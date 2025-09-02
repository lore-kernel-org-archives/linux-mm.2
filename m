Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E581CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:11:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3A886B0006; Tue,  2 Sep 2025 04:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B10596B0007; Tue,  2 Sep 2025 04:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989C96B0008; Tue,  2 Sep 2025 04:11:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E9406B0006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:11:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 165CC140B5D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:11:14 +0000 (UTC)
X-FDA: 83843590068.30.048EA42
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id C2C2B40002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:11:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cOtDZtiH;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4MWf5Tj42XyG4g8ZZ+nHXLySkFy5Z+t+SpLs9FN6OQ=;
	b=r2mcpwUBqcK95Bd/0EWIl/06uzkGNB1A/QPVN23776sN7fOGA6RElOAMmfZueYP/NjGvSj
	eBnGZ9reGp/WoLIuFZSyDE2wsUv0t9fl4aoPEBJjNdrfpYlP5caaNJaePgLg5AizW2sH7C
	JhioRykkvI8QmwJqOTnEhe1yyMxyq+k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cOtDZtiH;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756800671; a=rsa-sha256;
	cv=none;
	b=1G/KURTs4/InUj5oYP9SnfCyC/ZKZMKTfjVsLP0rkirBJ7hInFNrcYy6gzQXnWLkIxIYeN
	UV4eNU526S5Ax0Lo4jUDCCp5wiEKHeQ7kQHydkoGYYgLI5DokxBa7Yb1qiwsMx4ONInqI7
	IKd+061LSbB/XOukjo3Ff3GTeKPI0wg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756800671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w4MWf5Tj42XyG4g8ZZ+nHXLySkFy5Z+t+SpLs9FN6OQ=;
	b=cOtDZtiHArld1qfZVKyzv7vcPqUS8Kkt3fQpoBUc6uG7GaDPwFtN/n2oytKB3cBwLKK9gC
	/S+6jMcz6RF1VBv1oE0aRE7bhUe8Sk09laxPL5mjc52gCluTLBoAI7WMBPzOCW8O+Bangf
	89RdQybBBcmNXKvTcsx9WvIyCG5WVik=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-324-esYR-pN6NkSm1BHzlxEWwA-1; Tue, 02 Sep 2025 04:11:09 -0400
X-MC-Unique: esYR-pN6NkSm1BHzlxEWwA-1
X-Mimecast-MFC-AGG-ID: esYR-pN6NkSm1BHzlxEWwA_1756800668
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b8b7d66adso9508045e9.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:11:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756800668; x=1757405468;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w4MWf5Tj42XyG4g8ZZ+nHXLySkFy5Z+t+SpLs9FN6OQ=;
        b=fPRoI790J+p0nAXq2w45eubjwB+Q0YJ7acc1UVOgYF0NAm6pSz6U85o+QVkQYYUy2w
         GSPWLugDx8NXFKQtSEuOcFwW//ozrrTsI8caxmT4tzZCNFQgNHOQpeQbosYXhnNeDUli
         vaYQVRPz5YHCPrhcBe+I1gXBftfdkU+jE3wlB5mx80gv8Ut1UtuLdH+mTVoBhdNYG8QL
         fSCTETl5/A4QVt7cv0Snn2znrF9F9/R8cIrscBWGTMU2ruulnmBQNLesBrtzBUUadcG7
         IVYGzwCq1DPA3ahlVBzuzh2naqC1F/05N6EXSgSxm53aXlHsxgCfYVIqNfL1UBRj7XDs
         wX5A==
X-Forwarded-Encrypted: i=1; AJvYcCXxgoxz1fG+j2d0oipG0eFJNThQbidM9ccy9rEmxxmQuICg07ZIEiLIHIloB3aNZ1udUYUcIWPiuQ==@kvack.org
X-Gm-Message-State: AOJu0YxkHxXeomdPPfwFPcQSfNMV/zoUSHqBCl6y6zetnUrJEZfZBJ2t
	J8ILylDGDoHRmR/LW+ZKbhLJCeF9dLTI1XGWeM/jjH6mNyi7dslaxvWCWzw7SINp1bJtVNOkVa+
	7ywsemWT459gIW98L5GSOre5e6DWhhEVrXicZkdmuQiBGWi4WHS43
X-Gm-Gg: ASbGnculBWd+QuA7KJhGCA/x7f87r1jnUqMK95FQMDzAEczo6YdKk9pGeaMbhu18o0z
	ZJS5YfX0pRppft9bjq5WgWkbWokWfzCV2rGBT6We84AL6AyoQllZZe8OqSPyCQ24Zenz0arEvi4
	LyCagP9xCvvvHM/Y9DfNYptwl6Rb2NNJtPVNEXDff3AehuFpM+1f9EUpn91DgPqbIMq88ctAcW0
	RGSmvWbwRKU/48/dPj1Eio1hjHtaQD0V/769wqu08UMcAuU9uvXZliAJJ+rki80l9Kx0Gs2aGPC
	mJMAAhFJw0A+tL9D264Vgxm6tNh3Ex5IrYBLh0uYNO9+dOc3pio6Wyz4xlDpIKT34Pu1Aw3U7Hv
	4L8n+oSqF7Q+jVx74gH/bKIZxq+PKq9ZWhy17SyfH4U+v/a+oxgMpI6+FKhqgdH+ECBU=
