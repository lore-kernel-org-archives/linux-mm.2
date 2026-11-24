Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D11ED606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cIkS9woo
Received: by kanga.kvack.org (Postfix)
	id E32466B08A1; Tue, 24 Nov 2026 18:09:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE34A6B08A3; Tue, 24 Nov 2026 18:09:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D20546B08A4; Tue, 24 Nov 2026 18:09:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE4656B08A1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:09:24 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C7E5140D72
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:09:24 +0000 (UTC)
X-FDA: 85471555848.11.F9ED1B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7614940002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:09:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cIkS9woo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795561762;
	b=cKDIVkbvfaLRsHpXSd8MZPz6g09AGr5LAod7gQxD9hxGQZGTBetcUapybsGLokzBG4TOQg
	zmt46Dt6nRhwEM6gSqglqEhST1REq2CL222iv1H2F7S2kGD+vwEhPbWul+jAOkS8KRupCj
	yqsfOzEzrchqLNorStq8UEcpTb4Lklw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795561762;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V2OmqIyRYNn84fTcJ7B76gimFKbuWcXbIw+xjPcSzkA=;
	b=gpbSBkTdvJ8SGsHiizp0A7PfBglxqgNLFX+PePWPt2uuFeRoSFp+5FobbJHnBP2ThEufby
	ue497cxJuQDMahh29L4f+E4y8lirIwoTMlFXwYUUmYDg7inNOAZNCcfhYRcDwNjJ3TUVUt
	hi5dK7e/GClnxANskGoXaVAox7Jo5Uk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cIkS9woo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 148A4400CF;
	Tue, 24 Nov 2026 23:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3601F000C0;
	Tue, 24 Nov 2026 23:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795561761;
	bh=V2OmqIyRYNn84fTcJ7B76gimFKbuWcXbIw+xjPcSzkA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cIkS9wooJ7ryPDd26vHC20ZQO3Zxtf7rslQEkHJ0huW94PgSBPlsm+VyL2xH6uOOS
	 NTSb/OxkWuteyzM3VHtDUuv2F3lvni1lP8dAafx1caQsoOshGwiSpQLFB8dg2f+OKp
	 OLWu+kzZv1jW+JToXxr6un6lL2zluzmSel+vueb2JaA7IxqNqHIEM6WSR09t/7X3Co
	 m71At3Z+MPGdE84VIuQw0QHM6DoAisaW/V92zsAjnhqB9RPDa1WXZOfEnyTWdyE39L
	 ES/JAyWdJJA10/OhROMGYeAhaS/Z37rjyD1qgtLTdNEoGxBjeHQA3+5eswrsji95XN
	 hDJnULqenHi2g==
Message-ID: <sashiko-outbox-232207@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 17/19] proc: look up map_files vma without
 exec_update_lock held
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jann Horn" <jannh@google.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Arnaldo Carvalho de
 Melo" <acme@kernel.org>, linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, selinux@vger.kernel.org, "Kees
 Cook" <kees@kernel.org>, linux-mm@kvack.org, linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, "David
 Hildenbrand" <david@kernel.org>
