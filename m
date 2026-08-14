Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69088C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 23:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336086B0718; Fri, 14 Aug 2026 19:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30EF56B0719; Fri, 14 Aug 2026 19:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FE1F6B071A; Fri, 14 Aug 2026 19:07:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDE3C6B0718
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:07:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 291421C03A8
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:29:12 +0000 (UTC)
X-FDA: 85101316944.08.733F9D6
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5B01C4000C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:29:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="jnqBRO/X";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786746550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TH6TctMVaQF6gy1nv/R6PLK5AFOqk/3NC/Hbg6K2tj0=;
	b=h98MmR0QWHuufrHg7IG7aZs0vHEUYmS1GFq0IA8tT+7jT1vVVbxYuU2Sw3MZ00Xhk2VUp/
	QpSCKVVftOGTRPQmi+7Ntk3b7S3QHnqw15kZgI/HVwUizrRW4zWTF94msAHIUYi+pf1V+z
	Jw2Ro/g0yYgmgOlTTXJZWBuK4rju4aE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="jnqBRO/X";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786746550;
	b=RgkBrNJvuwpSghuFyiY8eaVBSWm1t0AtRoQeVp0sCCo5TizhNN455k5XbzqgMZmf8xYYqJ
	7oFoUz361xxgJ9/wrZbzcjWqnX7b41mEzgXT6rJjpgFXfs0hYK9Rl6KvX3AgL/jbKwIqx/
	Czc9GahRCp3o5m5WmMCNeWTsLLFGzos=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38deea72eebso1624387a91.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786746549; x=1787351349; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=TH6TctMVaQF6gy1nv/R6PLK5AFOqk/3NC/Hbg6K2tj0=;
        b=jnqBRO/X8LqPWHicJj6om0oKtl9uPUsDI/M7Yo8XraiLvFJlFf/zhBge6Yz6COg9w9
         T1xery6sBoNKHdclRUQ/6l0Kz+k0eOUo329T6rrH8dZ0KopOt+oMqwB9PYC/CqJJgv5k
         KAJBWqKkTorixnG14S4Hw0Jw5YNLmmDpMRdzr1QZLbW+SEWsxby5t951KXDsek1YWam6
         ehjkxInnFWSp3QXF8NffuNio6NGFlBNEDl/8QYcc5A2EgRJ+au65lJ1e0Bq2XDWSDTLL
         MO4BHacKeFnRIQtiQFEXFTrYL2w6Q2uyyeDuITGHD+6/6zY1Aw0KEl+f60brD7Cs5/DS
         et3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786746549; x=1787351349;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TH6TctMVaQF6gy1nv/R6PLK5AFOqk/3NC/Hbg6K2tj0=;
        b=Kx/lKp+8UBsfkC5POWW5MEx4i1tp/NjvlzxFgfdT+6epNDDQGxKSTah2hlZErgCZ3d
         sstOquuaujg4PPcA91oC/xO2cV25bduz6MwztoB7o4cJoy3P9FDZo3XBmh3OKnFPg0n/
         tJ8dhdJChCj6ctLSMoFmrhlkFuE5WM7GAZDrVUh3KU9brQbTnhblyHL8VPYA2NuEbxhN
         BGkyIRXAgrbucTyoAOXZMzXl7Q+ACMbrUYCgptO/4nECwjQQ/DgV6R1OGbBL7khvLCpx
         iuun4MxyFSHEyQ8+2rh3YjRgA9vP/VCokV4LTKcHxBBo7bMAtUDS/NVA/RcXfJoWH4O0
         S5iA==
X-Gm-Message-State: AOJu0YybVDo3caCAnzS0AaC9i5oFhX8Hsb0R3nIhgIWIDrfFri36EHc5
	eZK8b4xSWFGE8ctricpAnWWhXPG6yjMuOxBtJBDxLZozNhdPzJ4GffhV
X-Gm-Gg: AR+sD12prKt6f7YZmx4fVEkByqgO1Fas8wh5iD7k4XDP+aJH1gKLr4aWXqstqNFgOTR
	HPS+Jh1P0KXw9uu1KVGLWN+7QUAodSS9hglTiBfZVjrlHgaKlKlay0Oo+bwmFx0sveP6u8daB1O
	nieYmPmP6atE9UUdZ5VznHkoyDvCcnUrjizKxn9JwgmyiNj390L3hOSStmEPiaHPXjgUSyfaQVJ
	/KZ/V9F2m1gTNRxIZt07n3Ktl5yUwHDKnOJJj9YGA+kDfI+8YahQ7JvoHPKo/mDBS1C4r/Ybj5q
	TSDkjwTUkstGA8AV0B45mcCP7xIYRjWWsoFStLDpUeJZa1vZOy0BFZMoOz7bkg9Pwnm4jxWOoJW
	e4GRvimM5nkgACMWqCFj7UFSIq9e6BebdP12WjqyHALaDwkIOb3nPeLVvUNFiKUa3E9yH3us+8a
	NJ6OrINpMhH7IVenQoNSBqR8sJG7RV2tmI8OgD9hJvZT9v3vJG8WiJiSaRBW6GxtHhtlJXK00Sx
	i4fweHTL0cwDrHb25J4ManJRIL923GzSwMiXTuB1dEigLd8tTtgtrcU/VSHXE3yEGNhW9DYA4Mn
	RrldBLnCl4oqQG5MdA==
