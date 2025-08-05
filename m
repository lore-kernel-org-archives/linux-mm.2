Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C60C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 10:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEC4A6B0099; Tue,  5 Aug 2025 06:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A77A86B009A; Tue,  5 Aug 2025 06:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93E5B6B009B; Tue,  5 Aug 2025 06:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 834716B0099
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:36:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E8D0557A91
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:36:41 +0000 (UTC)
X-FDA: 83742350202.22.069A59C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 54E7F100007
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:36:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="I0t1/dO8";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754390199; a=rsa-sha256;
	cv=none;
	b=hkI12M90XFnNACSAhnsAufZVHrv5Nv/HU32Vzqg4eHDlvdOP66kuJ4gy5CKOu9e6ViO79R
	b1VOdBjU9bDnWX0VTYYma7Lu19tUsjdGTd9T6Rf1Sw9+cIiCd8mldn8RC248LcKGtpxG1C
	6dxuU9y+1iKenRHp9/m1kodpNnki2ts=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="I0t1/dO8";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754390199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wl4ZijE/HHMB43Fi7BAYKpOKxsawoOhIpbaL37luJFI=;
	b=d2Iqs35L6TzY7kabafXA7jeus0SNDrCisDENDHFjmi7lK2oRxwUnOyNTQCQZ8T1bB9PpF9
	zZqAUZb3+bBLaqLQjQtmDMzZCAkVv9Wutl9wYofe4urLmwE0lFvphUe4UL0Ce90bXf7J4X
	77FPDuLIW365AbH8YZ2Ka0C/2Kcw5UE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754390198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Wl4ZijE/HHMB43Fi7BAYKpOKxsawoOhIpbaL37luJFI=;
	b=I0t1/dO87SG4PjvI9hwGNIgiCE/TxDlTs7CTyw57DNguk04iXg5ahEsJxnr0pLnln7FkTR
	TXigp6qSfmg+Wqil6dabBu07ymcNasQYkn6Jwt/TkxzyfmH7yA+IabEBSuF0Nimi13EE4s
	dUdKo86+EJC+hf7DuoyIkT2LNfvi07M=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-XZefxn-BMtuJa4tkYMwKow-1; Tue, 05 Aug 2025 06:36:33 -0400
X-MC-Unique: XZefxn-BMtuJa4tkYMwKow-1
X-Mimecast-MFC-AGG-ID: XZefxn-BMtuJa4tkYMwKow_1754390193
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b604541741so2575413f8f.3
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 03:36:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754390193; x=1754994993;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Wl4ZijE/HHMB43Fi7BAYKpOKxsawoOhIpbaL37luJFI=;
        b=Ss6v1u8Tn2V+UxjraHdv6u0KhjGWrZBpyhGRIkMInPhxdiAIgWUYmV8Wn2ilmJ5ry3
         yGkWig6JjnC3duX43uifwsuiaCBfrxKH3gOX+k108UPzfOv80aKcX+L3mURTQP+4ngEB
         1ffZ72wC1Vynd948NYmu2QORAg8mdOufDxmfV+mwMGWc/JEq+XVzDlddIxLINV5HLrl6
         fypU9Ci0S9PS9TyhhPofLIhnjxpm9OBFUgnssjyVVOJxutdRRw1+CDAQfhswHtuuI6pl
         KyN83MZ6bJpx7h3aePD85Xzzob+wqPnEMnL8huOx4aTLVcAsJYHz5Oo07vZVwfpNbtw8
         jOMg==
X-Forwarded-Encrypted: i=1; AJvYcCUQUrh3Uzx2YGdrDq8Jflqbg+bjDOchZOou8gFeQTyutVI0+BaLYayv8XDR/Youih7kJPIxAQ5Dow==@kvack.org
X-Gm-Message-State: AOJu0YzFqe9o4g6CZBH4+lFXx4pPUdxyNBZI6mpBAyHUM5ZQyi3waWQE
	rDBDY2em7wtKVzxrjHCFRbyunvNiDsYnUdg4lqVjppVvDWoqSO1a8iNuBwckPCxvkI6GC1Wigcl
	VxGN5q08j5n3yOYpPNvuqiVvzI924WaoVxELPZ3Wrh78uW95k8Br/
