Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6993DC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 08:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566786B0088; Fri, 25 Sep 2026 04:15:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517516B008A; Fri, 25 Sep 2026 04:15:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42C196B008C; Fri, 25 Sep 2026 04:15:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 231C86B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:15:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E3C11A0583
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:15:16 +0000 (UTC)
X-FDA: 85251574632.02.DF6028D
Received: from mta1.migadu.com (out-238.mta1.migadu.com [95.215.58.238])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7650118000C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:15:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KRNnJLwd;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.238 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790324113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kRDJ6MnSY4s3eUr3hnETwacCU3czwQAXrUPoNwgrhH8=;
	b=mmv7ee+IHHDLoJcMR7NCdXhg5GrIjxTIGkRFZPczGguhUVltT3gXzEIo4RdkIRhRvQXzeC
	3LDbcoshmokorqO0Nk7e+/Z/8iCVNDHvkoCxHIg65bu7Sv8eqfg6r/5UvVYz+ZhJ02Br80
	2ZaBDB5TOF0nc7VPrdiN2TSGN1Q0e18=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790324113;
	b=vZggodwWcwrGfhf6CZSGQuRVlcHgaQuC+QowWr71hGEggngxYLqTadr8rpMNb8waWvAPCi
	MJwSWHuVdooTLhUDJ1GTajgurxXSuNRqoRBS343aFONPNylDS3Z40VzJJoBlDjW3XcOQ9B
	g7ROs+EiJoD7zzZ5HZYBFtSgMXrgN/M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KRNnJLwd;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.238 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=juiO3GcMTXWmLdFNZ5aDekSzxCw2FRDtxyNSWHdnk1g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790324111; v=1; x=1790928911;
 b=KRNnJLwdUIq5fJcqekxo4lfAdpCs/jAWBfWjnIWqYUBxAFlskdm/kxzLMZslZtUx0aUBCw8e
 cv/gIc2bRM7OvfODZVGykpizRaA/igfaTpYWBYRe7/zfkMAUdgVf6plcopvqKCUoMbu6a/JUTMH
 H3PLxipRLHMCbRbgTztn8RXs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0c74c6bed6dbbf42;
	Fri, 25 Sep 2026 08:15:09 +0000
X-Mizu-Trace-ID: 0c74c6bed6dbbf42
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	muchun.song@linux.dev,
	research@deepseek.com
