Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4217DFF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 08:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85B406B0092; Tue,  5 May 2026 04:29:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80BCB6B0099; Tue,  5 May 2026 04:29:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FAA86B009D; Tue,  5 May 2026 04:29:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A6586B0092
	for <linux-mm@kvack.org>; Tue,  5 May 2026 04:29:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 215FA160379
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:29:53 +0000 (UTC)
X-FDA: 84732693066.05.8D7634F
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf17.hostedemail.com (Postfix) with ESMTP id 076E040006
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:29:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=GMZ+zsyv;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="B 7HPcpA";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf17.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.144 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777969791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qUBPJ0urDcUnlsX6r89qO1KciLnxPJvMDkann39OrDs=;
	b=xv0XnNg8SsS7JBBFfCP0X1C3Z0/RVF6s4Yd1oRSCsIp6gKJFPcKXF4xonZzA4WemQ1v12D
	JTJkqCd8qGIbd2jxCJHjZlDTc/u3HoaNJIMO3sQ9EhkFwdnambw5rzKbs3C078Em69mpm1
	STHTs6gJY/xlHCQ6b+4gX6t2A66uxdE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777969791; a=rsa-sha256;
	cv=none;
	b=xmhUSTBsLHGr4io1jJJaCUGC55Ar+cBXFCOZf0M5GrNVVsgda8N6m3sAILFF+SFCeRqQvC
	aTljePaBpS4JwlaQopWzGEZGNpUyuR9cujnu0rRnBFUQ9Je3EEGXECmS3VrEa0P/piH3JS
	hb7A9s8kzd+nMUmhXm4ypER4OifnDNU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=GMZ+zsyv;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="B 7HPcpA";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf17.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.144 as permitted sender) smtp.mailfrom=arnd@arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 87E411D0009F;
	Tue,  5 May 2026 04:29:49 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Tue, 05 May 2026 04:29:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1777969789;
	 x=1778056189; bh=qUBPJ0urDcUnlsX6r89qO1KciLnxPJvMDkann39OrDs=; b=
	GMZ+zsyvzU9xA3J7cWCCRaI0gDhZR2Tw1FSueTgTNcYtSToYtVDEnwgFUOxoSYI8
	VgnqpBjE5I7N7uPLs3sHE/Q1TqXUgjGZyDH9NWruIkJW+oyoy72NQAamAYvp3A4H
	+Iaz8tXuLE1pz+xIZ8c+5eUGYRA852/pNgF+LsuXpGyFbR1G1OJ+5ZVfco5KSVBl
	hnxLxJIVIW2eiTtD5NVQmPc3Spc5I+lUJheCcwAEDWuukIhC0GQCqUqA+spnk+qh
	lQjL4t0K/2GrzX+YsgGly4LlGwJxjzaF2eq8Yg+kZtTQA2daTkGwTc1F2dKG4VYC
	lfL3nM4sTbeX5XV3/8Tqrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1777969789; x=
	1778056189; bh=qUBPJ0urDcUnlsX6r89qO1KciLnxPJvMDkann39OrDs=; b=B
	7HPcpA5DZ1msZO5GgfSa1at8VYqhtBAlxqewaEmHYcw2IPRPHTD3uqRItnkxALvw
	zb+ewQO0NWd+28GkMdJ4L2BHqEC8LXY7wrWAqbzCZQTj4tCEEcfvxn/wQUevQkVv
	VM/e1uLnFtygVRwilIYPHgTttdCVpBqqkOfqkfh1Q1Kc6zIJMVEUmI8vu7fBHYYb
	Z6DSOuqDw91Gkiogk0HC4pvx3NAPeoPoJX1vR+ZjbTZuo3le1nJd/c2SBIyOJXkS
	NylZfCWF0TaETepRsyj/hzV23wHN4RIclcSku00R0BNcD1utBKbpab8RLXiWV41o
	LxezAENaHGFO/LdmEinMA==
