Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19EB1F4368D
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 11:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B8196B00DB; Fri, 17 Apr 2026 07:02:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58F376B00DD; Fri, 17 Apr 2026 07:02:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5CA6B00DE; Fri, 17 Apr 2026 07:02:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3817B6B00DB
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 07:02:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCD46160124
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:02:10 +0000 (UTC)
X-FDA: 84667758420.13.C0BCDFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id B9611C000D
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:02:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CrzOjV3p;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776423728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTM1k+OmiSWaXYgfOgNACglUyAXtHEF34QAhe4dBrdo=;
	b=fUBkhZweg3HVQ1YGTX/Jb5cDiVarxeYieOdJosuUhIuRehuWzqtKye4CGhHD4KkC+t+d+C
	g1h9PRPQYuCV/Ya44HWXmT6bsWCLIP0IBO4ub4KbZqZdjOzq2TyD8SFOt23DqOl7Lhszr9
	xlJpaO8t+27BRHNxCPaZ4NWH9825xCw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CrzOjV3p;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776423728; a=rsa-sha256;
	cv=none;
	b=yQd9QAwUjabMSPALe1le5oElOyiBc0sVcecu1tX7/7MPxyFXy5poYoTgd5hRKs5M2QoZmv
	gpcp+ITRaqQb9rmoaF9i6shBP1tDLiiGw20GyvCHm+I/W5E0sSRgyjuNA/CydXCbuOZC+v
	cCTeEHzGBdCVGgG72ftVlBCKZ4sRChQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C4BF42E3D;
	Fri, 17 Apr 2026 11:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFDEC4AF09;
	Fri, 17 Apr 2026 11:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776423727;
	bh=RD2xZwSAN34oyYE/yDIGZVsjk5tGByOG6NLgb3CiwHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CrzOjV3poiBb1puu52YyXIKRuGOwWvMNH9wuAYttnOKLdq0iFSKLcw2Ru4KWcX9vz
	 p/aUAfW1sWP5GzD/1FyALBZ64HgTdT4xFvsqEljUHZqFlMDE6Y3N2X3ecOZi4rjW2T
	 0Tg+PnV6v9Y2r6uVkbFpcyKOt1tqV5H3SYTHCcnPHiBYX2sC4OvhgRMnfciVop1cjl
	 W+AUIqNg7QU45cczLLvAqBxyhEDiY9E/OuJQoqai19M+HpKVsWM6V2NQm7PlntGNlu
	 ytQf3jXSUzIIxSLHU7JHlx4pHs9hSOkfZ7PcCCkqXJLGCwsW5e3v3yl2VTMB/6uCiJ
	 Z/hmg3JWUXMJA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id EF459F40074;
	Fri, 17 Apr 2026 07:02:05 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 17 Apr 2026 07:02:06 -0400
X-ME-Sender: <xms:LRPiaQD7NRvGGI6zwWqzkuIbrKsRzf-riMi_XbJTYBdcYHVyNaaDaA>
    <xme:LRPiaRyAeti_Nx7WMC2nyqRdLHucqwGwqgBvI96JHtvWZw-dYwsufYFiBcs8agnlz
    NFFvhdfNeliG6XayXvOLLUBrFLPDX8b6qyelMiONaD3RmAgAvIeWMU>
X-ME-Received: <xmr:LRPiafxIctvuPPL4kUIE5vLvCvDfLr-fwC-PRCBXJl82QU03-Yghbw0l963gWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegleejtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeeuieejieffkeehfeffffdtkeelfeelhefhfefhudehjeehvdffleeuvddufefgkeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuh
    igqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughh
    rghtrdgtohhmpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhg
    lhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohep
    iihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:LRPiaRi0fIkRM59izX5QU3KhLf-I2qFhnfNUUanzQTESqVyBPDMQ5Q>
    <xmx:LRPiaYTqSmfQGtkH14z0Zke6oAao0cPgvjOpMpAUIfuEbDocN2CNGg>
    <xmx:LRPiaRKRhxGYIoazpX2flDljP6wGD5IHG2pMs9gPtbrajG2PFYxgPg>
    <xmx:LRPiafP2V8jRpG8pwLTsPptBNucRmn9aWSqe6bAgCCIWzWvoCgXaSg>
    <xmx:LRPiaTy_wSrxI2_acJSkBmHrnbs1hKulga3OLYTuQdfyRegVlTApXBIW>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Apr 2026 07:02:05 -0400 (EDT)
