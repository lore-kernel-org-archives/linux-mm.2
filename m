Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE755CA0FFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 04:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE5066B0023; Sat, 30 Aug 2025 00:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C962F6B0026; Sat, 30 Aug 2025 00:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5D836B0027; Sat, 30 Aug 2025 00:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0AF36B0023
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 00:59:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F174685B72
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:59:35 +0000 (UTC)
X-FDA: 83832220710.23.9616F0F
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1D3F140009
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:59:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JXUlKwIk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756529974; a=rsa-sha256;
	cv=none;
	b=OrJiRz8UtUqQaVD0fH9+bUm2p831gP/cG96IcPjuwPIR2ADYVeMO5aK2gh+tnVBrr2x5hH
	jqmItaHDsftCevNp6pFiqspdfjF0k1UZi9OoapzK400xwr+zdxr9DcDMmxSEoyYNhZLElp
	/pEOz2UBahbcpudT8NuC3GXOPqkXzyc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JXUlKwIk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756529974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=ECUtRIXM/m3p0uCZ6iejxUu4ieJmp6wy4rmOCxQvy0I=;
	b=gV68FnH4wMs8wGlezHZohAql8aY3gCCngwl8xi4Zhd0uSm1DpjBTn14X5uRzf7Um/CWYus
	36z/PMjhYGz5dVgN+loLL+KmTbPrEPJf6ZXfSW3G2OTyZxBJNQr4/sOJnjbRnrzA/cuqs7
	SNcwhaO4Oll6ZyZZI+1SmPhou8JGpMo=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7722f8cf9adso1222868b3a.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 21:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756529972; x=1757134772; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ECUtRIXM/m3p0uCZ6iejxUu4ieJmp6wy4rmOCxQvy0I=;
        b=JXUlKwIkcBkm9o6//wRxJ43lgISF7mZKPhIrfJ++ENrs3DG6vTzkv8XMimHemPWwoA
         jwB0sEdaOzc32HaTtW1LRz7zbi/MQWcqQM60R0BUJf21X25yQEJ+Kz50+DRZdNndP9wh
         /+PpBkJ+WZo09Yz9cYn/TvPd6Ns3pZl2kBU0vjBt2X2EpC+7mUVYuTeHAHcAn5fcP7FE
         P+cLThUnVpiV/5MfxA1owypDAvlNV5qyw6Zt8UadbxdEv8l+BomgGfVKA4JHcpZFF/as
         XT7i4LZ584Yolct7ywFwrQ+D/T6tH8N3hJpk0NhfDAw71N1C4GqHF7j57vB9GjJ8ASMa
         vyPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756529972; x=1757134772;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ECUtRIXM/m3p0uCZ6iejxUu4ieJmp6wy4rmOCxQvy0I=;
        b=MgaxIiARfD4g5mO8zJsvryasQUZREYRphFVh5g5FxGWHNzbK7BcNMViN1z8XR3VqLy
         cbkWu8iF6U3L8VTrrhyynabeeK3nweQ1WCze7sUaLXrw2kFC8Fs0CaFZfDPGB/M2f7Pg
         ln/lWtXxCqpBXexTIaoggVw0EF1HZqI3OmxcvchD55pPZdYdNJN6G9g20Q1CBllprIRj
         LTvdCP1ftCeejP/xFCd33jH4FNYQtFJBeZudDwAXW7jHDAOlfZ2qRYTSvrIqfXjsSIFk
         jaZ9DFU+NYuVRMvlBCeTiSCQ9vWbu0YXlAaiGwk/DIJE6gTeTL/eWneHdBaDSn+nTNUn
         mRWw==
