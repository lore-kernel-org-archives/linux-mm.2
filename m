Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A732CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 10:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F161B8E001D; Sat, 16 Aug 2025 06:55:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEE8E8E000F; Sat, 16 Aug 2025 06:55:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8EB88E001D; Sat, 16 Aug 2025 06:55:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C05948E000F
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:55:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FCFA1DD063
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:55:00 +0000 (UTC)
X-FDA: 83782313160.20.1E28C98
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id E5F3814000C
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:54:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IjxPuWaO;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755341698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ZH0BQKmTRqhky0GTh74OwMstz3trn3Zg/lANlIaP7s=;
	b=zc0+YqYhYRZYr18N6NnY+N/g2ZFrZY+MhpQr96GiR5GErP0WhfeLaR63VJFU0+BaqOkikT
	KfM0ZEQ/OS8YTMWVst90bgaq9e5uceRtsE0Gu4TIF3CttwizJfsVT4w7vLm5rXUVjaiEro
	LtyezjULo3gUDAdsDEXtDOvgZcWxBJ4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IjxPuWaO;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755341698; a=rsa-sha256;
	cv=none;
	b=xy4uQC3gsv61llftpssw/jVBqA5R6Pa9/eTogk4rJ+kpUiwsBrkTV1rRiVZX8jZQOUgTbx
	/p1IpYsUKLsyPwK/A1aVlmnWARa47XT6kNOWhUhfZaLl1l2qy8MA4vCh8Z1oqLSmm/Wrcd
	xSLi4vZc0hvSlptNFVnF/kBReSbxafo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755341697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6ZH0BQKmTRqhky0GTh74OwMstz3trn3Zg/lANlIaP7s=;
	b=IjxPuWaOmdVNvO+8ZJy4PhRTPOymb1wC+2SE0dy5z/6BMIqsg8JSA5732sVA6jUuEFUEWK
	koiWqVaqyUYUs71cOAm49dQMTr6kA0qUrMPi7PVjlISLbzyX8h58H8qnIwvB9/QN2Dl1Sr
	aue2Wx2ygvl1VBkWKWTeYCbgffv/8k8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-ZWL4bl6UNwme-kGMva4utQ-1; Sat, 16 Aug 2025 06:54:55 -0400
X-MC-Unique: ZWL4bl6UNwme-kGMva4utQ-1
X-Mimecast-MFC-AGG-ID: ZWL4bl6UNwme-kGMva4utQ_1755341695
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-afcb7915405so199602266b.1
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 03:54:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755341695; x=1755946495;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6ZH0BQKmTRqhky0GTh74OwMstz3trn3Zg/lANlIaP7s=;
        b=qY3rMw6rYxHgiLe+gvbYaiZhL2aF+e9XjpOXk0LxD89WrEQv8QTBeCd0qgpWfJwAkz
         78OsVgk5+64PlkQzfFe+ODRAfV34BEb8xle4OibKJgnLj6FPvvRawV0N9zM+oDvLlIDn
         olIHmYgmRqJYJKsliX0aULSHyLUiEf6ic/DRyLygmht4PCRvjyUbRvtQBGUhK32lywn6
         HU2mAoAq1/vxEK0KAZFGFSjbWw5juYYFd5b2AlDv6iRBNpfsxCOftJ4j/nKWqRQ9awx0
         uawASghaeqPFWbjJYeSC6zROaGKuGBaqY1kMDq9Vhq1H2EztrLoasCYQo7cLGke73tFK
         0z1A==
X-Forwarded-Encrypted: i=1; AJvYcCWqj6atRcFvM23eIXlrIiM7aUFjhBpp6QYlfWjbaduopxS7HWJfKulokLq57NCfdg4aQmRBcIrSnw==@kvack.org
X-Gm-Message-State: AOJu0YzFo5gnBkjuCP0qmC5pPRw9A0siyHITMGV2XBJ/s0M3e9r8QdeE
	VwlJVXZ51XQ91SlKjCHDcMFySDuFRb+Qn9czdnUe1RA98AqV1uNuH1L280BJBsreCRxAph6Wr1H
	KJKdD7y+OMiCZAPH0mv3liOFLNdFewW5vK94f98op/kYRC+2EXcgv
