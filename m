Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E97DD0D145
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 17:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 843256B0093; Wed,  7 Jan 2026 12:17:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C19E6B0095; Wed,  7 Jan 2026 12:17:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4196B0096; Wed,  7 Jan 2026 12:17:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BB5B6B0093
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:17:36 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E06DC1CD1
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:17:36 +0000 (UTC)
X-FDA: 84305824512.19.91902CF
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id BCEE9100004
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:17:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SUZEDiTQ;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767806254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/fdL/etc/5J0Wt6U8Xe/ir/x7svKKT9Jhst6iTfdS8=;
	b=e1cBKT7bepEk50Vk3X2A2bazL77+AWTEUbu7sYRxFHaTCbEHTTNe26YVf1Wj6RQeWAYOUU
	+kfx9Z9SKW9OQ09+CGLbgEa3gnS7GXHCe+kvmnlpAAZXHBAHKpx+tFoY7Lt4s9g72elovV
	j0q4noN2kdCInfWg1mwDWElxmY1jh7s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767806254; a=rsa-sha256;
	cv=none;
	b=QmPwsKg3LDG0dCJrQDOCbPwp/QfO6MdNwMvZwHM5U+RDfbIsnElLj+phveF+/QlWm2RskI
	KmARCtJE6TMRxb1JmU212xq9LZCwzp6PtlW62NVTa1SNHF0uYHx0U4fJ8OevEelgwYW6Vn
	/Y91mlxhQV+LEYb+gmEqv9AnWWaQ8bE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SUZEDiTQ;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-477ba2c1ca2so24697135e9.2
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 09:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767806252; x=1768411052; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D/fdL/etc/5J0Wt6U8Xe/ir/x7svKKT9Jhst6iTfdS8=;
        b=SUZEDiTQorC1DfwpwfJRtewXXorOtHzVXZyGdlgyyAhFHCeDpJfBg4rRPfVgClOriS
         18GsNqoa39ZwxLqVh/78dWuNVeR1TRGBcltKP30qZR19PNrFX8EazQy2jJaUnpPtpa69
         /NisKO2IyyMh+KnIHOSbjXHaqeBSjHTkSln7LDTtqDPBekZiFCqvFxz/VHp4vz2MGjjh
         hNoq2N+XMM8YtoSwVB3KPxRzZQEbWirhpOMw+P+F05TNs4fsWZP/hC1eW7TC5jTTyh3m
         NKzKiNhQosUHvuHq5IOCiPJdAwSu8kTZHT1oFQJyU/wQkVKP8ZLt1ZSDVC7gS5/usCFr
         9qZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767806252; x=1768411052;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D/fdL/etc/5J0Wt6U8Xe/ir/x7svKKT9Jhst6iTfdS8=;
        b=sSFZwy9WJu0ZeV7yaCYXfO+diW8M9YY0IoVKYvN4sm84U2Obn/wV0LhEinqbm77psA
         fnGcKjCRSnA3xqwl448gFSZ32dyqfqPcHWAc0aMH7tEr78uGbsUIklbSzU/e6QNYS8y4
         wAJqaztFCW20NWe9HGtSScTu0Ii9dvqqS8moZzunaGr8QunN4DsffGCS+Fz+RUOPaEpq
         ufNoaphy6Ye0vfuY36EYNYnjuNf8G+EElTt02b8Nv3jQ5kQLv0YYZzUu5OWlQxEjRXtX
         cfCz/TT+0RL9SLr+igfmIGRayfiKCzgWjiGKo4BEsMONz6pPNYPyRu9kY52Q3ciWSdmU
         e2lQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+1KeGCdgrILLleTijMJ6GjzLCOUhoHHmPKtCSNGdN5OdsEjjPnObPi/RNyRVeCTXlZ3SBjGNyQw==@kvack.org
