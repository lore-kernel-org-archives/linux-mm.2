Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B534DC9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 09:07:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4116B008C; Fri, 25 Sep 2026 05:07:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6D966B0092; Fri, 25 Sep 2026 05:07:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35796B0093; Fri, 25 Sep 2026 05:07:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AE586B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:07:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E25211C23D0
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:07:28 +0000 (UTC)
X-FDA: 85251706176.08.DF3D1C6
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8D3C7180002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:07:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Jm2UAcpx;
	spf=none (imf24.hostedemail.com: domain of BATV+07853672776bc0ba7c7e+8433+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+07853672776bc0ba7c7e+8433+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790327247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KCyV94oyn7UgoSfgjaYpx+E0zyZIPbxzlpyxYGj8GX8=;
	b=Ec68OoZsRlLTb4hA463+BRmIxXoOjXA/DbTDM8nywbt7uRp1Yf8Dodbu162U0101qa5Lnl
	Vnd0VEzfap9lDTdoC9qg/je5f045ACzHoNGUsEf8rShXEgRIeTjVYuY4Ogqk/tLXowQpgH
	IYWidDDZcEjYAjDknB+rmxLGM3KQBd8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Jm2UAcpx;
	spf=none (imf24.hostedemail.com: domain of BATV+07853672776bc0ba7c7e+8433+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+07853672776bc0ba7c7e+8433+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790327247;
	b=KukaOC+Rdd/E8mdaqRp2lo8sgTDvZ7AuIEWh+StqR5BokDUe3rbE6TZfRI3VY/9fzY0ZPN
	NE0mcJnqDxD167KvLsYgp4UUscIR6AzhAmdm4hnv5mmixHCdP89q7EwMFqeagjyJ2NXvN1
	aZ/Ut9BmgXG98+BG008B6UWw3zJYkN0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KCyV94oyn7UgoSfgjaYpx+E0zyZIPbxzlpyxYGj8GX8=; b=Jm2UAcpxToTAxr+Svp1O2pM4D2
	ctatdOQnUip7JuJmrAlj1RMH8E1zlPVFjc8sc3mciWWVQmMLyYIHqH6Dt3Ybcu1hVdMkiUxVlKcZm
	vsaiUPmIHUutP2/fkDKowSq04+IjHyu0g+bD0oub1gDqlD1X//vJV2jAxVBwKQ0T7SrSIgZmEuLMA
	TWrMDsdz+q2WtqoY4X5ZhkOHQ+YepDxsc64ieSY1Z6kAa6eKz8J5zGgZ7jQkjjGS9x0Q9gOKNdwBI
	gwaQUDi8N7wC3NC23QU+ZP6EXyWXQMEjCMzpNMlGq0CnJo/u8+RkdqU/1TVMrE2UJNuYHEwRG7tOh
	OmV4cLhA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA1ts-0000000CyOj-3qzm;
	Fri, 25 Sep 2026 09:07:24 +0000
Date: Fri, 25 Sep 2026 02:07:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: mpenttil@redhat.com
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v15 00/11] migrate on fault for device pages
Message-ID: <arY5zKsLuf7f_EYw@infradead.org>
References: <20260924065313.899730-1-mpenttil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924065313.899730-1-mpenttil@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8D3C7180002
X-Stat-Signature: quesuma1gha3iiu9cfjhpf8rwncf419g
X-HE-Tag: 1790327246-567331
X-HE-Meta: U2FsdGVkX19QuVPneR0Goxcg/5OwvMT/sqJgFU3GmeWilEA1S+DjaK/wDOKXg+GvWeR7W3GR+28QOuIfymzAYKHQBO4vVPzMLRAzqz1E6jiDVRLGwwdSx3WEkJqZCwz8WQrezU0CKJGQv1pHbR9xesSnmiew2UR9V0mMLcWVG3mlOl/6cDWxR7hnPMCh/qibd2Cj1Jbsy3vkMKJgvdjrXNNy1RwyzpRtEU44RTkhAOIwwed5sx+RZrp0xqQawcb2YXZi7MeP5WLusAO2H3fvqrm4wizLg4TtOJA8gBzlA5oYu0s0XGcujIMAT6BoKvo9F/YmL9br74iXYKTxdDIQHh1m+zvIb5QwagELvgpdQ68P8xRefMF5+URftQqIkBMU+U99I6Mnsj8Fd+hqs9GnWQOktLL5EF7FA7fLr+PQpU1M7l8Ms9VDs6nHeDgMruNJLdkp9AkYwKu25Vq0JVNY+/qUGL0gJ6zqZiMuBds53e/Dqd/OhxzOq+Ui4X3bCuNNuBuKiM9cHBMXMf4PZ9D0PaJ5qkr8tjyjwr8WGQKeep2h5xTLIyPI8dN/MwlyaRlQPeLBAMr3esZ3QV2t/ZUfKf+/GJ9oeYT6vzmiMT38rAuvC1qAa2MvRVibdo3ceT5l1gDZZm4CJ2YSqfPm7VloBM2kpMtzBLJet5i0snsoFFwecg0MKLu4NeB1uBNBSIVIEg51hKBusbK3uVzCzNcVwcAh1c1mqVSSqhEGotl8E11/MqIULPwxPHYjXeFmtFrFxx9/fVucLWWMcJ1EcewF+ex9SHG3nzxQH2cAMstUfwuFBV5LCAjhfD8HLi1DeGCxe2jV5B2LG7fOoM8UTB3ERXoh0Q0HJIFSnArmudUg54wEnl7IOKe9iMY1J6trL8xNXso8/YZZABQXUSdWlisbylMiGfIt0K7hCgUV1ycce/ackIPyRcu0ezc5yMDsBSbci65f4jeH9o/pfQweeGb
 etVodvJ1
 ILNUbMbwkm9MDZ2RUm052YD322rO86B1lVkeBDW3Dskw4O9l0jpcYOEdO/nOABPU+PxMZ2OdZL+iGpXPeNrvg2b23JCP+MONExDgJPU0dSEJyq7k9iRmYAxypkjnfEiMTnaGTC/dA0sQ8NmQBb1KOpU9PAA70Ucw1jO0IwawmHwtpjNT2OiKA/qFGZg9gvw2tweikw7IV4O5Hjk0qgKHYaHfXksFNaUd3lLWBVbk5fQTFKSF4eSbTkyZA06A6r1tHv/v4bs7iNWW0UcYp1wdJVx2zqmIOFcZblgD7X2JSDz3Qx4eCywJGiFHoaibPEbDY7WcP8odRsWiONlNPMdWOZZb4rrXFuYEIEMlJ86hop7ywssAXYg5NHSCQnEg7Vx8yepuC8hlRQqbfwwOGASsfQfh9szXUnM8ucY2Ptoja6F04KYRNeWfhCPgWDGO+Lg9W7VGAXMUzrHGnFGe3OkbiHj79RVAIqylrgFXh49SE3IM43qlL/EAi6rE1RwzXjI1v6RafcuTVVm+NlEhcHfxRMga1fHEm4OU+Ttb5nkNvuFgK58aoxJMzVF2xaAKVPHkJGudlHidRVSAoCVOMglDLjTZA4w3/km4lrFx+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 09:53:02AM +0300, mpenttil@redhat.com wrote:
> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
> which tells to prepare for migration also during fault handling.
> For the migrate_vma_setup() call paths, new flags, MIGRATE_VMA_FAULT,
> and MIGRATE_VMA_WRITE are added to tell to add fault handling to migrate.

Who is going to use this?  The series seems to lack an actual user for
it.


