Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A3ECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 09:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFD798E0016; Wed, 10 Sep 2025 05:06:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAEA08E0003; Wed, 10 Sep 2025 05:06:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76138E0016; Wed, 10 Sep 2025 05:06:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A19BB8E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:06:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6D534C081C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:06:30 +0000 (UTC)
X-FDA: 83872759740.26.8D7D5A3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id F400A40003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:06:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VLrEom9C;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757495188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJ0vl81zWTULU7/TV/0KZekw1CnLSGSEeoa8VD8/OBo=;
	b=vZtrSjqnvMd+hR8x0vFc+38OmA9JbNY65Cfr1G0K6ttDiqQ1WF4WNfC/gIKlQkxI8HsP7X
	yvPIOt9akSjC5U8CUonpcxfFLhbaf2uAQ3NWKaNzuecRr51MP4Rx++Jt+Tx8Z3l8QEbxrq
	mv4/R5b938r/RfSAnD/J/PtQkbwJEp8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VLrEom9C;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757495188; a=rsa-sha256;
	cv=none;
	b=s1P8yUKaiUJuo5Hxbk4QazFmToKMBhe27TcnhF4jAwaQEFF0D+h83znMVALmL1QdO021GA
	zd6HmnzFX9TeqQCYSEdVE6+/NggXjqBPR32ClvIzXTVfR/z8BNroI50jIFP4Qf46DtEZ1T
	ONfusHVu51l16+ixYMR+EU59PNEmcqM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757495187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uJ0vl81zWTULU7/TV/0KZekw1CnLSGSEeoa8VD8/OBo=;
	b=VLrEom9CKHJOxkn1giDOPm4RVuYcjmKLHubq3puqPkLt4rAMgrXe1qc6Cta269dq6da8jd
	pF22OYmYI1OtdjU4/vFFto34x0Nhk7E5muWEIhm2dlr5xuI3knTtosI7cWZS0ymPbDlOKz
	q1djiuJ07bHU44DCBItuWr0o2S/aYPA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-EEx0z2BwO-2ulPH49T0XnQ-1; Wed, 10 Sep 2025 05:06:26 -0400
X-MC-Unique: EEx0z2BwO-2ulPH49T0XnQ-1
X-Mimecast-MFC-AGG-ID: EEx0z2BwO-2ulPH49T0XnQ_1757495185
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3d3d2472b92so3697983f8f.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:06:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757495185; x=1758099985;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uJ0vl81zWTULU7/TV/0KZekw1CnLSGSEeoa8VD8/OBo=;
        b=HhGeFOAgZ2TGSW5DdmsSRhX/ld1v4BJsF+aV43qM8APu6hIIrlLWdmWWb7z8OenBfa
         CO2ccefT5KXFix/WHKp8yLH2hVK1zAcnWd6vhwnc8v6+AX7BIdcJHJNqSxxt5/3rYy2d
         EbI2UL2kLQVU8LO8d/ZGJkKJfIbBaJ5sEKOsP7xNB9jEqFHRWzz+0xPilhnyPGbTRPiN
         MeM0HhGFZVCiK25f8h+nt2GJLSKjXgoZ0AUqH+J1qvH7+Eneage8q2mqkxLM2sy8oX4M
         fM2jAROHHGka1Vqwu5558lUlYfdVVi59qarlViDcthXfzB0ElTAcAeDzLKdb63AZycA6
         isEg==
X-Forwarded-Encrypted: i=1; AJvYcCWw60Fut7DYdpEuhbHume9SU6CZi+uI83EP7HH2AIRQCryHpsC119EVAxvaCfVPtt46kCyrdM1rSg==@kvack.org
X-Gm-Message-State: AOJu0YzawTzRD/HF1qdns6I8mX+Dit9n/r4DhiMsHZ+9w3nkbQWAwMzV
	xJ6VSPOIHy/UHI6wmr0WiD+VN0yzNomnl28gpYl+iOqfvL6+OrrVqulkJVQctdJZh7J/9VOjcN+
	2Z5ErgFS9xpityGlu57tC+JX/Nx/FZD2o9pHvnI47CQMFfpIGFj0b
