Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74C1BC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B5246B00B9; Mon, 21 Sep 2026 08:38:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 766576B00BC; Mon, 21 Sep 2026 08:38:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6543F6B00E3; Mon, 21 Sep 2026 08:38:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7E06B00B9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:38:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7A67160189
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:37:59 +0000 (UTC)
X-FDA: 85237721478.12.7BF2E68
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 98DFB180002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:37:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BEej8Nkw;
	spf=pass (imf06.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789994277;
	b=a84x48gPNHFG1saKfZ3Gu9rC2dxwJfutzKrMdsGVpdsSDZtmm4wdlqxZmxiHgIh0wzj80G
	l3FtZjAh3xkX5XAp/C5SX4gqcVdXUHae0KxQcjWAYQqT2s25pkTamOpTta/oydPfxC7cAC
	4LHY/r3RnTzHMAVJWXdfFzqZBFTZT08=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BEej8Nkw;
	spf=pass (imf06.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789994277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aklumEa6XguIynReYEX+Y++SQ+69vSThlIRdZDlT/FY=;
	b=0iOC2Wyt6ZC00IukIBL6iUj8LmcPquUoI/Za4xqTtV0StO8rpULiQi01Ec7//TfpCAr5tq
	E+abbaUd9QvGKJDVceoQintgjHTsUzUOZixO/vBLm1C5iJd/k3SOrIBeBwBu1x4yd5imIm
	+2o+2VCGewQFC/3wtBHnrow0bpsPObA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789994277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aklumEa6XguIynReYEX+Y++SQ+69vSThlIRdZDlT/FY=;
	b=BEej8NkwYX/ejnvA76VdZa39mciXyfr0CInzXj/itpEDZz6c0wHjtHnznwpRcmYSeRETnz
	YqkkcuXtlVxCeBEMQcC4JyP6/hZi1YMEofMo0OqvvRYZx8ykPV9qKFSrdhHIxQv7D/rO2L
	lcLJtPUiK8oD8n30ADbT1ivs2BAzT6Q=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-411-AVyL1piRM16vpWdFLrfcLw-1; Mon,
 21 Sep 2026 08:37:54 -0400
X-MC-Unique: AVyL1piRM16vpWdFLrfcLw-1
X-Mimecast-MFC-AGG-ID: AVyL1piRM16vpWdFLrfcLw_1789994273
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC4651956055;
	Mon, 21 Sep 2026 12:37:52 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id A9A5E1956041;
	Mon, 21 Sep 2026 12:37:48 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 21 Sep 2026 14:37:52 +0200 (CEST)
Date: Mon, 21 Sep 2026 14:37:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/7] fork: refuse new threads while a coredump or an
 exec is in progress
Message-ID: <arElG0TGxxLFn7Ul@redhat.com>
References: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
 <20260917-work-coredump-fixes-v2-1-f3787fcda051@kernel.org>
 <aq0VLTyxNatFmLOK@redhat.com>
 <20260918-irrsinn-pickt-vermummen-d7167c397398@brauner>
 <20260918-disput-maden-parkdeck-2bc22dd90398@brauner>
 <aq0_lvHDViIpX_Mu@redhat.com>
 <20260918-elstern-potenzieren-marotten-71ebd0744753@brauner>
 <20260918-oliven-lebst-wohltat-c633868711f1@brauner>
 <arEHxPFFrRtvUSPJ@redhat.com>
 <20260921-aufwiegen-festwagen-ozonkonzentration-ffe78eafa8fa@brauner>
MIME-Version: 1.0
In-Reply-To: <20260921-aufwiegen-festwagen-ozonkonzentration-ffe78eafa8fa@brauner>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: zo-CnPU-7oUB34idAU65altA-KZxbJvzhZfGffWyWpY_1789994273
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 98DFB180002
X-Stat-Signature: ghgbjcry1brdontrta7f43i84kqad6gw
X-Rspam-User: 
X-HE-Tag: 1789994277-667440
X-HE-Meta: U2FsdGVkX1+a7yZM+9WKAwDP7UrXbYk8WxetiyzNi1jjpPvGS+FYMV1Sunk9uk6y5c+myW6ExcRveow4Z1Xt7+meMOBqq5XwpR/gKQCmbXOaKUrnfpKU+w7Y8LPk3bDCBscjBvhuo69cJwQnma5qUkfUye7c77LScZfGUEadj9T+SeKjOQ2DjYIJyoPKNd7+Jvcw1BURJHfmguiBO/B9LB022JYzSPyZ49nESausCbHt6ZulBaoz95q3+BhDddKk7fd0FnYPPR2T8Xb0TaGYdhkshzmeEzrHPMjM9dsG2aWRHA8Pa/XpgkU+17zuj0qmjeQEiaIsDew17TGtIEHVJrR2vvQJLaFmwI+8y2C/w2QhuZLFs2CPNmnQ1dPt2mUKsONpxtJjTBd9S+wBNzC2iwdcdrXWF/BZa85bBdCkhD3e46Ewzl5UkUjVogWd7KHKW0001xXg0loRquNCMxnq+bMrlEW1PNtj8BDqNDe4bgsAl3ks2K515OkUaty4OyDvDajmPfaLNDUd8eB4VZNloarshEV/lwo0XYqkWtrar9MMMA/EQczZfLWcjrXcDn17FhDwtltrZuTI1V0b/OqM22epnjxVRA4OaGSJ56YLYfBXV4/ds5nh1XGK+5uICYiAnZKODjP/HzLXNCt56vTFivwKpVbvkCb/gGuoiryXlRp5edcIITPE9lYNdOCuI2I2kjVYNJv/TjgD1MIA/81A+OjcrkJDRPdXWeNGezA3fhQLzpn9BcGm/8/YFVplKY5Sqd4rAT6vs1zX9iyLNt0liAFTyjHPwhfDAjF26xyTbXEjV8+pkGcv0cpg2D65v6GIhiPnHJnLb7iDDOWPEi3NM6oVRXhs9itbkCTrD37XbCqH6gI7BOdHwIVY1MPmLPyidLV51giN3JZWs+SrmDM55da4za6fXAXi8UPYZg7ZXqPFva2t8Ru9Zg4HXc3a6DWpAqdOv6b7cqs8Tl6M1Ky
 NVfjhhqd
 jb9HUIf5ogqj40kW/AZCtPs0AcVwzVaFAuI1q7EMytENGPf/1GxiFcBKjEzDUpV5XcWdtT7ULgnKXJIA5+ty0/sHz8IAta+I/yBQpp796URPRUN7x+bpJw95zNy8yu8mTHFduz6CS4eaSomGuvHJPZxt4QjP9CX5o/t8M+rQkhq3d86k65ia+wNmLATxLNgwhKiba2+sivPxjHE/epHAC6+2IEm4ZAdajPpIxaNIAHmivqHic3S2ml3BynzxPTv3a5Y+aRkcIR47V99A7n0/xQaQq+Z14PyR2MwNNVHR2DsWJDIANF4oyu9IZoC1Iu7V4pDCeDrDCHdpE6eM9UfwgpbvTu1/Gv88DcOOI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/21, Christian Brauner wrote:
>
> On Mon, Sep 21, 2026 at 12:32:36PM +0200, Oleg Nesterov wrote:
> > On 09/18, Christian Brauner wrote:
> > >
> > > zap_process() skips every thread that has PF_POSTCOREDUMP set.
> > > do_exit() sets PF_POSTCOREDUMP in synchronize_group_exit() and calls
> > > io_uring_files_cancel() right after that.
> > >
> > > That runs task work, create_worker_cb() runs and creates a new io-wq
> > > worker. If a thread started a coredump rgith before that worker gets
> > > created from a thread with PF_POSTCOREDUMP set which zap_processes()
> > > doesn't see. So two ways of fixing this:
> >
> > Christian, I got lost ;)
> >
> > TBH, I don't understand why the new io worker is really bad in this case.
>
> zap_processes() only counts threads it sends SIGKILL too. But every
> thread that later finds ->core_state decrements that count. An io-wq
> worker created from the exiting thread isn't counted and exits right
> away because the io-wq exit bit is already set. So it decrements without
> having been counted.

Aaah, I forgot that the new worker can exit too and notice
signal->core_state != NULL in synchronize_group_exit(). Thanks.

> > But lets forget about coredump/zap_process. With the change below the
> > io_uring_files_cancel() paths will no longer be able to create a new
> > worker, even if coredump is not in progress.
> >
> > Is it correct?
>
> Yes.

Great. Then I think your change is fine.

Oleg.


