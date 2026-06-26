Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4774AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 14:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130DC6B00A9; Fri, 26 Jun 2026 10:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108A36B00AB; Fri, 26 Jun 2026 10:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 020016B00AC; Fri, 26 Jun 2026 10:47:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA5AB6B00A9
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:47:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 429B5404D1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:47:15 +0000 (UTC)
X-FDA: 84922341630.16.166D039
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7CEA7C000A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:47:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LFfOHfxm;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782485233;
	b=hWgCm37I8sTV9NfyPDi354NdIbX/NAtsKOawprNwFF3B9TYYEHB64Ty9tYsefkD/LTy+UO
	+lk+30EL9mMGPyAuzkTwlX04eUseOLA0/t6em9HNFI0MUg31tlE69TRKfCnB59aoK9fGTe
	2Zm0iDPJvafnB1jePjQtUTPJSYAKIq8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782485233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ki/UMMGltgdJJNZZHuMQ1eeElpSKdZAz+X4n32ee4Sg=;
	b=7aUDS+6rcZK2ybIkr1UlUH+MClePiToHPWHsYVtFfQTZ36ZdBFbIz4ol70YuBk6SOCuitl
	SseoAyRsp9v3THdD2wa3T1BNqR6IKwhOecPti7rzD25i7N8jQjSZXf9I+CaCiDMmVKWLko
	ilNMecKfB/VUNkm3DivwO8GqzBSeSkI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LFfOHfxm;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A78A600C8;
	Fri, 26 Jun 2026 14:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097211F000E9;
	Fri, 26 Jun 2026 14:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782485232;
	bh=ki/UMMGltgdJJNZZHuMQ1eeElpSKdZAz+X4n32ee4Sg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LFfOHfxmieWWkk8tk89ez8N+O1bhMB9T7qUnxqZ2qRIFn0EXrSyZjFVdAPJGRZUf7
	 aUl+5F8ltNbv14mjQOGGNfskrEJXWjMjLlbIlpnku0K73bFPqXeFm4Cl0LiFZD2K0Q
	 DQ8NAnFpsWt8puQqsQWc0A8f/brOsYMyJ0sB1TlFAB8HIteCwilzvtxRNBmZKqIZX6
	 o2PIGjXmOoHTjOeAyB8bRO4jiEwAG3q1z6IkJ48GpB6aLQmC9HjZXOKngpnUorG3nk
	 JGeFSNvyheVWSoz5e2CNekfye0rint6Ec2qaIiGna18bMOTjqBw2c9fnP3rhHezDba
	 FTgjP3GD6F+iw==
Message-ID: <511c2e7c-0305-4917-a639-e8e9e8710903@kernel.org>
Date: Fri, 26 Jun 2026 16:47:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: pagemap: fix flags location, member name and sample
 code
To: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 corbet@lwn.net, skhan@linuxfoundation.org
References: <20260625174447.24292-1-zenghui.yu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260625174447.24292-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3smnixxt6hitbnc7k8knf1ksyhybgsc8
X-Rspam-User: 
X-Rspamd-Queue-Id: 7CEA7C000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1782485233-285944
X-HE-Meta: U2FsdGVkX1+fayt5GJgDy5wvuy7XBkqyRKpgZKOp+Smasq3GMYhtLvD1ReaiFC316cVHjjtFr1Yyv3Nkizp3qwL24XyGUgofK8iANTDKO6n4bdKjRx3DvHI7vbkuebi1iTHqg3gFsAL7DPa/I94zw9yN59HlUc3rAHnU0cQxAybYZt5hYYn1DXxnPedCYFvOMmdpr9YI2eHVxyF3ui/yZNY3dzYTqQcLNsI96lWvzulXsV5D534+Wp2cYdBZ3mGPNgr3Uch+KKKVBUKgKvyCuXQNcd9L7PiwEODhO8a6r5zFyKCMxSo8NVP/lGkSVqoelZ0CYhOy3f8IuzRqETGWPe3z8toxOXVdFJEmgTadFqEEOwIrYxNL7H0ULSiSQYgpBIHfXOgVS2BNlK6te3PRWvluR10pz402DS4r+BV/gFtDzIcS5c6IArn1k1Uu3vwpaTCNTz0Os9GYbX+bvOj1T4OMn0fKujaY54UemJihNGamm39myYRY+3hsLBoRNZYuN6OTZztj9ePrNfVe9pa/iUPxo2oxnrzCqfKGuLHF+3C8gCGdyi2WiXCefX2oa0XU7kUTwJlAG9IIdeAITXHObzmwhJBSsAhezolwOciETxurBTJInGZzxW/9LjnKSL6mzuV1LR3WQw6B5oQOurWgh7wy9OTO0YmySUxRCxKrbvyxJxkmLQHeYeRbYLk8jcpK/r4+/w4eXNDapuhuYOZHt4DhDxfsQVDa8OTbCQ/K69Obid6v46TtJNmxATwjHDN8NHSSjbDu7QsqAGXlZX5gzlVQD1JoZBG8A4iSJG/DFc3Lc/L7UacxXGVj7iJijVUx93mlqbXjrZbGjC/pSlsM+TmUF4k/0wna1ijqemnIeqBVCenwCxtzfqC4xukVtKae7HW0VI0VFol4efuJ8RyXxzYjB2yyDepsQ3Ui+EmFipTCS2Qiq68n/BELze/7RFWl+mtvL9DIfUvT6e5+oRR
 Vv+3wIJY
 pwdvcxsWS7W8qu74BphcM3SRQ8LfVsUNLXuJAdRJQ9DsUckv1cIrEkmQXyAiSnHKA5wmKlyeZ1aeqp68+tne3EeB4tuNZ5uk/FD1egA6oWNuFVPDJKMWyikt+sMuD3NUBPpmN2NZfRP0ZAb8o57iY147QYcj8rT8yw9P/lNlqb270guMdQrH77SYn3P3/2Oy9z6CjR5Qp8hh3fRMQfBvr9Kb3UQgWcxBo5kpj+DQZfCKJni6B+LLOYcu2LKOP2DF3+AdX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 19:44, Zenghui Yu wrote:
> The userland visible page flags (KPF_*) were initially moved to
> include/linux/kernel-page-flags.h in commit 1a9b5b7fe0c5 ("mm: export
> stable page flags"), and later moved to
> include/uapi/linux/kernel-page-flags.h in commit 607ca46e97a1 ("UAPI:
> (Scripted) Disintegrate include/linux"). Upadte the doc to reflect the

s/Upadte/Update/

> current location of these flags.

Ack

> 
> The member @walk_end of struct pm_scan_arg {} was wrongly written as
> "end_walk".

Ack

> 
> The first sample code of the PAGEMAP_SCAN ioctl wrongly used the
> PM_SCAN_CHECK_WPASYNC flag twice, instead of the PM_SCAN_WP_MATCHING flag.

That makes sense.

> The second one missed PAGE_IS_FILE in the required mask.

Hm. The description says: "Find pages which have been written, are file backed,
not swapped and either present or huge".

But doesn't that mean that

it should actually be

	.category_mask = PAGE_IS_WRITTEN | PAGE_IS_FILE,

Because

	.category_inverted = PAGE_IS_SWAPPED,

-- 
Cheers,

David