X-Gm-Gg: ASbGncuhIr5NDGAjD0cfwqprKqUgLkX9uXdBKyAZFQU4gt/icnpHkhqJpvJSPnhK50F
	5/ZzKimqGQ6cN7PsbhZ3dnEQXrj0Zp/QbPy0D0zPUDsWDZiz3RPWl1RQHv2+lSlXXExbk5+0Ivf
	+5J/F2kyBwyrHfpacfx0xVFilNBAKTXrlzY/1sbm0VoFekfEl0YNO+pn+jkEyLVQ18B5e6vl1ra
	G+hRVPuS4SvZssARobKh3ErtmwYnut7ZnIWmEgItlbIK3+pDDhcBix94xlKOqbHvGoLm6H8mTK/
	2vsdUsI0e1DLnEdsh1LWfSyZKjpB903B3av7gTbko0scn25NSxRSXQYlId+RZ4q8Oul14EmRf+D
	etMJ7M7LZh8Vcgqgu1yV0VJ+gZbHC++a3XaKMl+uRSm+Q1wayrDFEjFM386GT+X6cQ2Y=
X-Received: by 2002:a05:6000:2383:b0:3e7:438e:cddb with SMTP id ffacd0b85a97d-3e7438ed1c0mr12322889f8f.45.1757495184925;
        Wed, 10 Sep 2025 02:06:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEnDIjwgs/dbDJSod7IKxf2efZ1VuMA7eS98hMQupMuU8zTPuVh14Fi6ijNaBLIti3R2ACoYA==
X-Received: by 2002:a05:6000:2383:b0:3e7:438e:cddb with SMTP id ffacd0b85a97d-3e7438ed1c0mr12322848f8f.45.1757495184480;
        Wed, 10 Sep 2025 02:06:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f17:9c00:d650:ab5f:74c2:2175? (p200300d82f179c00d650ab5f74c22175.dip0.t-ipconnect.de. [2003:d8:2f17:9c00:d650:ab5f:74c2:2175])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e752238760sm5929620f8f.34.2025.09.10.02.06.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 02:06:24 -0700 (PDT)
Message-ID: <1d5aa773-89ac-452d-999e-6a0c8ebce994@redhat.com>
Date: Wed, 10 Sep 2025 11:06:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: Removing unnecessary variable accesses in the
 get_freelist()
To: JaeJoon Jung <rgbi3307@gmail.com>, Harry Yoo <harry.yoo@oracle.com>
Cc: cl@linux.com, penberg@kernel.org, rientjes@google.com,
 iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, vbabka@suse.cz,
 roman.gushchin@linux.dev, 42.hyeyoo@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rgbi3307@naver.com
