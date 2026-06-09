Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 801CFCD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 06:31:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC95A6B0005; Tue,  9 Jun 2026 02:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A52CD6B0088; Tue,  9 Jun 2026 02:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91A756B008A; Tue,  9 Jun 2026 02:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD2B6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 02:31:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F778140430
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:31:56 +0000 (UTC)
X-FDA: 84859403832.24.83C077E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1959D20002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:31:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CXf/U4at";
	spf=pass (imf13.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780986714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9cVW14CxuHH6XMS02s4qPCeAXwNI63im2JshZ0C4ctU=;
	b=pQmDI3/frztAW5wz7u8YJE5vsuVhBLj0+wJ2XkoxjZiB+JS56fHZwsctHNP/Cx1vJn99m0
	T4yi7GMma1NTH94xwci3rripSWD+lBmA84mlPrn7yrgj4Yad5loUYvgBArsaKuJYuXPLnh
	j3cEB53jltr7jHSCbCUjq19azy6tY1k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780986714;
	b=scpuJHgYphczVfPfXZ62qIGoo2G0HQLuJqNshpAbt2VWWsxt16SOO+CoeM/Inlubla+iL5
	cvi/VHxEcc4hGb+ElHXm9X8nKWKVlxTz8ZxC1cRP7451FyGXGAR7ySqSWIbeUv717BATCK
	R4QfLRa7oKSWJ18Pp2CQ7x+PPnh9/i8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CXf/U4at";
	spf=pass (imf13.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EE164419E;
	Tue,  9 Jun 2026 06:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2E51F00893;
	Tue,  9 Jun 2026 06:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780986712;
	bh=9cVW14CxuHH6XMS02s4qPCeAXwNI63im2JshZ0C4ctU=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=CXf/U4atw4ng7e5++Mmf/+093z4CCgU0NQ4E9ZtiHnLBZQ3XlO8c5hDUAFfLge80b
	 Pp3bnDzSXbpGGmmME5uzxoi7SzIcxFyVew9k+xSPXr9DfDxA1FocNs1iyYIFPuJeJd
	 Sc+ZhSEEIJqvvabqth1R8GJi4QuPMXUpJZ0HjkMK2cH6zsfklyrZDUE8fFdFZakSSg
	 iN//Rf5Lx9O6Aq0/7y3/j+gjCe1CkR6lQ+poglk2UzPIdWx1eUW/5HfZkTl+ArpSx8
	 5brncMYUg+37AK4DfNjqnvmHqFB89rL8uyAefG75olcRvVBlUaaShTliVjSAQy9og8
	 jW02qkerpWFyg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 35BCEF40075;
	Tue,  9 Jun 2026 02:31:51 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Tue, 09 Jun 2026 02:31:51 -0400
X-ME-Sender: <xms:V7MnapoRZE115mv3OE1zemucjsva6zjZtD5d3LsnPgo655T0S1_hOw>
    <xme:V7Mnameu8nxCzvSST9MMvGJscv5vZhpBAdbcMmboEfheSYhr55P0vRBiJ0xjWN4Wb
    SxlxanxBk8mUaIbIG7n7TYC69uxcjn-LY5Jbu_tl1eHxWiSk2V7yw>
X-ME-Proxy-Cause: dmFkZTFT0QeOWg6z5S4Eyrduc7ntI2XZ8ybouC2z/7kLY4pY3mTLgtkacitZwNL0VP8Z+4
    i4UPqGOWioNbD8PElNjGgAiflyJ41PIsAAy+dD3ap/EH+TIAFzLxd+eA15lYonXwFjoOXm
    AKsU7Rq+u5U3jQ88y9qztBhSwCBkMRpJPnBR1JdzCnxPqezwVJAo/ivpK09iFH3/nF6WJo
    YO4ZqSmOgzUBstd3L/zqENBtA9r9ayIfL0J65bWVdVShBuwriyuFMEK/DNuMYYCR4QHL0P
    69x8Jv4sWE89NJ6Y2jLFRTyobPkf+u9dagvkxQrWTh7cFlpWSLv+eOEi7AbetLf87SYZaQ
    wEdjX5HLugz4TrS6h5hEFzg3wvewAiBqfJB1VhgirTBJK7Z5+mi4t/WhE42TBtP1+u3Ft9
    BEGoJTCVdWezAbERphPOMzN7Xs6Ww/JJqfJ2iG4yB2ymnmk6z5cXgyCU/l8ZmXDejy1iux
    nxIGX8vKp8sx5VhXOhGykeqMiho9sWDJe5REpSnNTRAAVVWR6IFKTbYhEozF1pJqJh6KXa
    uRhNRa0XsAfrFUH1snAI+NgurLh9E85q0b0eeeluRqIMM1dRoLf5asDBnpVwciTtgxGueD
    sp0lAJe9rKMlnCbk1Z4+Ym9JonWancXM30q7gcQtuJoJnqqguwszhcyU5F2Q
X-ME-Proxy: <xmx:V7Mnarble0pwjkE_7YhgAahliXMbQH-zJV-FMhh0Vo225d_uaGzbaQ>
    <xmx:V7MnavbvD-WJixjTpRNbVUmFMt3WUdWknFu_5_hMnuncD3ThvB-dnQ>
    <xmx:V7Mnau32lH_vp-FfGhx90w1SaqphVHzCJxm3a0ywDm83jsotvCPYEw>
    <xmx:V7MnanZUgCXHNAw5zTNMLkS1bpPFe_ckgiLJju_yL5znmAF7kWdFCA>
    <xmx:V7MnajlRhooJNXLU6ZdPb7qf28Zq9usC6xacsV83k3tEqjwUaKa6cEjU>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 0E00F182007E; Tue,  9 Jun 2026 02:31:51 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Tue, 09 Jun 2026 08:31:30 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
 "Ard Biesheuvel" <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, "Will Deacon" <will@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Rutland" <mark.rutland@arm.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Kevin Brodsky" <kevin.brodsky@arm.com>, "Liz Prucka" <lizprucka@google.com>,
 "Seth Jenkins" <sethjenkins@google.com>, "Kees Cook" <kees@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "David Hildenbrand" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Jann Horn" <jannh@google.com>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org
Message-Id: <12e57bd2-5eb3-4de0-bec7-b46b58935977@app.fastmail.com>
In-Reply-To: <6a9c0f55-fe98-4063-864b-8f7e1f4fefd7@samsung.com>
References: <20260529150150.1670604-17-ardb+git@google.com>
 <20260529150150.1670604-32-ardb+git@google.com>
 <a1b27e97-182c-485d-a448-56c19c5de2c2@samsung.com>
 <CGME20260609062840eucas1p1d49831bfdb3447e38a3cadc803a9afc0@eucas1p1.samsung.com>
 <6a9c0f55-fe98-4063-864b-8f7e1f4fefd7@samsung.com>
Subject: Re: [PATCH v7 15/15] arm64: mm: Unmap kernel data/bss entirely from the linear
 map
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1959D20002
X-Stat-Signature: qb4qec8ijopa91149o5sir99um9wfbu9
X-HE-Tag: 1780986713-885496
X-HE-Meta: U2FsdGVkX18Z2XY44aRf206yBFLF30il2XfAWHazvZUNJnDKre6nkZNHgD6vht6p/2BPUj9zNJC1wqPPFQXviwK3z6QXqD839giULFS64V8TxowPbj6UDH9W+z4QoPELwpy4aA4uq8pLfH4zpUfIG0buI1Wil5wtQmJWsKb+gtNvBN8wLFeaGYI2kB4/PMmaoX5LyiCYxt8R/AUzaLwD5x6A9KYGI5S9WDIkE6Ooe4s6jtpmKy5S7bs0HOGQLFfQaU2LvQFojj3gyXe/j+bNu47fyv3WHjWGOVoDkyqugxscr+6W2GLaokORmFuLgqEaaIqpod5dFW9vnCyhiX8fQd7wahv63lfQWnF+qGGnXisqR0PDOxAnbdNWvJhCNp984U+z5V2vzAHncfle2L9M7KUlTWMQ16cgniHKW9NtL2Z5J36QAhn3v9P1k+FIUyN5VRRy27o9KI6bCC/ff86W2G/SuudYaFblrNBIEqoVncc6z6G3Ek7YmInlKeAbN0WeoZbaNobT7i+sYFfXyNBX1tuVOd6ak8uaesF/JOiCS6UaY+npn9a2IEqD7KYE7KETPIGCHF5HdmcqetH/fQJSKUmebqke/Y8HZ+cPmGL86T/FYdR839Q1ucOPiJG2iVADoBoQ7Ph5HuzzMCBPoLpXPU1/e0SAdd0dn5lvoxd3YRVg+Gi8b8f1wq+TD5yteguAznqtnVUqJQc4LTSMzbZ8mXe2mRHNvi9C9r5nuWHclv1g+3K0v6+XSctDKWBDf4q5izCzn8gLfHeSttgU65/YnM26tt2XUml2SD6MahS4otq6zmY0PoHVFeTk4+b3eJg3NcxWG/QDS0L7OoDS5jR4LzVcsk8JTk0r+nQjLWTl2mjb0y76mrpT6kHBcmNUC2g4KVH6uYRt/gtsUSSJvr415d0ASuSNQ4gbE81neNnyCMVN10LoMb6opHRfHbDPW+O+j7AmMep4jBn2jP+M3VO
 doPiPcpK
 SwppKMKD/bp+lWuPadJh8mYghLuaOVqr52xLwfUEOhoAbrQT/NbG36BKB8cnRJWbBgd7Qimm7l4vwJkJSr8sbUDESrXI4h19StyGh7tXrzfCH1OR4UxEsaJdlka7xFDp3CjUxgcxtO6/a8tKWt6G4JsFEUK50i3Y2Ujb5KLWK3ojTGVNQJhJzR/VbatZhR4Uf9QJH8J7DsLKebtGGMGTSgCFvPjJmbJBdaX47hb1Cc6lBm5LpZU1kNPuZfz2eU4e7Ltd/PdtpFB8bJrUQcZqKSi58/9+23W81b3STXdq6so92gkgc89ONXaxGMI1RzmMX8XSoTQk2Fmnxn2K91v4jTg+m8h0SOtEa2pEFJD03oEhC8mx1zJODXV84LSrc2IKWo7tBUTGjRsMfEPflkcAU/dSNgk6KcdoWtQQXzQFG89T9rs7AZgmxXO0hbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Tue, 9 Jun 2026, at 08:28, Marek Szyprowski wrote:
> On 09.06.2026 08:22, Marek Szyprowski wrote:
>> On 29.05.2026 17:02, Ard Biesheuvel wrote:
>>> From: Ard Biesheuvel <ardb@kernel.org>
>>>
>>> The linear aliases of the kernel text and rodata are also mapped
>>> read-only in the linear map. Given that the contents of these regions
>>> are mostly identical to the version in the loadable image, mapping t=
hem
>>> read-only and leaving their contents visible is a reasonable hardeni=
ng
>>> measure.
>>>
>>> Data and bss, however, are now also mapped read-only but the content=
s of
>>> these regions are more likely to contain data that we'd rather not l=
eak.
>>> So let's unmap these entirely in the linear map when the kernel is
>>> running normally.
>>>
>>> When going into hibernation or waking up from it, these regions need=
 to
>>> be mapped, so map the region initially, and toggle the valid bit so
>>> map/unmap the region as needed.
>>>
>>> Doing so is required because pages covering the kernel image are mar=
ked
>>> as PageReserved, and therefore disregarded for snapshotting by the
>>> hibernate logic unless they are mapped.
>>>
>>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> This commit landed in yesterday's linux-next as commit 63e0b6a5b693
>> ("arm64: mm: Unmap kernel data/bss entirely from the linear map").
>> In my tests I found that it breaks booting of RaspberryPi3 and
>> RaspberryPi4 boards with the following kernel panic:
> One more comment - reverting=C2=A063e0b6a5b693 and 53205d56212c (depen=
dent
> change) on top of next-20260608 fixes this issue.
>

Thanks for the report, and for the confirmation that those reverts fix
the issue - this was reported here as well:

https://lore.kernel.org/all/aicVyebkEMs6w6UV@sirena.co.uk/


