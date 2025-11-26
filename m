Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACCD3D11193
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 18:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94796B002F; Wed, 26 Nov 2025 13:48:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6BF36B00A0; Wed, 26 Nov 2025 13:48:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA8896B00A1; Wed, 26 Nov 2025 13:48:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C83A66B002F
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:48:29 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 659BC5ABC6
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:48:29 +0000 (UTC)
X-FDA: 84153643938.24.D394FF1
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7727940010
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:48:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ivStOe1K;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764182907;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdfgXlkpyLxaObMMHx43Tkpr2ds6LGq9BHgJcGxz0JU=;
	b=ys1OosQy1hDcXQyE3j78QHeSoChtmPFma9wmZzKV5UL1/s6LfC8OUIors8W8JBvwhQ/9O6
	FtBHgxFe6rOq0uqE0CMg4sbaX+TI2KT8BIfmwBE3rStnLOXpxsEW/aL4GkFguYfx96966o
	vILx5TrdEvJhJRcTR3n31kFjFv3ZtDU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ivStOe1K;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764182907; a=rsa-sha256;
	cv=none;
	b=k3tExkRZ7amUKQxpCD15FrNtnK9IYAvEpWX9EPibjNImvNsiOxMLSWirGtGiBVuBCu9GNt
	3sjdfj2Ck97Pn6LYx83qmGhx+1VH64VAt8+YRQKfmsOfi4ARRln4tv5VZmkzFfXPWTKm+b
	Qs7FEd63bE7Bzb6wu8EJuaTbjHhWaBg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mdfgXlkpyLxaObMMHx43Tkpr2ds6LGq9BHgJcGxz0JU=; b=ivStOe1KLxJxw1t8tb72zR8h5B
	W24XagOg7rDcPXZgjOv1FG9rwU2wWxKjHritLGxQkB7rwfZ46htLdBTDboPRj4SILvJyeNToEyTH0
	xeQY2zH9Jt34KfvU2TX7aaPQ873aCah7B6FLdWXnT3cieEefNdrNf0WEnG++C62r58kjy8crDm7u4
	VEzwxCE2EyyrsKYMOSP3AqVbLC/mQaYK2K+5cxl1C8/K9l4KdbpoFZB9ffzoEDmP/AQmnEhi/ckwf
	o0rUliXD2IRZhnuuNzU64OPR1fgeLSdXpAp6NE7v/QLeLHI48lVuZknFaIWBHEGVZkKcxbZcjIAtw
	PyuQ+Jgw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vOKYu-0000000HYvd-2akG;
	Wed, 26 Nov 2025 18:48:20 +0000
Date: Wed, 26 Nov 2025 18:48:20 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: brauner@kernel.org, jack@suse.cz, linux@armlinux.org.uk,
	will@kernel.org, nico@fluxnic.net, akpm@linux-foundation.org,
	hch@lst.de, jack@suse.com, wozizhi@huaweicloud.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	lilinjie8@huawei.com, liaohua4@huawei.com,
	wangkefeng.wang@huawei.com, pangliyuan1@huawei.com
Subject: Re: [RFC PATCH] vfs: Fix might sleep in load_unaligned_zeropad()
 with rcu read lock held
Message-ID: <20251126184820.GB3538@ZenIV>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126101952.174467-1-xieyuanbin1@huawei.com>
 <20251126181031.GA3538@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126181031.GA3538@ZenIV>
