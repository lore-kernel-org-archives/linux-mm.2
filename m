Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0AB4CA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:51:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B2198E0059; Mon,  1 Sep 2025 09:50:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09EF48E0008; Mon,  1 Sep 2025 09:50:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E837F8E0059; Mon,  1 Sep 2025 09:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD2F58E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:50:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7BFE111A401
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:50:25 +0000 (UTC)
X-FDA: 83840816010.14.763D948
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2BB2B100009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:50:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dQsFpe3U;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756734623; a=rsa-sha256;
	cv=none;
	b=2FM8HuTnGyl1HyKuSauQ30CeFAMv+sndWtLaMJJih6rAo9xvymjrnX0oQJS+sRR2yVO7iG
	m3sTL0A87zsmZJvFDAbii8yetl9dz4dp8EoNMWHd4wjIdbDWOJLAIJi26rJqPPuMg8NE81
	N+VJnaQUNEj561R6imx5bPaZomeLiII=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dQsFpe3U;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756734623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fVP4Gr2R7pmDK3dhteEbvY18ucQslE6qh9XfZ+Ur7rc=;
	b=pMCL53frd6gTBiBPlzASlA8kom1Bou007a/AKW+Uq0A9y7Q1pQ4Z4oD5I1zqv2AaS6cUB5
	4q9cqN89uQMGKfNe17wKXzVGdwhIbgRso+FHw8nrP6gbhSao9SbDVBEHbGaCcw5jQIg5BO
	tPyEJbGFaNgh2+BJsy1EQwL1K2YKrzk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756734622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fVP4Gr2R7pmDK3dhteEbvY18ucQslE6qh9XfZ+Ur7rc=;
	b=dQsFpe3UuD/sZUeBy8IqCnWjZBYcyG9ntisuqd/KY+mSCy18Up1yzEMIKIGjUnOjN10b7f
	hcWSR8WYyqv7VaH8Hu3Grgu21uHAtfYh+vRz/W1VdqWeB/NVgcXYNACzwUjErshLQxzL0e
	8xbboi0D8jIpRNjmWqqHwur3IvdC7Uw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-xu6RDzJOMditSNkekBgPZw-1; Mon, 01 Sep 2025 09:50:21 -0400
X-MC-Unique: xu6RDzJOMditSNkekBgPZw-1
X-Mimecast-MFC-AGG-ID: xu6RDzJOMditSNkekBgPZw_1756734620
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3d2edf6af18so882269f8f.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:50:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756734620; x=1757339420;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fVP4Gr2R7pmDK3dhteEbvY18ucQslE6qh9XfZ+Ur7rc=;
        b=UwPRXsZcTBZiWl53J6mP1bOqP+EJHnA3tJsr1n2v7+Q441YXc+pdE40KbF0rxrGXvk
         bRVzkhvleF/5b9LlaBemswiwpwrblllH40m1jDjQASJhQb7fH0lRS1vRihIYMa7FZlPx
         MNYeaZuxRPtVcMTylP8WXuZvEj+1UwwPU2w8Er9G2IAn9PpVsPblcuevLff0oyF2SLq1
         v7R2KIa5YaSvS6jnAD+yu39hO615bVCkixj6U9bwxT7gSLbxhRE1fOCXViAATJkoZTvD
         M5xOtqvBfiXnHUyAOwqa6kAU0B7EHvJxfIgfSy/c11fPCA8NY2zXOhQSuuJBbm92nBk7
         PrgQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuXMXtokM6fOVDtpIUASL3G3qV+rSEzwfp4Fm94ofujFDNW1h7fMAnplQmA9XyBMHWrO23Ooqb5g==@kvack.org
X-Gm-Message-State: AOJu0Yyae26IB8rEEImXY3VVIGR9iBTb/4nj6588NLn1pg+OirrvDmMR
	O9sMFn3sdHllsGCTB4aavJILTE0+n3g7XF8UqJNP+tdd3Ufmz6ymC86PVnji8vBGF6NaQk9QR1J
	5KuFc17xVnOJHQPohWkevwnJl8IgrVCPy61FvMpY8vKqXoER3iMKL
X-Gm-Gg: ASbGncs41Rj7ltBNc1X+TWXyD5gAAj/eDkpdF8ICP8yoBocWBmeEo6m0hijtjKUrCZy
	IbXFYLTLhRojVcEMMAbEtTte6eMzCobFqX1/Y5+LYpYsK1t4dtF/rvDCNvVsBbjlGMEvS59IoR/
	62kgef5P7D7BFVEQe7sDikogqPe5d+2hCOOusC5J8cW3OaUOz8ccaSf7P8KlfILP4Gu2YlZnfLX
	ijGzDMiSq03Jhlm5WnorIz2dQgEd5P21yM3F6zPUoKLACtDwiPN5Vr6djY4E9zhI/0X8jAJDQ3j
	t/duQCr0hYbGrfN9XHt3BpKLfgNGU3KJ+UoLX3TuEC+fUICvHaESKn1H2UzIuAc38vZLe76WRhm
	1nGp6DbDjD8FKRwomXXGH3WdcdaIkZgYdDCMFDuhR68MnRWlCYfxoqIMx8sW1LdQvaH4=
