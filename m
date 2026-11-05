Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A71EE6082BF6
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C762E6B05B5; Thu,  5 Nov 2026 05:07:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C281D6B05B7; Thu,  5 Nov 2026 05:07:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B19A36B05B8; Thu,  5 Nov 2026 05:07:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C8D86B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:07:49 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1829716092C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:07:48 +0000 (UTC)
X-FDA: 85400639016.07.E4461FC
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 28F01180004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:07:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.45 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793873266;
	b=Ee1758v1ZYIuMsffaOuWg9rAjXvyzRwTAmD4ZaHRGFYS1vSktcHd4etUKKL+3iGZPUKxcM
	tchtqXqtnvYVZiCBMazdvMrKWneiY0epdIG/iR20qx+mBlryJ1lxz6xf84kmBtDDLxCYdF
	7900v87KdxpOiRrd4sZKH8bqFSgWLjY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.45 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793873266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HRfPjQi/EPajP85bp44Mrjs4W2fVG4O74jaEjdHYdtc=;
	b=eafxA7gZKrOVXp7qCQUjoVRdDnY7rRA7DjGKVSsQpAr+4tCoQzNEiwv7bYk6z3HZro5w9X
	GCRA5CV+kf3ZpRJGBSxixEdX0rqjNL12xEFbp/tao2a43gGzWxrkDl2P9DlTYSW1m3p9oS
	bGSjraC4fhLPZBmqnk7GNpg2CZdGQNU=
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-9851592ada1so458659241.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 02:07:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793873265; x=1794478065;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HRfPjQi/EPajP85bp44Mrjs4W2fVG4O74jaEjdHYdtc=;
        b=r5tDiaba9votBvCpF8SehZwYbJMvS0vw6uHHD6MvIeyneLuz9+mgQMb+Ldw/40EyxN
         Oq5f8wx4obk8B9xRrXHwkvTAPr0ZrJlP7SNJRr0S9ZXrJocDmsNSGmeGE5KMyNuGbH3t
         OOatiCs8R+5niUp5xLPq/PdnNRQbwW31SITfaYhcA1VHWpLgng6xl92erl+OEIAUfKmF
         q6tshB4nje53NpHAWE1IdA83Uuju+haAeFQnS6A0DDKPKWIYTL7CGjAh89tAUxMYwJVr
         j5EbaGVbynomHGWPwwJHhuCtJ7WMftkX3ZQcVGLUJpGjosOBt2lpotpKUW1YGGcTk4ZB
         fSRw==
X-Forwarded-Encrypted: i=1; AKwUvByrt4elNnR3Gr7hIGBsG4VJpU/cDMwUor3UuVI1iCBXez0mpQB627xw6/DX/5YAucMTWZx9OZkZNA==@kvack.org
X-Gm-Message-State: APuU4Z/pYXHZaYKnKuoJfv9dbbbaY0chEeBNMuymwwYjXnMnt32Yt6M7
	eTbNeQjkAfL+TVVEzv+SV9SLXxV4RHKY2IQH2G+Qq465vzWveahN74p5cZQQiRuZsRA=
X-Gm-Gg: AYBFou32ELJrw9opRTIn+P0/Py5JECHYsDLdpsUywJuUQMBmU7etVmSwQxFGndQrzxw
	PNgDxfOJQJr/FFicIDNJjdzS7DFO46gaG8jrOXj2H7v23NJtG/35ztcr0Ewfsz1PWPmev27+Rq/
	h6G/YIMmoorgtrFlcGEdI3PeB4BRwkgb6VeJySBKVVYFk9DjWx6Q1y0mGm0Tc+2YJrJzDYSu96W
	PvDBYjFA70K1InT1txuF2dOps7lfY4SSf44jDr+DR8rh2nOb/VhvtK1PnOV+W1k4l95zqfDjh4n
	8B50Pmy28T44Y5bSTyxz+bOAERwIDXpvjDEAxOzkbqjTzH+RjlriDVCslKg9z3x2fR0djtYc2WD
	vJhmCUQSe0kOH4JhKIUl8JiFJbgfyDUhpCwj4st3KZoUvOeavB19zZTYfsZjXf5MEzC55avq+Nm
	clvE6MiideTq38eomkn4JuDqSsVDN3rv4SODjSAwGEZr8d6sySoRzZUupqf3nlwO/2NQPdiDaoY
	d6MxwalHVmvfp3bdpSXxoxUf0V9MULL/om/9mRsSzhxSyvzMXyNszyZY8zUtBod7/ffUzljLlJr
	Si9pptqZRSUYcthyfJb0aLFewUvnsEtpE+ZEEyW2xh+3LceNujM25w0UL/EfqF8d1g==
