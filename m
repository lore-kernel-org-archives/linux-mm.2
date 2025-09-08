Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 976BECAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 09:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 039978E0017; Mon,  8 Sep 2025 05:31:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 011808E0001; Mon,  8 Sep 2025 05:31:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69718E0017; Mon,  8 Sep 2025 05:31:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1A688E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:31:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 740015C6DC
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:31:57 +0000 (UTC)
X-FDA: 83865566274.14.0B02B13
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 48DAEA0016
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:31:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wWhyBCxh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=c7Gqe+lB;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wWhyBCxh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=c7Gqe+lB;
	spf=pass (imf15.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757323915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o61tsFWUDkG/zUNQgu6FmGCrqpjF7iodqYCLGq3LTu8=;
	b=gJXY7VLLIGaEQDaR6ENuoyMTK/JEImhql2Ukey+YsVeGNZDu+S3zvVUJgvt/CqNkYjhugT
	pR6fb78aHIU7ZMqCDCSoDPB6t2LpuYEqHbqjxcilzy6zGv2qWZabSJFacQge//mfxyxXyt
	JC1FxU1Zt6sCL3u6ZZSV+xPeJCEhfz4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wWhyBCxh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=c7Gqe+lB;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wWhyBCxh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=c7Gqe+lB;
	spf=pass (imf15.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757323915; a=rsa-sha256;
	cv=none;
	b=uHEBlic8GhQSJpLNL3+ZRLr7g5Epv4s2vNRHMYdE1SRzIokOVrkP0amr5AyYCkAqSdZ3N0
	6tFViakQxbgrHdWwZQCLCEg1zZQ9WPz1po12wGaWuPoFUnKKJTh3Odi+vK8SoY7r9KcfEF
	e+uR7QVRnpVeqIKr05ynLhdf3T5ZIgw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 778DF26798;
	Mon,  8 Sep 2025 09:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757323913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o61tsFWUDkG/zUNQgu6FmGCrqpjF7iodqYCLGq3LTu8=;
	b=wWhyBCxhNpcEJdYhsdb1tnwhyS5jNN9phd0/OxdQnT2s14zj0bMWIDsFdsPLgYYnUuKv/h
	B8A5DQZImJl/ICgcJjqlfY7hdFk89K1xfciIHi7+7lDSptnhbaPORxCjUH+JkfYYhYDvXH
	g8RQuAVOuSIlI6m4Ni9wKkGdqnk1TE0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757323913;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o61tsFWUDkG/zUNQgu6FmGCrqpjF7iodqYCLGq3LTu8=;
	b=c7Gqe+lB+A+uI2xTWWG7bIeg2KewI9RGG2PgJxuV7unGuoYMDUQ1dzAJEzYD+5pMNEoC1l
	F00gB09cdoL9D+DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757323913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o61tsFWUDkG/zUNQgu6FmGCrqpjF7iodqYCLGq3LTu8=;
	b=wWhyBCxhNpcEJdYhsdb1tnwhyS5jNN9phd0/OxdQnT2s14zj0bMWIDsFdsPLgYYnUuKv/h
	B8A5DQZImJl/ICgcJjqlfY7hdFk89K1xfciIHi7+7lDSptnhbaPORxCjUH+JkfYYhYDvXH
	g8RQuAVOuSIlI6m4Ni9wKkGdqnk1TE0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757323913;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o61tsFWUDkG/zUNQgu6FmGCrqpjF7iodqYCLGq3LTu8=;
	b=c7Gqe+lB+A+uI2xTWWG7bIeg2KewI9RGG2PgJxuV7unGuoYMDUQ1dzAJEzYD+5pMNEoC1l
	F00gB09cdoL9D+DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CF7C913869;
	Mon,  8 Sep 2025 09:31:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gMq9L4iivmhaagAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 08 Sep 2025 09:31:52 +0000
Date: Mon, 8 Sep 2025 11:31:47 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
	jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 4/9] mm: hugetlb: remove struct hstate from
 init_new_hugetlb_folio()
Message-ID: <aL6ig-X5tpqvg66x@localhost.localdomain>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-5-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902124820.3081488-5-wangkefeng.wang@huawei.com>
X-Rspamd-Action: no action
X-Stat-Signature: so1o7xqmmqc9bg1n3k39usnjh1hercuk
X-Rspam-User: 
X-Rspamd-Queue-Id: 48DAEA0016
X-Rspamd-Server: rspam05
X-HE-Tag: 1757323915-106224
X-HE-Meta: U2FsdGVkX1/doSD/2pZ3Fx+AhGsBJsXurm3taQqzOeLiuqrzhoMydBYDyR71l255Z8msys3s9zw6HVqZ0RC39Wff7W0ekPdU/QunYXD3B2yIK2Jdkk7TCFmDbw51rojLqblcpSleF6+4Tk/ZgDR68/ykfWeZeq+sHVzv/LWWyypjMt5tfcmn7n7mekxE8UyKbZj57XxtMPcqGwNXIt+aVOgfbIgWicy2GBzzFJlh7LQjluhczFJ0yFgfKNK0Vo76S2iQIbRjnwbptdYe5c+Wok7nzmdyD1PYz4QBojuL/9uodMLFITgVrJe0THjrerjDHOAVxLPR7Auqx4ygkwWDBCyELpCqmsTARr+SqgKiWTSixAhf9JQqcAXdPqxIe0WJwMJ/v+SvumzyWaajKbyLxUnB+bzFUirw44Dy6f4DEvk9S0Geu9a8Ht0bqrv+bWI6hwXojk/WIxaO/5DWTy95d8hw28o2SpfCjd67BWzm9Ji+dUpSZDCdlNfv79x0oV7T+cAWciqIrSKoPLpjptNwl0Bin1GXaENeMz4ygXIYFUT+myLHGQSkl11XP3c98TyDcPSCvIgkfUT1QR0vy3it9wcQ+gDKQeJn6mgQnH2+zUlvbnWOW3oD+jWYYTjtZd+OACCwWC1xIbgwU9IoSlAbjlCg2dlVU80Qr2GDdvqJLtnkzSr9YLP8GfEbABX9qIrfwZ2oiAu7eOwbPppARQ9QeiRp+XSoDs+Utv5txOmsE/BAsvVEXBAe+3W3kcR/7i6KAOXs7+6wBhaBsjUurx0koSs+FLM4n0msDxBY9r07kKtdiol5oAcsEhw/lcP5XVSz1NUAMSfxwCeNu+wjrpv/uYMOJWeRMwqWNwJ7hnpi+oQN0vxX2Pu5cFmG2ssB9X/YA/antDx76WlnbcvcSnDasA7dJ+Th6wli7DAJFDZQ6QH98gbPfm+YMU9kta97QJ/bFbf6xMxRfXNruZ6/UKn
 j3SggVBm
 71DtV+eqTicQSgiwsoEeCXmYoazajn4AIdxlRlAGKDneTI5QUmt+WeJwujo7jvb/czvBXrPg8eOfkf/eV7o9DfF5Jbhq99sfgjcRCkdD9Q4u4nJ1A+SzxXPNaILZYANTl7WJRTQxTID0Hb2DMNx8RcX8EH/Fhz3Y/yug9uB5I8nFv8m3YIDPTCfDNrViMxljylP+dwemRbBNzuD8y7tO+PgJR7VAR1IuN+gTtKZVsmAVp9FE6AHbJZbaP5615BVgaWs5rD7YFPyXVYLJ+vqAEIGWBQPbT8/FSW5mAjN5T1Siu+g+y454gvIrUwD+c5EcktX41PoKE8wDJeYHIGFld+YkH6AnEDKlP5CfJo1JhxaCO0WajrUMfEEjG/1X7FjmEaQPFWhjjMbmKaM83xrGiinb1v3brOt6fnMJdcAQ7SRkP2IQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 08:48:15PM +0800, Kefeng Wang wrote:
> The struct hstate is never used, remove it.
> 
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

