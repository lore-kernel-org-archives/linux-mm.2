Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9687606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DVXODAiS
Received: by kanga.kvack.org (Postfix)
	id E15DB6B05B1; Wed, 11 Nov 2026 12:01:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEDA26B05B2; Wed, 11 Nov 2026 12:01:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2B276B05B3; Wed, 11 Nov 2026 12:01:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CCD26B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:01:45 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0124FA7D01
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:01:44 +0000 (UTC)
X-FDA: 85423454970.05.9940192
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 29C1D40018
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:01:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DVXODAiS;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794416503;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WrcDy28YbfZYO3Oal3iD+jm+ZvY4fl072r07q+A2XlU=;
	b=r9ZNyhjMbLIJQINDgCxvfsweKrS9PmfwpTWSMf66HF/jkcZx7wLpNYMFvsxKuAUwdu/mEa
	s1w1AvgThHim0LYn0usVrgOb1N4tWIKTUk8HhXbvDLK/BbSDWQI1VW3boyxGwknveCOpze
	TXII6GDEm1EH2SuBO8wmkze0n1a1bFE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794416503;
	b=owAnNb7DiYuduct3LsufJIm8qKVPvjhgFA2URnq8O3TcAMbRDlSKhzQ/4fERcsD4E/zEJQ
	iUPeIuEPzgbHQ0czzv+I+LSdb/TlaB18+mpCn7RYchjn2bi9ZeqTCfxaGszvqV4Ytj+RUK
	gJYavp/oml1/W5tqfUU2Lg3OrqAvYUw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DVXODAiS;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D8768402FD;
	Wed, 11 Nov 2026 17:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614551F00A05;
	Wed, 11 Nov 2026 17:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794416501;
	bh=WrcDy28YbfZYO3Oal3iD+jm+ZvY4fl072r07q+A2XlU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DVXODAiSYvOmzdTU1jqLvA22AuMkDnVZjCGszn2vxsgAPgWqvvQkrXNy4h56Zfe8O
	 086kMvb5dL29utxA49xaQ9nAMQo6a7K2sB7m74QdUll3US9b2fqqNZu6iUgoNcS3xs
	 P4da6YGgsgI4qwQaqV3ZeylcuGQ/n9AQQz9dnm1ltIhKaOH+uUJ/fTLF9A8KEJf9Rb
	 w6XO06hELVf8uPNtG4pe5d9U+BhdWcjlIeaeRArspfaRrNFQqn2D01mHFUNEVeg41W
	 V+IsVGdNKYXYuZc4PCDeGZmzcV0F7F2BLwTi5DyDKCDj0BIdipxXzOQ5qFevsvJ7yT
	 wbrBoSSmZOrxQ==
Message-ID: <sashiko-outbox-209359@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] mm: only assert VMA locks if CONFIG_DEBUG_VM is set
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Suren Baghdasaryan" <surenb@google.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Shakeel
 Butt" <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
