Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7A15C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 05:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 300DC6B009E; Mon,  6 Jul 2026 01:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AD996B009F; Mon,  6 Jul 2026 01:23:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3BC6B00A0; Mon,  6 Jul 2026 01:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E855B6B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 01:23:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F663A02BA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:23:48 +0000 (UTC)
X-FDA: 84957209736.28.A07C925
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2C108140009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:23:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PCyLcZWj;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783315426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PSojfwaQMPYZzi0c0qcA2UvoigiUv2kyygMMHcgyNn0=;
	b=Y1ci7lLtkFvLSF3oXHXxVxkiJGo+7Hl6ZdZV5yXL1dZP2R69e3NlsWubQzKqWMYsaf/9NK
	HprB67xPOSQqM3Mrhjuuxxf8DzqkK04KEwHVztp/QY1+hKNEGoa9lSjJOQBZf2FF/AzlXy
	iH+clmEi3/VrKebaOPEn8N+Ftlt1Ob4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PCyLcZWj;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783315426;
	b=ZBKhtWn37hxFowZ37E/IpFlUeN/II7V0VxBgO9b7xnKsj+Z2hdSDbV1t1J1t7rm9K+XDIp
	yn9ITzMjfAQ51uKuTODhVWpvv1fmvY4IrrkdQIKMNiohzXIK59Qx194vWpOYT/IbujkcPz
	WkRrmuk+Ro/i3L2aHzrxs0aRPk3PXnE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F176A411D2;
	Mon,  6 Jul 2026 05:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564851F000E9;
	Mon,  6 Jul 2026 05:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783315424;
	bh=PSojfwaQMPYZzi0c0qcA2UvoigiUv2kyygMMHcgyNn0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PCyLcZWjVBueEkLUn9wEESmcgi4ep4pGNUTFj1YqTQXrbZkJpttzni87p1BVAX3vk
	 wP1d3BhHZI/QdFTAY4pvJP8+hJ3ApLC/I4Hb+jOS0GXv9KTyr22/18x+Efaf0+rlXZ
	 w7lu5srpgYYPcaHOlYYgVEesWd7+3vd2owdaDdp0=
Date: Sun, 5 Jul 2026 22:23:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Hajime Tazaki <thehajime@gmail.com>, liam@infradead.org, ljs@kernel.org,
 vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [PATCH] mm: nommu: point to the write iterator upon split_vma
Message-Id: <20260705222343.5d5c78cbb54839c5efcaabf5@linux-foundation.org>
In-Reply-To: <aksn5J8Nr0JIsVpQ@casper.infradead.org>
References: <20260702012546.665383-1-thehajime@gmail.com>
	<20260705152708.582fd8d87561f600da23c0a7@linux-foundation.org>
	<aksn5J8Nr0JIsVpQ@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C108140009
X-Stat-Signature: m3fgjgzzhk7hos6h51787txhd55hbwfq
X-HE-Tag: 1783315426-584630
X-HE-Meta: U2FsdGVkX1+xSywbjYGG7sLhvTX1KwEAqGfcKVM6KzwfA0zgpSrj8MdnQ4yDGcvPCfSGDCUYF/WVknRsHzUBnsOsfTJP8sE2WbBnfVcobsvGLcY58zbV66jmTBdgo4htztGh6BaMf7JOp3vk7LW+tvEe3CWVHiBbiXmOjixL8vf8B01XGP9gKrw8y5+qNxaStojIQH3mFXovYwMqUHut4R5Oe/a2cfOf+9ACYlAXiHZy6l9o1adPWpe10rGvLQM9WB71iTI+yoS2+b2FfW5zP3PYImHQEV+UM25NpK66t8ILC6mF10wTFlj7m+kov/fmeTGZW/1OEOWzfPLf5lCdQFJIpczi47OHAJlKuHOAwqQnaRpqaW86T3SSnYBoo3fURaN0Fzpw7RzC5knPaZ+kdvTMUJz9Kn2rpZEUJd5WAr1gEOGAYkhxtiIF4v0CRVokIAJioamknPZ5f3DrOr5uWSqqUyq6E1tJ3Kobv0IsvwE+8jqLTlN6/+IalOljI2j36JBN35XmQf5O/EVniT0axO4HlDeuDZoDk7Pn8kE8cUySY19HWE9zgRxJbhhjQHMpVyR+go3wvJCm3TDEBVudbtJHro+6NfoJR9623ssmbXUIYDod4aplbJTmQLTfcSGJWtJrNpR8ioMM81bmQZ3oOh8xaSfeGr1hzAAE1eA4tIlGqrPiK0W+r3wWEaQTKsc98eYwvlvaUhwRn5YM/jX39ERJ5mkNc8OVAa9TkuOgy0kwj6fxGOEb5LGNbRNoa+ApQD7owmFJeYeJeR9xeFBDTzmPc954IRva5yeZm9peIcBqVlCPJBu0iLSfPtefarAOz1YkGBvc1vacFFicQIEbw9DHU9pVaiWNzenqu2leIJk9I6njbXn9LjIms6RfaciyagHINhCCmzexOSOyBxcSfI1TQmHX0iP0Ns33IMaiZbf4lJV3PKuRJnVii5scEmNCr+j/qQL2L3ewLfLptb1
 8atx4ZHU
 L2Hk5QxE77c9qi5l487w2D7MCveo/zpkIqBdMZcJNaG9Y/NDf+F7a1NsODLkPWBgDDiiDxl5RHRbzYiQXDu5f7lSpb54ZTeYD7X6ckWWg2b3cU8JIlSVmpBgIJI0c1k8qL41dvJ3p/6ny24Z+m4Kl1aSuj5t7ZLBCub/fDSNR7fWjho1GkEezVMAXs/JgKXfp/w6f2hge29ZHHRv4CJkq0DTv+LCjz94fw9tw/jMxJJBZgSaCnoqYRx0V4A7RxVE/qHwGKmC70SGLSqagyocW6uPGCegojvIr2Ny+9Mhsr7lFSc8H8/LAqr8+PfX7OAiHIMnpDp//JFoyOMljieSgdY3mBcLKLCLbEc29eM97G2FPQXBCtEP5zdiHJnNIwcSpH/h4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Jul 2026 04:58:28 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Sun, Jul 05, 2026 at 03:27:08PM -0700, Andrew Morton wrote:
> > Thanks.  Unfortunately we aren't very diligent about the nommu code
> > (are we?).   Perhaps appropriately - clearly this code doesn't get used a
> > lot.
> 
> Should we delete support for NOMMU?  As you say, it doesn't get much
> testing, or presumably usage.  I have this quote from #m68k a couple of
> years ago...

Greg is busily developing kernel code.

> : I looked at nommu very briefly when I had my 68000 board on the bench
> : but didn’t get anywhere. Also didn’t try particularly hard. I think
> : you are better off with fuzix or OS9 if you want something unixy.
> 
> (i suspect Zephyr would also be good, but it doesn't support m68k, just
> arc, arm, arm64, mips, openrisc, renesas rx, riscv, sparc, x86 and xtensa)

Greg, how mush use is NOMMU Linux seeing nowadays?

Thanks.

