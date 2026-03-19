Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A28E5109024E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E65666B0546; Thu, 19 Mar 2026 12:24:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E15E16B0548; Thu, 19 Mar 2026 12:24:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D049C6B0549; Thu, 19 Mar 2026 12:24:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE8376B0546
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:24:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7CF96C1FD2
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:24:56 +0000 (UTC)
X-FDA: 84563336592.06.C400B8B
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7AAA640006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:24:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="CtAWe/VC";
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773937494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRmUYJQvplrsWyhzINHBTzcIH6dU/MeHfwdfEmtD8K4=;
	b=xy9wG/oMEXVicn30lnkfmm+QPEMVnnqT3/+cEk4muzdd4vrtUNiL0INKDtNQIJz9enMTLs
	RUCBMCnuWhIKoM0ArcAFGTmPXZmtsZmQiqo384c27RZ3/ssIYEGgiWUwPicoxF/YrIMKID
	rvYduJhwFpKma6WtcE4lRN1h9mJ9DTs=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="CtAWe/VC";
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773937494; a=rsa-sha256;
	cv=pass;
	b=qP8ZUvTrVvBFNZugW0oK/LogtQABb+lR1CIsBkd4KZ9zjgF5J5Zn4G88H5oTYvgtUMFHr+
	qMRrtb02yMzQ78mVrV9OtJvyFFjQAM1f60MuwAK7nc8JzVjdV11UMhGBI4o9UntzpPNjza
	rNKmNlA7a0OAKiZtLegGg6O7hVwyibI=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-667952fd262so1922838a12.2
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:24:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773937493; cv=none;
        d=google.com; s=arc-20240605;
        b=U6TXEJutNnF990jbG5NMBkgspQVTrtuGJVii881TAWbFx4g3NK8g+wx0uGGtG1GdKC
         1NGub7xD1fbKj/RuHrwxdrTgBt7cm0ZrhXfub47hwtLqiEobEb97/QJRqIh786jk/l9k
         Od8ZYk4G+zHczpqa/Oll7RDNRd86JsT4WrLOSobvUYsCaWVtQUixrowMpNLI3vpxJZP4
         aJVsgKa+eNRBs3O0bsNmykNqy6G4KCQwDnYN2n/r9YB2fIbm8eAZ8K64H/AtGY86vjw+
         fcrxygvc/u2gKA2M4uiy95vCUm1vbfwFszVzhI/iknRpIL8Jt9+DEeQEinRIamhuVFYS
         v/wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uRmUYJQvplrsWyhzINHBTzcIH6dU/MeHfwdfEmtD8K4=;
        fh=qWce8Go3lJOYk8z23VnqEyg6cuwf6niTIn8+/Cqy1AA=;
        b=l0z6Hbo0Ccgz1tqNj+Ni2CTyrU5ccstXfdnGKxqpaga2G6KHKHH6u3WTepyX8iuAGZ
         KLHbq2ct3+QV16+rJdNCYb/4uh+UEiCk/rW9lEtU42y0GCggm3Rf+7tdlFcPjU76Jaqj
         iEc0IiGLOLj8FA8cI2c8cOJeOXNvjm2TY6p0a3eJRllhp2Iwr80AYDpgIwVPEURdZr6T
         f9SUNM/Vu63GrJreieqpMGCm/arTo+cM04l5rSJ4t5AhWGEeRHMIcK0tFhA8fRIiEf2K
         81IcFVFqsTm4ZFzZiO4LTEBMb72O+FdTiMtm37AVyCkJKA/rO7zUzetI2Qi4nWGxgNFn
         u3HA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773937493; x=1774542293; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uRmUYJQvplrsWyhzINHBTzcIH6dU/MeHfwdfEmtD8K4=;
        b=CtAWe/VCz12yFfeGMdPnynBWq5lA3HQYseXacfscT6vYAMDlBG6+EGQBpiUx2yOMs6
         qZ6jlHJNfvBCR8+NYkGrccPGnqLpu+JkcFrK4Jne70F2BWTktgkT4EQvRon+HV6idbha
         R4HnZZPk5OISBv7Boow3vYZpGaP7G9Qyh+emOr4OOGoxqzcAjaescK/1Ny1R244xtl2u
         FGrZc6CwZDb8vrWBmwE4g5jHfVI3711hA0TeaRL8ENseKkTHZKXBpkwIeguAqYzxMiNe
         PnChBxp6zDEknCvnIRQ3ogarFSnxn+LazPPQzCSGxxXisAOF6AZaUFDEgKSap8K7zkVF
         FsBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773937493; x=1774542293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uRmUYJQvplrsWyhzINHBTzcIH6dU/MeHfwdfEmtD8K4=;
        b=AZxWrmkM/XAcQ7J4Bs8BdX3qf1drknsJHMS0FwqjjX6ciZl9BWUOqETPBzmhGGSiz/
         JDEShJhVP4pu/zqOSEJQfOqAmWEDb9clHSJPUEFng/TZfcSRbBEcz2p2KeRhF0nSHyOq
         w1bUfIJK/hJCnnv6RRfWqAJyirLSdDgg/GxGanKvrgX+BhxmMoEBHneozPWqpyHpHOQZ
         p4cEPNiVAIn6pvkyouCmHbp6jtwF4BTS18xDJP97s1+WBXOY1zxCE+dfzHJ4ryS9PlrZ
         dumdIRYaBTdsVu1Z9ctqQmFeFOryUxxCYg2Ezwr9QAqAFGEZH7bJJPi+teIPD1QTC+jZ
         zC9w==
