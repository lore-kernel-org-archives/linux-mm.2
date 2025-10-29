Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02791CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B9498E0070; Wed, 29 Oct 2025 10:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A3A8E0045; Wed, 29 Oct 2025 10:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4589F8E0070; Wed, 29 Oct 2025 10:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 335988E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:21:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D1966140645
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:21:26 +0000 (UTC)
X-FDA: 84051364572.27.76369D7
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id E292D120006
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:21:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JpORzIxn;
	spf=pass (imf29.hostedemail.com: domain of smostafa@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761747685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3v3m7+iEHWRkLzDZ7+GIqu0uQ7bsmsqb2voqo0NHPtI=;
	b=Q4iX/RpLv9kN361P843rGGkf0mSmPexgbhe30BbbZ7/b604WsnWeJoVJC6gomSWI/si5Ki
	SY5FNLpsPpwcihO+t39MOLfBZ/HqT92H8eN0D3fCMfKSkq+8MwI2KtK6PFE3Rpeg4Uk0aK
	9Bn7OEbBwfq0fCOQjb/19smbe3SqR+A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JpORzIxn;
	spf=pass (imf29.hostedemail.com: domain of smostafa@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761747685; a=rsa-sha256;
	cv=none;
	b=jTeDpAa90RME0PIxIUVTNMh98e9mzLWzckaDUlfsKfA1Co1kChzVWYyCdDSr/Fqq11DLaa
	DlJHMpvcJVyK+wNoQN1lgEAAv/vTkkNu75IqJs86K27v3vjqGmPpxB+nkIWb8kS5aVIaOD
	s7UDFvyb61qYNVQwj7ELjRabgP8FsfU=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4770d4df4deso54535e9.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761747683; x=1762352483; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3v3m7+iEHWRkLzDZ7+GIqu0uQ7bsmsqb2voqo0NHPtI=;
        b=JpORzIxnw8pbHRzYxioGoQLKAuEVOf5MzdqWNZj7Yye3fpzmpM6jhzP4b/hNrkaGyR
         COTTpWH2wx+/MSSIQDCBK77NttB60o70euNZJSc9HtS2PHZZb844qN1SFPd5d7P1KKFK
         7KFgO3rYfUzTdhEYqnawqdn1C0LM3MSynCIsXOR+xd+5UwYlvURKVVd2yozRt+QWp2Sb
         8xerj4SNDXLwni5UhgoP0s2hBpk3m8xHWBQXO6x5BiQRuBa428Av4lVZp4vhPqzt3oNh
         jgi/zWG6x+XgKhA4zUNKp7EnhrL9gBAF1uyRFdUU0QjWsnWW7eq5KVaqAi/2N6L17d+q
         uHUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761747683; x=1762352483;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3v3m7+iEHWRkLzDZ7+GIqu0uQ7bsmsqb2voqo0NHPtI=;
        b=bvpOv+sMxXJOOPylcAMALGLU+prCQ7+A1WZOpiGa1ioqkZPX6NCpp7w2JRQjBEXEgh
         XiynoiEbW9FCoTz2mtPC6Zkzp2oXpipfmHtqTAnJls07yc2VRAxMXkk9ANZ6KM3Jyi7O
         9ow6DG2zcM8iQU0bIpGylo1hSdF8dGVhRJ9VU3UsGS2jiA3QmJB0+0JsTh6V6n1lD8K3
         DaPA9vPhYXVslSGz9u+hz3gq6pMuGSgHodj5ID1W8TSUZPyv9jCTjGrY3bPAyynrXrju
         ibrrI4MnOS878t5VOJWUbZzOQNzhbA/xWyah6MasdYNSeQc27+K/6wItTtIArO679BDl
         JwOQ==
X-Gm-Message-State: AOJu0YyCro7Ew6VvRmV0rP9XTxvLTaHoitMQxpUsYoEqUTz3+5qnznnW
	2GoslctKdsnErCMJlp1dj/jE6+LpuhqviRVdldQkfqdH7Ei7mHyoO6+ODihtEar8VsHEWyVtYP4
	dAceTtQ==
X-Gm-Gg: ASbGnctp2lhcK8OOIvuAv2iShYy35wUPY380q6Dojq35Ja2jP9n+IIbyAC/RxhkLHON
	tqzyJfBNCyb2NmE0LGftvjhhsH064xsBmyq89e1m+U2D3XtDInOfFvgFJKVUzOCkKYz22zFxvkj
	DmjQopogtKdrYxIl+XcPHHEiAYvQmWS4srwzgUOstYioDTDAMwGanHkkuWcz4tmbBfOZwUSnpyQ
	jak3VvXTKCcBi7NuvN6HFisO966fUtgVfLzdoYVU1WbKitKWGHLTqXP2SMRZI4xOL8j86Keh2mA
	rbX4uGYn2vS12pvliVb9af0mAJKpNLA3gYiLAzvluRemfJOh0i+jEVu/UR+VWbvnXSUO7qpgYJr
	vQL0ahSGm/z1HWTHGAMmDsOAx6ohi75SqzBCKRR/Z3ZhMVoXzgF5IOz35R+oukz35K9f8sdvzo3
	IUZ1DiCJdbj/KiMK89NsWQiiWgCwteLgUXu2bG7pRjgW/BzrroEA==
X-Google-Smtp-Source: AGHT+IF0QvVp/pMidwWCYmRvRc3ULDAawDYrzzkZVMrjVXmcSM5ssLIvciM67QH/jAt5xWVHGKoIQg==
X-Received: by 2002:a05:600c:a00d:b0:477:2205:df3d with SMTP id 5b1f17b1804b1-4772205e0abmr1513845e9.6.1761747683131;
        Wed, 29 Oct 2025 07:21:23 -0700 (PDT)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475ddad455fsm123107015e9.2.2025.10.29.07.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 07:21:22 -0700 (PDT)
Date: Wed, 29 Oct 2025 14:21:19 +0000
From: Mostafa Saleh <smostafa@google.com>
To: =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, will@kernel.org,
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org
Subject: Re: [RFC PATCH 1/4] drivers/iommu: Add page_ext for
 IOMMU_DEBUG_PAGEALLOC
Message-ID: <aQIi3-l7juuwLZzs@google.com>
References: <20251003173229.1533640-1-smostafa@google.com>
 <20251003173229.1533640-2-smostafa@google.com>
 <uwznrzdsbfpbalzf5jxxpguf2ykslphfs47u7gf66ssiwzpqju@dh7nw3van6sr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <uwznrzdsbfpbalzf5jxxpguf2ykslphfs47u7gf66ssiwzpqju@dh7nw3van6sr>
X-Rspamd-Queue-Id: E292D120006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8cngnu56bjccadpej5ois5jih96p1ca6
X-HE-Tag: 1761747684-121466
X-HE-Meta: U2FsdGVkX193+ElKK2jVaxw2n6YuSoGtfYjhYwVt82O39DRWTSWXZz9g7UuZGOczeVUoHBfNDPVYdANe/rtfuY4y4kfcfy/3hjF/hfy6G1sbOaqD8tedEJr/6TIcq1SQTCT/DNNbUABppkEbET4nGbQB3C0OH0pqThAx+ORVMPQK5opVzSTj3dFVdig5SECCf/+ITBGBhxuERhnv56S1W0lnUin4khFIDxH++SCjv7oo8eRWnSmq8jrwZYyWL/POqWq+r2XLM29Jd41/m0jDycMeg0wFrDKX7eMyu/PjS2lx51ogaedJO8I9OOS+6zgbYTxzJEJocTI6JKNP8CKYGpqcWgkP/wliZ1Y9o6OLAvO3YgpxwndS4NkVqJQGgiWftFJOaZrgHkdZyTDc7RNrAdPIadUtb1w2KBP4SwOyGmU6O2EIGFou24MjqeAxVk36/UJy6g5uOY332QbbqahUkUwR4Hd/xZNy77dlFTKLIFy070Htp2cZK42Y9rpJm/8EWwc3uB6flUeyD5lhIxfuKO6IEaFsPHDt7gfdaZ1X8m6BvxTTeVzk3nh6WAsHMS//f1T0EfX98fIlzkPpIG6lLhc/F0t1/Nk017FB1uw5BSf9qqQhUrVDOyVfXA3i1AYIwzeChdqMzBb2dwNgBWSAoYW+fvfH+tXa001rhBkT65QYIKeazv3uQSEhbZsiwwXhJyKrKs8TB1ndWxGgJKqh65j+YLeXXMB9LTD7U5F/7YVLDPlGMBW7B+MWXGNm+6FMH2A3H8vlNzgrhbajryK5iRhfv/6NoGaURUDU3uyK65JTmPuKSL9hRoqZkf+6Mf8DiCFxLbBtJyLyNWkJ2o3mgP/IlrLbgrXrwCNrrGTJVA0X/7qc3/OCgDH6ykC2GFsuAfZhdoNzSJqTBHWT0C4ftqsUFqL0p0cIHp/1D8DuxsqfvcroYs1E990ME6U7rUnaCF+Q9eK/xJkwT5tFq60
 yR7im0sW
 opzIyscum/RdElDoIolXN9YBaN0Skuqo6JuxtgtwDcxlfcrsiOrYM6KSo3KrPF3q1WnrUvKbXIIkqz2lmjXebeEUH8rCNAEpafMFB4FTjxz/WbEMwvHps400iRv8g58uykY8l3ZFQ16d/HMLHLJUy+KWy6J6KeGbMJAuYQ8D7zLv4QkCzXqvRZlKnxg1JD4R5gIaFPAYIaTzSsO5pMxR1RaC8eI7JdtE7HbPdQCAq+LtujgnSHrgTmn1jPCDEdt3geROxXY7hrKVwmn7Qiz1vyfjnGZ7tAb4d0srMztConWHIxIcQC1O4uIB3sGag+OoTzoMef7T7ynqksxKxu8GCqCfIQHa8NwvVOuk4AVHreIV+1jknca8IiDc04X7pqF2wkPJ/kjFKeOx0OqgEnsfN+fFFRUtuBoLNwABQ7QsoYu2sX6320HrB/ApYDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 12:42:09PM +0100, Jörg Rödel wrote:
> On Fri, Oct 03, 2025 at 05:32:26PM +0000, Mostafa Saleh wrote:
> > +config IOMMU_DEBUG_PAGEALLOC
> > +	bool "Debug page memory allocations against IOMMU"
> > +	depends on DEBUG_PAGEALLOC && IOMMU_API && PAGE_EXTENSION
> > +	help
> > +		This config checks when a page is freed by the kernel
> > +		it's not mapped in any IOMMU domain. It can help with
> > +		debugging use-after-free from driver doing DMA.
> > +		This santaizer can have false-negative cases where some
> > +		problems won't be detected.
> > +		Expect overhead when enabling this + enabling the kernel
> > +		command line iommu.debug_pagealloc.
> > +
> > +		If unsure, say N here.
> 
> Expected indentation here is <tab><space><space> and not <tab><tab>.

My bad, I will fix it in v2.

> 
> > --- /dev/null
> > +++ b/drivers/iommu/iommu-debug.c
> 
> Is there a plan for this file to contain more than page-alloc debugging? If
> not, it should get a more specific name, like iommu-debug-pagealloc.c or
> similar.


I have no solid plans for other features, but I was hoping to build on top
of that in the future, but for now we can make it “iommu-debug-pagealloc.c”

Thanks,
Mostafa

> 

