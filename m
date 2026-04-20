Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A352F588C1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AB4C6B0005; Mon, 20 Apr 2026 08:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082406B0088; Mon, 20 Apr 2026 08:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F01736B0089; Mon, 20 Apr 2026 08:17:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E04416B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:17:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AEE361409C2
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:17:13 +0000 (UTC)
X-FDA: 84678833946.10.9391120
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id B052E100012
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:17:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nsk22ECw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776687431; a=rsa-sha256;
	cv=none;
	b=x8eWb30gVjWR/GvDLarPlVxSl22jXKCGgERO6iy872jrd4wLJjNlR7rXg8w28YAr5dm6m4
	SUZaYYKJDXzHW2kgB09wg1rmDDRcQq8kcWqRmMiqtktdEz99hLtZ/dNpdjx4KrSVkIge63
	mTUnOF26qEPweXxy8BzApbZL8gXTQco=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nsk22ECw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776687431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=drkslkYKwh8bl2BohU7oUu2nJDGY7lLZqg96VgbKXeA=;
	b=6oSoORkuomhKF8aCI/ectGHPck/XgYDIF7KaqcGGyvB84ZrbfzqwoF91ckO7ys2sufcOl3
	31nddPST2ogj5W+EmTZAqwGNEKJHg0aQYimZWjvbhOSBr1RtcYoGZtq3q+G/WaLj4uhLC2
	cYoO/yJegnbb4ZqNYOVewbZ6XARS+Z0=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5a402dea4a5so3374602e87.2
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776687430; x=1777292230; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=drkslkYKwh8bl2BohU7oUu2nJDGY7lLZqg96VgbKXeA=;
        b=nsk22ECwURtcLiIz2l2+p5r5ag0qhApuxh73oa8LTt1sFipLkLIDbUhe7WU6MNwV5I
         T795SetTCajPqQi+OI4Tzeuu+0funchBQ5EDC7W28bOPsIGgpp9xSg0NU1Igf65DpbkN
         B+1baN7n3mVqE8woiqczzgyv5lgROD3zMCr7SlD29jZRgWihbcLo78/Go5ATqmCF8uwv
         15lmsGOSkLglxCPi8jPVf4oTT/O4BbBjZXKa2TUK/wfFllee7P1HftUhFqcC8myF1qUo
         GTnG5GlyMgZt38Icu1joNYdnJt/joyU+gUcLWUC8J3Ux+/Q2uAUaR+hqFRbVAaB0Yqub
         Zviw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776687430; x=1777292230;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=drkslkYKwh8bl2BohU7oUu2nJDGY7lLZqg96VgbKXeA=;
        b=T+vhXgCt7Cmeb/k/ywc7oAzc3ZrcLo3Cl355XiMdUWg9+6Y5CMJ9urWfX0Yqg+hjq5
         JG1Qk5J+iBrjXZUlzuRTwJXdNGCUC3/+0tqW3Ozjcks/PmeTbqd9YqM76/eDz8C4mM60
         BBGU7wuznmJMFLWy/1RktXcml5h97F/ZEqmFJky8yngUhEf3Ho5/EXmKbNWQ2CBe96Yv
         aZ9RQ16HFdOlw5w2ZvWc6miOlFhVBa1ilP7HN/w4krbuQSQqeI2UWcBK0/EdSYNUjYdT
         QipoIveo9ZbzQK6xm6Y02Z8xSR6w5PMsm82qeuDSDEcqoq5JrxYhbz4xSFhDhTfI53pS
         VH1w==
X-Forwarded-Encrypted: i=1; AFNElJ8K8VDkDMUDYgxQh56qpBFO6TdU91axcppCV39tpMmf/tC2KiMhU5SETD8hDWX2GGUJ0CTiIiZC6A==@kvack.org
X-Gm-Message-State: AOJu0YwFjdIiU2Vfl8A6z0ELh66LjpF2QEp8AshSwQTchNEuq3rDTuCu
	3EQo3bGWiwucOkyG6rYsuh97JhUYf21nR70oqT/WbdkktQfB1BftT/Fb
X-Gm-Gg: AeBDieswEeaEjZ5pubQJuNatL1G+WS8sicC3Fauxsjf/oPYyW6Yw8DTB9BVMGR9Q4gy
	zAS/ofPqWoU5szVmH1/JO9a0EjZqW96IXfAeDWHDQ2xL0Q5x6AQhGDhK6OOtwwo7dIu6Rpcqzp4
	9ITH4TZD9YymiwlsCoYv9kr7F9F4CwmGbpRQsk01qUHIMfHT5vTvJR1AN+N5i5BlyDZVYOWRisb
	oTZR2CFu8Dt6uqD7kR5jsmnBOLrkIU/m/bDU6D/MN9JIycaGat+H99A7LEwRVToWm+og1/UM64/
	a8FCFwZo/Ueiz83IDRX7J5RT6UfyicGNI58bfldGYkJCiu3R+VVCh7ObWEVmeGB7Kk/VvQYlkex
	oOkwQrjUUQwrG4hhifUigOWpwZjr7/9En37pTO4K9jv/U+4YTut6dS+bqtWj1q89POlKPm3Gh2Z
	c=
X-Received: by 2002:a05:6512:a8b:b0:5a2:c289:3337 with SMTP id 2adb3069b0e04-5a4172fabccmr4256296e87.42.1776687429463;
        Mon, 20 Apr 2026 05:17:09 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a4185ad2f4sm2965771e87.17.2026.04.20.05.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:17:09 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 20 Apr 2026 14:17:07 +0200
To: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	Vitaly Wool <vitaly.wool@konsulko.se>, stable@vger.kernel.org,
	"Harry Yoo (Oracle)" <harry@kernel.org>