X-Gm-Gg: ASbGncsT6IDLZSjl5VPJlZQPPSqAE61KS4cEhmS9PoxJPeQGbvN2oNaRr0PhimruorP
	u4xcL5y4qwL2eOqL9a8awBwZnEB2biul165Gpc7vG/HR14bSKxaV0KrOTeHhMZiXTwQiIfplO4E
	q8gz9xfuZapSJMPWM951Iyc5xO51WlEgcAwn5+psNhEyidGSmAPVcv7tK8wYkhppRILj2p/vIAM
	XEnzDaMYpKVD/7BK/6YPI/63CFj6DdanVLDCr4xJ1lG837Po+EZ59MTfbpp54WAE+fmoeYVDMWD
	9zlrA0t9QJazxOTU4B9qpPuRdjCPWYkktFaWjzjtwD6gDn6ivgX+OINDEnB+uVGJmG+RetHSg22
	8qNjJArS4rkrZQDuz1TSPFha0zOk0NwnljcjXbDe83L82YhjJjmowmNMTcXpnC2hAyMQ=
X-Received: by 2002:a17:907:7fa9:b0:af9:d705:9f19 with SMTP id a640c23a62f3a-afcdc28bb9fmr506254066b.17.1755341694473;
        Sat, 16 Aug 2025 03:54:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6ozjGD/S/nhj1VM/Ur/6pJGOrZahQiMasXYPdrBY42V24LwVXORInLQLCcUNrc13VhcJAHg==
X-Received: by 2002:a17:907:7fa9:b0:af9:d705:9f19 with SMTP id a640c23a62f3a-afcdc28bb9fmr506250866b.17.1755341693930;
        Sat, 16 Aug 2025 03:54:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdcfcacb7sm354291866b.75.2025.08.16.03.54.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Aug 2025 03:54:53 -0700 (PDT)
Message-ID: <9db98f7f-b90f-464b-ae7f-e94ac523bc28@redhat.com>
Date: Sat, 16 Aug 2025 12:54:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
From: David Hildenbrand <david@redhat.com>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Huacai Chen <chenhuacai@loongson.cn>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, linux-kernel@vger.kernel.org,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 "Michael S. Tsirkin" <mst@redhat.com>
References: <20250815090539.1578484-1-chenhuacai@loongson.cn>
 <a20d605c-79a0-4d89-985b-9512a990b492@redhat.com>
 <CAAhV-H470h2HDEN_NY2qNBxUqQrSRQhLzwqZe9PB8GjnNsZVFQ@mail.gmail.com>
 <66ebc632-6704-4637-b62d-1cb11e5a4782@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <66ebc632-6704-4637-b62d-1cb11e5a4782@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7I1oc4eot3LTY8Eb_zb5AhwwrHNqFCjGD2AUV9NLglI_1755341695
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E5F3814000C
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 84xey685658jan73rgs4gxn3drn5jbth
X-HE-Tag: 1755341697-135174
X-HE-Meta: U2FsdGVkX1+vCBFiUZnTEIFcoZ0vPuCFkU94r1flattJ9Z5OHZfVWgIYbPfv/L27tb6IvuzFhqfFPIWGylNgwIId0iG2+w3Iw2FwVPAytMqCir3Tbh265B0T1GwwqsZoWRZND8l/exScpvER6YK6Bvt5lK4ydpLif4/ULSwkGltMWFNHIr36cMoxyyKAk2IrGszkOyMLEbPkU2d1FY4pL9X9FW/y5aUrZGeJPHDkyisxYVg4Fge6JDXilqu8luklh7HP9XZ3tWcz7oHgounyjlMnCCuAHu6BNApTNq+ItJ+F2/kvfozj7nQo+Nj4caZ+Qm+y8AaEtQ+hICCVnKzAj8OCOFs2PnDPdeKr3n8IStdGCdQPMjbc8mm2ODlcbrYhz4Lr4CZ5mJAivwB1EjcdI7Cjhn/fmjVi0jQ1P8IeozPz/NyOD1Y9bMAj+48cxmGGtokJSGMhTtvzhURH2kwssISfFuiyQQoGYXCRHZukIMBaCOGujZLQYnP77nNv2GtATaxh/syWJvwVShWbhfCVg8RisnSSYhHoN3qCPTWWu5KQAvJrqho1CJBY7BPEdT1eUOrKb28hfmopA2HXVr6OUYmYYOFMGaA8I7oDNYtqR3AvePCW6z3JkRFZXn1ZSplWujWjCLv1eFzrp4mTy11V3pg5KKv0dcsbJLZzC4UHQrT56m6TZ+K8LM+R1+3c7jy8M4JUWr7hyKUnLg5o1YPCHSI18Vy5iyTgj4aQ4HxUcmNza8/P4Dd1aAzmB7LmlOo6BZaxxR1Lm/R/nozGkSDdOh0uVSIbgExtMWIkLUQQhq5pVh7zkhEQn8V4sMyv/CbSNCSLL3fa6Hrop7uo3xXO79fsTsWSfLzLXxzSfzI37fmXio9CbKFuC7irayf/yKAzVp4zbGKTbub2gpgI89VD+g4R4cIU0d0RjIcKmR3K407IitKgrZ0wiBXYNdzsPTWLCN6SPBkc9a5Zyf0etlZ
 gDygmzPs
 S7OO2du7k56oMCFxh6mfuRSfZT7g9l2+pQuyAJRSVw5OS3KwbhxhPNDrxUwmKq5Atogmdzu+hGisML/yNnvAvi4GoT2oeCUvQHXMAYcMDTKAdP9KwPpGT39hxJxKWZjF5XZ/gg8gsMpHwgKImbJhW0fTCA3mEEAbbUw/AAMU4VintUKTG59w47t79ZNuz4RMnMy5v8UkhGZoMFRylP3sHBBMkVZxlHZ+31MgkTZ7mjxeysQbwsfd4QoyOKy4Jpnv7eEkB/uLIwS3/NExgt+JVPSzELuCygdy2t8hjZK0AYfwcpSP1RNaMDYSw3yz4Ppq+NLgb6S4J+QZX4eR87SX46/CBbVk2LS8OAqBaRDB9QmqfIyQOlwqoJd+pUwPhyoP66hAc9zZMV8L9FrdK8M5MfY+gemAZf6ViNy9FANxA9czfKLymTscVyM+v5cFOP5tUFRiwKMZ96FyttvzUo6ThErmKmY0MMP50BnE6v9XhOcWpw44=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.08.25 11:01, David Hildenbrand wrote:
> On 16.08.25 10:57, Huacai Chen wrote:
>> Hi, David,
>>
>> On Sat, Aug 16, 2025 at 3:22 PM David Hildenbrand <david@redhat.com> wrote:
>>>
>>> On 15.08.25 11:05, Huacai Chen wrote:
>>>
>>> Hi,
>>>
>>> please CC the appropriate maintainers next time. You missed (some)
>>> balloon and zsmalloc maintainers.
>> OK, thanks.
>>
>>>
>>>> After commit 84caf98838a3e5f4bdb34 ("mm: stop storing migration_ops in
>>>> page->mapping") we get such an error message if CONFIG_ZSMALLOC=m:
>>>>
>>>>     WARNING: CPU: 3 PID: 42 at mm/migrate.c:142 isolate_movable_ops_page+0xa8/0x1c0
>>>>     CPU: 3 UID: 0 PID: 42 Comm: kcompactd0 Not tainted 6.16.0-rc5+ #2133 PREEMPT
>>>>     pc 9000000000540bd8 ra 9000000000540b84 tp 9000000100420000 sp 9000000100423a60
>>>>     a0 9000000100193a80 a1 000000000000000c a2 000000000000001b a3 ffffffffffffffff
>>>>     a4 ffffffffffffffff a5 0000000000000267 a6 0000000000000000 a7 9000000100423ae0
>>>>     t0 00000000000000f1 t1 00000000000000f6 t2 0000000000000000 t3 0000000000000001
>>>>     t4 ffffff00010eb834 t5 0000000000000040 t6 900000010c89d380 t7 90000000023fcc70
>>>>     t8 0000000000000018 u0 0000000000000000 s9 ffffff00010eb800 s0 ffffff00010eb800
>>>>     s1 000000000000000c s2 0000000000043ae0 s3 0000800000000000 s4 900000000219cc40
>>>>     s5 0000000000000000 s6 ffffff00010eb800 s7 0000000000000001 s8 90000000025b4000
>>>>        ra: 9000000000540b84 isolate_movable_ops_page+0x54/0x1c0
>>>>       ERA: 9000000000540bd8 isolate_movable_ops_page+0xa8/0x1c0
>>>>      CRMD: 000000b0 (PLV0 -IE -DA +PG DACF=CC DACM=CC -WE)
>>>>      PRMD: 00000004 (PPLV0 +PIE -PWE)
>>>>      EUEN: 00000000 (-FPE -SXE -ASXE -BTE)
>>>>      ECFG: 00071c1d (LIE=0,2-4,10-12 VS=7)
>>>>     ESTAT: 000c0000 [BRK] (IS= ECode=12 EsubCode=0)
>>>>      PRID: 0014c010 (Loongson-64bit, Loongson-3A5000)
>>>>     CPU: 3 UID: 0 PID: 42 Comm: kcompactd0 Not tainted 6.16.0-rc5+ #2133 PREEMPT
>>>>     Stack : 90000000021fd000 0000000000000000 9000000000247720 9000000100420000
>>>>             90000001004236a0 90000001004236a8 0000000000000000 90000001004237e8
>>>>             90000001004237e0 90000001004237e0 9000000100423550 0000000000000001
>>>>             0000000000000001 90000001004236a8 725a84864a19e2d9 90000000023fcc58
>>>>             9000000100420000 90000000024c6848 9000000002416848 0000000000000001
>>>>             0000000000000000 000000000000000a 0000000007fe0000 ffffff00010eb800
>>>>             0000000000000000 90000000021fd000 0000000000000000 900000000205cf30
>>>>             000000000000008e 0000000000000009 ffffff00010eb800 0000000000000001
>>>>             90000000025b4000 0000000000000000 900000000024773c 00007ffff103d748
>>>>             00000000000000b0 0000000000000004 0000000000000000 0000000000071c1d
>>>>             ...
>>>>     Call Trace:
>>>>     [<900000000024773c>] show_stack+0x5c/0x190
>>>>     [<90000000002415e0>] dump_stack_lvl+0x70/0x9c
>>>>     [<90000000004abe6c>] isolate_migratepages_block+0x3bc/0x16e0
>>>>     [<90000000004af408>] compact_zone+0x558/0x1000
>>>>     [<90000000004b0068>] compact_node+0xa8/0x1e0
>>>>     [<90000000004b0aa4>] kcompactd+0x394/0x410
>>>>     [<90000000002b3c98>] kthread+0x128/0x140
>>>>     [<9000000001779148>] ret_from_kernel_thread+0x28/0xc0
>>>>     [<9000000000245528>] ret_from_kernel_thread_asm+0x10/0x88
>>>>
>>>> The reason is that defined(CONFIG_ZSMALLOC) evaluates to 1 only when
>>>> CONFIG_ZSMALLOC=y, we should use IS_ENABLED(CONFIG_ZSMALLOC) instead.
>>>
>>> Ouch, I missed that CONFIG_ZSMALLOC can be configured like that. I
>>> thought it would always be builtin.
>> Make CONFIG_ZSMALLOC be bool can solve this, if you think it is reasonable.
>>
>>>
>>>> But when I use IS_ENABLED(CONFIG_ZSMALLOC), page_movable_ops() cannot
>>>> access zsmalloc_mops because zsmalloc_mops is in a module.
>>>>
>>>> To solve this problem, we define a movable_ops[] array in mm/migrate.c,
>>>> initialise its elements at mm/balloon_compaction.c & mm/zsmalloc.c, and
>>>> let the page_movable_ops() function return elements from movable_ops[].
>>>
>>> Before I took that easy route to just get it working quickly, I
>>> envisioned a proper registration interface. See below.
>> When I found I cannot access zsmalloc_mops in a module I considered
>> the registration interface. But in this case I think that is an
>> over-design and not straight forward.
>>
>> Moreover, a registration interface looks like a redesign and not
>> suitable for hot-fix.
> 
> I think you misread my message: This is not debatable.
> 
> If you don't want to fix it properly, I can send a fix.

FWIW, something like that on top of your patch.

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 58fac171e4d50..4c9b5bcb63ba9 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -57,12 +57,6 @@ struct movable_operations {
  	void (*putback_page)(struct page *);
  };
  
-#define MOVABLE_BALLOON		0
-#define MOVABLE_ZSMALLOC	1
-#define MOVABLE_MAX		2
-
-extern const struct movable_operations *movable_ops[MOVABLE_MAX];
-
  /* Defined in mm/debug.c: */
  extern const char *migrate_reason_names[MR_TYPES];
  
@@ -85,6 +79,10 @@ void migration_entry_wait_on_locked(swp_entry_t entry, spinlock_t *ptl)
  void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
  int folio_migrate_mapping(struct address_space *mapping,
  		struct folio *newfolio, struct folio *folio, int extra_count);
+int register_movable_ops(const struct movable_operations *ops,
+		enum pagetype type);
+void unregister_movable_ops(const struct movable_operations *ops,
+		enum pagetype type);
  
  #else
  
@@ -106,6 +104,16 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
  {
  	return -ENOSYS;
  }
+static inline int register_movable_ops(const struct movable_operations *ops,
+		enum pagetype type)
+{
+	return -ENOSYS;
+}
+static inline void unregister_movable_ops(const struct movable_operations *ops,
+		enum pagetype type)
+{
+	return -ENOSYS;
+}
  
  #endif /* CONFIG_MIGRATION */
  
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index a1d2625b5c391..c391435ce9942 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -256,8 +256,10 @@ const struct movable_operations balloon_mops = {
  
  static int __init balloon_init(void)
  {
-	movable_ops[MOVABLE_BALLOON] = &balloon_mops;
-	return 0;
+	int rc;
+
+	rc = register_movable_ops(&balloon_mops, PGTY_offline);
+	return rc;
  }
  core_initcall(balloon_init);
  
diff --git a/mm/migrate.c b/mm/migrate.c
index ee65d8787e95b..d69c9f7c27800 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -43,8 +43,6 @@
  #include <linux/sched/sysctl.h>
  #include <linux/memory-tiers.h>
  #include <linux/pagewalk.h>
-#include <linux/balloon_compaction.h>
-#include <linux/zsmalloc.h>
  
  #include <asm/tlbflush.h>
  
@@ -53,9 +51,49 @@
  #include "internal.h"
  #include "swap.h"
  
-const struct movable_operations *movable_ops[MOVABLE_MAX];
+static const struct movable_operations *offline_movable_ops;
+static const struct movable_operations *zsmalloc_movable_ops;
  
-EXPORT_SYMBOL_GPL_FOR_MODULES(movable_ops);
+int register_movable_ops(const struct movable_operations *ops, enum pagetype type)
+{
+	/*
+	 * We only allow for selected types and don't handle concurrent
+	 * registration attempts yet.
+	 */
+	switch (type) {
+	case PGTY_offline:
+		if (offline_movable_ops)
+			return -EBUSY;
+		offline_movable_ops = ops;
+		break;
+	case PGTY_zsmalloc:
+		if (zsmalloc_movable_ops)
+			return -EBUSY;
+		zsmalloc_movable_ops = ops;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(register_movable_ops);
+
+void unregister_movable_ops(const struct movable_operations *ops, enum pagetype type)
+{
+	switch (type) {
+	case PGTY_offline:
+		WARN_ON_ONCE(offline_movable_ops != ops);
+		offline_movable_ops = NULL;
+		break;
+	case PGTY_zsmalloc:
+		WARN_ON_ONCE(zsmalloc_movable_ops != ops);
+		zsmalloc_movable_ops = NULL;
+		break;
+	default:
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(unregister_movable_ops);
  
  static const struct movable_operations *page_movable_ops(struct page *page)
  {
@@ -66,15 +104,10 @@ static const struct movable_operations *page_movable_ops(struct page *page)
  	 * it as movable, the page type must be sticky until the page gets freed
  	 * back to the buddy.
  	 */
-#if IS_ENABLED(CONFIG_BALLOON_COMPACTION)
  	if (PageOffline(page))
-		/* Only balloon compaction sets PageOffline pages movable. */
-		return movable_ops[MOVABLE_BALLOON];
-#endif /* IS_ENABLED(CONFIG_BALLOON_COMPACTION) */
-#if IS_ENABLED(CONFIG_ZSMALLOC) && IS_ENABLED(CONFIG_COMPACTION)
+		return offline_movable_ops;
  	if (PageZsmalloc(page))
-		return movable_ops[MOVABLE_ZSMALLOC];
-#endif /* IS_ENABLED(CONFIG_ZSMALLOC) && IS_ENABLED(CONFIG_COMPACTION) */
+		return zsmalloc_movable_ops;
  	return NULL;
  }
  
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index ef95cf8c6af90..fcb4f2c599708 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -2246,8 +2246,12 @@ EXPORT_SYMBOL_GPL(zs_destroy_pool);
  
  static int __init zs_init(void)
  {
+	int rc;
+
  #ifdef CONFIG_COMPACTION
-	movable_ops[MOVABLE_ZSMALLOC] = &zsmalloc_mops;
+	rc = register_movable_ops(&zsmalloc_mops, PGTY_zsmalloc);
+	if (rc)
+		return rc;
  #endif
  #ifdef CONFIG_ZPOOL
  	zpool_register_driver(&zs_zpool_driver);
@@ -2259,7 +2263,7 @@ static int __init zs_init(void)
  static void __exit zs_exit(void)
  {
  #ifdef CONFIG_COMPACTION
-	movable_ops[MOVABLE_ZSMALLOC] = NULL;
+	unregister_movable_ops(&zsmalloc_mops, PGTY_zsmalloc);
  #endif
  #ifdef CONFIG_ZPOOL
  	zpool_unregister_driver(&zs_zpool_driver);
-- 
2.50.1


-- 
Cheers

David / dhildenb


