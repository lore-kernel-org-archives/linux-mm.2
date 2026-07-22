Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B27C4452D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 08:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0CBC6B008A; Wed, 22 Jul 2026 04:15:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBD876B008C; Wed, 22 Jul 2026 04:15:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD64E6B0092; Wed, 22 Jul 2026 04:15:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7777D6B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:15:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 011441C07A7
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:15:40 +0000 (UTC)
X-FDA: 85015703682.06.88D1223
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4F58B20004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:15:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LRKjrsWe;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784708139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oiQsEs9po9PWz4IpdUW1ReK/rKr+M/MEauJC/KMRWQ4=;
	b=Q4aHJ/k5LgfImB5vyIx5Z8GYdGpCZyUADeM6iEvNR6jfwpxc3PQbV7X55f9NRS+5Oj1u0T
	mwcixILEVpCQiNR6LFt8WvOn5be2xNAFWG0lak6/oF2XFlQpZvhlTACAo9ASbxQjr3CVc0
	3FGmdzcOnKmGQWl4iIA5jEtlJwfGLZo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784708139;
	b=RXY3LvEghTfDH8oGCExikrNue9K0YDpVN1RfZMBi8dZCNHEkKlw/11Rc5evF+y18fjl5wk
	VvWor4e7o+cmAQhqg9dSxZykCaeds3g5Vb/k0yt1BJfZ3ehjBGnFybwsTT8ZMgHltB8549
	isJjMuMgxfIGIhOfsXvUniJoBtHagfI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LRKjrsWe;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 72DEB429C4;
	Wed, 22 Jul 2026 08:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD2F1F000E9;
	Wed, 22 Jul 2026 08:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784708138;
	bh=oiQsEs9po9PWz4IpdUW1ReK/rKr+M/MEauJC/KMRWQ4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LRKjrsWezbJfn+IiAK9NpF7++JQjNh8wH8+WWFa26zO4Im3nk1jIku2/eOsPNn6u4
	 bseMnOB1axaX13tscsBS3wqQiVVKhRSLd7H29STW3ObSeZyCX6Y1T7xh0eohCLjX5O
	 pcaxFYROIzSUOtNlVMH46jSDu5RhsnrNebSAwwGMftuLirx+JwzkcCBla93KXhonIk
	 kNzrSMcqRcIMdVkg75wcu7NKIxM86LMjKImaWlyTPVjP0aFMPWmFHxerQnJTEHjLSF
	 FL3+oBndNl1AzCBU4lrP8hmUQYLIWZFSqH2Mz0zIrrZrW4gPQ2wRbQj6UW+eKyVP8x
	 IDByCUs18fM5Q==
Message-ID: <734ecdc6-f415-41d8-9357-7fc11379e4da@kernel.org>
Date: Wed, 22 Jul 2026 17:15:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next v4 7/8] mm/slab: introduce
 kfree_rcu_nolock()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Shengming Hu <hu.shengming@zte.com.cn>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org>
 <20260720-kfree_rcu_nolock-v4-7-964e03c41a4e@kernel.org>
 <c7607f25-5336-4f64-9244-9476dcc8ff3d@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <c7607f25-5336-4f64-9244-9476dcc8ff3d@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------J0AkE62Qm6KEox29YcLjb809"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F58B20004
