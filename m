Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0318FC88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 07:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C1176B0092; Fri, 18 Sep 2026 03:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 071D96B0096; Fri, 18 Sep 2026 03:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2606B0098; Fri, 18 Sep 2026 03:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C698B6B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:18:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B978805E6
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:18:00 +0000 (UTC)
X-FDA: 85226028720.21.667EE4C
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf15.hostedemail.com (Postfix) with ESMTP id B30E5A000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:17:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf15.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf15.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789715878;
	b=0BNq24bruE3VPdCQGDzMcRrZGV6Zh8DcgYTHsYcGruiDnFu9j9+k0Qn4WIff3066IIVXBQ
	yNPsTJY1S9+QqW5GCY0QGSgbhR8hxPjlZpeiOY1AFK+pvsDLeVqrBFFxRZAFStaJg1YDK9
	aHgo/cMyuObPtgUTKhBg6waWf43l47A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789715878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=QaxZRwO/INmpStkQp6YjgQE6eqakEOy7OHl3MFxy9KTZn6kCnHM/W9kHQiBn6MJGfuRz1b
	1yHk5e6lh2h/5HS/TrgW8ziZY99zZc0kohxyPcG1/mHkcgRdmif4JJTHuSH4XZGjFdXjlQ
	KpHS41OyRcgLaabcqCM8k05agum9dsc=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4261E68C4E; Fri, 18 Sep 2026 09:17:55 +0200 (CEST)
Date: Fri, 18 Sep 2026 09:17:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>, Nilay Shroff <nilay@linux.ibm.com>,
	Tao Cui <cuitao@kylinos.cn>, linux-block@vger.kernel.org,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, llvm@lists.linux.dev
Subject: Re: [PATCH v3 3/3] blk-cgroup: move async bio punt state to blkcg
Message-ID: <20260918071755.GB10884@lst.de>
References: <20260918041744.1526924-1-yukuai@kernel.org> <20260918041744.1526924-4-yukuai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918041744.1526924-4-yukuai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Queue-Id: B30E5A000A
X-Stat-Signature: nxtiwha7bigf1rg3dtd9ftutxtsqb7mb
X-Rspamd-Server: rspam01
X-HE-Tag: 1789715878-839279
X-HE-Meta: U2FsdGVkX18jMvGN6gQ3bpuMtSctBjZu0J1jGlWRsrVukihGKWAsCVCPVtLHFkB4LzhccL43yCAMu5CHOD2gPr04FUGhIorgmkHZ02m4WNtQvFpJDwx5EdWcalK8i7zu88kUtxxK56ywbQD0DX5M6adWXeQRY852byln/6TltDMg6KPR/IbLO5+az1rasKlblnfyTMeGgt1ZhmaZ31mZR6PhoR6+igYPL8kQ3WGCwj5N8XBTOn3zh6K5V+gA4JS4sJMcC8EEhwSn8JlJEyUVgVwPnEnQJAaHF0C3ICdvfTZq7egC/4yv87hhKdYlfH1rQngGQMw2E6lB2MArT6oAa+XAkYLbUuW4xLOw5XHdwcgLfetqI4VyCNFF6vva7Q3/ylf1lUnZaiKXj/Zfx+JSuA204QOnZ9tV7l72JlbjpVPSMqb5JM0QKrfhc25ce9L9yJxr+Z9NyKDqD+QgnjMeUcy0GC/MnXbP7QTE3Jt2Vb/TBmxQdmElR8VBHoXG127FSYN1w3xF4Y+m5VqQtEvkEd54eVVUHXspEMlVRN6uyJ0+Vuq+7wj8hNMXHd7Qb0Gw5/+mVDU2rzrKGwPhh3wwFVhtBPZyiuuIGFvxDBWKXv4436RNTErzT6QWUgkUUYkZXO9CAVDjoB+bLaTldkvj01Ka/Kf6JD4gyib9x7ViXBXoQm4bm3pqdhU+lK4D7umZ69fCBTQRKSEp22/Om83WRSoTVNWtrecCsfdVhgajvSJU0prVmivZDyhNiGyTdIyt/01hcp3d9xGS/QUcLR4m+iwVqQeeN4i4w1Jgquuvp/815jjaiJ9a2cusbgN/YVtAJIa/6lfaw7YONxzqG+BqXqgYyulVgpCc+KkqXD3YeX74cL+4sfLswMjENQTMEFfyy5uhlaNMUAswhY17L++meXt/zJXec11LPyPQR6QErTDDTS//LPuU0EAfoOYduwmLKPTG71V1iWw16hwqL5m
 hY1ncDaa
 OlgRB4Y7Bd8mnqZU0hXVfTsmFiy2SugeLyRBd7+6AaTOGkR1Z8Zw0sSXzpRXz+E7S7KWRHEpFYjXE+6DDIb+PE1z+U4WbeE4Slnd5bI1ZWp/pLwkOz2IHh6eFPns89bnpm5YoU/phc06aPTN4C+QaHfCM6bGkawzqYTIZ4SpYeuRfxqPSXnY6Mrcy8T3ajDaPdVnsPM/E//6UPv5C+42FpWdNJftGhxTDKPRH53hNmNZVF44nOOZgUGNLw+JBy0lRkY0NzxGPEA5UWRP3YmXV1x3Im8+l5BFFZWst+dPCeyO1dex4ZVYj0Azu9w/CroemVwZA3EUysz22qNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

