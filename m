Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92457C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 11:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA316B04B3; Thu, 13 Aug 2026 07:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9A656B04B5; Thu, 13 Aug 2026 07:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989AA6B04B6; Thu, 13 Aug 2026 07:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78B4D6B04B3
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:11:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F8BF80585
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:11:08 +0000 (UTC)
X-FDA: 85095979416.16.736DCA8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1368140004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:11:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TnGZipEp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Q3nLSKTB;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="JlLhO/E5";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vHAxjYR6;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786619466;
	b=ldAFHqo2efb6sK/sVlnc4IDma7ZCZt1pHhIeRD6ECKoLO74eXAEbroW0DX3wtTPCaLheHY
	G5em8mnsZvZOkHp+25FzhoVSoHDg3NUgCpfJSuQaAsoMllO5wvPXxhh7vzaNvZ/sKqOBIg
	ViCi3s0tyJ+g8Kgt0NXXR9K5SvgjAbI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TnGZipEp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Q3nLSKTB;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="JlLhO/E5";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vHAxjYR6;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786619466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g9DLtOqz/kvw6uTXCnnGseLONncfYG1BbS7hBn1gS5c=;
	b=QMyzljK/OpkLnSvEySimH/rP6ZlVnrd9TJlimO8mj6T4iu4lPOt0Kpcgx639qWhXUmoA9y
	0ck+I/RFxOpwCKXHJ9JOlYThSzuAPnIPutGj4kfKhSwlPnlnxTcBGT7LggMqkCuf7wL7aa
	yueP/RTKcvAoUGjMdmfEw/zKUAcnKz4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8EC7282849;
	Thu, 13 Aug 2026 11:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786619460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g9DLtOqz/kvw6uTXCnnGseLONncfYG1BbS7hBn1gS5c=;
	b=TnGZipEpXvOMDMxm+p7n6VmVm9gNk7OnND1aUBQ3O6TXn972g/wpMpOiOfL3XL96EQLR/6
	OXEElOz/FVz/ITfq/dLPlSol2kX90bLwKrGPbTMT5Ys/BF4opaEtiVeDdr8kNMuom3I0dT
	iFhI0isOjjKy1igGDyTrZ8yXhgrNe0w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786619460;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g9DLtOqz/kvw6uTXCnnGseLONncfYG1BbS7hBn1gS5c=;
	b=Q3nLSKTBtwXC7EyRvHr5vGVxtXs4afFuJqlBwLqpaUA24/KFFK1Fante8nxEDWWFGQNK4k
	wl9N9mOff/D03ICQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786619456; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g9DLtOqz/kvw6uTXCnnGseLONncfYG1BbS7hBn1gS5c=;
	b=JlLhO/E5yoQSolyiIONWXVN1nBp8Uo4HLLIubjGR/QEpbbNbmCaeL0m6Ed5sQaFIgr3Ez5
	3tlbp+II6/tXdxhjdC7kDMVcwBCLs7KO82pGkKDbuRxw3aKuePxcJop9GkRGtHEfDnnevL
	t1dgNxn6xGWCrN45H/r/L/nWGncGgHo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786619456;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g9DLtOqz/kvw6uTXCnnGseLONncfYG1BbS7hBn1gS5c=;
	b=vHAxjYR6VVoC8vsCsZXHUwQgYPl80XBnKxKN41m1GYCLg2OZ/lqDMuMlHn2C9fqAmrBbFL
	JEWltbN13qRmuFCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9434C77DB3;
	Thu, 13 Aug 2026 11:10:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ruTxID+mfWrsBwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 13 Aug 2026 11:10:55 +0000
Date: Thu, 13 Aug 2026 12:10:53 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>, 
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v9 15/15] hugetlb: replace hugetlbfs_read_iter() with
 generic_file_read_iter()
