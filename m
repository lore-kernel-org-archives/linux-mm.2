Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11C4EC9832A
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 22:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDD416B0088; Fri, 25 Sep 2026 18:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB57E6B008A; Fri, 25 Sep 2026 18:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCAC86B008C; Fri, 25 Sep 2026 18:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C28BC6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:46:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5E8DC1C35F7
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 22:46:19 +0000 (UTC)
X-FDA: 85253769678.10.0938C6F
Received: from mta0.migadu.com (out-253.mta0.migadu.com [91.218.175.253])
	by imf17.hostedemail.com (Postfix) with ESMTP id 077A040007
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 22:46:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jj6FXgnZ;
	spf=pass (imf17.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.253 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790376377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=33OoWhiz0tW19vrTnsWs4nyEh1p2NzVwA78ewMVnBFc=;
	b=QIh+Pp5zKI9sl4A3VjSUmguFsYa3Yp+ksxvl7BJsW0uv5rubIJT/Y4Smd4FzaVZoH5ZoBp
	46pXJnmO1mtzWBflLtaxRgbiYuL7o8wWt7yl0vDa5BwXqdQd23xHZO3+xyensXDni9F2aH
	XMRlnaTzKm0bYbCTVwrbzEPOb4Co0cU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790376377;
	b=A1hH1qmC5F1YajkAsX7QpWS6xdjq870SStplhlPSqEMVhpAgoOx/jE82cJUC/UD6BuW6Xe
	Bg72o69iXTdF0nj0P0Qa8NYq0rnVZV4Yr/WHclTcAf3Lj5SRbruvLJ9U71KLvesqJ38j/4
	tO+s5ISbi/7ybDuBIf9Ejj22X5C8GwA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jj6FXgnZ;
	spf=pass (imf17.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.253 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=u9HaVC9yb8cnMF0BGh/IsIBs0kCSUhaTfBn+ofOxLvw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790376375; v=1; x=1790981175;
 b=Jj6FXgnZqdNjvmWPQpTlO+j9PSTFAiw+mmoId8VpWVCEJ4Zsl15zhUEBN05xH7esUhW3nc1J
 apt/c5vZQ8ruBay3405/sl79CqrWbcFIdBAv/1LqGeeYYklHdSVfE4JF6I0a68t/sqY/q0S7oPS
 VxY24LuFjVpw5k+rnsY1zZHs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id d3ecf85df4c964fe;
	Fri, 25 Sep 2026 22:46:05 +0000
X-Mizu-Trace-ID: d3ecf85df4c964fe
X-Migadu-Flow: FLOW_OUT
Message-ID: <58411d37-dd5b-41c2-8b9e-d54939a1119d@linux.dev>
Date: Sat, 26 Sep 2026 01:46:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] mm: implement page refcount locking via dedicated
 bit
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>,
 akpm@linux-foundation.org, andrew+netdev@lunn.ch, apopple@nvidia.com,
 artem.kuzin@huawei.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, edumazet@google.com, harry.yoo@oracle.com,
 hramamurthy@google.com, ivgorbunov@me.com, joshwash@google.com,
 kirill@shutemov.name, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 pfalcato@suse.de, rppt@kernel.org, surenb@google.com, vbabka@suse.cz,
 willy@infradead.org, yuzhao@google.com
References: <cover.1789239015.git.ilya.gladyshev@linux.dev>
 <ebd6540ad89a4bb80e2a62d00901b5c827315b66.1789239015.git.ilya.gladyshev@linux.dev>
 <DLFJL5U9DI6F.3QJP9YP0KX636@nvidia.com>
 <56e036665dbeb0a8f51d697220d5ed84f210994c@linux.dev>
 <570cf649-a8bf-4073-be71-207fbb2bef40@kernel.org>
 <CAHk-=wh3LLDV2AMZn1PZcU1o3Na-BNcQtP=LPXouLKPZWaiRdQ@mail.gmail.com>
 <DLO1WIACYFWF.3N01DXYFJLMD0@nvidia.com>
 <a1d5881926dbf4b16dc796fb1da939f32dd42f18@linux.dev>
 <CAHk-=widZMoVwT+to2PKPfy-y2gERYWdLsZCZvXcz0ZbXYpt9w@mail.gmail.com>
Content-Language: en-US
From: Ilya Gladyshev <ilya.gladyshev@linux.dev>
In-Reply-To: <CAHk-=widZMoVwT+to2PKPfy-y2gERYWdLsZCZvXcz0ZbXYpt9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8c31kxojbo4heug4wakscf8pgi9day1i
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 077A040007
X-HE-Tag: 1790376376-307759
X-HE-Meta: U2FsdGVkX1/2k2h4ojAtwFgCFyKhNhHghjvwgMd4oFHKMTcbRL0uz9A2Hh/w/hStlpYVsZLuhcEPoqE3VK0GqUyAHfRBW7BR/yzQ7CktGGmsdkJ/SUO5CoKOqlpS/ojnFi48cV0ehGqAz5C4khzIMM6dbWzIzrGDEoTJxbnb26KYWpjXHZ6HSWqQJq9nM930L/uiBpn+nY07JYPpEUyVfOgB4GKwNjJGszHk3TWhfM7c56qB0cN+7Eyv3cNJqax8/KorHhdL5EXhZrW5MhPR6bzIZRgHn0HL2kQ1/Wwb08i1cvpN20vAvYB+AOKp3U/bGYK6IGODaLQ4jpYLxniDfjALITCdERqRLtDyYW8/Jy7ojqdlYdcrDCBMe2Cu602Ai4XS+VbjOjm4oS9et6x+eyWliAtrosJTWLHqphIU/w+53dsI2eVWAohRa2vtW0hsUxmUZ29thPtCzh65/k/G9CmqfB4VBFZoVEMM9pa5hPbWfwZAtawRsQWhysyIBrSi2CVtACsClf3UvFDds/fm1EJoAvOY86knZmg1+9sEFVpthzcdEszkL5NMb7WTZgYXV3N0wLR/54RVN3ZhLjqz3MotdV/VunAH9UBN2WvZiz1ny774KYS/5TsWtRFef5GC6Cbw7MRhbbkUsQwLz85HdGw3rzKjf9rvfMAIdjG4KAlc8S/mZg68bFyuSUulcGfgNfUPvRAZt9ycQ8f2aTaMe9F3PK4mv5fwM/QxcS0WEyuol0zRFGiiL4m7VEpYneKNpaWn6JpZnpNopcgTdqTPNzWdcfgxxATAi99eBJjt4AJG8C4rlhLa/u2ql/925vdbH2gUT70Sp4vY5ZWTiztLYmcA8W4f4vhLqfE7esOBUG5BzwGnKvKnFu4yoQ1RISuswakPkJrVa/Pr1CKH1MS4rt2V/SIt6GklJAiNl8QIscuj76Vc949oFMy2KcS9l6lkowJMu5VaPsQehWh7AVZ
 wbI2FdF9
 YUcUYSo0ufIKg6S7q2p2R7FnFUBgAQop7OiLvW5XSZIZ85bIHDIKiq1oz9sJd7wEqbBerJ3gCMhR8HzoLpSijFH1aZmopRBAHFUR1AUNnRQPKfvncp7N/0kOxIBMyaZTu8XRU8PrM6ZYxR9m4jdKh0gLB3MjSzmrhnnia6BpBYkJGNNbaiOiYwUS0hzGpVxUB59PuspEw24D7qCwFHOQFe2AlsQghLPpg2odGW81Wrxi25eoglOZIC2ADpdZsNhLQvihZsegAVFWlAFq5CRJu8In1vvEldkfgB1HQEHqZ/cRfK3orKOJY1ACMzHVfIQ/U4IHCdD2v8FEmsGmijrQRMs/wW/eJ8dzpfDvXrLkc+qGwFjYxY25ESZFq+fqjTYvr4LGHN9bHbIlAqS758DIk8+ru0xIkoN9Ky5Up
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/26 22:00, Linus Torvalds wrote:
 > On Fri, 25 Sept 2026 at 00:03, Ilya Gladyshev 
<ilya.gladyshev@linux.dev> wrote:
 >>
 >> Hmmm, I’m afraid that since you need CAS for a safe 1->FR transition,
 >> it will result in a CAS loop for the decrement itself (like in
 >> atomic_sub_unless). And this will introduce scalability issues just like
 >> in folio_try_get(), but this time for everyone...
 >
 > Note that we could make that CAS case be the thing that only the
 > special cases do.
 >
 > IOW, maybe only do that slow sequence in compaction_free() and the
 > memory offlining.
 >
 > So we'd have two different cases:
 >
 >   - the high-performance case is ready and willing to accept the "sees
 > zero" window and the extra 0->FR state that can race with somebody
 > else taking an optimistic ref
 >
 >   - the unusual slow cases that are *not* willing to deal with
 > optimistic ref takers do the "CAS 1 -> FR" state atomically and always
 > use compare-and-exchange for their freeing path
 >
 > That actually sounds like a good approach to me.

Cool idea, thanks!

This, however, will still require converting all page_frag_free()
callers to use the generic dispatching dtor (which is __folio_put()
for now), right?

---

Beyond that, I see two trade-offs with my patchset. Neither seems
important for the current kernel code, but I'd like to outline them
anyway.

1. We lose the "high-performance + custom deallocation" scenario

For example, in cases where the current refcount allows you to write
the following:

if (!put_page_testzero()) {
   /* We failed to steal the last refcount. However, our refcount is
    * already decremented, and therefore we can move forward -- the one
    * who stole our page will free it via the generic dispatching dtor.
    */
}

The proposed refcount impl will require either a slow decrement or a
proper (slow) deallocation when put_page_testzero() succeeds. So,
basically, the compaction_free() scenario but with a performance
requirement.

2. Page deallocation becomes unpredictable

With the current refcount impl, if you work with a page of "type X",
you can be sure that folio_put() will perform X-specific actions on
it, and you can make implicit assumptions based on that. This is no
longer true for fast decrements.

---
Ilya Gladyshev // foxido.dev

