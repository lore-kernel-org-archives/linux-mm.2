Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6535606AA2C
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X+e0Bvce
Received: by kanga.kvack.org (Postfix)
	id C45536B0700; Tue, 27 Oct 2026 08:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C286B0701; Tue, 27 Oct 2026 08:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32CD6B0702; Tue, 27 Oct 2026 08:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 915126B0700
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:31:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3594FA7ED4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:31:23 +0000 (UTC)
X-FDA: 85368341646.23.D315819
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 29AD914000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:31:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X+e0Bvce;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793104281;
	b=31QSm3BWgt7yCxQ5bA4a0de7snIEWbKsIuJ83XqHFI+vofKhNIYiYc4duYWymiqItI0kI8
	+7q3DkutJv/wxBrTaEuqRq9dpbsry65Ae6+aFHOBrtAzUVPyYTB5nvkYgtXChPjua+6Wy+
	I5GIRJqJrUQfb3EByUwxiyQ7B6Ncza4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X+e0Bvce;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793104281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JA8h9KUew4bMbADI2oUInBzixioja4qGJWsGZbSCJpI=;
	b=ooLt6vKQwLmbBMzwBsm19FENOxIhHBZLrVbk3E4D4UeoLXxn0sucCioiKS1jNB8nqia1Cf
	pIdcBc+2LF6+GQDS4mHCYIBseaRzTpJCznbZGxDemD8FUEeLKWymZn/VZyl/q2lfjNGrJw
	f1scs5+rRFZTn1sBiXbDT8QLv3iDaDI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A05C43BCF;
	Tue, 27 Oct 2026 12:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C791F031E8;
	Tue, 27 Oct 2026 12:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793104280;
	bh=JA8h9KUew4bMbADI2oUInBzixioja4qGJWsGZbSCJpI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X+e0BvcexZwh/4AUnHQPe+d1YBwAqRcptdi8/Y360+KTdQMvrRBMo8bCd3Rg7pkjr
	 jfR9skKJCbBQUMZqJGiBNCLBi5gH6BVcLZ0GgQ3+2X/G3t9EryZbMxC+LsCqAiP1qw
	 DfEfACQz/D/ZpUqjz9dgH0VUCxkYU771b7/ph67qzFsU4AEno08ZvoXbxxTgWcmYvl
	 6zo7JiiNXHjlpfjJMU7RfZombHjSCq75bqaQ7fC8OhmztiCuY+9yfCmCk61JR6zHhB
	 OUKFXOmOR9BBW7Mp3w0zw9jNgjYqIEIRzdi5aBqJboCWtprx9MDOF1UIK0XZDyB36R
	 YX+eBtDE94n1g==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id C4148198003A;
	Tue, 27 Oct 2026 08:31:11 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 27 Oct 2026 08:31:16 -0400
X-ME-Sender: <xms:j5ngal-y604h5FHG0gXKO0JmoDwIL5zzPGd4jO3XJuWRuM9_zDhsEQ>
    <xme:j5ngaqLEQk3URLOEPxRY4eI0AJ_6xo_CoZNe0tDshbQ3sAFKU8ZeVq4MgnN_XMqiK
    _ua5k2oo1SM3kSqZI-xgTWMdqdbn9L6Er4vnooBn6Kz-JqBLvYqvaY>
X-ME-Received: <xmr:j5ngakfb0U-6wSKAMAAuXWa1RyM2CZOiZ_Wxt5QsSHbi7YIDHA2V047hFnU>
X-ME-Proxy-Cause: dmFkZTFr3RumHCfbQTlQHvPlXFybAsM2kuRamaLK+DcsHGJnUk2aCjGXXyr6NKWi0kroSr
    Oe85i3AcnkoxYUwKMUsCnYv3ol8I9M8cSn01GHV9AOTm5NfBjd+kCIjHiud1PAPzD5uXXl
    fN+b6rTVdtgXXvR1Z8eNRwhKI9yHxfQGGUEg7jRZegVt2fzj4kjjkHnB7T87ApQJ/YAHeu
    jWBHnlmzJHluxF9tAeEQxnoK263SXj0iYueuHFhGeOpOuCn6b2DvTIZwBEgN/+EwunXjB8
    CwEWM/ocJ/P7R/h2BXkq5SQ2kHartw+7bNjA0Gxa9vs0WmUsZFcGkZnIAoPCICn1WzThUZ
    qOz0AVGhp67x0YgaM1Ydxlnbw0N39OED89qvX5lcwiSM/HqWSxoVFWvTjUWcewSd7SviP7
    dQ04WcBrJE49hc8irsEuh6Xa8qmKhTv5+27sFoWEYs8ENR5FLW6D7hiRnsGUpkMI5MQceB
    UY8D9iJZ2kbY+0kfGnpFDbFzlSAgxEsNQH68IGiYsMcu566/hZL7hfXo0u3QYxpuXTE7Lf
    O/lVEviaducfFiifqy28iVecFxFVMJPrtttgxyJ2XsNCKh4pSCNIqqAiDWXSVimljJQasr
    nahIdUaatb5eDNRDlsczlK7MH5d2+R1Yg4ux3pWMJw8eTuDTZQQKwN8030Jg
