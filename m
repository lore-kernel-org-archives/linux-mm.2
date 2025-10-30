Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C49DBCCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 11:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 132B98E0145; Thu, 30 Oct 2025 07:32:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10AAD8E007D; Thu, 30 Oct 2025 07:32:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14108E0145; Thu, 30 Oct 2025 07:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9C878E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 07:32:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 79E44140414
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:32:41 +0000 (UTC)
X-FDA: 84054568122.28.FE11C1B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 068DF40017
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:32:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JWtwWSHH;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761823959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=syt4FTvtbdwiswAZ/fDirrMVwTV5UaIUqPiBthAi08Q=;
	b=SEP+JDt6AeNLqO3xVe04KrD3Ef8MR9ZY7ZARGrcZPrRY7tXyLnlft92az9y5AKy5i1cCA8
	g/M++G77bSNzzXlSd3peSfYpUqiB9Yy5tVuqG1eMJHSONrn95ESfkK79AAmyG/8HTGlCuo
	HQ6PbTQzDgzHu3FhEVJKDMQHWB0VAMg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JWtwWSHH;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761823959; a=rsa-sha256;
	cv=none;
	b=brCs00Wpyo7n1hpqEybhVu468acK1j6h1qyPejT8yd0jE04zH7vCTv+hxQxX1XPOQPNDpI
	3v12YX9I+t5qp/O1KKtfdD5qsrm71FZdwRnnQoWKYYA7fMCrswW99zGjz6teBn6y1Gh6Tk
	dzcHRwxV+WCVU47Uf6bLFfhScA/VXzU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761823958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=syt4FTvtbdwiswAZ/fDirrMVwTV5UaIUqPiBthAi08Q=;
	b=JWtwWSHHtf+q+UpvLqGn0vChzg0Q/76yh6d/oIfzVa3upIvmzGgpVQSaNASo1l8NVjs5DA
	WCE5NH6/D5GeAJnKI0cOuUPR2aeRoFdKU3L/kd66K0mzfFQ0uuni3ndMm4VmkgX6GNyuPM
	tPAfncvcLdTmQOeTrHiZQq+ZMudQJ0Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-6H7kriwJOf2-epCD17qYPQ-1; Thu, 30 Oct 2025 07:32:37 -0400
X-MC-Unique: 6H7kriwJOf2-epCD17qYPQ-1
X-Mimecast-MFC-AGG-ID: 6H7kriwJOf2-epCD17qYPQ_1761823956
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-427015f63faso542061f8f.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 04:32:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761823956; x=1762428756;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=syt4FTvtbdwiswAZ/fDirrMVwTV5UaIUqPiBthAi08Q=;
        b=HMIgsJJpLmpqMwXmMaXUlaSym6LlsUT95cuBlWLizeOabXPcfJst0IsPZY7AzAQ97H
         81xbmw7e0qyFzof44lLe1mSsI0RKw89wC9csYaaNEngtMHKsUAHbI6w0reIe977sjLzA
         G3U1A5O0p3y/9f5/kRl9IaJO0xx1CPDmUQy9M0C/uGCae7l1eWsAKsZ7Vg5Vr3MEUlvG
         4hIDn4u7aCM++Q6dh4d7v+Lg6OWm6bx2+ilqjbKcTdGkAxEPHRhpInVplqA6qcvmIeUC
         jCEwV/ZnvkPx/9D8VBZgNAMG65iw6Nb3rXDrGbTomhe8XyEQxA6xBoRdw9tAYnxxlqm/
         xnhg==
X-Forwarded-Encrypted: i=1; AJvYcCUC5vAOse17Y6iodKALwH0m+VIRwdznHtQO0hFSbIK18jqSNC58U3VVs6akYGl/LTgiTa29HPuYvQ==@kvack.org
X-Gm-Message-State: AOJu0Yxasb3vJrk+1nIy7GX+rkvc8VE6Q/mAauYYC0TYDD3CHx5qGkMf
	korioZox9ydPcN+CTmNoPdaQy6WJRfY3B9emUHGi5ZVQk1COrzk9XFwpML82m19A1ZTylVOjwtx
	lgNDxNzasgpatGIgY3uQsyOs20rTIIlwyvYYngnNTqRC4FALtEtzv
