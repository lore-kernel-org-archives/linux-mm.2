Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5766E606A33A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 00:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WHyXxKf8
Received: by kanga.kvack.org (Postfix)
	id 5D1E06B05B0; Wed, 11 Nov 2026 19:01:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582546B05B1; Wed, 11 Nov 2026 19:01:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449FE6B05B2; Wed, 11 Nov 2026 19:01:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1195B6B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:01:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C3EF160497
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:01:02 +0000 (UTC)
X-FDA: 85424511564.12.599F372
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8B5461C000E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:01:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=WHyXxKf8;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794441660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/+sJZZbZo2UcO+Nr8+QxFylA7K/BaXAtaD89aBd6sd0=;
	b=h6CJzJ6PPAIMiSwPtc58UDcMpABgfViRKDN/TAfEwyKmLSdJbTkouXA/sCeffiRPv+5xaI
	Z7KzhPRQ/d1F3HpskY33egP7MB2wGWWG2C6rT76KVE9L0B5PvCR7+RJhkv5tfM/qLGh+Lj
	z2Ebz0WT8rB3wdY8+8ql6+NmRemMayw=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=WHyXxKf8;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794441660;
	b=2Ojhm6Cyg7CqtBURCQzc2syZmJL9erY61IinIZKz/fm1f7a9bHyXK+goPdIbU/nDgdG7uX
	lYVyEmW4MoCscZl36SHJvSchGJtMvuglPvyHIs2g6nD+tCrYIkWo/jfpPqAz8csSmzalaK
	SRVTvXArI4rRZfwzpTxW7/yBBITZLTw=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5383c97c8cfso36711cf.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:01:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794441660; cv=none;
        d=google.com; s=arc-20260327;
        b=HZat93pndnA3YVPgpth7VL/QB1QWGtRDAvs3y/EYA4e1WMDvBaZd5NMmoBUTQ51/yi
         s2k6h2jXPypUvDdoayAEWbwptvJSvCCOSuEMNgXwRKWyPLWVTypq4UW9em5Z4u+pMhyT
         d24Fgxp99VZ2Ob17IbZQ51Bu75NXJvhOrn55iqB1V+QMmbSS6qFWAX/bgerOUSL36dQw
         dHJkEOkNt1C3qOtM5+k2a2r07SZ2m/nvHfZc/dBo+LTaEpqrsLSdYKwkWJysbhjLDt7e
         RoXKyQYtFsJz6xSX+ZkOIRxHdqLi43EE3j91TicQtHiqZLOjpbrM15HkKmxPUAIg6fBm
         U7ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/+sJZZbZo2UcO+Nr8+QxFylA7K/BaXAtaD89aBd6sd0=;
        fh=We3dBG+p47xMKlUUkYbmGnwdf6xOZjgbvYSwmkpFONo=;
        b=rvvWp3ovBqq/kVkvhlOGd8pUpleQCUfSBw6hQ9fjMEON8SOKJavR/Ul/tXnuvO2exC
         uVZUaF1Lj3YM1Dy4LbNy5eH5tK6ZLs4kYLsLPbQYZQnFGQiVSCeBkr1pqSBNvehq6nFm
         OAgDKGnUr8eY1kaBauWTU+XOhI4f5NgfvqnVZ/kckEj4MriJxte3F2IqcC10wWJzLlwv
         nP2YoMW9fnxgz0u8o3kEuuoAHiXhnMI3ZJxkb0WS/ZhwU0CX35gqiUzz+VLlJJoTS5qd
         LCSfIH3XF9Rz86LjwDutB+lzxqCN8zxx6293Ht90WlOVpA6/JJcxbUwbxfx547T0/cjI
         Kk2A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794441660; x=1795046460; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/+sJZZbZo2UcO+Nr8+QxFylA7K/BaXAtaD89aBd6sd0=;
        b=WHyXxKf8TpM8zg9Xi6sBF3Q/GcDrF34lmM+8jM/MHKh23FlvLWuOckkpFRzHDtoD8Q
         4orWvmOM7JdOjanxHLMnlQzPULGpJXqSeGJtoYbNmL05ng15A6HU3Dkf8VoLoC73yOFZ
         IiLkL5Fp/Hm1BujquX9/5LMJ0EiNiSvQG/s+av3Dl7BZuyA8ZUdzDu2IGPku4j2gVou4
         y0hUtuUNfT60sO2dutqwaFdrYihXcFrBAEFURC4IYuD6Pk+d5BEid7oT/alJXzO/sGN1
         wWMinN/XvW29V/4XJ0QRcMrMqRsF2sOUNbRYySSdwQfhxwLHlUrH9HBdx8Hg4SVv0SYC
         9dcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794441660; x=1795046460;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/+sJZZbZo2UcO+Nr8+QxFylA7K/BaXAtaD89aBd6sd0=;
        b=YhI7Tdi1NMOmMlgwkjjAcDb0x6zqPg+98hKxH6zWV41bXjuO58WJghHvuaLHeTfUQ9
         PMbTkuCVf+KvC3Ju7BPD6dcvJUo2bpSnBdfHlp+YuAMV1A8651ZGEuBg0oyiOCbcRnfy
         CqsAl5KIe7c5FXJjXDv4+nEnZxFXGBK5vYI7n2vgG6DJE4Fi53OKH4J3ssh2rqwDZ6zK
         VpLRDHwc0enQVJ3SHqrVcALtl7IqfWimtWyyMsN1Qkd0TvFv6VVWJm9f1TUbBhobyq7n
         GzFcMdPMFI/2Q6+l9xvaZmD5rgrFe3h1y2k2ZKb0Ijn65u2XbZBzSWloEfN9ItnTiU1C
         tLaA==
