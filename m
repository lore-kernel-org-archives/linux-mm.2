Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE198CED26E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 10:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49BAA6B0010; Tue, 18 Nov 2025 05:45:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 473636B00A5; Tue, 18 Nov 2025 05:45:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 388846B0026; Tue, 18 Nov 2025 05:45:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 25FDC6B00A5
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:45:44 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9EF059259
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:45:43 +0000 (UTC)
X-FDA: 84123396966.23.1FFCE9C
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id 038E740013
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:45:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cVZBBva+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763462742; a=rsa-sha256;
	cv=none;
	b=kl4zr3Bigb8792wAPMJqcnIev+3owNmdcJGZ6qz2CCL/s69rdp85GPGzOf7dXtfntIZKy6
	n7kWwC9o73SJLuwnUZhCb//b9V+2M1Q3uEaX2TArGAjZpCjTA1YVmRRTxkKmOSklZPofUe
	qZvtJHR/BSOBCZyr2THhgYsUKfaeoLQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cVZBBva+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763462742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YSC0++zcwlAEFKF5FAa/y1OLBIMh6DxQaj6lBFEO748=;
	b=LaIDvVpGzFNEX+wX3sW1GvRayvVzDNKiK3ma28g4YX+tdKjb9GONn9OpbPvI6ErqpY2rG8
	h+7+3om6umxPmYoVo7p0UcqsCwZ47gdxJNHGh4BkdYERdnMLKC1Lx8wsVMa3CM4jJz6WAo
	bbDZAFYAkvagzG5Rt7lrYxH6PmfREDk=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47755de027eso36823395e9.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763462740; x=1764067540; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YSC0++zcwlAEFKF5FAa/y1OLBIMh6DxQaj6lBFEO748=;
        b=cVZBBva+QZgRi3BlSN/wW1bV5RW5rll9EYiBu4u7SaPe+9roapDgO3mx9FHjowPTfa
         OR76z02JLaQTCTfnFucmkPXmIKkgzOY/6U3NQg7kkrKmED+/8JO6xU9ER39liRdEFmTk
         cgdzBJN3LXfAju0VDPrSZrs41gcg3G+eRDq1Orlcq9NddvI7cntdsSS0u7NFLoiM7ZV7
         AyZp3ZdQIHu6kUkwWbcEVnt03nJnTyTGxMhgm8OSfE6zseYkZacsALjqvG+f4pWK45e7
         1G5R5h98guf3gIVcyJw9jkfJQXQHoN6qkuZzAww/wBxc2TVJQgYSYGZshjWYGiHLoRzg
         vfEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763462740; x=1764067540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YSC0++zcwlAEFKF5FAa/y1OLBIMh6DxQaj6lBFEO748=;
        b=tEH9om28doWl/tISgBVkgafG5niHgcp6OCB4LagDhC2HfKlwwg6y90rgkA9Z92F41u
         VwbtIqSufGSGlmqQ9fIdhEAoAbkCnuzWf+PRFmJmQpCbvN/+D+7ZWSTmyeviN9K1e5tk
         dpAPX71fBar0Ih+zTWl/MnO65irfbUKxY1G29Gi6zL5eR1ASRXouwrW691YfLVkFZrYN
         UoQFRcqBcuzyJ4EcGkfzJ6X0CTJ4RMf9/Z7KT2RU2VQQRs9CGHlW1/mleKCoVQFl/VTk
         fke1nTF4mZOeQA7gVcnF0Q6Gt9mCHU8zkCaSSsQmY30Wl+1sOQBDXYubxTOERuw5edLQ
         ycxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlbCybz9YsWUGE7JiHAIWnQogmvj/rfb0kHZQ1A/SUFQhMVicnBl+C+MUkt1o5q9Tjx++JwwhOVA==@kvack.org
X-Gm-Message-State: AOJu0YxSUE2b/pSq/3yy1Bt+lcK8AaWvrrQKxR1lGGFZiVhhtTUlIc61
	IAFs4dO6rvKoUCknZZ+8UDpJQXxGHQjT7H0nmhfYIVu+8aI7tL7J9UiR
X-Gm-Gg: ASbGncv6esvHg8V+5PS61P0zdYf7+lEvi7Ozzc2J92z4nMyVCEFwu7VTZG5geuPV3px
	/fiqOqXk5PplW5iMMDYoFvFP0buBK7BM8FXUzQmWfn0qyiqvvYTZvHi7il8k59H830w+2Zcfxtm
	0YcDZl/xRuwfQM7V45KezC0ZSfqUCDI4tePMEwI1yb2cyqI4bI+Gsbfc1M7RcKASyJuIQEBBe1f
	mm8AlzWtv9X0l69fQ9Ddvr8sSsvkhkE5VDYhw7ce4Dq78dfU7qgXsCd6tj3q7jBu0JB6T9jmIjN
	0j2PCWvX/YKAgBJCKuJFyKsICYKZitrs0ChXV9SHCeGE3BHWSWGFII6z/e/5IYgaovkScvMSdlr
	h9MvY9O8Yo75UMWyqpZqcknP5i3u7rwyRosMuV1ovLIDffyPnw/CJXKk3Mk4TDNS4QrFU4YfTr9
	on1E+DSun0lqVuPj8JLqh6kLafOo1v0t6pEy1dHF1IJIB30O5lwm6VRP/OqoeUHAY=
