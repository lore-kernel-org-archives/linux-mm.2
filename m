Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FB47CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 19:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9B4F8E00F5; Fri, 24 Oct 2025 15:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4BB48E00C9; Fri, 24 Oct 2025 15:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3AD48E00F5; Fri, 24 Oct 2025 15:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 900FE8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:33:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3209D129EA3
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:33:02 +0000 (UTC)
X-FDA: 84034005804.24.5C35D42
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf19.hostedemail.com (Postfix) with ESMTP id 29B7C1A000A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:33:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=chw4THql;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="D 3AM57H";
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761334380; a=rsa-sha256;
	cv=none;
	b=tFaarTQjGm+oS5hseVS+ALBsPbLDI0ke4A1jBjQ1Z5mUgnDjrI5aaYZYeNSTez38mEbDTa
	AGGNTuNcrvC11jiY+nkVYAHZFLIKAPX1g0m/bl1fuuzpNehuhHIl3ODEtkktMe8y9uHzyG
	Bc15ZgbLFjhZPlNK07ncL/tPLrboJx4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=chw4THql;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="D 3AM57H";
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761334380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Eie9rhTwSUlY1W7oebxyg5hlbXGes4pkn2Ot5hK/W0=;
	b=kGhHJ4w0FL8/n+roTtkQ/o8vWpkJMrJ+t6ART/StwKIOgd8n5XT81e+irCsaYDkvohGOfe
	T6Zp/Xffo7O1sZGx1HjXyTgwWko+FsP393jXGgO6SPXL7gqwv2fK8hukJ7YzKd8KVw2dha
	ol0ys7GHdQsaTj5GdqmVD6/iQvzj/os=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id C06511300286;
	Fri, 24 Oct 2025 15:32:58 -0400 (EDT)
Received: from phl-imap-10 ([10.202.2.85])
  by phl-compute-04.internal (MEProxy); Fri, 24 Oct 2025 15:32:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm1;
	 t=1761334378; x=1761341578; bh=2Eie9rhTwSUlY1W7oebxyg5hlbXGes4p
	kn2Ot5hK/W0=; b=chw4THqlrwqSs38QX7V0HBZScQNidiSKZogcPrpPVGKNFSpY
	Hr/x/WMn6jcDRCRIZOqeh+04AX2tNshXGRrFGFFPzhCB/R1Yxbn/BRD+CMocWPhx
	UpBf+N5OpFp4lqNgOHwlKFmSPMJxD8VYzLeHinflFas7Ld3ZoqbcEQqiXJ+Z3xAP
	fCb8VUSRAqgkBqs7wV2j07myrIUZ6+GGvVEyjZUlcvZ91XU4e/x3XfM5poD9+QHu
	OJagCG04BPvf0fs7RH1Vqko1n28A/AqdD/RTHNQZVzUfitMiaYH0gHyQoRxFET6p
	cqGsM92yKgXdESHu8b2MZAD7FbQFbs+Ml/t0YQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1761334378; x=
	1761341578; bh=2Eie9rhTwSUlY1W7oebxyg5hlbXGes4pkn2Ot5hK/W0=; b=D
	3AM57HqO1i+sRH2fR79zXWnSCId0q9IG98YuR6VSFOQGUhKSutqJMChsDLj/Q7L8
	yRv4VxnZju07Q9kZijHV78l8O2wKbfusNAjX6uQzY7sPxg2Gs/Rxi94yw2DyGXe1
	brZLqLfUgrH/eiiEFLDTB3k474jQq/i9D2lnlg+u8wxFgi/pIAx6UB2lZeZUiyKo
	+jKGYD4ZIVFHHKPB8YCAa7hdkfBWLFVvL2whsdr0dgz3YeV6J9qOeGLWBiMmo5iu
	rlz9ckZvDXJLCd/aR/cvyC1mVkfwHKTs/yIVTSZb6GfUdyBGBBbNxS5j8wpuygxC
	fwPJRsyOxvr6PwHvKmG4w==
X-ME-Sender: <xms:adT7aLrpDPQZGVa84VrLn300BloDRka_Xr4eaWU4ja3qoCoIjmh71Q>
    <xme:adT7aAd0gyIgXgFgJ6m9vi0bn0ShQv6mIHu_eH2ssB_IpNsPVjpLL9NN6UqSlFbOy
    zeK2Os0Ng_D0EzLwoOIOmVpDNzRJLXJxrZt0iqRPB-m3wUNHO6V2Wo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduhedtudelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedfmfhirhhi
    lhhlucetrdcuufhhuhhtvghmohhvfdcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrg
    hmvgeqnecuggftrfgrthhtvghrnhepfeehvedviefgueevgeduhfffjedugfdtvdfhvdek
    uefgueffteegkedvvdffteffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgt
    phhtthhopedvfedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohephhgrnhhnvghsse
    gtmhhpgigthhhgrdhorhhgpdhrtghpthhtohepuggrvhhiugesfhhrohhmohhrsghithdr
    tghomhdprhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthhope
    hsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhr
    rgguvggrugdrohhrghdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlhdrohhrgh
    dprhgtphhtthhopegujhifohhngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgr
    sheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:adT7aFyRBRSeVnGi14kIw5Ck1L7OlC7KwIMqpMZgk5v61oO8fcM_Xw>
    <xmx:adT7aA9calwwSFl8H5vxhd7a94GeP9js63aA16vdy4NfsUhN7tM54g>
    <xmx:adT7aKAFG2RoCob6uF9S4yaeS54QhsKtAt-fxnxflvo7RqlSsAM5iA>
    <xmx:adT7aIdsOaSSwRDxprKYwXiknos2gcSFvlRqyzRQm_upT8MpgRROvg>
    <xmx:atT7aMGYELrvclqCX7O2E_660PuNtn2jwY1SNpAHOUyXq9fD6wrjUE8C>
