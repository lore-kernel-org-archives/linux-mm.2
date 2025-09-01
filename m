Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30A01CA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3868E005B; Mon,  1 Sep 2025 09:51:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 583CB8E0008; Mon,  1 Sep 2025 09:51:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424DA8E005B; Mon,  1 Sep 2025 09:51:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1FC1F8E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:51:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BFC921A07A6
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:51:42 +0000 (UTC)
X-FDA: 83840819244.22.27E175F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8655F2000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:51:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="YwU/9q1O";
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756734700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQXxZK+8L2C3hWSBdyN50IL5R99xW41D+fHSrVTbeg0=;
	b=MaOpNkYQD3gv9klbYoYzy0hEOuwYf6GH4wp9VnxZt7vWBo1Tfm/x/1UGEmwJfPGQDHGvUk
	WZDuT7ZDy3SLRO4avWwW+ohb8VhDPPA3fn9Q9SUcEML6r9kjRlLbgU1aPnV1j7iHP1aT2V
	lXShYOu6prR71reDjNyymh/BcyV/djI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="YwU/9q1O";
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756734700; a=rsa-sha256;
	cv=none;
	b=c5mRRaycbfd+rIoR0bZ95YETwUKgr0kzrWBHthMQrGgsHE6Mc3DJlwtGEDxiL1fewQXTzb
	0hClQFU+Zie3E/fUPlOMag22r9uZl3EaPLbgq97kVvnlAoPfTOz4BRDqp4cPLb1Cgchm+n
	QxHECIdqSjVux4/W1ncXnxDAAQAx8qU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756734699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hQXxZK+8L2C3hWSBdyN50IL5R99xW41D+fHSrVTbeg0=;
	b=YwU/9q1O4Om56IH1pfliBjqAib1T2ivW4V0NzSQC6zE+oOSrzSzty8wTA9wVTfnEot46xF
	1zehtlhK06AIra1TvxHS3nkbBksYmVYvZJisSP19XCxo123+aAQZp/YXnnHlGooTkKxHMz
	EKNDKBjyZyGvYtMRtW+9WM1e91aUcXA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-5YL7G8hLMVy82Fg31f0MjQ-1; Mon, 01 Sep 2025 09:51:39 -0400
X-MC-Unique: 5YL7G8hLMVy82Fg31f0MjQ-1
X-Mimecast-MFC-AGG-ID: 5YL7G8hLMVy82Fg31f0MjQ_1756734698
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3cf48ec9fc1so2089019f8f.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:51:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756734698; x=1757339498;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hQXxZK+8L2C3hWSBdyN50IL5R99xW41D+fHSrVTbeg0=;
        b=plGRRMmumEe2sC/bBX7QICat0QxhEWJkyDaSKQux2EGOdVc/adhDrxBX1LJlrwSTVg
         nUTsxgVWmKmnHFuZe6jhfPhIOBZLBpWdeb+Ko7tuLDw36hgA5ezCPxslUpr2e1C18IDd
         7BM1yGPm4KNcMyDWI9aCF4gTD3SWEFxuEq4sDp5geb/dlQZ21jT9sT5Iw+TEr2gENrvT
         aopD2tgd/jfaKN5ZkIIzLlOm82anFamk4erqBkW0aUiLrrX2OcLDPCXHStb8Nj1Xu9HQ
         lQN0A/p+j9GWdcbwVlcCbvmRgfi2iuaRUBEuTkyOknpUtmKPetgo3ox4uRqPBrm+OSbh
         MngQ==
X-Forwarded-Encrypted: i=1; AJvYcCWADeR22tSY1YoMAr6i9OgXvJOO+RSg2IVk+reFwu56TRUyvYQsG4EI0l5sItC1GLw4g4RUuuaNgQ==@kvack.org
X-Gm-Message-State: AOJu0YzW2ByoHrG6GIrhqDcCehxm3YvESLb8u7JmF3W4k2KZwsmHR86L
	MCdqKw9D+O3+mSQ+tVIeSNntmqbI1PPQe8jM51ErOsHp5SBT0H8Jns3uhmHPZlPyPTEmlvQyYwK
	CtzQPxDD3rQ2wBtHtXzsNj/dar9xptdzH3fq+9EiCSQd/wUNHO/Bj
X-Gm-Gg: ASbGncuSMK8MIZELf+GXHUggwqS52St+foKXKMaYqYRHeH30Zpnnd4Ckq5zk4D1noCn
	r6qjeI1YlP5qXd5ahj8cOrgZJj8AUVInTqkLDOiddv1aBBYy2DAQLOC4St3V+ABOrKcEQR6s3KD
	vyu7FI+L5tozJJVFkytEz73HDcZDU2QqYsIKy8c6RBAYrSmxFibZqIiBWp+o9BDveoAli99vIQA
	9ihiQrqlHFGUwrrOZ78ieCf8jZJw0O1uzH9FxcoKRfenfUlRa27Oieunfct9+pUXsvoKrnokWcF
	XinR+JNcWKQrXH/zanUukPtiN8vmZXmBZVpxEYnd6uxZ8iN6fH1Tm7aEEfOWNhsANNDe38T35AY
	wETwGgazg8on3jvRlO4rCW9MU/oebfAbF2zXWdWv7WVRwEIoIJG9dA0luiSBLO+kq054=
