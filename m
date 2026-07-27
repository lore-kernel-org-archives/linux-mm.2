Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBDB4C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D06FA6B007B; Mon, 27 Jul 2026 12:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8016B0088; Mon, 27 Jul 2026 12:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD01B6B008A; Mon, 27 Jul 2026 12:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F5B36B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:52:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0091A120147
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:52:39 +0000 (UTC)
X-FDA: 85035150480.19.EEEF239
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf22.hostedemail.com (Postfix) with ESMTP id E2508C0007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:52:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mz0iuE7H;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785171158;
	b=OQCbku5kH3xMGB4AUlnlx7gXhwy6v54bi9hFD1VLVl0P1d5vHWwuGZ8KHgviRCYw/mg1xT
	0MkF14NhEk/E3adQgmuF9ZiW2jUa9i6aKcrfhPxI/FgEy8EhbXbgMjBlXMPjk0NkPYXOtw
	yVUKVp+FPqFkqj8VbL84+yDXiJyoV6E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mz0iuE7H;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785171158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=737YPCc/OqaflOGUif9Ots1oI1aRa+aDfXNVPdOX2Nc=;
	b=uwKkqY9AxI6WOHnfB9xzkR2Y47Tam9E2vJnxcVdTyAsJy1dLg/dvo/b7bpMlqsZDVp7pCo
	LT3yljBTdqzJGBKAy7sntA/wJJDj3R39Eb1c40hWNW8Ipe9OfD39EeFexUILJHSDzGajwr
	ArPVUeXnuKhqLF9fybh2XWUOE5J/F0I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785171156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=737YPCc/OqaflOGUif9Ots1oI1aRa+aDfXNVPdOX2Nc=;
	b=mz0iuE7HjiTMGr5ynsrR8zgQeXteBde3kPHCfQj+P5ae/H06Aiw0BaWzgtRCJIsMIOqLCx
	ptaFBnUgAka1Nt8LZpnXNQyWzkktGBAPkKgDOVAJ7/YWbHgQu4+TMSQ39XEgcNLF9TJisA
	qEEtLXK92EzItukd+0JCvWV6dAa+KS4=
