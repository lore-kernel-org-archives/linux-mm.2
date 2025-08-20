Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3948CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 14:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 514748E001E; Wed, 20 Aug 2025 10:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C57E8E0003; Wed, 20 Aug 2025 10:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38D018E001E; Wed, 20 Aug 2025 10:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21F1F8E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:50:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA02F8361F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 14:50:22 +0000 (UTC)
X-FDA: 83797421484.26.F453CFE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 528614001A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 14:50:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="OnirXp4/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755701420; a=rsa-sha256;
	cv=none;
	b=wBbdU3VL6dKjUOxSHeKCXrui0frqB1PYVrKrv99PgERXZXT5mAYLE5HISH58+ot21NGFuW
	yVE+4mS06zegnbDKjuymSUC5lvd31fAhA0QIG/XAmUciyjk1cq1BOFY5OHlEOgsa/Ftt6k
	g22XHgDYf3xdpZcDQ1LkjP9IRBJTS7U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="OnirXp4/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755701420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UVDesp2YzkDiQhPhj3wNDxcGmY+ZKVXe2qM+mIpLJuQ=;
	b=GodP2VdGfj7yKyBYYCmnwrZfJ/ZKcvUKce3E1bqcOyrZrpQAcpabiNIMIduIL+EiwPbbxG
	O3Hoh8Eb80xNrWbwR2OoLGEX6SW5G898XLP2z1H++L+o8s33kRlcbE0mZkFmdXzjOCAuW4
	Tnv/yt7pj8bVQjjCH+G09CZSZgqaRyY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755701419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=UVDesp2YzkDiQhPhj3wNDxcGmY+ZKVXe2qM+mIpLJuQ=;
	b=OnirXp4/P0tQc6JBHr7lK1CC64n4RwVf65ecHshxvN1DzR1yT1InZ7A4usSD68oyNPAEXw
	40q9um5S2fGn/H1h2emfgSIPkuWg35WgdP3TKxRiMFkhrgnCFzDU6zL/7mjYPV0pqQLRWu
	vLuwU07VmI5oCr3KePYYh2mi4yrZVO8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-ucsaDhMSPXiTNQEo2ml4rw-1; Wed, 20 Aug 2025 10:50:18 -0400
X-MC-Unique: ucsaDhMSPXiTNQEo2ml4rw-1
X-Mimecast-MFC-AGG-ID: ucsaDhMSPXiTNQEo2ml4rw_1755701417
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9edf2d82dso3315468f8f.2
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 07:50:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755701417; x=1756306217;
        h=content-transfer-encoding:autocrypt:subject:to:content-language
         :from:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UVDesp2YzkDiQhPhj3wNDxcGmY+ZKVXe2qM+mIpLJuQ=;
        b=Ghxt3vDl/5mEWhq7qNVhUPzCWMogLiyZqOl8KM/h63vTCzffSWQ1XbPq9p5ZG42Kqf
         pEriA/YB8kFeGNbZqMsqgmSs7xM57xRrv/ppi2OYzwnW/YQzJAACsr1klJPB+s0iEPyr
         3zAV209Qeq2L5/W9UXPL3VcyWaANU78qvOgmwnqPFAut87iNYnuTTKu/2lrT3kVBEODw
         LRGA4YOdeSK7e6JlMGyDvpBtOH9Xcx2mcaJ8mI5mREh53Y4XJKBU6v6T371HlOm48xXb
         G7WFX3x85qhB6Kajk8kM9dt/8Bl7j/A616NEs77s9hj1fRDLu1tKoZUuooBJvLTJbwU2
         cMaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjeDypzQhn9JCBmxz18Z33vaLMoSLPTn3D87Jel8jesZlAFZBMJFcCRtJXPmIMsGq8GoyQxd4vaQ==@kvack.org
X-Gm-Message-State: AOJu0YzRRPfdFBOyrRwZgnzmqv++9KhCB7syEMhLzsvnrHdI0eRJ4FVn
	8CSl2CVo9vyY/VXcphKAdqghpNFZGg82X+GZzeAK0cC8vynfJmzf9uZX9gea2Ek0XQh06fXKX1F
	WzFcu999g6jlqLyvbxEnbb6c6i79XtL/o77bLlJB4nKrOwzWJw+8W
X-Gm-Gg: ASbGnctoUzxcP8+M+VdvTq9Yi8xVgJZ7DU1GG3xBn6JG/rh/HGsyOCGWe6CemYoL6Qp
	Qf/oHPuvmTO+qReBs7eY4sZtfqtvG+zTjaRrTikWc11I5MVXZ6S38PX9hArY9AOmxNizQRrTlnZ
	TShMhyXHtKNKbDh4MNA+UoffwjLLVmeU8l0QkDZ+B7dO7011nwrUSpFS67bLLKPjnZ94m3TKi1J
	cfI49Np3rt/lXF6kMts7eWVWf5pCGrHoqwLZSoY5dRQsrJo2Af4HBSYWi6URsobaHBN1EA12GXb
	fbIMHtvFww//toDgROPt/R5oPA549z38ewQ/ItYoxryMiGCUcwv8ZULM+0wS/ceKZc+2n5CERHh
	BIxfQA+BvBXDfTvp12hbeV+g5iFs5XJvSRvBwHWTVOAR4Shf1UDeO4341bfwcJr1Q
