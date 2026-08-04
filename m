Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ABA0C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3A46B00D6; Tue,  4 Aug 2026 14:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17B2F6B00D8; Tue,  4 Aug 2026 14:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091806B00DA; Tue,  4 Aug 2026 14:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D70A96B00D6
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:47:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6ABF1A02C1
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:47:08 +0000 (UTC)
X-FDA: 85064469336.19.844B2E6
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9A38F14000A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:47:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DXtBj2qK;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785869226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0XhFL1Aufp21Ws6fsSI1vIe2k9HSzrqnJkS9QsV30Gk=;
	b=zdSVP1XxywGEXO8hxiTuFqSD11vVQUQKFZJoHZwQgcCg5KBSF6kKYOTUNzxRKeppTyhaGD
	KkgS7Dbwp/N9O2nat0vxumnAli9qpQWiKYvZFvnX+/Ncoh5TlXsWMRTuxPgk/1aAGuvajC
	3CoaEtdMUhJX4c/bn/NFVcUM+eJZIbY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785869226;
	b=pKnkB9UrU0CJu+waNh9GshuHaLwmAXlteeU773TJSjPBg+rkpOiIWBAB9KQNypUZiCan61
	9QBddfEoknKiofeFmhpwGQWevdEDEFJdL/JQ6afTN9n+ndzaHtfLmfO0zJaPtwFKhUbncT
	mF/7XSwQGYdWUchr3UdcemQHcbnMKOg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DXtBj2qK;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8f186025973so1598656d6.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 11:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785869226; x=1786474026; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0XhFL1Aufp21Ws6fsSI1vIe2k9HSzrqnJkS9QsV30Gk=;
        b=DXtBj2qKT8wrLvsw2/D5ZZc2tG0gSeS7NvDhE+umRNgkrQ43PGrS7dGyccX6my37eU
         4fNyGgLeZ1NQ/cTM4rl6lCt18KirY/RJ36KtlOgjtANx7JtVA78BozM67g/RdMXN1Zvi
         X2jt4WzV385WLTJ6ffW0c4aKa9+Hs94PkVre0MyfkWE10R74TC4hE1RKeoX8mevarBe1
         vap2RlVaMedhI2m2fww1S1HA6hJhdFXL8tuuJ+aSVBjZvlVqHZd6e1xAp7mxWzQ+GqD/
         7cnc9BARd9Obeh4k7/zdOrhQNEWR1QNLrJoMRLYRFFKOfqbKn8blcwkbRWFDNqiqWcNp
         BvcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785869226; x=1786474026;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0XhFL1Aufp21Ws6fsSI1vIe2k9HSzrqnJkS9QsV30Gk=;
        b=N3K48p/xhntcHFfLdgJJjIaI3leozQJiaNqRKnRVtAP39EXiYKVKdGiB7SbVjmvR3L
         WxTJPGHs20gimp4AR3704HLL2xu8llqnvi2yRjHVdbzGqTbAU7Se7+tlnmp7rDdBUSX6
         AYZ2p4c94u0HRvPTqV39BOyctKoaXB7WipCglktriVkn/91zvnJR6oWxN9pF/PGcqgOJ
         lbLRH9Xtn2JbxmyMiti0jmf/sZfNz7+6aNM5iE3a9I5yJcj1HcQuYenx6BMjYoFdbZRr
         MnTAVTbffdOkIfqpgFcbfqKG757FgypgUu3Kaa+gGcYsk3lZoEXnq05XBLzRMFZfr4M6
         T07g==
X-Forwarded-Encrypted: i=1; AHgh+RpkWb53ADNZnI3ZfPwcnmr8+grxNFkiEPQPQM5uQl4yrjiyg0zJxiKdcButU7Z7THM+9aKJGZfuPA==@kvack.org
X-Gm-Message-State: AOJu0YxwzpqV7JsqMPIzUIrVkf7dv9jAgKH8WCAO/hGcFzwYzZ4EYbXF
	ns95dmhleb9sVLJNmIWyIimbY6yhrF14phfu9cod0sKt6pHbNsUaSbuu8KaBDbdHIjU=
X-Gm-Gg: AR+sD11Sth89Xir+XjGPkg2jFZSF+2J+1wc7bKhPAEi/+MHAs6jakBljSXYpiOU8BhX
	+shQDDt75Rssc9uRj6+2CCP0BU7E/DUjyK0k4+hPmjf7XxF/QPC6oKCaqnOpUehgSsxM/XJDwOr
	2RWtipo/Kk+yJK8M4mqkmvsSGqZDntO+lqcNK9QmaE9BUahDQG82FQZjI0LiNUlMg6yYGluhmUb
	NRhqlge+4NV7AE/uV/JoPGu3h02GkixFdBxXh9HPepm3BBkjRV0svXKFY+pJN+cK0kSUZre3Una
	+lQzadnWUZPy1/b9SpObVrL4rkh/tbQ/pXmihu0ZuwR7pO2Ab44jR+XTtzVPAylQgRAIK8mL9f0
	O7WxlzQw+HZ6wKP2l5eMWppOrxcqKSmIRUji75pSMZ12kDyD8lHl1qO+kiRXOBHwIld1CBLqGCq
	M81b6UHL92E5zCGOVAu3Y+CHdPmDRWv0eaCSgAtrktxYWTZn9i7gmDnBw6r/boGIUD+cuyyfTK1
	Ibj2C1KfrK2naBUQ5BoJJjpgrGNZLbcycT2AZDduBiA
