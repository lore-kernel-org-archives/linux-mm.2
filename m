Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6524606A8AC
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 17:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hmDKsv1c
Received: by kanga.kvack.org (Postfix)
	id E443C6B05B0; Mon, 16 Nov 2026 12:37:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF4396B05B1; Mon, 16 Nov 2026 12:37:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE3A06B05B2; Mon, 16 Nov 2026 12:37:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9ADF16B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:37:31 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A68E1C21F9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:37:31 +0000 (UTC)
X-FDA: 85441689102.25.E385209
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2CA8EC0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:37:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hmDKsv1c;
	spf=pass (imf10.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794850649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
	b=Ql2kqxAdEq8SYVS3icD3+Yvj8OzdfFCbdU99X9SECjYzOHL4rH3spFdYBwGd0oR/MpBtsJ
	jqmHTS/svOKwoKEi2C9vK1IfNJz1HyLvrNj7SNsadKh6WVQHgB24Cn+ZaO0zNRCQKVLgVT
	ZQa3NxhJhdWzDcfbKYRadsvrEmeiOwA=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hmDKsv1c;
	spf=pass (imf10.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794850649;
	b=yCtFNYQ8FijJbnTFSQSD3cb9GvHpAlBBGfGp9g6TZDgt9xlQT1gssc22YxRkqmCqYxf/MJ
	HcSjZ93SODEex4p3tWmfapKKCML/JFA3u9f//KjuJ8vbUvFwZOodz3pTSD/sEZqHxSzj4E
	SLgZNMDrpwoUTZ1Htow4W1cPEQSUX2Y=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b70192ebceso151580a12.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:37:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794850648; cv=none;
        d=google.com; s=arc-20260327;
        b=kMhtFj6akV7HDnJbkbK0vP7CemcGhoO9qsvXWNilo4PaQ5cHrTbGrPU2GrWNgVzWV8
         Wd17f+Wbk/7LM434gGKdvVXPrDugyeQYo6LEVOMs+OH2Z3JJZB+xACLW2mzNlhNUfAFS
         qzteYV0L/G9LWlW78TkVwbYHYqLX1xb77FMrgPLYefrHqUQ6gfnwYOBwV/Wz9iU+EzaX
         Yiwo4KjuJIDVKnQyLEDAlL8zzTGD0ePuU6/WnwWedso9WSJWmoSJST5Hrq3ANoODlPcL
         8rnkkfTrO/vYHakgcYCBsW4FJcJg6YA8cdk5h9W2KLOVh/D4i3Ea9/h+fYYipj2MKTMq
         8IhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
        fh=1zSIPmgbAeTo7EPMokXbYlMncrFJCMCkYSmE56vFopo=;
        b=k71r3PL473cRu1H70d35PWEkKOCODG0r917RsKEQ6UgB+S7Nd4CnGmoKYbVaP0Ni5w
         GvzdDNBJxCJnlJWe02RGL77/ZqBopB/Uwep4AOjB2vE4JZy/ndL/YoiWrgrn31UeBfN0
         d57C0dkYliLIgbdGqnQmormUhVb+r1Ee/KPjzm3/6XfbUi/BiNNId53LbKqfA3LKWtbz
         6qNq/akH7hvMyEw3KfSzFrp5uzN5eSHoZnaURumzfDYi9Rui4ANrYuFZeVcX2c2Uohx9
         I6URlvtY1cvsp90Po2N6PUB+icTLGDKFAd96dP6mQcfDzw9XcGrJQRDVkaijA5WNAf4M
         xY0Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794850648; x=1795455448; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
        b=hmDKsv1cjekQJOGHm7QZJoqaK4FtLJGugQxnVWwE5mMKeMUEJdh7uIqFc045goBE+y
         NMMzc5Jpj+WOMRgEgdruqVDF9l+tHDwxAklQqL4h7Mk6SSFPe3+Bd94/aen0WZe19XKK
         hz/qFstPP521mvf3RpvuKQ+MpiKn5SWkIClRtNCTRlzmsHX4QXOu60VFJaI2I0sU1NvM
         54zgsQ6eJI2qljTftlIN985Vhkwdq2UhvDVG8sbbYt2gfhY5mdFGaTOPS4ot6GfhQyji
         XDHEAVdGXy+aAFHLK4Sr0J4mMVpv44FKwbt6VL21ZPXV41nNVPUZXEWyjc6bEt2rWMYk
         ZFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794850648; x=1795455448;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
        b=H93hf+Xy3b7FcYH7y/R408v16Qs0nKc/DWvsZ3CS0E2A4efORWqlCAQha53jyQqcLL
         7sLOgYa/YlY2dzj/j3guH3S3PWBOGdD/rjrpdCueBX1qxT+pb2sGJEX6JrWTntB1/fRy
         EbahNTxZrbSpWZItXaw8OTeDnoiNopn8eOM1wHaYAVVfQtbL340Qeb0ZHIXfA8aS773t
         3b3snX4RaQ/nvEvTFTfrdKXo0836M31646ZPiiX6vMcIQQ9Y5AX7VE92NddeR6RaeTCi
         4KTVj8ygSEgffORKlUkSeCf2ikD8eTuFCE6jvKIzgwhbVQlMxMmHbPDYwXJXH4j3Cf8N
         wOVA==
X-Forwarded-Encrypted: i=1; AL+hErEhnRUC6HPG9p/ykyxITcLYYJfXuBvVyw+LHwCesKiix9LeTkQrlEHLS8+bYv5Vd22sPAqHeIOKrg==@kvack.org
X-Gm-Message-State: APuU4Z8yRZsdg0BgiqeqLJRipFo7sX8BlNaWLMp5h86IUsM5HI37S0ec
	N3IxbdZ/3PMp00iBYcr2qo8Z5Jo6ZlZ1AzQ1sShwlwlDouVTHXaJOIx4cYC6vUBEYS6mJi9vIIB
	oqm3bcqb9cg9t23nmuZo1bDnWu+t2ujI=
X-Gm-Gg: AYBFou0N0quBe3iN02iO7fEYl0TmB5KjyXDx3BTF0uvgHpWQIsilToEcDN+MG4Qapj0
	yyy0n+u5KQzNvVNeAkR0QzpYjPPo4yMa2dO3Hikpq/XwGoQjLrCO6yv8FQEjSoz7IKNx5IaAjWv
	W+zVFmXDyGQ4ZucR0cbI8kubVRBCx2MsXHv6tjxz9ZNNpNF2fS/+syIEt7YS/kFQwKopfEuYjIY
	d6JkaVELCvJa3jwCqCsqeLPUvhUhHgIA5dr33koV4Y+rDUxTAr0RyWQu2XFX/w09kTCkoREpSVR
	fS2DJO0LSAoXv6W7XFyn9oEgDu1vL36zQylLaPOl3V7zPn2srkndp7VCGW93RhAQUq7b1tQRolA
	USLmvGQXz6/1guZxeTTkLnCacx+yBDOMeGl9FjEDY73Iwu2WaPw7ykg/ItG3sGev2YhAa0A==
X-Received: by 2002:a05:6402:1598:b0:6b5:7250:d621 with SMTP id
 4fb4d7f45d1cf-6b859ae1a00mr134291a12.15.1794850647426; Mon, 16 Nov 2026
 09:37:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-33-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-33-8cbbea1cf34f@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 16 Nov 2026 18:37:16 +0100
X-Gm-Features: AclHuK_sKnxFPAK3k65pZhjyZC94SJD4eZ9z2j_P12s3kyb9TMw6hurQcjyq55Q
Message-ID: <CAOQ4uxgPerkkG4ie0SyHVXaBD9VZN2wYfQpEAEi4hytn=ara3A@mail.gmail.com>
Subject: Re: [PATCH RFC v3 33/44] ovl: refuse data-only layers on pseudo filesystems
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2CA8EC0006
X-Rspam-User: 
X-Stat-Signature: j7gomy53sfur56frmnx7z9rzg4jbszns
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794850649-437759
X-HE-Meta: U2FsdGVkX19KqN0ZfCOd7rZ0ZlKLxW5oa3TUXA763UH9ggtlMY6km45NWTUlJ1UhjCX2mmM227LX2IXH5XWhRnHXNPuyJiEqNTXjGamU74huBUAVETwO7sITuzQ2XB2EJjAg4X8o3xEmFdCpxScJnLOMyDBwStIDO7rugwgbVAo+w+YiX6ydR4Y2lTvOii4bu+vD3TViT96aFvDxhJWHAsrGm6+CFBC9Lc/cylUkC/nroNKDi51USjL4YhMHRt+qCxhdAO0RGPv6xldv17x4JIm15Ad4nJZfm1T0WMPj4ZEzV7REjnbIzKMXWmF6c5zHMcsQzcnYuoSA5Z3FPb6cX1TtuNkL2oPExgWURGvCig0jnAeP4t7un3Hh3tj5Ei5xjlmz7mPIGb5D9VbJ0eF7AoNPd6HNesyh3RjX/SvjDPw8q6UBIhB+ClSguINkPiNEIaVrsb/S2x3dv90ChrmJVmrrMDq0pZjo3zyZyN65ky8SCAwpkFHUD6uo3Lt2MrDWk7Eg3DGPT85yQdcEWpE4KXa+1ZPgj8vA1wn1uQLcTIn2k1PyfztogAPmELZF/2QkXkDkzZOiuapI35ibj0UUx0arD/Fn9/fVpN9h8DcN3nLAS18kZgKSEUlRD54B3zlBfq0CIwvAI5CQlBP+1TZVbsLF2wlnwdWf/qRl29DPgMAHmicWlRzlhuqUy4ALVth99twM+iaSiEPwaO9d1czOgI8Vs4sTnd0n+obTe74mP9hOAR8HCyQW2RL5pJJAU8YT7wn+bOEOktAoJJ+6YRwWt9VIBHqos+Jfc0smD9GhcbPiotqUfPTVnzX+TP2aLC3rGgGv2P6aRewUCf21EBijp0yAP2LjPRacU9ntu43zmBQ7JG9O6TEMmpL4wuv9bYsMIAkJ2VuKUk4yrNX9tcBRTAzhFqmb3crP23R0Ev3vKU9d8YF0R+qzPewfGGAudI4tNfVaWkT0YvhXykziAUO
 FNRfu6/4
 MhcR0gmspAy8EhB5l05hSpw8X1aLwqMtKB5tvbLtR1pMgCRuB/vZ8MrPo5Bza+D/PVF+9gGnfnIkDWYEOCqnacxlqgX4ifTkry9bZLKmgqt2DVJiZb7DSz3egpV41tVtQCR/RoqABv721DHAUj0Axy3BF8WXLDh+waVw8owifluNVhXWRP3q7LaVJ0gQ3jlKLPb4dCIdjad8NL5qTOFS4zXATidM1mH8JfwOlx0ULhZrcQWZ7ewrkZ1fYmeo1+BXV7G1TS4lduTKsVl2N+8WtHBZyMGebqgMn3lcCw10al6HzKgtnPnugNZJaO4h4K/3gmhMCEOGHOJh6WJjSy5hOwCLQVVp7AKsxaDDHs8lfyt0kcpxkCBQp/Wh34zyi5hGmLEpqMKONtOBgdV52p8BtU9S5fzPUu2f6c5yuYqPlm2yWIoOLgVhe0pl5OMruhRHAHQvW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 12:10=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
>
> The data of a metacopy file can live in a data-only layer. overlayfs
> doesn't look that data up when it looks up the file. It only remembers
> the absolute redirect and looks up the data lazily the first time
> someone needs it. So until then nothing can tell which filesystem holds
> the data of such a file.
>
> But a data-only layer has no business being a pseudo filesystem in the
> first place. All it does is hold the data of metacopy files and the
> regular files of a pseudo filesystem are kernel interfaces, not storage.
> So let's refuse data-only layers on superblocks with SB_I_PSEUDO at
> mount time.
>
> Data-only layers can be added via the "::" separator in "lowerdir=3D" and
> via "datadir+" by path or by file descriptor. All of them end up at the
> end of ctx->lower. So a single check in ovl_get_lowerstack() covers all
> of them.
>
> Note that regular lower layers on pseudo filesystems are left alone.
> Stacking overlayfs on top of sysfs keeps working.
>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo=
91QjJHH9T_Yw@mail.gmail.com
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/overlayfs/super.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 39d4d57dec230..719c2569dfeaf 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1237,6 +1237,14 @@ static struct ovl_entry *ovl_get_lowerstack(struct=
 super_block *sb,
>         for (i =3D 0; i < ctx->nr; i++) {
>                 l =3D &ctx->lower[i];
>
> +               /* Pseudo filesystems don't hold data for metacopy files.=
 */
> +               if (i >=3D ctx->nr - ctx->nr_data &&
> +                   (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
> +                       pr_err("filesystem on %s not supported as data-on=
ly layer\n",
> +                              l->name);
> +                       return ERR_PTR(-EINVAL);
> +               }
> +

How about we make this just a tad more restrictive:

                /* Pseudo filesystems don't belong in composefs setup */
                if (ctx->nr_data &&
                    (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
                        pr_err("filesystem on %s not supported along
with data-only layers\n",
                               l->name);
                        return ERR_PTR(-EINVAL);
                }

I could send this as followup patch, but since this version is simpler
there is no real reason to have the intermediate "only ban datadir" step.

Only the commit message needs a little more flexing to justify this.

Thanks,
Amir.

