Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49710C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 14:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150A26B009D; Tue, 22 Sep 2026 10:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 102136B009E; Tue, 22 Sep 2026 10:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F325D6B009F; Tue, 22 Sep 2026 10:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB4C86B009D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:00:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 548E3C04D9
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:00:21 +0000 (UTC)
X-FDA: 85241557842.23.D3CF00B
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf03.hostedemail.com (Postfix) with ESMTP id F3D6220010
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:00:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=p7cxJGCD;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.205 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790085619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yVPAItgeW/MMs80EWUUxpddBeukv+Oab4KQ44WwQXwc=;
	b=5iyW+mSdddGX6HKnQYkhJWG8ekFoW6tv13ZFoR68BWtDdWXHglIAExkYiT0zetzNUznnSq
	k/snWQT7w6BdYQsqHeT4x9M1tkt/44+HsjonwshR9ZsP/v+zxMzJ4J04SMYfp0NHfF5L/T
	UAuI71DvJ9oGhF+cKOc8+CcEJUL6hcU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790085619;
	b=3uk8kQ2TG/jWisHiERjEG/D4fT6Wp/2epVmhC13MCLRhnnQIAhhbF0mezKaJ7D7MsExnp6
	7PpmhBU18Rzg66LUjNBIBck0MWAF2eIWTqPTHWh5NlzugZfaBe49vIDfp+H2fOVu1Kv8KT
	XNllCKgosSAJN2JIvPwHt9wDSte7Z1Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=p7cxJGCD;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.205 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93910cc46c4so401758885a.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790085618; x=1790690418; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yVPAItgeW/MMs80EWUUxpddBeukv+Oab4KQ44WwQXwc=;
        b=p7cxJGCDBbwh9CFtzF4X+KDFaPiWjCs5QOQ2wBdqE0oVxNiUuDDh2HtuTbIk0mqSTN
         wYyJFl3DEbgNIItQ1AcYLFI7OFN9wHNS6IL2em1RY55c0EATLabrVF7/RmuIVIwWKju4
         h+YVKrAHpGJpIaUCT8Uci1j+5L7x5LRjt3zEhBR6DAPAe369puKnxxpGWBNoJKufdE99
         /c2fq6RF/cWJwtK8RRGY5brupA2xDwXjTq2NpBizUq9YJA6gQYvqA+wYFR6xUh5fd1Bu
         7cg0vamPAbPdMFl3eXjhh+cT96QDByFlU7VHpTUa0ofswJGcRX2tq+8ATZZI1oPKM4Lf
         kdWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790085618; x=1790690418;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yVPAItgeW/MMs80EWUUxpddBeukv+Oab4KQ44WwQXwc=;
        b=qp+hRe3vNqQXdI1BeWUjeHRQ4zPGutIPA8Wzdk8qTkG4nSPF18QdJ/9c9aPe5IxZz7
         oyzyrOtIlD2/ZAUghXaQyEwwLOKuRFbMQTlV/OGHXkKiroLGqn21UesueBv21NcKbwGQ
         m0hl9+yIdx3fb5DEMgqMrekSeG3huHaC3+LRMGNHUls5qoUlIJeBtXx9sUcouSSqQarh
         yJGG61tIfoGgswr4qP7bkQi7ab0PfmqK85v9BzFVl6nt4UIROwfDRwB7jQrHTWnRbMIa
         oHcHTnjT+EVdlWQ1t77B9vta9omN2OQdsr0+je8VOECD+un84C6zOZS3Cy1pi/SOTH0+
         Q+uQ==
X-Forwarded-Encrypted: i=1; AKwUvBylDKFTO1SFL+o7KvrAQ+Z6TVeqMXRGciYpefJS4BK5UzWWixwB8HNHbjIpMF5EyRnb9uOaE6izug==@kvack.org
X-Gm-Message-State: AFuF++l7EVBZIJkPXE0MOuaiO6pos8HVUBTlubDYlnyyxuB7qLjswGZF
	hu3ga0R6SSBJvnzpCPLv1YGRdjXT3HFaj0q84Ez+pTEiRAdTl305BQ+uhL9lrq0qv60=
