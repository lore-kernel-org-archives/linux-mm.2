Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC4B660A383D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 07:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PPAe8EdV
Received: by kanga.kvack.org (Postfix)
	id F17C76B00EF; Thu, 12 Nov 2026 02:49:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC8E86B05B0; Thu, 12 Nov 2026 02:49:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDEF86B05B7; Thu, 12 Nov 2026 02:49:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF3196B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:49:22 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 401521404F5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:49:22 +0000 (UTC)
X-FDA: 85425691764.26.E109C86
Received: from mta1.migadu.com (out-4.mta1.migadu.com [95.215.58.4])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0BEF780003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:49:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PPAe8EdV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.4 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794469760;
	b=Vk31ntUi6WCLFM1opnwzKOSX9y1Zr2fVlmzRsiFequMVbN/2VriV/IR+ANQVsdJ3nxyb3i
	rbzlLv0NvXAK2QRX9AV0Utxh56HDCeiiiy/UEnOmWM6NYViwvhUY9IRBgczsauJpZJgJ5s
	KIiQjnHptGsLOMaQPQETlpVR7nNGD0Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794469760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8u/Jrpuu2JVC6hI1ixrRZTm2BiUfBKSvznSfyHT+Io0=;
	b=tQ2dpwwwOc3sqP7RTGij5KkTS7WLYMjuGAQsHb4sQ/cNfRuhm66CGgZDM6O8MAIehYd+8s
	jjNN7HHRiCy7DFg9f5+4056QfVw6t1c+XihlB765RXxD+pUUZemFTyclnmaxSiJBqVLWlz
	l2uRFs+LBa8z6L8pqfp8jrG4Pr8hEEQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PPAe8EdV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.4 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6ulO7dBVIsFkGmxrkgfFgMkcM8Ux5PUXeXdSsWBAiK4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794469758; v=1; x=1795074558;
 b=PPAe8EdVUr72L9MGbfhyRw9G4D4unnmsjA498ARd/6RbCMsWGRLoLvlXtjuP9IkcW7hDaooB
 0hdlu8PV6u07HSSZHdNp1JDqC6JDZ4ixJAa0hNFvE2LGrLMKnhtbWnZBPg5m1lyD5mBzOibkhUj
 OprpzXrLWQWLBxp/O1vDUgxQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fbff19d345a9f3e7;
	Thu, 12 Nov 2026 07:49:18 +0000
X-Mizu-Trace-ID: fbff19d345a9f3e7
X-Migadu-Flow: FLOW_OUT
Message-ID: <aa6caf61-a4a1-4c51-aae7-ebb767f3430c@linux.dev>
Date: Thu, 12 Nov 2026 15:50:41 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/9] mm/kmsan: undo the shadow mapping when the origin
 mapping fails
To: Suren Baghdasaryan <surenb@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, stable@vger.kernel.org
References: <20261110112546.261415-1-hao.ge@linux.dev>
 <20261110112546.261415-2-hao.ge@linux.dev>
 <CAJuCfpHjSZhPPpRudAdrDPzz8dGK=Mx62CYCNoO4MC9OhnGd=A@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpHjSZhPPpRudAdrDPzz8dGK=Mx62CYCNoO4MC9OhnGd=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0BEF780003
