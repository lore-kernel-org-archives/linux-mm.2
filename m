Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AFCE606A333
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ROSRa8VJ
Received: by kanga.kvack.org (Postfix)
	id 82F016B05B2; Fri, 27 Nov 2026 04:03:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806B36B05C5; Fri, 27 Nov 2026 04:03:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744246B05C6; Fri, 27 Nov 2026 04:03:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 555596B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:03:18 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D861BA6AC0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:03:17 +0000 (UTC)
X-FDA: 85480310034.02.F95DDC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D672CC000D
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:03:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ROSRa8VJ;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795770196;
	b=zkOQw46AjVXIXgLR8Loktr3iWvmiKCN1RFFp/bhDk+VHp/MGSXMk/jEMDItliiVFXAgn8K
	B2e4i6JNrBIO7jg0exT23KVp1zcgXDBC4cXRt2xq7jDF/y7wuBXREPSUdkVVLjXq80JbQN
	0dGsQF7HtNv7CIJHBZCsblgCpDfWFas=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795770196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eruxf2h1leWPsvtTT8j+qcRw7QHI8KPu2OHo39+Umn8=;
	b=ZwLjYcF0bGu1AHzKpgdcTM9SwZKi3XxRTjn/PKrBcgMtwVi0P1MqEphjTq2k8VhLO/0eTx
	StX3TDU781O7FG5IEkj5b4p/IZBifmvkF+9AOripOwSkiDWVxH4lMrz2xeI941ivBmcAkQ
	MbdxneaZHIFYNmCYAnwR+B6nNblxiE4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ROSRa8VJ;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D95045483
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C425A1F00899
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795770194;
	bh=eruxf2h1leWPsvtTT8j+qcRw7QHI8KPu2OHo39+Umn8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ROSRa8VJRmhvHn8D0K8LraZdlKvHZqxSQI/qWdIn8ha7HMVG20HhYeZRh8jL6toec
	 4THvEea+2rwP1KyC9wK1uSDuoENQpVAHPYeKwajOweBzBwuVXJ+nHbjyzqgPBlzTYa
	 NXdLLTHI02ZZ5nNncjHsurjYdJ6aH9NLna+q4mlRQWxkUn2oHB6R/2Doy58JrFuLJy
	 s/SrKeEsCgnDWlXF+/xRdt9CQIGchZbYCVVUTY55QjdDS+eqE5gRPgvkKnwwVn6zk7
	 kvnMPKfEQgdDQ+6Tt1U4moNl5/5JTQbPG1Zjhk2Clcvui9/n6+NVXcZNspgpiMPUYa
	 95cZD81hYnYpQ==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-94958650b09so749884985a.1
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:03:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGtNWdfdclkWojKS0xd6T4/fmWE69SwSBmQlMQ8extgClsnVMoqLGpSmdX4cl8chQriBEgNPdkxOg==@kvack.org
X-Gm-Message-State: APuU4Z+iimSkImUssLOLsm1OwQv3RtyQ6fEjZFgAe82tZ6l/LOKvepZ+
	zuersMehY7nerrWlpHMDIW59SQmk0Q7L9SYGb2GS55NoxHH/BnpuVP8spvMgPLDNe2P75r6SWze
	TWmLH2CjeXi7h8oG/qkH8FXrqx4FBAss=
X-Received: by 2002:a05:620a:448e:b0:949:696f:c997 with SMTP id
 af79cd13be357-949bab480dcmr3968194285a.80.1795770194103; Fri, 27 Nov 2026
 01:03:14 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261127031110.1034854-1-ridong.chen@linux.dev> <20261127031110.1034854-2-ridong.chen@linux.dev>
