Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61710CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 12:07:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EC4C8E00FE; Thu, 18 Sep 2025 08:07:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C4278E0093; Thu, 18 Sep 2025 08:07:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B2798E00FE; Thu, 18 Sep 2025 08:07:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 796248E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:07:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 35ABD140121
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:07:19 +0000 (UTC)
X-FDA: 83902245798.07.741FFD0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id EB2D91C0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:07:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FBHcFR0s;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758197237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DOPYjdyI/uAYvwMzh9uSYuRR4ZAJRzMcD+yFLiyXXI=;
	b=ZdtuwlVczpL+Syxq6p7S/Y8RA7P2E5y6U4Os3/UaF8bEmyrjrKyWHQ/cL2XQ5s0TeOiTII
	+WURhMFUY5uu7ynDgHbGbudMrz6jlxSUmWkvU2a+dvtk37Tdm8oSMa94Amd6I6ziM7gDqu
	2B0obSv/7bvUwRSLek09mjq6C+9m99A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758197237; a=rsa-sha256;
	cv=none;
	b=YK1MlRElOKt8V3tulUhLyO/JtoTZXPgoBcbqSjNFoD3zpd7fCPmgFQkEJid/1J7Fp9WCk9
	zuPB7fZp4uWKHwL1/oMtca1HfmpRkojNO8f+nLV1TQRqYK7GEjj2k5F0mwJG3Bl3N/zOUH
	/PLbMkPjDfPFLayu7OSCio2fgGn2O/o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FBHcFR0s;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758197236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2DOPYjdyI/uAYvwMzh9uSYuRR4ZAJRzMcD+yFLiyXXI=;
	b=FBHcFR0sHYPDRTLkK29Xp55L4rA28SIS2Z0cR+ew6bY78KrGK8AjSU2RKG0rxo7Kwlnfyi
	zap5wMxdJUxLdcgPTidddDVo/k8vYvazZgX7w2SA4cO4bRxKAw47EaLDSVsnqq7o95s0WV
	oIeNfhfN7FXkOa03ABJSw/gjtnDXrJk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-Je4CleABPLmrPFRmiPC-5A-1; Thu, 18 Sep 2025 08:07:13 -0400
X-MC-Unique: Je4CleABPLmrPFRmiPC-5A-1
X-Mimecast-MFC-AGG-ID: Je4CleABPLmrPFRmiPC-5A_1758197233
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ee13e43dd9so234537f8f.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:07:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758197232; x=1758802032;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2DOPYjdyI/uAYvwMzh9uSYuRR4ZAJRzMcD+yFLiyXXI=;
        b=rRM10S4hyL3uoXRzH9fLxBBl/lflOuKhJK1XDCOG7TLNQJLtI0Nawj4LrICOEcLyqa
         ymNEjn2UcYN8xBdLeesnA1YTfeevBJooQO3H/dfCqu0veFvyJb903c1v8N5NoLLib6aL
         bTKzROEwvv6TM4hpIe8Ul9LmKFPJIrJwdg4+pgEV/sT8hDeEWYm+FtA2+f/OYcwwsWQM
         5bNWt7eK5CKmg01cUb+Atsw2ttxRLPoqOrtw787cFDhVAz+6rgnHukZ97Bbgg2ymBMVp
         roU7BN28pVOmzG86q4jL0BZgh7pDMlOiq7rwJrlFS2U//Jl33dIIODFYG7WNgZFVSrS1
         TMMw==
X-Forwarded-Encrypted: i=1; AJvYcCU+vJCzUFmyjDaqy2SbgZxKLsM8E+JetcOLxCGoT8lFtgNsmhvZ9myTjfYlGssB8GrbY2vBS9oLiQ==@kvack.org
X-Gm-Message-State: AOJu0YyG6uWAcUeZqSC/ch6aQzivY2L/8YH5cvVMNuuj4G6y8wra+yMd
	MnKDQyEpeYHHDZIQsSw+stjDBqSMlPhu4X13Tsc23v0jR5YnoQMFBWKzOLsh2OL0RzXXZi0+skK
	wjdbEssAfvku5++LqL2AHQrfXJlS4ruWrV669y7wvBKkc2+qztlDw
X-Gm-Gg: ASbGnctMCsMUiUvwLoXFhFo7sOdEjKaoFcoNKle/xe45wZLPdwYAophDPk464rexuR7
	mPKx+eBFMveveiQNyaaSFX9sxASrrJ5xHNm3HSM07bmw7Ka/jkKybX66eBtlNibZ/uxfmvy9COv
	DuQ1+OSEwH2BKTRHH/hOS2n3rVXQGILjW6amyEZc6mSJj9WB+4JuH/0CcJd5qfXaDcK7106ZoiA
	av3LrycoF8qERiYgYdsf5t/teXRql03EK2phQkcDvNZPCYq3JP02DKUUgTel+M5e9k1s8DW0cGD
	9hWWNk+c+CCiXWp1wjdZhklEJaBTFSc9oybEfM9Lo09zKe9KinfOMxkqprYKOMMyrYjlJMLqkR7
	UV4kResRkxMTinIxrs28vIRZsM+hCi8EolpYeV6+Bt76bSEhVdStiU1t+MBzjdhjLvtrZ
X-Received: by 2002:a5d:5d10:0:b0:3da:e7d7:f1e0 with SMTP id ffacd0b85a97d-3ecdf9e6289mr5689998f8f.27.1758197232580;
        Thu, 18 Sep 2025 05:07:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIyAUyV0RX8DkIW+uDkvTX0Rh9rKHG8DzLg3Q/ZTX8yNIVuNU0lPJSNOJoMqZHCKyGphxyiQ==
