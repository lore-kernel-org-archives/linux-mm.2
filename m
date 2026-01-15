Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A2DAD4660A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E60B86B0005; Thu, 15 Jan 2026 13:12:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0EAF6B008A; Thu, 15 Jan 2026 13:12:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1A966B008C; Thu, 15 Jan 2026 13:12:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C27A86B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:12:56 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 32E201AE4A1
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:12:56 +0000 (UTC)
X-FDA: 84334994352.18.FB9D09E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 77B11120004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:12:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Lg6cCJZh;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768500774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OjtdKRmjxsNKIzj7IDmtRGB6L76oBHE9yEJt+WRp/MY=;
	b=d6icvuzBsQ3WrjKh6vgE+trf9Blj+957xs8uhZiTqtXWG+Y8vX7VZj+cnYfCu3B8Km/4Rw
	JgUIKPCAOKHxlp96WG2QFOcpzj3R6aOYFBtbWqBsW+b9WCFlzKGKsTxuXWW+t7jWZ8V+gc
	7QntYbmPQLeR6y1kmqczB6xwYjzsIUU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Lg6cCJZh;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768500774; a=rsa-sha256;
	cv=none;
	b=q0HkXuFUoJiOhT3DN4IgW1L37H7IUU7oDrGSNeimpHy5IyqMTPxXuYzB/I5Gqo5CREsFWm
	gPPAtrdcOG/oyszCVS0/ULNeRwVajPpYhkHjR6CZvFWedA8/2YnQtNkh/z6HgBy/XRJOXt
	aRBIxuJYXRbPT1/0yfFGzHqngcNfrl0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C63726015E;
	Thu, 15 Jan 2026 18:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13019C116D0;
	Thu, 15 Jan 2026 18:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768500773;
	bh=R6KVjB4N/sjBVa5RA9eGHtGWnX8ojabIeBNaw17tr6o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Lg6cCJZh4pijiIkH59FFPEsm+BnW9TrN4fToQJLndud7ZJ4UuJ6r1gieuWbsHC5qy
	 KmK5Y1mbx52eM1YyF2g545p4WJ8IYwKjTMNYlNPbu508PmAJ0cpaOtMncU3lLn+jqk
	 g/kQieYyNH0gmflJ0FveGmNl1YjMjbmzRTRLW4Yo=
Date: Thu, 15 Jan 2026 10:12:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linuxfoundation.org,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, mgorman@suse.de,
 linux-mm@kvack.org, wangkefeng.wang@huawei.com
Subject: Re: [PATCH v3] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
Message-Id: <20260115101252.2e0cbe0559e62b988e5f7151@linux-foundation.org>
In-Reply-To: <04b92008-f843-4879-b4a3-608cc5e1de4c@kernel.org>
References: <20251223110523.1161421-1-tujinjiang@huawei.com>
	<04b92008-f843-4879-b4a3-608cc5e1de4c@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 77B11120004
