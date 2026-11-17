Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6ACB606A333
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 14:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FJ6y/NLY
Received: by kanga.kvack.org (Postfix)
	id EF0C26B05B1; Tue, 17 Nov 2026 09:59:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC8976B05B2; Tue, 17 Nov 2026 09:59:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDF3A6B05B3; Tue, 17 Nov 2026 09:59:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5D686B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:59:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 499971A0494
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:59:49 +0000 (UTC)
X-FDA: 85444920498.16.88A8849
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id AD2CF40011
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:59:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FJ6y/NLY";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794927587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1VbFWHqAdIMKRSs1Q13+9d1GiMSaggumwroNM3vhzw=;
	b=u+KQ9djxMgQLJUqf/LpOx5p8CPV/u9ec1KpfX84nOqZcIB8JqE5HBaFpJgCdCr9GTLzlcL
	+hYISPVUKn3QtAE02f2yRWXnzqz+fHT0YDCxs8TrAQEmJtCC/KGNmgBSm8PT7T/Om/RVVj
	EosdJNIvwI+bt9ToSVi9Ld4nnSHGeKk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FJ6y/NLY";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794927587;
	b=22YaBpe7olMo4JFr9rGMk5KImNp3JJ80pZOSyIN/xjQ8HR98DXA1HjTE+OizMVutGZDCxk
	0RbS1FHuYFtUHDep8ZCO5aYqAXIGUCG4Ay9cd18FxvUX2E5RPXvgo5M6ykYr8OHfWaRVDi
	KbxKmjSOxL9RWgsvAv4+88yiY/S6/S0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3784D6358C;
	Tue, 17 Nov 2026 14:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE3D1F000C5;
	Tue, 17 Nov 2026 14:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794927586;
	bh=y1VbFWHqAdIMKRSs1Q13+9d1GiMSaggumwroNM3vhzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FJ6y/NLY7l6o0kd84uboAds/5Zo+8K92K5B7YWfjR/4MHNXllAPewqBsc2eiOEtph
	 seQbGkgq47f4a/z0Mrn4y2U6HYoeMab3NwzpPIkS4OySQIgLrv8bBT2hjeOo7fmhrI
	 esSvaEHFT5P7WsrTLnFmN8lLWpekXd2bMahIlt/KIoHVwUhSzxZPUK45jUNRxK+Miu
	 Bu96YZyywpMGrwyNAZzvgjBq7P4uAUfyps7D/+tw+CoA3gOqjsV6P/P3ToIeyGwXC3
	 rjI4JJp2VIN6X/cifRq5kQDFlVoIG49aSIU1b1M1MaL9OHeGAy4FIW8i5esQoIenXP
	 I6NWlSOlhMwcA==
Date: Tue, 17 Nov 2026 14:59:39 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	Gregory Price <gourry@gourry.net>, Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, larips <larips950@gmail.com>, stable@vger.kernel.org, 
	Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jackie Liu <liuyun01@kylinos.cn>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mempolicy: fix copy_nodes_to_user() for odd inputs
Message-ID: <avxnIQTcFni9G4IN@gremlin>
References: <20261117142628.3931151-1-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117142628.3931151-1-arnd@kernel.org>
X-Rspamd-Queue-Id: AD2CF40011
X-Rspam-User: 
X-Stat-Signature: n3bt41qebj43zttb6i4uracn5j44ukkx
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794927587-599586
X-HE-Meta: U2FsdGVkX1/c1WTxN9kmh0mE/w8T+0GYWa50SEX06S0a/pk31FMBTeSdiPDBUdTayADpBSSA9xeXdwhNuRfIsuecExgSGaSc5ehjqs1I4svm7cIgfLlM7d0zs3oE/W1iqbjheraRKahIXTfn63pbaizEYLlSDo/Jqd5pOY74ZZUNOhUHnPHu2ykyBFDtZwaCmxknb1+0i68TqMgNXbGo1qOb9JeB/NHH5MhewNoaBnlVv+8HFmo0oPq9SruK5Dugy0gmNzO7nTtAsw3mMvuvK957MWpzha6oGwmkWR5ZT9E2PneDEfWXkmZa2duZM6kfOpHhqQ1buV4gXs+3/J8dewnEk9t0SjAVL0J2Fy9ofMfCfWCo604LGeMRj9SBWZVnLj1fQwuQllRzx7XwOkrWkeog+zz5q6oEZnw0cVWrwB16NcAaKtGO2bqerjf34Omgi7RQN9M5VZhEMPx79OqSRuBgmicYPWBRvETniKfSxKqPPyandeBpGCk0r+ZO53otMcXLWQY8JnMhVt4NleKaoloJyPQw+s6ankui4V5P9OCUKDladE21yRUpVnYXY73bfiRA7ql70By16DHzwai9aOuoPWbhPfAqHl1M4Gw97DZgACjqSgWwRta3+2uRYGYMrNO07L9Bzm6+F/tJRqN/YZEYHk2im0I9diJPmEDPs2BlbZmYP9Z5BjjPDMvuDGSX8eKsaiVvVtHWHexdJb2uaxl/cLirg1gMo3p7Voj8baUeVJdtanKVAnKD2ACfII6PjIQCEcQbr6eHYfPFQzI9HKI6VcjHNPbPYpA36u/zkts22Tqj4+u1ou20ioQ4BWjwOKvRtmDsFv2duTAa/PJhBerNNJCuztfQlqL8QY/gei2tBBDXCxIHZxApHllyqpaYtss3T0eW7dxsKmVlQfWlsd1rNbFerxa6oNR7DtnfLKtTu59olLlqv9UEhRYw8jyYZkwmp36FPzJ8L7oI+ZV
 tD83FvYp
 tjNV2Ggt9lordYvrObtYr4lRfHPMmO3xCzgzy0cjnDvuH5ew8CuR9+CrO+lGaS6sz3qEJSolzwkZxEYvt5G+7N7bC6Xut2AHWVF+ZCigIA4peZaPt2JF9a+OkagwJIbvjKalsFh4yRMY6fr8jdOJ54t6rIAKj3CdWutKM0oJj02oI5VtHB0GhAQxFWT8hzvRKel5oKj3jGLKqNaTddXLtAtYOUToeh815exZ4kM/DVXVrTLLqsDZ9hNhRP8dVu6vYWH2MRLV1GiZoFqu3xB4JCdzLDEe3HmhQxKuCtUFEZ8HBQfa7u1mYcDu11pKDFG12C2G4ManAC/hAXqO/PfTuWk5e0lrgu/PnKTL7RYw78OiNF4IlhitY1DSw/ILQBESabHmVG0PWcQTczOW7CITf5MEYUQpv9J9uOdDHhjVuS32nAP7GAchTuZaqs3AY5iTznytSJsOwyVelGa4sF4fkpsHQPEFw5rKQ7wH+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 03:25:53PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> The ALIGN(maxnode-1, 64) check has an off-by-one error that leads to
