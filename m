Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CEA5CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 11:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 127266B0092; Fri,  2 Oct 2026 07:04:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8666B0093; Fri,  2 Oct 2026 07:04:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F095D6B0095; Fri,  2 Oct 2026 07:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA15E6B0092
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:04:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5FED6806FD
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 11:04:12 +0000 (UTC)
X-FDA: 85277401944.09.D797F37
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4533040008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 11:04:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Q ekrnzX";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="es2mM9/h";
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790939050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+CspCPuUrV1DZQwM4VsM3gftFdzU2algsvWjKSKcew=;
	b=BFo3JJhQDfzYaXsHSnMxJIPAFMfTS/WA6wJa7qt679E6ympFyaV8SKqBUejWWAvLelZRiv
	UBLqgfM2lgPMzM6ijifbx3kzQu67EqUF2GoVWx1an0goxfIcTWZvaU8RuCEF7qe20WjEOd
	DM7dBKAAxxJ/GsvSQgfEuDAXJ1uBuRo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Q ekrnzX";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="es2mM9/h";
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790939050;
	b=AZNZ8DhklazpTg0ipsWglM6MVGnpWGiz5oQL8aOExi1tIUwE/NfzFsXUjCEvPWIh2t6tQL
	fq4o8EJAfi2ZApwA5maYo4Ep9BmhVA6TL9T1PTSp2tLfZlYbfOETJanURSycQmeqbr0lLq
	Mesq3FLcnD7icgJiKwGFUIsXkVU0zcA=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id AA961140012B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:04:09 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 02 Oct 2026 07:04:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790939049; x=
	1791025449; bh=V+CspCPuUrV1DZQwM4VsM3gftFdzU2algsvWjKSKcew=; b=Q
	ekrnzXigrPsPQk+k59ixw7EuVN1vJkDK77wtQ8msXjmm3lG8+09rr8TX6ouMMtA8
	JULVwj9eAOXvr0OZ3cAYjE+4uia6z56O7hCfxB0coS3DL4oTBmt4yEHfoL7WtvZf
	sOKas9LGw01pkIih7srvcZnfb5NNEooy6bAx7yuMBTdv9RBaMzjL9DZdYmOwqcmS
	s0Vj3K9vYbfQJl+9FRA+MJtPppyiNVwmeiuN1qGxvxD+qbJK/n0Xr4yPsCcp/dbs
	Vg/gWyDAWUjpF0a5g19tvgozNnHEOoXf5sVqN/G54INPq9gTFyc/ycJ0S1kCTdb5
	jb6ujMimOx89Qb0k4Z+EA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790939049; x=1791025449; bh=V+CspCPuUrV1DZQwM4VsM3gftFdzU2algsv
	WjKSKcew=; b=es2mM9/hFxAg6etPPqWoGCLcfup4dLXuAGXaaye1ZDLmnZi/Zo1
	utDYEKOdDqIuCovcHwFBV0XWvnW3g/nlCUEkDVmtydDssblFHXCK0hL7ZDfUbGxz
	mVBFuGPLBqqeNXOiktpNrbdRkmGsAw4x8xbd+CVxg+uCaM3lPwx1QiG183R2350A
	Nnj9yg4pqUKax6tQTeAaMLazgqScEUGku+XVG/2sNLWnUlia7KbS4xErKYfID3PI
	Nx8M3WjFm/549RkEO7lF/N7cTXdKpaYmBuDT5RFT3iu69xZJX+Ir1dB31XTv6CPF
	3Jd2VmruFqzfxKuVKHBqgKha9qGK99snseQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790939049; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:A4+LXCxfzUtU3fNu8byJZ653YHxUnzSuBxpzWQnQRN/jFy5
	ngip7P2k5vWCJM3fxa6o0KQ9UlTEM/uyhkSQuziFizEduCoASatJfmpH1/CCT/s1
	rFUwsyxicTRSlgiib3IYD5pXo75Wp87OTUqhYMrh9hYchl2cJ38GZW7VJWLAkiaz
	Y0BOBMlCaIJhLaht/qcAkjsrIn0SexJ8TA647Fgi5/gVYQFzbcHWzJ1vlP0txh7e
	sflv0dDIRcXVptfLHWI/M0vxu9p2RLsHnDE/bD1Snso3YjT8dTecJiN28uGcFSX0
	Mc0aCKxjBO2sxconnO0cwSx6QZFqDttWmimkocw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:B703GFyu9om6K0t7rMkPEQo13XbBpyozKr1P++By2lU=:EiDnjZi2h0pRKoiVbnzpkW/8VgM3LAqYOqBc5Wh7GeU=;
