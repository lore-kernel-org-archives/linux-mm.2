Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 899F5CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 06:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECFBD6B010B; Fri,  8 May 2026 02:23:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80626B010C; Fri,  8 May 2026 02:23:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F5A6B010D; Fri,  8 May 2026 02:23:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C188B6B010B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 02:23:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 85E2E12073E
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:23:44 +0000 (UTC)
X-FDA: 84743261568.30.0DA1192
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 893C4C0012
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:23:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SOHZ9exg;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778221422;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eXmCROexOu1XWxsa6Gr/P0MP9TotLBuHxBkK2z9uZ5I=;
	b=Lt3Mf94wdE7WpQyi/mZ75ktOaNhs7QUrdb3aQkAEczRp349d9Vq5/EJa3Mdf2xKrgbtSAh
	C0IH3bwk4LTE8z3rY2SUuyHbKvRwp7lF5fmU+vTc7zmDlLr1adM7PZ+PqYArErqXonBdWb
	PVkQbfM56+/0mnylOCwIhb4Dqnve4b4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SOHZ9exg;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778221422; a=rsa-sha256;
	cv=none;
	b=adjk1XQiWHxzTtelpi6jgcy6MUWvMA5slzOmpQDGW9zoijvR4s9EypVqKe4tvOm+sSOmw1
	4EerSILl6P8gD3b8V26ZvqVYBCdIA8bH6Ps90MNGj/5Ymu+OSIEf7foEvVv0L6boIabu+m
	DgwWkVakgMyIaIycN+qqejvWbNzzk30=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-67e9b3037dcso1372218a12.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 23:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778221421; x=1778826221; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eXmCROexOu1XWxsa6Gr/P0MP9TotLBuHxBkK2z9uZ5I=;
        b=SOHZ9exgFFnGfx7mfj5Wkba6DEhNWBg2gXY4u6mbJ5VIuXDdoTQl6eiO3aWCMdix+l
         FfnlHb1lQ6SoIO1RLNd+t3xbeWcSSnLmgbcm8XQgtGAiziNiQKqGK2x8baUXbGffSx20
         y/E+ARbhQeKlpKE2GM7O9WdY8iqw89FrJ9lKMmNXiRJ0sD9azvVDP+uhLZr+tRXPd152
         vcFN/gvTRidCT4PT+eCdxQFqQO6yu+JEtXcccXMdjNfw1QDRGrADm44PI+Y8/FCytybf
         UfbHpTLZTimXRXjposOuONoPq977SZSEDftWmmBLneZ3NA9Wp9yMRFDyKUStJ73yAseI
         75iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778221421; x=1778826221;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eXmCROexOu1XWxsa6Gr/P0MP9TotLBuHxBkK2z9uZ5I=;
        b=mJe2mhNEmxEP83TiIt+QgvtLIzIEcW1+nII4WXEEPGyJMWYdGozwdk3UWf7zodGOob
         d996DeZMjqLJZ+zjX80ymbEVtiUQCKyXYAujq1NCMEJZT69oyzSq0wiFINKNXNyt89AR
         umy5YATwwdYSknGGLfhnFg6UiQhnxOV8iF28vdNIKJRbO7YhRuwlhHuuJXyThcrI2yqa
         nkA+EL4KicJzJU1kad0Nps6Yg0pBhIhZBy4u+Qy6jE3dxMPQysN66NJEjZg84Lg9bN/w
         D/pKk6k7ZMFU/aiGqznEv8RoJrDbo4tz+7maXC1Bxfmt/K7QLfi9Qp80nbS4LFGq+YVw
         UDGQ==
X-Forwarded-Encrypted: i=1; AFNElJ+XFIQbCBkDzrdpiW2Pv2oYCVpBmQaLEMxPzo8I5lw1vnWyM+LBhJovFeJkBzJyeFtw1V/U+NhgPg==@kvack.org
X-Gm-Message-State: AOJu0YyN9XnITSK3CaS7uCX2rj9kKyvNWweFhXN/x5ILxh3Btw1sApMA
	pGYutsyi1CLnBSYJzYUCmJSUJNe1bZwYXB2LhroA0ATRteWa3gcKoVk2
