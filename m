Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59047D3B7F2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 15:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50E876B0005; Mon,  8 Dec 2025 10:44:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF926B0007; Mon,  8 Dec 2025 10:44:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D4DF6B0008; Mon,  8 Dec 2025 10:44:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8C16B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:44:28 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C08B01332CB
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 15:44:27 +0000 (UTC)
X-FDA: 84196725774.12.8D94DC8
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf09.hostedemail.com (Postfix) with ESMTP id AF630140014
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 15:44:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b="mS/JIlOM";
	dmarc=pass (policy=none) header.from=armlinux.org.uk;
	spf=none (imf09.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765208666; a=rsa-sha256;
	cv=none;
	b=pi6b2u/NBaIW+PmBskYSccUZUJwpSBqCAX46qIsUV2k3F9U8l0yldIGoQRBp13tOO52gwE
	RYtzusRxCcf3pQHErRhBWxtjlk+AlxPiIWkEoE9qpPjRfEZb+si8839tkS6NJJuNicnmTo
	SRLR0FqFrKlBI20qolmnON6jb237C7g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b="mS/JIlOM";
	dmarc=pass (policy=none) header.from=armlinux.org.uk;
	spf=none (imf09.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765208666;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pslbipuyb311NpGDh7aABN2Ik4Dzwcn+Di9Zp7T7MRM=;
	b=f84IqSD8JyKJTEvhkfngq9CgdqJgncJwyYZja76cTt5r9Lk4jC9bYCmMZZc08VmsMS0wim
	6Jm9w5JJogy7hiMzVfe3JhYMSW8aMtkjlKz2rwLwPVW6z/JCz0pVkcfNLXSfhyMEF82OIU
	WhB53/SSAcazlv2+KnNELdlFUvKGzrY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Pslbipuyb311NpGDh7aABN2Ik4Dzwcn+Di9Zp7T7MRM=; b=mS/JIlOMRVTCrqARcmN1g+l1Ii
	wA+sPPH2au2vG9zqcNd5pB7ibNnRoOMQWQkqTMRYcWHEb/xUdQKKphUAl7gYU6K3/PXNYggILrKri
	or0Y1vEey+b4oOLJ2aEQDTMRMLfVfW7RPsU7WOUUflxo2AqiUfA/+xd530Ahi9e84dRQcVYFxXGJl
	D9esXo4AczKMywv4Y8YyosK9Vx6+OvNlj/MOOzpqrJlw7CcDm7yI945DKBQvlNMb6SjuCej6Iru5I
	WTpOwU86ufXTwC7Y5cC5Fjvtma5c4aitPp1NMpxEO3jNTpVX6p2ms9PgDO2NnWEbQ7tHz3WsAfffJ
	VPacYP6w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43242)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1vSdP6-000000007uN-491j;
	Mon, 08 Dec 2025 15:44:01 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1vSdP2-00000000591-3DmX;
	Mon, 08 Dec 2025 15:43:56 +0000
Date: Mon, 8 Dec 2025 15:43:56 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, catalin.marinas@arm.com,
	hch@lst.de, jack@suse.com, linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, pangliyuan1@huawei.com,
	torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
	wangkefeng.wang@huawei.com, will@kernel.org,
	wozizhi@huaweicloud.com, yangerkun@huawei.com
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
Message-ID: <aTbyPNINxjzU3Lua@shell.armlinux.org.uk>
References: <aTajXdAVYh9qJI6B@shell.armlinux.org.uk>
 <20251208131842.76909-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208131842.76909-1-xieyuanbin1@huawei.com>
X-Stat-Signature: 9jasbj7eak7j9akzjejarsyzy64swgcj
X-Rspam-User: 
X-Rspamd-Queue-Id: AF630140014
X-Rspamd-Server: rspam01
X-HE-Tag: 1765208665-566804
X-HE-Meta: U2FsdGVkX196G0dPptNCg+14Ode3iYNHqaYY96jCpHCGrdXhe/wqFV0hLx1FJ9D9hp6wz3tl7CQisZWRp9SxCE6wJHBHkEX+q0bQ2fsst/u5sWTJykG5lLYwST66H1tCg1ZHv4Gs5i6PTGrRkGBjioyp+Q3/499seuLYTAqJDi8vgEh2BB6NmTp3se9qHsJoC6eV25IYHYYt1hI43TF99IPD0v7MwGwaUwjkB5Lue++7KmPocHpoFJjgx+8pg9O/K92r6pMjh9qMnQi7kVNXfraqxk1wFFtGl/c3S0gCelVUYi6ZM/BNVg+cH0zctxmaGeh58Ok3cPItJ0DBQPLfm1aVI/58gvN6BpLfk0jmFqagrS4pgU4TgjF4DaU6m32GCMDMKs1PFS1y4etMnZoG/CGfVJzRHoF/GPmJGn1EOk9X9yEmR5j1FqWAHb56ajHQJAvXNKsGY4DDxTL16vR/d3h2WivS7734OHB1ylxSE5w4VpoKgJMqvzovZNpZ7abUiSLAq6jVh/o3MC7WsrMehcD/5kaaDaLCuk57l6nGkaiNi8uQ9M0U6iM1rbKB0wHvqGff37KtDx2FT+Y+HJCEtMo27GXUWI6lcpXDiSTJP0f2iON5Ro78Zc46ZQZ1qcRKgFeuy+V1iLgj1WvkFuD99oTQvBuAOh+GZHsKeJZrcqGNZK2VCnhL5DD1LIdMVXwPXANViCUOkYFyDLozNrZs01he1SR/koR7+wca2hGKrHFcz6cwJ0kJxpkUnNmeTGinRN851bEfxBrKCXjORuJQGm70scIE3Ik2WP/qVpNFDFusyltycy3+6dGkZ3U/IbNmeeQ53vSxsO+qXDm/k5ixY+ZNQaZvkz7N1itikvzNQXhHVvSfMQxgpPwS0ahKRkesTeJHC3r9LCZH+SHfG2hjMn5b4DrDtWbh41dGpacVtFBRcmxKtEmY0ErjW6Vy608hu1Uq9fsQiPX1PAOp/s5
 h2tsYTdy
 7kTujDzZe6fy7LofS6cU5kTwp8u9oXDMs9IM8zx85Z4EYuD95m42ocRZlGNX5XzhCs3sOFUtRGWKB6+4jmkEu+b0ciy3Br3ML4oRHj/5xz76fLO+IVUEqCcX9f7MxARbgPm/vODI+uWbE5i6bbl4VmZQRJrk+DixPqH5gPHTjRnrvfEBwfHUEnZ3GBCGFFdljJUpyHxN8RbF33N+DUC05rP2uMjbH/z60wAuFEE9kbTCgkBk26oRcL/AfndzcpHVrvjxpjZxMk9e+bXEjD7bLVfY6ypj06GFnBZTqD/4oWFE+vlyvQliGDtpX6p3TmtbWJiGkaWtjZZCgdGy+U5USQOUXDdcNteXh2OoTcbXzUU5F+MzaQcS0+CiL14YgUJHAUoTqiwurjElscGSnZ41GRHFuhCEcaRThykCEbp96BLPw/JWi3QwGbQ61rNvLRYrC62t2Ul2aqNxl7aOvcoeavhWyfA0gX2jFRqzAZWlLAfKO6PRnaF8txLr+h5/O4KwVO8Ax7eL6NuMk+o2MuuYjtS5WPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025 at 09:18:42PM +0800, Xie Yuanbin wrote:
> On Mon, 8 Dec 2025 10:07:25 +0000, Russell King wrote:
> > This isn't entirely fixed. A data abort for an alignment fault (thus
> > calling do_alignment()) will enable interrupts, and then may call
> > do_bad_area(). We can't short-circuit this path like we can with
> > do_page_fault() as alignment faults from userspace can be valid for
> > the vectors page - not that we should see them, but that doesn't mean
> > that there isn't something in userspace that does.
> 
> I had indeed been lacking in consideration regarding do_alignment()
> before, so thank you for reply. But, may I ask that, is there a scenario
> where user-mode access to kernel addresses causes an alignment fault
> (do_alignment())?

