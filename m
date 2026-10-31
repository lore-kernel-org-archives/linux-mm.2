Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DD7D606A322
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 00:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=j6XhbBjg
Received: by kanga.kvack.org (Postfix)
	id 0B6926B05B6; Fri, 30 Oct 2026 20:45:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069916B05B7; Fri, 30 Oct 2026 20:45:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC3AA6B05B8; Fri, 30 Oct 2026 20:45:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA93F6B05B6
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:45:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5EC2BC0850
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:45:56 +0000 (UTC)
X-FDA: 85381079112.15.DA7421D
Received: from mta0.migadu.com (out-126.mta0.migadu.com [91.218.175.126])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4D01220002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:45:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j6XhbBjg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.126 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793407554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N347scaieRKnfZAxwyIlV4lZkQNr3Gsi349x5S8E61Q=;
	b=1pcns9SPG1bi5yUYhfMoJybqWzgikunh5qNNHlSPtV7Zn+5zEN0Qx6y0BKGI0dPsKgvK6x
	883oc+yfNTg0l4ceiUbH7OanawOkBYAsLGHhFQZcR8j9CWxatWznDdtCbZc51jFzU4twJb
	UzWKUCv3Dos8WcLxv6q5TozhIAy7/wY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j6XhbBjg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.126 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793407554;
	b=qJUhVNXuQF9pKYiHFr43dW9DWZKeh+kQ9oHeokISfLbkYdJiTRs89JsIka4H0VI9Wpi4vZ
	aVLWy26gXmnJDwcS0LUasGDkhSCILX8VJuscxanXwUhFselp3JSquL8ivQTVNdcNZF/6V9
	rZ7SJNiinfaB0kuh0RKVjAtP7Tw0F7k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qzhoW8hkYHWNhkLmB736TkASUeOo7ZLmpURHWLLr858=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793407553; v=1; x=1794012352;
 b=j6XhbBjgJNbD6upXqbFwJ6CDx13X4cfER3mBEBan53in/Cp7e8tnocb12U27v6AGv4ozE9cL
 80TgE4/+Evo9Q3RaeADQ+JKR+z68BcSGM3n6RVGD5Le4Awn7K8X8vql3T542dWOVqFas1YcN9+4
 riwCt1P8eY1PDxgleOfRawpY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 59289533df5a5a2f;
	Sat, 31 Oct 2026 00:45:52 +0000
X-Mizu-Trace-ID: 59289533df5a5a2f
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 1/5] memcg: move memory.high enforcement out of
 try_charge_memcg()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261030205418.341214-2-shakeel.butt@linux.dev>
Date: Sat, 31 Oct 2026 08:45:32 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Tejun Heo <tj@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Meta kernel team <kernel-team@meta.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Michal Hocko <mhocko@suse.com>
Content-Transfer-Encoding: 7bit
Message-Id: <F94627B5-26E7-4F9F-ADAD-395026632C45@linux.dev>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
 <20261030205418.341214-2-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4D01220002
X-Stat-Signature: hm1xngm8kakhn8f4txhxug3yq1giu4nh
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793407555-711045
X-HE-Meta: U2FsdGVkX19qWqjbDlEPntqoNvZWigN60vpsqp9V8Vo6UA4Fz0XwFYwQZpCtOZOGFYwi1UAtcDIc/sqsrGSGgZK+xn+JyamTdB/316so1Hsg3WS2JuMxpg+GBYkTrSrNb6oH+O6qb0qdq5GHGqYuFC5XPi0Y1u7n+sjprOB0CJYUvtYagRPd9QeUmlzk/znKuOsgTBt2rSTXqFAb2gQ/BJRV+AMPWxLsOpNp8Id4d//XFg4pWPVudvt1tcZCW1jzGV2Rm+DAd8bXhKyLIW6IUlRNOoxQsu2ShAo4RejbsipKLO/rPTvKcWIcchkaTaVbI0KDujRf6x2IL+1IMSBBY6MzrmJPx/AiI9w5PU97mOl2GdievBqXPP3vP9snWMld4H0Sp2pMyy/OrGXB/iA4ZOO1AeNNBIVDp9v1tPt9nWQnp1t5nXeVv9nVH51BYMeCbfru2WweANkss2JpcM1Xx55oU3G0Jv/8B2ea4ttuxQaI0EIWl4tRQeIDfzLgT0jg06xTxc0C5cjEpD5uOzYXiihr10FXm99X9ySeqJG1XwBQZY10j5gbdBtveuEV+iNGRV8HiRXYBL6g4KMRdRYDWwtlmDgFSiSTm70JIkb2ZDXK5nzD4oeojArH+lwpv+iiQM6n0InGXep9AIZBagRaeaP/v2YJoxhNcruXMbDP4hlzcmTb9Wfi67XnVAHNDJVnDv18qnkbtNH98pnTd1Ntief9dqwHtQWTFMI4La3MVFZD7XRdo9VNgHT3T4T2clrGpB2yWCVFdlyAVXq5WHfk3lCNBy4I7lCu/86B8IlDUzPif+d7Tv2Oue8vbwBk+eesf8GoZ0otgIl7srYNrs/vbtfnfsmbG1SwxdZ2ufD2h/E8tVmaMxMhDT5d6bGPYGpJZuwurqbywC3w6P0CJbDnggWVydI4t20nglr5xfj+vFXybuRZM+qWHgXkkhzxFdLj/99nD1u/Z9cg7Hb3cfG
 bz/KOB8/
 PvDhDUHF+NVu2WFD0VAIStcVl1d+23ootlyM4Wc1D0KMQkOL/Zuz9ziLVhmKLlPO232QjDSksQjV8zPg9bmypj1ESVNgHB3kRRzJht50fnvm5WAERDnf4D91xl5afrG5rTNamkvfnBC4ET1VWWIETT7FZdd4+ogZqx/cAkWCxtZI704f5FTeJ8QtYcK1gc3NkbBHEzKPivJvtVKEil/na9777beFhl0rsrNs4BDPWtipmH+/ZjheXvIKXlHZG2QxQ9VnaLZu3VbJcTghDtGjWbbJEHt23qxGhMIhDcNE+N+6poY74XByy8MgucKua/gq6Hfeuc4Keg73snragQDzY/p0DFoPq85Fi/KBLk1NGyoKfzv/Zuozm110wg/YtPryE+w95sWbqLzihIdc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 31, 2026, at 04:54, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> try_charge_memcg() does a lot. It charges the page counters, reclaims
> when a limit is hit, may call the OOM killer, and at the end it checks
> and enforces memory.high. Move the memory.high part into a new function,
> memcg_enforce_high(), so that try_charge_memcg() is shorter and the
> memory.high code is easier to read and change.
> 
> The code and its comments move as they are. The only difference is that
> the new function gets allow_spinning from gfp_mask itself.
> 
> No functional change.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
> Acked-by: Michal Hocko <mhocko@suse.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


