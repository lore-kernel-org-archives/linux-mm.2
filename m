Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E483C606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=P5lrUR35
Received: by kanga.kvack.org (Postfix)
	id BE6A16B05B0; Mon, 23 Nov 2026 14:23:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBEBF6B05B1; Mon, 23 Nov 2026 14:23:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAC8F6B05B2; Mon, 23 Nov 2026 14:23:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 760026B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:23:12 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A359C120967
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:23:11 +0000 (UTC)
X-FDA: 85467356982.11.88A9C0D
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8DD4940008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:23:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=P5lrUR35;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795461789;
	b=x1A2Xd0sYT2OkfQRpFRm9khAi9zBAIE0YvFb/yoC2J1+iSUezsJpHxwglCYTh6cx4qQjI5
	/9aVbrbHwpHED4VUsg/62k1PyLxxzfNOuDLF6aC1YA8bfG5ON12/UuakxMYrXVjaZ4f+Ui
	Bbs4q/xVcSSWHxqC4BsmR8xvX/aFqfk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795461789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Jpgt2iZSg+qW1jdf4hbWvk6weM53GPvK5N4UzQlask=;
	b=diu5l0Nt33dlbWhrHQf5MBHqvFTgkEe7Jwv67Jw8beujmhJvvTtmEh43o5T95+TgHhOa3K
	wk5x2QD/S/kBlFdZeEad+q7qvBruXfbhqQvh8JeQp3ZyFKIHU2zCzJuSkTw/s57HlbCo2q
	Y+PXrLiUBG1yxZoupyEa7Y25SfYyDRA=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=P5lrUR35;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c50cc7540b7so504388566b.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:23:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795461788; cv=none;
        d=google.com; s=arc-20260327;
        b=pEQC/rcWOzHERdaNyluiUx5yAGNtnRFr/fOqZY25GrVJG8u8ULSC/yuL4Y0heFQncH
         DLRn4yvQpyd8h/mM9xKFNPhcZbaZ3UdZvlkML5Bv5/UhZQYSRE0qfm/TpUoJte+TpOPf
         yz5JOQ9lCofGPSQQf5p89ZbpTAJe76xYkkSxLaGCVMTUaco9W/kQR5QcJbk6pPsAH/2E
         cFJrlraO0oJobwf6t/x44IBLpytOVusNvT4/6ph85UpSfzai0Sac2ldOxg6UIQRLr1IB
         wEZKc8cb2+X2iR12xHFhB061sLuFQLP3QEzNGXve1EAJPgS/MzQbuetkYR8P7QUkytt6
         VVRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7Jpgt2iZSg+qW1jdf4hbWvk6weM53GPvK5N4UzQlask=;
        fh=Z/gPiuCXpL0UDLyrOzT35K+DiiHMFm79mJiAoFBSGzA=;
        b=s78CvvAh2nObEjJ9l7poanEEesMW30qLb6ghDHcOaZkxxvQNzI6om7E7/2+z87IhuO
         a1KMaH7vgApKJbnkDPlJqTIUskWcceeXYVbRQGQ9nU9uJD4/QMaFr3BILmC+UhU9YbR/
         /FK7ILldCsyEBGzunu6D73qYwV7Rvr9txnUi8//FSI03DZqvj+s+RIR9eh/NRRyen08r
         /g/oKvAnmN8dCnH9JTZrS44cel4S5C5kTTQ4QZqkIYqH1mB4/TkO9Sa8RTopvomSEmzI
         RS1EPQbR43UAWoKRk7Kfmb0WPsme9CN6BORyOyZ47vmSOFp4QN9Iq+Y8s2rRxAJR+q7T
         DhSg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795461788; x=1796066588; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7Jpgt2iZSg+qW1jdf4hbWvk6weM53GPvK5N4UzQlask=;
        b=P5lrUR35aD41A7fTKU+T/sSzmOAeCF1I4wkPiZixZytwB2HNJL67Kk4Kg1+y/AteNl
         erU+VfjT35s0xFJI7R0Y48cT4xorV06jODTVxm3+gjhPKogCkjLDWQnBEk+lWcLxn1cp
         QB/3/lcbHsZoqjwnukMu5Qv400wCk2lCC3Xt6p1M8tmW1oPZSmgJ3aWQx4YjwL999u9S
         dQZ0HQdhKrTUQwwQqgLRA8OJmhoAYyfkH4ClFZbhq64yhXjXgtd29QvK/o9Qw6DWRcRi
         B0sWAyzBqL1MY+tDyEJMmZZLkZfPNM0ruIxP65XQYGmofJ9l1AHK7BZC+Z+PEKbZtrSe
         tBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795461788; x=1796066588;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7Jpgt2iZSg+qW1jdf4hbWvk6weM53GPvK5N4UzQlask=;
        b=K6Pq3r5wGLp08gKdwiOhoW0CRh993yutzUy3PUJkhJoPhwY6scTmu9/1KFRJvCGvMo
         wAb0ap2XqO4AZgAYfF/LrwJjJSPUkHN9m/TgBWUSx+1ElYmFuyTG+gVEeVmwtaT0P6aT
         Z32d5milfXCAsaBBzPWjH4ST/KVFg2EaXReD3cJFQ+WYmOzolj8UQoTnkuFt04HlHakw
         D6FQ6JGY3N1NHCXt0cTdfh/hXcsW66/86OtI3JT3YauniHL1GlQ8H0oNPGxZjpudxHwJ
         13oaQBpmTUHOhPJW1h/rFn7/hDR3V0wit97JUx/KD3oxBe6fywy+zAeEu87P8XfKtsck
         WpKA==