X-Gm-Gg: ASbGncu+h8jd17SNgoVtaWraDQFyfdhk2QXRonFuoT+SEedlXQ7Yp0ED//RuUXzu6qt
	ie5XG3YCbIDO/Mw/k/yzeadZB3D/UzOvxqNyfuh5OblGJalVkXGTnRXiUfHqkisLE90kDdWv1hl
	VOOJKKZnqq3+pjziOERr51Czm9n50mszNtiLKRd2Ajk13HoEH2DkRO+T8l/hgsdgxy+CESYtzrP
	itW8GXaSq3XsHXl7D9sR+399C6Fk99l3al0/kN9mnfvFENwXcukAq3IEa4BA5EHTCTcoNLtLjJd
	TPFJPG0DgHeYEXiz29/9NEHQo9JxZcZXq2mHyoTEVoXZ6bXTCfI3LdERaKLsrTDpn/VpNI7gcU6
	4lE+SwD1FVhx0CoYqOCLfkBCi+v7OBVv/e6+ngM/AcwdTNkPxeRQ38RsNh0MB3QvsrMC4Fm14vH
	f3Jp1n6ePgh/vKt71HrwKhWb7ILzQ=
X-Received: by 2002:a5d:5f84:0:b0:427:490:68d2 with SMTP id ffacd0b85a97d-429aef77885mr5304854f8f.10.1761823955803;
        Thu, 30 Oct 2025 04:32:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDnTvQ9OrjFxRFD1/geNzCwFgc9KwHnl7pB3XSjGFmYobltgmRk2xkTvmuOYysl1iukCDRuA==
X-Received: by 2002:a5d:5f84:0:b0:427:490:68d2 with SMTP id ffacd0b85a97d-429aef77885mr5304818f8f.10.1761823955337;
        Thu, 30 Oct 2025 04:32:35 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952df3c7sm31046327f8f.40.2025.10.30.04.32.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Oct 2025 04:32:34 -0700 (PDT)
Message-ID: <b40f638e-dbe9-48b1-a431-b3ba10c893a9@redhat.com>
Date: Thu, 30 Oct 2025 12:32:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm: change type of state in struct memory_block
To: Israel Batista <linux@israelbatista.dev.br>, lorenzo.stoakes@oracle.com,
 akpm@linux-foundation.org, linux-mm@kvack.org
