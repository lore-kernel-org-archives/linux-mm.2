Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12AB8D111B3
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 22:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E3D26B000A; Wed, 26 Nov 2025 17:25:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 294B16B000D; Wed, 26 Nov 2025 17:25:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AAE66B000E; Wed, 26 Nov 2025 17:25:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0674D6B000A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:25:35 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7DD8C131951
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 22:25:34 +0000 (UTC)
X-FDA: 84154190988.14.3F71DF2
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2C9FD1C0009
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 22:25:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=runbox.com header.s=selector1 header.b="xcD55qt/";
	spf=pass (imf21.hostedemail.com: domain of david.laight@runbox.com designates 185.226.149.38 as permitted sender) smtp.mailfrom=david.laight@runbox.com;
	dmarc=pass (policy=quarantine) header.from=runbox.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764195932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JdiNBuFehcyPOmOy5sppRLIzajFbdjUkb07I69kLGso=;
	b=7K7L3txBrR43l1shFHjXauxcAIYEDF1EN3sIve7EA55ArsI5vz2RVvNGFG6qDXd5I8cHVo
	8cbgQtIrEF59JSB/T2+YwaVfx92FM/k7anLLjIzmRJ/w4H/OdM/KRAE2qtMVrhA3MiCfdL
	v7qrcEdB0KUNlj+eK6Ry0GiWB/YLlO8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=runbox.com header.s=selector1 header.b="xcD55qt/";
	spf=pass (imf21.hostedemail.com: domain of david.laight@runbox.com designates 185.226.149.38 as permitted sender) smtp.mailfrom=david.laight@runbox.com;
	dmarc=pass (policy=quarantine) header.from=runbox.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764195932; a=rsa-sha256;
	cv=none;
	b=c0NAp2TLo+n78IUKTqFCSRTZmJyTyYH4029jj5pb0Rhn4l9k7FwyYyO+mxIg8rOSrMXbYN
	wTpDU/tUythVoNZLXM1fjq2BvwBP5GEtFUO9AEaiU7Yz7J7yGupvITiuxqUtWhB+WWccMx
	WjryNCAaFhiUIdJ5ql4b9Sz7LVekCFE=
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight@runbox.com>)
	id 1vONws-00AeXX-Vz; Wed, 26 Nov 2025 23:25:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date;
	bh=JdiNBuFehcyPOmOy5sppRLIzajFbdjUkb07I69kLGso=; b=xcD55qt/yTlHbRKdH+dBDSqh0U
	D42VMdh3YZT9pboyItqPjUEFlMjqGvWOkqKAMtxuETcqWYgXpz4rKroO5l/tRmc3L1BOxUfisIxkl
	rB1Iby8Ydzrb+bQCoPA7DatT6VLRSGNsdHwRDRTFQ5z0moPBOyfGsIcUf8++5wUiEyW+pE4J/YgUA
	OPPMAkQtF/m5Q1ardScEOjgI2eA0Y9fd/zb1MeRycorFUZdoNr0n/uOOSlhpqKg4fAk3vPaH5FtCr
	IgHttiJ0P0sh6EEouRQ3I09DwKT03Sa31APrSym62KaZbRen3hdZZ1gjJ53lTWC+Ky3pEFG8BjzHd
	gB2J9ibQ==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight@runbox.com>)
	id 1vONwr-0006Pi-3U; Wed, 26 Nov 2025 23:25:17 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vONwi-00EfwT-M2; Wed, 26 Nov 2025 23:25:08 +0100
Date: Wed, 26 Nov 2025 22:25:05 +0000
From: david laight <david.laight@runbox.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>, Xie Yuanbin
 <xieyuanbin1@huawei.com>, brauner@kernel.org, jack@suse.cz,
 will@kernel.org, nico@fluxnic.net, akpm@linux-foundation.org, hch@lst.de,
 jack@suse.com, wozizhi@huaweicloud.com, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, lilinjie8@huawei.com, liaohua4@huawei.com,
 wangkefeng.wang@huawei.com, pangliyuan1@huawei.com
Subject: Re: [RFC PATCH] vfs: Fix might sleep in load_unaligned_zeropad()
 with rcu read lock held
