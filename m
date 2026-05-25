Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E4FACD4F54
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 02:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67A936B0093; Sun, 24 May 2026 22:18:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652786B0095; Sun, 24 May 2026 22:18:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5683C6B0096; Sun, 24 May 2026 22:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43A246B0093
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:18:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 11E8940D31
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:18:17 +0000 (UTC)
X-FDA: 84804332634.28.39E1567
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3AFA4C0002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:18:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="XZ8GPKz/";
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779675495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLBQ3pVE972YUzDp3Xl4nLs2lFPadjyIs40uEfoMObU=;
	b=P8Or/PI/7+K4H+JZQMNhPby/jIIFd1vj67xQq8yBaOaOdueSn+CAZ5bh5+k6pLWedF7SAQ
	vumD1OgsWybve2g/OP0EkCY22eA1CLie4odP849Ix9hFDHMdYyQjuFQQNCoGZuwofK9opT
	DPYAOT54qrM4I+HZuUDmrwyKHhNcI2g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="XZ8GPKz/";
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779675495; a=rsa-sha256;
	cv=none;
	b=o/0hD0fZ8dNckRPtkZetMe9zCtECBCC/UDrU4A0KasuOQdhLaYN1ESNKOOxZ3xcuUZb/zh
	bqIMnusHODqhRAn7LlAyTfY+08XAOK6vRGE193pgy5xc+O8doMnV9300UgmgcH5x78HtIh
	YFnawT44w+uTLpCKb35MDtc4VWgwMck=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8cc715824a0so26060896d6.3
        for <linux-mm@kvack.org>; Sun, 24 May 2026 19:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1779675494; x=1780280294; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VLBQ3pVE972YUzDp3Xl4nLs2lFPadjyIs40uEfoMObU=;
        b=XZ8GPKz/wbTLAWKWQqTy06cGXRcc7C0DdfFxVReJWVZ92NxmB22vvzv05/wZKnU+mX
         QrNoZcf6JsVvyvyLIgaOSBPlIssxQRTayqmoTQxzXvyN0TCPs2L5/oSRYZTtUQzsLdcP
         3irlrUKVYsfkH4ZMTBgN13Inb82ZHnbjDivhTmxEK2uSrCUetEomCyMkJqt/QHkA2WLV
         sb3KH/gviPS055EPTctkPYWHJkMMMlZQv+pTAuPy7263Ihtd36rhHx0r750/toXnAlwB
         oHul1vw2cUP9G0yES+keBHeKnqHZZMbksOyEaBLg1RpaPe9jWSCOMRfCCdKMkIV8FI/V
         0f3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779675494; x=1780280294;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VLBQ3pVE972YUzDp3Xl4nLs2lFPadjyIs40uEfoMObU=;
        b=MCr8wI7rprjQuGwuZgZSUdRKhO2BFqoq+PAo1G9eJzHVFL4F3aPjfqzqkq5kQKXSQw
         lY44FhOH83oob1qH1F1sUPJWf6PDXPdL74TpgsyW86YXhetDEfHNltCQ+rsKGcp2aH6d
         NwIzhE68SywRpEnsJVLBs4QCbG15ubYVPidjWm+pygg6Qvk8OnWJ7b9CAaiZb/rdhzdw
         OS4FJHJkaFe4JGm+IHyemS9Bk0cYvbFCkAQjLuw6ICMD9GrYLLTFz5i4RZ3GJiuSxUZ7
         DvUKKChYd64SPnAtlMOqKCehjRXAG+EizVcgy7ae3wQXZy4uAgURP4zTg1hyLISXzwgZ
         KluQ==
X-Forwarded-Encrypted: i=1; AFNElJ+XH/gO4LUeRVcYz0xeJdPhGuVbBpiI2EoxC3ZHC354NDuOAmmSHTxaQcSUWOSrGCsh9zyClHaa+A==@kvack.org
X-Gm-Message-State: AOJu0YxkjxQCCjDXL+6iBVVb70ei4RdJiAtHVDUHnoghoaU6UqxppJHu
	A/akkaOCa9f7VeQUIOMqDVJc3afnlV/uL58ZaC5X4guTD0VdPE8cTcgN0bOH52f4YNk=
X-Gm-Gg: Acq92OHudKtu77/4RFc+fPeV5FYcMhXLKkZbkkAhVGbWF+istYucziF4vaGOe+ocnV0
	f7h2rq6cFxS89cGQ6RMShbtxKYb2W3rHRHdmg/CDw2Wfp8hv1OZsuGOUNqV4PZHS1AMESie4aRY
	Gztk76Tz5jyzdJgfOhDRFiWdSusf6v3YPTjEYmkpQ/bQ10HpFVm3npRTLieau8dVCBG7e+xtjO9
	GWS5Ys0yO3qT3c+LHJSEwTq1zwDC+0UBNOVmQaM6lHSTYFtte5KvgbjX/dhjnjCXwlDhUGWCar2
	XzDk/WvYTXWRaTvRiaynpwL/m0KyKlyInJWaw1q0HCwSICPV/SpdKW8jwwArO9qKyfQx5lUZvig
	fMtweHWY9Jg7UXIX6iIzwJs6s82b3roefij6mufOn/CRhQiElbgWEdkYwVkRT6f2D5whPDvakES
	mQAa4He6589MBQj+qOWODmERr7JBNIK30VZMnal5OkFJ5ViCC3GgaivsUTAxtoCJD3Mswxx0vZb
	+CCtviMSWZQjeAABQsbro4=
X-Received: by 2002:a05:6214:3d97:b0:8a4:21d9:bbf2 with SMTP id 6a1803df08f44-8cc7b5c53f5mr195484376d6.33.1779675494374;
        Sun, 24 May 2026 19:18:14 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc80ded51esm100028546d6.17.2026.05.24.19.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 19:18:13 -0700 (PDT)
