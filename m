Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F0CEC87FDA
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 01:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A99C08E0009; Sun, 10 Aug 2025 21:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4AD38E0006; Sun, 10 Aug 2025 21:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939998E0009; Sun, 10 Aug 2025 21:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7EDB08E0006
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 21:09:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02579BAA3C
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 01:09:29 +0000 (UTC)
X-FDA: 83762693700.02.806FEEA
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6ED6540006
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 01:09:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754874568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PZogQPgthXQpLzMYfOkkMMFAAg7NVoujJlli7pvNDvs=;
	b=c7BjfZT8XyDXcp9VULxu4fLPymQqIpxpdpZec4BheypYA8Vsr74Vi/OdMRO9atrmUtLwBZ
	ChrkuLes8aPpiLxuhRnypCJpc+wqPOxrgc672CVuR+ST6dyHN+oET25QYRf7xmJM7dQjJl
	d+6fhI6TBOh/VbzuGR9k++slxyUnIqE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754874568; a=rsa-sha256;
	cv=none;
	b=F82orZ22yi6j0py1bB/odwCIFMBbqyyAfW1IFbMIvlmf50P7W2j6WRuiWECDiZklz/NCKx
	4QmNWICCnNxLGqlKTQAtkfoiX4eH4vgmCw7VHciujRTVnnVSbTBLLW2jJBDwO3XjjfwQKz
	/GsrTDXGnJFNzz6tlCIcwfEcZaFXrCg=
X-AuditID: a67dfc5b-681ff7000002311f-f7-689942c2df79
Date: Mon, 11 Aug 2025 10:09:17 +0900
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
	linux-rdma@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH linux-next v3] mm, page_pool: introduce a new page type
 for page pool in page type