X-Received: by 2002:a05:6000:2282:b0:3b5:dafc:1525 with SMTP id ffacd0b85a97d-3c32f664611mr2236150f8f.33.1755701416911;
        Wed, 20 Aug 2025 07:50:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMpI9AfBVahnq7+dVkf+h2VoKoGyjqGXGgZgTRtEbKx9O3Qm4CSoB+Kss7RoTy7Q+a4bVu1g==
X-Received: by 2002:a05:6000:2282:b0:3b5:dafc:1525 with SMTP id ffacd0b85a97d-3c32f664611mr2236098f8f.33.1755701416229;
        Wed, 20 Aug 2025 07:50:16 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f13:de00:e9f1:62b4:5bb:5d83? (p200300d82f13de00e9f162b405bb5d83.dip0.t-ipconnect.de. [2003:d8:2f13:de00:e9f1:62b4:5bb:5d83])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c07487978bsm7822833f8f.7.2025.08.20.07.50.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 07:50:15 -0700 (PDT)
Message-ID: <2255e387-857c-4b5c-b27b-f7f2a6bcaccd@redhat.com>
Date: Wed, 20 Aug 2025 16:50:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: David Hildenbrand <david@redhat.com>
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-08-21
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uxKH8EzTpxticTsjExj0i3j_v73zO0CBGIk9l0ldLQU_1755701417
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 528614001A
X-Stat-Signature: qbny79y5ujxbrth8bb97d1rkucddibep
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755701420-975514
X-HE-Meta: U2FsdGVkX1/PTUKvzQ51z3Siav5PcRcmocXlXFgqK2N1nQNa5jEsj2wXD1Gi9OmxFpCQc7ErhPugCjyUqLGPuVUAPsHNJ6Ea/jWyb4o+Xhsbmfy3BuHQFXusjIYw41euKmdJlNLvkz6mS4JWnyRPfxOGA7lV5ewf1GvtE9Z/DMpYLqoPTBkxaf7SpMBWTh5HnImUnOfFT9slu9CRC9oq1hofhghtKVyrsAp9N3zKlEZyt4So3NjSSLFxcDMwf6t3JVwdhP+eswF5emh2CF4qtx4s7OkdJ85lWAvexFKpKrbg/VkzEX4mBnlXWC6kM/kDbprMCIQyVrrXuwlh30XmgnnShx45MwxvxzsjXW36fujEA8RRTiYxBTgM77BJiDUNapz6ezCgZaq5t55kxAXjoLHjFI6lUUQXeeCMWPpVBB14et/brhPfp86rkEfjHeNrkNupIhOshiDHePkyQhTl2mKCP/dcPeBJYzS2oz9XML4oEtxZRpzSglHZfKARZjirKM5yVG+KvmGGXDxWskvZ1sbjnOMCNi6JFk1Ef9pjcDvZDc1Ic6YrfFRZz21goy7g/PvDqyOrNOrTDZCOq0R+6g5jt5pZ0i3y94oLKNyoIdEBx2rr7+tq7Ic+N69AxUc6/TfP37vNc6bvYoYgEadj2D5PVPWTpvBouUvwIhk2jvAK2sE3kHaq4IOG+IB3IMDT5nnQnYCvU6P7HKHKIqVaM7m8esxk3Rgyy4dmldreVsX0LgjOuXaEGxUOgRYmuzJzQ9BxB3zOGRQOMFQZr+T7pEz6fO7xpz2nCV1Y1Ho2MctHsZFfPQ7b8datw5B44kVqVsYYa2Mzr6MUTaboMuROdJ/gZzIzKPD7/Fmm+lXOY+GtX8vwBCc6hruNY8K9mOK87sCE2wsdfJaY+O0Rs3/ZAhUrLOzpsOxV1MjHyU2qmpNcAvRkHYM4h50aymBWrb8/zk88aNVTtcAHIO/rnOl
 8NHghurJ
 74QH6OhuI0HX75R7bTXELbA0EntDg8THNhhIMH71c1lci5fUNZW4/g4umQxXvxiGRNL4i0yrR26ktSFPsv017qN3ydH+CS5OhAjADjaeE68o1u7xurzhii9yPSyQa54oHyywihDCu/CejLJHbGt/OdLr+GngNQp0oZu78gtUeJ8/yjwzLAOeseDrB6VEo/4Yz3YXhX+ZEzrVRdhARqMoNKbddZ9L8HU/7JTvepoc/neX/6pZwB0UUF9TjX0GNW7PUvL/Q1/3bT3oTKwykX8ZfL2Oy+O8XqdCDNAblHlsAAy8VxopgUme+m5z9O/cVzXYo66BonDlrnHf6RlyPcRiYG/cuExa47Xe4NEPnBg4619EwxSHwmiLw2nPm51rTtcTpb00MwLBC3abK4oGsqMsr6mbSF82YjMybYQpLeOZmH3m0s/jzH3rDTIrq/IiHDiuJxdDfhXn67EYgxiR0OK+w6yzzUSaUUAnUEE+QEZMJr40O5FQsP2MK6Fpp/2yiOUyqrIy4um8Eyab/c4rJQek2kHM0bD9fyq1as5/VaOEQ12K1/rvYOcX7jZyYqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2025-08-21 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

For now, nothing "big" on the agenda yet, so we'll see whatever pops up 
(I suspect discussions around huge page support :) ).

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

--
Cheers,

David


