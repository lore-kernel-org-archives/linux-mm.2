Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFB76CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AD5D8E0012; Mon, 20 Oct 2025 09:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 184A88E0005; Mon, 20 Oct 2025 09:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B208E0012; Mon, 20 Oct 2025 09:11:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBC4F8E0005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:11:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B21F05641D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:11:13 +0000 (UTC)
X-FDA: 84018528426.15.14383BD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2D5898001B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:11:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dHcyIpLO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760965871; a=rsa-sha256;
	cv=none;
	b=SytzvrXx90gXt19IgGSXlEvkpq7z0pOU7NCmFvXrI3qj/1JAiHknRK4S3fGhNTzgnh9aW7
	i5OdyoIlDJ8R+R/19OQhgn1Ds6MZmuYrqjoAuBIRrZByt9nqxj+NhfxnPknL0McPdyqliC
	3TqB13LwDYPMZtoyeeBxL97Q9kiQgRE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dHcyIpLO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760965871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HrSd1FAkJOZLI8GdXwIeRGYjDgTGkBQnBR6C76GuO/g=;
	b=c0ocIUokMPamZ1c0pjyrFNI/1WS1uf2hcgVHFnIXjm1LR8lwCcXIbY63vxkqpMthq0CQ6w
	ArIUEYcP/4F4LbYmOt9LFQhEg+1XAkrWx/3KDHLZkFBW/1Uwa39P83bYrMHf8DTQ4jYMQ9
	vlRIp/vLTDIfJWtmwBMp4W9pElZrLX8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760965870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HrSd1FAkJOZLI8GdXwIeRGYjDgTGkBQnBR6C76GuO/g=;
	b=dHcyIpLO1J3Acw4TwjVeCfk1aYq9pwtATiW8QmqLgRM9N7nftMPG7UnEyCO/dU5OOvvrKq
	PDm/8JpYRYShPdoyZtZHR8FUfE3bQeZPSpVQXcmYtqaWz011gFv7Gq+gmNqHMMBDYGqQJL
	imnb3fnSlNAHqGayC1C/A0l6UN7ZBns=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-164-uZk92EpjPhuEaWTarpm2Ew-1; Mon, 20 Oct 2025 09:11:09 -0400
X-MC-Unique: uZk92EpjPhuEaWTarpm2Ew-1
X-Mimecast-MFC-AGG-ID: uZk92EpjPhuEaWTarpm2Ew_1760965868
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47108163eeaso21209925e9.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:11:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760965868; x=1761570668;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HrSd1FAkJOZLI8GdXwIeRGYjDgTGkBQnBR6C76GuO/g=;
        b=JMu294Wy1zYGGsxdqaA8/S0VH42tCoNXC4HPjrsR+ZemfHYuj/WBymuNPwuUNjWUae
         sAy1U4guh/HQiWX9wMC3yDDi3rqe3g/ZRfi67+5sjK6GDXMtT1N1UDdrAuJVvNZudSmf
         xjkoBXxeUCa+cngz0ATEk6WCiaasBqQG4AVm1gMi4ooFrZo28rlI8XzHt25o/MxY8XFb
         xiwfRvZArIK7V7//BsMXcxhIVQPWTxk4eIpuPmGCzXoQGHv7N2rcHb+WuUDO7o1NkHSA
         qjgfcLnEeiJf3yHsqP/Wi/ce8/61YWLj+eSpEf9hWz12VaefmrjHzyLVX7AdAPWE4We8
         hj8w==
X-Forwarded-Encrypted: i=1; AJvYcCXXgKij4kW/TxsbCkA4lzuPYjjEgQ724gVFSUtutwVpBn6Bgks8B9uhZTIVNH9C+ZtZDrq2P1WvMQ==@kvack.org
X-Gm-Message-State: AOJu0Yw7d8aIuxjf8aRpywaOvNFpn+t7/cXbGtx39bhboZA9AABo4M9V
	KILzXfF5ro4SzmIi750leeca7btb3Wmrq/3ykuZ296FRt0O1AThyaiR4MaWUB8dYhhsN6SgmirE
	B5XAWm/liyQwU5C4osXMoveEM7puvFjjS6O2HP1JUndPtCX29hJiv
X-Gm-Gg: ASbGncsybomrMI9J+vx1QyriFbS6bIrzqrSsQL99EcyQlVBnkcmUybAYcVCKrPBa7fa
	fE8gZvcLlunsHfmBQWN38mGmOJhEp+D8dGcL9dJmHW4jeRyoZdv5xX3QYhuWk+qsc1bMDH0YVXB
	wYgINt23+vQrLyK1SkkhQ+EXJutdVId/h+Me5OYa0mlQzgHQt25V1Jc9HUh9qnuc0HLbgyyAGoa
	Qno16Mo/d2pb6RQcLC5x5lHUmUAXj7w335PxmtHxdFK7Z9T1j2Yfomm/kv9ewUmBlxxYk/41N/Q
	pBLrgLN4Xoslo6l3GzxjmuwZ6yJe3BXXpqe8ibZFH42hdPt8KQHBFEER80OHlR0rvXMGtYuI6gy
	FWZZ4pgZRFOmdMifT4haQefoZGGcwsA+oCE2T3k0hDeBUunGYW5qupSgUtFZ8StwDjQb4hs7aKo
	Vc4fAPvwHRxXdUi0rAiHbWxjNtGmY=
