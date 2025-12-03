Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30843D116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 09:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55CA26B0006; Wed,  3 Dec 2025 04:15:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533D36B0029; Wed,  3 Dec 2025 04:15:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470B76B002E; Wed,  3 Dec 2025 04:15:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37BAC6B0006
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:15:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5618F1604F9
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:15:14 +0000 (UTC)
X-FDA: 84177600948.14.67E0C76
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A0F881C000D
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:15:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BKs6zCBd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764753312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JTMwJ+1tYHTUeor0AokRkFyjJLU3Lp6uo0n8ouhiI5o=;
	b=tBV8qF1QJqrlU169y3buAHr2G9ZPjJC/DbQiq9UQvTgaAGcCE7IsG06gu0DZsSgmDxuUYO
	FWHjJJQYcFha7iaz5zpnSitf4d0fZNXRMIeQ6spYWJu1murJ6PDXGS8gdRFW9aZnGYWC9M
	vxgHo39zwuUIAkvm3KvINOvnxjyefK0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BKs6zCBd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764753312; a=rsa-sha256;
	cv=none;
	b=LTWS2VIeaFacZ0CgJtgVeKuqFsNMPNRfz9YMOh9TG8FyVRy1pocywMhbM/s0cguYorXv3L
	zdu2Bd1JpwDQZ3LCnbeEOVR1fT7GkmAdMcxvN21skOV1B6Y829/R73DsJMOEyySA7Wfyk7
	NBmv57zVWrQCx41wgi8hVlcw/O8HJP0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 14DE16019A;
	Wed,  3 Dec 2025 09:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065F3C4CEFB;
	Wed,  3 Dec 2025 09:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764753311;
	bh=GaDFCad7NEt89kxm4f2cl1q8wMHwQHh4HZxgOzMmDpE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BKs6zCBdwGPsyEPwcs1gEVvu5t2PJcOt+xtaio0LA4TKyf8lLFrd2/NiWZlIoXfOi
	 3z+wsZxhQX0ztsosa+/WOSjyaKs8E9Q7eMBuK6cGFfRKgif8lnujjVbS21YtkK27bx
	 Ge7tHzYiOEvrSFfu48MX8F541K4kGRgOh61/5PQlNcXKFY0mB3Gx9J7ph9R9g//nye
	 i0z4JnvRfZkB2YlYbEogk98y1YZUPv6M19fO9V4mGvmfHZO+zUFWQFeNrzgvK0azlB
	 fS19ls5f6wv6z04NQbn6QxcuEHEF8k+c0nUpfFCMe9oec1UcBqRNHqeG5Utz6u81Q0
	 ieU48pd8ECimQ==
Message-ID: <8b89bb59-6b6a-4a79-a571-e97b9ae5287f@kernel.org>
Date: Wed, 3 Dec 2025 10:15:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction reads
 lock-free
To: Gregory Price <gourry@gourry.net>, Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>, vbabka@suse.cz,
 surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Oscar Salvador <OSalvador@suse.com>
References: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
 <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
 <aS_0bgCs2qE0y1bJ@tiehlicka> <aS_2Z6ROtrxLQcRN@gourry-fedora-PF4VCD3F>
 <aS_4E2H5aJmSvWF7@tiehlicka> <aS_8BgwR3R_geayy@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aS_8BgwR3R_geayy@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A0F881C000D
