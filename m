Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CB3BCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953666B034B; Mon,  1 Jun 2026 08:02:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92B236B034D; Mon,  1 Jun 2026 08:02:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 841BE6B034E; Mon,  1 Jun 2026 08:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70F0C6B034B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:02:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 12BDD1A061E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:02:59 +0000 (UTC)
X-FDA: 84831207678.24.D041C88
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id AB85F80003
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:02:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VevA4449;
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780315376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/Dmnjx8evCUVN9l8RKJhflaCWiIEgpPUvqXkCQtCRk=;
	b=ZbNMl6pRShMP02dUWrAAk5Jzi11hkCorX2P5Aeguw6KsRrhz0rzewSxTaLygN4TNAve3q8
	qHAxf/Zd2lIlBcoWIdwFNn4E1vk3ukmtc3yvluywGCN8t66ed370pdt+Pn8wh/5JUIqdsp
	e8Ul2gw6/Ze2VwAsLQ0573X34qQWlxg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VevA4449;
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780315376; a=rsa-sha256;
	cv=none;
	b=INtJFlZNXF+KmnjqKMw12m/2uxBmgij1I4Bv7gk/+w3yq3XrxfUHYNXbSGp6asy6vS0xJM
	bhBTzs3AzNBZmMdh386VVjon1Oc3gvu8otBXA2CVAGkW+T7aJlAdgs8xEnT1EiwWdPokEl
	33a9A1UwcMK3kJWvefCFHQvQEAcLQEk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780315376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1/Dmnjx8evCUVN9l8RKJhflaCWiIEgpPUvqXkCQtCRk=;
	b=VevA4449P+0+8gMi8oMXwHDHaDRjQlXLY1KXCv/PG42MnbgMlMUkuoARGpMPvenQ8w5V3M
	hMTIMEwxy4zq67j/eadQOwGrFJVw0RFXdaaIN3f5FeYOV7v3ZyhjcLuCU/x+nsjsNACT7s
	LD+tzNKU9nt7J7gbblu3Lk6DEn8XcAk=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-ODw3VPx6P7iJj6iB8X75QQ-1; Mon, 01 Jun 2026 08:02:55 -0400
X-MC-Unique: ODw3VPx6P7iJj6iB8X75QQ-1
X-Mimecast-MFC-AGG-ID: ODw3VPx6P7iJj6iB8X75QQ_1780315374
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-66034c1b31cso5649672d50.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 05:02:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780315374; x=1780920174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1/Dmnjx8evCUVN9l8RKJhflaCWiIEgpPUvqXkCQtCRk=;
        b=Pg4LIV4zwM06pK1TqoJOzUTE5MNlZRbiDL/3ZgeJpl9OJ9Euo5+mq7XNIHeKMwdloh
         oBxyq9FifxeI0CIFKMhGItMGYQ7vLVwuKlY550BF6EhdlIT47WXSM7ItXCpWUAvkmTYv
         ur8uOeYqPwoY9WJdJVV1VanpC8LTcpV2O6MrrbQy3+ycjMPRRziLWOeK217Wi9zbjbr1
         s7zt/E42nAyyxW4GUd52rgYbKwQ7gCjt/9/brk+WahlQISVVATZ3wddi+T823I/CMn59
         efmL7rOPzrl0Qlmeu6qsKO1msoVgvxv7NGYkCmkYa+ly0Fz0Ah1rm5aSAT0Au8J1Okw8
         ctbQ==
X-Forwarded-Encrypted: i=1; AFNElJ+clPF+9hMEsItpqCcDjz4vf29Fx07dat3PDvrFtUPncqqSaauAza/dX0dVY+AMv5bJ+nBnDUk0Fw==@kvack.org
X-Gm-Message-State: AOJu0YzrZa34rt32XNjhvE0dt992ll3MB2aP6EGDhXoKKXhoYkVCdPDK
	DYAoNveHPiBg7dut4pMgIaaVmazpLuxdNsVYMin136srwtzHAJCortUHg0JkdA7pj108EbCEy68
	7Kf9Lx9tfMIqKgtfEiBRB2OSlqohnPTqsA+nHQe7avtdJ3XEEXDttxSsWNxlye1B0/OsCcl8wNW
	NoB/Qtgi6Efh4PMtEx+hYYI0zH6+c=
