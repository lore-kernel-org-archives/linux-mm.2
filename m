Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1F05CA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 14:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 337EA8E0067; Mon,  1 Sep 2025 10:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30FA28E0024; Mon,  1 Sep 2025 10:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200AE8E0067; Mon,  1 Sep 2025 10:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F189A8E0024
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:07:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABB4E160897
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:07:07 +0000 (UTC)
X-FDA: 83840858094.01.430CA0F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4AF801A000D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:07:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UB+FJE9x;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756735625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8phEHlSLnRxLufhaprOt2cjL5zUnMPeEi+VixSkVIU=;
	b=xrgpKXN5k+lJOLG2n9z2GyW6LKsfW1vI7PhD2U9Yfu9dt1mKznCyw3BRSvA+JtouiO4+lb
	5CRcmPFqwcC8lk064gOJ59g4VvGTugVLKGxWI9KQDoObOwXFt/yphAruHvWBRYk6U1D9g6
	YkvcWUAyefaD/WsHLk1McZZKQAcCCq8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UB+FJE9x;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756735625; a=rsa-sha256;
	cv=none;
	b=mtpylHOEiyHOkpT20m4xPFWilP68FTUZ9lvdlA1xEfi5k3UroKV1ya0IEQcs7kfoLoXr/B
	6PLG/f4kGU2YxRXIaiHlGetzdZ8MUCEAP+lEN6eNuIK46j1GyqUPKmcyK6bi4P2qpq0RJ+
	U8pF4zHaQKbXRz63yuYKiS/GcAzu5og=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756735624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=b8phEHlSLnRxLufhaprOt2cjL5zUnMPeEi+VixSkVIU=;
	b=UB+FJE9xuXUh/Sfrtd1/cuEmuFuJHNd7OBbBOaCEZESmxIHqy5C7Er170s3ZDyMa5UnAHL
	WFaVFNPnYZMxlzvS8UBBhzNXO3rh+YW+9T8wSzXDLOxZUDR45O8Wtv/4aKUR+paOe+9w5d
	Tsr6MMBKA89NKhbGZ7u9LbEleH06XRs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-ZOn5k5giMAC7x5FcBjEnDg-1; Mon, 01 Sep 2025 10:07:03 -0400
X-MC-Unique: ZOn5k5giMAC7x5FcBjEnDg-1
X-Mimecast-MFC-AGG-ID: ZOn5k5giMAC7x5FcBjEnDg_1756735622
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b8a307c12so6570695e9.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 07:07:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756735622; x=1757340422;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b8phEHlSLnRxLufhaprOt2cjL5zUnMPeEi+VixSkVIU=;
        b=I6mIGcFW+Ybrm3MwfY2lTPE1JORmwU+clhtn0PQpYLm2ZYt4HZmvleQWkxPEZR98Aj
         XXSb83NteKQC6N6ug6qiZdMB/ZxrvPiGxm0L5NUVQKJuEMHo3nOXBS1gi6iLY3z6oVlS
         8R94l8ZBYt+x6erCZurLHroORgpKptDB9+CPhVtFz9sQpHoFKerpAvx+7q4LLj3o+drX
         DiKx+BAGonHR1c2SaTzX9aNUNMNm5+Ji7EEdbBCrl3Jf6b1GM8iMSCp1XQZkiaWNBw0U
         LxB5LUBSKMx/P6dvC5+bbc5bk7DGQdLLNdoLBX3dFzMoyxQabh832vyhyZE9TGPG7MMW
         N8XA==
X-Forwarded-Encrypted: i=1; AJvYcCWIs5RXLK3qugUZYvzkLBujOuN7dPfMso1xQp6yRslfI0UD+YwBry9Fn7q7RQJGtj4z+SZTheQv5w==@kvack.org
X-Gm-Message-State: AOJu0YytXrNai6CRgLF0wnje2GXrgzpNmamVK3XTIgpUVuMuo/iDpPMI
	/0JMwQxlbzBqblL7CfUTPH4eD9O39XcAdL0zx8P6n0q++nuLEsVrumD5amejhpT8AIbYJYTVl0u
	WQRnthAG4IUSNflS+K7Y+rgscTILQqCK77DTtSMVHVqsxRos/HxqWI+zFOa2q