X-ME-Sender: <xms:fKr5aSR4i0LKn96Ts2wPMZBTJicmUDEQza8pPEi2fg2evgvyipuaEw>
    <xme:fKr5aSlTEXhSgiErd_l1ElbwMj6nu-asqtWTVcT3rgNNyz15IdJe74J3X11EQksH7
    lIaqz4pt-oYJHY__8---roprV299HC094O4H97cCedCavkzU3nVRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddutdduvdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhepvdfhvdekueduveffffetgfdvveefvdelhedvvdegjedvfeehtdeggeevheefleej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepudejpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopehnihgtkhdruggvshgruhhlnhhivghrshdolhhkmhhlsehgmhgrih
    hlrdgtohhmpdhrtghpthhtoheprhhoshgvnhhpsehgmhgrihhlrdgtohhmpdhrtghpthht
    ohepjhhushhtihhnshhtihhtthesghhoohhglhgvrdgtohhmpdhrtghpthhtohepmhhorh
    gsohesghhoohhglhgvrdgtohhmpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdr
    tghomhdprhgtphhtthhopehlihgrmhesihhnfhhrrgguvggrugdrohhrghdprhgtphhtth
    hopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehljhhssehkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehnrghthhgrnheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:fKr5aUb5ovd7P5XcuHC_V93o9oyEYJYoKMgqeUniGX-9CCJw2JyvYQ>
    <xmx:fKr5aQWFGZnJ-8-rTb5kQaoIGU9PKbKYcmylRlmMNuQjBuLdKF-ubw>
    <xmx:fKr5afQmqfKgv2NwBcpG8eghLVORqTLSgW0HIIrK0G6mflCtuAngnA>
    <xmx:fKr5adGXdnlQse6xej0imfVIhZXbm6SGI1WU3lD5ndL1sF4UoHs43w>
    <xmx:far5aeohjOqLMDmlUwjRvw9CSi6hVi_AL7kfCiYRD2b4US0XU5j6usdn>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 8337B700065; Tue,  5 May 2026 04:29:48 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A79HWrF7w_-Z
Date: Tue, 05 May 2026 10:29:28 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Rosen Penev" <rosenp@gmail.com>
Cc: linux-mm@kvack.org, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Nathan Chancellor" <nathan@kernel.org>,
 "Nick Desaulniers" <nick.desaulniers+lkml@gmail.com>,
 "Bill Wendling" <morbo@google.com>, "Justin Stitt" <justinstitt@google.com>,
 "open list" <linux-kernel@vger.kernel.org>,
 "open list:CLANG/LLVM BUILD SUPPORT:Keyword:b(?i:clang|llvm)b" <llvm@lists.linux.dev>
Message-Id: <df3e889d-ac8c-4d11-a5fe-8ed2769953f0@app.fastmail.com>
In-Reply-To: 
 <CAKxU2N92s06-L0+e=KZ7EbtU50tCpaCk2MYJD2xTFEHEsAhXUg@mail.gmail.com>
References: <20260505010112.645361-1-rosenp@gmail.com>
 <0f11390f-e8bd-4f8d-aea8-59ef545b2c32@app.fastmail.com>
 <CAKxU2N92s06-L0+e=KZ7EbtU50tCpaCk2MYJD2xTFEHEsAhXUg@mail.gmail.com>
