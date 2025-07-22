Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FA1C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 01:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552D58E0002; Mon, 21 Jul 2025 21:49:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503948E0001; Mon, 21 Jul 2025 21:49:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4405D8E0002; Mon, 21 Jul 2025 21:49:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 32BB18E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 21:49:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D7B898021F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:49:57 +0000 (UTC)
X-FDA: 83690219634.09.1A23DC1
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 100E640003
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:49:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=softfail (imf17.hostedemail.com: 205.139.111.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753148996; a=rsa-sha256;
	cv=none;
	b=IB2myt320D6NXP8C8ud6f/bxqPZ2frTa46mwGu9vnLS6qsU+29R0xYXyRP57pi1g4ZDCnn
	ZnmcK18yaX9QQliTOSfrLpNMX2BINgj2HfcUpz1/LHfulHd8fUA9ZmKHtEOr3R2us1DD3h
	+lB2I6p7pZV6yW5jmuuxwtsC61OLspw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=softfail (imf17.hostedemail.com: 205.139.111.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753148996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=ZnV2Bd/mwpw2RSDJEXUkJ9lvw3Djt08eQYkYkslJLFg=;
	b=upB59SLlAhSG3ozltjm7AfcQ+28cqAIB0s12w8XOGV+Wv/P3BJBLqmJcB4ahQvtMJvRaWQ
	L+pTRRF3pmYBgYbwA1a5r0hHjOeYiENvoKV/UJCLRzLCZVU0bIrQe7BptJ1OlaOYIDDMQi
	ykxlV/2/tNV13beGNV3ybSjSK3h53Xo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-302-xfYiSgwNMU-YOIV9eZyv-Q-1; Mon,
 21 Jul 2025 21:49:53 -0400
X-MC-Unique: xfYiSgwNMU-YOIV9eZyv-Q-1
X-Mimecast-MFC-AGG-ID: xfYiSgwNMU-YOIV9eZyv-Q_1753148992
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A628A1800365;
	Tue, 22 Jul 2025 01:49:51 +0000 (UTC)
Received: from dreadlord.redhat.com (unknown [10.67.32.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 46C5019560A3;
	Tue, 22 Jul 2025 01:49:46 +0000 (UTC)
From: Dave Airlie <airlied@gmail.com>
To: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Christian Koenig <christian.koenig@amd.com>
Cc: Dave Chinner <david@fromorbit.com>,
	Kairui Song <kasong@tencent.com>
Subject: drm/ttm/memcg/lru: enable memcg tracking for ttm and amdgpu driver (complete series v3)
Date: Tue, 22 Jul 2025 11:43:13 +1000
Message-ID: <20250722014942.1878844-1-airlied@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: y8A20M1u0nA5ZQeVbec5lKBI484qJbYv-Lb3mzz0XNQ_1753148992
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=WINDOWS-1252; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 100E640003
X-Stat-Signature: pz9r99qb7ys3rxm98q5h37x85gup4sre
X-HE-Tag: 1753148995-301176
X-HE-Meta: U2FsdGVkX1+lQueZV7SjVaKQIPHpX7IH3jCM0NcsNlbXMdwOpz/uU5g6/Ic/9YQm/GhkYKnYRCWyHLeT2RSCV7I/5/PzSuWUG7uT6SHthUKkE63DpFwubivsdPW1UCzS6xX4976LXa1v2Ki0OLxeaQ3Y1w1mTccH9kp/UevmVpVZFH6/DV0zlXaWxG+eITCNfwxA/uRfC8bmwUUXSA6xr0jK1hizCV6bpKVT0FrlyUSRfIbXGhk3BVmL7opQCCt8qZeQVRAJbI7Ugoklx3Sk/2bZPleQc7v7iI/+nTP7FVDKxA7fkaWFuWdILCac17KoqJoQmqs0yRzouI+eUTOh3mdt3WlQR1ILWM/lm7U+tRPTxiW05mh/ddnQadCDhhbeGjCoB2FhZr4RGoO1aNh4RA+g1TT471k4OtW/ncTTZq/QfD2kHWJGWi2F+9Lz/H4+df7j3aIAEydlV5QNZnUgxr3O0sQ0CB4JwYuWKEpuHPA5TWNauHJ5bn9rBtYEdI0UevKqlQtDykWj56f0FYfrYsDRhxhWlmo/4TpWf7CBOj0R+uJRwMAMi15gPk6/oMBF8bs5Q3wQIy7u/hy17HBE5RVfyMeP94+SCbQ6+gVr/mSVab93dQT9tQbSsI5HhwKPKxrgt4FjFX0EJEKYnNy4sHuwIZ7vHd1kHV2Xm6LxW7hbC+ejUUpPBoccUstXUaAv+0gyPZIPNRxTQm0O8NeLJ3W06bHeNLVNOyxJshMhFIIeAK6tlC4n+N18PfPK92TzHjRNmqTiybxTt3YCLMLXqwSCcFY+UgO1LVa7w1pzMJKf8MBpFzdAeXSi+44a1SCXFuacgwlI6OGCfzK4QFx1wvGQxV/Twfv7Q2GypqINtcXuOH8Y0EJkMuOh6Z7dZeGJXNuCbGo4TDgR5cP29ub/esjfYKt1Dy37noGTQPVwn+Pop7Hnc22L4fScf6IldereI6tvpQvqh86VbU5zfKm
 7bnAX5FI
 TbUUTMWgmiUAUbR6F7gIs+QpKj7m9/VjidTVTni8Xth9ThyIZ/brk5zG1WUQCGS5cUFe7uL0Gf+kZheQEWzqwaIzYMZwmW7zR0uVH+g2Upziu706GmD/8Fkre5Zx5d9lR+OMX9lCblNWACgJGk0f0kjVqOLYN4TN8+wcVE+hVsbQp3pxGE0D9AOJo/eASu8wykh2zt3sudtlT9NjD8aYdKn8LPFJgz2glum3qwubLsqS88cLQrtI2wLllY0aLqi6R/k2RgzEmI/vwXG+IFxSc9JFDXHUD8dB6IJQIZyqyZmpagzrbtgYtEJBRToQfnojVPiNULDJ9ZhSvbBbM5y+/VuSorvCWaHTy25+JzKgcsdy1H40vJVZe/iHCuw3WqGby79VrwFw6pnx5jch2nxj4vVOBb/w4H47A2k7OIavxXeTOgyOP45FzI7foeZ0Td8OVF4EKaP1Wl4V0W74hOcQUslwNCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This is a 2nd repost with some fixes and cleanups. Original post is below.

https://lore.kernel.org/dri-devel/20250714052243.1149732-1-airlied@gmail.co=
m/ is the 2nd post.
https://lore.kernel.org/dri-devel/20250630045005.1337339-1-airlied@gmail.co=
m/ is the 1st post.

Differences since last posting:
1. Shakeel suggested I squash some export additions - done now
2. Shakeel suggested I use lruvec in the earlier vmstat accounting - done
3. Christian asked for the turn off patch to be more generic - added Kconfi=
g/module option

I would probably squash 16 into other places, but left it alone for now so =
we can see it.

Christian has an outstanding statement on suspend/resume breakage that I'm =
waiting for a respone.

I'd like to at least land 01->06 in drm-misc-next soon, to at least reduce =
the patch load.

Patch order is now:
01->02: add support for global gpu stat counters
03->06: port ttm pools to list_lru for numa awareness
07->13,16: add memcg stats + gpu apis, then port ttm pools to memcg aware l=
ist_lru and shrinker
14: enable amdgpu to use new functionality.

Differences since last posting:
1. Added patch 18: add a module option to allow pooled pages to not be stor=
ed in the lru per-memcg
   (Requested by Christian Konig)
2. Converged the naming and stats between vmstat and memcg (Suggested by Sh=
akeel Butt)
3. Cleaned up the charge/uncharge code and some other bits.

Dave.

Original cover letter:
tl;dr: start using list_lru/numa/memcg in GPU driver core and amdgpu driver=
 for now.

This is a complete series of patches, some of which have been sent before a=
nd reviewed,
but I want to get the complete picture for others, and try to figure out ho=
w best to land this.

There are 3 pieces to this:
01->02: add support for global gpu stat counters (previously posted, patch =
2 is newer)
03->07: port ttm pools to list_lru for numa awareness
08->14: add memcg stats + gpu apis, then port ttm pools to memcg aware list=
_lru and shrinker
15->17: enable amdgpu to use new functionality.

The biggest difference in the memcg code from previously is I discovered wh=
at
obj cgroups were designed for and I'm reusing the page/objcg intergration t=
hat=20
already exists, to avoid reinventing that wheel right now.

There are some igt-gpu-tools tests I've written at:
https://gitlab.freedesktop.org/airlied/igt-gpu-tools/-/tree/amdgpu-cgroups?=
ref_type=3Dheads

One problem is there are a lot of delayed action, that probably means the t=
esting
needs a bit more robustness, but the tests validate all the basic paths.

Regards,
Dave.