X-Gm-Message-State: AOJu0YwGWbQd1ctzDRyTnMmOzwrlIcMqsSgKrkowXSxkGPRbHRwvR2vX
	SeVzhOiHtUecKswTYDZgGQaOY031zdIjnJsZPhmWC74ClXDc84k38hWkDUtCmLpxSnM=
X-Gm-Gg: AY/fxX5dAkxLYoVUBIjWSjL872Atiy9ef8+sXXakgZod8ZQjcbgJWuS4u5nprc16z5Z
	Rp0CYfWtxGFJivGPCBbDnsjQMkNRCMZ+Xdjv0rnJon7znyCHjkgfIYHiw639LCHv2xzmnJaPXcT
	mYi0gLWjFARNPrM3At2WYOz4B/hXQebpYEsuwpMBzZ/IJAg338PC0Rjvv4WeuEUhJVHv89g3NDw
	Yi+mxnQp1oz03BZuHkDLTq5oHG59LdrwDOhY8J+BInc7b/hVCy0l5Z1WLc3+NTegRC2OGvDblFS
	mmPccUA7jKHruC84Q9rsLYC/FmIxri+rPDxx4X38Nn/fTL3AC3rYktM8YnTl2T9YdSQRmkFPGQm
	rUaEHnDhT6M/6TEzzYD/oI5Cm+N6HXg7XJWKTvopc2CEot0+wqtnx1Rfc54R5IvfTOyMp2cbpNK
	iBYYQTgYzlveF57Fsrjhf+C2HWtAvtmJM/gjE=
X-Google-Smtp-Source: AGHT+IGAM2YhqSXf2q/Y4D9ThH36pWbJsXQh96JsJ4kULL5c2nm4jv7EQU2Mtki1NW8Rnwb67HOalg==
X-Received: by 2002:a05:600c:820f:b0:477:aed0:f40a with SMTP id 5b1f17b1804b1-47d84b31525mr38749425e9.19.1767806252079;
        Wed, 07 Jan 2026 09:17:32 -0800 (PST)
Received: from localhost (109-81-93-164.rct.o2.cz. [109.81.93.164])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f661a03sm117662475e9.13.2026.01.07.09.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 09:17:31 -0800 (PST)
Date: Wed, 7 Jan 2026 18:17:30 +0100
From: Michal Hocko <mhocko@suse.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	david@redhat.com, osalvador@suse.de, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
Message-ID: <aV6VKo5gRphgFQc-@tiehlicka>
References: <20260105203611.4079743-1-gourry@gourry.net>
 <aV0kzBxg57Mlw8mx@tiehlicka>
 <aV0-ChclC7SCrxcg@gourry-fedora-PF4VCD3F>
 <aV1nPG1BgBQDWkjE@tiehlicka>
 <88dbe97c-3510-4ce7-ae85-067243a152bd@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88dbe97c-3510-4ce7-ae85-067243a152bd@suse.de>
