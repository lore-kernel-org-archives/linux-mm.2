Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6624CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 10:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23AD28E0005; Mon, 29 Sep 2025 06:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EA5D8E0002; Mon, 29 Sep 2025 06:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D9578E0005; Mon, 29 Sep 2025 06:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ECB108E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 06:58:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75A8A86618
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:58:09 +0000 (UTC)
X-FDA: 83941988298.26.6E182E1
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7DC5C100009
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:58:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="X /lXBL+";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=HhPzZePM;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759143487; a=rsa-sha256;
	cv=none;
	b=4GzR2UZXQmILfRz/XVMHXmTvtZJEe9J4a531uTJ5AlpayAtEsgSYTRNq3PtVgKZkmXGP9D
	zIOAHXXAi30PsJvbPGGNU6QWvfUEsO8trJV/SKdfk5gc+y5k5JynZt1A3Qr5JHpY9Ta9f7
	Sjg+/WyCdn3+3H6/7wMhxuIgP2PbVyc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="X /lXBL+";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=HhPzZePM;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759143487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/P2WZ8pYQWNreY9h/D/CldbRuCHI38K+JiczSNjSE8=;
	b=o0aM0N08pK30Vb/SyD7+ExD/0HbB4xbbwPq0Ue8560PPapN4IZ9om4KIxTcKlQev5Rzv9I
	uFr39n1IvmAJP+nasKDI/ZWdKADqTHed+rwDaXlq0yE2G5vkAj9ZfBzV+Q7yhnqHs3j+IP
	qe5glUq8pgpEd6n9qduJBn3W2i0uFS4=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id A4D8CEC011B;
	Mon, 29 Sep 2025 06:58:06 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Mon, 29 Sep 2025 06:58:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1759143486; x=
	1759229886; bh=g/P2WZ8pYQWNreY9h/D/CldbRuCHI38K+JiczSNjSE8=; b=X
	/lXBL+wmunqRYDJ9QzmTO4emJyUdTxosB9W90n/5PsvpAm1k1UNiOw/kqfXDLlVI
	m0C3A+lM88tAR6Jp7URU/EJfBGrIsxb4nOGcDGnxE8ksWSTfD6+eF2MRgY84JVWX
	n1siFhH7MYjiojVjP+wue7TXXrTqI52VspuoSV2jW4+IzRmiXy2FSPeFA8JTyszZ
	K1ncyynIy1UIokpVpXc+gNz+FNdkQQcC5hQEdb/ks2MXRkZsN2vS3ZbslDRD5VIT
	BaUqkxXEgaS1utswiMLHjCgLRMf+Srl2XOz49tLrcrDGjAXZdqY8Y1Uw55Q/g47h
	MvIu89uDyEAsktRcMBo9w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1759143486; x=1759229886; bh=g/P2WZ8pYQWNreY9h/D/CldbRuCHI38K+Ji
	czSNjSE8=; b=HhPzZePMYq8OdsA/It4H8i7Q0veqZzhU0YpgK+Wz1FlmtphwUlU
	7ynuETfXp7uONnf+nUHx+27nzL+vRXIHnG9oxW9DNfiBEEVD346/RInpTj/Xr/Vt
	B3nc2Bx6ItzhIMiujqVUgwtguCx2sMdiW+gM+2JLt83s/QQ5nFnCvlD+uJH2wmgM
	fgQcbVPRB8przgrjUc08EKBQEsiALOl3DYwcuuUBp3XFghA5A2E741+mHVNFih8U
	+La3LrYmuFSBqq7mPno2nZXCivW6IONI6Hv6Icszpcy8/ZRPjsRY3dmHTvw4D2SX
	A3uDlbtKhFDebJABKIp5AKz+biuZoj0EgcQ==
X-ME-Sender: <xms:PGbaaBpQ1q01QdAQVlRhN_5ILu9u4RB1PS7u5n8FLQCMXmpvblWDRA>
    <xme:PGbaaNVZvNHSnqZzWrxUw44arCiwWLMzi8K9F3Bx_-J1LzyjsgEobd9axbMNLAyyT
    aWVEDaB4L7JBD_6kGlq_Z47wtjeJbGcg7dq-Q6IEGhPGushM8-D5LM>
X-ME-Received: <xmr:PGbaaNjepAu1WuXZNR8JCv-SW8LgQshgLtlbcuYSkGiHbEfF3JRtPG-s1iz6cQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdejjeekfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfedv
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehrihgthhgrrhgurdifvghihigrnh
    hgsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgu
    rghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtghomhdprh
    gtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprhgt
    phhtthhopeiiihihsehnvhhiughirgdrtghomhdprhgtphhtthhopegsrgholhhinhdrfi
    grnhhgsehlihhnuhigrdgrlhhisggrsggrrdgtohhmpdhrtghpthhtoheplhhirghmrdhh
    ohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopehnphgrtghhvgesrhgvug
    hhrghtrdgtohhmpdhrtghpthhtoheprhihrghnrdhrohgsvghrthhssegrrhhmrdgtohhm
X-ME-Proxy: <xmx:PGbaaE8QiuScIh-F0Z1ocCzFHqoajKekPksGdYSupnfIFh375UCEtw>
    <xmx:PGbaaFRADEGtI4J212nrVCGuTfVlIniBVczGC3vr8kPWedybLUBBng>
    <xmx:PGbaaBGAbHbbpDSdilJNQVx5T0em7ulPHlF8ryI8w_WOduY4-KdgaQ>
    <xmx:PGbaaJgqwdHtLCNYecscYNcwW0GcAfvXkcaN-PpiM_4AMGwty9OkKw>
    <xmx:PmbaaJe6e0sZd0thVOC6t2QA5H_pi896oMfzl8gkx9YMFg9jMByibydm>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 29 Sep 2025 06:58:04 -0400 (EDT)
