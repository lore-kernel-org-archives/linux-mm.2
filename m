Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6A5BCA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 11:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BECC6B0088; Fri,  2 Oct 2026 07:16:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46FD96B008A; Fri,  2 Oct 2026 07:16:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 338AB6B0092; Fri,  2 Oct 2026 07:16:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 049286B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:16:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E7B91C385D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 11:16:05 +0000 (UTC)
X-FDA: 85277431890.02.CBFD602
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf19.hostedemail.com (Postfix) with ESMTP id 809BD1A0010
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 11:16:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="F 6e8jeA";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=caGEv8CX;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790939763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6P809YcEFkgZYt3dJBX9HFU16JBGD60jWrOGj9WhIM=;
	b=4BcpS/F2ZgX1Oq39bIQLNexB4tt3COlLcp/uguPbCzI01z6LLY+W8uvYHGT58Z7Oc+2GGj
	BUrpatLE4qWSHNwvcQFhujeaRC/CU/QVLCJmUayjtN0HMNvxg3RdQJ3uj4oHseo3QM6xdn
	kJBUx0brJt6HLM/XB/MIavzbpJenbpw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="F 6e8jeA";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=caGEv8CX;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790939763;
	b=rIKYRAtrX1pcz2G6KzhW23As2GC+4irtyVsNtp46wYSBKf3196bsT5LXCGwFaKMW3wxqZz
	f44w1dLB/Iobq8LPp5eNThhhi5pGqlmJXZUx6Av20dPK1QKajmxsOaQmR6tdgrIgfaEI5A
	OuFkbHSYrwIjjn2AHl+i4AyKp/C5wyA=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 0B0E4140014C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:16:03 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 02 Oct 2026 07:16:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790939762; x=
	1791026162; bh=p6P809YcEFkgZYt3dJBX9HFU16JBGD60jWrOGj9WhIM=; b=F
	6e8jeA3Sjgohv+3K5lXyiBi5JOgA+lmGMiUKerbuNQLJmrCfx9vzND1QynNHPVO2
	Fk5lafsqpdcvaLD7FE4U472GAde2vxEkCqVXHM8AWxcL0Eyfgtt6ffuO6QUwMZVR
	2WeRzSj13bTWmwgY/d4M0Bg71/Z0datxnjPFCUOK9DmgNOYHlybwsrX/fd0AgNgW
	v1LoEVyQUWUMyTTtdfybiQSctv7BT6i+wDFmXdJZp50mL2u+xa+aNsyYvu789cw4
	kqDRK4yxzdx0G7u1nqmYEnvTwFYJwGjVpopSzG+BYdgP+sLww22fF41QJ6wSFiw0
	s8Pmicf9VfZv+4BVStX7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790939762; x=1791026162; bh=p6P809YcEFkgZYt3dJBX9HFU16JBGD60jWr
	OGj9WhIM=; b=caGEv8CXFpU5L/754PZtURUwBdWoRG3+RoXodZdqeXP/P+7MKv9
	ZCrtXzmWxso2c1hRadrPbGbSMltSuhjyga4luTSfx/Td5N8hlyt2y6iQzqm0Rf42
	DUSXBC+alfkiMeTM2kZlJdIAsgw2Fnx2Jvx2crdYvxrV+oVBVTLWVgWgGuSvecvk
	Trg5MeeB3MobaBmzrSzDWMN90Kqtzm3iTvrzJfw29NIxrYnFTJ29GasDKJ/RV1PQ
	us3gKgwwHbL80eqoP++ypWe0EoaS1SYpEnLgXlbxPxyi0wWTVo4FMeiH6hP1xWr6
	SuOpfjBbkJQUrXFlJ31VYk2Ohhlc7dR/P9g==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790939762; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:CwMz6ygERAbeDPT5tdZJxuezjBmFbfCwBy1RdYbhXSPD/lF
	r9Tk28dE1xnpqicMbZ5mW+u5UcBBU9NJuPzY+a0O7KAYxxuXuvaNq3esvz5GWOp8
	bTPPhvHsLv1QEXD2Kn/NSr7KjmlwTJ5TUdw/7hppDBCBtyS+WgcQnHWpPDDcyX09
	pGmHGM86Ns3mRcDga8NX/75po7iFL10Zv3GJxkNetW/zsCXqs5w5YmBHof3wGacn
	AcsXjiAwdKCka7eWyyo+sSnwaoxRK2YVoyvbgSlmUpdJwcSDma3WfnmfQC+qdHn4
	DeVp2mtgD8q7ZnUBFpvHbt3hW3b0TZ55uazii1g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:bMo8HEqw+XiMNM/BAcO6Jb6FU65Q3QvxVC76RxujU7U=:rLjD7PTRxRLm6zR7cdPqYXDYyMN4xlD9erFhXKlSNn8=;
