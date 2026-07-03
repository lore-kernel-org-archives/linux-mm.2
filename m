Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC83CC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22E06B00B5; Fri,  3 Jul 2026 13:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3A36B00B7; Fri,  3 Jul 2026 13:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3A66B00BB; Fri,  3 Jul 2026 13:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8ED366B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:11:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 125BE40230
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:11:59 +0000 (UTC)
X-FDA: 84948107958.21.DB6A666
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6F9F240007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:11:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=KYlDRCMj;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf11.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783098717;
	b=kAtIshiDYGFpVXgOowb1dcYYf0xg54TTSHV6ay9qxZAAEhtq2bL0o4iws5Zuo3V/1hElsL
	y8NZKx4Cym+0Xi1snrvSRg/MxWeYChUvBSHRA73frXf91RXZdyBhMVO+FfRDAcpl09rDvk
	3TW1PsJKWkMQgwqmLDZld3xdqgxigCY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783098717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pb7TrLeGqe0b/bNAlrMgjLIiLoh7aG16nEZVkpvvbWA=;
	b=f1nlxe4BAm/KdAHHcTeaN7MwhlNPlbTcbQjOtTuD9OHYGYUnkTi69+Gsz25+OXw8fqZpcO
	pgzEjthHgeyjzTTtOHiLqFwT52v7e+Mtj5f9XVmG7vwxZ/Xvt8dqeNJZwwRvODwJ/PBsqE
	LOltT1lBEtlBatRn4y3p+hwFYK63T8M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=KYlDRCMj;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf11.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pb7TrLeGqe0b/bNAlrMgjLIiLoh7aG16nEZVkpvvbWA=; b=KYlDRCMj9Z9aprfDoC0OuuVSUt
	aAt90CVAPXFkHFoG5hzBMuAaOMFhnK4O6WYD4bQ5KjvqtsctuFQren0WOJHa8Z3MKEOwD8xSNWxbD
	l+Zy2RkUqkCwYo9oltROgpA4pkfi0CkGZ5KT513lP/g2lv+35+LQGW3hNsANPA0ToQeNN0sEgZpGN
	xZpH2+pbgnWw473psp1hwBauahFCEmIYkhPDLNZdOHAM/sXqFheIjqSNkEtLrGEiM0QvX2sFxdPqy
	aqL2jhscx5y4MjD7KZd2TFmkTyPqZdp2oMrHXb2ZPjnSKYUzBirMeSDCid2bzcKtpaRyd4nnkqFiW
	/F4hDR/w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wfhQZ-009YIE-2C;
	Fri, 03 Jul 2026 17:11:48 +0000
Date: Fri, 3 Jul 2026 10:11:42 -0700
From: Breno Leitao <leitao@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, workflows@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/2] selftests/mm: test kmemleak's N-consecutive-scan
 leak confirmation
Message-ID: <akfsldIW1US1d69C@gmail.com>
References: <20260626-kmemleak_twice-v1-0-ab28f7cc0971@debian.org>
 <20260626-kmemleak_twice-v1-2-ab28f7cc0971@debian.org>
 <akYkKgWOsYnw6ETE@arm.com>
 <akZ4tzQw70x3RR2D@gmail.com>
 <akeX8mFiizd65pDw@gmail.com>
 <akfNeK7OOpvoZE9z@arm.com>
 <akfYImSNDh3OjIfR@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akfYImSNDh3OjIfR@gmail.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6F9F240007
X-Stat-Signature: qy1i9qh9xk44ycfr4kqbp4ocq45gbwn9
X-Rspam-User: 
X-HE-Tag: 1783098717-842233
X-HE-Meta: U2FsdGVkX1/xeZM/JTt4Hyr6MfbOCLKpBAKV+QbcULaR+kpGJHxkVfGnOrTapqzoOY+9rpXcfsXYVx77tAcUKlnVisBYK1bSgxSJqoSEWBbOtftSNknUrTymeWwf/6tpy0cQs/3otZIJAvmBmiJU4oLlAYVUdqSUlvskRBt6cimMDMncc4w3+8KspCKTYTA2psuL2XLAkThT5lG24+rGEaouPASyyXKYQJOqllB0gHu4XeRGdBZmSTTRLAbaB/VqgIBUlsJL8J7vsBUOATKyKV4StCVjVWQBxoLXZFSGoERueRwON7GgkPAQ6ermjp9Aa+FSb00RJDdF+LVaFX7XKZLNX3WzWQrN/wor1ON1/qGJvpo3IgPfX0dA5WXUNCxUytbOYK0HM8cjQTlPRqAoLpzY4dLgJXCc/R+VMrjdEguvoBvOkczP2qZNCozqgtEIRFFKuJ+ppTvkSfx5nCMNTGN/TfyKdLa1qs4lvab2G4wmYDkzKe52lQj+VLNlxKrhaYqt7I3MtzL0+emnAEPJ8DGAJ4+DgcKamTmkI3mIvCdRnyclmqFQl6j2Za2bAOyOGGqJLwGFnPqzjH8/x4miOiIdOd32JDAwblbg3b1xXlCmzLe35SpFnti3qo+E6Xd5r0Dxw4X2a+n0j7Mvviwutl/IFPrSUbIknrWtGsi1RROhHoBS1Yo5MxqEmwiwgNTtvsVTCxrk98CU3QzhKUPo2f9/mKCEtu9a0tD+E+osA9QhPgwvEsJFE2mQObcfxUPWIXY9dZ27Mfmw1hxEl5T8lvW/DgN/eKIsGLRq+m6BRuude5O5MoqlxVICjjHJT++ZOm4LL+pYM/saYumKFAj71001QUZoYedXPvPfQM07apzia2CJdqXC17G+kH7800jy3jD2Qx/BFGYvTzsTtYW+bYiYfi/y3091WNtqY3pptXm4MszZ3d/E75X2UNNU9Nz84IxV5B61ZfmjMvraQFU
 vDFrvOpf
 8BA7TuSOC+7s+22Qr800ez/NunVNIiQugm3A52m/NtMVmNhVzIA56XdGZ5y1cKVBbsM863R2EgAVquHkCRvFSxZMD+zSuGXZ1JgQLk7qpyFxz0GiXb2xfqwHzX+vKzM9RzGkySCwv2Mfp7wXmFd+UzVqARQJh3IwjcrOIKw5vFs/eG0mFREaFQrOmTaSxVvGerAxRKRrV8Ss/kZSi4ptD8Q6UKLXAgs9FYOkAuW1Br22oCnNjBLOHCZjiv5r6/CRoTfrt+3Ft3aVSQzii+EAT4X0rbcegTg+UhS1m3HbMU8f8J3M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 08:43:27AM -0700, Breno Leitao wrote:
> On Fri, Jul 03, 2026 at 03:55:52PM +0100, Catalin Marinas wrote:
>
> I will spin this "fix" separated (CCing stable), and send a v2 for this
> selftest with priming enabled.

Quick update on this plan. The v2 for this patch depends on checksum fix[0],
given it touches a similar code:

	@@ -687,6 +692,7 @@ static struct kmemleak_object *__alloc_object(gfp_t gfp)
		atomic_set(&object->use_count, 1);
		object->excess_ref = 0;
		object->count = 0; 
	+       object->unref_scans = 0;
		object->checksum = ~0;   <-- Adde by the fix [0]

I will wait the "Fix" to land first, before sending v2, avoiding merge
conflicts and being able to rely on sashiko to review it (instead of having merging
issues)

Link: https://lore.kernel.org/all/20260703-kmemleak_checksum-v1-1-5e0ab7d6966f@debian.org/ [0]

