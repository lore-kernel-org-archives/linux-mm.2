Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0535606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=Ns37zGuW
Received: by kanga.kvack.org (Postfix)
	id 152806B0603; Tue, 17 Nov 2026 21:25:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12B356B0604; Tue, 17 Nov 2026 21:25:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 040116B0605; Tue, 17 Nov 2026 21:25:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7B606B0603
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:25:23 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3AB48A7FF7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:25:23 +0000 (UTC)
X-FDA: 85446648126.12.2743B72
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf25.hostedemail.com (Postfix) with ESMTP id 620FEA0006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:25:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Ns37zGuW;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k08219NPaAzfFl1HhQIM7zNHjNoNeWmKDuXHg52dSl4=;
	b=Tcft6PZBJ4s8WzVpDnmzDJ/0UO0lWiksf5J0JJuHbBFglCeDZ+LWLjuuftrYEq6zkXNFIG
	Ufyor6AJ9cz2ySIvhe8BEvlpSu16Ti8Ya2uvlvoDIdoqQJRCE0wKqlSopNcnTTAA7kU8NB
	9OqtL10DFeN7lRk8VfbKfZRIsaaN8us=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Ns37zGuW;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968721;
	b=AmoaxvZdf6OczEZgAc2Eo7AvOpuqFbZnHBaZ+HG9LuBvma3a6b4p46DSvNrjL/ea8gpA9Y
	4RnIL5LVkNDIo/rpT89ipbQAeY/nUT5C0AqOAsjmITAdDk3/oMkO3hF4+YPR2GWRd1aPKu
	pIL65ghgwGfOxsiCqjOt0Sj5Jk5g9v0=
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-14394530ec6so790661c88.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794968720; x=1795573520; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k08219NPaAzfFl1HhQIM7zNHjNoNeWmKDuXHg52dSl4=;
        b=Ns37zGuWVYilmWcvBUHfqskLMjVYfnFWXzfutG3PAT6FfqTpC8nNTKxoa73MMXPFw1
         VIyZcG1XBl8yCnd1tB6bgg2NnoxANeS31d6kVdPWLJ6cu1LHElSc7PB9J95Sp+tgTepU
         MCHX+HF4G/YR7joNN6DUDnnDA8N80fgQYfjLk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794968720; x=1795573520;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k08219NPaAzfFl1HhQIM7zNHjNoNeWmKDuXHg52dSl4=;
        b=i1UsZyh+kCZc7Hix+j6y/zDy0BQHTMCqax0zEhBxP7eOk+5KjLvRp6NPW4onfvbQAn
         j8meQDblkUU1Uj+ouTXoMvcg1DtfEGDMsB6/v4FLmDEQV0pEQHYErWptZqnUDICxyuPx
         WD5SxZOphKeapzUXZHzeRStSeE5C5DE4mU9vjeezw2vsBN/c57bXJ2EmRL+rI6eU4Svh
         kUog2hMF5pqg8/Ml1hEBvmifNjSaGeAcVQJiPQBPoQEe6uIzzq2FkQGkTNbe85kcNGWu
         mJy62NSoYx1RmYqSz4j+ReObEWSlyr5Lm5NYzdqWWbryDIVttAuXRxdi8AkxLxQKUptL
         vUIQ==
X-Forwarded-Encrypted: i=1; AL+hErGSDNQaY1RlCHOT3VQEjzC3yKsME9LRAEUl4a3CbBW0kPxwYVkX2LG3mtE9q1roTLNrM6mgZY5Gsg==@kvack.org
X-Gm-Message-State: APuU4Z9lbNxQbtDNLcwM6Mw4+6CuwI78QOwyOQJdcJfzClslrmCe68eM
	qWcmI+ZP9bPVIQP3JAZfB9iSAxUqvmpTpq0rZuCClsppdzQf2/XcQjDB4/+XZlqNJw==
X-Gm-Gg: AYBFou21zz64boHonDzrD2Z2WIuQJNfnTfQjJ/bjZrB+3CNOQZXjAPWbYolOl7qyOon
	NrCSOv6Ob64er1BwMdnq7JDqaId6fQW1iV7mquJ+VQgV0O1WqNlmcW+zhETlfBKFts8Vk/2OL7h
	qdLPYSjvM2V72O9AfM7p3PyjTPOh0ynwvN5UJQ39m4PPJCtZxPAjyvo0Yi9zrZ+1jh70U3VTYaH
	R7IYUpibg6YmPYBkJzfI6/GOcR2KuvtqqAZbVi/qYLf8klQGzRK6oAPtB+TKaruZunM4i29cfm5
	+WBei6PzPr7l8RpNLjyBcLD+ar1Khls4wb8Y7gY51hRZ3AZfHEdQU4/gXy1HNm2r7RqmUPZvPIU
	mRIBA6QM+8VIDznpoG8vdim5F05B9aZQWhuqA7ZpqUDDdyzzHhpyyPC0n7MRtQj7mokhXxho0/g
	uTuEC1yOWrARUMNkM9DPRD7PGoYETlB9jSDQREwZVeplm48h0vsT7KK5r6kTleuYwl52t781h0+
	72BaDXeiw4NM8p8wGv0/kCv5Pf5b7KY4CxUyo5R4cQ11KMjPIituKe8pioWazWRJzmDI95BprSr
	XRCO7wilVE0FSpgef5yjuCnNe93CmS/k891NYqkpJz4UpwfNk35H/xf+k+Qqv1/IFIrLI1abCjg
	Rq0ai6FsBrGK2O84f
X-Received: by 2002:a05:7022:ef12:b0:160:90a3:ca8c with SMTP id a92af1059eb24-1b543bb7249mr1435023c88.7.1794968720115;
        Tue, 17 Nov 2026 18:25:20 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:cdce:1079:e29c:bb93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a63059e3sm3191810eec.5.2026.11.17.18.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 18:25:19 -0800 (PST)
