Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3150ECCD195
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 15:28:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 623E48E0006; Sat, 18 Oct 2025 11:28:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FBC78E0002; Sat, 18 Oct 2025 11:28:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5116E8E0006; Sat, 18 Oct 2025 11:28:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43C278E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 11:28:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4456C047C
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 15:28:51 +0000 (UTC)
X-FDA: 84011617662.23.1297519
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id DEFA6160008
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 15:28:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ge4wA8r9;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760801330; a=rsa-sha256;
	cv=none;
	b=107PH1mHzcxnv10w59uSYfIWr0wiR0/ExhxVLQcdIp7MuOVDfhCaff6Mrx2cT0njtZD3e9
	GPGGZIfl+DTgXZ5im6naqS/YcSS8XvteN9LO7IPh2huzxt+LSjCTl1a4jxBROrBceGVP4a
	eo6FCiMz4bXlp23h6ufKSktMFUuEJkU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ge4wA8r9;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760801330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jp9qkiE962EqU6AuwTutKC7YuQQ5b1pauuoLKIDWLOA=;
	b=6fq3eC6hyELR3jmFRWJpVduieWNjWJCuyBPYxkLBJnS9oEbGVnMvdqVQedHReifCwP+LFV
	DGZHLXwhlaEY/4TP/g1krbiqMkFJx1clAu7lGy5y4BK1jX1Qtx97fMtTN3c8tZ4xawyM9Y
	aw6xDGrEjUcyhrmYIKTjFzU9rETuXsg=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-63c489f1e6cso1531589a12.1
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 08:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760801328; x=1761406128; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jp9qkiE962EqU6AuwTutKC7YuQQ5b1pauuoLKIDWLOA=;
        b=Ge4wA8r9qwLtHymLska5WfoJKZw9AjpVjx62mVQqJAl/ZFkNaCSbvHHHDoKsFQVQXF
         DoiXv+Ub/f9x0t8IbhhtohnVJUNXReqaC0Cq5H13rXv25ZGsMhQzj0btOcom4mExpOWK
         eAkbv9YxqhoMOrTRD2okVGXxKHDtRpKi52LNDOmbsXwKkTOCcagatT9j7APQyVlibjlv
         Tx1Apcj9bqQI9LqSxY33OO5D7NU1MP931v9cuv8yCnn6wB4yfCVjkrGaQpizPznauktS
         qQIvDnfJAMFsrqeVzUPY0FdNpwU3IG4TLADq4hQ2TOvqMlPOGPpOh5VsScI0Ps1iRvEI
         JzQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760801328; x=1761406128;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jp9qkiE962EqU6AuwTutKC7YuQQ5b1pauuoLKIDWLOA=;
        b=dpo4k/FxvNzKd/PeEhQHRnZA9huC7V84lHmEc9/YkRjBn1FeIRojLkL/ROCGRIKKPO
         8eEuCXG44c0zCKD4LhvlJEpznLRReV7MP0gUbPf+QcGiOso8lv6a99udKvVCBzV2Buez
         oj3W0vzcOEwuddwx8UsYD5X8hVHCww/E9eTGBpBWAeLaNUP7x6Xv/uRWtB92en/kRK8t
         03SknC9ugnayVldVz59pKG0L+qT07e6mPZaQxfUTacVr8nER9SzY6w8w07R2g15BJxb3
         N/t/l9Xk2q/C2aFYUGY8Uu7S2csijVsHsFXquma7phOnI2QgBG3WaSusxVuDDijbsZ/f
         Icvw==
X-Forwarded-Encrypted: i=1; AJvYcCWe54m2LyvkVU/ebcRqTz6pHt9rf4Tr7NyTzmFxXzZUtgGhmQv/ZYgopYjiOnIG4mBEZBPDC2e15g==@kvack.org
X-Gm-Message-State: AOJu0Yw6dulPAuFzhxTOV0QhjkGEK39s5/lQRB2kwjgmYvnN3MCCh77C
	V6xkLEmQ1mo9Fj/nvldGSNFnSNU4UydD7VSWW26WkUoRTOOsDqcvBEgRawwhoY8Sg+CY/amsdop
	A9md1LD0gtd0sFywj143ePagijo3FlmCvf6IEi43vUA==
X-Gm-Gg: ASbGncsVRIhQ5cIzBdu4Sl4op1jDK3U+KjbyKEKbw/Yt5l9IfW36kCqNo5u0GWhP6A/
	CzN0xefeYzg9e/WSHapP250JnOK7XXAp+5R5eYX1Can6liEZclUTAt7bP7RuhND/couJWj+dwPM
	WW+H0bL3tOdUp0rioaQv7ShLLAf59JFLmQoFQzMWUO1mjuA+g3aXvkO+xVDlo5iYZvsObe17IF0
	26YLdrvsAawcQAfpbBi65AGOKdR+vwYus1rZO+6Y9bmbBjagIRj73MTRjrpJrSafT0AUOjaVmW1
	FDxuT4SEcg/LU5HC
