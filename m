Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 811B1CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 23:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B0A48E0116; Wed, 29 Oct 2025 19:13:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7616F8E0106; Wed, 29 Oct 2025 19:13:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650DF8E0116; Wed, 29 Oct 2025 19:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 511A18E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:13:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E84A7140923
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 23:13:15 +0000 (UTC)
X-FDA: 84052704750.20.2A9510C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0FF4E1C000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 23:13:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=im3LP7Wh;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761779594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cbtV0wXCHdPAvLi1c4husxXdxnZcxbVftKgb5veQJHw=;
	b=BGhWmfoaO7RtE3RPR0/urEDL/17BdQmLZKZZneOj6qmLqQqrnNKiOGfrOdKyHEysu8i+Es
	yMH1X5jYRs9Jij+irGiXNavT3OJYOWtUSy1HsvzWaquxQ7TFUD3xq3Y5CAWiNxk8TxsegV
	/G+gs1MtABmP5/CaRCdhGq0Lcjcvd5o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=im3LP7Wh;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761779594; a=rsa-sha256;
	cv=none;
	b=41lf4ReNUIyEZvju6iRBrPd3VQk68WaE3+L/rRG9CrZUnEgYC097Cl/P7pbReQ5GA4S8g1
	CFihqmb0uiBxCHU1PrJUS6ohNsoQ+fGLM4nWWpPTSYBsjfts2b+c211Ps16JcP7jYirRrT
	cOCDBP7hjqXfVHHYW6TpQSlX3X8UWrs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BB86E4324C;
	Wed, 29 Oct 2025 23:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A30C4CEF7;
	Wed, 29 Oct 2025 23:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761779592;
	bh=z4SnXRipUzz35y/BzThyGakaFJrTo847VpmitD4DBYQ=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=im3LP7Wh6PwlT0Uu4EFypO7HRZK3HCj/cZx1dZQ6EVD75bjhnAw2+T3Ml0qTTPVH4
	 2VAAAUaPpjfKb+je7NI4Wfo1AhVCe3/XyQOFVeK15Lu/uNgRGGyHbqQUpPLiCw+piC
	 qVOPw5OaKjEApJmT/RyYG0NdSjlS7qVmJofNHRn8=
Date: Wed, 29 Oct 2025 16:13:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>, xin@zytor.com,
 peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org,
 nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com,
 bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com,
 kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com,
 wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com,
 fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com,
 ubizjak@gmail.com, ada.coupriediaz@arm.com,
 nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com,
 elver@google.com, pankaj.gupta@amd.com, glider@google.com,
 mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org,
 thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com,
 jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com,
 mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com,
 vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com,
 ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev,
 ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com,
 broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com,
 maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org,
 rppt@kernel.org, will@kernel.org, luto@kernel.org,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev,
 linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 00/18] kasan: x86: arm64: KASAN tag-based mode for
 x86
Message-Id: <20251029161310.61308a6b61b1423feb655d2a@linux-foundation.org>
In-Reply-To: <20251029150806.e001a669d9dad6ff9167c1f0@linux-foundation.org>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
	<20251029150806.e001a669d9dad6ff9167c1f0@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0FF4E1C000C
X-Stat-Signature: qxtwsf3f84ywaqucw54mrtsooc15fpng
X-Rspam-User: 
X-HE-Tag: 1761779593-215046
X-HE-Meta: U2FsdGVkX18fJ8OPIej176Bk7HIPcjpgtdK6xzMTGsYNSaP92oyJHsI+U33EITIvtf6wcBkRAf+WMCeN30+qtM9looTpz/HXGYoaRpYkrQxQc0mQMqG+AVYG76B0SuSWlONvNluaBAO1Dynv3T/IPnmeg2ofSy6qIDxmIRUoK921pn0JACJsCyJ/ll3HvBUefHcmuQUK6wHA534OImgeODENEwbzxS6IJkfobljdUkXfUE0Y+l9Y50T4vOYKbQZTtVZqBZ7Yg5xbilce00c4oIGCirpcJ1EsO/+uJP/p9feEosR0Fqgq7CdLGoHI2EYiujfdAek7Yuhulh0bNE4ZyDLfeWowgX/jH6m94CP/tx8RNOl2L46iu4edWLpxBpouF3XncIQSf4+3yfd565ml6aQFsorRMxw3n6f1ZOBtvqc8dvWynG3ST7hVh/lKd1FU9kBvRdI6h9AHNa9SXRq3WklU0puWVClNFtaZR+hXcd6/yaIRYTWLh+uH9MCJkpsWAYhhvCCmfca9md53Mr95I8AN/97NxbGQvccfPzWC6nEOJ1xIhB6VT99bTgo9QB57B36b6uPOpQq2nvrRknzYN7Pqp5egxOdZo61uUGy6An5MJRiI8dMJ5TbPTgNEOsj1V5CfXtuC3PBrF8bGyzE0q1Hi88MCrKP48IuKpqSp1AGu58SMKQRGM3vYVgcfcBChISwT0pPLF948pDj1nDIAz9JagD1ts0xrkFRJrkM0ZCNODRsIe+ZSA/lfX/tbBvGa/pRoSsSwx2ZNAnI61tQSW/XyE2tkL+OKSGEjrbxu9+gR5siPvCElk5NMlMSwfXE9KI7hBVv+TLtdwqkBU+M8AbcJh9uG6/sU6jYhXRaF+Zw+Cvm5O8TgpaANSmjWCSKqA5bH2+0txEQSxpXzzdLIvd/aAE+b1dYIdy9hG0PNBpDJCrBy62Mj59unE95uysq1XD9tg5kgjdm1zJ2nthn
 ORh/wOvx
 hGj25OKuDclo2lGmgZDA9IGifVhT3RkmL9Ygzm8vflcZ/FaOunoTMkLIaBkj23rH46VpAaZKn72k1Q15E+xy0RBSHsPi67uF48cQ0UuT9jgTv3Y4SCXByVNm0Pd9QVywJzuuXzrqOzaXr9it2cobk9Tfv/1S4z+T2J2GX8CX1egUE2IdCefwD7O84iayQMuh3o4VjEwKdlN6ntiMMoY6BF3Yv1AngNVYZ+xkyngl5SFcWg2uHth3YcU1UuGvxX8jfVUC8xn9guUY7cVW6laeygojZiQExe4yaL6OeE2oznhbySwZk1M/ZvoeWlDL7MwvQ5lubMQo8jP7vQThxS1xhGhXsHhczbNFpAiuN73xDAVhwCukxE82f5oLWgEdTKUwGss0j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Oct 2025 15:08:06 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> However patches 1&2 are fixes that have cc:stable.  It's best to
> separate these out from the overall add-a-feature series please - their
> path-to-mainline will be quite different.
> 
> I grabbed just those two patches for some testing,

x86_64 allmodconfig:

/opt/crosstool/gcc-13.2.0-nolibc/x86_64-linux/bin/x86_64-linux-ld: vmlinux.o: in function `pcpu_get_vm_areas':
(.text+0x101cc0f): undefined reference to `__kasan_unpoison_vmap_areas'



