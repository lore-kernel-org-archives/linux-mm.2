Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E008CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 01:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30768E001C; Thu, 16 Oct 2025 21:02:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1948E0002; Thu, 16 Oct 2025 21:02:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7528E001C; Thu, 16 Oct 2025 21:02:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 918938E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:02:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E5881402FC
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:02:00 +0000 (UTC)
X-FDA: 84005804400.25.BEBF783
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2091114000E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:01:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kLQx2ly7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760662918; a=rsa-sha256;
	cv=none;
	b=ot6iHqd/ADe5WDQVZv7GE4uQT4sZ21161v/K3jGjrESt9Mq6DFqV2XnS1BD14B4YBJ57uo
	nHp80jO9dA8C+vKBkocTK08iErH9ZBDnNeIWNQPOAyk9/6IkKK2gxhGqlvmx01FxtqLqKq
	W/Sg3LzDXEeROxT1E7sOvMiZU18ChYg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kLQx2ly7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760662918;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhOCF1jngPVTEjHyyJfbBN6QhgsjGjoe1GvteHaugcA=;
	b=IAtibaqGqQ6JWivR/IYfPMyxzRREx0g03z1hb0B0bctDDzU0reatPQqeQ0BaI2fgwezuHx
	CBwfE5v4Ei95Z9MBhd15YwJBO2Wz6ErVMJu0BAZQYlGyg+0LtTtUn0dCxuZUbC4Cl0yEdw
	G8c/ZVBaCC4s2yjwRzlHYXyNxpdXxbQ=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b4f323cf89bso265158866b.2
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 18:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760662916; x=1761267716; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lhOCF1jngPVTEjHyyJfbBN6QhgsjGjoe1GvteHaugcA=;
        b=kLQx2ly7ZetPhY7pAepkr+G+VljPVjnmCAs5PvI2COHK4R36DZabmdtUZcCZi3HpeR
         oSF0HiOXHpia4+TXk4aO3luiomTH9nptvVbaGOSt7clUJF6E5Fldz/js496w6BaSyRMz
         wKDHJCFrGZi/EvTtlQW8dVjv+N+jNuZNZFl+B5daCDsaxExO4VbDOqXkLPLqiTpx9uL8
         gMkkYq86DBQnM6007lwFyhotjjFrVgAmF2+hqVEobB7wQniX2W6pIjFCxAiu5EKFNgCA
         Iq8naJglDwM6vMWA/PtRc8ILkO0dAdydrs8FWuouXuLqui6Qi+LTRzZKNCduIGzv3Ujv
         Z4HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760662916; x=1761267716;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lhOCF1jngPVTEjHyyJfbBN6QhgsjGjoe1GvteHaugcA=;
        b=b9LLsyk74mpFQRvc80W7iOXcyOynJj7TxxWcwonp3cqpLXk7/CBuOyf5KMyVB4gyha
         ZlRON0vEEf5xr5+UBtt7e6wAzU3ufWQRV5Cr6G8jFtC4ftLHzSe7M4tvOOyZVej/1IJP
         fkwgarFJajU7p+5z2PSdHen82JHV4JEMKk+X1WRXk3iqR39mH0dHk9fMF1yQ/5+TBvx7
         gPhQzeZ5CmVQEDhM/0vJHU1HPozX3sZaHPnTOre+/nUl3QPrycgX7wR3fKKBc408xzCS
         UddgGtcHxM+StXPgoKe5U0F/HmyaCJr+M3MLyoY568Rxj8odrH8mF6dntj5WPHUZXD99
         RK1w==
X-Forwarded-Encrypted: i=1; AJvYcCVde3yosrmMxF/GpJCU2sOsqx1cq8fwVm7XGT/eNvdSgEcFv03evq77iuMWwKS5O3RxZf0V3JJYEA==@kvack.org
X-Gm-Message-State: AOJu0Yw0qcgBZfcTIG3ZGad3ecTVMDpS3TbY640ghC2YR29AF6kZ/Soe
	O/Ing0uCK27Xcmnfkh13ZpiTLBgWrLEeSHfWDn0f40Wh9EzGzYbOoCAt