From: Usama Arif <usama.arif@linux.dev>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v3 2/5] selftests/mm: skip guard hole-punch test if MADV_REMOVE is unsupported
Date: Mon, 27 Jul 2026 09:52:21 -0700
Message-ID: <20260727165225.1628191-1-usama.arif@linux.dev>
In-Reply-To: <20260727095225.372655-3-usama.anjum@arm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E2508C0007
X-Stat-Signature: ehbwekj541gwcw58h3swjajjodkxfupd
X-Rspam-User: 
X-HE-Tag: 1785171157-170132
X-HE-Meta: U2FsdGVkX1//KxBUp6/r+2vfmjLU0Kp2UGpCn4ruvKwrps1qBiTXSAkZWj8Hd7WvX0aWRRXrHXCltRTvhB2VyDrtV92PCtjk5o6KuCLwyTLJM2MvNuC/MsktNxWm+MQjZgkCSCY2Q1BARCMwtyQEYd+RG5es3bKuxfTa8reEb6qQvGq9axBRmjAFTMUlUt0WoCegdo6fxEyVInCnMffOKs53ucMz3ejANw0HLfDx68cHQhEx4oi7vLyRnUCmn+ojgycL7R7X1HVv7h9AORwjEX8p670ZX9UZ/DjXRRmGP0HQl8rfcL7LPgvLSxFD943B/49YZLOgPrazqp0Fg8TW8BJqJ882HxgdeXm6OQe2JB10BV9tQ3PrNlWVQBlPygX4d5PcBlEKkqapdZdi0OzuuEWU2tPL6XrxjnSM9JcEEG+GpTpA8YZ6LYADFIY6IwALrpe3quIgSvrrAGdFTwJCiTMGVeQQk6CYstJuYUyjTebTi89hq9mlPZXMhlGCarnF6n9+/45NpuoNHb23imEngvP4bVBqKhLa4hXSnrHxmpNYHqkIRMqibR8cOkRR/mXhfAYkkRFwHHF03KXPb/tRNEvoCI3FklAhwjkZksZGTrdnx7RJqD3V8TO9Mxj1LQx5roSrdc5iK/J2HDWTHzz437/8ZRtvlocTuHGxes6vI+jIHETVJnd4mYMUu/0UIE7ev3zxFdJfaV6zFCGzWXGoeUbHW7++66HQpHuxFZTlISFZ7KAsisj8PqSSzYEX4TK8Lkw1iQXpNeH8u4g5lwFab7yrNBGntNtkbGoQjdXbAoPdjTTPVgbFZv8z/F8iIzhJFESl00ZPYOy2cVL9GlfQp6yaHA0AnOnSNu5sCg7qiy7iu6T3qTHeTkZUa4uFKTll4SxhDSMbZ82Tb9xpBa2UN+ZRBlTErSbgRSBMnny1soOx2/2Qiy5Kbgptf0DPST0djvohj8h9LstUg+9upjE
 pJ24P40C
 X5+ngluqGuv84oUA52xWKfudBD/R9OTAHdEisjN0FZVVwpem8OGTCmJ6E5WkttdontRNiP8+pUqdXRwtkaacTbFtzjikAeOIbf+5tyBGlAKzdSOVezSNHq9UxE+hjnlF2Y7rCxZCKhYvNWdY138pShBOCjUiTuLCqRYujFYLBX+8uTWFhNPda8+rRYENAPSllWIio4ufWVEsTbG0vqEquiCVw7ZorrbLecCTcrkVPlGniBydxVG2d7Hf6kDrEU6F0TWfmP97k+fRDIdUgrOSs1+oIq2q7g4O6dCu7EWw0yn19x8y1ABkCztz1QcO+Wr19WK37/XQTzDRZuuvXFQa/P9q0X5VKNpbjytwzITqsa+v96aRo1H3Y6dIAIqt3i0v07KlEjZOsz2EICjOZ9nlB+T5bhITdM/fzUGw0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Jul 2026 10:52:18 +0100 Muhammad Usama Anjum <usama.anjum@arm.com> wrote:

> The hole_punch case verifies that guard regions survive MADV_REMOVE and
> that the backing range is punched out.  MADV_REMOVE delegates the hole
> punch to the backing filesystem, which may reject the operation with
> EOPNOTSUPP.
> 
> That result means the test cannot establish the state whose guard
> semantics it intends to validate.  Treating the missing filesystem
> capability as a guard-region failure creates a false regression.
> 
> Unmap the range and skip only when MADV_REMOVE fails with EOPNOTSUPP.
> Preserve the assertion for all other errors so failures on supported
> configurations remain visible.
> 
> Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  tools/testing/selftests/mm/guard-regions.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> index b21df3040b1c7..5c8ec3ca75d7d 100644
> --- a/tools/testing/selftests/mm/guard-regions.c
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -1912,7 +1912,7 @@ TEST_F(guard_regions, hole_punch)
>  {
>  	const unsigned long page_size = self->page_size;
>  	char *ptr;
> -	int i;
> +	int i, ret;
>  
>  	if (variant->backing == ANON_BACKED)
>  		SKIP(return, "Truncation test specific to file-backed");
> @@ -1944,8 +1944,12 @@ TEST_F(guard_regions, hole_punch)
>  	}
>  
>  	/* Now hole punch the guarded region. */
> -	ASSERT_EQ(madvise(&ptr[3 * page_size], 4 * page_size,
> -			  MADV_REMOVE), 0);
> +	ret = madvise(&ptr[3 * page_size], 4 * page_size, MADV_REMOVE);
> +	if (ret == -1 && errno == EOPNOTSUPP) {
> +		ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
> +		SKIP(return, "MADV_REMOVE not supported by filesystem");
> +	}
> +	ASSERT_EQ(ret, 0);

Correctly treats MADV_REMOVE EOPNOTSUPP as a missing prerequisite and unmaps before skipping

Acked-by: Usama Arif <usama.arif@linux.dev>

>  
>  	/* Ensure guard regions remain. */
>  	for (i = 0; i < 10; i++) {
> -- 
> 2.47.3
> 
> 