X-Received: by 2002:a05:6102:14a3:b0:7be:37d8:1567 with SMTP id ada2fe7eead31-7d0725cefa6mr8059061137.10.1793873265194;
        Thu, 05 Nov 2026 02:07:45 -0800 (PST)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com. [209.85.222.51])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eca89b6568sm3973281e0c.1.2026.11.05.02.07.43
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 02:07:43 -0800 (PST)
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-9906034086cso432340241.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 02:07:43 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzZJePB2DJAjnkbap3CcAiRLfAGjFxbZ8l/6aEWnlvD2Jt6DXDJBR2qW/Tm8QVxUqrypscHmMBM7Q==@kvack.org
X-Received: by 2002:a05:6102:374c:b0:7cc:1a41:20e8 with SMTP id
 ada2fe7eead31-7d07227a940mr8060714137.5.1793873263361; Thu, 05 Nov 2026
 02:07:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org> <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
In-Reply-To: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 11:07:32 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
X-Gm-Features: AclHuK9naqg5CZQ7lhJVrMhg9TNH44f-SpA5WbUGCGBsAlcoOw2midTd7doJSmk
Message-ID: <CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
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
X-Stat-Signature: zccqg7pjcnmg6jjumi9zgfa3kbgsb98p
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 28F01180004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793873266-149317
X-HE-Meta: U2FsdGVkX18UQzKzj4izoUaVOhOYjm9LoxFYQcySiynjhIaoJKtB3plLmnV8Hwi9BEVzZjaSHpk5JvwHi8G08sO8KdZibwdBsNS3FxAKIDIB28OxVxdrBJHFDcfAOlgOnNtpZ9eo0Kqx5do/ftZUbP8+TuEchlt97FE7e7LX6H42IU+CCqYejWMnbrOaR+eyZ3BG1A79QeOuJYmoVAL4/pkgF4JYJvpMh2JvStsLvGKCeIEQvNiMZzSs4hdlHi87GGW5JfLmX9HLyB3kOX7cbF98uz9hUBGDcAHdDRANrU12o7UOYeeeGbD8LEPOmN3BSm5b614KqO7AjHnr3DoTCVt/jGkbjcD2P3ibly6nfotBSiajfdcl0WZKT8BA1aDsm7Gvnz4gkbTxzDwYOqquRjAGk/zrS0vWXB2bq++/KzW5vf+8c4MBSMHplifSg0TiW1wTKgvc2GcNvGN4vIL2XTvFyx1Hr0+xKxOeaC69mYmxda/C9hcj0IwqW2rdOgxPCzJQH9UYB2MYNJuBAs0aJ9gcRBT2S1FnDVn+x05Mk50pTNSHw0EM/3QVuKe5nXrOH3X5rne6zo3b72dVz1vlDQT103K5TSiWLNU8tVtxu9EDVOa92At2nsthEKJGNP1f0FHFUDS5/Q19TlWChvBd+o+9HVaJ/D7oMsNkgvRgc8hankCSEVeqs1MGeLJEUb3kw5Lhj1M3i2hN6BqIS1LW+thXy9n1Vz04HEZn2eMsGWHO1NVgKt04+9/XLXCR9fekC8RyQaXbYkh6VP5nwnVfFv1PwyVKDmXNcuMRYYpFM01DJlIKjMjhTVIX+GNsCRf2Hb7vRo4Y1cfvAnjvTvDBiDZwUjgJwTeSXhTA2lmMyGBIiqRSJDjJeqFJ6Cc6OVrm/33Q0DqheecRolMAgmXSWwsbht+aY/nd5FHWwbduKYX/Vl12P1cbgvzJvIkKTrC6H/lbd3g3GqjDO88Rpy2
 OyRjpZwo
 RASBPYodv4s7d48GFODbuyPT4jsgj38SPGPjXxKWCDHRH715/lepXcp3ntekJ7/cw1Okge2PnQD56zcb3WA3VMMyJJBrfLzCKa8RhRm84W5x4LwGVrDgSQxG+hWz3E4mSTT8OC8EZ6Ko/BmVIowHWGGkqA8V0VsF//2QYhrTHavza/kJnkEerz9JhMVrcKTcNDIk00ncUXY7LL3zKB6tKmLlsU9lT1Kyc/FueWU60X/+PJMpFBwiMC+4Ivf4BYmSVU10CIlIIYsIeuooQN51H5MsQZQzGtz2gSHuVgGOY1Ll1PlLIEcp/uBOoitAhbybsBrfbqEUAovrqj928oN9mYdENaTlcFb0yA0fsl3sSF6HfqAc6EWemySj1XZ2FVpZNVc1HyzHpZuVuH5VwSSVaE6xMaJdX/BvuNBvwFtkjsD5PQcHs2wPzJO+sW57784gHe/bRprSEIDxitue2k+nKGyQ0yA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Christian,