X-Forwarded-Encrypted: i=1; AJvYcCWY+aI8qfkkbsscEPHZX4MXZa/jyFZme21izww1rgzszE5d3f4lNRKnyrmeKqSZAFHpKW4cVSDqPQ==@kvack.org
X-Gm-Message-State: AOJu0YyUZIOsqA8R6l91qW8hrAcPpj9wn7zflhR2tSg6LG1zTdB11z0W
	e5VmQZPhcMB4UXarqWMAui7v7724Ttskd+jFeEBcMVEBG3/FbDad6ovTD/YugA==
X-Gm-Gg: ASbGncvtPN5iz8hQ+yl9Bf5APptZ80EhnO5GznnHIPIN1C6SJ9yNSGtC/3WIClsIWha
	L4M1ZyrOG4qjRT8wwKTC5NzC0+09K9V1YDbYUA8uvSrKpmEcFnD19TY4SBdyXM2AgVZzlO2w+Bo
	LRws2+9BeW/olVr3jnbOgOQE219UXmSxEKpB95aU1FXYWuI5gEB/S7fJ7gxL6vKRosYThyYi2/0
	2t3wm1mpaYQ0n13YERnp2zKH9zb1GytcsfaElnHtEw/rVnTVu6tON1M6VKjyVZvUw3IoG2DzQPc
	0v9Q3Ea3KPH2txvBQ/V+JD58Ho+B87HR6j4YrdH22k/LU+SSqCeTVDZCxcNVV7egVYAPSkHctV2
	EQYa5GVuTUHzInXc=
X-Google-Smtp-Source: AGHT+IFocOUBHixe2wv+gU96RrWRxGPvxKCNnqco4rS/r7Pe4pX8vYeeFZ0tFygY5WYh3POLg7pdfg==
X-Received: by 2002:a05:6a20:728b:b0:243:bfc4:463c with SMTP id adf61e73a8af0-243d6e5b012mr1543524637.25.1756529971878;
        Fri, 29 Aug 2025 21:59:31 -0700 (PDT)
Received: from dw-tp ([171.76.86.139])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4de04a9ea7sm1557942a12.16.2025.08.29.21.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 21:59:31 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linuxppc-dev@lists.ozlabs.org, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas
 Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Donet Tom <donettom@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC 8/8] powerpc/book3s64/slb: Add slb faults to vmstat
