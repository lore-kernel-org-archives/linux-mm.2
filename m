Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E6A560837B2
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xka43TzK
Received: by kanga.kvack.org (Postfix)
	id 097856B0612; Mon, 16 Nov 2026 06:11:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17936B0613; Mon, 16 Nov 2026 06:11:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5EA6B0614; Mon, 16 Nov 2026 06:11:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B46376B0612
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:11:05 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A758A0888
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:11:04 +0000 (UTC)
X-FDA: 85440715248.27.512C7A9
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id A84C21C000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:11:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Xka43TzK;
	spf=pass (imf18.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827462;
	b=ZgsLAvugGxO1sC+sQw08R52bynxow7KOTrNEzt6J1mgU6JrV1fYX9hAm63uGiXWggB/oCQ
	56xFEV4ALoY1E5B4wASN4ELt8BzFM4xfv9LsKJCH3QO4Kszbbl0tAa0bj21VIsAt89Qcni
	s6/iYCKukrEGs1sgMWkHL6eIc6R1aM8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Xka43TzK;
	spf=pass (imf18.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzDRDu7/JODZwbuavobSKTv49NxzFkRfd84aGaTT9+E=;
	b=UCFnzBkoo8MottYdEovfoKDaKEUSf7oKJgadU6nyY0zCzvYED/rvwYIjKd7bshVuHSOPsm
	+axUW3Ci3zCE80QiHDX0DuaulWY7Ee3gHVFYJfGdgQHn8qFHLUZGQL8te0jMrx9Y4Ojmig
	pYM64l9aIaxosF+KFDmDf0IXm4mdYVM=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3b3a42a4bcdso34850a91.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827461; x=1795432261; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rzDRDu7/JODZwbuavobSKTv49NxzFkRfd84aGaTT9+E=;
        b=Xka43TzKyR7x8DherhaESuTFjOJylXpOjHFMKRMT1fzP4M0Ugq19vW2Qn8qQelrd78
         NL86AAp8rEm2psvT/UO/vSzJ1b5Q5NSR+tQuam93BP8R5RAiSHtmAWOdaQR9+C4/kgjO
         PjYE6Na338BzhGzJvh49U4sB/4KTRASztj1r0KtDuteTnyjkpJcoMCpo/7L+cSjDJxgf
         J7Aea7H+gpLJJLU8d5Bs8oq3WkNRmmJyxZRIf48ga0yx8bkvqehzBknTwxeWJol4vL4k
         Oo7n4i0vtUsdIl4yiCwlfazZgvwaIeQutuBlf3c205Xhy6JQ9GyQakCZ0jHyVlP4UTJf
         he/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827461; x=1795432261;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rzDRDu7/JODZwbuavobSKTv49NxzFkRfd84aGaTT9+E=;
        b=gLI3jT6PTkWqE8r4pCXR7IZuwPY6E0gBwywVVRm8VnFNnSaSyEhch8LdlQo340Evga
         CFsIjj2yCexjIYYXw/Wiyw5NmjbwWI/XuZIvy5y0Qv3AQELJPtDMrgxi2COofpDJEDbY
         AMmsKtmdthYheK6yTPjYqoUWVfr6nZLb/OwTH53oHAgj7cRckc8X6CiasZIxBTAVPDYX
         saP38mX5vbOzu0F462k65OWNJkIympoGJkr6OXq3TzyljlC9Zk8x4pMiuG/VfHR1Q9xS
         rIOQZitnDac+3ZbeGQybuEhe3V0w1MAEGWyilGOS7jCrK5CyObYaikvXrNKHtGdTy7Z7
         m4Kw==
X-Gm-Message-State: APuU4Z9YRaYZKW9DkIu2LMVAKEjYfKUcuE6LeOq+lYAGYZd5hDtRHQtv
	lE4JRPm5/qyK/Gzv2vvsQix9OsI/PUmhgm/fkQuDqUMpef5aSUr4Glwy
X-Gm-Gg: AZFdTZft3uQemvQneIrIfF+iltT2p6Ca+rUwZglrl6IU3f+g9awPvmu1Gs9RUIZTe6H
	EL9Vz4o3h51e/udsD1Dv856BbsUuF8uUG/YN3Zg8AR5pvBICCqSbpCGmdn1i84fSmxLtlYSSIXq
	rsm9vyPyE4eFFPVXQVpLizcndYxgWi/guFRmrjIbXHB5RPuwUdXiB1rlJo4ipI5QPNKPP+RFYq3
	vbNP9twPfwjF017KFVsz6Dxk9EmgQuO6Os1AslbACDA/K9KQWI4B/7+gkjSjMkau0s160pSee90
	ROLT5CYlZL3ierZHkn8uRkal2WH9NnDsjW03r5iKtQifIIT18dWlJMbRD2e+gclZsnpTaLL2/PD
	j/RoloyCZzYSrwOKSDrjlRD2Y9n9xmcU9gO56uKLg+2lig0/VEmijp6OsXfUVGnTR/nFdfNfDNG
	U0DGR3OVCDjqb0XTTzYAl8cjW6qvGXMxRGNcFzCGzWuX7M78fUN2P0IhVdP7YsYfAOY0sI8u4pd
	ptW74f31bTxClvZwUIJMpuNvxpSkLTEypEE+VyYSVUjtBgOkPn43xC+8A0OEoGDCwKCmdmXExMJ
	2ZqDE0XdC9do+UTuacWj/pvOuemc7QObWDXQWN0uPseZAHINwMqvHKPriNYmI5xVGZpeC/lXFax
	GnPTvWU4OFEU7LQM=
X-Received: by 2002:a17:90b:588b:b0:3b0:9984:18c9 with SMTP id 98e67ed59e1d1-3b1b09f37ccmr8454898a91.11.1794827461360;
        Mon, 16 Nov 2026 03:11:01 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b1e9ef15sm9162815a91.0.2026.11.16.03.10.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 16 Nov 2026 03:11:00 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: Re: [RFC PATCH v4 00/18] mm/swap: introduce priority queues for swap device allocation
Date: Mon, 16 Nov 2026 19:10:30 +0800
Message-ID: <20261116111044.28724-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAMgjq7Cq5OQWdompBbEpyJTG3PhtdSLFUdb_Dtht3qH+u5HVhw@mail.gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com> <CAMgjq7Cq5OQWdompBbEpyJTG3PhtdSLFUdb_Dtht3qH+u5HVhw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3diaxmufpqh79d83imxzta3rbd695auy
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A84C21C000A
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794827462-665066
X-HE-Meta: U2FsdGVkX18uNjN45xWX5BXBMmOLrNeC0pVUc9EsdIaUWZdKYIFMH6RmEPveZ/eBcIbwOUVeZuT1pfG5vUB01z7bD2TMmxvrYhH85xaBiWL1YEEe/uej/QSQoMUgDpCKGiWbEReqnOFWqJ6P4EJ27sJvQw8/5tpFjgcPvd7KW30BjKG5LUxqsNfXStqsp1hxz0AIc0N/RiaVmFFbvicdx9hUrubA4OVjj5p7nEAcC0+ol0b19XyoMfqm02CUt57kzYbxzKLItQwiR24rfPZKyJw6I08es1oAVtOZjwOeso+SwJY+Cq0Vl4ndm4IxzryAbkYv/pb6jNAC6LRXWKdOM9IbExzQPxQl4a+r3ozvzno6sb8C9B4KIqLFnSLqljDVJmE5FNAkQEPgKMCngxRd+5OpeyG8KLFLCJkvZUcV+6kX7leg/Y+huUWn8QUxGEVM25V1Ee6z0UnBNiV7YFn1HPrUmQOioA3csCkpdKjz4J7QFUeTeQgvpwQcijq9XbzpI04tkGt9FENPloQ6t/SYTODYAKhdaZJvbg5iWJtmOvbrDypsWwhX5tDYnyuORW96KsW5SvxkH6Pd+6Wbk5nehgsCbUmwgjCbWpi+Q4XeVzhF8zR8GEeoOX5mYtVxoDyoax+aKV/KvJfOi6bJZYYNUbO9bsOcFmOdryFIv63QxZSU+va23L52q+1ShG1lHaFtDklyaOyldrw11UkYTVGNGlFafqFCinl4xJvKT2qLqwyLa7lYeIsStp9O3hCw9p2LoovPc3BeaaWMY8NsVB+smwivbBBk15ka0zwMQ8+nuhw6EZT9k0t6WhcORXArxW95IgEkxu5pWkuMIp9fn9QpnQOg5GVf/gMRJx5RFe28WFot2EiXylNW+dVjzf//7krJdDAXa/isrXsZtUvBG0kwKekmyl/zbdNvG4n3pCLuXn9TrHtMogOUS2zJrOF7ZWU6MZVVwvlwI3x3sV3O5Eg
 O5WUzRRv
 Re4L7/fk9MWTGRrxwEg67dRNJ+fSxOyhpdL34ARBhhtTN/+Xo/Ei8Vwj+QiZnvawjaGooJymHuLwJdBxlMeTlYcM7JlQ8W9eRBZlT+j+H7hVR5V2BDvJzNeGPbYbL0YE3dpzdQVWMbjtrAFoOJVgHdggjgPl+BIWritpa/l7JNFUhdOJtwnrEYWjy2kdi6Yyj69uO9zTa5SelIFcz/zb8cuVS401ca0vPATL4IxCu8bGLzyBE3FMqqwLYh+rHC8j7o8yea634Vhvl8CZjpwreaRb9HGRQEaHWu+S5QoNkTGDGj2pX197Np6+IY6e6eaYdCuF+g9Ale7hKxyEX9OKEHxoyK2R6cZo8+SSYWf9/gAPdnagfrTheuNvr3AGvBBDAaoSp/GGg3mDe3ryxRLsY7MZfrv564/1RySncYJCU4B6r1oDrfvPiaW84L0kfN0h3Xj8l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Kairui,

On Mon, 16 Nov 2026 11:52:30 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> Thanks for the updates!
> 
> Nice, but what does n/arm mean?
> 
> It's worth mentioning that the global cluster cache is gone, so tiered
> allocation will have a much better performance.
> 
> It seems the sashiko review is all green, which is great, let's hear
> what the others think about this.

Thanks for the feedback. By n/arm I meant the number of runs per kernel:
12 builds for each memory limit, and one BRD invocation. I'll use a
clearer table heading.

I'll tidy up the cover letter to make the motivation and scope clearer,
including how removing the global cluster cache helps tiered allocation.
Once I've collected the remaining feedback, I'll fold the changes into
the next version and drop the RFC tag.

Best regards,
Lian Wang


