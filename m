Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EFF0CD37B9
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7194A6B00C9; Mon, 11 May 2026 08:17:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0A56B00CB; Mon, 11 May 2026 08:17:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62E6F6B00CC; Mon, 11 May 2026 08:17:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 51DCC6B00C9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:17:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0ADB0A06D8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:17:21 +0000 (UTC)
X-FDA: 84755039082.24.8AF4881
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf16.hostedemail.com (Postfix) with ESMTP id 65B6F180011
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:17:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cl9hhl9W;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778501839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1Xtp8ucmwoascdJlTfCMmSV9tphy+hPG1tbhbr9z9U=;
	b=WI1OiM+AXXNmW9IoABeRCkfy6RcvpiBKT/yXi4U+fNop6L11Q+tlKkvO20ns2CywZKYAr8
	YWqPudk+YvgYHJNhDF3wy9BUm0oS5ak/QFtSnSiJjhV2R0+W4otOV8lNU2s5zaSlG5wMnw
	CaQ6dYOcKFdneYT9hl40fjkHh68jzVw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cl9hhl9W;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778501839; a=rsa-sha256;
	cv=none;
	b=1O/7JwJNx/oI5NUFpPFc8fPwmNJEpbPA43vnN0RjJ/Xi8wmzbVYzd1y40REfCpmCHu647R
	VJ1g3Ivd29twsD5ZgQRsYXxLj71t+ZK1NWNwPHkiRmtmp+9hvx86lCGFsKrBM5cUFe1fAb
	fKoj7R/64qaEUs3ueYbrOzsoDpGDODA=
Date: Mon, 11 May 2026 20:17:00 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778501832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v1Xtp8ucmwoascdJlTfCMmSV9tphy+hPG1tbhbr9z9U=;
	b=cl9hhl9WX0F98pNQ5NWV5bfqT4tkm9/T2whpttx3jOkdzKxo0+X4UaferwfKdYD7MtUH7c
	Mj2H6Ox9046KWDIPYwPgc+/f8hoJXB/HkCDG0jzIgovKQuf9kOBuqfJkaMYV0e3oZ2HcKf
	lrDUKdDNIoPx72mrTRKSFvQPXHLyyyc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, usama.arif@linux.dev,
	chrisl@kernel.org, baohua@kernel.org, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <agHIvLIzh5Ce8LFG@MiWiFi-R3L-srv>
References: <20260511073334.635682-1-baoquan.he@linux.dev>
 <20260511073334.635682-3-baoquan.he@linux.dev>
 <CAMgjq7Bts08uH8Bvnhx-dbJiwPtRvXov3q-d5VtmJyEQOXqVcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7Bts08uH8Bvnhx-dbJiwPtRvXov3q-d5VtmJyEQOXqVcw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 65B6F180011
