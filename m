Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC844C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 13:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15F3C6B00D1; Mon, 17 Aug 2026 09:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1109E6B00D5; Mon, 17 Aug 2026 09:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026BE6B00D7; Mon, 17 Aug 2026 09:26:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D6D236B00D1
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:26:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A97EC0737
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:26:23 +0000 (UTC)
X-FDA: 85110835446.15.D37DA49
Received: from mta0.migadu.com (out-192.mta0.migadu.com [91.218.175.192])
	by imf16.hostedemail.com (Postfix) with ESMTP id 426C9180009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:26:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oontv0Fj;
	spf=pass (imf16.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.192 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786973181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IwDSGqPPjOfekQTq/DjCN6xGZ21HcmI9nG/H4dITACI=;
	b=K2hbcWGIhKHs7uSauUTI8ghtp4u0W/OdOjA1bKNcG9S/Yfo/O82JPO6CUsdfBZOwz9JFbU
	VQ12Xj+Z87LhmIhSUfDES3dHM4UOG+99oO0hePNqkr0eHymEUQ3TLHxxcqze0mSU40cEq0
	xNJT52HzFp3iB/abPyjWeUNV+H8HV+g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786973181;
	b=ma85wneI3fMJoCi9SZ50L3wjvZRjur6kAnx4HtHJRusgqDdh/CrVTXr2sJ+2Y1rUpMMfJ8
	fIGy0pe+QRbnvHegavpcOEj0R4BydzjDFpBCQOGHetRfcXEMQc/BN+GQDSHZ9Lzy3qgcdy
	ffqmKrAdA7excGGemU6CsG64QsP9ooo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oontv0Fj;
	spf=pass (imf16.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.192 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3TpusMzd7P3socew3RIylYm80V4CeRzsgimpDnB14AY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786973179; v=1; x=1787577979;
 b=oontv0FjSPtRmQyimAZwWTEpL5I1SA/+g7HIYN42mqj0Y8PH7r/furn3ea9dWU1gJ5kUftJl
 xA4YZoSd0TMvexIl2E6cq2gpuomjthxoTNSPgHgpPs2Iq9nresI7Zo3aiNRTml7NWBYdNcbIlGb
 k50hYbzLoJpf3FAnLd9lmlWI=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (195.100.225.50)
	by smtp.migadu.com with ESMTPS id 922c91fc4dceb656;
	Mon, 17 Aug 2026 13:26:19 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 15:26:18 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Christoph Hellwig <hch@lst.de>, 
	Dave Chinner <dchinner@redhat.com>, Daniel Gomez <da.gomez@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Dave Chinner <dgc@kernel.org>
Subject: Re: [RFC PATCH v3 07/11] iomap: Add DSYNC support to RWF_WRITETHROUGH
Message-ID: <aoMLboIzOmJzn7C0@quentin>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
 <a679d79b676d3a43332aba54ba25660c9ea9e1dd.1785908600.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a679d79b676d3a43332aba54ba25660c9ea9e1dd.1785908600.git.ojaswin@linux.ibm.com>
X-Rspam-User: 
X-Stat-Signature: fjqbjktskpn94myrd8yw8dd6y87fmu79
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 426C9180009
X-HE-Tag: 1786973181-644044
X-HE-Meta: U2FsdGVkX18U9M3lSbmmSFtkIHgFN7TVenr7rBgcSXS1BnZk0CbrIi7HqyA7m6jHOQKj3bPZMY05mghH6dYO1EE/jyVFAZQBPYoAwN7S2As/jzmmyJKk9C+tSXmi86V6B8vcr5mYF8MHtfX4VZG+RmCK0Lfl47LKCIcptQumnTaOpPyV0v0Y9HQdLav0q0/RTaXmqEdFcJIzoCAdJ90RVva4IacLN9Y9AGJOdRuh3awiUgYzr8SVkf1x33yYPKQDwPO4MquNR1BFKqqHaokO/MyCEDTdhBb4E2ZIyaapfiuyjWh8lNBsLulOb2FgoSRzO9iYacLahJMUPqGbyvGTAxQSO5RVfB/FE2VFkfOwxqAfis0u+IKuiJ34FDG6ngPSmB4Cb0ryTCeXXeWd6tQYdQtWV+1xAgA9xJKtv4lHP0pyrssg0wbrivly5RHoHnwnv1t1ENDKN7Qb06i4UY0zgj1RzhDIDH0ep4eGBt3VvT7I5YIVtunrIapAHUBII+0GORyWvFYOovzspMZZJRnASRVUV5C8acMWmETK76aq/HPiWijbU5I3VSyZ7LDdYEe2yssrYUiYvjbHMrhexLpsiM67m27dUCeeO2suE0TZi6iA86dL1Aa2x0U2tfr2ikVaD1P3oiBfMxNq3Tvqu0GJSyWEhNjY8GKG+s8y+DeWB3ChFPw8n4J4ElZimiSgVX/4lHvtKT7rzPpM5FYTpXUkG8KEqYVS9fm/3yjddF7dbDmOe2epd7JEcadWVoBaatcGuGfk8+OrGXlLDn8ykp5s5KPGRxGTGU3yslTb6X/WBkMxb/yIsczMf5xrhWo6VXvBgF6cXvz9iKQtVBLNy16yrt4qQNwOyhp0GsZqQ24JwoAj7RZMBisVsLpkbKI8HZxZSTdsiHBf+0SBCRjic5XXPiKDCLgGJv6Gmuuw8Ic3rg/r3ysuMB0r9XWvMh8P+Z7Ku7InIpT2gdtVoRgl+G5
 29FUdWjg
 eQbt1HUipIphCez3ci8lokFNXKvE6EoPKjPhUz46abiM7XIWpbrFWoz0t8i8DBC9f/xIF/BpFHZj9nKyKUiQPGyehS/3rmsSz6WiFSEulTdlhnTfCiEdUEJWSrzpR8Rif/NOGfGVi/X6ajms4zKHquZKWwO7YeyVGAVswHkUjKr3x+2AkzE6WKu22XzZpe3Lhk2qDvlYK3Anf34EKjOPpDRxNdwyDv6rwUSazepQKt7+Vn2vd6mFujmx3U70FNAgK1LJsnnTS0lAJXRwDYYn+m8QkXjmNS2xf5XmVzrfRvOJVVsMgOQ9PFQfZL+UcrYuHA7NpMdTg4YpdA9kITZasA8GRiP/Cn72E71jzjjj7Zs2177gk0ipLecUbKecXpJ+DkYn+45d7Myz+vtY8+1kaYljI79P9CrilHvuPQ3U9MfAXfedyDdRSNXpfkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>  		return -EINVAL;
>  
> +	/*
> +	 * If we realise that cache flush is necessary (eg FUA is not present
> +	 * or we need metadata updates) then we turn off the optimization.
> +	 */
> +	if (wt_ctx->use_fua) {
> +		if (iter->iomap.type != IOMAP_MAPPED ||
> +		    (iter->iomap.flags &
> +		     (IOMAP_F_NEW | IOMAP_F_SHARED | IOMAP_F_DIRTY)) ||

> +		    (bdev_write_cache(iter->iomap.bdev) &&
> +		     !bdev_fua(iter->iomap.bdev)))
Shouldn't this be similar to DIO code: !bdev_write_cache() || bdev_fua()
?

As long as bdev_fua() is supported, it does not matter if the
bdev_write_cache is there or not right?

> +			wt_ctx->use_fua = false;
> +	}
> +

--
Pankaj

