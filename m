Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D4C5CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA9228E000C; Fri, 12 Sep 2025 05:28:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53638E0006; Fri, 12 Sep 2025 05:28:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A689D8E000C; Fri, 12 Sep 2025 05:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 985768E0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:28:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E41313BA96
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:28:33 +0000 (UTC)
X-FDA: 83880072906.23.FC7488A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id A57021C0013
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:28:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UNeo++ql;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757669311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q7Uh5PTxD7ESGcT6/GtnBW9W4Q4JZO2rqf/t4H/Zr2s=;
	b=MdhIXcJcVTvdLosxy1jNM0idfbhohy7gakeN7x+gFIJpCnZK/19aPGXDDmcNtMk36wgRDR
	XVOYZ6sHDJh1RT0+L9VFohYatJkbPwQXDg28dflJq3w9zzK5vw02VTAyZM0jtAjn8uYuvI
	b1PDGPe+hcv3Li/XJ9O9ZiN68Jnw8uw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757669311; a=rsa-sha256;
	cv=none;
	b=wfXo0e/uaYLLsYvfB3XH+vQoHFBG0sttko9dbkiucijmSO2haHun4ilBCd4QjSdq6gJRoD
	Wq7mX/J6BY/gNRfuaEF3LUkn0xeS2O9hSMnYXWVowJd4RjelXdEUdKUFctJ64TiJCXjWaA
	xnMmfrfjcWBiaPQHbzX3/GHzODD1m8Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UNeo++ql;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757669310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=q7Uh5PTxD7ESGcT6/GtnBW9W4Q4JZO2rqf/t4H/Zr2s=;
	b=UNeo++ql1l0XA4rKr/wpLG5psDirQ253X4FRj5e62jKHrtg+Is3fNgjrpm1Wzbuyo/Wmha
	/9c1siCVKUqAACevYb76Zh1EzEtWjB4PyThywfPOINbS8zTpBpajDZlpL7h14Ouaq6d2bJ
	ytc4oeGyZ2erro57LK+vYalfmn1rinM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-SrHLgijCNKi_ba4Odxmpjg-1; Fri, 12 Sep 2025 05:28:28 -0400
X-MC-Unique: SrHLgijCNKi_ba4Odxmpjg-1
X-Mimecast-MFC-AGG-ID: SrHLgijCNKi_ba4Odxmpjg_1757669307
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45deddf34b9so15979785e9.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:28:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757669307; x=1758274107;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q7Uh5PTxD7ESGcT6/GtnBW9W4Q4JZO2rqf/t4H/Zr2s=;
        b=ewY4CihCKAh7oBXT4q6PRucRgsjJaVITtBMpGCJBWSSMomPWh5DSSUrqHXtWUEE+bP
         RvHEvTdL+2aHo83nhqCyhXj8uZ89EDudTh2EJXOgrlKRHiuI5AJSxRCai5zo/hSG/ivm
         ot8ZbZ/XpPXzN2BNKpxVXMNFShJ1qnqt4V5M8oj5sQUctHg4qMsM6mARTXq8XEGHmole
         +WcWAKh7FXFf9rztfaLFJfsCzZ2VYcseO98PROKF0ffQCnGZ1psBdCN/MEoKkMNXwMfP
         JBQTjYI1Ojd/Gov5QCOc2zvvLHKAAWpbvKd0F4c9aGNhc4ryIO677QfuI0RQTU0W8bpC
         pBAQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0YM63M3bW9XskgxM8Mr2mChku8Ku5J4DwtLh//YUpFhdLej8yJtjojUc3Mup8kQp/fZB/oDFCcg==@kvack.org
X-Gm-Message-State: AOJu0YysaZ5j8yDS3eYKJUDNe0b9WI+Fwu4/8nBgnata4bSJULSStyT2
	DieO3f+GzheXfZbym2kpwsJFJlHzcSNciDuz5y0kO/2mc7cQYlboBbe9dUqCe9mKrB26YnAl4Vh
	E02j3FbeLqJ1b1yYlCjOR0IdSSKchohTR3SHqugxGRkCGjbdpw/jn
X-Gm-Gg: ASbGncttyV+F6msMGjdTa3WMRgMq37Ag2xR0GiTFe1Hv7M2hz+M8oTejXuU00xzH/B9
	nq5xbz7RAJcyZ6P2e+qpEIxxbRarU0ReFJVc/PvJKn/gAuwARrqysr/RP/vwp7s5xKjnsxtNNR2
	nU32Z9uNT40nA9XqGwR9x/CcPBUEgerQQANiiw4W2HUwYGtmjaNzEFVv3iVNQB9xRYibY5prTch
	UPIdmRmrs0FGB8D25nkyeiJ5o460DKKM1NFV9xGCUc+/5+xXkSVrKGbWPwy9MMok1zR0Bn8kRP2
	qAQ5M+nJ+Izoozd7czl6HMcF1HVzUz/URTQNKh7d7XDRyled80/jyrberyNhISkqJ4oBKrLqI29
	n/24QPbdOtu0wUAwuCbdTCQ0S37VjziHSt2GO1rqcT2Cwnvuk2iHqvgBL7Jv0jx+T/tY=
