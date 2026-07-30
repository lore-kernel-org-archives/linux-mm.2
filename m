Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80FF5C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 07:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F1F86B0093; Thu, 30 Jul 2026 03:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8326B0095; Thu, 30 Jul 2026 03:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9696B0096; Thu, 30 Jul 2026 03:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45CEB6B0093
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:52:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4982140906
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:52:21 +0000 (UTC)
X-FDA: 85044675282.02.686C372
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id DC493A0006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:52:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GY7ZyBXZ;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785397939;
	b=hltk0okLVAkeyJDcXTD4A8+CfEqc7ZJWVnxiWvKrDyrEgl3DGftHShRNOKyGurOsfxo8ii
	BasjusFXTkJ5pXv7tQzhcfZi0TeMd+goc6TcQyYUYGRNaeU+iCUmpDNOSakKcZX52zL9+j
	ZV8UaRwoyNumQEU/V0jgt4Mvi6SGxs0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GY7ZyBXZ;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785397939;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7BVZHSM3RopaR6W0/bDqMe3XMROxNpJV6YavlmGViAY=;
	b=70sGBObQSgvw8vKCPoSBEP8ejnueP1GDiHM3xEFOpsOpSEwDmkAHJ/gsxfVsulDZgM3lLs
	cBXtlvuL6XK3n8Fj7TIFbjzfWjJzKyJA6CQT+NbjhtAp0YqFWuFVOE2EI+M5YBxHEeUPmC
	1AAm5bswGiyK4QhcVLEiEbnyNXv2YBY=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49545ba3d4eso7856975e9.3
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785397938; x=1786002738; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7BVZHSM3RopaR6W0/bDqMe3XMROxNpJV6YavlmGViAY=;
        b=GY7ZyBXZpn00WAz//cl/jaJgD/wB/AWq8WeHlz6zT5tOzgxOj6c06lHvOgb2DvcQp+
         qxCg14VZHsSZ6fjPL2fBcOINx0IzKIWEwDUrXqcAaKQGVD45zLS3AmG0akFttAl1F7K/
         S+a/3I7mrotJkpTARwzXSxX4zdDhM7F425iPI/8KsK/ZzcKUPD/uwN0Xr6g/GTuG55wD
         m+jKVb6O5Qcgs/nX9joS1SDbL17Z6Xy9tuN3BCOl9U4uibnwUSHCtUorydA2I9tyrLuj
         qXgZdw81GNqs0bQSzDe2kGkd77j2XCowKFzrNQVqumLaqF1zFm2/WDGnwZ6pVsRI1UCu
         TrhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785397938; x=1786002738;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7BVZHSM3RopaR6W0/bDqMe3XMROxNpJV6YavlmGViAY=;
        b=U83/RGm1VOZfJOi7VAqTk+1FXOezdy3JFlGsxbjPZDIxZRtQhas940fGqo6c2gSHcu
         rHTHkjUfbdfD3YNwI3GqWsWzMO18cM1Mqh+IpFtUq3ReoEJWc8nTFd/mNxQ5XJOrS3tH
         TrddHC8MunNFQqHlg6uJrYgskWDBLQdHSoJJz5KlKwwd86F7vr6NPf9Y8tFWEphqT2ci
         CUmYCAx1du6CfA2Y7RUH9Rhj0+sb7EEk4zD6loUv2RlQJPOss7C/t7bOPb7DWQsWDxwH
         Ji5gydLVHBPSAjiUszBhR1v1X8FzXxj13BcPPLm+A78PYz51hn08XUFUzMOBd0HCBdA+
         vnZw==
X-Forwarded-Encrypted: i=1; AHgh+RpvWTv5KN2y4e8GR8Xm9utqCtBf+b/z5Yzy4+rZjXGn07YXkjFO/tb9iQ9YR7vkyuuJLc1rPr42zQ==@kvack.org
X-Gm-Message-State: AOJu0Yy4iDkgq2c+m7Z7cmd0KFr4anNN1IzdLwBpfuT3/6AHNuCVmZLh
	lAT7PpQMy7CfrU4O7ic8nzzp8a+IR7/9w2SPIyEPmM/pAb/Ti+0Xfzxm
X-Gm-Gg: AR+sD119eEULS0ax6gShcjAJNVzVh++f8lJgXDVHP5rHwA7D/h3XDc5xlf3r1sUNsZd
	cyf9EqgfWiVElmQRR98Z8jdozYTU4/C2tgzp3TRbqUswm6YPHj5ypLM8elF2u2ZYhSAKW+NzLEe
	yOL14QiKaQO5nB1E9xVKHJg1TKrlt2AxqMFeG/JRHq+6zaeIGjlfflpMqTTGOhnVyeIQm2Yx0GT
	FvgWzAuv7P72x0SJLYcEtuLRTcU1UyFEuIwagSFXExDHIGpHxdLXRnJ7oXk5Kzg+NF5clKT8CuM
	XBIt1WIgulm6zRZcFBnAdIVtV4V7ddENHBWaOi0/W2zBB9oA2QkuntXuYwDeWWoVX6150LC8rkN
	9J8mhlmT94pswB1zlLzSL9aZjCrzWmIucdRUZ3oDD/j4OY8nkN92oDD7yabN+BoNYV+G1wELWcI
	GQOKcIFwsO/+p33FFQmSru7Y7a0uzzJNuX3TI+clmo+zd9xN1HAu8oVw7Wlvg=
X-Received: by 2002:a05:600c:a182:b0:495:6478:2dbc with SMTP id 5b1f17b1804b1-49800e70248mr12017065e9.6.1785397938314;
        Thu, 30 Jul 2026 00:52:18 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49800f19bb3sm37302585e9.4.2026.07.30.00.52.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Jul 2026 00:52:17 -0700 (PDT)
