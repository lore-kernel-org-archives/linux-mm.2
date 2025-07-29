Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BDE4C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 12:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDB128E0002; Tue, 29 Jul 2025 08:42:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2898E0001; Tue, 29 Jul 2025 08:42:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA1C08E0002; Tue, 29 Jul 2025 08:42:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A7C6E8E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:42:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A6D658B5C
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:42:30 +0000 (UTC)
X-FDA: 83717265660.26.9881029
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id AD2A9A0005
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:42:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IFGy++Nf;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753792947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WcjMQQjDSdSwY1RX+LoRs6QbfJmy/6ykYqRqkN1o+H0=;
	b=psnMTh171N0GPLA9vZf0nJnm5iPTc0zRQf8mFXzmSEJQqIEv4/ZX3FKwo3Jj2dql7CCRv2
	+ut3YN7rCdDtB4lzGFiS7dNmoiCzXanAFhjvfjyf2an11+OCta2TeE960SZEuPQgKetpeg
	OWK/lQuhEy1PiWACygOXYKh6cKLZeEs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IFGy++Nf;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753792947; a=rsa-sha256;
	cv=none;
	b=lwhqej3e/qc0BNa+QtkYTK6WLYnVZxFEP7Oms7EoRRbmpAI7rDi5BMPM0wq84mjsTZLapo
	Nhm9Ma4cfJsiBtwWyD7ZYPJ6Nq56J1A1JpJXc90ZNEdUaXcC16SKbrYryWO1QPF+OpgVkx
	PghUJS0VutOxiEswrHjWkG96/Owlw1Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753792947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WcjMQQjDSdSwY1RX+LoRs6QbfJmy/6ykYqRqkN1o+H0=;
	b=IFGy++NfF2ckXOMUUOyQC73pF/U59wKxzvwa9D2qsDsl5stlRkLTyjjM8JQ1GwsMMPmLTd
	qhNTIcDVWhij8UuwwLyZ9V2H6uq1PCCYXo3+hNaGbZw6iJ5hWt5FbUwfhAX5JKq5dzV6SJ
	8VrLvh79BdO3Y1Ok4a5F4evumT9Kouk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-OVDdrVOtOnmyKjbKU5XhSQ-1; Tue, 29 Jul 2025 08:42:25 -0400
X-MC-Unique: OVDdrVOtOnmyKjbKU5XhSQ-1
X-Mimecast-MFC-AGG-ID: OVDdrVOtOnmyKjbKU5XhSQ_1753792944
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4561611dc2aso40481745e9.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:42:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753792944; x=1754397744;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WcjMQQjDSdSwY1RX+LoRs6QbfJmy/6ykYqRqkN1o+H0=;
        b=MsYj/dix8NH2fIZA+5Na3IwX23zuIXH0AX5PdmKEGX885kjYvaNA14YVqyBSCIX7qp
         VNOkp8RZbm5gcoo6w8kkns7wUB/oxfXvd4RbgTEzEAduiaz0yi3If/Ka1N/fIkhSjcyu
         VwXB1lJHv8Z1JkG6w4cKddz8EAwd8/Pip8A4bbs/3kNvoYHl25nvlBy+ivmtBgrAP11r
         DWlOxTtDoJjBy6e1z6uuTx136zIwdjp3DIH+Fufcf2fwJwhnJYl1SLQuWZbVnpuiah/d
         KlsAMgQbPtC1UrJ4o6PTNHQO9TJ9rxWImK8a8xKdKHW9mOssmO+KFTenhFgSbU04S6PK
         3itg==
X-Forwarded-Encrypted: i=1; AJvYcCWfD95NKRfzJ/hms+qdq59fJkFnY17iZE/K+9azKRtXU1M65oynroIV2qkK/X16ErABsZnOU4u8Cw==@kvack.org
X-Gm-Message-State: AOJu0Yxt1/IR3lvf4/3b4oZns1GR6lXappAENqN5MA9IrC1kC3Awdkmk
	Q49rKVVsbLzwppupfkbDNPOrSB1zCT8qk6MONVJCJwMZaxRYrFdylqmzTSv2si6VnkdUQUh+whr
	bFDCJWdQ4ehrckNPuiEoWaFbwLMGdlind+7VWFuvi8O5Ep40vgL/M
