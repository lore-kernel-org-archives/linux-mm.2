Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57461CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 07:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A46F8E0001; Mon,  8 Sep 2025 03:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 754EF6B000C; Mon,  8 Sep 2025 03:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6433B8E0001; Mon,  8 Sep 2025 03:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 510F86B0008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:56:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 289441A09FE
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:56:22 +0000 (UTC)
X-FDA: 83865325404.27.0728E8E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id B6AE318000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:56:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YSlRAU6D;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GHMMiDL7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YSlRAU6D;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GHMMiDL7;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757318180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qM4bq6PnJkBcjlPI/Ktkkc/3++g3plbsOJZEHlsH588=;
	b=LYv3TXdLt5hBtiAWcZVY2xY7AsSQ8ywEJB6W7K+VJyttrkg/hAW+mNwznj4zYjw28nr3gL
	rfUC6aMr8su6H/4wbfF2nVsNcDnaMwGUMVFjaCU2paoEsgU27tHy4ntOt9xUY3yGt78ERv
	wurOUOcSeRQ/kXQgEdhW8RQHHSjENnA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YSlRAU6D;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GHMMiDL7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YSlRAU6D;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GHMMiDL7;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757318180; a=rsa-sha256;
	cv=none;
	b=LU54tbcIIVDsBPYE4mQRZz4UOPTFQ7qaDDCRBi8momHMvLLro/M2Sgw3vuviaNgxTePeYm
	ueZtWyt4kxckeNh6DjPbWEanEOCS14DfYZ5L50wJ9KVRdETLOktIpkozqetNzfRhTCvfgL
	QkLnDwsHurDvgZdY6pH9fg2WFqUOANQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 652C85CC39;
	Mon,  8 Sep 2025 07:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757318177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qM4bq6PnJkBcjlPI/Ktkkc/3++g3plbsOJZEHlsH588=;
	b=YSlRAU6DSmqdTWajfOxYVrLJq+x5B25SpQgvijT0IYpAoN0+s71vY/QcPlbuYOb5Jf5DCO
	gL7ho3NI4IRSHG/SKJ8toqsqGBb2nSDHNO7d6M+0IXbMs5OzrIrKCQvMFgbyXjrNIlZP1J
	fbI0A3ffiVlWrzpguxbK4xa8S+WCNkk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757318177;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qM4bq6PnJkBcjlPI/Ktkkc/3++g3plbsOJZEHlsH588=;
	b=GHMMiDL7NKd5CTaRDxZ+PD4xUenbDQb8QpBEoHng7qjV9mZhayLPQPyHDrArWv33++fwzq
	mscrX9m3JTEqk1BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757318177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qM4bq6PnJkBcjlPI/Ktkkc/3++g3plbsOJZEHlsH588=;
	b=YSlRAU6DSmqdTWajfOxYVrLJq+x5B25SpQgvijT0IYpAoN0+s71vY/QcPlbuYOb5Jf5DCO
	gL7ho3NI4IRSHG/SKJ8toqsqGBb2nSDHNO7d6M+0IXbMs5OzrIrKCQvMFgbyXjrNIlZP1J
	fbI0A3ffiVlWrzpguxbK4xa8S+WCNkk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757318177;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qM4bq6PnJkBcjlPI/Ktkkc/3++g3plbsOJZEHlsH588=;
	b=GHMMiDL7NKd5CTaRDxZ+PD4xUenbDQb8QpBEoHng7qjV9mZhayLPQPyHDrArWv33++fwzq
	mscrX9m3JTEqk1BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 42FDD13A54;
	Mon,  8 Sep 2025 07:56:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Pa8DECGMvmidSwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 08 Sep 2025 07:56:17 +0000
