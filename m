Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ABB6D2ECE6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 21:36:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5916B6B02F2; Mon, 19 Jan 2026 16:36:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562306B02F3; Mon, 19 Jan 2026 16:36:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 464BC6B02F5; Mon, 19 Jan 2026 16:36:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 324476B02F2
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:36:30 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DFD0DB7C09
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 21:36:29 +0000 (UTC)
X-FDA: 84350022498.07.2D10E28
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id ECBC41C000E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 21:36:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j2FI394d;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768858588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIySP1q5PMnveIa/i279C9yGcJJ4/61I44p5rwmCYqw=;
	b=acIw7DjRU6R43MgG0rvEsTn13DuHHAdBcGnSOk6RnKl36F1KN9LbtgU5QSrF8O3yODRX9L
	+wUsk4Zrk/8cgynKL9HUVbRTXg9mWXh8liZJ3+6CX0YNd7o/w+hUPHNb03LKHPgf62nnty
	VlEkUZu5MUJvaHUAMT0+fWfHgpCxyus=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j2FI394d;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768858588; a=rsa-sha256;
	cv=pass;
	b=IJfBY8Urx9iJDD9bkUkxfyvdKobaBumUiu8EqCbfjCPaBTFLpL57I3ckMJq1WwldXRelCe
	fmoDguurInJ3Vo0k/4UUdJv2ra7v5OoT8+mq8s//hKa3lyEDnU4IO3SN3ZxYrU2YWwMiwT
	BB6Za7ZGTAtQw0+dk0sDvav1MT9xjLk=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-432d2c7dd52so4330545f8f.2
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 13:36:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768858586; cv=none;
        d=google.com; s=arc-20240605;
        b=DMYGutu3qo3M6ZF+8niQe/VE3a/tu7FNqaJ9wNbWq/WWRD+9/rfgGncJSNNGP567lx
         d55suJNr490RTC1COju26CYXOdV+tHBWXewl2zbbrzLuD3KR+QItrqwBj27E3IZZ5XQA
         cPQz4XigU8Iw4QOKYQPg3adTYd0IfGYYP6fwN39d0NmLH7P0vsUtzRHEBn5+3GjUsApP
         djvF8c+43YwMa2YUooVt6y+6lyx8f3FnSVJp3l6rIAr2IiUi+XL+l1NhZZZqmzWZvGqF
         /yKzs08XA/v01hLbPrNjtVGsA9M03Jkupsdg1emRInQPerSBjWeMTfp88YPYBLOVevh+
         WaqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZIySP1q5PMnveIa/i279C9yGcJJ4/61I44p5rwmCYqw=;
        fh=jwmrTmZb6RV5fALdxmGA+po3B1LjjcMhMbEIBisHDJ4=;
        b=LWc5Wln/rj8IeERDRHofEmp9XfAuZFpKW5ZK826CJIjKQd0z6BufN1cMgvOfK0xFvp
         pO4HCn1NU3HmLwi75UQCY24hDJhGAd/1wPnRnMPQE8hIH+1o2nMmpqq648Hg0eM9PmrG
         avnq5CZ4lqhME4LqpJjLtJlKF/+wAV1Pnnz5HSBSP5iiTCy7keH8Y7fQ5te29hU/Uxmv
         ZPNr5mc6TlX3RdkBtoHu12fgXeaBMsHgbTbmd8Za8Jhie5mK3/Ds8XhYqS2d+ZvFTshr
         wB01TZ7ZeQGhD4YMI4LxWVEvGwFDz+j4iX32VQ3yN7stSBKZzsWk6VqtrZXFzMNuD+1K
         vL6A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768858586; x=1769463386; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZIySP1q5PMnveIa/i279C9yGcJJ4/61I44p5rwmCYqw=;
        b=j2FI394dL5Pj5fA8N64t6yV6BlB/Pg/CL3UKID76Le2MeQJtQFvGE3sSSPI3U0NNPi
         6CnIQVYFmUYrEdkxC0FghPwbWOvg7kzEY3BmlZQPmSoHNZVrEJKZA+DAZKosmo7/SXuL
         VWd4kgdeHH7ywosimSXgr1ZWtxtmXN41/KbXXmPOGWOFQ/8I0nD0ddrcE/uNsrm3G5Cm
         OcMz0RMadrRJZ3B9SYmBVMBXzFsT2/jgnkGPqWO2fDcdq2LN/0IKE/75jbPjasJoONkF
         EjsTSzb3LjPajWhfr9vBAnLqFfU1hoCJBy2H6bklffMvPMVNxeFTJKjz4OKU9xxaN//Z
         +gRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768858586; x=1769463386;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZIySP1q5PMnveIa/i279C9yGcJJ4/61I44p5rwmCYqw=;
        b=QiyZiYkntE/JIhdtZ+z8s4fUhMbVElDEU1rKbRTtRh9gKV1M071kyM2AWG5uCJH6qX
         VDYoS0fmJrlu90kLG/3xDOfaBCxKlKYCAMNIG5celTo0pZ/ARMaWdc4Tl0+oGQJDbC3f
         kRrg3KgMNxM/N3ylzjsymMlWHf3VU5jqpYsJiWFXQO1cHsQqOFpe53NYwbHlcLXEpTX5
         FuA4fWJtILnzi3/QdilDFMiXU/6Qq2L32pTqFmK9wwhE8JH6np2JCeeUqj9K8jym7BUN
         bs5XvDIKJU0Z8lDA68EDgwGZMhb+hJngqwEzGFvqMjk5Ss7wz2QSMot6oGqVOOh5xlg3
         GFlg==
