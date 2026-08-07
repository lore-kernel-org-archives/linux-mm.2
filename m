Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 980EAC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 16:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4496B0095; Fri,  7 Aug 2026 12:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CBFA6B0096; Fri,  7 Aug 2026 12:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE6E6B0098; Fri,  7 Aug 2026 12:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 543206B0095
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 12:54:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD248C012C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:54:32 +0000 (UTC)
X-FDA: 85075071984.11.0608832
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id BB0E4120004
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:54:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=iY9hrmuc;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786121670;
	b=PBWAbzhJeut96UZt8v6vJ0/GOPi4l9AzV4TR5vLLQ1/5lpVSqvvENgkAoMA7uHL6E7lG+Q
	SUxGr5cvFv0eq6fj4CRFL43wE2HHi6Zy7HvUwGi9o6rXW86dDaBaNM5e3jud3Z9Vjqltz8
	DUBcuuRl4P4GKEv18YvDvaAxT31jPbA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=iY9hrmuc;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786121670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zExJrbo0c/Zyd+w2UrTAK/Zs63L2W9uQFVbD7ZL++tg=;
	b=toQcFeQKa9TDK2j9wfRPnaKl9CtM6VwFQIyE7LqLmhLgNaR7wV37Obq6fWBwUaNeVew6s2
	+pZE6K12TA5+R9KkoiZRWLsfNv90X+niyIbVVzEnIcGQNyFm8en9RAreMZYSAAEb2n9uFf
	0zG43/+cL0Yaohqn2A6o4kgsNYbU3Ig=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8efb708b1a0so23766916d6.3
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 09:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786121670; x=1786726470; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zExJrbo0c/Zyd+w2UrTAK/Zs63L2W9uQFVbD7ZL++tg=;
        b=iY9hrmucPmgQH4vv3aOklNO+MkLSnxhLN5rM3qK/OKcBYVtHozrCuER8XfFPbZVqJn
         9RejftIMpoJA0nUcEGyBdXCXmchFARY4ssyQDmUI7qe/wY16ysIo+yp7Ii3DMzX+aJC4
         MNGyxmrdL/9E8QMDbMg7b7szTm60PPGOpt15xbOQ6pmNvNK5ZHC5TC3OvqjJoz6Rl8Au
         ZqZ/fJz7Ze3mdMnFXoP26k5f0lmLWHg/au6S5Ri1yRvGYII+D3nQclsQ38dezGdajpZR
         DQ/LBCqMa7E1//QY8XZG2l9KcZFU3ixevuGhWmu7Sb82cKsTUtJVqgSRwKYpJqs5pMW0
         l1Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121670; x=1786726470;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zExJrbo0c/Zyd+w2UrTAK/Zs63L2W9uQFVbD7ZL++tg=;
        b=XfFAJzLwUAShFe2G1AtQjeASvrmNJ3+IDkAhB8zZWzFldR2P8ezq9V7fs5vQoFkVjj
         6dcaO9c8xTaS/6idTNoSx8DfMaZ7krN/+U8P8ji+ALIWEJRlhKQPJR58qlbBVfvJ3p7r
         WqKGlcAGY+CwrWSnDnopDKLP1Xy0QP39kARKuK4fp4oonZ8NegDecRFreh4E5pvuSt7P
         ofAmMUTpiC9Z1dUoTT8tXuW2JFiDbcX9Bfqtfnnqh25rFjsn1CQUeh34C09/YJr0pssK
         gWhEpWD2IJjnNYLusi3ZrhWgbRWl0GzjElxme2F4WJJ/EO36u47egwcHxvU/BkwOp0Ke
         CE4A==
X-Forwarded-Encrypted: i=1; AHgh+RojDdfPgs16i2axHXECdsllaOlfCFoA58spTryHkKS6zMhZ9v5jLoTnk2Ap4IKCrtIuS+K2prZ7zQ==@kvack.org
X-Gm-Message-State: AOJu0YxMClNJP+6UpxeeWZvIv2/81encURjwmkRf7BWt++oICgpO5X5y
	5IlgAKXEdiTldJmDVO5jyeDjSUH/tUdYinDxRQYSYBlcOg9tgOTeYNC62KznM/JNzTY=
X-Gm-Gg: AR+sD10cZlELjmb2s3ylHP7G/To4cZZmcIxWPHNGKm0FLJVJ23jnwNi0JcL6rd0sCwi
	wWYYDPELZmy9C6IttPzUmy3r6VSxfpYWFmprUADdmH9xEgoIPKqHwcCLaq3L1LB/8MNZiF/Pb3q
	cYxBay+48LXnacJ/h0iK6tWVy26CDTBPbeLaJfQI2ttaIhPk56tYrADeAn6NHm+wxwx+QM0me6r
	zmSnqqXz0JmwubiQRAfhW+nOOT9PeLccHeAgC/RbbGaFptozXjG2LDIms2T+2/ulT0pp9DfOTPx
	Ql4vg4jTt3DFW4CggKKpAtN0en9uLVI4/Lt1UD4W8HtF2e5+VdYRhvczuvpPl8V4GEuVGsWKCqG
	WjId8wY0d8xpoX8jIgyyJk8OtLkEkmrYP44r4Bxm/Mvwkc0EJAEgQGRo45c2DLCdcmcekVZ0MsE
	MylN2j5TcMZwdVA7hS2SIjghGlP1XND5fKOb9RptrnHBlN5UY10IkvEU7aICY=
