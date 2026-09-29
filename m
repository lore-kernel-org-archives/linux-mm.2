Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0261CA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF7FE6B0096; Tue, 29 Sep 2026 03:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8EF6B009D; Tue, 29 Sep 2026 03:45:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBF276B009E; Tue, 29 Sep 2026 03:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A31636B0096
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:45:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20979C03AD
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:45:13 +0000 (UTC)
X-FDA: 85266014106.01.94FB972
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 56FC5180003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:45:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eryQFDsK;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790667911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VY1SkJGQDmauz4sN7eRcCfUeQO+i8Q4S7HsIT43oUN8=;
	b=D2sZlVFoALUGrC7RJDZT5eZRjQqcDW4rsl/QeSFL6t2syeCpkslu9PdxW4AtcL0cOLpZiT
	5NV4z6Kq+G4Dik1ZH7Ot5QEJit9kV7yl9YF4sOVz62EWrxCvMnKJTBxXRaW3M4aK6a218M
	brMVE7xpUHYb7acy5JgbhkS2pSZJwb4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eryQFDsK;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790667911;
	b=OpQInkAlGJXMWlCVmRcGGH23QzW8vO7DCoBuel6LirYdEp97ydlzYI1GXc3Hu2sjM/+iuN
	xsbKwKmzTHxB0hn+stRbVJOkNAfXo3bXWGj3LA1SjmHlioDz+CDolGu3lmBzetk1OYLILZ
	wf5IPM4JvYcIYd7sk+S7ljADqWD/CCI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8468D411B4;
	Tue, 29 Sep 2026 07:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFF41F000FF;
	Tue, 29 Sep 2026 07:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790667910;
	bh=VY1SkJGQDmauz4sN7eRcCfUeQO+i8Q4S7HsIT43oUN8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eryQFDsK8XbiERSwR84WHNpDMzE5PzW2Ardhk9RRQOYTsF5ZNYAsYUTNwxnrO8IJs
	 4pF3o24oJ+dNKTsPvIBFa7CvmvfCowlF+wh5oBUBDLz4duFK9AGVH8JT/ueUbqsnF7
	 ZQnN9vpmWzdMu2UbSL9dh0S7xy4SEdCFP0/lBfMYZisKxJkVQFa8adh90Jsp+Hdsdf
	 grXSyKGdotmj1TjbtLy7memifkUshjvj+fwdD5gII7wv7AEeK82aEZfO0aX8u+5fRk
	 kHOknkEF+u5bV6GGr3ZC91nkB1aXFNs2e5o4TGWrX/02jSXQmkMK3/Bj+DRvMSofpX
	 Fgok4KIaAKVaQ==
Message-ID: <29717e90-4b4c-4ee4-8a17-20a7b1792000@kernel.org>
Date: Tue, 29 Sep 2026 09:45:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/12] mm/sparse-vmemmap: drop the extra tail page from
 device DAX reservation
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Lance Yang <lance.yang@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-11-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260927025441.741633-11-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: udyiksa67h54ijwppamrc4duu8xeadhn
X-Rspamd-Queue-Id: 56FC5180003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790667911-855686
X-HE-Meta: U2FsdGVkX1/+zf4ek4Td/KZdBRwr3vWy/xWrQTsjjBj9FsHjZQ7UokV48t+TVM5HEUzN4SIqanmRcIz081qfYiR3IQNJFP+IkAuImic+7kR42ZAfNgGQkoK99Xl7Rej+q7JLToorPjWNEPCQjsyGJ3KqYvCLMjYvFMgfXcVqNFO5sT5E/QIYYojJ16NMXSssTpe9lulmOrIdlnJTi1bMvgL/XkhMWFVTeq0FTqdnwgbUKtxv/Jlp0+kljnL+m+hdaocf53dxKIwvqAWl/3Tl3AzTf+sXjr2wonIYKN4yO/pSgzj0k0GxzwOYuwwKz059XbK5fiSgTyHqz3QF3kcEa5sTRSdMnVgbQxkrQlMQDdBbCA7WoRHdSOydnM+/f3ehhJkp42Ul8TFpTTsCAGJZ34Jv95Uv9qeVe36M7B2IzkillnIrfyY/kvqzj0TWbSuXi9xUpZuR2ijQy6sEwMyuyhlSWv9Rnr1kKYhoZVCRoB6xdvUVz370VyU9ghWJaSP6EHkxueDweJx928Rmv0b9i8LhKPT89187EPqyRaJlMMt9ZVkpgYH1Kv/7GkV371GxNNCOOl4+cyXPWjF0fJXYXPiNjOYjp/AexDHzR+lGBYaVUYK7xA7s2WPvVP9IXPbARI9YrLj3F0sytEg+bQZq/Evlp+7INadda4gUNyDK7Jun/kNall6qqCdokaV29mbm1ULfGG7OopIVCu15dQI9tYLJTCH+7hciF5maQGnmFs0dbRQgGDXw3ue/E9mx9WPbWi8hnP6LyLIyI431oRB+wHgRMyEXSajUN6oz1CIVqFHIZg1qwNsloK0Td+AYY+yV+Ajm+XIVW28cVjy4XlSpzsRR4uuIStPfcHzaVvm2QOnEiI9AoP0RvTYC/rHSabr2uwDof2a+kaYFTVxDhBG2rOLaDbMxCnlpdnEIDzSkqWGQOPCoA1fed9qtW1ZHKPMlDFB9+Iz2xzcZZC4Ogsa
 HSMfy0ki
 fAFKHvIKb8Nt0BQR3WrEyNZvOdekjgwz21yOxGLa1e4/bSmrEXro9eLo2HJhIawcZN+xqiS3w0Bn9cUFaMRh2wo9BPaEM05zgVJ93qWbs9hSbZ2gT+Vy7FXHzq/rr5kps7beufpO/ucx9U3+6V+SGXZp0MRiT8lC8bRlpe1p4G5xGc0lo65Sb3a5lVkLzsGM6EGktJh0jEQX8qH1iMZ8uCT3T2/EfRE24qw2EdJQ5PZ05To7hor/3R2vkxdzQRpKg82J5ucI0bIRgcGNJ0q4F2U8qFd04GL2I7lguvfDU8j8EncnfLJ3XRjVwmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/27/26 04:54, Muchun Song wrote:
> The device DAX vmemmap population still reserves one extra tail vmemmap
> page after the head page.
> 
> Drop that extra reservation and let the shared tail page cover all tail
> vmemmap pages after the head page, so DAX follows the same reservation
> model as HugeTLB.
> 
> This reduces the reserved vmemmap pages for optimized DAX mappings to
> one and removes the now-unneeded first-tail population from the generic
> and powerpc paths to simplify the code as well.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

