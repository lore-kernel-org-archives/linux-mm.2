Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E5D8606A33B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E5A46B05B9; Thu,  5 Nov 2026 06:57:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3D36B05BA; Thu,  5 Nov 2026 06:57:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D2886B05BB; Thu,  5 Nov 2026 06:57:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA2116B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:57:13 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72E84C09E5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:57:13 +0000 (UTC)
X-FDA: 85400914746.12.A2BE57C
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6A1E4160007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:57:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793879831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z2qCIfu1coqF5CKQo/xHkFXbKW7Y+rLlNCa31RZmxiE=;
	b=5HRdEx94nb6xl7IrGAyV86UjQYXkBsaLgHHkn89w7tm73odl2+kbknT/szYhV91bR1KhvM
	Gn4zKz1xlGEBC4O5GGeyPwcUyRpOmS374MHm5ROO4JuVO4PPPVe6MyZX2YGZQ9MycpLCjg
	ySIYehGck8tbCxBJ+LXSrCzRS/BYUU8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793879831;
	b=6kG4j7tfvB7Gp7xxTAQ632jsdK5MRdpzcZchbSQuY2W0+Fx57PthdGN6iRN9iGMTcIbZmp
	NWy4q5ZGD+dR39PvAXiDgVtrz1MMMy1xsVZQXrfGiB1D8DHpaY+OhCYib5Gq0gI0ALKqkH
	CG5WsC+7wBFNhT1y8RlLUtnYx6Y31cc=
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-823b938464fso1260210a34.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 03:57:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793879830; x=1794484630;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Z2qCIfu1coqF5CKQo/xHkFXbKW7Y+rLlNCa31RZmxiE=;
        b=2IfWO7ZSiG5pVooJm1wOQ3PTlywI3gFpOxSkdQ6vfAKz3hyC/68VpKARKAg9Nzq9U+
         A4An8boc1Pp591ZRKDiyOvg6m218+kawANS/aD6EoPG9ZqAcwIEKn3E6A0pxj7DdquBG
         jPOYvq90tv+DiJA/j8U5d70N1jO73A5EE4LyN6gzq6Oqk4rKmB4WxSmJGxjcmq8N1Wz8
         FeYt/dcOzAw6taVDlfZo2+KP3ToEcUfFpIaQml6SxAIvqkytWMgTljsBZEbAbVDlO4V2
         c3W05/DFdSiLhNncJe0CHvaYDe2zKPxR/XJS4iJuyir+00YoyAC9sLymUDaGowYOw0jw
         oHEw==
X-Forwarded-Encrypted: i=1; AKwUvBwvup3w9ZkBeTRkMcLz+9RKDWS4+OXlj59jB78pqlceWavwHQfgCHnilPRmAR6+TfDLuiavlJFwfw==@kvack.org
X-Gm-Message-State: APuU4Z+MsvgqMjrtmnX2fD8+NqSka2yVZyBPWPnlvoHPsr/+oBBi4Gha
	w6gbi6SRLLW1bp6YwAgZ3LRt9br7ryWQKIslEnOXtbfwk88ss70PMiFHyt7BtQd4Swg=
X-Gm-Gg: AYBFou1ClGNMFwoMAROlH0ACH0OatxC+M6HUgGqYhKvxvSEOY12aPP3uEppwKd9+x4Y
	IsCSfP0iky8ZxhWKy+OwMz790Rmx8KQUl6VDfFT6qhHkS4Wt0lA1M9e8GxIoALpct4epbc9GVT0
	JTC8oOanj73nGhNLo80ITf7sGLhmN5VV0DZRp0GQaqCpFh9uIq1V5h2T1eR6PFYWp+SLQLZWbN2
	j1BKWMiJfcv6Ya/OKwKY3gMFedAOicmuL0DJWPKvWdk2QGTE+prxDXhWsZj2as3Py079x1qJfqW
	72yGrUeQZ94Zr/1qM7u9ho6PJVMOrn0+IDrr/KU51/hZ4A3t8TBquL48kvim1ryIrQxrkmZlrfF
	SoeMgJ9kQOW2PDEWjvFcXUOu4e43ZRC/ZFd6+Bviiv7JPPsIH08TYIofG465BPlCxl0FibJGlSR
	EZ0b8btwrGqsyGPQ1rCaft/n9KiQ56ueAwD1Sydt+dT6+BKcvVbxv4JKaAeptugGpgwK50o9uDV
	npqj5djEpeq8tXkPC3+uFdJDCVsu3E0MsHNDyBbPp6LtrjXRvYfQtPjzgUotsSg/01a3FRzFbIt
	8NjW/RgM+L6mo0YbWq1AX/0kUQR+1vc82Fo3P5THoBFFIXpdi9ymP+h8FVP4M6tIN3buv7JKY/T
	gi0GrF68cpR0=
