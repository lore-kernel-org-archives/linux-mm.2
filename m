Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B1A1EA3C4E
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 12:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD2736B0005; Thu,  9 Apr 2026 08:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B83BD6B0088; Thu,  9 Apr 2026 08:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A71A86B008A; Thu,  9 Apr 2026 08:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 911556B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:02:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 370DBC2484
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:02:58 +0000 (UTC)
X-FDA: 84638881236.18.5DEB7A0
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4B61020005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:02:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=G6LE49VE;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775736176; a=rsa-sha256;
	cv=none;
	b=uJ6Z6ATE6Ssj0o0qEZSr2hid3RAZe2Fa87vpQZALhF4FpTy/p/PF/uedNw/opVdOMIij+Q
	+tOCcU4UaT99wbWX7oY58k8/huQAcK/5WFnPBVqe0U7Q5Odl5v8fWQCgTocOxZIhXfTyja
	9mv03jnnMxCpgOjRtWfTIjxhGDq91x4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=G6LE49VE;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775736176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbyMpGWVi4kmaTByIwWtcOm8t+drdWWVkfeRbLxtKGM=;
	b=4ygDtefW2lnn6rQt3CPZZJl+owPYfxWYuAIx1PaTTw6nw12iO4oDrUrfP31PrLU3a1lC3E
	bGYyaBrN7IyrB/J7MZf37SNiZJR8LdK0tFzU2lcJF6YOdBofercBqAabOo9pNZehr9LdKD
	o8OtYFuXmxXAHk3eHLP6X9tscpTJk/Y=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43cf3ee0fc1so453989f8f.1
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 05:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775736175; x=1776340975; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lbyMpGWVi4kmaTByIwWtcOm8t+drdWWVkfeRbLxtKGM=;
        b=G6LE49VExW24wxwCn+qETe1AbI584t+jjYjl2mmw1X8WLTh0mp+pXzgNsj84Aqyuhn
         E4pIpwc3rhb1g476hFOFSolkq7K8TGenzXBU7ZQEc64pPnREmr/j0QdqguC/aqcS1VFe
         uX1g/uktRT9SE7ZTqIepVITnqah9niZkfNS4XoLR6h7m/C+wCFBG/NmyxrUc0W+B1T01
         cST+/o40kNYfmvVD2ff9wj1z3cJTb5ih9fE8ttsrCHSUvFwWTP5Y7c4iNkf/Ti9WLytf
         TBD+YlGzyPKcO+m8cX/5eywbSyFefkEGsCa+3Af719kxkm9cae9fRbgzKcjPjIQnCZ/Q
         kaug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775736175; x=1776340975;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lbyMpGWVi4kmaTByIwWtcOm8t+drdWWVkfeRbLxtKGM=;
        b=PPv3UpvGiw6v1GXW1PBGKjbhTMe6G8nMFsc+Wydva3wX5hx6ec35jtaGVvjADVANEh
         GR8fVnoCvmBnCYE6bb7lNFslwjAb+sGL+r2U3R8m+CZkfmC8vDQdAGAZUu1zeEk7Smmt
         NhgY8mPr/ph1edevKlxrfgDdvXyRQQNSGnkcCLUKzmeUqhV70wwthSloxOG9AtQSJwc2
         0Ia9BDh4KQXjelR3Ld4soq3CID+MJY9e3eR1oaRrSmsVjGSy7aotSTW+GfqYFDyiu4Xp
         7vASnehFwtS8KeaxY6OTQkz+MJvFx245YE0z55QUUxuHBRR9Fb5X4BUp049qoIwtHmv3
         3oGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWD0gbFMGRs3/lYKCBr6EEDPiRFN3cDe7bZFs2mLhyhufEQnGsyYp8yaXZGfIJwCLDk5VXsY1tiBw==@kvack.org
X-Gm-Message-State: AOJu0YwieI5BbQDcZUhqcYKFS8NclJrcQ2SXxTnfMtRwQ1n+1S97PXyv
	vuI5z+yF/ot2Kv+MI4IHIvT4m/BPGnN8YDnSmQCsdEc33OQSsj/J6cAqn2Y1Jn8Qa3o=
X-Gm-Gg: AeBDiesXO0uyNNdx7MDaXxzFwu+dIHfIb/RG+WTg2QqOsYnM1jqA7SaDSxjTQL/k8SX
	e+LDLBxsnLpaicW8lNyiHD89KeEWacU9rH7M721vams59yqCgR5o+EqaRaPfeIzrcB0ebuqdjdq
	1Tu97fHxGnr5PLFqeFC2fVCOl8/50AuSQ4FEDsZRgIpT10i/Mop+TYhU7Pif70WEZ8+qkdq1+co
	gXhflErQp7afWf1D+BzjUK5zJGlPCSsCXoP8CbzPDspjBVC8Kpg5uRN7sdDSat+Rodyt2DUqVxE
	sLVTuKZkJuz67/wt8CRQBe3ukNAU3XqiaWj287UCm3j6EOvtJCGNbd95hhYwferMA7VYKxXY2PO
	1YmfsCi7ypme/oTYt4wMIyBym3/aZix+Q3P2PHgnaZY5wuInrN3j4N59z29dlvkBv9dQd1dxI8m
	uxoSbrY+jPcTh3rhwRSUo8hXdGQz3g94TY1Q==
