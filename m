Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9897CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 10:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B15146B0088; Wed, 14 Oct 2026 06:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9EA16B008A; Wed, 14 Oct 2026 06:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93FFD6B0096; Wed, 14 Oct 2026 06:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 676A66B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:55:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 01E4A1C3BFD
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:55:31 +0000 (UTC)
X-FDA: 85320925704.13.56D4CE0
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf30.hostedemail.com (Postfix) with ESMTP id DB7C080007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:55:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="n J0TaUN";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=QHgq217u;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791975330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=omdT6uKFt6UgyRDQimCvM0GtrqhzgEMeFDCBOuOK7D0=;
	b=4pnRVBL5mgdot1LAnrAubCb2ant0XN+NRLJ4pXEilK2qEEtv4poEwbsikro7RY7V7EI2uw
	6zZ7pc1Hh9sZQPbyIXuXUQ1ZO0YOvYRkzXiB0l7pCx6OYoJHYEt4AkFIauvXfmtUe8yxQR
	+WujzClbq03fjtIJxFhIXnehDE6h9VQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="n J0TaUN";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=QHgq217u;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791975330;
	b=ziII3VXcvdns8geqEYR3ERAxiA0d2CyV2HnjhBf1G85A/NqvaaeC1WkbqmS7xvllNk6SnY
	W06d3D/QzvZYvFXhZor8E2rWT1FXlmqXSCsXqp7XtOERBVZItJlrWr+ZoQ8VfRU+vrE9gv
	sAwynFKtLo4kueuMGkqk7OWvgfnEe4Y=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 50B0F7A0119
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:55:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 14 Oct 2026 06:55:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1791975328; x=
	1792061728; bh=omdT6uKFt6UgyRDQimCvM0GtrqhzgEMeFDCBOuOK7D0=; b=n
	J0TaUNMSoCZ0/0H2bOkTsJX8HktIhKJBA6tMb31Sc8qsgDlP1G0OMwdkHXrRrr92
	Rg4jRwJcvVDDgiJSdEbWXr6jKzAml1eiYLgIH3xQ1/EewJ30gflkaCBaGntzXlKm
	si2O3E5+InvVtolgEfiEenZACfHhb2rQv/X09cch1wbNCAJM3gHTi/K3lYN8a0Ta
	MWsLw44F+qcxA/m/Ww6gc/rq9kG0EFJaOkZ5C33dq44t4vqNTlk2HQlF7QlEaTzt
	gmjIyk5MBIfkXfFzdwRoVtzd3o6djSN6mnUGHLV3ZpHmPtqoUhHeDrlvnOqygrJ2
	UZCyIaVJOSc6HWcQrCblQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1791975328; x=1792061728; bh=omdT6uKFt6UgyRDQimCvM0GtrqhzgEMeFDC
	BOuOK7D0=; b=QHgq217uiDX7qacTDMSrRKx6R6531j+4Zm5YzdkuiUSpmbcvmtd
	k8Ev+7nZWGgiN4fF4EKqhhFlKakyAd83bFQEd5fGUsnCUX+Q6ZuDHsRJkiTzhidd
	wGUQBDKVJSdzzz7DsalIQPjP5wOwzkXwaM+PyBi1Pq/GXi6H5E3wzXj/ZPm/3ccA
	COK+SUsJFgH+iAMDzyfHVpwjOblr9+rBqKp9/aLeqHXO8zFQsKo5C8hhdnwEz5la
	8bpDG2Dh3+NGR7VQgjZiXRt5RghqH7GrDqz1W/kc3f04xOL8L3RQR2w6x/Yx4S+P
	lggZFIHEz44Tyhp62b5Tzhn4YMP72Ut6wWg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791975328; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:u+PuiC0UHHzFkCp2fJ3vl3lx+JIpZcL36TQrI/y51PPt7f8
	Ik6Dtcjy1Ioywy9u94TR7rNdDv25OF3Ysk7d2qsMzi7xBg1/hLzDHB7tIY1ac5Cc
	qNqYp3d7W228qwI1MP7hSG0qFHbXKrufxSXPVCAOvMDKoLddXsMoftuztzjGx5II
	Nkf1VknYrL2JzcZ1hHLkwGgX0mY9+41+WYzFALxXU7/TJBGW+CUuFM4dEVSTBsVM
	9p2hut0QfUAdnS0exivESyyq/b5cNuAr7WVUf/LnKrO5577tThJ25rprKBnHAtle
	yO/s3Sm6Ag95i4UNM6PiIvex+nYIvTxFsqmgbJg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:w7lEh1tu20A+ZpNoUeDrRfl4RpRTFm0eS11CIC/Uq0Q=:Xk/fUwmHtRA0T1v4C4miwnlsKsD2mKq4YWKxoaoiUtU=;
