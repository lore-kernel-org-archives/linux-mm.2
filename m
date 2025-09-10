Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D97F8CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 20:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CD028E000D; Wed, 10 Sep 2025 16:52:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37C348E0001; Wed, 10 Sep 2025 16:52:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 244FF8E000D; Wed, 10 Sep 2025 16:52:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FC998E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:52:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A20761402B9
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:52:07 +0000 (UTC)
X-FDA: 83874537894.03.676401B
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id BA47E160007
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:52:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BvV/30nX";
	spf=pass (imf08.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757537525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FWNfQlk257JJfT1KYHWmeyNUroe/2i7tvfJ15AQHNsU=;
	b=zNowSB6XAFq5R3+s4pdR5lU0O8dunqrqPMcZ6YsFa4MvcXpvgV3s0m1P7tIk1Jwek/NmSz
	G1eV1sXx+57atK50dM9UCOKhzrDh2hF5RPLQXl4w89Fh6Xh8zdChdgo4A9FpIPYvvsukmL
	iXME8r8h8N4iBfdeX0UsEx3bszgOJUU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BvV/30nX";
	spf=pass (imf08.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757537525; a=rsa-sha256;
	cv=none;
	b=VQY3AewgT+aYgebxyN2sa+3wuzl5p7v0vGNRko31db+sbCpa0EXJ9b2d0tbfPkKqmrYTml
	GdixmLgJZs7s9vHJCyF7swy1NjlngoLBauwOCnTshbtwBIWct66OnOeLtDk+PvZlMHHOS8
	XckW0Fn2oYo2uhT99L5mnGcMFTSny9s=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b600575a54so331971cf.3
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757537525; x=1758142325; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FWNfQlk257JJfT1KYHWmeyNUroe/2i7tvfJ15AQHNsU=;
        b=BvV/30nXp5lXWuwWIY9F+GJEQbqgLY1PeP2qZtn/5LyDz43+XyVgjOZa/OVEasyqJY
         ZOHjH+1VnAkyi7AmYhl4JioaOdu8u9slUnhRlxxbr7SxPLZj6o5yCky2AHfbxLVh0B9/
         b41bbqSWXvrboKAiDn7LLJQ2V3ebwu/wR3P0l2gTSzb/ZS7vNBiVk3o/QnMJbr00Ts04
         PJcvCnAiitAk57lAjlJxGBrUrzDWAlzeHeP+HVpsH/xz9Ym/rRA5oJnYCmjU0saurrIO
         dJ+HEV2cw6ogq4GFKeKjtZZogO1y7Vpj6LQrEPCpR6pG9M50bUuHKnWZnaauyjqcKaMn
         5Eog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757537525; x=1758142325;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FWNfQlk257JJfT1KYHWmeyNUroe/2i7tvfJ15AQHNsU=;
        b=ZRYJ1PhIrACihYHrc3lMD3eTcE/4PBRtUbB08sh08UlNpkIB2x6100/h4/znn/hC16
         R90FzMpvqSou/HsKfCTaZEqzqtxQSH6s/0nMuiQ5NqMMq4nMgC4JddGbXgopVhWHA3a6
         1uFHryKlRfvIIA5IX1y7m8kqnJ59Uq6299YclPNb3d/XF1hTZaRzd+P7o0GRuMxXvQbI
         ceKIz3wRX/l0yGXxembunfc4afcuuNDfseHbmLs7pC5+YHah0Oxdqz0YxZYScaCHFmuS
         dOS8WlIwlZ1u7zg+TViwEdU//vKdAGtU/Ake2nA7zJLTADQVtAp/i7gui0aRTV+e6xqc
         XJ3A==
X-Forwarded-Encrypted: i=1; AJvYcCXrgQSN8bWKwCzvGX7MpcZ8Is4ajUxRHsP1sfMgtQHvjeumS5DJMY2LMkif1pC13EK0gNE520LYVg==@kvack.org
X-Gm-Message-State: AOJu0YxPd1xNYj6IDLVGF8C7I7pa6Ka6V3+c+UeBAAjD3Z2ADiUS2o6M
	EbOCcxkedY9db9d9A0ZcVITlTvUi3rr0TQe6cFy1L8L64bvSA5qczvOw
X-Gm-Gg: ASbGncvGhTWWdfV7Pe9CVQKv1QpPhbCz5d/duuY4QyqcXXzlYPxGmwXtJ5L7lZ2mBor
	QeV+LGcE6zdtObNor5eLXTX0Avm9+i87ZQ55rOF/15bI4x7Vx+42Df6I5/2ifl+LwOjJVkkD9zV
	CRB9ab8bPX50J3Er+n6blpctS+w2lhYc/ADU25CLwa3jzkuTXFZ08YUAfaNWg7AI+FBWgTkaDAK
	usDSEMPytt+da99P5MOxwvDx+NdCvUut3zl0clcecHx83wcfRNseMJ2q/SxzyV6TBqy3f808RQ6
	zYz9nVwvqqm9gW1Vdu/C0pPUjX53g7TJr5i7KNQUwsUuv502isefQVYVNYSdTyhxGr7A7GQnK99
	6hArSQjf9G4545BTjBXnQWqqHztmkE0j9r7U6i51YtKRY7/0rwt4=
X-Google-Smtp-Source: AGHT+IFosu/REDKci4+Jh9k0F5EUAbtHTivVRaQuKcjCuMndGQMzNxwSqOG/Slmd3Ge+SzGqo/JjZg==
X-Received: by 2002:ac8:7c45:0:b0:4b5:e54b:190b with SMTP id d75a77b69052e-4b5f844d21dmr230870771cf.50.1757537524852;
        Wed, 10 Sep 2025 13:52:04 -0700 (PDT)
Received: from [172.20.7.106] ([63.116.149.204])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b61bbdd190sm28886691cf.36.2025.09.10.13.52.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 13:52:04 -0700 (PDT)
Message-ID: <8c4967ca-a125-458f-9998-6de4f8257dd5@gmail.com>
Date: Wed, 10 Sep 2025 16:51:57 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] alloc_tag: prevent enabling memory profiling if it
 was shut down
Content-Language: en-GB
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 shakeel.butt@linux.dev, 00107082@163.com, pasha.tatashin@soleen.com,
 souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250909233409.1013367-1-surenb@google.com>
 <20250909233409.1013367-3-surenb@google.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250909233409.1013367-3-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BA47E160007
X-Stat-Signature: 7eqziiu191cy81jj7z7ahzmmryqouses
X-HE-Tag: 1757537525-732847
X-HE-Meta: U2FsdGVkX1/0997twXQflz5vR2b6GX33GIInDdTbV/QVog42542DWTsyVWFbRL+uyaK0qV8sktY5W66V9EjQonSrkPy4wl/hBLNF33IJszs/M2dDHdAm0r4JHbew3LIKrtK4kTB5vQRYBbGrWg1ndiau4mgpt2pYakr8aT9/CcIqUDfz2y313lqyepwduUQnCKy0rFXm95djvwSiF1IE1fbM+QDawcdYq9jf2BOZDZgWg3qZjXkJwNG3OIzCEUR4Ov1nC5GtC98TfFOjxKiqyRt9A+m+vnp0zTUBCI7Nfu4n/5K8qHoOroJgUtnfDo86vl5gqxypefdQuTal5VhMY2t83LH4FGVPI75h/vrFEIMmTYl8tYRx5gnlXhy4rQCkPz/tALPw8W9eHa0p4AsvT3eba8oiWsB3LFpVuHV9xqCcnBAIDhUdq5ANR+q/DWlwxEYpsYcCcatx6CEP3vMDAPEK1PYYmO4jpXlL+4B0K1f2oco4Fi5yw2OdhkWmcc8Kwadu1+bsDTU8gQ9UO8qIJ4vN+jdsBq36IubQQCRJ0abh3jWurB/ylrOcGLV0ftyNXvMJB6aLc84WE7PQvGiOnVljIi5nq93nJAT61vCXjt3Ue10Z5JOFxNmaB17k4PoUoIE/NeApI7AgKLGMdKeA+79T5s7tQU5a2VhG8H81AiAg2A9sYcSULObRqWRt/1DvjMGVBqJBmxAQ+g/Z7BZldswm8+zunlXnz2Cwy3xTKl5tStzVczkPR44m1mCvKcFK2CumDfwGJm+7S5h29S5gqaMiLNFHZyGcau5H/H5CS9yr0z32lVFwZ7iMNSICaiXtC3dymx3NKXY8Br3FoNON4OY+NY0h9k48LQqZeih2kFLKJkSmI2Mn2VkJb2csDXgQU/sA7gb9sFNE3hXB2nCOD5keZpQJvsDLXolGrts9XpuC1v2b+JzgZxeRwK/TT1a14iECm0TkF3wlDwB6JKg
 mZro40yY
 B9a4qXlY0UrJnCzzU9sXi3QgdTQ2pTqADWQZ5uVQWV7NhbXcFoy+wucUwk/0zDr0Qo+GN43eiq086PC0Cl4gv8db/ACkbsOq68NpN5iMyN4ATApQh6kjnuKxa20KvYs4FsNHa5XqLWzC1PVEDtX4rUG4ACjDum6C3DpJEXmeO5pnBZixjd5RUABLVCSCKJTCleUvp1w3Ua+aDsAqxHEqMkvlQSMxUv5Q6m2wstaQxK7yakWJdfUoTyEaDE1mnY3MY0pkkPW3pTnTYrxzeX3r2sAqfR91PBqohQLLos7pcOcTUmT/MirZ8rSFqTrB3+Rzg2ZSbOI//y/D35AyTxQ1jmlbiS0X9d46JUl2d/GjO+QRqhVEh3pHvTsPVJGDD+VjGlhDsdrCrk/CcooHYuz4MTqD6i2F5VQSK8pUHuCgqNPZpeW/9gaEVOGtpQwjJxqJM3lITmyLfU9HlVKw0aim84ym1UbBasFfbv0g5Tm0T2I490/tiI/NyvNI186EeLXqus/aE9lWSKYe+by9d5HRwzU16+Pgml75qEcHy8PMIoc55adx/iAb7I7OXvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/09/2025 00:34, Suren Baghdasaryan wrote:
> Memory profiling can be shut down due to reasons like a failure during
> initialization. When this happens, the user should not be able to
> re-enable it. Current sysctrl interface does not handle this properly
> and will allow re-enabling memory profiling. Fix this by checking for
> this condition during sysctrl write operation.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  lib/alloc_tag.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 

Acked-by: Usama Arif <usamaarif642@gmail.com>



> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index 95688c4cba7a..79891528e7b6 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -767,6 +767,16 @@ struct page_ext_operations page_alloc_tagging_ops = {
>  EXPORT_SYMBOL(page_alloc_tagging_ops);
>  
>  #ifdef CONFIG_SYSCTL

nit: might be good to add a comment here that we are not using default as we dont want to enable
it back if it fails once. But not worth a respin as someone can always check git log if curious.

> +static int proc_mem_profiling_handler(const struct ctl_table *table, int write,
> +				      void *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	if (!mem_profiling_support && write)
> +		return -EINVAL;
> +
> +	return proc_do_static_key(table, write, buffer, lenp, ppos);
> +}
> +
> +
>  static struct ctl_table memory_allocation_profiling_sysctls[] = {
>  	{
>  		.procname	= "mem_profiling",
> @@ -776,7 +786,7 @@ static struct ctl_table memory_allocation_profiling_sysctls[] = {
>  #else
>  		.mode		= 0644,
>  #endif
> -		.proc_handler	= proc_do_static_key,
> +		.proc_handler	= proc_mem_profiling_handler,
>  	},
>  };
>  


