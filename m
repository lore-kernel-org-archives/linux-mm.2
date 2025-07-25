Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E009C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 15:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B532D6B008C; Fri, 25 Jul 2025 11:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B02D06B0092; Fri, 25 Jul 2025 11:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18AC6B0093; Fri, 25 Jul 2025 11:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 92E4E6B008C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:40:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D9DA1607F7
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:40:17 +0000 (UTC)
X-FDA: 83703198474.20.00397C6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id B763B100004
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:40:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OG7K90+6;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753458014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sC45sZmC6S0ZueACRW7H6v1qytH0Lj12og8gIKqUatE=;
	b=E9OXZoOxrxwt9nWlGmy3SHVQTrR9BOjN4LCdie8Z6hC9fU12u0cLi7CF0uvH2rLSl277hs
	53VBCauxQNa82iCB8jL52HAYdaT6BM05zgUjLbeA/QGVhLqPZFwsgE6rfYm7ihOVK2jO+6
	NXNgkpROMaXETGGf3s8JXT8BpxR7O6s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753458014; a=rsa-sha256;
	cv=none;
	b=hdw94nrDt5YKV08B9XJCsfm/v2ZC6EzedXzlf34GscaEyGZOkfkf3QupI596W1skBatawl
	svNtLDxfNSs0gs/u1Jm5jWc04hlggOpUlSIRIkfvJtRjqdBlmTKAVfboVv4J6vZRxZl4M+
	wYRGdeXBSeTRQiRpwdoXvyLw/trIDgY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OG7K90+6;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753458014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sC45sZmC6S0ZueACRW7H6v1qytH0Lj12og8gIKqUatE=;
	b=OG7K90+6K2Rq/2uNGFtYXgqOZAIMRpx11uXD539G0SeEh2NE9LrF68ZsJDIk4JZyVzaLJM
	ONSmKGPNuBOlhmEeNLFpZgbu8oV7+4aw0FaT7BmPSzh8AH2kuy4ny59j8hpzBKS4fGHKWl
	rVLXu7zu0BAERpSmvNXHcSfOL8RDKoE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-308-m8tvBWriNfiwkL2DacoWJA-1; Fri, 25 Jul 2025 11:40:12 -0400
X-MC-Unique: m8tvBWriNfiwkL2DacoWJA-1
X-Mimecast-MFC-AGG-ID: m8tvBWriNfiwkL2DacoWJA_1753458012
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b76d51048eso1534533f8f.2
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:40:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753458011; x=1754062811;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sC45sZmC6S0ZueACRW7H6v1qytH0Lj12og8gIKqUatE=;
        b=J93zKaKbY3Lj1T5Z82U2u9ua2HaNQaWuN9TYhC3yuvOXAOJfLMJCiplYQ+gBg8d+Lf
         SEPDmPyx0F8Q7yRGns9ddVPfwAzpgscBYjKr2h2ucYTmLfMyQyarJ4q+ro9ibqf4+F1T
         yyU7Ll0dwN29SjbyWAGP9NsAnIzKDNwdnKEL45AJ8c7Lv8lsF/0LjbBXkGya9q122t9I
         ABYsUGw8wZbc09L61K9BFpOl/7t10+HdmOguN18RZ1MQesqoEeiJto20cOIZ4Pe6nA/J
         YNGiTjHOUXTlpTdAm56KRjbYzFcupKM9HWfxiauF1xFfn9l23ZtC0esMs9WFpcZRd9MO
         8Uyg==
X-Forwarded-Encrypted: i=1; AJvYcCW1/8/Db2QkgDX5RQTjDDezH+e29hSZGU9/h8bR4q65SeK1Kp4DT39NC9VgYEQPWPRgXgGmDVoekg==@kvack.org
X-Gm-Message-State: AOJu0Yy7LS5MFnv6hewOw7yC0hLLNBKG6S5DOrGvYi/LWhPpqgTdNH2N
	yP5K6yA5AzWhM1teUnJ6geRozK3aKWGS8kPYlo9tL7bJUK7WWOq7EFW/CFyuz6LHB343PgnDhcf
	/xdINgq1N1apVQ21Er8jC/jHhCGF4hLP06cAqZMfQVhiSMKFDLA30
X-Gm-Gg: ASbGncufgZFDd8CcVPj5DwaHAbYOWDjqc8u1/eXf27v8QHuSeTtFDULCg1lNdRahueo
	V62pWoeDR5kFD4U3JJk50EaUMSxzXhm0I7utczL1v02sVlq0JuZZ9ZL3TCeOyMKKgcqmtXYS57U
	Ix/il8g7NuVevWaj23wN39B5x/hhm5DRG9eJ4EEDs5dO6fkgADpFtxxKn8sNbFfOEIU5gz2pZxO
	5u1+vOOo76A/GUggbWzVaMBAxEcfWl7vioxgD6Q9h7ZimTGJsnL7YSYItcz0dUDUDL+NH4ZfJid
	0CoXKfkN9nUvJ5MMXRY3fJrJinZmPndrPgixsIVGupKg9xO98OI9bk9Ut3io76+3NFPSFpK/5fr
	GivyeWQOn1kLzkmmmscjdw/K8T9YuIb7dtCv9DwO+n79qDZgIH8hQKlwbOM0XHsnA
X-Received: by 2002:a05:6000:230e:b0:3b7:5cd3:fc44 with SMTP id ffacd0b85a97d-3b7765ebbb7mr2029231f8f.4.1753458011477;
        Fri, 25 Jul 2025 08:40:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFcFgs6H/wTKa9G+TeRTa7JgaCydFZvZ7XTEctddgKIUnysUc4LLUc3CS4Kto0KmSHn0+paOw==