Date: Thu, 30 Jul 2026 07:52:17 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v2 2/7] mm/khugepaged: extract young page check into
 collapse_is_referenced() helper
Message-ID: <20260730075217.qulyrc5s7olumqzp@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260715025941.1571316-1-npache@redhat.com>
 <20260715025941.1571316-3-npache@redhat.com>
 <ffb091ee-affe-41b2-939c-6437dd9cc13e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffb091ee-affe-41b2-939c-6437dd9cc13e@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: ics8go4pd88otpos3aubfnk53bjcogc5
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DC493A0006
X-Rspam-User: 
X-HE-Tag: 1785397939-736442
X-HE-Meta: U2FsdGVkX1/1zWGgehXWFr0MIlG51z4Muh+gkbQyvCtAQy2CASl9YmXVxSS4fx3MB7Yx++ocIeUiLW/ZAuM0HcZDWIStoOSSHB01tEG2YU/6I874C32HFf95jfV1AbEvjtmClwOZDT95XA+0eCjWenLkefaYoh6khN5yZWG69bW2OhWy1JtZhimWvdL8IEomd8HPTYdkqg6lw8OS+fbwo8NdOIeWbv+i1rUBWlwzAnX1EaBAd3W3H3f8nyB3BNFVrWtEtovUci9WtZca/9RLojF1Q2z1FlJ/D7V+GBO67PLKyP7gQ0e5bh+UCPcmFCtfh7CoarldFoGLQTK7ZDTNJzp9kltSUdwRsdX+KBb1V9rdHwlFSQJtY/k0kLnIKWlkD+NkWR/UI0phzZgz9jjKpFde3hwsRnuLKv0/a9ubrvMLH3VS6Yz+pCmYy62lGexroBqHvWqCYfnw18lFHfj6PuLkJ+F9DMX1CZYwogYvEzTVTs5jkD9aqDFcDbpjZ1yqhwj2uiMpNEfXKRwg8xaFW5JV/DuiSoujmsHcKW1HEzrR7EMfuYR6r41rzmn1YJsiQYJZXQog3zPJNdvZo4h7cGsSKPRO/jzRoSfSQqU1I+pszw6sIHR3Nf+zIvL7nZhh9b+ujG/UaspJADrawXCt0NvxqLv8+m7/EWxeksCrCjtcfO25l8MFT+F42EGWU069/5YKFXgjn6ctVqA59l0jcKWjo4+Cv+jcGxv6wxgvPqmVODo/0SChZoPESiIyVxGFMJyDYuY9VH60HkoPB45W+bIkpri1plboLOHUzFWjNZJB1znZmasH9fWnMYhoxJ5+thXUmGSaSaATi9TLqUj1H/0R5lqF0a/oC27PuMXrPECjctNGpYwSgl11uFd6+t+Yqj1kl6FZfmouQ+QdCcBz/v2NAtfiDPfiKzsqt16S1TeuyaguxAzntdcC5j8kkOeN4JdUMJzyNF0q9eFazxK
 8b0O7wH/
 0KYWTRxZZ3n8Uywg0/0Y92kv4SXnCdppdFwfTTmCcL14mMfhzolqizQEskXUx1L8Pb0WDfC9Hqn8AP+XlbIEkVFnFq2HJ8losSqO1hDpIKlB3E5PsxWeuORPBNSGUvhQx6MxJB8yqtCaGrBN4xrmc8oE0olk3mwtEe65EZPjsWJqHVEwrF0S5p9DK5oVSawQT3sY8VSzVcPQxGf1kg3yiH004niYeI3idIFoSpzxZVx8/xUQtNmXaFgPs5annxqOMohfa/sMzzgp+MaJnNB42Rmp/fiXq0+1svdLMT8p4hKTp7wzt8j29Jc7P+HsnEDBB38OZJhuDoZSUwyGnLkJMNdrxL3sEnVwrnVunKzGGoHqMYnsAoL2HB9dwDLTwCODk4327vHdy3gnbmfmU57CZrhL6TmmJ56rcD1vh/WlBMMUWbudmFlfsCPJ3kfHyOaghm96J/fAFVtqeQTaYemnYXob+Gyrwe7qeEpM8/c02+2x+jQf2HxgZ1WqBzM/ibGVvnkbW36RY1urdjnMyECQnE/4X0wVIeev/jIFI6D89cQlZrQid3p0rjOK9YlMr/ZHHx0i4KuoPka2j+TjhVb/xIWaFD9mCDSUmZJLA6wjhKXocj85RUfgPdtGqbAyKR4/n8cY7CMzKw7aQq55XiLLbaoeKrGnbUi382lLOtQHm5uUEjWvJ5/P9uwoO/34LowAVp5kWobqTiFmFwqq82anrVl3usA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 11:47:00AM +0200, David Hildenbrand (Arm) wrote:
>On 7/15/26 04:59, Nico Pache wrote:
>> This change deduplicates the "is this PTE/folio referenced enough to be
>> considered for a collapse" condition that was repeated in both
>> __collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
>> a single inline helper function.
>> 
>> Also move the comment and use it as the function header. While we are at
>> it, updated the comment to clarify that a young pte is a recently accessed
>> one.
>> 
>> Acked-by: Usama Arif <usama.arif@linux.dev>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>> ---
>
>Also, do we really need this (badly named :) ) helper given that there will only
>be a single invocation after #5?
>

Hi, David

I see collapse_is_referenced() is invoked by collapse_scan_pmd() and
__collapse_huge_page_isolate() after applying the whole series.

I didn't see #5 refactor this out. Or I missed something?

>-- 
>Cheers,
>
>David

-- 
Wei Yang
Help you, Help me

