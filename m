Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AF2AC982DE
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 17:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B19B96B0088; Fri, 16 Jan 2026 12:22:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2C76B0089; Fri, 16 Jan 2026 12:22:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EFDA6B008A; Fri, 16 Jan 2026 12:22:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 89E456B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:22:04 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 389A7C101C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:22:04 +0000 (UTC)
X-FDA: 84338494968.22.B3C4BFF
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8981C180010
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:22:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LA264xcK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of barrdetwix@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=barrdetwix@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768584122; a=rsa-sha256;
	cv=none;
	b=IKjdIDWy9veYb16nMFX4bAL+Knwj93C70tksgtXy1a1aJSyyTitcd7iwOH3zbzb/XtOMg4
	R+rsZgC5wbsuA79MY+AdNN8fj42J8QjmvTkgQjzomu5Ooj8twxxwMfBAL2KQKSwgNzqh+9
	DVEaxJxES/zLZqhoHaUFIMDEGZSDOZY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LA264xcK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of barrdetwix@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=barrdetwix@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768584122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uPW8Is5GlXyiIanWkT5TAZiriz9aYexuNfv3iUeBrAI=;
	b=qQNlVxUgNJIqdigPCB6taDyhyCNXoHonKPF8NNx/048+L87De4lgivb2/hu3XAk1u8Eger
	aAx4Mrh5iucJUPhdqeNV9/rkDNLJAvS+UxbbecoQOIFRd8uliDwciNX3XFMgh71DiCe0zm
	rQ5QofTBIWVc+AYrnW43dIxPGVc8ywk=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4801bc32725so10944655e9.0
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768584121; x=1769188921; darn=kvack.org;
        h=content-transfer-encoding:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uPW8Is5GlXyiIanWkT5TAZiriz9aYexuNfv3iUeBrAI=;
        b=LA264xcKjbSBRO6u0kbO63wu//ewx26EYyJunSqTtsoBsAIjS3ydtIGQS/zoODx8Bf
         MKWB0Sf60thNwQDEpyojWrhptqVmlDhF9wJU3bi4Bt78u3xcpER8o4gn1o8//SKT+bRY
         G53d8qfWkg4qk5T7DAon+iS53tIPPOgGZKEv+hbhBJvw4W5f3KWRnzrvH0yvoYhN7Ccw
         cGD02JYeLjVizHAMuKxF4WlZUpQFaHRBt7kUeKhcdjymyIyfQ4QWYTiV7tBip/a+gZAs
         y3+l87hTBMGt6xr2IhGUQs5gt62LENQgK//uEifLDFotHAcQ8EpQARbb1iuZPeqD20Ej
         MAhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768584121; x=1769188921;
        h=content-transfer-encoding:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uPW8Is5GlXyiIanWkT5TAZiriz9aYexuNfv3iUeBrAI=;
        b=vAQ6OOlSzXRw2y28mOw0wRtnBHFsV30KSm8oz3y9xQ6t7KZOdD6fCRalByBA4/ORKN
         age7s3zgAdcGSkGNhPgJS1OtNVuTlcftd+2B2rQC6z0uEi3Gi0ky1Vw+b7oFf54W3pxT
         mEeyT1CDbIo4FgBFY9Ymbh8IJt0PFXTABnqq7E0ttI8EX51Qf/waAnHh4eMBHFouCG8o
         KhFK9Q5GjZUftnvvFU/KKhEulJ0pM12KYerw99+ULjIKVziNRSJSchoGG9eMuzRHjun9
         tzZHVpL1kFUcxCLfV/2nasNNZdhSp9cNzWCpawq5u75DE+8JhwIHGzDhgjL0QzQuiAZ9
         qMOw==
