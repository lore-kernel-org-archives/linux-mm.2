Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14C70D12D5F
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 13:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622426B0012; Wed,  3 Dec 2025 08:19:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D2F46B0023; Wed,  3 Dec 2025 08:19:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50FAA6B0024; Wed,  3 Dec 2025 08:19:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4111F6B0012
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:19:57 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6343313AF3B
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 13:19:54 +0000 (UTC)
X-FDA: 84178217508.14.40DB653
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id D129E8000D
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 13:19:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RMgehdpn;
	spf=pass (imf02.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764767992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZjp3KH4oYjoP09YFcoEfJL55iESyRosmuIgMEErB2I=;
	b=6GiBJjRBkhQmVJVhiTb2rlONo1HvIIGFoI0WFnWIG3GxitTkxkQ6izFrw10JueBolO7KG+
	5DLaMHISW/SujdR7HpKQQ4GmpvYJw0fftNw57OfGadwXe8c9CEsMeYt3RNcj1/h8h8weyD
	tXduGHZuPa+5fzsZINGNTanj1nCBP6Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RMgehdpn;
	spf=pass (imf02.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764767992; a=rsa-sha256;
	cv=none;
	b=T+5ehiea60rXwcFGjXO+RkrbRQMz93CE0MpSVrWHASNzSsf1eMl+ivkAoXn00ls/68nWEq
	0HYe3Z9iSGUMdCW+RkeZ37lPESZkIgEVonJjV4KfoivwMBzC1W/O4ECCmypkrrmavYdiwL
	uvayVCJ/nVGG0V2RZGgnXtAsDvvyz40=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764767991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KZjp3KH4oYjoP09YFcoEfJL55iESyRosmuIgMEErB2I=;
	b=RMgehdpn6Lv0a5u0y1kbJskkyNZnUEsuEhGGVcZyL6uXBKP/ZtLbcXVeZ+HOMhJ1VRUOYb
	FmsHKblNZKNSaqCVLInjm/fZAtrsnOMod9J7+FU8wBHmJ63m6jP87rF22nTjKp/lZn2sh5
	4DVYaYmKyTc+L/1EpeY2xfl5IeftR+Q=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-i-Lo1j7fPkaMIH3DDc9aNw-1; Wed, 03 Dec 2025 08:19:47 -0500
X-MC-Unique: i-Lo1j7fPkaMIH3DDc9aNw-1
X-Mimecast-MFC-AGG-ID: i-Lo1j7fPkaMIH3DDc9aNw_1764767987
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-882381f2092so208671016d6.1
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 05:19:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764767987; x=1765372787;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KZjp3KH4oYjoP09YFcoEfJL55iESyRosmuIgMEErB2I=;
        b=coeCcq3+5Cgb/oEtnn4Q/XaroQAAk27IwlB6jL/d3oO9HHuRLWRWJ3RtKuZN7Ri7+p
         tafdIFm2PGT90i1q/AlcevZ7PYIl95LYCF6vHWWRnccNrVZnP2s0hhtm7cS0iTz+FfLA
         sA6kkgSpjrlJcTWWINIlqadVvUdE5UO/gektvfcxuN2JKq5n5id8QoLssUWmfkO5FXH0
         L8gjE3e6zQrgQU5spQmhwZIgZPIIQIwSkyXPWvY0DJAsi6HtlNHRQ0x0kDmjRVVdwgim
         cmndJTOeKQ0czXzYgDkBLzG6CuG82W3vzIlNXElCWhCp9aRgg9Y902Yu2i4FLtb0J2KC
         7WEA==
X-Forwarded-Encrypted: i=1; AJvYcCW56D/ubkUt/5hKv2qkI6pyHsMSfBrUjqXl46/e7hSOunwwc//IakSqEmku3WtNbQTJ7phpTEUeVw==@kvack.org
X-Gm-Message-State: AOJu0YzIOvvfYM7VG7SupMyh5yVD0odEK27ZNakOkLtav+JxTr9QmDwO
	r7WgGBx3TPz0VTJtabg3B1PqG1M2AWy83rGZ6ekbr5/GCwzEVEY8e3k6KHpAHsroeSbXZrgBtZ6
	0qi+vWRxiG7hvw9IwVfrNQ/rICpsn5cNkNP1RpzYtOeoKcgfVeK81
X-Gm-Gg: ASbGncsxLotwe3fy5dYQ1Nw7Jiabx+CKoGVXJ18mToXN0CJnUPgr5eIeGH7Jjp4Clkr
	h6B6VM6J439leFbJer4tWUf+d0HTuQDIr5ox9D3sHOVvz9BXTLYuOhqAO9DXmCt2mKy46pZadI+
	wno4yXNa613wsCIdtGCZAqsn9UcoaAtLIfrYM13pJZtMncd8jc53N0SnhRt8hyE3nrrMkZ3qqix
	C1yzjKJEUzq3Jebuf1eUbA54dN61cAmlm4N4VBNhZ/lE/lUVBvI6Gu8ysBMnL9mzjAlqQs5bbYU
	6msbI+n3cpfhC2YOnqv/V/kGHR2jRoAkj69h/Ph4UBttUC3cXdXhmsD46iCO1dq6Gm/qiNeCO2G
	+9fTjFfgLnNM=
X-Received: by 2002:a05:6214:1cc7:b0:880:55e4:dde with SMTP id 6a1803df08f44-888195a2da7mr31326796d6.63.1764767987376;
        Wed, 03 Dec 2025 05:19:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEKpNns4VOQafFjiG5hX4ruS+Ccvq4UMLfIJlDnhWMvAf/b8wqmyNsYkTvCIREynB7oBmmreA==
X-Received: by 2002:a05:6214:1cc7:b0:880:55e4:dde with SMTP id 6a1803df08f44-888195a2da7mr31326296d6.63.1764767986938;
        Wed, 03 Dec 2025 05:19:46 -0800 (PST)
Received: from [192.168.2.110] ([76.65.77.217])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b91ba3sm128339296d6.53.2025.12.03.05.19.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 05:19:46 -0800 (PST)
Message-ID: <81d3d168-fc0a-4519-ad7f-c6ab71294792@redhat.com>
Date: Wed, 3 Dec 2025 08:19:35 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 04/10] drivers: i915 selftest: use pgtable_has_pmd_leaves()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1762464515.git.luizcap@redhat.com>
 <297c6fa3dfc50c28c05c0974c86a205984d752ed.1762464515.git.luizcap@redhat.com>
 <8c745e54-1cb1-44d4-abc3-00e6511cf67c@kernel.org>
 <21386400-9a67-4fcf-b686-1e7c9678d123@redhat.com>
 <2149802c-b7cd-430c-8af0-99d26b0b7330@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <2149802c-b7cd-430c-8af0-99d26b0b7330@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mMWnTjWPF-2i_IjQc6vK4JLmZdK-tUZvV_qxnZhrJIA_1764767987
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D129E8000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: udc5jec51ow4a7u8qe9jp733o6zmt4cd
X-HE-Tag: 1764767991-231080
X-HE-Meta: U2FsdGVkX19+QHWeA4iKdUGivcvh0q2jGMK5EKBMvif3ecv/6TFRhiS6r0Zzh4eC/v564zywObuUxq8KM9Hhokns+51K1hDwiR83rmvLeKO52h5O2hTCFowAFt0vOhdnobHHvDVu9qfz60/ko0e0pzfpIRxLt8TU60+2dT6MU/WyvgssLDm1+9A+evHo7OSlRJXEamKAPGFwMi86w4CcnZQ83PlTBBz9Ed9hD+cfZE/DggGX0fXFbT2zsT2Tco+o2Kl1CTLx1zrCJuMAxcYtTohbetqbgt9aZwY9x+G1+kNI907agZlfKZyx19QwiiqGVxjg8NXyk7HvJzVe5/y5B+0SpQtnKiss2RfSoph6Vw5lqcTN1GqHY+/7nWZjsm5lEVm7/U7FmIEztKYNMu8IbDe2qa3knwDyal3MrhihUiEynCTuDGgufPXj7Yaz8sdycYPotli8BTZ/cOjughLEpjQA7fr2GcsrPZ0MFNSp9AT5NzOKz+WyzgROpTcY1lVJFw5WVjyzp4TO3DBSr7FONGQBxGRzpV9sBP9oN8tU4kxxq/NAlhf4UzOWB8FtD6SZljZ2RRXl7TWMwVXrsLEp4yjrYzySnfO07+JAXcxsAGJl29LUw85E3hbu5J51KJGDfNxRtC/mEh3fOklboosB8/mPiT3Rqiza/a1hN9ruXW27hbnCqnjxuV1GwFjiR3j99ke7qt3eB9h0oBOE+K7w1uccJ2+63d7xlnbZN9KyghV6X8APcgcFJ7QNG4xuVXY3GJotSuh6rN8/JBXX3Iq94QQeNfBq0LIMhCiRK42BzDGw5Kafic6Usq3KZrWa4GAP57BlVtPP7XtFVln5Y8bP0wrFoy3exxiKJpNTKqtomHsUl8upJnhdYMGYttbDujpD0xjJ4oohjXlXCGANiTN+tBzNbvXn+rzGBBBliLl08IUaBBMPehxGui/HTe32L1Dvs0dIUHtyFYSbbL5+3DY
 kIoezY+F
 rLVmctiQcAOUDsCyeKZG01N6p2Hwd6VjELrrLmDwh1MGAlgofhmy5HsWJyubXZaTYEbjZk5GPQNEMtC09qwGzj+zFEg2OtahSd43UMZ38cuZYPjRk0rXKFKoX5lN8ReDggyPU83OOuuxnvAw+Dl1W0qlSmuq9Or3//eg90SmX8MGPuQYrNRZSz+ZdwiJX7KOJQy2XTmwRk9EKI3U/T2pDqajWLpuBKbtiCD3iw+/EYf1A8BtS/EUIqMtmhv/FfIp8RJS/gpZPG2V4Q1k8Z2FCexYVTiDVXYo8vlPGPC7S5rW4sXhVW23wmSlytN5cTfFdDNEdHTBfp/HWWHlQaf/yG2D2S4ANm6M9vV4aNyyJqbv9yYhUK2gFw7W3BhAENuT1vMPVSwzcbEjIL5UjuR2RDtBw2hjx91Fsk0y+DGdn0mjSzrfg7tfiKgcCTN+IAz6zSI2qcrpII5wKWG4Vm0IErjvlmPzIdUKsu4HeI60piTv4iDyMx3QeY/k1rq+hKYdQDGfQEXGeV/J6IWl/BoDBUGSstoGoV0gcbiQCUcGoBorOKq2XrpttyQIxMshXp8HzBIVZLXwsHRxKSYgTGqp1D02gm09qHsPOFCS5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-02 05:51, David Hildenbrand (Red Hat) wrote:
> On 11/17/25 19:55, Luiz Capitulino wrote:
>> On 2025-11-17 12:30, David Hildenbrand (Red Hat) wrote:
>>> On 06.11.25 22:28, Luiz Capitulino wrote:
>>>> igt_can_allocate_thp() uses has_transparente_hugepage() to check if
>>>> PMD-sized pages are supported, use pgtable_has_pmd_leaves() instead.
>>>>
>>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>>> ---
>>>>    drivers/gpu/drm/i915/gem/selftests/huge_pages.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
>>>> index bd08605a1611..c76aafa36d2b 100644
>>>> --- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
>>>> +++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
>>>> @@ -1316,7 +1316,7 @@ typedef struct drm_i915_gem_object *
>>>>    static inline bool igt_can_allocate_thp(struct drm_i915_private *i915)
>>>>    {
>>>> -    return i915->mm.gemfs && has_transparent_hugepage();
>>>> +    return i915->mm.gemfs && pgtable_has_pmd_leaves();
>>>
>>> On second thought, is it problematic that we might be losing the CONFIG_TRANSPARENT_HUGEPAGE check? Should we check for that separately?
>>
>> That's a good point.
>>
>> In this RFC, pgtable_has_pmd_leaves() should be functionally equivalent
>> to has_transparent_hugepage() so I think we're good. That beind said, I
>> also think that we should disentangle pgtable_has_pmd_leaves() from THP
>> now or in the future. When we do this the breakage you're spotting will
>> happen.
>>
>> What about adding thp_has_pmd_support() which does:
>>
>>     return IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && pgtable_has_pmd_leaves();
>>
>> Then I can convert all the cases you spotted to thp_has_pmd_support().
> 
> I hope we can avoid such a wrapper for the time being. Maybe we can just keep pgtable_has_pmd_leaves() glued to CONFIG_TRANSPARENT_HUGEPAGE for now, and leave untangling that for the next cleanup?

OK, I can do that in the v1 posting.


