Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1113EC5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 20:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A1B06B007B; Thu, 30 Jul 2026 16:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751ED6B008A; Thu, 30 Jul 2026 16:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D9A6B008C; Thu, 30 Jul 2026 16:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E0D26B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:07:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 16456120286
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:07:24 +0000 (UTC)
X-FDA: 85046527608.14.AC8B0FD
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4A0D6A0003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:07:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mTM+3AfF;
	spf=pass (imf15.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785442042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I/UMoM94HTH0CifsnpKfjDYBiZszucZn3J+xZcqQgUs=;
	b=wOsX99qmOhmxfORWUOHsyKpBCJ+hpB/eiLWrVl8qrZ2gyOX0FckPYUlem/Vkq5Lu1wNd/G
	q0vVF1FcpiyEBjGEV9Cs5LUulY2lRm1wa9dXMUlAHwMRCqFM63fJe4WoXHXZ+97c8QN0Qw
	Xa9wGNLevV2DjafrXEmhEa/YxsquvsA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785442042;
	b=Xe7wPsBy4i0JuBgcyzu9BLNKktdats2eneOPWGCEwRp4lsu10rY6v/XORvWSz/s7Tnw73A
	5ao6n/Sc/GXowuxH1JHV0xFyCOgay7PO81D3DALW848ODa2bpsilQYPSDHIPD9zUaDdI/S
	reavKfbMTlr1TiWrfuZ2zXQ6GgqUZgU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mTM+3AfF;
	spf=pass (imf15.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-59b074ec7ceso106897e0c.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785442041; x=1786046841; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I/UMoM94HTH0CifsnpKfjDYBiZszucZn3J+xZcqQgUs=;
        b=mTM+3AfF4bhx6qCKyeGvdbvrDIRtHZTxjcP3dztauIXeAjsvN6ovcrTTqd7RsIvOUD
         KqBUa8Ycjr3oTvHRTTurtYWlDQS+1ogi70LQLafJ4hoKfT1RpmdX37P3uVoZ6+3vC67m
         CXp34+IhgRrkp1od+DHBR/ngnNwN9brB423cJqn1dwuIdmzKmzU0RfCDL4tDn4DF1vGh
         VmGIsdUJb9QTkggBLCS1U1FA9dPc+ReKfAPBcJGjkXLY9JaxHL2oGfLxcX4+djBzCegP
         Z2jG1wOr+nrZKPeM6MkpdOmZ7KpRhI//aYZoc1XD4iGQ959W0K7BrPmiCJGGtl0ZHCyq
         sjaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785442041; x=1786046841;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I/UMoM94HTH0CifsnpKfjDYBiZszucZn3J+xZcqQgUs=;
        b=YqVwvS7I/ilFkOP69Udse6lK+E/V1PxXQ+RC1XFU/LB9ANOmQb6AZxJpYIhdzjUQ6n
         U74qdNv7KQWBbZbNjkvxjWbYVgfcKkWifgYEXjAp07ebexAtkgx8ydqpnZz7o8ZdvzET
         HA0i2dcP9hZ4Zy9xSKS9kSjUxXzr7UR+6zD3XHWqIk5vkRADjGUZBDnDaZ4ltTeAbnEg
         jVZjjpoIlVmNKbYXhP2R8vrt1PRNgcvIQhtHeeNKCJ5rEnBjjEuyB2eQgCg3FDACM30p
         a7BLNZeLG+wLPvSdcuWDIyHQsOLRwRqV11wkZ0kh3MyS9zEVutoG/HA8fl4KLZOTs+CX
         xjdg==
X-Forwarded-Encrypted: i=1; AHgh+Rqb8Px6kqpInpHruMlykar38iPFN9Yw+LPV0uaFePPt0PrgN/Pb6CYwrUOYZaWyEFTPCsfb/46ZzA==@kvack.org
X-Gm-Message-State: AOJu0YzArOchBHn89uGc3a00EJ1E8p48BlxhTRSJngHpb0+n5xY1TVA3
	SLSACHEU+vdrx3aR/+7LZbL8VKt3TF3g5KzO53AUNyIz/XbI28P16REF
X-Gm-Gg: AR+sD13apLSAecVh4A1Ko5WNtGlrVZ4iGKZ/a/fTcXdAoKWUnLfRF4JkvHbqF5TeHxZ
	5JZdtoDqzEYPm0LWed9vK/odggf0djXlvoI4ScfbZ1JrV2ptKCJAIfky395kfzKhYYmvW0RRjZZ
	rpjEvjZhjHRuHI/FhcYsR3SVsZWKq6GoHExptlWEM+Kc/8aLPWoMXrmdHERFV/Nx8gjE4ze8wCB
	AZryEgWei7hfU76dZIuFMy2/alxudBzaOXpC60unmLWyxdw66HH5kY+LudpiTPF66XCmaNLbQqd
	HyIMVMwn370DyoWUDeRNAenSY9V/JQwY65+qnnZ35y0RvTM8SGubVtMbkVyT7bvz5HFX+QfooFT
	K54InwMuL9GK+2U4tJZjnkDFS+gQybMLLTGT0Gv1ymoMc9L4uuqjgUbg1fkbFH3gpEuG5EV5jv2
	6Dx3rN+zzihSY1XO/8nRC7ibhXCwlJ1QK3FHbyLjigbUtyPMpcI3ClGzzxskfmJFvcKL80fjXwh
	w8dUL/YU2iX6yYg6hfdZGvA
X-Received: by 2002:a05:6122:e46d:b0:5bd:faa8:74e1 with SMTP id 71dfb90a1353d-5c366276510mr1279552e0c.13.1785442041197;
        Thu, 30 Jul 2026 13:07:21 -0700 (PDT)
Received: from fedora ([2804:30c:1f53:aa00:1495:7d0a:c9fe:c63a])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c36674e7dbsm2178151e0c.16.2026.07.30.13.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 13:07:20 -0700 (PDT)
Date: Thu, 30 Jul 2026 17:06:28 -0300
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, shr@devkernel.io
Subject: Re: [RFC PATCH] mm/ksm: use checksum to speed up page comparison
Message-ID: <amutNsDURz4TxUTI@fedora>
References: <20260716122039.679173-1-pedrodemargomes@gmail.com>
 <98c91508-4aa7-4390-b2f0-e39f16bdedef@kernel.org>
 <amtdj-V6kDlXFhq7@fedora>
 <89e64c5d-f317-413e-9fa3-9b7e0a7f0f5f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <89e64c5d-f317-413e-9fa3-9b7e0a7f0f5f@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4A0D6A0003
X-Stat-Signature: 8ks9wp3db6kumy5rj5gzkbkcsxiz4n14
X-Rspam-User: 
X-HE-Tag: 1785442042-899801
X-HE-Meta: U2FsdGVkX1+emfx2fkTaLJbRVASt8rhleuHqYXoOG9ydliVBornUxHtWQl8tfK+Lly+AszD+fW/nvN4UaY/bQgdpGw6xs/dqw3zneQ0t72Hd8wEtX+DL/x8HZyhZgpKDx0pmhDhg9rnIpbxKVGTFB1XmCqmcnlOjSfhimnwh0GFPm70JE2oNiwG7nWiCeJiN7bJQLv7AEmkDX/DI5KCe2k/1v0a6Fxwo/hQesLvu+uTghv4DF7hfLKfCI/ipFfYmATPZux9AbQ7S8EEdA+zkEYtUVDH5IUPre9Rr5zdoWMuTFdWxVLV+9l4DQc27QR5pHnruR9EmpbJT/F2FxLkGqhTxCYHuUrgkE5d02QgfbsSfZVoZ9wY1Ht3PzcQzQUFvkI635YiBVW4J6aOte+tyKKP0/2lIkhEmuwNxuG7diE17M32Xbk6C9kZ82DJ6A9C8dIKkf/o1faLnWJJJZ6o/FAyXQ5AdFlnm/2CroAofgc6mLi6TzJpQZJvHCpnEcn2cBggrTdHIOaFvKf3gQGnvlRLaJSVJGOuG4c0WZzJdMlleyh5qQWQ9+mQnsXNuWHEJNZv+iucYNO2SaFonejJdZvSgU0QCs2o/y+UL1Yu3PFzQa2W7erEel/qh1rFrI4T9JrN3YAtwxDVjAQS5C3C/QH7/U+TvugwSZWVOmNoY49je70dT8rDF2amtrTQ1XTYygeMzrfX1Q+O99Hi7q36Sds+k2u0xIPxTsCjTsQPehHFmpOKbQ/EQYn3byycoRcX13YHVXnFiofPKnbAFkJa09MD3/Hobj9D44+uKLTARfedQVIp/FecIQgNZpiolDZAuiFSF51m2Zt+lAfM7N2OPj6ae+C86Z6Wu2DkJ5A2BZro7JiQYGCm3XgY7N5LWfhDz8td2VOll6HsdL42FzJk890jpCYEqIMtJGhDaa3iv4czmOEwCoHJ0q6nzZFUKbl4aaTQAVCc8UydThhwyYwr
 zcnUD4BQ
 Mz2nQ8TcB72lgkuRKm6O29wr65Uw4GD28gpSiLpKS3Q3YDhClLYEJkz71tVrd/E1ADTSOwTlnqUPeEeew50Wg0TSpRryFvEDTXXzPo4ywFcJqyVg7vmCKRTS+jtGtmZ6SAe8GTgooBb8a7XpKIHnm3YzmYPttBa3AvCnrez+IDoOLnSgvsMfh9lyeWV4jLUo2/Emi+3ftnvAdgKwI4IH/jNHJIiwY+qujiLJM0Nwuqzhb0dTPksuZH3aI2jrjK/aoept8SN5jR9cULCuY9VJW3B0Cw5HoW7gsVMzRPS3pVWcuq5jGKtVqHwtklNbT1i6lspgVGxLV/BvdoDHnCkOK2vFLtOtluM3OVmQTr+I4O5ez2l3Tl0t2c92qhRMVnzCzcnBfSKTpYk64z8UdLFmhKlVHcB3rx81up41IiDy1KrBGkwHGcsxDLTDmq1Z8YQAELvaZG3gIAfCGc6wxCVxNJ9SxzfJ7gSBCfjjn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 04:47:14PM +0200, David Hildenbrand (Arm) wrote:
> On 7/30/26 16:22, Pedro Demarchi Gomes wrote:
> > On Wed, Jul 29, 2026 at 11:38:38AM +0200, David Hildenbrand (Arm) wrote:
> >> On 7/16/26 14:20, Pedro Demarchi Gomes wrote:
> >>> Use page checksums as the primary ordering key when traversing the stable
> >>> and unstable trees and fall back to memcmp_pages() only when checksums
> >>> match.
> >>> Since struct ksm_stable_node does not have a checksum field, create one
> >>> in a union with migration list fields, so when we encounter a migration
> >>> page while scanning an address space we have to recalculate the page
> >>> checksum. This avoids increasing the size of struct ksm_stable_node,
> >>> which is maintained at 64 bytes, as show below.
> >>>
> >>> pedro@fedora:~/tmp/linux$ pahole -C ksm_stable_node ./vmlinux
> >>> struct ksm_stable_node {
> >>> 	union {
> >>> 		struct {
> >>> 			struct rb_node node __attribute__((__aligned__(8))); /*     0    24 */
> >>> 			unsigned int checksum;           /*    24     4 */
> >>> 		} __attribute__((__aligned__(8))) __attribute__((__aligned__(8)));       /*     0    32 */
> >>> 		struct {
> >>> 			struct list_head * head;         /*     0     8 */
> >>> 			struct {
> >>> 				struct hlist_node hlist_dup; /*     8    16 */
> >>> 				struct list_head list;   /*    24    16 */
> >>> 			};                               /*     8    32 */
> >>> 		};                                       /*     0    40 */
> >>> 	} __attribute__((__aligned__(8)));               /*     0    40 */
> >>> 	struct hlist_head          hlist;                /*    40     8 */
> >>> 	union {
> >>> 		long unsigned int  kpfn;                 /*    48     8 */
> >>> 		long unsigned int  chain_prune_time;     /*    48     8 */
> >>> 	};                                               /*    48     8 */
> >>> 	int                        rmap_hlist_len;       /*    56     4 */
> >>> 	int                        nid;                  /*    60     4 */
> >>>
> >>> 	/* size: 64, cachelines: 1, members: 5 */
> >>> 	/* forced alignments: 1 */
> >>> } __attribute__((__aligned__(8)));
> >>>
> >>> To evaluate this change it was used two benchmarks, bench1.c and
> >>> bench2.c. The first one allocates 8G of pages with different content,
> >>> and the second one allocates 8G of pages where the first 4G are the same
> >>> as the last 4G. The two benchmarks and the system ksm configuration are
> >>> presented below.
> >>>
> >>> bench1.c:
> >>>
> >>> int main() {
> >>> 	size_t size = 8ULL * 1024*1024*1024;
> >>> 	unsigned long long int numpages = size/PAGESZ;
> >>> 	char *pages = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> >>>
> >>> 	// Generate #numpages pages with different contents
> >>> 	for (unsigned long long i = 0; i < numpages; i++) {
> >>> 		*((unsigned long long *) &pages[i*PAGESZ]) = i;
> >>> 	}
> >>>
> >>> 	if (madvise(pages, size, MADV_MERGEABLE) != 0) {
> >>>         	perror("madvise MADV_MERGEABLE failed");
> >>>         	return 1;
> >>>     	}
> >>> 	printf("Wait...\n");
> >>> 	getchar();
> >>> 	return 0;
> >>> }
> >>>
> >>> bench2.c:
> >>>
> >>> int main() {
> >>> 	size_t size = 8ULL * 1024*1024*1024;
> >>> 	unsigned long long int numpages = size/PAGESZ;
> >>> 	char *pages = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> >>>
> >>> 	// Generate #numpages pages with different contents
> >>> 	for (unsigned long long i = 0; i < numpages/2; i++) {
> >>> 		*((unsigned long long *) &pages[i*PAGESZ]) = i;
> >>> 		*((unsigned long long *) &pages[(numpages-i-1)*PAGESZ]) = i;
> >>> 	}
> >>>
> >>> 	if (madvise(pages, size, MADV_MERGEABLE) != 0) {
> >>>         	perror("madvise MADV_MERGEABLE failed");
> >>>         	return 1;
> >>>     	}
> >>> 	printf("Wait...\n");
> >>> 	getchar();
> >>> 	return 0;
> >>> }
> >>>
> >>
> >> Hi!
> >>
> > 
> > Hi!
> > 
> >>> Configuration:
> >>>
> >>> echo never >  /sys/kernel/mm/transparent_hugepage/enabled
> >>> echo 1 >  /sys/kernel/mm/ksm/sleep_millisecs
> >>> echo 100000 >  /sys/kernel/mm/ksm/pages_to_scan
> >>
> >> Given that the default is 100, and sleep_millisecs is 200 ... and it is known
> >> that frequent scanning is harmful for performance, what is the real world impact
> >> in common setups?
> >>
> >> IOW, do we even notice / care?
> >>
> > 
> > As described in the KSM admin guide [1], the default values for pages_to_scan
> > and sleep_millisecs are intended for demonstration purposes rather than
> > production use.
> 
> Well, I argue that
> 
> 	echo 1 >  /sys/kernel/mm/ksm/sleep_millisecs
> 	echo 100000 >  /sys/kernel/mm/ksm/pages_to_scan
> 
> is not for production use either?
> 

Yes, this configuration was used only for a quick benchmark to test the RFC
idea.

> > 
> > At LPC 2023, Stefan Roesch described the use of KSM in a production workload at
> > Meta [2] and presented optimizations such as Smart Scan and Advisor Mode, both
> > of which have since been merged to reduce KSM's scanning overhead.
> > 
> > This RFC proposes a complementary optimization. KSM already computes a checksum
> > for every scanned page to identify frequently changing pages and avoid
> > unnecessary stable and unstable tree lookups. Reusing that checksum as an index
> > into those trees can further reduce lookup costs, lowering CPU usage without
> > changing KSM's behavior.
> 
> Yes, but the change is not completely trivial, so we better make sure that the
> change is actually worth it in practice.
>

Ok. I am CCing Stefan Roesch to get his opinion on this.
Thanks!

> -- 
> Cheers,
> 
> David
> 

