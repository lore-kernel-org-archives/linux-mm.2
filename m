Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 686CECD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 15:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CBC36B0113; Wed, 27 May 2026 11:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57C8E6B0114; Wed, 27 May 2026 11:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41D836B0115; Wed, 27 May 2026 11:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3248E6B0113
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:35:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C1E540638
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:35:46 +0000 (UTC)
X-FDA: 84813599892.16.392A75C
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id 45F5540011
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:35:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EmusWGbB;
	spf=pass (imf27.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779896144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/34ZEKo4WKYSNfKeZJyC5zY+tHi9Bq+q7x5tIuisplU=;
	b=Yp6JXWJdE5cG50IJ/kCOB3uhRZWfv8dAQSCQNp5Cye4WghNhppi1BW9xy0rOc712XKIvLR
	eZs6O1xo4NecJVVYhjMbeIz67Sy3PKcu7fC8M5o5OfyWDmGOv2uCVw4HOB0pHoAlQxLojg
	Z35hSq47vG1wJVaFDURgXONH1m501XY=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EmusWGbB;
	spf=pass (imf27.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779896144; a=rsa-sha256;
	cv=pass;
	b=qV+ttriEyU24t+j+3CgfOA61Y03VB1O2tusgSFUguBZi9DDx6a5tGTdjSyPjXK2Qbky39V
	3AxZDAtAu666UNdVHPTMMK+506Ao+v5FXpMonuGG7d7L6yAi+wusz8aaxMp/QxYorCQgV2
	xHEP1D2pZ0gnL06yhjZ/hgGoOnjZewY=
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-133466cf955so31400469c88.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 08:35:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779896143; cv=none;
        d=google.com; s=arc-20240605;
        b=IKwEW/qud3cr7hKFzoM9A2q24vntSdFkA+GMK8/bch2k1KM+1qCOMKvNF6IlgJwD9H
         N4CG3fD0ibzp5+9svPHQoqE47o/g6HMjLjkXQw4PeXXjpJ9pHtQSdSNSch8uFTCuhLWZ
         aKvsC/kPXJkqAehck8B0xf57aNnwFDb4VAhCFdIHONCT5DG41lBjBKOJCPBgy8tcaLWi
         ILZV9mhgXa+s71HJKlP32ySVK3asCKgBcxM2eBb02kmwsOl3iHqn7HSDNcBVghBYDlvj
         reqKV7EvjV/a5nbZDGXaBpVZVutcOYSwKFAk5az4+R9lVZMxqtD7IgpLFvibJdW4csbQ
         Rr2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=/34ZEKo4WKYSNfKeZJyC5zY+tHi9Bq+q7x5tIuisplU=;
        fh=AoAE7ZbhdMVVTsOs0QpoglDOFnLseXZMqHtZhV70IfY=;
        b=PgmzYNXJZZTemLvR8ot43Amw/RGN374pMw/bWZnaOkrOe6M/FIY21rDZLEICgS3fRe
         /yqmGLwNC/lRrF03G3NwYK+wZw9uvV+N9M4lqBEr5PSUYfh7zCyXxMbBZ80ppQC8kDfv
         loH/XzXRKd2Zij5ZX3++lGDrq/oiFuMu9awJzeCX+FBdELw+MKz/lZeoHAQ9khqKMNIt
         RfKkPGK9QI2+ULkRXz/8OWIVW66P6Fc/x07HnnyXGNTlbCR/bFr0bBX30nZjpkdtu3O/
         NNd8+b8U3pNu+pJgtPOHoK4N/M/1pwgozS9pEaRkIwy25XYkm0U4NqeUkcGvO8KMCu0N
         w0Vg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779896143; x=1780500943; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=/34ZEKo4WKYSNfKeZJyC5zY+tHi9Bq+q7x5tIuisplU=;
        b=EmusWGbBMpZ4Rx6yEMZopRQO9bsQJ1kumhm8f6U82dhvDJuMfhTWwuk4lAhaCSEiQk
         j22StzO55qdtIfBBLBUMl+P7OhIVn3k2XNrfIir0mmrRM42Yl8khYJZpeXpn6mOUizHe
         JVJfCoUYbZSZGu1onfr93S/hPqyvFfNYyNO9L5J5HvkkbPWImjT7/QWd9UMDnfzbBi12
         qqZYe6AdGabEFKUnH6rId1tisKpFTGukHeN/JV0+CPzY4zMIRRvfhK5xUu6qKoUGsP+O
         qSOm3zZpoy4wqzxBr1f23OtGAuiC82UwIqezvCEEoJfPNgN8OH1BV0rnWXupY8wZ2KNX
         Rcrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779896143; x=1780500943;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/34ZEKo4WKYSNfKeZJyC5zY+tHi9Bq+q7x5tIuisplU=;
        b=qQmttYATdsDlg8AiD98a1Gv4dwhm90kVN/1/TuDhBjHXph6GhYj4vZ07U8j6gbUjCt
         CO8utvUxdONLa/sl3eIOvQpwhccejUWFlM/No+gqujmJtt2bZYiAYwCQOErDbIGVIGqU
         S48zC+FZZPVa92vM0m3FSwushjWp34a0b6dvrTsF4h1TKWwrSUMcC2vsDRs8uyOkmGdG
         01s50kI27DjaN/U92R1Xb/LtswmnkgJnk2j1S0mkYyvHDtLT7zu5OjdGo+lDCbBHXS/9
         U95fWEB1UWENVPBlFC2uvaw02QpUZWW2QDHH9fkZBqICXlUTHrr606aFr9ZrvENrIPvo
         Me9g==
X-Forwarded-Encrypted: i=1; AFNElJ+P8U1792gRVXaX+7xeN/M9n+iuk65/cU5xE3zDXPoXHdFAzxUA3fNEFvUyX0cSBaq+kEXYun2xcw==@kvack.org
X-Gm-Message-State: AOJu0YygIQSNABe8XwKT5RraBiap1rCWA45Nj/7R7ruIHaBlJ8zieHzC
	9AXMtvpBgZbEQrvEcOWjrHUidYVE3Jejxf3dWbcOGAl15qL1j8HdwaSy4uLvj6l6jWKxUzxyQ+W
	wZV4X2lw+jPsfrn2I5JYYzFy1GlUaW5eHa5isYgul
X-Gm-Gg: Acq92OGHC981LOeCY2JXZdvLsJRUmzoRKGLralEZGTPEmS+pS5kaXeyWph/wFrfqGGT
	t4W3HRy+VddY5SGU8uLPvNqYGlcP6Me6LJKoZpwXaNS6HPmFFbgW8sTGiJiJGVq5aJJA4JBWytK
	Xg2POKy08AtLHqlLDLgJv0LZJSaTdbQEvAF0b8nwWzBG79Irhhs+fpSGwf+hSeTHdC58Le/R4+G
	rJZ1pDaKwK+7cOmB9D5tQd6BIiXCd32KA1CCebHrmnxkRHTwwHeS4fkSMs0505VU8j0oIgz73Xq
	qCNcasKCXAalNor/iSrOqM3jdmgsjAL6qNi6GMLzCjBfoagJfw==
X-Received: by 2002:a05:7022:525:b0:128:d4be:7428 with SMTP id
 a92af1059eb24-1365fb4fa18mr10605757c88.19.1779896142087; Wed, 27 May 2026
 08:35:42 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 27 May 2026 08:35:41 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 27 May 2026 08:35:41 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CAEvNRgEZ9vCKkoMC11tVrueAonGWH2x6OeaYYxXGEj2gwHUaKw@mail.gmail.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-5-91ab5a8b19a4@google.com>
 <CA+EHjTw-cUM=FrJevtSDtR7K6MwUfGfOx21LMFDn7DAy5bFzYw@mail.gmail.com>
 <CAEvNRgGQvMdDmVfbk42EY_PGN0ybTp-x21Zj+pg_X1mk9iCRtA@mail.gmail.com>
 <CA+EHjTzLCD-dU-euZKgzwyEr2ecPqFDNutcaHm2fCDGA+MHVXA@mail.gmail.com>
 <ag8JIlHjohAOC3-g@google.com> <CAEvNRgEZ9vCKkoMC11tVrueAonGWH2x6OeaYYxXGEj2gwHUaKw@mail.gmail.com>
MIME-Version: 1.0
Date: Wed, 27 May 2026 08:35:41 -0700
X-Gm-Features: AVHnY4JKedjh8K8TNAXOjoVnM50DfBi_EKpudGArqGboylLRPDEHJZCPBXCFwT4
Message-ID: <CAEvNRgH_ToNJunEmQKn3wED1aF02hwg3GrQcRwwZTs_bfPVf_w@mail.gmail.com>
Subject: Re: [PATCH v6 05/43] KVM: guest_memfd: Wire up kvm_get_memory_attributes()
 to per-gmem attributes
To: Sean Christopherson <seanjc@google.com>, Fuad Tabba <tabba@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: 7wqphn6d3p4rgnxhdkxursaqsdsfkhxs
X-Rspam-User: 
X-Rspamd-Queue-Id: 45F5540011
X-HE-Tag: 1779896144-841064
X-HE-Meta: U2FsdGVkX1+UsqVKlIgfOhjk2EKtM/yi71uWYI+pbpGJ86GbCI0bPnyHFW/RrObZYBnEEX8QddJdWTtSKvZWGxxn5DJEOvsAgKltC+cpW0LIC0+e0WsLdKKGJyHC6o1IaQI0pOPgp9HaLaRt38DEr3S7cm+etAugT8GCds22g12Fx9gw6b0G4+XWUP9Sao1gVcaYuvEjVN5o2A85hBeH7W7HPkDlyxTYCXu/IJJ8DLmJMPAg4eUIKFgwaK+eY8jfGmVztJdtVkNnD1pzc93vNywyQcPV+FrT9zazKATR8ErSnclA73faJLfx+jBk6gY9iyOMcqfKD7KKMYXYjT5uW1izqpJvs3/mUEju+CRwKxgYNlxuFSIt4Ty5paE1WICmSvmyN5ZveV/n9SIFLrlAr4tFvMND0EQRPUHkA633oX0ckQcRH0KYsIfb3hW3lo8E2HpdGFO7ch8mbf6tF9eVtZk3r/uPw/eC3T6zsekEuqUhXH++jzR+MwdhI/zn8CZDP+YPoIUN2v8c1Z+Drp+EpNYSWS7xexnbZJXvp1LA9uESxAqrMs50ooynQFbMxqtOP4X1nMXTGS5ptMD+AW6//v556xP9d1oj44bG2M1cPZI/IqXQf+8osPjR8WGQEknIdrWr3IA8ukf18rFnO4qE5mU0EFT7F2ZXcIZZaeM7Dw79Z+6CfMdZzBNBy4VNjn0nZVfGeNb1tzGCAm6PgsMyzPXD+W4zcXtkp6QOzs8QN2DDvclMX0z6gAbK9MKNpv8/7ipV7+gxxDtvHXYkbRIn5pb3IXLJGwPA9n3DzW4lMoTykLiXIyWRJmeEVjNfbinoOK/UfL0eN0GRKa0tJLRxidPWLoJ9tT7t7ORMyNOthkDOkjIGuhrZl53kc0nyxTZanDqXu5GygYpOxj35p49gqml10Ba87/kAJAKBsC9QNhahMl00fq8A3epSMHRO1ydwTBcWmayNTKGfsHUKnjA
 Whm8iAHw
 CXyOBcmuJXRyiQ+PYQHsncMgjIE6LpNJUsg+UxamfxiP6e7tRJa3783qHR5+aekmTy0TaXhAaYEkWK6yvlW9lB1g3Aom2I2Xy8aIFvlk1x2Dn0jYMXvEN4I3lAUl92rQroWyMTGvVgk8NyAJq5Sbnt3X6jAGjnrgDwzxWFfVqMahL2B4wzDP5gCvcXovozwefRthB4KfCSNytFslV8qKlxdUKjU9hu/doSs9JFhmsUfkeZhuUsXmV04JTLiTFOIsF4EXuQhqsVHS+wKPt6Ar/P+P7E2Ox9N193ORWdBCXvq9eFP/Z+WPr1hp+QGjhFcdpL6ZkKFG54l8E/5DLLXW1EGmBUTkt/PTkzv8sTKAkjN0CjF29ohZJh8ZRuQGiksy4fbzXpzW3KdPCw1XJtf2LxL5CYv/hZzb5RdwVJas7Kq13tHfCZefx/CdlHkF/vXR7lCz2wxZ7QdVkeHQdCPYEKn9YqN5/X1pk6gDC7GaEiRHLrSUBuh08hSfmquBlUrxUObFzI12qeSS6x/jy86He8EYB/f8XbeNAOaOOG1nnGbzIMxVt5H90Qb1mJX0G7ZTLu1t362kss1p8BE4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

>
> [...snip...]
>
>>
>> Hmm, I wonder if we can figure out a way to consolidate some documentation,
>> because this is _exactly_ the same pattern that x86's host_pfn_mapping_level()
>> deals with (see its big comment below).
>>
>
> This would be great, are you thinking an actual comment or something in
> Documentation/?
>
> Perhaps we could iterate on this a little with me providing the newbie
> perspective. Do you want me to take a stab at writing something up?
>

Please see https://lore.kernel.org/all/20260527-kvm-locking-docs-v1-0-4fe8b602ff47@google.com/T/!

>>
>> [...snip...]
>>

