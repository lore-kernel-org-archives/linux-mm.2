Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A34DCCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 08:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8762F6B00A3; Fri, 26 Jun 2026 04:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84D156B00A5; Fri, 26 Jun 2026 04:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73F476B00A6; Fri, 26 Jun 2026 04:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43C246B00A3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:17:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4A7801C618F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:17:25 +0000 (UTC)
X-FDA: 84921359250.07.1C5AC21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 94998100009
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:17:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HRPKxo0R;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782461843;
	b=XVsHGrPY+OwKw54etPf19UmwW8NcAISuQYgMVVqPmYGMNKS+AyiAst9Pmi7s1lOCnTIVL6
	Gl9h+Z5A8/33NnpHY9BoQKmkAlHsHGBXArtsWWHQnq8g0bpXGPuyMKh+rFNSRvo54ryFLC
	wsa/RKZL5FDuxu36nGTFab1iy26K/uM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782461843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/AnaYuc4P67ER2npVfM1Eb7butqeY9jqtcroJ08g3DQ=;
	b=Z7RpVEsiocKJ/TDXKIdkVQI8sjWQZxK7nxjPgzacZ68WBgYZNyx+yt/58nJGAx7cGGLoRR
	jQP94uIOrQHl2ArwvS6uTc4XeYP3VmZPTIFutt76eCFtnL9L4YKbw9aKyxJyhCdBw4o7Ny
	R/UcN6a1XQJha+B5iosfwKkvaHDfT9M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HRPKxo0R;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2897860098;
	Fri, 26 Jun 2026 08:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB4E1F000E9;
	Fri, 26 Jun 2026 08:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782461842;
	bh=/AnaYuc4P67ER2npVfM1Eb7butqeY9jqtcroJ08g3DQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HRPKxo0Rr3pbVCWT//XwS+W4dEPHI6hqcz1BIoaq/8A0qT653i2ccP8D1Qww3C6ky
	 ZHc7iEGKxZLeGyTypJxFtRlnjb/2M3CM0cO28M2puxzKI5v4P4mt6TjFKzFE4BuSSP
	 3IO6sBs03lpsURbOoVFbQFXSE4G53T0ZCSQqMnfI7+P433zwNCUWHBb0QTdHYJe35W
	 YayvavbbDgufFAFMzARoxcEMsGrUUxi2pIUkGdpv6gts0HDwuhPomEWmife+pLGAB2
	 i13ajRFu0ZeqIkoJ4iqrcwwv4xJ8mOBrtEYhSQCsxbEIHTCi5bD/4ggAtjwxoJqcPR
	 5Q8Yh24sykFlQ==
Message-ID: <04ea3e05-5b83-4c2d-8759-67c544a7b484@kernel.org>
Date: Fri, 26 Jun 2026 10:17:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: annotate data-race in cpu_needs_drain()
To: Xuewen Wang <wangxuewen@kylinos.cn>, akpm@linux-foundation.org,
 liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, jannh@google.com,
 pfalcato@suse.de, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 baohua@kernel.org, youngjun.park@lge.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260626053700.2036899-1-wangxuewen@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260626053700.2036899-1-wangxuewen@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: abodywqmci3brhhpj71fkoxkot5zb459
