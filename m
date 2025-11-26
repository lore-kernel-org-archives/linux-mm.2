Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33C98D11193
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 19:05:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 785676B008A; Wed, 26 Nov 2025 14:05:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D4B6B00A5; Wed, 26 Nov 2025 14:05:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A1B6B00A8; Wed, 26 Nov 2025 14:05:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3746B008A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:05:28 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0519C13BA81
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:05:27 +0000 (UTC)
X-FDA: 84153686736.02.5C8B877
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf28.hostedemail.com (Postfix) with ESMTP id CBCC3C001A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:05:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=UmvLjZfb;
	spf=none (imf28.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764183926;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y9ZKtsDO/Q8FwygSdDLskDJAHJNeZ7wl50axvyfs4JI=;
	b=EaSfCg5ZRzqCsOcOhuO8GWvxf7IA1diwxDLnmlROoZlGvwojvp2GO0N/Mr2zVGtcZPS+Vx
	lN0uXfkTznKX0bmCnjo+ZmHzBB2dMNtc6Eb1SJZ5gebkJCGJkh4pl7APm95RmADB8INXZ3
	XRfSuC7RAcpUCI8TmWwhMujjeTkax54=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764183926; a=rsa-sha256;
	cv=none;
	b=0m3gr7lGYjnI3RZVpXk1nGL+UzMxyVHSw2sZQtTergk/SQvCZXiaGMOp3/hVOCo4tpzIV9
	aT0FTRxK3Zk8YdFxOVeoZtndCEkJcDuUw/nniksMB2AmSf7zS/9FkkuNPthPz4G//AZpNx
	WIdQpZo1wsPqxf2nc0qL4JLLt2gDdWU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=UmvLjZfb;
	spf=none (imf28.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Y9ZKtsDO/Q8FwygSdDLskDJAHJNeZ7wl50axvyfs4JI=; b=UmvLjZfbuwcJ75/6fQd2XfzGKj
	W2Qw+i6LUELILqmzUEsGna/JXsOY0Zr47ZEyRPopEkhGADSRoV1ySRu8YSbjkmYNUkTDZrJdoGIro
	n96oCbDuxDv8MMkBLkXHCMQT2YZk4OAPhYBmUfzjxaFx0YA9ntd/SRy7aaFgmR4/xICi8BsqXoB3O
	IeGl3S0XSTh6dmKGo0yMZtEIxjTbcxV+lkMZ3eSjoeEWWCJiN5i/o3yD028EkAmLdzFDXDR9QW+EA
	1CRX17ba79gV84fkmMT8j0Gpo7c0ygTma4hhPHlBV99CXV4/FvB+LSqLqPgrKFLTjpOqFb3KBqB7s
	n3QI8n1Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58250)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1vOKpB-000000004QG-3kdq;
	Wed, 26 Nov 2025 19:05:09 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1vOKp7-000000001wA-2sGZ;
	Wed, 26 Nov 2025 19:05:05 +0000
Date: Wed, 26 Nov 2025 19:05:05 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Xie Yuanbin <xieyuanbin1@huawei.com>, brauner@kernel.org, jack@suse.cz,
	will@kernel.org, nico@fluxnic.net, akpm@linux-foundation.org,
	hch@lst.de, jack@suse.com, wozizhi@huaweicloud.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	lilinjie8@huawei.com, liaohua4@huawei.com,
	wangkefeng.wang@huawei.com, pangliyuan1@huawei.com
Subject: Re: [RFC PATCH] vfs: Fix might sleep in load_unaligned_zeropad()
 with rcu read lock held
Message-ID: <aSdPYYqPD5V7Yeh6@shell.armlinux.org.uk>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126101952.174467-1-xieyuanbin1@huawei.com>
 <20251126181031.GA3538@ZenIV>
 <20251126184820.GB3538@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126184820.GB3538@ZenIV>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: CBCC3C001A
X-Stat-Signature: wwe3guq35cjb97fczd38dgotte6or5sw
X-HE-Tag: 1764183925-99433
X-HE-Meta: U2FsdGVkX182dlyl8zgQrQhguPf/zLJPosTgu1SYsfwFLqqKjM/MgrFYmlEWPCVY9J/DYvYrumK0ctPxjY8mmTeLw5xBiBh9I+6lLJPQFNQW+TbR2WVRJ60Syc8kV8Id1l1Or/wZW0USSSiao+iWNFiUDi8MaHt4rVRNjNauLfnbkNFVaMBswOgX1+dPtchgRnXFubXp0tGMKaxHVhLmWSkmbbw7TB04cRXql8OaIcSWccd0iLY6FrETKFmcx2qjBgt5AcohilQnXfyQ1U+64zQxAFUedskB4+RLOFP2iSYIQ1Fr8MG/hE09/vO26IggCGXMjjklXUxTLWUAcKJgJ4zWOSeUBXv95CGKZfhqUvlUc3KW3IWtgxuYdvH6knf2q2QrYH/biZ9FwymGl4dIZBQKsW7Q14vvCq+5nz/mY/OoWhSr3r5mo1VeIYx0V8vQ67VC8Skx0lMEeDPv4JDUoZb7YwMLqUxW/QgCKbTfJkioq5jCMF+iy8fc3On+cJ1lSnRlPEOJMnt/2VolLziOBnVmVFRfdubqqdgbontPgSPR0/C78169gbQPUAH1PPk6FeSeNPdn3ZLWMPPC6ObjIVo8laLNEHhMduGabWubQfPSGK/CcSVzKX0OVze6mR+CrpHf9M4Zq99pbMitNrGk9s8r1kKKItawlc45wk+JrFfDW0c4idZxZbJgskvzc8JoccT61lfd5tB+QRxV/sNms2uYdrm1ajq8lA0aP7PiJrOLM2KM9aQtfIk2cLFFtwvHiHD+grOm0T/tt9WMy1Xj58mjN24uPzQaY5/uwBaNEbiM85DFxBofeGw2S11Q5Ck5sH9mdQVAg9dbxG8vu4VrqfWA0OQ2mZn/hEl8wc+4dBT5f8kph0iL2wFyfG5DWA+Cu14JsFaikufRMTiG7WGLF2eVOIpZEgNxpTWbK499O9vx3T8Ne+Tyxf7+TRN/Bo/Hql6pcECtphVgkjownLZ
 eQvfDdAK
 yFPCchDguHt6X6LuKd7tno6fnzGneFz5IF6JC54YzkEF15066No2QSjRi6ebM+yAnZg5H23l7zeH/VHrOmVXZJXbVXbyWrxMYtROUIPC2xc5VLM/zHov7FOwKvm4LdB2Nuyzj6bxqdwTpFX3C0qxdWHUQW/ZOEDaiCMm4NeQW67O2w6JdPwp8iZkG6iYQT0mOIeM/vx+IvbfbG9K8PVZk/YehjJ3O6dxVOnOCWCwnoJMkDEqAK6JIn/fd9cXnatg48istZu5+RTw0egN8/919No1SRdE8Ghw83HcH1DZhFyqnqC1yk3ZQ4lWpZcYh+JN+1y0yonmBmJ37wuL76uthz4qN63eIETRvNAcfLxI2QPPwce8UP+Zwp9RshRcQ8RhRmO3b/BW7TxqSgcqOY/T7vuFrtUoUOPCVHG9ksOcGvv+i+19QXxQBG5L/3L0hGGMx36m+CpTTDELw4/BocT+bTFodJJXgCm++UUUmqi6bB8MYR6yp0zvztlyMC+KZ2F/gxxzEaxX10mT0ypwiPozf77GviA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000021, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 06:48:20PM +0000, Al Viro wrote:
> It's been years since I looked at 32bit arm exception handling, so I'd need
> quite a bit of (re)RTF{S,M} before I'm comfortable with poking in
> arch/arm/mm/fault.c; better let ARM folks deal with that.  But arch/* is
> where it should be dealt with; as for papering over that in fs/*:

Don't expect that to happen. I've not looked at it for over a decade,
I do very little 32-bit ARM stuff anymore. Others have modified the
fault handling, the VM has changed, I basically no longer have the
knowledge. Effectively, 32-bit ARM is unmaintained now, although it
still has many users.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