X-Gm-Gg: AYBFou0HIlXYUXHbSTedHO7V75DoqXXKP208hmRZtRyx20nmRZ90pCkUGBZj9GebJCE
	ZtFBS8L5HSdADV7jq2XGnHIy16rdugll0wKSDl/5am9G6+aHXBvhAjkqUaZhsEg+yrILMrZfueh
	ImuU8ipsuhLEX2ryxybUqPOL4R4OAVWH7jm8FOw9rueTVTf2Gg4Zc9bogA89yzBaazAZ8GBdiqT
	h3OBbbeL6FEyxWCTmFg7RUukLi2LnF1vfFB3DYPobEvkH9v3Vino4elutbOKQtFbOfIsKawxEjs
	zqIytinIuKjk2wkMTP6vOOa6dpNSQzC3yQcY4y6YkNlDrW+ZEqUhWvcjCZtBXyyASUZX4T6FAzp
	JxnmqKFhO/qoZb8pm8lAn0UHtXlh30zC69bNFByMGODdGxxqSFgXzUGum2KAvLVc4+Hm3qq+z8Z
	7rHYfz06l8qifdWrL2DFA8TYgDFI8A3SsRKFsXg8G0JHTxfiQ7aI0wQQD0Z12EQDKwj9bo
X-Received: by 2002:a05:620a:298a:b0:93b:d7a0:d9f0 with SMTP id af79cd13be357-93c19a9ab32mr348786585a.74.1790085617903;
        Tue, 22 Sep 2026 07:00:17 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c1d23e22esm152156485a.40.2026.09.22.07.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 07:00:17 -0700 (PDT)
Date: Tue, 22 Sep 2026 10:00:16 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Matt Fleming <matt@readmodwrite.com>,
	Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
	dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH 2/2] mm: page_alloc: remove ALLOC_NON_BLOCK from
 ALLOC_RESERVES
Message-ID: <arKJ8BXOXknpmiu4@cmpxchg.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it>
 <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
 <arFBJdYaRx_iJNDA@cmpxchg.org>
 <arFBr22V60BMmVpl@cmpxchg.org>
 <72674485-6ec2-4cb4-a854-b937333cbf97@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72674485-6ec2-4cb4-a854-b937333cbf97@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F3D6220010
X-Stat-Signature: ujranztqktatxm3okyjhkwghitfu6diu
X-Rspam-User: 
X-HE-Tag: 1790085618-371347
X-HE-Meta: U2FsdGVkX183J1CGscK+nbnM1m2akw5x86ZYCI247+Ec7lasf2OuaWEU9UbqEJ2+aDDrSEIIePy2XAPNyr0ZRPz48EUUnwk2YRX6UW/Ro27h8IZEWaSDQ7ZiEQfJa48gwA0JLsnNJt7zmoJncLsU2gegYZKXU3tBVtRO5lL2yo/DygyORTZoxnY82+0KU7/9/cfzNFGoDIg8GrhEGn1Hc4XbnuQm6xJXe/1iDW7uySXNi7nD5Prsy1sk22tGPxleHgXxddPKfMBnTFVJdEqfraaKKPayTd5lvrYKSh+3rhRmpVhQ0oYDDmrwt4WYETpzgIIACAjQbgYYSZ0vaZTwhz0BNOOi+fIgX3pY+GnlFFwWIsM8p8cnqaJl6yrdFEl31NbWf/fJAnp3IEB5Km25rf5KSObCQjoKJmKAwTRP+iy39RfOKLBAmfWT8OoyEibxhPfB3D8a3BVc1mgEtgvkyp0sPNfvtjuue/sawoI+MPECPTaFjtcFhVitsdbf8rOBAHuAkDFk1FMvIG0yoIJohTKifasjPasto6/Ljb4Qu9laE+hKTSBsOj2hPXH/jVLcBp8Wq4kQ4++uBWsSkJkPCDEoMLnZmAB5IUGFUGPfkelBUW6HmYVwnE1xliGhp75SBK/hiIab5JADEOxk119BYl72gwDznN7gJv4TSYTa4MOGZ2vZ4I3vbOPsP3lRDEuovd3oRERXdUgtZmZXr3LmLrJLQg8eH7e5GVlWnIqrpEpbxZdho9SUHHG6iIcJafg7dL9kE89eHFk7iaqYQ4cnOJbwpG6J5Rcy/9nSXVyld8aZRhVIpNIkJdf5pMQOSghnpYj9hrWOIbPvk/2YvB7S97ww208yY12picZlF6EmgH9OqF8Z4ecIC6iEUOWdzyXw0/Ugwaq+H3XyevUJCoZMwVdtMCMBp/SZhT7uAlqIakYL9JSn2ICZYwCFDnwDtwT6UVy3ANaO4wL03HkIsd1
 AE36A1By
 9wAbroEqYixnJhpWLhuHvofXWovB98/idAI9zposH7/Z+vgBlRDRe+U0riTBcsEtzJ+FRSZg8D/ek9r7I/G9n4tu6H6EyOjrV1tOOz7ltxxHo1rjOwTRC81l4Ax4oCj7VLIczkzst/N5ueI0q7ZGEFIBZUld1zfSjT+q2s7+mPeuz2PWE6jYfP9+YD0VpWv02moVP647c2E0Fz3k0kRpABX4rfB4cXumaVFPwmJkclYDeKSheshbNYdnhN8CuJmpRDyTx1eIeDxg+2pimNne/ol+OoEnN4AByTI6KkW9HvjOI65XuLe/MpepATMHgip4EIbxT8rjskxNBls6/RuE0YRdHSuzamX/khIt4CmyxCgopc2FjljDFysdrrzpaV546h3g0JbRddG2n/iqCnEK0ewB4O0ep1PTQrZhppj7igAvzrU2+K4ORjadP43wkPMZB3Au/sjs2tEAtFkTELpfYoTHkAp/qONpIEVN6ifSwrmGvcpSqJuawzD8q6saRY1x/V2ccXR5bR99W4X61pSEs467k9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 02:06:34PM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/21/26 4:39 PM, Johannes Weiner wrote:
> > 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
> > non-blocking allocations accesses reserves") stopped handing out
> > reserve access for ALLOC_NON_BLOCK on its own: the extra 25% below the
> > min watermark is now only granted on top of ALLOC_MIN_RESERVE. But the
> > flag was left in ALLOC_RESERVES, which produces something odd:
> > 
> > With the ALLOC_RESERVES match, __zone_watermark_unusable_free() doesn't
> > subtract the free highatomic pages for them. So in the slowpath, they
> > get to consume regular blocks below the min watermark by the number of
> > free highatomic pages. The highatomic reserve is capped at 1% of the
> > zone, which on any decently sized machine is a multiple of the min
> > watermark: GFP_NOWAIT can drain regular memory to zero.
> > 
> > The user-visible result is brutal hiccups during bursts of GFP_NOWAIT
> > allocations under memory pressure. On a 32G box with an anonymous
> > working set, swap, and a filled 290M highatomic reserve, a GFP_NOWAIT
> > burst drove regular free memory in the 28G Normal zone (min=60M) to
> > 28M, 0.8M and 0.6M in three runs. Swapout failed to allocate its swap
> > table, reclaim scanned 13M pages to reclaim 200k, page faults stalled
> > for tens to hundreds of milliseconds. The machine survives it, but not
> > by design: direct reclaimers eventually fail and start unreserving
> > highatomic blocks, until the allocation succeeds or the reserve is
> > gone and the OOM killer runs. That reserve exists for high-order
> > atomic allocations; here it is destroyed to bail out a GFP_NOWAIT
> > consumer that was never entitled to the memory.
> 
> This suggests to me that a LLM review of 1/2 spotted this issue and also
> (or you) constructed a test doing the GFP_NOWAIT bursts to confirm the
> impact, but it has not been observed in production? But if it was, can
> we make it clear?

Yes, and yes. The test is manufactured, I just pushed it to stick to a
realistic sequence of events. But it wasn't observed in the wild.

> The change itself is fine and we don't need ALLOC_NON_BLOCK in
> ALLOC_RESERVES. But I wonder if we should also make the
> __zone_watermark_unusable_free() check more precise, by using
> may_access_highatomic_reserves() there instead of ALLOC_RESERVES?
> Which would mean that the function should however also evaluate
> ALLOC_HIGHATOMIC, and restrict the other checks to order=0, to be usable
> from both callers.

I responded to this in 1/2 because it had more context.

