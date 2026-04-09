Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C305EA3C59
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 13:01:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438DA6B0088; Thu,  9 Apr 2026 09:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410926B008A; Thu,  9 Apr 2026 09:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326806B008C; Thu,  9 Apr 2026 09:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 210286B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:01:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC6F75AB40
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:01:08 +0000 (UTC)
X-FDA: 84639027816.21.B314C04
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id B999420011
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:01:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PSHICBr0;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775739666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pboOsBqZdZszXx5xrZPHuc+J1U0ko1Sn2+9rj83d0ao=;
	b=F9t49bRBUxMldcGc7i7v2nQjpE3W6F7FP+jF6RaVYAlKFBKvGICKrjeDnw71zZ2NhoXAQ5
	rpS/YnsosfKRD1JAZcfnf4XUWoIbaSrNkYjirPuJxWJjbtZ83Voepagk/8qdTa+AqX0HpO
	AJmuzLu+5QcrX+SIHdINL0qi91qbADI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PSHICBr0;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775739667; a=rsa-sha256;
	cv=none;
	b=Ju2li4GIgL7YYSeKPR//KtVfGQpA4AiYOjvrucxgAX2v5OtlvSSn448q50p0W6l+nEAhAI
	nhi68FeeEi1NYeBdquRoz6GELGw6raIu3F+AUZUZyObKSbwN+zqjFZvOcGz7giUAZPt9Et
	dcPRuyjzzDnbRA5uWqAIyvxQHbIDg5w=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-482f454be5bso8925155e9.0
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 06:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775739665; x=1776344465; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pboOsBqZdZszXx5xrZPHuc+J1U0ko1Sn2+9rj83d0ao=;
        b=PSHICBr0RxDUaU5RO4foBKqk1TczgejgoKJnygQrMzE/LsOnJiimRJQbrppTBSoWec
         AkmMtM/1Bu3S9pXGOlpM7T1mWy7+HWlCgN/OnMc7Iu3N2pF3ZgRh4O3JOR9yyAGNa5Nv
         hiP51hbo8QQK8hKyc228WrwBS3pqGcM85Jjc7kPWT3iCofgI3vlWwLkjKsIegRoSDlMk
         KbQxlILrKnkI+FIKPsSnCAejdyI7ZmQyx4ObwYxtbSBMUmOqN7Rtn9/8IxFePtI7+39q
         PA02ytDMpr2foMdZRwFhuKXy4lZFH0ir9JdZUCU+mUNDlBRfPbBnbBeVzc4jZyFegY7S
         5Phg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775739665; x=1776344465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pboOsBqZdZszXx5xrZPHuc+J1U0ko1Sn2+9rj83d0ao=;
        b=Jp9xmWxORx1nFWDsxNJWND2fpTv3jdrf3sV+HsjZFSNCXqKEDC+ujn6+8rlhyxHQye
         ALsbfPMnRrdS4HSRpEoAb/O5kCH0GEjFNiHKMct3cSB+5MPfBQuv2cmImvxPxfmfGGsT
         iymL/zDX2l3861TaKAbfUJeyMsfWa0Xh4SyyiNjtX+5bu0IqJoa+FGNWZ6jn1lvidQu0
         WIsOQJyEcLz8bE+KEo3z2poK0IS5mH3549L9Zmq7w5869N3MSOVVITUUAOaRrq5j+dll
         RhipOhwfs1rez9leeTzOlQv6UukHYVMBEnyiNkRToZT/+4ytU7+zwwqK7psbfRvaC1Ag
         77Ow==
X-Forwarded-Encrypted: i=1; AJvYcCVaabJj3cIMs3pY0ABxRDlvWqRlzOGEtsbMUbBXWV1lvYpL+vfcT/d8frI35DrB0+Y8sB6QlYJz5A==@kvack.org
X-Gm-Message-State: AOJu0Yye7h4NBHDF/pT3dcbxb3aqaqhEJ3kOw8JNVhPTlPVK6Y7/Oiib
	vdb71SGf402AAzpd5oRWfi7hO45mY9/WSEoFYNadYiHvwdSJCXr3YnWZ4P0+Jad3/Bo=
