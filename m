Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B663606A335
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AorOBiJ7
Received: by kanga.kvack.org (Postfix)
	id 617E36B00EF; Mon,  9 Nov 2026 13:25:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C92E6B05B0; Mon,  9 Nov 2026 13:25:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DE846B05B1; Mon,  9 Nov 2026 13:25:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 319706B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:25:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB6DBA0696
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:15 +0000 (UTC)
X-FDA: 85416407790.28.768D582
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id EC97E180009
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AorOBiJ7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794248714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y4Cmesc6c6L7Z5O7qy6m8HiVqUJHOjQyHRE0+sJjwZY=;
	b=hWUvuv68MO+7yxcf22enJ89OtRbGCfrC6PEZJvsboDeKsVkauXGIeEW/GmryuN7hTrBT5B
	Vuz+qIa00Y1SXwawKMlXHFLdz9/2H+87oRz/Rm+ufdYzfDM0zhEx1ZKbsSgp97asUTOcwd
	Qgxow9swmqmchsBofc1m7NXdpyV20E8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AorOBiJ7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794248714;
	b=0b7UcMR1YMDkl9Lc0Vv4WTByZQYYYwtp3TF1p6z0NEceeBrf9jbNnZzVyDj0X2WooRI5h6
	ffFFe74ELiPC7PkXQ5aL3oNgX8buzFgFmlYBqvXr7vk2YLxP/HaMb6jVjlcOLPkqEEaz7w
	gMuBbV0mzMgP6TTMAptaKEPRZybcpoE=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cdba1b5ed8dso524038a12.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794248713; x=1794853513; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:from
         :subject:cc:to:message-id:date:content-type:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y4Cmesc6c6L7Z5O7qy6m8HiVqUJHOjQyHRE0+sJjwZY=;
        b=AorOBiJ73+DCIM2rFAjk0GcYC+DbACD07pqKISFHkVyAN2IO7/IuwjZhqVxYyegp3i
         /VIUBRN6ohYj3xgozTaR4Pa0vIoPVkaIksO4qT++hDGEQMlr1+bzyWUwi8BNVq87/Gdh
         /SgDE5/kO1Vwk+ZOGk/+OXZRvTNq0TuSso2rtV3yA+HjMDHFcbMX/pJNu6PN1tA5n2bn
         JOARxtOHptEUs+ZDV9U7xPTQgR7yLqkV0wGr2dfABINxoYKsOq1V0Cbx6cqMzX0o6qfz
         cM+ZhJY93EVBZoh8wk8RYYAyR1SBvRyIA+/HaYRQ1au25/4DBuPGVavoQZCj+bMZNwXD
         eAtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248713; x=1794853513;
        h=mime-version:content-transfer-encoding:references:in-reply-to:from
         :subject:cc:to:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y4Cmesc6c6L7Z5O7qy6m8HiVqUJHOjQyHRE0+sJjwZY=;
        b=Dn8ggwY6G3xduZrpyza2Q1ZrUPqLsTTEGhdkWXDafYAbhVBNtgxhuE43FoMvJVQIvv
         LVAkI61tJXEBNkSK5je03dVwe6zzHsd6g3XV8YNQN13j0aQAuh2OK/0hJEIYA3LxpUPr
         QySEweIcZ7QmcuvgM21de74Rl8wltRb+z9UzlXld2Df0QCCE24reVh3UQqc2jG7iraX3
         INju+c/uO3+/JtKUC4/oG2XXlS4OAzk3vkVskcfznrwIaFfwaUeTfH7CKMQPNhTVCP0i
         Zb0yjFi2eXkefAJ6m5LUG49QFuGmUOxFlUN7Et5ICFaheUlaJFplsTnBBCp+vLPV/Co7
         mHFQ==
X-Gm-Message-State: APuU4Z9TsY8DZdn45HRNSfSoLX00N1kw3w+ecoxq2qbdM6a+zidnX0dp
	lNgi83ihXSLxxL6qiT+qFRyW+1rVV3kkcPbexf8Nsv58ULTaCuoyqV3/
X-Gm-Gg: AYBFou1oTQAgmu900fBf+pYOXHpC4amVeoPdldAusc0EAQZzNSG2D6l19UsyCzCZfI6
	2vMcLjcQm3qsv4zPqHe1tquSg8uaQVVmHXkbWMryO8O/XOLHbTs6oTm6PoU9+i53NMPKXCpp4vQ
	5pQD1wddLYpv7pM4k2D2cCYMZ10PCO/ub/zt0F5goNNLptQzxSjpOFv7auyGEu6aMMwJEofkGkK
	mq0W+5q/ruYzJLscHnNxUjVAp5OW98pr9MrPEcq4MNe+dAEjLRHGnlCdHLC7aR16Sxq0ERYv8MW
	2PNALbaKbgFzIta+zYUfIOu7mlqJPdnrqnrQfoqpe0vL9zGZK84dZKSroSWwXCB3Q3M7f1i/Q/B
	GWmIxZChQHF1LAL/B7naq7ENbLT7oEa53zKubGzUZtmhn4bo86gpUM+iS1Zpaz4Kngid27+TWQu
	bdg3wd4+uL9n3lBNmkcQkKxiZnMAWqV3xgMmENs/eyVCWm+rbXQxFrhCCQLSWKSU5Oj8pXKa6J/
	wex4LU9BIFpGxxsY7rpW7QY5GlmeiKoklzCTC+hn77rbMO4QZoe86xMZaC+6WSIDQC9iDx3yHb4
	ZYRnbJ2bPQqjiXXOrOJArGbbSkBsBjewW884bPTCo5YYy1/X0xcZZy2uU1rE+x64RUDDGZRmA0w
	rJ6zaO8wJZFBLYfJx93Pp9IGcmdUQnwOnF2w=
