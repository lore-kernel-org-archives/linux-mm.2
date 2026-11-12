Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F442606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=As6qJfBH
Received: by kanga.kvack.org (Postfix)
	id EEB326B05BB; Thu, 12 Nov 2026 00:01:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2E16B05BC; Thu, 12 Nov 2026 00:01:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFFA16B05BD; Thu, 12 Nov 2026 00:01:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC3846B05BB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:01:17 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 54D11160464
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:01:17 +0000 (UTC)
X-FDA: 85425268194.29.C98DB6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B33974000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:01:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=As6qJfBH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794459675;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHMtwsXZN22EheGNlxc4OW2+q1ft1+YDDglDvmWZdfo=;
	b=7Rkbypz6lEOOveObLPvqoASS7bhMubHk+LELh4rHbaDxtrDlpVr+Pr5rZczLwgJtJ865Ve
	+XZt603lbCH9xaQ2qNHK3uh6alfMrkVMbTS6SuDL+1YpOlqs5cZDi2SbAJpPdQbUBBoeA1
	p0ExYV4PJc7d09RPiD133p//Bj+k+fk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=As6qJfBH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794459675;
	b=7XbpNqyicKvICKyh6U+Xt5cN8o/CRQIdCtQ1G+fAhOmKp3ZmwPSJsU9KamUDZzkFYjQmkG
	gWI508LvYe0CDWG3n0yeEcfhJsXtre9JzY/XP9Y+Fbre6ExbPRLsvMyvhKD2EA51nxf5zL
	kvCTo5SV6HFS43/rxYt55fDGoRbsziM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AAF645AA8;
	Thu, 12 Nov 2026 05:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D01C1F00A05;
	Thu, 12 Nov 2026 05:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794459674;
	bh=mHMtwsXZN22EheGNlxc4OW2+q1ft1+YDDglDvmWZdfo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=As6qJfBH3t7jKAI/ibp4pP2RMaTMcVZ7P5s+EU/tknNFxAnu+u0u1M5ErQF00tbzI
	 ocVRWz45r2PnVt9di39U6TZWiUnRCpLMINwhudbkuhxM/GLnoDHXO723+X6/kCfjHI
	 +wNabXkKtjnZrU4spZz90h4ZYW/W8qk1Whme/yxurLWlpVQyItF7dpwWHPDB2x+wfN
	 23qkyS5PwrGgnsNGuMRio72cBmi9YAJF+0ICbbnQGbgWXNS2A3i55jBLxBPXtKNglT
	 u93A8PFzBCdtuGfZazj7UY3DGFuhDyMbcaPBJjtiiFNBQD9sJfMk2VXh3RU1Iuk+aC
	 6ypLmhV212Zhw==
Message-ID: <sashiko-outbox-210423@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 15/16] mm/mglru: Make swappiness=1 file reclaim more
 aggressive
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, linux-mm@kvack.org, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261111232603.9934-16-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
 <20261111232603.9934-16-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 05:01:13 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B33974000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: cda86r1ooixnnqic9f394gc7jttn55yy
