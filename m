Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 076E4CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 16:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460FB8E0047; Fri, 17 Oct 2025 12:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411B38E001F; Fri, 17 Oct 2025 12:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3276D8E0047; Fri, 17 Oct 2025 12:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F6558E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 12:30:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8EC9119357
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:30:26 +0000 (UTC)
X-FDA: 84008144052.10.80F8C13
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 085C040024
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:30:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QazJII0s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760718625; a=rsa-sha256;
	cv=none;
	b=blJW5J7G2uS4o8iJt0/KXU3BZkkwHcCU9iDOQ+y9INKd3xTDwE9ccDw3UsT8H0NTWywLqF
	gpoad/ZVqkXRCFmXy3knRgf4b0goD2T9ptGSKNH2OlkoS8RBuuOJ38bma+RiwClCKSkou6
	EtaLrpERad7xMKuWlsEjgwxVjCOYkio=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QazJII0s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760718625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bmJ6BMKCC70hg2co/vhWRvi2FNRQ11Z/Oa2/TYvN/C8=;
	b=jS9e+Im07YUU+XxJ5rbQ8PevY++IId6/LUKM5H1Vx6rnzMgWQd6zZPqfq0IJVUsYKMzUvF
	SSdaKs/ehGFLmGOycYU2NescHUNwuAN62V65z78RQ7n4S0BUO0aXjBhFfQELBOKpVrrqVs
	XdeHcwEBsbA1/m3MEQkYHy4dfRnX/Fc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BDC544439E;
	Fri, 17 Oct 2025 16:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B149C4CEE7;
	Fri, 17 Oct 2025 16:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760718623;
	bh=0A95aUQlDuwkcx0jSODD8EHq026+LKD+s5SAlpUXlEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QazJII0s7tH8e2F7DgxwngRuHw2DH80TtOZ6Uqj3lAFc+iJ8oZN6PNVihCp48SU0q
	 gYk0Fr5azA4bIs+Yx9J41/OChxwqzXjL/9wv3vJx1uY9e6z24ihD2L3gjwXIerHp6U
	 +keBxh984t/6Y99GvpuwwACopO7NRW8C3Lq3ahLMlcFuH/bubjLEyxrudUBMZyJIH3
	 8ejTNSJrY6rHwCzOT+ZFFeI/EkXRN9JPvpGgGOEhHHg3S0DH2PBsU8nts77BysSQHx
	 SgHicqQE/P4XiaNgAsaS4Xq3gSvYz3btgM119QfJ7WKtdeK0Nh+BXam/MLiNEm2134
	 f6QZXMDLSZU/A==
