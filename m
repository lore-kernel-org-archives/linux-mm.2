Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A93A0C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 11:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7389A6B007B; Fri, 24 Jul 2026 07:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C2526B0088; Fri, 24 Jul 2026 07:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 588D86B008A; Fri, 24 Jul 2026 07:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 252756B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:43:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9A74CC036C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:43:21 +0000 (UTC)
X-FDA: 85023484602.09.74064C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0606F1C0002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:43:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KAmVci8p;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784893400;
	b=H0GeA4QmfVa9Z84sPdNKDH48hOyZ0LJEJPTAEWFen40gyCwKPDQx8X/sOP0O3b/LuFJBsj
	0kIyO87E5S3H7S/btUjTpFTJCWCMmNOHWGrUxQnwBQ+nretmu4jhiChx8f276CMqgWd/es
	wQmpe9h5FBrdF3IvGRtVJBWL7PtEliY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KAmVci8p;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784893400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZK9f+lQKq3T7Qui1zvAcmW2bLdT9jRcsFf+gQYXibzo=;
	b=5dIXKcLgHfq2hfnLisGd9SuG2aubSUcnUxbxVTG76l/+ik/NazhBJ6mPPQvln452qCpdtx
	3FzEwc9940KLNhW5UklUH1UNDggv2GHAm3oogeWPvaeQxm8e9plh3dbf83HnLzk84knRRS
	CfuZI7a8MdA62b1UOZmobnoF82CSr2c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 26997600AB;
	Fri, 24 Jul 2026 11:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502641F000E9;
	Fri, 24 Jul 2026 11:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784893397;
	bh=ZK9f+lQKq3T7Qui1zvAcmW2bLdT9jRcsFf+gQYXibzo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KAmVci8prSKWVWJDnnMjbYXecaey/m2kdgGlten0/MtSDBWAlDx8QxRDeBkvN21bU
	 45Dte5iInWRKBTstP++cGXcQNrRvBS5+5pFA8rdY/80T1Wo/lwhVk6IKJ91I/G/PmI
	 vnX16dokZr9anglrKFOakFh6Uv2BfmfYE9NDELvBOGm/W1wrAyq2y+YdryL+mCTAU5
	 A7cQeUv80a1u4/TR8ixPULvU6UFLlT1rsV1s0u8GnFPEft6rYwHZiivLCJeayyktUf
	 B8DUmSJcSqr4XH8tsArVvYzCbNBgSqd/UpxitfmykLMDSyG7/UM6tHePNDjf7ROgK/
	 EHim5TRRJEilA==
Message-ID: <07adab0f-12cc-4f48-bf23-4aaef67ab405@kernel.org>
Date: Fri, 24 Jul 2026 20:42:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next v4 4/8] mm/slab: extend deferred free
 mechanism to handle rcu sheaves
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 ast@kernel.org, andrii@kernel.org, puranjay@kernel.org, ameryhung@gmail.com,
 bigeasy@linutronix.de, clrkwllms@kernel.org, rostedt@goodmis.org,
 paulmck@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
 joelagnelf@nvidia.com, josh@joshtriplett.org, boqun@kernel.org,
 urezki@gmail.com, mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
 qiang.zhang@linux.dev, pfalcato@suse.de, surenb@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260723182727858gUQJ4TgRU2b6v1kdgpkfV@zte.com.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260723182727858gUQJ4TgRU2b6v1kdgpkfV@zte.com.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------tmAUU7aaQUfp05UMAY0PS3Nq"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0606F1C0002
