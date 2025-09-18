Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADC44CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 08:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155E88E00DB; Thu, 18 Sep 2025 04:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DFC18E0093; Thu, 18 Sep 2025 04:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE9FD8E00DB; Thu, 18 Sep 2025 04:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D64D18E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:50:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 814C3C084C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:50:58 +0000 (UTC)
X-FDA: 83901750996.18.2AD9F9E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0B1C94000C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:50:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fYFNaz6f;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758185456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CH/v3gIbyy+WCPfE/8m9cLd0LwiA2CCBDF5k/DDktME=;
	b=smHi0cfDVFRzHyILzClxp4nAciQexHIL9V7Stsh03jj+Te3DLnCV64m1PwA9qj3mt7l/dQ
	7pMqePQkGDZi72J1Zf68is48xFOjmXLuyh4afm90Nbua/SttPlPArP8e8/1KX+JMWhVoG6
	MeZQc1R69/iQd7ukIiwG9Gfj5cnpXd8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758185456; a=rsa-sha256;
	cv=none;
	b=CHE/iDPA6EnEYE5bdIqgo3BgYnmAkGVaoFW6Tv5oGC/iNOkcnbeF6/AbkL6LaxXLJldo4G
	J0pxTlPoDB2dhWbe++IDO2iKvlXlukrk7u2TYGCf+SbrltuEcVpmIkVfSSYQMWduVL/YTw
	kQHiU9w+9E43XVAJ2IHETgbq0y233JU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fYFNaz6f;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758185455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CH/v3gIbyy+WCPfE/8m9cLd0LwiA2CCBDF5k/DDktME=;
	b=fYFNaz6faFhcS96iFFIjRr3BdfxXUcN+NoVQIxIfjufB0UiEZaKqoam8ozZEE7l4YgMRs4
	yhchxJcyYVzFXaTLlz3FvNr7sVdgFzt12a/eClf4iPgHSTMFM676DCh4JzBJlWeycNrl/h
	5xgoJUfGFONGhOkRZzKTyhMQu69revs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-dsm2nceiOGOkZy1Nt0zwiQ-1; Thu, 18 Sep 2025 04:50:54 -0400
X-MC-Unique: dsm2nceiOGOkZy1Nt0zwiQ-1
X-Mimecast-MFC-AGG-ID: dsm2nceiOGOkZy1Nt0zwiQ_1758185453
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45df9e11fc6so4644575e9.3
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:50:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758185453; x=1758790253;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CH/v3gIbyy+WCPfE/8m9cLd0LwiA2CCBDF5k/DDktME=;
        b=xP3memz66rTftaqJPsqx9IrV18agrz5pSuctYyo9PxI0LyEmSdgDJGohukyv9PuaH7
         JeNYD0G7YheemGQgDc8NbFFUbTqd0Xk71mHiOqoEaflMgshQMeQGV0PqKlFoR6EBhrd5
         s3cvady21DSB37OIetqEVFyA/1vY+L/Xc+iV/ArDH/xdtB4fCG5xYBfUkzHBzzPPp8Wh
         80rnJI5kJhiG15NEFuxEd/6FdR0aWwfc/ms2A/FlJBwrDymcCb+ruey6XQLuzPpRmUwh
         cmj9az47YdzXrD5O+jCNLi5xUeX58gPCeMxIMUSzxRIo15XpINfRMTgs9qXJ2xfws7ow
         UaKA==
X-Forwarded-Encrypted: i=1; AJvYcCWTpDv2YKt1IUEMiqkPhrNGrWQMEVbUojySQhQRGvWAAo/kJ8AVJN5TC9AEvLXx6/88dmOv878gSw==@kvack.org
X-Gm-Message-State: AOJu0YzfVuTg1iOQAiCd05Tqvr9e0KwyXjRuG5SbDwrlRD6SEyOCw7Fi
	cH/SeFYcj65jEkia4wQaIIhHCc8t3U59k9O/XJEmHlmYn+85G/N+GVNl6xC5SwbBQtRd4bNdjPE
	xn3+Wp9seWpF9CctwQG9FJrHn84zfVIxunVs9T3LxHUaET+8hZzgj
X-Gm-Gg: ASbGncto5URsRCOVV+ySNlrZ6qFPbU/m+Y4PoupW98Tobt0H3FxIm98tlMDzGF4Fwyc
	tAZfd4nWnnIWBNais9i1e/IlioL4RxFzw2Pyo14ftkFXGzPE/3Pka9aWTDheDWUwgo6wR/L1tEX
	UX9Bf+j0kg90AP9pFRmfJ6U6Vl0nflqgPQX7HMUlYt49cML0nS7Z5vniTWJ5DbAJg16m7hS1jd1
	oRnKI0V1tJoqQ3uht/PVa7iU2Ak0P2S6FY85GLxX/WpISIBwGmGIMifTgXG13D57y14WKdfQQTt
	wPs7iPeaEKZj+WvIsYwfCXabKXw6Sw7O6sM9NLb5zwW1vTIgBiF1Z9Zs3CWe0WbcvoEHNMreZzU
	vYULAovOxEWzxdAVHorcn6l3fT2y6VBrCew86HJBy9S1xMpmVV4oMs+Rme0lfCLkald5G
