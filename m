Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F846606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=j68Gm7s5
Received: by kanga.kvack.org (Postfix)
	id 54FF46B05B2; Mon, 26 Oct 2026 05:30:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 500AE6B05B3; Mon, 26 Oct 2026 05:30:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C81A6B05B4; Mon, 26 Oct 2026 05:30:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 159BE6B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:30:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD52F806A9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:30:08 +0000 (UTC)
X-FDA: 85364256096.17.BA60B91
Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	by imf26.hostedemail.com (Postfix) with ESMTP id D6CFD14000B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:30:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j68Gm7s5;
	spf=pass (imf26.hostedemail.com: domain of wangqing7171@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTY8VQIlE+Xjvg0Xp6QPO+Pn1Af1VD1rvxxNkn+l+OU=;
	b=oCI23AQHZiVZzavTNsFKMsdvtT5OJpJsylPZg4eB28mWS24oIKc3trISbOvKhKy3xskWq+
	12jUfvysKm0kvLoLbNDTjrGXk8RcFhBCLjuLpFhmXKlTdFJL388OI71liHgtazwaa8Ma5a
	NJbYqbq8lCQQ0+U/5r35L++6F/P9kqI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007006;
	b=FuYE1XSBK4tSHB8JnSJrOjIiLuEk3qxBI5E8TpDPkmZMphRq3BjpU1g4qjnumC4zNefs50
	FIJXfKBwJ/cI+LmXhW2STNJMzsM3rJdHqJdcUwiG25IDD2zPGXVzBRJkYx/MIQ1eoFzZa7
	tgCRvFyI5gqB4ZlOHEJ2+4znWD647aE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j68Gm7s5;
	spf=pass (imf26.hostedemail.com: domain of wangqing7171@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f8.google.com with SMTP id 98e67ed59e1d1-3ac6fe4aff0so1916831a91.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793007006; x=1793611806; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hTY8VQIlE+Xjvg0Xp6QPO+Pn1Af1VD1rvxxNkn+l+OU=;
        b=j68Gm7s50OlvuBqzJlxrtMBx9T1vHnRnVxOHg5SdUna7mPfeNB5yS3amObNs+Nn8+9
         SwL0HfYkeIUPOC0jacQDJxFp8cLrbJ3VtXndvEk3F5itEg/WCIMJXjhroglxgl+swX++
         /Y4apfm+Dop5IzeboOq/ZE4BgviFdgBxPMCuSe5vF8wpsqyTsWCyn7I0D3K2TEuFadrj
         LTXhqGDsRGACL7WGQkBAgQ9WH6pEtJinAE2DXVNCs8/P4JcunEyu4g0iDBruEYTeS30S
         x2OfoIhwjAINgB/F2YXxdapxqXVj640GRkp/IgGGUaWac1VPBvZbvyjHYuUjsZPTR97f
         8uRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793007006; x=1793611806;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hTY8VQIlE+Xjvg0Xp6QPO+Pn1Af1VD1rvxxNkn+l+OU=;
        b=raowHmtnX4UyEI5e4dnk1A9J4JTutUG1rIdlYSCQzvk2qcvxg7Aac8MKECKoMpe9hc
         MTHvoE5V54JTQn/oIy4ZLFhBAMr/DoNJ4/11kFqo/DldVb1vH4mc5g8ahC+6I8gEgxxa
         HHwF9BbRvq/tW7sz9zQt7hFfR2LoBsl3uyn4/ZnJzdTPPxukoyf4hkk/zrdnZwbSH19G
         HbULOyZTDyRmxfcQZp8wsgMSrb4LmQsVw5RWELI8gim1HLSk9A0Cx93SubrGjPBZ3pRP
         OuWxz8o6AIQyaFLwE2uF9gq5gO4e3EtrlctbgHRnrzrgbYqRhk1VdClajnQ91h+yFoa8
         zn8Q==
X-Forwarded-Encrypted: i=1; AKwUvByD+MNTfKViBYdoOSStbQ99StONnnoeB7dJJEHnVBaO67cd2qruhZpXDRFNi+FpfFIg75oRSds6Jg==@kvack.org
X-Gm-Message-State: AFq9FYLSdZcmjmhJ2R9byFcEMW7Y94vdD6gY4Gko4aJnxmgPvqj0oS/+
	EIIYMH9XN5/jhZdG2LaEojWiHSgh8oGYCsiLE5fs4bmWWBH7X5mweJLs
X-Gm-Gg: AYBFou1jNhlVQeE0CSN3UNvuHrskEPJ0QBazrwOklVgiLT7PzHlqecPNruzIF9kAO+c
	tYS5EwfChqZlBK1ET5tZe99o0KL+lBTAoQNCdXkRpKVFQJzJHiXQIYucYEH+USlDzm25cv/zamu
	fSJ4hyCGEIDvkOYfPE0dCp5HUSZEnlCpnWPtaq4vOL/rW09t4bOp7pXl9UIuUL+fGeXB9vNMD7+
	VSbpL5y06N/iT784Cy2qHpqWj93UDgbwEy7pn+Ojl3utKWvkxPcdpmCDgoLd5XE6Mjn81Uc5eFh
	2JQbKukbq//XvCvQe36EwXah5etIspx2Knln7+BgxOPitvCOlUD0mTfnirIm8g7KJCBEL6S890c
	l700Q5dgfJ1+znVrQtFxl2HprD/svl6gPBM/aihu9C3L4rc/G0wLftl9P8QoILyy9CFY/GNi1bu
	aMRuMw8hhcnpBnwUBs5gG0zXCo1M46nmj2oysy9kMel9dJz21QLbUk10goS48BjIy3trKJHOufz
	Kq/kJSTKJC99VPVnnJKItHFuaFKk1Y31sclOVvOYEE/eVJS0yiVH/oVhD9Lqr9+2GyZclJLTc0/
	A6vnIj8=
X-Received: by 2002:a17:90b:1c8f:b0:3ab:3384:1a44 with SMTP id 98e67ed59e1d1-3adeaae6ab1mr5668619a91.12.1793007005446;
        Mon, 26 Oct 2026 02:30:05 -0700 (PDT)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebaddd45sm5436708a91.2.2026.10.26.02.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 02:30:04 -0700 (PDT)
From: Qing Wang <wangqing7171@gmail.com>
To: harry@kernel.org
Cc: akpm@linux-foundation.org,
	cl@gentwo.org,
	hao.li@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	vbabka@kernel.org,
	wangqing7171@gmail.com
Subject: Re: [PATCH] mm/slab: only require the requested size when refilling
Date: Mon, 26 Oct 2026 17:29:57 +0800
Message-Id: <20261026092957.2305785-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <attrLy_Q-53FnjhL@thinkstation>
References: <attrLy_Q-53FnjhL@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6CFD14000B
X-Stat-Signature: izdykiqaywuh47b9hapwjbkpu9podsws
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793007006-777296
X-HE-Meta: U2FsdGVkX18NBTGSXEwefcG6Fe65DH+/yEa64kRzn/gxcm+S8wCRfwpvQbE8iUpWpjifCL4j7HN4kId7YPvuGs+7ZmZif5aTCJ9cpOdBFWFL7vyjdBEmz+bfPBvaYnS9z+bVkkvcpQZVyM5s8JvYqkOuKlfI9reNizjBITngAJ9HfUGSgmibBDUXHMFYfQIwnqUhwYAss4w+ZktiXflSymMTPX4F/xECIck/DCssX6ldFR5Jvhxg6tQc49dEF9qxC1jwSlDBJm172iitQ4aPd6X2cshLwYSW6Yb3rd6jY1sZoDxbmZn+v85n8QodbKYpdLp7Cy7+9+sTBiUgjEAbsVEBbG/RGH7gQFFn/PhIqIqKiV6/GrUbHKeOz1mYL4n3sWLDUL78++q5AzegjwO2MHOfflC8qPxG0ZQbwzQicLyBuZCuZ+NbesKbowRXNqz1guFJmWQgG+WSyuv0ZxPcKJJmJKhw5XGfyGoZD6EAhevYL/ecJ0yrVj6rRN6sge0SoJZvMbpDkPc70GDKcUZc6uBQIL5Ff54uIWZqz4mcvgc37dz8i4aBn467WpywNiQpwl0yXCB+wapidqtvfFijXRp6/D5rVHX8GxMKfigLS4qtjnK9KfMphzFwAgW7/jNZjhySq814WCFTbHLY7Bqb6cRMXDtQuOEz0FxHOp6/y3u0Zn4WiY1B37JKa+yOB+u1FPRFLXHY1OD5TBa8Uekn/Ik8W4mCwjgt5vC+QVw1iHz5P33h9dG0rp8TiVtthZuX/J/gfEv0oCCdx2D8jHxadbseu1b8yc9tNQheAjN1tEwUM+199vZLF1iF/ZQjL2gclIazWGEf1ERySL+3xOF8Gg1P9Nz4mi3jF1HvCEo/QhwOrcHe2WVoJ14KS/mP+tqDxUS/wG4d9dZUFt0CoewVBXn1/WD5I0EdyEjAxqI/r8R/Q4nx4II9vEqEdckAqkZ9aXyueqxvBr0R8hBApCS
 /ary3CPh
 ED60rQLvex9LJbKFACjKxnFX+2Dx9sFNJFgeDy8wUgxcqBy9dls7L+7JDGtGJ+B2fZRdICJCTXXlMHPAY9aAAsPmVrvTyJn/aSfUGWIZNF4mobopyDaS6a77lPp++wVH39EB2TPARLsnFr80X0KdFnsmfM74Pb/LNJN5NwF39OK+KDcTKClL+rcuUZIJOYZ6SdbhyEOwQkqFJGBqTj0wgo6OVRkuw5ry2u7cPl85bcph7qcpCdmldDxW+ecG5feaMC7tXswmNCwdykTxvaCup6JrdORM4r0fyPoXw9VCjYYZXyZWo4WKJ29ZKXRrnSWiYQ/r18ra/z6rFDyjsiWqTZx3SiFSyHoG4eTmYnJ7guHi33wDN89HvtMIczEoGcFsyv6Xqom+i9RsUzvES8hkWbQjv9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 23 Oct 2026 at 22:22, Harry Yoo <harry@kernel.org> wrote:
> On Fri, Oct 23, 2026 at 05:44:01PM +0800, Qing Wang wrote:
> > kmem_cache_prefill_sheaf() and kmem_cache_refill_sheaf() only guarantee
> > @size objects, but for standard capacity sheaves
> > __prefill_sheaf_pfmemalloc() uses refill_sheaf(), which actually fills
> > the sheaf up to s->sheaf_capacity.
> >
> > The call thus fails with -ENOMEM > whenever the sheaf cannot be filled
> > completely, even when @size objects were already obtained.
> 
> This is extremely rare condition to happen, and so...

Yes, I went to measure the number of times of
kmem_cache_prefill_sheaf() and kmem_cache_refill_sheaf() in qemu. It's also
very low.

> 
> > This leads to needless flushing of the partially
> > filled sheaf in kmem_cache_prefill_sheaf(),
> 
> It doesn't make much sense to micro-optimize slab in low or out of
> memory situations.

I agree with you. Because it's so rare.

Thanks for your careful review.

--
Best regards,
Qing