X-Stat-Signature: xyggamyx3ux6pfwpnozbus5a6mmsaiw3
X-Rspam-User: 
X-HE-Tag: 1784893399-16905
X-HE-Meta: U2FsdGVkX19JpkC7a/bd3QhaH+6RMkRjFV60UAoQ35Qnp1aNkFdKs10uMO4VJ7nKO4Uvwx7FtW+nZEJC1LhnxgzhDKrjTSgpS7K6X6ArZUrsj1dUsyUjJ3/sT5J6cQ7LUAGkrcftlTWPJwxdCUbtRYinrZaDDCFH8deuDtOooXzpsGIrpTmTrjSYS1aoVVs8wSGnQBkbLlbERB8MZ+Jcj+smfdNeru2xyl/QL0Voyof/wzbVg8q87hMfdk5AlHa9MWF7HUoNyoeoA9vIwhbirF1raRgfAfwyiZw1+wqAdcvVFNPHrUXDO6UJujrTWlQwK7GzcXXVt5U8pbQQCMONJDtcMg94DxPhmPHHbdCmjVaJTirWsoiRYOFJPTQzfZRIIfA9RBxW9gNE0RZKWsXaGP3Bir7fmG/IVzh7izO5+ypeUOlWeG12IVl+JxOoRCbKyJ8udCKgHH/HZBfSRpuPgtOa5JPMhA6cWE8itxMPvGg+7ZlMZxs46YfOk4DGH5dmN/pWtiT4vBr1b0X825RKfc0kxl6AMN3QOjPN49vWTXHdy0FrnMUWWvQfHbEVF1HaAsoDyimO7QvTSzlWrfatXQHFlCg6fx73bL7R5KJjf/XIbAcUYl067dci/Je+iD9JFYcVrC8c4vXaf+dTmOXqUL8j2j0vGYw+nMcVmTyTQwFYaoxqJ9PU8X0LuVg7AKZEoZ0w3nYNt+ahnCChN6qoTgy2w+gWIB959yZIHJYOwNM3SaHKfz9u5uFGksnltdF0bT3tyfP7isl8+OOduXoNqGnowSWPXvnX6mrVs0XXfcEY6wXeik8E1NH2mWOPg+BQFeyUzEAlkNYZpCMqz5HlbDRmkYwe+09JbwSwzJ1vAXz+kBqdz6ronZmwKHXiVNEb3v16PYVXMrj56dJ/k6wlKj4mOVu6KQIgLSYRl6NqHRdyV3IY3pDlxqkyNClNNCzfCZLyt6mbPbGhuWNhVYU
 WNU9xl/V
 pGv8rlapQa1VSDafC18+Ptp7DGK+7RhiTuis579Kaq1xifyZovogU1ddtXhLd3YJrnE9rg6bH2HOXN8eFvmvPZ41GZL45X0RSrSd0OhPeJfwU/MkAMqTxwJvvcB4pIHtU2EFEFcMizJZAdc2xmLlYMOczn+yPNbBlviZqlKzkpBEVXBYfe1s040IZvcgAKxR55hluW46ANOkAirSniVGHltOuZl0HccfdHOm93VHMOJpUYKkmDGFovdeHUVe5Kohm5AIAd3N4I0corhOrmxl167oBRmMTaTfPyL0CIL/XVdTOf5PjZBh3UpqtsAEtHgyveac1awlI11qUDrkui3+/W7Jlr+J+TnibY0hHk2TIP6A9Uvdemr0M4U5odagcrCjGl903Df1YEj70BKLzKosbJxu/GwSYzGgVa2mpW0F1bofAUcSSRq3561la0wlXcH9iDlmE+zPCVxbysTX8yTsghQbdgu/NZJJEj0HG7DqyD2+WXf5bQBNmw/azYYg91uFD3gvUZmA1vk77iIFxgd59B2DyAvQTYBAnr4b0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------tmAUU7aaQUfp05UMAY0PS3Nq
Content-Type: multipart/mixed; boundary="------------l88ZLZ879gKaeoF6sUZa3ymK";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 ast@kernel.org, andrii@kernel.org, puranjay@kernel.org, ameryhung@gmail.com,
 bigeasy@linutronix.de, clrkwllms@kernel.org, rostedt@goodmis.org,
 paulmck@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
 joelagnelf@nvidia.com, josh@joshtriplett.org, boqun@kernel.org,
 urezki@gmail.com, mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
 qiang.zhang@linux.dev, pfalcato@suse.de, surenb@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <07adab0f-12cc-4f48-bf23-4aaef67ab405@kernel.org>
