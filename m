Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB976C9833F
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 16:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BC4D6B008A; Tue,  6 Jan 2026 11:59:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369D26B0092; Tue,  6 Jan 2026 11:59:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B926B0093; Tue,  6 Jan 2026 11:59:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 166F06B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:59:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C09261B16C
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:59:25 +0000 (UTC)
X-FDA: 84302149890.12.E883420
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id E78D880010
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:59:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HKishqVm;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767718764; a=rsa-sha256;
	cv=none;
	b=d6Qr87VtzNepy+qK+qGVeOcBkLySmfL9fpIqByXRElinGfjQsM6VMjAuCJ38Q7979I38I8
	pvz9gc6pKxoT/v4cFYbC9JInnTFdC5IfcdT7Unsm720MdgPU2ua/kJgbkpVbtQDqWKZQpj
	aFCr8zVXfk6ebSP9AVXV/irkmXio4q4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HKishqVm;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767718764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O3BneFL65T+Jb3L2foMcJ0M1ozwC7vPPWeZ3rcayR0c=;
	b=uCrcI15IvOR3mQdtLN0Avewqh9Sepz9v7qstucTQMjqpCnbm+MJPt1V2K3omh6xsuTBudc
	5ecgBIMbYqvo76Q/1MjOapyrw1xghJrV8FrVgjQ25VEVgTPXvSsJ6p33Vd4vP5GY5FcL0K
	8Z/x3l99pLrCjhRE9jtd4mCiO1TzZbE=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8b25dd7ab33so85165085a.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 08:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767718763; x=1768323563; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O3BneFL65T+Jb3L2foMcJ0M1ozwC7vPPWeZ3rcayR0c=;
        b=HKishqVmx6AXxmjPsKVnTw3vR1zA6bruXUil/kahZHoeTdOOVhj8s8mQObiU/FeyAZ
         +8MDk8bIrerpV6I1kXttskjtekkYPAubpqU2DEjslvtPP/oS1LK7+0ufUwT3MkbJAp00
         x5glCxCAnukruiWfg8c5LeT14cLu5EBgjXcNC5Yh98aqJ1GmbVoU1nPYItHKKDKhAl7p
         Znpl2sHVUa1AUZuwz5U83qrzDKByrhQbvg730tNx8EqC6CRw1KyKjiAr/04/08yeong2
         plE+GfI6ZGMb4oWkuvFRrox3IBKK9oXkCiFlODiU6vyhK6uAcWvf4ISPdLUMGCCQ6PSV
         DP2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767718763; x=1768323563;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O3BneFL65T+Jb3L2foMcJ0M1ozwC7vPPWeZ3rcayR0c=;
        b=iBaGKH/wnj6fTVrg3+WTqoGbcHXQ1vMcznzhpRgayG9UIBv8MK+pkZe0Y4fu2KwPP6
         ZrcPmEYTB8+iUKJVZ8e2J3zRZeMgD9oxqXdizRZ3UdTIzaK9TRojNuEyuLQWUtcI43ID
         WSwcTH0QsaOWAA7G9A7XkRlVhJz4dVgymNaXFzAj/j+UZf3QU364AknD0Xe2UT4nc0x2
         3s7fpkH7rpWw4vKBM38SEeDNMiP6ZYaYCHNpnlFZW9x02axUEw13+AaGORQaQK+eJDJn
         G0l0cuL2HY/AJY32ddqyA3Um/kJIEylBxZHCmhZO/nME6sp3rLkOmZWg+0G3RAo+98jX
         e8Pg==
X-Gm-Message-State: AOJu0YzQwllaJgW8UyoV8SiKR82Vy9RBCQwDhzHT+lNNVxfeoa+nmvUJ
	9GZI/lO4PWDQjpwvTKnwF5tsVmo5oEfTWdg+0BvdlzZJRAC3LuM7soGHAvbzFKOUPOk=
X-Gm-Gg: AY/fxX520dQ5Pjn4hRwM+WCjDidrI0dFeBS6GlIGdd26c+IgvfiG59lwyxa7tcR2Jdy
	npZP98DczfwvL0Dyq8I0CuFaPKAMP+1d+YJg+FWVeqI7OlwGMQxFsQ9gJ21QbE7VK5yj3nw0mgB
	JhAgJtEbgVlfGIX3q1PNAu/Jfvybnbtz4vYHD28XMKvEEUTIY4PD+49RPSW9+IUib284/wx112L
	JDbmh92h6cwr2NMF+kDjJ+sg2kRSiUchCsCfGT8kqBmJF09G00WrB9as2dKR7jZ8W4Xfkt/Tu/N
	1yf3HH05XAx+P45J4xdXsmM3f4g6n/v15TD6sRI/111hTxoBLO0UikBqa8U67UiZNk61aWuLb4S
	L7TLeuiVzQ+6X2NnnkkFzTlyYNc1WHnLisCm2YZdH4lQPNiNq2s2SDBz360fBauCj5lB2yCUkx0
	KrGc21tSRD50Lr4JHiUOb6G++yxCydbFicgabygjUfEH4MB7Sql+oW+UNulzGk6GXIuAShrA==
X-Google-Smtp-Source: AGHT+IGKsdLqZ2LvyByKJrbieH6Nc7PzW+X+bQE1oCIF6GKo00ybcMZfJ90IlNxmLw5vXuW4tpCe0g==
X-Received: by 2002:a05:620a:2893:b0:8be:dd2c:a0fd with SMTP id af79cd13be357-8c37ebc18a4mr465735385a.44.1767718762826;
        Tue, 06 Jan 2026 08:59:22 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f4a7962sm195418485a.11.2026.01.06.08.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 08:59:22 -0800 (PST)
