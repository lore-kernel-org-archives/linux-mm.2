Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 041F6CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 22:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40BCC6B008A; Wed,  3 Jun 2026 18:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BCCD6B0093; Wed,  3 Jun 2026 18:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AB2A6B0096; Wed,  3 Jun 2026 18:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 199D36B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:23:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB870C1FF8
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:23:35 +0000 (UTC)
X-FDA: 84840029190.02.4391EA1
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8FF4640002
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:23:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=HItKHSZs;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.51 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780525413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s3SPKunMho6E/CBsMnfM4oP5YS4R7re3HwYPdqVA40w=;
	b=FG209TS14Qg3zErkurSewnBsIUcmEMWLXBvYOs27kQ1NBMwQidNvIGZTegg5W4o01iOlzJ
	P1FlajeIS4D5HTVrIetF9YU7W+Vc2elLc+V8/UewJg4Wf5v7zdOcGAO72i6QbGmelBUBt1
	tMh3GSsXvngewJMgem1ERSR8XSYf0FY=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=HItKHSZs;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.51 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780525413;
	b=4DarWAUor5Kg6XEa7XB/GftLo+FWcrtztFEEX3Wt9phs21GGrTQPbX5wUgwmar8V4BK/nF
	Ia9qzWYOBwdyWCHlimlBITcOPgqttoylMUeom+/qfV9otOPk4VfEzUkUYw/KStYFBuUxyX
	dgJKZ485HB11BAqHgeY5F5YDEE/BRR0=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5aa68d9dc18so4764531e87.2
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 15:23:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780525412; cv=none;
        d=google.com; s=arc-20240605;
        b=TH8VTCZnTWcGkY4h3w11a9mnwuxREkC6i+AQ8w+to2Rh44p5ubBYiZ3B523Rxds5Ny
         DXnk02RkYPOpG1Vu+pDy1px3CJ+O0oPCbRoVZhR6DfXh8+JQ5csamVprxJmWmWxg9+cu
         Hc9Xqm8vWRnyLkCT+lupy3r1QaxZhwrXU93Rt+HGIb5qtsFKjhVn9jAdHpLYW/ga5uud
         kWXlduMWOTSNGcuDfYFWhIZwiLgFqyRSq1s341lCWwGrsD44Mk/y/oLVEqovy++JVTVf
         Ukun+sgmp1NCaRDHYY3W5KLB86LcF2z/FTFUmI7jG/WG4JzFhXIaecvJ0yCnuQY6ch6S
         BEmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s3SPKunMho6E/CBsMnfM4oP5YS4R7re3HwYPdqVA40w=;
        fh=+CEldTXluEPE+f0pnN2+s47f0b550MIYYdIyUO4l2mg=;
        b=aT6MxXu6GnVPVafVQOx8rIRdxzaJ+tZiTkUyiGLKbzz0r2nCIcD3KNL3iBzy7SMN1g
         xm7XMe+lZW9InlO49EzLUd8BZeJHYK+AmwfEzhTV3OoyKWn6821ar4cOfYnxfCU/ViV/
         Mqic9NMHkkFw3HXc9nUObs7bwpeLHsc/giYt4eipjmrU4RancT/Fc8bn8J7CRJVdsZiP
         KmQpMApGwu+I4XldiPGlGJ8wS6x9zd6fX6FdMjmeIIWUG+It0eiD11deVNOgT4w/0xBF
         yVrHzHfcZtpW8xDQdIN13X2O9kB8VJ8ZQFGLVN+X0KqB/lMSkZRxQ21pX/MRkGLvbwRq
         kfNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1780525412; x=1781130212; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s3SPKunMho6E/CBsMnfM4oP5YS4R7re3HwYPdqVA40w=;
        b=HItKHSZssn0RckE/dBf/XyDVMkeqP2llzsguBwT7b6nHlt1IpxFshxrBBWycuVT3us
         3oXXYGBZ2Cdis7SvD5q5jSnSuTcDdjmua8EU5DgUxk1SY2MfK5/sxcCSYiSrXJeLNciX
         n3c/ibM1FRVVDx4UoS1DOUXp/Sh19M3UuyvTuVTbejpkFRVRCGuxcWub7evxyTUFnNOS
         w6PN1xybMsLH8HE/5d9gjNXkqzwobDAIBO7cW/F/nqHMOuEUmkJyPsMGvdADs0cgM/sG
         5lBHWa3VYjJxNkS+QGgtOVMRY4R8zJzYU071Be0MskRVv0uD8Gol1aSJvtrgsgyg4vFB
         7DZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780525412; x=1781130212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s3SPKunMho6E/CBsMnfM4oP5YS4R7re3HwYPdqVA40w=;
        b=WzGQZayai0KsbIivwEWJm056StmNKVEPh9Fds8QBRsy6LeKGEzqcOO3sXPg1cmM45D
         m7ZgP29KxLVd0Li+DHh8BnFO3Uj3GplNRFSeMomkod0gfsyzL5oZTdLfLr64pqWlXqeG
         UCnw315fIKbcb9uY7t+rYv7BoYnoHIt9kokW9agud9jOvIqjCufO3oT7GBHZj8S1E0p4
         E/oxweMRs35ogjWGwfqNSPavQgUnh6h0ew3xiMUUhkMV9x28UtkOZrk4F9t4MEV43D33
         dB1zYZJxHqJNJZYgMuP65KCafCWGvCxobxLDE5CkSfZenqt5Sio97eOXWDfg+Ff+mhnA
         bMoA==
