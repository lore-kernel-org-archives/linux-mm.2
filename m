Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1D32CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 02:17:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16E6A8E0008; Mon, 10 Nov 2025 21:17:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11F888E0002; Mon, 10 Nov 2025 21:17:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 034418E0008; Mon, 10 Nov 2025 21:17:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E75A18E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 21:17:55 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9ED794BA62
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:17:55 +0000 (UTC)
X-FDA: 84096715710.14.EEBFC71
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf24.hostedemail.com (Postfix) with ESMTP id 57C8E180017
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:17:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762827473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oUX7KnTbx3OEd23l1/MHFeuf3MAyerWGStECHGOuSR0=;
	b=J3UdlPIuY2D86hWmVSjWFrpYk6ng+kWiunhCOsm8SF8h4ESGE+mUJmPth4G5eNMnNmLP81
	DVfcjunKy2X4xMkWNxDZOxqZQR6qACJTw5IkQCwOCzrQvzuRCOqS5rr1eFHJdAfcLFUXVm
	29gV5ReSZpYPHRuEfSNP+Vjzw9KGHno=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762827473; a=rsa-sha256;
	cv=none;
	b=L/2iZ+WnEhwyDZTOhnlhFV9qyO4UKeAebV3Uw1vBTNVh8d86Y/90MHEuxMFzNmXAStLvxI
	8gRQsnOkU3s2DmuqEh31xH7rs45d2j9V+1YfQCDFXll7ZnTFJi9cckMFh1EZXhxm9g6sdM
	z63ElmkiXbA0DWJiR1Fpf/pubD/HtVo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-71-69129ccbaebc
Date: Tue, 11 Nov 2025 11:17:41 +0900
From: Byungchul Park <byungchul@sk.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
	sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org,
	tariqt@nvidia.com, mbloch@nvidia.com, andrew+netdev@lunn.ch,
	edumazet@google.com, pabeni@redhat.com, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, horms@kernel.org,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com,
	dtatulea@nvidia.com
Subject: Re: [RFC mm v5 1/2] page_pool: check nmdesc->pp to see its usage as
 page pool for net_iov not page-backed
