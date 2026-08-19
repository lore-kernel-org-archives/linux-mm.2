Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A13F7C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C13546B009E; Wed, 19 Aug 2026 05:15:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9CB66B00A0; Wed, 19 Aug 2026 05:15:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64FE6B00A1; Wed, 19 Aug 2026 05:15:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7CD6B009E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:15:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81A841402AB
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:15:03 +0000 (UTC)
X-FDA: 85117459686.25.5414A41
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf26.hostedemail.com (Postfix) with ESMTP id CD1A3140006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:15:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf26.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787130901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=hbJsljPsyNX0tDhQu6D3Z7aQgPVBnJUPq4u3RgKnbQ36+vVreTV3zIXSS+JyP1Eqa+3UNN
	RMBdwnm2FrCOdQJ+M1cjFQtJPh5hrlmDV3yk5UEjaXNN0fVP01OSN+VCLCPlJXApW80v+Q
	cRfYpMB6bLVjThyHsllRrG2yPHSO5eQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787130901;
	b=d4tzprn3Lnv59+VBG5zIc4NNkZb/Mw00NDv4sMHCyGLNvetqQH0DjRReZo8hZV8i4jk05P
	g0GarX+7ep1rOtxXkItw4XD0MbqRhPHlVDLzqHoIM49QirfUYQlZ965vhdL0YJAfKVT0av
	JPhNjYaKn/AMRQmz2ycGkTwmKOnoDqc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf26.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 43CEB68CFE; Wed, 19 Aug 2026 11:14:58 +0200 (CEST)
Date: Wed, 19 Aug 2026 11:14:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Yu Kuai <yukuai@fygo.io>, Christoph Hellwig <hch@lst.de>,
	Tao Cui <cui.tao@linux.dev>, Jan Kara <jack@suse.cz>,
	Ming Lei <ming.lei@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 2/3] blk-cgroup: store blkcg in bio instead of
 blkg
Message-ID: <20260819091458.GC10298@lst.de>
References: <20260818070641.756747-1-yukuai@kernel.org> <20260818070641.756747-3-yukuai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818070641.756747-3-yukuai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Stat-Signature: 7zbb6jtqacdy15r5n98eh4neacbpzkno
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CD1A3140006
X-HE-Tag: 1787130901-49090
X-HE-Meta: U2FsdGVkX188K7xoDYR0DEoAb99hedvW14d03/TjmMd90a6EkMt5RJE0oiDWfRSFHCTpaoUMfd20SI235w5wq+2Gpc5ev0AN/wpuScB9cYrx9NcJsIwc2oIdjpq4DYBpsl9Ff1+b2yzOw/7XzuBoAWj1KeX5jIsQnWTl07yIvgRkVl0i6JuCYCtccp2cuENhhT/75A1dCiImT7sGDJt6F8Y0TUxmoT9HJdMnJUSJynTx3UmPX7hy7JCsnOGD4CbTnRtKzNwszbOMmQQcsxuYrJNCkdwz/DQ4nPGLPwhjoLCa2se0Ivtvqf/QDR1M0pkYR4CRagH58gJyU3Pfo4OP+RmloBGSoshqPCw7Yp3E8ct7D7ppPVXIk4gLFNjEI6rBzOOkE0iIbZfSKjMaoGu2SIcbdc7T/meVsqBRN8MARSBjHX1hbduWAECmpATI/4F4PnlhSPRX9FuTV8fJ5MvAQzH9WbKWjXnX8y0aIBCM5vmf0QM+W16YklIQRlFwLy8l8okLJq4IkqdiJ67zvPV4mwh+S7MD6uqRp8S8+RTgV6DDp+vtI8QT23eG/EW8+pelOVFowpDrAM4+Hw8+mgOinC8oLgepqAzimNeiQYev/SHqjoBkg5do/CmXkukYGxTjgLx5wdlvq9oVuaynT0lbNk7+jZwvPzE0hmTlEl1bRQp+Gy7PKkVdfRPBFBled0g2fxbvby1xUSFNhl5Mup+0gN+shoAcfmD0WcrW+D0Jv7+ECUsmnvffSHnS7mOOFsisVp2bV4BE4+jZVxOp7lQIXLer5sLA4JJVwWAMBiFbftYTkULe7E8XX325/cWSPGaSt6rnMXab58d+TAObkWFsXou5BKWWyq/MzKT5C6rQwipPt8UCAbdgQeX+/HaxgaTYvKK0pHOchlyMKmcEMUul9B+V6dbfxBV4xs+nRnFAtoAYDMp5BOc/BYmt0v/nd2QtkBtTStwyqLdTlRt/ZXY
 8xgLDAV2
 wN8fo4h4lMzF5aD2PJbP+44DpmP5gchRVx5+UcsWt1QYzTqDB7RLKwrGTCHzagExamuNmjZdhOzLpZAkTbQXtmsLmbsP2giqPjub7Ff2/RrO47355j6f5103Kac3FIVhmZxl3kc/m3Uh9GvGoBl6YbIcIpCIFUJs/6mixDshvMqXSVV5SNEwSFJvkaFjONdFYmTamp6lLAPSlpubi5iVQdSBDtbHScUXBd26oYTNpav77MufSiUHpqB/RFiO/vfumHvo8AHSt0OgGo8lUWJ3Glg6N8CgDd/27IyiACS1kvVziog+c1ptP5M6vzPd8IGqFDg3/JCA9smC2glZkUgnVVOH+OI3+mx+UIFffV7tjP8oxB/slh1VR+csiBsUGtWhbO3Nii0WOqiHEoFFpkeAyeNVENQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


