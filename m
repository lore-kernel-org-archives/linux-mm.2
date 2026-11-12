Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60CA9606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ipffv3fH
Received: by kanga.kvack.org (Postfix)
	id E00AF6B05BC; Thu, 12 Nov 2026 13:16:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD7CB6B05BD; Thu, 12 Nov 2026 13:16:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9F746B05BE; Thu, 12 Nov 2026 13:16:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0AC96B05BC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:16:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DCE8A78B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:16:36 +0000 (UTC)
X-FDA: 85427272392.08.CA9F7D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7F8BE2000F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:16:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ipffv3fH;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794507394;
	b=cp17RLLgL3GIyD/2LiiTtk+eaoEAvgKQeEqAiqnPvgT2gb6yt1X/yHlvHIeqdgfgkt/wuQ
	mz5bD3Ld3bDJ/56Ufyq9SUadcOAA0L4vt0Up5YjTKWmbb+MXhhFOGVFbKivJUsOF4/qbTc
	cggzxOjVTHW/KGvSLhqmg60yXngxhus=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ipffv3fH;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794507394;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rBKkrearG6i6Y6Hx6cWO5uyYD6RIF5v8jY/+z72l5bk=;
	b=W6r8WqVcNXmeJ9+dKSYdIKFpRojkYN5XK5kuNp/P/qNAtOxJJDODCY0+2EPsqT46cc3NmW
	wHWgffkQbUWdjwtjsnKE4bsZc8iNRSXpD1YmF/xawrJQ0gbBHbDOmIdxqYRGLGx0rT+P7M
	JXFLwP6K2a4oTr65H3YjVR4CmXJNM2E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD75044750;
	Thu, 12 Nov 2026 18:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3706A1F000C4;
	Thu, 12 Nov 2026 18:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794507393;
	bh=rBKkrearG6i6Y6Hx6cWO5uyYD6RIF5v8jY/+z72l5bk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ipffv3fHdJ0D6JBjTQGwRPY4tYmn1PQFrz2VYD0COSOdnp/DI5nuPU3ZRFDSjzDcl
	 zuHOX03+QSgXSt0Wm2mnXs/bUqSFi6RELZONsgxQKLJF4YnZF9tusG29P2ZkmVZz+a
	 qzuaCUgl2nPGzxn1tiIjtJBWQ5Ze4F7XNnG8jIsORxQJ+Z1YM+zFf1R+2W3CF/hSyC
	 9ag8SfoA6Osw/x+TxgtsKs9OZY97i5uyIG1KBcVp8nSEuCOLjYglOzXxiViTdxaYFV
	 wLPxEko30CB52PC2sdc7iul6myre3dkIaIBPtb6c+p0inDbZ4IIji3Ls9iUlU74hKU
	 3gsxAzQEEHKxg==
Message-ID: <sashiko-outbox-211681@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 10/13] mm/migrate_device: refuse to migrate shadow
 stacks
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "David
 Rientjes" <rientjes@google.com>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Pedro
 Falcato" <pfalcato@suse.de>, =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, "Nhat Pham" <nphamcs@gmail.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, "Matthew Brost" <matthew.brost@intel.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Usama Arif" <usama.arif@linux.dev>, "Kairui
 Song" <kasong@tencent.com>, "Balbir Singh" <balbirs@nvidia.com>,
 =?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Yu-cheng
 Yu" <yu-cheng.yu@intel.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Dennis
 Zhou" <dennis@kernel.org>, "Tejun Heo" <tj@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "Peng
 Fan" <peng.fan@nxp.com>, "Josef Bacik" <jbacik@fb.com>, "Chris Mason" <mason@kernel.org>
Cc: linux-mm@kvack.org, =?utf-8?b?Qm9yaXNsYXYgUGV0a292IChBTUQp?= <bp@alien8.de>, "Mark
 Brown" <broonie@kernel.org>, =?utf-8?b?RGVubmlzIFpob3UgKEZhY2Vib29rKQ==?= <dennisszhou@gmail.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-10-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-10-3d2454362e8d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 18:16:31 +0000
