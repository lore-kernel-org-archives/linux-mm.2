Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2EA4606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 20:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Nnbx3XTq
Received: by kanga.kvack.org (Postfix)
	id CF7BA6B00EF; Wed, 11 Nov 2026 15:45:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80426B05C8; Wed, 11 Nov 2026 15:45:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B481A6B05C9; Wed, 11 Nov 2026 15:45:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8138C6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:45:18 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 06C891C3BBC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:45:18 +0000 (UTC)
X-FDA: 85424018316.23.41F5CBF
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 112BF1C0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:45:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Nnbx3XTq;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794429916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ejReHMBjl59d9ux/+j0JWqbuls8q6pULA6fL9qb3kCo=;
	b=Tin5IxiIg/lIBF9Dgs6cIhe4KL5tsTnzSR6X+ny217LPNalOmAyfLcsdbOdoKYYOjge0qR
	IocY4tZfeSBRH6vPUwpVVCJ+JgKwKZo0mTft5sNVSeQ9A2iuWGl2G3jM7BuU+t4e2Qf+ks
	IXqG26LKVzED/vZvcyUTl8PRZ6QTvrI=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Nnbx3XTq;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794429916;
	b=stC/lZKdgowq51rIlCzzS02TKOr5oNYUrvB9FPXVgfwGZ7MwAkcvkKZlw4x3bv5a6byRov
	hZ0Wn6afGp709JVZ+2b05kZ9NTwERDv6+xCTvBRlO2Yj85HP2bv+IdRwpkh3cxrUuv0foM
	SlLhBV6wAChXZ3GlyRSWm8/w2UYZgCc=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-533202fe429so2371cf.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:45:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794429915; cv=none;
        d=google.com; s=arc-20260327;
        b=hJC0LqkbdQ7oBuY9q+iuDsMJzjXlqRHkFK6mleTq7Hi+GszOPL1N9QdGCuyf+PzlaI
         bnrmeI+l09KkMjoOaeKx+y+VbX3Sq15o9kVgccD68xQP2nQPG/hxVyYxEZwvop6QvToo
         CNXu3XrE/m3mXb1wIK4SI7HMseVdH58cKTz1rcTVg3ku4MdId4LyTK/v0rav5+irI2k8
         VxLalui2zQkauOVYffOMFF+NFDsGLMjtjTlGApZTpZUfz4hniaKzeMRz66JNObHg1HEE
         dw0SmZqyBf36nvceImkXHHcf820VP1lCDAHaIVmObyIfX6y8taa670uiUeZ5xXFr4MaW
         AZow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ejReHMBjl59d9ux/+j0JWqbuls8q6pULA6fL9qb3kCo=;
        fh=wGTMnhRM2qiMKJqpv1IOJW1GLHuv9biSsYe5Jy9+a98=;
        b=aLyQspzW3QvZR8rTITG7HcCbEcHCAWpgM4jv/le86VJN0+Rz6uMpvcZaO5T1JmmL+i
         n/MbzfEVbsQyRoguj1fy1dF40JCDk2bNvjlc5CKzHhD+6FSYsfFHRkwC+xB1Vr0v/5Dv
         MQpIyEdAsi2hxX9QT67YcMG4tSKAG8l1wm5BPCcOkMwOnwnpD+XzKosZFBYKcYZW3Dab
         jA6uzQV5BNWccNAvS6G4F8seWvYmvorxGYzn84D0TLc9V46TXj1q88pidHTuM5qECY12
         Zla/FbpV1imT9IfznBV9qwOF/ScX1SeAOK05SrJ6V5/MN0Yjnhs+UzVW2EUODCNB+7Cg
         ZBJA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794429915; x=1795034715; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ejReHMBjl59d9ux/+j0JWqbuls8q6pULA6fL9qb3kCo=;
        b=Nnbx3XTqWGRfenqk7vQ34qFgshNk9B3jaFFb2WdSxKSMo8iPwObD2o74JpKNLBvl5x
         ODGVwZwIE5VfeGcZ+esWFb7K3mA8XcblWda3SJDEpdetoXW2iZu6AnYFbrV8PjJYfC7d
         VljHb+oRP+dVRYhjpNyH4laW1TNg5BRY204DJHqF1kKyFEjkATyfune3hOVCzg2r5PRX
         14qBpEsibopAsogzr/WchR1eujv5Ef5p3wK9pN/G7ocXeu16Qn0lIeDs9leVK24/2nix
         g3n8lnl5mUiL2SfZd5wHhMt2oRwlULFvuYEE88x5SppXzZVZx11b41j7hfqkPdn+ZW+m
         Mimw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794429915; x=1795034715;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ejReHMBjl59d9ux/+j0JWqbuls8q6pULA6fL9qb3kCo=;
        b=Gj29bwJX0dhOXstroETtHO1Gcma88XZ1UvUCWAnOREOZfFVoEpirDLsSQixU4CmBqt
         yeDoqV4k5Y535ZzFmPAo2ryOW0W5pWT2KHGsUymD2OuiWRr8oXoeXkUhdkH3xdX0Wpbc
         IUaBbdBLTResMiQMtGFMctntmxO4nJdkshD6kZ/t2YjE157uczQDfeM552v+5ExJmEL5
         cTMvzQtxQ4DyNoyvJgwTw+2V/8gr+BagnWt/B7Nn+LJnH7B0i767yCWt+bu+ZUux+Wj9
         2kdacW/ylqshx3SeQlecIwEBfdLCSoVwOpkSQ2t4bsmbZxgUa4svm0EqbG2wa/bJmedq
         +RDg==
