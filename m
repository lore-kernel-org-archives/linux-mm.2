Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5718FD45E2
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 19:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A11676B0088; Wed, 25 Feb 2026 14:31:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BF576B0089; Wed, 25 Feb 2026 14:31:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1456B008A; Wed, 25 Feb 2026 14:31:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 780966B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:31:34 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 07BB0BA0F7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:31:34 +0000 (UTC)
X-FDA: 84483973308.02.18B5F3A
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id B2DA018000D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:31:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gRQWu3tV;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772047891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q3Jxm9A3azjabtMJunPGxErvPjmUnEkcbOHkg5GFLOM=;
	b=Do+AV8VPwqUT+GcfR71QSznKJKooid9ichZTuEYYdaiZ0xBzo9m1VJIhBekXK8KErPfaAy
	62oyPj//23ryCtHOtYqFYc1PMd9b5tP4jpKa3aW47BF/7MxpjcfvGi9mIHLMSLDfiJJ9hK
	ZfQ7AmPmmVCNg/qm4eAqp+DtyH8jPeY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gRQWu3tV;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772047891; a=rsa-sha256;
	cv=none;
	b=iLUxyFgUbuhDo8wGnD+vh2gEE9Ckdu0xYVp2m7PhPXeVM9uk7Rl/VqHeFEqQuHANvBwXBm
	R5PRjEtoFjKQAexQ+5E0+T9M3PfR9YlRS7sone2rJcRsLcNuzistjkzh42pCKodNdCnmKr
	JphWn44XjCNiB0tZ+44GqRxUWt+5BP8=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-897002b7576so1097156d6.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772047890; x=1772652690; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q3Jxm9A3azjabtMJunPGxErvPjmUnEkcbOHkg5GFLOM=;
        b=gRQWu3tVNGwyGcu3VGn4rkhIQB+aQr8X1RgoE6P6Y/BEpUD2zUDIz+/aF4JhRdt9mv
         6zwn9EI8OJyBBqlDfPN0hD34gsxf5Q6SUM2gixv9fCgoTXNAfJcoFi3cHsujM2CZHuyP
         rSKHn1w4s/IpNPoA2fOypwbF9qCnB/aonR+H+MzXdt4LUEKk19kkvLTRJZP0KXLnpya6
         UjGUYcSbqe2/YQGAh7asxrPMxaqLlsN6ZWoXnScLiqekj+d9/NyizD3mqidS3D9Gxkvn
         FOIUPb0rYL0wz06mrD4RTvemKFSrCQrWNzHGrbfle8m+/Ow/0Cvw6+tKlqrldlgcrU+q
         WWkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772047890; x=1772652690;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q3Jxm9A3azjabtMJunPGxErvPjmUnEkcbOHkg5GFLOM=;
        b=G/O9ukBpqYBb/I4xu9KfFp5302BJF69YxVhvaRQvko/Dg8+O6gcB8cjjt+G/VDJb0N
         eNZcn1fyR7ONqpfGnCy+BD03wuWHWxPv8YP2gjwAcAlh3lvt7abHJGY+F1+7Ns92JLnV
         yOdSRteqhqOxcmK0pteNkItj9p67Gi6DI7Txp2WO+aWPdTCHC0fkbK/jJfoRlP71c3Lb
         uP4KqskxKjdHUMCUd7lg7mPkr8JAwvlwe4Y6pvMLQq8SY6Uj+9USgwDWS/lZ+JRhS5LD
         9tnhpliMV/ba+EnHVwFySPXmgG1KiSzQ35KSdtpQiZ9zFwMpphuIcJjUDC9sLfQ+Zy1q
         sVcg==
X-Forwarded-Encrypted: i=1; AJvYcCXGccGLN0ThF0a5gDTWDWJgzS1OlDD5r9pj2nFxdj/p31PWt8va5qK/5PvfQAzGI/S9yqe2H+Dlng==@kvack.org
X-Gm-Message-State: AOJu0YzFvyx2+ktRKQRiZPWfhUK0NLZUV7+8q4wIMdlzb6deIpbfU9nB
	rGkRgeKs801Xh/1aAyaTGhYkodGvdoQcHgmIerBmKn/xtHuUxPr68nHUvIuzFDHnmQM=
X-Gm-Gg: ATEYQzxYObpWXYD+rLslok6B+lZHymD2k4mBgm/mZ96Ee6ww5T2X6wMhz4I5D2BOxIt
	Fuz8OMGFQ3wfJX/LV+u6LAElYopMZeQpUrKlDDv+7s2iWvC49Z1Eyav//UcUeYt8fyrZRgZv5Dk
	0gmPw4lF9CD1MKNlOX5VzuFKgGEwR6bbzXtQESTrWDVOSVRYV4vMg5PgBY+bbl0L2hsv49hRtU3
	ReqZml5pto7mVyRe8KVJsmXAiHUL8tMNfCUYPyBaUU4RwjW4V9RhAB/NqwwVP7PltH+dY0do3k4
	H/vGHWzWGPqEvco93mopdl8E82o71shCPztcFNryOz58LNkyo+8ebFDFfUxCm87nm6BEvjKI2n7
	Wqr+FQoW7dlFUmjS/S4JVqWvfOI9mddab9cTGP8hYr+3nodpeD6NKu28mtTFzr7b9SOl2kkSwhO
	gL62n7VyEpHn1DWON756lhNXmbazf5NnxF
