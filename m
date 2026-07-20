Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC5CFC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 10:43:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B2136B0088; Mon, 20 Jul 2026 06:43:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 863BA6B008A; Mon, 20 Jul 2026 06:43:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7790B6B008C; Mon, 20 Jul 2026 06:43:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4946B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 06:43:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1E6FA00AE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:43:10 +0000 (UTC)
X-FDA: 85008817740.17.B24FAC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 38351A0005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:43:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m2v5jzul;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784544189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nsfmWiegW0OILsLVKeO/049ziGI5iaH5BD/NGSwJfpk=;
	b=KRZdoVTbB4bsDlyQxq8VnZa9Z8m5ktMEvKdgRVgQ9l+skM/EoNHabGEV712W62APJNXCpz
	1wQ5Y/BeJSxM4UUd5L7sL734U2FjWMbzCS68ZpDRC1O/VHLiJ5x+em/48G6B2UdVQ3QM2E
	22J+OIKT+AHTqkYSQ4ta6GABnBUvrRI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784544189;
	b=C64obKuzND9PB2ZphPQ7WI3yjvqbSk9uo6KVjLEqHNqWoOfwXFTMouMU7vLGd7S5orurFS
	vLVn0VWV29VX4Lxv8XePTSytDINUJb8reuHHK6XgKUoP8kqxMvJ/EjHe/ovagKX6bfkrUw
	cgw+Z0IHk2FA0azPxbICyU+JM6WYl3U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m2v5jzul;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F73260103;
	Mon, 20 Jul 2026 10:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F67E1F00A3A;
	Mon, 20 Jul 2026 10:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784544188;
	bh=nsfmWiegW0OILsLVKeO/049ziGI5iaH5BD/NGSwJfpk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=m2v5jzulxqgbEghkgipyDUC1HMOf6eV25n5F6Dlura3AEtvoMzfE+zJyKV45ZngFh
	 T0mRGUmpa/kqfc8YYch9sHjjWa9wWUQZLPmGxbx0If3rvWmT6PjXPxnHSQ5TJGKpg8
	 mMQ3ZSNfBIJbMR1TC34819lwe+93jfYvdc4jBZ7NZXl+CWZT7EjKZnvbYmbzQHwgnQ
	 yw2sC1ILxLib5OkxgvheeHsgsBOTVh3+hL49G4F7sZK9rMTmiIHn1tx44l6WW0tw6r
	 r/tSDsTa8DgdUeK4LFKIZO+U5/jAS2wZ+k86DbYspwy+7mRg6+J7dFsUlbvnCNYyDh
	 aiE4NtaOLVEZQ==
Message-ID: <33a1cb67-8d23-4b51-b4d8-9e95e8de00c7@kernel.org>
Date: Mon, 20 Jul 2026 19:43:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: prevent pfmemalloc objects from entering the
 barn
