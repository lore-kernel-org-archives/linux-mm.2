Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B97BCA0ED1
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 00:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B68C8E022C; Fri, 15 Aug 2025 20:55:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E6A8E0008; Fri, 15 Aug 2025 20:55:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CBA58E022C; Fri, 15 Aug 2025 20:55:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F296B8E0008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:55:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C45881A0310
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:55:01 +0000 (UTC)
X-FDA: 83780801202.06.0601B07
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf09.hostedemail.com (Postfix) with ESMTP id E115F140004
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:54:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="THg/Zb8g";
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755305700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vpht9Z/NW8bqai5iUGyZE+rsgB2/DI1OX+Eo1OgSMVQ=;
	b=pqg+j/lBfrFMoW+RMzKHyGOT9RWTynyZoz1bAx6Z1sNLVQZVimZRAsmpW+rJBySVzVrfCP
	PFXzf9GF3Vh67MRHdj5R35wWFw7XeisRkaI5TbdobWqazUIZprpz5FjqmH9sv+e9bTpsxy
	8an4p2EH1B2tBeExJpKW2JI9kNwTv+s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="THg/Zb8g";
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755305700; a=rsa-sha256;
	cv=none;
	b=xEZdvlgkE0+u/cyrmGdmuzFMTE6vMF1FV4qTyTnZlNInTHUucqaQkfvzr06f518G8yjbxj
	gV1FsNcPJZvnUZq02tMauxjwMBqiXM5mRXNk1HnIp25rxbsxYylmpT3h7QOva4EK4rD5Kl
	OQp6z/PuDNFzGkQpxCDlFajv4s3266k=
Date: Fri, 15 Aug 2025 17:54:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755305698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vpht9Z/NW8bqai5iUGyZE+rsgB2/DI1OX+Eo1OgSMVQ=;
	b=THg/Zb8g/2b4tI1LVAVWezbgLz8U4BuiryQ8VrBsAGugrz9b3Ys0zyKjJ/qEDTByL3cvqf
	384II3c0911gcInJ470+mwjpq1b24t8dFFVBTsD9cLMiXW/4h51L65txCc/k9dAYFk9WC2
	ryWlK29pESM799dFW181Y6BjqFfa9+4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kernel-team@fb.com, wqu@suse.com, willy@infradead.org
Subject: Re: [PATCH v2 2/3] mm: add vmstat for cgroup uncharged pages
Message-ID: <ivlw4c26cxua6bqzg5zyqsc4xffj3ljkjils4j4c3elhmekwoj@ujlq2q2zvomn>
References: <cover.1755300815.git.boris@bur.io>
 <a0b3856a4f86bcd684c715469c8a1cb2000bcbe2.1755300815.git.boris@bur.io>
 <ztt2lhdpzfb3ddvgtqqwzuvdmlz4i5l6ijnwizyky4tv62dncz@taho2tjmqjkc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ztt2lhdpzfb3ddvgtqqwzuvdmlz4i5l6ijnwizyky4tv62dncz@taho2tjmqjkc>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: nk86pktqes15oxh5h989eg54mfb86wpr
