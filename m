Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD6BF606A33E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 16:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=I7iVn24v;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=pR36kdmG
Received: by kanga.kvack.org (Postfix)
	id C36B96B05B4; Mon, 26 Oct 2026 12:37:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0D506B05B5; Mon, 26 Oct 2026 12:37:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC7E6B05B6; Mon, 26 Oct 2026 12:37:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 88EC16B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:37:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04452A081A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:37:07 +0000 (UTC)
X-FDA: 85365332136.22.5A1D6C0
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf16.hostedemail.com (Postfix) with ESMTP id E1FA0180002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:37:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="I 7iVn24";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=pR36kdmG;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793032625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M788Xk3PB4yK/5EzK9J0RWEJS4zUyVPbx3h+aJGAnIE=;
	b=wuK6uaSzE/XE8f05NHoG/ULieU3wlkxdtgC1zqaHkLNsKOef2MWveljAkVzpTCKOa7R3ia
	fB6R9uuW1jWKo/Tyupyv+MnkTLqburptMN5lF+icW5eZSrpuDsi1IG8/xuiXmAHFG3qzHR
	46t1YxWRh7bOgFS23OcSwz4slrKLONg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793032625;
	b=LpEfnXWXrqJcR8OM7js04SolQgMc/X00tu3Jvb2JUsAxSOG+0iYgb04sXcqwoEattRnTmb
	Nm0zMwXLA7T9zhlsnImcBgWlDCD0UkB3vemjL/DdDbUXqIIb2GCNMcs4LBhjOB2mSH304P
	y2jskp67azAr8K2DA0eHgmOSiiiXT8M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="I 7iVn24";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=pR36kdmG;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 6E275138028B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:37:05 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 26 Oct 2026 12:37:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1793032624; x=
	1793039824; bh=M788Xk3PB4yK/5EzK9J0RWEJS4zUyVPbx3h+aJGAnIE=; b=I
	7iVn24vfD41AJXP0/BUpnXd1RvWqMCB3FN3N+xkeoOyTcWM8oXGZQcV4ZzOtbt5A
	gZMERr//QEIClHkEEpDk0Pg64ptxuKkMUVqDmMNkfOY/HTNsqRFlpzNtAF7Lv9AN
	kdb0x0yGuYutcx/Vn+YzFcCqrNH8y5M6XznsHneblgFSNwbupCCjmKQEgw08H6E1
	gpKtxTgOTxETLXIQqrbEDJE97FWt29gHIfWfqRmJ+YPlDGTgePqdTeiFpBANMaH+
	H2qCZQP9SyTVv+3mnuo/wa2yuS4Dp34BJGZNOZmjPxntK6moKt8P5swXI0h49nsw
	m3Q5MLYnBxUTnqLdENlfw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793032624; x=1793039824; bh=M788Xk3PB4yK/5EzK9J0RWEJS4zUyVPbx3h
	+aJGAnIE=; b=pR36kdmGlxLIaC6DYbG+KyTIgggdBXwH6daDGu7VElTmmotgqbC
	8ogM0UYCjAD+ZstXpYuq8+yxKPYk5JQzyuB0hNvLMdl9ZSwwI1wPT4pBqpsePr7B
	OXIlziLLErhBjE+5qXwA0AtwbW9xJtjeVm+o3l3sfQYI4RgUIJ0+1gA+GksG58V0
	LV8TURjx1ItDcsmN9UjVw7HVAZOBHKLIPVe1sHACRb64jBNZnOf932CuhMybN0Vk
	2QlgU+Luu4iO+sBjwNbvxXzF5sj1AeeZaKBYzbpa6GmiXJNeEe7cYfWF6j5YCzCp
	f1cQdkU097cgIYje2AFWpk6XkAbgXJwb8Ow==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793032624; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:YmUSdNOHJw89+jmfeoGor/cC3xbTB1UrnghNvOHdvir/MKh
	sXRHYnosizXpGk5SjNq4+bCsWUSl/hQfWoAnfjvPnl1sHL19UYZIDcRQ+I5BllE5
	XWRYRCoT+UYEiO0BbptyUpmonhAiKvFHIhqWf2p2HJqBGes84onyPoqWeF1rxyFT
	hqM285n/VXUv3OMJiUa0gb2O/a/PBiH6BGKPW8NUMWDwEkggsgUkK7Xj1o9gaQRl
	TP6mDweEHj7kgqQbgXcZ/bmICpRbTnGV0twDXw6vGTc6UWYY++MlE2RxlW3HLhpy
	/P9k+2xco6Me4ap1rmUs97OndgxE3hjVBogx/Cg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:8u+ljPUjNWAURUdkRgzi4ZvInM4ZjrblckocDAlPWYs=:ogWzqwUh+YwSKRYnV6B3XtBbR1nMJ/BN+dvXfmC+6os=;
