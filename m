Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0535EF364C2
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 22:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F50E6B0088; Thu,  9 Apr 2026 18:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A6656B0089; Thu,  9 Apr 2026 18:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 194096B008A; Thu,  9 Apr 2026 18:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 05D476B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:00:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A9DB1B71AE
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 22:00:14 +0000 (UTC)
X-FDA: 84640386348.19.38DDE96
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5A75080012
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 22:00:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rAee5Rmr;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775772012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VsrdhDzOc6fgDfCoSa5sQlc5g5monky6noHdeAhqicY=;
	b=EHQxojBRi83C9BmPlH1lGN13hrXzFfTLfrlywBPhy1ZV36dmOZ/GRnWTEUu1yxxxDZ32/T
	1eJ1R80BwTujF/ZojwzXWJ/WmE4vZVnRmyZDXZ3FHEgg/pPp6kx4ghUex/6kLlrqOq2Rgq
	B5UBmTYGv+Tm1JFjgO4WFB28l2OLtAo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775772012; a=rsa-sha256;
	cv=none;
	b=Pk6tufUqdhOJ8k+D0sb462Fk+KCAbm7ONllJpsnXbUjfPQ0FPv36f3MvO3G9NhVKpWp94B
	jY3pI01Jz0V60kmLZtZIarIBR6nIJJB7k3JTrupF9I3+sl+YDgM2UOwMinlbcp7r/9Zatm
	RmYNrQBNOWv8SUOf3b8hMw3gv6nQ72s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rAee5Rmr;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 080BE444DA
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 22:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D4DC2BCB7
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 22:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775772010;
	bh=VsrdhDzOc6fgDfCoSa5sQlc5g5monky6noHdeAhqicY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rAee5RmrYOjU2GTndafJGpNfbSVTwltlnprAzAAJRrdOFopyqcuSp1dKVI4MXkTrD
	 1AK9is+ji/0RfNIAVARM8O2ZFhdCcbA/tqotqA3y/eTou61qlDzDM8kqptr+ZZ2rPy
	 qzvy7NpFOCDCKoTtGlfoT3zZRyjG/BqjdByEjw+KdYaYrxOw94Wu3SsX7ZS4gqMkuW
	 jhqfyBNsALMntmoyadNQbtgLOVTXJOtCQaQJCc2grVZNC3xcD7tzJzehrynLWKyRJI
	 +eJ8Zxct/ggul97IW0UTdiz2ONKOoYjvykUXC+pbQ4G2+ZDwdktzvzTnJTGvFQgCdI
	 RzgH66LJFMIKg==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8a56ca653ceso15777346d6.2
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 15:00:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWb5barDCfrp50NC/Hf7K/tY7IpPNkNotP6vs6ZYAzlRzthoyQgNjE/EBoVGNf436jx221GPKJ5Sg==@kvack.org
X-Gm-Message-State: AOJu0Ywbw7o4SPBKC66OJM6oP5DARgU2IrsmLhhU+UBq0UgkWsXdbJti
	XAHdD2nHd5zmhXatLL0qkbfOc3dU2n/RYNs21boroV28O2zClgh+iDhzyxTHk/jLpC5Tl1Sr5EY
	w4L4xVvwUpOw7Z3jiERIfl5Jf34zWiDE=
X-Received: by 2002:a05:6214:2f12:b0:89c:56bf:9638 with SMTP id
 6a1803df08f44-8ac86139e27mr9695316d6.7.1775772010178; Thu, 09 Apr 2026
 15:00:10 -0700 (PDT)
MIME-Version: 1.0
References: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
 <k2ldf7rk6mogzhoe3r7a2hpcc62x2uqqpnwk3czbet4shpirs5@sqfzsqpdc3fk> <639f20f3-9e65-4117-af9b-e37af0829847@kernel.org>
