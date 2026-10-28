Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C40E1606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EceVUvxL
Received: by kanga.kvack.org (Postfix)
	id E80F86B05B2; Wed, 28 Oct 2026 13:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31916B05B4; Wed, 28 Oct 2026 13:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D47BC6B05B5; Wed, 28 Oct 2026 13:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2E986B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:09:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CE9A1401B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:09:02 +0000 (UTC)
X-FDA: 85372670124.16.0752147
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 02845100004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:09:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EceVUvxL;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793207341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mzc7Hanv0CDK4THhGHtewy5AYoBUPo6jlbuGdSqeuHA=;
	b=U3rqdXBA1ydTcP0GG4tWgj9YTyQu3yt53jIglT/ZI1PpmgzE4zUWp2kGvvwMPia2an/FZb
	/maakcBBFFHos547EB0aSPs+oikRpOLtWbTOFt8SCGcmuQU7A78275/B33WUwENanNIWSd
	4s6H3ba2CYkcDBHAjD4CTtkSTnt0NZQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793207341;
	b=VU7XCRw54Y7TMS+hb8e4Pd8ZAam5w+ZUjCcT/Ex20ajzZLa+YlCbKEjMp+HpADs4lQLZkF
	/rU6MfYyhnsqnzYqAY+W5hZQsMg9tNwU1a3S8n86V6Lbtn30kFcWFt12ASZyyrXUm7GP16
	5n9E96Hw/ROA4zfK8HMZ9Z3Ez46289U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EceVUvxL;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73ADD600C8;
	Wed, 28 Oct 2026 17:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17901F01828;
	Wed, 28 Oct 2026 17:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793207340;
	bh=mzc7Hanv0CDK4THhGHtewy5AYoBUPo6jlbuGdSqeuHA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EceVUvxL1OnZids3GRqeq1btRudotGLxGnTzu4CsVMZohND9PtMu9iepxejI6Lc4e
	 lCb+8Gpj01vLylCaE8zNKBJpXIXHsq8qJkTbTCuptNXWEyA7zDptDe1LKby7gYWd+U
	 5pNOxKOAOcEGtsuqqVSOGWGRKrlDwlSrlfvaAfWUMg+Df399cbWJPxKeiRU9M6em+3
	 YT4JnocZn3WzwtlbylfValFVt7mnMvqooGXe7CuDLeahKeCebD01bLSFFfhq+la3dv
	 nkl6EQigdTw4PjDi+Wp+Pdd5BkI5DtlSMnt+fUDuONmDt2aat+HgAm3JXLIi4ChCp5
	 X7T1w9wWUe4eA==
Date: Wed, 28 Oct 2026 19:08:50 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	sudeep.holla@kernel.org, jenswi@kernel.org, robh@kernel.org,
	mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org,
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/8] memblock: Introduce MEMBLOCK_PTEMAP
Message-ID: <auIsIp-nKJokYmry@kernel.org>
References: <20260921110050.3977591-1-vdonnefort@google.com>
 <20260921110050.3977591-2-vdonnefort@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921110050.3977591-2-vdonnefort@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 02845100004
