Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71338EB363F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 22:37:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC5B06B008A; Mon,  2 Mar 2026 17:37:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8CC96B008C; Mon,  2 Mar 2026 17:37:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98FEC6B0096; Mon,  2 Mar 2026 17:37:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 890E56B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:37:48 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46FD1B815E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:37:48 +0000 (UTC)
X-FDA: 84502586616.29.6E8784B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 98214140008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:37:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yBQXxcwP;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772491066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9IzD+2OT3R6Eib3fmsCc0CbE7k/g2Q82Loc5zlxuYZE=;
	b=cdCWmpx9ldFbzVJvUlXMDlaQW6KPsPb4xxIEY40PCjHIMWKd3scK5zRxlhXbQdgFF/OAlT
	/RkL7me6AR1NkKLIgtzhLPS1DlNGTb9kBvGPEbs0fu5wVKpXip+smIovVhfkau3ert9tFv
	0DXbCcICuqwrRp8x9bGLEPBdzTfstT4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772491066; a=rsa-sha256;
	cv=none;
	b=ojmVmDQdZKDmkvq2vPXyyj4SsCLLwwYvjclDUHEb71BlhFmluMqnhhKNerUy4eWh87xx4r
	CD+s7XoVonXHDWMxOWOnTygFE39nVLKoL3ELyjXWmCy3plNktpx7eS7XLjkSqicLB8/MDW
	huPXGdQbG55W/qOZ/OmKM+Ea9tAZYRw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yBQXxcwP;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C545860127;
	Mon,  2 Mar 2026 22:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B69DC19423;
	Mon,  2 Mar 2026 22:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772491065;
	bh=J2fvo+KSGZvC6JZi3Fa6EZ+t0vgBEn0ictN2fEgWIcU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yBQXxcwP9mbl6ewa3zuQ7K4FL6E89jF1hXOOl0UxVT7zm9U4qr5CRzNo3mZRzswbj
	 yFvT9BHNGoT3b7cGE0DsOEcNs/3YzNes9NLszNK31ww6yKE3FQ3EwkyaLa+mMdvC0z
	 Cl0G0MPesho2q6c7fgIFwUb9qBCx5RknJTdxab9g=
Date: Mon, 2 Mar 2026 14:37:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, "Rafael J. Wysocki"
 <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>, Len Brown
 <lenb@kernel.org>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Oscar Salvador
 <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
 "linux-cxl@vger.kernel.orgkernel-team"@meta.com, SeongJae Park
 <sj@kernel.org>
Subject: Re: [PATCH v4 4/5] mm: rename zone->lock to zone->_lock
Message-Id: <20260302143743.220eed4feb36d7572fe726cc@linux-foundation.org>
In-Reply-To: <0f340324-502b-4719-b3e7-c7ccd4378385@kernel.org>
References: <cover.1772206930.git.d@ilvokhin.com>
	<d61500c5784c64e971f4d328c57639303c475f81.1772206930.git.d@ilvokhin.com>
	<0f340324-502b-4719-b3e7-c7ccd4378385@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 98214140008
