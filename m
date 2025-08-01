Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5156AC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 09:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B303A6B008C; Fri,  1 Aug 2025 05:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07B36B0093; Fri,  1 Aug 2025 05:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1DF36B0095; Fri,  1 Aug 2025 05:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9342B6B008C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 05:02:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 430421DC4B9
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:02:44 +0000 (UTC)
X-FDA: 83727598248.28.957FFD8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id E7A6BC000D
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:02:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D5HIUVH3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754038962; a=rsa-sha256;
	cv=none;
	b=qxly/6lcvoyL8N8iUKNU+bBTLJZO7UyxPa+yblDJNvYV/FtTZwN5Gn+dkLTyPHq9VyArr1
	MT1IoyMXqcoEx8otAzQbr4MYsTj4EUxHqbu/xsQX4KfUHGrx2/maBYHBOmdjU358Xpql6A
	cRHB5Alc2ovR9JV1y/S/e9YEXNgRtBA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D5HIUVH3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754038962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jKFRHT6OU2uRnFKuf79dMDW02YpzgbfX6ReI0ryBvj8=;
	b=HxAMQmuTXJFVS2y/X3o5vgv8TIbxr5zwOkpBJuYy8zcm1vZV7HYm8QIwvD/Vh6oqcwsTIR
	XUvHiItrFHfH2UBRx9nlbjTLe8uWCnJEs/bg3RMilO2Rd7s8zCbhm2tBRUJG6wwiNTeTOc
	Ljcko+FB+UoM7IvbHVEG4O9GdG4rN5I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754038961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jKFRHT6OU2uRnFKuf79dMDW02YpzgbfX6ReI0ryBvj8=;
	b=D5HIUVH3WitL+01Ye0hSP4+ywUUEgX9XrueFD3rQu/BjJ/2GZ99MKyQX8in2+tjvfGmhvD
	Y+ZDjujCVgLZMNDCKgUFxabhcRohcElQ+Y+DmLVE1fOvDE5N1Rkc4r/r1u3smiMGEHHjFX
	jMC2kCrEwmDFI1I31RxcsH6I2J6NaEg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-ySpP1_bJMYuwVunkIbtbSg-1; Fri, 01 Aug 2025 05:02:39 -0400
X-MC-Unique: ySpP1_bJMYuwVunkIbtbSg-1
X-Mimecast-MFC-AGG-ID: ySpP1_bJMYuwVunkIbtbSg_1754038959
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-456013b59c1so3170905e9.3
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 02:02:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754038959; x=1754643759;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jKFRHT6OU2uRnFKuf79dMDW02YpzgbfX6ReI0ryBvj8=;
        b=VJZPr8ZZeiap3lTRn1bEU/HlnLD7vJ1tmHKJgqK0eGPjJ1/JtfyYwf64KCoLqK4o1M
         xL8gao5gr5y3xmiAGYaosDU8fn+Hbx7Y5SJSRpTt/0dcncpAJz13dO39Sq3SsRIO8LRK
         gB1QVDyMQwpQxEijboeiKPt2uNEYwYiMA3CybeJV538oGcR9tzBh5sk6ZjfNmdc2fLNQ
         i3EtWcsuQFjpQye8VjXYvk2rQ5F5d2byiJ7OI8rN9GoCkrLrJRif4/WdrNUt8iehzj01
         PRYq7Iq2MpuHl5EnxielJ9yN3FtYCZO1NdDBKIG1QGaC5CmyfEnu5kfMHhSW6gPcWZLd
         o+iA==
X-Gm-Message-State: AOJu0YyxiIA4Fi1Qvxz3esq1qMbWyPSGMuoH1qI5LGZHO/rbD6D1fBZA
	6fuKFTuhowhT3hR7K5isd1Wd+1B0aoaE12ob/xHvCmI72txbheS5au3B7xSEBVT5K+gwe9dGP8A
	KdkiEslYeJRVfUelKcb9SOmiaBmIoS0fc7OuBaeGP37S+/lEB+mIt
X-Gm-Gg: ASbGncshSw12laIZVzO66S33iQ0oOsp79MGLe2MZkztEog5LwZ/D+iXqYpicj3BDMfu
	BcHvZ1iOmh5pDA4jNh9lSgfLo3GMZjyWZDhxOTaddXso3tHZUlq3pE/a2Z79l+Uv3ntnf6kf18Y
	5VbPa0FyRvfwxG9Ft1KcCUfUvDoBTSzsDyvc6vv0FZgckrx0lz2yrFRWTSE2syrde3R5zxRnCpH
	7GFLtOQ/kgnw4qKdFAF6FjHR7smQ6YxgA1JZew5Odl/SigjhSxqToN+SXiL5r8lervsWh0Q6tXd
	YbJMckl9ftuErPI9CmwWH+x6wrAdMb1zPDTfFhgx7Dib8JXVE5wvCfDtYUbtxxkEfks0nURFCDv
	a+uIg6kbhFnbRalJ/FMPBoBu/IEruyVrnnCZWeUVzCeqyQ1dKFWA7EWy0VHXl/dIq
X-Received: by 2002:a05:600c:6814:b0:456:dc0:7d4e with SMTP id 5b1f17b1804b1-45892bc58eamr98373415e9.18.1754038958621;
        Fri, 01 Aug 2025 02:02:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkH0ccGkKZ/6vzJsc76g5xDgdfhxBqzn1bLX/4APKTuoDCrW7A/V19UVwG2pZ4KLzrc6vMOg==
