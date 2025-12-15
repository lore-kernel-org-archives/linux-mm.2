Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9EFCD59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 02:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13A3F6B0006; Sun, 14 Dec 2025 21:31:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EB6D6B0007; Sun, 14 Dec 2025 21:31:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0008D6B0008; Sun, 14 Dec 2025 21:31:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2C216B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 21:31:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 695E8C0E18
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 02:31:29 +0000 (UTC)
X-FDA: 84220129098.30.A0B9855
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id 90EC2A0003
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 02:31:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iotCXinx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765765887; a=rsa-sha256;
	cv=none;
	b=Bp8oPXU5C9mD4HMIBBXnr4by3MNbmB0mxyNaLJARon6CnZAYMjjt0mcd3spYSeeV8bNGiv
	ZH0N2KlsEx6aq0LXRn5m4d727PHGLcBCKrJ0cXy+NRxcJ0LMLrIS2wC+EOrXb9sqr5QtV7
	wphyyn61gRVhXYAO+y1QFdJhiWGV19o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iotCXinx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765765887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7DgcpvFl9leJgAbrbRvYm1nTuY066t8vtnJ50YAb+4U=;
	b=0hGejLLG4gA01we6jMJ7NweVncqKGsVw709qZNmD1btn9DBlhAF/f3kya5Tg2Kbe4Om/+n
	ZQSLrjcJaS/7+qJaIK0Cazp+Sj/JMZErW+s/8X0xSntRWfa7m1yTnmZr5quuQq4C6BypvK
	iB5aDAJTT/+1UeE756AjkfpOhwbKdZY=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4f0013c54efso10332421cf.1
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 18:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765765886; x=1766370686; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7DgcpvFl9leJgAbrbRvYm1nTuY066t8vtnJ50YAb+4U=;
        b=iotCXinxDAK2F1N4qvokNsFzUZgpcmhGoZqII3VMmSLenkmUHaWQe50n9mCsexrGaZ
         9KoDxdpFtmVh/Gnl0EtI8hMUX4SZguxK/oew7pzyfDaUgsrLeMnq3gerPD9yRxadYWe4
         WnQ2zmvWO1IZqFtrBVs4Y4PypydOslEui2Z+p6p/6XyQ0UrqXQZh+tKXE8uub+QpI8lh
         oBnzTCLxZ5MNIFKP824PBK+tzaMBA+1bMUbm9mIMpZQRl2aNf8XftsZlQS9WYuDn/5jT
         52TEnrv4OoML6xlMf/ztLKia7WBO+hu/0k9fBK/ffr7D8eZZcBnWl+GhaWeje8KKP9JR
         xunA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765765886; x=1766370686;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7DgcpvFl9leJgAbrbRvYm1nTuY066t8vtnJ50YAb+4U=;
        b=bByRSLo9I9DkUJh1EfdrF464MuiXt/UqoYAerdQtcfLQMSjBN2UAVSxERit5To0P/T
         mM3mOMjMVSWg9yOaCfvJX89//aLZSdhYWAcF4phnksHerZu7PUOa7YoUKld3+4hyzA7j
         f5asUbahZ6S4S5tBU2HXse8snZl0ppOKd7FeDDH5v4Zs9ZvrxWl3OGU7MtGnyHRCEKmF
         6jBE1ZBKJMqoiDFkykRZMxib2sHJuDnHMY8/fc5Z7GfleZsAbacig6MPx3ql6OzKhMmc
         2M0WxUfys/t6ocMWiXiMNSEQzOZrHKGPQOzuANhRhKuTuGY0ZoC+hBQgdE1gQXJtlhfY
         M4PA==
X-Forwarded-Encrypted: i=1; AJvYcCUIHYFeIbzLB6TA6I8bmjFip+do8PXJ5ym6ntiYn+BZuIKqH1QHrVyBP2DsWGEU3Wk+6tBxzh9vYQ==@kvack.org
X-Gm-Message-State: AOJu0YwLfYJxOkTZKmW8cqyFwz5cqcCVGXI8ScfkUpG9IqavkxmI6GK1
	RKSTV8axDkXmm6TjvGqkGx+sQonkn8E/narWRlFt+DXFvQbRhHSymvsQsYowtWnV3UFdXQtl2n2
	id8mYPYbd3DLIHMiedAE2QSErcLN38VM=
X-Gm-Gg: AY/fxX5hHC0P4QPJu8G4m1JLSDRjzbVQaErLzHZ8A1Tr3ZRx77P3dEbwIXe+MKv5HE7
	wg58oBXja5C7WSmz+RHQhIWhkBngBMsP3VzvN82RZqyq9lXj/Rbth/oB2IOGFIBW3F8FC10p+HQ
	/rDV6DUZkgprPzh0TEjy64l5YIe+0/BfQG6SM6rWXVS+AUvHLNNd57aWJN+NL53vVjtYM3RPskP
	N7McH3xpzq9X+N7zEqOsY8Od8k+ygiMqpPugF/azL7cV7nsXEtmcMZJf+S5bOUgCkVing==
X-Google-Smtp-Source: AGHT+IEtE+IQUmQG8uW2EepD0DgMtgDoVlx9oG7IA95Fi8ulE3llnvmojS3743tVdgnwXzS2nMLY000pczqaKPHrAQU=
X-Received: by 2002:a05:622a:8c4:b0:4f1:be1a:4098 with SMTP id
 d75a77b69052e-4f1d06283femr131897561cf.64.1765765886366; Sun, 14 Dec 2025
 18:31:26 -0800 (PST)
