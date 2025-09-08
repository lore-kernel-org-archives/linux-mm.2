Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B52ABCAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 08:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193F08E000A; Mon,  8 Sep 2025 04:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1443C8E0008; Mon,  8 Sep 2025 04:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 032B88E000A; Mon,  8 Sep 2025 04:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E68D98E0008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:00:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9709D13C012
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:00:22 +0000 (UTC)
X-FDA: 83865335484.09.6217F0D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4B7E0A0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:00:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S8W77xtS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757318420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ZtGxzPBBhWZb8TdeGEHePc9lnXNDI+6sWWhJSedy84=;
	b=RabNUpGX/XkMV1k6A7JQF85IttYw4jquX2pL0p3KmMb7oKOiOW27vlx8LPeUPcE1wk5Dhp
	weplW/bEm6PzO3oiZ3uyumrfRjSjJcM0izpD/HeKNxVQ0HLYGeIRwLO/bz+iEf3xEhEOgy
	np3F64uGTYzL73J+tgHW34OxX2JZOGM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S8W77xtS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757318420; a=rsa-sha256;
	cv=none;
	b=UsageUvH59rg7IfKXlTgQCXKISJginlGWIng5XSLn3tV7zILxBT7rdZrYZP36LTfw0VwmI
	XsJWWznSxHwsZnLymKabFCnFNaupodgSofvBeutWx357hFMBiNv1lwHRjppzx8joSt6/uv
	e4ShK0Sw2CflkE9MgNiAaO5+tuUDmRk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757318419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6ZtGxzPBBhWZb8TdeGEHePc9lnXNDI+6sWWhJSedy84=;
	b=S8W77xtSzGCJF74fRBMWrdwQX89+PHzFXCbmUkYhVX2+aUIFysjh84QHBiEFtFRyHUCUTE
	2IsZfgFG+7tSF88NbBaoOq9de1N22COM8TePgoKoiCH7GXE9B0FwELQg/43d2O83lU7qFd
	AZWqNOYwX5MagAConl4eHOcmxgou2u8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-aic4NYlCOQO6n9aNH9Zu5A-1; Mon, 08 Sep 2025 04:00:12 -0400
X-MC-Unique: aic4NYlCOQO6n9aNH9Zu5A-1
X-Mimecast-MFC-AGG-ID: aic4NYlCOQO6n9aNH9Zu5A_1757318409
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3dabec38299so2597075f8f.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 01:00:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757318409; x=1757923209;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6ZtGxzPBBhWZb8TdeGEHePc9lnXNDI+6sWWhJSedy84=;
        b=k/FV86vIGB49G4RMbPAFGAir3c5jjuQHsG/UHvAcQJvBY5nLQrDkEaBT66P2UxmXgo
         tgtlESIH8VMqZr/k6SVMigJzf1I4GOUYiLw03tzdooUildKSo7ZRhrM21y+O6Z4Y7oCf
         dB19o4MVkTNq8L32uPrR4o8yqA7OqfsSRg9x4yT9JF4oRBNQSpD2u9xvm2dz+TNMKTG5
         8AgvzSrNKlNhInx6dgVFI98BTZBLhXuH4k4KI1sM11XE/gqqfnwQRN88q4r0/m23EaIj
         g7li7571RFO6f5QY192zFHnpw7Nk0KBUZUkHwqdvfQH1zCvnbUjPDJicFN2QAf4yPtCP
         sZZg==
X-Forwarded-Encrypted: i=1; AJvYcCVP9EzBadicsfnzpky/el6x4GWUvTqAt6PdVfjTVNqQhe6Rmh1pj9lkiVj/Cp3nVh35ZNQC3thTVw==@kvack.org
X-Gm-Message-State: AOJu0YzMatE7DP6NCQZQAhKz6YVKkXosfkWE4lJC9uAb/TrJ9hvAEWIu
	reURo1oBd8TTzVH9rIGm73sdJmlEzanNVIYi1fU9oLRTGlyJ8sPJUinfHgdKHp2pmirTdBvitpN
	g5vkuNSHybzr9CQLQDrL69BvzDqmgdjfh+ne4DYE9Qmp8SkPB8DL0
X-Gm-Gg: ASbGncs/x4mqtLRJ1KTwcrV14HBYI2qo1dgo5vX6v8brACa0OoETqGBtsRSDjFDIQSw
	s0t6xuJ2PDRfU8Jz1zEeBeGR23BUczmI31sGKGhI3h5Sy5SZPwe0+dbBvovT/dvH5L8v7NT2tVA
	Ux4bCGs47qyVZHqxE6MFEfEPjAYYv/INXCFZt+DwtjHd7eEgu45cviR58i7HXjLHyYttkfbUWnC
	ogKD68TugjgmUdQcPzudUaTgKU7MHLF5wu59cfs3VAIq86Xz6MlfA5lEcOrKtiO2Vfx2cqxwUbe
	q3KKMJThv+cuxcKVkQuCqYXkcYfUl5T09YSSkAWC9+2lyg9UE4EW3MLGSlhvYJqH4OkESZ0=
