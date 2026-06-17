Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06986CD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 18:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD34C6B0005; Wed, 17 Jun 2026 14:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84686B0088; Wed, 17 Jun 2026 14:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A72526B008C; Wed, 17 Jun 2026 14:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7190A6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:52:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3130405B6
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:52:34 +0000 (UTC)
X-FDA: 84890300628.26.D99F609
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 12E621C000E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:52:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxiFCM4M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781722353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1mhh+jU+SViuEIswUJX3OsTgBu5BICnREJa91OfaeeY=;
	b=pGe2Z7s5Nz1k+CYeEM1ROgIkYwrJp2kcIJ4IWVHeoDU+FyiznraVeRXKoiUoWggYJV04gs
	PK1ZHkKnnkkYnkgwanLUBe6fL8tapWvEsj6/6z/O4lbU6r5TtfGZt6st9IdJYFi3TLsfkU
	AnqtOJXR62blxcWK4XQtt8FW4pN/Q88=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxiFCM4M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781722353;
	b=Hk/8t1hHpCNO1HApxjhjpCnAGkpz+6shGu/47FzrBuNIxm5dt6vhaEbVOCHpGNqNLEE/SD
	YzASKMQtnyJk3D2s+/lE2dpopnhMft/+RBdqXGUC4nT0M1STzld8llmXiVorkOYu769dwJ
	kLrgpi9/A86QnkM9N6GjE7XvegIkEGU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 466BE43BF8;
	Wed, 17 Jun 2026 18:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306081F00A3A;
	Wed, 17 Jun 2026 18:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781722352;
	bh=1mhh+jU+SViuEIswUJX3OsTgBu5BICnREJa91OfaeeY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kxiFCM4MJcV/aLWLoH1cJ+nt7/RWWggSenk4fFCmjRqKAZvgCy7+6/imKq1vuaUOE
	 e8AI9PjAWmFo/yrZNICWmQFM0rhdX3q6BmQmeLX6tCbZD5/CDvzLwx4Qtf+8AXohYZ
	 ZJ/leLAdu9nmSxyrDHOYm5IlNEYT57BUVCFlLgEz7Ts5sSOUjLNgk6pnhXhtMCleKB
	 X/Iv/EcFF3b3RhUbEzp3nu+PWRFKOwsWnIS9Ohxt7SNKVXo3f8chZrVW/PWujOfnE5
	 dKRmaBKTuZtosYuBj6dW4Xj4Xv/UbpCfEYtjuaYRzrXhtYxPDnlNzWh9w5gXbRRZWT
	 4Jy3to8iIkHgA==
Message-ID: <969cb14b-5b8b-48e6-add6-4dd13101dd89@kernel.org>
Date: Wed, 17 Jun 2026 20:52:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] mm/compaction: skip isolate mlocked folios when
 compact_unevictable_allowed=0
Content-Language: en-US
To: Wandun Chen <chenwandun1@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
Cc: akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 bigeasy@linutronix.de, clrkwllms@kernel.org, Alexander.Krabler@kuka.com,
 Hugh Dickins <hughd@google.com>
References: <20260604023812.3700316-1-chenwandun1@gmail.com>
 <20260604023812.3700316-2-chenwandun1@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260604023812.3700316-2-chenwandun1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 39bkd1s9winmkzri3dh19am1egepx586
