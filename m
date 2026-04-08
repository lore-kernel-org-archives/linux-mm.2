Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC251073CB6
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 13:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFC366B0088; Wed,  8 Apr 2026 09:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAD296B0089; Wed,  8 Apr 2026 09:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99BAC6B008A; Wed,  8 Apr 2026 09:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8497C6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:16:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 493561A0133
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:16:04 +0000 (UTC)
X-FDA: 84635436648.28.2B50017
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf30.hostedemail.com (Postfix) with ESMTP id DB1F580002
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:15:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775654161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XocPyPmspGMg0ErssEBi4P1HPFZ3OYHvIksb0gRnHH0=;
	b=bOahsaAIM3DBhcAx2S1RF5B9LS4essLouOdxjpVybkiuGaiWY+U8zTqKxoxMcyHcUNnhDv
	hwMCSXZhgkw/R+UOtkvolKZEbiXgWzTy1+YDLQQ/4XbQUcE+JBXycowQq1T2aBKkd43QaX
	iO5l668mXvwx/5fW2nRYYl39rV16JtI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775654161; a=rsa-sha256;
	cv=none;
	b=0JfVemjpBY23DqULKX6vXZTN1EqW3YUTrZNOWV8lqZ/uibtkex6yHuzE8v/YyUwzknxKiq
	v84//WbFIzAg/UsYaP+gLjJfgQd48L+7hoh7mlgAeMCOtns6UF/etMvHzYb2zsa91pyG3h
	VG4OO/wK1bxQ74auuSa5+MMCcD/Lzk4=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4frNqB19bsz501bC;
	Wed, 08 Apr 2026 21:15:50 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 638DFm80024519;
	Wed, 8 Apr 2026 21:15:49 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 8 Apr 2026 21:15:52 +0800 (CST)
X-Zmail-TransId: 2afc69d655081d8-09157
X-Mailer: Zmail v1.0
Message-ID: <20260408211552000LDjkQX010NY5GI_er7Qb1@zte.com.cn>
In-Reply-To: <2513cca9-0f5f-3b5b-e758-b9cc304c8699@google.com>
References: 20260407140805858ViqJKFhfmYSfq0FynsaEY@zte.com.cn,a14a89ba-e870-47d2-a903-564332da9877@kernel.org,2513cca9-0f5f-3b5b-e758-b9cc304c8699@google.com
Date: Wed, 8 Apr 2026 21:15:52 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <hughd@google.com>, <david@kernel.org>, <akpm@linux-foundation.org>,
        <ljs@kernel.org>
