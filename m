Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C75DE606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 01:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=paul-moore.com header.i=@paul-moore.com header.a=rsa-sha256 header.s=google header.b=Ns6k3bHp
Received: by kanga.kvack.org (Postfix)
	id EFA286B05B2; Thu,  5 Nov 2026 20:22:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAB3A6B05B3; Thu,  5 Nov 2026 20:22:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D74056B05B4; Thu,  5 Nov 2026 20:22:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE0156B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:22:51 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BDF99A09BA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:22:49 +0000 (UTC)
X-FDA: 85402944858.30.231F0F8
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id C534514000A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:22:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=Ns6k3bHp;
	spf=pass (imf23.hostedemail.com: domain of paul@paul-moore.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793928167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oLgPV68l9ICjIDifE65oCN1RGzBXPv/N3KtgmZVNysE=;
	b=Vw9A9QTgJZI65MqW7A+gtI2w02riyhH0YGuyXDjgMy1+8cZe0JESjVRFadmATLa/PT00ov
	hhnBBq58+kwKuh2XDArYvmJLcVypPCG2lk72OGdXQBgafOwIcDOVI+ER9QWtYd+itpJbZY
	hw3TNaXMab8pbvZC5nu8NMwb4yvApl0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793928167;
	b=KiGJRPYJUhMafArfi+9NSywR8BlfbjPivA1JlrIDlwf7/n5fCrF42eCQICxaoY6O2HJdrU
	xSohxfFgABXCW+wqUHvN8bn08becqMl/gUoR/kOI1oseN42FwGD3uYS2z0Cl6c9biyVhk8
	wRHFWDbrrsdv6RSZrz1qK4zmacVNtAg=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=Ns6k3bHp;
	spf=pass (imf23.hostedemail.com: domain of paul@paul-moore.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8a06210b29fso39896b3a.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 17:22:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793928166; cv=none;
        d=google.com; s=arc-20260327;
        b=UmcHKAyNnVCYcu1xXIXZpR/UODfmaLirEbxtOF1mpuDgYgP8hNMakPOM88xB/Vjipa
         LMPUvqpNw7TuSby8b++2PR6w0KoiUs+yyTfeUjIEFfE92SOzaqd5Xy6XOYRwyD5U6Rqf
         SvJMck+Ddzpb0AtLAA70mbNBpTU3RCXPlbdEiNljTmQQWLYC+X2V7vbtyy01KQFkU417
         D+1APqSULtAWT3Ir8zzJRUQEL1SO6LjxfQHUixlB25QRPvpq235vpxOpxdxXhjPSImXQ
         l/gZttY8pduZHPugORZW52Y8TTwGGUtKLcSaSKcnOkDCKatiP/oKcQgqIeSO7W0hy3n3
         3WGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oLgPV68l9ICjIDifE65oCN1RGzBXPv/N3KtgmZVNysE=;
        fh=dIgt6QsXTO/tspysUBknsv1CJYCDQUwxOb1YLvil/WY=;
        b=F+5lmajB9CJXlwAW27tZ9rVlFLeX0JOGp2DliOI7aCb0ZiHoJWWx1E3XDeZZTK62xK
         E80DVCcHdY4nhKZ8fTrV8MMTArKNMgz6I075K2Uws+bw0nm7R9dFaYtmOTATxLQpp9j/
         KIPAgsaYbs2IIeIUjZq6zNZeSPLmptjCo5qKDxbMBRPb7ejZU6NiRYjkxzZZPlOlONXQ
         zxVLZO7KYt8+1eUVWKshqF+TD69uGUMcJr7YqFTvBZYSixAdCLWvx5NpSn21/VQk5G/P
         e2GkUIuvtO5ZbDJw4eIZfRQ+d0vINlunp0fmXP9KTJ3FqdsQVdgX65ejU4Hhm7j/NkYt
         LflQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1793928166; x=1794532966; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oLgPV68l9ICjIDifE65oCN1RGzBXPv/N3KtgmZVNysE=;
        b=Ns6k3bHpqLEw6ytf7koEGzLQcCNo+erKrz7H1X1PZprYgXAjcN5hJtak+U29Xlq60R
         SUUuZnpC1buKla/wtbEej6Lzc3DE8ZX9dLF3K15SBfDnkEBhLxEiICWzVApeoZS2CYlB
         whvFdBWEtxk7+13JORSNpR9iEQEufiyFIDrLUn0OIE0U7C7Kq5VHLc/PtcR7SjfzF+5Y
         V8MOIMjmTwDpFd08n2MBp5CvSY/7O/i0USabaKKhoH6nos2WfG7Vubu68J7xWvMEjD+7
         ydVTHFa6fa9017kEimiug8GwVcKwxyqXzetU/SnPVyt96+lM9RuIaS8p941eoNMykDEp
         6Nbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793928166; x=1794532966;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oLgPV68l9ICjIDifE65oCN1RGzBXPv/N3KtgmZVNysE=;
        b=NQ/xNH4UpgpPmWT8VCUAqUJQIrL63uwce39RQyEl4BwRx+PHvGk1fMqOlmExGknfuI
         5hjV2obQAaog5FKj3ttg9bkRYzhsL3SVV4aGViSe1569yiTEg+jiLBec6QS0PEnZfLDA
         wlpzNsMWmD7mlssVf9Qx2yKGvvoeSkLSZaC1wT5P+R7QV5hah7xLXJoiInWkjH+OixDU
         XrnzPRZWSx0EWuW4RRfIk6wLxSWdOBeIL/TJeLf/YN2rsqgjq7YJWU6hxM5arBEUauof
         SExZDmaT/+vR+FVFolc3uL3xr2EDAkvDq7GSFJ6B3IrzZnEsgx4xAwojr0py870lqp4Q
         X40w==
X-Forwarded-Encrypted: i=1; AKwUvBwdubMDPE11JCfAM1RujOpFQUYO52EbOwJ4JAzqIOngmYM6efVAy4v6XUY8iNiOQ0Khw5FI/RLmdg==@kvack.org
X-Gm-Message-State: APuU4Z+SjCjYM4BNttCsxCNIY9vPpJnxNA08G/hUtlptCq0c+airoOUu
	tbmfeLgMIl8SC4HMM7TDTaW52kDaXOI3tK8g/aQsRSR8dveCk2Dh6nul2NxP/Z6pFjHjEjrVmh9
	tKdNIEDslFU+9Crs6CICGdm/ZeplSKpXj69CQGJTX
X-Gm-Gg: AYBFou0cQA5kUl+pHp88+Yst8vvrYjzj0+B9cJmj0WIha2yk5jkhgCMXkPlotkIiSet
	xTUH4rRU38Fv5URgr9zbHdaiQQ/JbKOQ4tsQIGQ+by+K9putu3UImVLN9EMehslTCwaMQFMg7xM
	1CHfvmfUkRbALAPFZSzvxMMISSwJhb0YLDBxLmknha8lCHNnyKz4k9WC7OYM7EKrvsYQ2rbl1qB
	9R8EqWlU1lmzESAiEFWw1c+vB/ddloLS2CX7WsRYC1fQWrozRqPzrlJGs/qCcVRk0kLXMLthew0
	JzKd99pwwjBksfLLqoCKJLrSkQy1QOFCJBzyr+SfVRlN5cY/5DZ/4vo0yV2KPf/xI7K6/+w/PrQ
	z6iQX3V4fD7bze1Ol+zwfIptsJNaqr1D8PtH9wcXIZ439JTRP4Rk0SSKxWQHfvdAGnh98
X-Received: by 2002:a05:6a00:4f82:b0:87d:e8a0:2389 with SMTP id
 d2e1a72fcca58-8b37b37d233mr903874b3a.21.1793928166471; Thu, 05 Nov 2026
 17:22:46 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
 <20261105-late-2026-vma-flags-v1-13-0d3cd15ab75f@kernel.org> <CAHC9VhSR=9YNhBxeFBcTR8wgG2yDP1fW590QKjzuc4Kq9ohaiQ@mail.gmail.com>
In-Reply-To: <CAHC9VhSR=9YNhBxeFBcTR8wgG2yDP1fW590QKjzuc4Kq9ohaiQ@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 5 Nov 2026 20:22:34 -0500
X-Gm-Features: AclHuK_C6UmASiuiBuBvumlcrlzJEUCTa0-vZyEfxhlZIjAFaCskKj-ONE1360g
Message-ID: <CAHC9VhRDVz4M-m_4UZZDKMgs4uc+j-+-jwYEdBDfSD0rtd-1Og@mail.gmail.com>
Subject: Re: [PATCH 13/13] security: convert VMA flag tests to use vma_flags_t
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, 
	SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>, David Rientjes <rientjes@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Oleg Nesterov <oleg@redhat.com>, John Johansen <john.johansen@canonical.com>, 
	Georgia Garcia <georgia.garcia@canonical.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, damon@lists.linux.dev, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
	linux-integrity@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: sa4oyqa3n5gu4tjoacchxpjkob1sqg7q
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C534514000A
X-Rspam-User: 
X-HE-Tag: 1793928167-547457
X-HE-Meta: U2FsdGVkX1/xA0RGCODzqca41l32EyJhHVdrJ5mwLwzNw+DgVEaQ0eV+QxdlORsH7a7OXJZP2KwkmpUEXeRjrqByihgbCDDB3wvmYGHrnP9WTtdgtKMhROLKKLz7NaXsCxiOW/Kz5IB+FAtOTSQvYqsKRTUn4iPHlFeVT2sQ4U+tsbTD3NfU6rrgXAHpDqAKeTxQZ7pronuxn3nQUfHb5hX3YfqQ9zZP3Db8LN79qeMwFjnXdKn5GPx28EZTh4JRfEvy9PHZiNiCFUnxImhxwUiIIjwy0CmVV2oaqYteTVCQUNEVVVwWbRomM2fM/SO+9fyzW25WxE26q7iQlAbSlb5vqN1SBWgbe776e97jg5+sfkycpnoebV2PGMG0/1Pfm2d8Q81ZxQ2bkgKNV7+WHEmwdpjB+oZ9ZfEqVCHALj/qLZvFboOb5G7RNolFuvHTK5Xdn/T+RaOBlsDxKMXbSx2skMiM6Pdax+M4HP06wFWfxSII0Tp4WQAI2JFBIlUcHYAOlvsmyuj5Q00B3H4PZAIri+irxOovZ6HSdbctA8U8RJcrznZNaKlAyIi/KuXK4GkUJAGrWp8FClXrvc3SdJgc1AoP7hvMUndfNHzCU4PzrFbpwjl/lATcejkR5Tgj4ZBZD3KBWYO/PIG3b39y60e48rF/mOeiLHixDvBSLxiEep4PBoQ5yzIB5xlrFGdg8gPB4k+hzU0Dxu10HeQGDcoyQUceof41xkrV8/Co/kRUEFByMm+yORevSdU2B75YA3zAHZTgRIdIGg1d+cgpAyY/h3H+GhIKKwoRM6BN96YP5K0BIY5am5fpscjP/2sjFYfa3YUYIp0TTAb7Y0Fmqt7BQsBx25TQYXfNioc4eoT1rVnNg9ICQmDNp8N9VFJyRABRS2o+UmVozGZZ4Jpwa6gYZLB1ajmgZxvxn9nD/0xBo2srAGr/9Dxv+dU2E98IEId7HfK3pBRmfs0uKWj
 TSxgm3B3
 RMJ1fXdGKYT8mtenIYe0c5pxs6UyQDP7lvEdWzf/fSfKb1lhCpffI+o7139wOIIKq4T87SGAFru8VATmMai6E78Uxgzqio0w7iEoYe8c/3ls7nyBICTyuuTosllwQTh6mOkf5Q19AQYgE4Nf+MJ5TyutJMSQ1tYdfmrvyxE0gDlVpzOwjKe8BksrB1EbRbMHZdJcGdZKoZIsdtakocu/Pc6s1BtI+kwV10pGMgoZSfMDjnNdyGhTKZ5dkYbAw67zlH/pucpWlnK4pLdbkC2kBeFri86DO4sFx70fdcVXqNNMia1W3ERG/EXxpEXWCBps8vDxAwKT/PwVRpY2szWxj4yTOD9CxF/j5Cb45soFr5LGA/RdYdTU5KdIFxShY67DenibIGWHgweKtQGJIdYPF+Y5XHoOUweuV3WEs6XUXm1SKlKPJGV3W1w3/l3XtGVMvELsXuro/y5d5p3k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 6:17=E2=80=AFPM Paul Moore <paul@paul-moore.com> wro=
te:
> On Thu, Nov 5, 2026 at 4:35=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
> >
> > Replace use of the legacy vm_flags_t flags with vma_flags_t values in t=
he
> > mmap and mprotect LSM hooks of SELinux, AppArmor, IMA and IPE.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  security/apparmor/lsm.c           |  2 +-
> >  security/integrity/ima/ima_main.c |  2 +-
> >  security/ipe/hooks.c              |  2 +-
> >  security/selinux/hooks.c          | 14 +++++++-------
> >  4 files changed, 10 insertions(+), 10 deletions(-)
>
> Similar to the other patchset you just posted, is there any reason why
> individual subsystem maintainers can't pick these patches up, or is
> there some reason I'm missing and they need to go through a single
> tree?
>
> If they can go through multiple trees, can you split this patch up?
> AppArmor, Integrity/IMA, IPE, and SELinux are all maintained by
> different groups/people.

Since there seems to be a desire to bypass normal procedure in favor
of speed (surely that will never backfire), the SELinux changes look
fine to me, but please do wait to hear from the AppArmor, IMA, and IPE
maintainers before merging this patch.

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com