X-Forwarded-Encrypted: i=1; AJvYcCXdv0vMsconcZmJ9rn8KI6BYASTJrnRP99nLmL7tyYGbS9f/tQjoo6S1esXkVzf8KryaP3zGAq9Pg==@kvack.org
X-Gm-Message-State: AOJu0YwmmPJONgOKCHU4cuOU8BNxzYOsaQD95W3Q6oh5hWKqx3MOm3Ua
	WaKMpP7xymWaaFTLFX9WhoC6klLFZOeUdYkXvv0mP6Wv45j2AWGZ+UZv
X-Gm-Gg: AY/fxX5nbRX0y2qwPImFegwvwsIBkjpW7LavYRvOCmmuEbuB1PvLzLnWUo+YML5dQy9
	KWs7O/XWvgV6D3b6iAo5XGYNC0+zs6HexqkwDOr4AzeRwzZzbRYsLLikxToDRB1zJiYyNHjUZFE
	pI8QbOo7m4+i7BowWY1lreIwramzhuwBvaUhXO1hjovEYbCgyUYIY1F7iZnbFzxkpgySNfdDzlr
	d32jPD3ckBGwAlgO9Irt5skCrAoqHKHPCJY69BsQOvfFHiLy2f9vCFJvQm28M5UA0xtoX2LS38h
	mRK+7Zw/KKdFbN3nsBvnuk6+YlP9xTiscVzlp/jifmtgoCdJxUWRxiJsstsOAB5KWGI+8Z+LCrp
	uLYUTa8WrW0PpKJi64FTaRJebDz0pFgMm65W2m11RwafdX4/vJNejxzM7d5G8aqZZ278ei0x0Am
	iHfDcavss4IozfnUjFIGWNcuo3Ls64K4NnfUZz196gUXiXKwBM6Y8cFmG+MNE=
X-Received: by 2002:a05:600c:548a:b0:475:dd8d:2f52 with SMTP id 5b1f17b1804b1-4801eb12369mr37979745e9.32.1768584120534;
        Fri, 16 Jan 2026 09:22:00 -0800 (PST)
Received: from ?IPV6:2a01:e34:ec09:e880:dabf:2016:8c5c:a5fb? ([2a01:e34:ec09:e880:dabf:2016:8c5c:a5fb])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4801e879537sm51723325e9.5.2026.01.16.09.21.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 09:21:59 -0800 (PST)
Message-ID: <820e29bb-38ee-447e-b77b-9ca2bf46b2f6@gmail.com>
Date: Fri, 16 Jan 2026 18:21:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Content-Language: en-US
From: John Smith <barrdetwix@gmail.com>
Subject: WARN_ON_ONCE: (PF_MEMALLOC && nofail) in __alloc_pages_slowpath via
 ext4, iput, kswapd