X-Gm-Message-State: AOJu0YwcU8F+yP8qUpYnBzhXnRkFwl25RTTKTLQEMr1OOR5kDjOSXLhl
	zruhFBjlDCDRonvUwYPYnAkHYWwjn85TkhvyEy9KEuCGRJsZTFAiAwkKtw+cvL6RQS+8VTjXnVD
	anzhLN2pwVTFpFmERi0bF3ioP3wCTGrE=
X-Gm-Gg: AZuq6aIUwM6IgX/Yq1FvgE2cKwUBzifNKAP4p0/LGoOmkMjYs+vlu0QVGqISae+kvwz
	doyIDaVaJx774ysRWGVmByJxqB2MjtpidnPVSRgWcZjX3mewyjF/bJIba0vx7XBaHX6LEN8qrvR
	o5dJFQG/KVX7vb5MhaO6x3d5SrL+bs4qE2hPForfnUCqSDhjsoaodS9jTXNYp7yJbEtmBv3XTCF
	lJHMfKAlSUlEajhzzvLJUtEZqgHI0JQ2jIlmIOS0R1M3IPBFc6sP7Gz5o+t1KHR79taH5w=
X-Received: by 2002:a5d:5d12:0:b0:431:266:d14d with SMTP id
 ffacd0b85a97d-43569bc5b27mr16203443f8f.47.1768858586150; Mon, 19 Jan 2026
 13:36:26 -0800 (PST)
