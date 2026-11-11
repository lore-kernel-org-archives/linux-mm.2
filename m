Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 641BB606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aD/quzec
Received: by kanga.kvack.org (Postfix)
	id 6C2036B05B8; Wed, 11 Nov 2026 02:59:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66C3A6B05C4; Wed, 11 Nov 2026 02:59:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5823E6B05C6; Wed, 11 Nov 2026 02:59:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C53C6B05B8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:59:22 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD2BB1A0238
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:59:21 +0000 (UTC)
X-FDA: 85422088122.10.DA6263E
Received: from mta0.migadu.com (out-218.mta0.migadu.com [91.218.175.218])
	by imf03.hostedemail.com (Postfix) with ESMTP id D09A120002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:59:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="aD/quzec";
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.218 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794383960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uWm7y82K4cFIYnrfAMOIQ14NIe58vu+3cXEtCVfdH1I=;
	b=Q7u7LN3+yOiItlARrhC0YCpb7doY/xlWMKvenNXElfOHeP66Wt2kLs1UHQ8CMzrUzoQqon
	SerxLFap8QCqgzIka5BzfUL5gmm41BNJHujjBp/kZT8r09Ckl8ZQHwF1vkez+LhtJnXaei
	5vYGDCYFsPxt4s3ux4KHMDRA6Ks4dQE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794383960;
	b=pelK34VjjGg40kG+ugK/CXJNZ3QLxQ+GO2NO3aBxsQZGwU5yz1LlMP/C7fWRs9e2wZb1lo
	+D9fQjtxsG71SLvb8QhwllNW//SP9wzafFU/7a7WPXEdn+8GVQwwhZ8/LXXivfdr8lVBvi
	cYkQJoYbuPDDrrdCWUGXi2xo+npxW20=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="aD/quzec";
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.218 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aSKuB+/JcDcpTX/+sgM+sj2du8YsGSehFiCEOSSZUqg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794383954; v=1; x=1794988754;
 b=aD/quzecxlvI4PU329AH8OkhNQE/KmLDr4aQcYl/5YHQkC45ewENjqEpaeGh4+U1OoMepbXm
 OFjKC7ZjUEkUVTgmsJMXiDtF/4SFuSqkMGbO/88NwyaWRmeR06/4P9n3U8T1fURb2k8NYp8I4Gp
 Zym/cu9IPMA1ATDIC/fd0Ehk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id bd0647fec455158d;
	Wed, 11 Nov 2026 07:59:14 +0000
X-Mizu-Trace-ID: bd0647fec455158d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 1/2] mm/mm_init: factor out
 memmap_init_page_from_template()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261110114859.76343-2-lizhe.67@bytedance.com>
Date: Wed, 11 Nov 2026 15:58:57 +0800
Cc: akpm@linux-foundation.org,
 apopple@nvidia.com,
 balbirs@nvidia.com,
 David Hildenbrand <david@kernel.org>,
 osalvador@suse.de,
 Mike Rapoport <rppt@kernel.org>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: 7bit
Message-Id: <27BD7A3D-0730-4677-AF65-7CF0D9207A86@linux.dev>
References: <20261110114859.76343-1-lizhe.67@bytedance.com>
 <20261110114859.76343-2-lizhe.67@bytedance.com>
To: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: 1cii8ub6b57icugxdaskfqhbob7s913s
X-Rspamd-Queue-Id: D09A120002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794383957-452888
X-HE-Meta: U2FsdGVkX1/xozBeVlJ1WCW8O6Yx7gRmVTFHkFaYYbvv8VNZcAEbs0lfWo1kl/O4JF8ueyG4+OJG+EQy9xCJ0+RflZyfjLfR3tnzaWMhWdNeyX6qeyZ+xful5EGXn63BP8aXO0IHE35sKk5KPe9PN+cSu3wFpzxOHB/DS6EomJNisiLw26Qr/3lJkkPd+lPONG0KpTISdAz+N7OsAfkC/MJaoSY9P5qbfWixE+ZYVNpwQ+oNaj/v5qobg9jnDY+RD5dmtcbJCiimI/Tpk94Cjr7ciyGfTue1GSWeaQbCA0f7svc4YBrdrhJjIoyILmKNYsV3dHOvCrXm0/KpvjgigcIw40uXz/mWqXnyKrXtWYhQEOt853fQGz1z2NuWQLANCQ454VstRAljJvXVj94eGs7xLDOmzLeL7dIdww1lit0pvK4c2b8y2RJis8UyfKcGI2p73fb/KUKXkSdPznBYRLYqUTlrFiXi4W+nBqAgQAVfN7xO5DpkTCC2rIHZpCaA8tsfU2L2jFE0+P1T+FVbXiXqAgkPWlrkTj3ksuCM1mwFIjCeAU90E0WQtbV9nQPaafBok9lq9UVOPoYecDm2KlTNJ1eeb9jukzK9i9Eq/Zrxqlfdw7ScLB6WXv7vvz/zJKXIrj+2HenlJbGqK/9+d8ShW6k8JieDx4zCz13jH8tOL8i4fGMALOIT11jPf2he0TMN+WvYiSk7M3C0hHADREpNaK5x/mtcRkRhW52myUDeLLIw1ce3yzcBHURrcmQLQShhVLrD70V3RpN8fMujUaSjNeU6kcQ338wLmUnSkfitL865FRyW1cISLmIdMchtYBKerHIzCiapeC3MUqdG63rCn1eEyzy06+KTZzNQaX38sxpPb+sOA1oAbgSkXO0d5O+XCyO0XV3y0cpk0kkYqq568bEHmbP9tVsbfQgLvzlEd+HuZ67eXQdGRNYl+hJ2G/PWiANmDmXx7XUbTzl
 B4xgLyUr
 cC0X7WkbjeolneDun+l+cpGwrYPUUCHHmJHiUMgoe4QkkcYNIwJukkxDqSQEqqdCfxoP69BHoF4Yk1QbtmsZOfQhlDQ2jQhTU1eKlQ80LN5As2r/vuqzBaOUG7w6kyz+RW9q2S+Y+nK6FG2aq2DrhgMinZOqrm9NRzZGqXv44UzN+6f7GqlEe4+4uUGYrGoSaQ3COKmyUB83zD94ah3Wfth8gNwjHmX8CvAXpRsMB5DfK0dzi5e51c27u4YBLx8czvoGS6dSUhZfgpdMcBPYH/uWO6Bhdr2FID+WWVOmlwE9HN9bQAaO1MNO62fc4cwa3sQYI5Ixz3ZpWFIk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 10, 2026, at 19:48, Li Zhe <lizhe.67@bytedance.com> wrote:
> 
> ZONE_DEVICE memmap initialization already uses a reusable struct page
> template when initializing compound tail pages.  The template mostly
> contains invariant state, but a few fields still depend on the target PFN
> and must be refreshed before copying the template into each destination
> struct page.
> 
> Factor that operation into memmap_init_page_from_template() so other
> boot-time memmap initialization paths can reuse the same helper.
> 
> No functional change intended.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>

Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

Thanks.