X-Forwarded-Encrypted: i=1; AFNElJ/a0BcDvfjlpBZFIn6LA6wV3pT5j47oipdbNXwrpAcLcOKKmYoLuj/RxFiQ3AUMyEFEPC9Oi0CiyA==@kvack.org
X-Gm-Message-State: AOJu0YwlUXpH3z6WScd9nmoxHwcMX3lF6hhTW8AyJhlx28xbuOpBuGim
	imCpOShwOPbfCBQnhbnC2DpapBrsfzSA0KmUBBXT51D1G+ea5gt3qaIw1BajaeSuMOfmdM/13fd
	++gWQ3/glrhtmCcAuZYVcGL1MrOQxD5XdW5zguMyk
X-Gm-Gg: Acq92OESm4UYgD2Q/e2xwatbkJdBTMfD+5FaqPLtbZYIjwPfNPhW/WoDs4YXtTPGYt0
	zzUT4xzdJZDrXkYK465uh+RBUg2NEytdPMwNSYf9EcIZCujnsXgEDlABBYkpr7jtp/zmIbqmuOh
	xTQKhggMkUB/hF+a9MqacOTU4ZVfUUhEOAeWV2c5jFhiCyV1tKDZiLOYcXz3UOlUwJEd4ACx6Kv
	lucSTYxsJhSeMjS0AMyRLPnJtd4LIqXEmQTKfpqDiCFL8Sbk4IP38nHCn3PHBtmTLu0/YYHGvrV
	qy/vhwpQQIE9jH6dQlQ=
X-Received: by 2002:a05:6512:3d14:b0:5aa:7126:c645 with SMTP id
 2adb3069b0e04-5aa7c088c90mr1762489e87.2.1780525411782; Wed, 03 Jun 2026
 15:23:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
 <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com>
 <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
 <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com> <CAHk-=wgn3QTLj+F+XccE10dXY-UGWN8+fNLEvhsLw+tik9rOmg@mail.gmail.com>
