Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49405CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 07:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A29918E001D; Tue, 30 Sep 2025 03:32:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DAB18E0002; Tue, 30 Sep 2025 03:32:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A31C8E001D; Tue, 30 Sep 2025 03:32:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 74A7E8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:32:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18E72160627
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:32:40 +0000 (UTC)
X-FDA: 83945099280.02.88A6C00
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id B01B8140002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:32:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iFNYt0gw;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759217557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kx5kJD47lwmwEdMug0EQxUJ+vdmo/Qnc4VmJ84EJ4d0=;
	b=SAjwgsW083MHjQFK8GWYzj9hl6RDihpg4DZXgjpUpwBHZ30M5vkLVU62QW4MQZGCaBbdSA
	Wy04vVUarhhp6dqQDZs8G0B8MLCO3AebOsxZQoVvMTcn3jTanR68sXLg9Vf4jzryE1oGar
	K9wkCqzSsXz0/8xiArVB+GrYTN9/8kc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759217557; a=rsa-sha256;
	cv=none;
	b=XBWZmkpsJpTCM1ytCkLUE0/q/VB1P5WiJSqnKk8QGBQC2DkqnR1yA0VfmLSEMVkHc06maj
	sCr1VTGJr7lrU5pZVLoypIV31AbLkwtA+8dXVyVzlc8hHOOWWEdSCVMsAHU7/3OKujmS0c
	kqfezjImcm2F4Lsh3t+aEIzKQrfqC/Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iFNYt0gw;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759217557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kx5kJD47lwmwEdMug0EQxUJ+vdmo/Qnc4VmJ84EJ4d0=;
	b=iFNYt0gwLiB96AlMS4GcI0eXBm+z3WeBmQWgGHA6GvHtq0M4hLPNrBDF2BZH7gejjAkscC
	W5igCiII+/h/Qhox/2NOzTbdpfBpvEWNkBSnJ0Ot4+lOamwYFg3UQa65phOlkOBeqKSaUc
	z90OkFHsxxffAuzPsQCyBeVFVpSLbFc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-e-mDwHqOMsG1Qb-oDmThvg-1; Tue, 30 Sep 2025 03:32:33 -0400
X-MC-Unique: e-mDwHqOMsG1Qb-oDmThvg-1
X-Mimecast-MFC-AGG-ID: e-mDwHqOMsG1Qb-oDmThvg_1759217552
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e502a37cdso11822365e9.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 00:32:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759217552; x=1759822352;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kx5kJD47lwmwEdMug0EQxUJ+vdmo/Qnc4VmJ84EJ4d0=;
        b=lB7ZmEbFfoeQDPaEAFiNxkI5K3u5F3HYkhgFFYUwVdHb+HKkyYk/rEkvpQbTUsXCgM
         +9wDXP3G+0bCqawZzLGnO0Rknlt9qrUxNwu46mGbGRmtVNLC/KvCbvrpkCGMR3exWBF7
         jUUBPzvVaf4c7I2Nn1Js1cpx9SCeuNcuYpK8WNZsTaJp531dTtxOfVIQcRK1g4HramJx
         r3wktkqpfDSmsPuThGMW/uaa/MbJQVFUhU6VOSEiiAueya0F3J4Qq+gfLhEenNXDI1aC
         hkbIs5LP2IQNCdgWs73DzVhCRV8cNwzU5skVp71O9HYWnioE3U+cWgrlcZ4GIPC46Gfj
         TwZA==
X-Forwarded-Encrypted: i=1; AJvYcCWsSx6brlSNHdT+Cfg+FkOnRohFV7Z5B/hesbuKnAQ2sT7NdT99tq3pDDG0h/f91X10lIDM/AUSSA==@kvack.org
X-Gm-Message-State: AOJu0YwxtjE5ncJschYrjoUlebarWp7wpTLmCaXF6M/eJQSDcpDKJOTY
	zYrAgJ1qZ5vF/pmAqei1/Nkz6+nZAYD46s9T0chnC8x5sJ0PyuvDU8BHVYz3SRxHTLZfRnTvP55
	pY+CNytwzcAGCdqWa78k0ppQhdUGobW9zesguMRCw3pvwroj0IxNf
