Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 309F8C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 09:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456CD8E012F; Wed, 27 Aug 2025 05:15:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4066A8E0105; Wed, 27 Aug 2025 05:15:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CE508E012F; Wed, 27 Aug 2025 05:15:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 125B58E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 05:15:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE00EC051A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:15:04 +0000 (UTC)
X-FDA: 83821978128.02.FC6606A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 786FBC000B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:15:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pch5YCGy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756286102; a=rsa-sha256;
	cv=none;
	b=o1WjmqcP/eYxmYs9xh2iTuI3TOmN9k1utY9fU5+ReCQFly8vvoYIQIyep8xmMH/AGCPpWW
	mcb0b6gdElJ2MblpWyxBEpd7+fr7SvKDg+mc3gCVCXE1aDL1ZvDhr5s+6md5cYYrT+cYzi
	bsyXYySkmI2M48K+ge5V18oMMYznHug=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pch5YCGy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756286102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JFYArG1HJZsUAczDlyYIIUDn+FFv+3hnPLzf8oxcMao=;
	b=X+GGLpECmoZuvDh1OmL8D1zNTPmydQeNVg0aFJ8zwvjJnh3e+xzI38Zty+Yw6ZB6MldKMA
	RX0g7IQ8JmIWFsgFlUmm/xpJNXVinc8cNRxlJ4GCbgjhIg6nLlSyq7/AcD91lP94uL+raX
	1BAbEQaJRPcky5lFrgbkY2jbS4QJ7Cg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756286101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JFYArG1HJZsUAczDlyYIIUDn+FFv+3hnPLzf8oxcMao=;
	b=Pch5YCGy+Cbt1P6cpO44bvFFtj7RQr1w/U6TxKkPDQeLQlKpGFrzuzauMD+ZRaPCKT8Egi
	GovsLujyS8WMLLihcqCNfb1ODHwituHHTHi7x1WgoJ7XumMrinLoRs9DWTXSC3fFBDgVGi
	OxZBKJe7qbqw17oTL7TYN+anaucUNro=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-aiDE6ZTuOmuIHRuk91N-zw-1; Wed, 27 Aug 2025 05:15:00 -0400
X-MC-Unique: aiDE6ZTuOmuIHRuk91N-zw-1
X-Mimecast-MFC-AGG-ID: aiDE6ZTuOmuIHRuk91N-zw_1756286100
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4b2f9e8dca6so641621cf.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:15:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756286100; x=1756890900;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JFYArG1HJZsUAczDlyYIIUDn+FFv+3hnPLzf8oxcMao=;
        b=Jrq/7QDM0NEQB6IzQgzFMNnXMrRFn6/bnTlRvSWnqE5/hZ/ja6ClzSlRI7HtQqvAhZ
         BNJbSyR54n260MF4uudezXjAPoPYB1KPAkcz0i19hkgNEvJKrCZK0DiyF4tTtGpXxJvQ
         HdjPLqR8BdQmJrAO2vWSqbWrKJqzwZ5wdGEr2dPaeoVDzL49CMCYpxrPcwzc+nugGQ0B
         NOlVNPQdQOWZIY0WXUxiY6UPoVaYihWrCA7Va72ASLdRtzVVGanXq0Bw7YkDd6AmRfLa
         3VxQJzcvBv+4FQph18VzTzj2q77RRkRp6XcoModAoubnodRkcNdkMcUGXk9Sr8Cf4vGb
         bxgg==
X-Gm-Message-State: AOJu0YxoTwbuDMRipTX5vhi+W/ZUK+rqQMyUHAB87isz2bdyk/DXmBcu
	9JlG4HGe7UcTyUZ1NaGlwEayYbFXDkAixpY2iM1qtZmXskWFz/rmaKmiCHa7qw9F5dXpUsb4azv
	NdwYLiv43qy50ufWfwCMOfk/AYUAzE13JFuj5t5SuWVRzb5yqcN65
X-Gm-Gg: ASbGncu0j0dVR6bhJ2l4OD8kFCw1WUpDZ04W1/kC9i/J3ey6c5PI675x/DBudj7MbzH
	01KGRiLDssGYKeyFECeroe2Cuw6+bRZOEXb4drYOkqwRGL0/BU4D698eztfAe4uGaL16E2/Ux1q
	0L4MmToivICx8AukxCyqF0J1O4KG5hmomeCvugLA75IFraBaLJSfnEFgX2BvfT9VcZjEF9EDjrE
	/5bYQidMfbAvVf+wxKBB0mWtA0Z2nHXe8j4pDb27uuTkxGbfm3lnGZVYxHLO428jGxm8R5co+V8
	gbRIYbapoYMHlLELiS2SF/j0ONEgDHbag56BJ2y2YJSY72B+zEybelHlANQP5g==
X-Received: by 2002:a05:622a:54e:b0:4b0:ead9:97fa with SMTP id d75a77b69052e-4b2aab050f2mr226856641cf.44.1756286099850;
        Wed, 27 Aug 2025 02:14:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9jkF62DqJ7HOEmD8rIQ+BRG3yjmZsBt0WHPem24PuhV2ZxmNM4ZLQXxcDZZAOAiBfzvjd6g==