X-Rspamd-Server: rspam12
X-Stat-Signature: r8mygz7esasu91mzwfopzw1e3de1ym9g
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794469759-609997
X-HE-Meta: U2FsdGVkX1+vRofK1leszQfSYrt1vVD0JbUksR1kNDADTVwF31ZvIwWi5xUh+ZW2Rfl48DiRrPxOEzntf3J3nmDwMWkRPdVAtZD0emiPxhRptwYOXtQZ2w7yOuD1m/LkfBRjVL9TnJun1KXTX0C6nC9pat8Slzd5oEU4oVFdlPzB0K+BuUomWy68WAWOiN3rMu9k14BNQcR1TPz7LTIEK8zuLlYwPQd2Ng4z1oMjcevdl7HfIvKMi57VZdTlLMp+aPgwc9SjLWZ18Yf+pb2CPLWdZZjaZfsiEp8R6jCgyF2CZUiZzz6pYuQukkfLmoteYooBymsx/yuzs5J77X6rM75+HsfEC3vo4sep3xIKcR7MY0lX/kIS1huuCx6XA+KvMOR6hGQQOhbCaVoAnvYAeAochGKi0YQFnDuC+NrSN1yq7N1ysorB1l2c4iGp1TM5A3Foi+DfdhGK6+2uO0UqDJF2PpHX10OAqKXUvxvdzg4R6Zg/1R9rkz3p34gK3zqzFmRs1PWYssH17YS3nSLkvRwF9zGqrakg1hE0jxWGDd/Do3lhcJ6J47iThB2vc0McJuZGeeCnCm0oe5PFTseBxqCitq+tIHm+meVrd9z0hRnzEaOgMr5jUIGJZ0tGrW7hk5dKlj4Y+f+rASC1Gi7ZY1NSSmw00TA6p6Gij+Bgiv1+VIlFXZyBBurlhEdMIklUniKjKjsZ9kT6WdP/TCK2KKRmMNCNjk7k4goMJNwLWENnRn1KwA8Vk1NuEPtIKJJgb7Y3OrSuFdVUSNhg//TmGxC5DdoGE02fRyfhDG6o+bdMQVEA9vYk9Ma69d6ei1S94Of5vbJFsV1hV7dFk7Dptc1hQ7YoTNxPAHAtdMT5qijgeWu8KgcFr9Gt6v9gZH3MiW8DedMt4soyuw84XtCcYg5TZzlcT4Ydd2aeLw1fftKrQzBOh7sm8rnA3CKJr6yFvAd94hZ7YjtyAdTyY9R
 zE5zl3uD
 v+ehHPR2in+nirdOG2Ksq8ObTtkTedFmyX3k/5x5z1yVWSV2VRbd4+wzmfMafTdQIPBmqr9Lk3WvFPDiALO9pqbLvuREb2enrRNzhQJwQtAb4IBMpx4U63voKX2iornktiQeD0yzUuOAlVJNhF+MKWzG1vqnsw9rH6QYjXTdLyiEawe5p32wNT14p4llH1IfsUDQby3GjQU4zAkUdS+WzS0UlrigXaSNKYqtpGm56mqTU2v94E5jfb5Lg9S2duEpOn7V5i91OPXAbBQtkaeTDMZVPpSkf23DLsFMaxgxpisdLCpwFGACYdcTV8rfDzEbjbJFrWeEbEfE2LsDlCtFCqxcnR9vSaYZ/Ec09Y36O6NJMXyWEOeWeWGW1o3T1hvaFYrPFqJfGDO+pBPdw78ZMy77PZjPzjo7R6cnDJ7Y8VM7HlTzq2B/RebhqnwhGSxTiYPn8T4oB+xwghIuzCKSfESiYjW+rrzuMMeVE2YdTayAEnAR8pLQkVCNXj/Sjmd7LmUFbW8D1OKNriZlFvDHxpILGMQQN26iwJE1rI8GpExjrLNMZrnnoU4EQLm5hK1hOZjBKxN5zEHcJWLU/TnG0eEk7p6ECmoxJx/AvyX48xhXsduQi1pawyG3YYZWd8JQT3l8Xrhk1xtFUsguIZeXeLkUnvVv6EW39UyjupA6f8awg+zHvNHJ4zAAAQ1T5Kdm7cQi/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Suren

On 2026/11/12 05:03, Suren Baghdasaryan wrote:
> On Tue, Nov 10, 2026 at 11:24 AM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> kmsan_vmap_pages_range_noflush() first maps the shadow pages and then
>> the origin pages. If the second mapping fails, the first one is left
>> mapped, and the callers do not roll it back. The next vmap of the
>> same metadata range hits the stale PTEs again and fails with a
>> WARN_ON() and -EBUSY in vmap_pages_pte_range().
>>
>> Undo the shadow mapping on that error path, the same way
>> kmsan_ioremap_page_range() cleans up after a partial failure.
>> __vunmap_range_noflush() only clears the PTEs; nothing has touched
>> the shadow mapping, so no TLB flush is needed.
>>
>> Fixes: 47ebd0310e89 ("mm: kmsan: handle alloc failures in kmsan_vmap_pages_range_noflush()")
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>  mm/kmsan/shadow.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
>> index 0c88d89bf0d6..2166086d3dc3 100644
>> --- a/mm/kmsan/shadow.c
>> +++ b/mm/kmsan/shadow.c
>> @@ -258,6 +258,10 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
>>                                             o_pages, page_shift);
>>         kmsan_leave_runtime();
>>         if (mapped) {
>> +               /* Undo the shadow mapping set up above. */
>> +               kmsan_enter_runtime();
>> +               __vunmap_range_noflush(shadow_start, shadow_end);
> 
> Sorry, there is a problem here. You introduce "can_resched" check to
> avoid calling cond_resched() later in the series (in patch #7), but at
> this point __vunmap_range_noflush() can be called with GFP flags which
> do not allow blocking. Before recent Ulad's change called "kmsan:
> remove hard-coded GFP_KERNEL flags" this function was called only with
> GPF_KERNEL but now that's not the case. I think you can move
> introduction of can_resched flag into this patch.

Agree. I just went back and looked at Ulad's b186a94227b7 ("kmsan:
remove hard-coded GFP_KERNEL flags").

So will do next version. But perhaps it is better to make it a separate
prep patch in the same series? Because besides this call site, the other
places that call __vunmap_range_noflush() need to be changed as well.

Thanks
Best Regards
Hao

> 
>> +               kmsan_leave_runtime();
>>                 err = mapped;
>>                 goto ret;
>>         }
>> --
>> 2.25.1
>>