Cc: <akpm@linux-foundation.org>, <michel@lespinasse.org>, <ljs@kernel.org>,
        <chengming.zhou@linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: =?UTF-8?B?UmU6IGtzbTogYWRkIG1yZW1hcCBzZWxmdGVzdHMgZm9yIGtzbV9ybWFwX3dhbGs=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 638DFm80024519
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Wed, 08 Apr 2026 21:15:50 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69D65506.000/4frNqB19bsz501bC
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DB1F580002
X-Stat-Signature: mfas9bxu8u55rsn48rzacbr4sirmthes
X-Rspam-User: 
X-HE-Tag: 1775654159-114308
X-HE-Meta: U2FsdGVkX197KQwrnwE/Hqo1RaTLLksHDVDkSKc4vJZLQp4SxJaZ8N4QArTb18OhTBcob7GTbcEGC7DqejEps7D5oCauQr4I5fEMuUBXJFErUlumwWzpoRvAKcglWZNVA76qt3xJr3f2hxqusj5hyl4z61P2dI+KYDQsTkJan2sGKhN3enYW/H4Jyl8yUj+WO+0qCQZMfMnW5jAZWKg5SXaMNSsJ6sw7DMaeDFSghCQkFnl9h1WOktSrwKpTJmuPaj15f8p8Uw21MeJTDFhTUW0Mp2RFZrxvmDw4BY/SOzYRIbNmFL2zCuBw49O4mascvZ+cIENG4wSlqHFuwnmfxPN+Rr1itt/gdLuLg7ypP2vqw0H4b6WKvb3wsMcFbBpuoZFnhjDeuEK4RVafUIedAa/4iGwOrYkci1mJivT3vxjFjYLGIzx8RgkMVh6ps3djq9b05TXuxctXz6Ck950ksNsX1fJZExx1H3WjRKyVljkd55/0SrwLuhKwoaqZJV9koCwxrha4Y8km+ZFicQc/wvbKrYoOU3dyOof1LmmJRlfgnE1yba8ZGt5zCUT1vFU7UkwY2h+/l518JG6tr50fBS8DqNJB/yTQoY2gHzR39x8NEQTR/XSw+W8N4lJLzWbLZiiMtLxaH0jfjJpU1ab6JbPiG3R7aq0c9BQ+lurLSNRm4SjGIxw3wKzNbKiAln7sdtyHaOYnZf7efEFfINrVAYGJdjT0MeBezbtLrQgvqtEP/aevkY0xp8Ls9EjDLgYw5PmTlVuFw8bTFGU0wJRY74X1ud14DLoSa3MpfhkSyF2oWvb/M05nu5pznaqss1Sb/8qztYjtwRRTtw4jvaWn+YCrgmlfDqVgrHEqSz91f8LYpdmTaf3RZA6wG10fA4VrKKzIgawTxTeXJc1eX51Jm8SDAD48JHkri6Pvix2+GuUQQ19/i2xiV4z0EJityFHI8x7nBrnbN5sPiWcvp5N
 idv8dqpl
 jCW/vGYGLk86OF6nbnH5KtsLrePDfODtblSHPtuDtV1VpQF5EinXX0Gr3dtt0JM3DSsYMNu43khnHMD3Re9KxO6qSEESle0nUdOREP/Db+q6Apb5GUkeB7N9Cf1EtDWaHRMXqiXxp8zqnbezJhPBpP/bvoGJDNwNNYrmOc4BvQHb6yA/qII72uUYYfcoH6VfgucmtnoO386SU5LXBnlTSyO1GYBglJNhm7x/SToQCli1Cy5ctYlLSZbmUE23Gmv3oMTXaWxHWyxsrFx/+DML7PKiSUdll6hs6ZxyH7Q2dZ77IDxDXqvrBePMg+QlJtOY/Gcqr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > > index 53f2058b0ef2..65470def2bf1 100644
