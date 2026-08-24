Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49C6FC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 426DC6B0096; Mon, 24 Aug 2026 10:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D7586B0099; Mon, 24 Aug 2026 10:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ED446B00A0; Mon, 24 Aug 2026 10:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0137C6B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:59:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7ADAAC01A0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:59:57 +0000 (UTC)
X-FDA: 85136472834.05.04CA3D3
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7AB471C0008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:59:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="M GT9z1S";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=R9Wb13ZM;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787583595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yu9P/sTLYPHFQVWmVS7Y7Dli1B95EhFAwCCsGt/ZaaY=;
	b=RhPW6nELeD90L5Y3gBaTP2y+RpJfMLQgEUdUxDe1wcZ7bRbrzWZwbEZCSL5J1xy8Rk6Sax
	vlcGQu3Fj9ZwXGXDY2Nb+2uRl1PPP8tFQlZzGIUNmkTATwe8R9APaj8B6N3JxT1UxDJzZe
	YzuEClcNpy4aWgbaYtm3impulUqF9Xk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="M GT9z1S";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=R9Wb13ZM;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787583595;
	b=dgY/ZJPiIbhvPcEiapeGhZeKkAazVFxYON9DhnPJSDWPHyzvl0yDzByvoCEHmosktmyi1C
	f0pWVwVegVMqz/FeTIpbitF9PzzKyreo3SnUDVPU4xOIdbKdTuxwo4/KcUiZzSGaPEAHtV
	cAI15QgE+Bbx6hvh2URnj3hTg8ET1CI=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id D48A813802BF;
	Mon, 24 Aug 2026 10:59:54 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 24 Aug 2026 10:59:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787583594; x=
	1787590794; bh=Yu9P/sTLYPHFQVWmVS7Y7Dli1B95EhFAwCCsGt/ZaaY=; b=M
	GT9z1SxWlB/4TFVji7vo9tPCdCuK/gc08BF5AJxPHyA0iw3i4X8SAyhafQtyCres
	/0FSTuz4YJztAs7t3lMFV63ci5h1vi894Ok+AnqmyNN3CAcqc24mI40sjyMvj8wj
	PQ59o6+tcmOZpzI4ag/J6OSRh9e4OGYW4NuGygJGuDyiDsj50tij2YzG4ms1o0Uo
	h12/46SPWxmGD04cGuQ7uS5Oh+E2/2pIpwAxrYaJxMCTnWJU3Vr9eL2rIudgMb/8
	FY8cIeP0GzLiV9Kcyt38VI2aV3C+fHtu4bJtDGSUy8dx2Z+RVCerpAI8hbF75MJe
	XLqd0p0IpJNZHpZLNCX+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787583594; x=1787590794; bh=Yu9P/sTLYPHFQVWmVS7Y7Dli1B95EhFAwCC
	sGt/ZaaY=; b=R9Wb13ZM4u6qNWWJQuTlLX5XFswHrSROHybTuFX0w516wPdrm9k
	fk+yFdV4uIDJvhcEbx8ZRhyYKL2nNOs0Fe5uSALsGbTiyTIBeRrEi52Qq+8m9Zzc
	/PeeTv1+iB5CjFiVewMc1Pe6yUUiool+QzBwQUjjHKuJSnyJiv1f5kmy6wdW47VC
	zozvkPyShdJSU+2sNEx1C0Swi0zIi/un93n5nYllykJx9o0HPWQ//OnGnNlcA+sW
	OjoJ/8H0bDgBJZ/oyZhOew8XvKvCTWatFRt/opbObrZpEfYVzaOEbbuw1PRAywnL
	abDRU4V1vccxp2FGi9JTFxeqP5BkoLYUWWA==
X-ME-Sender: <xms:aFyMaphnihHBiQZNoi7T389o1QTZbtMl2akARdWzQgCaTdYfeuHClg>
    <xme:aFyMaucjM0A6qKXe9E1-iGljJbInsvNsCBKamTairpB0ZbNvF6tJZiuaJuW8qPO4R
    ft-k4xnpN5t_GgO73GjusZD61IFzsd5qfrUaaDMoYDX89e1iVqDw5s>
