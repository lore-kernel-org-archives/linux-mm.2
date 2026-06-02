Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB26AC5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 04:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E4BF6B0098; Tue,  2 Jun 2026 00:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1956A6B009B; Tue,  2 Jun 2026 00:38:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 083D06B009E; Tue,  2 Jun 2026 00:38:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB1406B0098
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:38:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F5C91404CB
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:38:39 +0000 (UTC)
X-FDA: 84833716758.23.579B58C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B2161120008
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:38:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=al70hW1A;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780375117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBVL1+NAd5z/lAMiPLrZzxdoiEevN7OOXCvGxVD/k4g=;
	b=r7+yJiF9MkXiPWOyx2w9bPYbWuvJ4VeD9uSru2sTJCdUmqhcbcsnMe5ws/P1+fHIT5orX3
	VSxr5fY1JHnPjBAGf8admin7Qa9bwbqEW98zHx1R193i2C1LskHrAW6I0ZJ+f0ylUc21lP
	vPXL8OamL3DwTenqQ/m5NLf1C2k+k4I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780375117;
	b=rj/sreys5XVK7IVmcYkDzXiDBnjFNLmZP3DAUUim8YDfUY9DJb9b03Kg7RLmChmx3G4abR
	ZkGCKVuJ46F3AdqL22hGCisYt+dslUWlh6aRzLx5oFQOd6hyOUGLjS17UTw9zqeQ1s2bdM
	txQTMXOR5WGcmoY2QXDJdqCBW7BV7OU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=al70hW1A;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D0F1443321
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65F61F0089B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780375116;
	bh=pBVL1+NAd5z/lAMiPLrZzxdoiEevN7OOXCvGxVD/k4g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=al70hW1Aj82jPBiVMhAfnKW/eP3wDqKefSXqjwlN6BidKC0VgJhS9pjjfrt7tsaZm
	 ku9Itxz3glbmvbEYmhqMUYpWQ6K7FDS3HONDDJfMCkfPLHKb2K0c3SQZSqonn/wFbG
	 5mK/WVBNx935HMPvvJsbc6Q0whs+6WAuEheyj5RNZvxgaHg00/jSa/W6VAMaBn6fuy
	 mWI8KNNLbKcs84gVpF/ymQPh9aHBfNAGNxUu2AzZQ3jAvrnPcDEqtwL/ks1lVvrhxr
	 aEcn8WgswzHz4NFAN8hwMCo9zexrF0vPhdfbwRj69wnitzZtZ+tvNInMdyw9CCmJRN
	 59Wd7v3TD3wfQ==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-914ae4101b4so1390492785a.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 21:38:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8WX+J9sYKJHr/AoLawZCWlqlAJPk6/HvIiqmvCbPl/4yI4Edd8lzgAvHiKwPx7Uzk5K+z7lBnixw==@kvack.org
X-Gm-Message-State: AOJu0Yya6M8qcbSMZG0cenE/I5CgHZz9vqaHq+tkbirPl5g3iGyuvrsD
	rlsB0+Yrldp7+3fVRzp8pgu7yPaNlYA3GnEjcMQXce51uXfFYYUT+Lis0HpEcq/3mUMGRjiFUpf
	HXjkGvTztmaFSDRa3CvITsKSLJxV53uo=
X-Received: by 2002:a05:620a:278c:b0:915:776d:5307 with SMTP id
 af79cd13be357-915776d5d33mr400617285a.62.1780375116189; Mon, 01 Jun 2026
 21:38:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260601083044.57132-1-ljs@kernel.org>