If you mean, won't permission errors be detected first, then no.
Alignment is one of the first things that is checked if alignment
faults are enabled.

So yes, if userspace attempts an unaigned load of a kernel address,
and the CPU does not support / have enabled unaigned load support,
then we will get a data abort with the FSR indicating an alignment
fault. So do_alignment() wil be entered.

Whether branch predictor handling needs to happen in this path is
a separate question, but as it's highly likely we'll take an
exception anyway and userspace is doing Bad Stuff, I feel it's
better to be over-cautious.

> In your last email, you described it as follows:
> On Fri, 5 Dec 2025 12:08:14 +0000, Russell King wrote:
> > Also tested usermode access to kernel space
> > which fails with SEGV:
> > - read from 0xc0000000 (section permission fault, do_sect_fault)
> > - read from 0xffff2000 (page translation fault, do_page_fault)
> > - read from 0xffff0000 (vectors page - read possible as expected)
> > - write to 0xffff0000 (page permission fault, do_page_fault)
> 
> There seems to be no do_alignment()?

Yes, I didn't test this case, because I was only concentrating on
the effects of the proposed patch which did not include moving the
branch predictor handling.

> In other words, is there a way to construct a user-mode testcase which
> accesses a kernel address and triggers do_alignment()?

Testing these mitigations is very difficult as there's no public
test cases for ARM.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

