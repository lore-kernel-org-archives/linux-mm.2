Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C7D2C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 13:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCAF26B009F; Sun,  5 Jul 2026 09:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7C166B00A0; Sun,  5 Jul 2026 09:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B91F56B00A1; Sun,  5 Jul 2026 09:38:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1476B009F
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 09:38:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 18D7B1A06FA
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 13:38:13 +0000 (UTC)
X-FDA: 84954826866.21.6C7C56A
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf23.hostedemail.com (Postfix) with ESMTP id BFC9A140002
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 13:38:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf23.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783258690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BSf+J657ZxNqL+2fT78ijASkEmvb7MCeJjVd4K3nGCg=;
	b=pk0FUqgDRcEiB35SgxKIDZKCv279i/6EV1HGLrdzsuA9E9z5vbpORqoPLPhN/Dar8edNkF
	rcAt+M+EWPIGYtOVdNzpY85fDEgOTmAo1lNyEJIaDFn9w2QJntEE1vIscanWeefxx8A0Vs
	IVF3lV1oXTkyhLpV2cDLoWBvddyR6kM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf23.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783258690;
	b=JNNwY1lNnYf0wk6fUMAjno05caBNl7y1of9c5L8AHiTKS3Ze3XY3XnSbOGjy9fOyqYAJHM
	rCnTfFquOTQho+9ZqZKZU9Pkm3OHMFiUNoCzeGEqyjbRcWR36DE8kwXoo39uGtktd5mMIS
	wD3sdyPrUsBOaIhNI7ud1dWalvDg2DE=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gtT884gC0z4x69l;
	Sun, 05 Jul 2026 21:38:00 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 665DbuJ0005596;
	Sun, 5 Jul 2026 21:37:56 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 5 Jul 2026 21:37:58 +0800 (CST)
X-Zmail-TransId: 2afa6a4a5e36e60-9bef1
X-Mailer: Zmail v1.0
Message-ID: <20260705213758375Xf8iZzfLz92U9SASpvqTJ@zte.com.cn>
In-Reply-To: <7f211fa8-e2d8-4878-a8db-fd275d4c6821@kernel.org>
References: 20260704160450302fnznThT3hBeBiwlhE-oGv@zte.com.cn,7f211fa8-e2d8-4878-a8db-fd275d4c6821@kernel.org
Date: Sun, 5 Jul 2026 21:37:58 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW0vc2x1YjogZml4IGxvc3QgbG9jYWwgb2JqZWN0cyB3aGVuIGJ1bGsgcmVtb3RlIGZyZWUgYmF0Y2ggZmlsbHM=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 665DbuJ0005596
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Sun, 05 Jul 2026 21:38:00 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4A5E38.000/4gtT884gC0z4x69l
X-Stat-Signature: myxzqb93b8qo13tw4guta97qngftojfa
X-Rspamd-Queue-Id: BFC9A140002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783258689-587066
X-HE-Meta: U2FsdGVkX1+5k3rQDULT/jb0TLzmQKqoriYOMzgh9lCPCKQeYOkMn3kvgxMOgdK/5wRJuttAMn+RAQA5kDCSa8WgH31212AP+YwnTXNS55weQooUFBB/tUT3mNOKjQft8ufiWBbk97/r8vyi6ejnF0arkYO9LuNhGPA962OZHDEr5a++/vn01WiW4RUeVGTHPMC0Kmkv/xB5TG9gdkCwPR8/51IvBcCEzqWVthF51rq81CjZLDQkNqIVoK4JWYo0ffkq5QoFFf4Ls8xLJD9BmauUiO4a+9/fofeSrpTpvPeUIj33+/6kkTGt7EFwajD8WWQNJUPlGhVsRonM56RHPehZWdhnlnJKGVyA5AOUz94arIcVuj5YePqA+O2jPo3JNcT28O+xETqXkd0so6pOtGhHllfmySuSas58Z/nVACKM5BftOk8tioz7nBO9/mvtWPSOiUJfGR4giHHqMJhuS0aUp+4luPxt1PGQlMzHZylIUcbQ4qiSlvjoFova+sczepio4YCj041FOC1wzNJqRB8UtHenRtW+i+uCsG/+5Epxnywm9x9ivbFHlEb2GLk+RUEJE3s4o7j84Fz4DijzdbLJa62sckEaFSeyc3sV7E8hZhIexMCSyDqo25SMuN/NHKm+szwTy1PirxVkE/ymqkeXMJkmNKfK/k30RTWZfaPfdxRQPMLukZNXSqGKFwHSTq/cLBO9e7KTCa+RsH06VbZ1XxuoosHF1ksnf2r8dkDwBoJo/RVIeWp85s1fNqxHmzneMiY2yaX+ngoLjmpgb4tThcCSwAGDie8g8eF2f4iMD+qGmCREN0+1lJusI9ypes0MVYO5tCtoBZ3a4RY5q7yIwvdbMLeE1tFgWmfwT6q/5TMM2zrdy0gJAB0KbgOMKJJIChnmhi0z24nHE4UqZFEvN80+7xpkqhq3CKNOJqEkGvqayRxwubyYrPBklPQUJqlYYx6RdyQL3MNQWKX
 6GCGAni0
 TJm35SCWDiFKprqP+BArYO2t0kKhrE7rzsS1jBsAsvP/nCcn771kM12xa97OttZOMDz7BzB7H8f4I2r+oXfjbU64sNc/Ni8HJX+pWNZtQVwbJj0oD6lpDPdp0RAMxa1mTu4tKDY3h7kWobEE2ishBreozFkAWr2OgtGA74UExc/Ni/LZfqs+YOJxWQXWZ+3NMFKXrVkNyOZAucKdMd6N+pUEUVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> Hi Shengming,

