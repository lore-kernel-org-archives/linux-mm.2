Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5215AC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EE156B00AD; Thu,  3 Sep 2026 06:11:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69E006B00AE; Thu,  3 Sep 2026 06:11:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DB656B00AF; Thu,  3 Sep 2026 06:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE746B00AD
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:11:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D354DA04C6
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:11:12 +0000 (UTC)
X-FDA: 85172033184.28.C120C4C
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf27.hostedemail.com (Postfix) with ESMTP id E387740002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:11:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cFRFSdob;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788430270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XuxH6CgSRG1EdPhP+jIRa4q6speJtBOZLJj1P0OaFuc=;
	b=A1Qy3QD4tWZKpgDbBQoHL2lwdTMOmFOkJiEnBPJ4d7HZR6VhViUvkdHetlKTRSd+HWJ1+2
	e08HmoRVlcKvYbAgB2sHWsqurMRTlF8GdwyEx8+pOUuumFapLYq8eozQdHTYBmWq2cKdsV
	QSJl7OeZn5+kL3x4G9u1JimQt6am3Yo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788430270;
	b=QwnZZT8cg0S6HpXCgm2MCSkQFVbL8QuJLjVuFP71GoKvyQPeU3dePnm0BaOxJRdMlH5JY/
	R2dMccUGcWjJFADBc/Lum6NqSGRBmIxprJz0AXfyvSyf63gOgfYdAMrgUInzUEA2U0Tsii
	u61oKB6SAAJYrgt6MYucHMslvB0DW9o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cFRFSdob;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788430265; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=XuxH6CgSRG1EdPhP+jIRa4q6speJtBOZLJj1P0OaFuc=;
	b=cFRFSdobXAtwzuwaGEzqZEu3w1nVN99fisD/yAl1k/wywwlUFDOZW8+LaFAMLkSTT+0sfTQM5/06ycefk7hW9atPV8ghvfy2uln7q9ceZbClRz/P4fzCadJunmYpcAo4TcmyE9jcv60QhZzr5IlgkvGjRc+u6Q4HVi1+kV8i74s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XAFfT1p_1788430262;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAFfT1p_1788430262 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 03 Sep 2026 18:11:03 +0800
Message-ID: <0f2d9837-0198-46f6-8988-8bc089c1234b@linux.alibaba.com>
Date: Thu, 3 Sep 2026 18:11:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] mm/mglru: enhance cold/hot inversion handling in
 inc_min_seq()
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, baoquan.he@linux.dev, chenridong@xiaomi.com,
 david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
 lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com,
 Xueyuan Chen <xueyuan.chen21@gmail.com>, Ridong Chen <ridong.chen@linux.dev>
References: <20260901232421.40157-1-baohua@kernel.org>
 <20260901232421.40157-4-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260901232421.40157-4-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E387740002
X-Stat-Signature: 4ygz5uoiccr1nu1yfku36of571qo3myq
X-HE-Tag: 1788430268-364406
X-HE-Meta: U2FsdGVkX19K0lHLp+Q4f4sE7QaOA9XM9g/G3aTfYB/McK+XT6TUQoHUe+Lb8cyjDKEXlcoJFRi//AZs4xsj8Pzgaf9YAthwpzbppjDHkf/nyZrfOnjZRIoGkZdupkMuCBYGgDAJRAZvAXUkEEjyHZCE7LmmcBFv9OwBi1W27x9PfguQuv+fNqfNNQDUsSOf+0EdBuvMVaJDzh7LTV7xv0yhlta0jkaynmJp0ivha7rd2yx9miKOoPXcwOPIdCoDAXX8Q0jvZa1iVvV2paUY6WfCxA2NKB0/k42gxF+UF+fBoiEGwptj7+lL2r5BKLc9IcwE73402nhtVDZ4E6dL+O7NuXXcSBVWE7y+F+roapxJvZZkAaouPnKOEzKpsR7to/MT5atyJHFZp5RpbCvFaQHvgP2y1yMH/8EgfE3kkiAjh3uo2pwjtVzFhgCLrtlLe0B4retS41+t4IgrvI9eU3E0CLrHAow+boC9360FoF0RL5zV2bq9m1nyrMtryZsVnpHTAvDDzmVybI9Ef0LTsLJG4IQS7hSXXkcYtN2EHUXq/Jc694/S90JvvsoJg+dO+1+36vpmdsI1MQLwKqyXIDg6NTMaoORFaLVRehKqA1HWg1qWurQUtg5sUxosaIMZltMg1u7CE3xGcwkM/2US7NVxesYPLBP/7obo6p044qQfbyFtOyZVlsboigPtns/MnfHr3t/xemwWfWHrqeFAG0BzEiO6MsjAIfqrykd3KltR2pAbAulDPyDn8N54MM+Phq86UVE/j++JXI7w3DXsJda8wQ2fmaB6zKouxu0L/zx0i4NcHNVLj01oIAWm8N4trzCp3v4kowv9T/vqgE+49V5ytWZnWMHyuDxiyRwcNBMWRiqlHu7C8tXbG2bqc/aeNjTE7KLS1iHoBgjLmzu/TIiNzDBZXtC1c354ghIyYNw2AF94mz6ZYPpRSuxmgd9TrEGGg2W4VYQiuvaSjcl
 UTTbgvzj
 vNWoLxLtY8+hNdhm73EjmOWzRp3NWQBrtuOxE2yUHwi7wq/I5Oa3JVKrwYjGWJDCm9DMS6OHm7rQAjpgFNVRvXmXO/ZgjqMc8NWhOUMK0Uit90uqABuTshNCukkiaMa4KA5LbLYGrQaMyR2U2ckEacxW7sDZM4UylfznC/9oaQmOFBDnXxabTucmVs37T0DyK4dteTEXboOWUT9Fn/fL6S1X7245HEd5TmjDGR2YJe8N8aYWku7YJ25kzqT53tbrX7dixLZnajFqdWNbFPJQhbdEYx6ZqnwGHm32wBYdWAK75FvmNLpUamIIU3HjKebT9Rg1/A637SFC6+5G3/PT2fRDpfamLiu7O1w6cN1GBqDPGQN66XxyCMVNL5D4rhrFKrSra2FAH+0tVA2RCxHUwV71G+dG5I2qDkhwxXM/m7TMnr1yIPQMDRbs3g8RsFlnHbBkD71+OMx/TlFa5d3g9Q4tesSRBn4aJRwcXIS5xS0czjaCkwjtSiGGr+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/2/26 7:24 AM, Barry Song (Xiaomi) wrote:
> During aging, a folio's generation may already have been updated by
> folio_update_gen(), even though it has not yet been moved to the
> corresponding generation list. Such folios are hotter than those
> already in that generation.
> 
> It makes sense for inc_min_seq() to increment the generation of
> folios that were never promoted during aging and move them to the
> tail of the new oldest generation. However, folios that were already
> promoted should instead be moved to the head of their updated
> generation, just as sort_folio() does in scan_folios().
> 
> Otherwise, promoted folios could end up behind folios that were
> never promoted, effectively inverting their hot/cold ordering.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Reviewed-by: Kairui Song <kasong@tencent.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> ---

Good catch. Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