X-ME-Sender: <xms:cZK_ag6-CP6f_gb4D9vDrUfKp-kO5w-tbenjwAuJx9mWU5VIiGin9Q>
    <xme:cZK_assRmizyXeB7qZONd9_cj0AasuywH0VBcJ01oUWCh1xyr4tY3CiPq4YB16nXz
    X9WIJWDhA8H5A-GQlht_sY78I8qqaAlE0GEg9z7YIRxC9vt_PISqtk>
X-ME-Received: <xmr:cZK_atvB4az53u0LPZllRCclPWfZnepNl-2tLnc0qjPBWYF6SPHlsz2bcOw>
X-ME-Proxy-Cause: dmFkZTF/1tmYHgENW9/vj2pjkxCWxNZLy8cBqZqyG3QR22/biSzxfwGmM0SNSCX6B8CTEE
    sTzdhH4DefA/ogWq1+xZTNoNZrv6+eNRhC6+EKZ43s7HCM42zfU73HzR2hp18zMWUeDanj
    nxI3Hsq2s2NNJtxrBlAYWBwbjBSzuVnIQ62G1K7EAvF8nxwpnIK8LqmG8FleX8g1/NWWpi
    i1Eh2+rwWq/y+BB22y+2UHlhiK/LMUG1G01oG+O68qFEFivbqh0vsu2iQJcAgmsoyUHgKb
    2X88Uhgm2hGpfWmFleq/C55jouc3ELdga+uqGFmcFxDT3Q/oEEbXjFkgRaCAjW0VAlUlRn
    LXrejEbLijsGaWjNJTbbc/kFtaVuZERxtZs35DIxuCMbVK1PbOlz+gLxbYzN8M7tlMJrXb
    H5uKuiaO1wu3o6GytFsZVTuVzV/AzbDF98dPu52yFu+a45CF+Kf+AVGMuCL6SpIpMisDMu
    0wxgfWqDeTJc//eTAYYV8TXEO0GiIKxfOHTycUJfvcnE4hXUDAw7zG3CXh8cZlX1wNEc8N
    ThB2MNbWoK5+/sdViJhb+PNKJxmKRborKpl5atJcuQKgh0aRJZQUeAOYYa1ZzfDHj3WRcx
    Bni6Sf9xGhOISLmEPi9f40Y0UDnDSYb9DFWqjbqmIKjw56KodkXu3u3MpcCg
X-ME-Proxy: <xmx:cZK_aksEFhpnf2XrsNIkehG_MjzhnzDXag4QhVowuDSSLodFy_hB1g>
    <xmx:cZK_at627sWI4UwsAEjGi4nVkv1kWsFyI5fHLsy-rvBaWfLyfHYs5A>
    <xmx:cZK_anCbdeKfxXLXEBQWC4AwHYFsC-_AY3rYHeGjX9R9_M2gwiPsaA>
    <xmx:cZK_atvqTj6y68xOYjd3PE6Vu9ALp2gQG3B6BNdDCaZa-VlXoghpmQ>
    <xmx:cpK_aoT9JCIbXUKFqB5glVomIPxrr6D9r_jz6HtYdW7-B16y63O03yx6>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Oct 2026 07:16:01 -0400 (EDT)
Date: Fri, 2 Oct 2026 12:16:00 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH v4 09/13] mm/collapse: separate scanning a PTE table from
 collapsing it
Message-ID: <ar-SFw5YYJhv7esG@thinkstation>
References: <20260928100630.21870-1-kirill@shutemov.name>
 <20260928100630.21870-10-kirill@shutemov.name>
 <9bf6623e-ad1b-415c-9720-6063a1ac11ea@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bf6623e-ad1b-415c-9720-6063a1ac11ea@kernel.org>