Subject: Re: [PATCH] vmalloc: fix buffer overflow in vrealloc_node_align()
Message-ID: <aeYZQ501gs_OLR8H@milan>
References: <20260420114805.3572606-2-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420114805.3572606-2-elver@google.com>
X-Rspamd-Server: rspam10
X-Stat-Signature: d89r8fzqerk6o4wzs7gxxnsa5yp69a3d
X-Rspam-User: 
X-Rspamd-Queue-Id: B052E100012
X-HE-Tag: 1776687431-759091
X-HE-Meta: U2FsdGVkX1/M3ypR77KmlLvdD/fPFdC/V1QiNW2Qflo5FFvpqpRl7NwjLG0BCpdnhLeY078kcBiAggXEq8wIzzhBt9CTnzYPA/3ohhQA+iQaUJrEW1/xAxoB9yapM15f80YBFbqQlByE1AlNpBSL8zsVYNRVhFJAD+0ePPcNywmDo3vhgPacJJAq8EyMA1VyvP/c1mc0B0NlWZARfLBq/xMWLEzluk6IHrPL/C1iE3/DMOc9oEKlEfNuZR6qUvnX0+7Oi7QrKerrN5Zlw/NFAIlAkaVi2mjGAmEsG7pbyzumk6N43NfKTuXd2y/MV5CZXZluHOowBDrMV9kM299WKUgSRysKTnwYBuQqAB0dqQBZYD2rtg2B7FWOLXEEZfriil4CPzDv0cP7UISkB+Kxx0s1wP4acZKW7tPWc51YbI34ZIgd/kvXRqFLtzL3WGZXLzPbAdF/wX+W8TrRLi87AVygitW1kJezVkIyIlOsjlFCMxVn+tE4o9zbs4r8iF3CpBiI5B9mtaoX0yvhCurUICFq1W0NdAf2WSM/z5IykM1Opg5xF4HpmyfSNtg1rIgKGNxorkLdoGFxUKD3ifcgxyPA1Lpy2eYh2HGjL4fI9FAn2n1/aVpMi+cmLJyOhrQ5b4dDHNI4HmTutPktY8mcwMm0LvEtAyPvvH2pdhJI7om4QVp1lwXLmwpPNPPCKRokDKUN071eH2lXvaUdkfEdoTD4WfEYwimR9WwBFy1vzWK97B8Rm7mf0BrGLgqw3nGzcHPpZHYQTV39tInjH0EIQoNzl9vRwNZTKy25G+oXpZDn0VD3Lq96D3HNlGTXSBl2V/aF5VRC6C4LERibelRzlWENv+G3h3Dk/MZFC9y6TlYVd1w3tblv3aPqzntThD+SThLlMd5Jj2eg41yq0W9Dk6Mb7s6gKZU2FLHHgTFs1c4AcbTaxAEHmSFUYILphqjuwpZu7ecw3jU3ZVS03Jt
 V13cI71Q
 sYKeruuPUGzmi9eSQacCx4WOhXVQFFxqQfEvCMuF6flPNH7LvI/VGNZcCfzqls2Wn2xTvwvO4Un+tgpfBo+QIRZr0tAJGiVlq2KOmDQnGgPnOiVE8wpYg9uQSEVN/pygmJbdLnGieby82RaQkoVRxYRR5cJJ5cgo9l8aGY84EwbqVgMWs/VhApkgLuZk2YajRShELiq8KkqFFDjR9Yst1OqA6CfeTvxk8L1QQ8jAcxzCU5T8sHsASzIrZleipLl6jRw61gR6AHuGo7wFVNVtzkpCXyTNMuw9wQxOjItNi7WwdRNaMzKnWfJ9u3RcfmQ0GOOHbdwMeitRrIToXN8qRXHSm6vio53eQU8Ad99HW04+psQMbzj/HRo1KeMc0ZA7M0D+tgde9RV2xNKb3CK/VJs3APCp6uMLgcw861jaI0nq+j7E2AFBCJ5iSQXKaYDa7Uff7+/dLRm8YJHdL1VBIow1CXkIhkjsAZ2FzmgfhOwo6gqA83jMKeNb5GcixIWvmOGJLhfU/dYxOBXw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 01:47:26PM +0200, Marco Elver wrote:
> Commit 4c5d3365882d ("mm/vmalloc: allow to set node and align in
> vrealloc") added the ability to force a new allocation if the current
> pointer is on the wrong NUMA node, or if an alignment constraint is not
> met, even if the user is shrinking the allocation.
> 
> On this path (need_realloc), the code allocates a new object of 'size'
> bytes and then memcpy()s 'old_size' bytes into it. If the request is to
> shrink the object (size < old_size), this results in an out-of-bounds
> write on the new buffer.
> 
> Fix this by bounding the copy length by the new allocation size.
> 
> Fixes: 4c5d3365882d ("mm/vmalloc: allow to set node and align in vrealloc")
> Cc: <stable@vger.kernel.org>
> Reported-by: Harry Yoo (Oracle) <harry@kernel.org>
> Signed-off-by: Marco Elver <elver@google.com>
> ---
>  mm/vmalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 61caa55a4402..8b1124158f54 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4361,7 +4361,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  		return NULL;
>  
>  	if (p) {
> -		memcpy(n, p, old_size);
> +		memcpy(n, p, min(size, old_size));
>  		vfree(p);
>  	}
>  
> -- 
> 2.54.0.rc1.513.gad8abe7a5a-goog
>
Agree with a problem described in commit message:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

Thank you for fixing it!

--
Uladzislau Rezki

