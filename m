Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E824DC83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 16:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77F656B008A; Mon, 28 Jul 2025 12:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72FB66B008C; Mon, 28 Jul 2025 12:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7396B0092; Mon, 28 Jul 2025 12:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49CCD6B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:56:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EBEE2133AAD
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:56:44 +0000 (UTC)
X-FDA: 83714277528.20.EF4742A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 97F9B180007
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:56:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ui9QGaq5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=p8NH4+hy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ui9QGaq5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=p8NH4+hy;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753721803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=T4hxrER/Y5bQt1JVTtC7jjVd6hI2iYvgAd3Nm1Rz0kY=;
	b=EvE43PeM1Xh3UV2Hd6UOKib6FWTJ4rnY26GcEsUuqWPy6u2zGYt+uZFyRPEL5tJqPVjf8H
	NZmWk6JLdIduGDl0mHpxB8pPfp7JekDD5zhZKfypdFtDa2I6l9e6W+ZOWog63kSIii43KD
	Pznl3dN0tDCophgCRSbl7IwcFS2/QJA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753721803; a=rsa-sha256;
	cv=none;
	b=8QDi6Cht3wcRQ4pkSXBT9KIfof1crE378uZbLcR1ODCwjz5XNvQMI+6Lax0SDWnDTf9DMZ
	H3CUWG6en+1a7lndk0LzYT9FXBjhNrc/kMiil5yVh8jmu045/rXscp84/QPDvN4LkLpQWP
	tHfDt/0ee3kjsfgFoDn+30yYZEG1KI4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ui9QGaq5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=p8NH4+hy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ui9QGaq5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=p8NH4+hy;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 032DD21235;
	Mon, 28 Jul 2025 16:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753721801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=T4hxrER/Y5bQt1JVTtC7jjVd6hI2iYvgAd3Nm1Rz0kY=;
	b=ui9QGaq5b73c0I5teTjwg02Y+cUSwq1e5Z0ZKX2xNLJhf8US8Ae1tMtozgTyE2icr1KKjp
	QqPGMXzriKfQoyyu4wGXRAQAc+3AcWgIvEn0ePS5VDOzsXYR/Fs/NqywbaQ9tM2DAAuN0K
	ebLgecfYmKNeqt0irMID2cNN4JUE3TA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753721801;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=T4hxrER/Y5bQt1JVTtC7jjVd6hI2iYvgAd3Nm1Rz0kY=;
	b=p8NH4+hyBGl8oORcTjkZLCeMBX4hUOhTCNX8ygV1yzMMk2clU7i20L2qKX+emAozrVIcmc
	kmX7ESWYvR+vqPDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753721801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=T4hxrER/Y5bQt1JVTtC7jjVd6hI2iYvgAd3Nm1Rz0kY=;
	b=ui9QGaq5b73c0I5teTjwg02Y+cUSwq1e5Z0ZKX2xNLJhf8US8Ae1tMtozgTyE2icr1KKjp
	QqPGMXzriKfQoyyu4wGXRAQAc+3AcWgIvEn0ePS5VDOzsXYR/Fs/NqywbaQ9tM2DAAuN0K
	ebLgecfYmKNeqt0irMID2cNN4JUE3TA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753721801;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=T4hxrER/Y5bQt1JVTtC7jjVd6hI2iYvgAd3Nm1Rz0kY=;
	b=p8NH4+hyBGl8oORcTjkZLCeMBX4hUOhTCNX8ygV1yzMMk2clU7i20L2qKX+emAozrVIcmc
	kmX7ESWYvR+vqPDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC618138A5;
	Mon, 28 Jul 2025 16:56:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rxp3Ncirh2hBQgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 28 Jul 2025 16:56:40 +0000
Message-ID: <450d3876-90a9-4b1c-8d73-62ac19048991@suse.cz>
Date: Mon, 28 Jul 2025 18:56:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab updates for 6.17
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Pedro Falcato <pfalcato@suse.de>, Bernard Metzler
 <bernard.metzler@linux.dev>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 David Howells <dhowells@redhat.com>
