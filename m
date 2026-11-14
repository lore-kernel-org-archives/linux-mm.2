Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EDCE606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 18:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lURSPx/K
Received: by kanga.kvack.org (Postfix)
	id 0FD4C6B05B1; Sat, 14 Nov 2026 13:58:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D5216B05B2; Sat, 14 Nov 2026 13:58:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB7D16B05B3; Sat, 14 Nov 2026 13:58:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA25C6B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:58:12 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A83B6A0439
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:58:11 +0000 (UTC)
X-FDA: 85434634782.19.67E4864
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 17A42140002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:58:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lURSPx/K";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794682690;
	b=NhPg9d2SAFPR5ndrNptVunN0zqILWcq7ioFKkbZboB6OlfaX9oL2X81KQJ6gSW4CZ8eOsK
	75uqM45vdgzltSUljuTKYiW9riQ7RHbJfLEncBcXnvZgmRA9b/kltTnYeH8zsAjc6SHXPj
	5F6mNLUOsY0dWOiR1JmA/IWhJaMPIF8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794682690;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxb5A3fDezD9XWyVdU0Pm1m1e1Q9nb/c23yvsaH1TGs=;
	b=3EF0t12NE4g63c/oFYfKbpESjF8DHsZ9u1INZRJc8IpsY4+p2Pn0HN9rMsVsulPLHCvTPI
	tc1To7O7KF92e7Ojo6oek/EMo5DjZKgZMve8Svyz2CorLcDXfm9AUWytDobKL6mVJyTiuk
	MAFexYwKs//4EDfCAubfProda5IhetY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lURSPx/K";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A225460F40;
	Sat, 14 Nov 2026 18:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A218F1F000C4;
	Sat, 14 Nov 2026 18:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794682689;
	bh=sxb5A3fDezD9XWyVdU0Pm1m1e1Q9nb/c23yvsaH1TGs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lURSPx/Kru0c7vLoWR3Kzj61JujCHkscmvvS8lo8D3qckJbFCHCsuwy2J5VXIb204
	 7Xea03siSIbW3VpXItIFMLe7+16Fg77Px00eUfc2u6iMC3zBZkeukLjMh/u+VyowpC
	 ahQ+2U6iyd02SiN9ULBON4FVRj1QqoeknkEJKyQc6aIj78UMY/8DqZHw3ja1Pvkxfs
	 TJEjsUJNil3Ag75JMPuNetiwm6lEZPO2dCd0iV28mMxXo6lLVCggsef+Xzig3pu0q2
	 28ixQZIHdQUWR5Ig2F8YCVlqjUNIxI4PiXzI4+ievr9xM+wFpvH4Vg3s3NAzkgg2g8
	 kITZ5aiZsglEg==
Message-ID: <sashiko-outbox-214930@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/10] stackdepot: Store compressed frames in stack
 records
Reply-To: sashiko-reviews@lists.linux.dev
To: "Matt Fleming" <matt@readmodwrite.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Marco
 Elver" <elver@google.com>
Cc: "Alexander Potapenko" <glider@google.com>, "Andrey Konovalov" <andreyknvl@gmail.com>, "Dmitry
 Vyukov" <dvyukov@google.com>, "Oscar Salvador" <osalvador@suse.de>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Caleb Kan" <ckan@cloudflare.com>, "Caleb Kan" <calebkan1106@gmail.com>, linux-mm@kvack.org, kasan-dev@googlegroups.com, kernel-team@cloudflare.com, "Matt
 Fleming" <mfleming@cloudflare.com>
In-Reply-To: <20261113185702.1332171-10-matt@readmodwrite.com>
References: <20261113185702.1332171-1-matt@readmodwrite.com>
 <20261113185702.1332171-10-matt@readmodwrite.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 18:58:07 +0000
