Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 693CC10BA426
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 05:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99DC26B0092; Fri, 27 Mar 2026 01:42:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94E916B0093; Fri, 27 Mar 2026 01:42:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 863D16B0095; Fri, 27 Mar 2026 01:42:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 75C8B6B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:42:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 18C1F13BCCE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:42:43 +0000 (UTC)
X-FDA: 84590748606.23.0D36DEE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7BD3C180004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:42:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="nMVg/aQs";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774590161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CtK+sFH498A814cvgnYEXK5V5g0aekmcqwvNriMthug=;
	b=gf+/Ob5JyGjaEMjwIl6oz9TNt3WAmrDz5zTJ1afJwf3M23mNKrtOJ8Wjnd/iZi+fH03Eph
	n2RsgSoaNHpXPMVY3UfhIzdHD6ER6uNAJgqI11sXeeE+Lf9h22kr8jEQ1jAhZti2GlXLOb
	w/+yVYVpjpmTL0BjVrsTkOp/F457UzE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774590161; a=rsa-sha256;
	cv=none;
	b=uRipE78ygv0M+YbY017V7i29GyUPIAx3d2wjYTgKMw7PP72f3lZ8SdPckXicQBPwMobR5H
	a4O5r/noTqvYEIc2uIX8k/AzBOb8lp+PFkEyO8K8BX1UqdalMQ9LYPg4dLVBtDIH9572j5
	ASnlzUvq6vsRROnGixNyojzahRCyKL0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="nMVg/aQs";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E3FE76011F;
	Fri, 27 Mar 2026 05:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144EAC19423;
	Fri, 27 Mar 2026 05:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774590160;
	bh=M3yhklj1LSgjvqFVJOXiEJ8tXr8x4LCP2Dv44XWj7Ms=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nMVg/aQsknpt/6YD0Ec352VbThWsH3IQnRZ35TCjfoIL+crnXVhK1f+QBHw9lcn3y
	 /cHhc3MoNXa/z+/tB+d4yJtmHM4kwsvbNsMnhZi9hl7E9avTgc/6KdvzJLIdX5Nyjm
	 52VhB0qs1ecpt/nYaaFFbktocvqtS/Va+Ot6cOlQ=
Date: Thu, 26 Mar 2026 22:42:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jianzhou Zhao <luckd0g@163.com>, Oscar
 Salvador <osalvador@suse.de>
Subject: Re: [PATCH 0/3] mm: improve map count checks
Message-Id: <20260326224239.9052f8be3ddb9cac600f59f5@linux-foundation.org>
In-Reply-To: <cover.1773249037.git.ljs@kernel.org>
References: <cover.1773249037.git.ljs@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7BD3C180004
X-Stat-Signature: qo71ga6yc3me1up8hdwkmo1ubnc7n5c7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774590161-533870
X-HE-Meta: U2FsdGVkX1+iT23TWLYnSYi0XiZO2KwrTfSvNsD4ml5d6ITaxnClynOqQSH4z2ocV5ckm9SnazYZfPCL9ht61TRzOaLZV8xOCCTKv3e+6JkziCHiPZTKiEc82DL8iLfGn0IbQbcUUY3DoMUk2bXnD6TjzZfxJ78/rINzy3QvnJbFYPeF9dEbfDLxddD/BuF2akT36ooqy7CcOrhA6+2G2rItQK8IaOQrSjGl0TYfVf/w4CbzNWps8idgz1YsVDnCaYqxFgpMc8dTrZbbXWC3VF82/66Vn40uueJSDNWFClTGLXr/7mJnb47anmzn6Ax/EWoqycRLf3Cpm0IIJTkXYMjGshocAQ4RliZ16rp/g9DSbeGM7FwmYkX6ti/Z+3PqY7rzz5V/VGj29NMgHbZbR6o1bhmRcOHxyizTYePtuWShlmewE4ziNk6TopX0H53cabHxdeO1ynyJoLPli6hKT3HV3OGT3m644YiUOJwfrMQDNFzp2wxB/M1dAMNY6yMiPJNQ4DTajcDRsDYMdwX7YpApkvQJQlFZoYAq62n/bBGb5VgSxMBuZeAnVM63agPkDvr7I+b1VwW5POIp8fH5IBFMTbt+bIb5OHvIbwz/JdSePkAHTzE3qRVAdlDYUJdl4ydW9WAdjaUsIfcE6dzuP7o2K5Xk+QiPbZa1RWqMC6ujtB46hF7QRb5mktxT67sM0vWj11jJ1pIJ4SRo73JUZcGB/gTp6pECsbSSn+Zft7wag71WUS0mBGCxniFQx78NCeNXESZ6SLAvdMCTnhIj+HExXzBPNag+jOPIRBZ1ti7drW9bOC1c8+BNO5aGjWYFXCVkZhfosF7TBfZyC+1snUK5M0+hdmrtEuWVfzYzKw9O24ibwbwmEKjglH37RYuyLuEe3EddZ0pB7FdnmhzsL4LNPkSUazEmgpiv1NnKZMyUHCGokTFsuxKKsjDoHGxZQj9Gn4yVezk1FJ+ndX2
 +OfSsNLh
 HFe17ji1eFxKMSo4Es4ROiX09ReMLIf4N0xPx8zymBI3ghnp+QJbg6S7BIH2vBMSsP58rVAGsXp/fQQuN9XRTycCfqYK5BS7s9O9SrH8iCCIlXaXyQPgI8/7WQD18UQ056TJwSWG/k7ZdYHRvX5BucLEUdszX9QzE3u9D/Fp4GZNr7Mge73W01pfmjJcx3e40AuDh3zFLqg39PFiqusGBuV58JOfMkvmdLnXv/sTaUJi/2sG9j3/csWbFHzWMqfswgF+/ppIXO2klz4wSTypCJ2DAFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 17:24:35 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> Firstly, in mremap(), it appears that our map count checks have been overly
> conservative - there is simply no reason to require that we have headroom
> of 4 mappings prior to moving the VMA, we only need headroom of 2 VMAs
> since commit 659ace584e7a ("mmap: don't return ENOMEM when mapcount is
> temporarily exceeded in munmap()").
> 
> Likely the original headroom of 4 mappings was a mistake, and 3 was
> actually intended.
> 
> Next, we access sysctl_max_map_count in a number of places without being
> all that careful about how we do so.
> 
> We introduces a simple helper that READ_ONCE()'s the field
> (get_sysctl_max_map_count()) to ensure that the field is accessed
> correctly. The WRITE_ONCE() side is already handled by the sysctl procfs
> code in proc_int_conv().
> 
> We also move this field to internal.h as there's no reason for anybody else
> to access it outside of mm. Unfortunately we have to maintain the extern
> variable, as mmap.c implements the procfs code.
> 
> Finally, we are accessing current->mm->map_count without holding the mmap
> write lock, which is also not correct, so this series ensures the lock is
> head before we access it.
> 
> We also abstract the check to a helper function, and add ASCII diagrams to
> explain why we're doing what we're doing.

This little series has no reviews, if anyone is wanting to boost our
R-b stats.

Or not.  I plan to upstream it unless someone stops me.

