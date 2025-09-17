Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 660B8CAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 13:41:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFE1A8E0023; Wed, 17 Sep 2025 09:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD51F8E0003; Wed, 17 Sep 2025 09:41:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC4838E0023; Wed, 17 Sep 2025 09:41:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9ABB18E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:41:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68EECC0553
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:41:54 +0000 (UTC)
X-FDA: 83898855348.15.25665CE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id EB49C120003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:41:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gyRTh9ev;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758116512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j9LMOchMMyRjRRzN+kT7nX+PgJH+lWPkOhHcYp1LpMc=;
	b=Ft1vjnRr54Ba9fzdEkPtnnw5zd1TkgQ6c9wAjLsAN9SB9F7CTPQvdoZiEOGZ3zj8vjR/n2
	4BXEL/ADGNda4RC1Qgn0YK/K+7Bnq1bZZiG32NDsFbOVB5/9fGnP31ERJqTOlpphC5xd9J
	QSgsKNX9w73HpagWRMObrGErJIHB+Hs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gyRTh9ev;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758116512; a=rsa-sha256;
	cv=none;
	b=350XXwfXV0bK/iHH0nw4WCXKvXF/4lWCPJdjJhAr5l7CuLc8KZOQXluyZJRTlNOyfXwFoM
	GSgVgWITCTkFUHWx7Z5fZecVIHi+8/xcLlhlAdQwHpmPIPFmyC1Ap5UQ0ljl6Mg+8IuZQk
	LbuAM3AE4je8gaQjq64oksTRqv95cII=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758116511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=j9LMOchMMyRjRRzN+kT7nX+PgJH+lWPkOhHcYp1LpMc=;
	b=gyRTh9evTft9P0kEqf/d1NyjUTU1lV4hmvYgMAshi4X8/Hj2E5xmsQ3Du1NyvZd0EZ84CP
	snX8xKkB8Kx3S1avFCoiSlEC9kFsiKzvucmn0OGRqaLN8hQmesAAzTUdz2eDtOp7UdX0au
	VADZuK3FDHMpnqluFwM7QRcff9CcFgk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-6ZSl7bTLOOGjQmKNUEXoUQ-1; Wed, 17 Sep 2025 09:41:50 -0400
X-MC-Unique: 6ZSl7bTLOOGjQmKNUEXoUQ-1
X-Mimecast-MFC-AGG-ID: 6ZSl7bTLOOGjQmKNUEXoUQ_1758116509
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3e8c4aa37bbso1251823f8f.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:41:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758116509; x=1758721309;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j9LMOchMMyRjRRzN+kT7nX+PgJH+lWPkOhHcYp1LpMc=;
        b=HuWqWfKT0CAJrObv0z8bBeUelQCQv75IjnG1gUjAyHFFCAIDSVDKQT04aZbQcC4han
         voDLSZ6d1w02TIrXsuB6Au4ZhWVJ4SzIFMDvJFc3PAxgxtqEgOnaaae7ZKw0fSvG05Zl
         B/SAeuJbvuYtWZbP+QqHszPPnNqLyICkp5iCqmtCDxJkzbe5NdGKgdcaO94FB5EZtOKF
         i/BokZ8+SlJJClo6zB1nkjXdoZCtrRXaX6jgeQ3bf8X2FfvnfFEdp1NRKH6558G4iW35
         A7PtYnkekWztFdiD0T82KbhkhcGFetr6BKuETMCN7Lfeo7YmXrdtSFylf4N+JTerVspj
         95pw==
X-Forwarded-Encrypted: i=1; AJvYcCUmh6cP4M2pkMvzCWgxjPX7MhMxlixzuWvf0Tua374jpNU2wLJ/fcxsjHSN0htKHP8smKz4WDiOnw==@kvack.org
X-Gm-Message-State: AOJu0YxBKvH/ehnJjeq4O13Iks9+3CaF2rA/s2u5nf6sJIrxzWRDtqHD
	nU4SXTYqb/Tvb5zjZr99eIUL60xHM/WUzX4k8UBkzRH0aQVSCTiIR0klbpMNYhOfnA1WFMhzT02
	0r6mFUE2xDTtYTm1RDMuGUDONRN5O5V18t2Ri6RaRb39iXFJwkhPU
