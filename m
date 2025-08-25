Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C879CA0EFF
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 01:26:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B4956B009C; Sun, 24 Aug 2025 21:26:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 965736B009D; Sun, 24 Aug 2025 21:26:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87B206B009E; Sun, 24 Aug 2025 21:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7657B6B009C
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 21:26:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E60BEB65B4
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 01:26:13 +0000 (UTC)
X-FDA: 83813539026.17.535446A
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id 25730C000A
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 01:26:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vwUS2sER;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of hughd@google.com designates 209.85.219.175 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756085172; a=rsa-sha256;
	cv=none;
	b=ieiaIKDYSqWmNOjN//5AuURe6V2QZwZCZ0gN0hEtLVtBoYCNB9rUfgxeQFSWepUIuEd9sZ
	Bnz2t0+AJD0BjGfKBy66j+TGzI5q9i5BeT7BE1WkZvBo0KXVuS6oxygMNwLFy5a3eB8TPB
	hAbjlLQmRCJbPtgrq5SzKyNt41XHX5I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vwUS2sER;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of hughd@google.com designates 209.85.219.175 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756085172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3aLhKf+1bQX6jPVz/mhVq6QH+09EMxI761Jrd6xObQ=;
	b=jb2uVNfRfdAVLgvrmJwBDteg3fVVsJKnwEXqKq522hWuyXYRSL3eHig3+xbjxaEAVODTds
	qn7jPo3Je4FK0UlBFXFuZ5q/dhu4yMLLufw7k2W6F/aBHAuQdJpyr/I5MeVxpVO2lrhWIt
	WKRje9akl6x9Eb0e5hrk7Voul0NWRuA=
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e931cad1fd8so3226928276.1
        for <linux-mm@kvack.org>; Sun, 24 Aug 2025 18:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756085171; x=1756689971; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b3aLhKf+1bQX6jPVz/mhVq6QH+09EMxI761Jrd6xObQ=;
        b=vwUS2sERxS8Tl93QusrGOsP0JKbXOqvyzOFkMqMge495SX/DlOOpota0th443ZU1mW
         355lqLLerbzEZWb/z7cCnDV75TeMTjXBiuy0O1B9MCpxpHYua3wg6+NNapzLBLzsVGo0
         WXBJ0DKR5AY0IyiFx9IAgLH9rKIWI4SWLB0k3fFAwWpN+FDxdYILM4DNpWAXJPrHB8H0
         hK5Ay6BMa5LD12TdHbAl7lkAzTkHF+Tm1OtWLgWmeHQtzuGIpyOhrsptjhw70ozidB+2
         lbmuHaKyxMJNiFGgWdrIkaCsDSN/D8VJ/kjsUyWxO48V+jvAkl8eG27fEac+E9UBH/VX
         EvdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756085171; x=1756689971;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b3aLhKf+1bQX6jPVz/mhVq6QH+09EMxI761Jrd6xObQ=;
        b=N0lvjcuwVq3DeJDr/oH4/MjsdkYUQrpfrBOS2Qm2iRGKGX3UcXnjzLbe8Gj9gh+E8s
         yJLeOy9oKyiJUh7D1r/Odt0SixYS/tSdHgKrBwDrWiFe04jcfTr3FpPw3suq21BuT8Q8
         y/Tt5T/j/RtqHM0kVJ6aVMIF85dU6TXzRkmXRTgMm8P+JdP/3PBJQZnzPALrowScCMDv
         RRRU1TRugL7ebibv1YcUs3SIi2KhJALdyyNliRayIw/Ki41hGbM6yEM0f475DtzVKsSG
         2dTSf864S5YWEyoXkZjOnSVNZqVfyO5l7hVWGmm5ZuUvflvRMcnPaPS67Va1+QG+1Ezs
         QSvw==
X-Forwarded-Encrypted: i=1; AJvYcCUNIeceWTFwsvHEpwULamHLnwsFrPHDPSB3mCnL2eXr5YEUsKi1P1s9+zWgASuHm441+EKT8ulLTw==@kvack.org
X-Gm-Message-State: AOJu0Yx2qH+vYS88sc5rPxXQ7TDIOGuEmXgp0WW2O9rwOdCWMKK+MguB
	huIoQoGe9BVghbASGJZg48LzPP09wiIaRaWXM3JT6BVW++BKaFHP3t3EbGiWDzwkPA==
