Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3C73606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cSwkaxbh
Received: by kanga.kvack.org (Postfix)
	id E57156B05B0; Mon, 23 Nov 2026 03:50:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08F46B05B1; Mon, 23 Nov 2026 03:50:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF7526B05B2; Mon, 23 Nov 2026 03:50:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DAD06B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:50:40 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 798E91C4249
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:50:37 +0000 (UTC)
X-FDA: 85465762914.05.BEC8361
Received: from mta0.migadu.com (out-247.mta0.migadu.com [91.218.175.247])
	by imf05.hostedemail.com (Postfix) with ESMTP id E2502100007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:50:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cSwkaxbh;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795423835;
	b=P0jQCdIjB/iC4zNfVVYc+ce0+nQq1VM6mtr5qBNULh95rTsOuFlxtDF5pfcdDF5/2E4AJF
	JPJz/XnahV2N34qz9J9WfyTZ1raywtOkUIjNQomcyqSt0Xk0x3WBM15kRptoqUSOw7r4Rs
	sp2KOin2UG0AgtUEwA2hnTE9TNijJsQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795423835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DhKo/mTgQNmy1TND9VoDhX7AEkKALreB7zrtq8JXWBs=;
	b=iseHqhQauUVfQXhcVCllhdJbr3coGvIBV2v6sx5aGnm9JHPDTrAAblX0lvfElJHTY5aiN0
	1plEWBuVtvtyOpkyigpem9ChT5mePbNW0Y8YIJ3hus9+q6Cbm/2BdYXQ+phLJs2VmeegHm
	tyIDR0M7rcEiUjeuB0TFeLuArJU1e1s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cSwkaxbh;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m1gC05qoAzSqrKBZhxUCZhwdUcmJIoFGJPSk6HfoVlg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795423829; v=1; x=1796028629;
 b=cSwkaxbh5DVvP/naXezyZSus9ZCtsU/OAwx2o6XrtHsEU6TYe3fiTgQvY6qIebdliYXqEyyQ
 rZcbD/RauSm8LF8XysO4NM+NVAJi+5oA64H7WFmowcxQNMD+FcAYNrWKpsJ68yvXhgWVdmkbJyK
 ZoJBP6GmFKToI6m1iXBmvkp8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4f7084d3f2b6a81c;
	Mon, 23 Nov 2026 08:50:26 +0000
X-Mizu-Trace-ID: 4f7084d3f2b6a81c
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 08/19] hugetlb_vmemmap: Expose whether HVO is enabled
 to architecture code
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261122184453.2668189-9-jthoughton@google.com>
Date: Mon, 23 Nov 2026 16:50:09 +0800
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
Message-Id: <9487E341-5F59-4245-BE0E-EFDD413E45D2@linux.dev>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-9-jthoughton@google.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E2502100007
X-Stat-Signature: 7ucri7xgt5g1yeuiayex1xkykxrxbna9
X-Rspam-User:
X-HE-Tag: 1795423833-969507
X-HE-Meta: U2FsdGVkX1+eBLv/mRrV49iRTm2OwqdN+l8O5k2UjWHqhvpEgBPMOpiROLzK1J1NCtwHP0oYmKv7baGAbJCDrKpJshWk9PqyrNbQ7p75tpzB1VY6ctjto1eEx+485Rv8KS2wWwhSaCsXV1ed8iYOfz7UCj1iDiOLccwhVgMQSidBA/6XD7BFR2prEM+7ZNGdW0eS0+oZ5itXtNH4CtXIwliFJTFxPkWd4XReDUA7vstzuqebLWEOFuD4VPlYGBaES/3yIZd8D4DaAEFz4WldeXGXanIbj3ZB0402MxjseFdJdEw/ffBZA64M/vCt7nDSM9/lpPb99YFGxQ5SVH3lcje2NSvK1aWueMpDZzaa1+MITw4u3BYSXxMQnLJvNZeIyAyR1VeT05qXn81a/Y7+HGkEO1D6iD9GlJ2DEJwLmTBogEIvMoKJ7ODD7oN2Qo3Xy7wcx1KwQQFsGakjg77UT2RetYBVYhOVk8EEdjhMGNhtgBIE0DWGoWUy4NRqbB7wvcLbstYi/lEJu0xnEohY7yTKhICiQ9t61EXjWRCLNZITTT0R/qKzRbd4KIPw6PDBfe1wO9NJduqweZx1zCy6wfZHZIPDHwGSK0GbqPwD5mZBvwxi9mOKXPNqJsLiMRFKhWDCi/A4hppvIBfnQPJ0j0phxnU526jjLse4L22oBYSn+XkquHMRdn4qL5f/lMxuZu9xx5T1QUsqfMQMY1JD1zyggW7Bzti4hOrq+pkPudhmudt9G1oDSHjSwc+SL2kUTyXeo8+wGD6OjhLzpLY+MqnKWgXPdyLb5GBvE38IXiI9rtBwNSfo2kejjg24hthrWvkmyzL5V1JAg36/mgZMsbMX2RhqeKfl+GhFxJ6EUUa4BEojMTbDD84HpNPLSkGfzVHPAOmmwWEDK5d1MQN+zdN2te/ePVODI+i7uAKZAb8abj4DVYyjYBzERyJpKqHWmU3OM/ZRWSZyAgD3br7
 +ebJ8WHJ
 gs9dweXR+k0zfgQhcypcnNJ9n/67IsCnduZqkjeBMCXBg3LNq2MFRYZIM5APfAcGY07aojJAjwO3EPWafVTSTWRhnLk5bTa7fgahBafIpYkgz45ZiO9nW830o5Er7vgw/HGM3Rx5ZWONo8yAUi/PqY0iS4iRgeKSq86t2Wqit3e35/qBXQvDng0soG8rW9kwyVQiKx+JTwcAYYOUOsuzQkr8ZOEgTtg8Q/UxJqAgvFNwqWehreI9epa9wzqzyBJjEkfzEzw6PxIZ9bRUsOM4QPGrzTPjxkdFNWtjLKVZ3T7uVTAdnsOS9NzoYw/uT7Pi/2DAD/+PV9WlJEug+ZxuiP8RUVHuSw681ZZl6ISWLVVcATfPL8nkAnlhdYFvVWOvQ+S/tgXh5sQy6BKkw6yQ1+KMc1YbQDQCHrCpQ0zSDo1psPvkCWxtiMoGvdvbUHQcSPbvAbujCF7oAJ8BWW7yLyPIALexNiRl0wfuuxbWh0uKyMyv8JDGLyQ6/D4qwEXw/nKl3i1e1U8ky7ktFKBvI1qh7hm9FXeueZCvfRXyGnkPkNcU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 23, 2026, at 02:44, James Houghton <jthoughton@google.com> =
