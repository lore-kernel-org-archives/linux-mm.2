Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A40BF459EF
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1AC36B00A7; Fri, 10 Apr 2026 11:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCB7A6B00A8; Fri, 10 Apr 2026 11:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABAA66B00AA; Fri, 10 Apr 2026 11:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 99D086B00A7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:38:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 488E7E3223
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:38:59 +0000 (UTC)
X-FDA: 84643054398.02.74FDE55
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4C847140002
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:38:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm2 header.b=sNmsjWZT;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=cLiUg49G;
	dmarc=pass (policy=none) header.from=anarazel.de;
	spf=pass (imf26.hostedemail.com: domain of andres@anarazel.de designates 103.168.172.152 as permitted sender) smtp.mailfrom=andres@anarazel.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775835537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJxIaY44SKRSuRDHa4BqhYT4Cng9qUO02oLL9GGx6MM=;
	b=GCWAggihSNL0JwrVRRHKJJC2CSGY+9WrQqkjvR2C5lFbn3eCnE0tve3rpUd6FonVQqFBUf
	Te3DPdFnx7Jy74zhy8EycB8Uqj1Y+e0robOP8T2cTSeVMShgsuqMjHs8tIOdBl6Md3EfBI
	KIVpFap4zJixrSB+K0QEmNxtWBFs3sY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775835537; a=rsa-sha256;
	cv=none;
	b=Xcbj2laCvPisBu7NVcba079emOS8ny4F+pteLhHktG/P4HUzGaIXdppptwhao+PfZeZwj9
	vtOIDaqPI5CdC01Pjsd09+KCPVQoZz//Wxd4BB+wYshffvYs7A/aLWA+9DfuvnXndkOFRY
	tvuLjeYwVl6yz4hj/3dcZObbmedOvgA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm2 header.b=sNmsjWZT;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=cLiUg49G;
	dmarc=pass (policy=none) header.from=anarazel.de;
	spf=pass (imf26.hostedemail.com: domain of andres@anarazel.de designates 103.168.172.152 as permitted sender) smtp.mailfrom=andres@anarazel.de
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id B3375140014F;
	Fri, 10 Apr 2026 11:38:56 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 10 Apr 2026 11:38:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1775835536; x=1775921936; bh=gJxIaY44SK
	RSuRDHa4BqhYT4Cng9qUO02oLL9GGx6MM=; b=sNmsjWZTZoe2EFh8KAfLkDGFKl
	J3Zgj/EjlNAPNcUFRM6fiDWu66sjB02Yh/m9KvNRXbdPO4glD6TcIFYZKMmcZYlg
	Vnx6I72diINd/P0dD43qG9bdMeCWFuHewUMRIPJ+W5xhdhUhMsBxMnxpuDfv8ewV
	ZNL114gd75F9ocLzzN1Klc70QRbSbBIFxSni+TMeGdbxBqSt1/58qbRi0guySLTE
	MOQ0nSkHxNt+wlzHNP6b0SRTTyfPzhRXB6/lU2Lw3p4fEbUiHDGXeOr+iyW52iIY
	gfZoGWtsazMxN+7g0I37WrUXowRxvPK5c8VmpR3vXzghNlDLz+QNy3rnG4Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775835536; x=1775921936; bh=gJxIaY44SKRSuRDHa4BqhYT4Cng9qUO02oL
	L9GGx6MM=; b=cLiUg49GSO/MiajHcJ6h7uvmPgtRgnqe8Q1vKAwq8Ghhep+l7yX
	hV3IxLeNgPynXodaxmsfSAZBs/Kpx2UYTm89MiJYliNi4iYMyYILy1iJ/MWe+xtJ
	fuYJd5onYPJA7e0raKR8o5jCQ4AJEz0/KvB6hTrIhd+5RbrewnBoybX3nbu4eqA8
	2cNglkcVju3DKobEFHANJh//pRwEUVSV9uQMJKzkYX+fBlwGN89p3FSKq5ISLBqZ
	wjRRywuGx0i/4N/YTbgLSKAijblMLyhd8UBNH4kYKstXjVfMuSQaO6ugETKTeIWf
	9UEMwl88L4z0vgpWsuFuNqE/VQV5Z/Q8QhA==
