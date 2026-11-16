Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1592A606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.a=rsa-sha256 header.s=1a1hai header.b=aJX5PoNC
Received: by kanga.kvack.org (Postfix)
	id 2FAE16B00EF; Mon, 16 Nov 2026 07:47:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AB516B05B0; Mon, 16 Nov 2026 07:47:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C1F16B05B1; Mon, 16 Nov 2026 07:47:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBCF26B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:47:44 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8D4921C4302
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:47:44 +0000 (UTC)
X-FDA: 85440958848.24.F5C7728
Received: from outbound.st.icloud.com (st-2003j-snip4-4.eps.apple.com [57.103.77.145])
	by imf03.hostedemail.com (Postfix) with ESMTP id AF4B220004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:47:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=aJX5PoNC;
	spf=pass (imf03.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.77.145 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794833262;
	b=me45bAI+ycVXoAN9c0rjSJAlHvohtmyiUFcCNGv3sNeMciDUFm2mAhcel/HqEWHgvQnMo+
	mBHcdeXa8o8YuPTbfwTH3+ri6ZOBCc4W1a6jMmHbXItWe1QMfmwG6E82144765jrxZZ8kt
	UXxIPWihXWHjayDTfONRT9hC7xYH4Uw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=aJX5PoNC;
	spf=pass (imf03.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.77.145 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794833262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AqPO1svnj6cqsySztRzKc1k975aK5sT9hZbKLmraqes=;
	b=IB03+RElzB4VgpouzagJitgqRi1aYeQufLXA0FIiTUJHALkkVaZlji5J2nSPTXMwj2+wde
	Jju65lZMwEPdyCOR0TEXT//b91h9IhqLCNfemqW5gmDjIoifDfyXgJ7LsE6/h0VX5OmMqB
	cx/gial3Tj0vRHneV//LPf/kisdGFds=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-10-percent-2 (Postfix) with ESMTPS id 8E69C180064C;
	Mon, 16 Nov 2026 12:47:35 +0000 (UTC)
X-ICL-RepId: 01a1e466-0c3e-71a8-945f-4b8f3869dc17
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1794833261; x=1826369261; bh=AqPO1svnj6cqsySztRzKc1k975aK5sT9hZbKLmraqes=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=aJX5PoNCnUZDsPs6Wy9F/BXoQ7QKocVmQhEh1tHlv/DGYDztsZAKGDbDhZaiZKkjGfQGGU5H5OqURWQK16lbuANSbDQZmc7mCg1rJdTdcVPEQwivL2XpbCWZ88vfuyeRRmJjIMJxMh9HqIglhRQ6emejwx9K3ZjUSknL6cfG7A2SfKUwkIZrd4m9z/ZAcNQpo/S8E6mVMk5TnCsAt1qMBBNqzB6lGaX33thVBby3brzO63MktuwU33hgmq2nUQQn0zuD/SwGQOXCblpMx10zqMqMaQwrE7TIb0Ur9ugXTHYUysWyg1KXtjV0ZfDxTui30gUlsqVq1GSAumP/WrXbqA==
Received: from lima-kernel-dev (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-10-percent-2 (Postfix) with ESMTPSA id 6363B18002DF;
	Mon, 16 Nov 2026 12:47:29 +0000 (UTC)
Date: Mon, 16 Nov 2026 20:47:24 +0800
From: Zhang Peng <zippermonkey@icloud.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Zhang Peng <bruzzhang@tencent.com>
Subject: Re: [PATCH v6 0/5] mm: batch TLB flushing for dirty folios in vmscan
Message-ID: <avr7UOzToQYOppzN@lima-kernel-dev>
References: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com>
 <8b89bd7d-8de3-408f-8f27-c0e4918e48f9@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b89bd7d-8de3-408f-8f27-c0e4918e48f9@kernel.org>
X-Proofpoint-ORIG-GUID: rL_ceMxMQoQrcYO9m8_ONcWMxu8lnufI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA1MCBTYWx0ZWRfX65TkCsqUYmNK
 hQ32UvJQfbCqlzdHFiJo0ComYWmOCClOw4chzSx92ium3md5fvPK7PqNfAh2+TbmwR61GULqxi8
 0g+tFWGNWWcCIqFBNja+GXrXSDgIGRSxMhjc20Quhua/87k9uzjOXW9I0ESgTg51pondADl0PYK
 iCxF6skFKyv7pcJLWJWz1gbcv/8FlzXnUJ7nX4T0Q5CdKbxjbmYerZc0NT681rWSfes5UVuSV9/
 vdjc8uGSNWTwj9pnXeWR0VEf7rGPQLuvTYkvKE1rEfwzRzqXrScBhBjg+91od8rRfei/WETFwxy
 XLbQZ1+ns4NduH7Nuuk6JdWFnoMsepjRDRJ+9Uj7QA3AvXIFwohz2xX6xv73MQ=
X-Authority-Info-Out: v=2.4 cv=CJonnBrD c=1 sm=1 tr=0 ts=6afafb6b
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=-UxxG35tPzvqjwnQO_AA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: rL_ceMxMQoQrcYO9m8_ONcWMxu8lnufI
X-JNJ: AAAAAAABJG4OMtSERyiWZZXizsbRvBXCI28NnBcbk58Polj8fd/41R7pO1zJJ2Tykwec8h
 Xq4wQw//8H5xM/8wLsgiaXq3PZPV/l65LUcHbV6GZTjy7IRGgu1OzrGEQ8gUBLBgwfA9e2
 JujTZK5cych6aB/GbbiEmyaHnQ8pSUayaJmvYjZdOF8LwXLhOrgDoHKCYaWr1o711h9DG+
 YD6FFenD0LvvhpNMpa7aqZsc4Tm01CH7Vv6GFWua5/gWk8EKT8aqmAgOy17thiWWXjw8KO
 F6jeughSjZC7UH68D7y79DLxucghGwtYaHU1UTmROOrB461zQj3oX4nNn9yRUIck+H2fUv
 WGVCMcqL1h0IDZyepoGHSWrm57jAK4CfHO0WCJJ8AfU2Nc8zuWnOpGDdV2X+Zuiox418p+
 a8in0MXzA39O1vdTch2k/GGrThGWly4S7jo/ZKDy+Q1JQbZ+pN5Oomj26A+iXkfXlu620n
 15GZ0rltjFAtvVBW/1nXn+4u1QJ5g0apsdQiNV0dPN8+CrjI9vYwm4HM7bb02W1uaWqcWV
 reCnw+zdAzKLPrsczzdoKmDxWBM07mi12N2hORLu+5eSt59mlmqHVKW5ZZjAFh7EgBUt3I
 mujZdddCIrwA2k0cJojCOzDBEK9RMhXPWrGxN5C6LMQuUbALqAzVtk6TQ0IY4iguObiO5L
 x2PNCNzta/XHa4PqZmnxsedpAVQzDjCQ4Qp5FyQgKpZ+TrkGT5zMQ3k/CgL3CiJeRw/5qx
 z+cuvss5pdnUlQ6n66emywLygqffuieTTHb/kNyg9UyGejupMaPfD/Ct378WodANZkQPl3
 qTgDX0ErEaPXy/s4nuo8c7RxFmz4l72lwl4RnX8i+qETu4Hy3SuIKaICLG+IzOelrFmz4o
 6oDJS7o3umPzexI/Qf72iatX5pkja8cCwfWff/b+6166VhwYmKidshRnrU4qL95kCJALUs
 Hsi6kEtyZ49fgfvxA2nqW0GU8wjfOfudkiAEKpvd6tL5bP389xBxKancX6KUM2VfCkwKEO
 Yt9Xap54Sd63Vy2ZeSus0ma8izjlRQjpelT7jlcVvWSacGM1kaJvnZ2qNAFqsfrXImBiXs
 boHeWj8Vki8WVwAtYKEYoqKUx1l81qYvJ1bSuzZQ4nnSa13jQ5AG5PZe8I+NgmpkrRfZEz
 JZIOUepD0+IuCY6KcrmCIybuFGqaf11M2CWpvP2xpoUrmeJELleN9huS3LPY48XyHruVVF
 mdRkkCq3YOOCQjOqeYSu+0TJnjhMGsroTOPJbToa+/vooaMFfahAyO/4pCLkg2/rWCOTAz
 EzZBpLndUqrvIinA49SYTg5Q1FSRPqaEArbqVFNvqjUMY4Vaqz+ptCxw7gpntToi4mdM6v
 aDhz0dt3TSOTBB/mGoDmdNFnX8jkZikDiAoEAiF8KkJzzaMfVj27TRH0Ad2BTOxLsYGUds
 8gflFaHYJ96AK/yTzhffYybgYJC/YB5iMUY4IV
X-Stat-Signature: bibmg4pi7qxjfwd8t3ni83aor5pyist1
X-Rspamd-Queue-Id: AF4B220004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794833262-702090
X-HE-Meta: U2FsdGVkX18WhBa9JVsEtwm74tEsq/4QZ8IWWvIFJJCXQuID5BSsGMGv3oQ0FG3sA30bS1gxW43HzS31BsvwrP5q+UOwfbBo84l8Rjzs0snHJcjydp8rpCW/PVDG0OzZn5gM0dVPSpw0K/pqMRR0EPqTPW9y/Lhz0WK31pFSmVQM9/x3r54JOVd5BeGkzTjFg8bMmGnWBfswH24n/jx/gjt9NEwAJEmCubjGvYwpKWal86zs4YH2/8GHNMKxjt1M60rX8St1pZh6RKDUB5jBcZY3lwyu352PRmTGGeZ6fvtqQe5yI73odzhMWFhZwOGAJ9rNt8BuxAyoXRR+XQ90I+i5if36SScy34CJE9BtciN7UA0KOgihi0F4O0p1nluxOOEgNit+SjWOXH9N6CyQj1c61RjF3YPPTTvZYBJSRKaUuV3B1QKHvUkvOwIG5+V7wSuO9qaGImFOKmwIZ3OLaCO+ERuFu1542AxfPK1tax4wiyirU7jG1UB79SoZgxqXrZvb0wmyM7y3L/kFHJ31Yq5qx2hbaWhZYPzCnxSt2+3zX3IwFAlNCuTD504yVLWT9jEQfkyJ4HvDyPKVww1kCpuOZrOhMt6PVuWVWY33hF1ziDg0+kAQFiOlN6NXqZ2unzzYe74v+OG2Yx0RnmjbzFZP6SVF9gz//RZlqlJO+TyWSSVHwF+Vcm5SE/v7PWLDav00b3akWi7wT4UsZbS9Ho/qEHz8VKDk0OUpNwASC4MpuV92IPuZ7YkwgXeXFhNy3Za5WJkQ+QQ0V5BMU52md2m+HPMx8LWfQYRBCwl5qMXFdDAHy7OTB2fx7+IifD60YHiMZtZqTxctkgAYrULxt+xdyPyntSDSAySlU6YC799Isp2fzlfnnWXWQv96XC36mVxy636pTIc2A3R4pP9TnbQDlMZa9Wc4sucGwDIPjxE6ca4M/r5WeGAEUkwqJAf1i04j6kEvE/t6b1upkGt
 hHyGZ2+Z
 TPoyGzI+ZHO8iqD4zjw6b3wIhxZI3JNcEyhH4slM4GuGAFMydFyTdM0gkwbuzmEO6FmErjCmff8l+N5y7in8UUg6bgexLaAh0bapwK62s4x2MmsACmcqPrBERfb0189TlBuDnvB4TyXX63jCdJUuihk7wDk4VtNgQy1oyjhhJ0aUTfTlmgLVMBCdX/nHawCNUZZLvTABJ783ZdJHu253Z7MKDCzQ7uKICDquEkUvJDMo9csz8q7BIKKvBsuliwSYc6b8jIthujP/Xcrva/THDFcq4i3SYZQaaHp1fIx5m5xcRVdeVyznGrNPmVI50IyZ6WEe0ocDeUJdKovnwNhjUxfNUvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 01:10:22PM +0100, David Hildenbrand (Arm) wrote:
> On 10/31/26 11:35, Zhang Peng wrote:
> > This series introduces batch TLB flushing optimization for dirty folios
> > during memory reclaim, aiming to reduce IPI overhead on multi-core systems.
> > 
> > Background
> > ----------
> > Reclaim calls try_to_unmap_flush_dirty() before writing out each dirty
> > folio. When writable TLB entries are pending, this triggers a flush.
> > On systems that use IPIs for TLB shootdowns, frequent flushes can add
> > significant overhead.
> > 
> 
> I will send out a series soon that fixes various issues with current delayed TLB
> flushing.
> 
> It's all such a mess.
> 
> There will be one issue that is harder to resolve, which will interact with your
> changes.
> 
> I think something along the lines of your approach might come in handy to
> resolve it. I'll CC you once I send it out and we can discuss there.
> 
> -- 
> Cheers,
> 
> David
Thanks for the heads-up. I'll take a look at your series once it's posted,
and I'd be happy to discuss how this approach might help.

Thanks,
Zhang Peng

