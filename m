Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9C02CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 04:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B2FB6B00A4; Fri, 26 Jun 2026 00:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98AAD6B00A5; Fri, 26 Jun 2026 00:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7A16B00A7; Fri, 26 Jun 2026 00:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68DB96B00A4
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:50:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D3EE11A035A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:50:55 +0000 (UTC)
X-FDA: 84920838870.10.0CF31D7
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf14.hostedemail.com (Postfix) with ESMTP id D31E910000D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:50:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P32H+IGo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782449454;
	b=I2zelYtDuISxyJ6NTePkG+yZHZTNgdvYms7e+JZjEsezn6IMsumTm+HqMZ50/1ys54tOvl
	gyHHI1uwUcHoF7gIHlf13Ayia98Q7tFThwpgvZLFdXJ4Ep6Sbscbq3y8iwRTAgqQjPPLeJ
	fufwJboBBCvO6QbbzOfdqbXvxfc1awk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782449454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+VAD6kx1YH7226mbPd2tBdtR/GRqu2/JEMjoE4xVok=;
	b=Ru6fvVypNsljZeoicKbYf6NlIzY7cnKf0QlQD7DsmYy9RDVRNKfZkHAWWHR9wh/54keLWw
	IKaEsQv2xybZaiQFYx7NSTDxat7WGJzFqLl6k8XS/kn/sZP0pM6sFYMJeKhPsJFIR/j2vo
	oXiYRR9KlSt/DXnAxLjQ3XSXoUBmr2g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P32H+IGo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <46eb172e-7b31-48cc-bfd5-ca4777bf37ef@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782449451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y+VAD6kx1YH7226mbPd2tBdtR/GRqu2/JEMjoE4xVok=;
	b=P32H+IGoTdMWMRX3QdLXm+nN3H1478ZO/lGcErfCRDKgnHC2YsBgCNMd2ry3tau5Vf3TZ/
	rR0CXvMvsDZF/uO+QEF3yUerRMoy/nRLPqD8/wc68cgs6K1cKKK/G8r+g2tlL9AOzX5Tel
	iMToO9tmYYWuGJT2qfDm6yoMTFSr4MU=
Date: Fri, 26 Jun 2026 12:50:33 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Peiyang He <peiyang_he@smail.nju.edu.cn>, akpm@linux-foundation.org,
 david@kernel.org, kasong@tencent.com, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, harry@kernel.org,
 muchun.song@linux.dev, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <20260625151554.55105-1-qi.zheng@linux.dev>
 <0559695533E1C70F+31684237-e405-48da-ad8f-4ba7ff4ddb38@smail.nju.edu.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <0559695533E1C70F+31684237-e405-48da-ad8f-4ba7ff4ddb38@smail.nju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D31E910000D
X-Rspam-User: 
X-Stat-Signature: mynt4rj6rkmn9sbr5cz4bj5nijhuixgw
X-HE-Tag: 1782449453-375583
X-HE-Meta: U2FsdGVkX1+knkAzy4tC1qElXDZoXvv4B0FBNY01KUHz+pWd856ZRGa8DbOaf2d+s6JUR/4/EHjwk+d4DQ690TZ7kIZYO4ZX7lAj7M39CxO8YRhtRGPZ3D16xCtC3FeLPbHc/UYlgzn/gADktQ0SG0AVVsC8d4dlNC5xo6ahKHBJ8oX4dPcOQW6YvSwgBm6mtHdoA6JmkPUG6kagbmKdrjWLpv5Py2PGlenBw0uTfXh6go1QEyfH0akXzdsnUKNRDF1pe/oQDHjNo4WRrwD57OxmlEPZjBUHQyBpstEzGMJwHSh21H6GtXlvujbQnohZiH7EtpSwpjk1bzLsWkCE27U02SIjpSIM6EQT3pL4aniWYdxHP42N+ChGAHA4FNGVmeF9eNQJc3SvbgXfsD5pleCOmMoFW9fpfFhW1ffiv1yKk0Ni52kVkTgUMk3p/ZU+Tta+XfwkdSodCQE8xOxmBVJeuTKyIbv25nv3UQZp8hOt/wjhn7hKFUJS76XFWcjLQsxNTnpym2owy5kI4581bH+AsAuYw8zOCR4jfC+nZk47KWIZdSf6N4vfoxf0vCwLydZAEyK3+iyuooCGAP/vQPHJ6dPORVKn6YbiC0ASoohnYyPby9QLqBVGpGzxmhXRY34ga3ImZM61omlKPK6thlmdBZcrHvpiHW1PhCzbEUtz7mcPPYZvLmZrM2As/ZhafQ49A2QSJPomrthAM+eYHIOkTKQKERUlreOIKUJueC3JdjTLRCH4BFEOF4Dwxliswqfogg7/4F6uxa4CLN7s9/AJhI3qsIT3cvQKLuYklBUKZ74UO3VcFcKTN9ctpQnm4kRXKXHsfCiaSvEe6J4h46hOfedgl2GI7iTKrHIgh2cYnip2REt6IBTmbpcS2gXDq2FOnS+8Z3nq6BE2GuQSz3v03bg1eV60zlr4acxn1C2aIwCpWyafR8oY+BZ2XN5VMyO0+esZd55j639eGqW
 jdCGywEH
 jbhBzTJo9irko6YE3CCKdEjEAuVMmx1rlnjwvHBDjTpMolpA9SaclYBKS1G4qZlPEk3YvL4OHCfqQ6ULcfkbWHeM9J7YdCdft9cHgLDJ9XNQSoDBUqGKmoajnazuFGJY8wewcla98Ihu/QGf9Xh2o9lvwRaHopzbGzEFvrnH0u/qofpYZqq8GCflr5y15udEHh8TBA0liJmd886FAUCBaO0AKWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peiyang,

On 6/26/26 12:29 PM, Peiyang He wrote:
> Hi Qi,
> 
> I have applied this patch and tested it against the PoC, the warning is not observed anymore in the kernel log.
> Thanks for your nice work!

Thanks a ton for testing this!

> 
> Best,
> Peiyang
> 