On Wed, 4 Nov 2026 at 20:32, Christian Brauner <brauner@kernel.org> wrote:
> proc_reg_write() pins the entry and calls ->proc_write() which copies
> from userspace itself. A page fault in that copy can take as long as
> the writer wants, just like the copy to userspace of a read, and
> remove_proc_entry() waits for it.
>
> So do what kernfs does for writes as well. An entry that implements
> ->proc_write_buf() gets a NUL-terminated kernel copy of what was
> written. procfs makes that copy before it pins the entry. The copy is
> capped at ->proc_write_size bytes, or at PAGE_SIZE - 1 like
> proc_simple_write() if the entry doesn't care. Larger writes fail with
> -EINVAL. The proc_ops go away with the entry, so procfs remembers the
> limit in the entry when it is registered, like the size of the seq_file
> state, instead of pinning the entry just to look up a number.
>
> Entries that take binary data in pieces, like the PCI config space,
> ALSA's data entries or a firmware image, can ask for
> PROC_ENTRY_SHORT_WRITES instead. procfs then copies in the first
> ->proc_write_size bytes and the write comes up short.
>
> ->proc_write_buf() gets the position like ->proc_write() so entries
> that write at an offset keep working.
>
> Note that procfs copies in the whole write before the entry looks at any
> of it. So a write that is too large or whose buffer can't be read fails
> before the entry's own checks run, permission checks included, even
> where the entry only ever looked at the first few bytes.
>
> An entry that implements ->proc_write_buf() and still has a
> ->proc_write() fails to register.
>
> No users yet.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Thanks for your patch!

> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -67,6 +74,16 @@ struct proc_ops {
>         const struct seq_operations *proc_seq_ops;
>         int     (*proc_show)(struct seq_file *, void *);
>         unsigned int proc_state_size;
> +       /*
> +        * procfs copies what is written into a kernel buffer and calls
> +        * ->proc_write_buf() with it. The buffer is NUL-terminated and holds
> +        * at most ->proc_write_size bytes, PAGE_SIZE - 1 if that's 0. Larger
> +        * writes fail with -EINVAL unless the entry asks for
> +        * PROC_ENTRY_SHORT_WRITES. The position is NULL for a stream, like
> +        * for ->write().
> +        */
> +       ssize_t (*proc_write_buf)(struct file *, char *, size_t, loff_t *);

"const char *"?

Seems like you have to drop several const attributes during the
conversion from "const char __user *buf" to "char *buf".

While at it, I think it would be good to use this conversion as an
opportunity to replace "char *" by "void *", which will probably let
you drop several casts from users.

> +       unsigned int proc_write_size;
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

