Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7815606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 03:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LMWE4Agm
Received: by kanga.kvack.org (Postfix)
	id 5EDB56B05B2; Fri,  6 Nov 2026 22:49:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59E786B05B3; Fri,  6 Nov 2026 22:49:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48D236B05B4; Fri,  6 Nov 2026 22:49:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0EBB96B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:49:37 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6EEE1C027D
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 03:49:36 +0000 (UTC)
X-FDA: 85406943552.25.5169DBA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id CDF03140004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 03:49:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LMWE4Agm;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794023374;
	b=zC05JitBdUL1EgfZsMm2DgfgugzkXy0iI83jYuP8mvByjF/xDZT07wmzUUZBXQ6oX6DVcD
	K4r5cWKZt8ZmU/WMoyIiQhPTiZ5cDbpgTy2G06Fy0HWR2/X9QHaRGc4NMdgwlOF9voQNlu
	cdi6apbNd4hsfYF+CEFoav8AYyaccKY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LMWE4Agm;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794023374;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cutAuWHvNzGyfza3iyExlZUzQvoMDgtEBIcgqPWqQFs=;
	b=3/sDR5UB7e/dcJn+HRwHJniSFqoOhY2PeUNGqasM3mFE5812ATTjdT3ZB7QiKVf50vhFMN
	JvkR2L2PdFbvMYMLImlSLVgfonaYAP9G7nLITOsdWfrFq6QQQYMOdiZQ7lovIeqnzKta5o
	2i4Qs2zIcTplqwaCvfVPUWOAeXEj9es=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A32FF60ED9;
	Sat,  7 Nov 2026 03:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B281F0089F;
	Sat,  7 Nov 2026 03:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794023373;
	bh=cutAuWHvNzGyfza3iyExlZUzQvoMDgtEBIcgqPWqQFs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LMWE4Agm10/bbloUoyTBQBM4m/ORvxwkqqhUcWMvuU1WMFHpTaR+hkeNm6+w7kbex
	 SRzhYllQ6gd9O670442FL4B1cDmoBDZvxuo1zcKqFxmAMCDY854tfnaFWrrlaKsU+Y
	 sS0b14q5xtR7aruyt1RPaD6frWtowNZF1CGuh4sLQkfi+FmZhEqS0vJablEGkXVzYw
	 F9nw/ciFCQkmcug3hBCfxhfnxaq9vvgE15adj+qBCpPulu4ADld8j/SzjNZe7zveU7
	 YF61pmRLC2oGG1X/rXba35mBiDgax0ToiyauBzBfhGUyRt46bJN3fCE9yrNI4BRNUk
	 AKp/hzbTWkYEA==
Message-ID: <sashiko-outbox-202537@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH resend] ksm: add merge_only_zero_pages to merge only
 empty anonymous pages
Reply-To: sashiko-reviews@lists.linux.dev
To: xu.xin@linux.dev, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>
Cc: "Chengming Zhou" <chengming.zhou@linux.dev>, "Lorenzo Stoakes" <lstoakes@gmail.com>, "Liam
 R . Howlett" <liam.howlett@oracle.com>, linux-mm@kvack.org, "Huan Yang" <link@vivo.com>, "Wang
 Xiao" <xiao.wang@vivo.com>
In-Reply-To: <20261106034841.233085-1-xu.xin@linux.dev>
References: <20261106034841.233085-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 03:49:32 +0000
X-Stat-Signature: sxwthj34snshufjr7rfnc6muiobutdzb
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CDF03140004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794023374-609536
X-HE-Meta: U2FsdGVkX18dXrHgWDuhDS0ZTDgXY4uT+dqoirNfOasazjhSdY6oHw5gY0UPurOub/ZmCAI3vE6xUZW9ABuYp6t7/IeJhS2gp6in/gUHHVGQYOqNGwRHJkpJ9cisd8Mzc7XeG3YuayPQvPXe9SAP66rUfbshNCQwyXrcvrwobQRBb7Q7t/Y6f78s6dsAxPof/aC2O/gvDqL9ovEpGlGSSRvJobipMzD25qrxobRH1pv1gPqmm2y/Cq8UyB4NL9g1ccZ1B54JVbVSDYPidzqWaNitzLLTUTUXYFoTNz2dKKOTJePNPmo+yjJWbr0sSDX0eYCxiUl+6WAySidtn2auXzpy5R+ItsnO6ZLQ20HCBgb+Ux6QZKyVL7dBw66il6RBElNmeAiYMKYuYUSuE4QntM/3rt3IPfSMA1COM5564/jFPerV5g4Y1Ic4j5gBc2u+IJRJBQWz7KZvGd7rh333kVB2LnAZ3xxCtDBwRDfeWM6tfn6cReUn3By/s5dfBKzi5eyNBe4umuSUEBh4SbaNLdMeDNAC4h/n2bMjbQC0kktB08OiUigE0b5hZHCKZxyRJ9m+fUbBknl9mEvTzm84pDY33XakzcL3F+6l68xBIIVIDg+n9Q8+l9FR0EFyyL1zh5jeTMNcZmjwvzRzA3gstQU56jjDzXXfsIDCqYbr/+VI1lvwWuWyh3iOZY9FG+utBsmh9AJHcIm+gXWeckVr1osVigJWzybi4996m+8VnOkEpz+gh+tYx0E+P7JlZtouBN4+1IfT1y3kd2WaOR9Blr0CGR7cE88dwBenPv61ZJV9wOLWrOuG27LWzRpPDUl3v/JKMVEwbkgkWJkxulvIsubPs0XA9G+SP53634jpgKVItFdqF3DE306lU/fZb4jxpoyK7rV/XGvq1cT53rAk0lJdVWMMtKyW8KihADEZFh2BsoKcZm27cFmDuiCSajWCISxfOCh5Edp2rivQGCl
 1ST3pt29
 IqacX4gT6EgQSPwBXxbGBg6B+GIDkFGAgnQVVPq59vP2nrPRNl01lJGMrcnmMGBUB7VkCIZtQG+ref5JP54mapAEtbmbYBfQivX3TWhOhqwTBLsWdoh1gVPgydvSZwgUK2XuzUSkgzZjog13/jgb6+i4SG/dRrq5vJPQJ5tUhvtJ1/lXpHqUiFCEQIePAeSNDOIVjxjk3typVbIjq0+AV2J+XcJfPuUzsTBSzTf75WORzCKMZRMA5zjrzSXM0dA6l9SH1jvjEByyYeVPKvPynlkhLvIIpgOL4Ak+xU5m5keOCRnuUwVRkV1hJLuVtNzmXMK4S+G/3pn+k+kp3kEG76RmO9cEc9TQGojX/D5Oge3fzmi0nkYXlaEzixdDjQVQyuFP++Qj11CiyFAXPBcfeePig241ttw5jL2c3+kIuoqm3+luL/MqN7G1aE/jvqDxfCydalHDaEfOr8bb2n4Q2bQ/HTIUNl3/Tb3eVrJX+8s/zsbnpGN2jIGEGi57byNCEH6loBtj9kWU9h/7MiCIXpW7JQ2ROYt45w9L9M7AxAEP5pPx+wdMxNSFcWZPj6j6+r5ZaMxiMpyUbVkQkPzmXwKdl7Fk7rAcy8sqYpkaKIedfqqI=
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
- [Medium] mm: ksm: unsynchronized state checks in zero-page sysfs store
  handlers