X-Gm-Gg: ASbGncvO6BXQLYHLTTw14KIZa1e+RC3RIT6jVE6/TMyoybFDsRHUzZH74vem5kJgRbX
	c9Ux4qkbe+3G7AjEmJrrCP0WcFek02ncM0Bi/bVbX2TDgFwXBXmdnmns8iUTVBFfQtZg3lSQpVj
	2btqSgDOrS85+bgRH6yLQH6/wzcxC51n4VVtwgERnzwT4z7QQEQ0NpQwJ7LEbN+Vt3IjUpnn7UT
	YAAIVIqQIm6WK7Fj6VZJmhJcGXOI7pmwms+JUcDus5KGQKi88SiozZ8kU3TzSnz7WfOtIXFOKmY
	F0Irbq2toP003ZdkPdjecymYotzjuUbIfUdRurBP63Ca06sCQwltDq8zajUTOyWV6L6yy9HtSx8
	EAo6LXokU+XMYsztUQuIOYg5rjr9bf+Fk5K718VZAkFDgrQZoM47ITqgZ4fmYMimahvE=
X-Received: by 2002:a05:600c:484a:b0:45b:85d0:9a0c with SMTP id 5b1f17b1804b1-45b85d09ccdmr50143285e9.15.1756735622259;
        Mon, 01 Sep 2025 07:07:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFc/fzqFhcyBDKForO8lAi4OllS0y6HGtqOEpvIJOxrpYoc27SWP07i3IDs6oE/SD7LPI4+eg==
X-Received: by 2002:a05:600c:484a:b0:45b:85d0:9a0c with SMTP id 5b1f17b1804b1-45b85d09ccdmr50142575e9.15.1756735621736;
        Mon, 01 Sep 2025 07:07:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d92d51982bsm519348f8f.21.2025.09.01.07.06.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 07:07:01 -0700 (PDT)