X-ME-Sender: <xms:rYHfanQGM7Mzhl34gLG4et5x43xQbH93vi1lSKzIqoV4zVMr1CohPw>
    <xme:rYHfavdH9l4s4BXJXSOIMdqdKdPjYcjzpTdUBCyw8prJVvZ0DpDN6_EyT1qeodBSL
    5Na6TCoFDJK0ASgwnqAV_xfv4y4pUSGwsDTFs0POBX6FUttMu6C0QA>
X-ME-Received: <xmr:rYHfanBcBL_kqsp1g79Jds2IGWxkQfu3HfcDa6UIv7QZQE0CYV5rzHNYRCM>
X-ME-Proxy-Cause: dmFkZTF85toFBxe00b6Lht/0YohMnaHZ+kOqQSwWlzVS3n6NaDaTp+3L55+ckhhLGOFqI/
    gROlgw7KartkRyVU/1mD5EUn7ZFgUh5++lX4Rxl7IqqhV/09tBN8FrMq0XcJNcfIXM/fcs
    jAN3rc34tCVSgiB8+XaigqTvbo0SI8kdb6oHLKuBaaC5tk1Hc04ITbUeokPS7u+7cdi2D8
    8UVAypEv3LhlCg+OpfyjybH+wj3IC6vQs1RMPTTrUTwx8MsPvH0qQzqCcCGcBOeLJ7pYW5
    z57AotUZstf5//pTxw0fi+3Mab6IqWyQVB4QmZR9HHsUERQ/jOfPhnTRd1nMTKX/WyXFZE
    OXulAZaWcFzCXx+U6qd1iF80o1UBPD6T8nnLTxxx1EtSp+URplR05o6ShthzUEiNykbNFQ
    OEgBGu8LFPSR8k0wiFDaXMo+rGCqQeLRyj9UpmcfV1/DtePTZ3rAPENl1QZsy9u+YZMCHB
    yGC+vn7MvXAWw3lGX8X3mGl6bIf7ga0bPO7BN52iaOodqOfajOmX3isATAt+Xtje/ZUDV7
    UWYj+S1udZApPfGvPyYauzCGzTabSWb/1SPUrYrD+YOry4Kti1y2QGCx2CB/7tHJ22olLk
    KDBtj+h15jxdS848WxIIPWMXHIcl+GSCel774lZjsjdGaU6R/ZeRAUoSnngw
X-ME-Proxy: <xmx:rYHfanoZLa6oRb6cRI6obhzerCoRdv_bYmeHbvMsO4WKGgndTFQq9Q>
    <xmx:roHfakT-aMoPYOh0yt5Uk-dAP1XSLv4GCYHVkDOx8Z10KU4D_IjiZg>
    <xmx:roHfaocsEWSHJDeQ_WQKhF0iEo-7Sxb_WLiOOG9vcFaStUfrR78Z_A>
    <xmx:roHfamSUcwl4ir6MPwBZcQlXpUgfDHbsh27wR2SyIo8Y3TDzNUsXmQ>
    <xmx:sIHfaqfPuip1Z6RnZ2x6Boa_jaULUh_WvfP5KJngoUZHr7tTOpKu5-ds>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 12:37:01 -0400 (EDT)
Date: Mon, 26 Oct 2026 16:36:59 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>, 
	Carlos Maiolino <cmaiolino@redhat.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Stevens <stevensd@chromium.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 08/16] mm/shmem: stop retrying folios that cannot be split
