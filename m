Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04074CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C8128E0013; Mon,  1 Sep 2025 04:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A10A8E0012; Mon,  1 Sep 2025 04:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 466FB8E0013; Mon,  1 Sep 2025 04:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31D8C8E0012
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:17:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0957A14072D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:17:02 +0000 (UTC)
X-FDA: 83839975884.04.C9A590C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 866C71C0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:16:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iAlK2IT7;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756714619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nkLdfO7LREf76//a5lXUqelHdImxWu4Mcdt/w87Pji8=;
	b=myNydFD77bVaJPif7w3BOQ5HUHyXMM3ioq7nKIxKlWJxSY/ZHFQIUyaGK/VA7uZRbBQGoO
	w+fW8eqI2W7Lv3jDDDle955R/ha5nS50kWj8ODa4FwcwVfbKHszVULy2aMzQ13r5mgOA3s
	OUVfNDeRIlokmcp230BGuljUuC1uCjw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756714619; a=rsa-sha256;
	cv=none;
	b=kwL3Y/pnPISTuhUTVTcl36D8Sc9+Q9Wv4408TKW69yqGo0HP/GSk0CLqkSkijX/UTU84hP
	Rrrjtd1gE3OOcjSKMBVRouUStsaLF7/KWRkoH0CMJJNwp/zp0Mx1nz2UHiorfx79TuUt8V
	S9brg3bfbr6x6CKNj5mFsVmqDmkkwTc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iAlK2IT7;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756714618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nkLdfO7LREf76//a5lXUqelHdImxWu4Mcdt/w87Pji8=;
	b=iAlK2IT7cWnoL3Gw39grHNpCBp13J3EqrnlctEcGyQuTVuL5TzGFpTjhFYRalq4Siq6qwq
	1HN+PdFo5Xy1nkmJHq5u/2//j59j/K+WaeFU++1lzvXX/7mn+MG1iv0qdoj34PPSCNDehO
	XcPIC4ddtMgek+qVhqR9wIfAvTkuSuY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-QQ8cDT2dOqy9MxaKAWrBNQ-1; Mon, 01 Sep 2025 04:16:57 -0400
X-MC-Unique: QQ8cDT2dOqy9MxaKAWrBNQ-1
X-Mimecast-MFC-AGG-ID: QQ8cDT2dOqy9MxaKAWrBNQ_1756714617
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b71fe31ffso24185825e9.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:16:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756714616; x=1757319416;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nkLdfO7LREf76//a5lXUqelHdImxWu4Mcdt/w87Pji8=;
        b=EdM19PBAeGbEPtP7eSgSRD9boub1F4gO9fV3Ol3w13vMHGLotYkSwGCV4ealB9S9T2
         pmO0Vj1EpAtEhMB2TqUZlb5MLenHL156LdSYJSsSFQGqveF1eAE+CaTzmKgKMaZUFMA1
         1btDFejY6sWdQEKXNKn5S6nQbdrIyZsQFMD1OmIBFLQwRESVPsbRzDh5A+f6XXUHLPbW
         ut8Y7veKyWqGhGaksw3oex31HC8wWTpAhzoP48Jrs8BjMNBUB3KeKfhoZlZKZsQ3m0BO
         ZlY/kzdn4gbsK3wANeNrM27BXnuC6eIiOg24MuqfQI5wu+esyx3EbBZlVkCzPjYQJTo+
         ZqCw==
X-Forwarded-Encrypted: i=1; AJvYcCXWMJFP44IxAOK8DHjOfqNhBoArCpUcJqLb8qegSsH2jzeN2sxVSgmfkyA+26PuXHD9E7UrhXmDmw==@kvack.org
X-Gm-Message-State: AOJu0YxkvPKzxgTKcwf7QpsbAqu4TW06l5T1T280KmdwqFHF3+Kj11NO
	+BuMTbd6hnvPpFB28YZzZNcHP64RrMwyvc7WgJ8K6I9Fl0ZK67lNF8irVYRQIASgizPva2z7eqS
	Aj7PuSyYHJ/DJaoUBito3ap8hkjzOofYV9ZbOCxb+W+afi2LvqVoPLEx+t7gM
