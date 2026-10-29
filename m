Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEAD0606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 12:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CF19qMil
Received: by kanga.kvack.org (Postfix)
	id D61E96B00EF; Thu, 29 Oct 2026 08:52:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D12D56B05B1; Thu, 29 Oct 2026 08:52:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDB276B05B2; Thu, 29 Oct 2026 08:52:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 93C996B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:52:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8DC71120385
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:52:45 +0000 (UTC)
X-FDA: 85375653090.20.15AB2FA
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id A7FEB100009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:52:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=CF19qMil;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793278363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zf2xViTkAeLxB49iEkeFNan7sx9Snfm1yj/XBegFK/Q=;
	b=Kmz1yhmwi95zqj2UJv9l2b+61PYdUZZoyxAF5vf2gEAfEcCkXKbj7fnFBMyJsecKsck4cf
	eceg4HvYX74qYsRM4SQ9XqZ7ueoPM0mUYSnEvJHZbpq3kZ20iKxsIETWDuFUmi9ZcA6Tiw
	dOvdnnaVrVBT2SsMU1En04CuAYnrutc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=CF19qMil;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793278363;
	b=e5rqzehYB4sRAGGxEXTzuOI1Q0refZHpcs20OYhsCLSF1tO0pzkktrv8LMCiBU/sKQPkMY
	fP/IQL4xPY/o6Rg9m+EWQhxXsG76uDL0uCM4vVuNA3srBcM/ihu8xBNyFDxb0NBWOnpxZk
	Qn28xIMPY9gumK+kKgiyDBz0uVNwSbU=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-917a707f37eso20303236d6.0
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:52:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793278363; cv=none;
        d=google.com; s=arc-20260327;
        b=GwCe/KPcpL/Ozdg4s455hFtBl4el0h/+U+NWRFKbVsIcCIAPgJnVglmXYp10XyevZ1
         I8Cw7yccllw86d/GBmpPgNSehZyaPQXklr/JsKBl3Juocef8kBNCr0lothB95ZUpEBfr
         EISZOa01dzr4PR9LKKLb4Ek8/gTkhSQD1R152z0iJH++tgEI2bErMoY5JsCuEt3xDOkp
         q95ZdZphChHobm1YLl/eATZMZgZsD8qOdIXEAt6dti2GUAG/K5pGQWn4/DydGI6DasNc
         goCeNz+SzJU1KxqlPewZoF1gGGMWl/SDS3Fj5rf1IT6eEp6Ctfr8XfjtOfQWcW/pcTQ1
         s8kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=zf2xViTkAeLxB49iEkeFNan7sx9Snfm1yj/XBegFK/Q=;
        fh=RqgwBFkr0WBoRtXiXWJgWKx+2HYbZ1VrDG/hOv5eibI=;
        b=sNlMXgf7koCxfGsyb3x7B3aiYkPCdTvb+182Z4KWq1r2oXsLJQuAX3z2dMFAAGf2XY
         UkV6pBD+6QR/ND2sh/gPyfcLZ2nUGuUVsYwJzHF3BA3ey7ccMCML95661N/7ayPsnpPV
         9xDQxl8WnGIMtX4mDaN881DupZg8LxempsSJUwyyADGE8xeay4tO7cvCyNge12R4QLfB
         hR32aQ1K6jxBsgsvhO40o+H+eMSdj5eQmkIRMRGYi+zSC4/nXE8di1pH5oBKpwyVhsAp
         mq2rWgBBM34kqVNuwLoVgaIgB9nIGvpT9PjrHPZ5ppMnQVX1ggfTlfegmZbXcorpkTGQ
         EOhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793278363; x=1793883163; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zf2xViTkAeLxB49iEkeFNan7sx9Snfm1yj/XBegFK/Q=;
        b=CF19qMilmJZTcbD+5fn78p2WtFF2iPGy4ilIqR9c+SiFY+qi7mE2BA/NSKHS0jshH1
         gSNdrN0fcawksIvwWs9SGqxOwZ0Qcg/RME92YXhBeD/Sxuf3Ia8e+x2+pOn43Po/fVON
         ecZv6xnJcCI35rKschj2mA2oyLUNj7TwMQJ+VNtt+C2Sl0fNEzb01R+p6Sw4Zb5PqYwT
         enCdH+irdJ7t/C4B1PNbUUy7ndzVWOKQuRk2Kiw3zOpsx5ogJzO1FyHuP0EX+zMiJKpw
         R6dxKAe65s8TW9JRi/34ItBlydev6v+k7JrnemJRzAlgwlzaQ5JBnwI9iauvV3tC28rj
         SaQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793278363; x=1793883163;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zf2xViTkAeLxB49iEkeFNan7sx9Snfm1yj/XBegFK/Q=;
        b=PR+W9clcmvudCCm9ESnlndsdBDHu11ZTFnkpIqE9/+sQCum5Elo7aLpNkssVPOjyXG
         YXy2N+MPy7ePqQyRqGPgODk8Qw8dpDeZBpA8UipvDRWceKRqUqbDgDVNJVPcmd7O+l1p
         W9HOSqCaUboZN605izN/DKpyekfev6IOmeDD2LSw/89xFBJDW49cO2+5QR9JEqun+/zz
         fhexXbO59qOsroCYLwKjNFaOSkFPH3U6LsDJ+rr0hrrbtfoVvb+3gtsAjpHZrTq1aQXw
         RJHUl9qL/3PFhrCN5G+nxB5MuhAIcfEiD8KVCeZ82oQGwGaRHZYr1MkFCwyNZWYm/W9y
         S2Xg==