In-Reply-To: <20261124-work-exec-update_lock-v1-17-e489035395b8@kernel.org>
References: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
 <20261124-work-exec-update_lock-v1-17-e489035395b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 23:09:19 +0000
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: mk1ifwxu8kkc4hnmhki9koe7gf4phhei
X-Rspamd-Queue-Id: 7614940002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795561762-599516
X-HE-Meta: U2FsdGVkX19VWDEdo/v8cAmgKPkrLy4Dybi2KgIbzhCyKKWz1Ap2mKBp3MhPED2XJNJaSt2F44crNsc1a0lyXfty9YlqEqaLhhaaj0zie3rYZTdj8K+aOPbbVWT4fRxtaUx3DwqBvR3XtbhdZoIccxUQTIgOybhPb/hHzFxBnyHaMiJTZq6FZJdMD42oZAWUSzK1j6C71X23fKKkArDnhg1AfMWmnGzzD5hqaS5KOoCLFq6v12FKC8jiQ85AOisR4DLcks8Lt3dwqT6QdVard4EGvRGEtjpiZ2s9iYEmzOFvY4DiE4vIt8U9MOfTo2rV0GKLrBNirJ3iM6l908GEzTgTXE19FEwkqkfR9NE7ObiS80omwhRYDfpyP5GysjGl6t7j5K3SVcLIBvGwPUUvCcXXbLQ69KBlhHFa5rcxg5G3imVhDGOlr1YSkivSgOMD4LV4wLZ0QBV5VH9AMJwlCPDURt8Zbh/1naeW5iRvk8uJVWAWP5P9TvXjf/DEPmZbKcDopEoFa8/G4heLMBwnzDgLvGpTsX61aSabo3SGP1b1kLUILCf3AKhuI+i/rmW33DcXPaio1YG916p4eRXEGS5ZsdFxemlGMn9Xb1j+thJyPqzNbH9Ka+agXs2fiRBEAQpxoV3yPSnsIAmHryDUoe+4x8l44SpGE6fPFGy/Inn4Gg+07COjeCjd6X8dtv7yhz5c/yWYC8e7q81NzvcbDNK7f/2tDqygN6DVwgRGY91rWw7bzkSyks5iXebWEJwDRk6mn0F4+uGZxJnkw3mArNq7zWz4DfW6c491VbItpKKu+rX1wkt8RbCqP+7SC1601SOFUewoOSkTrfYS3pVFJx+0SEpTfVdnwMB1nBbggtZ1jB7/M17t4+P5dY7Ixx7yT8MeSoPSf2Puc0hXFcVPvXIJ0tOsczMzc4g/fAx3Pq6o/CHKlKWl7ZbXPQhTLiOwT3dRp+ijpP1BFL4U0bA
 jX6G1rKP
 kkhJNBHtbBAEJGjmSa7IgUFTooIcNprqoz7j6PiJheyvx/E86nY9dEzEhiAI0k/vHsw9GsWe29KteSp1Yrm3esgL9WoIVvvZfGp46+6e/lIQcleqceaXiUJnWkXii2s1WCp4R2FVyq2xpAHowBEzs9E8x2pnaPg9vSeZq8GlyESi79aIYH76EfUvRZjEvfFkCxKeFVedj5OH3hvhIHmpbEqFqM6h3uc8tdk1jL2TmmygiZqMridQfi8+pBubGBPcSpq1/qy0XTf+ri3gJdQ9Dck+QRT+3I/sxwe5fZxwSGUdNICzSMYClZ/ZoNuuO/HQ17zLhyEYVHGjg23VX+dlBFZS2seFcZwPnVDf3JRRNEf98INf1yyDmG0nCOVkOJqtiKkpLbnby1i/2e3NumQKRpWTS1bbM6zLOwPIDLwbOrh0masLjV3r2UpzEKwceogIdYHOpuAJHJG4wBYt9cUngmb3JMLuh6FI6Jh6NhZWzlhuZp7Lk1KnujpP6BDWmEnuS508BFLiyeNbNOMElm6Uphq5s36le7Zm5ZI3FyRZLL+tyP2joO94VFZ6dVd0vohMEUmM8x7de9mPyze2tRdmHAHmZ872EgadW/NqsRt9bgiKrK3pJkg7Gz7kPTTX2E4u7fWfB9QW1PyKB7BwTeDB5pLsO4e7Ksq9h8vOEWmHj2FLDMCqzmQTdMYidL1pXjPmhgIeemEsaLgPjE+qabKQf58J5QEax8Yt1NhE1HMoz03y229kMGPIxNUQkBWd+WNgO15zbSUfBlJzxF7YqBtgKBuTPjVMwX5ncRR2bk1AVBfyBarR+tMYJHgt86szMetqhtUjp/13ZOLPYINJBljRxIkePa2mMrNkESGQ6kuQ6OIp6vaY=
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
- [Low] proc: separate __free() declaration and initialization in
  map_files_mm()
--

commit 6e8b44b478838f53cfc44f13f68cf03b45a869ce
Author: Christian Brauner <brauner@kernel.org>

proc: look up map_files vma without exec_update_lock held

This commit restricts holding exec_update_lock during /proc/<pid>/map_files
symlink resolution to the access check and mm pinning in map_files_mm(),
performing the VMA lookup after releasing the lock.

> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 7685660c36241..b28bd6c57e1d8 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2228,18 +2228,40 @@ static const struct dentry_operations tid_map_fil=
es_dentry_operations =3D {
>  	.d_delete	=3D pid_delete_dentry,
>  };
> =20
> -static int map_files_get_link(struct dentry *dentry, struct path *path,
> -			      struct task_struct *task)
> +/* Check the access and pin the mm with exec_update_lock held. */
> +static struct mm_struct *map_files_mm(struct inode *inode)
> +{
> +	struct task_struct *task __free(put_task) =3D NULL;
> +	struct mm_struct *mm;
> +	int err;
> +
> +	task =3D get_proc_task(inode);

[Severity: Low]
This isn't a bug, but per the cleanup.h convention, task can be defined
and initialized with get_proc_task(inode) in a single statement rather
than being initialized to NULL and assigned right after.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124-work-exec-=
update_lock-v1-0-e489035395b8@kernel.org?part=3D17

