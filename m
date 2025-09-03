Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31BFACA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 08:25:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86FC28E0003; Wed,  3 Sep 2025 04:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847178E0001; Wed,  3 Sep 2025 04:25:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 735BF8E0003; Wed,  3 Sep 2025 04:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6287E8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:25:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F31261DE6CC
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:25:22 +0000 (UTC)
X-FDA: 83847254484.18.BC77C32
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8DAD0C0007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:25:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IEBTdBl0;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756887920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qEo6sIiOZpM0+aYlHlHYuM/LZSXR7Rc5DD9SislhVzk=;
	b=W+r3dabmq0YDc4uWJM377EyWBy1ASgxBcNV0sXaxay6J4a6TCc6W01H91j6OgDOdzGXbYV
	HEnaTUH714Gnis9MrCP0+MGWNpjz50SIpFeu/XPAp4c376JYLymGC7pKNbBgH+QVc7UiVj
	O1+9WLLvHcgFHeZF2kNpHIdp1BmouDI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IEBTdBl0;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756887920; a=rsa-sha256;
	cv=none;
	b=qu2xV4CtBUWOJFzH4q4115Sy3LexjcqUbC7ehpwUmsT4Xk+fCUHjF9QPpwp1bH3loVWPrY
	FHmOL79Vj0Bqcpenz7BiMBejWbgPElEKHodoDr+AcBefodMnhkJF9LbMjhSQZeIkViW3qI
	3doZFGrIMiGORTuyvMJAwlZCVgjJmeU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756887919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qEo6sIiOZpM0+aYlHlHYuM/LZSXR7Rc5DD9SislhVzk=;
	b=IEBTdBl0aiKBtX7F11gnllCMyMwMylDn2eg4l34hHJlwXRrSxM8XHD+0VfULe/lVeQA514
	/SZ5k3E/hnEIBBVW82Tf9HRUWgcsPPlB/0gObHuut8GQ/jA1emV1+8Lgv93x8BvwHlKbnp
	91882JndgoBQRrQbERsElZJbBN907a0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-GK7WfKvPOX6kZ6ezk1FbRw-1; Wed, 03 Sep 2025 04:25:18 -0400
X-MC-Unique: GK7WfKvPOX6kZ6ezk1FbRw-1
X-Mimecast-MFC-AGG-ID: GK7WfKvPOX6kZ6ezk1FbRw_1756887917
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45cb5dbda9cso2420175e9.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 01:25:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756887917; x=1757492717;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qEo6sIiOZpM0+aYlHlHYuM/LZSXR7Rc5DD9SislhVzk=;
        b=Dx6jDzNLkuRgJrN3DZqS+h+FSDgIKTv6RJ9JpF9zB+XW7HDBVgeIYhfmU4mppbdw5l
         hEPMxmDzPVT/DHONnT9EeQB2mj1GfFLXf+Fu/lav0b7FoVsVnPj50N6AEAihX3FnW+hA
         AL2cITrumozO5mvo96lTRxkPqwRMO3uElP9m2TZDf5AX3XFKYc+13Cvu+rg8vXemyjj8
         9sMnb6vIYenRGrwhXCZNFxHo71W9VmuadfqRy5AD9g3O/VXrbrOZDUpAkEWNx2sZQyLz
         3P+yibF6+X+yvGcz3HazqKv9lZZEa4uDIQQ+TAG1JD9XMhqYeG5c8qYDivH0YCLP5qil
         epDg==
X-Forwarded-Encrypted: i=1; AJvYcCWzxqURS4hYyTrevY58LCbGwk0mflWQiWFG+8BRRe4CADarlDZFwk/BiX8IGiWVEfHxvPQuSPAztw==@kvack.org
X-Gm-Message-State: AOJu0Ywf+pdaMK0Z2tpeT0wMGCPxABU2CJR+ab81gP4TdRa/oCxQVMAs
	hRGuZOiv24YZeQDuDPoH8svPtdIKfr6wrsyPCLqXQ7d2UKd82VmcIPgtyq4aC7ApxRmyhl8NgPi
	eL9fBmEi2GT22ig4he44GzOij8ypvL94fK8bUL7dtan3qoycOobNi
X-Gm-Gg: ASbGncueKN43zPs/mbjZb7bwmUK4pfolAidPJZcGpI5a5bR6+Zbvx+b7TK9zhfzC+OA
	LvoqkqnFsELTw3T0aQNUMOJFWbxTzmYK3VMXY1xCtPHiNS1W7ke+ZWb7GGp3ql/9YDIbv+YGJkR
	8CdXu1A5RPnnjxnyfqO9lTFWj3kfAHmrjz2X8k6J+z8Rym+ExYKGYd0RZCQNQiAVIYOe2kXy6xY
	No7TZ+kC+mano+25zG5ZyQozS1AGPIJJ/PwozyX3r8GN/oV+D550dtuoPzedTxz3BFhJhCDnCQ4
	WlkmJT05VQ56TeVk1m5NlA2B0FBJ6NLtnuiFEf0DeNwsvXRhirRLWMhNpr+uv+BIeLGsz8ErbYj
	bjoLAdLdA721MqjSY3H83J+7vpJ2c7EcnAa26G4TBnIb15fJuKpsHMXsgmqqWthUf8kY=