X-ME-Sender: <xms:n1_PasKFssOqG_LtWk8iA-X6qDJrR9PvGgiQfGhTbBXGWyq7CKtS_A>
    <xme:n1_Papz6po_PG_q0ISUcPHFRFbTroa2P5U-_OBp4xOqbPcnswYwckOrohLMLDtlt4
    S32f5jyL9NKrjj9DW7KIf39y827wJR3NZU0jr4vCV9VVtADA2Q3Yns>
X-ME-Received: <xmr:n1_PakFuSU48SznQPrIcSWMyarIWl_LFBzaCD18ri01rklAFZU-FOFouvE8>
X-ME-Proxy-Cause: dmFkZTGOn86wrNKWqtV/L9sYewCUn3X/0QTPjpd/7tUrwcs05L418nntweIa5Cf7z91sgj
    cziqmIK8dhRC3X3AMKM1JjOkK85uXwPO/r0a8XxPIyu7pqMMOBaWtI4/Y4Kc2vgzvSEWVJ
    ZaRsnP9Nv4tX62EYnxn4n0bn8AzRk53DhMm8R64MuOTDJ+90AcVgZVnBwPGdlXqHQE9tOz
    SEHuJ16ddypP2WQxaX2fC4FhiZWyqjYyo2r2upTBplK5B5iszLmNZsNVxH3vvLrmntXn3R
    T7YymoFpBrxjxR5NpXb6v2OSEEjeNdTU6Ju65KT/NUdORxnzJxQLU2l8E1rSgXzg6NR8jW
    8OJjZMtRZyo7MQR+p9xub8402O7KsoTmZC+MUB8WxSjIdCu7HmdbLIFir6NhXjreyiGPSU
    Yvl5I7aSRPhEIEjwWIuq9WX9uK6wK8DqPhQ4IyKZ5q/UR/lFHSeNT33rKqxfYNtxrLSg40
    7iu4HZJk0KjiGVvtmEPF0O15Zn/C8qUfRkDhcP1PqpAQy/arDx6iY6s6hMa7ix8VXbSG/2
    kYqmb09908Vk7ONX5Cyue045o9MxG9Ak/1/IDchsoSzVKogB9YlhAWB5ciW9DA9jDyIYcZ
    76BuwDp3CRw87AIqlKpQMVF1bi6OhunxwAShdHy6koBWrkO0/U/SVF/CUy6Q
X-ME-Proxy: <xmx:n1_PahkkZiKOWtd3LRLK5kc4mckJEWrLyoEzIe1j-leCcesNPSJxTQ>
    <xmx:n1_ParGM32g4gQlVeftNMvjqJW8JXbDxQFmlVvSge6TNd40eWmWLiA>
    <xmx:n1_PakxuUZQmj4ri4cguzLuyYh8O5IP1mPqwhxfdlQv3OUq4S5WAfw>
    <xmx:n1_PakaJsvD46h4JrRHLaELBZQVfr--D2C3y-kje07b7JKozEcYpmQ>
    <xmx:oF_PasPQd9PVQAZ92DN8r02aT2pzkmBkTm1DN9nkYjROD86_ywUCVr_V>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Oct 2026 06:55:26 -0400 (EDT)
Date: Wed, 14 Oct 2026 11:55:25 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH v4 10/13] mm/collapse: open-code collapse_single_pmd() in
 its two callers
Message-ID: <as9cHpbmDm2FzJai@thinkstation>
References: <20260928100630.21870-1-kirill@shutemov.name>
 <20260928100630.21870-11-kirill@shutemov.name>
 <b2133cff-ce69-4a45-bf33-c44b774dee7b@kernel.org>
 <ar-nKHZ5hlbsXeFP@thinkstation>
 <dfbb4bac-0def-4e1b-87a7-91c9cd91349e@kernel.org>
 <20261013143839.832f1a4db51f801a2b95f850@linux-foundation.org>
 <3bd88620-c245-4fab-abb7-9091d9a1b649@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bd88620-c245-4fab-abb7-9091d9a1b649@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DB7C080007
