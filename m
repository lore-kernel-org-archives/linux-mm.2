Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EAD3C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 12:10:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FB086B0098; Tue,  5 Aug 2025 08:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2B66B0099; Tue,  5 Aug 2025 08:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C1996B009A; Tue,  5 Aug 2025 08:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F0D8E6B0098
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:10:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC3E281018
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:10:47 +0000 (UTC)
X-FDA: 83742587334.13.CDA6F1A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0E5BD2000E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:10:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bP0AIIQV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754395845; a=rsa-sha256;
	cv=none;
	b=GfsuXtSliDldQx5CbV81KVK4vAJp+UD2WG0iWSDadzth28fuLx0gc4QcSLZgvEG6qDtbP1
	rUu6s45zP4W5VdkgsoVDA7cR8DTvpBRojImu1gACagO6pzLmBV8U5Am9c7bbT1HLAeFEYI
	sgFc0B9O5iUDkOAon5LYYzpCLB57V4k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bP0AIIQV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754395845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mxPZ9mV2VGEDs+TcyLyleA5F2IOZRlRZriZVa56GH68=;
	b=6UzHOcdzdW0pvr71/IRSEMph4EybVQ1PZ47eVJpZ/U4ED9PZrUKBr0KQlhn4F94ooyKRw6
	8JyPmp/NqO29TYtzVwKju88RbFJuII30TdBpZJsb9ao+lahMjY71Ev8u/XYd/xJEUc/uyh
	/1lf28DKSh2dG/grS6D1iKjEfM4tKKI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754395844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mxPZ9mV2VGEDs+TcyLyleA5F2IOZRlRZriZVa56GH68=;
	b=bP0AIIQV1Je0WcEnkmGqaJGd0nAyN5xTZwMLhbKrsxlL9kqpVkk8w0zG5ICW/kIBB1EqWu
	C6W9O5LsFnO3pdzgGRvQPG7GhD+eFKC8URRR1qLHdDRSceLhhm4/fVyCtHc6gj3C3i2992
	4T2/LY9iB6dguH/Rb+0/OxdNHksXr/U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-IdkwyQlXPLGkcQkG2pAA6w-1; Tue, 05 Aug 2025 08:10:43 -0400
X-MC-Unique: IdkwyQlXPLGkcQkG2pAA6w-1
X-Mimecast-MFC-AGG-ID: IdkwyQlXPLGkcQkG2pAA6w_1754395842
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4538f375e86so43079415e9.3
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 05:10:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754395842; x=1755000642;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mxPZ9mV2VGEDs+TcyLyleA5F2IOZRlRZriZVa56GH68=;
        b=NRX2YiUgQXx6PHxQVJf4fr6zIx79icin9vwGTog7DoJle7Fk3BrFtRbpIH2kh0GCat
         +LJHvB174Irhs9DXcXcQZLy/DxMtdLCW8EF3KwE1aIgB3R1Juy+25lVLpIRbg4pZV8jJ
         yzo3nCFErIbvMJ+igw2WBAKYjU3saQ5A+GBfc5/chThnQJltGy494jvzXaC//tSO+0Vn
         xAguiHe8zPPCCycyVrTOrtLGJpyugBZX+FrIT8yBLySa1F5YciwnWHy7Oi76PVelCm0l
         +IRqdpDXPJ482H/ahtTtw6DbJsfYECkOrJdPeL3WbZcS7dquVf5h82aqUnARGoiIGiQb
         qkcA==
X-Forwarded-Encrypted: i=1; AJvYcCWc2S+Tq+C4q2axMcG88HhdhLy98KGE7W2CBR42zJQ3R0J8XSlUgZDnz5Y0ldChk9HFLCKs13hJTQ==@kvack.org
X-Gm-Message-State: AOJu0YwOh43k9LjDC6YW8lf/T6deyx5ELa+/5hyUPhfRnj5LCY0a7rny
	y0eU0Hep23u0SkSYtzu1p5RF8W91hjNL3S0CeRRhwRq7NkJankLrNpsh+/cdBzXNt3skbINZ1gN
	1SXKtt+MzsXOkm3CA4BEjfBWcZXwOJztmiNoh42xFwt7bB6IkI0vb
