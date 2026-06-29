Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A780EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 07:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B5066B0005; Mon, 29 Jun 2026 03:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 765F66B0088; Mon, 29 Jun 2026 03:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67BB76B008A; Mon, 29 Jun 2026 03:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45AD76B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:20:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B99401C5C5A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:20:41 +0000 (UTC)
X-FDA: 84932102682.13.8924362
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8D9EC4000A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:20:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K4dVghBD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of michal.pecio@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=michal.pecio@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782717639;
	b=DKBcKZ21CF3xMf6I+09CwsBw51i4AVZkzCeIsMo923mV1/MuFK/1j3T9Hp3GnxEoSpgtnE
	kFkb59KnOWI3v33GvozRph6xoackoFrU6gA4ezMDkGOWH0pFED/K6mnAUHJ13FOs7GGJjy
	KXegcYowh+3g41/IdUVITNPEgFJ1VEQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782717639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ega7ohzS6r6GgV/ue9UrgO9PLazVFbtWrIRnE4VyLbg=;
	b=26olALOHlVpR/4qLiM8gt1JybBCGocQSbMB8mzDxTBxnfAKkKw1rQG5kL5vmSRb7Cl5TA1
	pAeO6gxcO2iqOG+CJiEOsLFTErN7QnLyph/yAahI0JcuCvS5rQ0jIlse6pgPd7eKK87FT8
	zgJu6G+3pDlzWcjg3/G8IrpZrOSw7R0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K4dVghBD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of michal.pecio@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=michal.pecio@gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-463f1165e16so3047317f8f.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 00:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782717638; x=1783322438; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ega7ohzS6r6GgV/ue9UrgO9PLazVFbtWrIRnE4VyLbg=;
        b=K4dVghBDkpdt6UQgs6RJdYlgFlxL2TPF3lYN7pQltPEupOR7CSHKWeaytfSMyo6ZLM
         lK7e+EpFS6jZ2Dbaey8LXLtwjqMZLJ7c12PU4GiNa05gSmiRrDK89pvniqTyVZrL9erG
         Pu4Qk6vYlI5C5KEc6g11Az73H9RYWaUcf102uKNV+rKxI5OYf2W2g2y9aRHYKr9k7XEn
         0cgO6afh9cLTgMHMa1SI5xmWIR0DTcdAZzq0rTL5iFmQGRyB3MvKJkZO9kz0ykYtsQhP
         1n6WfS/I56znODrnqb5DUkRWNp+A3fy+GLtjXbs0lhsKnzL5R+zaoJq3gWVnbsdgv3sL
         6vFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782717638; x=1783322438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ega7ohzS6r6GgV/ue9UrgO9PLazVFbtWrIRnE4VyLbg=;
        b=dIkPsmsS5bgnawMRgTsnFmLPW9jv9mMoY/7/aeM9gBngybvMrpwDhdhVkhMW2ubJAO
         2zzMhfEKJseGDRTUt3aujpICupbx/AuC37KMkjbwBUzYb1fEkgpoQflyzNb4ePylq+9f
         pS4alZC/cJ22jPviipyTcIZSQjnevfzCPAXeIU38xhW9P0EYhOE+Oeeq8mgph3nEeCoH
         6vADDBYCm9yTynyr+scgWRo1tXomQEtzysQmDSmIj5Wjxk+rJB7VhlpJcWwNY+RvKffr
         ckVjTYIYqJaG6yo29jQK3gNbnZyvnk5QD8wqpyfE886jQVPVvSPFHQO0w4ymKCDH+dNl
         ghJQ==
X-Forwarded-Encrypted: i=1; AHgh+RquUw4b41Qrs54gDL4PHb6OZqmFEOFDO6u5KB1uIZWjH2iGZrDqT8eUZZAc/AvzXaugNyYus6BTlg==@kvack.org
X-Gm-Message-State: AOJu0Yxb/K20QPCCmEYAaa1hueZn8E+sG0qZ8PfHsMdmP9UNLKvkyYwq
	O8vNU3Vte+P+CmBTlJaYoPKzValzCa7Yd2O8j0iWbjVNU1u3OVhUl56Z
X-Gm-Gg: AfdE7cnJEcSaE2yuctnT9dRh5Xo/JiyX71vQXnXUT6cLDOcTOH1x3g1pyL5mor1d3sc
	tyr2h9TYMeeNhsGJv+ykSznTYXeL+vhlWu0nOsuEEgzXplkNXGtLvSbCzxVXG6ef2mvqGRyMEJ5
	Df1Xo0lsShQa+9Unu6nbu170t3EGJZxdhBj4ei4HDd73Gs/ELP4G0fVsHECEEi7SxAT70gbERsz
	lQVeJw/gq6ljN1qvnn5qttTWZcMs+5zgKreXLGMbO/3+ZC69wnjbJsGHaJpb6BWYDyOEn6uIvj3
	GUgJ4vFE6iYfnrUN3MRhzBq1jBm5Zh0AvrtwGlZkAOw306O/6MEms1QGdUuFX5JmOVsbDEMrqh5
	1IA5MFCI5WJT5D4fkZWrwx4QUAoFnmBbaRuxoPfnjuB+CeATsLRS1f4w2u3DFjjW78Wc2jP2EqH
	xIxBhx7Lkh+mVkIMIxmUB+KhDL
