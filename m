Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51426CD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 06:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D4A66B008A; Fri,  5 Jun 2026 02:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27B296B0088; Fri,  5 Jun 2026 02:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 169956B0005; Fri,  5 Jun 2026 02:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC5326B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 02:47:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8043BA0A17
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:47:26 +0000 (UTC)
X-FDA: 84844927692.30.BE660D0
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4BB6CC0004;
	Fri,  5 Jun 2026 06:47:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="V6UtR/P7";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of BATV+25760b9178a0880d3e7d+8321+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+25760b9178a0880d3e7d+8321+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780642044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=yEE50aBI+MoWaJo5u2lOyrGEey1GrtZszw/LnhrzsVtq45Ft78gqGx2GBfO4l5gNbt196H
	IH3BR7Z3Uwy47fke+3Vd0wRcJfV/AOFw/EUXPaXYCfots9V1x79JGVi0IM5TsYhLxdof7e
	KPRzejRSqxiJ+JbuOD0EHCPzXGPox+Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="V6UtR/P7";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of BATV+25760b9178a0880d3e7d+8321+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+25760b9178a0880d3e7d+8321+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780642044;
	b=tnbskIkmY607GcggaZED9UEPB9Nc4stnJ3G+ZF8rs77/qYV7dMbBkmlJo9Jp3P6Vz2Q8sB
	CkeRzUiVcoW+roR01TE1OZeCzPjuci/5n7awYafvbnyM6Bz2seAngQdfcpvoLv8hJidefG
	ssNvosNO17WwLwru/ojopV2u3XamERc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=V6UtR/P7ao5H6NXHVW67cQ+kQR
	lzogiyQNE4VPvZ3bTAeikfaMj4RD7ECJzXh1VHZ/d/zWZ6LzDymNBAMi3Qw0m5Cd8BbkyILMHBAn3
	UY8Gkr3YSvvtZGiPgbIbRhQrJAk2F+l2wwtNa75qw+HjWMnEKsmMVitmSPKmrlFL/j/t3v9zSIpb1
	8pefOfRSYGKIxzMQK2rZT0QzSk5tZfl4tEE2qDojYf2R/nOnlI0yQRciQeTA+1iCX2OPgBcXXkZWd
	tcuvSmdOYE0vBOySM1e3DyuGrhhhBd1Nc/dMbGkJr6ODF6YX+oYk1bb4+mIFP/ubpg2KQyDntNvEC
	b1rHCVig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wVOKr-00000000BMb-3bgU;
	Fri, 05 Jun 2026 06:47:17 +0000
Date: Thu, 4 Jun 2026 23:47:17 -0700
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
	linaro-mm-sig@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] libfs: set SB_I_NOEXEC and SB_I_NODEV by default
 in init_pseudo()
Message-ID: <aiJw9ZTjOQzwHn-t@infradead.org>
References: <20260604025315.245910-1-jhubbard@nvidia.com>
 <20260604025315.245910-2-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604025315.245910-2-jhubbard@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4BB6CC0004
X-Stat-Signature: f51nk483d153jed93id4tredus8iqcy9
X-Rspam-User: 
X-HE-Tag: 1780642043-573829
X-HE-Meta: U2FsdGVkX18G1y7pEjuAPkbjGrlhmZH1eRUcFBqF498MCL0RCaGurOkK49d4IO2CGBlYEKVTgGeTqKLoLCBMvaD645Fq2lbtGXDbwUGu3MR0FitGu24a1i+Sn9cl1i9cdtfGDybtcELpSS1ahtfg5gDQVxTcGyU2g0JLGwT8Db44IQBGvUAfgKAQJc3vWeCP1WQyjZzoxSFvM5PrewuSPGQfUpEbwPYtPmrLpVzykztUB2p5ZPA2AIKtNrkOKniGwmQ/syk2M9gGZWaldSwbRnN2iW7Yf8/bTw2bH4uocL6LAE2UQPRZ744XTutaMLS7MxS8uzdm8woS/QFVH4R3A+i+Xevj9hh0qS8i9k/8xpE2KOiPo7VDtmxBQsYhkgLw3Gn7dSiuoEx0IMHt8TVwtd2rqKrTNZWzNh3Q/SM+dKeZjsRDWnHpW0DRAGIMQnaeLhxcKmR6qMkuI4paPgY1p4c7yNE9/GSu7bgbpCtYQEmKsTmgfY2js/AzOBjLXhap/2CmWRUncUjsXs9n++S0bi95Ms/t8CXY8t7xru2miZ70RiwGlB7BkGhLNx8Dv9WXqvDdCa78MbOAcY0Ut3ykMWjyraDLvss4JrrH87gpWXyPQJvJ2yUjmCAH9l/4CMPQR90Dh5sVio3N3dBNcjdyWx33saN6jAnhyMvSH4nueZ9M4tABjDtG+D5rYEvCzYOxcho70MUFM0MSQAoqi5seLtKiVuJzypLwgJw2aklbL1e/DHch1UYHDup9yBQEeLzsPSaUTLwtkY8iciWf519SJsVOipSg1rmaGRO+BxdSgbFF5ug7kMRLP/lDLlCoqIIxV6ftg7V+Ul9/U0nAEThjoPQ/LB+jufqx+j9GDpjYYEn8BqIVjSfr9yAZD19tlYuqmBxU6RwfsRXac7uyCW5F+qcnSzSfFIyZNdjAoNAIgeS+L50QxESsy3zmh2vAtZYYrQJcRr2j3QTW7bQm0SG
 3WAJ+UKe
 pE62l+vFiuzx4g4GrPoVf8H9snVnlLZoxJTsZsPKGeqJc/fiPr4otmg+l9NJdm4Q5nzjbD6r/I2Ej+JnFNa4e19GdpCpG2iE5IMJDbQmvu0Wxhqvm6Ya/qGiDYeZaU+vTlyxrjKeasVIG/Hg0CYuVY7zjCYKeKRLOz4f/3bP3MLLWLXXiRx2kEK3yHX+k6DpZtJiJGKJlywq82BvFY9NkAGgDmtHP0JnxmIEG5UvUO65ZTFmVCrkexYcO0Z+7VM0Hx+2nVIfFTtKUEhxBuHXKNvdTHbLcjYw0MomQmnKQB/eF2cbTlzRCKFe2Dq0pdkfDe1ATX7wfe/GRHkzE6X6ifY1THz++ibDOkYEkvmsjLxDWKpOrPq2c1+8NkEUvnc17YA5oNEoxauVkTlQRwvN1IC9pAYYd1GR40bbiuuNJRQyFFyt48ao1Izfupg6PLufaGEvqTAV4GaIQjILoRJsbBQdOWpI5dWO9Ic+2fKMIqaGxcewc5NoD+7/gdbtcUeieJLhCV5fvO7hWglTfP1jVxansBKI+5LzEpJEaqu5dvum67gHpj2AYnaCSbzafl5051dCsNllppFrukgDHtuftNW3XXRFkl/lK6OTjvOuoHsULCVEvR9B4kU4O0Ssg3c4HNqk+0GVexeol6sSzlqO0Pz6XxfrsJnIjP9umXzG6OkzjiwUgo211d0o/wJvYKm1nQ1n0jBsN6/K25JC/BtFO6XwBO1ECMyubcY1T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


