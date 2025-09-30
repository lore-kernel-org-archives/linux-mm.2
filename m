Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 169ACCCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 20:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3E498E0005; Tue, 30 Sep 2025 16:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F162A8E0002; Tue, 30 Sep 2025 16:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2B0F8E0005; Tue, 30 Sep 2025 16:35:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D2D9C8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:35:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73AEA13B399
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 20:35:45 +0000 (UTC)
X-FDA: 83947072650.12.8F0F15F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3D5E0C0013
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 20:35:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C1W2Us7S;
	spf=pass (imf22.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759264543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tcdjHj3hrCi2n9CnZqBqMGWq7DhDnkuit40Rw1hplXg=;
	b=HqjluY7uu+BSiVzK8M0ieI7nGzDgdhoBRWTG1k2j4jGIRnFbY+JrLgoc8m/pbuNOG65KsQ
	nZtHlSQyqX4UW9ze2CtUlOAKSPaCj3vaQRUPorgycRScPMpIr4PAwqrJVmHSBTH02r+5xF
	l6YASyIkv38D706oXGsJC+aKVnZBvbU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C1W2Us7S;
	spf=pass (imf22.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759264543; a=rsa-sha256;
	cv=none;
	b=N9Yf3MgadovrefYJ8QAjQOfBVACV3IhPE7AJqvE/4M00layAlG7EeJBQKD1Oz91Cf5whze
	TZ4J9dCDOleg91Eeu6bGB/o4r0zX6XuF/T984rIsDZ/ZjBXSEX1iPmK9vvmBbCNMPSOML0
	eSg+yZAWVTheQKWGBBbiDtGKos1Stng=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759264542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tcdjHj3hrCi2n9CnZqBqMGWq7DhDnkuit40Rw1hplXg=;
	b=C1W2Us7Sl+/zGVZiX3qGywjWZovX0S1SFtGYd0q/l7QBL4ZysYoGMih/2M3Ntm+LO1qdYf
	cuzaWSvhQ9ZZJzBvGwJuRLGnSfHvap1mQQVvDPDwUsmdp++j6X8ngCh5rwVxztJVbEGUNW
	iwVQJSfvvq+ZAWOLfEfRe08lKNv1i0M=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-246-Af90EKV-PQ6CumuUGM_fqA-1; Tue, 30 Sep 2025 16:35:41 -0400
X-MC-Unique: Af90EKV-PQ6CumuUGM_fqA-1
X-Mimecast-MFC-AGG-ID: Af90EKV-PQ6CumuUGM_fqA_1759264540
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4b78fb75a97so67227211cf.1
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 13:35:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759264540; x=1759869340;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tcdjHj3hrCi2n9CnZqBqMGWq7DhDnkuit40Rw1hplXg=;
        b=EmsCQdymy7RNUx3oz/HQYpY3GSZSZyKhjTlWkjJdrMkkKUximi04Cw6mwZAVtHQFsR
         m4TQ+ohyGxiY6wLkQ3kAd4jcFfXjn2rOJT7zB3mibJf5fCGKZW3nsHvyasrKxrlpwQLv
         zuy1Yo9OyLkhaY/PW8ZnNeClxz4f4z8+Zf47LuWwsgQ5BHW67XSVjfRZ42opUSGIVxPP
         FDaeNOOTedBY7F3mM5ONvlGbspf8QUDOO/KcOhrNWk/BHpgE1kkoUaxxAeW2nAy+g84D
         g1Fv+svNkolc4XroCBklsfwprjzHhf2+0mX8OfKqQv8dvZiwZ8JzjbuBNEFQ/Yr7GmEQ
         Nztw==
X-Gm-Message-State: AOJu0YwvPHiJarojdTPm1r7GKgxsWyoTlj83GlrJrVS8t4nRjrbWHbcG
	mWiCwBlFFGRrJgQyho2zqsqUzttivJWPBbIZW3KhKTFdrgxBFB1t8zEVPxQbwkaoavGUaDK3AT/
	MnNPTPCDV5PDdREOgC0UOHNj07S6MZcQB4xT/d37GyOV8uQp1UI1G
X-Gm-Gg: ASbGnctEh6DISQUnykNusLltAJl046k3ceZKvexoyHOGKFLCYk8T/8A9e3cl/DbDK2R
	jq0uytm7nyF9uAnRI2h9DwmJfcK9CrkQMITAPTaU2HAkjYs0DoT8xJBrYr/xEBZyZdHb2vSORW7
	ZuVMbi0oxFwrWQm0n1hPgeqI6t9vv/0IhYk7+QnKmznjdMXJhPW7BGVYfdAHNHCv+047g08wSN7
	4TKfkI04J+ewf/jVM5h5rWPGxurCZf9H6PbsaUYGdxVqx8Y3Nkk5pszL3ooVACCUp00XEv7GkKI
	Sxqkb2ZHGcORpzEL1XSuZKy/f9t2BaanLCl5hA==
X-Received: by 2002:ac8:525a:0:b0:4cf:c058:96f8 with SMTP id d75a77b69052e-4e41ea16a4dmr9675211cf.75.1759264540407;
        Tue, 30 Sep 2025 13:35:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRFvQ7iweHJJXKuRSbPcafJqC24Mx1TFX1nNEJ4hnhKFuws1x28jLXszl2ahz6F4cqkhz+GQ==
X-Received: by 2002:ac8:525a:0:b0:4cf:c058:96f8 with SMTP id d75a77b69052e-4e41ea16a4dmr9674851cf.75.1759264539936;
        Tue, 30 Sep 2025 13:35:39 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-80cd172fd3esm95716896d6.27.2025.09.30.13.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 13:35:39 -0700 (PDT)
Date: Tue, 30 Sep 2025 16:35:38 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aNw_GrZsql_M04T0@x1.local>
References: <20250926211650.525109-1-peterx@redhat.com>
 <20250926211650.525109-2-peterx@redhat.com>
 <f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com>
 <aNwmE11LirPtEuGW@x1.local>
 <f409cbe7-7865-45ab-af9a-6d5108bc5ad4@redhat.com>
MIME-Version: 1.0
In-Reply-To: <f409cbe7-7865-45ab-af9a-6d5108bc5ad4@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BaN5imEnCpW4WETLTQjVfPNRlM-b86tM8jPNGrjfATo_1759264540
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 3D5E0C0013
X-Rspamd-Server: rspam05
X-Stat-Signature: umsrdfhauof8o1f34b9zwy91rpo8dros
X-Rspam-User: 
X-HE-Tag: 1759264543-890736
X-HE-Meta: U2FsdGVkX1/8vTQeuyqi97GkTuROAckYyy6Yc+668ImffrGifNsAUKTlxCI0bmXgCzgvi8fYmkiNzA9A5JlzG4k/k29BLJt15ZZvzerBj+/wP4lsa6pKQXBxpXiwQQgKVOZ+k2psWduGNUTHvK41Hm9HTvJ7qtP0idYcH6NLRu9rIrZGoF1dRsxMecbcLuv2fBq4M5D/sAwiDYsDChYrhI9s08J/wyhl822sIm3DmF5HyOgeQidkik4dF5oh05nUaPyHqMEmdNy9UYv41mj5aX1XXt+Ho5izy6QDEE0+yxVnb5zknO4UROmHuOELTspT3th1xEdq4dTkVEuN/fwYn8YPOqD9gTQctXssueCqYSzvV3G2Kozk8VT0JHZzpE5junQMkEA/L9618M1A4GCY0BeWXOYdx7tpnlynZQTL0Ez9veEPmcPK9F7MxO3tG2XF6gac28oLL/2h27h8S3tGug3W2rT64z8EtIbiJTXUp27fwim337Hb/zzHhMDw1hB3ARZ5/DLqElGj57YI51njLjvF9EBiO88DrYdYzkXW9apSE/Iiq5lawa9CDTNHHx3m6W0XjH0NqiLjMMEt4LE1juCdnXKRNj/lrqct3HjOHdatefVLJ7sLxAVTvOm2nPdL5ieP0+nqcn/o/vxdB9rpwcfYy6TBlmDlRFDqgrkAYzxuweblrNBiEQufUJbPWruzqjMZgdh8q2PYKl6SUCgad2kk2V5r2ZAimhXHuOPXkncd4N0k8DBXMtWqFcpbthkfWWKb3O5sSznyIgUePRVCMoX+OixVApx8J349RhkN5oyyvjXBErK27ExdnWfUaRxZJTcktRFpYW9NmjafXEaVa2QtQrGQYsUmatTidPNqoFyb3Ck5SeypthOaXFvqcQpW7KBq6gI9zIGobCUwpGrdUeQE7tg16A0Ii4QZB5DU6aLRNkH2Q/immAClPjXDOzhKrr8gZkxLBWuY6qwRgLX
 8RAJ5Z+u
 +8IItFFwq+4y+q11BK6Y26t/ZKRXCmyxzVP+9wUdwbScdvC3SKGJXk9AYtJ1AGz8w9vTD0jPkVWaTv64gkRv9YgdoqwaEM632GFizUxFU8dL7jJjZkoMPd7gipd07XTyZ9OyiWGPDEXw9I5ikqYsKoel54QsghifFZAb2Z2QI+Gqm/pgZglj4DQVPJoGBwwYq/Tu4d+kOIAOiYfYErVV0IH+3j9Sm8LVL20KRGkO1N78jMac5egzcByDsHxnJ50zaOnrOgzAnclLpRex1M64W5jUNgYNgj6MzRHEF8phcYnV6Bfdc2J/slgUgrm6LkBj2r+1kjmWpQGZSOf4Tjr/pCeATPZaDXHmV1FHzjku0HjXwBsquv2zRwn9C7GpePXAmhVEvQevEtFROjrM/fI4uO/toSh95Q08UqfRO8ek6toa5lxm8gs7cM4MUfd8jig7J+XSm52/LiusUxwj+oKI+0gKflqYhy4UKjM6lEbU8e4Rw0tMo11tuyqeKESHkoUR/KJo1VLRJXweL8JPXw2wd/uNfser1Ke23kqKh9v+RvGK7qRx4oLcYqdVY5k3karKzNq1aNoI+dpec1lE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 09:19:05PM +0200, David Hildenbrand wrote:
> On 30.09.25 20:48, Peter Xu wrote:
> > On Tue, Sep 30, 2025 at 11:36:53AM +0200, David Hildenbrand wrote:
> > > > +/* VMA userfaultfd operations */
> > > > +struct vm_uffd_ops {
> > > > +	/**
> > > > +	 * @uffd_features: features supported in bitmask.
> > > > +	 *
> > > > +	 * When the ops is defined, the driver must set non-zero features
> > > > +	 * to be a subset (or all) of: VM_UFFD_MISSING|WP|MINOR.
> > > > +	 *
> > > > +	 * NOTE: VM_UFFD_MISSING is still only supported under mm/ so far.
> > > > +	 */
> > > > +	unsigned long uffd_features;
> > > 
> > > This variable name is a bit confusing , because it's all about vma flags,
> > > not uffd features. Just reading the variable, I would rather connect it to
> > > things like UFFD_FEATURE_WP_UNPOPULATED.
> > > 
> > > As currently used for VM flags, maybe you should call this
> > > 
> > > 	unsigned long uffd_vm_flags;
> > > 
> > > or sth like that.
> > 
> > Indeed it's slightly confusing.  However uffd_vm_flags is confusing in
> > another way, where it seems to imply some flags similar to vm_flags that is
> > prone to change.
> > 
> > How about uffd_vm_flags_supported / uffd_modes_supported?
> 
> The former would make things clearer when we are at least not talking about
> uffd features.

I'll go with it.

> 
> > 
> > > 
> > > I briefly wondered whether we could use actual UFFD_FEATURE_* here, but they
> > > are rather unsuited for this case here (e.g., different feature flags for
> > > hugetlb support/shmem support etc).
> > > 
> > > But reading "uffd_ioctls" below, can't we derive the suitable vma flags from
> > > the supported ioctls?
> > > 
> > > _UFFDIO_COPY | _UFDIO_ZEROPAGE -> VM_UFFD_MISSING
> > > _UFFDIO_WRITEPROTECT -> VM_UFFD_WP
> > > _UFFDIO_CONTINUE -> VM_UFFD_MINOR
> > 
> > Yes we can deduce that, but it'll be unclear then when one stares at a
> > bunch of ioctls and cannot easily digest the modes the memory type
> > supports.  Here, the modes should be the most straightforward way to
> > describe the capability of a memory type.
> 
> I rather dislike the current split approach between vm-flags and ioctls.
> 
> I briefly thought about abstracting it for internal purposes further and
> just have some internal backend ("memory type") flags.
> 
> UFFD_BACKEND_FEAT_MISSING -> _UFFDIO_COPY and VM_UFFD_MISSING
> UFFD_BACKEND_FEAT_ZEROPAGE -> _UFDIO_ZEROPAGE
> UFFD_BACKEND_FEAT_WP -> _UFFDIO_WRITEPROTECT and VM_UFFD_WP
> UFFD_BACKEND_FEAT_MINOR -> _UFFDIO_CONTINUE and VM_UFFD_MINOR
> UFFD_BACKEND_FEAT_POISON -> _UFFDIO_POISON

This layer of mapping can be helpful to some, but maybe confusing to
others.. who is familiar with existing userfaultfd definitions.

> > 
> > If hugetlbfs supported ZEROPAGE, then we can deduce the ioctls the other
> > way round, and we can drop the uffd_ioctls.  However we need the ioctls now
> > for hugetlbfs to make everything generic.
> 
> POISON is not a VM_ flag, so that wouldn't work completely, right?

Logically speaking, POISON should be meaningful if MISSING|MINOR is
supported.  However, in reality, POISON should always be supported across
all types..

> 
> As a side note, hugetlbfs support for ZEROPAGE should be fairly easy:
> similar to shmem support, simply allocate a zeroed hugetlb folio.

IMHO it'll be good if we do not introduce ZEROPAGE only because we want to
remove some flags.. We could be introducing dead codes that nobody uses.

I think it'll be good if we put that as a separate discussion, and define
the vm_uffd_ops based on the current situation.

> 
> > 
> > Do you mind I still keep it as-is?
> 
> I would prefer if we find a way to not have this dependency between both
> feature/ioctl thingies. It just looks rather odd.
> 
> But let's hear if there are other opinions.

Sure.

-- 
Peter Xu


