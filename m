Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77926CCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 10:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B377C8E0079; Fri, 17 Oct 2025 06:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0EFC8E0016; Fri, 17 Oct 2025 06:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4BD68E0079; Fri, 17 Oct 2025 06:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 911A88E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:03:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 339D4160609
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:03:17 +0000 (UTC)
X-FDA: 84007168434.30.7901B61
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1B21840004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:03:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H4E9SeDq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760695395; a=rsa-sha256;
	cv=none;
	b=3h0oi72gpC51xYE0RZSMaXR14HIdcWIWECPOA4Rb+D6gCR7WdJWt9B3AUz6P0JRTHgm/A3
	MfGc98lbQT4xBWpMMHy+xZABI0CVGs7PX6dLehFe52UNo9u2a1mfVSsIzf3yx5S9IpMt2E
	ahJz7rF2Bwe7S5asXqAvQbuo4yzTl8U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H4E9SeDq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760695395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7T9fbRkF3jqCU0uPzbOUF0lxcaNuHAGLnaDOYW7kx98=;
	b=nEK9YydSWMJME2JD7VcnRnjg5Mm2UsA4eGcZ3Y2BkOpbzSy4OFV5mfWSuvu8i971fXeRVH
	NG19h+g2O45xDeh4DrBzUriMjZnUzgOmFdAF4gDYjt85MN18jD7JTjLWuhfRUz5JUpXGFH
	CjMwBMbEqoK/MdhbT+9yghMcZsE56DQ=
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760695393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7T9fbRkF3jqCU0uPzbOUF0lxcaNuHAGLnaDOYW7kx98=;
	b=H4E9SeDqU1sLWo2YpFChIWayvi4ND0Pf01lnG/s/cCcYpLSed1wy0J76NDDxw/r2ws8Sop
	SIS4X0VeIEtCTi9oDOAxuaO3AttPVpTdLmBHJn2cuI7QKJCgiHXaJbvzxPV3ld6lvaWpfN
	+cK9hsHrcT8GWxj/Ppba3k7f3PlxqEY=
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] slab: Avoid race on slab->obj_exts in alloc_slab_obj_exts
Date: Fri, 17 Oct 2025 18:02:57 +0800
Message-Id: <8F4AE1E9-7412-40D6-B383-187021266174@linux.dev>
References: <a9ca7cc6-f4d1-4fba-a9aa-2826b9a604bc@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>
In-Reply-To: <a9ca7cc6-f4d1-4fba-a9aa-2826b9a604bc@suse.cz>
To: Vlastimil Babka <vbabka@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1B21840004
X-Stat-Signature: o1r3mbwbmtyiywuptyzs88ktowx1fnfc
X-HE-Tag: 1760695394-860340
X-HE-Meta: U2FsdGVkX19/lm8XPNWGM3Io5GfFwo3WvCtSPzXqNqMGLAIChYoNC4UG5bKXJTQPPLbXcGPTm4fxLSa6TiBLmMywg1yzDZQ/Z+2uAoVESxukKqAkCyUiomajawCHKA+paKmj6k69SXkbXu8dMf22gu4fHTXDPmh4LhxNZzaP7OdW23HsSD+ih2eNQR23wzWP8tlUGKy4RWY0fLXkKK2P02POBmjd9aYLJd7heeFxf26hBUlu3CCHrD4MaEUvazXRBw30uXvLNS/StggpRT70raqUwxeL1XR34KzPmilcvbmjYxAjeHdbFckrQON+y0yLz4jIh4BQTipk5r/VjcL2r9jpMyh0IAzA+c5zHBTHlAIXFxttzqcRgYitKBFQtWXRFXepFh3+/PU1PQDlYDP5ISxABQJvCSz1e94TBx1iMKYPm+IzzUGRGEOCWB2dKRZWkxKOquFBe4TtxEiGE/CaGZTpZZ2Et/RAA5pVsD/+EGPyYzsTjC3YjTL+LQQDOx1IsOy+XhBzb4YIEMx3WX6Nzgkm6XXI9I2QvK0O+pEF+hu9eMSzhItRRcGemHaKVcvIOe7eLwslvDP7HvAC/eR0HTUfqIq9E7fyi0qAOH1heod3NYBmNzlt5FrpnlsqTx9zxtXcKjZ2tJ8iXF/7lHdRTjuUnGMRHWzwvOHKtoqL6DLMLycmeMXK9Tg9muEPOYWunyWrPCjeuCbkCmpFrUvEVCrHWo4AgDIYck/haJJJU9ZCGqX3qUqBaSVns8NCLzLBrKuHyPV67F2zp0mJZHJ/83yUXNMjSTxUpnc89HSzOC4dBZJnQ3FEoz968MAMXXPXtsUKHGDpMEcGzv6bbBUhXASlPFW93Hz8x6s5pJKxETf/OVB4PqbXoEOaFTluoXfqrBIy1V8nyhu0rdUP0PjU91rLp/iovGdqPesZsIaCB6ys00nJ7UA9QqWP0k0qBsYaPfTu84Yn460IieiwP0O
 bsaj1xuC
 sKs7xZnCaktKOxT80deYtewye6+NbhB5cSUiXbxP3MwKzE1V8+VTVYkjm5Fb5ASxZ1LnVqKZI/cYpwFGaEmxWpG/dP6U3M07IA3dDAyvrTTwjmufG+EDbOe1h8BvZzl0TdPfCFRX4oSPWHmSQeWxqJlYZBfsVq2J3e8O3N0QPkch8bdSqSvHlxn/LcEyV0C4qVBipXbhYFxg5q7nBzJEvgIp7rbf8zWw6t4BZ5bgb5klCmp712PpTNM8oeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 17, 2025, at 16:22, Vlastimil Babka <vbabka@suse.cz> wrote:
>=20
> =EF=BB=BFOn 10/17/25 09:40, Harry Yoo wrote:
>>> On Fri, Oct 17, 2025 at 02:42:56PM +0800, Hao Ge wrote:
>>> Hi Harry
>>>=20
>>>=20
>>> Thank you for your quick response.
>>>=20
>>>=20
>>> On 2025/10/17 14:05, Harry Yoo wrote:
>>>> On Fri, Oct 17, 2025 at 12:57:49PM +0800, Hao Ge wrote:
>>>>> From: Hao Ge <gehao@kylinos.cn>
>>>>>=20
>>>>> In the alloc_slab_obj_exts function, there is a race condition
>>>>> between the successful allocation of slab->obj_exts and its
>>>>> setting to OBJEXTS_ALLOC_FAIL due to allocation failure.
>>>>>=20
>>>>> When two threads are both allocating objects from the same slab,
>>>>> they both end up entering the alloc_slab_obj_exts function because
>>>>> the slab has no obj_exts (allocated yet).
>>>>>=20
>>>>> And One call succeeds in allocation, but the racing one overwrites
>>>>> our obj_ext with OBJEXTS_ALLOC_FAIL. The threads that successfully
>>>>> allocated will have prepare_slab_obj_exts_hook() return
>>>>> slab_obj_exts(slab) + obj_to_index(s, slab, p), where slab_obj_exts(sl=
ab)
>>>>> already sees OBJEXTS_ALLOC_FAIL and thus it returns an offset based
>>>>> on the zero address.
>>>>>=20
>>>>> And then it will call alloc_tag_add, where the member codetag_ref *ref=

