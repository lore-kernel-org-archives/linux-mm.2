Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E906E7BDA1
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 11:34:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 771436B0005; Mon, 16 Feb 2026 06:34:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71EE86B0088; Mon, 16 Feb 2026 06:34:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62ABC6B0089; Mon, 16 Feb 2026 06:34:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 50E216B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 06:34:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27558BDEE6
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:34:42 +0000 (UTC)
X-FDA: 84450112404.23.9D29356
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1330440015
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:34:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="I O+f4JR";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=rvjtXAI7;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771241680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z/44F5g7jPHoL3CaGxYN0FVETrlse7APjvGYt7mfjgQ=;
	b=Io6Bx3KZcWFdlMAtWIjYlD7P8ls97UahQJS8kfZB7Qu3CbkLjeh4NAJy9tcatqryRL0HAP
	R+VPUDRQdSvm4oL7B3RDP11VIdDpnxUe3z8iSOo2u5PrK83hUoskLXYNiDRuU0EPV2TLJk
	/5gqjsq5Ah92litPD2mmTOsm/m+CjGc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="I O+f4JR";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=rvjtXAI7;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771241680; a=rsa-sha256;
	cv=none;
	b=hLguWr6iK59eCGf4FUOiG4Slh5Jh39uqD0nTyhnjAKucwLCg3HuIyOFGQtoVTZo0PHf/yZ
	rsRgVWtBul3xpDBtYV2jhgHnGLagK4iYjSbqvy+F4zHjJw9YKkF/BMFIp+YG3Ggh7Zw2TL
	wYiIAu5OZXE9JHnls44/Dzo07eMaTnw=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 814A61300D47;
	Mon, 16 Feb 2026 06:34:38 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 16 Feb 2026 06:34:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1771241678; x=
	1771248878; bh=Z/44F5g7jPHoL3CaGxYN0FVETrlse7APjvGYt7mfjgQ=; b=I
	O+f4JRfJq8NTsHdTvzrCpZfpB8D42zJfi5Bz9lRt3Swa+2LQjMIWEAPNabX9P/sq
	D60bAm9dssTXXmLmZVLzadJDx+3rNzDPUPXE3qFvxJsbwb8f/ClYpbsS68xtsPm0
	0fVsvEqhiSPjVSu19eky8EcRDKjCPe3QFXSkMHoPOWPHYJlcB/mURQXGsE3IKZCb
	uok+Yw2PG9m8GRIBoUdhGk0ivPMGcljH/yMQNrVq0DRw8idU2395Q3VBOa0pZ1fn
	0uO5xmbHm8/zn+NQK0WvDBBHYsx4i5wr0Tw4HhRihMKTwnedWFO4YsW4WQBHKyQ5
	hxcnVezTcAqjJ0LF2mPXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1771241678; x=1771248878; bh=Z/44F5g7jPHoL3CaGxYN0FVETrlse7APjvG
	Yt7mfjgQ=; b=rvjtXAI75i+J4WNsGFBYenrpr07UW7dVws1Unk/4buJ93hJpRxf
	htIWpbKV5+JcfCNX/9oy6mT1KbWmOKntALKMEs5dSMJVryqzje/Ge2qu95Sug6mj
	lwhzPNVH0pl5y4xpZqSbRvVyFp35zMJUcchevgrJm8fPV0hHmFzJFTlPDO3Ly1FT
	A8MntdTIxPVfl6VkuxavY4nkhHX8xH7RYCQG/wMHndq920PL8cT3eUeAZA8JiSmc
	veGay6ys0lg2wFFwhEAFuENq+lVUGzdWozt32CG8IVBnJlA8XrVMm9/HgxfCPeev
	mt9s2ZQQUFF3ZTKgfHrxLQhG2JTXSCu3EKg==
X-ME-Sender: <xms:zQCTaYwP-rnFnNq3Evewxyu-SIKFpkEnV06F3miPLNgyjHW8T8qIWw>
    <xme:zQCTadkXUjRGykCUF5FFEcXWG6uF7I3xzpejNFLyuIC_vyPD68bZoI1z5cygufU6R
    OpnXpDcmSaEdMsbvc5Gopo15ewrm3hrBWXa_sYIe0e9X57BrGBMFNA>
X-ME-Received: <xmr:zQCTae8hnM2uNXZ5BaLs8P5natNMPiaURN_iwyT2EOrg_pnK9_wpaWPSrVqlvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvudeijeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepfeetheejudeujeeikeetudelvdevkeefuddtkedvtdehtdetieeu
    ieetjeeugedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    vddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohephhgrohifvghntghhrghovddvse
    hgmhgrihhlrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurght
    ihhonhdrohhrghdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprhgtphht
    thhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvh
    gsrggskhgrsehsuhhsvgdrtgiipdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepmh
    hhohgtkhhosehsuhhsvgdrtghomh
X-ME-Proxy: <xmx:zQCTaZPUBgcNh9YNmVBFleBeZYYMAcI4XnHyPB3-JCcN83CqZusy5Q>
    <xmx:zQCTaQ8yjtghycgZSQb827hKTOhvIn_wjgQbc_UWx9nSshEv7aA6Sw>
    <xmx:zQCTaZKRxTgDLQbmJ2n-_62oWDbCYdbCetlIb0gLR2YfDSWsLtjkCQ>
    <xmx:zQCTabdqPlAlkOpXzTjmN-Xwq8GeTHytmiG50CghgH6XdYWWmZBqLw>
    <xmx:zgCTaW51A7zKw5acSIOnAbl-9bKYhD5jKgjh4qkDOXcTkSs6Mvl_4Zsy>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Feb 2026 06:34:35 -0500 (EST)
Date: Mon, 16 Feb 2026 11:34:30 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous
 pages
Message-ID: <aZMAVF1S1kP5Gny_@thinkstation>
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260214084514.2842745-1-haowenchao22@gmail.com>
X-Stat-Signature: 3ysewoc76y6mw4iztffsqy4ex9u1fb8o
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1330440015
X-HE-Tag: 1771241679-424009
X-HE-Meta: U2FsdGVkX18AwWB88/BreDKQRItj5z1gUxtVQK0dutU+xoSmw8zvvDxfC4zTiQ1PoS75QzdYppcEDyKWnXuMUnlaWzKVwbp1aTU6Rx7qk/ovLSgRY9juM6MeWDfux9vP5VH9dASCxLp+foR/Ik7/J+7vUIuglE2kVtPbom90gv9c58ScxUTo4JuYso8x788UxfWUnWcpJMLCB6GQRv/fMNG6jSLziB+bmUpcBN1fY8Qw2Grn5/dRyTjTjz46i5AuLArFYOZAtX/p9T3Lhb4gxqmmWXBadTRyR7KcXznKrJJukwpSsFHAyG10QD1OzOB7Agq3EZtd+rvwjC0Up8Q/l3mV1yLshnMIPsscE1J0WcyB9jkUGeK7sTv1HIdZP1V2SFlRS20zczePoKyeYymdPlWkXdiYeLeJNT7h2uWD6fIOyUDI6kJgIhmDozSouQj8LQC5mEIgSYFhZjjJMChezMXM3wuMcvwCk1NahjbPZCqyL4u2B1aq9y7y6jBOItmI6+vLnK+6JRxTskk1FW0fDb1ZW5tL1+WuVDcAN3oKoMOyDwP/0AoZre0wCrEOgseZQkmwYC/kRLB03ap/FHUVU6JIoWon/TcdRs06Z1toL2SCZgL6vDvpdgHjbvwptXIVOVYdly+nKpXnu7+5tpD8HgKXf3gERve6c7do++0/qWEqnt/3T3ohXoFapIDOjfjbcBvrpqPFpWsTyiJP1nkB/H5vsYgNcsV6RN9olbaSCoRTVZBB9iUTTqHZigxD2yc/Ijj16yJnoldPFRl2uwzm9n2pF4CiffkVk84aarwhJi8DQk6irBIRSHfs6LHPRx8RLsWQ6ag5vve5GyIqyPdXNcRoAalxEfFuCxyrNRc+gZhC9IM6XsBJUj0Xa3J173ckXcV5/LlcWttHsC4rUTT/a//NW79k4X1hBY9exxc+mAKIbBXkxwiEO5oJaZc2Oy3x7F2V7Bnxy64tzknLIqH
 TOB0M1S2
 ZTiNJYCWlj9Kr18g/Tp5fznXjBKR3dRH1RXjL/xirTa80H1ZbDcmketdhC72KeJnQlOijVdGuGron7HYJI32lFCKgPsYexUEaaUOj536bQPDwCgGHZPscR5/jI3bv0xbWF01n0Z9n3znK5Nrhoh7BRZ2kJllB3j7CurijEuPhQwDCoP32TVuYR3yBNIUYmbJHnVw2+q9F2VV5GBU48ddN0PlItzq/WdkKBh2Y5GmrSwavp7XNRxBJyPucAbre1w4rpy5oDnsEyRXNVMsMyLV0t+kKLjADoQvLA84YSxxC7lGM7v+kGfzRHATfKwACcuR240RFB8CFSEGD+9bRK1o6nnocAeZ8+9MYJXy+lG7YssUGDxEBdhUU7OM8BGli7UTmLElNLW6Qv85ji3fT33Ld6Z+sQxsAKcyn2zDvLQ2+yapymzjOvgSRG184kdGbVVYCPUhG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 14, 2026 at 04:45:14PM +0800, Wenchao Hao wrote:
> Add kernel command line option "count_zero_page" to track anonymous pages
> have been allocated and mapped to userspace but zero-filled.
> 
> This feature is mainly used to debug large folio mechanism, which
> pre-allocates and map more pages than actually needed, leading to memory
> waste from unaccessed pages.
> 
> Export the result in /proc/pid/smaps as "AnonZero" field.

I expect it to slowdown /proc/pid/smaps read substantially. I don't
think this line in smaps worth it.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