To: linux-ext4@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-Rspam-User: 
X-Stat-Signature: 1o9ccxr7m3x1k9c5ngdke3e4ap6dm87g
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8981C180010
X-HE-Tag: 1768584122-717972
X-HE-Meta: U2FsdGVkX1+eIc3E8ERpMPDQtTD845m/eoIzi40LF+3zAUsgkc/yf5KWMHSri9Uoe2GQt0yHK9l3GJdrrzDCrbnhXsLM2tOHtGqGxmxLvqoo6vsfpN+uDgq1+eKtWMwSSuFAx4AYGEjMbQdpkv68E2gbR9uZmRVV+ERes7DVEzMzjERgagSHjocFd2yfHYVA8CDmTe2TEo30BlgenYfZ+95wc2YidsdbthP23oc+XTt8hlroP1qW9AV1DN2jatR4Cp67ZheN7c6+LUPnVXblbLLyudcnp8MvOdlK0ecdIjiZcfWXzZOZGb46kQqfVVzI9sdH0IA6O7cBbGYo2jrMcyn7xIc9Foim7MH5JRDRYk0oggvgL278/DlM3gDrULzFlDEdg7PEKI/kqf4xKDcVOT9G3I3gVc1Hq6UEVnBPyCMgaLhZpv0sZ91yYekE68WukBYIAZLLB+5NzbLGeHIEjfnJvd4GMIXoRnOq6B9hRmG9wt6Xfz5755x8PuUx5miKMZyhLKcIFnlgVMsJ0mLMPGs+xSgxWMds7FW3JXq3C7NHBT9CAAw6x4UQfgipP8hjzXonc9GBDbzUwnnIbXVBdGxCyZDqi1nYRrYjRK3s8s+ImzOu2Ooizm8dpSqHoeBOUnhbbXpryGBm+dqT0Cdb0jc3tfgfLza3JRYJAOSymtfzyM2czKMWFILJr0Z3xXpYsVfw1URXLiloa8kFL7iYCxEtY3u8HhPrxYI9ebjqpJCcrfwu/Mpj/qLCIdofMCLtlS9I4uzzqNSQhFVmzuvbm2u1NU+IPsqtA26qUDWtX6ey+fcAVlGSbeK7Oe0mywXCWAlu8Uw9WjMM1Z/iVOWQD/ThUO7uRKvelWCCjv0qdX5TPhrLc2r3BMKzVEeKUY05H9lbJuSJDmECsjPbMVC5kuwIsnWxe8HEDPmNfsRglxNAurZ5fmMGEOFpJz8l6or31OLaoa46NjLOyxBwNuY
 xCPB9otJ
 AVDW5bUDsgCmzKvumGG04T1boAXK3PGU2k/AZ7SLt9IGBD8vL94HSnO/Pu5rHez6ldpC++WE1rO8Q4s/WSPRMn/nhbY8JiLYd6lq44OKdS2hHc8LgzVZ6+3s6OErVSQ8RfFFXpSWPd6y/uFMuoHgwLpQ6vKA+hdp58irQbVjqJygPmuqgPhNla2IfKwEF0/TA5rwt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgbGlzdCwNCg0KSSBkb24ndCBoYXZlIGEgcmVwcm9kdWNlciBmb3IgdGhpcyBXQVJOLCBi