X-Received: by 2002:a05:6214:4687:b0:8f3:e97:59be with SMTP id 6a1803df08f44-9088124bbadmr16733196d6.17.1785869225675;
        Tue, 04 Aug 2026 11:47:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9087ff9d79bsm8203346d6.6.2026.08.04.11.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 11:47:05 -0700 (PDT)
Date: Tue, 4 Aug 2026 14:47:03 -0400
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v8 09/15] mm: Remove locking mf_mutex in
 is_raw_hwpoison_page_in_hugepage()
Message-ID: <anIzMHAH8dImAcsk@gourry-fedora-PF4VCD3F>
References: <20260731200802.574821-1-willy@infradead.org>
 <20260731200802.574821-10-willy@infradead.org>
 <anIUe_Zq8bFX0-Dk@gourry-fedora-PF4VCD3F>
 <anIaMs7XtXp631QU@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anIaMs7XtXp631QU@casper.infradead.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9A38F14000A
X-Rspam-User: 
X-Stat-Signature: 1acumrqi3pc7zcok5xghqckdj6tshjbo
X-HE-Tag: 1785869226-8132
X-HE-Meta: U2FsdGVkX1/yjpCUsJbEOjdjh39TfZHxijQLezBvh9VACdWVZlpLCJxYRZ9hfc9L2IYNYOdNs/OdZ+9HA/efdUvMGGko8siD4L/0i6OK0yvcl71Mumw77/J8UN+9HtKr1jIag4qj6iKjBoUcCcmldVtR4PmhP4Wc2u9B1j3Rk4vCkhvrKW6fNYnA8sQuEC80TXFTrYWNh4pBMbYEK6d5OR1mSLqzEWVszft9+pg0LQrrqAy77TbPXeRcW4/gxhXPtxQk8Yfxm62YKhiaqOjm6NeqjuP9WUzqCXFDbSTbHScG5U0XPRKrdQ61Fp4U1M6p6AS8Z96VKUjKKMYoP5vjHtjjPOVCIVM7kKGHACrAb6y2nryaRuPuCyfOwAqS90dfrj3hhl2hS8z3GSg8qHuij0Ky7WwpUAiK7KIAWxLFOfS4KJGByKxMTnY2wB36PE3X+qi/RjrDVUHbVKJ1XVgNIpuYgU2Z0GEfybxAUKHr0Arkmub/JKXfDKjkk8LbZfo3JeT2A3wo9Bk8+Vc+/BbTnnlc79AcC8ylJ+HN4eJsZvmiexE1azDGpDQRdrzccdXErQjtKDVvX4bsRls1QiidSSRq1G2m0kd7etEjHiHCRsuymvRT4GJ7cxaXqnw4WMDKg//E/3ggJ++fII3gqRroL/t6zxw7C4q2ggE6Zyz6HWdij3HDIaZunG3E9tXYc0rwPgIcz/cDP463mE4iuycwb3ism5GaZ+SXz8sP+7BymlRAzNIedF8aH2bN0uj+KqdCbkKotDaxxn3G3wjyFysgriSDQ6uYPQT9HYbwuM6xeInsqgqhTLVQuoi0TX+A3SAaozf/PquB3OuxSbu1jCwTL727SKxXcT2X8sGI8hOsojwpxrwQ/RkicmfoPUqeoevYSwYsZCA8O90oXfg6N4XVZ8YFQp3wxuWCAJsMXK975gcZ/Ovlh4y2UifdRCsjcHPeoBbZs+896hwtNxbJFB9
 sUQgyFKG
 WXi7cO28LdocY6PK1s7Eco8fbd2DBwRYGC7BlBH1/AtlJ1dzjHIYOsGhaYho4++qB0+Dqn5XK33Ub0XPhHSqS/yS61s2oyEyL3bCsSUErwmsA+IQBCbxpbGml+9ieedT2TpjF+qlkiKMcw5RPY1Q5XM69pS3/mcMwGlyBHWGjsPSkIBTnvwpw9RUgGszSBbaXAdQizJ9I6kilk9YH914lV+ifizEtz1GWcEesHDUFyeruzHCwYfnuMAViQqaG+VWeuXpRF9X+8jd1pUPmA8+PAEVNzkW1gLfd6A6H/yaO2nxXOg/LIgDsLZdTBm9w9VRgwVzA29ijoMwSv5TFfme+enQhfdcKbkYyJvbY+mePKcLVSSFXZZIkhfas1+eyHDlmFC/5FZdR/UpgyVOB4WQux0eHZNj/SkEujCR1VBe+CWSDuzmM5vDkyiD5Jlo34NpOaZNoLc+KlROnabk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 05:58:26PM +0100, Matthew Wilcox wrote:
> On Tue, Aug 04, 2026 at 12:36:00PM -0400, Gregory Price wrote:
> 
> So we have all manner of protections that prevent us from taking this mutex
> -- the folio must have a hwpoison page in it and must be hugetlb, but at
> the end of the day, one can still be preempted while holding a mutex and
> we never know when we might want to call this from a non-sleepable context.
> 
> I'd be open to arguments that this should be an rwlock rather than
> a spinlock.  Or figure out a way to shard the lock per folio (lockdep
> etc make it very hard to embed a spinlock in struct folio).  I think
> it'd also be profitable to change how we record poison for hugetlb to
> not need locking or memory allocation.
>

I think such complexity needs to be driven by an actual demonstration
the spinlock is problematic.  It seems like if you're hitting devastating
contention here, you have much bigger (hardware) problems.

> But this is all a very long way from where I want to be working -- cleaning
> up the page fault path.  I think I've made a reasonable set of improvements
> here, and somebody else can come along later to make the code even better.
> 

Agreed.

~Gregory

