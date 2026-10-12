Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BED16CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 12:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D3206B0088; Mon, 12 Oct 2026 08:55:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA8F6B008A; Mon, 12 Oct 2026 08:55:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C0266B008C; Mon, 12 Oct 2026 08:55:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58A616B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:55:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1491160CB6
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:55:56 +0000 (UTC)
X-FDA: 85313971512.24.1B01020
Received: from mta1.migadu.com (out-252.mta1.migadu.com [95.215.58.252])
	by imf12.hostedemail.com (Postfix) with ESMTP id AD1B040006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:55:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="XAu/7C3r";
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.252 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791809755;
	b=haCJ2n4PE4JuT5cBUXplUa6P28c/eaIMu9sxO8KcIOgo4IEoBQExe2PdZV16aRwuniR7se
	9EtppFURNkTJ5xQQ3kKdky1RLmftU/P1H4lwBF5t98f7HlGD3dNOL3+1D+xo9QYsIoZg3K
	nDqk/YCIrDkjURG4NQ6NJ20KV6b5M54=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="XAu/7C3r";
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.252 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791809755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zVdDm9vWio9URlOBbk5H1FhupUhm6ZtZOBzYo8Bfqf8=;
	b=2Oc5g3Fn7hBSVHL9Ctoox4Xjm2V2EVeJ9beKRKHj601pMxBgy4rlnXrzgnrzo8eM/DoH7U
	a7ixOHyhAVCCOixWPfT+SD8tewj4b1AYrRdfe7WUIcfVU6u5X+BJm3ihdJEaRcSH1aYy40
	9EsHE50x8uMtSeRCZ7TaYq5y7saUJFU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=zVdDm9vWio9URlOBbk5H1FhupUhm6ZtZOBzYo8Bfqf8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791809752; v=1; x=1792414552;
 b=XAu/7C3rb/MZ5dpABy25laQ+yvYFKm3jheT5YLO5dLGM8GxZNKSkbbWwuhJ9SEenvzOqbKe+
 0YxDDs/UTQYCjF5V5k4VSp8AhWwcF4nVcYAW6TY0rLP0PqMN9sj3YrGtoc3RhOdNrYZ7YO3XjJi
 GbkgpeK1G0tNxMZ7rEWHlVR4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 018eb001ca5c019a;
	Mon, 12 Oct 2026 12:55:25 +0000
X-Mizu-Trace-ID: 018eb001ca5c019a
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 1/4] mm: fix missing page-table destructor in
 pagetable_free()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <asy-b7_C3SjnmSaS@gmail.com>
Date: Mon, 12 Oct 2026 20:55:06 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
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
Message-Id: <145CD5DC-6457-4E1E-8B9D-AE7D1EDB0AB8@linux.dev>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
 <20261010112457.49485-2-songmuchun@bytedance.com>
 <asy-b7_C3SjnmSaS@gmail.com>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Stat-Signature: ti1chuh1dpa5qbeqsr76eya48iynewbe