> > > --- a/tools/testing/selftests/mm/rmap.c
> > > +++ b/tools/testing/selftests/mm/rmap.c
> > > @@ -430,4 +430,73 @@ TEST_F(migrate, ksm)
> > >  	propagate_children(_metadata, data);
> > >  }
> > > 
> > > +/* To test if ksm page can be migrated when it's mremapped */
> > > +int merge_mremap_and_migrate(struct global_data *data)
> > > +{
> > > +	int ret = 0;
> > > +	/* Allocate range and set the same data */
> > > +	data->mapsize = 3*getpagesize();
> > > +	data->region = mmap(NULL, data->mapsize, PROT_READ|PROT_WRITE,
> > > +			   MAP_PRIVATE|MAP_ANON, -1, 0);
> > > +	if (data->region == MAP_FAILED)
> > > +		ksft_exit_fail_perror("mmap failed");
> > > +
> > > +	memset(data->region, 0x77, data->mapsize);
> 
> (Not crucial at all, but to avoid confusion between our results, I'll
> point out that my testcase only memset 2*getpagesize() there, leaving
> the last page unpopulated - just one less complication.)
> 
> > 
> > What happens if you mremap() after faulting, but before merging?
> > 
> > rmap_item->address always holds the user space address of the entry in
> > the parent process. It must match the one in the child process, because
> > mremap() will unmerge/unshare in the child.
> > 
> > And it must match the one in the parent, as mremap() would similarly
> > unmerge/unshare.
> >
> > Maybe doing the mremap() before merging (but after faulting) would
> > trigger what Hugh described.
> > 
> > break_cow() and friends don't care about the rmap, as they simply jump
> > directly to the user space address in the process.
> > 
> > In rmap_walk_ksm(), I think the concern Hugh raised is that we are using
> > 
> > 	const pgoff_t pgoff = rmap_item->address >> PAGE_SHIFT;
> > 
> > but we'd actually need a pgoff into the anon_vma. Without mremap, it
> > does not matter, they are the same (tests keep passing). But with mremap
> > it's not longer the same.
> > 
> > I think one could store it in the ksm_rmap_item, but that would increase
> > it's size. It's essentially the folio->index of the original page we are
> > replacing.
> > 
> > Or we could just remember "pgoff is not that simple because mremap was
> > involved, so walk the whole damn thing".
> > 
> > We could also just try walking all involved processes, looking only at
> > that user space address (but that gets more tricky with rmap locking etc
> > ...).
> > 
> > Anyhow, I think that's the concern Hugh raised, IIUC.
> 
> Yes, you and Lorenzo are seeing the same seed for doubt as I saw:
> as you say, "pgoff is not that simple because mremap involved";
> but it is confusing, so hard for us to be sure about it.
> 
> > 
> > > +
> > > +	if (ksm_start() < 0)
> > > +		return FAIL_ON_CHECK;
> > > +
> > > +	/* 1  2 expected */
> > > +	ksft_print_msg("Shared: %ld (1 expected) Sharing: %ld (2 expected)\n",
> > > +		ksm_get_pages_shared(), ksm_get_pages_sharing());
> > > +
> > > +	/*
> > > +	 * Mremap the second pagesize address range into the third pagesize
> > > +	 * address.
> > > +	 */
> > > +	data->region = mremap(data->region + getpagesize(), getpagesize(), getpagesize(),
> > > +			 MREMAP_MAYMOVE|MREMAP_FIXED, data->region + 2*getpagesize());
> > 
> > There would not be a KSM page after this mremap(), no?
> 
> Oh, good thinking: yes, a side-effect of mremap's non-persistent
> MADV_UNMERGEABLE would be that there's no KSM page in the mremapped
> "subregion" at this instant, so the try_to_move_page() which follows
> is likely to have no trouble succeeding; so, as it stands, this test
> is not testing what's required.
> 
> Sorry, I won't be able to give this more attention for a week: I
> wanted to advertise my doubt before 7.1 merge window, while awkwardly
> knowing I'd have to back out of ensuing discussion and testing for a
> few days.  It seems agreed that we won't endanger 7.1 until this is
> resolved: I just hope I'm not guilty of raising a false alarm.
> 
> Hugh


Oh, thanks to David and Hugh's reminder, I now understand the issue Hugh was pointing out, and I also
see why my current test program incorrectly passes: before migrating the memory page, the
mremap() operation has already turned a KSM page into an anonymous page, causing the code to
take rmap_walk_anon instead of rmap_walk_ksm. Therefore, to reproduce the issue Hugh described,
we only need to add a delay of wait_ksmd_scan_finish_two_truns before migration (after mremap) 

	— simply wait for ksmd to merge the remapped page back into a KSM page.

such testing code can reproduce what Hugh points out and FAIL to migrate:

	/*
	* Mremap the second pagesize address range into the third pagesize
	* address.
	*/
	data->region = mremap(data->region + getpagesize(), getpagesize(), getpagesize(),
			MREMAP_MAYMOVE|MREMAP_FIXED, data->region + 2*getpagesize());

	printf("After meremap region: %p\n", data->region);   

	if (data->region == MAP_FAILED)
		return FAIL_ON_CHECK;

+	/* 
+	 * Wait ksmd to scan and remerge the mremaped page (since it's not KSM
+	 * page temporarily, see prep_move_vma->madvise(UNMERGEABLE)).
+	 */
+	 if (ksm_start() < 0)
+		return FAIL_ON_CHECK;
+
+	ksft_print_msg("Shared: %ld (1 expected) Sharing: %ld (1 expected)\n",
+		ksm_get_pages_shared(), ksm_get_pages_sharing());

	/* Check if we can migrate this region successfully */
	ret = try_to_move_page(data->region);
	if (ret != 0) {
		ksft_print_msg("failed to move_page\n");
		return ret;
	}

	/* Wait ksm scan two turns at least */
	if (ksm_start() < 0)
		return FAIL_ON_CHECK;

	/* 1  1 expected */
	ksft_print_msg("Shared: %ld (1 expected) Sharing: %ld (1 expected)\n",
		ksm_get_pages_shared(), ksm_get_pages_sharing());

	return 0;
}