X-Received: by 2002:adf:f30f:0:b0:3d4:7657:3a3f with SMTP id ffacd0b85a97d-3d476574e7amr4175824f8f.45.1756734697836;
        Mon, 01 Sep 2025 06:51:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE60jJSkvXYkrdq4EWZ/PA0BRllu7a6Nn2AA0zTGkvxb3B8o9Q0Wwa5gtduhlsn3favlI+0vA==
X-Received: by 2002:adf:f30f:0:b0:3d4:7657:3a3f with SMTP id ffacd0b85a97d-3d476574e7amr4175787f8f.45.1756734697344;
        Mon, 01 Sep 2025 06:51:37 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d729a96912sm3639435f8f.8.2025.09.01.06.51.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 06:51:36 -0700 (PDT)
Message-ID: <f353186a-7907-497a-a170-939837f47f6d@redhat.com>
Date: Mon, 1 Sep 2025 15:51:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/12] fs: constify mapping related test functions for
 improved const-correctness
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@HansenPartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-5-max.kellermann@ionos.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901123028.3383461-5-max.kellermann@ionos.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CSItpWY3KL4NwIQyiu6LnAeW_y8upa9ov7NQbauT9tY_1756734698
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8655F2000B
X-Stat-Signature: das8a5pnyymuu5krdseuf31xtc9tuos7
X-Rspam-User: 
X-HE-Tag: 1756734700-867293
X-HE-Meta: U2FsdGVkX19e8uDCXNbxZbiI4RlLmXsfV5BrhXfgAGgQJjwxM7KsutdZPvjEl27iD9CcHDdGwmuZkNvS30lREzvJTdIrk0OdacdJ9SIwm+4TkgEkvfF8ZKWIR3U7RVdVSTjhPLFI+bAw0yi8I7tNkkZ/i10wqzB3H9RHVNvkvi+prarF/EMZOJ6ip2hyQbJC+LP23/kPGaUOX+8Vpm5+Az2tSlrfMnD7/ujx0ZKJJwCgI+ygY3XGwM5aQbJ6eE8h19rH79h6CDtuznrEYU0XPEGI7qFAlUoYXmXLpRaO3bASwmfu+iaAX4J0AIO88piwKxnooU5YOUQjpS6fhu1T7pL4a3tjygMoNG5D24NZtIS/w+v9kQiOWZTk7O7c71Gt8/tnWFLa3hsjXZzgLH2DkfZUygmoZ7Vq88YIc3A/wmPOBUsAJuRnJMZ6TQfis9+gVxJWrl7FtZ2xzxN/TXz7uLPcJPM9WQpMongGcBVWOZwIWHAK9z8nSynIMGLDCOux7d9jW1V6P0I1OL11Fn2+++j9d2HtseegB4bGknN952zxYjxhDv1AGZfyo9X3WDBvGG7T7pa8dPg774HjxCIK0nly9PW7+znknNGZuzSJqgSJvpQEkSOFrOFRO6CI9oBtE31ualtKr3Os6krTHD2HtZ/b+G5+4kTzBnyg371LUQVNAJ4e64C0aK3xzxPHS1GhYc6bWdZrOG3Zg1PVKtsx8i85ZZ5oJ7t/tlKDlcshGLqmszkx0M/3lSjm2X3p0n4y2WLMuwn36bBsU/78zl8HUB0AcvGkVteIdJrcokGfl60K8zOfSPtmP5s/piOBUnn51bWR1bbXWpRMSKuyAAEXMRTMRivTt9osOEDWxx7sZJTX0j+wSw2Z7x0TY/09CcqX8IcwrDpIaeDjan75hHaJrIF/i0mvk324RM9fHK2NoGdI09aJOiQVGTW4Hd7hRZ3ECa/f7l/MM/gaEHZwTFs
 WX18SQe+
 GzNsj0+HUv4/4akUp3ORd4EZzAyIyJKKadGaeXTxYwKzWuQiOaUeqt4dzXhRTb311tE4aJfgQJ1s4pQ94WOOUV6y94HylhgaGvgMTZ02ujfnyrsZaeZCryrDOMBorCGQpDFCBu/wq36DljaUae0/G4SNovnOizLzU9wThObqwHc94Y8TwDP1/DydblPZTOqmck3KT4EdixjnoloCdkHBwbIdLj5E18dQShMaNWaffD/FfUYciUK2nBTtLixruHYYiGnVkN74eEgcYe02nSNp45Vc4lQPdjJAlu/nswuQBglYgDbyJCx1ZcezcKwowE6/StnCozwK2RzYYcW/+tJGT5yaHTm/lgk4Y/gq6oA7fw8rtwS+us7j3/K/X+UAsc98QxLR6sf0cazxuWMkLQMdJBz8tJ9kUg/K3k6rGgEGugdO51CU6MLT88IzZOOspaKgDjyNUpPCrMJ+WK/41wafgyBJvKncpLGrQacwy/MFBTx/hVwUe2cIaHO67KVpnH8N7G9rlkgDqSDBtg/NSzm68+yTh5yEHOQll0+Pe1NQiGRzP1TKXPaiht6e/97kSVlO5iOeK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 14:30, Max Kellermann wrote:
> We select certain test functions which either invoke each other,
> functions that are already const-ified, or no further functions.
> 
> It is therefore relatively trivial to const-ify them, which
> provides a basis for further const-ification further up the call
> stack.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


