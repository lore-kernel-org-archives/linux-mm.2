Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D50ECCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 20:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD01E8E0008; Tue, 21 Oct 2025 16:15:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D80B98E0002; Tue, 21 Oct 2025 16:15:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6FDF8E0008; Tue, 21 Oct 2025 16:15:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2A4B8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:15:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4872A4878D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:15:18 +0000 (UTC)
X-FDA: 84023225916.08.3EC259D
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 612978001D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:15:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ict+v5A5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761077716;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=itkucRp1pipf810tivY17xNu+wE6i4kYgosg1cEyOFI=;
	b=8MHt8oJdYUpe7LIJxiOD2+dU2Fw/iCJOEjmuYYcogN5+6K7yh9Qv5u+3CW0W+R0dVEMRWy
	ZxsM4ANFDI1Nb3JgAeNL3D7oRTCNf6CKoYIRFwgADCPVAvMcp/SGjgeonXKBc9S1RPNEcf
	hdIbcvHZm2q9g7WzC2E87TMBVeuoYlo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ict+v5A5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761077716; a=rsa-sha256;
	cv=none;
	b=iCVeYT2DukIoLJseCPhf/ivdtSy+AAC1oblSSyMpQKJmclLlp2Ml4YOi0bUfaaOGkkIllH
	2DFVr4g/uvRaP7Q965mqL2MV3qZcaVCBufRMW9xwZuIAJzxGBMcTNI2aUlH8yjkbGuyuOS
	/8pjY0kSUkMTZ+Oslf+n9glkunJ5FZ4=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b3d80891c6cso43440366b.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761077715; x=1761682515; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=itkucRp1pipf810tivY17xNu+wE6i4kYgosg1cEyOFI=;
        b=Ict+v5A5mcrdjHp9zo6bUFyMhhiKqzO5VqEEGjhn2j1LcbL4aZsuOZUqGTWb5zTmVJ
         zPlXpmhPOFKtzWMBkJE+1P/f4DvDKfVl4Tnmyre3Do/jlzCYl7z9ZsjM9awWUdplDa6G
         gdIVy9TyapO7Xpd309ZNaY46Y/1aAZj/fIZIzZOsAyiseFmH5NPBbzFpCiT+tzZb1RU+
         DccDS+aOkKry9QybfgsrWWUy4ju0r+6WJ0DCymIPFRqgQAuT4r+kLIhqVk4+22cjyi+i
         rHCnK0becaVDp25DCH+W7JqdX1LEFsJryGOb7kqgFDZMKFu+IPs9bCNpP1SC/GglOehD
         GEHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761077715; x=1761682515;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=itkucRp1pipf810tivY17xNu+wE6i4kYgosg1cEyOFI=;
        b=C64RxNJkfufhzljbiAVWw/a/VObHdsZET2u6GvDixUB8UQNTiyDQQ9LX5fLK76P7Lt
         +4x55Rqs0FPsdNsgYaCFm9Lz9Heaq/cj/5YuJoj4qoZeM66VxEi5Lfe4h0MSRCN0ccIl
         kynd1nuCKsSIGCc0KWTQjuEzjkoEsMsBDh/JkEKnm/Biy7ytP94Ldouw7aCknyEnHixO
         NLJLEsdDKgKhqwFu2d34uOwJrB4cVNxAH/FPCn/PHELe9L11TLmtCQCxWKZ7UDtbOwoM
         AJ6UTrFJWCQ9q1PCtKXAa0/mh4TMwxlBssOTONYpaXJuPxFLNGuMrXV/3acY5ZrKnZib
         NVNw==
X-Forwarded-Encrypted: i=1; AJvYcCWfu9gWVex1q1pOiQVLWgGzbxnjK5MiH/GLH9rBUHMj839Y0UknCqosQd5blBjjmblvVPFfKM6oDQ==@kvack.org
X-Gm-Message-State: AOJu0Yx9GBknb33m/Py4a1D+14vWx60ygkhhAF5IO0xALlNdGlkTnGHW
	ipRTO4n1EI08GIiKniLzhzW1RTRLqvVJ5im406fnPIrsw3ikF6VNqIEt
X-Gm-Gg: ASbGncs9nqEV4NTgZSqkBDwWzDtNpMrAU6IMducIJN+2zIMcXKz6f4odOY+JaK46pTm
	SM7qfC4WwgNGDsCegnYXN/w7RVBO3cFpFD6Np3Jq96Ch+qAqAk15w3P82CcUBQisxvWg/u6BIAb
	k07pbjdIYkg+44VG2rApVPnXyhvihG1byRtDRS1rGn+Ng9Rud2P5nMaT0kGii2N5ugtEXAkttBs
	Jnw4DekbRpge1zCIWsbREWqyeb4UeV1eBAYNBd5TZYXwdNYqbMxSwqRhEUpN7KkqOCRbIoHf1H3
	2KcNKL8Aad0Sd6qUPE4OYKlJIF08uY8ivhU3qD6fV1Xs2ANgd0AkrQFBVwlLP0Ej1mzIJ51gGfH
	80h/UdT23JRAYbLBKIyP9ljVrkIj59c8zoAPiODH/1nG0W4HtohNgwQQtw7FacAmq/x40j2Vr8E
	q0fdpTY8qG1w==
