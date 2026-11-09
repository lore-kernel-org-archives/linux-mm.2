Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67105606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 11:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PPSzIqD8
Received: by kanga.kvack.org (Postfix)
	id 7A8A36B05B5; Mon,  9 Nov 2026 06:50:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759686B05B7; Mon,  9 Nov 2026 06:50:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649276B05B8; Mon,  9 Nov 2026 06:50:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E0C46B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:50:31 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A7796C05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:50:30 +0000 (UTC)
X-FDA: 85415413020.23.593A1B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id DF60216000A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:50:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PPSzIqD8;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794225029;
	b=l1f63BAtjUHfa8zx8bz2RQIOT38DLz9undsImoaLkjoYlYRuw86663JbnQ0OOJR3pLbutA
	rmpDlDgFojo3Kd4Agdmv43BgDIkP5VlAFtJmItejOkZ/0P//18+O6+6HkvllOg5dv5EB53
	fXmeYJPKfstGSRn6Gbo6K6I3dtI7kX4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PPSzIqD8;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794225029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Exoo2CmOlzngpZBFMsAcvX6yQB+s302nR1CiYpzE3eM=;
	b=QxHePMbO53QmSvjQncC+rRSGaCPymAyhICjSctMhmgUX81xkP/flf/XluVhKoR1Ff55QtN
	+9JlhfVTOp2qknO3GJ+vxEcEZNX2ZycmYPFAS8bgXCaLruPvGTb2b/ScHW8nW7kePVPcAQ
	WR7rbrCBGw0fL638R7BTIldZZ0ffEDc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D8FCA438AF;
	Mon,  9 Nov 2026 11:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00191F0089F;
	Mon,  9 Nov 2026 11:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794225027;
	bh=Exoo2CmOlzngpZBFMsAcvX6yQB+s302nR1CiYpzE3eM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PPSzIqD8KC/PuDyfIcG4TCHGmJCurK6iOEWZtaA8iFu8UDAgVHjQzyJOs8aE8YCgL
	 At941m3HjeRpUZgFSGef5OvylFwacttLmjZlLxqmiIPRk9CINHunqtethL8KVrh0F8
	 gc8LrODCFAY2Z9JG3XfuT2jbIDIe5rZdX3Ex5pyOK89nveg+WTKVSoEi2neOo4tDZV
	 wUb94nsWqMoEyoQqw8yhySJ9hfcChm5mFJaQqAtlM6yAVMDkqdxjevK769nS/H9HBQ
	 CA7ch64TWsbgpOSErIqZxp/lp4s2nMTMcQzyUYoeHB2wP+lA4JQ3QCOe9NYgn9kHKT
	 x2z1chZOgOAew==
Message-ID: <4932c957-f6e7-4435-afeb-ba45d01cda22@kernel.org>
Date: Mon, 9 Nov 2026 12:50:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory: refuse to map page cache folios that are not
 uptodate
