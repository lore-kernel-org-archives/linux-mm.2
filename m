Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F41CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 17:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 918BF8E002A; Sat, 16 Aug 2025 13:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1228E000A; Sat, 16 Aug 2025 13:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DE358E002A; Sat, 16 Aug 2025 13:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E0158E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 13:13:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13FC2140451
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 17:13:45 +0000 (UTC)
X-FDA: 83783267610.20.A44CEA5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9FB50C0004
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 17:13:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MMixcwFe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755364422; a=rsa-sha256;
	cv=none;
	b=OHHMSrap6I4ACBJCAajB86oF9TGKoiGp99DbsMeaqWvQjR9SoWcCnIYt03qoNNwUpsMEfZ
	v0krLLN0aNJW5Cn6t5ICV04lhmARBRjxQiglznNnxdrsp8GGvSinIn5AXBmbJcgF0p/UIY
	n1eSWzTQVW7jAFfLPRjMr954sYptqbE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MMixcwFe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755364422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2cgk6Zbx0vB/BGOo5PYZi9awyuAzqjuvaL4aveRfbkI=;
	b=GIXTm5ikG2To9K1zIIToGI7FyzDjjJ8OLyvzVar+Zpvk1mxFlFBrrvo/v7t7klRL3+vO5f
	51ChZcSgYhQJGJ/3lziWHTUELOeXj4VbE3mM1pDaDedI1YtSA9skNksdq7JuhO/NN0OClp
	Mjr/gY4BoVuR5cjCd9fd6pPXmVIU8lA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755364422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2cgk6Zbx0vB/BGOo5PYZi9awyuAzqjuvaL4aveRfbkI=;
	b=MMixcwFenB2EpZI1KUgfG56KSj4YYuqNkB0y2lDqb73JyzbueCtJEKbzBKpdJhFivnp2RS
	iewbBaO3lKoCYavlOBAmIB7nCczyI1CWwybIL1PnExy8nIEM2nt0U5JT5LtR/COPzPK6ly
	rhzEcZN2/K1u6pIRCSKaY1xZ64Srg2M=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-fzD-a7DBNbu94f4sXPXLRQ-1; Sat, 16 Aug 2025 13:13:40 -0400
X-MC-Unique: fzD-a7DBNbu94f4sXPXLRQ-1
X-Mimecast-MFC-AGG-ID: fzD-a7DBNbu94f4sXPXLRQ_1755364419
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b9edf2d82dso1556425f8f.2
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:13:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755364419; x=1755969219;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2cgk6Zbx0vB/BGOo5PYZi9awyuAzqjuvaL4aveRfbkI=;
        b=GOQXlQiUPwZ9YgK+ypTExTerai5h2zjY5espIHl7jpp+bgbOPnRBM8xXNVCK+7mcBx
         aah7EvAd8Pa0QYBrny8HTQFJNKhQAJfiq76Dw9NjMKY15Qpq+fff+MkwfYDtKbgdwUpc
         WBZcdWqZ3VflviFJETUToYIt8+PhrHI4HDfBQD7eHKUNAoC6qo6G3QOlJy0QwRvxHObA
         kKNGDJ+CTlkF3lfDxt2vtFJhres1y7iaBvq9dvNBfzeEx15K6RmnKyYdXbV5sT1yKd8z
         hnId2B68gouizsdk/3fwpMklH0i+yEuLwc/41vTct8TfY2eRW77lPEry8SnUul7mVejz
         MBrw==
X-Forwarded-Encrypted: i=1; AJvYcCXNWyoXHaKrIBWdjORzI009ldHa6vSz0tcZaEI2A0XLW0oJE/E1IGUQ3QkZl3OoWiVBiYWyoSft0w==@kvack.org
X-Gm-Message-State: AOJu0Yy+j65oz7zNqBK4cxn+938bLAsxKtljozraAxIy5ofoFclfGAYS
	VvXBO8Rc4aD55N9KXCnuqtf7OBPzRd+Lr4MLxDB+5JBrd+hKiJdpwHLHJ1a0IomrxKzzZiw80PS
	mO0kecOjuYc2b1wAlTcrONT0ijnJMWCcQkN+ToF2KKyykoelZid1Z
X-Gm-Gg: ASbGncsDyQCAuzuQkWy+XVz82Sv/7bdJ7d0BgfZNyqZKw3NvVTDlwcVuyXkYzFYvPJm
	Qj9lmYxJCaFFbncuGwgy38eOp+wC0CjKxy7OFkUMLiluqudBCkKShlqUbZBpPyCO7HdHRBjbU2Z
	IfDj2MD1OFKiMT4X1pt0nIw69dG9xEiQWVPo6HiYNj4k4gJSpJnST9Y5xGwG1oBSW3ImJtn/C9Y
	kqi61X/RVmI3TwJc5UmFP1mWHG30SQmnrnAiT2Vbv8j5XsIBukbiNJbSGFsMwDQDwWLMR1qTZ+y
	Rjmh3tpNPZvYZ4rZsrOnilIHslMsqHSKBKfFNlsocxZWsAX6mvaoQJjnRlLOcyWlq836D0m/Kgv
	KUvnWbPeDGgD8Ow8OBM7aFxZDDHgkEGTtWzb7T8M5aRdo7ZyHtgHE9UA1gBQ4ezs1I0U=
X-Received: by 2002:a05:600c:1c14:b0:459:d494:faf9 with SMTP id 5b1f17b1804b1-45a28ff178emr9712035e9.10.1755364419371;
        Sat, 16 Aug 2025 10:13:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEF90eN2Nz0toFUZwAqn9DD5dp3Ri1E/8xuFSl/glYZ2CcKQtMM8PsgWaRo64HcVxwKlIeLsQ==