X-Stat-Signature: kzk6c7w9picncyewxiiq8c88xk8dznof
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BCEE9100004
X-Rspam-User: 
X-HE-Tag: 1767806253-184901
X-HE-Meta: U2FsdGVkX1/4Jj+m3QQO5xfZc7isIUgQ6hqt/OnURtOLq5AJq4EvOiD02WPg1pliY9OVrZThJEH7wea2QpFTUhIZfpLWBf3Sw0UsT3qXBGXH7oErg4FliN2E+h+fYtClEJgNtDlEdCFcmQ9F5G+KNPi68qb8WgoI7DRqyNfXtnfe9QvdSk+CQ7T2gBSQpaC+HjZrG5tt5BiwiubPfFASf6TLBLAvY4ZlJjQ/uYFKsN/yAQIpfFBRsHR+0rbrz8Aq+/KeNjJOGOA0T66HWqFJpMceGq6rdQhdTBOPJSF9QJ5pqVruYqtznFY/Ppoz/LlMJSUIck8I1YFXP8haWcDxJcPNM5dISx50gqDqnOwc4C+VCU1+f0A/fLPRYgPN9NHRhzAcm8vwIsOdvgpEV8JWLpr8RTTsgTTUVUHkvlSDYrG8DmWDKgl1dZMJSYbiDapuBPXoY5aGlPbmdtANVFgf6YeeE24AiREcFFvJNMIx7Vsw/YVOEPfQsG+9BzxPsb30fe+zE9yCpKmJIYXwUxFBMcXB6mHHXWR5OpnuW/Ap2OMhlUNDj1GbRmCVnJPDgA6CIy+AWc9q5Db5JtYSpAbgREYwqG87jBhY0kXgDvcXmagltvACK/lnfWic34noio7Mdm0JnvtHxdjEe7ywPrsW4uH8LX3oaZSTfIZqCx3B2R6RqipeTucgJVwR1b4F+0WD9+Ucv2SBylor9IoQf312/JcUKNiRepq9AeZTsdQxIbDuCBMBEs15Y/zmauoLh+9Qn6aeiG+gkmHLAI3spSXdC8fGepS/+DKh6J6Y7QfzjjBFnn6eJhtLVbi4Gg47ATEY3obzTpUrtbX7jyBLd1QuHrjXHIOZbM33K1L+FlATOJ72rC1Ug+3U/k4RA/FJCi2OcvypjKUzRPc+ylwQLkVvYSlReZ+caqz0Tskh4Y6j+OmD3gfcziy2WGobo1DdfLE6E0MLeZ35R6cSBOkucAm
 2rOxcWkH
 xe0GA6ushIPoBMX/uBdbwyLg40FLWpdwqMm0xAZiRgUrH3NQXLf6hk0q4C87GfYSlqcf76YWrRglAGe59o7jHDdlCiUWMnSP0YEyeKDinOC1Lu5HZC3S3sogKV94RXUctlD99XfaxxV4rRLhVsXThdAVvWLitzkSm4mdXEQlo40/Q49EjzGxxEfJbZ6cG7mALRZ1xGkubyMs7qeHMNh2pU0rn5M2GQT2oH8wC+Eok+CHEJqGJun5Uh6DdPEGVrarbQq99irVdfHr0othp5iP/etG2/efxq3hvkAchvbVdtfzOMZTiHqdVRsj/e5h40JAuy6kKTf1uyGY7ee0bTCPHdcqZUjj7fPqsIGyhkCnFdvHRpH0+ng5asela4UpGw2YDVbYBpsZ+rq7PqkNZv/ezUxnRjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 07-01-26 13:47:41, Hannes Reinecke wrote:
> On 1/6/26 20:49, Michal Hocko wrote:
> > On Tue 06-01-26 11:53:30, Gregory Price wrote:
> > > On Tue, Jan 06, 2026 at 04:05:48PM +0100, Michal Hocko wrote:
> > > > On Mon 05-01-26 15:36:11, Gregory Price wrote:
> > > > > It was reported (LPC 2025) that userland services which monitor memory
> > > > > blocks can cause hot-unplug to fail permanently.
> > > > > 
> > > > > This can occur when drivers attempt to hot-remove memory in two phases
> > > > > (offline, remove), while a userland service detects the memory offline
> > > > > and re-onlines the memory into a zone which may prevent removal.
> > > > 
> > > > Are there more details about this?
> > > 
> > > The details are with Hannes, I was just recapping what was described in
> > > his devmem talk at LPC ("To online or not online").
> > 
> > I know of policies to online newly added memory blocks but I am not
> > aware of policies to re-online something that has been made offline.
> It's not a policy per-se, but rather a udev rule (which one could
> argue _is_ a policy, mind). There is a rather long-running SLES bug
> around this if you are interested...

I am aware of udev rules which automatically online memory that is hot
added. But I am not aware of any rules to re-online memory that has been
offlined. The former makes some sense while the latter makes very little
sense to me.

-- 
Michal Hocko
SUSE Labs

