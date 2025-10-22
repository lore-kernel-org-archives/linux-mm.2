Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CC61CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30F48E0013; Wed, 22 Oct 2025 04:40:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1818E0002; Wed, 22 Oct 2025 04:40:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 982CE8E0013; Wed, 22 Oct 2025 04:40:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7DA538E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:40:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FEA25AF8D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:40:46 +0000 (UTC)
X-FDA: 84025104492.05.21EF3A7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id C09D94000B
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:40:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UE+LCqRr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761122444; a=rsa-sha256;
	cv=none;
	b=D0tWBtNXCiTx5RAfCZ7OWtNtnHLCVGlGc6srRGhgB//TRd+VrKLKN6QsEpioFo5j1NDUhC
	Z4Bd5YV7n8BcaGb0Osee+co74pC08/A6TkNfiHmoSAzj7CncSO/7OopS6CU788Ji++XLrN
	HS216pWAHHr64oMhT1t+ksKRcADwtSM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UE+LCqRr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761122444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IyII8qs2AWA9eUNKWYj/GrkMP/2s9uE4zP2DrnDC69E=;
	b=BCKqqxIuvQzkCEBxofFrm5lCjC+9/H0REybs+50a9F38MlLkxJd8OtJ4E20BUUFQdbMFFj
	9LoLIu7/SeEjfjA/pZ5LtZBU0/yHa7cN8+sFjzcGMX2lVfTi54eA7qObUffa7YFdNgtezQ
	WXh2kyxt5nbwPxvb2POQzXAY8j0YwgM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761122443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IyII8qs2AWA9eUNKWYj/GrkMP/2s9uE4zP2DrnDC69E=;
	b=UE+LCqRrpoJldId3xjqzDmpJ8YI+YChnbuFzsem2R6MXWkes9hAyhXD6Qeax/shau+dWxx
	DJ+QbacpDOO9Sqfqb2OxV9dPwonVbvhcixejX32Jxl9nOjAMjtQiWvd7Da2Vkxju6bZrO0
	ruURINO7C59u36tMfDEnds9uxJ0ax3c=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-6-2-1H_zOrSL_Hc9x7Cv2w-1; Wed, 22 Oct 2025 04:40:41 -0400
X-MC-Unique: 6-2-1H_zOrSL_Hc9x7Cv2w-1
X-Mimecast-MFC-AGG-ID: 6-2-1H_zOrSL_Hc9x7Cv2w_1761122440
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47113538d8cso37023465e9.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:40:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761122440; x=1761727240;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IyII8qs2AWA9eUNKWYj/GrkMP/2s9uE4zP2DrnDC69E=;
        b=moB1C7osFIAPpQC2sNLIugz7vNe9QdVl8BbjvrhP4+aXapb8xg7nx45J8qwNE4W6GS
         1MnS+fVmwSba6EuOLGWMWwFo4rCQsMyFmZEcBWly+New/6nXodJNjO9q05wSEodf/cr4
         Mtn6KcEEyxbYF/zjgV84AdlaT0NXzO2teX+MIvFHugOiRzXWEHAtvIX8edyjirS/td9U
         8HzTVuEaFOplMuhoNcCBu9eA3TixIKHCIzPNJ3zjKKJb07wFhrAOgi0kFSV1yGJ0801G
         rmQK7BcpUvHBTedovFPaSZ5FupFuv2LwbSUf0lnT92iIW3KLmZC5dliyRYA507ajkSQt
         Wm4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXd238of/3I6/QV8tzeK2bVFygYajHu4VYag1bdX04eRNyj3RYoLWgvhDGKs/paAItQaAXZqb33HA==@kvack.org
X-Gm-Message-State: AOJu0YzClDCIHXsT1K2g0awNZkQN5Ix2EFjQfOBQYxyMtDTR8zOYPfQY
	t+ciVO7H9ufuu/U7QehtDxypIi1PW80KQj2GMItgWO7ItGZszkegCQUvdf6Yw7WH0Pw0Wv0b5kW
	lSiaje4w6uVavIm1BNeLtCGAV91sxQ6EEDOjOWg17ExY6HL1hES59
X-Gm-Gg: ASbGnctAHQ9wUIeUbJ7M2tRmS8W3TlH78JrlJF+f9iwM4BoDYcD3b+MdbTSEZJMGJxQ
	7Dje/FxLkrP5EnEtwlIRjIIavsfSM3T+ZuewU+LzuoxWelej1hsNG1+81FkK7Pywkge+3YIFFK+
	63gonNFzhEq8vJsxEsdg7bFYv3B69E6R49hDkNouGpFyB1nJKFGjwoV4lBudvutCuETyOxQMrW9
	3HKmd9pZ4yfrCm7Dd3BM6xBGLjigxEd0EtPa3FVO3+fDfAQRdbm2Fz6uPA/ReF5NfufSBWid4Wk
	/Ut3JNcJAJwzWI+IKGY5t+LBLRL6wcde31oLHO79UBCtG+PXdNazS9CQ2huCYUkDgjZRFRSSnmu
	HeOY3rWVN1aocUEDIU8fN/vP9ItKBPZ0vlcGs4Ioez6IiZldxmwzClmmFxtUB5NohgANKL9DMYs
	5EM0JTZS6XP922hp4e1FW5pwX7K6k=
X-Received: by 2002:a05:600c:458b:b0:46f:b32e:5094 with SMTP id 5b1f17b1804b1-4711791cb4cmr174181685e9.32.1761122439913;
        Wed, 22 Oct 2025 01:40:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFoS2FDFL4u1V3mpEYxjOqKBNemC1wS2eap0hBA+VfSeySp1O0SWfSuGs5C/jtt/9Qw6UCYsw==