X-Stat-Signature: i4zcdap6mirno7hy5ze1ixj34ifw77nh
X-Rspam-User: 
X-HE-Tag: 1784708139-955550
X-HE-Meta: U2FsdGVkX1/WEqRrI17RnjAic3ANSaMYni1gxgTZqG9y8HKv3BH8/nrG83CCJmWjtNQx4mmX/d1h//sDcATpwMRvVIpXxZz4ppKJAvj6gZaXYdB4Q3Xski5unJPd3m4f3SSZw+4n65QhdO1weGP0gFXLaxJOf0FGpsKh63A2t2GhRdGtGrsB0o0ha3xsp+pqHmDcFcVRlVjdciKECy/fPlDQFJdtL9R+nI9yjpfA1EZmugmBhWbsLcpnKyUHk9dfcQA2n7Vg0MUqWQNyaPJ72I/rjygt+/frglQWVOubkNKVWct5DXyPOsMXQcn3pNDL4YBNJkNT2bs0sbQk9sOqZDaccumdL9D01zNXNUSl8205PUWpNXzBjatEo9S+d5hCKXAYWO0DhJevJrFDp0ah8j5zrVOezp2cV7fZIEcBlCQ4Kfi4Al404/caOlYvielrAmJgmhp/rSsVTjEs9w+2z1OgV0J7WVEYY+WmMPKX7V8E5l27Gp4KHt42UM6MVR6Waw2l/MRQIBstC6sU0aRrhf50SgWrB8P/J37fs5t5bm8KQYS4vGPhQgc37aoWOl10oHmjyWzMx2ZkcxGCItrEtFJAyj5o64fP6vGkqRd68dCPXVb+QsmhycQjAABQR8GSPQAnKpipr87jLXatC3VoO+/SPxtWVBF35hvcXlogg7NYyXw069D9rGn9Bc+l8OuXsrl162pDPazD6KJ7ajlB5FDRef82ZF0MJ7tFHaAFlJwgfxz3JQGSstOK/sUzHtkDRkyDj06kX0xHnX8q0Qyuq5DEFhuIoVgf2Z9J9WC3KlVwXvcF2+C0gHEuRBBksHNZIirG4dWyikAG1fJIVNex2gUYdIX6p0IL+HtLDTcqMLqZdxm4nyvidF8IZXN2aloCO6EH6GsmeBYgMNk90UZhIfMu0GqkzYbFHYEQFYkfe5Wb6vk5OKJTbyX+dB8WgT98xbra2lQLsbBr7MhlIhq
 2CcgPMq6
 LDcWyD6n9JDyjJM/JjDfKl42tlw1r8lOaTfdFhYCvBXQYxqkEwJA9zOULhYK5aciYrK//fQ/ROGhmxBrYhoL9YEiOMtx+TbM0tfA/msJJfq5HxdNEG2T0foDbl91wGP8ObfM75XoPJUCBwucscWgVllvwVUKENLJuFkl3062dCb4ik6cUE4a+87IEhLxyk/TNSPWXvH8g4j6ytvZUp3TO7iTZZekjDRa8KuQhNySrtjLIJ9uEpUuHhVj3L8lIwellCXK1MbbC0qcEGADFVv2fMkxHemkhoOmG60q06LDBPfFjLfigBHBLIS9DTfne83Go5xmowLxqkTJoS41p2a6S7ymdj9KirwVO31FQWmjQUVrfjXgZsgwKMuHobXRNgGN0byZIfis1/HdTesUdzHaTQ0Vvwoqs99JKZwER+283cq7kLTMK2tza+OICaRuMSo27FggPw3KAxc/mCG2Z7ij6HXE3QUe2FVd1wrpDOnGTBgCE0R+S8QHhLuuib2/p/iLfUjNl2OivRFx1s3dYRu9uQ8DcGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------J0AkE62Qm6KEox29YcLjb809
Content-Type: multipart/mixed; boundary="------------Zum3HQTusEj7uNFO4KwvsLy9";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Shengming Hu <hu.shengming@zte.com.cn>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <734ecdc6-f415-41d8-9357-7fc11379e4da@kernel.org>
Subject: Re: [PATCH slab/for-next v4 7/8] mm/slab: introduce
 kfree_rcu_nolock()
References: <20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org>
 <20260720-kfree_rcu_nolock-v4-7-964e03c41a4e@kernel.org>
 <c7607f25-5336-4f64-9244-9476dcc8ff3d@kernel.org>
In-Reply-To: <c7607f25-5336-4f64-9244-9476dcc8ff3d@kernel.org>

--------------Zum3HQTusEj7uNFO4KwvsLy9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/21/26 10:09 PM, Vlastimil Babka (SUSE) wrote:
> On 7/20/26 14:44, Harry Yoo (Oracle) wrote:
>> Currently, k[v]free_rcu() cannot be called in unknown context since
>> it could lead to a deadlock when called in the middle of k[v]free_rcu(=
).
>>
>> Make users' lives easier by introducing kfree_rcu_nolock() variant,
>> now that kfree_rcu_sheaf() is available on PREEMPT_RT and
>> __kfree_rcu_sheaf() handles unknown context.
>>
>> kfree_rcu_nolock() falls back to the kvfree_rcu batching when sheaves
>> path fails.
>=20
> From the code I would say it falls back to defer_kfree_rcu(), which is =
an
> irq_work that does kvfree_rcu batching?

