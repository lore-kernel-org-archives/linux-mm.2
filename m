Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DB9ED65C63
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 22:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C0146B0005; Wed, 17 Dec 2025 17:11:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944066B0089; Wed, 17 Dec 2025 17:11:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 825426B008A; Wed, 17 Dec 2025 17:11:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5186B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:11:18 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 391EB5C960
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:11:18 +0000 (UTC)
X-FDA: 84230359836.04.96B783A
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5D4991C000C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:11:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=c893mxZE;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766009476; a=rsa-sha256;
	cv=none;
	b=CpvkdDhp0jTxjGIWesGD+DFRph4S6Y7NhOm/qZt6A9f9qoGWIHQ2jsL3igHitK0WnL52Zb
	rX+Ru65W8cJVIp8xRrBqoLSc4ETCzPc1d88i2s5d4xPcEb2oDQoBl+wXeM7QRQdNfApuNQ
	/Zn2fogfVIzj/MuSYvM1SLLB11Kf1CI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=c893mxZE;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766009476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9EioNTCwqG6qzkEs2QnInVjKzgqwIpqmQRuJzuIdBCA=;
	b=KaBY4Xjj9kFoBpUrOXwh4uIs4qUGJegsDOZ9d6RTbMOPqzuv9U2CcQ4b5wXZLBTSlUjy4b
	qFWTXLfiUqL5afzj0F8yAcK4RTBNER59xBSj1JPLrhNpgWjfCgI8KZXZAESX1zp71H+DYj
	GhXEVjYSDUaAT5J6jmxFYqbA2gfe+zI=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8b2ec756de0so600985a.3
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766009475; x=1766614275; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9EioNTCwqG6qzkEs2QnInVjKzgqwIpqmQRuJzuIdBCA=;
        b=c893mxZESH5HytsB//Rgm8h+tBj/hMR540caFnKcjxMMj2g+NVWDEavmNN2NG5+OqS
         SdQP63tc9TOP0Mc0t1yTAFjiCRhf1eszq/dO9mZXYj2HY8M5Ilp3KAmA8QGbpaL1idHi
         2HOYm0hHPtdROyuG2LQhoQlxRRJDDhR9iyEMv4FhQxiHt+I1b6KChDSmgk33WcOwIgc5
         7BY5VLKq3aCQj8gQmRIikeZvTI07rltvNRzXWGkRDJm8r4qcHWn0xrn/5FtyWKtae9ZM
         cKBUBzjVgwjcy2nZqpEgyZYEtpyLSFY88NnFIm8PTz+aFtkPLW8YYtUoiO3zaryfUk7C
         JTww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766009475; x=1766614275;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9EioNTCwqG6qzkEs2QnInVjKzgqwIpqmQRuJzuIdBCA=;
        b=nyrwGxwnaJySeBzZJJWlDKEyXeEoul41wNdap9JL/l5Q+qJDD23OE6Al2mrn2+sTK3
         1SBX0LAxVjUvChDJUohbz1SLRJ31Wh2TILqyY9sWdCjgMrlye3zljDUO7m1DVDaddq2M
         c/1YuziFWMQ4h4EI63Kg8sqG6FlrLZy0GSJN3WSLJrCDZ/Uj5VMxaFv/HSphw6livUel
         +2iDfOtiWEu656Cj9AQ1rVb0ctCdjR31BBzaKA7Uj9zxsDK8EclpV0PvybbAW510v/un
         fNhj6OQePtQF5SChoBMBmWZHz7Msj6NzxdymvxzfZsqtRPNPMvXpSxWliw44Q1LauN1I
         TcCA==
X-Forwarded-Encrypted: i=1; AJvYcCX0Yv1FaZUhB6/zOSxUXDt285oSvOpd68ZxTCiCafnUHCKXxpLD6IDxMiAnoYRe+557lajHDEaTgA==@kvack.org
X-Gm-Message-State: AOJu0YwZtqM4rt7yzXiU8DViPo2linv8sqNhK3YE5HyLfPvqTiNHVMr1
	xF6ng4M3S3zw7R98c5xJPa58DT+y05rdsXBYewUzYR2Jm1gtpregI1hGsXoMRxf7gkM=
X-Gm-Gg: AY/fxX52u2tT/furaMEhgGyy0OfNa6VpkxPsw1hA4Nj8RRRMyrPgIKa4g55KZUYj8qO
	7YlQhiXmo4PskF3+oU9sdG/M/u6ONVzYbKkASUsmDLkC/D9jSbREwcSwvjkOKeb1LNcDIPwq4XJ
	DhO9q2jQZtm8cvIm8oC+9/NH2rI+nO1pjpzINks1W6FYWi5sCExdShNj6CwK+XzoEQkkge/vHzh
	CGpksWWdGbP/pVuGzi+4kYtrmYE9glp1E8oKKrJLhB37c5RBqHittROVUz3m+gBM8gMFyxajo1t
	gc0RuBaiXFpnjMPc9iSYkyQEEk1uSe4hbkfELML2UMmNeIjAmTG9xGy3uz3G7mCkaPoNcHmsecM
	AK+yYUAD/HtCRDi2DthQBAXbjPRyfKT87rV3XIOSONsT7yaVZi6LARR6rheFU8A6VXLbCepUdV7
	2g6Z3OaPuNMQ==
