Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77ED7CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 09:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCFF86B02F5; Mon,  1 Jun 2026 05:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D597D6B02F7; Mon,  1 Jun 2026 05:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C48B96B02F8; Mon,  1 Jun 2026 05:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACD516B02F5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:37:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A4E4161CF0
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:37:40 +0000 (UTC)
X-FDA: 84830841480.16.49A163E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B257E4000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:37:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c1PJZNWT;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780306658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AzbXwY67i7orrJSYLIcDP2MIfpMzq9fPfuSJU14oS7I=;
	b=iK8Gw0EJMBDv1bQb2Sf1etENONPK0gAUJ97Iy7CbcHL7plZ0hCrwVF0J0jpufsuSshHGqK
	ao25y+AXmDq62TQBq0r8KogZAtfng/+aVuk+KlBc7RlrBt9d78OAc1qglEQKbRCokI60ql
	hVX2H68sCH3Wh/sQcQ91cGak9e91krQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c1PJZNWT;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780306658; a=rsa-sha256;
	cv=none;
	b=5C67E0LTbtc5fdC5Zg1zXcab59YcpexUzHJz4FD6RTN3QeHZL9VA8TUxcW6hF85+Qcmiov
	KSYNMdnQJjD8dZmjecx+wOifgBzGNoSJK6Qa2UaKdxRGP0Bhcd3kz9i2YXmhJctKwHJSo9
	L94wooOYL5q0lPBeMUmVg4EtoV37QDI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 12D5944519;
	Mon,  1 Jun 2026 09:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2F01F00893;
	Mon,  1 Jun 2026 09:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780306658;
	bh=AzbXwY67i7orrJSYLIcDP2MIfpMzq9fPfuSJU14oS7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c1PJZNWT6Jhrtsti0/iLRUjmX2p41TJJfRVGF/3HNXBQB7PyKa2x9bRmyaeFYhkph
	 S/XYHC6xhKx56Ya51Xak5ZkdEYl7w6jJ5CHtlZipgiVBNEdAMNHH/iRIH0rE/rdUWu
	 0NcYKv9W6ljVMkX338Av9+n5cEDMlkvl9EyHcrfG4IQCWXZKImq9ht9DNl8Bv5zvtM
	 ATehWylJaNN+9d/XXQwwW29cYaUrS+pOaBG4dYswLQ5k9wG0aOJ57MhEFaYf6nU2l8
	 SGi6xk/XJwSfllo85W6VmcGnxePA0rHGqKLm46uy+j9fAJrU+3ZTv7yeI+eHKuE7At
	 N4eY0MFKY1p+w==
Date: Mon, 1 Jun 2026 10:37:30 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org, surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com, 
	ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com, 
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, sj@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH v5 04/18] mm: skip out-of-range bits in mk_vma_flags()
Message-ID: <ah1Sxn5VHLF6jlcU@lucifer>
References: <20260526130509.2748441-1-kirill@shutemov.name>
 <20260526130509.2748441-5-kirill@shutemov.name>
 <ahmQvfNk7S4F0LBj@lucifer>
 <ahmoH9v6_DA2i_zn@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahmoH9v6_DA2i_zn@thinkstation>