X-Gm-Gg: ASbGnctVQeEJjnVENvKAYidcO91E5NESkxRo9Zc3waCWwFLmqRPGaPFcdtvjXCYUvWZ
	+uEWFkKW63RSlSeztFgIE7RsmtIDjvIaEVqVjmbDCkmdbJYdhyaxw1UJOdYuvNpDnDXxlkiBErX
	HojW/HSvJ7aDO57DAGDLAlEk9InuZKQDmA8YRD5rTrGUNdD2xaTqQ4uw0oPdsejc8SbkJzXG/jT
	h3kHTzWgkWr/Sh4Cefv3eK/17I6+kJYDScokYp7G33dFRmIfFEpCcaKkj09of1P7Tl3VQWBh5Rn
	ZiA6RS6bPnB4DPv3C+6CZJq5nw570yPsif+XmzdasJK+FMAtxe1MUveHSOyQqXuPZvEizYxjWAe
	PuNH1kkBzz35lPH56dPvLJXm6ICcr3iBdcruPmVF9vxHF2/MGtk2nuHyBfl4iuXiAxzHAVuK+V+
	lZbbnoINN44W6RUQ==
X-Google-Smtp-Source: AGHT+IESXET44sa1Didt3BQ6M8/RKA8XAwX3ohwCFfZmIhEtpdeEqGT4wCJzBu0c72swRla11eCTgA==
X-Received: by 2002:a05:690c:94:b0:71a:2093:3558 with SMTP id 00721157ae682-71fdc2abbd8mr130068847b3.10.1756085170475;
        Sun, 24 Aug 2025 18:26:10 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff1881f12sm14366797b3.38.2025.08.24.18.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Aug 2025 18:26:09 -0700 (PDT)
Date: Sun, 24 Aug 2025 18:25:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Will Deacon <will@kernel.org>, David Hildenbrand <david@redhat.com>
cc: Hugh Dickins <hughd@google.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, Keir Fraser <keirf@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
    Frederick Mayle <fmayle@google.com>, 
    Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
    Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>, 
    Ge Yang <yangge1116@126.com>
Subject: Re: [PATCH] mm/gup: Drain batched mlock folio processing before
 attempting migration
