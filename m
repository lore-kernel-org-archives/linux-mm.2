Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF9FC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D3066B00A2; Mon,  4 Aug 2025 08:51:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083CC6B00A5; Mon,  4 Aug 2025 08:51:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8DCF6B00A3; Mon,  4 Aug 2025 08:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D7EB96B009F
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:51:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8896A1DA81B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:51:08 +0000 (UTC)
X-FDA: 83739060216.06.C029E07
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0EE26100003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:51:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="S1l/1bIo";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311866; a=rsa-sha256;
	cv=none;
	b=YyxYse0w8sfPnos7pJnxVGmV9+08ZtCaOdJfm9k91gssWfiLfclemZqSNwCRxiyGa4Ux+0
	uUWc/0Upxg7VOttbLthnPgrPNuUNT9LLigNEcORglHAjicXAKovgUuIo/570kGUwctuTs+
	ROuvCW+XDgqTWse9KNZ3oUBLYJKFjrc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="S1l/1bIo";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zBRal4xsaOEmUS6ItHYz2leZIyIcjbTf23K2YmGrEKk=;
	b=h/oFIfUIFvAsgbZODXFpNkz7jWbTPtMbyQxXI2IW+lfi6/sf+r8W9c38IEWCwnbmmhJYbD
	Jp2f2el/2rR44VQdh27vhWbpFc0cZGJkqa+f38gdOtOtKDZi92QF0AG2ny64/mE7yb5+Av
	kreZbNSwLZCatIDH4yY15zg5/bMnTxk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754311865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zBRal4xsaOEmUS6ItHYz2leZIyIcjbTf23K2YmGrEKk=;
	b=S1l/1bIoGPDAhrMiIWzVH3X8cG3Icp9I8fyktt2WbSMfBd6H7Ue/PWTiSqNMQYdCbC2N8w
	71wWN838qBljTZsvS3MOyia8qiLVE6zMOEd2SYK6B7Gs5lkE5C1LBSivEQWn7TXOdqit+/
	rfLebtB5VIxE9spZxnSZXVhDSbgwk+0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-7uCoPH1NMs69GUw0H1o7Fg-1; Mon, 04 Aug 2025 08:51:04 -0400
X-MC-Unique: 7uCoPH1NMs69GUw0H1o7Fg-1
X-Mimecast-MFC-AGG-ID: 7uCoPH1NMs69GUw0H1o7Fg_1754311863
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4595cfed9f4so4990705e9.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 05:51:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754311863; x=1754916663;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zBRal4xsaOEmUS6ItHYz2leZIyIcjbTf23K2YmGrEKk=;
        b=a1/Q9NY2gdNMKKOUczVN4YxQno4NAPSRr/UOnpedHCXpZa4zWZxMUCBbWPi3XXgpzU
         9o4k2IHyuYT8ElZPsWsC4GD1C/FiVMH/2xNj1SZKo2Z0x3q+tn750EkAhvFeU0qcHdwI
         XyYiOBY+vLRj2kGFOEVHw1q8tlxa1TQ0T7M/MrO659W3iLm5x+zhOOjmyYgbcVzrzRSy
         wH6Z6Jwt21X9w0rhJ14YqG2bpJNVhfPUYNc15AFyfn7cAvKfSkwi/JKyNMXu2bWLcWTY
         NoH/flHlRODC91d6diPY1ZYTKmsAAxir6FfK7YeGkm2F7pGUmy325AVSglu8l8dDjG5J
         QYjQ==
X-Gm-Message-State: AOJu0Yy2clcYZjLkeHAWwexAFx5fxeXuYGXnSE/84oZgpNmA1UkQJ34s
	UxRo8kCMXnIqNnYo+ebdDKM1RerXYErS2zhzXeBSBz8yjcgxiILdZc1+Vo52nFxvq+4tL4v2NgR
	KB7O4ztRq78es8huTI3obnYpsw3zCi0bH1xJby2THwdp1Nyrus0NSElPrjxhYgv8=
X-Gm-Gg: ASbGnct17efOX9OopZX7sZcRJt2+3njoZZd82Szyjfq9bRwmT0LicCsWRcDoD3FP/B9
	lzw43hPU/ns0Oc8noh6wM8Ksj5EKBTvdaD3q7UWNFEsA0A542u2WSzRylY1k1z96izH/Si/lAL+
	jxxCmOU2T9N4Lbhj6+sCjAHZJBl34v1hyBN2M873nPppP8yA6T5Y5HJ4zx+CTMsqEwpT02GwuWq
	cTX2eBVvW8puU5HVV7Z/1+9g5a33YJ0DPr3BJuU/ztyrLOlwI91dafSoPOChzMF1AQtaRTWp1sa
	Jjbny3uu0HUECAh9DLUcPNhb3sjM4G2zX4FZfSMbEwK+f9bHhGtNQuaS3NIYl0uCWTSkQr4wgOa
	7Ev8Ph17T/Iq+RaROTk1gYbReIXZt0rfa+7USienOyENXRsKrWB9GrbL1XtE9a2T7Co8=
X-Received: by 2002:a05:600c:4f09:b0:459:dbb5:399d with SMTP id 5b1f17b1804b1-459dbb53b86mr21230875e9.19.1754311862861;
        Mon, 04 Aug 2025 05:51:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDwnvqBfRM2yRafjOhR501WHdQ2r5zqZ1KQJbaHPA2Nh5YiknfB5iBnnN61Wrk91/G2qbSTg==
