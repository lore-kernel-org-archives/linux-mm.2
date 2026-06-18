Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A647DCD98F9
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0E866B0092; Thu, 18 Jun 2026 08:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BFAA6B0096; Thu, 18 Jun 2026 08:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D5206B0098; Thu, 18 Jun 2026 08:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6BD6B0092
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:21:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6FA9D90D60
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:06:19 +0000 (UTC)
X-FDA: 84892754478.12.4C2B046
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9CAB0A0015
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:06:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SrtKdbks;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781780777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FWN+yF7/uh3OZ1VQ28W2YBxdxjoCELSQ1hyGvrXn09E=;
	b=aNf8ymNFPagNyIW8wlH6Uy7EDBHqeQCZRYW0S7T7QiGPci44X/dPghKqsNQ9xz/gd/cjN+
	Ft2P1GKYjKoFmb9ZcM+hiwnfXMkN/ryOx4C2tYBLw9Ne1WZPBW7VbmBs6tzzIbsIzfGD22
	zRFKNZEXrnbuNO4nUDDWMBrNLdj2wpE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SrtKdbks;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781780777;
	b=KSrfOlmL2uBem/LOs8lFUA6kCB0I0IbSVRvRTgH27Fi1eB+ViIA8YsbkgFrPXQ1roTmF9x
	+TANKYVsB4ZsPh2NIwqKAmnaOCNhdsd6a8TW+END5EmsZ3xbEUzg26+7m+CYAV3evjKopu
	ENy3YjxBpwnc/fasL+vTv15Ebj2NPXA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 26E194417B;
	Thu, 18 Jun 2026 11:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426721F000E9;
	Thu, 18 Jun 2026 11:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781780776;
	bh=FWN+yF7/uh3OZ1VQ28W2YBxdxjoCELSQ1hyGvrXn09E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SrtKdbksQhvrfHQfqGxSbNH3SxtUMloo9Wlx4hOLZdllpEMY+HhXEJ25ZP9cJKisT
	 pwCceL2lBYC6p+HT5ciYW6yrLRe5DafDMaMx0L44dNAG6UjY1RAf1RrozvJEGocc2g
	 /FszeToSWsIq2p0dhRr7KmMrefsfyztAbXF2gUTB6efTRVVK/Yz6sOcdli8YPt6YHd
	 um3+I0OaTOYKl+msXONpqB8CP6qBy+fT6hKOmDWi9uADtrGrp4THrIwMv/j/ltu1Iq
	 zRiBlo5UvskNPYcBNo2wH8QQYLk8fmnTs6u8KDa6Dk49rjNyeRMdboYjJNdqQqF/vI
	 rBTFXhWyiCQ+g==
Message-ID: <0689b495-2662-470d-a20c-9610c5eaa7f3@kernel.org>
Date: Thu, 18 Jun 2026 13:06:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] userfaultfd: prevent registration of special VMAs
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Oleg Nesterov <oleg@redhat.com>, Peter Xu <peterx@redhat.com>,
 vova tokarev <vladimirelitokarev@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20260618095017.2553004-1-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260618095017.2553004-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9CAB0A0015
X-Stat-Signature: qjinp936o57ypcgzngfxxuzus7kro6tj
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781780777-884776
X-HE-Meta: U2FsdGVkX18ZOH86eeWwV3SGLe/yXP4rf3B1CnHuj96SAwGcWOVnlm9PXX7tK0NxTSum+PkPIzl2h1BOP1cstm/BYEXRU7hhNsTJTfKpXldD4B/KWiMQkqCAFoWeSzTNymJF67w5nJ8jJIb2ej+V4i/zoi/CSrS8JRm2xj9Kpgdp0DPAb5KPAQa11J5lBPzjKvM6mURFg/Yw2VHVdEBawA74VL9Ojh7CDaKKz1+ppt4OoKI0xvxlpZy2yakVjgNOow1mtQGzftAI7aXEGRlQaqvTQr3Oq9Z/eiCefvQPr52XzCX1wS1BRZfTL9FkD2nK/qBBSKQ5F1gqJfuJpCQogqUTXcPFiNhCXIuvp6UuRnezD4LDYfVZlW6ThcuTtWxpVrkz0e1iBO24REuwmE+A3vkpcam/pdfTi2Q+LS+JpG5RsZGe21AtpIj3bWasquiMrrNogusBCU+9IEKiHhJrv+/9q78O3IosMJ3yRHxnNGVjlDQsWF9O9EPErBYnGLzmvnnHhyiQsNcTS17oskw1BCxV9h3GQTSHVItu76T7+izVYB5Qa7spdgP+RIbiJWTxmtFNn5R9F/nJxeNwRB15ljwwFR0SoNo/ogoZnrRh9oeQ3VAhlk+/Kx75U/nqrLWRkXqPBDKCt/VX6qsn9nlqxf4QjpsfAkWyvcykRi09re7bEs3pKpK3p4+AZoq5Mh5T/zS5eHYWBsR6WWSfts/R2borHChsBfEF7Gi7zAR6+SUdT0VLU0SsXJ8u5SWKUWOjPDclHZspIRKbQl2rglr2t0DzzSwO7P4JJO3Wt1cyuYigAKdzEit5ZXn9LTI8irDIoE2xP76lx72oNZoUL5PMVZViH0e45qN3BXxR/8uUYHtx6EKzAciBc62/8fuPmcnjFxcmxvil5UKQ/5k5gV3NspW7/35lQWeYf5Mvhtbj2Kh2l6M5S8CU7phtZTISlWoVw9pyc8Ik0x0AFx6DTG6
 tuiYV+aw
 y6LcI+IiN62ppEBtzqQSg3/zLwwq3iBqQFASw7jkxuMWGPH9aAksX08o4Lq44l6nvSB29RO8kEWMXZES3i/wU2a32UL/ipdKJWWXzNU+xelqpJle0/kqp419MQkJc3C5opVxWG7AJevoG22Q1iuqhpIrl3WbbNetOd8RCznTyQw/lDKSDlHPjkpY13ERd7dRnByxdxYq4OXsL6fUyCaYHqEj+UhHn/Do/B20MbKU1BVZGo89wYp5VIKqckETEXDjPGmUpboUvBcEA8CzRteKggU9Hmjisq6uMfNQWNfcv8q9OPgTmtB7RkmqU9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 11:50, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Vova Tokarev says:
> 
>   userfaultfd allows registration on shadow stack VMAs.  With userfaultfd
>   access, you can register on the shadow stack, discard a page ... and
>   inject a page with chosen return addresses via UFFDIO_COPY.
> 
> Update vma_can_userfault() to reject VM_SHADOW_STACK.
> 
> While on it, also reject VM_SPECIAL so that if a driver would implement
> vm_uffd_ops, it wouldn't be possible to register special VMAs with
> userfaultfd.
> 
> Since VM_SPECIAL includes VM_DONTEXPAND which is set but hugetlb,
> exclude hugetlb VMAs from the check for VM_SPECIAL.
> 
> Reported-by: vova tokarev <vladimirelitokarev@gmail.com>
> Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Thanks Mike

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