Date: Fri, 17 Apr 2026 12:02:03 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <aeITClDuFStd7BAB@thinkstation>
References: <20260414142354.1465950-1-kas@kernel.org>
 <55019037-4f1c-4d9c-83ee-3a844d8f3d5e@kernel.org>
 <ad50rPOseVa-SP_s@thinkstation>
 <aeDoqFWPFxkkNB26@thinkstation>
 <1a499781-1115-44bc-adbf-2ac3769354ca@kernel.org>
 <aeFCuLJXT8VOkzH7@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeFCuLJXT8VOkzH7@thinkstation>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B9611C000D
X-Stat-Signature: 4if5wxqqjufzs83z6tnspwb1hhytckmt
X-Rspam-User: 
X-HE-Tag: 1776423728-59804
X-HE-Meta: U2FsdGVkX1//i8MVeyz8iM507L3Saf+pQw64G0q9pPZ/TCqXX0Oc4aVIwgVUze9noMGLlQwgVwG+Svn+5eXsLRzX07Ln4z3RAVEKfMeumRKexKytk4toKIS6nSHOxat/MpQb84mDtdKoPtdDhFsjoAWn43SFnYtiMQgnxHV+8xjcrzT0hL1iQaPOBDudQBXkeD7gKGWfxtjIRReEVYOP42/+uoI48+gjqmz4htGIGbmomaiC9IixQV5ZMjjH+vLkCQtJdf9VZ6ejlOju3F1P3fo9TJ2HVpI6Morjv8YlVnUnWsGqZdaqn9iPCE7cZ4XndxFKUinYZ7+pQCII8viEOtiK7H2PQQ/n+LVHnX/NulmDF2WjQ5Kh3vbklkn0HkDwMDqeEklZugHES5ILyPuwejgf9mdVJB8i9nh4mEVBKtvmlXEUhxhC82Sx4/fJQ8OexFOxJxT3lxP6qE3vu1j/xpTVNgVuTSyS/IBZy0aj7Lm6ZcsEXbWseI1Rn2Qou+1anEhidehyTg1qgj483j4/bsPoNuoNPIGB8At9MgasEx+BoFccRFZvxwodknjM/o/mOZP9ApXZbdIJqPKf1aBm7rnYsiKKBiJPzUH3mnDtL6cnn5begddUGM0+9mF1zSBnGTtfjESpaWffYpWHRa+/gkd+KEdn2OzCaSMpS1fX82pH841E8WSv0iUPOfnoXzs2/SIFU5JgkEZ4IZ/OIySmeluk8CkUjL7ElMeYb9WldZQDZXVEGhW8RmJV9deoPdjSjUtOyePu1H2xkrWlA+AC0Nt5mhIbuo6Yhtoxefyz+4VDO15GWzHWunhTef1oDrcDqbm2QgrxNkLvP8YomzhcPqdN9XOOZSX3VwaA6p+IgeL1TE/IqudYvk5G9lgKG6jSHITZ3BaS7EiMd+EhgNq7OFTS0ZuxI4P+NebVtJhb6eYUYb+8GlzPw9fiyEmo7Irx1m6uDGTiMPxVG00/L51
 3ITEgJeE
 ufCcABu1pmLngNgjOKoJ0fQjerzdqkDJwOO8W51UU36zbqI9JdqqhLQ91x6b9pN2g8ZqJ/E/HH8DQsuBjyVeKQRCxobVxfHaNi5ExEvImH7gk07dgWxONYEWVEm2cAU2BrC/P2nOjDzAH9gXJ8hKtI/hLjm52bIolqql+rM6AS7xseLzqNz1CkJl7VNugDCqJQK1GqaipwMJ1xYohyJqscRnfA8+ggz1PeYghvmNZ9vfaAmqG9H0jXJh6zIkQJLV8A1K6tghRM+ICmoVpO3lxcFwdbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 09:25:25PM +0100, Kiryl Shutsemau wrote:
> > b) obviously means that we cannot use uffd-wp and uffd-rwp at the same
> > time in the same uffd area. I guess that should be acceptable for the
> > use cases we you should have in mind?
> 
> I took a different path: I still use PROT_NONE PTEs, so it cannot
> co-exist with NUMA balancing [fully], but WP + RWP should be fine. I
> need to add a test for this.

WP + RWP works. Test case added.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

