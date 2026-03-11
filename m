Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22DA8103E2EF
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 23:03:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4506B0088; Wed, 11 Mar 2026 19:03:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3520E6B0089; Wed, 11 Mar 2026 19:03:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25DB56B008A; Wed, 11 Mar 2026 19:03:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 13E4C6B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:03:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80EF71B7D6A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 23:03:47 +0000 (UTC)
X-FDA: 84535311294.08.402858E
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
	by imf25.hostedemail.com (Postfix) with ESMTP id 34C8DA000B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 23:03:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=ideasonboard.com header.s=mail header.b=WxcdvAR4;
	spf=pass (imf25.hostedemail.com: domain of kieran.bingham@ideasonboard.com designates 213.167.242.64 as permitted sender) smtp.mailfrom=kieran.bingham@ideasonboard.com;
	dmarc=pass (policy=none) header.from=ideasonboard.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773270226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=33EAGUBLBYod3tzyGg7m09477vqXsAXQIQrUfRFHjU8=;
	b=iw8Cz2DlQYr7WI+XldNftTIeOUZHVaja2B95B7OGoRFOHrflNVHIgGsCj6u2Cti87OFpDX
	VkWwKpnrfPLr4josgnMMBMNf1WPR9gS0zfduuhNTN4LR4GL74qE/ZgWgt02m3L7aVcYXNR
	+Hru15Pd/WLEYtv+tojWVOjadYHr/Pw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773270226; a=rsa-sha256;
	cv=none;
	b=DDr+E897LjHy5AUk/q4BRcNP6owwDEIZV8JHevYsCdKw7YNtZuq8WmMz+ce+VqctFYXL6S
	sp9SnZGUrbjggqIuvJIaEk9EbdCOBY/7G+eaPuMlKpkOsUY+9asmdbF1voxUg68LILdXrx
	BC8JasOHFJ1/ws55GXgCr00y8yLAbdc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=ideasonboard.com header.s=mail header.b=WxcdvAR4;
	spf=pass (imf25.hostedemail.com: domain of kieran.bingham@ideasonboard.com designates 213.167.242.64 as permitted sender) smtp.mailfrom=kieran.bingham@ideasonboard.com;
	dmarc=pass (policy=none) header.from=ideasonboard.com
Received: from monstersaurus.ideasonboard.com (cpc89244-aztw30-2-0-cust6594.18-1.cable.virginm.net [86.31.185.195])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id CD91E448;
	Thu, 12 Mar 2026 00:02:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
	s=mail; t=1773270149;
	bh=ATo3aRyKmYSXuSYD8x/NeBUp5LJcLKbzHVpozNXQJC0=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=WxcdvAR4zphcUuTNTLXCbLGiiCOKCwemLRMbnRdmW3ARcBHAWQiYVeysDpnfCIDuk
	 B8rMCjKjDjoWJdgj4Zp0scfHxrPnr5P3xl9hFANY/wyWKZBZYHzyf2qsFxVEe9S31Y
	 m9r/HjFnopry9bsUUdk6/id/Q3d97jYK/FiMa+Qw=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260310-b4-is_err_or_null-v1-49-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de> <20260310-b4-is_err_or_null-v1-49-bd63b656022d@avm.de>
Subject: Re: [PATCH 49/61] media: Prefer IS_ERR_OR_NULL over manual NULL check
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@kernel.org>
To: Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org,
	apparmor@lists.ubuntu.com, bpf@vger.kernel.org,
	ceph-devel@vger.kernel.org, cocci@inria.fr, dm-devel@lists.linux.dev,
	dri-devel@lists.freedesktop.org, gfs2@lists.linux.dev,
	intel-gfx@lists.freedesktop.org, intel-wired-lan@lists.osuosl.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mm@kvack.org, linux-modules@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-phy@lists.infradead.org,
	lin@kvack.org, ux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
	sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev
Date: Wed, 11 Mar 2026 23:03:33 +0000
Message-ID: <177327021364.3167621.11851238159935183684@ping.linuxembedded.co.uk>
User-Agent: alot/0.9.1
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 34C8DA000B
X-Stat-Signature: psyjbukm6jk6uuw59itguopnp7uyihcx
X-HE-Tag: 1773270224-596993
X-HE-Meta: U2FsdGVkX184V1XAcHGSd3N73j/SvcYcEN+uz5e1NZ1gzGFlXelaMTCfYj2cAXoS0woxChSRtMPik+sKATVo+PhVlDm9g7ACZq5SjTS2LqFdV+OrKFaRKXcTGoSYopsi9LO8llP5nt/mIJUsXig79wYLq2g43NfHpUm1H72qMgvdiLbnZUXzoDbLbzGCKdrSLUFafsQzKkJuTMrVUJzXVQPWqBF0NC2IZCseOjf6lM8y4OP1EHOpqXdd/WSsaEgj45bZtSCO78ksO23SV7I8PqjFgFd+EWbfwy2Ea/WiOPLrEgfkuWUjIjyGy37XjuBTQ8NjRTK1G3/CTJOCXO/sBFgf8085oO7jpMp9DFIxRAa11mQCOy3rbzCS4zf70PgXgSbOavbUdEUhPk4FfYbjUrVlbDwTudDyc9on3udoxCNvyAmus6aEluQEuofycMyiEgzXvJUWgr5xlGL8jqvwPRYuINKYFAB6jgkT4Bn6mbITpIzzOdaSYizkktvuLecg74KpiRxqDQ20qJHjlT+8zPIx0iRpgpU/lbczPLqTMUbsMVdzo3troGH3SYE90HaFwtk9pDaDoe8ACCsiapEvAmbKVB1fGTgeptQ/1TgGxgKBQiX7NPSuGncvtd1Ea/o2RuwPFu2CH5s9ONKm9nt8HDBFJXedDsJRVeB3QFzHQdwg4cdk8q5Huz+9a0IGyxx4m4BrX8TIDasEgC2HP+QcPShP0ZrsK1S/bxgNDdYszHZcNniR/pIU53gxw0gUWfsl43i4I4A45a20QpEtYCBglsn5D8Cu+QfxVaFP/+QxR/FkkWu9rtb54m311cEMXm8acU3TmqK0HjW3dZ0TrKV2SwHUW9SdkN2mxY5EgUc5XV4VXeP/G8oDqvjdEZiw6NOcrfordotTupU6wYHnUyPG0JfmG2IiQLsCalcuZWF4WoY1WNgImJcezMfuS48mnhm5mBvZ3cfp8dnMBjSLZNR
 ZAiafVrY
 KIk4rE8hjJHRkOacXR7dpy0frEW7AClBCMkmAXDyCs+J4iGVLF9TMyxJ0wfi84GHnxjihXTCVfyo32/CD+2QJLBs8i15L7eHj3Z6BS4nw7BCHiEJ/nc28b4t2aZxFw/jwEh07WZNqnfucgUmwpdszl7ZDKGwr8QCO4VHllZm2q+vwUXsGBelMiG5+2IGFVPjF74rZuc+OM+vL5QEVavqRDpUAMO3txt4s7bK/U+Z+3RI/Lmd1IYJ17QMydCB80zBwhtjNn/b0kxOiCwaDTdxkxB280hstzozotpDnsZwxzjcOBdZ1U8Me3wMytVlmi6cMazl4lH/mJPr9s6vifDHMDrAzCIZvvReMiEsatz+GyOXtM58rYgt6pwJ2jWf5Mk96RjtAlqtotgIvLGWkQIMKsGnIoxqmlllyyWvP6yLs84UtR4AGRW2zscgQJahDA9O6aRk4cXX1SkAywjHsqe1ivaujvVEieqOGKGXkrP0KnLnZQec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Quoting Philipp Hahn (2026-03-10 11:49:15)
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
>=20
> Change generated with coccinelle.
>=20
> To: Shuah Khan <skhan@linuxfoundation.org>
> To: Kieran Bingham <kieran.bingham@ideasonboard.com>
> To: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: linux-media@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
> ---
>  drivers/media/test-drivers/vimc/vimc-streamer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/test-drivers/vimc/vimc-streamer.c b/drivers/me=
dia/test-drivers/vimc/vimc-streamer.c
> index 15d863f97cbf96b7ca7fbf3d7b6b6ec39fcc8ae3..da5aca50bcb4990c06f28e5a8=
83eb398606991e9 100644
> --- a/drivers/media/test-drivers/vimc/vimc-streamer.c
> +++ b/drivers/media/test-drivers/vimc/vimc-streamer.c
> @@ -167,7 +167,7 @@ static int vimc_streamer_thread(void *data)
>                 for (i =3D stream->pipe_size - 1; i >=3D 0; i--) {
>                         frame =3D stream->ved_pipeline[i]->process_frame(
>                                         stream->ved_pipeline[i], frame);
> -                       if (!frame || IS_ERR(frame))
> +                       if (IS_ERR_OR_NULL(frame))

Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

>                                 break;
>                 }
>                 //wait for 60hz
>=20
> --=20
> 2.43.0
>

