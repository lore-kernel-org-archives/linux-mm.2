Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049D9C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 09:43:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C82D6B0093; Mon, 28 Jul 2025 05:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0496B0095; Mon, 28 Jul 2025 05:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58E906B0096; Mon, 28 Jul 2025 05:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48A056B0093
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 05:43:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B28DEB70D7
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:43:06 +0000 (UTC)
X-FDA: 83713184772.17.7BC6B22
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 28F8B140006
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:43:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gBo757Ca;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753695784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0nzT7thxG2Q5khJ7T1QqJPd4Hx2iM3VFFGAgQnzoXws=;
	b=i14lHyAzyA9/sCzTt31oNDZ33tv6oJ7OExyNVtVqhcmw+VZ4oMXw+YDd9udDUpy0LSGGMQ
	56h0VoTRT0lFuRXAlJgKokiNmyQaC6TwaX7p4qQ63zLx/LU12mh8DcRT0I4KA3HABlr+iY
	GHdDVz+ai6yEvQQgo0S13Fawej8inNo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753695784; a=rsa-sha256;
	cv=none;
	b=G4/x7sBVRRHpfTD1ko8tIbUDOJ0TEzpJBddo9b/C0vmwE4dMOb6+WhRpUe0YV1QH+qH4zn
	lOHkUmi02wwz1u2qDEbhMSzZOtEB1Z+DxpvrcbMlxF1lo5FYIT3/xQG8HsSYd9c6lE/UOH
	LMgD1jzUfg8B8DM5OnVd0iJTj5U6xoQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gBo757Ca;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753695783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0nzT7thxG2Q5khJ7T1QqJPd4Hx2iM3VFFGAgQnzoXws=;
	b=gBo757CaXoi/yG4JO0PqgIBxE9X+XfsJxZRIO6X0yKCMkzrnXEKCGHKjpWEFqYaC58adwP
	a/cgvgZOIxmzO/CkhbVpa+10nDxv7FhGc7Xmrwd9EWhqFlmPX0seTrRceHjJwX1hiJgA7U
	tXAjZecr6RDF/+5M8NWwNYLtsgPJkjc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-S2kUSaKKNtWWvDimVuoo7w-1; Mon, 28 Jul 2025 05:43:02 -0400
X-MC-Unique: S2kUSaKKNtWWvDimVuoo7w-1
X-Mimecast-MFC-AGG-ID: S2kUSaKKNtWWvDimVuoo7w_1753695781
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-451d2037f1eso23548985e9.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 02:43:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753695781; x=1754300581;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0nzT7thxG2Q5khJ7T1QqJPd4Hx2iM3VFFGAgQnzoXws=;
        b=a3tMAWb55JsJNQ88cFgac2jmaPDDjk+v5hRQs2YA7gAwNpZlGR5rMp5H2veblzR6jC
         zotQA4Dk/HZI0EZaVofh0e9DCxKOsbDpCKfoAuUa4oH9be0I319zmNqdiQr4Il56RQ3c
         h9jWmp7gsJhwZIwpNfICykXxWYFZPtlv1p9wanVZEEJWxcJQm5Uc39c6nMgK9va2BdQz
         UcSocDtAjm1PmfFbB1/jECZ6ipJNPhglD48Jmn2u6yAJeDjeIs6miJpHObIpX+dNO7QL
         bIPmmqp0s0DlRxtl+lhSKg/epDZB1J9OZXrT/rvgqqULCv79CPsRmbCVKbdVgbzL53HY
         T+Pg==
X-Gm-Message-State: AOJu0Yy1+JyONmcxhZSj9M7WnNpcAoK0Y1bblElCV1KB+1X4y+XB5M4V
	ga+XDN1xW0mk2rH5LZXr5gONlBSv6mM9SNBlytxa2kzInxT4xFhHoZc/DIp27p3JY9EHhdSYW5G
	+PdDHdPuxeant69xb/OSF45bYHVdqn5VSX+eURzMpQU3XmUSRlQkL
X-Gm-Gg: ASbGncvXBlLGxpq2M2lTp0XQfIsSxu4PCntdeyti0k9DOoCyfPVhwXxURXKuVkMwbvE
	00ODr1qxFBLSBcDGRr+fg12iQMXmvTH1s8L9OvD0pRiHMMcvu4l7XJhIVT5XBUh89iNHHlZOEoD
	mmCE0sZSMfP/NSpOpPaKge7ujHu1lCKIKrpe7rqP5MIGkxK6plZDbrIYvw7KGtYqSy3fKGlfJ20
	qUYf7c7f9SYtHOuR+KLmTdT7fVKC6zdV54DBEuAG+UfeDuHE0KifJ62QzoHRJuusI1cn1K3vfGP
	IQQsMrd1rVQD39CBQrNwLdYxSOM3C4VvZN3U/3xkFp1v3Ap6VF0AnTTdSkwO79sO/fN/VpyhIVB
	7nzDfFSJMxqvOc+KM8qZPMv0TV162n7a3rIRFZgXjZ6HdGa/MGPhQwCMvezCPq9pXX8Y=
