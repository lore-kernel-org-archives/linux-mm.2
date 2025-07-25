Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD3AC83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 09:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5887D6B007B; Fri, 25 Jul 2025 05:26:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F676B0088; Fri, 25 Jul 2025 05:26:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474F66B0089; Fri, 25 Jul 2025 05:26:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38C236B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 05:26:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9138133DA2
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:26:09 +0000 (UTC)
X-FDA: 83702255658.18.A12BA49
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6A7E2C0002
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:26:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AKKJ7a4e;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753435567; a=rsa-sha256;
	cv=none;
	b=Ze7au0wZkddRKPYy5I59E+fj+H/Sk8Bz9wZiNNnOru/wo4rb7hr7xCGSb4xVe70aGbmZSv
	0d0Qf59CqCiEdDPAnl6OeUBf/HRcQa4bsVrLfgbXO132N7QdOQHAvKNUJF1g+hwd28B2le
	bVd6OSkBEGE3mYwty7FGzUi1bBNUYbI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AKKJ7a4e;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753435567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fuI+073QUV8TlKCpgSMthUFjEGfbNKhBcsktNU/kgXA=;
	b=OMFSag34ACmiQGEZYPl8gW3NMKNg3PW+jppNIiKzA02GW1tYCVlyJkIkqG33PEJHA7s5dU
	qPDQ0F3zRtjS86TEt8WwgoZ7MX60tHFBMYDIXcmQTrixGHyo5ZOyuK+7f89CRlPceTnRG1
	4P+THapbKB7p/6qUEH1J1gQVlHJ4itU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753435566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fuI+073QUV8TlKCpgSMthUFjEGfbNKhBcsktNU/kgXA=;
	b=AKKJ7a4eZMoX3zVvT/a3Cd/hgJ6YOlmLaK2GdNlgliq5Sucu7nWLTRnqRDJOzuUpTM+sEV
	tJ4PXDcgTgVgApgSqKeVdTbY/u23iQqAsV08LOPti35S9vquDUSTg6RW1znF2qoRhoaNo1
	Nc2LjDBaevEHoXCJMlN3HFTdrhbxDcY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-XqZIr9BGNM-O0XxroK7JEg-1; Fri, 25 Jul 2025 05:26:05 -0400
X-MC-Unique: XqZIr9BGNM-O0XxroK7JEg-1
X-Mimecast-MFC-AGG-ID: XqZIr9BGNM-O0XxroK7JEg_1753435564
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-455f7b86aeeso8806075e9.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:26:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753435564; x=1754040364;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fuI+073QUV8TlKCpgSMthUFjEGfbNKhBcsktNU/kgXA=;
        b=F1gsqXGrlBaoUmSe1PAZRKp6OD5l3gtNQFVDPq2ZXD9M55lsteUgrqRUVXFlpp9qpj
         Jji1fkcNloXVRtSVVf/6VW1L1Owzqt27cSQEzq+9NeBMP66Owx8E+fwzNQzE0ymo0fq7
         Hg7g/VK+r1BFpCa3bMwRbMSxj37CnkPd7tlGHll3bKqrk0FhpRHeuSM4tglzXCY03WR9
         eVUF1vfhq3TDxmfAWuqNF0IkiHCi90RBcYhGyMaEssxZI/TE8bYKfFjxPNpHURrxnnpA
         mJPnlHMCpwyWfMAZXL77/r4HNAOfhT9sZzugyN7y2Ypg1h/HcEbzj7RFOvpcaZg56LN+
         muTg==
X-Forwarded-Encrypted: i=1; AJvYcCU9DdDgy/BUARbHbBN+9PUXmlEvXFG69rvz0yXYh5VX35jPEbdnFHYEAYTOFxGxxr6XRWNwFNNlPQ==@kvack.org
X-Gm-Message-State: AOJu0YwHJe9KEtmffq1DY3m/ketaLCvqSUATmwVX8oMew3O/cm9Siw5v
	mw4XGciAlXWlCCBNfHzYgsDXOk2v6dWrI3q7JBjIBbUQZFXqvmHOL/khreQUCT00WfaIDJkSLOn
	+BjgKwaI3GPJkI4P0i339PC5JID3jISyMfImZ2ORjDtu54skJF6Dt
