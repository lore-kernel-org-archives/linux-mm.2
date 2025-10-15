Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3770BCCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 21:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77AA18E005D; Wed, 15 Oct 2025 17:46:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7520C8E0027; Wed, 15 Oct 2025 17:46:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CD7E8E005D; Wed, 15 Oct 2025 17:46:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 475A18E0027
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:46:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC8A2B6EB7
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:46:04 +0000 (UTC)
X-FDA: 84001681848.04.F4BFD6E
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id D11F240014
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:46:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="oTx/jY2+";
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760564762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L3FMg1FEv7ZUbFziIBjfrlMH5r4d6/IdcxKlJL9nOzQ=;
	b=t1lcXeED3xd1Wptr/VN22LXYUgKj9zkydT6plMvK5yvXTu+FUIsGDlZTCHqMUEgSvxvdUH
	7i1SMQ0lGG4wy83mRk2OJxQkS1Ny9wLhaa8aTpFhI1VTC2AT3MTRMrOE9gNd06fpYYrgLr
	8x5BjzcqoDV5IXLAZ+QkdHh65Bw7Glw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="oTx/jY2+";
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760564762; a=rsa-sha256;
	cv=none;
	b=czqsbNZJNTSR+shAh5Z9RzsIsYiGzQAn4RTkdZdqUVqA6X+OhOymHLc1xSzWLcMe162MPW
	EUjKvBu3Ph30yhQtiGKBS+t/Qq0A6i0dJFrHv5zpV6kwdTalRI+mNQkW5ocofOm5/ZqhKo
	KxPvLg/tT7kMXGR2/mq0vPMT8L4JXUA=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-85ed0a1b35dso5188885a.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760564762; x=1761169562; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L3FMg1FEv7ZUbFziIBjfrlMH5r4d6/IdcxKlJL9nOzQ=;
        b=oTx/jY2+1jR1uEOQNAl0oW0ZL46bsz2uR0xBrAW8XkaHmD9ONTlxzM/uoxUnroW4ep
         4fIRv7OA6brwXtpqIOsdAGo8+TYAylh5UBbG6Kzkuv7GEAM371/1MF18e6WzoB0ackjc
         eC9nHyYb0ATMyQjvZRn7RXEGXGhmQwlV+8KIZkyP6dNPDMNVc0sV8tCtgtAf1fMrxQk8
         S16ryL4cmKz7HaJ2IA7ilGzhGLCvAkyZRr63wyuDyPJGxYrc436fyLEvbZc35oPR+abm
         2O/VNRl+ioFCUze5hePkgInphaqRfAXxoUpC2NKiM1XQholdfAKw1Sc/BRnvLrc47a5p
         BgGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760564762; x=1761169562;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L3FMg1FEv7ZUbFziIBjfrlMH5r4d6/IdcxKlJL9nOzQ=;
        b=OGkg/3B6TXd3tn1RLGi0B1fV0NcT4zto6P0a26DKVjxQtzRjIt23Mgv85hEOJtHZz8
         O/wC1kGCakj+LJcUWGisi847ZTtRpYh7+37nclm+LHYHiXklOQPryIyCNHfkdmQhtNLL
         4HGG2rNfdG5ragwCIrdi9J9vnWb6XNusku+jdjfyjqfz9CHMZl/frDTRpTABFZ1s2u/W
         VUZT1wpz/dC05EyJU0npmFk7o3Mx3Nk+pFCE84zdSD/k0S63HnLglI3AjUekfMdRxPC4
         KoGAPbjMktgeH6RhALyY+eeVNNNbxY/ZWXQm9L1xyFNQkgk4PMOLok14l5uS/mZGMzf5
         NqUg==
X-Forwarded-Encrypted: i=1; AJvYcCV6UhYu3GHOkl3sE/fKGqd403COQVDQGFQ1/XurAe8SJSXbeCV59svE2BS7aoYrDxbUerws7qO/Lw==@kvack.org
X-Gm-Message-State: AOJu0YxGJ0opmh98l90+LkUq9KQFQA3kGUYG+Q+ZxmVQDTkGlwYsN45x
	XeSOWBiJqDTpKdqh07z2R/n10zpBabKx4IARHZsR/kKj5sjzF4QSGYk1VF+HsIHYPn0=
