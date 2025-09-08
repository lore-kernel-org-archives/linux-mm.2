Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03D2CCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625D08E000C; Mon,  8 Sep 2025 08:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D65D8E0003; Mon,  8 Sep 2025 08:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C51E8E000C; Mon,  8 Sep 2025 08:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9538E0003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:18:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C75D8B3C13
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:18:26 +0000 (UTC)
X-FDA: 83865985812.16.9CA1693
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9877140003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:18:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="gcGAcF/Y";
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757333904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PuXzt75qqZ88CE8il4yCnMJ+l8oPsUDRiV/gr28llhU=;
	b=3cgTH/+Z7Vf9eKVvUquc0arZDo7CvqAOk3gaNnwrN3RQQsSKX2Sl3wyAuWE1+ktVZFUQE5
	gI2Wkyo8phhMnUrwFmGrOLufw1X2KKBW5tT86sjFmcDc4hdEF8UOsfnbKcc08/HS3yTAg9
	6U7Coc6icLMqlnmdz7jzzKs35euG69M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757333904; a=rsa-sha256;
	cv=none;
	b=43dJ05ke8FIYXOv3tM3wNMsr7B3nXg+btrYxL8UZtJvUymWgSEDMnQ8eDuDAPp0ZmBJhdX
	e3dz3dwa6vtpKWBNKJsuwnpXzl4FF+heZ13ewnnNXGDjSqfo54a2k4D9guXTq0WhBm1ZNo
	PccGq6oQ0G4kglyvaDM39qjPJH4nkYY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="gcGAcF/Y";
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757333903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PuXzt75qqZ88CE8il4yCnMJ+l8oPsUDRiV/gr28llhU=;
	b=gcGAcF/Y6qHI68e1mb67bi820AsT3kWYHh6LoIPiqr8kUslp8HMqPwVvyCK6Yy8nVD2ury
	QUYNG42AmTvLXJiIhciPH+5mPi0HcJ48yvMKs805soD5zh1SAhPVC2EoF7vdB8pZtxWzyr
	5LMNw0HxsSZxAc4DIx1ghRF+DliUwYc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-OTArQoTVPriB0Gj2f3oj_Q-1; Mon, 08 Sep 2025 08:18:20 -0400
X-MC-Unique: OTArQoTVPriB0Gj2f3oj_Q-1
X-Mimecast-MFC-AGG-ID: OTArQoTVPriB0Gj2f3oj_Q_1757333899
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e26569a11aso2108210f8f.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 05:18:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757333899; x=1757938699;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PuXzt75qqZ88CE8il4yCnMJ+l8oPsUDRiV/gr28llhU=;
        b=G51AbM2eLj7v2hy9Rh1I2vqC3ZtNSt+tq0diU83izjZMu2KM24GVZY8gpmp2zOK5sK
         OFTeM3KLrMjbhM7Cix+r2MeeYkE7gD1S5VnY3k/DX8WpctJFCg4Wuxc0Z58fzVBpvmbN
         8UUF+BO1qfoF6vhKgo7azYAu6T2JhNMWgbtc30Z43tFhZFAIkXS6twoaeWwQLrUKmcwn
         Zp4p8o7RH7FhvGIolMM5zfITRi8Qt7+TEnNjx22F3xGXEetWe2bkhkOox1X9ZUqSu4rw
         ZMb2cj9r1X30+8Plvj4wFzYAaJpAMQ/knR1kGXKGm+ldl0dJ+Epse4HNZSsHY9bO2o4h
         TY0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWZJDGoNRTpiRRThHJD1Tvb1DSwSGXInMIYUpczk/9KLcnP62P1Hl4Dp5rbYcKAw8Wj6aR2izBEsA==@kvack.org
X-Gm-Message-State: AOJu0YwL4m5pVKBZKspcgXJ8/S7XQN7zh0iOL8pxTpkMYIuhGJAMFdUD
	LTOmheLhyWZaWwPtSfitI/vdnc4pyFEcIc6NPXuEiZ35IpoQ1MFz4nkfJenrWd6V012rPqc17FA
	I9glydEJYEZo0NpJhfwo60qxBvG8UOlqUUgkHmFRoyh96Tc+goxbz
