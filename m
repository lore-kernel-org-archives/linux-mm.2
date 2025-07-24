Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 768A7C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 22:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1760D6B0354; Thu, 24 Jul 2025 18:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14DBB6B0355; Thu, 24 Jul 2025 18:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0640A6B0356; Thu, 24 Jul 2025 18:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA3216B0354
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:48:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 910A5133A9B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:48:05 +0000 (UTC)
X-FDA: 83700647730.09.E2B57EC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 38856180010
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:48:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MuiT14RW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753397283; a=rsa-sha256;
	cv=none;
	b=yvzddoTtiszmfJW4ybq3L0zEixZ7sre9jkBcJDR3G+8c42cVHSpSuaeie7mZjkVQppiFX9
	9ipFgQ09gtbiJyJZFoDm8eUdfcYjtxUtDZ/tqYYgrcdrD+wuiblXm+w7g3F5eNUFePJXL9
	G3oaXg1QD8q1nxJ8Y4uxD5YJSJxksUw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MuiT14RW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753397283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmr4Kzq+/XTnys2IA+krHPH44Ad/z5rXdCAAEVWap8U=;
	b=XLQRQyrL3ocT+7D3cxJfLK6Of/wy2l0kX9uEr2X5Acn86Ys/VTKaXyqJUtPzVr5lrBs4vJ
	Zd00tDVt0ncIBac/WSZ95lWhtcI2ZtuNE/yRBEYD0GQFf4hrEVE+U3yXj5dxRF/hcDpY6Y
	PoWsvEdSQ3DnhAS4ObgzpbVDYT4HM0g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753397282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jmr4Kzq+/XTnys2IA+krHPH44Ad/z5rXdCAAEVWap8U=;
	b=MuiT14RW3lyR+zzjqoli+ZHCwemaDAUMUG3zz/ZtAyxCpsSKiY3s7qq4BxV8CeS8dksUsD
	pC/ifZ2aVuo/IAKTNFq+P9ccme95rzW1aCwscwwMAIdwwLjQNs4e+h0V7Vom1+QH9Ui5NR
	EfXf6ZLGkz40CttbDly55gN+pjEWi8o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-S4PG__tRM62gazkorYVPhg-1; Thu, 24 Jul 2025 18:47:51 -0400
X-MC-Unique: S4PG__tRM62gazkorYVPhg-1
X-Mimecast-MFC-AGG-ID: S4PG__tRM62gazkorYVPhg_1753397270
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-455e9e09afeso5829355e9.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 15:47:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753397270; x=1754002070;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jmr4Kzq+/XTnys2IA+krHPH44Ad/z5rXdCAAEVWap8U=;
        b=Y6+yhm0JkNTxFIym22mc1Fbtm4K1mHHkCDc9tr40Z0+1Gao1amv1TukRlC0Oegr/h3
         p+66nsFOnOlFuJNiyuKu3mZQO0tT7B7y+Iog7tedyhW/7gj3sqXey1tpaKCpXB1+mmE8
         nPO/Hhy1S42tUA/prxF9Me6QYONfkaELDqk5arrB+pKhvihc1vc5HewXjRusU3Y+VJCR
         B677FXCSIPu2lTf6/QrEEjCKq5NquAw7rY9hU24O7TrRCvgdHUBuZ0u3UFq+lu+WuFx5
         86K0ISs3CkvrLscw4aa/nM8Wp6TMiz2Ucofc1NtEVvXtrteY8Fws55SKDM4dieB6yIPu
         h1HQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwj2g7d74uHyBkBjKTb0oCS1uBeEopEfY92qG3GocKO29VbDVPepEWDgkS7PJQzqp+mnbefeKG4w==@kvack.org
X-Gm-Message-State: AOJu0YyPaXs3HSkRSh9oUqRiQ2DanhRXo39ldgTBd3xSa0Nj8etSYPzM
	/vfONieKGJjNv3ehJeaBQdZw5jRD3xN/TJhjj5OEoEY3miHo5SusccmNbn/GgQxptgC2jHMucEb
	dNS3ANfKVaIOXSaa7QZjgdh15p5MyMzNNGoek23Q/QtARlx9QRzQt