X-Stat-Signature: y59h1nja47zzd3ygcq8bz4mstan6yo6f
X-HE-Tag: 1778501837-668698
X-HE-Meta: U2FsdGVkX1/jV4QbJmLFWS8c/1khuOB5JCdhG11Inwb6+gk8zhttwMRrmm1vrjPZc9m6+3RednryBHx7+xsUK2Eq69ElN1kKx8awfQAU55Z+cmy1O2CcgETAfpePhcH6bhKtaB//drHNx+QiIdRfm4f5xgu2pEkZLFfbfezGeErqnHmyvgVzmsu/+gv6AbgSiIs8aIkhFOc14T7IJJl2SSWmY2fI/j0HmCZdt728FowbXntecbSFNCRN30Wu8ZNipVrBXsdoB9E3ZYBSZKEytJwhkfWf7vPJCzu5vaQs4JIYVDO/3ZpiB9Ld+mhpWAHizdrDbHx2lbvlHcYaNynK7TPyTodCKAQLgq9sBkMZYtflCpZZd28vTHIN0ggN42Vp7hIhg3Fk2FDlwRFn671NpGadpodxhUCqua6A+ZBnZD8eJkjhhsPr9w1Hl8hjEow/iXcW2ELQRMtA5mQntHM8AYqIKyxO24oY2mUN1Sj0+17iY1hEIruTA5xglquXR+H8iVZ7wVxsvORK2aTXlLPvohy66f006FxnLSlo6wgVY9Yxw4wOGn99z6NYwXAZ3Cm1zNA/5rNy85k8cG5j84mR7Q9u1UnIQkLYE2j+0ee4uot1ndvztUUWYbEOoVFXcxqzhS5LvY4ZO3CvOjMXXT1zx681i/xM9BRqAoYh0v8fGx6HTNfdFf1pY++YwZcRWnRhl1ORbBiN2UF9XKNTfXWLDCxxQI2Vi0gdWADDeSEGBEoGtdgdM0U4T0d6dB1tQvMipLWM3fSpSQk4SeY9RlQeVA607k7Xcw0jXRC2BBG7I1zZDEkmbiNBTgugiZWrNPnIWDfmETf4eRPppVKnt4dqVr//q+1ezPm0+eLIxcqcQWhYsxKOSQlusZ0hjW+9JZ7UuXPKEvcag0l5JN9u7vX76LmpbwnuxcIalUl9qZiqKwBpON+1aZNKZmHzgJSo+lwwt/4iJrtJu7qzRRdo5vx
 1xaPztxI
 SbSmOwyyLF4+bLvTP5A45Osdfr+xQckfFHnWEDJtlQCg0VeerYojcE4vmM/GG0r/OxFHHey+6iH7L/VQ2gb8ZLFwA7ZiwNiC+ZYr7S5uVDRniDUEAiq5DsH9T/obuwr+3skCMN1wKKF9ezv61f6ERz+7K2jAXZMmvqLUM7OJa8a4fonMOuMwhr+VdhhnD5EeUsQ7f+FxlN+SKfEtH5KgNclrSdovqUMNYUxpuGDLO8/9GLYxbIbJ7g50LXEFciesTwT4mTqH7jbv4Nq6H4KSYdsN2xH4hqTKr3dsAAI7zPjaHKLLkWyLbcw37uoMt0Pl7hWwv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/11/26 at 04:37pm, Kairui Song wrote:
> On Mon, May 11, 2026 at 3:43 PM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > This simplifies codes and makes logic clearer. And also makes later any
> > new swap device type being added easier to handle.
> >
> > Currently there are three types of swap devices: bdev_fs, bdev_sync
> > and bdev_async, and only operations read_folio and write_folio are
> > included. In the future, there could be more swap device types added
> > and more appropriate opeations adapted into swap_ops.
> 
> Hi Baoquan,
> 
> Thanks for the patch. Sorry I was busy with travel and a few other
> series and didn't got a chance to look at a few previous versions.
> 
> > +struct swap_ops {
> > +       void (*read_folio)(struct swap_info_struct *sis,
> > +                       struct folio *folio,
> > +                       struct swap_iocb **plug);
> > +       void (*write_folio)(struct swap_info_struct *sis,
> > +                       struct folio *folio,
> > +                       struct swap_iocb **plug);
> > +};
> 
> Overall, I really like this idea, we can have a cleaner interface
> starting there.
> 
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 9174f1eeffb0..82d2c9b35b11 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -3518,6 +3518,10 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
> >                 goto bad_swap_unlock_inode;
> >         }
> >
> > +       error = init_swap_ops(si);
> > +       if (error)
> > +               goto bad_swap_unlock_inode;
> > +
> 
> But this part seems wrong? init_swap_ops is called before
> setup_swap_extents -> swap_activate sets SWP_FS_OPS, or
> SWP_SYNCHRONOUS_IO is set below, so the branches in init_swap_ops
> never take effect, am I right? You need to move this someplace after
> these flags are set. Maybe right before swapon_mutex so the mutex is a
> clean barrier that the swap device will be used and all things before
> that will be seen by users, with some comments.


Speaking of comments, do you think below sentences are OK to you?

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 82d2c9b35b11..8012e5e334f9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3518,10 +3518,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 
-	error = init_swap_ops(si);
-	if (error)
-		goto bad_swap_unlock_inode;
-
 	si->max = maxpages;
 	si->pages = maxpages - 1;
 	nr_extents = setup_swap_extents(si, swap_file, &span);
@@ -3616,6 +3612,15 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto free_swap_zswap;
 	}
 
+	/*
+	 * init_swap_ops() sets si->ops based on flags. It does not need
+	 * swapon_mutex, and must complete before enable_swap_info()
+	 * exposes the device.
+	 */
+	error = init_swap_ops(si);
+	if (error)
+		goto bad_swap_unlock_inode;
+
 	mutex_lock(&swapon_mutex);
 	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)