In-Reply-To: <20261110-tame-vma-asserts-v1-2-be293ff499a7@kernel.org>
References: <20261110-tame-vma-asserts-v1-0-be293ff499a7@kernel.org>
 <20261110-tame-vma-asserts-v1-2-be293ff499a7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 17:01:41 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: kxr9t4fr99x7635o5xemub9ij4tfyz5w
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 29C1D40018
X-Rspam-User: 
X-HE-Tag: 1794416502-453916
X-HE-Meta: U2FsdGVkX1/s2YntUgQdj3RjJc4/w4aCl3hlHZbBH2nJv/h04rHSbNKCgkH7HUpjPcqda6gWoGAbABT7l4Fbczx5Jzcji5IIDCIUj9/Ech55gh49PRodquyJ35wB+/8nyarZKoUbrSrJBOyopuYyCQiRVzgS1m3KTWm3G76AWNmt2MrpGJcMdNzT+sUA5kP8IE6sac49zvgEAJsma/H3EeCZZDvQ9U3SLOPG3tWp6ntC8JUwlaWJj7J+Ph7DWG4LzJvmkB0WNZJ4CzTeUnPR8eErdD1sYGjPIO0MXZtq8c0ap/LMyuSOW649I9692I7nBibnz1pifsVzVZTDDgqUGuoUFPVnusgibWQWjjLIovmJX+v53lrjXCYe9mUAl0ODzpHd2oklZ1lGee5uokUgcnGJkazfXszZTppqLjiXnObo2dHx66Kfd/Ead6+1w8L+75Mklg7aY7rPHfBCEIo5EcxCWI/AWtqpUe1XtuxHio/VYso9PTGYY9XywzwuRar+FMp7yK5aWf7S02D7UEELQkkyTAFL1OMwjs42/Wg+MxUW9qkRMCYGzByTRm4LJw7mmkfzi93wY30NKvu6+QUuxo+cPcSd/RLdlPokhBOWn0GCVn1QwlrJbJq7tZEXuKTIaGBX39MzFKoIbBoGlmN0/Og4Jvt+6age9CgevvEcqZu/YxGvxruvwZZ2ObIJH3zEwc//vNwX2A8vVL4lrSKnJIJpumWJcwhHB8LXu8cSv/uU7r41fRT2XVe2RXiXrj6WsfFOkPv9btRJ+Hi7kgIc4xB8A2rIjrmmBWtNSTy08e6QFEpgR8yCftwnMAfa2elVQuntDnRKou8CAW1ucrlViTjT/ClBmQCgU5jmASGUD3XKuAySZm987e/rngJpf7wGNpKC6QkIOWaiKVof60hSPuV1mSJ6B6V/gKNNZpl1NWfK9IthMkvjPBuHxDQoYpSeywo8UXpS06u+BzXDylx
 4YZhFqoQ
 nRser4FTxdHusjxQ+FOqj0RezaZsuBtkZBJCf0oa3pPHf6Yg6GSRKj6NNZyro4ITY38Bf/JCmLKPc2ylPL9ftulQs2OCyZA6NXqEXHqyRunwkWxXt8rjJxe2YEMy15ygQg9lxYYJnS/5AgU7wrbUo0fWATZs00QwWLugBOQDh5g4VvAIEGUzu6VT9NxsSniC3IIhFBXTllab+K0j78VMuLYcc2dl3VqEBWPCujVpoKjcsGuBQpRGsmFWljpjDkY5Jm/P75YrR1eCr+kvxIaDxGSfkJQCzCo7IkQlP2PnBy8KsnWsn7NaP8vOLLbKjFXaLpdKxFd2JG1Rckw6HmjRyGwVlcDon4D32rZ1ELoJIpUx10Nt+3PQY5Pfyj3p7PMGxCrNEMK1ohUGsset8xk+GM127mqkxe9BeAl0P8/qK4BIJqFp7pMoRA/reMqVQ+A81q6wPWqEFmPDeYmWnRrPzBGNsuXgwLIEfiTG6YMVBGaQM01kSqzdhHKhC46HhyFASrDVwG0RVKXDEbm6bYe06LrxaJfQyxgcw/yvZyzLQFg6sz9WabuOtNHI5hMteWx6pwsM9fL/giUngjr02kpU6QbuadVPjNhWTvS2QDl8b7qPYuR6ynVfX3RLuOvG4ZOBTjFW8N2q8KLBg0fHf1+E5f9gqw3hFuECUb/R5mqzPWt9tDp0=
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
- [Low] mm: missing CONFIG_DEBUG_VM guard in vma_assert_stabilised()
--

commit f772b5a674b87f589a1f2a31923e1ad5204e14f7
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm: only assert VMA locks if CONFIG_DEBUG_VM is set

This commit gates VMA lock and attachment assertions on CONFIG_DEBUG_VM so
that they do not run in non-debug builds.

> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 7b6749e0f6fa6..d0291e6a4d20d 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h

[ ... ]

> @@ -369,11 +374,16 @@ static inline void vma_assert_write_locked(const st=
ruct vm_area_struct *vma)
>   * vma_assert_locked() - assert that @vma holds either a VMA read or a V=
MA write
>   * lock and is not detached.
>   * @vma: The VMA to assert.
> + *
> + * Assert only if CONFIG_DEBUG_VM is set.
>   */
>  static inline void vma_assert_locked(const struct vm_area_struct *vma)
>  {
>  	unsigned int refcnt;
> =20
> +	if (!IS_ENABLED(CONFIG_DEBUG_VM))
> +		return;
> +
>  	if (!IS_ENABLED(CONFIG_MMU)) {
>  		mmap_assert_locked(vma->vm_mm);
>  		return;

[Severity: Low]
Should vma_assert_stabilised() also return early when
!IS_ENABLED(CONFIG_DEBUG_VM), just like vma_assert_can_modify() below?

Because its tail call to vma_assert_locked() is now a no-op when
CONFIG_DEBUG_VM is disabled, vma_assert_stabilised() can no longer assert
anything in !CONFIG_DEBUG_VM builds, but it still runs lockdep_is_held()
or the volatile atomic_long_read() in rwsem_is_locked(&vma->vm_mm->mmap_loc=
k)
(and vma_has_anon_rmap() still runs the volatile refcount_read() in
vma_is_attached(vma) before calling it):

include/linux/mmap_lock.h:vma_assert_stabilised() {
	...
	if (IS_ENABLED(CONFIG_LOCKDEP)) {
		if (lockdep_is_held(&vma->vm_mm->mmap_lock))
			return;
	} else {
		if (rwsem_is_locked(&vma->vm_mm->mmap_lock))
			return;
	}

	vma_assert_locked(vma);
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110-tame-vma-a=
sserts-v1-0-be293ff499a7@kernel.org?part=3D2

