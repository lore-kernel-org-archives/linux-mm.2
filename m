Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48620C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 968376B00CA; Tue,  4 Aug 2026 09:42:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F0A46B00D0; Tue,  4 Aug 2026 09:42:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 833B56B00CA; Tue,  4 Aug 2026 09:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 639C16B00CA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:42:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E565640181
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:25:34 +0000 (UTC)
X-FDA: 85063658988.10.49EDD72
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2A1AB14000F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:25:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf09.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785849933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=utDL+0SiwwsJ9i2G5ufIopnYuVFiBbA1aRS1XwnJLRk=;
	b=cHBndmPy5Zuydas5smLx3ponH6YprfPorxmrWkU3Qj2iegZhcdlZ5+LZ00J8x+95vdQBRS
	PD/b51WmlbY3rHEEcJjnG7bnnDjQshl6brpFUD6iaiYt8Pb0YugUYlEeMfuWcl3uMS3GwY
	Dr9OLwI41cziQLEW//bjwS3M07vFBzs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf09.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785849933;
	b=eXs8OsTBePzCQb8Vlc5iEpxdkNcX9F3554k1CdmQDHo4nP/YWjXTgwXRAk4W5OzVsp85+y
	GThvpDoJsDnjFVzOo5Bi+85IHnMw5bnaGE/8xY8aQ59Wl1uIHwwfBl0/tOcJZ4Y+J0dF8t
	b2YjKovmp7AiO062KfLwjAj6ZTecEW0=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 353036732A; Tue,  4 Aug 2026 15:25:27 +0200 (CEST)
Date: Tue, 4 Aug 2026 15:25:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>, Yu Kuai <yukuai@fygo.io>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Christoph Hellwig <hch@lst.de>, Nilay Shroff <nilay@linux.ibm.com>,
	Tao Cui <cui.tao@linux.dev>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 1/3] blk-cgroup: add helpers for bio cgroup state
Message-ID: <20260804132527.GA8078@lst.de>
References: <20260804065313.2092022-1-yukuai@kernel.org> <20260804065313.2092022-2-yukuai@kernel.org> <prx5s4rwbgoeh7wtgyo7vwydh5iwqn6qc2utamowirsplspfmp@e3eteq5xwuyf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <prx5s4rwbgoeh7wtgyo7vwydh5iwqn6qc2utamowirsplspfmp@e3eteq5xwuyf>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: gnrd68chdf1dp3q8ozy93e6isy69tqhk
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2A1AB14000F
X-Rspam-User: 
X-HE-Tag: 1785849933-60038
X-HE-Meta: U2FsdGVkX1+U94JmAb2A9mq0lyW7Jh9uCN6Ke6Iwn+xLbkE/eJjyVkMY46o0d3PTQGQQ3BcQtLFmclM5LhdbehmsrG2ixxM93pwvX7xzZ0+PBHvBnLNbEb7A/PID5MfXGyZskeU9w/9drciWTMtDBAay8KAcKhaNLFvum2v0ikWGNe4f02JRhic2La1kRYw6KGkKHm0h9WcnL7CvyRqAItLtxRnpJ2dU/CSUJ+koT2nS8JMXMt5BEbBRXvNXLZGo1GcfapgRuRPuQuPHb8lhd1x2AlZsQWbx8uLTpKhAVMWqslE6RF7ed/m5vJRTCiWnBcqLM9o0rSagrqVpCwZ8VFERn+sY9MFqrfzXOe0dZ2QyK3PUdVp00Yb43fSROyM6IVAF2S2rp7bQpcS0tZ19PaKVWo1mz7noTmBtorTeKkZbBsq8tVFulXr0bd/GSfIkYzy0iOjxpbMYSasot/pQ6N7qkAnKVP7OBCeH8hcCTRiMok65t6P7tQBu50qlL3LnekkBDT6tWhn3n6CtlJqYGKZPlS+6VXqdzfp+dwEzegW0uvQzBeCwGd77U1ClJ+Ri+PPsbLrRJiz0wKJNMIThVl4/boFBojFJ+Tdqf1qJhVWexLZp85OfAFcVOUIDCybRMAHSw4wxCw9KE1K30NdT5lAz4GKYW+X+To3OLRhRFOklC76cOZa/qGJIM2PIUkjH/oD3LWvpIQtRj0jxwsBXo+qjJQOD/eBzJgDLAk4VJ4zi7noQWVyHxTq20wPgwM30WjhCqqXO4Rdb8CiLq4tIhT4WXEJOB6XdS3tt+M2wf/DIzhmIL218vJ4PkGw6cmjANXZbxqjWeM/H3z7xnOsraAsWPqrQ6BeHbzKT6W+GW/wFPJ3PT69qkRkeV0/KaVYKOFG6OYv7i5nnUfpwfMrCl4N1UBMh5t8JVwvHpC73mMrzx1fBeiZBnXlK9QpS9UHjujKW4ZtoSBWU5Dyk25n
 XfSRJ6hD
 WbJ17GKQH37pfNG07glLIN2cjVrdM/7vSNj5BiQ1/4VcjhPTfTNRdUdKDouoEN85qvvsUE5fFmulXO9jbgwo/3b7xElBjtKEEdsRQGdJmiqo0rUgFPrcxIBNw5r2H1qgZK0i4jjuzJRfejCBIygG5yol0CuSgUKXS6jk8YaVxQ42W5Q4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 12:52:16PM +0200, Jan Kara wrote:
> Mostly looks good. Just I think bio_blkcg() should gracefully handle the
> case where bio->bi_blkg is NULL (and return NULL in that case). That way
> you can also get rid of somewhat odd pattern:
> 
> 	if (!bio_blkg(bio))
> 		return ...;
> 	do something with bio_blkcg(bio)
> 
> You can then just check bio_blkcg(bio) directly which is much more obvious.

Yes.  Looking at the whole series I'm also not sure that this makes too
much sense as a split out patch as the next one touches more than half
of the callsite anyway.


