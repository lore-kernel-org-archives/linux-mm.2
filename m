Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2866CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 14:00:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFEA26B0005; Tue, 19 May 2026 10:00:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD6216B0088; Tue, 19 May 2026 10:00:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D127A6B008C; Tue, 19 May 2026 10:00:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C21B26B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:00:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67D69C1ABB
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:00:01 +0000 (UTC)
X-FDA: 84784328202.12.569CB06
Received: from dragonfly.ash.relay.mailchannels.net (dragonfly.ash.relay.mailchannels.net [23.83.222.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id D2046C001E
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:59:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=GANpHPK1;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1");
	spf=softfail (imf22.hostedemail.com: 23.83.222.51 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779199199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jFxOgosKVa9ofCbZHaIOL9XiRrG91n8Kyi+HJW0U5gA=;
	b=Cj5/R+9oOwYTKLk7PeVTN5q6mRvhQDFeVEiLvGxLSuZh48p8l3/lBs+m9kwnCVszOEh02Y
	iD2ctf0LXqLBDaQbjoswP2moxhaS4RS/J5GOB1j2WXFEyLdpb/15RcMWsj+HVAwFkeHEAv
	pDObItPCtHrNJ2v3vxILS6lLzBRXDSc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779199199; a=rsa-sha256;
	cv=pass;
	b=jTFSrTh0QTVnKVO31tlbP3GZZEcebPy/3Qckgl904gn91euwyE5eF7RA74gbG44Oe6jV53
	lPrzgnEMrAKJeY/waXIs/hIYDxbBlvUyhfW5TkBXSiAOQnox24F7gEokT017bANZkESx5t
	RGXu/3fPt83WcxC3VKN3GtP6KoPODww=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=GANpHPK1;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1");
	spf=softfail (imf22.hostedemail.com: 23.83.222.51 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 59FA1720588;
	Tue, 19 May 2026 13:59:57 +0000 (UTC)
Received: from pdx1-sub0-mail-a247.dreamhost.com (trex-green-3.trex.outbound.svc.cluster.local [100.109.25.249])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id D270272188C;
	Tue, 19 May 2026 13:59:56 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1779199196;
	b=UICybyjvqK+9gv0mHnr3Gqt5yyQ41AwfyFNKuaHyAFZWBjzY1S0GSmM/PqEqyP0Wxk1lyl
	HR8GoiGWWIWNtNL4IAbEZtqV9YDqRxIbPBVsd8NzdXSpJXqRYrSB3Qn3cz1KvGrMzI5sP0
	HW6WsRGmSn32tjN4zawvVHJPtxef3NCbwmahK92Z34fbnfEQykVza6QIgBVkHHmlbiegq3
	2/kvmQ1+nGdBXfyVNLPgIUfAHy+H/WMTA5DZfOCgid+tooIxytYPPUsrV4PxImjL7j/CVj
	50rwhj9Fiw7+HIiQEDaMnaPU4ec7L1z5np2n2Onju1RVMpeyREKsJSU32UBwpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1779199196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 dkim-signature; bh=jFxOgosKVa9ofCbZHaIOL9XiRrG91n8Kyi+HJW0U5gA=;
	b=YF3O6HTiBeYsDs9TAua0xzSKfBmq1jG8uMce47Vd9uiFSM757zdeqv8cOqLOcn4rK0CmTN
	4zW+O2m8puIPFMWbWz86EkFniUyIbOguINu3GrROIxdQQHnlzDu9x7UJd8kCs+9K3a1O2C
	WPFerDcfhmOxzTNyyRoS5PJZo51XaW4WOpfJ6mRS+voqrbkJarySzfB6rC6tkAwembWxAp
	bkMEXDz8B8gYKI8e8TYpmyzJvxADZXr5/lPunHy8E7dP3Hq/pRoaHxPEU9IJrd+vEdlObC
	txdVKoJXBPxipiS/TkdXA+Q96r+JQCWo7PDBMS0LN6vfRkKrRW9Mx9DtDe/E/A==
ARC-Authentication-Results: i=1;
	rspamd-54674b4cbd-brtcq;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Attack-Hysterical: 249efd135791aa8f_1779199197226_80967156
X-MC-Loop-Signature: 1779199197226:4283785261
X-MC-Ingress-Time: 1779199197226
Received: from pdx1-sub0-mail-a247.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.109.25.249 (trex/7.1.5);
	Tue, 19 May 2026 13:59:57 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a247.dreamhost.com (Postfix) with ESMTPSA id 4gKbs82NT2z106M;
	Tue, 19 May 2026 06:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1779199196;
	bh=jFxOgosKVa9ofCbZHaIOL9XiRrG91n8Kyi+HJW0U5gA=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=GANpHPK1WffqqXdiP/4KXPQp/S+JFICRzsVSrF+yDVEy3EuzL+K48e96dZc7EYbvk
	 eF2c1F0bdwKRhSnyIjy8n1R6KpmRZCv1Z8pHdHrbgmzuo6RaODvbOQlpQU39ysefMq
	 5rICplTx/G8jRW72YZWANehMuhiQ4dlxJRg9Iw8y+hJvI4EG5lhBTpd7RrilwN7V+p
	 83mwfMOnP3HEn20Ln5MET6xzu3I2xSO/xnS105QjFksVslvms+gOkTTTmGED0PKQbk
	 ABx67NMAeMMfzgzCEmybcHUrio06+UM6VFY/jV/KLjDK6mpVc7TV0vnYaAgoc+49I1
	 rYHSPdJlNSCPQ==
Date: Tue, 19 May 2026 06:59:53 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: linux-cxl@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: djbw@kernel.org, jic23@kernel.org, dave@stgolabs.net
Subject: [ANNOUNCE CFP] Linux Plumbers 2026 Device Memory Microconference
Message-ID: <20260519135953.v74dnpyi4i62diyr@offworld>
Mail-Followup-To: linux-cxl@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
	djbw@kernel.org, jic23@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: NeoMutt/20220429
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D2046C001E
X-Stat-Signature: x1cxj3qej9bjfhzq6w5mc37sittxhqmq
X-Rspam-User: 
X-HE-Tag: 1779199198-438924
X-HE-Meta: U2FsdGVkX19Sp5rqAzFnv444ZIQsSXhrDJCLcWy96NzO9qsnv5pJl694DXYz3Zz3NcMvLheIEAwLRCeCw1wmq1dq+1XRv4To7DVv7/NBn4LZqpqUEjtiNGTIX26WWFRbVyfKfy2E7p+JoXTMXFr8ttSdWXzAEnNRypYGQytthdAOdtkfw5cd32QG4mJGCJcYZjyVDIOsFHgqyH70K+lcugZy4U2SYpGl8pZZFg5NLSrTt5dcNLLOVXQe0pL7czi8yc0V1/Ud8cu+i+6GjItvqIXIUdURC7gEvIjuVRpXpB0Y1xdL6KvpWdD2DuZMXz107BobVuz8ZcU+VHY5Ewp4DzhcRUMSEJXo7nnFhJ8BbyyME8m4j3n4/CPbrkmxGatIS4DVmsFDq5WXqBJrTBBIhmC7TnvmCRJXs4OJHjyfvL/S6T1qDJoBWA6tMjBnLct4T/78HlMdVim+zdykrOy/m4n5WMFT99Y3m0wyrGHkX2VM97KcUcCSyyxt9SYpmwRq8Gri1hK/boIVQYnqW093fyhGxQ62eWoMI8D2QYRW6BDifZHT022WXE6SmrRgBWj7pWG+kUJYiLF00dU650qCZjWKrM3H30APzmO1cnUQ904OT/q6edW+CtZVevU71XMyAyxg1JK8gqh/uhLui10TbTuNIL/97DaybA1OFi0j2fvwu9edtjfAzrxQZRYpHFTa3h0R0faJeKv36DxeuEKaEEOz8vl5K1T1FwNJ1Vj2XgbPZl4f7RjeUx/uNoVKlk/YxQhjpz+HjB6gqe/1lSEmJEs+cIylMRqzJQZ3M4IOrOWBcbZLH5YRvssWDnEZOjmEvG/uY5jG9K2o4fuCoJGExUQKA7fZ5irQTfH6sYZHLN+69nZxCjc8IPmQZHHbe8HRggbruYNRumWulXdw1iKpjRjuxDP5xbSvSEWxTIrNK9h83+SPBMxRx2oHtECfXHeFhebugK6XJ+Og4KdveOi
 voHzuRUV
 h29NbhTdDbvqGa8iIQ3UDW7pNqZgqmisQPMJB+I7f7m7T7K5x0TmUPavsGF86T1qEQvFHRpNUmVg73joPR7/MdlxVv201hwzkQiao9KDoacPppJe25EVcwkvM3JnbtyXJKjM6QcgZuW7OmykE8nOFcAvWD75rDhzxRa49IHy3bRWt4pokmWgT2pOV3kW2aX8jHoytyjKALVhBoBuuiG9UzqUWO2XWUnFP6VZkHjZajeHTw8F/pqrLavUEmCviW5Ujbxz8a+qMO/lb38As4wfsl6ogZigvbvc9a5ooxK6b6IECAXx/vqs9fV93NKEXEkun+onZZG64p2P9+ItM97D0DjhDVpT7gyxH+EUTRspkQa+ore6M/0vNzb8Sq0mXdBmui5T7F++QCtZ96P4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

Linux Plumbers Conference will be held Oct 5-7 2026 in Prague, Czechia,
and will host the Device and Specific Purpose Memory microconference[0] for a
second year in a row. Co-lead by Dan Williams, Jonathan Cameron and myself.

The call for proposals and topic submissions is now open. Please submit
your proposals by July 24th at:

        https://lpc.events/event/20/abstracts/

and select "Device and Specific Purpose Memory MC".

Examples of topics relevant to this microconference:

- NUMA vs Specific Purpose Memory challenges
- Core-MM services vs page allocator isolation
- CXL use case challenges
- Hotness Tracking and Migration Offloads
- ZONE_DEVICE future for Accelerator Memory
- ZONE_DEVICE future for CXL Memory Expansion
- PMEM, NVDIMM, and DAX "legacy" challenges
- Memory hotplug vs Device Memory
- Memory RAS and repair gaps and challenges
- Dynamic Capacity Device ABI
- Confidential Memory challenges
- DMABUF beyond DRM use cases
- virtiomem and virtiofs vs DAX and CXL challenges
- Peer-to-peer DMA challenges
- CXL Memory Pool Management
- Device Memory testing

You can get an idea of the format and accepted topics from last year's
session[1].

We look forward to your proposals, discussions and seeing you in Prague.

Thanks,
Davidlohr

[0] https://lpc.events/event/20/contributions/2331/
[1] https://lpc.events/event/19/sessions/238/