X-Google-Smtp-Source: AGHT+IGts6ykTvFE1YIf5+/taVV8z+p5pVaBDGIqd212np4Jl9wdklMUecq1eWRr8hlVr7tWAtBx6Q==
X-Received: by 2002:a05:600c:6385:b0:477:9814:6882 with SMTP id 5b1f17b1804b1-477981470c2mr118226955e9.5.1763462740092;
        Tue, 18 Nov 2025 02:45:40 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e35b7esm366739935e9.4.2025.11.18.02.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 02:45:39 -0800 (PST)
Date: Tue, 18 Nov 2025 10:45:37 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Sahil Chandna <chandna.sahil@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 mhocko@suse.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 hannes@cmpxchg.org, shakeel.butt@linux.dev, zhengqi.arch@bytedance.com,
 Liam.Howlett@oracle.com, weixugc@google.com, axelrasmussen@google.com,
 yuanchu@google.com, yosry.ahmed@linux.dev, nphamcs@gmail.com,
 chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/pagewalk: use min() macro instead of manual
 ternary
Message-ID: <20251118104537.7ebf4422@pumpkin>
In-Reply-To: <ff24b3c573b766b187b55a38497fbad0a319b9f8.1763227530.git.chandna.sahil@gmail.com>
References: <cover.1763227530.git.chandna.sahil@gmail.com>
	<ff24b3c573b766b187b55a38497fbad0a319b9f8.1763227530.git.chandna.sahil@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 038E740013
X-Stat-Signature: r5p6aih5kwexugnq45t4cdbwm4ueuof3
X-Rspam-User: 
X-HE-Tag: 1763462741-930829
X-HE-Meta: U2FsdGVkX19Kff5eVJpxml6NrvBNcvh1aHnpg3wxQAgj5UmnzjavNneaCW1gtl1XR99uVcuPoGTuEN1wUtMOPmnrhMBFHP3YKpk9NhXLSrLCTB4OL2HTbUydahw1X8AE8EDzPmBcscbEClOM5DSbXArqHlnQ8PgraVZy1gVnNGFNwhPZvynozbFzVZAstKBNJpV1U9UreRrgFZGi8lZM3wtWaBqs7slHaphOf0o4HOqbme+zMEricLVoVyROlmHmIEU23Hhn5465v4cFaUlaTYP8wpynbO7suZvErGiMreVRYnwbJ33GE8+hMeF9cTX8vdgrUcODhsFi7FyPRHY9hXSVKWgfgSnmr96oOqtR/0xfq80+TcVOuxvmymqdh81M5bTTu7XXY99M/17CfgFmLSVj9aqmBD8/sxz+5xV+Q0XPI9hlOdw6tfyBVssS80gvMF45ol1ANHsXAec3VnHARn4zN57V9nKhgpnrwl2LkM+FE+Ik/o2qE4VYCyjB6Nz0n69EFBGyJ+S4JmZTwS3tQZylm3ZLTQ5gh7MiUah6Dta5xZZZwp5KNRTfO/WISBxZy+GM6qIZ5SyaK0+4HCm47FUFlA83LlgeQq5qg1a1l1WVriCUS8v3i2TqQMkfgo2ZHh4kQ/aJyl4xsum/kOnG3s3tw2cyGksG8jU1l/8U5tjbYkOszw8m+jta79G3H4M/OlMg1Qqw7SUvI5G07nf1EP27Dqv19wsM1BUJ4Eg/TLEf0sbRTb+FLV8a+YCAkqbKS3ieS+tWE9Y8MlV4gXRWo+RYlDqNCEm6blZhlr6BzBVhb81kYXLCK1r95Drcf5VQQWtHG5T57eTOoKk2HYWQbeXgAQz2zCivyZCQ0/nid/rzD4JlUd0NhBTh+4wHd48xDrTC8WxYGUVC9yxy0PbRIgVZluAT/CkHFs/APwkTjmSmLJyG/Nkfp2lwerWqOriPz+0pW05NK1hCSmMswmo
 Nn0Wu2Zu
 SfQKhNM0c8m9fUPq/Y03B3wIhb7CTEzjzFUkAHrlBwhTzPVA9bDyJH2CBOHHnh/jJ9JFwjr4IWSSteKWYAwTvjTjqMSR+cVfjNjZKC+cKBT2dAzD3NHUwMIMSZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Nov 2025 11:38:49 +0530
Sahil Chandna <chandna.sahil@gmail.com> wrote:

>  mm: pagewalk: use min() macro instead of manual ternary expression
> 
> Use the kernel-provided min() macro to compute the minimum value instead
> of an explicit ternary expression. This improves readability and matches
> common kernel style.
> 
> This was flagged by Coccinelle
> (misc/minmax.cocci) as an opportunity to use min().
> 
> Found by: make coccicheck MODE=report M=mm/
> No functional change intended.
> 
> Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
> ---
>  mm/pagewalk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 9f91cf85a5be..82db421b5b34 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -313,7 +313,7 @@ static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
>  				       unsigned long end)
>  {
>  	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
> -	return boundary < end ? boundary : end;
> +	return min(boundary, end);

You can remove the temporary:
	return min((addr & huge_page_mask(h)) + huge_page_size(h), end);

  David

>  }
>  
>  static int walk_hugetlb_range(unsigned long addr, unsigned long end,


