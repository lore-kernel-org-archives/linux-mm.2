Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B1ACD2502A
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 23:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C5F96B0092; Sat, 10 Jan 2026 18:33:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7736F6B0093; Sat, 10 Jan 2026 18:33:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69FB06B0095; Sat, 10 Jan 2026 18:33:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C1D16B0092
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 18:33:46 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC8971AC5B4
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 23:33:45 +0000 (UTC)
X-FDA: 84317658810.05.B4C3383
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3D9A08000B
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 23:33:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=H6KSlHuT;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768088024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t6q7M0IjRmz0e4y2OvFw1dUdAZG4DPwgAu9x6yI2TYE=;
	b=CYfv37LmDLPcVYQ01o+Z7azq0oKh5sJrHOlMkk0ZnKBtsy2po4pAwnzGxJIfb5/SwTUqaQ
	0etshSh/6BZx9a8uWbG0yR+QZCJ9G9ImGrTyLe34Usqzb6kRecyENMsWhsASPOwM8rEtNH
	Xe09teU/qXxbNd46fTYWjvSn2o0HrYQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=H6KSlHuT;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768088024; a=rsa-sha256;
	cv=none;
	b=OfkR/t3BMv7ikzwdskrbSEQFf9Q6+7pJCGdz2XHIp0VcTc5osRU4CYnnr0HrW7MRACbJa1
	guH49CvTdXeFzInI5U6Ew/RTIIoDeZRlb7rQRVKZqpS6fsudiroOx3cqx5wPa22ybpp3sA
	sxYmF/nQciE8sT92ViqXkzBf66h0vDg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A6A3860010;
	Sat, 10 Jan 2026 23:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A32C4CEF1;
	Sat, 10 Jan 2026 23:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768088023;
	bh=e2sYFvxqf2oXVRxryUmtDGwxS+F7IW+fdW8ehSlHuC8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=H6KSlHuTQuj+XO6tT+K97n6UdIUpCQNL5xOzjBZtL/XVGYgcnn3SdwVNcMe3K39SB
	 zfzmPAHYElbee7Hjx5MuvVlhj3dQQhL4cH/DaohiwWVQSfonVbQ8mHmdS5ALMMRAht
	 +zPpclEJOZVKbM0sXj1MaKDj5sIYq4gUFYM/MwsQ=
Date: Sat, 10 Jan 2026 15:33:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: optimize stat output for 11% sys time reduce
Message-Id: <20260110153342.7e689e794ce43a0a39c699fc@linux-foundation.org>
In-Reply-To: <20260110042249.31960-1-jianyuew@nvidia.com>
References: <CAJxJ_jioPFeTL3og-5qO+Xu4UE7ohcGUSQuodNSfYuX32Xj=EQ@mail.gmail.com>
	<20260110042249.31960-1-jianyuew@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: u485x6gy3i8tah9sg9cr88wke3dbz57a
X-Rspamd-Queue-Id: 3D9A08000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1768088024-720147
X-HE-Meta: U2FsdGVkX1/JhfTpU1pYQAhtCxqCU/NXvKhCU2BkYpzo4zdDQSl5HmQ8T8CcsDkwwPFgQe0BtWWR0vo2ms+VLBUrSagDyB58ynmaMB4PIC8hvax8uchQAcE7tobSJW8isD5nXjiW5ngKhrV6jqmOSh4iWQl1TG+/ys+ziKRnTrlpUeIfN1z9kc2MsARLmaJbwyy28cr4FTZVFAsQiOAum7XkK8b65+v3dBIBX74gaRYyDIcnt2XXuPM19awZzjA7hiZtpoC0MqLln9ZPPZmBpLRa7ZF3e0f8pIaVSq9c5lgWxexbRpJn85RjCCfQiW2kyamGoOtTk/zs2eeYYagHgyjW/oqFNsYDZqUG8pREIsDqkvIkaUytmYK4AuNS6twK5MSeNFuBgx1Sg6ZcsajEKUvISbm9Wcbj1GHW7NeQd/Up/L69h0Co03kFEdb7Op3yYa7MXSYlC9cFC1pMnfua+q5PMKrWLCG8+MNUl1E1QGa1zYCO7yz6cQuohtB1K8Wgy5wnyb9wJ7aSwZ7MIZm1KD5y5kOV+YYP1fpEe8lBtqCuRjWpXGWWxH2l/P9n8awIT2Dbr6r6Jn8/8vN3ZenZ1vkLvMNsvxBeTtGk8yGKFfiEKGjwX94j4A68MpSPO6O5rDkwUBv5SJhEJrZGWxn9PIuWvX5vKLnqxyCt5Q+NPkiqSqg+tveM0XDoWnsz7tLExAsTJYK+TfYA7m3bKHXJC5mEJ0ajzJbvOn0lbfsYOk1km1lSe0fcmd1BHBrLl3fAoUiLbGFqbrdzMywXuHPlwoefSHTWK4k9XBpuMQWNRYZEaq+Epn3pRLVmtZwXJSZm1y+iuOXnEizmzTQrIL7T99GfV8XS1AdT0tO5i0NdrU4SgYn7ycJu1DpEAWYK10Oebxfp2A7F8HIAFPWg9bKt6egHLS8uVZ1haY0mDeHCuac7Ij38yZkYRigko8NALg0z6ca/0UctVMs1nknT7fF
 GUhhin6Q
 okkuzHTQtDvijGazANzUabqFvor4DD3N3pJQNQ33fFCzrHYfIgVGfEw4syHXKU6ghnW8VXTJGAgSsz6K88oeVWIcT8ccQ/8xHVPNycKh3vCmho/Q49Ja93NAEyVhZExO/3oZyL5hcd9/EtdriHewfvXcF1qxov3dl0NVQzI7hJq8wIE3jn9egsRm/Fsu5GlvoqdUHSSmJtUtXMzifst5KMqU8tXaMBezyd8DtGqLBbJ6qKJuc0sU5vV9nb1CckoQ+z5dNyWvCQb1figMVE5yI9okhhpUzqyZtjmSnVNOsmDlwnZ/d/4zPMVSCBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 10 Jan 2026 12:22:49 +0800 Jianyue Wu <wujianyue000@gmail.com> wrote:

> Replace seq_printf/seq_buf_printf with lightweight helpers to avoid
> printf parsing in memcg stats output.
> 
> Key changes:
> - Add memcg_seq_put_name_val() for seq_file "name value\n" formatting
> - Add memcg_seq_buf_put_name_val() for seq_buf "name value\n" formatting
> - Update __memory_events_show(), swap_events_show(),
>   memory_stat_format(), memory_numa_stat_show(), and related helpers
> - Introduce local variables to improve readability and reduce line length
> 
> Performance:
> - 1M reads of memory.stat+memory.numa_stat
> - Before: real 0m9.663s, user 0m4.840s, sys 0m4.823s
> - After:  real 0m9.051s, user 0m4.775s, sys 0m4.275s (~11.4% sys drop)
> 
> Tests:
> - Script:
>   for ((i=1; i<=1000000; i++)); do
>       : > /dev/null < /sys/fs/cgroup/memory.stat
>       : > /dev/null < /sys/fs/cgroup/memory.numa_stat
>   done

I don't understand - your previous email led me to believe that the new
BPF interface can be used to address this issue?

