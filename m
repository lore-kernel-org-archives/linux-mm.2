Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E008CCCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 11:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 469CA8E01BC; Thu, 30 Oct 2025 07:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 419C98E007D; Thu, 30 Oct 2025 07:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308FD8E01BC; Thu, 30 Oct 2025 07:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1C98C8E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 07:34:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF0A5893D9
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:34:14 +0000 (UTC)
X-FDA: 84054572028.25.41514EE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2DB7CA000F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:34:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XJcWVEJV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761824052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9w1uQN+XHy4hQ/YXkw4AP0gfZ9jwPVf23hTV0vL2o3Q=;
	b=YebF8whuyJp2suULE8V/+5sfaSp09Ed8kMjaMogvfVGyY06VwgWyN0sGzX+FD+8sAubiYp
	F6EPz07m0jIwmBlyqlnGyyrX61xKuTe4ClN1k2V7AW6mr8OlYRC5mBcLK5sRqirGjYKhwM
	1Om8UbpU7fxeTJvtuNgtgeP3I0JL7U0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761824052; a=rsa-sha256;
	cv=none;
	b=6IEybarGF1CXJnpXYemA8HorspMHmsncufO3JBwtI/8xZu2Xj2vWXkMfyoAUfYcWMGs2ip
	6lc2kse6z/MikYi78gifFn8X5auqabrjhr//oCv9AfFiV9WGtY5VVocrLLIExXzaFGiq83
	V/XqWN8nEUExPqaN9deR85YLUnrY+NA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XJcWVEJV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761824051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9w1uQN+XHy4hQ/YXkw4AP0gfZ9jwPVf23hTV0vL2o3Q=;
	b=XJcWVEJVuElPZ6tjWJHThoWdOCDDY9CGJQFMX3kAOc6kU4ugoSbHtmE0ogGPTX+QglxXlo
	NXbhlDqiNQDsC9l1KC5h0oHKADFYlI1dxco3UXxXpLpOG5ezZuEaNyoXmPR16bcJ0xiXXI
	bFINvRez51HQYAgkMcza1wOO+bwUXuo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-zYwoBNuiONa9w-Qn_azimQ-1; Thu, 30 Oct 2025 07:34:10 -0400
X-MC-Unique: zYwoBNuiONa9w-Qn_azimQ-1
X-Mimecast-MFC-AGG-ID: zYwoBNuiONa9w-Qn_azimQ_1761824049
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-475dca91610so3790665e9.3
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 04:34:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761824049; x=1762428849;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9w1uQN+XHy4hQ/YXkw4AP0gfZ9jwPVf23hTV0vL2o3Q=;
        b=gifG6OtlvA31nTHeYBHk131abxhX7ByO30TEyFfw0GTztFEac/R7Yb4PMZ7/xlXxMv
         Jzc9DlgcnY4x0DBkGBqgfcIQOuoedCoXHKvAJokhiJRRMH1d9foULzMKAUN0GSJuS1hn
         knltvr+4IO+lP2Y/GkM60pgbbVuIeWB1TEQhxzqJ2m/FzPzkuWtZ0jC/XhUmQTLiJZXl
         EFZMVuMek9Kl3S5Lq8ujwBhQpLwXPleTTKfFM38tXR08e8aRUxorWM2WJ8XbFX8Fos0H
         Gi8nJhoCJTWHMmY+NIZmCV4qgGehQXW44pUnCZABC5xKBE+dc7HXMNWp7bTrJwPVE971
         GvxA==
X-Forwarded-Encrypted: i=1; AJvYcCXzEtbxvgNt4U4JUEp69NEQIuLgAGsGlvUbBsMNm6+QL8DHcrU6XZgVRFyhRELiQizqC0W1zCnvug==@kvack.org
X-Gm-Message-State: AOJu0Yz6OdLKpB6J/MhVESxoUVG89zCX/YJSfxO/f+78F7VoI4mOiV7i
	psjYkYvO7luVE44xEMEI4Sd4NwBria7VZ+LxTKdLDmp8RCvOalq2Cq2b8ZgdFM4k+waJhLMum0Z
	3mslwW0LR+F/ITe1l9stCC0489Npr2jQM/CYU0ez9bqf98KaiHTve