X-Gm-Gg: ASbGnct5jTYVe3HSpcK88zV/DKPj3MThqNFEBYa2DkanM8Vp+F1/y4gNdCaRdWN1clb
	eufIcmjoBD6PiABsgMhcVjBaFFa/8IjlNSc86PVpapbZeuOXHglt7/0XHwHSqik6BPRfz2EpAR0
	xyesUAXpmi1YKINdR4vQdtciij7iGJ0ySMHifIUfhWEfnoahC/m4NaKCkp7F4hF6J5ScxNECI3i
	UtLhPtgY0AK0xD8MyCc5GwM9lhfPbCrRegVn3DaI0FU4hJbel3VdMueNzJXJu3y0vfoycokQOIs
	+JCfnR7/TRjXt3NmHAuUOPUlAHNeeZp9waF94pNGbyDIlutPfNKICt7oeALZTBvYdvl+zojl07c
	WIaeas38rBh2j3H5/q9BhjCZ7OemvWfUvSd3lWSbIDCxg01SW3INEoVSonq4yCp4Szohx7/IMtR
	NXLWshp4wH/CqvGbU2fAj1txV6
X-Google-Smtp-Source: AGHT+IHw+KEl5rxSaF+lWRF3a8kte3TVt48oRokdAZeDiuuJF4LkZjJ7dkb1VCZhm2T8EQpxcxNUVw==
X-Received: by 2002:a17:906:f594:b0:b57:2ffa:f17e with SMTP id a640c23a62f3a-b64731447a4mr211558566b.19.1760662916198;
        Thu, 16 Oct 2025 18:01:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5cb965dac0sm681744066b.13.2025.10.16.18.01.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Oct 2025 18:01:55 -0700 (PDT)
Date: Fri, 17 Oct 2025 01:01:55 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, linmiaohe@huawei.com,
	david@redhat.com, jane.chu@oracle.com, kernel@pankajraghav.com,
	syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org,
	mcgrof@kernel.org, nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v2 1/3] mm/huge_memory: do not change split_huge_page*()
 target order silently.
Message-ID: <20251017010155.dnwu2bytfyoeyiaw@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251016033452.125479-1-ziy@nvidia.com>
 <20251016033452.125479-2-ziy@nvidia.com>
 <20251016073154.6vfydmo6lnvgyuzz@master>
 <49BBF89F-C185-4991-B0BB-7CE7AC8130EA@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BBF89F-C185-4991-B0BB-7CE7AC8130EA@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 9apa5bqn8c5obcj7c39zm8b6nkznfy99
