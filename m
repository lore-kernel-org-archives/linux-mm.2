Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D850606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 10:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZNFcno64
Received: by kanga.kvack.org (Postfix)
	id 802D86B05B0; Mon, 26 Oct 2026 06:50:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DA156B05B2; Mon, 26 Oct 2026 06:50:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F04E6B05B3; Mon, 26 Oct 2026 06:50:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B20F6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:50:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E36C91C400E
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:50:13 +0000 (UTC)
X-FDA: 85364457906.30.F0E4252
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 32CFFC0002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:50:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZNFcno64;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793011812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DY0xynj2BuvcQfpKNa55nqUlTfhCGDJICJ4nB0KZOrU=;
	b=yxffTodF2iicgoZ9Nl7xIycpDHYYVOgUJLtMmIozLj03DtIUxpCY1KG46txX3jCjffywn0
	hCeXwYjWlsYw3vC6WNyrVay2oRVa2wSiGK2OsHv5AzAKiRbosd+1EkMwHClHoz+/dUiTwj
	J28rD/s3+QCG/VD7pTi7raVRfXNSh10=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZNFcno64;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793011812;
	b=Es/isMoeU4ah/QLjdCn68F0DHPgz3+i4Lt8DPcMORns5BTVIXVpnlHM0cmz9wIfE0x8f79
	BH0+OaYA3Q874YTBVBCbeATuRXITml6vqZBp9YuFFuCjSdJGIU4HaqJ/mj8zAu/5THDn1L
	IrIvLfqEQWU1bIgAotrCYDiS6+bBcbQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AFBCB60A54;
	Mon, 26 Oct 2026 10:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FE81F01825;
	Mon, 26 Oct 2026 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793011811;
	bh=DY0xynj2BuvcQfpKNa55nqUlTfhCGDJICJ4nB0KZOrU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZNFcno64kcHcB3X4mVYYrxBv6nlifsAlqGJwZNpBSt89J4pheTzEFoPBx8BP+zofr
	 bPQqcGJFRbvVc985BAtUDlnk+BrJp2u0Kb1izuHqHiSZGuhXGsINGHIRWwnwuPYfN/
	 E8NIXTXtMAkqWs+VuMMyEAmCvDeX+uppHya/sZ1qPAYBavFbrfhS9LZHa6R0+/8Uao
	 3DmUVVx90fJ7JBoYn0vVeywHxkBpBWxVW8F9vaQ/N2CYwVfQCIawH9oZ4AP3E5LJgq
	 r9lCBAqTGt/YUYsnZif3SUiyGnC7bii7/H8bQh0gw9kzDJq+aqbwJpoa/hhnL/KEtj
	 EQr9PhCLWUh4w==
Message-ID: <fac8ba4f-1437-4510-8a9f-1257b2c8f350@kernel.org>
Date: Mon, 26 Oct 2026 11:50:04 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm/vma: avoid losing atomic VMA flags when setting
 sticky VMA flags
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Davidlohr Bueso <dave@stgolabs.net>,
 SJ Park <sj@kernel.org>, Kees Cook <kees@kernel.org>,
 Colin Cross <ccross@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
 <20261023-fix-vma-atomic-v1-4-8ff4fae1fc85@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261023-fix-vma-atomic-v1-4-8ff4fae1fc85@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 32CFFC0002
