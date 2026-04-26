Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01C8AFF885E
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 19:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B70956B0005; Sun, 26 Apr 2026 15:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF9956B008A; Sun, 26 Apr 2026 15:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C2076B008C; Sun, 26 Apr 2026 15:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 879576B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 15:31:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0AA20140693
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 19:31:32 +0000 (UTC)
X-FDA: 84701701224.05.910D971
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6F024A0003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 19:31:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ecgvEWfo;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777231890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Jw3LWnEt3tW8uDib2ykc1XiTMmxp4exxP1CjdBPPAPc=;
	b=nxV+ibtUX3EIKN78W9kuAyPETv7KJemg+UadGjTqSB+34zorCJCwaYTF6JrwT4jC3xXX30
	WDG6TGnV9t7i8x1wY98UoNd1TEwx6TjKxvvadrnj3e0VadO9yef5O2Llk/6dH1eMwnFRpR
	joNxRa3OkTggVwzMvme8mrgzgczqyKU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ecgvEWfo;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777231890; a=rsa-sha256;
	cv=none;
	b=KaUJ7S7Wk9nEqBsv5k9UieSnSdKpetxlyRFgkuFg0x6R5/E9ROKx06/oOe7Z64Xfl8W4mv
	vTxcssXplVgU6vJbVI596OO3jArQPgKP3VfOUUWWx9ew0CKERLrKVKBpqW8uHdXGVok7Ay
	fdtx5paDdwggVBVXBcz3aCF+pXc71Os=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B5DC960138;
	Sun, 26 Apr 2026 19:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29F2C2BCAF;
	Sun, 26 Apr 2026 19:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777231889;
	bh=4tHvdx6TSi/pE4+uHCV/opn0vKxPFOFkJhVFTnizMW0=;
	h=From:To:Cc:Subject:Date:From;
	b=ecgvEWfoOCQW+9FcinGb/eNNBQ5wVGjaz9PTP/nTxJS8UV1yCIvLTT+ZL8uvWgSK5
	 IXDpkq3+Lfvvwcy65ImxVZA5awY6MMEDSoektVgQ61cptvIBMHu7SfO1Z+MhoJ/Edo
	 csVppEq7QzYxM+eoTe5aE/23uhCiuPkz75kbUaCZrI+jf6lD92McFB99sRINzq9JEX
	 DL+QX/coAOamnQDV4ksTRFrGvQ/knGBdl21litoSY59yBxCAD9zFh3s7efkWwtghBd
	 J82LDP5pB5c1nUbmiBnTjY/sviZeKKrGmHOkBzTOqiiy5Ru49gLTSErNajqAaoGEZP
	 wNJUQoE2ezQjA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 7 . 0 . x" <stable@vger.kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH] mm/damon: fix damos_stat tracepoint format for sz_applied
Date: Sun, 26 Apr 2026 12:31:17 -0700
Message-ID: <20260426193119.88095-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bet3nwpjzomckhg1qjt4m6s9np64gsfd
X-Rspamd-Queue-Id: 6F024A0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777231890-643959
X-HE-Meta: U2FsdGVkX18qxPYEYfjGM1gVoQnuCUHTJSg7BeuzH0gdpdJ7RZ3UvVJxS3ibZZ2XOJx7UkowgWrgx2cbFvY/33y1Ow+N0++FJH9A4cuGDu/SD+uxMvp3Af7OYcsbkl9ZFkfpqV/lwj5s/ZDcGq/KigU49Mj4xKjn3nxsF4SOof21emd9VHtwdH6SpY4D6VIpRrLDQHy4FuP4zgGqh6JAGhYMqVGKyz+z5ACla2qYuAcezaz++S0gj5vw7qpuRq8IX1MpmqgSyyx353PD1cxAews/CZ+op3L7wcX0dLHK2HwK3QBZwRNwdB6PHKdm8w5yC7ux0q+iAqYTWHpQIWgyU1TzQ/Xv6Za2f1A/JLjT8A/C8ncZ9Dmm+45HM4/7Mx8SPOFCHuD3491+N7ifzarfN7NWgpONJDzaPgBkOIWVof5elfRjSXHnk8GUtNRecVYgVaJbI41UE4P07OGveB6r4p/RVWpRnfv9p/+fIYHzxmDGHLA7E80aHXEikqr5A/qKQtj6h8cqPKUWxiS+q105twa4JJQ7AShS+Y1F/L1CKjgI03tH5L+Z8pvv4udQ/2lQ2FMQCZISjV1F6HavZqKREG2tMyj+lJ6jYfPuVnCGErl3YouviX58FSZHd9PIQ5GHWKbnkCEEY26FCzkUFbveMwp38NGxBTjuCaZotOe8btQ4inA6R5zUNCSLiFAtLBNOD22HTHjEtCiwXOOLuQ8x4zmfmNZwM9D639jFSuuUhxEVvcUbTaSSXqG6f0dwb5rd6sTAKFgOLAjzpiI1+d7LuD3PkpLolELwskuhvI/WTxG7XzrJv2mHhoWgKXHcPzAQTZxQHrZUEGXBDsD2ISKLkEwzMV3KWatBvGR3mLuRK4r2qWUgjU0GY1dsEHnU6pdrJdf00JU3PdeJyhwE60eQSOzrJMB1/dLhV24VYtUcwWTTpQt3KCakfjwEuP9zr2r840mSbsk5dQXFsc6cPv7
 i4EFecVk
 coSW2J5fLo9xSKDunvIFqwedDJ87CCgJVSP9IFq7kqWq5dUs3hixEHP+K2P3K40fjnVGhvTRCPAXyKajJhCWqmAVoqELxyr2jU4WC5FRr9K9nYvfcGsRMXNm3L44Bra95QUJe7Uu51nUx/hOMWe5sjL0F2yE7N3VH9cg7MuWXGZ3SZXszihHnb0bM0egEp5YBtxVo/VxdmfF1bWMDnaiWNdFhxQ02qyi0OClPtP1BFOdF9+KHn5pUtCYyQw8L1CCiHz2XcifZic6HRgh1BEQGHdjPiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The print format is wrongly marking sz_applied as sz_tried.  Fix it.

Fixes: 804c26b961da ("mm/damon/core: add trace point for damos stat per apply interval")
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/trace/events/damon.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
index 24fc402ab3c85..7e25f4469b81b 100644
--- a/include/trace/events/damon.h
+++ b/include/trace/events/damon.h
@@ -41,7 +41,7 @@ TRACE_EVENT(damos_stat_after_apply_interval,
 	),
 
 	TP_printk("ctx_idx=%u scheme_idx=%u nr_tried=%lu sz_tried=%lu "
-			"nr_applied=%lu sz_tried=%lu sz_ops_filter_passed=%lu "
+			"nr_applied=%lu sz_applied=%lu sz_ops_filter_passed=%lu "
 			"qt_exceeds=%lu nr_snapshots=%lu",
 			__entry->context_idx, __entry->scheme_idx,
 			__entry->nr_tried, __entry->sz_tried,

base-commit: 2e98f54b5a2b874905c71f3bc40eb8c0e8e757f0
-- 
2.47.3