Message-ID: <fbfc21ab-c947-422d-94c6-0db897ee25f3@suse.cz>
Date: Mon, 8 Sep 2025 09:55:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/21] SLUB percpu sheaves
To: Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org, Alexei Starovoitov <ast@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wx7hpxgr9cx87dw9h5nsx59dmg1zdbcz
X-Rspam-User: 
X-Rspamd-Queue-Id: B6AE318000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1757318179-813087
X-HE-Meta: U2FsdGVkX1/ULhePGzltwMp+rvDlDeHvD8sy+EAENRYhWB78CKbFEuR1oIHu5hgGWusaudVcN161ysbyNBBzDPoI2vETjpV4MrO3vPPwkD+UQbarSygOj290nskaFWcAtdGnBa8UekNZrSHFL/gBWdG8SsZbtJb4d+nQYbss3nm419DCNdWE08f5IdmdoV65M9Ef67T7ZnnZejEdHyAR8WSCdp6vvrMOQCETdRX3yFNW+7BVlGksf68bVXHjNyCT/CwB9KMWmnBeWkRwCZ9uliEHZCB1IjxOU93wVfShD1HWTtHV+svYJ81k4JL0czUb6X28DYwCJFktRCb97vmU2c6+Zb614tL1MBV1MOSCk80rjJ/EMmtfz7sU7HeudXI4G9q/Wbpl9OZrNmTIbeuRJpGCmXWYUFsrGTHuUwP4QZHeXVMVMr3g26Rmg48Le2k0pGH5VFx/EEVqyzV/OsG2YT7un5wVlusuYf3ZEHOxjn9YxpZOc8YNJLA8aHkp3uzMViuqC5omUJqS5dLcP0iG9uaGls8QjBp1PicZTaHeF5aTNTaWkfhV8s7O3JHXotm72bEnypLTh3cjAZqAvYwhfiYyM2biQSe+7cVBuMStuxIa6opK/2gO+fQ0wHZOuW1LGpt4fqWReOxtAsX5uYR0iTAv4iuW6xsV7EMimT1oth9cR4kp14KrnfqRBxNHaxeESA5gWW/tzxIA2F2W//whlZEx/vDdvwNraGCQdSOEbG+38UWaoG5aOVRFrT6jQVc9WwSpMQYrmeOTyHK0unkXXw5EfsyXX0Gb/JzRwfv8eMI7G4rORnlmTL/GithkhwvsXl/+VRGEEIQzk7blx3qlevBWwXRZ8GLG108jSoEKddB6NngfW86ZAuR4dC9KDwHXxDov8I9kU7V0T0qtk47JCrTzqObB9bVIQT8vZznsblZi2oKfyDjiPNjxRoIupDT+zPbMPUo2UoOTa5y0uej
 90RMUnsO
 s/j2ytBko9TwsNQaVA9iphJ3myZHJrPhirg8t+kUGGLhNVtPgRGGTHnQHjj8fUIni5qJgp4QDxjDFB7HjXs/3TGni9seVvNU95ETCfdtoPuBn57AWvi10wJr15yELJI0Q1Kl8uFkPFv9s4Li4JHdAcVbhzHoQ7ufYCKL6jF97QAYFEmJvoRVe3pE1gwKnuInMiXSly3yXvUbpQLmIQmif+8pswf9R1WPQPC+oqwHaYfDDwVdEUH2UkOwjW9ECoidTxmDaDwuqaQheMM8Ku8XdFfMJ/EWke/XzwZ6cbXpj6N6+OAOhTrQj/utsFtqdZ3I0dc6IKZPryVV/NZr5JKFsy2+dNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/25 14:59, Vlastimil Babka wrote:
> Hi,
> 
> I'm sending v7 as there were some non-trivial fixes needed since v6. I'm
> including back the maple tree part that I sent separately the last time,
> as some reordering between both parts was necessary to avoid
> intermittently breaking the userspace vma tests. See the changelog at
> the end of the cover letter for details and links.
> The v7 will replace+extend the v6 in slab/for-next.

Liam made further changes/cleanups to the maple tree side, mainly the commit

76fcafc3894f ("maple_tree: Drop bulk insert support")

but it affects some later patches too due to some conflicts

for now the result is here: (and in slab/for-next)

https://web.git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slub-percpu-sheaves-v8r1

I don't want to spam with new vX too often, so will send in 2 days but can
can do earlier if there's interest.

