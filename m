Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20766C79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:18:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E3106B0092; Wed,  9 Sep 2026 12:18:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BB356B009D; Wed,  9 Sep 2026 12:18:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F13F26B009E; Wed,  9 Sep 2026 12:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1B056B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:18:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3BCA2A41F8
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:18:23 +0000 (UTC)
X-FDA: 85194731286.21.FBC2D57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5CE721C000E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:18:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="o1ral/CX";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788970701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HyXKsyvomAP4+5xUKdpWvuWxueChSf/W0pw/XmgY1Cs=;
	b=E/DZa7NhPdJ4z8ccKJkgqsw73MN7cyAbD+eEfqMB1tntD4ElceB8w42g/IzIZ4PR2ihGsO
	wzqt/hQD7oYNw01DxIBOnZh0hH2ZoyipS8n0qlyoNjzizVfs8WSKLAsfVOvzh7zOnM8jTN
	lshPalyiSi6Nxc7GW8PBfHPldAW0sK4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788970701;
	b=VKfJg2qZA+G91JSoqFV+xaYLBVBV0qsYGHgdQaqbKBdmEz41bwMvnnXA7/CyJ34UEBK+Ri
	bNNOzPB46lSiB4sLHPvubSZDpr6Cs3SH9IRk04IxmvvK3WxE/xKTlF664PM1r55Glwm+Dv
	cd032xi48tBQaoETNRymnVfY09EDkyI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="o1ral/CX";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A4B141707;
	Wed,  9 Sep 2026 16:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80631F000FF;
	Wed,  9 Sep 2026 16:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788970700;
	bh=HyXKsyvomAP4+5xUKdpWvuWxueChSf/W0pw/XmgY1Cs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=o1ral/CXD4X/fnI10rF5bNsFBS0O3npyLOcM/9WYX8ixwC5pJ1Hvm0bz89SHGylJK
	 oWoqybpTMJ98En5CCBAd08JK+6v6M4KeeQKe394T7dBvMwipJCL6YkakDcFA+/71ti
	 RufHHaydWT326j7bHQhwse69mevd/0OPJuTgxt4j10MfuienIrZEJ/RK304M0xF0Vz
	 Uo8l8sNIwOyYe88CCHh8s2iFFi7+FlsyZVx7y0t7gdNvLJAWrEXFM1H4UEiQyNDcrE
	 ZwE1+AZ3FXLqgGTF7EwLHmh+swp+qU7ANIghQ8gN/OaxGoH+VxXJqGvMJRBKtl7vl6
	 sFFCsg0Ho+g1w==
Message-ID: <f1a4356a-bef2-4769-8d5d-c8f21ebff47d@kernel.org>
Date: Wed, 9 Sep 2026 18:18:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/22] selftests/coredump: put a hole in the middle of
 a sparse mapping
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>,
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Omar Sandoval <osandov@osandov.com>, Jacob Lalonde <jalalonde@fb.com>,
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
 <20260820-work-coredump-sparse-v2-20-ba32dd718c51@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260820-work-coredump-sparse-v2-20-ba32dd718c51@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5CE721C000E