X-Stat-Signature: wkcsa1e48kiqa3uphd55zx7z3ibaezia
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793207340-286038
X-HE-Meta: U2FsdGVkX1+yl3MiS4sWEaqfpCYmcn3hvEXyqa/OFyLfME1ukJDckpVAvWmjfvwurIVd5PJVQR/6Aw4OuVMT96AG85+5Besg1zAoeqnECFLVh05atVZEYLg2+3P54oqZsS+MMUWcPghR8opD3kQx7JE9Gff32uoKUkxbzVIYB8ZTO763dOlZBKmuhhvP+0hD0cgRSFkKq5iW9lGYIABe7wLzloP07OEx8zlWbuJihhEbjuv3XacQzL8JRIKodE4Ud3tV12JrIiarXYNcdQSqR47EAw7boPvlIukQxjrlzbsbf1fkQuKfeLcRy4GZjA4x5Sz6hRQ3upHswMdy1v9nhyTwXZag/DwdretsAb5a8kPsZTk8gaARmyNoFZF4DbTf6mhrBVsyGlaPTw0PsMoCqiMhesCPrb8cc4ucTiwDhS/Thi8M3Lszxhw8SHcGXugZxabpnjvCIkTJTjxZe0K59QZYvL90vW6coYCqSmLsihQ+CgsKN6IxI3x2eWYdpHCGP2uw/7NsulVfINKVA47Hrf6gNtjNPV7XenBlrKBXYTrsr5gPS0jXQkiEII4vPKfuPb1gE/GPF97HamNleUFX98xUx81ktcumFTKd6Nnc5e3zuQk1CzcrNFnpuedQ34MYQrys/Y6oN6Ri9x5oSYibCrjZOE7hcpOcpX8mcVjdvFoNjIoxydheIgommjB7PEy0wCdO9QWUqhP8NAACxSiX1hwOGfMZAcsVR0z38sW0hgyj/Gt+XxYtmOsOQDc4gcS5eihUA08MIpOww81fnhM3QJUQm2Iwpja9QiG/JXSW5QzThyPti1C/tW+k9FA2C2evugdc6WUeTdBWDJHjlLUhK8wm/b/KGJ72nalXb9QqYEqToqkquZWZHKRctyMN9qN59sJebCmHXWcFZk9SWX/KdsVvUt9X3522i8ml01CiwnDyoFoAkyFmiFjNy2hx3WS7ZAWu2+5dh58faEGF+6H
 UPvjB+BW
 1evr4rJsmoMVg6R279W+1z1NkdiGQiArP2eFWFFTsDw9/KjxR8MjQwMVIxgeJIN3kTMpLjLGLvJiTStgQWcra513wA29j1wEAraW+u9bqhjGTOBODS0DguPCyAk2QhKMWtBmtAaIoL4tG0bB+cbhJHnqepOb+wKh/LoqsNa4bKL1BhacS6pUSAI4qJo8i4SmtlApDMdVRxb2H88lck4hNcihgsa8t0UFLGcnJIuw42LWoorB3JnI8j+Ze9vbA7jJ9a0dbHb2iRWm52EfJWTgVIsSJ9Dfg7+xExH70onjFsCvvFIWcUqX5jHKdGqEyJsaD5VYR8p2+1oTZH9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Sep 21, 2026 at 12:00:43PM +0100, Vincent Donnefort wrote:
> Keeping PTE-level mappings is interesting on some architectures as it
> allows mapping/unmapping pages from the kernel direct map without the
> risk of splitting blocks which, under the break-before-make rule, may
> trigger page-faults the kernel can't handle.

Let's be honest, it's arm64 :)
 
I believe that some powerpc variants could use this too, but they don't
have break-before-make, so either "some architectures" or
"break-before-make" should be rephrased.

> However, mapping the entire direct map at PTE-level is costly. So
> instead, create a new memblock flag MEMBLOCK_PTEMAP to selectively apply
> a PTE-level mapping.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> ---
>  include/linux/memblock.h | 18 ++++++++++++++++++
>  mm/memblock.c            | 30 ++++++++++++++++++++++++++++++
>  2 files changed, 48 insertions(+)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index aa845f488327..13263055996d 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h

...

> @@ -285,8 +289,16 @@ static inline bool memblock_is_mirror(struct memblock_region *m)
>  	return m->flags & MEMBLOCK_MIRROR;
>  }
>  
> +static inline void memblock_warn_invalid_map_flags(struct memblock_region *m)
> +{
> +	enum memblock_flags map_flags = MEMBLOCK_NOMAP | MEMBLOCK_PTEMAP;
> +
> +	WARN_ON_ONCE((m->flags & map_flags) == map_flags);
> +}
> +
>  static inline bool memblock_is_nomap(struct memblock_region *m)
>  {
> +	memblock_warn_invalid_map_flags(m);

I think it's better to check and warn when setting an incompatible flag
rather than when querying it.

>  	return m->flags & MEMBLOCK_NOMAP;
>  }

-- 
Sincerely yours,
Mike.

