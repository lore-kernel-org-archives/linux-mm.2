Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F34E8CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 19:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C1F68E0008; Mon,  8 Sep 2025 15:00:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 599EB8E0001; Mon,  8 Sep 2025 15:00:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B07F8E0008; Mon,  8 Sep 2025 15:00:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D10D8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:00:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 111E5B6FC7
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 19:00:04 +0000 (UTC)
X-FDA: 83866997928.24.38077DA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id C072340012
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 19:00:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VBuzmDtY;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757358001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nslG19AZst4YO+kmMNV7wzqM/i0aghl6Sv45Vu73ShU=;
	b=F+oG33xS75JsdMnLc5n5bKIvJWYl4B0/GOgPi5NYg6jD4mEojm5mYGLlDAHQPmagbW+WLu
	PcgTDtW8DE9Dw77zWS++7nqvXcKi+0qPbSzu3lGfxX1OuRWng67AZTUjpMpxwx5o0IAOZy
	zo6WbKCa4VKHvSlZPQgpBtJOsgt+2fM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757358001; a=rsa-sha256;
	cv=none;
	b=FWEuhafFf7nvIcdycwR7dp2ep/006Uwaex8PHMFAxGVTse5xXkXRqQ5nuwvsz+G7oufRbK
	JUy2tlrrgRwvBS/1AwZmdkumW3FCwGm4ybHbPVooQ/sYn/9LCiZ30b8+6QzZMueaJCTtXq
	ms/S2gv1EQ1Rl2e43YO51QlqyGaXQII=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VBuzmDtY;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757358001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nslG19AZst4YO+kmMNV7wzqM/i0aghl6Sv45Vu73ShU=;
	b=VBuzmDtYY+fBZKjj8TqKuXxwFtjB6RIUb8PmyuBYP9jrtTI27hObiBefNbXYIyhUO9VnlQ
	13j335Yirn+c1GCm8DatccBJIlwL2s+nW0tYtUArhqNFLqdWzV1SIesuHIqkAmH0H+Tbqs
	b09mqYacC70QqH0CQatoXjS2AGAeyw8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-240-s59OWxQGOAm7bJQKFgjkcw-1; Mon, 08 Sep 2025 14:59:59 -0400
X-MC-Unique: s59OWxQGOAm7bJQKFgjkcw-1
X-Mimecast-MFC-AGG-ID: s59OWxQGOAm7bJQKFgjkcw_1757357998
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3e3f8616125so2168027f8f.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 11:59:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757357998; x=1757962798;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nslG19AZst4YO+kmMNV7wzqM/i0aghl6Sv45Vu73ShU=;
        b=qioSfxKbG4D22nxaqU12DZO8Cu6pqbgdvyGbcM4Rr5GkWTnJZ91YWrcZoYzYhdlr2u
         6LcTYsu5DbJTW1z6LHSK/3dhBcYZHRXhaXK3J8aXMbRJR9Dw8tMzYuXCL0dmQ/WaP4NR
         XbiNHzkPUkj3SAXqbrhehNP5/YF+bYJlqN9AZI2ZKil4is3dr4QbvZ0zI3bxFyRceZn9
         OnGh3VrqfzcaINJaYCpgYbTclhC1VhWyKtgGmGHL8TczbFwsJolxDKIaf/HdLkmDTZkH
         dbzQKcA1xma83gGzmEMqqVaw+HPeeJqCglbYgZwEUDtIMl1nIDvz6uejKhc1l0w6dEC9
         RCRw==
X-Gm-Message-State: AOJu0Yy3tJvdcbGlwFmu6DWHsmAE5+cIn+ptAHGXVhSMiBHW+ffHDHC4
	KdlOEnXCZh7V2fgwuhBr6xZuEmPmfXoICakXTT50tg1QfLG6U2g7V+wBcds2lvsfk/PbFwwMliv
	CijSFT2jHttNuKMKQouwshxDyoxw5F/gtHOnXNSyb5hJNtag2pz7G
X-Gm-Gg: ASbGnctqhgiFAGyj9TQuVNFZ2EvIr6km5qPZutg78KddbiVtpUgP5GrwOq8nEbwCZcb
	1FYdBmYJ5AZy+UEFHMRjjcsrWKQu5XN3qiqvCr0d9cYaj0tmUj6QEKKJ0HBUV2m2ZJ0wK6puyxR
	zvt33r4n4aTHbd5TIU4yWFZnFwPoppxuMbHiMksthOalZima3+j7sEcIsYA+gHCLesTi1FXILiB
	staZGWIt/AzGcS1BrSQQHGEA56MjazyHCyrOkGRGnci7K1rYk4bL7yMvDaZGg/5BbSqXxMT5J33
	U6UV4YFeb+Jd7mAqAvv6OmMZmT+SOEUgsgCOoDB8+C2blOcl8FAMOa/86ql+4tYYKTk9OdEq9jI
	u0hApLg/wKI+oW8Rqi29XmR/+iPBsIlL0pMDjWWxMZo4g0MnLubaHpGJFxcK747Ev
X-Received: by 2002:a05:6000:1a8d:b0:3ce:25b2:74d7 with SMTP id ffacd0b85a97d-3e62a10df5amr5664317f8f.20.1757357998339;
        Mon, 08 Sep 2025 11:59:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+Zj8ITv/9ebud5ir8J5xqVgQfOO1EeHZLfCNgykshmv6cSBq0PDd0OjcET7en1ze6PmG6Uw==