X-Received: by 2002:a05:6000:706:b0:46f:558:a43f with SMTP id ffacd0b85a97d-46f0558a904mr17320972f8f.4.1782717637738;
        Mon, 29 Jun 2026 00:20:37 -0700 (PDT)
Received: from foxbook (bgu190.neoplus.adsl.tpnet.pl. [83.28.84.190])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c1ee0189esm49368953f8f.9.2026.06.29.00.20.36
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 29 Jun 2026 00:20:37 -0700 (PDT)
Date: Mon, 29 Jun 2026 09:20:33 +0200
From: Michal Pecio <michal.pecio@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: sanan.hasanou@gmail.com, vbabka@suse.cz, akpm@linux-foundation.org,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 harry.yoo@oracle.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzkaller@googlegroups.com, contact@pgazz.com, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Mauro Carvalho
 Chehab <mchehab@kernel.org>, linux-media@vger.kernel.org, Dinghao Liu
 <dinghao.liu@zju.edu.cn>
Subject: Re: WARNING in usb_free_urb
Message-ID: <20260629092033.4a83e91b.michal.pecio@gmail.com>
In-Reply-To: <85cf5045-b52b-4aaa-a038-ca1b856b55f9@kernel.org>
References: <6a3eeead.7fb353d3.354599.b0b0@mx.google.com>
	<85cf5045-b52b-4aaa-a038-ca1b856b55f9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8D9EC4000A
X-Stat-Signature: dtmojpxu55xekm1z7yxd6wnnpdw5onkh
X-HE-Tag: 1782717639-543250
X-HE-Meta: U2FsdGVkX1/mNWbJn6tGbFexmbu61ETlkzyZuvYJUbNlGdq2q1g3bFDh1A+vJSZQqbUPB1yKw0gWsMdpbg+8bhCr3yZ9pHTO0LQmgAeQ2/PE62Qqm3S4gaJ2Xxfa7mrjYuvXOs50A1VnKHZd/T6FEe0JXv4qEp2rO96EAyq1ogpye6Hw3i0f5B4DrKxUxN7q+x3C1cRpwlfDPr5PhZdQAhAciV3OokouLkSPSRIyl3O7KUjhSzAaHc4/FW01zFk+I3LS6y2r5Di+Zj8JEaMVWU17W+YS6Px2iyfZH7Z5Zp+2BVzmV3l8foRPFHNilfBlr1uQCVbgpYA++/LwI5th942vMSI7tfVKdSBXtWpwhyIYVXfo8bLUIgDPAx3HMvM2vSyEjMS+zd/2jns1Kgyi5jnxKZMLKd+VjjWDphFX3aSI1xYeUI5+3DEuGhybVLdSTcie3bNnmgOALwUflLxc9qbU/Bo1dElq6Jf7WR8d3dz+jaRvKgVS6Bx+mmeno33biHCFL4Q5nBH5RUc+GPoYWpmPivo1PvLraDio6R/I7aYzZHNhIwiATIux/Gxwn+3bDuEEic+y9wY+Rc33j/9ZHDILD7uOv0vWlZbxWUDmtiLKF55dJ9fDo4Z7W17/Z6YWhR/TS9VqvMHVmqQ2TKHPtHtFZYdS0KFDR3XuNVZcLEutxn4+G1SCz1eti2TxHXMUhq4UXVULbCzze0hzlODIntqwY0Xpginn13vmnYwt6OoIhnUh7aBlPK5wSZX7qyUMQ7T2xauw+CEoNWOLqAPSdFzITvdT5xytek5ZJMfHhXK9HN/VC0mDzB3Q6IS9ysSRuO6E/4aijefQL0Mk30leC22gs9NlWd2fjQxSR4JjrB0Xs5lG5bLpxecd/Bjyj7Vdo4LZw4F/D/iSXES/t+25cZxhsE5IiXOZ3DmJqYy5cKRZXT27NjFvihnA222QxI2ffJ7m9ZqgtWWOXEALUOi
 5Mlxny8I
 jXa6b39SA4xY9lJ1d2YE9XWin/nEErQfBagkIBDGfw8+ITT4KAnQy8nZRQRLaIIQeqhYlP+kBwY0sFTPbUwMcps6X0P3JSnPh88l+OUwWQYDtqXieszR+zExAA8ztqqapvIDbHVpy++82G0BSi+o//ldBqPWdF4GjXHO1kCpxqUiPDAX4hG3x6Th9qIr9UdBKxdOZX6yH4u2WFDOy40KX2Wa9Xa1jw6tWFYrFUiYIY7zVjrMDxK5rh0tAX91ymcowh1D4nEHBFXv2mQYKKKPYx4NIrmCjTEOI0YIgIafeF/0VdDFIuCXFSLDfnqaLDj7ZnHCMLtL2845U+QbSpuwG4PfqaRFP85RwNTlmiD7Ba1gHc6w0H+9nHvHthv/zHyo/lL9OPjdx4F/k3QSDonrXs6Pqu6uIRLD+3YFBdFR1OG3S1jQTtoGxl3RqYFSu04GezuppGwzeWmiK7vMUntCGX6IofbqkAsAJmMub5cNhK5H8uCSW/gpSP+F54cd90sY+vXfORd63xPSgrffYZMztDJ4fyetT66VjNnW5slnu/oSeVkOPZLOu3SbtN98E4z+a/R3tljLVaDGb1pM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 08:27:48 +0200, Vlastimil Babka (SUSE) wrote:
