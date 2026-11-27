Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA82D606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PHVgZtVZ
Received: by kanga.kvack.org (Postfix)
	id E32B66B05B0; Fri, 27 Nov 2026 17:33:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0A626B05B1; Fri, 27 Nov 2026 17:33:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4ABE6B05B2; Fri, 27 Nov 2026 17:33:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B07256B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:33:36 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2FF6B1A051D
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:33:36 +0000 (UTC)
X-FDA: 85482352032.30.4030953
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9315240009
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:33:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PHVgZtVZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795818814;
	b=cdG953fAwTZ5rQxj4br5h0Z1SKFxKT/YAiIef53FA57EcL1N3C+5AJ2K2heTlPRp5WozJt
	i46/j6VsY5sSBb8X2EnTL6ueROSyhdT6n0/rg12D3LKY0SU3HtNm9AmE8HTTvNbroRhExm
	RL2Sr7RRjkuYR1Ay5MrOVaGJjGtnE5E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795818814;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IVmY0pCpM6LntaMWmUr3NRIGkIMDmQmHgaKoV3DNWuM=;
	b=TldNcGChiMpWc6MZBFBm+5n/v3tAR+/++nWl9BHCwZNkeYObCVrZGlTKhRmGvZLN3fZ32Z
	+oVYoc2wFQQBeCfkITIWSJCxnCmGag580HoziVzfA+HOZLvNniIbnHbEs9R6Y38Fpv1BGj
	1T8FQ2bqHS3zMsr74qNAs+4Ix4LpFSo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PHVgZtVZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C9B4044274;
	Fri, 27 Nov 2026 22:33:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824311F000C1;
	Fri, 27 Nov 2026 22:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795818813;
	bh=IVmY0pCpM6LntaMWmUr3NRIGkIMDmQmHgaKoV3DNWuM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PHVgZtVZXHuord/NHnQH7Ls7JKGChInZ5aFM2i1Dv6Gjslb0wreWcmFAMHixFmiYL
	 l2rCt5+dbyOmrJF1HcI7EmDvoh3lBNDCfiZo4UtLba5tUE5VGFe9bC7U/FKU57GNDr
	 43mgfjxujA5Hm1tMG4xFt/q/8lIAUeU4X+On5d/kV/91YK+R4C6WtlJRFAb3mYZZ20
	 e8Hg9pjM4dPZ6JRq+xen7GrYUf9C48R+NLNPsxYTP05lESlg1ovsE+/8q3UUCgrmP0
	 vv1BOO0htKfdqNkJJhgpcp6Hm22PfrgyskbIHfua2Gvm5M7tzIWgWOBG9di4LmF0+h
	 t1+72JqgEhshg==
