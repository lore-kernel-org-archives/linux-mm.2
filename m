Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEC6FCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD731801A1; Tue, 28 Oct 2025 13:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE9980199; Tue, 28 Oct 2025 13:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC548801A1; Tue, 28 Oct 2025 13:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACDEC80199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:56:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4055A88AF8
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:56:20 +0000 (UTC)
X-FDA: 84048277320.25.5B6E5BE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id AB6E720010
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:56:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eHx5i/SY";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761674177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g6eToIGweByE2pHgRfb2gPb2S77u3+GTDDQYyAyPH+k=;
	b=RDbBtzROkJ9KZMNxQA7dFmuXbW0L1JhZJRnZvmn7AOudx76SlOnKb72nZkveDwtpq+LuWU
	blFc29npW1vsms97y++Rh/IjCkSFyuJtrju54OpfQxnhd6+0oWz5kE295daIyEk+EoMs7W
	GUJY/gI3HlJ75eRS0fJEFuxuDSX/4nk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761674177; a=rsa-sha256;
	cv=none;
	b=vNgvcUnQ+RznjkM0h6zL7UaedPbuz0K1YGWf0AapQaon5rrOENEBCNVVML5lxix8MEem35
	5J5YwuPFWXsA38RXM9drnqsiNmqVd/k/OHyBXopsPLpiGOIHm3bYvwO6KC0Doge1tgCGIY
	WrhS0IySQaBNCADN0TEaH4KJ1UGs79Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eHx5i/SY";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761674177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=g6eToIGweByE2pHgRfb2gPb2S77u3+GTDDQYyAyPH+k=;
	b=eHx5i/SYMOBOsGES7TldI6jgNaJkmrY+mNjvjUP3f7HV55MTId6U7KIfxwgNCbtUhDAGDb
	xLPTkw3XK4JnK3I5XbfPU5iUmVDgjVeQqa7s30qlb4fZQrt0Ssbpgo/4g/UO8hOaHUMCf7
	hku9QQx+9CnrVb6UOkDqFzNHsCNfFGo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-nXfc1RuBM4i9Ii0raY_kmg-1; Tue, 28 Oct 2025 13:56:15 -0400
X-MC-Unique: nXfc1RuBM4i9Ii0raY_kmg-1
X-Mimecast-MFC-AGG-ID: nXfc1RuBM4i9Ii0raY_kmg_1761674174
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42855d6875fso5188830f8f.3
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:56:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761674174; x=1762278974;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g6eToIGweByE2pHgRfb2gPb2S77u3+GTDDQYyAyPH+k=;
        b=tySOYc+kemQ7OomIVZup+p1XIzgIDKPWlWrPcoT1Au/U6SrWlbxqqilid7Wv/Iz5oB
         1LmCcOsOFVTZzjro7VKb0BRL4hXZpcgcuRJBW6+VTWagOt2CPh+yvoc1OYpl6zUAphbC
         1lE7qjkaDRlft9tChoUxT0GLmqt3MfuUDVIqTzne2DoalCepoRQjkhWxpewuRu35u1mC
         fbSn+Fg9rG1wFm3g0ken5sgi/OCf3XpK1SS9DS1rSJQKtFe3P7JdqI/Fme2lsDopHohm
         63bjyFu3dOxYqXSUI+lPkfYgBRWQBraLTWofxl7VpsWQoaAEXLuT/sZGBuXdU8wq1MTx
         qLtA==
X-Forwarded-Encrypted: i=1; AJvYcCWJ5501dlgQkcN+iOTOqNzFuIkkXuhuWx/difmKuPMI14+QQ9+jKPj/G8X17/5+1SEc04SdUratxg==@kvack.org
X-Gm-Message-State: AOJu0YyBCqL1LYWPyYkRWt1heUjPBOcvIC+sarwgG1HUJ96zyM5fnSSc
	/0BNoOKI5dVA3UR6FP6nFLMnTnUXrVTCzKrg9UK44gGR8OEw7hh5gIOL4Ggmf4a7NeZ4a0FIUs/
	1DGvCfIl6rWN+Xu3F9IhD0U7PzTD8eO6w9QArCz/igixgIb68Wsx2
