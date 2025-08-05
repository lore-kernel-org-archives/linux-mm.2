Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E93C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 10:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 933006B009A; Tue,  5 Aug 2025 06:47:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90AA06B009C; Tue,  5 Aug 2025 06:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F9916B009D; Tue,  5 Aug 2025 06:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 703A66B009A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:47:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 244FD114ADA
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:47:46 +0000 (UTC)
X-FDA: 83742378132.12.437B022
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id B1DF0180003
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:47:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XW6tGdZn;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754390863; a=rsa-sha256;
	cv=none;
	b=NymrlHTMddZ7naNCqY23E81fmLHobbWTqSPmLyuJVkFc1x3gLo8VA1RDWRs9uwVkZ95ebA
	Hp2ZBIxV5soFXJhYuX6d+QJ93EWKdaS5Ji4TAd2PUi60Z5hK6l/SBkdoO0F+BUQM4kWXLB
	bMHg9UwkSyWS6g97bwJXUMdGIf27+NM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XW6tGdZn;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754390863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTTeUXpaEfmXOu2q1XspDyAZDWPFExfM5BjlRehMDhk=;
	b=uWCxSo4FBCNveTRxg9OK0eMcHnnDboWjU3kWERl1qxOCMTTvcNs5LD9gr9hjIVq1XuEtlH
	yzEdGpTIuVXV3AdGFHlqH7oXgb9PvgKsT0OwS5nQkjMGLtM2/XIaitcuk0RoE4ttU9WWxq
	O73wG8JbkCA20NeMwQpuZEqLPrqXZlk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754390862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dTTeUXpaEfmXOu2q1XspDyAZDWPFExfM5BjlRehMDhk=;
	b=XW6tGdZnghhJabIgmPo/ho83/pUBVo/qfG53zv4N7Bd95uLPJEoCu11zZWwNYncoleK7J9
	U81vXrMAIXsLgRNYyokP1SHly6cF4M/cYfTWv/2u5pR5Wu8i2lBzUx/82ymkltD+efSbZh
	jUxPbQBPSlSr/MZT8tmrzf/vhd8K5e0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-dPgJpi8vNVuDbaKiY1v5xg-1; Tue, 05 Aug 2025 06:47:40 -0400
X-MC-Unique: dPgJpi8vNVuDbaKiY1v5xg-1
X-Mimecast-MFC-AGG-ID: dPgJpi8vNVuDbaKiY1v5xg_1754390859
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b7891afb31so2793692f8f.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 03:47:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754390859; x=1754995659;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dTTeUXpaEfmXOu2q1XspDyAZDWPFExfM5BjlRehMDhk=;
        b=YZPsA9vd14mujrP6yy6v0PZK5gkDZFbbehI96vBYvY0dU2oC6ep16K1bgU0QcABZCE
         yWjT21M9EnZkYKSjvQENaw8Y1ozT4FwwTqI7mqFVmH5k/943q3Q+KhIBMFf4mkQIXzkE
         Qj/d6GkUz+qVEorYgasqyTHciOQSdcCWe2UyyuplwzImDfukS9bSqLyQQMREKbh8h0zF
         Ip5KqAdIEURX7sfDqyYyn7eGzYDJKxPr/nqg5tTx5Ju+Dxkm63cONFC3kj/rsdTc95xh
         Dvt8dsMWko1qg2fJYsOQYN2aK9H4TD1V3YJG/pjZg+ZqChaXfbHGKdVpxeLQKOT3b8em
         Hg3A==
X-Forwarded-Encrypted: i=1; AJvYcCUVigqwk++r5mRZC9Ib1gZ4XkL0Vlonz0xbbUu2D2yrmqv2oFdCAhirMTS5HgAIUqvWRL26Htcytg==@kvack.org
X-Gm-Message-State: AOJu0YzKhqxghxRfQ2yuwbXvynb3eZ84atJq+w8tbNuPcnwcv01QSfO1
	4tViJvJKX676mN2wVWBY7UcOsRFMcP5hENGNa89HxKe6kGnxsn9noswkPzOEdtNRwsmJryZsqJV
	ConudNofFkZgF6/FfV30qZqjFubDg4RbiiSFy/pRixInO4itkLptW
X-Gm-Gg: ASbGncs4M1JPsZaxcj1hLdTavZ2rqPdB0Ee4qBe1rPJE38KgEH47NAnPV3ppOJlq/h2
	oLtuZmz854pZIO6iJV8ahpIUO1A75HdAT7a4mnTK3xkLFGRGR8RPffsCI/PREU70EtECYPHh1Ia
	DhP9AQ7iPwGjYrmZIoVZ85qSXcZEOcuCjbJVPWJHgrPRXuEHWoRLzsyRmjccbxXjyh0RxVmzFH3
	hEpvK2OYDx+xI66/gkSLbf59ISAJrpB/ZzA49oezMRE3plSslFHdz+teGZfhAeqiCLFh1HaGIC2
	QJ+O364mdMMmqUjO2ojXcdbGFarIjcDpNT8oCgJ+/1ZLQT4eipmAuW97Ltf0NC4qFMBlh2ZXr6p
	5GEkftR4GmIpSpTFpkmNI//ycyArxBcg5W0va1TWcHiD2ZdF9PD/jc0R4wfYAFZCSxX0=
X-Received: by 2002:a05:6000:178f:b0:3b7:901c:92ee with SMTP id ffacd0b85a97d-3b8d94cf1cdmr8432087f8f.58.1754390859342;
        Tue, 05 Aug 2025 03:47:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmBnG3gma3djOJ58PE9KbMw2YKFxWRTijeMo7qV2ngyd1xQZLcK0FpBmhAOFea+867zmz5tg==
