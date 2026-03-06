Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3BF4FCC076
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 22:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11E2B6B0005; Fri,  6 Mar 2026 17:54:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A19E6B0089; Fri,  6 Mar 2026 17:54:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEF4B6B008A; Fri,  6 Mar 2026 17:54:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E104C6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:54:38 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 761DB140708
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 22:54:38 +0000 (UTC)
X-FDA: 84517144236.13.55CF2A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id AE7A3180005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 22:54:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=THmqX8z0;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772837676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6O6R13x+JDBywDtrYjf+lvOJ36gh/XRQqgVF4nkWVTU=;
	b=s5gCbd4b3OUwofJ4mC6VNIHLeIF9X53Oo/k8mJf0o9WVHMclGklmgQK6iECovjhRCtsO1+
	HIfOpf9A0BHP8ki6c0wK/ouNox+mdfmlEjiHg/AmPgo4/DhKuaGTEIOK2G51YEYSbpIq+1
	49ut+Ibq6Ram9WytOI5P3Ux5hbRvds8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772837676; a=rsa-sha256;
	cv=none;
	b=DOcoiySs8VLkLKQJYlFFMf/pWMozuE6mYEXy2WiKbd8DuixCgARftp3VsmA0vScva5c5va
	Cbe3KrwePrEmIf/hQpuwPTkr9xtGQICnbJ43KLxVP0oGUt0fC4w/SLWfOlI1SzvQyWDRfc
	8oC+dw3vKv2FJslJqZrCp2bFF5qqPXs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=THmqX8z0;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE9A342ACB;
	Fri,  6 Mar 2026 22:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC2AC4CEF7;
	Fri,  6 Mar 2026 22:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772837675;
	bh=Crwot/d7WDbdCGkIKt73y4giJNElc+vyWtGZgHDnlsk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=THmqX8z0XY2vShT+oN+k58cZPc8qtCX0GKKF7CItaFCMczcEQnmyhAEyR63WWJa3Y
	 0ccps40WBnBLmgZej9zfz4VT5bbR4DP9fVPegZKaSP/9JBi2m+gbkm86fDMiZXrnF3
	 4J6/hsW8ztkD9j1w2rFlVglS8QyfK0ma6okLNDVQ=
Date: Fri, 6 Mar 2026 14:54:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Law <hlcj1234567@gmail.com>
Cc: Liam.Howlett@oracle.com, aliceryhl@google.com,
 andrewjballance@gmail.com, maple-tree@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Josh Law
 <objecting@objecting.org>
Subject: Re: [PATCH] lib/maple_tree: fix swapped arguments in
 mas_safe_pivot() call
Message-Id: <20260306145434.c069313fe809d94e64a07109@linux-foundation.org>
In-Reply-To: <b796ccaa-242d-4e4a-a9f5-b3a91f46f838@gmail.com>
References: <20260306200820.2819999-1-objecting@objecting.org>
	<20260306133321.4fa6c5a73067bd179a5e888e@linux-foundation.org>
	<b796ccaa-242d-4e4a-a9f5-b3a91f46f838@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AE7A3180005
