Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1425606A6AC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 14:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LVEeRbRa
Received: by kanga.kvack.org (Postfix)
	id D87606B05B0; Thu, 26 Nov 2026 09:31:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5FCA6B05B1; Thu, 26 Nov 2026 09:31:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C742E6B05B2; Thu, 26 Nov 2026 09:31:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6057F6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:31:07 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DFA0C402A2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:31:06 +0000 (UTC)
X-FDA: 85477507332.24.5092C21
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id ECDD3C0009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:31:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LVEeRbRa;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795703465;
	b=uMTS9mslKf0sXX1nJlqynqLXgVtw4UejXAzpQS3q7+0ep1oLggmjYImfCf+rydQMzp9EOK
	XafOBW5TVm98OTuDDYprzQY7DBdIbOsKXKSyGZwNdYi4Ad79nEH+b37S+XjZMKWNeFOdLo
	pz9wYdEln/gpqrg36Djno8UnhcNQmH8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795703465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5r3XjtXFsLjzzhMzj390HKNPBHceWrZJqEAhyaam0k=;
	b=2odjJ/8DKqDvrBRtMcgjBrmeBMPAZCcLseFeYNe2geZuhzJJEcySnzuslv613x9mFR368q
	fOe8uP7x3JPlpNdvfWy5IImkm/5oIzG/QHonEWqx5gjOiFs/urcVTya+mU76tuIdO+CyGG
	G37Q8jgI2A0R3xAmQbWrp+SnCu13WHE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LVEeRbRa;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE2881BA8;
	Thu, 26 Nov 2026 06:31:00 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E9F83F86F;
	Thu, 26 Nov 2026 06:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795703463; bh=Gh8fyK7BLAji0Po7ndrDo9Z/I+fzSOToLbTFsVx3zZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LVEeRbRacat2kmxF2QkCxag4t6jAyhtj4S+xDo+pF7fMr1Tz/HhujzVMY5tHehXMU
	 qCzCPO6R0EVjS9S8Iu8MQu60xg6xWeReC2v+YlZNpk+tZF0qOlBkj1aO4wtTScfy+Z
	 21pgcGpco2AGab9fHjE3qak7bp9yODvWbgfJ3hW4=
Date: Thu, 26 Nov 2026 14:30:54 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Mike Rapoport <rppt@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-openrisc@vger.kernel.org
Subject: Re: [PATCH RESEND v2 12/21] mm/pgtable: redefine PGTABLE_LEVEL enum
 with ascend order from PGD
Message-ID: <awhCnpiUc1R_BLx4@e129823.arm.com>
References: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
 <20261102-dummy_ptxp3-v2-12-78840b2ec73c@arm.com>
 <awXD4i47F-VAG1tD@kernel.org>
 <awXc0MSZl9t9VW8e@e129823.arm.com>
 <682c765f-332f-4ac2-b448-4201c8fae6fc@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <682c765f-332f-4ac2-b448-4201c8fae6fc@kernel.org>
