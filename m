Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34049C5DF74
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 04:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453316B0088; Sat, 21 Feb 2026 23:14:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 400C46B0089; Sat, 21 Feb 2026 23:14:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5DF6B008A; Sat, 21 Feb 2026 23:14:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BF0D6B0088
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 23:14:18 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0CA01B5C26
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 04:14:17 +0000 (UTC)
X-FDA: 84470775354.24.E21FD33
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2DD6EA0009
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 04:14:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nx50bLWy;
	spf=pass (imf25.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771733656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+lOsDmbrLG+37RLcP+i5OjgdDr1iH4MiXfrLxOUmAg=;
	b=476A7cCWgpS+46c3VRSg1mwIhg2BOkV1xCB00yJX9Cv5fCaLJuGjocgzMPvPJIYGY3vlnP
	auqL57B1PxuqyeteJ7eVCTVri1dxnvEMnSSgGOJHkIsKmhJAI1LD8VuFbAphhggwSm0hNP
	7KDaN8LxdqUvhFkbgXBQlZ6DMg/bEhI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nx50bLWy;
	spf=pass (imf25.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771733656; a=rsa-sha256;
	cv=none;
	b=xK9opZu9iVAItiIq/f5gt+X4HKGwIz4m596uCg3FasVemZ5Cf/sK0CC6B+aWz7hWSj93Ur
	9vYWetFUBIP+cs/7FlQqrPjaB5vBWD2fvAfvUHeuwd/RsMXSQre75V5c5f4oFEwrnhvbW0
	xwDOjQv5Lj2hFfgHZicULbv+9uPaLs0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 59ED06001D;
	Sun, 22 Feb 2026 04:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AE8C116D0;
	Sun, 22 Feb 2026 04:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771733655;
	bh=e4nGV4qjxyKzsXnZLO07rEcHKaCZ4nqj/dbjC/wbzzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nx50bLWyBtC33JXvKqxon7Xg0/1Q2tgTcwgawrwEEiZ6s491TBcBCacKw6ZOUFwl0
	 Yvfn+gdFBnaRaYNHvEUBAgwJN7QwBYVKRXWwrLtgK3GjjhtYaayEiUll+QvFWH3dXh
	 r0woYii6OEqRTJgrRraU1WXpzL/8agg6ncXXH2PtQqYN1LrX2GeG20V8ROPJe1lo1G
	 oJ7Jd8BA6stP1dEcn3gVTnRNYwLeXqQimCbKV32XIHfSX1sCHiJGOcE8hciQI/kcnV
	 HA/E5GvbOg+B92ym+FdEN4qpdVaIQfx9RJixLi8XamMk3wknekwwp0kH/bX3/adv9t
	 /h9QBlsm62DfQ==
Date: Sat, 21 Feb 2026 20:13:24 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>, cocci@inria.fr,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Joe Perches <joe@perches.com>,
	Christoph Lameter <cl@linux.com>, Marco Elver <elver@google.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v6 5/5] coccinelle: Add kmalloc_objs conversion script
Message-ID: <20260222041324.GA10695@sol>
References: <20251203233029.it.641-kees@kernel.org>
 <20251203233036.3212363-5-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203233036.3212363-5-kees@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2DD6EA0009
X-Stat-Signature: jt3hnuwttrrxz8g6deejcxjurapo9ok5
X-HE-Tag: 1771733656-171401
X-HE-Meta: U2FsdGVkX19/cl92CX0BpIV1DDOpwo9ydhvULvGTQV6FcaBVV7YIu1PB2MyCpJ607ZMTRjiAFCgFsQI44mTKafKh/0TbuVH5ZNpDdhDF9GnjD2L/O6KEj29hloQVXvCdhGSAW/Mvg8PEkLY0NMz62LlBXBNddjxIdFi9Usosa8WBSHrajX4RjOYwGOj5J4TmsBCGp3DeNNqL1ZjhD0vrXj/DpEJ+1gqqnJsP5EHcCMWz15OKHDrYUFnjRd0+/FDLgNlqGT+CFyn9WQXKvHFjg6FMe8LTq1hwVSHXV0NuirtJf30LfCi5GEFTaS/Qc1NirBCl77Is6q7nvoqDIbHwo7voux6Gio7he9CAAI7rNoGVmGcknwQ1VgzoL5GeLwB3PktA0//WqShYlp9bVEvZM55J4ROwgNJMsMWhaZqQjdMKAoMSjjH6YJyTKMv7deTuZd3HqrzfkUbOqf/0SDOWM23E/2rGLWczgg4WspzRKdELjIVBzLQCFtu55CCXZy9b0xYP6Bszw2cqjvrqBVpe9J+f89kW3tk6TOvxUf311C1VWRfThrp0tdaYLOf7rLQdJ+a4h/hWTol4zOlmgMWf+P2r1CBYxGKSnudnAIKrRDTS8DSjXykNdoSEP4crn36yQZdIdhXHuga4M1mTN935qO7F9K6+zM6AzwLjn6tuFxkkJdutwm1AK2MeyIBaaughAMI9n8nlVu4byyOZfMaKo32zVodI4WAYSBO8bFcvU6asIWP3fQ+6FVpqPeWBiSjifRPCM5tatEeW2jm/xDlXX4LcHOcAOe37zVRhwXcmvSavEr45PdUhW/vbC7Vk7Td9pIBos8egJJ8Sg9rNfJc3EuY+XF/QHZP/e35fNb2iVR1kHuJdLRYwNm10lAST9L8fBRqdRP9sSTgpdDd3frMwWhUfuroA0/AIizEC/w6yhJf7Og6+HAHJc/pfh4qFwl6LopvlkmfSrat9p5gN4yV
 wSAiGPIg
 IKpQuYM2ka1ubu8vhmCTbHl/hauzv22aoK4Ho9Sfas9WAcUyp05yPxoLwjQbx1zDeGcT17WNh+UAetiRu+wSCTQTYUW8Jbn7oilJ5Qir7V53MNOUVQoJJWo1Vq5npCm9XMoBU6jeZl+vdR4+jJNOAWEIIhkHYJeSCvYsEoxjF7BdfjBzvKm6jPJO0gRxg36QaOeiowhozx+bSISMkgUvwDyTS6AmxTr54cMfP2M3Pm8AD6NrG6AM511ONMVoEj5qNkaKYr6tkX9h5KTJB/813I9ptVsY97kLYxwF9SFq+jXIvZAHV4OvIzRveQP3Xgk2eFV0MT/tsYMJCLMmJigx3OxPQVekCzCVWWhi6PmPqlor2S0FiwY2rEdOIQQgFIIf5VmpUTesHIbp2kgZCTcLEh90xHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 03:30:35PM -0800, Kees Cook wrote:
> Finds and converts sized kmalloc-family of allocations into the
> typed kmalloc_obj-family of allocations.
> 
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Julia Lawall <Julia.Lawall@inria.fr>
> Cc: Nicolas Palix <nicolas.palix@imag.fr>
> Cc: cocci@inria.fr
> ---
>  scripts/coccinelle/api/kmalloc_objs.cocci | 109 ++++++++++++++++++++++
>  1 file changed, 109 insertions(+)
>  create mode 100644 scripts/coccinelle/api/kmalloc_objs.cocci

Is there a way to reproduce commit 69050f8d6d075dc using this semantic
patch as claimed?  I spend a while installing the latest version of
spatch (which was quite hard to do due to all the unusual dependencies),
but it complains that no rules apply:

$ /usr/local/bin/spatch --sp-file scripts/coccinelle/api/kmalloc_objs.cocci --dir . --in-place
init_defs_builtins: /usr/local/lib/coccinelle/standard.h
SPECIAL NAMES: adding u8 as a type
SPECIAL NAMES: adding u16 as a type
SPECIAL NAMES: adding u32 as a type
SPECIAL NAMES: adding u64 as a type
SPECIAL NAMES: adding __u8 as a type
SPECIAL NAMES: adding __u16 as a type
SPECIAL NAMES: adding __u32 as a type
SPECIAL NAMES: adding __u64 as a type
SPECIAL NAMES: adding uint8_t as a type
SPECIAL NAMES: adding uint16_t as a type
SPECIAL NAMES: adding uint32_t as a type
SPECIAL NAMES: adding uint64_t as a type
SPECIAL NAMES: adding uchar as a type
SPECIAL NAMES: adding ushort as a type
SPECIAL NAMES: adding uint as a type
SPECIAL NAMES: adding ulong as a type
SPECIAL NAMES: adding __le16 as a type
SPECIAL NAMES: adding __le32 as a type
SPECIAL NAMES: adding __le64 as a type
SPECIAL NAMES: adding __be16 as a type
SPECIAL NAMES: adding __be32 as a type
SPECIAL NAMES: adding __be64 as a type
SPECIAL NAMES: adding wchar_t as a type
No rules apply.  Perhaps your semantic patch doesn't contain any +/-/* code, or you have a failed dependency.  If the problem is not clear, try --debug-parse-cocci or check whether any virtual rules (e.g., patch) should be defined.