X-Stat-Signature: 6iwnsm57j8tfqyro8kiyatosn75iodcx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7F8BE2000F
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794507394-265332
X-HE-Meta: U2FsdGVkX1+9+M9Q3B/Lg9WFGaFigz6xivuEYeBcJwbE1ahmsNWrgwTYINpSI8PJROkC36wuJzZJHWE9VrCv9Bp4GK2grOPO0us25FSmB3FI0ASOWu+8nYDtECWXbxQ+xBmOKVgnxh0QKfD0P+V18IN1fmVErsLeIsk3zSlGZYQRQdFqHPNYZBZ9W7fS0/twcM+vLKtW9WdzTbsxSCMAt6hBdcb6yMTMxd4GIW/y57Gj5qr3mjkw3hATUyl/66hiCrFORYqV0BdLBkcDgGEyHLiaEUkO6hBsrZ80U/FnI+spZ2595iTJ3XbGSY2wMcPOkpD90fogkMsM6jSbx66HCtoezaA33UE0BdKvF8w+c/Rnp7g9aBjAPgl4u1DG0CYXOExRM7jV5Ca8Q3f86sNTSlPRVuPOLHbhWUvjl8xxjgLzwkE53OHtq6GsHPVQnpVbj4I2eXncYY8gC9L9wCk2IjfW+1qC2NC/plqP17vrdC8n3eCDRA+gfRojSHrxd8zEMAShknwRTNKrnbA2wrwe6ctY3ENcENBGTqLnjhvOCsuCxN/EJdIk3NIt1Fiy+CEwRYMa/l2sdYj6FglAluQyR8gxvRK8HrIaEQN6sbW9ZjMht4QaGIhW1od9BDKG9tz/kK7qSmu2J9dwhIQUkgwiIpRNmuLcqtK+9xZ/6SaBdPsOYb811z1EUbCo/4RB5fn6MAvZAlF/LDdjNCzQAa9G90CrLUIah/4wXQmQJzqx7lxnW9D7IVR55WCIDRiETNF1aOq95kFSVSz5VK5vrn5iFBZ2cRPg41uW5Y5mWVYbUR4mmL0m683Lj5Arr/JbQSoG9rNVH2e7ChIijFc0P01f+C/VIBE0GceMeLLkMiajy2kUYcY1xqPrcBuVL5qMFrGCib3QMPLQW1eNvlNSxNurRgwyBTGpb4PNUEaPITZYY4e99rXwm8nwKjgVVq1vEZS2m6X4+D/qPUhC95QsMqt
 +YCt1AJk
 RIdtvoG5OE4eMjOEUW0PdYRon09+PxjflOTaxGxlEqJL4+FP0vSHTjbhHFr73y1Kd3R0IqV5w7S8mTOZ+n7AoelzCQTxfWEX2AfS9gopQ1pxqKK7uPM3QE9np7EfYOvrwP3G5dK5Q3JaS+LJXNtUU+Fqdp5wCsfexTTiZNRU3XC1DdQUKZIjac+1HxlYLLeVuwXrc3B+Tddi20zkbaw0659VITXPpO8fqHdFpN5GRyKO40pJF0+GlInLMbPynFD4xw7Zs0tQQwKcYaBDd0cq92Sc5FiKbLyeiocwR5qTvyOv0teANp4fySCXZGXY4aweEAUrkql1vMPMVB65VtuNOAz9+p9g0l4eIfZKfxa+KoA6j4TcPGFCzkVo97f64nBQEmxOCUv7gi5bKsoFUTfLAPO2PSlKg8rqmWfgdn2v/4pkXh53qNfRJWQwq2cgPhBwfGfe5WgXaK9tmZ5CNsdftpWVq8NfMftlSAFm94hnsqBkfStzH8LpeSqmMOsuZthOYpHYCYdKvkkgTlFmvOaizcQEWKP6sTBv0RJhtI4TtnxKvDWjD0yxP8T9XXRbbu05hZGjpn4Mj5kJcvrTmvhn17dXo0U8tV4KP7r1Uv9tPBptnwKeisYFS6gHkr49aDlzZuXsQNG4hZgpe6kdO7WbAZee8qF/HMpYLntrin54TeqwLsHCrRQtSfmIFhfB6vu3IQjrs/kelHZs3muvxV/wo+W8G9lGLy+1hkVD651EDqO8V/kMKdQEHiUmPmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] mm: out-of-bounds write in migrate_vma_setup() [1]
--

commit a0bf8430c5e68cd904038ab8081c7bc9a9b0f7de
Author: Chris Mason <mason@kernel.org>

mm/migrate_device: refuse to migrate shadow stacks

This commit rejects VMA device migration in migrate_vma_setup() when the VMA
has VMA_SHADOW_STACK set.

> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 0f2a2832e0bd1..c27f513ee46e3 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -759,6 +759,8 @@ int migrate_vma_setup(struct migrate_vma *args)
>  	/* The migrate_vma page walk has no hugetlb support. */
>  	if (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma) || vma_is_dax(vma))
>  		return -EINVAL;
> +	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
> +		return -EINVAL;
>  	if (nr_pages <=3D 0)
>  		return -EINVAL;
>  	if (args->start < vma->vm_start || args->start >=3D vma->vm_end)

[Severity: Critical]
This problem wasn't introduced by this patch, but can migrate_vma_setup()
write out of bounds on args->src and args->dst when given unaligned
addresses [1]?

mm/migrate_device.c:migrate_vma_setup() {
	const struct vm_area_struct *vma =3D args->vma;
	long nr_pages =3D (args->end - args->start) >> PAGE_SHIFT;

	args->start &=3D PAGE_MASK;
	args->end &=3D PAGE_MASK;
    ...
}

nr_pages is computed before args->start and args->end are masked with
PAGE_MASK.  For example, if args->start is 0x1fff and args->end is 0x3001,
nr_pages is 1, but masking rounds the range to [0x1000, 0x3000), which spans
2 pages.  When migrate_vma_collect() walks the aligned range, it writes past
the end of the caller's args->src and args->dst arrays.

[1] https://sashiko.dev/#/bug/linux-ca91ac03-4056-4cf8-8afb-0e516e08797f

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-mason-migr=
ate-et-al-fixes-v1-0-3d2454362e8d@kernel.org?part=3D10

