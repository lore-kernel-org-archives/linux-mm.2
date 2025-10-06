Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 749BACCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 06:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCFD68E0007; Mon,  6 Oct 2025 02:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80558E0002; Mon,  6 Oct 2025 02:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B965C8E0007; Mon,  6 Oct 2025 02:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A87EE8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 02:34:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45C52B9BAB
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:34:44 +0000 (UTC)
X-FDA: 83966726088.17.ED66AC0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1897640004
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:34:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UazIaBcR;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759732482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nksCC2zzYk2DM+W1S5KM4R8l8BvMYBZj+rsznw3niOo=;
	b=5wH7YsQlp1qDI8/2nTZq2Ja/F6zKWj/x4W5SbgEkqJRzhYwNpQqHnqQl1l6WdrOXjfizo1
	9M01XsI3UA1nxAu2/aKBgASZuu9LlbVGC1oQ1aLIHXoSiExm8lILZaTSXvBywL4+Cb2saH
	cA5U5ZM2hWNZIepkOfsavG0WF429YGs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UazIaBcR;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759732482; a=rsa-sha256;
	cv=none;
	b=DFEZAi8nkRGiTsCpWiUyde1NGZg4l5Ti9RraZe29EWPgYUeNo3QB5gJCY04yban72r5VNW
	JM1s3SsLaRIq/Bhloa4hlD/eN5UaQu3aiZT9PynBVwvFjjuvOpfx36xa2nVzH0j2FUX7B3
	COQQ6l5vYavN5WtVEOunprSQINZIR9o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759732481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nksCC2zzYk2DM+W1S5KM4R8l8BvMYBZj+rsznw3niOo=;
	b=UazIaBcRF4YMfNoJ69sgTphkUo9ivcYAg+dZ9NcHVdGEHAA7VUA2zw2FIkhXQkLgb6/upa
	2Gs0MDynSn3tPHXQl+17xYTgxRj3VRj/PblClY8QMdIzpr/DX0zAoVK3xdRRQEw8rDLl79
	Q/ANhKeV6yak+hq0G+HISS6Vbmm2lKk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-SmuY-K9DM-OQ0GAWKmpI1w-1; Mon, 06 Oct 2025 02:34:40 -0400
X-MC-Unique: SmuY-K9DM-OQ0GAWKmpI1w-1
X-Mimecast-MFC-AGG-ID: SmuY-K9DM-OQ0GAWKmpI1w_1759732479
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e7a2c3773so1509675e9.0
        for <linux-mm@kvack.org>; Sun, 05 Oct 2025 23:34:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759732479; x=1760337279;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nksCC2zzYk2DM+W1S5KM4R8l8BvMYBZj+rsznw3niOo=;
        b=TpT74Nmb7rC1tAGvUAZUS7cVlyzLFxrOmuArPpgUZGllC21moeVjWGGaU2XT32BO4W
         uZt8ik+h+R+IhDdcHB5lushAGizFo+BumkY9pKevYPRx/hdNRvJ28csqHBds3skGNBPB
         IABssQ33NfKuh4TL/3OKyek9bWaPT1EgA8gTI73S/mtNNqgOWdzdBQnUU3uvWBMzkOEI
         SIDVBNywlZ+xqTs5rDlxX3XKBBgRr6pEboruu7PTHz1+gKn+/KfMxNmDF2z0SKltGlDv
         z00DOVyr88/fUU6l2ditA/UBuzOEvjE1rj7LJRKkLi8/POn6/zySKPf1G94EwqnSzgFB
         zrEA==
X-Forwarded-Encrypted: i=1; AJvYcCVMBB23uYQfIUu84AxOGrR0zKvZlHKJXBsZLJUJa8M4+VdZEQNfLd9dnwTig9UnwLLSON9mJ2EDrA==@kvack.org
X-Gm-Message-State: AOJu0YylBqVQ3wj675qKxhPoffzzdMMuUJPasqxuafWHpinmL5Fiqt4Y
	XQNtlfSzeN1Jv+x2dmxIUVqWpN2OmCxGp6rVgOrF2gJGs3xVf6Ml+lt119TQ8GHDntzi/1EKDDs
	NY+99CjTy4oz53wq04q2ROURKOD69T9GTUb23D85WCDgLuUEAhmqj
X-Gm-Gg: ASbGnctPf3YNgMwNgbVMVJBLjK99bAqMP3FacHI/WhGA95Tw6uP1ZrcGhHk6rvlO8kD
	PoX9B9hI1OhET+v6kCmxMt3fHKM38pjYLOyXIQrkTPgzp6NsbouTBcxSxMWm/JUq8VhBNAygSMR
	qHizbGFJHfCP8K7ngiDtU65QIUlMtZIA4oNYiOFqBYPpMzmDv7IN7Q7N1wmJozog7OzBXTIIQPY
	eMdu7inZCe0aCxsNZt/4pQnQv8xcTuA6+DsPvhtuzETfXc24RkSFEBmVTsm/x5ZaAfTRs/RG2o2
	x2N28GkcoZa57MAoU935FFki62Ouz7FyuMGBV+Q9VYSk2pTlf76TV9nQexhh/oko/wTdB0NvW0B
	9fTv9kwOV