X-Google-Smtp-Source: AGHT+IGD+GIZ6cxCDQx+cpZ1B+6x/CWUhSAiqtZJo+SqncV9lu3xa66p7nHm+gyAAx9koD78PZnXe2MMWr42HEQvxQw=
X-Received: by 2002:a05:6402:2713:b0:639:e5da:637e with SMTP id
 4fb4d7f45d1cf-63c1e1f212fmr6981739a12.6.1760801328092; Sat, 18 Oct 2025
 08:28:48 -0700 (PDT)
MIME-Version: 1.0
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
 <20251015053121.3978358-2-pasha.tatashin@soleen.com> <aO9ZiERHff7vQiBL@kernel.org>
 <CA+CK2bA5Eyz6TUMTy3pa5HBvZ7KkiHX3EHn17T=d6LX_X5i3bg@mail.gmail.com>
In-Reply-To: <CA+CK2bA5Eyz6TUMTy3pa5HBvZ7KkiHX3EHn17T=d6LX_X5i3bg@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 18 Oct 2025 11:28:11 -0400
X-Gm-Features: AS18NWC5SixWaTv6tISYyRfabBu0M2TA5NSlq-EJV7berBAV8wLpo3xmXCWe7Kw
Message-ID: <CA+CK2bA=g3r7V92NCYZDWNKPguCM5EYdroqHxEH2YxUy68iDyg@mail.gmail.com>
Subject: Re: [PATCH 1/2] liveupdate: kho: warn and fail on metadata or
 preserved memory in scratch area
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: qh5wbac438noe5ehd7n6hayg4mxh6saj
X-Rspamd-Queue-Id: DEFA6160008
X-Rspamd-Server: rspam09
X-HE-Tag: 1760801329-461012
X-HE-Meta: U2FsdGVkX18assenIPpWZ8fVhkzF9z5nKETT3fp4+SoiZ+tRaoCgqLuumZ9krFYYUSlP54wtmIZexWajFaWuaEgz3Bn/Q7qhG7HiW4ndZYpRm+FtKDMlj3cAUKaU6pjUizU7kBWyJJXAxvNw0UuiXYAURSX3owT7RgT5hDuCiI/BRIv80ngtMd9pHkTZyUEklVPMmxHd7OeThotZeiyHcEs3ZbC8h2C8MSYOJIooH20vdf/kHDuz4KDfmU76+YCEzTcsygqqm/NZFWdCTfipJaEOY0FkKPOctC2EJFhVxjQN5yfUGwwnzyYA20y+1XeflhStPVcV3Ldc1Qs4P5p433F34qkdf1aD3ZnfJ4e8wXw8de0vsd1x2CYijnLA1fpVDtIfKdV/37NtQOLj9xoeznGTdpZ9vG9vSlJZe1LENKMwFEMU3iXOYBva1Z8Bp0BgR2dysMkog6J4BfdZlmLpDBwppaix9teX8n8paEXxjlkoSXKWZJ8X4r9btlrnd3TZWzseY2slz/S8e/twmrsdmNat9kbjUakBrNIa5uorz2J1eFRRF5EcjQobU2LoMHNcvY++T//e2CQRJfUA2V3RkzIysEHairEc/GSCWfOUbMBtN2qUKIeM+ssj2VUg03WdbF9BfBz41JaSMigqRFmSWfyGUBZLavnAIo7dJTnAyd+sBcwOlQBI1u18LKmSjqf8TA8lpIJBeHDGY7Rh74WMBdJpPHsBFUJLAU0ar7fBlsjSFMHbkjTtjXlhrdcbBBm7n8o/bQTwebVW60P8XvBOd2NEnDgUKuuqd+whjcTZyltCFilpLLQrfE7QQbDbBFFrQKqdjLpVWA3OOwv9rB94POkLGXoAqfHEvb3lv1HL9d3ENrjrQoSOD38RetoSIPzs9WLPju3c2awCT4tBolMGL8tDRx08kFZ8jPniJ+aOaFJMJb81uZoFQAZmBq+GTSe5xfH21v3sExSu0ES5r10
 mFyZNIOy
 E3XwkTnFTituKUJNCyjDGFKSH87jNhvWTpWgzEOYB8ZPU0aGOEV/QZHci7IhHxE3JOYetRIWWjYG1H/wzh0qRn04KG5U9h8Du0HXXkCyWm8RhV1u8lm2z7PK5ARIT3dHh1Gb/KvCjSyKTXLnPl8vfO0r5xcOc3Iaopk+t3su83qxQiqF5rjDIoRDSCjVL5BOiN0lD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Can't we check this in __kho_preseve_order() and not duplicate the code?
>
> Yes, that is possible, I will move it in the next version.

Actually, I decided against this. The check might be expensive
depending on how sparse scratch area. Why make it even more expensive
for kho_preserve_pages() case, which might be calling
__kho_preserve_order() multiple times.

Pasha

