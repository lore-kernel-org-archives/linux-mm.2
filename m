Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FE70CD8CB9
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290EC6B0005; Tue,  9 Jun 2026 09:49:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A916B008A; Tue,  9 Jun 2026 09:49:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E2CA6B0092; Tue,  9 Jun 2026 09:49:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ECCA56B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:49:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD373C21BD
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:49:57 +0000 (UTC)
X-FDA: 84860507634.17.54392DE
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3B3CD8001A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:49:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781012995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+G1EW7+M/7Jpt4UDPj+TTL5ny3BpzLPZZXl1ymkmAZ4=;
	b=uE/2th6bxuWPTc7bN+SuxuNFWXuipmMMuygtEGQ7m+riSPqfRIr0iN90lHj8FQWkYp2H09
	yUVmHCMu223fJdswPmHxCuA4PpUY7AeK/9ajvHLOVVvb7bw51P/wvgbS4YUZULfvT8JSTm
	FDPU2BfE+fb/v9+NN/C9IfXqjROT5BQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781012995;
	b=1+TDcd5RddtDqApP0WEC4DCvCLcXlmCs0HnJgf/GtAomLj8gYY1mDldYtp7iepi6FsJsHt
	CKg1XBsQ+68aBs9ekfyKWAafLnyPd56HRG8lA5OkgXmiOPy/tMCU67Xphb4MQGy93sa8M4
	mJCKE+mdyHim/CpppqDdlA8CrbSw+Yw=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gZVdn0Ywpz58fc9;
	Tue, 09 Jun 2026 21:49:49 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 659Dnhdw042464;
	Tue, 9 Jun 2026 21:49:43 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 9 Jun 2026 21:49:47 +0800 (CST)
