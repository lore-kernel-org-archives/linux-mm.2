Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FF96C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 07:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B2F76B00A0; Mon,  7 Sep 2026 03:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A6F6B00A1; Mon,  7 Sep 2026 03:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A05B6B00A2; Mon,  7 Sep 2026 03:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47C616B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:11:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4F261606D0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:11:00 +0000 (UTC)
X-FDA: 85186094280.25.D951FE1
Received: from mta1.migadu.com (out-41.mta1.migadu.com [95.215.58.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id B6FC8140008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:10:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hhgnm4SF;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.41 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788765058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHSiGbEuAeFAjGiivJ7HMyZlWUF2kTZ3Hz+I5kMVMuA=;
	b=q65loHs2UjGujUU/uruDaIFTnyL667w9cM7p8JfcEE5QkOmu6/LRqXSq1JKNlx+mXyvt3U
	TxhUajbscAADAO5mB0iKvKg2cska3hYm2LbNLQIOxnEa+nBr60yM9BkQqk+v+i0ncEOdM8
	6HzhOWPoMDC1f5SZoBR0zitoucR2LUU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788765058;
	b=JWhRn1XHYp5LRglNkSgxbAwkh2wpbP8/plpQoA0B7izHbj4V2QvP06qBYraM2vPDCe5wiB
	m3j6F5I2QDRR4zq8nb/vSa0fJUSx+2haDN4xjt86jEJnjj5oqofQSGeAVNLbVsAkMizhpd
	5i8TDQtwT8nBxdTStRyadkx5SFGddC4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hhgnm4SF;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.41 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JRRbxs4nGui4cuCx7AujhYPrgAf4uhXjt73M6I+9Ogw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788765057; v=1; x=1789369857;
 b=Hhgnm4SF3mmBLXXwrqe1ktY1xlHdGoWv2w2BCE2HumKS1+pUL4nAKQrsYQnapFDQQc78N2Uk
 rgBZ3HjruPMaxvlKWw8Hxod3H2vp1IM/cshr4OgpWiybzzy5RFkq1j45pvmbwh35oPMKTRih4Lz
 bQiREaJCKv5VQSlsI3pOWTdg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 9cad51a24e8e6336;
	Mon, 07 Sep 2026 07:10:57 +0000
X-Mizu-Trace-ID: 9cad51a24e8e6336
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH RFC v2 4/6] mm/memcg: return the memcg when putting
 memcgid
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <apxvRTMdmit7dYk5@BINGFANGGUO-MC0>
Date: Mon, 7 Sep 2026 15:10:38 +0800
Cc: bingfangguo@tencent.com,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7B499C0E-2A46-4EC7-A850-8CC2DA2B5D20@linux.dev>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-4-8edd7f7a7251@tencent.com>
 <c3bec318-ef9d-4d96-8a98-a68717c17201@linux.dev>
 <apxvRTMdmit7dYk5@BINGFANGGUO-MC0>
To: Bingfang Guo <bfguo@icloud.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B6FC8140008
X-Stat-Signature: tzohk7capqwo35i36w5rqn16ert9y86b
X-HE-Tag: 1788765058-19904
X-HE-Meta: U2FsdGVkX19+2lNxtcq3ky8qQo1WMf448NtrglEMl57xLbH4S/F4l1HooYu8J0n8jkCq2Xk02pcvNAqldqFBuknUAHTlLfRiFq0WZ3a5ah5/opdwfnrVuBGZ1UZ4G+EMCH8+iY+fgHKYHa8BVjF2VRBeyJrcCB9sEPvl1104YjVqjoHeXesXPicSbr7ETjWBdVPkBOmCTphwYlYTye1Qu+mUX9joCDjX3Wmt0FdH3YcF5MGs0OcEtwczFbq/APD4nIilyKh3MG/HbcgQKjg1JXzb2IZDQDE50rOkA++Y02EVaTsvYriLCIMEe3Wx5Ot/jjlwWsyMFqaC/mGVNRDnKhU/gNaT405V8Y6a/3D2YYF+GD4opVgKB2FSW311uiOnHjCWHRuJg+V/iyzoZ1KZeYyUtfbjj3EA3zUFHMQr+sy2qKTp6qHN7yZT1oan9vZdjwPGoMNntGWJwkrBJBIBjDegEmOh1+fl5FpPDKREwweB2oLghWXsvCbxbb9/yieKYsC/Dmi8F0yCIaznJ16tPhLBgdt7DzN9DTgOQVjEhEDQJYMGsWCWFPd12gPIQU61dUn6wxe6e/5sQvYM4U4PtjtOE0KF84JyHMZAO9nCm9NhHB9U2rlVGi6LYJdBojBgHLoPhETMY1RwNS+31lxbodh3Bl8QgWVXWO5AeB216g64AICfHnWyXgZUXzELf7I8yHwMk1zfm2CN+wjOAS6+LS6QkB1uazNFIe6Dh3aHt3qPM7J9MVbKr3FkRFFQklmtPKeWiXnShG+JDwPvfX59t4hGl4yLh/iUuFG87jp6+D7g/iwwJNsogP3Lsl97+laNezwtZzTADEWhME0gXf1quRwI600/7VLsIuBoHU/q53wihvsopPx1pGri+GuzeJ/sd3MS8lIhztuoY9bfRWtm1igjarh7rllMBMQDSt7c0WkUz0jQEWaPaGrjFFxoxe1gXneBQ61EcPGaI/n+o23
 h7xb8S8i
 QTY6EoJBoUPgZRjWE8M44KG+L2fuPFg2W0TBZ8ay6lQu8QdpiyP0bfXHR5FKQpqqFE9xKkhANNB0OuPZt4DGrrk0UqS6bhnu+1PvwAlfQrXg/xIHxTVtC8uiTmVsNlhgcew2PVMO9naHow1lA7qPm5tL1uPxdJcdq/HZJlak+ZzeGqRvugmPEPxiSB/wKTPIqN1tHXYibgQKEykovhW0aPY0UCDRIslf9sa59bCfBaARkVWEQvFTZmwKvBxXlF99iHGaxD3SxtluFVeOq/JC9C8x0pAa9tCiWovgFbUizh9iO19SK46u/scqQ4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 6, 2026, at 03:36, Bingfang Guo <bfguo@icloud.com> wrote:
>=20
> On Sat, Sep 05, 2026 at 03:28:50PM +0800, Muchun Song wrote:
>>=20
>=20
> Hi, Muchun!
>=20
>>=20
>> On 2026/9/1 16:58, Bingfang Guo via B4 Relay wrote:
>>> From: Bingfang Guo <bingfangguo@tencent.com>
>>>=20
>>> __mem_cgroup_uncharge_swap() needs both the memcg and the id =
refcount
>>> drop.  Right now it looks the memcg up by id, uncharges it, then =
looks
>>> it up again inside mem_cgroup_private_id_put() to drop the =
reference.
>>>=20
>>> Make mem_cgroup_private_id_put() resolve the id once, drop the
>>> reference, and return the nearest online memcg with a reference held =
for
>>> the caller.  __mem_cgroup_uncharge_swap() then uses that memcg =
directly
>>> and drops the reference after uncharging, avoiding the second xarray
>>> lookup.
>>>=20
>>> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
>>> ---
>>>  mm/memcontrol.c | 20 +++++++++++++++++---
>>>  1 file changed, 17 insertions(+), 3 deletions(-)
>>>=20
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 048c9bb0fad79..f0503a1e5492d 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -4048,14 +4048,28 @@ static void =
__mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n
>>>   }
>>>  }
>>> -static void mem_cgroup_private_id_put(unsigned short id, unsigned =
int n)
>>> +/**
>>> + * mem_cgroup_private_id_put - put memcgid and get the nearest =
online memcg
>>> + * @id: the memcg private id got from mem_cgroup_id_get_online
>>> + * @n: count of references to put
>>> + */
>>> +static struct mem_cgroup *mem_cgroup_private_id_put(unsigned short =
id, unsigned int n)
>>=20
>> Having an API that put reference-counted resources return a struct =
pointer
>> is a very strange design. Please don't do that.
>=20
> That's true.
>=20
>>=20
>>>  {
>>>   struct mem_cgroup *memcg;
>>>   rcu_read_lock();
>>>   memcg =3D mem_cgroup_from_private_id(id);
>>> + if (!memcg)
>>> + goto out;
>>> +
>>>   __mem_cgroup_private_id_put(memcg, n);
>>> +
>>> + while (memcg_is_dying(memcg) || !mem_cgroup_tryget(memcg))
>>> + memcg =3D parent_mem_cgroup(memcg);
>>> +
>>> +out:
>>>   rcu_read_unlock();
>>> + return memcg;
>>>  }
>>>  static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
>>> @@ -5816,7 +5830,7 @@ void __mem_cgroup_uncharge_swap(unsigned short =
id, unsigned int nr_pages)
>>>   struct mem_cgroup *memcg;
>>>   rcu_read_lock();
>>> - memcg =3D mem_cgroup_from_private_id(id);
>>=20
>> I think we can introduce a new helper like =
obj_cgroup_from_private_id(),
>> We can use the ID to get the corresponding obj_cgroup, and then get =
the
>> mem_cgroup.
>=20
> I actually did this in some local versions but gave up in the end
> because the ID should be referring to some memcg and I was not
> sure if getting some objcg from a memcgid looks normal.

But the current series is already changing the binding
relationship between IDs and pointers. You've already
established a binding between the ID and the objcg, rather
than with the memcg. Therefore, I think this is a very
natural transition.

Muchun,
Thanks.

>=20
> So if that is acceptable, I think it's a great idea to do like
> that! And the put can look less weird then.
>=20
> Thanks for your idea!
>=20
> Regards,
> Bingfang
>=20
>>=20
>> Muhcun,
>> Thanks.
>>> + memcg =3D mem_cgroup_private_id_put(id, nr_pages);
>>>   if (memcg) {
>>>   if (!mem_cgroup_is_root(memcg)) {
>>>   if (do_memsw_account())
>>> @@ -5825,10 +5839,10 @@ void __mem_cgroup_uncharge_swap(unsigned =
short id, unsigned int nr_pages)
>>>   page_counter_uncharge(&memcg->swap, nr_pages);
>>>   }
>>>   mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
>>> - mem_cgroup_private_id_put(id, nr_pages);
>>>   }
>>>   rcu_read_unlock();
>>> + mem_cgroup_put(memcg);
>>>  }
>>>  long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)



