Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7DF0109449D
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 01:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9707E6B009F; Sat, 21 Mar 2026 21:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9212E6B00A4; Sat, 21 Mar 2026 21:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 810A06B00A9; Sat, 21 Mar 2026 21:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DC6C6B009F
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 21:05:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F14C1B8776
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 01:05:32 +0000 (UTC)
X-FDA: 84571906104.27.75EA71C
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 839AB14000F
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 01:05:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kQOKkeH5;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774141530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z71A4A/9WIsYeL7CrSvLjwvAwzNvfNtlpf1MFBL4KRA=;
	b=PmPKU1tHCtNhRq0ipRqCc0JIh8tyHcIvxv/cpsYBGVdubUht1jwvXQ2PXvasxM6f89t0Za
	ZT+DNg3PH4xGqGL7v8eANrN5fCPPgzVh+FEZKKCbUpF1YnSpI7A7lDRGkdsdeykjhfvgNY
	Clg4Ams2EhUDb3BL3ZkTRE54qGeHfew=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kQOKkeH5;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774141530; a=rsa-sha256;
	cv=pass;
	b=DCMIly9ag258TLmZRww27fi2Cu2KU37cJAXc+80bJDEhTSgXh1OANvg90NVeBZBLXqYD8/
	hqUVZBox3cXjxUrtAM3f3fODZ5wWl+FQM+O8k/0/oGldi71jdzJl+LgQCVt0+xUSVfJoTX
	qk/NZ/povdRy9FgydXrh29kO6hY9/kg=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6618bc129acso4251513a12.2
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:05:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774141529; cv=none;
        d=google.com; s=arc-20240605;
        b=IQZNxMoxy//1rcVeHtbL5/BlCDlHH8G5gZpEUVBrVCWLFrC6hzrImLccymnV8DnZGG
         lTJK54jUHC7QsKlqsv2VFKFoQWlzRSH4PR8vN/2IAhhsg4KzDFonPf0AyCTRZRtaj8GU
         lSjznfuZB3sKwEFj/ijmrhNe3I/6bgOICxpLQQFMCsCRTZQxvMp4gjpPserva59IPOgH
         bR7n/a8pfKDJSyqp5r9j1XzBijQeU3H038yBNotsNA0sHKs7q/IJxY1mcf1/OslZ+ahp
         8rQ7y/FIig9/KVnr6sGyk9XNldO3ryA+fbNVh8RyeSor1SIM6ZZLmQbZm43fTep5tBTL
         RpEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z71A4A/9WIsYeL7CrSvLjwvAwzNvfNtlpf1MFBL4KRA=;
        fh=TwvvfR5EdkUm5J1whK1yrdF7Der6ypPf1b8aoYUKJQU=;
        b=hdLpo3cwap4HfSnGDmzEKitXrcFD5FFEN+GsD/Or47p1bL5mi4iAZI0fmUwbCMXv61
         eVNajE8azJJytl6guR0ZkIchzdbTHmU8745MFH1Yi7Vj3jGjEv8McJGb83C2mh+4FhjW
         oHg+/al7N15F90xsPhQOuqBqTaVNEvb8ocX7dDDv0NULZfdwBBpNqB3Xa4B88VwlkAeW
         FmqO87r4557MLJttwsCF17ahHJeBAjqxmrbptcT6qg2ynMxi+znbTVqoE5tSfBSofxjk
         sAS+sFDr4uj+AHXQ8YidboOAS9zz6mKXDFaHexVzMK6h5agfc2vDuS6fNnP2uiM3Ea1B
         2TQA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774141529; x=1774746329; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z71A4A/9WIsYeL7CrSvLjwvAwzNvfNtlpf1MFBL4KRA=;
        b=kQOKkeH5U70JdXl/ZiDlU3j8YxPsxNi7e5tM1n1byJloZCG1pXE4G7vavBRUNAJQLA
         sjZ0xLMz5QYYGdqbJqap0WMEsh4cdp1ThgzB0LwKEf5j5K8Xzpziqe8RAuOodPCJ07X/
         97SsC0WN//cqZAFhj71ZAkgJ5a9c62PoTDIr5rbYnx0Lbfn+9yT0EjyZHjm6a65adiBj
         4z67Cipdz8fYB4b134o4cnldAzW7eXvBzZTAxt8q4t2so7U+6gWNOHRZCnvwCKDpvlHR
         HsqARPn03wKrNgq80KNq7flSysTctHFFtWJHTAL8Ml674zfydmk6Jabp+2U7i19AVNUp
         UUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774141529; x=1774746329;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z71A4A/9WIsYeL7CrSvLjwvAwzNvfNtlpf1MFBL4KRA=;
        b=YaOuKBq7oqxyqWo+4QX0aMjvDL1RNMINNTC2UUux9lS1ncmeh6vT35Y+z9GAnF/5M8
         bewUNySFHXkrrXdHJaU2/ofS7aSN7I992BWEnMWqwNgjVkhKM08fZU3DVp7lZqmjvDps
         fL/RkVnOwx8l+i0Kn0BH9s/Jyzp2pn55IlLc/M6njzt+8YSP3tyMo3cKUor70XV8QW6P
         VPiNRqP0+37vujA1BITFRxyZHmRa8SgZD1GqdJbr9WnEnm7V4zVa2iwpkWu7d0/d2BiS
         blbuN1UX7A+9hvY5oge6TfjdVj/yviHDbAsR9FJbORkVLeHtccG3WJmQOLPLo5u+dwsu
         XSCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRBKJAV8bWxpmsMHW03KDDx/m7iJ661ELviXztzl5kHge3KY97hiVg0GQ//CxnlWe9iOIYIke5Vw==@kvack.org