X-Received: by 2002:a05:600c:1e89:b0:45b:88c6:70a2 with SMTP id 5b1f17b1804b1-45b88c67360mr71590335e9.1.1756800668338;
        Tue, 02 Sep 2025 01:11:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1u/GPZRrAk5+4OF8Grl0TirFQTXJJs3FiBdxsp7971JurAJnmwDEqUWzkf0hTf7n/W9m6vg==
X-Received: by 2002:a05:600c:1e89:b0:45b:88c6:70a2 with SMTP id 5b1f17b1804b1-45b88c67360mr71589695e9.1.1756800667854;
        Tue, 02 Sep 2025 01:11:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b98c95c77sm10525715e9.7.2025.09.02.01.11.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 01:11:07 -0700 (PDT)
Message-ID: <12bb3414-2ca8-4384-80e5-81889f2bd35f@redhat.com>
Date: Tue, 2 Sep 2025 10:11:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/12] mm: constify highmem related functions for
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
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
 <20250901205021.3573313-13-max.kellermann@ionos.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901205021.3573313-13-max.kellermann@ionos.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zV00l5NFX_qDUa6gPEpv8y3sBReXexroH5Z30EWXtno_1756800668
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ae961by3atkbndjyzgrtwfws7nzaf4hr
X-Rspam-User: 
X-Rspamd-Queue-Id: C2C2B40002
X-Rspamd-Server: rspam01
X-HE-Tag: 1756800671-211430
X-HE-Meta: U2FsdGVkX18FQRQg+vO8HdSDymPEkHAjdJXqaCRslfVEfymBD6CrICmU32DEzawt0uJLnDK5An4nLNy/9W1S4+N6qt34aRh01NStbNtT5VhgT+47fNPRbd7MXxMuoZBCnCjdHGzE9KeaQyb0kp39waNRNNGHIjRkYX14mg0A6p8pG8skxyMDscroCuz5eoF4cNT7wGQtOmGK96HWt88ugURuvKghnbPjhlrbG09lLbrPRHxAbmaBNwQrZSsdv2Qy3yjnZDX1c9Mbkc/TO70A0VRYCIgQ2CWSp3YHUrTA3w8VgZ08kjVEqCmT9TwcMjZoqvTJabv//DhbkEk1coPcEvzWXcSdlN6g8gYe7mnkM6plelrxSuRX1jEUMbKETJCiPtMMFMvzVqFkQH0Ou1JCFQH+gOTniQGMvB7wPKeMGGhjtzhkFMZslC2mswKh4a5WIyNUB6ZiNH63qXX5rOKCPg0sH6WX/IGHQvI1ZLD14Q5zPA4/7TDwflv7jqUU1b+Orzew/a/1rreaTpKYBoD8t0q7Km+t7f0Eo/szIIluVrnrTanmjHAqns2GlXMB7KxaQJIyok+V5tAjQwL/WQaoo+VkBYv9RnT+EpWBh5zGqjccugId9oHYUkwmey78vgxmMlErGl6U+bk5PIDMnQFa2VvEpcUd+kPCoKYhLSL1jaT/y8pjSHGQxfS9APCj65rpAGO/PkI8btw8G659gI0DfDoUt/YVoWSaCZXBaxZX5XGGvZoDNTqgdQd4cCCOsN9jinfCOb+nS4S7ZeTXHvgggG9sqhG092SQ7/te2IOzButbXBdCnS2fjogyZ0M15YsneeTX/5gibeEZZd1pax5tYDLa264VuOG28tIqmUCmTrQOKVC9PPzeLi6VP0NWgPQsGlhzZ8SaEMregYOEgb2XAQlIJGvXf895pDBD2OBM6KIaJoxwNuHT4tu14egDl+2PJYraucTZtftpHLFLhTr
 2agtTl2/
 jE80Q3n5mTDJ1bcDrPj03CPBssh+mWn/IjnigJCRctTv2rIK8HwYhQj8sQECmoFsXALRbEbfDG5tx59xnahd5qK3CKLF+Zujcl9UOx5OLdvb2L2bK6EPGlSNsVK+TJLT2P4GhktlMAVw5yUvhjSQqq2kD5/rlTvLtXvrKSmqUXQutAe6GBgpKBXEJzq48jNLGriI7F2JKijq36v2GDxXLWHEDTWOHYnDNN8N+sBIVR2LBs2sGalNN4MC8Z/2BsfPbYWtrqSj1pLlPYaeLgK2URix6MclhNEkQOJb6t9CjvTh2B2YucQJanSQcI1D8jxzx5yyO8RmJoE7t95qiufP+zjwBrMSGf4Bn/zhYGaDboy5YA3sTpiGrZvlFMmWUuR8AaYfzYPYEUx5KuHkoMSAE2QT3o4htTpQpbSS0y7EFzcNkbUmuh8IVdLtKKaYaRw1PX13Ku7WQNgJNoeWpXuwC1hCNtLJQPFDFY+mZVDlArGdXaqs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 22:50, Max Kellermann wrote:
> Lots of functions in mm/highmem.c do not write to the given pointers
> and do not call functions that take non-const pointers and can
> therefore be constified.
> 
> This includes functions like kunmap() which might be implemented in a
> way that writes to the pointer (e.g. to update reference counters or
> mapping fields), but currently are not.
> 
> kmap() on the other hand cannot be made const because it calls
> set_page_address() which is non-const in some
> architectures/configurations.

Right, we store the address in page->virtual.

It's interesting that kumap() won't set that field to NULL. That seems 
to happen in flush_all_zero_pkmaps(). And we seem to flush during kmap() 
in case we have to empty slots.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