X-ME-Received: <xmr:aFyMaqhpXl8qyNdtn0eD-FoUVVr94to_TDzYTJ_Cu9NRaZ-8pwuDRL9ksWI>
X-ME-Proxy-Cause: dmFkZTFa7qxHA3qw09qMM0lVFcj/nmVHnRJ0m27uYJT6lMLZ7v1xzgdvd5p6U/QBOQTfkA
    10cJ+0Icwv6tyE9AIciaBSopNETAHkeNH8otyAPTL4UeuxqJpy7nz4i/xGDZlwvRkCXIPm
    0yTGMiT7QIObxGSYPnJ6lbBAlLaGqN99Pisa653oUGH0S0u5rxDTMVZxGCG32mXAP1dKXk
    dMrYaODJGgDXYh6sU8EikjdwkjxNj8YCQ9etN4LJa3av2TnlVTnUKWyZi+Ea3e9YQHJ0QY
    WAWSZFOmBspb4p46AXwaKJRFFRr88VqQ3E4YELG4yvXtevIuuehkYkhSrktLQi4OAr05d2
    CHqx2eywsgxYn5epfHNDF2ZfCYYYWomwJJpHejDRWVNcVRcHovhq5pTLxwf5TZaa++R2D6
    qgTgAfWsFG9kCXRuSBMkvSVNMWAxjfBwOCszJR/Ois+Efkj0B48suowg93eYyLUS1CU57L
    edmv2OcFEKBnswdwkWsxnFum7HJf3g9okI8NBSRWK1c5lDUSXLvwtXo6X9WECibp1L5GeL
    +qSn8UTsBkFDkqw8C64eNO1JAd8g1V7AZsHs/NsQGkBK2CaK4HWl4iP4OBoaV86LVAxfbI
    mTLS9lLSGc42Mn+Ab7nqJOLJzm2Rf+KxZJofVpVDwVvdbTmr8jcThpB1ThjQ
X-ME-Proxy: <xmx:aFyMauQTq7FNe43FkdTdZ1xmY4EuDBBtJivVng_yDA7oqEk3QPMw8w>
    <xmx:aFyMamK8dXH13ZK0xjswRGu0Oh8JfE1Z-eMXPZCxsmDn22bUoWoaeg>
    <xmx:aFyMatR8RIV83iQosn6prU5RDRdiQT_1oz7UUhMw8_uD57JEiR6PTA>
    <xmx:aFyMaruwPSyawHNRKwHvMdXAbu8ET1Zk0BVLqXekf_CWi1J75UJq8A>
    <xmx:alyMap5dO2oBDGIh4DBhvvknyQVXRI2wad-Y0wwN7EJ63nGbX_5UgCZQ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Aug 2026 10:59:51 -0400 (EDT)
Date: Mon, 24 Aug 2026 15:59:50 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, nico.pache@linux.dev, baolin.wang@linux.alibaba.com, 
	baohua@kernel.org, dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
	liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
	shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, 
	ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, jannh@google.com, 
	willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
Message-ID: <aoxcN7jrfbK_Ac8V@thinkstation>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <aoLAly-oL2OAa4n8@lucifer>
 <aoLkMUtmzRVuv2Hx@thinkstation>
 <aoQ77EcD3M2kjeya@lucifer>
 <0153303d-f9d6-45ea-a276-fbf2e5625ef9@kernel.org>
 <aoXn1B7cPnPq7uxd@thinkstation>
 <aoxRs0mjyQnpO-IT@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoxRs0mjyQnpO-IT@gremlin>