X-Gm-Gg: ASbGnctX690sd0h8F0zGeS80FngZHvjjyejL6oATckhBZbxWS9WH6fIxPP5w188HNod
	SDegMsEmdeGKuFdrkF6UzyDmaimesMRCYpwrAA7yZNN/vIA77S6qnpG08BPetleIxgPfhhybJRK
	yWodhQlHt6VOyiAty0qqsNB2FSwe7f1ZWt00HzE1vzzt1HMnSVEEp9WnDa30rLJeSvyhUycq+7h
	Kn2BhzJVGCFG6XbyfIb8batkjd9uCj2ePbyEzzRZ+ofFRJmkm6nVFB6YXkpjjK4hPtbiEpG7NkX
	KSGKSo3ufmv8T1rjjx5saFD0CHSe4BcjfvD+qHEnTE5GglrWaYVDLSEe2OVvzMQK7+c6bYs=
X-Received: by 2002:a05:600c:1d1f:b0:43c:f629:66f4 with SMTP id 5b1f17b1804b1-45868b33a97mr83521985e9.0.1753397269745;
        Thu, 24 Jul 2025 15:47:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWL7IGjqrlox7wHaHE7riRq39AcTrIZ/Xgb8bCcHSYeD3u5LC8WQCJ8+W8XUy/PQJ5HU+/9Q==
X-Received: by 2002:a05:600c:1d1f:b0:43c:f629:66f4 with SMTP id 5b1f17b1804b1-45868b33a97mr83521815e9.0.1753397269239;
        Thu, 24 Jul 2025 15:47:49 -0700 (PDT)
