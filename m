Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F220C61DD6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 16:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5367C6B0088; Fri, 28 Aug 2026 12:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BDD66B008C; Fri, 28 Aug 2026 12:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD216B0092; Fri, 28 Aug 2026 12:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16BB66B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:54:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C2D1A3F02
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:54:14 +0000 (UTC)
X-FDA: 85151276028.07.9134141
Received: from mta0.migadu.com (out-221.mta0.migadu.com [91.218.175.221])
	by imf05.hostedemail.com (Postfix) with ESMTP id A2A3210000C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:54:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KMWLw46O;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.221 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787936051;
	b=5Oux5jZ4iZSl6m84p1RXgtIp8mt20LC1rSmZ2WgQkR8FCERuoC9m8+d0pOUpFMIF7N25y7
	JbfN/g0aZQpUzWUsNJ0GZhTZphhzpnRZ4fJ3G5YehGhd8pj0R4DgqqgI9Ia80EMNFPIBW6
	F59v6hXobsFM7Q6A8G9eAJvnonmVJMs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KMWLw46O;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.221 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787936051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8VuU959mLcIyuyMNgmVKSLaRTObzAJRt0JWSsrWb4lc=;
	b=ivSvUy81RPsv1OR/pUEs8cr+1pOp54yG4x4BW5uVSy3Xq8+en5aBUQmaeocaeXo+G1tKhr
	8Hzge2GaY2w4vA2zZJBmOB75NHPNi63lNiQGpWOm6kY8loH1r4/x3ahAC+aMIteBPzXipD
	idbiQp/6c3Sb1qjADW/auEc6xK9Oqhk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=psJGwL1+j+jKt7s0yptB6/W3PUUi95PtS5n+HITAWyc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787936041; v=1; x=1788540841;
 b=KMWLw46OnClM4RT7i00HJSzN7lZFpKGoDxoP9mv7bV9IjQJrEBa+KRhkvUfg/PuVFI/A9M3Y
 2jxgN9LOTBrlm1buMQwNnwQBDC4s5i5FCLuEn5sjIpL0+C8mC06z+0dJ169vZhVwY7Wz2IQS01I
 BLV1xK7o9NKK2RKgJRs2TPmQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4322b439f1cc1ba4;
	Fri, 28 Aug 2026 16:53:51 +0000
X-Mizu-Trace-ID: 4322b439f1cc1ba4
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 09:53:50 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, falemi@asu.edu, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] refill_stock -- VM_WARN_ON_ONCE(mem_cgroup_is_root()) from
 a write to the cgroup-v2 root's memory.reclaim