Message-ID: <an2mKH_VQlfEYqcr@pedro-suse.lan>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-16-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805210557.1118966-16-willy@infradead.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1368140004
X-Stat-Signature: 71tamwk5fkwqp5reufbxzzixufdu6hy1
X-HE-Tag: 1786619465-903014
X-HE-Meta: U2FsdGVkX1/GynlD21LccyK+vZcy6svOo2VIlSoyeHmp/d1WRXAlWCZno+GLdier2w20AmDU6iJEirrEyX3XoXOktgprwP3TP8R4x7/cTfbPLO20m2SYxzSYEK4EUms5IOckEg8Y53TEfd1Xr2bbq9dcil5I5gtdNLhBwdlTfKMqBKN76VbcH722WmQbR+K7YYNASyNWwp9Y30Dlv2nnuLGf9Jd6eCi8lAlsFwf7wCUSY0kjhcQvdx1qL+6XQKh0vhqYPP6tuslPlbkQv743ZbPxq6TM4L84iyEa/2vuxvy1/tA/6VV18vw2Jx7hRC+FoRlWIblUUWmgvn1TL4nBfBS2QJSE83c3IOOLODxPLPLRsowmdfTF8zucXr3CoSOvI86kZJlra4xLFKljdVjex482ua9as/ZLW5wDveRaQxPhlR10IkSsxWXBZBtzZqx5jOBLufTTYWWdVxwP6Iyjn7Jc6/FsZIvEEHlUYVhCE8nDA5XfNZYqwewgPXqCLrVYA80HXou2co/ZNN+L+pJPo6seKMNI7oeF4C2LJDyPhfimhrfhOlzKivkSEAu5kaqnaHyXyWWeG7NQ+FG506uP8lLuNTV+tQlXT0vOsdUNSfgkS5xYcNhSkZFC0RTDqayHOmoQzCZHITEszYRSXoFuBPYJDBiliDbcAl0DmuA1okNbBIa23gGaFVE6A+mfHLQ+yzIkYAtWipOxPcVeKup5GpYmvBWFZAjGc7jy1QRHrYUYmP5H7lTdJyKLIoeEMOWPDcTKIYjVrQJBplhoYCNZNUa2rt+76wtVMlkVLN3q+SYuGQC8IXQWsrW8pNi6cRIFWzhE7iwqfQPBrotlbYI1TmFKhRj662Qn6ealKWzxEBxvYSCk/IcFIkYBm+MDLV13yLgdceRlbOFeV/w+deSPHaIRMa8zgOMyfWegFqz6fasiWJGZCjiyW8ecmJapUibN5LzSkxml+X1KhjLQCOa
 A7tyxBzJ
 XX8aAMPlcDw0iBIqgmWsTkmkOsc+BLJWl5hoaImL+xhQSl03x283Yn7DhwFx093zpFr7ULBrue2OTWP73fUJSWboC4RFiRhwFit/AiYhg3BjCUwnb56hEHLLtX4GUSyl/YjU521e9vFL0VyjC8KWBX+IVN6CY788dcn2CJ08cKDkmdlLlReuzyM5JNlgcCZcj1t4fAac446dbP7ozfniODIR/GnA4zurs7Duwg9Y8e0uOmZXcvPbya/3g/+5q31dyEEvQ7bbXVtNoRrrNkR6iWrmELWDgSD5qB0EbFJ3KkyP0+zOxLXob6IUkOOYhZxNl+lkhLxcwXber/9U9qBSGe8btFsLp1QvgPvThWLw3TGj1565m1jFcob4ZgzgXB/IWuZVdbtiIuElVPqDbJT7RcMfd10suZ4BKwm84RmTDb2SSi9jjXfxQE8sUqoGYqYPTWtOn3WuIZEBXbCbGSjMyvu3pg6eqz9Zkx2x4YYdJT34dW6rOFWjxzlKJ4cU7FOOWS73L09Vw2J8tZraaViLKiKSmTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 10:05:55PM +0100, Matthew Wilcox (Oracle) wrote:
> From: Jane Chu <jane.chu@oracle.com>
> 
> generic_file_read_iter() now handles hugetlb poison, hugetlb page
> size and missing folios correctly, so we no longer need a separate
> hugetlbfs_read_iter().
> 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> Co-developed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

Awesome!

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

