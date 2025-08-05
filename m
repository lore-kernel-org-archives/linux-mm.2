Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 573DDC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 12:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAD926B00A9; Tue,  5 Aug 2025 08:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85076B00AA; Tue,  5 Aug 2025 08:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9B6E6B00AB; Tue,  5 Aug 2025 08:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B9E866B00A9
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:39:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7B6921602DB
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:39:28 +0000 (UTC)
X-FDA: 83742659616.17.1F988C8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id C47A920006
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:39:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VjJ4+4N+;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754397566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5Y+Zp/i7E50G0WGTS0Sm25Wg/EgJru81SUTqhRCQxo=;
	b=Q22Nm6qV4Bniy4wg/KgYYglKqITHA+u/6yf1Qxd6NmNTCAh40zkrYLOU11iWH4iDGk39Lj
	tPtpR3nrrwCO9b4DFb2ZTbA1hiU6eLD8rhfJi8T2Dxbf86OPVEUC7mr8alb7EWQstrTQQI
	7HK2OeTkcQ8EaSHAQIFZ6Ggd9bqQ7m4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VjJ4+4N+;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754397566; a=rsa-sha256;
	cv=none;
	b=JsmdKh6/ZT54N4rr3DA/dHaN19kh19Lc6vNFvez9k2QBbLte+bTxdP4SWa/gYVCcRa83i1
	+jDJnGRd+2BP5rTN819jZhugpK8iyGeOIS+441gi6DEsRFt3Yg8U5okscH61q2oLU3UWvM
	ue1euh1FkvI8LWXW4EM/NKdkqnl1xak=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754397564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=m5Y+Zp/i7E50G0WGTS0Sm25Wg/EgJru81SUTqhRCQxo=;
	b=VjJ4+4N+B9gkEZX/MMnAk2LocBWBAPD8Iheif11rD69oPWN6X2IFFDLrl5Z5zwhbyAeoJv
	NrQ85wo8L6WR1aSkHp6t7EABS0Gand/Ky/Rgs/5i7lsA5X4OA+/rhKXCsf9SRtcJC9PgMl
	mofTM7EOI3dOEGBnx9E3foVX8YYjJW8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-cjMMcqj8NGWPlsLno6i_nQ-1; Tue, 05 Aug 2025 08:39:23 -0400
X-MC-Unique: cjMMcqj8NGWPlsLno6i_nQ-1
X-Mimecast-MFC-AGG-ID: cjMMcqj8NGWPlsLno6i_nQ_1754397563
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-459dbbf43c0so9279325e9.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 05:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754397562; x=1755002362;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m5Y+Zp/i7E50G0WGTS0Sm25Wg/EgJru81SUTqhRCQxo=;
        b=EJJNlnRcQteZvUTBGHF2RA1OuAlZsjh6hsliRooFJ4kf2T8/0Bg0AVChMlpRG8+8qk
         6kGXRv1DRP4P5KmrEVN7nFz9qikWTBmzrwX1UUxeuZORA67ow7RtNsfusbShqYrUSN3p
         HI428y30TS7BDNVDdENfWs7GfHNQsIxGdEqgEl7dvTkVMrcwY/kG0hM49gIb4od6J6Ky
         oYiAEbWwcMlyBr5eZh932K1FwuM+1rKYei/F8zzfvakiEC45+jikhCaUx42g7GlIkOhN
         Hgpz/FutV8MGZjnW4VzdHwRhSUghyJRySKar1fUhG1dv0G9YEYNxUlsGa64qHmg6kPzQ
         sqqg==
X-Forwarded-Encrypted: i=1; AJvYcCUeacFwi86R/o9YIE/mCOtuNzZhgzst/2HAvAwfn1Ii4AfF0QIRM2u8re49Hvfnyuo+SW1LYMBvWw==@kvack.org
X-Gm-Message-State: AOJu0YwlA5Ac8VBG89/I5a6e00aQFWT0jhVTdeuZQNtWJU/F0RyfVwq6
	ndRti+/lbOEKriU9DaRinRgWkheYgBjXgUW4Sjgy5Zxbd4c9T72DEKfQPM68/Q5QxqBkNGXtjBk
	fAlEr1sY+t737COGfDqowxrPetjnExwyCiyAFO32FsAgnvqqyycbQ
X-Gm-Gg: ASbGncuo3zD3jeBjkrMUYqtVkmZbOkFisbTasL0Ak/Cqxr0Y25IwRdoDmfuddGWywkp
	DlLcjKrOH6miLhQmjO19JHEOwjr3zFXp3VSp2dE9S+hjYRwZGCIR9ug+ie2yXxyX+CpF/L+8Qw/
	A9nGE8HJ4zh8TYHfSk6pbBDSzpm5Kqnh67UpT0DrAP3J2bqJoXZVVpcySDl2PYu09+6K0prfKb6
	/nwECrTtJBQ03qO0Pa7bKo2N6tW5PCeMMqSHH53VxQuQhHiVmleEE5DXFAbswlj3OH+I3bFnBcX
	MYs619WI0Xd26jvorYNpuB7PHhSEdFWE3JwxUKIGYG33ctFUVqegYn7DrmQZInR4QvUQOm4=
X-Received: by 2002:a05:600c:6305:b0:459:d3e2:d743 with SMTP id 5b1f17b1804b1-459e0ce7d64mr25782625e9.8.1754397562394;
        Tue, 05 Aug 2025 05:39:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9s7iANb1Hl8Kzi4LwMjObXbUhyYy8qTBI01O5RhMA7SSDeNZ4hZPMsdRmz97VTDrMkp7u7Q==