X-Stat-Signature: j85kk9m9yfhz34t1icu4zc7ncoe9dp4x
X-Rspam-User: 
X-HE-Tag: 1772837676-706443
X-HE-Meta: U2FsdGVkX18lG1XEXeA57ZVH1K/zl+yQ7URYWNm55CaDNWKVPil920f4OJ4zYO/s7pSmGEAqZoJOHXu5zi6wsDdEWrfgOAhKaOj92KKxOoAintEVifMKCM1OIruhhZE3apqntnYwEogPpPE31A46ICaRmV2RDs9HvStZuhyX3D+DQKoGb97y8iA1EGuOspUKbkCG0xVHJLSXb0vudQtm5Qi5ch3RjaBrFWiqsZKegikIh/We4dpKSQoiY52Q8qOBNcetFCOEe93H5Hfn8twj1QF07YhEFwYY/9wVT9eS8yC692oza0KzshTDWePnS3ZopbbY0z9AORHo8Z0hLr7k++Sej3uWRnav3Wt17XWseKgsTQabxygQ34CGVNgMayUIa0Lu80ZQ5MRALAA/FDHwheTZkX4yXfS8mcXdWYkmE697nMLcWZoiJiFIEennOh+MfjMPeOX0p6pwa9j8IMPqHHYZbHXSlha8Uv3N+ca4vqhqeoh+XX7zH6x34wPfFinlwMwAETdVVnm+fijhilZVS6Aeos12RWufHsDZOHZ/Nf8r7XEO8W/+bw/pYTOWSquHcOabc5uN8n7izmxcDfhh7qDPOVspVM13/hJL+OQNVCMTQgPsb1tDSsW1RLO3rcs8sQmHK1JK05nkYD3uDo0jahGDxU5ISnL1giKijt2L4Y4J5bKEAiQnIKo/hS9ljfAuoVKbdVMKMd0TDJKL835hEK25wDgHvZXTZHqLUaoMaH1DCfimm0B/FoXAyWZs7PkESf7lZpL2VAFYiU/QkYma90VZkoWkupEVEavJxVk+7Quj3fIcZBmmZ0JslkgSrsPp5PWIDLt7vl9oiavbytU0quxVM8AuZ4iSD/74F/7/w17K3jJ0vj7i6eci0GYRXzoTFcekEsTzGLNIA4JQrujirhSR8dzH3yavsBOfRiZLg9o9SjslOJ47pYdETtEQooYdboshE9V3Cu5REtHM0lh
 3MuRJ2dI
 Xqqa9UxGhOas6Bi5E9EDGiTtpwMfbxthEXCmaEl7n2hIUI0RstBynWcoZOeJKkkj9G67Ii/lpGmElCy5cp5l7Mj0wrRza639D3LJMKdprezBaSbfBcGt75AAygDBqtni/qQA08f6psdoLVS9JivQE+OVA+irdZ+POfhDXbCCzJVLteM/7MeORPm7qa1gbQBrxCV2wI96ZAo3d0+QNDZfwHDyXtmrlghSjWBguYAWJQ1AO3LiMUjviFMJBuDDdUe/Rk6JjziMhTSIYlq+Z99lHR27Ck1yiU6VGRheQj5tixjHyVCSDc3e5ntBN027PM7oTnMLgLAEZTVm0JfnNRHes6WeNeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 6 Mar 2026 22:11:54 +0000 Josh Law <hlcj1234567@gmail.com> wrote:

> >> --- a/lib/maple_tree.c
> >> +++ b/lib/maple_tree.c
> >> @@ -3279,7 +3279,7 @@ static inline void mas_extend_spanning_null(stru=
ct ma_wr_state *l_wr_mas,
> >> =A0=A0=A0=A0=A0=A0=A0 (r_mas->last < r_mas->max) &&
> >> =A0=A0=A0=A0=A0=A0=A0 !mas_slot_locked(r_mas, r_wr_mas->slots, r_mas->=
offset + 1)) {
> >> =A0=A0=A0=A0=A0=A0=A0 r_mas->last =3D mas_safe_pivot(r_mas, r_wr_mas->=
pivots,
> >> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 r_wr_mas->type, r_mas->offset + 1);
> >> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 r_mas->offset + 1, r_wr_mas->type);
> >> =A0=A0=A0=A0=A0=A0=A0 r_mas->offset++;
> >> =A0=A0=A0 }
> >
> > Whoops.=A0 How come nobody has noticed after 4+ years?
> >
> > I'll add
> >
> > =A0=A0=A0 Fixes: 54a611b60590 ("Maple Tree: add new data structure")
> >
> > and maybe cc:stable if we have a reason to do so.
>=20
> Hi Andrew, on thought, I'd like to add Cc: stable@vger.kernel.org to this.
> Even though it's been 4 years, a swapped argument in a core data structur=
e like Maple Tree is a silent bug that could cause rare corruption. Better =
to defuse it in the LTS kernels.

Seems appropriate.  But not as a hotfix, given the 3+ year thing.

I was hoping to hear some thoughts on why this has proven to be so benign. =
=20

