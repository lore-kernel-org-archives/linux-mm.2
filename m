Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23779606A327
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 05:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wIWvYtFj
Received: by kanga.kvack.org (Postfix)
	id C2E246B05B5; Wed, 11 Nov 2026 00:50:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDDB96B05B6; Wed, 11 Nov 2026 00:50:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6426B05B7; Wed, 11 Nov 2026 00:50:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 886496B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:50:11 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1658EC0210
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:50:11 +0000 (UTC)
X-FDA: 85421762622.21.F025A25
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1D57BC0002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:50:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=wIWvYtFj;
	spf=pass (imf10.hostedemail.com: domain of rohithmatham@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=rohithmatham@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794376209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qLjMFu8J4R65tVxrQqm5yS5zqVzYkCd8FhHMRrbl5tE=;
	b=ncrVmZguODCBoANzB/53KNQfedX+Sj918qd7WvU3GAYZX25lIm32mbClQ78sLmuIZTbZw8
	ai3CaCSodD5+NC2QQmDIZEoQ9Rltqxhy0mQkccRuxE4zieJPdjhTyQd+mA8YZKOLSoHlAI
	QL+RMf3fe4u2cRSdSm6E0dRAYslIsX0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794376209;
	b=xS+Wn0KZJxO6z8ErZr916RO+OArd05v+bPpUh4bBpIW4XTF81tEFmnqtyNtcEnbVfldqRa
	QAtblDeWTP137io6+XavFeLkF3RiQbgnNCD/8soJiGe2zBMiL9IsYC4JUeyui25Izvv4E1
	KicyORz7xv60r0l3lVJiQw4pQSnKGTo=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=wIWvYtFj;
	spf=pass (imf10.hostedemail.com: domain of rohithmatham@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=rohithmatham@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7f84a55cc06so1674334a34.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:50:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794376208; cv=none;
        d=google.com; s=arc-20260327;
        b=HdAhCbB1E1i3+uQ7g9FI/BLM13j/pbk78kI55Hm8xDp4F/fkO7JMKEOHV0jQaT20O2
         /lXnJJlSa0Hg9ks2Xl4XQNcOZVNr+seesXaWNXouqEWbsoGEiZs94qzDDQYi/jiJ8mLJ
         CqWRhFtSGz6SW7dX4zvFJPo421o3qYULX2yl4R0PtwIOYrMuCtWRhVpng1hhfyHoqM1X
         WNtb8OBidl9iUW3s5Tvqbv3vFnoVNGWzxll4LFBjKWzQvlDOqJe0YMh/S01SE/L6ZuR8
         5jdOALwGZ8oyTWCe2UuNng043oXB08/GKPK6t2wokF/7WWkjaPjxDCMLfFHbg9FPjT/0
         gVNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=qLjMFu8J4R65tVxrQqm5yS5zqVzYkCd8FhHMRrbl5tE=;
        fh=osemRs35mg537oR+odJC6gbxBAtibEfCpgGs5SvHWI0=;
        b=GrvdRotFYEfAQfR6NesssHpwJW5u8JA9GEDtpbYtwGE3cRu5GF1UGAgwYCPGBtKKeg
         SNjEjj/riVFmFgFv4Mf7xK4ibkZhBwmU2kMhX/um4mMDrA6foGYVB9W2ITXG5Qs5nurB
         A5MLk4e0WMzpGwCLTvhrKZjbetP4QYRILSUt62EQcvm3G/VNDawFCD+ahGA4TabuTGl7
         ywIi9EqvIz6WcJtjx70b3DS/HgNTRUVkeBt6d+M8oXgQNX3Tr4gRNPBeSWPpfqhX2y5O
         iQfor+C8PJx9K1jkR49GUmyFVlQglH4AHbxU7MvjKNV1aMtTXXW6xoRPrPGGXXf51Vw6
         wDhg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794376208; x=1794981008; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qLjMFu8J4R65tVxrQqm5yS5zqVzYkCd8FhHMRrbl5tE=;
        b=wIWvYtFj5V065BLERIU0AB1nI6SRycGz+Ke3GDxHLkQREtWtSCfYICrW3PXNnyTT0B
         c/sLkT0tMLLdWnQ61Jry+UEI4Z0gXRIQlP9PTllBwe6Sl02+Bm+Ofn26ajaXii5ODNhF
         HMfLc3TnW1b2Mh0/+L0C6H7dCjMDveLpFlwAVs4hOmxsluZi3794pMqKltdAM0B9CnWN
         SEO8AKAejLuqon1Yk8/dZjZb9n0JZ11+8C3QgAfXYs89dwn1NDSvsfORhmQSZo/BFWIr
         GlfmnnOoeRvZJ10zoAXvvBNriX7RRhIv7o/2vWfG4ghNmI46qeJ9p6KDxXo+AbkpGtNs
         dsvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794376208; x=1794981008;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qLjMFu8J4R65tVxrQqm5yS5zqVzYkCd8FhHMRrbl5tE=;
        b=UZUo5p/veSWUL0JFkrUn5N4Zt7gMMCY1Ulzp7z/kvtMDXUwFJFQXo/21W1s6ZTmaGw
         Kn2G0MHUbdoS+CE4zHOXJmCf1XzX66+8lxpfsajmoM5GGSzq6TLhUbBuFqZLzbkZOAVP
         EZTC0Z64erx7c4SxMHYW5l7O2NUvXmJjlohQmqyiR+Y+/vPaALMS8hYnpD+DIeFZJQ54
         o22aVMRIOjtwf2rcfo5XP72YYM/Kd5MUMkw1YYeW6TzDewxThQ5y6e3whzqC1+7Q4bmZ
         9UWAxfftJvQv7Z7eahLokKiGCpl3c7UlkVz4Jij9zguFB83lewRLtdiH9QAGkCTV0qqo
         /zfw==
X-Forwarded-Encrypted: i=1; AL+hErFlp6dUTiHao1fLjXn1CMTmhBPqxxYlwK0asXO2IioCt9oUvUmb8OwkAFtiM4+/MY2c7u1JZ/A5EQ==@kvack.org
X-Gm-Message-State: APuU4Z/fdfXOflTi+kQrEYdVllUtYAZkopOD6sjAw5I7zKIqJQmzw1rc
	zIe/B65F666Wq+8nVxQ+M4kqNXT6GY9oo1aha2wCoU5zu6N+uKHp7022zLMC0wiQQvERdLSvTj7
	op7qhHBYbX/yDMXHYJoaxIkQlEjTf1Jg=
X-Gm-Gg: AYBFou0lAJ9t+wUGVKVbGokk/8c557a63IAtnNPx0N7XR225NKS2Y2UYKfewMQDKTm1
	367SDBnZ+HYc4UAqIb5XX/W8If46ZUQ/EXV8f8UKn5xcNr48TvW2XVJpbdcnbK26X07qlTUEEx7
	+07OS6Sw46Wm95DkCURKCNmrPL9UlzH6WsxxbE1jGVw3aTow9PDsHlEHlk8tGXta6ggePzwLKHj
	jmuYEh85UquCiScxZQ0EIorYJu3haZmRA5hqcj9qH8ZPm7R2KKDIY0l7+zqm3sfWSgXOxQB+4iy
	Y+6LCiBWEBU9/TMxhNE68JSzJTlb0ohCW9NVw6YP+iZMJt+nPHjN1tp6HVG+k94aD2EEI/EEmJO
	0FVxBRPGIk5IDnKAQGHvMfDWcZ4YyYL9d8mFNaXfATWwwZC+vpBz7h0Z5r2xUoNw8ajhDKM4HcN
	wzK9tpE6B6RmKM0wWqtaDS2JzaUfJ7nI7irYZIX8qfhh9gtuHI008=
X-Received: by 2002:a05:6808:1686:b0:567:fb7c:5e51 with SMTP id
 5614622812f47-56b97b176b2mr1256490b6e.50.1794376207565; Tue, 10 Nov 2026
 21:50:07 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <6ae09458.f0fe5aea.79aa1.008e.GAE@google.com> <20261027101009.18e9136537144533915008e4@linux-foundation.org>
In-Reply-To: <20261027101009.18e9136537144533915008e4@linux-foundation.org>
From: Rohith Matam <rohithmatham@gmail.com>
Date: Tue, 10 Nov 2026 21:49:56 -0800
X-Gm-Features: AclHuK9vREYDdXUQROwalxOpZu44UxFr5X6sOJrgEYZa8zOqfkVcD1SaqwiAwi8
Message-ID: <CA+FtcEqSLhNZHcYVEiwtD-CYkf6PEmVfi+tVc852ZdTTtbaaAA@mail.gmail.com>
Subject: Re: [syzbot] [mm?] [usb?] WARNING in corrupted (4)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+9fe09db3795456e0b442@syzkaller.appspotmail.com>, cl@gentwo.org, 
	hao.li@linux.dev, harry@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-usb@vger.kernel.org, rientjes@google.com, 
	roman.gushchin@linux.dev, syzkaller-bugs@googlegroups.com, vbabka@kernel.org, 
	mchehab@kernel.org, hverkuil@kernel.org, duoming@zju.edu.cn, 
	linux-media@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000720aef065ff9c40c"
X-Stat-Signature: rcep8j1hddmx7pn9rsqdcefaj3hebxwd
X-Rspamd-Queue-Id: 1D57BC0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794376208-254690
X-HE-Meta: U2FsdGVkX1+8VvI3+HPYjIsVPbsEGbP8vucSMMGZzLxeHxqguCP9ZKzhRvFk0n1KUmI91eJ5B5cq7M4nVp2MiyMsoP9Q2aEMyPGS5WGTNA8NZNdeagweJrjSKlTlZL+pdJIGt0+NptEERtqs57j3n33BrhatD+kGWeU0OeVSbWb3RWR8rX4UOJu03htrAfMq2terlSkfUhSQ55jmAbc3J7/vThWboDQxZJZ9Z+oyEsZTNuXOG21uhyRhsd2pYLONZkz+LZRAiG0yIQqtI2JZLZ7zg3F2QjZF9V4Cw2yUmuJutr6uSewPSSnEtIXr53p7AB8ssq3q8a0FO761c86oio5Fimj9BAP6RJr1ATM4O4vLMTjeB8rVZ7ZKlKaRtt5zb577ll3UtECU/T66O8UmqUoUUTI+S5kIGaOK/mPw0b4a6TbNdyUFmannJ7iyfAQPm+kZjBqdjm1+nkwtLA7D4omNgv9eYeGRD1jCeMX71u7Y1vtQiUguvDf5BtiH3/NIPM2IwkBhKbSuZNDgN1C09L5vwU/6ZcpktHD0h7lVMS59WkjCaEPDfRzDWDtLigRQgoBWnED2ZW52+4W2NGspAnz4bPyGHYbnWNVUnA89L/NSJMnoNHSmhhD4XHpuEpaiJabc4IHRUwZblOp5plYiJporpL+LpFBfwey4iYjjnTm1aJMlhjpJFcBihhrgT5z794pziuM28OCxyp83O8xfJ0Xo/f41BKDrxLEFkNtaiUF9oacrF1vcbvOPD9DSphvP5dbJKvLRos1Y7deRMr/5wcbKO8TQP8DSAkk9ZD6nFF1qeEvLqemByC7+5MwHEQCl0GlkKjFzkEDuFPIxiP8OLecwh1W9NUajYPePQYjJSfUXkTqsOV8ea/UZQENM4KGRbuB+EDApy51tm5w0ew/cRRIBUnCkT7xcONhFvs+zih3rBhYo9FSkFIBhKIPZd343eZZEuQdJNma9NeJeyJq
 0KvepYz6
 qVS7SqoMMhrNRnlFzWlfyNHvJDTxz2yErgmDThmRv45qDgvNPygavGWQXMWOelV/3tT8O60Sp1yctU91Dpz/XmlY45NqkAUV5W61LfwCrmQiYNZjy80xh8YnM/HhMAyov2x4bTGmV2c6chTcR0YqPP5NIZpiRlDWlU/rkhIcuMtEY/EY+1igUWRUX5H++BPKt0ntvdYbtviNwYFp647R+XY6b8lk9ePygFSSfRC+SJSyN0vpY7i1DQrdlS2lRQxHv8rzs83rS4NOk//GH3t2yN0DCpbWeTccRTzkGS6Dcj1aAXnOPWT1YC5/z1PMyr/5WFlA3fdO14iMeJa8YDGLJg2G6Kh7eZS2uJjJiK9uEedNeyw/JMglfuVVK5B8wHtsHXHUNDwpvTpd+PUULzVC192/eF3DUlgWdXG2ccub0JRNW7tTgfoFA55Eiw/65tCXfpJJSsl/bwysLLuxCOSpmu+ZJUj/urSej0nnts20jhiFC9O7q9QHkWte6eV9lXxdjD1uJ08PPuAQTWb1DjZdBQIESo2WKecvlPWwo9LCd4W6FFfqe4q1zy0+YrF3NiDSI5U1ll5RVw6uchg3DS/DEYb6Gu7oXl+nqxKxZ9btWSslvNZpPHtHU0DomiFjKBmsqx/DA4LXczHN+lSzqmnmAzQYi6OXer7gITdADbEnov2eh7UxJ0or6h0DdBog1laail21/SI8+N+/98RwZO4W23sToAw81blbuweWshEoBvs2M1ZF62j5AyUB3CW3Jm5BWRxclo/pbmPFEaFsDcWe+GcyhF0WSSIibhTCkoB07O+cdud19s7gex1N4skICeTinX3DA024p1hLdKKlC+nc5boqtIfzw1lPJNYLj/oRJ7/UDykZ+jOPwEHtH5aVRkIMzve3BgMIqcbRSNjFuvgd1Z9NnZhCLloC74dvjMYCaUySerZT48vKQKIsrEHYQdvS/HYbfKsg1g5avA+FovQmUSVMoErRj
 8SqNEXB2
 xE51Z5AajA0pML4QT8hdrAxtI/aWipdk12rVXLkPG6+cs2hUJa1fUe+Yx9WPIPfBsXlcw10VjrtEN7nP10PjhIjaXRN3VLIMjsL+MoBSwMCgLuSNcMoQbS7iAa1lMcCPpVadmhMiwtO+F+Qpi8TRKvNTuoTyVxhocmPMIpZl2Dz0gcFPJVoUYQWzG8u3TpLxN6006WXW/J5SAnl1AZJVfVJFXsvHELygFnoRAfHMGhFtNDYvDEcICu35sAXb4b8E9uZ5zTUUBWMDBUJ7we/kOqTqVObpdvim+2tioMybipD5iCuYK9hbvnEhf7/4YDQO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--000000000000720aef065ff9c40c
Content-Type: text/plain; charset="UTF-8"

Hi Andrew,

I retested my v6 patch against the October reproducer, and syzbot
reported the patch test as OK.

The patch removes URB_FREE_BUFFER from the Siano-owned buffer and also
fixes the related work initialization and teardown ordering.

Patch:
https://lore.kernel.org/r/20260601201639.63171-1-rohithmatham@gmail.com

Mauro, Hans, could you please take another look at v6 for inclusion?

Thanks,
Rohith

On Tue, 27 Oct 2026 at 10:10, Andrew Morton <akpm@linux-foundation.org>
wrote:

> On Tue, 27 Oct 2026 05:08:56 -0700 syzbot <
> syzbot+9fe09db3795456e0b442@syzkaller.appspotmail.com> wrote:
>
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    5b0764a53235 Merge tag 'drm-next-2026-10-21' of
> https://gi..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13739fc9580000
> > kernel config:
> https://syzkaller.appspot.com/x/.config?x=fd1433abd362f255
> > dashboard link:
> https://syzkaller.appspot.com/bug?extid=9fe09db3795456e0b442
> > compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD
> 22.1.8
> > userspace arch: i386
> > syz repro:
> https://syzkaller.appspot.com/x/repro.syz?x=11cb9b0d580000
> >
> > Downloadable assets:
> > disk image:
> https://storage.googleapis.com/syzbot-assets/05ac8658d211/disk-5b0764a5.raw.xz
> > vmlinux:
> https://storage.googleapis.com/syzbot-assets/9cfb73243216/vmlinux-5b0764a5.xz
> > kernel image:
> https://storage.googleapis.com/syzbot-assets/fc45c7faf785/bzImage-5b0764a5.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the
> commit:
> > Reported-by: syzbot+9fe09db3795456e0b442@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > !PageLargeKmalloc(page)
> > WARNING: mm/slub.c:6855 at free_large_kmalloc+0x97/0x110 mm/slub.c:6855,
> CPU#0: kworker/0:1/10
> >
>
> Thanks.
>
> > This report is generated by a bot.
>
> So is this report ;)
>
> This looks like a double free in the Siano USB media driver, rather
> than an MM bug.
>
> The failure occurs during USB probe error recovery. The allocation
> comes from smscore_register_device(), and the page-owner records show
> that smscore_unregister_device() has already freed it. The USB core
> can then attempt to free the same memory because smsusb_submit_urb()
> sets URB_FREE_BUFFER on a buffer owned by the Siano core.
>
> Rohith Matam posted a patch in June which removes URB_FREE_BUFFER
> and fixes several related URB teardown races:
>
> https://lore.kernel.org/r/20260601201639.63171-1-rohithmatham@gmail.com
>
> I don't know why that patch hasn't resolved this problem, but it
> would be worth revisiting before developing another fix.
>
> This doesn't appear to need any MM changes.
>

--000000000000720aef065ff9c40c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Andrew,<br><br>I retested my v6 patch against the Octob=
er reproducer, and syzbot<br>reported the patch test as OK.<br><br>The patc=
h removes URB_FREE_BUFFER from the Siano-owned buffer and also<br>fixes the=
 related work initialization and teardown ordering.<br><br>Patch:<br><a hre=
f=3D"https://lore.kernel.org/r/20260601201639.63171-1-rohithmatham@gmail.co=
m">https://lore.kernel.org/r/20260601201639.63171-1-rohithmatham@gmail.com<=
/a><br><br>Mauro, Hans, could you please take another look at v6 for inclus=
ion?<br><br>Thanks,<br>Rohith</div><br><div class=3D"gmail_quote gmail_quot=
e_container"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, 27 Oct 2026 at 1=
0:10, Andrew Morton &lt;<a href=3D"mailto:akpm@linux-foundation.org">akpm@l=
inux-foundation.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quot=
e" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204)=
;padding-left:1ex">On Tue, 27 Oct 2026 05:08:56 -0700 syzbot &lt;<a href=3D=
"mailto:syzbot%2B9fe09db3795456e0b442@syzkaller.appspotmail.com" target=3D"=
_blank">syzbot+9fe09db3795456e0b442@syzkaller.appspotmail.com</a>&gt; wrote=
:<br>
<br>
&gt; Hello,<br>
&gt; <br>
&gt; syzbot found the following issue on:<br>
&gt; <br>
&gt; HEAD commit:=C2=A0 =C2=A0 5b0764a53235 Merge tag &#39;drm-next-2026-10=
-21&#39; of <a href=3D"https://gi" rel=3D"noreferrer" target=3D"_blank">htt=
ps://gi</a>..<br>
&gt; git tree:=C2=A0 =C2=A0 =C2=A0 =C2=A0upstream<br>
&gt; console output: <a href=3D"https://syzkaller.appspot.com/x/log.txt?x=
=3D13739fc9580000" rel=3D"noreferrer" target=3D"_blank">https://syzkaller.a=
ppspot.com/x/log.txt?x=3D13739fc9580000</a><br>
&gt; kernel config:=C2=A0 <a href=3D"https://syzkaller.appspot.com/x/.confi=
g?x=3Dfd1433abd362f255" rel=3D"noreferrer" target=3D"_blank">https://syzkal=
ler.appspot.com/x/.config?x=3Dfd1433abd362f255</a><br>
&gt; dashboard link: <a href=3D"https://syzkaller.appspot.com/bug?extid=3D9=
fe09db3795456e0b442" rel=3D"noreferrer" target=3D"_blank">https://syzkaller=
.appspot.com/bug?extid=3D9fe09db3795456e0b442</a><br>
&gt; compiler:=C2=A0 =C2=A0 =C2=A0 =C2=A0Debian clang version 22.1.8 (1~deb=
13u4), Debian LLD 22.1.8<br>
&gt; userspace arch: i386<br>
&gt; syz repro:=C2=A0 =C2=A0 =C2=A0 <a href=3D"https://syzkaller.appspot.co=
m/x/repro.syz?x=3D11cb9b0d580000" rel=3D"noreferrer" target=3D"_blank">http=
s://syzkaller.appspot.com/x/repro.syz?x=3D11cb9b0d580000</a><br>
&gt; <br>
&gt; Downloadable assets:<br>
&gt; disk image: <a href=3D"https://storage.googleapis.com/syzbot-assets/05=
ac8658d211/disk-5b0764a5.raw.xz" rel=3D"noreferrer" target=3D"_blank">https=
://storage.googleapis.com/syzbot-assets/05ac8658d211/disk-5b0764a5.raw.xz</=
a><br>
&gt; vmlinux: <a href=3D"https://storage.googleapis.com/syzbot-assets/9cfb7=
3243216/vmlinux-5b0764a5.xz" rel=3D"noreferrer" target=3D"_blank">https://s=
torage.googleapis.com/syzbot-assets/9cfb73243216/vmlinux-5b0764a5.xz</a><br=
>
&gt; kernel image: <a href=3D"https://storage.googleapis.com/syzbot-assets/=
fc45c7faf785/bzImage-5b0764a5.xz" rel=3D"noreferrer" target=3D"_blank">http=
s://storage.googleapis.com/syzbot-assets/fc45c7faf785/bzImage-5b0764a5.xz</=
a><br>
&gt; <br>
&gt; IMPORTANT: if you fix the issue, please add the following tag to the c=
ommit:<br>
&gt; Reported-by: <a href=3D"mailto:syzbot%2B9fe09db3795456e0b442@syzkaller=
.appspotmail.com" target=3D"_blank">syzbot+9fe09db3795456e0b442@syzkaller.a=
ppspotmail.com</a><br>
&gt; <br>
&gt; ------------[ cut here ]------------<br>
&gt; !PageLargeKmalloc(page)<br>
&gt; WARNING: mm/slub.c:6855 at free_large_kmalloc+0x97/0x110 mm/slub.c:685=
5, CPU#0: kworker/0:1/10<br>
&gt; <br>
<br>
Thanks.<br>
<br>
&gt; This report is generated by a bot.<br>
<br>
So is this report ;)<br>
<br>
This looks like a double free in the Siano USB media driver, rather<br>
than an MM bug.<br>
<br>
The failure occurs during USB probe error recovery. The allocation<br>
comes from smscore_register_device(), and the page-owner records show<br>
that smscore_unregister_device() has already freed it. The USB core<br>
can then attempt to free the same memory because smsusb_submit_urb()<br>
sets URB_FREE_BUFFER on a buffer owned by the Siano core.<br>
<br>
Rohith Matam posted a patch in June which removes URB_FREE_BUFFER<br>
and fixes several related URB teardown races:<br>
<br>
<a href=3D"https://lore.kernel.org/r/20260601201639.63171-1-rohithmatham@gm=
ail.com" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/r/202=
60601201639.63171-1-rohithmatham@gmail.com</a><br>
<br>
I don&#39;t know why that patch hasn&#39;t resolved this problem, but it<br=
>
would be worth revisiting before developing another fix.<br>
<br>
This doesn&#39;t appear to need any MM changes.<br>
</blockquote></div>

--000000000000720aef065ff9c40c--