X-Gm-Message-State: AOJu0YxPiDECYmzka+ijxBFwC8g8cja0326qe+ot+Jw7IeoDz/uInNy5
	AeD10Y/EEXDyG06az6eleF7nzbYqcpmi07+a6uTi7IxtMc6lVxskEvV3ow+naqYFwKbXadG4I4L
	wh7XVoJI2KMo6/2iYxp8eWZifEcUjmqzzggAktN0gEw==
X-Gm-Gg: ATEYQzyBF6nUC4tjjOmWOd2WNX0USJUFCEWd2sc4+9CZ7AZPa05wdmLVUlS5hhj13YG
	I4B5cq8y0EiMNHG2OdV727d7AwL3ODTjMocjkxFCIHzlZtRBaaXfYZTPQLSRvgmtzTs2XvJBLhd
	AVvZGBj/T+LvYgevUZivYVsJ5a/ErTuGzida76ur5B0fwTey9Oi0wOCEYv054BS0N8QrLyGnj3G
	i/hbw7w4MS9KI5kl49+8NONzjpnlFfYYqtGOqQ8K9DkJIC9DiuyWOu1kuK6JlAy6UxBjItmLVSW
	dTw2Pvl0QNoEWXNDbuDIsmn93TDpF8O9FSEdQA==
X-Received: by 2002:a05:6402:3513:b0:667:df35:8739 with SMTP id
 4fb4d7f45d1cf-668c9119018mr5809668a12.11.1774141528777; Sat, 21 Mar 2026
 18:05:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260321175808.57942-1-pasha.tatashin@soleen.com> <20260321175808.57942-2-pasha.tatashin@soleen.com>
In-Reply-To: <20260321175808.57942-2-pasha.tatashin@soleen.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 21 Mar 2026 21:04:53 -0400
X-Gm-Features: AaiRm52fD9VvtuC5_UHR4ptbTaHmC_PzXcfxEAIOVyW6x1v9oh_L8TjB8925SVE
Message-ID: <CA+CK2bD2aNu-NByET4KkBP0n2j8WQE2zjxb4g-1cv2hYfjaRZQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] liveupdate: prevent double management of files
To: brauner@kernel.org, linux-kselftest@vger.kernel.org, rppt@kernel.org, 
	jack@suse.cz, shuah@kernel.org, linux-fsdevel@vger.kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, viro@zeniv.linux.org.uk, 
	linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com, dmatlack@google.com, 
	pratyush@kernel.org, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 839AB14000F