> rounding down too much, and ends up not copying the last word when
> userspace asks for one bit over a multiple of 64.

From what I can tell, this isn't an off-by-one, but just the (possibly weird)
convention in mempolicy.c. E.g. in get_nodes():

static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
		     unsigned long maxnode)
{
	--maxnode;
	< etc. >
}

>
> For compat syscalls, the effect is worse, as the actual calculation for
> the size does include the extra word, but the check for the input size
> does not take it into account and can leak a word of stack data.
>
> In addition, the size calculation rounds up to multiples of 64 bits
> instead of multiples of word size as documented in the man page and
> expected by numactl.
>
> Fortunately numactl always passes multiples of 64 here, so none of

(Claude) went looking at numactl source (e.g. via libnuma) and it seems it
passes size + 1 matching the convention?

> this affects userspace we care about. Finally, the 'nbytes' calculation
> for compat mode makes no sense since that is the size of the kernel's
> internal representation, not the userspace side.
>
> Fix the 'copy' calculation to address all of the above. Note that the
> off-by-one error has been in there since the beginning, but commit
> e130242dc351 ("mm: simplify compat numa syscalls") is where we starting
> copying the wrong data.
>
> Reported-by: larips <larips950@gmail.com>
> Reported-by: Gregory Price (Meta) <gourry@gourry.net>
> Fixes: e130242dc351 ("mm: simplify compat numa syscalls")
> Link: https://lore.kernel.org/all/20261117101910.1820066-1-gourry@gourry.net/
> Cc: stable@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Please double-check the calculation and retest this with the original
> reproducer. The off-by-one error does explain all of this, I'm still
> worried about getting this version wrong again as everyone including
> myself seems to have missed this in the past 25 years and there may
> still be additional subtle issues around it. Apparently we had many
> instances of the same off-by-one in this file but all (most?) others
> got fixed inadvertently by other changes in the past.
> ---
>  mm/mempolicy.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 6d662a9a8c74..f318e1155770 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1749,12 +1749,12 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
>  static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
>  			      nodemask_t *nodes)
>  {
> -	unsigned long copy = ALIGN(maxnode-1, 64) / 8;
> +	unsigned long copy = ALIGN(maxnode, BITS_PER_LONG) / 8;

This looks like it'll be broken given the convention of passing bits + 1,
e.g. ALIGN(1025, 64) / 8 != ALIGN(1024, 64) / 8.

Then later that could case a buffer overflow potentially?

>  	unsigned int nbytes = BITS_TO_LONGS(nr_node_ids) * sizeof(long);
>  	bool compat = in_compat_syscall();
>
>  	if (compat)
> -		nbytes = BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t);
> +		copy = ALIGN(maxnode, BITS_PER_COMPAT_LONG) / 8;
>

Claude suggests that this is potentially broken too for similar reasons.

>  	if (copy > nbytes) {
>  		if (copy > PAGE_SIZE)
> --
> 2.53.0
>

Overall it seems the issue is that e130242dc351 (understandably!) passes maxnode
rather than maxnode-1.

So a really small fixup would be something like:

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index fb627b37afcb..051d411c04ee 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1733,12 +1733,12 @@ static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
 		if (clear_user((char __user *)mask + nbytes, copy - nbytes))
 			return -EFAULT;
 		copy = nbytes;
-		maxnode = nr_node_ids;
+		maxnode = nr_node_ids + 1;
 	}

 	if (compat)
 		return compat_put_bitmap((compat_ulong_t __user *)mask,
-					 nodes_addr(*nodes), maxnode);
+					 nodes_addr(*nodes), maxnode - 1);

 	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
 }

Maybe doing that's the easiest route for this?

--
Cheers, Lorenzo

