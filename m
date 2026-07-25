Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3036C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 16:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5C976B009B; Sat, 25 Jul 2026 12:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0C6A6B009D; Sat, 25 Jul 2026 12:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AADF46B00A1; Sat, 25 Jul 2026 12:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5F16B009B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:28:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 16C6A1C04B5
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:28:34 +0000 (UTC)
X-FDA: 85027832148.04.DFF2D52
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	by imf09.hostedemail.com (Postfix) with ESMTP id 09681140003
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:28:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=rdhvH977;
	spf=pass (imf09.hostedemail.com: domain of deller@gmx.de designates 212.227.15.15 as permitted sender) smtp.mailfrom=deller@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784996912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yIatGR7BxVlsPtV5mXKcWjGLb6heraxX3D5hGyBKDu8=;
	b=CIMGKfi14gQV29UAcYVYtYrUfsJfX5ayDXYkg6fF2mDCpBMOL73WQS4nneYsbnkOMIaIrK
	E0LxmMre4pr6zs6tD8H/jqj5LBT/v/G7Nmjb9esaiKNaMt8eVrHXi3aS6JbIew3brInh1U
	4+ypk7gbuK/mi57Fj6A1A6vow19G4ZI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=rdhvH977;
	spf=pass (imf09.hostedemail.com: domain of deller@gmx.de designates 212.227.15.15 as permitted sender) smtp.mailfrom=deller@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784996912;
	b=Bt/9ohFUfFbStaV7+NYj7JuMc6oD9Sbl0X5pFebHJWx7QY3LvD5svmku9iog8wKEvRZ88M
	BZvcbggahv5PITJv62dRT0TF+F/B4dfxWSqGG6DQwx9hx7w2SRHvav+OfMRzztEE4OJ8Fh
	p/hPKjLhw2aTErZUfXZkCTQ0+hrPBNU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1784996862; x=1785601662; i=deller@gmx.de;
	bh=yIatGR7BxVlsPtV5mXKcWjGLb6heraxX3D5hGyBKDu8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=rdhvH977xNVv0HGGK5O3n3yeLEWEPigQp7p3pENliC8Ntf1Q+OQ5ffkSu0begiSK
	 7aD3kg5eSy2FvL2BT23AyDQcvJfjkHn3Xz3Q5jNQ4xDNIFkKYA35OIvYbU6CBZOfL
	 lwx4UnwOY5J2W8wB5+jqCeEaWqPVPBiZIqZWTLlBEMveB/eT8t7RxGp/3MuEPyTMW
	 i9uhLhGu8pd7OaYaeFpGofBRi+601FCHRH1MRdF+it2btYqNkl0i6jWD52Tf8ZmNz
	 CoAY0M7Pjzm+cPrAf3z/XlZAx65C4zQYDl++200Vvc4F6QyVAAm/gxNJ4UokqED52
	 20IwUOXrmg4+8QTKWw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M1Hdw-1wqQ6u0OJG-00GYk2; Sat, 25
 Jul 2026 18:27:42 +0200
Message-ID: <3e9dece8-4e86-4ce5-bd74-b3ec305f3003@gmx.de>
Date: Sat, 25 Jul 2026 18:27:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm/parisc: constify ptep_get() argument
To: Usama Arif <usama.arif@linux.dev>, Pedro Falcato <pfalcato@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kevin Brodsky <kevin.brodsky@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <20260724102017.141532-1-pfalcato@suse.de>
 <20260724102017.141532-4-pfalcato@suse.de>
 <0fd713a8-e4ab-4c07-b36e-79dd138b4a86@linux.dev>
 <amNzLXuwflIZFKtI@casper.infradead.org>
 <253f7ac0-205b-42f1-9fb5-d19eceb581b6@linux.dev>
 <amOEUZlp1BxYh6_t@pedro-suse>
 <fd239383-dcbe-4daf-b337-32facef07076@linux.dev>
