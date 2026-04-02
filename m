Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E27A9D39425
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 13:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53A4C6B0089; Thu,  2 Apr 2026 09:42:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EBD06B008A; Thu,  2 Apr 2026 09:42:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D9ED6B008C; Thu,  2 Apr 2026 09:42:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A3236B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:42:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C1527E17E2
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:42:10 +0000 (UTC)
X-FDA: 84613729620.30.F6E4FC8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4CAFB40009
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:42:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H5oQDE7Z;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775137328; a=rsa-sha256;
	cv=none;
	b=SBjQ05vmdStSTwzSbyc7U2195kAf6Gm3DLfI5kFx512ZW0KXIG6OPlt5SWPO3sMoIwT379
	XA0fa6qpTCDhSwTNJAvvZ9WDnNKS1yQjuxmwAC5Cmzhxw/6MeW96Nm+/A+zxBxouXNXKD8
	yPOG5QrQcnzLVrEJWvEGu6mX6AAXw1Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H5oQDE7Z;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775137328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yWfsa/6+96oHTl9AiAyQHghAoNdpYCmhSqZ3pWlb3YA=;
	b=pU2mfo3oFGeW6yvrpjL4b3wREu5eSN7a43c67Yz4sdSDL35ewgwv7YJ6XwHv7+4jWI711S
	1vLhdu6w0OMW49L657HEyJScdpzeaXwn19kcpCG0EHDWq2+PCMXs4hYBJMQjSjHqOEshKr
	gp2bURPb9XoP5JNu96zZ4srM5QWu+rY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775137327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yWfsa/6+96oHTl9AiAyQHghAoNdpYCmhSqZ3pWlb3YA=;
	b=H5oQDE7Zo8f52DXblldPI73r1OtP8kOJzFo+gC5H+FdGut6vzH+99+XXF/Tc7xANXKquGx
	aId3pF6npiF+SJfjLznYuay42w47Auhoi+vVoKr9gwswuoI4rF0IvAXm4rH2ZGFVGkl9bQ
	qK5aUxhBniZKrRwBGmx3bz8pIwnal7E=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-119-0Nv7gxTgM8yg4IX9SS-Uvw-1; Thu, 02 Apr 2026 09:42:04 -0400
X-MC-Unique: 0Nv7gxTgM8yg4IX9SS-Uvw-1
X-Mimecast-MFC-AGG-ID: 0Nv7gxTgM8yg4IX9SS-Uvw_1775137324
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-89fa878662bso43184776d6.2
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 06:42:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775137324; x=1775742124;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yWfsa/6+96oHTl9AiAyQHghAoNdpYCmhSqZ3pWlb3YA=;
        b=SyP0++cxcKyuP3cX9XC8IOyh8UMhwS/B6sQcg97kIA69GCznF0AH8rMWUO77hghDwH
         mZwDaKKftFW8yTOKnCytjdsp90JSuLW1nKxhSEFa7dlCrFkHVWeQOsUgYMYmBHCWpMNK
         EanVgB5fIY/xomt8rNW6UKMWBgoWqQ3T9XdL3N+cLnWegwTlsHEw7ZRgFKpAGlUJeHMw
         q5JtvQMJFbZ6FaEvj7h3eYJ/lDzwn14kpT7pG50SNU8ss0/whlYardEBNPucyDfGOTtq
         xeGUX1Vd8CaIhOND3Y8Hwl60vwYRJ1a0t2ESjnRMRdOYnCP/iXk501uRLWp/hOUOfYes
         4zKA==
X-Forwarded-Encrypted: i=1; AJvYcCVIdvwTId/AHFa0hrghtxIER9o9SVu2r5rdMjMC7+DL/mYZBboz1FtR4QFrrIpIieprWbvIE14j3w==@kvack.org
X-Gm-Message-State: AOJu0Yz2uIh8O53En1cAyjChTD2r2OwgpdH9QZ9izf9VejH3xFGTwEWt
	TPdDIhF7CBc77bsLsbY7gzP0wShsqFTvJlS2dOkrfFgLLn1eBKL0ijoMBXfN43CuA/HCy6w931p
	qJsr1+P16oGJGomC+yREB8pwVEWIsn8GKP4EL4jZha0kOo3N7bpAOxocV1wuZ
