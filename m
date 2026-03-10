Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69E35FD2D98
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 13:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93B8A6B00CC; Tue, 10 Mar 2026 09:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BEFD6B00CD; Tue, 10 Mar 2026 09:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA986B00CE; Tue, 10 Mar 2026 09:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CBDB6B00CC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:56:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A547B5EDA
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:56:05 +0000 (UTC)
X-FDA: 84530302290.04.120FCB9
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3DFC81C0002
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:56:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of hadess@hadess.net designates 217.70.183.201 as permitted sender) smtp.mailfrom=hadess@hadess.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773150963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=765ZgLXaPzReFoXtpkbv3MYN7L9J6JKDHvE8MxWus3k=;
	b=dkkUvWdcc0zFIAUS8mJg2kJW7M6rqaaSHfXNgwrlrPpvR3TPyBLMjmPZF7LyOJwJVa+Gyw
	MThDo4lxibaFWdgki1AbWdqiUr5Ksmye+na03uZRqPXAmLkzrcDs6WPma6IPqooHuT3sba
	6y8hX/EnOqlW2UKh6/DKM5jfSKNEd8E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of hadess@hadess.net designates 217.70.183.201 as permitted sender) smtp.mailfrom=hadess@hadess.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773150963; a=rsa-sha256;
	cv=none;
	b=JxfX388YAWI89WbsAIxmu/98ry2UnmSWFoSG9jJe2USVj31MKV/flNidryOCGAUy7gH9JP
	4Q4y17q2GGkMIKXb5faF0Gw9d1DKkS1iJtx8Vl6YKao/rVwaZPFp9QekJmVbPITF1TuF21
	0s2Gi7deyjoi/t+o3mjHVeaHXIcF/ds=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 539B3433BD;
	Tue, 10 Mar 2026 13:55:53 +0000 (UTC)
Message-ID: <375c7c30c184d331c199876e45920976030f3cbc.camel@hadess.net>
Subject: Re: [PATCH 25/61] net/bluetooth: Prefer IS_ERR_OR_NULL over manual
 NULL check
From: Bastien Nocera <hadess@hadess.net>
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
Cc: Marcel Holtmann <marcel@holtmann.org>, Johan Hedberg
	 <johan.hedberg@gmail.com>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date: Tue, 10 Mar 2026 14:55:52 +0100
In-Reply-To: <20260310-b4-is_err_or_null-v1-25-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
	 <20260310-b4-is_err_or_null-v1-25-bd63b656022d@avm.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-GND-Sasl: hadess@hadess.net
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeduudelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkuffhvfevffgjfhgtgfgfggesthhqredttderjeenucfhrhhomhepuegrshhtihgvnhcupfhotggvrhgruceohhgruggvshhssehhrgguvghsshdrnhgvtheqnecuggftrfgrthhtvghrnhepieffgfehtedtgefgjeeggfffgeeuvdegveekveejfeekkedujeehteffueefffeunecukfhppedvrgdtudemvgefgeemvggtjeefmegtfhdvtdemsggrgeefmegrieejieemtgdvugefmeejrgehfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpedvrgdtudemvgefgeemvggtjeefmegtfhdvtdemsggrgeefmegrieejieemtgdvugefmeejrgehfedphhgvlhhopeglkffrvheimedvrgdtudemvgefgeemvggtjeefmegtfhdvtdemsggrgeefmegrieejieemtgdvugefmeejrgehfegnpdhmrghilhhfrhhomhephhgruggvshhssehhrgguvghsshdrnhgvthdpqhhiugepheefleeufeegfeefueffpdhmohguvgepshhmthhpohhuthdpnhgspghrtghpthhtohepheejpdhrtghpthhtohepphhhrghhnhdqohhsshesrghvmhdruggvpdhrtghpthhtoheprghmugdqghhfgieslhhishhtshdrf
 hhrvggvu
 ggvshhkthhophdrohhrghdprhgtphhtthhopegrphhprghrmhhorheslhhishhtshdruhgsuhhnthhurdgtohhmpdhrtghpthhtohepsghpfhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegtvghphhdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegtohgttghisehinhhrihgrrdhfrh