X-Rspamd-Queue-Id: 12E621C000E
X-HE-Tag: 1781722352-879928
X-HE-Meta: U2FsdGVkX1/dhqjGmwfoHqphTPrY3zJrq6F7t92/YcsrcLvt1V0n1BuJpt4OctVeBzuji15FhpcwC5odpxzMmi44q/RE85eBMCYm6oKKAJSj1TAtABb1IoT4Ka2Kdtk8flV9LWkH4goI/ylEltAAN8O0RIgHLocrZF352iJvpYGUmhEuP0K0tp7VmNwp/Ah7PUWZDZ4ZEpHiEB3mFDiRGbgOhE0oOvJXWCAHqVvflZ9/TEGydMszUN7Gf25qzqKJ2gDRS++O3OWtHwU8ADo00lK57kcIHEkkemloFXnok7yCW2etn+d0rp8XQN1sNOMkZ9+s3odDs00fKZ9MUYCaTNPrduqTYxZ5pQxUXCTA2+eQjpaKnF4iKH5UkZe0DzoZ31fxpn+ky9HLzZCALz6vTHneo2LGgCROPNFFMiORhma58sS5Vg2kDsuIReFG5Pkg1Ku4pkASOI+fvPufDtRBPmw7nrLSDPY940C2EHJeNT+GVMicscKbk7M4K+C/kLmG0XmDgA1UO0L2pvWHdxqgagRqfT1JYxMnKmf7e4QF8xVQPv1iRomad7y+HzB3kbUBspnXcvSLklANv+rrkkLY3j0z8TTzarybGx3FLYZwb6cMBDKLr6HvT4CviIO9Ap84F1CJwJFl4wpDh3N2/+QVoUret5rSKBe/p1pMWFfhFHfhpoVsZAAnf6IQb7SfxRg7dHHpk/DU++4n105MjqWglQw3aGW6UE/6tYs9oiAljqtgDhXoyEHhCYFI308lwYVh/usVOfZuj2k3JMHb28nHW73Ir5Cwco5Vu57OfdOfFva8w04iKDosnfJD15gBoJapPVSSlPa6xb7MxfYqKILToi8JAnP91Y8vGnVZt/okZKsZ97ebigVF4hI7UrPwEjf7ggNoHgpf9uq4n9Nhb/J+zsNO5R/wUJIJWMln1vTf0jq7wWNpdvfhG8rVjyjJ7j9hnPeW7BeJk7m2n7RcT9z
 QXnaQr/W
 y8oVo6yyko9fq3EM640zjzg7fMrxpCBAo/EYn1DzSHLEeogNMR0JnZuADxlgKucHAELWZVQ9k34u3W8fxiPM0a/1Wv6QALgJox77Z2knImo7bncK+A9MuQTlYXURVCTSqfiFTsjBjNsSEV/5E4y6RFAdBVn6gpIfYh/LhnfPkF2M9ddqWZxIHBTZdyOtXG+sZwjyyRhFpY3er+nBlkrd3qKx0PijJD4cXZ/LTfNT3oYAqWvoDAQGGDJ6dRqDjMyttZz8wSEz3aKOJywdBltZqyJPGXA2gapnwh0doC0AyIaXF1NEVV+rYMnx+guOzcEgfGcIGKMiW0JRyJc+1hsdQGkoke7DmVL6Vj/09NH7uaCYKNPYSVMKJ1dOugx7C/fMBW4gvTrBez/mVvsHgRzv9JsVmckgZpyWGvW98Ijg+NndMc/epZkIGgcBAX5qSpEd26bgWxFQYXKEUgK8iMsZIUz39ly5HEUn593EP01yt9/aMkCToNDcqHFg3V6LXLyYV0aYd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/4/26 04:38, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> compact_unevictable_allowed is default 0 under PREEMPT_RT,
> isolate_migratepages_block() skips folios with PG_unevictable set.
> However, mlock_folio() sets PG_mlocked immediately but defers
> PG_unevictable to mlock_folio_batch(), result in a folio with
> PG_mlocked=1 but PG_unevictable=0. Compaction will isolate such a
> folio.
> 
> Fix by checking folio_test_mlocked() together with the existing
> folio_test_unevictable() check.
> 
> A similar issue has been reported by Alexander Krabler on a 6.12-rt
> aarch64 system. Vlastimil suggested to check the mlocked flag [1].
> 
> Reported-by: Alexander Krabler <Alexander.Krabler@kuka.com>
> Closes: https://lore.kernel.org/all/DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com/
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Link: https://lore.kernel.org/all/33275585-f2db-4779-89f0-3ae24b455a67@suse.cz/ [1]

Well in that thread, Hugh doubted my suggestion and then it seems we didn't
concluded anything. Did you actually in practice observe the issue that
Alexander had, and that this patch fixed it, or is that theoretical?

> ---
>  mm/compaction.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index b776f35ad020..7e07b792bcb5 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1116,7 +1116,8 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  		is_unevictable = folio_test_unevictable(folio);
>  
>  		/* Compaction might skip unevictable pages but CMA takes them */
> -		if (!(mode & ISOLATE_UNEVICTABLE) && is_unevictable)
> +		if (!(mode & ISOLATE_UNEVICTABLE) &&
> +		    (is_unevictable || folio_test_mlocked(folio)))
>  			goto isolate_fail_put;
>  
>  		/*


