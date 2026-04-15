Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF65FFA0C32
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D0876B0092; Wed, 15 Apr 2026 02:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181736B0093; Wed, 15 Apr 2026 02:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BEFF6B0095; Wed, 15 Apr 2026 02:14:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F17986B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:14:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D58813A89F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:14:29 +0000 (UTC)
X-FDA: 84659775858.18.A4E78D2
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf28.hostedemail.com (Postfix) with ESMTP id B9ACBC000F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:14:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776233667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sVQK/DfywlnRSvprzIYKSXSIPHRnV1UoF2XR5AbgItc=;
	b=gWcPD4gT6vZxEKG5MqGezkVfI4WBtUMrrGLqd83ttWUPkx7As8btVtmK5WYSDU5rNW2tmh
	MqA5ipc9kQSZoT7n85rwFIzSmXbVTon2k21zvhGqkCzq5toCWcXr4XTeboEGl8cLQYNP1v
	uPNBpNlFtxxnguXEmFaEKTtU8NGyijI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776233667; a=rsa-sha256;
	cv=none;
	b=r41FEKDMgiu/TQmj6sFXy4fl9S/uPxcToXX3+9ebBI8Pt78PtYW9ktIDL/Iwm5eGyL1j/e
	2fS0J+vvuNyE14s6EYI/vXDr1xQpsg2FxbRaSndfd96hH81jkDlnYLtBIsrNFV+k07Mm6I
	9Wgm2vOOy+5iiibqEExuNHbEU6e0Xoo=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 67D4B68BFE; Wed, 15 Apr 2026 08:14:23 +0200 (CEST)
Date: Wed, 15 Apr 2026 08:14:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
	hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
	Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
	p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 1/5] mm: Refactor folio_clear_dirty_for_io()
Message-ID: <20260415061423.GA27588@lst.de>
References: <cover.1775658795.git.ojaswin@linux.ibm.com> <a35d5d65953cd9bdead0843d09c4cfc9d1fd65aa.1775658795.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a35d5d65953cd9bdead0843d09c4cfc9d1fd65aa.1775658795.git.ojaswin@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B9ACBC000F
X-Stat-Signature: ojukgehpwnkqpnh7c5wny6gxzajjagk5
X-Rspam-User: 
X-HE-Tag: 1776233667-859936
X-HE-Meta: U2FsdGVkX180cQybkxNR/rPxcedJQX+r6kOXWMEhxuR6RJIZdVrfMpBJQ1Be4cf7iuka5NPX+iNp9+4m+IEA8HuwPQY9yYI8fz5CSZkL+cmZuQ5ua9UYhk1byw7VyCmWcRfNppGIy8BiRR9ZX7L/43pA4iuIW1hvlNbNG0Z/yL/qMmWhErEupaE/A1jYVLV9gtvI0zMQanFwYpz/8Y/9SoLSYX4a09rhhiI77sP0Yt/MZXuk7zcPsn7B/ibdzvJJcTgVd+j1mgaI320bsKbSHXMd/qzU4RCEVZA/05Pk/moyUMYs9kS8GbP0Ea3IDfSWq60Vy8+HX0f3h2bIqLEzzgDYKM80pVrXV+IJ1ULoHSvpQQSKRkdC4qA6LCUiMrHxkPaNqFmWs7+e/WNv6lxq53ZJvOJOjWBsHdZ8GitDr+3X8m4Etlk//KmCjoeifC4t3ZKmgjINmlObw6VV1LCQ0rsaaOfIUsxkh+B8xeFgUmGlRBID+oLPY6gq3iBKkP5l3yB5Y+rslZhjFkQBNkIF0DC1tyJP8yT7VU3RaXeSwZ7slBUdgvl+qH8yUxO+TSkxvVMOU+YeOcM0daSu4Yvd4CtHoNDsDP5SPxs54V+0Gkpr/2x9QBaU66BMFPsXV99kTZM5swGlbjO4opVxVBEmV+8XgwWzP44XlkYfNULV83/fEfn4XOcIQEw9qE6U5zYK8FJJdm4wtGyfOwNjUJlXj6T3g3vScG5HOEUujvt6rRdXDhEm/hXD6bo/M0YnlC29weEcXLsglp6Ck76NLzLDOydmrxBJVV8H/75mXM8bok4Qeo3Ywk3QMdLU2s819g1naDiyx2/cmm5CEa0EpONpFUjsR+MLNhN9h4ViM2sITh5SWAsiEJl0jVPBC0ycfDdZ47mdYYAiOOIY0JsB8uJXuYsjhPNV9BJkhnXlf630EsdjJrNuM6cxS5rqvJUZfWiIVcMN3ZYEefrhM4oR8tQ
 Muw3XYGy
 DHjal4giwR7uTrUKbfk50zuGl3Zv+DoMsdkG7HWoWKd+ZBlbj3tfqcDS9FHcP30L4S+gIkbZOl0vgjiJ1xgCjuV6CAgVLkYcMNKXtv7+d2sR8QvxBL7MCtAYHLBjW/3Ckw4OZVJM52wzofvSr/Oz0+FILSWXOPVBWO9ZcicF2xDBoZuyYlvh23TcJqmPNQrvH7ifooasJ1KtooMPOyNnbwoZtFZhJjuEvArLBqUufwZOiJwViA25q0f67UGqPuL//kE+1EFdWVMfct+A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 12:15:42AM +0530, Ojaswin Mujoo wrote:
> @@ -2847,8 +2847,11 @@ EXPORT_SYMBOL(__folio_cancel_dirty);
>   *
>   * This incoherency between the folio's dirty flag and xarray tag is
>   * unfortunate, but it only exists while the folio is locked.
> + *
> + * For some cases we might not want to do mkclean, eg, if we've already taken
> + * care of it, hence pass the should_mkclean flag to indicate if its needed.
>   */

The kerneldoc should move down to the exported version. 


