Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2439BEEA851
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 21:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B0296B0089; Thu, 12 Feb 2026 16:23:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87AA46B008A; Thu, 12 Feb 2026 16:23:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4AD6B008C; Thu, 12 Feb 2026 16:23:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 69C1A6B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:23:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1CB511401C3
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:23:48 +0000 (UTC)
X-FDA: 84437081736.20.09E48B6
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3EA1F40004
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:23:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bUsLWgg+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770931426; a=rsa-sha256;
	cv=none;
	b=HJ7juWTMldQvQ3B6e3emqOBo2k5u6Uax5gePPkkmKjap+ortRlZyByRLgKAFMayW7Smkon
	blkiuVuzUeKGL69okKhRT0PVs6PEH6IUv1a9+laaU1TV4xefJhptKxtpQ+CndgiELuQUCU
	RizY/+ZOwuAHYjUQV539HkvPmd45AjA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bUsLWgg+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770931426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=urRGhY6imA3+iq+NIxaKfTA3oOAFaO2s3SPb2rxYQCM=;
	b=GJL7HHuOaeA/N48OJgiywp5yDrdPjE81FH9MNvOKwuiPqr27wUF/6CsHUxAGdlqU/3hlG0
	9YRJxCnNjEgqpbAUX86ObGe72ABjTbGUIDsymMipe4pJQaiilozDjsei4EXJ4kP4qmBF2p
	KxdWsI8V0QXfzGTjDOfqqseAYLn47d4=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-124a1b4dd40so673788c88.0
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770931425; x=1771536225; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=urRGhY6imA3+iq+NIxaKfTA3oOAFaO2s3SPb2rxYQCM=;
        b=bUsLWgg+xjw6DfUsLJ3fdp/ApeJPMigm0TN2VFM6fVtYk7Ny+T3tVr0qR9tG8NYZEh
         RczDZwztYrhwVHlk9JYd+XyljQtvTrzYHtkCjxt3nsrmHt0CQxoJ/2+QXnfZMYNwIq+N
         epxGw2L2Y7oIjuK2RaIoB421nUVKC9vDck+GD0YG/gHO4MPhgTRgZ0sh6gfMX4YPiu3c
         nmqdZ/dXGcUEdOTPWUyZ/31+GJeRwxhIdfwXafBzzGarz1h8l5viJkr4vSF4uPUSNoEL
         1ZCba50tYL2QnmIBoWghcs8OBgD3Y0cXurAIrd+511mZzciwHlCgmsHCM+06BEBKc7Al
         ZR4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770931425; x=1771536225;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=urRGhY6imA3+iq+NIxaKfTA3oOAFaO2s3SPb2rxYQCM=;
        b=YL2lSSQ7KVeloAjz8TJGnO29X9vq3V29eMMiFMDnavGvED+hJYClz11H1vneVgUs94
         JRlDYVIViea1HT46HRjOieMrdiYfhH/R5iiSqp4y73oXJQjVVM/L9s3+/42TWLAoxDmW
         7OWdGYPEejYPDH2zpvbDwMOJY3T9zWEexzBVBp44YLcOQhEgc6Ng9/j3w0uxViLDj+D3
         DPE3jMGGRL1NvXQ/1zb8k2GRtYP4AvDcZix99iYON1SPqYwRCsnaVJpFupXuP3qPFohi
         n6G4wFCTa431E9yWmKbycLUSilCIJob1o1TrAD/9FXGjsPgA+5Z2+50hLOj6g3E0Zl7J
         dvXw==
X-Gm-Message-State: AOJu0Yx0RqVP+Gi1pQCQlgH4bGjaW+t1mhm64OcqtWgKdJK6zBzzedPR
	9qNoe3xmUrSEkvMepHkFI0yefnXvQgNoOOeylfvsr7FEW6WlG7mbp5lg
X-Gm-Gg: AZuq6aLlBYN2jeVLfvoGa50ehDwKGOlPPcch+c8putpaWbkkZB4+p6OCaUxdgkClnnZ
	BULRGd+uXobmkbSbFeWcyr/50eAffbfXlsLtbVp/iARFa6eO4knpXICD/F1KYN4wbZrvIJbcCu1
	/Qlv2klRdaLQWi3xt37uJrsHVQeyQ1xJAJpZgb1W4YdmWFVCiSQwfBwlS8ty4QOusgnNQB7qMvO
	tyzoA5UiOJf+5EQxEyNuJI7ce+8JXG7BSvCnuW1Ru6kEhkIrwJWtyjoOheM9XLTYQgd3ACYV2mW
	i9vBkUgBbQa/5J5GS6TF/5ARnE2iDlWL85gYHa6om9HkjiigcMjbr+kuYshqBWNeyMd4LbcgmoV
	fGOipkTqyDDFph1Mn0SDt43CMcB08vFwX8chHgrStLH7MNp4OF+GvDZpq64FlpI+Jz8CKCi6xUu
	jgRvfpl9csoxF+Pc/rTvO7/SUAEQTIImgZ
X-Received: by 2002:a05:7300:fd15:b0:2ba:a2fa:84a6 with SMTP id 5a478bee46e88-2baba0e3898mr151831eec.24.1770931424978;
        Thu, 12 Feb 2026 13:23:44 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba9dcea9b7sm4192869eec.25.2026.02.12.13.23.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 13:23:44 -0800 (PST)
