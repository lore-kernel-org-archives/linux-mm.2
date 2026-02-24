Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DA78EFB7EF
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3686B0088; Tue, 24 Feb 2026 00:04:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91206B0089; Tue, 24 Feb 2026 00:04:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9CF16B008A; Tue, 24 Feb 2026 00:04:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B39606B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:04:16 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5B19E1C2FA
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:04:16 +0000 (UTC)
X-FDA: 84478158912.04.3A3B215
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3F0172000A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:04:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fpnezLB/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771909454; a=rsa-sha256;
	cv=none;
	b=udfacFYQx5Pcmtse3jm+6BqA3BotidFyZFAo+dFe7aEykoq4bAMPpElXDA0Q9lCmCD2/Bq
	wo/5iCHK2CD3QInwOy96KRXjs+l9JGEZWfw+R6njEimYjqecmvSBkdLONoSj9//isU5GlN
	gryEfFSc9PTK+PPd7X+bU0m4BVf00jE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fpnezLB/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771909454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EG8whWiscX+B+atpuuBm8IAdBUH2FBl3rjbNgVwiCQI=;
	b=NLUewcg3xF+o2FDjX1JCZDRw7UEI4qEN2aj704LExz0a7OM6wNZQl2I6UX3LOHPSb5i2KS
	2BtkveKVpy+CZbl6ZlgycnUlMOVaS8iPk3hmbPYHxMNWeCcD/B48EV4ThEwuk4UoBrENuq
	4v0jfrLb/GRM0tdbc7r9AmiW6RhZIc8=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771909450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EG8whWiscX+B+atpuuBm8IAdBUH2FBl3rjbNgVwiCQI=;
	b=fpnezLB/XGUs1JAM3+ddrRnJ9xrr9MqSXJr6joVN4tUkuXpMbxNU//ZvvhigHKYRtrvL3C
	k4tYbq8Okd0O3pirzfHrohzOikxBRrx87cyE8xysynb3fs70Eks5nxS3E1r9RTB0TMMPlf
	nrr2DS5vuEiB9Xd8kAYPJCHttdSbxkw=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH] mm/hugetlb_vmemmap: update outdated comment
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260224022840.1936-1-kexinsun@smail.nju.edu.cn>
Date: Tue, 24 Feb 2026 13:03:23 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 julia.lawall@inria.fr,
 xutong.ma@inria.fr,
 yunbolyu@smu.edu.sg,
 ratnadiraw@smu.edu.sg
Content-Transfer-Encoding: 7bit
Message-Id: <B36C46B9-28EF-44FF-A06B-2B736BFA9C64@linux.dev>
References: <20260224022840.1936-1-kexinsun@smail.nju.edu.cn>
To: kexinsun <kexinsun@smail.nju.edu.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3F0172000A
X-Stat-Signature: w8e3dcccwschsz999ucscdsoff6kos9k
X-HE-Tag: 1771909454-157804
X-HE-Meta: U2FsdGVkX19r0KTqeO9Xb5V5iwpQOAYm7IclPIaRXeQxSUjMdLDLKBQ+dOxKIGDRrsx/ZsPRiyVEGCGj2OxPHDWsacmWnguU60eYJp1AGrILb88Ho8qgGfUbPIIzkx8rcu5P3wT71ja3QTKvSUSHb6G2OWEsE+7KMPIMJ81+OztQ1RneScczHmZUlrTDQUZkYELLLwK6c5ySmKzD/hhtL5lk7O9Sejc7UnTGwsmb4BB5k+MPYys4pw5GYfd32Qq2etlH6yEG+pe2Ni+PKSUy6J1tv53S7Nv16Q0yiBp34DP8Oa8WQ2APRSoj4Ko0FsWlLVfalewl+TboAth2k/uDehTtcSge/u56jKZo1OlRFa3ENxVvKhGAtrV3b/p5DJE2BIXFGkw0t4Mm7lsWti1Rqkh6MDRBsRNDBviLUHr0DC6tgoEYQpSaoOTS2KZ8WMYRNuSXgcQRHGo+LHbXgzmFu/AWSj1HeZpjF5EpDENIbUgDbzp3x2vKGtsd4vy3P0aEkFpn6nT+r0d70LpKlooPY3ptGWEJT2x3CNd3/iZ5LLUyVNE2+hhU1sWVFWyn2fi5E5r2fzCNEeVAh4BVYFKxWQ3TQxv5G5he8bM+5WY410P2CRL5zJuILdgV+/JJHl5jOFIK3ssVWTANAGL2sZ4Ig6ONrYCEubqfV6ig6n0ewbgny/J6h8yNArvQFTP/D8ynABz8mSBFjsBr9Vuox0t+vSm3wlPQdrPSENisn897W1dFgHUK4lHBxCfTjX0Uva+z0Z8Huziczi50KsZq0rnQ2TQjhnnIXsYb9gFWOyjoQ1msagf2tv1BfOp0cJI+ID6rELZfWkvpVD0ZmTdsLgb4ERH0rNJi/KfQuej1z+aycyKYfAarVmFbJdudVIByYUD42BKe25oH9njfa8BFvd3Lh8MUSx+K4FszpWnzDHEPnOz0tC3nuUI1jSZVXKyTeX3JbEfmgdBVnqIQMxprXcX
 PMvTU5Mr
 q6DCfjgrL/Qas0+9Xjku/sQDFOm2Ly03c4n4JIs/9CzTuiLtOumidt85J2UUAFCQjqqLC08+IOgIfrqN2BytLYgqS4z0L4X7FGK0Vo3UIk6sH7Y7RZqu0FER/bGWc4tJF/UqtZlWRrA5x7AkKY3y+45dWAStVGna6LExA/I7TDHB51MUJiUYu4TTdV3Y03MyPxV2bZBULNeFelvpRbLdGTm/3m9nsVgpEbvRLnqf4oavm5sVe3tYk3DyezYCvJHJiw92VAHNEwQGE40u9cjX24ZET9IezOM/APyHF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Feb 24, 2026, at 10:28, kexinsun <kexinsun@smail.nju.edu.cn> wrote:
> 
> The function vmemmap_pte_range() was refactored into vmemmap_pte_entry()
> by commit fb93ed63345f ("mm: hugetlb_vmemmap: use walk_page_range_novma()
> to simplify the code"). Both functions share the key behavior that the
> reuse page is identified first before remapping begins. Update the
> comment accordingly.
> 
> Signed-off-by: kexinsun <kexinsun@smail.nju.edu.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.