X-Received: by 2002:a05:6000:230e:b0:3b7:5cd3:fc44 with SMTP id ffacd0b85a97d-3b7765ebbb7mr2029206f8f.4.1753458010930;
        Fri, 25 Jul 2025 08:40:10 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f34:ae00:cf93:b0dc:6bed:abc? (p200300d82f34ae00cf93b0dc6bed0abc.dip0.t-ipconnect.de. [2003:d8:2f34:ae00:cf93:b0dc:6bed:abc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4f40sm57086215e9.27.2025.07.25.08.40.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 08:40:10 -0700 (PDT)
Message-ID: <c5a52f8c-5819-4eca-be4d-9c534c6ad6bd@redhat.com>
Date: Fri, 25 Jul 2025 17:40:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/rmap: Add anon_vma lifetime debug check
To: Jann Horn <jannh@google.com>, Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Rik van Riel
 <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250725-anonvma-uaf-debug-v2-1-bc3c7e5ba5b1@google.com>
 <1d849190-214e-413e-a082-d7f862b653cc@suse.cz>
 <CAG48ez23CPO-m6kPaEs8kLUfRVCN+QMbsEn7BocfaJuq=gRwaA@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CAG48ez23CPO-m6kPaEs8kLUfRVCN+QMbsEn7BocfaJuq=gRwaA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 09qty1FV1fU7JTtdFp59cBoDU_zHzrv_SQML0gp8EVA_1753458012
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B763B100004
X-Stat-Signature: k9fckg1es6cpa9emn77mzjo8m7gwpusi
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753458014-128590
X-HE-Meta: U2FsdGVkX1+oCNvUcCjl1TPSHnhs4n2dv8b2lFZ3IWOEaW16Ih3c9J9MasmgtrR+kbE73PvVI9BDlmRU8fg8KP9SW8e5HmczxFdrDhEaMRbn3TikfIL/LvlwNeovKd4hrS2NIH90EM2MBH1RiPujptFeqYDdSU96QL5WiQQ9incVw8Cwk1MvwH50iLeoc5oYLRGFw1/czmXfrXjKBeLVqSc5XVCy26bQVHRJCKtmnuyuqmPDjIdZEgOpsdsoSNQyVq9bkwj9Wx7StnJvvo4Yc2eY/39zXilNvupgvo3iT6At6d9nKFyQxwYjSAyfkEPfSb4JXlI0Ir2dcr2XdVCletvXc89ykdgCbT+qgyakxk8eSGGoJiF8+HpVX9c984991gy8T/d7rf1nBoIb2xyjmZhvmeien7FdUXzhqRDTVphIzsoFgth/NLqrzrRgw+HqX9Wnvpx6Fp7RHMeeTEg5ahvOt76zcPuSE6O+CEvHoYYbd/ZHKBdDpV06eWC05taNyqWeve5yIJeaq03vcmkBOgy5UGc4ZNvaYxwTo9HfCkT2u1RGyl1SpF340BXklBvOjPYYjquIDe38T3g0CfZJrSfzr1c0SO8ogf/kOj8h4Lsflz+mC8AHkLkGajf4CgBJFNNjyGbe/MEWnnNgw0pXIFwaLSBU2k1lXr3DZxaPpf/MYBrlFWrNDt5GGeziKjPTK1VR/BMIgFwSgSud3sgLX6RnuO9KdtZbGvnzFcIz3Ea2DBQtvjK/PQKLhqTLqujWZ/unRr1fDQlMgn1t30i4Mzk2RTdRP73Kv4VI2p59aYAeVyjdymkb+Sk2Ul5IgAiFj12+gDOwrygZUkI053Je4o1lhDR9WPMJ1R1LsNwiMDfXlFOAaouG0jG/ehlzQRvMEj2HmoCTLYBg00fEj3+eHYaNzqyGIjoJbMGdrqCLrEs5HcsG6K2+UfX4IWCNrgXX2I7HZaRqxoOZ0wH5jIp
 LhzUhaT+
 c0Tsj+Np2sMZ1MPf9TraEAb6PeWol1aK2/KZ6qvWp6l1JQPuke4HB5o1PjcdZylVRFYtj7fjFdqykG4G7H6mJz/a22yXffqNBj0tLEnJdp/DhSDCzQxU+F+hVgKuqt91pLG6MveWihA34/zVjK0foNH8OzMEEUSqpaO/Ek3TjiuN4sKrOaaVhMNZ1YHBHr390UZW4WPR4HLAE1EJyxqc5vzxHsZo/mT//0PcMiRPkZYWXCK62M/dD5CZzQ0H46z4X9zG7brru3KGRuvejOrY9/wPZljX2RII1fgtpYH10Ja5fjUTvXOKe7wzxjQgd5t8yUqjAEVqozdo/a7m05Ju9Y6FXKboc4Yn00hcxkfriblZayaTFeKR1G9nmCpdaW3ucG/SVbvoA8zeXIFilhkP3ysvJKcnQ93o038+pMvujvmCtjg9P54atANIxfC9wzubwW4TIGiHWm6HiFB6yxrdfwOdnizJuqfuEJw8897WFXZGdRrBDE/UjGnmhGzdolL+ZRa8u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> +      */
>>> +     if (folio_test_anon(folio) && !folio_test_ksm(folio)) {
>>
>> So you verified this compiles out completely without DEBUG_VM?
> 
> No, after David's suggestion to remove the explicit CONFIG_DEBUG_VM
> check, I looked at the definitions of these things to check that it's
> all just plain reads and arithmetic, and removed the CONFIG_DEBUG_VM
> check, but haven't actually compile-tested it.

The compiler seems to know its judo well.

-- 
Cheers,

David / dhildenb