Message-ID: <20251111021741.GB51630@system.software.com>
References: <20251106173320.2f8e683a@kernel.org>
 <20251107015902.GA3021@system.software.com>
 <20251106180810.6b06f71a@kernel.org>
 <20251107044708.GA54407@system.software.com>
 <20251107174129.62a3f39c@kernel.org>
 <20251108022458.GA65163@system.software.com>
 <20251107183712.36228f2a@kernel.org>
 <20251110010926.GA70011@system.software.com>
 <20251111014052.GA51630@system.software.com>
 <20251110175650.78902c74@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110175650.78902c74@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SXUxTZxjH95739JxDY5PXivqu7EI7jQmJ+JGaPCRmEm88F86Y6GKiF3qU
	EzlaqraAsGWxSLOJWlSUCLUzdR+KgKJF+ahgFBAVgxAUPW6s1aowHRSkFflS1rIYvfvn+f+f
	3/O/eASsb9UYBMWSIVstktnIaVlt/7RfF95z65XF718ZwF1ZwUH5SDace1qrgdGKXgbcZdUI
	IqN/8TDZ0IIg3Hybg3+bhhD8dmYYg7vdwcLbyjEMdb5eBK+LL3DwsiXIQ7n3Wwic7WGh/uca
	DMEjdzhwOsYxNIyGeNhfWxoFV9l56Kgu0MCJsT8w1Nif8vDA5+bAXzGpgZ5GJwt3XedZGCxq
	xhAoSIEWzywYvteHoLmyhoHhw79w0FXiY+BqQxcPxzs9HDx3BBB0NgVZKJo4wMGp3AIE4yNR
	ZOhoRAOnbvn5lCQxV1U5salvAItXzj9hxEfFx1hRvd7KiHWuv3nR480Uq0oTxYNqJxa9Zfmc
	6B0q5MXuR/WceKd4nBXrniWLdbVhRnTmhbi1Mzdql6fKZiVLti76Zos2zec5xu8+qc1uc/xg
	R2P8QRQnUGKik++D7Ed98kGEi2mWzKf54dM4pjmygKrq6JSOJ/Ooo6okmtcKmAzytFj1a2LG
	DJJBBwfs0ZAg6AhQe0Aby+hJNaa/P+mbWtaR6fRuyYupY5gkUvXDKyaWxySBnvsgxMZxZAkt
	zA1OdZhJvqY3qm8zMQ4leXH0z4cvmP+LfklvlqrsUURcn2Fdn2Fdn7AehMuQXrFkpUuK2ZSU
	lmNRspO27Ur3ouiHnf1xYlMtGupY14iIgIzTdOo/0xW9Rsqy5aQ3IipgY7xuYitR9LpUKed7
	2bprszXTLNsaUYLAGmfrlg7vTdWT7VKGvFOWd8vWjy4jxBnsaH9h/QrTMs2NpIsJY93zTKS/
	3nitYUD6aXHAMBnfHX5+IC3SdV+2ODe0P043HCrvf7PpZoi5orwLrTNfCqsj9lZpx57Vc/K2
	PzalXNv63ZEVMy5/1Z45d5V/QXbyF7bImlUP12du2cy0JYcPSb0nmjp6Vq4vUtr8Vanh/Ouv
	W52+fUbWliYtScRWm/Qf6eEt3l0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUiTaxjHuZ/7eXO0uJvLngoi1jl4kNSCoit6YRSd7hMV5/SlwzlBTn3I
	ka7azDSJZi0yT3o0i3StWlRmuhKmzRcywi3NpBcU5enNlb2oJTZziVN7cULUtx/X9f/9uT5c
	Ita4uDmi0ZQum02GVB2vYlWbVxyOvefQGBcVP1gBjioXD5WjmXDlRR0HIVcvA44KD4Jg6KkA
	XxubEQz7Wnh47/2I4OKFEQyOhzYWPlWNYahv6EXwruQaD2+aewSodG8Cf9lbFm4ercXQ8/9d
	HvJt4xgaQ4MCHKornyyutgrgPdvKwSNPAQcnxy5jqLW+EKCjwcFDt+srB2+b8llotV9lIXDK
	h8FfoIdmZxSMtA0g8FXVMjBy/CwPnaUNDNxo7BSguN3JwyubH0G7t4eFUxO5PJzJKUAwPjpZ
	OVgY5ODMnW5BH09zFIWn3oEPmNZcfczQrpIiliq37jG03v5coE73XlpdHkPzlHZM3RXHeOr+
	eEKgz7pu8vRuyThL618up/V1wwzNPzzI/xn1j2plspxqzJDN8asTVCkNziJh92lV5n1bthWN
	CXkoQpTIEul0R5APM0t+lY4Nn8Nh5km0pCihKdaSXyRbdSmbh1QiJgFBKlG6ufAikqRLgQ/W
	yZAoqglIVr8qnNEQD5YuPR6YktVkhtRa+poNMyYxkvKlnwnnMZkrXfkihscRZLF0Iqdn6oaZ
	ZIF029PCFCK1/Sfb/pNt/2E7Ea5AWqMpI81gTF0aZ9mZkmUyZsYl7Upzo8kfKjswUVSHgh3r
	mxARkW6aWumbYdRwhgxLVloTkkSs06onEolRo042ZO2Xzbu2m/emypYmNFdkdbPUG7bKCRqy
	w5Au75Tl3bL5+5YRI+ZYUey69Y7/MqJ+S6Lbsmfrn5VOd81v4/ZfH++NWxZ5Z2joZP+nls9b
	RufFayv8f5H3Pl1fdeXB7AjTnn/XxBaeS/o9cXVie/SryH0b9nkclsDaRUs3Thvq7YrUdp4P
	BIs1n1f6juhzvZbcZfq/3/Wte7KwrKhM1fbHteTQqpqhuGHzqukHdawlxbA4Bpsthm+MZrNg
	PwMAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: m4unwp8e3ogwq4uu38kasyfdp5kiwhoh
