Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39000C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 15:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33DD66B00A1; Tue,  7 Jul 2026 11:38:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C68A6B00A2; Tue,  7 Jul 2026 11:38:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1914B6B00A3; Tue,  7 Jul 2026 11:38:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCEE76B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:38:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A9EE403C7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:38:56 +0000 (UTC)
X-FDA: 84962388672.23.5496B16
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id E457220010
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:38:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf03.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783438734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=++Cjevhqskve0JMvE9muxDAncKraaU5muuQKRDN3N74=;
	b=7pk4MdH0cXY3+8g/GvxWGjxAMuPJyXjgN9SMOabdqlmNiAhZSZdb4g21epXibbJak2YEfH
	RA8n6h8tl8nlVMII416/K8S+re1ZyqKjvJgy/U8hxLGL5+2LZsJQ5hg98iJ3EMN6lt/u/B
	wJ+gh4X+QE30ita5gLeY1blfdJcIsGs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf03.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783438734;
	b=r8ShSFiqSemOzmqZyVXswQiGlIza+gyYnabS/lACvhMxKeARYGfUb+D3zobsuWA80y/nKh
	aYwOj5+CNi0gYmg92Ws99G2cIIKugHCY+/90ww3/luUPesXLW3LpZdIdkBEB0Xpdb+6UHy
	35L+qyn8uavgLu2XOut9koQzVT3AV58=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gvlkg3ym2z5BNRf;
	Tue, 07 Jul 2026 23:38:51 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 667FcgRf096224;
	Tue, 7 Jul 2026 23:38:42 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 7 Jul 2026 23:38:45 +0800 (CST)
X-Zmail-TransId: 2af96a4d1d85338-1a558
X-Mailer: Zmail v1.0
Message-ID: <20260707233845825QFxhT8ZP5Ej4atrE04d1K@zte.com.cn>
In-Reply-To: <84c4c2bf-397e-461c-b898-482d1a49f40b@kernel.org>
References: 202607062139095043SOsLi6TIf403tcjPf8fm@zte.com.cn,84c4c2bf-397e-461c-b898-482d1a49f40b@kernel.org
Date: Tue, 7 Jul 2026 23:38:45 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>
Cc: <harry@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2Ml0gbW0vc2x1YjogZml4IGxvc3QgbG9jYWwgb2JqZWN0cyB3aGVuIGJ1bGsgcmVtb3RlIGZyZWUgYmF0Y2ggZmlsbHM=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 667FcgRf096224
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 07 Jul 2026 23:38:51 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4D1D8B.000/4gvlkg3ym2z5BNRf
X-Stat-Signature: zo4wc6himzwt7rs7wqfu9hhs7qkaxd8n
X-Rspamd-Queue-Id: E457220010
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783438733-171041
X-HE-Meta: U2FsdGVkX19wt8CvemSCqWzFMNW7FuSNd/3+NLydzR/nyUU2sDZYK71LQBQ7FjX67zfX0UfVyGACXgfuiyb06vw4mD/0Lnwt7Pft2lawy8y+hyTm+i/mi7On1IBjcQOrVRQfVjr3yKHGQq9+QPs4lqnpOnJ8IT0ki/uNIShT6amXPN9IMW5dNKz3ceL5J/G8IysLSib2DpqrXkAWjQxYdq99KbWMgmPa7DAtUdwtafeNcoN96IqvInOm2OxrNhU49TQrv+0kS019fL4kvM00bO61eIA5Bnzj10uQaNghExYIuz2YHJofzDd7rPnB7zCSFrfilt8Tiia/dIQmj5B6VTa8JexWnwQtoQyWO7SumpSUUZOSIxHBf3wVbfbQ72TFVGRBi0TBXDAiHjFpGMu9vyiQmgvFpqVibsmPrXMghbOCPFOsRCwEYD9ioPpcQ+5DbQli6ZS1gJf6ZXU0mpX9gYNtudRFOi2v6oOFajtWqbaKdHytAiBcuG/NYJG1oGFDmuDcF45FLpVFt/ABHPPjYKBPek5RC0x6pw098wzOs8jAHDgNFG5Ifc/1ghxZSe0W8336JG7R7bVcn8kwY15Q8fJJxHMhOGs1acCeBFOWoGpUT+G9KsbBcTSZfSRDvqGyhn65xYoR3SH4U1ghB0AyjuxUOR1FLlpixpNeHe0ourwC5Y4ncO2S9eJ/gXkAerjFi89QlFZvfdtWigXL857jnyjssDzXDbTp8Wn97cOQj5MOtxKNash9QqeOrfnHLYiF0I9OSyfU2wgZpkwScZK6xKg872J1rsrJHj2xzERYADMG/Mtp65I//6gbVu8fxDZiV/PZFqrxCXdq1eMazjPOe73k4Ve5X79baqK8ERQhK26kUfSFdBD5yaLy8UzhRMSHX3AM3iqEvEqMun+Wo+V5111nwYtzGvbilq58pcB5/ihbqNVkTkRb3Yg6xYJU2kmjIf1FCblU7ZjdnKMbdMk
 212KT9Vp
 baACr0ahy/uPZDiuU61u4BYOknxxRzGnI4n0ClIyoP7ZuTKF3mBKm3K6lTXtsJy8Cunj8O6zSKTxembejGSdikglBRJjFV+gF4/wD+eXbCqNBuofWOhRF1w77VB50QcTwWL/wxWsHlK7OkB34tgPi6txiCXsE5R7ybhd3KCfOGArBr6qZP3FjeSn/mpvYdGmAxm5oUkdKTDr0SQrL/0zEyHgo8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vlastimil wrote:
> On 7/6/26 15:39, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> > 
> > In free_to_pcs_bulk(), when remote_objects[] fills to PCS_BATCH_MAX,
> > the code jumps to flush_remote to free the batch. If all remote entries
> > have already been compacted out of p[] via tail swaps while local objects
> > remain, the flush_remote path returns early since `i < size` no longer
> > holds. The leftover local objects are then neither cached in the sheaf 
> > nor returned to the slab freelist, causing a memory leak.
> > 
> > For illustration:
> >  size = 64, local objects at p[0..31], remote objects at p[32..63]
> >  After scanning all remotes: i = 32, size = 32
> >  p[0..31] local objects are dropped.
> > 
> > Harry pointed out that, although the logic contains a real leak, it does
> > not appear to be triggerable with the current in-tree users. To hit this
> > path, at least PCS_BATCH_MAX objects, currently hardcoded to 32, need to
> > be collected in remote_objects[]. Looking at current kmem_cache_free_bulk()
> > users:
> > 
> > * maple_node has sheaf_capacity = 32
> > * skbuff_head_cache has sheaf_capacity = 28
> > * panthor and msm drivers have sheaf_capacity = 4
> > 
> > The sheaf capacity is, at least for now, derived purely from the object
> > size, with the user-requested capacity used as a minimum. Therefore, among
> > the current users, only maple_node has a sheaf_capacity large enough to
> > reach PCS_BATCH_MAX.
> > 
> > However, for the bug to trigger in maple_node, all objects in the sheaf
> > would have to be from remote nodes. In that case, there would be no local
> > objects left to leak. So this issue was found by code review rather than
> > from a runtime report, and it does not seem to be triggerable by current
> > users.
> > 
> > Still, the bug could become reachable with future users, a different sheaf
> > capacity, or a change to PCS_BATCH_MAX. Fix the logic by freeing a full
> > remote batch in place during the scan and then continuing to process the
> > compacted array. This keeps all local objects on the normal fast path,
> > while the tail path only handles any leftover partial remote batch. The
> > redundant next_remote_batch jump label is removed as well.
> > 
> > Fixes: <989b09b73978>("slab: skip percpu sheaves for remote object freeing")
> 
> Removed the < >
> 

Oh, thanks :)

> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> 
> Thanks! I added cc: stable anyway so we avoid unexpected surprises in case
> something else is backported there that exposes the bug. And the fix is
> small enough.
> 
> Merged to slab/for-next-fixes

Sounds good to me. Thanks for taking it!

--
With Best Regards,
Shengming