From: SeongJae Park <sj@kernel.org>
To: Bijan Tabatabai <bijan311@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 1/5] mm/damon/core: add damon_target->obsolete for pin-point removal
Date: Fri, 17 Oct 2025 09:30:19 -0700
Message-ID: <20251017163021.116255-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAMvvPS5gjn6J1dF1O+Hj3CmVcPTQG__zRwqqdBMoRNtptQeOyg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 085C040024
X-Stat-Signature: c764wczg9kat6kp8zuwf3kmtwwphqu38
X-HE-Tag: 1760718624-860487
X-HE-Meta: U2FsdGVkX19EROYK3K2uiq66kv7jCdSMWZVMJgX8twl8OFEy3nJMpvFI/WzUM61PgSCtJ+6lp6irLCz5yXOwNlTzzQmFryEGW/bb9/IEJov7AbEx6Eh7mR78t2KIHPhyVuMEWxmPbnaCezpmaOKxorkZrhud3Pptsm/PJeyDhAgfJKn4qnPPC/0z0Nm3pEfgDl0s4aocxKR0hwCr6QgsHJK3ha+rlI+sjcgrJhvWmaVZt18flD01dFAB2K+zPfWsT3a0QcqyWLvAfm1onngWxzFIWC3TrBTNBoM/Sls2lhdp7rJlBaIiGWDiyxNz+4sz/NUe+kJ1UWOF+a8BwTSOtKeyduy/gC3QZQLt5mPuatf06d598BJcerBA9P+EuU9MWKtXaHW+xvtrTrakNmyP+2Vt4O00sPc1VqgGv8UPf1DOp6l3fTmooeNRlYXAhbvSwJej7AEku3UGVy92x8wshsJOuYz7zlGX04oQX83oa9Vpnp2RQFVnFvgUAzOUo+3SxLV83Vn4maP3wsw3yslCfxLJXZ2oWTJjQmP8PcRaRJunhHLhELOcvujyoXoaVpJuQ8+UfdjTD9vaprCDRKClfoUMbp4R2lwDS+lWvVq9a9UWDdMI/WjLEZRLnHF6kOFrfjwUccuJ45gx/iSZlHZPiLAcCAc76KXcgN7hWi0O0ux5HlKN6RYzeFT3k31VAOgyix+vQU5JW3ehOhD9W5yLnJc3oDM4F/KJImlNiRNANFdulIE/8VdQ1wWQ6M/hjFzTGzQ1KALQgNbCIKxY5+nxUTvZYGuGKieQ0xn9uqB6Et2c693+ZnKGDcAnZmEy2/I+jwSsl5OVeTAlTiNWSWTZ5Ou96cEqymJtbeZ5ARojgtUD+Ra2y0Yl2TYml9sv9Th45EQDntE3D8U5/PZy2WGPh0GQXnUdkeNj04TqUM7hDS5oFqIGkhVqMSoEH8vDPpClx1O91/VDGJ4L/RxKYKX
 zhuh14ga
 xE5gG44H6AYaKBC+XK9h7ldVvDvCZ95yq2kyLM78dqM/YJDzRKG02a9Ic19BrdOFnVDMqhcACIdS3kvGpMmKZn5ujDjpurGnvoa1DIYgn0gCFwGlbPo82bToRvIEfnugh9pMuAO18ucLgnNtxyVrxOWkO7PdWOGX3WveXtzN7yVqIVI+Le0DKiFhi61ER1IrZt5vuSTiYeVjArzwIXEopLe7i+A/u5WXxXuy8F1piIya6gsVb2GXb/oREXEhYcsAaQNd+ILkrnAD3QQ2zVHQwMy/baG1RvpP36jx/ED2Qv3E1w1Y6Xta7wr7ynD4DpUVao0QmTFAfwjmMKhFNaSAPu1/eDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Oct 2025 09:52:16 -0500 Bijan Tabatabai <bijan311@gmail.com> wrote:

> Thanks for working on this SJ!

My pleasure!

> 
> On Thu, Oct 16, 2025 at 4:47 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > DAMON's monitoring targets parameters update function,
> > damon_commit_targets(), is not providing a way to remove a target in the
> > middle of existing targets list.  Extend the API by adding a field to
> > struct damon_target.  If the field of a damon_commit_targets() source
> > target is set, it indicates the matcing target on the existing targets
> > list is obsolete.  damon_commit_targets() understands that and remove
> > those from the list, while respecting the index based matching for other
> > non-obsolete targets.
> >
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >  include/linux/damon.h |  6 ++++++
> >  mm/damon/core.c       | 10 +++++++++-
> >  2 files changed, 15 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/damon.h b/include/linux/damon.h
> > index 524dea87cac7..8a7b45b9e40d 100644
> > --- a/include/linux/damon.h
> > +++ b/include/linux/damon.h
> > @@ -92,17 +92,23 @@ struct damon_region {
> >   * @nr_regions:                Number of monitoring target regions of this target.
> >   * @regions_list:      Head of the monitoring target regions of this target.
> >   * @list:              List head for siblings.
> > + * @obsolete:          Whether the commit destination target is obsolete.
> >   *
> >   * Each monitoring context could have multiple targets.  For example, a context
> >   * for virtual memory address spaces could have multiple target processes.  The
> >   * @pid should be set for appropriate &struct damon_operations including the
> >   * virtual address spaces monitoring operations.
> > + *
> > + * @obsolte is used only for damon_commit_targets() source targets, to specify
> > + * the matching destination targets are obsolte.  Read damon_commit_targets()
> > + * to see how it is handled.
> >   */
> Nit: Twice in the above comment you've written "obsolte" instead of "obsolete."

Thank you for catching this, I will definitely fix those on the next spin.

> 
> With that fixed
> Reviewed-by: Bijan Tabatabai <bijan311@gmail.com>
> for the entire series.

Thank you!


Thanks,
SJ

[...]

