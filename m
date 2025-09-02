Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 951FDCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9996B000C; Tue,  2 Sep 2025 07:03:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7A5E6B000D; Tue,  2 Sep 2025 07:03:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1B276B000E; Tue,  2 Sep 2025 07:03:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6D156B000C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:03:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4494D85DAE
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:03:16 +0000 (UTC)
X-FDA: 83844023592.29.5140A92
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id D91B18000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:03:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T5WDwfE4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756810993; a=rsa-sha256;
	cv=none;
	b=NuHICKU5sgM6f3VFt2bWW2WJ1b7gOPYnOxuNiinK46iMxEypiiamwmfutp797e3ywiLqNU
	daUdVFyhwbpgpsgN/TYrfgXbOQVI5nv8FsHDam6Z2BcjNJDSTAw9BN2RA4nVfGzY0p5VAq
	p2/3Y/PqhmasvQ8enViHRQKQgQKZmGE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T5WDwfE4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756810993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCSqN7NYIuXHdLAecMsccrDweJPtJmgwNiDlc7rsnHQ=;
	b=Q9n7iJYSGHENuCR1DuVbnaRz4yBtxxeYcsDcADnkUd9zwxU1rl1pZnNcw1GQ+NYhEUHj5u
	ScVx0BeMJb+FhKhcCD7UMnaa6jOgiBaCicj6wuFiQcI2tOnkyxiFG+HbKRqputz/JKs1Lf
	KFqisfuoMuYSb1woYCPClXTSP9luShA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756810993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gCSqN7NYIuXHdLAecMsccrDweJPtJmgwNiDlc7rsnHQ=;
	b=T5WDwfE4Vxx9jw1fPi14rZ3yV+0V31jQI8UR3aJkNErzyAwNRQxncd9FhESASx0juU3Jqk
	vvpghFcl3ul3k692HT7b4PgI5k5f2me4q7pmU+YsDCBfhlcBIWHbrk5EVVARx9/wTLAc2o
	GnTzKlGt8UJnjAu9bSk3MLko5h/tuMc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-dDVxjZ3MNCuTO2jqMCi1Hw-1; Tue, 02 Sep 2025 07:03:12 -0400
X-MC-Unique: dDVxjZ3MNCuTO2jqMCi1Hw-1
X-Mimecast-MFC-AGG-ID: dDVxjZ3MNCuTO2jqMCi1Hw_1756810991
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b869d3572so9621645e9.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 04:03:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756810991; x=1757415791;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gCSqN7NYIuXHdLAecMsccrDweJPtJmgwNiDlc7rsnHQ=;
        b=dD5eNW6xgVMCry337VKacyh2pSSs6H71MiB0nUGn+F6gS2WooSZ2gT3Wu36s1zKdcp
         iLz3y5nE3jqGECeJFkMnQYpi2gnCgr4V/6+R3jS0qburEjtiEA1LwINilgDZy3hKtrAF
         Hr2J02vlqGewCqpZoyIOBV2AJV1qrVeREk5mIeM3j8hLmqz3cFsu5gbakmaI4gLc1OLT
         w4hRSC1qAYKcIl5aj2nuaMQdEgz4NdmxdtBWRoZMr3igcdXQknhyis01oqeK0kmzFISy
         GLgaAPu/KGU/bQWlWucGga2SpFExdiP4P8pHG1K4ArF6J+Y76h+ndKq6R4ZXH68dVfSW
         HC3A==
X-Forwarded-Encrypted: i=1; AJvYcCXw+Uam6sSXJ9AFjZtIONrYwPZsyK7FBjjxtR4A6/0PPvsXejXKXPV5gCYKjyu0iSne5fYwwJkRZA==@kvack.org
X-Gm-Message-State: AOJu0Yw9oh4uEV/wKW6MkpDtQjS8YiiKFrBdjWsv0dRJxNU6aNjRA8I/
	1MKZoB78yoDRBWZp2lfsk9Y/qN4/VVqF9UvM5Myni5gtqHM4Qe2IircZKXWOIL4Bw7ky2NmOcQ2
	2S1WeqD7YDgEOoHxmlj3V7QhQlCZ0JZilpQZeJZhXFtDufnHV/3rC