X-Received: by 2002:a05:6000:1a8d:b0:3ce:25b2:74d7 with SMTP id ffacd0b85a97d-3e62a10df5amr5664302f8f.20.1757357997969;
        Mon, 08 Sep 2025 11:59:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e411219ddfsm13436880f8f.57.2025.09.08.11.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 11:59:57 -0700 (PDT)
Message-ID: <dd1f158d-3e94-4251-b3ab-9971803f32f3@redhat.com>
Date: Mon, 8 Sep 2025 20:59:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] ptdesc: Remove references to folios from
 __pagetable_ctor() and pagetable_dtor()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Vishal Moola <vishal.moola@gmail.com>
References: <20250908171104.2409217-1-willy@infradead.org>
 <20250908171104.2409217-3-willy@infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250908171104.2409217-3-willy@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JJD3jMWQR0GyW4RWwxLLY8ull515DRuamuvZyZ-URyo_1757357998
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: foafg8omefbwh7cdp7quzbgbu6w9mr4k
X-Rspamd-Queue-Id: C072340012
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757358001-837792
X-HE-Meta: U2FsdGVkX1+So8ybwpZvMZr4njZ41k5uKJV5xkuqvZzQgX7aPde8g6ZrBEUdmhVxA+cGhox+0eECn3s8Ei34glIyCrcvSl1R/97aj3ZF0uKDfm5FvGAPW0LjUu4pl1l9dRbWGMT6QPnytq39sAj2DAL7fHEyF9F8+a4Y8hMh7YN2BYA5YYBPS7FurZqpcFWlnySRssKw71PWT7BqBMWZ9SjxgKCraZWcRGhPWojNmGsrX8HNABjO5BOiErALh3/CIkfez8G9K3UyfpVxGoYENWvhmUnstruIV4GeKeNyFZdNAU/M0ZIurPfxyz9DqlXEdpgDbsQALEQQlxoAFu0559w0T5ddlM3i2rv8wPlJt98qa+7NyYIP413Ev3wReq/Y6tb7JxbSa9HUUOGy9F0zjU9boV49vAXYVm/JA4Y7NTSZ4mLNzDNe20SlTEqewi3YWL8coqGJSNPmMYtNu6MhMslr2i85eu3J9HtLAhqjgjKoUz0IMMgMZFwBwrM1f9Fjtu+4lh5Db6XEdJYfTezjXqKLJ874hAfFgaS6UwHEAFcMspR2/IR8c0YllMVnaroA3NHqUvRvqdItigSQBAl2i5uO9Id8cYOWKqJLZVeLyi3F7Q1gFJkjGR2YiRfjycwzevqpHuWmLZ8sb4bvE7YCJHdowRTze1u0D37TW5B4ovU5l5zIxG5llzELdTM66YUtGGGTOoyMgvu0mFLQa9mNwsQBxbD/1RGf5wObYadD352kczpEwYc9p7axd+xbQjAOsJbP2nZfIqe9lgPPu7JsVuRNFga9CtBDbpxbB0O2ZHj8XdYu4cWC/W6mPnn4m7hxLhRzzXVz4xazi7FcOmEJDevtVbENOKORs7bJnytcnx0Kp7tEZabcPGxO1ESAt5sVqfenfOXUlTehfKRK2XylgYhJiuHnj7jHVvPO7gC3bu29mfsCKx84JPndFbCL3S7hfymxayRPPoC9REWbdWB
 leL71Ph7
 5YI4QvRtE3kG9gGp2BR3VCeU75KM1g3fFmyVBYMiu0x3jDrfS9/qwNYyXjoXoPmnFRH/pS72DA89ZaD9wF6Mz/wDX4szfkEzhlgb75BC7Huh1Qt9ipZ/HMYVpn33715zZXY9UaJEwcobUQ6gWsADkaA8V9Nu3vKWwfa81XgqbyhcSk0RVbSdBL1H3/yM3q/X+vd/ugp74K6NV/HsZG9/gaNyHdx3na3BVPd1q7p2SKMSCJSqpKXVZeDbCcNGYFqYkmZcutPkhd83q0ePpFyIhfxeG8yIY3rFCMrFGyCPGT/fuw3mZ+4fNy7eWKxVrkBtjoW6SjpW1dMXU5U6+9fPECAXAGwGiAVTUT7pzlSuCYVQrJNw0urZYlNhIJovfS9HeoH/11cA5afJCWagSFRnQenyZTA5IspY70D5OLnRewA8jq7DZvuvXPB/9QNIYCBJHD6OJqw/WO/Dk8SXZfMyBtqU2FP3v1Y2eGpJmtpueCn7TKte7pSvqZB2H/FGJp28Xk8D2r/br5VyRwCDv0qxXDF7ck1pl6wJi3+2G1XChyzn49IpIacq+T6j+VXKOhkvU2EaXqDrjq8i1zBgnmOVBoFgLqmZEE/0baZer1fUjJRBvCKE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 19:11, Matthew Wilcox (Oracle) wrote:
> In preparation for splitting struct ptdesc from struct page and struct
> folio, remove mentions of struct folio from these functions.  Introduce
> ptdesc_nr_pages() to avoid using lruvec_stat_add/sub_folio()
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


