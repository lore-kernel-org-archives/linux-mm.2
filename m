Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F388CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 18:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7125A8E0006; Wed,  3 Sep 2025 14:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69C2D8E0001; Wed,  3 Sep 2025 14:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 563B08E0006; Wed,  3 Sep 2025 14:19:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 424B68E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:19:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5C1F140841
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:19:15 +0000 (UTC)
X-FDA: 83848751070.22.5DEDB90
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id E7E3E180011
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:19:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KAPXbGVm;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756923554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ke0qcgAMsmvpnDPJypy8RuWNPArs8ss8xx0EE84J2oc=;
	b=WpXEt80W96Q/RjjX/d8cOTm4QqX1P2MBaUAq4+tHKSeFbteASkhYpKI5FO/ObYBnxraDa2
	8Rnd2LdKobkRcqH+MdUnVLS2oCVqgcMjGzNRnjj8ECZhK81r+9DUqdWcwreeERLnR2bA+T
	aCyM/Yc3+E27IfAQAa/ZIH/hrDgJPPI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KAPXbGVm;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756923554; a=rsa-sha256;
	cv=none;
	b=5AxDcVp6zBEM1TBdT/2BtVHnKQgsLuAxutVnyuZfLnEufGwmeg8vAWgZXZM7wIKBz+/TxR
	1fYTpQERV8Ls6bPhuzmmrqWJBUQ1MJ0/v78yHxWLNHHWEvCaDEn3DVfM8jXoOe6diS+mmi
	1URux2ZedBpZY3jnBf9R1stpAKW6EAw=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-327f87275d4so121491a91.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 11:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756923553; x=1757528353; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ke0qcgAMsmvpnDPJypy8RuWNPArs8ss8xx0EE84J2oc=;
        b=KAPXbGVmjCeJOqsA1Dj9L/J4BNhCe9aW1rnumOKK+z9cGpoWNCc49+dh8t3p9OE27d
         ByBaI9OW5hDLCXy5sA/Il6Tn5cI5s9aIRJnQc3E42xNsoBVbDkWyk9fztXxx/dG3RScg
         Ab/aVdSG7Uz4JTEiNQfmcb/a+qPwBr7oTSbL2JcBK7nDCcKhaKiNGY96hn1f6tLANNuQ
         GamJt/8qT4R9tIBOAI5KngapxJcfyOBZFkVkX0qtp/PnvoL34G1/3L/sVA2f/iB4jqWw
         p2jLiHcoceKf2TxnzY2vxhm2k9+wWfuY+Dn/BBS2yg514Wa9amMn7qFCfN4q7XIkArel
         xskg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756923553; x=1757528353;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ke0qcgAMsmvpnDPJypy8RuWNPArs8ss8xx0EE84J2oc=;
        b=jcslAXzwVCp3wd3zoKXwuubQXMEUt5/+fwXoLoIWsyV0V1diKHm9mUCk8KGipTSHYJ
         laXXHFrnvDpDtsOoAO022VbBDbGKK0cd26BExuUUOF7ZJ9xxdQJrhidaa1ZzeQ6ps5Sp
         AYn3dcf1ZsNyTjgaghiMOgWbMenloK/fTk3KbU85vzNiuZHa7XHDI9/bexLMzXcPKoyT
         boEIy6j//YhH78BqFLr9sBsUwgLYCKrAHKkphWihJ136aY5JZZzZA3d7JZ9o+lMXnRjn
         RVUYJ7xIQQXDMy5xbbb8baWACsc+2ox4UC99fUDSuKCNeBx5ei9cu3gE1WnfhXr/pJ9q
         fahQ==
X-Gm-Message-State: AOJu0YyxZ32xZLFJ6VVsptuNFn2xHaku2h6YYrn90hZWFGBwkwyO+2Hd
	NQJvUnp7dqQjKOip8dlosEyvh56eCwWVQqJsJ4kLO1VyYMK9JACauDSTQbiyGQ==
X-Gm-Gg: ASbGncvbp5FSPmS3OkPgRO/YT6FtkbcrYpLrWNS7jh/xiyQqZt7nO9QBWm+gCRNeCYM
	yoYaEFXPz3zOB33tfV+ALsMHUtroC8JvZBavMXun0WDWHcMzYE3JmikwrCXI6EYehTaHahsDnhF
	3vzHHU2S31zrvqt4a5jHoolydvSjbnVl2PvzYwTshBfqUibTUZH88DaLMxbNnE/VexgnAgRK0cx
	5o1xMweiN4XnSP7MYGbBOY1ZDrSwv7IyTTXWevBTGEwwooquX7RZn72b8KsEWhv9h8D4nm8iIIj
	bm3IDvgWHNS0F5Icfywj2miwoTbSWmXAucjHMp24fXg+xu5o7o/I6crXhtNS2RTIQ8kyukrktBR
	jJC7UCy0Od4bTk40mqt/MKgcWMso/IDFpAxpyzHLmVSaF5DD3Uo9zlw==
X-Google-Smtp-Source: AGHT+IHba2WCf4ULzfzT96OFbGRW5hX0jYX6go5DXCzBh5B4HyqF6qJTJeBbjky+6wZFkd4r/CCdiw==
X-Received: by 2002:a17:90b:3e8b:b0:329:d50e:2f10 with SMTP id 98e67ed59e1d1-329d51d739emr9569298a91.22.1756923552715;
        Wed, 03 Sep 2025 11:19:12 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4cd38610edsm14886181a12.54.2025.09.03.11.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 11:19:11 -0700 (PDT)
Date: Wed, 3 Sep 2025 11:19:09 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: tag kernel stack pages
Message-ID: <aLiGnSHFJdaTpMc-@fedora>
References: <20250820202029.1909925-1-vishal.moola@gmail.com>
 <ea48bc1f-7ee7-48b4-b389-c3622fc4d3d1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea48bc1f-7ee7-48b4-b389-c3622fc4d3d1@redhat.com>