X-Rspamd-Queue-Id: AD1B040006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791809754-37085
X-HE-Meta: U2FsdGVkX1+0fKPtBxFpBOfudezkSsv+NvWb9NHDfGnpc/vLizN7v8VbMrqRBh3hk4bocZshsmRc2sktMKN9UZoU6uoPOwaNnD7WA7rnHq+0dueDCYZZfOqvXnIwES4W4BsxlqPuZkKWmBGF0SwSs2saTagjwR7fQqSyGLyFdNg25mXq0fVSKzwiBXbHjFRdrlnvTFldUe9lKmoHXTSBrUwrqcT/5Vg7JqJ+bpQ5aNXnQLpXs1vVL79vSAgtXDdC+auBINgFTYK8Gc+DZvn99c44phcVMY6+WWQUR6vqzsIFPC2q9YcUbxjLm2MbFhhByJuiPRsUZSocPsdPSxMAx3i8RKN4Z//heMg5Ku1LD0oniB1fkEw80Mh3J3pYpQPeDljVYoTqATXlHN9r6q2rreCv3kOX0H2wY2qLcluPzAS4/MTRWpFWpS21rsZRiSRrnnZBUSP0dFlA1DoSqNTl2+w2ADUHwOfNKAJNZXnC13BDiD05t9LZo1BUERS3H/zlID2eqw2CydY6VCfV6JA421+f83KTXdp6wE6fCumMbhqVrA8GoGRhcFNvPQvlcTqPPTS27+vLbYAeQDP+Yxnf0pJCJOaK1dERozmIPSLhDWJT4QJYEY+0LqmcuHCyU5a1KT8KYUl1YmUD4JL6rumqQUxpT3QQCeaDQbwOvNON7wsUg9OKTLDlQpjdSHWiatkrJ2AaiQi10xjqFgSOLI2MPK1uxsgSGXPN4e//5tsfHIMzctzsdSQCZbPBZABjlmuYIUur34QdaVB8g+pw6GIUT6+M5/gtx7C8UCv+mUVAGq5AUyUkyRfc2XGtwFlxmmq7xypkGKShIoKs52/3ANm+Vl4vfGoMmbI7wXCfT8FVg23uvDe3Ko1Xs8oPSrgIVcdttykeYyK1160gHoS7eE6Ru5EcMWddTH2F3Q4Q6QFwUuuYQ8XBCt0Dj82smHyiR2bPfZHYeGcTdoibFDcEF6t
 KCULoQoC
 6dX2CXpgP5Xo05oGsUlQvA08HLQnXabFUA4gy2svsRbvWWM2NAxa7+E322arROVDvbZmd7UUlNKWUTFeHODxe6ZRdWHi6RliDXvtWuCHuOXcAPbanbX9TMiUfavfzGyYJjV6lkMQFLmIqh2nPBqSY9rqf0NO9nzxjKdxzSNwDDmYSUKxVevXuyRYubAAsyFfVam67jXvg4/dj9ec1r+vZfUsYXIP1ju1GmLnc9fmPUFrCCBfGxoyHzTzs0Bnhw2/w+HYFE603ALEmY1On3PAIyOvIr+BKGtEA/AhiOqmRZgNHKzjFDlrKRDwoR3K2vUNy4BHEC14pDegHQfk0255r0k8fNPcfd+WWErF/ViE/yY9yAsY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 12, 2026, at 19:15, Jose A. Perez de Azpillaga =
<azpijr@gmail.com> wrote:
>=20
> On Sat, Oct 10, 2026 at 07:24:54PM +0800, Muchun Song wrote:
>> Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
>> pte_alloc_one_kernel() runs the page-table constructor for kernel PTE
>> tables.
>>=20
>> HVO (HugeTLB Vmemmap Optimization) uses pte_alloc_one_kernel() when
>> splitting a PMD. Restoring the vmemmap backing pages does not =
collapse
>> the PTE table, so a later memory hot-remove eventually frees it =
through
>> pagetable_free() on x86-64. That releases the page without running =
the
>> matching destructor and leaves NR_PAGETABLE elevated.
>>=20
>> Make pagetable_free() detect constructor-backed pages and run the
>> destructor before releasing their memory to fix the problem.
>>=20
>> Fixes: 49f599666420 ("mm: call ctor/dtor for kernel PTEs")
>> Cc: stable@vger.kernel.org
>=20
> is the x86 case covered for 6.16-6.18? as far as I can see, x86
> free_pagetable() only uses pagetable_free() since bf9e4e30f353
> ("x86/mm: use pagetable_free()") in v6.19, so the backport wouldn't
> change anything there. or am I missing something?

Yes, you are absolutely right =E2=80=94 thanks for catching this.

I double-checked and indeed x86's free_pagetable() only starts using
pagetable_free() since bf9e4e30f353 ("x86/mm: use pagetable_free()"),
which landed in v6.19. So for 6.16-6.18 the prerequisite is not present
and the backport would be a no-op there.

The correct trailer is:

Cc: <stable@vger.kernel.org> # 6.16-6.18: bf9e4e30f353: x86/mm: use =
pagetable_free()

Andrew, would you be able to update the trailer in the patch when you
pick it up? If there are further review comments that require code
changes, I'll fix this trailer as part of the v3 respin. Thanks a lot!

Thanks,
Muchun


