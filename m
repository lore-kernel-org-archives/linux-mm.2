Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF055C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3656B0092; Mon, 31 Aug 2026 11:18:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D94486B0095; Mon, 31 Aug 2026 11:18:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1126B009D; Mon, 31 Aug 2026 11:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA1FE6B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:18:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 33B12140189
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:18:10 +0000 (UTC)
X-FDA: 85161920340.07.A1E52CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 95E068000F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:18:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bcA1mr5n;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788189488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdVo315P9z/oxh3HjT+Vou7ndb8hUTA516RNFcrLCec=;
	b=rnedNFi729umFETshvIWWJ5Jgok15c8KEjr/lg8je60mVdTQOl+kX+/aO4dwpNjv2GTpBv
	Y0WlBePcgKJtjBC9QdXadRU+vxw7tEUWK6MjRtYNSu7Z9dis7aVJci4RGimsRm3/sPUYiY
	PGrG34F0wjpt6xVAOewy77vKwjXp/Ac=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788189488;
	b=i+ZOhj5mFvo+NFF+VU94cS0kOw+qCWpBMvtNRuAYCgIKpuGz9HIj6PG2pxcP/aPkrSRHNV
	0s+Syf40N5gvB1c6Ewwed9JPFjn1tzuTBWCB10iEkSmrPlgQCog0t8TGvpKVXrjB5iIu8H
	VXRDDKyiUWML7E/JlkepJJwLCL5C1+o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bcA1mr5n;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 320FD601FD;
	Mon, 31 Aug 2026 15:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088A41F000E9;
	Mon, 31 Aug 2026 15:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788189487;
	bh=SdVo315P9z/oxh3HjT+Vou7ndb8hUTA516RNFcrLCec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bcA1mr5nW2Q87Xa7wuADOB7GSNjQyjXs6fWsOI9FpOQ8xKjB6jmONilBgTdjjYdno
	 c1cjRXX6rfxiFDKPy822jshHW1kcuwlcrkAFx2dkjx38+OMtzXVXTVZ5PPFKJgfWqk
	 +eQAFhcegiGI8Ca0783wV5ymF7xqxScAnJ7WN3u1HfOpM53ohy3z283gd8WdHe0OES
	 CGP9BjyZHHWrjsI2R7+ya2Cs7K4kdGIQhEjtcC3oAI3xHR7ZHPInXcQas7c/fRphBW
	 JDr0d3+NBlwvSJz0VqqyBmD9fgXCOqusYvOGBshuRlgXLrAbN3I3MrzA2lgClN2ukg
	 NGYdOM/ydjCQQ==
Date: Mon, 31 Aug 2026 16:17:46 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Michal Hocko <mhocko@suse.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] MAINTAINERS: add memory related docs in core-mm/ to
 MM - MISC section
Message-ID: <apWbFQ6u0jqziUZU@lucifer>
References: <20260831-docs-memalloc-guide-v1-0-547718c274c1@kernel.org>
 <20260831-docs-memalloc-guide-v1-2-547718c274c1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831-docs-memalloc-guide-v1-2-547718c274c1@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 95E068000F
X-Stat-Signature: t4izr119xxhw7i3111rw3if56thodarz
X-HE-Tag: 1788189488-900201
X-HE-Meta: U2FsdGVkX1+ynh3ZiKmUIsbWtXk9m++c5Bxlte0CPOb+kAnCZPNB9ygKMLO9bvOyaz+G/kkG+b/G8wbEVpelr2ceXXRmkNJ1M8s6gQzficyTxuojpgRTLgfIHWflGyd1cH1Nfs3iqETjrHRNL+AuNX3+KqzBcFBS5nUEA7HiRO4YfBFy2p1KKDAYO0b1nzviw3BLa+jEkUwXqyq2NBxREz5BBcVwGfEnOiUNhF6sGZlN1VlTeveXaOPkZA50jOpVOFXBQ3udGnirxRpI0Un0Yys8VO+ePAB2QmkESwM/wy4YHjOWPFoRYP8T6uSiWxeUQeSj/XR5SgeiEK4Iw7GMspgq98t4nlaffLazyVHZakF62YvBZHDdLmgfzBFVF/uaUR/dRvqw+sWzBM4o/K0H3b8KuKtksxYYq3Yn2HIpqAp+6Uqlm+KmowvpClUh7oEjDC4lcKgay51mnDmrKyFvz6vn0GFqXM6gkszNMSrccLVxSASTBpecwujeSgWgu0AdOkwHIuF5VxuDIZIMp9j4VyIEbGeWO46zkS9PyknSxdIacuhIlfOJxqyVjLKV5LFPqS5PBgcYe2vceF+e4RJCFOnfra4BiDF6QBXKNh0hdMP6kfJbFVimiPtWgHf8y0l2ExvTy98bslcSqmHxkOP0UTQ5JOtSmla6VjFKwcGr5TR0oH9SfTYPE8/IXr0okIJp8MGgvNjf+AD/tpHeX4gslSoemmtsx0T/fCRGHUYkrnuMVOawJ3iRrfjGOUvhR6PvbEC1kKalE8dOwN8mHRHy5mb7IKyigaqDtNKNSgJAVZvRr5UkvqE0kJ9ASxWHvUTHLNyUWyzmAkMBGCzv8q5UN2FtJ8oOaQntddDRkV9nzeJmBJbs4r22O4FvhiZBWC90wcitiHUqdA/qH4x2CA3C7TK8szsxiBM9rkVsrdNLA7pOkawdGqnEFrhbGYsY6zywzXCmgjYZLzUNmP6E9J5
 7OBz8WUE
 Zx1vzpOviVRX7pJBRQktKLeTwzxTO6c/NZUDLPQyErzqYsPYCHQN4+G03UbUZNrHd+cLCvACuXFQcG80gN2QK75i0jUip6Zx6ETEMJIygocat2dDHUJD9Hq6ZGdTakBEdHdyHAOu57I7iqiE9gZuCRJA8ifBJ3XIEqYQSgB4z5yBw+qcXy2ESwiqQgYz5kAHSsdhZXqP34i95bfSCL+ckFTRiE6CGYhCc3NfLR+XzMeLLDVqpscdsBBxjZY0dOQ4Np5ScpOr+s2tNY7t+o3dMtkqjdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 06:13:02PM +0300, Mike Rapoport (Microsoft) wrote:
> Previous efforts to make sure that mm files are properly listed in
> MAINTAINERS missed
>
> Documentation/admin-guide/mm/
> Documentation/core-api/memory-allocation.rst
>
> Add them to "MEMORY MANAGEMENT - MISC"
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3a19da74d00c9..707f93320ad72 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17275,6 +17275,8 @@ F:	Documentation/ABI/testing/sysfs-kernel-mm-cma
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
>  F:	Documentation/admin-guide/mm/
> +F:	Documentation/core-api/memory-allocation.rst
> +F:	Documentation/core-api/mm-api.rst
>  F:	Documentation/mm/
>  F:	drivers/char/mem.c
>  F:	include/linux/cma.h
>
> --
> 2.53.0
>

--
Cheers, Lorenzo

