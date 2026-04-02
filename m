Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FB351112246
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 01:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07FA86B0088; Wed,  1 Apr 2026 21:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030486B0089; Wed,  1 Apr 2026 21:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60AE6B008A; Wed,  1 Apr 2026 21:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D72956B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:33:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E224C16EA
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:33:20 +0000 (UTC)
X-FDA: 84611892960.13.10D5982
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id A17D6A0012
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:33:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=k2O90M6Y;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775093598; a=rsa-sha256;
	cv=pass;
	b=cDvgQ1yDHXZj3BQ0QBjOvnaVwEeFSeqVbE12onN9eDXbdDK8OY2i1OboKjbcRj50fSIWc9
	KxsdQGiIYN96VFiLCH9ccd/pXbKVoyPg3q+eDG6n5ZcmhbJ+enkubeNUkP3fU6QBLtR9A3
	JCeX/M/ROEAmZHPSRyoQ5X33qfyYZr8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775093598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=edKahf5UUbO88q7wEt3iOK5tjqiyruS8L1sTpfQLPpo=;
	b=qtAA+XXvTa38s3rD3UThTb83+NphyQadYv7aI0CJr9lFFl2O7egPFlgkNbD+3cJRKWJnIy
	bDyoYl11uGaBUbXLqVsnzFVGzoaIuqJjcjE2wTFxzuOWmldk8OJ5xnVUvQ4SROTiydFoNB
	/q5Wbtz3dswBSAAMJB3z0VQfqjj5g3U=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=k2O90M6Y;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6634bb959a2so496701a12.1
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 18:33:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775093597; cv=none;
        d=google.com; s=arc-20240605;
        b=HWRTMTNkyg67eyJii0hZF5b4IlLpHzrT/KpNJty0FpdMjnGIznhwz0vb55hM/BwwZY
         Lws1Qy53nss2bzOZpzLFF5itbp0Y3JLxdnev0aGh4xlQa2BIzhJQCjTHK9+FVbuCRHeY
         I/IyiXCxTbPpNBPAk60FI74oCDJU1kNxeGnwa5qjYUN6EP0mOnj+TyqGfrgPocvPOlli
         FvmkLC0dGR3+SE/YID1DIDHUweBUsCDeh/SIC7H7DH3O3tXvX33Cd97Cjg51Nqc3ZnU1
         l08s/RbIv5tIyvKZ13+hYgwSRNWtrNPWBDcpfdBFyrNkNT/XJEuXeQdNADJabr78lVP6
         5VPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=edKahf5UUbO88q7wEt3iOK5tjqiyruS8L1sTpfQLPpo=;
        fh=rEg8sXr3a3aungC2yrLD/mcIhbCY1w5OIriRPcsYQxE=;
        b=IzoU/8fdUR7xJtcDVKt5HI4ix+PeI46VoWfuOOKs/VhI/F+aFelFEQQJKc13W6/bsD
         Al1/tTQtGvNhjxKgjUiRAAeil1e5Av1HXqkSv91ztGZfQSCJ5JI0PMzR//o4LFYckWhg
         QbVtRTh4jVFa9opSu1iSELEvJaVB4afHOtIaC6YSg4KBg9+cUlKpRBWg7mzYBtldb1M0
         973nvoKhUc2ymr28mTn6ML7g/ce2X4btscOTp9lMhFVHX2566sDbEfdGyX7dtQQSHtB+
         u7ojifm9jIVnEHBAmhdliyX6GP9/YvvLE1gdoKhJa7JsqgetsCUsNdC/Y73ceYQQfdv2
         KJ9g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1775093597; x=1775698397; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=edKahf5UUbO88q7wEt3iOK5tjqiyruS8L1sTpfQLPpo=;
        b=k2O90M6YRULL+mx4gXpJNTUwU+iAHAEOc4jR1mVxAvQtv2rBNnD3ZnDKGejlFf4h3M
         rqxU7YXcUrGUp3LgPzm4ARGb1flugiJdkGaf+DZ948qn2QFZonSFH5Zg5XvJpjNvj/9M
         BvAv6WY91LzhMaNKX38O8qmnN8figrdA1Y7MqKSATMaEwDUogPVvbL3TTWMftSkG7gJH
         XmvGwT9k0Y7HzZ5u/ewFUV+7fdf8To3PhNUYuSd2qNzBew2QCJ23TdAjF2wJXKqvRuLE
         j0r9dg9n5uzx22gsjQI425NmIxm+w1kiifaeho61TkoDlmCzgUUGSHMlWlm9j4azzPbX
         pQwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775093597; x=1775698397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=edKahf5UUbO88q7wEt3iOK5tjqiyruS8L1sTpfQLPpo=;
        b=GsXPfZnCJxIXKJWZDdgbMqg6DtF4WT7L3tbxpkuStAQwLvT06430qipmweHxt1LQD4
         UJEiXp0S4+V6QY6CLfVFX4BK06Qd1mx4eA2H8GSx2uJosZsO7LMgGtDGOS0E5pAeuNPm
         QL462+v7yOGhPHXP6jQEWvT4nXykSO7ti6Z9CSG1Np/GX40FYS/jxjRodXNzOOcHHMSa
         GiQ8Jn31gXR1GMYMI910C5nDK43z55rZxCIRD3wMI5EYJperjysTx9HyBlBlcKj5Gssf
         pH0xJ+3Jz9PpkRdo3iLQMYH7A69cfozKdWTYHR0fi7EpKYwOInEFnAeHFKyWRy0vw/Co
         r6TA==
