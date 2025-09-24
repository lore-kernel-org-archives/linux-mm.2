Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28485CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 14:52:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E7988E0006; Wed, 24 Sep 2025 10:52:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 698388E0001; Wed, 24 Sep 2025 10:52:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5870F8E0006; Wed, 24 Sep 2025 10:52:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 397648E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:52:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5D62BBE6A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:52:46 +0000 (UTC)
X-FDA: 83924435532.13.6F73100
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id D23EA20015
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:52:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="g8/g08SC";
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758725564;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iIVEL9YzEZFFBx3BCoIN128Uv4TB5Rvmb1Ij2L8y3Zs=;
	b=h/Rk3UHK9bSwgcFvivkAgySYFnO6Dwru5dE6Spz3L0Ji8s/XeR00QVz1oK7w4ZV+xuTMS2
	fSoHQO7iMXpFNpEcUyfxtQN1o4XTeb+mVcRbrxZ9kGsm76tG2ofMrlKiVxxT8ikH78pu9U
	LyLSnsvcnXJXhNJcwiuXTZjL4J2zeGA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="g8/g08SC";
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758725564; a=rsa-sha256;
	cv=none;
	b=7d60m3vChDcuyll8KPayjkb4TgY2e7hYj0Vsf4loh6MGd+JxV6ta/D9Xw+HwkdWLI2cNCa
	CwdT5YgskhdIDf2mUAfFpzqcVoa35fxMBz39dMqWSaZJslMyjGn9LQO7ifbG2N/j8OWnkx
	oLj5en+6LuGYz6PwA865f4sPv1dXHEU=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-62f24b7be4fso11758136a12.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758725563; x=1759330363; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iIVEL9YzEZFFBx3BCoIN128Uv4TB5Rvmb1Ij2L8y3Zs=;
        b=g8/g08SCWeuFEkygzNEv3/4fW1DV0XYenh96VOYW/Oac53uOg/Eb1U3ZKMXmP80YpJ
         K5tYBaagaZ4Q58WEB4bwkVLwUsx3xnnXX7fVYcmuqMDjz4kWlkC1691hcWLBv8pymQcs
         syMn39/T4tnKy0mCLcTDMXojuaELdn2NG6kOYacaBKzmwHgDajU+9wP3XoPIKIQUWtEg
         6EV6O9Ud2epzuR1lQPMPjgkqkAynvJhnpMjPyGZI+HkipTZeCBI45VY9FAiXkFGcq6hN
         8K4VMbplc1HkuHHcE6Aqsjtu5IG3jWz7hB/wvqNLgO3qkfmEuGDHy39nQ0u0pLRZkqqp
         TcFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758725563; x=1759330363;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iIVEL9YzEZFFBx3BCoIN128Uv4TB5Rvmb1Ij2L8y3Zs=;
        b=HWxZOcVIqz6AaBfNnsvEHXAjEB9W7iaOkuvZlBHEWiiUKRduSjSFccB12ulqJknOni
         jYcVWA89GYpDiEo89QOLu3CDbrbPKRbnjAips3mXk+VTcrOXVqN2KuDS3r/B6ay8Z1AA
         CG7DpcdMBFHGnMjZl/M0cGH3fDHm+RhGG0sq5EM64eUMj2pRRMsJpYorinXHwo+czeRL
         B13yVUS6EaWw/aGQNi58AMQdu34AExGlmeEy9Cw/BNAK/BEkWxjQYE5kti6+hahNkPfl
         2hiitCvEZ656UvItwYmREPTQjJ7My8+02Dw77uxoMHhqxosMHMMnmqyVhP6iKz3XeBiP
         y0+A==
X-Forwarded-Encrypted: i=1; AJvYcCUh1oYjidACYCjMX2BD5mml+TM7k9zB/Bvj0baYw1iFqCY6NjXmfFE1+bx1LjzHomy0kKW/iu3oWw==@kvack.org
X-Gm-Message-State: AOJu0Yze6caPbPnvHHUdfi8OXpIAfjsMADgkQcIKbozQ6kFJpYhLQ61J
	AKCLrB1RcqVsqRD1PTfvn9gYKx9ug7W1O/pgb+XFf7TSiCTE5Wy3WQCB
X-Gm-Gg: ASbGnctXneAomeZMsuPUObAOsTXN2eBDVk+zjHVQN8uWo5B4O5KoKX92TM89XkU3vAG
	YY+psv0B643Hevws9tVCvMznQnAd9+nF9zhCoOqAWDO4/FMIDSXQZKXJ1zCbdeVEK3D1kLKO80g
	zL7KUusaTz9U5zBDc4083OeC5QbK5RHQWnHj/dvTvp6ZRuAYHTj9AH1Fk7wdTeGaBnaUgZWRmq5
	RoMYKY/BVWAQ21tdv+SF/9lR8/nwaz3k6kLfmr2JGvAxdJSjGqOAxRZW3D5PKwefqM4bwuXWzzo
	gaZYupl6k6t0KX3bjjHwaWWfJBbB2+71YwLB3JyrJZRpd8uID41skh85B8Tn+jWH6dk6DFJS4Xa
	eFkXkLtYUBkfjQQYofM5pYg==
