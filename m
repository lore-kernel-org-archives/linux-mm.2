Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AB46CCD195
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 14:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50B238E0014; Thu, 16 Oct 2025 10:17:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E3118E0002; Thu, 16 Oct 2025 10:17:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8998E0014; Thu, 16 Oct 2025 10:17:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CA528E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:17:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C29901DFD71
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 14:17:33 +0000 (UTC)
X-FDA: 84004180386.02.F1068DD
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id CEBCA1A0016
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 14:17:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GVVnseUS;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760624251; a=rsa-sha256;
	cv=none;
	b=GNTqQgGYugDMAuj1762neHtL/NOnnxHHLwoEGF86D3EzSQBBGZAP/8TkEPk9MpTsbQCtns
	qc+28KWWfrck8DAOlPxP3JQ/pVuC5jmmt7pcEiqVbJtgtRLXdqPXPZvNbYw2goyZnt9+Nd
	Sj9p1XBC6JM7cIacGRZHMaRJcVYhIms=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GVVnseUS;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760624251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vDx8+7T+MYrCmWnRteKVa1iC6/sCWZvHc99T+OB8RqU=;
	b=w+zBTzgVU1ck1xLrJ9GSl5Lhlzz7SzBUFqHvs7eq7HIVnpjZDLaWGW2vK7GuiQCIGtB1H8
	GVv6ZsArHunwfxwOJz0lT+jPiwpgQ40V+uIJnYvuxpHMfD0JPWphSvfiL3DDhFzTH4hmmQ
	AKVjhhPI5rcaLQM5eKhZ+i7A44UVy3A=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-87c1a760df5so11184146d6.1
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760624251; x=1761229051; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vDx8+7T+MYrCmWnRteKVa1iC6/sCWZvHc99T+OB8RqU=;
        b=GVVnseUSEHU79pgSY8IdwYlCYE5GVdXxijx7T/DuSHil9jqKhm3t27MTVvVx4UsaLX
         ITpY++gvnskPbOHBJwRckUs+5Kaw562Nh3SBlDBia0FSchBoWSEXWrw9EEDsBEAEJ/dQ
         fvGahLRowvdzqbizppjT7hzHlmUofV3zo7XhyUkt4yk2GlZPIoLoy8lvCXnzgj8HM/EO
         mWTFq+wFVj/96JbniZWXwJiQt5q5jYMZqEg9ooad+CQQru62QLm6L5kjBkV4p6JGylUt
         Gwd4cTh28toRb1wFs6mp0pDBNm6GIG4EAZzVbX7SU/9JxYuMYVp/HAge+NUZNtdsSMjR
         Sjow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760624251; x=1761229051;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vDx8+7T+MYrCmWnRteKVa1iC6/sCWZvHc99T+OB8RqU=;
        b=m12u5OtFMxsj0wPjTuCZu+uQ/EaQgj8rDaATtMlMltin00d3j9ap/6M3bngh9DVgdx
         9QscpuzqJknyteaIyuBf8r/anPDvU7BUbpJbyxR3/vf0J/knyT3jCW3kfx5TSuhB29nG
         AFQ/gX+e6GuSI737pT1MRgD9W8kXmu5hovSx25jtcLZYSFgO1LXqvAOsKWs9zqWSKlrW
         I7ftK+UZVbiofsQbXhNZkz/HI5Ex/xrWvcuZ9ZmWyqlOOmIBpbB6dnV2URvezFsMzeDE
         QW9RDh3J3YMca5sT72Ee1rWpxSliewkWRqz6nXTCoGOYRmfIbpM/MjyRKgjIb4e/nF16
         9oBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcXJ/7ajEJ+xPHvXgbdIbEmXh9vnAFg/JixfDXVN6/1jAgHEK4aWbSp+zNqT/1Bf2A1haUtdnDiQ==@kvack.org
X-Gm-Message-State: AOJu0YwwijZgOdxSA3AySoqR29uodIasflWL54Qnuxv6NXuC5LXyAKkd
	u3dCwdE7F/3E2P8VgETih3lNKp9WO1CTtFevbi1RJVD7UB6Mr0mW2AZy/912kwDzh3k=