dXQgaXQgbWFkZSBpdHNlbGYga25vd24gYnkgZnJlZXppbmcgbXkgZGVza3RvcCBmb3IgfjVz
LCBzbyBJIHRob3VnaHQgSSdkIHdyaXRlIGhvbWUuDQpJbiBfX2FsbG9jX3BhZ2VzX3Nsb3dw
YXRoLCBJIGhpdDoNCg0KaWYgKHVubGlrZWx5KG5vZmFpbCkpIHsNCgk8Li4uIHNuaXAgLi4u
Pg0KDQoJLyoNCgkgKiBQRl9NRU1BTExPQyByZXF1ZXN0IGZyb20gdGhpcyBjb250ZXh0IGlz
IHJhdGhlciBiaXphcnJlDQoJICogYmVjYXVzZSB3ZSBjYW5ub3QgcmVjbGFpbSBhbnl0aGlu
ZyBhbmQgb25seSBjYW4gbG9vcCB3YWl0aW5nDQoJICogZm9yIHNvbWVib2R5IHRvIGRvIGEg
d29yayBmb3IgdXMuDQoJICovDQoJV0FSTl9PTl9PTkNFKGN1cnJlbnQtPmZsYWdzICYgUEZf
TUVNQUxMT0MpOw0KfQ0KDQpJIGRvIGhhdmUgYmNhY2hlZnMgbG9hZGVkIHZpYSBES01TIHdp
dGggYSBtaXggb2YgZmlsZXN5c3RlbXMgbW91bnRlZCwgc28gdGhpcyBpcyBtYXliZSBub3Qg
dGhlIGlkZWFsIGJ1ZyByZXBvcnQuDQpCdXQgaGVyZSBpdCBpcywganVzdCBpbiBjYXNlLg0K
DQoNCls4Mjk0MS4wMTQ3NzBdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0t
LQ0KWzgyOTQxLjAxNDc3N10gV0FSTklORzogQ1BVOiAxMyBQSUQ6IDE1MiBhdCBtbS9wYWdl
X2FsbG9jLmM6NDY2MCBfX2FsbG9jX3BhZ2VzX3Nsb3dwYXRoLmNvbnN0cHJvcC4wKzB4Yjc2
LzB4ZTIwDQpbODI5NDEuMDE0Nzg4XSBNb2R1bGVzIGxpbmtlZCBpbjogYmNhY2hlZnMoT0Up
IGx6NGhjX2NvbXByZXNzIGx6NF9jb21wcmVzcyB1YXMgdXNiX3N0b3JhZ2UgdWlucHV0IG52
aWRpYV91dm0oT0UpIHNuZF9zZXFfZHVtbXkgc25kX2hydGltZXIgcmZjb21tIHNuZF9zZXEg
c25kX3NlcV9kZXZpY2UgeHRfY29ubnRyYWNrIG5mdF9jaGFpbl9uYXQgeHRfTUFTUVVFUkFE
RSBuZl9uYXQgbmZfY29ubnRyYWNrIG5mX2RlZnJhZ19pcHY2IG5mX2RlZnJhZ19pcHY0IGJy
aWRnZSB4ZnJtX3VzZXIgeGZybV9hbGdvIHh0X2FkZHJ0eXBlIG5mdF9jb21wYXQgeF90YWJs
ZXMgcXJ0ciBvdmVybGF5IGNtYWMgYWxnaWZfaGFzaCBhbGdpZl9za2NpcGhlciBhZl9hbGcg
Ym5lcCA4MDIxcSBnYXJwIHN0cCBsbGMgbXJwIHN1bnJwYyBiaW5mbXRfbWlzYyBudmlkaWFf
ZHJtKE9FKSBudmlkaWFfbW9kZXNldChPRSkgbmxzX2FzY2lpIG5sc19jcDQzNyB2ZmF0IGZh
dCBudmlkaWEoT0UpIGFtZF9hdGwgaW50ZWxfcmFwbF9tc3IgaW50ZWxfcmFwbF9jb21tb24g
ZWRhY19tY2VfYW1kIGt2bV9hbWQgc25kX2hkYV9jb2RlY19hbGM2NjIgc25kX2hkYV9jb2Rl
Y19yZWFsdGVrX2xpYiBzbmRfaGRhX2NvZGVjX252aGRtaSBrdm0gc25kX2hkYV9jb2RlY19n
ZW5lcmljIHNuZF9oZGFfY29kZWNfaGRtaSBzbmRfaGRhX2ludGVsIHNuZF9oZGFfY29kZWMg
YnR1c2Igd2lyZWd1YXJkIHNuZF9oZGFfY29yZSBidG10ayBidHJ0bCBsaWJjdXJ2ZTI1NTE5
IHNuZF9pbnRlbF9kc3BjZmcgYnRiY20gbGliY2hhY2hhMjBwb2x5MTMwNSBzbmRfaW50ZWxf
c2R3X2FjcGkgZHJtX3R0bV9oZWxwZXIgaXJxYnlwYXNzIGJ0aW50ZWwgc25kX2h3ZGVwIGxp
YmNoYWNoYSB0dG0gZ2hhc2hfY2xtdWxuaV9pbnRlbCBpcDZfdWRwX3R1bm5lbCBiYXR0ZXJ5
IHNuZF9wY20gYWVzbmlfaW50ZWwgdWRwX3R1bm5lbCBkcm1fY2xpZW50X2xpYiBibHVldG9v
dGggbGlicG9seTEzMDUgcmFwbCBkcm1fa21zX2hlbHBlciBzbmRfdGltZXIgd21pX2Jtb2Yg
c25kIGpveWRldiBjY3ANCls4Mjk0MS4wMTQ4NzBdICB2aWRlbyBlZTEwMDQgc291bmRjb3Jl
IGFjcGlfY3B1ZnJlcSBrMTB0ZW1wIGVjZGhfZ2VuZXJpYyBjZmc4MDIxMSBzZyBldmRldiBy
ZmtpbGwgZHJtIG5mX3RhYmxlcyBkbV9tb2QgcGFycG9ydF9wYyBscCBwcGRldiBwYXJwb3J0
IGkyY19kZXYgbXNyIGNvbmZpZ2ZzIGVmaV9wc3RvcmUgbmZuZXRsaW5rIGF1dG9mczQgZXh0
NCBjcmMxNiBtYmNhY2hlIGpiZDIgY3JjMzJjX2NyeXB0b2FwaSBidHJmcyBibGFrZTJiX2dl
bmVyaWMgcmFpZDEwIHJhaWQ0NTYgYXN5bmNfcmFpZDZfcmVjb3YgYXN5bmNfbWVtY3B5IGFz
eW5jX3BxIGFzeW5jX3hvciBhc3luY190eCB4b3IgcmFpZDZfcHEgcmFpZDEgcmFpZDAgbWRf
bW9kIGhpZF9sb2dpdGVjaF9oaWRwcCBoaWRfbG9naXRlY2hfZGogaGlkX2dlbmVyaWMgdXNi
aGlkIGhpZCBzZF9tb2QgYWhjaSBsaWJhaGNpIHhoY2lfcGNpIHhoY2lfaGNkIG52bWUgbGli
YXRhIG52bWVfY29yZSBzcDUxMDBfdGNvIHVzYmNvcmUgd2F0Y2hkb2cgc2NzaV9tb2Qgcjgx
NjkgbnZtZV9rZXlyaW5nIG52bWVfYXV0aCBpMmNfcGlpeDQgcmVhbHRlayBncGlvX2FtZHB0
IHNjc2lfY29tbW9uIHVzYl9jb21tb24gaGtkZiB3bWkgaTJjX3NtYnVzIGdwaW9fZ2VuZXJp
YyBidXR0b24gZWZpdmFyZnMNCls4Mjk0MS4wMTQ5MzVdIENQVTogMTMgVUlEOiAwIFBJRDog
MTUyIENvbW06IGtzd2FwZDAgVGFpbnRlZDogRyAgICAgICAgICAgT0UgICAgICAgNi4xOC4z
K2RlYjE0LWFtZDY0ICMxIFBSRUVNUFQobGF6eSkgIERlYmlhbiA2LjE4LjMtMQ0KWzgyOTQx
LjAxNDk0MV0gVGFpbnRlZDogW09dPU9PVF9NT0RVTEUsIFtFXT1VTlNJR05FRF9NT0RVTEUN
Cls4Mjk0MS4wMTQ5NDJdIEhhcmR3YXJlIG5hbWU6IE1pY3JvLVN0YXIgSW50ZXJuYXRpb25h
bCBDby4sIEx0ZC4gTVMtN0EzNC9CMzUwIFBDIE1BVEUgKE1TLTdBMzQpLCBCSU9TIEEuSjAg
MDEvMjMvMjAxOQ0KWzgyOTQxLjAxNDk0NV0gUklQOiAwMDEwOl9fYWxsb2NfcGFnZXNfc2xv
d3BhdGguY29uc3Rwcm9wLjArMHhiNzYvMHhlMjANCls4Mjk0MS4wMTQ5NTBdIENvZGU6IGZm
IDgzIGZlIDAxIDBmIDg3IDE3IDAyIDAwIDAwIDQ0IDhiIDdjIDI0IDI0IDQ1IDg1IGZmIDBm
IDg0IDRhIDAyIDAwIDAwIDY1IDQ4IDhiIDA1IDZjIDI3IDU4IDAyIGY2IDQwIDJkIDA4IDBm
IDg0IGUzIGY0IGZmIGZmIDwwZj4gMGIgZTkgZGMgZjQgZmYgZmYgOGIgNDQgMjQgNjAgODMg
YzggNjAgNjUgNjYgZjcgMDUgNjMgMjcgNTggMDINCls4Mjk0MS4wMTQ5NTNdIFJTUDogMDAx
ODpmZmZmZDAxMDgwNmMzNTA4IEVGTEFHUzogMDAwMTAyMDINCls4Mjk0MS4wMTQ5NTZdIFJB
WDogZmZmZjg4ZmZjMjJjMDAwMCBSQlg6IDAwMDAwMDAwMDAxNDhjNDggUkNYOiAwMDAwMDAw
MDAwMDAwMDAyDQpbODI5NDEuMDE0OTU4XSBSRFg6IGZmZmZkMDEwODA2YzM2MDAgUlNJOiAw
MDAwMDAwMDAwMDAwMDAwIFJESTogMDAwMDAwMDAwMDAwODAwMA0KWzgyOTQxLjAxNDk2MF0g
UkJQOiAwMDAwMDAwMDAwMDAwMDAwIFIwODogMDAwMDAwMDAwMDAwMDgwMSBSMDk6IDAwMDAw
MDAwMDAwMDAwMDANCls4Mjk0MS4wMTQ5NjJdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6
IGZmZmZkMDEwODA2YzM2MDAgUjEyOiBmZmZmZDAxMDgwNmMzNjAwDQpbODI5NDEuMDE0OTY0
XSBSMTM6IDAwMDAwMDAwMDAxNDhjNDggUjE0OiAwMDAwMDAwMDAwMDAwMDAwIFIxNTogMDAw
MDAwMDAwMDAwMDQwMA0KWzgyOTQxLjAxNDk2Nl0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAw
MDApIEdTOmZmZmY4OTAzM2NmMGMwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMA0K
WzgyOTQxLjAxNDk2OF0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAw
MDA4MDA1MDAzMw0KWzgyOTQxLjAxNDk3MF0gQ1IyOiAwMDAwNTYyOTZjMjBkMDk4IENSMzog
MDAwMDAwMDFkYzQ4YjAwMCBDUjQ6IDAwMDAwMDAwMDAzNTA2ZjANCls4Mjk0MS4wMTQ5NzJd
IENhbGwgVHJhY2U6DQpbODI5NDEuMDE0OTc1XSAgPFRBU0s+DQpbODI5NDEuMDE0OTc5XSAg
PyBfX2FsbG9jX2Zyb3plbl9wYWdlc19ub3Byb2YrMHgzMjEvMHgzNDANCls4Mjk0MS4wMTQ5
ODRdICA/IGFsbG9jX2lvdmErMHgzNC8weDJhMA0KWzgyOTQxLjAxNDk5MF0gID8gaW9tbXVf
djFfbWFwX3BhZ2VzKzB4MzQ4LzB4OTEwDQpbODI5NDEuMDE0OTk1XSAgX19hbGxvY19mcm96
ZW5fcGFnZXNfbm9wcm9mKzB4MzIxLzB4MzQwDQpbODI5NDEuMDE1MDAxXSAgYWxsb2NfcGFn
ZXNfbXBvbCsweDg2LzB4MTkwDQpbODI5NDEuMDE1MDA2XSAgZm9saW9fYWxsb2Nfbm9wcm9m
KzB4NWUvMHhmMA0KWzgyOTQxLjAxNTAwOV0gIF9fZmlsZW1hcF9nZXRfZm9saW8rMHgxZjkv
MHg1ODANCls4Mjk0MS4wMTUwMTZdICBfX2dldGJsa19zbG93KzB4N2QvMHgyMDANCls4Mjk0
MS4wMTUwMjNdICBfX2V4dDRfZ2V0X2lub2RlX2xvYysweDE1NS8weDUxMCBbZXh0NF0NCls4
Mjk0MS4wMTUwODZdICA/IGV4dDRfZ2V0X2lub2RlX2xvYysweDNmLzB4YTAgW2V4dDRdDQpb
ODI5NDEuMDE1MTQyXSAgZXh0NF9nZXRfaW5vZGVfbG9jKzB4M2YvMHhhMCBbZXh0NF0NCls4
Mjk0MS4wMTUxOThdICBleHQ0X3Jlc2VydmVfaW5vZGVfd3JpdGUrMHg0ZC8weDEwMCBbZXh0
NF0NCls4Mjk0MS4wMTUyNTRdICBfX2V4dDRfbWFya19pbm9kZV9kaXJ0eSsweDcyLzB4MjQw
IFtleHQ0XQ0KWzgyOTQxLjAxNTMxMV0gID8gamJkMl9fam91cm5hbF9zdGFydCsweGZjLzB4
MjEwIFtqYmQyXQ0KWzgyOTQxLjAxNTMyNF0gIGV4dDRfZGlydHlfaW5vZGUrMHg1Yi8weDgw
IFtleHQ0XQ0KWzgyOTQxLjAxNTM4MF0gIF9fbWFya19pbm9kZV9kaXJ0eSsweDVhLzB4MzUw
DQpbODI5NDEuMDE1Mzg2XSAgaXB1dCsweDFkYy8weDI2MA0KWzgyOTQxLjAxNTM5MF0gID8g
ZGVudHJ5X3VubGlua19pbm9kZSsweDhiLzB4MTEwDQpbODI5NDEuMDE1Mzk1XSAgX19kZW50
cnlfa2lsbCsweDZiLzB4MTkwDQpbODI5NDEuMDE1Mzk5XSAgc2hyaW5rX2RlbnRyeV9saXN0
KzB4NjgvMHhlMA0KWzgyOTQxLjAxNTQwNF0gIHBydW5lX2RjYWNoZV9zYisweDU5LzB4ODAN
Cls4Mjk0MS4wMTU0MDldICBzdXBlcl9jYWNoZV9zY2FuKzB4MTI5LzB4MWUwDQpbODI5NDEu
MDE1NDEzXSAgZG9fc2hyaW5rX3NsYWIrMHgxNDcvMHgzYzANCls4Mjk0MS4wMTU0MTddICBz
aHJpbmtfc2xhYisweDI3NS8weDM4MA0KWzgyOTQxLjAxNTQyMV0gIHNocmlua19vbmUrMHgx
MjEvMHgxZjANCls4Mjk0MS4wMTU0MjZdICBzaHJpbmtfbm9kZSsweGIxMy8weGNlMA0KWzgy
OTQxLjAxNTQzMl0gIGJhbGFuY2VfcGdkYXQrMHg1NTAvMHhhYzANCls4Mjk0MS4wMTU0Mzdd
ICA/IGZpbmlzaF90YXNrX3N3aXRjaC5pc3JhLjArMHg5Ny8weDJjMA0KWzgyOTQxLjAxNTQ0
NF0gIGtzd2FwZCsweDFkOS8weDM3MA0KWzgyOTQxLjAxNTQ0OV0gID8gX19wZnhfYXV0b3Jl
bW92ZV93YWtlX2Z1bmN0aW9uKzB4MTAvMHgxMA0KWzgyOTQxLjAxNTQ1NV0gID8gX19wZnhf
a3N3YXBkKzB4MTAvMHgxMA0KWzgyOTQxLjAxNTQ1OV0gIGt0aHJlYWQrMHhmYy8weDI0MA0K
WzgyOTQxLjAxNTQ2M10gID8gX19wZnhfa3RocmVhZCsweDEwLzB4MTANCls4Mjk0MS4wMTU0
NjddICByZXRfZnJvbV9mb3JrKzB4MWNjLzB4MjAwDQpbODI5NDEuMDE1NDcyXSAgPyBfX3Bm
eF9rdGhyZWFkKzB4MTAvMHgxMA0KWzgyOTQxLjAxNTQ3NV0gIHJldF9mcm9tX2ZvcmtfYXNt
KzB4MWEvMHgzMA0KWzgyOTQxLjAxNTQ4MF0gIDwvVEFTSz4NCls4Mjk0MS4wMTU0ODJdIC0t
LVsgZW5kIHRyYWNlIDAwMDAwMDAwMDAwMDAwMDAgXS0tLQ0KDQoNCg==

