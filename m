Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20845C9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 23:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 023C06B0092; Wed, 23 Sep 2026 19:06:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17FC6B0093; Wed, 23 Sep 2026 19:06:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E301E6B0095; Wed, 23 Sep 2026 19:06:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB07F6B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:06:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3CC97C0192
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:06:48 +0000 (UTC)
X-FDA: 85246563696.05.C1CFFDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9032E18000D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:06:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZzuHD4Gf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790204806;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZdmhBqOMuKYNscPsuUbYi6tP3G80UEN5EI2cwEtmR8=;
	b=ow5CrJMZHfPgCMX+t0fbbQQyzc22o/YvbbuHGxVGJUpOjvJGjGmfbTXUuDEY1S+Qj7Ab3X
	+gqbau1F4cZu1arEB1fQHWZR2T3u9RDqD1QmSwHmxa3psdWoJB6si9kOCp899F7PI7NPfF
	ix0BD2xiJJYD10h9QmNF/fj1dFWThk0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZzuHD4Gf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790204806;
	b=ndY4muGZsoaSjv8rkdsDCnIubLnKKDTEyGboD/J4/apLiQOgJdclpxyyst9l4yzaADKtof
	wDYZKRjZ9I+IVyK30kgLwpfOU4YGt0zwh9pAqS1Znorw3EIUzKygnDgCgUC06ayhTceBOh
	ktgQ42KxdXJ+gGFL3TO71dAhtGPLJS4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFEC340758;
	Wed, 23 Sep 2026 23:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E847A1F000FF;
	Wed, 23 Sep 2026 23:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790204805;
	bh=WZdmhBqOMuKYNscPsuUbYi6tP3G80UEN5EI2cwEtmR8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZzuHD4GfgdAkX+OUfQZ6s7tIgAQjGqlqG7OhOna8OhvbMDSeHf6VeKfOHVcSh4/tm
	 8XIBmh7+Vx7lTluK+P8eFyYsACVvqdN4LsDY+JRyF+2WvXMocelVF+MBLGwxj3HUmE
	 tKi+7G74HzQEWKKQQ1Duf93OfrGeAiWU9A2MfKgNPir+AR/wFXQ1mwAF00nZpV7674
	 2tELmsn+Tn/7ooLIyS4NPUHqZwOaHCptdW68CGWV1EWC50i6yX7sjcech7zZY4Onpm
	 UfjrFl+wjzhmL5Kh261xy7QdpWy10OiAZ708xw1p9jqE5xAJ4nCdpAu9KWJry3mpRZ
	 tCaljRNJprcWg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 4/6] mm/memfd_luo: allow preserving a tmpfs mount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Hugh Dickins" <hughd@google.com>, "Mike
 Rapoport" <rppt@kernel.org>, "Pratyush Yadav" <pratyush@kernel.org>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Alexander Graf" <graf@amazon.com>, "David
 Matlack" <dmatlack@google.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260923224408.3745689-5-pratyush@kernel.org>
References: <20260923224408.3745689-1-pratyush@kernel.org>
 <20260923224408.3745689-5-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 23:06:44 +0000
