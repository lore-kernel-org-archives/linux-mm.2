Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA04CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 07:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 849CF8E000B; Tue, 23 Sep 2025 03:38:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 820E28E0001; Tue, 23 Sep 2025 03:38:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70FA38E000B; Tue, 23 Sep 2025 03:38:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5978E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 03:38:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1341613ABBF
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:38:35 +0000 (UTC)
X-FDA: 83919712590.07.B33CC49
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id AEF5D4000A
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:38:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G55dFHo6;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758613112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3+2f8veuvuQfgX39BgNLfIIBsGS5Oj+VIkm5FraHo3A=;
	b=cF3qj678RPaFepsmIe88h5cLrL4kGE8WF9o9OimQzaeTCZPYyknGue80fpY94WYc3CJKnX
	tRz5n7wojxlQIfYAZ500Ns1gHVQpDz2pVU3/h90ToXy+i+YDFZvIRdkkgkAgtAIJryItA2
	tzGmrZwhrXRuXD2PKqlNHA8Yw6KqGic=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G55dFHo6;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758613112; a=rsa-sha256;
	cv=none;
	b=Rae8CndSBghlOV2RSarkEYo78pYFM94OeOR/YDMrpcHygWMGaAwf1dOuCBb+7rqxans6sh
	WhhR2G3mnenGNhgYiXHjyTKtZIBAnfpn84C9/vULffa3fVfA6zsKLgHuQYXFebwRI94Dq5
	2yS4D8E0vLfZonEQnEdwgC7ULA0sLfY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758613111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3+2f8veuvuQfgX39BgNLfIIBsGS5Oj+VIkm5FraHo3A=;
	b=G55dFHo6ctzThsnfIIO5mPHVHt75sKGfzzXG6OiO6sPqUEwoKqz7iW7Puk6uxLvbBOIcSo
	h5NaiCRFs5ndnth9qQj7dktSVsF6QwEt/Ei4hrGZHcmaYLfMyP0cYy3QlNlYrMy6Wm2ZXJ
	goqh+Avmf6W4S0lwoQdknyr6F9Hi9YE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-vasX4v-jM6C9Hrg8Z2mt1A-1; Tue, 23 Sep 2025 03:38:30 -0400
X-MC-Unique: vasX4v-jM6C9Hrg8Z2mt1A-1
X-Mimecast-MFC-AGG-ID: vasX4v-jM6C9Hrg8Z2mt1A_1758613109
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4612d068c47so36656605e9.3
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 00:38:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758613109; x=1759217909;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3+2f8veuvuQfgX39BgNLfIIBsGS5Oj+VIkm5FraHo3A=;
        b=QifQDtNRgmOvpko4QkD1VNrtOEAbPpS0lvt7nVFuKnJYND9nCQTxteApR5BqbK/WyM
         ctHwomY325UGYUlgTf44lHHoQJAur8hmk2aKpLdpB78BYQhR+irwBq3LF+xP2ptQUrcT
         EKgi70H6IiAcN7LDu6MnUGTr9R67xLl9DhBgEhK1vUuIRmoEeWZfMKxob1860A+t56td
         /RFS7GD4Skt+9Ozjv4nGQ6SFV9vgLyJiI2ZbzPK6lXHiOw5HPd0Owhu3yxmoXKqTY/67
         mpa0XlvJnABMhLPnUBf1brLl3LEnDCUeT62S0jEdw/2y0NFvDQGrl8nAmjiCf2NeGqYO
         CfQw==
X-Forwarded-Encrypted: i=1; AJvYcCUYY71odFaWF04VTOehE21UGcKqPilxPq7ALehEiTJ4UQ9ofSNCBct9gKgfbONnzmLQ2FylOGfY5w==@kvack.org
X-Gm-Message-State: AOJu0Yw8vxMaf23PnSiYxhgjRNKIn8U+DVQs7WfkXnyGiBQFg432nc+7
	dyRHwkXS0hWlZkn+2NL3dNjiv9eqPcpsreA2qqdk02mWPm9Paf76PXWvlhSHywnYhXE2fk71nSp
	/UclYdDkB2zlZ7Fu2wJmPmyMtCaN4qFlZ41T+lbaY86tFwMqnEATu
X-Gm-Gg: ASbGncuzuF6kTTkta8E28kFotXqPB6EimrkxqfvstIiFMWV9QL+CJwTC8ysTzQllmn5
	b2AbRUm8KnjORh+GjqCMJY/BhltgnRThpQMEX1LI6F61+EBmPgELE9jtI7HyfA5ci/mo+vrVf9j
	upaVzwsNENdSM+gwHPpmNN6Izm946HyK9h3xqRVU5ZNZPa195C2YRNZ3j8RqFgnErukczI2DMTO
	k8VizKQZ59jSFzDGcIOVyIqoBe/1qZeEKZ1+TYV31fyPz32eWhwrImZh+WlOEgir8y7r4UMIKHu
	cBJ0phw8v0+T6VEYk1DmxHfh06hm7BF1hPjSNKvZVZfcLxa+P8wOodIIDrdceyk+PO+K7Ro=
X-Received: by 2002:a05:600c:3541:b0:45f:2843:e779 with SMTP id 5b1f17b1804b1-46e1d97a0ddmr18796935e9.8.1758613109150;
        Tue, 23 Sep 2025 00:38:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFu/BPEIJsCwjIeyZic5miWaKNTnGiC069S6ggfgPcy4CJzDTmfq1ehSOcS1TWgHULTVLA7jw==
