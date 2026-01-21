Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A26E3C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 15:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116F46B0005; Wed, 21 Jan 2026 10:54:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EF136B0088; Wed, 21 Jan 2026 10:54:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3CEC6B0089; Wed, 21 Jan 2026 10:54:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E14606B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 10:54:15 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7B2181606E1
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 15:54:15 +0000 (UTC)
X-FDA: 84356417670.11.1FDA4F0
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id 84AFA180008
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 15:54:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kmlLZtTL;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769010853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N+b9RHMyh8YpEgryFPlqueFgoSWtvVkjnMCqvxBGKig=;
	b=CzgtF0/jtcM86UbUWv12A07V9me3KJnfSM+OM9megzOVnde3j13+XYmKRwkrPPoa6gs0Mh
	pIo0GRFwoe1nVpZeen/lxf/87gxiK/Eqztn5audT3S5VdEpsYEVGpeO6HY6RyWelF+ZgYq
	uUetdXuLU5S0GVNXtlW5qr0JP2tP60U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kmlLZtTL;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769010853; a=rsa-sha256;
	cv=none;
	b=04HMorGk5wCRISM1p0zB8KKYQh7fKgL3IbbZGVNTukgdZH02NRH0DXGc/w997QUA2u9RcE
	YLr2U90vyJgg9SAVsWxgIKddytUOFA/IsOXeqMTnWjq5rmc0AmkJNZMhPToq+GrAU2wIII
	6ydOk/AiWfex0M98qiLUkd6yVktPQJY=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7927541abfaso65804407b3.3
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 07:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769010852; x=1769615652; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N+b9RHMyh8YpEgryFPlqueFgoSWtvVkjnMCqvxBGKig=;
        b=kmlLZtTLiIxjo4TJ8/CRvRSX9t6wBh0RKi3og6B+YatqvNXBVS3uN7EUhZMzzv3shX
         27jHfUSojbG/yj2UT5Z2YB2P2F2AJIfI64vY1+3YYWXs1d3/9A630ZrXC6vKfXNQAzg5
         y9j5fEc53gwbFWLU/52XLvAnKngg3Ufcmx/n4nNpEoh22wPOMTc5dkAQ3QMf09I1djaa
         GpLe4Kaiu03Y+zsql8WwNuckD180rp3O1ZHLbzvh7+wOgvhCvb+sVXnBpzBuTZmdx7J+
         xMgXtXf0r5vDPwzA1UA9WXqnkj0aYEYxuaN78aHsoAEF/KNKqN2pUmgkJf8kwVlXRaAZ
         DiVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769010852; x=1769615652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N+b9RHMyh8YpEgryFPlqueFgoSWtvVkjnMCqvxBGKig=;
        b=bXvQSSbOsWtkWiicgiTRQrXaro8W+pWzJsqQSDBenHa8I0MErfXAs1p0DuO44WUtlF
         5BWizoJssz25cc/beg499rtV4kJRfnM1Il3fL0WC/XqydUuL1mnS/j4A37rinupbkdL5
         ok+jlg7MngeGCQp+VZWG4RNTs9x+M2uHi4KgpFwwzJfEVIIw3tRmFDruUL7tZkgtKRkR
         qaqoucXmg+U+vFGO8yoeJ/wa10F2YvRgUSujIcMaaGml0JqsQfbAFCCxagNtwKXC0GP2
         OkveqzgCQXZJwUvFmE9BlDWfJNKqOOtcXtKAgwyfQ9NTw0EJwBzUDVDkz4qF9CXdEluE
         aJFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCoNIfruAz6mA/ItVT1wgnoVbiYFilevX2CevkjFMU8LfcrBj0oaGe9W1+Qi3yyTIyjzIUj16r9A==@kvack.org
X-Gm-Message-State: AOJu0YwZY6uWAu/hLQ5A2qo9ZevGD6a529AYLkE9JOTnfoTahS4cAdH8
	Cf5ccLoDmUFgcoQ1G+zsYzohtMSb7R2FTWPn8+YdrHW1wDi6xBqAFAMV