X-Received: by 2002:a05:622a:54e:b0:4b0:ead9:97fa with SMTP id d75a77b69052e-4b2aab050f2mr226856401cf.44.1756286099411;
        Wed, 27 Aug 2025 02:14:59 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b2d4d048bfsm55006761cf.53.2025.08.27.02.14.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 02:14:58 -0700 (PDT)
Message-ID: <6dd69fbb-b043-4c18-be14-e9f70b6c0c06@redhat.com>
Date: Wed, 27 Aug 2025 11:14:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: make folio page count functions return unsigned
To: Matthew Wilcox <willy@infradead.org>, Aristeu Rozanski <aris@ruivo.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
References: <20250826153721.GA23292@cathedrallabs.org>
 <aK4EOf-EE43pi-xq@casper.infradead.org>
 <a959a7f8-20c0-4c2a-9cef-ffad4f8b805b@redhat.com>
 <20250826220041.GS3581799@cathedrallabs.org>
 <aK5daUurTM8ET2gf@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aK5daUurTM8ET2gf@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: P59wMz2I_mbybP7xL5b5ysm8RbCxQPRbXJQ66F07Vm8_1756286100
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 786FBC000B
X-Stat-Signature: enit19ejyg7djqnpugbtqpyh6r941psn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756286102-68062
X-HE-Meta: U2FsdGVkX19teMiGF0QcOiAvRyoxRY36OU6W+icYFANeXiB7qSPLUz1bdVbfKPrSYwzHMd1hRKolocujoUFDIrJ7GjApMdY+Y2Ijz/N6iaObODOl5VJv0bquzNo4KiYk9XKbpTFwjcEVMTueDfemYgS6jiJz1f9q/uduNLsy+osLwnTNru7om8+DWCl9CEEsNlqsiStAv1L+wErjeB3j2JYWsk0p9PQPUxKPWXg7D2XNI2spjvl8BvYacD4o2mZRMyQbTxQw52RIl6fn/XbAFPjZfXn8u+NpdgBOjGE7xDaVUP2DYCDwgBCkgo6T9xGxm03+EZTo86U65vf74qP9r3H8iPPJTpxm0OIFsS6FQwxnv8p8SCZp2Lm8P+pAl6dfmpyEnnaW29upu5tgl87PYvqHKXyC9Aex+5JaDARsHgG5mY5Z1Xg+09SBX7w4f/Rs+LoQ94PxPquW9vin81eXwTsTcqKRo533IqvpP3FAz6ilm3lw31h+oKz5SYeyAyscDoQC52mXZ6MOT4i/wsHrrOF7hcelqHtkWv4ezQOCTIbmrvdVZcQUTQq9RWaZzbjiFYrAf3rlBD1dtiSgfYsI0VeLTuXgw/dtRwanfftgfXm/KDeoJyoRuy6PcNb7DKLBVTl2zi5tzuA9MILp342OIHGpNJdYx3PQvW7JjeOIJ4VYIUKymbGQHNW79qdHjeqJCd3NQzCq4idu9LfjR2a+ciHTPtV1rbek5A6mNDWrJFe5k/n5plYw038wAgB/0m1LEfIfccxFksZ0hVL4o1qtWXK7qvTL2ucrJmzIpLIAWKrwGb1+fOhtxQav3sgllSx21LO2nfkkvwRlRjhfHhAaOd97IOrXNpXacOxVEdSWuM+XA8lzwTZg6FfVSzmBdzwnabHbufhfSpmLIC349H2nPI80oKNecNqrdu5RxHu+GSvC4Mrz+rxU7hfIugRilokOHKbWjIYBwVD3FYM/Fga
 490NJAQJ
 eMAQYov6787op+LxbhJ5Nh3HZ4+SRhuW2b0xBEySpwhxsaIUB098L7+VIalEx7hm0Ogr+OIi/KGG02lhJRre+sbzTWnTe2bso0hyS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.08.25 03:20, Matthew Wilcox wrote:
> On Tue, Aug 26, 2025 at 06:00:41PM -0400, Aristeu Rozanski wrote:
>> some actually expect an int (e.g. memcg1_charge_statistics()), it'd be a good
>> idea to get those fixed.
> 
> Yes.
> 
>>> Then, e.g., -1 will be (unsigned int)0xffffffff, and casting that to
>>> "long" means trouble, because we wouldn't sign-extend properly and get
>>> (long)0x00000000ffffffff.
>>>
>>> Using "unsigned long" instead work perfectly fine.
>>>
>>> e.g., -1 will be (unsigned long)0xffffffffffffffff. Passing that to a
>>> function that expects "long" or "unsigned long" works as expected.
>>
>> We could run into problems if folio_nr_pages() ever returns an unsigned long
>> larger than LONG_MAX :^)
> 
> I feel comfortable saying that we'll never support a folio size larger
> than 2^31 bytes on 32-bit or 2^63 bytes on 64-bit because folio_size()
> returns a size_t so that constrains us.
Right, otherwise we're back in highmem days where "unsigned long pfn" 
works but "unsigned long long size" is required.

(I hope we'll never have to deal with highmem on 6bit :D ... well, and 
that we can get rid of highmem support on 32bit)

-- 
Cheers

David / dhildenb


