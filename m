Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68ECEC5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 06:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 563FE6B02EB; Fri, 14 Aug 2026 02:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533C46B02EC; Fri, 14 Aug 2026 02:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44BC06B02ED; Fri, 14 Aug 2026 02:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1DFAC6B02EB
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:50:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F31140387
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:50:57 +0000 (UTC)
X-FDA: 85098952554.01.169AFB7
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf05.hostedemail.com (Postfix) with ESMTP id BD7D9100005
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:50:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786690256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8r2AZqW1AUJrEV1zOvdxHuNQmKb9G6A04RP/k8ww7M4=;
	b=EkqlCec0sEyWMVj/fD4N/dng+JZ0ZV1fH7VzJzAW3Bmqbn15dKupDjhxvtAMsUVEMXjp1b
	IEkNU/sZkE3N2ZYTCJLTtgSnAGQXCLY5iazYgK/gViTKHCHHBTVx6RX/2Vc5Mk1QF6kKnt
	R5dPSdSXagNKqdJxBJRDjWCM54dXivQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786690256;
	b=MgjXPaxcy6JIABkY3oac52adaR83KVeagmMXMjsmRqmYc2tf+/f3HWfJAxy+x+CasL/Vis
	W5+WhnROuCEBbAXHthUmeSsMkNymc3bJmcPlrMk9GIY1BtC2vIWVQkAUtzemxlQ2M2CuYR
	B7UXKXOsCSAIuNy/SAZu3TCHfeawqHM=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0EC8B68B05; Fri, 14 Aug 2026 08:50:50 +0200 (CEST)
Date: Fri, 14 Aug 2026 08:50:49 +0200
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
Subject: Re: [RFC PATCH v2 1/4] blk-cgroup: wait for old blkgs to leave
 queue before disk rebind
Message-ID: <20260814065049.GA9495@lst.de>
References: <20260811064744.1139446-1-yukuai@kernel.org> <20260811064744.1139446-2-yukuai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811064744.1139446-2-yukuai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Queue-Id: BD7D9100005
X-Rspamd-Server: rspam07
X-Stat-Signature: 5qwxjgi6nyk6ia7p39rt369gxhtkp3rq
X-HE-Tag: 1786690255-587409
X-HE-Meta: U2FsdGVkX1+3Hllfno5Vc2COrvPZARez5oHShCKQ7uC1PW9PAS3N7lu1Dm7EIyjLt1aqXPZFFqWPitWKaBXBK+0hXNNeGeSudrDx61dIafxgHhG+kSSRievGxQ8dGrhnxawDS97VE6s6v4AAg/PkQAtnCzALopFxh9xZFBtSWZaWUoeRXYJwDrORzg/2GzPA/1EZOT3IasWEFUBHzy0D2Gwa/LL029nd5sGSBvsM9GOwl8723jTgWwHD8Neo2Q5vxJzlClimQ7r86fiigVcKWa3a1M6iIL0/MVIHNJk2K5Rd5ZMuldsBl3ZMba0Q8OJ08NUiwgbbd054EQdFbn4Yj8KdR96wgHiufrNXnxvRktrw4ocNBGkeb3OQzp07ti8xcTAEfN+s0ZCu96M6bQ7OTXZiOfTU0tBI81RfU61b4QoHZNW+dUG3JTzUJxUFm7A6TcJu3ACUEMmbbqaSd6d2nH7zh3j9QVMPChuwYwifoqAhCvSLM1WK1T0SpiXlJ394EvufxhiRGb5ZK6FCKnC7jWKfk2j4NdnFS7Q1s0FH3SI/I4qVgNmFlMoBeCyTAz9MgfpiEhEb5VzqDxDjp0YofYSiHOabCnOHSk2gSJOSOeOO3nvhvTX/GftR7YaKew42UF7Hje2Q3GCq20Iyt0AUrNrCw4fH5Y3WN7Fr/nggZhPTPf6ZNzNrg+PScb+7ziLe8I30d2mU9hFoi4DZJVj4kmnMoSJ/4H2f5bZl2ZrDkAJME+ZaZs65cTgX+EpRMrrAsKLLsZHbbRD4B25/z+oczPKetRLbmoOkle9EQKXtlXKNbOnBTbgaADd79cUarJK3qmg6mt4xmWKyouBuMCOWVSm7fKbdw0eHujTNQ3yP8ybPqVvxW6FUYwdg8CYhV4rYwn2CcofEJS9tP7wUmk32J3eF+9wu/4+NO3avLBLe11TpPaQSQX9tgryK8MEOqawqkmWew50I3+FD6crGD5x
 TS9Fs2t9
 QYevtR1qEnguU6ENTwDhN11x6UaOl51XYqOfNw1MqlE7vOQimQy+I9RkjDv5KBpvhjuZl59ce5OcWE8AW+3UffmGmm9zqB4vZQM1VMN6nxIHM+Cgya5Wk+5g31aXN3Z8T5TyV52rQ2ZsigFNhPyBb8JDD92gp2dDADPPKx0OqEnDpqgHcmqzXLr29lfgMy21jS+fh+zoid1a0AhQCEc2GDCzL9ilk5iKSw7zo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

You probably want to send this to Jens as a separate bugfix for 7.3
and -stable.


