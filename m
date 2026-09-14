Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD842C88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 19:09:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C731B6B0095; Mon, 14 Sep 2026 15:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C248A6B0096; Mon, 14 Sep 2026 15:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12326B0098; Mon, 14 Sep 2026 15:09:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AFD96B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:09:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C5791C0A68
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:09:16 +0000 (UTC)
X-FDA: 85213305912.13.B9D3C4A
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf05.hostedemail.com (Postfix) with ESMTP id 22A84100017
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:09:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="fia2zIH/";
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789412954;
	b=uUl0GD+Y18wuNU5DFsV9kynaqQdgjmuehvkWp06LbvZAtYWWdb6uM0kqXKc9ACAJ25sIMw
	OLy/J/OPPaFkJHDcdL2ZjnCDrguyZUEsn7+t1zPfwpa6y2u7FJdPxGhHMw5lNBL7VyX3Fl
	7EFR+4tK9NeZQZJMh5WEF3rAQ08CNC4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="fia2zIH/";
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789412954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X9Fk6EZe650YphioxGOlEW6RVLD4CxMEJ5rvzyR1SRE=;
	b=i+lNnkRjHTW5Clf1ZYfJrHfq7ebjvJZpqFiG9/wadD8eWbepKMJhb391JBXKYDjwoUIOwY
	UZqczxF8OsgAzUO+0ESVS9w2kyXo4HS4QBqCQ3TTH1FmFBKV1vuFET2WjxuaYpRPqs7u8u
	q2zht3uwFC4GESres7GIRMZ98I4qoio=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-53012819c04so457301cf.0
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:09:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789412953; cv=none;
        d=google.com; s=arc-20260327;
        b=QccBHMOESOQInwxA3TFZ1EcBlUb7R3b/0+pJleirvZT5liwfKSZ6D5wo6zIQgFND3c
         skbk94Z/AoMBOuPf65c6qBqHxPIG4LEFFL/19N3KmbLBnx8z9c2gdJz5mUeGsjLM64lJ
         aAFU1LgMg+DcFR7z643BDvI2tNPBU+U8PBqYNhg0jwNk3zlX+A0V8QuhS/oJ50DsQxOE
         ZD+1IBROvRrqzZXcbSi70ZkZuYC1QpFtOVdmmAZi/mHefa5hY54BonYqAMAZUahuj7ID
         3mtMPL64e41jjMAxiMEvP9ZZMDFl/rPiNyUibq0jcVB0B12CSvklTwht9V04Bn7GvZoq
         KocQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X9Fk6EZe650YphioxGOlEW6RVLD4CxMEJ5rvzyR1SRE=;
        fh=69smdmEM8eKyLtschDHOadHUcU7wOMimWbrdlR2/wgk=;
        b=qLv6J6UFy0XUn8PRZ0RgbED3HtTbXlplALz8gOwcMHQK/AvCXw2kqWo81/+epP4cKS
         dsGhqAcKJ9HoFhAnZ2E1G+8Zlcudbno3C8G4NLbxd7SAzkiyRSXhlYrbV66tbTdprCRH
         ZGZcDVXmeaOK/6p3O2beL60S74IG30y8P9uvNX7GvTZioNYeFI7giehUKzSziqYsjr9q
         h1F4roSvh34o62WqLv9To28Jg7sdVWThl/MKKyw/A3CBz0/lqZHKYr1EXOGD7fsKLAgC
         fSbCdO6PJgfD7e67iRLh0xk5W8M2ZAsKCJUpwVjis7pe3ydyozRUNrY8KNVzqelLi50L
         yYfA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789412953; x=1790017753; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X9Fk6EZe650YphioxGOlEW6RVLD4CxMEJ5rvzyR1SRE=;
        b=fia2zIH/K8p/4AE1k3lI+OK6e1fizdKvXpNEdeyx8xZNC22dgRM/BlWqbW3FzEE8CO
         cCsHxTDNU7K6e0QJbGmGn53P/cdWNY+7DdKxHms2XFQun+x6APZ5gi7B3Bi83FCJuXx8
         KctxSoWpQZnOPP8AyzBjTMi3e4kT4iOrtcZthZIzgSpa4okAIZy6eFe4YFWZOpccPvFY
         dPGuO8YvPDxz+DAE34OsD+MrTiHSq869/prfcd5zs6zkqoY+85fjVsb7Dr8GOasAR0V4
         VjEfu/sCmW88W9ZCYKJMcIFzN2l2S7MWiXUjNAtU6+/ALMVWXEfVqlDXQxNbzyCwKtiE
         buGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789412953; x=1790017753;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X9Fk6EZe650YphioxGOlEW6RVLD4CxMEJ5rvzyR1SRE=;
        b=KVPM15VLF3X1Xt9eHt1wgfTuDMNZZFJcoKFubdiY1UqSEEG9bV/q6FPyh1LPSlgNzB
         ztK57WDgmf5cEtkM6V5UbU93j7aE0FACMt5p2Z7NM9SQcKB00jyPSdaA2Hedf9ZMPTym
         8AlgRHFrhd+/zkkruUl5wOTa/+7a1w5sKI3YL8o4x2IyUl/M11bsPdWkaVnTsHY2sZ8F
         QU33UK5gb6U6Bb0YRQ+LFswo+KyAzzuQ9QZLoY6gMyAVn9RGLYYLh9K3Tnx1QqCXZPa6
         l+5q7W2Q+YJvbGlsOCPONM/mI24FbAPdbGqgdE/OpoELX5RhAAC9i/AVQxSXC2S8JpJc
         P20A==
