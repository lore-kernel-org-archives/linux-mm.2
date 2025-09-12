Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00157CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:48:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ADD4940009; Fri, 12 Sep 2025 06:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4855C940008; Fri, 12 Sep 2025 06:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39B1D940009; Fri, 12 Sep 2025 06:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A32B940008
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:48:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C1EEA14078B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:48:35 +0000 (UTC)
X-FDA: 83880274590.24.B05DA62
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7A36F160002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:48:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pIhrbsz6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3KzBQV3s;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pIhrbsz6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3KzBQV3s;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757674113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CWphaHK8OZGZX1V68Y5uJkPgW2mcaEuIYhBomIwfjhY=;
	b=KEdvnm5wicEyjNlC0sfH/s0kV+tLARk959s1GHIcPMh99UZ/iXU0/jlcCWNtL/CcFKbzQW
	bVNjv2sQleuDeD60dkaKUt1IYnpNWSAbnXIf83RKHYk0Wjqn7IyyUehhktHPeSsHXzGf3k
	Gw2Y5OFxuxGTRKSm7t6K+8nO1IJ0usc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pIhrbsz6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3KzBQV3s;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pIhrbsz6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3KzBQV3s;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757674113; a=rsa-sha256;
	cv=none;
	b=n5HnRycXclIidKku02zHBxDe0aglsl1wLiuyaK7mBbDYKZSWLFSOtNduaJCEjNKq5i93zq
	Z3y1ruR1+TOTMhWc3ESUxcZrmk1+xSlhkgE2eYP0RAH4VFTguRhTbt88+sHvzyxYlvxvv7
	OyKHDeBxKAT5fxacuWlBqOCQj+1NXqs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 852524D403;
	Fri, 12 Sep 2025 10:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757674110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CWphaHK8OZGZX1V68Y5uJkPgW2mcaEuIYhBomIwfjhY=;
	b=pIhrbsz6PFEg2rsKfYIDk9LSisUudy3RRRF+vPTEdTVNBEc/IYjMGMRlHJPMd81a3PeAPQ
	enViOBHkrPb/ixVfVxnLyPU7+6VjTklFYkyeXlsUfBRq5C+jV7UXdmEmLyAdx4Q3d4ezXR
	1O/cIWn77hOKnup2fdLIdwqygTz6oOk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757674110;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CWphaHK8OZGZX1V68Y5uJkPgW2mcaEuIYhBomIwfjhY=;
	b=3KzBQV3sfhI2xmW0tXlMKSTmNI2mUbzMU7tkf31yqUEPagskAIo4a6mTeoFEttV9DasuS1
	kLhxxYyMXH7/23Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757674110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CWphaHK8OZGZX1V68Y5uJkPgW2mcaEuIYhBomIwfjhY=;
	b=pIhrbsz6PFEg2rsKfYIDk9LSisUudy3RRRF+vPTEdTVNBEc/IYjMGMRlHJPMd81a3PeAPQ
	enViOBHkrPb/ixVfVxnLyPU7+6VjTklFYkyeXlsUfBRq5C+jV7UXdmEmLyAdx4Q3d4ezXR
	1O/cIWn77hOKnup2fdLIdwqygTz6oOk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757674110;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CWphaHK8OZGZX1V68Y5uJkPgW2mcaEuIYhBomIwfjhY=;
	b=3KzBQV3sfhI2xmW0tXlMKSTmNI2mUbzMU7tkf31yqUEPagskAIo4a6mTeoFEttV9DasuS1
	kLhxxYyMXH7/23Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8C11E13869;
	Fri, 12 Sep 2025 10:48:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RcKSHnn6w2gcWwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 12 Sep 2025 10:48:25 +0000
Date: Fri, 12 Sep 2025 11:48:15 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Cali, Marco" <xmarcalx@amazon.co.uk>, 
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>, Elliot Berman <quic_eberman@quicinc.com>, 
	"willy@infradead.org" <willy@infradead.org>, "corbet@lwn.net" <corbet@lwn.net>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "maz@kernel.org" <maz@kernel.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "alex@ghiti.fr" <alex@ghiti.fr>, 
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "trondmy@kernel.org" <trondmy@kernel.org>, 
	"anna@kernel.org" <anna@kernel.org>, "hubcap@omnibond.com" <hubcap@omnibond.com>, 
	"martin@omnibond.com" <martin@omnibond.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, 
	"brauner@kernel.org" <brauner@kernel.org>, "jack@suse.cz" <jack@suse.cz>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>, 
	"kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>, 
	"haoluo@google.com" <haoluo@google.com>, "jolsa@kernel.org" <jolsa@kernel.org>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com" <jannh@google.com>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "yuanchu@google.com" <yuanchu@google.com>, 
	"weixugc@google.com" <weixugc@google.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "devel@lists.orangefs.org" <devel@lists.orangefs.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v6 01/11] filemap: Pass address_space mapping to
 ->free_folio()
Message-ID: <2w22wsqar437lyp3w4bltyoql4ksn3exppkyaia5ogtnt2ttte@6nptj6ed4qnm>
References: <20250912091708.17502-1-roypat@amazon.co.uk>
 <20250912091708.17502-2-roypat@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250912091708.17502-2-roypat@amazon.co.uk>
