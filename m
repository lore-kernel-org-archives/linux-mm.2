Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68E3BC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 15:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BFCE6B00A0; Tue,  7 Jul 2026 11:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470616B00A1; Tue,  7 Jul 2026 11:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35EF36B00A2; Tue,  7 Jul 2026 11:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 07FA76B00A0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:36:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64460C3301
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:36:34 +0000 (UTC)
X-FDA: 84962382708.01.83F4374
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7843814001A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:36:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q85y9eWl;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783438592;
	b=Fr0YwdDeBAcoGfq8jgEAfBgsl/GFMuB2H0WhqPfaXHNGhq9hJbpYdnU6Ar1f/C0inAypF4
	0T5yfneRf7QC8u9FKQy8OPik07wupeXr3FnRRSCeh9y/ale4J93k08pItAGvxUW1sFpCM1
	Rk/b+zrvQ433C/+1cTfXHzW1kH8XkGQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q85y9eWl;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783438592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4C7m57sAU2ajhrVz3LWwibeLymdgwyRapN4fL3ROCgg=;
	b=60UzaKN0YfclwXCfFxdEiUL8aR8fzsHzQVoUmUVel5h6gN64CyD7DXqyh9j+QXO9RfmnDh
	j6B6b36tOjSUo48LJLEU05kWwE349+f/sAEubctJmoZlf/blwYjoHREAKrriGElMR0EZ6j
	NXapSMl4Ma0OHOONG4xdApKE/Y3TtFU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BA3E4078F;
	Tue,  7 Jul 2026 15:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980DA1F00AC4;
	Tue,  7 Jul 2026 15:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783438591;
	bh=4C7m57sAU2ajhrVz3LWwibeLymdgwyRapN4fL3ROCgg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q85y9eWlkd19L9q3iVIFvdYAaNenM4MJZS6TC/0pjT/UDCvgPodlCDcSxpTkcey03
	 9tKPHBkYzanpRQmeN+v6Bcaz5orxgOrHhMMXv8/MqPoudU8nVZA4A8Ea3U5RafqcnT
	 +9TkbCyi8UQ1VsspPRgXM33y0nk3uMJgXLx/gwxxYLDyTUA2Uo43bqrzVcW60UeawL
	 XsifpcDHbrpcYsXVG/XTmPB1lG32da44Ty9hWXBMHjbf5+GO3B/BT92q6BLJqslPD+
	 U03yv3t3UvhKq2QO3hUNQwnsf58MppwbvDmC6lsGW4e5Z/kxsJGqRahScxnAMtZeOU
	 YDkTGGayVPxnQ==
Message-ID: <56608c36-634a-4b30-b29b-b3bcb5067ce1@kernel.org>
Date: Tue, 7 Jul 2026 17:36:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 3/4] tools/mm: add page_owner_filter userspace tool
Content-Language: en-US
To: Zhen Ni <zhen.ni@easystack.cn>, akpm@linux-foundation.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260707115411.1714314-1-zhen.ni@easystack.cn>
 <20260707115411.1714314-4-zhen.ni@easystack.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260707115411.1714314-4-zhen.ni@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7843814001A
X-Stat-Signature: ca544x8ruxnzh3y4zrrd69xiypuhz5wu
X-HE-Tag: 1783438592-83157
X-HE-Meta: U2FsdGVkX1/r5y0U6Wv9wbKFRuk4oLQp00ZZOiaUfpLK1WCPgY7YbWdipqZkQBvSshc+maJocAZdC5fHs651iNmrVi7nHXN+kPYFtu4Emyr5V+bMBTCkjDlDcXYyu1Hebfk9jBaaGyyTl6Qya83gaKYNq5bBGGwzMuTH/yZw/zNqUUPdZRRe8CN8xbMFIYltmihEnT6NdOg/jIrJd5Fmwq4jdIZHH+YGg/81MlbOqZVQW4fjT5xxY71XF5qkRoTBOSkwCm6qypyrxC491aA9ZgAuK7tFVSkzpkMLBpQ3rS0YF8gr49Qp6cJHadbR9MoDBr7jGWGEiPIxfKy7UUdwAHSDs5nAKdNx+CWpmj6w6owDFg2unV6M0DKGa0RRZpnXwETXTLCCH5UQBTRxFG3wbhi7K7hkHW5Bb7kx+D9peoWHbEvrlrXtVhWp+Tlume+xTCPTSLbkmmzn/YCg1o6ihW23fZoWwS6wcB3yfibA9k8IuBwGf9ZdwFstGS0rqsQRYXkXytjh4ooBKoMZDyTpavplZRNiOYHBQri7jHvLcwCWyK2xWJTW/Bp0hKfRm371r7/3Wy9NEEyxndPcrwRMrjzy3ZKAXwplhIzggLNQARtD5t05Sdnte1FDCchxmTMDCXfWG4oJaJ9ki2rGDF0i4l/GCEha7DChbAdoZlKzHpWb6yk9OXX91+iWm9ystzVLq1XMZIV8NckTuo9ykRZtomvBy+SpdOy1f5v5NqVT0/0aU4VkqU2zpyze0GLJmxaAdOiuaDz+NO9WuQOoNb81vPgd3a2dA7hL1wkQ5nNZeEsI2gRPTLA9DA7riwz5qzzjnYoU6bp+Hh7XD9b8IapmbAvX1mUBKkHmWukM5SquKN1EFdaUzOVe1aOUW8XXy/8d3mVNL5O7uEweD4Z4nkSXFmDSa+L1B6J9wyersCovXvZmvh8/YWTTOLp9IBg3MF2y9/u5u3FlyTaAgSd2vna
 WSMSNsD1
 RpugKxJ9HjcBU1I9CkC5z1IVlThTzCyO/yuqQ2aoX4t5rkdnfoMHvRfQgtcBdX9qb7BDDJCi72oE4IUCnbVifbv+u84zw1agq1cRQaAesCfJX4LGA4yYkE/UxLrmTkdPCMVfCPmDDIl5G70nrkQG86bfKj3blA4xxzHsy/zHZLDCLBJ+Vf5rmPJcElP9ga6KwUOOoIPVZlDPXvm9huA7vnsopSGIBoKGYCmsSrZtLMcg5CD1j8PIzxoILAJT4FxO4EooCXKPAG/nyY0GnQhDh74aj9k9bbOEVIP6os5fwF0v0uzs3+i7zvW1Bp0cqaxe3H0ag9coCtcNLJmFIbfJKbH8nEMMhDBiguL/X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 13:54, Zhen Ni wrote:
> Add a userspace filtering tool for page_owner that supports per-fd
> filtering with print_mode and NUMA node filters.
> 
> Features:
> - Three print modes: stack (default), handle, stack_handle
> - NUMA node filtering with flexible formats (single: 0, multiple: 0,1,2,
>   range: 0-3, mixed: 0,2-3)
> - Per-file-descriptor filter state for independent filtering
> 
> Usage examples:
>   # Filter by print mode
>   ./page_owner_filter -m handle
>   ./page_owner_filter -m stack_handle
> 
>   # Filter by NUMA node
>   ./page_owner_filter -n 0
>   ./page_owner_filter -n 0-3
> 
>   # Combined filters
>   ./page_owner_filter -m stack -n 0,1,2
>   ./page_owner_filter -m handle -n 0,2-3
> 
> The tool validates inputs before sending commands to the kernel and
> provides clear error messages when the kernel does not support
> per-fd filtering.
> 
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> Tested-by: Zi Yan <ziy@nvidia.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