X-Stat-Signature: g1uc59wh1wgy6aa5rrrkxjs7rc77nigu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768500774-195344
X-HE-Meta: U2FsdGVkX19kvRfc1/TOJ6AzxEnD3e4iPKbzVf8NyPGsBem9a9moQaEz0Ndj0XugI7scOswG/o/C0anghkTHpVG/MFf/arm47VhXoL/qVAVu2zZZ3VKj7jYRExvu/BkvMGtRr9QjFTm03MRq25gmB+02Qqj4FRHqrBnfJLRbHCm7w6TpoVquIjKMrtnHgf/k2UpL0Az5kZ13bKChnvVDDNV4C1jsCWjSrMpjohHaXOcHkNPusEBoSl+GiUL+t7L2tEGdpNF7CV/iCjn63Aukkv+MPurCS7xjqVwgorVjpj/QrjyhISpgD1kL7b7IxiJDWh70ue8+gUM/ZG6bS/WTGld1f+VOxZo9p9SxgTNASwBMnRMl3B8Q05FYBLFHrjLyI6EgDfyjfI+s8mhDrHjS9B6cIKiBqvcTw4YUsw8omOX8C8Gt7GqsJ3W/2YpUiWu9iJxj1ZO4LF3X9LgnoVSy4577Z1LiKU/pbQE9fxJBD0CvHVniTJPEr2oj+foTKfiEwQRpYrFcHYIiyjrBSMTX2893MZ4zcY8XAlExfyYsph1BaLeFMS/U08/Z1846TJh4O7epcuOyI5WQMGEojS6ZeoPYlN/5MNKEzc447wfB0nnxWbwv9887zJRSqA65/AulDomcQkQOoKJ1GFbduDCot11UNV8FiTI26Zi3CD5gvaCdSpsw5OA8YbjyE5tFQKNP2NMidljXmmbFRZBizkFbTJLGAuhezmxpzbz8a0CuD2h3nFXYy15HlEzKHsAxSnECroALzTr/mJi9lVtT3gQcCuzystGi0gfLdLajzYgm9wAs7BUOb0zONkIqbDEM6Mrv3RQuqISm310VtxHZAg/yO4aCUX6VOCBZxyLY1h6+G22vhZDiRKYQrQG873+LPQp4/A0SZu0xmljxCUtvIv+gEYIeDq3hm+hk7oDJt7m4MHxtcOkgpW5XU+st/AWWcdO0VvVCYMmRO6OoTxvl+v6
 MCBBSRXb
 GWN887OK6+xtkFfxOb7iE6if+ui9IQotbUWV3/23/ogus/ym4GdvZzsxvG381rv4q0X7wOFU0R6Epmy03MCr2yZY/3PN667AqyKSO9qowMaIzOQ2Z+gc65jfNywfksqmAQ1Coe8C+lkFAoNnTYuhsaScyh4FqME04YPGqSjMP5xB+EdXUKyK6TItyxj2XluWn9XEbmGcqgqc0Mf6WQ3yeXyPEMp7EYjyQkmG9QhlQ6U+kHb9ojmE8LrOo51SnwkiYANXsm+rag2jXqeW12my1GCGSZOInm0AM7cp8zngbgxE5nliCll7Al+0aD0Qfiad/F78CUt+cTcvPBq00YalHyCwVwkkp0yWWMd8zl0EFfJpY/YLJsVR+9RBUGve/s/LJPcxz9tR7Xz2koKk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 18:10:51 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> On 12/23/25 12:05, Jinjiang Tu wrote:
> > commit bda420b98505 ("numa balancing: migrate on fault among multiple
> > bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
> > for MPOL_BIND memory policy.
> > 
> > When the cpuset of tasks changes, the mempolicy of the task is rebound by
> > mpol_rebind_nodemask(). When MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES
> > are both not set, the behaviour of rebinding should be same whenever
> > MPOL_F_NUMA_BALANCING is set or not. So, when an application calls
> > set_mempolicy() with MPOL_F_NUMA_BALANCING set but both MPOL_F_STATIC_NODES
> > and MPOL_F_RELATIVE_NODES cleared, mempolicy.w.cpuset_mems_allowed should
> > be set to cpuset_current_mems_allowed nodemask. However, in current
> > implementation, mpol_store_user_nodemask() wrongly returns true, causing
> > mempolicy->w.user_nodemask to be incorrectly set to the user-specified
> > nodemask. Later, when the cpuset of the application changes,
> > mpol_rebind_nodemask() ends up rebinding based on the user-specified
> > nodemask rather than the cpuset_mems_allowed nodemask as intended.
> > 
> > To fix this, only set mempolicy->w.user_nodemask to the user-specified
> > nodemask if MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES is present.
> > 
> 
> ...
>
> I glimpsed over it and I think this is the right fix, thanks!
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Cool.  I decided this was "not for backporting", but the description of
the userspace-visible runtime effects isn't very clear.  Jinjiang, can
you please advise?

