Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13F8BF53D65
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 15:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77A036B02DB; Mon, 16 Mar 2026 11:17:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7279B6B02DC; Mon, 16 Mar 2026 11:17:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65E106B02DD; Mon, 16 Mar 2026 11:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 511A26B02DB
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:17:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E288E1402EF
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:17:37 +0000 (UTC)
X-FDA: 84552280554.15.70CBFE3
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id BC21E10000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:17:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=GhwT6UuE;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773674256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aYljtGZrh3zJqikb/fZJJnNZqha9xGUKaxYnnsa+CCQ=;
	b=Zqai8mUDAHJZ9Hlr2PqfCTcVRWo7F+XcfaPt7U/H/Bk+bchZLGTQou9VxVKnkumif5/G7H
	B9WKkW5Y6LZqS4Be6GKBSB/Im9iUSrgKEufnx3+nFyF5aRY471kZu6ChjOJWObuCBAFy14
	ZwbflkA+VGN3NcmYf6hBcl3JkZdDlTA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773674256; a=rsa-sha256;
	cv=none;
	b=OcY6VN05aVFlMyeX9BfHk0ntN+SfhY777SlkyPJyBdbU47ezJSnyAGs/YsIJgnM/NHAoUw
	oWqR2lDD5kqvoVzN+wekkASVhAjv5czhcLbLCPHcby8z5n1wopl3h7l0m0wnXA67LcTVeY
	2Us+GygQRyMtEZvmSJK2OlPZNUj+i+g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=GhwT6UuE;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8cd90401034so504218485a.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773674255; x=1774279055; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aYljtGZrh3zJqikb/fZJJnNZqha9xGUKaxYnnsa+CCQ=;
        b=GhwT6UuEehedPRqEQ3VuYWASHvm6mFwX0M3NnNJ5OCtTp/rSyVGUk7lccfVk+0U0Dl
         ZiWQkjwMLTTdA3fgOk7l68qBWsC+TAqf/xBRfV4lyuTK/U19xLQ9LsVKzm5stS/Xz5po
         e+jKDlxvOtLn9a1ZbgqHms0An/T7UaOOM+UT+KIa4T4g/ZbxpCOBLtOuSrROxFD+BW6t
         +P39h0m/ahIb2DCI0luosrOE5zL4ex+TYPjCecs988/m6dmMQhVZ0LZHbqUqJDh1MvY2
         CtaS+VcTejxoIceeXZ2PSe01nN6JgPu+hneeDm97JS/nkVXDY07oUpFdVBerTgndXVM2
         FL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773674255; x=1774279055;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aYljtGZrh3zJqikb/fZJJnNZqha9xGUKaxYnnsa+CCQ=;
        b=iEUQPOgNxqWIC/yaKfhu2TdcapWc/MjrqdgG3MFdWbv+CgAJiDFi9i2FIljRD5eWML
         LSC+1qLbad+KGYI2AiYOtrq4KrMAUC6a/Edcoad4nr3m3p6PrdCMygOqZuU5slpfzxJe
         q80NqmPgDQOchKu669o3Q++VZ+Hxf7apeEVKH9fv9MsegQzrLhlDD3ix60t2yHg7xdCh
         NIWOKdrLSmBdBTmRdWeSMrdc7clHeDKOqpIVV3vmPE4ZuuofEf3O1aET6VS7q9L1Z80p
         lqEjlklKL8hRyFNxj4/ADuMbYJGjpQMvD2XO9DCr+NLZ7VckBeclAG77FopTMFStCzHc
         0Wxw==
X-Forwarded-Encrypted: i=1; AJvYcCXCEtbGNiAGkBhdOFKIlKQXlCwbvs55QGsIj3PCgTVcQII5oiDiftPI7ZzFHEGrMiXCG6l2o49GBg==@kvack.org
X-Gm-Message-State: AOJu0YwHsIhP86TiGO8h2C6ScgWeSJ55Jqb893P2sZBg41AzGojd17jx
	tz7/X9e089L+4u3Gn46egTctk3rvo1yuG+suLtCZVZ/Lae0pxIMebiGOSJTLojdKRJY=
X-Gm-Gg: ATEYQzwzLC+QOhomF3AVSfPlG+jvA6Ff2Gze2vl00/Hs+l4hEW3LNB6GFwp4NqnIFVM
	N+vauJpvFawnCBbLMz8iLLLEs1D1SW+JCToAaEqH55Xp5NnUYoQuZWWV1YpYyvau5utd5pLsWGP
	7fckTNVlBcJsGr6O4PFTbAu+5Dk1fq0P5faQQIGQRNxJrtXNcHBJp0PymDwltIBh/nMq2Acm/Od
	pO2nuMt7zrzF9JbHKGxHoAVCl4iX6d68SkHibVgJph5Mopu1UubsFgYBJVwWwYDXReJQT9btSxg
	ZG7nqpgT/YpX6jADCJwjDctcvWZhXhjB0shWJygqAxHoqT9GycxM/TwRk5gP7c1D8aYzf5mF0Qg
	u7Iek7zJMHPxwi2izqxuW6rIVOYZ8ZwJML8aHtamqo98dB+rWcjyMGmw182bSjIievUPZAWEslb
	XWav9opMs1QVycKIKJGJxOKQ==
