Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B305B606A327
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Wrk5gWYW
Received: by kanga.kvack.org (Postfix)
	id AE5F56B00EF; Sun, 15 Nov 2026 09:48:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABCD46B05B3; Sun, 15 Nov 2026 09:48:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9887C6B05C7; Sun, 15 Nov 2026 09:48:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 685E16B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:48:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9BC980784
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:47:59 +0000 (UTC)
X-FDA: 85437633078.15.C362950
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id EABF3100008
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:47:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Wrk5gWYW;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=amir73il@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794754078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7HykaAJlgnOpmpM8XJHQMzZjK2dm2wSOUdGIuC/Jng=;
	b=kbL08NTNDy4hwvllxBlZEprjnlyls5t/BtiJdK6PIhZsCbU8MO7VA3+X6e9CsJc3g/jnDQ
	0YgmV0tzxAbIMarteHbjFtjqhvxJ1TgRVuNXMGucnpqf8HrE83StjT/sJfnFvnbT5Wvbkl
	dKrMG0UsvJw9HoDL3WTELe9IUW4LPMQ=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Wrk5gWYW;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=amir73il@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794754078;
	b=r5Ri7L4ttoIJKdzlTJEfov9dcIAeAAGJ2Re4ZQHzgaHedMpsJseGteJEAHNmIRdMV559Ip
	L/hjQ7KNa8yCKXNCJGaO/Z1XCqRgIDrxBZOAKwQRTOkq+hetoLWrI6oORH1X0MmLg8sOG5
	yErBuXM8SXGjPHssu+LqtwcwfBRgBZA=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b2237b596cso5977798a12.0
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:47:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794754076; cv=none;
        d=google.com; s=arc-20260327;
        b=cwEtcTanTqAmkha2TX2VnO3hSceBJGbt2Xsin2VJ9ABt/RD8SyINdaf8zPkUiHJvpU
         V+AncAZkO2K1lzVtG43ibZwUk9KWsB9tDxqFBLw7+8DLYFhSm5iMxr6wTm0wsAfhAFzR
         33RMIrXLUkb7cdhA6XSho0vdsYCZ2LSIV/zc7Nz1DfZIq0JMVEqpKT2seUIaMTqEpm7b
         2UAM8k7kYk7NeOLsRtgU1+Q90uKy0gA97urp5gO0oACoR670+nhbSwpCBm5DPkNQc1Q9
         yaOOlfW+aRexncsLq83FW+LtMLQSe9mTgu7Nba2lztfw5JLpzadwr79cmqMYF6yypdf3
         XF7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x7HykaAJlgnOpmpM8XJHQMzZjK2dm2wSOUdGIuC/Jng=;
        fh=qnzSquc1ZE8rUjdk+4lYII8LkhnJgvdXWy9gwmsX7qY=;
        b=LIQfBeivCPnbEvKHnUTt/YujUjp69z9PmQ4KVhE5cU54vAhd2NPTfWqCtciOrZT+3l
         d3iNzl6gcuJ9yXYY3z2ceS/BANiF8nCAfrFCaeVwfPqodQ7gfx/+WKUgDsizyv1t2rL1
         lO/VIWG+N9dgNpK+1KqKqB+MmzQAtMsM5025t6ihF+C4K6faX8wbpoWwDHOQFFp79NmJ
         7ur1umzqFhWpSa9UvUPm90VvuymuCbKHtzF0o0WWkwSqiuzCZ7bQBpzr7Ed7pw+f0W7i
         KVm0h2GLJilUCpifAKtecyc35yW/aEQCBpDHdl4neUV298eVpyKk8ywEbuBk4ALRBFJU
         h08Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794754076; x=1795358876; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x7HykaAJlgnOpmpM8XJHQMzZjK2dm2wSOUdGIuC/Jng=;
        b=Wrk5gWYWRRUl4UBHIkKo1PJK76ad7F7FNbqsHYvg++Q++iGMENMDf8hNwa+Zn4DFZ2
         eRqLuYeggMJxfvYZxW8sYr3ghL0F4rsxEnfmrEvhUwjv7cx1Lk0emRMbdnZhW35tW5oH
         8T4MgPWf647y0nccdiG/pUkiL+2xNHpD7MwsDbAFgmvqyICq/rk4ismEjwVk75dAYXTA
         3Zd8B4EMxxxdnE3z9tbkxbCFo7fWapAx1nMgoT2+b43gP5SSEUTYFtRmcX57MxbW9x10
         sLYFss9fZgZMpMNzLh8I2u3YbOvPQ1r0cA6VR31ufvKcmBxg5TJP6xFVU5gX9cPbO3yF
         Cqig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794754076; x=1795358876;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x7HykaAJlgnOpmpM8XJHQMzZjK2dm2wSOUdGIuC/Jng=;
        b=h/koUkFVYDTmVX3vyvuHzSmMCCeagdZ9gATHOwSbiJ5O2tPTYHjqfxbOn1zXLX05+h
         I4VYwOnZl0wK4K5KWWHwMMHPLK3DX6/4j7IMCPZIoPZuDFjsLa1PGmXFBxjDgdx3RjRF
         wkuFiA/tGVXWk6Rfo7QchmqefRPTUXw8iUgBJg2qUHM2R0oOQDVSYJjDr+WrvBcEKA2/
         Uz/asduAshf9TSGTMz/di3wNTZnIJwL3JYkBUuaOUf1yMu6nM/ldBP1mdXCUay/wmWVK
         ErilMlnrZ6bmuWFg2au1YIS4SF5gOEtpYhw7wxYrp2oOFWXEMJ9qWjD1hniC0nrPC/Ft
         KGmQ==
