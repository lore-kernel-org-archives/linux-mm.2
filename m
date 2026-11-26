Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA94D606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 05:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jX5gf0s3
Received: by kanga.kvack.org (Postfix)
	id BAF3D6B05B4; Thu, 26 Nov 2026 00:59:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B604A6B05B5; Thu, 26 Nov 2026 00:59:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51A96B05B6; Thu, 26 Nov 2026 00:59:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71CDE6B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:59:36 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3B64A8C26
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:59:35 +0000 (UTC)
X-FDA: 85476218310.10.9824491
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 17AA240006
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:59:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jX5gf0s3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795672774;
	b=JDiIA+gGKvSq/Ndsbt5uM4FBR1TW68xENWAs5rwDQ5SxCN9uLH/Pune+Fcrrop0OXdiB9t
	ZSsRlAENtfDrCXbRd/iqxHqvkOGc0md7g6r6ShQ08Z10gMiU1yLyarrdE6Xy4hMXzTjjIP
	f4NB2QFU9QFLWKhy4uyDSuKOWikuWZk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795672774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VsisjEdAcEQoikyIb1phqdw1n0JZDLyJ/MLeqYyqG0E=;
	b=QK77aOFbSWwnr7BuKGHXJqL83QdLQqko8A05AF4jKR5JgrUe5k0tfAdCA9FvsNoPw6axWi
	/Q6WB8OBUqgGWO0JuTePlFCHVsE7dn1eMS17XH8k2J//A+kAtvczwN2YYPgNKdVVZAY9nH
	48GaR6xRlpdnYYmXeMkMs0FYxp/WNyI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jX5gf0s3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78EEC60F08
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A4B1F000E6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795672772;
	bh=VsisjEdAcEQoikyIb1phqdw1n0JZDLyJ/MLeqYyqG0E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jX5gf0s3CFTwpoga7V0Jihxldl3viYJ63kjPyV3ognxDwWErcdcRKbm3bvkVNtBU2
	 /gBef46Y9q6v5yjRZPQ5ERn7s96pnEvbPHj/hsqaTrZDKdlNtjs/gOGFRJorIPII/H
	 bDslLOelA2fmLqD+NzeCFSf8kKgIx6SCvT2EoImDnO8WdBVabWYTR6y2F6VyiiEzEG
	 wealsmoaZV/QngF7f+H4i4hMppmO1Rh2P8k0w1RBuuNxkQUc3JY6P68T4ZFZeXYM5s
	 xmYP6BvFaraGVv3bDpSb8IAuF9frERxVKFq2lXAXG8hrQVNDyqe3GCwOhmIOvfFLV4
	 6eJDSJLvk/EgA==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c51373ae637so191254666b.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:59:32 -0800 (PST)
X-Gm-Message-State: APuU4Z9NxOLYHvkfy5Zz8X5S3uoa/Wq2NV4VyS1n6P6KRY2kyKTS3tUF
	qU3wEeQTNbQuzTW4+cj2NIH2ncP/ho2X3m+zCkbIRd3cRJveg7YHgZ1QiaQUdN4RbzK/mZjJ3NV
	qmWv9SS6ZcDXNclqMABB2gKvcVdy57ntsNdKUAgBfQQ==
X-Received: by 2002:a17:906:da0e:b0:c46:a72:e0c3 with SMTP id
 a640c23a62f3a-c513a84dd04mr1356707266b.16.1795672771599; Wed, 25 Nov 2026
 21:59:31 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1795439990.git.lianux.mm@gmail.com> <3e8d55101602d5ec982ae636eaf5eb4dcaad3ba8.1795439990.git.lianux.mm@gmail.com>