X-Gm-Gg: AeBDieuuqtQuS7FszNhv+csc8hdz1yGbf3R4zdHyY2UKsYIakmYJwR/Fs1fuXLPnP1p
	Sje5Omy/wYfIqt9oCgD/aXoknACl7UCr4uxssVTyL99IrtTdmjLDpN541YuIgiQHIKSx3hTsI5X
	c1KjzsucVgwDbZ7mUbmoqTMZCn25x2QQXFBXenZVYEMwPXDKVKmxQYvHM4OIYQ5ZdxTe3phSzE+
	8HrH/Dg7kXGBl/k67b61V7PMOSW0fbSiQAsLRShApDJ92eqoq4fvPguCKuWd26lRc999vdT5R+r
	uiEsa6fajN1f+rMvcm74wEC2EM/bfsjYipWXUiNXpWVd+G1j7WklhaU3NXnBgIKOYKYdy7G3Bo+
	CxarcTCvq5TNnKJ/aSEDGVBY/8CMA2nnCRz7TLoQ55VusjO9SfOHe8BpemGWaK/xgqgTsA4ZduO
	V3fCGNYBS3y7T7WVTQGasw6cVGmprJUIE62w==
X-Received: by 2002:a05:600c:4a12:b0:488:aac9:7a31 with SMTP id 5b1f17b1804b1-488cd23f39fmr33183335e9.0.1775739664774;
        Thu, 09 Apr 2026 06:01:04 -0700 (PDT)
