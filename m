Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A96FC72DA
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 00:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC6F46B0088; Tue, 24 Mar 2026 20:27:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60116B0089; Tue, 24 Mar 2026 20:27:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D75B26B008A; Tue, 24 Mar 2026 20:27:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C56516B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 20:27:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 12732E07EE
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 00:27:07 +0000 (UTC)
X-FDA: 84582695694.03.F9E8452
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 79E361A0012
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 00:27:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bkwk/mKC";
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bkwk/mKC";
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774398425; a=rsa-sha256;
	cv=none;
	b=KQMDxKAJvyflNSIYfYFZFnyWdbqtU9T8i+1hSYykN/gqCJqZKDlO/O57W489NDb1mL85Ok
	nYg4RJsthceal/A8axjjLNLag+PS5xeMTEaGAnd90AL9pR3HvxmmyaS2VnKd6NwPz8ZTJB
	/5LnGSONFgFBOAE6eqDZABrSf8YiO4I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774398425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ZGrh0lVcqL3xhLe7tFKs5FcqVBItzNccuWpmUnROcg=;
	b=M3mx+gsQFTjNlg/5unoog+9lXkRR1Voo3ZRcDrclA6HjrXIofyheK9b+dQncdbM2ugPxcq
	YvGfpv5VV7EzzTgRousyxgIkPHJ4bEM8fxx9lUl3kib6+6Nd/xjBHMXFZruNE4Yqtc8wBc
	1UwppXfJSZhT22cDB/6+GwgXOMYL7X4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AFC75600AC;
	Wed, 25 Mar 2026 00:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BDCC2BCB1;
	Wed, 25 Mar 2026 00:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774398424;
	bh=Y7EVwJ+sjpBixaJ4qN9HZFjajxFcGP8TqgJtgUVGXlE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bkwk/mKCdeMGOikDf1qDXBzCadzZC9pJcXzSGUaNb1GwuC70QkhkYVK8eoetKqatZ
	 YVRR51W7BR+DfTKsKQ0UxKmKMmjflq1TXdrS11ejMscD4ohIkxnrB3jE0i9GRDmZZ5
	 b9lEW3EEOPqd85vDuKy2DbuSrSOtUuFWf8qoyQ1/R67ipI5Qfv/1WQYwIa8CsUOhUw
	 2klBzcS15H8OWi/m2tol+kepYz77MaXiGCWS5uabYyKPX3Jf/R6N6hdeaDXfY5g9Ft
	 g75Hwsw+7+7kpaIbQB3NAI3pt7FXIx8l1hPV+DiHdBSE6toFYPRiIPFrbLp2XPLtED
	 DHe8AIvR1xiOQ==
Date: Wed, 25 Mar 2026 09:27:02 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
	mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com,
	mkoutny@suse.com, akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 3/3] mm: memcontrol: correct the nr_pages parameter type
 of mem_cgroup_update_lru_size()
Message-ID: <acMr1nU5PLnHpnwZ@hyeyoo>
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
 <2cf06f9faf51900ce6acbb4740fc60355a2842ed.1774342371.git.zhengqi.arch@bytedance.com>
 <641f8cfa-3a8a-439e-bf03-87af4c49ca2e@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <641f8cfa-3a8a-439e-bf03-87af4c49ca2e@lucifer.local>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 79E361A0012
X-Stat-Signature: 46ejy5yq1rn6rf6ibur6ids38bfzknjk
X-Rspam-User: 
X-HE-Tag: 1774398425-705394
X-HE-Meta: U2FsdGVkX1/mj+4SUzb8SZJ3dfL0XHA7s7vDzuCK8+7J+/25mlYtj+9F5xgMrFjcAJHbNp4TmQW6EsEWJwfMh0Td5/4zD+UzONclPu1BmLpDKZgTRgYTi3uatRvoNheViT644421j6EwfsDGi9STQWgecI+uPJdesuAOmryxMbRdslSY8iDMw+st8d02oP03KDehwrrx3q6PKE7t3pv86uMSqheEAKiDzb72pnZdDo30ewUrkefa4Nx11ou3VxAye7z7DdU8M3R8/uK/fKPk+n+wxzkLN4o5Aa7imLlN7CKi1DPtdJrasNfUhcCCKbf84kZs5pUafh/IP6bb81A+yb1GVaNj4SWeEmgQxvq5wDp7lR2ZpWfpaRNhbkA5XT1pwXzixaE2XuXTarqYhLMpUIjLKrwQ/RZZVw9YU4LTC4R/9IGUM+M9G3nK3M2aQCyxuGP7lVoRJNfFB80V2A0zMlA5M53Z8xY9Ptay4vxfvdpGzD3/XJOQuarmJcqLWNxYsnFyX3viuXNnHz9+STVnvmGAHwGEx2ApE8sDGeaYnEOX83V464tbmLruqugdCrjdyM7q+nfc8+k5DSsjoWw06drLExRII8lWZyp4BYj8On4YvD7FJrOBc6J49b7bqdv4XgDG7ZUBQRcTgNcpYw2SbvnTO8xQp3hosdp8B/gKAcW3CDnqvRK+RChPuY77t+ZUyf3noB8zrgOq/xvnR0SL8JBVHxVgsQjH44vtQLGE7CRdZL9smznWzSSO/9EccXHTEW3Si/qPeLqxefh2eGXa42lXMlwZl52KD0pgkPoH2qOwm0HO5f8xjfAgPds0QzKfQLQ+yrZBSOTVtI67JHizao+5r+meh77z+wPa2l1hXcvGOhA+5fKwFQ3qzF43Zh+E5u5QHsoA5DYFK/1WAfONpC3vdu/E+kCYAL4oi1Hv5FTUVObcnkTGvfJS2ySNFsH8HaQjZDVDuv0fozTMR/e
 X95RldQ/
 I/vTXyG/1TuzFj1UtmAOzq6R5klJ5W0O8dbjzLSsDPDlLQ82xAH+ml+y868X+zgbVXv7Bt71jGT8EFotBcodIFwbNI4pPkhVlILoD+QwS92tuEKvvlXHLeqgUqp6pFTcZEB6OvfGuQBsnlVVxCFXCIOQbUXtohxHya/SsiiS3q9YG088XFn/bjwzDNO2D48Wi8yps58mdzaeaaQU7mTQ2qQQjN99Q6kUPHbZ+yqkl8BQxGgFj8yu9IG2s0RQn7yrUoVIRmpT1I8KnqdEqL6ObEsNMG201ljp0lNpW5IFiwSkcA7YwsgmuRzi2RdwjLN0utDqs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 12:28:08PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 24, 2026 at 07:31:29PM +0800, Qi Zheng wrote:
> > From: Qi Zheng <zhengqi.arch@bytedance.com>
> >
> > The nr_pages parameter of mem_cgroup_update_lru_size() should clearly
> > be long instead of int, let's correct it.
> 
> Hmm, but are you ever going to be adding that many pages? I guess technically
> correct though.

It has been fine as-is, but reparenting changes that.
Reparenting in theory could add billions of pages at once!

And yeah the commit message could be improved.

-- 
Cheers,
Harry / Hyeonggon