X-Forwarded-Encrypted: i=1; AL+hErHWe1x9tjVUMeaP+0ojRBxZ+aSO6d2jtiFc6H9F9a4nFXKKWUUQBLo8a2fQhgOeulipAbJPWzonjg==@kvack.org
X-Gm-Message-State: APuU4Z/f7Mr/Iq/yD00mfivytu+2B/kVzSF8kkUEfNAwsKqE/1p9t1Ci
	KGcRyepTzCDxcNWGAmn/LFTRBo0sxUxEk+vTVRLRNoqdE936Q48NQRy4MbJYgTdhaLBh88YT05N
	d5YNhTISm4HLqTRM94kMF5lBJg+n3jtc3rVP6ULvE
X-Gm-Gg: AYBFou0xlhiASJpJhr+3Ge3otgQ0aCCf3TAOM1brnCcQZjYqHN2fwW6z0YU3n+pNb/r
	G8/cC11dVwfthk4MaD8VFfrDXk609tjIxacCS0c1rjWa+q9vod1/tdVcxMNmfwUq31LV3E0z1yh
	W56SzxOcvtrMcB0wOA47GmGAzXJVR3sbnxqRxg3kPxv5K+lnFZPKoOUc5UC9aqbaRUebeu+IFM8
	X1LUGXjTaVw22siHLCegBMBQfM7H6os/HNMnPQehr9zeC90IPaUcIsdXXQG688KUDqusO/RnMl8
	2wv3CjK0xp7FvN9QcIritI8KGOr+Xmn7KQFjOZaRjuI/I2EYjaNknfnJskDVTlNeuOnL7aeze5T
	Rl2VdX8m+Kte2spcSKaAVxRDE66M4E6EMj9ZCZwbbell+hFDYE54rBWKit7mVbxUCDA2sFXTGr4
	o7QPtxW3XpUXw5Hz1QLJ72h0eY2Q==
X-Received: by 2002:a05:622a:514c:b0:52f:8389:29e0 with SMTP id
 d75a77b69052e-5596742d03cmr7885161cf.0.1794441657704; Wed, 11 Nov 2026
 16:00:57 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110112546.261415-1-hao.ge@linux.dev> <20261110112546.261415-4-hao.ge@linux.dev>
 <f416f84a-03de-49fd-ab67-d86ed4dec633@linux.dev>
