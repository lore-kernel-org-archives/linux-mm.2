Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8CD5CF397E
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 17:32:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D04926B00A5; Wed, 19 Nov 2025 12:32:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB5136B00C5; Wed, 19 Nov 2025 12:32:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7D3C6B00C7; Wed, 19 Nov 2025 12:32:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A1D786B00A5
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:32:05 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5152859A9C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:32:05 +0000 (UTC)
X-FDA: 84128049810.23.D08F308
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 25BC514000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:32:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W3Cfn2oi;
	spf=pass (imf23.hostedemail.com: domain of luto@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=luto@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763573523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZQYt+JZTf9u0DSrzjR8u6+IZq2TyCBjcdNC43g8UR4=;
	b=xljsLrKwysLn64u9MMXEF3yUxxQzxmI7Nw1j59rNj6JWHz/w2gyTHoWfg5difmxmfu8h0h
	I++C75fqIulhIhXAT0MNhdEIy5qB7fUmxx+6z9U6ABJ/q4X9/WSEEhH3KZpg+iKdvCetyz
	AyiVp80B+8GFfci+TJHTCqmaZUVxE2o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763573523; a=rsa-sha256;
	cv=none;
	b=S0mXzdiKeDi5dmTXowWNX2yN9zVn0bZapoSI7x0ji4Bn62nw5V+Qw+LBK6oIsx7z4j5RD7
	3MvVCT95kRTcUdr2UMeKAWjHArxelZdrC7wph7E1E2kUmomRlfDwvcttSTG14sRDsOcm6W
	mIwLyC0WOn7/UcVzZUsvAOoU5lIAmE0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W3Cfn2oi;
	spf=pass (imf23.hostedemail.com: domain of luto@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=luto@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2007743789;
	Wed, 19 Nov 2025 17:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25202C4CEF5;
	Wed, 19 Nov 2025 17:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763573522;
	bh=/t2oTQtncuM/mvzgreWw/hJ7gSFNgj07SaGnfOfObKg=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=W3Cfn2oiDvKGRYk7XXu9FsNDHJc9fbUZ/qZ+tByWGnzj7O2u+nFpOup7P765xJoR7
	 fejiA1bvGY68LQY2bTW9qrmQtFR2JQ7Ua3voayJaJBfdEZG6V+7rn3DXerADQmfx8C
	 ltL0RyFVWUnEKu5I1M47Z9VbiFmBTmZaAUjXKLZQQH6q0fn921XQ8/UAnvoPAoUd9R
	 eFykJH5ntv+cTxiMbS2XplL+Z7yfWo/ko/FORBRQslCJIjTNYVC1t5QItXkYCUhdTf
	 g/3VwppzhyevZgimVZXmws5EQDLPbbMTlKJ2RpOVpdo5QOpE7gyyiZaTLC9nN5U9R1
	 1b++N/eo2Q4dw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 15FF1F4006F;
	Wed, 19 Nov 2025 12:31:59 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 19 Nov 2025 12:31:59 -0500
X-ME-Sender: <xms:Dv8daYw8V6oCHt7IdscAKP7ZmNBGAa5l2QAwxtemNAhqmc86Cvmz2w>
    <xme:Dv8daXFjKfxoLeyJ2tQ-LMwJMhCMviHudxhtJj_7W7G9StSFxeNFWZzqbW4KphyxD
    U3EneA33cqOoXiVDgcMLskQ2oHKFwMim-OnIq2k97GUUcvqh4MgBwbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvvdegkedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedftehnugih
    ucfnuhhtohhmihhrshhkihdfuceolhhuthhosehkvghrnhgvlhdrohhrgheqnecuggftrf
    grthhtvghrnhephffgieeuueevvddvffehiedtteduveejtefhuedtteehfffgieehhfeg
    ffehvddvnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhguhidomhgvshhmthhprghuthhh
    phgvrhhsohhnrghlihhthidqudduiedukeehieefvddqvdeifeduieeitdekqdhluhhtoh
    eppehkvghrnhgvlhdrohhrgheslhhinhhugidrlhhuthhordhushdpnhgspghrtghpthht
    ohepgeekpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehjsggrrhhonhesrghkrg
    hmrghirdgtohhmpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohep
    rghrnhgusegrrhhnuggsrdguvgdprhgtphhtthhopegurghvvghmsegurghvvghmlhhofh
    htrdhnvghtpdhrtghpthhtohepmhgrthhhihgvuhdruggvshhnohihvghrshesvghffhhi
    tghiohhsrdgtohhmpdhrtghpthhtohepsghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtoh
    hmpdhrtghpthhtohepuhhrvgiikhhisehgmhgrihhlrdgtohhmpdhrtghpthhtoheprhho
    shhtvgguthesghhoohgumhhishdrohhrghdprhgtphhtthhopehjrghnnhhhsehgohhogh
    hlvgdrtghomh
X-ME-Proxy: <xmx:Dv8daRCKxEiK-0E-MKjf5NWUbib5nldBL-kYR9iWEijS3CsfVa89kg>
    <xmx:D_8daX6x1rtaemMXGl1UUQ-GckmNeRG7S9C0cE8st-Pfk6O6QPlNqQ>
    <xmx:D_8daW0MQGOGXibaGRTJmbXnHuAS5PAeFiV8Msmu0BCYqd_QjRTjZA>
    <xmx:D_8daQVCyt9OWVjQ8WbjKcJmpn9xIBLHN3rVEdTmsuxpWYuoTd_HUQ>
    <xmx:D_8daTkZEglornIN3N4-CtsqujdAUXdXlIbQgLT3HNoWB_wXN4CqSIGu>
Feedback-ID: ieff94742:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D1DC6700063; Wed, 19 Nov 2025 12:31:58 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A2ZwPDH9FoLc
Date: Wed, 19 Nov 2025 09:31:37 -0800
From: "Andy Lutomirski" <luto@kernel.org>
To: "Valentin Schneider" <vschneid@redhat.com>,
 "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
 linux-mm@kvack.org, rcu@vger.kernel.org,
 "the arch/x86 maintainers" <x86@kernel.org>,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>,
 "Josh Poimboeuf" <jpoimboe@kernel.org>,
 "Paolo Bonzini" <pbonzini@redhat.com>, "Arnd Bergmann" <arnd@arndb.de>,
 "Frederic Weisbecker" <frederic@kernel.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 "Jason Baron" <jbaron@akamai.com>,
 "Steven Rostedt" <rostedt@goodmis.org>,
 "Ard Biesheuvel" <ardb@kernel.org>,
 "Sami Tolvanen" <samitolvanen@google.com>,
 "David S. Miller" <davem@davemloft.net>,
 "Neeraj Upadhyay" <neeraj.upadhyay@kernel.org>,
 "Joel Fernandes" <joelagnelf@nvidia.com>,
 "Josh Triplett" <josh@joshtriplett.org>,
 "Boqun Feng" <boqun.feng@gmail.com>,
 "Uladzislau Rezki" <urezki@gmail.com>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
 "Mel Gorman" <mgorman@suse.de>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Masahiro Yamada" <masahiroy@kernel.org>,
 "Han Shen" <shenhan@google.com>, "Rik van Riel" <riel@surriel.com>,
 "Jann Horn" <jannh@google.com>,
 "Dan Carpenter" <dan.carpenter@linaro.org>,
 "Oleg Nesterov" <oleg@redhat.com>, "Juri Lelli" <juri.lelli@redhat.com>,
 "Clark Williams" <williams@redhat.com>,
 "Yair Podemsky" <ypodemsk@redhat.com>,
 "Marcelo Tosatti" <mtosatti@redhat.com>,
 "Daniel Wagner" <dwagner@suse.de>, "Petr Tesarik" <ptesarik@suse.com>,
 "Shrikanth Hegde" <sshegde@linux.ibm.com>
Message-Id: <91702ceb-afba-450e-819b-52d482d7bd11@app.fastmail.com>
In-Reply-To: <xhsmhecpukowa.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
References: <20251114150133.1056710-1-vschneid@redhat.com>
 <20251114151428.1064524-9-vschneid@redhat.com>
 <65ae9404-5d7d-42a3-969e-7e2ceb56c433@app.fastmail.com>
 <xhsmhecpukowa.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
Subject: Re: [RFC PATCH v7 29/31] x86/mm/pti: Implement a TLB flush immediately after a
 switch to kernel CR3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 25BC514000A
X-Stat-Signature: yqofph9h3n8aa4c7qwug77zhyu7487xt
X-Rspam-User: 
X-HE-Tag: 1763573522-304509
X-HE-Meta: U2FsdGVkX1895KhVHzlnf+YxmC5syJvI4cNKLNs4GLga0WU0QOjSjdBNzM9eXjIf+ESitpOfls48shRwlkn0Ijn+HzoLDaBO1VpUzJaJFT0iV6bGTZGPCImKkf17c2Zq7xj/cNdDyupmRJ4DHd+lShPX/vX0/LWi3wDXtMg3CYddWjejoBo5K8lqLxWUGQpbga0ioivnrXjjSGukcYVQ5dtYv7B+oFsBzE3dumz2GZ37aD+1E+loD4H5C9o3rXLdx239BIXGl7gczL+3usV8m45sWMUM7rezooS5wxUi+RbtvaGqU0kxQaJ+LAaEGqQ9AmYU03SHqD6bNXlB7o+tj5CdNSLAz/8PR3o4PJcEtLBgInZNOpv+yM532dQoGe9RcehqD/9A30AQnItncnxpiYV/+x2SEQe/7dS/RsvSriq5/kfR1PzBuANuTr8rYiUFKUpt3+xH/S1DmL4gdGvP6UkHMpzpZwGugaIC2yIteF0ru2fl/KnL3K1kvpWLeLCmvCQb6ZskDA9J05kSoQZpqJHdpomNMVKXttRk5bArtEXDos+50yKHaTx1fNGXkNW+cqiJX8ZsUbEHxIOMVJAC3aIJUJ9i1T886uZUV3nEAo+0SwKxmez6wPylX3Ov8Nle/Z3wzBURdYxZLRI4l9D87XN2QozJg7bIwOxO/iYA7BYny13z6B2K2X+yd7MkqI7qnmbL2ISf+CkAXDHxOH/tsdrFlyPpFsLiZoUlJI1gNYHHIifw04T3T/y1RElDTRF35GZl0Z2/DKxWL70nnQi4VRk8dX5TMvWC/JDKAetpqFPRQ1Gg0a4jPJfVhAkck3SdJZPm3B/1+9MIJgrLTqHe36y48BKUzpL5w2IEjCnHbVtqBl1YbPhqrtO/yTY6e4aHz7j0S/e5wp6ME/BMXwC7N0bwM+KnfWlvkOGA+D6QyvuFd5pPmW/0Hx6CYdwMtpRRSX+R+nepQtCR2KGXe5X
 eAcywfJQ
 1uIzmNupZjXSLr8jJq3GiijwNvb4HwksbRznXexzeu+AjEqimUUDdu73SkfJ2xm75DZrn70Mkt72gC3wOeYF0fBngBtKFjQTsKkz4U0N29xaYJmrmDlQzyfyZsW48N5uXwyf78xuVovtTC7U+eAQaTDSyK6QXikmvQuCTiXa2wKwD/tedd8Gb2aLM62yTdIxO0FlHPlYJxf9Ts9btrTNEbdfpNpYKEZ58SbosFyG8iEseQ7yckQzlc5UKM/STuDB9TqUgymz/ZQGkz56hY1lvnyqNSo0QTAm7hSlSU1gEJ+wIHUGgaRCttONR6czvouyGVy3WwbFJORR10gpvwnMZV0JRyfNvuw2UHDz8v74rnRflpDQsTs2hguLTpy7tSDDrlt01
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Nov 19, 2025, at 7:44 AM, Valentin Schneider wrote:
> On 19/11/25 06:31, Andy Lutomirski wrote:
>> On Fri, Nov 14, 2025, at 7:14 AM, Valentin Schneider wrote:
>>> Deferring kernel range TLB flushes requires the guarantee that upon
>>> entering the kernel, no stale entry may be accessed. The simplest wa=
y to
>>> provide such a guarantee is to issue an unconditional flush upon swi=
tching
>>> to the kernel CR3, as this is the pivoting point where such stale en=
tries
>>> may be accessed.
>>>
>>
>> Doing this together with the PTI CR3 switch has no actual benefit: MO=
V CR3 doesn=E2=80=99t flush global pages. And doing this in asm is prett=
y gross.  We don=E2=80=99t even get a free sync_core() out of it because=
 INVPCID is not documented as being serializing.
>>
>> Why can=E2=80=99t we do it in C?  What=E2=80=99s the actual risk?  In=
 order to trip over a stale TLB entry, we would need to deference a poin=
ter to newly allocated kernel virtual memory that was not valid prior to=
 our entry into user mode. I can imagine BPF doing this, but plain noins=
tr C in the entry path?  Especially noinstr C *that has RCU disabled*?  =
We already can=E2=80=99t follow an RCU pointer, and ISTM the only style =
of kernel code that might do this would use RCU to protect the pointer, =
and we are already doomed if we follow an RCU pointer to any sort of mem=
ory.
>>
>
> So v4 and earlier had the TLB flush faff done in C in the context_trac=
king entry
> just like sync_core().
>
> My biggest issue with it was that I couldn't figure out a way to instr=
ument
> memory accesses such that I would get an idea of where vmalloc'd acces=
ses
> happen - even with a hackish thing just to survey the landscape. So wh=
ile I
> agree with your reasoning wrt entry noinstr code, I don't have any way=
 to
> prove it.
> That's unlike the text_poke sync_core() deferral for which I have all =
of
> that nice objtool instrumentation.
>
> Dave also pointed out that the whole stale entry flush deferral is a r=
isky
> move, and that the sanest thing would be to execute the deferred flush=
 just
> after switching to the kernel CR3.
>
> See the thread surrounding:
>   https://lore.kernel.org/lkml/20250114175143.81438-30-vschneid@redhat=
.com/
>
> mainly Dave's reply and subthread:
>   https://lore.kernel.org/lkml/352317e3-c7dc-43b4-b4cb-9644489318d0@in=
tel.com/
>
>> We do need to watch out for NMI/MCE hitting before we flush.

I read a decent fraction of that thread.

Let's consider what we're worried about:

1. Architectural access to a kernel virtual address that has been unmapp=
ed, in asm or early C.  If it hasn't been remapped, then we oops anyway.=
  If it has, then that means we're accessing a pointer where either the =
pointer has changed or the pointee has been remapped while we're in user=
 mode, and that's a very strange thing to do for anything that the asm p=
oints to or that early C points to, unless RCU is involved.  But RCU is =
already disallowed in the entry paths that might be in extended quiescen=
t states, so I think this is mostly a nonissue.

2. Non-speculative access via GDT access, etc.  We can't control this at=
 all, but we're not avoid to move the GDT, IDT, LDT etc of a running tas=
k while that task is in user mode.  We do move the LDT, but that's quite=
 thoroughly synchronized via IPI.  (Should probably be double checked.  =
I wrote that code, but that doesn't mean I remember it exactly.)

3. Speculative TLB fills.  We can't control this at all.  We have had ac=
tual machine checks, on AMD IIRC, due to messing this up.  This is why w=
e can't defer a flush after freeing a page table.

4. Speculative or other nonarchitectural loads.  One would hope that the=
se are not dangerous.  For example, an early version of TDX would machin=
e check if we did a speculative load from TDX memory, but that was fixed=
.  I don't see why this would be materially different between actual use=
rspace execution (without LASS, anyway), kernel asm, and kernel C.

5. Writes to page table dirty bits.  I don't think we use these.

In any case, the current implementation in your series is really, really=
, utterly horrifically slow.  It's probably fine for a task that genuine=
ly sits in usermode forever, but I don't think it's likely to be somethi=
ng that we'd be willing to enable for normal kernels and normal tasks.  =
And it would be really nice for the don't-interrupt-user-code still to m=
ove toward being always available rather than further from it.


I admit that I'm kind of with dhansen: Zen 3+ can use INVLPGB and doesn'=
t need any of this.  Some Intel CPUs support RAR and will eventually be =
able to use RAR, possibly even for sync_core().