X-Gm-Gg: AeBDievVa1P2G8HKA2yJhUkEEdmnmhDoEuVg0Clt13DXY2hsyUdOFizfFd7WUgHNX7A
	D+quJLqGO2aeooOzPo5qeOVZYUtncNRN3uRcBl8ye92Cwj4jgnGtbUrjpsC6oSiczRzzGTUrE1O
	yVuITZ+geP3WrRK0AzplR1ToEWND3ZoNBTQkqrjCtQp5jnSm2DKPiYKtpOwADJOGrd9eMEjcDop
	tPyRB+hauS665nh02yGVKGOWNG67m8jD+OJBzMO8ONC8SbfaNq9LGwk5LE9lBR9MDe8A0p9LZ9s
	D2D34GCHeGxjxAjV4hIigkSbLphQLiccj7yOJx05nVG3EwwTFxQ8bAkWPlq8fYdRIRq3ef69/7G
	FH8k7ONRr9rrDHbl3+QBSqpV62qVahL7yUNCz1id5pujUaw==
X-Received: by 2002:a05:6214:300e:b0:8a1:8ddd:e12d with SMTP id 6a1803df08f44-8a43aa44c2dmr109661806d6.59.1775137323593;
        Thu, 02 Apr 2026 06:42:03 -0700 (PDT)
X-Received: by 2002:a05:6214:300e:b0:8a1:8ddd:e12d with SMTP id 6a1803df08f44-8a43aa44c2dmr109661226d6.59.1775137323022;
        Thu, 02 Apr 2026 06:42:03 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8a596915986sm25665836d6.24.2026.04.02.06.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 06:42:02 -0700 (PDT)
Date: Thu, 2 Apr 2026 09:42:01 -0400
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: David CARLIER <devnexen@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-ID: <ac5yKatsMxNp4G2g@x1.local>
References: <20260331134158.622084-1-devnexen@gmail.com>
 <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
 <aczOCqrCx7Xd5HIF@kernel.org>
 <CA+XhMqzdQLZD4YWzyZfTwd_+sDnLqj24APqBRgum97_=8EcM2Q@mail.gmail.com>
 <ac3paYh6sPHr3EJd@kernel.org>
MIME-Version: 1.0
In-Reply-To: <ac3paYh6sPHr3EJd@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NX4P0sl7Rs5_KDx9U5avmhgFrOn_33ab09HWbgpN3w0_1775137324
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: uchpbgdt8zda5tmtwarhw6s4znjn75wd
X-Rspamd-Queue-Id: 4CAFB40009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775137328-621094
X-HE-Meta: U2FsdGVkX19rJ7mRrGUHcyuFBfXGrhfMdoJam+Zzmj2qzJ8FwRFlU2C50B2QJHwtZHekpoLs2x1AJld7lAFE812PchNx2dZhLLk21KffuyUdOr538hud+2KMuu3pCcGXlIChngen34beD2iIbXrZkgIp8bjnEvvaqTD5CiEPxTxPFeJwMdpBlzDVGPFszNDjS3nmT9nt6lXfxEA78wNTfhaufDTjuMCcJ8pk3ECm9MpoC4KUdfQ4CDywVVMGigHVBVfvXA+N/dRHfEg+Qx1BtWGhcHygJ3vR9rWdlgCv0NPsDHICgV6lWo4D/SQOKPJTwSc/0/5KrM++PuU6ogYfvmlDT/4CL+CzgVndWjtcKNYBI4sr2u5bLrp/RRaIm8Lf/QEh4SYs7xgzPl9IjUsegx5t9zGm/beczFtE7ATQeTJgWDZ7+3VkknkNRJWoGb4mJhJnKbfz/dT6jkXm2M5m0pF6y6/dWuItSBD6lznBViPb9LcRSHcKeE/QItbJlZB3r6VBIKAQyumj0IeEcS91NwoBESUovwv8sHSmefXkm7DHocSAAMUG7oHlQ8NYwUhX/1uqTzlLFW9jKpF+5wKlS0XKZ9EsDID5dAX0DzOXxklKqLHRdnfh/SZNTRQU7LjB3I4bGSC/KrMZkSbgS0ohMjwY7DIsCI2uKtJeM3kkye5N/KSlVCWccYez0lhs5H2DhoWVlEJRa1LQgNXGsAIJr1UyHFyOYiDKj7nWrUtt43p5PlHuzTnbTdZLdcaxMOv4AKxGjQnoUgBsgFShsClCy0SMKdUj7Z9oDt64RmzdtH0U2NLulNch+4kU8TgtQjaqkBsru4DlF1TeqJBV3wL+qSxCi2pVzZk2BkJJaFwC2Y72i64aByRKU7M3UhejvCAHzx/DIEfGMv2SFX8WYTmVnu2Ph/joR//dLwY8szBmB7Ryw5UAJujOwR+ngXz1h4+zVa5TtusW7WUe/bWsgyU
 K4knqWW1
 l3q3eTTGBUFBgaQPFrZLmScKNq5ic3GT0WBpgoRV2B2izBY6iONkii9logrbz6VnGxHFeyxTbS9LraHpgsNpz6Xlacq0hm4YDwMJTLKZLDFRL1oJnPFrrnmun7e0Vn8J/ropXuf7U1iQ6Ok84pXw1NR8mbbkKFV2b4mCO5P+JwDqDseZJsO2tQvpUpS+Qe7MlBsriN6TFNmTiFkB/6t6l7mSg4fmI2LMhJr18N4xFiv2/TBQQ9Qy4QD7aDq3TrXTHuSjZBJMYgPtCgDJdHQNpF/BDWg5yEuYB8y5tTgMkN3OIUVZ4vrOFLY8imG3dUaK2dGFL84KaYOtlypTH6XfRCuhU1CskuHJEnOSV2dc/c/eoA3RjBSh32W+6cESYz8ireH/gkzCh6SDDc1EE1Z4gWgxoW/kG4Xa9kbHETNhNlbVN3X5w/T9M4Pjh0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Mike,

