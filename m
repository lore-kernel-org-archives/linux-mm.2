Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2DC9606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WiI9lEkU
Received: by kanga.kvack.org (Postfix)
	id CBB4A6B05BB; Mon, 23 Nov 2026 10:01:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98FF6B05BC; Mon, 23 Nov 2026 10:01:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA8C76B05BC; Mon, 23 Nov 2026 10:01:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9ADB96B05BA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:01:11 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B1334094C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:01:10 +0000 (UTC)
X-FDA: 85466696700.07.80B58CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id A227616000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:01:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WiI9lEkU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446068;
	b=k/nnxVupgUQt1sEU1RpY1mHQvL0vofgDDX29KVRyykbkk7PeCuEn/vw45+CXu1vx2dgmft
	31s6lteVtU+7mSwbYIbPXEQ7oJYMRSzyUwGr778JEKhnnhZtutF/WhIML3/86QSYRkIRSV
	+T/s5xu6MIzznNJw4VOZXcbaHq8DTKE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EUyMU/XwUgHp5lO8B06tp0V12TwyEXwID7MKlCvCTy8=;
	b=TpoMLJjcxOjMc/Qa/F2pq7cngOgeYVo9BTpaSB8S1RCED4qkBT/4GOUOjSre7khBbFmDkO
	ESB9rROcClcbP6STqROkkTX8RfDRebSpmZKVdmiNdQzuE+QsB71aNOVKevMTXEqqCWtUfj
	BDP+NAO6KKmkr/w7yHmCr1PczfOEHjw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WiI9lEkU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C511541467;
	Mon, 23 Nov 2026 15:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0241B1F000C0;
	Mon, 23 Nov 2026 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446067;
	bh=EUyMU/XwUgHp5lO8B06tp0V12TwyEXwID7MKlCvCTy8=;
	h=From:To:Cc:Subject:Date;
	b=WiI9lEkUAnH8OuHpkoY4GwaK5YIQ5H77rtEyur9agG9ceB4IA/UFAber1CklXJhjG
	 8RlPX9NyD52W3Ds0UOJ5gsqXlr0tH64AxOc9CbDXV2V3RUWyphHPpHuCweQ7l8NkK3
	 ohB1+SaISi0P1vlf8tFkVX0xGbrfce5/nkQ0vci4W6clyeL9Gny99YlwvnGnSIgnJp
	 K/yamsnDc4x0ZtTlgbu/6bQomUI1ZsUWvWrbLMMe0pXc+ejKimd9AnAOoJbPqeqM3J
	 Cc4kHsTPX6bqf1ajVNZXvxi4lUJFU3ixyBIbRLTB6EpyesKEBem49DktAwsJbaMY7d
	 EMt0QXK62PRPQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Aveline Noir <jm5905938@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH mm-hotfixes-unstable 0/3] mm/damon: three fixes for idle_time overflow and damos_walk() hang
