Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40EC8606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=nsXWwYzQ
Received: by kanga.kvack.org (Postfix)
	id 54DD56B05B4; Mon, 16 Nov 2026 18:37:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FDF06B05B5; Mon, 16 Nov 2026 18:37:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0BE6B05B6; Mon, 16 Nov 2026 18:37:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19DB56B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:37:25 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9835BA7515
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:37:24 +0000 (UTC)
X-FDA: 85442596008.05.7D005B0
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id AF0F918000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:37:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nsXWwYzQ;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794872242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uOHVmM5CmpZM7TQtreayT9wMg/R5R3UxyUKm5ik/5Xc=;
	b=bQT84qX6XUeWJ6/mOSri78Qyt4sYrtSjKh5d3fEPjQtYG7UxlxfbJ75EUnylwSEgVEkClH
	XXTmsr5GZC361J3W5grZJjeuP8gXPyfHTn7s5v9ZgtWYO+ESK4Xpi8MiyrVIKg7PWgGvDT
	J1y81UiJF98rqnpyNKSnNNM1C+IAMdw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794872242;
	b=EW8J5+RVwCnpmePFOr0fgZ8pgWxIzhXvZa37xSUxq48iThs+iuuw4d+rnSPQODJlvSoW7O
	9T8NW8KXL45NYyl5XHW3kuqeozDUicn7aZYUZYrmMx6a/eizewRTevy3SyOQr8FjWFMFjG
	SekcSSQIyTx46xPrmOcM2cKlecoKeCI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nsXWwYzQ;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-55c35262674so22857581cf.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794872242; x=1795477042; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uOHVmM5CmpZM7TQtreayT9wMg/R5R3UxyUKm5ik/5Xc=;
        b=nsXWwYzQbTrBnIofOwa2wvAtjUjHCXZKyNvpG3y974krTBM4JBLBbFNeyxACqCrCLz
         DxyhK85e8joWgxKJOkQAFT8BHCzmZtMVa52tyeluYpb+XgTpZ6glbReJm5XIk2Iqylpn
         49HwqIzj+MIStPW4EnXOkqa5xZ9k85xR56jPsfk2R5gaz9Jzhaq+WkaVi4w5SPYUAb74
         Jvt1T+Ir5uA9Bl2d6BCrxCrs4JwKMuStWovlZMnmnFKvsO38juKAog8hcSeaHzX30yDX
         wYEwYN4yGIhLv5Lb85UBIJoo4iepjTDd1YJ5o+yhleTbjotsrGmCIFg/f9XG2HTok6z9
         tMQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794872242; x=1795477042;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uOHVmM5CmpZM7TQtreayT9wMg/R5R3UxyUKm5ik/5Xc=;
        b=0pjMBSPzVOnZxCrmwRt00up93fpQzjOPiwf1G6cvFRy0ZjdEXuYBarP/VRNJ954oSO
         6tz/xdRjWUKDEOeOkfeoL6wbgXlUOU+lxo1pmLh++TqgDVJ0DZGfkFLmAnpZQ+dAANMD
         xcjxxWICRTahm0mLQLKaQJ1hnC8dzLf5eAqsDD0kmPahoN+4KqsGF0SBHsYwEfFTwgsW
         LzrM7rcz/LLAm9cnsc7OyF5DTnMEOhE5ELVaWCFnxP+p+1qlZ7ZrHUF1nUxJAsNP8Ur1
         hzQONwessEJ7LpN/LjJnKcYhLRjY+NTn0dzVbjbMLk6iyDO8VECcPZoXrBwe0dwZaxbE
         gEXw==
X-Forwarded-Encrypted: i=1; AL+hErHOC77wWdT5LS5OBNMbsoQMvFCtIHDEYhlwbMQbz3SRYc55+gcwVG9XIrM2InY0BBJKp/YhjO5Q4Q==@kvack.org
X-Gm-Message-State: APuU4Z+7K3VjrSkXASJQbEdnqijbSTCorqovxZZHZ5dRKWzRPz1XtYP5
	rPtlCb+HZ/pTQu9h1eOqEmNeb3P42m0qA4mdCpoDF2QjgYNiLFpExMWRxhMQdUZC5NbrXLNp2ax
	tK/UT
X-Gm-Gg: AYBFou31R5/7gvIJa42spGlAQYyD0aQJi5HPySJYEKCjNd5RCRgZ0w10agQI4MnpY8s
	T4kkdkE8IlBmnqJkqcwAo+8rcymml9aHnAM/dKzM6c3/KM5UB0rWVTjwEhszw0xlcIVdok+ymmR
	BJQxRb424EZAiAE4zzdKNKvVfvGVhP9tZWH2/GvQEaAn3CRvuyHmvYxSoRSplveXCMBNKP7SozS
	pRaQCNcd56ya3exqU+tkc2qQO7XidMa+1Is5WC8gWJWmXgqhj55vjZQz5xGFsLh0slTjXmTJVqt
	/StNOPOCwp8IEPVbEQvTCHwaol9JRhIt5+g6beDdj0BGGILl5FDP7SCo12Usgwqp5p0bBTUhMvp
	3zBS00iZVkWuFs4aMcG2aRnxmgk53bQ1sVCUKc7VWAPmQAr4kevqsQ+05Pd4BKCbcch2knK1upC
	lY6VSJjA2RwusPLpgas1QkDkjLbeSvrbV58t+jdgCEZd+pVQJLO/iYGh3qcp7cd65Kt9szxmbOZ
	U8g3GCYa18MsmOegZjFhQmNOJY0WZir/+Lzi2iLoacui3vsUWjN3UBktx4zBEcCUK7r0Y0R6gQK
	svWUl/cpMzBr45hXsCcXbdtsEVXdk9H+v/PwDlmKgjv+KF1Y1FZVLj7rO73jM2rrJjaUpqYIEnk
	q5ZCA7uKV5VsyFO2Pol+mUY23cFQi
