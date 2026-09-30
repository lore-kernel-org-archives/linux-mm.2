Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD856CA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 13:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6FB46B0088; Wed, 30 Sep 2026 09:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8A46B008A; Wed, 30 Sep 2026 09:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A2C6B0093; Wed, 30 Sep 2026 09:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5ACBF6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:36:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B10D71407B1
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 13:36:00 +0000 (UTC)
X-FDA: 85270526880.19.02D2877
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id AF5E6A0007
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 13:35:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eTRpFaBo;
	spf=pass (imf25.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790775358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QchkhwI1w5bSASLXqcxUjuWuiosjQacZxJlQZryO/o=;
	b=x9vxGd8+RU5ZHJPBuhTB63l+EjctZVM7/bIAv497oQPegdr+VRqFn3Xw0BikoSJe6/iKsJ
	wK+EsJVMnBXibRNqLhjBc6JSoEK6Q6ZmfS2Zj5ixB+demz4R5V917DIkNf6e+QW3M1K/Za
	mPx8FPZaxl0+F46IoCnp8+WZ4F+pBNM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790775358;
	b=15539Mm4m8bOoJbSjEt8ZFSIVLURQJgV51pzmM8bGWKay89wY6fmiDWWH1q0wdWAjswS+h
	tR3qSKEp2AMqxYhZiKFxjy277Ai/kmn9+bnnrFmk9xzQl2WkcohdLKEkHePPszzspjR6qJ
	BM3cXReLcVE1sXFa4pEszUb/K0QCC+A=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eTRpFaBo;
	spf=pass (imf25.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c20ce3c118aso291645166b.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 06:35:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790775357; cv=none;
        d=google.com; s=arc-20260327;
        b=TTomSUSkCfGVvWsZ7ubySZU9wCnp+oFXEuZDEUaOH1Wnz1JTpzTKHY5jOWUdEtFiTA
         gx4up4g8nK4AVXGI62fIHrlpKf5PUnZEPT28UEVV/ZDojbhSH0/FfDiadfwMzmodA1Sl
         BIvwcjJkJapoN+0iuWTQz8ybSH9VWflMF8ycaM/jssUyZkJU6zf2Bu4IkMqqXtBb9/fU
         i+kWM3iBwnHJ4L23fQ5M+INLfIaxJuUFk4NOYwrjKHshGb2Q77SrwOe1EwcyH8RwxMB3
         avcLnAHJZRQfAs38kiJkDXaQcEJQRiP0ikLkHjCQb0x3rPEX9f+wTEHBeNBTYornNsTX
         jHvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4QchkhwI1w5bSASLXqcxUjuWuiosjQacZxJlQZryO/o=;
        fh=GyaY/DbudVSU0VDVHTiojUPMNRvuDy2/0tsKYoX2VwM=;
        b=kJDYp6j7LXpd5ZqPZKznl9sdogVj1mNtE6Q5NPzJZo6OZuf0IjywkBLD1ylTKMGvz+
         Ee1IZDAh6V02zFJ31Ua5hhCqyrtiL55LfTRn3JtkTTgZK7AZpYWa1UvPunaQ54R7skhR
         gtilPQV+j5FnHb3FEzKDUbduFdxCQeH0d0l8Opw7k+Ajys04I6htKnDEne/UwClMGNME
         mVg/q7c75++16PdK9yFAieTac6aMouwCX1CZCZRcy3lwijMbgjhRsqRd9sIM8HexrPM8
         zZIYNO1Fk+xODLl5hhpK6g7zo+HPajc6Tv5Air09L3RnnS8OUzISsU6eTlXRXoJw1BS3
         fnbQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790775357; x=1791380157; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4QchkhwI1w5bSASLXqcxUjuWuiosjQacZxJlQZryO/o=;
        b=eTRpFaBo+Sg7rrdGmvBb+hG+Saavf8l77E4HLN63+xBEI2hPq0BPlrotS7XEz7Tck/
         kB6JEVKPk6q/9WM1lJOvzOEhKzimfmHzpk8lCKCXLM2w5r/i+oKqJhE3ISCEqxT4jCS5
         uaVNPAZ3sl33AB4xkAaXFfWv9uZKXpn7k/qd2Me1A1kRQvfIDg7gsc5qH9Pyl7DeLn2s
         5BO9Wp7HTW4ID+7H7SoYHcJaEtqc+Di9BHUnCfAIph4ml5zmWMBNtAaqwzKDidWlG5Mm
         mwJ0afzR9lkmcNM84ligN0HANYm/iU1Ugu9e/gFFb3+lT++vCboANymtRh0jztWvnAQK
         v36Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790775357; x=1791380157;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4QchkhwI1w5bSASLXqcxUjuWuiosjQacZxJlQZryO/o=;
        b=nk6GQbV2eo6CifBjZPoE66iQ3xWI+lhf7xQlFQwJAr2lqf1laflGPlbcxpnUbazSeF
         Z7ruMKS0G5i4/0t0dxaRT6FclwdkASc0liTVc7PP4pTy9+KXdsZXucNjHbiaXXSSWFAz
         91z/Cz8iWm2kSUhBD1Q3i56GqcTjrRAnEYbFYhlQuaJd53qQ3TlJjsgz1i0EdR/LkB9s
         k0UrHcdHPZYoTF4WnVZg6qUWo48b8U9OYAvo49N94R4J18t7CyxN+VgKCqIiMBH02zLb
         66hkAqSGIKxH+7umNxsZSdyxfNVYY1uNFMIEr1t0pzbbN9W1Tm8F/jZjanrVMrEURlJY
         E38Q==
X-Forwarded-Encrypted: i=1; AKwUvBxH0ns8PUu1AADR33DxWLFlfAWCfVFWct0zVwo/Snh+AlgtEkrdsU6JgsB7gRrsETBlmmZ8o4zmlA==@kvack.org
X-Gm-Message-State: AFuF++nV/fEcor6G5MYNv35C3a/WsErkLFVzd41oF/y5w7d5P1Zw4H+A
	pwcwp7cdbHG1N0qaeqW8iBFMa3YKC5vKug+sAAy8qQvAjU+j+3hlfgbFx0dFZN2exStTzkmxS7K
	pf0fDd6rhVO/K5pcpBg/wWAkFp2Z9Oug=
X-Gm-Gg: AYBFou2v31wZNtxLgBaCSe7xc7qkt3xWnv4JSyP8VI/R1rf1+3Jbs3RtfK2IYWT8ttv
	W6FUiKZopS1dkRYZRuBRsQiGjEFrrhJqkY1Z1VW0mv+MaRVKv9/NdPfUjUlIxW/T4b1huaACsjJ
	Zwrn2gqk+YiLWcCKpD8D2ozka7jlPqRnHk8BD7cIHIP6RplKkEdV0KxX2LRRPaPXPMlcqH1E3gi
	G6IG4G9si9iQoBHe+j4TFFxCNXo5L5k76Bm/1BrycMusoYpX4W3Pm45TD9QgPVO9Yk5k2CDAcSS
	FUMvE1uKECrgUD4JnxXg0aH0lQWlkHraSzLBVAHP8rnKXiS9xB2IeaIz9i1OtidpDOSj
X-Received: by 2002:a17:906:6a05:b0:c2d:b9b4:f4de with SMTP id
 a640c23a62f3a-c2e23d9207amr125564266b.18.1790775356627; Wed, 30 Sep 2026
 06:35:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260929034158.1455429-1-neilb@ownmail.net> <20260929034158.1455429-8-neilb@ownmail.net>
In-Reply-To: <20260929034158.1455429-8-neilb@ownmail.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 30 Sep 2026 15:35:45 +0200
X-Gm-Features: AclHuK-7IYZDCVZREHuHZMSP_wgME-NMrM9tsJnpybGevda7U-xOXfVzEqygZdo
Message-ID: <CAOQ4uxjv3Ziqy+CjbCO7noAPse+a0066UO7pkFhStnnW9FFSPg@mail.gmail.com>
Subject: Re: [PATCH 7/7] ovl: stop using lookup_one() in ovl_iterate().
To: NeilBrown <neil@brown.name>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Kees Cook <kees@kernel.org>, 
	Joel Granados <joel.granados@kernel.org>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Breno Leitao <leitao@debian.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Jan Harkes <jaharkes@cs.cmu.edu>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Hyunchul Lee <hyc.lee@gmail.com>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-um@lists.infradead.org, 
	codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, linux-mm@kvack.org, 
	ntfs@lists.linux.dev, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AF5E6A0007
X-Stat-Signature: g3qykodqy9ibnhuq7cy8fg8egiwm3qo3
X-Rspam-User: 
X-HE-Tag: 1790775358-358018
X-HE-Meta: U2FsdGVkX1/rCBUpup2C9SmZdJajO7JgpO32YygWpslYrkoidGl6iLTPvLpZJCOb1kEdrH9NlLCuCSb71R7KnY6Jp/Yq4yZhW2i14DV2rWR9eZ/JNw6NvkCloXzRSS1S1OxW28eMOydfCZ/38Uk8tcn0o7vZoPB2vIQhxJyRdhGfoGCINisffxX/uINWjuVNFiHnIdZPKeJ1E1CUGcXVUoZXuVHcWRgbhlQ4DS58Qf65eMoHk2GhDfsF26nT2guyWFh20b+1ZC2ldOn03dgq6q4FCw447MUkaamiBQZo6N0L08NijeOm1Tu/UWu1+lMpBhytRZCm6H1WmZk5HwoVSF8zis6GUT4bLK0xQP0s3ekTyqFftM+saZFo8QtB1zRL/jlhgGPXukDCg5PEpUyOR5S3wQIE+iHd7PZv8yn5xB4Ix3dd4DTQvIXFCUMw9yAJpw0GMFc/0FEn2JbUOaRYUJakAIkh/eURxNA+rfPq+MGfwR8LVknAFWMfsmU2BlIxHB6WBdduwiEVr9JjK2hA7XYeMDEPD4VURaCIRSFH4yMBL7Jq0XDHqL2txuz85IftdFO+nzO9/NALiFn1T3gTtofFE5jeGNQitQY6b2+LGtvKzeNapfyf7eIJWtLkKBK8PNooPtwrM3/Etw5llICdjMcDRdQWnUjB+/OVYI3d52NPn177mwIML9iBsehDTgqIujVq1SPyYKh2AkOpMZkfEHALcS9mio2DLt7cAW2OsMQd/hDgNMDu18iJ36/6RCQ6uA/lOvOMRNZjOZ9dDdDE8+1iyTDS1ZnMZjbdFNwASQ3BolsMWEINVPjyh+Lg/BqpvNosD4Ajsepk3OB+eWsizWirdt6pHH9K8gTkQITKFamVMWQRsr5Hs+9XID0UXE48ccAVPN/ZnRFObhJ433vlz9+0a/sreBbVrH5siF3Jn9BsH97NCEwzLR31FlocAr+0ylXvVTOZsmCwnhPTMzJ
 LhAcZpxh
 AR4X3/hL9ppTD65ddHUwCDOFHKjgehYDQWBozq+Q9BbJlt0oseCqa8AdtTy7quGf+ANe9x+wlciCOtn/bEN0V0Ybajlxf6TTEjfgqMQDQrLtJ/nCLXFhju32OhTScnnpr6yNCPSljyk2SSe+T3CFO7etX8RM3K8ErIpiCTd5/K3pgFdpIV64etKjdiGdZYo8C1u4E7MB3du9Z2ifa8mh0417XtoV4OssnhhRtQzWrxm6Lew2fYk2l4WMPLldxGIA7pL0CbJMBaM7TA9oQQ3exqHjCRKPOFaIvEzi3RUw5rNRjHzhMSYZ/ZMag0vqSQTNcJgjYznpXdiLRIybbYhVqI09N02jUrQMafKL3tJkBBd6nMvl5H4iGlkQT0lRGmWAzAwAG59w5lRJnnucF7ge1nWLN/aP70qEhf1N2Hn0ApCjqA9x/g8eMW69pBogfikd2P2SNQOTk+MjWoeckb1Hb8rzln0UJpC9vvjHykoGA0nFaIuzQ/E1egJrHlt0xjz3/qCoPbZls9XXHQ4zqOVJ5Hg9eZ2qO5Eq0SaLuyBoMVO2C9ojXWVrIYb08tNl9sc6N6C6vLu7XbR17CI0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 5:43=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrote=
:
>
> From: NeilBrown <neil@brown.name>
>
> lookup_one() is expected to be removed as it does not fit well with
> proposed changes to directory locking.
> Specifically d_alloc_parallel() will be ordered outside of i_rwsem
> and as iterate_shared() is called with i_rwsem held it is not safe
> to call d_alloc_parallel().
>
> We can instead call d_alloc_trylock() and then call the ->lookup, but
> that can fail if there is a lookup attempt concurrent with the
> readdir().
>
> ovl cannot afford for the lookup to fail as that could produce incorrect
> results, and it cannot safely drop i_rwsem temporarily as that could
> introduce races with handling of the directory cache.
>
> Instead we rely on the fact that ovl_iterate() has an exclusive lock on
> the directory, so any concurrent lookup will wait for the ovl_iterate()
> call to complete.  We allocate a separate dentry and if the lookup is
> successful, it is hashed with the result.

Please document this assumption with:

rwsem_assert_held_write(&dir->d_inode->i_rwsem);

and comment in the code. Having it in the git commit message is not
enough for future code reviewers.

Other than that, I have no further comments, but I would like
to have a review from Miklos before this patch lands, because
I don't remember him reviewing any of the revisions and this is subtle.
I am a bit concerned that we have no test coverage for this subtle code.

>
> When the concurrent lookup gets i_rwsem it mustn't do its own lookup -
> it must use the existing dentry.  This is found, if it exists, using
> try_lookup_noperm().
>
> Signed-off-by: NeilBrown <neil@brown.name>
> ---
>  fs/overlayfs/namei.c   | 12 ++++++++++++
>  fs/overlayfs/readdir.c | 26 ++++++++++++++++++++++++--
>  2 files changed, 36 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index ca899fdfaafd..f56e33fd4d6b 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -1385,6 +1385,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct=
 dentry *dentry,
>         struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
>         struct ovl_entry *poe =3D OVL_E(dentry->d_parent);
>         bool check_redirect =3D (ovl_redirect_follow(ofs) || ofs->numdata=
layer);
> +       struct dentry *alias;
>         int err;
>         struct ovl_lookup_ctx ctx =3D {
>                 .dentry =3D dentry,
> @@ -1399,6 +1400,17 @@ struct dentry *ovl_lookup(struct inode *dir, struc=
t dentry *dentry,
>         if (dentry->d_name.len > ofs->namelen)
>                 return ERR_PTR(-ENAMETOOLONG);
>
> +       /*
> +        * The existence of this in-lookup dentry might have forced
> +        * readdir to do the lookup with a new dentry.  If so we must
> +        * return that one.
> +        */
> +       alias =3D try_lookup_noperm(&QSTR_LEN(dentry->d_name.name,
> +                                           dentry->d_name.len),
> +                                 dentry->d_parent);
> +       if (alias && !IS_ERR(alias))
> +               return alias;
> +
>         with_ovl_creds(dentry->d_sb)
>                 err =3D ovl_lookup_layers(&ctx, &d);
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index e7fe29cb6028..bc41da4bace8 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -574,8 +574,30 @@ static int ovl_cache_update(const struct path *path,=
 struct ovl_cache_entry *p,
>                 }
>         }
>         /* This checks also for xwhiteouts */
> -       this =3D lookup_one(mnt_idmap(path->mnt), &QSTR_LEN(p->name, p->l=
en), dir);
> -       if (IS_ERR_OR_NULL(this) || !this->d_inode) {
> +       this =3D d_alloc_trylock(dir, &QSTR_LEN(p->name, p->len));
> +       if (this =3D=3D ERR_PTR(-EWOULDBLOCK)) {
> +               /*
> +                * Some other thread is looking up this name and will
> +                * block on i_rwsem before it can complete the lookup.
> +                * We will do the lookup in a new dentry and when that
> +                * lookup gets a turn it will find and return this
> +                * dentry.
> +                */
> +               this =3D d_alloc_name(dir, p->name);
> +               if (!this)
> +                       this =3D ERR_PTR(-ENOMEM);
> +       }
> +       if (!IS_ERR(this) && d_unhashed(this)) {
> +               /* Either we got an in-lookup or we made our own unhashed=
 */
> +               struct dentry *alias =3D ovl_lookup(dir->d_inode, this, 0=
);
> +
> +               d_lookup_done(this);
> +               if (alias) {
> +                       dput(this);
> +                       this =3D alias;
> +               }
> +       }
> +       if (IS_ERR(this) || !this->d_inode) {
>                 /* Mark a stale entry */
>                 p->is_whiteout =3D true;
>                 if (IS_ERR(this)) {

How do you test your patch set? Do you have tests that exercise
parallel create/lookup/readdir?

It would be irresponsible to merge code without showing that the `alias`
branches have been exercised. Do you have an idea how to do that?

Thanks,
Amir.

