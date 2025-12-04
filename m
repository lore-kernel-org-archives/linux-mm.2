Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FE02D24477
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 18:34:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786706B009B; Thu,  4 Dec 2025 13:34:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75DC06B00A3; Thu,  4 Dec 2025 13:34:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674766B00A7; Thu,  4 Dec 2025 13:34:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5637B6B009B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:34:42 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0AEF514035F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 18:34:42 +0000 (UTC)
X-FDA: 84182639604.15.53F5EFF
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id D22C1180016
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 18:34:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=XMyFXYxk;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764873280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKYmIZsWojJAjggwNZPXMCAVL5haYWj0+8meBT5PJDs=;
	b=8cgXWXy8REYaMzrLtyoeL7sxyYiNoYSCiPw0sROBgkHTNV9ScwYujWSyZlaOW2yxRWV2/A
	UUSkE2mBwM8T2ERVnJYUqnj3I7kVjzzMXId3VEUXtE4FQG19B60kEMz7HIZula6sRuaz3T
	nsQix6THbKca00GKiRkKtlgTCAJ8jeU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=XMyFXYxk;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764873280; a=rsa-sha256;
	cv=none;
	b=rxJihoCSJ4tyVi3J7RQteUSoIluxlMaLubfxYa2JuXq5MEXe9vEwnbZgbUDJ0nFCi6kPWQ
	thEHbBRdwOfMSA4ZFjMR+hUlTMuoHzagmA64dJH+8uh12+UjXutOvtPbpbuA9nv/8mU39C
	nv6dwOFiZ/uUO2FbzMFrrzaCrnXm06U=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ed6882991aso10389931cf.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 10:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1764873279; x=1765478079; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WKYmIZsWojJAjggwNZPXMCAVL5haYWj0+8meBT5PJDs=;
        b=XMyFXYxkCK9Qx99HOqU5BR6ScubUBcVWkIItyXbfl4zScNrvVCGJ1YFAGSLmMeg/+w
         HCXy+U3C+V2d49kfKYAS/SQz8NE35Aavngh9PGXsw4C2x0LBlYka2GJXJ6JVOGpb59kU
         6pW0AySf0YhBUsLLM64p1ipFZt2RFyQgXWs8fSoIybNx8/7ESb1kxaYD7lcI3hfEbsQ5
         +5fi5CX44m6DCvCFUtwCM3+Zj3wN8ZjWpenXkxHiedEXpG9pvEULMsmA54JYYdp6PdLQ
         F6+NJ2AKpRcjEXQ9b5OSFDcj+Iwfn2oiLIYFkcLnXhGK5U0aYhxbvqGf3HvpHctKMSIf
         j02A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764873279; x=1765478079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WKYmIZsWojJAjggwNZPXMCAVL5haYWj0+8meBT5PJDs=;
        b=qAu2DV+ggsMxVhfto/nnt7jGW2gwHVSDoQEPKP0jaOp8oCZRA2pCVB4oXOGebbFJdB
         GCccXJ6ZKEpZCSXxyMAFtySgcHxkqDEU5BD2EztrGg/DYuNPKfsL4TG+Xrg4DMcNCz3t
         KQf2kozmifLQk8FXYvKpntj4X1eXh0etIZ7wqVr5ixegJCN1MYupP/e/8UswXsFZ8Fsf
         0WXXPJKj6dCFW4p+WYK0PfBwt2zwvLCer7ogkrHlkvHa2u397KxfU67JyqkN8kvKH5qQ
         F6SQrfQ12O2N38budcbLVtZp0d73ZCK4O3QpB3+KZg+E1SIefgM0enop+ycEr/330jhh
         f+ew==
X-Forwarded-Encrypted: i=1; AJvYcCUDaq4NSiVgTxltVgfrNpHl3nJe7YffwSfs8LuQGmkd16vRZgLA2iRZMN9tQyKUbn2L1t3OrWPcnQ==@kvack.org
X-Gm-Message-State: AOJu0YyCPk6y++0dpLLECTpWjApNbazdZY/0SmuKJ/Oszho2l7FnLOD4
	mrEi0W6r7LZTP+99jl77y3C3IaZIn4/Puu0jALQzvD5+Tbvxaz2ZH37lIX2eockN3qc=
X-Gm-Gg: ASbGncvxvRWkOHTwYjEhc5q3llnaG9ehEBIlF3zjuVMcTNI+IOlg4Mry019al45hYbX
	PUQn4XlsTRgs9jfFdeL9z4MYKchQqVQ+WpBvW6XlMe2e7RboyYurH4EqwqS7pVSizlMT+uaqTiu
	lkjcMkpZg6M4b2g9BX9iZql5NryCJfL6L6HdOa28gUg1093KsRDY+liRqqgOiFSKoNBIO2Atg74
	WHPxZaHWHwt49+F4OoVhQ7YsSjDVPf45aVIqAdbOEvSyqDZm7uCJ8O3QqpEMtRAS1NGuXTgPoc8
	gI2BTzvDbeOSRniB7eaVcLAk+JSVRsVg5xPe1Jm0aTHrromB2BNpX//nTKESJWlchh6HflJzSde
	brmhmN6u64Hg5Q41ud5O7077RxJV6/D0pv6/55YQajD9onHHI3R0nDilG/iHhUu0stpuUbHhtne
	egAY4E1jz8vA==
