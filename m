Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32DE9CCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 20:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C9136B008C; Sat, 17 Oct 2026 16:22:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279CF6B0092; Sat, 17 Oct 2026 16:22:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1904C6B0095; Sat, 17 Oct 2026 16:22:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E82DE6B008C
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:22:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C7941A0338
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:22:07 +0000 (UTC)
X-FDA: 85333239894.04.52C16FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0C13880011
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:22:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QhAiiwMQ;
	spf=pass (imf30.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792268525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aaLn70CeP3Q8y8xmpykRafKibJMZVBLTb1hqu180a7g=;
	b=JObfq2+KiQ3r82XspbS2/7JbS3iVdwsdSqL2LUtoCXCEpN8KPOEFus1Vm9RC6SdSGksmDi
	WY5+xqS5kRmY9YLEukbVeTUKb0hNPjTrXipfCVF5silAggBySNcUbluNhTxEGWU8gVT1Ip
	X0Z2kR3JLlf6pHQihvOfsgOdMY/GM0g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792268525;
	b=5d0nsH5N1T+Q4z7fU6XdmZ4+Zvc+3tuNZyThrrBqZqJZKDxt2ra8pzBW0RjLxaTqQiTDEV
	oVu5e1Rb3vGuz0XraBleIuE/ThsAhFu6mgO0VSUYs6l9aS8DQFNyNM4g+vghw4xNF6+xDQ
	ZmPNAQeZx9qEOuPBJttAqMvSMKsfkeE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QhAiiwMQ;
	spf=pass (imf30.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E97360D77;
	Sat, 17 Oct 2026 20:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A031F000C5;
	Sat, 17 Oct 2026 20:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792268524;
	bh=aaLn70CeP3Q8y8xmpykRafKibJMZVBLTb1hqu180a7g=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=QhAiiwMQry3GdYWalA+rKsEunsWgZJdUVxCYFZZsTVYcswUbBHVAG76kzdgm9+TSO
	 grTyKCbJDePXsN2guS9DxJsn2deiAgLfCumQgAOGJrgK8262863I23R/SXorAv3jAm
	 x0SRkh8N+gw5iruMENdGH7Fa7EBJC8w3Fab+LI9TuQoaLyczlwfu49apXxgH/A0wqX
	 LY3Tui+RgIw5dS/zjlBNRFfVtTyp8wUnJE/UIuvHYcGpdRh8QAfZ6cso+N+utjk8qJ
	 0qveJbsodhThFNU3sgR6wgUQafoX+bmRrqTquwG72huhTtAKoMH2/vxPenJojfZsjJ
	 Yt0vHhBslyrmA==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 2E157F40069;
	Sat, 17 Oct 2026 16:22:03 -0400 (EDT)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Sat, 17 Oct 2026 16:22:03 -0400
X-ME-Sender: <xms:69jTauaOcwjzmflMV8xyiQGt2-s0OIzXe4kIURxL54BtR5L5hNYY8g>
    <xme:69jTasNPLXfhDilTYXUyaqHJDlu6tC8GBjkcL-0a9dsmbuliCsRBn8_hdJmODj1XG
    kJNANdQIgV89c58raDEmwOn9OtXXrxkDFfI-W4vTJUBDC-gdkKJGHXL>
X-ME-Proxy-Cause: dmFkZTENtYKl6YTXhI+B9FpVMnYirjkR2wHpBXjuhrZFg2ou3rIWwL1icfaBcFo/77we51
    OgnP88rf978IuAkvYeRg5zv5ZMUz5afMKOoibXogSiQBitEpEGee5n9sXD+xCzBMyivyU2
    1BkZdDyxTsTvsaGobnbgoe0xj2eNXE0yoneVIxl0LHSgPRFKHv22whIwROW/4o85UnIe8g
    zJBrAMtaR8NpSgJyrQIeQWoWxTaiao1/FqYWhufDmzggyS9D70zj5DRo4rH7znyqS4ZpXE
    lCvQey4HrU7nBZDoUM/1pOC4yTDUr/qzjfxtDXXA7P61katAKdZsAeVPn0esmuiVc9oJeY
    EUhr8IZbwNWbV2AYWIT73HN6Fq2/8++OeDFiNhY6ZJtVQuItT2CfDjoVxPnTCy3Pv/Rjlo
    mBXvHaljN6YNw74aTdQLuJ5oZmmIhG26kaKlP4Bcd+lzhqA4lPSY3ZzYMr7A9/pAphQv/q
    kE+GvZkh8j/AWeL1VEFkRK33WXykTvDysKSi2FoHQCybMnGUFLUOmwcQzbmsvJCXP9/Ie6
    qIwzzVWKTstQMztCAqqfQazRkzpkPcx1XGN/LJRRzuT9hx7do2ccdGaRh3hmOEil0V3J7+
    tddBGmBNaRAaPEXaz5SMSU58/g6mG9p6Ph8H13Vsd6VoM2Itx53dw3ZIEjbw
X-ME-Proxy: <xmx:69jTagk80LQIEHcwRtXfXru9aWl2aidU7P_PUmEGl_qgWdsoVvQoeA>
    <xmx:69jTauErXpv-bC-2-Yh2UBDTbLvoNDR0ktyy-rGEqZXnfzT9sf6b0g>
    <xmx:69jTan8YP0stvtxqDudFm_oai-ff6z9la8TSSTFq3uLwfyQIYmhpgQ>
    <xmx:69jTavla2GdgLyDJyZW7sIqOXu4UeNMkSIKAzLYGHx4o8rc3U-V3Fg>
    <xmx:69jTaiCNMTTcDig3JXhwb-TXbBePX7RRXwy_lJEDK2eMN6aKy_YVbtxl>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 0BE3578273B; Sat, 17 Oct 2026 16:22:03 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AfI0eCoY7JIB
Date: Sat, 17 Oct 2026 16:21:42 -0400
From: "Chuck Lever" <cel@kernel.org>
To: "Mike Snitzer" <snitzer@kernel.org>
Cc: "Jeff Layton" <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
 NeilBrown <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>,
 "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>,
 "Christoph Hellwig" <hch@lst.de>, "Jens Axboe" <axboe@kernel.dk>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org
Message-Id: <74c5b238-25f3-4349-a99c-4806fa644022@app.fastmail.com>
In-Reply-To: <atPDhmfdneS-d5qM@kernel.org>
References: <20261015233309.42999-1-snitzer@kernel.org>
 <f60b0363-c4d5-4539-990c-1c6c7967f8f0@slotpi15m67>
 <atPDhmfdneS-d5qM@kernel.org>
Subject: Re: [PATCH v4 0/10] NFSD: keep direct-mode I/O out of the page cache
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C13880011
X-Rspamd-Server: rspam08
X-Stat-Signature: j4xb951w4ytahr5roijhs5k11g9feems
X-HE-Tag: 1792268524-805519
X-HE-Meta: U2FsdGVkX1/OxxFS+FQZp7aVRfnzJnVOlxE7cTA104pOj2efsO2a4EWC4REiZrVqDxa7ABONsEDdss/9PCxA61C8NoHosXiNaN29gSaV7CBrsg87pU8kULJfIEJ5OCGTesqtaFRU2UDwXWiBdJ2V1NhE3kS53wajmcdAQ8zYcB5wi4ylIFIVyBKMi44PvQxlisPs/GXfsFgfFKSewF0BIUEBy25OfBCz++n/ovrOUpoAzPTj7+TFCmSqRnFn0IFMd9+NRzNzdAv+kYj9JxkAJG6/Yx8rOxqRhrwf1lzCPe94UZ9fZSg1R1my/5T3jvJGp3FooW1L4wYR4vHV9Y5wRWKpHjICMslBtCDRAif/wwuONosXN98yMjT2e1nGO6tOOjHdvfowBTcTHq6dMsspWfASXfQGPViq6Jg9vRjTwGQPD003by9756KtUZMvHlmQ6pDOBhqWq3YaJLeqehy7/uuaPVclCwplUgRupKOoYmhvKXD0tCLcjiZKW3+o2Z2PhyjwdlG0arytKvgMUecAHcJwiuZDflotR/GJbK9C+nUn+CyXDhOg8s6tRDdoKmhwW4b700lGKwfAF89JuIBLDig9LFCGYy0EPTkSasjARKstC3tEqbDOqIYC61Fi0burRavN1c9SUS0AUh1XpK2WA/iknocWB36Zvu5MDxxMJ+IfZuiBtomZxVyAE2ZHbnuPgn/yCtE8Z2XUapynuTs/nuIZhi3srTGw4Ut2F0yng2vHkZduMGWYIHmsN4VuMi1Zq+iCqicweTfuJmrAVOfO3/4y4C4OW3iH4esvu/Bb/l7/J1TwAJdHN6yR924+CGVTWAsjYwiEoV3Hm7r1HL50E6uWb1/Cct1huFBlgTsuerqsr3m9ANfHgitCkxA/cDVsxygLWERnnqm+kgZcev9kjjpxILpdqK8mnxvWQ6j999Uy2HnQZNjGDWLGpnTWVq2GUpv5sEvElTxYGbCUotC
 q0HIFJv/
 kJiHkXUjvKK5ASIgRGBce9CJqwN/q1921kDcQ5M4wGExUBr1AhbBsdW9xABGYqyfp9G5bti3IO2dUjhtGatzf8Ly7R4kjNpwIFTw/c6V1MC4O8Pf8vm7eRA5c2p2TfjdD8zQFkE+totFaJ6JYoUdnm/gAGxGfAa/J0PgckEHgiBDfeYImXS/6mLo9jB4E5vjkrqC0w84ppzcSJ0W/WAqVJVrrqknzjC/nK6xyjM6/wcpkxiy+NHE/FImGROpjXOE6+inpdzSfFhf8+4nVYjt9lkvVCvSHNdJUk/RNX37vMnNYyIQqqjYtUdsI6Ss8DCtGSNNyqviceBbuADU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Sat, Oct 17, 2026, at 2:50 PM, Mike Snitzer wrote:
> On Fri, Oct 16, 2026 at 03:23:27PM -0400, Chuck Lever wrote:
>> Consider splitting this into two series (which I already proposed
>> for merge process-related reasons). 1-6 need careful scrutiny to
>> understand the trade-offs between scalability gains and
>> predictability. 7-9 need to be explored as an issue with DONTCACHE
>> that should be resolved below NFSD, not within it.
>> 
>> I'll study 1-6 more.
>
> Patch 10 too please, it improves tracing so we know precisely how each
> segment is issued.

Agreed, observability is high-value. We need to assess whether these
should be counters/metrics (ie, always on) or trace points, so I'll
have that in mind when I look at it.

But the high-order bit here is whether the changes in 7-9 belong in
NFSD or in MM. Seems like you've identified an issue with DONTCACHE
itself that shouldn't be limited to an NFSD-only fix. As always, let
me know if I've misunderstood something.


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)

