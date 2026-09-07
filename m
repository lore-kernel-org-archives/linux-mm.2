Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3EBCC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 07:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E796B00A4; Mon,  7 Sep 2026 03:12:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF5C6B00A5; Mon,  7 Sep 2026 03:12:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EDCC6B00A6; Mon,  7 Sep 2026 03:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5ABDD6B00A4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:12:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9889140657
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:12:35 +0000 (UTC)
X-FDA: 85186098270.02.ADE0E55
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 19112140009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:12:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+zI0swo;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788765154;
	b=0bOtD/Xe4nbOb7gSG0RlQahrO0CN1bpG05X7+9+PzLuJfItfGpJii2572EC76eJzsrlLQi
	xFcVlnebDnCcVo+YANFxKwyHDIW3B4HFTcOKj9EA8IrI+xmb/NoQTNvQHKL3DNTLfJguLt
	DzcyUsJfEK3TSEgYP2824i060hYTsaQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+zI0swo;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788765154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RE/TBJLP0RcagR+LIg7Gb/yCSd1JAB/3v4ML0qRWGLk=;
	b=oanJC6MZ4gGAAuJ5RigYcx+wNHz/7dt72sqNa/Zeiyv/uIXWFexW9o5I390lImjsJjQCIU
	jAI6eGEYi7MJsl+Ax0NQbPechS5my3btc8Pxi5Rulst01adSqzVngx2OZk+Owi9IBRIvRS
	7W7AjVhVtiYTQRsIUrhaa7K2rL1qNvo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F98B60AB5;
	Mon,  7 Sep 2026 07:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFE51F00A3D;
	Mon,  7 Sep 2026 07:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788765153;
	bh=RE/TBJLP0RcagR+LIg7Gb/yCSd1JAB/3v4ML0qRWGLk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=K+zI0swoOkrTg5i9L5eV8wJVdNXjs3rTmZ/N4KSpYQ2NkILP0dqNwirZOWrmcZQwY
	 Ca/eonH39MQaMusBEdPYJkbgOdQ2hMLoLDSi88KToxejiBYXMA6BTmhtZgCgc15Ued
	 X3M67vgZG9fgK3xdyal8xADXh8ab1yA8HSJwCzDvpQKmj/eceCjKdPNc3YaCAB1IV/
	 xZe9zidRB806l7MO3ZfSx/YcJUfowF9N09aHrv3dYIuaQGFeYx0b7zn/hPuREX4Uww
	 S0hHhRuHpCZFCZb/ST6CynnPWrePo4aZEGu4W8u3xMOj+mpD7/5LHHCf4JkrCJn6G6
	 kYlIbYS0LQAeQ==
Message-ID: <591f2b51-8a24-42a5-9472-6d017f417910@kernel.org>
Date: Mon, 7 Sep 2026 09:12:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs/core-api: memory-allocation: clarify when to use
 kzalloc_obj and kzalloc
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Randy Dunlap <rdunlap@infradead.org>,
 SJ Park <sj@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260907063654.2248617-1-rppt@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260907063654.2248617-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: jfgrxakizahis4au6mbeoat8cnocxfht
X-Rspamd-Queue-Id: 19112140009
X-Rspamd-Server: rspam06
X-HE-Tag: 1788765153-202541
X-HE-Meta: U2FsdGVkX1914xZQFWbEQ18YTalh3cC+tQA6bn3Ngju4V9X4NNvWN+6xicoqZ1+BvUZoSaJGgAMwzBeKMKC9nFTRdP2Y4VQ5tqa7ldbdmqnyyZGplrzi1yfG8bH4RKkzYiFIcY9BiCNSzNlOVZRSGh9krGcZOU3V+gF676I6zswY1sAMwM8BaRGrfjeqA13wcBeFKLYpFCFLTUOJ6PNkhZIWjfHYY0w2cGf1js983gmjy73mOej9tbtdEJiP9cMLtkHakH3oEG+uRyEKrx4Hot/k7BcakO55ciTLhN1NrbgKwbAW6pppbpv7M8w4HMpQrJ642UvnmXfUlEJ6soj+TX5yj+nbV2shFPaP4B2V963Ewi2ww/4t5hNAEW8Pj3Pq0kuOUTQ5dE/Lb25/hIOoQN2xwpGBtIyMFGdtxswMEZStgyLAPdgHFJNGrOjk2CGVD6PCfRDdWtQdcVP/fuZPIc0Y8QCaO90bxTHaUOdoancQmsoysiYHV3C70TGIxOcM4/Or3BbHAFLCd4BQnczlbsvMJGybU6ugisIuZf+YZv5jpMXvxsTNJEKzQiuQqiYL5MP3YPKxKlDE1ii8taaejzrbUqKE4R5o0fFbURkxncMkpy9lZ5SbXhmdAmBLQuWnbw/vTPS+qOTgfQepa3qyRbEFAkQvisC7scd+9o8RRhRNdxKvE7AmlS7JeiWPOlEHE3X1ifRhTdtXQnrGOaT4yNvH/xRmYf6C8YTD6TJ7NLezxMcVPgy0EFqOWp2Byfi7g6bMXB8Aubu678/IYd2IhHYH5k85b7QCg8dphecMPawr5qNMGLjMel/y41ZCPO0LfAQFfPaPqXgjlbzhBtF8XpWa+UsN2Do8XXPL5JwkqBXJoVaeFf3YWx7wsqIXr1XN07tHNq89wgECZhv8RwspZHSvQk+yLZ+nGL+vMI8eOLNeXs+mACiMSsspUxZafev6EIDQsZb779F3nBkP7XR
 /K4SGmx6
 gE4Rdg2+tNqB8JJCb7tBsLog51cS8QDqwTDUhLXG9MwZDh02kBJiThawFNDcWslKtbrvEaz0gVx0Ta4WegBrdzEDy0j8w5PYU7fN8058QPpM06gFXPfTq+m+wsey+7vBwqWg1A+xszAnXZES6Z4xJQsgVwvEM+/j5D3PzUlfAeWQ2MrWmoFmCq+lKPhVydI3h+t6QLGCSQ5kdj5bk8gqfQIry7ZJa+xRT3AK4Pk3EK6xAI/u0pF1bxLroixKqip0LKzfMY8lTpelym5RCjLkk34LsaOgj8w0TTHuBMdc6CqO4JFuh8Vn0Vmk9KLnfVYJ9V2oaCmO6pbAj7Zk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 08:36, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Make it abundantly clear that in the most cases objects should be
> allocated with kzalloc_obj() and buffers should be allocated with
> kzalloc().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
> 
> This applies on top of "docs/core-api: memory-allocation: add
> k[mz]alloc_obj() and clarify kmalloc" series
> 
> https://lore.kernel.org/all/20260902-docs-memalloc-guide-v2-0-218c1a4dcb80@kernel.org
> 
>  Documentation/core-api/memory-allocation.rst | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
> index 823f7fa57429b..648222b6c8576 100644
> --- a/Documentation/core-api/memory-allocation.rst
> +++ b/Documentation/core-api/memory-allocation.rst
> @@ -23,12 +23,14 @@ answer, although very likely you should use
>  
>    kzalloc_obj(<VAR_OR_TYPE>);
>  
> -or
> +if you need memory for an object and
>  
>  ::
>  
>    kzalloc(<size>, GFP_KERNEL);
>  
> +if you need memory for a buffer.
> +
>  Of course there are cases when other allocation APIs and different GFP
>  flags must be used.
>  
> 
> base-commit: d7dd88ed029164fe0a959e126d0ce18dd3719f89