X-Received: by 2002:a17:90b:4d08:b0:37f:c22a:c188 with SMTP id 98e67ed59e1d1-3933b6f0622mr9625496a91.4.1786746547453;
        Fri, 14 Aug 2026 15:29:07 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394f818030asm1031982a91.3.2026.08.14.15.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 15:29:06 -0700 (PDT)
Date: Sat, 15 Aug 2026 07:29:04 +0900
Message-ID: <m2zeyopc9b.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: ljs@kernel.org
Cc: linux-mm@kvack.org,
	geert@linux-m68k.org,
	daniel@thingy.jp,
	akpm@linux-foundation.org,
	liam@infradead.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de
Subject: Re: [RFC PATCH 2/6] mm: nommu: use vma_is_anonymous() to check if vmas are anonymous
In-Reply-To: <an8Bdv54k2B1o1c2@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
	<20260813063401.1786548-3-thehajime@gmail.com>
	<an8Bdv54k2B1o1c2@lucifer>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: jaxnpqetpkgfpusztb3su9yyuzfqoust
X-Rspamd-Queue-Id: 5B01C4000C
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786746550-891200
X-HE-Meta: U2FsdGVkX1/rn70acQhdInKvvjmJgNO+U6js1k+vN7184ayVAlGqoyVeeb+xR91kAZ6pzb6Qrdd0XpqqvqYVaTt4NcjanssobuwL34InMspcvHsyAsEsf+u/K1varUT9fYzHZ8WYCXYqq42bS/DxhkHObWAEl2hZjS3RA5swSLQpSxVLmHH6XIX3e6EmBPUQHb/d+yoRWQFEYAVaJ8zJNoFIAgQSGtizXoJCiNlXY3wUHfkB+tEebOJeFCSp07Et8zhYxM74rEqe3V3GyX2iy0ZZ59GyQua9UGHiw8wQchrkdfDpQWjDClbCHRGfgYz3aN2IRTo7vsB7geI9G066oi2RtlsG6I8dpHqV6efBo9ppqonPFgr461dfCVCbmi4WQwCOp83eGw5UHUI1EiiveacdOhVHTKl1MOyDpuIN2qInrF8dTN2cTNHrVucD11SvxZvy8zDrR51jEE9Carh5w6tguAS+8osH8wdDm8JovdlqrD0xsetQzVeaoBBJzIOx5t0x3hNUz/3NXrn/tpttr5oBVgH6T7ODV3CeWfRMgR8HddiAakx4shoceP9Q1Rh8B5JYeBktqiE6Yvt8lXVUETxbEApNKj2l0t3Hh90UGhR1CNEKr/3UXN88dvY2mJXczsDhXpzKcLQmJig6l6MdsTJ6v9l5soZf7EZYM+VRYLaCKvJGjrCDnmsGyYjLq0QxOaRxxI5ZGDYn/jKTJ9I8HhaoisnDWRg9Cc6NU2ePy7TxN2FQEc9XWPbJtYYWisRjPDzwMXWV7L8hkws/JOVVvIzNyuy4hPeU4EyOPAuIJQ3ygkJQn+vVKj5bYeu2t7WQ6i4Jrn9svJR3blcPJni5OPmsrj4hQ6Y7nQ8p6x+YB4ZjcFeCoPEXKXTIuxZGu40i1HLJSZpL9x/+WijtUZ/87iGb/EX9a58vMokvmgxzAWYuILmAwBZ7kfIMLqLWP5w8Z1NXSKlj4Vct94EKCw6
 qoLlzcGa
 xtMRD578CwuGdA6lFtyQGkPYOUQZK5RM/QcyrKFEuzkmw63pZMemC9y+Fc1cggspUkRhVSFbwfP5Gjrkkbe6W6UXhzDvutmWkgk/Ej8MF3oeT7Sz8j5c3Txhr2v8TdPGQPhD7FbcIH1dtJhM5aW0IagMX2EdLB3x1wTfMVk+GchJb3RYFVERBgSd0f7ZXkt75KcZ9YXcYHDOL7rdGFor2cHvPfo22Yy3+Or51r2aimoQ5R4EzUuDMWwcUd+XlUl8iBoMuyqpJ+LETkSWIRNOROXbNgxQ1JOSQkGcLvFTlbJpcGRWnVZX44OCTCPwV1ZQXRRolafc1LOa56P60/33x/CDhwZxeoavrXjKlA0eh+UD3pKw0YxMG/Ujeb5G8ojv0kfKa1c2HcjtoHECoKpBzjTaufw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, 14 Aug 2026 20:52:42 +0900,
Lorenzo Stoakes (ARM) wrote:
> 
> On Thu, Aug 13, 2026 at 03:33:57PM +0900, Hajime Tazaki wrote:
> > Private file mappings (like those from /dev/zero) can have vma->vm_file
> > set but remain structurally anonymous since they lack vm_ops. Testing
> > vma->vm_file instead of vma_is_anonymous(vma) might cause mremap to
> > return a spurious -EINVAL when userspace attempts to shrink these
> > mappings.
> >
> > This commit fixes this issue by using vma_is_anonymous() instead of
> > testing vma->vm_file to address the case of /dev/zero.
(snip)
> 
> As staged in review on 1/6 you need to squash this somehow.

I see, thanks for point this out.

-- Hajime

