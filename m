Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88DF8C531C9
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 00:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C769D6B007B; Mon, 27 Jul 2026 20:38:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E9A6B0088; Mon, 27 Jul 2026 20:38:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8B7E6B008A; Mon, 27 Jul 2026 20:38:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 812556B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:38:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC27040260
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:38:55 +0000 (UTC)
X-FDA: 85036325430.23.174D0E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 15CBB1C0007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:38:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bWoWwaMl;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785199134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtacWlA/oBgxpyYEK+DrFmdhi2/XxpjvkTdQoZxPIZc=;
	b=F3zJkM/jDuAbBVPEh6RNDmTQ6GVzpUIMXS0HvaMXwKaMa6kqiidcra/Ht7OMw/WivY4V9h
	Cl2mg9++dzFznlRt11un+GT2zgFvdQivYYY24sVGNBKBjc1/vBAMIxs4AtI7PGAMgQ38BC
	ujYM//rxFdYb5GiCS13slFCMUsUJxFM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785199134;
	b=PLTn2MVe4aA2b3lY+NG0rq7r65IID4XMW8nqegeR0mvTv25nXJ4HHJvz4ZE3g2dIdLXgmv
	utuqpJS9El4Jxny/U/q5riTZVIAnSJVN7mJqj0BA7Iab9Z5ScYFb/XBKytF+q/LGnB+0ks
	Gg9nZDaB6EuVU31yKXEvs8XFG/lWcsE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bWoWwaMl;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 48DD5600FC;
	Tue, 28 Jul 2026 00:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D951F000E9;
	Tue, 28 Jul 2026 00:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785199133;
	bh=rtacWlA/oBgxpyYEK+DrFmdhi2/XxpjvkTdQoZxPIZc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bWoWwaMlmtvDOoOPbOtrvox/+hufHrXVjI8cVECahKMobTWToMpB0X2qRWiCO3avr
	 D5eNy4i13YAra9ilgCfRIxibCQ59rZoIxBrHeJQ9ogKKAa/eNxxBZa35cxZTQcuE9N
	 6PeZBptUVNvV9aj7vMGx1aQasIukD3TQeGGYdO1k=
Date: Mon, 27 Jul 2026 17:38:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
 <leon@kernel.org>
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 34cacd0ac7c10dc9e34e1b9f28a2b78d335cb487
Message-Id: <20260727173852.6d54ced5739a55c0ae7024c8@linux-foundation.org>
In-Reply-To: <amZU1hH_9IOeO4G8@skinsburskii>
References: <202607251512.KMStVfrY-lkp@intel.com>
	<20260725193155.0e03a382d76a99485ca05cdd@linux-foundation.org>
	<amZU1hH_9IOeO4G8@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 15CBB1C0007