X-Rspamd-Queue-Id: 7727940010
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5b6mhb91yeuhg6d4om8yiongcssu8qyc
X-HE-Tag: 1764182907-210756
X-HE-Meta: U2FsdGVkX1/c/htPhiS1bdpb8Rv9tPjr0MH22L6T/iEbpFWAb/nfx+ff7H2WLaKQlECfxYP1tm2h1ZQp3BIFJUxh402wbFZAVrfAHL/xlVNiTIkxxzyvdprzBPapo7HxTuvMJ7YaMhhYgCd6yIy9t6VSOWYLL8BR11Pjx7388q9uMPsLXz+bKQWj7k/PJvcRibnZgyPZdGOH8r/TzCSNid7AefsY9WKKLQ9wpXnKrWAiMxzWKVMuIXpKE0+Bm9JBNvuPw+VqpCgRL00JiIO6USwF9RJFB0VRp9Ls3Snn+7o/EKjIPpaXu7tuCvxKmAZJDp07b8/07skmrbUl7mq2zUBIdJqD7ZEcZrQU+VOxHWV7QA5rAzhfTEEK+sSn6lJqCd/8f4umqR/3mD1eQQlaQHyjAFAH4seNHemVu70OQLCk+JgZgeQ5lL5DGGsqR8EYgWSFlyzrLPIRqjmYoqjnMs/KtbdzOJP/OhubPBSj51HvrUYojuoyK55TwVNewc9DRzQ5RGiclx68ewouuETNUXi5Z91IJQ/RFEp1nohRuGSlGj/zX992TvH6iUqV+zdLQvSe5uHb60+UoJ0JUAxoMbuW8MnjjTsOxoQpLfHyXiMnI8Bwqt/sGziMfGRPEGtIIG2ZeJtq+ZD4ZfeqoKYD4Xuq0N8jUtG4ebZVjXKEgHeWIujNoN4lbyJ2p8WpEds/00D0w0RZ30fM2SCh0PJQECivKMTUm7DWAfY8NZFI6FifHbEzfbwlvzUpeDYAZYKEyHhR1E9Nw+DtebMgXO5cA+rZ78msm9DwvZ8Z3/AeqyKQ0aF1Iq4Ru8MkGIYWpj3DzhfD2279ldjaVbrghhcfy5018gv84J8042JmZKaaJCWNzq6AefBWIo/CGMq2yXYASNfqa+vSuqfHoupGUx09oJ4SlxfZrKQnt+fBg+oLvRw3G3eDRhVAkwklnynBNRh2mqbEHuxhjwzYS8Rg8UC
 8SfMeL93
 9YTnUOgjfXgrPSrtlh666vCV8sDVwWnaw2v5QYUvKUcCBeZ/+BciQFJgGOqWYnq/b/0L6Gux2I06ba3s2dRc8h/J3JZKEx2BBtZtXbuwYbCGDDN1fMzOke0/IR0glTwrb6IhMFuDXypHNLHL6ODBzP16q4C8iKUTKCGx/+/uXiFmzajRVcW/3fRjcQDQ/IFBHrOuzqOGzjUVszAJYmXQ3K7joIRfwksKeR5UbGFXxk7Ir6P+xTeTJqc/1OT9rMsCK3y+1XHOdhd74gMRllAge0CtLoSCybF77Ybg4JJ72jZ/NSwokod7deU1gz6WG3E0b3hBtAK+8cv/eCekHS0OaARh8sjzCcLm30elOYcS6rjo5/YtB3VrFwuSUtiC3FSX3sM/JzWZJiSbmx/q/bseGNVBEw5e0r5n2fqcqLdamjCCfImH8in6h3sMXZ0QJn5i35vEHNKSEdxybVx3eT7VIn4U0tmcFBmi899N8cxKwQCMybAcyRkVaxT4051yrN60frWyrCZePCzNoS5W8Ii3eHIh99Jk+JHauLVCsY6EoAbQB9kI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 06:10:31PM +0000, Al Viro wrote:
> On Wed, Nov 26, 2025 at 06:19:52PM +0800, Xie Yuanbin wrote:
> > When the path is initialized with LOOKUP_RCU flag in path_init(), the
> > rcu read lock will be acquired. Inside the rcu critical section,
> > load_unaligned_zeropad() may be called. According to the comments of
> > load_unaligned_zeropad(), when loading the memory, a page fault may be
> > triggered in the very unlikely case.
> 
> > Add pagefault_disable() to handle this situation.
> 
> Way too costly, IMO.  That needs to be dealt with in page fault handler
> and IIRC arm used to do that; did that get broken at some point?

FWIW, on arm64 it's dealt with hitting do_translation_fault(), which
sees that address is kernel-space one, goes into do_bad_area(), sees
that it's from kernel mode and proceeds into __do_kernel_fault() and
from there - to fixup_exception().  No messing with VMA lookups, etc.
anywhere in process.

Had been that way since 760bfb47c36a "arm64: fault: Route pte translation
faults via do_translation_fault"...

Did that get broken?  Or is it actually arm32-specific?

In any case, making every architecture pay for that is insane - taking
a fault there is extremely rare to start with and callers sit on very
hot paths.  Deal with that in the fault handler.  Really.

We have no business even looking at VMAs when the fault is on kernel-mode
read access to kernel-space address.  And callers of load_unaligned_zeropad()
are not the place for dealing with that.

It's been years since I looked at 32bit arm exception handling, so I'd need
quite a bit of (re)RTF{S,M} before I'm comfortable with poking in
arch/arm/mm/fault.c; better let ARM folks deal with that.  But arch/* is
where it should be dealt with; as for papering over that in fs/*:
NAKed-by: Al Viro <viro@zeniv.linux.org.uk>

