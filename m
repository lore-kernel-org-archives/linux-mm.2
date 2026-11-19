Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F5E6606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=AhoTYwrT;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=zTZxm0lw
Received: by kanga.kvack.org (Postfix)
	id E28936B0663; Thu, 19 Nov 2026 10:53:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E00496B06A8; Thu, 19 Nov 2026 10:53:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D16CA6B06A9; Thu, 19 Nov 2026 10:53:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD6676B0663
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:53:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED46AA0B86
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:53:20 +0000 (UTC)
X-FDA: 85452312960.04.9F3428A
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	by imf26.hostedemail.com (Postfix) with ESMTP id AF8C1140007
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:53:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=AhoTYwrT;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="z TZxm0l";
	spf=pass (imf26.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.154 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795103598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=udWw4j/3CRbbtGknfZnMT/IWCBSeJb9u4N8Ww5aPcts=;
	b=YsA7famQ6pnuknm2xW1Jh1rqhiXVRFce/+fvw+bTUEOHY/npjM9n7Me148UGXr90aZsaX6
	GJaF/rMyChN28WiqTFdVMv39neOSxSzxC5QbulvIE4zWPDMzUrmPMAjbpYL7MqYYWXWXfS
	EEEueqvZcbpgFrTraFTxUoFlKIlZPLQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=AhoTYwrT;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="z TZxm0l";
	spf=pass (imf26.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.154 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795103598;
	b=258xCfpQxnC+LSJJKzW0y08K+wT23qP88jyvzLscQPAit9GCN17Ks+oTq++KClodaoZicL
	jHxf15DD+FZDXx/UVXsfj3N1CwYUgl47gxVDHZLAPemHXXw/x+uA6NfTPcHdkkL3WiTZEw
	KoCQpTk7s78J1G6tLIFs6scOK4NBQHY=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 045C114000E2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:53:17 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Thu, 19 Nov 2026 10:53:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795103594;
	 x=1795189994; bh=udWw4j/3CRbbtGknfZnMT/IWCBSeJb9u4N8Ww5aPcts=; b=
	AhoTYwrTz8Qphcgy62B0BD66gS0w7j/TEDQwwZYBCmBlS6K5jkBn94EybUsCkdAM
	5lQpLzQttabhag0U3M6Fd3FI+m1ROPTDI63wQjz+JrmjP2Y9Qs53nStKaki2wtQB
	0D57XG4G4EwbdaIf5MzgRcKfruglDHto6PNnP625rWyFXZHaQhbcZ7fxJG1t8Sjy
	mjtcWjlL/wRDsxPnt/Z4cV/jtMFkhqG+tm2RomKosmjzkr/GpPO5V9uwku5/eBcW
	0uSwkQdEl5h09eQ4A6AXd+VbMaibwrGOZwot9puYk/VU0859ObfM/cs5jhLeblXS
	g0F1XCdYrO63ehLFPTxd+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795103594; x=
	1795189994; bh=udWw4j/3CRbbtGknfZnMT/IWCBSeJb9u4N8Ww5aPcts=; b=z
	TZxm0lwtb5rzLVaI24MJtCEbYMY7HdL7yQtBTb9e78ptd2Ty73XCQugMz58SqTQq
	benW75i/XDst21K+k+PoMdT1MQTPtG6ZJ7bGgBaz5XxB+YIC0rcJ1qhJYn/oIEaf
	cUOK+dbfjhE37sXlIEBhIaTm5/5kFyC+KGjDjRzI/jnd1Tadorzv1cX6I/XL0A+g
	l9k8P0eberC3W9vzCWM8Dg3wclYkeVHFBx/VkqbGbZCc+wBf6/+MC2hNLJAo3isl
	I2txC+hxekqSNh2KqJ4IWmwDg9baQ7nU8zLjMN3iIlZNifRDyzKaIiLNeGQy5riD
	6xJinpL818HDL4dlcxR+A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795103594; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:j45irh+KZg7gyQ0sHP6qKt4YG/xDsfujxu5H8l8rtxhnJW2
	tOKjrwckVjjNw/G/V2oeyNISb6K+3RDkNESFwU0iKpwKkjetB/K0/MPNfoLeBQk4
	1FlLhz8LOuon8RI3dx4wsRZ6Yz1bSN9Hx/ucloERdK41or87geoMja6uydjTuHx1
	W+aRSs1axWDi4BbEttZKrtmO/pLy72AaWvgkKDQxdiXp16uEQQpmnsyBTM6YCWdF
	9MycdU7FzXGXujRefP9xqYStpW0B4ZKTjNa5MAlHOLC50lARAnq3THHKC/Mx4dd0
	8JsYPrFojfp6ehlFZmIju70UWMr5m+1dvOp5Bxw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:zojJKI65RDiBC01FjWfnaIUjr6peF6J5GZxmPRdJ+Xw=:3rMBRJpeHI4Xwrnmp6nHRSbLG3c2x5m0ddW7b4csni8=;
X-ME-Sender: <xms:Yxv_aof_h6Vx4k2whqKMkXRXxvgDqhsNJES7o7OSXwwyrKTsy5SgCg>
    <xme:Yxv_alDqfSi5lEFxvosnn5d6a3hhwhn61EUqHuyQKVm6zuTWXvK1e3DVW3O-Cha41
    wm7QYZTpxRGXJtADJTRvXNr0MLbr-0TbPTrrY4pCjcxUAxdH4-EDLA8>
X-ME-Proxy-Cause: dmFkZTFkW6/+Kc1dJJAACXMOgE1Uxs4efqxqPSJT4DZjh+RMr7yC7rNoqxnNEDcPsEY0aQ
    upC4fJOjPuviISStLTuK3aSU4Zxn11zSPHWnnfXPzUSUj9gYuh5MaGb/c3OVNOIfZind44
    5rApX+RzTaH8wKRSJaUj/nV39ngUmpqfxQdqpKqci/8DC4/kiKT1hirNWyUIHd+Lq5HGlc
    wURwZcKaVmi6KcnA4cyV0bMMWBSUsoW8b01hNhMlzS2jcd9ImYZj9f7IMgO7FyhyIzAKJg
    rvnkgsOg4QxAFiMkF8fZIxD+XquMLrKKeNtHRpas40c02xfQ+7ph7gaVPDqUSlP0u6vQl3
    t6KRarOTmitu85PK1zTzf0isWCveAuLeafSiI1xeSJNEWCSh1zODd7iA86h9DHsd6oVPL4
    ivBe4soWu/znuwllCl1IO72e36G1RTcsjbfZ5auphSElXcgZ//ZQabme9h9dA5hQd41AwQ
    +sXb09CejGV+izDTfveCU8YIPPuOyfNJYozgDLOfTMPeuDKVqSFgeUYmdC3VccRX7pXGG+
    3vs5glUcnbNzoFaJNGIksy2isyb5fF1oUHV6PJjTlmph5oImLceLJG5XwRsGcuAKYKCWnM
    LPUMuHf2qdqO8fus5k6hQx8hXtMthp8XjcI2WH8jy9k1l9I1dFGwBpjUjk4g
X-ME-Proxy: <xmx:ZRv_asbIDLCDaCynoIVEbY2ZXg-DcF7CspY6MyQxAh8XluImnH4-Zw>
    <xmx:ZRv_am2EwlfN2dop9tYLEh2IZUYhl-djCfHZRgVwaeFhZAhVJ_Gyeg>
    <xmx:ZRv_aoBVc0-WrkhGpg9kngMsK0GewEZjgW3KH2A0YxbhSKENk1Pntg>
    <xmx:ZRv_aq_alng-7N17vsNdRCQjpBfwcDo9hl-in-tGXgIJhJBo7J4V9A>
    <xmx:ahv_amJrCM3TMxlTKyZLHY2fHcLWwJVHNVe14NJcAhKmh_192wIdhhr7>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id E643532A0099; Thu, 19 Nov 2026 10:53:06 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AQsIS8mXxcAZ
Date: Thu, 19 Nov 2026 16:52:45 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: sashiko-reviews@lists.linux.dev, "Arnd Bergmann" <arnd@kernel.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Gregory Price" <gourry@gourry.net>,
 "Andrew Morton" <akpm@linux-foundation.org>
Cc: larips <larips950@gmail.com>, "Zi Yan" <ziy@nvidia.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Lorenzo Stoakes" <ljs@kernel.org>,
 "Brendan Jackman" <brendan.jackman@linux.dev>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Jackie Liu" <liuyun01@kylinos.cn>,
 linux-mm@kvack.org
Message-Id: <c420ec17-b297-469a-927a-85934a05fda4@app.fastmail.com>
In-Reply-To: <sashiko-outbox-221983@kernel.org>
References: <20261117211635.2472067-1-arnd@kernel.org>
 <sashiko-outbox-221983@kernel.org>
Subject: Re: [PATCH 1/2] [v2] mm/mempolicy: fix copy_nodes_to_user() for odd inputs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: w8j9ph9qpktawz7jhnxqu1mztscspngi
X-Rspamd-Queue-Id: AF8C1140007
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795103598-532435
X-HE-Meta: U2FsdGVkX1+noMWvoT+BcpVq14J60FTNmnHYAZi2sBirybEZEVIJiJ7hn2JeaiopH9UVe2P4CRKITRFIbcKwUGZVeEw4HhX4pcGdGCpF2nQBdmNQqAi+8qvffqpkWypg7vuJBtat0ssrZmIGHBUk+0aZQJ5ueyA+NOpFKGTPg3Jyix38B6HUSDb/egHVjM7s9q0Qmaye1u7QBaQsjuS7LbL/lXbIyMbl49Y74nTwxbBbVvo8RPJjTtW+/iBTQCLuo9Wfk5BAxNxwgobbC/NwyX3N7vrPmooZVpgdZW4HxgVj4Wrckrvo2GCo2wM7O+02gx6u+hX6F8rdtWInNSS+zFxOyjwCQITO+YsT/DBncJQGEpbOTOaj/6UAsmcLiE3Lbb0F5+oE1dMgdcQgmVPSkS2q7EmeZwNLD1c9NNmJRajLNRqo5licMa1JXTjWpoLw9S71dXsmJx2W4pE5EhFd4ryjIn3FfinRF6kdAf7hsc5SN6tVFh4lGm/aE7ljVV9c+UadRfm5p3UQ7sDkDgvcZ8KBXASB6qTvkvfUEz7/NasvPYE+FEvw0KhhusUROxGzMm4ssqYVoahJ5EFOvOes6r5es8CwUBJIgbHpFgMzoVReDc5qpKlOWsJUj6vqOK/fnIiKnirI/j+ow8CbIHP+sjVW8cC06XDVfHGB/A1jboXxEqRswLXal6728f9Mr6hS2BlRspSaBAYP9DznVpbaGn/Cv9y7N2KXhEPzZxn9CoGdmX6Bsof/Jl/ogfvtkqTDq8XyL1lhvMOylEuxn/VKR1gnX4gLVVy2WQce9Wj8faIFspAnYK4rWvurVdX2N+8tPfVIgfJq/vqhMxYeza6+utVZRGjblBW4Xxc1Bn3GjhyDBGoTizTRG0Tmq0BPNRrJhCW+VdIlV8Z+KJfJ1t9HVOcheeGF53F5N6JQ/CVoKQYllVmKScY87Nd62Qw58h3RWyO44EJaOnLW2NXBMpH
 Wy7JPTf6
 A2NtXgG7HjclayZ1J9UkQUGTeF/nD9g+98st4AJnEpcRrA/imBYDPDpp2WIHdhz7L9Af3UDhDY0bs60ehvmLjeZHqwIT3N4O24/eTquy9+dJJ7Ayi7Pr/wl1Ol0KY6orasUlULSg0MY31/1qS75ZWcYSU/dBWCv9F9WKlGbWBpbHrSbxN6crSRQBgVN/1AUDrlQzhctRO374jenQCM/X8Poska2pZe5CBKrU7m3Lmd+UBDVI6O5bZUCCHFeHR4Z55v0HumlAvli5JXHhwrtbdBldPk1ITYuT/tAuzOmVMMvYtCMw/HhDEb64/Rj6GBJPNVpHuuoqe/wzHn6CRFls0DQeenYTRWhrIRbeh7G+uhSS2Fzzt+ZW3iy98ZCRxNJGO3teYZm6GfZKckxZ6Z3R6GrO8WQg3zqrA4ft3cK7YxNL1W71InNtUXLjMNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026, at 22:16, sashiko-bot@kernel.org wrote:

>
> [Severity: High]
> Does replacing the compat nbytes assignment with the compat copy
> assignment leave a 4-byte gap in the userspace nodemask when
> BITS_TO_COMPAT_LONGS(nr_node_ids) is odd?
>
> Without the compat nbytes update, nbytes stays a multiple of sizeof(long)
> (e.g., 8 bytes when nr_node_ids <= 32).  When a compat caller passes a
> buffer with copy > nbytes, clear_user() zeroes starting at mask + nbytes
> and maxnode is clamped to nr_node_ids + 1, but compat_put_bitmap() aligns
> maxnode - 1 to BITS_PER_COMPAT_LONG and only writes
> BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t) bytes (4 bytes),
> leaving the word at nbytes - sizeof(compat_long_t) untouched.  When
> copy == nbytes (e.g., 34 <= maxnode <= 65 with nr_node_ids <= 32),
> copy > nbytes is false, so maxnode is not clamped and compat_put_bitmap()
> copies the upper 32 bits of the kernel unsigned long instead of zeroing
> that word.

Same as my reply for patch 2/2: no, this is fine as the size of the in-kernel
buffer does not depend on the word size in userspace. Copying the extra
zeroes from it is fine.

     Arnd

