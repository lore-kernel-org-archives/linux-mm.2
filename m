Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C20BC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11B376B008A; Fri, 11 Sep 2026 11:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CCDE6B008C; Fri, 11 Sep 2026 11:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDB1D6B0093; Fri, 11 Sep 2026 11:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B95F06B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:17:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 15CC8801DE
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:17:27 +0000 (UTC)
X-FDA: 85201835334.18.5578F9F
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id F2E794000E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:17:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=aUXiQ8m8;
	spf=pass (imf04.hostedemail.com: domain of mkoutny@suse.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789139845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2JzqsoiLxocAa5D2L3SPzdIZsS+OW1mUD+PJx4LQgiw=;
	b=rT7HAaNkYijKfjg8vPS6ootg5bs3ah6I7KDLCPbg76/4PRatV+RjBmS8nblOov1UcjOMWa
	i2/UZM98HwtysInl5WyCTAhUY5G/2vKy4yGgqEDtPfuIeAEdDVYhzD8tBH18GkTL2SguBC
	fmuDUsemPIY0nL6BxsKjl7WP+uNQx6M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789139845;
	b=RDrl5FEdg7prWnvGoPKly7yP0dD7NwpCowNrBmEcZQOWzP/1Ucy01EiCgMCDJRx4OSsSFV
	+pO2CblCvftnCe1evoMK4w76ZOnuufbScXiIo9GOklysy/XHDVCKY0Ots9dyFsuq2jp6WV
	K2miL9IRdyhlI2L8uDWAIG/7PmkDlS4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=aUXiQ8m8;
	spf=pass (imf04.hostedemail.com: domain of mkoutny@suse.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a18840e2abso1763764a12.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789139843; x=1789744643; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2JzqsoiLxocAa5D2L3SPzdIZsS+OW1mUD+PJx4LQgiw=;
        b=aUXiQ8m8tzyUKXQIUIZ0lVAEk/46tYmmH4yWvqzoHYbafpO87/dZcMTumnRGJVWf8Y
         jcbz5/7vPpjVUUqMDXspI0F1KNx5/ivWFSy3SJvtaw870htNjpGCSQKLW8RerLka+7Bq
         vel7y+olMcJU6qkT6ROFIBUNIOX0QdULu2mEX/5KYXtizzen+5xeuaXrcLvXguIdaxej
         nt0sjJKJRJW4LUHFrafdvg4pcgdAaaPiZ1QJoKcMibDuxA16SrwyK4zBol7/Tf8qURox
         pxWEbPFN39T7xkMmUdTI2gH72S4U3pLtsNT/5oBtHNgBrIj/zTYWro7e9RhkLuUHyYrU
         EfCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789139843; x=1789744643;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2JzqsoiLxocAa5D2L3SPzdIZsS+OW1mUD+PJx4LQgiw=;
        b=Lj8wKT8qBwU28RFNQGAUadOQW2bKEj9boZw7aE1/I2vuwHAKt5ts1MrNou7q26ULyG
         oKNWlv2AjaqAAkIbIOX2KyfDc84BBfvFx4i8cTJGDf6ZLxnPyw4uvzU4ypUH2WyzGz8+
         3HGpDobO3uA7aIBZLFeKMtXisqjIPPhIZA6UpuZufaPCTGmwrE3x3VUrRZMvCli60pKD
         OIQdlUWe+tEUzhYzbM68NKYgtIH/TsXXeN2R31JEkVnyRxgmF3mjnXBe2AoJ+4VZS3Wu
         LJ5GTbz7ZLIJTGRTKeRA+aZTQkSncn0C5l7RSaF6jxkoAlWx97AZ3Ddt/KCcA9esYAlv
         bTYw==
X-Forwarded-Encrypted: i=1; AKwUvBwkkjCiT9XRovWe7B7Lxbta9hOUnA3E1syeWy+aXgtlOtVhGqKAE2CDuqO3uCPyAATpbuaoNhw3tA==@kvack.org
X-Gm-Message-State: AFuF++l2KVDvcyAIPk4bPc423RC0b0pYCnVyJRlPCrt92wiv3wsOAoqa
	BBxmdKk27D0qwbjMDSLQ1R3GqRvFzQ7zruS7/CYb5aJcu+lJdmW+tz3Da3u8XFofHNc=
X-Gm-Gg: AYBFou1+ibV0kFSX7hkyxqa3OK2rukXWmn6eVnk8Bt3UaFC4omZuS61xd8KY7n327jY
	BIUuRmarCYVwPqNS0ZxiLxAupbhqmLoWpIz5Q1Y7PISGHdc4b7j9x+Oin6iIKwKvck97LDpqV+H
	UXAu+n1d4QE4rJJALyl8piLp5TwEhI2ygXmGDd0w8p/5TczYVTeMbUTFnaySomNrZN5WNFC7Q8n
	k7zDLOS8PdQQB2P7V8c48fgb813aPAJDHdEsT1CJIHzL382RQTuSu9x+TzSqQSJDOfze3ofVMhx
	1YUZRJGeVFMmVNO+J3A5EyREeGE4A+Qr7+RBEyTS42oOLalnkeFXwC9SINSSTSop3c+7nMnr6Y5
	Jw4DhpRzLK6HkQxzc6Mb8h3jsT/Qz00ITNE8z+KL+ZfdYrGqpWGjUiWVZhwE/NQUA107lkoyXco
	viZyrBkwb6ZiGHSUlGA/jH2h4dXDIOpK13NYzhUAGk6ro0CllFdsP1lfKMUFMKi3GnaGVSNaIJy
	Q==
X-Received: by 2002:a17:906:6a03:b0:c29:45ce:85ad with SMTP id a640c23a62f3a-c29667f24c6mr225571866b.1.1789139843199;
        Fri, 11 Sep 2026 08:17:23 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2966026e2esm93138666b.19.2026.09.11.08.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 08:17:22 -0700 (PDT)
Date: Fri, 11 Sep 2026 17:17:20 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: linuszeng@tencent.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Jingxiang Zeng <jingxiangzeng.cas@gmail.com>, Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 0/3] mm: page_counter: move hierarchical protection
 out of struct page_counter
Message-ID: <aqQZus_Cc3mRiuXn@localhost.localdomain>
References: <20260909-descriptive-name-v2-0-d7dd7c099049@tencent.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ozrropszbqjorccy"
Content-Disposition: inline
In-Reply-To: <20260909-descriptive-name-v2-0-d7dd7c099049@tencent.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: z3wxcbi36mi1h48n6h9miapbaa8dx86k
X-Rspamd-Queue-Id: F2E794000E
X-HE-Tag: 1789139844-241876
X-HE-Meta: U2FsdGVkX1+uBS3o6D08n6CthPhjx5abX4qdhUQ3roFiQGvJ1NmnMXzc7eAg/eKEeqeD84d9WBy2QDdy0kAlYdoBVA6LHDt9yKQFvu94tRqDb1KCRg5usUkH+W5pAw1VOaBVv4vyaxy4f8LFJuxWiTWQSLfdoGzRnL1SPgXkynjsGPPWn2jRUy/v0Ma6+ghMhM02oPsXuMGMQZtDRNPR1zL6JVq3R5xvmIJTK0SGfSC6oatOsnDT7Qsd2jcN/bn+yIu/ufHHKgkmMLRVclTomy3HjN+UEhx0ifDk5VlLzZ0rzvnreMQ9fh1ck9WHmcGKGC8hv86ZpOu7FagPPYdZjvqatzhAfv1qhEwg2zVwziwFBxJ55M5EVcIXEaj8VUe6FddMX8FLCFVwbNAv9N9lGIu7s7Wqht+pFTAKvvaTqCkGraDD9QAYrvDrAdw0DGxmNYYvXsvtvouJEQIeA0L/X7ZIENx2CAhSkWCxiKJtIO/+1ssnyWO2ukQacQo0t5vwc/8gQV7PAN3civDPjTa04DyoPZoxerG64lsSryloZuGc+EYpEdroganhsHivDTpg6ebLRjE9HaMFl6dDkc34wUsLwEiPSu6iIWmBZHhT3/roAAwYoefdkZkMW8cTTmw0WruBAvsW3T2L4G0wMQ3Z5668fOHJNlLxRu/KXKSk2dyMv56poZApP53jwIaiP2h85ebFI9MZQqhStK8anZDgwKZAP6tCV6mrSPsfu0eIQtnn/cugviJnXZ91lXBj4h5uX9KbGY6GcVdNIY1i9rsnpeEbjnS2IRkxfwtZXBjoFX+ogqGI0Sg7hRGEZhYlrRE5B6So6ZqXWwIhixDKx95Xeebrhc2/OrZ8ek8mqTBIl/oLK+KoG871z2mtMn99utPvIYL3SxfB1/6108BU9jEiS00BoZ2H0p95kVLPVvxMwYyhqk6KCxgdG4A/dht7xicwBdz+Zxv5nR9bj1bdRf2
 YAYYOtK9
 xAG4AtkKos5rw730tEBp+odUJd2mmhypbovkdUSoc3o6RPiPwt5zml9DUvuizD07Z4yQeUkIEr5IwY+S38TnsNyQ6n44Iix9cc2oV2xe9g8iNGYTkCnfeRjti+bWxYOmHF4AI+bTMcyNpRO6k6/YIQaUKRjryShnMsY45PqhVeu8ixC8f2PtlGSLwA9189G8RSa/eUdQphF+PhoyT5N1GugWer/clmIiDYm9Wo3Met5HOsLSwYzppLw9ht9ROJZ2st+eZWcL/PPjqccImRl2kLDHRib3m0+Pkjmo32G/UqWj2FcMeVCCTe7jDAKGlMtmoR6aKeJD9HdCpNAy/JNR2sCzUQr20D6fdpHIM0MO8JjhWCzlk2LIJbzpOgoIgbnEPfZwXxybgl2VXWVJjL17XyianXCuvikiyshWASiuf+NTKLRAibvyRYTkhiZ1QKn7tvn3VYqWiZPhxbNi2GdgPWjEgeI8bOyZyol8M/MHtMDg9Mts0xVl+c/4nXTi0Ema6lQqRf1xIiNrWahlAqjWPtD0e2B0f/W5gC1FbTTqpWSlV1vfsEz0+TFK6N9b0tnnFD6+aTPbV0AuQaoQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ozrropszbqjorccy
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH v2 0/3] mm: page_counter: move hierarchical protection
 out of struct page_counter
MIME-Version: 1.0

Hi.

On Wed, Sep 09, 2026 at 05:44:18PM +0800, linuszeng via B4 Relay <devnull+linuszeng.tencent.com@kernel.org> wrote:
> No functional change is intended: protection semantics and the cgroup
> v1/v2 behaviour are preserved.

It is not clear from the description what is the intention then :-)

Do you have any measurements that the reduced cache footprint
changes performance for setups without protection?
And what is the positive impact on protected scenarios where the
counters are in (possibly) different cacheline and one indirection
further?

Thanks,
Michal

--ozrropszbqjorccy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaqQbfBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjHdwEA9eabDSoks6Xn+ni3bc0I
AP32Ul+BBWTmz5HMyoTjovoA/2JJSh5lKBEsuu0fwEMrZGzX9XiTI5mG6CHzszPG
ztkH
=VS/g
-----END PGP SIGNATURE-----

--ozrropszbqjorccy--