In-Reply-To: <20260601083044.57132-1-ljs@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 2 Jun 2026 12:38:24 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wMZNxuHf2SE6MGBZRA_64b-1V3yndfn-LtCS_YUOMO3w@mail.gmail.com>
X-Gm-Features: AVHnY4JJRXqYX5791gA4t7nrlGZeRm0sB3520yKVDDmA0dWYd3LMLjmHYKtK5mE
Message-ID: <CAGsJ_4wMZNxuHf2SE6MGBZRA_64b-1V3yndfn-LtCS_YUOMO3w@mail.gmail.com>
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: use correct flags for device
 private PMD entry
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, SeongJae Park <sj@kernel.org>, Balbir Singh <balbirs@nvidia.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B2161120008
X-Stat-Signature: bwdbwk5xhxmtkqmbhqza7omdtniufhmy
X-HE-Tag: 1780375117-410844
X-HE-Meta: U2FsdGVkX18m2+teXyf1QIPXm+vh6z7xfV89bLZqdVap6aTTpnDNXIL0IqfXdQVGwC9nzzTMRjxQEjLiswp3KkKrkR8aWpTk4femMx2TXzSF44BAfMzmYRk8A3TrDHNlMPIEKykpfwALi7g1JXjTJHqPfFqtl/QAtBs8P/FJ3NK9qcPD8ffxz+TUvOgdXEhPSYxhHkRi0ufq0vleykqRiJx9S73iexdGopZmOPfROYcBvniifQSD63aIBpEPFqmEPQg694/lKmxibqLOQbPuutY96KokfiuMSQiojQ2hqRk4wz6Jnz5y8iwDkR18ceJ49ffH/P7e4Kx8itHvLMCIboBMHbK41klB2It06oAAXG8rYSP3rroURjJ31sNBvR1SzYqH7G8r/95jtiAetGZ+LX55RIHQNS3z8gxQMoIL1e2aAqkGpRKK2joIMnGOc73ckENZZbc88/+dvryM+a1T5vhKFluQEws7fsxkpHg9G5w3v7dRrpspiQoSNvcncvVD2Cs8DTfkvEFoi6RZCdppUwF+iRtFF27ZjjVCDrByK1rer+k7uA4U+39Vpkr6ZNyzMcJ5JBhZpQY1GlFMrCtCucHNqJqp3Uu2sN5hM7rNt9DeD2OJ9/dnp+6iFDsLekzp6J33clwvaM+S/FhnlHaBpAqLrGeWzLFpr7DDNPEoRBTjuvXZJrtiCtOqvg7ZixB2B5SRSa6Ym7FZTD8Xufld/EkPbM8ENj0SI6AxpJmFqhrREttQB9fbuLo4YA5QNc7QRUPSBUR9S/hfW2e+7IgSSNYZtt1GEqXX1vGs/N0W/eo2N3ybb9koz2KR/bjrUKDWriyc/e5BvcgrbNq9bI086233NDL9ePLGQ7JK3+CisBGbeVcpxKspFNVAIog4VrQtibhG2rLLH6Q38F3YFf3eZWQUCqBC+LhsTGgwsjt7Z+1SKr44hRjVzBB5VpOo/DGy6tR7rXaqlMNDo8dvJpu
 QBha6ue1
 yigAaU/wr7bHfjDd1XswgrBsJOVTR5POecCrH+QoorNRGLyvZWmUYDQ9Il+XkjKj8MxTk52pnu3i4Ez8YZBiZ/cyKaFT8RRbHGabmEUxdvGSGgzcvubagbUUQJZop/QE2ePHn0KHf2m8zSvQx9ZCpNRX5PqyvEFYPXK/F/Woa4ZzNXagnysQELv1HwQvFF4DnKdB2AB8fri0WPPjczO/4xNgrYmLceuN7meeQfz5MJgnvhJDLtqU2bLqJhkAxQGRQhPhHXx4+qVDw2YolLLhrTjMPWE80jU87M146HZWN50zEUS0feE14vEaHZXf7QQ1XfQ4Zkp38tgvX9Y0ILVSyfxyDvGzTx81UCDoO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 4:30=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> wro=
te:
>
> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> device-private entries") updated set_pmd_migration_entry() to use
> pmdp_huge_get_and_clear() in the softleaf case, but made no further
> adjustments to the function itself.
>
> Therefore this function continues to incorrectly use pmd_write(),
> pmd_soft_dirty() and pmd_uffd_wp() to determine whether the installed
> migration entry should be marked writable, softdirty or uffd-wp
> respectively.
>
> Whilst all are incorrect, the most problematic of these is pmd_write(), a=
s
> this can lead to corrupted rmap state.
>
> On x86-64 _PAGE_SWP_SOFT_DIRTY is aliased to _PAGE_RW. So calling
> pmd_write() on a softleaf will return the softdirty state encoded in the
> entry, assuming CONFIG_MEM_SOFT_DIRTY was enabled.
>
> This was observed when running the hmm.hmm_device_private.anon_write_chil=
d
> selftest:
>
> 1. The test faults in a range then migrates it such that a device-private
>    THP range is established.
>
> 2. The parent then migrates it to a device-private writable PMD entry who=
se
>    folio is entirely AnonExclusive with entire_mapcount=3D1, softdirty se=
t
>    (accidentally correct write state).
>
> 3. The parent forks and the PMD entries are set to device-private read on=
ly
>    entries, entire_mapcount=3D2, softdirty still set.
>
> 4. [BUG] The child writes to the range then migrates to RAM - intending t=
o
>    install non-writable migration entries - but replacing parent and chil=
d
>    PMD mappings with WRITABLE entries due to misinterpreting the softdirt=
y
>    bit.
>
> 5. In remove_migration_pmd(), if !softleaf_is_migration_read(entry) we
>    set the RMAP_EXCLUSIVE flag when calling folio_add_anon_rmap_pmd() for
>    both parent and child, which are therefore AnonExclusive.
>
> 6. [SPLAT] Child sets migrated folio entire_mapcount=3D1, parent sets
>    entire_mapcount=3D2 and we end up with an AnonExclusive folio with
>    entire_mapcount=3D2! Assert fires in __folio_add_anon_rmap():
>
>                 VM_WARN_ON_FOLIO(folio_test_large(folio) &&
>                                  folio_entire_mapcount(folio) > 1 &&
>                                  PageAnonExclusive(cur_page), folio)
>
> This patch fixes the issue by correctly referencing the softleaf entry
> fields for writable, softdirty and uffd-wp in set_pmd_migration_entry().
>
> It also only updates A/D flags if the entry is present as these are
> otherwise not meaningful for a softleaf entry.
>
> This patch also flips the if (!present) { ... } else { ... } logic in
> set_pmd_migration_entry() so it is easier to understand, and adds some
> comments to make things clearer.
>
> I was able to bisect this to commit 775465fd26a3 ("lib/test_hmm: add zone
> device private THP test infrastructure") which first exposes this bug as =
it
> was the commit that permitted test_hmm to generate the test.
>
> However commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> device-private entries") is the commit that actually enabled this
> behaviour.

Thanks for the excellent changelog and the detailed steps.

Reviewed-by: Barry Song <baohua@kernel.org>

>
> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-p=
rivate entries")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

