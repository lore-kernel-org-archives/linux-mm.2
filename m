Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF6B4CD6E79
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 12:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D45D46B0005; Fri,  5 Jun 2026 08:19:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E376B0088; Fri,  5 Jun 2026 08:19:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C33BD6B008A; Fri,  5 Jun 2026 08:19:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A67AE6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:19:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2FF9340BDB
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:19:50 +0000 (UTC)
X-FDA: 84845765340.01.BE52859
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3B0031A0007
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:19:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b0qpvNtV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780661988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gz+VtwQhYk3ng5JxyiUgLQa8oImJtLVBwaLlzEeVzFo=;
	b=v6pLrW0BUP65pPln0dLF5KPI6/3GyPeb/1W68Sbi/9tyYvF5u4dMRH1QelHXZQfiXDaeF/
	kd7yp0s8PMp5uJsgrIpidZZGOe+ga7sLiAUR2NMco3RoV04T7cYg/J5SXtoai2wnmTLFvk
	4LkEnQc2U66xN0zAgrH12OHT0Zhjcko=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b0qpvNtV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780661988;
	b=FepKhiD/BFcFUP67ao6izAawf5UJ9R68S8dpqkzjMOEziP/PFNiSQHtVh+38cMGJ5zeSX9
	8AXw5+nJL7iW5t0xIKYPePaZLEYAwxq4JvIieYZ0cj1N2Q1BYwOMZfycMofh0IqCu6lXw5
	1Fj55aUSIZED+jcIlEcMQJcBNy15Kek=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490b2b037d2so16449015e9.3
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 05:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780661987; x=1781266787; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gz+VtwQhYk3ng5JxyiUgLQa8oImJtLVBwaLlzEeVzFo=;
        b=b0qpvNtVB3FlS8yND78WEgKxQ488eIajmpkVIQXg4pm6LN0mY7VRyvD+kmod8NsTNw
         08WVshJYPcgifC32l1dLyHamF/3kabpFINQUmgVROLV9WVQIoykZv1M3JujQBEk0h64o
         2EcscrXFq0PaAKgLr/ZAn5t5BpeolbvptNeokAdZTek0xjItDmYkZmL00KZqRU8L4tA0
         y/uIJNjvzIGAKFWRSUaAgbJUOOhpdyDgczUxUuBTawlFRJJd5X2gP1tr/RikVAhW980X
         +Zp61RtFDAiJ0/Y/J05t3bo64RheSrOjamu/Q+Fbph70rIG4NvwqwjrdJltMVmkBPFYG
         EaFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780661987; x=1781266787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gz+VtwQhYk3ng5JxyiUgLQa8oImJtLVBwaLlzEeVzFo=;
        b=k/kh6NBbGopWCWvEcuBRdKs8pUH8K8iJ7VtGMUvU178mwQvKXJXCHKkIzD01EYZIqS
         D9vxHIWRrmtAGlpnQc4IGJBBu3mjAk60zEho9age7tVTzTNHPoXT7hrXTjR3vHcEkXx+
         86pXEuUeiUA0etrjvYSmmIP5OUBu8BahtwWteB7zDqvcPhToEoh9G4LbtY+0k9bDmhhh
         rvUx1jAyS04n+ReiHttd7DjJBdPjuvyOR6igyOMKDVikt5wGUfFtWoCnHHR+9aG3LT/N
         WFwySsvhqxTkIPdCtZAPh62G0auvr/kHWi86nW6IRntXZdwaFO/j0h4DOuKqnENwn8Ln
         tgdg==
X-Forwarded-Encrypted: i=1; AFNElJ85qNESJ/BuK3CFTrGyfISPcxGEFNgtCkVS1p3PPpjn2W/fba7S7nc9st8v6ubDs0pt1oHNm88kwQ==@kvack.org
X-Gm-Message-State: AOJu0Yyd/kYjfxVUvu+zb78F+JzBK5fZLpYe0ZJ/VKDykxzCBG8HyhL6
	lvEIArHddF+chLSgkd6WkT0nEMeA5E1PfjuuGpIWCojzfg7Tqu6tNPqP
