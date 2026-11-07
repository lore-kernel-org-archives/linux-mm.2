Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E032C606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 03:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F+jZOoWy
Received: by kanga.kvack.org (Postfix)
	id 6A6D26B05B0; Fri,  6 Nov 2026 22:43:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656C36B05B1; Fri,  6 Nov 2026 22:43:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56D406B05B2; Fri,  6 Nov 2026 22:43:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 284386B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:43:51 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 858BAA7B40
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 03:43:50 +0000 (UTC)
X-FDA: 85406929020.06.7D208AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C8317180002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 03:43:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F+jZOoWy;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794023029;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9E5ibFPsXIKoHnSIZ1Z1BztDjDSUVZCgCyIkzL+syn4=;
	b=c9qCw1tlri7vJveJY/pB6td6prSY9LEMNLz35qjMMMX+d4/T3+VweW9xSt4uom7Tt8XNN+
	r4UQtmgyGoQhI00e9fIhJ/svtCrytASh9cS9DccmG2FpwTSmbhS8cAYVWY4eW/EZ4D+MXX
	6RPaKNN10AcIefQHA4kLuQAforeXfmk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794023029;
	b=o89YWqa541+g+dkytDxz4ISwFToh15b9s69lcyONsWaHtF+wuqrYzs1IoDGDiIK+epnWJj
	krmUBbbI0BgJM4HqdZ6uZxlVeufBMjkSMRykqrCmxlfFWRP/WuR3BPQkHvjCZuQQjPmNVX
	STfAI6pc7ux7r12KLWKetPxdoD2eXp4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F+jZOoWy;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B5DAA4025B;
	Sat,  7 Nov 2026 03:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4364F1F0089F;
	Sat,  7 Nov 2026 03:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794023027;
	bh=9E5ibFPsXIKoHnSIZ1Z1BztDjDSUVZCgCyIkzL+syn4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F+jZOoWylyIFoHJiNOeY24V4s6HwTnI0yI7ihk/Mk7y7P0VxOH/RAW7LIJ/xIm9ME
	 wvN+DMjTFT7ON8JrDWCjeQ4LD9kCcyp6qkTm2IgNFHJbnVVgyUXFPTBrSCiHtktyLs
	 5JW8gYdfo1zZCliQ4yUvdWK+uiHHoi82C+PKJTdjHU+oXUOb7hPgJLelMA54Rwj33M
	 KPIAPIhpL4w99JbqBtWmMYnYUxGrcRy0z0U+fN7pOMrDjCBPKbm/UZiG2Ce9g0fPqc
	 qAeR6B7L3KbS1/bQ+alZAUkPQWaIyu19jCvlK0aUGnmNqSuEvRJNqjV86rD6pIBzSv
	 VnbQv8YV8qbTw==
Message-ID: <sashiko-outbox-202535@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ksm: add merge_only_zero_pages to merge only empty
 anonymous pages
Reply-To: sashiko-reviews@lists.linux.dev
To: xu.xin@linux.dev, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>
Cc: "Chengming Zhou" <chengming.zhou@linux.dev>, "Lorenzo Stoakes" <lstoakes@gmail.com>, "Liam
 R . Howlett" <liam.howlett@oracle.com>, linux-mm@kvack.org