Message-ID: <at-AmbZyqUnGAJkI@thinkstation>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-8-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-fixes_shmem-v1-8-703206d5fa0c@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E1FA0180002
X-Stat-Signature: cqjabpcmky97hn7gt6rm3doaut4ihqaa
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793032625-513406
X-HE-Meta: U2FsdGVkX1+U1TSuK7czOIkBw+8brgeVgH6Oxrk+SITaEzPfNssL+qayE6uiYt62cp5oV3Jlew9dnCfGTi3j5pdYpHRRjGg6KUM7W1XxHsZhN/ARul5JtIaloifUs9/6imis1xcQu2jwGr6ZQta5PZp1u9l7jU9d8leSGZEcxXVT0bSxGKZyR5xb6dmsN46oOYedM99MVC04lIZ9k6cAx9yr+EdcDl6bUIue5BCEXLjZX1IpJd2t1HrCLJdD9m/OkaM7ix/k3jP/seJV9VtqLMA+wMMZ89MmMm/cHmU1lVaSEjxFmOqbIT8TS5Yny90e5bUiwdlTReDzH9xpJvFW53mAuEooLrYLAMaV2j20moSPu+NsoOFES5BY9L5k2FPY+nxeQwv96yCSOqQEXEJqaAFnN69dB0qExF34nTFA8QkvRgsQGtBGZ/xIPv6AqFG7yoqN7l409RwdrmUSX7tQ2Yhl4XW3tAJlNf+gDRY6pw9F0w4csf6plA6jD3ONYHnpgBcMJXkMQEA6PPlD+/qqNrea/T1T8edZJmq5dJkCl9xMZYjEfdH6mlIlBay84zFdLIjrhPnNfrjnlFaIQUvwM7E0n0ypU5AyEORyMtyBNAaYay7aNYhDR1ouTXXjfNV1SRWnBcI1A59Yv7dtMdNMisBiNm1URY8kvPRlg7VZ6Rbb9WZWzUCQ5bYC7HH/dyNWlod0GubRvgPbnYkNxGhrbfn5QO3ZZom1IB0rkV2bJqbcHbCVA7shU1Qsjg2LX0ZDWhS1b2LOm45Qxi4fVYubAyPQTmrmbg7UqJLajkl10hMP8zXzzGZhyn0L6Qsh1V8b/kxLXX1cibs3Hacn/Nq66/tgnU3TJFTVVm9ojpXS+1qeBx5MIVzUlO2s76Ux96rv25esVcheBC6z8MflEKAsMNMoyBQvIB8dURDh39N1xgumjFnLYDpUyEZXp5dM0OccmL+mEvh/r/hObcm8UdI
 s1SGymjK
 Ej0Apra6x14jg4mITvesetNasBx1xUcG+lAe/8ZUpO1z2sJf+OO+S2Saqus05BbzteGf4er6ddgeHYe9UFC43Q585LyomxUsCy8hp7DF6DgTMEU2dn6AGNFFhhQ4HjupVIDoPTe6VWNPNPS1NvbapXfxgyotbwm7sfKp0oKJY6j2FMMzUEbcTW5QbQB8s0mgPNis0SnjyFTKJMiJspt2dXNLnZpeni9ISv41PMXPpo9RTRngVdQQ/hMQVEsvze60+sJrJ1SgkQwRVRQqzFNWOgfjESpUHONadRembrjQ8VrAjqSjMacy8uq25gYNIQsNLyTiEIbahDis2GCBfo+5M6C+BgSsK9U+jSZ6HsdGGXaxbc+EoXObErGbL4QtxCjAeKVlcszQtTubaiWn2mDKUqdQi304TDpm+cYbS2ISajgdkFp3UFxWHZqk6dfrWgis7kTx54zd14RRb5qCwiQACsFgU7i2JTP6C9LHqoC+xGYDkI8If2ruaHIrcvP/72cpneWZjUKxxv7Osh4ikKXZObOn9bqlhepv9d1HcrC/9VzTmIk0Je6CMP8mQp/nx1ZMidEL8hE64zKeYxzznGp8f3XUHc/nxhcLqXFkizhgIEqWa8Sk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:40:41AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> A fault or collapse can insert a large folio crossing EOF after
> shmem_undo_range() has handled the boundary folios. If splitting that
> folio fails, truncate_inode_partial_folio() retains it when it is dirty.
> The final scan then repeatedly finds it because it restarts from an
> unchanged start.
> 
> Truncation keeps the inode lock and ignores fatal signals while looping.
> A concurrent unlink() can then block other directory operations while
> holding the directory lock and waiting for the file's lock.
> 
> Advance start past the retained folio, whose truncated part has already
> been zeroed. Do not move start backwards if the failed split has shrunk
> the folio.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 55ac8bbe358b ("mm/shmem: fix race in shmem_undo_range w/THP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: split fixes, simplify descriptions, adjust comments ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Any reason, this should not be in the same patch as 07/16?
It is the same failure mode in the same function.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

