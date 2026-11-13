Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECEB9606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d6Mtjvb0
Received: by kanga.kvack.org (Postfix)
	id 027406B05B8; Fri, 13 Nov 2026 09:26:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F40F66B05B9; Fri, 13 Nov 2026 09:26:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F606B05BA; Fri, 13 Nov 2026 09:26:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C54736B05B8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:26:01 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 614CC801F3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:26:01 +0000 (UTC)
X-FDA: 85430320122.09.7BDB114
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B01AB40002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:25:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6Mtjvb0;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794579959;
	b=bjqrMPbiFxuddKYJKMMejQVIEHz5N4DCdLgc5zK8j+NAvHRJKL4XmBy9cfCxcN072qwvw8
	jGGY7Un5w6Ee4MPAmySC3Yq7MnUFveY+5dQWtf+raim84QnLBTQNqIqAaVlV2AqOOWBDJk
	vHoGBqLFVWTK1Z+pbfgGkHlr3fy+BjM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6Mtjvb0;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794579959;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uGazlu8ZE2iEilyNSWyDR4PXa0zhg5n8Ju1m9LVZYdk=;
	b=Ir47O3oJEJLsNA3lsX+j3Qpm5/ZsakVVRBdN8FFDZG954Dnox6pDVB0Khz8aTwIoKlGJVd
	sf6qVOP+KF0QuMgM7EuBRjyLgvkcA1TaAvHWdEQ1mGL5/Ekt/KpRRkiKb/ujl32/M+Vyok
	Vtw+hb0E0jJoBj/aWiYWIHRGlvRKZGQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D166A43920;
	Fri, 13 Nov 2026 14:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805011F000C4;
	Fri, 13 Nov 2026 14:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794579958;
	bh=uGazlu8ZE2iEilyNSWyDR4PXa0zhg5n8Ju1m9LVZYdk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d6Mtjvb0izQ7tMW+TKdqltTALnjGs/s/qsTtCiTcxiW9ImCMu/US8fU27eyNhqJdT
	 efkP8fjCq75tG1xSi7ByXwXxEiGFAnLcBXatGj+H3LjNQ3hZnlp2XqggdjB8vVk4qi
	 MkIvQgQzBvWWsRc6HCqKMErR6nuc3k9ZUhsmto5prZfybTk/F1pIxh6TMOiioaqtAO
	 eYdgERV82+3FlsTSGOfGby2HBZiBzhxTFbMFiTPwoZf+g9CB0YwnSCcF26OZXpuVk3
	 GkFC+7jk4S/KyGcLSNsk+VnujlOs73HWdbTUFTWayH1ODqJ3Wyf6bJts+ivnA3Y4Uc
	 ZGFNU8JJE/ctg==
Message-ID: <sashiko-outbox-212981@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 6/9] mm/mmu_notifier: add
 MMU_NOTIFIER_RANGE_PERM_UPGRADE
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Q2FybG9zIEzDs3Bleg==?= <clopez@suse.de>, kvm@vger.kernel.org, linux-mm@kvack.org
Cc: linux-s390@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com, akpm@linux-foundation.org, david@kernel.org, peterx@redhat.com, ljs@kernel.org, imbrenda@linux.ibm.com, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, frankja@linux.ibm.com, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Jann Horn" <jannh@google.com>, "Pedro
 Falcato" <pfalcato@suse.de>, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20261112142039.907090-8-clopez@suse.de>
References: <20261112142039.907090-2-clopez@suse.de>
 <20261112142039.907090-8-clopez@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 14:25:57 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B01AB40002