Message-ID: <20251126222505.1638a66d@pumpkin>
In-Reply-To: <20251126200221.GE3538@ZenIV>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
	<20251126101952.174467-1-xieyuanbin1@huawei.com>
	<20251126181031.GA3538@ZenIV>
	<20251126184820.GB3538@ZenIV>
	<aSdPYYqPD5V7Yeh6@shell.armlinux.org.uk>
	<20251126192640.GD3538@ZenIV>
	<aSdaWjgqP4IVivlN@shell.armlinux.org.uk>
	<20251126200221.GE3538@ZenIV>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q9wi9k57e7m81w4y75tff9puz7jcoqzr
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C9FD1C0009
X-Rspamd-Server: rspam09
X-HE-Tag: 1764195931-801871
X-HE-Meta: U2FsdGVkX18CoInD/5P5mH/VM50vZzbL3UD7RzXF75wziRIx2Lwy4w97X8YVmryWs/muGLbqEUgvPH501yMIM1I3OHhXXUl+ZEhIcos/zMMCCxQOK/7fgE5GxhwoXgwwzER2mCArPTRc4EeXbh5hYnyz7AS0Jmj3MJnWfiI0HDcaVdCUEoYS+nxFmzRaSwQw6+l3Gtp5V/apWuw9iu1Dtxodw+gOKh4xZ2xB/U/OrhYEZ89jb2ZPM1EaclbGbtGEaenpjSRdsw+XkQ9hjJweSdQpRD2Zr035z3wyySapzISng0bbEacfL54wVNvtRgzudlqTGYe86YHSzIlWlgiPUrSBSo3FTV/qlWACZ7OgB28dsuSisy0ZabOCWOQDTZ6p/rmOBsmCPxUdKCBEvwadGhYG5T+5+hjZuHxCm/8kIgGC1sedsKdmfj16VJ3O2L8PnXr4Ch/dNyh9/mwnYRUSg5ABvb95brY1wk2bsiaiV02NOg/Xvswj7TIiHxt043AjW0QsqPfbz+SF0XyeLpBRIcDPgSDntfR9Raq2/0Dpk9GXqUTBsSFn+O/ioEwhpj9TDlSazna7CmrlVXCL8cc966Jf7jNc96U4zgX7cl4xq/KSa+oQHnD6siXZxNVMZWKEIHAAFGzjpjIYj3nsqXQqkRnSZDQW4DAvWMiuBOY5wZBvMGvPgsEi/1WKQywO4IFcnG8QoFx08SDPj6CaJ65cYVHYfZMp5VfrmTYh4j4JdOuDRTbmsK0H659QGEL/0a3m9l43J2T22zKCj/IFZjrNMm+xHC83hmCdB8rhjrTR1Ap1b7L5bZYtM1aZh4fR1KAwso1EDHZYOpZKU2ReBga2DpwcdFNU0f1jQq4yH9JHxDBWtY1rVaZLjAjlTYsK21DAQVFR2TvqyJ5+pbV4BrObNwNkCeexwfNj9NrnLqbxAq+VJD5ZVIuFeTCeJbOGVX7i5FuSbvu+d2EY/ydwviu
 iFfjbMkw
 s7CAiDIUkojEfnBmaioaiHEsxb8DU2m6VIRxrRrhgbSObQYeSEca6rteJnsgVoW/X1i3hAQNDXk4SGrYb5QUkTWSXDsZXu3HRDcCcOFmlRi6Iybv14IO1gjFjNqy3UzaDlC+hFcxRLUJSzxR9kCCoL90HUdgn4pUWektr/Xkjii3eHbvEV+gQooEG7/gU3w8/+EWcLXlQYPNIEMg1oc34zoXqNBHrvYKsncEs1Vaz0zNXJIjO2L5bCyHORTFNoYJD9wABRwoTwmwH3/79sCSv2BghyO9eoCwMDcdcFdDBuupA4d0NhuvgH7PdIlT9jEIArLlt7Fehh8YtVpO/Wljm5bjIP4mruAzIVwvgoBvfysPWiWSdO/9vu8xHQNgJxw7I0h47SOLNH6vxKKQinoHV72rMzz2PexjTLk4i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Nov 2025 20:02:21 +0000
Al Viro <viro@zeniv.linux.org.uk> wrote:

> On Wed, Nov 26, 2025 at 07:51:54PM +0000, Russell King (Oracle) wrote:
> 
> > I don't understand how that helps. Wasn't the report that the filename
> > crosses a page boundary in userspace, but the following page is
> > inaccessible which causes a fault to be taken (as it always would do).
> > Thus, wouldn't "addr" be a userspace address (that the kernel is
> > accessing) and thus be below TASK_SIZE ?
> > 
> > I'm also confused - if we can't take a fault and handle it while
> > reading the filename from userspace, how are pages that have been
> > swapped out or evicted from the page cache read back in from storage
> > which invariably results in sleeping - which we can't do here because
> > of the RCU context (not that I've ever understood RCU, which is why
> > I've always referred those bugs to Paul.)  
> 
> No, the filename is already copied in kernel space *and* it's long enough
> to end right next to the end of page.  There's NUL before the end of page,
> at that, with '/' a couple of bytes prior.  We attempt to save on memory
> accesses, doing word-by-word fetches, starting from the beginning of
> component.  We *will* detect NUL and ignore all subsequent bytes; the
> problem is that the last 3 bytes of page might be '/', 'x' and '\0'.
> We call load_unaligned_zeropad() on page + PAGE_SIZE - 2.  And get
> a fetch that spans the end of page.
> 
> We don't care what's in the next page, if there is one mapped there
> to start with.  If there's nothing mapped, we want zeroes read from
> it, but all we really care about is having the bytes within *our*
> page read correctly - and no oops happening, obviously.
> 
> That fault is an extremely cold case on a fairly hot path.  We don't
> want to mess with disabling pagefaults, etc. - not for the sake
> of that.
> 

Can you fix it with a flag on the exception table entry that means
'don't try to fault in a page'?

I think the logic would be the same as 'disabling pagefaults', just
checking a different flag.
After all the fault itself happens in both cases.

	David

