Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82B56CAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 08:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E095E8E0016; Tue, 23 Sep 2025 04:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1398E0001; Tue, 23 Sep 2025 04:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCF828E0016; Tue, 23 Sep 2025 04:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B4F438E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 04:26:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8064EC0819
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:26:29 +0000 (UTC)
X-FDA: 83919833298.08.E0A085B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1A05B40003
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:26:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UpZRkOb+;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758615987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u158U5eLLkY8pwNFzJaS9pMnHCqEcHc3FLks6NqWdoc=;
	b=JceT8Qllm+gkm9VNZc5910dAnVPnjQdNUqyTkKhqFpfleEQTVFXaqKk41Yu3cxDFd+jAyB
	1RGB8gpt1mxQ3KJdqOpLidYuMz4zvVbJxX1GRpWWj3JngK9Qe/zxPuvfBrZHS0ESTsTJbk
	EPY2QQ2Z8DlSDxOfloR+YwxAKaOnXb4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UpZRkOb+;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758615987; a=rsa-sha256;
	cv=none;
	b=oUNcXwpk/IzcI+1ioNlgZ8Nm5KB6chGSioo03uWdku7zMs40kzbmXPNDMpYSWk3jzOTLcb
	g2H5rLFu2JI4s1HLwBuEQ0fTZ/A/W3IGjUYEWE88bMOLIDfXOy2FNHQkz794+0dZhYf1xC
	uvguDRvGSdzMR+wg44h5Mi+hYNO6Z4g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758615986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=u158U5eLLkY8pwNFzJaS9pMnHCqEcHc3FLks6NqWdoc=;
	b=UpZRkOb+x9uOE+USBLDAJg8VSHcIz9gWxOpcWbstYtbAyMj6FsTxlpRZJbk8UK13zL4h46
	N66JxVOBpww5WAAcXYdyJm5AQwWE1VUuaQ7wmroYXYTqLs0ytvcq0EosIl4HE7lj6kHww1
	A31qGkxsaO17bYjG5smN0iuI34RCFCc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-G31zLsIgNKKfLXXsCqSF_A-1; Tue, 23 Sep 2025 04:26:24 -0400
X-MC-Unique: G31zLsIgNKKfLXXsCqSF_A-1
X-Mimecast-MFC-AGG-ID: G31zLsIgNKKfLXXsCqSF_A_1758615984
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b990eb77cso18007095e9.0
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 01:26:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758615983; x=1759220783;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u158U5eLLkY8pwNFzJaS9pMnHCqEcHc3FLks6NqWdoc=;
        b=ldcj82z2L2I+1rSFJZCRmQvXpERWVCgSDAZrdGzSUgzC8qCir69c5t1um9yPvbG4J5
         Uc7Rzt5Om4S6oX7G/w2sSNRNpsM7jR2sDdSW+dWZ7YFsg3p2s1KXU1dU0/8QucmETfyP
         TQl1HBo488joZwquHnnjIeczuwLm3ge+gH2QEb6auz+/tPeDqHSg2ndkH9r0Gkrsk2XO
         KpVghjOFzFkuSsp5U8F1VZwk0A0m3PPcBG6YkJX4Tg/3E/exsWdzWuUvZqcZuyGnaGxV
         lCFZ2lhLHvIcDCIOLIhc8I921RkIAOuwUH4LqdUFfvqg1in5b55g4KUiOinqrUzEpmub
         2mzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnlb9Ube1eRuwRk0cn7jHd6m7gYrqxzyCDViK3CoafL7PS9so3TT/sM7uc67mPQyfmx4SZDoKcmA==@kvack.org
X-Gm-Message-State: AOJu0YwUcnHUTL2vNGLFufdD9lMcJM8y/p3NMJZXrotxtEPL/lullUJO
	AiDyg9we+mFix0HGzrhKOtGl5jW440oFWtadohb86tGTK5TM4vzFC2pLsWrdhe3XDvSY9IZ7MAY
	4qNlkGLwUuN9zhMoviKLPDhZN7kE9QRvDN7kG6GSA5/2oOWRTfUAk
