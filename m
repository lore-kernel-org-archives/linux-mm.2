Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA8A4606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 06:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ckJ6LFUs
Received: by kanga.kvack.org (Postfix)
	id DCD226B05FF; Tue, 24 Nov 2026 01:29:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7EFC6B0601; Tue, 24 Nov 2026 01:29:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBC1B6B0602; Tue, 24 Nov 2026 01:29:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A76286B05FF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:29:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 324E41A0A7F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:29:34 +0000 (UTC)
X-FDA: 85469036268.11.3AF49C3
Received: from mta1.migadu.com (out-36.mta1.migadu.com [95.215.58.36])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2F91440006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:29:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ckJ6LFUs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.36 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795501772;
	b=ConkzdD8zXdDZ55UKmrSkfek7fHlXGiOZwrM20SbdNcmItsGcXeUrMPl9VvOQhs7Qfdz0A
	3gqJo35c3fZmHpEVlQGtBMZi387KMQflF6RBNd7+Lpk6B9j3YK+DRIYICd3/5v/ffMcz6u
	YPLwa+mS2pKrLVwrTq84GaRH8CstJUo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795501772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NpJ7p+XL96KolW5YrSmILZycmP6UbJ2UnBz9Vu0J3sQ=;
	b=D0QPKdWkYbBxpk3Ztx8lchzPpk1SA0iQfRDGoHIS7EecZSH0JhxOGkPmFgZldxvqgFFw75
	oCaR01Bl/YpVR9sS+y2GDc9zmJk7ukSY7amZQELOCQgc0G5Sl7xKIYIUC60kgMKvshOz4O
	7jhKlOUV6twrff5Eu0RtsObIu34CqDM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ckJ6LFUs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.36 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TwUmDLsZun7XGAL7ci3Ea9GyDSoS4ymbA/4JJT9faIg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795501770; v=1; x=1796106570;
 b=ckJ6LFUs2RXaN3v7t0TPrEUUY1xB73E4y31KI2vp9Ks0lIdY/07pGXkhZTW+1UZw8TO3abAW
 MGX6+VEUREBm5441TKaw5h+EfVoZvZupS7rzDruQ1+JGEi+BVopPq8GdQudXidoT+8o1Cd+dYPt
 Ic8pfe4tijo5wpQADcAPdLkI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 27600df550999364;
	Tue, 24 Nov 2026 06:29:30 +0000
X-Mizu-Trace-ID: 27600df550999364
X-Migadu-Flow: FLOW_OUT
Date: Tue, 24 Nov 2026 14:29:22 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, david@kernel.org, akpm@linux-foundation.org,
	kasong@tencent.com, baohua@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com,
	baolin.wang@linux.alibaba.com
Subject: Re: [PATCH v5 0/4] skip empty PUD subtrees during aging with a
 PUD-level Bloom filter
Message-ID: <awUuwi7Jwt0BQfJs@bogon>
References: <20261123085800.981256-1-baoquan.he@linux.dev>
 <awR-UsoEGg733fQA@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awR-UsoEGg733fQA@gremlin>
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 2F91440006
X-Stat-Signature: 3eoopder3xu49suoz9g4kh7f1q6anrud
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795501771-301371
X-HE-Meta: U2FsdGVkX1/Lk9fhYTy9s0Z8K92W+Xec4JLgb5BtiwOWwXYJhWGajHFMu9PquX5kHuEpHIL1e1H8evQqtycJwoAl/OmBzgGF/+sJjg3dPFnf03UJGEKFLWaDVrXkgAZPao+giHGKxx68A1H+VfjqxsAvKePXIwevloKkfwq1KddUq6EUTNqdGoUPs3aETAXHVDC3UkJ/cnaBX0vqJNJu6qvvZ+gk9Q3S32CPilocPh7N/ZLB9FmO4RF7PH2PezPnZaNwUtrjKiOgd5E/G5zNJ6imZMofxKkYo1fCj4zehKBu/TQ9cdrE4DZEmvLqrABrYLsgZxRQLOPqP5JjRjQ24dxSCDy3XdXi8Y+pSDkVkiPPmAM7cSWM4wRl/Fw02sLFyJzG1u5G6Cr4NqOFh7TvD+aXkBlW33Xvb9CtFASg3KSeiHBjfwfw3KpTLA/8D/rW7Pj0kiKs5F2WHbMNvD/fLWH4+njjziH7odBoNthZY0fRK+p3NFUGmMcAJapPtTPm6uE4hpgg2d+d3PVn0WE8kGCaTXVUSci4XA7g8b3gZmZkdNISoWCKx2B1jIc667dS6Kr3QiXNt891Zpqt5XlWPAgwgvUGhvU1XIcXWee7JURyIs0LSOFZLcRIESzKM9JVnZugm3OR1iMxC2MzmJaUvOYRuzONcINzgIw4TxrkPYzhQXSTP+DkacrH1ImOVrJYYCHv3mal5H+28CJW+3M8D+alKAW1Eu7fQZMI2+7HWtTaERiTWPpiioVo+NxIpwfDeN7jX8yJBakMe/QbF8dERM+Ro8MdMt1I6yI3wvMDPMGbvNajQdoX+z3eIbyFU/B+lXssdW68j8eloLQYL06Nxbt8H0P1OK5zFx0PxjLpy0fAh8r7ekkJ0choex3MUSFg39fj32opw4e5+r11uB2K/AKQKxE1imeSwZAFNXXe3PjCdSTtYRzk96ynj+j9KHiOcqtRY+ue+ZXnaJbtGJ2
 ZtvebaCj
 K5sYfvAn/eBC59LasdTYt9ADfba8ZAJ7z7xzC7Yjiq8VcRZsRpt+MRtN2j1ZFn317pkRRhW/nXI3wIBWrjXF9E0Pv4jB4+FF/xxh/6wsVBJmpTWpe1Uq08PDoTqOUiYx/GcAMH51YuoC7l6zfXycl/BrKcNg42Pbr72yonX9SW37FBEq12uJz8S9DHItjCLN5fqfsO6m71r5pI6YT7mgVAIRCGKq6p8koWuwb0nz1cJeBV+N4CSW13AESx3WqM1/mGviOm/98N+kDBS5pdX+mPoU3OV8UZV5PxfxwZCK8I9HCvIPPbtGO/obYQ4GIoaNAg6DXaZCKI5DxeAm+8ObNDVeJmBTZ3PbZbmwLn8Eyd51NNLAgnL9+efrPIxsH+jeZdj4RpSSo+s44XjC59NBy+kyXhMSwMY5pw+/emSugZiNL8hmNShb5lEc7xMGA8H9g22uRXYS3zmOSX//DvU84LTq514tKd7h4bb6OHzt2aipsfoX6GDSL/JhmukTZPTi6Uh57
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 at 05:57pm, Lorenzo Stoakes (ARM) wrote:
> (Got a script set up to detect things not cc'd now)
> 
> On Mon, Nov 23, 2026 at 04:57:56PM +0800, Baoquan He wrote:
> >  mm/rmap.c              |   5 +-
> 
> MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
> ...
> M:	Lorenzo Stoakes <ljs@kernel.org>
> 
> Please cc- me on rmap stuff, thanks ;)

Sure, will do next time. I should have used scripts/get_maintainer.pl to
collect mail address, but not copying from the old thread. Thanks for
reminding.