X-Gm-Gg: ASbGncvF1tF/S6NfrSVwW4Fp1xLWN1O1Hk7KPznF1so/SZNgUmcXGtKtKRefyzPektm
	bq3w56dVqZQV+GBk5o2WGzpu7TPCiq0fMtyZeD+rCzrecmmfRN0zgVGwCXm4XYEh3jWU928nWpA
	KFEMqw15q2sO5BvioXGl5LezXcwT+RrMZ8lbieBpugdJIPrLyrNKlGathCJ2kJFAcbnwJVplI6e
	DXKJHI/cEKrLp1Zv8YmNMXt4QE6U/rkRa+QTv3jx4pFKuMyR5uqnzMG1wBg8ewV2FOr84VwL6od
	cYeFeNqSrm2UkrDMs2uUPcvB0dBy917uHwcDAW4PW8054Dcd1AEnXSMsGrqDYtJbx4Y07IOQOBS
	wQkjPSbflVi54KER2qSrtl763BH1fwy8SayKRHFM191kEpDyEU+aTMw86TRUWNgRxU2s=
X-Received: by 2002:a05:600c:3ba5:b0:45b:8ce1:6d4e with SMTP id 5b1f17b1804b1-45b8f97cb7amr37617565e9.33.1756810990752;
        Tue, 02 Sep 2025 04:03:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmcwCNsyllSmlm7X3OEc+SbR5UW+tkEOHD7ix+S0rkPYayVjoEJV6qhJeYYoVmAdcV3TK2Aw==
X-Received: by 2002:a05:600c:3ba5:b0:45b:8ce1:6d4e with SMTP id 5b1f17b1804b1-45b8f97cb7amr37616885e9.33.1756810990127;
        Tue, 02 Sep 2025 04:03:10 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b66b6985bsm182588615e9.2.2025.09.02.04.03.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 04:03:09 -0700 (PDT)
Message-ID: <287f3b64-bc34-48d9-9778-c519260c3dba@redhat.com>
Date: Tue, 2 Sep 2025 13:03:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: Usama Arif <usamaarif642@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kirill.shutemov@linux.intel.com,
 aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
References: <20250819134205.622806-1-npache@redhat.com>
 <38b37195-28c8-4471-bd06-951083118efd@arm.com>
 <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
 <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
 <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com>
 <5bea5efa-2efc-4c01-8aa1-a8711482153c@lucifer.local>
 <CAA1CXcBDq9PucQdfQRh1iqJLPB6Jn6mNy28v_AuHWb9kz1gpqQ@mail.gmail.com>
 <d110a84a-a827-48b4-91c5-67cec3e92874@lucifer.local>
 <95012dfc-d82d-4ae2-b4cd-1e8dcf15e44b@redhat.com>
 <bdbb5168-7657-4f11-a42d-b75cce7e0bca@lucifer.local>
 <e34e1ffe-c377-4c9a-b28b-ca873f3620ac@redhat.com>
 <db2320ee-6bd4-49c1-8fce-0468f48e1842@linux.alibaba.com>
 <c8c5e818-536a-4d72-b8dc-36aeb1b61800@arm.com>
 <2a141eef-46e2-46e1-9b0f-066ec537600d@linux.alibaba.com>
 <f34b5fcb-6a97-4d97-86a8-906083b53be6@redhat.com>
 <eb02c281-6d41-44af-8eaf-8ffc29153a3a@linux.alibaba.com>
 <286e2cb3-6beb-4d21-b28a-2f99bb2f759b@redhat.com>
 <17075d6a-a209-4636-ae42-2f8944aea745@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <17075d6a-a209-4636-ae42-2f8944aea745@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: P0K0P94Mf_Hgp7Ci9uSBPP_G7w1QYn7D-_nZ1MCNwuk_1756810991
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D91B18000E
X-Stat-Signature: egchiusrnn9z8sa8ce486irwh7wps5sf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756810993-794843
X-HE-Meta: U2FsdGVkX1/CDqj2DZuwoKqjf+CVdpF/SXcJt0SX3hjZC+OOn+EJohH/8WAvw8kSgHfNc79dhgaVwC+eV1EN91HsJmtJHawpBB7j7SH9iQz0Q/eW/Z1hRjD8JQ8gJ2sGlm6I56Pw2k8GHlaWX0/YgsaUqYbAq82kcLzG0QWBDcpcRhW00TrgEfRbplpFEq0Xx1IIjEib5Y++pY22TFd+kD1lu0T2XVuBeegbCSRGxsAP+mc9bS13y1nq1+j9dOmx6DVk28fm6sV4xapKlXoP382AZHjJuoL2l0v2HLm3gS1etMcdSVWNB5u2mHEC9BLl3IUS69ShyFH6QnS3zthp7lCiIIK17pxbFeLw6Uj+oVZki/9ODrFNQ16q6D58l0BRMdaQ8AMSTdgC0ZJ5GNtjcKjDP33ucZcz1smUIY+MbZRl/U++ufOOP+p2zWo7WmYyMGmih9vNtFLXNbU14jYbBQarKfa9wPstz8djNCzgRYLWuwUWvXQb6Pcpqnxx5s9wRdieIctSc0o286kRcseA855lgw2FMxaSigi0QDJqzp8b9jP3I6qKbyuoCD7SH1361x5SqsL2UjoVZjAw5mkaPyKVv3OE7GbsmUhdTkp/6NfLzrPym54Ro5qOILpDByGctm+Yg+e9xAcgmy6P4yyCth8nO8z1JPJof5dK0wy3F9a1VleQ5FZzfc0MQW3Gnt2QB8OFuNc8j+YiFcCNBvLHkwL3VdLyy7P1Oaoj7UJ7wupvjMjlEhXLVsiW9UrsgEhSqUatR7F6tVmC6OjdydozvEUrNRThToEOLXxr0YzBT7syxakZBqFAq4Fwy4ThhlyJcNWJwUVQjzNT8za36C99rHGrH2vC31XufMj2OYP0ZNNsPGWo10VSG14Kd0FqgE64hHKHXGgtk+n57nPTvKEaBnI1fVXxAQleRjq4Ys0YUSLkQYh0kQfYOUFcs0Wgu064BWfIdjbG8S3n2xh62bA
 q44LQ+HI
 xH3s9FnuZl7lKaEooeXSUTUca4ddvVMMq5w9AfemkZ24EIhZ5foKuj25e1RtIATVlBME8OV6FATqvkrH22M2kU2yJbaThXfFsuyT/gcqWFFd4jbxV2Oz+JJk18xsXiiQZLvqjtapMvV2tsjbev4WT4+dIZB8u7gVSn5y5FkiEnF306YdboFyogs/KZhgi032BCQIfF+Gyo8P4ZuNnYTLz8Bi3qG+tCOsRO33R6xC8aCdAmqRkxfBopwHW+xKqgip9/ZGscrrwPmiTsKQ45HDL2jTX+Rtnn1mnIsbz62AwFnJvdFV7puzFwm+xTaQXaS/QwkfWr1CsPxqzp7uk60n1H/R0Qw1Fb5b0+eqgafASN10QzwIdpZTGE8yto4qUAtg1SwrZLdRTh9eT/7nNL6J/yHi0lVEmGVocnQbjyp716YQqJJvJylHip20XIFE4kEL4llAxaMMB1TI97za26dJs1NLow7s6Ye6HJ5Q/xTlP+xWJsistAPFCoqHyCBr67HqJYGQLO/gwutu41ekKR6aTtI6ynA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 12:34, Usama Arif wrote:
> 
> 
> On 02/09/2025 10:03, David Hildenbrand wrote:
>> On 02.09.25 04:28, Baolin Wang wrote:
>>>
>>>
>>> On 2025/9/2 00:46, David Hildenbrand wrote:
>>>> On 29.08.25 03:55, Baolin Wang wrote:
>>>>>
>>>>>
>>>>> On 2025/8/28 18:48, Dev Jain wrote:
>>>>>>
>>>>>> On 28/08/25 3:16 pm, Baolin Wang wrote:
>>>>>>> (Sorry for chiming in late)
>>>>>>>
>>>>>>> On 2025/8/22 22:10, David Hildenbrand wrote:
>>>>>>>>>> Once could also easily support the value 255 (HPAGE_PMD_NR / 2- 1),
>>>>>>>>>> but not sure
>>>>>>>>>> if we have to add that for now.
>>>>>>>>>
>>>>>>>>> Yeah not so sure about this, this is a 'just have to know' too, and
>>>>>>>>> yes you
>>>>>>>>> might add it to the docs, but people are going to be mightily
>>>>>>>>> confused, esp if
>>>>>>>>> it's a calculated value.
>>>>>>>>>
>>>>>>>>> I don't see any other way around having a separate tunable if we
>>>>>>>>> don't just have
>>>>>>>>> something VERY simple like on/off.
>>>>>>>>
>>>>>>>> Yeah, not advocating that we add support for other values than 0/511,
>>>>>>>> really.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> Also the mentioned issue sounds like something that needs to be
>>>>>>>>> fixed elsewhere
>>>>>>>>> honestly in the algorithm used to figure out mTHP ranges (I may be
>>>>>>>>> wrong - and
>>>>>>>>> happy to stand corrected if this is somehow inherent, but reallly
>>>>>>>>> feels that
>>>>>>>>> way).
>>>>>>>>
>>>>>>>> I think the creep is unavoidable for certain values.
>>>>>>>>
>>>>>>>> If you have the first two pages of a PMD area populated, and you
>>>>>>>> allow for at least half of the #PTEs to be non/zero, you'd collapse
>>>>>>>> first a
>>>>>>>> order-2 folio, then and order-3 ... until you reached PMD order.
>>>>>>>>
>>>>>>>> So for now we really should just support 0 / 511 to say "don't
>>>>>>>> collapse if there are holes" vs. "always collapse if there is at
>>>>>>>> least one pte used".
>>>>>>>
>>>>>>> If we only allow setting 0 or 511, as Nico mentioned before, "At 511,
>>>>>>> no mTHP collapses would ever occur anyway, unless you have 2MB
>>>>>>> disabled and other mTHP sizes enabled. Technically, at 511, only the
>>>>>>> highest enabled order would ever be collapsed."
>>>>>> I didn't understand this statement. At 511, mTHP collapses will occur if
>>>>>> khugepaged cannot get a PMD folio. Our goal is to collapse to the
>>>>>> highest order folio.
>>>>>
>>>>> Yes, I’m not saying that it’s incorrect behavior when set to 511. What I
>>>>> mean is, as in the example I gave below, users may only want to allow a
>>>>> large order collapse when the number of present PTEs reaches half of the
>>>>> large folio, in order to avoid RSS bloat.
>>>>
>>>> How do these users control allocation at fault time where this parameter
>>>> is completely ignored?
>>>
>>> Sorry, I did not get your point. Why does the 'max_pte_none' need to
>>> control allocation at fault time? Could you be more specific? Thanks.
>>
>> The comment over khugepaged_max_ptes_none gives a hint:
>>
>> /*
>>   * default collapse hugepages if there is at least one pte mapped like
>>   * it would have happened if the vma was large enough during page
>>   * fault.
>>   *
>>   * Note that these are only respected if collapse was initiated by khugepaged.
>>   */
>>
>> In the common case (for anything that really cares about RSS bloat) you will just a
>> get a THP during page fault and consequently RSS bloat.
>>
>> As raised in my other reply, the only documented reason to set max_ptes_none=0 seems
>> to be when an application later (after once possibly getting a THP already during
>> page faults) did some MADV_DONTNEED and wants to control the usage of THPs itself using
>> MADV_COLLAPSE.
>>
>> It's a questionable use case, that already got more problematic with mTHP and page
>> table reclaim.
>>
>> Let me explain:
>>
>> Before mTHP, if someone would MADV_DONTNEED (resulting in
>> a page table with at least one pte_none entry), there would have been no way we would
>> get memory over-allocated afterwards with max_ptes_none=0.
>>
>> (1) Page faults would spot "there is a page table" and just fallback to order-0 pages.
>> (2) khugepaged was told to not collapse through max_ptes_none=0.
>>
>> But now:
>>
>> (A) With mTHP during page-faults, we can just end up over-allocating memory in such
>>      an area again: page faults will simply spot a bunch of pte_nones around the fault area
>>      and install an mTHP.
>>
>> (B) With page table reclaim (when zapping all PTEs in a table at once), we will reclaim the
>>      page table. The next page fault will just try installing a PMD THP again, because there is
>>      no PTE table anymore.
>>
>> So I question the utility of max_ptes_none. If you can't tame page faults, then there is only
>> limited sense in taming khugepaged. I think there is vale in setting max_ptes_none=0 for some
>> corner cases, but I am yet to learn why max_ptes_none=123 would make any sense.
>>
>>
> 
> For PMD mapped THPs with THP shrinker, this has changed. You can basically tame pagefaults, as when you encounter
> memory pressure, the shrinker kicks in if the value is less than HPAGE_PMD_NR -1 (i.e. 511 for x86), and
> will break down those hugepages and free up zero-filled memory.

You are not really taming page faults, though, you are undoing what page 
faults might have messed up :)

I have seen in our prod workloads where
> the memory usage and THP usage can spike (usually when the workload starts), but with memory pressure,
> the memory usage is lower compared to with max_ptes_none = 511, while still still keeping the benefits
> of THPs like lower TLB misses.

Thanks for raising that: I think the current behavior is in place such 
that you don't bounce back-and-forth between khugepaged collapse and 
shrinker-split.

There are likely other ways to achieve that, when we have in mind that 
the thp shrinker will install zero pages and max_ptes_none includes
zero pages.

> 
> I do agree that the value of max_ptes_none is magical and different workloads can react very differently
> to it. The relationship is definitely not linear. i.e. if I use max_ptes_none = 256, it does not mean
> that the memory regression of using THP=always vs THP=madvise is halved.

To which value would you set it? Just 510? 0?

-- 
Cheers

David / dhildenb