X-Gm-Gg: ASbGncuElMX26dr1fjNzTcrg97TsqtoF9GbkcXZ5i97szl/RKX2OKqw45NUk44bN2XT
	WWO3qZxoUuP/EBKrRE8fYUBxUxg84wmvQ8QgZ/0fUrGg/j6yrDkcSysMSmvRZBaDWtKkokadS9j
	1UtQgk8fqBB3GV+x51mcw4af7OwRu5yOBRb6K/sM4Vk/cn5rTu7/NF2m/sGH5FXG47mCkqmbpSb
	Uxs8c7jY0+0yQKEp+gnoWnbY3yY2vybDH93SxjhWLBcwwm4WKoGQgXQZdKKu1SVF4mIfysyehg/
	TEYWx9mCqX2j6El/yZsJJ2lvDJi5/J6YWo0ERVLJchQ9ARLJFbIZ9jkkaov6lo7tslHeogOMfTM
	Q16LRrquV3LKpRtp+E53Kn/3L0XaPOS4Pv2ipXoejNCFSunvuSgq05DbK7di3OYBsug==
X-Received: by 2002:a05:600c:6610:b0:45f:29eb:2148 with SMTP id 5b1f17b1804b1-46e1e12731cmr16208685e9.7.1758615983560;
        Tue, 23 Sep 2025 01:26:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqzL6FPtVZMWa7SDdaAzcN92tCv1s8XBSB/8rSC0slsXilfs71hU7mkj+ZOiqZYqL/7Rz7Hg==
