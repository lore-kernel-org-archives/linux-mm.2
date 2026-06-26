Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1114CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 04:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFA5C6B00DD; Fri, 26 Jun 2026 00:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1426B00DE; Fri, 26 Jun 2026 00:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0ED16B00DF; Fri, 26 Jun 2026 00:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC086B00DD
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:22:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E96E8CC61
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:22:59 +0000 (UTC)
X-FDA: 84920768478.28.CE50A3D
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf02.hostedemail.com (Postfix) with ESMTP id 38C7080007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:22:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782447777;
	b=bzfFUotREgIVfhHatgVTtub+KAIX4kt1T2/J4VvrDpRb7eU4nJmwsxcUsEsuIXDI6ABdqG
	6opaBTc0M3Y8q7Zzwr81Vsi7B/vBEr281m/45luxai8cbXkC+RwFP6+AnKGHXmr1/Mw9AP
	6z6mQCB2vJqoW/HVXf1QvacymIjZzWI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782447777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dlYDuPOUIP5Fm/6XAmo0jwWCwPvSjNhrx8uDJ0U/ccs=;
	b=rTdPkiWYpMuerHdj+gIfmtQ90X0YjZB2UDkzSA/Nxoo+XrQK5kREmILQGuBQ2CiKvhNBl4
	cQ7iq8tj7h/VEP/O9YhhbF/SBLJpgk+5nHV3AiuPiarpakheEBW01WUQYihVoYnc8n1tg6
	oW7IaMAkaxKEr9KrvmFB61emvveMKcY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 66F5568B05; Fri, 26 Jun 2026 06:22:52 +0200 (CEST)
Date: Fri, 26 Jun 2026 06:22:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-mm@kvack.org, Vitaly Vul <vitaly.vul@partner.samsung.com>
Subject: Re: [PATCH] mempool: optimize mempool resizing
Message-ID: <20260626042252.GA7997@lst.de>
References: <20260625194915.387663-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625194915.387663-1-vitaly.wool@konsulko.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 38C7080007
X-Stat-Signature: 76wokp6ruu1c749m3nmtpq9q1d3nxrii
X-HE-Tag: 1782447777-992863
X-HE-Meta: U2FsdGVkX180lltIEB4pUv16+6rzqY5Ewcpi16bNpPs/eaCc7ZzjEwoUoDIwHPT8AyvdFdD9XOZRJIugHi3VtRnwocJenCzHml2NX1NnJTvxX6jrPXWDS4vJ+9lgDVpDBFLhu1ZospvxHRR8eO5x00RQn7fE+UMFxpkbrQFBUJIaomxoB0SHe9rY6t1bSdvvXF8e+EBrS6QQTrV25stYEVE+ooWmQZHX8sq56xUHukw5a8GK1LKR2koYvO11Y71gAHWnttIOuMNAAdbgX1yqDR5p+5qOCtXY9pRLf1LajoxS+26hbBu50DBah+uFtxP4K/k6KGnq8UkEeR/fBNT3A11vWBWhKJIhNMUcQuAr9SSKgcSDrGQzBKPYprX1eZlAsKpJFAyJr+VcCG39xxlla8vSGoPuYm+8LBbg9Z14A7hakJUAivmdE4PmiKo9gjKV52TMpZ/y4QuobECwcXfH1XoE1FNQMPAyEAl5/msurQAQKQXskDLTSkYoyRv3WN6M8OupMWrjmHU7B6auPb8TtRmNukf/kh8ez0gwYqSCtqlF+CIXZTVHoOjuuI9yLhOeR/E7IDcmIi81GgwWa9PDJwbQ8I1kG5BKUpOwwbrbmCSE6kDlUf2p69gjBLt59k/pvVJPGrHGwxfVO8yUmOTKjPaZzsZVhiGQMQUDDT6uhRJfUuGd3TFX748YsrzseVvTe1Dh1NDiEBDFh1Z4YZNNgN6dWaYHokO7Sww6DhY7e8NZpwx90iYpRdF6yVrmjQ8So6NkQ4omSxC5K4Z49D89oOHmGtumfWa7YXZJX/STsjjE0hv5f9rCGH0vgnh45Hcdv0bQYYmo2n4qzTd3wysblNDwdb6u8FHfhFebSEGGma8zOAZIToOBfL21SJgwN8uvgdj8SBuHDT5N2Rm85aMMYY8cS7DOOVy0WM9wsLZUOzyta3iVDlFtVjx6K8bJaaDkuY0pg6CkuNRU/owEDPr
 vHvj4pM6
 HOnw38j8VYoq2tUkDtn1wAhn2kMZ4J1oC0Ilc17uqiIr57FSEGymFP2qaomi4ghhLwGZRZqEchR8SlPjSj0hMQkp9+JfY8/niR6Ikcxusg35VsyC4VMmoFrC6gQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 09:49:15PM +0200, Vitaly Wool wrote:
> From: Vitaly Vul <vitaly.vul@partner.samsung.com>
> 
> Resizing mempool to a bigger size currently requires a new allocation and a
> data copy to a new larger elements array which doesn't go well with the
> idea of having a fast and deadlock free memory allocations during exreme VM
> load.

mempool_resize already is a very rare operations, and none of the
existing callers knowns the upper bound.  

So what is the use case of doing this under predictable I/O load
where we can't stay at the old pool size?

And if you care about it, why don't you size the mempool to the max
from the start?