X-Rspamd-Queue-Id: 94998100009
X-Rspamd-Server: rspam06
X-HE-Tag: 1782461843-670694
X-HE-Meta: U2FsdGVkX1+VYh8T8WLmKVl0XaDWhL6frthgGib2VuQ4bnfnRU0b4hwDl376KGUH7Cyi4TZNy5xiDhs23qig/lJqMRqa5nqKAoPWRWhTkwKYNo1UY+zgo4ttu6j0IVnAEFEaf9tWaVhDjGteALao3OCQf0gfCMhLmQ5H+AiJj3QXcfuLxvlMVutl1O+GIvRojnEzMnMf02iVqQZ6qmiY54230q+1DbIFkrew/qzfZnVxqKYEAAFgS7yvXDeIQLOSqFI3Oa6G6WCFIWzM8DYz/U/Q4/sgS4sJdyhioJN0o8JAF9JEgsYKOs7F4O/PYUzWwnOxE8uKLBE1WIpewz0msfMKw+xqmNuoiBTLXW2rSdebIVnmha6zqJfpRviEeusiuk+VI3B8xhSvk5K0LC93dysDZDXmbW6G+lVVUntEntsp4kf1Sjfbr39hEPF/UZRJ5WI6hhYftGa1DfDCoA3KFhZQ3qk4g47tEImxkneYk7PAV8i8lBT2yAm0E3qPiTxqd0UIMySrggN3Rp8c+/Gnl48PE1F/rWnbjZmHbT6hpsY2sD2mqEwNLFOL4ZBxkfJlLQ/yGuEuKsFZwSXUimW/nb0exrDY/vjgmgm2qA/NwzYG3PQCFJi9sc4xwEbtLYA8YKtEh2ul06NsMiGtQtEcsuGyJXTPdeM+asK9XuH1KjKW7CyR2Vd44F34/PdvPDU2KrUzejv/HLw/w09IJBipgkKPQRjnxFiYxF/qj1lH4H0siuiv0/pqzTuJi7KgmgTd7GqbYW4I1shAzV5R1QJ6dOEYdriH2AnYwFvZhGEdBBpkDjVbrY95t9cpRUvP5gXHZYieLxYgrVzEL5gNHU0+WQPRhbObsKcHRLlNYOpYsNrABKiQltthpREZ9aZ5xvs4e7MUlqxRh8um0/LuPGvdxpsmt53v6Hy0cf1942ZbhDVtWD7rCl36lAtZZNbXwKJNy4ge1+AXcDDQrdRtlnn
 RU2eWuhj
 EQt0q1E3fa7AJsJMvWLdCrV3QYZsbEmMLZhBj/+D7vay/LL7eAXYF+u5nSME3md97yyQbdPBh6gW6XYzyb+/4SfD35BItLR9sDRQ1dib/HEtg8P7Of6hMCabgNkofjTaPuN/fkqsMwAv2HZR8OoUTnh14zkTjZ3daiIjamTCWDgDR6JewE0JS3IeO89jM1C3Kbza6eTtNMk6O7LZFOLgZvnwTX28vznEp+SAmCVO0T5gR9Gt3PNoheF1sXqDXYLIk3wXrGSpN+M4uYfVTFsoig6HLTu7wL0dUnTaYcn7hIY7zmtlS/RcP5/uMNLg42mJDTi8VldRRAJQy5d4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 07:37, Xuewen Wang wrote:
> KCSAN reports a data-race when cpu_needs_drain() reads another CPU's
> per-cpu folio_batch->nr without locking, while the owning CPU writes
> to it via folio_batch_add().
> 
> Reading a slightly stale value is harmless -- cpu_needs_drain() only
> decides whether to schedule a drain, and the next iteration of
> __lru_add_drain_all() will re-check. Use data_race() to annotate
> the intentional race.
> 
> Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
> ---
> Changes in v3:
> - Wrap the entire || expression in a single data_race() instead of wrapping
>   each folio_batch_count() call individually, as suggested by Pedro and Lorenzo.
>   This is equally effective and more readable.
> - Remove data_race() from need_mlock_drain(), as it is now covered by the data_race()
>   in cpu_needs_drain().
> v2:
>   https://lore.kernel.org/all/20260625065153.1581419-1-wangxuewen@kylinos.cn/
> v1:
>   https://lore.kernel.org/all/20260624092606.1083449-1-wangxuewen@kylinos.cn/
> ---
>  mm/swap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index 588f50d8f1a8..46ea207e0624 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -828,13 +828,13 @@ static bool cpu_needs_drain(unsigned int cpu)
>  	struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
>  
>  	/* Check these in order of likelihood that they're not zero */
> -	return folio_batch_count(&fbatches->lru_add) ||
> +	return data_race(folio_batch_count(&fbatches->lru_add) ||
>  		folio_batch_count(&fbatches->lru_move_tail) ||
>  		folio_batch_count(&fbatches->lru_deactivate_file) ||
>  		folio_batch_count(&fbatches->lru_deactivate) ||
>  		folio_batch_count(&fbatches->lru_lazyfree) ||
>  		folio_batch_count(&fbatches->lru_activate) ||
> -		need_mlock_drain(cpu) ||
> +		need_mlock_drain(cpu)) ||

The indentation is a bit suboptimal now.

Would read nicer as

diff --git a/mm/swap.c b/mm/swap.c
index 588f50d8f1a8c..5958e6fdd3593 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -828,13 +828,13 @@ static bool cpu_needs_drain(unsigned int cpu)
        struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);

        /* Check these in order of likelihood that they're not zero */
-       return folio_batch_count(&fbatches->lru_add) ||
-               folio_batch_count(&fbatches->lru_move_tail) ||
-               folio_batch_count(&fbatches->lru_deactivate_file) ||
-               folio_batch_count(&fbatches->lru_deactivate) ||
-               folio_batch_count(&fbatches->lru_lazyfree) ||
-               folio_batch_count(&fbatches->lru_activate) ||
-               need_mlock_drain(cpu) ||
+       return data_race(folio_batch_count(&fbatches->lru_add) ||
+                        folio_batch_count(&fbatches->lru_move_tail) ||
+                        folio_batch_count(&fbatches->lru_deactivate_file) ||
+                        folio_batch_count(&fbatches->lru_deactivate) ||
+                        folio_batch_count(&fbatches->lru_lazyfree) ||
+                        folio_batch_count(&fbatches->lru_activate) ||
+                        need_mlock_drain(cpu)) ||
                has_bh_in_lru(cpu, NULL);
 }

But I'll let others decide :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