X-Stat-Signature: qmj9jm7uxqqkcetawwbk1go734fgi4ib
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774141530-635902
X-HE-Meta: U2FsdGVkX187E2f2leuJbt4CFgyIx3YOM2UfLZ4SJip7CCDYCqZyBjWPfSwG4qFGV6V0OsKweOeS9pgf25hvz/lhfvsC24iwQrBIqXSPjoKaXpZJIQz5qIK1euURopvdeEgstss7Qr0btzU2rUJAFTx5uagGqYCYSv7YEbZ65aMN9Gv0yn474bhLbIVT3be6IVdi6lY3gIsJteR45L4DamZId8CsBpDVbMlmXoxnF4aUPMa8ue+xcf6vK/PSSofFXaPI2km+1GZPPaV8AxwDxbm4Bkb2S5ZjBJINmPAzBwdUKJmJf1nl5OS3szeBIAwlf0IUjuD7Fxux/HPxZbSqi6bBDgtZni6aIOdSjmM9BLGwkd77Ue720nKaeSoIUc5pxoJAs2wJlznYMDNvAHlD/pgCEZaJgdVpvPM3OMqDHpJ9LK5q8sDPUQFFoWJHWC40gFXsm7/kWZ4l+Kkxyr8p/ZVPn1aKZwR5HBhfOyAn2jr49vKA8h7tYMdsyh4vv2qqH3Vgw0H/rW1cnCNCNS7fwwQ4flrzkh+NLmBS+7LeAulPa8Gc6GcWk3suvtikTbC+cm7I5cInPSi65RcKMAU/bQfwpGdlikA8reBNagsOzmrvHXY6Iw2i7R1JSBiCoqyuJq3sdyuxgk2AqWjo1J39W8OagClowARBRL3bmKUh5UN0BO4Au5rnerMvJovqzrPT0v/+MahrjxeTqOSuclOIERmZaqpxEc2YpIaSV72zsYgxk4fA3DAblT52G45xrIMPgktN9v6r8WxnvGmc4EzLBlTEhKzu7KiTHX0Rj6R0INxhwzD4qO4JpBt7OldYYwtsSL4/AnkrHsBvCsgXe03WdFqiJKSjgZvhdOTqUcN+pVVHOHJ8pPniHlaJCpQeTC3x/MJY7BsLbAz5ZsTWDbTjGz7wWMzqm/ZZA9EITa7sa+hY5s0ZOu5GJCfYX1+ENe/dQjyBGqMltr5lUX8CI86
 EbA/Cegb
 bkgbl5y9r0vh0Ul34JLd0I66gL+1x1p/rRgp8X9bPyPaJ/eRzgrpuihdBg4V3yeDbbkPbWDF5f65walPl/NGmGSjctqE1cm3SygEKk8L3QcI7g5oQTIalQmdL9EYBcymVUa1utfBbFs/Z3vLv1o1v40V54eGV737JCj65Y9T8XfMCdtqJSsZuYf0xKSrcm4Bbbmft6O6YZW0hQ40aVJ9rATp37eLgj/i8dzjpUBv46RI1e4xjU7yesFqydWE3f+9QREUL7u0PzKHRJcWhbZ6j5TGuKPIMf+iH1vpcLbYCx+U8PeYdT+tZryPXL+0IJAfu1z8HyZwtZLdNmcqN93PNW9iMmw79y+I5qqLKOzDaU6wToTku5pjIxIcqTz0YZ4jh/8N+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 1:58=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> Currently, LUO does not prevent the same file from being managed twice
> across different active sessions.
>
> Add a new i_state flag I_LUO_MANAGED and update luo_preserve_file()
> to check and set this flag when a file is preserved, and clear it in
> luo_file_unpreserve_files() when it is released.
>
> Additionally, set this flag in luo_retrieve_file() after a file is
> successfully restored in the new kernel, and clear it in
> luo_file_finish() when the LUO session is finalized.
>
> This ensures that the same file (inode) cannot be managed by multiple
> sessions. If another session attempts to preserve an already managed
> file, it will now fail with -EBUSY.
>
> Acked-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> Acked-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/fs.h           |  5 ++++-
>  kernel/liveupdate/luo_file.c | 27 ++++++++++++++++++++++++---
>  2 files changed, 28 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 23f36a2613a3..692a8be56f3c 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -712,6 +712,8 @@ is_uncached_acl(struct posix_acl *acl)
>   * I_LRU_ISOLATING     Inode is pinned being isolated from LRU without h=
olding
>   *                     i_count.
>   *
> + * I_LUO_MANAGED       Inode is being managed by a live update session.
> + *
>   * Q: What is the difference between I_WILL_FREE and I_FREEING?
>   *
>   * __I_{SYNC,NEW,LRU_ISOLATING} are used to derive unique addresses to w=
ait
> @@ -744,7 +746,8 @@ enum inode_state_flags_enum {
>         I_CREATING              =3D (1U << 15),
>         I_DONTCACHE             =3D (1U << 16),
>         I_SYNC_QUEUED           =3D (1U << 17),
> -       I_PINNING_NETFS_WB      =3D (1U << 18)
> +       I_PINNING_NETFS_WB      =3D (1U << 18),
> +       I_LUO_MANAGED           =3D (1U << 19),
>  };
>
>  #define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index 5acee4174bf0..86911beeff71 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -248,6 +248,7 @@ static bool luo_token_is_used(struct luo_file_set *fi=
le_set, u64 token)
>   * Context: Can be called from an ioctl handler during normal system ope=
ration.
>   * Return: 0 on success. Returns a negative errno on failure:
>   *         -EEXIST if the token is already used.
> + *         -EBUSY if the file descriptor is already preserved by another=
 session.
>   *         -EBADF if the file descriptor is invalid.
>   *         -ENOSPC if the file_set is full.
>   *         -ENOENT if no compatible handler is found.
> @@ -276,6 +277,14 @@ int luo_preserve_file(struct luo_file_set *file_set,=
 u64 token, int fd)