X-Received: by 2002:a05:6000:26cd:b0:3e0:2a95:dc9e with SMTP id ffacd0b85a97d-3e64ce50347mr4840542f8f.57.1757318409166;
        Mon, 08 Sep 2025 01:00:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+e2xgTQYe5kT3rV+uD8LRSVafVXIklNJL7Am05EAxkn8s4rPl3yNNJ7oQs/EOmF2miaT83w==
X-Received: by 2002:a05:6000:26cd:b0:3e0:2a95:dc9e with SMTP id ffacd0b85a97d-3e64ce50347mr4840495f8f.57.1757318408663;
        Mon, 08 Sep 2025 01:00:08 -0700 (PDT)
Received: from [192.168.3.141] (p57a1ae98.dip0.t-ipconnect.de. [87.161.174.152])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e740369f1esm6798834f8f.11.2025.09.08.01.00.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 01:00:08 -0700 (PDT)
Message-ID: <28fc8fb3-f16b-4efb-b8e3-24081f035c73@redhat.com>
Date: Mon, 8 Sep 2025 10:00:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
To: John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, kasan-dev@googlegroups.com,
 kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>, Aristeu Rozanski <aris@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
 <016307ba-427d-4646-8e4d-1ffefd2c1968@nvidia.com>
 <85e760cf-b994-40db-8d13-221feee55c60@redhat.com>
 <0a28adde-acaf-4d55-96ba-c32d6113285f@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <0a28adde-acaf-4d55-96ba-c32d6113285f@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rwKisvtqfRTgUA_N44t6BJRgId1TSSHm3wTCILAJeGA_1757318409
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4B7E0A0005
X-Stat-Signature: cpns3bt1euz57fkupd55iywmx9rmzpyn
X-Rspam-User: 
X-HE-Tag: 1757318420-203971
X-HE-Meta: U2FsdGVkX19OSNL2cIE/jLbb4UfOhWwscyGR3ePZvAivFXEpR9/FwhR4xzwt6azjJ5zHmJtKI1MXExF9CW110UbKu9E5a/aB/rgz3dTroHmVgzCs/YBeYu9zPbM/jiKBAMU9fXkXxFC/APLLRP1EsvkPveloBBNq9EXNf+Fr22HGuD0tcMAn/6O6Jnfek9I2KEMvWVzXsuh0et0blwL5NemVpOddij9oj2X3thviCNRcF/3wR/0IESCS/LFEcqRDx6f9pZps4aYFA6WZy7zHM2uinf0Lt863wZEZqdrGN+YzK5dyftxCdkmmL/xqlCgSLOkC0/J8ADf3g8VwwHuw5JwIcdxzel/NKGoLgl12kg0ZdmDuG6XdwhHyhTTHXKwLJKUIAA4LrliyyCoppKKAaXRHZ+Vy6uR7rccWdlKTHgNyowSPHAqufa0U2tspWMtbJqoxK/jOqT4Und3BO+ASLuiQu5mQpPEegjlYWeslA4EsNv2CpBL5DDLg8xAdAg0pqLBbxaomsTTT2cep5f76duzTZkirT914mx133G5SMaAM59T8d1cviT5gYgIIw/7QCtRun922CIka3dr671kF28kEheGLqv0WlDm7bIcpwBWtQx9KSnY2lmqlagiKAI5OlWAwYEtw5h1QuchkhgKapJvN0WOiQXj2oKg+NC5OwJEug4y9B1hBswdcL1z7PhnE08czRi0wym8bxGqEw6wOQCO1+NHqpkKLFLaYajeuPUBTRx5gpx9wMKqdWbhjDy3VsSJBSje1oh6cZr2pregR02LX/yBxQ0VNTCsf4EiX9+ye3uNZNTPeTnnpbRraNyn6CA7SAKpTgbvJ9btmyocE4DLwWuVMUmF/s7KfSabIHhbzx3zvXcWq+Fh6Hxm2dZRPyc6V3UEP3rhFAaN4YqtgFVpTdg+88bRIZzrB4uv6aTvefPxDkzLgT5acux7hE7JQ8YAd4F4gzPGhaDOIaHI
 dcZOY/z0
 GdZUxJ9phXVm3RHlW3y/9/BIEED/6+utuAnbQf5Ht5N/PmGCVtM2OouO+Au5BoHWx2JaNp6Tt4/yzMG21bVta8axdzAMX7G8B/NX+v1SJ3acgiJXs/X2mfITUTLiQ0v/qcp2qjWubV8EMy53fn6tY1/JXr3x7Z8ZRAFGbIt8PwlQtF+tRndptFsb0CBYSnaDpqG2uoqZ+iEpFSWiTCP4BLGfck5QMGJReBkrswPrKSJ7pKhKnurtlakSbVLXRmHYfc605yb3VXfxgafnRLdXKBSp4h6fvVQpZO9AI7DIQB1lV62RIjjRGgrdXPlHU2C9S0qVMbpDKNwUSmsBGykqRjQSknXb0r16OnB/OghJ3qdHrESh5+Li1iBfPKzJP7dgPvCoM0ZutlPlgyAs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Roughly, what I am thinking (limiting it to pte+pmd case) about is the
>> following:
> 
> The code below looks much cleaner, that's great!

Great, I (or Aristeu if he has capacity) will clean this all up soon.

-- 
Cheers

David / dhildenb