Date: Sun, 24 May 2026 22:18:12 -0400
From: Gregory Price <gourry@gourry.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
	Jann Horn <jannh@google.com>, Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm/mempolicy: kernel_migrate_pages: simplify the
 usage of put_task_struct()
Message-ID: <ahOxZDJdihsmJpEp@gourry-fedora-PF4VCD3F>
References: <ahMt6xyUNnacZU8-@redhat.com>
 <ahMuF6FC6TIOZ-iZ@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahMuF6FC6TIOZ-iZ@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3AFA4C0002
X-Stat-Signature: ufdh5ag6h7fgr6g3um8kijxmqai4kfdc
X-HE-Tag: 1779675495-376218
X-HE-Meta: U2FsdGVkX19Z8Esoem7S8oWYaf7vlQbb0rvkRnM16eMTa0SGsgQXUv5t6Z4baNPTzj92l1iL6bmIjgtxUUuzL0GExaveSZNpXbSr487p4cRTDu66Uf0tQIaPhTE0imggh30CQdy+WF0fH/V4b1kvqevfWgck7oBkuxEQ0Ji00ZHU89jHcUbbULi3rVtwAxOBS3UtwzUW4z6IPsOBpRkdzCJV2laZawjOVzodMfuj+tLVvCon6twViOyXkiRJSDv2dTERn1LPZjxR1y7AyxTRusqp34Gz1nBgTSGxDOOo0voDdy0iN7sp0dtQtde3dzI/GhmSjxPdMuejH3nVYv3or7rbmRF/m1FBymlbTU3xIRiuLAzaOdcX8V4vrJ3APZji1kLWdIzic5U7iQJCAcVfRqWCThzRIh4BBzpIo6Hcf5AKYI0Z9jneFlY+DETgwPmiAep99Q5aO+BiAm4DxEI+yH+LOH6VEPywtJIALhTmLPWnr+n5R6iIw+JNQpdSCl6V77sSuFehW8IHB6o8jvBcNDiZSAxkb7CwZJt7FQi+uWXGDYRNz1T5R6ftNGgHnuMfeqcLtH+w8v+4SM3fZqHj2MG/7wtdsmOQUNjA2JX/JQJ0tjUzjom97unuLFHjC2onw4/bFzStWFRBHfWs1ZlFj62g6/C0WR5YEW1YoyqhnJRftcwoHyDvTFH1OSmEiLt8oj5PApXX+LjP6B37tanFK6rk6DV+hBTWPNR5LhC+vFRD0ztkK3OAcmxAmbsBBiE/Bw+yJ3cix7tVGLp2GZjR1lgSgOY+or4EWXxGwVSHO1eRkKEpbEDj4mVgO+6gR8QZDfeGEFQ701fHbxZdUwIeoH3L+CyLgNYlVMKeIWc5vlq6rnYvPoh45TA4SQka2wB4Z/LeEFNhoIqKIXt9jDJwYuieuZdKWS/HQL/yR9QF7AfKFBKeBlauqwg2s7LD8nDz/LdLOwNUQvxxdmASHQz
 lCxVU79x
 /HEYlhEbi+3hJtOHpHG9EVO6wgvgCdsW8F42mzH+HcGtTQZZwkN9IZLCeFwyGzfOodPGnRi0bq7iMxBzJQB9KEKA6KM37fOZ9TScm/KmTipYtOfbVy8Y/UK51air+34SS/sOKCqEUHJyai9F1bX/wccf3Hx8m/aN1y1e4rjCx3t7tIWMvc/oq0Q1JY5spoeqMYkETgfuj149y+rhpyfbt6nkiCJ5u8KRC8ln9p+Lo7l9h/mzMYSuM/V8ykd/b+elFrcRPwWpXyVGDTPTe5naGysAdZhCxgK5trsU4QERuONBBtb7NEMdr/JO0ViOWs7+ltMtO1FXrTUwIN9qzGVQODdvMsyljRlmo01rmYn/S4fi58nl9LpYVSLRSDMZYTJeYAAaYbWSdMwxAjmbkfTZmTf89Gv3lzWnfuplHlNzOfQDPRMsuMQoU5u7BfBxj9fKqZ36h9WSmgkS8RXLD6fdKyG0Lf6sG6ZqwKCugnW237Rmk+NfsDnq6wi7vGxjmh9GLPQgYdNfH4q6mAE+hnYQH+nozn29uSo5MZT1J4qotS37W9L+kCdp4pd3BNDKQEXZWwJRIrS4QG3U7Yxiagm3Ju2Y7Q2FIAxg+PXCUf/z0+SbF6Ik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 24, 2026 at 06:57:59PM +0200, Oleg Nesterov wrote:
> kernel_migrate_pages() calls put_task_struct() twice; this complicates the
> code. Move put_task_struct() to the unified exit path. This also allows us
> to move the "out_put" label up and avoid another goto.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Gregory Price <gourry@gourry.net>

> ---
>  mm/mempolicy.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 4e4421b22b59..4326dff16aa6 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1922,25 +1922,20 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
>  		goto out_put;
>  
>  	mm = get_task_mm(task);
> -	put_task_struct(task);
> -
>  	if (!mm) {
>  		err = -EINVAL;
> -		goto out;
> +		goto out_put;
>  	}
>  
>  	err = do_migrate_pages(mm, old, new,
>  		capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
>  
>  	mmput(mm);
> +out_put:
> +	put_task_struct(task);
>  out:
>  	NODEMASK_SCRATCH_FREE(scratch);
> -
>  	return err;
> -
> -out_put:
> -	put_task_struct(task);
> -	goto out;
>  }
>  
>  SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
> -- 
> 2.52.0
> 

