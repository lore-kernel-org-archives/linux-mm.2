Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71AD1CA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 02:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48A116B0088; Mon, 12 Oct 2026 22:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B1A6B008A; Mon, 12 Oct 2026 22:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 350EE6B008C; Mon, 12 Oct 2026 22:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 134E56B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 22:50:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F464A09F8
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:50:49 +0000 (UTC)
X-FDA: 85316075418.25.FF33EB6
Received: from mta1.migadu.com (out-106.mta1.migadu.com [95.215.58.106])
	by imf22.hostedemail.com (Postfix) with ESMTP id 84C0FC0004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:50:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oNPtqFiX;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.106 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791859847;
	b=0Uga2hfzHAySndAjHDpcgA3DZKf8PbeHJAfxRa0FzHyJ8nZ+AkUOaKbTMLigzsfeFPMfFy
	YMVGOCHTIWatunoQ7oQePnHt5of3wjkw9ZmDzl8kta+tnGijinnP04qCcB0vD9a14lDuQD
	vWPQIOFMjaS9mGX9ZHmaVe6MKERJ1Kw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oNPtqFiX;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.106 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791859847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CPwxJwwUbsYmUjf0+QOdw7ObRSYifXqwx8YV7+AcyYY=;
	b=VPlRczPRiydyiWdoNGVZsjvLlIdpNgln1HK5Nl2RxdjrzWBpvlhiRyiTmgBfTh3CvDAvAN
	LsBd5t6yk34d7ME4+BHoQFxfRmZhx6L4FxmnHoXufgIN8lPAeAevMtG7J6mbp9e3XazKGw
	qHJn67nLKBzTQ+MA0rqcOnqLv78GMsU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8wMdqUD76bepHOzOME5xbGf9H6wBMPJCOauRyfPWxJE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791859845; v=1; x=1792464645;
 b=oNPtqFiXxOnTU0X6djyqNB5Ani+3gr1I6RXWS1BqRJvAY16ZMR4dOS8JM5773LU8YHIiFcjn
 Bv1zvPpk1o0kxvVbA+SeDa2/4LNFdl6no0YIWSlHSQSsaH5xf3Rwttgyrl7E+zB/DFCIZSlN+8C
 ChXlTFK6PauB81+RAz+tia2g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a849ca26c8b26880;
	Tue, 13 Oct 2026 02:50:38 +0000
X-Mizu-Trace-ID: a849ca26c8b26880
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 1/4] mm: fix missing page-table destructor in
 pagetable_free()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261012193114.77147e0a43affa8ee1ae896c@linux-foundation.org>
Date: Tue, 13 Oct 2026 10:50:21 +0800
Cc: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Dave Hansen <dave.hansen@intel.com>,
 Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>,
 =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Alistair Popple <apopple@nvidia.com>,
 linux-mm@kvack.org,
 linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <200A83B9-233C-44C7-B4AF-0900BA1E09DF@linux.dev>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
 <20261010112457.49485-2-songmuchun@bytedance.com>
 <asy-b7_C3SjnmSaS@gmail.com> <145CD5DC-6457-4E1E-8B9D-AE7D1EDB0AB8@linux.dev>
 <20261012193114.77147e0a43affa8ee1ae896c@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 84C0FC0004
