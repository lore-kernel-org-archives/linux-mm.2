Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7B2BCCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDAA88019E; Tue, 28 Oct 2025 13:49:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2A980199; Tue, 28 Oct 2025 13:49:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0F38019E; Tue, 28 Oct 2025 13:49:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B958580199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:49:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63324496D3
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:49:59 +0000 (UTC)
X-FDA: 84048261318.11.DF938DD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id D341A40011
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:49:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aPoXohSs;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761673797; a=rsa-sha256;
	cv=none;
	b=FBrhGC+EqnIrWlX2JClfQivQTSy1NCgGwHDShS4gEBvH2HiQ2LCoTU6wQRI7vzRpoJ1hJU
	0QENPXKTBdzqhpRvNbAuMI15EuTqb6j/1NzwVaTf6Pj+4pokLnN5/G1hpSdP0v1HqRH/Di
	Y+nZTzc+RUGkFaqyr3xK243e3NZhzCQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aPoXohSs;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761673797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0wjUs/xTYbM7Fdac3xo6xGaBum9uo0673qS9j9wmfiU=;
	b=zplQ0704dUossGR1fHCEqSz+C51omcYm3xy4dD5tqJGJkzLbMCZ70YYQSkVl0VbksRiW6z
	XPCHTK+nMXwWUrzuCooWGc/MkA3HdQl7JgPKV1uSUTLI3Eyag85QTmndbE6qf2iZ6MP0J1
	SJqbGRPtYqn9ayjCUGQe4/zktaX6CMk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761673796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0wjUs/xTYbM7Fdac3xo6xGaBum9uo0673qS9j9wmfiU=;
	b=aPoXohSs8TOySKf8Dw3cYUekTK/b2G5Oklyy6pHyzklCqSL/q4IwHZD7pN42Nf36Qg6GwU
	zK6TkoZ4bZS3+fQkuGSTxJG8CIHMMHZuqBUTxzCWRCibSt6tpYFTS801Yh06BX7Cm5jAYO
	JUAA9hddVK+vutLcgnY0RBvaGr6fxKA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-b6xkWd0KPJqZYXCz_VLuYQ-1; Tue, 28 Oct 2025 13:49:54 -0400
X-MC-Unique: b6xkWd0KPJqZYXCz_VLuYQ-1
X-Mimecast-MFC-AGG-ID: b6xkWd0KPJqZYXCz_VLuYQ_1761673793
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47113dfdd20so23223985e9.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:49:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761673793; x=1762278593;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0wjUs/xTYbM7Fdac3xo6xGaBum9uo0673qS9j9wmfiU=;
        b=GjANKvr/tV5+rQ217xxHYnNfGh69I8cSTJd2t2fHkB2Zf8SuiNS1q1Uf0UWNQ+YZYu
         15zCmbJQdr96ixRyxuoXj5eAnlBxFwOYadj0ByvnJi17ThfIruG1IC2fIGGGI5aOST+u
         Kp4Ogn8XQmPyXmaPDZ1gSMGiCzPMaWTxMfJF8E08fv9fxAAEd4VS/UxDH/Z0Pn38UulA
         YJ7oXfMm84kO16defJnp5+UgDYlXoqvgA65p/fHPq+assnb7P9tserHBKNPUOZ7QAtvW
         UI3S+7AfoZ2OSuo8t36hZJ5Z9RjeEWvUnLf/fzjVnI9l4EIXf9PVV7Sm0QQPHvqQWOrY
         ozkg==
X-Forwarded-Encrypted: i=1; AJvYcCWiDO5FXLuNOZvAk8nBRHaaf1I/t3SpFjQeYHqtxtIId44SvEEhCFs7zkbgZjUKO4C59Q2Yaxl9+w==@kvack.org
X-Gm-Message-State: AOJu0Yx1Y38Za1PviXSLFOs+3IMgvpWm20clcfy5D+g43kBJ/FkWCn42
	lBp5C9cNAiUAjLLmKFn2awD8VJzhUlExj9KpS8Ee22hm3q+ewzDXHD4dBVle9lL14Gz2opPPOrp
	7VeGRMGar/x8ws1wuVbs2dj2zPpRASN8EDZRfvf8Ch+lFK7xgZvcX
X-Gm-Gg: ASbGncu8WS4UaDHe+yJxRX1xY8fQxO91C9+No3p2fa2hOEzCfRa/1xBn5u4QVi9OS+I
	21VuzAsgKUAXYvmUwZmfXSKl8mDoGm9/PdIRKqdRs5YK0l79sY2EOGLYyh5OhujornJTkmPAc5Y
	pON5ZCW+RM1MyYnLCsZqbTGyciGsXetum3gUxacoNR05OMetJ8SAHuIhfq9Y9IpIwaw+3fjqlLO
	fSxn+w71LfSFZRit496Rp4CDkL6WDjuWkAeuW1RuuKxNaaLboB6dL/sfdwLRjJGniOmDi2V4F73
	BdcmJttM7c+di8UA/4zjH6TIOAwibCtk7L7cbeEarBgUnvtPeXq9TFUZHh+kwHnKNvWpLDRHUeA
	C8RFfHONkgvoIVnQtt6FFeBHsmjpgrtgjzCkyv9g=
X-Received: by 2002:a05:600c:3f0d:b0:46e:2cfe:971c with SMTP id 5b1f17b1804b1-4771e283ed6mr2495485e9.0.1761673793414;
        Tue, 28 Oct 2025 10:49:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcx7klDKQsDly0rERnv58qXRJAfJupSMrXo3pXhmlMb1uRNgLUDuTQsDYYW7kLhyUZ6FSXvA==
