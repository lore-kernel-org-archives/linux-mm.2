Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37048CAC589
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 08:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83B2F8E0011; Tue,  9 Sep 2025 04:12:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812328E0001; Tue,  9 Sep 2025 04:12:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701088E0011; Tue,  9 Sep 2025 04:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3398E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:12:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D232D119E8B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:05:41 +0000 (UTC)
X-FDA: 83868977682.25.CAEF49A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id C6D86180002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:05:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vp+ulvNT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xbTHpbFi;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vp+ulvNT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xbTHpbFi;
	spf=pass (imf16.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757405140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lh/rjlsZv0cfz+ybr743XYRzcYfwYGgp+sZYhN4kRfw=;
	b=QZru7cq378UJrUmOtfy5QeU0QpOdPt9sWeOb2uGbNvj+rvJk3ZhEIzP3OgqFDUJsnMB2BM
	AYAhg5MV1r4/RFo57FarcQwGae8iFwZDec9a1PYE0U/VDQXxYT+1V6VbvjsCyepci5rjQL
	HezwiUD42OTj6PWiVbiOUx602KC/xtE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vp+ulvNT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xbTHpbFi;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vp+ulvNT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xbTHpbFi;
	spf=pass (imf16.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757405140; a=rsa-sha256;
	cv=none;
	b=8R/G3FZfxkREfKyIQ+Z2UjLp/cYjPi88i3PF01JNZlNtqiS314B9PIR+luEv/oJ+8uGKGS
	0u5goRtUMnSZhZn/hiwaJe0OR27XhI7ytrPHmgJ6ESVeKDUbZQnyGCFlOnbyKMWRBvoz13
	G4LC3OOVglrI/6OZUsclOOe1VWR6Ut0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 297F723CCC;
	Tue,  9 Sep 2025 08:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757405137; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lh/rjlsZv0cfz+ybr743XYRzcYfwYGgp+sZYhN4kRfw=;
	b=vp+ulvNTQv/HWmQ6xNUjt1wAJWyHuLX1qtIzIPV0eUF8x8vGgo3l5eJVh1SYuZqIb10wnm
	6nijAv808YDDJ9HTcuoLO8LXbqg9J2PvXdBJREz4zLqUu9GqYMHl1bzeSyh/GbGP6euCty
	VMs40oEJilJwS9deVAm7Z8dH72CJLpc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757405137;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lh/rjlsZv0cfz+ybr743XYRzcYfwYGgp+sZYhN4kRfw=;
	b=xbTHpbFiYucC1BZd+eeh8uN3gQMHJUcG4sGTvCoEggSbX7+/4kQKcTsR7EcamIPuc2TtbX
	8IEvH/ZQ6LJCQ4Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757405137; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lh/rjlsZv0cfz+ybr743XYRzcYfwYGgp+sZYhN4kRfw=;
	b=vp+ulvNTQv/HWmQ6xNUjt1wAJWyHuLX1qtIzIPV0eUF8x8vGgo3l5eJVh1SYuZqIb10wnm
	6nijAv808YDDJ9HTcuoLO8LXbqg9J2PvXdBJREz4zLqUu9GqYMHl1bzeSyh/GbGP6euCty
	VMs40oEJilJwS9deVAm7Z8dH72CJLpc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757405137;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lh/rjlsZv0cfz+ybr743XYRzcYfwYGgp+sZYhN4kRfw=;
	b=xbTHpbFiYucC1BZd+eeh8uN3gQMHJUcG4sGTvCoEggSbX7+/4kQKcTsR7EcamIPuc2TtbX
	8IEvH/ZQ6LJCQ4Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C28B1388C;
	Tue,  9 Sep 2025 08:05:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4rd0G9Dfv2jebwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 09 Sep 2025 08:05:36 +0000
Date: Tue, 9 Sep 2025 10:05:30 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
	jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 7/9] mm: cma: add alloc flags for __cma_alloc()
Message-ID: <aL_fyqHJBC9zbEov@localhost.localdomain>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-8-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902124820.3081488-8-wangkefeng.wang@huawei.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C6D86180002
X-Stat-Signature: gx4oszwe1nhz8jmbwgn9a6xyyt97c885
X-HE-Tag: 1757405139-444067
X-HE-Meta: U2FsdGVkX19XlXWb9msepUsgbwECuk6THYlN/RT1hP+DzL7KH/iStEpO8CqlOHj/G+vZs0BNp9QqdMC/g60F0RdEqmf1qC9Thp3PcLkHAA1ZYroOZsCQ34swByqwKIBBYVwcys7JTRfUO+2EVPk7vOCbAKXD23XQpssS9pBXGpB47KF1ejcCUVCOobz1tpjsy2WfpTbyLmdRzWGqeMJOJxZNQV7KdgmyKMr1XfBOws+s6mYSygfqQQXSeIqjsFyijWHA6ySumQprs2z0XuSHCUusDlCAfSxaS574iWTEjWe/wOJJvU2OuTPI4HJADu89VHL+T7BnmnB8a3IGq9aWjQSWiUvXztE/KOBJF+KKFtT70R+kqc+BT+V49MSEyJwxbkpJPdmzhpzVs64yLs+OeqQ3kJeJtXexqaX7TaxCCs2g9gy4cDfo4xI92hgPWYcdLILnFK+dIScuQuwWVNsZt2BBluudGJyRvT/sQrFNpJySKWCy5U6h45CrXIff0bF+CRPEP9BOK4iDnUsjnYGVS50/MEwpfwzN7nuYwiA5FIcUKJJp3Jc60bVfDHfQYkKWZfizRQmkEOGFKnH9pt5YE2PiCwsTwfhc5+NaTaCQp/nGYiP8jr3WxxBEglR1fvxwSDTTqW06k1Fctz6GKK8MI9uYSh8iCyHBR+OHb/Fe9PN6tFdR/NVSjygbbd2B01H52KAEtjloyMG19XTF7D3bFdb6/gvumV3IBi0bHKtFWdlCmpgjfo4mvuiqeOA1yHJmPJEmJ1mvGIQeOfCuOo3upOBDGbC6MjDYgu+FYOXN8cgroVK4cyZHxYV9+ciIB7Xfo0rSfWVEtbBKmmtTxFmKc5rmPNXI/6XT2YLAb+11ueG2et3Nfr1qqjNS4YlYdhEtvtBHPRvu11+Eu8+dzPpJp91ReDbDk3MdlqmmR6TFCAcmlJ3V+D5ioUHTS1CfQDtIbHFrGJre7e9v4ZjlPQt
 zZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 08:48:18PM +0800, Kefeng Wang wrote:
> In order to support frozen page allocation in the following
> changes, adding the alloc flags for __cma_alloc().
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

