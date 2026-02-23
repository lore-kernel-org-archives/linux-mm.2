Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7800EA4FC2
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 14:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF3E36B0005; Mon, 23 Feb 2026 09:03:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5286B008A; Mon, 23 Feb 2026 09:03:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1156B008C; Mon, 23 Feb 2026 09:03:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABD016B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:03:47 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 50FF988C0F
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:03:47 +0000 (UTC)
X-FDA: 84475889694.14.6BB5DF3
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id 24ADB40014
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:03:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=UamWqCMb;
	spf=none (imf12.hostedemail.com: domain of BATV+48176073e30864d8fa6b+8219+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+48176073e30864d8fa6b+8219+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771855425; a=rsa-sha256;
	cv=none;
	b=Wa+kWY3k7RaPxN5B6Ll09SSJbgRNtAp21Af9ac5lLaBolgSlMKOSTe/vML9HOrsMsKWKPl
	aEHQ5JcQpwhWJz91MSEyUJygWytvwP6J9cyj6roqkGfpi4KNS4gzp6Yk1Kd36J/8D/jIel
	Y01ptf6lYtXGarbLRvE/O6fYJ3YVj2Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=UamWqCMb;
	spf=none (imf12.hostedemail.com: domain of BATV+48176073e30864d8fa6b+8219+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+48176073e30864d8fa6b+8219+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771855425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x0bCF0gSNivwN6OED4BvckqGL7j34q4jTf0yj2ndCis=;
	b=Z9Ogg6C/7wLPg2xrltkvPQHe4F0IyS3Ps1/G0CDPLcfAMnH2949B7+UWPfoC69I4IXfPnS
	j6BfLVwXZLCtnOgML/2TRCsezNmmeJ7z+eQBGXTKNQtlf0BUnHfFh/GenffiYkz51JsWW/
	IXQl84sewK04YXNYRbQx/q9UwQC/onY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=x0bCF0gSNivwN6OED4BvckqGL7j34q4jTf0yj2ndCis=; b=UamWqCMbl6P3nbszGSl40uzFdI
	l6ZjTjAvQZpcrAqLBgvEpn1PTBhaHyLcLM8nELM9k9jjB6cjpWItZhBWSB5yo2Ld35EG+LfWoKPTg
	wVZxxM82kFhZnjlwTKTAN6hU7JgDj5V5zS6fWPIUujS71WuSauUKRLhQZ3h884V5YXbE5yeA/3o1z
	g40QtAPXSLaE45U3JPId+LK77m7RrY4TycmWevnGT6EuY2nKm5Xn0QxVi5dZXjgXlrt2BhEC48Zyw
	uGKob5+htZDIPIv7s4zX/dbitIPZd//Uy8Ip1NfgtuTMWU87fVwdAZnqjL6MVezLjACgLXbPrh2rA
	Z8z5r+DA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuWX0-00000000RIL-2hdP;
	Mon, 23 Feb 2026 14:03:26 +0000
Date: Mon, 23 Feb 2026 06:03:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, linux-block@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jason Xing <kernelxing@tencent.com>,
	Yushan Zhou <katrinzhou@tencent.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Eric Sandeen <sandeen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>, Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Gao Xiang <xiang@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>
Subject: Re: [PATCH v1 00/11] Zero page->private when freeing pages
Message-ID: <aZxeLmNyKKTrkSzn@infradead.org>
References: <20260223032641.1859381-1-ziy@nvidia.com>
 <aZxaIEFZr2NvO2eQ@infradead.org>
 <F1307EF8-7054-4135-B61A-62141A113394@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F1307EF8-7054-4135-B61A-62141A113394@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 24ADB40014
X-Stat-Signature: arn8uboq9ruwipgams31k99k84ayhhhw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771855424-108287
X-HE-Meta: U2FsdGVkX18b1O5vLdFQtxMROMrYm7Ne2ZmkY9M/QmfxhKiZq3pJSSIPTwcehxvnHTZdQynzariwigTkOcz54f1Hzw3RbzDSJiJ0wb8UwA+hCvQsI6KagsrXcaxfAmV8+WiOhKbebIfIU7j4mx2M97+bnlWa7uY6EeKKoe9HiuQROq9cYF/k7u5EnJJOI4SGTGxrgzXzraG+DJO8B0sRYNtYm+qx+p0DWSmcvf0LHZP736q5hx0jYUwyVBn5GeaVjdhmmXJBE29tjkDVUu8h8VjVngW1RFOSvSEaHbzJJh5iYZqhNEuubcIU+lOB0LE8O5yG4pmSQzPHqZLNhor2RbSQcWk8i70Tz2BfE1rG7WMxDC+Xy7l+rph7YNTH2HU84JmPY8rR4FyybpaUQqjwtYmmklfLSk6GCPsifwll4147ttdmyjfwm+N6s6LVCKLFRi6d8ARqlDX43Afu9ZCXVAkdiwDyodeV+RyoX/6fPNoFBFrtwkiJWpHGqhKWf1acrdXYP/bTtBCHKDg74hB0yhI/IHoKPR83sxQTb9LL1HVz0PGbfPphvDLX9TU0PovqewJ/vc99ShgYHG5vKePnmONKvZZssDve6+dEYYXSJuErmoSzPGygDw7moGFpN8C4g2B3sWgVMF3yQqHA0cFEMnu68SVieVmyc7+cEe6LZBEnbNltsLu2zDLKKev/xV22uPjnbOC28eba2xPvFH8ST3aSuJs+25A4OhQYp6sv4r3SyVqTrhC2RqH0CzOxpI2tfkuOb2PWvVawGXuoJvq3qUGtxTtYRN58v92EXTQBj8Qj5lU02S9r3V2BsyRQN7K5I8W6CQ+NlUeJTER/HIIZfBErrEB+dB0SdNQeaXm6tRPw0bSSTj9BlT0mLoa19Nzjgufu8X01V6GaVowxsLB7bK3kyI9oc/WN5bgiAMcEuV6Xfv9dtzaXrDxNPoMv/FtfqQmXPjmGrAcXufqHZBS
 osmd/7xE
 FUNrx8H+TyQb4iW+J0UzC+QiR1MJN5tf1DDbmg7t1mtBVJzrRAU4nd8EpII0KZ567TpZd6dhnqZawPU0nXO53L0/wVa/rdCEPg6mDvj7qRjlIG6YEmFOGV1zmZS1rDJPZRHY10rTcUPFfwEe5czqiN5v3tNMChp0kSbec4vSZ1g6IA/ZAt/3kNX+shNtiS1GAmXzcseBVayfol6P2Z4WeX4VLCEvAS0eIbKP3hgJf6WPcDS+vVWWyfuBCd1WdEr6v8DaBLr5BhQ6HcGQz6eV5NU11x+h72GTbrezpfeHVtmlQZoX7/EcxsnZj++kSLrDfEVIrk3tZaMoY+SbHhLDIzlCdfSwFT4YMmjZLQsWt1yurJdc/ik15VlSLZwPd+1GgfDnUH2PjURHt60uqMAZBg9E4tNuB8n00axnubNtQgWqDVAtqw0CtxeF6FNrQxxGQimliUORA15tqT0VhD2Z/mrJtwv8eTFK68tNHmNc4teaFPPqtYrPfKoqukg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 09:00:57AM -0500, Zi Yan wrote:
> > awkward interface.  Don't do that.
> 
> Page allocator hands the user a zero ->private. I think it is reasonable
> to require the user to return a zero ->private. Restoring things back
> to their original states is a common standard, isn't it? And most of
> users do that.

No other relevant interface requires private data pointers, as that would
be silly and cause tons of bugs.


