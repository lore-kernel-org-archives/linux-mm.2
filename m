Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AEE4EE0AC6
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 10:10:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67BE36B0089; Sat,  7 Feb 2026 05:10:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F696B0092; Sat,  7 Feb 2026 05:10:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527D46B0093; Sat,  7 Feb 2026 05:10:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DE5F6B0089
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 05:10:13 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 834D8160417
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 10:10:12 +0000 (UTC)
X-FDA: 84417240264.29.2C0B4C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9228FA0002
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 10:10:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bLFlcVB5;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770459010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x400cLiV2cN92ltvwm2uynYmE8aYt8MHC7TnoFZivow=;
	b=HEYfh1dNH9sQPabFoqiPp83HevK/j9BguCsj5k5oGCIHQIwPbjoz87U2giLvqqIedmNhiP
	eRqgc6SC01zjTxCNq1vSRZw4UU24/vejwLO0aiWdhXfty/7jI52p08yFAfveJrCd3Foyrn
	snXvnoRE6neBdfDrsfhooFYivi9EGCg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bLFlcVB5;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770459010; a=rsa-sha256;
	cv=none;
	b=eiO+53WW/ZYc4AYSkb0qWMjG9D1hpUJBaJdTZprfgrwWCZbHfxfKlF4N7TmW9wJjS0z7YI
	o7htvldsaD6AwGfhKKF+MCvkIuI7UzJJE/RSPcxnfAKAerZdRV1+o/2GNJgcwETTskcqj8
	wXyP3rtIyJMihZhfyENOaILolZapK8c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3ABE3436C0;
	Sat,  7 Feb 2026 10:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07095C116D0;
	Sat,  7 Feb 2026 10:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770459009;
	bh=GOAZobfTLqyNC8py+ywFE3IMr7+g/de/0W0x1Gkcyhw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bLFlcVB5AxueSvoZVkdKqZ1NFfNlfVtk+RKgNeD3ivf++J01WPPCtkE5RmiJG5mtA
	 cXT4yGRSkABVwaQUv0Q2tbOX44Vo89/j5RBn1yX5B5lZArpzXtJEdrHUM0ndWrRq+S
	 mg52sL2ZRTx+oxcPADZt9xercCvOn0QK8k1B/yCXq/Gn0tv2rexkvvOZL2C68RLHu+
	 tGokz0nnxITucndVILFMSjKOcED1FVxJlxkiGNx2skw6KENY2ZY0U9GMRfF3kjP6uK
	 pW0nkD4YE0NFMy7fl8QgKPU63UxpVAz7woeqbnu5NUZhCGxbRCdD/Ie8Po/I0sKBLx
	 RYifb3gslwdZQ==
Message-ID: <9717eaea-9bbd-4612-bc45-c7f85fe1ba67@kernel.org>
Date: Sat, 7 Feb 2026 11:10:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: folio_zero_user: open code range computation in
 folio_zero_user()
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
 lizhe.67@bytedance.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
 kernel test robot <lkp@intel.com>
References: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
 <20260206223801.2617497-1-ankur.a.arora@oracle.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260206223801.2617497-1-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6b4uxrgtaqbpkzqa9fjizjkyktaj6zjn
X-Rspamd-Queue-Id: 9228FA0002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770459010-678171
X-HE-Meta: U2FsdGVkX19Np8eJVDacPNMixyp8qeetFpIYdDYhGUiBs83jLZ97mjgpatmaFpwsP5KklqLryz9UbyWedvtSYvu3dKr/w6C3xSIbaUkMwrFnFnwYlpo/a64mRmvRLEeknhut0Tkey0dzzATApFIk9XjWibzECA4oRvPzPhC2KBLNRKOhK11Jk3rT3PLH1x9k21d6WbDZ8vgYMbgr6zoUuXwYMC1PgVvOrNK546SEpdAqOgciA3DuwakjX8bJkL+hY9+KzxvlzxQuQTDDoHb7+5uAKVd+upJ4hQrbHfsRlXG5F9QVo9EhCURYl0yhSUxRE5/dWwi48563/gz/i5hYYRnOFUTyZuyysY1SupV/LMzG7fVHVexWIB/Cn6Nc+mFiBKnPV2WEgqp9I6lYUWXmw+HJ1MLAl6sD/PPe7EPxgJ8lGqy2D+4SiL1mMdCMIH2qvNpmWMZSsUWiGPynpS97iZVHbECeLBx7DlyhpJX4TbzEizGwhUo3dE7j7Gul1q3g2pAdhuQuELDsF7QeQxMQddeVzfnVt5umXYEYXodIVOktaTX/HhQ39+OhP5ZTxC7hrHYl/LquA/bhY/qLqpaXPSYTqKUT2OZ1WIN34HOrY99sd/OQUubdxWP1QI0xmzd57RAbjRINZn9pOp0gkx708VryJIhgfgsws0YH8XrwkusdJbnyaAIYpbcpI1pTJRrVZeoXDqttyqgQl7rLlCyXv6EYDkP+tlMaf4iZX+uLFGwGGdxoR5T3FpVivXMEeaTFGWlLU7RDSsJMgxTHStpPsBON1TffnnuKFT7jJCBnAwylTLGIOdvG4ZR1J6dUNFAyo8TkH5h3Th9eXWFIoctYcUpgDJxYnMNl2OQ3xhfOLh7OwiXqV3dlOfjUyBDzTUibGCU8s8rLqVDZLx1SXrutxvg1/oAqKGdIZ5ZGyAPA36DAYh00DzZcdJV2ulyFfawyfAGVAW2y32rD6jZfTDh
 IsXaUWGB
 JFogKql5I/l6b0tqLzh9r8aLuBEeN5ibKwiXISY6OLhs09H32AiGqCOnSRkatMRBIeMns44wNiRHTkaCZq+xt1PqswI+gTt5HNK2Mq0H1QtO2qLlb7L/R+e29RehoLNAdfENi0vnxzv2KYDUnkbaaPaHqmg6BpCaU38nvOAkUgLLDV3Xkt7XLraIdpGCHeKWiu2tarh0ITtdTmLZtqBvyMVSflCXBdRKcj7xo79xJOovz/FU2wZ4GEAQQ82JDMWqr2CTRKxQdiSq44DN4Tz7F7gcoCe6ZVP5NKpag4rEqlnwbdTWaR9ooKU+mHlzdcf/JQT2VJZK8KY+nH654Lkk6GXqzuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 23:38, Ankur Arora wrote:
> riscv64-gcc-linux-gnu (v8.5) reports a compile time assert in:
> 
>     r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
>   		       clamp_t(s64, fault_idx + radius, pg.start, pg.end));
> 
> where it decides that pg.start > pg.end in:
>    clamp_t(s64, fault_idx + radius, pg.start, pg.end));
> 
> where pg comes from:
>    const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
> 
> That does not seem like it could be true. Even for pg.start == pg.end,
> we would need folio_test_large() to evaluate to false at compile time:
> 
>    static inline unsigned long folio_nr_pages(const struct folio *folio)
>    {
> 	if (!folio_test_large(folio))
> 		return 1;
> 	return folio_large_nr_pages(folio);
>    }
> 
> Workaround by open coding the range computation. Also, simplify the type
> declarations for the relevant variables.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202601240453.QCjgGdJa-lkp@intel.com/
> Fixes: 93552c9a3350 ("mm: folio_zero_user: cache neighbouring pages")
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> 
> Hi Andrew
> 

Thanks Amkur and hoping you'll have a nice weekend!

-- 
Cheers,

David

