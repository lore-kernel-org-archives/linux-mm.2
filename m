Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C4AEC531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C4CF6B00A7; Sat, 25 Jul 2026 17:48:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64DDF6B00A9; Sat, 25 Jul 2026 17:48:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2356B00AB; Sat, 25 Jul 2026 17:48:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 239ED6B00A7
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:48:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 912701C07BC
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:48:38 +0000 (UTC)
X-FDA: 85028638716.07.190742E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id D3C04C0004
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:48:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Q5tlCJp+;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785016117;
	b=7Y4ecjuZ3Oj+NC4i7naFlXxyeU1q65QAsmEcBSRJY2Kpbx2ZYhwAGltrgI3oMIAw6wAsWr
	rLoyYNxTYn9bez01/6NNess81LDQdKsICoxPw4qz6daUuqK4aqdUxDZmswxSPjFenngQh9
	xyZB/C256mclrZgwAHw/7qjYS/Y4WVc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Q5tlCJp+;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785016117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gIBRr+eBTgXMBBErT9R9Qg8c/kYBgNwObuWPPZqXvs8=;
	b=lpmpqzvqj8Qqsqw7IaEiJc4VAg2xSMgsZRQQ7piywFjLuI87T7r/bwrM3xE6eLdXU6i13H
	UkIghZJtM/r+DIEEg4CtiuuctH+/FusN3yxNCtuZUtViYnNIFRf/fRCSGDJYdfayrm8Lrl
	JX/x+YDem+4E7eabYMluTMolMz+Lsuk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D41434182D;
	Sat, 25 Jul 2026 21:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949C41F000E9;
	Sat, 25 Jul 2026 21:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785016115;
	bh=gIBRr+eBTgXMBBErT9R9Qg8c/kYBgNwObuWPPZqXvs8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Q5tlCJp+5kuvY8cf4kWXUs0ywqiXTM00bNoINk9L7CfTK+LqKuTIO70qsQz5IE5hP
	 KEM81/NBfIpRsjhozaJ2js6/6U1rIr9GFGEDrHFPBRa/e8zgZC4F5yGxnVHBaLPnYg
	 yMAEidr703Tt5V+55KBOrapa6Nm+LUS4HcsAzT3U=
Date: Sat, 25 Jul 2026 14:48:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Lytkin <iprintercanon@gmail.com>
Cc: linux-mm@kvack.org, urezki@gmail.com, shivamkalra98@zohomail.in,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/vmalloc: fix 32-bit truncation of the area size
 in vread_iter()
