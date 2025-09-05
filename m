Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91971CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 14:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBD5D8E0006; Fri,  5 Sep 2025 10:25:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46EA8E0005; Fri,  5 Sep 2025 10:25:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E758E0006; Fri,  5 Sep 2025 10:25:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A94C18E0005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:25:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C820119213
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:25:42 +0000 (UTC)
X-FDA: 83855420124.09.3343369
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6DAD5120009
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:25:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="K4t/pr3g";
	spf=pass (imf29.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757082340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t49T5ieWmqvjuwDEwWCSzOWxn76CDIcibE8FOXUbAwE=;
	b=t+niBn10lwUpga7Amv2HgxLhj7l9TIYQU8vqkCFNSRFd3Z2kwx1Uk9m3Vfvrs2Ku+W632J
	LglWxDPD6XYzKnb1OsWguf1s9YH1bE7z+sGgNAJyufXA7vkcCY+qasCbCCGF0x+TPzXJBg
	17qYp282kcreeoN+IrgORXhC9lBqY9A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757082340; a=rsa-sha256;
	cv=none;
	b=lngYZwcm+UHCWf4b/krlMt4PqvCPL3nJLHWRDJDkTwtWL4Kk+OkkpAbQhBHHiSlKRluZWP
	liASl/PbvNbrbf7lXCtJpxBI4hbX6hmOr78VRIhBbQYGbeLvk3MiiJ/WDRj5bT9LiLfH/w
	4zBFSqRcc1y1OX0wtxyELYanoyAxmmQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="K4t/pr3g";
	spf=pass (imf29.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-55f6f19359aso277196e87.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 07:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757082338; x=1757687138; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t49T5ieWmqvjuwDEwWCSzOWxn76CDIcibE8FOXUbAwE=;
        b=K4t/pr3gzjpAyoZDFmg3mZEISx1PtKHMM2OaSS+MapvZniNxEYy7ONA0Z4/9EDiqKK
         qVQilhr0JnP2FYBVZuajVFTBHW/VW79UxHSh8wSk9RvmQMsNuTduCmoAuGUkC/bMsMvN
         Iqj4NXDAbZgIp/wmjVaPLjlQ55QGtLiI+DQC9fiMbjbdXM1tG1N0x+uE8gsHnzO0Z7ju
         RAvfBpqIu5D/SipjWUMGMvjmPu+IWhTaJlZSZM9scOB30oUBlTf4FkjSzA8qJAxA9lz9
         AvhKeR20TdSG8mdUVWcpOK2ogM9jcNizYvzVmosLzGkFrDMSSLii/GzYfOyo6hmOKUiP
         KI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757082338; x=1757687138;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t49T5ieWmqvjuwDEwWCSzOWxn76CDIcibE8FOXUbAwE=;
        b=RbdLbvFOG7gDG4v9vgUwKml29Gd1dn0t/iFDp3lFBi0SSzFcCaPkzmDKzm1Cta4oeO
         VWdTDPHml1Zjpr056SUQzXYsc3iChRqecwABQUYZiornfoXvS4VNdSMYsHCpWnSjtGOe
         WrBdFXdyv/zgwdvFtzxwNfU4J+EGdiNFjOd0cbWdbXmpSRiHnou1l8PKURE2bF1/5kVJ
         PrLJmKeEu31ayCg2Ub/zWemrji6efcyi4/UiZFUpOTrOlasBMZiAmpTxzXxWzc3PfqrS
         694HqOJn8TyzaM8bIeyiwOp4wuiD9dkJteWfj9Rvhh7jME/VfgH80SI+XHz4/TAUj5ls
         V6RQ==
X-Gm-Message-State: AOJu0YxmM3SWnyBvejpTXAxt9FRreLa3PCUJuqEBOTpdt4sv9xOGlHrc
	NbL4WJt6iNZS2aWGJv8iin8jOgd+qy/SZfoeEaQJ0CJK6wcsb6pP1pyM
X-Gm-Gg: ASbGnct5TcESvTVgn4C6tr0e/K8O3G58bQm0eYvVF1LknNh4U6JnUhzhzGVI6dE+FGo
	6Fp14JTY5AiBfFitYMtNfGxfQm7+e4kRtHb776hBqNv68j6yxLFGhiMZXm7kGJmNnuyySUECxBA
	n2vXnGH2dCOy9SIdDmGEThh5uPpMAR6JS+GU1jrNPIEHJ/ft4He9vUCxX7DPdLiYthzhTgv1eUJ
	gj1uyop7RQUTyszGBeYHNVL5QEQ2OEK555odJ8ahrrmTS8MIuTT+88+oao0mhZebGuMIHjEWvgP
	/Xfj2LNC0GWci8eyo4jsfrK6sApXky/XObYnyTNPVxKniH8NaA9Q02iWLtYbFUXE+PX/gLizO/9
	pKVw7gaJIZjhvlZCrMfL803dBkYnq
X-Google-Smtp-Source: AGHT+IFCdyxxpgiXvUfdPu0jSkipTrD4cYHne5e/pQOWtiT7Jg2VilLFWXWjFeMaxSOCIlf6n/Wo6g==
X-Received: by 2002:a05:6512:3e1a:b0:55e:a69:f4a3 with SMTP id 2adb3069b0e04-55f6b19a1a4mr3693761e87.6.1757082338231;
        Fri, 05 Sep 2025 07:25:38 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5608ace81a7sm1775871e87.74.2025.09.05.07.25.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 07:25:37 -0700 (PDT)
Message-ID: <732359e4-8b8b-4925-8d66-2531e7a22b73@gmail.com>
Date: Fri, 5 Sep 2025 16:25:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc, mm/kasan: respect gfp mask in
 kasan_populate_vmalloc()
To: Uladzislau Rezki <urezki@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>,
 Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
 stable@vger.kernel.org
References: <20250831121058.92971-1-urezki@gmail.com>
 <20250831122410.fa3dcddb4a11757ebb16b376@linux-foundation.org>
 <aLVuw2UkYUcL_Oi0@pc638.lan>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <aLVuw2UkYUcL_Oi0@pc638.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6DAD5120009
X-Stat-Signature: ktx4fpai8q9pjrntoqxk1cpkuifffdmt
X-Rspam-User: 
X-HE-Tag: 1757082340-842389
X-HE-Meta: U2FsdGVkX1+halMqlfZtssT382ZE8gkra+t5waDrt6eDJE5It7GKgXB1sj0Upg35zTv9ywetZg+Dz6fhA2Z/o9+G8UnGaUlPL5hIUb0ubbS/MCVAWK3Jyj6uvm5ATw6/DcSNXfnd2LSuXRk99l52uanEf6Ji1A8qqk/Dq9XG8Dl1reEeE2jB2/GignN1dCgUCGgAvjm1i8+t/RBZb05GkebiAa4V5OpZNfwEX+zByQLi22gK8W9ZWBxL3EEG7P3qmIa/RxtGtAGsD9rIWHPBmptIOTK+YCBl3MF8FIiseYVepWigE84nEk3zEFQ8/ccwFJvB1qas7/5evEKwwX+PVhk8eZwdKuO0Rp5GvNNlmfOpAhM8GMrVpnkVVgDvVjN96Fv3+n83ebw3GgZmv/9CDhlwVGyuaDhh1UWLT+qrJ2YqbsJR+HKQd4ypUYyV+szE6/mN5t5osSSpmIBMJ2V+nn81/Houdcl6qv3zf5F+QjpSGq9N2cwiZFb+QZaWvAWff6i1anx6df8+c8OoLroANRkwF7eGusNmOXDYKDGW9JNLXmc/GIDMceh4LhtAKUOoKFirJzGw/RKXAahB4cB9NtyjzCSTMgso07i8h7qsFYIb9g4YXIEWExuAzXaQZisEQ/JL6YGdIc4A6a+Pfb03ZhSnGuDlCrN5DyI0+SbJWeU7m73+g6PG6kRhXdtKsIGWPOYuo7fOzb1ETREaNQtMOfCT1eCtmxlr7kNmkrSWEG9cOllojzh5fsbqZa40UsuGxbJ55n1obOXiXzGUu+g+y8C7vTwFWrVr33XPsh5lyqrfkvplRfS7smxGopl/nreMWW1ddJO/E8mT/6HluMMv+xSBCuNEkw4IK0w0eoIxRsHuJspjnGDYCFunFC8IjxUZpOFCmE53r53hPWjphIBfJjaSYhl9H+Gbra0jrMSaGTH6Ub7aOO+WbNGN1m3GEzltAb+CAN+A7P+2RiLGZeP
 Jy27NAaU
 DpCpgt0iIINLjiJWDWR3pEO1DWPrTtXvSKabCMsJBrVkXgr6PEdgO4k/6WJujZM5nWFkxeXu54QbPVSBPl2nlPyTXb7ZwyUzx+lUhacwjRhsecqBXnSyAtXAUyEXagKJ1xkc05R0UoYFyRc5Gqhie/j6jXIn+06XNibt575+6rIXZfpzNbj7csLYPPP75XMCqnLyYYt5rue/vT3At5R+9QMRyVs5JXEwv7iI7uQ4paPpSZNZEUoJmIOO1d1TcFTyOmZ68fIRSf8ZEnAzLeYiqMlAGPSKtacDHu59+aSIwR+ujh3uNGtYX+Jo1pg+E7IXXOzAsPnGaG700vUuuaPZGMmFeQMClj6986/r239wdY8b+cbaoglSPbYUBS3pZDOr3UJS+aCnHrc2x1FkgnXo3RpbBrNNdV9Rt9M7ajHFltC0TiXF5gadOFe7Bsh81yUDTUVjEAK6oQn1l7uXxOU2pdsIPvE1qfC7IHMuWWW+w7zQqhAAb0Jk0/GMqo2fkgBBZazbFUfYySEnSH+F94psp8oNTA+QhOPuCLsB2lyHvUyi4MqiQiXnwGcWQEQbkuF3ou1y/OAoDOYCBf/k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/1/25 12:00 PM, Uladzislau Rezki wrote:
> On Sun, Aug 31, 2025 at 12:24:10PM -0700, Andrew Morton wrote:
>> On Sun, 31 Aug 2025 14:10:58 +0200 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:
>>
>>> kasan_populate_vmalloc() and its helpers ignore the caller's gfp_mask
>>> and always allocate memory using the hardcoded GFP_KERNEL flag. This
>>> makes them inconsistent with vmalloc(), which was recently extended to
>>> support GFP_NOFS and GFP_NOIO allocations.
>>>
>>> Page table allocations performed during shadow population also ignore
>>> the external gfp_mask. To preserve the intended semantics of GFP_NOFS
>>> and GFP_NOIO, wrap the apply_to_page_range() calls into the appropriate
>>> memalloc scope.
>>>
>>> This patch:
>>>  - Extends kasan_populate_vmalloc() and helpers to take gfp_mask;
>>>  - Passes gfp_mask down to alloc_pages_bulk() and __get_free_page();
>>>  - Enforces GFP_NOFS/NOIO semantics with memalloc_*_save()/restore()
>>>    around apply_to_page_range();
>>>  - Updates vmalloc.c and percpu allocator call sites accordingly.
>>>
>>> To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
>>> Cc: <stable@vger.kernel.org>
>>> Fixes: 451769ebb7e7 ("mm/vmalloc: alloc GFP_NO{FS,IO} for vmalloc")
>>> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
>>
>> Why cc:stable?
>>
>> To justify this we'll need a description of the userspace visible
>> effects of the bug please.  We should always provide this information
>> when fixing something.  Or when adding something.  Basically, all the
>> time ;)
>>
> Yes, i am not aware about any report. I was thinking more about that
> "mm/vmalloc: alloc GFP_NO{FS,IO} for vmalloc" was incomplete and thus
> is a good candidate for stable.
> 
> We can drop it for the stable until there are some reports from people.
> If there are :)
> 

xfs calls vmalloc with GFP_NOFS, so this bug could lead to deadlock and worth
the stable tag.

There was a report here https://lkml.kernel.org/r/686ea951.050a0220.385921.0016.GAE@google.com


> Thanks!
> 
> --
> Uladzislau Rezki
> 


