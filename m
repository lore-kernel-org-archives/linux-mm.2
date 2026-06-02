Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 967D2CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33DC6B03D7; Tue,  2 Jun 2026 06:58:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B3E6B03D8; Tue,  2 Jun 2026 06:58:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B21B96B03DA; Tue,  2 Jun 2026 06:58:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A25746B03D7
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:58:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3BAD740642
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:58:12 +0000 (UTC)
X-FDA: 84834673224.07.93776D2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id AE6D480008
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:58:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W+uq8hrC;
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780397890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzLj+P+CIxVIK1VlPvMvdq94QC/E8hMOQaV32XaaoGc=;
	b=zG3rO4D15aMi4Jh1zLLgvVNgAIL7JquvPAHO70nf6i8rwhC4nH5CsNiFWFW4VSlzrUPD/F
	iJ+A+I54hRwohMVIQEe4cp2aHpy1nV+pZlf3VCbz+mBO8s7ntu5kccqEPbvg0aeCl9hEsG
	PUZlZUtF6d3QzkJx+GaNU2QvHASkCkQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W+uq8hrC;
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780397890;
	b=QNhtWTZFW/2UPMaem0j2fTr7ORet97SNJ+h/kuXPyLKtYnVYSSUUG7oqUNn1rUnG4qZMt1
	q+wuO+zpx0w8/y+g+kH4lU6GKI7iFj83fRlNh7jDmC958sP+fKcnIbT9YKEzJU48WZgXQ5
	8gqKxFqMjVppI3B/znK+uOvwo7vX8AQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780397889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lzLj+P+CIxVIK1VlPvMvdq94QC/E8hMOQaV32XaaoGc=;
	b=W+uq8hrCIiZeSY5aG0+UkAh67C6CKkCXFSs1YTHS1MSMDQyrRbf9mecfXgveFI0f+AauAk
	/w+2wL8Gn9F8tLnToUTzqprr27JnLrEQp+DLI/0EUReqW8oK80Nngg0xh0b1C8JYDVd2Bw
	sLdjUEU+RmWPR1R8kSZfHbzB/WofkCE=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-19-GgE_T41eOquomRgsoxDPTg-1; Tue, 02 Jun 2026 06:58:07 -0400
X-MC-Unique: GgE_T41eOquomRgsoxDPTg-1
X-Mimecast-MFC-AGG-ID: GgE_T41eOquomRgsoxDPTg_1780397887
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-6605694a059so5357886d50.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780397887; x=1781002687;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lzLj+P+CIxVIK1VlPvMvdq94QC/E8hMOQaV32XaaoGc=;
        b=jxeBvfxpi2THpWdI8aTqt7XVNVBVcZSBqzO3k97gc35bpzkfiUcKW0kcC8rH9cvwog
         M+hrBZXSxPVtFSTiv1Z9SkuW2i5hoK0FJn9LigidNWMlp9bCAr9zvLCc9zL7prSK3+ov
         Z/Ed1UQABanKg0NRqus3cLxT+Pcuc68PEPSKO8pUvEMAtGejqjj+g9hXHOBzp6iu1Kfv
         ZRUMgArEJz4yMpb62GEGGxUOnqHj3ZHTBpr+khnI51LERR3b/EXyp9K4cEdN8K3OZnwi
         w4czt0SLCxdso9WzFFBPWvY4bKsh67g6wSlSiz4YvmMEhWFtoYQ1MWNhIa4o9Mb3XDM7
         eS6Q==
X-Forwarded-Encrypted: i=1; AFNElJ+/dZ71BLiApttE1MKq8D79g0NwWDiMKFVifO/p9tMC1G77XwP5VExDEPYXKuIc45zMBLhA/n4NiQ==@kvack.org
X-Gm-Message-State: AOJu0YyCz59fR+3qZ5QBPwAwm1raa/kpBhsLPKRrx8U2x8LKipHBInSs
	D5D4OFAr+51JQ7u75pXiXs5bNlGCIlLZVzRfeuwpMDOFTxYqE08kU/KkvL5q33R8kod4zAoEgsu
	PzxZ1EkPrXYiy8ZxRQJjLJIbuBvG+hIoSNO8XZVUelaw8nRFETgq1w9q3SkfYs1L8w5sJbvNlLQ
	yBnq7eoUdMMuJXOGrQ344VOlhGADXt84B+s/4ca+Pn
