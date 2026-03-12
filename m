Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6D99106ACDF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C47A26B00A8; Thu, 12 Mar 2026 15:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1BBF6B00A9; Thu, 12 Mar 2026 15:33:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFD946B00AA; Thu, 12 Mar 2026 15:33:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A089C6B00A8
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:33:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49090B942C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:33:49 +0000 (UTC)
X-FDA: 84538410978.29.4AEBC8A
Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	by imf21.hostedemail.com (Postfix) with ESMTP id F3E721C000D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:33:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773344027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VQ4I1//oujMg/wMbvtHZ1fNg62i5rEhIWcPKRohhj4U=;
	b=DIZ5GSqVJZ/m9cUVN5UPfPtfB9byrZmpo3U9W0YlxxWpaV20fH+Ldlgnu9xXH+eVe+N2Tg
	miUBMuICRYgrpDl2ZwZ19do/tYgxLOnpOP2bdPPXhT6Gg4RT+NGBCF0HdC0nFptPDm14Ep
	ayaMBR4pjA9VDixjTW8VEgVyCJP4jeQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773344027; a=rsa-sha256;
	cv=none;
	b=5+iqbacqrIZhnxC0O41gxkP9MevmVR/KuVb9phR83L62+qBriBxmaHmJttUxaJk42loVE1
	r4Ffzwz48cOBGaBJuCTWOJ+anCo9wArtnGWKHfzFAMhKhKURkYCRUKIjdhE1o8CsQaWrsr
	JZ1hc1vqB9wdwX7u1lhpoYYUiiTLY/c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 4DE582C14A8;
	Thu, 12 Mar 2026 20:33:44 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id yCwNT8mwVvHB; Thu, 12 Mar 2026 20:33:43 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 8A34D2C14AA;
	Thu, 12 Mar 2026 20:33:43 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3HN7guaAFMsE; Thu, 12 Mar 2026 20:33:43 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id ABF4A2C14A6;
	Thu, 12 Mar 2026 20:33:42 +0100 (CET)
Date: Thu, 12 Mar 2026 20:33:42 +0100 (CET)
From: Richard Weinberger <richard@nod.at>
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx <amd-gfx@lists.freedesktop.org>, 
	apparmor <apparmor@lists.ubuntu.com>, bpf <bpf@vger.kernel.org>, 
	ceph-devel <ceph-devel@vger.kernel.org>, cocci <cocci@inria.fr>, 
	dm-devel@lists.linux.dev, 
	DRI mailing list <dri-devel@lists.freedesktop.org>, 
	gfs2 <gfs2@lists.linux.dev>, 
	intel-gfx <intel-gfx@lists.freedesktop.org>, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
	kvm@vger.kernel.org, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-block <linux-block@vger.kernel.org>, 
	linux-bluetooth@vger.kernel.org, 
	linux-btrfs <linux-btrfs@vger.kernel.org>, 
	linux-cifs <linux-cifs@vger.kernel.org>, linux-clk@vger.kernel.org, 
	linux-erofs <linux-erofs@lists.ozlabs.org>, 
	linux-ext4 <linux-ext4@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-gpio@vger.kernel.org, 
	linux-hyperv <linux-hyperv@vger.kernel.org>, 
	linux-input@vger.kernel.org, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-leds@vger.kernel.org, 
	linux-media <linux-media@vger.kernel.org>, 
	linux-mips <linux-mips@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, linux-modules@vger.kernel.org, 
	linux-mtd <linux-mtd@lists.infradead.org>, 
	linux-nfs <linux-nfs@vger.kernel.org>, 
	linux-omap <linux-omap@vger.kernel.org>, 
	linux-phy@lists.infradead.org, linux-pm <linux-pm@vger.kernel.org>, 
	linux-rockchip <linux-rockchip@lists.infradead.org>, 
	linux-s390 <linux-s390@vger.kernel.org>, 
	linux-scsi <linux-scsi@vger.kernel.org>, linux-sctp@vger.kernel.org, 
	LSM <linux-security-module@vger.kernel.org>, 
	linux-sh <linux-sh@vger.kernel.org>, 
	linux-sound <linux-sound@vger.kernel.org>, 
	linux-stm32 <linux-stm32@st-md-mailman.stormreply.com>, 
	linux-trace-kernel <linux-trace-kernel@vger.kernel.org>, 
	linux-usb@vger.kernel.org, 
	linux-wireless <linux-wireless@vger.kernel.org>, 
	netdev <netdev@vger.kernel.org>, ntfs3 <ntfs3@lists.linux.dev>, 
	samba-technical <samba-technical@lists.samba.org>, 
	sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
	tipc-discussion@lists.sourceforge.net, v9fs <v9fs@lists.linux.dev>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, 
	Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <1584421372.26258.1773344022512.JavaMail.zimbra@nod.at>
