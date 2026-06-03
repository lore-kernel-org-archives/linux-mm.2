Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F5A8CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DDE06B0092; Wed,  3 Jun 2026 09:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E676B0096; Wed,  3 Jun 2026 09:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4246B0098; Wed,  3 Jun 2026 09:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0CC6B0092
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:55:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A7B88D424
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:55:06 +0000 (UTC)
X-FDA: 84838747812.15.EC644BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3363C140012
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:55:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hAqykw1X;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780494904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IQTVZIzjeFB1qarNlPlpiX1GZmdklIUx36xABRz63yw=;
	b=Hjd6AYfm6q3ivwBfDBoBqkYw6PxGcg6yOXseCrpPnGNU7yq99vjIqj2xuuxtkGHUur19RL
	MBtJWba9rffGB//N3e7p2YNgow4ris0xCPzXCbrJkHvbyGzWKUFAs1OUMguyi9K+toyXAO
	frwVNtWSu3c6lA80vyyWVF0jXBpqO0U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780494904;
	b=Se8n2YsMeuK6UG1ZXITuuYaDvYZ+loXaemSLfKB7a3zYuU5J1LQHv/TvlhFG0WWz5Xe0j2
	mi//QaiOLk4OdwxZEVwF3jisXyE9xy5drWRyp4BTBh7aNgEopyBRi9EQ3J511DzgTSAHcP
	pDOJJMKSXIpSiHB3W2+aSzNhyaIyLWI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hAqykw1X;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2808F440F7;
	Wed,  3 Jun 2026 13:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E381F00893;
	Wed,  3 Jun 2026 13:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780494903;
	bh=IQTVZIzjeFB1qarNlPlpiX1GZmdklIUx36xABRz63yw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hAqykw1XMvNefkjWBI0ZgvpiT9m2B4MAkcBR5LOiEfK6gkMAgGeaFcP8Bk9lnPEnn
	 pJYwIVQD4TjLImMfHL8gzDRcN3xNBwTcKMyNqf+KXaGAiD0HBy4k73rc5ng/21zSZD
	 dmHmLLDwzD9gRx5uYLj3od+caAdsAmNjWYhbAQqLEXyFq8D5d6CzL/tNsjIYWvVwgg
	 N5P+61aApyZfGZb+jD/ev538twpVI/RQIwtzoEyZ1FTgdn6K59UQL+S+aE8Bw6Hwa5
	 PIgv0Rwz937BAHR0jeWtkNqMsmCnWjqH0DaV6eVedfWUkRMIJBzk3K67AqbSq4N249
	 ks0Zhr3Jy91Hg==
Message-ID: <8e738cc8-dce8-4043-9b93-2bb867c43028@kernel.org>
Date: Wed, 3 Jun 2026 15:54:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/2] mm/process_vm_access: pidfd and nowait support for
 process_vm_readv/writev
To: Alban Crequy <alban.crequy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Alban Crequy <albancrequy@microsoft.com>,
 Peter Xu <peterx@redhat.com>, Willy Tarreau <w@1wt.eu>,
 linux-kselftest@vger.kernel.org, shuah@kernel.org,
 Usama Arif <usama.arif@linux.dev>,
 David Laight <david.laight.linux@gmail.com>
References: <20260602100917.3641359-1-alban.crequy@gmail.com>
 <20260602100917.3641359-2-alban.crequy@gmail.com>
 <20260603082707.3831525-1-alban.crequy@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260603082707.3831525-1-alban.crequy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3363C140012