In-Reply-To: <20261106034304.231809-1-xu.xin@linux.dev>
References: <20261106034304.231809-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 03:43:46 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: 1qzyz5648s1sxj4ajqfa91k5iusr9oka
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C8317180002
X-Rspam-User: 
X-HE-Tag: 1794023028-239882
X-HE-Meta: U2FsdGVkX18mP9EMWYRdON90HHEU4TonpM/DONG6CbESqLpZzhqckvj16BX/tvdyokLyNkdFWuxVNb36al3qN9ACZGqcpaIPWNnAgBGnYyacQD+IJLv5YaS2JndSqwsc/StaMrET+PCOmuRvCl1J6TW+gBINwAQPqnY8pW92x1yJCI2dMH/itqneEcRFry7IQA3ZsumFcCkhiI5crfI3qL5e+ruSAnxdr2N6qxR4EkBEoMKtecOoSVZguiBy3vPqmKSRdosamPtvbuJnSELG5DRINc4mI9RAYoCToW28EedNkWvLvSAx6+72pCx7SBiWjzFwnkoCuhLaBc9vmyZSLIrzgU6EWnaL/FsAUR7+qVX0mzeZRzpxsZ1pYD6hcqoaiUUa065AlvDgbEp7BlMar1LlHipZUw88BJPs2qzB4PEh/FeISom8kEwOg4cscvEEZlevpg7KRXd3msCPcaJkPkMaBy/ATEItomy+8k/Qg4JuG94Mf62ni3DORWUB/E//7QqSqmsLc+7HGzyK3zNn4vg076Pska44s6eYcFvvDxTr1h3s0EF65r3OEmFEhlt/SngAByA0kNtf9d8RbS6sHfqJA+H5xib6224n0VKKafxavtVH8zC0WBT6FDpNYgzJlNfz2qXmysSYg7H67LXQqtjBA9zdNKcg/rjB4ByCMP7uGUP1hfRDtsAe6+uR1tExdDTXECtm9pl4YAwHVvoHXjTXPSNjtFlpK8t5Ms7FGoZEhu9mDkR+Uuach00yjuKVF1QX1xVR15H2HOMpXt8lT45Ulh22Fh/EX+ouDJIb0+7Bb0QE5c0lbqtrW1aFUuTrWPso63Jd0vIIhKqef6lcVdJCpp6BBJKvMclPpEDMsNhtj8t+oXa+6LTRmDw89v9WESZZd2/O7OaVMUaK9we0uqrzwgRxKmkAg4+Fvepl2FPda/6edyspwmKVEwWNwC1Yf6LYoN9DvIIjxu59GWt
 3xNxQbQR
 8URxfAjAHAnlX1963winAiPTavfUvUzwcXQRitjPFaDuhnReG91vqOLJOlQxzfLU8K6CjytVPYO7IIfM2FBhPATIagdQrt8L1Sv6Qdxti3dn02BpEaU45gGVHrObgyKAqm/xuLUyNwWA5qnX5ZqN4deNpeAkj0XmO9s5/HNEebCvZpakp4R8RUuGfAzLKn02tygvWvS3UNjFES36MZJJHcoA/z3loNawpDknOiZ/j9c6LUGPU+0g0JNtmqeasCBNWllBKkmWlMS0z19KmAp97u5dmnPkOnO1HJ/jA9LhcxKoCNnTKMyW5h4EF6MeCHnoXeuhQUvDgMHgs1eK6D1eKxgh017v7SYAlBe184nUGE4L4DOUbARCc3dc1iEKVxGcUyD+9CuFCCoqir5+Ie3qPuDNE9L4y8goizb1u90NiVy9wfzws/4/EkhRnfX3F8NlEpI/JfMYOm9C1ikh7adk6WIg8SIWEV9/yIiyFpfE7ZvwuhCbfGqocn5viJcwnO/bd6kslWiPAUXAAdz7NfouGmxerVnFKk3uuRGKWjhx8psk4UCxnYlzcBGlWB6kAR2FbmnjAAIRwRs3We9badg1utRFBsZKnVIVwr5SNyX8aPx5XLeU=
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
- [Medium] mm: ksm: race between use_zero_pages_store() and
  merge_only_zero_pages_store()
--

commit e3394c6484d9d77c2cd89b85bc6fb89ad39b6904
Author: Xu Xin (vivo) <xu.xin@linux.dev>

ksm: add merge_only_zero_pages to merge only empty anonymous pages

This commit adds a new sysfs attribute, /sys/kernel/mm/ksm/merge_only_zero_=
pages,
which causes ksmd to merge only zeroed anonymous pages with the kernel zero
page and skip the stable and unstable trees for non-zero pages.

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
> +
> +	return count;
> +}

[Severity: Medium]
Can concurrent writes to use_zero_pages and merge_only_zero_pages race with
each other and leave ksm_use_zero_pages set to false while
ksm_merge_only_zero_pages is set to true?

Neither use_zero_pages_store() nor merge_only_zero_pages_store() acquires
ksm_thread_mutex or another shared lock, and kernfs_fop_write_iter() only
serializes writes per open file description. Starting with
ksm_use_zero_pages =3D=3D true and ksm_merge_only_zero_pages =3D=3D false, =
two
concurrent sysfs writes can interleave:

CPU0                                  CPU1
use_zero_pages_store()                merge_only_zero_pages_store()
  if (!value &&
      ksm_merge_only_zero_pages)
    // sees false, passes check
                                        if (value && !ksm_use_zero_pages)
                                          // sees true, passes check
  ksm_use_zero_pages =3D false;
                                        ksm_merge_only_zero_pages =3D true;

If that state is reached, cmp_and_merge_page() will see
try_to_merge_with_zero_page() fail with -EFAULT because ksm_use_zero_pages =
is
false, and then immediately return early at:

	if (!try_to_merge_with_zero_page(rmap_item, page))
		return;

	if (ksm_merge_only_zero_pages)
		return;

causing ksmd to scan and checksum pages without ever merging either zero
pages or non-zero pages.

Should use_zero_pages_store() and merge_only_zero_pages_store() serialize
these checks and updates under ksm_thread_mutex?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106034304.2318=
09-1-xu.xin@linux.dev?part=3D1

