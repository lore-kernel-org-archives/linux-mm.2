Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D83AEC43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 07:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F20B6B00A6; Wed,  1 Jul 2026 03:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A3AC6B00A8; Wed,  1 Jul 2026 03:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 691BF6B00A9; Wed,  1 Jul 2026 03:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FF406B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:19:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF75D1C1D3C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:19:52 +0000 (UTC)
X-FDA: 84939358224.22.E850548
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 70CA340007
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:19:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uler7TU1;
	spf=pass (imf07.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782890391;
	b=fOruVVhzGEIUw/Uz4RBdGEwUqPQsuNCPNJRNhPUg7XlqIxB/RvEjmhdYcPWHACelVjt2P8
	SXnENzize/dXlC5cjSR6OjhN4Tho4+MYLNmUYGnrHMPuXwoKP3x1MZ2t0Mr0KNzAzQeWRa
	EMu0OqCk5UJRtkUZ2Zto4r+/NidxU2g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782890391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oU4WzgOEp9MzpTOCoPD9OUsBrXWafEC3mjtn0apNXKM=;
	b=CtiVZ9ygZ1+lwvX+nVZeiLB6X1j+m3Zd17VCfLfwWnsq9RoWNIhI+qTI1dmywQBWchSnIJ
	0y0tBITK7jOS42Hw4C09E7Z5/Nbym6dUN0OIFlqBxxFqT5BHGIQ2mDPuYappIphSEOt4EH
	9A40wCXKgXwrHQeuTc/H1/2gsVqWun0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uler7TU1;
	spf=pass (imf07.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oU4WzgOEp9MzpTOCoPD9OUsBrXWafEC3mjtn0apNXKM=; b=uler7TU1Gk9SDIwdFJcsM8Dq2t
	QtyDMju9rs26AfVwFAI5kufCwCm8B03v4tb0uaRemIIHO1lIFqbDZFZJmHMy6YbGu4hOiZK9WVzTf
	kCxAYt/FVHbq3V1GiJR5VW3Ey8/WgrYRzGpZuBA6nWteQ/bswc/y6bm1bol5NIp8iIpMjI26XfAVY
	pz4pDIl7QNZvkwM2sMRBXJoXq55CmzsefUa08ShHXmbMwzKoItZ57WcrZWrqYWRT+lFHMXy3mplrE
	lQwGt1A1X8Oamv6jQhpA4vy86N/0P9HjTteDYVS387w9jV3A0CaqgBqnOv+98KPp+eyjiAoyXESmx
	6ZPcZ64g==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wepEX-00000006DAR-3izs;
	Wed, 01 Jul 2026 07:19:46 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 5555430035C; Wed, 01 Jul 2026 09:19:45 +0200 (CEST)
Date: Wed, 1 Jul 2026 09:19:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Xiang Mei <xmei5@asu.edu>, Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	linux-hardening@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	"H . Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>,
	Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>,
	Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>,
	Yan Shoshitaishvili <yans@asu.edu>
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
Message-ID: <20260701071945.GL48970@noisy.programming.kicks-ass.net>
References: <20260629214712.1198680-1-xmei5@asu.edu>
 <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
 <CAPpSM+QTiwgPk3KNmWbjSk_SS8LLL5XDfikWC1A98vetom3yeg@mail.gmail.com>
 <4e96acf4-25e7-4f30-8455-f9b3f49062be@intel.com>
 <CAPpSM+RhcW=xciX50W3G+2mUVNkmLfL1-BScPN_2TekMbzYVcg@mail.gmail.com>
 <c7c5d2c7-db83-404f-b40f-ee01ae8b9299@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7c5d2c7-db83-404f-b40f-ee01ae8b9299@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 70CA340007
X-Stat-Signature: 6gqtgkweoks79cmae533wiq3i66cpken
X-HE-Tag: 1782890390-58412
X-HE-Meta: U2FsdGVkX19iMp+uVYEEWUdtaBw4UWLH0llLftzY2/eoMJ9hrCxMDCpUjgtqm1uxTyhHhkYfoXORSrbM2pxK0S90YwqQN+thFYmOqWYwIR+p6niJxKu1Ki5N+GSinP46Qdy+e8yrzQ9jVWaeUtaMjWF3gJfCqIFYUIFXsXt5Nxy1qroPiCMGTjoZ4mDg45d8hpDTJa9CxIBlDURhDMl6aVGx4IHoTCtWGsy7XL68ks3ppVuzBdoA4I/ivyUIpEGeNTytycONNtlVMm3DL/J44193B1QW8SWygutYWQL/LTZzH9WXgVKM0PplhUMLt1QenuY7MIbzkFi1w8Xbydzbfz95KiCmBxCELHRT8ctul1Ia88BuF23aGWAj+qCNwCTpexu7IBKD8gRvuuD9lbir9JTlgmIKzOgIbBIxyPbiBckM5GbwKihV2fHqeC5JrpqnrFhiHeNapI+JJiOW57Gjx46NLo2TD5am5Ypam+v/yswLRy+lLIZ5DWaRUI8o8udWMy1u4vSHKCm2TaDvolPW07H/bQSUN6Hy+A48KcjMMKm3hpIOYyPHPooCRk7uKQIh2/wFMFC+dbSugIsUmXhRHHg7ieZghyvxj310LcoWr44z9Bu7t5V5rxbwWjf55o16LOZhUW9J95Ui5NvaLy1tgO3qE2MnOuIB1Y4x4T1JFWUQD1i5tJPSpll7LlCSfIGZkpOutxgYgGXWzJEVMJR1df+fHSIlHA0pnjB4SrafpG9H6cfPUEx+tl2gcGqXeD78YLWTmIpw/7DX1JOV+0tDtwSXuytVKf23x7J9AOa7JXTnBBenKdbUaKZnDFyWIpfHlQyt0Gwkb4kzL4I4BOGVbJrFFaf2/7p/VBvYnatXpxZUWAcKO4zHhHjryT6WjyqIlFf3tOW8XEhvJR1m/xxdfQhhYTkoT3uK61dqlemlzsgeK1wuG8NboLCvq0D9kYUS18DLph4k5BlwdgMi4Fk
 KFTZ1Mbc
 VeDVNxcX9o0GEzRqbLi0KfgUNBhclmy9ajo8WkVxTFv+QSMCLsBrxyECniCxG2PvWk8PITXfKOaJ6gpDenzjLf7aNQrav+qdWkTDBx98ua9Tyeky/sMqVOPgo08CE6CldUSoH6lCm4TEtWhAkKn3vB+v52UUeAkijrL6E6vPrvpuoqDQ/06iBuczhAtXQpF52j9SwSWsU0ttAVI5KVk/1Sy0XXbB9lPh8gRlV+hw65R1tTPkHmq60pJQ32MbbapLVuFFlQdMqj88HYJzHmDEkptRCVl8B/GvS5eksGMBiQcUzgVaOb3pxBFde8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 07:01:48AM -0700, Dave Hansen wrote:
> On 6/29/26 18:22, Xiang Mei wrote:
> >> Please don't even try to send a v3 without addressing this.
> > This is a demo exploiting CVE-2026-31419 with this technique:
> > https://github.com/google/security-research/pull/397
> 
> Thanks for sharing that. That's really good info.
> 
> But what I want to hear a bit more about is why this new guard region is
> a good, generic mitigation. Does it help mitigate a whole class of
> vulnerabilities?
> 
> I think you're making the claim that this ENTER technique takes what
> would normally just be a DoS and makes it fully exploitable. Does this
> happen for a lot of DoS bugs? Or is CVE-2026-31419 very unusual and this
> stack guard gunk won't ever be useful again?

AFAICT all it really does it make it easier to set up a ROP chain. I
don't think ROP is unfeasible without it.

