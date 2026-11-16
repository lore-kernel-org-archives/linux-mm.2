Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D938606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 16:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Oend7uNW
Received: by kanga.kvack.org (Postfix)
	id 2316C6B00EF; Mon, 16 Nov 2026 11:13:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E26D6B05B0; Mon, 16 Nov 2026 11:13:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1266B05B8; Mon, 16 Nov 2026 11:13:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC2026B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:13:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B61F16017A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:13:45 +0000 (UTC)
X-FDA: 85441478010.28.897EA14
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6F6FD180015
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:13:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Oend7uNW;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794845623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZxHOUEDwJr8Ec59nGL6gXnjQrpofiX9HS0TRBVLwZm8=;
	b=ayHRtUY1MJHzXrAeqSifK76d9XfmTQP4i79p5vk7+TcroNFFu5NeefH5SNOSN3YxDxfR0p
	7+4j/1z028r+KSZgXSVWjdKcZEo6Wbw1HPKM2yJTJkt541VGJ6M1kkqKX1qW+sldHlcVQy
	9+fS61iftpm+S4kOIaWVDmWfcpWKvdI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794845623;
	b=TsVm6s0XIQzwBAoHlxPjLtNeSv62uK5Sgkp7r0tK+8oblfdiPwhIKe9ueoirG7lOPY92PJ
	i9yuz4h5d0EiW+sbs63ATPca1vJxXcZ3WNlpH5seNrBIR4IFFOYoxne59f/fe/ToF09P6J
	SJjHq9rSd6TZGsVGLXTv2C2d8OSHYI8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Oend7uNW;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5365d26ccbdso20706801cf.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794845622; x=1795450422; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZxHOUEDwJr8Ec59nGL6gXnjQrpofiX9HS0TRBVLwZm8=;
        b=Oend7uNWBUhhmv3K3ahVW5iNEr6qjySm1jrfGIWpbKMqSPCm47u7SwcWLsbxN1SlVk
         eZj8qw8UDck0tqKQXqS3OU4BgNDLwiOqMskhXHZHKakj9HLID1qvcb9ooGsH0/3VC62T
         mmpaCZ/HLrNz2KIAxWkHtdFrUvOdgNPkBGnIjkZydUIcxg9YZX/2NtP0tKckBy0V0XZV
         vN7PzJhqdpVd4ud+jiV+4ATZcGTxSR07P+31hWvZ+qF4TrHI8Uucj9natpLuXF7EjjoU
         hM3wUrivV9ytpA8x69l7LnrfsHA/ZY9bRyWCmoz4IHAo83tpBGcskUsK4c89DGMZd0eJ
         gskg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794845622; x=1795450422;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZxHOUEDwJr8Ec59nGL6gXnjQrpofiX9HS0TRBVLwZm8=;
        b=nptlrhBvuLV1FCehJFFTMeUXemvfO9dg5pP7UAPBZx05NduhNHTo/E4DxUEMl+uL6u
         G0HjaZ+ZX3/nXFjklPH/OtZP+a7LoxfDK3rCD7wCxnaZ2wktjbkuu28CtrOGKdJZEkzY
         B5sMxy6s8wHFh3tFjx1cDgpw5QoH/Fz6KFjgmS6fwipiqT288DcI9RWp9TSJ86hCwJKg
         Zen16XOFtm+nsYZiuqdZbPTpMM4BXgHf7vkvIc3x9BU7XDOhrxDac3ZnKzmtM1GeZaHU
         h6ueMh3cAvpJJSV3remmh8nVR+xS/Sdt/c3VSXRfIKfAPgZyXwdi7f7PJLZ/4+bvtaDx
         7XbQ==
X-Forwarded-Encrypted: i=1; AL+hErEHBUX6G5EcRS6wAWbXMzhchJ2rThydV2nxn796XW2Dut3XUuH7/YrAYhEMTw+m3iu4DD28yIRCeA==@kvack.org
X-Gm-Message-State: APuU4Z96kszufDr1dRvk5rhowz3JKSBw10l6p75Qj8vL48qR6PkgjiW1
	q3SEhpmtGmNABCj5ILhvdqyjyb8iHDu7Wllix5xhpufTui4wAO3AYhZynh6DDvXC/GRr0odCw7T
	luhla