Cc: lance.yang@linux.dev,
	sj@kernel.org,
	mst@redhat.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	ryncsn@gmail.com,
	kunwu.chan@gmail.com,
	lianux.mm@gmail.com,
	baohua@kernel.org,
	xueyuan.chen21@gmail.com
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
Date: Fri, 25 Sep 2026 16:15:04 +0800
Message-ID: <20260925081504.23569-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <9f63d60c-913e-4e79-9d28-890dd48ef713@kernel.org>
References: <9f63d60c-913e-4e79-9d28-890dd48ef713@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7650118000C
X-Stat-Signature: 9ydzws3userqxpq8ecbe1jxmz43drf1j
X-Rspam-User: 
X-HE-Tag: 1790324113-465702
X-HE-Meta: U2FsdGVkX19OWdPyZZytzNDeTbvWtoUxREZasep5Rb0rG69TiJUNJu5L9W69Jd9RVJ0CX2OME0Q2hxCh+9UTJJZXHHf7g3422a41UGoq03RIT3leNDTztLNO91ZjOcUVo6XuRa8iG8BsbjGC05zHkm0MLptuktEeAs8pVG/OENdwrCvN4cROA4+GQ0VweDw+62TghNM6l0/lJYEinQdjU2rLxe9I4t1d7A7J+CId2ubEGuK6H7e6b66Hd2xXU0lusHHVgv/sepS0WqpTX4HPXh2BU/zqfyjbaVfjr538aL8yBitefPJ3j6aLE9WEaNmxlpUbDsztCkRJxXVY9yCYLnksHBj2bRqkOUHMxR9FEaCJMkui4b551bneLrQarHmj/AjRa7ap55xhYRaNHZi5GCQb4ukIfDe3h2BPVJrLjRCaCfFTD0kvlberBmttZdqR+ke0v/f4Ao07AIs1FVQAG7fpRzZPzKwdhRSaMykelES2ET1mgOjYabNWZ0NwsaRYUiAW2YcVcqTVQOsS+Ozbtc7DmipqP+D/fNpGmtRvRyQ+5pjGleUd++o3wbJhycpfLGvE5zr3V5+D1unKb94Sk/XttZATHmTKA/rzpsHRgpxk/s/RkVh2Za/o0h5ji6/mSQXU1o/AuggjfrBf42aVAjEDLFE11nLBx0qlbF5GatpN4SAPAE+WOKhRHYbFsc9KtHiH3ZT3Dk4kchHka4ZpJPHdijB5wWGgmlVOHyQyy4Iu7q4RRGmcvG9+FT5JiwysW4YgcPSjm598IKVO59in5AQSFdPX9hUVOF5sTqfa7GD4QKl5DJH1VVuClEmCkmYvWFTBFFXWhq7F5Ijkqbkokrww992d+4M/kLtYCFkFs0HRZMCUS8WooRqVSoeoUQKwcpvfsfcpMDPS5gvcBuM9vZTMDyAErb4ldY4rmiisrRg2SkDk4tL5UfmH+idUH/yHWJm4WtqR/pjt8yg0493
 u9Vnfqyp
 3kPCZj65S7leQ4m6H1SMbV5X2RhuTte4V4cd/CSZLh7jpoPqWShtZrOg+/uzk6eQdLmNKGDUBkIi+UHpi8MtOpA6joYKWReReKj9aR2HCmQqto0o7UoJFf4KyvqvZ2KF3O1e1eRUJNmTvdb004FuvzJgLzoFBR/i/3ixof16HnJZQXxcrpVGvWwy12DkBYipdePrNOfDXWjfHGI0I/MUiAPkV91QIgsfVvSxva4LPlZy76B9ZBL7+U1muRhz/MmocQd+Oz7QpyZaauiyAk8m/4Hcn+5HBUH4aD2g82kJ0me/AHfQS6OWx+q5RW2pgH3GEspo7wKpS6eHj3kS5VJklXljWeJaCa5StvtHZacwYQ2CcPI4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc DeepSeek and Muchun

On Fri, Sep 25, 2026 at 09:04:41AM +0200, David Hildenbrand (Arm) wrote:
>On 9/25/26 07:44, Lance Yang wrote:
>> Hi all,
>> 
>> I was reading DeepSeek's new DSec paper[1] and found a nice use of DAMON
>> and virtio-balloon:
>> 
>> With this kind of workload, an agent may read a file once and never touch
>> it again, while those pages remain in the guest page cache. Without memory
>> pressure in the guest, they can stay cached even though the host would
>> like that memory back ...
>> 
>> The trick is DAMON + virtio-balloon free-page reporting :) DAMON reclaims
>
>Heh, I read "virtio-balloon" and thought "balloon inflation/deflation, what year
>is it?!". Free-page reporting makes much more sense.
>
>> cold file pages from the guest page cache; buddy gets a chance to coalesce
>> them into reportable blocks, and virtio-balloon passes those blocks to
>> Firecracker. Firecracker can then drop the host backing with MADV_DONTNEED.
>
>When I was at RH we were looking at this issue as well. virtio-pmem was one way
>of avoiding the page cache in VM entirely. But it has its own limitations.

YES, they enable virtio-pmem with DAX for the read-only EROFS base-image
and toolkit layers, while using DAMON with balloon free-page reporting to
reclaim cold file pages from the guest page cache on larger writable disks.

They also point out that the guest must allocate struct page metadata for
the entire pmem-backed address range. So virtio-pmem is not free either :)

BTW, Muchun recently posted a pretty cool series for exactly that:

https://lore.kernel.org/linux-mm/20260903122128.12264-1-songmuchun@bytedance.com/

(It shares vmemmap backing until a DAX fault needs private metadata,
avoiding the full per-PFN cost up front.)

I have a feeling the DeepSeek team will be watching this one closely :P

>Thanks for sharing!

Cheers!

