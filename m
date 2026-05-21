Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A82DDCD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A0786B0088; Wed, 20 May 2026 23:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7509F6B008A; Wed, 20 May 2026 23:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63F196B008C; Wed, 20 May 2026 23:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5377D6B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:00:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E57331204D7
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:00:02 +0000 (UTC)
X-FDA: 84789922644.16.ECC15B7
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id E0454180004
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:00:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IUlIhNxQ;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779332401;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1wQcJH9G8900u0nQpbzMUZp3+IyVGSWJa+VT29T57GU=;
	b=LEvlCy5lfw8KyicyUUU5gNeQAn4bcAlg6WE647pJ3yJ1WkQ0NMMyo2rq679RDP9G73nfuT
	AsfOhGP+z8YJzxUlrhC6CwuZYhANFwtAZJuTYE9uNp1IpUuvoz2FvIB43hGXTE5Hc0YnYq
	tehPp87hdv6HKl0Jq4DwbuaGw0O0JA4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779332401; a=rsa-sha256;
	cv=none;
	b=isb/xI5ptf+q1AUsL04YoSPQ7NhL33Nh3VKTOhJ9n/cJfDaU5jaiYLYMd9Otaqn472h42t
	CWnBdFjO3ru0xwpe6M+YQEKduPsPEoeYcCHwqTtM6uPuZQTMBsCxuWGqSdBgvnboFLflOe
	k54OhCW6rbFn+mpRZAXyrKM/JLX8Rv0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IUlIhNxQ;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-bcd3c190f71so958259566b.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 20:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779332399; x=1779937199; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1wQcJH9G8900u0nQpbzMUZp3+IyVGSWJa+VT29T57GU=;
        b=IUlIhNxQ1AScezOyQ3Vkb4W1oFmr6wXeAYCy/rxBBOis+I4pA7J4KiWBvCL/FpsHjk
         yjK8WSRB1w0IyDwfEFpBXYQZOdMb21p16bs5ACzo9hsr5XCG6yR53bth/4lh0cA2YOn0
         cCz6Mf1zuhmfxKnOl2Tsi3y3pnmmVro2HFJwD3rzkrPw3lrWfbRyBB7GDbuyA1bK26tk
         vgT0uVRTZrHytSEbXHiQRN4Fx9rylPTbOQg/RfYT1zqG+qh40Z7OniRtL5XVo9/mRUpZ
         03yNEEQXuG2bFjc/6W4t55LBCbl1gWlHDd5Hzy3kFKwjSYBHvqYF8APL17EY9rGENyz5
         6krA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779332399; x=1779937199;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1wQcJH9G8900u0nQpbzMUZp3+IyVGSWJa+VT29T57GU=;
        b=SWWho6Lbd/iCoo0O8NHaQtK9BPdGaGkT3bfqoyJynJgEGlZh0BbJhykiSQpbY7tYl5
         kTdQnL2PEmUEodEqnw+aLf6+USd0RJOZcUO+X0F7/IbYLtC1orHQpDSW9BfYo7AWDymu
         EBh5DyNzMOqAfGV5yih2w908GW4hLo68ed2orDAvxULLMBAu1EH4u0LdAJBeDcArDpH2
         h9jgpnkksK7s51DFKAL7J2REr86vdkMonAKx8bzSTpWbxb6Jtb6ZnOog/fg56x3CcBNu
         IMYflMRUFvSaqSljWppm/l+0U5/GHvrIIoRdwdo3jOEXZqICsT+5SDKpGpEdfWx4kcGJ
         7LDQ==
X-Forwarded-Encrypted: i=1; AFNElJ/3jAQT55aaJzeCliS5mOBpUMI+UjpWSzoU28mXD8wi0N73Q2Tjmf8E6aH7BR657ytVlQYXXVlAQw==@kvack.org
X-Gm-Message-State: AOJu0YwLPnYcoP/yAuiVdvk6B4MSGMTPT6wigm1VQUEMRt5jXOQmRPe3
	Yfm4H9T6tkkkGHDTZvb2U66reFlNtaOD40XaDCPSX1y4a88OeQvu2lY5
X-Gm-Gg: Acq92OGXiq+53o+R4cUlyhHwFxYIJd0UXwUGO+LGL82kW3XU/xCGooGJUe9lH4mKh9B
	UJX/x4w73sWuhFsQLrO1GVDnDYvs+fr/i7wdtAeiWkQtWM1fKQ+U8SmARpN7aihPtxndN4u6yah
	6gwcsj0M3wPs7s9NUG3J56dSp5SpXNkryKhUklt12/FTJhA+/Ke7n5Pk1DGDgBbnQaI0P5zf7o5
	zVy3P8Xcga/UMvWJCHgwO1/wmkbc4tFtJMQ311RSNNot3WUcyBtHHUyy09D0DEpBKPBa5+f85dY
	wk9kIe/KLD5aJ1ytIwPBONeV0zzvzZuy8eaCMqyzD5r7ElxxvtA7h7alTmFaiHGjcyrfWBpme8V
	z9jTObwCHY36T0nxSgtuwmx7NrrkAkKenN05MI5/S1qdtXD5aUdQTwhQs4oNJKbD7dDY34sGFbG
	Gs246VxUIJC856q2nRNp7vyw==
