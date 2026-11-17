Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24651606A8A2
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.a=rsa-sha256 header.s=mail header.b=IuWBwW7q
Received: by kanga.kvack.org (Postfix)
	id 46E546B05B2; Tue, 17 Nov 2026 08:57:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446C56B05B3; Tue, 17 Nov 2026 08:57:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E6A86B05B6; Tue, 17 Nov 2026 08:57:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0488D6B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:57:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 970FF1A046A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:57:34 +0000 (UTC)
X-FDA: 85444763628.21.901125A
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8B598100003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:57:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ideasonboard.com header.s=mail header.b=IuWBwW7q;
	dmarc=pass (policy=none) header.from=ideasonboard.com;
	spf=pass (imf14.hostedemail.com: domain of alen.karnil@ideasonboard.com designates 213.167.242.64 as permitted sender) smtp.mailfrom=alen.karnil@ideasonboard.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794923853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZO31/vr2Anb44jHz73z1goyYJ+XECbiZPGQcJjHi+w=;
	b=ZjwYEdMEJV4gUB5jyVZeKqqpmUvy84drp+PYlzpvaJIy39S3i0E7oA/R/b6VUmPKhQndfL
	n3HNwzd37VIy5KRnqSQuD9/HB7hZZC8xzSZIMhF/x549yn9TNOPddj3UPmW10b4xTNLTGS
	3/K+MML+dI4cKV/hOckNZy24haFG6qU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ideasonboard.com header.s=mail header.b=IuWBwW7q;
	dmarc=pass (policy=none) header.from=ideasonboard.com;
	spf=pass (imf14.hostedemail.com: domain of alen.karnil@ideasonboard.com designates 213.167.242.64 as permitted sender) smtp.mailfrom=alen.karnil@ideasonboard.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794923853;
	b=fctH83j78xUrYqNbwHskroGKxwAXuOPBYjnuC3c4cHiMHBuSYW3cAk2rt07YqAucu0dQz2
	SAe3n73rLZrhzyucWzjWRwSucTsKzzyTH6+5iiDIOLpS7NXlSbwtzR5voEVTQ0SVNLlCu6
	bF0/kfnvKuCyW7AQEHTgvHiBQxXQn8Q=
Received: from [127.0.1.1] (cpc89244-aztw30-2-0-cust6594.18-1.cable.virginm.net [86.31.185.195])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 943552022;
	Tue, 17 Nov 2026 14:55:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
	s=mail; t=1794923701;
	bh=WswJsxOBSsQrRCuzWGEZVgUOgcENdjhgoOrLkxfZu7g=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=IuWBwW7q9h0R86JgDPK3HAdIyVwqXjg/oKFsAkynRxGipq8FGkyDlaL1TAqtTZwBK
	 icBRF+jK4TTQmjav2G4ZjJWfMwz9MpUJSbgQsPq2t4qZCZMoAwSh7/HlFDs0ipPJD7
	 CQVQLfRJtmq3sVaxWVzduyy4lmztFbar2vVYy5v0=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 01/26] mm/fbatch: remove !CONFIG_SMP special case of
 folio_activate()
From: Alen Karnil <alen.karnil@ideasonboard.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Ackerley Tng <ackerleytng@google.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Binbin Wu <binbin.wu@linux.intel.com>, 
 Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Christoph Lameter <cl@gentwo.org>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
 Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
 Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 Marcelo Tosatti <mtosatti@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
 Mel Gorman <mgorman@techsingularity.net>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Rik van Riel <riel@surriel.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
 Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <b482561f-6620-d41d-eea0-a7f2a05cc444@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
 <b482561f-6620-d41d-eea0-a7f2a05cc444@google.com>
Date: Tue, 17 Nov 2026 13:57:16 +0000
Message-Id: <179492383659.1554713.15351223817355202820.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=634;
 i=alen.karnil@ideasonboard.com; h=from:subject:message-id;
 bh=WswJsxOBSsQrRCuzWGEZVgUOgcENdjhgoOrLkxfZu7g=;
 b=owGbwMvMwCUWeK6p+sMV/3mMp9WSGLL+xLpKT1rRd/LkvLUFx7cL7duefH5e5znmZoZ/rsbXd
 51KF3/k31HKwiDGxSArpsjy5ZDM9KU2K8IuaIZwwsxhZQIZwsDFKQATUZ/LyNAgsrBHxWvG4TvH
 kmXZj29gtHjFfeC5V2sN0/X0VK0gpjsM/wOuF9jorHkwO9PKXmK9lK75yof+Rpz/5/0/ZT25T2K
 vAgMA
X-Developer-Key: i=alen.karnil@ideasonboard.com; a=openpgp;
 fpr=F4C21C97A53CA856D029540951CE827BF0D44F9E