X-Forwarded-Encrypted: i=1; AJvYcCXJPVOs8aET3/jfQ/sgDsaRrGWAHjMGIl64YHlKPm877VP1geVMcp3K+0UIJKPsRD5N8SpcbiZozg==@kvack.org
X-Gm-Message-State: AOJu0YwRUhJprdBG1lpOQSVHKOOaZyUWGvIAp1jC1xm+uBpf+VuHMg9W
	4v1kJhfOG66smzpZr24xGIXJPtsVPkWnM4I9fqo+XwEYVCPQa9zPX4567HVuFAj+DMogb6JDdks
	xDYwY7HR/LTiNDjdnsxwGRmTxEJPoWaYMXzL23z55+4NFXWgZaP1hdT8=
X-Gm-Gg: ATEYQzy2He8IVCYZYJ8M6fNA+nMu3XxDwBgHMxFAZAIquD1ebzkPOrLMGJZrs17wQjm
	/6CaLrudScgBxW6utgXtOgVVuvAOg087KyEQ5xeW1GEZC8uwuB4JPcGFeODwSOHyYdui43o2pCZ
	MExGhN2E2uqS0Aj6wN2VDEUWgxkEoX+O2cxErmPgbL05rMfFNiMBj/IgDrxs1c7BiMkJAR1w0xi
	QhDq6kz1PHA6nwp7DGumVuhUeBkVX1uZvy1862L7BvoNHlJgxqvxhQ11TSlYOFW6eFCgaIigc2j
	gjOe/RFHVIgkgASwovnLl9MLQq588CtLdNYDxg==
X-Received: by 2002:a05:6402:270e:b0:668:6d06:be00 with SMTP id
 4fb4d7f45d1cf-668c9b25e59mr31958a12.29.1773937492467; Thu, 19 Mar 2026
 09:24:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260319012845.29570-1-duanchenghao@kylinos.cn> <20260319012845.29570-4-duanchenghao@kylinos.cn>
