Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DCB8606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 04:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=hamW0ccx
Received: by kanga.kvack.org (Postfix)
	id 32F6B6B0627; Wed, 18 Nov 2026 23:29:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DFB96B065C; Wed, 18 Nov 2026 23:29:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5F56B062B; Wed, 18 Nov 2026 23:29:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E429C6B065C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:29:24 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 52AAF1A093E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:29:24 +0000 (UTC)
X-FDA: 85450589448.25.A21544D
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 721E4140003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:29:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hamW0ccx;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795062561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dCICOQDRVMWPO5nwEzDmnqXj88ffqAN3Sthv4ao13Hs=;
	b=LhzC26lfKgYG6S7Q69gFocKhlqCVLPAsLOOQiyad4GmU0e80eDIF5eiPbOIxqi4RD8COZ9
	AIiyzxzyhaTBTJaWd6OrkxcKLDSWcj0Ge1OBz/l58LZb2R7l7F6zp4e/kf7W9wkuYEan4M
	M/7eC614g59XtFC8DNvhorX0aBTBjvE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hamW0ccx;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795062561;
	b=q5IeizcqjtaXyUx85I2Jh1ojFGsrJPHOzsOJd1bVT8GghlmcH+t95Es3gNbozSEWhjcav0
	R8+srGQV63AttdwDqUQ4KMno+Dj9FyiUdMKbIFxjjj2fqMseRkEs81UvBHk4XtNJYUQ1MH
	LQB3bUlnlspPNxiCclFHC6YUunRrI1o=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2efe022c04bso7140675ad.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795062560; x=1795667360; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dCICOQDRVMWPO5nwEzDmnqXj88ffqAN3Sthv4ao13Hs=;
        b=hamW0ccxYVpQ/iQlPk8H14IfbtrVATuh34NgSUGCNf1T+4HnmKY2KyP4EAIJHXyIIk
         aPlTaWQ9shCW3GhGvpsKDEcUzb9Num+w1FWppH7KTHCQhIPqBZdf0SrSfMX/7SJFN1BB
         APgapU6/lqLKRLDbYK//mcntr36I7JTF6GxQE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795062560; x=1795667360;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dCICOQDRVMWPO5nwEzDmnqXj88ffqAN3Sthv4ao13Hs=;
        b=vuRQ+6+3RdAIN7O74iLYLViXvzeKVwDB/JemGXFOM9yuHgMAznPtGtWad2TGHfTP6U
         FXvQf4XLDvwpAoiSW5DbEV6B9Kzsb7mzggvUaaydM+oosfoepbjxU3ogbqdNu3Kzbcp8
         ToRlRUYeCPGUk9VlvsAiSww7kCJN7vYLUjzmUBPg6xShcOCO1qHdFkoTwUadLqcTJ72s
         s4CiDs+5dMI2AY1atgyBLrc7riSnHWfGXUFBx1jxUYG/qXoT7/BQmzcBA0D8QI0bCW6Z
         ZC1Txnc7C7cq+prg6lSTU/kNQhfp4pcFkm5a0Meev2GszeWj8DKzPqbMiTeL3E8sC7Q/
         uptA==
X-Forwarded-Encrypted: i=1; AL+hErF4wSWUzrGN+zrvwV6uEj8ZzbjoayqiUuvcN1amcNYgVlghkCflJv0n4CFeSMRudf1KXU+LO/objQ==@kvack.org
X-Gm-Message-State: APuU4Z85CLyK12ZZt5eaaanq4CZMQIcp923luCs93FDxuffAjpGgwVF5
	9WSeGPMOUp8X+MvhMGdZlz8FzmOhIHnJxjLh/RqYS3UYdZ3hkBqaQKb6xhIO+V31sA==
X-Gm-Gg: AZFdTZeYotHLIc8oJa5k7xZ4vwPjJQJ6fkNaT7hBnhsnCuZk8c/BCdGPPn4DrT5tgLu
	Y/aFig+za/3L7dwxxImHjiUPSMtVfjCTcfazrl97FJGz1yEwRgQGLfjqX+hzRGYQ9wl6LwDvf8r
	mK/gSo9ldR++LdswuXmEI5Ngqv9cqdf1BoJml+RGmB7P8C+7Wo7hXeWZVQk+WMdfsAmtrc2R0yj
	Pt2j7JZCjsnn8e2x0hSYHgn0x9+QFtLleoQifdp3PCzL1YzfhGgynQFd12P0k2V4kjpjcCYP6uB
	Pt77I6LmoIqpLdJmB/NQuoOCXDK0KEOXT11KZ4Lo7xeJX9SqLN12D5uDcbtNi8NB3loeIcyHmzq
	uDUR9mDdyqy/MiYQ4ybZ2A77Y1zkNklPsYa6oVAtjCG7fDO3YpL/bQOkFz27I5K4IOre8dQuUHR
	J4UL0tBPYd6vpnIvyZAyKCCjgc1d1ZnCyRGtanAsgEIvpbziyLyUss4FGKtsdxqxgcSuIZSp8j1
	on5rzMadbe1AnQZuxooGOqI5bQSIZaJyHRvKNUip86FlZaRf5kKPTpnqIIt9vt2wBQKA7U5Nunj
	U1Y6guny5NT4qluEusyW11/TbsqQP+hKWnYAHZTflU6mi7Z7RSONmpScwjSwSpmrFLK10g==
