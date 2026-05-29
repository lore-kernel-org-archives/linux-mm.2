Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BB23CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 16:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 998676B00D2; Fri, 29 May 2026 12:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9488C6B00D3; Fri, 29 May 2026 12:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837DB6B00D8; Fri, 29 May 2026 12:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EFDF6B00D2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:10:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0999F8C701
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:10:04 +0000 (UTC)
X-FDA: 84820943928.27.73C4482
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf18.hostedemail.com (Postfix) with ESMTP id D00291C0007
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:10:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="d x790+g";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=XzjWYWA2;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780071002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCQGxE2VwZ7TPyH1GENnw64ogNKLMsypG7SdY7O7HyY=;
	b=SNWekhSZ9q8L93PjPBgjkbs5JS5iapsY8HZBanNY6FxVvlz/ApM1OGBRcJ8VkbkAUUGpvh
	uPYCBJNQNwni9+r6IvtPTpq7HEJk9NI2UbvIp29X2ObSMQVXFBL5PRciZw6DoJ3Gypxqjb
	KpAJhnyZVB1hTy2t8Mm+N6+emMYfbYQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780071002; a=rsa-sha256;
	cv=none;
	b=YiqIJEe/nsiaFr6KLkiRHpko7smAV76AxEnEuKpiQ0Ud/0rMwggjFQYX2wvRebnYYbBDZ7
	n2EO8AP5935DIzkXvRbJwgMLRWrypBUVlUCW06gE9H6a6ipnP9wa8my8K0R53rLZnR0VIu
	Jk7qjEwRIohZUu98wjnkyFwacT7TlSg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="d x790+g";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=XzjWYWA2;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id 8E219130017C;
	Fri, 29 May 2026 12:09:59 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 29 May 2026 12:10:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1780070999; x=
	1780078199; bh=yCQGxE2VwZ7TPyH1GENnw64ogNKLMsypG7SdY7O7HyY=; b=d
	x790+gmFOOG9v4AuVJP4ne6bRgdnfCQusA6mDuRfxN+aMBZm0kvt3wnU/pQeM+CN
	39g8UHT39sT3ktgE8mrVsSybi6u7Suk6K3GB9lcXIBDLJEys60v8ontI4U+s9zlp
	T4iYlyY8kt4aEBJQjexUP35BvIns5SAO8obRtFrCE9Gxj+axX+y3ZKofNhMxwCjV
	DIagvUTLnSYY0OxSfoJGdFu1qmeFAf4jHNxhwKyCENto6+BWUOIm0CsMglsEg7G9
	oTXff5K8+JWKdrVUY2sO0CS7nleoceCZNXqN3QeXpV06teB7zZMxM9+th1ladti8
	Q7hVeSIefKnCrOg2vr4cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1780070999; x=1780078199; bh=yCQGxE2VwZ7TPyH1GENnw64ogNKLMsypG7S
	dY7O7HyY=; b=XzjWYWA2FQxK/sdjf3Ns4xQt2XwlqavTtO/b0i7jHjVEqQs6IZs
	Xk7OtncmEJccbLGx1TCq3HrtmigP24BtojTYLnv8lx2ZD2SmxuE3jZKVeNQmp7Zr
	C/w+DA7rWDavQvu0xbUGqKJs7XFerdMLnhYma25urvVM6Y1mzGupa9PK9QJ/Xiql
	6xGhGQzdieRgB/BM+rx3CJPad6rotOF2nD0+5orpWJ1GCqyu2oVJ360Q3h4gD6Dh
	xmtcR6868TTK1n/hVvQLHe6/UaMCM8eTf4jPydMZNjwGMcznykbrVKtDHefoLeHF
	Vk2zvjzlgy08XXRhJg2F/Sf3LrFpWqjSStA==
X-ME-Sender: <xms:VroZaiYsZ3s217W5f-7Yot472V3xNeypxcJfdq-lZPZ2zBxLt6w_Yg>
    <xme:VroZatx4_egnkCHb_9gr2HO1f1PndNcIn_8GDr8p4vAyTGCHbKghHY3ERldVpZfOv
    KxKvvjO7gaUh52NcFGbq_XFEVREFwQT87gUuoJBQ1_V3teLy8I3QlM>