X-Gm-Gg: ASbGncsUMSWIH556zGz+r5I5V4WSlEcTrsWcA4RkFM/f1dZssSvaQr3JMgis6x9iuT6
	ZPSrlGjGHW2luMnORqqm/RYVHJcuv4zFc0nh46zjWPW6CztKbYeiDGyxnPnVEn8QhU1mC4jSpU9
	5R5CYsLsSpENLHCcJVVjxPOvSBt23SULWwaGzRvjLDiJuD222sThPZNcJ5+XIhY9oGN2xyX6VV3
	J6oZESnhZCtYumh8LTU6Nz4rYMd8C8Ht8wVQPmJl9F+H+1ivjtOJ47wnxOgGRo5eKjdIocXKq/1
	mmKljasfpvXyUi7VSSxWdzdXLuz/dqsQx1u44F/fO/UM9i5BHSlMJBF5S9ChiQXqyXLpki/v8M4
	/3uTI20w0jSdhnNRGL8fGWga6I3MSWOt2XP5jSmZlqqc6BHbfRfUnXQaaRe6ug3EPdm8=
X-Received: by 2002:a05:6000:4305:b0:3b7:89a2:bb8c with SMTP id ffacd0b85a97d-3b8d9474e63mr8616408f8f.16.1754390192626;
        Tue, 05 Aug 2025 03:36:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGAOnGMnGXyh1ND7MnUFCBNlWbq0W6kMApMwVAYJuatGTqk1QunVq1YA2SrRT1HUU1vGbKqVw==
X-Received: by 2002:a05:6000:4305:b0:3b7:89a2:bb8c with SMTP id ffacd0b85a97d-3b8d9474e63mr8616359f8f.16.1754390192127;
        Tue, 05 Aug 2025 03:36:32 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ad803sm18564762f8f.6.2025.08.05.03.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 03:36:31 -0700 (PDT)
