Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEA2D606A320
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JVpSAE7s
Received: by kanga.kvack.org (Postfix)
	id ECA3D6B0771; Tue, 27 Oct 2026 10:04:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2936B0773; Tue, 27 Oct 2026 10:04:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8286B0774; Tue, 27 Oct 2026 10:04:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B35806B0771
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:04:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C60A1605F7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:04:26 +0000 (UTC)
X-FDA: 85368576132.04.2BD7A8A
Received: from mta1.migadu.com (out-169.mta1.migadu.com [95.215.58.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id BF7A940013
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:04:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JVpSAE7s;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.169 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793109864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6EV0y0rZNOrxKdLbmUoelWmdjOtw2TON5MFmaUpTBGs=;
	b=vbkRwz1TRMr8m2XNmqzWs5CqhYH73dcUTcptklDOGlviwRZ2AKWNhZgk0ve09o5yPAd4MO
	fHiof/vdCmpTUwjz/C5kVt3bm1AR2SW/gD6ACJhijXPn8aoo3RbmhydggPoigcjHOVKXaU
	QXROnqP9tsaUi66K/EZiWfrXZO2rwAo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JVpSAE7s;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.169 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793109864;
	b=ICL7NoJ94K6i68Ju2idvXEACVvDSjbAIHklB6FUjujoZq0xb05bfZXV5/BfHPgcCoIP6EF
	h0+/uVmMg2W5mJqSEqKP8G6FHAro2XmAwR5FQRplKRg/ZCsElvtll5B3LJCHtpwTKan3tU
	uxBwDI/Hx6fybtFUIbJXNSIUZ6VTE6I=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6EV0y0rZNOrxKdLbmUoelWmdjOtw2TON5MFmaUpTBGs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793109862; v=1; x=1793714662;
 b=JVpSAE7sa/CBBarlh3S+abLMqE64/O5GkAFR6jFVMMd1YPsboVvsspq0Iqqumk4aGOJjzy4D
 DUjBLrBmcg6VGTf9Tq2EpIcDEdEcR1JKYSpIBDwOiHlcDvyWfVdL9y1Gj58CxhQH7rdh2K7LNdk
 PYf9iCvGMGj2cOyqnqyV7n2E=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 094579383d15bde2;
	Tue, 27 Oct 2026 14:04:21 +0000
X-Mizu-Trace-ID: 094579383d15bde2
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <d7a634b6-8668-4753-8bfc-e9334dde705e@kernel.org>
Date: Tue, 27 Oct 2026 22:03:54 +0800
Cc: Kiryl Shutsemau <kas@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4A32F5E6-977D-4720-8723-B19AFBC08FCF@linux.dev>
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-14-kas@kernel.org>
 <ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org>
 <at_f43oDv73y-t7O@thinkstation>
 <f97a8d33-50b2-4a86-8381-ee840cdfa2f9@kernel.org>
 <20261027110028.GH2668564@noisy.programming.kicks-ass.net>
 <auCKv_omLGRc6wv2@thinkstation>
 <f3f3aca9-bdb7-4aec-9099-9fb63a60e61d@kernel.org>
 <auCZFckDfBMrlfxV@thinkstation>
 <070DDE5C-2183-4A8B-AC2D-891CAE15E581@linux.dev>
 <d7a634b6-8668-4753-8bfc-e9334dde705e@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: BF7A940013
X-Stat-Signature: 9ojgxjbf7uhq6rx3sz57nfqx9pqe3c1j
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793109863-940550
X-HE-Meta: U2FsdGVkX18eHNkDqcr9VZJHJKdLdnc5l8JrJl+AkrloeO5/K5Pe+vRTolBUR34l8BmT+9hEHvESeQaJ2POFESCJFMuTAZnfzivM0orF7cUIrOFxfQwxVcdwQDnqZo+akq/HPHJMaUQ8jiNw13J6+560xADjqtq1OrA3JmiGOH2K0OpZbCwBzv8rfDUfyeJc06ech0tMsoyShqiTT1zVvRkijLOekq0Y7ftXdGOhEDoGiX5CMG9UY/rNZgolR41Yxj/cW0WL+5A+veC/phtjnIlP+ffv90eY8MKUmn5oCQdZdi0NeJ1Gz6fEo7BgTPGHE/FNK/pzoDp6PL67V+XLqqe8zhhx+/LPAm1Y94zGCk2Eu7Hecl1CFjw0Z7W66/GAeEnZYSLe5aEUTFTc+/s8TfxR4ba5+w2WfBr9RvTNnsOJPj3zO8DXrSDmW2HxDpjguLhENQF5UUDtw0Jq3gVvqBXsT5yk2+XvVuaCy9QOeiw32HeI3JoGlTWfiBijH3EGweq94Bxupk2Ku7IMp6v//E5z7PEoZK5VKN0f7sI89E6bVKOwZtC3HmbjVrMn8FHV0edeKfob0cE4d2yZvZJrulL1OQ/6OviKT2DeZpVx/5aXEjQ2vS9WIRFrob72ZWPJzNft3Ai6tf3Tw9jGh1KBRMYYbFeYcgOoCJbEYy248f+A5mBhj5modiEPz6ugBHJYK8uAgLgvAOSgQvyejDkJLlDmcqz4EEQ0SF9pHkotRNJ8bpsYeSyi7eALW1Rsmq1zdHRe5ETqX+huFtas8GyqxRftctiH4ANokjdpTbmxp+m0Pdjwlug+vvaK0jkqusHWjBIKgN2J0XVe3FUejUe+/c3b3E95QxgNHcnZRnuzZnm3zSKsQDxsKhBDC3M+XQ/HT2ax00zeuxFKLrEfDyuF+dcsY3fLpLi25l9Dao8aYi83WP2N/f4+fXjWbnpopEii/aD6kgp16p1pDlGdgAU
 cUruzDFx
 vT86vFkvK1jg5D3i/kOXHyuv0sg7ptT3ZZ7fMily/ULNZy4NbME5DY++0YJcQDj59Zn+6coGupruKOWo3QGyiybnmCEPY7dVkSZxu4WSIgeNJS3bTFc5O0rZOf+qIPozMnoxH4qMJxuGChnxomngpxSGrhdJvTtlvqFZyRDePvjAtENnRaoNnmk5nF417E+sQieloEVET7wrgcE+fQnVoOlHr4PH9HIUCrteJNcqryweQpEmYJxcVXX0XT6ba02eB3MvZEwclOc60gHg9JmQiIUruEwLlkO13UGOH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 27, 2026, at 21:35, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 10/27/26 14:13, Muchun Song wrote:
>>=20
>>=20
>>> On Oct 27, 2026, at 20:31, Kiryl Shutsemau <kas@kernel.org> wrote:
>>>=20
>>> On Tue, Oct 27, 2026 at 01:05:58PM +0100, David Hildenbrand (Arm) =
wrote:
>>>>=20
>>>> Right. Without HVO we would just corrupt pages in the single folio =
(which is
>>>> also not nice).
>>>>=20
>>>> I'm also questioning whether we need this RO protection all the =
time active.
>>>=20
>>> What do you have in mind? RO only under a debug option, or switching =
the
>>> tail page to RO some time after the remap?
>>=20
>> I don't think enabling RO only on debug kernels is a good choice.
>>=20
>> Within ByteDance, we once successfully caught memory failures using =
RO (because
>> we backported HVO, but some missing commits in memory failure caused =
write
>> operations on tail pages to persist). These operations triggered =
invalid writes
>> to shared tail pages.
>=20
> But would you have caught it with debug setting on in initial rollout =
/ experiments?

Possibly, but we indeed didn't catch it during the testing phase.

The likely reason is that we hadn't anticipated issues in a corner
case like a memory failure. Also, it's worth noting that during our
test and verification phases, actual memory failures simply didn't
occur.

>=20
>>=20
>> Under the old HVO schema, this invalid write only corrupted one =
folio, but under
>> the new schema, it corrupts all HVOed folios. Therefore, I personally =
believe
>> that for the new schema, the value of RO is even greater.
> But doesn't that mean that you would find serious bugs faster one way =
or the other?
>=20

Good question.

> Silent corruption of any folio state is not good.
>=20

Under the new schema, an invalid write causes massive corruption,
which would likely result in an immediate and noticeable failure
(like a crash or oops). =46rom a developer's perspective, this
definitely helps us "fail fast" and find the bug quickly.

So, let me think about what we actually lose without RO.

I believe the main difference is the debuggability of the crash context.
With RO, the hardware intercepts the write immediately and throws
a clear page fault with a call trace. Without RO, an invalid write
silently corrupts memory, and we might only find out later with no
clue where it happened.

Of course, losing this debuggability doesn't seem like a critical
issue after all. Thinking about it this way, restoring RW permissions
to fix this race condition seems like an acceptable trade-off.

Therefore, I am kind of leaning towards removing the RO protection
and restoring RW permissions to solve the race.

Thanks,
Muchun

> --=20
> Cheers,
>=20
> David


