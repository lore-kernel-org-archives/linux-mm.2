Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1B2EC5AC80
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 14:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280736B007B; Sun,  9 Aug 2026 10:03:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 230D96B0088; Sun,  9 Aug 2026 10:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147946B008A; Sun,  9 Aug 2026 10:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4FB96B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 10:03:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6188614057C
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 14:03:46 +0000 (UTC)
X-FDA: 85081899252.10.470B5C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id B3AB0C0010
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 14:03:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eem74xGm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786284224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8R5Hp4lAYk21jzt2d53dHdom5AbkPCz9hSGN4NvOnCk=;
	b=ZdtHbB5Isbhz5mpIwDf80KciCIj8mEOaxjD8/fM9qhDQz01tbQC9SZlmaV+Sl9YrxHfXFy
	3Dhqw3hjYhr/c/Ev9oJ+UPj8Dns6qTDeVf0Y3P2dIzPqOSDaihMZAVbch4KhgSenaYLoFO
	hCCf3YRFwSvnaMNOyzt8ikrylmVWf4I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eem74xGm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786284224;
	b=A8UORoohv8KGjNl2ts0q/kClED9VeBPt+LoaM/c99EmJ8jtr9bc1l6SZxeEOgNdxatCZzq
	BWtDxKAM514EoOuP9I7kbRUn0ezHnVejqBijFVRsleoCG4KAiUEiQwnkbmDibMfoogrJTi
	ZHYrmRuLnFIJ+KN/sBoN8XGJgn2qgKg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 15E9960008;
	Sun,  9 Aug 2026 14:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DEE1F000E9;
	Sun,  9 Aug 2026 14:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786284223;
	bh=8R5Hp4lAYk21jzt2d53dHdom5AbkPCz9hSGN4NvOnCk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eem74xGmmfxX4i5JGj5geIWcHbuRewGhh7jtDenQX1rUPWDua13ZDJoWcbiBDD6xv
	 RqDLgzNIa3BbyJlCevTg8MNcziZWAbPAG7qqrRUvwgaXnhXrFcn+AzZxoq6a92f/5g
	 uu0HuXuNHMYFgYdinigoKyGTDpiIZd7gCDmOr330AFuevEFo84RBz6zmUtC6J4UzZj
	 2dgDt0mxAPahvRLYoJwwmFtFHQLbemX2BLnJEZcKRx5k049uI1QCAPV0r48fFZbzMq
	 RRcM/Pwx41eRaDNfkvMjOm7ky+QtZng3gVmecZLGxWtgSQs3u1PFrgpBWbL5dW1cHL
	 Qfo3l3WHevXLQ==
Date: Sun, 9 Aug 2026 17:03:37 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Longlong Xia <xialonglong2025@163.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Longlong Xia <xialonglong@kylinos.cn>
Subject: Re: [PATCH 1/1] mm/mm_init: compute hash mask with unsigned
 arithmetic
Message-ID: <aniIuZa53OBqCMbB@kernel.org>
References: <20260809123119.3811851-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260809123119.3811851-1-xialonglong2025@163.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: d9t7zmkj8qgnutighxrug71c5orkmhh3
X-Rspamd-Queue-Id: B3AB0C0010
X-HE-Tag: 1786284224-571542
X-HE-Meta: U2FsdGVkX181Udv29W8opnG9cw3zbArE+raX1dWIdRyqv3jh+XEPsBRM0KQUbxv+ut/T2GVuKJn2S0FIgWf1jXSs0APAxwwJWEEYYDg9A+QrVX+p9YUl9BF6CvEGqQoz8Ha7ar8q51yW0bzN/9363odBo2WL9zzFX/sEvKob9kX3Z/g8+91eCqbHV+pdTXrOnr3SPeySfsvzIPSl/he4wc0RAItnYDlA/t7hQFPdrcSpPjLGSiqSlafpO7mcYhZjhlsGNESMTamFHkQY/mw6/3JOBsBJWP6B6KkvipqNkjMQ1LITJgzmrdZXP8pdfX8j+G/qDJw91odoqlkKhARfpjkwWDaZHK3ZE8Zwz7AVITcLLSNDh2Vy/ySqs92T2NSf3ST4mGoZp5fcMmVqvNg7a+4wUMDRw/ATWt0XhgKnva0CGSkyTd/K3QJpvBYN8SiN2yVSv7r3tJKeT5XwTvPDf6nra2Av6+Vx31/YjwXORTi4F9/CSmyJTvbhLBebtmXgxC7gbCkx/9UDjDDo/ak1JTXfKvktzmR1KNWMMmRGvW5oqKP9DT+XnNGmwSHrxKEgM3TJIqTRX99x3IGF9icuoJiFtlFX/MNvWU/MroWv1gqJR/8+UcyUnD/rAQ+CFWqo8v0qx0H6Ma+R1tpvJKiZxs/qcXrz3VSsSatReQMrYtC3+g/vZPSa3MqnuamiNl+aklb+yY9HPnvpY5iEkxZUVfkxngKpiLqx7yJxG/+xgZn7WlQovbW88sSFHz/JKovOz34EHvmr47RNs+nVG0Sqju9axX3A5/wCRlmN6NvEO91DUvSABNGVQsfBYDL1ryzbhEuM7vC9fFU++gL6e9pPPRl64k/o840hYtUr5bcyzgklYvZMqgF+2E4aFyNOuT67tfCLMPMU09eOVr+TWE8Z/ZFZX0b3992xjceKZ8YR3bMSA7EIzcQWgqF3IGTHTbskLFyTnrY9M4YUtJGg06P
 ZWLyyiCt
 m1ZwdIqBY0EiDiHbFZdTgD4HPE7hwAgoOeJ7Dy87gkeSp12+5uzfIiRDP7iAkSUIxuder6pijeFVFSgg232sOmByMYyhHFjBW2QJ2KaVC64JidPF9P54SCXPJENnb1fN/6H/OeZCWz+u5gRtMZWhaIHZVHomp5iHRqRYMuT9bZcUbt2saliRLT0ekqS2ogpGyYGHuZMfmF2eDZO1VLde6XDOaa8/ax5I1rOI0P+H/Z/Ci4VR/PHcu+Sn8oetjmzY5HjcHC6Yc1XDJnriUa4vyCw4mZ4vUfW9R3bNdVxrESZoYKtA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sun, Aug 09, 2026 at 08:31:19PM +0800, Longlong Xia wrote:
> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> alloc_large_system_hash() allows up to 2^31 buckets, so log2qty can
> reach 31. At that limit, the current expression relies on signed
> integer wrapping to produce the unsigned hash mask.
> 
> Use an unsigned literal so the mask is computed with unsigned
> arithmetic. Supported compiler settings already produce the same
> result, so this is a source-level cleanup with no functional change.

If complier already takes care of this then why do we want this patch?
 
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> ---
>  mm/mm_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 498d62c4ece3..1883fe923ffb 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2469,7 +2469,7 @@ void *__init alloc_large_system_hash(const char *tablename,
>  	if (_hash_shift)
>  		*_hash_shift = log2qty;
>  	if (_hash_mask)
> -		*_hash_mask = (1 << log2qty) - 1;
> +		*_hash_mask = (1U << log2qty) - 1;
>  
>  	return table;
>  }
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

