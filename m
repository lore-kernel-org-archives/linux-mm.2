Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23F60CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 11:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C6808E000D; Mon, 15 Sep 2025 07:44:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79CE58E0001; Mon, 15 Sep 2025 07:44:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68BCA8E000D; Mon, 15 Sep 2025 07:44:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 543FF8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:44:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C49C1605C8
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:44:33 +0000 (UTC)
X-FDA: 83891302026.25.BE40A1C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id EC4ECC0005
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:44:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Hrm3W7WU;
	spf=pass (imf10.hostedemail.com: domain of toke@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757936671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uSHPRUFaXeFg56s3ZlnqQHiikskw++1DW2WVyVaExKo=;
	b=g41LuyydyePjax994QOLwxUcx1XGEy0G2eLz3gBy+jRvjJkR742kjPXR/RdsKVK0h0b01c
	ozqWBAmqla9RseaJkiTHeYeFWe1MijKq83828o8a/bjDJP42Gf+6KTRTMnd+lvmC4c11pP
	QNGWGVKanO8kY4vOL26nueDTfbqw464=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757936671; a=rsa-sha256;
	cv=none;
	b=dCijAGTyh+Ksq3SzSAEHbbRn8sl6r6TysJUvhKi+rEL0U6uzvAcJT6OiwVU/ID/F/kW078
	loHjKvUkhpwVDVKyKwF6h52/XtBPUMobTlEXOlRzYd2c99FQoAmYprVWWXjUb2O35hLDm+
	JTfHVN3SatXRrvYU78HVx7K8kTiKVC4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Hrm3W7WU;
	spf=pass (imf10.hostedemail.com: domain of toke@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757936670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uSHPRUFaXeFg56s3ZlnqQHiikskw++1DW2WVyVaExKo=;
	b=Hrm3W7WUS1yk3pl7cjFx5wVjX3uUATdEhn5WDdOQ3DqMuIGNmJ4OWB05re+vr9myLKTCkF
	8absuRKcs80An49xbgxBrOcnoL8rMh9fwicj8q+m1fpJZzPn4KLS6KGeoofYwjsPSb03El
	WIOV/WezAuhJuLOKt2/+eMvDWAjyx14=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-iXO-0dmFMpWFtiBrwXWEiw-1; Mon, 15 Sep 2025 07:44:28 -0400
X-MC-Unique: iXO-0dmFMpWFtiBrwXWEiw-1
X-Mimecast-MFC-AGG-ID: iXO-0dmFMpWFtiBrwXWEiw_1757936667
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b0ea66f6811so116086666b.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:44:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757936667; x=1758541467;
        h=mime-version:message-id:date:references:in-reply-to:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uSHPRUFaXeFg56s3ZlnqQHiikskw++1DW2WVyVaExKo=;
        b=WwN7Rhg0hu4DBi9nD1cT+B9b5TdhUWnpEerpPdcEcDV5Xs84Cgcer8VtiH46zJnpr+
         R5/WJrQwh71YRB2DFilUoCOzVudk2Yt6fGWXGhD2QubAKNFdo0X0fUBpC9xZbXsYcy8i
         8pmjvtbrc+j0hgzAGuuNPwDXpiwS396V7cj/YvtNONs2fdoluzfcv3fyn06G7MxA+Wi0
         czZjHwyjp60NK7WsU7cNxGPpqSF+W2Ruw9EUWk1LirImD6a1lsIWpVWVElp7gfJmhTd+
         xnWT7CYUfwNo6UPqJp6dfkDfTdVZikTHEBog0YDvs/qQUlbvKINM3E3TrpVH9LiEHUeB
         O6FQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuhjIikeNjUvHFJlw24DMhObiDvGYMmk10auq6khp13P+y2l69rSVxO9ARCQS3odio5xYwTrIprQ==@kvack.org
X-Gm-Message-State: AOJu0YyRCaZcvzAQJUgiPGF6UhN+h4AzqBfU6S4ePNXZdyfXFEF7yyVE
	7+UzSzgJ6gAmz7Ma1W5EGLvG7/qikmnvLhqY3JPE2B43tAb9NR9TiXh6njA5+z0sRxWOvq7Dq/z
	oSBuwkL95QF1Z6utzwDlyr13YqSDxTuRXYnwtLJHCGRJS+c0gT2G/
X-Gm-Gg: ASbGncslSZcAiyMt1qSC8YbEcDoHM12yFkNcUud3FhtNC+eHG294tT+0oLOEk6U0XCT
	uelulIcvQja8W/tR+f4BX9/WGwjjI32v2j12utLxY5nqpHVJm03hPFeiWsmgId81BgqbKUNyIm+
	5zX5RBUJSwhxWkWpQapV4G7ikHXkfCjKka3qZJz3zst7K7TLPC0E06ipjA/DD4TtIGH4XpWbk5k
	w2zMD1UxujHjRsz0hZc0WKFanc9eGWhTbjGhZuhkyTFBBO+GVFpik4OLpD6/UnV4T8DXI0LeAwm
	EafkgpIkcZI2rS9dnKZcPvKPnScadDUBnoDp6IbHBSRh2woH5xVtkHcvAYhr9FZa
X-Received: by 2002:a17:907:3cd4:b0:b04:626e:f43d with SMTP id a640c23a62f3a-b07c386845emr1107738266b.47.1757936666846;
        Mon, 15 Sep 2025 04:44:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGP/rnaPf4TLpT9wQUB5MJEnJsUtYxAdTzEBrkYO+7lF79YJ4d63LszUhAd2mHJ20+wHOss3Q==
X-Received: by 2002:a17:907:3cd4:b0:b04:626e:f43d with SMTP id a640c23a62f3a-b07c386845emr1107735566b.47.1757936666370;
        Mon, 15 Sep 2025 04:44:26 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07b30da289sm914339566b.17.2025.09.15.04.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 04:44:25 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 9FC69215498; Mon, 15 Sep 2025 13:44:24 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Helge Deller <deller@kernel.org>, David Hildenbrand <david@redhat.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, "David S. Miller" <davem@davemloft.net>,
 Linux Memory Management List <linux-mm@kvack.org>, netdev@vger.kernel.org,
 Linux parisc List <linux-parisc@vger.kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>
Subject: Re: [PATCH][RESEND][RFC] Fix 32-bit boot failure due inaccurate
 page_pool_page_is_pp()
In-Reply-To: <aMSni79s6vCCVCFO@p100>
References: <aMSni79s6vCCVCFO@p100>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Mon, 15 Sep 2025 13:44:24 +0200
Message-ID: <87zfawvt2f.fsf@toke.dk>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tP8Za31D_FFwZR55xNRdNbhQrXekftAjH27BuCuld-w_1757936667
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Rspamd-Queue-Id: EC4ECC0005
X-Stat-Signature: tjey5rpcpwud3smc41zjmw38g8nonfpj
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757936670-706235
X-HE-Meta: U2FsdGVkX19Vvg6b5/1BN6m9E/4/USWQHKqSnmger2Q1RYD2LVFemFfSPCiUuCpilsS5OAoSNTn85onwj5/qhaDVb7l8QufxrOll+gF16S32poomusbaNSeG7vep7ob/9V5ZDTjRU3JYe24VTugywMDf0x2+mQYV9I2UB2uiUliWTx6bC4RGnzmlkGX2KYqeFTPDSuQhYR/Eo6BCzv0IAm76x/rWvVgaLaI8Tdn86waVf9K2JTnCmyek3MYksTDLraeCXmcvLqmAEcvU/ydXYa63PYcHAOmZRRhcoSevTY4IXVdK6Ajz9Es/iQA2Kztu3SFrLgdZdxEzuywJNSvwvhUKy3JPvngcPUEeQMTGfI9pHHIcmX/Xia3Z4Q1YaAQSuO/xj8EbqtVn4MO2KCEiTXDY/7RVMFVjJ/Ts3f/wa8KaXh2fSdkLYPMClIfMM5hRaqUFgbJg0vqqSHNbOKCZ3UZNRUEEQXkc7stqt79eym3LMOe/8SnVldzpG+bkJ/OUB6RrQ6UM0elZB3VoJ6X5vIphYyuKanZhyjgJng8WumiqL4RPv4F4G6xo1Kj+I/ZGORqDb7sOLX3Oug6zOG4osW/MJYDDFwBuAV4Aqm/aTzBoFiNlf0jjMVFtdY5TUHT5cFCINSnFJxIMIeJhLZ5qQ1FOz6He04Dv5OFc6WWbi9nhHi/EI6mgOrhq4e8qwgMcwyrEcTLzk7n/DcVzv7P69KyIuam1Q1quxur0Z25g1109YJ4F6xbl4GCOOos4aKD/TnFjoVsagsILkhc6mMGIC1Sd0rPVwqHLHciyczn1sAiaKGACNCE6D04jUTP9GX7SOUVahbihn6MZ8089bZRZ0ajvkYqpCraPhqTrllopzt09m+G7L52iSibyiWDLsgdGmjG02lOxAJVeEo/n/cD+u4Fxs7D96p35EsjZMgMTV/KjuNHjkCC7YXh25eGjsvLh+pYMD3UkY6TijZrpuFu
 MhgZBDrX
 YDN85kA9WPZDhAr4sKkJFzUxxgWIsijz/WVkJM160YXCa1VSLHLXXmUT+NjRwjTup3o60K1ajcUZqRtIzrzZqh82Bbf25hZMNOpmJIj+ub2lOclLFY1mdozAbUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Helge Deller <deller@kernel.org> writes:

> Commit ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when
> destroying the pool") changed PP_MAGIC_MASK from 0xFFFFFFFC to 0xc000007c on
> 32-bit platforms.
>
> The function page_pool_page_is_pp() uses PP_MAGIC_MASK to identify page pool
> pages, but the remaining bits are not sufficient to unambiguously identify
> such pages any longer.

Why not? What values end up in pp_magic that are mistaken for the
pp_signature?

As indicated by the comment above the definition of the PP_DMA_INDEX_*
definitions, I did put some care into ensuring that the values would not
get mistaken, see specifically this:

(...) On arches where POISON_POINTER_DELTA is
 * 0, we make sure that we leave the six topmost bits empty, as that guarantees
 * we won't mistake a valid kernel pointer for a value we set, regardless of the
 * VMSPLIT setting.

So if that does not hold, I'd like to understand why not?

> So page_pool_page_is_pp() now sometimes wrongly reports pages as page pool
> pages and as such triggers a kernel BUG as it believes it found a page pool
> leak.
>
> There are patches upcoming where page_pool_page_is_pp() will not depend on
> PP_MAGIC_MASK and instead use page flags to identify page pool pages. Until
> those patches are merged, the easiest temporary fix is to disable the check
> on 32-bit platforms.

As Jesper pointed out, we also use this check internally in the network
stack, and the patch as proposed will at least trigger the
DEBUG_NET_WARN_ON_ONCE() in include/net/netmem.h. I think a better
solution would be, as Jesper also alludes to, simply adding more bits to
the mask. For instance, the patch below reserves (somewhat arbitrarily)
six bits instead of two, changing the mask to 0xfc00007c; would that
work?

-Toke

diff --git i/include/linux/mm.h w/include/linux/mm.h
index 1ae97a0b8ec7..17cb8157ba08 100644
--- i/include/linux/mm.h
+++ w/include/linux/mm.h
@@ -4159,12 +4159,12 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
  * since this value becomes part of PP_SIGNATURE; meaning we can just use the
  * space between the PP_SIGNATURE value (without POISON_POINTER_DELTA), and the
  * lowest bits of POISON_POINTER_DELTA. On arches where POISON_POINTER_DELTA is
- * 0, we make sure that we leave the two topmost bits empty, as that guarantees
+ * 0, we make sure that we leave the six topmost bits empty, as that guarantees
  * we won't mistake a valid kernel pointer for a value we set, regardless of the
  * VMSPLIT setting.
  *
  * Altogether, this means that the number of bits available is constrained by
- * the size of an unsigned long (at the upper end, subtracting two bits per the
+ * the size of an unsigned long (at the upper end, subtracting six bits per the
  * above), and the definition of PP_SIGNATURE (with or without
  * POISON_POINTER_DELTA).
  */
@@ -4175,8 +4175,8 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
  */
 #define PP_DMA_INDEX_BITS MIN(32, __ffs(POISON_POINTER_DELTA) - PP_DMA_INDEX_SHIFT)
 #else
-/* Always leave out the topmost two; see above. */
-#define PP_DMA_INDEX_BITS MIN(32, BITS_PER_LONG - PP_DMA_INDEX_SHIFT - 2)
+/* Always leave out the topmost six; see above. */
+#define PP_DMA_INDEX_BITS MIN(32, BITS_PER_LONG - PP_DMA_INDEX_SHIFT - 6)
 #endif
 
 #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \


