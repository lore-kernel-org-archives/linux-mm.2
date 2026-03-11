Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3EF0FD88D6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 00:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 247B36B0088; Tue, 10 Mar 2026 20:16:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CB536B0089; Tue, 10 Mar 2026 20:16:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 077346B008A; Tue, 10 Mar 2026 20:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D2A816B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:16:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5DCDD13A9E4
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:16:31 +0000 (UTC)
X-FDA: 84531865782.25.E649D3E
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9A9DE180011
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:16:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=v5WQ+aGF;
	spf=none (imf24.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773188189;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+5qjaihAOE3Wva2YLY8jATPGvyCa7CiJLk7V/SbO+c=;
	b=6xWTKeovvMj7Qt8ZQ/6ShhuNkDrSD/R7vBI7TaRp3daZZiNBRjET3O34NJP97DvBGgldo6
	Ndm15qZ+B0zSrus4V4cNUSS6QW8uuKgmBus7ka+sphfS62ePBlaMtK0u4Nrklbdnp5N4pw
	ag+xCOy2ZpeqM9CsE1wDrt+cU+ZVZqo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773188189; a=rsa-sha256;
	cv=none;
	b=ds3rYkCBC500A1UmzybUUb/FsoQsxqnN0K2a9Q9PQID8xOXyUoOsImqFbZQca1IcF1DU55
	0UpCCnNo0ef8Iq7orWXI6vRXWq3AGRTYe8XQsRmUBWLl3s+CDyEmMT4EZ+5m54SnODC5gk
	SW+mrU8FKRMUAjDAWhTy0WJ5QgLXO+Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=v5WQ+aGF;
	spf=none (imf24.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=G+5qjaihAOE3Wva2YLY8jATPGvyCa7CiJLk7V/SbO+c=; b=v5WQ+aGF0sps0WNhC7Zp3i4qfq
	0Hb0SCVWpSXvSr7WdAe2bPHF4KfJ/Ed1eiaiCb8D0oCv1z5xwK7JuLf0tC0l8hY2t6eWn1tcNZSpg
	QYrAEXTacs2n4b4dGxTmR/QZFsu7Xre8GI0M2CDH+d6uoN0gFUU9MJ/Uqp3GyqqaO1XmybhsS5lVz
	KPXBqq6BLZCCQzpQ8jMEzm8MnKJZE/MMCDQxbCe0qlHGv5pHIS812K52VRhLCysEP1IhQjrayukQi
	lGpFnxogge7mHLP+wP8QrSVC+xUyVfKJNzw96REdhpsHijJHvcSndISQsei/F/gJP6wWuF34GUcce
	0I/0wllQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55974)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1w07FF-000000005dP-41aF;
	Wed, 11 Mar 2026 00:16:14 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1w07FB-000000005hj-1vhz;
	Wed, 11 Mar 2026 00:16:09 +0000
Date: Wed, 11 Mar 2026 00:16:09 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr,
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
	sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev,
	Igor Russkikh <irusskikh@marvell.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <mchan@broadcom.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Iyappan Subramanian <iyappan@os.amperecomputing.com>,
	Keyur Chudgar <keyur@os.amperecomputing.com>,
	Quan Nguyen <quan@os.amperecomputing.com>,
	Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 38/61] net: Prefer IS_ERR_OR_NULL over manual NULL check
