Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A685CAC58E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 00:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD1818E0005; Thu, 11 Sep 2025 20:39:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81988E0001; Thu, 11 Sep 2025 20:39:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 970AF8E0005; Thu, 11 Sep 2025 20:39:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80F918E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 20:39:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33C7BC0644
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 00:39:07 +0000 (UTC)
X-FDA: 83878738734.07.9FB34FB
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 52CFE40005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 00:39:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=TaX32Jbo;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757637545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pygF7jfRzgyoJR+RbnAP81gGP/4eRj7+xtnD/Gk+w+8=;
	b=yv7mmMRY2U6OLSsX25nyTk5ZsVk/I1RkxGwn8PTo3hgNGpeN/nRS0i1jAqJKNWaaX4MQwE
	2aF9zI80vnY1yA9vAEjLkbf/of5rEaFCQ/TI8kb4T5m2QW6y92KWT1MFzzQqNtnvCZ49pU
	74vbOEudms44aP7qcHiDUpQRDM1ZnFw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757637545; a=rsa-sha256;
	cv=none;
	b=x0cGr5HqyCY52TTybSV3PICH68+uEfubHU7cxplv6I1EosE/B3KynXDsuymvPpcXu7Danx
	XVeaXVVfOVdg4UohbtSwbzdtNyjD7t7z+NsYD1WQ4AQ7zxpWqidaGYEx/Oq6nQCW4dGxmw
	/4+M/4x7B03WFmaLEP7gmXvpasRYYcI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=TaX32Jbo;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-32b5d8bea85so1125066a91.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1757637544; x=1758242344; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pygF7jfRzgyoJR+RbnAP81gGP/4eRj7+xtnD/Gk+w+8=;
        b=TaX32Jbol2OdSPPFwaeQSQ+oAqsoaamdc9OJ0vKvAZZhn4ettlc7iKgSZgkFFrNpB9
         CX+c8IAtzdUY9KHrWKvnK02isO25leYY+/BReDY4q3IO/fMpkKEC2cDOSEGuVZIHal58
         cVY2WQ4YkXgX3/tjt1YDTV1IWfbRlySOeznKg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757637544; x=1758242344;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pygF7jfRzgyoJR+RbnAP81gGP/4eRj7+xtnD/Gk+w+8=;
        b=vAV8FFcDQBm4j9VS9lVynWM2lFoTNLideOjdcC47plz1wb7ihxBBGJDXi/oKNZDTyr
         y8vzB/6xLkHiFTHY44yAWg4uIb3e+shTMfGwcVkkqN5KPrJA86pmeStENxQhR6jmsPm0
         g8A5P6y5znwoU2RY7bidv69ue5VaqSMVzYDnOAG4OYmXf/YfTappEWMOn11q9ofNv4jm
         CIYgfLd7KYzVw0KZbLRWVc9T2eHtiKuF58jR5ugWD8ulJfbKrqsw1h42GijTJBLgw3M/
         YUsNfGoYb1+E/gKiYZyaQE9tonUHmPm2WylcT4f3eXZTfwpTgJKdAgG6S24Jq+xdz6lW
         eNXw==
X-Forwarded-Encrypted: i=1; AJvYcCUmnu1WGfRHmHf1UQ3xA0g6rjxue8ORkF097FEjpXiWw47mkBxSHFPd7P1Hwummr6Rp1y0/z/Nmgg==@kvack.org
X-Gm-Message-State: AOJu0YxVaGDcUCZPRDG41Pic2+6Zd3NV0fnMMtw5ex9D7Bmdfb2l7ak1
	g1d05gY441v9yHfWE13Sg0xebaAqxQAO/fW4XK641TXHkI4tcu/MM9JNMprVWRfYRg==
X-Gm-Gg: ASbGncuw5wreLutX8HaLApb2aQQT67JwY5wK0Oo5vopdumf4x7bYDyS/oO5M9704FuR
	fRLH7tt0wotCLh5CfDqmVC+V6yWaUS0lmBV7Wj6omFO8cPCLBbPDAs2qnN6QexA1U+g7ZWYaS23
	53zXXFeZotQParLqZBtWs04oBGYhiwNr1PS2oQ5H9BmJHP/yYs7wORhQVclT9FahvotctFrudzQ
	HhK2sN8RjtzxRSckzRtI5osPFwc7aGUqcBFMmot+f3140/SH1cIyu6fXQP60i7OO9E950e/gVGP
	fcKRLP3H2YLwqLmVCLPlsdwZLgT+IHqoKLlNa+ojKiNMRcmfWjQt/A8IW7KmpgtcqalxVfCj4sJ
	meiJG4uhZmPBO7F3fNukhkn8w3w==
X-Google-Smtp-Source: AGHT+IHzT3QQNVRvVSz0tE7xG6V0WgOvZURC67BN1xRkbpT5lpSEH+gWhcZm+P+aIDdhInHKfnPrvA==
X-Received: by 2002:a17:90b:582c:b0:32c:7693:1138 with SMTP id 98e67ed59e1d1-32dd1dd8939mr4799954a91.14.1757637544012;
        Thu, 11 Sep 2025 17:39:04 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:d93f:86ed:f2c4:218c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7760793b5fasm3501595b3a.16.2025.09.11.17.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 17:39:03 -0700 (PDT)