Date: Mon, 23 Nov 2026 07:00:45 -0800
Message-ID: <20261123150049.81317-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: z3ncbt8tb1b44dh9a57t1k1xnoyn6k4m
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A227616000A
X-Rspam-User:
X-HE-Tag: 1795446068-84117
X-HE-Meta: U2FsdGVkX18npi/uZVZH6zBKjTS+/+OVyJ/QyBqSDRX4ZgaHxnAsNcXhkJGJxLNi/2qIFFw1hZzSPgqV62imD/DxNdVWsIK6qDDJdcEKgPBdEhE2CMtxXpgn+xMNAfQbwq5SQZFn96OogQMd5JV/UOQjESYGVctRaUW1GFP6y3DKGEKK9XN0xFDmurHfr7BL7TX7Q4tYtOXyukEzVrbbNO4fL3W+1K4IoyABtlJ1YvF+pao9TtAkIMzG6PnOZftnJBxpkTHla/9zf05H9Z50I0/P/0ADcTPzx5myxJ/js3V3Tl2Nxli2l0duUUGrnfdAQu+2WnNqT0mXFIaV3RReTFPSLBMNIT8Zd5YLK2XfYDo9iZiDhIefJp5FYv3Xs8xnIJ6tqXEWb/Lx4kSjqh3tglSpWMlOoAna1QnpMl2WKG20Xhwp6UrxCUUlPyt9oUkzHjp2xJq0dq2SQKZSR4NYKgSSl8zMFUkQoKGicTfabz40dCzG6/KLLBsVTohQE28ogAUK1ho6WlgXA95y/exbEOfP//1FHXWTslIyNpN3HuSOBiK61DIvkZWGbfQ2llY/pJvWer4MpdRIPNumZ07CXRjyh4k2Q8HRNAKWR9jyboe4+zr29mLVyQ1im+OSpbfh896paQ99INbjebVmP376GEvM3Xy1T5MMHk3g5GmdpKBXwgl95n852wFzmCyS4ol7pZKWwjzc4JtV/NBLNZOAE88+YCMFrC/lMPxso9PZKp/rnHDbxGI/7ZMiGVrUyOtELuFEaoKPfIB7HUEXYA9dce5T7eNXCnV48UwK3JQ8gmjjuYVePat47SY7bNo729CBtyfqarGGXGv7XUE3Gy55t7KsdHEy+1FDsqC3DmXA+5/IA1uAOFNZgxxAIaaL4kU5A8e7deLChdR5PngNxStsmA32OFicvh1XJpBEOV9OIglTMWONGiYQyxgBKeduNl+eDNce2pYfmY2fUlOKAwq
 sgeobkbO
 Yp5Qh22qalga+gllEI6xF7f4AfaVsJ2YX2QI2HwfT2FPeXILbN5h2PltFdOIW8ebJJ09f+2Rmto5hFwM9g5wERiKlVorQOooXd9M/gyPo46yMgS6mTL3BgRvkDvqc6BrCB/mRepT2zk4R4l98DkQE3PJwld3MUI7ep1kdNUEA5qXisf7ea2UxTtlDEr0jJO+BGIvKrWAuQ7J7l6AH6jBBAwTOksHVps4mOk0H6mmzyaJsJSJeHlwbj5dI+dbiK9wi+XQic/t8fE40ixq2w+5VH+cL/dgYQ64NBqBt15y+JMtUMgPA/QKkYY8xZ1t8VMk6D5xTzvxehupS4jvS5rOJuV8mcu+2mPFrJ669OCjU9u4MGWh7xXvfjHYefffZcAcge0YV3pCBUkDT67uRttR35BRX+K6LQgmJvg+t4bzQYhAhrTtGGQNRJprF515zcMQ76gykzfTye1ZLq9fmQAIpP/QB97VdmSMEJi7/XgL5g8gx9N223A9BKCC1VGHihgrtZGpf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Avoid 32-bit overflow of idle time calculation in DAMON_STAT, via
patch 1 from David Carlier.  Fix a damos_walk() hang that can happen
under certain watermarks setup and a watermarks commit internal state
overwrite issue, via patches 2 and 3 from Yifan Feng.

This is a batched reposting of separately posted and reviewed patches
for being merged into the mm.git.  Refer to changelog on each patch for
changes that were made before this reposting.

David Carlier (1):
  mm/damon/stat: avoid 32-bit overflow in idle time milliseconds

Yifan Feng (2):
  mm/damon/core: fix damos_walk() hang with zero watermarks interval
  mm/damon/core: do not overwrite wmarks.activated in damos_commit()

 mm/damon/core.c | 13 ++++++++++++-
 mm/damon/stat.c |  4 ++--
 2 files changed, 14 insertions(+), 3 deletions(-)


base-commit: f6538c11c47408c69dc77d38fea1b2a4fca86f3e
-- 
2.47.3