X-Gm-Gg: ASbGnct/7pcJj3+DySUTsBXPLBtLDyOs3eOGHTfuE5Z87x4E3jpCrSpYmHf9te0ZHAm
	hlwpn5IhHD75U5VXQjCD1x1lRjqoFMxQkJh3YyJjOy3CuyQnDW1MYlMlEC6/odq7oMq9wbKNNZc
	0tukdFtt7ZHcjpYQbdWNEHj7TpbQKn/AY0Z9kO9ze6Atfx33F+RKuraf6jatIPKmSibauwpkGBh
	VfOdHw1HZPkdsWVvFjfVigfbLQ898uTQArIxFYw6eLB7pep+AosTTvvebqnY/0ny01L3wuFjXgj
	NMANDoyEqrKra7o5hhJLmFalL5sngq1jtcbyR3ODLocab3zXVHuPZIdaYeDOX2akJhqUvC4y0Ym
	UIQX1EOyEU+JGw5Fr3jix1gCSOY/sbxnMIJ6uH6OuMIMMhoMwJnqgJ5co5wGFI3Pq3f3kVuVmG5
	vFdsCgjEniCJyuz6Adh6+7OerXItG0yxHFXXgbmL7rhNaB70LHpqV8Lk7/GPlQAa+AXkZI7g==
X-Google-Smtp-Source: AGHT+IGFaJmIXEF9qOWREfnISohaPtcOawCiX32gOo0axLN0cRb3DCKNrFn66v9UE7KAPGfO0N4wTQ==
X-Received: by 2002:a05:620a:1a02:b0:88e:86a3:98f1 with SMTP id af79cd13be357-88e86a39b78mr380325385a.45.1760564761659;
        Wed, 15 Oct 2025 14:46:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-88f37e50ebasm56360985a.31.2025.10.15.14.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 14:46:00 -0700 (PDT)
Date: Wed, 15 Oct 2025 17:45:57 -0400
From: Gregory Price <gourry@gourry.net>
To: Sean Christopherson <seanjc@google.com>
Cc: Shivank Garg <shivankg@amd.com>, jgowans@amazon.com, mhocko@suse.com,
	jack@suse.cz, kvm@vger.kernel.org, david@redhat.com,
	linux-btrfs@vger.kernel.org, aik@amd.com, papaluri@amd.com,
	kalyazin@amazon.com, peterx@redhat.com, linux-mm@kvack.org,
	clm@fb.com, ddutile@redhat.com, linux-kselftest@vger.kernel.org,
	shdhiman@amd.com, gshan@redhat.com, ying.huang@linux.alibaba.com,
	shuah@kernel.org, roypat@amazon.co.uk, matthew.brost@intel.com,
	linux-coco@lists.linux.dev, zbestahu@gmail.com,
	lorenzo.stoakes@oracle.com, linux-bcachefs@vger.kernel.org,
	ira.weiny@intel.com, dhavale@google.com, jmorris@namei.org,
	willy@infradead.org, hch@infradead.org, chao.gao@intel.com,
	tabba@google.com, ziy@nvidia.com, rientjes@google.com,
	yuzhao@google.com, xiang@kernel.org, nikunj@amd.com,
	serge@hallyn.com, amit@infradead.org, thomas.lendacky@amd.com,
	ashish.kalra@amd.com, chao.p.peng@intel.com, yan.y.zhao@intel.com,
	byungchul@sk.com, michael.day@amd.com, Neeraj.Upadhyay@amd.com,
	michael.roth@amd.com, bfoster@redhat.com, bharata@amd.com,
	josef@toxicpanda.com, Liam.Howlett@oracle.com,
	ackerleytng@google.com, dsterba@suse.com, viro@zeniv.linux.org.uk,
	jefflexu@linux.alibaba.com, jaegeuk@kernel.org,
	dan.j.williams@intel.com, surenb@google.com, vbabka@suse.cz,
	paul@paul-moore.com, joshua.hahnjy@gmail.com, apopple@nvidia.com,
	brauner@kernel.org, quic_eberman@quicinc.com, rakie.kim@sk.com,
	cgzones@googlemail.com, pvorel@suse.cz,
	linux-erofs@lists.ozlabs.org, kent.overstreet@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, pankaj.gupta@amd.com,
	linux-security-module@vger.kernel.org, lihongbo22@huawei.com,
	linux-fsdevel@vger.kernel.org, pbonzini@redhat.com,
	akpm@linux-foundation.org, vannapurve@google.com,
	suzuki.poulose@arm.com, rppt@kernel.org, jgg@nvidia.com
Subject: Re: [f2fs-dev] [PATCH kvm-next V11 6/7] KVM: guest_memfd: Enforce
 NUMA mempolicy using shared policy
Message-ID: <aPAWFQyFLK4EKWVK@gourry-fedora-PF4VCD3F>
References: <20250827175247.83322-2-shivankg@amd.com>
 <20250827175247.83322-9-shivankg@amd.com>
 <aNVQJqYLX17v-fsf@google.com>
 <aNbrO7A7fSjb4W84@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNbrO7A7fSjb4W84@google.com>