X-Gm-Gg: Acq92OHrcLIIWB9F4Jb91adihy5O9q7ey+2c9Nvac/0J2hF1IyZ/RMY2YdnJlfsNCGA
	By3o/991gnMxiBPtcMtDpEqULEAzozBPxEyROmZlSyLq3dSR4UWuqTGbIuZK5vOi1pNil9tHn4Y
	9OJB10Wm22Ev6f6291vd7BTq3ohVXOpExjuV2c3KQXIubZpwZTkMHuLahD1LBhUvJvCu13lZ66U
	cUGDLcab9zAK0M60NmuSFy8UCWyXJz2G1yEUSRov8/xSEld15hB2Y9VUfvb3SJqElUZ9XXnDVYh
	i4P4LFyDJ+u9vswCJb7aDkxvlqwwiJD3xgEfK+H9SLg8wO1peKp3XQVvvcWhJbv9HeHxY7Z0Otr
	pxhFOEcV9lTyQJG6SsQNlC7RaQVNvHZyEUEuMG6decejz3pyGhkdltgo4kTH00XFNenj9KUfRPr
	xBdNojBnviGSHCO6eznq2AJOHkVO+8YCjPoX4VeSf4o7tB2L1fVHr2nhkqfn5anX9O8R1KF9hl8
	ysA1Fsq4Q==
X-Received: by 2002:a05:600c:1d12:b0:490:7227:100 with SMTP id 5b1f17b1804b1-490c26049a0mr52430315e9.18.1780661986468;
        Fri, 05 Jun 2026 05:19:46 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3cbfe4sm152016275e9.7.2026.06.05.05.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 05:19:46 -0700 (PDT)
Date: Fri, 5 Jun 2026 13:19:42 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Stefan Metzmacher <metze@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski
 <luto@amacapital.net>, Askar Safin <safinaskar@gmail.com>,
 akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
 david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu,
 netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de,
 viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260605131942.4584728e@pumpkin>
In-Reply-To: <512d948f-7883-4d8c-b2c5-a777e70ca975@samba.org>
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
	<20260602225426.122258-1-safinaskar@gmail.com>
	<CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
	<CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
	<CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
	<512d948f-7883-4d8c-b2c5-a777e70ca975@samba.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 43tbrdf6pyj5iqkzoke94gm3q8krjre7
X-Rspamd-Queue-Id: 3B0031A0007
X-HE-Tag: 1780661987-642182
X-HE-Meta: U2FsdGVkX1/Xi0qG0no0vaxpVWmQ+HHVIA0z1e3EC/7V+KAOAhQluKPt4gnY+V+1jfALhl7yKwXMg8n/pweAOE0u9Knr7r5MRlytfVmE1uhUeLatu2v3PvuJr7I/3pzoZKjZ3ZaZRhl0tv1waKyuuZRreIT9bpSqrpAu7qZO8k+o5cOAdT6PvlA+F+4Q+w9jeFQKDHXVp0bIJ1Acyd/IhCuVA+YLxf7/5XF5KaSe8QXmtl7PdP3wBBUK5bbokQjwbHOq5//HtEVELCfIUgcY6mpqtCTUdW1k+wx/NQRC9bPlM9vYO5xixM3izCDhPiLAzWQ9plWw9r2UdvqpuIMclTbAmiGTqGLEcJKA+5OLgO3jh0OAJI7KBfIKDYsiVxbTyZmmCAF8fz3drhvoPV1HJkRAAC6FBfNITk23sTiClYt5SUKKRLwUO/T9CvqL7KmC5HwPBCAoZ9yBRwdIzMMyWxjXAeaY8O2IpO2P3T4M8jSNjtzmgDnmiYs+qUWaWrrNnS8b6EjF5SsUk48ur+RZ07adGi+7u6fyX+ah1Vb9QfAumOz3GXLal5+ZgXlnPE61bfSMHqma5mBhn4qDt2THX0vQT1lq6n39zqMwqVCTdfHFplRBrQqtUS+NQi8XV0x8gKQk19O/sSqdsOlWYh7FcVw2lL2ulQwLR5vyLyOUaWu0FIKxjwydUuQOLtiHMNeYKepoEnyOPJeLyBJxwssYxV5wtVFKy+wJHwEr4ifO3gE/Iq1qTwElHrFfLSDJu3dyYdkvpXHXiKnWJS3US08XZeGowxHtiVcwt89fXfh0u/0aEEQm1PFE8B13Pl66PeR0xe26ymtqGCORSk63y7r/TBXZcWaJmhAMz3ux6aRoOUF04UlSHJ2jZ+24EpKZhBgC9l2D0C2Y6ejK27l5B+ZzcVGIXapFiYX4PcZHyt2Pl4o6W8CPkscrmmmYKKm+x6I9xLuacc8OF36RYnUijWM
 JBmcp/Oj
 6rA3sx/8z9r2TbJ2Ad/Cqjyeiv6TIavxwOneGegbT/hLDfRiyl8T+CRS/6wzRyCf3TtJynU1cE8KlZ2e5/Z7K/z3shAyn6yWjHhp917jAfk1Y0POSqgRgyvoi8mOXeQYXYGpPsZtMQGvimgWGDGdbKSeIhTR56DXQFgLQ5CoOibqxYabTVXr2pYRrxvkfNNxMAGcMTAlEOg2TJtJ4JNLan7ZO/hsBPEllsM1WDRRnkaSHjlyubctsYuSSCBa06+1gPBjPUYuB4rjR0MCt+8umkTdNZemgiatrbD7webnNNEMrb9FTiKhSmGbJZZOlecF8Misq+JfmJb8dBdljBlpRMmqSNxbQBVoFtd3FSznu0LoPSgl8sMm45kvoXWYj1H6KWyK6EvSzNzgJ6rNwS/zWK1p/hJFDlIddTsSOyMzdLxpvDJIqpoTenEW3UVcf1jT9uoEGLGqWvSqfyJ5Hj1Zw+/UqvxQjn2wyQ1wgHjBwjJfNvl8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Jun 2026 11:43:45 +0200