MIME-Version: 1.0
References: <20251215004836.694-1-richard.weiyang@gmail.com>
In-Reply-To: <20251215004836.694-1-richard.weiyang@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 15 Dec 2025 10:31:15 +0800
X-Gm-Features: AQt7F2pRfV21YjTfLYjqxSmS7cdTbUCqZLwYS0Vjsaos4OsVRyayyeLMIloOEhA
Message-ID: <CAGsJ_4w3535fwxa_WkkQLcfNjzRkJYbBJ0WfpYJ+v2hwovdvWA@mail.gmail.com>
Subject: Re: [Patch v2] mm/huge_memory: use end_folio to terminate anonymous
 folio remapping
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 90EC2A0003
X-Rspamd-Server: rspam10
X-Stat-Signature: tcqc7tboz6bwrwn7chifb4kp5o1q99ho
X-HE-Tag: 1765765887-178615
X-HE-Meta: U2FsdGVkX19hU3zCV8gXZkhtUZxUYN7X+gFISJey69L5UeDs5RZenWdK6wOm3mCBvahFSaiik9gmFEvoSAWNH2Jh92lF0Ox39l1ImmCXRFoh49FH9U/4hpDXiapzorRUf3uJuS4VMnwIZtURJxuqWgL6twLxYCwyMtwKiKfUaYIa3ir38OQYpCv/fWx85G6vG1uYLqswFAyqBHIadN6CyTncU6wWshv08oC1wWuixpvjaS3G8Dxrb14ev4EjrQc/jQT4wEhdoF20TXthykHBMo6ED9vHFIJPeUOfll+KVFmX0SxWkXF7RQ1a0CuGqscnKPbGNwYwUoOPGOGsh5PjrX70AtlB/EgHxlMr6JD70AoCIsBzvqN0osVAJEdoxMGB/xc/2Fy3Ngt4wSFwvaxdj6DIfV2BthhRBtw6bwnB2HEc/tpHff8wrMpFs5q9QaspWgHoVTLuxp6gLYE6AlZztMm9t+Gi+sL33yIyJHfrQ1FZ0aLnl+viXLdLPG1LbECcw4KbfGXhRoC3v/fiRjWJBVPL1S54rn78iy9jry/gPuQ1uZLZJ2fXHrpPABeclrPvAZsWXBwjolp94tnu504iGb3T9Q5YfveV5UE+gYbIGD9EXnaTUeFqOFfjGTnmJW4l6C3K88whRHubjm4HaplXvhcCaduwCkZHKryBLM00P/Mqu3QZuELEuFfW+b0T7+4dOiADXcfrtepMOzDpF//Rk0dAT41JHJvyiOzb6VfmpXrJrkFa0rV11HLaKMeYpevu8Ls8d0mgpf6u/n9SICX42ITtLPKeQ4f/qFLkXCfjyvGGr8bvqyU+8vYBrOg3fxg53YzgwS4/vPQVUNGuvefiTtdulqA0whmRiaTvv8P/SJh4CpQlAoXWRR7mzEGTkDLc6hf9OP996Mi+OiUMGuKWsQ4tyJmVhUx6HMCHMqRVC1jIoCXsShCx5cHq7/yFYFdNMdpSqvootRP3BJskYGG
 nAehomOh
 CTD8KzPFUvtEH8TFuGbn8aBjwlCvVmMAKhGnB+AU3SkP+Tad7GVt+edOcW8w6IaDlg/frGDZyH7SzcLtneo8U0QLz3tJO9ekL1LXSnIU7Q048uo5/rPQXekZTk8DBQCRD/cxtVecQotIu7MH2x4Rvqm4uyn1UaELnoBEo8oIeS+IHPTCMe4MmBQJoHtoPwqgb8UvUT2JaVUh08Jj/oWX5X5+zKxE79ZnVBdFU1Qws2Olfn0zs33sUQVwoi4yfuSbcHji8Z9qpGr89bk1igcSV8vuQhjU3IZwTfu9U0FE8aNVkAXgl57/5iJ1qCyL+rSS9b69IKH31CwDpyMJU8B8tnltUgzpQy4gzc6VomLMQxJf22mieRlrCNTLCxzxSTKIoSdfr5AiCdjrFI9sGMO/ziX2IQBp0YYU5/Rk+7RZmqLvcM6v1xTVGQEImHUtU4p/T8QUt+Nes7IscBS0hxeDwd3ADqzoZiDCTPRX2lnFDHUKdqU+BH3Jgqwi8xJyyTpkh+AP7WdSn2/t8uMo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 8:49=E2=80=AFAM Wei Yang <richard.weiyang@gmail.com=
> wrote:
>
> After splitting a large folio, it is necessary to remap the resulting
> anonymous folios.
>
> The current implementation determines the end of the remapping process
> by counting the number of pages that have been processed.
>
> Since the final folio in the sequence, end_folio, is already known and
> tracked, this commit refactors the remapping loop to leverage end_folio
> as the termination marker.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
>
> ---
> v2: move folio assignment in loop
> ---
>  mm/huge_memory.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 40cf59301c21..fe812d9c7807 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3423,20 +3423,15 @@ bool unmap_huge_pmd_locked(struct vm_area_struct =
*vma, unsigned long addr,
>         return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
>  }
>
> -static void remap_page(struct folio *folio, unsigned long nr, int flags)
> +static void remap_page(struct folio *folio, struct folio *end_folio, int=
 flags)
>  {

Do we actually see an improvement in readability or performance?
The existing code feels a bit more readable to me; nr is clearly
the number of pages :-)

Thanks
Barry