Message-Id: <20260923230644.E847A1F000FF@smtp.kernel.org>
X-Rspamd-Queue-Id: 9032E18000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: g71x6sgywcxgkiofdxr55rydm9mfh4tj
X-HE-Tag: 1790204806-930884
X-HE-Meta: U2FsdGVkX1/21RIuTwCpC3De/TftgMLzVT5gm/QMLO3b2gzchWW56ix6GEYPUzQ4vZ13MRo7STtIfY80m7uGwXgx12z1sNoMHsveccRv4n/MxEcZk1f08hVDMEYOPXEy6k7AwavoWMpf+qD2Uk9jC0kZt2YefK48CAVCc7X3MDi/4orhNG9s9xwJiA/YcFSe0p4oJZsfjos8lL9Mk1ywb7eu52EAKz7e5gCQLgg2cP86bY95Rq2+QtZRB3ki2J1u+2qh/9mzvIa8EQDnKhNgcfOtQedBA4JF1s6Wggj4izMA83rfgS4htEmQS3kSExkgguKn8uAYPaBeE1t8TFw5XiJZ89MTZg04MyLMm6M6bjRHBBcSNBc4b55oPl0YqCfQLQQu6u0ymwJMkXbcKA1rbBksRXq9+Flo5uHnjnWH6hclhH4QWLhtmC4aXfrFyuXvevs7BisbcOazteeLA0PtgkjfW52f6/jzLFmrucBQUMXYdHfflqf+O9An7zKyeaqvkNcZXK5Kgg5VMO/Dhd5S/itpQMyiNLG5bOV39o7YrHcn1DIUtNb/Oq8DqlxKuahz6vJLJHCqw5G0ZZPzSAdD/QdwxVRYeRbetjoDsZcEmaoHcsYQsOGdbVtMzhHkZfC1ilfSTjl8dSFl5t4hXQzclbm+D73fsy90XvS6lpZxKsnaDRmtZ3Dv/HRHrI7uy94T1NzlNhfMrDGQzwo7Vffs6KzKUsJKqllv1dKqBZyNIsAnRmdMSrlDlO+vNAOnAs4K2aGS+7fR5ApcD9MJnitQQd7Vg4jM55jxBcUU9i6zDwoIyPk+8b65TcgEWxWCO0dTnB7sGImrcYAwbay6M0W1ojpRcsfhVqGbxqOqphb5nYZIIFw/MKAUJaYzTYiynFER+J+a/aC6cBKMoAp55ynvDHkilFD0kvyJ5fK/0RaWAE6vZrbbga/IJHvN776+2z+ZRRMjeV2ChVFuqfq2+lP
 nO7YzmPP
 CsFUZdcMvdZ/eL/sVVX3ye4sSZEG9zdnfWrpkf+s0mcib2+YJ5QmHN4SuPZG+ZWjOFXqVBMserta4VF6VrTDbo7L1dQ6jkHjUCDZElRr+s9iXrxTgPOk59D6QBmqoqkYeZvdBCxCeoWME3oVWY8KU4JRsJhO+uHUh01tHBaITa8yI8suVBJ3ck1+GOW2hplZc4GPW/BY2QAPQ4b31fVRMnXM/GRMhySGj9RJNs3kuelMyY1NN0mkeLGSbYLBVYzfpaIsYeMaj6A6yk1KRzeqt3suvknhE2W6pGSpT1zBjrBamJxuDL0tLlQi4MEJbNI8y9AH0BG3H/POJovF+3qMncouko4EOKKdGs79YyV1jbdsoyTRHAex9MwQyfrzpz25Mpw2YgCAR+ic50S4TPNskpZSJQur7SS2h33h7wlsolBY7Qhau27cq8IKrs1SYN2cuO+4Z7O87QaWV2ONugBVyjk8UG9/z6tdqRMJJ7q1sLZjWHP8inxGJ8BVw9fG2eZFw/sBGilTC9IeBk9D/6ht0AGPrFF28R06phQOk+fnxm/VfvN3QX6J/XsTwuqCu1mesTM28G1SVRkkiUPmSQBKnrBzolRJmJqHTQ6IVJgT7km/IqCkew/6KBXXS+4hsSzchprpuxFcfFhLmp88=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] mm: tmpfs LUO drops group quotas due to incomplete USRQUOTA check
- [Medium] mm: TOCTOU race allows unsupported ID mappings and quotas to byp=
ass LUO validation
--

commit 20e62ff0b162f0ffc76cd0d972cc6c760a83d003
Author: Pratyush Yadav (Google) <pratyush@kernel.org>

mm/memfd_luo: allow preserving a tmpfs mount

This commit adds support for preserving a tmpfs mount across a live update.
It preserves the filesystem block limit and root directory mode, while
resetting other options to default, identifying the mount via a file
pointing to it.

> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
[ ... ]
> +static bool tmpfs_luo_mnt_can_preserve(struct liveupdate_file_handler *f=
h,
> +				       struct file *file)
> +{
[ ... ]
> +	/* These features are not supported. */
> +	if (SHMEM_SB(sb)->mpol || sb_has_quota_active(sb, USRQUOTA) ||
> +	    sb_has_encoding(sb) || is_idmapped_mnt(mnt))
> +		return false;

[Severity: Medium]
Does this condition improperly accept tmpfs mounts with group or project
quotas active?=20

The check only tests for USRQUOTA, which means mounts with grpquota or=20
prjquota will bypass this rejection and their quota state will be silently
lost across kexec.=20

Should this use sb_any_quota_loaded(sb) to properly detect all quota types?

[ ... ]
> +static int tmpfs_luo_mnt_freeze(struct liveupdate_file_op_args *args)
> +{
> +	struct super_block *sb =3D args->file->f_path.mnt->mnt_sb;
> +	struct shmem_sb_info *sbinfo =3D SHMEM_SB(sb);
> +	struct tmpfs_luo_mnt_ser *ser;
> +
> +	/*
> +	 * A remount can install a memory policy after can_preserve() accepted
> +	 * the mount.
> +	 */
> +	if (sbinfo->mpol)
> +		return -EOPNOTSUPP;

[Severity: Medium]
Does this leave a TOCTOU window for ID mappings and quotas?=20

While mpol is re-validated here to handle concurrent remounts, checks for
is_idmapped_mnt() and quotas are missing. If a user concurrently adds an ID
mapping via mount_setattr() or enables quotas via remount after the
tmpfs_luo_mnt_can_preserve() check passes, those unsupported properties will
bypass validation and be silently dropped across kexec.

Should this re-validate the ID mapping and quota state as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923224408.3745=
689-1-pratyush@kernel.org?part=3D4