X-Gm-Gg: Acq92OFs95zX1rPRFGNHDYc/zy98AeThRKdLRy2tNvfcO255QvI7YLx9+lJJiGG5mTX
	V4HbCqn0ECb8PtZVu+USVJeHjccg5C84RlUv7xKtHriRPZhiRs4vSqrTKG+yzQsVn3gFjmaNUFG
	H20dgjZ1H7qz8QX88p+kKDzFaRHo1z2JW1ohnifmT/qRKKbH3eP4xi2QpcYOCk5Iv0hRA6VynHu
	qEa0/BgT9WYMdIQYQ==
X-Received: by 2002:a05:690e:1916:b0:660:4886:922c with SMTP id 956f58d0204a3-6605ef3d9ddmr8301976d50.17.1780315306072;
        Mon, 01 Jun 2026 05:01:46 -0700 (PDT)
X-Received: by 2002:a05:690e:1916:b0:660:4886:922c with SMTP id
 956f58d0204a3-6605ef3d9ddmr8297124d50.17.1780315266993; Mon, 01 Jun 2026
 05:01:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260522150009.121603-12-npache@redhat.com> <20260531071845.10875-1-lance.yang@linux.dev>
 <6a9f062c-8376-4f83-90a9-8b167f925dc6@linux.dev>
In-Reply-To: <6a9f062c-8376-4f83-90a9-8b167f925dc6@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Mon, 1 Jun 2026 06:01:46 -0600
X-Gm-Features: AVHnY4Ifoce-ym9rt4H7XGBtAQemIZHZ2nK_-zOeAzqon_03N1y6C3UXAt3eth4
Message-ID: <CAA1CXcCfww9X-f2Vb=ipz8tY2nMNnMx5_58Ozz63tvZTz_wpOw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: Lance Yang <lance.yang@linux.dev>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, liam@infradead.org, ljs@kernel.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: srOwC0OY332hDWvC8YLoU9p3qx79SMRs0CNZ2r6nLrc_1780315374
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AB85F80003
X-Stat-Signature: x7brcjz3g1tt3bkgs4uc1fimhgyiiw7b
X-HE-Tag: 1780315376-756281
X-HE-Meta: U2FsdGVkX1/D8OAPwsYl1PQsaWRFceC86MIGQr4OrhrGS2U4xS3cN0YrEMBt+UQE0wvnyimEMaESs2tJ83DXy2d9RBswEgKqpQvuoFmJjXRJiwLqFKkzSniz+1vwD/MgerilwN5pQA4JaljlBOl93tSRw5v8WCZ0KTjFEFWA6+9tC3AHWh3uQUKLD2jHsNFqEtEn0ndmHWKJbaZbvBjoFAEiSzXddjRk/eULOvRFrLA0i8pUh6JCDTnCkKlKYHNQYLSf5jIQ9eFi3W5N40b4631Kfh8InE6/A12VM13TMrpbQ1UEd9Bm5RZVTfkrc5ZNP+bWE4+9l6IN98wg8HWkAkBFW4SS2fLQ6sdbhQlhIHMAiUV7Rg1TrrVg27yhO5hj8eklMfrX8rJSRyPvdhi6UP0pETcNbZOOssG+6TOQ/x2Qr3gvHtJ8QBHL4Z/pSbPQ54MNQScomurxCs42bDM2Nltp9WQYxHVLxsYhLzhOyKuG7f3dh7CmRdD4+0tUEOF2KHqiVXoDxW/6PQk9jGCs/h5i7MjwY8Foae9Q0Fqsfb0pB5oAdxhWGSs6j/1OSXY8kMQYHIfq1s0dM+mD6VJCKqTln/5/Z8Acgmhv/dxJOmUoA7xVL6RyIv6vObegJ1bldEM6BhoWlrj76roSgx4PI/AYG0Up43hp86JXrWiGQljL2Q6tufiuqMnrywvB9KivPIRGeXauIpJIDob7KvYoTN9pzTa0o5J1e8UKLxbZ/TlnBL/n08MWj824/uUVwt0P7qTKWrv4kb1OEvbw7d2dMdKVAmyLtvslYmDfG0yOoOQvliBMCRE1LG3jsczhid/bsTyygkVdeVPvEDck+sEySiCtySFezeNFBLieERq14ie7cqDzK0UDmIm0kSl7DBM6tu5LRaOavBFVcEsXKzgtmW8fo9c4KxjSnZRy6u3e8IosBcQpGqPTvtO9X4Iq4QDN8g2NMztwEVpuI9oNYCk
 GtZCpTRx
 c9Zgq+YtagNir1V6E93QkwrrnTqIaYcA68OKxaHCZDhnFIOs74TUSIWU7D8mxjnGanFNvhd2UGs03+zc0C/oUZs4rRVTlJ8YqKVlgy4v4xpfoWqry8GopWZ5Vo/M4EHWOm/uHdN6vcwwTAhBypqr1Zfcu07uQrsfluWx2ykjtvU7sbY5YC9azhhymwAgbt73hwOCNP32vm/wGv+bZOltoND/It6ZgUj0445QFI03/JfVV4Z1LYyrurOOw4tQUN5ZnFnnFgFZfm7G+KQdJEjm2NcOV+RBEReqCX+HTSw1m+7gpjjIbXbBSfeZBfCAMKpJRp5CmUx9+xDTotRKqovawQSZwI6FPV+rw09Z87okl7oS/Ll3o6MMYu9pBig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 31, 2026 at 2:48=E2=80=AFAM Lance Yang <lance.yang@linux.dev> w=
