Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5ABFCA1009
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1B5E8E001E; Mon,  1 Sep 2025 11:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF3998E0003; Mon,  1 Sep 2025 11:45:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE2148E001E; Mon,  1 Sep 2025 11:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACC8C8E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:45:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 63CF11A08E3
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:45:55 +0000 (UTC)
X-FDA: 83841107070.13.4C2EE3F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 002E840007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:45:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MYLzlH8D;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756741553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w09380bFrKMk4XLei3XWMbAK36bC+vurKLembtRbMuY=;
	b=cLZ2JykvFk7BJ3uCxJp+9OkAi8+tIF18kVn8yR3BL8e9+ugdVvJCM7WMlCwc5Gd1aIV88w
	5sEl1OJqZX42MFLYbwiSQ3e2q5MXqvOM4fi6mChLpXNfOVwXd1dgabNBopKhaTqdL0N3aM
	8I7hvDtkjHNA+gyECj5kh8sld285dSY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756741553; a=rsa-sha256;
	cv=none;
	b=MVXHIVWrzr0bMlMyUaH1nCFfLctkyKdNSRLeEA083S4jE8yVw2964DQYvvaU8oHGNXgxnb
	qiHxRi8ML/3sp4wjaxRm1DSjV2GilAtLzFi3f5Mhv3IVr3IajYix66Be95dRiK96ttzukZ
	HvhWXXPk+zyqtXvdp5p1wLJnNWr/kts=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MYLzlH8D;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756741552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w09380bFrKMk4XLei3XWMbAK36bC+vurKLembtRbMuY=;
	b=MYLzlH8Dd157Z9rbQ4qeecvrQZyvmoFnYcbFktpVsHNcqzAoVpku91yvqBTWv8O5D2Tnow
	gaRBXQsWHfl6QGWYn5Njxvt3f0L82I63YnVWxEHXIn6sFouPiqW2zM819Wyj/jqXJn7kBW
	zrdI13R9VSWaNb+EO16EMvWXMEs2Jng=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-xEpSNA0hOFuuTKClDNylNQ-1; Mon, 01 Sep 2025 11:45:51 -0400
X-MC-Unique: xEpSNA0hOFuuTKClDNylNQ-1
X-Mimecast-MFC-AGG-ID: xEpSNA0hOFuuTKClDNylNQ_1756741550
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b7f0d1449so16121545e9.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 08:45:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756741550; x=1757346350;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w09380bFrKMk4XLei3XWMbAK36bC+vurKLembtRbMuY=;
        b=MPRXBU/vSYu3oZzITvmrPFZAkgn+H4tjk7WrYtkSh09XtlMm75FcuoyIRgrThKe+DR
         GIze13QVdr36dSrhtgGGiE1SO+5aTIPvhUJWL1rCelaczRfdcpLC6DEHGZ9ixGtsSd/T
         u+OdfdMmEBxRCvxQx9VDGhY+2pJhwVeYj/fwR0BWHGXcjQKcStu1YYhjCQdwou7mq668
         JeKzrSaW0esdgnJurXX+0cwJYMV6NW2HBBDBFdPRJgf7FNpHbS1HWkG9zwQhVDDJx+BF
         9QevtdrTLUw/5kCmWQRv6h6CnuPHPAAZzwEtS+zL/qgM1Zjq11xpNRpxP6/yKMgIvN2F
         x32A==
X-Forwarded-Encrypted: i=1; AJvYcCU+sZ37Y07rqCSWDFo682xjt67Yep6vYmxUMORQfRxwUwaAFYwopGKdEe1yaABDsxdbj9UwCCAmJg==@kvack.org
X-Gm-Message-State: AOJu0YyKqTnOtwowaPGhKfpsQIzoxQSFQlGECtiASaExBW9+QYdWapcb
	5p5a0V4E3VJBAtDLAotig7p2T7kVGC5uiRqEV9L4HPoWLtB7fMhr3zEkCVeoM6MvN8zaEpBmgvz
	x2JhVdmuHgT9ghznzEhLA9qaRIO9+/7/PK8m9WpYKM/Ia7IyXJyHd
X-Gm-Gg: ASbGncvjTIbnD3CI4HhgaHqWhOi0eXITH5sSptMhWDo4KBSo3qGopfZ85f0eIvxjem0
	H+4X8bAGlAZbDuNNkOPqQZQO8QY5j9KlKM+dEu1xfzysvIio43BnO2UAAf0LgHaTQ/F9VIlQ0I/
	Rjjz2Z4430Kg8yvGkbGjVdYytiEMajvGnWnN7OaE5Y6zV4jL5NFEiZmN4UDrmgUQhKV3MabuzSQ
	os+GMio+Ua8K7grsMZvr5uopkP7pBAd1tK14HvapoyxZ1TJrgf4bZSR4d/E0ZZ/0tttkmZzl7aH
	qQKUKEVRc021fUQGd4Lu0qzds7czleDL9nQDGqzTNj7l2eM2N6twyaMwoh4CuXo0a7t7VOrFJ6B
	EenTubqlo46MhCGBT6bUR5UZbsfqLhxZ1X+gJ2qP+dAAKFsbrSgCjtw65apojkTpFSrw=