X-Rspamd-Action: no action
X-Stat-Signature: jomnmyjff8dij7wu7e8fmw5gfao3u581
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A36F160002
X-Rspamd-Server: rspam04
X-HE-Tag: 1757674113-887221
X-HE-Meta: U2FsdGVkX19m+RflpReutXTYOHiLDi3upjLIiPAF37Z1ay+eSfZrQ02znBMPVccEH0Bb4Mrb/1r8xumQX75SOhu+TUpRzX4RLrZQsnbFVSbfa4/1Ok6j6WvMwsoM9nQ/HNx2ik1fQRoDN6NIIMZcmHtWibbwvPptZHmdZAHyDlROB1XkmF8OA0HPjk5tYGAPVJ7F7jT5KFqz+KQtuDQSE4rQczYaq5c+cMKWtlKp/D3OY8xMK2q8sdMjwu9fJ02FM/kMMcjVZKtiGKkZ/WhcF4+HftZcMlUlffnijilNS75TWcfXw8OoD7v+QuQVR6zsxKS9b6uOrfnqSGoMZ4UGdzRBVBIsypJydu/ygTNcbF4hR48aB7ruY6dKz1T+YOje2SqQBz4LJsetJy8m0tbdJ7T6MXVW4Itp3CcSUlPkS4OQsFzqbfaIGSx3+d8Q8D2mUU03MXkPTKkUaKMKgpRXAdgsGq8zXxJSUlYfATNgqPKuckgxSK6zqq9XuEQoC3bp/S1gMR52jCvljXVbAHZ+YMrrL2+m+jkpjm604nphpZvspvOkLJvnQffPvsM2tibZv8mBgdlWtLHc2sztGgpYBNbt08QMBoJsJdDTuz44ArfCGLRfV6XPL+F4Nl5vg3neuQtfie1lNBGa7H3AYqTHt+pAUyD8qJTRegm0uGv5GBcex+TFAVr5+mb5DxeDjZOtPNkC+jEKID4C5+176Fn6lI+6IhXDLZ8GN/xKUVQmkevfsOhoFsDbYRkK0rpgvV7ymSVBKa+QWb2hLfCjIyrpq7J4Dc5UuZ/dHPesrg30P9L/+Lm/NPru3trOQWigGmE5XcuVNJOWvf3szJsRL8Rixvm0SSN/PncINbTp6J8+DnC9NpPba6gQIE/AR0ZPGSkf+XYjn1JZBo4qFoUrQM1cDL+7LmGE0VkNsIE7s3OZKQxhoIv2uG0GediI9oPA89WY3D/lk9g6cNRNNyK78Fo
 4QyTGq7I
 jBePXmUhJuDQnS7DLbueuh+x676wViWZiOV2mNRZoWRQB/seph2coFrn+FisZr4PjxdEx/DZ5y+8xquIIKSWhm/NZdm0bQJEtKLt9xpfGNqJD6BQnzgD4m/ITgYx4qGmgZy2Mb1MAPrCixm2494J+Yd1qWZfIag+kcpaYaIso2C4iQW7RcAzjnZtnxxdKtNCalhQdOzqdO9t2I0LjTP44ysyCaEtbljDmam4wUSKLqvEZzD5VtXlJ6MoTrufXCcvKu6hOzHnppzc6zV0B9qWudJXTzbg8nbgLzLCCJQpGxBeF913rNf9ebVd69Tah1zdDWDmDItPNeizoM4ohKdOSda60ncY46zMnrYHJ4cKPssuG6TMOfRYdx/dNs7Aa1qXcY8TPubuuR5nbRbPy57F34BVZVZtKja4H+kXaFV1f/8tOMLvcSB/wtIoWh5qPy7W+s2t3/7S7518o4+ueHznzRDlMhLqJ0yjQswSPx4rgpnfbhETe9Z632ZI/cGntCUi8nrV0Z6RNy4gC6Y00RQT9sS17T8RX8fBRs/gFTcYb5kAXz7jP0n8SkjddMtlpWZwYrwCbEv83GcCbuJc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 09:17:31AM +0000, Roy, Patrick wrote:
> From: Elliot Berman <quic_eberman@quicinc.com>
> 
> When guest_memfd removes memory from the host kernel's direct map,
> direct map entries must be restored before the memory is freed again. To
> do so, ->free_folio() needs to know whether a gmem folio was direct map
> removed in the first place though. While possible to keep track of this
> information on each individual folio (e.g. via page flags), direct map
> removal is an all-or-nothing property of the entire guest_memfd, so it
> is less error prone to just check the flag stored in the gmem inode's
> private data.  However, by the time ->free_folio() is called,
> folio->mapping might be cleared. To still allow access to the address
> space from which the folio was just removed, pass it in as an additional
> argument to ->free_folio, as the mapping is well-known to all callers.
> 
> Link: https://lore.kernel.org/all/15f665b4-2d33-41ca-ac50-fafe24ade32f@redhat.com/
> Suggested-by: David Hildenbrand <david@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> [patrick: rewrite shortlog for new usecase]
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