X-Received: by 2002:a05:600c:4f05:b0:456:1e5a:885e with SMTP id 5b1f17b1804b1-45876303792mr101602895e9.3.1753695780563;
        Mon, 28 Jul 2025 02:43:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEingAcXyTOBXyXI2FH2HU1bPKlgnUliTyZ1KFbdz1Pmdrg7JnI9WdU+fqH+RQT9Lwk6ikS+Q==
X-Received: by 2002:a05:600c:4f05:b0:456:1e5a:885e with SMTP id 5b1f17b1804b1-45876303792mr101602505e9.3.1753695779981;
        Mon, 28 Jul 2025 02:42:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f47:2b00:c5f3:4053:2918:d17c? (p200300d82f472b00c5f340532918d17c.dip0.t-ipconnect.de. [2003:d8:2f47:2b00:c5f3:4053:2918:d17c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b781d2fc1csm6194995f8f.5.2025.07.28.02.42.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 02:42:59 -0700 (PDT)
Message-ID: <9e152d8d-4b39-4a6c-93be-694a28686c07@redhat.com>
Date: Mon, 28 Jul 2025 11:42:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
To: Hannes Reinecke <hare@suse.de>, Oscar Salvador <osalvador@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Michal Hocko <mhocko@suse.com>, Hannes Reinecke <hare@kernel.org>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <4057479d-6ece-49a2-b823-99748e8c9c35@redhat.com>
 <273a3376-c45a-4d41-85b4-9c4f3428f268@suse.de>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <273a3376-c45a-4d41-85b4-9c4f3428f268@suse.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Egj3zGbaHECW94ZbMsXT_Yh0nJ6aPEJzchP5YFXXAVk_1753695781
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6yiqpmqm6e5rcxfda75bjzfphimm9jmu
X-Rspamd-Queue-Id: 28F8B140006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753695784-950266
X-HE-Meta: U2FsdGVkX187LrcHDaCD+H4dCMoZquT9RjzKfyNKOuDUpdtkHU69K7THq3RYGYkMvn9qtLIVdXcPyKAjUs4q4fvbDD99XacCEFjnzTP426+KTcZCQZPOix/489X5tHaoIU2B5oMsFa2/IO8r6xfBJXAiny07H6buatxi2wAqNooSQZtPfkr28hN4OorO8yyAuzBg6BrvKkEWbtQ/+Z4Ghk+7r+++vFL/+wGjJpAEFkC82zqoZgkCXKFv1tjw9/U8Xy6l7cCE7xK3zFoIaoRgpI3H0ZskH8XUNFzTBrsEFqSCAiPo79o2mO6g07T4SZvmH0PkqhPqLIskZfyoDCeaybdBTTzW6doMVcIoSX8Jwp2japC8vBxgJ5BrqwhKWpl/2qFowtUTW2g4G6rcEn6gGINiZoNu1jf9siodjDBXN8Fc9kCw9gIF7x0lTWcufE2fxhVqquNIexz8mk4vfjXU1Q+9CYDCQy/mLBnQXWZbb+ggGkYQxKifhIoNjKnC/pIu/OImtO82gNRucP3am33IVPwWfudLu8f7bHdTqvN7M4AOBCUKjcGYWb+ekD1tqO2j2CrzGAZcDJSixbL1JF79KSlYCAwcQA+bYLvHcqGZSuDgtJxAtdJXltpkj1D1v9E7O1igUIT9QH+XvBZYxXxFfBqLClgivcVJJFRghS8SyMIX4YyT/gk5y0tYdF/k1CBUta2uIOrJyXJDryYfd78AK9LaI6pf1K6EPdBi8+psLpOZ0+48OtokLcPjtOgzjPzU6BkSI6hmCSTT4irIlq5opqfKfG/b0LueVYxuBGjiGfuAngAwWwcvOdcec0Z27rxzraHyCK24I+aMVLXkMGgcr4o6x6hWF6sSIE3Wvojf/PrydXNbp3Cm+2FUi59R77kChSQEtzQ/pYkULqecAOw9l8JMCmf46nYoqzenkHHWU/uymgcJGE82Wb/aYlE3067mp0o+NWNZCo/pB8+te9U
 f0mEwZzl
 7Zieg1l8ikJ76ulG1BcNIhg2uKXHfQ+5AUD4FsDF/IcKg7muStV9PajmgnBNnfpafcqyFFt1ve1mub7CZ49snw6pCkIcIxAdm6UqweBPxZgGd2P4Ybfva4Pj0oIwHAoVaHTGGB4ImAGupvESOKYBFcyVBVpuoOVo+Vfnp0B3ySZGwzet5BXqQ4hViHHGpZ2EcwU9WGojT71GR9hEzMo+gnnws8pZ9KTKWwP86RnBZhMDCyd3vT1ldd8gqXIP8hnAfe3KZQJYDvuVat38Q1SxJG/BqFHqYss3Js8/QRBQ3GUdDXLSaxlVKf/wEofc/3DNaKrWoJIhIzcwEuaGVBjapo2QpW08zL1ibauFenS56KmsnOkE4chYk1ATtqZ7wQ0SoOVl3INGybaGsm4L3apffaG1BxovLIvxhRlkfVMiLPl6NUt+sWmsgX/UyQSrusq4JidS3SjTSMvTLoALc+UjnfxlVMv9eRMfTTCIcy4Et9VOISG6wI6SpXm1u3ED/tQL6mIAi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.07.25 11:28, Hannes Reinecke wrote:
> On 7/28/25 10:44, David Hildenbrand wrote:
>> On 28.07.25 10:15, Oscar Salvador wrote:
>>> Hi,
> [ .. ]
>>>
>>> One way to tackle this would be update the ratio every time a new CXL
>>> card gets inserted, but this seems suboptimal.
>>> Another way is that since CXL memory works with selfhosted memmap, we
>>> could relax
>>> the check when 'auto-movable' and only look at the ratio if we aren't
>>> working with selfhosted memmap.
>>
>> The memmap is only a small piece of unmovable data we require late at
>> runtime (a bigger factor is user space page tables actually mapping that
>> memory). The zone ratio we have configured in the kernel dates back to
>> the highmem times, where such ratios were considered safe. Maybe there
>> are better defaults for the ratios today, but it really depends on the
>> workload.
>>
> Point is, the ratio is accounted for the _entire_ memory.
> Which means that you have to _know_ how much memory you are going to
> plug in prior to plugging that in.
 > So to make that correct one would need to update the ratio prior to> 
plug in one module, check if that succeeded, update the ratio, plug
> in the next module, check that, etc.

I am confused. We know how big a DIMM is at the time we plug it. I 
assume you talk about CXL?

Can you describe how that workflow would look like with tools like daxctl?

(what is a "module"? A DIMM?)

> 
>> One could find ways of subtracting the selfhosted part, to account it
>> differently in the kernel, but the memmap is not the only consumer that
>> affects the ratio.
>>
>> I mean, the memmap is roughly 1.6%, I don't think that really makes a
>> difference for you, does it? Can you share some real-life examples?
>>
>>
>> I have a colleague working on one of my old prototypes (memoryhotplugd)
>> for replacing udev rules.
>>
>> The idea there is, to detect that CXL memory is getting hotplugged and
>> keep it offline. Because user space hotplugging that memory (daxctl)
>> will explicitly online it to the proper zone.
>>
>> Things like virtio-mem, DIMMs etc can happily use the auto-movable
>> behavior. But the auto-movable behavior doesn't quite make sense if (a)
>> you want everything movable and (b) daxctl already expects to online the
>> memory itself, usually to ZONE_MOVABLE.
>>
>> So I think this is mostly a user-space problem to solve.
>>
> Hmm.
> Yes, and no.
> 
> While CXL memory is hotpluggable (it's a PCI device, after all),
> it won't be hotplugged on a regular basis.

I've been told that with dynamic memory pooling it is supposed to get 
much more dynamic.

> So the current use-case I'm aware of is that the system will be
> configured once, and then it will be expected to come up in the
> very same state after reboot.
> As such a daemon is a bit of an overkill, as the number of events
> it would need to listen to is in the very low single-digit range.

I am mostly concerned with all the use cases that existed before CXL (in 
particular, virtio-mem, standby memory on s390x, DIMMs) where you see 
memory hotplug way more frequently and also would want to deal with 
things such as memory onlining failing in some environments more 
gracefully (e.g., retry).

What I realized is that
(1) udev rules are not a good for all use cases
(2) auto-onlining in the kernel is not good fit for all use cases

The goal of the daemon will be to configure auto-onlining in the kernel 
where possible (e.g., only virtio-mem, only CXL), but fallback to manual 
onlining in case mixtures might be possible (CXL and virtio-mem etc). I 
expect the latter to be rare, but sometimes we can't make a fully 
reliable decision of what might get hotplugged in the future ...

-- 
Cheers,

David / dhildenb