X-ME-Sender: <xms:jxnZaaSEiYbAExxRxGw3hrePqknEN4E1bmOhprB_kiYncLzeb2RZxw>
    <xme:jxnZaao5ToE9OeBpO456Urq9KM4bEOQKP3C3JZQMf5rgkgBizZGJt3523kf7BDbSq
    ph7BKzYTCpCs8TpvxiwIJHQGhqtrpmvSImW30MviNybQ78hppcMxg>
X-ME-Received: <xmr:jxnZaYwp3VjdsIaWCLVHJYkojrC6a9aAYeZ1CyN0aAAmNFqMS_vrRjYzPpbwwlblfBAIaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvleejlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpeetnhgurhgvshcu
    hfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrghtth
    gvrhhnpeeffffgledvffegtdevlefgtdeggffhvdekgfegteeiveejkeetudelveejhfeu
    geenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnh
    gurhgvshesrghnrghrrgiivghlrdguvgdpnhgspghrtghpthhtohepvdekpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopeguvghvrdhjrghinhesrghrmhdrtghomhdprhgtph
    htthhopehrhigrnhdrrhhosggvrhhtshesrghrmhdrtghomhdprhgtphhtthhopegtlhhm
    sehfsgdrtghomhdprhgtphhtthhopehsohhnghhlihhusghrrghvihhnghesfhgsrdgtoh
    hmpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopeif
    ihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepsggrohhhuhgrsehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:jxnZadDWZDmIVxJvKsBItRlQwa1bAspYS_DJ1quHl1LOpWy6KegADw>
    <xmx:jxnZaeKVowQ4YWpymoOU-KNJLQJgIZc3wHBupXIaWZfWnesBw1NMrQ>
    <xmx:jxnZaYGLwXTamTO1ad_rvxoJoHNZWkun1S95zoRQEIwNvO4tP8l2sQ>
    <xmx:jxnZaZE_MMKcu-jSsK7qK07AX_CerSeGhOAKpTk37iG5kJZvQNa2cg>
    <xmx:kBnZaUhNPTInsFB_ZJfxEYnJSm1s98hOfA68RiFjoBL8FHAiz_tHIZtn>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Apr 2026 11:38:55 -0400 (EDT)
Date: Fri, 10 Apr 2026 11:38:54 -0400
From: Andres Freund <andres@anarazel.de>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Message-ID: <iqz3kxnhilg4jyud47mafl46ftytdmyvfc7kentoo234afa3i6@zemg7yixpqeu>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
 <s2dr4cedsmqby6e3ijauv5p55vrde7c4ldyk5gxdw5iku66rbc@x3nipjpgqjh2>
 <F4DE9305-8D16-4DD5-B988-FBF5C8BB7B57@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F4DE9305-8D16-4DD5-B988-FBF5C8BB7B57@nvidia.com>