X-ME-Proxy: <xmx:j5ngapdOe2vVgT2grTZ7td90xi5lIyt5aieIkbjFwmg3Etw7YEqT1g>
    <xmx:j5ngapmM3_rgC-TQdk-_fUW-n1fySSsx-acomwLSyc5CSAwThQykbQ>
    <xmx:j5ngaj-OF73Yr5lXoFTaJVTKBEidGV6F9smn42IfhmEA7VgztmdNDQ>
    <xmx:j5ngako9ZmvbpYbK1nNMAg6ZB9VOY2L_aR-L52n-Vgzbty7vHU_EIg>
    <xmx:j5ngapKn1Nv8aWmgJR2WTfb1wwuHd2q0Y6X_2YiP6_nGWPlBzweQOT1p>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Oct 2026 08:31:10 -0400 (EDT)
Date: Tue, 27 Oct 2026 12:31:09 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
Message-ID: <auCZFckDfBMrlfxV@thinkstation>
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-14-kas@kernel.org>
 <ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org>
 <at_f43oDv73y-t7O@thinkstation>
 <f97a8d33-50b2-4a86-8381-ee840cdfa2f9@kernel.org>
 <20261027110028.GH2668564@noisy.programming.kicks-ass.net>
 <auCKv_omLGRc6wv2@thinkstation>
 <f3f3aca9-bdb7-4aec-9099-9fb63a60e61d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3f3aca9-bdb7-4aec-9099-9fb63a60e61d@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 29AD914000B
X-Stat-Signature: d9h7nkhtkmnbtedtbe9cqz8464pq4z4b
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793104280-832174
X-HE-Meta: U2FsdGVkX1/vxao5xxavep8isXSLsiPq+HDTwCDP7+M6QYBoSRPIJlbyvZgZJjUA3utdDO1q6N66bXJUApxoSS05GDRXKvBzLqn2O3NXePd/+yaXy98lCpCRedKNFfTEM2sgDNiFtB7z1l/swXDpLawzwNvJmnvg+ks0YelnrvAZ2Aajz+M4OiseUTtQaFJPlHiqXSe2qa8f+8wqotKDXuWZ7IqflcabaUx4/VVM1sieSUUqO3CpI968X6gavKb3ad+JZ3H6WmLp6+4FQPA/P1JAYUFXb2IaPVdhS/jFhocwxllz4gYrTLkv6KvePWHr4ppTx14e9OlXZiDApya80/5HqiNVtMC4b2PDmrHdaZiclrv42v8xK3h8VTeDzd5bjcpoGpDLoIDuIHFlQHHD6waqgt1YzTZKGsLliewWep9P6GQh8ElRrIgjRKlS1lY9Geiko7/NF/ovPyggplEQ6MuAtLjgcgIpETWDETOikKGrnXXdTgp0z+evipVqc1TzktiWOWeJPhH9eI4IXSRQSBZCWdKbfbcypgsa5VvXY0j29GTqp06i402PDNuJ+RQNkMjiEUYI9buz9Il2JS9Ncf9Bp1LkZ8ANeCDpuXnWjepHGVeDTkvHaYC+J76o7Os/yloSSUwl9MXhST01AHq4DRYey2jBWCsSxAmN7HZ+97iG1Fm4ODuyj7AE4jW7fdnMlGmTmZwUATtJA1wQbOKdwCMa7He2XpU26vv9O3qR2KM0wXhuezSML+C1Q/iEveMOndXewGUY3QHg5oWvQ7D/MEBYfoHsGbXzqeJSEKV38U4WbY+Yu9hr/YBvTa2RqbC7VAUUeS/ChOTjBHfNgSssVDn1xdqmUHo3ub3a0YFsdGLBqnfZeSUUPjl0HlNxsVxOGa3GIkL9vGsuXly5eZAeWQzrd7vNAnjPW0KvcwJTIcNlY+2W4/1naubnEk8RrTyVp1iVyWIjbJgZTFi+Fa+
 DHiKuMS0
 SbkGllzyPhNRS5cef0tcmnQuod3+GaWZgVCwLK8RIudhpG2aJfbJlNAb56LPaD6OxPvvdIo0HqhGvx9mMQfiqkTNadMkbBwT4D3K5dTM1jqScKGc5fQ5jqJLUsl9GgxutDq0CIN27p8LJBpT2nGbMmF1RujJSGXcwo95mjnLB4oRwmePQYEualcraRT4CN4SaKUssXSNjxdjU4TSK/5VRk/31L045pxaxZHlWWZEebMwV2j4uMSkVJdaju+aeLss5HpfsVcrMYs+ue/wP3V/rPI50UA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 01:05:58PM +0100, David Hildenbrand (Arm) wrote:
> > Writing this, I just realized that we have another option -- map the
> > shared tail page writable. A failing LOCK CMPXCHG writes back the value
> > it read, and the get never changes a zero refcount, so the race becomes
> > harmless. The cost is the protection: the page is shared by every
> > hugetlb folio of that order in the zone, so a stray write to any tail
> > silently corrupts all of them instead of oopsing.
> 
> Right. Without HVO we would just corrupt pages in the single folio (which is
> also not nice).
> 
> I'm also questioning whether we need this RO protection all the time active.

What do you have in mind? RO only under a debug option, or switching the
tail page to RO some time after the remap?

If it is the delay, a grace period alone does not close the race. We
would need rcu_read_lock() back around the get, and then it is the old
scheme with the wait taken off the allocation path.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

