Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5C7BC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 19:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1EA6B0005; Mon, 13 Jul 2026 15:49:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83B906B0088; Mon, 13 Jul 2026 15:49:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DEDA6B008A; Mon, 13 Jul 2026 15:49:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 273436B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:49:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E733140160
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:49:58 +0000 (UTC)
X-FDA: 84984794076.16.A3E1860
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id AA4DFC0007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:49:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LvSI84Kp;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783972196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZe9zYBUgL5Fku0tOf4jGfW4HRaI0/J5FQVtBy0Ve6I=;
	b=Ob87qK2am2+vLivuAbY2s5EFn8J38Qdtidpv4hNXzS9fAMMPturLrtn9/LslSFzOUXi0wV
	g0xEF0uWhSctGX/hpAK7o3ckVqS50DpX5s62XbOFK2HSYRafPU48FZgnSgFe2giCia+j+m
	FBAtpchQL83PGT5S+EGISTE4P2KDwr4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LvSI84Kp;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783972196;
	b=KF5OVGbAl6gEh31m9zdKZYVN5OuoJiDKSgyTuwjC/T68+C2tvQ96MQKH9s7rQ7UDsgDCly
	x+wd3QYa00DNQ3SpNzmTCiR1/d8s8gUmp11tJBAzB6WuTIUGb67W5MeOgH0mZNrGroTxiL
	ZjjlVASvaYC/4VXAlbJjXePRHnyuweE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E94060103;
	Mon, 13 Jul 2026 19:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C921F000E9;
	Mon, 13 Jul 2026 19:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783972195;
	bh=IZe9zYBUgL5Fku0tOf4jGfW4HRaI0/J5FQVtBy0Ve6I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LvSI84KpyEW4PF6a7LNDng1GF+rwXXsJKi7/6liu+LAH2SvyPUp3Y3dazy85hfiJ2
	 8wmORaiWbxnT9QD4Gktp63fmyZHYGlJwN0LNqE9aW/GK3kqC9X/vUDxMT2Dh2t1JkM
	 YdU53xX2zJldz/W8YkvqFYp3XZ6jIqIACguCJ9Paeh/RuCinRwhFichfxdD0IQw8AI
	 uzF+0XEdW14nQUGG2j3iuaQeox3i/AnIlQp+tfHaGhsUjH1ROQ6M8kUvkdg6XHz0xG
	 0JTaMX5GR3Vnw/gkw8JisANxpqabirohlF5apD06wIS/ws1h48ypbW2+WJUaYP+JQn
	 0DyzG/pm3fC1Q==
Message-ID: <3ea30f8a-bb29-4bf5-8400-1c4840d46a88@kernel.org>
Date: Mon, 13 Jul 2026 21:49:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 10/34] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
To: Dave Hansen <dave.hansen@intel.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-mm@kvack.org,
 kasan-dev@googlegroups.com, linux-csky@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org
Cc: linux@armlinux.org.uk, akpm@linux-foundation.org,
 ankur.a.arora@oracle.com, rppt@kernel.org, linmag7@gmail.com,
 chleroy@kernel.org, klarasmodin@gmail.com, chenhuacai@kernel.org,
 kernel@xen0n.name, kas@kernel.org, zhangtianyang@loongson.cn,
 wangyuli@aosc.io, tsbogend@alpha.franken.de, ljs@kernel.org, jgg@ziepe.ca,
 catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de,
 ryan.roberts@arm.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 baolin.wang@linux.alibaba.com, tj@kernel.org, kevin.brodsky@arm.com,
 anup@brainfault.org, atish.patra@linux.dev, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
 hannes@cmpxchg.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, kasong@tencent.com, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, anshuman.khandual@arm.com,
 yang@os.amperecomputing.com, chaitanyas.prakash@arm.com, ardb@kernel.org,
 guoren@kernel.org, yang.li85200@gmail.com, viro@zeniv.linux.org.uk,
 dinguyen@kernel.org, schuster.simon@siemens-energy.com,
 wangruikang@iscas.ac.cn, junhui.liu@pigmoral.tech, muchun.song@linux.dev,
 vishal.moola@gmail.com, namcao@linutronix.de, pavel@kernel.org,
 djbw@kernel.org, yu-cheng.yu@intel.com, baolu.lu@linux.intel.com,
 Jonathan.Cameron@huawei.com, coxu@redhat.com, andreas@gaisler.com,
 liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 geert@linux-m68k.org, shorne@gmail.com, jonas@southpole.se,
 stefan.kristiansson@saunalahti.fi
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
 <20260713135614.1618183-11-yeoreum.yun@arm.com>
 <c3edfb13-08ec-419c-bc05-8f3f64186b24@intel.com>
 <ac365196-8ccc-4d8b-83d7-28fec763e75c@kernel.org>
 <710b7eb0-8e0c-4f07-991c-2285c77e1beb@intel.com>
 <6007625e-c3f9-4ad6-99a8-61396bccbcec@kernel.org>
 <32d459d1-ad19-4baf-bbb1-0565458001d2@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <32d459d1-ad19-4baf-bbb1-0565458001d2@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AA4DFC0007
