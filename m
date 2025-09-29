Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B14A4CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 08:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1555A8E0028; Mon, 29 Sep 2025 04:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12CDC8E0002; Mon, 29 Sep 2025 04:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042A18E0028; Mon, 29 Sep 2025 04:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3B198E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 04:25:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B284E1DE9BF
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 08:25:11 +0000 (UTC)
X-FDA: 83941602822.24.3D832F0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 743E040004
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 08:25:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Vt/PZpZm";
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759134309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qftm91581EaAfNDOmtwxMDJauNlDbirPFRFWFFB7q6o=;
	b=VDJKA0lNVPZ2zyzpX1muA4qZ+pgec3A6EmycDcjZ6ZmNgk4oq4e8ETD7O4UHEFOT3Dfx0k
	7bmuMBS+laJu2REA99XEhwGJOhj2Bz7UnWUODdX1MQxbT0MmM6dMQi4zJdc9EqiVgZ0QxT
	k/RybBD2L+Lw1Tao/tTb/Cboc+U0ogI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Vt/PZpZm";
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759134309; a=rsa-sha256;
	cv=none;
	b=ZrBN6oE7Uj6blL/9M13yi+yNzJkMNGKUt8F53j7xZtGb7SaI7IfChytT+dGd88PLWDou1m
	zgoAkA8kNan+OKKosmUseyCz2HuDlWs7KlRiBZFw2jA4VyGnxsuQHNZ5PutZuH0vunvous
	njH0KYyLrKQOHdcgmo7pRUM5fYRq+xc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759134308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qftm91581EaAfNDOmtwxMDJauNlDbirPFRFWFFB7q6o=;
	b=Vt/PZpZmR4yu87C/1nzLVKDdX9/iM/HbaUllY45PL0FLlJsEoirNzlF6/nsHrlpGqjKeiv
	IUY9zBBZ1ymRjGLglfZnsxOj1d1ZSOuWVu325iCKY0dlOTFDCspZJd7NPkZl79FY2zEQws
	DZbGQ1oNDS+pzfnARH9zArmrgkpiUWo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-m_ki_9bDMaWlcD_cF0scQg-1; Mon, 29 Sep 2025 04:25:07 -0400
X-MC-Unique: m_ki_9bDMaWlcD_cF0scQg-1
X-Mimecast-MFC-AGG-ID: m_ki_9bDMaWlcD_cF0scQg_1759134306
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3e997eb7232so1854744f8f.3
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:25:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759134306; x=1759739106;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qftm91581EaAfNDOmtwxMDJauNlDbirPFRFWFFB7q6o=;
        b=odAOUtK3q3W2eh2/ps76ZY0J2B23J007jTN9J8xzRlrTJC/oybPlr7S04KUFybfNX5
         17xufUKx26UZ/BfSrMbSpefSCWetL9c/qZLsmTXWdHTB0278Oc6rPhNWpz/BZv+qcvf8
         0Q6StEobjPE/vnq+5kE4+MuPo917v4pqFgX85EMo/26B+jkvZ42gNJXNwyUHFfXviR0n
         hb827U0MiR8kg+x+N82LiDEQY4yptJk4aujCLUxkoMjSfFaMrf4CZEqdxFWUNL+XOFPU
         17cpYePdFWsatFq7z+H18A3EWhw4wRAM/vDM7DSh3sPtWWOkM/+Mff/X5YEORXwzRzKm
         u6/g==
X-Forwarded-Encrypted: i=1; AJvYcCXBBJFSszZVc6ARqwnMpPNQKNMr+Njcq5b0d4R49z/QWqhZc4W3/AxphGLk+sO4P0/+l53CuWlVYA==@kvack.org
X-Gm-Message-State: AOJu0YztuXCcJMJ4uHCzOadsh0zal5IDJWIlz1ThCYfoZs9QVnHrcIUO
	n/enHNd2rTSwOfCdEqErSckxHrL75hR/nW91d553osqwqFs9+IghsfTyFQRKutLzY5l1BMlq7L+
	nfv2fx1q70Cd8hVEdvZUwbGokPk8xUZYfrCRvNSU8luiZ2oqqfZCv
X-Gm-Gg: ASbGncv/tSoW20FHMJy451fF5QZqGvmYEx7NElSAN4bljOz4I1nMmk6p3//7C+NZS4f
	DzH3ozdFRjRGAO0p+SyyOCodto+kiA7CwP7tvpC9zyNTWQh3DgYb8Qb7X6+mk/mUanYLOzy42/e
	RZ+/oGA9i9ukjI+EVKc3nAoQ6TRl9Vz8bBxZryNdpIvfyuJ/I6tk7PH2+UGOHHKc/wQEEKVeOMm
	0tKzAg3DWZS5xXClM7uICquKl10A3uYqQJ1I/0vGqWoD52UjsW8YrS7D3xdcePlNJoyjFbkQgo8
	PjabxTSBhu/r5mDmH85wwStfU+MmJFE2caEsoOtfS4HkhXJkqOYOUr1i0K8JzWI1CIh0EPzvnKw
	TxH3KqNixjJXfVRX8QKYqocYTYKhkZ17IubsDmRAJUZbH8fQ+goZaOMuHliO+j+uySw==
