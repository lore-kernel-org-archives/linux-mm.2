Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2779ECAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 12:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EC2C8E0005; Thu, 25 Sep 2025 08:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C2CD8E0001; Thu, 25 Sep 2025 08:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FFEB8E0005; Thu, 25 Sep 2025 08:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D81E8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:02:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D2601DF71F
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:02:39 +0000 (UTC)
X-FDA: 83927635638.14.5D47DF2
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf20.hostedemail.com (Postfix) with ESMTP id E5A2E1C001D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:02:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=Wexx5dWx;
	spf=pass (imf20.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758801757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+YsYSsjXHoCZf1yDpNVGLxhHA3dngJtQSAS0a5Tx4PA=;
	b=T1ElPLoJJgX4pnOs/YktVcAVpRqRwmX+BZdu37KoecHCj99EGyfh6kuUfe8uLqOi6DVkdr
	GCcobP7Tdp+aby+jyXpAadBbqXHSPWy5m0q82VE0spRT+Y9+R26U1PiUyVlfOWRfQCOHz7
	9Khqm57pEP+PI8R9YzwlH2RZH0zwASI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=Wexx5dWx;
	spf=pass (imf20.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758801757; a=rsa-sha256;
	cv=none;
	b=fW7b4bApqN0oBeYGKMt2NdT9ajpSiJfn+bvOv+JMNh1Lt5dTvaB5/5XuZkedaS0G/gKU7x
	b296ahx9Kv8D0PhXhDAwpPmmbyVqq3WB4xznVkBAbG73Q4+RVdZ+ZlIa1QNbsutNhTPPjb
	t0HGu/2SU59W1x9wW3sqvd4uvHt4oDk=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4cXXQc1yyMz9sZc;
	Thu, 25 Sep 2025 14:02:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1758801752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+YsYSsjXHoCZf1yDpNVGLxhHA3dngJtQSAS0a5Tx4PA=;
	b=Wexx5dWxo8RpKBddDVUpjHMylP0trukOxHItpqb57jd9Wb72VCle/wWI2Y1l+8veGppj3i
	uhoKkU+FQgEUN1PPZBmlFBqPI69UVT/QtCMqiKm8IZ5vybB0iziaP4VLRuKF7Q6NOMZzZd
	pObcjnoeAS/XgXJZJI5zlockMFbZex7KBtXjEKutGf/Sf2B38+pJs9s9w1MPuR58ZeD6hN
	8tyF16Oj6HAbpGbx2S7AUq8/i+x/3DL9inYcGzkPJ4MA+eZ12RdrZpgcMzZ5bpihwPgILf
	5ZIPWkgTaDfNvfILyOFgrLAPJOnplN6/fk+blBQzqaWqcrRZ04k0bwh0XI1bSQ==
Date: Thu, 25 Sep 2025 14:02:23 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, linmiaohe@huawei.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, nao.horiguchi@gmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
Message-ID: <fzfcprayhtwbyuauld5geudyzzrslcb3luaneejq4hyq2aqm3l@iwpn2n33gi3m>
References: <68d2c943.a70a0220.1b52b.02b3.GAE@google.com>
 <ce93b55c-75a7-4b4d-a68b-9d80baf1578b@redhat.com>
 <DB0E39CD-36A9-4929-BCC6-33F27E387AEA@nvidia.com>
 <70522abd-c03a-43a9-a882-76f59f33404d@redhat.com>
 <B0781266-D168-4DCB-BFCE-3EA01F43F184@nvidia.com>
 <cad74ef8-3543-4fc5-a175-8fc23a88776a@redhat.com>
 <E82638DD-9E5D-4C69-AA0F-7DDC0E3D109B@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E82638DD-9E5D-4C69-AA0F-7DDC0E3D109B@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E5A2E1C001D
X-Stat-Signature: prz1doqsnugje7qhgjxx7kj4awzpbee5
X-HE-Tag: 1758801756-725729
X-HE-Meta: U2FsdGVkX1+cAe7E1p031f8eAM9onB+Y7AN8ftpPwGRzG8Wtr58ZNRX0eljL6DT7+O12we3zPSFbHpWhQjtcKM5+hRFMFKZ+Zr2uz0XlmiiYkmUQnDfT04KpMrnvL/vBEec2Y4WaGbIk8GIi4v8weTuDPAmRdXOVBvFuWDrhycJODthc3Os7atC7qEeEq4g0HLo1CoBt0AviaK20lJSmFOXGfZNAOib5wn2vyi5Yrd3nNDMM67MdBt2wFfLG7xai52pCZ6nNXHFKtZhuBmNdM3/oQUX4Fhf4iNZdOdNf8pb9y+nn8hLvsoiITKm5JVxgz95PkaOD2bdIu4cHSNt5vVWKuasmFOPdaamPRnfXI+avMS13NyrZ6Gek3LNqcvkU3sgreSvXqHvqplc8tZIRAq/C+Of1ZcRZQgSKcCm5LrOyMUvgKlyAcCLQ0DPcyVkAxJlWzo3sVh5XUQ02yRb2px/+5dwMEUXb1GLrxDSb2jEBzVFRPUmF1Xrgrn2tOaAncfOXAg9sW/6NfUYkGE5rm5aA6qZqhbG/wjlr0CsJvvFT2eB28ROGANhFy2loHm/8Ut4G/d+cmyF2da/alHLdO22Fy4gaGbuz92uTK1NC9LU91sRlWPAFQoU7In3MhY7UGjV3qw+QTWHEdedLN1TeAbLVFs7LU2US/Bgg4F02NwjxxvIXwX4GV5Ox68jbkGqjkkcKX/+yk7kHNPFdVJEvdyyuLmFgfq+EvlKHMm13P43PwZlsFhsXLXKWpdzLRWAPZLPnBYhTYf6DhTYR+8GTzF4jdG2Jm+dZn49+BcCxQVl3F4MQDdQ3O6tkIqF3nTX58p7XpOQ5B812INfD7oArYyHF85aTX7k5wI/XThhXWGsAskTMCHlSi1+8yHZsTmMp88CfKRhGBUfr6cj2l8BiKgJAx/S28OqPOFobJVDtqFhBw270L85XifmShP1D3zfo7qJH73px/G8RVM40gzz
 VIuD/o1m
 YAOpz1+NxCkwCUoBd3hdqVRlCRkTRpg1xYInkb7f7N32HtJebBEgZuIL7u9LiBCpQp9FFRl/wSHz1Y8h+hoHsBexLHugR/ulYIIQ6oCVmFue8/trpRQN425wCEksSgsKMLaf0hReciK6X3sJgTlIEmhCmL6jO0CythDpr1vg9nea6laIsWWpud8tjYhHkyzu4AhAtaeubpLzDN5GwGxUm7IFdHhslINZrifjEBbHJftfWQKL7C6gBYFFMQ7bCoseF4P4ggueM+I4mqpbb5s522bc6pzonb+8yjsnrR4PXhCwUSIEw59fDN/pHBhp3efO3MPZf82/nBgxIprGh98mnZHxtk8oTCIQVYshAcrywpxrqhi3gQAJQ1xR+Bz+KPomlcW04dW2XBtZV9IM858aP5stervFoxhSfL+TPeUGqXi46J7N4ejAcXyEGhNrHDRlgz9QVIoMQL6749932FtZY7KEj73UmoWxZX0dQ3F1pB3mYaik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >>
> >> We might just need (a), since there is no caller of (b) in kernel, except
> >> split_folio_to_order() is used for testing. There might be future uses
> >> when kernel wants to convert from THP to mTHP, but it seems that we are
> >> not there yet.
> >>
> >
> > Even better, then maybe selected interfaces could just fail if the min-order contradicts with the request to split to a non-larger (order-0) folio.
> 
> Yep. Let’s hear what Luis and Pankaj will say about this.
> 
> >
> >>
> >>
> >> +Luis and Pankaj for their opinions on how LBS is going to use split folio
> >> to any order.
> >>
> >> Hi Luis and Pankaj,
> >>
> >> It seems that bumping split folio order from 0 to mapping_min_folio_order()
> >> instead of simply failing the split folio call gives surprises to some
> >> callers and causes issues like the one reported by this email. I cannot think
> >> of any situation where failing a folio split does not work. If LBS code
> >> wants to split, it should supply mapping_min_folio_order(), right? Does
> >> such caller exist?
> >>

I am not aware of any place in the LBS path where we supply the
min_order. truncate_inode_partial_folio() calls try_folio_split(), which
takes care of splitting in min_order chunks. So we embedded the
min_order in the MM functions that performs the split instead of the
caller passing the min_order. Probably, that is why this problem is
being exposed now where people are surprised by seeing a large folio
even though they asked to split folios to order-0.

As you concluded, we will not be breaking anything wrt LBS as we
just refuse to split if it doesn't match the min_order. The only issue I
see is we might be exacerbating ENOMEM errors as we are not splitting as
many folios with this change. But the solution for that is simple, add
more RAM to the system ;)

Just for clarity, are we talking about changing the behaviour just the
try_to_split_thp_page() function or all the split functions in huge_mm.h?

-- 
Pankaj