X-Forwarded-Encrypted: i=1; AL+hErEathmuGK4/XER0oDNNZRKdlHLo2ozliZApXxs9qDSzmGfYb7U7PXtgONtgk1txB+5o/Jo55jZpnQ==@kvack.org
X-Gm-Message-State: APuU4Z/woQvI3cjJuMraroXHla6XLvaxuV+rm4aX5O4jQ6zhwySMUBgS
	XTpXuQRDusLmeJxAo23htcG6Kiek61LRUPTuFO85j+Cf58CkyO7R+mP2cC1f3vrMAXxeZstw70X
	y7RdYgKenM1omgoMhDzak9n4TPWl5LBLyn6XgJvtc
X-Gm-Gg: AYBFou3KGLZhkHSqUzFevHx7vvJ/EyuR5n95UHzbjIZ35uBVcqH4sqezIchf3M6GjjA
	mGUeV4GNFqgiXQIfkWMnKPn6uQ4rtb6rc14Jz4j8tvxX/ihx3pShmDBQa8mO+xDWUJomb3on4VS
	ioSvFVV5bOLQntrmJ3pFrT25qdN8/lQcA/FTtxaf/1Ls1ay4Am6MAiGKZMyhLqvEris5epJCi+i
	cd6YCNl9XbzBTQQ3UDpCcQbymWuHXAKcp3YguYCwFRBlpTM8tfkqMHJOS0BqUhuX5C/seQ0PTaY
	IrbrsRkarwYF92MAFA4v89y9/xAT7poSyC7N291QHrU10UEII02Ezss6whzQ87svlerJEm25Tf2
	Q/o5cqwLqwMaNdl9tS1TolmzXy5foH4cLbHy8ELsql+phRYkjxKixZAEsrsoifiMBf4FabG3zR4
	jcg4DkTLmHaRCHvr6TKYyHRvLm
X-Received: by 2002:ac8:5c84:0:b0:534:d386:c3f1 with SMTP id
 d75a77b69052e-5598d505571mr488441cf.9.1794429914175; Wed, 11 Nov 2026
 12:45:14 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110112546.261415-1-hao.ge@linux.dev>
