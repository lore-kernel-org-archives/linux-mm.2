Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42FFC606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 02:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JrzfS8jq
Received: by kanga.kvack.org (Postfix)
	id 5E8346B00EF; Sun, 22 Nov 2026 21:24:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552676B05B0; Sun, 22 Nov 2026 21:24:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4130C6B05B1; Sun, 22 Nov 2026 21:24:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C6906B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 21:24:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B51C1C3F79
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:24:41 +0000 (UTC)
X-FDA: 85464790362.29.4C9C687
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id AF521180005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:24:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JrzfS8jq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795400679;
	b=ScTHCNH9SRnzPRefz3mD5ZkZiAzOgTG/J9hG2SJj7ZcQUChYzfCDrTsOULMj+hM8WKjlaK
	LHQ+uuPtAo3WfP0UhSHvc1yL+sKJSdX/vtv6i2wnX4TcoQMQVVdKwF6gQmwESoYoTJsYeE
	+fGHhEH4DxBmNLU0c5FPwbfCvT+krH0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795400679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=57tb2/Vr7t/oaBgLBwC/I6C/d76kKekhB9lL9K1wXnM=;
	b=TRlhRXgv4SZLCEWeVD9IlRpwi1lwuEbChniofi9yhOFs9sV3X9zrcZSdq2zcuRxEWeoxek
	a99DGThHNsVSWxj4thyT/mwrGl6nXyDnAeZjcLR8pQI438mSoaKKAQtmit5X+IxZnlgEVA
	K983LMAwEu8xK1c3qYUf/7oEkw/NM9w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JrzfS8jq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 93CFA449E1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C05B1F000F2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795400678;
	bh=57tb2/Vr7t/oaBgLBwC/I6C/d76kKekhB9lL9K1wXnM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JrzfS8jq/ZdwzK7qWLGEcDSyB9OKqmNuSOS3xhsOwReZb6AV3RVA8NEiI4XXHb5uk
	 NpoLRXLnpKKSNqolb97sUYCWPyyPNs/FQlPVEIYcO6T+VqlKBBFuQIkjeYSA9+r1vd
	 uCx4NNqhngD/6HO7Jn/D7ym2JjRXQp7isD6BxQAAdtgJi4ejsnl8mFUDk7yCOAdJ3r
	 EIbPD3LqkWS8IfS15OBb2Ovqv9N2gDbaEVahpUWO6c8uVwTImsKqh3ujdnaQSUZQRx
	 u6PZFiS2I7H70MAcPkfEoXQjVw9psXSUGizSGzLlqBPXZx7h0YMGMwKCojgAjcQHR0
	 htp2KmbblZ12A==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93f2f2edb19so260934185a.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:24:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErG7flpb1M7dsiw2qoR7Ms8HoOdFfglqAblU2gFDl0KcSMrKfIXKTXhWTUUaa7ciR6Ok92VSVkHPlg==@kvack.org
X-Gm-Message-State: APuU4Z9yHKBAKtG3Y0wYqGFKguwaAR05q/GaBQatVS8I2wctFTxr6lmq
	hmoE1rbxFFcQWHHY9nRNSg54DucXvCefXiI+lLVDM1DS9VqrtERKZ7gTp/NNsmibdD/SIx6fWes
	xz3oH3EfStCld9gJO1/hj9QEl3lQoYB4=
X-Received: by 2002:a05:620a:269b:b0:93f:228c:5301 with SMTP id
 af79cd13be357-949bab678d4mr1820344485a.64.1795400677521; Sun, 22 Nov 2026
 18:24:37 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116081403.216452-1-max.kellermann@ionos.com> <20261116081403.216452-6-max.kellermann@ionos.com>