X-Gm-Gg: ASbGncsl5KDwnyf6Cp6dn9XmnPwUOgit7cd95viwroENIt7OlaZ6LgFjci5cETbqLwK
	ZqGFHpCE9jccCCc7FimtFHS2Tz444FWKfC4O+p27ErYCgZovTjpkpXBSe896DsVoXb/ALsXW8dA
	ai9slhBHjLh+P7dQwLMd9lLa5RznpIqa8uCK6bpJUcdKhC0GQfU6oANPDIpbGg/szvtEn5st0TK
	6uM3rzL7aLJ6kEUauk1Pnj1KxJxEcbMRGk8tesFZGHPMu3C/afCNzdEIlifVGNrwtNzQJKwcAAT
	6ql1hduhMzT91YA9sxUr9TGRjLHw0ss7YBwzC+M7zpwOgBsqSs9p1csCW07SMFPQu7yEzdX5v6f
	3kjtBjxX7ZQeLU8E1SwCgjKsnURk9UZbarCNJkpyLGkUIQMPqLQkNoEG28Rj9rg3++lQ=
X-Received: by 2002:a05:600c:358f:b0:43c:fdbe:4398 with SMTP id 5b1f17b1804b1-458786425d8mr3021125e9.6.1753435563957;
        Fri, 25 Jul 2025 02:26:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUt8YTfMy82kRyiKTD2nVMnZutqe5uKLRf5ukn85wELhiNYgYKzUj+SU3x+/UmHhtqJQUj7A==
