Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C18D5B16E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 00:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4774C6B0006; Sun, 14 Dec 2025 19:53:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 428256B0007; Sun, 14 Dec 2025 19:53:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3162F6B0008; Sun, 14 Dec 2025 19:53:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 206746B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 19:53:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E674EBE188
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 00:53:26 +0000 (UTC)
X-FDA: 84219882012.24.B4FBFD1
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 060DA1C000C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 00:53:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XhsVXHkP;
	spf=pass (imf18.hostedemail.com: domain of seakeel@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=seakeel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765760005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F9g3zA8+/SS364XH9Hr1y/D4AwnbgxagYZf00bypWxY=;
	b=CGbUVQz0XDR9FDmjBF0AKUwZEh4I5J3uNulK27oJWh9c+RoWh5llakac5uky8sXhC6llGz
	auDQjlWh9++9B445I0UOtjBdfR7eX5cxBKO9/STMvKo65vVWuPJx4h9+zmlpA+2guXgbcj
	lSQz7dNbcZKspGSy7nkUPxbVa5fHW3I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XhsVXHkP;
	spf=pass (imf18.hostedemail.com: domain of seakeel@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=seakeel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765760005; a=rsa-sha256;
	cv=none;
	b=NcETw1YaDlcCFO0S/KpiNAaNz1x+uPmOaSR0NKX5fYIvtXl0SqT0VlADzFAugPCquKF8y1
	idwLIEZww7pH2cZa/8WiqKgqtcG1iFdHSXuOZ9YzlnkT/07dM4LNC/tgB3TAafxw/2AZ6Z
	HhdU/uiHH4EKVL6MOOz8V7Bq6T5JPIQ=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-78c8d74bf4cso22822037b3.1
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 16:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765760004; x=1766364804; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F9g3zA8+/SS364XH9Hr1y/D4AwnbgxagYZf00bypWxY=;
        b=XhsVXHkPTAZtxyW7UXw4aIKhDBcVlurWizF6/3WopSa+0C06Mya7+kl6dxbmF41gg6
         6GuzqIOXfwrU7TyEAnxG1r9+Xu/nV2BMam0w/TXjZV/ORl79WRQid8KLf3Bw7R2Pzl29
         lO2oB/oIJa4pMVYR5UETQPvTSvhMPzarw3fQp3FH3xhzknn18jDjAV3cAzk+B7OHB7g7
         sBYqZhaVxBBe6M0qFTlao7Cnx0Tu8zAU8lEMrslCXTSJ3sRQcZG4WrL/1QdLVCiIy0NU
         DEkbkuaXxrp052pUZPV3KqYVGFRUadz49NYPDkdlcvQ6Gixe+dxdLeKIaK1LPZhp6rq9
         Gryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765760004; x=1766364804;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F9g3zA8+/SS364XH9Hr1y/D4AwnbgxagYZf00bypWxY=;
        b=v7GC035jvbtN5Rtmzj/JU1BPyxAeIy1IoS25qczrs3VehBQ2bGQGad6GaWic5v+obm
         Xdvx4Di3t3mkxJEP2ulUAJr26Ze/Th5q6UdfZdyB0p3ObvBflVWs97jnvsCB/SuaAlCK
         fKuCjPtTD9TJcyTFuE8Hh23vNiYcA4enZtnN8kbnJe9ia1lXDdThpt9TEcGnihIQENpj
         yNlWjlv6hwTiljUYozK4zghyAOf1ihaXopEXXfMgAYDf4evcvqe0IuL7smIRmB3Xi6ym
         aUGeGO+h5lfrUyOM5tcZ9Kpi9WxIbxAhupB+cKh6ao9yra7KLWZjuCOUGMju4tBD9Eo7
         6o9g==
X-Forwarded-Encrypted: i=1; AJvYcCVNDxZZoF5kMtSycHQt+aQOfQ4A+aMEYn1wa+7DEbBmC4/GPhVar4Sa4fG1qFDr47ZJE2Usj6PRQA==@kvack.org
X-Gm-Message-State: AOJu0YyhDKLTJwX11vrhxlptJNmVPLNz8mjWh+8/kwyy4+A2Cjs6Hsua
	GXZw1rnDzW8pyf68pyAW0UXxdUwk0e+6xkFaQOS6ILJUtSg60I/8kYck
X-Gm-Gg: AY/fxX5GzXAvqlnJv1smt7MoOCoYgFGDrax7hR6QtWUVagKd95zwasMbXsO2cMGJSFR
	4bHDchaI+wdlKYJHVcdsDtFzFk+urN0GyGmrYWoqKm3Yhmj7ZnfWxeXGEq3zqOw6Nr9T/q4skt2
	OsKKK6faQmPGx4tg7zJ8kJ32HMS/3eeiMMedsaNIsx5fColffQYmiDY6J82mLUj9UnJuh4F7Js/
	5zaV56fj5MfVZCdPfUITaRKIiAVYMgalLQ/nGZ+I+BhJstSkLBXDGel2Ka1krinNZmGUXbguieS
	ki9z4gztLmU3wFFCX/Ex/EcJKz7KGyqrsg17DBTG8ZjeESH7W5njGoGa1UYsl8zdxvlxmhA9nDj
	KqIAJP0A+eolWM0a4hfZaDTSTh9Y2TXRsPYwsAAql23xNxoAmXtetAejNQdmDaT+uZPGFu10oN4
	qltIza32y2sqA/hYVBHO4n1w/q6CDm1jswLknbjw==
X-Google-Smtp-Source: AGHT+IGymE1URbEHDhw5BX1nzGOTECoWjlfm2zsVFVoPWPkTZrOWD3CnCtM5DT/uUKOVkJdBDZchkQ==
X-Received: by 2002:a05:690e:b8f:b0:641:f5bc:6950 with SMTP id 956f58d0204a3-6455567e9admr7325417d50.84.1765760003993;
        Sun, 14 Dec 2025 16:53:23 -0800 (PST)
Received: from [192.168.2.226] (104.194.78.75.16clouds.com. [104.194.78.75])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64477db6599sm5753649d50.21.2025.12.14.16.53.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Dec 2025 16:53:23 -0800 (PST)
Message-ID: <52e2c1eb-67cf-41ee-9088-760fb6258153@gmail.com>
Date: Mon, 15 Dec 2025 08:53:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm/pgtable: use ptdesc for pmd_huge_pte
To: alexs@kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Thomas Huth <thuth@redhat.com>,
 Will Deacon <will@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Magnus Lindholm <linmag7@gmail.com>, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, linux-mm@kvack.org
References: <20251214065546.156209-1-alexs@kernel.org>
Content-Language: en-US
From: Alex Shi <seakeel@gmail.com>
In-Reply-To: <20251214065546.156209-1-alexs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ynn8ckzawfc338foeyxmuspjnsq6oy9z
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 060DA1C000C
X-HE-Tag: 1765760004-949753
X-HE-Meta: U2FsdGVkX181G/Gd+Hc/wdcnrg5KaMMXFMUu/4SzeP2veWPtIQkSByPvClTGXrOLpfAboNbRdWOGLjAJU17e/vqqaQvCdyp08sPMpfFTXP49haUCH6VjacgtmpMxwW4nxwl9f+PFqy4OqyXxPnZ7VpeH2sOjtMAqF1nnUnQtg64TRI6BlQKJdRurBmf3NznezQN7no84OcScfEs/cFuCWlCKZYL1oa6+OJWXaKaSQPU7S/H0cbGJqJmxqTfEmFkVhKf9spyrC3ll4i8vT/Opd6IzJ1W1VuQhjZ6NUVH3y5h4IXtZWjg6sIRdEOrrjFK0I/xv+EMyANwz7Nd6KiLVbX1Uw9cx9NmITSSxn98tfHaHQ+EoHYRJ1tqVKCJfD3ynQWNOaB2tjI2prrRqksdYkeDaIB86KJfNgCUuU0ZYU1h49uLk2WeYT0X+A1Svdh5hMJSpxpq0jD+quiU3y25iqmjTSXb2o6sqP/eauaOyZWz1nWIsgaz4a9y4gNjVEKpSs45moROy5F2B+b0Y76vNDZIKJH4baBJdoMVBD8ZwRi3rObh7NhwxVurm4I/nET7WH53VdzObm5cMDOJDSBwMYcgwqzmfPqZZ6iZEhOIYl4SJCW5I6JDTENE1Hhke+Q6uvnLyRnQvZSE98KYtXbNfzA1G9xJ9wNsisXisSYanTUxeSbKl90C9ennOmD+YFxmXfsP7gubHS7KxZs+CU4e0fgD9IWN3q47tMEgqfa78Mde16WJ8vfqJULiY78uXh4dflJNKkVVJ7mLMq+wKTRzxh5BAE0nUCFNssJsKo1I9jbfdAULCL1hmIHBYm1IcRYCXBBnI8vnRvR6h0ceiTa+pl30CM7kLqHSx42cQoNFVHkAiLUH6hg4pREl3o4m7yYcTWl/wWIuKrVJUgcKI50Y+hxO7wLaDD9EfJvfLdVmOiKxVzn19kJlWSbs7NWnuBpB7sPWhFhC44Paq9VHWhFJ
 H4XBfEO1
 GO3GpkAy9lW2lQ+pvITgCeNcYhK/3fVUo/gXtjyY1p1IBjPsuotl4kxGcNiOjqhlrPKlNQ9Y4dTw1scLSiRLaEk9mnxS8JZMNO5C3sOqWFPaaR6Hk4DuTjh04LmAPAyLt2TE1bifM1RC3jASjgdmLcHQS4Fy+bahoLbbu2JJJ0OxBC3mJuu8N3gRTU4G8V4qqZawGfOorHuul9aOqF8jrqwLoGaWDEdxOKutcCYymc0Q282nGbXLuzqatD2aNErTg5aXPxcP7KGXJwk/ZgEl9nwSEJxqBI/Z4SvECIzmuXqu9Ox/PFQY5A3hfse5Ts+1bghxwVobcVNNPkdVAzcjayO/dbMcMGbsPt0/B19GHvnGvsByfHAXhTjt1m8CJ8Ljuj0KtQx1SnUM9PUfMEUTL3Y1zhuOu+WqLb+RjroRO/f/vNYgXyRHtAEXHv4y6z8pTIKHwlb470iYm6CX+rdIILyyeylFoRVseyh/qd7DNJH/DI0F06K+vgTzP6eYbcvUHYlsSgeK2u23GuneLpsnC4v5B0VLQSpwUXa3FLKWlku7YHq9/uiZHhv51sd75TmqEoZvM0yeHX126Mfs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/14 14:55, alexs@kernel.org wrote:
> From: Alex Shi<alexs@kernel.org>
> 
> 'pmd_huge_pte' are pgtable variables, but used 'pgtable->lru'
> instead of pgtable->pt_list in pgtable_trans_huge_deposit/withdraw
> functions, That's a bit weird.
> 
> So let's convert the pgtable_t to precise 'struct ptdesc *' for
> ptdesc->pmd_huge_pte, and mm->pmd_huge_pte, then convert function
> pgtable_trans_huge_deposit() to use correct ptdesc.
> 
> This convertion works for most of arch, but failed on s390/sparc/powerpc
> since they use 'pte_t *' as pgtable_t. Is there any suggestion for these
> archs? If we could have a solution, we may remove the pgtable_t for other
> archs.

If s390/sparc/powerpc can't align pgtable_t with others, we have to keep 
the pgtable_t to bridge different types. But we could take step to 
change pgtable_t as 'struct ptdesc *' in other archs. That could 
simplify and clarify related code too, isn't it?