X-Received: by 2002:a05:622a:349:b0:55c:abad:a72c with SMTP id d75a77b69052e-55cc6d16ad3mr128623811cf.56.1794872241711;
        Mon, 16 Nov 2026 15:37:21 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d3e135dcbsm29090161cf.4.2026.11.16.15.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 15:37:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 3/3] mm/vmscan: consolidate promo vs. high watermark
 checks
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
In-Reply-To: <20261113235238.3595412-4-joshua.hahnjy@gmail.com>
References: <20261113235238.3595412-1-joshua.hahnjy@gmail.com>
 <20261113235238.3595412-4-joshua.hahnjy@gmail.com>
Date: Mon, 16 Nov 2026 18:37:20 -0500
Message-Id: <179487224059.482102.5784465450134794105.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AF0F918000A
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gptcjenmjy9ogsdmuup6zbjt1n1hs78m
X-Rspam-User: 
X-HE-Tag: 1794872242-43452
X-HE-Meta: U2FsdGVkX1/4/MzWT+ZYkzdpmvOBG6Uxmq/2aU1zy7NiOLOabUnS3cSY+wLKySWuEA8T0RGk470zopdgVKd47XLr4GCl+qPrfB5ZJION94z/wcho2yDwJenPc/HV3uh1glYtzAetzOD3JF985hNsj/8sB2ticnlTAYRq3m7qYaKxsfgDDdxbFc0k2F2gICmIbi/3mpiAp//5ytFRrP8jvmsrk6B+9K8KmxxzK/4tk7RdlFgm7RYAW1GMHA5enUQphUK9PUTvuZ+SMHwGkKA/elUaA5ZOHjgyrhRoZhXbzMdl/O0Q6Z6FF5Zib6WUABmivNxJKFnAdesDvOMyueuzP+e7S+UiKwLftzL1H7gT2juNnLgOMMxt7fiw3uZhV8+vyJSI3GVyh7bLPo4F9tdmacA0DFyeXL2q+RzsIZk+nW/ZN0SklOmoPlWSUgao9it5Sd48NjyHMo8aOeaQskwNS4DaOS53cxfJ4zcktjvfPYBpifpno1wQryS4vJq0hx75MaJCqmGMJm2O0hvFgqUr5rmWwJfq/AXgbHkFdU9f0hvkI9kq1hgfBWXxPP0EKdtIKzGQ/NdKEP+ff3SiLSPzl+XfIvaDnbREqxsgJDtP5wLM1FeW2AsSZQrXSFB+43ewX0eV7tpoSnzy8MxHgpm67keRe+RxGHkADRRT8FgeCyEH+pDzOHYVvrV91DiGFt30hhYCQiAE6VctRlh0uKpq9sUhbHuvygAHrD9OS3gwG0dl/XPaIPGMGLkYl3LaONutAmYhcmie4qiRu/XQ4hbub7tWs54DWYTT+geuvQcOQeJBrN3uHmVjfqepkCR+xVWLtD5O/V/eOUGR6i5FoCF5TaMeur747z2X+XjzrPyAi5USw4JEerHlhYjD9o7FlmCvPiC9NG0NACQfgEaeSwzbzkVqW9ljlcuKD7hzJmyyf8D4lke0k7pXmo/xtuih+zu5rK0PLxA0b2EqBn8v+zx
 IXnj3GI3
 lH5oGgMM+PNwRu439TkKyoivYKPrBR2BluBorts86B9Qvvv7BVbeVJF2nrLs0U7rShJFrgvDHy7pV1X//l7N9yOfr33gdhTi0sqQSyoJgBNTLh5Rwqhkpb+3hIK+ymbl5gGf98bdvzBrpOZ+6wMOQulHESUPVsvH/b06sgp6ieNNGZGyjRQx+qxryMAWvJ3RcgLyGKQwX/p1IC/7775p3ShmHUrVrSSn5TKJ2VVQ6K+5j7mzvyHS+xXGgt7lidDCXkKu2lDp7NzlPv/6wOT6rF8y/m4U+71TKJ3IIuU7zWwh/B1L6oEBWRKWi74lItKqfv4UxUlrbh/Ru0sqDIUnQVgIMnHjvJO4a8lx/mjI68TahSot/c+sosXos45MSMiFmS0tBR/6pu9oB8N2AgD6+yYr8Nqwg5D+EK24d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-13 15:52 -0800, Joshua Hahn wrote:
> There are three sites which all check the watermark that kswapd reclaims
> zones up to, which is the promo watermark when NUMA balancing memory
> tiering is enabled, and the high watermark otherwise.
> 
> Consolidate the patern into a helper function. While at it, remove the
> include for <linux/sched/sysctl.h> in mm/page_alloc.c now that the
> dependency on sysctl_numa_balancing_mode has been abstracted into
> vmscan code.
> 
> No functional changes intended.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Nice.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