X-Gm-Gg: AYBFou1qTRwKnSkUAv9jTCVwNOu0JKQQaWsRVS/ApjibGXvuROZAcQrIQk37uz9d+2C
	M2fH/9PZM3OE6tFhpsAMUKFBPPhVRhpSx90cjCpDQoYo9+5d+16odgfOz7a5T2pedGzxkCCBJxl
	vXE3Z02BMccnazP7CMdJulTa3M7lcpWigmk1POPV+foKa653kXThL0RuL1m410RICZqiy0beDbp
	2LiCXjKkwlgH2OaX4srDplXGRn1UJ4BucCizEZhSqTfXdDVxg+jWXiMK80RmybztHGA5OMB7RWT
	BVPXf91FIeczkyUTRjhMwfHZz4yP04eUpIpK6ZsXMwkdeP2TbBZqS7Bj3+LLaYhS/uo/UL1P3Sw
	AxR4r/bCdrM1+Aqg/8jhaFNjU4kMzUX5cOKDY4/ZY6z1wI2fZOOuWJ1lEf4WrEZ1HwtgkBo/1JI
	Jc48x/UJ6RSVkIL3MbnkruqC7BJLOk7ePmWQBNGKuyXb4E+Zk9ZIZuUAdBIwQg97P05JO8Lr8A6
	CM5TB5252fDP7GNesy3L6PuRzhwr6AE/up4aibauVEA+lh++3bBil8qoUwyJ87gmjkXjSln6k3G
	Fmze18Us9PxIhYpKOuRaOZTmZWX6VzN/B5vu4YP+4qmjfp+orcxYdYiEmisYNVnxqUv3C40vY0P
	RLFuomNgHNp2wXfr6NHoz50uOLIYf
X-Received: by 2002:a05:622a:4d98:b0:55c:e8b1:3349 with SMTP id d75a77b69052e-55ce8b169c1mr107785991cf.25.1794845622539;
        Mon, 16 Nov 2026 08:13:42 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c6025f5sm868661285a.5.2026.11.16.08.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 08:13:42 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/2] mm/mempolicy: limit shared policy ranges per inode
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
In-Reply-To: <76fc4555-b458-491b-ba2c-ec030879dafe@kernel.org>
References: <20261113-mempolicy_limit-v1-0-16688b2644dc@kernel.org>
 <20261113-mempolicy_limit-v1-2-16688b2644dc@kernel.org>
 <179467808112.482102.13365594235443107281.b4-reply@b4>
 <70740a32-92f5-4425-8676-68863f3e44c3@kernel.org>
 <179468794889.482102.14066028910704780583.b4-reply@b4>
 <76fc4555-b458-491b-ba2c-ec030879dafe@kernel.org>
