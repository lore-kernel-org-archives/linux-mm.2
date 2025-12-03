Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61E31D116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 08:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9F4F8D0002; Wed,  3 Dec 2025 03:43:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78708D0001; Wed,  3 Dec 2025 03:43:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8DBF8D0002; Wed,  3 Dec 2025 03:43:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9650D8D0001
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:43:07 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6BE1C0580
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:43:04 +0000 (UTC)
X-FDA: 84177519888.02.FB00BE5
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id BDAAF140014
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:43:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YcfrF1ta;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764751383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vaMrZfXHba2THBbgdK1Ts2PDSgoQN/m0e8n8zxby2CA=;
	b=jnpK7TOlJB/G/BIo4YfDvM8VOMsnKSVAujXlXd0+9awMKZH6VmbcQ/tQEtlsmfQYn4Iwvt
	dSIPqgSH5anV7TMMJ58l7q4NBVXOJLx10UF/lj5O9yMMfXqohvxo/nHCFL83N8UoFUhs5q
	qh/iWk8oPKMAf4LCv8X84SbdGOeBU1o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YcfrF1ta;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764751383; a=rsa-sha256;
	cv=none;
	b=N0WpcR/9+DwdBHBuD57daWr4rncd7V323TZMcpe6x23tXrjjR+Zfgjx0kDYNS6dodf0ho3
	udBbOW82lhqG1oeNNvU2PAvo89IyDW5nvcQ180URa861eLFHcxAFRa1Sy29Xxzv+Zcyx3y
	vMOsZvtZKXFF98pMrd1R2w2k+6JhV2I=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64312565c10so9938061a12.2
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 00:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764751381; x=1765356181; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vaMrZfXHba2THBbgdK1Ts2PDSgoQN/m0e8n8zxby2CA=;
        b=YcfrF1taChn2fPbF0w4auqbLah7FlgHD6ze8hgM5pZVsr5EZpjx66SNfUKkLfiINiY
         PyysPEVPVcJa3xNiFykC7NT1B487KeoOypC9iQztyRj2FZZw3sIbYJWTjNkEycrY/C7b
         YhkT+qb7hEr6r1jg3sCTNRW57M6Y9rP0iF50Po4H0vrs6xI7RjxDDqr0j5Mhqtvq197u
         KFnRsh+iEeESUY4l+sEHxOX9HGkw+DOfVyPzuQM4QWk6ctjr8m3OVdbhpKn5+QY9zfYz
         V61IQn2Av8vgvKsab6wTS36AijqI/GMa/1NRQrxzuk/xjWNAhZEarzNfvHbNA2uJsGSO
         8q6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764751381; x=1765356181;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vaMrZfXHba2THBbgdK1Ts2PDSgoQN/m0e8n8zxby2CA=;
        b=fdsmx41FNgiNpDKH0P4sfKhfHLwLjyr2HIjVzkxOHM5TS3VPIuAYEEHWUNLPVJ+M5i
         agf6hAZGF/QBvwyhGr78s1NqQ8IVyW6o77bYlJx6mimZLGO6e73aogiIA2BszBKonI67
         8XD3jxUgqnY9y/QkfpomQ2Nvkml0PcGjrjU1xHI9PTNl1rvX55CfTvGc0H7H+C4+vxCh
         TFOWeW30dM6dWx5r00nu4Pb7FrJm77zMupZO9+gZbKjYhlTu1ZFKs062cQ+8PAc3gPF7
         6Ut/fa90d89RaeKdZJUxzzkplnzJxLu0dT5tgjMOjBHRVGCuxEPoWq7aIx9OuiQB8Kqd
         S+Aw==
X-Forwarded-Encrypted: i=1; AJvYcCWhlAmCZrR+8mhzEMESt6mlDJtq3+MjntsojOj/cwnqjU4nWPlggvrUyNeeDzZaZYbNtAxvuObRBQ==@kvack.org
X-Gm-Message-State: AOJu0Yzj9zKr1/m1zrZzFS26V1Xg6ZBxmTKPv/qmEXBG2vIAmUFk8a3L
	mPwCarJbfSmTjTSxq66bjsZ63dAYdNSKhtD5MXOklA5S8IbvzgeleL8cxx+aM1BfAY8=