X-Rspam-User: 
X-Rspamd-Queue-Id: 57C8E180017
X-Rspamd-Server: rspam01
X-HE-Tag: 1762827471-368020
X-HE-Meta: U2FsdGVkX1+9LNl3DNq6fwTgiuIj9xvCmYVpSZZ+CChhdlYkKvFlIMzJbGKGDCFsN1SnCo5gv/957Qq6aIopw3cjFxBugxOubWcEvfh/cryQ30gur8/GdNscxRDOloddharuJQ0MmKfpH4CwPl8YllG68rDCB0DFv4OpavZQ6CAjPKqlT8QsOKZK11O5CyQO6vVhxJxNoOsXncB+ILQvu2WrCK6JXB+Isepgl/Vhj8b+ycdwtE293mqj05kwXFtj+tsdaCrx4F0CNQSJFLIIthN/qwwbFpCA3lUjEg0SVuhNrP00jC54LppCiujcKoZkxTcC381O/K0ek/VrXHudEFd1sULNhbL4IcnkDCHR69idTEKIDfjM7e4qmd34Vk6YvXDpL52CYSTv16LPbghQEeqOPXGbAxs+plKcEDfMvPEWs89j4AhahUt4p7PmxLNXmCbpgcwlkro89TWNoku+Ukey5Pjp3hweCJUUdN4EcKNnA8C5zgcugPoomyx7TCf5PekcXwKlkYqQcE1gCexubceENyAZWXSnmzVabfmlTOwbkGYrj4GAYwkmnzFGDTPos9fnUHmZfB5t1gCc/oulvLUxS1hVwm1DV32XaBAAa97T60KPBf8rWGFafCCqbYeCH/QpwSnc5MfjPqTFrkPKTV5RBJHJVop2sf1zLCns8iZAdY+muVL5s8YVWYk9OGIK0GHdF7lsif+t9DFI1PEMWC2ixPrWHA9WmNj51UssRUCX/zaPOiv4GxkaS//hL3xXOAi0P7cqwst7L6q8Pop5EQrOZ/4+2A/oM+gBf6B4hDcI7+jaHTsWFGapROvpkIkjaPoLOG2TktHtAV/4odoqFRSBAsfP2GytLYt5JllI6twKzQTJD/kgXqtyx7yQ4RUP5270G/oHRQP2H18kL1YP67XZhr0nNm1YqWzT02fP6tPJPxHETCOCX1T4yano3LSP8tdlumOze97/Ql2F2xm
 VKi/DVO0
 RicIJpW4p5mH9AvBYf+0ofFryJDi2lfZKE8eUpv4sNAdlRerdzXdUgzvaqn6f8tUxXPrf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 05:56:50PM -0800, Jakub Kicinski wrote:
> On Tue, 11 Nov 2025 10:40:52 +0900 Byungchul Park wrote:
> > > > I understand the end goal. I don't understand why patch 1 is a step
> > > > in that direction, and you seem incapable of explaining it. So please
> > > > either follow my suggestion on how to proceed with patch 2 without
> > >
> > > struct page and struct netmem_desc should keep difference information.
> > > Even though they are sharing some fields at the moment, it should
> > > eventually be decoupled, which I'm working on now.
> >
> > I'm removing the shared space between struct page and struct net_iov so
> > as to make struct page look its own way to be shrinked and let struct
> > net_iov be independent.
> >
> > Introduing a new shared space for page type is non-sense.  Still not
> > clear to you?
> 
> I've spent enough time reasoning with out and suggesting alternatives.

I'm not trying to be arguing but trying my best to understand you and
want to adopt your opinion.  However, it's not about objection but I
really don't understand what you meant.  Can anyone explain what he
meant who understood?

	Byungchul

> If you respin this please carry:
> 
> Nacked-by: Jakub Kicinski <kuba@kernel.org>
> 
> Until I say otherwise.

