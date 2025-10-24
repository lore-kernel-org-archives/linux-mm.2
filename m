Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9AE3CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 17:45:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1333F8E00E3; Fri, 24 Oct 2025 13:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10B528E00C9; Fri, 24 Oct 2025 13:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 021C28E00E3; Fri, 24 Oct 2025 13:45:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E56838E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:45:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9391813C4FE
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:45:11 +0000 (UTC)
X-FDA: 84033734022.04.C3FBC53
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf17.hostedemail.com (Postfix) with ESMTP id C30A840017
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:45:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rSQQ1+7W;
	spf=pass (imf17.hostedemail.com: domain of 3JLv7aAYKCNcL73GC59HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3JLv7aAYKCNcL73GC59HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761327909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9y+RsixQBpMVe8jJ0C0RXhB2GIgsnXkIXIfG2sQ8Z6s=;
	b=NlXAL3wuw1hnp00Ucr9ghNWxMTU/AhyGYiSetneOUb2wpO+CTDn0OBiz3Au1JgHRMoFP3z
	2gXyOwOdhT50DAA1ZyG5BlqeU/2fZxrmEqAPYb2He6x3/1/KNAQaz9s7aL4cDCIa/Rrq7R
	Xp5851RfFRnpQWtBVD3ZgPoXtqwJqsw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rSQQ1+7W;
	spf=pass (imf17.hostedemail.com: domain of 3JLv7aAYKCNcL73GC59HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3JLv7aAYKCNcL73GC59HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761327909; a=rsa-sha256;
	cv=none;
	b=eeSrPkivHx/9a62yrlfFkU5qQPtR3jvqln7rKvQJ5eyfX6DA4JoraHsGvlmd6ZQIDtHyT/
	wLnPD+NChsIV6S/U/Hn43Y54FyVazUxZL2bVCbVVrLneaTizouLQtGMsSJZPoeUamYlxiF
	YCeXLrzICWCndjcPCLZxVBNAV8Rz4Vk=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-339b704e2e3so2303765a91.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761327909; x=1761932709; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9y+RsixQBpMVe8jJ0C0RXhB2GIgsnXkIXIfG2sQ8Z6s=;
        b=rSQQ1+7Wjt6xNa9vm4d+s2vGXl70qhPRiNRF5R5OACMakypyYtlWeEck+F8sgLt7Cz
         9VEKmkCSVserb4OLD/J4MPbot6hJoP4nDvyi23AvN0YoUo+FiOjI2SvGowkD95cm2Xz+
         MxO0dF3rhzSOHafyFLfinV/7EqQ34JnHqRCoQp7fE3k8DuzEE6xWR0Y+e+s7wZgrDx6q
         m2aCBw6Vr8aMWd5t0/ofBjoaSHKlzbireMECJXlhsJceJ25Rz7qA/lqEOvSx6mXFP0Y9
         i0WKkmE2C+vmm4NPrdul3uDpJB+L2wiW4M3lL//vc+jtliCBO6FLYhAJYSHm79GgsebT
         en6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761327909; x=1761932709;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9y+RsixQBpMVe8jJ0C0RXhB2GIgsnXkIXIfG2sQ8Z6s=;
        b=nvh3AKAOlSyQCWdXo/jQ84LhSfZsD/v5YS0KSaLZgzYFfAhZjRJ6gy/q3fNPIF4P6Y
         c+pcc8Pr7eKJks+zNAg9/HtPJy0Rowlq/nRogJ/0NhcJ4i9PXo067D8Lm1K0HDa6xpfU
         UWILjVcq2UFXiOSfAAXvPi0h3RyDcdyrvrJGDGK4Le91UBMtju7We5lFWfOmiEp/aXDp
         umNp2bwyeNk0ipzlaUVYb/VqJoV7prXDGdjDzJMEKnY1UwQVtSe6HPZStxyuFtKBEDYN
         jXMHzDnBGsU873lbrd16v75qbSNC99r9qeHP62Kiwjj/m9Q1xWND9qwC0BgYmKHyt+QW
         XHzg==
X-Forwarded-Encrypted: i=1; AJvYcCV2m9PM2s14yqxA/RPIicwFu0wdrwzM16tzzDgApbls1w0YgVx4B5ADauLx8gH/St/SBbDiScGx8A==@kvack.org
X-Gm-Message-State: AOJu0YwsqotjpdxAHk0bJxmcCCVvRlu4c+eFoeKPGK6UtmqEtaQ4kL+A
	K79yIHHkK++EzA7BPmqAjMhociBVr1CFN5cKN6KYO4r+Uf2vGSQPPMxTg8qrBD3vfULcA2nrwl9
	MMJ8KHA==
X-Google-Smtp-Source: AGHT+IGvJAcWikn/2GkAunTJp4wJjRX2y0XegrvA0YCLDSoXMGm33ouWPic5F/FBkAnJdnxZYF98SiNPybw=
X-Received: from pjte14.prod.google.com ([2002:a17:90a:c20e:b0:33b:ca21:e3e7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3891:b0:32e:9da9:3e60
 with SMTP id 98e67ed59e1d1-33bcf9375e8mr34102450a91.36.1761327908483; Fri, 24
 Oct 2025 10:45:08 -0700 (PDT)
Date: Fri, 24 Oct 2025 10:45:06 -0700
In-Reply-To: <diqzo6pwdzfy.fsf@google.com>
Mime-Version: 1.0
References: <8ee16fbf254115b0fd72cc2b5c06d2ccef66eca9.1760731772.git.ackerleytng@google.com>
 <2457cb3b-5dde-4ca1-b75d-174b5daee28a@arm.com> <diqz4irqg9qy.fsf@google.com>
 <diqzy0p2eet3.fsf@google.com> <aPlpKbHGea90IebS@google.com>
 <diqzv7k5emza.fsf@google.com> <aPpEPZ4YfrRHIkal@google.com>
 <diqzqzuse58c.fsf@google.com> <aPuXCV0Aof0zihW9@google.com> <diqzo6pwdzfy.fsf@google.com>
Message-ID: <aPu7IosMI61NjZY5@google.com>
Subject: Re: [RFC PATCH v1 07/37] KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Steven Price <steven.price@arm.com>, cgroups@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, x86@kernel.org, 
	akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jthoughton@google.com, jun.miao@intel.com, kai.huang@intel.com, 
	keirf@google.com, kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, 
	shakeel.butt@linux.dev, shuah@kernel.org, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@linutronix.de, thomas.lendacky@amd.com, 
	vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	vkuznets@redhat.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: h5t3j79cte7zyowr1i4onjge9am454w3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C30A840017
X-HE-Tag: 1761327909-23498
X-HE-Meta: U2FsdGVkX18n8t89Oa+n2BfAV17SsuHsMrwSYePvg6MD1jO2oCF8KLxWfAliVxXEhnBKteOSx28R49ryM5OIvqoGkQv1b9eSatbGkuXC1sQTl9EBEhu4TDOhqOd5eXhP1clIVGBrZhkfoUT9kAwIDGQaEEyBGqGnZ8uoUX4JUtMOMZhHYgQYq6Jrtk82L/ZZQFn4lhnJ/gjF/ahQM0G5Q1khqBHqHCwwhaMo3dTczfzvH+sZ6VkjzT7EXB47y8aweEcvo/13IGv3vFvxAk436isH0D845cmZgBPEfNUaR+0eg5GSplez9JylL5TFznPcS17Ss5RmSg7Bt0q0m5Em/aroMp9v5pHGj76oHVxVAOBgx30UK1gZfaeZ+wATpi2xgfvL592vaXKvin9EbQIsGEqK4oYyW39kJB6CY4udLmm5It9BUAdzwK8GNkShOAYw/YdLGFG9jJpvB3RYRgMSzbqTQRWlwUDXHjvpQOBE6B3HCjp7RGkZrBCCLN2N75hy/Ryda/Y8QBnR6W7XNjEmX1DgrzDl048cMhmvtqXJ08I7uXNktknjV0z4UZs7D2PHAhzq4MgOS5mMQNRw5Wq9sUe0BL7vtBiD4+Ug33RqWmZjeNlUkrzTng4mPd1DPDaEh2DtBNLsI4j1tXoaAna6x1Nfy6tFc1Grwb/vOODoI5vN6NZbXz6nG0JE+YEYdbdL5YBsn2KU1JgjEF6rxqKrwNEDEQ/q3L23oxics3psh2zqgFSOmZmlLuKUzXwkDWaNFFpObt/LJbNl3UYcWHQvN8BHFEksa21iJOeaRThikZmhymifEIu34LFRxWTbhuxB1/8CRUQz/VDa4jWBzoLmJZ2OHDc5eR9eHYasHmtikym4EUVcnUcinCksVVy7XWfIm/WbcNbDbGuM+tAtNd1VHB4mWmFmSo+mfarBY5Isdf6HZ9+L4rUeYgPC7o9Z2HBxLh5M+s3lp+0f8CWWpwI
 Fhh/vCN9
 I+61QYMC/wQHWadIdJL/6GAXvEKUW+s30QUSNy4/5dL5jOQ1SZMSyOG6XKe8L5qWmkwZPbJgbTpXX2Q1yPzy7Uwr/MAAMn1XlHXNPqnC4iNNAJ4wSe491wfzPT2ujj3VoIfLLKOas67CmOzQ1YjVqYHPp7nOLKQpveB5DJXoxeUKCmqbEzTPvVb51zSG2DAEiVI34cp1A2mWlcXaGogqIy8yIChkfur+IjLZm+kFwUX+/IO1v7ffFP4pSnWbTclGRlVRb5ZsxCX7iQlwKlU1gAk7FEpTCt/AjfGXI5FnYyk+waMtVaKIWd92wtUpQCt01CGoHu3H0RoF7nGKv3bT+dl8Vnc0rctws35hFID3v51mezerqNMk+AHOP5IyAF292KFTgEsuMDxYJsS4jickElxVwP921jtnjHy9KD2JIoMgUV2zT4RE59GGN9PkCt/q6+euwlS5NErOnl6ewAcfC/Gqd51snuvJ0YEXZrlY7urynMWatYtkuDgOiChJTIake/iCmsa0mnxfYGiL2kZA3H+FnnKlGZAb4MGZYnvdHjqDR6+Z3IdThk5ePBoMQSefPk/O4sOwr3AEt6t2ghNbBUg2cgKIhV9owRVuTe/7nMB/HFvz1RC/Vxw5uFf1Y3PfH5TskVt192J/ywbSMneiQPUtQXJxa0xxR0EVQ1PbU6bFspiC1Z7ViBx70bKk9IlW8mWe6p3IiAF9utGQ1aoCZFSg46Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > @@ -486,6 +488,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
> >         }
> >         guest_rng = new_guest_random_state(guest_random_seed);
> >         sync_global_to_guest(vm, guest_rng);
> > +       sync_global_to_guest(vm, kvm_has_gmem_attributes);
> 
> I ported this [1] except for syncing this value to the guest, because I
> think the guest shouldn't need to know this information,

KVM selftests are about practically and testing, what information should or
shouldn't be available to a test from e.g. a safety perspective is completely
irrelevant.  In fact, one of the biggest advantages of selftests over KUT is
that the guest side can know _exactly_ what's going on in the host.

See the usage in 1850e3da4b03 ("KVM: selftests: Update private_mem_conversions_test
to mmap() guest_memfd") from:

  https://github.com/sean-jc/linux.git x86/gmem_inplace

> the host should decide what to do. I think, if the guests really need to know
> this, the test itself can do the syncing.

Why force tests to do extra work, and potentially introduce subtle bugs due to
state being stale?