In-Reply-To: <20260310-b4-is_err_or_null-v1-48-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de> <20260310-b4-is_err_or_null-v1-48-bd63b656022d@avm.de>
Subject: Re: [PATCH 48/61] mtd: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF148 (Linux)/8.8.12_GA_3809)
Thread-Topic: Prefer IS_ERR_OR_NULL over manual NULL check
Thread-Index: 0l8CyewQmrWlgaG6N3QgQFfukutRbA==
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F3E721C000D
X-Stat-Signature: 6p7jb57nuhgjia81yd8r79upjigi7a8r
X-Rspam-User: 
X-HE-Tag: 1773344026-394769
X-HE-Meta: U2FsdGVkX18fgzFZZ+X3Dqw1Q6dZB9LQkt5jwvp39funDEC/P+AYuTW6Y6kmMXJ7V9EIutXAEY9IBBIsL0E/zi16XdzyHkv+rDmR15X4gQ5pTG1RGVsG+XoxACO8J0jRSSlT1YFpCF5r+aXCXloDi5alpBiYRnT/M9KtviTnQVSF60fyDQLx89LDv7wed+/NxDokMTNGlkgASaHlutoTus281ekZj3wFIS9/8Igk2RXQFJz/x5Qyyn+OXwfDdvG+H1FzUG+O27ii3cjUsBFzolkIjUu145ZGv5BaKBMNlJGH/3v1gl47W5pIDOby7pOLwO9Z1Eso7+sJcxOAH55Hy6yum6zDHRnGLoNaIEDh15FBIwiXpuGjgZovUSfzbQyMJliOY+RyRsV97zeGQVwbMHyoCU+wXSJEfqn3AKuRdWPt72EU+ADjahgSWa37mikPawwGsqdVzSg2B9rFwKmTS5bfngcWydOSHfzLXdTKmj2/kcaZ1Ok/sl4Sk0N7KmfPZ0SOrjS0KNXOtqApeVM/4yahWOfGBSrla71TDrEuZ9c9Cx2ZawCozAkuriWl7gn3sX8ryYVtX9ss6XnAb1LEfmxXAQILw7nYflfc3qadNzEM0XL6iKii0XPOA1aPaZNVUFd8+JkAKD+PLuCP3DxgN2a7kUaDgvfBMMEyrRAT00N+6dMuPjHf22mAsy8yejr9udbogT0KL+sFwzGurz1NAbhzxKvB82N2MxmUuGjEWGlgr0JOGGPenSoVYgOqI5IkgLM1ma61Iy7+52bRuReuIrJSAi0ovY0fh99UPRpSvRlTVVgjTfo6ys0wVwS1vsCe7wtRgkwXl91EY+8E7HvqaDshqxsqoWXZRj2Dn8vWK2cVOoXbFerU0Ya31G1LLcK3fV7uATa60ck7YoVEaTvnba7ppfK/bAHoR5bCv4MeQ2Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

----- Urspr=C3=BCngliche Mail -----
> Von: "Philipp Hahn" <phahn-oss@avm.de>
> -=09if (gpiomtd->nwp && !IS_ERR(gpiomtd->nwp))
> +=09if (!IS_ERR_OR_NULL(gpiomtd->nwp))

No, please don't.

This makes reading the code not easier.

Thanks,
//richard

