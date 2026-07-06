Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 308FAC43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 12:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C8EA6B00A1; Mon,  6 Jul 2026 08:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0F26B00B9; Mon,  6 Jul 2026 08:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 092076B00BB; Mon,  6 Jul 2026 08:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCF686B00A1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:57:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4B8DE8DC79
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:57:58 +0000 (UTC)
X-FDA: 84958354236.23.37BD3C1
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 74FC74000B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:57:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GryvCmtv;
	spf=pass (imf07.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783342676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hO5ho4KeiiLfcBaCI+3UMPtuUVrSULK4qaWn/9TzQms=;
	b=Azb5fQqFSrST3wdNZsZDeudPZxV2OPFT3sSO9RWs8ysZQQ06SPpGd//H+SI3hNgXekVaVz
	d4q2fIZ7iRzTEmulaHyzENYQdUaMxtz7MnYyrSSEch8BsHJQCSJQPp33Fr7URTM/5r3Aqu
	D3jzdLU0F4QUx2FcXGkqlb8SxGnZklU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GryvCmtv;
	spf=pass (imf07.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783342676;
	b=5aAo9K+ip4REuvVlpMRh7reO/UCjfzasF8dIo4N2NZ7m6w8eT6Jqa2+9ALWzZsUt/bFovp
	nTXClyto2kF67S8FqhVYPMcCUfEqQ74mS1XU5/74VY7WT2MbF/Du4p7nEs01JVsHWLuh+X
	ZSiaBWtXet8IZw2LjzWyXIDuQFb3TC4=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-847917c3678so2186426b3a.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 05:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783342675; x=1783947475; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hO5ho4KeiiLfcBaCI+3UMPtuUVrSULK4qaWn/9TzQms=;
        b=GryvCmtvJvaq6zNHdPXpkLuXU3eao9Wp0ZnT+d7kCu4c8HybTpjISO30MKevDEZ5Be
         pzCCsDkURaXB7MXgSi976Cz0szEaUEGUE9rVTMkZc2rGcizh2WWwmXANdJEIAU9f8J+j
         NzDDw03MGNl2G0d2HGefasmB2AZ28SaNXJ6kZFUxb9YiCMDIl228wak9yK2NU41dCQ8N
         p3h6MJ8uIdFHVTik2hXDsmS/+UUfAfCpyTmM15GFJ1H8vh7R87L+LtI42rDSqheYNZZU
         EwY13MXPag7KIO9mt+dX7mVFZBNm3ECIThxuciVKXcGN1YT0Q+mN1G2F3gOH6qYe7VOC
         F6ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783342675; x=1783947475;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:subject:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hO5ho4KeiiLfcBaCI+3UMPtuUVrSULK4qaWn/9TzQms=;
        b=EbM+D80CFrD5ByqGg8rivkbbdFrb7vjZ2vcJiaK9Yj5I+NTc3qudu7Zc4GwjE58Hp2
         FyZb3hZihNGiVNesvU3FObFraAo4XURqOPD37GEnvwBTlC/P+r4R9X7/zrENYrWD0GXv
         G4rxGa+pHC4rk2EZu/vpO3LNyA014EcF9a2Gq+xq/WpHvxZ2sHSDKGM4NyL0APA28sR+
         0s5IpRIIAkjm+DdU/88lTUGqCrLqa5vBp0n8Kn8GjxLO0fVNS+SCe3xAQ9K5TAJNkU5I
         Rl77lBtcFgOpQi1p5FCqPvdxEc8DM7Owj/ct30FGxPHGfvfBcoZWNxYT6MqKJvmEMtIX
         oeGQ==
X-Forwarded-Encrypted: i=1; AHgh+RoB6D/+oRWSQbXqoocsg4LEBos4mrNh4v72gfPnHFkTYWtXCJrWrMkZ9wPeQ4q9+h4YNVmJI5UkSg==@kvack.org
X-Gm-Message-State: AOJu0YzdIdI/ikNb72A/o9KXkJuHquk/ZE7r5y+MTfEZp/kL+tNjnTAw
	X9pvO3bh/dkRzUloBeRoh+JV/7LOrC4Btp5TtFW+0fL74dSfxBR/ee1Q
X-Gm-Gg: AfdE7cnY/WaU0PWlNNLKX+aJjec1zYjRJyfYvYGcREuUN2o1kYxX5iZxdW7Rb87o/Qb
	VudO4WShNCCCsDvinVQ6HaBVnlWV3garOLKQ/pyvnJEVOKzXPUxEyp/uFuBrMa1zk9C6hOBC/lp
	P1MUAnCvSh/rtek4/Qkxx/ks9lsMd/xD4KUKme4b7cZAl0LVO9jCeovU4SWcgLjaxn1gnnA1U1o
	wbyJ2LiupaVWVeNnIl0apEhZ2sgirUtX86UwZN39POHN47Lvwot6hci20EToc3/hhZmp/5NjVdB
	BQKB52SvzK+TAqk3BvF97kPkzx3njatvWSeJQzQmMbURU+F6fSPVvf/yKQr6iN3DEeStVttQVqK
	qq9ET6TH9e0xTxhzn04VHIxgdxeWjWd422FfdCEUQwzQyBU/mBbRrp7S2JsYqgML6Kx4squl7wx
	jYUW6tjhrfCF5zdbVvjdaGYUbsMvY/XtYBkC42SR5Sjzag1DJRquQbWqakn4mxQnY92UuOOmMuQ
	rt1PFI7/YqP/1TeQI3hXqenbbdDx1HrsHyNmiDIWh0O
X-Received: by 2002:a05:6a21:a91:b0:3b5:530d:d96d with SMTP id adf61e73a8af0-3c08e6b4b43mr515293637.12.1783342675118;
        Mon, 06 Jul 2026 05:57:55 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e8f5c175dsm6341551a12.11.2026.07.06.05.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 05:57:54 -0700 (PDT)
Date: Mon, 06 Jul 2026 21:57:51 +0900
Message-ID: <m2o6gktgvk.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: ljs@kernel.org
Cc: geert@linux-m68k.org,
	akpm@linux-foundation.org,
	willy@infradead.org,
	liam@infradead.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	gerg@uclinux.org
Subject: Re: [PATCH] mm: nommu: point to the write iterator upon split_vma
In-Reply-To: <akuS-6zegY2XBa3f@lucifer>
References: <20260702012546.665383-1-thehajime@gmail.com>
	<20260705152708.582fd8d87561f600da23c0a7@linux-foundation.org>
	<aksn5J8Nr0JIsVpQ@casper.infradead.org>
	<20260705222343.5d5c78cbb54839c5efcaabf5@linux-foundation.org>
	<CAMuHMdU36O2UqfQkbbgOVSH5KFU-MZ_WO3jRsLumkUu22iC7vQ@mail.gmail.com>
	<akuS-6zegY2XBa3f@lucifer>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 74FC74000B
X-Stat-Signature: 1mo8asabmca8zb74xrx6me4o58gfewkk
X-HE-Tag: 1783342676-301183
X-HE-Meta: U2FsdGVkX18wtOcPNwEFq1JuK/S3vJJ8Fv8LgQOQeZioPcogQzgKdYCj/bDxHP1GupV+4pWfRU0x7r/+inMZ7qAQoRPYgfdtYbF6VpC+YbmIa33jC85NK6z9/UP2iL1AD3iNjnx+OtlPKHlYPmdvByvGqrvNuAnmUjDvKppvanIaIVfurh4FqRjxjqYwLeYHZKeJiPlApg5PYV47Dt8T5j/HgDNubIIUw4UsS4ggyX7hnQhof579HJguMeuwEAWPQaIZSn6QRvqcT5B3gOtj01H5dcEDmHgLZEtfzvDeaOItklto0jqN5ic+iSDqRbe2pffksIaDpk30OT2Yy+xfrfS3ByUF8r0ZCmL5JR13qHquNn3RL7M8GgWkW94ldEjBJOBjtFC627n6kMUo+ggHT3CGnlKCP6/FW03KXdgINHQtPXlNDfHiMeX6167u7dHl5vE8b0OWaSAt72ChBlXcWng/1HT9Hn3WgZhmdhoN8/4tHRRYjc4Uqjj/BNafyt2erOMf9rAzohkRaxJdzYot0yEywSlK4X0nUlHqemqdIDSeIdcv1LpVVMyWsLBf9i17ERCHuh45ZyIBVbubuuqSIHmwL27iCQZCcgr/l+QSWcZG4ag5X43XSZMF75jEGo7PTvYg18n98H+0SWOo8W3x7j6ClKz6Lugp+hvP6MByvBbC4zUKozktrKL1z89Yf/AIJAEQEG6gfGFXF5FZjVXLGhucw+cddywi/nOmi4UmFi8JkdvuB96O7LmDULu1r/aDSWr51QMfqNdw66jP0nYtTXXmYtKegjMMjp45AtHiu/EG4kNSO6T4n3DDU0urVwO13uBTxX9kJJ4RWQThsu8n9cEddJVx3rCYAKyP+/qZpP5675DUOCKOBRe9aAo4dinTn8R1sdfCTUOUiilHRd35OE7r+nse3Y9PaRMi2lGN54kMZnJmDk+Wi5KAL/yP+nZwgD2bVEh/cUmfaQXt+yl
 XhpDGBD6
 rp8iG9vNtI5z1qjnViebtUjt9bcFwm04Fne0r5uebPzOGS4irFeVfGu+gmo05hOdA52TGDvuplvJy755VVEempAWcJnabF3QfI3gXRJwsfLN/sntyRkGNQ1hvmP9cPDl7oIzZhficN36vYfL5ye44R4oVaXH+5gq/wMMVpxKS8IqSjbgWVDJ4Jzs2KnqfJxa1GCUw8jlwWiuJ92T9BQMdgVzWhJziD0kAPAsIatgXMQ92tO1TCppvwqag/0hae9+l8gpgtxm/uQkR3cIzBTxCx7A57PmTJZl1OvecRJZC4x2XquV/GiY80M9OrcbOU53j1R7fnEchdcRW6mlsL1DWNazOXepK8owROGz2bBcDhcXPFUhZaZdPOP9DoteqMEmpqodnrw6CjGpMHE2OHrWhC7Mis3ZP17Ra3AOeecmqORv7Bp9JAgMtk8k4PZx3OrlaxRy/7CHf/sEoAFc39oakPF67PI5jtCYjQM8WDNJqRDwrXuGn1NvrbN4ms5qhOjwaPB/hIwk3Gjau042L3VhPiMadWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, 06 Jul 2026 20:51:36 +0900,
Lorenzo Stoakes wrote:
>=20
> On Mon, Jul 06, 2026 at 10:27:43AM +0200, Geert Uytterhoeven wrote:
> > Hi Andrew,
> >
> > On Mon, 6 Jul 2026 at 07:23, Andrew Morton <akpm@linux-foundation.org> =
wrote:
> > > On Mon, 6 Jul 2026 04:58:28 +0100 Matthew Wilcox <willy@infradead.org=
> wrote:
> > > > On Sun, Jul 05, 2026 at 03:27:08PM -0700, Andrew Morton wrote:
> > > > > Thanks.  Unfortunately we aren't very diligent about the nommu co=
de
> > > > > (are we?).   Perhaps appropriately - clearly this code doesn't ge=
t used a
> > > > > lot.
> > > >
> > > > Should we delete support for NOMMU?  As you say, it doesn't get much
> > > > testing, or presumably usage.  I have this quote from #m68k a coupl=
e of
> > > > years ago...
> > >
> > > Greg is busily developing kernel code.
> > >
> > > > : I looked at nommu very briefly when I had my 68000 board on the b=
ench
> > > > : but didn=A2t get anywhere. Also didn=A2t try particularly hard. I=
 think
> > > > : you are better off with fuzix or OS9 if you want something unixy.
> > > >
> > > > (i suspect Zephyr would also be good, but it doesn't support m68k, =
just
> > > > arc, arm, arm64, mips, openrisc, renesas rx, riscv, sparc, x86 and =
xtensa)
> > >
> > > Greg, how mush use is NOMMU Linux seeing nowadays?
> >
> > Nommu (SH-compatible J-Core ASIC) is used in actual products, running
> > modern kernels.  The rationale is low interrupt latency without using
> > a much more costly app CPU core + RT CPU core split.
> >
> > Please watch the recording of the "32bit and-or noMMU Linux BoF"[1]
> > at LPC2025 for more info.
>=20
> This crops up now and again and people point to uses, but fails to addres=
s the
> real issue here.
>=20
> Nobody (aside from Hajime - thank you!) who uses nommu maintains or contr=
ibutes
> to it, or _even tests_ it as far as I can tell.
>=20
> We broken nommu for a year I think it was? And there wasn't one report.
>=20
> The last time I raised this, I was admonished and told there are critical=
 arm32
> nommu devices that absolutely _must_ have the latest kernel and this is
> perfectly working code.
>=20
> And riscv also introduced (and I'm so very surprised Linus allowed it) a =
brand
> new nommu architecture (!!)
>=20
> And yet...
>=20
> If this is really so important, can those who care perhaps help out a bit=
? At
> least with testing?
>=20
> I'm a bit fed up of it really.
>=20
> As far as hobbyist retro stuff and upstream goes, I am sympathetic, I cam=
e from
> being a hobbyist (though not retro), and would be one again if I couldn't=
 do it
> as a job.
>=20
> But retro people do NOT need the latest kernel. As far as I'm concerned, =
museum
> piece support should be ripped out, and those who care run downstream ker=
nels.
>=20
> As for the 'critical products' that must use nommu - PLEASE start
> contributing. Please start testing. Anything.
>=20
> Again thank you Hajime for doing the one thing that really counts here -
> contributing to the nommu code.
>=20
> Anyway, as to what Matthew said - 100% I am for us ripping it out.
>=20
> But it's not up to me, and unfortunately I think we'll get a clammer of v=
oices
> saying how important it is, and silence again when it comes to do any of =
the
> work.

as nommu started for embedded devices which are not easy to test, I
agree that it is also not easy (in my opinion) to maintain.

indeed, buildroot images for nommu targets (with qemu) are available,
but running/testing each of commit to the kernel tree give me more
than 1 hour to rebuild the images (including userspace build with long
flat binary conversion, etc) (which I'm playing under github actions
with riscv-nommu).

# yes, should use ccache :)

one of the goal which I am with nommu UML (*1) is to provide an
environment which can be tested in a simple way; runs on x86
machines.  An extension to UML means that you can also use KUnit
infrastructure.

LTP (Linux Test Project) dropped the nommu tests 2 years ago (*2)
(which is pity), but the reason is similar: no maintainers appeared
when the project asked.

I wish to be here to improve this situation, both mm/nommu subsystem
and LTP, as well as any !CONFIG_MMU code in kernel tree.  This patch
is actually discovered during LTP (re-)integration with nommu kernel,
which I'm going to propose to LTP.

I hope this helps a bit.


*1 https://lore.kernel.org/all/cover.1770170302.git.thehajime@gmail.com/
*2 https://lore.kernel.org/ltp/20240105131135.GA1484621@pevik/

-- Hajime

