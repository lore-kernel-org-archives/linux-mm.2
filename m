Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83B37C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 925656B0099; Mon,  7 Sep 2026 11:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D61E6B009B; Mon,  7 Sep 2026 11:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C5826B009D; Mon,  7 Sep 2026 11:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 567586B0099
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:43:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E94961A01B2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:43:24 +0000 (UTC)
X-FDA: 85187385528.10.0420C4A
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2969B1C0002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:43:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OymmNVi8;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788795803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9N6f/b+RDjU+5LdwC1W3FgNOtZzFd5njRslDhw37g/s=;
	b=44ckM5AlZCOCUGFjkAnoSZxLIRpnqktgIPsKZO9tbo7RsEOptH9bP/wFqesgDUCDWu6sp/
	MsZAwA67laqL0NAnpfW+02I7pvkEykKeuKdVWVEEZF/IWbfU2GiQdcKgVp3sc6K3Ze2Tf3
	AYwtjcoLqSsZVsej1aiY3LHyL6/H270=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OymmNVi8;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788795803;
	b=szihvzhdu6Ajk1zQGDE03nsvLw9u7ZSNvZTqS4lGPFuYuN5M4hH+8hS8nuT+yIJMHomv7m
	S9v401sK05bvBLsEbiqjbUSxruyBb8fmN97101JeVxo0WnrD62vQRfFRs1FtczR/owAKfS
	8ysrIek+2QWbJqF8Or05W7sUuq4D7Uk=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e50a650a0so346442685a.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 08:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788795802; x=1789400602; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9N6f/b+RDjU+5LdwC1W3FgNOtZzFd5njRslDhw37g/s=;
        b=OymmNVi8Z4m5NFKz1gWL7+dkvZtKkA9TNxyK7R1FfESUFXaztFH8BzUNXwgn1DZwL4
         ylO+X6i+SwGRpCr4qh4aNF5tYQsF+zRlSsyktbRnY1sZ1UBc7xLYBLThZm6aj9dMgZ1m
         mmhQImaliv5AVL5yfYTVjHTz03lB80xUfEAqHun6kApyMzm30IfTamPWnmdVyRx+pzel
         uIVJbcqdEdv9siDqS5Pmt1LR6/oLGElOzBErJN2mKEWPDjQiuOB8mIzAVEsvpZAHlD4X
         Ls7+08GQ8MsvPD3sfBN1TtAFZUbmoYCkgyHWIjV1fPCAtN0wppK7+ZUHHRLaG3ASRUz7
         zTLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788795802; x=1789400602;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9N6f/b+RDjU+5LdwC1W3FgNOtZzFd5njRslDhw37g/s=;
        b=CNnIhrNaW5lTZQMH2oxU86r+xyheweotn0ha4FLqmDPEqRfYEt/d5MJQNBqB0D99kp
         uvNnEthN5sRn15VZmYwX+yEIe90M+9/yrjM6L4q/u8ZNXCciQApq7GHGxCLdZzA249Yp
         w6sDn3c9ohdOVxla9meLMudYn1Mtr7JDEG9nxs09ZNHb0pMJmaAIgkHNA9UZ8/mk7S19
         RvIl4lK+ZNP7qCkpC1/oZwElG7X6ef74jEh1MYzr3QnlYl2Y9A+TcrtzpYaWTBVZvqiE
         qi9guM5742FWt8CR0S86+R7VqvlhAwlTtrm41nOLPYLSw8DzG5aMJWo8Xoe+ZGaruQBq
         ctZg==
X-Forwarded-Encrypted: i=1; AKwUvBxn3xZ/fr00UMqUx2KDnb73YVXgWhLETKeHX1ZXXYp9XiYC73Z6hkSPb8pPedXSVSJM0Sk4KN3p9g==@kvack.org
X-Gm-Message-State: AFuF++nRYBI1zGmUO/JD3GPEg0953uf0RO5qjvEj/3yRfHxW+GdJpbDj
	QK1fcZ2LOyPN6PzsaHc6oUFh3V9802uyJzTeMbLNcK0sD9rNQKavqGG+nJGH/LV3bbU=
X-Gm-Gg: AYBFou38jrIiaeNMgxNTMdT4G24YX91/W+EgHWqtiuUy8+SwPNvJOQaNEN5h+QymnkU
	S4v+6O8JZTtu/3kqQvUJhLziZp4v7MGvwDB5RjoFw2aszDZnSUxVLb6W1CQLwuPPjCwT1TWU0yY
	AdCtnrSwz+718cD+DwYzbAhJZz9tn0ph9n6c2L4uWJ7YVo84GhLO/1TH6j33FrR7kG9Q8Aa2SPC
	37j/7lbKmgP7U3E3uNX9fh4ZO5+whKN56gvyluy/wxnn3dTN947jKgNNoxl7nlFd8RGSToU3hGV
	NtaT27fZy6Je8l/AhQa/EckIvazKm968tt8HD8X1iCxVsAkhk+hujE/akRkurKI4arpycnzv/ir
	iCQb3AoZth0bqdIy9fyeExc+L/C2jZlR19GaB5mfATA83F8VU+iuBK7Y62YNTx1JsVioCpBTblI
	GkI0gEZU7/DHdL4Spwh9XzV6v8TD9au/ex5dMRSH7dlxJKibMRAk7I7m1+NtKL19wTrndnNyscS
	Ll9gEGDmqfERVPjgmsLZJhpidb5gZNkbksxZBjIsWyj
X-Received: by 2002:a05:620a:1a10:b0:939:93f:3b41 with SMTP id af79cd13be357-93980341197mr2411106785a.16.1788795802336;
        Mon, 07 Sep 2026 08:43:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910406bf8c3sm94620766d6.48.2026.09.07.08.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 08:43:21 -0700 (PDT)