X-Received: by 2002:a05:6000:290d:b0:3d1:721:31c7 with SMTP id ffacd0b85a97d-3d1e03c6916mr6097668f8f.51.1756734620246;
        Mon, 01 Sep 2025 06:50:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGS5YkCDJoe2KLKpyw9PN16pVvmUFSrYqCth5HMHY9aLGpLdyFPeQoI3wQu+Yy0lNdrjSjEcg==
X-Received: by 2002:a05:6000:290d:b0:3d1:721:31c7 with SMTP id ffacd0b85a97d-3d1e03c6916mr6097638f8f.51.1756734619809;
        Mon, 01 Sep 2025 06:50:19 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b813816desm82205115e9.4.2025.09.01.06.50.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 06:50:19 -0700 (PDT)
Message-ID: <9217a23d-45d3-42f2-ba3c-003982868fee@redhat.com>
Date: Mon, 1 Sep 2025 15:50:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/12] mm: constify zone related test functions for
 improved const-correctness
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@HansenPartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-4-max.kellermann@ionos.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901123028.3383461-4-max.kellermann@ionos.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sKWZPkwW3KuvatoxiGziggtQjm7FaOIfkX4IS68EReI_1756734620
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2BB2B100009
X-Stat-Signature: 9tsyut3nomhjes9p7am89z7wschm94tc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756734623-491306
X-HE-Meta: U2FsdGVkX1+2Zv150Ag4Rxn0s9XSa+qayruuFShHcS2NHt0ECA7pED5McYNuCRGRPl4e9om3/ilbPwXXjR1QGJuZvRhpRPjefSVOg5nsL5LXxCng/1gpCiSRkJRofVtd21MhJlgAw/CLI3XVnqA+vLhhYC6kysEasZ29gsoK4JCH501q8FyyuPXDj5kylSu9oCZQFJMogxYJ1p6RIWdUW2ISfmf63+iBAeQLoLER3npdW7P6fCrJlVXkEFyd259GHnvKqgfAgufb9LMFcXZpKHBAzJeJIk0nm7+YzH0UAjJyn/jtlMNbFb+FOOktDD8gB9lEHcTeI1q3qaD8L0mIHPTBYRR641lgMeqlGi5bO7vZoCJ4MmRfuGwWvRoD3NLCb8KqyjmYpGztoU/NBblXRmpbgDBC8OMKwciRdcp0OMCnG9gENZgS2iXVploAfu9GMgVPT0ZYamhbZLD8NU+/c0Jh9hkib+c7V4OVhcBYWMK/tBS/SCqiDVuaX7GwlZOKmxoyGq3GArUcizh6eB8LFYn1J2VE2LdwjU/epHbCEjYOuG4dgGgF/Ne2T11zJP83R64KkQ+pHv5LODYcOZzswQ7SMXyk/EChvKlDb7GabJHK9bntvDR62qBXxE8YDDCwxporj/AfAjqa4D1exG6yTWBbUtoWihAhPj8kO7fJmweRbRZuX3TW5SDdf0xzV3prKZA1eT2NzIylgAv/VIbxvUOtHcAHdaGNmoGiH3qA5oPVT8kJbLYGKqWfl+NSjJV4G2TZWxhveHYodtwoGX5aRwZIQu09KGrQyldeajZAzTIQlDoI30sOfOqSAq9f273IZGRSBsDUB9F3Cd0O7iksyaoHqIjohiDyQwg28/TmZEAhEnEwFzMvXDq8+bmL0tAdqv/TxlMV+YZUIjp1+EYJXt+VLu8aqdoCIqDfMN4HaaIARlcDayY6qOO+XdzCckx3AKsVfEtkP3NEpT8ckr4
 H65OArBW
 GlBfu+S1RyfyYJKtuN9LpQW6SniLg9WRpFpLcR/cMaK3atsdKWVRNV0d1k/tYKirtwmqpWldNJIlZIr7nD9tUy3jRB6Gg/WDZ+6FiUhOKpWbmMq4wU9ZIE3z/puiRWjnuWnE3bqdjAJa8sNyvPNRxdqLgY+7aMFkNH39V7ykj6FewgWi9xHAWEPuDyg/IdLEiwaWGs43+ihAYlBlAGtD+Son+jdKVgASTCg+08rnGd5BYIMx4uWkEzZGCgdjpKb1mYLqxlaHRTz8YnPSbRVkWng6Lra/zAgr45j13j3S/I4JFioAP/DA0p4GPyWeuObiYBf8mdDDXophv8CMcUpXexxgMyhy9vAzcXLaBVEfpqSa1D7KJZ9uapvhw3ADTQHQDUWnRd16nrJGBL6D/Wh1dAiYl824EJPBlXv62N2TACR0/Ir6/PR7gY7RKia6Ayl/lHqYcUwLUb3uKWlr7Ifn15FBH9sNyp4lVcygr+F2Jlidfl4GqEPiZTzPP0RMM/sl1TSwVP49Xhtma5YVC6D4uS6gf4hFghCmy3UDMJ8m3jrDwwjVb6qzEYaHhT+5kTZgl/XLa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 14:30, Max Kellermann wrote:
> We select certain test functions which either invoke each other,
> functions that are already const-ified, or no further functions.
> 
> It is therefore relatively trivial to const-ify them, which
> provides a basis for further const-ification further up the call
> stack.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---

Also some getters hiding in between the test functions.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