X-Gm-Gg: ASbGncvSYt4V1W9Qu6CWdUTudC0TcfaiiAeqE5YryKDbC7ureq0lYKkLfzE9yWlWMj6
	zM2ao1cHY3uBfHcCUeP2xy1wc5BBWhRrkGIRks7IHoAq84vUFLgEbpk8gsrbEs1w9lFZQn/so3Z
	LhgtmUf1MatxpDaHZKGr2rcNL7c+AU0BpfqhEWCciSBbe73yAbdWZxYB4WV+58c/SJyOiOWcZcQ
	CKqwbvi+sovwLmE1N0hg06vG5HtcQTIemiXU+ivwulnaPiPNr/hVZrBxV0LEh8n3efn77u5EBLU
	atWnJuPc/ySwmCcIo2sl0jkh+tMYf4duEvVn6f8ezB9KFIrll5JqFGhUg2pChYmkYIWBFOmk+ne
	1v41vQj8NwmcrFNpBDaRRCyLkN+qiJrQm6lQu6JVNowq/Sp/dhZShwQSMiIc+h1dfMPc=
X-Received: by 2002:a05:600c:1391:b0:43c:fc04:6d35 with SMTP id 5b1f17b1804b1-458b69ca295mr96547345e9.4.1754395841885;
        Tue, 05 Aug 2025 05:10:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRVCbz9qSTE0QSs8VJxnp/4QbJ3PPlhM2p3GCusUFNug/XIQgjZ+Xc7sBO+ds4FESyakyM7A==
X-Received: by 2002:a05:600c:1391:b0:43c:fc04:6d35 with SMTP id 5b1f17b1804b1-458b69ca295mr96546975e9.4.1754395841451;
        Tue, 05 Aug 2025 05:10:41 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459c58ed07fsm98317775e9.22.2025.08.05.05.10.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 05:10:40 -0700 (PDT)
Message-ID: <ca35da97-13d1-49f1-95b0-b8b9c8a7f540@redhat.com>
Date: Tue, 5 Aug 2025 14:10:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: add static huge zero folio
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>,
 Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, willy@infradead.org, x86@kernel.org,
 linux-block@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
 Pankaj Raghav <p.raghav@samsung.com>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
 <20250804121356.572917-4-kernel@pankajraghav.com>
 <4463bc75-486d-4034-a19e-d531bec667e8@lucifer.local>
 <70049abc-bf79-4d04-a0a8-dd3787195986@redhat.com>
 <6ff6fc46-49f1-49b0-b7e4-4cb37ec10a57@lucifer.local>
 <bc6cdb11-41fc-486b-9c39-17254f00d751@redhat.com>
 <dwkcsytrcauf24634bsx6dm2wxofaxxaa4jwsu5xszmtje3gin@7dzzzn6opjor>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <dwkcsytrcauf24634bsx6dm2wxofaxxaa4jwsu5xszmtje3gin@7dzzzn6opjor>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3hyV6F7XUj6wM2Dgu7Ks2F3sMJ6teuVKbW6rUECVBNg_1754395842
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cc918z8in9fyeecqiswm5qwd6ggrnis7
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E5BD2000E
X-Rspamd-Server: rspam02
X-HE-Tag: 1754395844-698596
X-HE-Meta: U2FsdGVkX18cyb1hhn3UjBe/+8jAf1ecu4IyzB+1Na7YBqUx0cqJBJrTLXoPfbcv87GAoJrV75LAymM+EEZAla4G0l098A5r/fVXWJlkEsb7xU14tYwmehSPdCzJag3+P5o0+SPCoy9qlDxP+GvKW+p7WeVMk9prQSiqSDWXsSDpz1Ks+XhEb+PjTreu/CfgDciJKEDkHZLePeyEsslGMS2Dyaw8StPhahrzXr54Pql0KKv2wC0cG2a3P/vY/+WW7eMClYWsvq0VjCkIn5FdZriJHbPI6RyiOWppJwDjRvXNazKkGBWaq53OJ3Mx+ZWBfKjIdiZe+PKSFvflkU1q07IFjSdFWep7WDFbppWvXrO+TdBPSIgW+NbNJrhbPUsHtijae7FFk9xz7C1PWg/9P7W8TOhT0j7ZVyZCFDuLjL+hkMqnXPQfr7ZoOqkjA53p3K3tGm+qCKRjcoq+N9t+NFuGhw0MOoLi60BlmuflrLisqjxeEYX9k4s0iCZ6AqWH6WVZooTwDWUKbJp6563qD1EacQwaZnz9wTW7wS5aL/kXV2M7Z9SMPSqMdbSb2JwyzzZ0p+mD2uBbrrbIxoud7HE8+q2+FY74TuQI0mbnvMQWr4RsnY7YxB2ewUxL8VAWIeFMiT8ZB3snqcVx6fqFqpUc6dSeQxnSUVKW2DgY7Ae2rbI5j4GhsxDqHCmNQxGEi7RCZYfP5wbLXIvo/mnZyWzWoHF520EfvfNGgFXH8EXG1mUdIXk3QfED18JiAYR0Qvc4Yyd71qh8WMfQ52KtNarrEB95mWP6VEsGbwiMGl2sx6GFIEzMUzIqw/AxelGxi0WBBTHFOZqzQi6ewgOgczHWokbW5Sy9zis+0Et0od8+1buiSiKmp1xdLNb+kts9eRtOWuZRiis2GWkns4TyOXYFLV1bakzH5gBM6nLrCeNGOnjSLL8RivOUaJ0RchKRi9/P+hgvOyjsGZxld7w
 HxDRuyya
 pIHq2mHMaTWgYhDggUSYX2ZVZW37rcePN3LNYb0u/Zp2NF6dh2nWhW7D4j+OKcyI4XVKsdwJSBCI0Ye5C7NIdRjDrkeCEvlI0O82OFrO2XUx6ENHWE6rA5QGlpCjyQJQyym0ZdskcE2WUyPKxnnTmNmvVGhiU7LzXD+dQj5YrcFOX2N3XXxUjfOsDvsHDnw7lzG6SgmrDbL4dD1uhrvjCLV/X1sTRdFmA4Iuxjm4RwJkWzBIPCU9CP3JqS5tbl/goxteCYuSdZw3qWt+tuTzfYmr15qeSO7kZhwk+/jlCiTUq1TFvjb6tl48U4tleLoZ1pXxf/1ZzN8/trCs6z/IrSHpa/l4IH5iPUDFdHAmLgDf1auMULFc35TD1iOrUaowWJlZNg/rlW5IdxyGW7ogCboRIRtSiWrn/+jobZxiIYamiOc6X+sTepywopCAz5vcE8dhdO5U4L9AthpaeXB1sk2+0O8n9lHnT2N7pXnjTx+5EI0B1nZRnNGlUuzcGwyjrFZYL3VPJrIYp8I06WR518BhBnd2Ddwj3F9aR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.08.25 13:40, Pankaj Raghav (Samsung) wrote:
> Thanks a lot Lorenzo and David for the feedback and quick iteration on
> the patchset. I really like the number of lines of code has been
> steadily reducing since the first version :)
> 
> I will fold the changes in the next series.
> 
> <snip>
>>>> @@ -866,9 +866,14 @@ static int __init thp_shrinker_init(void)
>>>>    	huge_zero_folio_shrinker->scan_objects = shrink_huge_zero_folio_scan;
>>>>    	shrinker_register(huge_zero_folio_shrinker);
>>>> -	deferred_split_shrinker->count_objects = deferred_split_count;
>>>> -	deferred_split_shrinker->scan_objects = deferred_split_scan;
>>>> -	shrinker_register(deferred_split_shrinker);
>>>> +	if (IS_ENABLED(CONFIG_STATIC_HUGE_ZERO_FOLIO)) {
>>>> +		if (!get_huge_zero_folio())
>>>> +			pr_warn("Allocating static huge zero folio failed\n");
>>>> +	} else {
>>>> +		deferred_split_shrinker->count_objects = deferred_split_count;
>>>> +		deferred_split_shrinker->scan_objects = deferred_split_scan;
>>>> +		shrinker_register(deferred_split_shrinker);
>>>> +	}
>>>>    	return 0;
>>>>    }
>>>> --
>>>> 2.50.1
>>>>
>>>>
>>>> Now, one thing I do not like is that we have "ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO" but
>>>> then have a user-selectable option.
>>>>
>>>> Should we just get rid of ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO?
>>>
> 
> One of the early feedbacks from Lorenzo was that there might be some
> architectures that has PMD size > 2M might enable this by mistake. So
> the ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO was introduced as an extra
> precaution apart from user selectable CONFIG_STATIC_HUGE_ZERO_FOLIO.

People will find creative ways to mis-configure their system no matter 
what you try :)

So I think best we can do is document it carefully.

-- 
Cheers,

David / dhildenb


