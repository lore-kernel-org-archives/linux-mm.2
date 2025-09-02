Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03259CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CCB38E0011; Tue,  2 Sep 2025 09:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57D2E8E0001; Tue,  2 Sep 2025 09:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445388E0011; Tue,  2 Sep 2025 09:50:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2FA398E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:50:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1AAEB6B47
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:50:58 +0000 (UTC)
X-FDA: 83844446196.08.B934FF7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7D26C1A0009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:50:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DQbDyaDu;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756821056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjIO8VOEjJ/H4tg0OoEy8m/wse6tQSWY2ahEW3Ut7lc=;
	b=h4nQg55gVdIB0F7vW3maYtKW0HHAm0NNSxPGRQrG831Ue6LLsdvZ4CNqbUKferReWJGCsz
	JmqzMCXFg2aqLazEEoP+uaTlDZSLq5WUxQMt4u4YVmMG3Cf7Xqr2v2F0An2FniP9G0A/2y
	zMf1e5qhYc53yVALGwKBDGYgyMPvys8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DQbDyaDu;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756821056; a=rsa-sha256;
	cv=none;
	b=IsaygOtus5u3Zt98IrxLiSnJncGuRHe7yTTZybV/W6JCIwS0KqWoarKJYsUGwpOWDOY1u2
	VPj0oT9lba6rVssWhornh9U6O3RqOhe1Adyo8cudJ51fn9tbki2lkMqtJ64vyDB5pLXVN3
	1yjJWbGBLoKt/dU6MRVkt5egH4SX5NI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756821055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gjIO8VOEjJ/H4tg0OoEy8m/wse6tQSWY2ahEW3Ut7lc=;
	b=DQbDyaDunOcJsKacoQ5dU5YtQdbB3wm/lB92bwD4Tch7Qar6MFXj1A9NE+QTuHXnw6FZtm
	IZBEPtfewq6PthZqAPmvWq8etvF7d0jBuT/bAJjJipNLTp2tUIEZ49iSnPsOkCqLu9/Qg0
	fyw2hThotDgPQZOXbdGoQeOrK80GFHU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-MpZZp3KXM8-bHamLmukWrA-1; Tue, 02 Sep 2025 09:50:53 -0400
X-MC-Unique: MpZZp3KXM8-bHamLmukWrA-1
X-Mimecast-MFC-AGG-ID: MpZZp3KXM8-bHamLmukWrA_1756821052
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b920a0c89so6060885e9.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 06:50:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756821052; x=1757425852;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gjIO8VOEjJ/H4tg0OoEy8m/wse6tQSWY2ahEW3Ut7lc=;
        b=CGflkKa1UDOpGTU5tPJrpJxeD6sJm3/g/e8V2trzSAEhSnyc9bFEfZSQrgX/Txp7Xn
         /7+W70CedvhFoupil19unCvWc55ld37l6cMsBc0wTiN0WG7PkAVX5j+PRPCHwKG912PP
         gv5WW9DZyzA3HH95rKI3aLSFcaftAOaK3Fkn0pLwWFkew10HpWS0WHwQFfQShppDebWN
         eGGSa9p/qTTBTGKHXDIu2gWC6pEroIfDEiqlQYqTrQ2SgAlAOio2CCC9VSBv6wF1oTsa
         c6xN/57DtSC/EaQ7ylU34CQSqGHWrAxZrPqYCUAqViwxxg6mIXTDCu0q7JwtmR7Zy3+3
         ZmaA==
X-Forwarded-Encrypted: i=1; AJvYcCUSuUcx9giNntb7Tj6DNn+HVmU2+GfJwKLTIg5BxO/lRdgXOqopPRQf6K/Z+Ew0USBnvDQQyyKMFA==@kvack.org
X-Gm-Message-State: AOJu0Yxh2AdfNHVUZm5zAntWfg/7MwR/EYT5OUVfaN/+8NNCqjcIzHL0
	j7ZIVBVMXFvfcavLLdyA9iscYs1sYwOpkgLAOuGGbn68thxDxFGPcddyDHXeOLhL/cRJCp48jf/
	LWFE85LRiOVTWhsycM/+8OWdN1JCNtdHeint4FslJCxPe2rE1dbSY
