Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF02F606A880
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=COMCeF2g
Received: by kanga.kvack.org (Postfix)
	id 03C086B05BA; Mon, 16 Nov 2026 10:12:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0191D6B05BB; Mon, 16 Nov 2026 10:12:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93B86B05BC; Mon, 16 Nov 2026 10:12:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C274E6B05BA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:12:50 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 51B531C1137
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:12:50 +0000 (UTC)
X-FDA: 85441324500.08.167587C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9ED1F4000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:12:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=COMCeF2g;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794841968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQJbz0+g2lH5pB00J5WNO9QkzcZ2ta2JczWJ7IFiNSo=;
	b=20WIiSq9IMkPI5ZUXtRsYMNn4BCx/4dAm1CRnv9ZwTYGZD8/y2UR0PVCSgtoX2ZEkN+HHM
	8Ujk1hxoFFiSwLfJmn1l0mUbIrEMQW1G0S05Xuaw1zxRE47gsG0hZ6BP6rjyHQhl3nCJX/
	8R1E7ywafC1YpBtcgXmRQPvQP0kzGus=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794841968;
	b=vRAckk5isTdf/z2dGzm9iidvKAPx78uiC7JUzHGF7b3bHpCDF9eFXn+uf6+iPuANm3dLDm
	OfOxGqoHq2iePsS22AGvNNMEJYwRTPfd1wc2MG8JQPNA5hNyVb9RGKFAZ3RkFQ+L9mxfTB
	qivOItpE6jIeWoCEWIUqP3kT6VMXLkE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=COMCeF2g;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 21D3C62D7C;
	Mon, 16 Nov 2026 15:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A1E1F000C6;
	Mon, 16 Nov 2026 15:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794841967;
	bh=JQJbz0+g2lH5pB00J5WNO9QkzcZ2ta2JczWJ7IFiNSo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=COMCeF2gVxBOIqseA4DrlRfHBB8N6I+viinf6+LyU6H8+R4iKILtLBVf5fwb/+QWJ
	 39LYitotiXu5WMcxLsoiF+pAeS/ZZpdGZie9J7af4Xpu3SnJ/Dz13Zfpt49gS06V3D
	 wOYcJSC/26FoOsaAFuG1aCOQ5TopMT15cACyCtuyEHiZJW/SjA7kz0JYTi44nsj8Ms
	 o+VeEke64isp7htctM/tnVRKDz798GW5JNygcivEDaj/p/QdPRopAoEElviyGQBFQJ
	 mE0DGNWPUE+ttt1TWwBeiCNhqlsVCH9+/rI0gjDpIhWbe+jmCfg1CUsBhPZ57NCXdW
	 P0YDVJAGLo2pg==
Date: Mon, 16 Nov 2026 15:12:42 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Eliav Farber <farbere@amazon.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] mm, uio: huge PFN mappings for /dev/mem and UIO
Message-ID: <avsbLgh-zBGmE4KF@gremlin>
References: <20261112125638.12209-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112125638.12209-1-farbere@amazon.com>
X-Rspamd-Queue-Id: 9ED1F4000B
X-Stat-Signature: wrijdmsxg7bwzswekxyjhey1w84wqc4b
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794841968-708691
X-HE-Meta: U2FsdGVkX1/hU9mN7VkWNW11G+tjBTdX/BvqTyzeM8qzN0fe8bLb1tR1aygZuhlmXD7f0f/W97WPgBHDav3SupctTXCOoJhPoJAc+mb6wNH1fOj4UX0qA+/1HVIyR5aknEcGb4by64H3zRVYvD4cmge8MniHELEEi7gN3bEe0qT+MYLqPU+qVNMyj/mClHqxAt7RRyV8oZ1OjjuBo17S62DZjoxEH/9FR+eDkwvJfCduG2H4CMINr1VUI+R9ISMEnMlxUbGi7l7z9m9KWzcdZXPhENm/5SgEFL7vdEyLS3zhoLN5mAN2oK88YsGA5MPVzmih20h2ftCBVL8qgGULYQtOO8GNf+KX1vGobsHq3CrSwbjORchdxkoob5bMFX0vLkGemd8coXQUkBOmNiBthyxPuWUB1NPprKSl0p4CgiL3LY96DzR6RnglxwvE24wF7Llz17o9s/RPWlZf3vfXTKNbrZfW7A/CePaaq1yGQYb+NLdKAbFLAp4Ty9jsJzKt2byMSYzZ2+MqJPs2nFU9OMjclvH+x9jh3IFMy3ptOd+wJVagFMB6/xavOfnz8Ly5f7PBhvwhSMY0ovcJrYi2r5RrcK9Ouk4c/pAWFh2Oa3/FYVgN6fTVUc0LwejODqlE9FXkyEjWi4VoTjnm1Tst3n6cELsP0p24PN0v3nP2lgQpv3SzaJJic1IFpblK/F4lfW02xjVul/AaWtQV2E8HzmY7jmA92wzvkfRfR9CclhRkwxS2grN8ANVRzdlW1lJzMq0cf3OUS3/CdTdMQSCUzTCDHi82op3Nsb+ybWNccryLPJoUXGovFkFg4eGkvyi3czyUdEwrngHGc7/zEtwgHVuRB2Xpc40MX27gPlt+sWztpINRBPMGAnmyj9i1sTU2og6jA+y9hd1hDYV3LQMhu5jwrHvIv5JEn2tddeSwyF/npMKVWOCzsu22R22zMq+mpMad6BzPe2I7GILWlUf
 5w7tJqtR
 D+UHYspUZy4yi9PpXFQ8Lj4KTayK/Aavq1KlU6tSA/6uY/oM3a7UOr0bzDH12TV+c7XOLKgR5tScdCxcUSmeQQmnzdvvQCS3V4TJV1ZE/JSM7IYSYNhkyNpDT2vMNOs5mnumHMrI3q8atzcBFIgSX7HrKjkFdMV+/s8kBSpKFj5yxqe36vXFOWn+fa0gqBy/k6veJI1T9gvJzm/+hbi5PLE8Lmcu9EaW/8W1MXyMEJp1NNuObjwog9xpnVQbghHYd/QtprOVU5PnCPvZ9jrWTawSRLhJ6voWFN/6XUyHYELyFDGY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Err, there unanswered questions on v1 of this review, so why have you