Date: Fri, 12 Sep 2025 09:38:58 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching
 kfree_rcu() operations
Message-ID: <iycnfietmsgggxcdjuqngjuzbuygsxfpvkcz2fwm4frdxin42u@pxhmqcgejnov>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
X-Rspamd-Queue-Id: 52CFE40005
X-Stat-Signature: d4em5w5xqkmjswiy4qogcjzipan9skiq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757637545-615434
X-HE-Meta: U2FsdGVkX18wvNTdUvV8LbhryNCUsXWKkZntTCwTjx/froHpXQBXejSmGQjjfGNYx599aQzdwND0kq5aJZrCzubjtLStPjVJIO4sZWKlLORRmWDV8SKlU5q8Y6hUTRb31YXF1zkawFhUvmfgdgUZnQpiMw9ZWrtzTtetkurvtIBJ1Eiguw9GOFVK6bWdK8JmeZ8gJhZ0ujwLqH0crCvXZWlQ9jma99csHTdDstB7liMhBUA3byEr+TWbFdNkbAqXs45YEyxB0M7mtEMIXiz33cWe369+hcqeQ3NyriKIrvJ6EprCG3avtH5xUCNlNsw3QURwlvYPbHUl1Wx4StexM6jcue8ONMgikzLQbBPvCPZn7xbXJzrzJk69uI4zpUcP2hfZlbWf5KJ4n0LMVujHTj5A/hqeZsyJfaxLsf/rMhYg1pZK4a2kxRei+oihWgZ3eqE0p8t5tROD1TlO3Y7DmRxZqECz1ApuaUx/s/DDpYngEuneIMUpDwBxCR11UJQERt7P7aDxW3tlR6Vwq1N7nZ1GX7G2IwUO679/ESudMtiv7ZqFyxFlI8fSNeEUpbaqQRUZR/16Tbd14kc/MDMa+t1MVxtUhF5ssfHzsIsjzDWqEfBtdjr+ADypm/71B8s47vfnxnyNLwAw4OZ97HVW6uCgxMV1OeMatRgTlXMd7U8w7GnaiUYAAJ9Nrm26X6e5p/d/AsdQJDacKnxxDz9KkmmeapQOpicGMQcioX+9DZS2S8oTK/Vi99Z4HcWpzAP09Vg9OyhHkLiQH24Hg6GgPUXZlvkmLsiWJegXLV3fXVHQ7a7DDgapU1iCdvcuWAU10SLc5RwG3Z1siPeODvbd470SQFh5Q1plXD2YZM/AspvGEq8rX3CgQs/lwWq+ZWEao+3Z4H7JnmkTFNtRG/+g1hPd/wgtVuRtN0/1wSbUs0Yxaxy9sad+pvnJWUcyPi326JFUdxFpRWVP6V85hL2
 0aQVWWMN
 7GZ5rFdV8clN8VusqfBoLCai/i/gCVjkghnjcW1U9RuC+vi7h6wDCpHaOblVt022//Evc/be/2H4BRUry72G+InWhLtzY6qjEf6A+x7tWNB6wlaVqxj8N62nB3Vc/bvZCcMykhxWJG3GkxbRt7wzComLe8u27ZmIAN0n6vqyaEEBlyu2F7XSduDz8uhhmGOiFA2xtEtVnMBPpZ7LORP5jdD2230/LtdGcqSHRCy3ewcutQVJS0W4j9EjmLrYMa0pS5UfWvp/mElDQ0qcLI3i9M6nZQFKQy7KEid3bE3QBc0jguAeNbT66yV8wja5AQLMBWWbJvWn8583QstnU1UvhewmwwKoSAE0euL+YpoaCD8IhGETOeC3SeDMiSWXialCKL7xN++nFVyzIc9Fd7za/vmhnDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil,

On (25/09/10 10:01), Vlastimil Babka wrote:
[..]
> +
> +	if (rcu_free)
> +		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
> +}
> +
> +
> +/* needed for kvfree_rcu_barrier() */
> +void flush_all_rcu_sheaves()
> +{

mm/slub.c:3960:27: error: a function declaration without a prototype is deprecated in all versions of C [-Werror,-Wstrict-prototypes]
 3960 | void flush_all_rcu_sheaves()
      |                           ^
      |                            void

---

diff --git a/mm/slub.c b/mm/slub.c
index 11ad4173e2f2..a1eae71a0f8c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3955,9 +3955,8 @@ static void flush_rcu_sheaf(struct work_struct *w)
 		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
 }
 
-
 /* needed for kvfree_rcu_barrier() */
-void flush_all_rcu_sheaves()
+void flush_all_rcu_sheaves(void)
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slub_flush_work *sfw;

