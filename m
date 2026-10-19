Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61702606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 16:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=FnL5qN+r
Received: by kanga.kvack.org (Postfix)
	id 45AB16B02EC; Mon, 19 Oct 2026 12:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402FE6B02EE; Mon, 19 Oct 2026 12:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F2536B02EF; Mon, 19 Oct 2026 12:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0932A6B02EC
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:16:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A2F218077B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:16:55 +0000 (UTC)
X-FDA: 85339879590.18.1732311
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9EFAB4000C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:16:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FnL5qN+r;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792426613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tzy2/hZNZgxPkh/2CJVsFN5uf24dNj2kZ/M8pdTK09Y=;
	b=4omnqeEKMQvy23w6vLmnJlqPIlsGXTZMOPiQMJtjn5G5iOu2/xRCeCmM7pYXw/qfxi9wus
	jICnQw27YBc/RxHO1SHeR/oFeLoFXaYXLx72DTwVHA542Co7IS2x96GC6kqUrNfQABtfKY
	1OaYJL9jRUHI9d6N4mHQZcjxHFUz4TU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FnL5qN+r;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792426613;
	b=5x3IWZEd1R6tUHjV12D4fID/TGCeEEcxsyLLXEga4uya8+PK0hBdYSMD2AdWgez5qLdxDh
	m+4x7BXxpaHtmOQ+RiEwOHLxyTJfVXPcex0bixNr6E4tq/brijj1XrXoe81yefgDmPfEHa
	3W4ngLfQDo/Xcvlh/ll9MYRQ41N1xI4=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48b060ec084so1553995f8f.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:16:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792426612; cv=none;
        d=google.com; s=arc-20260327;
        b=q5LYaiw9Gxv8yyK1iUylkW7dR750c8dkF2LO6wZrYMVvABLEwfFQsVDAbUTAfDYt2z
         Wdoej6qSAmC3xVICkcE6uweWi3nk5HyNDqa+1zaL/g5MdQROFw8CMBbQA3e/aDDL1DeS
         rhlw2xgZ063BiK03UfJ4h/8nGNAcoT3uKuIDLbagTRupD6lo56Dh08+t7Bi8rTZaQ8Lp
         LDxZYgn+CU9pQs/CzTo2RBrOCl+nBSkt4dgF51j65+POS391UXl3aTHi62XZ6ODzgbCf
         rWL7RSmfsq6hLxPtzBPUl+E2wmNkNqeo9L/2wKuyNEKhvx4Nb9cGpvRO7RXWT7X/k6hF
         osUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tzy2/hZNZgxPkh/2CJVsFN5uf24dNj2kZ/M8pdTK09Y=;
        fh=j6g037MjgqzBimLmHqiiQ9QGnO4NfjaccOLyZOJBJf4=;
        b=EtJvUeO/uCKaD8j+EogyWJc/Of+JJQNh5aRn+cesrzyxz+EtciO15qQYsSNGR0tXJx
         S5yStiPPyTeE6fN+ZTjnTS4ITUYFvhSjEDgLXeqLOMSn7Y4RSJKwrezkFMa9CLZ29tcF
         ZqzILcYmpb/6hBZldJ+mP9imGG1ilcnFtcau4KLOwcp0AiMeNp6E1821MGKChRRrXDpd
         Ei1K2tyPvZR+uxa4DsLPZCGMIxxiNDvF91FCaYYuPFUUhLscSIsvONmsKNA8QYhFCJye
         NNBz+Mvnj4dbadqopkZyMQV7ScSi469jf0/G7OFIcEU2E335rePbEVdAoWtMyt1h/oQJ
         c6mw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792426612; x=1793031412; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tzy2/hZNZgxPkh/2CJVsFN5uf24dNj2kZ/M8pdTK09Y=;
        b=FnL5qN+rUVcKgbGAUBxIY3Ql0BMzYDWwIldHPU5+R0hmNJnawkW1yWJ2c3F4/D2w35
         9PWaeJuSOnaKwNVo0S3iK6C7Gyu7fF6RjbX08IpRdoKKfLbnaxdBwFpJ2HN941AtkyEf
         ppLU7gDBlXouwg3NzfjTnthULbLX9NXHEwHollkRR8hagkVlov5ttdDZowASGkBLMO0e
         /jc0v04iyIWhA/iUmSP7IJZxbyDxZB9p3zlzrBtFVHv2AI37Vozav7dHv5S1SnuVOGOj
         1i2kzHuvTVhPJwJns+8Q5etqHvqYyFqbTGWBRifUdcDiJd9vIbUYkqYv9dx135gZp/99
         87BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792426612; x=1793031412;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tzy2/hZNZgxPkh/2CJVsFN5uf24dNj2kZ/M8pdTK09Y=;
        b=2Xe0oQk5jBth0XSTJGG4aDTR4b8Coy+QYCpwExN4i8qbblg/5Vn13aScHneUjsL2Fz
         7WyWPpHBT8T27yqoac3RjypgQJpZ+7s4M4cgd8ZVsCfnTRqyw2u4uLRkfhQn+XRhoT1x
         x1zdvf1pPvMhc+qr+sa9zxOu8hwE/NYlyfQT/ONISL6/uiSfvnOCogABlJfcuS3CF7I2
         xb8py9heqhz/eeW+xArY6uQXS10pUE5fKOGydo/q5eDjSpk04bBOJPr8GzIfYNflJJFq
         nJlUiuazUqgIjncgCI4hfPoRLIYb3i5++qnpRfHjh1/TB1JFulBhwAr2d/VmSY1Z+g7y
         71xg==