References: <20250910005957.54108-1-rgbi3307@gmail.com>
 <aMDW1urp03myzZFi@hyeyoo>
 <CAHOvCC695c3fBphYvVz0Gk3H2hR9O2GaQLPvOVSZbUyv5C5rwg@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAHOvCC695c3fBphYvVz0Gk3H2hR9O2GaQLPvOVSZbUyv5C5rwg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 03ynZDJK80aRaiyNyz3led1ZBjOSYkBqgNKqQrHf67A_1757495185
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3ny4fgn1u8phyjk6noddb1jpnr83wq9c
X-Rspam-User: 
X-Rspamd-Queue-Id: F400A40003
X-Rspamd-Server: rspam04
X-HE-Tag: 1757495187-681793
X-HE-Meta: U2FsdGVkX18mWlEPTUdaoMLq8OBgVZvGiJyqIhF58j9djp2/gBeRl8eTxx/Bes6XBjUoYhpUg4RialffLwqqFJrzZ7O/83W934PR5tYKeJLIi3tgIwUtMdYu84jkbS69fVnoPILgOX/WqxVaxtymZD3yW2s7ExCpmyi7DEvwGtGqRNUEsTVaxDEveJuca5Q+yH5pvgK2dh312InU45WHhhiY6BRVEdogWQ/Dnvnd5NPe5s4WCsDaUtijgywKfNq//r/B/304iV4IZeizJi9RNm4qL4QKJzm2RFm//LA4xGsejyA07HwXEpbmBlDcqOsEwHGgHiRmBAadU+Nu15RiOhfc0WrcVF7LoIG2qTarJDPj11zaHrw8Llq82XShbqrhob7WAT5604IUR+HGSY66I9eu+w4NZSmnU1HexncH9v2IeDFJ27NgQNTUO6buLxeG+UAWASN1rIi9j0SU0006tHLTvT1TWphAaIV7i2WxirekXPnQacoOSwLVvFA+XV/A2jJlqXYuXgsv3TzXC7Pbc/dnotce1YcHJED4gDKN03BQdgqW4s5xET7NPscYPsGr3W981WE9aDtLeY4Nd4DYPfAr+KMghyQ0E7u9YHrnzJQdinJsqfV7MBCxPjlEfoX7MZkImXsc6HhUWqhVI8/r8E+D83j/2hg9sOlwDmXCe0LRD18StZXSYnr0KnXn1Qi8LKyMgDW2GOPV86bwA3uy9jR39NFRLjtmYImDMsXKj96a24jnxfRxNPJ3HsfjgV/4GP1wjZCcz+lOUgqY4rhtuChxR8fWEt9uTLRwzh7nRzPNzX5KF5R8+lnI5iFalGS6d+4CK/PlxUHxRdru0QQKdKPNltxrv4c8xYrjsVqRASFN+89UzkrJUAImKAmr66TOKb7kLtr9AcLkCLcxZ5betVLOywWvWszC4LR7eANdhleyTRnBndxIaaKOcpfZx2zgo6O7I8GUmOyywjSYAGB
 PILoFOZX
 dojnOBNkn0/pLtL1+XlkvoqryZaHJ2HudL8VcrhJkB5GO+G8tgDjr8POzLz2GzdTfFYwvutyRoJ7fAlzjWxsLWkIj2aytNJAzhNX5s/MRF9AdEsGnM+1O7u0N6I1KglurUzzS025nTZCMb29mdsYDp4LpAvK9Y8c82BXJ4mZr1/5yO+WgSTTNPPlisPe1DplUHVNTgYYyga2um0lDzG+157N7YNdhvhb/WgxRXbGUhjcr1sF+nS4q4V1wxLoST5ygCtejdLf4hxCwNvdy5aIlU7vRSSb+BOLlSAFy5Im14s2afYMXrHQTWA+94P1+9+1vHpCv6sfvF1PctnD4k452PnQJfFLgVJZmKcbMH5tgKa4+x3LfY8dQJlwpOsYZsIeE+fZnLBIjco+iYh+r31pZjkLl3kyHfjAuusIoR9a9AO/sbM3GzkR7/dqfp7m5aAPBr5plrpDYeRnYTy5ChYlshjhBXGirIJxfo5tkwb9vSG4kxhiiTrfAh/ooPX3Yjd4/syPrT0M8ZcdOrpqYGCR2uA8jYedMC5eydI9kVBMiVNSjDa0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.09.25 04:31, JaeJoon Jung wrote:
> Hi, Harry Hyeonggon Yoo,
> 
> Thank you for your kind and detailed reply.
> 
> I hadn't thought of the union data type.
> 
> Since the counters, inuse, and frozen members are unioned within the
> slab structure,
> there is the problem that the above values are not applied to
> __slab_update_freelist() and try_cmpxchg_freelist() if the existing
> code is not followed.
> 
> I canceled my patch request.
> I apologized for my inconvenience.

For the future, please

(1) Don't clean up code you don't fully understand

(2) Test your patches before submission

-- 
Cheers

David / dhildenb


