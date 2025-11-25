Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9810FD0EE0F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 19:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A926A6B002B; Tue, 25 Nov 2025 14:21:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A42F76B002C; Tue, 25 Nov 2025 14:21:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 931956B00A0; Tue, 25 Nov 2025 14:21:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9076B002B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:21:26 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3441A1A03A7
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 19:21:26 +0000 (UTC)
X-FDA: 84150098172.08.43A99ED
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 77AE28000F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 19:21:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="M4eRE/SA";
	spf=pass (imf30.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764098484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6qx6sgcmtbzfT8nlrCbJjKmeKver9dtlckhLCSjjEuU=;
	b=nxbnJVf0LTy0SVjp/WHwLUguEfBqvbEtPgXyxX0W0vpUr3jmZJt5E1b3ygUrPdHBmoUvCp
	jJewJhKpKtEWrbC+boj307rZgf8UYoyoVq6ICamJnraGJCemdHSAKlHQ1NGhaHV4GrUQnZ
	Icoj+Wj/SySODRVFBAgB6sRq3/IAsMw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="M4eRE/SA";
	spf=pass (imf30.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764098484; a=rsa-sha256;
	cv=none;
	b=uMRLHb3iO/KT3frdL6YHKPI2G4G6xwGqgM/cYky5OIZ1TR0Mrfv6gC+no7qk8F3sULSK+4
	xa7smkXVGI7zwO4xnQ4qfdz7K5QSxYzaCkizItQVhMbemJvzSHozF11PhbB1IZo8lLwCkS
	daTWEYKNCYqkk9Hr7vAIs8jWzRtQVBU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764098482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6qx6sgcmtbzfT8nlrCbJjKmeKver9dtlckhLCSjjEuU=;
	b=M4eRE/SA+nhqPLci3UEDOG4c3cVLyfOIf2O3J1z5dLg6EKr6DjS60uNT3BIBxXLVSNPnA2
	8vTGkJZ5/VZg9a7Ub6TgQ0RGFgBr1hEh5tyAlfcmkdsZbYRL8fJpOiBnqqPA8YmwLUPUt8
	kK+kQnJEnt07NjcxYNCEk5G7WPQLIQc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-JyyanxxgNB-dPPUxvI4lCg-1; Tue, 25 Nov 2025 14:21:19 -0500
X-MC-Unique: JyyanxxgNB-dPPUxvI4lCg-1
X-Mimecast-MFC-AGG-ID: JyyanxxgNB-dPPUxvI4lCg_1764098479
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8b2dbd36752so1485521285a.0
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:21:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764098479; x=1764703279;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6qx6sgcmtbzfT8nlrCbJjKmeKver9dtlckhLCSjjEuU=;
        b=KWgTcKVNKDL3zq04YpUXnpEVfLhjgSH4o2rw9x+VpwpWLhqKTaolpkRk4mPxOn1SCB
         zP24EJkTHLk0njGdPjCSlDpXEqaKnhfOq9PQzBXJrGcgsfhj9N1D2XnzKfPGKtLsideW
         0qSjvZewYSNAXw4CFnAWzu+YV+iDJZ8Sr4+JvAL4OEOwyQ0gPjo9cpNJWlWSwhJ7ST5F
         c6xrr5CV1a9yXA5KeS64qKu5Gy1ptNH//jGLWnngjSPneSJDT6cHxL+PlVy3pfVlNVrQ
         5FRVjRkiTHh0Bzw10ndIDPUrrX+RQDlawfbfeyDG6s62TdXXI3jn9mfWmiA7+ja78/Tr
         qHTw==
X-Gm-Message-State: AOJu0YxggjGjpxKlm2mG5GDqthMBWFmqnrldYBddFBdEkd4nvv77LHb0
	54J0IRJe5TYsRY5ysKnmYMow0cM2PqtrXWNLGW8lYADvvwtJWArJ5bMnKWk4SyAKSMWsC7LJY+o
	JV/eu8ORbzm5vMPEDoK7YJhryO9Hfqy0qnUQgGFxkqMuxVUOiDhLt
X-Gm-Gg: ASbGncvReyASoxfiiucxkTyEhU7jyeR+Nsgp+Cs+lHDLxcSrT+qRPQnrKPhb/R8C3w4
	Cv5c+vTMZHGGfI9GlACvjfKRYSZqPf3Tx6UXGbxW0N2uatzlMpyzF37isEVaSScO4Xxorvxs71S
	1O4iSRA+t6UURf2zYSVuD5bp4tang6/2nzEXNtFRo/kURY6Vlc4D1cgHGrPMwZVaZyn4fYXVFSP
	SotSEo9UTp/eQkybBS0Gd1XnsjHGxlqHeoDwSyF9qmrt96EZadDSGAJetZELLtuVokO6kdyi25d
	6BIncD4WXWnOx0881QZhjGvXTvV3ZGgX/yFpAOa1N2yO70smdl0HOGGejYMWXOBvtVS92s5qEv/
	vm/M=
X-Received: by 2002:a05:620a:700b:b0:891:9bb6:6b9c with SMTP id af79cd13be357-8b33d4cfb76mr2360726985a.44.1764098478759;
        Tue, 25 Nov 2025 11:21:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGCwC+zV9ilL/kZYBgogz1BW/k0XjgDzjkTt78Ehqb7OwOZ4OSkjcxPe6SUz84vf0wVoVyZhQ==
X-Received: by 2002:a05:620a:700b:b0:891:9bb6:6b9c with SMTP id af79cd13be357-8b33d4cfb76mr2360721485a.44.1764098478205;
        Tue, 25 Nov 2025 11:21:18 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b32953735dsm1226353585a.24.2025.11.25.11.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 11:21:17 -0800 (PST)
Date: Tue, 25 Nov 2025 14:21:16 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: [PATCH v2 3/5] mm: introduce VM_FAULT_UFFD_MINOR fault reason
Message-ID: <aSYBrH_xfMfs6yDW@x1.local>
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-4-rppt@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251125183840.2368510-4-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RazzHxpGvOUxgrAjYhuFP1ibMiqtJ4Zye-QIRDlw_2w_1764098479
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: j5ji7htae3oeuktj8k95s7j3orgdfwbr
X-Rspam-User: 
X-Rspamd-Queue-Id: 77AE28000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1764098483-539310
X-HE-Meta: U2FsdGVkX19l0C2skUvgDyYaAzvrzwjrY5jIUSaaoRqE6Ugb7Z55KV01D1cYYDU9O8qxUTRrmoE93TBs9L/7qA/lWtDp/pF2AFxWDGFEqAZcllET9PNs5tS3U5tCnWNS6TzeiWd2+Ow1gHEGCuCe/YhyeuWrFJ0QGt7nsBE3Xl2akhde9aOkqs1EwZ60SeMa6gA5W5ywcP2t/FoQnDRAP7LTZWNuPW6h8lHhy6Rkj5zuZ6CoWkJ6oCQZ9geG91kx4OgFbY2yt8nJ29qJ2Z4WaVuTSaNVsLmdjzEgAUtQgBJdE4s9gej0k2rjpWMo6kTythKg3qKluY+YDv6cNjcWzOOO9wfjO5JTwUVS4g8dpXaaLnuThp/ONUWwjaJW6N1M01D5k4/N2HIx3CiTV/eIkh56siTeN9udD6EDKDY96KxleGXhARFelCG/6E/6c7hXoGKl+ozeFo/C4Q38yFDZgb+N/OjUHeMkq55NPoaeJgOdrgHclyW3wafuAOkqM945bbqatcmdy3PESz82m3NmvFI1esa3xMP4hFuJvubSej3pEvIVsL9vAvEEJ8w+HRe8emvEglvpqPlSPpU1LGZrCp8VkDRjUM5jtX0ESAfslJVudoN5GCJkvCU80jV8FPW8NPf29Ve5+vyneyUJUI7WZrdDh2L3+EzoSSxzRcFvZn/7sRj8QqKKuqxZWfI2LaJn168gJK4yHTdS71suwu/JqVA9Q2X9U+DNUhZpHbFjJA9Bn64NywwqHobicIiozou1L0I9DHAmGefIZEJG1lE9026hTtW4xhooz7FWb7Q0jjO6Tpz40WfVkHwX0eQapt9LHdplVQ/2h3iHOL/2mVUkFLB9BQzb+utPZ7k2OC8ybPpf5k3RjIPsKmALVc8prnQXousXKe8HeyRG6T4Dtga7FFovq6aMSsBuoaptuFVXdaf69oRJ4f3NPYF2MlKdlY19488q3mTVUSNwCBB9sbN
 0gs2izmG
 ImnFhL5ddIeWNL1TzAIcZv2mrmbLfkVsXoI6hJ7q0fCmABZ12TBSKOf0cf9bnbEhr8YImMc8+5nJAlCIFTVxsMzdycD9hvE3rzSQ/BPYyl7i7Hn7mG5sZedN/HrFsiedsLggujvLULXzZ/ye8v9tDDgCSaO7PTM9u1Ge/DlNie1MvUb+w4sYzeuGgzByYIbjbw4N4TAhuFS9eJcwDu7ZkKBEbYSlXwODhVUewq2sSaGr4HJoiwFbX6/R4Z4Ja4e7LJyJ+4m+TPaAgsSSSISbc/7F6LQaJ0Cm06nq0gPOd+F3VaJd4Olqz0MvfteiQl/+Dt1Vnsbi2K1KcUq0Xln9cSdGGH6O9SAgFvTy632HZxSeJP6/bdThod/74pYLS8keC/FQHeD5Tsl+fzOPsssOGJOGp7Z/In2Kv7lCqc85xufAknu8E8xMdCuBAo/u5PlBuuMqL4fezz8r0qCVjJW6EELe6SH6wXeqLgcPG0gRqRHCtnuz0zbKjHQBybwQOPZwFIEHO2Z6BGm5UwAq4NX3fpfuDm2T3/uKttm1h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Mike,

On Tue, Nov 25, 2025 at 08:38:38PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> When a VMA is registered with userfaulfd in minor mode, its ->fault()
> method should check if a folio exists in the page cache and if yes
> ->fault() should call handle_userfault(VM_UFFD_MISSING).

s/MISSING/MINOR/

> 
> Instead of calling handle_userfault() directly from a specific ->fault()
> implementation introduce new fault reason VM_FAULT_UFFD_MINOR that will
> notify the core page fault handler that it should call
> handle_userfaultfd(VM_UFFD_MISSING) to complete a page fault.

Same.

> 
> Replace a call to handle_userfault(VM_UFFD_MISSING) in shmem and use the

Same.

> new VM_FAULT_UFFD_MINOR there instead.

Personally I'd keep the fault path as simple as possible, because that's
the more frequently used path (rather than when userfaultfd is armed). I
also see it slightly a pity that even with flags introduced, it only solves
the MINOR problem, not MISSING.

If it's me, I'd simply export handle_userfault()..  I confess I still don't
know why exporting it is a problem, but maybe I missed something.

Only my two cents.  Feel free to go with whatever way you prefer.

Thanks,

-- 
Peter Xu