> On 6/26/26 23:27, sanan.hasanou@gmail.com wrote:
> > Good day, dear maintainers,
> > 
> > We found a bug using a modified version of syzkaller.  
> 
> Subject says "usb_free_urb" but you only CC'd slab maintainers, where slab
> slab is most likely a victim here of e.g. double kfree() or a kfree() of
> otherwise broken pointer.
> 
> Ccing USB and EM28XX maintainers. But they can feel free to ignore this per
> the next point.
> 
> > Kernel Branch: 7.0-rc1  
> 
> Why use such a version for fuzzing? rc1 will have many bugs that are
> already fixed in 7.0 final. And it's not even latest, 7.1 was
> released 2 weeks ago too.

To be fair, em28xx had no changes since 2024 until 7.1-rc1, so the bug
must be present in various stable releases and likely in mainline too.

> > WARNING: mm/slub.c:6352 at free_large_kmalloc+0xb3/0x160 mm/slub.c:6352, CPU#1: kworker/1:4/12317  
> 
> A kfree() was attempted on a pointer that's neither from a slab page nor a
> large kmalloc page. Might be double free or corrupted.
> 
> > Call Trace:
> >  <TASK>
> >  kfree+0xae/0x630 mm/slub.c:6437
> >  urb_destroy drivers/usb/core/urb.c:25 [inline]  
> 
> static void urb_destroy(struct kref *kref)
> {
>         struct urb *urb = to_urb(kref);
> 
>         if (urb->transfer_flags & URB_FREE_BUFFER)
>                 kfree(urb->transfer_buffer);  <--- this one
> 
>         kfree(urb);
> }
> 
> >  kref_put include/linux/kref.h:65 [inline]
> >  usb_free_urb+0xd1/0x120 drivers/usb/core/urb.c:96  
> 
> USB layer itself is likely also not the root cause.
> 
> >  em28xx_uninit_usb_xfer+0x165/0x310 drivers/media/usb/em28xx/em28xx-core.c:833
> >  em28xx_alloc_urbs+0xf2a/0x1130 drivers/media/usb/em28xx/em28xx-core.c:-1
> >  em28xx_dvb_init+0x2b0/0x4a20 drivers/media/usb/em28xx/em28xx-dvb.c:-1
> >  em28xx_init_extension+0x121/0x1d0 drivers/media/usb/em28xx/em28xx-core.c:1117  
> 
> So it might be this driver doing something wrong?

Yes, it is. 

        /* allocate urbs and transfer buffers */
        for (i = 0; i < usb_bufs->num_bufs; i++) {
                urb = usb_alloc_urb(usb_bufs->num_packets, GFP_KERNEL);
                if (!urb) {
                        em28xx_uninit_usb_xfer(dev, mode);
                        return -ENOMEM;
                }
                usb_bufs->urb[i] = urb;

                usb_bufs->buf[i] = kzalloc(sb_size, GFP_KERNEL);
                if (!usb_bufs->buf[i]) {
                        for (i--; i >= 0; i--)
                                kfree(usb_bufs->buf[i]);

                        em28xx_uninit_usb_xfer(dev, mode);
                        return -ENOMEM;
                }

                urb->transfer_flags = URB_FREE_BUFFER;

If buf[i] allocation fails, all previous buffers are freed and then all
previous URBs are destroyed. But they already have the URB_FREE_BUFFER
flag set, which causes a double free as shown above.

The free(buf[i]) loop should simply be removed. It was mistakenly added
by d571b592c6206, then a26efd1961a18 recognized the double free but
attempted to fix it only by changing the order of freeing. Sent from
.edu domain, so probably an automatic static analyzer fix...

Regards,
Michal