Message-Id: <20260725144834.76cd9aa557e72aa02688948f@linux-foundation.org>
In-Reply-To: <20260725132201.88279-1-iprintercanon@gmail.com>
References: <20260725132201.88279-1-iprintercanon@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D3C04C0004
X-Stat-Signature: np4kq39jbf1bqogrf1be1sek4atundnc
X-Rspam-User: 
X-HE-Tag: 1785016116-718112
X-HE-Meta: U2FsdGVkX1/49X6+JCGBj7opRc8MWU5SYnfHTkBWzDpMkoxeGGrYPlkP2yJgALrRXuaWlPbz53/Cugfc9mzipT6JPic5aHGfMfKzljlrF3lInQ6LQswiNjQxtBO+mlI6BGgwxEuEy3adb28nZ/Ry/4X2eYkGcilwZV18HwWT/O/GI+ZPyXoIuW/bK8fumqkHEIxIxHvaLoKcgphUahoovZx8zfJ7mOoABFuUbIsyknicz1XiGlteE4k/wbv4jFs6ohAChsqb38mjJozKOgKcI0ehNzwAP5gtfvPDFxkEr5KKmWdphruaN+WA+hrdGef7Q8+HbkHfe37+fUU1/bnGLMj3rhudfZ1Lylb7ykBFlod3sMc7CNXbNeO4rnFGeG2QQSXxLoNbRb9ylUBD3VApVCeqqMuKPoMf9nyJrjBa6JYhtHcJC09VEJHGY8ik1yuyrz9uAYTASBz8Rbpmjolus77xCKe/YGFeP+FLF67tJ3/hNWn6g/Nst/JSY6OXKXOwcksv5tsK/Z1rspiD+hL36DsO44rU+txnab19I1BxcfJRIzJAyQ6ev0zygFhjL0Isy+gJdrdNAUb2V7o8/EGy6J9OeJ8uu1chcikEpuomRmgIrw9DAP5HQRZn+xEwduBTYRWEbOEN9GbiDFL5TFF+lgKAYljLfZDNXAHfNFvAFDjPTsD/lE7fjSmb+YLxGXcI4X5wtFUkd5C1F4q8ptr9RcT+mvSKjfhBPwUOKhZi3d7DqpmrZ3S3EcHRPczMlmvqp4y8T1lSvRA5QnjKb14Bt4Hn/tgSIxUyAf2ANOyT3c6CGrEAe4WJQlQSQhcr1y5yYwqbz+1fjQTXSMpj2J2THxw8yTwgbsPJVQvnyRdwTf2IMNuQi2LriYpNTjIva3GPt6bSUOvPjzA7v9012pEXbNnjVgdRB3bqKmJmZWLHZAcvEdwS22bt6fkpS+VtynIaPhdaIBBXFlDV3E494kn
 vQWSxISI
 XLMUUDht7PNRDammfIRRoix/MjG7hJNKtcapWNdPVoAMhf9uYAA78Dc1MGbX+WX2hBLi9k2+QDECB/aFWZ/1CPekIxADH2cmhFUYl1vQqQ8A0evuEmgkjN2ELRTbxICebhL2UnLhT++izNngo2yzToSNt8/ZFfhuY5JMtaRQK4SevaS96R3j1+u0wDNd+b/yCKX/3T97DrcffoYJMxdA0rH1QzzbQyjko6lNWLDjHcTcI0KzaA1HtI8vA4V+8LCnUkIiWWXNiT1koyUZJxgEaqSvrUJbwY76i6Jpggjh0sEuJSvY03+OhuJ447xBxMNabPPVHgRTZCvySYQhnAb5loxxdXPZmaFNmo/zQH+eujKfZYFSajxqd3kDSrilihDget4US
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Jul 2026 16:22:00 +0300 Artem Lytkin <iprintercanon@gmail.com> wrote:

> Commit 0bca23804632 ("mm/vmalloc: use physical page count in
> vread_iter() for VM_ALLOC areas") replaced get_vm_area_size(vm), which
> returns a size_t, with vm->nr_pages << PAGE_SHIFT.
> 
> struct vm_struct::nr_pages is an unsigned int. The shift operator does
> not perform the usual arithmetic conversions: the integer promotions are
> applied to each operand and the type of the result is that of the
> promoted left operand. The expression is therefore evaluated in 32-bit
> arithmetic no matter how PAGE_SHIFT is typed, and no matter that the
> result is assigned to a size_t. Once an area reaches 4 GiB the byte
> count wraps, at 1 << 20 pages with 4 KiB pages, 1 << 18 with 16 KiB and
> 1 << 16 with 64 KiB.
> 
> ...
> 
> Fix it by widening the shift, which also makes the expression consistent
> with the four (unsigned long)nr_pages << PAGE_SHIFT expressions in
> vrealloc_node_align_noprof().
> 
> On 32-bit a widening cast cannot help, size_t being 32 bits there as
> well, but a 4 GiB vmalloc area is not reachable on 32-bit either. On
> 64-bit the cast removes the truncation entirely, which is why replacing
> get_vm_area_size() introduced a regression rather than inheriting a
> pre-existing wart.
> 

Thanks.  AI review might have found a few things.  Most are
pre-existing but they are basically "more of the same thing", so you
may choose to address them?

	https://sashiko.dev/#/patchset/20260725132201.88279-1-iprintercanon@gmail.com

I wonder how much of this stuff would go away if we were to make
vm_struct.nr_pages an unsigned long?  It's already using 64 bits in the
CONFIG_HAVE_ARCH_HUGE_VMALLOC=n case.

