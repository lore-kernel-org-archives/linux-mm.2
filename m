Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34A56C55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 20:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069FC6B007B; Mon,  3 Aug 2026 16:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B496B0088; Mon,  3 Aug 2026 16:47:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E739F6B008A; Mon,  3 Aug 2026 16:47:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C37056B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:47:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54E6CA228D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 20:47:10 +0000 (UTC)
X-FDA: 85061143020.13.00E5E38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id BF5F420008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 20:47:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRoPMII9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785790028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Rcib4bBbybHkbZgin1sCpS/iNUjgnAN+5dNXEdntbc=;
	b=5pQ+9drsf/BLGyVQVoMpD6cogQfQddUqyWRdl14mujBh2hgtvbMZrw6ITE6EVf2hGDtm/q
	E/5hOuuB6ZntOYa21gyWlQXm4FhFlrC9auBdPyyXu8CFN2o4BaKbBVi85yoBaqp5ENHYOE
	FJDpLu8Ex21HLzclCRyRIfuiz0oOECk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRoPMII9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785790028;
	b=wtQRrVRLrITD9e8BEHzrRIpZ/oOelm3kEMppjgoMRZJAlAorKnB1N7BSKSm9BQFwChNpwV
	kh3Cz91xmdvZ3S0oJGyrhunvvX8yxuMpfMqVA3QdXroc+gJ5FRT+ufV+a+Gee4Z+W2hv7/
	fU0u0NaHoUVEJdpe+dLiHv6nus+FGN4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B4DA40176;
	Mon,  3 Aug 2026 20:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52ECA1F00A3D;
	Mon,  3 Aug 2026 20:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785790027;
	bh=2Rcib4bBbybHkbZgin1sCpS/iNUjgnAN+5dNXEdntbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dRoPMII9sfhLJrF5yC09mSNyij0NFAhSTVh2J9hVA9/J9RBsJhbjGiBXbe9Nxaq7X
	 KlQ+9Bq9U+HawY/CVh6yKY9i0QRep97WN5k4J0K5Obmuddo42bJUKoBg2NcJIxRsex
	 lu+95RkUzDFa3sn9e47ZqzVkeR9rdr3pOQNyR7QKUS3Py5RO+lb8goNcmI/nUZohPo
	 HJ/59GgeHvCYpT9I9+ZhnTcisR/GSE1k2u1xKKw+e6co7PfTvIHJh4gqGsk0cOmdGr
	 w+bmik5FlKdBOcIerhwZj8gOFlVEDJkwmyZHuys2aoeWHhU5Fc7GkohJWV+op+fqLO
	 8gj5dVTKzLzgQ==
From: Sasha Levin <sashal@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Danielle Costantino <dcostantino@meta.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Hao Ge <hao.ge@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 6.18.y 0/2] mm/slab: fix unbounded recursion in free path with memalloc profiling
Date: Mon,  3 Aug 2026 16:46:56 -0400
Message-ID: <20260803203504.stable-0005@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260803-kmalloc-no-objext-for-6-18-y-v1-0-8b01d1021f0d@kernel.org>
References: <20260803-kmalloc-no-objext-for-6-18-y-v1-0-8b01d1021f0d@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BF5F420008
X-Stat-Signature: 7apzxp9qewza7883niwgz3jmcj6gjchw
X-Rspam-User: 
X-HE-Tag: 1785790028-126226
X-HE-Meta: U2FsdGVkX19PCW5GvlIotwBdcv6tststRfhhbtFUqHbuNNwVahqE94mx/jFAtNI+mFUKolrwTmtrUMZcu5AjtNXiVDmWRV4U9wWBogooBy1K5dgQeHOVf2XZX0SSXdbg3CYcv/qqmP4szNrGELxuLi0aLlu4FLZx1hJwHEF1qBcm3vYV20e2qG1CFW3KZ8+9VZyqb5fQf3/Ed8oRlFc+8u6by6dYIIivbupr7loSBSOtyUEohmNw+AkPpz++DSQzKfPaVi3+/RGl0b+HSwftGTRCOLfYenKhOn+8+LaBtJbdh7L8W7CkZUQHu0Maon6zS0lyCgycN8Vo1j/k+Qoc+Dxfw/16rs2G+OYUrB2PttxxXvKUelIacT/D5L94VskbhVIfbowtDLx/CJLh7fFUUz6iX1wh5isRnO/1f4W/fyQwI/kyo/DqtftyMywLNBNRzw7AcYZ+DxJ/5hhlZ4WwF03nRKWmbnK3Yb9hXdE92aWSEYUuNOzoeeyUgEA318WPAUu4RLw9RQERYaJ+/iIIdlY95e7XD4APMqFru//BDCcTp7tU8OT+HaF3jAnrnxMK+9awgzHoefSW7WHDUU5qN0QLJL/096k3rm2V8qHmhSkkDcMo1f/U2r0zuqG43qqFzvEhQVkmUHfDde3whi61oxhl1QqhZsSCskPufHki/N8bbTrME+QRU7uCcX4h/L6H6+iGsDFRto9DDVblCnRByTFxrw3ICZOu/cUJ6CHyESK03NVZ0RDVbaMWvvKNRD1o/lBnawiLF6pBrHL1rJyoxPCm95ektxbJGl7GS8A1XvIrztjUoSImMoU7PkIoEeFkofwsmSOjU1OXc2faVYYPCT4JWVR2dV9Ol/P7D30gbFIl/WDyhN5v0JF8ysrxR5yuQtCDDpkut4NAoChatZfekH/9kmEQrpLK4tqr4cqSvymctffwZ0IxFuXkOncYSNAMqq0/I233HrhASPpkUDZ
 CFennGjH
 /fybCWwuYfo47N3EKxw1yCUymO+t2CnF+G85HLkxoGNPLdhSJMpXCuTGi36D72KmY0dBz7V2djtBgDYhUwp7wpjPaF5wW286Ip5kg+8ZFOXpvT0S/sfBwiSQMUjy33OTHy9BccqILWFiIJbGpA2K4BOjTFPxtM2NaAsRG3t7BXRcsJv77EGQSxNQyysX1zouZ0HywQZhDf7XtvfRX9sg6aj7MwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 07:15:09AM +0000, Harry Yoo (Oracle) wrote:
> This is backport of "mm/slab: fix unbounded recursion in free path with
> memalloc profiling" series [1] for 6.18.y.
>
> The last patch has a slight functional difference compared to mainline
> due to lack of SLAB_ALLOC_* flags. I described those subtlties in the
> backporting notes in detail.

Queued the series for 6.18, thanks.

-- 
Thanks,
Sasha