X-Received: by 2002:ac8:7f13:0:b0:506:a320:e45b with SMTP id d75a77b69052e-50957e2317dmr165467931cf.39.1773674254573;
        Mon, 16 Mar 2026 08:17:34 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c49e4cda7sm36962386d6.24.2026.03.16.08.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 08:17:33 -0700 (PDT)
Date: Mon, 16 Mar 2026 11:17:32 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/zswap: add missing kunmap_local()
Message-ID: <abgfDB-6RDjTar1d@cmpxchg.org>
References: <20260316140122.339697-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316140122.339697-1-ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BC21E10000E
X-Stat-Signature: f8wypj79m66f1pmzdo9xzew3ypjkprn3
X-HE-Tag: 1773674255-129256
X-HE-Meta: U2FsdGVkX19Od1P1zbYO4GAVqPCRyU4yCQ4iMMGcMf3eRui3QKKP3zrEkHWanwsH+vFqIjXwYjqNo1O3kSLSgX9BMsesEaGxSwZRxf6WFH7FvivbiUwTCUNWt5sWA1QGk8rcefHIhsuTAMtewiV6awB8OmNL4M9UpElAhBuQQjTIIeaj0VCSaVLe4kzYHtRAIC43gGxsDJXb/beqqsxoBBVrhcQTWf6p92R1AKMKnOT7nkyOiQDSliy1LXxA5PCTTViz0D4+BSa+fm+Ba/0pgJhOHRhDTdVvAyGkcC6+HeRypu1sU5YqTGC5EOGtUujbWswWZRP13MtUEbTRvAXM6WaNJcB6Sx8Q6dy1m2erm/s0Gs9Wmr8jCnNwkim3wdhmE7ciNy1pMGljfNKPIzxh60bdVh9RTFvApbC+ucW1BPfG5HcafVg70CAA/vpDzzpfQli+elcxcqOUWzPOsDuw4gJqOHuc5lDoOv77+4/q4+HV3PK8PRrEG1VkGgqU81d4X35HCqJ0/jOHq02BWltMU1TgEfT0Jh4q+jdQucR9NH9Nbn6nt6FjEETZLzDYe0nUHvK3qVVzMsppiqL80axQka6T4jfmgT1VMSDZzla61KvCut8BHs6PP6IbCy3L/AV2tjOrT+/JB5rgNMOQKUXi91Giarl1BRQg0B/tVQUypfQh4CE0LBSX2vxnNTPFqQPBGckFFXYCSOOqrNdYDZpudV5/C0GB4i9X5VIT+DWuMqfeT/KNxc/k4ffCVy3alNib6RxrVmnYSJQ4lPn5uoZGPTFo58uUBXveCcl0sZ3TNuiOOYqEBC4ApR9R0iRVxEArbFZAPj709w0E1mxu772AF6k0KDFsRFK538z5gByf7hc4GKdgvZxxzNdlc6vOca+Ac7rGYplS6voqI50D1dV9Fgp6o9TkKItfSTsBcCWpTxTJMCLSxeow3d9uMDmHmzoZuxG8VGF7CvpkxGM3hon
 FEMPSgDA
 gBiLYFu004pflPuTXzQdfxd7FZxKyOXAZbIvUb4zA7+yZO2//hzBxb7IaUGwXjjORVdywaO/HBmgrUMVGhyHLHNIyWRO3GuTwdxUUHd0IioMnHltP0EKwkaDvYkjpd4fFoqRLi8+heMKNeLKklhqENByN450+0PjvXG0JWkcGSGmuy9GtttiBgK+qIGjnBR7AyKmCtxNpOzJE2XENoin5SxaKFfQLVahV7srWSwCT8tpw+3Emgz5QvwogLsbWutqn4r3zvCKKb/71T3cMSw/dTMxF6esdWLqpTpqjDtNei7+7G1ZCoInG+TGy7Yz3yv4kKhKPJxqLz0jP6iT5Ufeoxdzwr7bisVkr2lEOfta953dQ6vj/tDk0Xv+ZVGbpn8R0CXVzict5XG9CrXrzR6cOWeOLxzoArReA3xLQolcFyQmDHg5KS53t+cF51s3wkzs8b2m6ab3Q8tLVm+JNLix1N4cRUYvksvL/t9nV/p+fS53Em90md1InXyZHLgWhwVKIj871lWsiRg/rG3o65dwA3zCEwifAay346S3q/x2/engAt4HrfMfUMLNKK8xwpf0xSI3SPDjtpNXXNbo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 02:01:22PM +0000, Lorenzo Stoakes (Oracle) wrote:
> Commit e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from
> zsmalloc") updated zswap_decompress() to use the scatterwalk API to copy
> data for uncompressed pages.
> 
> In doing so, it mapped kernel memory locally for 32-bit kernels using
> kmap_local_folio(), however it never unmapped this memory.
> 
> This resulted in the linked syzbot report where a BUG_ON() is triggered due
> to leaking the kmap slot.
> 
> This patch fixes the issue by explicitly unmapping the established kmap.
> 
> Reported-by: syzbot+fe426bef95363177631d@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/69b75e2c.050a0220.12d28.015a.GAE@google.com
> Fixes: e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from zsmalloc")
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Oops!

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