X-Stat-Signature: ix454sn1czf7ibkmwkedbn7uyomqui1n
X-Rspam-User: 
X-HE-Tag: 1785199133-140475
X-HE-Meta: U2FsdGVkX1/665mOkwYliN1R/aHzfO2NyH2nRLcqjxv0ipMzuVBNApQWPrwSFlb7bEDDOuTQlPaNoW6/fGMZ6uOTdOqcKwg6BlYGkY7Vw1CFFp1u9Aax4ixpHFz7qAWOvTzI8Yy3/x4uQKYeI+DbCo+fozhzuTFO9v23GQoQCi9Fyv7abqu41Z1VQE5EwNCWCjSRSwUMBZu3+pj+LOOafcVEdRPUkohSsz0olWsRY6EhJYw3KT1XYt1vuxawFRAObX+iqZorEEN260yAiK7FIkTkmwie5K1OgzHPWHea3cdPDO113OnUn9BahVtgrWckQFYRyrGK8rpX7169egMcJdvK/TQy91icIpDwYmMGx+6LaE9n8YkWaNmjUB2Ihbp8nBsxZaQfWP5oudPZrw9dvjiCTkWAlhhrJS0ZejthPyxqvrf54WS5Mm0kevz3lgfHSbumxPL04OvZdKR3zPQ2C1t8CNgV1jfh1GO8U5aTzBzFkung+WsgydxHr22UkWbCU4le5niLf74bZoIDbHbSZKftUFDF/Vq3fiBU1byMe54ZiYk7lp9NFdn2VKVbGgpNjmOrPRn2ASUzJ3nK3exYUMABbjT8h+/UQ9yZF5110CHXSNfAcbSAanHp1WYxkj9mCy4j1PmMCfCNLZ8XwnJZPhk01+gSgS85vn0Gd/GYfEpKAESc3NfCqxaYFVOBwmoGiwGwijFQIAo6UlOY54qimIfp0ES5Xmz0v2wxIebXvEeN+tI+QE+PIPspirHVlkFtVzzZWef+yMeRuxNShFjVTYw6z+d0Yalh0sJ7d4/zVeymCdKEPWVCcqy4t+TXpMdCLqgBXmn88SHc73LL/878f2XTPjJ6ym3i68P+lnrrTwvo4QM8v2TOF0CISwq+5Lgw8QgIcgiJk3UOCJIvsa/olo5u1yYAdPz8+q483/dQ67dYmX6fGiFkHClLQToSiG9UsX270RZekT9WfSRtCQl
 K2PbztsI
 bg1dWoDW4BUV0SeTrBmOTCv93LPHvlaJftq0r7q5UXc0hYQAeI7+5FCM6ji2rFG9t/foQX+8apPOagrHPYKeCw+53phEbVNDNZ5ZWC1U4B51EDZqql/tBKPNeBIMLl1gyXUZEOJBG0WjWBZB6hSQHdrdbhMjwEaB753awgEfZ4mlCeMZnFkrGGJEFqEWyp2xSkmIy+M2Q2rgoiKd593hG9330MPNKHtFmvrZ6Dg+c24f1LWJUggjHxAGSrNZcfBA9A89/4Ty9+24KtPZw4coQDrYQCTRmFBBI5vWUq8nqA+bCE09pYo8jiAiKiRKr1ARdZaL5ZxcGkPywuiTGyGyhIokxUEE6TAyFesm8CR8A/0nm46/CAQ1swnNmt7GSWMQvE/8ukCErRNXY+65Vsr3Nii5khD4q7shUm/yxYXxV5pqjTlPjeb5eznTSljQmZEmMGeYgGpgPrk+Zi201jwWsq3QCTtwh3YkKmcG/FrtTYavnXee5L9rN22cXDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Jul 2026 11:41:26 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> > But I do wonder whether we should be compiling hmm at all if
> > CONFIG_MMU_NOTIFIER=n?
> > 
> 
> Documentation/mm/hmm.rst explicitly states:
> 
> "Address space mirroring's main objective is to allow duplication of a range of
> CPU page table into a device page table; HMM helps keep both synchronized. A
> device driver that wants to mirror a process address space must start with the
> registration of a mmu_interval_notifier"
> 
> I think making CONFIG_HMM_MIRROR dependent on the CONFIG_MMU_NOTIFIER is the right thing to do.

OK, thanks.  How about we use select.  select kinda sucks but we're
doing `select MMU_NOTIFIER' all over the place already.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hmm: make CONFIG_HMM_MIRROR select CONFIG_MMU_NOTIFIER
Date: Mon Jul 27 05:31:14 PM PDT 2026

hmm doesn't currently build well with MMU_NOTIFIER=n:

With microblaze
https://download.01.org/0day-ci/archive/20260702/202607021433.DYT5fDqE-lkp@intel.com/config
(CONFIG_MMU_NOTIFIER=n):

mm/hmm.c: In function 'hmm_range_fault_unlocked_timeout':
mm/hmm.c:804:25: error: implicit declaration of function 'mmu_interval_read_begin'; did you mean 'mmu_interval_check_retry'? [-Wimplicit-function-declaration]
  804 |                         mmu_interval_read_begin(range->notifier);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~
      |                         mmu_interval_check_retry

Quoting Stanislav:

:  Documentation/mm/hmm.rst explicitly states:
: 
:  "Address space mirroring's main objective is to allow duplication of a
:  range of CPU page table into a device page table; HMM helps keep both
:  synchronized.  A device driver that wants to mirror a process address
:  space must start with the registration of a mmu_interval_notifier"
: 
:  I think making CONFIG_HMM_MIRROR dependent on the CONFIG_MMU_NOTIFIER
:  is the right thing to do.

So select MMU_NOTIFIER if hmm.c is to be compiled.

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Kconfig~mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier
+++ a/mm/Kconfig
@@ -1250,6 +1250,7 @@ config ZONE_DEVICE
 config HMM_MIRROR
 	bool
 	depends on MMU
+	select MMU_NOTIFIER
 
 config GET_FREE_REGION
 	bool
_