Content-Language: en-US
Autocrypt: addr=vbabka@suse.cz; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSBWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBzdXNlLmN6PsLBlAQTAQoAPgIbAwULCQgHAwUVCgkICwUWAgMBAAIe
 AQIXgBYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJnyBr8BQka0IFQAAoJECJPp+fMgqZkqmMQ
 AIbGN95ptUMUvo6aAdhxaOCHXp1DfIBuIOK/zpx8ylY4pOwu3GRe4dQ8u4XS9gaZ96Gj4bC+
 jwWcSmn+TjtKW3rH1dRKopvC07tSJIGGVyw7ieV/5cbFffA8NL0ILowzVg8w1ipnz1VTkWDr
 2zcfslxJsJ6vhXw5/npcY0ldeC1E8f6UUoa4eyoskd70vO0wOAoGd02ZkJoox3F5ODM0kjHu
 Y97VLOa3GG66lh+ZEelVZEujHfKceCw9G3PMvEzyLFbXvSOigZQMdKzQ8D/OChwqig8wFBmV
 QCPS4yDdmZP3oeDHRjJ9jvMUKoYODiNKsl2F+xXwyRM2qoKRqFlhCn4usVd1+wmv9iLV8nPs
 2Db1ZIa49fJet3Sk3PN4bV1rAPuWvtbuTBN39Q/6MgkLTYHb84HyFKw14Rqe5YorrBLbF3rl
 M51Dpf6Egu1yTJDHCTEwePWug4XI11FT8lK0LNnHNpbhTCYRjX73iWOnFraJNcURld1jL1nV
 r/LRD+/e2gNtSTPK0Qkon6HcOBZnxRoqtazTU6YQRmGlT0v+rukj/cn5sToYibWLn+RoV1CE
 Qj6tApOiHBkpEsCzHGu+iDQ1WT0Idtdynst738f/uCeCMkdRu4WMZjteQaqvARFwCy3P/jpK
 uvzMtves5HvZw33ZwOtMCgbpce00DaET4y/UzsBNBFsZNTUBCACfQfpSsWJZyi+SHoRdVyX5
 J6rI7okc4+b571a7RXD5UhS9dlVRVVAtrU9ANSLqPTQKGVxHrqD39XSw8hxK61pw8p90pg4G
 /N3iuWEvyt+t0SxDDkClnGsDyRhlUyEWYFEoBrrCizbmahOUwqkJbNMfzj5Y7n7OIJOxNRkB
 IBOjPdF26dMP69BwePQao1M8Acrrex9sAHYjQGyVmReRjVEtv9iG4DoTsnIR3amKVk6si4Ea
 X/mrapJqSCcBUVYUFH8M7bsm4CSxier5ofy8jTEa/CfvkqpKThTMCQPNZKY7hke5qEq1CBk2
 wxhX48ZrJEFf1v3NuV3OimgsF2odzieNABEBAAHCwXwEGAEKACYCGwwWIQSpQNQ0mSwujpkQ
 PVAiT6fnzIKmZAUCZ8gcVAUJFhTonwAKCRAiT6fnzIKmZLY8D/9uo3Ut9yi2YCuASWxr7QQZ
 lJCViArjymbxYB5NdOeC50/0gnhK4pgdHlE2MdwF6o34x7TPFGpjNFvycZqccSQPJ/gibwNA
 zx3q9vJT4Vw+YbiyS53iSBLXMweeVV1Jd9IjAoL+EqB0cbxoFXvnjkvP1foiiF5r73jCd4PR
 rD+GoX5BZ7AZmFYmuJYBm28STM2NA6LhT0X+2su16f/HtummENKcMwom0hNu3MBNPUOrujtW
 khQrWcJNAAsy4yMoJ2Lw51T/5X5Hc7jQ9da9fyqu+phqlVtn70qpPvgWy4HRhr25fCAEXZDp
 xG4RNmTm+pqorHOqhBkI7wA7P/nyPo7ZEc3L+ZkQ37u0nlOyrjbNUniPGxPxv1imVq8IyycG
 AN5FaFxtiELK22gvudghLJaDiRBhn8/AhXc642/Z/yIpizE2xG4KU4AXzb6C+o7LX/WmmsWP
 Ly6jamSg6tvrdo4/e87lUedEqCtrp2o1xpn5zongf6cQkaLZKQcBQnPmgHO5OG8+50u88D9I
 rywqgzTUhHFKKF6/9L/lYtrNcHU8Z6Y4Ju/MLUiNYkmtrGIMnkjKCiRqlRrZE/v5YFHbayRD
 dJKXobXTtCBYpLJM4ZYRpGZXne/FAtWNe4KbNJJqxMvrTOrnIatPj8NhBVI0RSJRsbilh6TE
 m6M14QORSWTLRg==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 97F9B180007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: fgcfs375huyrmu8od8b8jnxpq43cfcog