X-Google-Smtp-Source: AGHT+IFi1ufP7ILiwl8iMiFNreQBWCrP98ESqvJun7o/v5UkyLrrz4yFim+gai0vG/VLaE84nLJxgg==
X-Received: by 2002:a17:907:7e9c:b0:b50:9f92:fde0 with SMTP id a640c23a62f3a-b6d2c79b133mr128406366b.29.1761077714698;
        Tue, 21 Oct 2025 13:15:14 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b65e83914fasm1139647766b.20.2025.10.21.13.15.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Oct 2025 13:15:14 -0700 (PDT)
Date: Tue, 21 Oct 2025 20:15:13 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Gregory Price <gourry@gourry.net>
Cc: Wei Yang <richard.weiyang@gmail.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, David Hildenbrand <david@redhat.com>
Subject: Re: [RFC PATCH v2] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <20251021201513.kxhjiirr4nmzaw7u@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251020210816.1089910-1-gourry@gourry.net>
 <20251021012533.56rdl6v76plkw4nl@master>
 <E787AD03-DC67-4B5C-8BF6-C79F3C583D00@nvidia.com>
 <20251021091443.5ggfmvl5jwyknjnv@master>
 <aPeu29qbxdn7dmjD@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPeu29qbxdn7dmjD@gourry-fedora-PF4VCD3F>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: 612978001D
X-Rspamd-Server: rspam03
X-Stat-Signature: 1un1fe9emz17j87e7ywroq1np9pkde38
X-HE-Tag: 1761077716-581808
X-HE-Meta: U2FsdGVkX19InBgAP3TZ1Kiy6dqCquQrkI5PQWrsTlvR0Ho5T8hnDoTixYB/JFQhHd6wncU681V2JWnEAmas7O/6sKEe5D3jSdlxaP33CXA+Dr9y7NPwVpbCb7KncxI5SSjsOz3xAp/56ISBBoWnt7cnxR+EjJb384LmT4/k4WvQJfF296wev5Um7RXHEhP4ErwqyuWSeVm2brQv83oadh8lSLzWS3CSFYErx80jSvp4KF44QFz659rWoH3rvW3wy1qk+ti6ukjFR+PS0IjucscaEMNGBYGNP2IED3RHen7tIZ9pqKX75Myku/Zw9GVKakcPKZUgmQJK4HU58UrprSqLAYnZteRkXGRWgj8lPfh2w9qkoPde3YrdqE9AtV0icH6Qnwv65XisVSpiGJT3nvua0BwHPkuVAq/ltqUhB3lyz9MrPjHqa2QAWJlURuUGN7LQR4co2Bo8/kkAaBvLr6OHZL7W068MlKq60QBMGJeBVTLr4YPdxePqomy7hMP7EKDXQbf41z+Ulr3hNw3GR27X4NIuYA5e4dbZuW/WcaQA7UXv/6NymJMTD/n2jQW9OX5ifjdhCCSMmQOzcR9M2fMfjhmvy7QglWFHFxNe6zkCm80RFXICIeHqYFLXzHsRm7gwe+TAgzWOdYkJr4zYWV54CgU77XPSXJbtfHmidCBPPZy10AN2cz7dSyhrxPLjEN7ebAgiFKE/jUB94w8ji9kXs1/Lc+dQiKLsNdm8m3UgC9IV+pjSaQ/fW80uDBNUN1jo/YhySqy+5cJ0OrC7WA76LHsSIrMmNOWztjWDKPyEJCrqSuyrUEWmIUPDghzBYghPa5z/M/LfbgO/VnDSS5usvET/W3zgBh7FSaYOO6CErg2JEWNE/VaIIaEdtWEPy2hppPudSNLxpr22c9hBokVBRWIeuEMj6M0HEAjXmMnLreagLvMfZ0aHCUn7lodwQqiThHeMddxueUaWnFX
 AB4dXiOZ
 7bs69JHCj3d9G5LKlGjyq/5X9LdK9mYim7cYCAfnNak6Gjqnd+vMikvw88MRz3rLNNQd71AsTn1Ef1EpGjiP7+BpD22YUqbumCWBV4hp0sf6MTab4NRKwtNeJHanXj+UCQ/lXdhDaGnYLO6kLz7PSuvM22J2bnJD4voPenrXyUo+NskXBuumFDiD7dQkxq1Whb7nf+s/HnL6BXRMZOzhxHQC1plzrSKx3tIvceTrpJCGu6xRfFhaGQGQGADItXGpczpUpUo4i+P/Xw3Iw+E/b7HbTf3VzvjNklIhjeoDde5OcIqCu1do+Z/8QD6d5A6/CalOo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 12:03:39PM -0400, Gregory Price wrote:
>On Tue, Oct 21, 2025 at 09:14:43AM +0000, Wei Yang wrote:
>> 
>> The above code is expanded to:
>> 
>>   page = _compound_head(page);
>>   order = compound_order(page);
>>       folio = page;
>>       test_bit(PG_head, &folio->flags.f);
>>       return folio_large_order(folio);
>> 
>> If we use
>> 
>>   order = folio_order(page_folio(page))
>> 
>> It is expanded to:
>> 
>>   folio = _compound_head(page);
>>   folio_test_large(folio)
>>       folio_test_head(folio)
>>           test_bit(PG_head, &folio->flags.f)
>>   return folio_large_order(folio);
>> 
>> These two seems expanded to the same code.
>> 
>
>folio_test_large drops into const_folio_flags which does
>a VM_BUG_ON_PGFLAGS, so not the same logic here.
>

Thanks, you are right.

>> Maybe we can use folio_order() here?
>> 

-- 
Wei Yang
Help you, Help me

