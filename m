Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1801CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C1558E00BF; Fri, 24 Oct 2025 11:43:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 371E38E0042; Fri, 24 Oct 2025 11:43:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 213038E00BF; Fri, 24 Oct 2025 11:43:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CFEA8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:43:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B27D9160ED0
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:43:44 +0000 (UTC)
X-FDA: 84033427968.11.D1072FB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6A8E3C0011
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:43:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ABdK/X8x";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761320622; a=rsa-sha256;
	cv=none;
	b=IVbCGIpMr33Q90kI5R57z4ItljUN+N0ZvXAh9U1jscvMDrujGqd8RiHAecQBTaQDEAuRBw
	XWlRe/pgzZhAyPc+dtSwe40XV72MLTWlM/y/xWAsh5X+6s71swLtpEjZMm4paqzhSNwWWP
	sSNSWq9Ul6ZFGZ+tq+kwN2p7dKEoAN4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ABdK/X8x";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761320622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ub0PNoE2B12NaRoLC+6G8KS0ixUn+UmUgZF/iuUYOng=;
	b=6E38LLT96SAG0Bgjw0dJqrFQBGf/TiVei9TOps+h36Ehbkz8wdMaLRJASC3w9LVy1nAnIf
	6cG395AT+wdXz8MTOZIniBv0ZHl8mUlXARhrT4UaiC5TdtDo9OJqy5zNaNo1chS73GEt1J
	UZ0n8vduIaxPlZDwdd+t2nNgBPnXt34=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761320621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ub0PNoE2B12NaRoLC+6G8KS0ixUn+UmUgZF/iuUYOng=;
	b=ABdK/X8xxeZ5Q1edV45rkY3WatH2vnTmDHneRxBArG27qVg9MLgFZjy26yhx+J3Mdz+XA/
	bwulAqgoAhxpAkqMAMYdNO4htFGB/Zf4aoTXbrVb0TWXAztFCIIVS4yOcm62Q19zNR7nq2
	qNutquO1lgtFrdme09JVPKAT55vbmXk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-ImUNvXfQNyu5gvo2qZweYw-1; Fri, 24 Oct 2025 11:43:40 -0400
X-MC-Unique: ImUNvXfQNyu5gvo2qZweYw-1
X-Mimecast-MFC-AGG-ID: ImUNvXfQNyu5gvo2qZweYw_1761320619
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47114018621so15714955e9.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:43:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761320619; x=1761925419;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ub0PNoE2B12NaRoLC+6G8KS0ixUn+UmUgZF/iuUYOng=;
        b=jNrH4a2e/kkK0fLdSVAHLWroRFinX3zPnIQ4hRNjdyhcMT3G/XqcB5umzgQCIEvQ8t
         vQDb4Ep+BDJml/m5FFx9KYChZR83PFFnEo8MBIdauI7dYat7xgRLK4UPyC3CgpLgLGLR
         Am8ZpRMBXE8blz6mdYuhnbJEJ7AYs/zM23pY8Ws8E0+pf+5f+p3v7zITjmS0QUIv2odb
         cMQOI5p90UJJMEg78jSeR91SIjgAN+2ELWD6vd8W9S/iegDX6rYc8OKYugR/DP5A7Lw/
         CimpIccoxhymd356SpJjspC23Nx43V9bXyVed9PoWITVWAnvTcVw/KJ326VKfeRf3W5u
         fb/g==
X-Forwarded-Encrypted: i=1; AJvYcCVkv13iTnbgdavsZeU5xXO8S91DZnec05dLGUm4CAD6+mByxHOQQjVyXhumgjlzT/tBzadVGaxfQQ==@kvack.org
X-Gm-Message-State: AOJu0YwbLMxzGUp6RDcPmbCfdnicWynkyUxrV9WdfqZCY70Vw0HyY9GQ
	UxNNgnmJnSVEn8JsoHSyI0UXUckIvq2SpYqEfKDaKYFnWsGPfqATrwZhhRnMmjsz2ylNzpm3ji7
	SxXy5TQtCadoK+GRZf7RqxqJMntJ7Zyp14Q/ykqwT9keBcWKi1PMy
X-Gm-Gg: ASbGncuOxffNydjI05STzhAPKqq8rJENWKSgkQ23nC85AyvMS5OpL6xx13urTZHneFz
	LuIBm8IcgXhiUyC+C26hnmG+8pVheiy2xIXmc1qRF3vkDrLklV0p1Xv2DE6ObWD+MQMLm3sWXPk
	KeUPisCGuPJeyff4lLcQuDTb6vYQBRSW9TKMUPYkbI5m1qZogfDfYHsUJPWpX27tP3abLkVgHqg
	l/RL2tXde/Wnd3Raj77v+R4mYf8PE/N4srF5/GGdIkbPHTEgcz3NwQFkBBoj4Sg9GiZkCEGC/ng
	bmJMR3NNLDD06zlOU0CtI5NkJm9U3ljAfMp/L+WNiH77AfuMCFxzoeKKawKU7PUrGkzELgGKDjB
	bhDMu37Dw034U2sTm0RUr6giJP4I3GN4dFEUcbEMQ79pRGHjKl02VmpcYx4hKxg1No7LhbLVB0c
	CYabixwiFUWIa58n9XB+RgeG5tvLs=
