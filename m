Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FEBDCA5FC1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 08:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04C6B6B008C; Wed, 30 Sep 2026 04:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023E96B0092; Wed, 30 Sep 2026 04:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA91C6B0093; Wed, 30 Sep 2026 04:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C37B96B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:54:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D87A61606E5
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:54:24 +0000 (UTC)
X-FDA: 85269817248.11.2E3EBC5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 445384000C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:54:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=aJzc5jIL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf01.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790758463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0UFYYKBUewXLJbGJZ9BEDna7/dDF99emZQefLuG6AWg=;
	b=zfN8pVaPn3TXk+ycaRwj8On9ZyGbGBq0xA/3//2Rqnu6Uv3cofr18GN3zMJd55kq9qAZvB
	plRxLrohoGp/nlEbXbBVZSPzeJ56E/OLBOfhrI4WB+UiUdv278LtVCvuMSScCrEd5WMwxk
	7Zzb28M0GpOrbJUE75yulbG5MIYZOXU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=aJzc5jIL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf01.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790758463;
	b=NZcTF2Rqxcm4OleL+42+/rmApUSa7e1J7zfZmYC6OfWj0FoJ5O1lV7uF4XbC940JyK+/AO
	9lXX7DtY4Md3EWJWFBqTlP0jY0RwNDjzuo6JaBDBKOFu2akzhTt4nmjODiD2aH82naglC0
	9y8hp2Qtg4ZAWo5yKIwafd3xZFlYL60=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=0UFYYKBUewXLJbGJZ9BEDna7/dDF99emZQefLuG6AWg=; b=aJzc5jIL6ZEo+riFOwoxR1oSNm
	C2hf1HPOb9+KTK8px2ooi5YPLIeRFxTZoinR6pVkeYDaZKn09QeR00yhVqRRjAPKdAPRJkoIrT7S/
	hRxVygx6bLPrPlKZSnQKreIhSWLLbwZnFvcJlIoRpu0zHhaZDBm7i980rS/vK3fK3nujDtN/6z8l8
	fLgOlnTOkOldZJL6u6dcGPuFYD8IOAfYYLYx7hVPjXkwkJJiUSDbMGWUxsizvsvnVwzDCw78nf0AV
	IzzNDXK6Hdr8Iec9g2P2seZ7jfrgAs9zrZtJEFt/4RzEbuMhSVTPiYHQJ3yrkx4qqkpIjr6CULMaD
	pmozWVDw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xBq4s-0000000B7se-1SQm;
	Wed, 30 Sep 2026 08:54:14 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D9DFA300673; Wed, 30 Sep 2026 10:54:13 +0200 (CEST)
Date: Wed, 30 Sep 2026 10:54:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Zack Rusin <zack.rusin@broadcom.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, virtualization@lists.linux.dev,
	bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bo Gan <bo.gan@broadcom.com>, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Long Li <longli@microsoft.com>, Andy Lutomirski <luto@kernel.org>,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>
Subject: Re: [PATCH v2 2/6] percpu: Bound decrypted storage for all x86
 encrypted guests
Message-ID: <20260930085413.GH88198@noisy.programming.kicks-ass.net>
References: <20260929040256.543767-1-zack.rusin@broadcom.com>
 <20260929040256.543767-3-zack.rusin@broadcom.com>
 <20260929075426.GQ4120091@noisy.programming.kicks-ass.net>
 <CABQX2QP0+Jr6gG0nZkDggvyGWCSHMNVKPPavZTYBqH+wg7rdMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CABQX2QP0+Jr6gG0nZkDggvyGWCSHMNVKPPavZTYBqH+wg7rdMg@mail.gmail.com>