In-Reply-To: <20261110112546.261415-1-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 11 Nov 2026 20:45:02 +0000
X-Gm-Features: AclHuK-ZSzUbXpuTPMxX4-S9gb3Y2E-tjBJBsqLyAoT0xCfZuwy_cCHQcxiXGC4
Message-ID: <CAJuCfpEUVDVZ53Pe3uzUVU_=4V3vipCLqY8jo_CC5kA_ZJSnEA@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] mm/vmalloc: fix up vmap error handling
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 112BF1C0005
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ia4pf5rf9ediujjipc6j7nwycif3rahr
X-HE-Tag: 1794429915-994909
X-HE-Meta: U2FsdGVkX18OdIzJtMiFx/QK5ppIaiFx07Py8Xizk6ICn/GgcT2e+givAFYN8HYRIhRnTXt7ccGfE6uEJmg5saMlJCGFwh138UlLld7dj3iMiNNeMH7WG4ShFGf24be6UoOKKIS5Akz9iheWSMaCGJJ1RLodTBJULc98Ji5wqYy3NDyf9KQmJ5mCs9gYAoHs+qI+uviEX5+WzVQRkl5bwivFOHx5cHHtWRklkOcYoVonstqqFHA9V+eDmLLohyhL5v/sNv6fAdqLTV0FYIBRpTAm4BYnwgw58CUxxxdIc0Q0BMCwbgOXWQj1x8oPAlohLD4VCdejY2g77vXLK+AujJTge3qxDgrOz/5ufemncv8wXNZt3LGg7kCAPtpwSaIbMD7Ur9SwRcXwjIClOXJzOmYetrw9Eua+COkKlRpdw9QDdgmar3qYrl6lff6uwdvWVnz5/XJp9DiEfn87jeIzY6YiVZAgJoF/t71hts/dcwYC+6a24a5d/5Lnu7SDBL677U0jBqvq9mBEoR0mN/zLEM5+zzuUOATah8MT/p4RCjWgB9dc0NJniNDHvHWPnHHQ23wC5C+puCpywWQM2qaJdZ7p3VHd6e5RSlqMdMl7A+uVSpbg2tkQ4wVBnjhqRd7RLxXgfGZmxbO3LqtAP08fiG4ow7u1JT5JXLu/BgIL+fsB9HcrFDTMaaHzw+JWsI1T4tWcjSV/wJHLrBKjAxDdWpo7eLy6M9tFElZAoNApoQEsrkEUtXuIDF+xYbVWB5CSXIQVHSSSH5eaqSniEOeWs9D9yKPUXnRELtSucNsHPCtwxo+7nN6450oY/SK14FIcW28AmkXumFI8ZPln/p4dlKa+ABZxM8rdGIUfqKBwe4EqK0/zA+mDJY3QY0jKZOQMykkID1yvMWQnZul13hlB93WNoOUell6vEbvU+S5MHDCLXEyYlpU/3JEfRw7o6qc6yib7mW0XNyUvaEFbXSM
 +hbnYZRE
 7Pa86Pewm5V9IU3UZaB7HEiDr0+LuRqCrZz4SHcpJpfxT1rp4efdcVHrm+kXMXSX85hCid11PSo1q7R/CrEjN/SUYyotmZA9Cv5gSXZ29/SEYIDvoL3aiHYKLc8VTgq3IWHAJoNfGZrtEvBhTdL12LEFeMyjlJ/dtw7TXgX33PENJN4LQgvLoj19Krszt71J/8gPyDcQtQXdYxAREPQ0BRDRfvN4QsM0v7TE6fZkXzPZA199cUIjWhY1dPnair2G/zzZIFZrJ5iLcwEwr7JgbG53VJ7o5zUO8Q71AfuEFg9PQJiKZjhUwXDhSWcGclPPATl7OUG/ecGL69EQuRmvvX9Synw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 11:24=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> __vmap_pages_range_noflush() and friends can install some PTEs before