X-Google-Smtp-Source: AGHT+IHGgi2DcmU0+uMFC7b7WSn6eF6QiweV4Jq/1vc1s9yTnvYaa7EwMPS8bTLYiza1IljUAqQW3Q==
X-Received: by 2002:a05:622a:1b89:b0:4ee:1bdb:a547 with SMTP id d75a77b69052e-4f023085cb0mr70058261cf.14.1764873278678;
        Thu, 04 Dec 2025 10:34:38 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f027d58edbsm12673751cf.34.2025.12.04.10.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 10:34:38 -0800 (PST)
Date: Thu, 4 Dec 2025 13:34:37 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, yuzhao@google.com,
	zhengqi.arch@bytedance.com, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, lujialin4@huawei.com,
	chenridong@huawei.com
Subject: Re: [RFC PATCH -next 2/2] mm/mglru: remove memcg lru
Message-ID: <20251204183437.GB481418@cmpxchg.org>
References: <20251204123124.1822965-1-chenridong@huaweicloud.com>
 <20251204123124.1822965-3-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204123124.1822965-3-chenridong@huaweicloud.com>
X-Rspamd-Queue-Id: D22C1180016
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: tuopzayhmis1eifqtp8ypdmc9k359xof
X-HE-Tag: 1764873279-225580
X-HE-Meta: U2FsdGVkX18IEtiZH9v3vFNYGdtD/3yl0PvuhLj74tgruaQshCMNwzKe55QyFXvqCqmTXm+P+ysPeGyg+YK7sQd3eqDEdnlsqQ+g5ypTU0zPiEPt75N3RYnuYtKQeERnjwfINKG7I33xzKqF1HFdMntRNQZrKzjbPFRVVq9kg+mtt4XisABbvIZpcPZiYk6+AVOQF76yBbmEQYkoXdTwL+4C6w16/rODhNmGnSBX/upd83VETcEXxJ5wAIGuwMa/BFKCpqzY/YtSDNb3y+pLHFU6qqrT+KZWnbvl9Ob8MHsfnT24WbGvWRROQd5FGLF0ELA/DUY14q7BZZ0VWkl/0b3QvHh4uRQ7MbnIzR6czfHOZbYeqlvGxQkigCKUqixTU7cZBDaQ8LMfphfMvv2CixnitWR5Dilu3xWyWYqwQk3UapK+7GxT6kUqelB36kwZzVAJp6zrihu77AI1X9ffMm7dDBalPSaa6vjwI0GaU6Tgn15jV5Qa7PZTfqThPUiXYdr4jcMZM/wtTVQWZ9Thm02P5PMs7nsUnhzn4HzGA3q9MPd8Y85poy7G6KRmOHSlwllaMbe0+UFPTxfmDgE9x95IKzl/SxZzw5PhQSYvvHCBHoiQc6pMlQWrLgQzkBzQh/0cs1Jxr5LrGcFUDJRzlUhfvXQgDz/zk3vicSbsMO8lKnKw5yYLII5UcKlcR77pPV+8CLCg6y5TIjRTLtm+L40kVqGMXbT6DB79rVYwX+9VU1ThNjZFaZ0dhe8jtOjshwjTFmhpgViawfaVip+0tykxslLImgBk0sZLCdGbbcnT6IcxYrvcf+a9GIAToWsa/m2mycV98PE+OOQlkzjVIRzkyiZ2VGmSWwJupHilzqQ/STTv+1E3qtJPOhzKhw5HkKu5fWAH3lEI+6RQ3NmREL76Bz0nVAlIa7Dn52yoAULMUmUf0Dce5Zj1VdztiA5uPwmA0Qy51zzVKn1kO3/
 itCcpGu2
 6jnIiX5B7bKkoyRfIPxT8BBt4EwKX7RcjTINHeIgjwB8VhkI1jkEMtpScvIV0KA9BjvZ01Y9P99Sy7eU+QOCdkRLwxoImoERSRbhbVZYENwGekG1OxmDPNEDW6j62mnQrf2j+y4ehntlVMIuUsM48Y9HCjs3HrNWwY+3vOeuTbUWH0OY1/vqtddCEuBTKVlat3VeDiBn7Bb/CwVCP8S2Eu3J+JRuOR+6JsC+woJwf6N5ynSavHMQIo+G0u9D5hxUFt0MGUYmRq2hKe1zf/V9p8hD+vJoCwiLZKHqC+ZR7E6DFMr0SHChSPA93wAI+5Ppl2PPkN/4T7RNToECeW8f90xfap/Gyi7kxsOsMa7y7oXTGpfbRoFb73ePDo6PqnJBehe0ab+V15pi4cO6KN7XQIw7tyRoGctjzJTGYOkguPQr9bX82XuTSwmXz7xsgLFqa+P5QFF3OROuBncA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 12:31:24PM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> Now that the previous patch has switched global reclaim to use
> mem_cgroup_iter, the specialized memcg LRU infrastructure is no longer
> needed. This patch removes all related code:
> 
> Signed-off-by: Chen Ridong <chenridong@huawei.com>

Looks good to me!

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

> ---
>  Documentation/mm/multigen_lru.rst |  30 ------
>  include/linux/mmzone.h            |  89 -----------------
>  mm/memcontrol-v1.c                |   6 --
>  mm/memcontrol.c                   |   4 -
>  mm/mm_init.c                      |   1 -
>  mm/vmscan.c                       | 153 +-----------------------------
>  6 files changed, 1 insertion(+), 282 deletions(-)

