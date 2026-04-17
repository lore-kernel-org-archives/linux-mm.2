Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E528F436B2
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 15:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C5BC6B011F; Fri, 17 Apr 2026 11:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976116B0120; Fri, 17 Apr 2026 11:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B31B6B0121; Fri, 17 Apr 2026 11:12:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C5AC6B011F
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:12:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3066F1388E1
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:12:01 +0000 (UTC)
X-FDA: 84668388042.04.F4C27D0
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf11.hostedemail.com (Postfix) with ESMTP id 09FCB40014
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:11:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Aq3s/d1Q";
	spf=pass (imf11.hostedemail.com: domain of alvin.sun@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776438719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hE91+ODNE/cyUlwhydK+2PgiKWGGfc/idUIRysntKY8=;
	b=AftTkt4noRpUCVKIxsGnqoBq4vXi0j/GiU1frkHYWuLIAYfnlYYDb9s7wKu6clBubHoJn7
	ZnTnb7Is0Ktu7Bw7QQa7KGF/gJMgxHVOirNcFNk9IbcUUu7rcm88dAvtub0PR8gtYTEWmQ
	rb5D+kSA7z0XSxU6YK6IkneyiVjDm3o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776438719; a=rsa-sha256;
	cv=none;
	b=pua7CLIos/rzeGRg/rU6vwRDbpqa0izwxBbnk21R4MiCLmhY1a9dnZGMa1EUsP40q6K7ir
	tNf5wf3g88JdDPHodLyeWUV9TkPHqE0NbFqsS/sORX7Vjptbf6Iq8X0BRwNMsgYcO/Wf1e
	Qa+NfvyOW+xWIj1NIkycfrny+DvoI6o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Aq3s/d1Q";
	spf=pass (imf11.hostedemail.com: domain of alvin.sun@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <03096a35-a5de-4fe1-b235-42c1647b8563@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776438716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hE91+ODNE/cyUlwhydK+2PgiKWGGfc/idUIRysntKY8=;
	b=Aq3s/d1Q35SNh01ElXCno+uaYR8qW6Od0mIGP+Xo6qSBdFYBSI1hAgiWAIfay+xZMx5PAx
	CIVy9tD1CGrhfK5MwGOhUTn6rYwcrY8SdanxcdkyCfcJ3vghL/Yif8DSlNr6ObYvLVvpNA
	usH7aSP8muoo+JlFfTyuMxw1DElM3sc=
Date: Fri, 17 Apr 2026 23:11:35 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] rust: xarray: Add Guard::find() helper
To: Tamir Duberstein <tamird@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
 <20260417-tyr-ioctls-deps-v1-4-41c6e9bb061c@linux.dev>
 <aeGKTIRFgBqHNI9S@casper.infradead.org>
 <df183bfe-21b9-4393-902d-18835e0bcf48@linux.dev>
 <CAJ-ks9=veRG_8SZ7CyzqdR2RhtJ6QZWozyo8oc-xnwoqpCdg6g@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Alvin Sun <alvin.sun@linux.dev>
In-Reply-To: <CAJ-ks9=veRG_8SZ7CyzqdR2RhtJ6QZWozyo8oc-xnwoqpCdg6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: w316yjqizpksxbo6oy9fpdfik59hg1pp
X-Rspam-User: 
X-Rspamd-Queue-Id: 09FCB40014
X-Rspamd-Server: rspam05
X-HE-Tag: 1776438718-315474
X-HE-Meta: U2FsdGVkX1//wbSWr3CLWZow7Mq+DwA0cWZWwMAQSwtD9bqGlcsJ2baYUTcb2NYBnGu0GVLEbl67wVaGnbLh9zV7UbXmVVQ+CA5ze61O4dt6mUXd4yZhk5WFYfc6zK/gLpwIqh106l+HiK5R2xIehn/Rx0123oUxGPzyZNI1uyske2HATY4i69RWFSSTDq7fnaNAikCXAxaxjcDXK/Wb+1L8dyh7nwydJemoSEK84rV68FHd4sfC7wUgBNXqR499JT6z3kuSiViVjQ7FNlvZw5wMF2EQNNrKTlj2mGNSb+FqwSmsZKJwibCfL4F54Fo2AvdnKyPTI4HxrJXCvZo8voXzMl6Y3Xr2Ew1M4IowbO5mL3mmm9Rzi5cSa6rCuwZ00AODkJXFR9jVh5+f6+9p2Q5tOw09ld/17/tcHk0zpX+Y9XoJMliJGuyh/RrJhdyK6B22zZ7MKn9o4J2aSeoq93u48qdCkSPrKu9OIPzcKVLSH8CrcE1qVvItMP/PdsuyzKn/74qgWMzuyySVskBYi3QgY20pw/O3GyerjHvMPl8vHoUHaZerO+3PnDw2TPrhLteK57kXI7vGVDSXtBfAEVt/QEaMJL3Dcj6tGTw5ZFav1KVXosDKxXyAG0i9Wrg5MzGkCSDMRQg9CL+VVfAHaPhxaJdOTg1d1d//dH2Z0fHYzD2X5Hc94YKqbg3/AO5Giizjs5k/SgAReKnyQNyRaepw0oEfgul8UzgeWg+3pEBX1CU4+/8xcYwvEMp9guAjdKLXc4v6uUd1mB4Getn8yRcqqAma1A8zGkrdQAEzuQ4qNYW2aOh9u2nURetQUz2CQKi6Dp+gpKFUnAUEJVlAH68f0nlLXhf6kld2VIplEJV5k8cCq2GGz5j2gyCjlYBAuixjpPhjXJKgkLUAjjEBe427693ur8KVQFP6pxbg3/vLHTrxvuw74s7R0NrOu4DVTpjU+e8ogQqD1vtqq02
 VoR5KkfM
 GnJvp/XW89UB80jCMwf9AqChdV1xodRcNnMJOO6javWClNupiNR9RvMtI/W4LeyKEzofycKworT2mYoaKxmNE85Hx+lFnVt/sNNM/GCOhQbrSbreUCaJgfUQgG9xe0ssuweipadamOXoQJKOTG9qVO8kxDI03I3gDPsrvu2d/TCNkf4L+CoklC5YLxSBiV7zAM5AG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/17/26 22:52, Tamir Duberstein wrote:
> More complete wrappers around the C APIs exist in Andreas'
> https://lore.kernel.org/all/20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org/.
> Perhaps we can borrow from that series?

This looks like a very complete xarray implementation that includes the
APIs I want. I'll look into how to integrate this with my patches.

Best regards,
Alvin

