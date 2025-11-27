Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A7ADD11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 13:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 673596B0012; Thu, 27 Nov 2025 08:54:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A186B0023; Thu, 27 Nov 2025 08:54:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 587726B0027; Thu, 27 Nov 2025 08:54:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 478416B0012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 08:54:52 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D732F138C80
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 13:54:51 +0000 (UTC)
X-FDA: 84156532782.04.5E48240
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 48927A0004
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 13:54:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=aoAKfVc9;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764251690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FPlh5iDpWzy3oYkKJyEDPKFCbBCTNoWio1NNY+Ejdb4=;
	b=FlX0GQ6erZp0DzmIbWFYOH87pyh0cmmW6J6cItu8vGw968NAQwrZOQVj5HRUn2FuY51QTA
	L0SPD8zHOzYx6GFBGIKQpw5b6bBS2Wiex5/GhVfLq/326Uej3/CEbs/6zCz+K8pvUsPCDP
	Kjhs0HypdQV9IUl2QWXLi5uHSpiV00A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=aoAKfVc9;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764251690; a=rsa-sha256;
	cv=none;
	b=y4QJnc4eBsXl01IUs1u8A+jCMimpZyFoCy+2D3ObnlimSR0MTGMdBhnlodJNP+tkotoREy
	OFaSP/6zzvlKjtRGjkUBUMclcFeu1li4bOCXna9P7SQqCMSAEtguOf8zOtYzOrOZzdhhBi
	VTzYlKxXVCVeCnlsbglytyRtKLZx2Tk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FPlh5iDpWzy3oYkKJyEDPKFCbBCTNoWio1NNY+Ejdb4=; b=aoAKfVc9h/ihKDjXlRTucCPLYk
	dPqVyKuFyj8kJvQ3mLrgtX4CZihwxSMDt01h6+9uBPRG18p5aRiARpOCDSfJWQ3rkdkN+DJUKY0VD
	KS+htVRCp0N1UJQ526/2szUW/djXIv950zbjqdegyJLh7my8ggu3/4K/ARcQTeSSVib+Qa12NjTMC
	K7MIra73jEkBdTlEN3GL7WAyEBwkQYI48XO/UiY/mBp+6hrLFddbARlTQxHgXZzXosTpAQ6fSnOHJ
	z4zRWGUomSj0gWpdEkWjo7n1MlMIkRX/NJcMPQBuLLhbWHeBckF490yoBXoHlYZZ8uQfsAnrm0rQB
	De4VC6xg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOcSM-0000000BoEc-19cw;
	Thu, 27 Nov 2025 13:54:46 +0000
Date: Thu, 27 Nov 2025 13:54:46 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jan Sokolowski <jan.sokolowski@intel.com>
Cc: linux-kernel@vger.kernel.org,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 1/1] idr: do not create idr if new id would be
 outside given range
Message-ID: <aShYJta2EHh1d8az@casper.infradead.org>
References: <20251127092732.684959-1-jan.sokolowski@intel.com>
 <20251127092732.684959-2-jan.sokolowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127092732.684959-2-jan.sokolowski@intel.com>
