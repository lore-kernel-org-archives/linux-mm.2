Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0249CC44507
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 06:18:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E256B0088; Fri, 17 Jul 2026 02:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FE3D6B0093; Fri, 17 Jul 2026 02:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A2146B0095; Fri, 17 Jul 2026 02:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C7366B0088
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 02:18:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B3A578044D
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 06:18:12 +0000 (UTC)
X-FDA: 84997263624.18.654CCB5
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf15.hostedemail.com (Postfix) with ESMTP id B02D0A0003
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 06:18:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=qJurhs5J;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="S NFPT9E";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf15.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784269090;
	b=XUmrB+5/MGG27IRcdXWPgSieawtTfyYhunKWAFgGSe5Z1SluG8mINdyPsJqIi0fXT0tYPv
	1oDKCicMmoEQiz3xACM6SjiErcQTj2HXDXTN12iN/RgQrl2IqeueYfNojBvkey/B0XDWOR
	XBzntOVgTG2HaUajYxNCosTr7J4Qdx8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=qJurhs5J;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="S NFPT9E";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf15.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784269090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DIwsi7KwJyaKhQst6GtgDPKu/03zqC/ceJLNUsU0G7I=;
	b=gOKa8rlI8qi0RkN6x24szgMLcIZaV+f2vDfJppZ00NnIAZ60t2lIkSbkdmeAilbsodaOjO
	pNC/5xzS+1WaY4QL2mA4+JAzodgVCeqLClKCXDVAPvLyTtQfdDPmENpmzM6KDlFfKSVhh3
	04mqc6iV1a+BoLy+i6bQa1zAd8guDDE=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id C9D6E1300108;
	Fri, 17 Jul 2026 02:18:08 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-04.internal (MEProxy); Fri, 17 Jul 2026 02:18:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1784269088;
	 x=1784276288; bh=DIwsi7KwJyaKhQst6GtgDPKu/03zqC/ceJLNUsU0G7I=; b=
	qJurhs5JdXDOPoUVTQH/c7wlS654Wk2iQcPnJ/CfxGI+lDliQ5WoXu9PkdWdggbW
	4d8b/pP1UoIb+cUshsR429F+4jAmsqxfXulbery4qx9QQ9L3k+CuBjhMRAcJ508P
	hkFpMA3/09yB51NIbjjASJyhc4gDS65tiI7/bPl+e6FpPcMswXKJWDAOkLhGoqnj
	HfqcoQ3m4Kfmmvcx/bzssrZ+hwlg6Dm2Q58Y1+XLiXurzsv9XLe/lU2RHonAjrmT
	Rv8BYN1KEYHV5Vnvxz9qEvOgjyUxplJIK+PqCHpYIathhx7GXGR9hFZ9zhMg6XKd
	bY7i6Vl1mKinY8/PcRF8Pg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1784269088; x=
	1784276288; bh=DIwsi7KwJyaKhQst6GtgDPKu/03zqC/ceJLNUsU0G7I=; b=S
	NFPT9EYrba01yD5+bxd0o86ReIuerWFEUX4KTVAPRJpdmcVvwba+/+L9NrYNYEqz
	GNFOhIqqFlmQEic5XKMgufYnt51BOVzJ8oDuEigx6ZTwQNCDwNABsx0yaefvPyAq
	OSVnT7Tk53WZGASdhTaErR5DhzAyaNihwPtUYvF8CprRClo4GENwngWSfd4DUaAQ
	EMRcoeeFZRfQ650IbUBfrdYE669ijsQbPxh0v80NFCLXPm16uJm+D7nmUC9SBQ0g
	dCX7TAfRWr6pfs/wSbK1bJr1MAJw50n1HthqFPfXnFg7BhG8N/GGqs/ei+tMgQeU
	WuOo19ntWRmsneHGOshlQ==
X-ME-Sender: <xms:HMlZagVQAqiQ2wrxcfzlM64OJgs_v7E5hozglxjLbZA3oFDx16Q4Sg>
    <xme:HMlZavZjC5M5VU4vv_x6XA8Q9mGZD-v9gYlS1ZunodCNZxSELR3_B5xqo0NQQ1Kkk
    S3Vnm8TCLvFoV9aetukmCzWBHrmtSXqTSyvspwykP4Js9EywzxWvA>