X-Gm-Gg: ASbGncsIl5aUmGQFLdYHRuXNhuhoJQ25d+PLNxt+TUWtN8iPB0xtlSXcK70UgoN51DF
	cI3l03AcdhqxlZlt9bdjOs2CFBWuxvXj+j+tfP4AfkPbIvn2jzV5xpVTSZg9Llixfg9miejvB72
	GVMD4WbwulQtCkRGN9oimqVVEq5kogtKb74BaFDSQ/sIWhWndWtShUqhj+q8zwbbrqW+2nXsJTj
	SLqQF2nZVFGRwWC4sklbPqWvf00w3j42NGLbFYH5YmXOSd7OozUs1VabZD/1g7e5dHXvQ4muKC8
	ZqgVNgLfbQCYW7SKK632YLFsubOh28b28wqfMKH0fBnvSHB+Cs5qtgIAvfA5LP4VrmByG2hkvor
	ZlarfTNHk9A==
X-Received: by 2002:a05:600c:3b10:b0:45d:f83b:96aa with SMTP id 5b1f17b1804b1-46e3299a5aamr165320545e9.7.1759217552130;
        Tue, 30 Sep 2025 00:32:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4B7drdL4EeWrqkWa+uMSppFVKBycAsK4wlNYE6Vh0G6TeYmxyF48M7zZXFvsuApXLRvCrnQ==
X-Received: by 2002:a05:600c:3b10:b0:45d:f83b:96aa with SMTP id 5b1f17b1804b1-46e3299a5aamr165320325e9.7.1759217551698;
        Tue, 30 Sep 2025 00:32:31 -0700 (PDT)
