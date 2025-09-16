Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C1B6CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 20:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 388698E0002; Tue, 16 Sep 2025 16:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 360138E0001; Tue, 16 Sep 2025 16:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275698E0002; Tue, 16 Sep 2025 16:48:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 111AA8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:48:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ABEAB13A960
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:48:03 +0000 (UTC)
X-FDA: 83896300446.24.2634BCE
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id ACD7C8000E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:48:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d7Rp+Wxj;
	spf=pass (imf02.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758055681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wnUpZJEnRBwm4SA8hacWkv0qxtpcVpis+ipIASBsxLg=;
	b=KOS0A8tjxnTYaebhhFGOqI33xpz6dxCdoRUY8yt1A/xnlf4r1p7vDasOqm0cb8id01yi8U
	obEm5eCvk2nq9EF46x0un/T24p6l3xHeNYdIlbLl2dpYnNsRGTpxRPkJbFPqbwf0hOHUce
	YwPjw2RxuuTsQYQkl4TfYfTwKYulW7U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758055681; a=rsa-sha256;
	cv=none;
	b=hOPWEn/zcu5Iwvbocg2H5xOQB2pUzsa4wjyKxkylIOJqFzG4gSwTzHIWIQU+mRs4uYywf4
	7JU6UhtuSF3t2PAx52uNpalFGnYPqPyRScVg0LRfHTpCKo/YRSpBXSc01OS9R1w+HbNcPW
	FYbi+e68SX2WmfNcYCQ5oQbqT881IDo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d7Rp+Wxj;
	spf=pass (imf02.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45dec026c78so60049105e9.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758055680; x=1758660480; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wnUpZJEnRBwm4SA8hacWkv0qxtpcVpis+ipIASBsxLg=;
        b=d7Rp+WxjW2Tyzb9jPUwOkOq25I515MnYI9JYF6NVVQa2hVN+qG+OEo7WMy3GnigJl/
         sY1eWMxA70BWLfl6U6FLbVWvEezxvEIQcDrd86QY3fcoTeKnEQL5vnbOxnXAwlIpFm4L
         VQleshgDMx5I52Zow4fWWeJvp5TAuUDcxsVCvsrxNqIRgadAMYB2q5NVPnechdbJQfTa
         BJMmoiNRZCTYfZ/w9Kmcd8tJWNdX8f009yawKi49o0kE34uGOHDC+TSmeTdzginOm1MK
         VR6XOkoKkLTuWoendCfyoMmf21jubHf+XHWpCHI5c4zbj4Ht7EKIs9YcPlcQ1gd+2gkc
         Zm7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758055680; x=1758660480;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wnUpZJEnRBwm4SA8hacWkv0qxtpcVpis+ipIASBsxLg=;
        b=eabBfw39J0oxMlECID6SmVo4F9oajHr3M6fIusdiqC8Gg1S99AhuBk2c23ETBxm6SE
         PCHmZ68+j1U69pWezHel+xIJNVmzZDTmsSpILvQqJok+TJmMk7dTJoQLyVBI4CdU3vCk
         C6M2+QFvHCgDxn2kO66TOPeIT0AVQpM5WQBWWsNNtq3rXkomGWz9uiyRmaHaVCoG+gHK
         sKF5JZ1bDdBp5F3daTDqf/jmYALUJhPuHgKb1hM6IzHT5y/hz8EtKZgS565qg43rc/+H
         jrDGrFDcFfvcInT4MEALqI9EXMzyi9lqDTsPbN0c370REt/yMPUg+raIPTIwxyNPDCWw
         kZkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqnZCJ2TVxRuhLe4ykL10tYwiKhrmRnSTVfy8fZwgOqXt3BkbHzdiAk/9mG2OMjQ6cjM0zz+uu9A==@kvack.org
X-Gm-Message-State: AOJu0YxdLTAPlljlVKuuMIp8cBzbOozyoaTfDhbcwhzwKZ525fTM9ybx
	Imzq4GSL+lWpoY3uHDcVi7GbBNmIgcU3rWRmNLPueVo6sMqMuCX0Xa+U
X-Gm-Gg: ASbGncvR47Gb+qZEdkdavYhHOHAMi7fT/zX+95HlR72zPzQuXIcC6y17mRbFfR3PmnQ
	rz32tppV9EriK6p+5stHMddCJba5Ry5gheXDupFin459g0gykI7aKI6IoIBc3ZdL6dSrcrvnVEx
	D8qzgTTT3vcKbijRCmKdT5951V45ssxMUfCDsS7WtOzMCw80njIKymlNjmmcV+EUlWg0WH0ZRc9
	H8ZJIdIgF6jNO9Sh15JJtTVVoE7m+WCvYwzfVsbWiKBd8//+nsmPvQwpB9YkWCv/pAq0eMMSge7
	Ho6MQK/WRbqozP3NZDi3izkakhK3KIv3A9ddrTk3ElXKlxEgPVt43IzNlugyFd5DUq1L2gYQQq8
	7ayW8JHFBQ1Ya23zRIqkCFPkVvPaOVU2uEyZD6vPw6f/CfmfU8oUhZ3GAdkJATyTE4s4+XllQ7l
	qP0PMHgt1VDZdDRv8FvA==
X-Google-Smtp-Source: AGHT+IEkxcTio6GGFoM3muCkeaaC3BaAbrW6vbBnnuCs4pDQo46lP6f91xDpDnWdbW4d1+fTPKzarQ==
X-Received: by 2002:a05:6000:18a7:b0:3d4:eac4:9db2 with SMTP id ffacd0b85a97d-3e765782b5fmr20202818f8f.5.1758055679917;
        Tue, 16 Sep 2025 13:47:59 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23? ([2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdb0a2752sm2366465f8f.56.2025.09.16.13.47.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Sep 2025 13:47:59 -0700 (PDT)
Message-ID: <4429cad8-5363-4bd0-8b7a-36396d322464@gmail.com>
Date: Tue, 16 Sep 2025 21:47:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] alloc_tag: avoid warnings when freeing
 non-compound "tail" pages
Content-Language: en-GB
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, 00107082@163.com, pasha.tatashin@soleen.com,
 souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250915212756.3998938-1-surenb@google.com>
 <20250915212756.3998938-4-surenb@google.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250915212756.3998938-4-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ACD7C8000E
X-Stat-Signature: ckfs6espb5ng48xpuodshct6ex4cii4k
X-Rspam-User: 
X-HE-Tag: 1758055681-43728
X-HE-Meta: U2FsdGVkX18RPqGHgWF7HKo47LSYvn3FKTgGJhVqmcwxFVz7vYz7eognxyxMwFLuz3zA0gfUGR+YFyP8fDuEt1rXkAVc1NbWp/drlooGp3UuE+NfwsjydDZdaLDeA/yqxkZkeC6nym8pMkjxq93wvZy/vVO+V34Tq8CQg/7pqgsdp2Iw8q5jLQYJKHabHi/O9vWZX7smcqBxuUiyHrn22JG1WvBkd7CA4pEEqDV/yFgfDQnPXB5k/eYlUkvKRWbBAzYP6/yYbR9ynUfioRA+Z7AGii1IZw3XeuvNMN24UNG02s1oxw62NENl09F8NCYJajcXTWowwhdxgTJTfB2lHrRnMxYYY9upB8GznBOtFGohMQrX2miImC3R3Olaw6h7xLgAE5D2G1tDefIB/naLg8T/yrUekPI8bt+6dEiDrvg23vlh7YUvUBUXzp+Gthd1t0v2nGoXioRYdfbKanT4lGtKD2PtvXUU1A8OX1xxAzLlGJ1CWXy7y7C4JetG6W2sdviwF1PEiNgu0zy2oY/nYNT5d4HGrWOUNGi8MP1GG5gkGZcJuQzKHSZBy1MRVpwdqiD8oel/uIWraxQw6XWCLcyAfIkBFdf8SJXUEuxpV3EFiI+midjkAP6IDFDnl8Sk/TDTcNE+/HwDjdwtMJ88k0/5EuhtuKS4nVE8w9+h5zyXrhDwkyL2Nn7CFlOF/+bU43Tu3qUHabkmz7T6vYH+WjeZMKGKnfSKUGjdETqUwctcFbM+tW97lImIM2DlAe6dD+Ohev+QuNdSeRMpLBEe7DjNsrH2zF6XmA9x+k0DIMApiA73FKzVcIRjn1f80/OsGyLD+3T7XVJggQY5GJ2eTuQ/w5Zm9WE4dNVJqCye9OVyY2xjG1svQkuGHMOdtuCul6jbaVEU/2sIi8QjoRHFexttmHmGaT2hrC7ayyHEcQh3Wu6vZtD/1IOJ8iLumtjZK9HIwr9HE0SyxkR0rRk
 XYPJ5pCW
 a/SSPTwIJ/ITWKbbnSpIB9Gkafv+Pl7ju5xXpQvOvampnj9r+LUqjt50VZmh/CUSP1XtelgZMFxi8K6lb40CEKJHJ0r+mll5oO0dj+IyRCndu7PjmvQsteicq8xCfwBhZ5VuO7c7NWwu/iycWB0tOAe2jL/Pjvtf7qiD2vJ9mN5qV49zX7AP1rOpzVwqZFdJq0vyic78h2SvMVLSEtIfjh0TflhfV735Ir26Qso7qcp8kxFb7ffXaM1CLMcut8PziPqyU6YtfE3P6K+NxErqcqD/EqrpdNgqm1+oxYlgI1meIyP2iAKRRLTn265mDGDzbCLX4o5xXDJjjmKUiNrX0LC4PB4z7Ma/H0OhHAo7d4cTlsnRTEtbr8npyg3UVqr+6jhN9FaNTShV8YXhfirmZBdU+s9zTfqNzhfxm61aFd/jzv+snpjjmF3MCgxCO+FgSZFBtb6H30pNCo5n27pShB7hBqH4n1dONxnxt4vCEpwkrkmS1smfkv1Jw3zSdWqXxlwZ6SnPTvI0zgaO8m00LMQYnd+TorfzQMQzojpDvvreTKKgPOlPbMPYofUusFsL3PkYeEI0Ig+MTsdUKM2AriFackyV+lmwvIWmJ7D0G6k39qfA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/09/2025 22:27, Suren Baghdasaryan wrote:
> When freeing "tail" pages of a non-compount high-order page, we properly
> subtract the allocation tag counters, however later when these pages are
> released, alloc_tag_sub() will issue warnings because tags for these pages
> are NULL.
> This issue was originally anticipated by Vlastimil in his review [1] and
> then recently reported by David.
> Prevent warnings by marking the tags empty.
> 
> [1] https://lore.kernel.org/all/6db0f0c8-81cb-4d04-9560-ba73d63db4b8@suse.cz/
> 
> Suggested-by: David Wang <00107082@163.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  mm/page_alloc.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 

Acked-by: Usama Arif <usamaarif642@gmail.com>


