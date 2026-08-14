Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F09EC5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 07:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00A26B02E9; Fri, 14 Aug 2026 03:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDFC66B02EC; Fri, 14 Aug 2026 03:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14E46B02ED; Fri, 14 Aug 2026 03:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A2A446B02E9
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:12:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 292C61603B7
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:12:40 +0000 (UTC)
X-FDA: 85099007280.25.BEFC49D
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf14.hostedemail.com (Postfix) with ESMTP id 54EC4100004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:12:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf14.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786691558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oQetHTl3vaKZHwye3xIiJ/QDfHFthBDFxW2wUb3qp6Q=;
	b=XKD9qKoi/Gi7vLDkrFSWxxdusjWSpJ0VNPewXcH0QxAGgCKzvX211PSbIJdJB3fmEG4LiP
	fRJzAOcBcgKB2FZZY8PdC8HefnVjWEolGdC0qF3dK9kkzQId8W4tz+ZY+U3Cq2+ZYTvnwI
	nVQbgvXyn5ruI5VoxUj/23ysfiMH8K0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf14.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786691558;
	b=44tl6ecvX0xiGb/NkkFPviV1R/PHN0ZaCAJ3qEBnPjqhkSuLg36fSjbZdd6vyhL+QWkBuC
	epQyfHi70ifoKDsnJ7CwzhSj3IST6Kdt6HIObIvkV1ZpMPm3h5Ypo9JUXR22K4AB5lkox4
	3lv7Ww5rvQFXBc9DcPCK38a+lb7no48=
Received: by verein.lst.de (Postfix, from userid 2407)
	id D93C568B05; Fri, 14 Aug 2026 09:12:32 +0200 (CEST)
Date: Fri, 14 Aug 2026 09:12:32 +0200
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
Subject: Re: [RFC PATCH v2 2/4] blk-cgroup: use a request_queue rhashtable
 for blkg lookup
Message-ID: <20260814071232.GA9784@lst.de>
References: <20260811064744.1139446-1-yukuai@kernel.org> <20260811064744.1139446-3-yukuai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811064744.1139446-3-yukuai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: dkww3siz5ytcq7ysfwmwgqzxxbyy7334
X-Rspamd-Queue-Id: 54EC4100004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786691558-582647
X-HE-Meta: U2FsdGVkX1/gv3FDaadczCoEbo01NYkfb31jAtqpL3CR7R4PgQiUaT/Wc53E6dd+Rm3/EsB9B9U4DJ/oLfV7hTNckIiPa46NoAzCmTTUPElXVwKb6HeIc/CuzVc8VHmqe4vOlfSYUJGtPUGtTh/01PWsDyfe5atfbKaAVzojWez58Jp2UsJlQdQC9V7bNgoTxvE71mfMIntktqWL7yrbHWE+nCFzX9LwWFfmFyDjEv4W2vojBXAo2dvTylz34nKZrMnDlpLrr74KHddK5zjNJzQ0zs33ux2fdajdhoVvyiL3WLtsFCvWuSxmSqUgTZjBk8ydDABrCYsby505qGM4EXrITgn9wQPnsmLVlCQ4lmrAwwOAo8iBEjN9PitInXyKSuadEse44ilDXVq6BzOOvKgfmb4TCHQNJ7zomuia+wg8q6MFCJd5cgyROEcrNFKI9O4yf6fvxIO4tEYr8z1rdFPjBbtK0HHU31mlBF6yrJgxr4sIAtdPedJe9aSmXlHsM4I42iPYzZ4Tta5mrkqsGOZ1xRr+A8VUA2mYyfagZhWZ0IZdTd9UYEZ25YLfVH31sMuC/bi6krXOBoqtOfC99Mgvu0W3i2cpISTWIKm4Zt5rpeHJSpZxhvG58b3VqNH1fWV8pSXG7bmxC7a9pX6ZYCZwy19BeyD/qNiUENVOdeuGn+ttb7zj1ySDrQutoUIdy/a5MwKlZoreIa3eq5Vxcdl869Ti0JSRQKEeBU9P1V8rxFqS8IPxUVa/FqquhNpvsKg6rpXWgkeJJT2uRLoT+8E1ZIbWG/+VVoAdCnFa6sQ4MR4UCL8yq5ghbINh6dw327xUL5Fw1GkltR9JVd5VhaU7sWEH8EUO0N8cvEBPbkZwiAaalwYeFyupvx7G4YKuLTt76QjRLr+/f+feHfdOOhBPwIcNTfGgR+16XHBNAKezZ7rZ6tUEElZqDkOHzSQUKetyVMJ/eGrrdo68ptH
 yJhYiIio
 2XxnLvn5rxc3XLcnfpx5wK24KFcHK6q+jp2mUeNkTaYP5OLSR/a2st9wGqIReHRwG3DzBb6rHUy6M6IQesQFfyfLBsErid5g3smMPOuyMpbaoV/9kkO97GWXPP33mHzwQNORvjwEn2qM35H2tasBcr//Njkemeymf9t179GZggMoO78pC9VaumG1XL5C2H0H7Tz8CQMK0XuVPvXd6x6KIqMsbEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 02:47:42PM +0800, Yu Kuai wrote:
> Keep q->blkg_list for ordered policy and scheduler walks. Initialize and
> destroy the hash with request_queue, and remove the radix-tree preload
> paths which are no longer needed.

Are these fast path operations?  Otherwise we can walk all rhashtable
entries without an extra list, but it might be slower.

> @@ -191,10 +198,15 @@ static void blkg_release(struct percpu_ref *ref)
>  {
>  	struct blkcg_gq *blkg = container_of(ref, struct blkcg_gq, refcnt);
>  	struct blkcg *blkcg = blkg->blkcg;
>  	int cpu;
>  
> +	if (!list_empty(&blkg->q_node))
> +		WARN_ON_ONCE(rhashtable_remove_fast(&blkg->q->blkg_hash,
> +						    &blkg->q_hash_node,
> +						    blkg_hash_params));
> +

The list_empty case is for initialization failure?  Or can we end up
with that by other means?

> + * Lookup a blkg for the @blkcg - @q pair, whether it is online or dying.
> + *
> + * Must be called in a RCU critical section.
> + */

Please add must_hold and/or lockdep annotations for this instead of just
a comment.

Also maybe mention that this does not acquire a reference and the caller
must already hold one?