>>>>> of obj_exts will be referenced.Thus, a NULL pointer dereference occurs=
,
>>>>> leading to a panic.
>>>>>=20
>>>>> In order to avoid that, for the case of allocation failure where
>>>>> OBJEXTS_ALLOC_FAIL is assigned, we use cmpxchg to handle this assignme=
nt.
>>>>>=20
>>>>> Thanks for Vlastimil and Suren's help with debugging.
>>>>>=20
>>>>> Fixes: f7381b911640 ("slab: mark slab->obj_exts allocation failures un=
conditionally")
>>>> I think we should add Cc: stable as well?
>>>> We need an explicit Cc: stable to backport mm patches to -stable.
>>> Oh sorry, I missed this.
>>>>=20
>>>>> Signed-off-by: Hao Ge <gehao@kylinos.cn>
>>>>> ---
>>>>>  mm/slub.c | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>=20
>>>>> diff --git a/mm/slub.c b/mm/slub.c
>>>>> index 2e4340c75be2..9e6361796e34 100644
>>>>> --- a/mm/slub.c
>>>>> +++ b/mm/slub.c
>>>>> @@ -2054,7 +2054,7 @@ static inline void mark_objexts_empty(struct sla=
bobj_ext *obj_exts)
>>>>>  static inline void mark_failed_objexts_alloc(struct slab *slab)
>>>>>  {
>>>>> -    slab->obj_exts =3D OBJEXTS_ALLOC_FAIL;
>>>>> +    cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
>>>>>  }
>>>> A silly question:
>>>>=20
>>>> If mark_failed_objexts_alloc() succeeds and a concurrent
>>>> alloc_slab_obj_exts() loses, should we retry cmpxchg() in
>>>> alloc_slab_obj_exts()?
>>>=20
>>> Great point.
>>>=20
>>> We could modify it like this, perhaps?
>>>=20
>>>  static inline void mark_failed_objexts_alloc(struct slab *slab)
>>>  {
>>> +       unsigned long old_exts =3D READ_ONCE(slab->obj_exts);
>>> +       if( old_exts =3D=3D 0 )
>>> +               cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
>>>  }
>>=20
>> I don't think this makes sense.
>> cmpxchg() fails anyway if old_exts !=3D 0.

Aha, sorry I misunderstood what you meant.

>>=20
>>> Do you have any better suggestions on your end?
>>=20
>> I meant something like this.
>>=20
>> But someone might argue that this is not necessary anyway
>> if there's a severe memory pressure :)
>>=20
>> diff --git a/mm/slub.c b/mm/slub.c
>> index a585d0ac45d4..4354ae68b0e1 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2139,6 +2139,11 @@ int alloc_slab_obj_exts(struct slab *slab, struct k=
mem_cache *s,
>>        slab->obj_exts =3D new_exts;
>>    } else if ((old_exts & ~OBJEXTS_FLAGS_MASK) ||
>>           cmpxchg(&slab->obj_exts, old_exts, new_exts) !=3D old_exts) {
>> +
>> +        old_exts =3D READ_ONCE(slab->obj_exts);
>> +        if (old_exts =3D=3D OBJEXTS_ALLOC_FAIL &&
>> +            cmpxchg(&slab->obj_exts, old_exts, new_exts) =3D=3D old_exts=
)
>> +            goto out;
>=20
> Yeah, but either we make it a full loop or we don't care.
> Maybe we could care because even without a severe memory pressure, one sid=
e
> might be using kmalloc_nolock() and fail more easily. I'd bet it's what's
> making this reproducible actually.

=46rom my understanding, it only affected the obj_ext associated with this a=
llocation, which was subsequently deallocated, leading to the loss of this c=
ount. Is this correct?


>=20
>>        /*
>>         * If the slab is already in use, somebody can allocate and
>>         * assign slabobj_exts in parallel. In this case the existing
>> @@ -2152,6 +2157,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct k=
mem_cache *s,
>>        return 0;
>>    }
>>=20
>> +out:
>>    kmemleak_not_leak(vec);
>>    return 0;
>> }
>>=20
>>>>=20
>>>>> --
>>>>> 2.25.1
>>>=20
>>=20
>=20

