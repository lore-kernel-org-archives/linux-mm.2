Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 482B7606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=fpPjAkP7
Received: by kanga.kvack.org (Postfix)
	id 5FA976B05B6; Tue, 17 Nov 2026 03:06:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D12E6B05B7; Tue, 17 Nov 2026 03:06:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8676B05B8; Tue, 17 Nov 2026 03:06:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 279C96B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:06:07 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C04E81A033C
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:06:06 +0000 (UTC)
X-FDA: 85443877932.05.23C9DBC
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id C5465A0004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:06:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fpPjAkP7;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794902765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phkLAVe2PWOa6jK368c9XEugs4HUA+7j+Ko3Mk6IPVk=;
	b=3rBJwBhSqSu7fzJpLSM2yYRmn9W6oIt96Z2Su9NLD8qwrvb+TBNtqtVM6pFbSpMe3WZmZT
	WTgKILX33WUEoAwNYU/UP4alYMAS8g+E9RgYl48WRH18RbnGWLp+B5GhSAHdK0B6kbLLxj
	Dio+N/CNQQbJ6JbnAYNzHRkgHDmpsrI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794902765;
	b=ZljpmmHRvnbltTlfwv2u8AgM90XCzkmBMk6xqGjBh57WH/Egb/MI78P4wkhbWeHLCxLvRx
	QjSyAaRK0W5EeCSrun4b1f3jwEU8bQqCFrvxSst6xqTJDfQiK5IlGpUZt9ANj33l5Coq8a
	6eHa1wSHynpIVoGz4eie10IComdhs6I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fpPjAkP7;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-55bd96affd2so7593351cf.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794902764; x=1795507564; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=phkLAVe2PWOa6jK368c9XEugs4HUA+7j+Ko3Mk6IPVk=;
        b=fpPjAkP7JlG4seMuMiy5ACbzC1cXK6KASrT4ZLJszlzRwMAcT6wHYMKzbn145ovtBA
         brJa71HqJ1Ma91ykEETV6vCL7036qtBjXTzyTV76IIFvmNWUgWNxywRsUNIY9Al9PoeL
         tl7IQ+E5ttJojiSz5P+SOJlwTpjXaPACUwDvzUby4kpsV18i2rRgAJWpl7LWEJ/+IEsL
         fcdn1a9b71HjXv27dnec4NPGMcRrwvbAOmN8w5KyYCPIQQyPo/9ZEm5lyi1fJdksS94q
         uk+7iE/1dXHGdk/kqvtXKCdxsXe752gQaWfbO834IL+vf9N4pk4dCOmjK10oU6aCsgJn
         OBSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794902764; x=1795507564;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=phkLAVe2PWOa6jK368c9XEugs4HUA+7j+Ko3Mk6IPVk=;
        b=IadLlndTLHOqhQTcjKv6+vqdCdVuuab+PSFlNw4dnAR+u3mQRHpjLAO/lKsJOn+yHH
         XZ67iYu961Vs8fyqCLDrwZpBJs3gfPL/KPc90dlebVtaqFS/DTa1kcpQ5zpwlO/1RfwY
         FZFL3U/f1t/jai2YibfEoP8aHnG4r/v0zO9chkVxUYcGc4HTt+c41cswXKsuvvdG4m2h
         ECiY1dlVtlK9GRN+DQmqBx8Mcq83UvlZhBBKh5wI1X1T3thMLXuw5xA00r/1XMpn+HQq
         J8XhqntSmssznynAsPi2dLHioHilp0X5i4kYRL0uDuV5Oxs8zRdbygZBlv/ongQGmktr
         F7+w==
X-Forwarded-Encrypted: i=1; AL+hErE3kwLuP6/5ebaqCe0o290xApU1gYMWnLW9qqNgobQedtPdoiYGJ3pSLFRHs1p/vw6VN3iCITAjfw==@kvack.org
X-Gm-Message-State: APuU4Z/9+hjlkLAaF6raW7RCvJQBHxfbOGLttrkrzp406auN3ztR9IOn
	SQ9A4Ax1AG6Mv2Dy8nfBevLyJE3etoT+cVcOtCkWMWjvRwP7UDS9IsWU7U3tseZ4l0A=
X-Gm-Gg: AYBFou1cyaMMNYWeP8c48hCmVzHAsIfOY2uxVcSmHOkul0eZKwHK5qFSeq0rT7Q5XXb
	X6RBxlpycy7h/9bCzo83JZf69AJ/3VsJ5p9w3524yCrjSuE4RNWCDD7pqhlvYvWjeoFU6v+K7fj
	FbvyiRKXDab7FI9iB3ngL3bZBncMclgLvD55j74SKauxAtBriPVFwa4RfKFw+FAwrkDM+KZIp3C
	KspCS6qynImtx2qNTPVzIsxaYjIKuMkivvXvuoBVckedFQJ+KRCyDv+vQAKWkc47RFroBvrrV4i
	ioZnufTGuNQZsmjxhnyvneenw1eThWvh77I816G2w1iNjqiovhq9p4krCFuYKyRU0wC94JI39MW
	HP9LsXkre/3XOBrSZBlGdRBpOCriLiqypjDBibcXzEdIiyyFjgSjpvfNoX1aY2eTN3lcsh5pdiF
	OZHs/rz14Q3oDqSqyZmJPwtTHCNuKUyUNBqnsr3t9MBkepd+Gz9BoKQujoK73WdAkmRLJyXu361
	fTvLg7dOdmUjT9om+v1CadqbDsDPmS7REOmOsoWkGg4N1Tv+EeM/SDZWs2A9Ecag0LWHkFY9NpO
	WoH0VBoSaIp82ByeVD6wRQ0rdyuIXaa0T4p8QFswlJ/NFjSJskAYL60/1FsXEhLkv6g0NLWkaNx
	PoxKYWKivLvQZ9lMvtc8RJh8spqFq