X-Forwarded-Encrypted: i=1; AKwUvBzJmUmrGiKAImMfPjWyjFe2tcV3od8dasDmlcn81ueQg1YMaM3ikE1NmtEUngJeaPxjJ/Y6xYuQDQ==@kvack.org
X-Gm-Message-State: AFq9FYLFDW2wB0wEOX+MvzlSBxpY1TSytCV5y+onDD5wT8fpdxipk0Wj
	2ZbWbd++xNZyX6bzrbdB+IR9pipjTMF25UwNMuvtv4jaUShBATFFdUUISbLlXo+PhnKwaNF/YD4
	r1SmyzW/M547M/BQikcE5QOBoaw6D2a1yKW27MORf
X-Gm-Gg: AYBFou3C6neGqDkCTrVoHfdfJMDpvB2VftFXN2REvbcAvTpkzdSeg6rVi/cxSnmN5pT
	APJgaVBBxxBIq1zGDIyQTIQadYGa4TAMQg4LcnvpBHh30aWE6wL5vP6fRzy8jtR6dRXbdmNGEPz
	SJGoabcuzNjB827teYWzzJfIW3DAsJYhVIo8L4ho36R1LXkWug0TXfpKy02x5aEo/PpzqtT2Yct
	rQOXRYsgNVlmssOSxZCd9wcov0V5HZU06TYbKeqpXb8mEpucT53VHFoRs39LoLci62xCzj0KwRy
	32iRvtUs+1ZiGkRmhAYTuKwe4PFczYGeTNc2Kv4cgF0/SqlThU7NVIPfHXP2lkfwsG7ChNUnWB0
	MuB45v3uVOKWL7djWVJWw5zwce2x7IVzm5pEooXlADiiMQplv1L5ShYoccrkQVRuRrQ==
X-Received: by 2002:ad4:5747:0:b0:91b:9496:6a18 with SMTP id
 6a1803df08f44-91c7d1ae53bmr83041376d6.37.1793278361370; Thu, 29 Oct 2026
 05:52:41 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 29 Oct 2026 05:52:40 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20261027154649.91571-12-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com> <20261027154649.91571-12-griffoul@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Thu, 29 Oct 2026 05:52:40 -0700
X-Gm-Features: AclHuK85LBuCmtDdaaOWg4OEyIMQUVa8mDtLyPY6JdCBNPTut6N07RXjZEiRQWQ
Message-ID: <CAEvNRgGn09qrCZjUM5sdqQohPWE62GN4c52iK7ZV_gi5wro_Ww@mail.gmail.com>
Subject: Re: [RFC PATCH 11/14] KVM: guest_memfd: Add kvm_gmem_restore() for
 PFN mode providers
