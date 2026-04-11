Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E736CF364CD
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 07:01:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373FC6B0089; Sat, 11 Apr 2026 03:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 325426B008A; Sat, 11 Apr 2026 03:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23B416B0092; Sat, 11 Apr 2026 03:01:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E1046B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 03:01:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 60C391A0784
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 07:01:50 +0000 (UTC)
X-FDA: 84645379980.07.7D8E467
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf03.hostedemail.com (Postfix) with ESMTP id CE4992000B
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 07:01:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="SL4hN7/F";
	spf=pass (imf03.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775890908; a=rsa-sha256;
	cv=none;
	b=Qmx/qwpXCFokuqrvSabzzkl17td6UVB5APoIUZGxBB1IxHDaFX8nI3/YoxLwR91BzmubKO
	88eNUR3eo1gHWkEmDWT+cfLfEA1skQVP+PGxYB+sNrRklc7uiLuctKGJ6FPOXAPvXBYV5U
	TpWrpGfHaFdjHrBEvYEr1aSTvSm4g1E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775890908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=itovhA6jaJUGrsujq0MFEzcnIyUQJDZTf5W+YFGrBdQ=;
	b=qJcsOEr3a8iNeUnxkTdMdf23BKua4ElBkB8UYfAUPtF7C3uiGU1KLSoLYgtXmu309s670c
	AYDpj32y6q5nwoftU1zikyeljKTYpaLJeaqnR4N5Zu29iIS4c54Jca5DAz7begUZR2uC2f
	+Vj5+GaqFzTVDrABGnRxbwPtAbfyzUo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="SL4hN7/F";
	spf=pass (imf03.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775890904; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=itovhA6jaJUGrsujq0MFEzcnIyUQJDZTf5W+YFGrBdQ=;
	b=SL4hN7/Fe5n0wl2+0ErwFsZECsjHPPGXlpa5RXbMLOgS2/0pDgWvjZWlo4mWRjqLVHTcndrfpRgHhpa95MYEanhdAszq7yfho3XbANOSz35q/88vgbrc79hIqBrhgedm4bk1SwM9Qslhx7aaKVtB6EUuDGgrSlc2ssPtft5oVbc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X0n8XRA_1775890903;
Received: from 30.74.144.103(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X0n8XRA_1775890903 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 11 Apr 2026 15:01:43 +0800
Message-ID: <d6b2eb4b-f612-44e4-adcb-2bb4a332c8ea@linux.alibaba.com>
Date: Sat, 11 Apr 2026 15:01:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/10] mm: replace thp_disabled_by_hw() with
 pgtable_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1775679721.git.luizcap@redhat.com>
 <9432a2398caef7261ca44355fb7b786bb20bc15e.1775679721.git.luizcap@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <9432a2398caef7261ca44355fb7b786bb20bc15e.1775679721.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CE4992000B
X-Stat-Signature: 3dtpgadqd9ifiigsuz77qdimcjy9usgh
X-HE-Tag: 1775890907-412043
X-HE-Meta: U2FsdGVkX19n0wkPoSKJv4YsoyuaDoC87HMccCeDkyrHjNTgfc9IUQYElT9PApufOWcudPUkNdAOJhVDsU/Gk3PWIO4z3yLMbUS23k1HgNUYP5g/y2sSLSWOBdRYvXWYWTVdaVNli5eucNQXQ9Hyyrf/7PP0BMAekA4SsJAu3gwaaaJ/3J26Y6O0EbvqrX9XA+Zh6/IZMNexXoVE7oxnUoXJ8y3LXyCVeGx/PZet8lS95WfoJ08x4u3jvPkEBGfeOfpGJwkbSd7MGXf2Cx9qIWPKic+ozaqUoQOKeQAurjezj7jgT/K19QQ5/a+ymlY09CE+paRE4j6twGOQ1PEemERqPBJabOflGdVis9XA9y5bRIyMBaOTLi7Eu2CuNZf+tBxTAZHvIJihzqJmhSIDE0YAMvGwvOsucAKwM/Qb088t8LrF1nCsGOB04Vjo2bMAvCEdPZa0cskSfZ4yzjE66fpJ77k41+/HbNwxL/YuOrJO4csa+RGAzMIRmnDj2KVoEWR+oz1TYPqawr87UXWV5DJn8qVEYtRf6NjYP+tMTo+yfT9o8hfAtrL/mkmCfLs9GTQ4wrVjqsOD0yDeAgkgUA49+Hut0Ex+/II90b7z996Yyc8d5ePqWM4T/ZnwGVPt7pKgIJ7RweDcSpXTFpWP2MiuVQhDhk4tEk9luV7+duGpF8WgylZyw17Zd8kjFNs533ffrRSRcAvB3gEyFAFdYB/RHuIZzkJMdUQTDGZYd42MyeesgopFczpEoK2FDaW7J5jWykq6+SZRNG+9TsPxzI6ZxQZ1z/EbZ3nhX+aJmXW1SvfHBU7i3wPA/S7ATe/4E0hIPN5FNeoKxGqbmI8nHtkmzQtt0soCBUaJie3RPvB8rFD71x3ydAfnem6vXITvLiKXeNYizClGV5ggZhMg2eOKyf3OKrx0tAip9iN4v3x1gGfGtGT7duApqCSB/w4GRk0vm3URRKLQJN6p/QF
 wn1TC9hr
 Q89myRFMsZzq3nbo0NQ8q0+ceJw4AHlFKWQ17YK9OM6xxzn2gm6stxYo1kYkwnKTjOyNfe6v8xlRkFMtjlgVYg+WEZNXaDJXU0ayTRPJPvftXwvY2LuKNmQMMKLefCHCmRQWiwQKMKH+fxH9vj2CLmzuGRsdweQJnYQeZAtGCoQVTZqLv2ZTYdHp0LS0gNCXUEVUXZixrl/ENCwmyjAMXy12hgvOWcskjWfEt0Ckg5ATUjqStsmfoWI/j/yhV7mzMIVE69oS3qU23vNkCcjmolRBqg1qcdsUulvRvq4hgtLNOlENA2x21eNl1JqYuoTbyQfBsKkEe2gNyoBlFDoRcruKRC3IhH1hljostFrCiSqPJZZSbfFaAz/X4/QAmzs8gyDzy/BFG5hRrMZzA8otNbcY1Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/9/26 4:23 AM, Luiz Capitulino wrote:
> Despite its name, thp_disabled_by_hw() just checks whether the
> architecture supports PMD-sized pages. It returns true when
> TRANSPARENT_HUGEPAGE_UNSUPPORTED is set in transparent_hugepage_flags,
> this only occurs if the architecture implements arch_has_pmd_leaves()
> and that function returns false.
> 
> Since pgtable_has_pmd_leaves() provides the same semantics, use it
> instead.
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

