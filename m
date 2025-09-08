Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22CE7CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 13:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812848E000E; Mon,  8 Sep 2025 09:40:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C3156B0027; Mon,  8 Sep 2025 09:40:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D9748E000E; Mon,  8 Sep 2025 09:40:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2596B0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:40:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0CC8014015A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:40:08 +0000 (UTC)
X-FDA: 83866191696.07.796B312
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id F34991C000B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:40:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gExlCJ34;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6Q04AI5v;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gExlCJ34;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6Q04AI5v;
	spf=pass (imf18.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757338806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m1x7WQ+EqaLnvvAVV5lTZGtx7g6zWqCmeBozDBQMbds=;
	b=oHzqRUogPHoXJLWn3Prh9u7e00VvEIpGMx3OS5Sn4kpRL5Q/LfwpkNXPsbRc0fbyrF8z38
	PMC4odBzbFNPEj34XLSqfzPDr9RjgxGdz/Tm3U+/CQhnIW9AmOyCAWhChjsw9yh4U19CId
	EGJe5naeRPT0SNgtbTegJsyZxGpstLk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gExlCJ34;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6Q04AI5v;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gExlCJ34;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6Q04AI5v;
	spf=pass (imf18.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757338806; a=rsa-sha256;
	cv=none;
	b=ZWGfedNxy73QZhxKAblcPtgZ7NXxzloqOwrzGEqFGeCxS3DEdlczvtk6tAzIoTtVBK8zJd
	cGEmSZYhUEl7EeH+d/7Xc7AByi2xqHEwgta7x+wp8TW1Uaf/hohWMSg4+IsTNCrbyP2InR
	LHBglK7IjPZw+1x/PWMgrU8SsXJ6bNw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 567BA274CD;
	Mon,  8 Sep 2025 13:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757338802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m1x7WQ+EqaLnvvAVV5lTZGtx7g6zWqCmeBozDBQMbds=;
	b=gExlCJ34QJf4zf4G/ak2IXm+IcsTWsUauyXUD+UBn1V40Dd6ahcZdawNx6Hmmcjw26mPev
	lRlUtQ1H+zuyTZC4rAZr3kjP1ZXLnv5sFGSl6nL2s3IfQsknDivASaSSAxvWDCqUUvzwyz
	pMO72uEQy6IwgxEbd9/QdlFRTEiP2xg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757338802;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m1x7WQ+EqaLnvvAVV5lTZGtx7g6zWqCmeBozDBQMbds=;
	b=6Q04AI5vlvrWMrq8RgdNqNSGKmMmQ2wEuQ3+0Ea/kNOWOC+gs7wDQ9Bf0uGnhjRgZDKgr/
	JpOjlKcY9LN/dtDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757338802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m1x7WQ+EqaLnvvAVV5lTZGtx7g6zWqCmeBozDBQMbds=;
	b=gExlCJ34QJf4zf4G/ak2IXm+IcsTWsUauyXUD+UBn1V40Dd6ahcZdawNx6Hmmcjw26mPev
	lRlUtQ1H+zuyTZC4rAZr3kjP1ZXLnv5sFGSl6nL2s3IfQsknDivASaSSAxvWDCqUUvzwyz
	pMO72uEQy6IwgxEbd9/QdlFRTEiP2xg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757338802;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m1x7WQ+EqaLnvvAVV5lTZGtx7g6zWqCmeBozDBQMbds=;
	b=6Q04AI5vlvrWMrq8RgdNqNSGKmMmQ2wEuQ3+0Ea/kNOWOC+gs7wDQ9Bf0uGnhjRgZDKgr/
	JpOjlKcY9LN/dtDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A86CF13869;
	Mon,  8 Sep 2025 13:40:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id coKOJrHcvmjKOwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 08 Sep 2025 13:40:01 +0000
Date: Mon, 8 Sep 2025 15:40:00 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
	jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/9] mm: hugetlb: convert to
 account_new_hugetlb_folio()
Message-ID: <aL7csJTwokJd7CV2@localhost.localdomain>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-3-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902124820.3081488-3-wangkefeng.wang@huawei.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F34991C000B
X-Stat-Signature: g3ng83qhemkkxctfueyqnh1yw5p8tj6u
X-Rspam-User: 
X-HE-Tag: 1757338805-441890
X-HE-Meta: U2FsdGVkX1/azGHOowsFJhl/VnaPhuvE7W48sAvvMmu4h7lC1dmQL9OUyH7R8BZC0CBZy8W48KDaAE/s3LcK8ojA167ePj6R308kNZoB6cq6iG+rGwgYjae/i4XpYLSQL1CI4QXajomoXgKquLfqjLiOiGYxG62+1raBIL+syxaUZhxvlQX0DoFDgIMgH7jptNIn0958yR9xeDe/W1qC9XontsyfECMDUVCgbiHj+zbV4aBIt741Y0oYL9aRBiarPOcgXEAiktskBKV4iHpOyfy+QXYvyJidKHwcVnxEcKsdUexN3Cx3pyQfEcQPblOLpEoV0kS+/5gDn/PShQUHLn3ctYprxkgyOZJpmGWTKS6Qg9dujEmR92MfsYDrLyMTpEzJW4cqyePz4Vi4Ah8d5n/HJVQmO26WnWNVmgpvvkQ7GGk7KOEBQnzQQ3/Pbyt0nON+OmlZr/2Gg57tGPUGKQe/vrTxr83ArYlw9FwoQoyxhn/PFBpIg8PJpnEKVLFB16GTGllRGu4rF/fthVHRG7Y9MCHfRr/xgIXiDzrdTQpncxMmLfwdndOjWQQ7OSU2i+W/AlLzKA64+pOu7k3FQbXWqkxMm8Dw5ZDiODBkNhHRWp/J1wZ/RR71F6gvFIpwbmpUEU7zzDL0bBjtAhsYq0nWlpadTBywc5PPjvQoNZDuRH5XcGMoAihS9e1XJQsSMpKu5qwetHy4XnOsc3qZJiRXIXG0qOwAbdq4SftTP4KPgjYoqm5HBcXt0OmqbUBMfM50pJ+fsgo06i6BIXHbgl2oS+B945rkJdB/4kiqHmwcyMzxUJNQem1zUuX52P0F5iXe6sWvvcyPER1zGoQRJ9CAavTH+BGcQxVHMs6y9yysnlxmqL/1Qg3tiAiWcKDZpXB8Y4VPKrhhyz6uMxg9v4wk+X8ACAN4QH0JdWFA3VmqPPqLJx/Lh5z/3hXFem5O5BfPrpokgEpQ7bdbU9N
 CUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 08:48:13PM +0800, Kefeng Wang wrote:
> In order to avoid the wrong nid passed into the account, it's better
> to move folio_nid() into account_new_hugetlb_folio().

I would state that we did it in the past, so it becomes more obvious.

> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