>         if (err)
>                 goto  err_fput;
>
> +       scoped_guard(spinlock, &file_inode(file)->i_lock) {
> +               if (inode_state_read(file_inode(file)) & I_LUO_MANAGED) {
> +                       err =3D -EBUSY;
> +                       goto err_free_files_mem;
> +               }
> +               inode_state_set(file_inode(file), I_LUO_MANAGED);
> +       }
> +
>         err =3D -ENOENT;
>         list_private_for_each_entry(fh, &luo_file_handler_list, list) {
>                 if (fh->ops->can_preserve(fh, file)) {
> @@ -286,11 +295,11 @@ int luo_preserve_file(struct luo_file_set *file_set=
, u64 token, int fd)
>
>         /* err is still -ENOENT if no handler was found */
>         if (err)
> -               goto err_free_files_mem;
> +               goto err_unpreserve_inode;
>
>         err =3D luo_flb_file_preserve(fh);
>         if (err)
> -               goto err_free_files_mem;
> +               goto err_unpreserve_inode;
>
>         luo_file =3D kzalloc_obj(*luo_file);
>         if (!luo_file) {
> @@ -320,6 +329,9 @@ int luo_preserve_file(struct luo_file_set *file_set, =
u64 token, int fd)
>         kfree(luo_file);
>  err_flb_unpreserve:
>         luo_flb_file_unpreserve(fh);
> +err_unpreserve_inode:
> +       scoped_guard(spinlock, &file_inode(file)->i_lock)
> +               inode_state_clear(file_inode(file), I_LUO_MANAGED);
>  err_free_files_mem:
>         luo_free_files_mem(file_set);
>  err_fput:
> @@ -363,6 +375,9 @@ void luo_file_unpreserve_files(struct luo_file_set *f=
ile_set)
>                 luo_file->fh->ops->unpreserve(&args);
>                 luo_flb_file_unpreserve(luo_file->fh);
>
> +               scoped_guard(spinlock, &file_inode(luo_file->file)->i_loc=
k)
> +                       inode_state_clear(file_inode(luo_file->file), I_L=
UO_MANAGED);
> +
>                 list_del(&luo_file->list);
>                 file_set->count--;
>
> @@ -609,6 +624,9 @@ int luo_retrieve_file(struct luo_file_set *file_set, =
u64 token,
>         *filep =3D luo_file->file;
>         luo_file->retrieve_status =3D 1;
>
> +       scoped_guard(spinlock, &file_inode(luo_file->file)->i_lock)
> +               inode_state_set(file_inode(luo_file->file), I_LUO_MANAGED=
);
> +
>         return 0;
>  }
>
> @@ -701,8 +719,11 @@ int luo_file_finish(struct luo_file_set *file_set)
>
>                 luo_file_finish_one(file_set, luo_file);
>
> -               if (luo_file->file)
> +               if (luo_file->file) {
> +                       scoped_guard(spinlock, &file_inode(luo_file->file=
)->i_lock)
> +                               inode_state_clear(file_inode(luo_file->fi=
le), I_LUO_MANAGED);
>                         fput(luo_file->file);
> +               }
>                 list_del(&luo_file->list);
>                 file_set->count--;
>                 mutex_destroy(&luo_file->mutex);
> --
> 2.43.0
>

> Sashiko: https://sashiko.dev/#/patchset/20260321175808.57942-1-pasha.tata=
shin@soleen.com

Sashiko reported two problems:

1. Are there any issues with mixing goto-based error handling and scope-bas=
ed
cleanups like scoped_guard() in the same function?

Initially, I thought that there should not be any problems, however,
after looking this up  I found in include/linux/cleanup.h the
following comment:

 * Lastly, given that the benefit of cleanup helpers is removal of
 * "goto", and that the "goto" statement can jump between scopes, the
 * expectation is that usage of "goto" and cleanup helpers is never
 * mixed in the same function.

Well, good to know, will not use goto inside scoped_guards.

2. Additionally, does setting I_LUO_MANAGED on the inode break the preserva=
tion
of anonymous inodes? Many file types (like eventfd, epoll, timerfd,
signalfd)

This is actually a very good point. It looks like everyone who uses
anon_inode_getfd() has one shared inode. This is not a problem for the
existing LUO user memfd, or for the upcoming vfiofd and memfd, but
kvm-vmfd and kvm-cpufd also use it, and that might be a problem in the
future once we add support for Orphaned VMs.

Therefore, we have two choices: either use a hash table, which adds
performance and memory overhead, or delegate this double-check to the
LUO file handlers, as they can use a private context to know if the FD
is already preserved.

Pasha

