Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E20F6CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 00:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D76C8E000E; Wed, 24 Sep 2025 20:52:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 088048E0001; Wed, 24 Sep 2025 20:52:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2E078E000E; Wed, 24 Sep 2025 20:52:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E39C08E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:52:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 78D311DDCA7
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 00:52:10 +0000 (UTC)
X-FDA: 83925946020.19.B5DDAF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E0D1980009
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 00:52:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B03GPHqE;
	spf=pass (imf02.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758761528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbgWx2FklFEBaLE/awcwgnEmo15Rtyo4cAaPuJ5wUR0=;
	b=mqvBPxswx1eMGoNQiHHD0IxatG2OlGA3h6yyQ8OigemDg7wax0DDoJEN+juEyOWFTc6rjg
	27WXxCXE3SMHQ1hjlSSIFQwaUh9oo9grJ/TY+LPyGdDQyrywzhLCdNLNwMkDarONui6K+C
	7Z+47s75eFGCG9g5bauYzKOaIm73HUc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B03GPHqE;
	spf=pass (imf02.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758761528; a=rsa-sha256;
	cv=none;
	b=w/e9vQvJd/18jWTTkxEKADK96ZSZia4XdS0rbiMZNBGGpWisSNp5ac6lcGGkZmVR8vB00n
	GxZTAtACDjQuhKeINIqtkxDlz5DTDxpjaR8zHS42wh5xxWbvvAQ8RNomLZWJG31hqN4ai1
	71XpTymxMjU79R1YVTSDURUCcwfhOFM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FE67601F9;
	Thu, 25 Sep 2025 00:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE021C4CEE7;
	Thu, 25 Sep 2025 00:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758761527;
	bh=4T9Uc1baOOm7aD/Y7ecu4SBOz/l6Ta2u4f5pFwwaU/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B03GPHqEXFNSoAFj12gdqmEUDxjJgJlrNnFZRAMrjsiwN0DzlFF1/VsRgW70z6EmT
	 B/xxKoU+TsbzKDQjgmwWVeMY6TUXrKxDoLUIeIOvAKT9ZmoxJGuGVaQJYmiVmlH9fM
	 jo/b2zwOwm2e8CvYjMNhGwrEmy9kz8V4q59CTKnoXVMA5E4m2IrwWMEI4+sGVqDqYK
	 ori3GPqOR9vpt6d1BKHYhihhQZmtEq08kZDFc87NkDcl2ix7XtUJRUAI11W7W8MmQ1
	 uk6iI6zl9G4WKXV27Mu/zj7cZVqmP7wVEsuL9luxWtZlcm+Zwm5pZEaSBfCdvtEx4L
	 KJASNC13sSt2Q==
Date: Wed, 24 Sep 2025 14:52:06 -1000
From: Tejun Heo <tj@kernel.org>
To: Chenglong Tang <chenglongtang@google.com>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev,
	roman.gushchin@linux.dev, linux-mm@kvack.org, lakitu-dev@google.com
Subject: Re: [REGRESSION] workqueue/writeback: Severe CPU hang due to kworker
 proliferation during I/O flush and cgroup cleanup
Message-ID: <aNSSNgUeMSTtlimW@slm.duckdns.org>
References: <CAOdxtTZJqgDNMtqsq51hQ0azanFPLXHMAJ-mRhRS6yjzYhMf_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOdxtTZJqgDNMtqsq51hQ0azanFPLXHMAJ-mRhRS6yjzYhMf_A@mail.gmail.com>
X-Rspamd-Queue-Id: E0D1980009
X-Rspamd-Server: rspam05
X-Stat-Signature: c4u6dmsh7ppioecorczwt5f8ds8wpjft
X-Rspam-User: 
X-HE-Tag: 1758761528-214832
X-HE-Meta: U2FsdGVkX1/xxBWoyYoJO02MgIWBgqgDjLdPKXz43MOqv40F4T+rjBWSRon1EEsXunTb1ANrXsTsq3IfSE/4ay6duWAp2pTt1/crhzZw3SNLpf7WWGa6cPzjANlIZU0JVQf7f9/zlj3ICjKvleO80GFNZP6+Sf/hE4jVkZ7LhqJ3XJk+a68dlyW6a2hwHCWVVW/0otMM4zcCY94JCJfeQam1yTsFURnw+P4K+TqTC1EouygFOUPnrz9CUn25uIB/+D2sCWDlvOnFytcd3NGzTvQT4ebTTKioB/Ui5rZjqKpDs60bXaL4sj0/42dfZEc9tgwME1jahVM+wQ9Mp15zji+nfogreVrOlkyC+GLeaJ0dT7cmL85GOXCI/DAJ09K2tZ81ApYJ7huvbtlTEc9Phwt0iUyFidIG6bgrkmVyYD21+upVvb7rh2gJUnDIqgLDlyy7vdX2v84aUs/4u49XV9ozyq4XedBW8EyUhQ1Y6YrTYmFzZj0dg4SBgAsiR09c0mre9ONDiUzdh+tl4RWeZANze4eAzHwRIvWqazOB3Tq6m6cP/1/uyq4jaevNJ/XvqVQK0baFZ9AO+bjHOmYJp7/9D229wETcRlIXcotSwRMMLhU69iUbnahEp7sqVBdJiMfg0/U4CDNSEfYLaGeyDk1NvuHB/ZSQY4EiIOAzBmgKQECJQsCsTtsxTgTUD+ifAS7dPbsLsQaK5ckLXc4ikLzmp8brcd6XcnPuaee3qi5TxBlNYule0GqEQ7UGmpRMZkV7jpHMzUeNGmNihPFI8z1vNAuj+DgiuB3nPykRo85/mLntU4PCf+t/l88Mf5rRRZL9EmL+kal9RrzaajW4HevILxhHDPzdhHlWMu2JW1n84mf9IZ0RykUVQ19OTSOoqP2HYNBEyZnKs8ToQrfsmxGtuojhI7giXJJxFzBnx1xOrar0CUhm8qasioRxIn1zVw2nRALmbFfFs2tYxgM
 3EjTbDL2
 et+p2RYE+ImvDBB73Rro0Ay3ISrg69mwwyIWxGQJxoQbA9ZRDcOO7I+MzJciG+947U0mzlZY+bBDJlwwHnM1zwI2m6qDoh1/WfGMtlTAMLufRsNHX5LTSIXLzDXMUuVd/L9rMS8MJ2E5yHDjHm4irsobpW8nXO9htpeRsAkURbyEWmYDuk/VRPATil1qxFDOD8be9gL360OohgQy/YR7j/U5UKJG98cnezJcs4p5tMFSlf9U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 05:24:15PM -0700, Chenglong Tang wrote:
> The kernel v6.1 is good. The hang is reliably triggered(over 80% chance) on
> kernels v6.6 and 6.12 and intermittently on mainline(6.17-rc7) with the
> following steps:
> -
> 
> *Environment:* A machine with a fast SSD and a high core count (e.g.,
> Google Cloud's N2-standard-128).
> -
> 
> *Workload:* Concurrently generate a large number of files (e.g., 2 million)
> using multiple services managed by systemd-run. This creates significant
> I/O and cgroup churn.
> -
> 
> *Trigger:* After the file generation completes, terminate the systemd-run
> services.
> -
> 
> *Result:* Shortly after the services are killed, the system's CPU load
> spikes, leading to a massive number of kworker/+inode_switch_wbs threads
> and a system-wide hang/livelock where the machine becomes unresponsive (20s
> - 300s).

Sounds like:

 http://lkml.kernel.org/r/20250912103522.2935-1-jack@suse.cz

Can you see whether those patches resolve the problem?

Thanks.

-- 
tejun

