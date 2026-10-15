Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65AD8CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 11:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8319D6B009F; Thu, 15 Oct 2026 07:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2F96B00A0; Thu, 15 Oct 2026 07:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E8FE6B00A1; Thu, 15 Oct 2026 07:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9B46B009F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:45:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DEE391C430A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:45:02 +0000 (UTC)
X-FDA: 85324679244.08.5D5752F
Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	by imf07.hostedemail.com (Postfix) with ESMTP id 26EE34000A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:45:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=aKFcWymC;
	spf=pass (imf07.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792064701;
	b=Si3gl54nOkeq/mHQy+FajEg8UqXhb3KecBT+wOr/q5f7p0uo1DNh/VxBrD4gRc42RZ31Ce
	CKYIm9iljlc1SkAib2Pt5yhzAdQOaE7mzWjHH91rzIA6ZvtRc0X7zVsmZ5MVyofCPMWncw
	bHXK1IHoLMHis3pnqrwJJ3vuPylf5FY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=aKFcWymC;
	spf=pass (imf07.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792064701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJmD9ocK7Fs9suTaTWnyV7Zu9zx34PL0h0sFqWfJXTk=;
	b=c/yJ+7xv59EqHSLEi34lq2r+7Wj6qRGWhfc9QwswTxme5ED03dHLNML43zau1PEq16ECly
	LJ9DsrQgK+lBfP9H4QFK1o0IEVNXFLGgIdLu2d1XomyX7MmYBJAy2Jb4KXjqdhMqRiY2Ro
	m9dYPo6RACFAG3kDiz5J4FK6utJDd7I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:in-reply-to:references:mime-version:to:cc:
	content-type:content-transfer-encoding:cc:content-type:date:from:subject:to;
	s=s1; t=1792064700;
	bh=sJmD9ocK7Fs9suTaTWnyV7Zu9zx34PL0h0sFqWfJXTk=;
	b=aKFcWymCpbK2U7jOrv7orsYLbstUHzod+zvjfY0Pzzd7FJyo8BCsFao+2EiAd+MNVQ0e
	OOzI2CeE5+7y8VpUorgtij77WKMsbF+VEemFDcAS+dIPvQ9Wt7yJXAa1rdtrlqP44hWRK+
	HmB751/FA/DW46SE4XAuVezWnS6MFFISiG7pTjh7f2N1/dwE6K9GkTOCN3cto7hCIJP+sp
	5SaWB64U00YuYfRheqwbWB0J+/nQ+cJ3NCQXZ6FGtffxlDsbMTDHO/kXeZTcthSDNGdhUI
	Meq8N9EVF/MrAaiAHGffWh+mu/q3S7rP6/76cZFrTZQN7THayjFLedINL9DXHHxA==
Received: by recvd-76bcf77c4-v72n6 with SMTP id recvd-76bcf77c4-v72n6-1-6AD0BCBC-1C
	2026-10-15 11:45:00.1120767 +0000 UTC m=+1363486.465368565
Received: from daisy.dens.ffj.family (unknown)
	by geopod-ismtpd-22 (SG)
	with ESMTP
	id 5MqOTtk5QKKOvgGuVd3Z1w
	Thu, 15 Oct 2026 11:44:59.807 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: Re: [PATCH v6 3/3] writeback: switch a replaced cgwb's inodes to its
 successor
Date: Thu, 15 Oct 2026 11:45:00 +0000 (UTC)
Message-ID: <20261015114459.1041805-1-lizf@honeycomb.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <0bc5d58533f10b4841807be3025daa11@kernel.org>
References: <20261002-wb-dying-cgwb-flush-v6-3-1991b4e2dcff@honeycomb.io> <0bc5d58533f10b4841807be3025daa11@kernel.org>
MIME-Version: 1.0
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeR8+gg6UKbfD?=
 =?us-ascii?Q?LHFRc+T=2Fmyn=2FDBRPotnjtiCsmyxPemx3wCGze0c?=
 =?us-ascii?Q?niTUhutH87NutD8y4iKX74jl+ogMc=2FOdfUblO0F?=
 =?us-ascii?Q?m9r6MNis1Ixx3Crz2H9yiTcY+q0G6OAjqtUJcTI?=
 =?us-ascii?Q?uvFdkEIWl5XukEQTBtBIMg=3D?=
To: Tejun Heo <tj@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, Liz Fong-Jones
	<lizf@honeycomb.io>
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 26EE34000A
X-Rspam-User: 
X-Stat-Signature: fjfpkjxhhu3jf1s3gp1o1onzoiss6x7b
X-HE-Tag: 1792064700-850539
X-HE-Meta: U2FsdGVkX19OfoeKbiHda3Iy/LoAK3aOaBOyam+qef/upEdGgPpyrz0qI2BJ+lhdXerrDjYJXX/clDWIUpDcMf421Let8UYAeBiM3b82KZUC1auRlQRtyOGM0U3n7PBKSoa+pQT3tUpQ0mfAEoGUxYQo2VYuKw3oE5UFbYgQzTks3F65tLEtJByBD6444azpjYNALZEhGwtf+W1W6C6ReLDE2/CJLSYR0d+/zYgK5brTPQOcDdwFFWJQaRe+75IdPuhyG9+XQeHqZvegEWutZ5OBgx+ATATM54j/m25NW8QXMOgznqSJMDg2CfNb85lqJKRRCcsO231DGf7gKIO4beqlVvIuwnKxhb5ksmYkbPa0djAQUzwv+e8Y3ReAL+e9+FI92YbMLck+dzSK9WVZ89dglpnsOO5iWPf3Rv0BumVQAB9B5mNAFrC0vVb+oCCj9oVyl56PuSvQgsz+jZSu7BDu9iuzgsbtIKr3aNw4d9XsJYarhqoCVvKQhKvhtbEJiuoS26DnNBV1tOBj0y2WdIxGWiJZFgq6ZKD1sFY69INZACXhexDCrCgn8d8IeYYy4aq+cCzy6Dr7ph6Aipj7iUw8qmzUfSRUABwna7ABt2hRPRH7PRDHrNf3s834dOe3RhHbSMDNPWusbrcVhyXNdtedJ74tEN98aQennOtvrZ+wmvAlmbkeF3gl1V6UVna2i/89nh3bx1RW9H53bXvCklvFnKd6aQQ5PuB2uX/CWcWpsf1rKZHOQHRhesWdacFmQwm7hRWknKHXXlyrz6BtGs+QhATE0iHpstbxHtCzWx3Hgjro3x2+eDnWRoJHER1zDazeJiS/VHkPXGQj18MjH8S5FbCQhojHNGoMh8n3pRoeo6xz47iriVMqdew+IenX4AMOH3nmkBRYHAQTCUbSjv8dFGO4fCGX8KM4pGtMp70aQQ5eWBbDWbXNdlolS8acj2UA5i2/FWI9Bs9iuQ4
 Bdlo4Z57
 H3/u1l23LyD5SUOyaO2ZzsJ10FHeZO5RZM5jkWNcXpavcHve/fNG2op1QLlMg5CG4L06lj5B1Qm5L6lCU4UpNKT1VBlER5SIDIlbFHHCITIb3OvSnN8UcJxdx/uy7QIXAY7uRbyDkBeePi76L9r76QYWl/MGySBHyVwtlIPc4peKDjV/CTeLfQp2YRtg0HxwWcsJ7cTdvXWjCHW3lq0e6y/72huFsAcNUL8FaOrznMF67HvM24w+4WfaLf11B0OpzSdPXYP6ILRY4toXt2jiKnRqLoqrV7GSgcS8egwaCOuN4y6LXLepvVEpR4ck2z3V48bSK+5q/l8mpWmZj28O6fc1ujd1z1QWFuB3TpJuOPYwm6WYT/1p/zFCGJeWxhUfG+N3wHTuxkw9fvuEvFiRXMXjmQMbFUO0IIKu+j9NmvxFjcP7Lb7B8T/zlSAzOlmIGDc8SHLoBG+L9BLA/ViPrFyCgHf9iWZ7M0jed1vMa1qMtb7YWjuU5dBIo2FR2PAUf2CEpHbibEpsD+Lpm66MoK4G+COCTDE4jIIWeR7Rp5OFEFnJ79hvng3GkpNnaawF+izY+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tejun,

Thanks, confirmed. On mainline, with a debug delay holding a sync's
work between its cutoff and queue_io(), v6 left 378 of 400 files empty
after a crash and v7 none. v7 holds wb_switch_rwsem across the scan and
takes your other three points:
https://lore.kernel.org/all/20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io/

Since f6988c90671e, mainline's own cleanup_offline_cgwb() rotates
b_dirty_time the same way, so a racing syncfs can drop lazytime
timestamps. Separate fix:
https://lore.kernel.org/all/20261015114307.1041273-1-lizf@honeycomb.io/

Liz

