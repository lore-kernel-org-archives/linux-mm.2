Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 308C7C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 17:48:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1C16B0095; Thu, 23 Jul 2026 13:48:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12CFC6B0099; Thu, 23 Jul 2026 13:48:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F38C56B009E; Thu, 23 Jul 2026 13:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7CBA6B0095
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:48:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE0781C0033
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:48:35 +0000 (UTC)
X-FDA: 85020776190.02.F991387
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id C4345A0012
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:48:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PbYGeDh1;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784828913;
	b=eiY4aFVbQJKhH9GXVAfNdz0TbO8nfCKsOtYL0Qnfi/3CQ4Gsci1xMYKK25q3ZgOqt1kGtu
	iVOGmt+hx1/sEA4/sfml4fdcHN/peHsFEZzSL7u0d0IpAY2mmH9VrSFd71FGMMIglf0q0f
	IBj9x20PteCraDKbCmFTFUO1Ky7q52U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PbYGeDh1;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784828913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G2+4/YWWiPL/NjZ7kD3wcGqD98ci6jBKaqWoskADH3c=;
	b=K1UIkHbf1vBAe8ztIkHhI4bkFlQ7F7nAzIhaXEgFKC3OKWVt9XjgziRzf9uddq+sF6UOz+
	KcNbcBosVffQJf8Kv2J4gJ9DntD5qC2q+oF3DMuxvK6xLKNBTGZJrltF/QStTfVr5mG5a6
	xPVzLxgZ/3CMCcI5481aT9/7QRJvmq0=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8eeb4508f29so10290416d6.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784828913; x=1785433713; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G2+4/YWWiPL/NjZ7kD3wcGqD98ci6jBKaqWoskADH3c=;
        b=PbYGeDh1xXI8/6Z1MP7jNdMGRZ6SlXg8pMG1+/DNx+ZStdGd+lxyFghOn1O/MkyTYV
         RAoOkDkwk9p8UI0BzDzfczLn51D+rt93m/F8SU1Ix7V+B5SgYqC5N/O2Ipml2hjYYKMf
         NtZa7h1FqHMCdFWIn1z8hs10msgbjIaSOifjbKqDuHAOFBtOI5AqUuCcXzQNIw8oNKwB
         pApxLiLJlX8+BC2lo2EXnpf3gBvPlIjYmgHjP6FbGomAYOR9H9EuLX4ARlG3U2S2uX/+
         cjtM9CBkGtFPRLahjWTvRqL6YV3dHbXx22Hfq5xHfYLQK8F9EBwYR+PCPwR6N19fh6lx
         TxDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784828913; x=1785433713;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G2+4/YWWiPL/NjZ7kD3wcGqD98ci6jBKaqWoskADH3c=;
        b=FRI9uiYdkeCwlvSjVCByNmWOxFyfYItgYkRSmfOlqezAhANVrU2D9Rvnp1F89nf1nh
         fv7NH2n4s5VGZmVDvfMA1JjUDak5o57KQGgPHjE4PejooIj3ZQj/7DqSTfPVAxasHyWA
         sdtiDTfNfyGU6z42rQjSfRmeMxBY9a670QFCd1J5a3mj8kzcg5NKU5U5ebLX9txk9Fv+
         fX/nr5LTIE+1aGh1jMG2rS/oQDqfWg4U3EAfFhythAkRWNkvJUBBcCY+OeE6EZUrFvoo
         BGonTjvV8m0I4YJtvDDsTG3WKCG9DWXr3RU/03dDAjgut2ukcP+mZ6Xvzny53x5PvDUl
         5mlw==
X-Forwarded-Encrypted: i=1; AHgh+RrfRMMuoELitBKDG1ha0Y3c+zmguKa/NKPU++rq36oI5nVbLrSLwsu0QULnqO8xR4mMuzTB9iXr0w==@kvack.org
X-Gm-Message-State: AOJu0Yz6zgBY0EySagpKcS+noC7yTe4XHuh2L92f+wmZbPGWJh9cHD4b
	fF8xLl+xX7j4kCwEPOyCHOMYG9d+eRjmU4IetHnHALmNfxCIjfTy6/RHLj3y/qJkvw0=