X-Forwarded-Encrypted: i=1; AKwUvBz/qQfcmqbCSrXrfCV/1iN01yGpsKv/uQ0z5Lj8Q0nd+RjHZWr1TmA3VegxpqYpx5Elj51duz58xQ==@kvack.org
X-Gm-Message-State: AFq9FYLiCOFjyZyud1dy8/BpdQk0R9I6OGRbiR9rhE9AyFGeir4bknuK
	JyyqJM0CUBgpQey8FJoUGUSU6o4JCfQOThtI3UdW9AyUygRjrxf/Eltkg9ZiJiWweJVfH0So7Ed
	Q3Zt4yPElqa+u58TL9MJ0A/7+z58BHt0=
X-Gm-Gg: AYBFou38m3TwzCxbfvzU4L7y9AAdRtl8bIb/QkACyqFj0P3rwNNKNGb+ruSWB5stKih
	SivuXu1AmraBZQOCRBReZrsWRqSP91h/rcUGMF0xkgSbk5U191ns56I41MqOo8jOkO1OPIcxuO/
	OWersj1MvH+KPclohr7dcBuSD0DWBXWDUj0pGafvGgZgxLPyr9sxdySXP/pa1V17ceTk+rgxXxK
	6boR6/TCfytTQNOBI5/s9i1xI6h8HB+WucN6fmfrM5dbxfyQuih+69xjvjCkL2x35KEUv8hhqHs
	5OUYlXphshrNCsxyM3gGYi5QcM/MJJ4w9INFOa3rwZsG64gWeq8KuobPuvLhOCVb/qdqHvh/RzJ
	/UBSQdh6iUB90o0FgG5yEK1kHN28fKFhpUMF5MGf2V9g0osGpLD/s5Jep4o2GRXQELDXM/0wxPm
	mgfMXRiQ==
X-Received: by 2002:a05:600c:3e85:b0:4a1:6991:36d7 with SMTP id
 5b1f17b1804b1-4a1d75e385fmr158858205e9.10.1792426611931; Mon, 19 Oct 2026
 09:16:51 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019160615.2348500-1-nphamcs@gmail.com>
