Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABD60CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 18:40:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA7536B0005; Thu, 11 Jun 2026 14:40:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E696B0088; Thu, 11 Jun 2026 14:40:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABB616B008C; Thu, 11 Jun 2026 14:40:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9DADF6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:40:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8FC6A0696
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:40:12 +0000 (UTC)
X-FDA: 84868496664.07.65074A5
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf29.hostedemail.com (Postfix) with ESMTP id DB27A120002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:40:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aWhrfyJH;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781203211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wzhsohGL4NN0J+0elGR6up6JkxV2fvsVc7Gd9mwW1I=;
	b=q8QEIgfeZw3VfjRJrAPjAhecW+OaYBroIurnUBL5HYkFBUVqXv/yMdGE+02gg774MjB/wk
	GRZReQlxxgWihl2rdmMdwl0VKmXupvjf66EBRaXDBq6xOoao6ffQbmT8OT3rVslVwD9SIJ
	nedvim/ChiCNU5m2djPt3EU8BOdH2kk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781203211;
	b=lHa3w66XjLcz2Bfpwx9XkXawF1q2zt0U7/uTXdUkZr/iUHxqOl6xsCnxDz+CzO0fLIfkqX
	h1rlFJDLJ1Gd7fd1Y1QJKorkHRXyKOPPS1gw6XJAkzlX2ImaGpBAdq5VKpwlcdyEhk0KOY
	6qO9D7VM2h9oOsLbFGfBsfTrqywci3k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aWhrfyJH;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 11 Jun 2026 11:40:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781203209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9wzhsohGL4NN0J+0elGR6up6JkxV2fvsVc7Gd9mwW1I=;
	b=aWhrfyJHczYiAW+e7CbyKhPyH4/r8mKsb6EcANV1BPJIZS3AxGqU9MsO3NJK5q067qHkVZ
	4qUCYyvYkBQuRyF1DmRAm1ZaEi4wmeMcTyeoaWucoo2bgku3ByiuagDcXNmRO56lIJo4dP
	Bkd80GjTuDJhJgZ28tXvJOfHpytRgI0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, jp.kobryn@linux.dev, usama.arif@linux.dev
Subject: Re: [RFC PATCH 3/3] mm: entirely remove lru_add_drain in do_swap_page
Message-ID: <aisA6GFkx22p05_4@linux.dev>
References: <20260611105124.98668-1-baohua@kernel.org>
 <20260611105124.98668-4-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611105124.98668-4-baohua@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DB27A120002
X-Rspam-User: 
X-Stat-Signature: em6a7szsw8oqmfqs99n4nzsaa483orxo
X-Rspamd-Server: rspam08
X-HE-Tag: 1781203210-457995
X-HE-Meta: U2FsdGVkX18Vb+9ot2+wmNhpqIA0BhMTrEZzy8u2FILA1/a2jtW5q9uu8PIUXQZhSNVTzDZ+cd6CKbe1H9bzV/37E6nwII7deTamsqAsHnRAxeQiuWi24MhQtxlW7f7PvAjESeb/uLKkOk7kV9ZWtOsa1r66lk9gCGH2I7eRvJV/v/1kW1k+1XzjNpff4c2xFxoSYFOYi5h1/tBWlNCpgi0hr69vIxSmlalbuAjfkagenrNfQIL7lcnYZeidhUE9tTU9GiUMoVu4DmuqZhwGEflecKTTg/sh5oaTXnEZrxYNuEWQmOuZ5Maat6uVKeKaprQdQbpNBsXlL0S8bsV/++2aJ9RKZGnVvmWjrGVF7LFH3Npb6krZeh2dFHn4u8VLlBHr6OzifuTdgCZIZLXnIJHtx9HNO7YF+ippF+DHauiOtKzq3WjmR2AayRsMbIs7X+4lRMS2xhHdmAA1k9WjzYLC1xiOk4wEEd3MUT4sss3Y6fjUdf5MPrZSYu0Kp77BV7rvchcKO/CYZ8ZCQaVw03j2DZkJ3J2rbxFAr4lsQQf6ecsP/nO9tafSQmh79SmplLHLhRgmI57Cu9smp7P5LFR2PPP2wls1zzxNNOmWARXBdXHeh8CBeYxpDls0pHTW1gU/YorqJpKMMuRyz7wNzfBBqxO0kZIDG2wKBeZ44La62F9Hx9YdNo+rlndTJGeE2TLaU8y3Gt9EvC9JsX/kz85KwslGsBDZlKvhPLreTOUJkQ1t0AFxgjw20oiSpMBoet7I/4+sUsHqJ1HKoAf7NltKMB+kC56uyh/Hn1Wjd47g9Fj4oEjJLYOvIInr4D9FjFUTnik05P8Vo3pofvEANgkoVdl+6Mp7KLj6vgXLMxoz6uHmw4L054/DJgmKjjOuZ8iUcw9hIxWmmn+EvnaxfB+HVDySOH4NK/XIXQ7eVnHwa1y/LxTu92VcHfGp1Fa1ZHekiDPYFAv/E4328sP
 jjO/k7yU
 6LdcfPleAU9VRh8OJ0Isk95PFkKO28g205TlYQNpN8EF8fQso2aKsRdaR1IgYlR9WdZtpY5Yi2jY1yYm/utS/wNEgOLpFliVQ4ugUVVW71NeuQvZRlcRdRXrh4MNx+iHG3yWVkhx5s2nsm9Y7toZFXPdrcvznPfeG2h5MU6JJceACA2T/JiGd7O8ZDXoVp00lFDr6dGlq6cUadVxB/26B9PE5ckIl6ZOOhj+Pyp9TEXdkagtiFX1y7X9tkH7168Wes+mltHd1ZARAcHQ1SxAWaqGr93GkgwpdNCCSM6CLTBXPDDOyinndhQwYQRYMastX4h0W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 06:51:24PM +0800, Barry Song (Xiaomi) wrote:
> We are doing a lot of redundant lru_add_drain() calls in
> do_swap_page(), especially for synchronous I/O devices. For
> example, the test program below currently ends up draining
> lru_cache 100% of the time:
> 
> int main(int argc, char *argv[])
> {
>         int i;
>  #define SIZE 100*1024*1024
> 	while(1) {
> 		volatile int *p = mmap(0, SIZE, PROT_READ | PROT_WRITE,
>                         MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> 
> 		for (int i = 0; i < SIZE/sizeof(int); i++)
> 			p[i] =  i%64;
> 		madvise((void *)p, SIZE, MADV_PAGEOUT);
> 		for (int i = 0; i < SIZE/sizeof(int); i++)
> 			p[i] =  i%64;
> 		munmap(p, SIZE);
> 	}
> 	return 0;
> }
> 
> Folio reuse now relies primarily on the exclusive hint, making
> lru_cache draining to drop the refcount in lru_cache largely
> irrelevant.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

