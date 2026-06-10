Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D35EFCD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 06:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D60A26B0005; Wed, 10 Jun 2026 02:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D112E6B0088; Wed, 10 Jun 2026 02:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27046B008A; Wed, 10 Jun 2026 02:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B1BE76B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 02:21:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E34181208E0
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:21:56 +0000 (UTC)
X-FDA: 84863007432.03.3300B4E
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3A42040006
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:21:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf12.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781072515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rj1kq9ETBwbErly3UT33Ox0T/tSwNluIMj5iqfTLDt0=;
	b=Cgk5G21OVwwy11nrl7ARPPaUZuYPirrSMz0aNbVAFxcFXv0Bmrf/CAT0DLYygnL83aO9PL
	7DXK/gga4YrrS3P7tVVaVh+skWu4GDnxNYCgGgjOtwsQaiTHlP1SDYpb80Y6N3I4lRtcBd
	GoC5JhbHWrOUVkUPu6CZf4PhaER4Dzc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf12.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781072515;
	b=h9Ghom7covTwgOcH2+StUQ6nrOQhF3/0MieyyKOaXVF12PoT74KSKMwfWEO77QxrCT3Xma
	7CvZ+0J0FDoE2+vhGGAquLk+gjdzUBoAjoNW/I5SEZDylbLabwRt0PKrYqqRkiCSfalbNL
	ow0zx7nhD0ER4HETsoOPEFxW2ygjKmk=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gZwfL1B3wz52SFx;
	Wed, 10 Jun 2026 14:21:46 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 65A6Lail069606;
	Wed, 10 Jun 2026 14:21:36 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 10 Jun 2026 14:21:38 +0800 (CST)
X-Zmail-TransId: 2af96a290272a30-5a139
X-Mailer: Zmail v1.0
Message-ID: <20260610142138377xoCoUM7vV_7bXkEkruK-f@zte.com.cn>
In-Reply-To: <eff26d08-d824-4459-858e-277760fcb4a2@kernel.org>
References: 20260609124746153K8Y8tYI_4pNVKogGMdglR@zte.com.cn,eff26d08-d824-4459-858e-277760fcb4a2@kernel.org
Date: Wed, 10 Jun 2026 14:21:38 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>
Cc: <akpm@linux-foundation.org>, <chengming.zhou@linux.dev>,
        <hughd@google.com>, <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2OCAzLzNdIGtzbTogYWRkIG1yZW1hcCBzZWxmdGVzdHMgZm9yIGtzbV9ybWFwX3dhbGs=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 65A6Lail069606
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Wed, 10 Jun 2026 14:21:46 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A29027A.000/4gZwfL1B3wz52SFx
X-Rspamd-Queue-Id: 3A42040006
X-Rspam-User: 
X-Stat-Signature: 55ahhtct67ox8bte3ns49komnwa5a4c4
X-Rspamd-Server: rspam09
X-HE-Tag: 1781072514-496681
X-HE-Meta: U2FsdGVkX1/WR2yFEGhh6XujMriqGEWPEMfIWXGMBiCwf8NVMPvEBEmkdXzw7eFiEJ77FRWQPXqshKi4Qt9Cqoy5FGqU2EFyTqEtwE//jZL4NxMDv/mh3svS7LH8saNFZvO7BFnVDM4gYmTO4vM0BbcFj44wENIMcvFeXWJ/3a0+qfVSiLv+EqNgIKS/3VTS/iwAUl7wU3jV40CBK1Q3tomo8vdSdkW0AgnGAzkyCMctwRMp/a0JS4O9wtHwOy9/3S40WCXgI3Xs/UkZEZJ+aFz3auxRg28ewbhpXOs/89DakKlP+1dhrC8RAF5gH1y1bAZ6MYCpUh8H3Qqo53H7taEceUsgzP/D39+kMOtpyDufXaiwx8G5gZfJEY7C5U9PA+yrB33oom3CnRwL1l1/dkcW0QEnL8/QK8O1nBQtQYsXBxbaryYgnbb7bqkcxW+nMQ0uB+NeQoKRElIf7yg7vkN+hAcVcOyOC0lmp0WwyqnLtOvmqXn7L/bcD7qwKi/w/RseRFfECoFHklTIq47M7KSVj/jAnwIc1d0M4h/zd77u4QedF9utx9mQjBU8mU9qTZUE0OitDa6XJmV4ztWh3yomm6CoB4oDDJFstjlCtomK/4IPAlEZMTFUDHD++Z7M7AFB/UkQXB94L2q1pMTbmA2Xm2YY8/aGeP720ZTMwqzbn9camyPY0t1diHsMadPp/HX5D9PAoc/9Eafi61ZB7E4grQe4+QuDtdxaHmDZUPbLS4gTLZBc7G0WfIDW6c3FqjQ4DsapZZP/E0mI3Jvy1lhcAU8tmU6i3SDTAKozggmAXtlsS4V/w2eKpmcD0YcXjy/LAcpNFzGFyEEFP+pVGSan/iJik6qI0wqxFsprmCthWH7MgIlCb2wKcOwHpyL0RSzOkHYzDmlejwpQwWaM8RSWZFCg3706qtbEzWWbIbjIOWYs+wiY4/jfRGtK0Q/+5jZCIEgVsAPUXom8eTc
 k0DkIO8/
 Y3sU9CwqMa6EKD/F3nGbSkzRn+sjSL63PipMpLzK10wj2pzjNtVBiUe/9ZeIofqPMYzAnwDb8MqMClMpEY16JCdjEq/X4EaVZURYt/njk513c9/BJeLNCvw+anVGqE2+xHE0Wf2LjCvjRddTq/gxDSFYwYvalNlolV2Ce1OLLt4PmsIjD3qR/WEH+7Y3kV06LIPQkES/Q0WgaBFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +static void prepare_pages(struct global_data *data, int nr_pages)