X-Stat-Signature: h97yxstswi3oe1fbqt4cnzpg679g3yba
X-Rspamd-Queue-Id: ECDD3C0009
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795703464-436162
X-HE-Meta: U2FsdGVkX1+qRqBxU93EXD5D7QMbGknm70npiD7uOtLz6rXnesoiM+lPLabkIpabRaP+gExuR+s7GHDEJhQ+ZzJfe6YdwNhYOK2w2FBpVlHw4z615pLEA4OXOmFuRsk63TdKRRHWKljovT2DXfoxOqOVr0MapmwWb4UgMZX0SO0bs/UwNdMGV0rG+copiXehjp3TOujNiFSzeJ2U9X6vY5LBh8QGjA8Y7o7vWW2ihAhR3Qvrnl7/rXm/XlToVjHXI6EVkKcB6oBZ2dSHang0EUrWHbTQPD+5u9RMe50Fdnn+kQ7FKPp0UCSYVq7oohw47otESDYikBxsg5Lbj9eXfTZKFOshpzyPztr3h7jw8LFiTQ937tev0qzHkANIrNdxy+4aSdO+XQry1jgvzm/SBVHxSXEEm9SDd3CcfCeL4kYCzQDGNrizSCSL3q205ZVjSOnk36apg9sIdhJXMAB1lpAM5uyaS9IDRCo87UnZTt52hjHvMLTn+6qcXjN8D4CQZVsJr6UJfHXbIrz8gP8EvHN34iqbO5ad3KvqSLaKX92yjjf0B4vMDIj2nBIj8h70LKyvuWEOYDMc3yqOXVQOAOhXis4tyuA9uJLD5LRXFbYw4Anq5TZDxX3waapI90blOl0Y7qsBpV5YX5Uj62Ec6RX1HVtbyk2RqqRz9loLAJsomYwaGyMkvtv/4v9ruy3rwK5wDEllGOTKFXw0eLuYMWvGoEEOQ9Z55IgK92hnGoO0gp33EVnmSB0WvTrm874Xok0RfRkRbi5GVqG8YU3NGImL8EN2q1zj/Q7JJsD1oMPZzaMUfw20qEhn+DxKE3hcCk0wd8SjIavX5xkWpSGFXjeLStx1Kj5DJKnHubupUOqrZMqJWNAqBxNPp2ItFGFcgQH93jAJsak60GymFc3WfxAzET9Ae7Cd+T6Id40oZCURaFS0re4D1mYQqX6Glo26ywGf0tlRMQBozNy+X9+
 xznvdXsh
 M8EcgxMgHGzEtlr+PITpommy2wlK0KPbLf9muL3vBgxKFKp9B3vTqX8eRsLGuJ1N2qxFFT83qNFgoa3EqnU+ETZ9wNsN7Zl5j3JaM8EhNjPU4SDsxY+pGdTcufD/yx+Dtx4gU7QpwmPy1dXHS5wNV2hEUHlPw7tBJceBJlKxSjBCS+3C3d1QX9mEbiab0DmLO0PoZLSWjqS56Yz9FM2uKgSo7ofxuKl0kS6YU11h3bG+MEfXaPsxmlwhFcbAGTzndB5kLL0cY4Fu4+L11vM9KyuHydkIVtzkj88BcRgIlO0nF1YhYgagE3iJuIHLxrjyUE1QQ7reEaQJzXh/39ZEDoe67jpAjZtZLz7zX8Ercfys1TiJ3acIZWOGXxv89fGnBgniT9MgDUQr16o3yaY76Ysr0Hgx7jYuMQ5nZE43KMWVIp8sadMrAPs3sQ4Lk4uzNtbGMV5YqnXOWPQvCLwtwUP2yMpsPXLRk7Hb9aNqvTxbOVWgzopMlsyGvvvElRU/nmzcL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 03:19:13PM +0100, David Hildenbrand (Arm) wrote:
> On 11/24/26 19:52, Yeoreum Yun wrote:
> > On Tue, Nov 24, 2026 at 07:05:38PM +0200, Mike Rapoport wrote:
> >> On Mon, Nov 02, 2026 at 11:21:25AM +0000, Yeoreum Yun wrote:
> >>> The PGTABLE_LEVEL enum values appear to be ordered in the opposite direction
> >>> from their intended usage.
> >>>
> >>> Intuitively, higher page table levels should have smaller enum values,
> >>> but PTE is currently assigned 0.
> >>
> >> That's not what x86 thinks :)
> >> They even expose it in /proc/vmstat with smaller numbers meaning lower levels
> >>
> >> $ grep direct_map /proc/vmstat 
> >> direct_map_level2_splits 152
> >> direct_map_level3_splits 4
> >> direct_map_level2_collapses 0
> >> direct_map_level3_collapses 0
> >>
> >> Just an observation, I don't mind either order.
> > 
> > Right. I made this change because a depth-based scheme seems more intuitive.
> > 
> > As you pointed out, though, the x86 specification uses smaller
> > numbers (0) for lower levels (pte), so I think we can leave the
> > x86-specific direct_map_* entries as they are.
> 
> patch #14 depends on this, no?

Interestingly, x86 documentation numbers the PGD level as 4 or 5,
whereas helpers such as effective_prot_pgd() use 0 for PGD.

Anyway, this follows the usage and semantics of effective_prot_pXd(),
rather than architecture-specific level numbering, which varies across
architectures.

And yes, patch #14 depends on this, although changing the condition to
level != PGD_LEVEL would remove that dependency.

-- 
Sincerely,
Yeoreum Yun