To: Fred Griffoul <griffoul@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>
Cc: Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.de>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Kardashevskiy <aik@amd.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, 
	Ashish Kalra <ashish.kalra@amd.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Baolu Lu <baolu.lu@linux.intel.com>, Bill Wendling <morbo@google.com>, 
	Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christian Brauner <brauner@kernel.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Connor Williamson <connordw@amazon.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@kernel.org>, 
	David Rientjes <rientjes@google.com>, David Woodhouse <dwmw2@infradead.org>, 
	Erdem Aktas <erdemaktas@google.com>, Frank van der Linden <fvdl@google.com>, 
	Gregory Price <gourry@gourry.net>, "H . Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>, 
	Ingo Molnar <mingo@redhat.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	James Houghton <jthoughton@google.com>, Jan Kara <jack@suse.cz>, Jianxiong Gao <jxgao@google.com>, 
	Joerg Roedel <joro@8bytes.org>, Joey Gouly <joey.gouly@arm.com>, 
	John Starks <John.Starks@microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
	Justin Stitt <justinstitt@google.com>, Lorenzo Stoakes <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Michael Roth <michael.roth@amd.com>, Mike Rapoport <rppt@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolin Chen <nicolinc@nvidia.com>, Oliver Upton <oupton@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Robin Murphy <robin.murphy@arm.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <shuah@kernel.org>, Steffen Eiden <seiden@linux.ibm.com>, 
	Steven Price <steven.price@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Tarun Sahu <tarunsahu@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Tycho Andersen <tycho@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
	Xu Yilun <yilun.xu@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org, 
	Shuah Khan <skhan@linuxfoundation.org>, Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, llvm@lists.linux.dev, iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A7FEB100009
X-Stat-Signature: 5qsworki4skubtifnrxi6jdbebhn4imh
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793278363-698919
X-HE-Meta: U2FsdGVkX1/APlZ6KDQNdLG5bjfkXX7OE/0DdxtHeIPTH8qQE6r564zWw2tTT3iEB2uEfohZ0+1wafVgOR+9aTKr6ua1V7iQf5qXHawvCBrjrvYKOysQ/UnQ1hxIxDlVFkvRXnrOZ/K8onW9NojHO7scdif54aR0rCvtZqdHcgesJUlhsHcwQi732bAchwV1zijOpFsAZGbPvAPDOp8oQPkhGyra7ObssyIh0KK0OT5vGMcXFwPOrU5WVA6YzO19rJSR6Dc8cpJaQtuK8UNGUq6CgxPKpjtifP6P75IZJhSyqSZbnrApgDLeI536eZjpoEVZ20ehNbHsf4/F/08YQtqmGBfxIsULBRxUOZVDWWSPq3ZSBGf2TXs1zSxJlaZsCZ7WUcGWNUJ9zyohb0hXuNtX2SFTzxhePG0P0JJZLy8EWK4eK3Ao/EW80GCf1b/F/aDgXVVSr/eWQ5i0KcXIhsaofPX36MR9wL3qpppY82yRGSmaOtEn8vZncJK/w8agMcpECoX3mFUR/pB77HHyy/t+gBdFXkK/E5dN43GlaeR9YP0DxueHiOmY1uHTbroV//wyFzeNEEXWD0RgnCjS5m02Y7stNcUM9ZlCOZlKLnrj0P1kGabvuFsqpnDLwC3bX/eHWN1SmbLd3Ir07z/5wCzU7f7fer8R1Hnu3lVzv0x+2fw7DgGnDCf32Rm2ms3Da0hE8J12XsRDcVzzYuuclGGcwM8jqpyQAKsiqXBYsTAuLS+0gyUObe2U4DGjlPngJp/pkfXZWSczoYmefLDgmZFKnoOK0d9kXWJo/pYjIfuVq5G0ME5jFTf63kiPjXoFHIAbujUYc5NQGyLvQhfSPrg4vmvS3Z0nJXsE2VIODdIP9gXDu6FgpyWCUI8GZ0QxSayQNQfzGeiSkHaLpZnUaSJR3P0jT/reIpkRlJEq34FY250JlDG5TZ1iuCfUy+44CNwAC9ksaR9FUCenfVn
 rB/3MTNB
 2YXnvyBg2+oi0gZq+7B1QYVlJ2rMJ69iym36b8jHcLtlVua3ULFRfXA0F2jhjAG4/2CZGi/sHFZ76xdOv3MdEMrxz3g72AHpky2XDMoCvIhATMcfDBD5hlB+h5fys19IfW9nAZmL6TlFkcqBTzD7g112/ota85JglYrx3TYhWOFXAg751j++BqagkndRnSgqOUs0B51kLA5wRP3RRAO68XrQBPz9a7PESsR5cOkJ/0NBiCSkHXoJ+DKg/pZSHzY479Kaqv4RFm61Bn9UVL0+KtRugjYk/7OFcWXTXTFJqv5yw0FxCQwehvJjcJQQ4OsNY4xFlf9wbj3n+/AVOw52V92pZa69SchC6AG3TXpU2an0P65/mZOFSX3erie8llbDnf0KGidKbvYYZW7AcERzU4z60I1OGXzm/vn2xaI3CEtI5vf6K30OhwfOkLVMmTMyfMeJpMkn6GIDUIZCtprd7RuBXMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fred Griffoul <griffoul@gmail.com> writes:

> From: Fred Griffoul <fgriffo@amazon.co.uk>
>
> A device cannot fault, so when a PFN mode provider gives frames to pages
> that had none, or makes a read-only frame writable, a subsystem that
> maps the file must be told.

Totally makes sense that guest_memfd needs a way to actively map pages
into the IOMMU page tables, rather than passively like for userspace
page tables and stage 2 page tables.

When the memory is owned by guest_memfd, on a to-shared conversion,
guest_memfd would do the mapping for IOMMU, which can't handle faults
like Stage 2 or userspace page tables.

> kvm_gmem_revoke() does not fit: it would
> zap the guest's and the VMM's mappings and reclaim frames that a guest
> may already use.
>

I'd drop this paragraph from the commit message, kvm_gmem_revoke() is
the complete opposite and isn't a candidate at all for the goal, which
is to notify importers that a page is now available (and they can map it
in).

> Add kvm_gmem_restore(), the counterpart to kvm_gmem_revoke() that the
> sample provider leaves for users that cannot fault. It only updates the
> exports, under the shared invalidate lock.
>
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
> ---
>  arch/x86/kvm/Makefile       |  1 +
>  include/linux/guest_memfd.h | 37 ++++++++++++++++++++++---------------
>  virt/kvm/guest_memfd.c      | 35 +++++++++++++++++++++++++++++++++--
>  3 files changed, 56 insertions(+), 17 deletions(-)
>
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index 25fb3d6e2032..3255280884b5 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -63,6 +63,7 @@ exports_grep_trailer := --include='*.[ch]' -nrw $(srctree)/virt/kvm $(srctree)/a
>  				-e kvm_write_track_remove_gfn \
>  				-e kvm_file_to_kvm_fn \
>  				-e kvm_gmem_revoke \
> +				-e kvm_gmem_restore \

provider --1--> guest_memfd --2--> IOMMU

2 is definitely required, but why is 1 required?

Between the first .get_pfn() or .lookup_pfn_range() () and
.put_pfn_range() or kvm_gmem_revoke(), the provider should consider the
memory in-use by guest_memfd.

When it's in-use by guest_memfd, then guest_memfd should use --2--> to
map into IOMMU page tables as necessary.

When it's not in-use by guest_memfd, why would the provider force it
into guest_memfd?

If the guest VM knows that the page is now usable (some other
communication channel), it would touch the memory and do a .get_pfn(),
that would be successful this time. Perhaps that's when --2--> needs to
be performed?

>  				-e kvm_gmem_export
>
>  # Force grep to emit a goofy group separator that can in turn be replaced with
>
> [...snip...]
>