X-Gm-Gg: AR+sD13mVSAvyHtdx/cpSbeb8ejHHyARcdeMF/NrBP8XhY4e03OXcTEj+OaPag+HqrM
	HH6Jc1ut8WvKloucA6Rzx7slKCcNCXc1YbtKTrJtJqI7pWk7rylOiQt7Z8C3k7Exy43vWtOejVs
	nShsN3DKSkEuJEHK8c2SCHe8Zgwq8emrQu3RKgShhl8FQf8PY1qwffz4rc3IuoQsSl/d/blpWCa
	UNRly++iiTxYxPTlBRP6VYYjOVItoQBH4ZkZDWMtwp386wlnYg1Z726PQHEJP2MlFnilyo0EAgn
	ZnKubbte+5UktrPU3O3NtpXoZWhC/jIr3yYuej5MkaRNgX/fUS1vvdIEIWx8VKZIYfJWlj9H1tt
	ddHeOVGFtJoY3r/lVCvR/JhPNY/1ZF2MY7Za+j91DupltYh2jpYli1zSoNeJgBBRJABkXmBSIPb
	ladIS2wDe7QnS6V7xIdpfa3sYbRrgaiCC7aRzXN/TXzuagzWZKhAOARnAaQA==
X-Received: by 2002:a05:6214:3b87:b0:907:75b9:b101 with SMTP id 6a1803df08f44-907ca3506dbmr49693546d6.32.1784828912139;
        Thu, 23 Jul 2026 10:48:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907baa09dbcsm50354966d6.34.2026.07.23.10.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:48:31 -0700 (PDT)
Date: Thu, 23 Jul 2026 13:48:27 -0400
From: Gregory Price <gourry@gourry.net>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sean Christopherson <seanjc@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, vishal.l.verma@intel.com
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
Message-ID: <amJQAs3Bm99ZR_sF@gourry-fedora-PF4VCD3F>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
 <amGpEEqxoLq/Y7ZO@yzhao56-desk.sh.intel.com>
 <amIcXrS7nGX-adpG@google.com>
 <amIrDncrL4K-JRBO@cmpxchg.org>
 <amIxyy4Vg_TTE8Y4@gourry-fedora-PF4VCD3F>
 <amJKOPczNMb96NJv@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amJKOPczNMb96NJv@cmpxchg.org>
X-Stat-Signature: gimidhzwehp63g6kbf1woaodcnftmz56
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C4345A0012
X-Rspam-User: 
X-HE-Tag: 1784828913-765720
X-HE-Meta: U2FsdGVkX1+fFbmcPYOBvX6o55Enn2fMVu9wbY2gMIh3/ByH9A/vMLQaBb8lQz0acUf4raOeuw8uue8onZUHhgX+JO98MtQBE9dtmRqsbqVfj53Dgnm9PsrwWI9m1Dd5d8hkja7BA9YBma6cd/4BtPLuoAFL0hjnFqC3123EG3LqbmHHoCjbCj1lUows4TSSH33vUclyIyOwvwAczNsEm+ZM3kLquaXry7igwNAdIlTGaHFthtP5nsLTkphdDvDoeRbsv1mLDiwCrjOdtHfmLRa0e83tZ9jqagmx6M99zVIgAEkLKreHhjMrUk4dqnIaM9KJCGmXPJt+H8vzPqAA/awJj1HXcLqQ495/BjziOALRIKXlMdHH7iq+xdpaO2cOmByq2D/HzbeVWUOv/t7q0rJDmV4hQw0pnb3kVbkbPL1JIwU+9bsazPZGH3/wi7b29sPp55nCl75iiqDxANPQBseg+N/Q+IMOnpaN3LXPtFKjG10zRyVkzVOpTOi0sy0ECyOAKlu0JVs4A2wHYUPjXXrtkQKg3cmUJRw+nJnKYtPPtoeIt/nEPdQpUZ0BUMixGEQMEfZT8tNfbyioJgp9VvxEvr+NqdsVRhvz4C3StmGh49EvdAXC4qhYUTeBsoGDrhAND8tQ+M+Q9RgdL50qa22bCX/iOW0XJAEgyPaBJ8vRkLnjVVERwJuD+HqOQFCNmSxQXrw2M5OdbP6MsWpmSQfiTUoHq6vBTXinfJ1KKmfSy14bmTsZWPu/KYmqambp81ztyTVJl0LNxTIPO8aX20He0MVI9Xm7/RgGCakRECspx4onApV4MCrwqaW5cfqTS2cyx5ajcQAdNskZYqrLc5dl6ZHmJRb+8TxJ5P2u+Hej5Gn0jJg9YSwDT0Rt/YxqNbKLmxwZZQWkx4tYkkrVEoecEBRV6oa+PFRWOZfo2bRvNebMALbp+2PZw+cy3aQtL3P0evImd0qhBnVAavF
 Es0knce0
 alkeLsZmyfmeQ3A5/VgAor5ZK+w97q1nscGcgBiJ+jjnve6j2pBtDS8Ko7m+jXxovAj9HSv4o2qHTwNgdx5XmGxy2n/jitkbRdAN7yXVEyRYe0M+LRMUhNOHRVRprzLfDsk2FoefnOr1G0WBNV5Qh3XEjWgmMc4KorAGDSwXhmMevYE8xeCCOW+6G5FAGOXcJ45f9iJnLHQm6VvR+ZEIzSlm3+E3p35A1pSvBwJvoYGpbxqea7t3e7AYCR7ez2IYZ2aAvNBCVgbIkPU/R3KH4rqvK4/JPsv9JQzqx69/tlDHVTkIW7vq3BHAoyRob2pN8e9uCKOiqdn0Oju2ij/B9YojNTOIpDyjhRwMkynW9BmSWoro2mmdpmACnSIyNImbmVACi8xnItyEVgbeo6gXwc1IIsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 01:07:04PM -0400, Johannes Weiner wrote:
> On Thu, Jul 23, 2026 at 11:58:27AM -0400, Gregory Price wrote:
> > 
> > I lean towards Johannes' stance here that consistency is better, and if
> > KVM has a known-poor interaction with numa balancing, maybe KVM should
> > simply set a default policy (when none are present) to avoid this.
> > 
> > That said, this is painful because MPOL_F_MOF / MPOL_F_MORON are already
> > a silently inherited policy on boot (added during init).  This will be
> > confusing for users.
> > 
> > This is not documented anywhere.  Maybe this change should come with a
> > docs addition that says the default global policy is ACTUALLY:
> > 
> >    MPOL_LOCAL + (MPOL_F_MOF | MPOL_F_MORON)
> > 
> > Instead of just MPOL_LOCAL and letting that silent implementation
> > detail bite people.
> 
> Hm, where do you see "Instead of just MPOL_LOCAL"?
> 

MPOL_LOCAL is effectively the default, that's what most people expect.

> Documentation/filesystems/tmpfs.rst says it defaults to "default" and
> points me to set_mempolicy(2). That in turn in general makes little
> mention of numa balancing and doesn't mention MPOL_F_MOF/MPOL_F_MORON.
> In fact these are documented as internal flags.
> 

They're "internal" and generated by passing MPOL_F_NUMA_BALANCING...
which is basically shorthand for "use (F_MOF | F_MORON)".  There is
no other user of MPOL_F_NUMA_BALANCING.

The internal/external state of uapi/linux/mempolicy.h is frustrating
to say the last.


> The numa_balancing entry in
> Documentation/admin-guide/sysctl/kernel.rst however DOES say plainly
> that enabling this feature will sample and migrate mapped process
> memory to where it's used, and that this has a performance penalty.
> 
> It seems there is a general lack of documented interactions between
> user-requested policies and the system-wide numa-balancing behavior.

Agreed, that's basically what i'm pointing out.

This is what most think they're getting:

    static struct mempolicy default_policy = {
        .refcnt = ATOMIC_INIT(1), /* never free it */
        .mode = MPOL_LOCAL,
    };

This is what they're actually getting:

    struct mempolicy *get_task_policy(struct task_struct *p)
    {
        ...
                pol = &preferred_node_policy[node];
                /* preferred_node_policy is not initialised early in boot */
                if (pol->mode)
                        return pol;
    }

    void __init numa_policy_init(void)
    {
    ...
            for_each_node(nid) {
                preferred_node_policy[nid] = (struct mempolicy) {
                    .refcnt = ATOMIC_INIT(1),
                    .mode = MPOL_PREFERRED,
                    .flags = MPOL_F_MOF | MPOL_F_MORON,
                    .nodes = nodemask_of_node(nid),
            };
        }
    }

So the default global mempolicy is effectively:

    (MPOL_PREFERRED | (MPOL_F_MOF | MPOL_F_MORON)

which is just MPOL_F_NUMA_BALANCING without MPOL_F_NUMA_BALANCING.

The user can't actually see that - because the MOF/MORON flags get
stripped out when it's queried (because they're internal only).

Maybe we should just set MPOL_F_NUMA_BALANCING in the default/preferred
policies and document that the global preferred policy default-enables
MPOL_F_NUMA_BALANCING - and that if a user (KVM) doesn't want to be
affected by numa balancing it needs to set a policy to disable it.

~Gregory