X-Rspamd-Queue-Id: 2091114000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760662917-586719
X-HE-Meta: U2FsdGVkX1+Nv286cfusTN5lpgoITJyzTNqq0ADNuBCpn5ZNrhEma10U0ttTA8/+Sz/7ms+IpQxfdNEy1I8RTD2d0djwW+fqyT/2GKxnn0mDOFsctE3e5UGYninRdiaH+LqpZUv3QS8UeK848qGYENu8LiMZMlxX29sjuLnkr7/Q5efPFD8pBWNxp/UEOtjQviCWm25dM0Njk0zYYVcIVoZuGPluYvuFc8J+ClAJAI2tzKJ/nAeBZITxeNTC/7nuURO9KIhvrqNlNDnvYBY7VI2FcK1OGljymd0vYJc6AJ1hoo2E2/j3qHJ4KkZQTcV/7E/Ma9mDIRBSJTa+uoZ+ImCMbEqzht2dKpDIqpmOostOAhXyaJ/lgQpaOVvWpcwEgx8uWfkY67WVnsluute8/zSX2Q1uPHf2BW8sEfoyRrwRzhx8Yj/ouc5ZiKxksxpXnp6kYuTBDsmiQUwQvrJj1OtTbM/4wmD5ibmWUyyzqTNP7Es9q47skewSS50mxj5zbmZa8nigP9VYhPnrHFH5vzP9yTBUDocJ9qnpgqzLPPvz3Nk3huVBi1zpm90R0rCqryX6kXc9A91u3XLj08FSTSeQLK+uoauRxkRIjNYf5dp1foAQhIknsSCrA6sAp5CnO/sxXCQ7eUhUcPerxqMDnGBP9FxFZTlFJU3v5O3v66CRKcGnGG3HTwcOvEHm/FC/7hZxoji6j5q8E2yasVDf9YFBc0u8PMB8tL0KxmkDCo26ftiHUG9obHuKsvHhBJuOcGIgto03ahVl+CUT5mWvJ+Rs4SLzvoldene/uCc4APUiuZWpy6XwDbjdihuPkd3gBdyIYpXmj8FPYX7jxbgqsnr2wxTAu71dNlkDXeu6TCZV6TJtOPYdQgDpGkNEplPqkYznodWS2qgjHuq4D1mRtpTWu0YoZo56UOcT3d4FMQXDzK1SgnKHNWbILUm8xZ/Y2UxYIsvWKOuWuFZY6az
 c5+c4kuM
 mYECmXkT4C/gMR53bq7j+/k78ZpKco93CYQ2a2EqJGHMLi8LDmDuE4UOCx8Xa1qsqUshalJ3Fv0LmhEBOmwLwjLT1vqn5i1ALHam9mpoLLX30Zo0GVnW1s5eMCEAqJS93S67N22JbVAWDncxiTF+hS2VKNiSj1/vjVzCCvISSmibeU7kAllG6JlXSXfUyjs8lpWPk21DkCmatt5E7YegZvMEuiV7ji9H9R2xwV/GwHKGQhbZzc554frJ2OVFnYZRn07CdontU5mgtzeyODJ0qV/m+4FBe3up2dTbO5shSDmBFZGf4WuntC2rm2j6+d/wNPXKbgTVKVYdH5sUNG2/JKqOKVFEyRiwZ/vrNHkanBJRge+jAVcAu4bZoXkbmd2+cHtJdML+E7nQV0BMlww7jZ571/zZjvIRfXty5uSEdJfSm9TZDTCDAM2jUZih5NQ42v3m4SS2ZqOmWLax/0b0yvcVcVuqq8C9li9fYn6FjDj2c2jJGwy1gilwu2dXke29OvL3c8FMJwYzvi3cW3opXci+hkv6xRAq0utR8vURuPfUA+JCcfub8B4na9N5K1w8d16dolO8kl4LACgjsGxsUXdY1m4dn9FAisq9fRWm/ZX7izrqci39QAqMghWIIw9k/c3bJHKcHRIgFK4SOhoRf8bMqb5Iw7VpD2jKr/0Y5tu5NGpYFiFOMt4PhB1EDUYM2A/fxhZU+H3Ww1QX9v+AJ1fVfWF2yzLIQIGUQo8AaMI1UImBLC9U7WaNi5mmUy1WkZrtWB/a867SvA3ywtosCaguqvjE3H75lSV/jzEkgy+hOdG8XNLubm0wiZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 10:32:17AM -0400, Zi Yan wrote:
>On 16 Oct 2025, at 3:31, Wei Yang wrote:
>
[...]
>
>>
>>> + * @new_order: the target split order
>>>  *
>>> - * Try to split a @folio at @page using non uniform split to order-0, if
>>> - * non uniform split is not supported, fall back to uniform split.
>>> + * Try to split a @folio at @page using non uniform split to @new_order, if
>>> + * non uniform split is not supported, fall back to uniform split. After-split
>>> + * folios are put back to LRU list. Use min_order_for_split() to get the lower
>>> + * bound of @new_order.
>>
>> We removed min_order_for_split() here right?
>
>We removed it from the code, but caller should use min_order_for_split()
>to get the lower bound of new_order if they do not want to split to fail
>unexpectedly.
>
>Thank you for the review.

Thanks, my poor English, I got what you mean.

No other comments.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