X-Received: by 2002:a05:600c:1c14:b0:459:d494:faf9 with SMTP id 5b1f17b1804b1-45a28ff178emr9711895e9.10.1755364419003;
        Sat, 16 Aug 2025 10:13:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1cc22739sm107942655e9.27.2025.08.16.10.13.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Aug 2025 10:13:38 -0700 (PDT)
Message-ID: <353ad5f3-2864-4f2f-bab7-5836aceb7f1a@redhat.com>
Date: Sat, 16 Aug 2025 19:13:37 +0200
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
 <9db98f7f-b90f-464b-ae7f-e94ac523bc28@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <9db98f7f-b90f-464b-ae7f-e94ac523bc28@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0HOeQ3xh1AcJpZb-8Oetc4Hwp99ube1Wll93mSh4Qno_1755364419
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9FB50C0004
X-Stat-Signature: t5kxrt5f1xrcmg7iw85c169suag6mhkj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755364422-885118
X-HE-Meta: U2FsdGVkX1/IpF/50ajB025QSwM2O8UrOUBogvx+nmMtxf4cK5qX72ao7fp6cDrXlhGfi7tszyc7pb8yGeGD5OHU3bSw3+CaWFmS2SRGrEXG3t7HOKNYrbaYI7H4fYoRVL3YZo1obVyznnsEfQeZIJLU/lwgqrj5UoZnyrFUkggtDTndqyE/ba6Zk4xE8wEx4BJsGFAUt0FRB1KH9gI9aNstK4ickEhWt9hjPXP7oAP+7M+nYHyh4zHCd2Kj1cUflomz/s+ZKPlukLt4npIcxT2iyrmt9PmQVP4aJfJkQnLetCQ43NPXE5qZX93SEBc1iX89rxqGiTgBTSfp1QoIGMzJYM8vcwYDLi2s4bjMl4qHJvGJTlzkD0xcxVgcOWDWi6upjB3P7rqJVU9R0QdRKOhk/rNohEAZyq44+b7bkeA2G086T92C06Y22tuYIssPmBXdA9H/3rCeycsQTSn2FTll5u/EKahysf7EIaWxP4W1ufkbURU1flE6DR+XvrUSh2IQnkuupoOkuZVJ5wcY0HES4hnGZh4KDb36a6X1ng+9WGa+zNHppSzZnJ7expKW/oA+Z/39NG66D9QB7iVqhGHee3Yg1G2IniToyAhcB8Ps2Irp7wOe8JAHnb4/lgWYstT1lNHvF+B39Iwz2y3v2HC2tL+hVWGTyPKUbgrJgdpI8O7qTW5f7O1B0+4MgCe99ALq7gagCIv4qHdjAQ48yyAWY9p1Q+0F2qC9HEFhEqYNaeo/v24XDO+nqlieptErapojE3R07Q4XEjkHbY8KDm7dkuULBm6D3+ELwJsnAMSell/XCJM88X8iyVaUO4qoNP6gh6qTLYcSx5fh5b8kW2nWoXRj//2oGCz1+YTBtAx9cajCkkvMO+hJ0qXB2wJVDMyz94GNqQmEjNQkN8nJRPsSICAc117YRrx1EULmq6/ArDTBNd4xWMK4IaFZl3qI8BbdTh30abSreDCYJni
 M4McSrrY
 S7xG6Jm0fMunhX04VPQ93oWbl8eldOpFozk8Vw/DHz4g1BTot0iX7bAboBHbcuVxU4xWnC3jAj0SYEJu0HzjZmM1bLZenwCIsSfeGWHoIYNRUi7bLBuZhJsYa35avhM6QwSCCZP9wjNwEsNwZaViN9WB4oPbJ+nHQJSpyzy4i4l5NEW2VyFHDPT4dF3pTS79ANDpur+WFoeikVGHKRYm80/NMdoLCrLrYiPz4TXXGUdB1OclSuV+HaCdGK3oU+h8RFlK+ryqgFIaSIYWkJakU6R+40vtmRjCg6lBsPm9C0QCgUb3WeT+6TeEo/l0WPlNdR40TzdalEG4kWyfzWAoKYTxx7cDFxHT9fqg49JFQsm2ZfGV9WYFgR4klbiDFGRc4IkzGCzHKgpb7YNXMZ+8w0KfgrVcVh9mmFYaFGIscOduiyn4W2HCoCW/tMDPGrs5lx5JyIUCysrCBc/p5jv2V2MJEyBzWakL0AK4KqvxvMPEmZ80tOU3WABwiAujbVLs6/Ue7wrgaIcmzuBEkDpewLMtBFR2lDXerpQb7/lH2J5J2MrScVbv21/scva0f+K2GASo7MCN+XMAGUi5XBpcTEwp1KloLm/2sY5/N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
> index a1d2625b5c391..c391435ce9942 100644
> --- a/mm/balloon_compaction.c
> +++ b/mm/balloon_compaction.c
> @@ -256,8 +256,10 @@ const struct movable_operations balloon_mops = {
>    
>    static int __init balloon_init(void)
>    {
> -	movable_ops[MOVABLE_BALLOON] = &balloon_mops;
> -	return 0;
> +	int rc;
> +
> +	rc = register_movable_ops(&balloon_mops, PGTY_offline);
> +	return rc;

Staring again at this hunk, the temp variable is of course not required 
here.

-- 
Cheers

David / dhildenb


