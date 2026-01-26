Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92D54D19520
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 23:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EF886B0088; Mon, 26 Jan 2026 18:03:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672CE6B0089; Mon, 26 Jan 2026 18:03:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57F6B6B008A; Mon, 26 Jan 2026 18:03:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 455896B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:03:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E05868C750
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 23:03:17 +0000 (UTC)
X-FDA: 84375642834.09.645D34A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 58CF020005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 23:03:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NfiIg12R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769468596; a=rsa-sha256;
	cv=none;
	b=xPrmRW611rwERqlGal97wh6aCggYfAG+hj7aBDcn6j0xZh5i2Rbvv/vu62/lSiHZX3olMw
	qdAaonY+Ohr04RNBxY7XPTV6rKVe33mroDYevsgsvbPxfYaBtWnztwHoWPBMcUul07gO8u
	Zd8ACu2ed9yeLm9USEEro9mAeQVh40s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NfiIg12R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769468596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WhgejczCrG0z6+ypE13rND30AZEwJhEVDQn8CR3noYY=;
	b=GUHbLKbZujM301sD+3fJ7BTfYLt1rPcTWbHL3xxLaLzPqW56/sMGEg+OJdrvg3FjYPENTb
	Upen7+q7pFGMGIksJkOeX3QNOwMp1NjHlZ0wYWwu46l9twFnimCFODsK+Sqw8GZpUiEPbX
	e/iRb0703ltiplVk54hXIT+KlMKGBJM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05AB643532;
	Mon, 26 Jan 2026 23:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD07FC116C6;
	Mon, 26 Jan 2026 23:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769468594;
	bh=tnkGgklz3TfkwbdTv4/4KPFnQf9ngexNju9cYOwAffc=;
	h=From:To:Cc:Subject:Date:From;
	b=NfiIg12R2d8nWus0tAjQD+vXkAREoCcqoz1/Pt3GvQLJ+U2SUNGh6W/xa67A0zd7+
	 Jvi523FXVXq/ariuErLivct83sImqpUOAiESDojqRO2QX/Otne/ft2KabsyqAhQPsb
	 tv6OOaoEm9OmTQnd5dXjMIjiRCwHsHu2i3LDNCbuWiVgVqwq5xz6AN64EdUrNlATKd
	 YZeKCZOF7GFry3lbfVZZcZVjajBvQSvDcIb4G6D98sfnUiSBuq9FLg2Oh9bVMh1u4s
	 UpjpvsDgdkOFdrfxzBU52HVxzjr1pVES+8I+cO4OXaBlVutWeSSLy4bWWregdgbIfW
	 V9WkkkkyJ71GA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] liveupdate: fixes in error handling
Date: Tue, 27 Jan 2026 00:02:51 +0100
Message-ID: <20260126230302.2936817-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 58CF020005
X-Stat-Signature: 1hrsn561uhedaxruiic5fkywuyzd5n66
X-HE-Tag: 1769468596-63189
X-HE-Meta: U2FsdGVkX19Br3z2KxISO9kl/VCO5o08+UOo+4srNz3ey4Dxsh5z54akz0aQXryXKIUk8y1TVspt0JUhIH1Vf5OrOxx55TDD5105AxKBokbuw1tnBvy5gMHpm1D1yk+/GYCPaEPUZ2WxiHUNVtxBKBzxjVqzFkoMj/mZ2EUu9RMIrngBZrog74lv/vWJDSg2i5LugrpVu/UQHxGX1x/tQ+9zEjCHQAusQZJFbx3Vbn9V12UR4rtHajlfDZwVna7+DWQJMUuPB5RPtT8nyPNcD/fxT8Eio7MQP1WTcOxolHLlyQEXgqvB9YGZvV8L6lTJnjMLSRtcrzR/A0BP8WxvwL9+Sn2dt8d2RfdGZeg1VozwfEedkQ30HqnLrX43vwNYcN5m9aHlwR8u5leeVh7rhMGjWqh+1CsfuB4E28JGzdlUp2bSgR4JdEo1OAWNRVJBG4RI5U61ybtSYaewUcFpOiq/4o9Ks80t52iIIPYCsTKjyG9x9YyPUb4h00VbwI15Yywsuy3BD1K9Sos+s+a02mmVdPuA8Nkw4H8WALSfu80//aNSd15HgBUTlKfamu2mGZKB4U2+rSCMmFz50AbipH+gLfRSYtWw/TnpevEeRr4AGNRoI+r3QYUmQ6XQx6e9gSXHMWQZKG1m4kU3HGFzIutJAs8OWs4dRyIcj5uoxCRnqfff5UmuqLRN/EJlac2qpufWfU6j4bKvXKDGDbJXhbG0zEM0PwlJgsO7J19oeW7GXRBwmIGBPZrIZ7lfH0D1vkoEe0933GcVfZebKefQaNfcAQYoB+TWBq6whqXOdwmLEiATazfA1VML+lXq/+xMzrQs5/YVhAoJkDcILWjsjVqAaAPs9DigOj4KrjIXN9EoqiwSM7KWwed6K37zhZR7a6er07zuRjiOUrcocNre/GHZdWk9/3NMz+kDSzqOHtSR9lfx7bGqicT/P4CyglOiLHFrqpEHgZZD2aB70ZZ
 jQ3+uodz
 2BmI2Ni9VhucwOAAEyC2GBhcSGjs4IxY8TUrbmLs0mnfASPvNyD8m187QCo07i8yryzoSYLJCEyb7WbBsXwn3Y2PQM/A5rExzJXi5gLtybHE+GFaIGxRWQDDGsj7zyFMW9c5lDP/2Mn9pJQeclfPWVHTkgUoh1gnvo/fnhNw1VA2aVCUs36gO+bqltDu0C9bh7VDvsW60r+T9XzOcf3T5lwae/GBhZEpCGLz64wG8HA17yiI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hi Andrew,

This series contains some fixes in LUO's error handling paths.

The first patch deals with failed freeze() attempts. The cleanup path
calls unfreeze, and that clears some data needed by later unpreserve
calls.

The second patch is a bit more involved. It deals with failed retrieve()
attempts. To do so properly, it reworks some of the error handling logic
in luo_file core.

Both these fixes are "theoretical" -- in the sense that I have not been
able to reproduce either of them in normal operation. The only supported
file type right now is memfd, and there is nothing userspace can do
right now to make it fail its retrieve or freeze. I need to make the
retrieve or freeze fail by artificially injecting errors. The injected
errors trigger a use-after-free and a double-free.

That said, once more complex file handlers are added or memfd
preservation is used in ways not currently expected or covered by the
tests, we will be able to see them on real systems.

Regards,
Pratyush Yadav

Pratyush Yadav (Google) (2):
  liveupdate: luo_file: do not clear serialized_data on unfreeze
  liveupdate: luo_file: remember retrieve() status

 include/linux/liveupdate.h   |  7 ++++--
 kernel/liveupdate/luo_file.c | 43 +++++++++++++++++++++---------------
 mm/memfd_luo.c               |  7 +++++-
 3 files changed, 36 insertions(+), 21 deletions(-)


base-commit: 2e833046d66a40f9ad3de2948e6ecd791939fa59
-- 
2.52.0.457.g6b5491de43-goog


