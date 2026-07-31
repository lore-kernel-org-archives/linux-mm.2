Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED45C55174
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 18:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD2AC6B009D; Fri, 31 Jul 2026 14:38:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3426B009F; Fri, 31 Jul 2026 14:38:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92FA6B00A1; Fri, 31 Jul 2026 14:38:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86D1B6B009D
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:38:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 224DF1C0DBD
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:38:15 +0000 (UTC)
X-FDA: 85049931750.20.335D10D
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4EEB240002
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:38:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RbVXdKx+;
	spf=pass (imf12.hostedemail.com: domain of jakovnovak30@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jakovnovak30@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785523093;
	b=rYOB6QeSY04PDKM52J8BzlMlneCGGu5+FqdgyBXTFsWsg5Vu2aJqAsoG3kaUoXmK5Lyqrc
	cT8gp/d0CkxqxyIg5C2glmmITufeTODbm2O9R5JUA0lHQI4TY/iRkRCS2pK6czdApeZP8U
	IQqbcUzRV0g8SbzasSUsJs7NNVMy8i8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RbVXdKx+;
	spf=pass (imf12.hostedemail.com: domain of jakovnovak30@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jakovnovak30@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785523093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cuo1/buJDSgVaRnV7IziqM+qa03lBm77pdDeWz/JLcA=;
	b=WqhydO1AUOBfcYH1ssGiUnEQqFxGfo5z7OkdUWxWnm4dna7/UVfLaSZ9fxFrusKl6CCdvU
	v+4LUPtKFKvvBfV3ZXrzDp807miOy16Kj9rpxRvFdquGQWaY8FM1tRzeOjMCXq/hQZ2/Nd
	Jsf2HoHGy7+iFCW2Y9/evW9zgy0PJ98=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a051904222so2048078a12.2
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785523092; x=1786127892; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:user-agent:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Cuo1/buJDSgVaRnV7IziqM+qa03lBm77pdDeWz/JLcA=;
        b=RbVXdKx+QeRVFg+UpAj45bkvRc/oC+OdLWXrE9fdYVwdqJB/I0iueZcWKHAG3At86Y
         29VkHu5mG/0qic6N2z7W1AOpJ3PQ4OhKIvtISUIm54PkIuckWyDKn3KIcGMe/b+oM5sz
         S+J7USsox01dFMDxk5Y+pf/5HmjbOoit6NuiKK9YVb+9zABLtCmph9kr2RBcDWlrfFud
         g+wyp0PjwHJ3SYit4pOYZJ9jydWwUBHaKhOgkJ9c/qZODsSal3zKFIWSW1CCu9hKDgVT
         aE4zxyT6C79sMzIQiwD9ylbqBnU9zvtMHPSgAnRN1X+sLYYgmUeo7jn9Z6G4B7aoVN7h
         LyoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785523092; x=1786127892;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:user-agent:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cuo1/buJDSgVaRnV7IziqM+qa03lBm77pdDeWz/JLcA=;
        b=X1UHtUy7NNCICd0PNNXOGKjPAZjYl21eK3HcBxwxI1i2RNX2ptdMjsM5JH2GZY6B9W
         +U9T1c5LSogS+NbPuBFBHuhpdazFQ0c14LMIUQ4PySmzbt1+ghuT4DOKr5EtDubBTJGK
         h1r99LeE/7SWT4P/T8ru0KmvgxscghKpo/jZyX0KVAMx6/cKvQM6XN6SY5qbr2Dk7+C5
         UDr2MgTeBtXjvZ/68OJ5U9kXQBxQBhD7dTQyPhCXWogQA2q/bldkiRfm5pA58ljTq1x5
         QBC5slYkHh9ZTkYrngxP5dZNT3gQld4dKsZpfUSuMVqjbVJYuSqnVoHlo/ROIJJEbV0b
         sKvA==
X-Gm-Message-State: AOJu0Yzcj3VdXtIoClb1jUtW4yrbO9yAfmVO2MrFrO2nSoidGdjpwzAl
	okBfJG4+OhIc7AfThsbJMDVXJBlrBrK4CpIDPPMqeDknVQTLN5ml6f8=
X-Gm-Gg: AR+sD11QDME2TW/gZ0MgKPTTKZ7cV5OI8Miod9bUTmDq09MQjFbnqaQ9M/uO+DOd8tu
	1+Ncq9hG8XQHFGAJhih2zLe1GRcmXl3mSnwfxjeCJka7l6GqkXdv3jypk0S3cwyxHO1VvySKFcl
	wClcFAwD9Os3Hc3BXhRzhPFYUKiziakxfS+ETVvByJwT/t9BAsJvlXEAChCADVgIItPV2WGcsSR
	WGRzQ+OK939yIyWr9pCcRqlmcPdDOtj/qGZr+alRmd8tG9DN8oopA3sP2TDEjsuQB8AsCxlFuea
	9sqti7CnlObbpG/j3vVphKdT1cmwVXqhrLLtjbHMlIKWkuc4v3bppy/LXIy5mhpb1iY/mcj/vsm
	phFbzCm9X7HxQYrpTmkKHKc2calcz1THw9mBWoRNXf/WiPtKhnPINAqlVcEv4qjD/LwdQMNRHYx
	ZqFJbojg3o8jRcIWl6UOB/nxexmX8/nc+k+fcTYTwbo0SVqI2y+OTCE31PRy+5P3b9JZfXmrGIB
	NYkoYQUr5DhZl8rfjjNaCOQ2xiYcuz1szfZV9odHK+zCGfm8dKpBLsN0dbPmm5vUM4HiHTWT4PI
	Er7wtkneE4+4sA==
X-Received: by 2002:a05:6402:1cc4:b0:698:821d:aa37 with SMTP id 4fb4d7f45d1cf-6a0a7cd4980mr372451a12.24.1785523091596;
        Fri, 31 Jul 2026 11:38:11 -0700 (PDT)
Received: from ehlo.thunderbird.net (92-242-248-21.broadband.mtnet.hr. [92.242.248.21])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a09c655626sm3205982a12.22.2026.07.31.11.38.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 11:38:10 -0700 (PDT)
Date: Fri, 31 Jul 2026 20:38:08 +0200
From: Jakov Novak <jakovnovak30@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Pedro Falcato <pfalcato@suse.de>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kernel-mentees@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "\\  Liam R . Howlett \\ " <liam@infradead.org>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Shuah Khan <skhan@linuxfoundation.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v3=5D_mm/khugepaged=3A_replace_mute?=
 =?US-ASCII?Q?x=5Flock/mutex=5Funlock_usage_with_guard_macro?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20260731112541.6098017d442451a8b54345ec@linux-foundation.org>
References: <20260730204724.16912-1-jakovnovak30@gmail.com> <amx5XdMQ7S_krjNA@pedro-suse> <20260731112541.6098017d442451a8b54345ec@linux-foundation.org>
Message-ID: <716E3F29-C75D-4373-A8CE-C2AB2DD7FFEB@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9yo7p565rzn5g9n3ab8xr7ui5ignq3fx
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4EEB240002
X-Rspam-User: 
X-HE-Tag: 1785523093-83369
X-HE-Meta: U2FsdGVkX1/5UbRhe/YqrtnbdSRMm+HJxOPF/66yw+496YwPBP/nRfJvoHRIItC7wUyDIrU0qy35e+5gB6owcG269RNMzypn5Lk/z4yqJih687jKMGxhDoeWwpqOi/HLLvrhEOB11/zYy0j0DytYLBaU/mrwkQi+JPoBMSUjMlTr4jXgNWuwDvIANmZ7jxQzxp0ADeA4h1PSGcWVt4j8/Jkh3Lu3BE2BteoEFGoouYa8JyjPQEDQGVhc1cLzmFeg9AL9TvV6oKIYUWgWGz0OwlwQAi+XOMZ1Z2lktB4XOQQWBTqm4vqcVpfw2ohToYCxyIFu4c8LGdkjlrzHUEm3hd11Q7x+qKWWDVxgytLVpjrMtZj27fV8N/4kp/6grzcQZ0buEVdXOerCDQAZ0PEEDDG3h2vwZ8oQbNkwJRO1Ia//9SbKgF3XZdZdzyBEfRlvc/eaZMNBgHJ8gOi8vb2OL99UD8fAVEmuG1q9HfceFSkPiMxERxrz4lfSva7ZuTsYhnUkEmGoWBXDxv8ADL8gjcvWI2Qg7mLO21feV+5zvanMIwTv/yacSMRbeEls6O6BBfet944ExlJZTYGpDQJhWk0b9Tln6eSHxjtrh4FsyXe4UEDmYNdvoeAfKvXAD+UWH4HTGIem8KD1CZrncDf0/sBFXBoNPDXeYCk88i24sRpzKqL6eggy6ciyfDZXddIdp/F6x7mBPdeR9N2I0Ebvr9i/jkahwA86wPsGz6IO7/QpL9XJcs2wVMdQPcOWt2OqDQdpyBPNT2OWZFBHyrbqr906CFf/hDHuWb8OmsYhZLipIyZQntpBf5ONhAnE3ePrb8VPvZ2slWkozDG2bvbLF536EVDprc+fvFuP8OCpMD2DFN+XHZ4SZ/dmcVGTboN7wbxlQtTBFbR4dpSaRPcA3L8EqUzzT+9uGqwjXlS3IuFLFIYxZ1jY5NouCCBa8o6n63fZAUqYWPmL9Ai3mQv
 ruXMLvAt
 i/FdK31FmEyaOBXUkWfQt7wJ2bMA1H/8qkZ2t2U5ReHGEBrQqNUg1dxE+id5j+U25xkhdPyXEsng3tR5igsAypQvT63IQNf1EV9exuLqdye/eBNoPmeFeHnNgfJqofFMVHk2HHEioHOUZxchmwdyD0g67ka8xrhQW46+Po+XEW7AWTp53WKAH/AyhKdIF3yx6wiKAusCnSSt8r5D7zRBQI+xOlcSxx5auFbhhhwWcAchvCfEIntpD8DDBWaj7XT0+rOZRql2HZupOX2UkupYF6Tsvf9OO3X8sf5tUJZTyiYoeOEwOOfvh5iDOBa25kEiyahGrUnHr1jXseBznHCd7Dlsq4ihSOXvWaZ1rmvRxeUq6gCSZjlN1me8ztVjGPLZuxfWCcjN8HeZS50Hbceyf8Uw7U1TzCtTd75dHN+RG1WOZcOlFQ7gwnY6lCFGtvcC30RsIPDGlvso752c88gjwOE5taarC46cRD+bxw3ffXBRek6g4LZHE3nOiwOxks+V48DhWRwg+TUj3Ik0w/H9KrblobhAAesXpNi6tuRsc+n6fBZH6YquUglp9Kexm8fM90VkMjYg5qlDI1Nuv9moM+aZJvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>




>> > Reviewed-by: Andrew Morton <akpm@linux-foundation=2Eorg>
>>=20
>> Hmm, did Andrew actually give this R-b tag out? I can't find it on-list=
=2E=20
>
>I don't think so=2E  Hallucination ;)
>
>I do sometimes sneak in an offlist R-b when I'm looking at things but
>I'm pretty inconsistent and lazy about it=2E

I saw the tag on the mm-new git [1] and I wasn't completely sure if it sho=
uld be included in the next patch=2E Sorry about that=2E

As a general rule, offlist tags should never be copied?

[1] https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/akpm/25-new=2Egit/=
tree/patches/mm-khugepaged-replace-mutex_lock-mutex_unlock-usage-with-guard=
-macro=2Epatch