X-Received: by 2002:a05:600c:1c9b:b0:45d:d9ab:b85a with SMTP id 5b1f17b1804b1-46201f8b09fmr43949675e9.7.1758185453032;
        Thu, 18 Sep 2025 01:50:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9uhP9lU2sbclYjkhVEANMoZCPkO/bf+8HWAZr0cAYfclDLXHCDeLCvCQTcNZzgtXxHqXTaQ==
X-Received: by 2002:a05:600c:1c9b:b0:45d:d9ab:b85a with SMTP id 5b1f17b1804b1-46201f8b09fmr43949445e9.7.1758185452623;
        Thu, 18 Sep 2025 01:50:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:dd00:ca9c:199e:d2b6:9099? (p200300d82f07dd00ca9c199ed2b69099.dip0.t-ipconnect.de. [2003:d8:2f07:dd00:ca9c:199e:d2b6:9099])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbfedd6sm2725928f8f.60.2025.09.18.01.50.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 01:50:52 -0700 (PDT)
Message-ID: <e30cf8a8-b58b-45fc-9df2-adcd93c1a095@redhat.com>
Date: Thu, 18 Sep 2025 10:50:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmstat: add header line to /proc/buddyinfo output
To: Ye Liu <ye.liu@linux.dev>, Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250918071741.526280-1-ye.liu@linux.dev>
 <aMu01xIkj-3hgW88@tiehlicka> <1a9f44a1-855c-450e-9dc4-415a29b90011@linux.dev>
 <780aa9d6-a85c-4050-820e-c0ca9f5bb658@redhat.com>
 <6d6e2e33-c221-4ab8-a29b-3d14fb1a592c@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <6d6e2e33-c221-4ab8-a29b-3d14fb1a592c@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -gMumx1STfOsXiBUEVZ3dbyNUd1AiWdrLMpmVF7E1x4_1758185453
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0B1C94000C
X-Stat-Signature: owbpn7azeedadxn9nwugqdmtn3c1d4z9
X-Rspam-User: 
X-HE-Tag: 1758185455-465928
X-HE-Meta: U2FsdGVkX1/wd9bGnK0g5cOlA7cd2aZIh1a5MMdD6Nr0uR/q0z8lP3MRNOd2XdtGientX8myCKVal+oStxyG41uGv2HEXuxF7K7T/pONmsV2KU+gorgXp3eJPDarqYg8z9ovpetFQfu73GzzoHN8ae75tW6fBuBafMhGkEn4KvEWO14S6F29i6GTDv5qtTgANU8dFTxgTh1MCUkYId9m1RKbaNaishjt1m5tp+jd1Q2f0dId2hN/BHFaX2YZ6V+N5UB+G8exmUmd4bp9GhIJBJXF6A+o23B2RVu5+o+htu4jSrnrf+3AeD72qCJ3Lsd8AyxktBtdoPAXTEUueP8fBpiKaCj+4khA0JyXFq5ZGobb6vs9Xjc5PAm7V52Coq1ZSFRGYfdBl9d34W3ObEo5FPr9q3qeAxhmxJgrTDa9/Oug5bh5wpfO4QWBSr1KJFrG4mNvl4shK1Ss1MrKtimVuFPgT9jJ7eh26Tx/AvnJovNc78QskZ9rMkjmQEW1dyzr7v+MmF1G1DwOTrrwyg5JVxf5xlGb4u0XAjS+YPmmhg4N/mZ/n+GPo/wKqd8omRriiqrXfu9cF/i5HWf+9EgmOMNgItr+JN+QDM+uB94oLhhVFTqTBqeuCJuTon7RhUcA+nPjxLsg0M9lWy9T/Fm8fsnWm5+onVa2z0GdO9WiOh9KIihYkd5IPwEl6OaV3BhYMwJ10iVUiIS0JrwvEKZoi15A7Cg3yTD/7qI1JcBbZL6FMKWcNIEmajZF3e7fK1I44UYO/FFDTv9I+REVHWZerk2U5fBFApA7kpMven4V8FFUkNYxIyjBs3Y5fHPHdkbApcuJYNKFRdqfeWt3oNngSkGBu1XtY/4MNpmPVOdVTxFDr2Uy383dtqCaGR8lwCAGUhtSazPR9LmEbMsxS1oxiq0iq9DJFIdqsyjjIxzUdToERXIZGxg6rjC90YwEfMsxqT0c+vDDqvzIUd8O5AR
 iMmLBRGh
 n+cdHD1ZKUFwjDVZdZVnfAg9H7Wq+0wLxUitFLhUMJ83k1Q25DcsaQZEDgjRL4H+/3T4nW7o95Ysmmaa99a8ZqbCsR7TjOdpOhmD1NYCata6m+LwGacgatt8z2+86jz93Dfl8pXYLG3PLWOseshgElJeLJdrEitbxxW86Hyhl8GQ/BNsIf8R8Dqx57qawMyUCYySQKdMyF3Epyj2ecmJoIyFlf6RKN3A9RJzbVbvlhuWY6+3rQwOSH1/sKQwJa3+BE+uwgQQUO9zvDqx68ZZEx0gt9tFV4c0q5LXMHcKe1x/rnUnTd2n6vuSGuil0f74O0t/qB01jKAuflQXx7UncouMoyGBSVgB45ivH3f20KRxHqMLfzmgIxMXjKBtohcl8M1/6bP+4QB1ksyjud+qPNLBQJV1AIU0LK8jWUA6P++Jxn5Mu1Bgphb2E0ENZRreXKhT+BxBEmbuqbPAU6MUJl3zTvxky+qAVE750
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 10:31, Ye Liu wrote:
> 
> 
> 在 2025/9/18 16:16, David Hildenbrand 写道:
>> On 18.09.25 10:11, Ye Liu wrote:
>>>
>>>
>>> 在 2025/9/18 15:29, Michal Hocko 写道:
>>>> On Thu 18-09-25 15:17:40, Ye Liu wrote:
>>>>> From: Ye Liu <liuye@kylinos.cn>
>>>>>
>>>>> Add a header line to /proc/buddyinfo that shows the order numbers
>>>>> for better readability and clarity.
>>>>>
>>>>> Before:
>>>>> Node 0, zone      DMA      0      0      0      0      0      0      0 ...
>>>>> Node 0, zone    DMA32      5      8      6      6      7      5      8 ...
>>>>> Node 0, zone   Normal   1113    351    138     65     38     31     25 ...
>>>>>
>>>>> After:
>>>>> Free pages per order       0      1      2      3      4      5      6 ...
>>>>> Node 0, zone      DMA      0      0      0      0      0      0      0 ...
>>>>> Node 0, zone    DMA32      5      8      6      6      7      5      8 ...
>>>>> Node 0, zone   Normal   1113    351    138     65     38     31     25 ...
>>>>
>>>> Why is this needed? And have you considered tha this might break
>>>> existing parsers of the file?
>>>>
>>>
>>> Thanks for the review.
>>>
>>> The reason for this change is simply to make /proc/buddyinfo self-describing.
>>> Right now you have to know which column is which order; with a header it’s
>>> obvious. This is similar to what /proc/pagetypeinfo already does, e.g.:
>>>
>>>     Page block order: 9
>>>     Pages per block: 512
>>>
>>>     Free pages count per migrate type at order   0 1 2 3 ...
>>>     Node 0, zone DMA, type Unmovable             0 0 0 ...
>>>
>>> Regarding existing parsers: the patch does not change any of the existing
>>> “Node … zone …” lines, it only adds a single header line before them. Most
>>> parsers match “Node” lines and ignore everything else, so the risk should be
>>> low. If you know of any existing parser that this would break, please let
>>> me know so I can address it.
>>
>> What if there is a single one out there that has hardcoded to skip the first line only?
> 
> I understand there may be no way to be fully compatible with all existing
> parsers. However, /proc/buddyinfo is essentially raw data intended for
> human and tool consumption, and parsers are expected to be robust against
> format changes.