X-Forwarded-Encrypted: i=1; AL+hErFWo4QXN2dXiO7e5naQq8hCYBx2us7SKAVKKrNxLiLZYmz1mhpHRMQUma2H/iB5Ti+xwchP8w6jZA==@kvack.org
X-Gm-Message-State: APuU4Z8dlE3DVBujObqO7nrt178T4PGAZUKAMXkjbRDbYrVVyXjsRb2y
	sVD/ocak5h1KN6j+VHvzogTb8MGqT0549I+art6wcuQlUEEfj/VgDULJaj3mSPw7VIbfHcEbwlW
	qwPglvamYwDW2XYg8j1jxNcOyWlF3p7k=
X-Gm-Gg: AYBFou2QsCCNNvfQPxS3UEawGDEagcTqUvS5yyCWImMrd3T8gdw6jj9SoZwB25yiIX5
	JURkI3eh4mzMlpPIA8hMUzFuUV7TO0FZpzMGaB3c9TmooCUwVM+f3+HwWS2qOkioGWrjt0NYBQ1
	ewxjfDZUVDpCZ8bUIZMjA9hJG/WbAOVTx7bQsPx1Z4gnhEy2cDB6PxBgLRRAocnXu+bMKVjJDRb
	j48wItdlu/8LlH91LnH7rDKuGnvqRmZrAlQlo0wn5M0x2bm2Mw6uKEsnSKrL+SrDEKl0n6eyLtj
	DEqZ5DygXgwbykfjcKkiNQm85tvKDehGLJpnAY53bxleW3l1TZQwXK2uF2dpZIVVrwD3Gdx0Zsq
	auMHdzdL97a4AI5RuYSNFfGwtZNA7mQMW4Us31fS7aFRMhyrShuj7p/iOSoXodWEoxdDHuA==
X-Received: by 2002:a05:6402:1d4c:b0:6b7:e12e:7f1f with SMTP id
 4fb4d7f45d1cf-6b7e12e824fmr3426650a12.10.1794754076394; Sun, 15 Nov 2026
 06:47:56 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org> <20261115-work-ovl-d_real-v1-10-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-10-ca155efbcb2e@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 15 Nov 2026 15:47:45 +0100
