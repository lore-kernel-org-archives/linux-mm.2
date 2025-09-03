Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A8ADCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 20:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592698E0009; Wed,  3 Sep 2025 16:05:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 541F98E0001; Wed,  3 Sep 2025 16:05:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40A338E0009; Wed,  3 Sep 2025 16:05:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C10D8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:05:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8055416089F
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:05:53 +0000 (UTC)
X-FDA: 83849019786.08.9252641
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3C26810000A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:05:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NC7pzXoM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756929951; a=rsa-sha256;
	cv=none;
	b=H8loDbTKLx7FZZ4B+0uly+FY0KZAFBVFRDB8pDqSV/HDe5C0rsHLj4s2I0PdFxYzotfoOy
	qJ3pdGT4ek225ON7tkLPBirusSIVu+H8IE2JzovmogmWaaV8wYXhwdwwiAA7KZnDHJ+fM4
	UF/tIzWM6zFBEY4OYiK2g13mbpd0mgw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NC7pzXoM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756929951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJJW3wpHxiazUQti0atBSKNrLCeANgw+ouJZoVKaKYo=;
	b=ZzyAEQ+7lmuFhHUXP2z5COpExB0ucAqQ4JYd94k3M/qvCcETScJi7OsuiJmBKkn5sMfNHg
	CweOXMPmLNXGGAYXJ+NVmqtFKjFuZMwws34K0lDBgRFvsJPPNUEUA9Xt+00m79h9ZNSsNf
	YfSaOUS4JYva0T8TgCyUbm5ZZU+dbQw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756929950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tJJW3wpHxiazUQti0atBSKNrLCeANgw+ouJZoVKaKYo=;
	b=NC7pzXoMCvDg2+sIHO34pkybbYHZPybyzcRovKVUlgqvP+jALSrRHCAg7DKvmLNUsfWo8C
	IAuhhowGRGXpQZdObBQFkAhkL0xDzTjyKAN5FmFROmAahH60SlRF57NaDuCmPNi2bfZd4Y
	v7wTWZbYIunTqfY0dJnFNu6XNRgSrvE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-Q1KezTIIPJuSRdwBM57Pwg-1; Wed, 03 Sep 2025 16:05:48 -0400
X-MC-Unique: Q1KezTIIPJuSRdwBM57Pwg-1
X-Mimecast-MFC-AGG-ID: Q1KezTIIPJuSRdwBM57Pwg_1756929947
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b990eb77cso1339535e9.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 13:05:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756929947; x=1757534747;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tJJW3wpHxiazUQti0atBSKNrLCeANgw+ouJZoVKaKYo=;
        b=EsUhPzlfDt/jYjN/yporfQZIQTW5JvLLXrRCZ4sqO3SnZDh0O5Ap8UdzLFHQpCxlUX
         HBBDs9Yga4XLQALarD33JlTl/KHs90J7tC5e8TqGqNnP93RBxlTWPMzT2/lub/UJeyx+
         yc32pbPLrDKG52xNoOmyYF8H/xOBpP4x/WSB25kzWT32E6TLMAwbuZYFF8zFb2oxGDtP
         vSTjrERKwiPQ47pt7nzQ2bhiSOdrLn1mG7CZQcCzcNiuceJX2Bt18FHxjXRaaRahZwUQ
         CePdV+2LPfGZnmF5Ywem3fCwMTj4mlXtnCuESQeddzlpMN3ZyMT6LWJIqfnpBrtYDHsg
         +ZuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlj4xzyly1rg0sBk604fZcrzTBeSlQeNNJNLVlkxBljGGr396nKEme3Rcr6ixev/Y5qTFPWtuGpg==@kvack.org
X-Gm-Message-State: AOJu0YwPyqD7oZ+bTPKQSCMkWD1fgyxokuc1ZteQZy1eW48dUamBiETh
	LMynCWjIFICo1dAw42BW3qR7yd3VZKJWoZ/AJUevJLGi6P8hPrIUS8Gk4Qz+CJ/o6EN3n7pRU4D
	oS9ziQPGxi36zRj2z3fUsJZIJ1P0m+5ZT31oi2U0wm8oKg/P9/tsS
X-Gm-Gg: ASbGncuYJ0NgowmmQqBGtDlhXI8XGOdL0fD0GNnNczVCV1EC0/g/uNvDRVPA9NpHiFr
	65K32ZvFCv9rtHZneZd1jAwzQWJt++7HklfxP46Aha9F4qzwpUmxkjOpVfh6zSms39llkCU3FpD
	99C8KGtZS6C6Nml9KgLdy0RZXxcUkSYKyUrbvBi4NTUE5scrpBAs9xxFEFK30uB1wbqDBSIFmva
	1LXlCffby2OxxEtJB7vI8+58aAeXuOoL92kxSkO1D+UNiNVB2YX+ctx2Hb1uDAZx/K7oR9yYsSx
	oTAvT48oCRiDygd86LXHm/0yrobjcGbNtsXXUrTkMbmturtBWEPKMUWZ+jfepFGlCWNHKJKJn9v
	MuT9a/M3WMuhNmZd6PFZqSXBVotq5B0MaO2CdjdRUkeSOxSY57fM8jdxe5yzP3LCh2o8=
X-Received: by 2002:a05:600c:35d4:b0:45c:b6cb:e4b2 with SMTP id 5b1f17b1804b1-45cb6cbe8ffmr24788405e9.12.1756929946788;
        Wed, 03 Sep 2025 13:05:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGru8BK5sN0fUnS1G2rr4hp+6xO6Ql4hkR82i9YyrN5xU7YfiqJER+te2tfeY4mifoi9TYRCQ==