X-Gm-Gg: AZuq6aKIYauHhYAp7aEXleE8AbUUABFSu4hcOctPBJY/ggPdBi96zGkGDsr15PXtSO2
	sMlxms4Cm/21Rfk5zX5ssiTk5FKNSccTlVTL4K18M4MmeQ5JRJrE9o0Sd2uit7kd4li12ArPUg0
	KKiqhx6iEvx/gGk3YY4FftbMwpjkrh3iS6Gg2rdWRAP8KjAfUCdxdFBsg1fFB9o8Tau48LH40yT
	GVd3KBaNFn9tN82ExXYAtDFU7cl4gNTeI3JjaFlN0BLPXRLykMjoTd6hmPNd+3Pxgq4l6W+4mk0
	wUkQ2UEpHbAvDos2X5ND28dS4/X2uVBUj7Pg4+s/uNHg6dW1YnBLchAnOwTeEeIzvoVNQuAmmRF
	rMsTi98mPf72bam7/q9CiizSrWahM2E1kUrG4t4BqDlpwFI5IsbjJc6Ffzucz/JS1aTzZeOZxwD
	V2NUZ7dgHr
X-Received: by 2002:a05:690c:c4e8:b0:78c:28b7:88e4 with SMTP id 00721157ae682-7940a4b09c7mr44532467b3.69.1769010852361;
        Wed, 21 Jan 2026 07:54:12 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:c::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-793c689ccf8sm66033577b3.49.2026.01.21.07.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 07:54:11 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhaoyang Huang <huangzhaoyang@gmail.com>,
	steve.kang@unisoc.com
Subject: Re: [PATCH] mm: bail out when meet the goal of proactive memcg reclaim
Date: Wed, 21 Jan 2026 10:54:10 -0500
Message-ID: <20260121155410.459018-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121090620.559242-1-zhaoyang.huang@unisoc.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 84AFA180008
X-Stat-Signature: z7zmxh8epkwprq7ekw1uqabsgm5szjra
X-Rspamd-Server: rspam01
X-HE-Tag: 1769010853-322671
X-HE-Meta: U2FsdGVkX1/Wi/ibCQEvfoG6M+uqzs7DnNraQqMTBO1rueNbRflqYN48meHDKK0YViKV2yfjjobyZj/Wf0XDFtphgptYSrb1Gjez75Cje1zDMly0PHg7veZ5M8bfn0cqIG1z/xUGzTIiTQbDRXRMSz11r0S5HW2/EOfcCu95kCfrfCxkRIWGaFGVuy86exG6KrLbIfLupQA5QFgucpI9ZZ+W23toxdc8cPpCK7daEALR/wdVaQsD1BB63/E9gzB/KrnLKuD+/w3jDJhcUViH9wxW8v/lea0bfCVkg1/6a/JOg8sU4YRe5hKYhjk2u9DjEkkhNroPkaX1u6/uSWVTaJHscG6b5RsmS0RWZYM7lKkAzg+12GtzpQ9lhbxx310dLW/bfwXzGh141h6QU+pCrOwUNwQTLwcGTCAS9CC+Nl4nb8gPAUnHZ24eleD3fTF/YifEFTc9tQq+2Z29Dh7fTLUZEPUvCEcrO56p2pn/FVc1R6XcFC7hj5urcjbq2O4W2zMvKYNQ9EuUJS/Pk1hjtrGDpnSFdbUfPqLfWF9PRpgsA4KpzHak9zPRWa+0/o8URCQ6uh49OXvhh4J2apTY7zkR9z8zaJgBWVHF5J7sm8ZIgf9P75hUNqSLKtqRnhvr1kI+wEedExn1S3/Q9igI/P/PnHQGNriNTwn+o+8xY/4LPfEri1Vpiai0urdy4HL6P1ogwvZagFf2Fbe19bqoNM/ZTXevE1jopizHC0K3NYlBHB8Z5s+jFuKZTr8kc8SWrVKlXntDwU7QjhVenGF25V0B9oIt/8zv4b7PHfhLsEAhUVou//iEDwj+j75sZam2Mf4ycgUAOOklrESQHWg2XnTUL7BLkuVQNByuIWRfbsfVQ0ZnKS4tI1solaIllqVgmMqgisnlKa1JY+CSPSkC+B+6NlD4hRuZrNzBEGc7WRb/SMr16gbGnrm8wbQDbeTmEC82ObKeVlawXxkxQHV
 jr2J/hC3
 5haGYZZCg5CP8xa/5zn3t4E49DRNPBtSsy8pUA44Tx4eqV2X9z3/ZKmqbbl8WV9xZbFSp/hfoux6VA4YDjrlz5b83wM3zveM1PYbqOzt7QE/WXCICDoxsrfs1gJpGckLGS0hU5TNOIG3JFPj0WF5epXFWLtSBrGnA3kO45UjwPBS33Ss2p4SiXNsNh3kLuek2migsTuXQC+oHNj3Ad57iuAlUt9OQ4THDfViTsZdD45bSt1gCp8uJVYqNfEwkvmt/7oMy6nenj5Knm32BeWhf9aomndkajSSF1/kRTY6yqjdvGYU0gma4HmQDeJOEnBLHMmqfsxsEGcXQl7k9UjY830RV9OuwADeYOsHMEZjJGow0FRYHPj9A5nBKHKa29TVErn4bsq2C2Cxv5NaqIKJkkHXtlox1pTjuFvsLwqHZv1Gsa6wUt7K/rTBQ9SAkYqrxU80QKeJ6omRVcbYYXlKwyBkCvmJFYRu0uozSqCy2L+VbcqThqzf/hCoxQ1kMe4lUBA8gpuhOSVOV25ZK36Q4hlPFyfECxWnprTbkKuH/Z6Hsx22hcoeq9oFdlbyMxjhJpM3Oq5T2aLCxpMy44QpdeGNjPkgPwgxo5Py9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 21 Jan 2026 17:06:20 +0800 "zhaoyang.huang" <zhaoyang.huang@unisoc.com> wrote:

> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

Hi Zhaoyang, I hope that you are doing well!

> The proactive memcg reclaim defines the specific target mem cgroup
> as well as a certain number of memories, which is different to
> the kswapd and direct reclaim that need to keep the fairness among
> cgroups. This commit would like to introduce a criteria to have
> proactive reclaim bail out when target mem cgroup could meet the goal
> via its own lruvec, which means the reclaim would also go through the
> whole tree if the iter start on the desendants.

I think the motivation makes sense. If a user-initiated reclaim has already
reclaimed the amount of memory that was requested, there's probably no
need to continue traversing the tree and reclaiming more, and we can do
an early exit.

We also don't need to worry about fairness among the target memcg's
descendants, because if the user cared about that then they would have
specified one of the descendants as the target_memccg.

But I would also like to go back to what Michal also pointed out in his
reply -- why include target_memcg == memcg? Wouldn't we want this early
bail out to happen down the memcg hierarchy as well?

And most importantly, have you seen any issues in real-life as a result of
this? Is writing to memory.reclaim too slow?

Please let me know what you think. I hope you have a great day!
Joshua

> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> ---
>  mm/vmscan.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 670fe9fae5ba..5dcca4559b18 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -6028,8 +6028,15 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
>  				   sc->nr_scanned - scanned,
>  				   sc->nr_reclaimed - reclaimed);
>  
> -		/* If partial walks are allowed, bail once goal is reached */
> -		if (partial && sc->nr_reclaimed >= sc->nr_to_reclaim) {
> +		/* If partial walks are allowed, or proactive reclaim where
> +		 * the target memcg is clearly defined that could let us ignore
> +		 * the fairness thing, bail once goal is reached.
> +		 * note: for proactive reclaim, the criteria make sense only
> +		 * when target_memcg has both of descendant groups and folios
> +		 * charged. Other wise, walk the whole tree under target_memcg.
> +		 */
> +		if ((partial || (sc->proactive && target_memcg == memcg)) &&
> +			       sc->nr_reclaimed >= sc->nr_to_reclaim) {
>  			mem_cgroup_iter_break(target_memcg, memcg);
>  			break;
>  		}
> -- 
> 2.25.1