X-Received: by 2002:a05:622a:5a17:b0:55d:31ac:d86f with SMTP id d75a77b69052e-55d494553e7mr26563541cf.13.1794902763822;
        Tue, 17 Nov 2026 00:06:03 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d7fad3sm105812516d6.29.2026.11.17.00.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:06:03 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/hmm: skip NUMA balancing on protnone faults
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Alistair Popple <apopple@nvidia.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Matthew Auld <matthew.auld@intel.com>, linux-mm@kvack.org, 
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
 Matthew Brost <matthew.brost@intel.com>, 
 =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>, 
 Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <avvJZtN88gLXA6Uz@nvdebian.thelocal>
References: <20261112-numa-v1-1-ad9cbca8f49a@intel.com>
 <b32fb02a-68b4-4db9-83dd-254147dbf215@kernel.org>
 <1993e931e6a4b0cda5c04e72b1a8d5fb924f950a.camel@linux.intel.com>
 <9ec3e8b9-064a-47a7-8d00-566ff371b846@kernel.org>
 <179460319801.482102.15329919214055018110.b4-reply@b4>
 <avuN2eIrlqrO0u6O@nvdebian.thelocal>
 <179487347201.482102.6428415219993123805.b4-reply@b4>
 <avvJZtN88gLXA6Uz@nvdebian.thelocal>
Date: Tue, 17 Nov 2026 03:06:02 -0500
Message-Id: <179490276245.482102.13112734238511841101.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C5465A0004
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 1jdt73o311pth68upp13ifgu4tjji95i
X-HE-Tag: 1794902764-56354
X-HE-Meta: U2FsdGVkX1+cYoebsDvEvKjAEUtaiwpHE15tCafjipPTeWLxP7GJJnxj5D7tpkpx7v72aLagk9PC5GXX4DeIHWJDdtoLa7NAybIKo9Hm6UCQM4p29cw2msBhtIsKulZbnB8OqJIGBYLDDb0RtJAloIeEETg+4MxruJy3jwLv6cxd71IpLPwkWxd0jSg06UfWP3cggQpFJiqQde9Xnxp5lblGaTNuZojiZFI/0AImcWTI5aB4xKOGqlJNpLLPgYalHtHZg4LeXCjBNi9Z/UQDP9VM897IFg5ou20HASnWptx2Si7/4YhOSDyiboiQHXl6koL3J4TmVMKZPyEbLDnjpmuBAuBbqrSpPW2B6EMkip+N0NgGxAgIstIlL2IzXshvrgrYgVfFeytGPQhcPAqiMW07N0AGcs6NnctDYDV2ysqA7TI3/Asb3UrL6sIOB3CdlQBd+Wah4he4XnKcut+xs02CM922uQ6Curdb8e8H6WCfPFxILzwhhb4r2OSa/WnJGn+19UHBu3nXpOb9LiFRv/fXsEvQB6f15OfKJWHXVa0DIvGBjsP7K8wBDoj6ziCvcnBgZ6KNxEHBPnXfJEybYCiG+W3pwgD+ID5JfNLoru8bnrohJyFgxSh9m8Lkm62MDDf2VHjmZNyIC2oE3bX+vtQlvKQvT9Dcr7P0pf4bmvQE/MuCwSSVCY7IWag6Ko1VY+Jnh3skI7uIhHWpMDPO1IyuggkoN0TmbZT2V1IeMXSp7BgpFIvPLfaacXphotC1Mg67nEspdWzsNE1jzkxfs2Dt8NIg5q513I55/1IR0ayVMldP/NXu+sz3A7YjnaG9ReXLgawIOjB52yuZ36/j3wRiGmP04wXZgL8n4y/8db6Ui/XP9uSLIBus+LzPQMcQiGa+T9LpzJbW6W4YZ+1kYiFm59JBpCoYijNcPqGL9BeueWUDAeuHlHkWO1RKaM47WUyBrWbQCj/vGAIstaz
 VZTT7MUm
 L9wjLcUJqb2bwN1WfMyaZPN12x7uaaALxwJCaKdWvxyKd4VVWp7iTC0F8l9nvext4IfNNvd2U20jsAw9cf1H6WoBnnE+AeEqmyfI2Qj1n7P3KcSIlnqyn7SDvyvCY5JhwnvYdJ6VJ+PWADKx8GvDkaOzc1DklvKCJ5EchPqlZSxISStwhSPuuL4SNnTWAlmxcC1f9nUzZ3wIjAFu2JnPCwHa//xm++nW/E1lwKeqIIqctlhsZkxdRRjECQ5uThiefd+e9fVYM33y+zZd20vLfCoD3gxdr1Yq2x+5zOag1aSb1G8hJm9r8059/qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-17 14:51 +1100, Alistair Popple wrote:
> On 2026-11-17 at 10:57 +1100, "Gregory Price (Meta)" <gourry@gourry.net> wrote...
> > 
> > Ah, I follow.  I'm still working through the performance implications of
> > mmu_notifiers in the presence of PROT_NONE faults, but if i'm
> > understanding correctly it tracks that you'd say it's incompatible.
> 
> Incompatible is probably not the correct term as it still works. It's just that
> GPU faults are really expensive, and to be avoided at all costs. So having NUMA
> balancing running around randomly unmapping pages the GPU is using (regardless
> of whether or not they are on the device) results in more GPU faults and
> therefore a huge perf impact for basically no (or in fact sometimes negative)
> gain.
> 
> > I presume here the driver needs a global view of memory (or at least all
> > memory it can potentially DMA), rather than simply just a subset
> > (some set of VMAs)?
> 
> The basic process is this:
> 
> * GPU needs to access some user space virtual address (eg. allocated with mmap/malloc)
> * Therefore GPU driver needs to setup GPU page tables to point to the physical
>   memory[1] backing the user space virtual address
> * To find the physical address the GPU driver uses hmm_range_fault() on the
>   range, possibly faulting pages in if required (ie. if CPU PTE permissions
>   don't match what's required).
> * hmm_range_fault() relies on mmu_notifiers for synchronisation with CPU PTE state.
> * An mmu_notifier firing causes a driver to do two things:
>   a) Must invalidate any GPU page tables / TLBs mapping the notified virtual address.
>   b) Increments a sequence number for any concurrent hmm_range_faults(), which must
>      retry as their view of CPU PTEs is now out-dated. This is the problem
>      this patch series hits - the migration on fault causes an mmu_notifier to fire
>      resulting in a hmm_range_fault() retry and associated overhead.
> 
> So the driver doesn't need a global view of memory, just a view of the memory
> the GPU needs, or likely needs, to access. Determining that depends on the
> driver - some might require pre-registration of the ranges (eg. via an ioctl)
> prior to launching work whilst others might wait until the GPU work faults on an
> address not in the GPU page tables. Or some combination thereof.
> 

I feel like i'm missing something here.

Why can't this be solved by just setting MPOL_LOCAL (or any bind policy)
without MPOL_F_NUMA_BALANCING on the VMA to prevent the VMA from being
NUMA scanned in the first place?

mpol_misplaced() already checks whether it should migrate with the
MPOL_F_MOF flag:

    pol = get_vma_policy(vma, addr, folio_order(folio), &ilx);
    if (!(pol->flags & MPOL_F_MOF))
        goto out;

and task_numa_work never scans VMA's without MOF:

    for (; vma; vma = vma_next(&vmi)) {
        if (!vma_migratable(vma) || !vma_policy_mof(vma) ... )
                trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UNSUITABLE);
                continue;
        }
    ...
    }

So any stray (already scanned) pages at least won't migrate, and
NUMA balancing skips re-arming for VMAs that don't set MPOL_F_MOF.

You'd only have to worry about a user setting a mempolicy after
it becomes hmm tracked - and i think we could work around that
by locking a VMA policy in place.

Gets a little tricky for pagecache i suppose, but the plumbing
exists to handle this.

Anyway, MOF gets set is if you inherit the default policy:

void __init numa_policy_init(void)
{
...
    for_each_node(nid) {
        preferred_node_policy[nid] = (struct mempolicy) {
            .refcnt = ATOMIC_INIT(1),
            .mode = MPOL_PREFERRED,
            .flags = MPOL_F_MOF | MPOL_F_MORON,
            .nodes = nodemask_of_node(nid),
        };
    }
...
}

or you set MPOL_F_NUMA_BALANCING on the policy:

static inline int sanitize_mpol_flags(int *mode, unsigned short *flags)
{
...
    if (*flags & MPOL_F_NUMA_BALANCING) {
        if (*mode == MPOL_BIND || *mode == MPOL_PREFERRED_MANY)
            *flags |= (MPOL_F_MOF | MPOL_F_MORON);
        else
            return -EINVAL;
    }
...
}

If the memory is tmpfs/shmem, you can even set a default mempolicy at
mount time that does not set numa balancing.  If we need that for
another filesystem, it can be added trivially.

If there's a need for a driver or hmm to update a VMA mempolicy as part
of the hmm runtime process so userland doesn't have to know about it
under the hood - i think we could do that too.

Am I missing something?  Seems we can just rid hmm-tracked regions of
NUMA Balancing PROT_NONE faults entirely instead of ignoring them.

~Gregory

-- 
~Gregory