rote:
>
>
>
> On 2026/5/31 15:18, Lance Yang wrote:
> >
> > On Fri, May 22, 2026 at 09:00:06AM -0600, Nico Pache wrote:
> > [...]
> >> @@ -1587,10 +1749,11 @@ static enum scan_result collapse_scan_pmd(stru=
ct mm_struct *mm,
> >>      if (result =3D=3D SCAN_SUCCEED) {
> >>              /* collapse_huge_page expects the lock to be dropped befo=
re calling */
> >>              mmap_read_unlock(mm);
> >> -            result =3D collapse_huge_page(mm, start_addr, referenced,
> >> -                                        unmapped, cc, HPAGE_PMD_ORDER=
);
> >> -            /* collapse_huge_page will return with the mmap_lock rele=
ased */
> >> +            nr_collapsed =3D mthp_collapse(mm, vma, start_addr, refer=
enced,
> >> +                                         unmapped, cc, enabled_orders=
);
> >> +            /* mmap_lock was released above, set lock_dropped */
> >>              *lock_dropped =3D true;
> >> +            result =3D nr_collapsed ? SCAN_SUCCEED : SCAN_FAIL;
> >
> > Hmm ... don't we lose the allocation-failure result here?
> >
> > Previously collapse_scan_pmd() propagated SCAN_ALLOC_HUGE_PAGE_FAIL fro=
m
> > collapse_huge_page(), so khugepaged would call khugepaged_alloc_sleep()
> > in khugepaged_do_scan().
> >
> > Now if allocation fails and nr_collapsed stays 0, we just return
> > SCAN_FAIL. So we won't back off via khugepaged_alloc_sleep() anymore?
>
> Looks like this is a more general issue with mthp_collapse() only
> returning nr_collapsed.
>
> For example, SCAN_PMD_MAPPED used to be propagated too, and
> madvise_collapse() treats that as success. With the new code, if
> nothing was collapsed by this call, that can also become SCAN_FAIL ...
>
> So I think we should keep both.

Yeah I thought about this before, but more regarding the "incorrect"
propagation of errors; I didn't consider that those results were
actually being considered.

I actually had a patch to track the last_failure (with some
prioritization on certain results). I think that would solve this
issue.

Thanks for reminding me to improve this.

Depending on how the rest of the reviews go, I can either send up a
follow up series to do some more cleanups and improvements of the
current approach or we can send out a v19.

Cheers,
-- Nico

>
> Cheers, Lance
>