X-Gm-Gg: Acq92OEHDM4ddGgWZCDlGxrJZF43iZJfQCVx7rMZYMhxDl07rQN+ueVVlolV4TSmYw+
	DoYBb4ScKKU/ihm+ICRsrD005iSre0BpU6Lo5oxXtnUilSpVvRI7qirflTnCFnYhP+jUHhC0LkB
	V+dTq6uWNZl9dep1x1nbePGOs8ZYkb5p7iZhlWFFvlCVQdxs12z1UD1dIjXLXLYLNneHMbqUN0B
	EVryeQ6MNM/EwyaAw==
X-Received: by 2002:a05:690e:4084:b0:660:8253:b836 with SMTP id 956f58d0204a3-6608253ca8bmr7541737d50.5.1780397887247;
        Tue, 02 Jun 2026 03:58:07 -0700 (PDT)
X-Received: by 2002:a05:690e:4084:b0:660:8253:b836 with SMTP id
 956f58d0204a3-6608253ca8bmr7541686d50.5.1780397886838; Tue, 02 Jun 2026
 03:58:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260522150009.121603-12-npache@redhat.com> <20260531071845.10875-1-lance.yang@linux.dev>
In-Reply-To: <20260531071845.10875-1-lance.yang@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Tue, 2 Jun 2026 04:58:46 -0600
X-Gm-Features: AVHnY4IqE8U3CJE9xIL2UnupWmTAd82eHE7h-QioX8Ctpe94C2G_M5ur14b-CTk
Message-ID: <CAA1CXcA+oZmp=cxiC2_EBDxqGX94gAd335d9eFPNv=j_0=og7Q@mail.gmail.com>
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
X-Mimecast-MFC-PROC-ID: xQLG0AvVZiFdLF2c5WkXrKIxoMufAlPBk_TlpxMb45M_1780397887
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AE6D480008
X-Stat-Signature: icj35crjsybbn5ywzxk7a7tjiu6sm3km
X-Rspam-User: 
X-HE-Tag: 1780397889-227534
X-HE-Meta: U2FsdGVkX1/b2+9O4EFiz+vB6pkjFOljpGVnGRxy4Nwltv0WmaW2BnH1A8fOFbPXQjyqxvVfwiOF4b+HCEfBIxZxOgrtN+01gnV83J5HNv2CpOFd9xhfYVbqRN3NsWkbhcdWXWnzfYAcZcHRH9FILFD+01k28aX0FFK6j2apzaerqXX9RCgZB1b6UwhaZLwEDeWKrRnR1bIhmFGfuOYE15mW6d1/+SfEaUHzF63YfhrWycmDwqu7kdhtuAIvNXs/DrPSAPi/tZCzUpTHm6BP7xCb+ahYXR1ApIWUCl5IewJYKfzU9+KsbCn4/p8miQC7LXb3L2xtzJBKC2jPTLcT70IvoVoMdkC2MH8vNWV9IPI5BpXZH+SIWUru3UW47/DRSNgcTyuGTnfzLWpfr8SLu474xCfTx0U8VPzQR5GiRUjCwkDPfM6+GrKoUQAhFMKnxQPmeiEUe9iJX/32YAOaXF2+Eyv+S9bt/ZZF16NO7NbDhcoXUyAFKFVgC8CJYpe+neOC7qX8p4JpfZzfYzTw/ChsRVbuI4PWpKatVSUUfIuo9YRy5dvjGwxcQaEUVZ+V8a6I1kVkoayMngV4zxLLuoAx37L2JZOpvP/GSciKQF6OXnbgMKFmBsi0sut2gcX5HQeucriMGmH5X6K57RIN1Uc9GleL4wvSGGoSYZTlh/AL2opgete2YA8rGLF84hy7PP7XOFgQ45krsgqP3A8J98vafeEuuH8Iy31A+bUb+w8z/ONEtqR3efElZgJyJV1/1YrvLKooJJ6jC07TkEkjSY3KwVk7DTdCYyaLhrTm8Q+RhDRAn7mxShimiXHcL82fuFUCbBakA39HJPcYuHVoE7CLgp29XXdzZj/PrXCr4SuiFoHekY+6HZntpdoXOla6JFS1MdS7651eBB5XJL7pzb36oG8MJko6CXIncNviGZpmDz6t0Uuysjg6Kpznay1ru3BYP93sUnvxQWHI1/h
 7+AQxMzs
 doxQX7htPsTU7xFbxkyn1Fke/N5NLFwIA6iGuUGdyOq9j/KrLWDyNYgqAmfkWiUl91TpkVnWQfjlADZgtgBkvbOC3t/e6/P3YrgsRVndu8OrueldU9hBc5xbGNNcSEVjYub5xRYGFpkY86tpX/v15ZhwPZC6tRG2IvzDAMlKhzhl/n4wIn3Obp7Px99sw238RtOONdIkY5D6e/cnFBqvSyjzf8EUBGuubA3JPGtAl5q/liMzXdju46rqMaiqguGtxiJnrZErKEufos6Xj6vULMOvuP4pYtzfa9YN0OzTVnMbqNju5R5WuwDW4JhOAcY1LORcMnDMwzrcTk3n0mnd63q9puzLXQ4mniR+WltQthII5GXCogfrhEivddw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 31, 2026 at 1:19=E2=80=AFAM Lance Yang <lance.yang@linux.dev> w=
