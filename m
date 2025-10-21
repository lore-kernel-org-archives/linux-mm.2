Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A11A8CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 14:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74CB68E0003; Tue, 21 Oct 2025 10:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 724658E0002; Tue, 21 Oct 2025 10:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A278E0003; Tue, 21 Oct 2025 10:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 523D08E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:51:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E105E13B50B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:51:40 +0000 (UTC)
X-FDA: 84022410360.27.2F501C6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5459380008
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:51:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gW4fOR2z;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761058298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3fQqPMI0bySJ5EX6wn5xGDqe/3HW56mcO1ohR5OxkgI=;
	b=0WJVeYafWXhdqzsH8xYodgUZmJ6timu/6kS0JT18/uNrwLyHIL2pqumdODwxq+2dANSQkb
	Nn+v5eC69FZfaFNPrXsiGFtaRn8QBjku+pHdEzOCz0fle7+hSxW/yphTYrEkAHmlMhKd9Z
	Ouvy0hs2fs56dGlvp73T46T5Xnfx62M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761058298; a=rsa-sha256;
	cv=none;
	b=GDOzCJ1lWevX8KPnE0A16yGY8v1DQSsOeLXMvGSdk91FTF0mfSok73gMMWbojeNtxi7Rmd
	8qus25AZEUSpCMOyoKyQ3p+CQ0NJnII9jlpM53EJ4E5zXhcq4aEhsIDiE7nZlexnvaHNkc
	gGqF3Mmiy68vRqty56cnWg6Rk3v5V1s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gW4fOR2z;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761058297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3fQqPMI0bySJ5EX6wn5xGDqe/3HW56mcO1ohR5OxkgI=;
	b=gW4fOR2z+r4WtUIGLnf036MmcO/J4kOn/beSVzxg4ZI5pIxM3aYBsoih/OtMB2HMZSlRv0
	t/5maLLLeukrqF0IcInw5Rsnssk2c50hF325nu1hPiH+wqW8wen9NdpCsJqOI6nyO0ACWz
	RDeLcyWISrgV7FY5bg5+43ER5/Vy28A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-YQdmw8LDNL-4BlEdVMY8AQ-1; Tue, 21 Oct 2025 10:51:35 -0400
X-MC-Unique: YQdmw8LDNL-4BlEdVMY8AQ-1
X-Mimecast-MFC-AGG-ID: YQdmw8LDNL-4BlEdVMY8AQ_1761058294
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-426feed0016so2167800f8f.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:51:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761058294; x=1761663094;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3fQqPMI0bySJ5EX6wn5xGDqe/3HW56mcO1ohR5OxkgI=;
        b=UKlJ95QHP12R830+cWl/n5OnExZ+0LaoIbesyNwy7JsiijY9xVwnCjWGsBa6Clyo4h
         0GBfA42Wv8uwl1/L+A0LwwuCWvCLiEALTB4vIhqr4vRDgJJC3stb4aOoHylTrlBnKdwQ
         aKImcfLMJCkiOAcVuqCp7g16lgKCevGiKlx0fcaq7BmTu992UYnMTLvL+tLSwy34lWaZ
         yL+/z2TUSDi16TK+SM9wxyAmIs6F0G53XxSs9qtOmwULaON/mOTTqDhATXWw4pqjIpBi
         qRxr9PIGuQk8rCwL4rRn1RIeSaZ2Zzbsf7hXBVtmPo2v1NVhf3e1pfWeQlRm4/E3VaL/
         wJzQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3SQROr5cYg5kqcr2OL3sFgsfJyVY19phvug/JetUcjXyQmTzmak8Lw64OLU2j1s0TpRoiXwgCkA==@kvack.org
X-Gm-Message-State: AOJu0Yymdr/ifA6hVAzSQqID9ESTor2ImNOYS/OBm4WS6/GhFOFkwMDe
	+qP1QV8pfVqmjWgZ5erBBOQAFklxE+8s3J45fgYwWtbNQbjOCD2kR70TPsfLBVNqf4Qf9JmTrks
	A0FiQoFAFCImZu2f5jtK6otWX+4OlP+Uxx1/7yzXZfqVMQKSqaaot
X-Gm-Gg: ASbGnctSj/GpGjx1dWaa5HddKf6JIE2TESjnzj2UUgaXwtsGuwQD/+flae10QpwUsEC
	dLMSDuSZd7hv1bTq9KgmF7GtQUxMoMBfclTAS288m+gTTmOHbVb5qYA06NzFQSorzMZ6cMdxFRU
	+HRKSv3nqH1um2Z/bRjlfcN0Nz1XZeIJUeTrAW3EL5o7haTkGN2TYQEkiVvMB5UdEkYhwcB+f44
	nheS/HVIF/XfIpRlSS3eGiI2IfO35XgJl52a0icJzetxRPKOzzJOuCSakFuW4zEJ0Fo768ryijx
	A0kCwfItuXFQQYOqbqLSr1I1nb/H1NviVrqwRe0s2tk9ntMUyF5LtGKhJq4kXaEUgDllvT9aE6+
	HPEsvAOmMjIhHCHylRnVrZuHjGcxzdzrU0/ART7ZbSXV375Rg/fppgDetrZsqeqxrF1TsJggkXG
	Pg2yI+LB5fV6TCKxjFCJ/Y+3D8Aro=
