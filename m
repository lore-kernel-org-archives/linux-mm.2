Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFED3C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 10:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CDD96B009A; Tue, 29 Jul 2025 06:22:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A3456B009B; Tue, 29 Jul 2025 06:22:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DFC66B009C; Tue, 29 Jul 2025 06:22:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 293D76B009A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 06:22:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9467113B77
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 10:22:54 +0000 (UTC)
X-FDA: 83716913868.30.C80B41A
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf16.hostedemail.com (Postfix) with ESMTP id 23E69180006
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 10:22:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753784573; a=rsa-sha256;
	cv=none;
	b=N/me2UWmvNOTNGRAhacx8iUhjJfWDnCk7GxwhVsaX+/1J/x4+YS9QRQ9BebwhPEztTp01Z
	hc1OmVZwsUJD7EWVg3Kju07mMDwO5EKi8Isi0k/HsA+1En0X/wvL1BI7yo5FrHrxpCfe9e
	gtjrrzUQzVrX3UXL35VKe+62rsDHpC8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753784573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vhM9GGKrP8IWKbIVw/Dcl55m8/fAXq0d47yYeTf67vs=;
	b=xzsAPo9LiHc6HApGLOHt9J1HmXaugZpjBw3lZ4vkmqv6/7k5hcDRcvA72JttQs5OmRgG/L
	q/NAHdjjGtD6QpNXeumVxBJl1+Pb4b6/OmdfFWCKWXf+h9k0Ohn6utplF+nKBh5U65sju4
	n+ER5UV2iSsprb3HliMlItFCBFcVRIE=
X-AuditID: a67dfc5b-669ff7000002311f-68-6888a0f71497
Date: Tue, 29 Jul 2025 19:22:41 +0900
From: Byungchul Park <byungchul@sk.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, toke@redhat.com, bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2] mm, page_pool: introduce a new page type for page
 pool in page type