X-Stat-Signature: w4beauts9pqwcuba8n99i6bmth61kumf
X-HE-Tag: 1783972196-417518
X-HE-Meta: U2FsdGVkX19oYPX/nBYLIJuH8st8mlDIceGcDt5SISw5KtEar6kb5DVY/Tpp1T0c4VcIqDsM7i33YUqkMWIJB0LZSW59nk1clahZolwS16U4d2gX1K1fFGWBRb+55rfxThCxuOebvR8/5Ov22pOw3xcV6KCoVPlBrAmmAXHM5Xb8gY/+fHxONyQZMb6jaFA1Sd73nisOZxLFSAh2SbY1mH2LtS5gYre9IkISUnbb9ZMtNpYN4X53lfRqL2YY96Yds5ZGseblE2hqBNVBm8BFwXrex/t3ts7JSYlZ+aPsBPJb8xnq5xBI6TAD2V8BfQvyQGf6cdjaY+chJWbNLug0nNC3YGOFgmP1ZH6x4MNCFfG3YUKl9RkAw5vd5OyUDqb3NSPYl7yCu6r851WDxv5XoZ5DKLFdx1kgpYkmEzyY48cKPI4POIn0RkHx/znwFF76tmr2LlVzMzLU8uaQNYnP32ZxKeZyROU4BYGWJSnjkmJDXvfk8LbdwHx94veZj5CNx7YyoITJ0i2Z3zI75Iv7jEEHhZ8Gs5qAuHkv43f9dj3rtC9cSZFdsF4mEcA+3fkmWytpZazOz7NRNAzKM/aRytIGddPF7sv89lbA8IEXaJtwssCQD3mIAVovT+fQ8t983iuEH64uYW0umPLy3U6pQTWikM/i4elFcdgEkYpgvo0oYzu+ndRoIzJMeAzmv4iPaMxOZ+t+NDJATy9sBWl4X+Tx20AknjqLVg2CcBhsVmUbGHmhiVWw9hRqVHrCzHlmSmSh+WWwvZvz2bgI0SEpBS6uVm97vwpSB3pkCGWabZH5PY3BxPoaWk41+BGl8wmISEvEFB+/OcCUCR4FTtqLvDLDAXnLjzDTaWbRm3FSJoJ6Mka0teziaoGiwt7zfKRv9sHXsTx5Swl7MUtlaL82P6M8fw73vxniBKU/cqLCRBlX6OY2uHJ8NMySSo/xOD7yqpdz4/RUJ1ZC8SYlm0m
 qycZLoaN
 ql6ueDl6sjjdTjtR+Gp3+pOob2Y56EOjiVpA0ljv7kbMIpYBV7DD7HTnRvPHysDtUlAPEyM8BpGnLUFsJZOmNJFS3Qs1QfjvPg98S3WxJNgBDfYz/Meex/+E+K0Jj/XbhQuuzY3Kp2BQ6/fqwCNZplNcrEI3SIRWtu8HOM/J9XMm3/KI549DBDRCwe7S5ecXg+Q/q2CKLloN/rkYCRF4hpqNjfloQuXXoOiPzYd5LuUk1ekyuQeOCRFFWUEr1yR6lrdk34GS/P+50m/MyyepoiwfknT3+jy2CSEvSRB/tuREA3mWoybt3+B3HJnV6ANhxWgj3O25d/MNFUiLNJR1NgNbFXIfY4Ks92iKhcnJ1JzVg2n2MSjG1xpd6fcLEx1FhlRtS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 19:57, Dave Hansen wrote:
> On 7/13/26 08:02, David Hildenbrand (Arm) wrote:
>> It's always been the latter:
>>
>> 	...folding => PUD => PMD => PTE
> 
> This is kinda arguing semantics, and there are different ways to look at
> it. But I'd argue it couldn't *possibly* have always been this way.
> Linux hasn't always had a PUD or a PMD for that matter. The i386 only
> had two levels. PAE support was added later.
> 
> I think the pmd_t came with Alpha support (before my time) and pud_t
> came later IIRC. I'm pretty sure Linux didn't have a pud_t when I first
> started hacking on it circa 2001.

Yes, I'm sure there is some horrible, horrible history to how we came to what we
have today :)

> 
> Second (and again this is my subjective opinion) a pgd_t* has always
> been the "top" or "base" of the page tables. This is why there's an
> mm->pgd and not an mm->pud. We've also talked *forever* about things
> like a "special pgd" for the LDT remap. Or having two pgd pages for KPTI.

Agreed. We always called it pgd, which is just an alias to p4d/pud etc really.

> 
> My point is that the PGD hasn't itself ever been folded. It's the top
> hardware level of the page tables and always has been.

With the history in mind, yes.

Looking at the current state it's more complicated.

Because pgd_present() are really just dummy functions. And this series proposes
to let also pgdp_get() be a dummy function and disallow something like

	set_pgd(pgdp_get())

Which is just asking for trouble. Similar with using pgd_page(pgdp_get()) on

We could get away with catching that case similar to how we catch pgd_offset()
abuse, but I'd rather try get rid of the wrapper functions set_pgd() /
pgd_page() entirely.

But if we feel like that is too much, we can look into that direction.

> 
> I really do think this series is changing things, not keeping them the same.

Looking at it from that angle, I tend do agree: it further moves into the
direction that actually the p4d_present() carries value, and the previous
pgd_present() is just a dummy.

I can see that some more work is required to untangle the mess we already have.

I don't know why pgd_present() was made a dummy function and not p4d_present(),
but I'm sure there is a good reason to it. Changing that now ... omg.

-- 
Cheers,

David