Message-ID: <fc29d4fe-2d85-440c-a8db-c26520dd4fc8@gmail.com>
Date: Thu, 12 Feb 2026 13:23:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: move pgscan and pgsteal to node stats
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
 axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
 david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
 jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mhocko@suse.com,
 rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
 rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 surenb@google.com, virtualization@lists.linux.dev, vbabka@suse.cz,
 weixugc@google.com, xuanzhuo@linux.alibaba.com,
 ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-3-inwardvessel@gmail.com>
 <20260212020724-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <20260212020724-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3EA1F40004
X-Stat-Signature: 434onif86xrcu3cwh54puh7w3m3qxmqf
X-HE-Tag: 1770931426-115237
X-HE-Meta: U2FsdGVkX19MxF3NgIfZvQZB7WdLWbCPNgFyprgG1/nJbjciEDJqhwmaIKepQxuhzy/T8xULgZ4RXrs4EXYDPQFFfAqDeBgWMvyxIIK5SwGHnmbocYAH3jng2LiJV9tkko2MChGSX7bIn4S8uOmVm7VcbddeGxpcphmcbqXUcOweCKPNoruk1MfvZzvo0COWK9PhiKT6e1DJ8X41EzuauMR9fcO9f6MOpy+FbqDytvKOCfJQnb9pinav+xBiWNdrRe6gnQfhDguKzxkcLenRnSmcvsbOS9FYF8dxbCERmneesMscQPrT0aVbTMLwo9J020m19Mw38s0AI/T1Fk4WPCAtIsEOmacZZ8uBOuuB6h7UWYJ1XBD5JH/bEhu2tldUDjmTnkEycsxUSd9aQ5/4zG+ohcumn3JJgRXT4pUdFJEE6VaWxqbj0uY1T3xkJHFPa7/hFerTwEBBZnzCPnLrlWb6tlQAvoc9fLTAkPa0mzNDurzykCuqzQ2xgnFtR7zKjp0LkLlid0AZuEyka5nQAP9oirKU2FbCjBh3JZbRrheOUTImT9h3ZisTy0moPD0THzguw4GmcCJTOtdvDZYzIOlb7nKCQs5KcyC0U4redgHYctEq0O2DCl/HDVHlxfZM5s+ES2n1G1wHgOMFtzqgKLiq8XLTiO5x7EuROU+irtEJNygb4eqwA9ON42Df/JcVh7ywLjS2Y5KXxsHn6iGuVV+2rN+qN3W1PQlL8/zZpFpNfvkv0lmf9c+33+83tOo1JoIbfK67OmELEKyAXxMUrLUsBBtBK3pbjokEKGjoLkwM8JWnsN4UxcSe/s07TRt98owBSZX1iEtZPKmgEcO7YycBAFckM9BhcHUQIECwZc38beUyNltCdgYOCX3uG0RjkV9gz/PDvLU1VQe76AliE7H9j5OGhaZbHNn0oKDj8OW/Abwk+q3TnKX6TgPFIXTm+Rcoe13sdfypRa/ejOd
 NCMCzCTj
 tDOYihUPmWErhyQmHY79Ox9BQRPpyFyt1B9Zpt6aCoAC9yVdn9dHpZ4R8uhb3Ej64nOBwYBt601U+CwSOrOzewIxkTHPP4l3+xWgLaQztlDHYE2RCihLZk+1fy3IzJT1SjUqmRi0TWY0xgzEQGeAbKRJaa/sMS4kDYlCrDhXmRvDPa8PGcPHZRSuH2LXfjySjMuVq/OJz/OIhnwY4RpwQIS8UlQfpiGAvAgtwBpeVNdxmRCbcgvowrG+XDQiAeFB/pGm7CWXrXBoyBTbVIYlnJf9KUv+Yte1xo0dileHm6Djn9rpgTsed1F1Mu70X1HGSZ1R7P0M2iH0XzNYuuwS/2ImEtHoy+HZI2MJMvzvszSxktgoM+npZmL5AfTjgMI0GNM9/moJAGTXMi9L2w7xQnZWinm4kIAzVaX9t+y0A1Al92lig/Vaa9HUKH8uC873iNKDJLT0ZYmdiT78OlrEb3geKwXgs+lJJO+U3+db4MkK8spqFvTaaY5YIQOqqlrm8d2j/hHoeNR8WpA9z3BHlpU3j6iKcaUjmjTCzzAPT1Iq8OIJw4jxgfPPjmCcP0kcDud0qEYfdBSXZcMbgAfq1ZQ3CSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 11:08 PM, Michael S. Tsirkin wrote:
> On Wed, Feb 11, 2026 at 08:51:09PM -0800, JP Kobryn wrote:
>> It would be useful to narrow down reclaim to specific nodes.
>>
>> Provide per-node reclaim visibility by changing the pgscan and pgsteal
>> stats from global vm_event_item's to node_stat_item's. Note this change has
>> the side effect of now tracking these stats on a per-memcg basis.
>>
>> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> virtio_balloon changes

Thanks. I'll make sure to spell this out in the v2 changelog.