In-Reply-To: <3e8d55101602d5ec982ae636eaf5eb4dcaad3ba8.1795439990.git.lianux.mm@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 25 Nov 2026 21:59:19 -0800
X-Gmail-Original-Message-ID: <CACePvbWzE6AvbLzNFe=J5Vid8iy6FFQh0RBgr+V_jJJ4p=OEVw@mail.gmail.com>
X-Gm-Features: Aa3M54oIbvTBzc16n1b5zBCTLN35erJwZkNIaRd8dYijTduchcrgfU7gWLxR6Vs
Message-ID: <CACePvbWzE6AvbLzNFe=J5Vid8iy6FFQh0RBgr+V_jJJ4p=OEVw@mail.gmail.com>
Subject: Re: [PATCH v5 02/19] mm/swap: clean up hibernation error handling
To: Lian Wang <lianux.mm@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Jihan LIN <linjh22s@gmail.com>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Thomas Gleixner <tglx@kernel.org>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 17AA240006
X-Stat-Signature: sjodpefcb5nim83wm98hwe7szt78777m
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795672773-608743
X-HE-Meta: U2FsdGVkX19r+KbqPEMAYQuSc0DXMJ5T4bKbQYPaUMNmi/UXkdaHNYgqF+OQdfUV+BhadBxw6FIWUl9TMmyTyWmsU1uDtT2p7ZVeyZRSUE91zLQPI0JshqhTH+QdJOSL1JPCMnrmbkrEVbAhwEjmTs3FllTHsPVhuumZefnV1sX95b7oe3eva/1c3cLGUk1ITtTVQDRULoB840Dq4jKNLuhLchtCpzFgWxB/6tm/kmlEMKrowTBPXTub/eLA+aRCvH07ULq/1PuCxYafMzAI44dhhdvOrO7vyoEO76H2qMar0QAmHhyEs1Tw0culMzd1xDl71+Ce9Er2tuXTwgU+ZyauFl54STixpIrXYqV0KWSGL+HMaKyEJRg7J+/7vhC6FsKR19tu5z0x4hF9Q49tz9gWCPE0vujA1o1gTR9X+wRkmJuc+jlqKhif6K2wO3LYdeeWFH4XHD6O9aGvePsTcOdwzue6bCrebWKs73HBrvfDLTfv0yhgingGiN0q9BtUO29PDWcqKQob41yh1NbeQ/URiG6yD7q7k8GkFcC6xk9U33zLWZuB4poBsykYqP3kfiiz64NpOW0MmZKAnVVHrr72iZxO5CoTZnMJJ3iQ94kdjd6KSb+VuOo3T+kLDzzf9YbxfjEWEVp/cymMANQy2k90/Wr8bBgPJs9HByzMUiTBb8iTz0ccfYshZN1cum5m4lah2XN0lAeBQ6wuMIY4o26R/65xPcGr5vZM1onBadKuNUP7yCyzJNkIOCzhORRjAQCkMyRzpcXGk5eJblCbsXtqK8gAVqPDhNHVHc46lVqfH+2RrKSF8KQujW3d0fx07iFtCf2emFNvoBZV55gNECEq4C8A+hLrBnfI6UBp2KJhzAag+BMLoz2Xw91jsjcIKb+WolL+pwoyENFuFA0MqVaxZRF3W+sKkDyqvy2ozgoTw25PqJhr+y3Bno9BQP9ve8Fa2oUvI2I57wB+ETv
 LC2dvgJy
 sMuFsymsNVqwmDZSbvpeHjlSYAovIlGYol9UvTY8YivDP6laxtxW358nzCUdNHPHwMHU4CoGGrXsbyPOBdgGUXto/1OgXMKdxVbT5iOo0wunEQZc6fBLoUL2sA7h6sEMZP6g1IMRPYUhRKwo1rBhTz8hj3jShiuna3owJjduFdTNW6VjoxIRZPH3eJThItae0ru2rMt7ZeN8anGuPdiX9RCDzGWdgVw5jbUUdZR4vSg0vhr/2oOBWbTOdpVYZ0UnckfPJEFBEXwj+PPfrfNMKjxEIifBiblQvk2g27ZYS8BPlVMPw6zOkjLkavVRWIZFjMzhD2nXRvxD7L2aUiHBX7Pk3uA6oMCeN9mrQgY9Bd3Yye1vRSF2sjg1og2fTm53MF4Irbsd3NE58FqlyPZ8m7KbzkdX+lLNHWdT2M4/6C/dY+aVPyb1R9JqxlA+43STdKL6ZjQGP5CPqLYKNC2UEVb0q/oCG5mlFEyiVFNplQSb6leDahLE7saXjAbZQfW7GF81zGMgP73yuv7gaM4vZqPU3Dz5Px5p33mJSzClKPJgTy+nWBWKvxSSXTJsAtSBNYmL0kV71rJtNTG8hFfg+y+OP7NsnvRkh2g9JEpknmgTCX+jCFGdyVKvztzVMm67x0X+wamiPYgIorjtdm5YmRdnhSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 6:16=E2=80=AFAM Lian Wang <lianux.mm@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> Restructure the error paths in pin_hibernation_swap_type() using a