X-Received: by 2002:a05:600c:3541:b0:45f:2843:e779 with SMTP id 5b1f17b1804b1-46e1d97a0ddmr18796615e9.8.1758613108774;
        Tue, 23 Sep 2025 00:38:28 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1fd57.dip0.t-ipconnect.de. [79.241.253.87])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3f9c62d083esm10698647f8f.32.2025.09.23.00.38.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 00:38:28 -0700 (PDT)
Message-ID: <8bef63c3-f424-4b53-9165-b9ad789f1ada@redhat.com>
Date: Tue, 23 Sep 2025 09:38:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cramfs: Fix incorrect physical page address calculation
To: Alistair Popple <apopple@nvidia.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, akpm@linux-foundation.org
Cc: Haiyue Wang <haiyuewa@163.com>, Nicolas Pitre <nico@fluxnic.net>
References: <20250923005333.3165032-1-apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250923005333.3165032-1-apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _jqlXLQgPaNXVHEwBp9Eqq82liW4s8d44Mog9Za-LhE_1758613109
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zeamd4s6u4tpp5wmydfkj4rih6n4ue1y
X-Rspam-User: 
X-Rspamd-Queue-Id: AEF5D4000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1758613112-824534
X-HE-Meta: U2FsdGVkX1/KzuJzHnupEtKgVh6jqkOEUpBzULJMk66EnJzQxkjFB+m55QcC4M4dtdHwX2KRERG70UaCpoRyd3/yqt5O9woJVcZf1cEAnPGOkYmDXZJfkC9FGRSPFooun8ln5HhXVLKLvx4u7M5Z1L8jTEzrbFlRsXHY9h81SOWNfZ85aZCqmXfc7ZDH4GiNLbRXfhpfZzXsJgHf4RpHah41ANYCYfbb4M/e8P5ETvGf8bfJmB+h754uTRsFL7XGeT5ygL+EPrE/VQDnmMG4tER5lzun5yeUWMxIYrpJtXbQcAPgWCDWHs4HdNdj490kIisIqV+Gi+go+nF8XYthH20GmVhzcfuFkdqs53yc16ywPvJxSKCSjWbdm1io1Or2EAmrJ+3l5EvRY604JhDIavujAktxhQOSkkE2YKXahtVLPSh/Pp9SrNP2gNBrA+GT/uLLOxZg5FydOTyHSxd6BNTrCaqVlkre4Z9PPJhBUxHJUloC4MIEU0qiYyRgfUQNwZ2O46tMxBBM8BE9Lkg0bYONKIlBAwOarkDf4LND2fKh82otfq5WDtZWPsc28Csy1nB0bDnFfPL6IN/+nZiRw9h/l8Zu843WMc45QrfdVCdyVodGVubLJO2/uxxOnSCPdDc+7j3IJx/hsQPBGUcIUoT7qZLhiPpZ9nUhuumnDKRdUndm0edosNSnCI0K0d2v20TCXBIq/IWuhKxdJiLOgBt7BBYcSKpM8u62u8E/qiKVWadEolzmgNgsNv5zktkeWFoTiK8VP/LQ4hdErh0y/A+CthSySRgsvdFOtCSk9KwvlX5rS2vbN7Z8aVjWk9X9gzx5WLuigMftPJbBCHvaFqBipG1a6MiSpl3WXHWnZNbBZHqUxh1puXgwGfXKN9LhLQzyaAFAU9E/69M/nX+/Wace8wYXcprwPA5gEy5fH9QRK43an9Jekro3aRdcyv80ldrXJElC3OBjwnKWp2S
 xmxILpWV
 +dPIgzzOncTZklo+SA3qeR00Cx8gmttOaF71gdYo8vbnpMgdEJBySEYcOG+K0I6c+lWAIrmVh0hJxldWp+HvGiZEoORHDGbs9GRkyH6y9zMRx6/nL11SnwM/HGULKQP/pG32W3hyq/gW3bZ8r6PsafGq97emk4dMqPgbSCRbUVTNnlhdIVczhNmd9B2tga8nd/azeHTJ7sfywfyE1PY/S3WnDod46a9m8/DJg2aZO4pQYqKjPMa9pOqjf66e2Nqisc68CpdGKpq4Sbk+Rdt/GnocKWidqmzdN9GOcnggWdY5sBSUj76ynPyo+4O5U2uiElO5x0h1tSSyzX17AABkIKLd3i3ccc7+qVuHL2gnz/XjFSQHAbQbhH5aOhyzcAaWyM8G25Lp/C94uyF+PwDc2GQD/nJtRqj7jD+IMldBwRMgHg8H+FH9tOT7RhIyoDaxKtQGfeBfe7yy6U6RL95uM2DTmP2yUpfwuIC+KR+M5FFRlJcoYorUtnXAjot4pXgmYS8Sx9WiojOP7KEJtsNnSDZ+urrHb79pGv33ht/0oJSscQF61cgDf3Eu/EoAm1f9vm3yrAHSWQxRoNojSyvrdI3V3r4HD9X4EYxZk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.09.25 02:53, Alistair Popple wrote:
> Commit 21aa65bf82a7 ("mm: remove callers of pfn_t functionality")
> incorrectly replaced the pfn with the physical address when calling
> vmf_insert_mixed(). Instead the phys_to_pfn_t() call should have been
> replaced with PHYS_PFN().
> 
> Found by inspection after a similar issue was noted in fuse virtio_fs.
> 
> Fixes: 21aa65bf82a7 ("mm: remove callers of pfn_t functionality")
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> 
> Cc: Haiyue Wang <haiyuewa@163.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Nicolas Pitre <nico@fluxnic.net>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

Hopefully that's all now -- scanned the original patch and all 
phys_to_pfn_t now seem to have a matching PHYS_PFN.

-- 
Cheers

David / dhildenb