X-Google-Smtp-Source: AGHT+IH7jbnmAeMM98tWHiWTewqEfMXbERAblBTfIQlfFHGJgPwwBhCv6UzLL2D0G1VclydKa/8v/g==
X-Received: by 2002:a17:907:9404:b0:b0e:bb58:652b with SMTP id a640c23a62f3a-b34bbbd99camr10432166b.39.1758725562791;
        Wed, 24 Sep 2025 07:52:42 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b32fb199f89sm142929266b.94.2025.09.24.07.52.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Sep 2025 07:52:42 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:52:41 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
	Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, linux-mm@kvack.org,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [Patch v3 1/2] mm/ksm: get mm_slot by mm_slot_entry() when slot
 is !NULL
Message-ID: <20250924145241.pfmkg4ua2ex4tiyp@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250924004854.29889-1-richard.weiyang@gmail.com>
 <20250924004854.29889-2-richard.weiyang@gmail.com>
 <27storxu4seijr5smul3xx7pofe45ittjrchii3jtwbntalsiy@2cu3wf42drwa>
 <1ebbfe02-1cb5-4f7a-a640-68d5d95cb99b@redhat.com>
 <viz42o4iscxkpxystnikuvfnqzwwfq3anivizgx5dncm4qyqvu@4kymskstues7>
 <ef32e31e-d04c-4604-9786-adac33591980@redhat.com>
 <hzwqdrkfdnreb3liohafhxkd3fpfnzbpmqzlosktevehzmju2i@5nck6ryrlgrz>
 <9ff04030-14ad-40fa-af14-073bd78cb715@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ff04030-14ad-40fa-af14-073bd78cb715@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: D23EA20015
X-Rspamd-Server: rspam05
X-Stat-Signature: 3ku7y784am9uhrzbc6md4bgjmk7a7ey6
X-Rspam-User: 
X-HE-Tag: 1758725564-194681
X-HE-Meta: U2FsdGVkX19R9uH58KvUo5GczSN9IU78p5+6DM9c3bRRNxD9R5ZlKl/ky5QddNj2RCx9wdC1Bwzp+ZNcZTF2wZcmAbqB/jSxKJxXhELtnPGavbRf7iUoqgWG7zk+/y0PirxzoVGwyVfcaPNNnPOZuD8ejPY8G8ID0lyzNCg6rgA6hPZnTiFzERWkA2AAxOTcPKevPwBBEnECXUn/W1TEEzecc2odIBCRAogtxhljFYTn6hK54yNx0n++O5MOlB+rbADpQi1JiA/xlySLs+F91BvHlpupKAyeWZeUsG25hxt51pltJXJaSKE04BH6RShN43vnpj0cMAuLQkDvsPrJoSw5jXwyAKWZkxOYdl80rp6o9FBWNeXuL/MtUBQGpfhNqMJ7L3pYtTa1sc5h5Ihkk1xhEWq3TwavSRRyrW69yGb39tUz3l3BiGw/R25FFV6NSOHJwZbM/SYXM+9g1ZWZ/6yPKF6CFTG9pfSDuR/IwesWhTS2aW1wUTqqD5DgFNZ/+XNZpSLniLTUpI1p99gfMsmUPW0tYfxu5iPkj56B9/MjfNCXhk+6/TfMcPmlm+wxHJZDzUHouHmUfZSH6KJbrgWWX+UkOxflNKdouhDOoNuazIHQbpN+AK1z821+87fApJxrkgEnnBTf6523a9MelfjjXhbJCqB9BYmloO7S7YHZOvaM9v9guG3q3hOLU9vzJ1EqHdb//ENMeAL4hphxVOFjxaHJmD94WkX1oujk5W6Qoq++lwYMLsW+waokwdUuy6jROilrM1HtUH8nyj3zRL67br5cqsF9X2EX52ztqtbKVMrRT/MY7pDozAfWrPaApLsJa03fyYn7xposTGa20PYl1mLPYkUj4NSjdd7o+2Web7wda9A9Ejdaeyw4Z9yug4mt3FAQP4LLR85nfebkJ4mrzQkVzo5y/Z3GoBDnCC34iWVjnuwiPCRvK0MsXFmnHhuYLXxpYk3m7AolMfS
 Gq0ZsgeW
 DM0wAUHo3xy7ba4u9PaDFxON4OlSt3YjU3n9PXgSNpe/exjTU10zzO1I6WrXGictVKxbVf53DtaDImRypfJgFGxRItWSv7lUqVz+OYj/JnakHsj4KWqK+QMpjYG//43QzSAmP0BptcuQlnRCrzkx/pPRW8mOhhBTcL8vCaKfe1pkmgVfXjySY5ynVPRgajGnApuNlTF6lh/Nf1BgQ//1FjRg/9QtFalFxZgT/j+VHfxRM4cW8qySlwbJNyvdgaxB5gfir1+g2Psf03tr4UZxZwuLSFt1F093zjoekac0Y6uJ3NT6/BN1p8WftzyLPzIbba2U5oIdeMNBpwbVwvLNvs0zX9CBgyUnEJXsZV/IShLX62mM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 12:42:36PM +0200, David Hildenbrand wrote:
[...]
>> > > > > 
>> > > > > Indent level gets extreme.
>> > > > 
>> > > > You call this extreme? :)
>> > > 
>> > > Emphasis on "gets". :)
>> > 
>> > :)
>> > 
>> > I would prefer to not make it okay to call mm_slot_entry() with a NULL
>> > pointer.
>> 
>> Maybe invert the checks then?
>
>If that cleans it up, sure.
>

Ok, I will send a new version with this style.

>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

