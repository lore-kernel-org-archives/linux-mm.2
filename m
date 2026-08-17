Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9515BC5DF70
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 10:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 586566B00FA; Mon, 17 Aug 2026 06:04:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55EAE6B05B4; Mon, 17 Aug 2026 06:04:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49B256B0903; Mon, 17 Aug 2026 06:04:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 27B336B00FA
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:04:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95CFAC06F3
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:04:51 +0000 (UTC)
X-FDA: 85110327582.22.AABCB40
Received: from mta0.migadu.com (out-199.mta0.migadu.com [91.218.175.199])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5C99640003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:04:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cREQP2oy;
	spf=pass (imf01.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.199 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786961089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZy3RSwaMdIFLWYOJMnTHvFBfarZkg1ulH0LjrXs96I=;
	b=mxBYmOKF/x9AufA7yiRIKM6I0iX4lMKUiUw1VdmTGY7NtXq6UbhFTVehchjaCRiBWKnSaa
	hbkRq3go7wj/pXyipNmNVYxEzoiFd294GJPahLxMg7+fF3Q028DM03Mn6N5jJfD4l3xlQd
	u0jE5VsUR92UzLvcc3j6UP5ujwCcrtM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cREQP2oy;
	spf=pass (imf01.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.199 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786961089;
	b=RDuk5A/yH2hcj0r4zNgKboqU0Jio8l1I22mmlu73HNQennL/deeXnhffWz9CCBjnsUDhri
	djj2e3xAW853TM5B8R8L/rNjtgcR+SrIN3w/VGo2+K+yLM8JBV6LbyJqjGJHPkvcZZiWM8
	+29uhNf7cL/ypAXGOpKglrNsAjwrX5o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Pa9p0AOtc4bgbwY1yolIgiVFzciMbdEAo29iWopVcH0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786961087; v=1; x=1787565887;
 b=cREQP2oy7UUwWG72SrBE9IiIQlEiK932vHX/urf70Gj26tZpzexVv7cSLhe9hYD9OD/QAukx
 AuIM5A1ZO+X7Yr5b4/l+J0r2btNpPCOgtFxqZ0LIDnsgSNe0cY2aljnf0G+nrWNy3NG3DneyIsq
 O1e0NYjGfjfF6jj/zdz8leKM=
X-Envelope-To: linux-mm@kvack.org
Received: from fedora (117.129.78.49)
	by smtp.migadu.com with ESMTPS id 35ac66a1649c20c9;
	Mon, 17 Aug 2026 10:04:47 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 18:04:40 +0800
From: Hao Li <hao.li@linux.dev>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm/slub: use a track count for user metadata
 sizing
Message-ID: <aoLci4aJGKDNaNWd@fedora>
References: <20260813160825.73031-1-pengpeng@iscas.ac.cn>
 <20260813161059.73855-1-pengpeng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813161059.73855-1-pengpeng@iscas.ac.cn>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5C99640003
X-Stat-Signature: is5rjwgnfftt4r3bxz3rntzkyxargubp
X-Rspam-User: 
X-HE-Tag: 1786961089-295262
X-HE-Meta: U2FsdGVkX1/79ivhQt9noZQGxvIIui9aJ1E+8eAFXfz1t9SSQDTo3RVgdJowFvzCBiuSsXemm6KJRKFiy0umJWdbiUYR25FYl2klecIDW3cqEyyziajaQP1E0JYz1joya8OOooXGAQMUaZ6kM00iCZ4KOswnx2PZlr+d9WHTUPfV+rk6eSSXAoHT09Ps4tX0dP+TQpt5KvsRdWMtSfkeu7LmHq6n0Axr+ignyDhuHWpii0AAQIzCjoNoBwW9Byu82QuOnY9smYVv/K0STCg+c1+xmyeykI6+Whgm2uKGEcRCx8W/GQ9PRh4RA5k9Sbe1/3+aT0McRIrqHy5UvP1Xa+XpRuTefq8zDagQ1wtgX+cFBgwDK3n5jX9yc37EEZak1Yqa/Z5dGEnROfDj9yfh0OGZlGMZj7bziGYoPNwfutjwk/EnBcsUqKdwOEcKUUOPkLY73d4pQlMzEnztn4NSO8oBTjv5Gej+81ErD8j02Az8kysZMc188js55dEfx926PZutXQZ3GlamOfMzjF/jMx2fR9icY1o6V34yw53XHTCRgL1L/s5KaqnxMvPc4ntCuv4iPbR8mfurHi1EM1cKobpnePOwh+v8rITE/b1Qds2FsoU+VEHfrhU5tfsKuyRCOzBNKjcEOwkKI/Fbj8dfaQCH/1b4q5NpOoTfUpgeq3YYcN4UDVvhySAi5BanxeQlQbQqy1PCp5KMMtPxbDGB0ngCXFAQPKD5I/9OmoHGTATlJgVimPZBuOPAVD4k4ev+vrSZeINeh0aoybGJIw9kup+INoLN6LTWtuhOwjwanuEXrrXFue9SeFZHbKyVw6V4lZCQZuPR0B8d9Z57aRxMS5cLXmazAZT6iKB8evoAexE9DTFbdwC7QKvmxd2w06owp8Q5L5+r1X44Yktdz+rE+EH5B7jbS9Swzr7wTceVJ9jZplTM8mFQr1QotVwOkM5PV99MOdzQ2pyp5ytrltQ
 sESVTZrT
 6ovGN8hPPojJ2nsgxjisg0Ch+Ng/3VkXM4mwAGkq3/qnmGAZ2rKE940ixJ0LWJjIho+JXBOKtDfy0w4HL4RIgnthH1/WSXwjMlaB8ZmgnMP2DazrJVJF2WPFp+paE8N/zrWhy6QItgQrj+Pxgj+WPunaBgbpl012U/+vYrG2szDUYVjq8+id53Odx3DGWhnbxvfb4h9beNEmeX0C7xYCCFsM/DnfY7hrV4Wr6CPQH2X8cL1Z1QmfS+NLe+kcsFm9GqlW2oJL3ISbdkg4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 12:10:59AM +0800, Pengpeng Hou wrote:
> SLAB_STORE_USER metadata consists of allocation and free tracks, but the
> object-layout calculations repeat the literal count at each offset site.
> 
> Add TRACK_NR to the existing track-item enum and use it for metadata
> initialization, original-size placement, object-extension offsets, padding
> checks and cache sizing.  This is a behavior-preserving preparation for
> extending the tracked history.
> 
> Assisted-by: Codex:gpt-5
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
>  mm/slub.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

LGTM.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

