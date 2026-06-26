Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D449CC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D576B00C4; Fri, 26 Jun 2026 11:18:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944B46B00C6; Fri, 26 Jun 2026 11:18:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85C9D6B00C7; Fri, 26 Jun 2026 11:18:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F6A86B00C4
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:18:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA08BC22E1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:18:45 +0000 (UTC)
X-FDA: 84922421010.09.F2022ED
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id EFBF21A000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:18:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eI3da69X;
	spf=pass (imf19.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782487123;
	b=ydiCGSMYRQQ9DO4PVX4tGPbJ1IMc0PMaFB+XCHKYEDh0kX4JdT8sC+wtnb2K85WqsCnbY3
	7POcFeyQzfUzEPVtwLJSS3VjlPa+wjFJ9kRuYjxznnng8oyErdOuzjnD1qIOITtYnHhu3X
	TjZJVYPwOwDw9W0ccgpgyt96QQmoHeM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782487123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mVP2TUHCeB/LjDfIFLuoRmoPYS8ySiFWCJ8p8DKBKuk=;
	b=YMlxXVOuyY+j3HRWVbwmxT2t2KquPfjVgRrsi3WEUuBtiJ/OBguYud6OW8xw9IEW0r89BB
	nXHmAimxDksH0/MLjvFnJbjhgsDKZXNco9wQr+PWcOJFlEMvdVYan79rKgMh0JoJsJ7oFe
	ObPacwB9VgNn8qGyiMdlwZ/eOaScAMQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eI3da69X;
	spf=pass (imf19.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6977dc206afso2426581a12.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:18:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782487122; cv=none;
        d=google.com; s=arc-20260327;
        b=F9bUDNIOhYIirzjqFJmEdct4q8rGdka2HNWas595/5FrhAOt7k/eMw9rhjt3ivP83G
         i+SSJmpn6UQ1ElMbOPvAKge4umhwg6VE6TVpqMChEr0XBZYGlibfu47eHtx/mj3eeNOf
         vGKRPivPCXyUn/yVBMpacMj+j4LZOsPkQd3W2LF3mfxup8K75ABt77pySiICmpIjZj9k
         UstAmbMex9LIQOUtaHIsoEbVZaVFI6LATCdjR6WUW3d5QdeOVxMAjuCagYDlYbNXGsyo
         qlhN9dGU2PmJVP75awU+zrmYRVyC1FMuHn9wn99CMDVk46SsUPNqyakKf2jgI1kyOL+h
         GyyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mVP2TUHCeB/LjDfIFLuoRmoPYS8ySiFWCJ8p8DKBKuk=;
        fh=yZwZaztIpviDgJ1eWSFIcZroFWxSwTQtFSvNpksVGYs=;
        b=IdUO8KymBRsZGyPp1jIkyywwpexf8Mf/HyEjnHgfXaj9hXP1LG2YzUb6tZB4WWnjzF
         cCsXCdqI4a4rcngkHTHtCfZLia95T8GvbkJznEzHlYU9bfX45vzlqI88M1fJNYk4g9ze
         CQbRCNiirh6aYu7+KkCOwCJfbPuQZteEo1XUVDytX1IjcjrYkzleVfi59yj7Uum1DHaI
         QEvZf2/Zz2hFn57ttPzwtwK8BVk9eMaU1Cu2GKuyGUALmUU6O6N9v5InHvY6QDP+rsfK
         ECaUOM3SkSsOn6zGr2SEjUpF4QFvHM1EUaqGUw2P5KibJEPiWkCtt4MvUo4MvCPoFyyR
         bppg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782487122; x=1783091922; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mVP2TUHCeB/LjDfIFLuoRmoPYS8ySiFWCJ8p8DKBKuk=;
        b=eI3da69XzHhT1nM8I65BvaYKCpy6wCcvvpMukeGkz75oAUOsfT7px7Cw3jQGmWyhuN
         Adsoo83DhwCUF4Ymvuu3jAgWo+fmN+1hgBo3xgF2/Slv5tIBZ+mWO62jedPo5sEAAngc
         7CJXhZOorcGLfX9E2mTuCDvTHDm9ohsFBPY5JFYeGNMB6JSP4PP+U+04sLIGJP5cjCmK
         C8KyW4Jk7TBINZnJhtJQ/UsLGAfggRENX7fMDP3PAL08NRobaDN8RmPTUDgr6FSiv6pn
         61s5XdXxRdQVzczDi28Q3xBCZG0HZ94i3iIJPYsyaSZOVI+O0EmBM/SxdFKBVjblct7V
         lSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782487122; x=1783091922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mVP2TUHCeB/LjDfIFLuoRmoPYS8ySiFWCJ8p8DKBKuk=;
        b=MiY5cHQUVSXy/sINto3VVzg2rCCwzlfYDqsfRhIPRwbEMY4GipoQ8lonkZB2YGTXwO
         Ha7sRTlG6ixjbygBnWZxpPBmjrhEA5j+l07Tw8ctF/HUYiJAmEihAjmIbwcwuvvquMUJ
         dzbkF41V3oJ03lUViv2EKClEsf5TAYgx7+xCfjj1Zhh0i5GtqboMgLpGUKUjxTJTVlsl
         n4aUk+FmfC7cCUCv+iDgISo/KPyLdamJT9cUKO7ckAnu08nzp9LIsiM11wc+HR7xQNAm
         YGfU5TpYPbT1J1LIhR0VUN10Hfni2xS8Ngfju/C24fu/ZytvT33vtjUdTEUyFSqbPy/E
         dhSQ==
X-Forwarded-Encrypted: i=1; AHgh+RqMOlhGSnSuvUmWv2XDoW6Z/lKzJlb9ZVfSjWi5CobhKE3/MtZS+ZAvhshieC+a9ifQkL8dBtrxmg==@kvack.org
X-Gm-Message-State: AOJu0YyM0L6lJL8pJHPJ/Z05dh5CfM/XAYDd4/wwQ38X5x8OhiFwKfYu
	DWc1UqCQs7Rc+ZxZ2MVyCWvKVgDhoh6Iwy0r7Y+QGul5xRe8p0sl7VmuX5MXJwFuTQZI0QATDvg
	PrYWgYb5NlJo77B7quxrFuCu+SdQSG3E=
X-Gm-Gg: AfdE7clzDbSmlelQD0Msv9KZhuIlgW9swYp6z8N/gTSA6JqAdmIktUCY5KQFyufftIe
	DKQ1Y20kDl9wulFR2Xw4j2WQCHMDqiIy1pcelcQ2TINbkBT4gmRhD+8uOItcyCCp3DBATOFxyat
	KkeHzZI3Nx/mCAxJtbuciX7FVULIqbprlGfKcNMIga4YpRrhBGdadewUq+ERTDHf1l1beF6xK4Q
	naoMGtZ4uqZkLqpUP6OvSb4729ff1tbJs0N12OLY2Rh96mBmpKF5moN6WhGK8e66VKhPfR/8F4p
	iuLXKJ2af3+a75TbM+9KXPciN0KEK0k=
X-Received: by 2002:a05:6402:2551:b0:697:833b:845e with SMTP id
 4fb4d7f45d1cf-69810aefba7mr2419788a12.18.1782487122292; Fri, 26 Jun 2026
 08:18:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-2-ptikhomirov@virtuozzo.com> <ajqOyIA8tPQsxfz6@cmpxchg.org>
 <3f6392aa-c1f6-4263-8892-978dacbbd8ca@virtuozzo.com> <CAOQ4uxhras5YAr8_HBpuHSDwvfiEF8vAr0NDB0R_PXtGDhnqjQ@mail.gmail.com>
 <20260625-lehrbuch-gehalt-wichen-1b2f3533efbe@brauner>
In-Reply-To: <20260625-lehrbuch-gehalt-wichen-1b2f3533efbe@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 26 Jun 2026 17:18:30 +0200
X-Gm-Features: AVVi8Cc5EZwXlZ5GECvSYG7NzrqtiA5br21iMjGhuCiWGLWSPhjsckXvxs-eoOw
Message-ID: <CAOQ4uxiNrEZ8rsRc11mdjkMWe3dfThE0DJ2vXuO0yiNemnpR6A@mail.gmail.com>
Subject: Re: [PATCH 1/3] fs, mm: add ->cachestat() file operation
To: Christian Brauner <brauner@kernel.org>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4opxgwzyoid6z77i1dn33ud6f7aqu9b9
X-Rspam-User: 
X-Rspamd-Queue-Id: EFBF21A000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1782487123-177001
X-HE-Meta: U2FsdGVkX1+KRkrKmodN4DcWYeA5fArDoI98XwGigV9GI+GoIHKgRYOxaD43Dvj4rSnvySZFWrhMU8Gx5dYReAavGUJYc6GaAkOQ0jSw2PDAAFMgx/AG2sYFdqDlthxS1qmIPasmjWUxrVImtl4IYKW4H9GQrmtTgInznsiB3MxEkIgZ8b2u6t8ehjGPaOSscPA+BTwW2k/gvwSS3159SFBowVc2DiV6i4lT15udAycJDe3MvTs80EUkUDeJV05U+Ul7UapTvg85M/IllUAphkXynidYqgcvP5N7NvyEVUr3LYxCi+uNuJ7HO1Kpn9m3g8p5WE1Yyca75QTO7b79OcJcfmzFJ7RtdTKkzSCzdQ+MVlcKovn7286Z2D+ggwiTXm0mH57kbk45/TpfvaqjIyO6CvMwFUpBVaGgGFTj8eJ0+IL+27Z24jzKVhM+30059czNrknvXizygd2voE/Jb+KFD/FFMYx8I1ktxBt96hQCQQln2yQtwHGq3pXcsUYHw09q/94jpOIQfkrfXARFX7oxru7Ic3TyQ6jLHu26PNP4Tkca7UK9vmAHMfrDnMHkF83nmh2I6A36bz0NdKWb953sDSwP494pZN3T8A/mpB8pM9MzhBnpfr2eR7IPzv7HW9QboMYv+hMT67dAxht2jkpbaU9h/nR/DguTZwE04loLKf3VX4vdpyaqd1YCj0x6c7ouJ15iLAep1++u6zpizpwm9hYKynXbFBnzqP+uprQmGw9VQN1OhoeOJcqrXCXQ002Vjb4nnVGoICjgXDRSM8yXsP+15W6AfgZstp9vb+UnMbiWBx9EA/xj7gSOvP266uOlftPhg10XybTYdY04Y3K6pAb6Ejq0hBonK8vEFGNcaXm0gEDuQRC8hCnT12ZhvoH6TPWb3ZYET3lay2FPYt3n1qR4z6sezOLqD/3nf8ofETVpSt2gwVwcetCQhAAj4V5Z+grAUN8xXr+KRPy
 PU16M7Cp
 B7uqXkQtv63GxfFHl8BADNvDgYQb+0O0bKPU/2vSJ88vhEsjNjzOxbdCx6hCV+Et/BqVhI+6EdUfLSrnqjUbLfI6KueUkDP7MQGaGIxaJSHZ94/bbDRdhj9RyyfL1Tyrx1KRKDXTiwAlTHXIwnY0XdnJD/aT6HBm7IOaFITttgukyo8ElP6Beuwg9G/eNsk18ldAmYk/inudZ26cHPm0xLpgVnZgStHhXTLm3hyk95CHR+veO1dRZdkF0+ToftlDQr83GVjCoVN2qvpSLF3H96ujBVO8h+EyKdwm5uo7D5KyCcvOooCillx9Baz13XCGX9/+1VfektnmCgBGth0JMiSk+l3ufrZbfWplyLza5z1aOaFewfUe+ivrW8IOCV8oOXjLTccmvuWcpTS7e/MfgMX8tn0RPMwqSum+eQslwLISqL/pzanO8EXRawa+VxI/ERzbJ5rSIyrWa356AmQMMtn2rxeg3cyfsvLh4JYJumoHkX+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 12:36=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
>
> On 2026-06-23 17:34:47+02:00, Amir Goldstein wrote:
> > On Tue, Jun 23, 2026 at 4:55=E2=80=AFPM Pavel Tikhomirov
> > <ptikhomirov@virtuozzo.com> wrote:
> >
> > > On 6/23/26 15:48, Johannes Weiner wrote:
> > >
> > > Yes, AFAIU in overlay when we use realfile we should always use it
> > > with_ovl_creds(), even though I don't think there is anything cred re=
lated
> > > in filemap_cachestat(), I still think we should follow the common pat=
tern
> > > other overlay helpers use (similar to ovl_fadvise() and ovl_flush()).
> > >
> > > note: Actually some places get ovl_real_file() and use it without
> > > with_ovl_creds(), e.g.: ovl_read_iter, ovl_write_iter, ovl_splice_rea=
d,
> > > ovl_splice_write. But those look more of an exception than the genera=
l
> > > rule. All other instances use with_ovl_creds().
> >
> > Use with_ovl_creds() is a good practice to keep the mental security mod=
el,
> > but it is useless if the security check (can_do_cachestat) is not in th=
e
> > vfs helper (vfs_cachestat), so please move it there.
> >
> > Also it kind of makes more sense to check (flags !=3D 0) in sys_cachest=
ats
> > before checking permissions.
> >
> > > Also there are simingly no other file_operations which return "realfi=
le"
> > > for further processing, mostly the operation from fsops simply replac=
es
> > > general operation with its own logic completely.
> > >
> > > Thanks for your review!
> > >
> > > ps: Hope overlay maintainers will correctly if I'm getting this wrong=
.
> >
> > I don't think this is wrong per-se, except for can_do_cachestat().
> >
> > Just be aware that the real file could change from one cachestat
> > call to the next (i.e. due to copy up).
>
> I'm really grump about adding a new file operation just for a
> special-sauce system call which is under a CONFIG_* option even. We're
> not going to set the precedent of piling on custom file operations for a
> single filesystem everytime someone adds a new system call unless
> absolutely necessary.

I had a similar reaction.

> This looks like it could just use a new helper in
> fs/backing_file.c that the cachestat thing can call to use the correct
> file.
>

I was considering suggesting this as well.
Having f_real_file() complement

but technically, can_do_cachestat() should be checked against
the overlayfs file/inode AND also against the real file/inode with
ovl_creds.

I'd love to be able to provide a backing_file "template" for
operations, but I don't have a good idea how to do that.
Do you?

Thanks,
Amir.

