Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88DC6CC6B2A
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 04:12:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 411FC6B0088; Sat, 17 Oct 2026 00:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2D86B008A; Sat, 17 Oct 2026 00:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D86A6B008C; Sat, 17 Oct 2026 00:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E56C86B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 00:12:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2C42A712D
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 04:12:39 +0000 (UTC)
X-FDA: 85330796838.16.E20CC09
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8176F40002
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 04:12:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=AKAwiVPA;
	spf=pass (imf11.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792210358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5S3nqzH7nV8QrVGtHVrTGOi4+HwJ/Mlo6RAYYB4naZA=;
	b=KrbQ5Ax3DWFVbG7XWCcp0fz2tsCt4FUF0LhBW7H1d9XuHmF2Bggw3h3bL5EM0sRiQqqGKI
	Mo6AMRoxc1YAPTf7lkrShNwPKemqPN7yPWVA8wsRjH+akixCrcTWx1g5KPrMyLNhqMQXOC
	eCRluMgpnBZwJtTYKqnjIFbLzZtMjRk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792210358;
	b=vdO9vle09q33FOPcjpMkLuG4qVISjeb3MpDSvcFpNbVMM39T0s4lQm2n3OEsuq1LYd/5y5
	mN9EIPUdROo5km5aQGyS2yQDweSD98WQdlg2fp7GJbioSz3C7VmaOYyjmtCYT5eqJm30fW
	3a3lU+6+tulpMKYnle8KckimVZT/cVQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=AKAwiVPA;
	spf=pass (imf11.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=5S3nqzH7nV8QrVGtHVrTGOi4+HwJ/Mlo6RAYYB4naZA=; 
	b=AKAwiVPAeyCRzMo1jbBEYWbcgi1nQZ11Fo9O8DFd+t64ZwueOITZYYZoHQ9IaiJtvZVS/1b2N4c
	7ynyb/zeAwr6JXRi5RVn/npdykazsiPYSZwGFZ3i1NZBAyTcmu7HoD8PuPExQ5J2UfnFC7FCXUGkA
	y1q4yfstfvcniYpNRl1lgxIh3sVRiRhGFV9PQXBQDHLHfAZfO2RFr3sMskMqz/x2NXBs/IeYjmtX6
	5Wp71LrcREBfTNNgbUHh5+gXwdmk7JuM8V6Ou7XDvDhU60kqqxKR8hoHfrGT3JHbQHqSKpsSPQZ6g
	6gCNf3jTFvcpi4+U6gTrjuX4oxfuTRn2uhfA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHvmM-00000004mbD-3wqW;
	Sat, 17 Oct 2026 12:12:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 Oct 2026 12:12:18 +0800
Date: Sat, 17 Oct 2026 12:12:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com,
	chengming.zhou@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
Message-ID: <atL1ok1YkHbA4AaI@gondor.apana.org.au>
References: <as-jZopKRfuYAiTE@google.com>
 <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
 <atGqPIpUfX0LDokV@gondor.apana.org.au>
 <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8176F40002
X-Rspamd-Server: rspam08
X-Stat-Signature: 99xw5xxixc7whmq5518rcw6ik461db9y
X-HE-Tag: 1792210357-646979
X-HE-Meta: U2FsdGVkX19KUim6blqQ+4IYUcF2hhDTtQwRMuUW5FOg5RKx+b1poHWesPexW0Rvs8nbnKW8oTe5Tnhzg9ZnfsMQGd+c6cs26mz6heTi6NtgbSKKdwMZbO34BEgDTtLvrWDPq9aQjT4ZyBLLmKUZD7XOK9L5SH178/fmBYBXMrYegpcXHyfidwLNJPFkSFIL5d91OmZQjm8qn9S+k0gmscETKHtYbvo4k8l7WxNDlrbUbpNXdJHA0JzknSxvA2GXclH1jvmw8nQ+U/rOrYQ2v1yAM23m0T2YfzE1GuEyu2iiA8Uym5/+L2mYDcMlDdLuDc82hfDgc9KbS0RYqoM1a1mPYy4nIvPTvsaBOFCxY4kKZbXu9P8uvgx940canNkISRACqdKJuuHXIPtEf9QdeZOeoam4BWqtYILBt+Zq0Rl4IIdSDvrP4BSCjBmVI2eCeV+xvdSHbHwDpKhOLfrdiWUSAEQ2GQQCPwKKHYTkAnYy0RRCUBc2f0rSt6QQSBYogXfNSQIprZKWisWZmNbJLKB9gGl+G2FHurMk8OjJTDfE9+htYJppfRrcH+SiWYmKTpB5eMDyOB8hmGid0yhUbR5XtCcHoBFELzXGKzebwtRsVlyzGhZ6Q0+e/a9nWOqpSN/bX8QOrJn6wHnyv1z7BFN8mPhUiDKFAeYnwQxXbB9YhKj3/srXZan/no3wfCIGhfsng9pVHZZudX8M6TbTZgKTxM4nh4dm4F1lIoIFkEpQn223erD/WXQT91YXGQqK5iq3NRfGLM2AxRpI3QWOtaldGqZlzOX+uLDExF9kqG/XPoYd9xmQwrIZ10JY73rAjK3FjrXRFEMn44ioDYl4+TjV+jLRUTtVSvBA9Kd3tzH88bRj8GKp8MPN3Ws1NGLX6967Bb41tA5AVNiWPIYLizstDM7ML+c+sp9iQYlkXCEZmd6wHwjmCU1V54mph0swkr0yIfxKduHeOsHKYo3
 Pf2i5qnJ
 TQDBcyB+UEtVccZ44vnj94M2PYJjLDiST6KQ/S2V/b5yyrYv3qzbIYirfDuGuWX+ZNnsBYca0SzHg9+aq/r4eTz6SBhSfzQGUORg8GYyrp2Qlual/NWmjN+DZeERP0P8I39iCiJqDAM2+NIGQSNtf+RjkM1rv+Z+1AtVWp0ANDJ6Za0beFyGEt+qN5PqP5vL6fM6rdhL6o60RMqZaQxgWoCx5WhQ6COggtjU2MovnjMRLujZIcwtcaKGDCPWQZV6epTQcxGg8ke70Z6YcB74M+rjz87A2UAug5k2vvyuaN5LOGsPA+iMZf/zeSDouyGehMupfikX4mi4EO1g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 08:03:07PM -0700, Kanchana P. Sridhar wrote:
>
> The Average throughput of 10 iterations usemem is 19,058 KB/s. IOW, I
> don't get the same performance boost as making the localized change in
> crypto_acomp_compress(), likely because of added computes per compress
> call (one function call, two conditionals).

What are we comparing against?

The thing is that the conditional will have to be there at some
point as otherwise this becomes pointless.

What if you just do the conditional and short-circuit in
crypto_acomp_compress?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