X-Received: by 2002:ad4:5c43:0:b0:8f0:9d9c:52c2 with SMTP id 6a1803df08f44-9088108de78mr290544216d6.5.1786121669865;
        Fri, 07 Aug 2026 09:54:29 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908a8eeea9dsm12940626d6.0.2026.08.07.09.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 09:54:28 -0700 (PDT)
Date: Fri, 7 Aug 2026 12:54:28 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>, Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] mm/page_io: refer to folios in swap_writeout()
 comments
Message-ID: <anYNxJu1J9aeBX-o@cmpxchg.org>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-5-0899bac3b826@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-b4-page_io-folios-v1-5-0899bac3b826@columbia.edu>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB0E4120004
X-Stat-Signature: b4kfaszxkuiate763s6tjksdwm9he4n1
X-Rspam-User: 
X-HE-Tag: 1786121670-214924
X-HE-Meta: U2FsdGVkX1/tcSNjRD10CG9rr/nBW0nB+GSCVuYB+kf0Bnnn2pS/YDRpDs3dcq32+96RcWfUxYfMaDMJI0PO8EGNeDBImag1njkhNBM/wbeNAFMWFmbvf9JPaNSGDVCmg7HnfBdCAvyHzttxK3Z1ME3WHiNmWB1Rd9zjcmSDRez+YQivNTJAaOYG5/PbmN0cPuihwXw3iy82OtQnfO7gUS0k6Gd295D6u1/L+Efggq+Bs/w/ps70eNydf1pk/nYU/0lZ5gHu266CklKFv5sye9iUD2rKFAQXu1FBUVH2R5HpAbDYjIQ+W5Sg0kzi/Ia+E9dzSPPSWm/jab8cITRoujuOXNZeKBasPu+R41tUNxqQeW8o/2xrgpsWUyOfb7nQgPPBH/QFMx3THKf3RHOj9iO4b27Y44Aans6ge0GcfhARgzGae4URs0Rg45Ia6sYq1aFP+OzfwJ5M2iDbo6SXfcUnyXYcd7ia7mv2lIThLT1Y8Y55KANxeYZZGfOWzQSnoyBT11rmML48JfQ9R6d/JCmm8ozd0F8AwamD+kfhHeOLxbtL671BQZfFDgexFDT2Z/1vpM+KemIHyrvvfoAdJ6qN4DHz1vx0SXU7opF8H/J7eAZSGIefXsXZ8qni8dCGfuHy/Z35V7QTHgR2TOrEU73e2+kILn5H/l52YarMBn54zSHX79eKX24cHJpZhFnD4R/a/rvIQcZeIysQFPnmsbOOOc2Oj5gvTSVd7tTR4Pbwlzx7znNOU40FT3oPykMNMWrn0/CWuP+xUhjMxj0ZbihZ252w6eiqGy411RkWIz5+3/+Lffr8f8TGn6TGiPDiqpUlu4c+7i1cu/zbe6lsZeG9nlcFT19glgX20CQYFVTQz/3jDVEUQzI4AIZNawj1G90y3U3/yQQMLaVCxPZbjV2jzxLLY4o81xlj/3aHIHeokKrKepXooCYGx2+SRchW1VL6j6RfDmPLDKr1+hZ
 kqOzqR+D
 6Aig+7rWzFTw35wy8ApbyacMa6RxgxkAEdEd3mss4HsQQbC9e8JgYWARa4qHmdJWCS+JYfrtkrb6/WXJIXsjCZyOJvem0jX6kPXdvz4k3UzSfJkHaFYsqBpcNXM7iuVzBGV9uV+JnyGsnbSeu7RWpo5EOUr1zOzWKMm6wCti4ZmOhNz3UUAVexObVXpOgXB3jkOiEP8KA1zPdeyJOY5CsWj5PDFaroSVeG6ibcSh1Vb5FDiGV0H/PeWgEvfoUoPufbPSzheQ9bQq78hGoZDVcIuUYowoXLVjMMcPyMzYeiuxO5k+O9okDAptE2GdWobFDeUL+7xo/4j97P1fCkcKDiv4muk/c0uzX2dvcLYilzQ5O73qiU0QLDtrvRNQoZWwWvtVLeHvrUpS7NN0rJJXinlq8vn5wJ4we5ZcJAuK58vPpAVzTbGQ3FHXQV1adqcR0LrnvpWbV/6p9uVijaItay2f7bkCPVA/v5zoSWPpf4VaX6hJzsMuH9ZQSBAdnrkwugcH1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 06:55:37PM -0400, Tal Zussman wrote:
> swap_writeout() operates on folios, not pages. Update its comments
> accordingly.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

