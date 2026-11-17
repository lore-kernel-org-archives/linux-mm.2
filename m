Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99AAD606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vXq4eTWO
Received: by kanga.kvack.org (Postfix)
	id 8E8396B05B1; Tue, 17 Nov 2026 11:12:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BF5B6B05B2; Tue, 17 Nov 2026 11:12:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AEE06B05B5; Tue, 17 Nov 2026 11:12:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5325B6B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:12:44 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D53F51A03F8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:12:43 +0000 (UTC)
X-FDA: 85445104206.06.C888C6F
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 06551C000C
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:12:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vXq4eTWO;
	spf=pass (imf22.hostedemail.com: domain of nakixii@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794931962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUg9oijFJngLvXeo3djJLK5OYdiXHydsItyj0Mca3qM=;
	b=xXRxtV6oKK/6l/Qcv9/X7luUHhL3OuPKpbByZr5W84tJ5licDrY1pyfEuGDf3O/B2XKVvX
	8hqjEesQ/an4KjMRz+9z0HuheWOWH4zYjWZQ7OmHmYv8vAOswjkuGvAZ4qnl3fNIF7xZhL
	c1ffX6xSqzWO9hdZnTYwKcOATMmQG0k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794931962;
	b=HifP7ueoBkvMEJ+Fvz0cAw0O2ziDAc9fpdpcOufbsM+tRqJUWI5PvWbudpQzRgdXa7PFLo
	KJLBBbDakwueB7zacTtmi3N42enEXUdOIi9McElImYws8eDRYLU8SNc5fpxhFLQor91X06
	8tktPKwVn2fx8/NMzy8pY+vrZVEUC7E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vXq4eTWO;
	spf=pass (imf22.hostedemail.com: domain of nakixii@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cdb684859cbso23170a12.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794931961; x=1795536761; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uUg9oijFJngLvXeo3djJLK5OYdiXHydsItyj0Mca3qM=;
        b=vXq4eTWO8LgSp/SOEj0AiWoO0QKNT7fDSR36abBZF6GVW109e8KheZquQSXhDWjujI
         467qxxoye0u1g5tUU2m+ASMl8kWpc75RAHEfRUCZjd9ZH3MUmv71axSqsZLqNnnvP6fp
         l6figPNEyhC0zF20p24OdB2cA8bo1ekgnwxO+IfDEBdh6nQbTEvFYIaAXoFA5IilpST2
         eWZZHxduZfb5GMSta2mndj1810hVu+rwmfavG3BiyVaTHplkHJ6BH1DZDORTfWm0DKt8
         3kG5ExacliF1piKSNpo335qHjxo5ertccSU2buG8lZkyKK3knhoDnvbLO+QTcToKMZkj
         pdKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794931961; x=1795536761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uUg9oijFJngLvXeo3djJLK5OYdiXHydsItyj0Mca3qM=;
        b=j/OEpPyNhS5g1sNVpSC2KGQFMn6DsfbYDCP7pFE5BnxGdMqHM8pQWmJCbt04IAS6Mt
         nCjWo4tDdnNnTllZuPWETSoGqD5wJWL6R1jfBsKxrQwbluEivGCz96DQl/P8OnN+Bsox
         Ydi1nPqzxNQvYwuAfLx4sfu7wusjpIbv2Xk0AI5yKaoeKGM4hAFaVRp0HA2lb+V6eHId
         5kZC7RFs/4uVe+dUGcBDoacMXuj0uXefl7wRBC5l2c3gb48R6R8rt3U8A2z28SfJclXv
         k25OKYldMjKXXGJ0JWPDSHQI2LjBUnT1eXujHMelVlLcz4QdGXe4DtmhZWJTLUrMpteS
         dw9A==
X-Gm-Message-State: APuU4Z98dbGw3JT1VdPRW7RDaBK04PjDQOGRR/36Bp7XNmV34SHdSdJL
	Q1jw9HqB5Hazr0T5RC4BEe/OOeuVyuX6FL5nVlyM27sSXPJla2y1xC+i
X-Gm-Gg: AZFdTZea9q1SAT0jwBva4aKIGS3HQELeUxC+tdlCxJRapGERDgYoIVzOIzt/4WwnGSO
	iFfVt/u7XuBs1n+zJQhdhCsxX99uSPPn66Ypdzy6lWXYDkwM2qovQ3DWDQd7Grfkk3Cy+WWm0kq
	+a3m8SbtUIi/PDu5IawgVWz6hwrwIsr8OX62Y2yoyfIbSH6t5ReY4wLzAUj73rHhFf/7/KHPZry
	qikz0N155yMT0vQjbdtMm2bA1v0I0wDlWuGqHDOfkGQdnNhLm+QQpEIAFnG0PFWmN3netWEW8mM
	nN/9x3mRBl/XduSnPygBw4K9+m2N5LQJwhOC8odQZnIxhgtrrP2CfoK0uXbjeQR+zh8+CsI5pp4
	VamJk7C2USMUUHWo3cbKZleyR1La4EXSGT3KvWod7IATVTnlBVF/yDVK7CxSpORBH/xnDhWHsdR
	lM0dB8vg01A5ACtfaAepEossB5RWcK6DGFQ/w6DZz9oBagP03LJZptOmDFktj+bqnOp6rbQ9RzJ
	IdMxPUx1v5+D3WqGNBIxTbVN1e/iMa9IcGYbSigetZBa7n6DqqFK+ciSWTCn0VvnzKXUm4BwyZd
	jkLOkHPPpZZ2MrIYcA==
X-Received: by 2002:a17:90b:4c44:b0:3ac:7f4c:a68c with SMTP id 98e67ed59e1d1-3b1b0a437b2mr14421846a91.49.1794931960646;
        Tue, 17 Nov 2026 08:12:40 -0800 (PST)
Received: from naki-PC.localdomain ([2001:df0:a640:2::19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1bfb607e7sm8435512a91.3.2026.11.17.08.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 08:12:40 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [RFC PATCH 00/16] mm: add in-memory compression of reclaimed pages
Date: Wed, 18 Nov 2026 00:10:28 +0800
Message-ID: <20261117161028.475891-1-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAKEwX=M64ZmMLBRiAQ6FiiP8f=jkA4m=HM8rgQo-cir2SENPnw@mail.gmail.com>
References: <CAKEwX=M64ZmMLBRiAQ6FiiP8f=jkA4m=HM8rgQo-cir2SENPnw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 06551C000C
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: ng4b475819zzwdwrqnrtqdy87ia8mipn
X-HE-Tag: 1794931961-205769
X-HE-Meta: U2FsdGVkX18KW5/WneHoPZ3EXT+JVI5fCD1ZR+FQu5XBfcPxSVWi2GM63gdwQfSY97FfZjnriXCA91fNclwkgJEx7jWu3AdO0BAN+DHBUnJzRnwY9upNY2jHEBcfOyaWrJTvu1WE+ziKVzYHSGQzUXGd10yuvqL9VkkDhE+pen7K7N3oIZIT7bc9My6l6UBzrS6baT1lFKtMtIbNb67206p5JsA0piDcTZNJx4lySKctIFEDD/p3oVMZec4Zk7Hz/BjWwtCKygmxM4ofOsww7n8NItzJofoaQosT8S4WG+hBEdVposKBbxLZK7elOS7UWmBuJrM65RsTgX05ITi2xk3CtBzVaVnKLjXfhS9kY1X0+ax4IaQF8Yf7GDqKsoHpqkcHs1P3VxeWOQhYLqe8t+133z0oLZWpDftlVxw1e0s8ehmF0xIoZa0vRaD/q3rZnkPECd6jQs+U4bA271aId0oxH1Nk0q9/yPtsWE0nPyMzKKR1wB38tvWZXhPe2fD1mek0utgsG1AtNZEjT50dxf4EISt1mg5bx/NeJcuo+TJF8flmcw669X+jibx46+x3Cs8GvB02dxDzDCISdGjLB9vElwe1dqBQaI7Z8Mf747FoXFag82N6B6m0PJwG5SvRhYi9dgnKvHBWgq3pt6WMcbJjXz+Pqk6mXYSk63i0KS+N61uMt3z+wMl1L9YeXzosGy1kGwHs1GfHvJbPVL3tVNe1ylYgM8oYcP6emBvumRAZhmf9ibbBt11mTzio/sMwfu7S1xSUh/UqSIzQ3wtEt9eL/UK1ZiZS2NBw1f41c/deXODoZSxx4CzQD9F1sgl7eFcN1OJpJY3BHIEppZRaVbxIRwV9fbYmCqunzuE9Iugv629vGkkgCRCJAi5tmtSCRzkFqa0lAPXPFhFUM811euRoXhb3UEanl3tkcVRsMxwIPGu1H6EJaVQF78NSOPJmKYEsgheXrmsn4TVJLiC
 X8+Re8r8
 tqVuirmyNQzpU5ST1/yskNYUhFrdZvO5+52xGw1ftMBactDas0ZrmEY77VsD3OMFKLLteqKtxExdacBsfFhczNG0BJKPhFcvB6hdFHdNrCJTi4qnsH5z7TRXaMctMMu+Ql9ywz7YSQm5dxGPyC289Vq6u2ZbdK8G/XS/OEfucp3IgaASqD2Wz5DfgZ6IhYLVa+GyW/9C7Qe75V3T0zM6XpS1SOcI3gM4XDxFcYPT8M2//10axl22xGeTdwtvj0TXRx3bTsAQ2jnO0x4/79yNHKnYPUFM9RWm7r3kAW7lkedWCjRlsseHTFZS0jVWfGSaEbMkSq3uzXBHbg4bFj9gWjhbXdGkvtGv0837vdRhmGg8sKdOe6rWKLiF+15s4HgGPbNS/rWFgv2tsLm6oUMPBL8N5uAcTNsYk/MRylY2/KArvV14ojSwjogK3AsU/s+DdHoTuk7v0lCydESlyXZQQ1GnW+/i8cNZAMyk/WLfjMiHpz+8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 06:13:46AM -0800, Nhat Pham wrote:
> What's the motivation of this line of work?

It started as an attempt to get something like the Darwin memory
compressor on Linux: keep reclaimed pages compressed in RAM, fault
them back directly, and push cold data to disk only when needed.

Honestly, your virtual swap series already covers the core of that
(zswap without a backing swapfile, no PTE walks when moving between
backends), so I don't think a separate subsystem is justified.

The parts I still think are worth looking at are restoring directly
from the pool without going through the swap cache, and packing
several compressed objects into one swap slot on writeback. Do you
think the latter would fit as another backend type in vswap, or should
it stay inside zswap writeback?

The numbers in the cover letter are from 6.12 and don't compare
against vswap, so they don't say much about this yet. I'll redo them
on a current tree first.

Thanks,
nakixii