X-Rspamd-Queue-Id: 7AB471C0008
X-Stat-Signature: 4no4juax1r1nexpyu5drdno4zmyx4wk8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787583595-474598
X-HE-Meta: U2FsdGVkX1/LhHNwd9w10H8vxgJngumOSscdoc+TxTUoHbUR4QJvtRx4ikn1sqpV1jAsruZZr/oQUfxsbLJQgZYhxFdPoof5088d31O0qnxdMwDQTfZdd8ERkYN79mfdOSOBt/GUqQ98RYOu9Crkz1vs1zRCV1KpkWfYXrkPNpBOYVN0ZrwqkroOd0m8vVzCuHIGjAnYEU92i8tJAYeYZJTFxVS9Rp9XgCa4JO1bnJhy3ZCYuy93fdg9pkc6SyEj/c/nxqG8QbsBGcByd7tgvMU1uAt9GPbWmJbZKrpgHBoZ20IDWbymybVGXM0s+fQHaW4SzxOFsaQdpSJzrcw++pGRWmL7en+1L1ADVhng8FR7hBRm/dEDTSb+a3QSlUqQO05WMeMHbqpewIZfeszlgRqnDZMndwMW8YKwQ9O32RHYK1mlESaQOOqxKN7IC8G/PVGmqfQIjOXLUyO9ax5xO7xAlcPpe4iCGS5nB6trFDHmumj1YxwqSthds5ifNydM7EhUfS9Tof872+6JKe68mGAsoJdG9QKXJ/WS5M2vKnJkZ6WznP0gVyfqb11GaNF3NdyJJJSRjV4JnCS4+r2Su8GIm48K5bnjn5EwWH0I8ZfVaxUtg7rq9w899H9oNgp4qDb6tkNMrSRSmvEKhqoppzeR8PKQyDCkZKDHjMkugi9y0BN2zcKxm3e8Z/5mymYMdzKd3Caw/e8cil/jJQwUbNK8WIdS5ssyhEDwHbaTPRaKwc7uEGIbjQk9bwox+WhHnE2zdkHySoZFAL5B2CDSxU+wSeiB/+k+1iNR3iZf772yHPQ/5efeS2VxgB//IIDgdBKtFQRNI6IbIfooD6vhQi+l6F/VIFicTUwSovdjepzJaMhl/Rh6VGeoV1koIJ+TDxtjJ3WCtm2pIb5qn7vcO43fjaJsZaAAjlaUlBBEaEcqUM7EcqjuaSCw6kCCrvh1+kvkBSNeaPLI23X28eF
 puH35tVV
 CYXDnPRRLaQzSJ8zBWyWQbP6ZQXvXtkMdRNsGX7E3uskGPCZ5alLGJ05RCRpQWUV/MrohBKiabVcsKa2lZzqDiQ1ed+PIdVyd1KTqSnhopNg1hnPYXRpWpHJqKoXmKU2ArGu9hhW+zMLmTTBqCcd/2a4lsW3INWatmwa57cqE5eO6QRmiJ5CJCXcV5TrIP2gZjaD3aaoZRAaytbuIRilswMeAEH2nLj7zM7psSm7UUVtjg2B8X9+SXpg2SqoAktjEfiMOnO4zLQFOrPRrkSiioEZSFIvhZPWO1seGSkYRac2kIEaHRjxQrwasL5BTdVqnwcFiE3qPIRG5p3YMZLpLys8G5IfexVA8ADBZeghbzpx37feAgx2HTenMtURcZx8xB80cGzINsQPexP0qIDvL16AoqjN34iGjaR96pbZ7woY7wa0jy+pNCx77zvzZlOv+V8/q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 03:22:02PM +0100, Lorenzo Stoakes (ARM) wrote:
> This whole reply seems AI-generated...

It is not.

I heard David's feedback. Will adjust accordingly.

> 
> You replying only to David twice in this sub-thread which isn't exactly giving
> me warm fuzzy feelings about the working-around-me concerns I raised here.
> 
> So simple feedback - send a relatively small, no-functional-change series that
> improves THP code and lays foundations for future changes. After the merge
> window.
> 
> Can you explicitly ack this please?

Ack.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