X-Received: by 2002:a5d:5d10:0:b0:3da:e7d7:f1e0 with SMTP id ffacd0b85a97d-3ecdf9e6289mr5689931f8f.27.1758197231973;
        Thu, 18 Sep 2025 05:07:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:dd00:ca9c:199e:d2b6:9099? (p200300d82f07dd00ca9c199ed2b69099.dip0.t-ipconnect.de. [2003:d8:2f07:dd00:ca9c:199e:d2b6:9099])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-464f64ad359sm45788935e9.22.2025.09.18.05.07.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 05:07:11 -0700 (PDT)
Message-ID: <0c068e35-0954-43fd-b3b3-20786a6a12fe@redhat.com>
Date: Thu, 18 Sep 2025 14:07:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] vma count: fixes, test and improvements
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Kalesh Singh <kaleshsingh@google.com>, minchan@kernel.org,
 Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de,
 kernel-team@android.com, android-mm@google.com,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>,
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915153401.61cbd5120871ee7a4e5b9cae@linux-foundation.org>
 <aa95777a-8012-4d08-abcf-7175f9e2691c@lucifer.local>
 <20250916191645.15aae276992acafe7f7e723e@linux-foundation.org>
 <e85d0b14-28dd-418f-872e-57c0127ad572@lucifer.local>
 <20250917163231.b5f7b8012367f033a91e6f9b@linux-foundation.org>
 <cfabded7-442e-40d9-963a-597a42da581e@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <cfabded7-442e-40d9-963a-597a42da581e@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: C3eA0UzEeh7r91nSKWqV6nv21oRD4FNd0JbhBCs73NI_1758197233
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EB2D91C0008
X-Stat-Signature: zyx5w5a1ey961pdedygsw7sb4tduczja
X-Rspam-User: 
X-HE-Tag: 1758197236-651516
X-HE-Meta: U2FsdGVkX1/X+VdMnWhAiX7JtD0RCkMFi2N/jGRM0L/kqZ9uVQJamX+3JZZJDlZd3CrwV8o2xfTa9A84kgvHNEtakHbLISzlP4d83GzP00X96J/jzYuBE/GKREHrDypIMJe6DFjdU+bOg5K/hum8iu6nQoJV6gA+rG8CTv1W/MpV8URxl6xCseB/jkp9rCJ5i+ybAZmr997pbOxAIGFsWq2ICfJRyxhq4Vk/79hwJDgOrvBvmtjai5Cy96AXEimYTEmqOteiTgWONX0zBBJavUUakAaolySKT3FZmYxKk74/GFOjTSaNPnzXG8O9AbAssUEMJoL+UkXX1VNfC5ra8JPus7iSKIpwLj3SDFL7/OCcJuZVfG/Jjic8ZgHl4xZBOz4vbb2DotEGkjslqK1jVJ20LPYviX0b+LvVLrD5Y7dXPbzIhcH62Sar04GxGb+MYAibKbfbe88vTLA6TUY+7u95wFxOu/EU2HYj56pxb9UMuTvCuzkIAXY9+HyUCa8TPp/ZahHTFJ/2TWCU+dyENPTl1oc2OT9K/EM0c14KDUkooQuNhqVtCHRXHwr0fehBGxs+5zznOEqpu1k3PC1cBZSSG/G8xZut4jGYl4am9dnzc0Kbx19nfxD0Bz5FtDc2NoUuh6WBnekeJl0k/gP4ieVzIgn9JFLZJr0pSB3cH3m7eHfcoimewy+1PCEYEd6QD8UyZn3g+GMFf8xca9Qnb67WVGCA8ALjjAoqtq4W4Ed9YSgtxbRz4Id9vwJasP0FIh4axF2dyUoZSqAssHRc8ZF4Q/dJqpMPXoUF7LXE8WUEbVQ5FlbiMxrBPqCLmg1lq2LCH6CuLCbxP3G0lL72uo05DO+97FieqyhanrOv5K50yi+fUoRLBdXRJjbB0VpwOJEs5E7SGnXWwGaudAf7p86gi0X9wBMJB4T/NAsgtDaY7Ip/TW519DazKv8yrWLtbDNzo+04XxEG1cD9Kyl
 Am5t3GDd
 tuNbi5Uv/QJ7qWl2oMuec0XrlvuTuUNXSp8cCG/kwmmL5CA0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 12:29, Lorenzo Stoakes wrote:
> On Wed, Sep 17, 2025 at 04:32:31PM -0700, Andrew Morton wrote:
>> On Wed, 17 Sep 2025 06:36:34 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>>
>>>>
>>>>> Perhaps being less accepting of patches during merge window is one aspect,
>>>>> as the merge window leading up to this cycle was almost the same review
>>>>> load as when the cycle started.
>>>>
>>>> I'm having trouble understanding what you said here?
>>>
>>> Sorry, what I mean to say is that in mm we're pretty open to taking stuff in the
>>> merge window, esp. now we have mm-new.
>>>
>>> And last merge window my review load felt similar to during a cycle, which
>>> was kind of crazy.
>>>
>>> So I wonder if we should be less accommodating and simply say 'sorry it's
>>> the merge window, no submissions accepted'?
>>
>> hm, I always have a lot of emails piled up by the time mm-stable gets
>> merged upstream.  That ~1 week between "we merged" and "-rc1" is a nice
>> time to go through that material and add it to mm-new.  I think it
>> smooths things out.  I mean, this is peak time for people to be
>> considering the new material?
> 
> I'm confused, why is the merge window a good time to consider new material?
> 
> People have the entirety of the cycle to submit new material, and they do
> so.

My view is that if you are sending a cleanup/feature during the merge 
window you cannot expect a fast reply, and you should not keep sending 
new versions in that timeframe expecting that all people you CCed that 
should have a look actually did have a look.

-- 
Cheers

David / dhildenb


