Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5805ECAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:42:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B5E8E0018; Mon, 15 Sep 2025 06:42:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9084B8E0001; Mon, 15 Sep 2025 06:42:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819008E0018; Mon, 15 Sep 2025 06:42:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70A758E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:42:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29509BA14C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:42:02 +0000 (UTC)
X-FDA: 83891144484.01.9B4B765
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id C7A601C0009
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:41:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iAa2s6zY;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757932919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMP08Ma9+h7R8KIM5LLJJKIUUArbjFACsxNZwIJ3PwY=;
	b=pLRhZwl7dGEypM6DOKzPISwaTTDXUzQJbxDEVHKMGmtLp0wDSyoNqmUEfQ3Szw23bREKyq
	9LGaN631aXLFyw7JOo0+SLNFvzvYNH7usZcV8jqzmIrck4YuCHVcKJXLBhVXgk4XXgB3Vf
	Q10yaxAsKYtH18tlS159l+03B4iaXMk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iAa2s6zY;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757932919; a=rsa-sha256;
	cv=none;
	b=6KXXU8m5lFi9rMqRLkMq7pTKFKDDCotuo4rEoiHRYb0mvo48MC2WXsNY9DIRBXJDF8ZsfI
	OcHTzZxzmLgnQ8BFKU+f9g1GbkXYKYWS3wU5Vq9YUH85vZkZV15tu3BFc9TLqiIiLf7T1O
	p2AU88uKwk/qjsEnrXCapm0faKzLx+M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757932919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kMP08Ma9+h7R8KIM5LLJJKIUUArbjFACsxNZwIJ3PwY=;
	b=iAa2s6zYfkvAFHaBPvlr299UlJqSoqdrZk+CCa8pp2vJVbqMndIWMKoy8OZg6CxAZN2dBv
	bXYBSBY6ywOTmCuT00sIW9lEV39EKakEDGG2drP9KwYKkkuUv1b0ajc4yUKYsmUPxjO8qO
	1uepjedNbj90LMtrB6L2fQ/+CSkgUcg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-a-A3tvrlM5mfwXeb9K0nNg-1; Mon, 15 Sep 2025 06:41:55 -0400
X-MC-Unique: a-A3tvrlM5mfwXeb9K0nNg-1
X-Mimecast-MFC-AGG-ID: a-A3tvrlM5mfwXeb9K0nNg_1757932914
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45f2a1660fcso11454565e9.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:41:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757932914; x=1758537714;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kMP08Ma9+h7R8KIM5LLJJKIUUArbjFACsxNZwIJ3PwY=;
        b=qMJCkUAk3+3UrSVxxKoRiuesn0UCrzsq4c87+VMLuyfB926koaHbO8lI9NU3VhlH+L
         lHqFxTUh1cadaWAPDayad71qcRneu8SskFWkBG4rbLJuaiJ7zZN1nSbEz2wgOlRu5WaJ
         grpN7Y7mOxPIcmZPrm8EL+OGGmZrEw+fUoV0HCO2eBH9oT5scYKS0rEVzJwPK2QT3l0B
         OKQ5XXADSpVr/R+cPMsdGWNnTT82g6fqnV3W1DQmZAvr8sN2RygiFtGI1Kz0Lg5N6TVF
         qvjvEBeTzu5zbSWpnH8vZNRWJfAn/CTsidnp4f0ZV5XedC5YjtUdHsQDxT3p/Ki8dzeN
         jU+A==
X-Forwarded-Encrypted: i=1; AJvYcCWX/RfnKbroiyrLHknWTselVk57zueSImmVGQo4LqOHikfvvurnBgQRgdf04/1t2iuS6fzGGAnnlw==@kvack.org
X-Gm-Message-State: AOJu0YwCE4kL9jqYjcy++pYhr8vMabDKYBYo2XRTw3HCOEyWu+YRnMa0
	bx+azvi9oVgIOj8G9kBWTY/J7YOKXcuM6VAh5S6pguORLlDEAlYEn09AaTMd/6wfrNq5/y+BJFe
	OXk0LvZ+Hxg39Y9m5gOQAOW9SIuVs9dK3a0CChYrd1rUnZXBpXPm0
