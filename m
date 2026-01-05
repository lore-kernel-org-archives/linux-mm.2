Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0855EC79FAF
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 18:24:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C7306B0005; Mon,  5 Jan 2026 13:24:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674376B0092; Mon,  5 Jan 2026 13:24:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555EC6B0093; Mon,  5 Jan 2026 13:24:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 459546B0005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 13:24:36 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F0A7F14022A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 18:24:35 +0000 (UTC)
X-FDA: 84298735710.23.157EAA6
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id D5B7B140011
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 18:24:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=l9wfCNJW;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767637474; a=rsa-sha256;
	cv=none;
	b=pQWLT/GiJ0fPpY0p3BY5Exlp6JxVJx1F8iFkfA0w5iQebNItJRBR2BZ6/gfxvmniESKchD
	aQhb9BY/21jIzv4fBduV/vkQCGSUNZeTRcfqNUFg744fnrUwx8OParPaZQTzo38M9NWkLX
	GkbGW8m+pAU9nvaWUWUr+kwKcyK0wZs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=l9wfCNJW;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767637474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cmAw3sEmOW/PfoEmS4nNuobuL/oTLixAsI0C3Pzjvo0=;
	b=xIhp3s2p1oK3KKVeoJOjdLky9wO+CabJCB5NxGBMmBYEYP5RjHvlUXFJBvIMbfOh+GcddB
	7nq48MsTHjCcighbMSRUeY/vRZ1q9o6hnnl/khXj6uQqTmOIHz/Mk6X1qd8SYvEMDYGv6V
	fjFkd7DZzlDr00vNZAYkszMtysYZ7KY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cmAw3sEmOW/PfoEmS4nNuobuL/oTLixAsI0C3Pzjvo0=; b=l9wfCNJWstlU6DI61gawiguPIS
	YViswUJweTRCav0QQDt5HVa7Ai0ZCGTfGM3X2ZSD45LS/lkxdlVwmmHC7ITkdmW8GJUTTKDFyjoe/
	CzfJ6sDf17ItYV9vNfP5ZVOoKdT/mz8fPjGLaNqDKiKKvZ+tzEuTL4cuzjzUL3ZzAFJ3l2DCW4sHm
	KWe8ib0w5MSHu0fyXs/kVivqL3eV2NjLDVl5WGygaD0IdQISfSXUIGb6Er0niB/Pu9ydTR7XdpoGF
	SzUVRvgtWzb6QtAI8lI4eS/8MZ05GDq78blntDUQljxq3oBOrM7eYGMgIrh1xAbHKoj5jc+BEgn0i
	0DhsuwSA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vcpFm-0000000AjJK-0xle;
	Mon, 05 Jan 2026 18:24:30 +0000
Date: Mon, 5 Jan 2026 18:24:30 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Calvin Owens <calvin@wbinvd.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [BUG next-20260105] khugepaged: kernel BUG at
 ./include/linux/xarray.h:1441
Message-ID: <aVwB3t2wD6Dyt6yT@casper.infradead.org>
References: <aVvz3tYdu49TGkjI@mozart.vkv.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVvz3tYdu49TGkjI@mozart.vkv.me>
X-Rspam-User: 
X-Rspamd-Queue-Id: D5B7B140011
X-Rspamd-Server: rspam04
X-Stat-Signature: msykg4mdh191n9594ub98f6xay76qwif
X-HE-Tag: 1767637473-744173
X-HE-Meta: U2FsdGVkX1/2O1g7oz9bvwSLcIThtLjTD9clf3m3NY4JT6/A8k1Drw3Noe9zIxcZ2u80YImr4zAfJkuAXTQmA3AHR9xza915iCk3sd665UfKCqmOVuhpkolcaRld5YN9O2mSFbb+VKEsJwn6fJUm/OA2oadgwbYZFR+RR04jvn1u/e8wdGZxa2E3byVsCno0FVjJOw8F1tYEg+Rro2K2y8p2ZHX8HIQ2hHzeF5fP8P9HIF24po0SSZxusBm92/rqzSUOUQe4x5wnzmu0h2/cgjGN2JUoFhhOOXlxXct8ryx+Chi5gk+XqpePSJd9m9Es7W2J3oWLfGbibPI12+8jUo1VCfVAEVNUfRc3iEwVuAfWp095MarFT9OzBs2Shl7mMKzdjAbuzZu0rpdjapP9xjBn6Fa0G0dV6/cVYxZ8RuWS9+HnVxy02VRiJiHTtoyp0UNUaC/cYVYgZdIENEgmyKnOb4pMyOneVA/JY7MtjnmZfW5y1KOiCEae+dGB8ASBic7EFf7rXWnMV62SQuzpWgIih4cRSDznKH44I+P/8HWHtNF2hRa2NrTQVyyMSO3GwlPeZfa900/BBLmA+D18CKfPm5ZoovXto13gH70t/1laFqTcnbeVyHp99a/YiCkfhlukHwLlCjBM6ojosbvYShDmUF//FJuw8bVN6E7cj5avZd5JrGM6fQKLz4zudKvEDpMduQ/dwd80iaWNP9shH3oTCMINBEdbshEDQFPiRMMDAP/JJrJFiq1ge7ChFKEYpUQHv1/BYxPIIrc+opON2Mihh9b/IerTRIbzeK5sT0l/Y718gcg4i4qLYAG9p3j7mQNh0XHbr3iIZEmon5q25z+sevv4ubxCqskERAubxpPO8FTCygZszkM6olClr9HnzSE/3OJW34OWovkcbzwkpjxpxRwwjvuoThHkkpNwaUkxO35IQQ/6hmCU3aEXaVyGiJrtzs6ll1e8mHld8XV
 ZzYYqHvP
 TXEMx4bOucPcqho6GfvfXnPTCCiAHk4i1MduJbIgkSLBr/gveLDCoIlzDSg2ibqrdlejUc5q7+2ukXpHkLdoe0v6dr7pUyT6GyfZbcWcv+3oMZ5u25e3DIeROoqjp2dxOIDvFygJ50gFCpRbBRSV1l6vizALPwppbKwphtgFIqnktqQZiIf3vPKVzItGM0kDtB9oRiqgg3WCILKXhhXKY0GKfXBi30Bl6FerAbmSgLEaa4klRWCdYz4s5Uw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 09:24:46AM -0800, Calvin Owens wrote:
> Hello all,
> 
> I'm hitting this BUG_ON consistently after boot on next-20260105:
> 
>     [   17.103774][   T40] node ffff888102d43918 offset 0 parent ffff888102d42920 shift 0 count 64 values 0 array ffff888107432e38 list ffff888102d43930 ffff888102d43930 marks 0 0 0
>     [   17.108851][   T40] ------------[ cut here ]------------
>     [   17.110476][   T40] kernel BUG at ./include/linux/xarray.h:1441!
>     [   17.112321][   T40] Oops: invalid opcode: 0000 [#1] SMP PTI
>     [   17.114177][   T40] CPU: 1 UID: 0 PID: 40 Comm: khugepaged Not tainted 6.19.0-rc4-next-20260105-x86-hardened-yugetlb #1 PREEMPTLAZY  a1685c863f468289fb411d1c9b04bc9e336fe015
>     [   17.118934][   T40] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-20240910_120124-localhost 04/01/2014
>     [   17.122375][   T40] RIP: 0010:hpage_collapse_scan_file+0x1b05/0x1b30

Could you run this through ./scripts/decode_stacktrace.sh ?  I'd like
to see which caller of xas_lock() triggered this.


