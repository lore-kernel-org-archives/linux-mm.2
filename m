Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E8C0C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 17:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0B5F6B02D3; Wed, 12 Aug 2026 13:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2876B02D5; Wed, 12 Aug 2026 13:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1FCA6B02D6; Wed, 12 Aug 2026 13:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3C816B02D3
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:18:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 11AD51A0161
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 17:18:10 +0000 (UTC)
X-FDA: 85093275540.21.829DD43
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf31.hostedemail.com (Postfix) with ESMTP id 20F3D2000D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 17:18:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=IPMOXnlS;
	spf=none (imf31.hostedemail.com: domain of BATV+8f88a44aac2376c73a89+8389+infradead.org+dwmw2@desiato.srs.infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=BATV+8f88a44aac2376c73a89+8389+infradead.org+dwmw2@desiato.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786555088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ds42W/dXlJAXbQKntPBECqK3Gubna1cUNBXYw/z5vfo=;
	b=f6MphWMV4emGV9Ji2EmvyaR0HWg+5rHecY3kZLmMioOLJFF2fRtc7g2abA918RGauNuMng
	H9z4yHw3cLj1jAj9qSIFHlkT+0YQJcN3bQrZx8PvAls4VUklFMRNEkDQYpFWLqvVdQ7Pke
	L+qe5xgERmcCkq7jjUfGwOk2RStqTnc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=IPMOXnlS;
	spf=none (imf31.hostedemail.com: domain of BATV+8f88a44aac2376c73a89+8389+infradead.org+dwmw2@desiato.srs.infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=BATV+8f88a44aac2376c73a89+8389+infradead.org+dwmw2@desiato.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786555088;
	b=pGD4IWRQuVMrQ318lxRuM1HrfAyxoSbxhhNa5Wi8qHSQbey52fGjGXaaxgxTyJLFTpIH5u
	ck2qscV8naIa6wcI1Vd+qW7PCC7tQcqFAYuGbjSZLJu7LAFJqqXD8Aw2JXGZB1slFBGgGx
	lx/8KwB8UUz3IXKlZgg4eTEgZ76uoro=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=Ds42W/dXlJAXbQKntPBECqK3Gubna1cUNBXYw/z5vfo=; b=IPMOXnlSsdzwQrzSwlk4VEmg6P
	5UCDuLxM6/KfRsgUHs5UL2PO1fWSvX7NG0h0tejkGarlAnmKsnHStu87KvuOLUJD4dB/cl3a6qoXQ
	00SfWkRO7JnmQuNjFyYx0EptleEXkF5iYbGFFRzuXK6cGKGSD1WBws9hcq0XsKNHZvCL2ovN9laOL
	BSyeAKZIFXy7SNIyhVJzoKG2oQIFO1IY8jlLs39OGO8IBWcUJOZDWA/db4I32Q4y4a3EA/xBGWtj7
	msH8UuKpzc7aGr/anExAl/UI1joafQuJ/WLq1jO3VLmzq4PzHtxE5Zyyj50+5kDeo0FqQvDPmpViw
	blrC0kLw==;
Received: from [2a00:23ee:2978:2282:ac3b:fbd0:357d:8a84] (helo=ehlo.thunderbird.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wuCaV-0000000Fdcy-1sHl;
	Wed, 12 Aug 2026 17:17:59 +0000
Date: Wed, 12 Aug 2026 18:17:50 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Michal Hocko <mhocko@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>,
 Simona Vetter <simona.vetter@ffwll.ch>,
 =?ISO-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>,
 =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
 "Paul E. McKenney" <paulmck@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-mm@kvack.org, kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_mm/mmu=5Fnotifier=3A_Remove_non=5Fb?=
 =?US-ASCII?Q?lock=5Fstart/end=28=29_from_notifier_invocation?=
User-Agent: K-9 Mail for Android
In-Reply-To: <anydY25Cl78l1HfU@google.com>
References: <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org> <anwraNIKJV8zwrNT@tiehlicka> <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org> <20260812122759.GA662699@ziepe.ca> <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org> <20260812134934.GC662699@ziepe.ca> <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org> <fb87f673bf290cad133d113dbb0750a7752b9d30.camel@infradead.org> <a94b75e8b9b1d2191f365c0f4275fd5082332df5.camel@infradead.org> <d0692500893f303906fba1d7d596eb59a07a806a.camel@infradead.org> <anydY25Cl78l1HfU@google.com>
Message-ID: <932DB129-1794-4855-A61E-F4C2B54B1EE6@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 20F3D2000D
X-Stat-Signature: beuq49yo6jfuzufc4stbh5c59cnab3om
X-Rspam-User: 
X-HE-Tag: 1786555086-522856
X-HE-Meta: U2FsdGVkX19yynCBedcWt7K+U7kcCv51Wh3tQsdHNoVGJc8e6nz0MuHZGt8om7+WGLXrBiz0yBQiVQdHuMTEUCzfkCZrZktyOObjg/2bXh7wFYpanG8SfopH0Bg9BobfXhXnkXIGQBd1YsmM06fIIKbJCzTN7a2CTc5HtH/IfxErfEWiaRUCxwXZZs/lPdmd7ajxu1KHziOW71iGqYLKrxtpFogxk5ex2Ckc2+iEG4XnZiQ+pdP0JvWTzRdy2HOvAlqtIX7LCP2KJsiZiLAvYfB8J94PiMu7EpwhTF7KOFzlfVW0emq0sCXoCw9I/twtacUSVWfoGyYlK0tpoSn4SC6KQse6EFhhmvmIDHjW2jyM4VmC4+F914TGjWLv/r/5UZYhJVMeSzhzqIxowoXpIJMCRnxw8o/67GC7rjoirwKXPUSxaFu2bWMQ2p+xQiObKXdjZ52x3AdICrZzpuyiqWSix2bebUckNRP3W8qDhEQWjdQNJhaCibWGASQJb3/Kpo8laG0iWX+emMFtZCmcoz3ZVeqtxVP5VMZiQjOuJKJ6gCgcIP0WfeaWvhdX9+yHio1sb7oQOCvG5Cgwvs1IcGljg6qGF2QLlhYD1GWfPHbCU+MzwvihYp4UzXWl9TdQmpAVJW+eZZJxFi+vj39RFEdIwUVWRAxJ0sU8e74vQnkfowtDOQHEg3vNFqmu3eKqXtWiMSh+RitKmTyPqljTnoixuKw4p4i84eWoX4Ml/Nj69wwBRCrKhBUA2BpNOSad14Wmg3Hzt+L2BdpUfcA6RY8OnjOCuZqcl+5jKfn3MwcpMVI5M9QlPu1n0juLLoAZaSW6gdJ6hr0c16Q0uSdx6M2sFE4MAs+PtYzghC+rSMwMA7nFN7yv13V54IfRSwVkJ2V8/pXc/0252hrp7qa47pjGHJ+79sdKtja/bG8U3owkbHyEchaaAUWBlhWoyAfqqJa63K6DwL7wPjzZCDH
 d9ENjV4S
 VdbuwhsA4Hn3dRy43e87Hc/NKQ2OBwJ5yWupWiXNLcfzPB9AzGvR6lsHrLFM25JLi1J4uljidlLlQvYXLrsNMMUZOv7W9io7XhmGZ4+Mye8kWrFRsva+yEEyhfhE1AM/0XI45MLm1Q/8ju+iIapXQHKf90drWEK4kgyIBGdcYrw1/nVNgodl777UwteNG1k/vOW1knrBgtBFJ4IZQg+MolWI0o7DBBlXOSRz1LhiN3AxCDuiMHBEc5LhAB3P82R7dEwVJzp9MNylzoh+qhu1QEmbkVisNP6BW4ziQFVIirObTLwb6SmSUCZl7eZnsCW0Tpp5Y3Kz52psygOefXhQMHF7DG/EKyXFOebM3hKmxEMs4W7AXGYPIdT3fM6Cx3PRP/U8zNRo0PSOX+g2s9OJvTd3qkCuocfRSErPRZAJMBypTFa+GwIxJHtjrFc0eEhbXsCqKllD15j6rzfVwmavNZt//ICZ43/bCDnSA/LpDHyD/ul0plxwseKRwCMwTGIKz7J+R8QCdhsVTpjs3o64wb8HkVqg/6/LuGLnCd0dPawr6snvt1cy3ONj6nXg0kJgddH9jJJPdCHQ9IRVQCAY5Kp9hLyuC317CqZipO50hY3yrBnVxMV8gzmpU+5I7aUH6b/zUOMgJXNn7p3uT8QLUO9dTCCgU7eaNGl9ngMYVMXjQnVNIYAD91ZjJlzflaHk28MJ61wTqicH1Sf0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 August 2026 17:20:51 BST, Sean Christopherson <seanjc@google=2Ecom> w=
rote:
>On Wed, Aug 12, 2026, David Woodhouse wrote:
>> On Wed, 2026-08-12 at 16:03 +0100, David Woodhouse wrote:
>> > On Wed, 2026-08-12 at 15:34 +0100, David Woodhouse wrote:
>> > > On Wed, 2026-08-12 at 15:05 +0100, David Woodhouse wrote:
>> > > > I'll rephrase that for my own understanding:
>> > > >=20
>> > > > *If* we go all the way to building a whole SRCU flavour for this =
*and*
>> > > > implementing a spin-only variant of srcu_synchronize() which is
>> > > > tailored to the atomic-reader use case, *then* we don't need to r=
emove
>> > > > the non_block_{start,end} guards around the MMU notifiers, which =
are
>> > > > basically never being called anyway and don't actually seem to pr=
otect
>> > > > against any real bugs=2E
>> > > >=20
>> > > > Yes?
>> > >=20
>> > > FWIW it looks something like this=2E I'll throw it into my torture =
and
>> > > latency tests, and we can see what Paul thinks of it=2E I'm still u=
tterly
>> > > unconvinced it's needed, but I concede it has its good points=2E
>> >=20
>> > This slightly refactored version is the one that's actually going int=
o
>> > my torture tests=2E=2E=2E
>>=20
>> Well, it survived first contact, and it's doing the soak testing now=2E
>>=20
>> The average is basically no better than the try_synchronize_srcu()
>> case, unsurprisingly =E2=80=94 as *both* of them just observe that ther=
e are no
>> readers and proceed immediately, in at least 99% of cases=2E
>>=20
>> Like the existing rwlock case, it still manages double-digit p100
>> latency even when though *doesn't* actually sleep=2E
>>=20
>> I don't *hate* it, but I do question the benefit of it over try-first=
=2E
>
>FWIW, the max latency and >8ms numbers are very appealing to me, as my co=
ncerns
>with using SRCU are all about the tail latencies=2E
>
>But I'm obviously not the one who'd be saddled with maintaining the code,=
 so I'm
>more than a little biased towards choosing the more complex version=2E

Ack=2E Well, it isn't even *that* bad in terms of complexity=2E It's mostl=
y just a while loop around the core of the try_synchronize_srcu() I posted =
before, and some syntactic sugar and safeguards=2E

Let's see what Paul thinks=2E



>> Again, I'll defer to Paul, but personally I'd want to see a more
>> compelling use case for it=2E
>>=20
>>   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
>>   =E2=94=82               =E2=94=82      expedited      =E2=94=82     t=
ry-first     =E2=94=82       atomic        =E2=94=82
>>   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
>>   =E2=94=82 median drain  =E2=94=82 32-128=C2=B5s            =E2=94=82 =
4-16=C2=B5s            =E2=94=82 4-16=C2=B5s              =E2=94=82
>>   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
>>   =E2=94=82 avg           =E2=94=82 118=C2=B5s               =E2=94=82 =
13=2E8=C2=B5s            =E2=94=82 12=2E3=C2=B5s              =E2=94=82
>>   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
>>   =E2=94=82 >1ms          =E2=94=82 ~950ppm             =E2=94=82 ~990p=
pm           =E2=94=82 838ppm              =E2=94=82
>>   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
>>   =E2=94=82 >8ms          =E2=94=82 42ppm               =E2=94=82 4=2E4=
ppm            =E2=94=82 0=2E10ppm             =E2=94=82
>>   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
>>   =E2=94=82 max           =E2=94=82 33=2E6ms              =E2=94=82 17=
=2E6ms            =E2=94=82 10=2E25ms             =E2=94=82
>>   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
>>   =E2=94=82 fallback rate =E2=94=82 =E2=80=94                   =E2=94=
=82 1=2E2%              =E2=94=82 0%                  =E2=94=82
>>   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
>>   =E2=94=82 sample        =E2=94=82 32=2E6M drains, 10min =E2=94=82 41M=
 drains, 10min =E2=94=82 40=2E5M drains, 10min =E2=94=82
>>   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98