X-Rspamd-Queue-Id: 8B598100003
X-Stat-Signature: aiht3wtpjosw4srhtdscm5tcwthgxbtq
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794923852-343385
X-HE-Meta: U2FsdGVkX1+Q5o3Jv+i7KuASjHzru9nzDjUyCz1dUh0v5EPB+h+2mlqUurqynOOMCbNgKOzN7WgzioDIFN8lFxbEyKddd/Nenh4JKNOB1rqRCNMNC4IHlF3r4hGKyuP+tkCracVNwITXatiXnLpp8gtCI4K3iHLcOLLkCuqweKsVb1D5HOKsclsnvl2AaoIu1SdAK/EPn6r0ghV1D/5+Mk2s5or5mhZFdtlj2j8MbfasL7NDhZTE2fPHsBpwUf/xurHqHi4qBj9fYpL6z2wqvg3DN9aXEWkXhJ2vrJS332w4CS6ExxH3cCoopyAPp/z77zVGkwo6cXHdjCFoHjn+Lf9iTyoIa8RMpy9YpJ0N19anxoO6FGH2WT76CAUzlRtK2bcguehnbZqaDhgcyGnr0YHq97NYgnJfGLLxHcQSYRL22P1MaBeFLBlu6tJyO2N9C19BzGfeO3iP6TK7m7dfog6gDOGxJ4z/DivsIE4/LVmDzpO/V3k2Ghv2BbGTQX1lLZxhJKoGYSSm3qnt63hobhrv5QpbDbukyUhXGqZpTutC6IVQ2DjoFdIwn/4AQ43uD2+ukh5NReKnQD5S9X0XLa3eHSJMLHx0erVqKceag8NoPvCzLVJAXBhkMu4QM4lMzbWY5bcbDWIVIL66mFv3B3H6JfdupObz7mnWC5PYsDUqAVD3vwQGFQKO/q7jJfAgEOKfwcPg6I9GxQg0F3y945DOIPptrUyN+pKAU5WPpnw672XVIQDIjHTPsa4wU9rrHDHM/BgR+2lhfkSG67QVqB2/7l2RtXf4tFmeOQqVqK26eaKE+KAbczBTGpj2SxF7eov6hLZeE8hqKldW+24itKpQeUFW4vsr54Yvh7niiCUCUgjqHoLxhhAp59YN761GXPpU+FBPlKbql3WEh7GqI+9acLQRlHxnhF2EmGJ+FWgrHaxWPjvdl16Eg0w0T4JjlNnk8IigAalNlxdRkYM
 fCFo4Eid
 gamIpSEaYOOv5ns4gWns08jwfcHwkUnF039o4InZcqa4joGjoJxwME9seAMImbS9TTDDUJHmvnnxzqDqnqLLUZJHA8ysUVgIokBi4I1Hei+T0VPO5dfV3JaDHhlwppZEyvcecz5Tfcjgz/qRsAu/7g04emsmAv/Pn7tgL4Lj38RLv5HaQal5TBIFGqVEn5qeoszhQFZWurR9oNFHdNt6AAwgL+C77PhvhKPxaBLouthcn4jJMIZK/WmsNerF4/D3t8QNyGbtEhmiV4psad4uss3Ct2tLA7e2GCYrhBkuP0rfijSx76lukPbEjcQA0evl5c8W63hAIoJ49kbXynidtM7JHgyo+p1kXvq5ifmAr/UfLul/X6FjoBDf5whz0wOwSqLS0ASxVsm78NHmCHTZd+zWX1c3Yv+9qJFxYSVlsETSMUz9Vv+9Vm0QA0o3wHUncRGBo3WU4aYCwaiv8v5zWQbYOECRtkwaS3x6yDKdPEIx3hgNZ3cfFrbFvBZOOmlbpCeCZIgh0fUkzutnOu+V2A7/T45LUmjMAxj2IHOzKmBWMWIfoVeqqlpa9rCboYegT0jn9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 09 Sep 2026 02:42:10 -0700, Hugh Dickins <hughd@google.com> wrote:
> 3.0 commit eb709b0d062e ("mm: batch activate_page() to reduce lock
> contention") brought in an ifdef CONFIG_SMP around activate batching:
> https://lore.kernel.org/linux-mm/20100805140755.501af8a7.akpm@linux-foundation.org/
> shows a sensitivity to bloat that day, not any incompatibility with UP.
> 
> No other batching here has a UP alternative, and it's a bit confusing:
> simplify mm/folio.c a little by removing it now.
> 
> [...]

Reviewed-by: Alen Karnil <alen.karnil@ideasonboard.com>

-- 
Alen Karnil <alen.karnil@ideasonboard.com>

