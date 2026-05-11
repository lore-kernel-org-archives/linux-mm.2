Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5853CD37B7
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35E026B00FC; Mon, 11 May 2026 05:04:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336636B00FF; Mon, 11 May 2026 05:04:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 270416B00FC; Mon, 11 May 2026 05:04:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0FBB06B00FC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:04:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D30948CF13
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:04:00 +0000 (UTC)
X-FDA: 84754551840.13.2F11D5E
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id BE1511C0016
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oMkvLi7E;
	spf=pass (imf20.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wlzFNgs9EjCzT2cBIlpEV3TlKbQAmRqfCB1Cmm5Uw0=;
	b=YhnZTq+WlxN7lHrdO7zZa1GU+PIqG82ospDsoWzQySR14M8PSyFGFswgbu7WX4bIjWKFO6
	5U6hQVmU/FgY2WSHxe5N8+WU8wZIyeiDox6pFiPBq0OMq2OQVdpd+AEzj9lX6z/otJYRYl
	wkwpOask8MT8aUdnBDeMYMOoLNOftlc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490239; a=rsa-sha256;
	cv=none;
	b=s3nO2HI7iQw6yBvoxgehwjaBZ6ixxWJpO6F2DvAh3dubjqDANHxmqncLiKCTwx/Sdvy7Tj
	ukD0kvNzBqeAKOYQBJ6QnONXJ2PxgsK7wKkrUBEuquIKwTfbNmQDc8gPlyDRKC5oA9uXjT
	hIGj/bpxdiB9AljsK8iXLBLlYKojg04=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oMkvLi7E;
	spf=pass (imf20.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 11 May 2026 17:03:51 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778490236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4wlzFNgs9EjCzT2cBIlpEV3TlKbQAmRqfCB1Cmm5Uw0=;
	b=oMkvLi7EH43nFFXA627SK865Iw06+VZJNLjvC2+fh6qt+vw7Us7MaoPBIqn0jKND88XIN7
	w11qaXk4QFdjrAF7YUDRc5pp/MRaXNJSONNOvPlarEkcqoNbShjmFsiYOCZCCvu2gpjRzY
	svsfRSNe1xDe5vGwB8xuR0xHmHq92ag=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, usama.arif@linux.dev,
	chrisl@kernel.org, baohua@kernel.org, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <agGbd0kWva-bBgOA@MiWiFi-R3L-srv>
References: <20260511073334.635682-1-baoquan.he@linux.dev>
 <20260511073334.635682-3-baoquan.he@linux.dev>
 <CAMgjq7Bts08uH8Bvnhx-dbJiwPtRvXov3q-d5VtmJyEQOXqVcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7Bts08uH8Bvnhx-dbJiwPtRvXov3q-d5VtmJyEQOXqVcw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BE1511C0016
X-Rspam-User: 
X-Stat-Signature: k6gmkjz97znbsi5k8b4umspsudym3wfx
X-HE-Tag: 1778490238-386236
X-HE-Meta: U2FsdGVkX1+455fI+BPm7Z+faPqEm9bVyTRsLEBT6LNVFDYXYXr3XUCKCrcRzjNwigeew8OFy88Oj06jdIJQvr8Ri3bTdj61BwaAdEquT7FGLCy8EJseVvzGg3NN5ipzWp4tNT3af0Rnm1qXz0H0C2HkY+wGiIFRKdOu/o4qmmiPWEH9onogSUi741/5hIsLKNiV+xj5JZUOs1Tldbwpb8/SBUR2189r4UZJRzfFSdpaTRuCBc6tlQzK3ek7NEBJDKSDD8PTvp6eRrtRJ9AJk4PbvEM3gSRW14rP/nQnjaVCoZciL6B/2MFev1CGBmjSVzXmY5rbCZKVRoakoZORYJ68KOJFYJLzlqaRNhqk+eQaYLlRAHQ7Au2E8fhwOLbInCISCmbPSqH+OuLXqsda5U89jSFqCYqEBbGLGf88lhX3EWvgcI5cYb1o2A5lcWL666RzNhZ5oNsWMXQwJ2pbLGHg9jJpTQr6i/PmgXe4x/PAT8ZsdCFUwXW2K1a+3MX3a2nNq1U5Ndtr/N9KDvSvPoDTKn95I9fkfvcHe3GXdXVPKy3woDTcWoC12PwD8/dAKNrdlD9HaWUISB2mJEGqhOMZ56z0BKLURkyneeZlrEFsHDcAwpubUSk+Jy9aPXCL0A0rePANehqVNOJo80BJ5fkz3RbuNi6JxkKl0fKk5oOqonp1o3Hq5O1v5YK3R3/MGVsnnOZ7QBuAB8J9hLzCcLmKcgPdrT9V+kGpqXDrSUJtrq6LHmvFpHAPQRrIlGZLdXr4VroeEgJEsxPjGBFL4PbQ50/aKPvENG+TJ7lTVt3CNhhXPwPlBKZZaRfyCu7CPaA85uDvSVpefKKZaVPEqMLYcs0qWfgTtv6gzkGPM5itMI7B3tP1yOVfmGU3CACNRoV2Ny3RzDDnchRi/a0Aayv7dYXViFEmbkocao5TJX1MVUL4KJ6HTpn26XI5LnxpIbfNnH9zWqtVWbPNSdZ
 fNLgIizK
 7berpC2u94VS3QEOJwmf2Vrln7jWicHsILn1yDJq6xYucFb1hLUyAwA7iz7a2c49OajdA41UrsQkaFRfwF1u6qDoTUeqHpZ591dK6KSALuV6dqmHsz/jBYLPxoMPWsH/KVVB/66JabixWK584t7Urj0J0XICA3ZVN0ZhUxlmo+h/iVKjmUZm3w6B+Kegi8dQSDZ5TtpOUqm7vCbGSbDK2CraFvTLa4UYRaEcCNydsPt84EGfKxX40hhG920eCr4IZKEapWG6JqMOidzrUEjoULZWmT2h5WRRyxKMUlZZmQcnqa3WMlHNdpY02m+mBO1nPZOFp
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

You are right, this is wrong.

I checked my queued local patches, I added code relatd to
activation/deaction and register/unregister according to Youngjun's
comments. Later Barry helped post v2 when I took leave. I just picked
code following Barry's v2 to post v3. This wrong code defaults to take
bdev_async_swap_ops, so I didn't catch it when testing.

I will post v6 to fix it. Thanks a lot for careful reviewing and
catching it.

Thanks
Baoquan