X-Gm-Gg: ASbGncsMszPMisdgPc53yZ3KnK/dH5n37OrW2hGYbAKJS1aOxoMfgt7FHSx1ihfp9wb
	+vLMfJ0TFy9L0TMas1y9RnjmHNIiBG9joVImu+OoTSTr3Ago10+DYGbWt1e+9ANW4/4yTVcIUYE
	x+L4WFPjI8tCeNxtruo2levyvZPX9v4mkWhbsaWKJ3b8Eu+wbT+inH25SQpU2yNwREWHHOW+R6X
	Sr6/9zl97xGTDHW9p4DiMhFKPfF/MPncFtSm/bQFyaeHpx0mH9MN3c3pefN/Mnae1766ubhpJbl
	LTy+Cc7bDMurdgqhhFDnUhT9m98GPipTwupt8YhIHbvTmZQA7FKtR1PYqXrVlK5cGEe+rzYPdD4
	xVgbgfi5aRASnWgt7aAsom5QzclV30EFGOkg7RNRvpb67Q4Zh2fCzZt7G1rBVXHu4GKf1fqtx1z
	o2CG1nC7sduaZx+pO+aFKxN7qFRPc=
X-Received: by 2002:a05:600c:1ca5:b0:471:6f4:601f with SMTP id 5b1f17b1804b1-4772686efeemr32236395e9.19.1761824049092;
        Thu, 30 Oct 2025 04:34:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFiZFuRhX8Dwhv/z7p5mtCfdnZxWjcz8QOPOy9GE4BDcvy3635c3ogWbyAUBHwqCjgRyFyBPQ==
X-Received: by 2002:a05:600c:1ca5:b0:471:6f4:601f with SMTP id 5b1f17b1804b1-4772686efeemr32235995e9.19.1761824048586;
        Thu, 30 Oct 2025 04:34:08 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4771902991bsm63465535e9.7.2025.10.30.04.34.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Oct 2025 04:34:08 -0700 (PDT)
Message-ID: <9385ec9c-c002-4781-8f1f-a9eb29b2ff40@redhat.com>
Date: Thu, 30 Oct 2025 12:34:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm: change type of parameter for memory_notify
To: Israel Batista <linux@israelbatista.dev.br>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, osandov@osandov.com,
 linux-debuggers@vger.kernel.org