--

commit 9b8576e88012c85cc90e3b5aa732dfb204eefebc
Author: Xu Xin (vivo) <xu.xin@linux.dev>

ksm: add merge_only_zero_pages to merge only empty anonymous pages

This commit adds the /sys/kernel/mm/ksm/merge_only_zero_pages sysfs attribu=
te
so ksmd can merge only zero-filled anonymous pages with the kernel zero page
while skipping the stable and unstable trees for pages carrying data.

> diff --git a/mm/ksm.c b/mm/ksm.c
> index 340c65aa14e58..35ed40747e30e 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c

[ ... ]

> @@ -3679,12 +3695,48 @@ static ssize_t use_zero_pages_store(struct kobjec=
t *kobj,
>  	if (err)
>  		return -EINVAL;
> =20
> +	/*
> +	 * merge_only_zero_pages depends on use_zero_pages: refuse to turn
> +	 * the latter off while the former is active, so the two cannot
> +	 * silently diverge.
> +	 */
> +	if (!value && ksm_merge_only_zero_pages)
> +		return -EBUSY;
> +
>  	ksm_use_zero_pages =3D value;
> =20
>  	return count;
>  }
>  KSM_ATTR(use_zero_pages);
> =20
> +static ssize_t merge_only_zero_pages_show(struct kobject *kobj,
> +					  struct kobj_attribute *attr, char *buf)
> +{
> +	return sysfs_emit(buf, "%u\n", ksm_merge_only_zero_pages);
> +}
> +static ssize_t merge_only_zero_pages_store(struct kobject *kobj,
> +					   struct kobj_attribute *attr,
> +					   const char *buf, size_t count)
> +{
> +	int err;
> +	bool value;
> +
> +	err =3D kstrtobool(buf, &value);
> +	if (err)
> +		return -EINVAL;
> +
> +	if (value && !ksm_use_zero_pages) {
> +		pr_warn_once("ksm: merge_only_zero_pages can only be enabled "
> +			     "when use_zero_pages is 1\n");
> +		return -EINVAL;
> +	}
> +
> +	ksm_merge_only_zero_pages =3D value;

[Severity: Medium]
Can concurrent writes to use_zero_pages and merge_only_zero_pages cause
ksm_use_zero_pages and ksm_merge_only_zero_pages to diverge?

Since these are separate sysfs attributes, kernfs does not serialize
use_zero_pages_store() against merge_only_zero_pages_store(), and neither
handler takes ksm_thread_mutex or another shared lock.

Starting from ksm_use_zero_pages =3D=3D true and ksm_merge_only_zero_pages =
=3D=3D
false, if one task writes 0 to use_zero_pages while another concurrently
writes 1 to merge_only_zero_pages:

CPU 0                                   CPU 1
use_zero_pages_store()                  merge_only_zero_pages_store()
  if (!value &&                           if (value &&
      ksm_merge_only_zero_pages)              !ksm_use_zero_pages)
    /* sees false */                        /* sees true */
  ksm_use_zero_pages =3D false;             ksm_merge_only_zero_pages =3D t=
rue;

With ksm_use_zero_pages set to false and ksm_merge_only_zero_pages set to
true, try_to_merge_with_zero_page() always returns -EFAULT and the
subsequent ksm_merge_only_zero_pages check in cmp_and_merge_page() returns
early:

mm/ksm.c:cmp_and_merge_page() {
    ...
		if (!try_to_merge_with_zero_page(rmap_item, page))
			return;

		if (ksm_merge_only_zero_pages)
			return;
    ...
}

Wouldn't this leave ksmd scanning and checksumming pages without ever
merging either zero pages or non-zero pages?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106034841.2330=
85-1-xu.xin@linux.dev?part=3D1

