Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D09F3CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 21:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1689F6B0005; Wed, 20 May 2026 17:52:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13FFF6B0088; Wed, 20 May 2026 17:52:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 058036B008C; Wed, 20 May 2026 17:52:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7E3E6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:52:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B50D01C0160
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:52:22 +0000 (UTC)
X-FDA: 84789147324.07.DFA4F06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E216E1C0003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:52:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=duRI2D9v;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779313941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eIKsa7K4O8NMZabhQd1oNnXfcQVhGqAI3CF7zeqHVoQ=;
	b=htzlFWrl8Tg2gU7QEAjDh+s1TOl8fIVPbtnImy0Tsjdh0bWsxQcY3RQxunBZSZvh7p+E0d
	XhKpuCnSGh3JtbmUWR1ILj3dG/rh4wz+TqnrqQpPSTbJ3lzIE2fxG3qiXgeXWKcDIJO1T4
	S2EWvaKqZI0R5J05giavNmHI/m6S15g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=duRI2D9v;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779313941; a=rsa-sha256;
	cv=none;
	b=q3N5f5b34Qle3gs1hVrG4igiQ5JVwvdMcF5cCieLMQ4MOkb8gBxMJtHiZdJ3vR+vXImjj4
	yugZ2IKEe7Z/ZanaZw62qUtqRuqF3DZC3KXeuFdYI7J0NjREu/oljDIlMNcE87P2RpP5Fv
	vposxu8Gwyyqa/ldcelMp1XY8l1izsw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EBD3943DF0;
	Wed, 20 May 2026 21:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22CD1F000E9;
	Wed, 20 May 2026 21:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779313939;
	bh=eIKsa7K4O8NMZabhQd1oNnXfcQVhGqAI3CF7zeqHVoQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=duRI2D9vc2qdWL3wJt15sALa452j9YXPsqgLSzyOQ568/4wdRl2HsVkJPfHvmctUU
	 dbFddonLpmuvx4QMYNXa4McxSsReXemBKv5pYw+61MkDQp3mOZnIwctBEW+gIfAKOe
	 lMsftvxhDpKVgm5maFSae/4bBgJEsw2XbioA6gauF6q8DFoowpbQ1VaewTnmDzoylx
	 6AxJlDl7hDyAqxRd1QdCaC4YQMs/b4Hj4cHOzWCwwy8k/S8zur5EwRVN2ejKGsUnd1
	 H+ZVa/qOGAO012/upjv8fEpBZx5LC+gbFy25CPynMsDKqaD9bSraqQKUZAk6UeqW8m
	 VQUWQ2EGdVhTA==
Message-ID: <9c0e3e53-d284-4675-89d8-943f93436e07@kernel.org>
Date: Wed, 20 May 2026 23:52:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
To: Juhyung Park <qkrwngud825@gmail.com>
Cc: linux-mm@kvack.org, stable@vger.kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dan Williams <djbw@kernel.org>,
 Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
References: <20260519151008.1399226-1-qkrwngud825@gmail.com>
 <e9a08bed-3d5f-4606-8d17-80a16a4c82f1@kernel.org>
 <CAD14+f316+wMZNm_sJF6ULRDUD9EbkdecdDwhGQKcsu70Bdp0w@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAD14+f316+wMZNm_sJF6ULRDUD9EbkdecdDwhGQKcsu70Bdp0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z86tj9tk1zwtd1dsm1spddznhxtykpnn
X-Rspamd-Queue-Id: E216E1C0003
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779313940-237729
X-HE-Meta: U2FsdGVkX1/uDtFF8bh/bim/02APYwf5yPVNKpk9sdYNyYz/t2HjMUKhGcciIjGZqPipsZ6jabeoPMVHW7pUSOtv9M+PMJBTCuVc+d2wpnCnw+RqfXjFbra6xyu1yJIW5/HYC4Xgknbx1A7tUZRXEhLvpnDY9nKYBwevLSYE1YT9FkwsDMPDcty2GF16e7EMIjdrvgyBjOf8lI2pOiSiC3QUh7mUcwpkvEjy9ld4xj2bApFyE5CRsYluZcfBHhfQ6ZvgbNPeRwqBl0pVyy9xPQUzupzKCzNuMjNSK8S7byxouE/zv69jA6k8s0jg+2jOtQBtIjRShFGKReuimR+boR/wg3oyIJMY/jw2LrhRnrhZn5o7NxvKB84xWxae4QyqUypaBhKlcKEJ9sFnB/ocyQgZmRM+XlgW5JzdEfp8SjARB2L3BxES+wQN/YeWjV1Yfcttk9WPdU4KgbKS0Z7XJB4cJNSih+lW1DCt5lFpulfN+AXcMcbcA/H0yAiQgQpAmIpD86SMRjqJP9X19QrTM1Y6SgMHUvwxsJrBe6a3Nur/jv7JAiO2+qrrjoemk8qcLqzLFBHPCZ2namAxXUk80qGbnk5CFuUeZe98+cXuOly9085iF5qH4qmdipOQGUMI8daD4+gZZHNn9IctMUESgbfWYQNSaVWqM5+W3wVs5OKtoDTvj0KYffncC4jX1sFaGhAtenohSc6RVSoPorM9/lPrxULC0N2JuiOVl/ujhmPjunb3xANOskkwwNW/wQmy2OZi7jKNzSEYJ2bAqWLAQhmjunA/o0NiwnJhIO5TGZvqoiWF5hcX56LZQgpxzgezfraNE2AuqybZaCnZO8oOy8hSbtJjtyowWq61YIIb3kSroO64AqhpaSlrT0C5X3Tl/78J+80UQJGiOXSl28twuHakSuom31yk7x8mxztSWu6oUXVkcM1fcoiyFzIRWLujZmtmBRvPb0NPVEfjxG5
 QMzQOAJj
 nK6cIw9NFJTeid37G4dcPA8WiIjGuw1PMKgxlmoAZHd+M3crkTYPijHzbqNIhMQH4JehEYaIq4PBxq8ophoMccFyiERrc+Aizq8VTQ+yJwr1KJmXe5dQnOnVOLk9OJfXkB8IaK0cHhcq8+J9gX/dvryDC6dXFriN/ziFU8i1MMebZQbyaisGBN01kcWWKxUxyNRqqCANLJA2C6mBf9RWXsIDq8F7A1ParA1+ws3wE8Xybh4tz1JLx+EzOAHFZd6GjzL6i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 12:33, Juhyung Park wrote:
> Neat. Any sign of it getting merged?

I hope it will catch the attention of more x86 maintainers soon :)

-- 
Cheers,

David