X-Forwarded-Encrypted: i=1; AL+hErH8ZPIiHg69PxqWw2bFpu8ATtj5xs6m+Er6HT23XnSgPRvf/MZvXR7XWYS60sqKwXeobqf2TbmpqA==@kvack.org
X-Gm-Message-State: APuU4Z85F+ANZyE3O4eg4sME966116tOX1cYzpWsSzimA+z4P+UBfWVx
	W/G7+10op+/B5IZ5dcfgU3itaovWssje45GuaWXCdD3LDEcB4tcxk7S1Oj1rnREMWqAKKMepabz
	EZ5zwLb2LfZXXOM7UuRAzSQPKz3M2N672OjLHBPSR
X-Gm-Gg: AZFdTZfT/lW+4zCg0Aj9NmxjEUu8cfx+WPjVOOxKIXvRTuhbZV7cKZT+eTPHE8NpG04
	ach0sB7Z4U/W8QPADfVTLQPzF/YwOVbDn36neuzELLWpFY4DnhgNWMsHiw1zH3pgb5DdnFiVjsY
	LtCc53+quhBMK6cxf7OGRgr22nnjUocqyc6NpDrkHAvevfjoUih1Ho/w2/6M0NX7ZFoGenDKNF5
	mdxt3Z860PnzkTYQ1NmVF6CAoThqY0FoQSPvi+khHDjKBuEiCG8y/Vq4SJkCmliHdNUYgzGUfUc
	2hjXHm5KYKyV9phrBe3nBB/XpVYXMlr1MbUyrXx3baVJc5Ca+0em0a0P2GyWMSgtr3AVARFIf/z
	qtT2uXDcauPJtjXBfC+B96LPwbpfWU3f7YrJt7ykMh2K8a6yHZsliFrOfhgRQ/UWCyZ2qiMlajv
	k8FA653BAtKwatccDrnRNeWxodUdtRxhY4v74rgPyasSQvIQVeivQ=
X-Received: by 2002:a17:906:9555:b0:c50:52b5:e17 with SMTP id
 a640c23a62f3a-c513a5e1d53mr861981366b.13.1795461787407; Mon, 23 Nov 2026
 11:23:07 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-10-jthoughton@google.com> <sashiko-outbox-228638@kernel.org>