X-Received: by 2002:a05:600c:6610:b0:45f:29eb:2148 with SMTP id 5b1f17b1804b1-46e1e12731cmr16208405e9.7.1758615983159;
        Tue, 23 Sep 2025 01:26:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:700:c9db:579f:8b2b:717c? (p200300d82f4f0700c9db579f8b2b717c.dip0.t-ipconnect.de. [2003:d8:2f4f:700:c9db:579f:8b2b:717c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46d7a566a27sm66347685e9.20.2025.09.23.01.26.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 01:26:22 -0700 (PDT)
Message-ID: <0a5482ad-3625-4c22-9eef-574eabd7c2bf@redhat.com>
Date: Tue, 23 Sep 2025 10:26:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH linux-next v3 0/6] memcg: Support per-memcg KSM metrics
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org, shakeel.butt@linux.dev,
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev
Cc: chengming.zhou@linux.dev, muchun.song@linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org
References: <20250921230726978agBBWNsPLi2hCp9Sxed1Y@zte.com.cn>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250921230726978agBBWNsPLi2hCp9Sxed1Y@zte.com.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qTxroJE-laMSanAnoGoib4wwm_rLrfZKyz-BCtSs2W8_1758615984
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1A05B40003
X-Rspamd-Server: rspam05
X-Stat-Signature: 37eqi4nt7jmpuhher1ggfj839nbwp4qa
X-Rspam-User: 
X-HE-Tag: 1758615986-409959
X-HE-Meta: U2FsdGVkX19BBTIuI6k8s+rCsLsdxIO4ep9Lwj8Wab6+5pM0wvILDhPhmlnHNsgiE1VQ5SDSogrUMFW5Sd7/WvjJRE8wgyzuu2cNgzLNz6jIe3yjCVYinGJgKzL9v+/v+JY5Lgxb0jXLOMk+qinBfUDeAejl94rhzZ0D8cug241AtETaGC76eY36CZHv5SV4D8v7eFVjKN8vxW5q46j3d8zK5lREIvFqaOm1TljXhNLHnOQwPnmDULlBNZpDm6QsTa9IlF/JzaMQ4mI1LhO4I/3GldoYZxNR33uK7oo6SJAxFr+nvAL2re/Ca7YIH58tO2KLNNDUDbq0ZvXQgWfPFymrHgnpV93ttZMF6hIQQBDZO3fgIzxYa6EkAC6ayXJSLESPpunPJDJJCcbvRcR5mBuV6xJWvEKZSeeCUfQxfuAf+xcxEqANIuad4Uuov9Ex2iibChJmsMT9qqkEoARz07Ogn0ptixCXYdvc8mKR0ZwNExhEDXqyk9hVQuq4jE5u65yiUEKBGhUB5QXdxcpsb7nI4b2SGZUlDXajSgky426KBPi/Wn7X5K+bONw9KZ3yjrJ0JDiE8/y7GSfe8p8rgSkgHYOq12gbNTJZfz76zZkRB7i6h93UsLOcDFiASHau38oS2aaENobpLBiq/2Im+ADuED36YWU01AiGFQwG0UtXQZJAW05NjnALTrdedkqXGlV6nl8jX8jyCGTW+NrU9G+GMdFPwFvUKNIQW6XE98fV7oRwLlHx7rMFpYM/tQV6+m0iE5+gik99BHvjzoEzROJ9vu9M/h6ZiG5+nwz5iqo9kDbGdAi6qgyft90UevjebGoTkL9uUkvARG+mzPzNVCnR5CI/lfq4KrX+vjCBQag6fi0EcRWAO0C8rMzwA7t+NrDib814Tc94nmVxeJq6nBZH3wcpQrT8ZOL9tg94ZEOEVSYrma3vhjlH3rzI45GaqsPUWPV8kO+cuYUJ1Re
 m3OiMEac
 s0BTU84GYOyCIJVH5u/ogUlRvUSrMpa1bUCxAuEl7mOz//0i+ARpYaZXr1K76BGM+sicNoByKTn4zDPTKkdFzmlFtzMd+QFdD4KoBQbhim7FP/WV3bniVKTwmJkR9x1sVHub2HOZMMUP6X++9+I9iI7QLbtSLccQwbzwGbkP06UB4G8hyC3UNtwbKiBXV0vFzGm/6TOpQN9xzqQhXInzLS+3HYAv9L2oSQyZ13ITIoIXW+oY74WIVs//Wrd/JQy4gZY/Gi1+6F695rAhsrwk8VgamMxvr2+8tUyDVginS+0z8zWQ+bwBSmTmQ09UNv/1JqUbY6NPNj+PPfVXeDwILR+FLKP3R2RZeyhrunsWjYzSaLncxOGI9jCFHPuf53Nsqqb3eMUmYPxSuFSYwN22f38HEPaOfh73VmmpOTc0FUgGMFWK8pAtLoX8XHtOZeym1zgpVV01hd0RZPpw2j5b1QcJho2PS4HohlLEVJJnIfkJ7RdcvpIj6X9lJaP1VpVJ3XsnPsbKwUlaE8vfyMrlc/bjkTjh0VIaKjJA4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.09.25 17:07, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> v2->v3:
> ------
> Some fixes of compilation error due to missed inclusion of header or missed
> function definition on some kernel config.
> https://lore.kernel.org/all/202509142147.WQI0impC-lkp@intel.com/
> https://lore.kernel.org/all/202509142046.QatEaTQV-lkp@intel.com/
> 
> v1->v2:
> ------
> According to Shakeel's suggestion, expose these metric item into memory.stat
> instead of a new interface.
> https://lore.kernel.org/all/ir2s6sqi6hrbz7ghmfngbif6fbgmswhqdljlntesurfl2xvmmv@yp3w2lqyipb5/
> 
> Background
> ==========
> 
> With the enablement of container-level KSM (e.g., via prctl [1]), there is
> a growing demand for container-level observability of KSM behavior. However,
> current cgroup implementations lack support for exposing KSM-related metrics.
> 
> So add the counter in the existing memory.stat without adding a new interface.
> To diaplay per-memcg KSM statistic counters,  we traverse all processes of a
> memcg and summing the processes' ksm_rmap_items counters instead of adding enum
> item in memcg_stat_item or node_stat_item and updating the corresponding enum
> counter when ksmd manipulate pages.
> 
> Now Linux users can look up all per-memcg KSM counters by:
> 
> # cat /sys/fs/cgroup/xuxin/memory.stat | grep ksm
> ksm_rmap_items 0
> ksm_zero_pages 0
> ksm_merging_pages 0
> ksm_profit 0


No strong opinion from my side: seems to mostly only collect stats from 
all tasks to summarize them per memcg.

-- 
Cheers

David / dhildenb