X-Gm-Gg: ASbGncs5hTXJPA7Rn8n9J6hxFruqtFkx+XCpoiZiCvbE4cMbPdHB10+Tdf8Yl0ZOGu4
	M/RHm/NIfctVY2SKBywNdcq/jYcXpEqL74TQbaYNULzFXPWHp84jBlLBzdFX0HXAmD8SxpDAZ9V
	vfBqQbTPvFfsBHzyrtk0IPL1pHuMuSKFu4rgohLWHYSRGOH1AQeZRNjAmurIu2aYSzZ48DS9Z8z
	le+tQyU1J8yDdkHwA5/mcT+sifkIt5ntdwv+OJ72xlIEaIvzYghryt35LhgO2mol4690WF6FMo0
	FrWfKkgOW2aZCE725zhqkXzhqZPJBAt0eoIC60/u3OUSJ8+/eIPHNLRra+s9Nb6ydW3CrjOoy6A
	i0KUXqQZ4bfPlU5RA8oHSV+IjdjmDhafNKDB9hkynzhUxE2+xC9z7g8Nxa0Rafdzi72Ibz7UGzp
	ojaLdBGuHqk812bRY7cv/hJs1G
X-Google-Smtp-Source: AGHT+IH+dftZi9M4w7GOU5TZKpaqX6jfLAYFXQrFmgXkYHpbvFapvbAcqhxOMo99WFjg1NtntfJDiA==
X-Received: by 2002:a17:907:d02:b0:b73:2d99:d8a3 with SMTP id a640c23a62f3a-b79dc4ecb4emr134909766b.26.1764751381046;
        Wed, 03 Dec 2025 00:43:01 -0800 (PST)