X-Rspamd-Queue-Id: E7E3E180011
X-Rspam-User: 
X-Stat-Signature: iohbkwndjsks3w996ubm1xx5akhykxr9
X-Rspamd-Server: rspam09
X-HE-Tag: 1756923553-290494
X-HE-Meta: U2FsdGVkX19mVoMZAby0jiU815hNCtJI+Wko1EAcproAOZGKfXFOx8vrkx6E99PrV2DX4ZuK7z6VJ/yRl11RneEUet7acGrd50w8G8zGaPqtwwr8HMxIF++IbKyEZee0Nuap3WvftwMPi/u+OZYtX3caZqn/TJZb4udZK0WNqmHB3kwmBVaFoWlA2rg2UUysYxoZniZdbbRGJV3EQt4OfTZEt/kRbD20h7Ubddc9+uusAwxEc7ysVwMjrxQkrB7o9Jms6+GtcJ6enbFE38LaZFxQ4q3XWkfWi0STLqDmkq0O0MpwlbPajz4PxfB0ZuBr4bugYVPF5AWZezxc01ZmyU33TudnptcctzmdPQxbqdQ1vlIJdr0M4ONprh++NflRUQpQCw/aziJ6MGUDq6qH6fXDR1nHvHRFjEjyo0ZkCSXvrT+aDqgXxwZOvrcRJKvhxh1IZWk3zr7e7SPfwrgx9d+6qywnax6LOeRCmCUdZSFbHT62TcYnugqhTeG7RgcVDbX2hOT3gXF1GYRWjGAKRZv2Bp1Wnl6jiIDVBp2hi3N89Hjw1jo/+xfJx/43wIAKBNrxFqdy3gPGJ8YYgXzJsWMcP0gwq6ccNbYwNKEJq5/SrOk2Fm+gdNcvaUEDDImEasNH/X4epDYlhhnNah+beQGV/fDCD4cuwgDo0MxasTUPX0whFNoWKK4Usn6f59mvVCPZHWMrq6pZR/6ODtvaVFj34W/b2LKmnxIKCWz2bXdA+ObpHrhxlFdtzbXQ2rNSGzO99bGsvUV/uOpWZhCACf+ub9/x5yc650JON4b3lZmbFn+SzeBCRMgJlAQb9qUq27ucw9vhZt49JfRVlh0FdqVWDKHFq0eGxzE7C0KFacYUVwrrT3TACktjdQvDs5+clBAbd4rw00VUjvbM4lpIvnOCqqYTEmDwdEpqOWFXuI+VsJzNxIt9SYXvt6MHfUGMX1KV/7SZ71Xr1Q4/Gxx
 RK/6eG3O
 4xVvAdys9YdDYajz6B7UYtG5Lm3RLrO5KQpA3I8Cex1jv6/tteabonAIRgDOFZ5KfxcsSccUVXClt5jm3fmXm5nhacqsIWhF8pUvamvxHxo+4GIUJfzIJuZXxKIsZ+DP4zYmkJz2xJl8nmCoVE6EpARUwUULlOexv7KlEZZ28uJ14ZC8guamGU+WLrDs5DSvXqpNmKRR4ppVbDewNxzLVb/YuNH/A/sO53FRxQLsX5GYALnSzE3xyIA/jRyJj38yqY5HrJTCBo6EivI9eKV/ZExKbF76LaA2eZan8al/JIpXXmUfR0CEguTu2fAZrPAG2wGOhXdvjP1VTGjfX04FQL28xNe19uuQ3BPU1/qmUMKmmLbQ2okXp0IUGgM0UUEmssFkFSJTXkpIxMzjdr7PmLpIfccJN2hGKcwmf7JrIFyGVv3Yl15RkzLIGr6YYN/OlVPYxEmkQRNxyaol3LRQ2wkqqdzkWz9UjrywMjTim77ipLWfo2/ChvFIFk1opbfCir0TUh6lA0N8Bc9WJsHYxDOT5E5KPyNRAgC8UyR2XkIIXx0s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 09:49:06AM +0200, David Hildenbrand wrote:
> [resending my original mail because it might have landed in the spam folder]

Ah, indeed the original mail was found in my spam folder. Thanks for
resending.

> On 20.08.25 22:20, Vishal Moola (Oracle) wrote:
> > Currently, we have no way to distinguish a kernel stack page from an
> > unidentified page. Being able to track this information can be
> > beneficial for optimizing kernel memory usage (i.e. analyzing
> > fragmentation, location etc.). Knowing a page is being used for a kernel
> > stack gives us more insight about pages that are certainly immovable and
> > important to kernel functionality.
> 
> It's a very niche use case. Anything that's not clearly a folio or a
> special movable_ops page is certainly immovable. So we can identify
> pretty reliable what's movable and what's not.
> 
> Happy to learn how you would want to use that knowledge to reduce
> fragmentation. 🙂
> 
> So this reads a bit hand-wavy.

My thoughts align with Matthew's response. If we decide "This doesn't add
enough value to merge it upstream" thats fine by me.

Otherwise if we think this is useful, I can respin this with your
suggestion below.

> But I wonder, if this should actually go to the actual place where we
> alloc/free.
> 
> Now that it's no longer required to clear page types when freeing,
> alloc_thread_stack_node() might be a better place to set it, and to
> leave it set until freed.

I think this would be a better place to implement it as well.

> I'll leave Willy whether we actually want this type, cannot spot it
> under [1], but if we have sufficient types available, why not.
> 
> BUT
> 
> staring at [1], we allocate from vmalloc, so I would assume that these
> will be vmalloc-typed pages in the future and we cannot change the type
> later.
> 
> 
> [1] https://kernelnewbies.org/MatthewWilcox/Memdescs
> 
> 
> -- 
> Cheers
> 
> David / dhildenb
> 