X-Forwarded-Encrypted: i=1; AKwUvBwyDfQqqz2Mqf+23ahsCrp5WxQfgzZ+/FKtLrC4AmIAKz3njpP/Lk/hgYpVMmyuJnC1zWrwYcqlZg==@kvack.org
X-Gm-Message-State: AFuF++meFQ1zs8HbImqAn8QkxDHqgKNdQkZl5ITkG0tVValM/BxRJmf8
	e6FVjzLURnu9YPwPUW/HVXlCyFqIA5sz22FW2SMbd/82WJpCy84qvO+RN7ioTpPGTKdSMi4aFbC
	2euXrizAD04sZ4HiCDYBz0kPKyhnx0cInRcG1uOtE
X-Gm-Gg: AYBFou0CsEZtGffoFqnCrwmR2aa6WCCq4LxY3rlbD5NgXboBYhd6ENeeg3Ub+AtPRGu
	5Z3j8+VonW2jrGdit8VTwNpUBc/qh5GwIdMHq182xpJn+zgnUx0Xslv+Zh6+eM6Y6Y4Tfv/qTW8
	3i7H11rCWXbkQ/iCJRWveNNLFoq6qq3SCkAU4Yxhp3zBLUq/TaWvw4giGMgMVVQNh6FmPQcBKdE
	0cwPhfc+1Mvh5US9YqUeycflC0UgTvL7cmYyy/3R2bKAZtnqT3VF+AEQZMiyfnCQPQh1pyN0orY
	Wjs+DDlB9KiJF0gKu3xv2rlEOfCtxBcVdEOe7yI8jsgdH0BlP8RLAfUY/ptfuEZTky/3UBOESOI
	V235LVxsEVw==
X-Received: by 2002:a05:622a:418b:b0:517:64f6:3365 with SMTP id
 d75a77b69052e-5311a5ed821mr2927741cf.4.1789412952603; Mon, 14 Sep 2026
 12:09:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260914190631.3167420-1-surenb@google.com>
