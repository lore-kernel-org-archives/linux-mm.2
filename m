Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98279C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B67496B0098; Tue, 22 Sep 2026 11:45:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17D96B009B; Tue, 22 Sep 2026 11:45:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05FD6B00B2; Tue, 22 Sep 2026 11:45:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73AD76B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:45:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D5A48054E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:45:59 +0000 (UTC)
X-FDA: 85241824038.26.FE223FB
Received: from mta1.migadu.com (out-246.mta1.migadu.com [95.215.58.246])
	by imf05.hostedemail.com (Postfix) with ESMTP id B528D100017
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:45:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j8Pd6TsC;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.246 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790091957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rA2m/rBM6FS250LvmHiQ4GQ7wkwr5OAQGTIFlIi0PJw=;
	b=h8Ia2tQuNTDRYIOslQAaVyrD2GPj5ogTmMeeUsT5Zox7PSmUawNLIoNJxkRjrJLeAZjKbt
	jsVNREUFMuOc2Qr2o5A35///IN5h8vwxPJUh50vvO4C+xOhiFfnNBy5O9rEE1Tn1RNPvjI
	p3bzuLw9e3BKY7jAsbEy4Zjwaz8QYUw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j8Pd6TsC;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.246 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790091957;
	b=HDzq54Y41mhVEvAb0voJqYRRBDgTS/50g8jBwIHpIDnT91uh8uYE6I21BKH2WIgRWnlVl9
	qCPkXyqQ638QZhPZqWn3MUei5TpLYuVNaCp1OFw7KlPTu8inbWxRBEGDh/eN7s0ZV6kdyE
	uUi/O37kjv+15K2kSnNW89B2mlV+MGI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=E4nsCeMhUyoyfA92nxYsi+1V5mplBSR6abTs7jkapTk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790091955; v=1; x=1790696755;
 b=j8Pd6TsCJrJcpukHfn+/ory5A8icclYSiGnK/2ongwQCQlkTubh56qmMQO4Y/GfppFqo+vfs
 Cz5dOZ6fqnZoFIg6xFTbewHKZL2UTkAzhHLAHP1UM0XSL7SbaGyiqKMfg8mLJ2+gAJIZ/0a43ml
 sRuIZIdtLkH2Xnz0b1Sz4szk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fbff1a32c447a0a9;
	Tue, 22 Sep 2026 15:45:54 +0000
X-Mizu-Trace-ID: fbff1a32c447a0a9
X-Migadu-Flow: FLOW_OUT
Date: Tue, 22 Sep 2026 08:45:49 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Meta kernel team <kernel-team@meta.com>, 
	Linux Memory Management List <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arKgladcnmeTWUKb@linux.dev>
References: <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <arKRdaNEaKvFOtMg@linux.dev>
 <CACePvbX7aM45SE9H0hg1_uXBt1i4W7Pgk+d33Z2sG5bj8cHudA@mail.gmail.com>
 <arKZpJDpsavixjPx@cmpxchg.org>
 <CACePvbUmVLVk=w1sJinBfKVYoXcO57A163RrXv7C_QLzM4yQZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbUmVLVk=w1sJinBfKVYoXcO57A163RrXv7C_QLzM4yQZQ@mail.gmail.com>