Received: from [192.168.3.141] (p57a1acc3.dip0.t-ipconnect.de. [87.161.172.195])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fcad291sm3266302f8f.50.2025.07.24.15.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 15:47:48 -0700 (PDT)
Message-ID: <28bf0b31-8b51-4acd-ae09-890a952501f4@redhat.com>
Date: Fri, 25 Jul 2025 00:47:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
To: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jeff Xu <jeffxu@chromium.org>
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
 <202507241352.22634450C9@keescook>
 <e0a22433-541c-40b0-92bb-34b0596db642@redhat.com>
 <ef111032-e108-4771-9202-b8cdab278422@redhat.com>
 <202507241528.A73E1178@keescook>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <202507241528.A73E1178@keescook>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EDASf1IOCqFQ1iusPRz4973UsraccI0gW71NscB-lPI_1753397270
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 38856180010
X-Stat-Signature: 5a3mszj7435a857yhw1oqidmdftmqefz
X-HE-Tag: 1753397283-240283
X-HE-Meta: U2FsdGVkX18T7U6zI1GUyyBUKvCI9zXwMFhrakNgIje56iWraSbTNaXMO1RHYEsG2YbcXrQPDdMlaKOr5SAV+iKBVqjiM2PbKi6ZRhFWHyye1XJUoFhU3M6gzpQR2Sn/Q9hVq1rObVNKZLqFZHqtTdqP3QxCSWUFnSMRcadzMTGLRXQ96eqyxncSQoaWODI4n9/0nHnsSJOWqcfmQZP1kE5ZbnzmeJmclLbexwXAaBYwoFZ0RJ7s23ysc3SSdY8XOm9fXD72hFAl7kFcUdBpBC1B4maIx8DLztWef9qFZ4aIS7kyNnMo1u+LsEHZbzRDj5PIfJnK3FWwswMaLuNGwWCz0nH+O3L9UNVYOeMO/jz0d2iHsf5roIBCoaZSDrl8pvo+O65/vMtX6RlUxksIweJbY9htpXQD7TubT8paNdh4ZdDfkrysD5cHGTuzjMcBPuc1KyloA0DoZcPor1z6vcW42B/hBLU5r5Js8WcNS2oWsAf87xhCeS4bGfo4X6ZR8Xd7Z/LKWttccfPGtHfydebs/a8OYp1VmYrA1PHypRaenm7B7ZkcWWFnygVLJAzLrw+5wiNWKtScVjvXMDUGcZuHVHV4/ZfC+m9j6ZSBxHD5uqj6PxrrlTQyaifWrgfocld02fyg/kiO13irLl82G8wkBXK7E7evM9beCDap5UHUtTdJu0B4oF5yFfOCopPPdQRvOyy3mj537N7xdcAQLZ5meU65wmwFVPUPFdbc2hwTg2UF/WCn5hcqrXkn5RR0Z/ZaJi7f6FnZ+P72BfrbBgkRnusK2pOmEv3W2NKkZdbSS/EvOAcmHbsQa8wnhvsZIbofEqqmTsJnHLiXumvuGBTtCDD8CSq9xLNEADZPdrBwLFh/3OATgflkZpIsWPDfEJ0A30gISF5dgFZPsEpaav2qWosoQbKTXiJgYf8CtwPqw+zvZ3iRA1+yRwQ4zlcVUyBSLwjdVbqxZ8eWBGs
 fzecALGf
 aTpSTWMOWfP1gEFaR44T/njXdqaPlt7/3rEt5M2YrEbAsIT2bwgNl6eT8A1nSxhZ4iP8A2Xuir9dJkxmExmB1RW/R5+hf4KY8YFgTyuwlshPMt9ebHsg5bUE2UN+NGqsNeCXpBAJyjcsgdW/NNAWxLva096ZgnwRsRRNCKqJtwdW9oB2UgoXSv0C/ICJKlzAbq9k90FkyUu0qiDo2kV9KqodRSJNnlTkL0DvpflNUqbq3xOMuD7fbB6/YlPWLDGtoMeQZSbydjeAJyTxAaMUAvNc1yo+aNIpCS1FiQYDgN/xQaK9tVooYbhFwHLWiOnAjRtPJueYer+6IL5aR+LEyDO7Whe+yrU3xsTepHio5smPfmDRWnBXFJMwmSL7tS+Y4AAOM0RizdVzxIf5vG8LBtVBKq/sltHUkP8ap+7SxjddI3ZI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.07.25 00:29, Kees Cook wrote:
> On Thu, Jul 24, 2025 at 11:41:04PM +0200, David Hildenbrand wrote:
>> On 24.07.25 23:32, David Hildenbrand wrote:
>>>> As an aside, why should discard work in this case even without step 4?
>>>> Wouldn't setting "read-only" imply you don't want the memory to change
>>>> out from under you? I guess I'm not clear on the semantics: how do memory
>>>> protection bits map to madvise actions like this?
>>>
>>> They generally don't affect MADV_DONTNEED behavior. The only documented
>>> (man page) reason for EPERM in the man page is related to MADV_HWPOISON.
>>>
>>
>> (Exception: MADV_POPULATE_READ/MADV_POPULATE_WRITE requires corresponding
>> permissions)
> 
> Shouldn't an MADV action that changes memory contents require the W bit
> though?

In a MAP_RPIVATE file mapping, to know whether you are actually 
modifying memory ("discarding pages" ...) would require checking the 
actually mapped pages (mixture of anon and !anon folios). Only zapping 
anon folios is the problematic bit, really.

It could be implemented (e.g., fail halfway through while actually 
walking the page tables and zap).

But, yeah ...

> I mean, I assume the ship may have sailed on this, but it feels
> mismatched to me.

... I think that is that case, unfortunately.

I remember that userfaultfd can do some really nasty stuff with 
UFFDIO_COPY and MADV_DONTNEED on memory areas that don't have write 
permissions ... or even read permissions. Not sure if CRIU or other use 
cases depend on that in some weird way.

-- 
Cheers,

David / dhildenb