> failing and leave them mapped, and the kernel callers do not agree on
> who cleans them up. pcpu_map_pages() and kmsan_ioremap_page_range()
> roll back what they mapped before the failure, while
> vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
> __vmalloc_area_node() rely on the mapping functions cleaning up and
> do not call anything like vunmap_range() themselves. When the same
> range is mapped again, the attempt hits the leftovers and fails with
> a warning in vmap_pages_pte_range(). A leftover huge pmd is worse.
> During the retry, vmap_try_huge_pmd() calls pmd_free_pte_page() on
> it, and the x86 implementation cannot tell a leaf entry from a page
> table and frees the mapped page.

Please note that there is a new function called
vmap_pages_range_batched() which should also unmap its incomplete
mappings on failure. This function was introduced by a patch called
"mm/vmalloc: map contiguous pages in batches for vmap() if possible"
in mm-new. I think it should be handled by this series as well.

checkpatch.pl also complains about "Reported-by: should be immediately
followed by Closes" on some of the patches, which can be easily fixed.

>
> After discussing with Suren and Ulad [1], we move the rollback into
> the mapping functions. A failed vmap leaves nothing mapped, and the
> callers no longer clean up after it.
>
> Patch 1 is the KMSAN part. The shadow and the origin of a range are
> mapped by two separate calls, so the rollback there has to cover
> both. Patch 2 is its disabled-KMSAN counterpart. Patches 3 to 5 bug
> out on an unaligned range at the entry of the three range walkers.
> Patch 6 only flushes the cache once the mapping succeeded. Patch 7
> adds the rollback to __vmap_pages_range_noflush() and
> vmap_page_range(). Patches 8 and 9 drop the powerpc and percpu
> cleanups that are not needed anymore.
>
> Changes since v3:
> - drop v3 patch 3. The clamp papered over the caller bug, a bad
>   range now BUG_ONs at the unmap entry
> - drop v3 patch 4. The reworked walk (24bbe1c56f63a) propagates
>   the errors already
> - drop v3 patch 6. The walk below checks the range already
> - the map side checks moved from the pte level to the entries of
>   vmap_range_noflush() and the walk, and became BUG_ON, in line
>   with the unmap side
> - rebase onto the walk rework, commit messages updated accordingly
>
> [1] https://lore.kernel.org/all/20260915070001.113559-3-hao.ge@linux.dev/
>
> v3 link: https://lore.kernel.org/all/20261026080329.140244-1-hao.ge@linux=
.dev/
> v2 link: https://lore.kernel.org/all/20261019054531.87652-1-hao.ge@linux.=
dev/
> v1 link: https://lore.kernel.org/all/20261009063619.112313-1-hao.ge@linux=
.dev/
>
> Hao Ge (9):
>   mm/kmsan: undo the shadow mapping when the origin mapping fails
>   mm/kmsan: skip vunmap_range_noflush when KMSAN is disabled
>   mm/vmalloc: BUG_ON() on an unaligned range in vmap_range_noflush()
>   mm/vmalloc: BUG_ON() on an unaligned range in
>     vmap_pages_range_noflush_walk()
>   mm/vmalloc: BUG_ON() on an unaligned range in __vunmap_range_noflush()
>   mm/vmalloc: only flush the cache after the vmap succeeded
>   mm/vmalloc: undo partial mappings inside the mapping functions
>   powerpc: drop redundant unmaps of failed vmap mappings
>   mm/percpu: stop unmapping the CPU that failed to map
>
>  arch/powerpc/kernel/isa-bridge.c |  5 +--
>  arch/powerpc/kernel/pci_64.c     |  4 +-
>  include/linux/kmsan.h            |  8 +++-
>  mm/kmsan/hooks.c                 | 21 ++++++---
>  mm/kmsan/shadow.c                |  9 +++-
>  mm/percpu-vm.c                   |  5 ++-
>  mm/vmalloc.c                     | 75 ++++++++++++++++++++++++--------
>  mm/vmalloc.h                     |  6 ++-
>  8 files changed, 94 insertions(+), 39 deletions(-)
>
> --
> 2.25.1