In-Reply-To: <f416f84a-03de-49fd-ab67-d86ed4dec633@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 12 Nov 2026 00:00:45 +0000
X-Gm-Features: AclHuK9BKDPw8mqltXLLAZPx2uW3RHH6cpnOYo4JgG_IF10oXVJ9B3sYkpkOZaI
Message-ID: <CAJuCfpEO6F5g43=uR=PmNmZwRXDzLjT_4CfE7UUZmt7iebgjfg@mail.gmail.com>
Subject: Re: [PATCH v4 3/9] mm/vmalloc: BUG_ON() on an unaligned range in vmap_range_noflush()
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Dmitry Vyukov <dvyukov@google.com>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Tejun Heo <tj@kernel.org>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@gentwo.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ioneis45ndujay7sdb1x9uhiw7thjpod
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 8B5461C000E
X-HE-Tag: 1794441660-273345
X-HE-Meta: U2FsdGVkX19hS/vNHydcGMkJPXt6d5k9oE+XLb3nEDPFSRSeTiMpNjF2BOQ4H7FnqPsngC8qpZvjaoZ+WZ32gV6kEAvBDqloKGxQLok5foNm7iFATAcn0UuVx7tQ/IA78H2fEtgIWgpAzTFn4uRuKbM+11eDK6Hq2VPOZmwh/i9qBIjflU2k2PF1l9MUQz3IvQctz8LftEP1EWKAdshJjyi94fqdIHI7T+5GQbYxNMMNkgF5XIA9WWBfPVZFrVZh6oBMr+BOO7rVFTNLMH4xOTgoGPOfYP7VebpJJ6WaEYAkh8HW0b2ohHG1R5QKSEGvmC/ZrKluAIUgpyCpqGM+EbsrPSHddOJzAAUGT6DZR67Sx4gMclLsk4x/YCx2G0FDlsCJnKPFqcx3PpxT31Ss4/+JKqPGU6ENErQEXX4eMd/tXQix8FsxpuFvxkBkqEi5CBhNgjucEdVtNbJFQpJ/lcrGzgysuhG+v8EZ9TMOwmmv7dJGHIP0e1QG7bjMBgeU54q9xkovA0ltqELP5lrSpNaXNMTgKLMWpsfkjDSU2FXsFVIk/Nv0ZdV3JoUlmMC6RWwtm/vtjwVCnFVcWnqgKxYDShvGdrwQH6n2zcYlQMJhfjjZ0cOiWcDbcZ8CTA85zO9wjZ2eYWn1dpenGzXSJKZ2MvuRR7tbIepXpQeBHoky6uJM/LzGffhAqWtAGpYoCaqecTv8bcl0F3rY+XKzBxckOgC0BL8XLD1686Gj8l7bepWvhS9hDJ0I0b/+le9Kb8+/sQcmUJHPNKgFBRLohC8OXGfJIg+bQMOJ1yvM6nAQwEcEXXBthfE2QHjTJ6ggsS/N+qaHWQE2Fk08rS/8mH6g4+jiwOw4gBrUTLpjp19cbUkzEwXBSVGg3w2V5jWctpUfhmm0Tn9NpfzXnUfXuif6VivX/rzS0gKryI8D+huiPKCy8X9z7mzkX8P4xdYFNXM9381vGf1eyk3FLVb
 flf69Dqw
 OwDoiHeyOZ1EsQn3twFGR0J+ESTcdk0qvQt2rVkGVd29+UQgKAwYYeQPit8K4clFAOOVBoC07LFfCdsc1p9CUpvaVxv+AivJ9HsERAOERbDFvlHaT5GfMG6q4ipm8tBKUf4lC3iRMR9zsRI0hziMot0d7iBSU2VprkDzjjo8Bx1YrNY/PmhrB+X2DUmUwVCtaphHXzwZb4smISvEnSZsxlbkhx/tQ4EQGrIdqP8bFNMSkNX4aDbmudA/Jhrouq7wbPXeAZBn7GgYhxTuL+CWt2V2blg0iNL+tuZa4HBgLYgO3IQIyRRI/pcZ+fQOGE+Jp8aEzUUpMTmG/OxXqQlrKo+c/IfAYWjG1PyBGi4Efmg9rUkk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 12:26=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