X-Gm-Gg: ASbGncv9YBFSJmdBBRtniPmsS7Ne0CC6EyJZPxNW/jLe0f1iAWfPffjgcGUS7pAnz48
	xDVf1p1t891XdkzFwYRocEZqmXJefpkRDOUBDSU7CgamW3obicryEgvDl2BTW+7PDAombyRr+DU
	KpjyM8NsVHOImIExLDIZ4JysOwEAwCzl222T7BQZ+eXU/0HkvA3bxib+k6iMguCd4hhc+DTB4vp
	pjD+nkBTrNeOdM4rNM4JNXyVFCBWlegdRCozhIgCdPl7pSfpi0MFyAqZQr0jMImdJLC+QlzWpP8
	PYYXtTukPhgCH7zNcsJ6sAmu2atSmVusu3b0Xm0fT1H4P6WufQ2Pw6LUs6OsA8o8KnoDZPsLwSH
	Nagsub6dOJfqpXbFw0Ix+yHWRQpdpZlg1/NP1SQ6qNvbsek3XBYgcINXDPpQIy7ws/fU=
X-Received: by 2002:a05:600c:1c94:b0:45f:2ed1:d1c5 with SMTP id 5b1f17b1804b1-45f3116999cmr1375435e9.36.1757932914502;
        Mon, 15 Sep 2025 03:41:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEb1ZOjmd9aAQIqPGcbiV6Q9jIvdjqgpXc/t1qCDV7mn+Icr6fcxROrpICuDo/lmhXbwHIniw==
X-Received: by 2002:a05:600c:1c94:b0:45f:2ed1:d1c5 with SMTP id 5b1f17b1804b1-45f3116999cmr1375125e9.36.1757932914049;
        Mon, 15 Sep 2025 03:41:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3eb35e4fbafsm2369319f8f.41.2025.09.15.03.41.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 03:41:53 -0700 (PDT)