X-Stat-Signature: h75corsi3jkkqrcyphuahmw6385qbgbp
X-Rspam-User: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793011812-993444
X-HE-Meta: U2FsdGVkX19HrBeC3ddJKwQlBxhI2KIjM1grEFJ27BZ8FhpguCn4PsPH/QWNerEtUTD8323kjTogykfIyxRpIqr9Ay9QlXG2BCcOQQnOx2AQUk3NF7CIccd2KhIWrFLTo06XIkvDSelhhDNDjDywYvOAPymx0CLcbDS1EqdPC66S0M1JDMSd+LyzFydijbB5y82ZAMhaktnvHv9WlSFMWTWnvpXc5aF4uSlP2KEzz+PbM8SnadodSsOArWABdni4Sb4r2cy8psE8Jy6li+pGbOCbKpCl4z2jVJDMVkoSirMcUzZFvpazUJCgjSHxCQql+4nbvvCu+zDmadIJ74LEO24kUZZU+MtM7dmy2p5P74R/TOTNkRFSpk4isRg4zsEEjU9Kpr3dL9SDObEpQAbgsTgnYaY2X9c1AxzVaWHgdl7KVoBaHVks++rsBoxUK26zqGgWxaB9qLzFpFrAmJWMwn846pqLWhSTrf1tWw5CCgU5qGu5/JVtyRsP1ev/zsuAQQKb/swvK+z52m3Ka8l3ENxa/82i7DQffEyRGojm95La8tHAPgCTXCDLrbW03NM/msuEJK38SfI7fjgWUZDLEByKYeVOugi3Saa/AWrQXz6VBw3rPvcEP+pKEzXixYgs45+je3GMtnpNsZoRSXX1RYrN9ZMy3U+Yj9xCrXc0YpduIyTF0csyORbgGeepbB9rCSs+LQRZLmC/hRM1hS8itrq8Z1T/KJzZj0DrF043LnHExkFtYsyzqdQ9euiYV3ztkkBG7nzwYhck6dFrMmVo3cjOuED/ixepwWoHNTl7/M0EmbFQkhP4yIG5lzi0qBuz9k7N0s7e0WrYKEVZ1nla3fpuTOT72pPPfgWlhD/c7g7SqEwJkHqkqaaxvocudWOnV6jv9d4HxzMT7z2xqsNyTYNnosclrlzKwN5HZkG0iVb2i91j4mR7i8ABoPYPcPWf4H1IuTMnE1HIqWQtfY4
 JFL/ruQE
 CwNhSV+M31od/p1nVOjoAyoheHntzhaYFpkoz3tfI3mLv/7wW2Ai6WcjMRK3UWPJ+t+prae21WRCb9rml8YkVnMAPW/RYrEQA41ZPSiVUGlBFr+gaqr7oCbAnx4NEB197uwdBq7qLc/vSLX2bdczwDKmnW/n4JLgtTEQPfHp0Ah6tK5P1jCXqLN3cBZjyfW7eKSmxQR+9jABgZ+jJyRB1JYv2TNx9M0gedcvPKT9BafIREOpihy3mdZIc9HQWnnh3ZJMJpBX3omlYT36zhcqdvHN+ouQsaI0UXvM/i+KJJZARmpjb30faTEX7GMEkn3H3rQxy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/23/26 15:47, Lorenzo Stoakes (ARM) wrote:
> vma_merge_existing_range() merges an existing VMA (middle) when its
> attributes have changed to match those of one or both adjacent VMAs.
> 
> Sticky flags are propagated if they are set in any of the merged VMAs. They
> are initialised from vmg->vma_flags, which is assumed to contain middle's
> sticky flags when the function is invoked.
> 
> However, the VMA write lock is not held for middle when they are first
> populated, so concurrent updates to atomic VMA flags may occur, which will
> be lost upon merge.
> 
> This can result in fork failing to propagate guard region markers and (if
> file-backed) THP collapse discarding them.
> 
> Resolve this by propagating the sticky flags after middle is locked.
> 
> Make life easier by factoring this into propagate_sticky_flags(), which
> treats vmg->vma_flags as its base (in case any sticky flags are set there),
> updating it as sticky flags are accumulated from merged VMAs.
> 
> Also update vma_expand() to use propagate_sticky_flags() so all merge paths
> utilise it.
> 
> propagate_sticky_flags() also asserts that the VMA write lock is held for
> the VMA whose sticky flags are being read, with a comment explaining why.
> 
> Another means by which atomic VMA flags can fail to be observed is when the
> merge is finalised in commit_merge().
> 
> rmap locks are dropped in vma_complete() before the sticky flags are
> written, meaning an rmap walker can observe the VMA without sticky flags
> set, which can also result in retract_page_tables() discarding guard
> markers.
> 
> Resolve this by assigning the sticky flags before dropping rmap locks,
> factored into commit_sticky_flags() with a write assert on the VMA being
> written to.
> 
> Also remove the vma_set_flags_mask() invocation at the end of
> vma_merge_existing_range() as this was introduced by commit
> 64212ba02e66 ("mm: implement sticky VMA flags") to propagate sticky flags,
> which is now redundant with the introduction of commit_sticky_flags().
> 
> The vma_set_flags_mask() invocation at the end of vma_expand() setting
> sticky flags only is also removed for the same reason.
> 
> Also update vma_merge_existing_range()'s comment to reflect the fact that
> vmg->vma_flags gets updated.
> 
> Finally, update the userland VMA tests to reflect a previously missed
> const-ification in vma_assert_write_locked() which would otherwise cause a
> warning when building them.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Fixes: 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove under VMA lock")
> Fixes: 49e14dabed7a ("mm: set the VM_MAYBE_GUARD flag on guard region install")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Nothing jumped at me

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