X-Received: by 2002:a05:600c:3f0d:b0:46e:2cfe:971c with SMTP id 5b1f17b1804b1-4771e283ed6mr2494955e9.0.1761673792961;
        Tue, 28 Oct 2025 10:49:52 -0700 (PDT)
Received: from [192.168.200.155] (host-80-81-2-50.customer.m-online.net. [80.81.2.50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4771e387baesm2888955e9.2.2025.10.28.10.49.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 10:49:51 -0700 (PDT)
Message-ID: <f36ba14b-f2e7-4efb-92c0-a4d4f58b1bfd@redhat.com>
Date: Tue, 28 Oct 2025 18:49:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
 <2983c165-8c13-4bb9-b2f8-bfe8508cce43@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <2983c165-8c13-4bb9-b2f8-bfe8508cce43@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: H8gKJXEkz2vMPSwvbNmg8djRR7F7hCvJo-OohXZ5W_o_1761673793
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D341A40011
X-Stat-Signature: qudshbppiqi3m5nhx9xz81s53r1uy67k
X-HE-Tag: 1761673796-199055
X-HE-Meta: U2FsdGVkX18J88fZF1C4NVCFo9RZUJxx0k/EWrQisjggzzd0S4BddQrutvAS4OQEMB15EXLrLFd3+aW4qUdpdntWAtAvphLujILDIju2vSZHJqTHJxntL0fQYHQBSzovU8Z5Un0ck0lMWIeSQ60oc9iygwcR2SU7e5ZkBeJIb+IlTL0fjNO06tGqMTzHmtgUNLw2cfBlZdD0IwtKX45PHG5GgHQBo739gznM6lNqLH2dsmtJN7lFOwlznQKqeP24jSEJRFDB+9F3+B/iaajIb+C0VBvSRJJ8vC9zaZSCtMs767X3Z5WxpJQv2XoHTRioeNnxtAroP0K+/FfuZZ9O2I6vJhg42Yl0xT5By+BSMi5tosGGzcKo/3eBHdXKDuiJ3SHuH70xXgiaHoju6L4b/4UAhdS1zFaXxgbF+cuxWvtcunYoGVapTLChSeVtGKAxCstH/7B6tFx4DCmNpnIA9LUNFJXvJGRjyTou0Qsc7L4WENF+1UIwDuhYTUL5oBTuWQ7M59xFkbrIWjaoZkc6Hc5ONpZw1bg5eP/oFN9BVe9evXwCd9sYOu9bs+3SBp8LGSNzprWx/FccCSLpQG8iC18ksrNoO4Vyv/0m5mrdjPdcJJZEs8rcfOXnqMZohRwFZxXA4/4FmjGZxwWBOtBYzDglIvIB1Wx5ZIgrteTY9qC9Jm+nZ3a1bNiYIprqI7W360YfU/SHOmNCe81+Ct5DpCbjw7TyhVEJIC3fWHrfdmbo3EkB+XYs2XCZgymcCnZPVApoZlWCdZpD/j4JHTwhjstKrYHvCxwblyqPhmM3BKBQKISjeIcpr1bn0gsufj5MMN/Bep9ZtBw7JbdBWNJxiI7yb6jHRXqEtFhIJ2kkgIUwHQCbDfTIF9OyADlshEmgLOFLPHq2pBA35mIlJeKVL2nzkFdRqRECpMPFY6Xf2M7/EuWKJEk2w7J+Uv+Ze97g/xyNZzoTkIorEIjagT/
 ukwNvUn8
 thmg2Jci1/SFFLxbXN9A47oB9R4GPV4bqZ1cP6CiMiZDYxEj5wyDdMm+b3HT8a6D0dtUl7aP1T4SBKBiHE+dJZh1D23Y40GME5mnd2k+v/sBIptDT9p1FCZRHMFci94BVWOYvto86jh2AF82rTdKc2tTkwzGblGS2ajGsCmFCFXiRo8btISwTzS4DU/kVLbt7JRiBNiL+CNr9paJQ5IrAFhtRQjh5+8dsfRTLspX719fZG2sXInb7f8bNWLh9g0+27IoacgmT2BdNSlb61Skts3KqpgIsfLk9UwohJjUAurcjQJ/JgygdtoqLu3Loszaljv+wFo6Eh+xIczDJr/i5W8o5+FL72EaprDKLx++6lrY1IWwOXyU3kgmb3SHbdJfpUrKy79woZdwIAs+NvW1QX1GiBiNPfkCsD57ipoFHWFJEkaNwaXxyTvYhr0Uh5vXffOE9vOOmJpeXiQ4KOLGleQeBMIRk6tKYhddglmGSTFOAq15BDXAZneAXJ3y+J3ZZwAIB4DImhI26MBk22y4yHxR6qZpyj8Eli0EamektVLFptG5Dkr1/qsRfqxRilbxpN6WFw5NYTo0I/qmzeIMxJE5xaz7BIwd9a3aq+MZuuKW1OVX2f71blEKLJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Hey Lorenzo,
>>
>>> I mean not to beat a dead horse re: v11 commentary, but I thought we were going
>>> to implement David's idea re: the new 'eagerness' tunable, and again we're now just
>>> implementing the capping at HPAGE_PMD_NR/2 - 1 thing again?
>>
>> I spoke to David and he said to continue forward with this series; the
>> "eagerness" tunable will take some time, and may require further
>> considerations/discussion.
> 
> It would be good to communicate this in the patch, I wasn't aware he had said go
> ahead with it. Maybe I missed the mail.

Just to clarify: yes, I think we should find a way to move forward with 
this series without an eagerness toggle.

That doesn't imply that we'll be using the capping as proposed here (I 
hate it, it's just tricky to work around it for now).

And ideally, we can do that without any temporary tunables, because I'm 
sure it is a problem we can solve internally long-term.

-- 
Cheers

David / dhildenb