X-Rspamd-Queue-Id: 17A42140002
X-Rspamd-Server: rspam12
X-Stat-Signature: a5343tpu551muwtnkzsg53mknbh5x34p
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794682689-755031
X-HE-Meta: U2FsdGVkX1/kZIOLV5Wq8dY73oqjqtqNukLkdHbBQ/ZvUbuYibD0LWwpcIEI1FCfKmAU1rCQsv+MNOJNMe2PfRfLeqpipyglCTeo+hVJ8oQfjMdWYdiTnaluuPwmFxk1mCNaLfgdiYUdmQ7Y4Ewa1xUliOyvODopDwPlCjxSN2mJjecdd99GiaQ/7tgD2FC90rV766dfbjvfF0MivPsbF1wZ/Fbsz0pyi6oBkl2nI7lUjkx0zXfiJTyZGPIEQBCN3z/niE5sx0hghO/8bE/utS7Ie5ZQKzQRpuh3aHWZHwUfVh2yTEm6MGwnVzMRsQH2eT3Pm4pnzm2FLTYBpZQ1AIYbhu6+CPmktyunVvGg+tVXX8g2TM4bkKUmF5QgQoOyN3oozyI24czSAcLbnF72POk7sDLE3wLfyPj3tBD41BwSlBQ5/cH5Q9xLpy3ZUgIgEefwzdObsotctvlAAAJOoccLrHlduziXvHwpdsjz5w1etFIhTCXrryzoJx9VxfFjjnLp8BBZwgpzl5IbeVzl4zGU0S+0S4Bfub2CF1pzLKKQCty7wq2z7gKfDTvaJHLizi0cJtwz3jTAgGpQA4UbPkPGA0L8BWLsjxlRHnOEipG38fnZ6nrzgYp3S3GWUk//AN4XXB4Q464A4sG/NiuO6p8gcCXwA75r2WGIcHqTRHlE1MGkXFZ8StEN2fiQ6BuazRo/bf+jsmBm1r6JgROH/2ksr1uVtxM1dcYin46KDKn8K8IjnWBMkzeza2iMNKys/AVwI8+W+yHpQZjpZUOAnUf0Gw8/JdiOsI1DMNCQWykVtNhPLFcHb2wXEFiwbvaWOc1/V2Mxu8VjGSNdiZagcOv9t7tfFKetonvuDQLABuoBnAOZ58h9rVCqpeqZgTiPUenyiiLVcX9leISwgpDQ/c7LDu0yo6fweIrJohCQNEP32/0QMWWkvDvvmt6CIN3qJqiEHzZ92YdTXUNLbPh
 2qrEzCas
 D4BfDqnGynzlBUgRYJbTcSu13kZrOeThFBu4QBInpL6hqQB4ueqextWIz7mKpc6TpUmEWekMVhyMZvG8oazQuAIM5H0y5hVt90tOg+sIkQv3UEZxewaMT7ReOfbn2UmrBeUZTVNzsvzpYBvtmmdPiP9P6Rw2Y+WdZ1jbHev1V2my8DAqIriUX0wLxlNPFGBjS/va2PhL/nH3ncBoT26EJJeHEi9OocPz1ZL3bzJ1mSsoVGjRwWctaOh0Qozew6u1yO2PFcOv5c9pAWO0ZZZkq4KgaOpP3HMj7n77RFtRAAJJzXYLo8moQrVO+itayUwWxi/PefYvvnlBq9vbDmkM/L0HW1CdBzDpQESNKwcaUp0/cH3F69/GWg4zP/sGWJJkznCkaRvhYjsWiuZUI6W6x0gIlHJlpbnx1tC45ZDifp6/fBxgh6lGmOYgxT2PYsapQJ49oWalvqp6EZ832dBrPDUdmDY++8t9U0bcaJPND51RzgUaRlb9ssID77QKEozRD5n2E5sjVDbIsyAd6Xyq5/XAXt1VmSr9Q9KPQWWI4v3M6Wlf8MjdlfAJiNFLNNyGLOpWveOBwiKBBRNtXbt1zgescahtt0zzsXkpedQfYhKldUtSdoXJVDoH8ZkUMa0wOaLkgRaWPOCCp+0rlyO9MovUQzhHVF1mZ0FP671wMSpJt55FsZ0lM7bha89mUa8M016YZKw6003eZPdcVwHD5TvKSMhRALEAlpFfHy8PfTHA2K/Tk6RjddIW4ZpvBgprS7zGvWIVkfGgI/RM3r13U3J63YgWdUjn089HXD+3tVjjBxw8=
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
- [High] stackdepot: uninitialized frame in depot_stack_entry() on
  generic arches
--

commit 8ef363f0fde887ad99497bbd2e7b00c5bd8bac35
Author: Matt Fleming <mfleming@cloudflare.com>

stackdepot: Store compressed frames in stack records

This commit stores stack frames in a 32-bit compressed array inside
struct stack_record when all frames of a persistent stack trace can be
compressed by architecture hooks.

> diff --git a/lib/stackdepot.c b/lib/stackdepot.c
> index 8f1aaa0c6d889..f323f1e97e129 100644
> --- a/lib/stackdepot.c
> +++ b/lib/stackdepot.c
[ ... ]
> @@ -419,9 +422,37 @@ static struct stack_record *depot_pop_free(void)
>  	return stack;
>  }
> =20
> -static inline size_t depot_stack_record_size(struct stack_record *s, uns=
igned int nr_entries)
> +/* Check whether every frame of a stack can be stored in 32 bits. */
> +static bool depot_entries_compressible(const unsigned long *entries,
> +				       unsigned int nr_entries)
> +{
> +	u32 payload;
> +
> +	for (unsigned int i =3D 0; i < nr_entries; i++) {
> +		if (!arch_stack_depot_frame_try_compress(entries[i], &payload))
> +			return false;
> +	}
> +	return true;
> +}
> +
> +static inline unsigned long depot_stack_entry(const struct stack_record =
*stack,
> +					      unsigned int i)
>  {
> -	const size_t used =3D flex_array_size(s, entries, nr_entries);
> +	unsigned long frame;
> +
> +	if (!(stack->flags & STACK_RECORD_COMPRESSED))
> +		return stack->entries[i];
> +	arch_stack_depot_frame_decompress(stack->compressed_entries[i], &frame);
> +	return frame;
> +}

[Severity: High]
Does depot_stack_entry() return an uninitialized frame on architectures
using the generic header?

include/asm-generic/stackdepot.h:arch_stack_depot_frame_decompress() {
	/* Generic code never compresses frames, so this hook is unreachable. */
}

Because stack->flags is read at runtime and the generic
arch_stack_depot_frame_decompress() neither writes to *frame nor calls
unreachable(), the compiler cannot tell that the compressed branch is dead.
In depot_stack_equal(), the early return when
!(stack->flags & STACK_RECORD_COMPRESSED) folds the same check inside the
inlined depot_stack_entry() call, leaving frame unconditionally
uninitialized in the loop and triggering -Wuninitialized build failures
under CONFIG_WERROR=3Dy.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113185702.1332=
171-1-matt@readmodwrite.com?part=3D9