X-Received: by 2002:a05:600c:444a:b0:45b:7c20:5709 with SMTP id 5b1f17b1804b1-45b87bf56cbmr110751225e9.12.1756887917385;
        Wed, 03 Sep 2025 01:25:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXFZTNjXv1KCj2KN78f3Fb0kdyuEOiHEfKZ5mGiTx64+28c0jQ3VEf6QxekGDbPo7kC1JGRw==
X-Received: by 2002:a05:600c:444a:b0:45b:7c20:5709 with SMTP id 5b1f17b1804b1-45b87bf56cbmr110750855e9.12.1756887916923;
        Wed, 03 Sep 2025 01:25:16 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45c6faad9cfsm33627155e9.0.2025.09.03.01.25.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 01:25:16 -0700 (PDT)
Message-ID: <28e704b5-92ae-43a8-80a7-3746db1832fd@redhat.com>
Date: Wed, 3 Sep 2025 10:25:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] mm/shmem, swap: remove redundant error handling for
 replacing folio
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
References: <20250822192023.13477-1-ryncsn@gmail.com>
 <20250822192023.13477-6-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250822192023.13477-6-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IhuYkrg3hBtMD1xLWLQrolJ7Hy9vJ17YKgZVYEiu520_1756887917
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8DAD0C0007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 1sh38bqzogqg5mgyubro5fikduu5x4hz
X-HE-Tag: 1756887920-615946
X-HE-Meta: U2FsdGVkX1+DrPiq4VzeLfzosu5iOaUSSM1tSOXCYQxkCZQy6aY3WpbYxG+b6Uv3XMCiU2tT21IqAJjOKkXX41+GuWxnZ0ZeD2P0bitGvxyhg+JLmsJ/IIK10i3U8vhWSOSM8sU0Au6qg87ywyu1qBvoYzYuNWWrhtSSpllzeZvVq/x8rC/EUMG8dDli6lWaykIu/2EB9PPqtyBa8D3ERXwnZ9QudBrV3U0+dycjm+ConlNMcQEbOqfWP6jEucrKN3MfuvLCtj8mYEs5/x74idaplobMZuA8s6cWq7Tvn27jDAXY2kTJw8jdsqFvpiJkVurAkEtxZQvzQ4gG+rdcf/mj78JARzwXpqlSYafMs/TFLdUKQsWH8Yclj11LYOSkRj2tZrBvEZJg0ypqjAZ1FydT+qRQy7+1oxRxAqnRP3tjyrX4Huw9EBcGy6yp9j7HNHX6+ZhGpmj+q206PbLkvMfXv5Ay6gKYfd1cedQd1zhzAy7yrwB7lRgHWO4/mWvxXvYeYwrcIyyXqXHSwNbAC1uRN3MU0hnLVvZm/uleYS6VqjeN1/6L005h1KmoAsoUhVqNd3TlXkMVIkUVrGaBpBq4IZ+5TP9+qJdyHMW9QVAPWlaRa+iuGVLhuSNtmwva7dT9HnCTsX777JjmXZHLoqnU1EObenvYNLmQ0vaAmZQz42GWz3+PD7YtkuDRW4IHU1KeGeOhQ3M726dOBF+FuaoFJ/R6l10/3qdZV31wpDpi/k2RybFhbSn6u9l1kE+kB5CN2GRfnJpXJXDC1gjYeymnw2o+hzsmK1nfTk7dRH1/NGN/dHk0G+hBCSvPmQQtuzvz1gSW5lxpdYAoecSJDIX1oWWD7keUwsf+rGdlD5IWX3Zap1iS/0xcIv/EjUPkjEgo0ifdvLky6j7uyJJN/yqPX2ucWihnB/24A/5AM1nzCw5I1+cuu+WCVoADY0bbG5NtnX2flw/W1hCcGA2
 OCyNhKxM
 EtVOceTvlDiXbTPlYdS0mkUG8aDzeCskwcXTfOpXBTrXIaNyRhIWFxlx4+VhKmSgiVvFzjIzmqtidObquKmGAqqNmoJlyRQb6O46E4H+UYt5BRYadopjhpx8JRY+/zm8HXbbLubTAyZ2AlLq+7ou2wpnrhSvkTBG9uTwUeqbxSiPNKj5nCScTCIlalN2//fPiwj6433GD20HMZ4rRetBcoEyrSI7v9iRzjRH1EMWq2mtRKdfSEHLSty2+6SPcvD9y2ORpUUHdRNY0nDGSF6FJTM34AJP6dkQGakA44OwYu74p1MbJDDqylSizoQlaCAQt0yreQkjCH8fIhYWKZ8DJAgKZ6hPCK5zqpsFQuijvC7BoUEQWthnLo+d5Po/fIN4khiWEtRqHQKVHddKjDc+fnKqyL8wYnb2tJVmjBu9kRvyh41Qc4BtbuwQu4jS6XLp0KMxIyYfwLq77Agdd3gQyGKxjcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.08.25 21:20, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Shmem may replace a folio in the swap cache if the cached one doesn't
> fit the swapin's GFP zone. When doing so, shmem has already double
> checked that the swap cache folio is locked, still has the swap cache
> flag set, and contains the wanted swap entry. So it is impossible to
> fail due to an Xarray mismatch. There is even a comment for that.
> 
> Delete the defensive error handling path, and add a WARN_ON instead:
> if that happened, something has broken the basic principle of how the
> swap cache works, we should catch and fix that.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Sounds sensible to me.

With the "!error" code not deleted

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