X-Received: by 2002:a17:907:74d:b0:bd4:4593:33dd with SMTP id a640c23a62f3a-bdc15549e49mr43082266b.34.1779332398908;
        Wed, 20 May 2026 19:59:58 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4de6f28sm952539366b.34.2026.05.20.19.59.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 May 2026 19:59:57 -0700 (PDT)
Date: Thu, 21 May 2026 02:59:56 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Jason Zeng <jason.zeng@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/5] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Message-ID: <20260521025956.f3zfyphlc5sv6clz@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260520093457.3719960-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520093457.3719960-1-yuan1.liu@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: E0454180004
X-Stat-Signature: wkfjwid37jf97uwdyatxmjihegj5uca7
X-Rspamd-Server: rspam06
X-HE-Tag: 1779332400-234104
X-HE-Meta: U2FsdGVkX18x29iWwNFli3AcrMncZrRhlQYqFqRllew1FvqhfyVvX7GYhkmexUXxOcgbwJDUopkVF9dpa+LWMQG716d2jPyBCQ5BI/K4gJfS/W5X/oaxehRPOtkBoNblz/wwpTh/VRzJDyUROv4TiPoIgoF8gy+A8WFdq52jy+dgsCRwJD9V/uxooP5GU0PR26FkmnSlvbsWFG0DHiXDGN/DidZn5j9108qJ1ak21EdEF90jCQgu4VRhejTEgdkd1j9IKZtybWHXV5qOOyGCRKbjQH1a6zfbS5257w4fmmUa6Hjd2b09AMLmGkKf71P0aKQWM5sDP+e35+SCxV8GnEqoU4hxAPYALy/zLyHsMNfBcSZGOLeSbvkSiHROv90eRAlvcIbDi2EmYup+8oX1ChSo7o/gor92/PCUMUtsTX9S8qVd/hrbpDDKepELkWkaMrdNp58CemmoORcfe+5hUYctGC1qOmaTHMpt6DSWr5t8NyDZOoSQOzMxFvP1m9oXbKKeea3cgrrG/ZKHcE0PwcJx5D7He7qrWOx+s9mIQ3294ZWuzw4xmOd1lFPe/tlhTNVMDaUB+M7PeAb07q1Cxp2PDHLrJJNQLjFXjB32wRYqfQzHuIdX+OZ6RZdFf3mthY9VaOgpcLL9dYVcc5l+pv17G9HUyDCO/Vgh5cHzVb8yBvR40gZSHMrC040XxlF0cW3QgGoJ8EKjXnJUVovMWNQGLy1/gUBlRnZ7BA9d2+Ribe49RsT0Y64ey/XJ1i7Ze469CUesav0S3evgo3CfUA5i7+bJvPpDNVJalzWEFuCUgZBrc1W1LZjSIs+gJxFjFx+7kh0niC+gvfOa318zdO8iMSc7ceppPt4fhfNoTHeKlNlYq7xHQ2fX7m/5CPJjsgpPF370MucnUi0gA+Ssb3luMWOsRDBEJMXpCjp9PgPMWjHzvBX9dPHbBm7pc7ZvCbq1vFw9fbajEMKSFeS
 dKxGa5tS
 icTqBu9winoUKAsaVVy6ClBMqfu72M6ulrYOq36zu3/MuxIoh/sM9xX7RBDYylEc01pUwXebihj6b4ATD+r4PPr04c1LYp8hxmfO82jWbBIihShO8au1XyZ1Ums0Zj2gwOVHh2Cnr93hVYJFvAF+wybZbetgohOmjmMR+EWBWydJ23twwCE8lZE5k2BZ5b0f1MRflZZAt24b9QPsDm63nErpJkSXYYY60UObw7GR//7ut6qIOU/wMOAdkzw4KNdAOziBc00Cnpkq9fK5Dhk7z3RJlEVn3dkMiYqkQ98LmsAQtyxnZOGuqYl0vxA0DFaDm3dxzar5K8vrupk6pzgmlTOXnQdyAP2OSrXKhu1YsywfFZpHaIUkutNUzInV17e/xF6Q15GJB0V4k90922JW+//hGUcyIxZnfuYXZvQYcmGEn43HpjVUC5UXthgPYZHoGDvSY37e4DrXu0IohBgmBQdOYvpyPsjG6lbQXs8Il+TUcuyStt9m4uhwt+F3sKAfUJ6gwRId5Mn/5W3ujHaCNh/4oZvGGlizjUjyUraz82SRrFe+AlyNxbcvVnrh5StimT9jFANXGvDfnA/FDTgA0FEnXjOH1WAnDqsfzDvHLCufdOjMF4xZqvCOGZzc+yrrrObS4rl347Jv5u+18QqrOZHysRiRLYzBl0+PzlF9td79dsKnyFanEVBlIgDGAhFIJP31sYZYCfOr5epZCPBgdOhQTkwRx9ZJ13Khbt6S6brxLekmnxozSg9qvktHxbvAG0238
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Yuan

IIRC I haven't reviewed any one of the patch below. We have discussed
it but not settle down. So it is not proper to add RB by yourself.

-- 
Wei Yang
Help you, Help me