X-Gm-Gg: ASbGncvgbTu+ShdTzudA/0Wr8Ktg7TUSvubIYJ2S5kwfK+7RIMexDfcqMoXK/0Zsq9A
	uv/NW4gRCCRyetGbnXQuXr+HuUEM/bPxc3te8+gU+fpW6GQPgKKbtjEmnDaJNqx+xgjMWQYl8mg
	4SrHg5pXAEBR28xyHeQUIN8BfiCvimMJezEeaM4/bLY1kvhIp3XX3TuhXnbJJ4oZwFCgL9DEwrx
	+kkvc+/2s+14QXW5Jz7chAXO8DSzELV1ykNa8YWCK7UnYKr3zyvcjd/A2H3ChfrWmnc/65O033G
	7AVfOvcJuPw7RClD4tC3T7aArLuBoYy/ADWd3NEtVAGZPhECglIa9qi1VSSHG+vh8RiL+bJXPsl
	jwn7a7d/sQlBsnmOoptKEn14I0i4CVTCavDsE7Biw19fRMu9vBl4UyeMyogWPCU1m
X-Received: by 2002:a05:6000:178c:b0:3e7:615a:17de with SMTP id ffacd0b85a97d-3ecdfa1d446mr1736894f8f.47.1758116508678;
        Wed, 17 Sep 2025 06:41:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2wsn48aIbLhxRJMluX1pkl+z8XXGI8sJvZ1EmUT/hfsPa2xw9d1Th60HJN9iFrZKhSw2j9Q==
X-Received: by 2002:a05:6000:178c:b0:3e7:615a:17de with SMTP id ffacd0b85a97d-3ecdfa1d446mr1736869f8f.47.1758116508254;
        Wed, 17 Sep 2025 06:41:48 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e98b439442sm15422825f8f.38.2025.09.17.06.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 06:41:47 -0700 (PDT)
Message-ID: <c955bff9-b4f5-4b93-b7e0-28473766dd2f@redhat.com>
Date: Wed, 17 Sep 2025 15:41:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/7] mm: rename mm_struct::map_count to vma_count
To: Kalesh Singh <kaleshsingh@google.com>, akpm@linux-foundation.org,
 minchan@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, pfalcato@suse.de