X-HE-Tag: 1753721802-241010
X-HE-Meta: U2FsdGVkX1/fLBuAk8BAN4Ow+NRtkt07z2IfxIRMY4RzvK939GgtRivYaM8coE0YNTHkW/G4EmBZGzRhOMFvlHFfnHZbvUi5x/kpNZQPfBCDiaYRyvJ1RoRf0o/TU5qREKUYxh+EZmU7Jif9IZQimR9hLEkesU/xSSMCu6/CdSED1rtIOgZJ41oEiLEo+iOT9Cr4Kj5FCbb4xTSCs1FTV2LWLbrLSC4MX/KWOsxOIJTb3z/QkLTLWiNc3VXZ3TduiJhjkqq8JVShQT19h8eg7qtRLhnqGV3VxiHDZXWeQCWY7UAOIVi5RsOZMJPrMe73AO8vDTI97gxhx6TZWDv6EYdw1M0CGtNCObipSh8f1b0qXU5vOUcgsVzH5ybsH9rksWYhQyo+blOWoDFN98l6gBxS/6DTRyVsjHmr2jrCOsAXY4pjIFQQHctT5DHlofHdK6O8aG1cN3DBEwRn/ADUV2quW/tWoYxQEZzKHjG08UKOSW0OjlJb+lAUzrxAGH0hsD7ZSATvR/pJLzq1NWcLnbmqui7AtNicWwPVVwu3nUbKtOKqJ8kLh4p3lpt+7hA0AUeeqG7sx5bJ0IDrTaU9wup8hnm9E38+0R5dtBn/6280320eHHbQ07H8nYA4cM/Za2Icz0WPw2SWfj6d+SiGswZUSoF5o3W/hYVIvTy0iBd4UWLNANWyPAnBspDddkyuvsnrt7k56KT/6b26MhlWTcylOYQ0/cNtVDfb0HYvw+EvGzoYu6/MmUmy6BTpnJxLRGQOCNq1kMwIxdrycJz2Z5VzvF3z+McnG54TPoCfX4KemW1EEhSs84T4hKkkdGaTpeuAllufWV6L2Mt6QpL9wUZDDOmXOJoCosdzO2tQXzMILPJF60/dtdk0SQzG7YpB8FFICZKShLaevvb3ys4NcZNvRSW0rVz8m6lYUhsvY+W6mL/mpItynnhrtBhkgYo8gZzQky456Rr4j8hPnCy
 U8t7ezBB
 Kj9YVzG1tL4oL2D0rJzg1363eNSpbmMOWcBSBOWxVhSDdocQQocQeiaqmROAFjgm0BlL10S0sp/BigC1m7GjIpdKOVCLAqlu0mY6fTs3AZT3zUn75ZyY/NpXQXKXxYrbEQ58ewRzgZfI+eqY87IKSqE7LLLD6bLnkLOzBH8A7i/gpBEFh/nsxlZqmLhFKUGeJFmx2mwV2Hu9IXVrOxO/QeA42+HJtRAWLaEL6M610q6iqs4+you/Gs3Xb8U9SlmGUyajzZIGyoO4Sjwqw1K/YKzM+cAGYu14MFxjT3j00rP0VuVl3lGxgHC7DctTqUeG0UNvRiFrLkcMTWYG628wretU5YRJsglGrGAZxC0+hpVJl+GXOtteoZ/BHBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.17

We've hit a last-minute snag last week when lkp reported [1] the commit
"mm, slab: use frozen pages for large kmalloc" exposed a pre-existing bug
in siw_tcp_sendpages(). Pedro has been fixing it [2] so hopefully that will
result in a PR soon, which you can pull before this one - or perhaps take
the fix directly. If that gets stuck for some reason and taking the fix
later would be unacceptable, I can do another PR with my commit taken out.

[1] https://lore.kernel.org/all/202507220801.50a7210-lkp@intel.com/
[2] https://lore.kernel.org/all/20250723104123.190518-1-pfalcato@suse.de/

Thanks,
Vlastimil

======================================

* Convert struct slab to its own flags instead of referencing page flags,
  which is another preparation step before separating it from struct page
  completely. Along with that, a bunch of documentation fixes and cleanups.
  (Matthew Wilcox)

* Convert large kmalloc to use frozen pages in order to be consistent with
  non-large kmalloc slabs (Vlastimil Babka)

* MAINTAINERS updates (Matthew Wilcox, Lorenzo Stoakes)

* Restore NUMA policy support for large kmalloc, broken by mistake in v6.1
  (Vlastimil Babka)

----------------------------------------------------------------
Jonathan Corbet (1):
      slub: Fix a documentation build error for krealloc()

Lorenzo Stoakes (1):
      MAINTAINERS: add missing files to slab section

Matthew Wilcox (Oracle) (9):
      doc: Move SLUB documentation to the admin guide
      slab: Rename slab->__page_flags to slab->flags
      slab: Add SL_partial flag
      slab: Add SL_pfmemalloc flag
      doc: Add slab internal kernel-doc
      vmcoreinfo: Remove documentation of PG_slab and PG_hugetlb
      kfence: Remove mention of PG_slab
      memcg_slabinfo: Fix use of PG_slab
      slab: Update MAINTAINERS entry

Vlastimil Babka (2):
      mm, slab: restore NUMA policy support for large kmalloc
      mm, slab: use frozen pages for large kmalloc

 Documentation/ABI/testing/sysfs-kernel-slab        |  5 +-
 Documentation/admin-guide/kdump/vmcoreinfo.rst     |  8 +--
 Documentation/admin-guide/kernel-parameters.txt    | 12 ++--
 Documentation/admin-guide/mm/index.rst             |  1 +
 .../{mm/slub.rst => admin-guide/mm/slab.rst}       | 19 +++--
 Documentation/mm/index.rst                         |  1 -
 Documentation/mm/slab.rst                          |  7 ++
 MAINTAINERS                                        | 17 +++--
 include/linux/mm.h                                 |  4 +-
 mm/kfence/core.c                                   |  4 +-
 mm/slab.h                                          | 28 +-------
 mm/slub.c                                          | 80 ++++++++++++++++------
 tools/cgroup/memcg_slabinfo.py                     |  4 +-
 13 files changed, 110 insertions(+), 80 deletions(-)
 rename Documentation/{mm/slub.rst => admin-guide/mm/slab.rst} (97%)