X-Gm-Features: AclHuK_at8qVhKBNN0WXPGQ7F2lmyjSQgMjlfNE9nQtuQriTEXeBZE7dwGmSTD8
Message-ID: <CAOQ4uxggW+UifxBJDY8fAb+g5EWrsD+rELwXa1ngZ_5X_OZx0g@mail.gmail.com>
Subject: Re: [PATCH 10/13] ovl: return the error from the lazy lowerdata
 lookup in ovl_d_real()
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Chris Down <chris@chrisdown.name>, 
	Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EABF3100008
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 3az1p97ujfust5kz8erpdo1sujdgad6b
X-HE-Tag: 1794754077-355140
X-HE-Meta: U2FsdGVkX19HypqLIbD/bSV0mr5cs6AxmJ56E5ScQi6YjT8TC/ES+Qp+/1eyuEomNL/tQPEOv8sZoGOf/ye2fRuu8nHyHVuAivyL84a3ZIGBtHnccu5sVoOjeP7iBBV5iiJTpRDzCLlxU5VsFlR+02BKnjcbv/3vGhdElNhmfMruPwXrMikOlLoUayUOBThCJ23Rrd1WnC+J9B09+ukv6xbcFPrLeR63CZB20QDYY2Q6xrvdZf3bu1k3ySRXDIskM2CU6bZLutFW4VKqHQULFiH0c4H29hiQaoanYFclBfBZGum2QuRakrMC/L+3gVxwXFem/Zdsdip2rFik3zIfeKqpznrjzPmJ7GzVZoJWODIFajF7ckio3AqM6Ocgsrif6H9Z5ZTR0QrcVn/4dGS9Moh5VG9pGyKedJMZM7bJlQeRnQKyupMmEOWZU+MtDpNWqdf3zl9k8R46mfA/vtwS/w2dq6QYk/V9OJXM+XDRvShfROWgOJRq+5xF66d1dTP7JLqMzSQWdVomlTWmLSCxE4kLF4jghNNmqtETGu+zbTz9CJ5bJ8NO3P5bJ+cEB9V1EiroZgyTGZhP4EFVa8f1R426mUq6VzQMOobvoViHqPI6kfoWC2mLGUQMOd2Qws5KtSrWeT+I0FdYPvvv6ncY15xh7BKxs1GcbYEiwwD54Awxl4wQvCIunYyswSz3ip7cQozJk0/Uj0Hb9lEcIxSwYTOavJHFKgYjNYy0Exos/tQkbrQ1o2C+kKmB0LBwtYwbBywPfwKIPXFUWGIaInx4SO6YgruSojoysWkCfXNpfRoV1mBN/99O/3Cd3vZXzYpnVk8UAKXuWUwPhjL48g3T6DBSyz/wcy+VdTClpH5pCja7/3NOXgsvZvxiA/3ATWLY3RxUU3m7YXw1xd2k6jTGubT1VCF87cgZ1iiofBqU4UJZBsHFo2xd2bzhkpUcUlJ8u1twZrDY+K5kPQ+pzig
 khS1QKyl
 nljGvCrf1UWSfln44OD1bX4thn1JAO7ZAeAO2EU+mIHz47TKEip2+7HWdxOO775PaH2PWZumBWWNo6VvCOieE0zMwBIMDyhybpL8AkRKemrbvsrK0AUSWKRi/N9kLqZce/YsYjqnIkZJhCdBtCaK1Q7ragx6uLgTslIMvC0Fg2J2+5tCjF3eSb6tvOHOq1NyZV1AIT9lzDeCBt2V9cxukua9V/K06NIFfa4VL0ziqwf9V1RrS8nzIIT/uddydpWhQr6FiTP0erTXvKwWSKbW7oDehjrImIIBdj3VVfvoybQyXm4qqmCyMvLOExQTGX7sIafAdnXJUHo/tGMEGTDPCnlMiHFXPAFz5fYl7lmHJ1uR/J/TJOS97VUMTiHkb1FeORFH4unCBlHtAL+yVIP3vvKxrECYXzPgW0LeV19nTEKLVeK/EVQa9hSCFhz8zmyTwRDTum+Lv7tnXDu/x9HYcndJ8veYH0mwJ6o8bYeXsvPoViYeDQap5d2JsXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 3:02=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> All callers have been converted to d_real_data_inode() and handle an
