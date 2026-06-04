Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E13EECD6E57
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 01:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD0C06B0005; Wed,  3 Jun 2026 21:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81B96B0088; Wed,  3 Jun 2026 21:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C977B6B008A; Wed,  3 Jun 2026 21:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B86CF6B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:52:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A9291A04AC
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 01:52:38 +0000 (UTC)
X-FDA: 84840555996.27.FE07134
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3569420002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 01:52:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=WBOPrWqV;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780537956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ti3H/yNlOCN9jiz2PA4OGwlivuSMT91KkxAffb1eRD4=;
	b=1YO5WNky07PlCSvnQMdTgiT75Bj4VNJiDmnJcKihdYV8mV0NXEDIdp56Qtb0lk0Vk0TTpB
	DvgNMuDVCnrR7fwJDJDT+hqrIYw05f9b6LdyFwV/OeBPnM9bkduwPYhP1h2qRx4sDjLnyL
	dMN5A2XooB0n+1cvevwIgcW0Iwd1GEs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=WBOPrWqV;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780537956;
	b=nj3gpRreBuOINe5a2r/49bnjxVnmSXSwdAQgqkEpq/E6527VivHFJPD2TirI/u0Zlkk2gZ
	RysipkKjlk39kzhGrKI0h48IJPfnlfNeVyRBbZfTORSw2duujlAJquN7FlUCVRnN+tnEf3
	wyR8LE2iPbq2bW72qd0qDqj59I8yLwc=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bec3f69d343so19000466b.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 18:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780537954; x=1781142754; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ti3H/yNlOCN9jiz2PA4OGwlivuSMT91KkxAffb1eRD4=;
        b=WBOPrWqVQYk5yZ0/uIUNUiF5j+L0+s8Uszox4x+t4S36raIBIZ20BJzDT/WWxVm613
         UiQPSO6z/V3/Wtdd4y1EZGxi80mGgyhoD6QffEM5EE7u4fogWOhVx9cR96aiVS73YRPt
         hOheGsxtbVz/2VyAU6BAubsLUiq71Cz6bZF9w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780537954; x=1781142754;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ti3H/yNlOCN9jiz2PA4OGwlivuSMT91KkxAffb1eRD4=;
        b=HTtnCQ2HVgYTr0H0rKGwFJ5At4jzFogK6CPnFzqCl0Gqsw/jtCUAheVGDzuCt81DjI
         oGGtHBIIHBTkC8O8EUSKXToAaCw6BFLYB5hNuNmyS+IVPoKh68GzlCnc0EV4j1wlpfFJ
         7aRMxRG0uy52URBD1CF35ZQe5c83+nuvB19bFQVSkMkdT77Pm36piwapbWbLeWozDtWc
         O4cIC4AxPCOlS9OTWy3KNbSq3iVAPst2B4n7w0+wTeOuCEVe4nESJkF9khnkEi5vlONv
         nE1FncNrjkvHw/viIJPII9JlKhml4Y5Sn8P8SSh8Ya/aOkykdikFe5/P9pScjg/sM0Md
         qD5Q==
X-Forwarded-Encrypted: i=1; AFNElJ+y7GrnZbUnRbKWsEbLRK0W6lMyPY69HT0+MS0Af0a2T4zzD81y6hdmLJEDG9aq2LPpuv7ap8xEdw==@kvack.org
X-Gm-Message-State: AOJu0YwI80+c4cPh2C6TsldoZczUzfMmZ27+jNYbHAdf8BkLjh+1nZ8F
	vwHf0IJUxuWDd/+Q0ZKkSgnvGgAi9aN1IJO9R2sEgMMSChCUiWuF7fhbTDNSxErS4WR4PpAHa/m
	+f3uLt1XgNw==