To: Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kirill@shutemov.name>
Cc: sashiko-reviews@lists.linux.dev, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Mason <mason@kernel.org>, linux-mm@kvack.org, kernel-team@meta.com
References: <20261106144323.3634477-1-kirill@shutemov.name>
 <sashiko-outbox-202966@kernel.org>
 <8cd50b75-0845-4e82-a8ed-acfd3a261a3e@kernel.org>
 <avGvM5kpv_z2ezoz@thinkstation>
 <avGwAfK4I31KAPHl@pedro-suse.tail5790ac.ts.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avGwAfK4I31KAPHl@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7ghc3ir6eomo3jassxmapmhw871619we
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DF60216000A
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794225028-385837
X-HE-Meta: U2FsdGVkX1+PQ1Nao6dCU0x3mMJnONiVcAHywDAYQUM+12jgADreEPraHWcf3lua5X93ah3x3Hb+jF2CAMkJ11LqTdU5JuTTXq6f8czWM5TW35gTzq28CkhcNwXxCTus+vuz5XgFtWRhSwRmku1LCdP+CIWX0pVc4tVdcwA+bAHHBmFHdMCnMe/OtDe17Htqs29wEE028X/EzHcbhRKqR0j1AExa4AGwRgDc+4163EpqsPveCntv21ehqxf+7e4X+60hFY0rOHqNJ4ZsNbdr9msIhRC38Zes5BwpzPTK1SaDskgofO015AHOh2EVfDJSeRmTzZympunrlVf3s5mbOGWK3DXZ5NonEccmYD3jLRDl2rQbtmhR7LnwMoL/Opa2uTnzDksOLgkKW9lQU+ZF1pSLSXcSHKr/FmdAybjaNhgjqXvmTGeB4aQH2RvMdzS2t4luUi3Lhu02eh9XdjcV0zR3ib9DytArlaYbJUdCgyOKvr+kSM5NRl5/BC/YdIUrs+3KwWPcTxQa4WG2i+Pz8VKv2SANjEnhDHLcI6M6zzZCi0MNdb0Il1o1hvDRdOCBysRy1sMNJORER4/HWNvxGqmRq4/UgsLUYPNTCshPWS+aAP5XUBku2p3zwdWAy4Vnep88aLb7MG4sAtzzR0OL5tQdPClwAapQg7cM7oE73EOk3NghD0NWc6IH60ZGYOkuAcAR5SwtAAblf3RnTc+BBfytJ4fYlHabI2P4FmNT15Lm9NhENpIrTQ5PGzfdGy7gimVIAAT+APJlHk2LAMYVzs5fmLVzqSUGizdpAAFJhTZsJNXYKouMenKifUojXKEjGJBFxOBD5oefk6Z/mRCBmsff0yV0EzS0Zlf195MvMZ0ypPwzdIX50RBCFfFObG3WZCc9aQDlFo1byoifWew+v0DJB3GX5WuW4rloYqrmT0TWoqhXVWyXPLIdxv6tcEUK9cvwnC4dACZNiDASHf3
 sQ/bRD2b
 jW5miQin80trDgEy01po5IMld4rTsPls0xEWLwEHxs1zQ70i81QGbRMsV6tHpNQL9KGZTq2XSsRSWyC1VopqJ1TpeFlbrpKIB1LyY3xYGpyt5g8HWJVZ7NcxvlNOfc445vp+WNXryKH7okjiLo7HGPoWkEYopmsW2vEW0xZdsKJx3TjAFyhzhrDnZRpnxY8PHrJU6Rl8zxs8VHhc6TTUNYd1Mimf55ak1puk4w3ksXaQMSwXnY+DSILE/xOOcOEJNMKtbJhb3T1DpTG5TW3AVchWRToahDXIrgJ2A8sv4wWKqxtWM/rIQ24rIehCjdg5FIZ+Zm9f/TqqCcEn7ekJAXv/0uQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 12:37, Pedro Falcato wrote:
> On Mon, Nov 09, 2026 at 11:32:44AM +0000, Kiryl Shutsemau wrote:
>> On Sat, Nov 07, 2026 at 07:17:52PM +0100, David Hildenbrand (Arm) wrote:
>>>
>>> Kiryl, can you look into that?
>>
>> Yeah, that's legit. Will fix in v2.
> 
> Related: https://lore.kernel.org/linux-mm/as-fqjiGj5T5NLOe@casper.infradead.org/
> 
> At some point, if filesystems can randomly clear uptodate as a way to signal
> writeback failure (even without the folio lock!!), these kinds of checks can
> become a bit too error prone.
> 
> Perhaps we need to address this problem first?

Thanks for the pointer. Would that mean that we shouldn't use WARN for now, or
do you think there are legimite cases where we would want to map a folio without
the uptodate flag set? (sounds very scary and shaky)

-- 
Cheers,

David

