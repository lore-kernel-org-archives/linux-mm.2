Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C83F5CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:33:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F4D86B0095; Mon, 11 May 2026 04:33:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5A56B0098; Mon, 11 May 2026 04:33:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C12C6B0095; Mon, 11 May 2026 04:33:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1BF1C6B0095
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:33:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A81258D7E2
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:33:21 +0000 (UTC)
X-FDA: 84754474602.11.AC45D6E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 69E9D40005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:33:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2Q8J4kLI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+xcL3MYm;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qBFvdR3i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NGhed94o;
	spf=pass (imf12.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778488399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/ABwJHQhyeelEgr4rM06OrkuVKmZ9QJOD5SYPOeT4c=;
	b=xI3wP6jh1907qq+EvImnSR5VIXSqeqKnNR57knQOIuYNlMybUnsoK6Lipr2vaj7G4EPgor
	ZhNvwxeZF1k3QbJktydhBOHQaBsWZNiVaKb5nUO0zAlUUE88hfTgdtN44XP3a2FMpf8Ww+
	dOkWK9coiH/iauq5PlrbYHYzBf3Ogn0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2Q8J4kLI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+xcL3MYm;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qBFvdR3i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NGhed94o;
	spf=pass (imf12.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778488399; a=rsa-sha256;
	cv=none;
	b=xK9aboXet9JJwKi7CUZj+J5RWFkU61fFHRZNd8InnueNtmfWbYqDR5oRR6wiSOCtHlk1LV
	2Mg+yz7EW/lwXn/6lB8DIKdmvgKOdKkHCJXJVvf9eaGN9Pf1ldMwRMO23q6R6gTs2N6iCh
	Jbnf35aQrH5Ax6pcbbSZOS4CSQUSb74=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D16755CCA8;
	Mon, 11 May 2026 08:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778488398; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6/ABwJHQhyeelEgr4rM06OrkuVKmZ9QJOD5SYPOeT4c=;
	b=2Q8J4kLI/ZPcW5wMmL1E9b6GWYuRBRX06JbyGXQkVjFqKdUXQqNG+vn1ZTEp66FS2k9YTp
	kMOYW6i95tPeBiYp+TUDy+wJo3RponKFHj0sgXWQnn1j6liO36sHi8HI06JEVIWlImJzIz
	8EPYVnMO7r8oF7SmlkIfYFqur82JkCo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778488398;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6/ABwJHQhyeelEgr4rM06OrkuVKmZ9QJOD5SYPOeT4c=;
	b=+xcL3MYmKFU+N7hs3weginetpq+0+ah/XTgo/ngPqqqjtKPx53aI5Fm5BT1EwFdFYa+E3w
	2srM+CZ2m/nBuGCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778488396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6/ABwJHQhyeelEgr4rM06OrkuVKmZ9QJOD5SYPOeT4c=;
	b=qBFvdR3iw+ObFrzrkn6q+O3IQCiHwDBTdnL3U+qHAabbaI/CCmMuFv5jO9OHhxxaHVM+Eu
	IsklbQOtu/oC3oXhLZF1bO32yK7qdRdWHjNPhgx0RZybxO3ljhXp8J8Ufa5m1+t2+WPoEf
	oe61FUF9kDsMgHZIbJnD9BpYWGyN45k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778488396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6/ABwJHQhyeelEgr4rM06OrkuVKmZ9QJOD5SYPOeT4c=;
	b=NGhed94oaEvPA3x3Ry8gtd/If9qIYiBfOQTRlNF6nR1noXdvx6cU04r6+AxPgxUElUsrjO
	wy93zd/TJbt7A/CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5CD82593A3;
	Mon, 11 May 2026 08:33:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pNajFEyUAWqydAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 11 May 2026 08:33:16 +0000
Date: Mon, 11 May 2026 10:33:14 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v6 3/3] mm/page_owner: document page_owner filter features
Message-ID: <agGUSk7WuyWTSEDP@localhost.localdomain>
References: <20260511033017.747781-1-zhen.ni@easystack.cn>
 <20260511033017.747781-4-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511033017.747781-4-zhen.ni@easystack.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 69E9D40005
X-Stat-Signature: 6sm7gtbc48o4fx6zp9z31d496n9kt35c
X-HE-Tag: 1778488399-177181
X-HE-Meta: U2FsdGVkX18MShktIx77HzVRFUS11EkalL8nphu7W0zuBOPthNouX/AXP6bislVlEOHEDJYu533iH/Fp+u7unyeeuyZ99flztFOtmzDttAM1gmWdYJx3JQ1aBtsr7Kd0E9B/iV6tOrZBlQg2N4E9XMtSgEj0Y596rNsr/586zJGyKiTc9WgayWD7KJgSSvF3n0BkF5nVxfhazpGppouSH/tMmwB+3TITHIgAmf8fw1NE7Imq6v9yHDLIBVc69FffrWrUj6JuNvwnYs6KexDyYuITgpcbvWhj9c9HsA3e1fTf/CVFf4MBpuEYULmoZT05FiQ4Veh86WE0aMW0S9adIANpJDvfzs8hRCBsdXxxKi0AIQYlNgj7iNJK9yVqU6BEbZF4wswjUnHmP4WXw7sryO1c75/DfiFOP9UXOTPqNRn0QZEkeu48PYTem+pMx+2zCT3Eg2NnFUILm8Z0EO125Ic2tVHUrG4XKaoysOMbKRJmDnq8nfNAAGZQAumbfD2QXwq4Wd0b0BYRE6RFHQFRx5IgsHf29y4jZR/IVnxdgicmJ926LqaxpbnOGwkmF3t63VYI2hD02keH/+LzyxHoWXufQl4K48ZlrUy+s0dZSSdicB0p6xmzkIf8uvcXYmM7i8nywNeYJSLOr5WYVHw7V8h+GFO3/YH2Ly+atA6SF8IUNatfdTVWkFp+yJKHhGUCABcRUmAmHUncY18f1aR3/oXWy5MuOldlV8c6UVm01DlRxzrpV6p1fl3g85ao/9aReudeBIvdb+FxU7cf1OFuNy3nrSsskQQOxoVaOTFgayT2iPp0oKp5ocuEmAk6ILWxtfwzrVlhes7iSbjBjDAboNKoRg8TjxxQMRNrWYMYHm/8vRVyua6zYb3eShLVKaNca+hE/hzfdQY7M1AHs3brJlRc6cSvSlXz+qImsFpZIo7w8nDg/7JaAD8kkUB9utP6mWULyr56BCHq6Asgxb2
 XQ66tJJk
 biYaEA2IT9SIefSih0VzK+nqin7KUzcjFBl3YCDH7840B4mvWijS+U/wyq4vvGgtxZMMTK3+URkR1vdVNWLRP1MwC9tNy3IZ4rezQlVR4rDUltIadpoy6FeHNDyXe22CCV5DP3d/IgF2rGBiJhbvse7HhFE5v2MPE0nqhHAPqQlWDnLACUC3gCdansZBFCLpmVsjROVplA9bNcqtnwW1sKtvK7wWInVthWIATKbEV0nCABG0oZfdvH8rPyFOiRUjSN4rS0nH/o2dwzTDTSqID/QfadHb8fKm/5G8kPmuVKTOYQLURIl7t/GxOgn2VQNf4Q0qOaDB/fpUkEOA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 11:30:17AM +0800, Zhen Ni wrote:
> Add documentation for the page_owner filter functionality, including:
> - Print mode filter (full stack vs stack handle)
> - NUMA node filter (single node, multiple nodes, ranges)
> - Usage examples for both filters
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