Date: Tue, 6 Jan 2026 11:58:48 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hare@suse.de
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
Message-ID: <aV0_SMq_I_R7ikF3@gourry-fedora-PF4VCD3F>
References: <20260105203611.4079743-1-gourry@gourry.net>
 <7f053290-6b9a-4d18-936e-0f28006c79c3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f053290-6b9a-4d18-936e-0f28006c79c3@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E78D880010
X-Stat-Signature: a9g7wwchus8wrmjrsi6y9oc1tq5ii1ye
X-Rspam-User: 
X-HE-Tag: 1767718763-480469
X-HE-Meta: U2FsdGVkX1+agzwI+q8u7zWxI9kvSKzP+2NcAJL7ceZZF1tpfChgXIQ04gLISk723BTDaOBI21FY8o3ytVwU4OuDxuhv/hkMGiZ423MmvAQXhWuguHmvN8jEtfOHwcywLCeoDQ5Y3NpTGkNVdWmKHFWcxU7OzraNG8QYzgt/S+u6NAfTudPLwlU8ZTk5PMcss8RTz5upEMcd2PvAsq9oNlm+IxuKeEGtXWnfEZtfWMpHa2AF3AuhAuY0mNP7FXe5tlqT1B93eKGl3GmClo9FNOWJVRVaHXUTMJVTDa4ggqqQEHLsCMeKlrTfCDTM7Zirj5A3ZYMdTH+LoTt9HZJWD8feX6h1vM9HIvTLC+CHxMOFXzbHp8rOh3SlHVWopeHZ2/IxfihQwyUBBMpe7Q4w6zZSCxYPk25DdWjFu1LZ/m6u6WXCsz9Pbj8rKYDBvCTi2iErZvhK/pTXEpQFNoFfmvbMGe1qtEnDG1k0j4Q9rNshhKASXsavrhBT0lEAqv2qhx5FWPLxiYN+AYNWRWuFN2KCSbae8RUH8SIqT1A6OmdBpXHQLvYSVRJL9ltIoEHf7QB2U/wVZMS/rRjar982eGJ3sV70BVb3ahK1qqicWF8aEa5tl3TYRQdbBfdUr10ZcNbCrEyeJrpbIbs2i6r2MpaQjXX6Gw8dGhxM/LTZU70MlEh6O8KBbJCqdShmAubUQELay8SblwGBMrrf3crsyMoFKWtYoyMhwQK6UvCdxKWCHdta5K9/teTo2+gq5nxqPg0QChYm4gVJ9a1ondkfkOw3ILa26AfWCm5IkLHk3u2edHepQztFOSYW1NYfbu5FH3oxvQ+H5ZxbgQzvudieK3vB9wJoSVyf0/yrOgV85E0bcXXBc8MuIqjE5zP557KskIT5OYwwA9EtEaSH5mDOdJEbQZPP0B3X0R/WWpV8W/67Tmg5ab6ZV7pVno5q9vC7l4o/Vvalp5R4KmrX2uV
 t2DajC1S
 tJt0L8ZoTOm3D15z7Gyp+cjPBkIJ+Cig+xJNbda/rORSB0yv4OLjYqA0nTBDAszO8r8Op4OcqO8ctWUBRJS9q8h1zJ6dq5QQLLn0f8yhHLECC4wIy+KFQTtAnoi5f9ZAun5kfCZXTZ0D/orTjgnEhn3u36FMKzogCCa8bBDoksyENMBrx6QT5AKJYM6KLu499G502AID3uV97dC979TEKq7t65baqghlEGUMQ9TcvaLVS2S+Q6rjpV5Ob14lFgPt7wL6c4+cJKZPD+EgAXm2YuL4LjBtMk+T/Qd4/7XIDrn+nVkfy2Y3Cgt8Za7d/3OYT91amvZx30bOfVslV8tSVBy8ZvSjDe+H2qoqvaOPeIGKfETcmsAGxxEa11qPXMYgkP7oO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 04:24:21PM +0100, David Hildenbrand (Red Hat) wrote:
> > +/*
> > + * Restrict hotplugged memory blocks to ZONE_MOVABLE only.
> > + *
> > + * During offlining of hotplugged memory which was originally onlined
> > + * as ZONE_MOVABLE, userland services may detect blocks going offline
> > + * and automatically re-online them into ZONE_NORMAL or lower.  When
> > + * this happens it may become permanently incapable of being removed.
> 
> If it's really only that, we could also look into simply making a re-online
> without a specific mode ("online") to use the previous mode.
> 
> We could glue that to the "contig-zones" policy only, to not affect
> "auto-movable".
> 
> That is, remember the zone to which it was previously onlined, and then
> simply re-online to that one.
> 

I know we do this in memory_hotplug.c to rollback to prior state.

I did notice in... i think it was either memory.c or hotplug.c... that
we end up setting mem->online_type=MMOP_OFFLINE after comping an online
operation.  That seemed confusing and maybe we can use that to store the
current state.

I'm not against this idea, but it also makes the sysfs a little more
confusing (`echo online` now does different things based on prior
state).  I preferred just failing if the block wasn't compatible with
the zone (maybe making it more clear with a dmesg print?)

Anyway, let me know what your preference is, happy to pivot however.

Hopefully Hannes can add additional feedback and guidance here.

~Gregory