In-Reply-To: <20261019160615.2348500-1-nphamcs@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 19 Oct 2026 09:16:40 -0700
X-Gm-Features: AclHuK-V3wuqh2II4jQy2GzXwFR6X_qUKiksPsMgYsjyzYDn2Cz39hAf5ULvwpw
Message-ID: <CAKEwX=O7i6ehqyLNCpp9bqoREmahXwGS4Ja8bCsKUzyAMu_QLg@mail.gmail.com>
Subject: Re: [PATCH] mm, swap: revalidate populated clusters before scanning
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9EFAB4000C
X-Stat-Signature: 5erzyadgc4b8wqixc6hhma3wfk4hcq37
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792426613-701449
X-HE-Meta: U2FsdGVkX1+KoT8CsqR0d2SR3qSKyuViFamm6w4IlZvIpDevjyg9LONh7iJWIjbga+c2pFYY0SH8v3BogVHquFO8MuzawMDWvCKaAb5/EmEvxqySWbK8pZtfvCm7EgzRhH92ofk7Tsrn3QV4T/NjKwScEBFZc79RqKhajvbilGthLGCbu+dVZlGq4nmBc0Ukisp2DObhH8hMDpD9j9WNTwBpTUNDiDM7Uh7L0D/dxgAuh/C/FdMeox1nTHqlc8cbavUQsq8hy/fJ6vlZuKhC54/k8BkEXcSLlX4egQ4++85Mtp95/zKxlvOj0LQ/HJqViaDPoNZtdeZcdqqi8pQw8M6PgEcXdalENHSyQde1xcfJ9OrvJ8fPmv2ImsfYu/k+uAoY6vaLU07VQBYaXXdR3NHqsX7Z8viFbB40QLE3v8HOrMPQfzY1rZ8jQVTxzKyQMJwxPi1pLiCEFZkkiBdDZ3uu8Ja8bKhgkmzUYiMLSk40zkAtHnfh1p/VKwcndY5DWDtjhVufQubvArtshvXNPdT95fcKFTZKDK/LL43zg/9OhCX4HIrUmXAnsMU0cDtzscdNv9JovH6eIFLvFCeQI7/LTm5YJHej2s4kxgcOyqRvy1gHPy81dxACm/zr4tym5ShQuf1OY5hE5KDmXs6fdANjFgcDEpcR1aqIeFZlJU/pWEVbwMAqyBdIhqRlOICgghRvCombAy8lcf7sVI7mAAF4TP6RqbcCDfP3IMBisIiITowd9kfqR2v/JzyVL3Uituj7HV4u5EGE0g1q8zzXxhWCqmQcfApuEeECUASjbYdXi0Ma4sboC4+LBUYBtv7XAa+nx5n4Qu37ICXTFd4g/OFY/KBgbzdgoQdQ7legfrw0OXmfCGQ2r9rlPKe0503cGfKp0V36Y4IIfINpjn8NxegA9C37toch0xelEsLZTUYi17O2eBipsnALf13A138myOA5tU9QQI4qX1knUjB
 rGLgQef7
 xQ+xFN/sPoKGEk9hSg34BxWj3cGYnt64JnXWwnDogJceEVB2CBJdCsEFUSjnRgZNoIXe8u7yLzEU+iLFyLkcyLeqRqYItnbRkg3bGksY0OvlsNxXwA/2JKEOTbEcolgUg/sJURG9aSENS1TLgB4B12PQZ30O3d5hvZRRkluEESMYJbBvwpcdjLx1L4L5MLoIMPHrWSZmftzIUnEN0Xn3XH1RssqOMP/qL0fs7SXqQQt9lhDHIfqhX1+a8FJKmIUx3I4705wI2B0JVBEUoChEdcI7gGCePdw9ObuCWN+ElpKcTJ0ukBmNuOjuyqbMDEU2bNYIn8FKYHEnqNk46SKY/gcXQeaq52EfyTJUVcH98LW1MxZ/noqbzhHAuUkgP9Fn+JtKIfZ8xdWhyeTtRs05RV4KFrz2M4fr5jhsA+U2vpJwWbpgY2WfHyG7D0aKLeUIwDysT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 9:06=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> swap_cluster_populate() can publish a cluster's table with the cluster
> lock dropped. A cached allocator can use and empty it before the
> populating allocator reacquires the lock. The resumed scan can then
> dereference a NULL table.
>
> For example, CPU1 can retain a cached cluster offset on an SSD with
> per-page discard disabled:
>
>     CPU0                          CPU1
>     ----                          ----
>     swap_cluster_populate()
>       swap_cluster_alloc_table() fails
>       spin_unlock(&ci->lock)
>       local_unlock(&percpu_swap_cluster.lock)
>       swap_cluster_alloc_table()
>         rcu_assign_pointer(ci->table, table)
>                                   swap_alloc_fast()
>                                   local_unlock(&percpu_swap_cluster.lock)
>                                   mem_cgroup_try_charge_swap() fails
>                                   swap_cache_del_folio()
>                                     __swap_cluster_free_entries()
>                                       free_cluster()
>                                         __free_cluster()
>                                           swap_cluster_free_table()
>                                             rcu_assign_pointer(..., NULL)
>       local_lock(&percpu_swap_cluster.lock)
>       spin_lock(&ci->lock)
>       return ci
>     alloc_swap_scan_cluster()
>       cluster_scan_range()
>         __swap_table_get()
>
> Reject an unusable cluster under its lock before scanning it. Relocate
> it only while its table is present.
>
> Fixes: cdd77f84d966 ("mm, swap: consolidate cluster allocation helpers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>

I'm revisiting the lifecycle of clusters, because vswap introduced
dynamic (i.e run-time freeing) behavior to it. For the most part it
looks good (both physical and virtual side), but this look racy to me.
I don't see how it can be safe. Once you drop the lock, all bets are
off...

But at the same time, I have not been able to reproduce it (yet). Will
report here if I manage to.

(Side note: my vswap code is actually safe in this scenario. CPU0
allocates a new cluster entirely, and lock it before publishing it. So
even if the cluster index is cached in CPU1, this race cannot happen).

