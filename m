Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24894CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 07:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4CC8E004A; Fri, 24 Oct 2025 03:44:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D5B8E0042; Fri, 24 Oct 2025 03:44:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FE818E004A; Fri, 24 Oct 2025 03:44:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 477648E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 03:44:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34F35160DB5
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:44:53 +0000 (UTC)
X-FDA: 84032221266.12.EB6FFC4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id B55F18000D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:44:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U1iQOodb;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761291891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLrJNSiKylR34j7iZUW55zszPqmRqUTKJERo78AyDog=;
	b=ed0wQT566eeQ4DHZGiIdFUE7/QYujdrbt94Ip/9rsPfEnGUO/Zjm4NGHc5sKQe2BOG+jsL
	1s83GTjI0/6ln4pjrRQG9K7rTOhIN4CYWnNbfMG7gePrz4sYYXaKtuPqlVwSEWyhQbJrPv
	jtFdCcQgiNnaqCNShXnMkkMn5NqXM3E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761291891; a=rsa-sha256;
	cv=none;
	b=B8jmwHlTXE5QQYakUZCUrrtr87blvXnMiozfslD7pGOzZGRApDrzMLJrlIMRfI7w9gVPx0
	v62DSA4+rl8hcVXSFTmpppCiX7BHu/AGBT9FoZA57O947JFm/TqHeg3pt/piFGOy+yIRaE
	7KptX1ljIBx17ezbQCqPdCy8uAj20mE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U1iQOodb;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761291890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cLrJNSiKylR34j7iZUW55zszPqmRqUTKJERo78AyDog=;
	b=U1iQOodblpcicRsYxwWVcsrQAfxGDmYwqrE6rQDZn064P+YpsiFumwvnbmixHkroNS4fjZ
	ie2nHDxZtzxVRA8bxzRYMwxt+PomGdkTKVATyHUoJtDy6YYfByAfITMTyLQQzJs/7SCR3E
	eGhhchJG0vOvv33XPx9nXdf3wnKeEuY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-YjbnLStyMKO-ycap9F1Urg-1; Fri, 24 Oct 2025 03:44:48 -0400
X-MC-Unique: YjbnLStyMKO-ycap9F1Urg-1
X-Mimecast-MFC-AGG-ID: YjbnLStyMKO-ycap9F1Urg_1761291887
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-471201dc0e9so10814125e9.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 00:44:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761291887; x=1761896687;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cLrJNSiKylR34j7iZUW55zszPqmRqUTKJERo78AyDog=;
        b=mNiRRw2GlXEjtUSnm72/CceJ1J2VZI7/h5n8c2v5sLPwCt2MGjrVrm+BWztJV5akgZ
         cz17bUmSadCBoNzOXh/1UWxINU5CO8xz9bk8osvL4FRyrXLpRy4K4+3NfOBNBcvasnRa
         JzME3+QzxxTPbxzg+0Z55Y3FBVzGpK7/lXK+3SVp6Lv5bulnNKYf91PDS1Q2cQfBZ2U/
         pR9/gRiQe0ae1NVlplIzfFYmpDiXNduQkSfBk21m2CfNx6tpWhHYviX2dZXqXKy2mQIh
         Bq1IZPY+2EyP9rJ29jy2VKn7cRuV0U59OEyubEgONf6aUMoc7X2T9DIUf9piRCS/fFxn
         4G6A==
X-Forwarded-Encrypted: i=1; AJvYcCV0Clw1BIwHs8hqpEayo7o9af+X/Jk2bSTR+h3zmwPZVkKNvrXGPZq0NIEk7K/7KxLm1az2BWRUJA==@kvack.org
X-Gm-Message-State: AOJu0Yyk8Gpp05Cu18OQalBqZTXm3gvl5HTLIT12114pSlmQFT0mUUcO
	0t4e6lsJ+ZC3Sfnzc1evFACKGu3GWrPWbMRk41YjTVtx1XcgJVnP8V17dqrL7dRW3GeNIb/6RNG
	WztymdKacn9An7niWzYK0NGCLeYqxxFFLdk+wrSmOA6JvJj9fD+4QMJ0TqCK7
X-Gm-Gg: ASbGnctpTpGg6sumzsC44siqPL+/vjkKuZyv70bK721kjCjMFaf1nqdpxcAjpw6XvYy
	L3ULWS+IGDqk2U0pQDHf7WoE6LkP6OpzH4Gk1inJZl6uiJ9E9sJc4T+UeFQAfiJlzp5/9cJF1OX
	4/n3+4XT35y4oSeSEqZx0O6YLGHjL+DKqD3dpqEQfFrTiRbTLGLaG51fK/tXsMc9PPyqXos9dHG
	rlfGyVX3i3QdKt6oUpM0k/7i4q+dby9SYbUsCbUGYwT1av4t3uHEvSdKGp7v/NMLp+Q5dG5d3Tf
	8dOKqAxExEVOZXQqZyAhGF96jimZM7rM3pnfX1PTdr+YKXNiXLJUtLSAS9sX+W4PI99Z7HTWA27
	HEn7ScyWISWTG2hghOhfu17B01CHtDC8TMD5dfSSau3OVp1qJN/Xwv5Fiwnaw+eMXvuw4C60qnQ
	VjV9Z8DD+IurD8+UVOKTzgXNB1J6g=