>
>
> On 2026/11/10 19:25, Hao Ge wrote:
> > commit a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not
> > PAGE_SIZE aligned") put the check in vmap_pte_range(), which is too
> > late, because the upper levels may already have installed page
> > tables for a range that is rejected anyway.
> >
> > The pte loop maps whole pages and stops only when addr lands
> > exactly on end.  An unaligned end lets addr jump over it and the
> > loop keeps mapping past the range.  An unaligned start maps the
> > page below the range and usually misses end too.  Such a range is
> > never a legitimate request, and the corruption it leaves behind is
> > hard to attribute to the caller afterwards, so bug out on addr and
> > end at the entry of vmap_range_noflush() and drop the check from
> > vmap_pte_range().
> >
> > Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > ---
> >  mm/vmalloc.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 093b8d5f7b0e..27f2674a5556 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -125,9 +125,6 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long=
 addr, unsigned long end,
> >       unsigned long size;
> >       unsigned int nr_pages;
> >
> > -     if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
> > -             return -EINVAL;
> > -
> >       pfn =3D phys_addr >> PAGE_SHIFT;
> >       pte =3D pte_alloc_kernel_track(pmd, addr, mask);
> >       if (!pte)
> > @@ -347,6 +344,7 @@ static int vmap_range_noflush(unsigned long addr, u=
nsigned long end,
> >        */
> >       might_sleep();
> >       BUG_ON(addr >=3D end);
> > +     BUG_ON(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end));
>
> I know BUG_ON() is ugly and it was not my first choice either, but I
> have not figured out a better way to handle __vunmap_range_noflush().
>
> If an unaligned range is passed to it, the pte loop may clear PTEs
> adjacent to the range. Say a caller passes [3, 12) while [0, 3)
> belongs to somebody else. The loop operates on whole pages, so it
> starts at the page containing 3 and clears [0, 3) with it. That
> silently corrupts a live mapping, and the corruption is not detected
> until the owner touches the page. Bugs like that are nearly
> impossible to debug afterwards.
>
> It is not feasible for __vunmap_range_noflush() to just return an
> invalid-argument error upfront. Its job is to clear PTEs, and an
> early return leaves the residual PTEs behind.
>
> I also thought about warning and returning -EINVAL on the map side
> and keeping BUG_ON() only in __vunmap_range_noflush(), but the
> rollback kills that idea.
>
> int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>                 pgprot_t prot, struct page **pages, unsigned int page_shi=
ft,
>                 gfp_t gfp_mask)
> {
>         int err;
>
>         if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
>                 return -EINVAL;
>
>         if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
>                 page_shift =3D PAGE_SHIFT;
>
>         err =3D vmap_pages_range_noflush_walk(addr, end, prot, pages, pag=
e_shift);
>
>         /* Undo the PTEs installed before the failure. */
>         if (err)
>                 __vunmap_range_noflush(addr, end,
>                                        gfpflags_allow_blocking(gfp_mask))=
;
>
>         return err;
> }
>
> If the walk WARNs and returns -EINVAL for a bad range, the undo
> above passes that same range to __vunmap_range_noflush(), and we
> BUG right after the WARN. vmap_page_range() runs into the same
> thing on its error path.
>
> So the map side cannot warn while the unmap side BUGs, the rollback
> drags the rejected range into the unmap anyway. And the unmap side
> cannot warn and skip either, that leaves the stale PTEs.
>
> Also, these checks are the last line of defense. All in-tree callers
> pass page aligned, non-empty ranges, and I am not aware of anyone ever
> hitting this line. So for correct code the BUG_ON never fires at all,
> no user will ever see it. The only one who can trip it is the developer
> who just passed the bad range, and for him a stack trace right at the
> spot is much better than chasing a silent corruption afterwards.
>
> I settled on BUG_ON here. It may not be an ideal solution, but if anyone
> has a better idea or alternative approach, please let me know.
> I would greatly appreciate it.

I don't see a better way to handle this situation but I would add a
WARN_ON_ONCE() alignment check at the beginning of vmap_page_range()
too because it is used in some of the exported functions like
ioremap_page() and pci_remap_iospace(). If someone passes an unaliged
address to these functions your change would turn a warning+function
failure into a panic.

>
> Thanks
> Best Regards
> Hao
>
> >
> >       start =3D addr;
> >       pgd =3D pgd_offset_k(addr);

