Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B98FC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 17:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5748B6B00FF; Mon, 17 Aug 2026 13:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 524D96B0100; Mon, 17 Aug 2026 13:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413F56B0101; Mon, 17 Aug 2026 13:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 205B66B00FF
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:32:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F04B81205D2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:32:27 +0000 (UTC)
X-FDA: 85111455534.01.F5A0BBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6032C1C0008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:32:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iq975uFa;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786987946;
	b=C4IYtRItvhvIAq8JICbS6JjKJoqJX8xNgppfvfeLiPraUnIJkJscRdZ+bbl/vVLWvaIvaC
	sFVMjT4iwX6d0NEipmLFmL1mszazSwhgr7RdK3MscrDnypN2eLqpAyN847AQcVGezncFkx
	pRDvHYVRKnoR+ez4oFXT99Pml22lU48=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iq975uFa;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786987946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MN6diR8GeSzCKvRRKh/mD2MDugE3edYYYYNW6HjYy5U=;
	b=Zqk/2eFnJzkOMIq9v9cjHPtMI1xGmS0VRIPxJ1ALOCnOZnYWG9Pcb6bOBeML5+f+QKLA8w
	Ly7+CyZcspuuC6HgVU7sGJMvjPw3EZS9v3IDTIkiYut7ADpSNEUPbWXexst+UII7E9NWXO
	t2xVxC2ATpVp7+5qmlHjwKOP31nwIRg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA4CA600AE;
	Mon, 17 Aug 2026 17:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE62C1F000E9;
	Mon, 17 Aug 2026 17:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786987945;
	bh=MN6diR8GeSzCKvRRKh/mD2MDugE3edYYYYNW6HjYy5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Iq975uFaNu656a5p36jXXMjkHcwIWAaCrKJvkDmPJqkG+AiuoiVfT2HC5ckbW7Id1
	 OCg0Jt5MdWWmhCyJPkdwx8+HhjKQFNuwa7GX1vRdMTvINpRD/iljBeOni4uUNlKzFx
	 y9i6vdn+N8t8b/BY54ez+38Bv/CenWXCcLqs96UA5NvTwUjL8gWPbXRiMoHiP1KLJl
	 Bke4GkqrAJtxrpVDE/6yOA/FEH+irgYxYGWqwb9DqoD1Sd/NsL3MnZgsZt7kISiA6e
	 bzF9kOeVcap8oaZ5mDTU3rQTB5dSLNOrgvFymPxxt8f8ycJ/yMYAfN6eH49WGWx/Uj
	 wQVfDV7WK9vEQ==
Date: Mon, 17 Aug 2026 18:32:21 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hyunwoo Kim <imv4bel@gmail.com>, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] selftests/mm: add stale walk->action race test
Message-ID: <aoNFmM1Ozt7PaOaJ@gremlin>
References: <20260811161949.3879321-1-imv4bel@gmail.com>
 <20260811161949.3879321-3-imv4bel@gmail.com>
 <b27f03ea-414a-4ae5-9649-2a05398fe082@kernel.org>
 <antoRbvwXVxoQ7Dw@gremlin>
 <0ec056ff-222c-42a4-a737-0bd65d1f0a93@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ec056ff-222c-42a4-a737-0bd65d1f0a93@kernel.org>