X-Gm-Gg: ASbGnctkRj+2KIpTQo2iO+3RDruMV8zjhTQ2e2Yl0zaSE+3P1VnEG+6jNDiUlpg1Od+
	1BJPt0IlMuKiZajJTYkLwgWqDY42qccbVekMQbZ14dOBd/ZliJYsYtrGcy7QGGr/1RO7LV21cRF
	YKLEulosCVv8EebpiPTnfey1fEY+2HQwLqkYADI0dQG8J0Q22047DxJvmVHPwv1dpA942W6yUPW
	wUJRKe4FwSgzyxhxlClSIJSWs9UfORN6AmJqbqE3o4TltMqWxElOlSWVyjRPpiZHXRco+dexSb9
	np6LosDeN8XXleGDay6hz0ufgTV7tYdqoFzUSQpnXz82ccLZlI0e17wvT1s40XbeQcpMyQTb
X-Received: by 2002:a05:600c:620b:b0:456:1ac8:cace with SMTP id 5b1f17b1804b1-45889b30dacmr54719385e9.12.1753792944293;
        Tue, 29 Jul 2025 05:42:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHVzcw4B170O0ATQTmJ3dfpRn+oQ1lRRT7YNXe6J7L7+9l30GTFb5RPpD1eQ1esmhnAOVPqvw==
X-Received: by 2002:a05:600c:620b:b0:456:1ac8:cace with SMTP id 5b1f17b1804b1-45889b30dacmr54718925e9.12.1753792943716;
        Tue, 29 Jul 2025 05:42:23 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054f338sm190876065e9.13.2025.07.29.05.42.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jul 2025 05:42:23 -0700 (PDT)
Message-ID: <d66fceb0-4672-4803-b9c9-6b769ff847da@redhat.com>
Date: Tue, 29 Jul 2025 14:42:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
To: "akash.tyagi" <akash.tyagi@mediatek.com>, ziy@nvidia.com,
 surenb@google.com
Cc: akpm@linux-foundation.org, vbabka@suse.cz, matthias.bgg@gmail.com,
 angelogioacchino.delregno@collabora.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
 chinwen.chang@mediatek.com