In-Reply-To: <CAHk-=wgn3QTLj+F+XccE10dXY-UGWN8+fNLEvhsLw+tik9rOmg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 3 Jun 2026 15:23:19 -0700
X-Gm-Features: AVHnY4Ikay6WVUle1y1S25sIv6i_k8jcErZspj4ec4V3SJVcTGqkjlXJTjro2bQ
Message-ID: <CALCETrXpqPMS487Bm8f8mHe8hv9DzCqoaW4UdoHetzYBUAhYLw@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8FF4640002
X-Stat-Signature: 6t1knx1qmm9wi3yhwu4ai4dwpdfdeieu
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780525413-486113
X-HE-Meta: U2FsdGVkX1/O4d0+XU/Ey3cmbEUlYsQdYG9HaneKYdWXP7p0dR/h5emd6nYKPp5xhiv7U7gVvwA7n/meA/3bcAHJlUeg2XRo4GXvdmf5z3TBYqICJGZmfop3gOsahDwBcLU1XHnNQA/cY7cvixE3Kc9/cWdTsBDYlqtaSsv5EGEL3mY+TMNp7WEk3ciJ0NiNLDrloxFxLePHSXdrS433ivwRIGyqCK1lKSb36yY48M3lS7XMXClHeE348zNDFUVrgjHAajsRVnN5jJarKw8bRFZrFJTU4FJU1hJFiAZVd2F4yGow47mrm3f9uIo9peEXb0+HSCmpex4afuontRM9dgzXxFe98YkNJfM8ehXz++cDFN3dFo/r4gAaVsZnkKwodBEsIVN3l4x7tljlvwDwBMyGaovgU1C7+/9IiAwzJ8vnkM8vQcAXR45f+5WuWbfFjtQZWiZS8YPkDhO7v9bQ/R967bvNrpDP643VxSYwYBHlM3pxRKV0IZzq5bebK2rXYLEzdMgiRl4LikfMOPX7/uRb590Vb2j1I2zk/FP3m1KPOIXVMqMrX0ElD7lo2hOk3Y9qE6mGJYTer3imQ5EJpRtRP4ogAKKQcmKSD1M/aSq8Dbh+x7Vszeqizj8NYm6bY0O+9L3YDXuUO8mV/Mt7xLZaYMUDwt2RKS/sQETMhYhMPZGMGWIFDH+WhQkkV6tn5eV1/kZY4SQkKVdZLNEdLFjma5HTyRzYkBSzKxPtAnhnTmyc3QXPy6Vk8psckRFk4RyYZJBX1vDpoqzdl2yXTSGmJ8yqPhFa7suzJ86oIBr+tYwSvhBiuwAnSpezr4vjlFOXLq9yuFYvZJvxoO7YMKDO+C4MmUOoMn1a03kTzlmQPATLwj5Dih6fzLnKfybzREOr2rw4vPAwniO9dm5vUjMfISbKgLd1s9AU4GlHOhxkcW76MIaLPir9PhDKuJeFhg7Ay46A/oVz9GJMXyD
 pIxlEhey
 sd6+6Ob0VvUYEfhh0pf81/tJNomi6UIal8eksZNd9k7nKvvCyrDhdhIX66F7HIFLNZLXhP7v797jEDVvPpAlFbZsmRnWoVg7zvlT8AqAUmP+yLRzt20iZulqMr+xEMWCysoLhDDofRlML02gTc9FEu8hHcIC+IlCmmKvpqufVVPotqdsDGOn/aZnZhlEZPQz7m4BBm2aEuuLUw1IkqPQH/JXPj9OrsZIv0w0oGqO6Faoy3wjPg+BSdggLHmFPYhDK876lVLbYs+gAirLF5cBnWXYZ7zM0LM7m/AuKks+dY9thujmJy5/C5G+yQKFOnOD1eFEso3TgOv76nMILyPr9YyGncyc2uJuiHsnjoOocw3odrexR3lQwfMW20pPaDQ8Efdjl76vE4RPE4yTIH0FyuSqQCp50hq6gSt2jBb1cfKx1Iu29YeHFsX0FqsFPFM1djlMW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 2:39=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, 3 Jun 2026 at 14:31, Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > I think I buried the lede too much and you're arguing against what I
> > was trying not to say.
> >
> > Maybe we should keep an API that does an optimized copy, from one fd
> > to another, that can send from a file to the network with at most ONE
> > cpu-side copy.  Not aiming for zero like sendfile / splice.  Aiming
> > for one.
>
> Oh, absolutely - that's what my completely untested test patch  basically=
 did.
>
> The user space interface was still there.
>
> And the networking side still continued to use the ->splice_write()
> thing for writing to the socket.

So I'm suspicious that you've possibly make bugs much (MUCH) harder to
exploit, but the underlying awful code and opportunity for bugs is
still there.  MSG_SPLICE_PAGES is still around, and there is still
(AFAICS) no actual coherent description of what it means.  There is
code that checks for it and apparently needs to do something special.
Foir example, some random kernel version I have checked out has this
delight in af_alg.c:

                /* use the existing memory in an allocated page */
                if (ctx->merge && !(msg->msg_flags & MSG_SPLICE_PAGES)) {

Grepping for MSG_SPLICE_PAGES come up with all kinds of terrors.
Check out the lovely comment in drivers/block/drbd/drbd_main.c, for
example...

And even with your patch, I think checking for MSG_SPLICE_PAGES still
matters: if I write to a pipe (using copy_splice_read or even just
plain write) and then I tee() that data, then I splice one of those
teed copies into a socket, then we hit ->sendmsg with MSG_SPLICE_PAGES
set, and we're hoping that the code does the right thing.  And maybe
all the bugs are fixed by now or maybe they're not.  Most of what your
patch accomplishes is breaking the connection between the buffers and
pagecache, so you can't poison /sbin/su.

It also seems kind of unfortunate that we can have skbs that contain
data that isn't actually owned by the socket in question, and, with
your patch applied, I'm wondering if the only case where this can
really happen is tee() and a handful of random drivers that send to
sockets.  (The ones in drivers/nvme/host/tcp.c and iSCSI seem like the
ones that people are likely to care about the most.)

I *think* that what I'm sort of suggesting is to drop this ability
from the kernel as well, or at least to consider it.  skbs would
always own their contents.  And something would get wired up so that
at least the cases of sendfile, nvme and iscsi to TCP or UDP sockets
would still works with only one copy, from the source page cache into
the socket buffer.


I suppose the counterargument is that, even if more bugs exist, it's a
bit hard to imagine a real attack involving tee, and one needs
privileges to set up nvme or iscsi aimed at an unusual socket type.

--=20
Andy Lutomirski
AMA Capital Management, LLC

