Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED4D606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=JyUTxH9Z
Received: by kanga.kvack.org (Postfix)
	id 9CA8D6B05B1; Mon,  2 Nov 2026 14:54:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2316B05B3; Mon,  2 Nov 2026 14:54:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7EF6B05B4; Mon,  2 Nov 2026 14:54:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 610516B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:54:24 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ECC43A792F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:54:23 +0000 (UTC)
X-FDA: 85391230806.16.AA6D7BB
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id D8FCD180003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:54:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=JyUTxH9Z;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793649262;
	b=iEQcoFEjp+vsbgLeqqGDkWq/CRLUkUtRiRJSiRbfoWPZ81fPsHCd5WFgrCJhNirSsCkZ73
	hAmBKLvnEeKD358NwM6wGPnDjtTPEDBP/VCjQ9A7VX/5t1KBRojjwnYN71WJqJVwnNDdku
	cqm8hm96O869TFHL/KBE+bSMl6WVZSs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793649262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PXm/uwD24jlxN0Wbjq3NylUh7A4E/RjzDePOTrROpJo=;
	b=kxZpLeJPSqvjUgJN1c29as7Ov/UzRVXcEli6qBpORG9HP65AuCVd8lOm6syZaAop+5sixx
	s3XqUQ78bieKdB6dNdqv5MdGMqe6mR03bBEKTBXocD0Yn00liQYe3zYwEOndq2Awt/PEAF
	rCkDUvQmzi3QEasm/06Ag2AQb9P1RQk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=JyUTxH9Z;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8b0f59a5fdeso28036407b3.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 11:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793649261; x=1794254061; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PXm/uwD24jlxN0Wbjq3NylUh7A4E/RjzDePOTrROpJo=;
        b=JyUTxH9ZCcknM+53+8LeyZ2KIHWvxm6WzeTCCY0sgIHVdOgCup5bJUFC0+TOSs/MHW
         YNJs/vLpNEeVr/AkI1WE/XEO6x22X0kf2HuRfb3FUvq4aoorSGzjcokdUkJAugnvfQ85
         9b6Pe9As3cf3ORCxpCJIaw3n8mr0p5JhGQEeRhll0QS3CIGQOIPCQ0Agp8M/bS8JARkN
         yq3oMy5Mx/UNrjn/m2EZtPT5xhCmaU4kz4npP6qgT8QGwLUIJfqbENrMjCHyNpQKy/Dw
         0VvIcx6oT4Uo1mbOD0maVWSyiEMGHa/kr/U4BWdYX2u1HgANeW8bJxtsj6ahgJruyNiu
         0xTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793649261; x=1794254061;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PXm/uwD24jlxN0Wbjq3NylUh7A4E/RjzDePOTrROpJo=;
        b=v0gnZclJfmUEpC+WAQu/tokzZqAnkKeqkRS41vxl8VOtuvYj+KAE8RLsdQt2h/pNRB
         WeIEUtYz270inpcm6sXBh8E5VVEkd9FUTy+ncIJSkBnhkaiK2MDb06BWsFdoHjBj6uhn
         ZErA9MabWqrbolAEQ1eQ3ymCZm1G8bZvO5aSR5lhnWdOW43zMbqpqIHVf2wR8lGf4fXG
         v2lQj2YHeHzYt0YLo0q/gK5MC7iqhof1rr5pw6FpQnRyGNVhAndMM+ENQfirY5sXK0yP
         kCJQO0VbpJI02x4el/HiqaT/r0ttosqbnkFTw8fwFa6j00I0rAsWdQ5RG2hdADIRurFx
         vIgw==
X-Forwarded-Encrypted: i=1; AKwUvBxQ5UJ+LcXO0kbAk0D/1Os4UC59hmckHhgpFN5DA2vTrV/wYKPhehn3xAtiPh4f5lcAfBc75/Qnyg==@kvack.org
X-Gm-Message-State: APuU4Z+aAS7hOUEnjTXBJV/cIPhlmw9RrYhoeBKOMpEeUwl4XBzzfKSA
	/5zYnCWq5Nz+ezYLg7cV6v8URDTDQxCrF77HShRZWzdP0Txzv6jR4od4R3LOwqpEs/g=
X-Gm-Gg: AYBFou0j87BrlltgpjwCcGJ8JfJpjoOACXOliVLoxZQc3gZ7iIgwAk6B92g9WoMqN3H
	1lwG6ZBLM2j6KIAgWKRYOE8sj3QSdiHR/My2Traw76+KdA6iTOHxbn6nuuth6jlukoHhyzuMmch
	5YDcW3eO4WixRAuS+/hwqXTkMGlE7Q8rEx9Csbu0hSRGOwR/n4W4ZlqWa5IR8P/G92Q1RCcOk0X
	QGtErb5YzuSmXxIzS+W56lql0iLipGMDUeYOp/rWfedYwuhgrMYCG28H9FW54f1nmzvTz2QLG5K
	rzqO65QerR+Ac//ArLcn+XuuApDxday4nj0Ro/y6ZM9i0WQrET4mijG/rfC/ATP6970ELsruMAE
	e8fUXKCXKSirWUlLFKX5YqtQqlIU+GILi6+rBadns6YcRsXrMrYKkYWYGLydBoGd9QbKtiISBqg
	LC5JhfS8mLNGhvCAYqWzZ27PqlyKtZ+8YYJRcLT4+ojZ229OXnEpAkDkGkRa/0VFDyW7qmhFJ2/
	SvdPXWe8MiBEhTOrfYF1qQTTqCM3i6R0klrprF2EMN5kNkh2AmO3KYl1UodUubcVlEeQZQMK55Y
	ItObrrVPAXCzSSSzohVoNga1Qko=