Message-ID: <9bcb1dee-314e-4366-9bad-88a47d516c79@redhat.com>
Date: Tue, 5 Aug 2025 12:36:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] selftests: prctl: introduce tests for disabling
 THPs except for madvise
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
 <20250804154317.1648084-7-usamaarif642@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250804154317.1648084-7-usamaarif642@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _cFcpJ098GUxi4B_sCQIpVFkZEbg7zFbktmhf1O9keU_1754390193
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 54E7F100007
X-Stat-Signature: ba94pugpsg7buew483fdrj63mjr1z6t5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754390199-749136
X-HE-Meta: U2FsdGVkX18qwO33tkXJQhRo3hWL0q3JLgpp1url0dNrF2MliVDZGkWcEuaeXjMfkSvGWNNgaEebsOPn0oMg15m7Oc3LneGf17h5+uiP5nrRGpvmL6sufqXh7PAlC8AA9qrLSSPkYm40Im7cmph2Yzb1xqlYsaJzzgsd3YFqLEhPE5QCfQj9aAr2JUd6mbw80wemsfBW3Q2cX6ALvnN1Cob3NoRus0Gju1C67WlLrZBcXQ5ycs52ioG20f9nQyVDwjV7Y2e3jzg50Di5GWkYZVtj0BSamKSkh7DI3O9lrBcBPuCRXlnBSriP/7RCRUOercmXbReL1cqM9r3UjuE5Ec/MbB5jM73W8tZ7ADB/+3V5W/WJzM6H3xaW4m72c60ndXqodlz16dgR8ldGlrvO0VG0pYK0L9mv/yO7AVy8qBjHzExyB3p460GuF+1hAncD5VUPD3mhE8HSwjkFQWMz5/sGp5UowSJ35gw8CwFFERI7KbFQT4RhHxoVu38XUuyCtJzcBTX9M+08a5Zr/D0IecwCOaVkq2Xf+VfrxdxU8j2DlzXYt/BAYfMyPazu/39vBQJrb3PYPj75fGHjuxyuWP9QUrbxVAFW3+E0XjFcAKM3U5Tpe0iahwAYC0+hjiP+Sl0E50/87Rr5FtaKenSsygN/NjYvC/E/ipaNOK+OKe2J3t5riTalPpc0oEzAao+76N4mRn0ytrdiWIhbRXmllb57YczSp3og9DfTsuDuu6mpyxdBbYJrz3HnMmgOAQBN0dI3AOXOH8uO9CS2lFV/THBGut1LvSHbnGd754f1AtMM4eZipsUKJqkKgofoTHZ4l4HBG46HjLHiegfpeQiwDJs5QCkxlmvsOKRh+9SkbzZpQDZCM1Ge4ysX3Jgz4jXORMgUu2ADQf1O+YFIk1W3peaYShsGsHV8hoeRr0my0NJXem7OdeCFEZSCc+JFNeYYyNI2Z5X48weKHXVOhWx
 MuqBTYvR
 vT8ieBAQFW8BBagcvPa1OjPK1ANpb7yooqbbPORBhAp1r4AV2siLUHOrwaEl5aaZ581NnKmUY+C3Lpwd5z1Vb23fuxpmDXBMeb2b5MOiOGky7HvJsEN0X6agfE+lPtqYseIhofDCfLwdDrVdrMKpuu3fPQeWdP0Kmg6znUwQFywQOTT3cKX+w3Z09/2sNtRAs8K95Il1F3OTL0gtZJ6j+I0VG/UvniUSIHIVENShHvotK58TW3AzE6JkCwX6UEhQwQAmmH8B8k6E4GoZ26q1xZvolWU63VJ3fK9j0Ka/PpkYzvaOL4vz0eqPgrWowOJ7yjTG2X4ilDOxk0srYYgTKFKsCrpdTpSwLomPTXm9Du6QDH9Pvb/OEiaRy9I8x0VqJbO/jAjwEqR5owV6clfPbIJYsMgHN6jXnMCaJ3Q0nRU098UGkHh9H+X6GBtkLxhhfHMgblxLAq6oAvhkpluMt8DZl7EiYPzb6gIdTVO6sgEd7+SI+xZ+9mEnOP4kUsZZqxqLCJk1woNzjzextxzv04ieHOUulRaN2RjbP6jwjFzBCsH6lmj1RKiW8QA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.08.25 17:40, Usama Arif wrote:
> The test will set the global system THP setting to never, madvise
> or always depending on the fixture variant and the 2M setting to
> inherit before it starts (and reset to original at teardown)
> 
> This tests if the process can:
> - successfully set and get the policy to disable THPs expect for madvise.
> - get hugepages only on MADV_HUGE and MADV_COLLAPSE if the global policy
>    is madvise/always and only with MADV_COLLAPSE if the global policy is
>    never.
> - successfully reset the policy of the process.
> - after reset, only get hugepages with:
>    - MADV_COLLAPSE when policy is set to never.
>    - MADV_HUGE and MADV_COLLAPSE when policy is set to madvise.
>    - always when policy is set to "always".
> - repeat the above tests in a forked process to make sure  the policy is
>    carried across forks.
> 
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> ---

[...]

> +FIXTURE_VARIANT(prctl_thp_disable_except_madvise)
> +{
> +	enum thp_enabled thp_policy;
> +};
> +
> +FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, never)
> +{
> +	.thp_policy = THP_NEVER,
> +};
> +
> +FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, madvise)
> +{
> +	.thp_policy = THP_MADVISE,
> +};
> +
> +FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, always)
> +{
> +	.thp_policy = THP_ALWAYS,
> +};
> +
> +FIXTURE_SETUP(prctl_thp_disable_except_madvise)
> +{
> +	if (!thp_available())
> +		SKIP(return, "Transparent Hugepages not available\n");
> +
> +	self->pmdsize = read_pmd_pagesize();
> +	if (!self->pmdsize)
> +		SKIP(return, "Unable to read PMD size\n");

Should we test here if the kernel knows PR_THP_DISABLE_EXCEPT_ADVISED, 
and if not, skip?

Might be as simple as trying issuing two prctl, and making sure the 
first disabling attempt doesn't fail. If so, SKIP.

Nothing else jumped at me. Can you include a test run result in the 
patch description?

-- 
Cheers,

David / dhildenb