X-Zmail-TransId: 2afc6a2819fb216-0fd65
X-Mailer: Zmail v1.0
Message-ID: <20260609214947060zpq8Z6jdYop1TceXXcLoQ@zte.com.cn>
In-Reply-To: <CAA1CXcAsx3cU6HNea1MgLocGReoGoFQaq3NBFd-NUeOW8nJjmQ@mail.gmail.com>
References: 20260609201202615oT6yd_LtIoKkGLksFaCha@zte.com.cn,20260609130611.88058-1-lance.yang@linux.dev,CAA1CXcAsx3cU6HNea1MgLocGReoGoFQaq3NBFd-NUeOW8nJjmQ@mail.gmail.com
Date: Tue, 9 Jun 2026 21:49:47 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <npache@redhat.com>, <david@kernel.org>
Cc: <lance.yang@linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <usamaarif642@gmail.com>, <yuzhao@google.com>,
        <aarcange@redhat.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
        <chengming.zhou@linux.dev>, <ljs@kernel.org>, <ziy@nvidia.com>,
        <baolin.wang@linux.alibaba.com>, <liam@infradead.org>,
        <ryan.roberts@arm.com>, <dev.jain@arm.com>, <baohua@kernel.org>,
        <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
        <rakie.kim@sk.com>, <byungchul@sk.com>, <gourry@gourry.net>,
        <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
        <wang.yaxin@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBtbS11bnN0YWJsZSB2MSAyLzNdIG1tL21pZ3JhdGUuYzogUHJldmVudCBmb2xpbyBzcGxpdHRpbmcgZnJvbSBpbnRlcmFjdGluZyB3aXRoIEtTTQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 659Dnhdw042464
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 09 Jun 2026 21:49:49 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A2819FD.000/4gZVdn0Ywpz58fc9
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3B3CD8001A
X-Stat-Signature: sks3mbj3j6mgcutn8d9ct5wcksnz1ujf
X-Rspam-User: 
X-HE-Tag: 1781012995-817651
X-HE-Meta: U2FsdGVkX1/B6XBUJVkL+63s/EyiXGND8GwwmEFcNcFJpvCXTk1/snrOMlg8KZivwFNuXjWR+mbg/5fx1/3HEWIyjw2MnnMT3Pw1h+grhWx/fRjcDbjQIBEBBsppkUCafzZHBRhY9r+6ATKcq50egcM6xRIz20ZlL0sJmZzHYfAacLQZ3NSKXcmkJ28tAkS6zbIRYMvyDB1HIaPHTQzEsA5CVh88A5FW13EbRrPCOGLLtJIAQO37t6opyN73N7K0sAC1e+T7CaSuPq9Jvv7sat5gg113VdB0DMhT9u0/yWDZD9FtDtNYbrAYyYvVnCzcHvoR0dCAD1JDOogiio3r160YZAsuMe2WK87q4YSYudEvqxVVB1bhQqSWZZbUsGt8uZeIwCFH4nN+cKFkhKJEo48JV9rNgSjyHIl9ZAPoR0KWDWiWs5NylX2jvhgBxLkUHQ0MdOtETM37+rBfvkytru0qUEYfjlpG2iV7o43eeyhGxa6WMMFZnyPoVjK4TY6aq3+JjYP9Y4DW/iqGSqIM0lZ0qcGTRfe5xwlKzpPtNGNUDOwzX0sifJ/npokneWCotQpbcF3rbDb8/vzk6vhr+sQ50QH5wO4C5Rl0potlmHn82v6/sBPGuPt1v0dUPTQeE+2x0UZUr+FwsIH7w1zZpNr/KyOSQt++zsNmwuQXYUkvahymAEUXWsFKcxLpZghX0CTanGzEJQZ26Vex0WPwz0/3ocUAsIJrjsCdDy5L7TQr1exTVtli0jJM9iHPLxOoHsR1lYnhMSRrMJqRCM/WXYlK/9l9y3YL3DUS+R/4xEwe6s3k/mVarkUhiYKBir8sKInGPo3JwDN/HQq58IlV2lOjHhB/A31R9hxsTrJxiJB6SENCJchginRSiW5fK/MYEaNpSNroigbZ+Rxh469dKLqjvLaiWaBB+GuGzuU0AWwAeg3meGH4hCMeCqxzf0ktjs5TCQxYsmM3ouTTG38
 GgTNlC/w
 dxSsUKIui73m4jLk0hj6uMEo8jrSpXkxalF5sxvz6tq+NHSvMccVdD9nw5pBbAiKwHqg2rc1FFz2+QfAVHSZ3rWk7ZE6MrYjO0cW3xGSd6D7OMXg2OkkZUcpcL0/WBavLdQacQQno7QwtaU2Vl3gu0stMXyy7uBll+yuAOknrOEDE7yseJPW2Z0AA/uewLcTdNsAVD8UdfP9FmIH4y4/AmgBf+sPhpaBM8NPQfYtS28uGNZ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > >AFAIU, KSM and THP do often conflict with each other. THP tries hard to collapse
> > >a huge page (which may contain many zero pages). If KSM is enabled and part of
> > >that huge page is mergeable, it can easily be split by KSM, rendering THP's
> > >efforts futile.
> > >
> > >Therefore, in our actual production environment, we typically avoid making the
> > >same region both KSM mergeable and THP always.
> >
> > Right, some setups may choose to avoid using KSM and THP always on the
> > same region. But that is not something the kernel can assume :)
> >
> > David noted in the RFC that QEMU may use both MADV_HUGEPAGE and
> > MADV_MERGEABLE, while KSM can be enabled later system-wide.
> >
> > And I think Nico means something different from KSM spliting THPs in
> > general.
> >
> > KSM has been able to split THP before. the new part from b1f202060afe is
> > that a KSM-triggered split can also remap zero-filled subpages to the
> > shared zeropage, outside KSM's own use_zero_pages/pages_to_scan controls.
> >
> > Maybe the changelog could spell that out :)
> 
> Yeah maybe I didnt properly explain that :p
> 
> After some thought I still think the alternative approach i mentioned
> in the RFC may be better.
> 
> ie) prevent the zero-page merging that results from KSM splitting a
> folio. The check we add here is more general and will skip this
> zero-page merging with all MERGEABLE mappings, not just those causing
> the issue (the KSM splitting). The result is that even migrations, etc
> that are also MERGEABLE will be skipped needlessly.
> 
> If we use this approach we also don't need the first patch of the series.

Yeah, That's also what I want to suggest.

