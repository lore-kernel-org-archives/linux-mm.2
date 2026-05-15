Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97160CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 11:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A29A6B0005; Fri, 15 May 2026 07:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751A56B0088; Fri, 15 May 2026 07:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668406B008A; Fri, 15 May 2026 07:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51A776B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:33:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0247BA0666
	for <linux-mm@kvack.org>; Fri, 15 May 2026 11:33:11 +0000 (UTC)
X-FDA: 84769443024.15.70CD7ED
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf24.hostedemail.com (Postfix) with ESMTP id 10B3418000C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 11:33:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf24.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778844790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qP4J/3MbqmVPdYK3GrljdHPsbVgj4MVvh5Ql1yHR2O8=;
	b=wOoPL5/PvYc6Y8IZePVUM6NDrPKR7wbKJqQZoe8huXll5otsMnxhPGn0TSlkvOzX6ZsUlz
	Nsk7v34os3ZzQ8w6zATaFng7nZX2FPwfMTLD0cxh7BuHto1ggQxOzmHSeSk2C+cAd/p1NE
	zLWlRRmIXOknF18T9gXnktvgoDd/zFg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778844790; a=rsa-sha256;
	cv=none;
	b=3o6nbwxvE1TgLCSHrmJjW0NMWmbfBdtVOrmfugmYj2FomYVXvFVb1m48g3ajsryO3rM3Vw
	jWEyexiQRb3q8iQknE5YmDc77yqSYv3/bdyM4wdVRQOyHemWIm3JsFzHO8zaf7WoGAKuJT
	U9N9WAQVbk39cTlD+/hd5k/1uBg7YnM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf24.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1E85C68B05; Fri, 15 May 2026 13:33:05 +0200 (CEST)
Date: Fri, 15 May 2026 13:33:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Steve French <smfrench@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
	Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: improve the swap_activate interface
Message-ID: <20260515113304.GA24980@lst.de>
References: <20260512053625.2950900-1-hch@lst.de> <CAH2r5msnYVb3hhXHwqDVHGGC1h4E6mLCRS4ktCrQoD9zdUW81g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5msnYVb3hhXHwqDVHGGC1h4E6mLCRS4ktCrQoD9zdUW81g@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Queue-Id: 10B3418000C
X-Rspamd-Server: rspam04
X-Stat-Signature: hx5rsyuzjs9zdoepp3dqru1umuj6ht9u
X-HE-Tag: 1778844789-279890
X-HE-Meta: U2FsdGVkX1/hn09dKXJwt2fao6hHsnGrf6AtDSSn80j7cT4U3PlFPthELRJYNDg0cITR49LTlE52vgoeTXW3bLFAjKOyaqxlltJAe6TDqCHKCZfYEkpm3O09X9J10hkFXe3ePAszcNIE2Gq/1cKuY3tApJdy2dl0DpXvWWR6lLKYUSyT3dqVVMI53R1ApPNUMPvhmvbmZWn51r1eM/rOD+Y4EgiPLDLnskAdopaRd3EvVEIGzmVGKPHQOCu0GBYLe1UrMke7MeNvDIW5tqF7Qjq7mT9bKOUh03Tdsf+X/arreUR1FC5PUsBUnEF7OLmlARAFm9dJC+OBU1q2967cApTCyHiZHhyMFsQRIQQbwv+Sik1Z24N6M45W4FhTuk5i763gOUQH4dL1RZbUlwDqD0CI8rbzPACecngonHH/oZ0wDjiyeAI/cvCQtN2KAi+HH21vkrakua5UCHoIDVswag5uNx4+FuZwDLzrth+h6fF3eQDDOYU7zk7jTlKmXPHE+RtSDolg7+7SsizmTPqtM0KfhzPlKvKdsk4jgCHTIHBojtg5bNjbA5D0d4nskS2fOqzF2Y8OnZKrsBSETXhnTfo9a5Xop5MyP1efti+HYkPnIUYciVhrLiHLxLgfuYqt7zleZ2LKccp9IO8VOHfa8vlOD45hPYF/wJNmkQEUWVN0qGvuvll2j6nnNE8jI9vRWHnoKa+n7L5KMtJh//MbhdSxTa1AKYyMyyk6sPWgHd6fO66ZQrA3M01c19RJRnapaEODm8fPgrEdnDKeeAoJdoUUc7WMmW5o0JHxJv9nVqLd7m7IQLkwTkJBx8x9jgkhwULuSGQla3LeesZNQdW3MzEzfK1nqGIcsH28vTFe/A6VH3VdkU/o1MCdxl0LLEIq1XvYP+GU+zdKl0I9FxZE5Kwne5/CCNLdMJg9EJaXoeaDT+SuCCRX2H07E4zSEDaicGEZ/jS1n+AXv+VxCf9
 XkT48Ps8
 CDGwfuM/d0IrB0JNy5PzlmW15lJN/y9IIVgTkcVoRHwR7Lcvjv6nLF3UraGX9tW0PlAy5MMAww7j+PcylPSv4Gvvo4BBWbrZ5wVXDdVfz5l9QU6rOJ5clAeN94NBoCoJemSllyz8IaMr0l5tmWs+uLHp79TgV9OaOEgpQtKzkcOTFz8ia+9zoDjfWhydU3fps6jmP88wH/mTtQ29ClfpxzZVq/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 03:34:03PM -0500, Steve French wrote:
> I just tried this on 7.1-rc3 with the swap patches (full kernel build,
> on Ubuntu 25,10) and boot failed with out of memory which I had never
> seen before.  Any idea how to workaround this with the swap patch
> series, or is there a fix for this in the swap series already?

Is that a failure with the patches or also with the baseline?