In-Reply-To: <20260914190631.3167420-1-surenb@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 14 Sep 2026 12:09:01 -0700
X-Gm-Features: AcwNN1Xey-KZQBZHhXD7fvjxi8aWlFwRwZWeVWsoawt4J-qoLHi3_pUfiN2HihY
Message-ID: <CAJuCfpE-XqnoR0_vX0tf_PEeFB6vBno=zKLk4-Xg8bAPDDLmJw@mail.gmail.com>
Subject: Re: [PATCH 1/1] proc/task_mmu: remove unnecessary inlines in function definitions
To: akpm@linux-foundation.org
Cc: david@kernel.org, liam@infradead.org, ljs@kernel.org, linux-mm@kvack.org, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 22A84100017
X-Stat-Signature: fam4dh46sthhepbep197hhkoidcxy5k4
X-HE-Tag: 1789412953-855459
X-HE-Meta: U2FsdGVkX189xQ3G1xn3nrjPLdQPdVAjGolL+PjIbx5JDv0/QGxCadebzFTkpIV0ESfLexx+iC3gwdWN6IKzW+xhCyVTKZLn/IfURk/woeKTuSG830LuvrsjXcD4DwrMa6h8O/ptwFS1Kpn2+LLVlgzCwG+rkmV5XsfAzDhw9oPhM+ctapZ9FVa81xfgoB4hTtUhXC5uX+pomzqRL8rQK+lJK9vyYyvHywE5ztFpa/MqE24yp1Bu5EIJoY273szgQk86LLScnD9i37v7CycBeIOqRV8zUvbkH2pEklMDKDYjf2jC+8zt+0DJLDJrgeRf5wQqsdsm5E+oUqpq9gTL8wC3fE/MfbULSDnKVEht8yB9pgYO5GAVNlyKZDwvYSzbPCnHwHksVaMKAZ+WNsPq2jbEsyIgyCLBpBqnfEA/rX6P7uanr+rLLxYc0OpIi4jzH7ovF2Ah+d+/1CQwRsQUnmZVjKsfxnoxTqtjyIgLEagWSLqV2n96O4+marhvS2aZDBcbpChNDbwP9PKqZpDcVLmGKTpH0/ujIh1BbwcWJi0xxvvZPxSZgzdXjZ+it0+xxYyaTbe6LCI17MkLQww9Q9GJg7WKAZe/lJ4dcXppbsUoGnET7iukRApi46utzeWAE9DvSstv2X7SDwK7SieilvjPWDVfCBS/qUzuvJ+hU7vDLtfJK1HT0AhdjYT89kbCleamAsqAbbNTFrF0ZotEcFofySNK3f7Y89LdCUV4XEmUYmBZaFvFQihleDdkDP46pp+UhtPp6gckmobu7s3xHQHUX0CFn444OhN9tpBWS3uLuXoz2b4+UwKVd2B4vmBP+wG6OV0c4+kf5nfGadYZwZWBRBy4OOKPeJupiVPGYQWlQKTuKZWjV2pWUGPYGO+qqG11ju1pntkwU1v4FIMqztSo/30yg9TNp5dxPdxx7pb+MKVtHuD7cK6ZhmCHGWpE6/5YonFPCKyRb0SgZRf
 uHiGB4rI
 uT46s70t/7WAMpCtkpTsd35xoPl8iM3PbDitdl023FAUNwr0iI7g7QLzqCFgzlUjKbJEGovEcJeBsIXqIvXuSUx863RW8Um1M2TYISQDgx8WhqckKJHPZqhvpHo+wcyZUWcNxMRLjtGfCtc8wOKeMVWFWlwxuam2+IxlzNzgB+WR279UWPE2gxLu+QTgKjxm1zYmMWXVrIJml3hacB3jRnwGbL5r83fkcBwQMFHi4P1xS0Ril1PkooMMSustJ9no1I5NMmLTVG7Fc1bkjDYjZ504vASxYidn1SfS7IX16Px1vc9vXISWgRRVZ18JpIAfULjpplPn8EuDfIYVTgYAcgTHp/aJnzVIL+5Bx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 12:06=E2=80=AFPM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> Uninlined drop_rcu() and reacquire_rcu() functions are not used when
> CONFIG_PROC_PAGE_MONITOR=3Dn. Exclure them in this configuration.

s/Exclure/Exclude

Rushing too much...

Andrew, could you please fold this fixup into the patch it fixes
(7edb437cbbfc in the mm-new branch)?
Thanks!

>
> Fixes: 7edb437cbbfc ("proc/task_mmu: remove unnecessary inlines in functi=
on definitions")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202609121422.hkKWuy7K-lkp@i=
ntel.com/
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  fs/proc/task_mmu.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 24425e230895..f8790a7095ff 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -184,6 +184,7 @@ static bool fallback_to_mmap_lock(struct proc_maps_pr=
ivate *priv,
>         return true;
>  }
>
> +#ifdef CONFIG_PROC_PAGE_MONITOR
>  static void drop_rcu(struct proc_maps_private *priv)
>  {
>         if (priv->lock_ctx.mmap_locked)
> @@ -201,6 +202,7 @@ static void reacquire_rcu(struct proc_maps_private *p=
riv)
>         /* Reinitialize the iterator. */
>         vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
>  }
> +#endif
>
>  static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *p=
pos)
>  {
>
> base-commit: baa8de2f3448d1466a888a805c18d01c998fe052
> --
> 2.55.0.1032.g73a4cd73de-goog
>