X-Rspamd-Queue-Id: 6032C1C0008
X-Rspam-User: 
X-Stat-Signature: pgty46h5w8xq4w1gr6bs9djnj3azf8kc
X-Rspamd-Server: rspam06
X-HE-Tag: 1786987946-404594
X-HE-Meta: U2FsdGVkX1+VbPOrH8koc/72yJFOt5m+cwYi4spJf3v3gSrjz7gkU2OHPaKap7gCcr7/zVD74+g803WfE7sxSKUVukVgs+I3V9GNxA/xR15eoSkq/U/JgsjRonEggvq6GM0zviE73dUMQyxNoi17qK8S4jZGzpzV5/1BR0eKhz03U1k/fkpfmff5k1ObYcvLL1dvTugqqjJUBvSvtiDvGPWNkUAyzK+1MoBXR7Tu2gBjDuFBY9zzG5clc0ktIGKN+OyUebOethdZFPHFmB+PumhvUEvCwiEi5ZZUXE3UKtNxPmIuOJuUXfK2VTesSBJFHI/Y0sgF25IKdHAiGhXulug15hMakql3jQhLbZ3Hlh0/0C4pFnNAezK5JhfR8Uz98RE1vMHN18RzUd3dSR7Dvw3JSTZdVjnwMbw05054SrY6Sv0OcExnEhBhEIXjGBNoVE0AMVpzBqrPfMkvowHNrtZWVLyUN34RiN9WxAPFy6muHfUTBCY/VTFNeN29XFMua0EeYD9rYT3UVx55TzeMixCYUgWuYhPC30W82+VaBVP9lOeCOoHcw4cqq8UcOJmCPMFDTBpsvobUOWf2VKwSb3N3b9+B1IA0kcvq7MY0JXudiwZb779latAs0IvmEO3Zg8y3B8x6G6Ka6/3IUpz4u2FgDQq1gHnWuo1vbNgkfz73kqywJVrbGmjfD5S1XJvLk6GNvh2x7CX9/3slczgSYRlZ5QrwgAhdo1VdovbxBSI2eBIRWEKkE1gdKfXpX6FUOnuitybflB85XVVKGZSl8Ua1S3Tg2NGm/0bNHJhzpZ7oyxgobBbL0bXlF3L5ocj55w1DJZ30bn+fGQByglS+RV0DJ0oRBs3hjiKkCTX5lwk++MRYUAoy8R6yy4jfKaWadEYoyw5rcCaDnWMGyI8I2zEIM19QBR3/H8VxwsBcrsFcO0F/v2OoBZ/RudvCEXbooS39YmA865LkahD6rUS
 pH/NRdqH
 Uv6cOxEwohfkUQMdRHxKR/LuRV5zEwcYmwB4w134Jy7GNYV0INWaXlS+A4mcFb/hWsXvXm2w+86Zb2+3/fOBsQaC2mVW5cV/KOyjQm0oPnjsC+CS3YNCgDBNolhziWiWUJVHulelVUg842Tax/mnUmtBWxMIq7ctr2ZQhRB3/v4sjqdZ5uTH+j/Cy26Nsmxp03dgauGCLYxDhYKd3urqN6aXbM6Q2AA2a0cKrkKLmlhQviJBnIweZAJU5TL8xWFXbepzk3kFuVB3YDjdduUXZpX5mhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 08:49:46PM +0200, David Hildenbrand (Arm) wrote:
> On 8/11/26 20:23, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Aug 11, 2026 at 07:11:59PM +0200, David Hildenbrand (Arm) wrote:
> >> On 8/11/26 18:18, Hyunwoo Kim wrote:
> >>> The added pagewalk_race_test maps two PMDs and faults in 2MB of the first
> >>> one.  A second thread then faults in the second PMD and drops it again with
> >>> MADV_DONTNEED in a loop, while the main thread reads Rss for the mapping
> >>> from /proc/self/smaps.
> >>>
> >>> Clearing the second PMD while smaps_pte_range() runs leaves walk->action
> >>> erroneously set to ACTION_AGAIN, which causes the PUD walk to be retried,
> >>> so the first PMD is counted twice and Rss comes out twice as large as what
> >>> was faulted in.
> >>>
> >>> mincore() is the caller named in the fix, but the second walk writes past
> >>> the length mincore() copies back, so it cannot be seen from userspace
> >>> there.  smaps reports what the callbacks counted, so the duplicate shows up
> >>> in Rss.
> >>>
> >>> A failure can only come from the kernel counting the same page twice, so
> >>> missing the race is harmless.  On an unfixed kernel the test fails after a
> >>> few hundred reads at most and takes about half a second.
> >>>
> >>> Assisted-by: Claude:claude-opus-5
> >>> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> >>> ---
> >>
> >> I'm sorry, but I don't consider such a specialized reproducer for a problem we
> >> hit once a good fit for a selftest.
> >>
> >> Or am I missing something, that this here is more generic?
> >
> > To be fair I did ask him for this. :)
> >
> > I thought it would be useful to have a regression test because there's certainly
> > no harm in it? The code is very sensitive and catching a similar mistake in
> > future could be useful.
> >
> > If you're sure this isn't valuable then he could just drop it, but it's my fault
> > sorry Hyunwoo for giving you extra work in this case! My bad.
>
> pagewalk_race_test is just rather odd. If this would be part of a bigger test
> that covers more things than just one odd race, it might be better.
>
> But we certainly don't want one new test file for each kernel bug we ever
> trigger, right? :)

Right yeah :) sure we can drop this then. Sorry Hyunwoo!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