> goto out pattern to avoid repeated spin_unlock() calls and simplify
> the return flow.  Also simplify unpin_hibernation_swap_type() by
> making the si NULL check inline, and clean up find_first_swap() to
> avoid an early return inside the loop.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>

Acked-by: Chris Li <chrisl@kernel.org>

> ---
>  mm/swapfile.c | 39 +++++++++++++++++----------------------
>  1 file changed, 17 insertions(+), 22 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c06f9f532e74..0ae901296731 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2331,21 +2331,18 @@ static int __find_hibernation_swap_type(dev_t dev=
ice, sector_t offset)
>   */
>  int pin_hibernation_swap_type(dev_t device, sector_t offset)
>  {
> -       int type;
> +       int ret;

Nitpick: Here "ret" only carries error code. Maybe we can call it "err".

>         struct swap_info_struct *si;
>
>         spin_lock(&swap_lock);
> +       ret =3D __find_hibernation_swap_type(device, offset);
> +       if (ret < 0)
> +               goto out;
>
> -       type =3D __find_hibernation_swap_type(device, offset);
> -       if (type < 0) {
> -               spin_unlock(&swap_lock);
> -               return type;
> -       }
> -
> -       si =3D swap_type_to_info(type);
> +       si =3D swap_type_to_info(ret);
>         if (WARN_ON_ONCE(!si)) {
> -               spin_unlock(&swap_lock);
> -               return -ENODEV;
> +               ret =3D -ENODEV;
> +               goto out;
>         }
>
>         /*
> @@ -2354,14 +2351,15 @@ int pin_hibernation_swap_type(dev_t device, secto=
r_t offset)
>          * the same session.
>          */
>         if (WARN_ON_ONCE(si->flags & SWP_HIBERNATION)) {
> -               spin_unlock(&swap_lock);
> -               return -EBUSY;
> +               ret =3D -EBUSY;
> +               goto out;
>         }
>
>         si->flags |=3D SWP_HIBERNATION;
>
> +out:
Nitpick: Maybe "unlock"?

Chris

>         spin_unlock(&swap_lock);
> -       return type;
> +       return ret;
>  }
>
>  /**
> @@ -2441,11 +2439,8 @@ void unpin_hibernation_swap_type(int type)
>
>         spin_lock(&swap_lock);
>         si =3D swap_type_to_info(type);
> -       if (!si) {
> -               spin_unlock(&swap_lock);
> -               return;
> -       }
> -       si->flags &=3D ~SWP_HIBERNATION;
> +       if (si)
> +               si->flags &=3D ~SWP_HIBERNATION;
>         spin_unlock(&swap_lock);
>  }
>
> @@ -2480,7 +2475,7 @@ int find_hibernation_swap_type(dev_t device, sector=
_t offset)
>
>  int find_first_swap(dev_t *device)
>  {
> -       int type;
> +       int type, ret =3D -ENODEV;
>
>         spin_lock(&swap_lock);
>         for (type =3D 0; type < nr_swapfiles; type++) {
> @@ -2489,11 +2484,11 @@ int find_first_swap(dev_t *device)
>                 if (!(sis->flags & SWP_WRITEOK))
>                         continue;
>                 *device =3D sis->bdev->bd_dev;
> -               spin_unlock(&swap_lock);
> -               return type;
> +               ret =3D type;
> +               break;
>         }
>         spin_unlock(&swap_lock);
> -       return -ENODEV;
> +       return ret;
>  }
>
>  /*