wrote:
>=20
> Architectures that select
> CONFIG_ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCTL_RO may configure the
> system at boot depending on whether HVO is enabled, e.g. arm64 may
> require all CPUs to support hardware access flag updates only if HVO =
is
> enabled.
>=20
> Add hugetlb_vmemmap_optimize_enabled() so that they can check. It is
> declared before <asm/hugetlb.h> is included, so that it can also be =
used
> from inline helpers there.
>=20
> It only reflects the hugetlb_free_vmemmap=3D kernel command line =
parameter
> (and the sysctl, when writable), not whether the architecture supports
> HVO.
>=20
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
> include/linux/hugetlb.h |  9 +++++++++
> mm/hugetlb_vmemmap.c    | 18 ++++++++++++++++++
> 2 files changed, 27 insertions(+)
>=20
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 0d5414392d87..b2a6441bcd84 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -22,6 +22,15 @@ struct node;
>=20
> void free_huge_folio(struct folio *folio);
>=20
> +#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> +bool hugetlb_vmemmap_optimize_enabled(void);
> +#else
> +static inline bool hugetlb_vmemmap_optimize_enabled(void)
> +{
> +	return false;
> +}
> +#endif
> +
> #ifdef CONFIG_HUGETLB_PAGE
>=20
> #include <linux/pagemap.h>
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 142f2975846b..fb6da64bd80d 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -452,6 +452,24 @@ static int __init =
hugetlb_vmemmap_optimize_param(char *buf)
> }
> early_param("hugetlb_free_vmemmap", hugetlb_vmemmap_optimize_param);
>=20
> +/**
> + * hugetlb_vmemmap_optimize_enabled - whether HVO is enabled
> + *
> + * This only reflects the hugetlb_free_vmemmap=3D kernel command line =
parameter
> + * and the vm.hugetlb_optimize_vmemmap sysctl, not whether the =
architecture
> + * supports HVO (see arch_support_vmemmap_remap()).
> + *
> + * The value is final once early parameters have been parsed only if =
the
> + * architecture selects =
CONFIG_ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCTL_RO;
> + * otherwise it may change at any time through the sysctl.
> + *
> + * Return: true if HVO is enabled.
> + */

I don't think hugetlb_vmemmap_optimize_enabled() has clear semantics.

Its name suggests that it reports whether HVO is actually enabled and
usable, but it only returns the policy bit set by Kconfig, the command
line, or the sysctl. It may return true even when
arch_support_vmemmap_remap() is false. This is particularly confusing
because arm64 calls it while determining the capability on which
arch_support_vmemmap_remap() itself depends. Therefore, the helper
really reports whether HVO was requested, rather than whether it is
enabled.

Could we keep vmemmap_optimize_enabled private and let arm64 retain
the boot-time setting locally instead? For example, arm64 can use a
private hvo_enabled_at_boot variable with a
core_param(hugetlb_free_vmemmap, ...) registration. The system
capability is evaluated after core parameters have been parsed, and
arm64 makes the HVO sysctl read-only, so the value remains stable for
system capability and late CPU verification.

What do you think?

+static bool hvo_enabled_at_boot __ro_after_init =3D
+       IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
+core_param(hugetlb_free_vmemmap, hvo_enabled_at_boot, bool, 0);
+
 static bool has_bbm_through_af(const struct arm64_cpu_capabilities =
*caps, int scope)
 {
        /* The kernel only enables HW AF updates with =
CONFIG_ARM64_HW_AFDBM. */
@@ -2055,7 +2059,8 @@ static bool has_bbm_through_af(const struct =
arm64_cpu_capabilities *caps, int sc
         * BBM-through-AF is only needed for HVO. If HVO is not in use, =
don't
         * penalize systems with mismatched support.
         */
-       if (!hugetlb_vmemmap_optimize_enabled()) {
+       if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP) ||
+           !hvo_enabled_at_boot) {
                /* Only valid if HVO cannot be enabled later via the =
sysctl. */
                =
BUILD_BUG_ON(!IS_ENABLED(CONFIG_ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCTL_R=
O));
                return false;

Thanks,
Muchun

> +bool hugetlb_vmemmap_optimize_enabled(void)
> +{
> +	return READ_ONCE(vmemmap_optimize_enabled);
> +}
> +
> static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
> 					   struct folio *folio, unsigned =
long flags)
> {
> --=20
> 2.56.1.809.ga0b61035b5-goog
>=20