X-Received: by 2002:a17:90b:4a46:b0:3b1:6689:a016 with SMTP id 98e67ed59e1d1-3b167931c23mr197925a91.16.1794248712676;
        Mon, 09 Nov 2026 10:25:12 -0800 (PST)
Received: from localhost ([153.61.198.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1678d4e49sm436923a91.8.2026.11.09.10.25.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 10:25:11 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Nov 2026 18:25:11 +0000
Message-Id: <DMQW32TTNOPX.24GN6Q7VI6QJR@gmail.com>
To: "Tiezhu Yang" <yangtiezhu@loongson.cn>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Harry Yoo" <harry@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>
Cc: <linux-mm@kvack.org>, <loongarch@lists.linux.dev>,
 <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mm/slub: Genericize x86-specific cmpxchg16b comment
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
In-Reply-To: <20261109035906.10857-1-yangtiezhu@loongson.cn>
References: <20261109035906.10857-1-yangtiezhu@loongson.cn>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EC97E180009
X-Stat-Signature: kzzjxdrj7bs8cd7euzxwu4irsw5bws5x
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794248713-626033
X-HE-Meta: U2FsdGVkX1/dpfmSGEWlOW8qCPJxJIs3tNa3xL/WDDMuZL+xUVGco+3+D520An3QhlqaAmFpxEEyr5tD4pL5iF6OW+nsulTD+CaY7h4HPReYaxyX5xXuGfMGI37t2Cvbhluj5ow+6sHHOTao+KlRzF1vbPPrIYcSdsm5CtOrOFjOOSPVMvFlGcNebp6cKBGuI+gYV5T7VXZD2wlp7iRkfHaBbx3BvsuU1HjB2rgHPn91pTgNjtLVkfPax49ON9iHsTy/nLFnUmAn4vKNNojrmV0DNTqQQGa2oz5ll40H++LouU1Z2Eb3dYNgUBFsgiTkZ2IZy0a4yETmJpXkE2b1SFdm+TFhUPEDcMaFV/y/y9sc5CwvGEKAlh3PfB/QrEE2h2jLI4yVi3RcE1Ph8GQ2WwrERKgCA1Z0JlD5FW3lCaWiTcITru/CUO2dHvOs2gn2Fiwu/L289IVSw81Cx5XlOAiyONcqLoN5y+R1cWXpBaMdx1wpjEILdYwU5oMMUNV09Dz7UxVAAb56wRSumIqi+YzyVs/7rae/K4Heol734RhB0FUcrd6yiU57blcmVeOmNfCpHCCxx44daBqDaA6pnVWx3A3/DkuZ4rVAUeF9CLDs2hg1aA0/svfeMzgNhyM4Ym2LJ867g4TlpO1Kr94BkkhpYq6Q6cvOIwL6JYJhAoGgWzu1qPTfBGNkY1vO33V+SVYao2ZsSzMIkaTI9dxlW4HdydyVSvfIj/pBM2auFH/snZcDoCAdAL3poQDFBffWA6khJ48uGq4sxybQmDjuT/KRd1Q0XmABZaxSnoZxrYTFWIKblp+SvtWfpplA4neH0LiL8TR/3fb18S71fkSd6n4+JhVaiD71LSOwDBrJRj5aRDoj+em6lNyTxifpEeD0GGfiV6HeyZkLrRQBvC/1xNtJUUo5KMKfy/2+W2P/Th/9WLL6IQfr2yWl3KurZL1tITUmHYEeMSDnaDVYOWI
 2Uoq2iGM
 2nVJ+DowfHFgq6+zk23pfH/yxpDrptTWNPwZ2YDTBzi5YKGFd09dGUy3OILbmTv0a0r0M9ChRL2oZl+uuKq6AfFlA1I5c6p4kAxZZC7VMl6qDt/xRYU0WmsmogdvPlTwN1v89zFYYF2jH6vUrmSfvYJ6JZkr6kWBdNjI8AvpcGemVj43A7SWo08OkVTIymmcgVmgeGYTCryYeKnPohC202rMubfzG0i8iOF3otgzbzuxFE7RwNApxwgpuXVnEo61r76i8LpLEDKrmgfInTa1vc7D8RHOt7PRKFAIwNCtMvr9UNtjRMn+1ntGTCtsHr1ZYmHBgeiVZ36qlMKs5XH8XWn1frvz+u12QWWgsc1l1nKX6refWICXzw76+qJmHIAUOeU3bf0p1PtBYh6E3gFn5MyCxI0cAQXC0a1axovVTwIf1a6sjVrmc0FMN9krFQVR3o/HWAr4nUjH+uJ0/uzhe2z62utHH/j/ARNKR6zNApfvHA7UCmsKcJxC+4MrZN6JgoCL9k7Uccy6Rbi0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 07:59 PM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
> atomic primitive is satisfied by different hardware implementations:
> (1) arm64: satisfies it via LSE atomics ('casp' instruction)
[...]
> Update the comment to "double-width atomic cmpxchg", which provides the
> following advantages:
> (1) Accurately describes the cross-platform hardware invariant.

You ignored Hao's point about shorter commit logs.

I dropped all of your pending patches.

pw-bot: cr

