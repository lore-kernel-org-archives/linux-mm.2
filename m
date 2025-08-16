Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ADB4CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 06:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CE1B6B062C; Sat, 16 Aug 2025 02:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6676B062D; Sat, 16 Aug 2025 02:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095AF6B062E; Sat, 16 Aug 2025 02:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EACB76B062C
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:32:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B064BB6E43
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:32:07 +0000 (UTC)
X-FDA: 83781650694.10.DA218C7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4DA111C0007
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:32:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HdhQDyKY;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755325925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GlFkWrbVf6eand42rcHY+Dg0RCcwj6AArFWghAme644=;
	b=fx1fV7pQ78wKvuwP24TS53QeysN1X5AVkHmPG1kfUXxRdvzt3UX7v6aaeKROJ90p7b+/yN
	cnZzVnerB3Hobabg5fTCyIq1+WoOKtIgGt3HXLiIfxPFmYECjUaIY75aMl0PXxjx5eSdJN
	iym8xn4pR0m36wQwSXlFMEyUfAYQ/kQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755325925; a=rsa-sha256;
	cv=none;
	b=0t+8sqB1GhPe92bU7QWqwMhl0aDJ7oA8PH2Ghev1pAsv1ykQjIgP16REj6zDcph1fsulzn
	QFaI6EaUHHeCQuXWLP7vin72D1L6gnTXhrZexXKKE+sUF9g7iGEQoe128ske/LUQSeIPvq
	94bmaJnhgJQqJsvIHMCaLr2MEvH59lI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HdhQDyKY;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755325924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GlFkWrbVf6eand42rcHY+Dg0RCcwj6AArFWghAme644=;
	b=HdhQDyKYg6XXa2Q918y8t6NTOVmS8zKwBOwrt6g9yKhBfPOrxmiLH6/UjAdksdkQqf5Nq8
	WsowgzW48HjufD4GUxB8X6QHvU7ub9I96Di6Zu5E8ksdJ9VIxgC9zZPll2un0wvEx5bcOr
	eMoqlwV/aAPfrK8272MPU4WkjCSOkT4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-PI_czjvrOXqqcFkYSbJv3w-1; Sat, 16 Aug 2025 02:32:02 -0400
X-MC-Unique: PI_czjvrOXqqcFkYSbJv3w-1
X-Mimecast-MFC-AGG-ID: PI_czjvrOXqqcFkYSbJv3w_1755325921
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9e418aab7so1322795f8f.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:32:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755325921; x=1755930721;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GlFkWrbVf6eand42rcHY+Dg0RCcwj6AArFWghAme644=;
        b=ivLoDUy+ewJQTCBIExsbn72dvIN+5syuasGPN2Kujrw2RFPlfPyFYy8uR766W4fq8b
         kKMPutkYvAJ8L8REw/Z1bjg+B9u4YaTqlbkEXQlwyTUMmVJFkB+6DPf1Q7QRp3ZzrjIi
         Od7ZnjVxOgGQDJb/uV8UmBm8RbOiRmuOM4Xl/qq71UR8BYqGIpp6uOIYsqFIQuc+eGnV
         gOoZvLfUR8d7CRXuvL2vqOG4g/Su7EIlqk+Ds/GHxmRKiEwUDJnYc6qEl3PXVRPkML/z
         XmREDDGMge9/Yl4tej5wBkqwmgtruapwrXTF05oeuMXXrAZXfai2ei8u8TJSfSCFAPUq
         PXfA==
X-Forwarded-Encrypted: i=1; AJvYcCUtK9A/+BOrDSv30dtjRO+RcwYXRyrw7nnh9z5FRA3OX+9fSAz0MGnEYc6ndn65VIj7BKzDlH3/Yg==@kvack.org
X-Gm-Message-State: AOJu0YywjUy9cq8BCLmiK4DNpCzIBpCqCJH6PjtQP1bbuN1fBbSI6VZU
	XKcRuDXRhuE/TUFay6Io/ImCn1iOu81MHrTtjg2BUaHXGNPzxMaS05ey0pD3J+wfxBWB6k3bOLl
	/BaaOhRPOY4gk3NydqZqrD6hg1BZhQF9eMB4Hd4V5cCX23x4gcwi4
