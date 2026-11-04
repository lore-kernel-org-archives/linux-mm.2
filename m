Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD193606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEC9D6B05C2; Wed,  4 Nov 2026 04:18:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9DC06B05C3; Wed,  4 Nov 2026 04:18:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDAF96B05C4; Wed,  4 Nov 2026 04:18:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE3896B05C2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:18:06 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3293E1606A2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:18:06 +0000 (UTC)
X-FDA: 85396884972.05.003F8DD
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5D54340005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:18:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf12.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793783884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M+g/PqMDYZQI68tfBBcin7qYEE0xbkk7OS+btL9Bc2c=;
	b=jbyFKobv8gCBT/wUh5TiulJF7ZlkGX54ax4V7JXBAJMrUvUsxnnXw2Flg/TFnwwyGu0FIn
	k7CLgvwS5ejBNPGJUyz3ECRku4B04IQ3O0DloVQuexBE2koIphDDn5eFDgv90lOx9YNSm4
	GNYMAGgl/uz1uHPEPdq48JkbFtaMpyE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf12.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793783884;
	b=OaBGmlt/Fv0LgTb2uucRVHMrd9icwn/0mKPIJKRvUwFPijqBunZemlFCCGh8GqrWmKYhi9
	gaOmGY7HeCE5IUgVUXvu51usiD7S9FtQ2RtfxJCCjanSSUaCQ27dzNzbKkXRvIIezZjr17
	PoxQd09CSTLkeBteg/RHfviffBBn/Oo=
Received: by verein.lst.de (Postfix, from userid 2407)
	id AF6C568BEB; Wed,  4 Nov 2026 10:17:59 +0100 (CET)
Date: Wed, 4 Nov 2026 10:17:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v10 1/7] mm: move clearing the uncached flag of a found
 folio into a helper
Message-ID: <20261104091759.GC31130@lst.de>
References: <20261103211754.35352-1-snitzer@kernel.org> <20261103211754.35352-2-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103211754.35352-2-snitzer@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5D54340005
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 9jxdxtx9b71zhwh6xggeeca1t4a5xj46
X-HE-Tag: 1793783884-34820
X-HE-Meta: U2FsdGVkX18fmj2HJCFmaaoNUMwshGeyAJ1N8aUZzfF4+nvX6saPIY1WrtwFV6wdwmQhNh3272956QXTol9apM+lLj47qY9GnworFXnD3WFrLHrOsqGqooQPzZf6fMPFVQBX4np/5/kvz32CMSg3U35n2BosL5B6s3WwETHmMIth/x1OR7rJtNY+rjmTd1RBkHyk5j6azvkJzO1x20JynsJshgIsdE6zPqwjvvw3IWJ+fjQX9rd+UT6s/r5razxtlN+eRKE73BDuQRg//tYR3x13rZdhQQA8FuowuXbYGpgJZarpn917zwudkouBWDpIDYPwx4h3AHfg1ZPBqOOfbgg+qi2FSWgRWBvjkYEpfwopyJpkHbGtj1rjPLqKhTodUCjjlWuBCTHauSI6KUJfSlTHIYfqZWTM2kPLv/zyOZbeOEbH+UJD8R1oWG5K+Uprru+xAbwKnDHxYLsR6mUsGLtbexqZy+vYNMtojU9Y7ARaTDpz7pqXXDjaZRKKwblS5AYYHUzdSu3E8rzFeV1BhTPaOYLHyammPudSGXgpoOjYe8rXNNyN/NQPXposz85snz1jrjd5ZUT6eruyqbxSm5+AHpbhHqSFlR+hQmdlRDgUJR/1ilWmoKVO1jSCPBKey1FRAg/w353PZYJWsxDGXTijwhkIMqvXo2cNHAXet2j/CUBT9g3tN9k6lNTTcxcPlMvbry+WtClHUM4OO8cPKQCB8+xAXiqxYxi9B5PsF/YgWuu9mnXnOUkfhYPmBgE11w6oED3Rk7Y+s9GwcDNYawQxV+ntLPqWxHHgUUBzSR36y1AIJBGGv7lS9kJeSh6d1WvfzasLRazfim33OCuEqXTHC1L9e+yyBWPd23zbwgCuv+qM+hHntKtUgCo9wVqOu7Zv/9hfUtL2ErzTr8o4Thz4n87f/ka3DvwAEcgG9Xgbe91dhWRfM1ZNpqAQFUN38m/c7ylE9ngKt4KpsAg
 uKz79Q0L
 O+2+IyTiGIbrGilzteZMMScNNYGBSKud2sErIvZ6u4DGwzcpSx3+rGDiF+9NBmuKhm/QjYjeJU55Xi1/yiJh89ONbxfwJFZsjdXbfMQB0QGvnujUyvLkAZxaneWHKYTiwtvPgCpmWjWTGHJJAFQHxqfz+VKaawh6/xLkaIJefamp994ZAvtLQA2UNxxp22nSctg3K7QZEnefkc0fQG/jXpl1OCcE5ZJr1pttHLdEOGKSeQ+WwkOEDgaiyX7miQmn8nsHLOfyelLClBZk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Looks good as a general cleanup independent of the rest:

Reviewed-by: Christoph Hellwig <hch@lst.de>