X-GND-State: clean
X-GND-Score: -100
X-Stat-Signature: hpa5irczwx4wrnj5hbfbk7o58ccsxxw7
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DFC81C0002
X-HE-Tag: 1773150963-816775
X-HE-Meta: U2FsdGVkX18J13CTl/XNXCt0g1sUyiWPv4h4v2BQmaS51fk3byLYa9rif7l562GqAE/TDFWhjpvoA6OtpD8xXDyJc75QHnpnXAaxKe1dyyAFIlVrFY+Q2x0Z2ipZpDVJ46c+6fNXwLlkzbqu/ixbrBsFsK6Sun2RiQadZpkUrr1k1wkfYkL+edZCUVTnhWOIOv903rnBxZRe/5srC1hk+cfjd8iVUZ01/JC06GpuaNUKc3J23CyL9es+KoIih9AlFNemM1JYD0HgfzbnqYQKTZErerEyKstB1Nn7XOxX3RA+MycwXJq6GQMhzGQ+tEnLa/7n7Y4+LB7tdXxXn4fm6z4s1936h5W/HBWdjZ51EaGjZNV1K4E2CZC4QQeHaVZ1hliILZcKRjW2WMBAnetb2uHh6tqSzUpO7Y40CYtCJ0YoCs9Gcy+4FIQArj+H0GweI97Q/7KaXtOEh5SUU4wiUhWBicKc+KiDF0iX+e3pjxJeNk++5GhoWLmuoEbrUN1re28cVpoImKN5wXsyYWCNudAs8+OqKJZT8TEEA1at88+MZfYrK5KIn00NPBIyT7oMZ2ujexvkN+dUOqKC3sDSMp3LXDPXVG9e4woO4o4LuTx+TSb6Wfl0uvRhjZ5fRQ/abqEvAJs3QQwUahCN2hfpBki02tEEKRx52DFYIhgHzZO+tAFjYuYzlG3V/XUbNfPp6AenlA7ymC7vrkjxMK5zXGNnydnjRMG3vsokXYLyqPmQLrhUggONgjJ3AMMKkiVSn0F7zpUGCoFYUYqWLBGFNafdaza22AGsxzVrWXbCKVkMPg4wUKcrKuXoy5yFPgGfsmlGQcAZFzSJSkRTwWgrKA5tbPM7edFzvS6yTzbXRsgXFEjg2NaT5ujx8yLiQmvi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-03-10 at 12:48 +0100, Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
>=20
> Change generated with coccinelle.
>=20
> To: Marcel Holtmann <marcel@holtmann.org>
> To: Johan Hedberg <johan.hedberg@gmail.com>
> To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> Cc: linux-bluetooth@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>

Reviewed-by: Bastien Nocera <hadess@hadess.net>

> ---
> =C2=A0net/bluetooth/mgmt.c | 6 +++---
> =C2=A01 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index
> a7238fd3b03bb54f39af1afee74dc1acd931c324..06d2da67bbe14e17ee478aa939d
> e26526c333d91 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -4169,7 +4169,7 @@ static void set_default_phy_complete(struct
> hci_dev *hdev, void *data, int err)
> =C2=A0		mgmt_phy_configuration_changed(hdev, cmd->sk);
> =C2=A0	}
> =C2=A0
> -	if (skb && !IS_ERR(skb))
> +	if (!IS_ERR_OR_NULL(skb))
> =C2=A0		kfree_skb(skb);
> =C2=A0
> =C2=A0	mgmt_pending_free(cmd);
> @@ -5730,7 +5730,7 @@ static void read_local_oob_data_complete(struct
> hci_dev *hdev, void *data,
> =C2=A0			=C2=A0 MGMT_STATUS_SUCCESS, &mgmt_rp, rp_size);
> =C2=A0
> =C2=A0remove:
> -	if (skb && !IS_ERR(skb))
> +	if (!IS_ERR_OR_NULL(skb))
> =C2=A0		kfree_skb(skb);
> =C2=A0
> =C2=A0	mgmt_pending_free(cmd);
> @@ -8277,7 +8277,7 @@ static void
> read_local_oob_ext_data_complete(struct hci_dev *hdev, void *data,
> =C2=A0				 mgmt_rp, sizeof(*mgmt_rp) +
> eir_len,
> =C2=A0				 HCI_MGMT_OOB_DATA_EVENTS, cmd->sk);
> =C2=A0done:
> -	if (skb && !IS_ERR(skb))
> +	if (!IS_ERR_OR_NULL(skb))
> =C2=A0		kfree_skb(skb);
> =C2=A0
> =C2=A0	kfree(mgmt_rp);