X-Stat-Signature: wk9ey51mhoqhwf7ou6jcgjdduy3wz3bm
X-HE-Tag: 1788970701-767526
X-HE-Meta: U2FsdGVkX19e0i/JRvOQLdiGL/nbeLdNi0shLnexSHMeP5rFXl7gWN8iocxk33hOy4vG1ka2ifFqa0kjOSHwnehsox/ubhP5ZrK3MIyfqUz1lm/IaIrUjcFU+vxERfmr780uBaFP8s21DM7VyojvVWIbBEZwepuekXVcvd/5CUGmOl+ieqsN9J0jrKLHbbJ86VnRn4DcMdUoTHP0iGfGXxfaUiaqBP+2TPAtgyEG2vx4JxVGIIh/7iUdSJLeOf4oVvhk2wcWioULiCc60JceJj7BXF6SzJfXmWvlYXQx5fYAqJ76n9Ka7z6aZqZOc9HB/OSLcrVpbdnMSDiX90QPPl/qYutDArzIXAg3m7ddDfOK9ONmMqiJigPF7r5pnvPmV0/tdH07vEtEfGSUQkkdq5IvXFn/QWYe5PnVVJcMQHS5lLS92XY9APBEptOm9SRC2jkzsLoXluOZRQn1mrTSlRsmZHL1UbY3nXZ6Apb+af8QsgvozXyGyfjRKtkIJDmUGNMRYbMUOrWF6blIccYOqDGmv9qWB79oBIxx5GAQ3PbmjHOyJ6gtAXu3SJ1bSpSBSAsBgG+jqVHPGNtpHUMJX8k4QsqcSR3mO4O/3o30ZRyUW//I+sbHHXODv4l5ZHgMJ9yD7pV3n7/lwyxAWP5YYR6+JWouFcIUTcC8EWGWChWiGGxjlJtiT2uwDWu5pNFn5rx98uXpOSz8jsVFCDCmjOxozNgQKISdMqXC6hQWTS1VSfoV9dqCzcf9U4qR3fd1HnU1i6DFLx0HN06LrqCh/TJuTH+I/3pWIqeEpZaQCrXs1KJ9gFMC+P2XMi6NtGWsfvwaYsMeNKvF3JnZcVdUNUCgZPEFIh1aaJyIc65/flOXnKzWbm8JkpY2VIO98jFESMZP00qLK9wsqzKhp5mqfqneltJoPRN26gcTEJoDhqQIMFEoeX51/ZgYge0gyWrc8zwv5w7JiERolSSV6P1
 jKjK410d
 4lciroS29cU5kiVgwSN7/pd1HyYd3v5lllgZ8GfFLpkDiKNtHOlnwElQS0uiaCqPKC6oqkfZd5Uf/68u1+CUxS5b/g4Bm8PqkMnQ2Esw4M1VdMtBLDnyXW2A6H0QEWxE99V31YqpOu/vXqB+QVnGnRTDGb7B9fLA9+/58PR+j3uMonc5DuEuYurwBQALTbSp+OhQOd+EAN9FJxedhI9nEIdf2h6m1pDso0zB3e50AeF3YpITT1lbshBmnhKYZ0HU+GRtFfuVIzwGrCY7aLMwcQ2sldO4puv8nyxTFurh4DlZsXD4732Ur+Ukcvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/26 01:09, Christian Brauner wrote:
> The crashing_child_sparse() helper touches the first page of the
> mapping. That forces everything behind it to be a trailing hole. This is
> easy to handle. Make the test more difficult meaningful by also touchin
> the last page. This causes the hole to sit between two populated pages.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  tools/testing/selftests/coredump/coredump_test_helpers.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
> index 45d76fa0f469..89f3954c5607 100644
> --- a/tools/testing/selftests/coredump/coredump_test_helpers.c
> +++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
> @@ -58,14 +58,16 @@ void crashing_child_sparse(size_t size)
>  	char *p;
>  
>  	/*
> -	 * Touch the first page only. The whole mapping is dumped because
> -	 * it has been written to, but all of it save that one page is a
> -	 * hole.
> +	 * Touch the first and the last page. This will cause the whole mapping
> +	 * to be dumped because it has been written to. Everything between
> +	 * those two pages is a hole though.
>  	 */

"hole" as in "no pages mapped"?

With THP enabled, this is not necessarily true. You can either size the mapping
large enough that you get holes in an case, or just disable THPs

madvise(p, size, MADV_NOHUGEPAGE);

before write access.

That's probably the cleanest way here?

>  	p = mmap(NULL, size, PROT_READ | PROT_WRITE,
>  		 MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
> -	if (p != MAP_FAILED)
> +	if (p != MAP_FAILED) {
>  		p[0] = 'x';
> +		p[size - 1] = 'x';
> +	}
>  
>  	/* crash on purpose */
>  	*(volatile int *)NULL = 0;
> 


-- 
Cheers,

David