X-Rspam-User: 
X-Stat-Signature: czo1z8tjok8ecjzt9xboa45rmbg3nkow
X-Rspamd-Server: rspam08
X-HE-Tag: 1780494904-360176
X-HE-Meta: U2FsdGVkX196jnJroZ58WXHmYFqzJWWl1h1JlpHO9Wq1yCv5skeXU28Nvw92nbdvtGubJV04wN8jyyBeHRY05ZeZe7KQaIIqB8EjjrO9QUqrOZOZo+DppkrSn7GqVW5mhSs3luqoxfFDOF8fA2f0VwH5CMSNwkV2hFrRd64xVFmuPGRNKI+wUsLyeQ6xacA3RLlh/2JRzqAzkb1+QMPuZSymqqqa4nEvdvKhr00Ibc6Yu5sjoEqSx3Boegb0hfeFuA/YIQr6QVVwHn+/ieGGch3WGF/wsP0cYOJCcCucVWi60gvZESmdIJly7RnIKglkhGHmEiCHzBGe8xudyzcd/vBARa7AnOyCHWfVdzXAgD4W/8oh+lIEWoFhjrCcZKLTbsUMpPs/2GFhp8LhdO/H38hrffPwesVFXRcDtsag/zXga5Ytcd5hrLmW0/NjOv/v3+Qzmc0QFHlCeoxg1WGRBiTcCuM7yEHaGsnE6cB5WuClO4cRqvAKm3R+bH2R5N8T5meulE8fe0RnrQw7h/2oWEwdk9/0zJowUb3nLREfk+HlIOXZrcEMpoELDG6UIRBo8ksQlhSGAD3lPgLgGws+Y37XmtdaAf1QjEnpNeC78jzOmHy0CfXpZNmibVia6e2VfOlA4UiwC/kVFnojBjCmAWnRPtNPGSxkNAiSnN+95eedL8JqVkUe9RJc9sjQI95dT51xNkrtPqtihnjvpKTGD9m2pLumsqpAObm+hag2t4EiOXA+o3HmF15iZnCtmj6oHbwVIlEV7jdbgysjQETOTGrLMXxM0QyYe9CJId58wj5d+iUBr+LhoHsDAZ4rMdlH8v1njQHjdMA/vSvab6iGt57Pi4+Ts7XPFEBX/YMR7KjZ89/Bdr7O2Jc3bw4nI8xCNPx8N2N/jjiQ/cWgKp5P0p987kIT+f4CUPKmPx2T2y+f8XIzx/1rQzkfol+WNCMtvY5+Yw63XzJsU0gABBc
 hATjfyuS
 Pxo/zxVfC/roPCfXgv1F2H1FY66GnmQlQ/OpBJUXRXKKVHJVq6aPtvXjf6itniPoxeX+97c9XJ2k+ebkV+HKT0m5LU6NvWvma4Arui8sOpzdDdh+PNKGACK8l4wMvKPksgfTzSGW8DbFjw9i051QV5EHIyev3fWM0Qc4xnp8wIcE/VOaZErJGCt4urYInQB8ZztyepGqWLy4PGMKH7NFStU+mJLQ9jKE59dmC6CTcV7kxiykMX5USDZXiHsGS329JhHHxcnj1BNngUqQMhhjz6EGwQmRuMOd8pgqoPe5guYypX7BL65nF0eO60wneVinvNpP0trG5sm4mFy7R+6sjtkIkcRtc4xBMSfRP6xZUT3alaCjUjMKQ5fKXL6bmgvaq/PTz7bkCViFCnm8ZHqLitAfKEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> However, the exited-leader case is a real limitation for profilers.
> OpenTelemetry eBPF Profiler wants to profile a process where the main thread
> has exited but secondary threads are still running [2].
> [2] https://github.com/open-telemetry/opentelemetry-ebpf-profiler/pull/376
> 
> Using plain TIDs (flags=0) would work, but it means users cannot use
> PROCESS_VM_PIDFD in this scenario.
> 
> What do you think this patch should do? I see two options:
>  - Address this limitation in a separate future patch that fixes
>    pidfd_get_task() to use PIDTYPE_PID when PIDFD_THREAD is detected in
>    f_flags, benefiting all callers (process_vm_readv, process_madvise,
>    and any future users).

Extending it consistently for that scenario seems like the right thing to do?
@Christian?

-- 
Cheers,

David