Message-ID: <apG8lKU0xDitsvV7@linux.dev>
References: <CA+0ovCgWzUMK+nNbbtH7eV65Ca=fDN4Ozu7iASgryjvv8Tk8zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+0ovCgWzUMK+nNbbtH7eV65Ca=fDN4Ozu7iASgryjvv8Tk8zQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A2A3210000C
X-Stat-Signature: c18ht5yfoujqxcuu6u7eg1rnbdjz61hn
X-HE-Tag: 1787936050-912153
X-HE-Meta: U2FsdGVkX19ZAyUMWm0bTGEsR1ySu9V4wz54S6nC78yTdOlu1hwW+FZzxqf1xc5IMyb6MmSVOKlaJNxhesHvVQx/NHElEaDD7qXsteJfpOA+MVPSJ3EMAEQWbeooU+uZixa9pF45Yru4827S45S8qyKV5VJ9bUziF4vX3ig8fpTnKLjgoKL53VjfsK1hRRFMeSieUxlxtwHfnc7HCC6Hq51gzXQGayMAWZ+/axve/gZrH/Mm1GFftTXMmMIbzk2RFC4Db5ndLFx88Pm8f5fWFh5gppPx1VK60n4+AK0j1x2ZEXQpTukilbT1zYC3Q/CJl+XEuT3Qs22IPuo6FCnLyhpySBokyqgIKqSP4cNPOMDlmbyGw6EcUCR8cCk8Ey7YWFtMTPqWwWV6CGhwfypJZo+oVScibi/6Stm6UNwSN9EOtzko5cgrf+wvHYVw0d+3cOFCHpELqYAqv9t/Fpla6BKjjoUa3M9HZJhSuthr8PBjkRzBzOBkWwoHVX4g9DuYSMmN7hzFiaK0FnuOF4OilHTCz4/+VvhFUP+WPOiIoIdfehJ09Yq9Wf0kfqag0lLKKgmevLgXNQy+jKs1K4d9f7kb8hNumkToWu0WwpHxjwieu7RS9v1hLd62lyrsxBW/fX1ykzs9zuMhXiSi/b3yxuu8QXfxaOCKHcX++JjNsWke9rSZAjfBs9apHpnxDbyFNl81Oyq0WqDAE853hQI4/O35lSK0OQK5B3/QxE9XDnEJYqH+9keykRs3U312s0scpfVk8+q2paq6IAxhCD7YzWZCPwiK8fslN/sIopfkHLEvN38Xrmpg/sRnCCHaB5I2PUWlUrlyuIqS8DP8CFYB3ILYYavg/Dyvtm8dgLgPZaTOgIoXdnbPbN6YmFtGrfnPnr5/CetHOxC0lz+D/aULaNAX/kcHk6mFMeNrrdXVbvZ04SFTq+qPxRMUtYc3ZREIsiLYXT9MtX4XMlhmwGc
 7fnotkAw
 zG37Rny8R4JTWt8jci3DUrFR9/ctJ/i161HW6tD09o7jlBBlccpkEjrbEoUGwH5KX2SVXm4lWWt+37x0Skuq+N6bngdG7m4RxD5H4/BxOH66NKfH3QtGKyKo6RGpWHuVQ/vX6kNyjQ2PLJnugup9Mce0+/ojQkBE64+lSUvXUlA0YKySXttfg4M44FM1xq6jZfTHhKeQMMnVMk+SX1AcTum4gujzo9Zm8eSnz7PMrHUNIWDR9kWNSKMgi7wUVGBwDHk4jLUPkHQSPoJxXID6S/u2LAIog9h7e5+or1i4sqhaqvl41GyIh+woj/mK3NzdXqQgYBBx+0SXPyyj3rcwfGhYdiFGIts/084twmeRhXFGrNIlAzdCeoVv8xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 10:28:57PM -0700, Farhad Alemi wrote:
> Hello,
> 
> As part of the kernel research at ASU's SEFCOM
> lab, we hit the crash below. Crash reports can be found here:
> 
>   https://github.com/farhad-alemi/public_bug_reports/tree/main/145-memcg-vm_warn-refill_stock-root-cgroup/
> 
>   mem_cgroup_is_root(memcg)
>   WARNING: mm/memcontrol.c:2198 at refill_stock+0x644/0x940, CPU#1: repro/9490
>   Call Trace:
>    refill_stock+0x644/0x940
>    try_charge_memcg+0x12d6/0x1570
>    __obj_cgroup_charge+0x35/0xf0
>    obj_cgroup_charge+0x1de/0x210
>    obj_cgroup_charge_zswap+0x83/0x270
>    zswap_store+0x1620/0x2000
>    swap_writeout+0x94c/0x14c0
>    shrink_folio_list+0x3388/0x52b0
>    evict_folios+0x374d/0x48c0
>    try_to_shrink_lruvec+0xe72/0x1350
>    shrink_node+0x3320/0x3b90
>    do_try_to_free_pages+0x6a2/0x1990
>    try_to_free_mem_cgroup_pages+0x30d/0x830
>    user_proactive_reclaim+0x504/0x840
>    memory_reclaim+0x1f/0x30
>    cgroup_file_write+0x331/0x8f0
>    kernfs_fop_write_iter+0x3af/0x540
> 
> Our reproducer.c is available upon request.
> 
> Happy to test a patch if that would help.

Thanks for the report. Please test the following patch. I will send formal patch
after your testing.


diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4a18ee4509ab..1709ac96bbde 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3157,7 +3157,7 @@ static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
 
-	ret = try_charge_memcg(memcg, gfp, nr_pages);
+	ret = try_charge(memcg, gfp, nr_pages);
 	if (ret)
 		goto out;
 