X-Received: by 2002:a05:600c:35d4:b0:45c:b6cb:e4b2 with SMTP id 5b1f17b1804b1-45cb6cbe8ffmr24788185e9.12.1756929946340;
        Wed, 03 Sep 2025 13:05:46 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf270fbd01sm25242063f8f.13.2025.09.03.13.05.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 13:05:45 -0700 (PDT)
Message-ID: <701a1718-fddc-4ae1-817d-d9549ad71a09@redhat.com>
Date: Wed, 3 Sep 2025 22:05:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/12] mm: pass number of pages to
 __folio_start_writeback()
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org,
 brauner@kernel.org, willy@infradead.org, jack@suse.cz, hch@infradead.org,
 jlayton@kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@meta.com
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
 <20250829233942.3607248-2-joannelkoong@gmail.com>
 <e130c95a-103c-40ba-95d9-2da4303ed2fd@redhat.com>
 <20250903200210.GJ1587915@frogsfrogsfrogs>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250903200210.GJ1587915@frogsfrogsfrogs>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9EdA-AIJyWCAG6dqT9xVWIjR1uLGQVf0MwO7Tp8UbfY_1756929947
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3C26810000A
X-Stat-Signature: fmr4k8uizpbuhf4ubahtbkszyehbb596
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756929951-400150
X-HE-Meta: U2FsdGVkX18Sbg4cDvvngb2EEI0YfdmlR/zk7P860YCh5gjTa8fSEWrR1XdQSdRa2GkTnrssnxpxcEX9zv0TZQZJ8eb1UBzh0tu6ZDvS7Guy+RlBwiWZmclXHWEeq1KHHPvAUT5sZfqEAPTfVqg+SUA85i1npFmd+ZQ0lVfGu6EOBfoxMAATjQSt8wON8pYq7tztqVxNqnI5n54we37lMzwtwFllKZnnvnbeR8NaKIKWW8UAIfCqieokyG8TKvmvc73CUGNw4l1uapUntkazX0wk9aO5MUkIdRNB7Sqsr8HOxfwKTkMGiA+1ma8j7gA271J1HkzfkpbOIwA3AaW8prZMEO/ra+Mc4lTAuToEhmm7DVNifq79Se3E/zQaiMEMcztGyV1ZSTGCadXrbIYODMP17DmypztrocBRf7mLyn9vVWWWrLr3L3iVAurw71LQ9FNSpFR2pfzNAAdbhVCHVuScBquoV0ifrvctXxquxjHOuky42V1Nrz7Kc7RYqb+N3nPDYe9HYSarlLG9X1JY/3+z8xckva496Zl6cioXJiiQlz2+lB+qlcZmAWUXDm4IjPPr9sS21KwIRSZ48W86sI5zvXiaN1ugy9yp7xVoCCLCL2YNjmK60IUNuq7Fcc/g0c95QsJm7sw69IERauiVJ4SaV/L2a4aXKkbQ+qy70aa5hADozK9U4zg8DA7cOxPbVe4FMqiFyeAk+Lrn5oIA4eWmgcJJs3YFwrmO97Rup+/26Bo4Z7yko+m3yDJHhFzCRBCQkU5yVrXwl7+8/+5c9EcAsg0OEaV9k4tRqHdCjnMINCXT8GSKKtgJzxVoNJe+fM+tHxYetSuGSRfY2Y3c2caf0SWABlz6q2ebxyI9Ku2usazcrpBGtr1vh2T0ldW8q00l03ZWRW/UVRNsQWD3N1a41U4x3303xsHXNI2/q23KJ1aig81hXv1HU8RlhanBTAi9DpjejrdPZUV28Ei
 Wkj849S1
 CuPFYusiTmf8MvLOZ5I8Q+Js5ipThqMyex4khXBDs0yzW0vVKwPao1oBjLaNTdDuC13xvTH81NYvjK8nF22t6Vh73uJpqNJ7thaqJpla4oDSL00GZBSR4jMxDjDJ9DT4jWp2CInPfOvwv1rJyoEDGfpqS5mUQn0Jyt1ie+U48YEldsYtBKdiA4gMt3lxuCBJYCjPx3s5p74c+n8PIVkKd5Yq4FplWBdzbm7VSLCpLEK39zXY2U2jyfaXKAOzBvYmOLwBHo2nmm21IriXrodssdxr/4rG7hxbyaSFqiDrtTRhGyK84tIT1lCdeaHSr3O1G+iR27Fmxpo+LfyvMryFxbGYss6NctcDNStUMFha6S7qpHcg4TjCyWmX1zKdGSXNG8nlUo0tgWQTaHwBKaor+pkFpLttzH+jPwtvVfrS8zB5+gE1m4lozWPxQGA8OPqUfx8SiGmgFosdGuWFI0A1+qWaKwHlPnC5I1i5Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.09.25 22:02, Darrick J. Wong wrote:
> On Wed, Sep 03, 2025 at 01:48:41PM +0200, David Hildenbrand wrote:
>> On 30.08.25 01:39, Joanne Koong wrote:
>>> Add an additional arg to __folio_start_writeback() that takes in the
>>> number of pages to write back.
>>
>> Usually we pass something like page+nr_pages so we know the actual range. I
>> assume here this is not required, because we only care about using the
>> #pages for accounting purposes, right?
> 
> I think all the "nr_pages" here are actually the number of dirty pages
> in the folio, right?  Or so I gather since later patches have iomap
> walking bitmaps to find all the set/clear bits.  Perhaps that parameter
> ought to be called nr_dirty(_pages)?

That would make perfect sense to me :)

-- 
Cheers

David / dhildenb


