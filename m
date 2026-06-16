Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31006CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDFBA6B00B8; Tue, 16 Jun 2026 16:53:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D90AE6B00BA; Tue, 16 Jun 2026 16:53:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7FAE6B00BB; Tue, 16 Jun 2026 16:53:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 873AB6B00B8
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:53:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DDD1412023F
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:53:00 +0000 (UTC)
X-FDA: 84886975320.01.0B32036
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0D46A20004
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:52:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d19EmUrp;
	spf=pass (imf03.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781643179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cj0OqIIza8TZpzIi89NPwfYz5Lr8KtiNgulM6qKZaEc=;
	b=kOZv4w4hAjouzwpN+Tc9G0w85FOgGHVZxQCMkJwWuG+Q5nuOHrsqtZJZjq9fmylJiq5lNY
	O/HvMaNt2bMPMMf8+WRIk/eccyvhn9SkDR7kNcGaIKROPi+gDQuavHlQHQHbgj3orgLPlR
	1liZPxgqhCB6Hd4DA9VP/O42uld8Qyo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781643179;
	b=swJ66hBrKr6gw7zSVZVQ+2MRQZZjr7+QpkJLh9g1n55dbZmkKbO3LuC2/ndOkremFYDqqU
	QD3C4z/0HuOKMBdmydVYDu8NQTfBPIUg9yxREGgilcDdPHaOZ/loS9Q0YAn5i06KBsVAjY
	Gm0V3LQ7zmb8AadWiWWTUYJ5tdt3WZA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d19EmUrp;
	spf=pass (imf03.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781611079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cj0OqIIza8TZpzIi89NPwfYz5Lr8KtiNgulM6qKZaEc=;
	b=d19EmUrpyHfnY1cDkWr5Pgy+k+d7eFilIhNo+y4UIIjqndySCSOaazg/G8TshBKTyTYnND
	XCyUVJJyDOLK/bkGHAJuXNKw+fdkrix2cFn368PgpUQyupyTl+Ld5Z1eUzw/MhgsQEQYZO
	0Fwe6r3tB/j/kPtZNQWXjtsg7SB8wEw=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 16 Jun 2026 11:57:42 +0000
Message-Id: <DJAGEUY8S09F.3V3HF570G85OF@linux.dev>
Cc: "Balbir Singh" <balbirs@nvidia.com>,
 <lsf-pc@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
 <linux-cxl@vger.kernel.org>, <cgroups@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-trace-kernel@vger.kernel.org>,
 <damon@lists.linux.dev>, <kernel-team@meta.com>,
 <gregkh@linuxfoundation.org>, <rafael@kernel.org>, <dakr@kernel.org>,
 <dave@stgolabs.net>, <jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
 <alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
 <ira.weiny@intel.com>, <dan.j.williams@intel.com>, <longman@redhat.com>,
 <akpm@linux-foundation.org>, <lorenzo.stoakes@oracle.com>,
 <Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
 <surenb@google.com>, <mhocko@suse.com>, <osalvador@suse.de>,
 <ziy@nvidia.com>, <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
 <rakie.kim@sk.com>, <byungchul@sk.com>, <ying.huang@linux.alibaba.com>,
 <apopple@nvidia.com>, <axelrasmussen@google.com>, <yuanchu@google.com>,
 <weixugc@google.com>, <yury.norov@gmail.com>, <linux@rasmusvillemoes.dk>,
 <mhiramat@kernel.org>, <mathieu.desnoyers@efficios.com>, <tj@kernel.org>,
 <hannes@cmpxchg.org>, <mkoutny@suse.com>, <jackmanb@google.com>,
 <sj@kernel.org>, <baolin.wang@linux.alibaba.com>, <npache@redhat.com>,
 <ryan.roberts@arm.com>, <dev.jain@arm.com>, <baohua@kernel.org>,
 <lance.yang@linux.dev>, <muchun.song@linux.dev>, <xu.xin16@zte.com.cn>,
 <chengming.zhou@linux.dev>, <jannh@google.com>, <linmiaohe@huawei.com>,
 <nao.horiguchi@gmail.com>, <pfalcato@suse.de>, <rientjes@google.com>,
 <shakeel.butt@linux.dev>, <riel@surriel.com>, <harry.yoo@oracle.com>,
 <cl@gentwo.org>, <roman.gushchin@linux.dev>, <chrisl@kernel.org>,
 <kasong@tencent.com>, <shikemeng@huaweicloud.com>, <nphamcs@gmail.com>,
 <bhe@redhat.com>, <zhengqi.arch@bytedance.com>, <terry.bowman@amd.com>,
 "Matthew Wilcox" <willy@infradead.org>
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory
 Nodes (w/ Compressed RAM)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "David Hildenbrand (Arm)" <david@kernel.org>
References: <ag6XyvxR-NU5rGn-@parvat>
 <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F> <ah47NNhuiClgGCdn@parvat>
 <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F> <ah-0CyZurn5D1ezY@parvat>
 <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
 <c1b66e7a-bb95-4295-8193-55ceadaaa578@kernel.org>
 <aimSzvoJDrpeQsmM@gourry-fedora-PF4VCD3F>
 <d01fb1ed-2418-42ee-aea2-37f9a5c5729c@kernel.org>
 <ainFROZ3WrGioyuY@gourry-fedora-PF4VCD3F>
 <aiwl4kCG814dpX7L@gourry-fedora-PF4VCD3F>
 <9f1815b0-896b-44ab-9e6d-9316d8f11033@kernel.org>
In-Reply-To: <9f1815b0-896b-44ab-9e6d-9316d8f11033@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0D46A20004
X-Rspam-User: 
X-Stat-Signature: qibbjpf9awyii69xa34n71gi3kmj5rx9
X-Rspamd-Server: rspam08
X-HE-Tag: 1781643178-434378
X-HE-Meta: U2FsdGVkX1/naVADXhi5qeJYJCswivxjqN154MaiygO6LSCNSSj7MWzS39BERZ0PC8QRTpOrWp3InTD+42Ht6yozy5NSiBn2TheYONRoo+h8hKL4O8GgG2rSlRzn4UGfpwtDl7k1fxsx+uS1sujhCWGIyBSxb8KXb/5VwrwuX9l+LU2o3rQTnq1CQ6jRznXz0dbPXqKRHIyFeL65hJwVqaXYnqtBm8LW7djjFX+UnsSNZ4W8JnDjfmQmxmP9uJTy1YbSn5OweDXIyTWPLFUq6uQKm8Lre1/e/MpbYxutAjUoRXj+PEqec6WacWFLoXRNZde4U+Dy6Rk761PXiYbuE5KRdQ7YWTRd9ZuUF6hGTOcJGA4C6iUDaUGcsaLdZ5kL0NS4tz5UUvUSdF3R9UyIvQk9/soBuVK/7raiBggXzCP0I0HvNG7CAe/PGRib3obFP/mP9S2DdB/Obk7o4ZcPLHYjp0ynmf93S27TYn00gOpllA15gBZmS7Pp3+6fk091FkBzHCWPBT+kYmkViXKxFXEolvTvJX3vsZemMJOCzuRzWi9ciOjvfopGtDqKuuCdzH7vifGi2qKdp/UAHdo0rIYKmNLT9C2spzsAw8O0kh2A+XZTU3OOtS0UYcBoUWCRYNKBtf9eAnMTjJQx8ZZppRvtydfZTD5zkHJkVVxGblG42yvmS9GpYIGAXIIzD5B3ZoDHu1n9u0t19jx57h0+euoIRg2MUEhinF5IxeiwzCet8MzzQPkN7yInaucPv2AltsIGQ81wI4nulLmsNq3+k/mN7mKApr/hkv52+L1n9agKs7J5Awp30hmWUHIfEiqLkWBXhRtmIVjbvPHXojP8IK63F9O9ou507TV7m9sruLvH+APu4wgYch8mlUaLkEmoXiT7KQASoOALJk9D0PXJYqJvvRE1sf+a0Bbb1/3HOkQ66ZiQ+YiGtGPtRe4xxZImgKO/PD0DCANasperOQ1
 Le5QebZl
 eko3XtDO9WEO5kJiEGhauRELPayNkYJEcJ66l1nin4nam60raoY15+47zs5QiGmgz2G/Lll/ENO/KE2XndVALmVdhVqn/rzlSeWJnstFXlbUaHS0dsv0DbFDhTGyMRqJ3yO+kmRxrPOwoTFzH2QRMe1zkf5qk1njM9UwVDtgdNN/sjumGU5jCYMEyAOzJUoCzNKUwEWWpDUfMIrc5sGjlp0A0sBn/mM8G4d0FHhphKD+/c6y0SbLTKH4O9EyNLZvSfi02p4Eq5fVcfD18LmNHXxHA9Gfr+mNRew8xqo2KfYULnOvDz/DB6BRaFhcOg4xdvWBcl6CLUA4Hk5VLpOb7TXFM70Tu5a/p1ZTZ19HXJ31nSU+28YUgeMfqTmR6RVCfpDitZiU1hZjFg54=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 15, 2026 at 2:38 PM UTC, Vlastimil Babka (SUSE) wrote:
> On 6/12/26 17:29, Gregory Price wrote:
>> On Wed, Jun 10, 2026 at 04:12:52PM -0400, Gregory Price wrote:
>>> On Wed, Jun 10, 2026 at 08:59:59PM +0200, David Hildenbrand (Arm) wrote=
:
>>> > >=20
>>> > > I understand this question in two ways:
>>> > >=20
>>> > >   1) Can we disallow PAGE allocation and limit this to FOLIO alloca=
tion
>>> >=20
>>> > Yes. Can we only allow folios to be allocated from private memory nod=
es. So let
>>> > me reply to that one below.
>>> >=20
>>> ... snip ...
>>> >=20
>>> > At LSF/MM we talked about how GFP flags are bad and how deriving stuf=
f from the
>>> > context might be better. I think there was also talk about how the me=
malloc_*
>>> > interface might be a better way forward. Maybe we would start giving =
the
>>> > allocator more context ("we are allocating a folio").
>>> >=20
>>> > The following is incomplete (esp. hugetlb stuff I assume), just as so=
me idea:
>>> >
>>>=20
>>> I will still probably send the next RFC version tomorrow or friday,
>>> as I want to get some eyes on the __GFP_PRIVATE-less pattern.
>>>=20
>>> Also, I made a new `anondax` driver which enables userland testing
>>> of this functionality without any specialty hardware.
>>>=20
>>=20
>> (apologies for the length of this email: this will all be covered in
>> the coming cover letter, but I just wanted to share a bit of a preview)
>>=20
>> =3D=3D=3D
>>=20
>> Just another small update - I am planning to post the RFC today once i
>> get some mild cleanup done.  It will be based on the dax atomic hotplug
>>=20
>> https://lore.kernel.org/linux-mm/20260605211911.2160954-1-gourry@gourry.=
net/
>>=20
>> But a couple specific details regarding the memalloc pieces that i've
>> learned the past couple of days playing with it.
>>=20
>> 1) memalloc_folio is required to ensure non-folio allocations don't land
>>    on the private node, even if it happens within a memalloc_private
>>    context.  Since memalloc_folio may be useful in contexts outside of
>>    private nodes, I kept this as a separate flag.
>>=20
>>    If we think there will *never* be additional users of memalloc_folio,
>>    then we could fold _folio into _private to save the flag for now and
>>    add it back when we actually need it.
>>=20
>> 2) memalloc_private is needed to unlock private nodes, but in the
>>    original NOFALLBACK-only design, you also needed __GFP_THISNODE.
>>=20
>>    This is *highly* restrictive.  I found when playing with mbind that
>>    MPOL_BIND + __GFP_THISNODE generates a WARN (valid WARN, it normally
>>    implies a bug).=20
>>=20
>>    That leads me to #3
>
> I think the memalloc approach is dangerous due to unexpected nesting. The=
re
> might be nested page allocations in page allocation itself (due to some
> debugging option). But also interrupts do not change what "current" point=
s
> to. Suddenly those could start requesting folios and/or private nodes and=
 be
> surprised, I'm afraid.

Minor side-note: couldn't we just define it such that the allocator
ignores the context when not in_task() (and warn if you try to enter the
context while not currently in_task())?

(Don't think this would change the conclusion very much, e.g. doesn't
help with the nesting issues. Mostly curious in case I'm missing a
detail here).

> The memalloc scopes only work well when they restrict the context wrt
> reclaim, and allocations in IRQ have to be already restricted heavily
> (atomic) so further memalloc restrictions don't do anything in practice. =
But
> to make them change other aspects of the allocations like this won't work=
.

