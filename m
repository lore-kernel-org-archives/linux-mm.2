Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13F80606A33F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=1/oGAtuW
Received: by kanga.kvack.org (Postfix)
	id 1955B6B05B2; Tue,  3 Nov 2026 04:02:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16A456B05B5; Tue,  3 Nov 2026 04:02:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A74F6B05B6; Tue,  3 Nov 2026 04:02:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D846B6B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:02:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 619041C3448
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:02:35 +0000 (UTC)
X-FDA: 85393217070.09.DED5FDC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id E6E4980007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:02:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="1/oGAtuW";
	spf=none (imf30.hostedemail.com: domain of BATV+2fd16d4a2e1f328b98f9+8472+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+2fd16d4a2e1f328b98f9+8472+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793696553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yPwWcuoDWOTn8atKLFpGQ89U466zx/Mv3d/vV7gtKnU=;
	b=IQE1HwJrL0mC/k1PV37dAFFHNMdZ1iM4zEnw2j4DDMR/YR/B5/ewn2tD90MMSPxAAMzcGb
	c7dXHtNQOKIm2ryVy9mmkVS03fV1KjegxCIKUtnm/VKvGfEFZURcUEpw9ISrNvVje5tK/J
	1IbfoK2VE7E6Sizb5xfPWdjMjnd3hhg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="1/oGAtuW";
	spf=none (imf30.hostedemail.com: domain of BATV+2fd16d4a2e1f328b98f9+8472+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+2fd16d4a2e1f328b98f9+8472+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793696553;
	b=StDI2ftJiZJbCArUFpkU0h6wRhf77LU1OqFhcf8CHuYn6n2qgIybmljXkNUQdpew6prc2G
	ivtChUVDaeK0mX6skkt9Nx1b8o0Bas1WV62XPow4j/oJ56Ndq3MJReTi7YkeuUyEfyvyQD
	CuPoxrReNJuN2jb6O6UeXERkgnGpAG0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yPwWcuoDWOTn8atKLFpGQ89U466zx/Mv3d/vV7gtKnU=; b=1/oGAtuWT2KWhEFRC0FTkzNppH
	wgXiQ2Ax4H/oBJt4BaXkLjBieYi3WUfEbFUxTw3xeT5wFBZpKwfVO+8jSBpOGIzs1SI8IfInMaOJM
	ZtULKr+ilyZI0KuG44SlzdR66N7LRMAVHnrjak6xgOtaQ6U15Fftbr4CnuRKBgviXR55bg77aszF9
	GMSWN0JL0gx7Qo17wPfMPofozNRuJN5Tih1J8LcjLSB0xFy3YIAbh5SzYzpD5G+iM2MHh8WFy+1b7
	1LV9qY3FTE26dPYsAG1p2DZcWv546ALdk2S7drH3vVBfTNfYmqNUGVyWwbAaoe0wSq0PI+A2+BZyJ
	WvC+VZOg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOAPH-00000001g21-0qAv;
	Tue, 03 Nov 2026 09:02:15 +0000
Date: Tue, 3 Nov 2026 01:02:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] mm: remove newly-unused page wrapper APIs
Message-ID: <aumjF5peb2vyuncA@infradead.org>
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
 <20261102175605.a0d9caee8279ffb5f6fdf15f@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102175605.a0d9caee8279ffb5f6fdf15f@linux-foundation.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 1iscfuddobzrt5wweyac5ssa8ub9zsyk
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E6E4980007
X-HE-Tag: 1793696552-733089
X-HE-Meta: U2FsdGVkX1/Vd9H9O6aiStnbYiCe5jjlS2CXKHW0n7gkqtTpdn6U2vOBUPowrXmYD4C199BzPiECiHVfnTFBeddR3QduZ5a3qJbYLU3e72G7JJ1lkSRMByXWhXZ8ggYF14Uy11vDV8q2XA7lxFb5U5xpYcH+UYMM9BqGZ4aerfhkxqawvfu1ITNIPRbemFbjvIrOCFsjOduJ60V8TyPTitDMwm9SfBSzttRFEf8tt523Ksmmzuhjwm7VME5Aj9f77r96CcFVdxB5A+XqIFkFtxqq5ki+ISgukzraIc6fO9hsA4t6ZrDvzgP6HxfdCk0vZcdDlTKQRmXZXw87kgXKR2Dj/5tT3fTO4cnadwpFRo4EOS1UZZQKiaAJYfuPshfTLDIwLmzKQ1LpTn9hngq4Rn5f+zA3wDCeez9PTsTXoNd61LtE5fxx0TEhKBmzpXRDYwpR2DVZmOoH8UJLGMh9ccWBXD2nStocoqI84dM8nNtrNDdDNqWN0rKrYyUGrip3qHdMFMq7TVLhAAwEueBTZkxeIIIANpr2VLUfVfTmxlba8f0yHADE/7C77/fVvNihb050c8OcPLlOn1WU5N9jP95AgpGsI7me/HnvJDp/Qa+MO02l7iUYvMHXg/1ORiEsAwyzlyALK6Gok3wBz9gvMTlhSOFgClyw1CyvXh1/cTZWmNcrZUimHO9UKa/J5+uv2lfCuMp9HUpV+xZrg3O/82D2+mCTG2aVU+h2tAp3j0LDb+hcVCOWOmiNdMGZ4qg1aophEnHn06QEB8pk4osJRXjkTapQ6AGvoMY8SroHBZ26L0VP+fLf3/ggOJBKdTUe4tTZ2tvH2PBieUQZ6l5ECf/FpurqC8BxvaxdXG6uTpHiTRpxPATUSGYERISwJCZXYdJh6K7dqSXdb2exivJ3aM6VomlGlOHxbkif2pX42JGOOIkPpwqJctmFD9/jpV9GvwEexV0R359qxkidYBF
 PLWnRUII
 MdSe2k9phEfVsmxtoPqnu+UnCI4OZLx58kn1sqftXy1lc6fLg4YVF4nWU6/DSVJvp/nyObqDpCwlMBTqSCbNKTqX74/0PdUIev4zjWfj1Ro3/hDaYgjGmrdFjmfUoCfcVTtM4e40kMjiDJgrU9ouCjbD/WzORUw3mrq0VRqBPc5KCg+pOO6Rdes25OfG+qCui6WVEmCnnENEiaRCgNeBhJNVT5IFLjkNgv57xZLGwX/vgJgCWYSVdhhr50Xy0cr8DFjB0jop2euP1PXsO5Pk8Cg4jkT1cs6UFrDHzpv3Fvc8IWlS3RSuk5IbTzFGEBeNfAmZWQ2/pVPLV84uiDzIkJJDm+R+JFhWUUSdDJ9uaEPqN8EnEEXHCVYsBcHmWdmiIHHwMadzmmZhnfRpQ0tvVAUVIeySiZ/Cx/4ab4W9M+5ce2T3b+dWhDb5tbaTOLOq9PaauE6qPuZTA58KVORW+zjJm29JpUG7Yg/q/eh+H8BpYLQ0ZgLnqsDJ07prrz4PbA6wwNUTGRs0vA9V07qmPWknPYnxq4CNt3Nu7XdbsLebW35Xs2LdCBaMAcil9T6UsmQVOgBa+P8pjg88=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 05:56:05PM -0800, Andrew Morton wrote:
> >  9 files changed, 8 insertions(+), 110 deletions(-)
> 
> Tal, you obviously haven't been following along ;)
> 
> 
> This development cycle is not the one for cleanups and new features,
> but this one sneaks through!

Given that this is purely dead code removal I'd actually vote for
fast tracking this into 7.3-rc.  Unused API better be removed ASAP
before people start using them again.