X-Gm-Gg: ASbGncvkPqZ/84dpQvXJEbhDuyZaXL7r9YqpwuNo/EcBtIfYFo5enKbKmVG13S/ryTZ
	hVhsb3L50ibZBnRazUJCZWlHCjD489cUaC7+2UlYEL8oYN3BKCNk0deOO6OS6wRWU6j2CGdBMvI
	r23kAkaTKZQNVxiUagvQ/Y7sIkmNm36jFB7/IYVm+56Y7+Zy+wwbmK7e2U8zf1QrmHYzGveP0CF
	iLYvdZ918i7DB6te3DKELNJrmkwYJy/IVsQ/1wvB8enZG2a+ajDi/eavadUABmJ4BPmC6Znhq5b
	9zXIpxNE2vtQ52ox7vqBUXZDEut7Mvs8tMS++yMz2mYfHuZHRHWHVcLrvWZnl+lS8NcyymaJW0C
	B2azIWl8SILIkPO6roj0iVAe4tf3uPRzOCzpeWX9IpApuPn/0/CKDVW+nb4MaJf/6C1k=
X-Received: by 2002:a05:6000:1884:b0:3d8:7c6e:8ad4 with SMTP id ffacd0b85a97d-3d87c6e9003mr439456f8f.10.1756714616561;
        Mon, 01 Sep 2025 01:16:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwthdaUuRN/UHZwPjQCWXHJR2aYsLBcBwtQCJ670MV0m+dvqvfBHbNmHISZ0huNgDdFxfD0Q==
X-Received: by 2002:a05:6000:1884:b0:3d8:7c6e:8ad4 with SMTP id ffacd0b85a97d-3d87c6e9003mr439432f8f.10.1756714616154;
        Mon, 01 Sep 2025 01:16:56 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d0c344f6casm13232159f8f.36.2025.09.01.01.16.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 01:16:55 -0700 (PDT)
Message-ID: <df27d5cc-bac8-47ee-a03d-eb1eff6dbe39@redhat.com>
Date: Mon, 1 Sep 2025 10:16:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap
 corrupt data