X-Stat-Signature: h4wiukxi8fpabmbasy9z7ky4k4p6zqco
X-Rspam-User: 
X-HE-Tag: 1794579959-175920
X-HE-Meta: U2FsdGVkX1+TpKPg9SuxQNy6Rms+ayqIIaGMwMDBw9ZAZyKyu8cedmutzw3R/KXIFs6DzvZFhIOsolGRAjTaL0cT3p8oYY4Do4qnlsDRGMCtHpv1EfK3OTn9s4GKXzapEkLXa99N8hwl2tCsRslBPECgr23/HLHZhPM/S7JfhR8mUp8axu8uxJMjEMpDNo+YvNqNthGUA4QqayMZLKh9GkWNspRPo6moLBz0yRzyUaUlDt+XQBcFql0HyFqYso5Abc7M1GybbQjD6Rpyc2I2xAM3Iz8JrRyJ3ytQGjIftnqC3I9hRL10T7WPpTvIZQN9FEpqN7DJ3K08d2da2/zvaepNYYG6RmYAJl9Z+HttD43cH98DjWyupwKUn/VeMLF+FYBJV7yprXEPlqsPVY4CgKtCehs4uATQNpEKaREeEPsuHthsksk+6bRzbqObD3ELBKBrN2+bbrf0GlHu2R4TkLF+MDAYmRy6hVsNcia7IGekfIqXN7ie0I8qJ8t15En109mkWuDtpRTnYGMErsveFgRJc+8HGu1nWVpHpg8CnvHPJdcMoWji9MjejxHnl4p/T/89k6ISNLvhjErn3SKuUx5mFh7kkAkMZozTBHz8oYP/kRx+xGC/6TpLgBCGYj6i90h3Xd3TbfhGF9MF/JlPdrEG4JZN2cb1pmXG/lqzfOKwfp5X/9OMoCnGMu9GshvAvefV2awrI3LFezg7Yva0kRdBNuMjqHQo86lv7NLloIDJr+G7aKWfu1Q005sM2VM9kBQXB56BoNAce/zMR5OBv+VnXAUNUD2TufhfBj6JR4aeX2JS72RnYzT0zcUO2PS9zTMSkJ1H3p+9JTa/8PmcVaM8fbymQ9l847MlgIw0rtm9hJDi71+EyjFNEJ+2mhBr/ouv6HCOzlrgbjTcH7OX/AhznMzeVAnMw0nVzO9mUrh+xmFvGyBjKtmIi0RO/Am3Fd1DHoJn4QL9seSu3+c
 yO7aYhP2
 HVCFCZ8RyC1hCm0Pre9DZZuzSU+KvR+a/4bovB2PjLMkmkK14zJNNhFn43oPUdoreL/YZZZKYJd9RxRt9y979Pubr5gyROrf3MV+fgQUwkrCcN7opWrLKkuSrMEi+RdTLlBO5TQCgTwpj88AvWLkfLBMzc5mz4oJHQTLnrz6/BX4akXSRZLvCF5mPcVuHf58D6UMaYJvHoo0cKOuP2RJ0AjK/Gal4lr9CVA9QJRxAMuR4/kCTGv2pVROmIy6t7O4MsyPk3iByMYJ85XFjdRcWlpamVeXaa+p7ROhKcO6JSAnNp6hcY1x5WKenDxiORcsMyVJmUCguauz6KEqQ12+UqgfDfrf/2nHHBmWPjR9zbrkWBrGbLC5MkZsKsXDtB4fNlI5LAlc4bssBAtR3Ya/WOaY782k4f7InMzUkT2nQnKs0EbYQ+Sdn2HTPo3Lbg2ZTB4pSrPtxkdZKd6woMV+YQMfite3qzz+N6tytDVzmPO7hLxeACwnJAOxzfNd9qcayMKjB/Gzhzb1R9KL/YhGkP5v++GlsDYtWwMn+cRmh/TS5id4gfmyjOQUD6b+Xd7/VOOUrylxhE3M9TgM6/AfvbK/ICJQyaEHgTmw6Bsetxc30U/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm: change_protection() strips write bit for soft-dirty on
  perm upgrade
--

commit 292879801a9c3725b053aaa1391bad7e3b1f0588
Author: Carlos L=C3=B3pez <clopez@suse.de>

mm/mmu_notifier: add MMU_NOTIFIER_RANGE_PERM_UPGRADE

This commit adds the MMU_NOTIFIER_RANGE_PERM_UPGRADE flag to indicate that a
range invalidation only upgrades access permissions, and sets it in
change_protection() for permission upgrades and userfaultfd write-protect
resolves.

> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 70922e19c741d..ce3dd4b23c25b 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -582,8 +582,9 @@ static inline long change_pud_range(struct mmu_gather=
 *tlb,
>  			continue;
> =20
>  		if (!range.start) {
> -			mmu_notifier_range_init(&range,
> -						MMU_NOTIFY_PROTECTION_VMA, 0,
> +			mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_VMA,
> +						mm_cp_is_perm_upgrade(cp_flags) ?
> +						MMU_NOTIFIER_RANGE_PERM_UPGRADE : 0,
>  						vma->vm_mm, addr, end);
>  			mmu_notifier_invalidate_range_start(&range);
>  		}

[Severity: Medium]
Can change_protection() still downgrade writable entries to read-only when
MMU_NOTIFIER_RANGE_PERM_UPGRADE is set on a VMA with soft-dirty tracking
enabled?

When vma_soft_dirty_enabled(vma) is true, newprot lacks the write bit, so
pte_modify(), pmd_modify(), and pud_modify() clear it.  When restoring
writability, set_write_prot_commit_flush_ptes() delegates to
maybe_change_pte_writable(), which returns false whenever
pte_needs_soft_dirty_wp() is true even if pte_write(oldpte) was set:

mm/mprotect.c:set_write_prot_commit_flush_ptes() {
	if (pte_write(oldpte)) {
		set_write =3D maybe_change_pte_writable(vma, ptent);
		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, nr_ptes,
				       /* idx =3D */ 0, set_write, tlb);
		return;
	}
    ...
}

can_change_pmd_writable() and can_change_pud_writable() similarly reject
entries lacking the soft-dirty bit before checking pmd_write(oldpmd) or
pud_write(oldpud).

Writing 4 (CLEAR_REFS_SOFT_DIRTY) to /proc/pid/clear_refs enables soft-dirty
tracking on all VMAs while clear_refs_test_walk() skips VM_PFNMAP VMAs, and
clear_soft_dirty() skips pinned PTEs via pte_is_pinned() (which can be
writable without the soft-dirty bit after a read swap-in of an exclusive
anonymous page).  A subsequent permission upgrade or userfaultfd resolve
then advertises MMU_NOTIFIER_RANGE_PERM_UPGRADE while write-protecting those
present entries, leaving secondary MMUs with stale writable mappings or
breaking CoW pin coherency.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112142039.9070=
90-2-clopez@suse.de?part=3D6

