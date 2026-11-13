Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9EC1606A335
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q1dIthbF
Received: by kanga.kvack.org (Postfix)
	id 057856B0677; Fri, 13 Nov 2026 07:44:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030376B0678; Fri, 13 Nov 2026 07:44:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E88706B0679; Fri, 13 Nov 2026 07:44:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA6156B0677
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:44:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B3C3140111
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:44:49 +0000 (UTC)
X-FDA: 85430065098.19.0B37F99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 37EF9180006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:44:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1dIthbF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794573887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qP1fDgmD+0/GNcLr7ZQxR1eYEZJ6oOSkEBBpvgi4B/E=;
	b=dxlAZx9i7BpGSwDRnM5z+Gg/udrEdxOpAOa1aDqxM3p82H9ZyNL4i6MEqkMXXmChOB5hPZ
	bF1sezqHfdrN7X5WVmo6zMJMIGeIU+pCkLI0AReLFjBn9/HPzZApAwYFrUc/w5uQS/2j/u
	ga//pNjIXDvKS86J3zpPCOzzDjxpffQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1dIthbF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794573887;
	b=7jv/OzIe1TeQiiQ8f3oo/S9RKdFM7eTilCtcGVXItZwCfQ1GjgjC/LGHsIPNhvFpbXj85M
	t4SlYIqN72kLgubzvk2AsVvOXs5PT+t+jULzXtBaHtdnWsV2GWa3FEuaGYdpFVvqAQ/Bv+
	R1PNSE6XK7H8obMmRj4bSC81g1XYdQg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0D0061868;
	Fri, 13 Nov 2026 12:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266D21F000C5;
	Fri, 13 Nov 2026 12:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794573886;
	bh=qP1fDgmD+0/GNcLr7ZQxR1eYEZJ6oOSkEBBpvgi4B/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q1dIthbF1Us3wtLOgQOJO9MrKtvVJgOwVtJluXfSpNZ3IF63ueVZcKqashkrRMrw2
	 OFZZNcStDc261OUlqFKqpIb2IiCXceYapcPfelPG19FfPq7npnhss/qVe556j+i9mN
	 4ognTX+/9evNh7r6yKeeYOueoACcTTcj+4Y058vz/Et872/gBjXulE8DKnW61zb3/c
	 +/aQRp0XF0vEParschWpthtLXe/NwJyOY5rLjQIP2KIBtNySXXVehkBiFpfVc/LvCE
	 p/bOw1OrclFGH/FxF6xuUmxBGiODh+sTWYb76fuXh3jTwt1/592urWdiwg0nbJqU/6
	 6nUWpCrK5qe/Q==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 990FA198003A;
	Fri, 13 Nov 2026 07:44:40 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 13 Nov 2026 07:44:43 -0500
X-ME-Sender: <xms:OAb3aj9wtmg3oXt63DlqdvAHyCeduo4TT0vPS9dBk0N69Asxbni-Fw>
    <xme:OAb3atUfOuh2DdP_XoYdkVNGkNvu009-5CFJNOqT3ERkjxPKAWdzAgBF51VBYmVHj
    f29MTsUpSwIkAivcRbe33UC7sKLR6HEZ02BZC7DtSai5_QiPGYllw>
X-ME-Received: <xmr:OAb3aoZ97faUwvbhIguHKon_mjXW4u9xKxFNc4MgpbfEJhR-7g_IaP5XRmI>
X-ME-Proxy-Cause: dmFkZTGp90hbmu9g2nv6Qpwl0ey2IoaItGc4CUAeqGv1xSwtx27bHHgLe816J6e2LwkW+M
    Oqhe4ZnrU5jWuzElELI8JAakEw8ONWTGPSM843dswrFPae6cLUFc8OnNdE5Wy8p/rfSGUb
    RdyPlZOnd0QOFvDFxSZ+Q7sXbMqc8z+f6lgqMMNOzwTx2oup4TZ5JPMLFbpyY0bFkvCUs9
    yx7qZMcgICL9TwSRYVzqEnTCNsKGb1LfBaPc4WMNzwWwCwXztqY4tWSjIwjO756oFybA2m
    wWRg4frOGH7VKyi9cmvO0C/sBS39CRAuyoEXV83pS6BWp5427weow0xhtHCOzoEuBraMZS
    PWs+JxnWGRyRFQASl+avgvDVS/tEynB2Zk+FuBD9RySJZqNCh3tP2TzAcCB8z7J0yN7DRR
    8jBLcsxTM07Hh9YkbJgGvnngbF+qgLYIKhTFbumw280ufWA/XPpwIdq+sgom4Q/7IHN8Em
    XIjd6ZqgKzKma3NGOxFgw8O2gGOlqlj3JMUZHe1TEv0VXFVefvlhoorPiyIge/G4WhVwqP
    P80h31eExz+rnliKV6X+7K3gKv1TfSFW6Kd2MIkyCJUoo13NU2Ei1eDA5TobE6MUDf6lv/
    4LOFK5uUR1px9ego6rPeurQzEjwdvj8j/uyJeHj12LgJ6tUjY/Im3sjQTVQA
