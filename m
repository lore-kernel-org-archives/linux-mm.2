Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAB8BEB28F4
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 08:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D4946B0089; Fri,  6 Feb 2026 03:59:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BF136B0092; Fri,  6 Feb 2026 03:59:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 197666B0093; Fri,  6 Feb 2026 03:59:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 081B16B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:59:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A72DA1C652
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:59:06 +0000 (UTC)
X-FDA: 84413432292.17.0D45931
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4BCC4120007
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:59:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J3Z+3PGc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=l9tEvGTB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J3Z+3PGc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=l9tEvGTB;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770368344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=g/sklVOi2ACPjcYdwO/npVOJQMsPmOE9LkImB0ClTW4=;
	b=ebH8lygYZZAFsGkFrIt5BWp4wy5q0efnNtwqj+H9UX0ZvtIQiSQ4iRSr2C18MZNBPMqi0o
	AZ7qvSPzjULjuwkGrMaJeuvwslVZHPRRFvOLQChY8maXo76wOchYm2VOYnH0UZ7Cuw8lcQ
	hWMu340voKQVf1ifxMMhHpiuJyr/DSw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J3Z+3PGc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=l9tEvGTB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J3Z+3PGc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=l9tEvGTB;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770368344; a=rsa-sha256;
	cv=none;
	b=hXE7khiM7wlCI4HVVWQ16XsgLAxk9hwKpF4yLDpFSdKijASmfONnoBssAqepdA4SxrORTF
	Ym8nuiCHtsj9xzIyYWtxFJWPZjOeSTJy0wE/Hv0HtVyt/kCyfrcI6aZgF7aqcsmeuYw7P1
	qMxyjRIuSor94ki3dmNgr9zSEGAXj8k=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4DADE3E6E5;
	Fri,  6 Feb 2026 08:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770368342; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=g/sklVOi2ACPjcYdwO/npVOJQMsPmOE9LkImB0ClTW4=;
	b=J3Z+3PGc6NghLwlvW0pEt5HKRYQxhuYf+mnIuF9us4nNlFCiLE1PM7SE0M5UBGq8udDN0T
	CXPVlaU41QvElam6uYplyn3hQbIebPDKQTlfaRp4E3HrI1Wdd+dw+8r3etcKy6ZH/ri8xH
	UELM02vMXHL2qrQVYv0N8lQEHUMb4Sg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770368342;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=g/sklVOi2ACPjcYdwO/npVOJQMsPmOE9LkImB0ClTW4=;
	b=l9tEvGTB1xqLURGihKsObBZD3T4M2r1OFRUHiHkd78q0w8I6ATOh2QiTwXzPuM6vuQRi3u
	eAWu1J1I9h4XHVDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770368342; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=g/sklVOi2ACPjcYdwO/npVOJQMsPmOE9LkImB0ClTW4=;
	b=J3Z+3PGc6NghLwlvW0pEt5HKRYQxhuYf+mnIuF9us4nNlFCiLE1PM7SE0M5UBGq8udDN0T
	CXPVlaU41QvElam6uYplyn3hQbIebPDKQTlfaRp4E3HrI1Wdd+dw+8r3etcKy6ZH/ri8xH
	UELM02vMXHL2qrQVYv0N8lQEHUMb4Sg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770368342;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=g/sklVOi2ACPjcYdwO/npVOJQMsPmOE9LkImB0ClTW4=;
	b=l9tEvGTB1xqLURGihKsObBZD3T4M2r1OFRUHiHkd78q0w8I6ATOh2QiTwXzPuM6vuQRi3u
	eAWu1J1I9h4XHVDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1BDB13EA64;
	Fri,  6 Feb 2026 08:59:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MlUNBlathWmFXAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 06 Feb 2026 08:59:02 +0000