In-Reply-To: <20260319012845.29570-4-duanchenghao@kylinos.cn>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 19 Mar 2026 12:24:15 -0400
X-Gm-Features: AaiRm51oXduFY4BoHVVSFdOsbSa2V52zrw5ohRxFbtdHvoWKheFTFWQioTkLflk
Message-ID: <CA+CK2bD1jk7kHLZeF6n=FrmNJHbntdBA3fHZA2RYBEkBeSW+oA@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] mm/memfd_luo: use i_size_write() to set inode size
 during retrieve
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: rppt@kernel.org, pratyush@kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, jianghaoran@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 7AAA640006
X-Rspamd-Server: rspam08
X-Stat-Signature: jdmehx7coze9omzqn3hqrmifbx6zb31d
X-HE-Tag: 1773937494-240180
X-HE-Meta: U2FsdGVkX18sKV8fRD17H4/5mgw7WEzD46DsTX0ZJT2RQ1N7/50ajgVG7ZHf0bCxwRCG4w8Tv1RaNs0+rMuIq2IrYNJWD+oyLkHIhKwX7oba0p67voZPoXHx0+gvdX1ccVVYac9/X4DNimHARO9hQurc+rJuopcXSNVMqo96OEx3f8Qq2LCuohZZUuue9DTUeGpszdZ8Rk/4niOBKgcFK0F0gdk9yP4bWePydudwlYjIYtYoyEGbmhXLgDbA0IZWmP7V6+NNr0IkPo6ikrm3zhuhKiIjdEgpGGcKBPGZFHe8ssVqI6bnAtf21v43jFh/4H5oMNXbgFynC+RaEf8j9V4WU6i6Ybc49tiIOulUoMf0xbLuUnkuh9E4/++nxiCXWINsMmKnHyO6ZtgPzoCBBZCFFi2rMMQyYkIBH/HU9lyWK7dod9jf4gD7i04nDp9fOEsa/o4Kq+txK1se0YlHEeYfHuhh1AHUui4ma6XNiYKPueToaVbhOQCshuhV6eGObWcNtDKzaxfQ80yCmK+yxiErTKPuIlcHUL1lASjW6UcIGKx13CwNT4R+jDZzWtIuBITEijOu2F5Mg0hqL/NhixCpEHgRKOdQEmz8Pga+l4D9k/3iPqs5nhm21LxcSzHN9gXd/zmfV9L8dVXGcHBCRtkVClbYco4fWE04OFb/UV3wCqNRAMX6bwYZcyQ1eYU8NoVK1KW3uucKnVHv5CFXdRzvJElzbXkrlSKOHzMmVzX6hHqcrOB/C4Vwzh0IWzehcWnWOz1Su1X/YPaMAxNwZSRzEEHKHUMSV6dSGHM1muuLj9YCczYbqVUCXBGxne+lIjuQzaGoWiySSnoCCfNrmb+QhyDPCMLB4zgnj8BNgVhn005w4+eJXj6EBGz97XNVQeFeesqIGU34WEf+jovnG6hGQArL8EFcH4j0H3TpbSUHbuYLmHcSBcAQ8CpX/I1pDWZLK5fVWfFX/ruGIwK
 XDQ6XB5X
 BdhxvGgGRxfAYkYmqkK0hKeVcxgrFiWqu0DnQNLUwWoC/tiItdYD+6jL5K4GbMbXXAR7JFI5IDleIKuX1s1hw9SvYsCoqv0nm529wSySkLIwM/nRUvA558CJ4umqLvXlzCntJxbSB3+597Z2tQssqaogjcSQ6DjL4z3tqzvPsykQEbapfId8XoZlYUUGVQ+vk59S3M1gpKIGUBq7Voj1PhyKjcKJUo5ZI02f+2Olx55r7XRXur0jfSVBQ1MTtKGE7wfSxCgoDn0aCDsBSxOtTIzSGSwz2LAmvczzsDBJdsY9XpLy/CI123SNq1x9wnQtrgzTDpaRJokO1trjkLP1IIL1HZONr/jK0Xu8j75Nnakj3niLKtTGEsIPw02vQ64DdmcCbJcLLvzn1QGHOg7ol17Osvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 9:29=E2=80=AFPM Chenghao Duan <duanchenghao@kylinos=
.cn> wrote:
>
> Use i_size_write() instead of directly assigning to inode->i_size
> when restoring the memfd size in memfd_luo_retrieve().
>
> No functional change intended.
>
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
> ---
>  mm/memfd_luo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 413df8c75c1d..5e5971f25c68 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -500,7 +500,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_=
op_args *args)
>         }
>
>         vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
> -       file->f_inode->i_size =3D ser->size;
> +       i_size_write(file_inode(file), ser->size);

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

I think, smp_store_release() here is not striclty necessary, but makes
sense to use the right function for consistency.

Thanks,
Pasha