Message-ID: <abC0Se_cstwTWp9r@shell.armlinux.org.uk>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-38-bd63b656022d@avm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310-b4-is_err_or_null-v1-38-bd63b656022d@avm.de>
X-Rspam-User: 
X-Stat-Signature: yzqrex54uyr4abbgfjzsfiwjs537giea
X-Rspamd-Queue-Id: 9A9DE180011
X-Rspamd-Server: rspam03
X-HE-Tag: 1773188189-583068
X-HE-Meta: U2FsdGVkX1+2ckxtuQU1GJrFA0/UTzZFdio4GD0ov7gvEJVmp8ClniLhFB01rWnUiu65A6TAgVFLKo2hqeK6Adrg20cCHLT99xHYPDDuPzoBhdc+bI/Fpyi9gh+3Kw4zixgcU+bwRPZ8bOW5TcTL4Xsix5mswcaTmSERzBA2CRFdHzqwIAejZYa/morsHhg0maSXCUXX75P+fpIlTyrYMCqvhrd/tiZl4V/FGp6ebNm1nOb+o27EiA8XvdzCBCgevyuYenfIuF9xsdhEiRYhGB/QfuhOsaGueTLbPrWb8+Gbu5gAqn+Gm8t9jOOYIkwNXN1txBACUGhymWayCcppSOrm5v/N9CKQYgEzJUAy+Ju1WhUAZPeCLC7eJSVm6GAFpBeBUxwpkQLhMYnqRoWJfguInRjV7KQAxmuRlniCfiqXZTb4Hsjjg+al6pmyi6AaxX1kEBKQvnO1KPAS7zWnWM8BI4Myn1akaIMWib3AH3Vh5xXkBFOw99pBKURvgBYm4hXEkYmqk+u3kapAqSpoVlhN0lbiVPtCW5URWvJ9VsCgPhsTau9P+X6OWbWFKKkUZvO8TbI3Ylgbix8kPV/CE1Fx4VWJHBoOov+Ad6JsXCTJla3/jE5gz3fybNKvHCOJrB/pF5gRMPX8ngx+lGkr5lsB1e+OKwdUFKgb0ig56KqUEvGOs1MXIUm66qnO1tJ+4BybpoH8g4VqutliYL7tpUTYsvCRLif9+EJBr0SGBE+zNUSVQalqJK0Eodzh3tlQm/oH9uY3JpTelHxp47geTE3SXP6GEfQUbbDak8EQfMEZcKPaEK2xkTPl6HMm6J9VY1w1Crd2jC6vNrvqQX0RVS2sYic/OTsD8DM3XL/lgA9suAKc9NEdH7Ef2oB3sRDeUu/Eim1i1Es2W3CIrVckHkZvizGmclnQFbUwAVfkzwBL6SGIQhfmEzkeJyHtV/0nVFNfhj0Z8Hgq+pg+gju
 rYQ7azFX
 eEvc9hwBiimlEUx/09tJojQCzPvSQwPMQ3jnOL8RrUBhq1UqwbKktKUIJmn0hdrEdz8r2ji3D5LreTWJLzG6KlVjuFA9vrEndbq+YGFhi0RP/H9+dddqZp9/elGtOcN1LthyqjEQyfxVXwAbJjhUSCBytSbmEQMyqcV5hfsDJXBrlmHlfeyR3hEk04CE615snRk26/dJoAxRsYHLp90hhxIAEX0cBOzUegp0w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 12:49:04PM +0100, Philipp Hahn wrote:
> diff --git a/drivers/net/mdio/mdio-xgene.c b/drivers/net/mdio/mdio-xgene.c
> index a8f91a4b7fed0927ee14e408000cd3a2bfb9b09a..09b30b563295c6085dc1358ac361301e5cf6b2a8 100644
> --- a/drivers/net/mdio/mdio-xgene.c
> +++ b/drivers/net/mdio/mdio-xgene.c
> @@ -265,7 +265,7 @@ struct phy_device *xgene_enet_phy_register(struct mii_bus *bus, int phy_addr)
>  	struct phy_device *phy_dev;
>  
>  	phy_dev = get_phy_device(bus, phy_addr, false);
> -	if (!phy_dev || IS_ERR(phy_dev))
> +	if (IS_ERR_OR_NULL(phy_dev))

As noted in reply to your cover message, the check for NULL here is
incorrect - get_phy_device() returns either a valid pointer or an
error pointer, but never NULL.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