rote:
>
>
> On Fri, May 22, 2026 at 09:00:06AM -0600, Nico Pache wrote:
> [...]
> >@@ -1587,10 +1749,11 @@ static enum scan_result collapse_scan_pmd(struct=
 mm_struct *mm,
> >       if (result =3D=3D SCAN_SUCCEED) {
> >               /* collapse_huge_page expects the lock to be dropped befo=
re calling */
> >               mmap_read_unlock(mm);
> >-              result =3D collapse_huge_page(mm, start_addr, referenced,
> >-                                          unmapped, cc, HPAGE_PMD_ORDER=
);
> >-              /* collapse_huge_page will return with the mmap_lock rele=
ased */
> >+              nr_collapsed =3D mthp_collapse(mm, vma, start_addr, refer=
enced,
> >+                                           unmapped, cc, enabled_orders=
);
> >+              /* mmap_lock was released above, set lock_dropped */
> >               *lock_dropped =3D true;
> >+              result =3D nr_collapsed ? SCAN_SUCCEED : SCAN_FAIL;
>
> Hmm ... don't we lose the allocation-failure result here?
>
> Previously collapse_scan_pmd() propagated SCAN_ALLOC_HUGE_PAGE_FAIL from
> collapse_huge_page(), so khugepaged would call khugepaged_alloc_sleep()
> in khugepaged_do_scan().
>
> Now if allocation fails and nr_collapsed stays 0, we just return
> SCAN_FAIL. So we won't back off via khugepaged_alloc_sleep() anymore?

Ok I did the error propagation! I think I handled both of these cases
you brought up pretty easily.

However I don't know what to do in the following case: We successfully
collapsed some portion of the PMD, but during that process, we also
hit an allocation failure. Is it best to back off entirely? or can we
treat some forward progress as a sign we can continue trying collapses
without sleeping.

Basically, do we prioritize SCAN_ALLOC_HUGE_PAGE_FAIL or the
successful collapses as the returned value?

This is what I currently have:
done:
    if (collapsed)
        return SCAN_SUCCEED;
    if (alloc_failed)
        return SCAN_ALLOC_HUGE_PAGE_FAIL;

Thanks,
-- Nico

>
> Cheers, Lance
>