X-Rspamd-Queue-Id: 445384000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 8gb5jcym6bcg6mjdo4y41dtr7ahgdx9x
X-HE-Tag: 1790758462-142948
X-HE-Meta: U2FsdGVkX19uIppiVhvdoX4dSTQ4mUFKMd/re4gkb6/ZHHYhWBiUYUln5Im15gTZNq0RwceEndiyNVBPtVjEa88RlvklTaunlsm+w0lCUIOufjrAD60CeHC+1frsU+YZlHbi3X+/NqgJaurqB6bn0X2v0MhTMLblaTIKSSHcWQLTPmlRHr7MztCoCUXFgEfgPXJkXf4DcIsaLQ5wZrJJhcpZppgHHohyWoWC7lq+x5QzXu+kVAXT5eqdQKW90dVLZ/E8BhzCl5CJXIDZL/XWbfedxIlRZWuP67vOsGRhmEt/J2JTwyB1X/N203C0zh4jwkki/NZoh8HhN7N555Q8i3Kcglxd8GJRD6g8IW6AzUpZV0+ZCl1cZ9ZHfmT4g55KEDZzli+oCyOTcbnukNHa8juJdwic/i518+i9bqO382YELhDxXV2E5vBqp2LjBf+8UmjxifbjGfpcCFSI6JxTdMm5Je82XCYH3zFckU5HFMfP023PuY70Xc85P565lOyF6XObEWPCoCHkwjhwpQah4sMwiRSM4UImd/yQCPZIgkkZFu8DFXs9dA0ZZz5SXthI65GR4ZzgPpdRYZ1F5kO5fRvBQjVChejwlcNYz7u9G6VNdy9MKpq7ET/wAKKAyv0PPq+0uf5d5pxyVVNqIK3UMJBiw790cwRdrsZ0Yd5ggHI/xfS7qGqIP/6yN4sJCRj50bK5TdxRsF9W+/0ueXZgU5wrOnuncG/tyLeFkY3rtJr36/vQYsXvDJmokiA2Bl+ZzipR9qUoGeXWBSuvPo+CdXHwbg4G1VfhlZ0YD4Y/cVBbnHrHX2hQRyswQq8tU9obi9F6HweZFiPZIgP2ce0nh5qiVJvU/9mIeGi6s6nfTfnvMfp0fcAjSr1ikR0JpStUJwIPTtXws5tFjwqt52f+9lweCXd3V2CzPY/z7rasSclgLmmAu3gO40wmSV3n/3irWOjhzqVy3e6lF3W9mOM
 8rUDQBbE
 steO5khLulm8l1nOPl/DMnTARpBCOOvPeaxdhBiY7p95sfC94yAPvoFztRzhSUBTwDD1SDEaQKu28i2tkEcOnGvbKHLwblXVujw1FLvcp22f9mn78tfLik0XwfuEcXqtxDtUMAk0SH4itLWt7xV1q38rUmQcj0AwHNWVh0IEQgN7kbPYrG8AKM2coOK7iA0UBC38ukPiIV5+qcR+2nEpgflQbB7JIX55WdsHaz/2V5P3G4erPEkQ7MJBplQnLMKpigl/wMS7+jZa2n631NIH9cCPF3OwiCIhDG0K5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 01:12:45PM -0400, Zack Rusin wrote:
> On Tue, Sep 29, 2026 at 3:54=E2=80=AFAM Peter Zijlstra <peterz@infradead.=
org> wrote:
> > On Tue, Sep 29, 2026 at 12:02:51AM -0400, Zack Rusin wrote:
> > > @@ -1022,11 +1024,13 @@
> > >   * Note: We use a separate section so that only this section gets
> > >   * decrypted to avoid exposing more than we wish.
> > >   */
> > > -#ifdef CONFIG_AMD_MEM_ENCRYPT
> > > +#if defined(CONFIG_X86_MEM_ENCRYPT) && defined(CONFIG_SMP)
> > >  #define PERCPU_DECRYPTED_SECTION                                    =
 \
> > >       . =3D ALIGN(PAGE_SIZE);                                        =
   \
> > > +     __start_percpu_decrypted =3D .;                                =
   \
> > >       *(.data..percpu..decrypted)                                    =
 \
> > > -     . =3D ALIGN(PAGE_SIZE);
> > > +     . =3D ALIGN(PAGE_SIZE);                                        =
   \
> > > +     __end_percpu_decrypted =3D .;
> > >  #else
> > >  #define PERCPU_DECRYPTED_SECTION
> > >  #endif
> >
> > So you're page aligning something that will get different protection and
> > will thus shatter large pages?
> >
> > That is somewhat uncool. We like large pages, large pages are good.
>=20
> I'm a huge large pages fan too. I have a poster in my office and
> everything... And I never do things that are uncool. I have a wwcdd
> (what would cool dude do) bracelet and I look at it every time I make
> a decision, which given that I'm old gets on my wife's nerves a lot.
> That is to say I'm handsome and innocent.

:-)

> The alignment isn't new. It has been there since ac26963a1175
> ("percpu: Introduce DEFINE_PER_CPU_DECRYPTED") under AMD_MEM_ENCRYPT,
> which common distro kernels enable. This patch extends it to TDX-only
> builds and adds the boundary symbols. On bare metal and in ordinary
> guests nothing changes protection, so no large pages are split.

Right, I saw it is pre-existing, but you made me notice ;-)

Anyway, the thing that wasn't immediately obvious was that we only
really change the protection for (sekjoer) guests. This means I mostly
don't care.

> In confidential guests, yes, converting each CPU's page splits the
> direct map around it. The alignment doesn't cause that: a large

Nit you could 2M align, so alignment is somewhat related.

> mapping can't be part private and part shared, so a converted page
> can't stay inside one. The alignment only keeps unrelated per-CPU data
> out of the shared page. Because that page sits in every CPU's per-CPU
> unit, each 2M mapping that holds one of them becomes 4K mappings,
> including the ordinary per-CPU data around it. In the layouts we've
> tested that's most of the first per-CPU chunk.

So perhaps a little more invasive would be poking at the per-cpu
allocator and having a whole 'decrypted' pcpu_chunk which is 2M aligned
or something.


Anyway, as long as this is sekjoer guests only, I really could not be
bothered much. Proceed, but perhaps put on a comment in the
vmlinux.lds.h to clarify this, for those of us who do not live in
coconut land?