X-Gm-Gg: ASbGncsHzMDC1LO5b9IbgjORObko4TNKrpoa0xAdJW2DkG56gK5ltcMvmjXE88aePmt
	7/Jgpi/qHIb+HYXwMt+UYxa0tsl2iY827F8lAY8KwhjEhzdOJEl8Nb+Kc7XJimL4/7fe8vt84zr
	yDSxR4NAjQ41JEvO59ooxcpzIQryiBU+FwqnQvEMB+dm/TvMWOyHT58IfjjmZP3rb+LnJ6/H0VW
	0fQjqYdUFcPuSLdVxU03IFuhjYZuMWfMxpxWShJVrN044Nw2BFcvsAje1AYvBMJMc88s7quNRn/
	dN2QwH9KNFSb8cDCPLiA7Jfk+DEzJhSDWeHEswVdotZCJtXymNJS0RfnWLQbGnKKA2wDEyMwnoz
	JuuWPCN3zqx8d1KUjkTXfjhe3FBLu6KyJBvA2JThg9MfTnF2kIiVdH5C1ZjfPO+EqH1E=
X-Received: by 2002:a05:600c:1f1a:b0:459:db7b:988e with SMTP id 5b1f17b1804b1-45b8554eb75mr86986685e9.13.1756821052441;
        Tue, 02 Sep 2025 06:50:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGE5rw3XcMK3gm1igeQlOk7pSVENRSC5jy18vid34H5lOCgcV+oH6uu2ahStX5eCwpxOESuPQ==
X-Received: by 2002:a05:600c:1f1a:b0:459:db7b:988e with SMTP id 5b1f17b1804b1-45b8554eb75mr86986345e9.13.1756821051980;
        Tue, 02 Sep 2025 06:50:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b98e77231sm27328225e9.12.2025.09.02.06.50.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 06:50:51 -0700 (PDT)
Message-ID: <516d445f-eac0-4ad0-a337-6c669f1ec191@redhat.com>
Date: Tue, 2 Sep 2025 15:50:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] huge_memory: return -EINVAL in folio split functions when
 THP is disabled
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Kiryl Shutsemau <kirill@shutemov.name>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, willy@infradead.org, mcgrof@kernel.org,
 gost.dev@samsung.com, Pankaj Raghav <p.raghav@samsung.com>
