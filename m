Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9145CEFD03
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 20:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE59D6B008A; Tue,  6 Jan 2026 14:59:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E933F6B0092; Tue,  6 Jan 2026 14:59:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D754A6B0093; Tue,  6 Jan 2026 14:59:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1E586B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:59:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 716AB13C016
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 19:59:59 +0000 (UTC)
X-FDA: 84302604918.27.447B4A1
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8773C14000F
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 19:59:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="n7k/+GKD";
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767729597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWpz+GfQini7oDjFufcaLNIyvW0LJEPJ4NqJCF4ChR4=;
	b=q/pfn4rzJG6sflTpdsUePoU2DUn3Nry9cwUUZmEnHA0r2OtUD6bW8yeC+BiChVOQ3zp5nw
	d2MovSFoWytfuz78e8B885JLvE4asYltE1rs3taExM2jfFdlOHL/aMkY0x3lCjsK7TavKI
	U7oDZsBLGPTEpQAfKI3i5k3GyNrIikY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="n7k/+GKD";
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767729597; a=rsa-sha256;
	cv=none;
	b=ht+p4/Wdd/MlBisA3wsRrtthKnsW5RYBo+WYebmMgtH0IdNdc32Aug90AyeoLZ38Q7VcTt
	Wg/fgM25Ubxdq93rNhuOsjWjAsp4DV/ocKHWTVRR9xm1BfGHEUrfIjLob/DZf8SdfEc4jM
	izEN3HKlYwYRg+2EZrCZIDn3D0lgIpM=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-88a34450f19so13115446d6.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 11:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767729596; x=1768334396; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BWpz+GfQini7oDjFufcaLNIyvW0LJEPJ4NqJCF4ChR4=;
        b=n7k/+GKDk8r5UGtlxQfE43/d3u/n/OYBchf9O1Ez+F+la7YKYpivLKUtTygwIVC2Yk
         0Mwq0CB8qin9trrqrU3Nlk7kiD+JuVUaI3k6/zhUrGsFdwU3rmAIPmlhRqIeTGc5vxqo
         Lpg0sg5KBcH00bhXSAXonVtMyj7FinqGuNL+JImdKd0FygrFridXZslB7eV3xxhvVMkP
         mQSXKMmhk/vkrI3c+j76DWYVdKK2Kwf4aRqhT5Or7hdT+7EUVJxthIUCoU7w64+9nWl9
         5LhZKuQcJwK0ZphYKaQZTQBCwGiL/pZhWnvIUa5ns4HJUtNUBQkARHkJ3KJzJ2HL1TZU
         UX4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767729596; x=1768334396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BWpz+GfQini7oDjFufcaLNIyvW0LJEPJ4NqJCF4ChR4=;
        b=PYj+gnG97TtdMdcokKgP5BrPkBqNORNUzK+57TYaZsEiVk4TeLp6G8a5x5P+snK1Gt
         VJxzyk9uiHqJ2OwpbK5nnAcbByAkWPT+IhlcI+tjawB9eYEeRJPTr9hN8hQlZwtmHi5m
         RGnKQrKccelk20P9l4A+MLkeYhZFEn1mgMNluVHF2hmMfUGjsPmEkgFq9j33UkKl8LgK
         XMtXPKq0amg9VD5JF8mK1T+ZqXcl3xsWsPueJb5R4i7Pm5V0gQTTiikr6td+fGS02fGY
         59WYHFw+sDVywJRxB+zeJ4UCQ831H2Xjc13Z1dKeUbSXz3+Slh37+Ggy5c1btPeUvvep
         +h1A==
X-Forwarded-Encrypted: i=1; AJvYcCVceIv+2sFrERmfc7xj0i4jU6/Z3MvNUEhGe4HsV/X+QUKFJMBuq611J2XDQjqX6Nfiq8u2T4TDiQ==@kvack.org
X-Gm-Message-State: AOJu0YwPcm8iIAJw7Txb/xNIO/bokXsyhoimy2qh9V5GU66NdG5p56yL
	spucIQjkGPuesIxxx9ek7HIybwYemAqRbX5sZleZwK+qPaN9DcvnuJbVgMSE4yzADro=
X-Gm-Gg: AY/fxX5phflwBHxy3rGlptTie1pwN/k+L1u59ll/TdIQB1ZGSY6Ss2LbPmVQUHWyuhd
	4E/gVIXmVEF3EYuGKLyeBmwfyjN7QxX7soKddfNTL0qOIV3KX+cLHwD+9idS5lUNVzaptPH/AGU
	KmGtZ1ehVRr/lsYNZeDMh7uYc60XVtOgTXtt9wFqiltS1ILaIuOX2EbVCAa9Vkt8JW9EOcoFGRn
	My5s7aUjAyXj5fpTmwIa+ixP0cs+ihzNmW3D3sJPZgt1rVgiGZCdgYv20Auu/63Fp6Obb5S1ccz
	Lxk5ZaiBQnPCwt7Ah64KFzy8eamzZkJWjYloWqpvLMEFPIbseY/zaITd6KcozsM/+prT5qcNUwf
	rtkWjUK27SYIfsTaoFtp5D0TomI8MjNaALeb7L4WSyjdDrZRlARDmGN+8H3YbmIQjAYbHaLDHGN
	1aBnchk01kmr42BfLp3MC1ITJ/EJ2lI9Xa3KTrbPyC1e3QMqB7ekS+L4uIAwAyPU8G4O1TGg==