Hi Harry,

> On 7/4/26 5:04 PM, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> > 
> > In free_to_pcs_bulk(), when remote_objects[] fills to PCS_BATCH_MAX,
> > the code jumps to flush_remote to free the batch. If all remote entries
> > have already been compacted out of p[] via tail swaps while local objects
> > remain, the flush_remote path returns early since `i < size` no longer
> > holds. The leftover local objects are then neither cached in the sheaf 
> > nor returned to the slab freelist, causing a memory leak.
> 
> Ouch.
> 
> Interestingly, we fixed a similar memory leak in free_to_pcs_bulk()
> during the v6.18 cycle; commit cbcff934fa7d ("mm/slub: fix memory leak
> in free_to_pcs_bulk()").
> 
> Hmm, I feel is a signal that the control flow is quite complicated and
> worth revisiting if we could simplify the logic there. I'm not saying we
> should do that to fix the bug, just mentioning.
> 

Yes, this is also a memory leak. I agree that the control flow in
free_to_pcs_bulk() is fairly subtle, especially considering the previous
leak fix.

My intention with this patch is only to remove this problematic path with
a localized change.

> > For illustration:
> >  size = 64, local objects at p[0..31], remote objects at p[32..63]
> >  After scanning all remotes: i = 32, size = 32
> >  p[0..31] local objects are dropped.
> 
> I can see that could indeed happen.
> Interesting. How has it been undiscovered until today?
> 
> Well, for this to trigger, at least PCS_BATCH_MAX (hardcoded to 32)
> objects in the sheaf should be from remote nodes.
> 
> Looking at kmem_cache_free_bulk() users:
> - maple_node has sheaf_capacity = 32
> - skbuff_head_cache has sheaf_capacity = 28
> - panthor and msm drivers have sheaf_capacity = 4
> 
> The capacity is (at least for now) purely based on the object size
> (with user-requested capacity as a minimum)
> 
> Only maple_node cache (out of four users) has
> sheaf_capacity >= PCS_BATCH_MAX.
> 
> However, for this to trigger in maple_node cache, ALL objects in the
> sheaf should have been from remote nodes. And that means there is no
> local object to leak :)
> 
> So, although the logic has a leak, you cannot trigger this in reality yet.
> 

Thanks for the detailed analysis!

Yes, this was found by code review rather than from a runtime report, and
I can not verified it with an actual triggering workload.

I agree that it does not seem triggerable with the current users. This fix
is mainly intended to make the code robust against possible future users or
changes to PCS_BATCH_MAX  :)

> > Replace the goto-based flush with an in-place free of full remote batches
> > during the scan, then resume processing the compacted array. All local
> > objects now go through the normal fast path, and the tail path only
> > handles any leftover partial remote batch. The redundant next_remote_batch
> > jump label is removed as well.
> > 
> > Fixes: <989b09b73978>("slab: skip percpu sheaves for remote object freeing")
> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>

--
With Best Regards,
Shengming