Message-ID: <88258e24-60d2-4068-8d26-bec51c94a650@redhat.com>
Date: Mon, 15 Sep 2025 12:41:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: Barry Song <21cnbao@gmail.com>, Nicolas Geoffray <ngeoffray@google.com>,
 Lokesh Gidra <lokeshgidra@google.com>, Harry Yoo <harry.yoo@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Linux-MM <linux-mm@kvack.org>, Kalesh Singh <kaleshsingh@google.com>,
 SeongJae Park <sj@kernel.org>, Barry Song <v-songbaohua@oppo.com>,
 Peter Xu <peterx@redhat.com>
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <aMdVcH7KCXBvLtFP@casper.infradead.org>
 <CAGsJ_4xDRB_F-T42WnhqpmwLyiZRwLGqx9vDf_d5TFALsCRX4A@mail.gmail.com>
 <aMd-2argDQCHww_Q@casper.infradead.org>
 <b6d5c607-a9d9-4c1b-b4ac-41fcaa2e696d@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <b6d5c607-a9d9-4c1b-b4ac-41fcaa2e696d@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: e3W_I4O7Qc6jB1oLH2ZI-nN_XMIAh8z5TPlj_47BUFo_1757932914
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C7A601C0009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: pzau8gn5onuakaibfb9qhb1gdjrw1pqo
X-HE-Tag: 1757932919-806886
X-HE-Meta: U2FsdGVkX19VpMXKzuk2nyddK/hKaH/eRUojJe0WBx69a7FxkDtED49Xa94T0pu5S9NueH2O13enc2x3tbclZfTspezwm0BugMeQIDd+xU02DjS3jaUAmXP4stR0EeLl9kbSvlOx8u26apFby1ip72/OUNShniyw2OCrMJLbtCaCn/8yRpgFr7iXryMfi7fxvRjNzGX2LrwcU4nNq/U4Z0zFbRpFMdsWuyihXhBDDrY5q+6eRwn2oxn1cbB8+VszJ//Tt5q1KpQBYMfV2/IyxTNsYIt5IRTSMdiD7l7ieqKeNLvGkXIv1MhNTsK8GeHGR5//H9ECdyNgdIxKgin82nKQ4CNqzqFc4C3V+rHTrcvofxNuzpCPaMqnDYjszBnNxEGEy2bxHvoqZic36YV0sLiISPleXvyaElNUcvD5rjLM8B4kx1WthbDrJaz+aQGzau/t3KaHw51IgdrQTR85fL9HxLI1xGaAdtjRuJBYS8X10qh+VeFO/i1D3GDlE9vMo1tUeQB1fSFiBmqoUeKA/i3BnXtCAJ8kK7mFv8+/Mh4Rq65jbP6kUkTiYQmGFEhakvvYpckBp9lZwNA9+NOdBJCx8Yx6Wm1s5DGKGcq5pmdFuJHrYEr0ZaogNmYWUbZ4EmJG3FQv5s3nze4syaRKVsyN1VVXn5nkAILuHHc5iByZjm4qU6lmsmsOcU9zGO8Gh8caWcphTrORX5iLcZEYtRdhmNSo9wekWzRD5F8BNeEqasUkXRkGS5VnFliZmfEm5myEIDsJFmBCakkAdvWN+d0GeAz/4I1fgUf1tM5NQSbWih/9gkjO3Tg2wl8JY2XPp88ku4EaqXo4I60KOnG1RhsLuiljZedqMzzcAxAaIntXooDb7K6L3EL8A3sZaB8OtZR8nn5xGSTgKCETP5DQWhqiZdxGj/puhu4lDQA3E4iwJjr/FZmBNeMLNZ5GwDXl2EJLlMpogVlTEqURbWy
 p3n6qzeT
 rzg1wLoOUaNMaRinhJc6V4qoCrOICCeDcLPM+7kioupIWNrnstPY2BbGO9FufiC0xWdROd12HxK9sBpn280Id48lmUn7oNLNms/13lxH5V7pnIKLeeN/h8jdhzfUASmQR7U2ka9lNU/7CJkAxNuVhVMzby00JDkxfRV4WofMIbb0+vNw24pB3ptwXldzNPYlfwUUfEGy/Sjg7t2VyrEqidNHJY1WQbxoIs880YAG0hi9IUxJT8ZIC8sR7KXQe9Sb0gq5U+6qlvGJmqqKHqkP4fzZ4wWMc3xkkEp2X9S/GM0WWMj+axLS+FeIcvxbonou5LAXaaWJZEhHycqiHb8yZdnL+x5v7sM9Cxeqbg68qs7IOffIAWx1iLuQJ62ITbLYwZ1r0rMMmQvInXOOwxyBH8GZ3VXbqaO1zbDi7gxkV3mfAzqdIpI4VziZiTV4P6fvVj/CLzBs4YD5MspY3wpleZ/n52dte3yZFlqPR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> Another point in favour of COW_NOW or EAGER_COW is that we can choose to
>> allocate folios of the appropriate size at that time.  Unless something's
>> changed, I think we always COW individual pages rather than multiple
>> pages at once.
>>
> 
> I don't think there's any practical way to do it any differently because
> you don't know what's mapped/not at the point of fault.
> 
> How expensive would it be to have xarray for anon, I wonder... :)

We had a proposal least year I think where someone wanted to bring some 
weird FreeBSD semantics into Linux MM and proposed a secondary tracking 
structure for anon.

Tracking twice is obviously more expensive than tracking once, so I am 
quite convinced that no, we never want that.

-- 
Cheers

David / dhildenb


