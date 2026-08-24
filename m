Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA5F3C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 08:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 976D46B009B; Mon, 24 Aug 2026 04:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9285E6B009D; Mon, 24 Aug 2026 04:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83D0E6B009F; Mon, 24 Aug 2026 04:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FBF56B009B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:59:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D91A68048F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:59:43 +0000 (UTC)
X-FDA: 85135565046.27.D5800F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 444D6180003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:59:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JVvZjDTh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787561982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ji2vpfR47EINYn5xjrH8sS2a3J1UN2IFPpRZaEnaMsc=;
	b=0ikpH7l5QXF9gZId9yTPlG+ss7+6FxMrpthC0MZlx/EwIPOek4IU345LG+yIUmxmHFvsd9
	5ppnPHqFTxdl6paylQfOqFBa5zVJygX7XywCLvJN9Z6RheT1Xk/hjNjHq3eRkGYwypOgS8
	jwAxjVfmgg7O/JHr8Y+4+DY3GO3dFQI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JVvZjDTh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787561982;
	b=htYPp1dC1k1Q6HVhSXNF3Y2Ftz6Wg/qp0/GVc8cnhiLrp9pdvGmyNu0oGXNfYnpHJhfdJ8
	OiD2mTdpAmbvNk5hhspfLHn/GmlqVLs4NV7jY4aY+ioPkV9AJQIJyXWC4x/vzCjz4REzDq
	6/meqy/stBg6f6kcXbN8rFO24O8krAA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB3646013A;
	Mon, 24 Aug 2026 08:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808511F00ACF;
	Mon, 24 Aug 2026 08:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787561981;
	bh=Ji2vpfR47EINYn5xjrH8sS2a3J1UN2IFPpRZaEnaMsc=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=JVvZjDThZwbJa0rNcyqYN77C/BWmXlTmM2KS5jcvibN7oy2xCsYkXatZ1j73jwwc+
	 GJKrY3A3UolQXfBB0HrKnhAL8rTX/iU+/wc3aEfmI71KUzIkIdww4lbrA1yT4R2yI0
	 8yIKN4Ald1t5h/XUeZ0uMfh2NDf7Vpv2cZ85o4DFkggBmVg0jsiPiWxQORLeBWNb19
	 SanmaJ6d/hW3eLylg2Wm2OsZTMi6MLxrkI7k99dPqsbHIG+vRqzCl5sjNLAF+Uhkvb
	 Sk+TlufUCPnP8RLUnMiISZ/Q7HhrG9x7/1hdPtVm2/y9cjI3evGlEPAsQED9zwRnTT
	 LKqOAhiR51O8A==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 07/17] mm/sparse-vmemmap: move vmemmap_get_tail()
 before PTE population
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 David Laight <david.laight.linux@gmail.com>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260819095140.17252-8-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
 <20260819095140.17252-8-songmuchun@bytedance.com>
Date: Mon, 24 Aug 2026 11:59:27 +0300
Message-Id: <178756196749.3606540.17797657173492059130.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: 3qw4kyqgc3zh4wyyufpgqkrxawhpkt69
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 444D6180003
X-HE-Tag: 1787561982-406122
X-HE-Meta: U2FsdGVkX1/KPUZmJDegqjEVniUKtqtaMHCiSZ+1LxKRa6dWbCH0eDUvtUSYaar3aq2DweBONopaiudszTWBr9oBx+enOmX+Vsa5ds0dkd4mEgcIEO7fiYjpL+DW59L1HtVh/6GTiPomTinXH1KkAj2AjvqCozt5TMbvbAcanqHUXO+1DJAXWiyoTbY531vrF4rkcZyasSTZbS3qoqCKSNLL9XLEbF3N7b14DQ3vvGkm0NIiOhz/b4yjXKgfQJA/Y+imL+fe/DCvAD6aJt+B27e+ftrw27N1yR338jSbcrjJE0g79BHcfNn57K9/BAiG0JE6GNUAsCbc0lWeaV5e0oL1YZDm47xL4/YXPIgqAscnm1zCkkEW62NAal8Bo6Bn5bBkLMxRVU1QiRuaElbWtIlJPa0qRm2v3eY0I5xJgaSuYJlpN5IkUqm0SDJ4UiPI/+kGcNQutXvP3PTTHhVfQPdmGMhQcET1vfcsrY+upiSbIfUbDlxChvKyIhnz6+e2iLxzJWp7LHwJ88Yq8pW++JYixUD/ZYPeYJvu5eGaEseyFbHxz7kqYp7bvJSmAqnCc3BbDqgsF0rG0wMj36fyGviFWpuPe7pEmu+a29o4gErrPrhebgeVESgU4JqULbs2lJj6ubhosdmRHPMNRdKQDdbkPUEEJt2+LHaegdF/wz+/NKA1Fb7Y5oilbXDMcIbXPyhd36EflTwOJNR3RuagU9eui90v9AIZkynwUYTlBzRxI1ZU2xPypyjLnvuoJFwPU6IsLi93Qc56qRtC4xehDUx83mYCY/kU/wxNnebM7jaqiHZW2u0JvKy3RC4MRzCCisgXBwarp2rt1DepfiHBFVftUgR62cmUrfuE+bOKRL0N/Sq7sUsZi8MakSLIapNuQsbFBz58NYq01U9TD69vLpkSeKvj4jvx3Sb3wExLa8WQjNupDhPMQl77zZEbq6ng6aBbmTlsDKYURDlRbmV
 3N/4TC86
 WFu+Yc6kuxjSsps+JH3G5r3SAMfUhbUwIqQqXOhF/N4IbJbT+VBs514kG5Dy/I4EWrsY9wyRv47e1Jn+Hx5a63Jl0JIqbLwhTntnl9CCyDbaZjv5Z1koI5MiOWKHz9eT7EI4C6KVQXYO4hyqDKGJypbq0GALVp+PHxC6Nd0K4JVQ6074zGH7zs5ddBfKF2XskEurx+ROQdEfRLoPJ5shW+o+UBLSJmq/w/LOSB/xB4YTTLgAXhPrgyoENDUhLLYjpWzBnFFI4Muky9s1wZPkwiG3e6yfIC68BiBlrZ79OchJ6ZPch+dosy1BxVn2a5+ehDpB1SsSv62nMw5xqCFd+RApQpFg3rB2cVWFYLdPBti3ML998MnFKD35C6VGQjmOVm1KDpds+wXdhA0m3qi0DoCYK82xuL80w4L5B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Aug 2026 17:51:29 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> A follow-up change will call vmemmap_get_tail() from
> vmemmap_pte_populate(). Move it before the PTE population helpers to
> avoid adding a forward declaration.
> 
> Move vmemmap_alloc_block_zero() with it because vmemmap_get_tail()
> depends on that helper. No functional change is intended.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


