Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8221BC982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 13:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50B8B6B0098; Tue, 22 Sep 2026 09:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E35C6B009F; Tue, 22 Sep 2026 09:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421316B00A0; Tue, 22 Sep 2026 09:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 215E56B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:06:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B22571C2AD0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:06:18 +0000 (UTC)
X-FDA: 85241421636.26.5A46455
Received: from mta0.migadu.com (out-209.mta0.migadu.com [91.218.175.209])
	by imf04.hostedemail.com (Postfix) with ESMTP id 84ED640009
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:06:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eO7VdZLh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.209 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790082376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VM9a+UzERQgojJ7DN930ciqqP9CjzWj3CgLRia1keMk=;
	b=dc3yBZF0Q8QcXmq+PxMKhf3bJHV2VmZPQ2SgWmAbwXYfp44xZVkfPM3Yv8tAZVxLbYzmNh
	CyLyywoPfwD8WILr3cItHMsfHtKFnQKWuE2/LwVHSCmekLXuVkN/ec60g6nSs+j2IZTdUj
	12ai/6YV00cisCzo7OPtyecqXD6/OJg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eO7VdZLh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.209 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790082376;
	b=xPu0wnXEOufyMmsHcZyc6vqlvAy/7wdNLUAlNUDQelBR6vMI/D3o4eCcYEvOgPLoYLA22S
	hRU04HGWuNdk5VhfMqrRZYZfGi94xc0xF6a+ieNHCatP6m3X8gYU+t1az7G74X6zaR64u+
	heRcrRPsqC/5RMXQOuL//KUzVvD2pKQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IvS+YyqlHz+K1r1LlmSG9IHF3Y0fYo9PEhMGEyAyhB4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790082375; v=1; x=1790687175;
 b=eO7VdZLht/223fCpP3GVwLYm9utxYogVg6WPwVrYI4u1fdBHZ+SnzlGgf78XPUrGpi1SiGpz
 j5Gg0etBSvGuoyVfDvXZhzzWX3B2odNyCwTIzY9zhRGlLsCxEwUrjcLo0VaAwdrp8KzfDTKP2/F
 /G5uWJPlcEWv2Wdk/ILPi75Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 31c7473652c7ce96;
	Tue, 22 Sep 2026 13:06:05 +0000
X-Mizu-Trace-ID: 31c7473652c7ce96
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: gourry@gourry.net
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Subject: Re: [PATCH] mm/page_alloc: let the bulk and folio allocators carry alloc_flags
Date: Tue, 22 Sep 2026 21:05:58 +0800
Message-ID: <20260922130558.48402-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260914155115.439742-1-gourry@gourry.net>
References: <20260914155115.439742-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yga5am465qxeza7znwbxbujepq3yjziu
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 84ED640009
X-HE-Tag: 1790082376-490481
X-HE-Meta: U2FsdGVkX19C+aQz8GH2EEc1PqN8+y5b3cHBjlslikFLuYpWTXkrNGQleU/K1bORzy1SwajdzqIqhH18Fm2tTeA07V3vRlRtQhXtPhEHlEi0ikDRKxT93B45YcWBUZGnopAZwX039bewaHdeFDguA+3/Bp6TAIcl3pL8mX6YoQoCe5LBGfW4fyg+EaMTTjw894vM4LO8dsjifT0r8Z2Tv3jtvYNVN+fXYrr4OgTAebYvyaaoQ4pHw38zNYA97JE6zJqwfe79iSRJTjH8DbbFR1Be3/Hl2b1ynWyc26uzhkxttSvXBr3K828Ue8tpmL+6DUhwB5Yrk2OIGKifAlsR4mXf89SMuUVeEbM8GllXKV/lSf3XDSB2lW8kyIbGEjtXphmdKcg+exz0Ts5ITK6WPBeHEInY496HqQ7CLvRps1ACQ4znmF3uU+bXwQOt5W8+EtPmgywoxTEQ9PULohjSq/fZRVOwt3k/vKYLpIAusNGQ7iVF9KACQOhLFayeT6K/gcxsl03MSCLQ3ueDoLrR5vWAUM1gue3ekBGr1MALi8WDY/Dks3V7Iexanq+2jCJ8gBLuYN0npMvoPMhPlrcgzEc+9a2ZAmTwZlnw4MTJ8QFC2pT5f+T74zJ/wDDorRbrpr2+3wtUp8SzyXA03qJuClKkT8Kxhy513yofS9WQYZEmppwhQFx5v6I5LlYnO+SRxsJfEW87NK8g8wBGL+n9iw6fv6iM/izM2AuaSisSlH2feezDESPJVmSLz4eT5w5epmlvqcD17xek+L/FVsoOE5MGykVgDogUV9j3atVSfnLtrAJy7aNPtqONImiAbLDSmzXp8h/r4C3saHpaqizvFsc81yBRZP0LtWpPtWM4C90eHrdJoOyn2VINKGc2nuGISv/A4jteWdCGFXow9L2iKSLPJhKQMokDAfLshC0GT/IykKY0ltF6MTInb0j0ryBImn3GQp9yCeaWV1HoTcg
 lYoHll6X
 3TZeuTXEHe5j2fRHHGxWd2Hc66My5seGd4LJgL8TCVe3GLHQWUfO/j5pKV4lcGvsLEbYnGLCaB+aw28Md6Pb/Hh8Avkn2nyLnnr6/HvaZQAAbST5yaCJsVi9dw7RHFDbCqvsxoqYyS81K229AqCVlHVwfiM1qqdmCKUnUMozvKKR2xa9QZtHDYzSlVy9h2PC/ymW5VsFAmb3BccP9DTUPILDftPwK5aCq+5YYDwYdxS8bP2tBxZZPUFQEpO3syi7mhj+N6ciN2Nf9csGkUD3hDs5mvI03iQTPpo68mfeVMOwoAig6HWvMiPqIt544XztrrL+qL/5EjCrBi58E/PhHxTt1QMb05KlmzuJ/8aIhyyozhCM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Sep 14, 2026 at 11:51:14AM -0400, Gregory Price wrote:
>__alloc_pages_noprof() takes an explicit alloc_flags, but the bulk and
>folio entry points do not, so callers cannot select allocator behaviour
>(e.g. an alternate zonelist) through them.
>
>Thread alloc_flags through both, matching __alloc_pages_noprof(), and
>keep the flag-carrying primitives mm-internal (page_alloc.h) so the
>public gfp.h wrappers stay flag-free:
>
> - add __alloc_pages_bulk_noprof(gfp, ..., alloc_flags) in page_alloc.h
>   alloc_pages_bulk_noprof() becomes a wrapper passing ALLOC_DEFAULT
>
> - give __folio_alloc_noprof() an alloc_flags parameter and moves
>   __folio_alloc_node_noprof() moves into page_alloc.h
>   __folio_alloc_noprof() is no longer exported
>
>No functional change: every caller passes ALLOC_DEFAULT.

Yeah, but what if a caller passes ALLOC_NOLOCK in the future?

__alloc_pages_noprof() checks alloc_nolock_allowed() first, but
__alloc_pages_bulk_noprof() can enter its fast path without that check.

That fast path can reach _deferred_grow_zone() or pcp_spin_trylock().
Shouldn't we do the same check first?

Or am I missing something?

Cheers, Lance