X-Rspamd-Queue-Id: 48927A0004
X-Rspamd-Server: rspam02
X-Stat-Signature: 14ocah5b7unmdcj3ifq5rfau56p3zre1
X-Rspam-User: 
X-HE-Tag: 1764251690-224761
X-HE-Meta: U2FsdGVkX19Fdx2br6/Z2QqAdzB6FMfYifq8Jc7pPB0xBTL1JlttvFS6EEnvMh8NNNlc9hMLiVMl7FMOv+GAosQObIEUY/cYbnsmqJ2l4ib5SemzPgzNrB9gHrlFCdfJ4hYKaCXW57USXL2RCMeyQIWY3PSb5Kjx9gO6A/GD5KGhzgbOI4h36TLXkQ+0R0vFlQgdkmppwWi+9OiB2bBQ76wiadhg+Cn8ghpJly2mQgCbmLhYeUTWmPsSbupreErYlAMNFAgXLbfVoLVWb/sDMpwVet1Wlw6xjJgfSUF7qB0tRHZldFu2UMCNA5lMKpQmywQn9is8WiD/bkkxR2Hgcog7sHOwxwtpX6/Y1w8DpX8cIQaflJj8eJlFzi24p6TE9j5XY71Me+Wg/p7hVKH9qX2jn29QCC+k8dvKp63UY+yjGQRHQajXMXTZj/To+5kriqprDxVORvuJ+UCKlpprGfOi8rjCu8RQ6V4x4nSC8iTxDBo95RJGIOtLA9Vxgi2YZKqP0fPoktswzRvpwi55FguMIkQG/ipYisoAJBJcyZ3W3Qpu2eKQNKfavThzlrWcR8ow/mhnslJyZPNjMoKSF9bpz8UX2rsknY534qzuKID3Gw7GYX74HZgZ2bEpErc5JOEBhbR9vJE6CaxtttNO9kjUbKquAPhmL24lGqov0p4wwHPihay43gNoLKYdvIMHKGzeir4ZUtpft8PWOY9wBVZ362cU8QNTKDQaSCiuEwvFq3fes0zaAM34o00yk8nmyYgy6r6TMDLG2bag3emRHdqW2Gwgz+kWgjrm8Z7IcqyO0lAxsKo4U4PnO59OfrcgAkVCPtg4Smqd9OwcKK83mmF6revlUPd+vSjrttaEiY2iKUYVk+8QmiEuEQaJ30paH21nYFJCyYVHT6pePNxpOpyO8iUBldwTFn758UQ1zW2fNF+PTbq74L+vMPwUn+p0/q90iJQLh9zeUsatbvb
 PQ5fWdfa
 7j5L+scIR9iStybbKSLXC3nZ85KAxL1r1b7P+bzTRpXeywvoPto91sNA2f+s9y9CfZ1lNRtI3VmlkzILv5E+6VL3CwA0Cub6p1Ojd2NPjbfF9P+Md/oCRUPa3scYX/Aio93KOYJv6zzf1nDqZ/TBCjCiboO9RTgbfmQyxAclbJ/SGPbbvMcXCLi9Dtpj6F2JLGC0zc1J8GCwWSFrp6xCHnu3LxxlF3aiQdunThTXGYBjU+TlUtk03K2P9Pw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 10:27:32AM +0100, Jan Sokolowski wrote:
> A scenario was found where trying to add id in range 0,1
> would return an id of 2, which is outside the range and thus
> now what the user would expect.

Can you do a bit better with this bug report?  Under what circumstances
does this happen?  Preferably answer in the form of a test case for the
IDR test suite.  Here's my attempt to recreate your situation based on
what I read in that thread.  It doesn't show a problem, so clearly I got
something wrong.

To run the test suite, apply this patch, then

$ make -C tools/testing/radix-tree
$ ./tools/testing/radix-tree/idr-test

diff --git a/tools/testing/radix-tree/idr-test.c b/tools/testing/radix-tree/idr-test.c
index 2f830ff8396c..774c0c9c141f 100644
--- a/tools/testing/radix-tree/idr-test.c
+++ b/tools/testing/radix-tree/idr-test.c
@@ -57,6 +57,21 @@ void idr_alloc_test(void)
 	idr_destroy(&idr);
 }
 
+void idr_alloc2_test(void)
+{
+	int id;
+	DEFINE_IDR(idr);
+
+	id = idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
+	printf("id = %d\n", id);
+	assert(id == 0);
+	id = idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
+	printf("id = %d\n", id);
+	assert(id == -ENOSPC);
+
+	idr_destroy(&idr);
+}
+
 void idr_replace_test(void)
 {
 	DEFINE_IDR(idr);
@@ -409,6 +424,7 @@ void idr_checks(void)
 
 	idr_replace_test();
 	idr_alloc_test();
+	idr_alloc2_test();
 	idr_null_test();
 	idr_nowait_test();
 	idr_get_next_test(0);

