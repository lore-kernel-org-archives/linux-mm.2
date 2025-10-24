Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44767CCD193
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 00:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A34D48E0021; Thu, 23 Oct 2025 20:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C028E0002; Thu, 23 Oct 2025 20:47:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FB278E0021; Thu, 23 Oct 2025 20:47:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9588E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:47:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33BEDBE0C2
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 00:47:23 +0000 (UTC)
X-FDA: 84031169166.25.6AED591
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5673D40003
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 00:47:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=InmmNr9b;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761266841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dekchQfMYsPgwmIHu1U8iRd6IWXI+KU+TikQrx5aks=;
	b=uI4LUttfy8tJ/lrhSnhpCcLv+AQGNJVqqVG9Ni58aFHt+ayNJEW7Y78Z419kKcATFpqvln
	qtEf/8zCb/Mebgwu8pmpKNRq//eBXRo3wuQXmo+aPAGTmhk6PbTIhft9oGZmFKeiBDJaL0
	ugOYWDxvCyCPxtmQDjhfSMGPZLzV9ZM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761266841; a=rsa-sha256;
	cv=none;
	b=N28zXDIVHBC5pEvFDYj8M88riig8lwlyCakNk0/3G15uQoI+8hm2zzr0mEB4lTdUmKiXh7
	XcnNJZ37yMRv4LAaWw2uKnB++y+QTMTA2xfPfPR5P+v6uIRh8Hhr603s049QMxS04SusYf
	dGAQESpe0e0LmQPQyiN0cNjnEmvdy0s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=InmmNr9b;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7f04816589bso159510585a.3
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761266840; x=1761871640; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8dekchQfMYsPgwmIHu1U8iRd6IWXI+KU+TikQrx5aks=;
        b=InmmNr9bAS7NYMGVuvTIaB1YdQe1/bUApc/9ANRYd9UkKQJsgZK+W2HiKahEMrhGDU
         Ebq/dLEYG+UksOoOF63Vz9BDmGmEm42nGveh893eqHLR6r181pumKSfeLSV8MDHdSjhC
         ZrSGViM6wHI/YpYNwOwBBz6RmU029fWZjH7gx/lMh9c5Qc6hf5yFinSyh6a7tXQ6bzAh
         X3Fty4mGS0mIRKZQfg9qOrCuUyypGyRQqbTWSvR6vN4TJyoQT9Aby/TzvLBU7YtziVNt
         veCCJMFSowLdTC150PVueB4aS2E1Z75SJxWKiBzG0OGH5xqlAtHJjJGpNeD/fjAhqlNF
         fA0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761266840; x=1761871640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8dekchQfMYsPgwmIHu1U8iRd6IWXI+KU+TikQrx5aks=;
        b=Jv9XjYK+S24xTG28lTPcIe80UfLr9Un4XYxZbBX82efOM6GxUDxVEMDfsDk2NvzIwj
         PMMKsS1v/Jittn+2nHbaYyqCGwoUD/Tn3ga0vMXmp2qFUcasvDBchMzwr3aCXpQZRaDc
         6BLW+a3wnV4w0s4njeuCizXalDgSfm++r3ZtRnRSUeYz4JWijhmO+NTqSjhFZcNCwhuz
         hm74g/xAb6E/7h7X1VrdxDyDcMBN9doGVZTfxeI4+ZkVnHjauetzsNgJe33wefGuxqUI
         4DaI4eru1NSt8XQ1JrGJyC/n6apz5mQOCFoICbkRKPQ7VuZD/jx0j9furPTQ7ebk8bFp
         CbXg==
X-Forwarded-Encrypted: i=1; AJvYcCXy89vbmKYVshTAU5IS8yP/lgIeW3j9EAXT5BQJKT7kIbVzJetTCTBfmMkgEA4KhZ2w89dkDHXl8A==@kvack.org
X-Gm-Message-State: AOJu0YxE+Ml0KiD/sl3NgP9JIoC/ane1f20yCPlD7ygmFPv8NzGvjDsT
	1WhKRY9XCYwBMFEM+sYXmlFWH6cVS0fyreAT0sVszKIACCR32ZTN0v6YEf8MDhjzzclVsA1ZKsy
	SBg/7zZ6pkNudW3o9BXdll4txbeq10Ec=
X-Gm-Gg: ASbGncsjPltM9qxXbLalN0Zwt7HTZ1gEmuR1mHWctjBXSqjmCTns4zdr4DBo6nt4clk
	0cYJI0KfU7wrfLO5L0ngcGNIU6oBwJs622QoV3s1UdtmkTnJyN+v1MnWxPOzX5BfyOxFa4d7en3
	kaPWAHvB+1G/92NZZWNF0cI8oADhfgbWeHmOe8op2/qqB3HUXFlUSV7c6yElV0e3hQzIrG1p6JH
	ImMyd2cjVu8p+9SsoJEYBWIYuPo+e6s+nCnzAhYj+w7e5KfJmlXonA+mbtuHoVcLf/xUcjagcJp
	kzgMO/fwT4HEJSwaXfe4GYBgxBg=
X-Google-Smtp-Source: AGHT+IGokajvF01sX9F7KXkvDGH2BAi4A0xlPGkcF5m+/FFCBakkYwkQlnjuvwYu0COErqKt6mUfvQXhm2R9aA7CSo0=
X-Received: by 2002:a05:620a:4510:b0:892:624f:7f74 with SMTP id
 af79cd13be357-892624f836fmr2622571385a.28.1761266840350; Thu, 23 Oct 2025
 17:47:20 -0700 (PDT)