Subject: Re: [PATCH slab/for-next v4 4/8] mm/slab: extend deferred free
 mechanism to handle rcu sheaves
References: <20260723182727858gUQJ4TgRU2b6v1kdgpkfV@zte.com.cn>
In-Reply-To: <20260723182727858gUQJ4TgRU2b6v1kdgpkfV@zte.com.cn>

--------------l88ZLZ879gKaeoF6sUZa3ymK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/23/26 7:27 PM, hu.shengming@zte.com.cn wrote:
> Harry wrote:
>> __kfree_rcu_sheaf() cannot invoke call_rcu() when spinning is not
>> allowed and IRQs are disabled. To relax the limitation, extend the
>> deferred free fallback so that a full rcu sheaf can be submitted to
>> call_rcu() via the existing IRQ work.
>>
>> Since the deferred mechanism does more than deferred freeing of object=
s,
>> rename the struct to deferred_percpu_work and adjust names accordingly=
=2E
>>
>> When a sheaf is queued on an IRQ work, it is detached from
>> pcs->rcu_free but call_rcu() is not invoked until the irq_work runs.
>> To keep the kvfree_rcu barrier's promise, call irq_work_sync() on each=

>> CPU before calling rcu_barrier().
>>
>> In the meantime, remove the TODO item as apparently there is no simple=

>> and effective way to achieve that. This is because, unlike sheaves,
>> kfree_rcu() batches objects from different caches together.
>>
>> Suggested-by: Alexei Starovoitov <ast@kernel.org>
>> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>> ---
>>  mm/slab.h        |  2 +-
>>  mm/slab_common.c |  7 ++---
>>  mm/slub.c        | 85 +++++++++++++++++++++++++++++++++--------------=
---------
>>  3 files changed, 53 insertions(+), 41 deletions(-)
>>
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index e07b4e6d6679..9c9ae1384f47 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -551,7 +551,7 @@ void kmem_cache_destroy(struct kmem_cache *s)
>>      }
>> =20
>>      /* Wait for deferred work from kmalloc/kfree_nolock() */
>> -    defer_free_barrier();
>> +    deferred_work_barrier();
>> =20
>>      cpus_read_lock();
>>      mutex_lock(&slab_mutex);
>=20
> Hi Harry,

Hi Shengming,

> I noticed that your fix in [1] serializes defer_free_barrier() to
> avoid concurrent irq_work_sync() waiters.

Right.

> However, this patch still calls the renamed deferred_work_barrier()
> outside that serialization scope, including the new call sites in
> kvfree_rcu_barrier_on_cache() and flush_all_rcu_sheaves().

Good point!

I didn't _fix_ that as part of this patch since that would be confusing
and the fix didn't land the mainline or slab yet.

> Is this series expected to depend on [1], with these call sites
> moved under the same serialization? Or am I missing something?

I was thinking of rebasing the fixes as there won't be much conflicts,
nobody except for sashiko complained about this, and we're not going to
backport them anyway.

> [1]
> https://lore.kernel.org/all/20260624-kmalloc-nolock-fixes-v1-4-fdf4d173=
51dd@kernel.org/
>=20
> thanks,
>=20
> --
> With Best Regards,
> Shengming

--=20
Cheers,
Harry / Hyeonggon

--------------l88ZLZ879gKaeoF6sUZa3ymK--

--------------tmAUU7aaQUfp05UMAY0PS3Nq
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCamNPvAAKCRCGXBN6rc5S
1jS3AP96xAV6tdo5fPUAIVGuhE+lXKoppDkmuQX1EC4XtI9KRgD/XzVEu0/IvVjA
KfYQg+G7K9N5IJAuVGvicUoHa7EZrw4=
=NZpC
-----END PGP SIGNATURE-----

--------------tmAUU7aaQUfp05UMAY0PS3Nq--