Indeed that was what I intended to say, but I messed up while
writing it :-) Will fix that.

> Otherwise the sentence would contradict the following:
>
>> In most cases, the sheaves path is expected to succeed
>> and it's unnecessary to add complexity to the existing kvfree_rcu
>> batching by teaching it how to handle unknown context.
>=20
> This talks about trying to perform the batching immediately without def=
ering.

You mean the earlier sentence "kfree_rcu_nolock() falls back to the
kvfree_rcu batching when sheaves path fails", right?

>> Since defer_kfree_rcu() can be called on caches without sheaves, move
>> deferred_work_barrier() and rcu_barrier() outside the branch in
>> kvfree_rcu_barrier_on_cache().
>>
>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>=20
> Other than that and a comment correction below, LGTM.
>=20
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

>> ---
>>  include/linux/rcupdate.h | 19 +++++++++++++++++++
>>  mm/slab_common.c         | 28 ++++++++++++++++++++++++++--
>>  mm/slub.c                | 24 +++++++++++++++++++++++-
>>  3 files changed, 68 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
>> index ef5bb6981133..ce0fd401352e 100644
>> --- a/include/linux/rcupdate.h
>> +++ b/include/linux/rcupdate.h
>> @@ -1099,6 +1099,7 @@ static inline void rcu_read_unlock_migrate(void)=

>>   * In mm/slab_common.c, no suitable header to include here.
>>   */
>>  void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr);
>> +void kfree_call_rcu_nolock(struct kvfree_rcu_head *head, void *ptr);
>> =20
>>  /*
>>   * The BUILD_BUG_ON() makes sure the rcu_head offset can be handled. =
See the
>> @@ -1124,6 +1125,24 @@ do {								\
>>  		kvfree_call_rcu(NULL, (void *) (___p));		\
>>  } while (0)
>> =20
>> +/**
>> + * kfree_rcu_nolock() - a version of kfree_rcu() that can be called i=
n any context.
>> + * @ptr: pointer to kfree for double-argument invocations.
>> + * @kvrhf: the name of the struct kvfree_rcu_head within the type of =
@ptr.
>> + *
>> + * Objects that are not allocated via kmalloc_nolock() are not suppor=
ted.
>=20
> Is this true? If __kfree_rcu_sheaf() succeeds, rcu_sheaf is either flus=
hed
> normally (call_rcu with rcu_free_sheaf()) or via the irq_work doing the=

> same. The defer_kfree_rcu() fallback ends up doing a normal
> kvfree_call_rcu(). I don't see any path that ends up doing kfree_nolock=
().
> Am I missing something?

I added this limitation because I thought it doesn't make sense
to support this when we don't support large kmalloc and vmalloc in
unknown context.

Perhaps too limiting than it should be though.

>> + * kfree_rcu_nolock() supports 2-arg variant only.
>> + */
>> +#define kfree_rcu_nolock(ptr, kvrhf)						\
>> +do {										\
>> +	typeof (ptr) ___p =3D (ptr);						\
>> +										\
>> +	if (___p) {								\
>> +		BUILD_BUG_ON(offsetof(typeof(*(ptr)), kvrhf) >=3D 4096);		\
>> +		kfree_call_rcu_nolock(&((___p)->kvrhf), (void *) (___p));	\
>> +	}									\
>> +} while (0)
>> +
>>  /*
>>   * Place this after a lock-acquisition primitive to guarantee that
>>   * an UNLOCK+LOCK pair acts as a full barrier.  This guarantee applie=
s

--=20
Cheers,
Harry / Hyeonggon

--------------Zum3HQTusEj7uNFO4KwvsLy9--

--------------J0AkE62Qm6KEox29YcLjb809
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCamB8HQAKCRCGXBN6rc5S
1hFYAPwLQ01L3lAeQg0ZDcFbF72rH/98pNkQxh5OCV8Mp/HczwD9EC+wNsSqKXwf
So24hkqJiRfI/5vgRW5WwTakc0peTQo=
=WsKZ
-----END PGP SIGNATURE-----

--------------J0AkE62Qm6KEox29YcLjb809--