X-ME-Sender: <xms:qI-_al_XW29hKuV2_QY5CdbR_7-Rnky7igCnrBvkRKcNb9mmPOpDXA>
    <xme:qI-_anXIzSgfEZihc5ZWQSzjw2cekbDaUAZfTGsNzo_a79V1YaSCX2yI9CJEYCBdb
    Ro08lwYBYYRMtXiG0zwfipIygxjiMYNCovxgwusK7Xduj5basbGsPo>
X-ME-Received: <xmr:qI-_aqYJzFIIKnBrwgTgfilLJZnOl8W8L3SofRVEA38IxyXxBMZ1obZ8cmg>
X-ME-Proxy-Cause: dmFkZTELHcSiMMxlJw34NEVhTb/tP/q7rUftRVhStCDqy5afz8mIQLkM5/U6lzTbT7wY1t
    Dubz0b8qAjMVg1fBerCV70MIYPXwjQR1Xz6+u+kNvHS5IrQdijxYHnd4qgJKDCU+uIkK3M
    A63URQ30c7172S1e+9w+Qm3u6+POqC7A6FtqE4x2etFFOPGJrz6rJ98hbHRzwQv29fwAL9
    IPjyzfA8vfYEFs4w8WrH6fofLmF0ER614Rx3E3d9vKsUe+oZtGkLeLSS/bnnjuQWuRXFTN
    5ZhU3Bia6r2PTTckhuHZyDCdJwSMZDSG9+naPwBLIwHKr8medxM4MSNsZ9CZ/AEU1mm8C8
    DpDa4BcIxtRxk31Lvhwnba/kRwh7hZqBGjukZhBOiktQRPseP5nJBqCJoQEOJh6FArRiV3
    0TFoQSip5obzK9i2xEDlmLAS8BLEcxp58c1/w97k9xdD91B2MLNNOqYElFNy2p09CrpdE3
    /mT2CTyZ0ll3n8FFgdNMJvxPO8OeJqHxxO73aQQCtT8ZAHxyheqVwJf/gZQz0+jShj+F/L
    z6BbbHoffeY3ABEmB7vh5+q3bR5aI3g1DRZKI2MYrvVT1osmvjY7CQ5m4IBxOXeI7t/P9f
    MCwzWznWWqeVTdn+agZgcubO+TD9JJZ1+gotwC6gVatu6CFB9TnliCUtvgzw
X-ME-Proxy: <xmx:qI-_ahoMuzxjxda9e-7WWILqqvVQ6OzqIi_j6vp9kffK2nJX1wx6JA>
    <xmx:qI-_ah47Y6ZgaFBM22xfNaCTp1eEivnjXpbLcDQu-mh2pQxmtbY5PQ>
    <xmx:qI-_arWglGbLtLsWf3LLz-Sm9sv-rZsimrjasxCkOY_vibiLudrPJA>
    <xmx:qI-_avtVZV38vE--ZyoG_9VSBELsTtz4DbkeCKUwlql_akeSOXO1PQ>
    <xmx:qY-_alg1zRRH5BVUKeLJX6ccgS3g8IqsybqWkk-BMI3G2z4Vz4N9Ka2y>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Oct 2026 07:04:07 -0400 (EDT)
Date: Fri, 2 Oct 2026 12:04:06 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH v4 08/13] mm/collapse: call collapse_file() from
 collapse_single_pmd()
Message-ID: <ar-PTlqz0nq5Z90P@thinkstation>
References: <20260928100630.21870-1-kirill@shutemov.name>
 <20260928100630.21870-9-kirill@shutemov.name>
 <DLRF245BL299.14P8UWBF8SAJJ@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLRF245BL299.14P8UWBF8SAJJ@nvidia.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4533040008
