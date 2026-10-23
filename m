Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B728D606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 17:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kZzeyvJo
Received: by kanga.kvack.org (Postfix)
	id BEDAD6B0BAE; Fri, 23 Oct 2026 13:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6946B0BB0; Fri, 23 Oct 2026 13:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B039D6B0BB1; Fri, 23 Oct 2026 13:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EB9C6B0BAE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:26:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A244A6EF2
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:26:10 +0000 (UTC)
X-FDA: 85354569342.25.F63318A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id EBF821C0007
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:26:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kZzeyvJo;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792776369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XSow9JMNcB3KaezVYp2YCCd7nh/RjIrlw4N2iZye4G0=;
	b=pfEaaBj7ZKfaTNVmrVCWVhiACcAI5Qj9hNKiZz9ENOK/F2EvOBpbYW/mW4f4LW9P0d12BY
	DXeeFrSqtyTjIA66SO+RGuZdvT+aIYYG/raJlehbTo/4mo9q1RnCZ5DYF03eujaHxJ7bc8
	VSbcmYWDqmr8LE9njhu11FazRClAf2A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792776369;
	b=BRTvSbUePIfHjMlZwMro5T6at5+3NPkirxxLhSntnU0l8K99JjphTLoxQgYAkbA2MsqIfg
	4EmGXwprq7URAVPOoGJTVWlgZ7eqBJNFbW7vVXPS2YKVXHMLdSXIcfnRCv/bUPdsn6yV+C
	JYHqO+/Ftcbjg2YNCIbpfz1aYkuei94=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kZzeyvJo;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C41B443A44;
	Fri, 23 Oct 2026 17:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705031F01825;
	Fri, 23 Oct 2026 17:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792776367;
	bh=XSow9JMNcB3KaezVYp2YCCd7nh/RjIrlw4N2iZye4G0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kZzeyvJoosy+DyY4nymYopIcOBr0VaSKdfDrpMhVmfJGEJ2SbGb/ivCBsMdOgD0c7
	 XqCaO1wpHXX4Q6ERUFtBIWUUyMgo6P0CKjYYiurs8ynjMTmbq+cLXy1aK3/gQmdfTy
	 HaZyIDtFwKciOD3g8uKAJusaOOX7DxGyFUBaU77s=
Date: Fri, 23 Oct 2026 10:26:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suseendran Bhaskaran <suseendranb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zswap: validate dlen and normalize comp_ret on
 compression success
Message-Id: <20261023102607.7635885be12b0b6e7a5971aa@linux-foundation.org>
In-Reply-To: <20261022232734.496064-1-suseendranb@google.com>
References: <20261022232734.496064-1-suseendranb@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EBF821C0007
X-Stat-Signature: za3c85exabwnw8y9hsapmtemf5h1j5nt
X-Rspam-User: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792776368-675906
X-HE-Meta: U2FsdGVkX1+vXcPq38iCfeP0BUysZTQCpAK5Y5hIGa451hZdu6cF2gOY02qGnzlxKPPlTehdY+l8ObaZbUkLArH2oRfB2k1yPNgOi/HV2dSCHKEou6I6OnaPqwCmxPjiaSihGzVizU99BBdC+nDCzhErXTIah3LolvuugvIBQ2QoSJqKCwcnKss9eXShUDH2/JFCPY9xXuEeT0+corYsuihaNYDZMPZCEZ+wiCFCT901UIlb6Xoa5usCH0vAs7DVrDQv20WigPfdlsoOyE5PUjsFJIm5YRYbOCYOirSRynXD4mp52QEG6ZPVlHl5fOZVb1pLG9b9S4+zBHIFf58s/1dGVs8lJRsrUZADdHPMafc74otXoMRJdMyQDnqmeJZ5x/jJDGOeAenAOVNmwjQzzHyhnc2duRbDIJgN4OLq1lsAf8TvRBOUeeiqGgc4VFpJ5yUkT11kJYfSG10qXf30th9jzRaz2iULN3ewvB7FjAG47p/E/NqcX3hC3+rg5TMxFFbi38vA6sGnGKcKCnlcOqR98HZe93wqLsx2If58bVZRZAuzJDRyb7229gVRWZ4K/btkMweYJ8Y8ElLhd8axMvsi2lkthe+y1xZ+7E0U12bnpIgeVI0VCO67cmLR+lqsNAqRDlwLNoRwNJ6SNyLyj5VJAL9TU42v6uP56X62oA7Zmz6sHK9tylGJVDmzCt8EmQenovWdeDlheoVQA48FeRk4rSb9btVYBt9qRBPtQKdeg/iGzhSKDqnht3PO/0jmMSyL7DCc8Xa9ni9XFpwv2Q1qRmeqV2fmOPuJn+3BOmYvhCSupHHLlb0UrM9+yU7RhyeJxmfBjC2jOeS4GXsy1m6xEILHv3mCQwdUqdOEthCVpbJmxYMxfXsdchbm8+cQuvpWk79UoQWA4+TZCiEo4z1IrwKWcpFkgLPCR9qG9NP0ovIvEjG5drxJ0bLrVMHIXvXHaDTKQv/2PLsI1sg
 tm/pu+Pc
 sAmD68NXCc0R5POcIu7zEE9Xnd62GyuKEFY0ODiw4gekp8ND5KEF3/v4xS5F23E06PjamSXPUVbHvNFa+6tDGXV6kAaoNNotYPGZoNBWaxafJEWiw1OR0XEgMNNI9Sxw+36qdLhUkEzbTf067suIyfzUQ8SPueOMBEACL5guX/8HFgHqte6sQBEm2XxYEphFFFiYu3DS+bBlZXLZUHTmcWN9V9qAPrwjmBl5fVNKtGMLeg+J+xmGH4cL/FzcIusS/px8TmwQdI0vwNjnquRver0scl+K29LU52Pmu0yHjIzi/XKc9WsF4Bg0/fj/ZgmKOZMoa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 22 Oct 2026 23:27:33 +0000 Suseendran Bhaskaran <suseendranb@google.com> wrote:

> In zswap_compress(), dlen is only meaningful when compression succeeds
> (!comp_ret), as compressors do not consistently set req->dlen on error
> (e.g. zstd, 842, and qat set dlen = 0; lz4, lz4hc, lzo, lzo-rle,
> deflate, and iaa leave dlen at PAGE_SIZE; hisi_zip sets dlen to the
> hardware-reported produced bytes).
> 
> When !comp_ret and dlen == PAGE_SIZE with zswap writeback disabled,
> zswap_compress() sets comp_ret to -EINVAL instead of -ENOSPC,
> miscounting the page under reject_compress_fail instead of
> reject_compress_poor.
> 
> When !comp_ret, set comp_ret = -ENOSPC if dlen == PAGE_SIZE, or
> comp_ret = -EINVAL if WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE). This
> allows simplifying the failure check to 'if (comp_ret)' and dropping
> the ternary assignment in the writeback-disabled path.

Sounds like we're complexicating core code in order to accommodate
inconsistent compressor behavior.  Would it be better to

a) design the compressor interface(!)
b) document it
c) ensure that all compressors comply with it?

Maintainers may choose to go ahead with this as a backportable
quickfix, but it all seems to be a bit of a mess in there.


Wht you forgot to tell us (please never forget this) is the
userspace-visible runtime effects of the bug.  Autobot says:

: The userspace-visible effects are limited to corrected zswap
: statistics and a new warning for invalid compressor results.
: 
: When compression succeeds but produces exactly PAGE_SIZE bytes, and
: zswap writeback is disabled, the page is rejected as before. However,
: reject_compress_poor now increments instead of reject_compress_fail.
: This makes the debugfs statistics distinguish incompressible pages
: from actual compressor failures more accurately.
: 
: A compressor which reports success with a zero or oversized output
: length will now trigger WARN_ON_ONCE(). Previously, zswap handled
: these results without a warning. On systems with panic_on_warn
: enabled, this could cause a kernel panic.
: 
: There is no intended change to which pages zswap accepts, rejects
: or stores uncompressed, nor to normal application behavior.
: 
: I think these runtime effects should be described more prominently
: in the changelog, particularly the new warning.



My autobot is all worried about the HiSilicon ZIP compressor.

: I think the zswap-side fix is reasonable. On success, dlen should
: contain the actual output length, and zswap should validate it. On
: failure, dlen isn't necessarily meaningful, so we should rely on the
: compressor's error code.
: 
: Separately, I think we should make the compressors consistently return
: -ENOSPC when the output buffer is too small. Some currently return
: -EINVAL, which means reject_compress_fail versus reject_compress_poor
: will remain inaccurate even with this patch.
: 
: A compressor which successfully produces exactly PAGE_SIZE bytes
: should still report success. Deciding that the result isn't worth
: storing belongs in zswap.
: 
: One thing worth checking is HiSilicon ZIP's negative-compression
: status. It is treated as success, with dlen taken from the hardware.
: Could that produce zero or more than PAGE_SIZE bytes? If so, the new
: WARN_ON_ONCE() might trigger on ordinary incompressible data.
: 
: I'd take this fix independently of the compressor cleanup, assuming
: that last case is safe.