In-Reply-To: <aKM5S4oQYmRIbT3j@willie-the-truck>
Message-ID: <9e7d31b9-1eaf-4599-ce42-b80c0c4bb25d@google.com>
References: <20250815101858.24352-1-will@kernel.org> <c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com> <aKMrOHYbTtDhOP6O@willie-the-truck> <aKM5S4oQYmRIbT3j@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 25730C000A
X-Stat-Signature: dw1r4fe9ybjwkrj7eizxzsjjcig75o4k
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756085171-794644
X-HE-Meta: U2FsdGVkX1/znUuCppIEWIyQNzt2ieT+Wg4umcZMbLqXmn9zp9sPeLrHavX6Z4zeVoZQ4oz9A6LY6/iF2uQlJ44/Sd3eeOD6eMMJHCyYFmDiFRe3O2CQYIiBr+7JF45W4aqLxUFX6v95Bmb8YCTKHHLfFCTSlbkRNixJP+vhpqVLPRRmIU4uOqbvGaPlc2ZHx2GvIaKGbrFC3JwkugPq0x493Kirjcz3cdr1Y1iPjVzL38/5DIscJkOAZywjHfSJKVGpucYHQPOcvuBLEYdQA5uAI/EcZb4axFjFGOR0tdntBEBzddrfqcEqkl8UMvdnxh8hXgvSgqQIc5d6OkbqejB5MJi0Zb9ZkPbReFJb0R7Xfh8685XUEkr41QGg9HK+WgH5eMQcWX2JHzrn8qgOPVeRClnONjW9f2rl661qfk+CefWWaogoNOAxFgT3hct4EJ0oPO3bhA2sCZEO5Ef8HOfs2yvyDqsQdpIp/Ei1qnIlr6PH1f2xGd1Tz3/kUgMQc95DmFsKhYEYvrCHKu0H8YeTi12AYNObfzD+Njz6rCHM7MrkQPzeXV1btj6WMz65PmRc6Cd4KKYlKFQIJh4tknXB1QCuVvxi/eLnjbg6aNKJCdPpPTMU/qxpqKGOrzlDjY9NIkOYxEiSYmoJSBSmH6H1sgrAJgmelArCjV2wTGvaTVZfkSJWqCqlkDy8KpKc7/sLKT3QDuuZFJKdl/40Wg1AmzIHBW67nuXtBaJWhkIBEWTh6bS9qs06P4cPxtuUUDhSefr+y1VE/m9QSgv5ee3w8Hymam3eO4ZUhES/Pvr2zro5R4OAbsU3zUqS244UOQG2eisz5pgxRaO78zjqERELdO8OPrXf53n5QHsbCwckNK/pR9gzkExf70CU3Te35faBVzLfOYyNb8c3ijue4TwrFM+7MHXEhH3kOpp8OgZTi3f5VihdBeBZhyawuQyfNwX0aV64EF8rm2iF6SW
 9/8Pe49Q
 rZ4AMLbqD8loEQI2eFN6A4KprP4aLIRx/uLJr+kzt5mji29ghbylhec5dlNoEGlaqIMgEgwW2WkPl2GHXdMV7VEBwdWMza4wTTt5Ypa47+b0vrFQYt74j1LFlYtQZg8dJVJbF44ahoQyPCCsqGTxGDi4yuIFaH5ngUoF6i7SewXhE9bnyrIrTXldRxsvSEVEgV9tBzpYsgmOGhw/urIq9jJHhvXsEnXaPSLjQUEr+moarBjo3MsT2eWP58m9crkykZont+LGmH8TRH48kIEaGp2hMrcQEXpocjLRXFUlbVb0SXkPW7tOz6E2WUOfTJ+74Kt3NuwwPdPjxQIGo38S9oGyyIDePr5xU0DWOLBLmMzv+bV0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025, Will Deacon wrote:
> On Mon, Aug 18, 2025 at 02:31:42PM +0100, Will Deacon wrote:
> > On Fri, Aug 15, 2025 at 09:14:48PM -0700, Hugh Dickins wrote:
> > > I think replace the folio_test_mlocked(folio) part of it by
> > > (folio_test_mlocked(folio) && !folio_test_unevictable(folio)).
> > > That should reduce the extra calls to a much more reasonable
> > > number, while still solving your issue.
> > 
> > Alas, I fear that the folio may be unevictable by this point (which
> > seems to coincide with the readahead fault adding it to the LRU above)
> > but I can try it out.
> 
> I gave this a spin but I still see failures with this change.

Many thanks, Will, for the precisely relevant traces (in which,
by the way, mapcount=0 really means _mapcount=0 hence mapcount=1).

Yes, those do indeed illustrate a case which my suggested
(folio_test_mlocked(folio) && !folio_test_unevictable(folio))
failed to cover.  Very helpful to have an example of that.

And many thanks, David, for your reminder of commit 33dfe9204f29
("mm/gup: clear the LRU flag of a page before adding to LRU batch").

Yes, I strongly agree with your suggestion that the mlock batch
be brought into line with its change to the ordinary LRU batches,
and agree that doing so will be likely to solve Will's issue
(and similar cases elsewhere, without needing to modify them).

Now I just have to cool my head and get back down into those
mlock batches.  I am fearful that making a change there to suit
this case will turn out later to break another case (and I just
won't have time to redevelop as thorough a grasp of the races as
I had back then).  But if we're lucky, applying that "one batch
at a time" rule will actually make it all more comprehensible.

(I so wish we had spare room in struct page to keep the address
of that one batch entry, or the CPU to which that one batch
belongs: then, although that wouldn't eliminate all uses of
lru_add_drain_all(), it would allow us to efficiently extract
a target page from its LRU batch without a remote drain.)

I have not yet begun to write such a patch, and I'm not yet sure
that it's even feasible: this mail sent to get the polite thank
yous out of my mind, to help clear it for getting down to work.

Hugh