Date: Mon, 29 Sep 2025 11:58:01 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [Patch v4 1/2] mm/ksm: don't call mm_slot_entry() when the slot
 is NULL
Message-ID: <fkxkvkapvckqp366untyvwp4fpnl6ljdegfxteqniil6427flz@36ace6twyslf>
References: <20250927004539.19308-1-richard.weiyang@gmail.com>
 <20250927004539.19308-2-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250927004539.19308-2-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7DC5C100009
X-Stat-Signature: qeg6qxsjgxsco9d8tuz33ons65hkk6pt
X-Rspam-User: 
X-HE-Tag: 1759143487-66926
X-HE-Meta: U2FsdGVkX18wQ7rh7cKjMb63wkLJtSwVA6yP6LoTNJ5/kE3w5pXHKyBEjMCA0/keuCiF9emtOHSR/af/3YyUuPjOjAaDOlIC7B9HbYSCGX/ZAlA4k2gcNSqrcWDsCn6v+j8TRwpVGjFyXHZkCuwiCDYT1pia8WnPyKhc0+2hFSgnH2nHL7czHCDy2wG31U9TVlOqPHeNu9nKheMJW+J8ARcGi2DIPjXC1ePeYeHhs04odZ9ndCeu/VA2+J99FxE5w2L5cc/zIvJgIBCAyWd1OJFua5a/dsR6nc95os5FyaPUm8qATIEQN1N+XMx4T+wonm6DWuzC6Rq0XbWlDi5unCp0E8mV7jREyXMR2VmPsMCbBpPne3pePAJq9W02p/TEzIaSrLF6w2yQqhjPSRG+X1E4God0DtuuYVN/hQMR4GQU4oRZvqy+moLO0rIoG4lEVfYBNHCnpgy5GV30zFKWcYmmdGAFkDAHaU+SvoSe7J8fyROibEW040cAtEU2mtty4SyifSoYDwXaOMqUqbCihYVGw+6wuyxGckvKMlRPfL/eL6Yg8Nz8ZenafSXtdctxXzDA1rQkqMwqEnaDQzGAGOO7VoxMwKsk0Aw9vxBnnv3CEE5TU5pu/nZR5FsKQBdjMMnAIt97pcVxfV/DqTR98QwvioYs2p2WuWPTg/D/pzsYzYCc6xcmrFLnxUH46oHH5Fa+TdUPpDUXEl5eqsfWzlauSs+RnZzCE9wdVUH2b2/w0yAVgInpOnxPGFyKtAhyjJTgSz9qHxIUr1LAOkKSFA4nWH07TF4j5iqiS/ZiC5IBZKF48qTLoihOupKchTjKNCq9Vd8GDyAIQ7WmNKzuxyJ03nGGQAuQE1hjDy0+5AcBmBntnHY6w2vFH60blD52qfzrHgjcVUhzs6ZWUXRZRggheQbQD+/740+ueBdFAw9mN0g1EZVsGxpSPBaNhBbPqKTM3vTsBxRI9fTMxBS
 4WI8hK+8
 TOZL5/UlGGBubNMxGzZ3NSbNsAbYgbhore6pDRp7rYejrBAUCtH4tcsH2DjuaYvDE5+QsbYbfQb6NtXuKznvsYjEUuIMmUGurw/fcfN+ukFHSCuUVOuUB7pYSUdomQOtxCLym2h8Hn9MbYScDC69i6DTnCxPvyKQIrfWTwcchktW55a/WI14Ttfep1TLeBp1kIbtCXoQyt2O458KZOwAnLkf5ArxOrlvqJBOcPli8rYL7Smz/VysCXg5xn2Xqrze10eRmceCyswgO7JOov/51YkvjfELoJ+BFIIcYsKDrrhhR4E4h2N7ZCZGvrMqeA643ey9MRTWNd+UHuiT57nV2MMrpXgKerJRQs9c+sBKOugNed7qsu/36XJRFAXY4L8JJflHNwHghnvnz4syRZmpxJdIXLFIRxVdFI7Kft7mOT8d6jKHIGLbbwXK+kwjaRR5hsHZ0xwBjYSPvTV6GtnMwDkAubaUUtZc7kSmP7oX313R5OFk4gX7O9AqtRoOvxQ2Nl4eVnZ3nJJvuMr+HAc01GEctd+pruJyuxv02c871pEjMknSfkM9KqGfX6D3OuGZo03twgH+2M4R7dwCo8YWuJLIZFnmQgRBn2TrYpo/JSd5bLxD8Dp18FDrcxFn4gW2FpbrjbwISBoG/n5B+V+vufe9LRbNnsvmt9poGvv2KVuE/wBM0ZaytnTHJvrI2LQty/3Xf90Fp+FZgwl8Zjas6uoHBNTVI73keg053
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 27, 2025 at 12:45:38AM +0000, Wei Yang wrote:
> When using mm_slot in ksm, there is code like:
> 
>      slot = mm_slot_lookup(mm_slots_hash, mm);
>      mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>      if (mm_slot && ..) {
>      }
> 
> The mm_slot_entry() won't return a valid value if slot is NULL generally.
> But currently it works since slot is the first element of struct
> ksm_mm_slot.
> 
> To reduce the ambiguity and make it robust, only call mm_slot_entry()
> when we have a valid slot.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Kiryl Shutsemau <kirill@shutemov.name>
> Cc: xu xin <xu.xin16@zte.com.cn>
> Cc: Dan Carpenter <dan.carpenter@linaro.org>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>

Acked-by: Kiryl Shutsemau <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