X-Stat-Signature: 5aex9j9xembmcam3ri1zefk88sifdy7z
X-Rspam-User: 
X-HE-Tag: 1772491066-335315
X-HE-Meta: U2FsdGVkX198PY/6+4Jn+Ea8FmNw/akIE1urSTEbmQZZgGofdXqgSHmjcK8tyf7Tl0v+BhM/iznBTMr/X+tTLeGTQ3KnB6ISQkfijJ/G+8l9YltrsgMMPmeEoS9mANFmhRgfxLu4IjBE3zlA8iQdCZkZZkIc9N322GxxR8jAF4krOI9YlLBSTRLsMAtaCwy20UWCkIr9c+P4z45khOvKiyjhQofDYU+6gNUrg0/zNIWKWa8fDGTyEGvMAL1Iv8KDx+mLw/oedEX5yyT6azJV5EWG83ruBJQ+P5lRBE+6UKQTbmzdqV08nLnmR63WVCWv79lZYaeHlMd3wMMTHxqFaH8uLPkub1Am7lrhWjjs9Ws7UmNPsBnvkMg/ad5FahkqxXwV665reStaychz94CLxTLrwowKDBmLyFu0FQH5+dQ/pVTZiH5zdu+4XEcTI15X1bLQ/1LZq/GQcvszc2Fgy23aUxTHw0Zipby245gv+yQIhVI2rami/pcLKDS9yep1E7fl+nUI6HXjpLFLHoF2KRW5J1xJY4s/RisgATxinq/P84CnAerYJibn1zcfTUT/2DAbauQxhGiKEOPTEGWnWf8syJjpVvB4m9EOpmwuswh27GbZjB1SfggyDg3D/hWzhm0jUbuuILVD837kNXmhNCAm6ax1ZC/GpnlPHeWUCb5keesDfTHcJPlctWcTfk65wn8vtshNmYjRRjokhJ6xdqCxULSRGscl6+SIlom4MI+2A2b9zuRxUbtwJGt1MUs+mifr0V32eQApeaGdtHJohobJAMPHK39QCQvoPGNaV7FA1ishW0dwjgcEql/h7idseiSwq+d4zqOccQtCugii022fua/2RsWzDV8SAx4BFovEk+d8p0S4i19aHsW8WSyFqY8EvxY7nwYO/WtXTFuBiPYYl6y06syj1Sz8PsxdPU+bzm4Wfr93MfnXEV6iSCOPmwhcEQljE1i8tbu7Dg6
 2t6F2a+V
 77GIK1FTKtlUGwEKzPBrZSOMUj62OkIIJ8Bpo7gljdmkqCxqXv9sph3umAltb09y0N+3xSoAI5OYAiMYx744cAMMTfirBYCJBDklG8Iq+KmGJdeBxuDrozxWGGVVBTwKXXtCNUGA6QSDfFEJ29I6Zpw21i+p8VfyW0fsNp76iln2HHc0zGY9G6NClimCkdAEF1FK8YazLlU3TVuzudaoxd7Ea+KES1aLvuroDrbF70Ti1L0t1nFMdDfU8jUqhlo2ZINAs+wWebmOkaFfgDwKMdO1V7WVZr7QO2vi2p5F4qtK0Ie4glFy71lc3zBI9qAqBgUmH40T6ucljMlRg+GzfX39QnroTYcdFFKPgJtoK2Q/KqKrSn2+8TTqL63AxqeUTZJDHO9DqsAB7RA25vG6U90lyyy8qOKiBcuMccZd/uRdBx2FVXcr4tAv5SCZwwUQ8LmBWsgpRpe1z7ET6DE5nSA0FxPCWf5G/sTow
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2 Mar 2026 15:10:03 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> On 2/27/26 17:00, Dmitry Ilvokhin wrote:
> > This intentionally breaks direct users of zone->lock at compile time so
> > all call sites are converted to the zone lock wrappers. Without the
> > rename, present and future out-of-tree code could continue using
> > spin_lock(&zone->lock) and bypass the wrappers and tracing
> > infrastructure.
> > 
> > No functional change intended.
> > 
> > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Acked-by: SeongJae Park <sj@kernel.org>
> 
> I see some more instances of 'zone->lock' in comments in
> include/linux/mmzone.h and under Documentation/ but otherwise LGTM.
> 

I fixed (most of) that in the previous version but my fix was lost.


 include/linux/mmzone.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/mmzone.h~mm-rename-zone-lock-to-zone-_lock-fix
+++ a/include/linux/mmzone.h
@@ -1037,12 +1037,12 @@ struct zone {
 	 * Locking rules:
 	 *
 	 * zone_start_pfn and spanned_pages are protected by span_seqlock.
-	 * It is a seqlock because it has to be read outside of zone->lock,
+	 * It is a seqlock because it has to be read outside of zone_lock,
 	 * and it is done in the main allocator path.  But, it is written
 	 * quite infrequently.
 	 *
-	 * The span_seq lock is declared along with zone->lock because it is
-	 * frequently read in proximity to zone->lock.  It's good to
+	 * The span_seq lock is declared along with zone_lock because it is
+	 * frequently read in proximity to zone_lock.  It's good to
 	 * give them a chance of being in the same cacheline.
 	 *
 	 * Write access to present_pages at runtime should be protected by
@@ -1065,7 +1065,7 @@ struct zone {
 	/*
 	 * Number of isolated pageblock. It is used to solve incorrect
 	 * freepage counting problem due to racy retrieving migratetype
-	 * of pageblock. Protected by zone->lock.
+	 * of pageblock. Protected by zone_lock.
 	 */
 	unsigned long		nr_isolate_pageblock;
 #endif
@@ -1502,7 +1502,7 @@ typedef struct pglist_data {
 	 * manipulate node_size_lock without checking for CONFIG_MEMORY_HOTPLUG
 	 * or CONFIG_DEFERRED_STRUCT_PAGE_INIT.
 	 *
-	 * Nests above zone->lock and zone->span_seqlock
+	 * Nests above zone_lock and zone->span_seqlock
 	 */
 	spinlock_t node_size_lock;
 #endif
_