MIME-Version: 1.0
References: <20260120-shmem-swap-fix-v3-1-3d33ebfbc057@tencent.com>
In-Reply-To: <20260120-shmem-swap-fix-v3-1-3d33ebfbc057@tencent.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 19 Jan 2026 13:36:14 -0800
X-Gm-Features: AZwV_Qh0t3pt4cR5MdFu-yA0efJKL9TMIvNsuFSc3OuE-QMB2P_HMtg_1D-vSZQ
Message-ID: <CAKEwX=Omzgh92KHhaFi8-mnZ0myV1yi6XMTkT4FFsFPHFnueLQ@mail.gmail.com>
Subject: Re: [PATCH v3] mm/shmem, swap: fix race of truncate and swap entry split
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: yqnqarfyos66epjo7gmyfsqn4mks4re9
X-Rspam-User: 
X-Rspamd-Queue-Id: ECBC41C000E
X-Rspamd-Server: rspam08
X-HE-Tag: 1768858587-52094
X-HE-Meta: U2FsdGVkX1/8Ww2xKTXAMC6yMaZ0idxqbt7mF1DXfrk8NoXD2Xt9LKvU4fgbxlhCWZoEW8n5fDrw/EqhMDaP8SNlKMwRNtJlB+/IwIM9pidXWijtjfrasuNn1Rg7xnVpaeTCyvgH7291RZAeYKCiVv4CndWKk7qccdPuWJYMBrjkr4KKveUvoEh/OEP2xPzEY+y/+8XWDIrMZ8s3nskJJ+CdcGh+4f6UvsbMRJgBYfnUQwGUa3o2O9mi7kQ4ajq/Xuad9diR9o/RWfVybs381eZ0RUexZh6vM304MybgfPw+yrbdBB7ZaDRHCdSvGJ4cAXVRaTFiw23uCJmzOXKBtfoZ8Rjjnk2Sp/IrA8JsiaNVfrvIZvWhnIbPaWuoNyZUdZo8RmoOl+anbxR+dzNT3W5tGLC9c8diHDgw/IgyCjI7+jENjoZRzWHxlEmsKeYQ2qJqXiXzFG/aiESh6Wro1RtWRAS0Md4sGb3mmWpDvziNim24Deqfope79mGq2UqNOWE54d+lxOaCON5yyzQMl9gwh+BU3wBmKRtz9FDPF12Bd31K2hGb7F5mmUhKKRLP5rD1L/l5lgeSbhSex/7DIqDEuV7h11HPyO6LWRGiR26t4pN4HhL6MFiXIgJKm35KfAcDNLbLU5op5USiMmZTOXaDhKSxkwYqxuUmOG9t2gaIt96EWBlm7uqJHIzNjdpWc1JaNgM3EVqzxA09mxKX4rvKZaL93zXjc16ydaUVgW2C1X6guAb0MEXKlwzJOsmPN+r3w8f4hjIUhTQLVyWJyo8QD063kfh7TXa18hFmdtHAHWSzxy6zcUEYMCydFvNg8ffVOCD74ddIk2+G2UcX0vXulSUK9MFjjGfr24An0PVBWFM6yNEllRprsx756WzoWbiIVsefANJtX4V15eO7lU0zI473/XyoFTcWLujWOYT7zvzI3g+2qRm3LW9owSPtfBOXg4SBJGW2tH8gg5F
 eXlMjoxY
 vgEmqXoM2vwvQo84iE+41K33d9hjKmRMbj57udVRDi3zJMz4G7UMIv3YYv0BBnzuKZ6UENVVRxjT6ByHCtI3TVjsA7XIJE6QysD0h6cs5cHZy2AUkmbb1ULSOgRPMqwPVyuBeRExEBNvuyb7S6aPPLCWVkSP5QXR99OYyRDeuEL3CVpCVjcYAZ0BWmq744tPTcYQpNZGON+U6Ci7N+PIjnS4ZxWVwggUrkRvXal3MgoMdbmARxfTGwaiQGbaeqvsuo0aZU2IQoRbDLrj1KTaOXjLfEtBu1Sl3zbmHagCVz++xvnXbMJzf4iUunGy9IDFLyqHcQ9PmL3pkdboDVE0s3sJG9vV01G3w2fgZLsaUKjnhXQgKm7G1KvyMvNXDrPB+WiYZfN+2x6H9PP3SchApdQCooO1knVcQvOl9rqrKjaCv1vqYvPa3HiUfDab6jY0RQufb9rgz0rOUzq8toM6yljkYdE8/NtkYUpPS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 8:11=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> The helper for shmem swap freeing is not handling the order of swap
> entries correctly. It uses xa_cmpxchg_irq to erase the swap entry, but
> it gets the entry order before that using xa_get_order without lock
> protection, and it may get an outdated order value if the entry is split
> or changed in other ways after the xa_get_order and before the
> xa_cmpxchg_irq.
>
> And besides, the order could grow and be larger than expected, and cause
> truncation to erase data beyond the end border. For example, if the
> target entry and following entries are swapped in or freed, then a large
> folio was added in place and swapped out, using the same entry, the
> xa_cmpxchg_irq will still succeed, it's very unlikely to happen though.
>
> To fix that, open code the Xarray cmpxchg and put the order retrieval
> and value checking in the same critical section. Also, ensure the order
> won't exceed the end border, skip it if the entry goes across the
> border.
>
> Skipping large swap entries crosses the end border is safe here.
> Shmem truncate iterates the range twice, in the first iteration,
> find_lock_entries already filtered such entries, and shmem will
> swapin the entries that cross the end border and partially truncate the
> folio (split the folio or at least zero part of it). So in the second
> loop here, if we see a swap entry that crosses the end order, it must
> at least have its content erased already.
>
> I observed random swapoff hangs and kernel panics when stress testing
> ZSWAP with shmem. After applying this patch, all problems are gone.
>
> Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kairui Song <kasong@tencent.com>

Good catch.

From the swap POV:

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