X-Stat-Signature: qfmsus6frt6htc4okczokmu43z9bm6bq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 809BD1A0010
X-HE-Tag: 1790939763-862177
X-HE-Meta: U2FsdGVkX19adxWNNvHMO49ry1y/VphSSKA8UerhNX5LzfTtFbT2uj/LTiWMZUM51E2iPTOacwHUh9NXKP4PpWy2Aape0/rAYWq0AEFqnG4QFmHtvorSeTCSsaJVgWB9JxqoqE4ec/4SycKN3WEDgpgnyW9NIj9H7jdiI83KhdEKlvCbyJNui3uH7SKN47kohZpea7r3af1N72eKkuEDEUD9C1MibWkWaXSs044bVjAU1HRRhcPIPL9upulzhBh4JKrfEZZb7Vj1T2aSbK8A6X9UuRaW2/VHSJ5J41mwaS4MtL2u7v47iQL4PuEckzfyhoRI/aqR5hIx1RXsQxb9EBFw52MSQLHH6/qNRwweqhU2VKQCiQnQN8wOQ641qWDbDJX9wIdpJfU8JVhB0s+8dMbInyHAL7vj6SRSXotZ8Tto9213npP7KZbeeZR5WgNacGgaf/VYzt26lCWZEdpWHer+AFssWUpYcHhsQrdxNcrWnoAaGOhOSW1hogQBlhK7JWiaMgDsnsVllEPdYEb3FtNPxw/ypsJZyPA6kB9pvn2KGARLpymYg0RvzGhEozbmUG/o4WcpHLO7lqbVihINKFD9VxaGGXXw5U+1fTIHb0GMRUiGIsOXhkhJ+Rr/ReuV87IBuPTpnyO3ZhrYM4qjHTwziC1RRGh6egV2u22fvl9s7Itts4/hWPwJHxeGtnNI5Uyzwl4GGPvKMgU2AXlRhDvkYtrk51u/7LIsgkPCUw86U2umNHhW+tXt3cF/hDGbiMnUEFlW8QopmU5Wasnzpr4fSM64AjRhUT4Q0DN/JPDnMNW9S+eI4TrBD7AK9NidafK8FCRu4P61Wzn++R3t4Wg2wXwuwfKPHZ4WmmgT1ML8xokhRz8ZuTWkTKslPyTdFLPC0QsiVWFV5rAmkYo0zWW7NYEk4FNVPWNBFp8OvkU8CQji1itIbnxrUOvIP94+IsejZouFJDHuktMXI9f
 RYIRGIT/
 w5Aeguo2b6TbUKFjLZccUONc7ZnmGKGtwQDK4srt3m25RpnxmYUdWE/a3HTdJaYnzzWLpEF4rHQkIOD7TgGXFYrbWmD81Mt/LC32tn9PD0hMz/LFRzvaspCz62R3Rg7S+iuW3WBy5NyUmvxGBwIEeYYK7iLEfOBozpA1nIWa93lzWMtDDEa6U/p0wC5Cho6NSdWBgL3XQr+EXXaCfHlY7+U7ahtuOVsed7/d3+gkGvld6P2VIaq8dq5E8XLnxeporpI8flAsqDBh2QSmd2ZNwdG/G4/l8dqOCzZKZ5aWZkQkJKz6OULAdcr3X/YRh7/yDShBSAugnuPxKvg1DbY6tDPS7Ar7tRQ0fUmGdVWIu4t2Aczeu9peSTxl1Zqjc369Z5kRKUy1cNnSGK2N8rmrRZ1PFGcG1HUUSvuaMX81Fcrrbu9Hvm8S/hruIJIAQC8bk0SUQjRjxT+F38p5ytA1fv84xAJ7BbekfhAPaMgy0Y6CAbVedRJo/eQ7SN3PTxSoTGKr5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 10:34:54AM +0200, David Hildenbrand (Arm) wrote:
> So I suggest the following in the context of this patch here:
> 
> 	collapse_scan_pmd
> 	-> collapse_scan_file
> 	-> collapse_scan_anon
> 
> 	collapse_pmd
> 	-> collapse_anon
> 	-> collapse_file


Fine with me.

collapse_file() has been using collapse as the verb all along, so my
namespace argument was not much of one.

> You should mention that collapse_single_pmd() is only temporary.

Will do.

> I'd just not add that doc if you intend to remove the whole thing in the same
> comment.

Ack.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