Feedback-ID: ie3994620:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 18E372160065; Fri, 24 Oct 2025 15:32:57 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A_7exwu8WuKB
Date: Fri, 24 Oct 2025 20:32:36 +0100
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "David Hildenbrand" <david@redhat.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Hugh Dickins" <hughd@google.com>, "Matthew Wilcox" <willy@infradead.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>
Cc: "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Rik van Riel" <riel@surriel.com>, "Harry Yoo" <harry.yoo@oracle.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>,
 "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, "Dave Chinner" <david@fromorbit.com>,
 linux-mm <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 linux-kernel@vger.kernel.org, "Kiryl Shutsemau" <kas@kernel.org>
Message-Id: <ca03ba53-388d-4ac4-abf3-062dcdf6ff00@app.fastmail.com>
In-Reply-To: <18262e42-9686-43c1-8f5f-0595b5a00de1@redhat.com>
References: <20251023093251.54146-1-kirill@shutemov.name>
 <20251023093251.54146-2-kirill@shutemov.name>
 <18262e42-9686-43c1-8f5f-0595b5a00de1@redhat.com>
Subject: Re: [PATCHv2 1/2] mm/memory: Do not populate page table entries beyond i_size
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7oopuotfg1tgty91eq1mf5tc9ezo8p67
X-Rspamd-Queue-Id: 29B7C1A000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761334380-322900
X-HE-Meta: U2FsdGVkX18hTvngbuE6gGrVsWUrx+nYZj03dijm8fKJUP9Si96rVW1vaWJQPSb+yNmaK1ZgAktfosjQirUNpq4+LqG1uOT4BfcJto28B/y9eEn/Tv3f4XamguJNqfk6qonsUscZHLQScgOJcpB7rOF0Pyj1Ump+tjuTa+OomTjpRh4qtZ9iWb+XnoShQ5VSxuvAjvukajZyzoNlljc8Egu4qguiMmcLZXuZA/mKiu0uuoRpgLvQnrxt96H011KE2mCqVEVpdFpcJA0hzd9Ukh9gm+ypAboNtTU5y+Rzk6BUlytOuD/bMO0advXsuF3kBzgBNUhMy6Wq9gUKxt8UA1x/hkENAUaIGuY/J0HooUt/TlbvFMRIPtD/RXtubORGB82Ib1RZPG7oDqrIEj55wwbs+Y2Qrt2FKhKsSBJJpeyMxvurdxGUPkLbTwOTOUBVvcdaGsqN+vpFMInHRmTUUjwydlboaQPj/2sQryCZLC81k5aoHdkepSexM+UE2cFwoLS58qzQX2J40G8TSCGspvjATOGpoP9hDzJrVb1ba2iWn+wSYEEyVoMuJjKidcsrefTmaHYUsAXh5ygUSowBku7EYnLrW34F2a/8r6SvsA/Im1XF31NZWvpxuByKlThqDmROHAwBGeurwLmyhrT//samjwEKViz79GIZ6DT9NDGHHxVOY5w4FYaBME2h4cU+sMDpNftQZoT2HfVVBWvH37MJJSGTnnYYLd48cb1WfqVFGzXURjz55reThUq4/o6e0uY7kdM2XtPjRppyb3gaS1jFk5IdeGvNm7vBIQsyWUXOVNBugGS2xfbtxYqonbv5uBRB9luNy93P+Ku4u/RPss1PYTa3IRbhGfSrvwcVLgGWxQFb29geEYUNuilCHiaRthImt7eyxBMIcr+NomsoNxwzWGqmdk+kWQvAwhxFgcvR3w2IJ9bTus2uET4AJF0B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Fri, Oct 24, 2025, at 16:42, David Hildenbrand wrote:
> On 23.10.25 11:32, Kiryl Shutsemau wrote:
>>   	addr0 = addr - start * PAGE_SIZE;
>>   	if (folio_within_vma(folio, vmf->vma) &&
>> -	    (addr0 & PMD_MASK) == ((addr0 + folio_size(folio) - 1) & PMD_MASK)) {
>> +	    (addr0 & PMD_MASK) == ((addr0 + folio_size(folio) - 1) & PMD_MASK) &&
>
> Isn't this just testing whether addr0 is aligned to folio_size(folio)? 
> (given that we don't support folios > PMD_SIZE), like
>
> 	IS_ALIGNED(addr0, folio_size(folio))

Actually, no. VMA can be not aligned to folio_size().

-- 
Kiryl Shutsemau / Kirill A. Shutemov