X-Rspamd-Server: rspam11
X-Stat-Signature: fpbnr77f16dtd7a9z3h7eiq9p5tdnzd3
X-HE-Tag: 1764753312-504142
X-HE-Meta: U2FsdGVkX19heVJRdR2Reg3zL3WzJ1Uyrzdcuoq3L2VtUbbYJFQLP4gPUkafPVDVRJ3LZwez/xWEqvHc1yBhKn3k+c9lfUDIQMElzhtWs58pabCldHh3a8CpJhzyc0MVw+aiTasykuNnuRxtYGhsQWb+eMHsdWeP1kC3DeH4X3MofppHn/evtxWlirzd1Rd11wGjVvpNFGxITD/WVqXgTHgl1X5lv8lbrg+e7TA5hKXNLXXW/EiRZCv0MB0fzFWsL999t/TPuuYMFYayMk9y4ao4hKRWfWBHh9v6TiwsloX5SsqcTRRAmr8FnXkKyHoO8AcIjE3FZMjqMzOdf+JDj0iPM6+XNrDycHLZFrSE3UVp3c0yDyoA0dsdNeQZhJQ7+wkuNTDCvD3z2nXKhUKt1xOn4w0HhePYzzaH2A/3wfarEZNan3FIuQak2s3+vPd+RI/nMtShQ5hZfjIHr9lh5nvM1iADSXXft2v+COcPKBlF8q8RGEeGt5+ntlNkgjfNhWGLfUghghzccsDpitnDS2uI6gMBWN91vEKfJ99+LgC7qn02gzgFbHckwuEB1iDuFDueXIqg89BGVcLFefzd2Lx+JqBdI27Lu66OaP5kw9JZxEKyxHgAya8q4F0xPX17voyoNKiU8t2Ut6F1MUYWMtGTgNzL5zBI8F1Zfub0/BdRF+g9KKLNnSBUYV1VUWWq3mE5YO4YWGWtuEDmAA/pWqUUpO9qPGEsVvk4QqiS45hnj6oChs3/l7rHXAiezCK12MEEXR/YejrTWkjldX0cLlv1T7XSUVFsEB5FBrm21e34u4P8u4A4dQozNktVEJ2z5EG82kFHivAYmZuxvJGsmV33HwsWRNME8s7PwjdbGTEA/NLQcnFoN5ip6qqMVzPxdbYO0zllnySYGNzfWGaCX8n7/VLQi2p9FbwrCtfPa/hhvp5GzJ0h1Uyq62+s/qH2eKsG4z2TFVDpHg1PHKe
 4hL1EBlC
 9sS/QsoogFFXphrDc/SM6XhUtnXEz/+DyuHWhk0/VQtEuzdiPKZd29FrrNJR2I50piCEvXiaVfqVP8x5yr3q0a1g/BQEwBXb0ttZefZ+DDFb2hwztO7SFo0xROUxPFd4bpeHZ2F5xvEahFxGugIybVTTAzK/kiMUkqO6fWcInVCkh6rd8x0uGPoHR9GI+37c/JEv1H7IOewjXUPaKFzMvKjKEg/82ilaS8qefOAwNrlo9haImPkyFXmfpl7NmHELI9G6A4WC3FrlCxBqCEFgNnhMLkZX9qEwoJsBbgJj/lsRW8ATXTX+FPfkLpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/3/25 09:59, Gregory Price wrote:
> On Wed, Dec 03, 2025 at 09:42:59AM +0100, Michal Hocko wrote:
>> On Wed 03-12-25 03:35:51, Gregory Price wrote:
>>> 		if (!ret) {
>>> 			/*
>>> 			 * TODO: fatal migration failures should bail
>>> 			 * out
>>> 			 */
>>> 			do_migrate_range(pfn, end_pfn);
>>> 		}
>>>
>>> Maybe it's time to implement the bail out?
>>
>> That would be great but can we tell transient from permanent migration
>> failures? Maybe long term pins could be treated as permanent failure.
>>
> 
> I see deep in migration code `migrate_pages_batch()` we would return
> "Some other failure" as fatal:
> 
> 	switch(rc) {
> 	case -ENOMEM:
> 		...
> 		/* Note: some long-term pin handing is done here */
> 		break;
> 	case -EAGAIN:
> 		...
> 		break;
> 	case 0:
> 		...
> 		list_move_tail(&folio->lru, &unmap_folios);
> 		list_add_tail(&dst->lru, &dst_folios);
> 		break;
> 	default:
> 		/*
> 		 * Permanent failure (-EBUSY, etc.):
> 		 * unlike -EAGAIN case, the failed folio is
> 		 * removed from migration folio list and not
> 		 * retried in the next outer loop.
> 		 */
> 		nr_failed++;
> 		stats->nr_thp_failed += is_thp;
> 		stats->nr_failed_pages += nr_pages;
> 		break;
> 	}
> 
> So at a minimum we could at least check for !(ENOMEM,EAGAIN) I suppose?
> 
> It's unclear to me based on this code here how longerm pinning would
> return.  Maybe David knows.

I would assume that additional references will always result in -EAGAIN. 
Remember that we cannot distinguish short-term pins from long-term pins.

We should never have longterm-pins on ZONE_MOVABLE, unless something 
broke that contract and needs to be fixed.

-- 
Cheers

David