In-Reply-To: <20250830144542.6ba0e774@canb.auug.org.au>
Date: Sat, 30 Aug 2025 10:26:45 +0530
Message-ID: <87y0r1jtki.fsf@gmail.com>
References: <cover.1756522067.git.ritesh.list@gmail.com> <e05ac86618d8a52feccf5bac99da44b11871382c.1756522067.git.ritesh.list@gmail.com> <20250830144542.6ba0e774@canb.auug.org.au>
X-Rspamd-Queue-Id: 1D3F140009
X-Stat-Signature: b3bfb3o11gq9diqnrzxsogdkbjt1bbwq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756529973-809681
X-HE-Meta: U2FsdGVkX18emPcEKBjhVQbPEJQjjrQOy23QaBNYcFbEyjHbFSl2dZoV/QQswcvlt7DanDHQtSEeFFrH2Dq7TQct6Fy0gzQhoI16U8xurrToJgZV2u7ML50jLWLVBzptE1x32IPlntn87qmI5wJNTkPtBZnjGImgxeC+9/Zs3uZ7dX7a68X062Chipm/8FCWSx+lEepER89RnBxPgImE5bsYKLWJkSDTEVi9uEM91IZn2IHImPy+du6Ihm314E9r95GZBtk4glg9vXL1mtoOunsVAFVCZ87vPMKVPE/87+EeG9+ofQEI0ILn33EG+mxilw7Kzd4SjKl0DB/Y2hmSamzT8M/Otc6xo+AeX0VyqZ9Oi/Vc81NSCpmIruViHByb8IyV+Fy8iQ/AENNxOoTCSq+iszzK2qfgB36OVYFobvy/+/cWCrTXVMSSUbGHn74ttkwTf5WM2rZfDZf4PUn8FT7Ywg66ZfycCCnTSQsrb2REuwInsAvRfT4fx/ZxTYjX4yW0ctXvm/kuu4WFI7Oo6AbaczzPW9P8j++at63V9rdjDJx61Oxtv/znIQ6bSxgKM7bnCWzxIVj9dZaH4TOeYuZBJWrTrxhow79ZhHClRWanS9TFrhKPyJ1PoZjS8/ky2wYRK1MwHWAUfOgqWwpnhoSTmheM1rF7OmrL9gwebgKl0Ugnf3EbVJ5bSWguefNtk3fg21//UEw7XhH9K2+ZVnJfWXrbHMOIz2m8CikFkOhKnQyi24wRfjnnOKsXABVSuA6DBg6WFq7rKUxYatDgTlo8LSj/IKcp+Y6laMNTF9gsUmqoLAQneY7bHC20b/MwMMjB9U4PCnM0MLomFXePCj/wNSHzL5/IB5IABoltv+Z4v+sbc1MJZ/2WQkEkgbJlG2N9yes5twIwYyq+YjzYET15XxzYHxM3F7/ApCVuSSlU2kL+xV007lghNpRyRPP45DAQnck9fFAFxoTEqAE
 NeljdPde
 yQCh5Gj70RAVGUICakazyGJwbcHncIrJsNg8GqS2joLYmQWEzNMo3jG6g4geCCwvcCLEpClXUQpIgb6JnU3G/JjYISXdFSKXRWi2J9BjTw0yHNhfVXm+UsfNU4rB4XrECIyOfi0czIh04C1Q7tJ2hHdbLwYdkeVOCFuQwrozwGC988PN/sFG05FaSaK0tdqDSWB+xmui6NjhzK4QujjtJzTUItCvkv9jcdp65P93tULaJO9GIRm+I9/Zyo+zDpX8SQlhVlINyZVreYQtGqv2Xz/mgOlWT0xTef7dvcbT2eAeB2MZp0RYKS2mWRxTlCN0hn0SaoYMWLKY2HomGyCvYX1g0i8O8SE0MGHY6K6Gy1dHSRN9R5UALhrlkHNOBhK5i2DoL+3pDOiZX2Msf2/5TisZ7wPq/1gnz7VUNr93cwXFa/LwclhM9CGIsKHSRheU1wCtoPDyidnFRJxOVI/jeH/fkYQNMmGz0UkaiZHuK0qQwef+bSN+d9iEObA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Ritesh,
>
> On Sat, 30 Aug 2025 09:21:47 +0530 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com> wrote:
>>
>> diff --git a/mm/vmstat.c b/mm/vmstat.c
>> index 71cd1ceba191..8cd17a5fc72b 100644
>> --- a/mm/vmstat.c
>> +++ b/mm/vmstat.c
>> @@ -1464,6 +1464,11 @@ const char * const vmstat_text[] = {
>>  	[I(DIRECT_MAP_LEVEL2_COLLAPSE)]		= "direct_map_level2_collapses",
>>  	[I(DIRECT_MAP_LEVEL3_COLLAPSE)]		= "direct_map_level3_collapses",
>>  #endif
>> +#ifdef CONFIG_PPC_BOOK3S_64
>> +	"slb_kernel_faults",
>> +	"slb_user_faults",
>> +#endif
>> +
>>  #ifdef CONFIG_PER_VMA_LOCK_STATS
>>  	[I(VMA_LOCK_SUCCESS)]			= "vma_lock_success",
>>  	[I(VMA_LOCK_ABORT)]			= "vma_lock_abort",
>
> Should you be using explicit indexes and the I() macro?

Aah yes, I guess the branch where I developed the patches was not
upstream tip and when I rebased and tested, I missed to see the I()
macro change in mm/vmstat. 

Thanks Stephen for pointing it out. I will fix that in the next revision.

-ritesh

>
> -- 
> Cheers,
> Stephen Rothwell

