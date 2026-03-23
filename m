Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 220CDEC01C8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:01:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BD866B0005; Mon, 23 Mar 2026 07:01:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46E686B0089; Mon, 23 Mar 2026 07:01:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35CB86B008A; Mon, 23 Mar 2026 07:01:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24EA16B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:01:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3FE6140AEE
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:01:42 +0000 (UTC)
X-FDA: 84577037244.09.543CA56
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id EB90AC000F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:01:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="h/52kMqm";
	spf=pass (imf22.hostedemail.com: domain of 3kx3BaQgKCCgNEGOQERFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3kx3BaQgKCCgNEGOQERFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774263701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fw594RC7Otx4FzA9sHEiwCzrolkTaDAMaFwy+wBrh1g=;
	b=ZSBVWaCx9vAPFUs0FYTfNZ4+vMxKAMmhviCwJnejY7SY1abh3MuYmCBvCM7yFRGBrLeBBj
	dZ0wjvOr+/DQY8Tv32p7liYN3CnRoIFeSkfvrJwSxMRGQHNRfsT1fU58Av2IhfAtPZEQN6
	bahEW6wJK6d/DkTsmp2ZAM8SEq4FPDo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774263701; a=rsa-sha256;
	cv=none;
	b=QF6nwgTIQiRH/Y77xqQL7NP1xue+aPOufO0V3UqNUm16Wha+HVW6tpmMNVMKik/qcKdItV
	dGnAbuIDu7JH8EphDCmTuBbUkObwywevWfwxiGE7LOaLpYMLGeYBLNtNzTSbZHvxQMgbgP
	pcYtqYz+R20tiTBXuwIqVjHM5JUFfSs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="h/52kMqm";
	spf=pass (imf22.hostedemail.com: domain of 3kx3BaQgKCCgNEGOQERFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3kx3BaQgKCCgNEGOQERFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48531e6012bso59520215e9.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 04:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774263699; x=1774868499; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fw594RC7Otx4FzA9sHEiwCzrolkTaDAMaFwy+wBrh1g=;
        b=h/52kMqmtpsE37/ORKVrKOan/sXLxlrQSS7zpf3LmfyY0f2J1jskrK3J5hwWgW+aIB
         DDDXnqDznrSsXhq/ecLXK0G2uiTdJB4Ist7E7KE12jZ1uhHQORRc3PQtk+OVyCsueJz4
         gQEQPm3lfpkarH9tSgVkQCRm0lqLytrKGcsZiQu1ekG/cNu1g63Tx5sBqEiJSpVaZEfE
         fAWd6N9Ltn8h+psFVeEStcVg+mhuuhyes4wJTm5eBCwI/kZQ6ZHddRIFBAOFNxwXG8V3
         QjJ2oRUjGUFusBwzKCSRAwBW6hrhtLtSoTPAYCiDeqnIrQlsKV91lHn7UMgjYQxsTKKv
         CwLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774263699; x=1774868499;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fw594RC7Otx4FzA9sHEiwCzrolkTaDAMaFwy+wBrh1g=;
        b=IZlp/P1KqRc5OXs5VESG6AThK2dgeD4gApS7hFrs+uwHWV0iOCBOYsiFmThdeygAEj
         lKXBFc8/soTXlT2oZGJ/qf/V+LHyLogBnwZHya0UFZHSMO7G524PNh8y6d+lJGqJSTs8
         VaC4QJHCted8s6P6cE4XfnoOWKAI85rVkd27YCTpOPsGsxjMz9iABKHQGvLDaKsRiO7/
         fXBytpVd5su9reO4DObIeZW2XKvU8rTp8WClgNtg4C9kxe7Xk0R0rHp1uLfvfPJrEYbS
         0VgLjyYgjs+8lxAPDwwjXM+SZ3gu/+caA3KZn47cd2U0529mSw7s63OU9Qb8ibcUv7Cf
         cV1g==
X-Gm-Message-State: AOJu0Yw4qcg39tIV/4rwry2Z1noi1L3dG+u7s7WtAnK8pwEEnlVifG18
	jUjBOcMAbQ1VkOvJrGR5m/VQjR9Eu3AV1yQIqZKd4W2TfkYy06qknsdO/3D90GW86wsQzsECYXP
	b6EmxI6l+jY7VQw==
X-Received: from wrrj9.prod.google.com ([2002:adf:ff89:0:b0:43b:63b2:2d6d])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:348c:b0:485:39b2:a47c with SMTP id 5b1f17b1804b1-486fee1af1cmr140778235e9.25.1774263699152;
 Mon, 23 Mar 2026 04:01:39 -0700 (PDT)
Date: Mon, 23 Mar 2026 11:01:38 +0000
In-Reply-To: <554c886f-6678-4208-8566-15aa140f6c4b@intel.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-1-28bf1bd54f41@google.com> <554c886f-6678-4208-8566-15aa140f6c4b@intel.com>
X-Mailer: aerc 0.21.0
Message-ID: <DHA3ZMO37B70.CQU1ZZE21C3Z@google.com>
Subject: Re: [PATCH v2 01/22] x86/mm: split out preallocate_sub_pgd()
From: Brendan Jackman <jackmanb@google.com>
To: Dave Hansen <dave.hansen@intel.com>, Brendan Jackman <jackmanb@google.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, 
	<rppt@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>, <derkling@google.com>, 
	<reijiw@google.com>, Will Deacon <will@kernel.org>, <rientjes@google.com>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ydms3mmhcs1sdrstxr3wsms4mydq1eip
X-Rspam-User: 
X-Rspamd-Queue-Id: EB90AC000F
X-Rspamd-Server: rspam12
X-HE-Tag: 1774263700-493619
X-HE-Meta: U2FsdGVkX18LzhgRuoFERYdugeGBe6GfdIghIThrhPumevaDQMpqX8XSCp9QyEEb6wVRkNTRwQHWKGn+qyEAlMLT/HP7ZVEgS7AVOdIUVI8CVMlSYcnLb9bCuxeIEF3N4PYP7nGmrt+CgLC76ksFNTa9fCFgNYSiEd+vekcedmmENT3l2zYR/TKjme0UM3OyiHBoG+qXFyAqSlT32gEiR1BpHoWfEYltaolmS9hKVthYUjiL+YOr87wMxhCJFcyNY3fZIwJfbf51GfszhpmtXhrEbSI9N2dJINXhcGaM6IOXu10P+D0dwkmz2CGFFYBQnTCYu/1CAMHzGgs7gV2LmdKpnel+MQylpgWb78k6qD7uZLIVdq9JZXUSpv4zlni8LfAENb076tAz7XKZpxXZUlwBl/QFZjKn7rthof296OgylrdsmO+XFICmbjldmf9TxePAuhyrsVvoXPt4CZknQHHB22yI2079f7g7/YXiEwwhVf/QyBfouWnFcjxoHyBl8mjY0FhsIwUfISv7190lIiDiCizFSaaPzpTpKJjQav5hmXfpPgLA3PXQui5DOFgJM5eccfZVbrC4gXlE8dbWUA0fKEV+I1j1X/NinKBINDwq+XKVqkKgcpt2tdHoLdGEYIpYArJa/ZnWLCDwuNsL2az6y8ZSF6qRvZ+9S6w41O6i3dJuXKiVJAf8U+DVgLrluUn4bZhSPM9td5Ee6KIKuSLSVEF6Om1brQ8xbsil/OVO/GFmlonqJfX2wvJ1J0bLk4Pmg7xPRwjHsbG3nQKUo4Jn62Bx76PGdaIXc2OxGgQiT6euMkC/tcHyTzJ15MV5W7jsfz1CDdTFSAQomMAqSbI5atfMIPmfjpJmPcJbHfJHzOVDjx6/+vf6QJxnn/ePh+HBqDKxcB6FXZ/Ahr6O2+QH4NiyOVEHRQ6ku8wF3ZbkFccr304bp/imFzS5mFbx2xPtfVpmFOyGdlA2WXj
 jM9cb8a2
 UZyRfuBkKffgGEhYsRrNxiECOfP82NSGtplNw9XAd4lwO18cXPCj2IrTxCix/XhlEEJrBErPEHyCZ42czoyr/M6KJ+S9+OLtJr0uu5gE/tVnuHIYgEL+RPGH1GKvzsDaks0gNkslA4FgkdtwtACC2AimofD/pvwi2c7nojgd1eWh0ZJQ1QnBioalP81Xmn+HGtur6Lcl2XZQ5Yyku0ix3Uv5XStyS7ezBkwEKhkgoB9PZclVBN8A0YCGM0H0/Ere06X2lwwAuTnposmthAncvzLBxSB9Vj4kTVuWt5QLPMIMu5zYrq9mgehMYMna+e02084a4psnRw4wJIPRPTgZXvsieUSakM+8I+1Tp/wdlfRZFn5gWzTIGjet51DIHBQ+CsnQY1T+3NO5AUvv8FMd3+a0KJpkDMVNF/L4lfE1thdiqHSmO62vnbfTte3WTZv70LSHGub5jjdg0IU/drugnQKsPJaoOCHU1Xne1L9mc+k+M/n4GIBOYEbmwHxuYfe35smg5BJUVdtOGnli+i4dtMpyrHmnMzMteEn7ZLHfZanQURf03HhegsrovjGilFM6oN0ALqk08TvWFKPiN5QiFylGzdiQNUNaPXV0x4Jm/gmOHVUVusM0B1a7G7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Mar 20, 2026 at 7:42 PM UTC, Dave Hansen wrote:
> On 3/20/26 11:23, Brendan Jackman wrote:
>> -		/*
>> -		 * The goal here is to allocate all possibly required
>> -		 * hardware page tables pointed to by the top hardware
>> -		 * level.
>
> This comment is pretty important, IMNHO, and you zapped it.
>
> The problem here is that the per-MM carved out space is PGD-sized. You
> want to make sure there are page tables allocated for that space. But,
> if you say "go allocate a p4d" then that will collapse down to doing
> nothing on a 4-level system.
>
> So, this is effectively:
>
> 	Go allocate a p4d or pud, depending on if it's 4 or 5 level.
> 	Basically, always allocate the level that the hardware PGD
> 	points to.
>
> Could we put a comment to that effect around somewhere, please?

Hm I kinda thought the comments I left in there captured all this stuff,
but yeah I can see this is a bit of a weird function so more commentary
makes sense. How about I just put a few more words into the top comment:

/* 
 * Allocate all possibly requried hardware page tables pointed to ths
 * top hardware level. In other words, allocate a p4d on 5-level or a
 * pud on 4-level.
 */

And then just leave the internal one as it is:

	/*
	 * On 4-level systems, the P4D layer is folded away and
	 * the above code does no preallocation.  Below, go down
	 * to the pud _software_ level to ensure the second
	 * hardware level is allocated on 4-level systems too.
	 */

