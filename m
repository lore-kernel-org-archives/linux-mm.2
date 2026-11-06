Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8B10606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 16:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=janestreet.com header.i=@janestreet.com header.a=rsa-sha256 header.s=waixah header.b=RRhzC3tk
Received: by kanga.kvack.org (Postfix)
	id BA3226B05B0; Fri,  6 Nov 2026 11:31:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53266B05B3; Fri,  6 Nov 2026 11:31:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A68716B05B4; Fri,  6 Nov 2026 11:31:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 822396B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:31:41 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 08C4E120147
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:31:41 +0000 (UTC)
X-FDA: 85405235202.12.7B89224
Received: from mxout5.mail.janestreet.com (mxout5.mail.janestreet.com [64.215.233.18])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7C726140007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:31:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=janestreet.com header.s=waixah header.b=RRhzC3tk;
	dmarc=pass (policy=quarantine) header.from=janestreet.com;
	spf=pass (imf09.hostedemail.com: domain of ehagberg@janestreet.com designates 64.215.233.18 as permitted sender) smtp.mailfrom=ehagberg@janestreet.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793982699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xHu8pGb2qY5UYa4jLSYkZgw4/M457fi68VtTjeWnUNU=;
	b=WylBmT4eM1PmUwZF6jCUqq1+dyn1ZR7O6Qj52QYSIoOXDQvJXX6IfTIz00wkgpQ1d5I8AV
	nJzYRl+mySo/nquHUd2k4rO8EtejMQUna0w8RI22mDRfEOIOiwHVetgHlbO6VK8ZVdCO/T
	IaK3AbclvcIWEUkzYg5E+gIVXJuOazo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=janestreet.com header.s=waixah header.b=RRhzC3tk;
	dmarc=pass (policy=quarantine) header.from=janestreet.com;
	spf=pass (imf09.hostedemail.com: domain of ehagberg@janestreet.com designates 64.215.233.18 as permitted sender) smtp.mailfrom=ehagberg@janestreet.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793982699;
	b=VgciVQe0qepZIeU7F8iQpQaJxirS4eI3OSTtXjeu325TiAKJdqsP7V8MJWauypc6o6u6Xx
	8Nm4StoQJ9TgDHWwpJuUWmJGXr+uIfHT+zjPQVfRCqYjd3jr7L6rT39rsKNc2ZHgWd/sFh
	GYOrfoY4MF/i4NyXteLF0GjnLT1rfqA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=janestreet.com;
  s=waixah; t=1793982698;
  bh=xHu8pGb2qY5UYa4jLSYkZgw4/M457fi68VtTjeWnUNU=;
  h=From:To:Cc:Subject:Date;
  b=RRhzC3tkWigVaXJ7gu//Lfw8iuuEd32Zu0jJRVjVTMlNpnTBc2xZ9Vgj3q4gpGaFu
  YNXwBL/gvvzHiCivi/bgcS5OPoiPnb5KCbpFih4IOryxelCS/WQkm2/C/rvZIHoBPA
  qub2bfAUtFQq03ypOFZ0xP1ViDnlAMee1qIOx4j1XC9wd82lKBw2zohBqDw3XeG92p
  qLupvqGkN9+AbYC6O66n8YKZmT8lZC/+LawZsm5Xsxy8lPvgeFmHiRTSvZnt5S/Ipw
  xFQfoDTF0y1zdiLIEvR09ig657tiHxTRKbDSD+PKkiXkjlMBrZALKcjlycc9O9OiCO
  lyfC7Nlg9VQuw==
From: Eric Hagberg <ehagberg@janestreet.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
 	akpm@linux-foundation.org,
 	zhaoyang.huang@unisoc.com,
 	tjmercier@google.com,
 	shakeel.butt@linux.dev,
 	kasong@tencent.com,
 	baohua@kernel.org,
 	qi.zheng@linux.dev