X-Gm-Gg: Acq92OHVdjnvgHYmy1npxDlxmffcLepsnzJSpSDY0JzKhKIghsfbFqMoMcDAdUQOWNN
	zY58GYyNUwj/dEDpA4MEtafLYwUKuQmsfwxPSezrabSS0UnZC9+Os985FrUd8Y2ueR6y6gryQns
	0b7CN9RJb1hP0wjnDzwg0jca0jDE6ovgglwBBiofqRIABakKh6C3g2rM1La10V05MCUEf4j0xMR
	5TcC+5cyyPTZTq2m9oCC4JO8uVJY6YRSc9e/t8ADleKzas/7+7AhlgaLdrQWxNSKXy9zCeYN9Wx
	9OfzlAcKD495jL8oNGCJRM1vWFojtk3/u6q0Wjm5MsQOAPPualA5K6bijPrKKtqTeVuRxBtQGeM
	WYnEvNrj+9sIPKIzSsF/yTnKj+tc/ulSrsXWURCW0+YoOiVwnsRVq+MeHv8JJufcKjKFd3YB2F6
	MV13C1v76BElTyizpOo9hpHFuYPTKbXrA8
X-Received: by 2002:a17:907:7284:b0:bc4:8738:486e with SMTP id a640c23a62f3a-bcaa9f5f0d8mr76170166b.2.1778221420652;
        Thu, 07 May 2026 23:23:40 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bcac4849e22sm33580966b.59.2026.05.07.23.23.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 May 2026 23:23:39 -0700 (PDT)
Date: Fri, 8 May 2026 06:23:38 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oscar Salvador <osalvador@suse.de>, linux-s390@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v2] mm/page_vma_mapped_walk: Use ptep_get_lockless() for
 lockless access
Message-ID: <20260508062338.h7xmz3hjzozdrg5t@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260504130434.2285053-1-agordeev@linux.ibm.com>
 <20260507093433.q5xybwumryxclnqy@master>
 <43815634-29d3-4fa4-b967-0e251ff32f73-agordeev@linux.ibm.com>
 <20260508010040.o7bypjnfceeqloeq@master>
 <4da2d354-808d-463e-ac85-5b1f3fd51618-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4da2d354-808d-463e-ac85-5b1f3fd51618-agordeev@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: poswc6e3x3pam51hi7fn1poapgytqguj