X-Gm-Gg: ASbGncvbRWrFO0n+VTEPtChc+IqrSrQQG30H650mHRSlH/JSHLYwBRpcKkHofKwML8I
	IKKh7BpzVb+x741HC3rZ7/dmQsBWDk4sC2g91zkwSgqucV1LiL5xVUYYRJ+/lF7jzhFOECH0R/i
	MFf3YHexiOW1puoUeoz/7JoedSWp1PNT7D84Jkg5d/L3mMANKwUI5dKB8ZN0gQNc2b7WLz582t4
	+kDJChbEjGdETimKHVYHLLB2qOQy5FWpPxBZqYa+qFpI/MADO4D0IzdFidSZJ1o2xBhkYUcvr1e
	sr7y9oltr10Qygg8WJDdi2ksnc7iwf8zfYQTkOo/hICnV8/zD2KU73JCUC8IDiTRcAyw8bpjnTh
	8+/aTJPrwMwbW32iQHoIBd0atXNeLDrHUtye3Ea4=
X-Received: by 2002:a05:600c:4e56:b0:471:989:9d7b with SMTP id 5b1f17b1804b1-4771e1de250mr3042335e9.21.1761674174492;
        Tue, 28 Oct 2025 10:56:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEY4oqI01ymhTqStAjkQ0EYI9rwIiErh5/4NzRqUPCO8tW2HD5t4ifGkOgJh9RHOuRsKfElhQ==
X-Received: by 2002:a05:600c:4e56:b0:471:989:9d7b with SMTP id 5b1f17b1804b1-4771e1de250mr3042165e9.21.1761674174052;
        Tue, 28 Oct 2025 10:56:14 -0700 (PDT)