Let's take a look at a random one: pcp-buddyinfo.

Reading the source code [1] of the /proc/buddyinfo parser in
refresh_proc_buddyinfo() I have my doubts:


     if ((fp = linux_statsfile("/proc/buddyinfo", buf, sizeof(buf))) == NULL)
         return -oserror();

     while (fgets(buf,sizeof(buf),fp) != NULL) {
         char node_name[128];
         char *zone_name;
         unsigned int values[SPLIT_MAX];

         i = read_node_name(buf, node_name);
         i+=6; /* erase ", zone" */
         read_buddyinfo(buf+i, read_buf, MAX_ORDER+1); /* read zone name and page order */
         zone_name=read_buf[0];
         for (i=0; i < MAX_ORDER; i++)
             values[i] = strtoul(read_buf[i+1], NULL, 10);
         for (i=0; i < proc_buddyinfo->nbuddys; i++) {
             if (strcmp(proc_buddyinfo->buddys[i].node_name, node_name)==0 &&
		strcmp(proc_buddyinfo->buddys[i].zone_name, zone_name)==0)
                 break;
         }

Do you think that one would survive your changes?


https://github.com/performancecopilot/pcp/blob/main/src/pmdas/linux/proc_buddyinfo.c

-- 
Cheers

David / dhildenb