X-Gm-Gg: ASbGncu4L1rTrSfz2mZiJQmNQT0gfWS2u0DRB0N6qKGhw04i7d6en5HQO6gLI4s9nOR
	BXagvEH/88mlNTGR0dmVKiP5mlMJrd4s+OHDIys3lw/1dzlW7xwlClhHbPxlDVNWO5+dCr1jyhJ
	TVx0GNoDOZaX1zysv15L/jXuDmIyKbcD+NxvoRo+A0aMb5CeWPXoC/q8fbD9D7opY0P7tDLFWBl
	7Gpe4A0kVtOseUDFrPjL1tM7JhnVjCsk/QlE8sB7Vzu4SYGoQlk5LuDvMI5BoQKmEg6wrbmZgJH
	wRlZJOTPBBSghC0uGqlUb+g0/dilLpdFJrwHS9NVF0B08fAw/xDyNqCcaxipJc9lMt+UyQNdY+L
	GpKKDcSBzYMg+pYEEKicZSOYUwOUVZkYrH0e7e4qKD84ZFmGToe7iC1IqM8YbHE9z
X-Received: by 2002:a05:6000:1449:b0:3e4:ea11:f7df with SMTP id ffacd0b85a97d-3e64392b8c4mr7476348f8f.40.1757333899315;
        Mon, 08 Sep 2025 05:18:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+yeVQRYSd8nkCUCllIs0DiL5pm4cULTomNXgzijKtbB7fyh7LoqFBush3PDSaV4UKlqAXEA==
X-Received: by 2002:a05:6000:1449:b0:3e4:ea11:f7df with SMTP id ffacd0b85a97d-3e64392b8c4mr7476311f8f.40.1757333898904;
        Mon, 08 Sep 2025 05:18:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45de24ab648sm74672245e9.5.2025.09.08.05.18.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 05:18:18 -0700 (PDT)
Message-ID: <0bbda135-068a-45bd-afd6-3f5cdf4e570d@redhat.com>
Date: Mon, 8 Sep 2025 14:18:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/15] mm, swap: always lock and check the swap cache
 folio before use
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-6-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250905191357.78298-6-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QjgmIiw1kDpB-_lTUAnXcP8rHLTRcYca1V0ypldfbxk_1757333899
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9877140003
X-Stat-Signature: uee7ytzu8jm7n7z4n87cscj4ox1gc1di
X-Rspam-User: 
X-HE-Tag: 1757333904-808659
X-HE-Meta: U2FsdGVkX1/nsUu8G3edaWpmznAap6xyKNZzduua4/ig/VkXsNkiIokyJgFNdIBhSTFKWa77EU88af5bxL0h6J4nKqsK1Cpy1OQlgcSQqdUTDA0o4lx7GFZ/IPsz1CkqFavboMzQ5HobzqmQS6zjWaTZF9NRtD/nYFviCpw0Z9PezzcQ2Ld8Xjfuk+LHgjeAKwGRbWM/3XaK8icwBtK/fR75OHFi0KtCheXBp5N/ZZLGb6Gz1/JGLiyJ+E/+wS11lh0Mw38e0M2NhmHAbtJTMAOHKCAWQ/zLafKk36W4pB2l7xK47m8Kf69XDX4+TCARGRQeQUZICN7sp6TFWEsjSIaLAFDWsKarzo+3U2yLjxIRAUbzemWSxHTfIARZIuXcWTuvCZQKO+WF2xAx15pMX9fGgV2bab5osF3gQaWioQH2rBFFnDTlck7lsYjM07qdc4bKJdsWxBLsAPSF41u++XTzZFsFEvgB+PzWblTf6tGpbcr9HZ1mM30G+DY2pIwBTdidCx1z5dTJunZDBlBFpshUzWUosgl6vusQQNEvfZr4n1q56pTp6dCEwlvHcjh6cTisHjySpTn66oW+PUVDFXOODpSanTd9fG9qBRg9sVgiPjDNu+n8bgA8Kk773pmvs8OJ7PYbkP8Z9PUCJhqmMkY11U87Whp4QH62yqQKwVjNidD47fb0ldBxGv6KY7EIcuCPPIDmSWbRUOjQgX1GSHAq0efI+6EJMNCnSvQa6CORwOQp1+wKK46Alt7jOnbLwtHTTBxNYx42Mulx5v6Ao0RLq+e+g57zp2InMvHVVkcCAEptmsqUFy55v3Nt86NnR+BLT+1SA4lOQxqaOrH72e/C5AvUWovDk+VLLhtFTA9Tk+0Xpr3O5pqg/YTimtA6c501b3B5DN58Gk+JbichxmwrIB3bHgRqbjmM7Oise+/T0/CA7QSpLA3DGVMzK8sYxohpJ2LYjW4b0Y0CBpi
 0krtQX1C
 47rNcFXH6hEMwD77EVlBY5RHVtbDz/oKiKBR2z5noUX6UgwA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>   
>   		folio_lock(folio);
> +		if (!folio_matches_swap_entry(folio, entry)) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +			continue;
> +		}
> +

I wonder if we should put that into unuse_pte() instead. It checks for 
other types of races (like the page table entry getting modified) already.

-- 
Cheers

David / dhildenb