X-ME-Proxy-Cause: dmFkZTEsnogHl3/584/D3E3UL21JNIJ0IpLGex2XJCrBcpEOIptBGsASC8eWXQmjmgrrA+
    DsJi/6WKuBBi5F7OuvHSL+g/7EoKzEioTp1iZcObcFlCUdN9FQiLyhQ2WJckBsyhX/9Aho
    5zQIT0Bvwp2+NRIJWoZWWMC8SmjxWARp06CdfI/xQXVcnw57hiZzQkOQc2pwFGFa0PD3Ig
    VJ+Fd0xeZxtZewuZTM7xNyzpSHGuXpGq3mqq0soJ2shLfJD66nl9DGJFWVxpf76R9pb+Fn
    JOiGB9PJjr5FAsfP8hraRM4k548vGuSqGP1eA/PLgcn2VY+22D2Q5gmScaUtFJHkQeGQl0
    qOdJSMCXCOKVo2GYO0c8fM24yoitw5qkoNohPbWnf30vjF6onkva4ikrIgyRvIKEJvZNRA
    2o7FLDlhqcoPYk1+SmVJ4d4YE9GOtue1HKQ96xeNVuknOhecYVmSMo0VsLMLmjY8/FISBD
    gWTMCij41tnxpv39fvK9ULBw+8sWNQSqKe16iK2O+3X4VjSrm4lXzDGTiCUanjHSVT38ZI
    vviFiqNWzxfI/YQs5BbNcV3zIA9lOiFNZ/YeaHhcz7lLGZ/gbDMi5asWUg1zuEVqw7zMyu
    qV8v8QTwW2fXPoxCr2PY3YezqzuWa0Y6IrZCF0DlJYjYcHwuiRvpQbFeuHgw
X-ME-Proxy: <xmx:HMlZatns8IaYGj1VLUytOw4spltodteAcr4k00MZgvzHgwqZMovQtA>
    <xmx:HMlZahNXyXTuH2E6lbACeQcbmNWaNrYAiCMfDDD8K8uf2luwqFnldQ>
    <xmx:HMlZat5qsP5jnznKN1zDwch0mVoi_kuQo9F-CYJkyvhZNwwUsQEKRA>
    <xmx:HMlZaiL-pxHqt-gDvYbR-kuRnd0nkUgMhwofbEfTT8VK3P-i3s-mPw>
    <xmx:IMlZakFwaTi3Bb2V5_o7u3qejYOcKPIj7XfIuyMLQ8lJxF0u_ZM4Y94W>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 0ADC3182007E; Fri, 17 Jul 2026 02:18:03 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: ASU80-mPZ9gg
Date: Fri, 17 Jul 2026 08:16:55 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Yeoreum Yun" <yeoreum.yun@arm.com>
Cc: "Pedro Falcato" <pfalcato@suse.de>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 x86@kernel.org, linux-mm@kvack.org, kasan-dev@googlegroups.com,
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
Message-Id: <4c3067df-20f0-43e8-8e62-354888afac04@app.fastmail.com>
In-Reply-To: <alkrWNECXmoxkrUC@e129823.arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
 <20260713135614.1618183-3-yeoreum.yun@arm.com> <alYL7B0HAvmLVHGU@pedro-suse>
 <b7dbc476-1477-4004-93b3-c5e667e24df8@app.fastmail.com>
 <alkrWNECXmoxkrUC@e129823.arm.com>