X-ME-Received: <xmr:VroZanNjicJKD2ueeW2Q6rlSuSxp5Lu2S-vvGEQzskUPdPuR_-EbQULwg9JeVA>
X-ME-Proxy-Cause: dmFkZTF5GxdEr1yCvZ6kyFvOzvHVs6SwkJfUGREcVnkg1W8F4OQC1NfE6tZFRjuAEYN7CY
    oaeGvqirqC7MgUTCKRTPqriH20k/xhHdv+L9upsVMvX2G0Ehd95vRdHta+K3je4rJQBnCS
    qAV7t2idhxq2AHeyEs7ThD8S9VwoF45Rgg20qllo34+oUy3TVn6bXp7RhbnqeiMkplmiE/
    vGDHTQ4fr6VkZ3xwGpfyV8Fpf0aTgcR3ui/oOuiF8Lrc3gIpmXEAc8KbPGQDXs4ubh5AVO
    aEDwiSBAL68wmfFNOohGfrv5tNlzCqN22kr28c1/AEq5T/PDAjboCyvAd+YtMlbSzDrvOg
    5ffwJyVINgO0G/FnM7vN04WA3yPEDhlzsEEWsbxItMdALnS7Req6yihD4HKG27eTCIUWsi
    3K35QliMA7OJhexc3hMbSlu15zDC0Ubi56fAUo9qu3dhOy/zSAoOCX78c6uLEoWiaYn6Qm
    1Vtru0/IdBDvXgaSzsTuIQKqN61p4z/8JVhFETigfRfSgLIn2zrqhBrKyvPS+j/OE7l0uK
    zt0o7mgm8lOF+uurUs+vz7W5PONJEoIfYm8ADY7juvGiZRjRVsGCwxWLRRQQD+H2Gpi5Am
    znL2bTp4ZHh2vuBrcQHiY+cq5PFRj9a9Ihe7Ee/0ulN4xQH1W5I8EGaE6ZmA
X-ME-Proxy: <xmx:VroZapOzu8MWwtCKHQeztbejLKFN4MQi2TnVxrs6R92pa5qus8PKtw>
    <xmx:VroZaq8GzdXftzn4ApgZ8sKdAvtx8eSwHlqhZpMMapGCXvpVmYH_LQ>
    <xmx:VroZaoby_NAFtPQhj2dWHtxsDxUZOjCaUjcleAVcgLGn3bFEAKibdw>
    <xmx:VroZaoGOrnNd-hzG95vFOmevM9g64xdpwHnB_WIsMegvtQ8ub5XU7Q>
    <xmx:V7oZav4VZ1ZfLoykJzfe7aSwIPEi_N--zGIiXJ_TCAdDHftwfbCVW3x8>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 12:09:57 -0400 (EDT)
Date: Fri, 29 May 2026 17:09:56 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org, surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com, 
	ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com, 
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, sj@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH v5 04/18] mm: skip out-of-range bits in mk_vma_flags()
Message-ID: <ahmoH9v6_DA2i_zn@thinkstation>
References: <20260526130509.2748441-1-kirill@shutemov.name>
 <20260526130509.2748441-5-kirill@shutemov.name>
 <ahmQvfNk7S4F0LBj@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahmQvfNk7S4F0LBj@lucifer>