X-Stat-Signature: 4t8e87sjuumuiiion7ar5uoijwc45aww
X-Rspam-User: 
X-HE-Tag: 1790939050-100739
X-HE-Meta: U2FsdGVkX1+k5kVsjp6CyMn8t7++vvd6QKVMPcUNq7tRCdQIBdm/qWJKQWxOcUgasjQiU7s5pCbgIOweM6/yMi7IexEVp1hQEu9GkEO2BIUdH9rtnn9aNquIJ1IxSLTAfP3GxlSRMr2Jc0oVQV0CsYhqNIQTzcAojrSkyNiQB7m0b1brMZQmtr7bQh19P+PmVPSRj/7tTgxI0oC5Gohqo/d1fHcJhCrzCiJg+27H7JGcnuUw+AkvdiAGPHDhoFhQSHzq3c1vLnYIUwOXQtiDGd6HMG2tSjB+929BrSZqq1b5LHvLz+zc8oUo50Qu5xDzGCv+EnKtfbG/RFNMucSSLZC+4031Im33k3Kb3m9EzZBQNWm95BtxshkeI2hnjEte8spVc8HDig9IKziZfJOQbboXC22OoOiPrq+a9Xy6xVK1jt5wXcPEikQq3zol7SSVG911rwaL2S0kv0CpTyiEmm5Yqez3eSnABC+csj7bMJrTf+3lVgcht8EfjTjcCRmJvMkUO0dwqIeVuqUn/deyZ8y8gyJMnNcBbuKRnb0edcUnIXHw2IFKJufubQJAkU9drRq/0YwBcvEIRyU70HLveT2f7HH2rQlpWpQwykxqmKCpFt9hF0kBPuhZHFtiTOA00q2jkM+sCLrx2agL8Bys+ohxSZLVw3uRtgcpwkUFc3LwyRjH8vavrErnV+RP4gDkUtuHsdJA5rkGUlkWj9hkNU+qLdAgsJ+cg4lY6KDNVzjQ1A5zkIOcCGCh0fIBuY0Xi/Plm3WUOl+K3ahpOZeeBygFWJBJA5kcluI3AQYcEr5CToOIMRME8T4qdVa69pRmZ2SvQzqADYfG8cC3rr/l64G8Efji9j3Iok2aUUPiemEJ0SXFDS3/3X8Oifih3JtBFzpjcvVKGc9UakGdrd7PXCOJ8nFViDM02cIxsOg5rg1ld0qka7U6/BiS1m4L+esxZXO7/xv2uIsiUu5qbZI
 vrI4zdMx
 ul+rizwzfeREIg7TZQtr7lEOOzVyWyeakp+ld/bSejn56TjhjGyTaXFtckFsMQl9IOuAklk9VuT26qIsoBnRYbAWwBFXucnhXrHmFPEKdyCuqmt++FCQjPwyDQhgkWCTwEpY03yf7s1SqnrBnhbsFilke6menaA7B7iIJHxV7U063UfA62kpOnr5I4veEW5fyRrKloe+8OMJfwcJTp7OwLlNrIabMp7CkKGnaxmjujG/Q0qOwCBtOyIEO880zbyLJ/XWFYT/XspqS3T1XUuJysEK83e+xODdl+1N3EGTKPSGoxw3tYp64X8GRQey+6BkAOT6H6B7dVMLmXTSsw12lCVS4rMmpHQmqLsBQDpdybLTIxXFhZGTxjMPjKlHzhKxpIPvhGX8fRjwEbyxCs2R/a2tDKUGAwqg8AsSm/DK98dATCoHp7KBUd6ttcVX6hJ5RFC7D6nwECuWPzGouuKLa+guXXwjPh/oiNVMjXw+VGhk/BGduHsE+36SNYqagLpgl/KjVMzEM5jf1pjOfAJrxqO0HdnOWhKst2LxXinRqn6J9auPu3EgrGyvvZppB/V59gM04TaxS74sYYV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 09:41:18PM -0400, Zi Yan wrote:
> On Mon Sep 28, 2026 at 6:06 AM EDT, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> >
> > collapse_scan_file() reads the page cache to decide whether a table is
> > worth collapsing and, when it is, calls collapse_file() itself.  The
> > caller cannot get between the decision and the collapse.
> >
> > Move the collapse_file() call up into collapse_single_pmd(), so the scan
> > stops at the decision.
> >
> > Two things change with it.  The writeback retry re-runs collapse_file()
> > alone instead of rescanning first; collapse_file() repeats the scan's
> > checks under the page cache lock anyway.  And mm_khugepaged_scan_file
> 
> So the new version is a little faster by saving a file scan?

On the writeback retry, yes: one page cache walk less per retry.

But that path is MADV_COLLAPSE only, after a dirty page sent the first
collapse_file() back and the writeback has run, so it is rare and the
saving is small. Not measured.

The scan rate change is in the next patch, where a refused file table
no longer costs khugepaged a relock.

Not measured on the file side either, but it is the same shape as the
anonymous scan, where the relock per refused table was most of the cost
of a pass over memory that is already huge.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