X-Rspamd-Queue-Id: 893C4C0012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778221422-861947
X-HE-Meta: U2FsdGVkX19BMciJA6iJW8CV5owtMryusts+7LNUTOp6yC4eunUYUN+z4BO5XvAuXHi5miLIRPhuqHnXgfa46np1K9oFsueeT/BhvCIB82CAi47MgfNXQctOc5ZUfyDqQYNEdKPt9n9SkF1D3bY9IiKqcuuURkMnv0UoWLMJlmYtz9oRb4Ic+Kc0+VlGB61+hLijm7vIkLx2p2s6X4G5nkUrENEecmWDZmTMhZozZod/6Cx0/P1/Pn/GafoOXfFVW+NGkOlfozGWTqQiPm2crsc4cuwEEqQFvoQd+wVY8IiZCAHK1Oei2qjFLL41474sk3gA/shodBJdS+ktqxhoxNNxpcwQBsrzcM7QEP4usvTdqfSiUKnMLZ9niPO/JrBfGBFrie6gnCJ0Uf64QDaojWByNbI+S8on4pdj1DLc4zNl9d5aPI4Th1kmVJVRycu7Dh6iPbU9S6ozFC8UM5LCWiqh7Z7po0V7Z3++pKTeqYlK3xlANN6j9JzwTRc0WdcSCdu7DYAcexqwLR9UqlEZb/LDT1A323zVFtFpbF+b+HNtZHZLa6w5jGUBYoRocj3KKqz8w89QiAA+yUzhHLjPjMjorX/Wl5yVe5jv9pwfr78X/+fjNR5EaP4X7Bq9eV1EoQi9cf9otKIEngipeVl5NrlQOiWAAiTlVFW05Y51pbVNBHClZMfMafDSu3t9+/gS58kRorZIQWcwZ8UsfD07/oVKjywLcl2TlsBLVMZd3rh1RZNWBqvpe2ktZjbAF6ikfyUgJRsz4j81yYRw/jmOYbNFxl+XLo3mcCjd8V3PTbFIv4tcVMKX0Trmv9xkIM6KnoDplvRpVumhB7a1FlhE0FysBdALMbh/mPohhvXP/icllZ1YSPH6oZF0NfHyOeJN6UOtciBfWRhFrEadWooGJXwH0linMIa93L57Ivf2ET0Gifjm6duEOD6PyQ3n/QYp8OK2GjAfxtowbOo2TPo
 fo3ACBaH
 knCwSQ8vl9rAx6GuSooJn9XQSfifRUhACpH6TSr7IvX2GQ6TNv6fFoqu17Ws4bt9AFh28I7CciSLvquuV8uJYtyBha2J2JuiP877DRKDiNW/G65zcMWck7LTRucmM6TaUpiyLfomRWWnopPnHtq1Ea1Ff6sOjbkBSNJOKkEgyRehth2xL8oXwQ1VxCV6rOWSbgs5s1wMFkwCQ6D97xLBYvbLWYDFjvWNvBopkrPxpPRFTK0d9LCDlUfY2i1TQRaScngZcbwOg32EsNcyUi6mRlWipDx/3bhmbTU9VSaR9gcRQcLfsDT0Uuz2d1ETnEaeEDdML5k66XeJciItzWuZ4khhRPixbfdCvai29LPkqy9IdQ3MOpYLLxaVzXr2Rl8npSvALTDvaRduX0EBALmYgdiCo7lZKNkz+F0BNx532AOYwk5450xeCrbHP+yModkDEbVl0jooojb6vl2Yr/IrGTL6NopUHbNQXC+3/WLsPXYQl1BMTZjADIJGWa3h0ZyzHPANuZaXUo2wJdIA0ouwJ2fkcs3SU7NxAvBsT1r8VZ2s34FMaTngoRpZ6DTyDslFIkJ2W92GRYDDd0rAm/nyb+WX/UEQdB/0Gv51485XDQDiN+yjZ6ZU34NUhn5Uo8L0ET+rAI7Y1d7hdoMJ3IWNvzg6OQfLykEpWIcnc0K+Djwyu2wq8dSnB5FLNlUcHHeM7bUe0n2ixcog6FN6EuLcbHcoiLOcSLIlJJhsl7OlglKjUlwp6WmodYRvY93MyXZBoH0+nU4rkr07cjqnpssmTxVpBbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 07:15:45AM +0200, Alexander Gordeev wrote:
>On Fri, May 08, 2026 at 01:00:40AM +0000, Wei Yang wrote:
>> On Thu, May 07, 2026 at 12:32:09PM +0200, Alexander Gordeev wrote:
>> >On Thu, May 07, 2026 at 09:34:33AM +0000, Wei Yang wrote:
>> >> >@@ -310,7 +310,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>> >> > 				goto restart;
>> >> > 			}
>> >> > 			pvmw->pte++;
>> >> >-		} while (pte_none(ptep_get(pvmw->pte)));
>> >> >+		} while (pte_none(ptep_get_lockless(pvmw->pte)));
>> >> 
>> >> As Oscar mentioned in lkml.org/lkml/2026/4/27/630, map_pte() may take the
>> >> lock. So probably it is not right?
>> >
>> >If I read the code correctly map_pte() might take the lock, but also
>> >might not take it. If it took the lock and uses ptep_get_lockless(),
>> >then it is fine. But if it did not take the lock and uses ptep_get(),
>> >then it is an issue.
>> >
>> 
>> So the rule here is:
>> 
>>   * ptep_get_lockless() could be used for locked and not locked
>>   * ptep_get() only used when locked
>> 
>> Right?
>
>Yes, this is my assumption.
>

Thanks, if so, it looks good.

>> >> > 
>> >> > 		if (!pvmw->ptl) {
>> >> > 			spin_lock(ptl);
>> >> >-- 
>> >> >2.51.0
>> >> >
>> >> 
>> >> -- 
>> >> Wei Yang
>> >
>> >Thanks!
>> 
>> -- 
>> Wei Yang
>> Help you, Help me

-- 
Wei Yang
Help you, Help me