Message-ID: <sashiko-outbox-238332@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 2/7] mm/damon/vaddr: use damos->last_applied for
 migrate action
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261127222719.105510-3-sj@kernel.org>
References: <20261127222719.105510-1-sj@kernel.org>
 <20261127222719.105510-3-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 22:33:33 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9315240009
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8ns4gzibteuksmbsf5g5ycj35bsys89e
X-HE-Tag: 1795818814-200215
X-HE-Meta: U2FsdGVkX1+U2BC71NlLt9MpXM9gnww3zMMLrOyvza5OB1GiqNXjFdUUau4LcoWrylp/meqeH5XStcLWo4r0RvpgA6+ONd9VLODHuucXPyLol0/bo8wlXGwXKmBiKMfHRmaZroWgW88RBw3OzKS8T0/Uh5BKWqeXx9ojcFqgrQvx9l/lop47D6e7sqQlNOefVhMQmb/b/oU+x1ug6l4nYVDlj42uT+875x4Gjnwz/SV9+Fb//x+PTjBR9uHHTyCpYlPO/CZ20hYc31cf7YPrqPxusvndBP3QlzjHtNloUsvTwHuX2m1o0Qy/UQNe+V0CWpIu0JTUH0pNm31qzb1g7VSnj5jsnlqhU0yASRq2GHOs0jKhVZR9hmcmMl/GTk90kev7oHT5ceadnU8qQZKt5v7o8rK1tatdUfL0lvAu+xvrjhrSa+wUli2iTw5rxgWSgxVQtA6g+fluOyFZR+TZpSp8ZOBqc6QIK140qVWZyVfb3R8ERr9MG5nhleALOKuCQaBzQgFMIE0GeDsQv0rGWZhMTb5NiLeQq1bO5/CNdpJ9V1GRguhsAGUNANrTvLpEbP9aDQ2UXFagqsHgeisRJjmqSY9l8F3dMQFEg1CucX3MR+nYuR0lifnx/8IEnFLA0TfrhGWj/ZQmWaz1+ZPvY5IE8m/4eFn69nDM+aBj4ogkgui1GlfkFS68hvIFh9HiZh9XmdgIoHv5/0emKQmj+9TWrxuDQlHGABSMHhUeKsClbENLX8xBOEJ0P9mUcB0PYxkNjHw8mOqRjPIhiBNQpDr+8EUQ2r+3xkYq9luxY16jc/xxbR/5Scs9e7ANqHA2gtRDidHTdwcUyv/+1nsz5hUNKTQ/TgdSlkzRJWrGNwrIHP+WN592W+DcuAk0uhhHCm9WaSKnC8k8mxgfZc+dyVKdF2nH/0jb3Kx64TELKdUAIy1FFmU6uZMyOwlqRU8CJDW+wKsTd7VfaE6ENJI
 zccYf52p
 QM3AFfopA2ng6rndlmV5/o8DtfZynLJ9VItKK8Kx6iA3mj3oUue2ZyiFkHLwm6kFxIJ/GrIKw9/U/9HxpaLDV4+9EtWmw5B09Q63IoIJyVlR2ss1sMIugFmQyL5TdUqOyaBKFPtf90WXsc1yIRegrwm384E9CWYI60mSl5Xobjs6y+usTtVsfgvbS3s+MZwERHVJ40Znl6fxnXPJGFsWicHpBtKWDJgHuocHuQ87Q3w0OVW/QRfXrQM3x81E8ayYaKVdTA5lyTO93XWHeEpJiChSoLzroVL6G3pnGDygRhqLSZgO3v8zZmIMUtOzJaac3zOXXOCkmYlVcidUni771SsaongxgNRHnrJ5ccEwDG1VurEipaaZgbIbtDkEQE5+iP+OyAb0vWxr5rC7jSZQyqGk2qg+Caulpi0TF467wR/GqTgNA6UIIfUwHo46bmPvHMKP9XR2dHefKoRz4s+webFbWRTMXfUrTpsgimtN+YN9L+vkamA3X6JJalviweaoLtmf3LlGSMBLiWC8lMu5ptFO63uiKi7J8qo1sWYz+EBkelSAnNbdTqb0Y59EKdVaKJqC2RXHdgoSHOTSFZSlnTN5fwWpE48XJU+ysYiH2U16mobdkgdxe6cY0wHc2rgox7KnZ7fIwEqofloWeVeVu6S0D0dqe+jhRXAwuJUTjoBfo9EycUCQbSSETEyWKtQ/1eIoiC46EgSfVFWrNoIX7quioI7X31HSjrDEI6fSDINloRt6eVuIohmmenH/uxQ3XxMVxsBe9WMO9rdK0dnDWEyOCdt4yCb+zgRuG/vZip3t8hoNvXNF7ftIOS/pfB5HPRx+XjO+fhJ22WgEmdEc8rkPhBMdJq1tiRJtn4C1Z5yKm+iY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/damon/vaddr: NULL folio dereference in
  damos_va_migrate_pmd_entry()
--

commit 28e5ee87b052dd198d574f424c2cf49c18aacf24
Author: SJ Park <sj@kernel.org>

mm/damon/vaddr: use damos->last_applied for migrate action

This commit updates damos_va_migrate_pmd_entry() to track and skip the last
applied folio via damos->last_applied using damos_va_invalid_folio().

> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index ca7ce9bd96e7d..c8f93a19c840e 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c

[ ... ]

> @@ -881,10 +888,11 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, u=
nsigned long addr,
>  		if (pte_none(ptent) || !pte_present(ptent))
>  			continue;
>  		folio =3D vm_normal_folio(walk->vma, addr, ptent);
> -		if (!folio)
> -			continue;
>  		page_idx =3D folio_page_idx(folio, pte_page(ptent));
>  		nr =3D folio_nr_pages(folio) - page_idx;
> +		if (damos_va_invalid_folio(folio, s))
> +			continue;

[Severity: High]
Can this dereference a NULL folio when vm_normal_folio() returns NULL, such
as for the shared zero page or a special PFN mapping?  Removing the !folio
check before folio_page_idx() and folio_nr_pages() passes NULL into
folio_nr_pages() -> folio_test_large() before damos_va_invalid_folio() is
reached.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127222719.1055=
10-1-sj@kernel.org?part=3D2