Let me also leave my comments inline just for you to consider.

On Thu, Apr 02, 2026 at 06:58:33AM +0300, Mike Rapoport wrote:
> Hi David,
> 
> It feels that you use an LLM for correspondence. Please tune it down to
> produce more laconic and to the point responses.
> 
> On Wed, Apr 01, 2026 at 09:06:36AM +0100, David CARLIER wrote:
> >   On Tue, Apr 01, 2026 at 08:49:00AM +0300, Mike Rapoport wrote:
> >   > What does "folio allocated from the original VMA's backing store" exactly
> >   > mean? Why is this a problem?
> > 
> >   Fair point, the commit message was vague here. What I meant is:
> > 
> >   mfill_atomic_pte_copy() captures ops = vma_uffd_ops(state->vma) and
> >   passes it to __mfill_atomic_pte(). There, ops->alloc_folio() allocates
> >   a folio for the original VMA's inode (e.g. a shmem folio for that
> >   specific shmem inode). 
> 
> I wouldn't say ->alloc_folio() allocates a folio _for_ the inode, it
> allocates it with inode's memory policy. Worst can happen without any
> changes is that the allocated folio will end up in a wrong node.

For shmem it's only about mempolicy indeed, but since we're trying to
export it as an API in the series, IMHO it would be nice to be generic.  So
we shouldn't assume it's only about mempolicy, we should rely on detecting
any context change and bail out with -EAGAIN, relying all rest checks to
the next UFFDIO_COPY ioctl done on top of the new mapping topology.

> 
> This is still a footgun, but I don't see it as a big deal.

IIUC this is a real bug reported.  Actually, if my understanding is
correct, we should be able to easily write a reproducer by registering the
src addr of UFFDIO_COPY to userfaultfd too, then the ioctl(UFFDIO_COPY)
thread will get blocked faulting in the src_addr.  During that, we can
change the VMA layout in another thread to test whatever setup we want.

> Let's revisit it after -rc1 and please make sure to cc "MEMORY MAPPING"
> folks for insights about how to better track VMA changes or their absence.

No strong feeling here if we want to slightly postpone this fix.  It looks
like not easy to happen as it looks to be a bug present for a while, indeed.

It's just that if my understanding is correct, with above reproducer we can
crash the kernel easily without a proper fix.

> 
> >   Then mfill_copy_folio_retry() drops all locks for
> >   the copy_from_user retry. After mfill_get_vma() re-acquires them,
> >   state->vma may now point to a replacement VMA, but ops is still the
> >   stale pointer from before the drop.
> 
> And this is a bug in my uffd refactoring, and it needs to be fixed ASAP
> with a simple comparison of old ops and new ops.
>  
> >   > Second, I have reservations about vma_snapshot implementation. What
> >   > invariant does it exactly enforce?
> > 
> >   The invariant I was going for: "the folio we allocated is still
> >   compatible with the VMA we're about to install it into." Since
> >   alloc_folio() allocates from the VMA's backing file (inode), checking
> >   that vm_file is still the same after re-acquiring locks ensures the
> >   folio matches the inode.
> 
> Again, it's not that folio matches the inode, but folio is allocated using
> the correct mempolicy.
> 
> >   The vm_flags comparison was a secondary guard against permission/type
> >   changes during the window.
> 
> Permissions should be fine, they are checked in userfaultfd_register.
> Some other flags that don't matter to uffd operation may change during the
> window, though and then a comparison of vm_flags will give a false
> positive.

IMHO false positive is fine in this case when -EAGAIN will be used (which I
still think we should), if it only causes a retry.

Thanks,

-- 
Peter Xu


