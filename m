Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB6C1CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:57:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214898E0042; Mon, 13 Oct 2025 08:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C42D8E000F; Mon, 13 Oct 2025 08:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08C1F8E0042; Mon, 13 Oct 2025 08:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E4F128E000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:57:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F51557946
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:57:58 +0000 (UTC)
X-FDA: 83993093436.08.7E62E10
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id EAE21180005
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:57:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F+YZQ906;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760360276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2X1rAysbW3qRv0FDcYzeN0+jhVsKtG5ZQMjaXQTtjU=;
	b=F7IEqskTyCSwuPQ/olr73IjyCCTQsxpbsBjnNw03W0fc/asK63i9fxXYyGztpabuRFDUNv
	aKIgmEDWXZV04uA+hRvZOPBSQtMM8fHNMRrQh0psPSfFvXcdEJAj0SlW9BqpV7xORe2hxy
	skDrYVCihDWuGbtsLrk7G11N37RMqxs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760360276; a=rsa-sha256;
	cv=none;
	b=6FQPp+nl2E5JcOKbqv/opz2jyl9mFTZPerN51k+c3zZuNi2epdEMgB76ML+AIv2VyvgVBU
	EFVtu1PWigIpcshuO+zU9zhsHbDXZkzgymhtr71gzLOISL4MbAoQ1wlX0vjIXYDS2kDhli
	+twptirB713J4bo72OIUtcgvN+IKtqM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F+YZQ906;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760360275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S2X1rAysbW3qRv0FDcYzeN0+jhVsKtG5ZQMjaXQTtjU=;
	b=F+YZQ906KZTv7+WwvecQjKOySi30/SqVIFxJ3D9PosnPaVXtfGq71P1tp0qyr5Jm6TOQcc
	4RVhgCFsrTY8QOh4fk/s7gi51fN7mz8+SGUUVU5qW4L8LOesakSoL0bhMbBm64R5INhFM2
	+hvDBoMQ3XocvDsOpPzksU0GLQNN9DU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-k5e-fnA_OXOFZ6lSJaydMQ-1; Mon, 13 Oct 2025 08:57:52 -0400
X-MC-Unique: k5e-fnA_OXOFZ6lSJaydMQ-1
X-Mimecast-MFC-AGG-ID: k5e-fnA_OXOFZ6lSJaydMQ_1760360271
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ecdd80ea44so3360091f8f.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:57:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760360271; x=1760965071;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S2X1rAysbW3qRv0FDcYzeN0+jhVsKtG5ZQMjaXQTtjU=;
        b=m7bzUzmY841KL7hVZN56+JP1x5hm4WBWwsg2iB/l4PRoCe+hL5Fv2E++KMFc0Sz1pA
         Fp++56gPUj8TDZFjIO4ZYQtZzqkW66WKGE6SqzYvg0nix/65Hln6K5b96IDzJVQ7K2H0
         OqzLrTXLfvIJPj75SWPr8nN3lps4fk+GLr5EmUxaMt6PKbnKY7Tot1ahfW1S9gpGaesm
         dNQeDadBdqDM4b4lAKYZT2hBNlgteTyXO4qpqPzXffyUQufEmBFF0Pe9cAyzGyLHr035
         ZAuNfepo1dVEszsw2LdNN42gwKsdRPZidbqILZksQlGvXX43DiF9n1K8kjorfqWxNIfe
         bMYw==
X-Gm-Message-State: AOJu0YyhEMbVVhMLGTqXtQ0Pr+LAECMaaqaaS72fUAZrbRdZ81o599L4
	ctGr29FS4ZCYYR8vt3wps4Xwg6p+40/EB6B61L0TlqSBCYU8Mj7/8XboxLX5V441lq9r4XWQx1e
	g6Y4hsFnJltctgTtoLHzj7nNHt+8WaQ4DGbp0F2Zr2FCVLi/ymtCV
X-Gm-Gg: ASbGnctYPMy5AcC6ZKvxcehEfWcgpS5uomnMzElWkQNnmEK01HplKOEwrF0/a/AI4I4
	G03Vvp3kh0OKgh/RJ9ksMDFP2PG7nC0ZQ4CzXayUHe2EtRbrgaFKFuz71g9RMNKSA2SqssBF2W4
	1qGfnAEGX09mSUuoz3kSICwrI80/Yw33RkDFj08RnAVVUtG8r18Uj+KFTcK8V3KUi/Bnm2Cby25
	Z/dN2xAloKDImO1ILkHoN3rnhnwQqKtYYeQloHod6/XOnyHnV6P051cvLk0rgKUDSdiWicvt4nC
	3HJIG4fP3PTaGHp57d6LCWTnso6w/1tqThUTbpZ/b33HzfWOfHyxrlNOXUeDO0laEa+N4cNg5aP
	yLcE=
X-Received: by 2002:a05:6000:2281:b0:415:24ee:60ac with SMTP id ffacd0b85a97d-425829a5a28mr18102827f8f.5.1760360270936;
        Mon, 13 Oct 2025 05:57:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrIE0gfv1NwxEHgPUewpX6QcweHZ5uv2XrsL35segaxQ7rc1y0DSWMlYVC0Xyyxj8iWo1lxA==