References: <20251029195617.2210700-1-linux@israelbatista.dev.br>
 <20251029195617.2210700-4-linux@israelbatista.dev.br>
 <004bb148-a818-43d2-af04-2f2ed85cbd67@lucifer.local>
 <f7dd549e-7dd3-4fdf-89f7-ef6993376809@israelbatista.dev.br>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <f7dd549e-7dd3-4fdf-89f7-ef6993376809@israelbatista.dev.br>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RPH_Q0RKx7nEo7drSOhQ2Icy53yP0OcXm8PtYcnZ46Q_1761824049
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DB7CA000F
X-Rspamd-Server: rspam02
X-Stat-Signature: o5pkp1bfkzqkrgqcwbqs7mfdrr4ei4wa
X-HE-Tag: 1761824052-617279
X-HE-Meta: U2FsdGVkX191i/IPQGy3fx82o15AD49xjlOcmxEYAIbA2lpSbZmC2bbp964Emr5Y0VX5Oby4WXS3Yf3RlqQhC94tGHgz1LX0upu8ZTG/1KVtvsMKHC3WB4Brue2bSGEpmyoEdKTdvP+RcFqxhmHzQ48C6wvcBgNji6O018sGPJfk5+Vl/24DCbmiSq1u1aW729wmM9JbDel3fyH4wUjR43tAwmA6Wo2MhkgjdZH9eP5C+6w236xmDvV3pTYFYW8eiNlbaHkfKYjlNRgotz53NHViptC4Ar+N9ghBY2HbMIkbEs/TsTf32DhQhiAan7zIcZGvctUyZLpkz9VQkHQ1XneeHn/barWewTr7YoYzU/8LDMAB42TxMSOdB6RaZaX/Qd0y1UDauU2Qsa8hltZdmbUmRGuyWwCnp594PE8HOZ8LiFQC2Ss8s/m9s3jVuxvI2esHTGdVNSI/gxGcz/T5FKlnPcbu3G/RYH7c1+giEsnCqBomXX143XVEnkQ7Q9X/dAtS0F7O91LTUtX+4/X7jGrJLuxo8EiX+Ej7TRWDW0a+sL8dQrLgEl0ALvHhiR7yQT3legbjwygMIlIqdazNvTWF/W3KCyaaeA2n7byHuvikTq7FaIgl9y+aTHvelpaYs/x/E2DQkO2ETlomCn0eE6tFIBO14WIlEdneVsWZhenoWed44UwClVNZ+KmJSqEMNO8xv/i4cEFqkuhSRJGtp0OD2/hefCy56LpuSbUuAmentupj4Yq/8H3Jpiy5z8jjU9u60+Uf/e8CaIUkMXZbDc61OQdQWUfMYmcCQtBNL7tUJKhegi06TqPkyUiQtyPxNhvp2WwerkVSughscx7v5b21ryAcf/3VN76TlQpZp+1/f35WoLhvky7d/r6S/Jv/KQ7/I/s4VVSshT3GFh98rYbds9ZqcrJYgO3ztlleTrX68TCoSZzdv6AoU+4csahvZbrzPIzGqtl0XdmirEP
 tsv21UC1
 NOhMQshe54Vfe/Bu3JWTMDvuGsW1P+npjtbfLtMjbVA74bTlFyQjj5NEF0yJAY64hIRC4XTraOxYNkEscjQZtXRgNZOHsD/wn7l4bzHszmK4ilZI6DW/SjHxTZOaJgU8baegszA4h44phL4LMsSnL4yjA8oK+kklBFMqghgB5UviIrQoQPTRxjdsZfjs6rOXrFk64OQ1x4E2BDZ7VryJBAM1FOFq5t2fy/4UiwrSQYTNE6fsZxZ3uJbdnDKCt8lohu93/L/oLn3woAR6Sbl8E0b852Ys0ewGx+R/0hZmbhI6DWFFmfm3NXacBghDfVtf1hfcQLgcq+T+96sWdnqPH/7cNvUYCyWBpGVco3jUKIbDflDa/DqeqaxuU7gE+XBxkF6a8gpcUeuDB537NJd49Iw13IvvNzp8jjNZ+x6X3urpltojpcFRKiZYlVKNfmOwP5VmQQyd4kH0vB+98CL2M0LtWfMhPycCjpUR7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.10.25 12:16, Israel Batista wrote:
> 
> 
> On 10/30/25 07:56, Lorenzo Stoakes wrote:
>> This seems fine, but I can see a whole bunch of others like:
>>
>> kcore_callback()
>> mm_compute_batch_notifier()
>> page_ext_callback()
>> reserve_mem_notiifer()
>> etc.
>>
>> So I think worth chasing all of these down?
>>
> 
> Yeah, I figured there were other cases and was originally planning to
> include them in the patch series. The problem is they are notifier
> callbacks and changing the type from unsingned long to enum
> memory_block_state would break compatibility with the type notifier_fn_t
> found in include/linux/notifier.h:
> 
> typedef	int (*notifier_fn_t)(struct notifier_block *nb,
> 			unsigned long action, void *data);
> 
> So I think it's not worth the trouble for now.

We could just cat from unsigned long -> type at the beginning of all 
these notifiers to have us then work with the actual type.

-- 
Cheers

David / dhildenb


