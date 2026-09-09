Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89F37C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 22:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A2A16B008A; Wed,  9 Sep 2026 18:36:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553556B008C; Wed,  9 Sep 2026 18:36:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46A2F6B0092; Wed,  9 Sep 2026 18:36:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 238D96B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:36:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 09E45A035D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:36:57 +0000 (UTC)
X-FDA: 85195685274.03.CF434AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 228F7C0005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:36:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=krP9gce9;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788993415;
	b=e5rnG/ytqNaVDscJGyR76b3/oEJ8BkF9DHT/KYN9L0OMdJIkuW7iGABLEL1uIoA6xlipZK
	Kp9xaMTHE5dFNcer3m08dmLCq+Ov8MVAe2jPPsa+nzRsURtsm1ZNPvOdRhceAj0vVAXmM1
	Np1Jgz1H6qBFEXGtB93JoGohTfgEmJw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=krP9gce9;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788993415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G1qBdSpwsZDx9917VKBaeIKL8pVnAWB5+0VSGaiWxVM=;
	b=I/bNF2W60g6q+blVgUfeEnc2xfpRMy3YOaZd6u1LcAiibq0OfMn2frfeYXry2kqNz/jA86
	tzvI8GMHl93Ueaccph0wG8KLbv9j4ZINWppq0yS/Q/0tBkoeq5ELejIVGWIE04Rz0UvjEE
	mx4HmbdvNcOgpLdAVxyL/a2WPDS66bs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EE20943AE4;
	Wed,  9 Sep 2026 22:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AEB1F000FF;
	Wed,  9 Sep 2026 22:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788993413;
	bh=G1qBdSpwsZDx9917VKBaeIKL8pVnAWB5+0VSGaiWxVM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=krP9gce9sViQZ9kWxwxUg8BfupMM4UwEYvgfsqyijIDlIk0ZmOyYCe//9fsrdWYDG
	 Bzu7543h/RoNqhrtZsvqitKdj0M55aPL8JDjB0E6UxaOKnn5V7+UmwPP9MgOiTzIJL
	 OyQXxTggDoZVEOERpjqvZy0cxh7ir7csGMd3VzSc=
Date: Wed, 9 Sep 2026 15:36:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Muchun Song
 <muchun.song@linux.dev>, Muchun Song <songmuchun@bytedance.com>
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION
 0bffe67ab8a72b3725cc31c4b525709bd3a3e223
Message-Id: <20260909153653.9e19f1d1f61a080d5bd6d2e5@linux-foundation.org>
In-Reply-To: <202609100517.0DrzxrW4-lkp@intel.com>
References: <202609100517.0DrzxrW4-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 228F7C0005
X-Stat-Signature: jchkwsdrsjubuocyszhg8gaifc1b5fnm
X-HE-Tag: 1788993414-812910
X-HE-Meta: U2FsdGVkX18OMRR0DvTMgQbhesowtxcL3RxtklII2KvHA4+zMfBIKsFn7n5+H+gMKGzVlcFak6iWg+Vix59o0kz9+qg9Fu2+zYgK3oWksM0BGYaw13d6mRsHtdhr7m+L6Rs7bCyChagUJ/rvhAte/DM+tAeqw56MeFEcFHnDTwLRhEBxVqfduJpueEkknatQJ9HMT2+6RQqjDjV+TeXcGTxBvecigZnHXSziSlNRjaMSIfGglWX81cDmBW+LhgqlBjYC7JCn/RMJwca7GOMrl7tTXd2Wdk9bXyT0suSJY95nMfU0hdHDeT6S/qhWMoupsg3TtsYC7HQ04VrlwnxWG3bCx4CgXtviOND5DktzVb31slOZCG1Ev74cultcEsH5yVfywP89O/Jd0bURT6ybwOrMteu/Uaq+zElPjrNdwURyBmQzCWtncf4D05pCor51JOfBri86ZRuyGdg/7/DKkf/yoFIB+AENk9TkYdoBcVODgFQ/vR+Z7200hnlxP61HfzDcrz95TESA9I8zD1UC0tEOnipPz+Ivm+TusOCUr7mGOLI+uZ6fGZRPsnEEXn//JFru28uISUV92MvtZK192zFKvbJxUThp30K5SAZ7crLALk2EBIx/NVht/OIi9HueAyETMnUIS+4ZE5ba4d23SxfmnMmXu8WlACEXPXuMKqhfdEK3B+Q8uYTkRVsafuhZOxHsYs/Edx92wrManzR5unHU6smT+NAllbZWj3wOrZmFqLHTCbbafwVzQLSn8ytj5WUDltejSTTKBQkJDEBGyGgTT3pJ41zfBH6pwHX5CchQ722JpIbdwx9wqHOcsoil7SP/w8HkjY2kuJGUtoHohxScF3kv2Wm+EB3OCTty+ZZqVFXQPnx6TCFOjDkuM9KUpt1uGwaBbrskKbBNjtUUbfiTlzji7baTT/uUMvKs/0oqMxCDx22RmfqunC5HzX0L0x/sQrfKwVGdhyedF8h
 AchJDy+t
 rQfALbp12wx+BvBipQRxiBgwzMHdmpg3h5ZStzbVygkVBkD1r2OgCEPczqIQDotIHyq5lA00kEubRquIIJfbbgSgpVQs2dC1OP/fXGWwkbTx2knDScuuhp4z3eUfRUraahQoe3LUZkgQLdH6MmH4l3DcG00e72eioqI/iSFYGW4fiwJ7Ge+f1UrSaAs2Ry3eFSGUiYiEeUx00vQhldMccBwqZyDl5scfPSLtwRf0HPa7SUe77CvEANoV09WEcKNe/QPR2yZ9q8mpRCs9tpY6DNNAjccuVhE46nhEhQXNWcMst3XY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026 05:56:22 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: 0bffe67ab8a72b3725cc31c4b525709bd3a3e223  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Error/Warning (recently discovered and may have been fixed):
> 
>     https://lore.kernel.org/oe-kbuild-all/202609100351.ALNh2KwC-lkp@intel.com
> 
>     include/linux/mmzone.h:1692:10: error: call to undeclared function 'NODE_DATA'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     include/linux/mmzone.h:1692:26: error: member reference type 'int' is not a pointer
>     include/linux/mmzone.h:1780:35: error: conflicting types for 'NODE_DATA'
> 
> Error/Warning ids grouped by kconfigs:

Thanks.  That's Muchun's "mm/sparse-vmemmap: switch device DAX to
shared tail vmemmap pages" not liking CONFIG_NUMA=n.

I'll try this nasty thing for now.  Muchun, please make it less nasty!

--- a/include/linux/mmzone.h~mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
+++ a/include/linux/mmzone.h
@@ -1687,16 +1687,20 @@ static inline bool zone_is_zone_device(c
 	return zone_idx(zone) == ZONE_DEVICE;
 }
 
+#ifdef CONFIG_NUMA
 static inline struct zone *device_zone(int nid)
 {
 	return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
 }
+#endif
 #else
 static inline bool zone_is_zone_device(const struct zone *zone)
 {
 	return false;
 }
+#endif
 
+#if !defined(CONFIG_ZONE_DEVICE) && !defined(CONFIG_NUMA)
 static inline struct zone *device_zone(int nid)
 {
 	return NULL;
_