Date: Mon, 16 Nov 2026 11:13:41 -0500
Message-Id: <179484562114.482102.7068121367282977254.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 6F6FD180015
X-Stat-Signature: n9qfwtpja163mwhe476zo6uru8ds8ksu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794845623-484477
X-HE-Meta: U2FsdGVkX196DKD+zPzCktP7JrxPlHuNv9sCvh+PPZrVGoUGr0bDcAcLYNHc2SlOHeVX8m/9z+9vAihUuXT1K2xaKkyiHr6XlmF5NDIc01ZQzgOSi0WaLAmq0x1+3QfEALpEEk8TqjTUhaTIRu1HDCwQ2OwdO0nRN21gPKq4Mwp4efAZP8a/PBzms2ReJtHw60VYsPNz/+e3dZcYf+st4F1E9L/uarRbupTHOF1RtibYDOKTPdillRE7SeJQdImlB6EkzWe9h8NHa42fQKbi7KJX7xTv+bTxcT7lN7CmaWfcuG86yEIqAbEzFzCyHsNHOsA4wDSGvX3+tbGm1R2sO+IMKJHPB+9W12mS3hmTPxvFBnP1lUxf0AN/C/WHFg6jzoc9gfrAJ69z+LJjLrKRSQaFxZPDKB1+gNKiic/HdrSmLtsiqDkmWkhn+RJmlrDtk1cACuyI9kTSSgzd8ff5FlAFy/BgsD+DpsPr5JP1xGzFBJvu4m9PrRC0EzBMfFa4G1H9b1YhN4MX2+QFKj88A3otn05/3Xh3FppOTwuKqJ/TyvhJQEzLvYd5mvTO0z+ccniQ1DxiNIEPvJnWEHwJI8EkgzCuZUFNtugT1bxYR2Yc1SdEfPaGRADy1X6bt5nRMpnQZ+YxXZ7YkE6RlFbUGbjD6Xuhs8EQsI36tpHg/EDM3yuKx1UOsCTVFKq4ed0tU/UuDLTLUZ4K/oc/+gMXCdCo809gxYRNpXK0G/J5NYbNFwb5HvQt2fIU5FeNke7wabwHf+zt+R6egnEz1qvr7gaZhpeH8STdlG3HdGuJydT8v0+YsYFsa9CrOMv7Ej8kXokam0xxof1OdmbFGlgxqxcQ9pbV8ACEfUS7tmB3EkFH/tzssTRPuHwbPLqc8KUWmitx6NiQvH8eVaiuRMp45+0s52nI/YVklF0XgJWtXIl8ywDkFeWssafSJZ6fhfgnMTTK0tIi2pmFD8ZyD9c
 AqCv1SzE
 NcCH9Lvu09NesJ/z+r3KHjmdYhKknIpUuJZdrtom1k1lwi9fMe2MhICo3J26W6K0f9INs4T36S2EC2SYOP+4PhQz45oENpsugCbTvDWVzBzpM3J3z2PxY6W6L3IpXPd9BhZOCWjSawPYBcFrL9RcynGmq17Tl8qIx2v3Gpz86WR5x+lfr5RSjdqBeJXCnlyLlk6m+rRL7ShNN8qMXa+sOd3bhIiaYrnRlZ+2lgdVpGb/ES+RPGhVNUnJXnD/Yv/GYAEDKp2j0S2irXR+hNAN8oSwMaHtDT9oLyrN2WfXs7o1wgPemIRAtCOYl4Qcz2iqpTS3fddlgEN8+UqaOhfsVwku6FJug/O7g/EUD7c0uvtYTFF0IJktjpo3oH32APwe8CN0R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-15 17:40 +0100, David Hildenbrand (Arm) wrote:
> On 11/14/26 21:25, Gregory Price (Meta) wrote:
> > On 2026-11-14 21:16 +0100, David Hildenbrand (Arm) wrote:
> >> On 11/14/26 18:41, Gregory Price (Meta) wrote:
> >>>
> >>> Multi-task mappers were previously unlimited, but that seems like more
> >>> of a nasty unintended corner case - not a real feature.
> >>>
> >>> A single process is already limited on the number of vmas/policies based
> >>> on `max_map_count`, so it seems natural to just use max_map_count
> >>> directly, but I took a brief look at some distros and most seem to
> >>> ship a raised `max_map_count` (>1 million) by default).
> >>>
> >>> I tested that and even 1 million can cause a soft lockup.
> >>>
> >>> Not sure there's an easy solution here, we might have to rework the shm
> >>> policy locks.
> >>
> >> Do you know a single valid use case that's not solved by patch #1 and would
> >> trigger that many policies?
> >>
> >> Ai was not able to come up with anything for me.
> > 
> > Just want to make sure the bases are covered.
> > 
> 
> Yes, and I'd be very happy to learn about use cases.
> 
> Maybe we can let this stay in -next for a while before moving forward with this?
> 

Seems reasonable, although just kind of delaying the inevitable.

I suppose the mitigation for it causing issues is backporting an
increase to the default size.

Eh, if the concern here isn't a big deal, I'd just say ship it.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