In-Reply-To: <20261116081403.216452-6-max.kellermann@ionos.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 23 Nov 2026 10:24:24 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y5cEBmdxz91WJqc1WJdHM=8_nMomMDO=D5As2tfnAMbQ@mail.gmail.com>
X-Gm-Features: Aa3M54po4ST5My0w1x9oemNrt7Y_OkpJAd7w1jCl5IIsGSWDYO39vxHRXon-7kE
Message-ID: <CAGsJ_4y5cEBmdxz91WJqc1WJdHM=8_nMomMDO=D5As2tfnAMbQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] mm/mglru: reschedule between memcg reclaim attempts
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dujzupzth3tywm5h656tdfz16whzwyo1
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AF521180005
X-HE-Tag: 1795400679-570241
X-HE-Meta: U2FsdGVkX1+bcG3I/7orXop0UVNZ/9RgUyxcLj2SJ8xgHyrUx+bs/NZwe7ho95qCxdPoYycYW+DKCqMlIQF+wHewZqaJBysoQ0IoUkJyAy7BdFvJGTxgJDeuUEgq//MeQso9jxJByBoArEGts16USbEGqgiGI5ARhsYa6vQjKkQsIknnNXo0xOpgTvHGytIBT8KK7AoyveT5R/MSa327qvTdZcsg1UsO4d+1+VmOf9RmMpWQ/zIF6jiCCoYHZSPj+0XbzqVjuLOnsWXlkincvAaZ5MHAN4eC6Rr02u6EI3FmTZvUmFV7wm8/uSbDLe/oH8xcv4BloSAsYZoimljiLVyNOVB1bRT/2yyE77D50UxT+Xpd2o2WGd/Nf3/Duw1pvM5lym0yp2qLVNFS0/DO+FEukUtYlVKPlJ1fwKCunXRxzRyu4q2IqtNnN+KB1WyOPBrMOUtNZYWq8yIRhlTuDKWzK72s7hoisCbgx4DHDqz1Xg/pN0ucLapiovmZNtQtGbhK6wrfvQFp4+AcJehn4mgB4rHehegoP8sOpEwYt1s+X7Q5vheHdo5peC7EMd7JN5hCELffy22wXrdSNlxbsv5Sd2R3FfKUdC9twqoetefAUi2PfWanOkKyek+nsDntXFenGeqvSodJtvFTGpHmQHxFgCb0tsd6rzORG98i/ezr+ycGUJQZH3k0kh4KihQRxQSdTNMXg2Hw5xqcpWqXee4C6XUHOTPrJxli0j/wkFeVfa5Ng9Jk7sTht6x8xk3yIQvO3i7EDheoKRpFRKlLo/OvNB3otCBt3Asu3UzBmHSPk8bipYhJ5eZO7Su9FMwXcmxsvgZct7h9YmYaYp3/2thpPUBziGrYRvMIEQmQxyScxy00tphq9LeJOm5nHRmiWleabwvaN17aJwaLe7x0k9DxnK8pqd3Wc2qFEICDtOWlA+H8yxWKqCmEWH5LHtgsrbhtkbFMRqeM2bp3Pq/
 Nf3bqzgC
 F3nz7Y2kNLasuEYRHFyBGPcJODAqWgeXzGz99RLUhna9qG6m1uuh3os/kd+up5raroo8WpeK1rg9GM9kr8CpIzQ5xDlo5VUj9ECuOQ1BrqjyY/pfLMc/I+hXqlZ5l5z6bMwX/3/qhZNze7CRdpd3qbS6yEgjct7MvjbZLlhSgxIHif2TIIoQcJZhpggOMwM4x2N17B+O/fHQ40qs+yfZw75lDcwulvC3HCg6wzwcdFgec3JIBGDqMzulbtdE0+5UVB+M190+xeBZpiEcBLrSF9otVuci3gZv1n4EOQ3x4/uskIxJzMey6SYaH0nfqVG22bhMMM8PLCIz4yQPKionmVvZl7proeywiBvxcHfKuxo/ytpEZ+QsVGbVZKOMQA+SRvFRoy6s6fzvCHRyGSonCgpc0Ya91aUPVtITyT5nRtUsXSo/d3E2xLBlxWLl6VY00CsTIdtnA9Rs6abN19Bgs3JwrR3DKaritfEITz9tlPDCobK4FKc/9pzQeKtwGqD0LR4zJAORm3cKHDuB4OLIIQ8ZkIP81MCRT12dpmfxjyuYIOsBOkVrn9N0E3vmd1gYKmRe5mabccECImyKm0OOmQVKG4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 4:14=E2=80=AFPM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> shrink_one() can return immediately for empty or protected memcgs, and
> try_to_shrink_lruvec() can break out before reaching its
> cond_resched().  A scan through many memcgs can repeatedly rotate
> entries without giving other runnable tasks a scheduling opportunity.
>
> Call cond_resched_tasks_rcu_qs() (as the existing shrink_lruvec() loop
> does) after shrink_one(), while the memcg reference still pins the
> cursor and before reacquiring the RCU read lock.  Also call it between
> bins and nulls-marker retries, covering scans that skip every entry.
>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