X-Received: by 2002:a05:600d:828d:b0:475:c5e7:e580 with SMTP id 5b1f17b1804b1-475c5e7e633mr67896445e9.32.1761320619250;
        Fri, 24 Oct 2025 08:43:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGcsWO+ZM/PYY8bptlnJAedXpz/Rg2rCmnppXlQBSMH+PbqY3P4FSmsB//MeHZgPtSXFS2jCA==
X-Received: by 2002:a05:600d:828d:b0:475:c5e7:e580 with SMTP id 5b1f17b1804b1-475c5e7e633mr67896185e9.32.1761320618878;
        Fri, 24 Oct 2025 08:43:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c4342946sm156957715e9.10.2025.10.24.08.43.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 08:43:38 -0700 (PDT)
Message-ID: <d186391f-90f9-4fae-a986-6a12ef393c38@redhat.com>
Date: Fri, 24 Oct 2025 17:43:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 2/2] mm/truncate: Unmap large folio on split failure
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
References: <20251023093251.54146-1-kirill@shutemov.name>
 <20251023093251.54146-3-kirill@shutemov.name>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251023093251.54146-3-kirill@shutemov.name>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IMl1I4mrBWHN_6MTo9apmyEBRYdUV5PDAiUmB3gSeQ0_1761320619
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fzfcmjzud3pijxtuqa88zeezo9s3y99o
X-Rspamd-Queue-Id: 6A8E3C0011
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761320622-136131
X-HE-Meta: U2FsdGVkX19vHyo/d/GKzXdOkAC1iQq7xd+s66ohnzBSJ2R/EPAhCIvKHxXwLWyeRsn3oQ/Qef4t50Z6O87bL4Buy0JqM44uNkHUWRNVH5YFKVE/n+uXRjjN3o5BqRcW+tK7l73TadBMATUyoYoR99pz+Rao+YEP+PQnCfWOIcHG472OBucCFXsdIceXCUmayU8iV+NtZK6rgtP/ASkK9SHPXq9itLLjnxH6WO7I2k3DwONzfh146kr7/hryWUOFN3+3IS/XU9W9bYR/LV341zAx9JHW/Iq/dK/CxrVOHJftySZT6pIntIfLLjjBFTK14tnWEyy+2TUAl8TUjAkLGX5cbRYyM3j602g38Wu6WrJE9d+rfHP37GGcam+Tc0jzfFVZizUFlboi6PHmSfHDPixHKz/WkoMePnwXMUNQl0oZwtrRoDGQKEg4k42eOwGYHbtRwWClc45OJDsl9d8PNfbz861A5WhdHsBowKy6q9HMnBvqAyBE485jjqoSIjjMQfFkd6OSN3RCJubc/VyjAtcj5/lv6aYpguqMD4Uh4Ir6sXbs5EjKJwznn/LjBFDfjnLPQ4dskwXGBZ+cbxbkz/805+g3uPLgYyzf033xiG4XYNlOkuw99VcjaGqBay+9Hd/V//rlYXrVLqS0qZt4mPZ7D6iBc8M0eE5oEH+5bcrUsTEzrIU9qLYHN6rEFrXK6jdN1PA7nocoL6qL2R1jgoOOwT5mTHxFj5e+KswJzWukpGxN/h5UYFJm8Xh0Eg3KNtUn0sYXVZDV7pypd5v02sqHein+6FFXEYMfyz0M09r8pu4P/1x7+b6bzVUHiy+qy6pGPXJwJFzSkeZoeh3TCcI/4tEhufeFtsdXvJ8BRi6AWotfLOSSW3Q79IaF4jqbpIfU83gkOcD4YQlTG3hM4d02jTFDrMPiVxKwY/Z+6Jtj3RfWOw47M4SULLB8CenSkdjMSpW/G6gkVescuSG
 eNPWhiOT
 5r/0xjpxBTGtxwyam80itZmMgh2RUvFaAc+ebYBD/bbBFidHsvnxr5d4393Bs1ua+wTfOYgBIpUlbzw+si4EloIzVqsI3GYidBIm23Ol0fDfS18DgMK7pZbB60P0oSM1WwoSPety1BiveaAwpqG0mvqZA9cNZnkvhQmvXzmL368eDWYn0L8CZYYRLLE9X4Udgrq2OaJtTzGSGLNTWNopD4riavXgelAQXnE0fnfnaX+sMvTs/AWW/9YzimHkjnB7xk9Er0SeYb4nBmuKAak48IwnppORRX1A6cSy8CVYfyq0UpkeicRpGlKAlUzchdCH+ELffESLmyBpSjkY8auwciN28/+GMRvpGrPiiFQwl5xGSeRLZbxUnsVh/cJgHr5Krk4/tWCirKfhy0gcalM2lW14aCsqMXAY8V86rCw/Kkkd16ZCRTJKsWKv+pOQ2ZCdFQ/myfhi0WD79CWhNE+JvuEUG/xL/1vnhWncuUFI6vcm7ChnhoUIACfXk3woGP8149RZgxjDm1saKNtcg+mAd1ls4Gg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.10.25 11:32, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> supposed to generate SIGBUS.
> 
> This behavior might not be respected on truncation.
> 
> During truncation, the kernel splits a large folio in order to reclaim
> memory. As a side effect, it unmaps the folio and destroys PMD mappings
> of the folio. The folio will be refaulted as PTEs and SIGBUS semantics
> are preserved.
> 
> However, if the split fails, PMD mappings are preserved and the user
> will not receive SIGBUS on any accesses within the PMD.
> 
> Unmap the folio on split failure. It will lead to refault as PTEs and
> preserve SIGBUS semantics.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---

Thanks!

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