X-Received: by 2002:a05:600c:c176:b0:46e:6339:79c5 with SMTP id 5b1f17b1804b1-46e70c5a8f1mr77732275e9.5.1759732478664;
        Sun, 05 Oct 2025 23:34:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyw9ASmRzvvDBMljvs6RWnytS9ZK0D//kmm9mdCgi148a4ifRTj6KbJkrbUXq3XwyRgPJurQ==
X-Received: by 2002:a05:600c:c176:b0:46e:6339:79c5 with SMTP id 5b1f17b1804b1-46e70c5a8f1mr77732115e9.5.1759732478276;
        Sun, 05 Oct 2025 23:34:38 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e7234e5fdsm144553375e9.6.2025.10.05.23.34.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Oct 2025 23:34:37 -0700 (PDT)
Message-ID: <fd1dc222-3d33-4d94-a56e-423255ed0588@redhat.com>
Date: Mon, 6 Oct 2025 08:34:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/dirty: Replace READ_ONCE() with pudp_get()
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20251006055214.1845342-1-anshuman.khandual@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251006055214.1845342-1-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Uz-R1pY3o7NrCpNgB3_mB2UtEuPey-gkWKGfLrhUuvg_1759732479
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1897640004
X-Stat-Signature: mpgzfxx6qbuigzfzs7nk6gxboceq9kf8
X-HE-Tag: 1759732481-20094
X-HE-Meta: U2FsdGVkX1+Nlv3Mr21pzkeh/VHdgt1nOkesYEhPluqVrw4J7Hculyrev9rAneD00IaOT9vqDzc5tAIcuP8fEhr1+MI0vzGeQYNDs1qWd2ZBmMaz2Hnzmr8F1AKapoKqsFPEDzJ5ugquEqX+3NPi3F1q7rDu1i0xmgcyZFIlwfiqkFvQPN/xk3XtDcG91TVuxPnJauz1NtFJCAK43ZVfKxqkSLssXckm/x+gb1/oVQq8sMwafRucRosl4ekQvNLjEv1DQgzXB6Aa556mSbGNxPiqguA4UgadMmxsZfk6iAbm1Gd0X0VpvMKOoBdHZ/eSBXQXn0QsgIT3h7ufy1k+GQNHZybgp9nItDAfmHQTZ3k8YnA6gx/ifzBgZIiDTovsavlrv3tvcxg57dx4bsrIx4XXuXVfE8vE0lg3orxXrggPcO8a288EW0slAYqFRIEitZejHoQZtw4yPsaF3YIGUh5Lw8k0YorhYAQ6b6VQusLtYsS+Z6ZBswtjcD3jQbyIdBg/4BRe2xCuzmdF9waIP0GOBPY3fbyNNFHhNpVCWmT/Nvr5SwzZqedyeV6hdBwJQTlgEzMajsCBODXoHVc5OQeUulnVt5tVkMytebR3Fl7hqGGIFqR5XWW9uHMvaWRKqTxu4MFWRxhdCZNyKZSMvdnJ8o8eGCJ9ExOTNDM2g6DYqEqUbnWd9UsJ/QY1F6dWWH6aq7aoTJEa4Uvelo7EcfVhgeuKHxp0L7+4ABoQcpUN8957a6IUHlSUtw3Guj7No3pIEBlQ6vFGaT4cmIIBTajU/Q7+N7DpkHvJgdUsCAYF8VfJ78TTTRM+ZtgS3dYNmeWLbLHsvMsj0yOZE3nZn+5h0g+FjBX4MJQTCMggh+wU+pVmLK6O9mmvdW0MbX/c3UI2vAd0ir7xHgTiE4GnqzOvMuNPmQGICkYsINRCQeW+ZJC1uSXfw5t2KhND/t5Sw+NNizG0aHv6KPUq+5y
 wOzkKulv
 GQDyW+qfGI7MIF8fj/LwMpfgyVSZBFwX9gxjANnWDQM2Amf5Od9EeE6ZcvsC71A9LLGqjQW94axqbhd+5pYKNoptweivUfv3LZqw1aGT1WJ3ybVvbOWq1azmKnl4yG5rximyXhaliQ07JDM1v41v2QhDIfAcglPRtdxmMyJg2/Tt89/g/VyLpi2J2BMZsH0SNh2Tl/5nyrGEL37t8SBgh2/QgfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.10.25 07:52, Anshuman Khandual wrote:
> Replace READ_ONCE() with a standard page table accessor i.e pudp_get() that
> anyways defaults into READ_ONCE() in cases where platform does not override
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