X-Received: by 2002:a17:903:3bd0:b0:2e9:5829:9b48 with SMTP id d9443c01a7336-2eff72ea3f2mr42869015ad.20.1795062560125;
        Wed, 18 Nov 2026 20:29:20 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:9297:4989:4c44:dad6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff5ec9cd0sm23174315ad.11.2026.11.18.20.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 20:29:19 -0800 (PST)
Date: Thu, 19 Nov 2026 13:29:16 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] zsmalloc: fix SPDX license identifier
Message-ID: <av56Sq5ZxntVn3al@google.com>
References: <39f6056e0c8834fc3eca2001fcb44f3b6048f74d.1795061575.git.senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39f6056e0c8834fc3eca2001fcb44f3b6048f74d.1795061575.git.senozhatsky@chromium.org>
X-Stat-Signature: bkyf6cncj1jz7oohrms6qtsmfmo5bukp
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 721E4140003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795062561-235751
X-HE-Meta: U2FsdGVkX1829PfFM6vRe1m6AXUZIohhrp67kXe2Lx1BmDrk0T3qMgAERov2z0UUrk0CZO5ZTzrBFxJuvU80AtprQgG1ymFC1gXQVb+IdfQxa9yCP3Ad5/33Vu4rJBZYn5OOJzPqjiJ9uRAkicKaj4oCVPtp/x0662sOS7/cAlT9Iq1Of3BlW0iEi1hnsUJ/FDH/FD9f5xGvRLNg45Sy+0Pf2AdRto3d+Pi86Tcx6nv/8ztP0lh5mnND8FnGqIkoRgcVSVzRk9OY1OK+puO4HwPw5Ua26Gx8TAjDEe0zHIPRH/8rVmBPRtLG2fV8kZnnjgRR6BOvhq+2wyU5Z39H2OKvQIe1VmqIYDiK+PH33nIPIFAAi5Wn334HDHCkD9OYUsNUkKPU73XNuq7rjZTfHTLJIOw7SKMacEB8DpAH1dyZRA9mRsfn0IESxVs0tGnCQFN9uaDpAyPcZ/QDdUbcFg5CHjxiW9UFLpsWcBmerlZyWw3fdw00QrWyiAPXD79KW299sf+qLDAKoY5LlQsx0pHYSN4dOTSzRAHKQ3z81lioYkjRTbum3sKFGPerea0ZqbEhVDHm+Yi+XYujD1w7LDAgAUib+yD4/8TWt+nT8sM6cAaHYoOeN/nF4tIDuHqOrjxo6+TnJ+5TasWm1xJ0fcM95u4LYqLAxjhnwkfV1ytK+mYo3HK1Mp5N9Pl1g2UjUFzPH1yJl/7FQQNjVPh3fyhJ8c0d6PqDwaD0hhIy39Us02+QwDcnZcjgT6XqpdjzWEMOLl7c3+pmUHakx1S9KsDMuMN4BMPpOacoCcGyllTcVue1n6YER6AIIEts8hFKhFlwqH24i35GmxtD305JD30df+/GhbaOdgj9MEUWkdoq11A/+Ru2/IETj/r5ZzsgYHRTT2v1PbO04idcLYPEsx7kuD6TCF+3mu9RjhiIbcaSwQur4bZSCv3V5cJ/fLXIcnBZ5hvS1OiU4JP4/mQ
 9ziWzyJM
 g4fWyIsUuNXkhyVb2ncrZwg3W2EMMamAJoKsn+6qoyX22cjept+vz77/p788EWKecmHgdIW/w0Cpyc2LG+/EbHnJNMlq/ObXz1kpwYYOhu8xYbY4QcP3CpZPpuGqdeL0ZGPYvMeRc5cpSh5XFyH+mYku+cxFRJKXVkQhN8T2Tz6bQJKwIIaf0YyzEdjWNAI0S+MoYuI87xxgwGgMPFj5zTes9f2CyuUd7zzO0gTf9mhddEqnioDmQzMeI/Y04BfxMkgGoX1w6ancpUAPHRdhrGGSm6BGJihwD6vUY2/x1/VIMQnvVlq8wqwNBilbcPRkQf1fkDGJIdJeMNAsRldbPxHVzV85grV67dphqcrJV2RIX3ub09iIrxS0oisB+FEmKWpGnpVSjgEbqZqcxTpZI+nLDN1Sgmxy10XKyJ5UhiJHFnFnqAd3ELd8glg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/19 13:13), Sergey Senozhatsky wrote:
[..]
> +++ b/mm/zsmalloc.c
> @@ -1,16 +1,10 @@
> -// SPDX-License-Identifier: GPL-2.0-or-later
> +// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)

So this was introduced by commit 91d0ec834786 ("replace kmap_atomic
with kmap_local_page").  It doesn't look like I have reviewed that
patch [1].  Somehow.  It would have been difficult to spot that
SPDX one-liner among all the kmap changes anyway.

[1] https://lkml.kernel.org/r/20241001175358.12970-1-quic_pintu@quicinc.com