X-Received: by 2002:a05:600c:3512:b0:46e:5b74:4858 with SMTP id 5b1f17b1804b1-47117877122mr161139595e9.13.1761291887196;
        Fri, 24 Oct 2025 00:44:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwlvuk9VRwxu76UUh+uMXxcz7U8DQbC7bbY2MIM+6dZR2mZ+SIiDnqoou/qLDOKhlbcxHV9w==
X-Received: by 2002:a05:600c:3512:b0:46e:5b74:4858 with SMTP id 5b1f17b1804b1-47117877122mr161139345e9.13.1761291886817;
        Fri, 24 Oct 2025 00:44:46 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475cad4c81dsm78589885e9.0.2025.10.24.00.44.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 00:44:46 -0700 (PDT)
Message-ID: <38195001-4d89-4bbc-a505-440b139b9608@redhat.com>
Date: Fri, 24 Oct 2025 09:44:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] mm/debug_vm_pgtable: Add [pte|pmd]_mkwrite_novma()
 tests
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Huang Ying <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20251024013137.136926-1-anshuman.khandual@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251024013137.136926-1-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EPYOJd0dviBz4sXxYAB677XvhDhLRh63OKlgOXe7oSs_1761291887
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: scn8rjr68s1gdzt76wjrjqmg9d35baoa
X-Rspam-User: 
X-Rspamd-Queue-Id: B55F18000D
X-HE-Tag: 1761291890-59343
X-HE-Meta: U2FsdGVkX19Q12ddk8ESt0i3x7J/iskYQdIEFR+JqEJOLn5JrXgHn15SA9Y69oErYJLO8bfmx8ZtfpgNqxqkmI4g4LhOdU1t7JeDa/5d8VBex36znacluRjWtk42aGdektCtKa5//QY8JTDk7ZGIcQ+Z7y3jSUCxOsWdGE4trjxqTBFDG4sWdKY4YSPI4YqgyX6PVNogAg6+aJPzFk+Wix6kUEDawh279Qv0jc3TVg1WKxkWUoaCGWMe9hBIVLhSQpKh14zyf/rPPM3YHIHzSM31seVsj5y6K44dtZWJKiSf0kOkI5rqWBmkSytFTFIpAyfM6jN2yy7l6IO0zL5HWyAl4NJaSyKtiRjEoO0dMeiQQn6orywAH69FdJcIHP6934wfWwTlMqY+oY9dig+wfXdi0yN55tBdQW3JtMGFjUjT8/ugxI1APJNjx8Sa0u82znGISup7eHntEjt7crHD3Ns/eIT7JAAQMR2RP0MIQb7DreD/t8WrAh9qdYpLm5OjuCDjHX1oBCSy3ugay8t1Lk630d9JEn8m70iCZdP7ZxgjzwumoI1Txoar12mwg9drcjQ9RgZ5NMuTxgf9X8ZpOYdPuxmFuMu8DkSsyBe1EDUcISWrLfbKzXwFBnE7DNcrqrz8HNFM//J0itNZ/SfKRZq7o6CyPVpWjxyQX1yL+C0ADK/Jj8xSUzZsoV5OztgHYjZrk4UcBc6+fStC9StEivgP9QDs9CjOi5p1Rc4QV1h1UG+cg7aLyCff7iNzi4H7b1qNASO46ZoQOCNT09VJm1QQcd9frddsgNXES8WANleWaS2PfeCmpfvH9iDesDe5R390yJUMBxnfl9/DpIv46ty8U9PGl4QBwLpPaYgfppVcOexg9G/ZSfgMIJl9kiKkU5VxahctgfqUZEwZOcWBoCmpZxA19KHpxq4x6WMkVdOJu4A/T1z6d8GEoij/HqDkIGlzpGkH4eL5nIqzN6M
 SHQnajNV
 8AdiV5Z8oZCbGEY99TDMgBpyBByL/hQ8EYCQ10EmG/YEl73gCTUr32sc+UWgaBdz5D0q+UvauznkTBReUm90Z8qtNrlMal25eptWfMi7T+Rzfd4aAiP69p9hb3TpyqrVVbTyDxlNZBWe5yH3uXMyBAO9xV7N3Fu3APr4xQ7ql8+zTm0nXqHth/IY3ZTWN1VXPqM0p8gi48ZkoIQWSRBQb4ckG6wWwuFsYng2DynzzcDc0AF5rd3kG3WckTMXOLAkE0Z7+2IKQ5ZgF7l/V2VKNybJGyBVdTdHdjTdyk7FAXAbXiBzposrvigaSau7IOP3nM1kbWG83GyexGxUYx5a2NImXOcYRmhojULOev4wP7ZzqPOHG97aaGRwPApvMVOlEXA/DJ3JtLKa2XDpP84uuboSzB5mMRfzWAtlwkNR9TbkR4/y5nIGZVFuoFCQobnjJ8t2cprUWOvwu60zL2XzA1TTrqgicz64srlpSMj/n6F32qcK3V7uUq5mLCEzpX488ZvE7nslmR/JiYSWVQuDdK6lOFNu9qLbjfXAPOj+tIp5hL3z1cJk4WxJYzDng6PrJtj9bdJaKAzFF+eFWvt6vBbEo7seXOMe+u/E4uV7LJKkIXXqjEfVBuVwVCUXfVfcaI5tttXDuIS2T5MKfcGgrk+pR9XRUE9f0p9hpuowzOR8Jt5NS0cU02bHONw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.10.25 03:31, Anshuman Khandual wrote:
> Add some [pte|pmd]_mkwrite_novma() relevant tests.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Huang Ying <ying.huang@linux.alibaba.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