Content-Language: en-US
From: Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
In-Reply-To: <fd239383-dcbe-4daf-b337-32facef07076@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:XvEnQPYweOvdRlakB++BxNs8G8wkp15F6t4WcV4lTCEzkxz2evz
 ulkt5g2+OsJwb46K3fnZ8xxVK6MsyDBPGxEQJ0HDIyVaA5TeSiThrvngIAkKYtyVFB0Fvk2
 DpSQ2vU++551bzQrR+zPKyZuOcJNUEELMpikxVjIql6ipjTMHaG8v32wGLqfGSBmCi1S2ru
 yhOQhpXQbYPQQY6vF4ptA==
UI-OutboundReport: notjunk:1;M01:P0:qTUj568q8PU=;JI4h/ZapZ84XNFeW1sk3xYdVhzf
 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
 2Qm2L0Gh87zVPLri14Y+QWGktFWmo9
X-Rspamd-Queue-Id: 09681140003
X-Rspam-User: 
X-Stat-Signature: ahobneuto8pzwqpdnskeuueewcbzncqs
X-Rspamd-Server: rspam04
X-HE-Tag: 1784996911-232865
X-HE-Meta: U2FsdGVkX1+DoKfCcNLmMehYL3hRt2q71coa/FmnNg+CLrt2rdOeZNMRIOHprKAaWs41dwsvb+L9lNxncUSWFopiXpGuJb1BPIPrxWhF+1KetpG+0XyBqvdG7k10R4rHssf1LXkUN5NwMvXadkFyRCA7En/4i60hmDjLh48CJIrvEzH7g7vNlGDycgsXXgRgoLp6RD31jq2owtSx/PEAkUByHNRfLP9llQ7q2ZHhrCDluKu9LUJPmW7mQALTuxz8R2FBHn8GNbGyZ0b92VMeW7xOiX5TR7s4FnJAlrXJ5uQryVyIUPFCIBQk0TMIGGnl5qmORZCwSxwIu8pSNVaC9HCERkNF4lAPjCPhhw2YI8R01AGCZuhkVaM5bBkTiJyeOmiCYhZLawCsxL9OA6EsFFhODneirvsVYvpdZrB8dGpV+t94NZaex7uLZSi9HBI3G5RsHNULeOyb5/Nk32LTqgX3k++Ws/lrozlZMTb8YmvBl65QhI9sPESmUDboDeztmgYgw0hSpF3AatFGe+/ncGX0qtsKnDCq4zzf2p98s/hU6ksZtIaCre/nt6wsLkLtMVO9Oeiy0Rv/wa78W+Aw4UH7UEqx+Mc0BvYW4nA2+5enPmLWle26aQZDmulKI9LWea/JqlDYaXqvvSHnBO0u9M29olamIUkGAZEOORj+BKt7P77E0Nbsn+9Oo4iAz2aArn4fr4lF13PYRg7Hak2bW8qrvNSaQdYkJo00wzMe7+7SA92iTkpgK3MwSrztV32/V6aFNGxqqDqVlrB7vOmwk3iqZ4dp9Ja3vrJfR41ba0Pki+vfJUYrkEXEHUJ6Xo6nl3lao9yc7Dxugo5dATpblwEg7vqiw609KJUvW7G7zmoMi/K+fTbaO30pfXPICUhcNA/LNwkkD5I+T/a5XsE0fJiVqaNWHNP8kvsQBL899D1HyQincdhVZawMPdj6hhgm/5v0GMBRY7tePYU8zbl
 ugHmC8r2
 Y+v9XXNAOOXJYz9PwxpKXj1AUUBLgvxr5l7eqlnhT1mom7G7LqiF0XPAFe3ctqjWJjUaI516R+X5MACfNMnNKGWr1AGjhh3ZOTkZQviapvlPf2MsgV1d8TCGYqAli9b/rBcwzZsmOUHp50nkAGXQKX/rO8KV7GGlEjA0NrRmPKeJwJ/eSt9K9GQSGkPP/X3PUF2Ep55Gg8EkP7NV2Rq23PBMfTqpZwUIO2QVIj2GCrUDMg0oSTAd+oHIxoUNxXTzBxiDyaA+r9VDsGHb9Vj2VTcHWoWZCn0HPLoqMugfg6qKZ1FxWjiFJYnGkqyu3OXniQAuqZRYKFmUQQPPb13mxWnwkxQ9yGx2inLS8aouPTPRUgmj7zD/gzNfInXXjIZEBWVDLLokWA5IPOohNe1QbcjBxccJ6FUNOsaDn8VeRPvpYvOJfX21Dz3vkMlwwNG4EgeBP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/24/26 17:48, Usama Arif wrote:
>=20
>=20
> On 24/07/2026 16:32, Pedro Falcato wrote:
>> On Fri, Jul 24, 2026 at 04:03:44PM +0100, Usama Arif wrote:
>>>
>>>
>>> On 24/07/2026 15:14, Matthew Wilcox wrote:
>>>> On Fri, Jul 24, 2026 at 02:36:59PM +0100, Usama Arif wrote:
>>>>>
>>>>>
>>>>> On 24/07/2026 11:20, Pedro Falcato wrote:
>>>>>> ptep_get() does not need write access to the PTE.
>>>>>>
>>>>>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>>>>>> ---
>>>>>>   arch/parisc/include/asm/pgtable.h | 2 +-
>>>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>> hmm I think you might break build bisectibility if
>>>>> you separate out the patches, you should squash patch 3 and 4,
>>>>> with patch 1.
>>>>
>>>> I don't see how this breaks bisectability.  Can you elaborate on what
>>>> you think would break?
>>>
>>> Patch 1 does:
>>>
>>> -static inline pte_t ptep_get_lockless(pte_t *ptep)
>>> +static inline pte_t ptep_get_lockless(const pte_t *ptep)
>>>   {
>>>   	return ptep_get(ptep);
>>>   }
>>>
>>>
>>> ptep_get() takes a non-const arg till patch 3 for example for parsic.
>>> I don't think you can pass a const variable to non const function arg?
>>>
>>> So parsic won't compile in patch 1 and 2, powerprc wont compile
>>> for patches 1, 2 and 3..
>>
>> Aha, yes, nice catch! I'll have to rethink that. Maybe squashing the pa=
tches
>> would be the cleanest way forward.
>>
>=20
> Yes, squashing is the simplest way forward.
>=20
>> FWIW, the vast majority of architectures aren't doing funny things on
>> ptep_get(). E.g PA-RISC, loongarch only define these so they can use it=
 in
>> their own asm/pgtable.h. I'd really like to delete these but I can't te=
ll
>> if they are *actually* required.
>>
>=20
> Ah maybe there is something in git history on why it was needed?
>=20
> If not, hopefully someone from the arch lists could clarify..
I tried to remove ptep_get() and ptep_test_and_clear_young() from
arch/parisc/include/asm/pgtable.h, but this then triggers compile errors:

  CC      arch/parisc/kernel/asm-offsets.s
In file included from /home/cvs/parisc/git-kernel/linus-linux-2.6/include/=
linux/mm.h:31,
                  from /home/cvs/parisc/git-kernel/linus-linux-2.6/include=
/linux/pid_namespace.h:7,
                  from /home/cvs/parisc/git-kernel/linus-linux-2.6/include=
/linux/ptrace.h:10,
                  from /home/cvs/parisc/git-kernel/linus-linux-2.6/arch/pa=
risc/kernel/asm-offsets.c:21:
/home/cvs/parisc/git-kernel/linus-linux-2.6/include/linux/pgtable.h: In fu=
nction =E2=80=98clear_young_dirty_ptes=E2=80=99:
/home/cvs/parisc/git-kernel/linus-linux-2.6/include/linux/pgtable.h:683:25=
: error: implicit declaration of function =E2=80=98ptep_test_and_clear_you=
ng=E2=80=99; did you mean =E2=80=98pmdp_test_and_clear_young=E2=80=99? [-W=
implicit-function-declaration]
   683 |                         ptep_test_and_clear_young(vma, addr, ptep=
);
       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
       |                         pmdp_test_and_clear_young

So, I think the answer is, that the local copy of ptep_get() is used in th=
e parisc implementation of
ptep_test_and_clear_young() function.

Switching to the default include/linux/pgtable.h seems not easy doable....

Helge