Received: from localhost (109-81-89-155.rct.o2.cz. [109.81.89.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f519e2f0sm1758679866b.21.2025.12.03.00.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 00:43:00 -0800 (PST)
Date: Wed, 3 Dec 2025 09:42:59 +0100
From: Michal Hocko <mhocko@suse.com>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>, vbabka@suse.cz,
	surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Oscar Salvador <OSalvador@suse.com>,
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction reads
 lock-free
Message-ID: <aS_4E2H5aJmSvWF7@tiehlicka>
References: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
 <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
 <aS_0bgCs2qE0y1bJ@tiehlicka>
 <aS_2Z6ROtrxLQcRN@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aS_2Z6ROtrxLQcRN@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Queue-Id: BDAAF140014
X-Rspamd-Server: rspam11
X-Stat-Signature: ktd33duh5j7t5ohaoo7nf13nk5xdeieq
X-HE-Tag: 1764751382-802010
X-HE-Meta: U2FsdGVkX1/3cOTGBWM73kDUw/+nDvMZv6HSGnFGDqFRL51iz8tkzjam29SDHNZ7V3HsRdyS7HA0m1BXWpL2bQHQJnIEwppv7LJM+xAXOa4rQdCA+7i2qPhSjwr808xtWyWK+CGBPouSOnXRyUqyrFimZ/r06DDb83TLLqKptPKiLbR30AkhAO85svX6NZ1v2xJ6aEEdyqfereFEL5VctRE41+Pfh7D+prUALCH0NbiQLXRys9KNxLhuEmE7Q0Bxpr10O+mDJ24+4OgO6wYzaphrnVZ6oe3+4jrrJTAJNzNv0EAOcCwgu+ncDMK2U6kkOa4QPxbYs9Un6i9qmX4DMD/LyjWdBA2viDcwORGYUqXI51yLyexJqBZi9ZsVeUy445ArDXgwt/KFpijo12hyzYXjL1pOmo0oy50zyH99i1oPPLxdIsCFTTe0XY4wMOe5opS6CPHCM/zZigc/VNMUsHyEe8UohL/c1Gts2iX7cOBdHVE3mXmfDzwwpdUqxKmZ8w/aY1jxhoPqZECYrhCB1Ai7UhtjefT3MGuZn09fXpOLGWAG32xLirmRR6DIkgRSOsKnFs8Id7o87qfa00JcjIHXjC4f3EhfZttqb0/LgF2PwS96oYp9+kDdsvcJ4e3MPxW2uwLYcyM9Kc1pPC8eh0Seg/fq2At+o3HJX5iUDl7xEnG2JCKcTI5u5/uWrMonWV2/JNHlvNDcQV9dBGdfURXLHKEGh4V7XRqdzWCRfhJzrNyODvlGdWYqVdfNEzn10nIxAVyQPTVFu8+pnx+o7qmtXkM//NoAGkrL5WuB5vweZ84N45I7RKvMOjX0xTmy8elIxk5VCUXoALdDCfF5RN0ztJm78/C30ZOicahEzU3wt+AqEgXE1dKj5toqc6vc2Ze+ISLEZZXeHjMYswCjuykCD1gz3zagBBUyc7x/I1ddXJwpoCU1qnJNEnBBnAgX6TZE7iNNDlU0r3HCSD1
 UPiDxgLF
 A37WP6e0v0IqquMiXJZdFbXcV+lpURgA82wfnYANzaDynWfd59cHXAi08JzR2SErcZuoYTjZzWY/js8fOwtbLQ7QZngk5cTw7F9CbgWrZykvNWZ+G/FXVPjhiN1MFw31eheOyWaU15LriMJsF9DNp85KemlTskN21rc69WodAr6SeDEyH8cWjzjQTv4eiN+VDVveCamZbeV7I1dnJwbIfr1ABWu/fZttChyo+PqpoP0jaSA6aVJCHdAWZmhzvJOQt2rb1yLIu9XIBLe1grPN3bA6sy8Em+lQH6UEZ18nKLgo4ReNwBivwXdQNB0/buyjfNAQ/OiGzyk7bNqxpZi7fOdc230kF5pNMfa8nJ2r7sDkyYMMU2O6aiEqBxI7IyYb6aUyaOZHP8OOjR6gNdMLcUM9rWvPrSXXiiEXh5WTxhV/4610=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 03-12-25 03:35:51, Gregory Price wrote:
> On Wed, Dec 03, 2025 at 09:27:26AM +0100, Michal Hocko wrote:
> > Let me add Oscar and David.
> > 
> > On Mon 01-12-25 09:41:12, Andrew Morton wrote:
> > > On Mon,  1 Dec 2025 11:30:09 +0530 Aboorva Devarajan <aboorvad@linux.ibm.com> wrote:
> > > 
> > > > When page isolation loops indefinitely during memory offline, reading
> > > > /proc/sys/vm/percpu_pagelist_high_fraction blocks on pcp_batch_high_lock,
> > > > causing hung task warnings.
> > > 
> > > That's pretty bad behavior.
> > > 
> > > I wonder if there are other problems which can be caused by this
> > > lengthy hold time.
> > 
> > pcp_batch_high_lock is not taken in any performance critical path. It is
> > true that memory offlining can take long when memory is not free but I
> > am not sure we can do much better. I guess we could check contention on
> > the lock and drop it to make cpu hotplug events and
> > sysctl_min_unmapped_ratio_sysctl_handler smoother. The question is
> > whether this is a practical problem hit in real life.
> > 
> 
> I just today hit a scenario where offlining was blocked on migration
> failures that took an exceedingly long time to offline (many minutes)
> even on a relatively small block (256MB).
> 
> Now that I'm looking at the double-do-while loop in memory_hotplug.c
> 
> zone_pcp_disable(zone);  /* (pcp_batch_high_lock) */
> ...
> do {
> 	do {
> ...
> 		cond_resched();
> 		ret = scan_movable_pages(pfn, end_pfn, &pfn);
> 		if (!ret) {
> 			/*
> 			 * TODO: fatal migration failures should bail
> 			 * out
> 			 */
> 			do_migrate_range(pfn, end_pfn);
> 		}
> 	} while (!ret);
> } while (ret);
> ...
> zone_pcp_enable(zone);  /* (pcp_batch_high_lock) */
> 
> 
> Maybe it's time to implement the bail out?

That would be great but can we tell transient from permanent migration
failures? Maybe long term pins could be treated as permanent failure.

> 
> ~Gregory

-- 
Michal Hocko
SUSE Labs