Subject: Re: [PATCH] mm: move phys_mem_access_prot_allowed to header
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 076E040006
X-Stat-Signature: dh4er5ty57yz1aia3q4dmnxm9uryq1ht
X-Rspam-User: 
X-HE-Tag: 1777969790-856118
X-HE-Meta: U2FsdGVkX18Hs/FTEztqHtoqNpnWQjxYIbtkPayEnRMRZiN7b89CEiSB3NWBpOgfopKyWnbcUhgFkkmtcON26UBEC2n2NeCAuvr8ZOBV7pfHnb8sOpg1RqpTCgrBjpaE2eqcuMpQt1xrkxx+VZYXxV9mFvsXZoB6zs0xsxmzIOg0O6gbI+zTNoXh4rltczgUmBkrx9vajICXpWBoGxwpLsKppve/naZj79Z5ChqzGpfpRogxmFfONUuWDkG7VgCxVfKDfapGMFZiliX5ygo0AVuMSi0uVU42J5xd0lMHycJBVt18TgFFOvoWMjonX1vZFdFXP5q3bzUSgesJ7jLVEhksiazJdUvrCkqJipL0WbnhV7b5uw/1sY60BPkvkCKtZfZWjCD5GmRtuK52buvZzVZhMY4CfVfYmq1/W0hOnn86xnFV2apTdhGakvSvH71gkuLQvEYQc4sSvUsja6Gdxskq3He20Q3mEvKgsk7j1Nmen9NHFw9WZ8/Vi7gOIpurBxe6T7kETivWGaMapVcGFMEsqEzCqzbLe8LLlv+wGTIO90jhrU+BYjW8eYD7/1wJVOuzILctNa2bge675WOwurhaxcZVip3+B6QpXUUsgIKA8fvzGqjn4MNvJKGzoupXMBllDZxCoCOUdj88VfB1hwBFZ9Snrkzuy1f0P73yEy69cyo21JhF/Y8OJ6fJ/D+FwrJlQZEUgXI0BjL6XBOnzi3NP6VWTnAfiDrlp7FdzFsVZpYy1Mm3nKVXrJ0LUjHhRf0FgYgsAP/BstBjvGri9hPveDntmeWyFF0blIRUZ7q0kJrzmkpc/QOh3hKW5phjLBLz0J3Xx0t2vdrmkNlEBgd43rl4BCRjcW03X4O6pz4rs/T7b33arKqSpfoDehTw4lQOc+taoXseElkr8+JG0RIj9uLKPevaGL4AHMzgyygqIZUntMz9a3D6GENMQ/TsuR+Ur5OgcWHhF+tbVES
 p1fDYo4B
 1nM/gSSLnWOTePCy42fEaB2T4k3ujHRk34mFIimxL8i2lVO2sCMdikeUAbCKCP1LsB3Df3wMV/4fzxaQn2O7EPX4sF2rWObsVtrWhdUVAHTJEK23JcLgBB4/kk4zaLRqJw2Orgk7ll+4ryxZtbGrZGVL/jZEN/ual2QCCe7IdGzB6a/1Qcw2Zo7RpL6AKYsq2PtFxN7R2bfUIQbSnbPgYKUfCeY5lHIDv8ylqIw8vXQYn5cjRXzfTCBkfXLGVpK7Fw+C5Un7fFXdI2B4T9YpVP3OCZaJbtKXV3ISYmPUtfLV6lUoktTHqGJzlTWvEtNQco7GDBRPJzt77acP0jn6vjMV8vXK4yFlN7f984McgxF5pyPUSfYSfL9F6LlSst+zQfxGNUt7BPCm1ppngxPnokaq0VLMnnYKYyy//gPP220pi47w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 5, 2026, at 09:47, Rosen Penev wrote:
> On Mon, May 4, 2026 at 10:54=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> =
wrote:
>>
>> On Tue, May 5, 2026, at 03:01, Rosen Penev wrote:
>> > phys_mem_access_prot_allowed is only implemented for X86. For other=
s, it
>> > returns 1. Move it to header to avoid using __weak.
>> >
>> > Fixes compilation with make LLVM=3D1 ARCH=3Dmips
>>
>> Can you describe what exactly goes wrong here on mips?
> Cannot find symbol for section 4: .text.phys_mem_access_prot_allowed.
> drivers/char/mem.o: failed
>
> It's full of similar errors in drivers/pci/ as well. clang on MIPS
> doesn't seem to like __weak.

This certainly feels like a toolchain bug. I would not mind having
the PCI code converted away from the __weak functions, but it should
not just fail with a linker error like this.

Does this happen with both ld.bfd and ld.lld? Which version of clang
and lld are you using?=20

      Arnd