In-Reply-To: <sashiko-outbox-228638@kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Mon, 23 Nov 2026 14:22:29 -0500
X-Gm-Features: Aa3M54osq-kJxtT4Y9atQQYQnCb_YAmdhHC0kxgMwEHE4_dxYTiiSl6LpxhomO4
Message-ID: <CADrL8HUgo0zAHe7_eF1+hfTR6jBbZ=UKB1qPpMWpksvqbNHsyw@mail.gmail.com>
Subject: Re: [PATCH v3 09/19] arm64: Add bbm_through_af capability
To: sashiko-reviews@lists.linux.dev
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Kefeng Wang <wangkefeng.wang@huawei.com>, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 8DD4940008
X-Stat-Signature: 1m14rbhtjgcnfkwk3ihnq5tssrk78sm6
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795461789-601101
X-HE-Meta: U2FsdGVkX19ZMjrbFHLIOfkQS5VWIfuhlITUv0rv5HcS6ArSIq6SxJ7a8pNSPnrfrHKffkzlxiPXybhfo/S/oRz095EE4QbKx7tdrU1nM+i3goE7aGlFsziZRR3rLrqf78UltmTTsf56uJiMGAklFFr3d/sJy0bO9WcayJO2HbYENFi6KVm6sgFOn/c8Wm7OXFcsGpUg1LQalrPX5ezuPg7q1YjpUuWFlXltCfpL5sbhw6j6d0wrO0GgkelIZmDwkdhlMyi7F/cxzjZ/XwO/ZAFXoOP14TL+yvtzf7nKkq7i2HZ5Bt1uka7GDRnGvddDZB7He+cNiLzs4IS0ofYX5Tdd/ADr3Vt/IfHAhgALBYQwydG62P/rVWydzHMTBs4tmEC48Dz2bs32nN17NJX4dHmodW6XfNVS4ewn6VsTxVcmidjKziMHa6sfvSBB2WhFPj0tJJIKf2GUW77CpAUFNtMhtgqFguxAk9NMd6/OPlyMgPcsZorfghmwGAMWNieR5zzOG74l1lJQrpgdFaV7YlbcHa56cgw2PAnGM4jwWpW/ce8X6MJdRevXRoj8FMWUNcMst5jtwbFAXvtfQHe2P6Z7ESevjXthCTvb5hfuiF+GJR7xv5wUsNIf+I0JivO2EGNbY1y/aOcKcRaEIkVyCrz4MH2UhkfhbqBnj81uzd/cvFcAjjhi/zQvELryMAr6Mt0n5NSbhzh5PJ+oPPPmRY+bCTO6POfOtSd0aOBj+rLkZ0kVqwxIE/XXuXMaOkiMA1GZJKSNK06a6x1QIrxaJ1iqGOhHF2h8Tkj2ObhO+6q1M/xd9urnzOEIhTafoZuPNYxbiP7SL10WQ89LktIfypx4tATzGo9SyZnSZUoFkucwuFuYYQR0OLMDxoFMZGkiOe6sIDm3oc1uf4BXMamrDxjOy82S5kRoZVSCYodYYBsjJXr/Cbv9vRFTwSjC6W2RNEq24hwknDZXiKaD8jH
 ScyaA8b0
 NmGuwCQ0RodYx5e3j+pPmH4CcUbgWYEa2a28vrbyvUTVz5eF7/AOiNiTbqQe89M4zPkaRg4AtXqg5Md358OVA6kFFIOo7Glp9NTE4fNbWXafjwENgNWNG0GRfMmwKxy8922rAHhoOror6sq3p4aCwr9gXIISwV9VafEV0ZdlWqEZ4yOZPhElWQLHWSpaPsuwRfvbvuzoHK0y66rntChbzE53uf9RUL00E8m43/NQPMSVVQrC+zCQINazB9pgSFV9d9o3I5BGiOvUapYHUsqC6i4WOz3swpbcVzzk7o4m/rdD8Ld46foxcFrzldyO2qcYNskC8NOS2pggMmgp2dIe1Fh3xL8X4DnCZ4dhe36c9HoNUQayV3nasIIg9IDIfAluOztDhZ0NlFFSjeivbu2+6P4gW2cS855pKTyB3IMUu1RH0kS81jE0ZBqx0d8qbdlvg+c1viumKGGc+xkvCJuYYG5bfq++1Lw8yH8C3KOKEgjlN9rqWOdmudUmpd9R5gU6yDUPsnLcj8zJaWYU4MTXXhjqXO1cK2QNpVp5yPgTuOLm1KtVBM8LU4pmz99VrU+Pi/dmesoOkaleK1MBXeShU7eRH5IJqfKjyijEk0ibs2xMiJR9siEaFVrWRcFNjMojfQRT06gPrjogcqjus2ObU4RJNqnMmas5x7Z3Km9bv1ylVzvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 11:08=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] arm64: cpufeature: has_bbm_through_af() checks BBML3 only on