> error now. So return the error from ovl_verify_lowerdata() just like
> ovl_open() does. The lowerdata dentry missing after a successful
> ovl_verify_lowerdata() would be an overlayfs bug, so keep warning about
> that but return -EIO like ovl_open() does when it has no real path.
> D_REAL_METADATA never looks anything up and still can't fail.
>
> Update the comment in ovl_d_real() and the documentation of d_real() in
> dcache.h and vfs.rst accordingly.
>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo=
91QjJHH9T_Yw@mail.gmail.com
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Nice!
Thanks for cleaning up this mess.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  Documentation/filesystems/vfs.rst |  6 ++++++
>  fs/overlayfs/super.c              | 17 +++++++++--------
>  include/linux/dcache.h            |  6 ++++++
>  3 files changed, 21 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystem=
s/vfs.rst
> index 1824462a43711..6953f399672f3 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -1374,6 +1374,12 @@ defined:
>         for returning the real underlying dentry that refers to the inode
>         hosting the file's data or metadata respectively.
>
> +       For D_REAL_DATA the filesystem may have to look up the data first=
,
> +       e.g., for a file that was never opened.  If that fails an ERR_PTR=
()
> +       is returned and callers must handle it.  D_REAL_METADATA must not
> +       fail.  Most callers should use d_real_data_inode() or
> +       d_real_metadata_inode() instead of calling d_real() directly.
> +
>         For non-regular files, the 'dentry' argument is returned.
>
>  ``d_unalias_trylock``
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 1985b553a47b7..39d4d57dec230 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -42,7 +42,7 @@ static struct dentry *ovl_d_real(struct dentry *dentry,=
 enum d_real_type type)
>         }
>
>         if (!d_is_reg(dentry)) {
> -               /* d_real_inode() is only relevant for regular files */
> +               /* d_real() is only relevant for regular files */
>                 return dentry;
>         }
>
> @@ -57,17 +57,18 @@ static struct dentry *ovl_d_real(struct dentry *dentr=
y, enum d_real_type type)
>         }
>
>         /*
> -        * Best effort lazy lookup of lowerdata for D_REAL_DATA case to r=
eturn
> -        * the real lowerdata dentry. Callers may ask for files that were=
 never
> -        * opened, e.g. for uprobes or O_PATH files, so the lookup can fa=
il
> -        * here. Return the overlayfs dentry then.
> +        * Lazy lookup of lowerdata for the D_REAL_DATA case to return th=
e real
> +        * lowerdata dentry. Callers may ask for files that were never op=
ened,
> +        * e.g., for uprobes or O_PATH files, and the lookup or the verit=
y
> +        * validation can fail. Return the error then, just like ovl_open=
()
> +        * would. Callers of d_real() have to deal with that.
>          */
>         err =3D ovl_verify_lowerdata(dentry);
>         if (err)
> -               return dentry;
> +               return ERR_PTR(err);
>         lower =3D ovl_dentry_lowerdata(dentry);
> -       if (!lower)
> -               goto bug;
> +       if (WARN_ON_ONCE(!lower))
> +               return ERR_PTR(-EIO);
>
>  real_lower:
>         /* Handle recursion into stacked lower fs */
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index 674bc50b81827..5b3b34d271bd0 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -638,7 +638,13 @@ static inline struct inode *d_backing_inode(const st=
ruct dentry *upper)
>   * If dentry is on a union/overlay, then return the underlying, real den=
try.
>   * Otherwise return the dentry itself.
>   *
> + * For D_REAL_DATA the union/overlay may have to look up the data first.=
 This
> + * can sleep and it can fail. D_REAL_METADATA never fails.
> + *
>   * See also: Documentation/filesystems/vfs.rst
> + *
> + * Return: The real dentry, or an ERR_PTR() for D_REAL_DATA if the data =
can't
> + * be resolved.
>   */
>  static inline struct dentry *d_real(struct dentry *dentry, enum d_real_t=
ype type)
>  {
>
> --
> 2.53.0
>

