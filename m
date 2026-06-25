Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79ACACDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 00:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 630016B0088; Wed, 24 Jun 2026 20:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 607616B008A; Wed, 24 Jun 2026 20:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51F3C6B0092; Wed, 24 Jun 2026 20:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC166B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:28:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3D571404FC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:28:03 +0000 (UTC)
X-FDA: 84916547646.10.F2F24EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1B20A20002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:28:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VH7yQxsm;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782347282;
	b=4FOQc6K2tebCU5Sa4K7+gtbdWSeH7gRISb7j5MSezgspnTnr1SVHeSXFNW+yaJIhwD9RmD
	lzl/gjMY575Ivc6QRDcNnSR4sknPnwyjTZ9rtzU4RclwCbt8ygywh1EDWsHiB8cD7F5gnR
	y/sQDqDayOoRRSjkdfrMng5WZaHBplM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782347282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G2j8yE67H/DwH47l2u2y3HxJcEjscsIq3SIq2Unbn1k=;
	b=dZa/lFp8rz75aGdxVBR0Cus/dF2qIPYGyN3Bbdc3Xu3dpeH4mHPy2HcmQEMlGCNFpIk+yD
	lOsSOEXMs4WJtvoJGa3vtWeP83M3isNrNrHN3tRYgLdpvXjKcrC0LNqKFnM8wOt9kIqVDb
	XZBaFngdjgqIkykg8UFqfbYMmhAKJC8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VH7yQxsm;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0EAE60018;
	Thu, 25 Jun 2026 00:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783851F000E9;
	Thu, 25 Jun 2026 00:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782347281;
	bh=G2j8yE67H/DwH47l2u2y3HxJcEjscsIq3SIq2Unbn1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VH7yQxsmmHXxzNFpXZqI9MMa09EZNg8M9yW3KmCcj0TKRBakaThJKTiZIaphncxiz
	 Ax4k10BuicfqTw+s4gIxpCIcfU5EmaR1SZTmT83WgOtpmjcv9Ncm+HiFPdypx5lyvJ
	 +WlaJFvNi+LTXSq2Tuuu5xmFfRQhSHIjqsy+lsEZLeS7dv7HTPLLeguHg8oDkFiul1
	 g9Mbx3IRM+XvU0Cqih6BFTU917zcQ1NtAdUaVP65lxU6z19NX0ZYVI9NjrfIHknie9
	 HHFZ4Cycp34LjKYEmmRMOfFsNabEOaI5wo+7LbPGh/+ig+2kFzuDG4yRLK1Wn/kn2B
	 e79ZdWLp4pjWA==
From: SeongJae Park <sj@kernel.org>
To: Yousef Alhouseen <alhouseenyousef@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	willy@infradead.org,
	jack@suse.cz,
	shikemeng@huaweicloud.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/writeback: parse help before importing drgn
Date: Wed, 24 Jun 2026 17:27:52 -0700
Message-ID: <20260625002752.96325-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260624123514.7822-1-alhouseenyousef@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8bmwpb1ze65d3sqw9etpihypywces95s
X-Rspamd-Queue-Id: 1B20A20002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782347281-138262
X-HE-Meta: U2FsdGVkX1+B50gowZbetfV5o9gNd0AL6vOXkteIlTD7/7X2CFVDbJpmtEn1LxCyav0AWMdZ6CcAg2Dk+FyFWd1bRZeI/nybExeTMhT9GXAYOKAmoOD/Bcit0D14GrQdKhuMMJ3c9C5MR59CQtrDAuJCp82j0VcaImXC6HG17u46FP87Gz8Rr4m40uaAi4AIPwWDCPJYEvD+uk4lGHrJFVIy5AnwEn/LG+jOrIuZY7g/Dp6IBqFZKXriKq3KTcaaiKgwj+ECIr71RFNd4fHD2fzVTjITWl1PF3B9sfHoE7yr4CJA9fWNBYCQaOMqMHYIIiYzI37PdWXG/ilumkwQXrpI7smSgRQYB6tF69ePWa29OLRCb5fEVLR11Yg1Cs+Z51ujfnqzUPj5JAcuRWWgvemFm2BdRyQn/DeQzKYJys8+ZLKFIBF7xG2vTSbDhm9NQRmsAjuXukPsYbDlcOI/3UyOpayxV3NDzl+IXi3g+xMq9M9WRhfs8QdUjKHPHd8nVrahm2y5a3DfjO086UEU5NlaJ/UHBtIv9q1/qULx949uwnV1WPqfoChL8HlvZoQ972nF+UFqqayuNXe1K0i+enFApzTYb7cC3QiQNP35DMh3VmKqKQx1b/gyY27XXxnfkBVm3U5YoDPrw+WUlsq2o1quwVt/PrXSz8dwg73aijYOZirQ23qqeze2ulXSpl4IX0AiZElDCKZuTU1aQTeidWwJhcmPeP/z1AMiy+t/wjiOc86dKtH2oYVxtiatdwkNNEljq5LJyObDdsZeroi9cSS4G4bgM5xULXG1sErxYTvJk80Dsl6xOrWNqjzPlAiUJTAoC8QhUfDVi7InC+HTdfp5aDjXYDLpdRlZVcgdIltvdzbQHArLS/3sa3s+OLvewFpLHcs4cy4UroaNr7kJBEUlyzx+yvMZxCGBuVxTz2aKwgQ6a9hATp0SEeU2JA3dZZ5l76Nzog0NSaFyvg/
 +gqK2OSP
 DQfpWuPMjFAtJGmG42k7+mIxWo/sgh8gxD4u4WMF/5UzGXZId7kTMpxlDEXMe+vt+8JwpZlL47SIwAD9O8/whWP2ssdfSwuOt1nsH5or6bgwV59ZP8VzwyQ+j60tocCUTyYOtymzEuERlVAKt5JOXbaLHWDdpzhqDskpQTJld3LmJyPwmNYVkmTUr9tJ/uVcTpggHxQohyjE/OtcKZDAm5dYQ/MvwcfBrNybhigsdrkLFbfg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Jun 2026 14:35:14 +0200 Yousef Alhouseen <alhouseenyousef@gmail.com> wrote:

> wb_monitor.py imports drgn before argparse can handle "-h". That makes
> help fail on systems where drgn is not installed, even though the script
> does not need drgn to print usage text.

But...  How do you execute the drgn script on systems not having drgn?  I tried
to mimic the situation and reproduce the issue you are saying about, but what I
get is like below:

    $ sudo mv /usr/bin/drgn /usr/bin/drgn.bak
    $ drgn tools/writeback/wb_monitor.py
    -bash: /usr/bin/drgn: No such file or directory
    $ python tools/writeback/wb_monitor.py
    Traceback (most recent call last):
      File "/home/lkhack/linux/tools/writeback/wb_monitor.py", line 44, in <module>
        bdi_list                = prog['bdi_list']
                                  ^^^^
    NameError: name 'prog' is not defined


Thanks,
SJ

[...]