X-Received: by 2002:a05:6000:41d5:b0:43b:4461:7adc with SMTP id ffacd0b85a97d-43d595cd5a5mr4088185f8f.20.1775736174503;
        Thu, 09 Apr 2026 05:02:54 -0700 (PDT)
Received: from localhost (109-81-92-28.rct.o2.cz. [109.81.92.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e1fe0b0sm68655798f8f.0.2026.04.09.05.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 05:02:52 -0700 (PDT)
Date: Thu, 9 Apr 2026 14:02:51 +0200
From: Michal Hocko <mhocko@suse.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Salunke, Hrushikesh" <hsalunke@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rkodsara@amd.com,
	bharata@amd.com, ankur.a.arora@oracle.com, shivankg@amd.com
Subject: Re: [PATCH] mm/page_alloc: use batch page clearing in
 kernel_init_pages()
Message-ID: <adeVaweQzQthEkq3@tiehlicka>
References: <20260408092441.435133-1-hsalunke@amd.com>
 <22b6ff3c-9d41-4eb0-9beb-cb92f3ada89f@kernel.org>
 <4e8c218b-ac5e-4674-9e1e-acf750f0a5c8@amd.com>
 <20260408083229.45d1a083f17484d3b2678855@linux-foundation.org>
 <fcc68286-d2ae-4e51-b4b2-886af115ad7c@amd.com>
 <4dd26573-85cc-446a-b2b7-2aeab8aa2417@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dd26573-85cc-446a-b2b7-2aeab8aa2417@kernel.org>
X-Stat-Signature: 71k476r4pdzppcsdudgny3665i5mfwcr
X-Rspamd-Queue-Id: 4B61020005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775736176-725953
X-HE-Meta: U2FsdGVkX18OeJeuZCAjwWH9kdmWSMulbkeycGKYJnwn0hJMkJEk9qHAMFepd4+GXWGaIfci+7ggDuK488/xigGaXKgxRRV8sK8vWihYSQDslHzVgvyxD6JWMiT1Y7C0u+eyNQE2VTT/qpgBXOzboXDvXTUONQV7qJWtWVh9uUCR3Ri78YML4P3zb9vYHE0deVnLvpRc7+qQoM0br2tKDwwMYJ8RHF4IAjFHnWhbsOb9GLX0WAvg1r5IROBQrhUVsTBHkaQDqZGNtm7YfAMQ69KOp4XUURnft3IugNGHt6PoME+BUJt5e0P4BmT27LDhtQ6DF6ex3U5zUT6SmnUJSMK+FU8C5yBNehvdSRJSjHesdkBKVgmUl/d3Rr2e3jT90zQ/n9UP6FOhgBVNaxcY7gcD/PF6AclgJg1Cv44626+Sm6TLWVPQFsPwPCkwWJBThkfMWBJjpkfJGpjYj7WTzuITEbkrhaIRe+/FEPTh5Q6W9dPYKCsSCdIMrNzbRquSinQ4jIWRaE0P036I8FkyWFxUOqm2rIcX2a+hx1ClOwTBPliZQiqqp6+4ffIjgRh/iaQUtUA9IavqLTv+Q22Iqf7L3OuYDxH9h682JtKZf3VBWTBLKPzCk8Jp+JMxSBOFYzWm1cYBf7qTZ4vhsGYQ+KMmr05vgUvuP+wvEcMmm27sXg+YfWeu1U3bsKNUk4AVgyL9OvhOv7Qa8ra5T3KHByzlqfGElIpBaUpDDJhQxCBf3afizRcaZ+FdyE2yPyBnpxhYAl0Yi/OiDs6BMfRWJbhTF5qj/yH8gRS7QFPtFk0pc2WIfEUwntSMNIoTzrG6owxtnMQ02AXu8bg993hYZvOK5aa6UIY4necvRW1mz8op/joCpFo+9Z3rWcoTh9ZoJvhH4oImAiQFqvTnt1KxYusRzKCu/WIUrHD1tixpGbp+/vnZVe5zyP/+pSbWcPz8Mh7x1g5YUOUhL1LCq4t
 3hOARLTf
 lUbd20VgSrSRQMRtS83FmAfGmjIod+CA8chIUyZ7pW/oCfErdEYj0t0fAvGOXQKz5iPd5fU0VzhVMNq74rnJNmakYBSPUhuWvjuTh3i0gTA8LK58=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 09-04-26 11:00:33, David Hildenbrand wrote:
[...]
> I mean, it would already happen today, because there is no
> cond_resched(). So nothing to worry about I guess.

Please also note that with moving away from PREEMPT_NONE/VOLUNTARY there
is no future for cond_resched anymore. We should be starting looking
into reducing[*] them rather than adding more.

--- 
[*] not all architectures are PREEMPT_LAZY compatible as of now so
dropping cond_resched will need to be done carefully.

-- 
Michal Hocko
SUSE Labs

