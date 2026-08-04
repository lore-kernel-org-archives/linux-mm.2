Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A03AC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47B346B0109; Tue,  4 Aug 2026 11:47:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453B66B010A; Tue,  4 Aug 2026 11:47:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36A1F6B010B; Tue,  4 Aug 2026 11:47:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 14AD96B0109
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:47:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F7EEA023A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:47:31 +0000 (UTC)
X-FDA: 85064016702.29.84C619B
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf11.hostedemail.com (Postfix) with ESMTP id CEB7B40008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:47:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785858450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3INYlQKobLh4mMVUFvPghDpGiNw6y0KRfCXHtoDWGyE=;
	b=GvujAkDNJDwmhV6ZqejsGqg72PRjQYN1L4zmR2u7e/7yjvtZSEZspBBLLD9by0rzMkod3a
	3H+iQ6Etb7LXR8FN8ga7uo7rQyANI/1HJijrQWS0OKU/moEL1VwNnBBLdH6JQzCVL299Lj
	U83TYDlkBYvpy5/AKJmxLx2cbprBew4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785858450;
	b=EHX3hC1CYhV+6OoX2X/GG0pbgOaPONzwmdrHwc+8OQHe1Hx31Tro8q5rHhNy3pbqopItX7
	Uw7WaiyRGy+77AduAsBGOJNAbqFcNKSDPbwHUfv5cYKLqX1nr1WPSQvWt+kYjSAoPDXEwZ
	cSnj4l+arJRk8lg6HgumwxNeoSnREcY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5789C6732A; Tue,  4 Aug 2026 17:47:22 +0200 (CEST)
Date: Tue, 4 Aug 2026 17:47:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: yu kuai <yukuai@fygo.io>
Cc: Christoph Hellwig <hch@lst.de>, Tao Cui <cui.tao@linux.dev>,
	Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Nilay Shroff <nilay@linux.ibm.com>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 2/3] blk-cgroup: store blkcg in bio instead of
 blkg
Message-ID: <20260804154721.GA11379@lst.de>
References: <20260804065313.2092022-1-yukuai@kernel.org> <20260804065313.2092022-3-yukuai@kernel.org> <a677f581-344b-4d99-846d-a00801e26033@linux.dev> <20260804133208.GB8078@lst.de> <0fc5dd22-7a8d-43f0-8555-d2ca966efff6@fygo.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fc5dd22-7a8d-43f0-8555-d2ca966efff6@fygo.io>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: CEB7B40008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: sbbiope64rh3zqqi98yuyob37bgtdcyi
X-HE-Tag: 1785858449-737076
X-HE-Meta: U2FsdGVkX19gRYT8NvcNZGLijXtERq02RywPalFKGa7bX3n4bLqOB4SSzA29H2Va328NETLkViJGC3Mdly0KwRXnvPolp3g2nBBu3RAklYnMuiznOIZVOY+HSNrLs4IjIcy+Pxs4Empz8bkOdJf8zuS+z4W7CZT8M4Ro6o+NKw7pV4VZoX3NeCxJvo78/tNQIs6/DbNWrbArU/DgpWaJRDjhy1Jhy0h85QAsdxBq3GnTN+HpuDc+yIAPrOdKFBDrupgI2lH0iIVoxKZlNg0gkSLyUSjuU8B1tt1Xf+TMaX8qu6YRpxAUFvbLVErCdzze8RikBzBqmxOaqFHVAWEMjuBPNJvc/3mrPE/UFY1B58R5xqD9MSH62dg75wwaVf37oRcE7DmszLEvSQ95wQTIRL3vYUks5NA0iJRf+kMGPZz9H5nM+hM6uOATkG6vE4uDdmeAQud4cpHEtWvYy2ohmpywsUmv5bGq0Mbfhd2nv+/GCBBsulCPQ7RXu9kVfaMMsJsEDcRPNs4RbVFGUccU5Ctt2nljcT9QfEb72SC/2ICwi9mXfQAgyl3iokLrBmClsNf8LOaiiaokNNfFfFk5ZHib3B10RcrMpa3QIsDwx8lx9DTnUH7rIHsPhgu7l77yTXHtwAJiSNlAjOuUSuf/NSV0fA5U/DxSyufl8Y/FoTSLZK5CPY035FN8Vl33FsMAAIRCZAnDICs7zp7n6pjHybEvz6ry4pPwwwy5ThCQw6DAtZl5BqnyQKTr3wJh7iAC6CFIEz+Pv6CFSc4ZuUzf8yQrPDykEH6tivy1ygMcs0lkO7MQ+k8UFmkDsJj76pwupqvaCS25YW21woOyGNf26G8CGayRTOGwoPjHFYd7BZ6KmT/95vadDAoPTeMiCAW1yfNyeZmD+CAqnIYa6o5gh6QQsVYk4fQarIEARO9Zy8mQqVODQ7q1N7FGn7Ei0vxtSyux5pX/9KIRMmvrenW
 RxtD/kZ/
 15UDZdcuqLnilfVkQynz2OOV/PXlWKVHr3IQ/sLV5/buePpFrNqY1Z8evKrz85FJl4gy6rz9iM9jLv+NgRXlyKXNkcYdf4A9edWEcto7yfUaZaV6CO1nF4WbuDXbfl1yVG3Sip5lFQuHfi+Mm09bqgGNoW7U/rbD+6JX+ZfF5piRSEhlC/aLZnucJGouRrAQLsila
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 11:30:55PM +0800, yu kuai wrote:
> The problem here is that remove a cgroup can also remove the blkg from radix tree,
> even through it still has active refcounts. I think this can be fixed by checking
> the cgroup online_pin first, if it's zero, we can search the blkg from the
> request_queue blkg list, where blkg will not be removed until blkg_free_workfn().
> What's better, if we can convert the blkg list to hash table with key as blk-cgroup,
> it will be much better as we can lookup from this table instead of blkcg radix tree.

Yes, I think you can really easily do that with the rhashtable.


