Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3AEED11196
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 19:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5D8D6B00A4; Wed, 26 Nov 2025 14:52:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35036B00A5; Wed, 26 Nov 2025 14:52:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70F26B00A7; Wed, 26 Nov 2025 14:52:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C68016B00A4
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:52:15 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D455160770
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:52:15 +0000 (UTC)
X-FDA: 84153804630.24.FBB61E1
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8765CC0002
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 19:52:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=BHndPZwG;
	dmarc=pass (policy=none) header.from=armlinux.org.uk;
	spf=none (imf10.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764186733; a=rsa-sha256;
	cv=none;
	b=F9m5v5lB1UAMcLDI4ob2FQuHVBzM++hoRaYZB3Xy5KFnWzBL+jUgJsWdlCbA5UqM4sjeBS
	9ybSQIsqYkk4xJJKs3JECqu4meEqIoamiFzh1Bmt/CWPrAhrKHILP5WIb8Rwcn3qJ8Ps8O
	yvacWpS5w6EHPtSjfr1e7WZX+dzey18=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=BHndPZwG;
	dmarc=pass (policy=none) header.from=armlinux.org.uk;
	spf=none (imf10.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764186733;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F9CMg7xCCCe7pvWjCkZUtW9tN5r9wm9+9Wqdv/t8aKI=;
	b=d+kaazdq5u21VYgaD1LuIt0VBhdM0fR0cS7emMV+D5CDtVpAo5ZC12KoIx177i6CdW2Sqi
	zHOafNWjnvExWg+n6YtfuC08k0Z9JDtGCyl8ke3T2G3ph+xYVKXhzqJ8V1CzN2R91CUS3/
	cBfITFtVbfVXOHEaSobOKqPzx6+2KQQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=F9CMg7xCCCe7pvWjCkZUtW9tN5r9wm9+9Wqdv/t8aKI=; b=BHndPZwGPTrM215ddveW6SCQGS
	w5XGshZORwCGNkF8wPex0jf0EUyPFK42vLiC8mTGhk+tO6My2wml6VI0EsCSE2x4vzP4RS3RM2FEr
	lIWTKBpIZsjjNZedOqvW17H9D4sdzF7bEHaBbp3kIO9Fn2PrApcD17fPyx+UpKuLfsy3aPWxinpDV
	sDejfX89mi//7BMUyjo+iWwITrIg/kt2sM2gf2XYfhdVtASKmx7bkn3q3toxJm7yAJQLqE2K8M8wi
	7Zz8OhoN0oy5k2OZqqEPYmZInZGg4p53iAQ37QqdvZp1utXGyGhaL8SAv//OBGvF//QTmxqepp7NU
	1/vp9G6Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39804)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1vOLYU-000000004SL-1B7L;
	Wed, 26 Nov 2025 19:51:58 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1vOLYR-000000001yH-0OLR;
	Wed, 26 Nov 2025 19:51:55 +0000
Date: Wed, 26 Nov 2025 19:51:54 +0000
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
Message-ID: <aSdaWjgqP4IVivlN@shell.armlinux.org.uk>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126101952.174467-1-xieyuanbin1@huawei.com>
 <20251126181031.GA3538@ZenIV>
 <20251126184820.GB3538@ZenIV>
 <aSdPYYqPD5V7Yeh6@shell.armlinux.org.uk>
 <20251126192640.GD3538@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126192640.GD3538@ZenIV>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8765CC0002
X-Stat-Signature: 5snjwd8mo5eo5ddcfe5rs96jkt8cnyec
X-Rspam-User: 
X-HE-Tag: 1764186733-934328
X-HE-Meta: U2FsdGVkX184EMZlaxSyRHx2K5QYHzbbYbDcj6/b6R13Qunqx1b6rKILgLZUPuyzXMHytfdx7NGkEAPl216LIdPb3MvCayLXziUxYdkp6bC5Gv0b3NqJU5taJlo8p4tTav4XymccuEVa2bg5qBjGi15ZFlPPATFQF3C9T+rAWs/JnLGDDhbeUSLocy9twag8XzkxD27I3duH9yDZvu/zx5NZWvpFQsgrtAMZbc1QN0cYFvsKCT+ERa/ZXrNjZtrVZab5BfQ9F3Q04V7c0PJ1IY8ZghxkLT/3JHLECWtKYdGNWcOAsed8N7QqKcql55UxpEru03vpZsDE2oxW3Hz0SALFLpjpDNesgqT6if2ZR0Wqwv6/MZH6CRLzhEJvNja7jPsP+zFQXPo0YMGLW/82tmjGHJen1gDzGms7/0H0Aw+SK3HH2dPncWnu1MfDATzPRLN73qwP1mgaizs3I7Vf7+eXi7enuNMiRUZXLozQ7NtKO70FlWzpgOPQokM5I3BYpzkfmk5nfyMwkhP+wx9hqNps7j2WJFgwBtgDqSezu1SVn7HTDbwLPwiNcTWC1rMvF4T/juzJzKUchNrK66yQSFko5wK370HJIqTxrl/nsY/J29d8cWtGiNRkR1y2xdZMSRECgDdGmxaPGEeGK9q+stbm8aVaiEKSe4hkpHV3FW/mQQ6IUTtPVwlupavQYkmmp5WoPSKM9+ckQ3My7A2DFZg+QwZMmqrSPNYdX/s0Q4t7kkHUqFYgp97NntTQ/QitckspqwzNQnR8qS6me3xe4Leqf2V6yRbKO3ulRtd4pW2SVY+PYRbG1J5fAUGADtoiI2I681H2znc+DhSTMh81nzD+EoacHahwkgsSMp37TuCocoxVESWJk6VZTlRGzGbS+NnK8KJtwu2JTCWQEmpNMiZHPmqfSlPGqxtMS5ZcJvfcGcZZf1hMye/1+0lzJMukxN4LsfgGOa0aGnKtB6U
 uGnHfacW
 5XkJ9PPoWeK3cbEm2bMEAB2A3gsoUrAfT0HXuFJyO7SKYgaenrytzSi0Rnsv4ZDc5Q9cfFqxYOglWWkIRZ+BEUgAmAqrUwL7Y852njf9yK5+zigRpR8gyupMg2kZ/jR7WexZ9lyCEK00WIlQEU3RYMqQlDtUat9LZR8QRlDTZsw1NdiSATC7t7fkpWF+AXV9SWkHwBYCgswgT70TG5i5vs6IjnHQRURI2OeETdNpZUw4zpJ80BChhpPImoG2BqSvjbYL9eZAM586ftMQQ/MGuWWMpE+Mtn7KXywOIoZCKR3dKONjrzGtY3T4MS6C8Rdyiz4qqhDATpk+LxZbeDD6QaEhsMiprQBCRRK+H/6wSO0nZUOsOtdjGpTwu6IQ5L1STElrLOQzxeWwgcskIdLdL0adFqwfSMlPLDY3NfbE2KFxIGyjeoYLxFwr5YZr6/W+O32GtBjWxfD3OWGx+hVEhQVtma74iPHEza/onQdjjbLEzitGLT/lxotnC4oy/4mEcBuEs9GV7AfB3dyRGCrXvuGz08w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 07:26:40PM +0000, Al Viro wrote:
> On Wed, Nov 26, 2025 at 07:05:05PM +0000, Russell King (Oracle) wrote:
> > On Wed, Nov 26, 2025 at 06:48:20PM +0000, Al Viro wrote:
> > > It's been years since I looked at 32bit arm exception handling, so I'd need
> > > quite a bit of (re)RTF{S,M} before I'm comfortable with poking in
> > > arch/arm/mm/fault.c; better let ARM folks deal with that.  But arch/* is
> > > where it should be dealt with; as for papering over that in fs/*:
> > 
> > Don't expect that to happen. I've not looked at it for over a decade,
> > I do very little 32-bit ARM stuff anymore. Others have modified the
> > fault handling, the VM has changed, I basically no longer have the
> > knowledge. Effectively, 32-bit ARM is unmaintained now, although it
> > still has many users.
> 
> Joy...  For quick and dirty variant (on current tree), how about
> adding
> 	if (unlikely(addr > TASK_SIZE) && !user_mode(regs))
> 		goto no_context;
> 
> right after
> 
> 	if (!ttbr0_usermode_access_allowed(regs))
> 		goto no_context;
> 
> in do_page_fault() there?
> 
> NOTE: that might or might not break vdso; I don't think it would, but...

I don't understand how that helps. Wasn't the report that the filename
crosses a page boundary in userspace, but the following page is
inaccessible which causes a fault to be taken (as it always would do).
Thus, wouldn't "addr" be a userspace address (that the kernel is
accessing) and thus be below TASK_SIZE ?

I'm also confused - if we can't take a fault and handle it while
reading the filename from userspace, how are pages that have been
swapped out or evicted from the page cache read back in from storage
which invariably results in sleeping - which we can't do here because
of the RCU context (not that I've ever understood RCU, which is why
I've always referred those bugs to Paul.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

