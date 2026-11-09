Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D1A606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 11:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=qsTj4MUJ;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=FecShwTH
Received: by kanga.kvack.org (Postfix)
	id 14FBA6B05B2; Mon,  9 Nov 2026 06:58:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127E26B05B3; Mon,  9 Nov 2026 06:58:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 016AD6B05B4; Mon,  9 Nov 2026 06:58:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC23C6B05B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:58:25 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 516241C3FBB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:58:25 +0000 (UTC)
X-FDA: 85415432970.07.7023DBA
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2A9C420009
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:58:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="q sTj4MU";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=FecShwTH;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794225503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2f74xI8ENOaYm5Fxf2K0EU/+aEKl3TphPyCxFled6CU=;
	b=PzE6Hwf2WkTIG84zqugTuaILFhmrMw6yWsJtoz9E9wFebmHSE072XBKTBI21DCoFy1AHlf
	GHT4PEFOT1awemAzMg5675UitCqdnyx2xNOHrzc3022UMETMmxMmrEYnhQ3cDVI8AryqTm
	IXedh4K143sArH0XC6Gb3mYEYFQvq8I=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="q sTj4MU";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=FecShwTH;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794225503;
	b=5+BBnrX6oUkUCzYg+AvMBwnN30G6Np1SwEVpLEIb5D3xo2VwRIaERhfjIQSHXRAHbrb7HY
	TylAg884BCJUvPdrgnYFcO7aHPb62cst+HO8Ktd3GT6PNXUmCHT5UqqShX4iwyT1Y/Ncqm
	LO3bjaxJWLaAPXmTrC+g/rOfBuU/h0Y=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id 966331301FF5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:58:22 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 09 Nov 2026 06:58:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1794225500; x=
	1794232700; bh=2f74xI8ENOaYm5Fxf2K0EU/+aEKl3TphPyCxFled6CU=; b=q
	sTj4MUJB9LnjMT9ddWekMI5rQ6MfnVa9ipVwS+H2fBwHe/DfEwD055meMlYZRstV
	UAGGbZkvi7d97cf6EbLVgU3kEIIn8O0ofrC6csuxwMhHOwxJIHGi2vyt35TBZ41A
	5O0Z15rOVt2B2fg93sTHnNf9BTeI3GJckezJ/SkLZjBdpzqIq7406ghqY8WJb4LO
	bNfTuEWE5xZu5yd+gBJ5lNAk95qbu8PXOMulaniOQ2gVtvA9ekCvxtO7CaxNQlHT
	7zWt6bleZgSWEHOp2orQYYTHUGsPII9mTXG/LfpfiZ9gvGiLyTCzcDDQZU+Y7hct
	8LWtIkM2vDV7LIhB3fGiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794225500; x=1794232700; bh=2f74xI8ENOaYm5Fxf2K0EU/+aEKl3TphPyC
	xFled6CU=; b=FecShwTHdhiR9AwHTjfsmdtyg5h1Xmh8oaoAgRhk9nikwOpQ51k
	LataX+4L9yYZOox7XSrQiGm6SuIuNau6havAM2rF9Njpc/qbWfOmGC50v+ZSWCxC
	uTGylQ++lirX9Lz/578E4XVhjMVbof1GBhuF2o0WE3z6Qbrk1LErac2n5T9Pyfug
	xFkwSCBi33dmn/1h/96GNfGY9MF30A28wQU4W4XNQnFf/pZ+fd1M9MSrx8EgicVr
	fqvjr6AUplf6wkK8k7T0jXqSmzmm5c/eU0ybMzWsxzCAsGJl7ogBZ5P9GncOUrdS
	r4Txumvi1t785NDiaDkrINk7q+kswkT0Vyg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794225500; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:ZXyGZ7W8gGCbqyXQRqqZgkN7F0qYbjxSgVmGxfHHQ3nuuDV
	K28DpDXTQGirVz2dXYF6X/R3uj/+zeuhD5WLwrWYpfDU0eK+X9sf4wwnzn/LwK5X
	yzdHukBcSjt1yoDGS9kGnO0jwmlAOYjT876U+FHi651pCH+eRCoAbSnaPzb8uav4
	mld1ewW0D8rCGS9IJqxeMWLf98KrmrJatA23wDxltxcytHwfhGN2kISQ6Aww1MV4
	C05X5loTUrNu9l+E9ZMJ0ljxbrDNtShyzNwe1eZ+WgJB2H1hvE0pNfbRFXT04+l3
	r53Z1S3nUPq3iH4VxvUEEtEzwlONANpJFfh7V6w==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:DwW0TWkwnhBQyqz0EkCMgRSesyG8g63gT2ui/HE93d8=:t7q5gP6od/flbVtBtebQGEUZvnyLJolctkwjR3cAcMM=;