Message-ID: <20250729102241.GA62940@system.software.com>
References: <20250728052742.81294-1-byungchul@sk.com>
 <fc1ed731-33f8-4754-949f-2c7e3ed76c7b@gmail.com>
 <20250729011941.GA74655@system.software.com>
 <18eb9e6c-1d60-4db1-81e1-6bce22425afe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18eb9e6c-1d60-4db1-81e1-6bce22425afe@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTYRTHee5zd+91NLxNq6eCgkUUiyzD4EhvIgRPH6KgD4W9jry0kS7Z
	0jQIVkqmNDPTyjlrvZimwmSGmzat5svSgsSw1qtmU3oxS63VVCxnRX37cc7//M75cASsdMrm
	CTr9Ycmg1ySpODkr/zTjyvLvtlPalUUlSrDaqzmo+pEO5b0uGVgr6xB8Db7g4WdjG4LRFi8H
	H5tHEFy7EsBgfZTFwjf7GIb+tj4eqhyboefGAAvubCeGvjP3OTBnjWNoDA7xcMJVwYC11sRD
	Z12eDArHyjA4Tb08PG6wcvC6+qcMBjxmFtotN1n4UtSCoScvDtpssyHwYBBBi93JQOB0KQfd
	xQ0MnOuycfA2qwdBV3MfC0UTpzgoOZ6HYPzHlG0o/6sMSlpf83Fq2jz4GdNbN58x1NfUwdB6
	yyue2hyptLZCTXN9XZg6KnM46hgp4OnLJ26O3r84ztL6N7G03jXKUHPmEEeH+5+z9HNTN7c1
	IkG+NlFK0qVJhhXr98m13vMX+ZRcefobay9rQkE+F4UJRIwh+SV29i9/KM6ZZlZcTL5fmMQh
	5sQlxOcLTnOkuIx8fOqZmpULWDzPk2y7m8tFghAh7iY1d9aEMgoRyED/xHRGKXYgcqemm//d
	mEnai/3TC7CoJr7J90xoFovzSfmkECqHietIf9VpLsSzxEXkbp2XCXmI2CuQYND75+i55F6F
	j81HouU/reU/reWf1oZwJVLq9GnJGl1STJQ2Q69Lj9p/KNmBpt7pxrGJnS400rnNg0QBqWYo
	tDnZWqVMk2bMSPYgImBVpCKl7KRWqUjUZByVDIf2GlKTJKMHzRdY1RzFqsCRRKV4QHNYOihJ
	KZLhb5cRwuaZ0LF3x+Miw1afNW9Z4B686/VdHX1Y1xcRe/1a4hb1DpN7veN2d1TBpYLouTXV
	ta2L/OtSF1ueunHZrNKFu+LOdTwcmyyPlw3648MvWRK+dfqp3v8hM+oAn7BxzDjMCzGFw5uc
	HfrowlYpfkdpjsscPnN3ZvieDe1LT6wwN2y/HIhdpmKNWk20GhuMml/XZ8JjSgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHec85e89xtDgts4MS1bqRmjcKnrDbJzsEZZEU3aiVhzaaJmdp
	GhWzJHOk2UVzc9LKTHPCZJp3M+bdoIumrpuapVGZdjHvaM6I/Pbj+f9/z/PlYUi5QeLOqMNP
	CWK4UqPAUkq6I/DimiHzZZVf4tUNYLLmYbCMREN2V4kETLlFCAZH39AwVVmH4FdNPYav1T8R
	ZN4ZIsH0LI6C39YxEnrqummw2LZD5/1eCirii0novtqAITFunITK0X4aLpTkEGAq0NFQndEo
	gedFSRK4OZZFQrGui4aWMhOGjrwpCfTaEyloND6g4HtKDQmdSVugzuwGQ0/6ENRYiwkYupKB
	odVQRsCNZjOGD3GdCJqruylImbiMIT02CcH4yPS2/uRBCaTXdtBbvPjqvgGSL3zwiuAdj5oI
	vtT4jubNtki+IMeT1zuaSd6Wm4B528/rNP+2rQLzDWnjFF/6fj1fWvKL4BMv9mP+R89rih94
	1Ip3uu6XbggVNOooQfTddESqqk9NoyP00uj3pi5Kh0ZpPXJhOHYt98WQQDmZYldww7cmSSdj
	dhXncIzOsCvrxX1tt0/3pQzJptJcvLUC6xHDzGcPcflVgc6OjAWut2dipiNnmxBXld9K/w3m
	cY2GjzMHSNaTc0x+JpwuyXpw2ZOMc+zCbuR6LFewkxewy7jHRfVEMpIZZ9nGWbbxv21GZC5y
	VYdHhSnVmnU+2hOqmHB1tM+xk2E2NP0w989NXCtBgy1b7YhlkGKOTJUQr5JLlFHamDA74hhS
	4SqLyLqkkstClTFnBPHkYTFSI2jtyIOhFAtl2/YKR+TsceUp4YQgRAjiv5RgXNx1KO209N4z
	zwNjDnePbfoB79UvA+XJWf6ix+azU5mTxkr5wdhr5VuHPz3NOLbnVWTMy9dsRu0iv+vbdXnL
	z6+UVIyd37ubwxNLcfDDo2KzefGLAF9LyFzfQv+7he3lblntmqAlAa1BsePByd5NeubGbU3d
	PvFbzvw+RwfVdjgkO3CXQUFpVUp/T1LUKv8AoYlxAiwDAAA=
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 23E69180006
X-Stat-Signature: zbx97ymjg9png3xh3knxumgfhwcomxoe
X-HE-Tag: 1753784571-255965
X-HE-Meta: U2FsdGVkX1/RNa6w6870mW/hZAKebi0SyGl7RIqtkp2nhe+dKW+SwlHpT1uwTC2KJUtrJ+DBOf7EInBiR4BW8DbiVfxtH0zMz4BKN6ZDMhtFNqgcMWXdohMPV74k3eXNfoT7MJ58GN6Q4kOOasNLJHcP6LwgVliNGA+P8GOJkTBCI4o1UWRo6NOIfLEttV0u3W/w7vjLE/8ps0qLqp8wCjCAbEyfhNLKCzV3V1THAFAmX6ajb4U7pE3fOF2rzau0BP9qdDt9AquaW0/spjxwlw/j4JBccnNjndX368H/vu9jqMyb/UctkYuirPEMd4hD/lFTmS4kUnyshJ1GZmUL9HzU17Og3owjV77dozm1/l1ygR4uTZaTveRg2XnflDyzHgYg74jt6djFz/UPi63fLjsaqlFCEirNWPqCZGBie5Bafy/rMEKq5aoS6/s9OeEcWTmZaRWBKyLea6ZhVegLT+VyFBzcDqj5EaDXJMOBxEZAqTBgu4FIveWYEtMPxzvNwo45qLkcX8BGF4DDyAUsDP1OHPOJClWqhLPOok/g9VCXS85oXkMIVW4wHR07h4Ba+dBE+nb7f540W+DzdA+tZLIk2qFYD4uiUzV52+gUuvgIcqBdbZ9RVQGRVY6ATzRQ26UOo6fcCN7YLKOoksNBFJpHqtLr8HuyibgKVV0Q92VqPpIUMuADM3XvvX0rEDQr70YE7PyjArIsSkUUoeKveILuzQEPNrxwMTi8t1j+zAexKlmpaJ9H50qqJAexr7n7eogBaBUmNRaHR3M1RnI9kC7fCQDeag8Cxu6lcPq/ugdFM6R/Q/zbpgCGDg9uUwX9QqT+hr5r+kEQKNUcUv4HTJzjVMWUZGM/G7qiKL8Xrb/jN5m0JYVz5asfeWsZS07tStxQDZXxrVegSMzOLEyID7PG6t8HpbafrCCZK3MocKSOgE+nZDwREMnzuPblO3gsh57uHJu9rC6n8pFv7Tt
 n4/FtAz1
 MDQsqJEEzsrtAst8n13EGLXMkr0eLneK50OvhQmiqoCs4Hsgu77vGB/Vws8Nfs8JSNsZmUB6QGVTi33FfB05Mbt61PBwWw4jExu1h5A6DcpQh1UmlzYvRpJ/tS91DZ0Yd4lYeTdw0pWBXpdbCRSEYunSRHqCs8dyeF+uvsBa17NbRPq/lMXp5X3pUXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 10:22:30AM +0100, Pavel Begunkov wrote:
> On 7/29/25 02:19, Byungchul Park wrote:
> > On Mon, Jul 28, 2025 at 07:36:54PM +0100, Pavel Begunkov wrote:
> > > On 7/28/25 06:27, Byungchul Park wrote:
> > > > Changes from v1:
> > > >        1. Rebase on linux-next.
> > > 
> > > net-next is closed, looks like until August 11.
> > 
> > Worth noting, this is based on linux-next, not net-next :-)
> 
> It doesn't matter, you're still sending it to be merged into
> the net tree. Please read

I'm sending it to be merged into *linux-next* tree since this's about
both mm and network.

However, if you are not talking about a specific tree to merge but you
are referring to 'Do not send *new* net-next *content* to netdev *during
the period*' in the link you shared, what should I do?

As for a network patch, I already tagged 'RFC net-next' as the guide:

   https://lore.kernel.org/all/20250728042050.24228-1-byungchul@sk.com/

For a patch aiming at linux-next like this, what should I do?  Should I
remove netdev@vger.kernel.org from the reciever list?  I'm not used to
this case.

	Byungchul
> 
> https://docs.kernel.org/process/maintainer-netdev.html
> 
> Especially the "git-trees-and-patch-flow" section.
> 
> --
> Pavel Begunkov

