Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1975FD5B87D
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 01:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CE856B0088; Mon, 15 Dec 2025 20:37:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 775B06B0089; Mon, 15 Dec 2025 20:37:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674156B008A; Mon, 15 Dec 2025 20:37:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54F876B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:37:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCBAD12E6F
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:37:57 +0000 (UTC)
X-FDA: 84223622994.05.0C57402
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 01BE940002
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:37:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AaKYqsGg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765849076; a=rsa-sha256;
	cv=none;
	b=SSsMffgiUQkGjqo6QTwI75betmKsHUdd7keHXsTCSHRwAVe3IgipVewn8rEImrn5onIerY
	dmsssMY382kJ7V/dZzP0b1gdjsO/V1V4y4Ii4RMbA4zcHJfbq2ArCMYAXY1v7O+IR0esxj
	pIxBLlFf8P7X+mYetqEieDO8VQMs/sg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AaKYqsGg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765849076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0FDBivIYW8TFHL3VKiPkgeHToq4CwEnpvCaDs7HwAE=;
	b=Nhpf9DCVHLFxmN+1fy9LTZYj1sM0Ddahz+4+mP5rr0FUWZR2FA7Rb2gBjoeS7CwiKf6pi5
	ZLuptv1SHFDk0SUW1zNTfI0aR6zzk4xcK7/2HtD52PBFuhDfYEGirnnnTWQVUqSQ5OIWsp
	GPBlw9ys7fXaaAUA1dX77vLWm4zDsNc=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7bb3092e4d7so4364884b3a.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 17:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765849075; x=1766453875; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f0FDBivIYW8TFHL3VKiPkgeHToq4CwEnpvCaDs7HwAE=;
        b=AaKYqsGgVDt9xtwD3Y3mjfE7o18ZQ0Ul7KNVy/NLm7xwMSVj+lp8BcPJSwmj5iYFRv
         qvZebuUU9TryckZR7YuGCtgDbZPxX7+pmwjbFo2ECxAs4u7BiTURR3W9IqDEQyUMSafg
         eGOQgzY2NsDskn/xwWiRiBYeZEW2KqCH8OoYYmnziI7MHDh5fhOSsG73+d6NcbJqpxBf
         aJilAph7aoxRX8Bj5lfpW1BVbbGbWOqy+HHo5gTMKqlFvZUlU5Qw5M9TEut4HIyVSKQL
         QaIi+Q8CRbdeBy6vomBH+YVh8VC4FBHZmBkHsTb4jk8JJ256ywAIt9j62iPVnUY1dhou
         CQMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765849075; x=1766453875;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f0FDBivIYW8TFHL3VKiPkgeHToq4CwEnpvCaDs7HwAE=;
        b=exXg5HryZ1zZkr5a3y+ST337KDgQuVHKkyU8SIpfVPbmT9sQx3JPLXV/sgm5MDoDS1
         fF1MiuJ/GeArzp08fy2vWivmmxty8Dh9TPCHSgNX5xpCdlF7dDnr9Uqi1bV1J1rPTCZL
         J94OMwDHfr2u4+lPqEAcPubBLz4tvC3MxWRUMWENCBm94NSRa9xlgmltdZYUxT+6OuvQ
         Z9qnK9Lg1BJwM+NTzm0/T1KjXGzRQKlGOisrt+MkP4z8UhN7tiZ9EsZVPHGFMV74tFTB
         Hl+RD4cz13tEcXJXaMN/PKlBou6BLbAFCPkahGCfWpcRb5VgA0DGCzq8BrMg8yfKVOl3
         voxA==
X-Forwarded-Encrypted: i=1; AJvYcCVgZobjrHkIVhDYtuAyOYfvlpyYY8oJ0tEpLcBdnP3NLkI/2CTYQBoyJghmKOIevetrr7/YORojAA==@kvack.org
X-Gm-Message-State: AOJu0YyIYn791u6Q/xBoitpDEQsfdVWeljOesfOdidNjQ4QhnnOMO51D
	3aJhvAa+ORWRzj+3RgCpS8aALBuNJzAmmsMF3xfzWdINLoU5dr7uhkFq
X-Gm-Gg: AY/fxX69XNLdBTX7LRoxjgjhshS2wO1Pyp1cKlKDzkbPQ5BjI7nrYs6F3aqE4fV6uWr
	oWwyB0hTa0fyMiBqNSSWWASQLq0k6snudWVFuIaoh4WR4ORh9/vxGnBVE5nGMJF8zc/SGZ4dKiy
	qk5E4R+1aIq0HsTVQwscQeamQZcc7WEw9AB4tAKoVBXwRIgc3SSSrWj8MLaocnKfUzwAAt0CGj1
	LFryyRf2mY9+fPxMMSZse8LppldxpC5Mpf9TZjXJoaZbkn+wsc0CmKrvoVCLd70nnZNGbFSUB3P
	IcrJMVaMQKi3XjwHAQKpgABP7Jo3BCztyv5tNcMXI2LMWnOtCh7wNcw8kkNmGzvs0MZG+FIpXOK
	3hk54HZ0bK4gBefoe+Pi+gtZxc6P8tNF28elLN0LdQs8IrpfhSgFA+v1EEuaOn4zHNPVBxKBMWv
	WH1rY=
X-Google-Smtp-Source: AGHT+IGt3M1e5nD6KT/Tr73XIoi0zHyij2fPN6XhQLefORTEEkXDCvzAbax3QerzbjuxYRohNPHGbw==
X-Received: by 2002:a05:6a20:394b:b0:366:14ac:e200 with SMTP id adf61e73a8af0-369b708cd8dmr12251610637.62.1765849074655;
        Mon, 15 Dec 2025 17:37:54 -0800 (PST)