X-ME-Sender: <xms:XLXxavxThDx3KML4QDtIECejD0S9tXBfXTiJ8QXjQjqqy7EcBd-2bw>
    <xme:XLXxanYKJAr6bEhrXs5UnTKKqAjSLPPfkKPeneI_zBAPSkFQHP-JPJfcrHrN-Cni1
    3jOU0-6CCJ0XpN0gJCF5Z01ssSJFLpNmQZRsC5nQ3fLgvIgsyOw144>
X-ME-Received: <xmr:XLXxanLWXKbkj24EUk_fxFv76VYbPgBJtO85BMPETt66UGzQKHRfubil808>
X-ME-Proxy-Cause: dmFkZTGkIihStJ7Mcmq5LDnjB5YEQJi8XMzYdh/yQxMmWscvf9u1zH1XQgYTPBth0AAHyQ
    jdFCb38Zp3R4bTIZ3PY9QbSW4/pBhbNhPt+KrL3Zufep6BcNhf2o0JXIP4mv8moVDKFblQ
    ATkO4XJ9KMx/diY4R/hBXfRI4w9nn/YxpX7bCaM+TvgIw8oCVLn6lx+Gr2Z5/hUXZpgE5K
    fRnq5VAvcYh9GLbhZTTTnpe+DsJucZEHkYXfMfppUfx7Pld45PnirZQJNYRyzg9i9809qe
    xHUNjsv1cyUV38v0nYt5Olfd1othXynNXM8dLj42EwQw+mYnQn5sj6/FKSyyzyoMH5mvKn
    E2nQvEAMba1Lk62MwKexTtMKFdFXBRzSQRXfbejhGgy8vKNYNVZVzVLAPfjzfnkwntU7pC
    GI4R5ezscLsCfBKfcbyhemZV7qJPLDJD6gGNFusgqBmhSPhq1puvBAKGCZWerShA6VYuos
    26hdPy0OqkBjUyKAi59Jc8FW8YT4Ra0Jybpvroj9nEBVSIC/ktAAplF4kvRrx7eGoDOw7h
    M2LiUMHq9NbUs4QjRarRzvhSRO1D77NBrt9mgMuupXWT25y5nKy4SWtSFXM+j7B/lalrYr
    9VJ9oglTUl6fyoZ/EKmgfDxGRGil2+KR5B0+yMgmc/ZJ7ul4vqHvnLXVQC1A
X-ME-Proxy: <xmx:XLXxatz5Pl_qRVcem_Qq7EaB1074dofQFkNj8LDUMQxASspbEhn2rg>
    <xmx:XLXxavO4NZsSIauJudFLRbY2ZggTjnAfR-P6VI-3l7gwEgKBdL_Stw>
    <xmx:XLXxahsFlEN-IlAZqgILwUNXPcxiXEcO4S87u9f9gna67o6_Q15w3Q>
    <xmx:XLXxas2U8sQUZ9RTlUfgaW-IRBdQ3MfJjC_tc-L9P51HupgtLnn8DQ>
    <xmx:XLXxat6y-Te_YlPNnU7x_VjMARnzSITKp35gE6pAZbz2hkd0Zf31Rx_0>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Nov 2026 06:58:19 -0500 (EST)
Date: Mon, 9 Nov 2026 11:58:18 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	sashiko-reviews@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Mason <mason@kernel.org>, 
	linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/memory: refuse to map page cache folios that are not
 uptodate