Stefan Metzmacher <metze@samba.org> wrote:

> Hi Linus,
> 
> >> Am I understanding correctly that this will completely break zerocopy
> >> sendfile?  
> > 
> > Very much, yes.
> > 
> > And it's worth making it very very clear that ABSOLUTELY NONE of the
> > recent big security bugs were in splice.
> > 
> > They were all in the networking and crypto code that just didn't deal
> > with shared data correctly.
> > 
> > So in that sense, it's a bit sad to discuss castrating splice.
> > 
> > But it's probably still the right thing to at least try.
> > 
> > I've seen very impressive benchmark numbers over the years, but
> > they've often smelled more like benchmarketing than actual real work.
> > 
> > There's also a real possibility that a lot of the sendfile / splice
> > advantage has little to do with zero-copy, and more to do with the
> > cost of mapping and maintaining buffers in user space.
> > 
> > If you are sending file data using plain reads and writes, it's not
> > just the "copy from user space to socket data structures".
> > 
> > There's also the cost of populating user space in the first place:
> > page faults for mmap made *that* historical copy avoidance basically a
> > fairy tale.
> > 
> > And not using mmap means that you have the cost of double caching in
> > the kernel _and_ user space etc.
> > 
> > So sendfile() as a concept (whether you use combinations of splice()
> > system calls or the sendfile system call itsefl) isn't necessarily
> > only about the zero-copy, it's really also about avoiding the user
> > space memory management.  
> 
> I don't think so. Ok, maybe for webservers just serving tiny
> html files, that's true. But for me with Samba it's really the
> copy_to/from_iter() that is the major factor.

Is that copy also doing the ip checksum?
I really can't tell from the code (it does sometimes, even for tcp).
But I can't help feeling that optimisation is well past its sell by date.

-- David

> 
> We can use io_uring with IOSQE_ASYNC in order to offload
> the memcpy cpu wasting to different cores, but it's still
> wasting a lot of resources.
> 
> For the case of filesystem => socket, we can use
> IORING_OP_SENDMSG_ZC and that at least removes the
> copy_from_iter() in the sendmsg path, but the
> IORING_OP_READV of buffers in the sizes up to 8MBytes
> is wasting cpu in copy_to_iter().
> 
> For the case with smbdirect and RDMA offload with 2x200GBit/s links
> changes from only ~33GBytes/s are used (and the server cpu even if using multiple cores)
> is the limit. Without the memcpy waste ~46GByte/s is easily reached
> and the limit is just the network link.
> 
> Maybe another solution could be having a version of
> copy_to/from_iter that uses async_memcpy(), but didn't
> have the time to experiment with that yet. Maybe a new flag
> to preadv2/pwritev2 could control that, so that the
> application can decide what's better.
> 
> But without an alternative please don't kill splice.
> 
> A lot of people are frustrated because they bought hardware
> that is able to handle a lot of throughput, but
> e.g. with the default of smb over tcp they get no
> higher than 3.5GByte/s on a 100GBit/s link that's able
> to handle ~11GBytes/s. And io_uring and splice are
> a key factor to fix that.
> 
> Thanks!
> metze
> 