X-Google-Smtp-Source: AGHT+IGgyeULS2yL1kyDxa/tHi9+lstEdnmTR5Uj0x0lP635FqQGB11Q0kiBfEr2i4WUd1NmFkRAWw==
X-Received: by 2002:a05:620a:28d5:b0:8b2:ef5e:d27e with SMTP id af79cd13be357-8bb3a2776c0mr2800428385a.51.1766009475409;
        Wed, 17 Dec 2025 14:11:15 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8beeba3c1aesm34819685a.46.2025.12.17.14.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 14:11:14 -0800 (PST)
Date: Wed, 17 Dec 2025 17:11:13 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 11/28] mm: memcontrol: prevent memory cgroup release
 in count_memcg_folio_events()
Message-ID: <aUMqgeBerdUChV86@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <5f8032bc300b7c12e61446ba4f3d28fba5a7d9d5.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f8032bc300b7c12e61446ba4f3d28fba5a7d9d5.1765956025.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5D4991C000C
X-Stat-Signature: ckw8855zdpxqnrtpwjjtbct8rcnmjqc8
X-Rspam-User: 
X-HE-Tag: 1766009476-374
X-HE-Meta: U2FsdGVkX19s8kKc0g4MaLsaYAeNoQCglLtnAnR7kjjbk4GhxvXZvVad3SPIhfbf9Vxm/HfyioC4a/rjYn2QV3/BsFtX9wQXitvtXd0HMbwlkV5NgDvTCsY1Uw9IuTOJVvL8+0B1PGSZiWI0GqFJH+yXW6WF2lZSmEZzuS18ZOlCx36yWdSPmXaetDsOjHSufJmDbrQqFT4LeTPrEi2USqmry1/ydOsfFmPuhLjGMLXH4643b3JQts8jioO6K/Ti0RuTFIHwPg0yN7Zi7kuL/Fsy8HIdf6lOCk6j4hAWPRpe+mHsK2DtL9DDC3bQ21ZP9A6ndPetGN1i24JDLFcwNIuMxlRncpNTgByq7TVdU9OUMrYiPJjIK2ZXqRazqHd7qGieRjnRHG/lWJ/UzqqAMaAb5+RWlsv19b7eB2Td2o6jfQ7arYxVi5vZaY+nkbs1CJaB9hmu9TXIJ+iBFpXnuRjqS76aFQIx5I6NTOMVjBWn9kCgAkQBBelfshLUmBilQSiTLDNXzcezApqjj00xLYxL5wkLeNgDeq9yMSfa5XljTxTWW8GJvUVr8noFB17SVAoMp3U2PMRbw6rezWLF6aubEv3ljlg6maA8z8vSEmMGjHdqKuDQ+/4QWfGTSK+YP7J7i/tm0CtZXhHGqJQ0tIpmfSloYPswCiVJxo5M2AjhmdENoxw/J7RKZh2FPDpTGz5putC5SRjfjWrcXTrvTCpDl9JwWUJusbDw6oTvdYRUH6A3hyQanfsG4FW6CRboPMpsuu60kP0GNGUAfr2OtsKdc0LCpuZHZB3P1YpK13Jc6VHpuOW9LKOjhmCj5W71Gx4jy8inoQeKem1spMnc8KMIuysmJ3PFkr/GN2VeBCxrJDmQ4RZsrLz6A3xw2eZdyiRMtbFe1YtboEaBLhhrdhQh+KWX7PI85ESIGzY7Uvyqjd3AyQ1qN8eyP+oB8s5AviKuc31Sve9zlY9Hv54
 C2ETn6I9
 GRr6abN8O0U0qXQPBjCPfNwWi99VkCHHS55gSCPoaimtK5SwUPVcOnDj0nFX9REx2J46GVrrAJwU4vQby8vFjdarxFw6t4l7TO9Vtsu7yyBdeFmY6OzSCwD1dd7/GnYCncBjmfTDRcuu5hUUXRueMcQnGlIrrps39eklBmmyCPUA//4Hsph2RQ99KJmRBvb6SyshImc9L+X5ZNcQG2MxkHO4yFtNRpAR3GGJy+7xXKeyvGvfNhF5G5mCwvngSCMfVAMVu71h4uATm9WLLIGnitbKpzFld15luOPKV321E/1GCBBngUT8z9q+ni066D2OzFyTJBMDzgVNvYIYoLLXi3nzIuGKYLh/oQMeqz/kOdI/h+mgwXoaK2Uc2xAq4AnT8BXMT3UjrWJkvVazQykSBv0Ok547W45JgziVusQWfpWds29dUTLeZm0lmkM9mImvrbEZplhR7CYSyREWlUdbI4nCKdW/xGgdcNmxq+G8Q3kYFGTitqcVLGwnQ5R0PuM5FJPqmCLhhOWcJO1cWjEHy48LbCQqgzbXndc/5Dc/Zj/DvK7c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:35PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in count_memcg_folio_events().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