Message-ID: <20250811010917.GB28363@system.software.com>
References: <20250729110210.48313-1-byungchul@sk.com>
 <757b3268-43ab-41bf-88fa-4730089721f3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <757b3268-43ab-41bf-88fa-4730089721f3@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTcRjG+Z9zds5xOTotzX8GfViUYHSl4A1Kutr/SxEUBRrUcic3mlrT
	vHSBaXbTZmLXLQvLMnWSMO+XSW3LS7EuRrUsnVlJstS8JN6oNkXq2/P+3pfneT68PC2vkwTz
	mtgEURer1CpYKSPt9b+3zL7ZqF5Z7pRAbmkJC+bRZHjYWe2diisRDI995OCPtRHBkKOJBY99
	EEH+3REacl+mM/CrdJyGb41dHJgtO8Bd0M1A/fkqGrouN7NgSJ+gwTrWx0FadSEFuWV6Dl5V
	Zkng6vgDGqr0nRy8qc1loaPkjwS6bQYGWkxFDPy85qDBnbURGvPmwcjzHwgcpVUUjFy6zcJb
	Yy0FFda3HFxpzWPhS7obQau9i4FrkxdYuJWahWBi1GvZlz0sgVtPO7iNS0mqy8US+49+mpQX
	faCIq+EZRWpM7RzJsxwnZYWhJMPVShNL8UWWWAZzOPLpXT1Lmm9OMKTm8zpSUz1EEcOZPpYM
	fGtjdgVESNerRK0mUdStCDsoVRsqJyRHW2clN9l7OT3q5zOQH4+FNdj5vYOd0e7757gMxPOM
	sBi/NCf4MCuEYJdrjPbpAGEp9ry3eU+kPC2UcNj4IgP5FnMFNS6784XyaZkAONvTw/i03Mvf
	nC2STPM5uMX4dYrTQih2/e6hfFm0sAA//D1Vx0/YgB1DDVNZgcIi/LiyifJlYeErjwusPdR0
	z/n4SaGLyUaC6T9b03+2pn+2eYguRnJNbGKMUqNds1ydEqtJXh4VF2NB3pcqOD0ZWY0GX+22
	IYFHCn9Z54ObarlEmRifEmNDmKcVAbJu9Q21XKZSppwQdXEHdMe1YrwNLeAZRZBs9UiSSi5E
	KxPEI6J4VNTNbCneL1iP7mTLQ+K25ndcD3tdnunZdCr6UE7vnKQoZ1qtJku7Ihzr98iMpuGg
	oDZb2d4tH5dlUmReWEXiWPPkbEf5vpz9SdZHgcau9UERhWu3UeK4s31Wt8ps1sSVslrDsfpI
	D7ezPXq77GRE2lV7xEDkFpuzbdvwQvfBlNkF4YfriGqJUcHEq5WrQmldvPIvSa6EKU4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0iTcRTG+b93V4u3qfmiXWBRgZVlJB27IUH1J7p9CIoIdeiLG84pm4oG
	habdrJndKNcMrTQvC2Oam6YSm01NyFDMmeVMTTAvZV5oahdnRH17+D3nOc/5cDhSlkf7cypN
	oqjVKNRyRkJJDu/I2Gjbk6vcnFG4GYzlJgbKvqfA414rDcbSKgST7m4WftU5EEw0NDIwbP+G
	4GHBNAnG1kwKpspnSPjk6GOhzHwIXEWDFNRetJDQd62JAX3mLAl17jEWzlmLCTBWpLFgz2um
	4U1VNg23ZgpJsKT1stBeY2Sgx/SLhkGbnoJmQwkFX283kODKDgNH/jKYbhlB0FBuIWD6ah4D
	Hbk1BDyr62DhZls+A/2ZLgRt9j4Kbs9dYuBeejaC2e/zK8dyJmm497KHDduA051OBttHvpC4
	sqSLwM76VwSuNnxgcb45CVcUB+IsZxuJzaWXGWz+doPF79/WMrjp7iyFqz+G4mrrBIH1GWMM
	Hv/0jjrqe1KyM1pUq5JF7abdkRKlvmqWTmhblNJoH2XT0BcuC3lxAr9VcD26wGYhjqP4NUJr
	WaIHM/w6wel0kx7tw68Xhjtt8yMSjuRNrJD7Ogt5DG9eKVTc7yc8WsqDkDM8RHm0bJ63ny+h
	//ClQnPuwAIn+UDB+XOI8HSRfIDw+OfCCV78LqFhon6hy5dfLbyoaiRykNTwX9rwX9rwL52P
	yFLko9IkxylU6pAgXawyVaNKCYqKjzOj+acpOjN33Yom2/fbEM8h+WJpb+FdpYxWJOtS42xI
	4Ei5j3RQeUcpk0YrUk+L2vgIbZJa1NlQAEfJ/aQHjouRMj5GkSjGimKCqP3rEpyXfxrSdq7C
	jugmvzsPHk6dq4hypY9WBv+QrWjRHywb6DxyP+SzumhskHN5q84mbWskhsb7R5rrVh4zFew9
	sSRi35WnYeNXmrbv9dKGJjrGwy17YgItGVu63N3WA6clcTPPTaHhr1KiAlpifPffmjbHXpKc
	Gjnsq3EPrHXt3rSrMuhJumK5nNIpFcGBpFan+A1UN4MuMAMAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: 47pijond8ifmsboiopm47smmo8t7tm5d
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6ED6540006
X-Rspam-User: 
X-HE-Tag: 1754874567-989008
X-HE-Meta: U2FsdGVkX18+3rAlp7sMk4rESBYVgKT0TCeSyALxPFTsDKCXszhyxzhPI7T/aQQpmo3aUHSbK7BghzD4qw5+aafvMavZOFN/yWuxgJRGSh2UvG7CLKvz4XpCl0/C3/SAx4w81zRzOwtAPrL1zTG8ptSsJPSe5DgyyT4VoyVh8AXQHNw2y+EU8Y7vpd0vLLV2xNN8i4pxl2/iWG5E1Ww0p/6xA4eKohb1bjqGUB0dMWUV+QqGjhF6sK9J0ZFKR9H9kjNUX4JJYsVNOUH4sNGR5YIJuhj+UYKMMiM0pnq5/UtLiHfjGeqOE47SdQc3EeN29oMNSEGc98CFLJ+Yve4pK95XWTAsjSCg2xfv65x4j2PaGm8Hcc/oph9WuJeceJvlLuIbQpHzcjt8GW84heinR/B8uvmVJl/wuinjzQG7yEO4WoBedAHFpN+icywwyyD0j5VTpf2dwevdea8rOqBxlEEiFjL91U32XBEMc3XQeeBH23Yv18o6MyebbUs8eWNgakCvrpDKXS3g1jNoiZM4F9yM5TVGW5QZmGjIXF9eWiI7v5+M1PlXZe3aOh1WAc74eE2pDARtXmUSvIVqU9schfeU9TCCGEOOSLe1P7IVghBTo8zmD6ICApJj2r7P5jzTuFMTwfWUk6hWLkrpf+aKf/VX2QJ4Ix2lw5i3QE/w5y/iTf2YfbDgxhFKFEJAQ7HhiMVahOV5QC3cGVNZOPTd5qDdMfvMpcLH6hAq5I4KmcVQZAmUb4hhTuQzuBE6vT/TRJeQ1L02X+DmUWhs4h7Y8/E+WmerrECobXeDHaP/8C5ncGt5rvIq8KeDDIYlrptHi4bJjm1Cn/wpt1H66I73jQW3wJ9Ibf0L06U7boG55POyFZyt6fNmqLi4uDPgDjUSzrGefA4TRJhNbbS+KPMl4r+i6YMYiEmIW8dLNFlZdcvXv/zoqUMFQYT2odvCJsZF948CsREJnqsXlj3DmOQ
 myd/ZcIS
 ry5ES7Ql0Q6VuSmXapCxaei+ymfGjuHDBdA2W5MrsQdz3j5LWbeIOlmsNecjNtuYyHRIXey6PEOX6YO1gPoF5lYuPrOFfdHNTzVjMefZVH/h5CDbdC8ejxhhhAKOs54UfhMkpiw5o6qaOgzRVfcFOUvBCoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 10, 2025 at 09:21:45PM +0100, Pavel Begunkov wrote:
> On 7/29/25 12:02, Byungchul Park wrote:
> > Changes from v2:
> >       1. Rebase on linux-next as of Jul 29.
> >       2. Skip 'niov->pp = NULL' when it's allocated using __GFP_ZERO.
> >       3. Change trivial coding style. (feedbacked by Mina)
> >       4. Add Co-developed-by, Acked-by, and Reviewed-by properly.
> >          Thanks to all.
> > 
> > Changes from v1:
> >       1. Rebase on linux-next.
> >       2. Initialize net_iov->pp = NULL when allocating net_iov in
> >          net_devmem_bind_dmabuf() and io_zcrx_create_area().
> >       3. Use ->pp for net_iov to identify if it's pp rather than
> >          always consider net_iov as pp.
> >       4. Add Suggested-by: David Hildenbrand <david@redhat.com>.
> > 
> > ---8<---
> >  From 88bcb9907a0cef65a9c0adf35e144f9eb67e0542 Mon Sep 17 00:00:00 2001
> > From: Byungchul Park <byungchul@sk.com>
> > Date: Tue, 29 Jul 2025 19:49:44 +0900
> > Subject: [PATCH linux-next v3] mm, page_pool: introduce a new page type for page pool in page type
> 
> That will conflict with "netmem: replace __netmem_clear_lsb() with
> netmem_to_nmdesc()", it'll need some coordination.

Indeed.  It'd better work on top of "netmem: replace __netmem_clear_lsb()
with netmem_to_nmdesc()" then.  You said you are going to take the patch.
Please lemme know the progress so that I can track and re-work on this.

	Byungchul

> --
> Pavel Begunkov
> 