To: wang lian <lianux.mm@gmail.com>
Cc: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, richard.weiyang@gmail.com, ziy@nvidia.com
References: <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
 <20250901081109.52460-1-lianux.mm@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901081109.52460-1-lianux.mm@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: b76hJjChScTXpleoE5lmDI85k-ml9ueHI0fuLBvNE5g_1756714617
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 866C71C0002
X-Stat-Signature: mza5ceujbfwejadzbhcettw11hc88kqy
X-HE-Tag: 1756714619-830210
X-HE-Meta: U2FsdGVkX1+1QITHe61DP3lvE5sLjdw8CzlZqoWN/Uif/3mmse2a/Hv3hHhpcJ77bhFRKexWMd5PbLGEN7sp8ar2Uh7KNNiohdGTG76SqPfh9Wa6LiBVoQ4SUpaIAGXFUTtttNgdAYXoJ3w3P8pp57fDf/lY/0b8N5ZdhK090maM38WTq7DP7IVGmVvQ0K+DmfVSs5zUtmFcfk+yCeUhueBlYcJW3dyDm5xQrIwk9x0ACgbEqaaICm9y6MU9TnvYuQNHU4A+hUtTfa+q0s41aU9238idISfOx80sDeHKgOMclNvDZlINkjzPRVy+L3TMb9qWRW2iIbUgJ2lfkj3UOzw9aN08o01gaff6vKR2aY/b6IswP81v7sDBU928YtdHp+ePE0DJhN92ADnRROuZRhgnb3J3iBr5h49hoYJpjOwEMWFeEEP9a/zGeJxOL/YMao1y+vmSNgjnrw29fvWlTEcIntS8ytI0f2Zu05YC+xM6AngzTpaqOoY/pr2/BSSBnJ8/iEBSP8XA8AOKMeNb1agbcfTuDHgPsiMGQsDtc6zQNmNT/tWC8lzWwhoLtKWFdS8gR8sTT2OfxCwYD/T7gQaqzVCgy7igAi1CEvaRXCmhV4pEKZFnp9ivVilvr52UP8Nv+ZI/agid3H3rNAGT5dLAwTzz1PQM/omIZcEN3UwdQ4xPjmh0rSitxuekJXjjvxBd6oQmPe1ynMyyXhNyM6/8qxHVfRf1YjCdq7KeFlHaO9Uu9zN4+eiVQ97bfxyJkFBZuqVCerVO4hNVV1juEJOYv2eL+trMXxCEl6fqBn4WIG64R+Y/L5E0p3BCyzre9D9tuSsu/AUKOsIMjYK4wpKScWo+2qcowez1dbrLrpIEFY4lVgkDWFu9RMkcBhA9/IC5qOP0FfkUfKRE5Oc6LspyGwxnK+xpLPezoBWo05wSnvuZayI1HMHt0Jf0gaCFClSkSfibd8MPI9U8sNB
 wNxEkuM0
 IBbSx86W6F8a5/eNDtS02jr0wDbt2KBa7GuKGVn0pW7qTKf5VvrnqaEisvDbykqWfHdUUc3X+UiUqeGAQlIgy0f2kNtEcE/jY7W41Ql9mfumuvpr8zbCE4R3K/o7X306gQrVVRAfsGR67zj3dwwzX1QY4IkYAWnTAvQWvlvWyAb2o7qcVukVtDgMMly7aOXTsWpRT1yDYjJbXi9ugJfpmkNvcpbhm7kJtJOTrqyB6OdIlhMEyq837AzFavJdz0tOErzs1OPfxaPjPOwh7F/JEXJafZg1sfxnGp+9aJ8RIRnWXacBxwvCUbiks7tIE7x/wOLNKcVUglLN148r8YdHhDMPzkJhFk6sXcUA3ARFF5ziZDgGTBBLwHjb3YPdmZ/RuZyh8PAtfzT7WiSmoAXOFEDn158Z6r43RSFNuaVZ5jkWCcphBG66eWGB7aHDcpKa7NSaPkeioJVJPLmtjMEFVQiLIFcsU4euNvv1rQt7N4tgT38SVVxQ/kZKhMqAL2KWV/7toum5RpBNDtrLuLvUymdjnNA4r498mvpaC2vie9CBn0GFVbJEe8JWIyxbb6a6FHAZZviegqgR+uIp/t73qyS5YkdFmyibLwZ9etKVqurVA63JyNzrjFLbuLNOlZlhRWmoS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 10:11, wang lian wrote:
> 
>> I'm confused, don't we have that exact check later in the function?
> 
>> Your v1 might have been better, unless I am missing something.
> 
> Hi David,
> 
> Perhaps you missed this in the v1 feedback:
> https://lore.kernel.org/linux-mm/E0C570E7-C4CD-4E41-9590-DDB64757CA2C@nvidia.com/ ?

We have:

	/* smap does not show THPs after mremap, use kpageflags instead */
	thp_size = 0;
	for (i = 0; i < pagesize * 4; i++) {
		if (pte_mapped[i] != (char)i)
			ksft_exit_fail_msg("%ld byte corrupted\n", i);

		if (i % pagesize == 0 &&
		    !is_backed_by_folio(&pte_mapped[i], 0, pagemap_fd, kpageflags_fd))
			thp_size++;
	}

Sure, it's after the split, but if mremap would have corrupted the pages, surely
it would still be corrupt after the mremap+split.

-- 
Cheers

David / dhildenb