> > +{
> > +	/* Allocate exactly pages for the test */
> > +	data->mapsize = nr_pages * getpagesize();
> > +	data->region = mmap(NULL, data->mapsize, PROT_READ | PROT_WRITE,
> > +			    MAP_PRIVATE | MAP_ANON, -1, 0);
> > +	if (data->region == MAP_FAILED)
> > +		ksft_exit_fail_perror("mmap failed");
> > +
> > +	/* Fill all pages with identical content to encourage KSM merging */
> > +	memset(data->region, 0x77, data->mapsize);
> > +}
> > +
> > +static int mremap_merge_and_migrate(struct global_data *data)
> > +{
> > +	int ret;
> > +	void *old_region;
> > +	void *new_region;
> > +	int nr_pages = 32;
> 
> Likely you should do
> 
> const unsigned int nr_pages = 16;
> 
> and then simply multiply it by 2 for the temporary larger mmap.

Ok, thanks.

> 
> > +	long merging_pages;
> > +
> > +	prepare_pages(data, nr_pages);
> 
> Is it really worth moving that into a helper function?
> 
> > +
> > +	if (ksm_start() < 0)
> > +		return FAIL_ON_CHECK;
> 
> Why the merge here? Wouldn't we want to merge after mremap()? mremap() will
> just unshare either way?

It maight be redundant, which was introduced from the last version v7 to calculate
the base KSM counters.

> 
> > +
> > +	old_region = data->region;
> > +	/*
> > +	 * Mremap the second half region to the first half location (FIXED).
> > +	 */
> 
> Okay, so we create a VMA and populated anonymous pages. Might be from THPs, do
> we care? I guess due to the split-on-dedup, this should be ok.
> 
> Now we mremap half of it over the other half.
> 
> 
> > +	new_region = mremap(old_region + data->mapsize / 2, data->mapsize / 2,
> > +			    data->mapsize / 2, MREMAP_MAYMOVE | MREMAP_FIXED,
> > +			    old_region);
> > +	if (new_region == MAP_FAILED) {
> > +		ksft_print_msg("mremap failed: %s\n", strerror(errno));
> > +		return FAIL_ON_CHECK;
> > +	}
> > +	data->region = new_region;
> > +	data->mapsize /= 2;	/* mapping is now half of original */
> 
> Let's avoid the use of trailing comments where possible.

OK, thanks.
> 
> > +
> > +	if (ksm_start() < 0)
> > +		return FAIL_ON_CHECK;
> > +
> > +	/* Attempt to migrate the merged KSM page */
> > +	ret = try_to_move_page(data->region);
> > +	if (ret != 0) {
> > +		ksft_print_msg("migration of KSM page after mremap failed\n");
> > +		return FAIL_ON_CHECK;
> > +	}
> > +
> > +	/* Ensure ksmd scan two turns at least to update ksm counters */
> > +	if (ksm_start() < 0)
> > +		return FAIL_ON_CHECK;
> 
> Why do we have to re-run KSM? ksm_start() already performed two runs. To remove
> any leftover rmap entries?

The second run-ksm is necessary since we want to check if the counter
ksm_merging_pages is correct after mremap.

> 
> But fundamentally, wouldn't it better to query before+after the
> try_to_move_page() the PFN of all pages, to (a) make sure that they are the same
> before (all merged, if not -> skip) and (b) make sure that all were migrated (if
> still old PFN -> not migrated -> BUG).

That makes sense.

> 
> > +
> > +	merging_pages = ksm_get_self_merging_pages();
> > +	printf("merging_pages:%ld\n", merging_pages);
> > +	if (merging_pages != nr_pages / 2) {
> 
> 
> [...]
> 
> > +TEST_F(migrate, ksm_and_mremap)
> > +{
> > +	struct global_data *data = &self->data;
> > +	int ret;
> > +
> > +	/* Skip if KSM is not available */
> > +	if (ksm_stop() < 0)
> > +		SKIP(return, "accessing \"/sys/kernel/mm/ksm/run\" failed");
> > +	if (ksm_get_full_scans() < 0)
> > +		SKIP(return, "accessing \"/sys/kernel/mm/ksm/full_scan\" failed");
> > +
> > +	ret = prctl(PR_SET_MEMORY_MERGE, 1, 0, 0, 0);
> > +	if (ret < 0 && errno == EINVAL)
> > +		SKIP(return, "PR_SET_MEMORY_MERGE not supported");
> > +	else if (ret)
> > +		ksft_exit_fail_perror("PR_SET_MEMORY_MERGE=1 failed");
> 
> Why are we not simply using MADV_MERGEABLE instead of the prctl?

No special reason here, I can switch to use MADV_MERGEABLE instead of the prctl if you think it's better.

