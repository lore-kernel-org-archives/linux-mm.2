Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2582C79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C157D6B0093; Mon,  7 Sep 2026 22:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC63E6B0095; Mon,  7 Sep 2026 22:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC306B0096; Mon,  7 Sep 2026 22:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9209E6B0093
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:30:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 221051A0349
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:30:37 +0000 (UTC)
X-FDA: 85189016514.05.2BFB4FF
Received: from mta0.migadu.com (out-51.mta0.migadu.com [91.218.175.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0DA1840008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:30:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DuABJVcT;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.51 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788834635;
	b=UDcwXYaUpwufiuwsy80rmySvlmnYrKloeV9dOYJrXVgcKlm/IEvMdVMkh+Mx44n5IhR9xn
	loUudXDclwQy6Rvf0uk8YZ+hMZKmZw8vNsaS93vuO0n1hb0USOav5kFsq+G72/HYyNTF+q
	Ttap4quI1SGYLgm8gO3O6V3aqBv5mY4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DuABJVcT;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.51 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788834635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yl8MY9lg81eA/rxSCefkncUshxMCI8thmlW+1n8Nb48=;
	b=G09kA4h+sAUI/DRGTBga8qdTARs5nHItLKDQydwr0ktO7TPLSRXKP24e05Eo2SbjHpSf3h
	6JjaZDQuBKRCKwvNuMhb7ayexQo4Ty3juT3A31VS25+Rq+VpoJ9M0qmuS2bmuMEzt6qUHq
	oNY4vy9wpMvSvQXiW7YcFyONFiFGN3k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=z0r4/wgDlm7GGYqJBZ08afo0a+iAQ+9yytpL1uANVFE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788834633; v=1; x=1789439433;
 b=DuABJVcT3YDhXtDaPGcYhoZUite3GQp4Xz5SV0tCmimiJrJ3BXkU8BGYGu5k4RyKLvccg2Nt
 DAoAJr2ut4YrzNgEONOjPYOAShVxuLAawBM2/Jrs815G+mHLX5t1I3UxBs/KzqXewKgOSQAz9l2
 MFqPHWlJNP6RwNw9S/P3NRT0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 0f1918fe47817a4c;
	Tue, 08 Sep 2026 02:30:33 +0000
X-Mizu-Trace-ID: 0f1918fe47817a4c
X-Migadu-Flow: FLOW_OUT
Date: Tue, 8 Sep 2026 10:30:20 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
	david@kernel.org, mhocko@kernel.org, ljs@kernel.org,
	ridong.chen@linux.dev, hebaoquan@kylinos.cn, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mglru: clear the reference counter for rejected
 folios
Message-ID: <ap9zPPughaSlfXM2@fedora>
References: <8e4db9a298c5ea6ccb192e274caed5b96f0cf022.1788751143.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e4db9a298c5ea6ccb192e274caed5b96f0cf022.1788751143.git.baolin.wang@linux.alibaba.com>
X-Rspam-User: 
X-Stat-Signature: rddu99ny6qsipq3biafbyfr3z7wmhjiu
X-Rspamd-Queue-Id: 0DA1840008
X-Rspamd-Server: rspam06
X-HE-Tag: 1788834634-565476
X-HE-Meta: U2FsdGVkX1+QOjXc92B9wkTSfyRPTaTuPhHWHCBj2M1TslFp+cVCxu16f11XDanXgZiRSO9MfoasLFIiZH3Mo7QFed9P3YgOeuihQHJfWI/yeOXZLJgyZc8taHlRn+HdDV2+Lfco2Iz9P2Qgbwu1n8CJYpppITkj4Ne2PZgMPmtYFv7wami471leSdpucNQ3mMgD1TMVlu5IV005dpdjevv0j67YuNVFGdiLOpz+n+4UvceJkBaHnybyqTqqOuE0DJgZrCbmmhka/6cmT7b7tfGP0O2sNa49dPXfA54tH2aP5Gn1zfJ4Fzhe4yjUqElswIT3b7Pmn8bT39H8AcDMulYMcEuvBBfaZ8RNoL4RbUjE8j1gPexbaM+LcH7GORET60alnwEM9Ya+rvO9VhyIt3KNqsN2ET84clLDDlukya1mHXsBwJU9BHBVgm5hSIMkH53cshXmXReo7Rv8fId/3EAYddPd+pzfKFBvdLJXs1sPcZY/g1Dgr7Wrzr+Lyhh9rB38qn7xHRVVVIbpKQVmmVrNgxTSih5HH+XSAAX57mPk03SGZyNZVVMAX3lk54Rfuj8iPQM3K4XnZSYSRpl9xfZRR8CrhrYdPSdmsJR4fhIfOXXwSRcwv6/abYP9PMWwEKhRJf2AkRtRXF+NLzEbA0UbaKk9g2HcFWOWBWr7nFtrfke2+e7GGrUAWwXNgAVdo5au8f6gYAvuPnl07uLZH1ltOvXBUuwHRH0mH94eLIWNkTLq6r9u5jC8Ugu34hfaDBLh1kM1KpfawJQ2tCGcExTmHGIK/Gonuqr3oKMIHlgPNXqjFoC7QK6V/9RIDs8cs9YfISofJc4HBI6hNpSCdftjc2+wQD5QdWFvA02Vr0Q3EZqHBpTHhAfcouka3jQd/7YJh2HzNVlMYMIOuwLckl81w+VfWTvDQi99ymYbs5ibBBQ/pDTgn2Y2P1XLxOLaVJu+1r3us6oys81mAnK
 HDC+jkt9
 Pd2Pdo83FRKzy/JqacqiE92akro4zKeob3ZZOpAgwRGzTyb6jsCVGNBiD66+rkOQnBwr7sTpQbuOxDB8EYY/byf0g3JJCQRi7hCVCO9JZ/TVYMyCIxygcE/c4L9P+UrOu0bCFGCyDu7B+WnuqVBs4BqxoeG87mlOyxVjzj1pGcezX6I3eR590Y+M4b9ZC1wUqdKYRtzsOV+xYcwA5X7oWQgU43I4FsX1GzFrT5JkQYxupkSKv/nR8Flcl9BBJkEG7RqIwUH1j1dw/Ha8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baolin,

On 09/07/26 at 11:25am, Baolin Wang wrote:
......snip...
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 40d3f1b48a74..42c0a09938ab 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c

Well, this seems to be based on Andrew's mm-new branch. I usually track
mm-unstable branch. Maybe the subject should be marked as below?
[PATCH mm-new] mm: mglru: clear the reference counter for rejected

> @@ -5021,10 +5021,11 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  		}
>  
>  		/* don't add rejected folios to the oldest generation */
> -		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
> -			folio_set_lru_refs(folio, 0);
> +		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
>  			folio_set_active(folio);
> -		}
> +
> +		/* See the comments on LRU_REFS_FLAGS */
> +		folio_set_lru_refs(folio, 0);

This looks like a great catch, while the code change could bring issue.

Because move_folios_to_lru() relies on folios' flags to decide their new
generation. You just cleared it before move_folios_to_lru(). This is no
problem for rejected folios that are determined to be put into the
oldest generation. But for those rejected folios that are determined to
be promoted, this could be wrong. E.g currently gen window is 4, and a
folio is referenced, lru_gen_folio_seq() decides its new gen as 1, which
is the 2nd oldest generation. While folio_set_lru_refs(folio, 0) clear
referenced bit, this causes it being put into the oldest generation in
move_folios_to_lru(), this is not expected.

Thanks
Baoquan
>  	}
>  
>  	move_folios_to_lru(&list);
> -- 
> 2.47.3
> 
> 

