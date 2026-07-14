Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D06CEC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 11:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5DD06B0088; Tue, 14 Jul 2026 07:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0F586B008A; Tue, 14 Jul 2026 07:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B04C6B008C; Tue, 14 Jul 2026 07:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 698196B0088
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:55:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D62B51A03AD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:55:47 +0000 (UTC)
X-FDA: 84987227934.28.3FA10AB
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf04.hostedemail.com (Postfix) with ESMTP id DC94240007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:55:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=CVv3c2hh;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="f NsAiUF";
	spf=pass (imf04.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784030146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+24MjkKOyccdIXKr6nivOOwP9jmSIAod++JgzQuHBc=;
	b=xW6bSIy9s4mKCFT+3Ki/BzF6ZncCvlJN8Lg3c5yOcvPoLOKAK4VXrCuZ4aIvA2rKt4WYBz
	l2SKLxx0EaTePXkVkW6DJWB+acXSaFg4v8+65FsAaOTrej2B0vjlk8ui2qISeirDHsk0dk
	/GdDCUiBqfNxOeppxkfdriid+Tkj4b4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=CVv3c2hh;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="f NsAiUF";
	spf=pass (imf04.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784030146;
	b=iSw3Jqqh9JaTUGR5GpPvEgDXqDzR04owY6njkgrpAVKK+MJQKgGLkqyWTADFlwcRzf1eUf
	uGYWiW84SMHhOb4VDYuKhbHwdRmBSVJBaUEamIWN+eyuqK+/Ncw7Xy/DIWe2KJSNs/524C
	r2+CxQibCRK0YqtO9Q+8P7APrj8S5Gc=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id EC16A130018B;
	Tue, 14 Jul 2026 07:55:43 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-04.internal (MEProxy); Tue, 14 Jul 2026 07:55:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1784030143;
	 x=1784037343; bh=T+24MjkKOyccdIXKr6nivOOwP9jmSIAod++JgzQuHBc=; b=
	CVv3c2hhp8uDNc5r7ko2QUEtAAEx6nH7+CrFdGshtB/9AFtkXsk+/qw3yHVkZex3
	Vu2pyZGe7H8X64Mc5ca+WSXsO7bWC9O09NZdEmA7HZE7eZ85HM3/1zLXggvYdeuM
	16qF02oA9jL+4y2fpX6uD2YZuMPLGt0nMGRyEVu6f9MeJYOE+aR6E1lpqUGQowZ1
	KP9Yq4MFqjRpWhYQBq12QjfuhTqbRZiaiTTMwnONYQKH0y2vq/r/elX57A31FF6N
	1W3e3QWu1DoyiVFQBGIkueMbUdAh2ZnUSSYsL5UDCpUp3AC/zE/RYCulDhbLOw7k
	+uFvtuEOSR+bhu2NrvK7aA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1784030143; x=
	1784037343; bh=T+24MjkKOyccdIXKr6nivOOwP9jmSIAod++JgzQuHBc=; b=f
	NsAiUF2wwNHbm2aRh2VZvJga/CUIwB0EAlWxBskMLODdHCILE6vnzOvR83AnOzQl
	C8hVCO4GyTMsu7FBrFxQGuSWPsKy3FSWOq1c+xUKsYqBv4uEqrRFB3gayLttIqS2
	u83K4SQN9y/BFFYAKEW6yjopRJxx9hQlgxhLko+W03RWXrYA4yXKm7O2ajDzwFFM
	e83tcetVh9XkdyXTnKRy2e8TO+K900r4hcchIyI+CPCM7XZqPq1GFTEy7UE4lIR0
	J7HVETXUGSGEAo0czc6ylx+mDLI8TqprfL9KLguzXthnTGD0UsguRyqtmSV0VkT6
	6aVmY5FL81d4cieO9JZ6A==
X-ME-Sender: <xms:uyNWalt8ukQBwYv6Gt7VUExfITQvBsstUE5RUTrzK0Gvq159mQn17w>
    <xme:uyNWapSIkzhd8c-ahrxBAFufEnZo3Sne1Fl2cbjrg2ZN3Lccmh6C_o3P-DfGDFxUn
    sIg0pYngkjQSeMNgV0UWSAbmfoOFhIz3T9S5pIE2SX34C6jv1pjP8tw>
X-ME-Proxy-Cause: dmFkZTGxIX4qsR7V9UOAbbpZ7DI+TPioS3EdeOfkz2sqQrWFwCwBFa2jO13xOhfwAzebyL
    vDn4L3EOcKqRhgsBPy8K0LlhasC87RLvJKakFM63Ex5ajF1mW9HBfU9h64M01z8Zkd1enj
    GGlJ+S1uE0LE0ntEkqcD2W8Mc7+iLE1JAn9qBp8jOSHfQ/492DuvwwXjB3rPP8pj/tMaxq
    q5TAvzCpGhJ8fPEa4+CYMo9P46KZqjk/ruzcYSl9IYoSn7a13f67wJC/dG+TgSpdxoToXo
    rHMhANm1HxqVijJlmPefX4wiI6JZN4Z55MCfIh8k55OoUatB+dk0XUuzpv91MEhl04VWsV
    ZSok8TCuuKj8PWwP0EiIT6QCPzE9Rhj+56/WVYSuoFKN5pnvjixLDWFi+WaLep3dlBF/ZM
    R1gPJomvZP0vI1mZd2xbHjHC4PbZoDJZaTI2Ff/jkCigkrwZtlj8DSAfGjPYx0nC29U3Zy
    hDEvNQoI0Xi+DgnJGdxCmodO1+oDmF5qjsBDd7dKYUF5QBBYz+zfMf4uhbEhlzoLTu8U5r
    m8QjPMKAYeAQelZO7q1lnl3i66zJ6sB+Q3LY9jh3ODNPd2SBRx29u7BvyOPJFOnGnIoKbW
    izEG2Rtu653VGFVorcXYXHnVQAnHtxZF9aSmlvX/LNWUy3QkWR/KwJPtp2hw
X-ME-Proxy: <xmx:uyNWaqzCG7oLkHgr2707HaSDbalGogtx1FIQpREY7NUn4k5I1vhZog>
    <xmx:uyNWagdqLr2-T4dQLiEGj2x5Ja7MmcDpQ9saR64VrBglZHa2LLs_GQ>
    <xmx:uyNWag-NW5lmoFjivEHv2jK6SIAsug9P0F140RFyfmM4dUQcWFnN4A>
    <xmx:uyNWahES6J1uBUFym_4ngGCm93iVp4JHd694IJ2fGtylDwcLXlD07w>
    <xmx:vyNWaurTTdPA3xEUOXdW4cewVvGt51MQOAWINakqJRR53uGyaCedkGEK>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 57A521820082; Tue, 14 Jul 2026 07:55:39 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: ASU80-mPZ9gg
Date: Tue, 14 Jul 2026 13:55:18 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Pedro Falcato" <pfalcato@suse.de>, "Yeoreum Yun" <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 Linux-Arch <linux-arch@vger.kernel.org>, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-mm@kvack.org,
 kasan-dev@googlegroups.com,
 "linux-csky@vger.kernel.org" <linux-csky@vger.kernel.org>,
 linux-m68k@lists.linux-m68k.org,
 "linux-openrisc@vger.kernel.org" <linux-openrisc@vger.kernel.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Russell King" <linux@armlinux.org.uk>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Ankur Arora" <ankur.a.arora@oracle.com>,
 "Mike Rapoport" <rppt@kernel.org>, "Magnus Lindholm" <linmag7@gmail.com>,
 "Christophe Leroy" <chleroy@kernel.org>,
 "Klara Modin" <klarasmodin@gmail.com>,
 "Huacai Chen" <chenhuacai@kernel.org>, "WANG Xuerui" <kernel@xen0n.name>,
 "Kirill A. Shutemov" <kas@kernel.org>, zhangtianyang@loongson.cn,
 wangyuli@aosc.io, "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Jason Gunthorpe" <jgg@ziepe.ca>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Will Deacon" <will@kernel.org>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>,
 "Rohan McLure" <rmclure@linux.ibm.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Tejun Heo" <tj@kernel.org>, "Kevin Brodsky" <kevin.brodsky@arm.com>,
 "Anup Patel" <anup@brainfault.org>, atish.patra@linux.dev,
 "Paul Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre Ghiti" <alex@ghiti.fr>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Andy Lutomirski" <luto@kernel.org>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>,
 "Michal Hocko" <mhocko@kernel.org>, qi.zheng@linux.dev,
 "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Kairui Song" <kasong@tencent.com>, "Barry Song" <baohua@kernel.org>,
 "Axel Rasmussen" <axelrasmussen@google.com>,
 "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>,
 "Andrey Ryabinin" <ryabinin.a.a@gmail.com>,
 "Alexander Potapenko" <glider@google.com>,
 "Andrey Konovalov" <andreyknvl@gmail.com>,
 "Dmitry Vyukov" <dvyukov@google.com>,
 "Vincenzo Frascino" <vincenzo.frascino@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Yang Shi" <yang@os.amperecomputing.com>, chaitanyas.prakash@arm.com,
 "Ard Biesheuvel" <ardb@kernel.org>, guoren <guoren@kernel.org>,
 yang.li85200@gmail.com, "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Dinh Nguyen" <dinguyen@kernel.org>,
 "schuster.simon@siemens-energy.com" <schuster.simon@siemens-energy.com>,
 "Vivian Wang" <wangruikang@iscas.ac.cn>, junhui.liu@pigmoral.tech,
 "Muchun Song" <muchun.song@linux.dev>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
 "Nam Cao" <namcao@linutronix.de>, "Pavel Machek" <pavel@kernel.org>,
 djbw@kernel.org, yu-cheng.yu@intel.com,
 "Baolu Lu" <baolu.lu@linux.intel.com>,
 "Jonathan Cameron" <Jonathan.Cameron@huawei.com>,
 "Coiby Xu" <coxu@redhat.com>, "Andreas Larsson" <andreas@gaisler.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>,
 "Geert Uytterhoeven" <geert@linux-m68k.org>,
 "Stafford Horne" <shorne@gmail.com>, "Jonas Bonn" <jonas@southpole.se>,
 "Stefan Kristiansson" <stefan.kristiansson@saunalahti.fi>
Message-Id: <b7dbc476-1477-4004-93b3-c5e667e24df8@app.fastmail.com>
In-Reply-To: <alYL7B0HAvmLVHGU@pedro-suse>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
 <20260713135614.1618183-3-yeoreum.yun@arm.com> <alYL7B0HAvmLVHGU@pedro-suse>
Subject: Re: [RFC PATCH 02/34] ARM: mm: make 2-level pgd_t a scalar
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DC94240007
X-Stat-Signature: dh8tn85xccfmt1sc6ty58dxgwrcqhbfm
X-HE-Tag: 1784030145-690874
X-HE-Meta: U2FsdGVkX18zPEY0OVRizO6T3CB+pkPTI6C6yO7P6IIYFTyU4HkPa7YUh+e6/iNf5+ULiyBoI41m2TMiB7u7PhGhCXnlfb5gWcpWRFXfA2DOfGqLjNVQBn3BAYylKqofFc+tzJsGYYsaPer+gS62YpRyArcMEm37NASpSPHbVH9ZttRhrXiLAARjddOcJ3OSpoCJBnhky2qNeRmLxXoicizej8+5++z4K5h5GOhslsefPJJSZ+17ms2xfSLgppHDL/UixdQpPF88Qxle2ritnJADOB8UtNfHdS97djPlumQhfFWyTsxVRg3OyjRTThjpU/+Gg3DCQ/drXC9YmkdJKE8saydKSVh4GjZgifC4ferWgdszoS4JVdtHVlMA0XOgpogbJJFkH6tqj/QES48gmlHVsGn3Lm2hahByf4kj+e2Vht9YreAlHVi6xXpW7M++wsNkzkbYRneqwVmKzQYeva4gt4q0Ps6MvMikumoYv7DhfA6/aRCz+hf7AJGajuR5kxRdiBDLMJaNK6tlPaVwyZrwrz9sNb/U20mJt2wx9nshLoUcVbdopRtDE4O67mL9x8w7hki7WLkqY8z9pMpnSvMhWbhVAyh6+Zhq9j7MJm1hAXj0fUvdeTe9GfpSkTHvsrVcb4XhcZygXak9mVUzHve/VDwxIvIhbaJQnG3UhcAR5eXKRVj9YlGX9cxM5Eiq7jzW72H6OhrCThoZZVIB7+0GX5HElvisa9oJDRLDFUE0Y80nO8tk/TTPlEL/LsUAcThKUuRZO8cWyHd+4Aw+nzN7+EGRcqPkNTd+LwhEYNmNQBLr6IzKcn8Q8E0OgWDtW26iqaq+8CHUVmcebUQJ4xMi/omD+7gYz7IrbAcHwyNzoUWwHCYm9L7dJyXjlLBj4m5DlwBm79V0oyILUkS5D3471jMq2g8aSzKWbn0S3A1+udjbC8rauK+smHGyBNXUO/SaztZs55eoSq3UCrD
 jRTb+nR+
 CtV0Sm/PMMSiKrblPq/NLZoZTwd+vCybzVZnScnqag92yxQYFYVaJItGaku4VF2JEHohUWXyRw5NQAK9K5MTUFGcVgqDAUh0bSMTx2aPIUaRRDbUlA3B5yA8/nWxGagecGRqGyPStyb6bPTneJC+Xz1B30L+8aXA4q8HJSd7Npxq4YIszJzFby+V9fKmGejwQjYFuI4M8ycZzmlP27Baeq8XfmT6/cXQFhHjK0juH69Q+61vVr2BApPNLzwhL1zFlJmI0IMvfQlcigfpIoYVz+CsXqUsW0VWTx9+OQr3kNMcrVwEL+9+p7aC8VB7W3/Sx697TlMR1c9T8g26/hv7TPUV7l3uGOzxwFLTWxSsS0QT+trMpZ/mA49XIRhd3Cyhvv03pi1LYTNIbgso0NwSbkSPfxGcT34BCRpPrG/C0J/cEgQtnRzmWwFFJ70HG3869XskfVAwjT7ILMm3PeYxSTAeh6Mfic28LCLZRYrprC6v/olxxf+gN0D5tAkcqHtUupb+GBxdgoude92zq8aJ8WU1Yl+l7s/+hXydArVT42pMKAeR/YPzVulRXgosWHC+oqwGU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026, at 12:26, Pedro Falcato wrote:
> On Mon, Jul 13, 2026 at 02:55:41PM +0100, Yeoreum Yun wrote:
>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>> 
>> We don't want pgd_t to be an array, as it prohibits returning it from a
>> function, like pgdp_get().
>> 
>> So let's just use an u64, and extract the right 32bit value in
>> pgd_val().
>> 
>> Leave the STRICT_MM_TYPECHECKS case alone for now.
>
> I have to ask: is there a good reason for the STRICT_MM_TYPECHECKS ifdef?
>
> I see the compiler has an awkward time returning a u64 struct (see
> https://godbolt.org/z/qejbv6j9a), but if this doesn't work maybe we should
> get rid of the STRICT_MM_TYPECHECKS stuff? I seriously doubt anyone is
> purposefully toggling it on for testing from time to time.

As far as I can tell, the #ifdef was originally in i386 and
got copied to all other architectures at the time, but was
removed in linux-2.3.23 from the original copy when CONFIG_X86_PAE
was introduced.

For some reason, only sparc32 and arm32 still use the non-strict
version, with arm having changed from the struct version in 2002:

https://github.com/tbodt/linux-history/commit/5a8202f0259a
https://archive.armlinux.org.uk/lurker/message/20020306.213958.cd486eeb.en.html

> If STRICT_MM_TYPEDEFS's worse codegen doesn't matter then maybe we should
> permanently toggle it on.

This would definitely need good testing. It's possible that it's
not that bad on modern EABI builds (i.e. everyone these days) as
well as modern compilers, as OABI definitely had bigger problems
with 64-bit arguments.

>> +static inline pmdval_t pgd_val(pgd_t pgd)
>> +{
>> +	return (*(pmdval_t (*)[2])&pgd)[0];
>
> Ugh. This isn't correct C code. It only works because the kernel passes
> -fno-strict-aliasing.

I think the bigger problem is the code dereferencing the pgd
pointer in the first place: Since the pgd pair is written in
32-bit units in __pmd_populate(), anything reading it would
technically have to operate on both entries.

As the kernel relies on -fno-strict-aliasing, the type mismatch
is less of a problem than actually doing the potentially wrong
thing.

As far as I can tell, we are however saved by pgd_val()
only ever being used for debug prints, where printing
the first entry is likely all that is needed to analyse
the real bug.

> I would recommend either forcing a struct here, or
> using a u64 with bitmasks/shifts.

That would require extra complexity for the big-endian
case though.

    Arnd

