Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D6F2C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373156B00C5; Tue, 30 Jun 2026 06:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324366B00C7; Tue, 30 Jun 2026 06:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 214F46B00C8; Tue, 30 Jun 2026 06:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCBA06B00C5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:56:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 678D78DE60
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:56:16 +0000 (UTC)
X-FDA: 84936274752.19.C72CDD6
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5079E20002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:56:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gyrZt5Zz;
	spf=pass (imf13.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782816974;
	b=Dl/gDWcRCOJCg/fWbVCSw3MdyL6mTUasHEJ8TrefFmXEup85pqvt9XEAHgxmH0hCnYomA4
	1V4N4zr6qPEwPjwxNHpJeB2mfSPLYoCBQveTcIuplG1Qa1ctqRN7KviD8fW4xdUdnNYWG2
	4p0VKcKx2pZxksnqeOCbbagdhlDZcEQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p0A4syWLh4jWZqK6Nlb5P1GnOuC5t+TuDmqTBq/uuSo=;
	b=E1EqpohqNoz9+veTHCTqoPKg20AJDQ4Jl2RLXUKq1jfWfF3/+VbkTjjZ2zAZGpMtT9nL3/
	aonARrAV3WGrRM/X2c8BA8DomzlKpmN4FLF7FyspPbBMcyKoG0AUDQQHyvizdPcdh47mum
	RKi5OC5uZ5yQV+RwKIHyobJLWgCq6Z4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gyrZt5Zz;
	spf=pass (imf13.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-697ebe536b6so6975133a12.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:56:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782816973; cv=none;
        d=google.com; s=arc-20260327;
        b=LNO0FDoUpUpI+aIVA316nqkGBJojp45DcvPd5vQiSnUteULfVkddgWMy363Qi6fKLz
         MMnPqXd+ciMxFeAbj8T6PfoNiYrmLzTRVeWy7S4rAmgCoznAebKqraG3/SaRKCRaIHwA
         Qri79PIUfYQCY2ITEuxemvUCn8eMD4pGZ9CeZyk9noGo8n1dAqQyow8lSIR1KqjNzz1s
         IiGCqPlZKQWam7krluLCVm1y7+iKaXpcsaWWARkvc7cwjAjUjVPeUT3sHB0YtMwSOkZR
         jNrgc8g4QoittRB7gaG3CwqQJ/zIlIw83fLLDNZ5+PvDtrMqDPtiYa09bewW6NS/KNhG
         S3sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p0A4syWLh4jWZqK6Nlb5P1GnOuC5t+TuDmqTBq/uuSo=;
        fh=gP2QEHP9aE42gGLmW7GmGInrvPIh2sQb3nk06jbu2XM=;
        b=B55vz46FKAyANcy84hVgmSWbXy/X7Wq1DjnRshL7FYxa/wIGqtKcz9AtIojw+Cyvmj
         JnuRhJxjqqFR+Aka5+Om/1c7t1OKT/xw0PmlozBg1LjfWfLQ78I17IkIftXVXtV+y0af
         gJ8Ce+uIINHVQ50ANJBekUq0E7vTT7JLu/8Qq794NW+5YCvLQKq+PQmrt7ErOvQwDfa9
         085liBCYWl1ysWvHZ8eCMjhUgaDVltKtslinVRBG4JFdVxb3OxbOlswi8cqfikgGZBQC
         JGtF4oNab2tENiPIf+mFN3NYZaPo7kTQuTu8bSl4nlKTIvgTMRHQlnTYTg/zbDTijIeM
         AOug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782816973; x=1783421773; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p0A4syWLh4jWZqK6Nlb5P1GnOuC5t+TuDmqTBq/uuSo=;
        b=gyrZt5ZzkK5kxCd3vrgNW5iaHfr9NNRfGX3lDn8Fs0gXvIJc1ZQM9Oa/bhztd+3bni
         rdcIiOKsPlxB8YPQz87UdDhRAkSHecgvCrSNmGyJrklfhFfYZtvsZaYXKESb5a4M9NoZ
         GLw/UW+cUOWvsl2tRFcItXy9viVoY9FqrxGgxuW5kUrneV5UskPxLreycrnHhhNHAOfA
         Ud+e2bHmwuDOjLGSFuIX4PJymjvfKS4YmZ2Krmp4MBRCm2HNnz7NbwUHBQOZ2HaZ/45i
         ig///vhk9iytIEq68EiY9c6J8QuunG37Mtez5j/OwosrOoBm9SVbvgKa5gozBDUv9Q82
         KiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782816973; x=1783421773;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p0A4syWLh4jWZqK6Nlb5P1GnOuC5t+TuDmqTBq/uuSo=;
        b=bbVNPjN4v9BYrLZfix8txfvumTkso5Hqe7mL7AOuKgNgvuZNpz8epnlM4aBZCCv1V/
         O6tpB15uWlTrGTLenChE6iw/xg4AiJpq8RXDhPyoKCKytevknxW+zeXZQ6eT8S5gdXnS
         ElOmO8Go4ddcpQIonmSr6yUOPyDEmpuZHm+6cRAHT2hex2NKYkzBmcmaq7mh18WbgyJI
         Oyu7XX2YHf6Eo8o1jDNV5F0ewi4QTfL5Opc+eKL7vbF1TeS1FFY7UyIGkI7tpOfC0YDU
         rwnWPke9veAsdf5OfUeJSze+15mkwV+BPvaCvpVGE2bilIRpEs6bbRHzZwGB4oSf/9de
         xh9A==
X-Forwarded-Encrypted: i=1; AHgh+RqChQDPVselP/PAPARDYizlCp49kOAcKjbPx1Gjqn94/JVyYx6U7A57Svzd6cezX3+l+JAjrJ8r+w==@kvack.org
X-Gm-Message-State: AOJu0YylvyNdyCQ7CuIVzp1/WERgUWrMrdhNBUydY9b8c1R63MtH5pCD
	DPbPtbHci/JKsoeZasYQuDUhw9kubWGvKYs3van1AIyciJyND0CLDXVMoUlpOlMmA35HfOLtnGh
	mz5lGV7ndosTfprkaVyfLxEq5Rnfytcc=
X-Gm-Gg: AfdE7cmAsyidJumyJW048esN1eOy3fvmMsMR6dqmeTLydmxNBE+PMR44Vifr+xMgQqA
	gSef1f3je57EMqDxXifYlmMi/uYV8VPK3y0M1M9Kr4Z+efmZ3+xngzZOmBl1UQpl1Dl5PmosSWD
	W2ItICZIDezgJ2n5dMhqfVUBj5+gPkDT/4nuLjMrKLOEH5KPNSufGgtEKV3b09FRF6S31dzXWjZ
	/BhVecHYOwJREKip9Gr6/USt6iu4tmRDB0kU3Hdh1CKzxZ3aoUfQDALOxa4a8wV8BZHM74VpqBB
	9zHdRY+bsbocTn2QRS/7PohgH8enNaE=
X-Received: by 2002:a05:6402:5487:b0:698:bbe:9c8 with SMTP id
 4fb4d7f45d1cf-69879de69bamr1227728a12.15.1782816972468; Tue, 30 Jun 2026
 03:56:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-2-ptikhomirov@virtuozzo.com> <ajqOyIA8tPQsxfz6@cmpxchg.org>
 <3f6392aa-c1f6-4263-8892-978dacbbd8ca@virtuozzo.com> <CAOQ4uxhras5YAr8_HBpuHSDwvfiEF8vAr0NDB0R_PXtGDhnqjQ@mail.gmail.com>
 <20260625-lehrbuch-gehalt-wichen-1b2f3533efbe@brauner> <CAOQ4uxiNrEZ8rsRc11mdjkMWe3dfThE0DJ2vXuO0yiNemnpR6A@mail.gmail.com>
 <20260630-tierisch-ehrbaren-errichten-bed402a0a26c@brauner>
In-Reply-To: <20260630-tierisch-ehrbaren-errichten-bed402a0a26c@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 30 Jun 2026 12:56:00 +0200
X-Gm-Features: AVVi8Cce_xT1IqdadZbbNXWS9V0ahfJfi6147JUNn_XGlol1jGtfRLAq44glwps
Message-ID: <CAOQ4uxhN_K23C359OLpF9mTe8-90qBvKS+dTwf5+WVvxr-0Jsw@mail.gmail.com>
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
X-Stat-Signature: 3cnw43atji1ta65x5etb1w4shciaeyy4
X-Rspam-User: 
X-Rspamd-Queue-Id: 5079E20002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782816974-89541
X-HE-Meta: U2FsdGVkX1+MMS/wIeU2RU+h47pdTwS6fEj3tDAt862rBf7C0zIdgWLBwHjW2BNeZqumsRVgDA59XF+8LJJsL7tIxsiFGh1dupyNa/viEg491xD6duRkfmFvPqLxye1xHGpSaUoePxfN295NUIoAxt2fseZWHPLXx1FNHzGoBVBA3nm/tjMHAX+eEY/IZZ7rBcHw4VSW8YovSC6oplPcP49GOkVIJ/DFygqBn9bmOxFkNuUr/XHfqQ/k58YVZt2mHsi1zYcRF2Qa5fS9LYh90QNFatV+7Xpa5lKa4PuCOhe0EbcbxxrqWjKrek+7n28leim0OGQRrQT9w0Ikmade1SzWRZulQkQA62UZmyI9ycpXRAUm7gbvs3i2KB62ZVUI738WTLB+vdedgOfTlZyIRJ20wOAzBRbo3by2KeJdqjOyc45dH6frH4hxfRthwh41f+TU3A25vkqnGkRph9Qhim1CevNm1w/D5ShIX4M1RyfsQmt50uB9BHleYgxd5ySY+5XQu+QnI/sTlSqvnGtF5ABVgPUlT2MsW8PGe0Pu08Uxihz5ExMXqVAWIDKFuGmc/lG3kB0ntsmdAyz7rqMMfTYl1L6PB1YCh48Wm2VSHfaBb8puNr+WsG0DN7ggQJXEybuK+CwSC+PPcK05xS8aOd2cKGChRkGu8ew1k9Ywvs2uoEtTkCi9VmncIYfhx+FKzmwojTzQtoNe9qaQH4bZcdQg+r3zuWeYhaeQCKUQnOZkJycLi9odKMt5uYY0w3fdVmjdkHnJEVeCED/ozsP6zHnVREJQVGUk8Uky4OpDKFVngaQzBCc/O7mnKrZjbtbol3xNwA7tjeSMyUMb4rSTwR3G5HS1JbMlmY6OQwT/zwI5i+Tfz4Xxmp+iGKHOiDFqOI4cWehe7gpVxCtxKKVl20sgjW/MT55fxdJF4B60NL/qMcBze/+lEWd/fDiMyEbltx/eZo8MNUvffW2ckVb
 bPNpo+bX
 U44GwnO4JbRxENvMhOlWZXkm4dOYDGsniu35bBuen2TXh76XBb8PMZZi29QXffn4HUYhDM5f9IZorhfgHFDGuMJvDebAMJuqvVsB6lOzB4KntqFbKZvH2ZftV0mZQNVrgd6QlOxERWtMfm/ZspkFw1Qqu1CybntqKFOzthQ3IfSAFvQ8NmS+WwyQkEYK5SmR76AgTZfVbAGIfPCC0Rp1JjouDNPDnGYZ24LXqNuDkl7Q4Ro6dVyMTdas61akFTpsT7NXf6fHmc4TS+PjVx6qEkxELpO3bpRxLMEgOrFE+drimkHLg9VWzrU+tt4yMY9KZAaSjqMcni6b9F/K//5JGIJE7SnwmO2B/o6CJ18j2ntiCfhuOFUfiDC1ZcitTMG+NyEb0gzdHUSp9k94q3nsiE0Hhf8guoLxPmNr6cHlQuB6AYKSrlL3NhiblbubSyZFLUE1TeOyzjrMLhuFJPx/8GPGYJGWGPDosj9f7q1qY2GQGjt0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 9:55=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On 2026-06-26 17:18 +0200, Amir Goldstein wrote:
> > On Thu, Jun 25, 2026 at 12:36=E2=80=AFPM Christian Brauner <brauner@ker=
nel.org> wrote:
> > >
> > > On 2026-06-23 17:34:47+02:00, Amir Goldstein wrote:
> > > > On Tue, Jun 23, 2026 at 4:55=E2=80=AFPM Pavel Tikhomirov
> > > > <ptikhomirov@virtuozzo.com> wrote:
> > > >
> > > > > On 6/23/26 15:48, Johannes Weiner wrote:
> > > > >
> > > > > Yes, AFAIU in overlay when we use realfile we should always use i=
t
> > > > > with_ovl_creds(), even though I don't think there is anything cre=
d related
> > > > > in filemap_cachestat(), I still think we should follow the common=
 pattern
> > > > > other overlay helpers use (similar to ovl_fadvise() and ovl_flush=
()).
> > > > >
> > > > > note: Actually some places get ovl_real_file() and use it without
> > > > > with_ovl_creds(), e.g.: ovl_read_iter, ovl_write_iter, ovl_splice=
_read,
> > > > > ovl_splice_write. But those look more of an exception than the ge=
neral
> > > > > rule. All other instances use with_ovl_creds().
> > > >
> > > > Use with_ovl_creds() is a good practice to keep the mental security=
 model,
> > > > but it is useless if the security check (can_do_cachestat) is not i=
n the
> > > > vfs helper (vfs_cachestat), so please move it there.
> > > >
> > > > Also it kind of makes more sense to check (flags !=3D 0) in sys_cac=
hestats
> > > > before checking permissions.
> > > >
> > > > > Also there are simingly no other file_operations which return "re=
alfile"
> > > > > for further processing, mostly the operation from fsops simply re=
places
> > > > > general operation with its own logic completely.
> > > > >
> > > > > Thanks for your review!
> > > > >
> > > > > ps: Hope overlay maintainers will correctly if I'm getting this w=
rong.
> > > >
> > > > I don't think this is wrong per-se, except for can_do_cachestat().
> > > >
> > > > Just be aware that the real file could change from one cachestat
> > > > call to the next (i.e. due to copy up).
> > >
> > > I'm really grump about adding a new file operation just for a
> > > special-sauce system call which is under a CONFIG_* option even. We'r=
e
> > > not going to set the precedent of piling on custom file operations fo=
r a
> > > single filesystem everytime someone adds a new system call unless
> > > absolutely necessary.
> >
> > I had a similar reaction.
> >
> > > This looks like it could just use a new helper in
> > > fs/backing_file.c that the cachestat thing can call to use the correc=
t
> > > file.
> > >
> >
> > I was considering suggesting this as well.
> > Having f_real_file() complement
> >
> > but technically, can_do_cachestat() should be checked against
> > the overlayfs file/inode AND also against the real file/inode with
> > ovl_creds.
> >
> > I'd love to be able to provide a backing_file "template" for
> > operations, but I don't have a good idea how to do that.
> > Do you?
>
> diff --git a/fs/file_table.c b/fs/file_table.c
> index c68b8c0a4097..d93059d53e88 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -57,6 +57,8 @@ struct backing_file {
>  #ifdef CONFIG_SECURITY
>         void *security;
>  #endif
> +       unsigned int flags;
> +       struct cred *backing_cred;
>  };
>
>  diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 27cc07738f33..64e07ebc43b0 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -50,6 +50,12 @@ static struct file *ovl_open_realfile(const struct fil=
e *file,
>
>                         realfile =3D backing_file_open(file,
>                                                      flags, realpath, cur=
rent_cred());
> +
> +                       // Raises ->flags |=3D BACKING_FILE_CREDS and set=
s ->creds to ->backing_cred.
> +                       backing_file_set_creds(file, ovl_creds(file_inode=
(file)->i_sb));
> +                       // Now add a helper that performs permission chec=
ks on
> +                       // both creds for that cachestat() thing and retu=
rns
> +                       // the actual file to operate on.
>                 }
>         }
>
> something like that?
>

Confused.
It seems strange to have backing_cred in this scope.
I would expect having user_cred same as user_path.
backing_file gets you from the real file to properties of the "user"
facing file.

The cachestat() syscall has a reference to the user facing file not to
the real file.
The helper would need something like f_real_file() to get to real file
from user facing file.

Anyway I am not seeing the big picture clearly how this could turn to
be nice code.
Maybe lack of imagination on my part.

Thanks,
Amir.