Cc: osandov@osandov.com, linux-debuggers@vger.kernel.org
References: <20251029195617.2210700-1-linux@israelbatista.dev.br>
 <20251029195617.2210700-3-linux@israelbatista.dev.br>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251029195617.2210700-3-linux@israelbatista.dev.br>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gZApP1Gumx8dq1f0q0tB0S8UsZtPHI3Dr_-IUhks6f8_1761823956
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9eb9ghns811mc7qsdshdik3fwi3asszj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 068DF40017
X-HE-Tag: 1761823958-36603
X-HE-Meta: U2FsdGVkX1/JZqnglmPghM6c0OUo0RyaajgV7OCT3s0dP4b9DtVoE6zWooSbk44GJn9YRC9SeKTHIRuC2Je4G4BxJTAcyLHphDzhxB1oZvykHNg4FXnEc/0KbO/IHyXyAyKFLumfSYFNyHnPrsAYQ9MVV35KGSxYm9eAgQwZN0lFXssx3yxoSjL3/kYVSom1RzxChIi8KxcqvNSTQQrmgPxlIMOMOcQqWaPISYuRh6GqHUa87I7idO228trgByKIG2Vkq2gafQc7Y9ZYHvNJL1ZOlIH009IFensKBifoWI1WWNsy8KxnEbVg3/k2qE2RwlMcpvTPE/AIdoStLj9ojwXRNKLydN1Ipm0ogHIhnwEG+ZU6uYWbcMZrZiHuL/G+4/nkxRCVEjLxTcZA/uQHjcrjbj5EOZEx5MV6Tx6qr6rYVK5PghWY9ELRnrs1bmr0uiW4JwYAF7zrUr5bMpJT4pQGlro5oqPXqI997Cb6h0R0PckWmSrJBXipYWDrpu0PKcKwuF1F+bq3JJaxZovw3Df7/Va1qTh0F9d7LzRO5c5nu/eDJWvcEg6LMJvKWp0NHU/T9tYleewQDu6+vI0YzK8pMuhGN0WRKh1AeE99AVUfTZ1+Jq0UkS3ms5e1+fPiaDLyAExfeTkjWK/SgTyK6uIzkM99HIkR4vU6+2mVQ4qk8S9seGngdtrP+I2GSKwXO1wG0BXgnXKLQRLmyISk+DK19YPkmW1tdWs6/mbRHgleKhV6lLGhD02fl5R6HHYymlaSMZK3nCWpTjbciOuQwM1Y85Up3qW/uXDorGtDzMqXuqHLTQVOeDY17ggaOMpki+tsSTvwfzNFg7aq7sDTUraTPs0E3PiFzdsvPYmAPx9qpnS3XViErAANxG8ekYt/RrJalS0kQ82HCS4mjPVlO2kFR87fsKaPtQPF747FZNkUrns25YHbZi6MTjDllEDOB/LNLwBdNMa3Rs0eMW5
 +z9jgRZA
 UldvKfNs3NfqK/DB9fwsM/wbH8nqg20ifYv6bM9sI3fnCSTsFhm8DaYOUwf8CUJmmedOiZlKjfOeW6LJqd6ZgRzwqln6umKcX5qbpPQCz+Z+x3vSxHJhZQ2Oio3HzQPtYPKLk8Zta6+6v+rF0h8+3uFFNneNuhpkMHzAtriNUEEB8nGYAhCNisGb9uPNCYstVKKuo9PFam5jisd5Iux2jk29IiXUuFwdjnu8XT7/48iOhqM8s7oGBFDvlO39O1//jeSPN03N59NWGzj5OON7Yj4Wlo7PJPqCc77xzjr2ukzyK1QlOSjFzJhTQ6+3kqEKaW1+kjEhCBDzp7SKZ8wueVTJb3EGqcBCAOWf+5gG3nGTFvjPOCPaK37vFcSVj6fqAlRUyoZKX7d9BNrI7Hy+aBqhiyN3QzU+Deibne6Al4prJFL4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.10.25 20:56, Israel Batista wrote:
> The state of a memory block should be restricted to values specified
> in the documentation of the memory hotplug API. However, since the
> state field in the memory_block struct was defined as an unsigned
> long, this restriction was not enforced at compile time.
> 
> With the introduction of the enum memory_block_state, it is now possible
> to incorporate the desired semantics in the field declaration and
> enforce these restrictions at compile time.
> 
> Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
> ---
>   drivers/base/memory.c  | 2 +-
>   include/linux/memory.h | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 6d84a02cfa5d..3d17dd774947 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -198,7 +198,7 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
>   		break;
>   	default:
>   		WARN_ON(1);
> -		return sysfs_emit(buf, "ERROR-UNKNOWN-%ld\n", mem->state);
> +		return sysfs_emit(buf, "ERROR-UNKNOWN-%d\n", mem->state);
>   	}
>   
>   	return sysfs_emit(buf, "%s\n", output);
> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index f4e358477c6a..36d733283329 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -78,7 +78,7 @@ enum memory_block_state {
>   
>   struct memory_block {
>   	unsigned long start_section_nr;
> -	unsigned long state;		/* serialized by the dev->lock */
> +	enum memory_block_state state; /* serialized by the dev->lock */
>   	int online_type;		/* for passing data to online routine */
>   	int nid;			/* NID for this memory block */
>   	/*

With comment alignment fixed

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