X-Received: by 2002:a05:600c:8b0c:b0:471:1717:41c with SMTP id 5b1f17b1804b1-471179121f4mr81400095e9.24.1760965867843;
        Mon, 20 Oct 2025 06:11:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFdYu6Qyrymzh0FxUNnXYjT0miav3YGrgXeWzlhaNdLFgILOFhVeO43V9WtsptWIZrrRfJHPg==
X-Received: by 2002:a05:600c:8b0c:b0:471:1717:41c with SMTP id 5b1f17b1804b1-471179121f4mr81399885e9.24.1760965867490;
        Mon, 20 Oct 2025 06:11:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47114423862sm233219665e9.1.2025.10.20.06.11.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 06:11:07 -0700 (PDT)
Message-ID: <c3735a31-dc27-4dfb-9179-f1a929dfcc47@redhat.com>
Date: Mon, 20 Oct 2025 15:11:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] mm: huge_memory: use folio_needs_prot_numa() for
 pmd folio
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-5-wangkefeng.wang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251020061845.3347258-5-wangkefeng.wang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1j_PIaX-ZaI0HgoGGBaqlfZI_pGccFvIaeYJNGt5i0M_1760965868
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sh83djc36sakawwt6ugeoa1fb45kwwe8
X-Rspamd-Queue-Id: 2D5898001B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760965871-369372
X-HE-Meta: U2FsdGVkX18p8CbTgFCOPVOBGLDrbvfUXtQqWWogkPQpDhlaekLfhhB2a9Uze+BgK/26XKtsH3KFD07IH5Yj249mO99eSN5yC4DDnKPh+aMupH+VKon9o9mdH+Mfb80o95VLnlk+HEcZfubO6bdj4279eMJunwAOq5pDJX055BVIJSeHeImn2p/m8QUJOOVudWEOMJ8SgGzBHufJbwtBeNDsPJGj9Mv8TSgvKqX+Z48M2FhuEp4Eplq72lWVbeLJ3G/f11P2QJUvK8SR0IBILRM2rpuKtPtF0BHIfIaJSIU4Dc1+2qZhkkdcuyVGNmKWkuuqAwgNRLjH8mVrqdup2M6vT4h1CAJTvF2AkNIF+xXMc73Z/u51dzoMO5HDzbpoP6f5mlw8AqCfAhUzb7vfnY3NFyEBUSqLXCfuTzf7MkSiK57jVojuUWD8lZa3TYGRr16dqYecZVivMKzMMX5+LAOMbADOhj1b9Lm+DKpMUNqxc+L97lwd+Epij3jLOit+tAyKiovNaP0tZx9NN8Nv6ntJadnqkX2+Do/8aHXAwLpDHTtAIRcCafDTKYoBpP0BVT2QRU8CD2ilY6r4ooSIABFCQMGu9ZXUoP11elBiVWnhLcyoEtRX+iVG7Ab4bZSBqCRRylsL5zA5G7QmwQ19ewscUn1h/R827d9v5xqdHTpq5fdPgIIxSPVsj3gdPfVduvGxuOjVGxG3EOdQcaCJVVdBXR7K1Rc+Mntdr6aI4tlVjsQbJsD3PCqVhizMQLeQZWK7gcFOqs3Nit9nBBMCqO8vWjrdhlAZ1tHQZVPBdvihm2Y3km4QAxQMvLplPl89Hc3DeNGbndv4mP8cfKWLs3SUgFkJsjfeVo8RdlwEcuetobDqG1hJXnk+rIr086Op7/rB5AGR0RXXo9vSj7jS0ASZ4aSeGpCPgcGGfPOg7eAKSvlbi7cGhbcq5pZMDXLukFTBlhWjtF8HkMq6rkt
 MLt6jRNX
 D8UXsanUnN3X6dqPYOYgWyaYtbDHX6wqQHYubUog3du/ytDIe7JKTDdFldY65pARvteBvDEvSUtrXmCOeDpShonsNQ6BL4pAtgcGIIdTho9G8e/1hb5WURz8EBMDMvd0E2t5pbJ3wE2LP6v4ppxTwQz9D5u8+tNJbmF7D1eCJ0yfmK8UlCDbQNwvWS/FZ49PNrK0LPCE5YLKTw0vgBEOlylx0XaUj7cUhrsP2mwFKQBTwBIUjshhpQP1Hd4xRLv6eo01PurWwBiPxGLu2rvog/MD26PLniNyXcCNZKw8P/Ri6onL9aoHmGcZzRstRDG/Xn/Yl0vfrT+nMIdpjKCVhAc2KS/ancybNucKezsWYnCKYTmFDJvbK3PXeJFEKBrPLV/+GA2zNaLGzop/en9BTmdf5eY5IaA+BKGFIUN+O6WA/NvZskhkLnjanKScHBcl5WVjHziIm9NvYceEIFP4HJ73uMeSlGyHR8p7Ge9M855/zMzIpqxVTcRU7G5Qv1zx8AG2Ohe5+dh699BOL5oc4rd0J7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 08:18, Kefeng Wang wrote:
> The folio_needs_prot_numa() checks whether to need prot numa, which
> skips unsuitable folio, i.e. zone device, shared folios(ksm, CoW),

ksm only applies to small folios.

> non-movable dma pinned, dirty file folio and already numa affinity's

"...and folios that already have the expected node affinity ... " ?

> folios, the policy should be applied to pmd folio too, which helps
> to avoid unnecessary pmd change and folio migration attempts.
> 
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---


Acked-by: David Hildenbrand <david@redhat.com>


-- 
Cheers

David / dhildenb