Subject: Re: [RFC PATCH 02/34] ARM: mm: make 2-level pgd_t a scalar
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B02D0A0003
X-Rspam-User: 
X-Stat-Signature: un8s34thx91yxukq549fh61u5onct67d
X-Rspamd-Server: rspam03
X-HE-Tag: 1784269090-987999
X-HE-Meta: U2FsdGVkX185AyLHjXGTsYA0ZujkkEXwyQ+85AW3E0vczYgbzFMaat4XrxHM2871i00eq4bORBAYz1PPsMy0IiX9P6DQmYku/M1VD52wZKsSsBok/A7E4+absCvjGRkotUGTJ6uu36BJ4aerVFxu09tv0WIBhVdsQkA7fTRnw0/OuWFYvjClOQ/SRj/D/BvbdKvWrt3+IlrcdtyzYjurt+DVjH6aicbzHTPFbMuTs+VmgbMCWf/c4dIG7TuFihQpnIYCpO2O/4M3asbAY8rqEaZO4sVPaPasVWEArxl8YUoZy5h4rAqcALJ4l4rutCJZKjt4lp8qPbna87AIYjrn1cHaAFZ2A9RJuGytmReNC9Xe/VBsJ7fBdebvFwmjrALibhVQXID61C//brs/1xSwbIQQLMX/CF4a5blX5pPUt8ZF6JRT43tda0XiJ323+LUqeB5WbyF9C9Njg72pl8t5sfifHHwgCwcSdBYfJGppNEbWfkCzYMfE4NvvXnPa6xr1RQb28hzMTVFBp9Z+9wLFAYAqeJV0p8nyekiU+yMk/Wx/t+piya+MHCl6Myl//Mjk0RNbGaJdxE+oFspUPL90+JPfGhmSVNj5PBTZcTaEtmMvgKlnQM26vwe50A2yebXI7eApTI9KOc2o1wyi3wWsQz6m1jfdTJBQDKTxsB1nCoCL9xfKPqRla1InxJHfPj+Y44+DG6zmSiy/W97t4awjf5Jo4fYHlUyP6yvny7215COlsC5dtPkfoQmkug30E4eqNxJFo65aOxkA3yHRyMGHQ3YoTamukwD4F+/fJz2BuQYFBqRnFVwfZdqIiOZjzB1RxFk/xR3notRSJ7VSRrmEPMOsH031W1Kum5/DorPEp5YRrSsmZzOz9vrCBH+J4isLTFdQe3NXmPgq9JU3REwRTjG23Vrww/xt7DLYebJPkVqeN7yTQ+G5tCizvp9HbJ1N6I6NcdoQkjIbnXBQn6y
 RDi0SCwx
 mU4MJFLjFG4Y5vO+AjmQs6htIRrNffXCZ38bVEmu+QB50FJaoluIUeqGZUT11gU2x9QKWYE5cZB8EGPxtmXYm7H9ZZ/AeFTZYiCx9l67JHAWvbgV3k6AqiH6ip48wFuY3PJ1mP7EmMY5eIZYw41cT4w4ueEAj+xkySZtVVKaV69XPIOgqGWXaoToYrcu/FMdG4znCFpWq6WW384FQsk6C6baTH3ABQrHvMTtnvxrwllCage4zPaBfjdBIkr4qCv1mjrsY0/k6xq+0nhBF45VkLXijOgWzLUMKWY+S8iJPN8Eiwvntba2beM/4HEdpWNYKlvnEivUIiQehLmpHvnwaBGxzsWYxW/p3MyPtdMybRdw9YwqM5w4eRsqVgig48uN0J2ht
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026, at 21:04, Yeoreum Yun wrote:
>>
>> > Ugh. This isn't correct C code. It only works because the kernel passes
>> > -fno-strict-aliasing.
>> 
>> I think the bigger problem is the code dereferencing the pgd
>> pointer in the first place: Since the pgd pair is written in
>> 32-bit units in __pmd_populate(), anything reading it would
>> technically have to operate on both entries.
>> 
>> As the kernel relies on -fno-strict-aliasing, the type mismatch
>> is less of a problem than actually doing the potentially wrong
>> thing.
>> 
>> As far as I can tell, we are however saved by pgd_val()
>> only ever being used for debug prints, where printing
>> the first entry is likely all that is needed to analyse
>> the real bug.
>> 
>> > I would recommend either forcing a struct here, or
>> > using a u64 with bitmasks/shifts.
>> 
>> That would require extra complexity for the big-endian
>> case though.
>
> Agree. And since the users of pgd_val() mostly uses with
> pmd_pfn(), pmd_page() and etc. I think it doesn't matter to return
> lower pmdval_t or higher one.
>
> Therefore, without considering endianess, it's enough with downcast
> like:
>
>    #define pgd_val(x)      ((pmdval_t)x)
>
> Could we apply this in next version?

I would just leave the original version here, at least it
keeps the current behavior for something that is easy to
get wrong. Taking the second entry on big-endian sounds
counterintuitive, especially when you have a hugetlb
mapping where the two don't just point to the same page.

      Arnd