Date: Mon, 7 Sep 2026 11:43:19 -0400
From: Gregory Price <gourry@gourry.net>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Ye Liu <liuye@kylinos.cn>, Michal Hocko <mhocko@suse.com>, 
	SJ Park <sj@kernel.org>, peterz@infradead.org, paulmck@kernel.org, mingo@redhat.com, 
	rostedt@goodmis.org, jpoimboe@kernel.org, mic@digikod.net, oleg@redhat.com, 
	tglx@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com, rafael@kernel.org, 
	gnoack3000@gmail.com, ljs@kernel.org, rientjes@google.com, shakeel.butt@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, will@kernel.org, boqun@kernel.org, 
	frederic@kernel.org, neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com, 
	josh@joshtriplett.org, urezki@gmail.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, tony.luck@intel.com, reinette.chatre@intel.com, x86@kernel.org, 
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pavel@kernel.org, 
	lance.yang@linux.dev, mhiramat@kernel.org, pmladek@suse.com, longman@redhat.com, 
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com, qiang.zhang@linux.dev, 
	dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com, 
	babu.moger@amd.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 3/8] mm/ksm: convert process iterator to
 for_each_process_rculock
Message-ID: <ap7biSs63MDeB34i@gourry-fedora-PF4VCD3F>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-4-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907081334.1152889-4-ye.liu@linux.dev>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: iqus31xn4aop3ya48rwfhjx7j9c4i9q7
X-Rspamd-Queue-Id: 2969B1C0002
X-HE-Tag: 1788795803-303932
X-HE-Meta: U2FsdGVkX19kW/8VeK83E0iY834oH6QHivW9bVN2sHi0e8pImbF4MeNCSQ0FUVLhZ9gOs946JQalipGVFlDhvZ1GBovSy0aTLmcxlHxPq1KooLdv/SkyF9/qiT/+04kv987wrqkN4Z737FePSDPZmYlgvXRVJwJ+5HIvFfOTOqMw+w7M2n1tgB5/liPMS49JdO78f2wm5S1YNZefu9x9/E5poEJhCnuPbBZ9kqQlLl7JL7DbWLPvPZM5rVKJgc5sszxM7ROwmHhnjRFd80EuAcCpiiluw9Ky0VO/zviuty4FHo2fMnSdOExyq0A7X1d0lozYK57j17gf2/fJrp3AFJ2QTSsjYGojiaVFEXD2x9PvizXHWugsqi0j2H2yrDlPCqSjSYwDerMjKY72gMm49uSyrynZifQE5rcgt8R+SKLtWhf3UxyZUL6bXVTHcw5NJRPU9yXpBtxJrWJRalJ0F6VPxo36HVaLmkgw2Xv1lZ2MOcCvdhcHIYnMMUSpXq18bnEGwvQGuyz78ddQbSyxOPph3ANNbcQcV7xGTr6y6RHke53UYW/ltuYwwQHp7wooUL8dKJsKxuzQtl9zDfDRtCzrvFYczflNvgAJna9ZHARgcgj0/K4qxKdv5wJSt61r5to+qDxxAtu5bnuQkBS2zaDb0i7AudGSNPj79t04TP7XaMr8/i+36CFmj4olxIb+tfSPMnh4z0ZuY1wAI2G1zDrJ4rELPUfOrf7/h5FSYVIjx0Zp4IXZ0dDirBBbMD7WOztlrZ53dQeRfDrXm1gLLHhRGM7E8DzP7LqyFkk378hGaKuOuOh+vetD0/mY/bFskrUKmCu4Yyk5IM/aU9RIhif0d6agfMICYdgCgl48Tcp8odaLk2L3BYXZfSHcGiZZ7iGaLzo3ut7mS/I7r1C55BgLTtjo4pJTJj2bfZHhlf4PCtVsPja7Tdi/WC0mGnqdSU8m7eriFDuA7to4Dsn
 BEOiF+yo
 A3KSuYZ8/YCWBfo1q/SG7r8JRfv532X/A177iaqwUv/wZvbpbGzAkfPn+9GVv94bMbfsIpfhJk2tYTRW9oGEQ02vTBF+74XR01sgOxDPFSFA93FKyuTI+Q3F9YkpOEjZyNkABltloQIA/EHQBKa0DxUUzf06/oFDRR44QA0N1pWZxk01gbw5AHuBqfj5I6SY2pmqrOEd3EvaagjTW3nY4qQdIF3TWkNUFMpGAAs1j566VdHYzZACuRd6EqSLPsakTBIsi8hZoZUZckwWxe6i6q2sDdlbgOXYSAT3gd+9sZjxhXFarJVNkObG73M2IahsibcpWNcYQDTCsZgDa58/8wNxI8GfpBHJkE6IgpuORfYyEK7zt79+dhJ+qCgjoD/NUozh1MYUzIZG9rjSbfZWAzW/djeoaF1RkwIEkxkG7xmKfKr6M54Bbig5/0wiqZ/PXzKu93q0CpUrw82TsrPUWvgrv5j6MJqg/BnTHgJszYRf2y4A/i6s/dkY0e1PSKZaG5ehdiV91UYkN1oblwctwL0Uh+zF/OVWc6Sky8yFaY+SiEh6Ts71ht/E1f5rmlaSyDA9G0I59ITas93dIpC6JihR/mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:13:29PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
> with for_each_process() loop in mm/ksm.c with for_each_process_rculock(),
> which scopes the RCU read lock to the loop body via scoped_guard(rcu).
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Reviewed-by: SJ Park <sj@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


