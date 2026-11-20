Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AFB460A2611
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 11:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bUfRfa6V
Received: by kanga.kvack.org (Postfix)
	id BC8D26B00EF; Fri, 20 Nov 2026 06:49:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2B8A6B05B0; Fri, 20 Nov 2026 06:49:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6596B05B1; Fri, 20 Nov 2026 06:49:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CECA6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:49:19 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1566DA8EDB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:49:19 +0000 (UTC)
X-FDA: 85455326838.10.D4F049D
Received: from mta1.migadu.com (out-74.mta1.migadu.com [95.215.58.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id EE15FA000B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:49:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bUfRfa6V;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.74 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795175357;
	b=cBz7cG6SZnEcyabv7XPxJfdRW2MVrhfht0gN4CuJuVj9CLtmUckGpYQ7NYcOA1C3JX4mks
	fYq5hlP7EsZ7VqVWE3fjvPUoh3WOl/R9CJa4VE/z03L19p9LBQbhcA77MwjzwxAiu+ByCI
	0YHvoScD1JuT3IfF+ODh/PI27fTysv0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795175357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nez0UXFsumo3+L/J9xcaupNVhnyClOnzleCniiAWq/4=;
	b=nsjJIi1dPOwBuyS4sMwHVD7NZNafULbNmm/iKEh6EbvsgL4a+zwpElbe+jehAIZ+UpoEC0
	mvDOqtP8aILL+HREUxFSVlndj+AnsBjMg5p/SOk13ea8romklyfo9l4MEeYqWVgdIU+gdR
	LFfoMals3JCo9NCyFBMVP6UFEq4bZps=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bUfRfa6V;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.74 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=leJ4NXueywkyUGIe5I/Fu1YvErAj1SAfTfxmCLv2MaM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795175355; v=1; x=1795780155;
 b=bUfRfa6V5yk2xNssa8St7J6F26hiMa7tDe56hOz7a0v/EFYznmNwCULoBz1n/X+BnLIpJf0V
 5T42Ez6EGt552ur9FDYr5taxUJMZ4TW4HdDWmij95lsgloqhz74crf7ztygbzI8IWbAnWTFYRSg
 4TPG49wup3meQ+BKKAx9Y8XM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7924206fe925bfd8;
	Fri, 20 Nov 2026 11:49:15 +0000
X-Mizu-Trace-ID: 7924206fe925bfd8
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] mm: shrinker: stop counting when the seq buffer overflows
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261120110538.3256962-1-wangxuewen_ky@163.com>
Date: Fri, 20 Nov 2026 19:48:54 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 akpm@linux-foundation.org,
 david@fromorbit.com,
 qi.zheng@linux.dev,
 roman.gushchin@linux.dev,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Xuewen Wang <wangxuewen@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <04D634C5-9E6D-4AB4-8863-63CAFFC60D8E@linux.dev>
References: <20261120110538.3256962-1-wangxuewen_ky@163.com>
To: Xuewen Wang <wangxuewen_ky@163.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EE15FA000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3uodou5tqosifq3pfenhprtzdw96ew8k
X-Rspam-User:
X-HE-Tag: 1795175356-583462
X-HE-Meta: U2FsdGVkX1+pnPJGU0JE0dt+nJSzmKdiRZXnDTeCOYySvTIUAjgDmmfiLMyxNFzpx9SJEoHfyGAbXbAfQhp9fSfk2o7hiBbvn883ZV2b0FvhpOEeTyL+7JSlul+rg7Eh/9gTHrX8QuvZGzBHkhZWuRj3+9yuVf+4RW1hFpEa4MZIfWvi/K21+Z2Kc1KBg+0Y9IREIy1pcVSpik5DoH2Np61n8UUH5Zm+iXMTDQ9cBKwiMfy0rDM3asIrq0YjebdBAcxuNzTLaTG2pqNPDQ81sMnMz8NCd3VOXkE2GgyfNqk+iDtmzUh4mqSI9aoWUYpOVDGDjKBJHrNPwiMmXShYjPkxgCP+6pz54JWgh42+DQ6vA+0JNccAzfKNA9gfoOBNqItl2Zi4/zZr/J7SHDxWEGbYnMNeh5oLS2W24FtG0Y4aGtrUXFF+v+T6k5HgVwtBJMa+ZQteOLsJN7IkZA+mFYVe/6NSn4YfEvXPc2pB2UGzBX/6TpRRQ9+403vIRInt03mmCdTBtNdkztpAJORhM+ocUgso8Qaqg0EymVjjMoOXXpCerjQAbGrDQbUFBCTek7UhyNujubt9VdWec6w/rIS0JNS5rxx/tsTFydBgynCLL6XjyPW5JTgVQD3QoEcAvOejLBFXmycyOeA56Pw4aBlcu7xIjYSmnxKbfvrGfAUw2bi1jBKuVlTmBs4/1ye+g39T/3t6pIPc7DU7IDuve90nmxYUAvthrDqHTC7KHPqvNHWSnf9iNssVB6MzGYRzLkRpf4vHayYq+deWLp7zGf/AykpdKSK+64pezPKPEESgvdaglIw1LfulDNR7zz9JajnkyPAwJsDawRbXRSX/jl042hEV5s4wEXi6As+yvVcGK9YfQucCQ62FhOkgkWcz6L2qPY9k/MlZ6ilDfCIU8j5R/mvboPHHidn+2ncLc/kKj5VJUCViHndrgC+/akzNFYxSaL5t7nlfbI9V85F
 lJXXTDsz
 agb5UfhcWLfPGCpyDzAa3BpV0cf6eu+PO9sc11BetYRLDWbfnBOZsiMsRp32wD1+lWNYoIO2kNVm0lOWhr0Etl5b7ji5frffpQMBrgb+ntcKlLpSWNjiOfjG6GFOrnMxSgeM5atMmeQ3wKQkN5KLu0jExP6CduWoQYQtspfQ5bIYF7IY8JguvM4tJWQqyksThwWIEulU5tT0AaIZBFS/2fa7Eq0aLaAHgt8SYEK8BoHgztOrLTfoOkHGLsPXPmZspFAqa3Jh/cfb+JenRE1Bu/4gxGLoPuZk5bHRxlTr8fH4+iXtyC5IJmbWbrxJQtu2GkgjPhy30CS69SFN71OcQfLo/j43KIZBsljX4dGflniZqijp6a/Cyi5ggmnqrM2XHiU5imcc6TJwPYyGBkfQc2TehCTsHNa4DS1kaBc1NC+vg3WjrEy3/5OK/gLUWsI74F/7POUF6xB4GAmwhmczI82TXm3FNyb595SU3e1vL25u45Mcuj8X8jih6oFrfRTSo4dal5CdoSbViw4By+6pG2NGndg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 20, 2026, at 19:05, Xuewen Wang <wangxuewen_ky@163.com> wrote:
> 
> From: Xuewen Wang <wangxuewen@kylinos.cn>
> 
> The shrinker debugfs count file uses single_open(), so all memcg rows
> belong to one seq_file record. When the buffer overflows, seq_file grows
> it and retries the entire record. Queries for subsequent memcgs in
> an overflowing pass cannot contribute to the final output.
> 
> Stop the traversal once seq_has_overflowed() is true, using the existing
> mem_cgroup_iter_break() path to release the current memcg reference.
> Leave the overflow state intact and return zero so seq_file can retry.
> 
> Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>

Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>