X-Received: by 2002:a05:6000:400a:b0:3ee:3dce:f672 with SMTP id ffacd0b85a97d-42704d146c1mr9781060f8f.4.1761058294274;
        Tue, 21 Oct 2025 07:51:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzosmlWh3/P+YB7nAbBiJ3utPf/hRomXYGIIhrnu8Fdc/hu40WdTxCW6Sx3UdA0t9/yDMZfA==
X-Received: by 2002:a05:6000:400a:b0:3ee:3dce:f672 with SMTP id ffacd0b85a97d-42704d146c1mr9781045f8f.4.1761058293882;
        Tue, 21 Oct 2025 07:51:33 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5a1505sm20941015f8f.8.2025.10.21.07.51.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 07:51:33 -0700 (PDT)
Message-ID: <05eb8d64-bff0-411d-9488-d2fb47c66a2e@redhat.com>
Date: Tue, 21 Oct 2025 16:51:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2] mm/khugepaged: Factor out common logic in
 [scan,alloc]_sleep_millisecs_store()
To: Leon Hwang <leon.hwang@linux.dev>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251021134431.26488-1-leon.hwang@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251021134431.26488-1-leon.hwang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: p4a1yvXN9aKjYsSdv8z1rJf92I0_v3hcwAsj1-E7ozw_1761058294
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5459380008
X-Rspamd-Server: rspam02
X-Stat-Signature: rjhmeq9qu15pfjqa7kcqpud5knancxi6
X-HE-Tag: 1761058298-595726
X-HE-Meta: U2FsdGVkX19aYJfAnkjTLG9CvBkCG+j80uMbx7fm5sGlPFyPaaxsNWY9o+bUT+7YZZOi1iMzbQMxE2JYl64GGwY6jlWUSJyFUcYkIybK0B+aw2BWURHh6E0OSK2OEIhKBMBKd834q/O4AhJZcbFie/ZxQ70zyafpsauh/8O4KkzLmwM/oYtphgp+HcKY2X6qUPdxyJe+VRywIC67XZuCA0yr3zaVnxvK5tqrcX1SuHzPaV0l15rwUv9qu+MO5gY/iaC2vDim+m591If5v2JbfvlqPgIvAbYfPe3yqVRIyGdQxpnjTHMTBbhJQxfV7P3Bx4cQso4tECRF2DQXM6+tQsrPgfb2UseK8iefCBnMFDUCG2Z9ezHxqTP8UBCLQWx8VugytJtmSzMUeV9xgZeI+gWzEpwG5NCP1ZQS3c8M4CjnwxLs75KuwxUIR7YqNGwWsh6ip/+BnCEdgIIg0e9dv8GQ9E2GF2whYLP/9rckd/i11TpASaRrVIox0w3YCzlLR/s8ifjiRiTNvP7t2/d7IoazWsJFvdcdb8IFRvvbNmMltyLdkz5SMopcjtOIVfEh9V/38uIl0JpXKmRRxnBJKV6Kjfb3ggCnatJTM4pC0N0HnJ4T7R9p6ehuz4Epl0fh8W1vdjanFHvnApjnV1ApLyRhdnGwlcOrH7vuLyDxQ1XyCPbJvkznqycrQCOeT/QLQzR5EmSd5PywRuacDn0hfqBpxvudNRg0aSD74YunTbZCpQoBJmdAms2xn4ryvsBSkDrKD1wAa8NyptgCltqfBSX7xdblI7ojYltdRDhbmVB6JLUT5oOtHPblE1VSft75XgQpwFpk6Q6KOhKceLCD1HfXZhe5YMaSrkxKMkvVEKWLgZ8/FKndzfYG0QKgGQxngCthHCOmjDBZRsQRhAPFviDg6wNwoLp0WhUJ+T56f7ez6olq6jMb7kDFYCnENSt8PBSX5gu03gHolNSi0lC
 tmQL3gBN
 vZmG/3BqZT8r5niPvgFDcUCC7JGGymiGCZU2rMhg5lIXFkb+aEP0uK2dEA/UCCZ/caifj386yzOfB7BrbigqcLGeJKlc3q1XyjFo0pE+E9O5CW5FysnUCXsSGTFD+dMZKPBmDfD3BMaYg8vVYkxNSohsQSz0pxqT1d5BHRqi6XlR62VXciWVpnDBwy1Pdeqirw5bl+id135hr58kbv9J+V/R/pyhGK0vEDmc60b4HmHq7uiuWYQ6XQs5/SOHusU3qRJetn4HF9m1fXuJw9qof/v+eHmdYXyLcFuIJnyGM15vE4nhYiwov/bv+AnthnB9TI3HVYketmfUxSvKuhcbYE8cdSJnX7iWXpa0RDStw/xp0VK0ivyZxsL5/PP/V0tjctbkGJoKdDOcrZ4iJZ7JcdiOMuXq2HTJPDjd+lEGEse+MrUtEEcwcRtI7jTW3qDrqHd1T2EGvKlbJvh8fCBSmQCACP9IGC22YiuFnboRfsv2Loelx8xU1pPqTyEOwLeWB/htj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 15:44, Leon Hwang wrote:
> Both scan_sleep_millisecs_store() and alloc_sleep_millisecs_store()
> perform the same operations: parse the input value, update their
> respective sleep interval, reset khugepaged_sleep_expire, and wake up
> the khugepaged thread.
> 
> Factor out this duplicated logic into a helper function
> __sleep_millisecs_store(), and simplify both store functions.
> 
> No functional change intended.
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


