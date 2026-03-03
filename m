Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E231BEC1458
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 14:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CC226B00A3; Tue,  3 Mar 2026 09:09:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AC956B00B3; Tue,  3 Mar 2026 09:09:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1367C6B00EC; Tue,  3 Mar 2026 09:09:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB3546B00A3
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:09:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C490AC0D4F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:09:10 +0000 (UTC)
X-FDA: 84504933660.11.787FE56
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8C04014000C;
	Tue,  3 Mar 2026 14:09:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=KoDW+rSW;
	spf=none (imf09.hostedemail.com: domain of BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772546949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=od45ue3vu32GoRqWe7Ux4lCSbKCltE1Eibw2V39jTeQ=;
	b=RQ3kylfDsOyDsfCvQ5zF7E4aJxDjuNgKNzVixnD6JXmwboiVleJQ67YFJoqP9pihhNDMpN
	1hsUbZUDtKPshYVzevQue6mfUpRy6UZl80TZUIK48o/ZIH5nMeZf9pMf8lpVu5TlENXjXF
	KipKW92kcDf0/sRWY1iDnZ+yO+hAQqY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=KoDW+rSW;
	spf=none (imf09.hostedemail.com: domain of BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+880759e8e7db559b7569+8227+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772546949; a=rsa-sha256;
	cv=none;
	b=LwL3QTFk/eIs/ka1XbjND8zF2u8Ozu+wogMkl1k2Hnp/PJjN0Ddk5nVVecsmgvYtX6dRoN
	cbIgFEqqrwJnAdZ0yp4ue4fsqqsjYW7BBGOfch2AobnDuIDfTrFHjQ+iieDQce4VC/P/Ko
	TLVpNSsQGUDlexmfm+Enx3AH6B4c5tA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=od45ue3vu32GoRqWe7Ux4lCSbKCltE1Eibw2V39jTeQ=; b=KoDW+rSWC0BRlHPnPMSudCi6a/
	dNEomDDqiRYTFO3dxAk3ny0bQZVUxhDlUKrhWUvlVbrjoOswnfJBNwL40HQlczaKK3hRa4j0hpcWf
	IUGK+dVJ3OJP1tflf7i5R1Dxt3oFTsAQI6fOWyEIQTafb0GwrFF/R3ZulxGZEngFJlviYzcpW0hjg
	RS5kCwoRtBTwuTbJC5Aj5/5KDXU6V5UTiQeAyq8sVet0aH4U5SUyVRt1JgND0muS+hhMuD1r4Ecsb
	BwbBwkt3qHgddXG0kDKJHw64DA4OXu/ocqMq7zSLmH9kOyOoFoSU2i80zkqjlXkLG1rWA0mpdQg5a
	9RDSefnw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxQQp-0000000FI17-0hgy;
	Tue, 03 Mar 2026 14:09:03 +0000
Date: Tue, 3 Mar 2026 06:09:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH 21/32] bdev: Drop pointless invalidate_mapping_buffers()
 call
Message-ID: <aabrf4YhPJ2X7n9q@infradead.org>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-53-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-53-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: rddxesdadxn8mttxrpiz6iijprhws7pm
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C04014000C
X-HE-Tag: 1772546948-900177
X-HE-Meta: U2FsdGVkX1+AkJ9tsPodcmZWntArmiOUnfoDun/rKP4tuB/A1K9lmujQ2nqCVMQNV0j6FvAp973L0MPu8r6iw6D2as+HPAAZ/sOciwSFnfQn9BabsQX7/eTaVbDdUW0gSwaeBUXJW7kyDKyQP6d9yZmQbnOHhIPtHBreALZiif7bNzGtloNFsDzwCOWnwAH2PAmTnr0SzN+m1/aoq6oZhuY12/BFjGojPw2RMdNM67vR8ke+5FhHMPbA+kfXri7dozO9/zpWFC93xAspXtkzJwXuEXY3kFWK/iUzzB6Sv2TaSi0bdj8xrgYVmf9OCZa59pacgfckKCKaaMwuyH1Gr8B5GsfQ3GXx0Bd5pC7mn33zNqNWoGdyoQR1nYaXXmygbeI4o2Q55NqepkxHhLGfu7T/3dax56xZxeaCrCsmvrKxlYo/71d8Y6QE0GkYfFl07laLGIK5R7gSoRaX4/+ywBW+ppNvdThITTwAHjspRYB+bf/TUQjgRxALtxVqo91qPsUfN4ghAKW0wuUFAgVddLj08xfKc/GNxJlFYEXO/K8dbMItT0iR2/rGRniITjdiMPYdyVMjX9HV6KhpCV0rBM6C/RTWT41mEirUILfo+5ALYIQyOMDwRlKu6nCFO00mXSmCY2v0/KyhoVAmzz2luYpXhGPQLunGYS4PCL/kLL6+TBEWypKCVcgmho1LrQX7/06Sx1nwK57xGceqEDWXG6Nonc6+mmlPT0xFOOvRaEcFI2vPeDQdHIs7jeGUEykk7vgtKKeIHUKRJaspgKIgq5BZNaYQCc0j14ZTd/izFrlh4AhctkZsBEBzlfL1MctWfUUtfOeH03skUGPSzlW90Rw1DvSBijlhfXaz8eK2SioliTEdnNGUzgoLmWMy44HHBTT334srqUfpO0mbIXsOWz8ZDr2x+lTqRo5oQqGTWhsdZxBsMb3HwW3z/Z10uYyBDaKJirGy3TGIMPFWtrd
 ygdEUf74
 +uKz41d8YvBPG0DQvgmgglR//X1XpjIeUYjqrmrLK1BoZzWo1jBe188bM6S/i2wrN7nXhV+tCgH1enXA3bybKIKH1lV+EKOJbAZKz73pAD/DxLajxDYds3zoSziDdbVuv7JWFEQ8HT1tP4pApYpDdVNtPGiP5lTduj5vxe9yKd3lKQwf/biasCjQBSrYkPeFaiu5iuV28zZF+60JwWdirJhJRCUH10OCjwyh8D11ilcuVZ+0w9tgR3poiL/JGFthcCbg1Zvn92I7MzKuR+fh4V4LFS0OFRudJKLZT4aiAZLm0icDHRe+RvtTCjukzktoMTmj+eCNQVLZswVWaGL5QI0sReUIu76oL0RsftmLi8VngHPNbpsHba7wBeMlr/y3jFpCKGHdOEY1EMX3skV+mDHlmR5ZM7zIdjQAGmGB2gynC4Z4aTh9vCrHelnafeDj1MYRgba4Z7KBv+5I2qPkTziB5bH7KkRxlJ4JK9TFtk/lcts9jEfSiQV4IOGSyf0YLVRsCtYCtuUW+bBZACfjps8uphZJMuOeBngTyKy3gUeCXUs4r0Y5HHKojRSRXckJcwkgI9/PfMhYrx1MG2HTWBtWDMGTzs6Ucz4Ju+ipv+ScYK5Eu6uKmZ2JNsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FYI, linux-block only got this patch which is totally messed up.
Please always send all patches to every list and person, otherwise
you fill peoples inboxes with unreviewable junk.