Received: from localhost (109-81-92-28.rct.o2.cz. [109.81.92.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d5e969bbfsm4486737f8f.1.2026.04.09.06.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 06:01:04 -0700 (PDT)
Date: Thu, 9 Apr 2026 15:01:03 +0200
From: Michal Hocko <mhocko@suse.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC] fs: drop_caches: introduce per-node drop_caches
 interface
Message-ID: <adejDzw8Mf6407-a@tiehlicka>
References: <20260409063503.3475420-1-wangkefeng.wang@huawei.com>
 <addP4MKmA8zfSN1o@tiehlicka>
 <dbb92553-58ba-42e1-b7df-b8450bd69d33@huawei.com>
 <addhuRqrB-u7oDp8@tiehlicka>
 <bdd49511-9b84-42cc-a286-9fdf2ef531a7@huawei.com>
 <adeFBKzNq9rNzbHk@tiehlicka>
 <95bc0034-a72b-449c-9be4-b691fd03dc1e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95bc0034-a72b-449c-9be4-b691fd03dc1e@huawei.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B999420011
X-Stat-Signature: rn7bc3eu3694dkbd4wtkof7rx8xraap3
X-Rspamd-Server: rspam06
X-HE-Tag: 1775739666-738028
X-HE-Meta: U2FsdGVkX18kXPI1ZPWqcWQ+I7Y641qH5YB4jw1ZqBU5D9V/weozL3hhyfncypGlknFNjJcAKQQbyyMrUdPANDR+TXEvxwf+8vVWNDgUWHYYutRnxDYhk6Lzk8Bm6iVdJ3TYjTGoWxLo+kRd5Vr2a2NB6YPIYHT7lvfPrS4O/MqTHwXnZ5lMWRqrDwRJRjzzmv6z5jdUFwUe73XF6hBLvrjR/gQeYTeikRPaWTzW2qdFo/haUzsGtQqhgIcyUWwXJAjhwgzzp9N4QFmnfEkLTKE844tKGflFLdDqO4510HgBtGg403pYPJHVnKgxV96NYMzrTkCjtU8YFqP2ok1WyBgpqEahrBadSpp34SnT/4DzyE9CWlz7Fh2T9HeuAfO2T81nuD4pyaI3f7ORPsAiYGyONo8/KNnjbIdIoUI2oNgVrQwA8HQ25zEFaky1wgGNDxtzmDKaq5thKJWZ7ZzXz2F4o7Fx/O0RqxL4+8dMZZkpMqsJA5b+EBDASVaRkQikIxK+CMqPcrEF8K82ksVyYl9dGj0iS1/UIUm4NPKy0jUbOZPTV/KLKxip7O3jI21PRmkJp7MMZXFWEyElKW8GVtNNJNBEg+nE4/C/RPt8w5xPyfAbDK38tYZyR5uoPR6qCY6Skj8SQuyARLZ4+oy3NG0mhOMP25SqJs9sSZyeoatfDeIh0KJn5ch9XqxWAFgPbgzZ5Cav3K40InP0l4hZYtHDO50HA77f5ZSJxd7rhFyEqNhzSH2jwCTcDsbMe45Dixdd2JzHf37hR8u7ret33+yiIr//24Fv1JJO3G7iKgl3dsn8gZWbuBGeO1YbaJJZ77TPk7KfmQHP3tZlE5FAHdYjOEHVm4rde/CuPv/xslSVSi4CysY+OzTvXqjK2vpYs38yGBbAvBK5RQR4CyQdZVdF13LRlc4C9RFtJKtpJNNt//0rCFSSuhwDupkAwklmjpsolaPe0O1jeAzYu0p
 dxq8ImGV
 lb/tjyKpjdrwYaUAxm7rq77tHI6G8uGH0WRoSF1AIU1YeISKL5VKjPDL22Ge5w91qDgHaDhH3LZioInPSGlOEI4x2sya92QCRRJNJOEnSgYt8O9KFfURfiyl0scEqc+JfmYJsEC+LgbiaK96pVGlftGQ3OgSUYy8VAXV0TtO0fy/zUsyGd6+x+kDm6fvsruyCUGnXx541GQ6ExKEVTF0S/yCmEJ++QX6MQ7oyTxfxc6mH4wo0eqTeqSNE7kKBRpqTweHM6u0lQ3zREy+zMFIeiDHeD9p/Ip5DUlZUkUc9vvJQ9YVsbA2PzML0+8YwaIwZhcUPV6qit8dMK3M2+DhJeivDBoth8fIx7HQtScjl0e6PfMwCP4oAe/RzYH3R8WoHhO+9af8UK15bgqhd8inOn6Mx0cvxeLjf+jtoXyxNS1VxWgYeLOcE5JIMOiWLhGC8ECRGT8GMAdsdGtAQSX65f2rheS/myawuAbzCZTecm1BkxK4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 09-04-26 20:50:33, Kefeng Wang wrote:
> 
> 
> On 4/9/2026 6:52 PM, Michal Hocko wrote:
> > On Thu 09-04-26 16:54:48, Kefeng Wang wrote:
> > > 
> > > 
> > > On 4/9/2026 4:22 PM, Michal Hocko wrote:
> > > > On Thu 09-04-26 16:08:37, Kefeng Wang wrote:
> > > > [...]
> > > > > To use the reclaim interface, there are two differences,
> > > > > 
> > > > > 1) we need to input the reclaim numbers and swappiness, this is not a big
> > > > > problem
> > > > > 2) for reclaim, it supports swappiness=max to only reclaim anonymous pages,
> > > > > but cannot only reclaim file pages,
> > > > 
> > > > Why is 2) a real constrain?
> > > 
> > > This should not be a restriction, but a strategy. Our product wants to
> > > migrate anonymous pages to the local instead of swapping them out. However,
> > > the current per-node-reclaim interface does not support reclaiming only file
> > > pages.
> > 
> > Yes, I do understand that you want to keep your hot anonymous pages
> > resident on some node. Those shouldn't be reclaimed by the user space
> > triggered reclaim anyway, right? Migration will then happen during the
> > memory offlining.
> 
> Yes, that we need.
> > 
> > This will certainly require some fine tuning but I do not see any reason
> > this should be completely impossible. Certainly a more robust way (from
> > API POV) than the suggested drop_caches. I am also not convinced we need
> > page-cache-only reclaim for the existing reclaim interface. I believe it
> > makes more sense to look at the reclaim from hotness POV rather than
> > anon vs. file.
> 
> It is already support only reclaim file pages when swappiness = 0 for
> memcg.reclaim, but not for per-node-reclaim, so we can just make a few
> small changes to enable it(no tested)

This might be small changes wrt code impact but they are changing the
semantic of the interface and that needs proper analysis of impact,
potential regression risk and also evaluate whether this is what we
really want/need. Memcg has been special in this regards from early on
and we pretty much had to keep the status quo IIRC.

-- 
Michal Hocko
SUSE Labs

