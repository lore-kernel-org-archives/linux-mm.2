Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61C93EE642F
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 12:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84396B0088; Wed, 31 Dec 2025 07:13:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07806B0089; Wed, 31 Dec 2025 07:13:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E9886B008A; Wed, 31 Dec 2025 07:13:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3806B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 07:13:19 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29A245C807
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 12:13:19 +0000 (UTC)
X-FDA: 84279656118.02.24F3C6F
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4DC3A8000D
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 12:13:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ss0P3GdM;
	spf=pass (imf02.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767183197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FHpfqEUrGSgxMV6guOQm6UqkwMcwdCx4Mtcxq/Zux9g=;
	b=7phMAu+AGomNNu+I1hTNp+LP+3IpBqJvCAo+pAywJwQ/NZMe/Xf6y+RqU8PTQk9Yc0eSpD
	/UD29Ycgkka6gHenOBZDzLfrVi5cvzOXK/I5DajRE4rDCewPiEAeGSd7FA0Hrvj3f2OwFg
	l6o85Z7U/Mn2P2TQg6DpHKuH36lAGQM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ss0P3GdM;
	spf=pass (imf02.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767183197; a=rsa-sha256;
	cv=none;
	b=nHWXaWaPEvEtZCwMz6AhFFxuyiNK0T875/hWdgFrBIrI/30BzJm5GKBklREOFxukqwSb50
	pef2CyfeXnxbPZDzXUayx2xk+V6KcRH5JPWpPbssgWsDn7ntGcwJYrDnZjqK5z6JEQ0S91
	2CwnvoJ1D+Luj7usVi7/BQZiL+FMFGU=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a07fac8aa1so116326335ad.1
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767183196; x=1767787996; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FHpfqEUrGSgxMV6guOQm6UqkwMcwdCx4Mtcxq/Zux9g=;
        b=Ss0P3GdM9Cju8fLPyf3dmMezQn/i7w+QxymdF0mCeH6tuUjR7zuXqP8rVhXl0QYPJE
         V90Ld/WdQAAOmjbiJAAZvsd9avU0H7bTwbXI8zY60Q+tGj9cm/8JdNU9vibm/Kk5sMXN
         kORwdina9tkSt0QDHu8KsUWcIGEk8WVvvH8nVMKR2sS5I8vtkLR/fi/1Qt0gdhWxZTDq
         vYXzKT4nsh06aCD/Qk6gmjOQ9fClpbEbr8DHYUXER8QQj1BRJ5FyDia5dP6U12Z0L00C
         PjtRTsvw1EY80y3fDVBzDMqth+TbobU4XOoV0gE96xt6J9oaCKQm9IgYMh8KaofgIb+J
         T6IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767183196; x=1767787996;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FHpfqEUrGSgxMV6guOQm6UqkwMcwdCx4Mtcxq/Zux9g=;
        b=q1GNIqysALtwz/0ednrU9d0XIbxBZ+VXPqJmRgbC/UCTgPv/zin8HRyIbcHPxJTGXA
         CzQXkbLWzHvwYoT/Ww0A/r+v3C60lPg0rbsmPZHU2Jmxv+J/heQckapOIj4JkayQAmmQ
         4JdpGw9dDs+xT+8I3WZRSi7aM2bVIADvhL709Ny1cSvmpkhgzY9y38YiAEzCLUonj1xf
         hn4As7uVx0iH8UcTgnXw74lMKY6tpDj6cx/NeuBj1S5OReCPyVphyzgIUBzheozt4oDf
         6zijBBNBM5NNK5izWTKwOfxdGIwkICr0ihDVCBUk2EVCAmzSNOG/i8qw3oZ8MzDF3WYu
         iGDw==
X-Forwarded-Encrypted: i=1; AJvYcCVu7yjV8fwC1lh9ahGBs8vDD21IUxGGc4BeQm50F80X/pic1nzl1wcAW2kTD8hONFBHvb/QeKXVaQ==@kvack.org
X-Gm-Message-State: AOJu0YwmyjgxmU5Y/KKpHZCcUmIuV7whkObJuhBhAnBTdiogxYvXrRMM
	NySipOV3vASaCK3qQSKctrl6RC6bzfliY4+JgTwKTgPsD+a3joB+SitX
X-Gm-Gg: AY/fxX5FOC3frUcyEzbfvDGn+mAc+eYNyiIucMyom5EqKDbFDiUUeoXu+fgEzRdg1ON
	ucQ3hAmXTcVDxS0XtybDzAqV9+MpVGPcQeBhUu2X9FItXISIhvt4XyLqbcCF68OABCZmTilAIlc
	IljJZUeL5R90Tvmk4qih/5M5F5y+ZL8LcmC6XBM2At8wdX5gfo2U6e8uFinIZ9URyR/EZMqaaUr
	RLThiQYMQ8+1bASfe2JSK0HNp5SB6ot9RU1LmqbqKOCWBJxS+O0Y9vEEdz5Om3PJVECMHRkUT4v
	IBS9iBK0ORz04fuHihUKtXMomyqYw4dArHj6W32wE+uGbZRlHv6Ytc6+683Kq8z3YraiUiCu3Cp
	Seynps8QKLLtIw1+qt1MDgA2fk48mzm03WgUNyEFYZbTagUtf9JpMpGxlTR4MuAFU+n3jElXTXT
	CxKSIrGgpjLDqee4OsS6hVjnUZ
X-Google-Smtp-Source: AGHT+IHpFgNfkmrixZZ+F74LvnVN4Eq9WkGfpXy0HhazbWxSAkLnFJ2YH7nhaPG/TBJ+851izY8JtA==
X-Received: by 2002:a17:902:ef4c:b0:2a0:92a6:955 with SMTP id d9443c01a7336-2a2f2231751mr352425015ad.23.1767183196043;
        Wed, 31 Dec 2025 04:13:16 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d4cbcfsm331485985ad.50.2025.12.31.04.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 04:13:15 -0800 (PST)
Date: Wed, 31 Dec 2025 20:13:08 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	richard.weiyang@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v2 3/4] mm: khugepaged: set VM_NOHUGEPAGE flag when
 MADV_COLD/MADV_FREE
Message-ID: <4y4aht35lkswkaorr36m6276aktp65bywdtnj6sxo7koscj3qp@qpdjv47lc75v>
References: <20251229055151.54887-1-yanglincheng@kylinos.cn>
 <20251229055151.54887-4-yanglincheng@kylinos.cn>
 <084eee6b-6c9e-454b-a563-b2babb76b099@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <084eee6b-6c9e-454b-a563-b2babb76b099@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4DC3A8000D
X-Stat-Signature: 6aug76pbtc7azq61r9eo3ne49dx1xoya
X-Rspam-User: 
X-HE-Tag: 1767183197-706507
X-HE-Meta: U2FsdGVkX19S+YaUJp1iyoCuobSHvjALSI3Sh9XYBSBXK1B6kdMciJqmu6OMWGKpg944U+EM4VBNbxkJ582K9HgSSJuQEt0ue5EwA9e/1b+00hvGbDR0fX+f2a0Saw5btf/29r5rUOkPPbS9wEJ3wU2Epn0vrxpZDw1Eq+tK3bF78lfOecaZp6/Gr8VB7tzTYNOZvZero7jIaY/OwMRtEUTvhsNclKm5OPsY1OVZew9eI6h4Kq5bje5TPWVxyUWcFlM94ep5CjE1Rmub1JCWeFYGo8P5hAo8xWllEPB3bRyL8206zllwApgnYqRLddP2CW1bc2M3DRP4nwL085xZJum8KeYdQRyIIqDAGRhsZcL7vPzvSaA/X9Ipk1MW456/8YBNQTRL4XF/W0vl4Vug6KqiGytUC8OC6w0KHE/qxdYV0Jia9qHrXIooGND3R2LxlCfpJ7PcecZhLZbBhritcNfqxdUxiN4BFAHRq9QR/QZbW+7SpEvnG6ttqIldidNhpNKA9BXAfH11QjRL3QvlPWGokM63tfMGKp9MF++cdWQljOaaMHc9L1b5qL9az++Lp1vXM0NxrVhX/9ztQu2Fbbvm989KNzmFRHmVINgyNCfuNrNChBGOHfW4nfJjDEsE5oG4kX7no8+qFERHIbS0S+JV8DoVe60pR1FsNSmZjRUA534u7kMNJJmn2ivuWKqdRLHuU94URe6O6MTt8HsKyVr2qp/63UBQm/oYFy/YvxaTg+VRPxgh/bGsYOYLsJyuOZT75C/nILxUNfBUIo8QcwMF4Wagp8ZCOoDeAK+erszSRwi4QiqUpf9dYYl4ABGtdfthsfmv8/5iMnLWYU5Cwy2XXPixg2IxeccRohQ6Q8opvWQsorho5QNQEmPUawpE8j5V/O7UhVpXhAK5GB/YNpEm9hfcrmUwXKgZdr6O7Bmijjv7jQI+IiJPJWv1FBCCv2CUoqAD9UGxbnqSmVZ
 fu2c/7Ca
 bn23n9Tg4zRAHCpsYlu09AXu9QWWDJcoYg8BKhssfHWm2Qq4zNiUDqaO79fambkt3LsR14hlopivfcG0vq//fPOhJSeuOSj70Q82pKRgNH1wf55d0osj3l87XX4tuoMr60JjgbaM5rBkNkDDklr758laCHPCsFlRp89klejak3SKLbugRrgl1jdQTfsMDPS0zQVui07GjMbtjPkRFLAPhxyyNPVRVjy0gPENSAT6HjIOka7GjMqoSUt3XyYiU6z1/5C7dDzcFva/zhQqTE3n6UfHxD1HObZ71WJ133cWhvW0Yg4JUK1x7OoWGORyT/ryapq3GCXpqbUBtjAouc7ArME4CI6UOa9kngU9TnWroj0mlTb5cbK5JHwm0QwmuNNLC2OT9zFqaHtl6oga2Zhg/kEzO14xLAFbIyb9UNx9dybSZP13QITZqekr7UjuSRfcONemF/QNxYBBDZfGJ89Z0PGNHmvtdBYrQqfk4jdtVe64v1iJdk3n6jlCmbTYTdP3iZeDOH40Yj9i8m5cs4QFiTJ+8O+AeOU5AMQqHUlblKqE8Rwg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 08:54:33PM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/29/25 06:51, Vernon Yang wrote:
> > For example, create three task: hot1 -> cold -> hot2. After all three
> > task are created, each allocate memory 128MB. the hot1/hot2 task
> > continuously access 128 MB memory, while the cold task only accesses
> > its memory briefly andthen call madvise(MADV_COLD). However, khugepaged
> > still prioritizes scanning the cold task and only scans the hot2 task
> > after completing the scan of the cold task.
> >
> > So if the user has explicitly informed us via MADV_COLD/FREE that this
> > memory is cold or will be freed, it is appropriate for khugepaged to
> > skip it only, thereby avoiding unnecessary scan and collapse operations
> > to reducing CPU wastage.
> >
> > Here are the performance test results:
> > (Throughput bigger is better, other smaller is better)
> >
> > Testing on x86_64 machine:
> >
> > | task hot2           | without patch | with patch    |  delta  |
> > |---------------------|---------------|---------------|---------|
> > | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> > | cycles per access   |  4.96         |  2.21         | -55.44% |
> > | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> > | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
> >
> > Testing on qemu-system-x86_64 -enable-kvm:
> >
> > | task hot2           | without patch | with patch    |  delta  |
> > |---------------------|---------------|---------------|---------|
> > | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> > | cycles per access   |  7.29         |  2.07         | -71.60% |
> > | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> > | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
>
> As raised in v1, this is not the way to go. Just because something was once
> indicated to be cold does not meant that it will stay like that forever.
>
> Also,
>
> (1) You are turning this into an operation that will perform VMA
>     modifications and require the mmap lock in write mode, bad.
>
> (2) You might now create many VMAs, possibly breaking user space, bad.
>
> If user space knows that memory will stay cold, it can use madvise() to
> indicate that these regions are not a good fit for THPs.
>
> But are they really not a good fit? What about smaller-order THPs?
>
> Nobody knows, but changing the behavior like you suggest is definetly bad.
> :)
>

Thank you for review and explanation. I got it.

For MADV_FREE, we will skip the lazy-free folios instead.
For MADV_COLD, it will be removed in the next version.

--
Thanks,
Vernon