X-ME-Proxy: <xmx:OAb3anqilD-3ObX7OhGkDhwPse2A97PzhEtdh4itOqRMv0pmR6kGAg>
    <xmx:OAb3av6BojrlFLQ87tKmMEscosazzjnyYPIbUCNvJKoItY0SltER7A>
    <xmx:OAb3ahUOs_XLDSGHYPAIa1gdlHy6kkl2pLyl2w-Bn8npHKMHIv5vkg>
    <xmx:OAb3atsnHrgXjGYqrBUWUK0BEyd-A5pJPA05K5CE3frAOORU3uxDfA>
    <xmx:OAb3amrW3uFWGlLwc1CgZ28jgwuYLszfIgsg-kUiyzbvsXIg2nhopg7J>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Nov 2026 07:44:39 -0500 (EST)
Date: Fri, 13 Nov 2026 12:44:38 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Peter Xu <peterx@redhat.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Documentation/userfaultfd: document RWP behavior when
 the PTE is dropped
Message-ID: <avcCRLX7unFGeaHf@thinkstation>
References: <20261113112806.109578-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261113112806.109578-1-azpijr@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 37EF9180006
X-Stat-Signature: oos1rzap73cp3mug7x7au6ynb66bsy44
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794573887-579073
X-HE-Meta: U2FsdGVkX18kecAg/mzXG/5WJZpHqiUPhrAJjQ9pzZ9s0cWNJkolIW8vFTi1+JJTQV/8aEib5WQ8UGenAFP6HnguNMMui+rR8WtsCEqsdc4v+3C0CaeiS3ANIZgg2/7mAUah8lsb3oppGdxQ4HsE3h1uBmjMvh5aBiYWO1MpFQCrp2UndDtXCXmPw6EVLHrhInOJ8kST+KEr70ZWPL1ghu3MUI9t/+FFZycu2ZM+DbzQl5IUM5OUuxBIUX8y3Xo0ywq8O3Ly51mlixkgpiH8AdAHiavUD986Xf8/ntJGRTHvTjpMXACRhOYcMXMIiq1Jsw+vqF5jTLtYiM05TmMum8wXhlomN+v2Xv4AOi7n4wYzy0oAkz1RSjkhuoB2A5q3okLr3DmUyYbqGPAfB3M+08sQOd07IUKYLcfj9Jt34yhUj+u6LPH30JU/x4UDVA5E+RBPRcBniClVh5syRLackgmr0LDnnIyMQoVlCyIwHT44ET2vy5w2kje0Bu9aR0R9JB2XVFT2L6g924Up706RUh/kevOp27aj8H8/C70x+zvRgCCRm+JB6AWxHDTKOVpB+EdsaqXg3QdsTX/P8JgCyZWK7H2h4UopaUKbyrh2VH2BLJ3aTB2GmEg+H9LLfGTMwFh1+ffvG9grdBN1mHD2GfgsnifxWDhcgj9SPJ+7ellhR6V4qR4lk9lnHoFL1HKrQ15fDTKZl73vRc9dBvwiE2Ir2oQhUhZ7AItPhFpA6CYe9lq0ErMYlP1FmRsv/9Oh3jYG2DrMU8WKcG92NwRH/6w/1m0zuVMnZbRfIv+TQv3xWB8S+Adl7Ye8YLK3ypeS1kYE/1TgVfBcrHx8MByZ/DVDomgYkTQmMcEHJWHIPg+iL7h514Ct3apSzRQ7bvhMYW0WGXkkiyZhHjHz+SSj1oIt7mJRjNuw31DYxQ06rKwjQHKBXb5Thlalg4yh6j7LBiJtQOtB/o16OfabIUF
 bYWsow48
 tfNqLephfKJKxZ8OiiNEWH1MFL3hDmP6CUGcq4iJXAm7nNjB0UQhNwGfdRMh0gbxO/VtLMOFgu86NJRmM8mv9hP7R3G1z2ihcACRbj4BCcwqd7htli2RNJjymZV5Zc/OQnH9rsvO7+kexuIOiFAMAQfubgfur3TjYMZojTh2KAKxoFWX0WpBrqTMC3u+GpEysfeKkeBudWmQToT+5Vl5GSpA7PvO3VbH6pHq6abNw6OG0UZKQhOfke+1voH5jFelu1WwQ4Yyn/pWyDBtdYl9QmEMDgqNEYDDjjPhT6EInLuNRmEqGGEIpqF7KX+i1PgodnAqZ0s+mobU4djUZ48TOdKpc2I0IWZVj/ujF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 12:27:42PM +0100, Jose A. Perez de Azpillaga wrote:
> "Scope of protection" lists only the PTE drops requested by the user and
> says the range has to be re-armed afterwards. On shmem the kernel drops
> the PTE as well (page reclaim, collapse), and RWP has no marker by design:
> the next access is a minor or a missing fault, and the user is expected to
> register for those. Document this, together with the modes that sync and
> async tracking need.
> 
> The VMM example registers guest_mem with RWP and MISSING only, so a vCPU
> write to an offset that is not mapped there can be lost during eviction.
> Add MINOR to the registration and describe how the handler treats minor
> faults.
> 
> Link: https://lore.kernel.org/linux-mm/856cdf21-7982-475a-b244-a7ceff4eb6aa@kernel.org/
> Link: https://lore.kernel.org/linux-mm/avWnaR7VVEGa7yNp@thinkstation/
> Suggested-by: Tal Zussman <tz2294@columbia.edu>
> Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> ---
> this is the first time I'm writing documentation, so I accept any
> suggestions to improve it :) and I tried to follow the documentation's
> own style.
> 
>  Documentation/admin-guide/mm/userfaultfd.rst | 65 ++++++++++++++++----
>  1 file changed, 53 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/userfaultfd.rst b/Documentation/admin-guide/mm/userfaultfd.rst
> index 97daea83b7f1..19bdac668f93 100644
> --- a/Documentation/admin-guide/mm/userfaultfd.rst
> +++ b/Documentation/admin-guide/mm/userfaultfd.rst
> @@ -384,17 +384,45 @@ normal missing path (``do_anonymous_page()``, ``do_swap_page()``,
>  the population itself, co-register the range with
>  ``UFFDIO_REGISTER_MODE_MISSING``.
>  
> -Protection is preserved across page reclaim: a page swapped out while
> -RWP-protected carries the marker on its swap entry, and swap-in restores
> -the PROT_NONE state so the first access after swap-in still faults. The
> -same applies to pages temporarily replaced by migration entries.
> -
> -Operations that drop the PTE entirely — ``MADV_DONTNEED`` on anonymous
> -memory, hole-punch on shmem, truncation of a file mapping — also drop the
> -RWP marker: the next access re-populates the range without protection.
> -Unlike WP (which persists via ``PTE_MARKER_UFFD_WP``), there is no
> -persistent RWP marker today. The user needs to re-arm the range with
> -``UFFDIO_RWPROTECT`` after any operation that explicitly frees PTEs.
> +Protection of anonymous memory is preserved across page reclaim: a page
> +swapped out while RWP-protected carries the marker on its swap entry, and
> +swap-in restores the PROT_NONE state so the first access after swap-in
> +still faults. The same applies to pages temporarily replaced by migration
> +entries. Shmem is different: reclaiming a shmem page leaves the PTE empty
> +rather than installing a swap entry, so the protection is dropped along
> +with the PTE.

Migration is not anon-only: migration entries carry the uffd bit for
shmem and hugetlbfs too. Keep that sentence out of the anon part.

And please call it the uffd bit, not the marker. "Carries the marker"
next to "there is no persistent RWP marker" reads as a contradiction.

> +Operations that drop the PTE entirely also drop the RWP protection. Some
> +are requested by the user — ``MADV_DONTNEED``, hole-punch on shmem,
> +truncation of a file mapping — and some are initiated by the kernel on
> +shmem: page reclaim, and collapse into a huge page by khugepaged or
> +``MADV_COLLAPSE``.

I would not list them. The list is not complete: splitting a PMD mapping
of a shmem THP drops it too. The next tool will find the path that is
missing and report it. State the rule instead: on shmem the kernel can
drop the PTE at any time while the page stays in the page cache or swap.
Reclaim and collapse are examples.

> Unlike WP (which persists via ``PTE_MARKER_UFFD_WP``),
> +there is no persistent RWP marker, and this is intentional: once the PTE is
> +gone, the next access takes a page fault that userfaultfd can deliver, and
> +that fault is the notification. Which fault it is depends on what happened
> +to the page:
> +
> +- The page is still in the page cache or in swap: the access is a minor
> +  fault, delivered if the range is co-registered with
> +  ``UFFDIO_REGISTER_MODE_MINOR``.
> +
> +- The page is gone: the access is a missing fault, delivered if the range
> +  is co-registered with ``UFFDIO_REGISTER_MODE_MISSING``.
> +
> +WP cannot use the same scheme — a minor fault would trap reads as well as
> +writes — which is why it needs a marker.
> +
> +Without the matching mode the page is mapped back silently and without
> +protection, so what to co-register depends on the tracking mode:
> +
> +- Sync mode: the access would be lost. Co-register shmem and hugetlbfs
> +  ranges with ``UFFDIO_REGISTER_MODE_MINOR`` (and
> +  ``UFFDIO_REGISTER_MODE_MISSING`` if the file can have holes), and
> +  anonymous ranges, where minor faults are not available, with
> +  ``UFFDIO_REGISTER_MODE_MISSING``.
> +
> +- Async mode: neither is needed. A page faulted back in is mapped without
> +  the uffd bit, so ``PAGEMAP_SCAN`` reports it as accessed.

The registration is fixed, the mode is not. A context that switches to
sync with UFFDIO_SET_MODE, as the example does, needs the sync
registration. That has a cost in async mode: minor faults are always
synchronous, so "async -- no vCPU stalls" in step 1 is no longer true.

Getting it back would need MINOR to follow UFFDIO_SET_MODE: in async
mode, map the page and let the next scan report it as accessed. That
could be a future project if the stalls turn out to matter. For this
patch, just fix the comment.

>  **Fault Handling:**
>  
> @@ -486,10 +514,16 @@ never traps on its own ::
>      ioctl(uffd, UFFDIO_API, &api);
>      if (!(api.features & UFFD_FEATURE_RWP))
>          /* RWP unavailable on this kernel/arch -- fall back. */
> +    /*
> +     * MINOR: an offset in the page cache but not mapped in guest_mem
> +     * would be mapped back without a fault, and a vCPU write between
> +     * the pwrite() and the hole punch in step 4 would be lost.
> +     */

Not yours, but the "if (!(api.features & UFFD_FEATURE_RWP))" has only a
comment as its body, so UFFDIO_REGISTER becomes the body. A second
comment between them makes that harder to see.

Adding {} around the body comment of the branch can help a bit.

>      ioctl(uffd, UFFDIO_REGISTER, &(struct uffdio_register){
>          .range = { guest_mem, guest_size },
>          .mode = UFFDIO_REGISTER_MODE_RWP |
> -                UFFDIO_REGISTER_MODE_MISSING,
> +                UFFDIO_REGISTER_MODE_MISSING |
> +                UFFDIO_REGISTER_MODE_MINOR,
>      });
>  
>      /* Tracking loop */
> @@ -550,6 +584,13 @@ progress. After ``fallocate()`` punches the page out and ``UFFDIO_WAKE``
>  fires, the vCPU retries the access, faults as ``MISSING``, and the
>  handler resolves it with ``UFFDIO_COPY`` from storage.
>  
> +The same holds for an offset being evicted that is not mapped in
> +``guest_mem``, except that the vCPU blocks with a
> +``UFFD_PAGEFAULT_FLAG_MINOR`` fault, which the handler leaves pending until
> +the page has been punched out. Minor faults on any other offset are
> +resolved with ``UFFDIO_CONTINUE``: the page is mapped without RWP
> +protection, so the next scan reports it as accessed.

"Any other offset" is too broad. A cold offset that step 4 has not
reached yet will still be written out and punched. If the handler maps
it with UFFDIO_CONTINUE, a vCPU write between the pwrite() and the punch
is lost. That is the case MINOR was added for. A fault on any offset
this pass will evict has to wait until that offset is punched. The same
goes for RWP faults.


-- 
  Kiryl Shutsemau / Kirill A. Shutemov