X-Received: by 2002:a05:6214:768:b0:896:fb96:e13c with SMTP id 6a1803df08f44-89979d91197mr276698026d6.57.1772047889659;
        Wed, 25 Feb 2026 11:31:29 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf659210sm6749685a.8.2026.02.25.11.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 11:31:29 -0800 (PST)
Date: Wed, 25 Feb 2026 14:31:28 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "ptdesc: remove references to folios from
 __pagetable_ctor() and pagetable_dtor()"
Message-ID: <aZ9OEAzENzeFYDB2@cmpxchg.org>
References: <20260225002434.2953895-1-axelrasmussen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225002434.2953895-1-axelrasmussen@google.com>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: B2DA018000D
X-Stat-Signature: w7sgdnjug3yyf47rhiyymgx8776kgoma
X-HE-Tag: 1772047890-908466
X-HE-Meta: U2FsdGVkX18KcVZRTpn66YyegsAnHOZmVTxL9geKD93u7/8Mj+YWyE8Nxget/CuXXcvP1pQixImDXa6B1LIp6qW0qCG9hUb2HCE6+RD4Gh/vOuLtcmubs+9/MxJ2ivFD/HsxtgfTJxnGSD55Xddpbt2OohIRwgC4xNCODk1JXtltwKeeEvUPyGe6feVLocX7cwLhCyI+LXs31W+1ipvdOS3rfDw6lIIoeyC9V7n4Lit4CscM41ih65slWmZNyN51iuEYlmM2Wf18WpjGp2pqqPdT6cOcmUdog6xUyui7O6RJR55HrHZwc6GNGbUncaPHUzfFEMtxEe5jnpqsmp2+Tki2Gu1Y2o0fYBJHs8u7TP7fOsrmY9Kb8gZ+tbgIb8NL6tFgPWFTyjlkDnVTrCCk4FRo1JDu/mJfiiBeRUMK/cbp4uQoqsv12Xb7I2+SMpUVuZVXklYMHd5ioGTjlh+7TOH+GyMI+GttdlIesflLJFrX6jnouxH/EULQ0d0S2v4QvNysz8wdPKjwK7M/Zo/POQ+DiyG1cAOcM+ZdGNAfjsnEr5FPgr5Wk6yZMp0Lp7GN3/y0jrsOPKZOn+DaSkQQorDDR42dsln1QKIlLRMq4Pw6XRkWJVBJAz1qfzBMVY65eGw+fKLc5PHpJUNf/ZeIJkrfKEv/OaAy/maVTrVZNUq7LUjz+1zVsP6+Kh9LfpfP5yS4oknPDIoyv3KF9odPwH31XX6goKLOUIIGwFFrve/VnMzchjdT28QHZczqLkeQ+otgSGCS6KIqulld6DANw6MH4Y4KMuPt1O6X2tnrrZNfbaZyf2oqrKKpMWuhT1RLhx4OwsWAzr7yKF7fW94rPvFRw5gOdxJU5NNxqxL2zCPPCheZGZO+JPPdfy3ib6C5nx3/EuewRYpte8BS2tduIb2AV35hNBvfpLa2yC0WvcQQGJ6WHnGSiPwqpR2G1zAB1VOu5Cqdx4AI8IEfoTd
 lEwrwSdL
 Z+gvE+a6h+rLxIcPrihVGWUsIv9yC1pEIbqv5UXJZo6S+nx6/pJ2OYFi84xnoOSeujEiO+FK2Cr0VL+daGwLdaEf/iycPFwq0tSuYqPn5bjxS7DfcOiOkWiSBDhUv7U6UI3DQhcmFgDYt/tmqYADFdUmByW1gT8ODWkOX/C4UXMQE0iFUB/DzCwMKlzod9L51U3K679Fl23v1hiA8nNDEycINid8QksC8Ob3z257m6jtIqMBGjR6BjEJdu0y3UDVecy0pXAmh+OKW0YlSfVV9pfLQPdqpYISb+4M0KZfo2Gf7lb4/Lu9//reSLFmQtVPC4VYuEID/x2WiveMdsl/gFiXA86NOZzK2ZmBBP/2HxKgwRG4Pb1HHEoUWOtocoHj3rpD+g70TH8k6VbNw8TdnQxoPHdM0CTYUKeNPFUWgojfhukdtGRsAcbwr9z4o9vqtJk4HYb+wJFK405W+qkytdnlcEV6YTGTZ1zOE6T5QOLhrgcWIeMzV/gyBZhsaqLz7x+CtyY+CKn9OTonEIpwAs83qbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 04:24:34PM -0800, Axel Rasmussen wrote:
> This change swapped out mod_node_page_state for lruvec_stat_add_folio.
> But, these two APIs are not interchangeable: the lruvec version also
> increments memcg stats, in addition to "global" pgdat stats.
> 
> So after this change, the "pagetables" memcg stat in memory.stat always
> yields "0", which is a userspace visible regression.
> 
> I tried to look for a refactor where we add a variant of
> lruvec_stat_mod_folio which takes a pgdat and a memcg instead of a
> folio, to try to adhere to the spirit of the original patch. But at the
> end of the day this just means we have to call
> folio_memcg(ptdesc_folio(ptdesc)) anyway, which doesn't really
> accomplish much.
> 
> This regression is visible in master as well as 6.18 stable, so CC
> stable too.
> 
> Fixes: f0c92726e89f ("ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Willy's cleanup proposal looks good to me too, but this is more
straight forward to backport to stable.