X-Google-Smtp-Source: AGHT+IH0pDZX0kEZDbgkinL5VI9nQJeDZHAvbz2W5LdZr1hgU13QOB2KrppALh+k9k7U8WBwPbQhHw==
X-Received: by 2002:a05:6214:4992:b0:880:57dd:5f15 with SMTP id 6a1803df08f44-890842755e5mr1974186d6.54.1767729596630;
        Tue, 06 Jan 2026 11:59:56 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f4a63b9sm232749985a.3.2026.01.06.11.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 11:59:56 -0800 (PST)
Date: Tue, 6 Jan 2026 14:59:21 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: hare@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, osalvador@suse.de, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
Message-ID: <aV1pmeXP2pZ55g5i@gourry-fedora-PF4VCD3F>
References: <20260105203611.4079743-1-gourry@gourry.net>
 <7f053290-6b9a-4d18-936e-0f28006c79c3@kernel.org>
 <aV0_SMq_I_R7ikF3@gourry-fedora-PF4VCD3F>
 <9575e042-39f4-4f01-80db-34aaaa9312e6@kernel.org>
 <aV1PQd3tyfSiH4xD@gourry-fedora-PF4VCD3F>
 <616f97b7-24e0-4134-a08d-5abaf07a8b09@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <616f97b7-24e0-4134-a08d-5abaf07a8b09@kernel.org>
X-Stat-Signature: 8ri9bdadw15cyapj5te4xkrb1hfoy3d1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8773C14000F
X-HE-Tag: 1767729597-461779
X-HE-Meta: U2FsdGVkX18HR4cm2y2VcNDRgfHrwPQ3s+4JqDjOFVe5rsLbEiaGJRCk/Ly44EpqOLr8TQ5Zxy27SaCVE75BFPb+rAY6DMm9nUUDySv98vsPHJJWebO/P7p5UEcx67AEFyAgfbAJ1Qxkt2TxP9mMjrt2hZ/0WRZlBz/s5qdB4rZbB48Co1H6fDm1RSRecKlPTbGbaSoIYEzewP8rK5U170UeDhUNRoRYaE4tRz6Q1vV+VnSVXbV7Aav+qDleQbvIK7Kw1S1saus7GYWGfp/Z4cKxCXpKF8bidTelr81qVFuy+d0DAG08jL7fajNXmwW5djsgHAGqK6GQRG3h/5zbo2Hp7JC6uLjNkYuuOYJ98LXyYJhypH221+Ot/uJsSSTnlLa0kQwXB0hEuPld1JCe/5LpbRuf9VsCJp92XPvK9C7rfRR/0CaLQhSfpqUGIBQA0uYutRUapnG5JUHjw6CC9W+Z3ln+hHfq2Y49lXvuKObkbRLb6k1fJud6GQbDCS7QPqlKnWDsYAAcKmrgrX7JKLj+9+SXBlpTdp2NkQx4peoa7mZtVU09Qn0xaXJrACqTk+xpxeD5exCfcgR7RpQZtLLpVuoSs4lKSBfCF2nvl76t7Bn0uxyZ7SM1RJYAZVVyAmdlrwm4xWrHwQpjO7GwRVW6rRTIqXl2YceOX2xjF6a678HO7FNx1mZiKi9ewR5ArDWMeVMQLSxdIzKT4j/CxzcJ2zyCA5kYg258vG5HWhlLe2iJ6zDU8S6UY5pHhmThz/eivloY7QyLw4PHsT+ismL6ZjTEnMhOm1CChKS7DdttVD0FaPii0a0YQk+Lf/m0GlS7CII4x/58xBQWY3ErbyGWo+ajKd6+TKigUJ4l0SzCCWu/uavG8iqz8mBWaQtnhlJGw3tfNH9LZmF0+df8rh7YNEeQJt3PAbIN0LUJY1jYgegJejYk3ERgEU12Iov8r0Oy0xwl4q3Y9NK/fdH
 Trf2ohZ2
 MpuLgUcVZANfCRgFSPj38aQC6m80yGW9ug5zbUzynfK2kVcwbdwWP2Yxi+j9znsAzCSTHxbExLGbQt4UDRedYiJVfJ2N2o/fU9EYbYKquaC3SmcaZzTDBYIWaIxk5hf5txzj+vssoWCDLoGHwHyGNaEgKq6lh1bkPW8u83pomqXIHS3g57Q5BavLaku5/YlT1ylKkMEn4/9SqKaQl/0r+kh6KASMfOiooxQVNsuu+f8uZ4gHP+6l3dapy/s344dnCnIrr3ojAsuBPMXPgMozzvjUNCNWXYorUlIekQrGCWrncn21uMETtiMXzyiai6OzD4LbJT1bJqytyjOTL8yYIeXsFeoKOlbXPbqzHKutqvZ/0PpqfJzsK3aCBlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 07:38:54PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/6/26 19:06, Gregory Price wrote:
> > On Tue, Jan 06, 2026 at 06:52:11PM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 1/6/26 17:58, Gregory Price wrote:
> > 
> > Fair, I'll revist this once Hannes gets a chance to chime in.
> > 
> > This was effective at getting the discussion started though :P
> 
> Hehe, yes.
> 
> Another thing to look into would be to provide a way for ndctl to just
> add+online the memory in one shot, without having to go back to walking
> memory blocks to online them etc.
>

I think it's the opposite: offline+remove needing to be done in one step
while holding the hotplug lock.  Right now, I think you have to do
something like

daxctl offline-memory ...
daxctl destroy ...

You can't destroy and have it offline the memory for you in one go IIRC.

Maybe that's the ACTUAL fix here?

~Gregory

