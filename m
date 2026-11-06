Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54169606D804
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 15:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hNmDLPIP
Received: by kanga.kvack.org (Postfix)
	id 621A36B05B2; Fri,  6 Nov 2026 10:26:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1A96B05B8; Fri,  6 Nov 2026 10:26:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C05E6B05B9; Fri,  6 Nov 2026 10:26:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9276B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:26:41 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96CC7804E3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:26:40 +0000 (UTC)
X-FDA: 85405071360.01.C51584E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id C519B100009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:26:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hNmDLPIP;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793978799;
	b=3V4XRbHVRWBTBnMDU+F8h+23EuWAKWe0H9BNQK027gZY4dzJCd/p6vpix9zgZHPwBrcHPK
	QCDu6KK0j6t1rqUvXH+pd8+3u5ePnKGbZ8QqIRr7urrClYsvwWdEnzmTt+NXWA/vMxU1Zy
	NzLroM5pq9365qQQNLh098RJCJWsVuA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hNmDLPIP;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793978799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFRk93kVwDnKUZB/pcB0eF0UozOQGGbpKAYRpLOWGWw=;
	b=iqLRjp3q/awMX30W4FsEcgPKxeS0zEw2pRWxzRVuTeJFOF2anVpBeFdIvnEj5woTgPurq1
	cuZuS3tzrJF3JMLkBJfyb6chgO4t1DIODzc82s/yF5dMZfxFDt5fOADXWdq8UorTh1exVu
	nBUPVRa1sER008kk18gbZOkj+Zjr6RY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DD844086E;
	Fri,  6 Nov 2026 15:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3EA1F008A4;
	Fri,  6 Nov 2026 15:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793978797;
	bh=NFRk93kVwDnKUZB/pcB0eF0UozOQGGbpKAYRpLOWGWw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hNmDLPIPCIvMSZn0FOQJtTkkZXYaqyFnlZNSYPuCKTcNHe51SqoKWL3VMdVHTVsM7
	 K9HIuP0ELk+KrsbSxnuHYQ2Ka8ZGcjchQ6Uxijf+zNY+KstKz0upt/iNNUPs6A4lbN
	 cpGjgUjU6ke1JlbVlOQ8kyyZm4LV2/eGZZyLR2rs=
Date: Fri, 6 Nov 2026 07:26:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Ge <hao.ge@linux.dev>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Suren Baghdasaryan
 <surenb@google.com>, oe-kbuild-all@lists.linux.dev, Linux Memory Management
 List <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v5 2/5] alloc_tag: Introduce IOCTLs to toggle allocation
 tracepoints
Message-Id: <20261106072636.524e8f0a6a618e7b28988273@linux-foundation.org>
In-Reply-To: <9a4323e1-a966-41fe-8268-9d6621346fea@linux.dev>
References: <37ae7dca766994d3872fcc65b623a80d5d506369.1793818636.git.abhishekbapat@google.com>
	<202611052344.mDV2DB89-lkp@intel.com>
	<20261105172104.339c6f598a65056ed46e56fc@linux-foundation.org>
	<9a4323e1-a966-41fe-8268-9d6621346fea@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fasp7zgxfsriwrcmo8e8asxm3eqx485g
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C519B100009
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793978798-699139
X-HE-Meta: U2FsdGVkX18TP7Acv7zyLqXiPHBc2YCFvQVhq3OtkwYSsK4UfTpyRU3xXXR9tZwoflZsm9mGxIy+c7hyACw+SlHJIjqSHFr1Se4TiyQSefNfYrECh3R8NzwXa/OF7uyCApKhH+HETvuOOZhAUTXR+NPFKmN+szdMHFf8LymblxT2dfhUEQwRUsb6AvB92GiMJT8f41wyrKyaVG9pyZR3LiVjZQa8TWuLMfpzq+dMlXzb6QZ6fHMLrjhfbGLifKm+ravJltIRF0C01scdQRJUVqqYoAHqyUzLCfrVhRxDNyN+y8eQyo9y+hUoaIXeVP4xLe6PRoblvQGrG3AOgtmYXmgvO0MdTy7wvK0Adqrkb6hmlaI0IS2kd1qqI4AVAtVKXoUAX+oHVTsWbpbFwyhXuU8Szf53Dh4DDK2cxO1yD0rUwJHvAHjZMYPEZFKBpaL4AC8jHiIzowsFaGc9nhLnB478XNo+YKcfWKur+do8NkdBOybJAX/RvVbUTCQQdNq105B2YLrWB2i4vx6kDmiGT1pOvHQvGzlhvH1/ulXXaeskDelaIIj/cEz4ltqrM30hf9evMB9du95UOaDM3pswjEBbbC5Arma05Vu8vCK8HsVZe+HZTX69mTQKja00JVCIYpp70ytcmNKLkQqkr/Xt1liXIp8Ep+eG86Vbcym8qwgDOimRFUX9oxCpYlxXZrr+xfsQVLeMkEKU1vz8zvdpR5MZ+hh3hiAwRx9EeOqN4yIuW6Gq+Yz0nqRAEUj3ioe9FW6xDNEwHvWOjEN7asSmqLkQCuMfJY6KjtwkYpJm6k5z4y3fe9bO1SrrvjNmFT9G7dlVCPNXBXUMSzy22uGfT6zRL1Azewyt0Hb1E+pNQpF+AuVLR/N8TbLwprg2YE8UXy7TuHI1FwvU6Nwm3Y3JW7v52lrtCLtYHGeyX4BmSzYzgGVgVy4SMZAb39BeRHp16NUpm9ls5fVxcetfHyD
 w0pj2CjY
 i21CvXBQ9eE9HvitNxhTYg0htJSySurfIP4f2ZJIy9OBsUac2Pei64kC+GeQWTLXKGvyebnmOL5HVFU2/H6pGuKi7un3bUgxyLAw2ssoh7gz2lAaS1/o9RxJ/vW/c8vTKdIbE1tQaqzfUfivJ9PV2pZ+noi9wlQQHEbixw21+bnggG7Hnr9eC7LZGa9LmkcIDqJoSrAf3luMW+JlEcZUa0KSSi0AOJ8YHGckLJY64R83f9AuuXFisDUYIuRwmX+eilCmf5Eivn4bOjyDmsnDIqeC8GZfiANr2nvR//lpvAsB1xb0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 6 Nov 2026 15:54:33 +0800 Hao Ge <hao.ge@linux.dev> wrote:

> >  
> > -static inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag)
> > +static __always_inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag)
> >  {
> >  	if (static_branch_unlikely(&alloc_tag_trace_key))
> >  		return tag && alloc_tag_is_traced(tag);
> > _
> > 
> 
> 
> Thanks a lot for looking at this - and for putting together a fix at all.
> 
> Perhaps alloc_tag_is_traced needs the same treatment as well?
> 
> Even with your patch applied, I still hit the warning, just attributed to a different symbol:
> 
> WARNING: modpost: vmlinux: section mismatch in reference:
> alloc_tag_is_traced+0x10 (section: .text.unlikely) -> initcall_level_names (section: .init.data)
> 
> Marking both helpers __always_inline clears the warning in my build, and it would fit what the series
> intends for the fast path anyway.

Great, thanks, I added another -fix on top:

--- a/include/linux/alloc_tag.h~alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix
+++ a/include/linux/alloc_tag.h
@@ -156,7 +156,7 @@ static inline void alloc_tag_clear_trace
 	atomic_andnot(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
 }
 
-static inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
+static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
 {
 	return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_TRACE_ON);
 }
_