X-Stat-Signature: 4rbzgpm8d739p1iqxfwec56uhqhinzi8
X-Rspamd-Queue-Id: B528D100017
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790091956-752113
X-HE-Meta: U2FsdGVkX1+G5Ihd5OVMgOhvN9fxfi6QmmaDsNFUkDwC98Ez5FJWYSrS4eGF1d8sRCQbZDSpoYTVz2l4QpemjMLwEA0tk3v3qqYDJsfiQ1xAdmqSCzaAEgv6nTqWPF/kWrZkcU8QtAzFGN6PI+KPRbbvhJ2YLF4mH1CuQFHho+jpmnhMoCNNYxTmKvzAzLCK4uMwlMJjApLxa5lJ4+E+vWKvkaNWqLNeA9D7J9zEjBom1G+5myXk+1G1sD4NwkMUtT0wC7Rq5+3PbBqVUO00jG22zjf/cPgvCmZikvtcwJHKIs2+wNQQFUiK1vIAOQpRUYsP7l3JDXKTft+uxtbK1ktf9cfZUtVW3lwCeJWhzx35F01BzS2sIf9RvyO6jvhnTf7NtKxW3ZVsTQIY2nffClZ49s+N6HPWtSzgywrLvn2tz3o0e/GsTLIZGBEw9zGflevGQgKNDXGdnbXrdnAMfD+rB3DBVd/HnWCmGlVzXYWOsvfWYcDiqT7KZ7Y0MxHmp9KdwxBAuJ1okyj2mdn8MKKI76CnXFvx81o3zg0lhLLjE0ynHuEA5DGxlZUJNyE3R6MGi5xwRV88GlOsP536uZFLedpwoDL0TlAPe1m0ZOSE0LdhLfFdhB3ZS0J5Xh9t0G2PByZ4FHtCea18zP1LkkT34+H4w3K4Pvlkak85ovZjr5l12upScqihVT+qNnGmgvx7W1BoGJoIuLKVZ39gmRFaWCrvB8/nuWJSgWn9EEeKh4RDdtLTvHGijdG0AwN1K12EOTPdtq0xRbSgc9tJsO9GNyXHqL1ZdBZDgvl3h1GJy6g2vOQR8RoL7/qEkkWhKKA2Fd/luYyJD1LSWuoFlE+/u0qXqIqbxaopq9EFAIwp4CNF5C0I3oDiHHktfq7o2WyKHdsGS+PJV+8UKkuuT8Kam20OAqYu9b/5b6TMAdPbxvJ9fHxezteZ9p9mbMkt8Ykbh05We4L8wDbn37b
 lGJgljmd
 /65q68wVquJ1hTN6xv1Odi4Kcjqbdt+rBW3Tf2nPI4NRg3n1i44pcAMuA1V03BNZGGecKkbmhqtJAL2yqVnBXdVnVVP2bTlflq2PiakB9rXdQRFflQ9zDC7pMICjtDwc4As6xbCiZsNEVMA6WSpLYiiSZeYZCGfN8T9WO6kkAW3jTNcCKBrFPh5A7ARU9NdX5Rr3BW9CMyroxV++PfqAs7+MDAoE3zwRj4YmmM1tqtt3wb38MOXtpcoxxBDUILzQ50X+ZWjMkYvuOLqbD8fA0zRmhRyPDRcooD/vNhWQ804sx1gpVcx2VPzTmPFH/W+LEmEPfcpufswIQip4hkO//iv0jZnc8BRyNengiSV+dPsxmU3845JbjytB0wWRgm3jF9h+V3Rdf12zjIPNFwx8Mns/RamK8iTluMGEpIeCFCLPePtDNqqi/exIe5VHmRX/l/m6jGQpYa3jRUBCR0m4yRswpmJPHR+OpbfF5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 05:30:44AM -1000, Chris Li wrote:
> On Tue, Sep 22, 2026 at 5:07 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Tue, Sep 22, 2026 at 04:56:48AM -1000, Chris Li wrote:
> > > On Tue, Sep 22, 2026 at 4:43 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > >
> > > > People can speak for themselves and suggest other time slots. You do not speak
> > > > for anyone but yourself here. At this point this is derailing the conversation.
> > > >
> > >
> > > I am expressing my opinion, freedom of speech. As you can see in the
> > > previous discussion, Baoquan wasn't able to join that time slot. He is
> > > a major shareholder in XSwap. I worry that alignment vswap vs xswap
> > > without Baoquan is ineffective. That is my opinion.
> >
> > Actually, he said he is not sure if he can make it, and before Nhat
> > could respond to that soft push you drew a hard line without actually
> > proposing a workable alternative that made Nhat give up instead.
> 
> Please consider that it is 1AM in Beijing if I remember correctly. I
> don't consider that is a workable and reasonable ask.
> 
> > So my free speech opinion is the same as Shakeel's: you're speaking
> > for others and thereby derailing efforts to align on something.
> 
> I sympathize with asking Baoquan to join a meeting at midnight.
> 
> >
> > We all want Baoquan in the room.
> 
> In Chinese we have this saying: don't apply things to others that you
> wouldn't want applied to yourself. Do you want to participate in a
> technical meeting at 1 AM?

Three emails in, you have rejected the proposed slot and proposed
none, and your own conclusion was to drop the meeting and keep this on
the list. That is not inclusiveness, it is a veto, and the outcome
serves Baoquan and xswap worse than any hour of the day would have.

Baoquan said he was not sure he could make it. He is perfectly capable
of declining himself, or of sending alternative timeslots to the list.
You turned his "not sure" into a hard no on his behalf, then argued
with everyone who pointed that out.

Please reply with two or three specific windows in UTC that work for
people not in US timezone. If they overlap with the other participants,
we use one of them.