X-Forwarded-Encrypted: i=1; AJvYcCW9elt0J8w6IlNpq0RqcNa6xxDTufPw8rkdPz3i041kr6E9w5xxR/g/FD0YIc5IKsPSv7N0+wLUYQ==@kvack.org
X-Gm-Message-State: AOJu0YwYQVIHz/AmZQhmM/Gw/ayTtMOQO2ORjyEq7WNMwxLwtlj3Npz8
	31+Fr3BTD2WLw7/kTm6qNYH/rasNprExKO3pGmKOu50+hllPvvhxW331nu869rOaOyqDxohkJng
	8AObCMB9WZkirlskZvO2pWxD42bPZaI3Rjd7q9JSbhWinQD6sTVa9
X-Gm-Gg: ATEYQzysO30Huh22DYUx8Ibzww7olrGWAk2I5da7X0lCL5WmYzQag3N1KIDg2cqhCq9
	UqiOuUOLgCF1Q7BhoKfaZFVaCM8k7QARTWZ1YDtinVU2LSLcWaCJoaJolnkz+1HagPEA3diOcP/
	eCX5Cr1shRO8ZN4wpR+9+C0os64lEMNkkqcxS2p6cOxuaeMlS6+hKgdS+D1lURLoGn5X17rpf7t
	p67+pTsKF3nDdUMC5RyDGwKtznp+zosvq8ES4ei4FMWUVvv9qWdts93OjEa2S/X3PetpTNtmqwt
	nlwzKabLjmnu5Kn/KBWj1YrcFweNboo55k05yw==
X-Received: by 2002:a05:6402:52cb:b0:66b:f0b3:42b1 with SMTP id
 4fb4d7f45d1cf-66db09e1daemr3014562a12.15.1775093597054; Wed, 01 Apr 2026
 18:33:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260326084727.118437-1-duanchenghao@kylinos.cn> <20260326084727.118437-7-duanchenghao@kylinos.cn>