X-Received: by 2002:a5d:64e4:0:b0:3ce:f4fe:403c with SMTP id ffacd0b85a97d-3d1dddf0380mr5956758f8f.16.1756741549959;
        Mon, 01 Sep 2025 08:45:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGi1rtBK/Uad2pFxdABiyJhRSWdeDN/k8YOFB8m5rXiRziuyDcmHFMOrq6sZh+Mi8uFhVEew==
X-Received: by 2002:a5d:64e4:0:b0:3ce:f4fe:403c with SMTP id ffacd0b85a97d-3d1dddf0380mr5956746f8f.16.1756741549523;
        Mon, 01 Sep 2025 08:45:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf270fc496sm15975685f8f.1.2025.09.01.08.45.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 08:45:48 -0700 (PDT)
Message-ID: <64fd5c08-191c-400a-828c-a2883dd090d7@redhat.com>
Date: Mon, 1 Sep 2025 17:45:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/22] mm: Constify compound_order() and page_size()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org
References: <20250829154728.3397606-1-willy@infradead.org>
 <20250829154728.3397606-6-willy@infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250829154728.3397606-6-willy@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: po3-v8DBRQIQdhTVxzaqxbIUmfzlO0F5L1nQk2NT5mg_1756741550
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 002E840007
X-Stat-Signature: xkcbfdaqgus46uj75jh7iez8agquka7d
X-HE-Tag: 1756741552-39268
X-HE-Meta: U2FsdGVkX1/Vxum1CK59JGcBcMg6pt/fd+uycB/9tIbfHvW+QLVXFObJrqKigiC6/8jPahNJb2VLwAQPoVFeuoxumnOHIdPxZJkNeeBKJ4BWlCTaXFUCsr5b2gxUW/P2BLM6fBlKA1Zq6/jDXz2/WIW96fHzYp/ujh50IuuJkyV69/oFwhmlYTjnW/xZBVgehrK9UJJ0H6a7jFimD79ZVtUKg5ZHkZWt7MJaIVSR1PWtF81L9v88PYsb/TpQFp6iGLes4c51emReoqOJi07Ga58jnSn7Wn7lBPt8whI/Y9CcmrZvi/ulAOXUgpw1mMmA2jMae1pMSxETTKcVIbx8LzEH0Hvb+YnCMQqCiD6y5Ba5h8FbrK63flTt7tCDf8TVOgNVfP74F1Yp7i8oRnnQpJLzaKfajihSiABtj/Hp5/npXCmqMtKbvJzLsWTuvtYOp3zEJwBAmtpHCr3eKXhnOmO7zyXy/yzn3aoyPzjuEiJ+OnaSucO2aAC3CVTzlMefs/9skjwwZG8GrVWS95CtFGWmigLQuBcUx4/I+bPrF9v7+d1sJIveb/SeiPTLfAhZeHSCIScCHRFjWRaUy7DeQOFCMqhAinrB4DivZz/PJgtxGt/0BMJA61LEETfASKrDxZ1pnrg1+GSDdQ7ueaaOTk5MghRqaQMnYZFBvWvJN1ivToDxUUSCGN9I/op11rWZyWOmH5yx9D8L0TmUPUQqBiaAH1UfiKWzK6X//pOF2Avty2NslTdaZcaQo3HnRhbHYkk7VM8VQGrIEcuhW0yPscyG1NTZLh/tbhMe0vHu2dh3xePsEjSiSojLt4m/ML0tZL4oQmIHT/bDFr99OU/kK2UEY2zlpvEk88gOpN6e7qL5DrE7/Qw4ysHTp1/Nl/3tfhumUObKmMeVLFgNW3Hc8VzzG/7oVSm92kPnf1k5oWWG856JA4oueNuAxSyERTQ6fUqzMcy5AmyUrU/HIRb
 NXsDIjiD
 SRJRlKi1I3NUdpOBWAubzXaX160VjDs4mCodNbdreHlHUHGSRjkRQTp0hyV+thCs8GjC9LmCPgJGbtJoqCi/CEGU/COYBllYP+EZeVRt5yZporaGb0HRVPcmLOgHL2IFYuLYP2dla4fDkPRuh5LvgW+0taKr+Oca8UoehS/kMxsZQyBcuNsbQHzDOIzSSC0tTSkllnj1yg9BgZFHgqU2B1SmoP+qSU/awcdiLR7uhzenFomQ8deLgFerM6V8T++EDfSCx1x8alZ7k9Dx0dkese9v/Y0YQg1HcY/iXGure1Lr3r9oTvr/grqXVKCZ+YLENB37xgVvZT4iS87KpybHuat4TEskgEVkrhCjsyjw0l1ODqW/nzw8S64i8wbWdBBNL+alu1Cb6MpeVbex8JH3ZNYy0MoBEfo7T+ZpDR0SSzLoGSal0ibAHFmEjYqggPchRpWV40li+bryJuXZdtcx3veDwdMEpMyW7g0pURWTNXB5rTh1q7SUw/0q8u3JRciA+GG8m5FS1wDfBlPI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.08.25 17:47, Matthew Wilcox (Oracle) wrote:
> These functions do not modify their arguments.  Telling the compiler
> this may improve code generation, and allows us to pass const arguments
> from other functions.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