X-Rspam-User: 
X-Rspamd-Queue-Id: E115F140004
X-Rspamd-Server: rspam05
X-HE-Tag: 1755305699-366571
X-HE-Meta: U2FsdGVkX18i5KV22fWhA15tHcjTWkr+nsTkDMXZrIBDSso3Sso8m83MsdXwS6EC12aS0Yily4ImVb1d7fm6dtfnHFzu+m4kdQ1qPpOBAgLdt+WU36Zv61WnNArDXZYOXvgemICLStR+kYB3bhVOvEnYXSI7XRLpmU8p3qDXyg7WSW/rTMQ3533yW0krStY9Yfn24z4AB5n4A1wHmePzGdaJRY8Ogd60Xq99cqDRmrfoCG5GYtVZt4Lq6+nAaQO5ZvZNffV3QzKtlXrZDOn/qlZXZVMzU6Ph32Ay2aMHBt01w+WRpkfL2DUnF0v1DBkNzpZxa321V34jSNScAp+QJoWAxatMwicmkokNURdZJ1KCM5OOQvqeF8lcyR1xNV1mzDnvjGmD2um/CXDY+av1eXXbLlxBJKVYOCSORzDav820o9KqorPj2m45V2p6aF5QxfLUwe39j1ipNhuOv+2vzKKE02++exiCrJK+pZaYUd4+J+A/oyye72iE+FHwyhnnleQNeCmEUKfFXNZcaQzJ2PYahInp4ACSNTNODHZLS+MfbJPIk57vMVqWMKN984y0YubT9ElPdttvWXOQQUXQNQblAT04lixXKULkqQUxMGFCAWO0SGujdgbbg7ydsRfM+dXIWzg1B5gAPiSTcNP5ywA/mIkUbCqrQJLoEz3wJGe++Da/w43panDQCfcmBHOz4lIehTT+EI8WgesYBkWfiITLwZI8xNEkg6vy45+eH/UkF5N7xQV8gDOd6NIm4+k/0iZHG0gggkBsK0x2UhrDTl9ZnGiZnhi41ULt0iMLzFJamwf4YJ3R+c2u8LrFL4FvQ5nKa845JjVx8c4M4e3kshiBMQxPJz9+ajF+AaW19n/c7Fa6CY/NAt4DlWVi4960oAC50vvG2BDAcpEapwuPCQKZRqu65Y0imiE2t3OkmGO6lH0Q/ALgy560e8ZDEy5AbDDWgPhdHYTlUdRV3q6
 kALJcokg
 gXjJJTQ7x1UH672drRR31kzGEonpJC0wmczmpWP9VLOLUvOtCWuk8KL/Fo1njcdjDgj/Ra8fUfSsvFwsC7qh4dzU5VyntMfRqlc9iQkHJML2MDfMbwOqSoNCxifvXy+x5mmSaQQqz+zj7KHk26WlVsejgw0kr99DcIfjVGftruyPPtRTBU8WShU06fa5AUJBRUS2i2IPQLp0Zdej7Nukg6iRbz/3HJoHJOfTcRWi5erYmBpg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 05:48:33PM -0700, Shakeel Butt wrote:
> On Fri, Aug 15, 2025 at 04:40:32PM -0700, Boris Burkov wrote:
> > Uncharged pages are tricky to track by their essential "uncharged"
> > nature. To maintain good accounting, introduce a vmstat counter tracking
> > all uncharged pages. Since this is only meaningful when cgroups are
> > configured, only expose the counter when CONFIG_MEMCG is set.
> > 
> > Confirmed that these work as expected at a high level by mounting a
> > btrfs using AS_UNCHARGED for metadata pages, and seeing the counter rise
> > with fs usage then go back to a minimal level after drop_caches and
> > finally down to 0 after unmounting the fs.
> > 
> > Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> >  include/linux/mmzone.h |  3 +++
> >  mm/filemap.c           | 17 +++++++++++++++++
> >  mm/vmstat.c            |  3 +++
> >  3 files changed, 23 insertions(+)
> > 
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 0c5da9141983..f6d885c97e99 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -245,6 +245,9 @@ enum node_stat_item {
> >  	NR_HUGETLB,
> >  #endif
> >  	NR_BALLOON_PAGES,
> > +#ifdef CONFIG_MEMCG
> > +	NR_UNCHARGED_FILE_PAGES,
> > +#endif
> >  	NR_VM_NODE_STAT_ITEMS
> >  };
> >  
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 6046e7f27709..cd5af44a838c 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -146,6 +146,19 @@ static void page_cache_delete(struct address_space *mapping,
> >  	mapping->nrpages -= nr;
> >  }
> >  
> > +#ifdef CONFIG_MEMCG
> > +static void filemap_mod_uncharged_vmstat(struct folio *folio, int sign)
> > +{
> > +	long nr = folio_nr_pages(folio) * sign;
> > +
> > +	lruvec_stat_mod_folio(folio, NR_UNCHARGED_FILE_PAGES, nr);
> 
> Since we 

*never*

> expect to add this metric to memory.stat, I think we should use
> mod_node_page_state() instead here.
> 
> With that you can add:
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> 

