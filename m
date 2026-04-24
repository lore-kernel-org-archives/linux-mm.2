Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CCEBFED3C3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:48:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51E9A6B00A0; Fri, 24 Apr 2026 08:48:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CFB66B00A7; Fri, 24 Apr 2026 08:48:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5E56B00A8; Fri, 24 Apr 2026 08:48:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2DDA46B00A0
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:48:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC0CC86D8F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:48:37 +0000 (UTC)
X-FDA: 84693428274.24.03C96BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 21F31180003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:48:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I9QneGDX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777034916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=udRRN3JV2Ocz19QQMpTbv13gq8avhV9J8ui0LFb68B4=;
	b=Hx3db51C+RNf17NPcxJAlgXw92Dw/+YuTmdbNF8TwC83qeI0jApWXz0MjehuJflNLzm13N
	4HfiIVcR0w7Mvgn9NpW9QLQ/lOkDbApn811tU3rM841jBPHLpep79b43B+TqQl23GsoFSN
	Nt2wxlVMarLgCbcyXdSAda8t7E+txuA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I9QneGDX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777034916; a=rsa-sha256;
	cv=none;
	b=pcJr4snzIK+6Ik66jqVmSXqzdWrZ4dq4QJBKjeW9OuL+YzI2IEBUzvH6ZtkEJHiMMLbuE6
	UNVuAwIotQGsCPY4AmJdsfVsR40OWN6pCe/YN5l22/OCOLhy4FehdFWne7T9APFb+csycv
	Otsj/669MvwjquRQe7oWmduJzBPSvfs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B82F43984;
	Fri, 24 Apr 2026 12:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28CFC19425;
	Fri, 24 Apr 2026 12:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777034915;
	bh=bmrtpah77EcnjbmtdZKoOnEjBu6AYR2ZoxGaPqk9BF4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I9QneGDXSDd53IEQJiEBnBZiPTozZyO/odDu+Y1ZwcfEByzlZF/JcVarsZ3lPOnUk
	 uiREWsFW/O9dUTQ0IKRiWHZdF3mSZkVw3FAsDMFmWuAaSRslqdM+2iPp74trRwyW0m
	 y/nxmvtPexntepCT/qpOFl/cPDCtF2zRk85kHWfoCXYwlJ1Y4c41TXEpnde6AHypsa
	 0wDJbs92JVSLwy6yv0rzdqRggjDHLuUIF14y3KbBYwvTAzdf9xhGzRSYXXLlhNDwhy
	 pitEBnT/0sK407eySB4OyWb5A2HhUlhVIMltY6wuMQdawUMI9aNhGp7axRDRxsE3vM
	 IoYkE04vWGa5w==
Message-ID: <16a127ef-436a-471b-b463-cdf4ea038d4f@kernel.org>
Date: Fri, 24 Apr 2026 14:48:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v4 08/12] mm/huge_memory: remove folio split check for
 READ_ONLY_THP_FOR_FS
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260424024915.28758-1-ziy@nvidia.com>
 <20260424024915.28758-9-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260424024915.28758-9-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 21F31180003
X-Stat-Signature: zckpet9cgx4dm7ze8k533pomkk3ciech
X-HE-Tag: 1777034915-92314
X-HE-Meta: U2FsdGVkX1/iXg4g//zVAkrK+rnGxCnGBPi1buShQKsUXRR12VT++qiHqNxuc+pZ5LJkn4zCAtMw6I7yIHTu5Q/PZ2Z8R/bZf/uKxUd0BbNcEZnDAm6ns777igM8l8KxLEl/I8v7cC3Kn6a6HzGXV+dDUb03uULMEWKKo8JeKP1pZEeWvKyEKi6NT+d6jviozxH3n3Bs6ArSr7/n7VSbE8A+VudITcUlHt4carreVjH06DVqryU57/quTSDFhpCqKBX81g86w/vcpWxLQvLP93Esa7RJ89WO+5aEPPFGMciFpWOnqk0RFVNfM5W3rCaRjDI3PYwoc++IZfQQvKsZ547IL4G2R5GK5lyhIAoTN9W9WD4Azi2T7Nk6nZPE8YqTXOLBaoeSARSEcqaec7FdnlwzQtmfDAv3GhR1ejUD5PIjjSyupwruCfwPmPshCfpe+IivzUBcpzcphTOWDH0kG2vC+Pq4SLShul0fje4TEuhOQizJt03VTKNTZV4CyfKN7NzOFY+wr4Pdp2p/tX6s8FYFOlI78oLRcYUImTZJOglHXQli9JG9wj/T3V2/Mzg/oFHUjmBDusdOMDX+hQR2hYSN7/yFt8kjZ0U+hlebkhkiGcRI1unn4H2thFHjc9F6GQrtTdvFkoJ8qmKEML0P8CZIJ1wSWTtQ07kggoXeIlILvAieyez5gGe0r3QpZVOxvGwIbj1vytmGJSavqVX/TyOPDMMA+PUai+MT1rnBFGDcallw2ytbOtFEV8lWtZ8K27DjU2OTG0CeSNszTewLPOBWkgEPTTm+QO5YBjoaWC/cxQ7fCb+q3XBN/07kADbyzLAKj89P52/xovoPkF7qeOFNY8wqwJnGhSvkACwmh3XpAZa1lJxe7NzMqvgiFu9FNbhfXUA4NFMAdoJ/lPM0P3MebDX7GQIeOEQGEa3E7FsVl2Bc6irgFFdWlwzmp5pe6XmHGyZayPyA9QklFOV
 YupZ/bWf
 G2d2nYeShTxnwgTyt4gExO0tXCEhZdX3W1v83o6uPZ46i+0AEwS4+BEgK+nIqTiFxoWLQZZsgtTI2IC+xL0Jb/dT+pMB+4ztu7LBHdnTqEo7rs5AJnAYhB9SnACZhbdQM2s5koynff/75m7F0O1oZm6Xp2YgHehivE7j5vEk7l6NdH7VNorJ8MKmAuiUWyKskwJrD/oyoo/36gToP0S+rdra718ZUMHr3W7nxkTKwAG98pmI5LEkK1zwv/D6n6ZMllqJyuZmr9L4RBl+syBxpSRVveX7X9PXod3TY9UEFUhWYVtiPsSNhAVH+l3iHmJbOvZmalqyA964uuiNywlkc1PV/QZcIFrW8dxtBnSNjQBDf243Gp5J48AcHJLZd+9wQ2sGz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 04:49, Zi Yan wrote:
> Without READ_ONLY_THP_FOR_FS, large file-backed folios cannot be created by
> a FS without large folio support. The check is no longer needed.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