X-Received: by 2002:a05:6000:178f:b0:3b7:901c:92ee with SMTP id ffacd0b85a97d-3b8d94cf1cdmr8432060f8f.58.1754390858853;
        Tue, 05 Aug 2025 03:47:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3bf956sm19096277f8f.24.2025.08.05.03.47.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 03:47:38 -0700 (PDT)
Message-ID: <761a2899-6fd9-4bfe-aeaf-23bce0baa0f1@redhat.com>
Date: Tue, 5 Aug 2025 12:47:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page
 as-is
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 kernel-team@meta.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Takero Funaki <flintglass@gmail.com>
References: <20250805002954.1496-1-sj@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250805002954.1496-1-sj@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MPI5H5roHzzKF1Sq7vn5Uf4I3ozao-vWDnX-jkWPbIk_1754390859
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B1DF0180003
X-Stat-Signature: r1p7fsauy1wfr9h7guoaq7b46qf3dcfi
X-HE-Tag: 1754390863-717918
X-HE-Meta: U2FsdGVkX191nveRU9S9TTwHHJrpJZW7+swFeAK9msffB9o9wlWcYxTW9VtQHClPYNPIhMc5k8UkEj3iQZ6kLnwb+5JDR5OoQXaj/TQn5dPSEbtS0wEh3fu9dFNGr6r0/WWggVqcmK7ehGWnPo9cYqKJI1oS/RWYC29vbe0FaPoWKUhdG32LP8H8TMsAe7o0dvFlcDVyexbgcCzFDExmvvMn62xmCHMtMPTmdgcPo7DVpfYn6K9IMScLaLLyohspSizGdY+S/77WtzStvTNd/C7xvOcJBlfMuOeMzjHK9mbFT2Wk8I74menDQryIzQyOaTlclcTwo7t1xCWzxwz5KBTr8yrVb7A4lm2WSIHjKKHGEFWYEqaG8pGQV0lQFuhNSA0f2tWDhsEfbs7kxcFyYUNPxeqIiPrFvhQsTPs2ofHj9oFIuy6wOlUFi6zzihoYxJ554nxMDUIqcWYhp8+dY/9MocqYWQOA/SrBECh43JqNV0sUCWvtdpyvihbjQaA9sx6nZFMQxCBi4zQ5ph1Z3lbZK/uE06ASiK8+vPsumzCBZ+wiNbWfsAHY8CINadIzwkQlcLlCdhW62DSVoQLtT6qQpaNJ77X/Z6iBMZtHNbVkS5YIHV6erqQ9fNKxx65LRYpcmDMFOyW9vB6tcDjORg8fUS+VtmJezO7Ixl3ud2xQyJMg0Cp6ut/PBS6/hwXpHr7+LDh9C5ZMFinoF9wmBUuJuM953ZLAQAjYXEPB21xQRf7HUL19VvTtP+QTBqdQRJZURLOctFgxHm4mbMCpESMZNnLNeyT2qzFC7ns+xAxPRUTmaafqot2Z9btApVPmCuFe8fmy0yx7H74tal6xbOhxIo7BrR6GKeoQ9xGE0NEIjLrD2g6x6PVsByl4u3PJ/x2zJigxMBzLagCv8+rNe7m5NK2J+WomVlGJF/24YvSxVNHgKWbNdtDQSsAp7JuhSt+LskLFbt6/JcQHw6j
 pDo1kFw2
 5wME/hlKOuArBxW+cJOIwk+LtpkVGDFX/OKA4Mqg6cyevrXU0QiPIZ0QD08NOfO34QvhWWKmwhyFygVgPxGJcLnYzTenxyhZwdkNWnrB0BGPviEsxMmsrsTH3trtMynzx6E2V/xiTABHaC92F5Ep2ZsIHq/ylWfdHgE5gQhcg7948gG+wqJJsm+bEOFeoI/UcQDMJI84kEPJlaiiGsMvvs7iTDhej1sj7v9kBRt3ngCNLG9gtpB5vpHFzFCLtTFtIFbCNyTmZkc9c/c4qR0Gm/6VUc+RRJZhTJbQgMCUuw6PJTKeyY2Np/5YrQE0E6w6hB5IzlNKEIDZcP72f9cjzR85bQb/qV7EnoWcnIrmHP/u3YBiItcjzm1VVUz1qFMCuy3B5HILVijgVolFuATpJWM/4XAArQCkOxbO3z6Fcwq9i1fy9z2m2qPFQFwqv7zDpAcQjrdNJ1ISVYnum2+Pk9nDJqeKh1RyXOXpTquBo/3NfeH4WA7dGCsNNPL0Yxw3JyQTjrk+UQXLI6MxepIUfojMPBOMWPBKTpn96
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.08.25 02:29, SeongJae Park wrote:
> When zswap writeback is enabled and it fails compressing a given page,
> the page is swapped out to the backing swap device.  This behavior
> breaks the zswap's writeback LRU order, and hence users can experience
> unexpected latency spikes.  If the page is compressed without failure,
> but results in a size of PAGE_SIZE, the LRU order is kept, but the
> decompression overhead for loading the page back on the later access is
> unnecessary.
> 
> Keep the LRU order and optimize unnecessary decompression overheads in
> the cases, by storing the original content in zpool as-is.

Does this have any effect on the movability of the given page? IOW, does 
page migration etc. still work when we store an ordinary page of an 
shmem/anon folio here?

-- 
Cheers,

David / dhildenb


