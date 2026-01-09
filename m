Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4630ED232ED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 08:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CA096B0088; Fri,  9 Jan 2026 03:32:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94DE96B0089; Fri,  9 Jan 2026 03:32:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8580B6B008A; Fri,  9 Jan 2026 03:32:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 749886B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 03:32:21 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2CB141B772
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:32:21 +0000 (UTC)
X-FDA: 84311758482.26.D74F076
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4165D40007
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:32:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DM7J+SxL;
	spf=pass (imf27.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767947539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H5FICVbCdpL28fxRZxhccvb+qo60S0uzBKWHTrHtW50=;
	b=cnFEwJn1pSKN6Y9ctLxs7Ij2VwYeCGYbiZVUzDlM1yRuTN/Mnanq3rgaonIK84jHJo/i86
	xZKBTpOtpteCGY+zVt6GYbLmvoHAjuzEArxGl7g85nK0NKMIKcWjtQ3JTje07dwxnouYqE
	IxI71cJqVMwQ+Ch8e47Fwl8iMiY780w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DM7J+SxL;
	spf=pass (imf27.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767947539; a=rsa-sha256;
	cv=none;
	b=jP7LRN33JLHUbimSvSGCtBQ7ojImiMyj0BdZFmtINEtf4C0/ETl3fDMRAK0qqtrvS071lW
	YifOYof7OZqY/UIqaEbF433pcBuHEeAWaEGKcl/DKSNoMuYy0qgLcFLrxV9xTo5RBKrScw
	K6r8P9cHSNiDKVSm4mbotCIk5TxA6m0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767947535; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=H5FICVbCdpL28fxRZxhccvb+qo60S0uzBKWHTrHtW50=;
	b=DM7J+SxLxkANJgLXHCwJyfkQ/DnkOAs3JErng4HZZhLz6DTMUmoF3ZSv+zju2sHvlMQiw3fG2F5Q9CnMeaHVyaFVJRjC6msoV/OTH/fKECVhk5W1JvtnDD2knjsVfkn9H2cj/IiBz/KtGcrScQxCga/Fgg5nUg3a6RVyuvoDBno=
Received: from 30.74.129.18(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0WwgBVo0_1767947533 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 09 Jan 2026 16:32:13 +0800
Message-ID: <f9d1c2d2-a6d9-47b7-9f1d-382a28bb88b8@linux.alibaba.com>
Date: Fri, 9 Jan 2026 16:32:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] arm64: Kconfig: enable ARCH_WANTS_THP_SWAP for all
 pagesizes
To: Barry Song <21cnbao@gmail.com>, Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com
References: <20251226063759.4020782-2-tongweilin@linux.alibaba.com>
 <CAGsJ_4zd+SMa4Mj23tjF5OwsP3LQyvYTrwN4y81=k8FSFgbH3Q@mail.gmail.com>
 <aV_3fxlzwOSz8B0t@willie-the-truck>
 <CAGsJ_4waQsxPKTcGvtpTAF4kVbYQXeH_iHaQX3aAYDNo-8oDLQ@mail.gmail.com>
Content-Language: en-US
From: Weilin Tong <tongweilin@linux.alibaba.com>
In-Reply-To: <CAGsJ_4waQsxPKTcGvtpTAF4kVbYQXeH_iHaQX3aAYDNo-8oDLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 71he6j9bjyyjs1bzcqe89wfmwn3e8poe
X-Rspamd-Queue-Id: 4165D40007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767947537-418080
X-HE-Meta: U2FsdGVkX1+GKsJlkGBHoMJrOY+lAPfJqQNiGjaigPA/rPAMtfdVlHKv+3e2O8k7kWusPp+wnAOFCw6ii1rrCHnP2a5W0QYLJQwBCj+Wd/mafFqNe+AJWMZ0+c6NV/8MYfeLakDvXBe+CPvYU8qniPYylh7V0rt8u4opJtMpu7fB0H+PKmbQBm4Zms9Vrmg9peQ9hZLtEn0OLQc5BKqkF7cMxXT9lng4EXqetX4uEfFADz2BtDhsGNXke0u++8mAPmGj5Q0SdYZLpLbl97QMHaYJokbqXXfs3Eg6P3YDm33IRPL9Lp/8NnlPINi5IFrbuZtp1afWDtLVICXlbG7n7P/YdyxkON6pmCCBobT7pymNk/DxpTRwhBbd+rcfMV6U1/nJ7qcISmQ9SIaziCQB84treiDHz9f+bxf3fruePnQEUJ8gVTiem5y66xdknFS4Grvj4qQfwLT75gTPki0t57q8hmERicGcP/kNwyE/C7yx5mcSMqJpXA3L9YdgWdlE+37Fe4Tax25VPtbEbx5vmIMszqEw3vyLU5fyGPc6WQqHSmB2UlIj8FFnAKTXff9ju9okh7BzAKOe27zAP0FHFNP9d7dLl6y+jASNGODLRGHf6uMohQkJBgGd6DFKuYZX9ZUCI2g+3+QIpuZjapRfEyu824nQNm1efonHHWRHM9aI9oC7L9qN6P4P3iShU9Jpu4o5uUPf95hUuo1G07Ve/JQkt2Fq+OWviCte1NXB17KxvL+24JFYugQ+pwkuLW1ttjwiYC3JKb2MLrvhgc2kIbL8YvNZXmuLRzMaCiRk/tVhzJJbgZjrUs4cY7AyIbMnZgl5ABoUknAevrClnfd2aveSvBc/rUDNvPFCy4qtXxO8jz4aGvoZvHhagg4vvUuzJ9cUBTYa4OTiEK+8HG209yaaeDMereINPAdOt5RlsCfCC7IuPF4545BEEm6KxXoysw4EBR8+jPKYu/Vw6o+
 tIVXWgPD
 jaD+D4j4+3IgzxplyE8wTS1f9SWj7pqDUfLocJnWAc3Oo6HigEQM7DBCxFh9TDB8EWtG6qQm2oCLthJxaXsgZRdPz5Lc4xblqYO5j5HxSggZFVBgavV59MFxE2d0eOPeQ3li5tGANM5+WeJ64MN0NqM8eq+Lkzz31GMTg0wWMGcrvKurIloqatfc5vL6oASprMghfna6LGNlSxSAcFAqt12vXu2OkutMoRH93kiC3tTNnQHWZvJmuzvtRHyOuroKJMpcbuvgVvQyuya+d1zvWRS47xNfq6aeFvL7jLyau7bfo5jC9H0oPUJ5pJDz+TOVuNNwjsZpjkbBEnbZ5t/Df6/ZZwYHR5NqgD/VNxFKWi62SYhFVUwvbI1bgo9RY7+S37ToBvTYv3puKJMx0hO3ncoJRybdpPHn0OPDO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/1/9 07:11, Barry Song 写道:
> On Fri, Jan 9, 2026 at 7:29 AM Will Deacon <will@kernel.org> wrote:
>> On Fri, Dec 26, 2025 at 07:52:44PM +1300, Barry Song wrote:
>>> On Fri, Dec 26, 2025 at 7:39 PM Weilin Tong
>>> <tongweilin@linux.alibaba.com> wrote:
>>>> Currently, ARCH_WANTS_THP_SWAP was limited to 4K page size ARM64 kernels, but
>>>> large folios requiring swapping also exist in other page size configurations
>>>> (e.g. 64K). Without this config, large folios in these kernels cannot be swapped
>>>> out.
>>>>
>>>> Here we enable ARCH_WANTS_THP_SWAP for all ARM64 page sizes.
>>> I no longer recall why this was not enabled for sizes other than
>>> 4 KB in commit d0637c505f8a ("arm64: enable THP_SWAP for arm64"), but
>>> it appears to be fine, and the swap cluster size should also be
>>> more friendly to PMD alignment.
>> You seemed to be worried about I/O latency in your original post:
>>
>> https://lore.kernel.org/all/20220524071403.128644-1-21cnbao@gmail.com/
> Will, thanks for pointing this out! With a 16KB page size, a PMD
> covers 32MB; with 64KB pages, a PMD covers 512MB. So, Weilin, are
> we ready to wait for 32MB or 512MB to be written out before
> memory can be reclaimed? By splitting, we can reclaim memory
> earlier while only part of it has been swapped out.

I got your point. In our production envs using 64K pagesize kernel, we 
only enable 2M and below size

mthp, so swapping out as a whole is a better way. Or maybe we can set 
the SWAPFILE_CLUSTER by arch.

I will do some tests of this concern.

Thanks a lot.

> While splitting down to order-0 is not ideal, splitting to a
> relatively larger order appears to strike a balance between I/O
> latency and swap performance. Anyway, I don't know :-)
>
> Thanks
> Barry

