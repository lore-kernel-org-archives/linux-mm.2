Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2DF2CA9ED2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 13:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9427E6B008C; Tue, 13 Oct 2026 09:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F5796B0092; Tue, 13 Oct 2026 09:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80B106B0095; Tue, 13 Oct 2026 09:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 598E56B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:34:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C5A1E1C18C7
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:34:32 +0000 (UTC)
X-FDA: 85317697584.18.3DAF99E
Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	by imf20.hostedemail.com (Postfix) with ESMTP id AE5551C0004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:34:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=cjPfxSlL;
	dmarc=pass (policy=quarantine) header.from=honeycomb.io;
	spf=pass (imf20.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791898471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yjc3wFNOxrypJJyu5rTq8Vr1Hd3Zz2aUY0wPnZO4Ji4=;
	b=jyPqHWxMPBNy2TPXBaFnRfV83Yh5V1zcGgJJP1+OfsVnVqHlGUpSUS4mxg08UREIkZRUzM
	kj2ufGXVQBs95mEYHfFE+3FuM+ctwaPa1C9byYKovEiqD52roXTU4SPqewpYZZSBhZUBgO
	mP/34j4cyKwgtRi7f0K5RqncxSnlcaE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=cjPfxSlL;
	dmarc=pass (policy=quarantine) header.from=honeycomb.io;
	spf=pass (imf20.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791898471;
	b=zijJTNui/AUBgBvyCrIn0XZl8T6PTSm7yqB+/2YtGKZFSGLRFw3mwc27dZDmJ1T2KB2OPF
	0zRK+xHrLJ36VJig+iZ1FCC8J4po4AFXVsUDlOhigV2Cbe8v1Q/QIb8GLCPi2IRHJPqcQd
	fbOpzYflQ/pxaGr7tOA7dVB45hBdR+0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:in-reply-to:references:mime-version:to:cc:
	content-type:content-transfer-encoding:cc:content-type:date:from:subject:to;
	s=s1; t=1791898469;
	bh=Yjc3wFNOxrypJJyu5rTq8Vr1Hd3Zz2aUY0wPnZO4Ji4=;
	b=cjPfxSlLQkSUdnf0bT733QfnqIyHwuJRNG6OpW0Z7CvBWxnySk5RMr67Oc8aartloIne
	pK56lqo0wA7bw51ni+1Fcut5Q7x9y5Uavv6FVrVtcE40SFKySwMzXlVILGojlgwyFfNLit
	qbCv0j92NNahom4tTuy0p3LA+dH3TRYvluTbZWUUAdx9ss+S44ajRzJIPWJ4tjWXb0kRLP
	Jef/3beZF2rrIcoj0XVGTFmtxqIksgGYEiSMqcrlhfMjLfbhiI+HLfHgCRTBLcWDW2QwjJ
	gtkvyi8l/XWlXAkflQ0eA+zJtTzDlbJameOVs3/1VpBZormpIJ+VqyABDXqJfqQA==
Received: by recvd-b6785b758-pms9j with SMTP id recvd-b6785b758-pms9j-1-6ACE3364-52
	2026-10-13 13:34:28.727189614 +0000 UTC m=+1197221.645450126
Received: from daisy.dens.ffj.family (unknown)
	by geopod-ismtpd-canary-0 (SG) with ESMTP
	id j7TrPBHQTSyTSY7St2F5YQ
	Tue, 13 Oct 2026 13:34:28.641 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: Re: [PATCH v6 0/3] writeback: let foreign flushes reach dying cgwbs
Date: Tue, 13 Oct 2026 13:34:29 +0000 (UTC)
Message-ID: <20261013133428.725790-1-lizf@honeycomb.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002-wb-dying-cgwb-flush-v6-0-1991b4e2dcff@honeycomb.io>
References: <20261002-wb-dying-cgwb-flush-v6-0-1991b4e2dcff@honeycomb.io>
MIME-Version: 1.0
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeYytsq=2Fs6xFQ?=
 =?us-ascii?Q?u5VO+EtT9LXkYGlxJUqGOEwoCTZ8+dJNWoztJgA?=
 =?us-ascii?Q?83GYMzdfkdF5Gw1J8iDpMcYzuTiSEt9CPgxODV6?=
 =?us-ascii?Q?J+YQBdUp3BsvPKz+3HRV7M8mWcCB4XuuCdW4GjQ?=
 =?us-ascii?Q?21qj0Gb=2FNT+XPXbEC7tPjQ=3D?=
To: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Christian Brauner
	<brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AE5551C0004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: w9ebqkhk435kb8ya67yqjahbaa7wobcr
X-HE-Tag: 1791898470-854858
X-HE-Meta: U2FsdGVkX1+VPR7rySGY99mAviQT/pTFEukLPRaCeGo18779Pl4Bu6l2ZLpHeuR1XVRSykKTssQJ4dbajPgzc6pjgLCXISG35KHeGnXWecc8O9TFePVMoV8IraPA5ux8YBLUwb1l0JaqyE0uUMnPL3bIVwy/+rqmw66M3MzLVzKX8TcFMH8/u2JCebtjMG0+xki8IWNe8mrAfccw+hHeFuwPwzFn3zpgn3+8YkZ8cxXRwu6AIqrgwLHnzdw9ipCneNx3xoBITRVpuC+22vVqOld+fN06Ne0k134RyDfu7NgEoY1DDeGUEfr/G0RBORxPLj2Qg41LRd/7VS792nrrm1uIIUIt9L7CZqvrMDsJMu8Xh+FJBQJMIKrPmVJErdhC/pb2PMbo8z4p/c6iZwptolmVrUFHgoJGlRtRiRBadPtBQEMAce/S9qNL5m3xPF+gYKY3HM+kgtuNofYTGllbsENHDobQpQJeWVgBdDr2C8pKOc2/PRXcNER8LAfdhnkWqJqOFoEdgPgOCih9cgAMJ83us+7J+WSaWEQJT5UJkC6O3OmVUxjI4T7+FHYmi9s7Qa/8+ZlghnEgF8KBd65r+o7Iy8SQTVJvv98mA65fo8MW7u0sHg531PbWw/xQGexLhvAqeO7a4aybBZpOoBsNoa7dwPipmaKP2hOtst7ojS5ulw4vAL77DwR4feg00Vdsge+w+O/IcrmOKGvoDE+FQ/eOF2SxDKJ3PvsxuTQeMUjTarWPtLJPzAY8we1z0FAe3nQyZv+1hlTdJqJx91K+Drl079wMYH236tpmNDc9qgQvm7rRfqIl6ir0gCTo75V19NuGNmo9qOsfh5leqOF6BEytArqM8a0lrol5e8MGjPkwyKMuN6MFNYjdKtP9K8O+dUtgbBlaM44NNZLcZ+F75J/cGKuTOL6gOEYAf6FnYQjngNjDBWWiN7oXrAH8eRVX+iGWMSWx70ReIdeSM6t
 1JBi7b1m
 crqY0/sItjQvGH5HAbW4n+7wrVJ0S+3wkYrZLfw6rPArr2FRW/dn64xgrLIpEMgtattRUKTZZhRsgx66isCHXvEWModW9PzM+McsK47wBFTPKnGBHYyxd4jvPG8fn5jPGylXoA6Bzw4HGejdXuKbPicTY+pSEPSwp/QmBp9l4bqdvKK1XHuRnm4jbWobukdkPQWKJUbDYP9BM+W8+Q8WuH8Hnj8DA+kOla8RJYCMMrFDum/Vn8SF1EJYj+nA+XrcYzyif11oBb+3yqor4/xfJZHJl6IqITYcmTQqo1VRfbghPqoPu5WNGYnnPrlhsmqow/XvF4HhPVzSno18PI/kWoESgSFSC3KWJ9/+iSUEQvYIpUBg12Sgeh2fycpHHaobCHEQq1bGp5a3XvnnhrGJZhG8HrBVotLI7+K7VeJMujP4T/ozD9gXYDpfFRzX0EFbls/5snZd5/VxIcGwTuAnkrrKQh6h/7xK3JNY6V/9t8T+5p+DQ/r5VEL8eSl/iEHHAX2Qg6mkA6RGbhBUDV3f9rFOk/AE9qpydZbs8vh/vnnYPJNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tejun and Jan,

Gentle ping on v6. Patches 1 and 2 carry Tejun's acks. Patch 3 changed
in v6 to queue replaced_work again when a switch lands on a wb that was
replaced after the switch was queued, as Tejun suggested on v5, and it
hasn't had review yet. Jan, you confirmed on v3 that switching all of a
replaced wb's inodes, dirty ones included, is safe; would you have time
to look at patch 3?

Christian, if they're happy with it, could the series go into
vfs-7.4.misc next to Xin's 168a8c13159c? It still applies cleanly there
and to 7.3-rc7. If that's too late for this cycle, I'm happy to repost
on whatever base you'd like to queue it on.

Thanks,
Liz