X-Received: by 2002:a05:600c:6814:b0:456:dc0:7d4e with SMTP id 5b1f17b1804b1-45892bc58eamr98373015e9.18.1754038958195;
        Fri, 01 Aug 2025 02:02:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:7500:5f99:9633:990e:138? (p200300d82f2075005f999633990e0138.dip0.t-ipconnect.de. [2003:d8:2f20:7500:5f99:9633:990e:138])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953eaed4sm91617645e9.27.2025.08.01.02.02.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 02:02:37 -0700 (PDT)
Message-ID: <566ff1f0-e6f4-4888-a901-4995a84d15b7@redhat.com>
Date: Fri, 1 Aug 2025 11:02:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: link with thp_settings when necessary
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <20250801085444.27182-1-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250801085444.27182-1-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gj9bGn0qFePe9tFH1RJbmc0WqRiYwTSUM1x7DV1zaeQ_1754038959
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E7A6BC000D
X-Stat-Signature: 84a1ss4jgy9nxh9b37wb5do7qm55k7rs
X-Rspam-User: 
X-HE-Tag: 1754038961-936109
X-HE-Meta: U2FsdGVkX19fAh/PxoHRWRmE5Gz5xU+lBmbjTuwWWCJ1A1QOukonte3KWzWIk5Yxv+/yIV4C4L6LZmC7xNwSVAXY1RVBrKf9prZ39QbK2P1wjeLCSbJyrsgXDljZs8a15E93mBU0A0CE2/l4cOrc1kkUSlSLrTFvadS7cfrwNycWTrqfpHQxRE26LnPai1iTotxS29cDl3MEwuE+cZDm38ayuo7z66JN3gw/2utPQniZK6TsCB8XC9eeoWOhxPq4I73JXyZzPbCRH16b4Mw9EQfK2ioLPCPQ+5+O8W1ewBKWZsI41TpHeykP/caCLyVtJyvfL8iy/xd1ObLxKM5Vv2GwLvtG4wUw0Ue96ziE4Xkdf3JUqKoDFLmtJfIoadSJfBYyEKR9YLcdhuDiiWB07MW0mCD9TA0X8m95ZuMlBn33KuQYhnT7+ANBGJJ/AS998QhaaEifkhwsRLorphS9lUNrM6FO/BHjXdJlXQsr1qQlNN3dFQ+rDhiUo4oBWbMujZV5UwuS75QocTOXPiI1yWiSVaWxgSbLBAkae8jGYZXAVcwiIk3I466QKRAPgO+Df7w9aKf+0gokNr19hUDhnPwCOvfkMZjFAQXFJmJ7tjhDOPsqu5ylmkXpABfA2b233X5157HLrb9Ek9E5JwHORilHFPf5red2EVMcpGZ3CxwP9nEmMzKID7Zy4241RI0Hnou5KXO4deGdzAYspOW+Qa1fekoyM8HE1LSWnPOUy6yBExK8giviv/nFrTRYKbUS541ZkDdAc7wq1DyJtKGllU7DnKLeeB6Dl3rlvDrmjLTd/K2WV3baYDRvSZzxDWhtmUofH3R5369nf41qbSOPrF2uDzAcHcNNfClyXuDjZXc1G2BInj1eIuW7OVOek4LS+3mzxKSMR4iboVXovyCMSLYxjatslnc/0cTGeMGOb9OdhDRQZyNAOQ3bXuASfzFw97U8kuPWX8EsScI+uHD
 fi2DIOjD
 SJySCXpsx8gEmjQBJ6JvrmRgDP2RJE7lRtL13tzwdwwE7ctrlLg9RRd0yr29rD3LLghQcZRz2Vuw0XhvkKLLPCIRa31fcbtY62fARM3o3HWjIewOERg4SF3vXxcgjVAA2P0s2TMoOfaaMzeMrrgzgxKRdp16Tj9OCqCB06OAiPoLsL/e+Iq9hwmK//qoh1ZmeTvLOb47kVTAYJSXZpzRj4z6pTkaxN5D0glrPDK/+Fktf08W6Ysvnm4ecMjBRDhb6qvL/wo1mkEis+jAo6lBE5dhxMTVbshl+3fCBnrdujMkG1Bfhl9lPaHZS1VTo7G6OXmrZRpaI/1d6KKNJZFnmiZF2L5dEJnxQNyGn9y7uGPpQ6oaUbkWwkJUPvQYS9w8Daw5E9H486bCa0yI+L76/MlmBlnO1GTQ5SFMTziCR+CefvAYLULiaa1ez4db1Iu145sgGzEGrJVytVXdJnoGQgUMnB88wn/XaMhJSzJlGWWgO758jwXwIHcB8/O3+ZAR3hI8zwVM6xyEreR8FRMuQ9jDMHL6B5X/Pee5or3vfSc2baWGe2OTsndSSpBjBNTx7W7nANBSv1UOTqTY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.08.25 10:54, Wei Yang wrote:
> Currently all test cases are linked with thp_settings, while only 6
> out of 50+ targets rely on it.
> 
> Instead of making thp_settings as a common dependency, link it only
> when necessary.


You don't state why we should care about that? I don't see how binary 
size is a problem, why do you think it is?

-- 
Cheers,

David / dhildenb


