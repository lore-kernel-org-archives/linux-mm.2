Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE798CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 04:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9DB98E0042; Sun, 16 Nov 2025 23:26:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4DB98E0002; Sun, 16 Nov 2025 23:26:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16238E0042; Sun, 16 Nov 2025 23:26:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B0E98E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 23:26:11 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3009EC0B47
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 04:26:11 +0000 (UTC)
X-FDA: 84118811742.28.C082671
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf16.hostedemail.com (Postfix) with ESMTP id 922C7180008
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 04:26:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763353569; a=rsa-sha256;
	cv=none;
	b=ULMVz1Ba9hhPb8p79ExHFnBPSVa9xAiHxqkfrBmli2d3zGlg9lFD0GYb5+vjPyS7y71oZl
	f8Lx3HxHpNHMjUhZQOhxb+bxOBtKz/JB1uz4JrO+irW/HjFzaIli0m0t/a7z8MtJQ9AmM8
	XIEkVLoNPw75ecAsp+pkPfys7nOHVg0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763353569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z1OiM/DfSTbLCvEFFdMx1QANM7f/7LwcCi+2smGPkRU=;
	b=NRUHRfOJlL8iQd0pIlRcCew2C8xNyPRnVbLKg4rC7HEZS2x9VutBxuk6iE2MnAfD+b5QKv
	nnHTyTS1Hxg2GZtj5ar+m0eVHFxdZ/EIHKF9uxYhkF8vREmlFh7QpfIM8ZJ0fiJDCqcIF9
	D12a3Mab0qUg0g7b/xVlfaJLn6pZTUI=