X-Received: by 2002:a05:600c:c3cf:b0:45b:8b95:7119 with SMTP id 5b1f17b1804b1-45dfd5c0dc5mr36986515e9.8.1757669307384;
        Fri, 12 Sep 2025 02:28:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZ5nV58Kk+xJkGc6fU0GXwEXnehySepBoJWxSSaPQdthPtf0Tvw62s50h2qqfl4KIaewNpfA==
X-Received: by 2002:a05:600c:c3cf:b0:45b:8b95:7119 with SMTP id 5b1f17b1804b1-45dfd5c0dc5mr36986305e9.8.1757669306984;
        Fri, 12 Sep 2025 02:28:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607870cfsm6004344f8f.19.2025.09.12.02.28.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 02:28:26 -0700 (PDT)
Message-ID: <b6f38984-5f89-4a9d-a905-ddcdbd7510a3@redhat.com>
Date: Fri, 12 Sep 2025 11:28:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: transhuge-stress: fix potential memory leak on
 realloc failure
To: Haofeng Li <920484857@qq.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, Haofeng Li <13266079573@163.com>,
 Haofeng Li <lihaofeng@kylinos.cn>
References: <tencent_CA0C296180B9D75FF6A53D6B4F2130888D05@qq.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <tencent_CA0C296180B9D75FF6A53D6B4F2130888D05@qq.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JA64cgGiS3u5dNwS4OV3VWJu7Vvus9PeETrtO10aRP4_1757669307
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A57021C0013
X-Stat-Signature: 4nh3nfdj1xjo7fym7zkh5h74rb1etckk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757669310-561926
X-HE-Meta: U2FsdGVkX19bjpYekOkTMNBAOdKRRMHZpVaQPWt4kyS2YzcKMcM17Ttm7CmAYsX2siwvMi5paAWsuyk5YGIxYT0EHIitj4QloWBVWGdAPVL36UjkkM6kAwgb0i2j6D/5HFU6wEJC8wS3P/d+ui32appHshOB7YV3G353u0D7+XtDvH6sKvd7/ZFKqPXcLjQPvx16rvHiW/sDn7xL/EuG1RCfXQIqtEqJIcsoLTguVY9Q8yYj8ptxLclhuvmmkOhxnIGn7daH11frZEqY634PmBDxhmeQop/OqaHIHw05KAlQdqsZEFUkZLek4w0ihq8ML6tTfWKooAVN2SY4KUiOi4NFJCoLwkkCc5skLDYLoPdIikaJgky96Sx7Hj+YSGZRbCGubiRHPBQ18O7jlfO0gSpElxZ81b+kDlK66o3KTg3Qv8nfJ2bGPtdOWjmwlgcfkBXHNLpmOD6H3MpO/vfY/LVtCAvbdbI0HPkrKxjf9t0wqf69vxPVDSp5Lk7F+bQebQhfmPzU84Z+kfg/x4RR3/R4NYBcg+Jy1I458Y6kFjlbUA/YLxMIpvNDPNHP+7v6ivVsbf0h9SSITEky1adrXjU6PS93QbyoerSyM3iRkmVR8TUcjiN51sw6w0si/fINSo4q33qkZuozBPNR0aUJe9lsuanaNtyrStDHPDu455qWYBisvUBfBC/B+Ev7MFXxC8wMzPoeH5KDMXZKhOTrQrX+7mY8EQTi32+6OikPHBfyXCgCyTp7LvEYyCnZLLwCduAZcTMwLz7XthSnIt5VOgpcC3TUpw88OeArduPfqouqBbURRoL4fGbjQrZB+GmTWiYuXxlGe7OQAuCPjto9kIhsFaAm0tjT1B9jB45DdZBurTLc/XBXwPwfpKALK3L8/3HeMcKCucL7De7T9wwKJK0wYIzxXjMMWd7N6vjKjDfRo2wD+39MYCciedtu+AWMFbRPP5vMIVFfIHSRRv+
 MuEGDMtz
 FNIjBRZDvs81xQkkq/GJS8uUo20/zVoyK4uBXR8p6r9k2mcykMbr9zUl2ng1n//y7LEoEhkUV2jEfv2+uMC7HB+mnLil+v2FSUmZTNCcbbHbTlY4ch8e/FSf7wiSM5yvJymxgVF5+uXQvBX91MbnsAwcnTXgjRlTVRDPLkad5gsW0gzyJHwt3PhbedbuvM45TF/vpeso3edF8AH53a7JznifWHqhSDrPz7QvooEUVGpdK6GKN2qtlUZ5xGu93G4VOKzGufTV2uIpI4pag2Wp+8AFf3vYKf7l6QbxWVDqH6tiQp9K7LxTDlHyPcyZ7UFg67gAK1RWZiQ8bhIqpzJwO6jsOu+rFmBQoax5RKC0ojE1neDZ4BQGV0kKajpKIu7T7fvmT2sYlid7fYR13EccQ4mg86wjW1s9uA1m399CTxyBazu4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 10:20, Haofeng Li wrote:
> From: Haofeng Li <lihaofeng@kylinos.cn>
> 
> When realloc() fails in transhuge-stress test, the original code
> exits immediately without freeing the previously allocated memory,
> causing a memory leak. 

What do you think happens when a process exits? :)

Correct! All memory ever allocated to that process gets freed, avoiding 
any memory leaks.

-- 
Cheers

David / dhildenb


