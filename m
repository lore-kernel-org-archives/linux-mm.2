Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 453B1606A333
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mU/JCKCi
Received: by kanga.kvack.org (Postfix)
	id 533756B05C3; Sun, 22 Nov 2026 10:45:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509A16B05C4; Sun, 22 Nov 2026 10:45:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 420006B05C5; Sun, 22 Nov 2026 10:45:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1ED116B05C3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:55 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78D91806AD
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:54 +0000 (UTC)
X-FDA: 85463180628.30.D5F0536
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C6EA7C000A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mU/JCKCi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362352;
	b=bwH/iOegw+aQ00f2UJXfJL0icc3uTd7mOs3q4+MNduCvnj3Ext9aQi17miyb+r/jcc9V3O
	UdnjzG2eEMeSYsg4Cm0fKaak9o979CjB8ooTYHLq25FPWZSRDvAX21B5SXv8XI5d1LOR4P
	MTCt8qLsFVhEDtBQkIToq0FUlCoFHhY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJT3t15TfBOfdlgX57Ds7OT7KQ9/RVLv23DmEdPrLw8=;
	b=NpZHMvJHMRsKosNZx4r9fTab0ovpJaJIDuz9ICC9invSjUDcZDIHAEN55qsjXMhDX5qY2M
	GxowOTKYoGIFDvqxxOsCQDFKyzFZc5gdqIYCyAI6lMh4UoWMS3ZQl1wP3p1YAPy5/QiACH
	MlJ67J4EV5tIT6QMruyxae+0PNyCaQA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mU/JCKCi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 63C90613F6;
	Sun, 22 Nov 2026 15:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774791F000CA;
	Sun, 22 Nov 2026 15:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795362351;
	bh=yJT3t15TfBOfdlgX57Ds7OT7KQ9/RVLv23DmEdPrLw8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=mU/JCKCiraVFqxFNBtrBnxFrd/w7axyI4sM+9xcEdMziMvt+KqOv/GC0fRQruihzt
	 hIf2t0BNl95Vihdqd9y1BXVlPFuX9mCb6Gqe+z+MWGyJ7GSYiMkLIMi4gXYu/owDKK
	 BY2fdvmTkn5ShpuGlbR3r6Mc2n7NTGAq5GHJRUlPCMVM0WyxAWEJkUHPT3Hb+XPqVt
	 TyDoYt7NaBj/ok2zg1L3eSzmQmjDZVr1lIVNmov2FAo5eVA1/C4ncf/g8KBuguO9I/
	 zRQj0BoZ80+ncShc+uVIF882w+ytLKjKZj4UIa8gU8hxZC0SnFwaSAsjXLesuzMIrE
	 OBeFgUC60T1LA==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 10/11] mm/cma: localize init_cma_pageblock() to
 cma.c
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 Mike Rapoport <rppt@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Muchun Song <muchun.song@linux.dev>, Li Zhe <lizhe.67@bytedance.com>, 
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261120100856.16929-11-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-11-songmuchun@bytedance.com>
Date: Sun, 22 Nov 2026 17:45:01 +0200
Message-Id: <179536230138.3933282.13713673852338005134.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C6EA7C000A
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: pt5xk7bb1mf9hi8amnn38b19b8848k9c
X-Rspam-User:
X-HE-Tag: 1795362352-685491
X-HE-Meta: U2FsdGVkX1/7v9xLo2/7ku/uZMDHL7vBvH/VrWw3yRR4KJTSGj7jFr1+PgUPiWFHtdsGli0CO4D67Xx0AZu5t5Q8zaZ7s2gcwCiIcV69wZKgLe4F71NeZSaJwFZUcjP4iWbujkQbwmyy0gg+fWtuNH81/Hjwyxw0YbKTP2O4CDj9g6gTJ4fDGYxmZUaZv5MsAQ22uIsjgufqy5IO5VB/te13bOGsqoxizVB6KPPRa0tnCDkNzDgcv+JU38dI30lEzgQg/F2LQv9TB/3Zp35AXBVNyrGvpXA9Bn9Hen0zdY+PmS/9bnmLkCOFcP95zKu76j3OGmibc2l2k2PUmHYGz9w3V4C5ERNKsk9A61343APy0tsXVuoggkOtQECkFXSKfu67NDwXY541Wxday2oBBSm3fcaEJYMlZBhCOJ8GEhBZ7kvuFO+TRwWaGyV5AeFGKVXXLU5fXEcFqMcFeh0RZAqYRC1u5ptG7PGTwPF3c/+M4FWQm63wj53PxovNptcsBZlfWGwRgxZGuvmq+QMOdB3pTO+u3HeE3ze7vBk0qOR+IZwEScvxnQVLLpLJuHz8O+LpR0wxlky+CdoWJz85dJqHIOhY5RT9uVfw+XvinoGLYE3o81tuERSHBwgBDLPIyEcI4UrMQeVeU0MV8Dnb1D/3sHQxgXJrnYoXF9wCb+YXIkskaBMdD2YgpOcfRjc62jGCxMx9vS8oySJ4GacMMMTU9ckI+SiVfPitkCMDw7AEviFUf38Pk9CHHxqlGQoMLMeqjDVRSdE1XCUuaKxJ+myViTpJYziUK3jWsKm0mHZHnUYBcctt2fJvuJQGQE1iQHbs291WkBU2HTTGzGurj3g6W9zU4vgoQDzH68qc7VbGKoW8tyQOdf4/S9XOaqMX8A63uHsr7/VESEkGUYcjY3oP5zVEXCvugyg88B0TuWzvLdAH3kIEt2tHMTfnv8gnSsjfqCQ+Gn8zM4+1PGZ
 uAhP0uIV
 DFDm0krjnFKMvXSOidtZkF2LdrMKnN5JroPtCTwToBfmiY7RiMg7Zv5gR07VugZ3WTobed2mYxC25S2RRx6gktht8lYWl7sRu6cbuXgzEqvzHfr9ciRLQCDJcA1Ju5YBMMGvVNfjmsxR3/u5AQ2MF3KMKaIgqELPClD10iSW15Ae8OdeeH+klBQI6e5xBSgevwIUqwcC+xJb08Ul7QV4JN3dOJGJTGf4zg7iJILahNfJ49tPKAlWixceRLH2PNGbaloYeXcBBfSj+usN8jqnUhnqrenODKt/xLWHSLkAZ71n9YV8Q/cPr/vVK0QTCc3L7x7SIp1kZnPghD0sUnLl/JWDmBgj19iHTRi4UHOPRYMmwjO+0HsJZZ84wT6kki53sV+0mxh9Pqa3xDugJLkk6GSeriCrTvyCuFEzL0OesPmLLI/an/JZZF+ZrU9qs0xKXIhg5pa0hMB41p/tHGNu3vNjzNHFmERllzanhNqnvEb8+rZMQDnBeYjQIoXV3cpxXIHuD36JySFGV0qdZAlnFpCe+cziJZjuz9vGV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 18:08:55 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> Move init_cma_pageblock() from mm_init.c into cma.c so it lives
> alongside the CMA code that uses it.
> 
> No functional change intended.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