Cc: kernel-team@android.com, android-mm@google.com,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>,
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-5-kaleshsingh@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250915163838.631445-5-kaleshsingh@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: g7uTXbW1FfREn0ysYS8UHgSA984qAdClwNAcApYlKhc_1758116509
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EB49C120003
X-Stat-Signature: rspw1hrnypcxiok1gwfqpc6cjyccfpbk
X-HE-Tag: 1758116511-734284
X-HE-Meta: U2FsdGVkX1+UFSXdUn4dWfSM74RGMGGVYr28HXN/52Sx1lD9KaY5POF0AW4benj/L4TthrKVY/xc1/dRwYn6LjthvJbqZIJ96pSTJqSS6dYAYPvc+Ocr+x0MJwXiuLJCfX9zYDUlMTcpDOdO3b6Xoo2WxU/v5GUkSjlr4xSw/B8fPWiTx/2DF6qQDgFEG0nvcm+jOq3NLh5Q2QxOKlNzN4accX9QyezUCo5dscBKuVyTirHuT+S5IKUdaZQ794Y49TCxpfKBlZtzf/rXAgxa0VdLunbOx9MrNLvzt5vOJJgrFDUYIFehysnQ21idZY9QikaitCjZvPDI0fo8qTIlXasl2ShQOPQx7jD5Eig4ApZ4CxOMVm0Grh7Ctf+USfqIcd1B++UqYgcu5261Jfl4ES85FK8Y1B5pPDnkJvhq8XCTOG5CTOIOJ3R0aYREtguWZsMb3G0cPIpCGRko3k0z05xVv9biU4bEZM10YPMoACPN1019+ISjfVuZA7DLN+ReXU+Wt88z3AA6ZMGTGl/qkcXnkNmxDw+BHy4Ol4Ipypc3QTvLvLMt4KVkAKl0S9AIugc0WUHKIbXZueltYlkMWZsinr8P5LPi6yDCGrlhPD2kM0+TbleNwRo0XHpRprxvWvlk3mIGlFt9CvBpGbKi2TTmgMUXBK7Tr1vzhzwZYT3iPVUnCkWX4U6cMvuAq+/TUtFcLLZ7xKvPOjYqPRohARhLb4Jq/lvkENdZ06yrmFtJ1EF8e6z7MuQlYG9V5e6cXKGLh1zuI+Oq8imYPwDLbKC9lAFHT45JCj9TBejH7QBfTg3XZVtfcBhao855dgD3CErSYnRooYh+Ih4sfym+XEo1dPEJL9ozFsycqgGgzdwg1dxpp6CR/U1EIZ+E9CftIJGuZJzh8jAdRVLHE25xrn0C9hDA7JEVwR/cy/VNwkBXMoXSbKnyhDiQkTN1KaS5/tyAfij0pLPyCOJibx6
 n6aeXhgh
 gC7a1XWFUOhrcfFYthe868lN8Yq1Cutem8BtrIfASrgApXEaw7o/3Fbs4C/fj3NEm2WdBz10CVgNdQO77elgXe+4mnmtolLjA18NFunp/pvVo5oX92jQZffYouUyhCYVi19FTZwTEonrGHO5PSCq0xEQFNthDkLnhY5R7IWIlRjzgEg7ADWMd8tZjb9PUPa0qt/RaFgru5GZfClR96z7uqdjrKdRhvaya92/8Wl1K0Tqwy6gNE8pzPfOHivlrReX0z6H2hOzrDsjvfGeyFrMu7z4V0lyKoqP1LPads5Oetp5k3VC0iG1nD8nbSLe0iRC37RjimWsq4FLPoQ9fiGyu77s/oOFqWTmf3leKUKBEcSbKYMugS/k6ElPgNsG81XvTS+oDlkNTa/0hq2RzdotJMxakwbYVETVwHeg/X0lP/Po735OKC/O3UbM+7anpnL9UDZc4po99ujNPluqChLxr4UrhzokN+hbDvuvfK6ikDnmANy3ycdAM+UMfwhRBb3+VlqgX2rlav6H0HQpgDetJEcLSkhcl/WHyE5ZgGvbaKmcTiI5gpRblLYC6BJVnZHBridg8pqrLT+MpT6uP47xx5HMJ+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 18:36, Kalesh Singh wrote:
> A mechanical rename of the mm_struct->map_count field to
> vma_count; no functional change is intended.
> 
> The name "map_count" is ambiguous within the memory management subsystem,
> as it can be confused with the folio/page->_mapcount field, which tracks
> PTE references.
> 
> The new name, vma_count, is more precise as this field has always
> counted the number of vm_area_structs associated with an mm_struct.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---


[...]

> +++ b/mm/mmap.c
> @@ -1308,7 +1308,7 @@ void exit_mmap(struct mm_struct *mm)
>   		vma = vma_next(&vmi);
>   	} while (vma && likely(!xa_is_zero(vma)));
>   
> -	BUG_ON(count != mm->map_count);
> +	BUG_ON(count != mm->vma_count);
>   

While at it, best to change that to a WARN_ON_ONCE() or even a 
VM_WARN_ON_ONCE().

[ or remove it -- have we ever seen that firing? ]

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