X-AuditID: a67dfc5b-c2dff70000001609-9f-691aa3dcc437
Date: Mon, 17 Nov 2025 13:25:58 +0900
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
Message-ID: <20251117042558.GA18510@system.software.com>
References: <20251103075108.26437-1-byungchul@sk.com>
 <20251103075108.26437-2-byungchul@sk.com>
 <20251106173320.2f8e683a@kernel.org>
 <20251107015902.GA3021@system.software.com>
 <20251106180810.6b06f71a@kernel.org>
 <20251107044708.GA54407@system.software.com>
 <20251107174129.62a3f39c@kernel.org>
 <20251112074118.GA31149@system.software.com>
 <20251114172318.3aafc438@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114172318.3aafc438@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxTH89zn9t5LY81jRXws+2LRmJAMRf1wNMui+7Dc6LaomJi4LNqN
	q9zworaAINlS22YCEwYMDFSMRSPyZliKllLBIG+CxEjYJFdF6JiDgYiIHbPUwbiQZX775X/+
	+Z3z4QhYf19jEOSUVMmcYkoyclpW+3JFxYeDVw3yln9GDVBeX8dB7dsMuO73aiBYN8ZAeY0H
	QSD4lIeFli4EbzrucfCifQbB1YpZDOUPHSz8VT+Hock3hmCi9AYHf3SN8FDr/hyGK0dZaD7X
	iGHkx24O8hwhDC3BKR5s3qpFcYOVhz5PvgaK565haLT6efjFV87BUN2CBkbb8ljocVazMF3S
	gWE4fxd0uSJgtncSQUd9IwOz5y9x8KjMx8Ctlkc8/NTv4uB3xzCC/vYRFkreZXNw8Ww+gtDb
	ReVUQUADFzuH+F0x4llF4cT2yVdYvFn9mBEHSgtZUblznxGbnM940eVOExuqosVcpR+L7poc
	TnTPFPHi4EAzJ3aXhlix6bcdYpP3DSPm2ae4fWsOaz+Kl5LkdMm8+eOj2oSR3gnmpG1lxqXK
	CsaKvHwuChMo2U59BQNsLhKW2PN8pxqzZCP1XxhDKnNkE1WUIFY5nGygjoayxbpWwGSap6XK
	kEYdrCapdPqVdamkI0CvBCc5lfUkB9O61uPL+SraU/acVRmTaKrMjzPqXkwi6fV5QY3DSCy9
	8WB8SbmGRNFWzz1G3UVJQKAvnuSzyzevo3erFLYAEed7Wud7Wuf/WhfCNUgvp6Qnm+Sk7TEJ
	mSlyRsw3J5LdaPHDKr9996UXzfTFtSEiIOMKnV9ZJ+s1pnRLZnIbogI2huvOfUZlvS7elHlG
	Mp84Yk5LkixtKFJgjWt1W2dPx+vJcVOqlChJJyXzf1NGCDNY0YGVtuw//7Y/scVd/tqq+Gp8
	34cNNv6adooJxkXsfp0VvqfL7tudVvKDrejMeq5vT8+2xAv22mLD+fWoO+pg1upjUd25lv2d
	X7nJAA58Zw/25u11fXr7ExSKL4zQPD4StAx+sHdjh9z/s98zMz9RPQ6O9MmQLrugtShw6Ius
	HOc2I2tJMMVGY7PF9C8NHjvqXQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTcRjG+5//uTlanJbVv1UUqyjsKiS9XSihDx2iiwURlFTDDm40tTaV
	WQTLpMvIS/e5ZmgXK5sJs+a0rJzLSxGFop5InZkXLDExk5aWuSLy24/neZ/n/fLwWOVk1Lw+
	PlEyxmsNGlZBK7atPbm0+aZav6KpjANHkZOF+9/NcKfNw0DA2U2Bo8CNYDDwnoPR8ioEX33V
	LHyuHEBwM28Ig+NNGg3fin5gKC3rRvDJVshCZ1U7B/ddW8Gf30XDk9MlGNoza1hITxvGUB7o
	4yDVc3esuNjCQWVOLQNv3RkMXPpxG0OJpY2D+jIHC63OUQa6vOk01Nrv0dB/2YfBnxEJVbnT
	YOhVLwJfUQkFQ+dyWGjILqPgUXkDBxfrcln4mOZHUFfZTsPlkTMsXDuRgWD4+1hlX9YgA9de
	tHKRy8UTssyKlb1fsPjw3jtKbLSdp0X56UtKLLW3cGKuK0ksvhsmWuU6LLoKzrKia+ACJzY3
	PmHFGtswLZZ+WC2Wer5SYvrJPjZq2h7FuoOSQZ8sGZevP6DQtb/6RB1OnWTOyc+jLMjDWRHP
	E2ElcXessaIQnhYWkLYr3SjIrLCQyHIABzlUmE/SirNpK1LwWOjniE1uZYLGFCGR9H+x/DlS
	CkBuBHrZIKuEs5g4n8f+1SeT2uwOOshYCCPyrx4q+BcLM8mdX3xQDhHCSeHrnj+VU4V55Lm7
	mspCSvu4tH1c2v4/nYtwAQrVxyfHafWGiGWmQ7qUeL15WUxCnAuNbSj/+Mh5Dxqs3+RFAo80
	E5WLiFqvYrTJppQ4LyI81oQqT28hepXyoDblqGRM2G9MMkgmL5rJ05rpys27pQMqIVabKB2S
	pMOS8Z9L8SFqC4p4wF1S+Nxm8/XHr6Nd6qsStWpn197O6KaWmGpH1zNX6tz9zD5N02qf7Urh
	yPaagTnNMd4o5akj8tHq7LxtybGfdYuP+W9Zf1Yo1mx4Mb+lcWDWBN3bq7MNOx7vdc1IjZCS
	ov1FG5dEJw6PPqro5yfE7aqoy+xpmFQVq44Z7Zh6vEdDm3Ta8DBsNGl/A8QjZDA/AwAA
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 922C7180008
X-Rspamd-Server: rspam07
X-Stat-Signature: 9811xun3zpb9xe94rstorur41zfo8bqe
X-Rspam-User: 
X-HE-Tag: 1763353568-509832
X-HE-Meta: U2FsdGVkX1+CYn+DFvVYzwx84rcN0SMCW77pHbC5u9rc5t0IdfMGD8Ecx1VEd8rV45frf+heQdug+xiTarUwW9cdvNYe/07IRnh3TwXnN0tGsYk/SRb46wNC+LuTdOdAKqLMVTtHk0j+wU5QqpSIJZlsBuZp57MsJ+JvrwDTR+4/tDeOxySkXdPV7NuqJIiixk4xZmpdyi6OsHVpaqklqKPriAyYTCWpZhEL0Af3W1fd8COvcY4rIhlNZD4iL4ME2yhMC/CBi/KtXMRofZJSa4sLHCrtmY0YCcWVuGmNpDJLcetLXGD9KLYGSsqN/NAcFhgjrNLrzNcAJNzsRyj6A61cT5SMW5XJ9CS5ZWFhBboPk1qtOiq8Grcx97Q5FAKPHXSPAlgRXjHCmaLEYIedr1oD+FSwm1zOj6KtwRLLbPKPxsdfUHP80NzLYbqlo//zfV4DMElD2HGk5ZWXdvasxosEgH8wAjJgxL/c9MWCEK4CzjmaZvuhqhwQ52sMOcBX4/cyzcmDeuYK34VM0Hq4vnp1uzFAos+3Bs3KlEPc9WIFC/3w44wBj6JsH24v2SYWxx5lMdfPQLiMHZiHBHtGB0yqIWZJP/yeFjPeiTey06WwPfpQGFxBuoWOAY2kEh5sqNMzAINE985/XuMkXfTceQKvno4ei0EnQf0Lr8qI6pIbShslA5d8nTsJcdk0TGIaSbQ4482ODOQmC2I1XSAYamOkFEVJIVThStC9ELzpFK8IO0nQVo68+GkGjAt9bnc0qdMZqGFQvDjw42zaXIbUa+f1Gxq+U6NUc1PsgRKRqrGn61XVxgP82h0hDhWHXqi1giAuoZ5HJY2BBtfqlldWavCLR6232PW8PgoN8Ch8DYml5xBbcQPPZkNef2p0cvV1OiGo+RZccNlc77XvqysoYS+7HzbTwtFJID0ltv7Qv/KZ7I9Egtv1iV9L0Xw26e5cM/NCTksWxGOFkBBxd9t
 wbdzSorM
 S3SGt3V52bq8eWx2D6OnL6zhMKacc4KmumJoO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 05:23:18PM -0800, Jakub Kicinski wrote:
> On Wed, 12 Nov 2025 16:41:18 +0900 Byungchul Park wrote:
> > diff --git a/include/net/netmem.h b/include/net/netmem.h
> > index 651e2c62d1dd..b42d75ecd411 100644
> > --- a/include/net/netmem.h
> > +++ b/include/net/netmem.h
> > @@ -114,10 +114,21 @@ struct net_iov {
> >                       atomic_long_t pp_ref_count;
> >               };
> >       };
> > +
> > +     unsigned int page_type;
> >       struct net_iov_area *owner;
> >       enum net_iov_type type;
> 
> type is 4B already in net-next, so you may want to reorder @type
> with @owner to avoid a hole and increasing the struct size.

Sure.  Better reorder them.  I will.  Thanks.

	Byungchul

> Other than that LGTM!
> 
> struct net_iov {
>         union {
>                 struct netmem_desc desc;                 /*     0    48 */
>                 struct {
>                         long unsigned int _flags;        /*     0     8 */
>                         long unsigned int pp_magic;      /*     8     8 */
>                         struct page_pool * pp;           /*    16     8 */
>                         long unsigned int _pp_mapping_pad; /*    24     8 */
>                         long unsigned int dma_addr;      /*    32     8 */
>                         atomic_long_t pp_ref_count;      /*    40     8 */
>                 };                                       /*     0    48 */
>         };                                               /*     0    48 */
>         struct net_iov_area *      owner;                /*    48     8 */
>         enum net_iov_type          type;                 /*    56     4 */
> 
>         /* size: 64, cachelines: 1, members: 3 */
>         /* padding: 4 */
> };