X-Received: by 2002:a05:6102:689a:b0:7a8:15b9:dd34 with SMTP id ada2fe7eead31-7d07277c1dcmr9955088137.2.1793873317677;
        Thu, 05 Nov 2026 02:08:37 -0800 (PST)
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com. [209.85.222.44])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-998d9c906fcsm4194778241.11.2026.11.05.02.08.36
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 02:08:37 -0800 (PST)
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-998569550adso1053960241.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 02:08:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxs/MjTE7Ydj5ywo6yTz3mII9kCn52+Wmwu6kq3WzlmPZzaKLgo6Mi9tQrI2xBAfWqOGi/ePLxBQg==@kvack.org
X-Received: by 2002:a05:6102:5494:b0:7cb:bc5e:7d9f with SMTP id
 ada2fe7eead31-7d072bb3829mr8787869137.11.1793873316184; Thu, 05 Nov 2026
 02:08:36 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org> <20261104-work-procfs-core-v2-16-76ace653a773@kernel.org>
In-Reply-To: <20261104-work-procfs-core-v2-16-76ace653a773@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 11:08:25 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXAk9CwoXpak8+EQjdvJ2Ab9fo1bvj_D5GqBzXB7urEUQ@mail.gmail.com>
X-Gm-Features: AclHuK_D2R6ZzQFy7DOLUQHC3VotRoglnOuhbtIFU-Oniz4UMRG_6kQUnblEqeo
Message-ID: <CAMuHMdXAk9CwoXpak8+EQjdvJ2Ab9fo1bvj_D5GqBzXB7urEUQ@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 16/23] proc: let procfs copy out reads that
 don't go through seq_file
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, 
	samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: f46yi5g7u1behzufygcpyohfuk4s918z
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6A1E4160007
X-HE-Tag: 1793879831-149742
X-HE-Meta: U2FsdGVkX1/Q7mb860nSTxjk8++QYXoaVvv5AgrOooXiE0IzEcvA4XSUSxzvAsz6UtwyHJ3+o1q+Zga4o6YB6PfYYL/tRKQmab0GEWpzsZlQvPWzeTTywfjofw0ptQE8PaPXqcg0brGsDPRZ6vAVBsfxUrx23cEtAQ+tJVqAQC9gZ18kiPIcob2MyQo7Q2RcRxb8GD00bypCqpmlUWNxSJM1SJpXPxlJukD3S/RDgJ9VIxiJABYcTlKBqlob64NxHt7L1X6Mk1ZeB6lSq8397478Rg+D1/cD60hNa1IeSfvLeEbSPGHnBA6eoS/QS3SRT+v9F/+8xYw718gCEubRB9THo7sClLds2MWZLpr5WfK89LVeWpA7vXq2S8yWMjSP8PBzh0NDKMaaA5S9ns7yjlMZGA49eGJPrMj8ltup6BU4xi0Juyy/hYOx+1FUcjtp5KLPDeyPELttg5kY8UUqhXg0O8R0qDaWOFmy8z9OJvUs0c+QG5MSXUvgyIymUbAdV8haE+xWa37xC/LWX+qmwUEnLVufCFtYhqPaWSrwE6zr0rfQTqwJVrIufc6CHwNGPUC3gYAiPk0W/szEdaxvV0riGByuhIDnJzUxEG/yIq5jSvPugTJyBCpTs2hQgbqDnxOkd3TbG9GzioLlEefLTFt2mILXSvF8iZyrIliQY7/A0e193b5UxOkiNtIcO5yDBW9FqN2GGg/JUE9vVS6z7D4gP2rkMTRq5Zl3JYd55mnfWkpTKeQ545ebczLQcZF7Vfo7PCm24Tgy3E9Ytcj4Ra6kgYYXWjZHoLrOv3xyBrKWL1n5M1uQLQYzgijqWODuTpMtKin1/47YAy2s5Ybswd5wddQPilMN8Ycq2z8In4dX6w/BRhIGPqyjP7eq9FqIfxn/hWj/V4DQMv/P/a2Y1tkr+u33DbsKpTc3ikEgAeQQDQzfip6OhBew7oLV1sxqvWWPV0VAowmosZ1dkZ7
 51QYNXe6
 h7QkbFGFyTnzmkSeF3DKBTFeHIa/+yYDzCpxJYR2eKHshAZDt96Zyhfmsv66ZKqFYRyQazkm0zPfcul5gEvVL+Eg1yGIWIg6WaZUEl6JzZARw1R3G2pJx20Z4erq5peVhKK++Jgn1UAC6G+8BCWL+QvMwwAAXH4f+I1XoP/TBMjvVK8UzZ5Np59Y317ky1kmVpVABwtxNCs+MOAZJihxapxtfRhViBMBDwgqLyk/jEeaIAneWped6Wb0Ec9c4/+3bUYhwwZjMdI1dGYBirpQTnSvdxW9ExB2wV08BppnRiCj9Wl0i8jRquxfj9cEnW4E3IkBH33uJfjtgK7/RpplH8iwqKyIBfpivrw4Y8H6JNwrDGSUPoRa4VlqNrvjZg1pxsg3mkBSiqnK043DRrOEDR6sxC/b2aD0PJvKQRpy4SYdRAWVak0Gw1ofUBP4oJV9vHbz4W54OnzKaWQfEFFYVcpB9AYsKCnIFhSgRKDUgeUmc+8ce+jXb4Er/nzkxC6zn+FkuRKf8X4SiwRTQIjHfrQ7YECKRwAYqBYRG8MnglzIrs/Cc34s9stUFFuTzDh7q2BzkTsLA05FNj9jKONtYzYIjvE/Zoq5ErhSWpvTxkEuu3y4iuxZTIohUCHl3n+pxmTSc2S17vcOCxnncYdM0gb1QoP1ebnFRx5d468NlTL+d6ec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Christian,

