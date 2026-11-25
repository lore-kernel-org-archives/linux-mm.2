Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95F0606A331
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JZyGbLbf
Received: by kanga.kvack.org (Postfix)
	id C28636B09BB; Wed, 25 Nov 2026 06:24:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD9246B09BD; Wed, 25 Nov 2026 06:24:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1676B09BE; Wed, 25 Nov 2026 06:24:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3EB6B09BB
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:24:59 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D9F3380E49
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:24:58 +0000 (UTC)
X-FDA: 85473409476.05.A851992
Received: from mta1.migadu.com (out-52.mta1.migadu.com [95.215.58.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id A4C2440007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:24:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JZyGbLbf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.52 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795605897;
	b=AI+IPbB1kkl7mzhpFIT746Y86kwGvjccO1bEOhcTi3Hwxm/OR4IruVK6OD6DfY9VuPOLzc
	AitnKHPoES9+lHC4FwtA/VP2bDjOhaH+u+4ymzZJZpL0gu/ag99+u/7UGlPvNrXt+OT2pW
	+KjYCreQyX1ER3OOFtskWROv604hYaA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795605897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h3phsWQfdxv0uf8XfVUgGfaDc5dsQnzDLtihhQEk2TA=;
	b=zg7C46kSK5pKZOB+U8XLGhILdmkTnkcg8LhkoXn+S3LJcyjQarqsVWSlMNPntbresFw6ti
	yio5EZi+4oyB3wYo9nsXBfVw8jHbzZEl+eWv1tklTzOYWzZzwuXs7OT5i4JtSQH1PHPo3L
	JA6G0ucBxobOVUDhT6G/qkE2D5vufwI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JZyGbLbf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.52 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5QCnQHYvVrARR6qeDXaM4h3qgqVkX81GKomM7qBO+tU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795605895; v=1; x=1796210695;
 b=JZyGbLbf4g1+ZSDf7saAvyLqtYnar3iWT0OgWH4IudSvI19fRDnoNN8H+GgYCZij+20SdI83
 24tgdSxPF7zVU5bZ2SKIjZt/3r8agRgTixW6m4dOk0rOPE6kR4PeQuBluyz8i/uCs6ERoA4KVV6
 rnd7rfFYsJhefkioDyF6CGzU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4bcef2c1382e426d;
	Wed, 25 Nov 2026 11:24:54 +0000
X-Mizu-Trace-ID: 4bcef2c1382e426d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 08/19] hugetlb_vmemmap: Expose whether HVO is enabled
 to architecture code
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CADrL8HXPKfUhRaVhVyV6CPoQ2apZx1FCpyqyPMr=p=Q_kF3HBA@mail.gmail.com>
Date: Wed, 25 Nov 2026 19:24:31 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Linu Cherian <linu.cherian@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Nanyong Sun <sunnanyong@huawei.com>,
 Yu Zhao <yuzhao@google.com>,
 Frank van der Linden <fvdl@google.com>,
 David Rientjes <rientjes@google.com>,
 linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0EFB24F3-D3F2-4B28-9684-68CCCC1E80B8@linux.dev>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-9-jthoughton@google.com>
 <9487E341-5F59-4245-BE0E-EFDD413E45D2@linux.dev>
 <CADrL8HXPKfUhRaVhVyV6CPoQ2apZx1FCpyqyPMr=p=Q_kF3HBA@mail.gmail.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: A4C2440007
X-Stat-Signature: rsze46hqhf5x93je1qir8ru4jj6phb4s
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795605896-431809
X-HE-Meta: U2FsdGVkX1/yU2ZL2FePq11BCjwdqNtMKCMcJ3NYsDtfyuPL8GkVyAxlDLclsyjFx1yqKK01YArMTFJ/77/mU6qvAFRr4cNqHiMJEEdB+BHww3cpsuOwmtfhCVbiIbWmPncZ90PpgIcXUV/yTTKWgByLvqXLp9HsL7E6GPJxUYhjPzjDdlxmQmjY+sUefT5v4QsO56rMg/uGrFqevEBvgqjbMV37gGxkVyDCINci+SwOMBf6NbcJKh4ctp6ulbTiLdkRtM7hIde2MrdCVdquMAKB94fIFPsm2mGBRs6weBLUYRsEDtdyTKR+fJYfSne3IYHfsU6STE4eIngrCU7xGkFfMS7D2bvWoE9Iw/vU+bunMXl41QkuYO43ufqYXCJqO/dsxi8jMy9BEkYe1DFTExWv4Yt9V4yDkiA/DTgx0cXgUl2Y5ouZeYdAdXXdAxcB/mxn1EesocSSa084a80ZOV2ziPDOz7z2ZkAKDEMbUwbU0jgB0fFuFHH74T1iS+06T3j480r1SW8v8WqL70RlwbFlSGac2d2osMAUOIZJPgXpBPp5JYLAwFNFz52xK76TBGQIuwMokVJTl5X6xWc1WhIbRFrcUoANaDLu8WSL6XswGQA1QVEBgp1YJKKACAzXHTUU9n+jAJY0iRG+tad4b63iyE8TCCnYxYiMettnO5d2hU/cRzQtmf4J1ZX4kY2glAc92tkHJruLbDK3ed1Y6+56IBv4HDgkJHht8fiLBWStYQnjM0Wjk9t1SQ2l18q5gEVnBCw9jN4xUO8Lz6K05ZCBQ8JhdkD7pYlYxzPDHcM4mzuBeRoY8P09CWCTicwXtYPlBltlYV2CNdi4qQn/TMokjt/eaAIs2EnIj1mQW13Wse2OOlyJ3cJSynq+Nth460+NZPZV9+9coWXLycELhmn8am9NTFwbu7zmWXUoqSb+5M9FaH71SVUMwfGVAAhT8+4sMik0rGhbAk/yPRs
 skktaD1R
 JkmPgSwzvVngp25rxmeezmgsJuF7kalfZhXRF/NP4kLeS1tNWqfQXPjutBdYDRYpCJjc8MtXEWcT2Ej3OElhZaAoziOJ9P65xJBsWqh8rYAc4bX0ptuus6hB3zpKl8ChiVR1UgXILd41+l2n+8e4oFbcUVKU+vjYH6UPPupFQps9/PPdozUWB00eiUOjSelurKY7C2HqMMnLjej+LLav62+9ioeCCZmO76WChSHPJdAajknokZRM2oRUvpbLwDBIayfXYmU7algx8O0dYaUMUGtAwaQBiZe+vqIYLt1g95vdMxxKvhCut/xxluVDnzi4EeC+OPE9EbnN8P/+LRWDdYVKMjcAjwsV3vD6Mx2qzFmUM2RySWpPltixodHHgzOe0rPk7sU7zLIMe6DKdPjUT3Wd34BewkwHjWUW56BO7tR/JjtQG29X6PyRlMzpLVWXpQOOlGRRICXYUWyqLDQ0NEg8473RB4RLxn5Rjngfb/sxio4lWogjR6oMd1/eKaDCuzOhN2itCL8JQEmx7SqD3yZ1JDXt4MPhuXaefwtz5g9KC58rzRFkqlAvIAANBFmHqySjdAmb7qmmRBU0OKP2raKwgBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 25, 2026, at 01:13, James Houghton <jthoughton@google.com> =
wrote:
>=20
> On Mon, Nov 23, 2026 at 3:50=E2=80=AFAM Muchun Song =
<muchun.song@linux.dev> wrote:
>>=20
>>> On Nov 23, 2026, at 02:44, James Houghton <jthoughton@google.com> =
wrote:
>>>=20
>>> Architectures that select
>>> CONFIG_ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCTL_RO may configure the
>>> system at boot depending on whether HVO is enabled, e.g. arm64 may
>>> require all CPUs to support hardware access flag updates only if HVO =
is
>>> enabled.
>>>=20
>>> Add hugetlb_vmemmap_optimize_enabled() so that they can check. It is
>>> declared before <asm/hugetlb.h> is included, so that it can also be =
used
>>> from inline helpers there.
>>>=20
>>> It only reflects the hugetlb_free_vmemmap=3D kernel command line =
parameter
>>> (and the sysctl, when writable), not whether the architecture =
supports
>>> HVO.
>>>=20
>>> Signed-off-by: James Houghton <jthoughton@google.com>
>>> ---
>>> include/linux/hugetlb.h |  9 +++++++++
>>> mm/hugetlb_vmemmap.c    | 18 ++++++++++++++++++
>>> 2 files changed, 27 insertions(+)
>>>=20
>>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>>> index 0d5414392d87..b2a6441bcd84 100644
>>> --- a/include/linux/hugetlb.h
>>> +++ b/include/linux/hugetlb.h
>>> @@ -22,6 +22,15 @@ struct node;
>>>=20
>>> void free_huge_folio(struct folio *folio);
>>>=20
>>> +#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>>> +bool hugetlb_vmemmap_optimize_enabled(void);
>>> +#else
>>> +static inline bool hugetlb_vmemmap_optimize_enabled(void)
>>> +{
>>> +     return false;
>>> +}
>>> +#endif
>>> +
>>> #ifdef CONFIG_HUGETLB_PAGE
>>>=20
>>> #include <linux/pagemap.h>
>>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>>> index 142f2975846b..fb6da64bd80d 100644
>>> --- a/mm/hugetlb_vmemmap.c
>>> +++ b/mm/hugetlb_vmemmap.c
>>> @@ -452,6 +452,24 @@ static int __init =
hugetlb_vmemmap_optimize_param(char *buf)
>>> }
>>> early_param("hugetlb_free_vmemmap", hugetlb_vmemmap_optimize_param);
>>>=20
>>> +/**
>>> + * hugetlb_vmemmap_optimize_enabled - whether HVO is enabled
>>> + *
>>> + * This only reflects the hugetlb_free_vmemmap=3D kernel command =
line parameter
>>> + * and the vm.hugetlb_optimize_vmemmap sysctl, not whether the =
architecture
>>> + * supports HVO (see arch_support_vmemmap_remap()).
>>> + *
>>> + * The value is final once early parameters have been parsed only =
if the
>>> + * architecture selects =
CONFIG_ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCTL_RO;
>>> + * otherwise it may change at any time through the sysctl.
>>> + *
>>> + * Return: true if HVO is enabled.
>>> + */
>>=20
>> I don't think hugetlb_vmemmap_optimize_enabled() has clear semantics.
>>=20
>> Its name suggests that it reports whether HVO is actually enabled and
>> usable, but it only returns the policy bit set by Kconfig, the =
command
>> line, or the sysctl. It may return true even when
>> arch_support_vmemmap_remap() is false. This is particularly confusing
>> because arm64 calls it while determining the capability on which
>> arch_support_vmemmap_remap() itself depends. Therefore, the helper
>> really reports whether HVO was requested, rather than whether it is
>> enabled.
>=20
> I agree, the name is misleading.
>=20
>> Could we keep vmemmap_optimize_enabled private and let arm64 retain
>> the boot-time setting locally instead? For example, arm64 can use a
>> private hvo_enabled_at_boot variable with a
>> core_param(hugetlb_free_vmemmap, ...) registration. The system
>> capability is evaluated after core parameters have been parsed, and
>> arm64 makes the HVO sysctl read-only, so the value remains stable for
>> system capability and late CPU verification.
>>=20
>> What do you think?
>>=20
>> +static bool hvo_enabled_at_boot __ro_after_init =3D
>> +       IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
>> +core_param(hugetlb_free_vmemmap, hvo_enabled_at_boot, bool, 0);
>> +
>> static bool has_bbm_through_af(const struct arm64_cpu_capabilities =
*caps, int scope)
>> {
>>        /* The kernel only enables HW AF updates with =
CONFIG_ARM64_HW_AFDBM. */
>> @@ -2055,7 +2059,8 @@ static bool has_bbm_through_af(const struct =
arm64_cpu_capabilities *caps, int sc
>>         * BBM-through-AF is only needed for HVO. If HVO is not in =
use, don't
>>         * penalize systems with mismatched support.
>>         */
>> -       if (!hugetlb_vmemmap_optimize_enabled()) {
>> +       if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP) ||
>> +           !hvo_enabled_at_boot) {
>>                /* Only valid if HVO cannot be enabled later via the =
sysctl. */
>>                =
BUILD_BUG_ON(!IS_ENABLED(CONFIG_ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCTL_R=
O));
>>                return false;
>>=20
>=20
> This is a good suggestion, but let me explain why I don't think we
> should do this:
>=20
> First of all, I'm changing the bbm_through_af capability from a
> SYSTEM_FEATURE to an EARLY_LOCAL_CPU_FEATURE, which means that
> has_bbm_through_af() will be evaluated before core_param()s are
> parsed. I could change it back to a SYSTEM_FEATURE, but I would rather
> not do that. (See [1]).

Actually you can use early_param.

>=20
> I also don't like duplicate parsing of the same command line argument.
> I'm not sure if there is precedent for this, but I feel like it will
> lead to confusion. (It is news to me that duplicate parsing like this
> is valid, as long as they are not both core_param()? or
> early_param()s, I think?)

I checked the command-line parsing paths, and having more than one
handler observe the same command-line option is supported. In
particular, it is not restricted to handlers of different types.

do_early_param() walks the entire .init.setup table and invokes every
matching early_param() entry; it does not stop after the first match.
There are several existing examples:

- "kfence.sample_interval=3D" is parsed early by the arm64 and powerpc
  MM code and is parsed again by the generic KFENCE module_param_cb().

- "pci=3D" is registered with early_param() in both
  arch/x86/kernel/acpi/boot.c and drivers/pci/pci.c.

- "console=3D" is handled by an early_param() in
  drivers/tty/serial/earlycon.c and by __setup() in
  kernel/printk/printk.c.

I agree that duplicate parsing should be used carefully, but these
handlers would not be competing to own the same state. The generic HVO
code does not need to expose its internal policy state solely for arm64
capability detection. Arm64 only needs a local snapshot of whether HVO
was requested at boot in order to decide whether the BBM-through-AF CPU
capability is needed.

Thanks,
Muchun


>=20
> It would be much easier just to rename
> hugetlb_vmemmap_optimize_enabled() to
> hugetlb_vmemmap_optimize_requested() and properly document what it
> returns. Does that sound good to you?
>=20
> [1] =
https://lore.kernel.org/linux-mm/CADrL8HUgo0zAHe7_eF1+hfTR6jBbZ=3DUKB1qPpM=
WpksvqbNHsyw@mail.gmail.com/