X-Received: by 2002:a05:600c:4f09:b0:459:dbb5:399d with SMTP id 5b1f17b1804b1-459dbb53b86mr21230675e9.19.1754311862436;
        Mon, 04 Aug 2025 05:51:02 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458be70c5f7sm80911985e9.26.2025.08.04.05.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 05:51:01 -0700 (PDT)
Message-ID: <c441e6ee-3118-4603-8c77-c5b2ef40982b@redhat.com>
Date: Mon, 4 Aug 2025 14:51:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memory: Force-inline PTE/PMD zapping functions for
 performance
To: Li Qiang <liqiang01@kylinos.cn>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
References: <20250804123923.296230-1-liqiang01@kylinos.cn>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250804123923.296230-1-liqiang01@kylinos.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nCzSuk5gmdOcjGUF6_2FsfX-45HTsnOgjWv_IcBdUEs_1754311863
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bine8tmeybuun5yhropkfdmnf17ode38
X-Rspam-User: 
X-Rspamd-Queue-Id: 0EE26100003
X-Rspamd-Server: rspam02
X-HE-Tag: 1754311865-653851
X-HE-Meta: U2FsdGVkX1/gwCt+KFILn6TX7N9M9Ck5v4jEkFnUuzOLi/qWNmpO/ruNctn/WHBEVpLgAVizwiBXEv1FF2x8C24epYhkQosLrCgKVlkeTVp5oM0fT1NXL1oTK2JmXzTkzVsnG5cFhOcKvpXGeUyjWE7j956zlIHyU6DqLVau5+c+du/BiVHOWErauvCX8tLK64+SRUX9Y/LOO4KgrfgkJT7D1+czsPiSnDdHILed1vP+KLrN5CpjkGfyqdPkFR4dVx83DJD+Dz0GxjiEedIiTdvklchEbef6QwI1UrghveE0lgNFlaPH5Kzcalo04U/S2aDc/Y0Xu5/oqJzQk8O1Dmpwl5z4dXDPpzl2Vuti+kKJO/6X7BmfuV238QnHBGien9ppRhNlTCH+YH+SZ2llg8eex+w5bU5aDKwZVCKzjyQ/DaZQBC5aIbn041+4QttF8vf3D1YwCYfMzECtRYHIwZ7zzl8Gf5n3thT8ABcWvJbAiDmfmQ/pJikYBvbBu1YlRY/Ot7/m1LYINLi5QSSB72MY/QPYS4QntfHnE1oPU0cwaqnExgAYbj7b1UgsVBBJvIUDwHJ/xpy9VFodXR6OYh9SRA5UbYYNoP74EL2txKzMCIMWo3JQUFvBw7BDl9OpOR893YWA718q3qCf5fOjl01jXMMiB9Nxsv739AAF3BHVBDXxPnnF4g0FmV3B5whrzbCXd7wcRJr4GCIFo1ClrBI/Dtji/n9efQF7XWEHkT6xVLchQ3l29fSBgAlJhukyAUWDUt5Rc3ztyPC+rM7JE7eJKsz7X/+j+OMmc2F8D+2I6Ekj5aYcESLEueFrq1lnW1nJLUvMwVbRxNynE+I0g/JjWVibGV4M6dmViBQJD1qV0Mjm9KP69qpDZYEnTQ0yQHn51v4VF5wh5bxcbWdQTSareod0+FB0UzTnwyN4DqBuZayX+2tKfdIV757BZCbwpNIHI1fU02Joy9MfKih
 QDS0r6l+
 v9CVMiq+FFQZ0YQNtMlCjSDrpmHkrz9Sw5CJAto9Fzo8MxVPKuycwYV5FDa+7W83qXhb4I4tpxoMk7uJJbMoSEwZtmBl/Hx8r/knv/I0S/kaOazlSToC1N0Nb31aADRvGp/flAdb1JOelmBWsTqWERer8Nq4FTEC17Tb+BCmyQ/EkKrUofxN2g49IgyClm2hj3/o7PVSaoWddSuPqStcK/m5xiJ0xurx+uPGCLSeosTR/7+9ywVtvFndOahWih3edLAB8AV5NGgCu5Ezuu3AGdypKMUoZmXR6+XaaiznNewu+WcFOTo5jJPOdOEOnd9cRldB99twEJ2nk66fUyZY3B3NlUExDQWaPv8bipJVUBVM6Kz06UEUfPtP3Tv1WwuQc7QlS44eTbZIqJMLQRQenQqqH5L6qT85xh7vdabcjLuyILuQpMnY3j3jGHKelQFNSJjs6PM5cMWUZZ4zmO2oLpuVS0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.08.25 14:39, Li Qiang wrote:
> This change converts several critical page table zapping functions from
> `inline` to `__always_inline`, resulting in measurable performance
> improvements in process spawning workloads.
> 
> Performance Impact (Intel Xeon Gold 6430 2.1GHz):
> - UnixBench 'context1' test shows ~6% improvement (single-core)
> - UnixBench  shows ~0.6% improvement (single-core)
> - mm/memory.o size reduced by 2.49% (70190 -> 68445 bytes)
> - Net code reduction of 1745 bytes (add/remove: 211/166)
> 
> The modified functions form a hot path during process teardown:
> 1. zap_present_ptes()
> 2. do_zap_pte_range()
> 3. zap_pte_range()
> 4. zap_pmd_range()
> 
> Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
> ---

What's the object file size change?

-- 
Cheers,

David / dhildenb