Message-ID: <c5f2a4f2-8156-4c4a-9f28-0fe129893e2a@suse.cz>
Date: Fri, 6 Feb 2026 09:59:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab fix for 6.19-rc8
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 4BCC4120007
X-Rspamd-Server: rspam07
X-Stat-Signature: pqgzf59gcnfuibfnexgxpoq1i9ehaw3s
X-HE-Tag: 1770368344-8748
X-HE-Meta: U2FsdGVkX19eF5N8GgKsk7ZStQ4M2b2t48FA3F+S5KeAEAvKT7HKIWMWoF6o8Eg3dzDhoXBkYMSOz+K+SaNOJzqK7ft9R4ywZ1rW6BBKt0EPT5nRz6PDasW1hnLsBGBIjcYrJ9MktSvTxrHjgKYBb4QZCehrx6jWTsj8BNaeDNWm0sTdWbIwkVmLmpw/ysgdDml7F2u4v6OCtU12c55tXscZ9H12FzNZkWo/M06EQis0126raxmu8yYcitnc3Vm9o31tqWVvaK7Gi7oienLr5DR/N7/remNFzL8rMIHQvc58mkudnpmrL6Pudbevs5x3ihkeJvdKf1ika3MVeEhK+hd47Yqo6Ohsng+VQIBJJhsFnXMRgdwW9ZdSpo0xVovo718ZA/06HysgQ3am0NOqIL3eiNA+vR2DaK/tDw/LS9OdiHavp92Ynntdq3ihDX2xgUUZzGuU+a3IYDsUvTlh3NxQz8ZlDNAHZ5h0krh1sZOwIRBJgYGT/rH5v8+eqZD5vUBa1dRAt+RKvNoGJqEmDfnAaMfyWc6TDLgDLzxoiJx1xgAUhUqGDCNiiMjVNV+4dASwKiN7nmHbt5dm9t5mgFd19/P5AFjR6UGePlU5s7y8G+Lrh28yQclqWtyQS7OkFXo+Hv7sqBOCGy4JDa3kJttOj3bAfQfTQzH4KYE8XUU/LKfLF/BTuirap4ewEZAxiPvN0N44WO3ztxTGI6vwSgdYUY2fBjaMyRADyy21zx05CXOiIh0OvcQdPUhNXlmOZAEIKGowtOK+f8xVHMPoYZbHRVxwB1+zZeKWX/Z98oiW5+hpd2L6Z+sCA6Qr6Z/m/MHG1R9VLHZpN2AAxyEktczZTRWVLlxavgazVKo+KZAL5UyFVqbYFUY8fiN0Sgnmb/DF8DAD39UUVUH+BQk7MJNPohsvQav68VTkbPu+VpR5krxZ8bIb1MfOhqefpZVE5WcfYfzGRXttHc7yk5z
 B6sYBPn7
 gcPiSjuqhQSnjuWOwBx1RZeJdN+Vgv7lgEgTEwyOWQbwmH73kwm7tiX98IY9wzDpP38ndQIID2LlR9lt09lcEKcWTQMLRr4FUEmvmwl/4e7Gd358Q/LiQ2r12TBeAUMYEwDCr+9JHwYlWit9IC7E7dD33ltNw+BChurIH5TSf68Oal6BDxnMf+br+zMNsxRtMcMo+WpfWKrH9oGHllgFkmPLPvnuiILGV1e02xCiHOedW1to1vSNyNpJOwArqopQVRZvVJXs1YXQpu/NfU6o/wrOVGf4ECjUJgmcib2Tm2snPIexKn1xQ+Ad4s2dpemgZLEC0tsBcWjxu1QEeU5BQh7O5a4fuLAvAEwf7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the slab fix from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19-rc8-fix

Thanks,
Vlastimil

======================================

- A stable fix for memory allocation profiling tag not being cleared when
  aborting an allocation due to memcg charge failure (Hao Ge)

----------------------------------------------------------------
The following changes since commit 99a3e3a1cfc93b8fe318c0a3a5cfb01f1d4ad53c:

  slab: fix kmalloc_nolock() context check for PREEMPT_RT (2026-01-21 11:34:18 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19-rc8-fix

for you to fetch changes up to e6c53ead2d8fa73206e0a63e9cd9aea6bc929837:

  mm/slab: Add alloc_tagging_slab_free_hook for memcg_alloc_abort_single (2026-02-06 09:51:08 +0100)

----------------------------------------------------------------
slab fix for 6.19-rc8

----------------------------------------------------------------
Hao Ge (1):
      mm/slab: Add alloc_tagging_slab_free_hook for memcg_alloc_abort_single

 mm/slub.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