Subject: [STABLE REQUEST] 19999e479c2a ("mm: remove '!root_reclaim' checking in should_abort_scan()") for 6.12.y and 6.18.y
Date: Fri,  6 Nov 2026 11:30:55 -0500
Message-ID: <20261106163056.541441-1-ehagberg@janestreet.com>
X-Mailer: git-send-email 2.43.7
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7C726140007
X-Stat-Signature: gjmqbfrncmw399pt3fgmx6nxqoorzpys
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793982699-916800
X-HE-Meta: U2FsdGVkX1/HNfmUHSIJc9khWzhfDlIeCJMc8HrnWtSK8CC7qobpplXiDV+H0SUIY2c2hJr5XlklFu1P86bk0bfLj2FfX2fK06LtooPMv1Nafwn3r2JFvNHr0lsZZ7E/r6SUJ86G/4wwTEYe6sy+QIXhg7c4io/51RfwrLqGnrx0bc/eHE0pYVLuSg10Ie9iu95ic2e8cdiC6hzFmjwwuJnp+05qh2iusvof+vBzlNN3G9hd79vX7L1/7QX/xaSdo+9kLVotRcsnAyJVOzktqBn3LoPUB+imxcJqsacTUHfHJayKYuUmX7nlme9PvbkIX/3E4AUHNj9Lcv6zv91VYppzmFhkmEdEdHgbTRd6CsyRVGysnrWjh7DFrgTuDgtGGw7yIpMUacm92Ncty08v8YR0uXaaxDgi2ZpNpk4NTllJ1bgoUz3peU2lDtJEPj8BfiF1VtbG0aTMZsjbF4z/nNzbbHtDSDIz3H3J3g6+L+Gw7qCdR4WdWVIaKVtuugudq9b3BaMhBH518r16gHM4QugYVh2Wsn3lZDWsfHMDG3DHjnZ821Nf6jZp5C/Q9ewVWrZcmjAsI1HqLXA6IIatny7fG2qF5enR5UVpAnXLcMrZVxECmYJEUaQoFaZMMYYzWPBYwUE0e+Rs0yWmEQGt7SebqS89576FoLrTx45vxYrz9g7EvfmLT/dq5x+7XaHQx4r7+sK7BIC7WPQZ9ZepLlGasFqerAegrHq9KfqkOCQ1S9zhd1vxp6OzmnkOyWr3Luk7JCItHQkoJENdYjer3irn2VY6TtcQT9ewTC426VGi46npxpB/MRzg8Zal0KzQwsxE5yaUPrHdM+O+byOmRZk+v1EsvYF0w24VxksSWIdBAnAJQH/Ve79yRtNUkJYEyGGPwZkMGxLajfxLtUrU+49x+zMa8xG/aYBwDLX48MA76uqi17G/2MyyNiugvdSKDyprM0+BBqtAZjQbDyH
 C1qPq+61
 l/nOK+qsXgSV8TRdplXxrwUPYJcIlaLGUD+P2Z7VvAJQZ2nbt8GvP2PhtE8ObwLbdKAeKb81im2eP3K+19OOM4i1QWovI7N57DX5B9ry7q8/EtyDzRX2pfqYEfXkCzpDyftGkW+YehPwvzXgnp3s0GQ1spxW9B7LBQt+6dW3fom1S5fqKAlJabOzkQ+Iy+TKeAYmS3S3vwHZ7ek2kO7MVlVTmDSqG7Lfrl1+1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Please consider commit 19999e479c2a ("mm: remove '!root_reclaim' checking
in should_abort_scan()") for 6.12.y and 6.18.y. The commit was merged for
v7.1-rc1.

With MGLRU enabled, memcg (non-root) reclaim never bails out once
nr_to_reclaim is met, so reclaim against memory.max/memory.high can
over-reclaim by a large factor. That scales with lruvec size and hierarchy
depth. On some large-memory machines this causes cgroup-limited workloads to
fail under memory pressure. Disabling MGLRU avoids it, and applying this
commit fixes a reproducer with MGLRU enabled.

The check being removed was needed for fairness before b82b530740b9
("mm: vmscan: restore incremental cgroup iteration"), which landed in
v6.11. Both 6.12.y and 6.18.y contain b82b530740b9, and the patch applies
cleanly. It should NOT go to older stable branches that lack b82b530740b9.

Thanks,
Eric Hagberg


