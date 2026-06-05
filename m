Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3DDDCD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 06:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09586B0088; Fri,  5 Jun 2026 02:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9036B008C; Fri,  5 Jun 2026 02:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF3F6B0095; Fri,  5 Jun 2026 02:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 88B676B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 02:47:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 321ABC2523
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:47:38 +0000 (UTC)
X-FDA: 84844928196.30.2DAA379
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id A0E2940009;
	Fri,  5 Jun 2026 06:47:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=O1syVw0R;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf11.hostedemail.com: domain of BATV+25760b9178a0880d3e7d+8321+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+25760b9178a0880d3e7d+8321+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780642056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=mOo0csaqaPe0tp67qwK4KE2YKBL7Tj8k5cY+HcWWhnu+HIuMsTHWhvRSSCvHpyRXNvjbQq
	VOv36baemnhQZtlPmWabv6eq4pMOtid8zw3RnjkUhcYp1WtVxS2mdtwyM/ve9Fc/aNCmL5
	y2H5uRLpyaBzy4Bvm6URC4wtnZdzE98=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=O1syVw0R;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf11.hostedemail.com: domain of BATV+25760b9178a0880d3e7d+8321+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+25760b9178a0880d3e7d+8321+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780642056;
	b=c9q/MzpwhiIkFkaH/SGbKk+WGyzkgGE4bIWuM/i0YpwAiJfjYWuc3n6RKzicZQSw4dU2n9
	JH/0c8HiR5jdUthqI1aKKRLHC2JLMk7+Ts94LPfsKAsT6Bj4v+KjFnAm8oPUV1+3+SGrCE
	UKx+I3ONwGIykwfPqa1R5nnhUtxGVl4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=O1syVw0RObUNsUloXhEatKWUIe
	+8iwjfg6FEZjfbqmaleJjUITEnUf87i4rMzY0ykIJQN1Z5X5WxmLKq0/sQgK8UbWrD6KIA9+Jo/aM
	4NBngO9DpCzY8mbr+EQgzQQhdWAGPiz3/ryp2KRUSoYUy+Ngol++HwEOySoIcZ/LyRhs/aWSMbEYG
	wcXpqUl8Jqx/ZSLw96YZ/vY2f/5HwrvN/mFF6n49gnbmeQMlvJJ5Dudp2vS/Q6gS/5KX9o2+zIgwd
	sqKvUXSlr2SK6bDM4GEf/FZAJTimGblho2KAyWQi8w/b22h+FsbF+fbhkJTLkrRdx69Voe1JDxvOU
	ZEmD7VJA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wVOL6-00000000BOe-2pM2;
	Fri, 05 Jun 2026 06:47:32 +0000
Date: Thu, 4 Jun 2026 23:47:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, Kees Cook <kees@kernel.org>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Chia-Lin Kao <acelan.kao@canonical.com>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	linux-aio@kvack.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] libfs: drop redundant SB_I_NOEXEC/SB_I_NODEV in
 init_pseudo() callers
Message-ID: <aiJxBKwK1v2e1wQn@infradead.org>
References: <20260604025315.245910-1-jhubbard@nvidia.com>
 <20260604025315.245910-3-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604025315.245910-3-jhubbard@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 4p5fnommpuoh1daucwtgkoafbp1c7pud
X-Rspamd-Queue-Id: A0E2940009
X-HE-Tag: 1780642055-542838
X-HE-Meta: U2FsdGVkX19Ao8hUqAgwSHOih542ryqTA3nU6ovxUjDCBD1wKhLZLopDiTPgEODdg/4qGzTQkG4vdHTKYzh8vl8lUOnFjj4DvaG4Mzm4oHToOtXTnui35aIapsjZNlvunEpGcI9AXWtIg5eQ3otJ6EDATymkBdbodPnOlTeJEjqU8fUMfxs6GU5o2Md04S8xdq9t4d+tr93kp9ariD07F90MrN/qqajtwHjs2+mjHrzcYzc1pU+p6pJ5CQPoMYjBjHlAX0OyGhdqLDgNcYWSKLepMvFxVHMDXQ6uZwwvpTewSFnUrKXdqNtOtXhNXu0QmWKrKPfkTt79guXGQUimix3yKpFvTBM4PmsflKOFbUy0uIt3oTbR7JU0Q8OTH5HQ3g5Em89fcHPuKlNl9fg2fiUpP0Bz6YxVtgPEJwAAiMJAQ6qPWJFaHp4PNwGWnAAgKNUeP1F5Ai5B1wZD74GcN2isYYdNwQ0UZnhSzsONJzDvj5ciZj8ZDFUy9pBOqSe9AqOZ7j9xyaK5S0+ochLBWPQURGazyWy3kYUK3kd+HUXVQJJNBQI31ZmQulp4Z+KIWCHs7NFhqH5taKgOuu1+1cyd1p+6UhpZFNVieDf/tWzIYh6UKNhyfuAog01Ca+mrduCTQJFI3MaiDRIvPav6ciKlny2SEf/8rzuGvojF76jyf61cUi5yKGSFeUj3hug1/vjC5v3vLLEIcBhSqc0Ir9No7tn1YWlbUcwsPf8shZsD+iijjohfHvkm/jFOy7ci//a4SLzkbg63qmU3dtzfbKhb/UpaRXPOVPVUw7BpgNJGWJ2oEZ9a/ZwJFSu7AlH1OBLDBceHCpRAIzDy2T8TFvPtFUS0COrSEQ8SB4nQ2aKUBRLN9H3dXSSPrri9ZHDDOEg6nIY/5QJRirV17XdUNhmZGJIorGAqolUPfyajaqSVxv+6cjbXV7yKcG8tMFLKOfsNd7Z/Lttb5KkVNtc
 o6lHc/jp
 7lM5g5upUC7y9Qet7nKy8eu4sqrYqcjRptS45zi856SVoe3AsX2VqkeOU4g6PDdteuM/hZFigx6Q/hjl0a6hdOJZixBO9zKYiLHJhHjpu/sfL4tCEg5rfjy5vOU1na8AEymeh+lxVSl40THKJ3rFt23YECWBeJKEXjsh/no+1HXF69UZvYLd+AlDT7kvAoUJ1NZpg7bScjrItC00UJXf9BvuzBfglwidUNrJ7du1H/nwkFdhBNxEmM81xxj2OxzkUlYh0/K/lpZacy6S9cmvkPwU/RM975ZEPW5FFzZ6LWyWR+ntapQCFFTW4DekWjiJjSUCXOLnr/WPQDYY2oel42UZt9Luajp9Tg/aFxUk0nxwkVuAqs2tKioxXNjwvY3pnglx/EOHLYgC8EwTpOBV0ylTZqL3uWv27jUH2OOC96PiyxgyhVo8I5/2Osb0vbYxY7J1zkoumauFE5HHbWasXMQV1HTrtvOjX//W466GUgvcryrB4iqkuJqjx8X6079iNlupF2S+Jj003jvStOfVVXPIa+EPCJ/bY3QKy8GB++FdTXQyl8p/ijUPgDXxp5DBhBiOi8YcCPobeuwsXT0pVLUPbVPwgJ/WuFMdc/Hn1cqEdTlZjnoSk7wyCJNMMl8ZoecO3orPzDXn3o6v8uGSBEco7KSKxPLjOmaUWEEsx+MRGofu+BLjgElWsiMNE2+6bi88pxwGH3Bh+xvzKp4PXizPU05s6oJmm753y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