Date: Wed, 18 Nov 2026 11:25:15 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Chris Wiseman <chriswiseman@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Xueyuan Chen <xueyuan.chen@vivo.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
Message-ID: <av0L2-OtxcWpQ09m@google.com>
References: <auwOBaRtM9p_Wxfx@google.com>
 <18e529a5ab0738f7.3137322e32332e3235332e313736.873cb.0000sendgmr@google.com>
 <CAKEwX=OUt4=wqDLiPvYuiTnkpuZYnszkuNQScNR93hHhVPRRGA@mail.gmail.com>
 <CAO9r8zMMGem-LTJQseT5xSSBjfr3UX2gzG_ftpw6+KF8m9v5yw@mail.gmail.com>
 <CAO9r8zOY1E7gCYnJZAfKvyHcbj8e2WVuXMqsaPGPsKR4-9itsg@mail.gmail.com>
 <18e53459a8013078.3137322e32332e3235332e313736.12c7b6.0000sendgmr@google.com>
 <avVVRYkIAQnLC_Yu@google.com>
 <18e8fb5c1c4d127f.3137322e32332e3235332e313736.289d37.0000sendgmr@google.com>
 <CAO9r8zOtL4t5pwQOE=SAWeg=k2TkhtNXgV6CJJGNTwuTebKpBQ@mail.gmail.com>
 <18e8fc17375582a2.3137322e32332e3235332e313736.2a6db6.0000sendgmr@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18e8fc17375582a2.3137322e32332e3235332e313736.2a6db6.0000sendgmr@google.com>
X-Stat-Signature: kxcjkb6mp84xaq1144ymtob76mdxi6iu
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 620FEA0006
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794968721-307859
X-HE-Meta: U2FsdGVkX183hAjEmIt2saa1f6oiZcFn1SOs0BfrSodnhA/BQ8vfmRx1fKSzmzw73PIbojxUaA6ewNRDLU7ijFcO3XdZAP0sJswCQmyA69nHWPwQDowdyIUCGvxisGwseNq3VOQQXGxqZlp/auIklwBOzaDwAZBQpehbe9WbbGb1+/Wbdhnsf3432DqYxSvgNDHfUogPAP++gzkl3y0g4H6uYt51mFXj+NfheJKQBuMLrEHE0F2tAthLXJ79zuI+jZO0NsvK5D+IF8zscDUhc/7kktTvYgdsEFgkPzkR+KHbHKrC222vyLY+Hl22IcPLv+jOpCT1iKCHSvJO9hPJla58qsy311O5MrwEZxrOVt0uZQC4fSVYpVFBBCZLlDsKI3y+2GAbaBJhDWUc+xY4xdWHZMaqFC06c4nPDRD5jZLrRI7i0EkkTKH/mXjVqPpxzG9pl2A68JM33RN6aSAVGlLGVYV8ARO3lUm3Zx4T+rZJo8f+RUNgy9r37U65sAZ44VVRPMA5EDbk3joliPz64GZXzc685UtTv5wtBOx87McEo1XchtZV2HiPgiBW1weu9Hprq2GDzhG0otlGLYoJWDEpbqtDwLO7yJIXnE5O/dmS5+nPbioMmICBDYWo/3HQGA5qb/fvi4FqX5WSQvJNuZuFL4pXGibrM7gOyPJ1mUqKPDM8cgeVdlf/wQKjOG9U8bhHWad+aqbuUC+EHKxj0VZsDj74xnv703vwP5PaMo6R9NHxeK5y3og2ZzBJg7w/LPN34YOR9JGiiVxWJ3xnz2iGmAz47hxYJiIfam/YJ3EZiP38GZVaJtl0R3E5x5e4l/PAe7csiFnD9kIqrfkOYRO13dGgiRlrXSubU4/6Qh3nIUYiZshGyAlxmT2K8CUBNQAYQVsmMpG2CB5JmecZxJLeR2h7yhwYovdYB8reIyr8WaGUuD3GgdfHku8j5H80grrBpiesQElgxwfCSFc
 W9qZhiXk
 8SspSp33NeDk6B0so8VnMZv6OzPJKr8rl1ou2xc7LZ4tEuRPqhYmSL0GfupcT8bodtBCFd22rXYMzBpj94uNIO/d3U+B3EShtO6SVk0oPiqdZaC3BFluJHVjl8uSSX18XalAl/I0uhON+hy0Chl43vPVr8Sr5eREI8LNLaqk+46EnG5KSA4PcjvEguQPNWyFsfBiHNR9Xd9CFlXZndvtSOeMpPmM59ELJXw8+y8bVm/Y9EACU4qpZVaLzAPdyZJ/OKeOn99u1ysrnSdWm4tI9v6E16W6fZag0p6AXzERlFC7BpzbQNxEykl6ZlsBEAzDeY4XiiG2l+q5GM8CbcH2hd/RVQAPfxY1K8a5pMjOe0GqqC8B51CbH+n5kVQPylgTJ/4vlJoGim5T08sEkrnhPit6OgDeCfh3Aegbe+B19SkSZWBF0EyHAdhz9iJlQROD68mtj+E1WIzJNauGggUGgJEFB0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/18 00:27), Chris Wiseman wrote:
> Nhat / Johannes / Sergey - good with a 2-patch series that just removes
> the zsmalloc shrinker and adds the unlocked zs_can_compact() pre-check
> for manual zram compaction?

If there is no shrinker now then does unlocked zs_can_compact() matter
that much?  I assume zs_can_compact() is now called only from external
code, so it's not expected to be executed nearly as often as before, or
is there some other reason to make it unlocked?

