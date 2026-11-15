Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73D41606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XZZ4jS/T
Received: by kanga.kvack.org (Postfix)
	id 8C4846B05C9; Sun, 15 Nov 2026 09:48:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8748B6B05CA; Sun, 15 Nov 2026 09:48:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78AFD6B05CB; Sun, 15 Nov 2026 09:48:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4CECD6B05C9
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:48:55 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3723C120791
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:48:54 +0000 (UTC)
X-FDA: 85437635388.22.1B2F5D8
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 36A3040007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:48:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="XZZ4jS/T";
	spf=pass (imf04.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794754132;
	b=4787CpRxTEROz/o7cz8ERSjgCgukdqgOY4lC9hzofhp/zFkNz9BYijhiiyGRWLQwYKk4aP
	pxX0QazsN7ZjjD127sD8bfUBdRnQj06s8OfWo2UHA7ettvp/tfM4dcwek+5XQZU/W5KKRm
	iEA3CGKQ7zEh6s0tKnSBYU3r2rWtUpI=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="XZZ4jS/T";
	spf=pass (imf04.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794754132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4gZYNSTU3nUDa0BlNRCYypUaVksPX6JgKJOOi2udkU=;
	b=RKgBw9njuqvOuuOpwYWMh/bvqXz3oBtZI2xETc9+/Ls0Mb9q8t3q3xqr/JolnnUckgquzk
	sAYKldPs7y5mEkGsNhSbs71X7AHycXqymnxHhRV0IqrE2HWOoEJkKSYpfEUyhOGSgcxqE1
	L6kwIviX0L83W2qdNJcOBtlDgngoLzM=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b6e7a05225so4030270a12.0
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:48:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794754131; cv=none;
        d=google.com; s=arc-20260327;
        b=G9166B0MY6RDjaLrUZrZDYg7QAwXMtbh28+cFmlG/3KssJ7tWSww1VOJHhsvETmvxL
         GS5cEKmaOsKf19CQs/DczG9VZpna+ldnWIitOKeXfLO7ef3rqPpJSNHsGnCbWqi+k8yK
         SgsTz68xBl97Gr///vT4oabdBptxGPA45aJ2pyoCjCLGAhhlPD82lr7f3DTuY8tb3TIq
         izBedF15PwtVhwKpbIpj4nP45h3V+2CoROEfcsDne/CbfHElOHk+yUsVSApc1dD6RK5G
         CZg21wm6/n9l0yx+qmXiZt7ccjqc18yrUS9wOptMvg6MOMu+kZsQcsjB8z3h50c06K10
         Damw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C4gZYNSTU3nUDa0BlNRCYypUaVksPX6JgKJOOi2udkU=;
        fh=eJnnYEJ0I+J2xhf8G3B/fr/1Bio1eJEWK4gCxc8sZ+c=;
        b=YEq0+ROuWkXqt3Ot6KIf2ITeRBcliF4UrdsH+PA13PaXEij+Mtr5DOAWWPP69RL2Hr
         9kq/gq18HdJ3oGGkkHHAaHKNlGbE2VDSR4KnUw/oRukUlV8bF2TBtbR5qiGP+gFPSu7+
         QNIDQBdLo6Ix4DlqlxSNDNjxBMtFiD1xO+5jKHJwQyOGLbRzLnz/S1Pi9QmZva1sFJ3M
         nu70AsiDn7HfA+DLatHnt87b3JN0yEGJ8Tr6xbqCJ4AjmViI9O6nhf3Q0kM7QN9JKHBY
         uJCXPK7hoJQ17coE1rxmYXOeYkIqyN06pvAmKT/2puwNIKd32BliAHt3St55Z3CTEFDF
         ZL9A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794754131; x=1795358931; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C4gZYNSTU3nUDa0BlNRCYypUaVksPX6JgKJOOi2udkU=;
        b=XZZ4jS/TPEXZ0K89/2DxWr6tQm33zfUzux5FgYydxuuhu9vnIDz3wcCeBqM0nUea/P
         x8xmjYnA7Bs/B43urTISGmFXjcPedOOAgsGMx83mwIiAro9PzsBLDFtALO7qFsREugjf
         x+PvlrkqtNcF+bX9BIAFDsPGg5Ka5PLh3eD7iqlLO+8EmkOBC6BoHVSr7CmT12XJeYbB
         1DnH+w12gZEaqXDFnEbw5eGlWb7+fmTKRdXVLPS21INNU7+CK12TfiG0YqiwFAFEKySq
         Oixau0BFnWHlOmCKVpVcT8SsdaYSWvnNTk6L61D6mO1lREoaDS/kl7qms0uybSDLr2E/
         JzAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794754131; x=1795358931;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C4gZYNSTU3nUDa0BlNRCYypUaVksPX6JgKJOOi2udkU=;
        b=jWJYU+2O7W/1yzwPZd5b7iEHKL6JsOSxs67V4ZWGuNOMFJHYK6J9FIHbyIH0G8ElIl
         Bk1liyBWLJFuTbn+qT2AnxeI5lZfaZGHYRlbcM+h1w9zpGuwIdZiIYQDAFCZ/cpmr7h9
         fMUJaI9t725+XwRIMI/Ez0Rs0gsvmcavyDIoqFLxZ5WEAPYqeU1qkbuHXsj945llA8bK
         aLtFQyIkCzeMNoaTi2vOt+Mn1kf2HBD2IWmgUrpbmfd8EzAtIMqwsylFUpgHLnzI2YW2
         dXghb9lq29fiymr5xeHQobd3+V2ywwgB+WL+mEnEaz9fltjm8FB7AFqlwqY+zx3EX+MA
         9/0Q==
X-Forwarded-Encrypted: i=1; AL+hErEjLWykEEknjJULSjHaZuloyIV1QFwSCLGjamfT2/xX3tsX6TvjGHL0DZtPZcatn5rBLliNnIkJsQ==@kvack.org
X-Gm-Message-State: APuU4Z+jkqaA95RnfS5VUtyg/fKSAHPii/d957URF0bKwbMl+1NIk4n/
	HwP5zxvePzIhdhjsad7xRpvgyeU50d6Bl7VDXARPAYVmPe4P1Faj8c/5VYNdTe0QewX6H2CRb3A
	zYQ7UaAKKIJ/dP42y8w3pGsSi3koJP18=
X-Gm-Gg: AYBFou10RUHMrI5YLt+7z+wh/idD6mqzsUHVYYmotIS2YBatEhIgCkK7BuKabl89ep/
	pylNder15I3/MCY9ZOVn2kPThiZjEvtPWHLRvG0wEYQYAiRqwE1mvdBF0fCifNiuN5CILbEtf3U
	MSDIiMvknSpEGo/f8JoN8T11j7xVac+I5s4CwMSGGH9QfUFOICuATHdRfoe5FuT3FKLd+2XH2HO
	ldZkMgAaJmItRuRkKlYH3o0xQM7JajdEQb+GNK+47yPD0Q06W+QHpEw+WIC5NExkl2dP+7GTHUt
	JRWsSkBJVf5TKyo18CAmgkFElcoo1IBZTCxnH4pgkk3yPjnTk5mNNvd9HiPZqQxfvYxs2XVV+Ob
	+Jo8IteJWWI28HYs6tpM9y8eRv24wgFysJEeBaCv7gXiO6EBDd/QWOV8HnJrToTC2njor+w==
X-Received: by 2002:a05:6402:1944:b0:6b6:edd7:790c with SMTP id
 4fb4d7f45d1cf-6b7c0d2c969mr5932123a12.45.1794754130672; Sun, 15 Nov 2026
 06:48:50 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org> <20261115-work-ovl-d_real-v1-11-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-11-ca155efbcb2e@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 15 Nov 2026 15:48:39 +0100
X-Gm-Features: AclHuK_loWLpZnEsR5-ArAPNE_f3U8cZmm7GbEpqPveHBdFtxvcWfTtvtccYOKk
Message-ID: <CAOQ4uxgiwKsadtv1Me3ZkSsTawjNey3wDDWVAnx6U0+Oe+uoQg@mail.gmail.com>
Subject: Re: [PATCH 11/13] fs: remove d_real_inode()
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Chris Down <chris@chrisdown.name>, 
	Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 36A3040007
X-Stat-Signature: kq4s13kxb5y88jgsw6whofpmrmt988aw
X-Rspam-User: 
X-HE-Tag: 1794754132-81875
X-HE-Meta: U2FsdGVkX1/JkxfkESyl7K9sESi2vKx5BJSrNT0UxstiPb6sOhtfJx0L+JmO0eRk3/QpTe7KfuXhkjTdo4+C01uwPxSH8Xxg662kRoFnEgOUIwUzds7nvcEcQfMGK3dGFafjt65pAZZaO7Ky4XC2nXCsxGVby55b0kAG+f8vbqs/vxB9eGNUNpWD5Nq0QsiqGui9s/EY86a7BmwRVoiVN7kdkyTxdutfpPB8jpWOpx5trA3Gfuf7IhowGvD1dfn0ucjq0rOkwahoAC0QW/BdbyRnDrvNYJzAUsbPA1ZiGHZ94tnImYKS7yjIuubQyIFdC0qvq91bHgvpLO9zBhfpVnIDUoZzJHItdbM3UkU+LSRkQD9ZooyusX3llz/+rLLIUgHF+kcSRhNAfUB0qk/v2yKZwaVGxo7rFdbX3M6H6Rzy8oMGKX4edUaU2uOajC41KO2S4Ot5sTPYED6//3p1j37jqjm5I3cuUHD2ooUk3pJamGNW1Yf9zXys8DwGZh0zTOXiZcZRcfRRR5yDyOp2FsiLv0NMcAfKqHeCMhgSzG8n7dzmbEqBhp/M6xSyqy8cxyY4Qq+WXXdImMK8RN9O1QkJUwSudTADyy5k+crBgHeKXs74950D7Qdbr5EHjdtf4aYoypsFv7JUjWxqfbtUQISAbeCpjjn8m8iV8TuwLkzkbeeu90AvtGqbxVQVd23HjqXc+YmSjI94PVH6nEzU2m7ACzyw7owwprAzpgIDtSZ2APWfeIsAW/kQBCDMst9ItJvR0tJob0l4QqkBVPo2rCGIX4qmGF5N9AAvZnHnOWfXbC2V7neHqJxiXBU08LMo18VAsyPPtFhmGyilBeZMHOgd/+7y0LBQvsLj7nIBkDxN4nwyF2/AS+hNIFaTYdthUHk/KzZ6RlzLYnEOBVmOt48k/s6njTCffIA7pUr9wd2ZSDimv8JueCvxqGF3BD7dQw29s8kcMi7YgqT5DOD
 u/zaJiSF
 qM1aHMPVSaSI0qj4KxxZtP4Q65BdISlS5VeyyUdhOk6B0PixzanUYiU//4XDezyPH7yXcB0eOQr3IhHY6kRaE2vxFgM6MK/zouMSbKwSdSTpmTc6tl2vdUQ11+b8XSGEJFzfBsa2RzPCvoI7cskW2lbJpTnrBaHiJQTB7vjtstsRkBrC+HqoPBz+JrVaCPIjFMqEdJIxhMn35VF5WOvAp+iFqCeK5E2SU0Q0WvKsSnodkPXuNFYvTnSq8t+B6DSiC2dZCeNJAw5cMoQhWvnGb6yHbfWmD87WgExPpT2W57P7gxKNF3RWBL4prBMz4Zvr8p12iAmu7NN4LTuNKpUYtiFn7pv/sRuuyI74bapuqf1To7cMDt2cjQHFF9SYsoKdp1U7CS6l/VbHjQFgnYyuDzJ6nybTu2ApgrYgqCW4LfPxPijEMkbieEH2PsRMXHdHsdWyAI82U91I6dvDg14DhX+tp3rkSvMPd32q9e0oPRaUuB+jLAKuRGuJTEg==
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
> All callers have been converted to d_real_data_inode() or
> d_real_metadata_inode(). Remove d_real_inode() so that any user we
> missed, or one that gets added in another tree, fails to build instead
> of passing an ERR_PTR() from d_real() to d_inode().
>
> Add a porting.rst entry.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  Documentation/filesystems/porting.rst | 10 ++++++++++
>  include/linux/dcache.h                | 13 -------------
>  2 files changed, 10 insertions(+), 13 deletions(-)
>
> diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesy=
stems/porting.rst
> index c38f5df755bb5..28a24b702f2a6 100644
> --- a/Documentation/filesystems/porting.rst
> +++ b/Documentation/filesystems/porting.rst
> @@ -1422,3 +1422,13 @@ helpers take a const struct mnt_idmap *. mnt_idmap=
() and file_mnt_idmap()
>  return one. The idmapping is immutable so nothing should have modified i=
t
>  anyway. References are taken and dropped via mnt_idmap_get() and
>  mnt_idmap_put() as before, both accept a const pointer.
> +
> +---
> +
> +**mandatory**
> +
> +d_real_inode() is gone. d_real() can fail for D_REAL_DATA now and return=
s an
> +ERR_PTR() then, e.g., when overlayfs can't look up the data of a metacop=
y file
> +in a data-only layer. Use d_real_data_inode(), which returns the inode h=
osting
> +the data or an ERR_PTR(), and handle the error. Use d_real_metadata_inod=
e() for
> +the inode hosting the metadata. That one never fails.
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index 5b3b34d271bd0..2b15179e9baf9 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -654,19 +654,6 @@ static inline struct dentry *d_real(struct dentry *d=
entry, enum d_real_type type
>                 return dentry;
>  }
>
> -/**
> - * d_real_inode - Return the real inode hosting the data
> - * @dentry: The dentry to query
> - *
> - * If dentry is on a union/overlay, then return the underlying, real ino=
de.
> - * Otherwise return d_inode().
> - */
> -static inline struct inode *d_real_inode(const struct dentry *dentry)
> -{
> -       /* This usage of d_real() results in const dentry */
> -       return d_inode(d_real((struct dentry *) dentry, D_REAL_DATA));
> -}
> -
>  /**
>   * d_real_data_inode - Return the real inode hosting the data
>   * @dentry: The dentry to query
>
> --
> 2.53.0
>