To: hu.shengming@zte.com.cn, hao.li@linux.dev
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260720164108387NvWvBxxTPdY-K3EVodBZZ@zte.com.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260720164108387NvWvBxxTPdY-K3EVodBZZ@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 38351A0005
X-Stat-Signature: f3tgysawm5eac688xtxghxmiekkqdirk
X-HE-Tag: 1784544189-761876
X-HE-Meta: U2FsdGVkX1+PRsNBZtmdsj0R8K7lhIvLFNdLpmP+BeippXQYWqzV21oeNKnik9pzZj9RC403V7bGmnXbDIDzt7gCsxhRKSikmTUSNU7PtHMdwNtFrqUXtmNubjlmNYXPoSiQmUq9aF7f2QZtdLTnPcgLZDjVxVJK+CPxOY36Obb7L9aKSDH2zfY3e/8K7F9zpRmhMHDeer1hxxw/TLpHb9SlSIKzVBeirHIG2j3JrK3yHwIqGmg8Ew0QS5vU7WrxD6vMo7Cti8L5NpIlWWKGpq41LfSLnlBzBjj2fWcEtzYceJQTGsA/W8Sk0vBk0XPAv6jvXt7TxwZv2UG9OZNaofTCwaD0vgjUuXcS0sKVoVX4rfgDfUVrAQvEF2fq79dj1sguq1cjt4ekUUL8mgnN4H5wyZJwaxnSb9GPdvbWSTq7f3dZ8Q0Qo4GzE43THR901/craQZwWrirBbeb37B5MB/Cq1Wva0QAhPt7psevjGbr01ukoiFEK3BghPq7DcFCwzZs5TYNTcgL9whC+0MmE4uZOuuPIO2pLIrWo82Uv2HB0kl2A7DBjaRSgKe10PRtitIbRY0i/DBxGjHXGTFY4wLfjLErhLWrvqy52XdB+xWdpFZhAUljX1DYtVPNV7pOUZqbsSmhAg0Zuz8KClpuPdH8putTduzTCTbQfWAXm7bKEMG1WDbW1uGj5UuN+BvqQgza5xoMFM9TrhRqPY3IXodI5uR4H5v1g2BaYcrIOnqnyoxxtli/55DaTsrMaYe7QTj+53KZ6ei6cI/OMWVgUe0V1TdLcCnII7VtVsKXD8ajr5+hKCcSCTinQh/cL8Ygtt4ihWSkoyxbJ2qjlYz6DPm+4ZtQCVBPJzEPejj25Mh0P1nQtKn4k2huBOYVF0h//W1ua29AxBItWkZOUfB996JNYsfbFdf8jXTm0rNaEgN4Iu5ck45i+3zdp6LoauQHTXp440CjcIg9e8KB8e4
 5Ybf5eea
 sT08AuDZ4v1EveDUNdEzfVTkaCuxCSMVRf6VFm7Y6FqxEE78QRJv4rBn5jie2VhYsI9BnJcffGTWQznxPZHwn9mPY5fICXBsYqIyEyz5warYIGkNRJ/vsVW1SL1l2z0g8ml3kmKByEA9lUO3ck37V/rqB/pjc9CG99Kf2ialWoTS6LQCcj1lC6Ep32JKA1x6aKkfK8sdqwo6GDSKpsjuGBfP3jdPTeaQWUQliuR6fapjL7HLKZrQNEg/ZvHg6hbt57dGxfy98SSCWG4Ezyy2u/KGBLI2lLp0LiKIedAEW1vqjIwVWZ8qybnnZ0VJ5cYLaQo2v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/20/26 5:41 PM, hu.shengming@zte.com.cn wrote:
> Hao wrote:
>> On Sun, Jul 19, 2026 at 11:37:01AM +0800, hu.shengming@zte.com.cn wrot=
e:
>>> From: Shengming Hu <hu.shengming@zte.com.cn>
>>>
>>> kmem_cache_return_sheaf() may refill a partially consumed sheaf befor=
e
>>> placing it in the barn. Without an explicit restriction, this refill =
may
>>> draw objects from pfmemalloc slabs and consume emergency reserves.
>>>
>>> Add __GFP_NOMEMALLOC so returned sheaves are refilled only from norma=
l
>>> memory. If that fails, flush and free the sheaf instead.
>>>
>>> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
>>> ---
>>>  mm/slub.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/slub.c b/mm/slub.c
>>> index 53b4976d3831..34f17ecbde87 100644
>>> --- a/mm/slub.c
>>> +++ b/mm/slub.c
>>> @@ -5123,7 +5123,7 @@ void kmem_cache_return_sheaf(struct kmem_cache =
*s, gfp_t gfp,
>>>       * simply flush and free it.
>>>       */
>>>      if (!barn || data_race(barn->nr_full) >=3D MAX_FULL_SHEAVES ||
>>> -        refill_sheaf(s, sheaf, gfp)) {
>>> +        refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC)) {
>>
>> maybe we can add __GFP_NOWARN as this is just an refilling attempt?
>> refilling failure could be acceptable.

Adding __GFP_NOMEMALLOC | __GFP_NOWARN makes sense to me.
Analogous to __pcs_replace_empty_main().

We don't really put pfmemalloc sheaves back to the barn but as you
pointed out kmem_cache_return_sheaf() could fill the non-pfmemalloc
sheaf with objects from pfmemalloc slabs.

> Thanks for the review!
>=20
> Good suggestion. Since refilling the sheaf is only a best-effort attemp=
t
> and failure is acceptable here, adding __GFP_NOWARN makes sense.
>
> After taking another look, maybe we should also clear __GFP_NOFAIL if
> it is present in the caller-provided GFP flags? Otherwise, the allocati=
on
> could retry indefinitely, which may not be appropriate for this optiona=
l
> refill path.

Hmm, you might argue that it's not worth trying to refill the whole
sheaf w/ __GFP_NOFAIL in refill_sheaf() if e.g.) that end up reclaiming
more than one page under high memory pressure. (Just like how we clear
__GFP_NOFAIL when allocating high-order sheaves).

But that should not be part of this patch at least.

--=20
Cheers,
Harry / Hyeonggon