X-Rspamd-Queue-Id: 4C847140002
X-Stat-Signature: af8gyohtdwk157z8ejp7bt1c61p4mjee
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775835537-443233
X-HE-Meta: U2FsdGVkX19a72PGlIzF5W2umX0DotVg97mkTJ9H/Pf9Rm2E1n/Lr6/nc8oDNvLq0jbi161NHZm8+bGCkmoNSFQuEttBU/vW94ujbsCa1TxEOJSQAS1xgLAw3tPC76uUBeV2NliSJlYEwWGlhIqwL/iqjNMPYwfzAYqkySa813m/LlEUPbHy4vb/7q3SOLdZwNPdXvm77Ujr1MipC9G9V7TA/o/HNjPc+yk5EnOQLCfByRNYT/CwomwBFOnRxabhJjoo1P2JGh6HDUenjqGOI5d4oEbYxfzpgSoOrv0ZguH8c26NGQsL6HYhUuYrbqCrGbOeQV2ENewTOm0OotS20LdPUn5sn9OkVeFAkL23gqs/ZZw3q5AR1LwboX/pc2SPYXWih/067Wic2jT8IQR6zVXZaIxywjytC4gtZWEyzEMopmivnF2ktR6kQVYMn1CE7gKfublOFBDbirKRWb7hDS2fNIh0I0kRVu32gV4/yrVXJA3/Gc2VpRfyHYGenhoH+GShaPPWmB8J7gQCP+NEHyJ7s6dGYX0KXTzbGDgMVvY4kQw5ppnmsYl+uIPJREbWiRxCh/b0Q1g677NDduGcDUedzsuAE60b/sVuvXSP3bGbfIRDYHLxLzaGjyH2sJIcxvkK/LvEWvE3mdcl60t34INFnvpy2iOf56fbrkrEXSrLkfQxWgPLCaoUQ57u6cmy7uPNtA5s1RpwqS/8EhF32DDrkDr5bNCbUrJNrBpCkZMao8MN9YEW4pOMXW1cwq8Cr0nw4bHQ38AIxmBqkRlVILcflpvzPMzEq1lQVhLUXtxMS/waGGicm5Rk7myIlJvzV6GbxJ/EqYiKqSjeFmo1woy3qDxTqbKTFaHB8DrMW951cRY7kqUa5i63b35Kjzbhs3jp8OYYGI8lZnh+/r7p5MmndboJQcrZyPZoHflX+EyrWz66rhkix8OXV6+dHi84k+NenDjUrJbxzr5CM2G
 1PsIUHCt
 NZYCHTlzEsckTR3WBBBkajTI+LwLYE/+KoXf8kiOcbCWwJXTnD8um2A4LxR4SkRPi9EAZ+TgB9oQWuTXI0KGAwhC6t13cbRr/lDFzct4EAxhUz5bzsXjOeI7tTZ3F7ePtKygghfSeAvt6Q76MgM92ljXXhy2RS198p1uz2gjGDji8ShdrnF5r6l2JgBq22CAQ7RrRCehAplSwnngLCG/KUPG+/eHSlHhFLLTicYhoLaZ0u/9sQRQshzqlNJwjitnXEORWE898g+8f4pjj+TfHSbstXtZSsG+HzfU7ApnJsdE+BBurQaECPG7QE8G9f6OWYz1OBtm7/iUHDYNY8GTJ0nMriWm5r9k5xhiIOK219K9T7PSxSnD5Nbc1arBQrQlDGr+sfVgTfnuZtxm9o0/B9rWaug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2026-04-10 11:18:24 -0400, Zi Yan wrote:
> On 10 Apr 2026, at 11:06, Andres Freund wrote:
> > On 2026-03-26 21:42:50 -0400, Zi Yan wrote:
> >> Replace it with a check on the max folio order of the file's address space
> >> mapping, making sure PMD_ORDER is supported.
> >
> > Question from a user space developer (who learned of this via LWN [1]):
> >
> > Right now MADV_COlLAPSE on file mappings appears to only only work with
> > CONFIG_READ_ONLY_THP_FOR_FS.
> >
> > That's pretty sad, because I see quite consistent gains (~15%) from doing
> > madvise(MADV_COLLAPSE) on e.g. postgres' .text - but because
> > CONFIG_READ_ONLY_THP_FOR_FS is not enabled default (or at least not commonly,
> > I think?) in distro kernels, it never quite seemed worth the fiddliness.
> >
> >
> > Do I understand correctly that by replacing the check here (and the
> > predecessor commits), madvise(MADV_COLLAPSE) on file mappings might actually
> > start working in more situations on typical distro kernels?
> 
> Yes, assuming your file system supports PMD THPs.
> 
> Based on[1], ext4 and xfs have the support, btrfs supports large folio but
> not up to PMD order. I have not checked other FSes supporting large folio[2].

I personally only care about ext4 and xfs, so this is awesome.

Thanks,

Andres