MIME-Version: 1.0
References: <20251023065913.36925-1-ryncsn@gmail.com> <774c443f-f12f-4d4f-93b1-8913734b62b2@redhat.com>
 <f0715f2c-ee27-4e13-84d0-5df156410527@redhat.com> <CAMgjq7Chg6e_xL4wxYJqMzmCRENawQ63KSABrZ9zVbR4ET=YFA@mail.gmail.com>
In-Reply-To: <CAMgjq7Chg6e_xL4wxYJqMzmCRENawQ63KSABrZ9zVbR4ET=YFA@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 24 Oct 2025 08:47:08 +0800
X-Gm-Features: AS18NWCj9MGFG1npl-3BLgwz1S4LiopMlEcRzQLs-xgJmd9nWQbr_QcVvyIi32Q
Message-ID: <CAGsJ_4wQ_9xTHxbRsipir7aiEdjeUNnYO5Xy67tRcFTQxfpZhQ@mail.gmail.com>
Subject: Re: [PATCH v3] mm/shmem: fix THP allocation and fallback loop
To: Kairui Song <ryncsn@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	Dev Jain <dev.jain@arm.com>, Liam Howlett <liam.howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mariano Pache <npache@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: cy64iyi8kmhodh4rth6qywrnaiudkkdk
X-Rspam-User: 
X-Rspamd-Queue-Id: 5673D40003
X-HE-Tag: 1761266841-581911
X-HE-Meta: U2FsdGVkX18esNyM7nkzZIsTH9M2iBEGR5/dmDS1vn8EKdxHNYSNubSWj6PdEoUYich1SaCPztuQEYA7Z5g4XcnJt6PpsM4CfM6oTGkINYhhl1Qmgnz8hKCqtTzqDribzcp8ms4wDoTkx3nlVVG5eFGlENGZ8CKDLUaOUl5wDl7XEHxHltldQ4M+rgOVNKXMQLcTR37kcyEhGZTE2Folo69HM4P4kZlgpO+h4ElSBfK6RFDiQVSs7iVh4VBB8oxILdBrgF5TM3EvzumaGEwLRRBfIlvSPPQ/22NnNLWCCk1Ue+DRnMDPsWOY5eMe1ZI7ZHV3P0ybLKqD9lAgzoP9ILc9NodOELXGmMQcx8rIYe4JiuCI8oR8OqfB/GCOWIWAvgCDPdK1yABNgZ0F93eVisVvZf0qYBzAsu9UoKEguVvq7X0Hixaq936fAvrBgZdhlXK8RQ+RepSi/BCLjsNkI26eL4cmycCLJOSmUAOJqSfmA91pMQjUUHZwc90udCzqlNQMBdo3v9IrHsxwkMgDD2VKQALsrIysgYaA1IsTwhzMzbQcyCDUAdU3a/zW9+MYOT4hQGxs84dH6m64yG8HZlsQcC4Z5P3gvsa+mYInUxUHDuE7gCaI4bBPJpfHh/dPWoj6vM9U2lsyxOGFb8g4Nbu4v7zv4HCSQhQlMXZVGnC75/3CXxW2I6XrU1EbYcgp/1bLmAWQljjvljAu7iZDu49j46wU/5CovsDkRo0Np3oSsWI3ctBjT5y+s3sdzwYYxNK1LFBA00jYSmFwZRQI/sco5L7b3zNpq0LJF03t+uX7ZPyFtRUCAeXndBHP54n1kveokDH6OO6cluoXn6wJ/XmtxVSzHwnwp0b0BNePFS2zwxVfGQZ5aNe9zsuCgxqbi+0NIVxcCo5bpqWzIdvxVRqmD5L8OEOXqFiZdLfSMAT+tcAoKOkbI8FH+2mSwdwRvKX2FKOnqn+pfuSQDwI
 pCXCIRYf
 aqoQSwkDuSJglBEMDPp10xHlmRguDsmNGKDzUXXpuwmlhr1H7amIiORs+mFqHcD0fpC8+Wn3lIasFBCFPnLvfQJ8Dcr09Jc2k7+pMQYsy2E55y8dM5AuO1FyYOE5W/W72owEE1AjWhPA5Lldnp8yKp4DUTAKb08xdzUKYLytLMJ0T2sa8nS+cvY6PxLcO1Q1GA5Em9zaMzKH+u47xYeSqyEr9oua0HFvl61Wp1Amhv0KJH/zj8vAOJS4Di6lLM8OxY/MnBLEClX9RfB0HBH+iTN1fp+ogni7iDKMiW3490T7Q3s5995DwxXJVkGWCx/t+JM1hV/hDPP04v2D/trRlSyO7xWFEyizEj4AIzKj22AeTBYdlZySF/fMBTDeO10uSj3xp57Azd+R+18fKbGikCes0EA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >
> > Answering my own question, the "Link:" above should be
> >
> > Closes:
> > https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgo=
ttedy0S6YYeUw@mail.gmail.com/
> >
>
> Thanks for the review. It's reported by and fixed by me, so I didn't
> include an extra Report-By & Closes, I thought that's kind of
> redundant. Do we need that? Maybe Andrew can help add it :) ?

I also think it=E2=80=99s better to use =E2=80=9CCloses:=E2=80=9D. In that =
case, we might need
to slightly
adjust the commit log to remove "[1]" here.

" This may result in inserting and returning a folio of the wrong index
 and cause data corruption with some userspace workloads [1]."

With that,
Reviewed-by: Barry Song <baohua@kernel.org>

Thanks
Barry