Received: from localhost ([2a12:a304:100::105b])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c26515d4bsm13325458a12.9.2025.12.15.17.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 17:37:54 -0800 (PST)
Date: Tue, 16 Dec 2025 09:37:51 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+4d3cc33ef7a77041efa6@syzkaller.appspotmail.com,
	syzbot+fdba5cca73fee92c69d6@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/readahead: read min folio constraints under
 invalidate lock
Message-ID: <aUC32PJZWFayGO-X@ndev>
References: <20251215141936.1045907-1-wangjinchao600@gmail.com>
 <aUAZn1ituYtbCEdd@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUAZn1ituYtbCEdd@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 01BE940002
X-Rspamd-Server: rspam10
X-Stat-Signature: 8gb5ket31g3q3w6i6iomygu71335zsx9
X-HE-Tag: 1765849075-624809
X-HE-Meta: U2FsdGVkX1+bijQZdn703XB8HmSIZJC4ikiSZR9LPqFS3J2HqYP/24It/tE7nuK34vk1p6Zq55BuyA50QQxKBJfZHMRkitlnuhKXL7kjRFpDzfSF7gO7sDpNI5x0jzs46LSDiyrEkoHXFUDpl89NfAwecRvaYZnyCFKdU+/lQ2WnFoPLA2+/48WmaC9Npt7LCSJgOdkASk7gCcUz/0icvZBQ4k1Qib1nJH9NonEevXBi55VPfd0Bbvi8JkgfPpyIonuR0BlCVaeW1eHW6Ad+WfYEpBz8mw7Jbdj/Gie+ZYLXW0G33izOHnMyh5o9NgO9P+iKAYuP5AEQkL1/xX7xePz45D9TxzTLR0g/bKGBazsJcR3Q/+OJroYWMHDc0qLG/OvQywL8+fSEYMYKGmV0+hN7IUH0KnVVhRK0Sr4qbMoA63vGlUZ1ORGYqjQQiKTWP1vJ4CAZgmYAhG0JbwfeKJ/ES42+TJaRGDZyv2QyuwzY6JiryQZC+sWO7vQk0XYz7K7DdEr/3zlU8ddeiQoqLVDtBi8zGoYjevjLzy/+zgbBYyj8wyjRUagzPurpAgYdP+q6qDVUvgQuRPjRdFBIwOaUGUKB4DtkGdEwOXIHwLLAh3UyyLtGdqq6NC+jJdsXNjq/5Hi0eBMcbZBxQGw74GcPGYd7qbYRPiKbZvWjx7Q2YKEPLLKIQAsTNQ3ilZXy1N9LtmUL8FkURBLzWxzwA/kc6sB3EEvK9Z4UWiqPCfa70IgFI+TR7uAMvFvye/x3Or57ToVBefwd6jX8HtEeZH0o9gocabUiH2V0JNPf58rkmxp9YLGTrGWbCEVTsYnvct/94lODTD1iV9MTGR+zV3l5IEGmCerUDvAnRKvDqpgQPv1Wo+oppDdpcilZhToYnC6CDCoHUBtQf+W+W6reBdiirjLfM68KJKnuksP4MBJaSmK6ra76U4pa5p4tQF4/oz4/pCkz5wXDj1bc83t
 Rt4U5mLU
 BEEtJS4tiiakDmUAZof8SLvi+0exnzKJs3Xq81srbrS0PonnuDqUWfV8NzwF++/oJi9vhLNlZ/F2j0xm500RO0VJhPj5Qge+pO/oNBBd0o9meLogtuE7GUzQJv8X9aWKe7QTEDlRdCx+kUlzQgCJ2472+DPTDcVYeeP6hIH5xkSUUacoyD2iex5RYHABntTNvoY0oel4s0/w+K5vMCUdTNuk3kugIg7M/ybVBIj0BKHLNvDio1k6fe3MlWWVFVEftE3F5C6vsmvawzl2Dnoavz0SKlBUF0uwJWpxV2MoUI+LydrVmryr7FNCuDfAMYGANjjVP3CbMJb/lNnGEnk5niwdJIj+KkCO3zRCmBNtB+bOaAbCf1K1y6awumsT/tv/QW2iPPKTvjf2rGY0s8/gyT7M5Li/2OLPKeY1aDG57G/DKgeAABm931tZodMmVwvXTrSVufKGzzARyO6vLsTbnVSFqCR+1P1baJqGzit/xwtIs59MZHcMMt19rRJrJoEqN2vbiOPZXP/GpsgB06DMMjtmBAimlgP0JRv1ktvf5HhhfHS1fadIvngIpicWBzfdoKZIMCsyb6cZanTN9crgNApeYwE6gltCw40u+SsRTFvgVKfBOQknQlLYtB9BCeJN7jWvl8pbEqRZaqH7KbFp7iVJsqu2XviVICpRQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 02:22:23PM +0000, Matthew Wilcox wrote:
> On Mon, Dec 15, 2025 at 10:19:00PM +0800, Jinchao Wang wrote:
> > page_cache_ra_order() and page_cache_ra_unbounded() read mapping minimum folio
> > constraints before taking the invalidate lock, allowing concurrent changes to
> > violate page cache invariants.
> > 
> > Move the lookups under filemap_invalidate_lock_shared() to ensure readahead
> > allocations respect the mapping constraints.
> 
> Why are the mapping folio size constraints being changed?  They're
> supposed to be set at inode instantiation and then never changed.

They can change after instantiation for block devices. In the syzbot repro:
  blkdev_ioctl() -> blkdev_bszset() -> set_blocksize() ->
  mapping_set_folio_min_order()