Received: from ?IPV6:2a01:599:901:4a65:acad:d401:ae54:edf3? ([2a01:599:901:4a65:acad:d401:ae54:edf3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e56f64849sm43391315e9.11.2025.09.30.00.32.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 00:32:31 -0700 (PDT)
Message-ID: <02c8cf41-116d-46ab-9d40-803cc26dbbf8@redhat.com>
Date: Tue, 30 Sep 2025 09:32:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/ksm: fix spurious soft-dirty bit on zero-filled
 page merging
To: Lance Yang <lance.yang@linux.dev>
Cc: xu.xin16@zte.com.cn, chengming.zhou@linux.dev, ran.xiaokai@zte.com.cn,
 yang.yang29@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ioworker0@gmail.com, akpm@linux-foundation.org
References: <20250928045207.78546-1-lance.yang@linux.dev>
 <e74ae9da-9dfb-4673-ae9f-c0b27b796cf0@redhat.com>
 <8476e9be-3f80-4d7a-9a38-f910661e61c6@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <8476e9be-3f80-4d7a-9a38-f910661e61c6@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: J3BJEhS343_dDWwJC1DRTUlDIVGOpVxpLqIRJgEgOLU_1759217552
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B01B8140002
X-Stat-Signature: r61qac84z5d7npnkrqh3um18t7praqyk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759217557-766435
X-HE-Meta: U2FsdGVkX1/hRMqxDdFRcxEcnJWGoJ1JnyY9NgOha1SP+B9BTPE9KeEgF8uzabwpIJkrmqHAq0Z+cJb/jdQjhGLUM8pSuPCnGxo9QemgQJjmdoDRa1hYhH5HSkKjg8ztsNM6kYASqa4s5ESFAAVAGxM1PU2OGxVvtMxOlx54jNJ7gQ3At59ARF1ehG5guCxSAQuspUJiJdCxi/i+hgsMDY7+oX5tszq1cLTg2FDhAxbhp+pt6wSLT+6s7Dlp9J9Yi271tS2ymO8DeyhMJTVyFBHS8MDIZ43ZnbEKsjO8ZCD1K/vzEpLAsMpqwCFznOU9OtiKgRN5JbqbR/bZKwbPUXXjS+o0KubVTOc/A4ZPHzw8gbQ0adnLTz3ndna6sOead+zU+Xz3QVLYS4w9xstiU+bBSrhoDMGL5oVW6Pg+/g3YIb/7z5NU3ag6R+FZASqR56dcl7H1gUQwIWUltuRrBCDc1V5Up0Bg3u6a0hhnrbmZTMT14L1OKJMoUk9YRsgTO1tKRFChbAw4NPCh+1h2G6bTzXqAsQWm7y2/qhfjxSQJvGN79FsKfd2E55jNE3Ut+nJ5aKuav2Jfn+y3y3A/As251LRYD9i0vK4KTtldyXnh8tIDwkp6fLcsgSYYv9GWHm7WPG/Qu3T+gH3nJACXBLoGl/zfMqBOfynqg1J7YCIVj+Z4KVTHQZ/VgjBT5qXPTT3YzT+nr+WI1Q/5m7vzmy6YjmyEcjgmc3HBWD5IoR/Y6eh3pODAtvC8AH4dTmzBS4eJ8wOYm/1hDUp402PbhQ8xMAGz2UDYdWcjm5m4rD2kgvhIJELuuFwIQn7n2fd1ToCtdXUkNELb5JtUk2aJOIcKa9OB6QprSCOzjteH9F6kijd3Ll6eocWR984SRBUpG8bKTqNN8MvbKgs3e781py3t4d/eueuKAYPo5fNo/SXjgKsYN5/GRh5/2yVdt4exu9FBSzU4/3ynRgmXN24
 Z4yGgNqd
 kKnnVqpwbZ0kZG7vxtOcxyoiYbj8usZVhlui2NQPncrqY8UhygppgwcmwL7Ip3xQhwX194P+Fy39X01pqnS8Mwx5bnB3R3+EM2+bVUieHzPAKr+47uQ+aZTE49CfSJ5JfsrUCw9Rj9OspYOID8oUClJbrGXLuJCpcd8IWqlv4lKKTA3vTiTrMwAiPo++izkKPE1tZpv05DHzJD7aFMQboR3+v1xakgm39vPM+PF/IPGbCCw2AmbAjxxRpW8C8SKzCF4sYvfU4bk7J5rfjRejw88PcC0qBL6XvBR3PSOlnbXVa7D0ImejU5FTFho1bfMcffoPZbRXe9GTBM5pMgZg4bGZfMmwwFckM2ElHV84PJPZJDKM0TQP1QNeLWfewQY9kAKCgI67NMXfCE+XuLlJdwbcsH40RUjX7I24t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.09.25 12:08, Lance Yang wrote:
> 
> 
> On 2025/9/29 16:25, David Hildenbrand wrote:
>> On 28.09.25 06:52, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> When KSM merges a zero-filled page with the shared zeropage, it uses
>>> pte_mkdirty() to mark the new PTE for internal accounting. However,
>>> pte_mkdirty() unconditionally sets both the hardware dirty bit and the
>>> soft-dirty bit.
>>>
>>
>> Right, that's one think we should clean up at one point.
> 
> Got it. I’ll take a look when I get a chance ;)
> 
>>
>>> This behavior causes false positives in userspace tools like CRIU that
>>> rely on the soft-dirty mechanism for tracking memory changes.
>>
>> IIRC, false positives are not a problem. We get them all of the time
>> when merging VMAs etc.
> 
> Right, Indeed.
> 
>> So I am not sure if this here is really worth fixing. Soft-dirty is not,
>> and never will be false-positive free.
> 
> Makes sense to me. It doesn’t seem worth the trouble to fix. Let’s go
> ahead and drop it.

Yeah, I would prefer if we can just decouple soft-dirty from dirty 
handling at some point. I recall I had a use case around 
PageAnonExclusive at some point.

-- 
Cheers

David / dhildenb