Message-ID: <081a7335-ec84-4e26-9ea2-251e3fc42277@redhat.com>
Date: Mon, 1 Sep 2025 16:06:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/12] mm: constify assert/test functions in mm.h
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@HansenPartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-12-max.kellermann@ionos.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901123028.3383461-12-max.kellermann@ionos.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cYeXO8IQn3J5X4x_w5nBxFqsDuN8HrX0ULlLx7rcJHQ_1756735622
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g3j55phdd79ph67s8igym68uitxxn34q
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AF801A000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1756735625-287438
X-HE-Meta: U2FsdGVkX1+8a2nL4VpL6ge6w4DFwfcNzi5FY5RTWQ1OkcrfsD4MXkCa8zpsuSGubVhQY9kmP2F8TDv73xhQuMr3IKU9v9fVkvnu1eIF9JHquXTf2p5IU7M3Dy7j9THFzeUiB7uztcz+GUrDqhWcjgZWV7F5DgMMR1OQzaTNaXSYrPlzTnuHBSv70HxbIjXlRlnLhm0qg4nw9Cgn81HKjGT2QGEScCPIcRSqesWthFx5dPtuMcjxYrcI7i7KIKtqlYC3BvvxyMtZBXWsU6HaRmbz1c7i0OJ+NQPcpunU2Hst4RVdUhwFZmtnyTdc6ampq713d8lFY6GFdlW7EgbNx0BmVLuVIGV99gg+8e6hzGVXf/xhtpvDzsvuILWn540olB3Lfte1J1xWE4FKGYXFyjACdNijiKW4hjWS/AIkbNRqAYjH/SpfmVlK4haXoY+8+HOwZUMfG9cXjRsU8/0g6S6LYT7wCFIsQakBaz/vJBX9m2jrMW34e6pTZ5OR+sBZIDQZebdadTsTbNOUnTTNkG1M0Fmu1FITe9Wx+RrSGJ1usgtAD1La+Eh15PaXNh+YjnxQcMFxd5xSC6feWgA1BQo+CZqcB++Kws8sA3zD6vK+PXSIuiaLKouYC77jA0pGgFGKsTLljU+A69Cjadj345JULxmdiL3G4JGNCF494SBBa73hohUxPnxVNM0U5FK5Sem7Ogw40R1+rE4bIlW9ePhz/F7SSvKo6IQltieJjPHEVJLWoUx9Gt+nSvNDfLbJopWX57WyumYa9/LfDzPpqBW5zQEDuW/PKb3TLaXyGt8yIJ4lRJALnQLdi5JvDlGsJQ5x25i0KcCDvKVb7fMDmmqR8bYVHwt1Nj+ZzfhgT11KAxqn6/tO0uBaJonqhMLMZV0/No/PurBtCB/WXryRGjt+8tdjGLnCMQUfZLDkTcZoKZUrtrtv2BgmT1m4Cg0rjg1sc0ORc+IaE3l1w4y
 p5G5CRdf
 QN56eVHBDkyuSQ59Hismul1q+0NnRXcdiWSpIiZWPWINZpFlfidjaP8CGsAF86a0nxN/L9OIekgtsN+2U+5TGFua3CauhiyWRUE1YOW+uiH89NTztEcbdoKCElbt8buLmWB4rI36zHFOPwsNofHRE5D0ZL14nJzhF6BnkbJBFlqhyAN8FtrJ5b0v7JfDcGJfdvUK/h+R/KnG9u0yrRtK3Nq4sjHZ6TkZ6ysLHIyKV+Qq2oU1V7DgnVHTmNJ4hTSUsDZPLKfXX09z1OpMDJrsrU4v9TJN8eToW4AnQHf4mY2sTcY0aDuUP2BGtZshjeu6M4Ef32QarOyQ7TqIAxvLjvR9QIXAHKJ1MkFMQSZrTPM8c0jgb7wNA7ArWWUc197B2qCohNy2/lXqK4uY5sEE5CoiDnF1cO0Gji6Ty8eDxmUZcKzBq235P2p9uHNzunTgh6GaaqlRp6jFir8zBT6ffheWvzxyXI+LLOtx1+sUvQG7wmpB2j3cX2HHogr4tImpR0i3y8VgJ3CUBTjdbfA/pGmF7fY7JhHN0JzY11S3W7WOzALFcx0YrtfeDndj4nLH9DIRu2ZCIveeZWlvyQmCNjT7vNBkFLU4GmrJ4NjR/iQfdPhl6t6gGUwLHBRdyorRxuAkVUX4AuOtKTVo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 14:30, Max Kellermann wrote:
> For improved const-correctness.
> 
> We select certain assert and test functions which either invoke each
> other, functions that are already const-ified, or no further
> functions.
> 
> It is therefore relatively trivial to const-ify them, which
> provides a basis for further const-ification further up the call
> stack.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>   include/linux/mm.h | 40 ++++++++++++++++++++--------------------
>   1 file changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 23864c3519d6..4cca66ba8839 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -703,7 +703,7 @@ static inline void release_fault_lock(struct vm_fault *vmf)
>   		mmap_read_unlock(vmf->vma->vm_mm);
>   }
>   
> -static inline void assert_fault_locked(struct vm_fault *vmf)
> +static inline void assert_fault_locked(struct vm_fault *const vmf)
>   {
>   	if (vmf->flags & FAULT_FLAG_VMA_LOCK)
>   		vma_assert_locked(vmf->vma);
> @@ -716,7 +716,7 @@ static inline void release_fault_lock(struct vm_fault *vmf)
>   	mmap_read_unlock(vmf->vma->vm_mm);
>   }
>   
> -static inline void assert_fault_locked(struct vm_fault *vmf)
> +static inline void assert_fault_locked(const struct vm_fault *vmf)
>   {

This confused me a bit: in the upper variant it's "*const" and here it's 
"const *".

There are multiple such cases here, which might imply that it is not 
"relatively trivial to const-ify them". :)

Did you miss to convert some of these cases properly, or is there a 
reason for this inconsistency?

-- 
Cheers

David / dhildenb