X-Received: by 2002:a05:600c:458b:b0:46f:b32e:5094 with SMTP id 5b1f17b1804b1-4711791cb4cmr174181335e9.32.1761122439450;
        Wed, 22 Oct 2025 01:40:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c4369b3esm31744665e9.13.2025.10.22.01.40.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 01:40:38 -0700 (PDT)
Message-ID: <99ce6f94-9b66-4d16-81de-8dd753a6d606@redhat.com>
Date: Wed, 22 Oct 2025 10:40:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 06/23] vmw_balloon: stop using the balloon_dev_info
 lock
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann
 <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20251021125929.377194-1-david@redhat.com>
 <20251021125929.377194-7-david@redhat.com>
 <20251021165626-mutt-send-email-mst@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251021165626-mutt-send-email-mst@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dnNgZmLyJHZSamrkKck0dD5E_-hECtwI6hCCjjCcAUg_1761122440
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dpm5t1yxwweo1edpw5ba4kqfysqkoxno
X-Rspamd-Queue-Id: C09D94000B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761122443-939867
X-HE-Meta: U2FsdGVkX1/13VZVlzZ9YUuT2GwpMetY4obb2+lz4OIIu//x5CXbBQ5rA8maRDMP7APn5J8xQIJ+7F2NTzGkEKP3rhxCyNDltarMFygeWhPYqA7iYZHzu1JZacJu5kmR33ZF7rCrwR8WCp8cJftVU2KUjhr5KtFWh9aq7/mwLcGnrN36V5SWh06ZHyo4LhbLn3F0ypVOHL3OO/NHhxYRd+bFhKKwwlDUqx3qohYItH12Gqm/pJDhR5buatK+0YGBzR1O/r8rQxHhons9um4dfiv7MyAfUXsi7bGBQvq7WQg2T2A5ILQoP680r5ujSuZlq95JqVHYievcb/Y9KzFYG22sN7HNspaHiceeP0jYd6aflJ6/k+HAOi8AJDbo6BVsRDTfWbBZtqosw9ilC3CPIZdwevG7mUtPi0utSVgAZxhCGVpF04mG1pEI+4wib2bjbeV2iFcDXHjbRsKsHpexN8ARboH4fI3HQTAN47gTBU7pEQJIdOQ8iUzLSowyaWCltVo6N/vG5VZDCsWNZ7HCj+swsiV6ailWCz2qentx+IjAqRJMboP3B9xDe5PKers1iqSWvFAMWwE3kMrTw1PqgiL2ztgMPQOHCHS+SEMIevCShL9xE7OApwI3M8ITJCGnhuvNlPbUEb8RsSj8UjGBdCFEeDofAo0r7zZA6+jqctMyMVQn1wlvu3d4cT4cf6EMUKVUCIyu9nQ8O1uYV7Rv1R2ZwgpdwV33NHlaxuBjpQRdCGYshpfXyiPjrmwgokFaDjIsUFbJzuraa1OUf4KzK4SISfIPjqwhLMl7wFqRzOUzbfGImbOMnzGcUOKCv/tSGOwHjzHUd24hOEoI11iFj7GloQPd3W+Db7iOwGNkZbn9/MX8wIhnxpQR8yhwEkODG3vHLUoWHcwX+mmAjxpDHPxW3IkgQ7Vylzn/npOZXjWlo+miAKUsEG44O/l5nKFoDrG+TBBVtQnk90ChDcm
 gtX/Lvwt
 7/XxL2QGclbmjWdArDDqF9EEObXRdmOoIJrVwFUA5NkZedlsgg/E3mOMbEuoYwBmN9u5ORjF7pw7uKxl7i6W3ZyPlemlO6eJZRyW4g9oBfD19KR39rnJ1s8y+p6f0TEWsSfJQ4GU27O4b9S25gSJTMniSmDk9/e8V7hxAb2IJLv4mwT55uzdtZyWutmyKFqpOgIPLr+PBuGNrbQlKzqg0yfwQuYV9xqgxMoXS9KnnpyUg2AMavxYgSUJNpT0gYha+oFzbgPw/kznJFWosoVp9tBXMsdkEo7KpSKgSCaIGIsnNJgYeF0CRR6JPlQmeDuRBgBknTtpYLezsfGN48lxLaV8MHHg+0N0X1WLMa2ENuePlRy7py2behKFsc5oIbwK3FDyBMNxxvbbsxCM7Kr214ojk4SCvjE0iYKCQg++HUIvWQ/46UK6DxilIWOwmDKSiyR18kv8Y+I2LHoF7qD3LihDk7EW7e/AZB0Jp+HqHYKKLaQMkGiUP+ULvm/x5d6bF2FQmOEv50GBBEmaEI78ly63m23UKZC+r7lPU7Fq8gNqdsPFz4C39+v8BqYbRpfuh9WQjsdXrU8Nk990PCM6tM27YxqhjnxPqm4O6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 22:57, Michael S. Tsirkin wrote:
> On Tue, Oct 21, 2025 at 02:59:11PM +0200, David Hildenbrand wrote:
>> Let's not piggy-back on the existing lock and use a separate lock for the
>> huge page list.
> 
> which is fine but it is worth documenting that we are also
> no longer disabling interrupts while taking this lock.

Indeed, I'll add

"Now that we use a separate lock, there is no need to disable 
interrupts, so use the non-irqsave variants."

-- 
Cheers

David / dhildenb