X-Received: by 2002:a05:690c:348a:b0:88f:df4:1c8e with SMTP id 00721157ae682-8b2b66c5d61mr71635247b3.22.1793649260825;
        Mon, 02 Nov 2026 11:54:20 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b7125371sm58207037b3.11.2026.11.02.11.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 11:54:20 -0800 (PST)
Date: Mon, 2 Nov 2026 14:54:19 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] MAINTAINERS: add Johannes as the page allocator
 co-maintainer
Message-ID: <aujqa-dA7Xa5SsIa@cmpxchg.org>
References: <20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org>
 <20261101-maint-page_alloc-update-v1-1-27e8c246b13d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261101-maint-page_alloc-update-v1-1-27e8c246b13d@kernel.org>
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: n5ikf1rzj5a77e64raehr4xwx5w7xun4
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D8FCD180003
X-HE-Tag: 1793649261-49198
X-HE-Meta: U2FsdGVkX192pnhxgKR4lkDMKb1Zav0vRVX1pilRiKXIPMFrlXY+LC+XEeUi+UfZ2cB4vYfYavqb7/dXLOHF3rndOB1M0dCvp4j06WygzpIQoH/KBPPQ1AZalG2jydc5dL1T9BXVwxRX3J9HlOSGvNG7j9gXH8b/yXxHe/FQZKJngMJjNmSYTBQKeNQ/qkNixdkB5qZ5iB3zE8BesPvbOXV2oW/J5quP4f5SkEkZ6Fw3E+ykaMO3gLVRDulqKgpKsx/3Pgn7Qm3ORUu6b/8V1C/gHIz4CvV5jNNuSUJtOl4Wtbfkl7PBfXdDxkGunGfOuSzG3/xmJYEEVASs1hDIp0BMTCVpTBKxv/ejJm1/v+0dOYPWj7RmJnoLK2gg5Wthb2Vo3/mOiho4rIEuSMevY/JU3tvNmcUAm+nD8SiVxJmWD3akyKv3fBngeIdhrvPQgwzmh8G3Z60w9JuTmBvaEMJeEwnAPjlIEqfq6Sybs/zB5T2HGVGJvI+/LvleoiihLizXChXzfGcEQHis8fCIFm7Qxxdjix9V/dLbeBVlzsuSDYVaxPHa2TuHMaR/6xeonyMtD6ey32Z05O84X1MXHHpdos1+rT3frxbhsXvpXQAUbxgXXsthM46Mz5d1eQuyAom1pkUPc9nuXq+jlSvwuOAMaGOE0NPsJN7gHPGGaIY28WclF55RyPj5LUUPu+qJBVdFTk5INcqTivAmTKDrkiG8QfdHS3CM/aM6N0RRz/FCCZsMA2V0c/49Gsrv1n39xO3gpG6ANLPktUnZyySc/+6OV2Axr2NXQmgARsdW/J/0nK+3fOi1xWr+SGbCitPszMpU5/l+DuTzbTMyRzs22XqM90sOqVknmXWudS7VIij1ShO6E/tCA7A9eqha2gKTBray2091ICKPArwhc/CIaFv76QBAm/TXrocYeci3xJkQjD+oDZT6NXz7hnOmlAfImcSanY4R+Hr8ZxEwQ1z
 TiVTID/k
 SGk3h2g05TqUlNTexQN+4hcWlbTpTfoV0gPlLHV2u5nJOKO1/rUeQSbVnyEeKqOsXUqMP37tf0S3jiS5yoEbrH8hhMr1K/xN7EGsHxa6pTDHCNCW0PcnShpkHNOcc5ssFGYNRf3NfWjejgiw97696IwTDsZ0aBr/xXtkBm9DjkjwO/qx5IXqy9ROSvYPOYZldlLK0MGjNyhCIPUCJ0PUMAw5PlxBEq4ik780nXsajll20cb4clJf1Oa80WdBFyCpFNVes1UptqllIoODF99mRZqeTqu2mt0NxsnSWkzhw7C+4Y3WtVxcRCy5qWNYEaSjuK2nrPqUKXK4TE2/RzXQiBZsAZRlyL5jwoCXEd2OSYF4yo0ex44Rh3RtqyDQchGqujmgooSq6zJRudRbZl+6gM5ifA7ljdQ1QeJyAFo8o2AeHgSnmN0usbUIEGeq8YlKFdWc9ga+VipCu+O+ClcmdTdhZ+JXXAOGNi1MJJ0SIop7xH/XySzIqjSyhMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 01, 2026 at 05:34:48PM +0100, Vlastimil Babka (SUSE) wrote:
> Johannes is a long-time expert and reviewer for the page allocator and
> has agreed to step up to a co-maintainer role, so do that. Thanks!
> 
> Additionally, page allocator is joining the MM transition, following the
> MM core updates from David [1].
> 
> Patches will be collected in the mm/page_alloc git tree and integrated
> via the mm/linux integration tree. To signify the change from Andrew's
> mm tree, remove Andrew as M: - get_maintainers will continue CCing him
> on most patches via the catch-all MM entry. David prefers not being
> added for mail volume reasons.
> 
> [1] https://lore.kernel.org/all/20261030-maintainers-v1-7-97278f8a5f54@kernel.org/
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks for your trust :)

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

