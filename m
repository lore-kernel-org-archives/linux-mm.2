Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 857DAEC1126
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 20:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7C076B0005; Mon, 23 Feb 2026 15:24:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFF806B0089; Mon, 23 Feb 2026 15:24:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2C356B008A; Mon, 23 Feb 2026 15:24:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F7BF6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:24:00 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 395DA13A124
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:24:00 +0000 (UTC)
X-FDA: 84476847840.25.FB59872
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5DA7A180008
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:23:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LZORV9g8;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771878238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RNvomJRDzKYDBuDBzLOEEqO4is1h/8XYWfpUrymqly4=;
	b=RGJ6ZvoNBP6ZuQleK34Gx2hQrwodC9tH8n3pHAdOMPFBDDwJkYDubYWz6iec4vQ7dfLGNM
	z49MfS2Y5aifNT1W+hHpyPCnTwtG1KkT6TbqHi1DdFwMduAzStz06G/uMI+MgwuFxkeeYc
	+hZd0NEc7AAWexaJ4sZxpj3kSTjdDo4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771878238; a=rsa-sha256;
	cv=none;
	b=i7c10W/3zGHSnyjO5HyQ6P9E9NFmjh8EdlBZ95j3x/4cdi7KFRlV9KTbEBmo0k6baL5pn9
	V9HWpxtq8Vu7Paj9k9muKb+61rYYIzLiBLMStrFXk/Bol1BAGFfykeUMjls39bBOfGB827
	n+Le5+Nfu2Sv0L5EQdPw694mRmV0Kg8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LZORV9g8;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 23 Feb 2026 12:23:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771878236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RNvomJRDzKYDBuDBzLOEEqO4is1h/8XYWfpUrymqly4=;
	b=LZORV9g8xqhHSpLuPZ7ZD6V3kX11yA8PbWI0FhROUlo2tk75m0eEDrveWRmwIYtoPY2mlw
	zUupYzowXMd/nMquPwB+McK+Gy307vVza93iB+iCDurVWLwk25tLdIY1pBV8jMWBlXNfHg
	Gs9D09m5aTx7GynWG9R5x6EYqzCPnFU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: [PATCH] mm/slab: initialize slab->stride early to avoid memory
 ordering issues
Message-ID: <aZy3O2qcULFDoDU1@linux.dev>
References: <20260223075809.19265-1-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223075809.19265-1-harry.yoo@oracle.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: wctnfcobputdesnhqz5zbf488jpmfrhz
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5DA7A180008
X-HE-Tag: 1771878238-480338
X-HE-Meta: U2FsdGVkX1/rCEWDZ4oGOxItIRNkLo5QF/QOF5QL/daYeDlToRhU53/zD3jiPxzuaoT0qV+9oEiy1FvKsS2gSyCfGZN5TIke0y/1WxohBajm2qYkC0neJzBrvVB6xm5IqfVTIDS9IuC/09geOkq2G3451uONHl1yHFwwOKmiMCTaMChJe8yYcYQfz4IA2rN8eumOyG3XTuU5leNNvpOW6HYaNfNltaspjYy3AVCk6HrS0CNRzLPCcLhRRF79Wkesd7Qu5VHBpkwyxRLvlTx3zQHz9d+lrIi4JHLB0qJVbkYGhRYxmz6pqRLqe99elbRipEdXuq0fLAM8LaO8AZFKNy0jvlXDipGJYlQ7qeL8p0qGwjvEvWw0k+X4RIpCmoFHfDDnCSHdWSIwZ3b5IrifO0w77L3mPlEr67xpaTm6K/2dqW7+KlPolCqc8ST1RfXqvUtC82oSZiKstBdVxDgoGy2pq7GNVV4sw4IGpFyS+o7rXJPWCqbGgdOG6U+Q+24iRYAmuYoRlbTVw3DrmlXAy5z3ak3NjUH6JqIgOBVpvsp2fmAjT2yngtL//n0HJdiQHllfBtVQuVNMBdYFRdlUxW4KnTDOIxqv0iHAb6M2Kblm0MdmPpww1E+/Arz10I2gHmfNxyEEPVf8wsFSHBouBGOPALcQNYvp5JstaJceIhNrfRHS/xdtB6wpZdg/ZvXjf+v+pNE+5E/oRlJuppgmOUiEZ8j+roL87BZUC9ZjI9bYK7h+XjJtYnhgmsl4NGpeHAbjXz++tAEli9zYiXDEc1p1GjYJrnNZWfWL7DVKYWGluDbhWuhLMlqr8CnRl9WD5dYIIKkISG5JP21KoNTbOmxKtwSOWUGcbVi+f12DuKiitR0SiKh/5e4kSykh20/fGOMNBYEMAmiMkmiYtA2QyA8Ns6aDqWAYtdWNQj0Sq1sSEquSUge2bBT+bkaCN1h/hSLm1ZQyOCwhoNcnc0W
 W7UPEsE9
 E4DWLwUIYHqMKyjH4mzb0pOM2cRMa8VA76Ryy1IEF/HGyEqbhCnL7vihHbhOzHd6qJqCX9glfsOjBLHbXQz3mBG/SmuqCRA9WugFJ0kZXCCbCmOm/ujKo/tHrCmOEAGiwR/8aIgb7PcOOlqhfP1aRo+4tpFwFTkTqkEARFfcIwq8CImOYrfmutDIF0kgFKGOF1OBHPrmGXOzja+kE6LkQxG0MzJMSSIvYpwRY9gZ0t11V4XxPzqAw8rT4+RdFKoWlTxSp2Mp89flMNAF36DwDihTihkQl31/lXWSO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 04:58:09PM +0900, Harry Yoo wrote:
> When alloc_slab_obj_exts() is called later in time (instead of at slab
> allocation & initialization step), slab->stride and slab->obj_exts are
> set when the slab is already accessible by multiple CPUs.
> 
> The current implementation does not enforce memory ordering between
> slab->stride and slab->obj_exts. However, for correctness, slab->stride
> must be visible before slab->obj_exts, otherwise concurrent readers
> may observe slab->obj_exts as non-zero while stride is still stale,
> leading to incorrect reference counting of object cgroups.
> 
> There has been a bug report [1] that showed symptoms of incorrect
> reference counting of object cgroups, which could be triggered by
> this memory ordering issue.
> 
> Fix this by unconditionally initializing slab->stride in
> alloc_slab_obj_exts_early(), before the need_slab_obj_exts() check.
> In case of SLAB_OBJ_EXT_IN_OBJ, it is overridden in the same function.
> 
> This ensures stride is set before the slab becomes visible to
> other CPUs via the per-node partial slab list (protected by spinlock
> with acquire/release semantics), preventing them from observing
> inconsistent stride value.
> 
> Thanks to Shakeel Butt for pointing out this issue [2].
> 
> Fixes: 7a8e71bc619d ("mm/slab: use stride to access slabobj_ext")
> Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Closes: https://lore.kernel.org/lkml/ca241daa-e7e7-4604-a48d-de91ec9184a5@linux.ibm.com [1]
> Link: https://lore.kernel.org/linux-mm/aZu9G9mVIVzSm6Ft@hyeyoo [2]
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