X-Stat-Signature: i76grczz498fh9cejnxwj8m3semmxm6n
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D11F240014
X-HE-Tag: 1760564762-81299
X-HE-Meta: U2FsdGVkX19qL13qCqyI87eu9Bpa+Pf6atdNbKOVyjCcES3JQ6o80CC2uxLhrCFLVKUjCZ2mH49XT7f5/Ct8CTnyiB8g2kIdmDv2/t4IZiEeBpaeZT5hXJVrLmlmyW9q5y7hwekj2vxILmIOxFiLiSCQ2jZ1xL2wwW6E3Pm4AqayBjCtCzb+M8A2wApImX7eoKmanCxfRH8pp8ui4AWDyoRK6loseBsvyJHDYtTDFxCuZQyIvVMpwm3pW/Aqe1UbJrG/vvmkVPTqFFQNUmiX74roubCXKB8DDhMaTgB2KyAOOS1tzaRcg3DiMocTbxibNg1lz/B1S+HhBQrHxcro4xMnjV+HndjUH3zOgX01P/hgCrpmHZZO0g34ME8Ydv7S626UDkuJBpRqZEuZ3lFT4QNHcQDuoBG7cv3PBGBWfa6S+oCIZe2i6sbNjMBwPdFWd/arTQ3gG56/9qP82bXmq7I9IH++t1VNBvSo/27UGFvUumqzPZcjKfUGyhkZQ6hlzj5Hk8DHNuGJ06t7rxOij5yMEsQU7rOComvQkIBjXRYyYJNCo4P8fM82/G/29tfhqBsaWCxBFjacL7IiFM7RqCqNHIM8I7Mh2/KeXZCC7nQs4fgAYM1ID2RnHdTmdGDN6PvtOy+dExS8cZwdL1JEsK8KWTgmE+x74VjA7oZQtxVrTcghA1beKsGK68bE7SvPic+rhE+hAnz4HgDw/ztrdpMDA6yyu0XIOCSbsxHOfI+G7p9VClrEfUx3BliLt5XB2LdMUwPPMLCE56DDyZDoUrTkzMiDVT8sPyGwLIFNCbpeRX49gE8bhIP6yyvcldx8BRUFtSyNU2ZzFaXEpQ0zyHREGWc+V3bpVH5F0R0YnOhHQ4IQ8IAljMhurkzYFVSk/4X1Dn99eTjskauxY/t15IfD5kDS0Pgvq/E0M26VQT/FsX3UMXcVlgoMi2kIIl8N6NnYmaR5C4vI5yecW1V
 GEkJXLqC
 PlNdKANHOC1LTpDi100WuZFC7ySu5xNRjmNfFcO7AKJThAticp7Px3AVbW/KGtNc0BL5f7KHZnxgelot+XEkD1sNjAvoeuH04bGFZqaYLpbiMGsvm1D5z8kQLJITaJhsNoj4ornft62577jbWfjgINU5p9Pn/J0dnyFmb9InaQTCvl3gBBg05OpIrXrRhFxWjJNnuu94FzNeGnRb++P2bm9BymOpLqW3E3iUemppr9rD1Cu8ccbumuclisJBRxflq84rNx2RvIyQZqNWuCSo/96ZVP+dHZtkGzewPEnkXZLmn/ln5yu1fdEShw+Y/sa+AdukQcE0aLM5bG2VByH9rfw8Y43TGsJVpD66iAoJgUsBKnZVHS2zM4rHz+y659CstFtZKxvOv+WhRt3fnxzyKn7aSB3lueliKer7rJx32xahW/p8wjW6bdzshvUSt5++w2Y8R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 12:36:27PM -0700, Sean Christopherson via Linux-f2fs-devel wrote:
> > 
> > static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
> > 					     unsigned long addr, pgoff_t *pgoff)
> > {
> > 	*pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
> > 
> > 	return __kvm_gmem_get_policy(GMEM_I(file_inode(vma->vm_file)), *pgoff);
> 
> Argh!!!!!  This breaks the selftest because do_get_mempolicy() very specifically
> falls back to the default_policy, NOT to the current task's policy.  That is
> *exactly* the type of subtle detail that needs to be commented, because there's
> no way some random KVM developer is going to know that returning NULL here is
> important with respect to get_mempolicy() ABI.
> 

Do_get_mempolicy was designed to be accessed by the syscall, not as an in-kernel ABI.

get_task_policy also returns the default policy if there's nothing
there, because that's what applies.

I have dangerous questions:

why is __kvm_gmem_get_policy using
	mpol_shared_policy_lookup()
instead of
	get_vma_policy()

get_vma_policy does this all for you

struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
                                 unsigned long addr, int order, pgoff_t *ilx)
{
        struct mempolicy *pol;

        pol = __get_vma_policy(vma, addr, ilx);
        if (!pol)
                pol = get_task_policy(current);
        if (pol->mode == MPOL_INTERLEAVE ||
            pol->mode == MPOL_WEIGHTED_INTERLEAVE) {
                *ilx += vma->vm_pgoff >> order;
                *ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
        }
        return pol;
}

Of course you still have the same issue: get_task_policy will return the
default, because that's what applies.

do_get_mempolicy just seems like the completely incorrect interface to
be using here.

~Gregory