X-Gm-Gg: ASbGncsgOSOKBHlZuTb8TYlct60xY/ObQ2vxUxtvIV/08WcmneW1db0+D6mzoqaltmv
	ILhQ45Ptv3n2pjMvQeNQWGQxGCLXLUFWXBmk4c4thMSK3NXvyT5kDLMSewWvMNr4HKiHd19Atdp
	Kuz+sc4NLcv1vSajvrLReI8nJbjY2BfzHYAEXPS7gOFRfw+P5vumjuISboWLlW/9GZ/ufv6b6Em
	sqlzq/JWrVATWLfSvnSuG3qWMNOmsRfZ339/b2X9lNaXmtTSp+XSmNXaBjar8kBU67AKOjKfQv+
	ZHMyOO2WFzMnAtENknmMHRirfAosv/UwnKc94Xgm+G0khAPwCP3CFFUsgJtoAuZuu6K4bOm3oFw
	HvQwb6twa7Q0Lg3Amaz1KSBSUw6lKThHInxvlTziiBWRuK4N3CiSgJDqQvCiOEwh1qk8=
X-Received: by 2002:a05:600c:1c27:b0:458:c059:7da0 with SMTP id 5b1f17b1804b1-45a2673df7bmr12451835e9.2.1755325921005;
        Fri, 15 Aug 2025 23:32:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkYzb7PuEtDMdPCbhdC4F4c6VczQdwuoEnr40DRTuQDEK+J41wkeOWX1UbMAQluLS+9sjgiA==
X-Received: by 2002:a05:600c:1c27:b0:458:c059:7da0 with SMTP id 5b1f17b1804b1-45a2673df7bmr12451605e9.2.1755325920582;
        Fri, 15 Aug 2025 23:32:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c773e57sm88724495e9.23.2025.08.15.23.31.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Aug 2025 23:31:59 -0700 (PDT)