X-Gm-Gg: Acq92OGB1Y7Yp3S7lAN6QWiDEOSLLTeJ5lnMnQp5+b95TwJ+Hm/v9p40alPVWhjXLyH
	bnxMT/U4aWXrxvsXd4ATr4PsBZ2naT21gjwpdbG6AVt5tlhYybuaYYkGk5gJk4/s2umMJ27unBW
	hyYDcbxni7M05XGPeL5unphMEsZ4UlkPjawyQKoA/jWiJPpq4GpT57PrbqD7EEsNQ0SwvyoCPok
	hewFrxemTfQU7vusvab4ixgIZRfLg38v6niqsrQTZLM0/H0vqPuo5Hw2uAYQMfIFpkQiJemf/PX
	EqcAyEUkn1S0e3mrs7Odwq18zp0AHJ2WTDZ3lH41xJTgY5hKd0FmX9CxmLtJQwlPYfQ7uNgun22
	+cDdeAEtpxzlvqrlyHGBJndzGMz+3GrEEc46Xbd0BTFm35A45Ya0ZoJyVkq3Fb5ADdXJhOdUcrK
	t7N0CT18qvReW//9Ud14PFzIAbwKXDfEV+4AIKojS2GKbjOfkiRisuOzularNfk4oMP5a+arnpk
	QW+I00X4Ow=
X-Received: by 2002:a17:907:9815:b0:bd5:2cc7:d845 with SMTP id a640c23a62f3a-bf0ae4000cbmr326677866b.30.1780537954293;
        Wed, 03 Jun 2026 18:52:34 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf05228a16csm230512666b.28.2026.06.03.18.52.33
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 18:52:33 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-68bac6e24fdso178856a12.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 18:52:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+6eHnEZkJxuEa81UZ/1Uysxq528J/luDmqU2E46VMStepWu0yIDKkBDbWvaeu4g2sMvi9k4/nbEA==@kvack.org
X-Received: by 2002:a05:6402:550a:b0:66d:d2f9:520c with SMTP id
 4fb4d7f45d1cf-68e72250122mr2844444a12.19.1780537952777; Wed, 03 Jun 2026
 18:52:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com> <20260604004559.1112474-1-safinaskar@gmail.com>
In-Reply-To: <20260604004559.1112474-1-safinaskar@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jun 2026 18:52:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgPzxQL9Bdze=qnSa5v8A2D6cPaU0Bi=j4N38+ja1NkzQ@mail.gmail.com>
X-Gm-Features: AVHnY4Ia6Rugs2gzhFv567LCSFsgwGvMvJbpyqp7BVsPOVMqNGKAIqxMQwoy6bY
Message-ID: <CAHk-=wgPzxQL9Bdze=qnSa5v8A2D6cPaU0Bi=j4N38+ja1NkzQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Askar Safin <safinaskar@gmail.com>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org, 
	david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3569420002
X-Stat-Signature: 9cfieh7o31an8ee1hybsu1ux93kd96px
X-HE-Tag: 1780537955-367105
X-HE-Meta: U2FsdGVkX1/sYmNPtwlXpuNjvfLejGyjh+IuLC7ZIJsZKzEaK0Zwzc+p8DkhVLOMJryEq0q1JM0ZdY0bbI7Fo0cl95oRX2uDwONxbTHYG4w7UrsKTYzzYsbJkTDma9z3ULuq6mcDhHC24YtPmloYpLmHi2imYynlpLbI5nMSiYewBf/iYmabzsWvTJpzL8rwbjGH6Lsf0wb6kPSYMugcjL0LKmFIfWVoNARKLqp2bzACWSjANsRrouJ2jzCNoTO5uNb9v25Wf5XRlwKfoYwHpG1QAXqZAkCj2GRcOcirbvl3FW1GKV5TZAfjW7L6hgF4QNus9bdfxsPcdZo+15ZzHLvxWD4CTjcPy6qa+3gZcL32X8qp+0KFXvt5h3+LtNoSft/zgTtDcpEzVMsIPSPUrCOOGA20Ce6nqi6nAgspnlJb99jO8WB1IZYpBYWF0wExEsNR4XoTUebGPUrAptnBeTuB4AqenFC2AEsxiRIB5ifZkPi4f2vdf1Yn26RM4tBKEl/M026km9MJxVrRBFrl3oBfToWfsH1VE6Ucx7MXL6l0+BdzgKG2yMjS93csIl+nCYOk8Ap/3gb99umP9Ppwr7+2c576gLRPQ7vEItXecrtSO1JxHOSbAOiF//2GJHdZ3fIGJmREXeSN5V54NjHbXkgzXMpF2bvqukqYz4cid3NvtigGT1wyr/V7ieDWmh/NEluIUURlinYhv18CGvRS8gu+tGo+eIDtr+2tRdBpAuiXrD3ZVgljNaxCddWpyn7jqHVP3U6KXCJcoxUoG+nblOojBfP8qiEqV6HtT7pzKZBDDfDZcvWZ35zi26cWDj4Hd4AqDiU+7oDxasfiF+uQCHApGvf6ziB5vLKH/GJYn7F27UiDKlaX2k1epk+qbjlPpgSrI4isy/SVuW0RBX6RHxlYIo/ZGzmb+lfS90AlZYYI/KxBlGGdL3KI8ROKPoITjSCFakekzf+KP6LSM2w
 0SjAQ1Jf
 uMpoQOJUMNtQDZUY01TR3FRW9rDlQV+L3hyOIsbnecDVvR0iXUAqNWuapU7IYf8bLZyN6lzvjntHY1pfe3oGdXD5HRpmqT/lFOnBzSJ9wUF7o5zXL2Vr0UOy3F0vuxCBtL6dUqhn4Dpw0XyC8DGPQ3gj0ZU/2Ipw4EyogCg+IeBbXp6W7Dmk+QS2WkuM1mMpMieaZHFBSNLmiBH1v4YGWqozwSC7G8L+yds63gkfBfD9TeTtF2Yn711KLP/5YrWxXaeIr6+jFACJ1TfNNYOQZrP29NRAQtoRnK4Sp+vDNkiVWTc1u5TqTsVkEaFSZKLAW5v5WGEhTXlFQZ/JfnWKalSBEVKDALvUxQ0kOC3fB4pL4kZvR83JSjH7arULht+a0bO/9oBTA0A1Ix7b9+ggWQb9xrLj3Oqf77FwcgdW1Gbh0+lLlIoRGHnrwVGJc/dNa54Oct4kUUj0coZMCOd/ecDi/bawP0PcUDNXAtJJ1UdIDvIJVA2WZpWXndORI/XggMNgBEO3AjmPiot3vsRtVk+yzAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 at 17:46, Askar Safin <safinaskar@gmail.com> wrote:
>
> For example, in vmsplice I do "CLASS(fd, f)(fd)" and then I pass
> "fd" (i. e. integer) to "do_writev/do_readv". I don't know whether
> this is okay to do so.

Oh, good point.

It's ok in the sense that it will work, and it's not really going to
cause problems, but it does mean that the 'struct file' will be looked
up twice.

And *technically* it's a TOCTOU race, where the first time you look it
up - in the vmsplice() wrapper - it could be one file, and you make
decisions based on that. And then pass it off to do_writev(), and it
will look it up again, and now it might be a different file.

Does it *matter*? No. Even if the file changed, and is now something
else, it's just going to be a different file that the user does
writev() on. do_writev() will still do all the appropriate safety
checks etc, so it doesn't really change anything. It just means that
you could pass what you *think* is a pipe (because you did that

+       if (!get_pipe_info(fd_file(f), /* for_splice = */ false))
+               return -EBADF;

and by the time do_writev() then looks up the fd again it might be
something else, and now the user used vmsplice() as a really odd way
to write to a another non-pipe file instead. But the user could have
done that with a regular writev(), so it's just the user being silly -
not something that really confuses the kernel.

Coimpletely harmless, in other words.

But it would probably be *cleaner* to pass in the 'struct file *'
pointer that you already looked up once instead, and use vfs_writev()
instead of do_writev().

And I do suspect that the wrapper system call should use the same

   SYSCALL_DEFINE4(vmsplice, int, fd, ..

that the original used. Because it somebody crazy had the high bits
set in 'fd', the old vmsplice() system call didn't care, but your new
emulation system call will actually see the high bits on a 64-bit
architecture.

Again - that doesn't actually *matter*, because "CLASS(fd)" takes an
"int fd" and those high bits will be masked out at use time both in
vmsplice() and in do_readv/writev().

So it won't affect any behavior, but it does look a bit odd in the conversion.

And I already answered Christian wrt the change in behavior: I think
RWF_NOWAIT should always be set on the writing side - because splice()
never waited after it filled a pipe - and instead that
SPLICE_F_NONBLOCK flag should be used before write to check for
whether we'll wait *before* doing the write like it used to do with

        ret = wait_for_space(pipe, flags);

in vmsplice_to_pipe().

(On the other side, vmsplice_from_pipe() used to do
pipe_clear_nowait(), but I think that becomes a non-issue with the
conversion to readv()).

And once you need wait_for_space(), that probably means that the new
vmsplice() wrapper simpler needs to remain inside fs/splice.c, and we
just need to make vfs_readv/vfs_writev non-static.

              Linus