On Wed, 4 Nov 2026 at 20:33, Christian Brauner <brauner@kernel.org> wrote:
> proc_reg_read() and proc_reg_read_iter() pin the entry and call
> ->proc_read() or ->proc_read_iter() which copy to userspace
> themselves. Like for seq_file reads and for writes, a reader can make
> a page fault in that copy take as long as it wants and
> remove_proc_entry() waits for it.
>
> So do what kernfs does for these reads as well. An entry that implements
> ->proc_read_buf() fills a kernel buffer of at most ->proc_read_size
> bytes, a page if the entry doesn't care, and procfs copies it to
> userspace after unpinning the entry. The entry moves the position like
> it did for ->proc_read() but that only sticks if the copy to userspace
> worked, like in kernfs_file_read_iter(). If the copy fails halfway the
> read fails with -EFAULT and the position stays, where
> simple_read_from_buffer() returned what it had copied until then.
> procfs remembers ->proc_read_size in the entry like ->proc_write_size.
>
> Larger reads come up short, like with kernfs. An entry whose readers
> want all of a large file in one read asks for PROC_ENTRY_FULL_READS and
> procfs fills the read in pieces of ->proc_read_size, unpinning the entry
> in between. A piece whose copy fails ends the read with what the pieces
> before it returned. kexec-tools treats any short read of /proc/vmcore
> as fatal for example (cf. [1]).
>
> These entries are read through ->read_iter() so readv(), splice(), aio,
> the RWF flags, kernel_read() and io_uring work for them like for the
> ->proc_read_iter() ones. io_uring's nonblocking attempt gets -EAGAIN
> though, like loop_rw_iter() gave it for ->proc_read() entries. Neither
> the allocation nor the entry can honor IOCB_NOWAIT, and io_uring would
> take a short read of a record file for an unfinished one and glue the
> next record to it. So it retries from a worker like before.
>
> An entry that implements ->proc_read_buf() and also declares a seq_file
> or one of the other read methods fails to register.
>
> No users yet.
>
> [1]: https://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git/tree/util_lib/elf_info.c
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Thanks for your patch!

> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h

> @@ -84,6 +91,15 @@ struct proc_ops {
>          */
>         ssize_t (*proc_write_buf)(struct file *, char *, size_t, loff_t *);
>         unsigned int proc_write_size;
> +       /*
> +        * procfs calls ->proc_read_buf() to fill a kernel buffer of at most
> +        * ->proc_read_size bytes, PAGE_SIZE if that's 0, and copies it to
> +        * userspace afterwards. Larger reads come up short unless the entry
> +        * asks for PROC_ENTRY_FULL_READS. The position the entry moves to only
> +        * sticks if the copy works.
> +        */
> +       ssize_t (*proc_read_buf)(struct file *, char *, size_t, loff_t *);

As for proc_write_buf, I think it would be good to use this conversion
as an opportunity to replace "char *" by "void *", which will probably
let you drop several casts from users.

> +       unsigned int proc_read_size;
>  } __randomize_layout;
>
>  /* definitions for hide_pid field */
>

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

