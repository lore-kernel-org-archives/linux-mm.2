Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A54AC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9986B008C; Mon, 31 Aug 2026 04:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65B876B0092; Mon, 31 Aug 2026 04:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B116B0095; Mon, 31 Aug 2026 04:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3FB6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:34:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A161580407
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:34:51 +0000 (UTC)
X-FDA: 85160903982.07.E6476BA
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9E3A6100005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:34:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XAv5bww3;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788165290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EKY5CGhOvyevo/P0TzoHSDtfqd60ZagTatW+ckmf+JE=;
	b=S7OIS1sMoez1HV5J1AjcX4b4qG/vUfzrDULSBg6VXuAN3a57lKqmvWsPOgZYmrGn3LVGTd
	WtjIbYCI4au44WdF0Ma70AJTE23+P6Q1ViA7nkua794GyA1VBgToGDLdmW5aRQizT7ASWG
	HsfSMSwnkKp4FAwh1XZJgHdwnNmIJj0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XAv5bww3;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788165290;
	b=r2zf35Pj0gkz/miY20rfXV/xejvHoVUnRw2zcoLzyDl4wwuTw72ACRgEoU3ffC2zAMdMO4
	x0NpOsr4nKfi/hJ5EbS73jhhyp7BE3hlqSfEuMcCJqMI83wUd0NHDNOSeCPpdbuQ21Ggd5
	XFdiDCdRFV/9gaMjwCzIsbE76gCSKkk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788165285; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=EKY5CGhOvyevo/P0TzoHSDtfqd60ZagTatW+ckmf+JE=;
	b=XAv5bww3qYH3fOsXIZTBE1NLkL8P4JV3FL0aPgIxb8CX5kMtqxhhCi5AHK0ChEA6nrQO+/7pMVvXjsceMlxW+BCKbaUOUMTT6yrWcaxzrS9BH/uJyf9fYWndWgzyAdx+7HmQfsA3Fzw4iw3HdfMGSE8M/6U+STLyw76qwjxmwB0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X9v6q1g_1788165281;
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9v6q1g_1788165281 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 31 Aug 2026 16:34:42 +0800
Message-ID: <d65769f4-9b6b-4da2-b54c-7ff5ce47b9d1@linux.alibaba.com>
Date: Mon, 31 Aug 2026 16:34:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/mglru: make type fallback logic explicit in
 isolate_folios()
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, baoquan.he@linux.dev, chenridong@xiaomi.com,
 david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
 lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com
References: <20260829074204.45304-1-baohua@kernel.org>
 <20260829074204.45304-2-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260829074204.45304-2-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: rtuorso6xuyc33wfpaxujjjefprcef9x
X-Rspamd-Queue-Id: 9E3A6100005
X-HE-Tag: 1788165288-526286
X-HE-Meta: U2FsdGVkX1/2XOA8FkIIMF19MEhQKll4ZTXm5KxhMQIEPs7nwaNswumYeRVZwFiTZqU7xOMddS8/rl4IMK2QfTgZsqnVqlzG1F+sj365Hb8Mz0pXcaK5gd7GuPfr4lZnlKqNg+TJHD5gXp5w4RAzNTCu7p3SXhLWNuMbDHsqO69ZNriLafFQmfg3VLhdfBl786wMtxLaZvwi1xYQQrCBoEvl2y4V9B6Q8OF6SJsd8icdjHy/xk1UsZtZEzHnThNeVwBoNsLdzeoqzLjmlSLik+MOnCgvGhdi7czvddym/+AHWDpr7gYkyBw8nQBD78/giRg1JLG/8unXA5AzHRntCry03XZ3r9wbwdqYzj02Fdqloe2CiKRCxyhM/T72ik4jsy04oP+EsImw8YM2K/D/JsfLmns+xQpQjgIzkW8fu0cvcRqItTjti1NOwscI29XdXXzo14/7eyDWQCAiQtjdfwQWVAa/EQzRn07qWirDYbCZH538q7RVB173VUm0Fj5pBI9DQui8LLDNpzYJhv9OM788elZDhdsZKoiZpYyWLiT9/za3db7THpgCEz77qDoLY+mLxbko/GuzCifGLSIddAoTCSN4N3AS+eitX6gke8zq0xLtoIJwaD4rWbXhrSdIHnjnZ8q/sO6DshX6Xz1IR7tdHblhOi90vMSzKfjvvzUOSU6WyQfQdhBU4o1vf7U0MIVRcYvmGjigtUzc5b35oCy0TH49ixAFtS+oEluCTRIlW5nmnmDxxOOsr5D2M8WOh7mqbY7r2IgglpuPMjre4o9/sj4m2AxgGv1eBpLu9EOie0PKwP6eIJioFB6iOM9Rh3imhsZ8sug8xko6kVAHmxhLzahZ+0OUyyUfaiuuPcDsjTVcXwBzhojeRqB5Vym1aynIEO7YRZbOTOjtBDGeuRxvUTK0fbaL6JMK2pjVXXmTDV964oHhxzXEn0KTeza7noZ6P1+jP4i8/xpVtWV
 y8JPkZAv
 HUWZq8kqzhUs7EhzMSgLGR66741b5x4mVW2ZntuBnVDUzOOYTgxpWoUZvb+1sU0Ph1Q6OZQ8rL3rRz2v5wgI97WEFsRRwyYdsyxwYNhDdIc0a+qqXVEbhPHsBUsvcRIY+xpgZDfESTrhIYSwItAeKIhFNLjrsCxsdtSUShq+cDS7ZhEKPGNwuXDsqI5OIyqwoiINwNHooNnEOT48Aca6d33UTML5YI+YXCG5cgeHIn7rPjFUEjJMrwkV+Tyb1QYTP+cutaPdOh0uVpfDmGTlCpypy6srTdLyfi/Qkdrf0kuZ5EP0k6hZ9M2GlrSUmZGbQ4t39TqTejHmzNuyR/vVb5Un1mwr4oVir/pjf8UcVS6QAsWq3jh5VsNRrGKgOQQJW3wKOYA0EJ+Ie/0HN0rykm7eJzWY9DKopw2rL5dCQqILR9xftTBNVlGSu+Bhi/Thnt73yteNVJVxW6h2AZqXBkA5crg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/29/26 3:42 PM, Barry Song (Xiaomi) wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The for_each_evictable_type() loop in isolate_folios()
> is misleading: it does not actually iterate over each
> evictable type. Instead, get_type_to_scan() selects the
> type to scan, while the iterator `i` merely bounds the
> number of attempts.
> 
> Make the fallback behavior explicit in the code and remove the
> opaque for_each_evictable_type(i, swappiness).
> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