Received: from [192.168.200.155] (host-80-81-2-50.customer.m-online.net. [80.81.2.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952de4a1sm21724189f8f.37.2025.10.28.10.56.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 10:56:13 -0700 (PDT)
Message-ID: <e2a89e74-1533-4a83-8d0f-3f4821750e25@redhat.com>
Date: Tue, 28 Oct 2025 18:56:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, ziy@nvidia.com, Liam.Howlett@oracle.com,
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
 <063f8369-96c7-4345-ab28-7265ed7214cb@linux.alibaba.com>
 <9a3f2d8d-abd1-488c-8550-21cd12efff3e@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <9a3f2d8d-abd1-488c-8550-21cd12efff3e@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: m90V42amItoGlVAtPYJ0MulLhDqzmRnAl9f56pgxRm4_1761674174
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 7qxukbfcruawkpfwez8nf186omjb4az4
X-Rspam-User: 
X-Rspamd-Queue-Id: AB6E720010
X-HE-Tag: 1761674177-453784
X-HE-Meta: U2FsdGVkX1+Sljd3ZijIM2h88HU5KERW46UBBynu41EeUqEslHI7oeY2kFr6+T2FFUgKsa9xLxPyNZu0VgunpBTbPLWau6q+NNcCequHrV6fWzESQ144kg96EHZCX0i6oCgbKiyv2yO0wcfXuLGsXm8RfB+CxNHbt8Djsh7rYd/5DmdZMxfaRYuyinPktiAKONETme7v8ykrGAM1dWQQabSNlsIP2Yafd9CbLNnEpVFMguhhXMe68H+mqF6joUycpVJMzZLEReaJIHJcjoYM6Ke16C1AppW0HrN7HnS76O8M4YrWepgWYp1Pf/dd4JRViflgcMWJawEwKQHdH6sXx3V2m9DGC5Wnyg2RPzFdeiML4pdNDqQWFysCmOMn4mS03SZxEJ039aMDmYyhdzjnBdaEp0bKBgddayEzBt4oxOq2D5s3gaKz1h48VjS4oJr17CHS6Sju4RgI1MkcJ04mUJBznS7nrhR7W3jzT0hGBH/ADeOGDraMMIwwJdxiU7uRBc/lPz7zRfMhCMZKuerVSoA6pea246+CifTQx4BAXkDpGsg/vHmdvbf0fkpSTSzD+a8XlODINvBLJwwOo52q4bRiuZrT74esYNxJG0S+esQjNPmVl7m8r6CaiISZRNy29wiydGlA170RxjvjZdOV5ZVxHVw2IFIZoSCmb2jQtHq0YOueN0Vu4ftdOsge/feSu1KMw7wuhPZUiU+6CSsZxNzzND4YBpAJsG7j7AvDQ8A4+SIJl8LiWo9Bcxibcpd1669dj0lrv0/KkAY+uZxBkxKZT7dWIp0HFL4cFrMclAdBGnk3W07k6lLDI9FchlyoxIg5hkyKsXmY5xBr15gUKYyN6UjpeJbbQkIxvHAoInoMBuqMBN832JtXAyNGlZiabPXUscR4OrkM29CuvQsdgVU3FmXbe88DO4Brd2Oc9qXy5575A+ePX9IwEuiugO/IAs7pT4wz8Z+Lzjao0YR
 12TpJMdy
 ivRx/WO00Kvvc6WuDts4m2xiV9Zt4lZfG2P+xACrKP0HlUuboBu4/c79osz21qYWUZ8b0qVR5qOcTGYaf0sSFd3R/zlhHFfdhhP9S/6mw+i+sRuSOjLa4KpASuWrGoj3uS1oWwsT9q47jMwXtGXYchQo7QLp56KDwbLyNAQnoyIXg8J86ao8qJBLbuzr6ZfR2NQ5ObEYUhi2EvL7wwB03p3Lugl+o6f8LD1ewg+Jrq3AwxUxKx2zJNn9Eo4UX4Cq3Z1yKDAQi9lmV3CwyoZuKNKjlPTvdQZEdKQuPhiUF3magCtY4hlkZJ8jzn1v92jdD38llw2K5eFZhiXwflFA3XWu4iChW1SezmStyZgWHdWd5Be88NOYW67wdCdaN+WyhLKKbSAwAtW2AXga8ujerbcB5ZyDsYumvGmcLjlO3YDAFVlHirKXwtb2U9BEPyMI9HIHX7h9eP+Fb/X9eXPelI5ZeP572fUK4E3Ov9MdSnRqHLsdIw4Z0TISojqHOJZvAc12wM4x/4zL/q0l/XNfQDto63k9rMRRC0rKLoflkaUppDn6lrBQ1OJAscKx8NB1oMA0i1p/WNvlOyMUhX90o2ajs5coX0nDJgbO8B0jEqjH8D6hIcIyIBpkP2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]

> 
>> towards David's earlier simplified approach:
>> 	max_ptes_none == 511 -> collapse mTHP always
>> 	max_ptes_none != 511 -> collapse mTHP only if all PTEs are non-none/zero
> 
> Pretty sure David's suggestion was that max_ptes_none would literally get set to
> 511 if you specified 511, or 0 if you specified anything else.

We had multiple incarnations of this approach, but the first one really was:

max_ptes_none == 511 -> collapse mTHP always
max_ptes_none == 0 -> collapse mTHP only if all non-none/zero

And for the intermediate values

(1) pr_warn() when mTHPs are enabled, stating that mTHP collapse is not 
supported yet with other values
(2) treat it like max_ptes_none == 0 or (maybe better?) just disable 
mTHP collapse


I still like that approach because it let's us defer solving the creep 
problem later and doesn't add a silent capping.

Using intermediate max_ptes_none values are really only reasonable with 
the deferred shrinker today. And that one does not support mTHP even 
with this series, so it's future work either way.

-- 
Cheers

David / dhildenb


