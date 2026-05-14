Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49CC0CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED9A6B008A; Thu, 14 May 2026 04:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C49A6B0095; Thu, 14 May 2026 04:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8776B0096; Thu, 14 May 2026 04:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B6916B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:22:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1331EA0468
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:22:54 +0000 (UTC)
X-FDA: 84765334668.26.49BE428
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id 20BFA100007
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:22:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OM+ormGi;
	spf=pass (imf05.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778746972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jnnqbs2N6v6CmeDw57e03ve8ioJE3EIg9PporZt60VY=;
	b=MCNtqUW7PxgoM0Ie+pW7m2HgFDuTdULkUIfKlasMan+Det04DFWz6zM8oHQJcuYAFtIsZe
	/WXqtLksuY1W297KHWckT3BKf5w2Ir/NQX9BYl/dDxWiECu3Rcz/SYzbZ9XcTpTQ6eIwHU
	ObpuhLV4waawBf1SDvQlxOVdZojeuQ8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OM+ormGi;
	spf=pass (imf05.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778746972; a=rsa-sha256;
	cv=none;
	b=Gn7gjEN+P7XXGEtKAsWZp5vNyzCOY9is751CDdo7ufachWsBEqEtI6TeDn14NaGikBIgB2
	XicXwZr9Sb9pGsriKsQBkZjQlnIzh6qMQBgg4CoqHdQN43uWeI5ThtcL1dUWklJGksMd7W
	pfZ9DiiUuslhgeq4OgwvfNQRxMqzcOc=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48e8132c6d0so36340145e9.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 01:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778746970; x=1779351770; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jnnqbs2N6v6CmeDw57e03ve8ioJE3EIg9PporZt60VY=;
        b=OM+ormGi1azcAfJFKFjdrimbHfFMlaHhnOAOFXv1zjVszpCA/KRxBoTuD5bdM9oo5D
         COG7ZuKYyzYMWnrO7TNxSsg9d2nEB3onBkQT0KEWqvV0hKaZh0uRc8eKWi9elOrXXaCV
         kjpXBya5XbLHoj+xn8dQJxUpOu3QONQJr3HyQQCUMHWiNwf2qeojC8dWRVfOjfsEZ9lJ
         z/OP9TJthUAVNTPnhXginjVv9DaugPZ1y9aHndZQaCsE64ldQfXOMTqM87XtulSsJ2/p
         YjxC5MS5sttsExNDRm4xOOYeiJ1DJTAkeC317UcLbsfKsNX174+pQHFBvYwYJiMWgVcg
         PjcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778746970; x=1779351770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jnnqbs2N6v6CmeDw57e03ve8ioJE3EIg9PporZt60VY=;
        b=r7TMTVM0MVOUDe50MwcvauECYkYRFEohElwILmyZhOw0ySHgOKMiJGUO4vcOngkeZz
         CuP3c2v9yw1oageeLja5MbtrI80Hw0ATcaBTQhCdETy/VW76Dq/kmnEcl4DdTSWiwBpG
         Y38ZTJR1QN1xRviNvxg1oLdhJ0WQWwfWmIO11KzXYfkARVljtvWq9wA6/qC9ULxu33yQ
         Wp2AlnU1iwznffHb/xcJWMS7/0BabResCV5hEf8l+fqDbR4fqQUaQQjPsRNY6NPd/j9L
         CMY1Ip6/4ZWLEF3ThrJwIKEN2tNcNXCFXaoa/C9S72P38gHyXm2fSv8pCphOK1ru1Va/
         BD6A==
X-Forwarded-Encrypted: i=1; AFNElJ8V5HgfzTdLai114UGrgYBxmnzmqrYCNbeKXLW8n9Gv6gck5CoJWAcu9ERMKll/JpyaUnOVcLeDDw==@kvack.org
X-Gm-Message-State: AOJu0YxgVp5qhYbBL/hBM0wQnaNJMSF4rl41B54HtVNE9gBC6PjoGrmb
	P/UWg/lEfiHhboZxqL/qEAgxFy1hDkOoid10+bep35ruA7VR9L4zLXmY
X-Gm-Gg: Acq92OFLJBiqlM0mBd9hnAj9Y7VB1CM//A5AX/XN/4nElcxNLLqWrZluehhbYTSmxuS
	Hu+9cyifXACsA9AjZlAJxWah9sUeJgUC/YLIKUEQUwHZjR0epV/tJgJJ2ZmkzEvEOHUAqeJabQX
	eT6Hr3p3yCk+1wTNZiLHdgs6j1RLK7RCWHB7gvfgzcVIdn9pSaBGJwPpE9T/OFl8tKoJJsYkhH5
	Puw6FpgmChDbN3wrhMQ7nWVEP6b/vwCN0wy4w33xSEu6sRa7/f1xN1NRF+zmMiATFgvEx6uCnob
	GJh9umkRoNxRmgx7VVm/AmIK9IhQkl4BkGskzbhVks5QjBJAfTwsRuO8w2Y/0BppQPblxFh7hD1
	GeMe2dQihz3CqC2QCxsg02zWJHTS6GQfd+Pi6GY1NoAi0QjHP1TjCcqLhCes9sE2v7Fp9Mv66Jp
	SIIdyH95bhVUpRzQl7VWS8RHQ2EYeL/ZpOWl9Z30vixm8W4+BbZb6chYl9j8VW
X-Received: by 2002:a05:600c:45c8:b0:48d:35e:84a0 with SMTP id 5b1f17b1804b1-48fcea151fbmr93519065e9.28.1778746970041;
        Thu, 14 May 2026 01:22:50 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fd64a22a9sm49882335e9.8.2026.05.14.01.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 01:22:49 -0700 (PDT)
Date: Thu, 14 May 2026 09:22:46 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrey Konovalov
 <andreyknvl@gmail.com>, Bill Wendling <morbo@google.com>, David Hildenbrand
 <david@kernel.org>, David Rientjes <rientjes@google.com>, Dmitry Vyukov
 <dvyukov@google.com>, Jann Horn <jannh@google.com>, Justin Stitt
 <justinstitt@google.com>, KP Singh <kpsingh@kernel.org>, Kees Cook
 <kees@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Matteo Rizzo
 <matteorizzo@google.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers
 <nick.desaulniers+lkml@gmail.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
 linux-hardening@vger.kernel.org, Nicolas Schier <nsc@kernel.org>, Dennis
 Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter
 <cl@gentwo.org>, Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Alexander Potapenko
 <glider@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev
Subject: Re: [PATCH v4 2/3] slab: improve KMALLOC_PARTITION_RANDOM
 randomness
Message-ID: <20260514092246.12b7d1ee@pumpkin>
In-Reply-To: <20260511200136.3201646-2-elver@google.com>
References: <20260511200136.3201646-1-elver@google.com>
	<20260511200136.3201646-2-elver@google.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 20BFA100007
X-Stat-Signature: egzwz1jsw3sbshzk3xrx9jb3emus7itx
X-HE-Tag: 1778746971-268332
X-HE-Meta: U2FsdGVkX19dxMBtulNIW9B0OIXND6qmUXNfuFGqYjOmTYJh5yK7lvPZKO1+mEa6RkLhCWDzVY83qPLNvilFPirs/fk6gIZL+Uv5CBQlRm92mispHWnLLE9V+Pi8qWtV2igFV5F4/tX6UGt2rC/S5PLdGxoJfofcfERmjJD0bcJ36+SvX8jpLS3OJb0Hez4vo0nOJPLvhDEquPbPX5utg8CtB8dy0kSorJfK+c0W820BL84EcpWBIHqKV1tQBg91yk4MeUZuMRlyGxTNKMR8mAUi89J5LgUaD6QZ5FqVEZyAyIkmT5eEcUec/cvAcZS8PX3ervTwfK25QPPjvLiq6hELvE2jVGW6d6gOPKoc7kCRfB4w+F68jmqOCkYHGAEnklRLnyrjDPei3s6J5gSEWuZpqMlpCpb5pItodVYCQ0NQsAa0JcPmxFi7wL7+r/DIQcUlEAgs1jgwxpWjme74SHT94joiyOQHYes91NKIPX1e+bNZpLU+7/2XoYHwtEUtCErd/l629l7PWzyj1JnPWuaqGjhkFK8RBznT4mXiEqVWcoZ9Dki2gkVONlIT3WDuQDn6Yii5E0px5jr/yAyVrf8W6v3Zn1NvoQjNqxDpLRrvlV4vUBw3pDRq8rhp1UQnbio9BHYAJqZvRb+GX3Oe26CGUkB2vRcQLQQjnEWQot55lOC/PA1SV8GQue2j1zyNEJNlGJxrcq+gNj3eHi5lPk6E3vKdzNNS8ZhMW+IKNjz3hDjcpFkESULYkWO5B1oNeUVuGJTLawlxXYY00rSabpwafJ9yoxEQP9PbpIRYqJdXshTanCehXRhIFH1Sm/+5YFnHqr45zYnQpJcyAgUNxAWl25uvS94buzkTkykYP9vD+ryZnjXMXRDxJrtpCXEOq08HSO8BCE5vnZ+25H8ak8YyJKt1l9w8y+/5FscJTcVjzXZL79gZTWuT+xEB+akY9Y1HSOksCnhs3l6GrlY
 OhiF5DZk
 ju9YbfZsu1iISKFZirJBRyXkqpswLnmXfVqfJGGNend7G1WYFjztrxQ3s8a/pxb5b2KjTKw8vtIKyOHXVGKfSNg8kR4+CAbv4vIVGnM5PiC4Lx+oUC5qPpwJmWQmsQJ5uZIeeneUjCejRem97hz5A5FUA9iNw1knqs3Y10VBr76cPy5lSbzlnAQPggQyc2gFwWc+xaVwp+iR7Y2ymOoUATwZW/pZYPmkNipwY2o8QBvFrthYkG+DGH1lNjKPpfk1OpiFwMfHDd+YX8GOqb4aJZsPhdrq/BvAbyM7mq8DyYIHKBcFm7DGhXv1lzVBOW/XhJco//waYztVZvGrTMPJgYx1dOdao3OLkPcM+Eg9a5euIHpcS9nC2y1++Q/E+qBCaqR9wddsWDCuTQ6lR3+RnXROc33nRXEr6mFBdbwri4X3nOHYab/LC/+sG3foCiH7LOFK8Y1xX5uRFc0ziOvWt/C4r6if5O0euM6OmOQHfpAsKAP82iMp+8LhP6mS9lnUrH188NuSLpW4J4JyQHgddN5JHE/H900gLA8GpfBQgKXTYbzRyPT6DIlJ5V31pOI3X4RT0NV0SKU9uGvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 May 2026 22:00:49 +0200
Marco Elver <elver@google.com> wrote:

> When using CONFIG_KMALLOC_PARTITION_RANDOM, _RET_IP_ was previously used
> to identify the allocation site. _RET_IP_, however, evaluates to the
> caller's parent's instruction pointer rather than the actual allocation
> site; this would lead to collisions where a function performs multiple
> allocations.
> 
> With the generalization to kmalloc_token_t, we now generate the token at
> the outermost macro, and using _THIS_IP_ would fix this for all cases.
> 
> Unfortunately, the generic implementation of _THIS_IP_ relies on taking
> the address of a local label, which is considered broken by both GCC [1]
> and Clang [2] because label addresses are only expected to be used with
> computed gotos. While the generic version more or less works today, it
> is known to be brittle. For example, Clang -O2 always returns 1 when
> this function is inlined:
> 
>         static inline unsigned long get_ip(void)
>         { return ({ __label__ __here; __here: (unsigned long)&&__here; }); }
> 
> To provide a reliable unique identifier without breaking architectures
> relying on the generic _THIS_IP_, introduce _CODE_LOCATION_: it resolves
> to _THIS_IP_ where architectures provide a safe implementation, and
> falls back to a zero-cost static marker where _THIS_IP_ is broken.

Doesn't that mean that all the other uses of _THIS_IP_ (which seem to mostly
be tracking lock requests) are basically broken on everything except x86-64.

Would it be better to actually fit that?
It isn't as though it is hard asm, you just need to look at how gcc generates
PIC references to static data.

-- David

