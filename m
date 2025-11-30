Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F75CFD376
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 15:03:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 263D36B0007; Sun, 30 Nov 2025 10:03:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23F356B0008; Sun, 30 Nov 2025 10:03:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 151B66B000A; Sun, 30 Nov 2025 10:03:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 059D56B0007
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 10:03:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B25051A0CC4
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 15:03:42 +0000 (UTC)
X-FDA: 84167592684.11.2364422
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8887C10000A
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 15:03:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jmofuxGh;
	spf=pass (imf05.hostedemail.com: domain of ssranevjti@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ssranevjti@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764515020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=454k0NdJ//sqxnUnQcRzwDFYCemOmxV74PVkMloNpm8=;
	b=C/BvRHkCiEf409Z83RZK7o27IlqXhPWtf5s5m8CmmHsVz//NUCeXhZ/siXmyUIwflww0RM
	qBq+GB7PXKF7K/4SU+KaXlD0ThERALgjpIeV+IP/jai0YnQX0RCibkE81tXr9S8TF2GUtG
	XRCZt9aBlukGqxTUYf2kFPV38dvOex4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764515020; a=rsa-sha256;
	cv=none;
	b=bhwzIwvxP+YBH63SjVjSXbq6y7Z1TmH1FCrR6v02IlWs8Gfq9uSJ7COAPp4UqBJrF0XKx4
	wjwg7WUYcQol6CSxYhsqfZaREn9ZrplOK8RpRX1FYuKcnH6Sq2ES5xhdQvBkOVH3s1IXD5
	Tu7eLmJ8dL0C2+YU5FPpb3wWkj2IaOM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jmofuxGh;
	spf=pass (imf05.hostedemail.com: domain of ssranevjti@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ssranevjti@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2955623e6faso36048815ad.1
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 07:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764515019; x=1765119819; darn=kvack.org;
        h=in-reply-to:from:content-language:subject:references:cc:to
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=454k0NdJ//sqxnUnQcRzwDFYCemOmxV74PVkMloNpm8=;
        b=jmofuxGhcxCt3YhI54IiovOJX9bMUXs3DRhJjDM031rZ0eBtbCiehza9GxJlKbwPwg
         5Fsbx19kbNKLE4U1BDy2POo/iUnLfykGrH6w9jTn3XU3MvfWegLmbkebetKAo0ZTtVXg
         8dsQCzT87FOToSkKORcatU1lGSZMt4P9zuNaOk5uFA0CRJFeEild1xOSa/geB9Z6fT3s
         wRqqGB7pq2kESoZdqNGrPb+LTxZbIR1VlJfJN5H2kpEBkt/vdSJqodVWykgA/GdBo9EJ
         MPuly7A2uqPGqKYnrT5TclsGEjvdKt4y4ZYlyYEY/hybTOSO6IDC5fet8kPfRLSEZtAS
         cg0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764515019; x=1765119819;
        h=in-reply-to:from:content-language:subject:references:cc:to
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=454k0NdJ//sqxnUnQcRzwDFYCemOmxV74PVkMloNpm8=;
        b=ZEMlsoER5eEVGHGdVEFlgXFWR0/DnFN2YKZNYYPDfsq9v5GwdyyOHHf/fP6Fx6Invv
         jlMspszKOpUrTaGl8N2RbjnUKviQZ4KhZ43lUm0spFq4q+gSFJRUxPsCLBu2nF7EI4vQ
         yqrKUTdnfOWYMC1s24iiI9AmAKZ1xh7BcUtorABg/4rqHnjlKrgD4kD9yYMA+Qe2zCMl
         szCVGGVYKN901lagJ7xV3GYdS5PCVXPUx2+dKqdjiGdOV0vcCAbaPGuW4t7wT4R9ZluL
         +PmzULVvjtu07v05t0GE1QOII/TNpi/317YhGSKibcvxcDzHyVYmZBvrB0ne0nGa1zKT
         LCwA==
X-Forwarded-Encrypted: i=1; AJvYcCXlOR+NNNX3V8hGZCjrM19y+XTKSQiyuOvTf8OFVVnA4OdZ0EVwjvTcLy57+o0cvDJIvrRg+AjqlA==@kvack.org
X-Gm-Message-State: AOJu0YxV6dOtE6MPqG/k8NqNm9MDrVYRUGUWUyRJYsgWN0V1spGXKooQ
	0N1xTKxI+r7Kk7xo3JnEQX1DwZ9pPAvIZxppVVj0Yuqbgg/W2EZsAUT6
X-Gm-Gg: ASbGnctZGedAmxLaOlsLclZohXjF9SZ9KtYJh8srrg4y1h4grkMriGsgDj/4hrYn5T5
	e54qFPNEUXMMZC2zbezpx2i37tJXYUovQw/4R7cy7Qwj6B9e1olxeEZYItO5RITo5ZQmzkfwLGl
	iqUWvwbWzJVUTAJBDn7IV6JNiu+UIeMR4HckoKf2EOdW0sTm7hlCG5Ld29gud8DDRrrDFndp/Z3
	oXBbN7SBOZwVyFF726m4U7fTV/fZjHGghQ17KYzsxuuerPtFLNawU/UyUo/u6RNs2bs1L0PV/mu
	K9cN5vviGF+SPDDd7FplxpYxCc2vWEjA61CwJtBdaRqdNwpuLCbiE+xbzSPn7rHqlU4OzHEuqD/
	7ci9nP4Rmbh1wLQM3uTnyZIljsquav87A35YRrBLWnfERVQKxYHlHe6opJCf5mi8FFjXKuS8gC4
	szriBp5FKYpU8ss4Z4joMovpPhR9Q9yC6FFD9p7LmhVLTxO+dkNLAQU14=
X-Google-Smtp-Source: AGHT+IGu+nWwawV5ChwOmhhJwGD5r7xlcIavX7xc1c5+WEOiPICxEOVPDqZSgI99fAXCkzUDemR2cw==
X-Received: by 2002:a17:902:f54a:b0:295:6427:87d4 with SMTP id d9443c01a7336-29bab1db61fmr227655505ad.50.1764515019196;
        Sun, 30 Nov 2025 07:03:39 -0800 (PST)
Received: from ?IPV6:2405:201:31:d869:f0ca:4857:a475:749a? ([2405:201:31:d869:f0ca:4857:a475:749a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15fb1486asm10660567b3a.61.2025.11.30.07.03.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Nov 2025 07:03:38 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------PBFi06tPLAhiQ94kFTybRu9c"
Message-ID: <ff6e08e2-a7c7-4ebf-8f93-03e5ece9b335@gmail.com>
Date: Sun, 30 Nov 2025 20:33:33 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: syzbot+4d3cc33ef7a77041efa6@syzkaller.appspotmail.com
Cc: akpm@linux-foundation.org, brauner@kernel.org, hare@suse.de,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mcgrof@kernel.org, syzkaller-bugs@googlegroups.com,
 willy@infradead.org
References: <680ae31e.050a0220.2c0118.0c72.GAE@google.com>
Subject: Re: [syzbot] [fs?] [mm?] kernel BUG in __filemap_add_folio
Content-Language: en-US
From: shaurya <ssranevjti@gmail.com>
In-Reply-To: <680ae31e.050a0220.2c0118.0c72.GAE@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8887C10000A
X-Stat-Signature: kcjkzxt4esp43mffouzp8bme1oozth3e
X-HE-Tag: 1764515020-23259
X-HE-Meta: U2FsdGVkX19MPtYJr6kLPbX+xGss1suNj+5bZk3OuhsPsp1FBjfkJYCli5UrKGKeXSyml8PBCnSDSAyieoa9JoOk9vphyc2vBNXmzHgQxyn/bzjeyIO3Z9ZOIJPVmxhX0ZH1kZSHcKF8m8nq1yx2KIXFtGvZG9jZzaPN2gOIn+MQq9S/120Tx4K3RO+HohsknXnikhtuLcBkbQVDHiJa4flmrTvOqN/57Q6RRt0O0EOT8klN+p8uqAuBmjpK+hHvjYb6uajbGDIxp9btsEVqReA+0Bq86tGSherSdLeDuzPb/BPWPPq99nknvJT1N8DI9qsWi9jYoERbGqtzs4s0OTr+bxpDFE6luE8j38VfmeCe1IUHrQfDNOm1Mii9y7KGqS6lwF12EWo1Pcoc6hlOTCbAvMfM6NA5a7c7BW4E2HpCgGioX+dKscTu+4wXHtMYdFqwsJPiB7adLTJWy+eXgb0AMmBmOZvIISg7bt8M48sYu1ExJm4NCejnoOhE1QNFV4q5FGr6IRvNd9Bp+F80WZZrYCbkd7vSuQWGtnazRsoLEsWjWEyZvSCQVKZeEEj/LW4Lhj+h6YXh4lNIKPQI8PEauQNtaAe5ossQIXWCWKrync8Ri8o48GpXYj+WS2hfMdCMo0zZG3iIGL8OzI/mWy9P4fYhpad7XEQfPcr8X3o6LUC8JiaMFjoBv4Y9l64FiRvowvez6uUEY9khgg5x96EIFEgh1471aVyVxF8OZsJo3LoIW0LDjzHNEdMmUFrHNBqwzD0UDrhPEEY4yuiey3dwbPuG0tlv/NC1j+PnvzFd61pqH+BoINPI2Uly2NFMk14/TuDm7XvbqcAs6q5CHBXvoO7/OIa0p+SVweU5JVkaVjxKy91xPtRMyw3u7Fhw92+uKiKzLXhgmY5STojbVs9F69eC0I2lUgjjUKYwX8KjwQnM8TQjkrMH21UYN6sZjmfSaU02i7D1emjzAKC
 DZYJWpkb
 TMWwiMioNgZ/BJszxskFZ63qumRV8xDxMcKI7t1o9PD24aURiSgyNzowqVJXSNgFJoYSvia9miH12JiKktvtcnZlBfxwIvj8r+GGUUiALvYvqRWaW2Vg9RFBbZ2SONVbqACOf1Q7o/b8FnKlku+kJmlXYAZhP8Bh0I+Lra564ijYlUxk7n5SAeu4V3RiAP1oSj1fuEb+szafaEnpSTNpppDkjFooNIu5zEe/mfK3mSge00msYVT75FpNM2NNPnw5eNz6kwNF47dvCO61fW76xg2OhwE/P33HXk3f1aV5vad0U/UT8OpIzyWgrDDwdn0Kyifhmxje6EPCCtWLgLhXAww+FdkpIfsAR1aB5z5NoeBr9WctGSLLF1p1nnPFf3XqeaukxaQmYwew96bSlGgyAGNkBEzfw00m1e6f0nCsxkGQQUlWMxlGYiVpzbJIa4d3gsudRN3izm9cYVQIIi2Vu072f7kUY2I6K+V9QB6Y+ARkG7YdeoJb8pHPEugCV1LsBLbN6vpmrGHa9ocByKA/PlqDQtbmEzChIcWEzf3LvHM5BGqPUuxMV9fwM4cfbnEbFutUGkPkagpSPOUJwyoiwsazjunzacgMy4gZCcxQyjD2/dwQBg4107/6jTVOt6+GZvH4709xsKuS3V2LA6Rqz7AY2ph9QzYHRjArGHIW81aKI33wDzcRhAEtXGC9h6SQ2apANEm/3sgRs0f+wRTxHyCmn3TW2KCPX1pWrsw2u9J0B2L2T6EhyWPNvqdZQ2EISt5XJUAjL12u9kKg5fM76yvGM/Rqc3hb6dfhOnPAVnWU7jlU1ZfyQP+f5ov9PSgcfe5rlo2esFaUTxh2IRhAFlOJW5Y+B+f8RF5yAcRsAxv5nuYG9L5KWGakRNlWknLs42ilTotpKME3PPQUeTtGar7l7ssiYo3uZn8bj/og8LtRXr4PehF5GU9xp+DgiWV1YlFetKvzV0n1SpLIeKHWXE9FUEyJi
 E3yQklQh
 dfzsYX8mZ9Zz6x3O60xTAbeUHPWYdxvvUxzJAYT7JLmT9l4yjDypP65Sr8u5o5T1FpH5iiptJlM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------PBFi06tPLAhiQ94kFTybRu9c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz test:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

--------------PBFi06tPLAhiQ94kFTybRu9c
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-mm-readahead-fix-race-between-page_cache_ra_order-an.patch"
Content-Disposition: attachment;
 filename*0="0001-mm-readahead-fix-race-between-page_cache_ra_order-an.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSBlYzdlYTlhMWYwM2YzNjY3MmNmNWFjYjIzNzYxY2ZlZjZiOTQ4ZjIxIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBTaGF1cnlhIFJhbmUgPHNzcmFuZV9iMjNAZWUudmp0
aS5hYy5pbj4KRGF0ZTogU3VuLCAzMCBOb3YgMjAyNSAyMDoyNzoyNSArMDUzMApTdWJqZWN0
OiBbUEFUQ0hdIG1tL3JlYWRhaGVhZDogZml4IHJhY2UgYmV0d2VlbiBwYWdlX2NhY2hlX3Jh
X29yZGVyIGFuZAogc2V0X2Jsb2Nrc2l6ZQoKcGFnZV9jYWNoZV9yYV9vcmRlcigpIHJlYWRz
IG1hcHBpbmdfbWluX2ZvbGlvX29yZGVyKCkgYmVmb3JlIGFjcXVpcmluZwp0aGUgaW52YWxp
ZGF0ZV9sb2NrLCBjcmVhdGluZyBhIHRpbWUtb2YtY2hlY2stdGltZS1vZi11c2UgKFRPQ1RP
VSkgcmFjZQp3aXRoIHNldF9ibG9ja3NpemUoKSB3aGljaCBjYW4gY2hhbmdlIHRoZSBtYXBw
aW5nJ3MgbWluX2ZvbGlvX29yZGVyCndoaWxlIGhvbGRpbmcgdGhlIGludmFsaWRhdGVfbG9j
ayBleGNsdXNpdmVseS4KCklmIHNldF9ibG9ja3NpemUoKSBpbmNyZWFzZXMgdGhlIG1hcHBp
bmcncyBtaW5fZm9saW9fb3JkZXIgYWZ0ZXIKcGFnZV9jYWNoZV9yYV9vcmRlcigpIHJlYWRz
IHRoZSBvbGQgdmFsdWUgYnV0IGJlZm9yZSBpdCBhZGRzIGZvbGlvcwp0byB0aGUgcGFnZSBj
YWNoZSwgdGhlIFZNX0JVR19PTiBjaGVjayBpbiBfX2ZpbGVtYXBfYWRkX2ZvbGlvKCkgd2ls
bAp0cmlnZ2VyOgoKICBWTV9CVUdfT05fRk9MSU8oZm9saW9fb3JkZXIoZm9saW8pIDwgbWFw
cGluZ19taW5fZm9saW9fb3JkZXIobWFwcGluZyksCiAgICAgICAgICAgICAgICAgIGZvbGlv
KTsKClRoaXMgY2FuIGhhcHBlbiBiZWNhdXNlIHRoZSBzdGFsZSBtaW5fb3JkZXIgaXMgdXNl
ZCB0byBjYWxjdWxhdGUKbmV3X29yZGVyIGFuZCBjb25zdHJhaW4gdGhlIGZvbGlvIG9yZGVy
LCBidXQgZmlsZW1hcF9hZGRfZm9saW8oKQpyZS1yZWFkcyB0aGUgKG5vdyBpbmNyZWFzZWQp
IG1pbl9mb2xpb19vcmRlciBmcm9tIHRoZSBtYXBwaW5nLgoKRml4IHRoaXMgYnkgbW92aW5n
IHRoZSByZWFkIG9mIG1hcHBpbmdfbWluX2ZvbGlvX29yZGVyKCkgYW5kIHRoZQpuZXdfb3Jk
ZXIgY2FsY3VsYXRpb24gdG8gYWZ0ZXIgdGhlIGludmFsaWRhdGVfbG9jayBpcyBhY3F1aXJl
ZCBpbgpzaGFyZWQgbW9kZS4KClJlcG9ydGVkLWJ5OiBzeXpib3QrNGQzY2MzM2VmN2E3NzA0
MWVmYTZAc3l6a2FsbGVyLmFwcHNwb3RtYWlsLmNvbQpDbG9zZXM6IGh0dHBzOi8vc3l6a2Fs
bGVyLmFwcHNwb3QuY29tL2J1Z1w/ZXh0aWRcPTRkM2NjMzNlZjdhNzcwNDFlZmE2CkZpeGVz
OiA0N2RkNjc1MzIzMDMgKCJibG9jay9iZGV2OiBsaWZ0IGJsb2NrIHNpemUgcmVzdHJpY3Rp
b25zIHRvIDY0ayIpCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6
IFNoYXVyeWEgUmFuZSA8c3NyYW5lX2IyM0BlZS52anRpLmFjLmluPgotLS0KIG1tL3JlYWRh
aGVhZC5jIHwgMTUgKysrKysrKysrKystLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0
aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9tbS9yZWFkYWhlYWQuYyBi
L21tL3JlYWRhaGVhZC5jCmluZGV4IDNhNGI1ZDU4ZWViNi4uOTU3MThmODdiZDQzIDEwMDY0
NAotLS0gYS9tbS9yZWFkYWhlYWQuYworKysgYi9tbS9yZWFkYWhlYWQuYwpAQCAtNDY3LDcg
KzQ2Nyw3IEBAIHZvaWQgcGFnZV9jYWNoZV9yYV9vcmRlcihzdHJ1Y3QgcmVhZGFoZWFkX2Nv
bnRyb2wgKnJhY3RsLAogCXN0cnVjdCBhZGRyZXNzX3NwYWNlICptYXBwaW5nID0gcmFjdGwt
Pm1hcHBpbmc7CiAJcGdvZmZfdCBzdGFydCA9IHJlYWRhaGVhZF9pbmRleChyYWN0bCk7CiAJ
cGdvZmZfdCBpbmRleCA9IHN0YXJ0OwotCXVuc2lnbmVkIGludCBtaW5fb3JkZXIgPSBtYXBw
aW5nX21pbl9mb2xpb19vcmRlcihtYXBwaW5nKTsKKwl1bnNpZ25lZCBpbnQgbWluX29yZGVy
OwogCXBnb2ZmX3QgbGltaXQgPSAoaV9zaXplX3JlYWQobWFwcGluZy0+aG9zdCkgLSAxKSA+
PiBQQUdFX1NISUZUOwogCXBnb2ZmX3QgbWFyayA9IGluZGV4ICsgcmEtPnNpemUgLSByYS0+
YXN5bmNfc2l6ZTsKIAl1bnNpZ25lZCBpbnQgbm9mczsKQEAgLTQ4MywxNSArNDgzLDIyIEBA
IHZvaWQgcGFnZV9jYWNoZV9yYV9vcmRlcihzdHJ1Y3QgcmVhZGFoZWFkX2NvbnRyb2wgKnJh
Y3RsLAogCiAJbGltaXQgPSBtaW4obGltaXQsIGluZGV4ICsgcmEtPnNpemUgLSAxKTsKIAor
CS8qIFNlZSBjb21tZW50IGluIHBhZ2VfY2FjaGVfcmFfdW5ib3VuZGVkKCkgKi8KKwlub2Zz
ID0gbWVtYWxsb2Nfbm9mc19zYXZlKCk7CisJZmlsZW1hcF9pbnZhbGlkYXRlX2xvY2tfc2hh
cmVkKG1hcHBpbmcpOworCisJLyoKKwkgKiBSZS1yZWFkIG1pbl9vcmRlciBhZnRlciBhY3F1
aXJpbmcgdGhlIGludmFsaWRhdGVfbG9jayB0byBhdm9pZCBhCisJICogcmFjZSB3aXRoIHNl
dF9ibG9ja3NpemUoKSB3aGljaCBjYW4gY2hhbmdlIHRoZSBtYXBwaW5nJ3MgbWluX29yZGVy
CisJICogd2hpbGUgaG9sZGluZyB0aGUgaW52YWxpZGF0ZV9sb2NrIGV4Y2x1c2l2ZWx5Lgor
CSAqLworCW1pbl9vcmRlciA9IG1hcHBpbmdfbWluX2ZvbGlvX29yZGVyKG1hcHBpbmcpOwog
CW5ld19vcmRlciA9IG1pbihtYXBwaW5nX21heF9mb2xpb19vcmRlcihtYXBwaW5nKSwgbmV3
X29yZGVyKTsKIAluZXdfb3JkZXIgPSBtaW5fdCh1bnNpZ25lZCBpbnQsIG5ld19vcmRlciwg
aWxvZzIocmEtPnNpemUpKTsKIAluZXdfb3JkZXIgPSBtYXgobmV3X29yZGVyLCBtaW5fb3Jk
ZXIpOwogCiAJcmEtPm9yZGVyID0gbmV3X29yZGVyOwogCi0JLyogU2VlIGNvbW1lbnQgaW4g
cGFnZV9jYWNoZV9yYV91bmJvdW5kZWQoKSAqLwotCW5vZnMgPSBtZW1hbGxvY19ub2ZzX3Nh
dmUoKTsKLQlmaWxlbWFwX2ludmFsaWRhdGVfbG9ja19zaGFyZWQobWFwcGluZyk7CiAJLyoK
IAkgKiBJZiB0aGUgbmV3X29yZGVyIGlzIGdyZWF0ZXIgdGhhbiBtaW5fb3JkZXIgYW5kIGlu
ZGV4IGlzCiAJICogYWxyZWFkeSBhbGlnbmVkIHRvIG5ld19vcmRlciwgdGhlbiB0aGlzIHdp
bGwgYmUgbm9vcCBhcyBpbmRleAotLSAKMi4zNC4xCgo=

--------------PBFi06tPLAhiQ94kFTybRu9c--