References: <E70C1648-DDAB-4027-AB07-1C19B10C6AEF@nvidia.com>
 <20250729123028.1224786-1-akash.tyagi@mediatek.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250729123028.1224786-1-akash.tyagi@mediatek.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KDsSfKJKD1gaOFWF_NLXKhEF_SCX-NJGTjmxVmde_OI_1753792944
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AD2A9A0005
X-Rspamd-Server: rspam06
X-Stat-Signature: ob6ar1puwj74m8sekhuyuhmyd8w3oxdt
X-HE-Tag: 1753792947-847545
X-HE-Meta: U2FsdGVkX19jNCZhFTce7/1mJqAVJI0QqBgTS0QhgDhlGo6GJQT+7iafF4u1L3oNmw0L5COlwF6anJpRYwsJRlGm9qOCam8IONOhF50iHZq0kh9Es2NcJYozMBL5owGAxCAyag1DD5o6jEYEL9NEg8Org7PUduSzuG+2p0b1vztcRLh/XyLhymxRWkZtFuDUHBz34sc1bNUcahUse68mzP8/nYx3FXx38VI59FNowUCWpu8y9PjPWH2dZ+x9QcM80aoFbAhUFHUs3oij7IY/5zbUchkA5Hwu2xDnU5o23511nf32ybOG+QvyQDBqajvhT38SDOoqlP3AFhKPyayyt5jXa53a5O+t0+g7ACpkmu1BdfcWaweK/rsSCf8hnkybP8qny6Le1V+vSyoO41mBnpO9A4cuWXz64hLIZCRpK08seDmgXnxdOhH2vK+1nTwFvntOVkfYcgOpRCqCx8fBaOA5DDYy2KqRWzG2Zdx9j/q6YJucjvESPCWHw3gzoQh0lyUXOTeetgeobIxMcHF9JnAnmQWuU8FCBNSfCNfsB20GsMfmxPwJbIv43TF5sH8noXi4hwAVGgNBieB9yEu8ZaeHUObmKinqfTlN+gmEvUXK01YihxWzkLIX8pR6P4hyYQdm2RJhyQV+NMzKs6rOPn5fNHBN3DDQ/d0hD/14Y3b7N0eFgdNcp1wYDXUL7/PtAHvBYQGqk+NJcqi85A1G0vNXss0lQq6qSOyyXLKyRNWFKu6VAtc54ACfbU7kz3vduX4O+LwSpJnz5r8UrwIOWvxP5ZESc35F5bya3wPJ0hemHEB0o+nNC2alwuUzog5R9mrdCyzEYJVFQi+BbQXBx428DnEu8I+9TtH3jOgEGLo/cvoECyiVbCc3wt2KIGpZyxDrss+uQbHINn5gjjvIXImWNVdLl4vvWd8eZkLk8QN6nGqnIdvrhbwn/jWoSNdtQMLBByYrr3StnHvP7rR
 NPkFRBS7
 HlBJQeu4bUq+VrRy5E0H19Ar+EkXMieWDTeHkYMjIcuUQPG9eq8pFYcgXxxjZ5hWfHTkHMSxrnCXJzzvWW8Bh8EDohCHFOA/qFwLRGPTSnYHcJw/iBh5FEUn6t6tvHB6quHcbIH6iFN5sfXCSx9gUkR/RiAvP0bh0HfSKlP7YEwqWsTlhiNYwgUal9JnciSNNufWmyPWXlkhV9V8T55EK152II/kKhyroy0bQOXo0Pk3yNGAuBvEzfrwtRF7d0E8NH8PVdWiiyaLsimTZ18GNoxrPtGhCJdUCAxNEP4giXDIgvyMpPhAYijE6npjdZ177dKLaVtxUWX04Xe9g8qMpW2uAwbP2M2d88Rk5ySy3/WOD+otL5dVRyws0vKcplY6l6IKuEm7CkzeraJhEEs/RaokDUtpNQoj6xdH7y4QldRKTHVzM8wSneLdD67X9oKa3JYr9LC7S6MNvkUQsWeqUPvTmGegE2O/1Pi97p0HzMVpbTv81FaRIXOwYKInonkAOVFLWelRx9gHPD3n1fyQW2BEnAH97M9uNpJZrx7fOWPkby4UA/yf+HB7oQCTpm2XskVmgHqWqYhO9yavDQOlOF1OacO7YPnP/d1tTPRsB+jfCu4Ft67JmtITvfgSF6KXXmjIYe4QweeE1OrXaPOwRI6/VX2zg0yD/WTjYma9bqyIhlCwfJO9EfFL2m3ezEYxyiOYJvRJdDIuAqqg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.07.25 14:30, akash.tyagi wrote:
> On Fri, 25 Jul 2025 at 10:27, Zi Yan <ziy@nvidia.com> wrote:
>> But there is this known problem that CMA can fail temporarily due to
>> short-term pinnings. See the "reliable CMA" work (don't remember the exact name).
>> I think you mean Guaranteed CMA[1].
>>
>> [1] https://lore.kernel.org/linux-mm/CAJuCfpEWVEqsivd7oTvp4foEho_HaD1XNP8KTeKWzG_X2skfGQ@mail.gmail.com/
>>
>> Best Regards,
>> Yan, Zi
> 
> 
> Hi,
> 
> Yes, the issue I described is actually related to Guaranteed CMA[1].
> 
> I have rewritten our problem statement to address concerns more specifically related to the Android common kernels.
> 
> Problem statement:
> Android Common kernels usually have an out-of-tree patch to prevent file-backed page allocated from CMA.
> It allows some allocations which have lower chance of being pinned to use CMA to improve CMA utilization controlled by a flag __GFP_CMA.
> https://lore.kernel.org/lkml/cover.1604282969.git.cgoldswo@codeaurora.org/
> 
> 
> Additionally, android kernels create cma pcp list for pages less than PAGE_ALLOC_COSTLY_ORDER, but not for THP pages.

I'm afraid you have to fix this in the android kernels.

-- 
Cheers,

David / dhildenb