X-Rspam-User: 
X-Stat-Signature: bubeei3qq8eqb4ecxsce3f5gnoiquyt1
X-HE-Tag: 1791859847-381095
X-HE-Meta: U2FsdGVkX1+r52i0uxxOnpjJZ+4HUY0ytb+/fCDSU2Gxr1PMyyg9Uq7lI20HunB0La3EMBU5yFRwXsXGe0aGfBJH0rP65MM/8nehkyCLZev+iWv1mUzJGWKw9JqQInudbfiibH7cAd4X8aYztmvQI7KT6zXSlH4Ill5ko8HgS6EckFN2VVEpvqQI9ptab/45jX+azHaa2d4A/oZGR4kUHD867DAUg+5ggt1VwW+dAbka9y89x0g1SIvnyMcGfzH+zATVEyP/uhxFqMnLTPWfJq30tPZUeJ9OJ7mn4e78qiVgQi/gjWJAJMXcGQ9wL8+Joey6BE1yTl+Z+V4eISLYRnplDqo8Fx9jMQZa4zfGKKOoHOFfzePWwNcSupAm3SRlPtWp0v5a3N2lLm2x3ywO+VLMv4a4MLfY6vA+f6Za2gi6es1YgL6GPb3jXm3QOFw7A5HV00wbBXE4tOV+ZnngmyKD8JrGpAHL0hPafytaXihGpxHdxl+0Rn3aA859Zr1ek0veLWhAJpmmAZRNP+9s4USvbKa+j4enjBtpHCheec37acYJYmKheZQeyHI3xDBWo6aFmjdu9qI68JGLRlHCEqcA+mVq3VRdoZ6yr/lj8C31JKWHTsMY2uLkCpTrGcWPKDqeVf/2q81Hbp4NTgAmTKtTTNC2cH8E4kL8CECk0ox9f4vrWhR4tmlqgaJuLxefrnencu6PawgaKfgOmkjRCCnctA0n0HW0IkJMzWu9sNNAOdPt7iU3NqV+B8H0tG/iKAXYLTPwhS8+9MN4l15D45dC8lINdGGJCgXq0V7AP8EVKgBvaji22AaubtMlWrMl8scSSk0FTPU6+60G16ChMwySy3zxFP5TWpFlS1+GdsYY4P9O/tZbnS1S2+/w4sQ4HR0V3T7aOgkkzZKhTCXG+0TzZDon1joS5SAYPYU/J34KNxzWlErPOp7dOUTWhULTVPLNFkGT9LD+0dgq83X
 cNmz6IWl
 RlTZPGvj5zR0E+NXZP8F6M8BhjL8bywFIsaWsaeOqXjU4tHEPLNpCgCalvVm2Sc8l06VBhisL2f1gxLm2RBACWvntJGhqvggm4xr3/8GAlvclqKwiLy95V4sb6Zs/n0peOoyi4jN4SGmrIs2g6IlDl2+UahEU7UOjaQWpSddICDi2qJ7ivFTAHTi0Aqrrv/2jHM9oCqTPpsEq0Z1Ynopci5oNGiebetwKwokvvE/+0nQVlu20iRu6ix1URaWVvwR7DQwAFL1mS8Xtds+ERFUWeKfKmoO3WzEJgf9rmsH1nkE/pJ2L7cyMdLJzsGbZakLuWJjYX8sLiwLKuUugWrNh4DqqrOwvzUIaeGKNPOcHAXF0JusiQwjL3Xy2mq7pSTJGHrbC/HsuwfLN2+Pc2XeSUAQANB52iZfAO6bLdejrvz7WL8KZ5lt0NHf1wIG4XRnvc2G6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 13, 2026, at 10:31, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Mon, 12 Oct 2026 20:55:06 +0800 Muchun Song <muchun.song@linux.dev> =
wrote:
>=20
>>=20
>>=20
>>> On Oct 12, 2026, at 19:15, Jose A. Perez de Azpillaga =
<azpijr@gmail.com> wrote:
>>>=20
>>> On Sat, Oct 10, 2026 at 07:24:54PM +0800, Muchun Song wrote:
>>>> Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
>>>> pte_alloc_one_kernel() runs the page-table constructor for kernel =
PTE
>>>> tables.
>>>>=20
>>>> HVO (HugeTLB Vmemmap Optimization) uses pte_alloc_one_kernel() when
>>>> splitting a PMD. Restoring the vmemmap backing pages does not =
collapse
>>>> the PTE table, so a later memory hot-remove eventually frees it =
through
>>>> pagetable_free() on x86-64. That releases the page without running =
the
>>>> matching destructor and leaves NR_PAGETABLE elevated.
>>>>=20
>>>> Make pagetable_free() detect constructor-backed pages and run the
>>>> destructor before releasing their memory to fix the problem.
>>>>=20
>>>> Fixes: 49f599666420 ("mm: call ctor/dtor for kernel PTEs")
>>>> Cc: stable@vger.kernel.org
>>>=20
>>> is the x86 case covered for 6.16-6.18? as far as I can see, x86
>>> free_pagetable() only uses pagetable_free() since bf9e4e30f353
>>> ("x86/mm: use pagetable_free()") in v6.19, so the backport wouldn't
>>> change anything there. or am I missing something?
>>=20
>> Yes, you are absolutely right =E2=80=94 thanks for catching this.
>>=20
>> I double-checked and indeed x86's free_pagetable() only starts using
>> pagetable_free() since bf9e4e30f353 ("x86/mm: use pagetable_free()"),
>> which landed in v6.19. So for 6.16-6.18 the prerequisite is not =
present
>> and the backport would be a no-op there.
>>=20
>> The correct trailer is:
>>=20
>> Cc: <stable@vger.kernel.org> # 6.16-6.18: bf9e4e30f353: x86/mm: use =
pagetable_free()
>>=20
>> Andrew, would you be able to update the trailer in the patch when you
>> pick it up? If there are further review comments that require code
>> changes, I'll fix this trailer as part of the v3 respin. Thanks a =
lot!
>=20
> I don't know if/how the -stable maintainers handle a comment like =
that.
> I expect it's more reliable to do this via Fixes:.  Possible?
>=20

Thanks. I used this format because it is explicitly documented by the
stable kernel rules.

The shell-style comment is the format documented in
Documentation/process/stable-kernel-rules.rst for specifying additional
patch prerequisites:

  Cc: <stable@vger.kernel.org> # 3.3.x: <commit>: <subject>
  Cc: <stable@vger.kernel.org> # 3.3.x

See:

  https://docs.kernel.org/process/stable-kernel-rules.html#option-1

A Fixes tag alone cannot express this dependency. It does not specify
an additional commit that must be cherry-picked first. The documented
Cc comment provides both the prerequisite and the required cherry-pick
order.

Would this be sufficient for the stable team to pick up the =
prerequisite?

Thanks,
Muchun