In-Reply-To: <20260326084727.118437-7-duanchenghao@kylinos.cn>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 1 Apr 2026 21:32:39 -0400
X-Gm-Features: AQROBzCS31uWP5y4CqkTkJfp04_UGwN3CIhXDqOPtQUrKSoDcWS8ICGtvciBwnU
Message-ID: <CA+CK2bA+atHg_Eae7+MO8n99yV2eWvD=mxjReqNUFW=7E-XAbA@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] mm/memfd_luo: remove folio from page cache when
 accounting fails
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: rppt@kernel.org, pratyush@kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, jianghaoran@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A17D6A0012
X-Stat-Signature: eras6cw88bwmffzow9stfg8tbyccwo3u
X-HE-Tag: 1775093598-733329
X-HE-Meta: U2FsdGVkX18o+n/JXLOcyNivf1tt22WmBvEDzfIg+MBhf0V9FYwglQeBIho5kEnD9qtZVGdd+xNMAIDs3NNLw3Bic8KP5a4tPH4h3t1BmVF0+l3LWXvfhwqrLdcgtHUaJdrkkEpTXj0KZWkJ9dDxf8YhtnbB3TYPda20gfGbJNpm+ifJXPQ1njm5p5D9AJBVoFJtXbPlnCg2YTuHa7C8RL66ddrlA6szf9GqNAhiWP0ezvTb/OolUKn9GusGqnmWNMSZ0LeUywlzDffYx+XsxDRg5K2zagbcoL0lj8Exo5cck95hE920be/MZopZb0RozkD+6VRHFpVZmEgBT1WbARln2G0jlns3LTvShyF7Ql8+zEVjrLdENR00ph98s73pk34xQ/YtWewYGPGIWTOq6Y2TD8Wtb3JNMlyflX5f+13PZUVQxsINv7Wjwbxib121Ck+oBdQffoKIS/aTn3B9hn8/SDBRLjQ3v+alw1gPD5dQ/drwp7fOZLhpPgjyEAPT2lkh5Vyj58tt5gEcrF5Dn+tDu/miHjcl1GFoJ7DuTyPP8ANUo9vlPGSpejFDdY2v5JN4qyGIA9JDLwQ8SnXLgxYzhs4wbKgryexECrbhJ7wGIDm5sYAvCIQvuXSwdFzfawavJkCQe9CKvH54tksgBoihbwNcR1p6IcPTpYUhd2FxL2TCt5I6FZD95G5bcfIfqO4feWiIfO+7ZFtQ0/4PNf7zoDaa3NqqXWNGoVMoFuMpH1KRAF1v8eWnzHahahtyh2Z+nJ+1MxrF7oISuMP7WElTXGuEMHu/QRyMJaYEq2IilJZYQ+Z6KWlh0VqAtm0uiZggo2aJlLx30KNJYTLB18kPsO6F+4CrfRqNnM7uB1e1FSKMVIfTBB94cgpQNEf2wmuVNDnDAzAPXeZ1wKF/0xaIrhYRun61JR+xv0VDVKUzyrOUJB17MRi63X0i3S03prrNZF4qJIY82Kwq7yu
 mLBvxNKZ
 sqOHq9d8D8QeCgTl6Rn3QZeC0XQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 4:48=E2=80=AFAM Chenghao Duan <duanchenghao@kylinos=
.cn> wrote:
>
> In memfd_luo_retrieve_folios(), when shmem_inode_acct_blocks() fails
> after successfully adding the folio to the page cache, the code jumps
> to unlock_folio without removing the folio from the page cache.
>
> This leaves the folio permanently abandoned in the page cache:
> - The folio was added via shmem_add_to_page_cache() which set up
>   mapping, index, and incremented nrpages/shmem stats.
> - folio_unlock() and folio_put() do not remove it from the cache.
> - folio_add_lru() was never called, so it cannot be reclaimed.
>
> Fix by adding a remove_from_cache label that calls filemap_remove_folio()
> before unlocking, matching the error handling pattern in
> shmem_alloc_and_add_folio().
>
> This issue was identified by the AI review.
> https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylin=
os.cn
>
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
> ---
>  mm/memfd_luo.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index b4cea3670689..f8e8f99b1848 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -446,7 +446,7 @@ static int memfd_luo_retrieve_folios(struct file *fil=
e,
>                 if (err) {
>                         pr_err("shmem: failed to account folio index %ld(=
%ld pages): %d\n",
>                                i, npages, err);
> -                       goto unlock_folio;
> +                       goto remove_from_cache;
>                 }
>
>                 nr_added_pages +=3D npages;
> @@ -459,6 +459,8 @@ static int memfd_luo_retrieve_folios(struct file *fil=
e,
>
>         return 0;
>
> +remove_from_cache:
> +       filemap_remove_folio(folio);
>  unlock_folio:

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Thanks,
Pasha