Message-ID: <15ccbbb0-8ebc-4c50-a1c8-fbe5416ecf46@redhat.com>
Date: Sat, 16 Aug 2025 08:31:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/rmap: could be partially_mapped only after no
 entire map
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, riel@surriel.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, harry.yoo@oracle.com, linux-mm@kvack.org
References: <20250815084943.23063-1-richard.weiyang@gmail.com>
 <20250815084943.23063-3-richard.weiyang@gmail.com>
 <458c4ea9-1e33-4159-a545-6ad2c5b81add@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <458c4ea9-1e33-4159-a545-6ad2c5b81add@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YPMEhSlOY5ldnVPRdp02Z_H-XRnheFfLvGuYBOOAdzA_1755325921
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4DA111C0007
X-Stat-Signature: okuqr3ebgmq9ekqipn4wzkecy7f3ai7a
X-Rspam-User: 
X-HE-Tag: 1755325925-593081
X-HE-Meta: U2FsdGVkX19xdbvUZy5s6ECHesXqCNEkBS1wJ6xPrVjv0mshaflBzM48/Qp/OzfhuFSLXIvwYORqP8seedkCtIWo0KJgoslS+M/sy1uTr+hGbzIcVEPqi4Mh0xV4/y/M/IPRSRYNKpzD+AGEfoWFSmEylB1XHDaH/mIPuz+wyYYsEO8Q9XICVR13nXM/g5dR5QGleYtWl6SClKIXOPbmTT+fVA3exDZ9+qqe9sf9vXr2SLVGvZhy/ArH0gAaUtchTLbnWmdn/1XeEXxKqtc3PDpDMgvSxK6PUhYI4fSjy8tmkqXUAaQ6aasVEZxX/cOl5IdBsNw0kv3EgBqgE7oFhDZYomU6Lkfen2EUu1VBWg7wvoK1H9YidXOHD4pxambv2RhfxfJMCjCAyvfDZRdz9ux1XAn0bFyQuvBQgrX5S5FkWi6yLJoDMrTxvwOVDmjtSlVvlUn6wIuWFwAjbuPuzQhwR6YmygEbl6LjwIgZLBdoOuWZLoSN2Ia9VJe0qyqmAm+r4+e2TpDI1DlsmFTMl05zxqqSOOgE7/IDHsjlbzQ69lMgJWIlQea/Q3vSHY9My6uiiYjnCZzbmgFr0oX+SXj0A4TKDymIqndGY8Kad4SS/0nkw6uHYeQ8P4Fr1C+OKEIcLI+h/az9JXEoGj3csmFGhu4dktoTDbEiRQ/6vbbNK/ZeyNPKHsdD34dnpGZJB6b1lxlfhd8dKaoBaJduZEsGq9pFXTxm7amDE/s7Px2Z/dxnP/99xPu4pUbTrLSLjOgcVYB1eRWADOQPTsghYkHpCsQ5NsfO/5LdNUOlCRBO6Im2VZlxv2kujXjgiU0qFKNvLr1Akv3XePJtYPIMaY0Q+42/8K6K+QnVeLCcB2EqnrYVXCN3a4vrDJs6xjhmbiGWqldOhXZ3UDJusosml6JhSz3KQj6XbtYYhVWtb9ctbjSTjo8wPI99QvFp9TeZuws6GpqmXjKQcOZgdn6
 iyKcW8Nn
 WBT9HQRGM+o/eTaBV1DXcpIPNUtZKPzRz+Gqp08mKHNWRX7tMn5yvmd7q9mlV52fKWDe3oE4htT6MRLmk9mENqDvfhfB3DVac92+lirtPDAj4BTi4YyVtghQl2pZEP+TD5VYp8oMMfqvYqditZkXplb+Gr8Gu0bQcseVmqwWjV3H4YkjJ5HqoJ2lQ5YEGN3sMeBEwEivjZLNxwxW4h50pHo8r2SvZNU81T0Clvpmkh2ZNHBRP8Csbv7B/V9UG2PHUgrBNkx5IT489BG74TnEtzGO7Qjcwl5IIsolOFkoQ4t422H0ISR9acxkNjjqGhCtiwb7SWMwdEr7tqkNlmL2TlOcX63QQpCNRbaVdzeoyl7aP8bkF2JoOegYywLsqtqhTSFMiOhBolbnEH8SOqrYeipgRcib5u8Z3MwR5MFeLNnK/4f4HA0t2eHYHa6xdf4R+tEK7KkcxDj4jKwrKcJIFQOR+GOM3UTONhgKbqxjYFJDfWes+4v0BIZ35RGpTz25Z3Miuc3zdZT8hL5t0OCKR/g0AkJMtsWx53gHfs3cVTmd7XtI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.08.25 12:08, Lorenzo Stoakes wrote:
> On Fri, Aug 15, 2025 at 08:49:42AM +0000, Wei Yang wrote:
>> If it is not the last entire map, we are sure the folio is not partially
>> mapped.
>>
>> Move the check when there is no entire map.
>>
> 
> This one I don't like, you're having to sit and think about why it is that
> this would be the case, vs. just unconditionally doing it.
> 
> Again, as mentioned on previous series, just because we could do something
> doesn't mean we should, unless there's statistically reliable perf data on
> something real-world indicating we _must_, code clarity absolutely beats
> everything else on importance.
> 
> So yeah, sorry but no to this patch, please resend with just the two
> reviewed (unless David radically disagrees with me :)

The compiler can figure out that "nr == 0" if the "if (last)" branch is 
not taken.

So I tend to prefer keeping it as is.
-- 
Cheers

David / dhildenb