X-Received: by 2002:a05:600c:6305:b0:459:d3e2:d743 with SMTP id 5b1f17b1804b1-459e0ce7d64mr25782265e9.8.1754397561835;
        Tue, 05 Aug 2025 05:39:21 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a26f.dip0.t-ipconnect.de. [87.161.162.111])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953f886dsm260816025e9.30.2025.08.05.05.39.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 05:39:21 -0700 (PDT)
Message-ID: <66c2b413-fa60-476a-b88f-542bbda9c89c@redhat.com>
Date: Tue, 5 Aug 2025 14:39:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] selftests: prctl: introduce tests for disabling
 THPs completely
To: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
 <20250804154317.1648084-6-usamaarif642@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250804154317.1648084-6-usamaarif642@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: psCbmkE5eH_pXuohSzndBocFeqN0mTH6Qjx1wvjLd1U_1754397563
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C47A920006
X-Rspamd-Server: rspam06
X-Stat-Signature: ux89xyq7ppeznn41e75xpmnywe4oxnyj
X-HE-Tag: 1754397565-324175
X-HE-Meta: U2FsdGVkX1/E+tg0AhVOWT/gL7Iu1cjBHydNI8CRuqhV1oe5jCTMmWDLJfOkICsQrPpLi4nNASTTq4zQGiFj7AjAfRyGnrLy7Ijjcas2mXP5rc5dyV9JTXreCsrA5uaavvm8hUGTZK87vZrMkyw2E+JyzhmwMBDeNXlnqHNJaLbK6crzIVSG4eTdsEfdTQnjfr6aRqxMx8WCDlZsOLGeaoyyhORxzvWx/t2pIxuLSrAQDSKycNYgKVwjYL9rpFDv7SfWrXY6QYqaVB1SMIdQJuoDVrG84EvEmCsT7OodxZAc93O5jfZPi6PWL8zIZzDv5gMS/xtOZoHT8vNLXz+lAr3tg6Mnotq4K/0m44FDl+3CSHnBHtoLHSSvjgbFeHfJ7Nm7TSCGx+pDYNYy6SOB/AywzYIYF1WiOCfHInRHwZC1Sp3fKCeiGr6xu5AOjKXFpDi8/i2GVNukuYAFjwOkeLEXb4Gu1womGq6sMI7uPkPKU+Nm2Nate+a0/F7kVtb71Jo358YCxc508hyPvYbIjsvKQtHjOQnlK9Pl9mOoQkJcIWUzX17QFqZazc2i7CdLr2T8PipRfgAhidDGLNizL7EN1Dr+dbqNRZpdfhsZk1PRuVO3hZu+8Ahkyskf/j0y5f7KPiLJerg1bfFq1O4fhSudrh25xlltpYFaCkdRCd5AeY09tPzucK2SIOPXcSXWJerF9fZ9XD7iy62kJoF27rMXloAWdKiuzqowTqFTUNADmTpjbqpXsrHUcT220FT7m+iFktcV+QjlMT9HZuMrqyKuEC9nYh3JytZYQb+ASsNN42saDcHiabo/hGfjpg1RePcM0R38MQWtipX+nnpqtZ3SiXL/ZwLpmHbHVm0WCyuGNbej+nls18Nx3JnSB/2oawHUC9/cMFkg1CBopYIqTrfGkbI+gl+lC4wz3Tr/FnA0oYLJxfovSRBtGzX7jyuxhjKqFKEOMCBQg0poSYi
 um6OUC0a
 32rKPBPcyWiW4J6he4XelNwTLuvsdtSBCa3UK5VnLNRVcLjqrwzcdmdYurz3ru6aV8W9K6n77SWhNDhSPL39PoIdgZn1t9V0NM216c9v8uflVTfqoWzYTpX0X1QSKjG+lkGFK1kDZWXzkLmXnM375KL8veR9FmJ13oU5+sGsueh0wIN6ax66B9tdWebEreeg79KzlthlTsJ6NgvZL150NLpu2BC3cI0lXpL354CmmzlW6IFjxAHPFhdKHVDMz/RXhAOyokAlkENh9sSk5KVWFWvB6pRhzVNwgfSaw/qkcbE8NCqjtnE2DC8a7R3Hth4CbDttvXBhh1YIE+1sfgaNc5MJMuIM0dD4lIzJGTNelfXz942DYeeqs4llk70ZKoejNQjlpDtkVGxuUGjDWiUBMtmmfJdhtycOJGyxEZDnV5ZHh6JqeBGE06NWE+xSm5KDOQ2gVqH6cItHPuwfkxd9YpQCkf5vC3rwORWtZ1aadMgj3aTM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +FIXTURE_SETUP(prctl_thp_disable_completely)
> +{
> +	if (!thp_available())
> +		SKIP(return, "Transparent Hugepages not available\n");
> +
> +	self->pmdsize = read_pmd_pagesize();
> +	if (!self->pmdsize)
> +		SKIP(return, "Unable to read PMD size\n");
> +
> +	thp_save_settings();
> +	thp_read_settings(&self->settings);
> +	self->settings.thp_enabled = variant->thp_policy;
> +	self->settings.hugepages[sz2ord(self->pmdsize, getpagesize())].enabled = THP_INHERIT;

Oh, one more thing: should we set all other sizes also to THP_INHERIT or 
(for simplicity) THP_NEVER?

-- 
Cheers,

David / dhildenb