References: <20250902084036.208921-1-kernel@pankajraghav.com>
 <qh7s3j26aac3hyzgnr2ee6byjenstxhjnlwn4qxbvz2l32ohqc@qbhdxvpnuhtp>
 <90cd5be7-cbe6-42c5-b0eb-bf9613047097@pankajraghav.com>
 <6l6f5idkqebpai6qn6n3phbnydz55typdwmvp3eexwnhk4qr54@otcgssegyqke>
 <519df8fd-b02d-4b4b-bf47-79070e3d2c9e@pankajraghav.com>
 <h7pqst5vvkahposrvf2iy5qz53t4crrujold2ky4ssrpawaefv@yaqaj3so2hxi>
 <ic5kobuxfm4zi6agfvosjxs325mdgrfpjz52mi3zn27epbuvef@z5dmowge6uyb>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <ic5kobuxfm4zi6agfvosjxs325mdgrfpjz52mi3zn27epbuvef@z5dmowge6uyb>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RBFaItlK2J7GOyK4yUrdUgTcyUUxjy0BiL6Oj8m60W0_1756821052
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: eexhthak5cmdu3jo7bskbsk9j5anixwh
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D26C1A0009
X-Rspamd-Server: rspam01
X-HE-Tag: 1756821056-797218
X-HE-Meta: U2FsdGVkX19o04peur0XiWOzoyCTGTeaYcw0lUGQBGSQeg8EcHcqPmP/aZri1P18WPMyVUhO3GUZOytkY5rUH1AFURlWRhw2iDT5M5nxdw/zLkC6SdR9XqsLtpFOBnPZWP3EKmwNF2lQSydteGagjMsIylEmRD7RzXA7m0mbgvYfKQFlbmFRfH0zek+zsJaPMxJElmGZ8+0vT3eG6/tl7jMNZzDc90661/8UjyuUYi0kDaAA4qbL1r969EYDllfKUhb5DheZCFPDJOa1Ce3ju+cpS1ne9ndg57xDjUbXAIRit5xEGxSkKH3q5G0w5HItlmZde0On5NPB0tbGOVbPtRcub5MG64XswANXoJXlXLJmTpc+9yejbhKLKzpfc/ow7IbG+FTcjTA6ze5E62WIvd+Q179enAAZp+/N/UGnrD3F2O8P4I0Tn8iCZ/myfFCtg/XoH1qoo/zDkLbA++drucjmIqHXMmCu8ZdXH5EOIUNPKYQu4LbJDZLqEFEV3x4Yc47cIMI2hn31ArORATskmiHFwJ2smDtDfMqSfEa1CKllDMpMThF99ZT0VFenBnI0uW05RGN5bL02Q4CmznIuOWUUPL1ijA9F3bz4pEUQZZ3d1qU3H7Uh79+VRWKNOnkw2+dNlTYAIi9C73Ua1fa9OJGEdXYLfbTOFo4I53NAm5qNLWUXP+XP5uVxzxGOkcz5z/+mA8SYOOzPd/VGMRO0jn8utSle8MP+SCnSPScw8OVn//tmdwRz2R0L1HlUgtdzQPIL4RTiKVNMDtFrPPj2SidgdpU5/efHJjA+lQq33xq5EPGvU7g2bsEqDQ9xu8WCB+jRPF7OkNeKupPgXWN4x4CNc+rUDRjzPSMeVEQ4xwPoBV9Y22KiWNLgfj5Kqm0TtIKDqZ5VvIlHAyufulIZ9HWs2YwJ3RZ3ZHCw3keozNeh/PKzVrWTBKKChfZFXPDsgniSYUHsQpk3ylSTTaS
 3Ma6/gIE
 B2rTXz9Pnylsxyhnnh1BRWrVNWhl9IRsb3mDxyP/G4gthmRFfihHG5sU7brL89xTflvK5zwDPkIvTwv9KaVhsnuqjC046l082xIoONoM4wYKa9WNYSlkYNe+QfYPwzSr9FyeV06n324oMnOfVLrX2Yk09WXLYxtJry3mSMSn5LONy+r3V6xipIQOjc9VOs/EH3da6GYDkVdbXHnpcqq7dTnzoqvng+KN0e9ezqX9nITtulY5arGIPp2dfd8J6LI5UwAVOw0aRm5cPkEgZVBRKr1lCvweoMpqYKxFys480KcBONhoAUiqfAgOlIs/BQK2tTNRS5/3MzbNUA46KIhY40C+2ugrAd2mCMKrlN5lbyBbUMFMSOLOYrjXiKtXBoTuf0rqZgKhBEceQaIvgH0asMjizL4LQ/Ukn+usxZ49qjJDeJi+D5KGwOiUeev4ut/Efc8UXzXqXfX03VT+LYTRuD/xpmIMLruVgIyjouwtZXwQGswmQjPuc4dhJ/mPiJ8JgLWlM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 15:40, Pankaj Raghav (Samsung) wrote:
>>>
>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>> index 48c4f91c5b13..4ddf9e87db91 100644
>>> --- a/include/linux/huge_mm.h
>>> +++ b/include/linux/huge_mm.h
>>> @@ -588,21 +588,29 @@ static inline int
>>>   split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>                  unsigned int new_order)
>>>   {
>>> +       struct folio *folio = page_folio(page);
>>> +
>>> +       VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>>
>> No. Make it unconditional. The point is we don't expect to see any
>> splitable folios, so no reason to get here at all.
>>
> 
> Got it.
> 
> Just one question though, in a future world where we remove the
> dependency between large folios and THP, then we can revert back
> this change to do a conditional WARN_ON?
I think we would never expect to get called to split something that is 
small. Calling code should be fixed.

-- 
Cheers

David / dhildenb


