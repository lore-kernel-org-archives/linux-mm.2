Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ABC1606D816
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 10:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DS/I9zUU
Received: by kanga.kvack.org (Postfix)
	id A6D796B05B1; Wed,  4 Nov 2026 05:04:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A20246B05B2; Wed,  4 Nov 2026 05:04:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90C7C6B05B9; Wed,  4 Nov 2026 05:04:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 759B46B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:04:54 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16BFDA0686
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:04:54 +0000 (UTC)
X-FDA: 85397002908.11.67DAC9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8DBD740009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:04:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DS/I9zUU";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793786692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2KjKjh/TdBjCqqnAgRGDOggqlOjddLap+BafnZlf3I=;
	b=TIulSMO04K81WDTNfJ8KCvvsGFhJg7XEAlP6QQ8Q0sVKtYNDu4js07Pq1ymc2a1FhW8xd9
	wfhRxbSANj7ibYtADSjUUHtunmRP1WHHyiJJClZfnxhcXFV29zCXQmbcs1yb959O22A1v9
	/j3OW/99KtxzAiAE+wOdPWvFPqQNF3w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DS/I9zUU";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793786692;
	b=6bxM+TfifHD7r6e8RbaJy0QHoLVdewjj+tQ58zePb0ZhkgoeMnTasWcsg9JvRQPXNtk1lq
	iIRoqTLrW+JQtuIiiDwNtOp8Rt+bYkxGl31u6X9ZgCxje3iVryWgHB2Oy/5F9Jy14BUxWD
	ASA9/b+tLdSDI0nizPXpiQVG5eNABGY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B10F60DB8;
	Wed,  4 Nov 2026 10:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667A51F00919;
	Wed,  4 Nov 2026 10:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793786691;
	bh=P2KjKjh/TdBjCqqnAgRGDOggqlOjddLap+BafnZlf3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DS/I9zUUp2SDaMLz5BdXJWOAv1ehgWBSJr0edZ5jQUlxXK2HpjCdf7Xsmcm2/RT5k
	 dWEqvZFpvtAqCe0Lung+MJlwqqDZAB3Ktu9y6ythH8uYKnxnPrGN+GwId5GSArZ4ov
	 NL7btkRHm0Yu3gMxms+PflHlvaADjmHj4gXN8FA4l4TgKdqvHG5BRIPJhsUjNWl30m
	 L4ylDs3JQBx5SVHs7aAgErcr+jFT6OycAuhkUcEoAqxS9PekxCgc7ImtRrKGB1CHw+
	 amCG9RgzbhFgPxF+f7RKqwOeIww/kyGG6Jn6lulbxwjbBHVwMLcOTHFWsmRG4QR4ZC
	 iKLzudqQtqj8w==
Date: Wed, 4 Nov 2026 11:04:46 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 06/12] mm: hugetlb_vmemmap: rename vmemmap_remap_pte()
 to vmemmap_optimize_pte()
Message-ID: <ausDPuMzAyA6EylN@localhost.localdomain>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
 <20261104023510.260766-7-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104023510.260766-7-songmuchun@bytedance.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8DBD740009
X-Stat-Signature: bbq47qjtw51bruzwnyd3qdwn6t56gndd
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793786692-23218
X-HE-Meta: U2FsdGVkX190Q034fxJ4D0De5IuVQNFUoZ2UsnUR+LgiK4lKFYu8LQuS2+tKR9kXWf//ho8wH8GzfNkDaoEtVXR3iTCRrth/7x3BqnctfeDM7Ij2+oeLuGNS7mTSWan7vtIxJ4f+3/GWuq83TMFEhxedj/Ouxcv1LkC9Azzp+yHVhHpHwc4hAnknwUf+hYawpw85yV1l0wT9w0YW0bA/QBu4yz1XGuu1QF57DraXySSSFmxQI0PtGkW+2k1zRfDBIWhX5AljIo/njx33LNFd4TZtiTSiKPI5OMzidptLWDxgsoz/j2Nf3hsueJ9C5X7Sxjy7s+GBMWN8bX+TjcghVfSUZXUh6PdTcLKpaiHylM+QOTJ1Zi62MNyEo9n+qvm/rGSPAyRUHA3X4xw8/NGkM90hF3rBY6CFra1EneWJmevgsW+vapkvi98svf9RgEgYIM4YPwa9ccVeFIU1r8+8Qfx13mTTE3h5Fle/ldmoXy6v3tr6JMciaj3Dn92ohYuzjag+zoOXnb8W/E1KSPx82B9h+LiQ+g7E93LVCvd2ozBoE6mSl0ka0HeYnSa8iDNWGRPhzPMEV8lQzk6xbasYbQqhSXatc9tyEuJWV82yoQlkGMXrj72nkEORU6gQkmhXRvp72W9Y8HtJudMzLRu+5zrCK1YG4lTL+ItwCoH+siKxrjTAiokkv/xSwlyHbnOgI78UaO9Ml4aA5yzTweh5JhbhdVxbF5HalE2vRVx77SI8/k0T03DFDGOsmvCuHhEgIG1bfY8A4S6R1PWMhm4Q+JUEbnoppFt4ArREiFMcAGjWOzb3iNcNgNHweqALTMVroO7JyyrEv8n4bbKcPm2cX33DEKFZ/eVaUo95yNA0pKMVJo+pzXLLzSe92W2XRaYVZxpgFLqV2Q4NCfYWu8+mqK9EfXvDfB1E4fnuI6n9b0o4VQU0q7gY3x9u4zhim+yzahrbOb5/UNSl6cxV+DJ
 zf7jDSb0
 hes3J/lY9plY+8CmAJlM1+Ppkhm5jkclpOmiV90t9cj+e0x+8Z5qg0TRg1mypqJPFXnrSFxvLQOvhLCICrddwqXgmZiDVGDxFCLKXhmXizYoah3dJMD12kV7Iig1ZqIs/UiQus/137rzABfuxhm+AV5QuM6vorcrqo8qLWmQgvm0l4vItrKqyTa00sgwPzpt4jsdg7GMOw61BSBAHXh2KSEw+4pH0tmMpz0P6ns9k/Qk6YvmJSSSwBLtmP5O62TJbtiUD2I0GQYJvYoY2Z+hBkeJB3Fab6+wa+PTsF4EPnx1FXw8awTj54/7dGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 10:35:04AM +0800, Muchun Song wrote:
> Both optimization and restoration update vmemmap PTEs by remapping them,
> so "remap" does not identify the callback's role.  Use "optimize" for the
> optimization callback to match "restore" and make the two directions
> explicit and consistent.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

