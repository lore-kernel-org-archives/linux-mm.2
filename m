Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 649FBC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 731126B00B5; Thu,  3 Sep 2026 03:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E0D86B00B8; Thu,  3 Sep 2026 03:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8696B00C2; Thu,  3 Sep 2026 03:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 325016B00B5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:55:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BAB851401BA
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:55:27 +0000 (UTC)
X-FDA: 85171691094.20.F5B7517
Received: from mta1.migadu.com (out-197.mta1.migadu.com [95.215.58.197])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0F417120006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:55:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u3ScGSR5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.197 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788422126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=itCmv3JUmFtHA0g1GqqNKNNBI1gqt4sXnXvRwpyIvXs=;
	b=dSHv+Eig5GSrnwHutIGGGXhKnIaEyMlDoD9n0RgJYFobxj0/6yFm7LM54Qx54WbwuDpahb
	9GDzkAVVAUikwNddH6RGtpP9l1v0G9xsa0lRNBZ5Kk0R2jH81wkMysyDg2gudDovT1zGC5
	ed/G24Tj9zWB8CGjLaGtyMxJnnV3rik=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u3ScGSR5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.197 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788422126;
	b=s4mzTIO/5hI1MJd16AfRdp4CfFqL2I5dPDdbh75Ydmmp4DAsLrLlpW2i/uwVBM1VPuCNzH
	FM7qzByaRdsjFIqFlyHvGdV+/3RCeGHsqjEU32oi/dRqCVxRetff+9vcRdc+tC56P+dpxT
	aQd/2p639hKA72E5kABmBce/u7Qy510=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=o0utxRT6lPpIqhqf3RPoer+EjDMkX/LUDuhmVYcVzg8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788422121; v=1; x=1789026921;
 b=u3ScGSR5ph+dLi1TMHxf9J9qVf2xhxgwjPQzk/cOgeJQChcFfbO5GxOcPL/2KK94KzvwKLRq
 7d2bb09bL8aWOMHnQjCg+EShXsIpe16wZPg1SY6zMY8QLVn3VYPA44IYa8q4xhxg9cqqKQYg0y7
 NnapQHGPh5s9vYbIeoBMauz8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 1e804ac248914eb0;
	Thu, 03 Sep 2026 07:55:06 +0000
X-Mizu-Trace-ID: 1e804ac248914eb0
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 15:54:59 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	baohua@kernel.org, youngjun.park@lge.com, hannes@cmpxchg.org,
	yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/16] mm: zswap: return -ENOENT when the swap device is
 gone
Message-ID: <apkn02lBhQl-JusJ@fedora>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
 <20260827094509.1016740-2-hebaoquan@kylinos.cn>
 <CAKEwX=MqTYpZAwBDOOzdkuo7NP0JFRjFdQaedtrjk_HCNmTSXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=MqTYpZAwBDOOzdkuo7NP0JFRjFdQaedtrjk_HCNmTSXA@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0F417120006
X-Stat-Signature: u19fh19sru5s8x3du88ysufy5ngztq9u
X-Rspam-User: 
X-HE-Tag: 1788422122-75294
X-HE-Meta: U2FsdGVkX1/aFfqCxs4YiXcin31/zy8cnwh056AMbBD0f8EVpHEuomBUNL0B1p5m3xYWLLgFTnjd/uK1x9RAcbkmZEGv2f5ZMuer/AaJzEhGu8wc6ZIMX5jIMPb5VjHD7KXHq3C5lwrJXXbQ6RzLjKzQYm//5LPARVidGZ+SbYgHgOUdVc16qxI3LA7W96fUQqV671jyaEk4Oh2fmLWJgikD925bpMX4aVdM6Sl59GgDG8MpqiV8O60yt+w7VcfjZVk65nGpugC/0b110uxmEYrdwuGUUQFPvEz/IUY059IkL7sC4jhBZwCpvesumBQlZjym2XxuGmfgbt5WhnLQxiqMmwdxl2sibSvRBHxocwhLue3zax6qvHpKRNxtp2BT4/RawUE2wecA5HM4ECuX6r/Mjas6MGGSqE+S59oSUMnXl3a0rplIa+JSfvsKBHDt59hYFNdr6COM1kM3WXST96+1qEec/jzHUHBnAHtxgvckYJE4zDIn3jL5EAFFZ/PyP/c7src0tXXrtiVMa6n8J4ngf1D9rQWrjL12jTtjEhOmihdSbcq4bBuCxIjHvcovlsm4Ud+yosApuPf7vqB9+3CdOa2tTsv5f5V/YLPqreHvCz5UPZU7vjqmSN0so1+pIr7vsd3uXt83NOEsit+5X+xhU+Qpb52smjE8n7H13uV1GYoh1LdxGhyqJ0Z2ML4WNWPDV+3duUOJv4XsyEhrQ/I/MAZ0jpaobjQhxPDI4dacsCfWLdmZ/kFliwYIX58gLtpmIP8sCliZ3YSouQUUoW5zGf7lkvJH9zqv6wd90kjnE9cHg8bc3NiBsMSZ/TyZb9BhN9c4GxWiNPwqi48iGUdxg5rn+3RLhO+NUE9FtTWkjKzW5906unwp7z4coKiDBHveNkxhihdHWHFod80GcIGEblmYKVxjaJZ1p5lxxYxL2PXbDwDTBXsmKSJGjHykQEtZqLIHXnB4Xrc/FVC
 cqy2nNJF
 DBMlDk4MpoAZ/uiSQgfHiHXfnMPMdmCxMQrZw0EERWTSZgEWsO1gztCdeIV+CU/ZFl83C5UEn8z6H8yYtemsVg6W5FFXO9bgp1xYog+DbqABG1+jG+T34qD72qJbci+LFAJHQA0raAfuwUhZsAV1OXERPCdPnwYcxuNzJCUmloODdXpdn2inE8s+5Gg1uUxhZTIUhN5BL7WxGE94zVSwAfBE2LxJAD4bJOFGwr2XGYGSk6EfnlvtNJlBjvVPjMx3XbgRwqTWLxWf9WNA94xypYh6/7zL38HrDYmAKKmYZRXoFSVB7uOD6DajiT5aXViP151ELgcraSE7rfV/URNRnm3cYwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/02/26 at 10:53am, Nhat Pham wrote:
> On Thu, Aug 27, 2026 at 5:45 AM Baoquan He <hebaoquan@kylinos.cn> wrote:
> >
> > zswap_writeback_entry() returns -EEXIST when get_swap_device() finds no
> > device.  -EEXIST is the shrinker's "page already in swap cache" signal,
> > which makes zswap_shrinker_scan() stop shrinking entirely.  A NULL
> > get_swap_device() instead means the device is being swapped off, so the
> > entry is simply stale.
> >
> > Return -ENOENT so the shrinker skips the stale entry and keeps scanning.
> > Independent of xswap; affects all swap devices.
> >
> > Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> 
> I think this should be submitted independently of this patch series!
> It's a small, self-contained fix for an existing issue, no?

Right, this should be sent out as a standalone patch. I will split it
from v2. Thanks for careful checking. 
> 
> Acked-by: Nhat Pham <nphamcs@gmail.com>