X-HE-Tag: 1794459675-148038
X-HE-Meta: U2FsdGVkX18qjnkPpDRnI4ctWgsITqKGApMnJgFBiQ5mVNMxCCHMa1wDnJ767ycnGIEZsQpKatOKg+mOdPI4WA4f18hi/yPJdgIzepwUjDF2BI6+963/WS1LlFZgrLEdwVpEkIIzxSLdQyXtJix6DCAAHNa5OV/MQC4JjTYl51BaloYd93AcVh8y/YupJiyDfzvE5Bn/BG8iP7X9Bz0E81AHFdfrxxlrU5COeJvu+k9SK5Qvt61SnVYS8rqnrVFwyN9mNzJlKqJJnJiWRcs87fqdqh2f3TpiVwhy2lJ5KuNoj3RfzCXrwT68nI1I7pnoCzo2x2MTWkCABqI1ZYjgywMZtKsZX9nWG8R3Rsdd3TVW747i5WtgQFMpgjlrQ+6CerDHXaVJqZxRUON7z1Qvx69krNJnDu5yl6btj18lE7TK3Rqmm8RsMFH/hT/ZhfdC0Q0kbBtfLHnhPwCDiUoCXEc9iE85Gjn7kzppTAowXF0XXmK5Ed337E8SJRnTolPmLyEQpI0dZyeYuriqtESfAMIdUZlUQX4O/c7TBscCNzzh653QPQ+/MBLQUql9ZZwC2VfeqilSJa5xGXNV3HJxtQVU+77utPkM3W5w3Jo+ND5W0A6nJ4HYWL3fEdYRCJnj5fjQ9uVSH6CdQ1BofJ3/2E8I3xHMqvNsj70Q3dtgmLQBnz1i3jW/gGpTttqcQHw3wyHUJFAJ4cEoqkFltn2DzEoyAPE9ng7Z010RA997fWlxXk8v09mhOlznidb+7a8qqqOOKsvBEaOZC7jbyasdwL45NY47T0BqqdfgfITFw+ASxc8NMUg+I88nCZWtCOKTzVXgMYgH+O5qb9LWLueyvbADN9LUvDKmboltPHPRLAWnFUb7QkWtBcSOEBXJ0htxk9YCc1sNDEOKo3mBV/QVrYbTS5BRITw6uob7IFJq4tatr1cbFDoL4mkIEJloFOb1J8Lz0y2IDJt1vdfI3jf
 DnQgSrYx
 +b29UShkI40LOrnXm4mc9ZVBf1HWEsyt2kCM5Yrg2+7MstMM07DHIB6AmI1NpXSrBO0eVoxgVcbzkm+zUf5nZvmbz4CTEtFGvVh6Gf1JuDcLmsDSSmgafkSUt5I8V+Yxdfm25v0eAM5njaPE89IUPtn6H+2h1f1tsSQd36oJxyhvF6y9eLyBW5Pe9Bv8TMEocQjL+mzELbXglhGiDZDX4PIBNKiO0hnB/I7cmeM90yo0oTY3rf549JnXL3UcMolJv6KJxhQJvzZgnsvfBfRabHwtNyyzlQMd9wUGSQkTB5NgfwrfAS+qQpsGDy0ASWMAJZXFeY9jLPGTJ4O7URHgE8k/0nehhV2chLfG6r52K+0Me39A6MUDNkXBmA5N9KAOcz832qt3eqmff/Yy/Fi/Khi/2EXRIwZsj4hIOX8X+FrGz9YHM+Ako+5z3WKimSkEPMLuatlld6yItku72GtXroBXQ0xh1PinrljWqXwMNN14smpe28O4yuwRsyEBGMdCskQtThFrk2HMP2XHmVvjScgGqP2OlHcjxLT5KdGt2bpHxssc2SVzTHEXiIk8bcvVDJ8fcpfLZKwppPxjY5ftt/FnemnE0bqqYOSMMJk32doakbMyt6gLn7o93CHnDpcFPx34wz1KIo9kxUCTUt6C9L2sVMAXumBNMxDLaDsLrAfCfr5Plx7tksH6ykK3+clGwwqIM20najZnw1i8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/mglru: missing sc.priority init for lru_gen_balance_scan()
  via debugfs
--

commit cf50aabb1ef5db31c58a09226fe4dbb55149d981
Author: Barry Song (Xiaomi) <baohua@kernel.org>

mm/mglru: Make swappiness=3D1 file reclaim more aggressive

This commit sets anon_factor to 0 in lru_gen_balance_scan() when swappiness
is 1 and sc->priority is above DEF_PRIORITY / 2, making file reclaim more
aggressive at normal reclaim priorities.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a92b14190d733..f36e9a379b62a 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4946,7 +4946,11 @@ static void lru_gen_balance_scan(struct lruvec *lr=
uvec, struct scan_control *sc,
>  	anon_weight =3D nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE] / size_bias;
>  	file_weight =3D nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
> =20
> -	anon_factor =3D (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_wei=
ght;
> +	if (swappiness =3D=3D MIN_SWAPPINESS + 1)
> +		anon_factor =3D sc->priority <=3D DEF_PRIORITY / 2 ?
> +			      refault_rate[LRU_GEN_FILE] * anon_weight : 0;
> +	else
> +		anon_factor =3D (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_we=
ight;

[Severity: Low]
Does the sc->priority <=3D DEF_PRIORITY / 2 check always evaluate to true w=
hen
lru_gen_balance_scan() is called from the debugfs eviction path
(lru_gen_seq_write() -> run_cmd() -> run_eviction())?

lru_gen_seq_write() allocates sc on the stack without initializing
.priority, so sc.priority is 0 and anon_factor is never zeroed out for
swappiness=3D1 during debugfs proactive eviction.  Should lru_gen_seq_write=
()
initialize .priority =3D DEF_PRIORITY in sc (as commit "mm/mglru: balance a=
non
and file scan budget by refault rate" noted in its commit message)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111232603.9934=
-1-baohua@kernel.org?part=3D15