X-Rspam-User: 
X-Stat-Signature: apxjgqqsgzfu484e8hztobsqid9fxqyx
X-HE-Tag: 1791975329-200694
X-HE-Meta: U2FsdGVkX1/28lXgsOouAWVLljmv7BL46YAzckkXS7RiBBl5LaVbbCcN3EM6iPmV1zK6vh48QJXzcNXFvvtD8k3SYlfY13vociY/IJYOSE6fhnCn7R0tKJTUWnfEYWNa5a0OqD1LyOCpRYc5vIqabcrGlcGheB5oE3Uge8t9dEF1FfeBFKGewFN/kQTHiX8DhvUAflwXUYr7a2lu/LdtlzFWgkyCPqlpWScTIR2UTv0ocdF1TTixEvEnpFSmJ/TK2nyCT/HOvdtVSQiuCtxjc4tpV8A9TuaQkW9yIkeg6RaHI+q4VM273TqMhMM5XCfgMN90lbvEIrWwJ1SPmXLa1p3NRIQd+NKAcy2Ditn4oZq4gDY71uAQZhczJ+ZtLZDPSM7TZsKbdqho0iwwGz5abdd+6Vqb2Ra/vZuXWQwDhJbG/1bu24rQ/1N1Bdug0cLWUu1P01SXdyqnT40VzC94pKqs2/0ISofT6+J5sKnlPYCGKAALR3xkQBsYqaBIfK7yEPcDkYuoRMXwvohvxtPuOkHuIZlYnkz/BluMRVTxPFaXR2T19XJAO4mVQ/Iyno7+ak6vYthglVT4CyyGQT7f1KCom9/3MiFb/zS0iJYw8SEd3dV4EmPZmjIBwWxGkmedVPth/bRq043MehhnnUvZss2Ivq2+X9KLfn8voGynHF+uXeWh/3LexH99uP6JgbExRbWwTyfmEapK+tGBup2+FthRu3oiZzsGZb/ZLa1W32gzTvPRuW9jczch/aVYiLorcpRt7ayRjkqiA64EPpskKiW19iITX5+ZsilX25n3/iJH+lPQ+osq2rnhWMEYnRrzBZXqBWpZZpoirKP1wMXUlF5HKlgFtGcsrESJNwqEdb3NU2zTE7hqIn9eBkrXnNhwvyCpmQH4/wQWVar3ph/8BpgugtybvtGr3T8GfYmlm5y8eYjPsF9EZsA+Bkxv2V6g+4BR8k1BFQfklVrS1Sr
 +lcDHBPR
 vrkYoVfUjLvbWyfGhhG5VGs5vEkUw7FER6AvuxyAT/mBvW4MwFbfU7igBuG7L7rf4NqbAHMG3oLJ3quzHXUHhowEBRAsH9BvARAEUWb5IJSq0jb5iqRunxk2UebLPvtzCPhNFgTpfWQm0kgfeydziQQzTUFGKLGLL1+wJX0iZdwDO9e5/8cTsCwNQS51qhEWg3TpRNlldAGZKx3SUTdGbFb1LQLTKLPMS/hP/Ka7hmhP480F9IwKe1jWe3iescOOyRa1NwokrY+Nru9bmN/cf6q7BvuDE5heUzwMWSbbX9j0Gv78sgLfyuHw4NMHV2bnVeqLtZLZT3WcTq/eYiKxN7png53HZ4kyOmviR2z8fhFytlZv4AmHEsTFMrj5xxh6RuaJa3uww8TH4Mz7eIDSQPpR/tJ6WgZoociwaj23ipIY/klcaseOXtHWnpo/koxLaWELAZERwuTfW7lkX13fF+Oq2m+30sbtceuVapPPVIgFfLFHzCGjoceKTEdZIJUJtISQnp57UdTqNpKIndX/I9xVQx7WRHYcRaMJspSz9DRhOOHqE8WHPVFGqgONPhSVt2WwxMF39NVhqju0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 11:33:46AM +0200, David Hildenbrand (Arm) wrote:
> On 10/13/26 23:38, Andrew Morton wrote:
> > On Tue, 13 Oct 2026 22:25:21 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> > 
> >>>
> >>> I see the appeal of the single entry point for the collapse engine. I do.
> >>>
> >>> But it costs us on both the locking picture and the scan rate. That
> >>> does not work for me.
> >>
> >> So this is in mm-unstable and I want at least the first 9 patches to go to
> >> mm-stable rather sooner than later.
> >>
> >> As raised in person, I don't like the open-coding here; it just results in weird
> >> API. I wonder whether we can come up with a better interface, while keeping the
> >> locking as per your requirement cheap (scan performance).
> >>
> >> While we figure that out, does it make sense to send out revised patch 1..9 to
> >> move them to mm-stable while we figure out the remainder of the new API?
> > 
> > I've suggested to Kyril that we park this series until the next -rc
> > cycle.
> > 
> > But I can bring it back - we have a couple of weeks, three if we get a
> > 3-week merge window.
> 
> I'd say we move forward with the uncontroversial parts, and keep discussing the
> controversial bits. Either these make it still in this cycle or we'll simply
> have them for the next cycle.

Agreed.

Andrew, could you pick up 1-9 and leave 10-13 out for now?

I want to experiment with a few ideas for the rest and will get back.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