X-Received: by 2002:a05:600c:358f:b0:43c:fdbe:4398 with SMTP id 5b1f17b1804b1-458786425d8mr3020605e9.6.1753435563442;
        Fri, 25 Jul 2025 02:26:03 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1a:f400:5a9f:b1bf:4bb3:99b1? (p200300d82f1af4005a9fb1bf4bb399b1.dip0.t-ipconnect.de. [2003:d8:2f1a:f400:5a9f:b1bf:4bb3:99b1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45870532baesm47811275e9.1.2025.07.25.02.26.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 02:26:02 -0700 (PDT)
Message-ID: <f09131ed-6546-47f3-aaa6-73962f117300@redhat.com>
Date: Fri, 25 Jul 2025 11:26:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/9] introduce PGTY_mgt_entry page_type
To: Huan Yang <link@vivo.com>, "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, Usama Arif <usamaarif642@gmail.com>,
 Yu Zhao <yuzhao@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250724084441.380404-1-link@vivo.com>
 <764c48ad-8869-4f69-898e-0a1c58684f7d@lucifer.local>
 <40cb7d64-0b90-4561-8e10-06a808a2766a@vivo.com>
 <87bjp93vb6.fsf@DESKTOP-5N7EMDA>
 <9a0eade4-8981-4379-8260-e673a1803d56@vivo.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <9a0eade4-8981-4379-8260-e673a1803d56@vivo.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hIW3sw00dTsQwDhqnzoy5lRovIPTsZcrx4XVaiWUphY_1753435564
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6A7E2C0002
X-Stat-Signature: ka94s6j97jnmk9rkot31ak991tgnzchf
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753435567-119267
X-HE-Meta: U2FsdGVkX19TvxL/y53ewGPUpGhm6tJ8Y/+br/LzjTbW2mloJMXaemvGMURHvX4HcazIWY5Cy0D2lraHnd2C9mqHmk7mdbYsliDPW9/fAe0XTnh4uL9LLFLWiMJe23MZb4iPNFmdNWxJ7fsqj7B61HaY/5oQzjWDfcNbYbI/ppuvNDVMLH4bN+snbuN8+qI3oQrOzNXR+MdoBXlyEAlV8Bt3OArgK2ZaGCDv9dyqHbvhz9tep4lf7WxImLm9gOGGP4+Y1+5LDHwxGmAfKHQ/ADgxf38BkWNePUj6VcVkZfQ+pzIl6Xvmls09T4JifPCsJs2vCH0wOqaqCI55L/j5iw9VmthBQ1QPf70K60dZiR4mx3+fJXWVcS5rWeU92VqA7lG9/2CzrieLwPT22Xykfeq4UTFdlkGYJX6KsPwa/P2v0hR2r3Av9ca5gwEsy8ePzz7F0tFiQHmVl1eXgv44ZJGhhRAgGiRxD2ZBAuadWKrmfYBCNpou+ytecfE7k0nYSNsLM68XfBuURk4aJEA/kqNyUHHDzOtleQvUMT/KcQPuXLl998ZSa/4eHD0ejE3Q7z2WgPIeoyPBLO8UDL4eAK1YenK+PBIXQDxHkLlrZYC+jPC5xDwBx1wCuAL7T8Wb28BkVS2IJcYqAOuQzuJW+yQTRCVPIKhNNhnqspZTv/sT5fQe7v6rhornm7THoAPdZGM0z+rL40m4Yi/ruiVv0bgKrawOiIbIvunAcicIc3LO4QgagBrMsFLHMcsZvAp120iwJe9vLPdNnjfcL4FDjjXhxYWuLTTaHJluGXBeXTDgv2ZO5zDtlLiWDiJulfBRFpQ+UvxgbVE6MoWJrHaAFb5uT5amumviyZQk+gWXGu7JRaCev9oH072kCFsBwg8jcGAiCqjk0Uyza65RhOA9agt4xXzS7Dd8My4XM9N81fr+WqfCNaHoaKtlk7p2ZIYE08iYP5q0lwbp7fK3Mwc
 hzAHZcoY
 mA6MuGrl21OenD0dai80ipDrEs1jBZ5w82yOPuy3s44+OMBq0nKnWnZS4UqUasGoSJSTZuynE9HOjGqRntjqBZB3nHPSOUZrqK8JrJt+zKmhavh8uT6zQsl2uTpiAK/rimhjUsPoFTIk574NAR2AfWIeaoCNwHuv8BsnOhO/P+MU+TcOHxeMahxcmAyXRabX3mQN8b1sx5M3tNTqa6yffC53V7AYKNqJpy/R+L432lsq/kI8sO6h+yx17dYg1yv8WVThb+hW/XGAixlODxVPew69CdXHGULAdOyp5GlMoTYcSx2AWUMEnt124oi+RiqxjuvZHbApmjXg9JIJ9zO2mA5SPUFDT8kVXSyKnUt1R2qnJV77V5nnbvycTptdWOGKmC7jPnAIUBK3eVvsmO2ePl8verKvL6QbXKbsKQiUTY/wk2miqBcZgvNJ7Ah96EHPjas1UhFhiFN14pSpQaO9K3GQWbB7OvPQvsXkKk6Dl7ODmNAnRm18e8akaudBY4988E0ilIffc3wD3xic7SHlW4H+zrETRiaQJl4xHwTWKOwjzMNpuL8A3XLZnne6lNkO0/ce58eJ4OjR35Dw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> If you cannot prove that the optimization has some practical effect,
>> it's hard to persuade others for increased complexity.
> 
> To be honest, this patch stems from an issue I noticed during code review.
> 
> When this patchset was completed, I did put in some effort to find its
> benefits, and it was only
> 
> under such an exaggeratedly constructed test scenario that the effect
> could be demonstrated. :(

I mean, thanks for looking into that and trying to find a way to improve 
it. :)


That VMA walk is the real problem, stopping earlier is just an 
optimization that works in some cases. I guess on average it will 
improve things, although probably really hard to quantify in reality.

I think tracking the #migration entries might be a very good debugging tool.

A cleaner and more reliably solution regarding what you tried to 
implement would be able to

(a) track it in a separate counter, at the time we establish/remove a 
migration entry, not once the mapcount is already 0. With "struct folio" 
getting allocated separately in the future this could maybe be feasible 
(and putting it under a config knob).

(b) doing it also for large folios as well


(b) might be tricky with migration entries being used for THP splits, 
but probable it could be special-cased somehow, I am sure.


-- 
Cheers,

David / dhildenb


