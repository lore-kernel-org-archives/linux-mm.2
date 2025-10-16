Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07842CCD1A2
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 04:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FB498E0003; Thu, 16 Oct 2025 00:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC168E0002; Thu, 16 Oct 2025 00:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E8A88E0003; Thu, 16 Oct 2025 00:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 198758E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 00:33:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB7E11401BA
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 04:33:41 +0000 (UTC)
X-FDA: 84002709042.17.AF07C51
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf06.hostedemail.com (Postfix) with ESMTP id D22F9180007
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 04:33:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760589220; a=rsa-sha256;
	cv=none;
	b=V+YV2UdJgJgA7UpSwgeOUKZJfk6MLbvaMsGNsEybF48IPBsROdl0VBMVLjeXQLVy+a/3Kh
	nEcP5GaD/q3UkQnjheVPZF3pohqte0VQJTNoE1+Zg6ihpMYADfxhoLbV9g/3Vka+y+0UKg
	qNc6lqEu9CWwx0uF7lpNCemYr+Ti7bw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760589220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cxG5a7rYgW5UKD7jxo0ORPmHip3rWKhdSm2TPSjwrl8=;
	b=FMjl8grwjWYj4bgRLO9RoIlBAjirLbUc2NOrJxIdAkH9c7obRgNKPyehVHSr88KIwo68em
	ZWhHF1SagB08csszMxujEUT/2cigDyodBcU5QK5QYnpXYWI6eaIakaN0e8sGcSDltiSUzM
	Xi6vW4lKTtQcBnrJTVmArNFJRB26tFc=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4DC40227A87; Thu, 16 Oct 2025 06:33:34 +0200 (CEST)
Date: Thu, 16 Oct 2025 06:33:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: allow the file system to override
 MIN_WRITEBACK_PAGES
Message-ID: <20251016043333.GA29905@lst.de>
References: <20251015062728.60104-1-hch@lst.de> <20251015062728.60104-3-hch@lst.de> <20251015151353.GA786497@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015151353.GA786497@mit.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: xbamf8h8o3sddote4fm8hn4pzse6r5pd
X-Rspamd-Queue-Id: D22F9180007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760589219-161181
X-HE-Meta: U2FsdGVkX1+LBvZubCvK3hZwQ5fsr/KSQ4hcBBmDHzMrrz23uMNN0AHpIAWojtsWnT904KYPTkTCv1SIHNMVNKQHMzNtiLhcAbk80H90qBIv4XcJcOE8TT1rQQuF9j/XjxfoAGIW7igK1WKrFRyJll2tTHQvd/Qd4tqz3bTt4hXdK+RQ3DGUdWmBJRMdeCvRsN1q4TD2UhLyFF7HReDyV3nDMoem8A7d8mI8oNVc7uhrj2pPzVcRHVhZJ3C3th+hsSxs75BIdJDcdfYTP5X4FxovnSULzxO/0GWY2OdehWSOiTbFJRHUGEml9+gbQ22yWVJQw6W8R2J0tvJ5PuEegwqLxPx7CHqBkVcFtoThwRAjHGf8RI1N9r4AQAvQ8Uu4LonorswPcgXTkyPMI9VqfvOl2BKZn4pj9exuG3yusveYmicGmkvfsrZ3XihPWzVsNdtJ79orvWe2a0ylt+b6GlgAF7k26rc7rITWO4SWdKmCmv0agPdyRpjh4Qvv6Ii0aYsd1r6Xr4T3vMV4UqrfJV7miwPYJAyjaf82hWQZCQlBf2QUFxbS5JK1pLUc9QbRHQFzumvdEhLlMEuC0geg60+5LzzVof75f4h1dHyu4hJOlwSm0oi/ePHtQEuuQIs8tcOduUUn40UH04Bf3GF/zos02zQa4GWb89G9LuhNvb2CBLHTm3RJJ3osnv/JIVz2Nde+ekkyujTMuc2JxD36SfoLr7Y89DkIiu5nyChL/AaZEKvvoA4anMvujJiEruX0Z1Go8Pu+sF4WJNyCUNvmSdBlO93+fErNPz7uoBjePsXNUSRBNbBCAAwa+kUMQWWlN/7SVrEhxw2QTW+kjankSogzzXkaX+kthklG74+ec88L+sLImrSPVyMn9vyNI3TyZFTIuwFt0B0/KAtgOq8VUmD/SHKzNQ1OBh61ujzOtBxqhHAZh/NmL0r3+DeWs1mzDrpebvPo1y0Uve+kQK9
 sqgP4bK0
 7EFkGmZyPPxUoreH70aNXQIcH1qke4P6fIM9TwI/P1uhsY5QkVjL9xtlQ2nigKnmLjCd246NRgPqKWe/xhSTyO/EoP8zaj2n6Z2IdUJ1X78ubSGfwju+GK36kzFbio/nWKQadlB4yNnuNutY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 11:13:53AM -0400, Theodore Ts'o wrote:
> I wonder if we should bump the default; and if the concern is that
> might be problematic for super slow devices (e.g., cheap USB thumb
> drives), perhaps we can measure the time needed to complete the
> writeback, and then dynamically adjust the value based on the apparent
> write bandwidth?
> 
> We could have each file system implement something like this, but
> maybe there should be a way to do this in fs generic code?

Right now my main concern here is zoned file systems where the switching
directly leads to fragmentation.  Besides XFS that would in theory also
affect f2fs and btrfs, but unlike XFS they do not do the trivial data
separation by inode but just throw all writes into the blender with (f2fs)
or without (btrfs) some hot cold separation applied.  But even if they did
it finding the zone size is file system specific, so right now I don't see
much too share.  If we end up with duplicate code I'll happily factor it
into helpers.

> 
> 	      	    	      	       - Ted
---end quoted text---

