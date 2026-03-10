Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1C88FD2D6C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 12:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37C7E6B00ED; Tue, 10 Mar 2026 08:43:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32A896B00EF; Tue, 10 Mar 2026 08:43:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229236B00F1; Tue, 10 Mar 2026 08:43:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0E36B00ED
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:43:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7842B58F5
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:43:48 +0000 (UTC)
X-FDA: 84530120136.26.97731FA
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	by imf26.hostedemail.com (Postfix) with ESMTP id 993EB14000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:43:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of p.zabel@pengutronix.de designates 185.203.201.7 as permitted sender) smtp.mailfrom=p.zabel@pengutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773146627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9nwSoyBFb/J+scDlmZ8YZ+1mFs6NH+0TsiNWJNlzMqA=;
	b=HRH33eMbUC5cxtC1IEp75riRiQavHZVYcuIP/B+WhnHiq6D6Sy8/kQK3Gqrq5Vbw+8skkU
	taicQA4RakkVAaCEO0gm6ChqsGfGFrS7g0ldADCduY1X6PMC8oDuesjWpQQXlkNxSlmPz5
	cjdsdjypEIKz3zx/gcgkgYiAyPU6rrU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of p.zabel@pengutronix.de designates 185.203.201.7 as permitted sender) smtp.mailfrom=p.zabel@pengutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773146627; a=rsa-sha256;
	cv=none;
	b=ycxWRFwrBdW+6RLfLNIyYvLWRcYB3vyqEK2a8d8Si9kvs+I4U6J3LXjT4F29r4tZL/TejF
	0DtbrbvJpgmg2x1BQ7TY2p5VFCuCLPKGdGpEB8SKNFlN7uRaKe+CQzO6rw8CkYK+VtU/Ke
	ppxiWITL16U50qR4+0QEHdsMArPMfDk=
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <p.zabel@pengutronix.de>)
	id 1vzwQv-0006Oq-0m; Tue, 10 Mar 2026 13:43:33 +0100
Received: from lupine.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::4e] helo=lupine)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <p.zabel@pengutronix.de>)
	id 1vzwQr-004hMj-0z;
	Tue, 10 Mar 2026 13:43:30 +0100
Received: from pza by lupine with local (Exim 4.98.2)
	(envelope-from <p.zabel@pengutronix.de>)
	id 1vzwQs-0000000081v-2556;
	Tue, 10 Mar 2026 13:43:30 +0100
Message-ID: <ddaacda48df23fb2c009a8727518300ed2b82cb2.camel@pengutronix.de>
Subject: Re: [PATCH 57/61] reset: Prefer IS_ERR_OR_NULL over manual NULL
 check
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org, 
	apparmor@lists.ubuntu.com, bpf@vger.kernel.org, ceph-devel@vger.kernel.org,
 	cocci@inria.fr, dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
 	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
 kvm@vger.kernel.org, 	linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, 	linux-bluetooth@vger.kernel.org,
 linux-btrfs@vger.kernel.org, 	linux-cifs@vger.kernel.org,
 linux-clk@vger.kernel.org, 	linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org, 	linux-fsdevel@vger.kernel.org,
 linux-gpio@vger.kernel.org, 	linux-hyperv@vger.kernel.org,
 linux-input@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 linux-leds@vger.kernel.org, 	linux-media@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, 	samba-technical@lists.samba.org,
 sched-ext@lists.linux.dev, 	target-devel@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, 	v9fs@lists.linux.dev
Date: Tue, 10 Mar 2026 13:43:30 +0100
In-Reply-To: <20260310-b4-is_err_or_null-v1-57-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
	 <20260310-b4-is_err_or_null-v1-57-bd63b656022d@avm.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-mm@kvack.org
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 993EB14000A
X-Stat-Signature: jnkzestnpg9nz7qzt4xb3b4u6yppcgr5
X-Rspam-User: 
X-HE-Tag: 1773146626-930744
X-HE-Meta: U2FsdGVkX18mdqbv2ZeW/tYgoClPgXbZa1WJalkHvAv6lFpaNp+XO0LdRBlAEHvWT14aimfWAhGBKnqHCqHNXz8KsPnr/CAj7xOjcALBqNtKnghZgB/5hw/HP9cWMtY6VxtWmU+R9HoXHXeFW3ifHg9thl7y6ixYA7Ub0UScmKDPfU1bpNPiqzEeGTqWjD2u3UnCE2a3QILm0YcUNsr+KmHi9kgjS9sq0oeH2ZVzLP41p0CITzuerVKFpd8FBMXpz3nW7ovKRhLv1iEMapplK8LD5+BArmeI0jxIe/Dy+2hfOMvxL611rLglxN2K6EtBPr3hp9iAXdwii3X6gPSZvyRhWhsZah6OTCUxlvTGba8Smje1sJHkPUpsoJJCdON9mMfKTjMwfuR0Ho88D/HMmopZNUWZ5OP/0jNtXhmwbOCSEXxfm3CMjB5f3JlnUcoEL7Ij/3DE9ThXLkmXHziTN3hJgfbcPDbOPGFWDu5ECp2KnxXCwL/4k3TRoevEwgrsrpNzC/w+n/jmlR/3zgPlX9ae9yChlKoH1fe2Xxz4W4gMjwjglHYSW12TsQFLvYOUrcNcCa1cv2SxV012NnSTpu80/Ej6cBaZRDf0LTa7t0dBS+yzKG5Ie3ZSd/4EnjO2gPTqJi8Lz6E5OvuEeqjhNbnbaVVQxfIg1mFlYt5iAokxl4kVVIi1WBFhv8qZuaB0k+NEkSE0Eohf6UbT+8rdyQ8eVckY8ZsNcAqzx+y687EhQywPxoEzk70qbmVNybjYweLCoC6iiRTd8Y3mW1WIZYTlLrKBv23asUNVRuhk/6Mn+xL5A/f+nsrnO8z+0rMy4J5k3SYWp6X2xYgz11Y5mZ+hqdn0Bj0zOD5rSPnaFjUfiZngdXMnkxf6833kZTvKGJTlwvWjxUTTR6wazvuuKe71ic9XcqR4ncuF0xxdWqCZ6jyEKu9wmUoClOLM12XlWbI6pYT7+7RyjpODqKz
 LHDkFHi2
 6zd02x8fL2r33Ys0yz7lODsfh4zswZWtmqXmF0Gb7dKcpAQc3SqeDmglmTDpkqg/oa+GzUc+QXpsFtGbhLRzEJTQPaqqJIC3VSl2V719DVc/KnFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Philipp,

On Di, 2026-03-10 at 12:49 +0100, Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
>
> Semantich change: Previously the code only printed the warning on error,
> but not when the pointer was NULL. Now the warning is printed in both
> cases!

No, rstc =3D=3D NULL is valid (for optional reset controls) and must not
throw a warning.


regards
Philipp