In-Reply-To: <639f20f3-9e65-4117-af9b-e37af0829847@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 10 Apr 2026 05:59:58 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ztHnGYycwRgh3FaA7gsehJUWG5YY5nMURRBS6BBdqQ3w@mail.gmail.com>
X-Gm-Features: AQROBzC-hWemrYO67grdylTzJUW4bkQBs-WCGHYW1hrlVrLA8CV2eaI3kGJHGJQ
Message-ID: <CAGsJ_4ztHnGYycwRgh3FaA7gsehJUWG5YY5nMURRBS6BBdqQ3w@mail.gmail.com>
Subject: Re: [RFC] mm: stress-ng --mremap triggers severe lruvec lock
 contention in populate/unmap paths
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Joseph Salisbury <joseph.salisbury@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, linux-mm@kvack.org, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: nxoz613xkp4u8zhxwqbogu3tiq8zdfca
X-Rspamd-Queue-Id: 5A75080012
X-Rspam-User: 
X-HE-Tag: 1775772012-161195
X-HE-Meta: U2FsdGVkX1/ZM/gn/Ir1/1hxtZKKtXCZzMM2yAbQJ0LPcUm2lmy27YwDIrk6HqW6hzBGjUCviWQM6A9np9SRIJ3O6h2ni6VaUdmggfJxZVhq+vkZz/qY2XWm9FpB5MeB1NO0NP756pLxcjPtTTiVqdXQZkRsoNHcFsgSIa8fZNIQO6qaXl3hTe7X7qoH/L7bZWy8eSf2qBRZBVWvm4f9cLLt8U5T//cbmV36BgRrbfnirc1ZaUBV29u8eXiujU6rptplC17UhBPUGvSccnEvypU6lWgIclk6PxPXvkO8ZGNdkcdeqcjbcB/jW9HLbQzx17YUxxMgoz8WvWpqSTyPrqZ2s7JJh+TSxrOTkhFCxoWyK2we+5rZybSh7WX0ZL7CniDD5tUZNWzaEHUnwbY7dVtHvndslOTIWOXANpsOSRvjdem8EY1c495GJaft7UFevWxVXViIPP7oWIWGpj6LWre0crHr0KZt9HSjwRPALI9QnxLyOvviaLHnj0K2hsQ+3+dSqdho2A49/aYNLMffzs6y7wmpy/jS26p5wbEY5riQHbcnWUaGkadQpCoHk+4xqoesOTdMfSEtVeNyoa5JinF/Qc2eW03XgLSmlbDhiPDDNsmuX7ngawklX1GC5KThKT92VkHnieP8LE/o8PSm8a8Xwk+yVOl53zB0M4s8yykz+O9yPkZk1yYkbD0b8C4wrSG/qCVxJCfdFxuRNa5AdqwEfaAATt9vFNLuUNrqNgJlxiWsQkBQjUMnlg9lVWnaY3zPr8csJdkSEWdGUP1Y4vzUFJl8yAZ6fl/EhhogTqaJ+TzA/hsHr5Weug4Dnn2Wh0+7t90RCHoZW5sfCytpuRRDPBJ3kdL85WdbeDuRp2uhoT/LFeix+yeBY4I7O2LIb1l6kbei2T5ZkGRjIcFXxLn5sThb86VnvqDxkDpmenM3St5CDpw3NRWy93xPqHb8N6ua6bKPgT9HpD1c1WA
 /Md6hSKD
 WMzrSb3+gfLLJrNorCo8Ii+JRI/CweMrc6NOhj9k5n2E9WRm4z7bbiBtVHqBMQp614HJbZAFO0uGHq7A/rh4X4EV+Ch6tKYIhlCHPDMBuCWeUVpR/qcZwce5TQnD9eTPVSMpnIMycnDmi2LwA28GjjiB9jCnBg1cpD5Idex5VzvDcYfqzSJfC3YIRa0K6PJ9GpRD1JbT47i/oLAIXOHdlMzdsYwIOo7DeIqLohZD5fJg26lbM6WdForJZBL3OozYPRK7NtC1Q3i62Xmb/eNcYfGpZv77mTTQqkdoIvvVzQBlwV6gtgxWfAR/+Lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 8, 2026 at 4:09=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> >>
> >> It was also found that adding '--mremap-numa' changes the behavior
> >> substantially:
> >
> > "assign memory mapped pages to randomly selected NUMA nodes. This is
> > disabled for systems that do not support NUMA."
> >
> > so this is just sharding your lock contention across your NUMA nodes (y=
ou
> > have an lruvec per node).
> >
> >>
> >> stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --mremap-numa
> >> --metrics-brief
> >>
> >> mremap 2570798 29.39 8.06 106.23 87466.50 22494.74
> >>
> >> So it's possible that either actual swapping, or the mbind(...,
> >> MPOL_MF_MOVE) path used by '--mremap-numa', removes most of the excess=
ive
> >> system time.
> >>
> >> Does this look like a known MM scalability issue around short-lived
> >> MAP_POPULATE / munmap churn?
> >
> > Yes. Is this an actual issue on some workload?
>
> Same thought, it's unclear to me why we should care here. In particular,
> when talking about excessive use of zero-filled pages.

About 2=E2=80=933 years ago, I had the impression that we might need
separate LRU locks for file and anon. This could reduce
contention in real-world scenarios, especially when memcg is
not enabled, but I never built a prototype for it.

Yes, this is of course not related to the problem reported in
this thread=E2=80=94here, the contention appears to be primarily
between anon pages themselves.

Thanks
Barry