Message-ID: <avG1Rg8OyP74VIFV@thinkstation>
References: <20261106144323.3634477-1-kirill@shutemov.name>
 <sashiko-outbox-202966@kernel.org>
 <8cd50b75-0845-4e82-a8ed-acfd3a261a3e@kernel.org>
 <avGvM5kpv_z2ezoz@thinkstation>
 <avGwAfK4I31KAPHl@pedro-suse.tail5790ac.ts.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avGwAfK4I31KAPHl@pedro-suse.tail5790ac.ts.net>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2A9C420009
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: q538zap7qgqg4f4ce4ewxrmrhggijbje
X-HE-Tag: 1794225503-478322
X-HE-Meta: U2FsdGVkX1+E5V8W9fAJ2vl9bLO7zip+EfTy3Sn8/u1fLlhMsv8jStA/1K9PEwRIXSVqmk1RtDtA4IJB8w6QwCk5aN0of5pki8brr0E7/L3t81mwFXsjab1nFQkfHPF1DUfETVYYUbZYfJbs7RvAVERbDvC0K1enSbw7qo6pndiW42dfGaEv6Ooa4q0aooZT3NNPBA7utKi9poViovNpXZCoa48abCWs4cIAHOkcmelMwnEm/GrgbljA58I9yuE+GyBOtuVQzC5pU/o+oNrZbT2iQtC13HxoHsMs9Rtw9wuiiRcERQwPGksCnMB8g8giQHo35+zDfAxrO1ktd8Ff8hikZ1RkhVoKiFbSFyFMRkART5x/xBObnUNYvi4O1+qQru9EVL7IcK4KK520qnZw1FLL94jkKz8maLkE6IgdfkFxX27MGvhLZi6OZ3VTyosVCmpVfS0xhKxGjJIdZQYffFW+edGXJgOWtnCVkTytwAF9vyenJ8drkHsP/2nPZrGJmMTeiYbnkiWakRgVGW9lxYJoPr7A6Hl4U+QCdSVapd+wmHAvyauYltAY9/s7hhbEwtDXHWzWS9e1ZUWk5F6Ns9Voz34v6pamph5usQDnlHctsJ/3TDUxAoExEhO1y1vLSbb9fL6dUXYwAepiW3nqM65yvOkG9YBZ3feSLQYO3Ivr0kaxFI+g1MdMsPOvtPnMlmUuxPoDaY1Do2I/LpxJ6U/UUu2hudJNsqR5Ts3gmH/Z8mABhnEDjPGtI+h+1pn+8nZLkhsHNl8ArHNo8s6SyCiLIpmMacmalcPVkYd+mqyrgONB2lBdlbwGfzMQNoVkSTThemftfgCo9a2X4l/Nx3JDzlsxhn+SQ4n3xEgCMNgrjJp+GpJ9gq242of6S9EbXScQYslEbLwp63vY9hU5Tuh7QK3bRupUM5C6nQIRUtfRUqX++KzJFIU6T2flo8SanPuiw/gooe3EokZBqP/
 xZq1r+9l
 9rzWUfO011ypwGwhuQnLbVSpt9xPkNRUzSeqQ7JpMPLkjoN+Ep2ZEUDeJM34Q2G03+/BsJJ5iyCNOpxPgnVtTTAC4ZVMhr6WFTWsUtKpWKXxT6jTchrkwZ56Pykc7Io8xoOvQiTaUWFDuPLbuOq0JJJZ33miASxsttHSBeFcFWIscsivMrxAzsfItPf1uWrlLegefeuMz6vu+qtZP8VuCy04m/0mcnZfiEnM2tGdAKZGelmVmGZ68csHdlF4JU4h9xNstp/eBvvKlxMqYS7KJ7TLRmJWBPKYqA0+syIy4Mgwe8rKKAUl34/vGzc+4bMN7MQYuNKYKEwj0htUvgmGfgez+4xzBJTN+5ey/1Z7krtpdQeR445HjdhrrOaEghOwfLYUaryA0wJ9Al/r94yl4FTZvh0PA3HwuFUNWyxZRSSD3pN7usLTZcAdIbNqXpGrrxRnR0JVs9YSjlWKjHcZJDPLy6XdYspxogrRwYg6ZXCUzYCw3hzDy2+t7MPdUIuI8rL2nxxSwJtdfwPgg2WYRk0DYXqjpHAIvBReYDsIc+lUpOPpex3ZZtvWRnGOdGEgUqjyFwWyOUKDiS3ewQP5qhpP/jWKIEGzQSgZ5MBkI2ql2/iMyfEErmhEG1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 11:37:42AM +0000, Pedro Falcato wrote:
> On Mon, Nov 09, 2026 at 11:32:44AM +0000, Kiryl Shutsemau wrote:
> > On Sat, Nov 07, 2026 at 07:17:52PM +0100, David Hildenbrand (Arm) wrote:
> > > > - [Medium] mm: missing folio_test_uptodate() recheck in
> > > >   do_shared_fault() mkwrite path
> > > 
> > > Kiryl, can you look into that?
> > 
> > Yeah, that's legit. Will fix in v2.
> 
> Related: https://lore.kernel.org/linux-mm/as-fqjiGj5T5NLOe@casper.infradead.org/
> 
> At some point, if filesystems can randomly clear uptodate as a way to signal
> writeback failure (even without the folio lock!!), these kinds of checks can
> become a bit too error prone.
> 
> Perhaps we need to address this problem first?

The clearers Sashiko pointed at (ext4, ecryptfs, ntfs) hold the folio
lock. Which one does it without?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