X-Received: by 2002:a05:6000:2281:b0:415:24ee:60ac with SMTP id ffacd0b85a97d-425829a5a28mr18102802f8f.5.1760360270582;
        Mon, 13 Oct 2025 05:57:50 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce57ccb1sm18281426f8f.8.2025.10.13.05.57.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 05:57:50 -0700 (PDT)
Message-ID: <c4f22b64-b3e6-40e6-8a93-0c1071086825@redhat.com>
Date: Mon, 13 Oct 2025 14:57:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: only get folio_order() once during
 __folio_split()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251010141142.1349-1-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251010141142.1349-1-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: olUjLurX5XbnAEtlbASxVU3Vtze1giFwhG2Xo2cu7HQ_1760360271
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: wttp6uqehynwnxcixx3soj4uxrxm1es4
X-Rspam-User: 
X-Rspamd-Queue-Id: EAE21180005
X-HE-Tag: 1760360275-710555
X-HE-Meta: U2FsdGVkX1/2eq50s7WP3kjY+VRTidGhkN/6UTQuALTbSYZSmvyQjvttu+vMyXQQ1cRM+PVfWkGJvQPNFQgSv7jVHUshRRuZOZOKRJxsugYK9JIOE0u3mm+ab67Gm80Aq5sKPT7reYUC9QjlPco1ZaqtbAnY5B7VP63CAeosvBes73816KmQRjy5RgiuYNQbMkYzz/0ncXgNpVQFoHVLXg03v7r7WZlzx/QKt0fmMkWTKZ5kII4IBrJyicpGC7ZxBKwaxIap80/yJw1xxjCXQJOd3QTNEWqhZp0j3T6lgi36flnKBXVE5/QLYmIU/8mT/6RVvbnQN9RxYqqJ18/KHsfLDLohqaWNeFDo/EUzAJ1oMAo3bNm6YSQr4p7qrSJTqKepgQ4uifG5Bj/wzrhGxsUMCDuJ2EUDTaSmgvlnp8Xh6NoDD2tUfo5UpxpYX+OhGls9IhXOKNvoUA5zF9mL8hbDkaa6rjLr1Wxagse7t8P1m/dMBEjn3R39m6CYZNacFAnn+fcRk+JCgVzVhtLESpiim586DkE7W9jeGSDyk7z4iCHtVQ1rh73cLimGSx6ikhqsz+GpGTaVn7Q0K8y8Rl5/T4v1AKQNc3f2vO15b1i68ILqVQwuPpPC/BjnLNQb3Yf7VUccohA+DpW+EF2Pv941c9KP4+9IcyqkwKqI9jJBY4DKeGspa7lFNJIwhR9zUNtEuu9Nlyf0dlbpr1se2z8Y2QPvm/L+cwU+QjfYXQx1yXt8NKg0TMpYUQelBqLj3QxFxfT+FXXBPdL4rAm+fJxjHgHK8+XBc+ZusAxLrZh/XY+slvoNBke6/x+w7uBPPv7rPELz/yADgCDC172vn5LloB6Es7r14rO/h8NwwpTJNdJFyb1kLDciMeh/UKTW73lqSxORnjkuKKjFqF3MSiWYG41pEgSegyWeEl+bSgSumg92vu3AlTr5v3cUTiRXd74e6lcBUwczQRoPQRc
 nPw+eJf/
 28EGtM2hQ1bRr/79v+qWZObqZ2Y+94H2xOyA1Y6Rg+/fsQok2wHfCey4ubHX5NpkCutexcVTuSMQu+76aKoD8EhrvjqXKRpKGE+M2ay7udtA15lRKjqpJSiryXyX+xFwFaFa89PXM4FOwlRJ3631WLKMBFQkIZjOdkfLGzN3ff6lBpypHFBUSO+beaOcgw8dS+txJx0n0jD/XsCavaQXcpw5GHvMFAiqwVlPVxpNdy/SkVDNWg7VpEKVSWf3StdQBlv9siBBt9i73xV9vYSOYcHCITEzdPC0D+YGVdQehlLb/BOIgJO5yixBGTCyJ8exdmxwaWXXGOZz8wLZRHKB+54SZfkfcBbDEOYT+Pa24Y7bj/tKaHZn/n0+A1HZvjd81XTOEOLXk54BYCB0nVndpk85fu7QRC/I2LCquhuRDN1cdEsBbgQ5cchuj46UJ1XDlg7C0d23TXOzfQjcW37RfPhvHqikQEbWKboQg06BDjevqE3MkWRQGIBsSxmvydPJC3U2LuWQCVbDaZcavl3uyGqjRcGfsDoSNGrDIq49g5UCzjDTjf/TNe5zz+EL2vVDAJjtzwoTHEBPDl2i5nRGGrcjAHRxd/Re2BagSgZBhL6TkNccixBD/XpGAdVYPxFb4xCLklnYSi9WxR+8vwy2UqoVWbA7qzi0eudH93Qk97bSWbfoz/opt0jk7spVA1Hx1kYWRbrL1zls7c3OY4q/URXvmdQt5jzLeCheChKuo0R592YHy0hcxXzeqxYn7+nETJs1n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.10.25 16:11, Wei Yang wrote:
> Before splitting folio, its order keeps the same.
> 
> It is only necessary to get folio_order() once.
> 
> Also rename order to old_order to represent the original folio order.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> ---

LGTM

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