In-Reply-To: <20261127031110.1034854-2-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Fri, 27 Nov 2026 17:03:02 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zW7UtFmBckdA0L7sgs=X-c-w31FzY1JZJG9sTPm+6sCg@mail.gmail.com>
X-Gm-Features: Aa3M54oa0WdjzJtA4q7rcWJyPM1Mj2DUJNx3pL3SpCXSWAOiWYUe4Jcul3-RYl0
Message-ID: <CAGsJ_4zW7UtFmBckdA0L7sgs=X-c-w31FzY1JZJG9sTPm+6sCg@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] mm/mglru: pass a seq range to lru_gen_add_folio()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D672CC000D
X-Stat-Signature: 9jzf8y7kg4tz11jir5pmkgkuaa998i9s
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795770195-756835
X-HE-Meta: U2FsdGVkX1+BR/y2a1mZ2ZVj1XxmPf/AfwPX5imyFyajQWbc91KaAVNJ2vHsv6iyEim41uRYrggM+AEYg+MuefhHMXykOHMQjCxvhk3YVcoze3DTYkQsPSTXJBrWuRnWAH+Sk2q08DXfFQiT9xFbKQDR/pWBqbQIEFpE6kPicr3qndGaoDPsvlRsZEGoLIbT5xmXxxQhzumzISIVs/g64aLeP7k9Z2x1KnjxgS9zgZYwdCj4Yyj6AeJShxIZzTf4ymbmo9wV9bm2FNil7mNn6iaOYIzqQAi+7pIKGWKn2U90+JljS5+SYTURGAkcQDEVPpnVus49G+pwUT4s5TeGDWKOzBuFde15fb87Z25d1XM+Fc4capmZntM+8P3MbFdeudrVOOcTxzRvSvoZzI7dS79Ez7xrbyP8TCSQlygvJsfYcXsmpU6GLOLUbXXp5E5MKUvPPjWyvNJ/SuFsX56x/Xyc+id2oReR+6SFf1tdFgZxhvSWQZkc76ycdYZ5EsmUxO7fdOvmCMgA7aJ+0iGhR4Cau7YuiyoVCjHvoDLEb6m/vO6h2fIe0PvJLFiOqEhI04YdNUoU0j3JfmSIX/BiukG46t1aWfbpxWVeoOpPmYMEDWwsuNVqdEsoh3zgPtZ6fs+ji0fxEfN9AKr+ZifjQBe+07wyHTG3fhv7/2cXODFScJFBg57mruZtH8r8nigJ/dNCbT/m4vNkbuR/uW/qAogsUSxEInbq5GGn1xMYqIobh42fZsVz2vwdza1zOWYjWriCEu+/ncVVGRNqp/1GG9qSEV79qugG29zg7oE/OtAtm8jIiLuh4wQL3bzJ3CLL16eefamD9hvNg2tjVvNNXbQ2FIN0G/5j7hwDSuaI4SR7IK/EKVxgwqnKFO5t2fhoQf4+on3G3z1SXUpPtLhbHTeDXHRssxfHYJnQw/OrLX2jZ+wmyJxQN+YtYoyIRvRieyg8PJ5FUvS+0Pb6Nin
 FB9fsQ11
 yKjlqYWx23i42e+NsYVZ9eBD5AyxXDSb2eg+MTmfGEN5p9xMFkdDiWpkyst6ULpSUVQHDvwVG3webS5uic6PbeGR4aHu46BnEjkKw0HTxiMP53z5o6kzJpFAzLoRLXiZywmYMRFAFlnGd+cbDohBh6KGu7Lmh7AbO+a8CaxWGgt/CLL8n9vRbdDpHY3KwzXm+8TMy+mZ48c5eMDvrj6axVBTOtuD9ANiz6IEp631+IeBBetdYkisSAZuk1VBHfGCLp3kz5LJbMxKLc5lwo1hoErxXIKvAzolkNH48evlMS2162dLN1x5T1GaAfinNPi03ZcMsbp252OJLPyXZrmFkvtR8TI8sZlc3zQA2gPTXYhTVangJvSqDOuAgTcB0va5tDXmCjzmievbhQz8fL1ABgEJevYzBKOIa28LGwrv6/xZT5NVvwaYlLrQHUKvaYYEQ1ZeCPz3J/8wME4UFOAGBQpSVYt7vdCYMKeQKkYOM3tdT1/ZjDuadC4Bgqzza+lK+dLFH4TM1f+cO8Xpto2vxfJ0OGzwnjVAY8zFJa1jdv+MPNsL8cB6lKmFVVONWPqSlPVaOKN30O0CB5MYPVtgfUy6+z07LfiTG5jVp+NVIDTUJtpf+CXwNE8LfksD4f++yj0YY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 27, 2026 at 11:11=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev=
> wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> lru_gen_add_folio() and lru_gen_add_rejected_folio() are wrappers around
> __lru_gen_add_folio(), which can only raise the generation picked by
> lru_gen_folio_seq(), through scanned_seq. There is no way for a caller
> to lower it, e.g. to put a folio into the oldest generation without
> also adding it to the tail.
>
> Let lru_gen_add_folio() take a range [min_seq, max_seq] that the target
> generation is capped to, and drop the two wrappers. MIN_SEQ_UNBOUNDED (0)
> and MAX_SEQ_UNBOUNDED (ULONG_MAX) mean no limit on that side. They leave
> the seq unchanged when capped to, so no special case is needed for them.
> move_folios_to_lru() passes scanned_seq + 1 as min_seq for rejected
> folios, as before.
>
> Also rename "reclaiming" to "tail", and make it only pick which end of
> the list the folio is added to. The generation is now only decided by
> lru_gen_folio_seq() and the range, so lru_gen_folio_seq() no longer
> needs the argument. The two callers that add to the tail of the oldest
> generation, lruvec_add_folio_tail() and fill_evictable() for inactive
> folios, pass min_seq[type] as max_seq instead.
>
> This does not change behavior. lru_gen_folio_seq() never returns a seq
> below min_seq[type], so capping it to min_seq[type] gives min_seq[type],
> which is what the old reclaiming branch resulted in. That branch was
> only skipped for active folios, and none of the callers that pass true
> add an active folio.
>
> No functional change intended.
>
> Suggested-by: Kairui Song <kasong@tencent.com>
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