X-Rspamd-Server: rspam11
X-Stat-Signature: g8fx5yc8qhrzc6b79sgx6ktia5xos5cb
X-Rspamd-Queue-Id: D00291C0007
X-Rspam-User: 
X-HE-Tag: 1780071001-328603
X-HE-Meta: U2FsdGVkX19t02o3L7w32oWFH5jQ39OWQwtUQNcR++DBy78g0telCtHu5lWYbxv3wtRP/JccxdQ2KSRrPehY88qfgLgVxfJRh07TuVM0zUP3d3R4ho58dX/iuacN3Hg1hpdSQtwDIu4hUlVLPsB5mn5JDvgOftdCecVvmOBJvRVKPQbyE9WAQgAI8GO/aYGBwMXt/mzUw8fUg5cDvi1V2tRbmHMO1SRqzHdahYbR+OxFzws6HnLDc3xvBBSociaPg2r2UIvKaQdfyDQVS5BDJsZ+7dxsFT/SupcrVX362yDMg+sytBnp0w5CsUG9v8LcG7K1eSztSXJGKO+gA+6F9sRJ95enPTYZtcUqKYof31zxnTGqvCDS5SPS9z4lZjdmOT4n6zaTseGUuQtOBT9Qe2djFOz8v49tI7cem317CrpbyPbRbPpou1ynGgqcnRtDuJE2Kvcb5Tdj6mF7CWR10fDZRX1VectsDecyWD5k5KQDI97+QmRxPPjrr+LhpG9bSEK+TQEi9iVDq08sad1zOzB4WPE3c7tyWdDLYlqiTVbx2HsGRS0+1hNzniYbXEILwOABVv0Qc6bFV/iPoBAHN3q1aDwBfKE29OG16mb/I9+6tp+qywFFsZQGD0EhfMQUZS2tZsN4ZbKuFna2oV3MXTR4KWqOwj9s7aNhB77wh+ky/F7ohc18dBrxuqsZrJw0kCBRYAA3ATFaiV8hcA0RNEfm8buaezwTAiShbkQrtjYeofl9fs88xz3AD25hyBYf+HE7su6Cvz1xTeDOkLnacrXFiVobcgVGO1FXDMyRHIxRerwHZ6BiI71Yd98ScrQVnP3pjM5B2cKjOTI5Y+FbFXi4FX+iIJ+mNfzfJMFoE5OBs0c9ykTmvq/rQbZS1NpgqeA0RIy5Z4Mo25YtFu+kuZB1UDPI36S8XqQHrqNBkcmePrDgQcUDRLSqx55OiqR4h5e+jIVMIB88YZAKVWk
 imYG1p8l
 DeQqjuKa74sBqbmdFNEpG0Zzfhs5ePzYC3yCvz3F/2S4OVVHdicDfsWaG3ikV83ZWRkRMF/66/yW98SrRrDbc/XQIOsyGUIlVVGwaRGTtc9/JFzzWrmx0sqhUI62cCVJZR8Ruj96vMpJ8CpOREx+r4noBtc9GM3ObIWGXBNAP2a+TPTxOsm+NwiEjX/ZEWqe3DZwSpooMUIa8RkN9bcjJ/XebdYvkRQd8j7z/4pArAtNnzbB/jpJHC8SbHU0mm8B1hlz6S5C6AKYYP/NWA8NuqXXqHWrAkdsg1SEhKtj9d83QK+V/sdkD/1LmgumB9JBqXcGyIRTjMEobm2NOjqjeM/i+NfIGyOGZ+k9y2cfgN1Inox5ZEHTTxLsdK6Lgwaat1WfZHEqSag5p/n8MpAb7L1qX3xu8BZrpZc8IsDfhGQeVdFRnZ7ZXHYJtS4R2ozNQrY1uTpms8EknDt6bpEoezwxXSFCNS5J5gXbSi0flMav7PaI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 03:00:14PM +0100, Lorenzo Stoakes wrote:
> > Add VMA_NO_BIT and have DECLARE_VMA_BIT() resolve any bitnum out
> > of range to it. vma_flags_set_flag() drops negative bit values.
> > The ternary collapses at compile time, the runtime check folds
> > away when the bit is in range, and the common path is unchanged.
> 
> Hmm are you sure it does?

You were right - I measured it (gcc 15.2, clang 21.1.8, -O2). The
DECLARE_VMA_BIT() ternary is fine, but the "if (bit < 0)" guard does not
reliably fold: with it, clang stops folding __VMA_UFFD_FLAGS to a constant
and gcc keeps a rolled loop; without it, both fold.

So I've dropped VMA_NO_BIT and gone with your config-gated-mask approach
instead: mk_vma_flags_from_masks() plus VMA_UFFD_{MISSING,WP,MINOR,RWP}
masks that collapse to EMPTY_VMA_FLAGS when unavailable, so no out-of-range
bit ever reaches mk_vma_flags(). __VMA_UFFD_FLAGS now folds to a single
constant on both compilers, 32- and 64-bit. Added your Suggested-by.

I also took your "use the new API" hint and added a prep patch converting
the existing userfaultfd_*() helpers to vma_test_any_mask() (Suggested-by
you as well). One deviation: vma_test(vma, VMA_UFFD_RWP_BIT) is itself an
out-of-bounds *read* on 32-bit (test_bit(43, &one_long)), so the helpers
use vma_test_any_mask() with the masks rather than the bit.

> Either way, I think we should break out any fix like this from the series.

Agreed - the OOB fix and the other pre-existing fixes will go as a separate
series with the RWP work rebased on top.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