X-Received: by 2002:a5d:64e4:0:b0:405:3028:1bf0 with SMTP id ffacd0b85a97d-40e44777213mr15960549f8f.10.1759134306216;
        Mon, 29 Sep 2025 01:25:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+vYzQqhrpkW89ERnZCpVU8TQtWK6HJfqpmqRxYWPjCycn7nAFgLLmckbyGJ/zKWnl9UC10w==
X-Received: by 2002:a5d:64e4:0:b0:405:3028:1bf0 with SMTP id ffacd0b85a97d-40e44777213mr15960526f8f.10.1759134305844;
        Mon, 29 Sep 2025 01:25:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f05:e100:526f:9b8:bd2a:2997? (p200300d82f05e100526f09b8bd2a2997.dip0.t-ipconnect.de. [2003:d8:2f05:e100:526f:9b8:bd2a:2997])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72facf9sm17612699f8f.13.2025.09.29.01.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 01:25:05 -0700 (PDT)
Message-ID: <e74ae9da-9dfb-4673-ae9f-c0b27b796cf0@redhat.com>
Date: Mon, 29 Sep 2025 10:25:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/ksm: fix spurious soft-dirty bit on zero-filled
 page merging
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: xu.xin16@zte.com.cn, chengming.zhou@linux.dev, ran.xiaokai@zte.com.cn,
 yang.yang29@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ioworker0@gmail.com
References: <20250928045207.78546-1-lance.yang@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250928045207.78546-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fR6uyfR1dNlgs3LVajx3lwaXLJY5e4amjoB98fWuZQ8_1759134306
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 743E040004
X-Stat-Signature: uu38oe17nxeobf83kg7ygkgj1uto9j81
X-HE-Tag: 1759134309-360369
X-HE-Meta: U2FsdGVkX1+pqJ2McTiV4neF8ZEpWQ0/xr2h99jQ44jChl8N7ohUI5unAO190i6+V8nohDRycipAxRZz6GimpAu4Mlb4B0c6YqWWEBUHp/335eSxnHdI5diKjBVwIprga+IiXl+2zqIGJ3YnWpWA0XAMLfKyPDg2TJtYOrWIjq9gHkp2lMxRLwmTvXFzBfNJBMuxKyeR0X5DRW4D8eNudwpsGgxKI+fEQV3NI2DJMoYYkmavArQo2hLIbAGpxLDnIXkGWY1LvVhqYtf9cwAbnAjW5nV3PlBnVGmFPCXGV+wPIzgFn+MzF4NiBl/zH/fA0NuVRqwuyYhlAzOh024O8yPwueQQoDYr7Qn+K7AD42OmKOnOrSnugAdHZ9qRIRl4fsNk2KHXQ7BW4jhmDivGFYPwariLxNNEi0UYOIAGyWQ79MlAPBRAaJyLI2+yabtVhJoHGP67+/q29JTOwiuxxqdiwdwOji9PxM7mhUA1EGDMKvHWi9y09tOvPsrzWsepziASWBO/J0oubrLueGGJTkT+udcjyDcIx8lTcTJVcYehAYSsnRmj/nRdzkVsSv6uxkUedLeMCY8FNlCQLl80WYIY/34RcMD3rJJNSV/LkzNhzWXVdqMnjh2zk5fFZGkCTHGPtoglztfphZmQPnyFakmcIaUAIBf5E+1ntGNir0CXKrpvzWdHi9ZKRhRd+FQ3dSzl5QavJ2qfSWb13HBcsIf0HmJr/fL6poZF7UtolAMfNS4or5iBaTeSvfVu0ssarxNNKykLG9eQOEYBRXSZEEBoL6nrt7Ethcn18TVD4RE3VMao6cE2k963dqvukQ/TCZRtqjtNoPnPh7qIQvDNLKwop9inXHC0k/VEN4agA6MnKmfktQcUff/S/Vc9LYLBO9cPRE3/9PIwO9XH8UWL0Y5xEReIzHg/zIXPLchjBeYH4/8mYJd+d5iMKQepqmcds3hYVkkpagei9svaUtf
 4S3gCXlR
 jjhe4TzDDNJ88LetgLRiqtTwel52OqCvTgRYUZMWhuYT9bAQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.09.25 06:52, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When KSM merges a zero-filled page with the shared zeropage, it uses
> pte_mkdirty() to mark the new PTE for internal accounting. However,
> pte_mkdirty() unconditionally sets both the hardware dirty bit and the
> soft-dirty bit.
> 

Right, that's one think we should clean up at one point.

> This behavior causes false positives in userspace tools like CRIU that
> rely on the soft-dirty mechanism for tracking memory changes.

IIRC, false positives are not a problem. We get them all of the time 
when merging VMAs etc.

So I am not sure if this here is really worth fixing. Soft-dirty is not, 
and never will be false-positive free.

-- 
Cheers

David / dhildenb