sent a respin?...

I also seem to remember David asking you to slow down on the respins
earlier too.

AI might make it easy to send stuff out but you're outsourcing work to
maintainers here...

On Thu, Nov 12, 2026 at 12:56:34PM +0000, Eliav Farber wrote:
> /dev/mem and UIO both hand large, well-aligned physical regions to
> userspace, and both populate them eagerly at mmap() time with
> remap_pfn_range(), that is with 4K PTEs however large and well aligned
> the region is. vfio-pci moved to fault-driven population in commit
> f9e54c3a2f5b ("vfio/pci: implement huge_fault support") and gets PMD and
> PUD mappings where alignment allows. This series does the same for
> /dev/mem and UIO, and factors out the logic vfio-pci open-codes so that a
> third driver does not have to repeat it.
>
> Two things have to be solved to do this outside vfio-pci:

[blah
blah
blah
blah
...]

Just way way way too many schloppy words. Write this yourself please.

>
> Testing
> =======
>
> Tested on x86_64 at 7.4-rc2, and on arm64 at 7.3.4, which is what the
> test hardware runs. The four patches are identical in both trees.

[blah
blah
blah
blah
....]

> Two things none of this reaches: 1G PUD mappings anywhere but x86, as the
> test hardware has no suitable 1G-aligned region, and the huge zero folio
> fallback in patch 2, which needs STRICT_DEVMEM=n and has no check
> targeting it.

This is so TOO MUCH noisy, schloppy information. Write this stuff yourself
and small.

I hate to say it but it feels so so lazy to get an AI to do stuff like this
without even bothering to reference _how things are done in mm_.

Be considerate please, we don't have time to read your novels.

And you've been told before...

>
> Performance
> ===========
>
> Unchanged from v1, where the numbers are tabulated; nothing in v2 touches
> the huge path. On arm64 the fault counts were re-measured and are
> identical: 128 faults for a 256MB /dev/mem region against 65536 for a 4K
> mapping, and 4 against 2048 for an 8MB UIO region. Against today's eager
> mapping the series cut mmap() by 95x on the 256MB region and 5.6x on the
> 8MB one, total setup by about 12% on both, and the dTLB read-miss count
> by about 80x.

We don't need a (schloppy) 'perf since last-version' update thanks.

>
> Changes since v1
> ================
>
> - Patch 2: the order-0 path passes the fault's write flag too, so a
>   caller that does not retry the access, fixup_user_fault() from an
>   ->access handler, is not left with a read-only pte.
>   vmf_insert_pfn_prot() keeps its signature; its body moved into a
>   static __vmf_insert_pfn_prot() taking mkwrite.
>
> - Patches 3 and 4: COW mappings get their own vm_operations_struct
>   defining only .access, instead of a COW test inside the fault
>   handler, which was not enough: installing ->fault at all skips
>   do_fault()'s recheck of a pte cleared under the page table lock.
>
> - Commit messages: corrected the L1TF claim in patches 3 and 4 -
>   mmap(PROT_NONE) above l1tf_pfn_limit() now succeeds, and nothing
>   fails later - and dropped patch 2's claim that uffd-wp can
>   write-protect such a mapping.
>
> - Patch 3: the commit message now also documents what the fault-time
>   range_is_allowed() re-check changes without CONFIG_IO_STRICT_DEVMEM,
>   where revoke_iomem() is a no-op.

This is so schloppy and WAY TOO MANY WORDS. Please just write these things
yourself...

>
> The write-flag and COW changes came from sashiko-bot's review of v1.

You credit sashiko but not David... Please follow how _other established mm
people_ do these things please.

See [0] for an example. Note the brevity and actually crediting people who
asked, so they know that their feedback was addressed.

>
> v1: https://lore.kernel.org/all/20261111113045.35368-1-farbere@amazon.com/

See https://lore.kernel.org/all/042795ab-e8af-443f-b34c-72c674c0ea32@kernel.org/

You were told to rewrite your answer, instead you sent a v2. This isn't how
to interact on-list.

--
Cheers, Lorenzo

[0]: https://lore.kernel.org/linux-mm/20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org/