X-Stat-Signature: b8y4o4cc73oh7jwmjfr9neqyhpjt7mqt
X-Rspamd-Queue-Id: B257E4000C
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780306658-978077
X-HE-Meta: U2FsdGVkX1/l3hfgDxEw61nTVza9JZ6gzEhA1/WHoPsSi1gpBV07YC9jD3JfOrvp2tyOqP711OBHZBQcN6qI6pEnehI2n7rSrHMZZlfQD6knIGO7WKcIETJ3GxQEzZqhb1tKLdv2TyN49hapDv0QjSsdfm3mT7lwBt5yYB5a6n33qnuxdQpAgZUxcyXOlH7SFM9+rnLB8LfwDVbhOkCTg8eAnaGvDRqlHlCGSDDeGGQ8+yb4nG5bfI4RcxHdOwrQI4Ir/kdpPe239ij3LzyF68VLScdK5WO2ofh1pBVmfjI+XAuHPfWC9+6VhbDIxj4qclcafKtH0/waqMdTUS6rxN7gEov6t91pTfVDVAmKZYG7nL3wbLNaUJHFEKcmAmRLGcZ8eD1zTOr3XUx2hlVmModhZNjhjmIO2+QH/4Cgy1AOhOKQKiqnvNJUkEz5hYKgwJ5fFt6yimPUNE0AulgNcu/X3DNRcgzKV9njkm2oIGYRpZUKInxLhHgvSkcoCaDMS6t3rLVxIX1FJa+4SdV9WqsWEgU3px5QaAKnaoDEk+V+UwaV5dlKS99ZKvrwU4QBDA3vXmdthKyJa7u0mDeMUDuc+vsRTmMNLQl+ZAHnr98ot+/KJj6WW+iN9mcWAYFKMDSNaxnAvOMY8QCuZHpb9WTo/kr2Ev3hAxMXNi8zi0A+zYRiPU0D2uRuC7RwCGuNs1aeI5dvnjH6M9PzJKWABwsD1GMfFpkxxJkA794u9J0SSQvN020MhsltpaJwYiKf18U5wEjlrm+ivKLHkgAQm6EWx6xk2EJBSDCTYxKnkWeot4kJMSB949D46U0ogwNV/llc9Es6TtHtmkrfoYnTaHglc6oPUYtS/DCpqbf/Law2pnQO/eGFmksr9loK5i7cc5UqieZOCXFNI8YsSApO11vBQ1E+2B8la0Zbpats7Hx8dwYsHLgLNIbfUEB/mKdWTqJKdtBpWb3gGGtCZNO
 MesiO8OD
 2h7vtiIWInofvYkbAZ0ndR5QRtqFQvSHlrzv0wvUFoGxMRJQ6sPPPpL5NA9pUD6HKF12SjxkIGmgPpeIroho2nkGpG0yhmDk3fzFBEG2KO77mQ9UOj0WyM+NgzoQKr/HsqhSFP1oySAZCTw6WMiB0zVxv1zUWPIruEPpawFa7WZRNhQvJQdO53PrNtu+j9fLLyFNz0mOYznuV6/bqwOHFg2/PrhSEgufFCMduVu9wBWl8zassa2HGNmVode6qObUNfza++eI9exoSV9Qm+J7zxmwNFy9FLbFHjP67G6T2pcI/2N4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 05:09:56PM +0100, Kiryl Shutsemau wrote:
> On Fri, May 29, 2026 at 03:00:14PM +0100, Lorenzo Stoakes wrote:
> > > Add VMA_NO_BIT and have DECLARE_VMA_BIT() resolve any bitnum out
> > > of range to it. vma_flags_set_flag() drops negative bit values.
> > > The ternary collapses at compile time, the runtime check folds
> > > away when the bit is in range, and the common path is unchanged.
> >
> > Hmm are you sure it does?
>
> You were right - I measured it (gcc 15.2, clang 21.1.8, -O2). The
> DECLARE_VMA_BIT() ternary is fine, but the "if (bit < 0)" guard does not
> reliably fold: with it, clang stops folding __VMA_UFFD_FLAGS to a constant
> and gcc keeps a rolled loop; without it, both fold.
>
> So I've dropped VMA_NO_BIT and gone with your config-gated-mask approach
> instead: mk_vma_flags_from_masks() plus VMA_UFFD_{MISSING,WP,MINOR,RWP}
> masks that collapse to EMPTY_VMA_FLAGS when unavailable, so no out-of-range
> bit ever reaches mk_vma_flags(). __VMA_UFFD_FLAGS now folds to a single
> constant on both compilers, 32- and 64-bit. Added your Suggested-by.
>
> I also took your "use the new API" hint and added a prep patch converting
> the existing userfaultfd_*() helpers to vma_test_any_mask() (Suggested-by
> you as well). One deviation: vma_test(vma, VMA_UFFD_RWP_BIT) is itself an
> out-of-bounds *read* on 32-bit (test_bit(43, &one_long)), so the helpers
> use vma_test_any_mask() with the masks rather than the bit.
>
> > Either way, I think we should break out any fix like this from the series.
>
> Agreed - the OOB fix and the other pre-existing fixes will go as a separate
> series with the RWP work rebased on top.

Ack on all and thanks! :)

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

Cheers, Lorenzo