>   local CPU
> --
>
> commit 65766d54bb753e1e16346fb12f4bb107c66114eb
> Author: James Houghton <jthoughton@google.com>
>
> arm64: Add bbm_through_af capability
>
> This commit adds the ARM64_HAS_BBM_THROUGH_AF system capability to detect
> when all CPUs support BBM Level 3 and hardware Access Flag updates for
> HugeTLB vmemmap optimization (HVO).
>
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeat=
ure.c
> > index c9c9a6889455c..d241638b51435 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> [ ... ]
> > @@ -2044,6 +2045,31 @@ static bool has_bbml3(const struct arm64_cpu_cap=
abilities *caps, int scope)
> >       return cpu_supports_bbml3();
> >  }
> >
> > +static bool has_bbm_through_af(const struct arm64_cpu_capabilities *ca=
ps, int scope)
> > +{
> > +     /* The kernel only enables HW AF updates with CONFIG_ARM64_HW_AFD=
BM. */
> > +     if (!IS_ENABLED(CONFIG_ARM64_HW_AFDBM))
> > +             return false;
> > +
> > +     /*
> > +      * BBM-through-AF is only needed for HVO. If HVO is not in use, d=
on't
> > +      * penalize systems with mismatched support.
> > +      */
> > +     if (!hugetlb_vmemmap_optimize_enabled()) {
> > +             /* Only valid if HVO cannot be enabled later via the sysc=
tl. */
> > +             BUILD_BUG_ON(!IS_ENABLED(CONFIG_ARCH_HUGETLB_VMEMMAP_OPTI=
MIZATION_SYSCTL_RO));
> > +             return false;
> > +     }
> > +
> > +     /*
> > +      * We need BBML3 to support Block -> Table transitions without ta=
king
> > +      * faults, and we need HW AF support to support changing the OA w=
ithout
> > +      * taking faults. has_cpuid_feature() checks HAFDBS >=3D AF, read=
ing the
> > +      * local CPU's register when verifying a late CPU.
> > +      */
> > +     return cpu_supports_bbml3() && has_cpuid_feature(caps, scope);
> > +}
>
> [Severity: High]
> As reported by Catalin Marinas on v1 [1], can has_bbm_through_af() falsel=
y
> enable ARM64_HAS_BBM_THROUGH_AF on systems with mismatched BBML3 support?
>
> ARM64_HAS_BBM_THROUGH_AF uses ARM64_CPUCAP_SYSTEM_FEATURE, so
> setup_system_capabilities() evaluates has_bbm_through_af() only once unde=
r
> SCOPE_SYSTEM on whichever CPU happens to run smp_cpus_done().  Unlike
> has_cpuid_feature(caps, scope), cpu_supports_bbml3() ignores scope and
> reads the current CPU's local ID_AA64MMFR2_EL1 and MIDR_EL1 registers.
>
> On a heterogeneous system where all early CPUs support hardware AF update=
s
> but only some CPUs support BBML3, running setup_system_capabilities() on =
a
> BBML3-capable CPU enables ARM64_HAS_BBM_THROUGH_AF system-wide.  HVO will
> then perform live block-to-table vmemmap PMD transitions while non-BBML3
> CPUs are online, and re-onlining a non-BBML3 CPU via hotplug will fail
> verify_local_cpu_caps() and call cpu_die_early().
>
> The later DO-NOT-MERGE commit "arm64: Drop BBML3 requirement for HVO" in
> this series drops the cpu_supports_bbml3() call, but if the BBML3 check i=
s
> kept, should ARM64_HAS_BBM_THROUGH_AF use
> ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE (or check cpus_have_cap(ARM64_HAS_BB=
ML3)
> when scope =3D=3D SCOPE_SYSTEM)?
>
> [1] https://lore.kernel.org/r/aoRnMRZ0jE0ycwcT@arm.com

Argh, yes Sashiko and Catalin are right: how I am detecting support
for BBML3 here is wrong. IIUC, cpus_have_cap() (Catalin's suggestion)
is right, but I think I prefer Sashiko's suggestion to use
ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE instead.

Leaving the new cap as a SYSTEM_FEATURE and using
cpus_have_cap(ARM64_HAS_BBML3), late CPUs without BBML3 are rejected
because the BBML3 cap will reject them (if BBML3 is enabled on the
system). I think it's better for bbm_through_af not to rely on that
and instead *itself* reject late CPUs that do not support BBML3. A
minor thing.

Sorry for missing this feedback, Catalin. I'll respin a v4 soon-ish
(next week?).

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122184453.26=
68189-1-jthoughton@google.com?part=3D9