X-Gm-Gg: ASbGncvbkZpKKYX226qxTt+8nlEd1za7746GbvtM+JSrbD37OxZtTnM/BKdHImjyymo
	zvN3Jf5jud9a4aehTVrdVqeQd0ep0jeXdf6c/eBxVqTNP6n/og5fXFtsp/UYxW9ZRNeijQOkrZj
	v+9MyIdwQCNKyiytvJqhEOAjVF6EuPbcP8bjxgQO/iaSRNGEbBFVSEtWZJChxDyX0iaElL7i0bv
	8vX0RujqHyZiWo200Wm7LTAQ8VlK/NsrCvreSl4dfzBd3cmFFYZVwTvFd33cWEc3c+oYSIarRle
	bxp56UQj4SCu0jhIiVQx9uAHlPyaIN2t7kbAUnK41hldQ+bLGdftPtNufRsByh5y+lxQf5Clejw
	3iGaIzEBpy/ksceGGMqa0oPhFoiEnzu0stp/xP6SY2x59+a/9yIdISEyiy/3W9rHAiUmNTQdqAY
	iMGObtD/9bUmnCF5edItTlg6ZDgXD0ioljiXOjKLxUupPaxGBv5PskmodmnK7uIT3iYy3MKg==
X-Google-Smtp-Source: AGHT+IEMapVQRI0ck2KCGxvEYuBB3a+08a/2JspNz86EbcND1SGuRInp+B2xwxF3NumJMeFQLVJPkQ==
X-Received: by 2002:ac8:5883:0:b0:4e8:99b0:b35e with SMTP id d75a77b69052e-4e89d263140mr4179321cf.30.1760624250594;
        Thu, 16 Oct 2025 07:17:30 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e8955b07e9sm13309541cf.27.2025.10.16.07.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 07:17:29 -0700 (PDT)
Date: Thu, 16 Oct 2025 10:17:25 -0400
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
Message-ID: <aPD-dbl5KWNSHu5R@gourry-fedora-PF4VCD3F>
References: <20250827175247.83322-2-shivankg@amd.com>
 <20250827175247.83322-9-shivankg@amd.com>
 <aNVQJqYLX17v-fsf@google.com>
 <aNbrO7A7fSjb4W84@google.com>
 <aPAWFQyFLK4EKWVK@gourry-fedora-PF4VCD3F>
 <aPAkxp67-R9aQ8oN@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPAkxp67-R9aQ8oN@google.com>
X-Stat-Signature: hff518dqdm9dk3d75i9weo7u4bmujf4z
X-Rspamd-Queue-Id: CEBCA1A0016
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760624251-634579
X-HE-Meta: U2FsdGVkX18xz4YxYHaxgy/Nf+gZwqrdowrWT9waPFHtHf938MwaWI4BcF0lAm2rhTQuby09gE3p7T7+N40NVGSPdAaxohvXflRmIwdnWAmZDmItcLTjMcFSq+OjFNuU2azUC7TUDVuObFVKTQUiQBrAvklbG2dp9JC0KqoSj5mN3Ej45Gtu6VRZBwLkHLze0XaVPnCQjmeh+VU2OXjUnwZHSFPC8o0W4McJhQrYEiEUs+vE7kJ3tF1IpIQ8azWyftCV+aDsD8lzhmJcX4oS34SPL64IkPuoKVD9UtLG+g1LtM1xsdAHMep1Pd+cO4mZ/7ObriiAGLtTkpRLgBbDrRrR6vnv7ccvMCaswdy1Oupw4ZR5H70ekSkpbEyM4BeaKCWWxZ1EUvzKTdUF5pPMZ4JZ57DhTbzaG/Gf3pefQ7PyvmGCz5i3r8Dx0bSYbJ3aL6Ix743S0poSqggkEdv6Ezurblt6XjdPlir0/hsRvSNzENcFxq1O6gZYI8dT+1SRNrC2XaKvavqC/NBrmpVOf6lVchUo2wUcNh74tz0yPVroUpp0s3SO8mLIgus2OacHRv9DBo+NkIwiFjFVTWktcEoCQAj0qtLd54hJ4fZd6t9ZELIts9vJdTY7eSkWok+3L6DdfeoxV9hXrSaVMeY+pFqOzBFPPU4Fwuh4Up3P8gYvOvwZdxabTxZL4yShDge/Vn7UOUGopB+a2ydYTiPbwPVDsCkdURQXijldrMTrNoaYB8KIPQI+SseMbiZjvS8tVYxJXoTeIoDjTmsv4qIKiSZuTQqyWeb5slYCLokJziRevCMHE+hrr5VNAAV01qwy2dOj6jNW1R0uNYG/4MmpArod1HeYNBEru6YMv4r2hPgUPO6JNgyseEu9vW946CelSpzNWtnwd7K1ZZwkfYeRQcd36o72w4AD0gYAQy717u2G0NYWlCBATS4QJIj8cmUK9174/75sHWpWuGJBlnt
 PpWLEJ97
 h0tIR8rSSMLVF/YlISpzvJbGByxbzyGubnztNOoxkIHE0LkQ93yHV3dsq0pjbDvcdwoOMARu+FP6ZA3HVRskaK3Apc/mNbJFwvpRLg56ZBPVBhYaZEWAkkw88V38qZSaIu6ul5emy/j7U6Cgh0OACyn96ZXsMwJvA+TM7TYER7aZ/754ihlh+45q8gD/Rm4N8QH6TUCHRpf7X+4E0MIaNX7gyTx9/Ss9Xqsc1WQwt1rBdIQrZlyfgM2kdHDgVaLJx6vrn1rhMU5fDoO+uk7RsgtlqSz8JgFLaGfKCvGVFwEhF2J8bFHiV7CakZdDrZkT3ugd8uOe+4sSsvttCCgG8k0FHCPTYNqtNJzFSS79h6aIrg6jZbMojmVEzTYIet8p3zml/1JJLrz1j1K1fZYYrU7McZN3Rt8gGB8O/pnhdNAoG4UWutd7chvP92iW1rdsFMKuB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 03:48:38PM -0700, Sean Christopherson wrote:
> On Wed, Oct 15, 2025, Gregory Price wrote:
> > why is __kvm_gmem_get_policy using
> > 	mpol_shared_policy_lookup()
> > instead of
> > 	get_vma_policy()
> 
> With the disclaimer that I haven't followed the gory details of this series super
> closely, my understanding is...
> 
> Because the VMA is a means to an end, and we want the policy to persist even if
> the VMA goes away.
> 

Ah, you know, now that i've taken a close look, I can see that you've
essentially modeled this after ipc/shm.c | mm/shmem.c pattern.

What's had me scratching my chin is that shm/shmem already has a
mempolicy pattern which ends up using folio_alloc_mpol() where the
relationship is

tmpfs: sb_info->mpol = default set by user
  create_file: inode inherits copy of sb_info->mpol
    fault:    mpol = shmem_get_pgoff_policy(info, index, order, &ilx);
             folio = folio_alloc_mpol(gfp, order, mpol, ilx, numa_node_id())

So this inode mempolicy in guest_memfd is really acting more as a the
filesystem-default mempolicy, which you want to survive even if userland
never maps the memory/unmaps the memory.

So the relationship is more like

guest_memfd -> creates fd/inode <- copies task mempolicy (if set)
  vm:  allocates memory via filemap_get_folio_mpol()
  userland mmap(fd):
  	creates new inode<->vma mapping
	vma->mpol = kvm_gmem_get_policy()
	calls to set/get_policy/mbind go through kvm_gmem 

This makes sense, sorry for the noise.  Have been tearing apart
mempolicy lately and I'm disliking the general odor coming off
it as a whole.  I had been poking at adding mempolicy support to
filemap and you got there first.  Overall I think there are still
other problems with mempolicy, but this all looks fine as-is.

~Gregory

