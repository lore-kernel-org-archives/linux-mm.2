Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE2EA606A33A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iGdpvCQ/
Received: by kanga.kvack.org (Postfix)
	id 4DB276B05CB; Sun, 15 Nov 2026 15:29:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2E46B05CC; Sun, 15 Nov 2026 15:29:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EF9C6B05CD; Sun, 15 Nov 2026 15:29:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 09E436B05CB
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:11 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 64423407B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:11 +0000 (UTC)
X-FDA: 85438492902.01.3AE2D9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id CCE5C100003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iGdpvCQ/";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTjjk1bjDwpUg3WWMwzBwOs56rHK1uC/DHx/Q7GkWVo=;
	b=ZDST1hNg8F+uUTIm5WKp3jgqri3GtG4K7grIKvXxltzlklLCY00xFbuZicuSEqJh/b2G7O
	l0/6ttWvZMEC21drIJaItBcteN51OUBWonrrCDrV1WGEUWDtBM5QvpFKNkYcm+T05/wAsw
	rMTFgb+BDUFMrWERUaNEY7KJQfgJMFI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774549;
	b=axl3yW9OMGMOKoXfvDWai+b0mQbkYTHu9z+kY29wMpVKAXmrG1iieTggPj4XvIOfVNBBxw
	UhriorQUUJ9/18kC+VX25eNId/MDx5lsQDby8hb+jRPaLqyA4HEOqNRKZpEzgYGaUBrbim
	+hv0b60qsApfWDHuiyKMcprITWwaE/4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iGdpvCQ/";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 99FA344E89;
	Sun, 15 Nov 2026 20:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596AD1F000C8;
	Sun, 15 Nov 2026 20:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774549;
	bh=FTjjk1bjDwpUg3WWMwzBwOs56rHK1uC/DHx/Q7GkWVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iGdpvCQ/yTW5aKCkDn6KWUTvwimLquIvnuPL1kCchtFEaBfVMAF0ZIU/GZ6F/2zDg
	 rA77nsW6/UE4ZLoJhA1a+TwJy+2RwRO8W3BiduOYjCCsDECEIZAcowQjR+gj9+1ZXw
	 Pa2mvV8R3ciE1KD1N/PZ/zdUwxva0i+W4WuwkAyxsozo798OWzo538br0iOlNcKttG
	 bF//BkSsUOY0IqcycpxoHSbAsUihef6PVNoYC9ENoI9X2q/hNO898JfHebqN18biXw
	 D1v+9Hr6obIJ1RC8x64qGOdl/Jimsl5STYFMOdCXcCFynKOUDPWYJW42ADLMWwbuRH
	 hyTDoGa/aG6YQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 21/27] mm/damon/sysfs: add user_report support for report type input
Date: Sun, 15 Nov 2026 12:28:39 -0800
Message-ID: <20261115202849.99134-22-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: n6gqa5qamwqoh46h89uzdn7qia37p4do
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CCE5C100003
X-Rspam-User: 
X-HE-Tag: 1794774549-666259
X-HE-Meta: U2FsdGVkX1+VsvRflMOf9VW/jOrTb6c6Ax1qnKtgoSCAm9RcqytpzOU5reyXd9Ap1C0lUFQBLcSnJtB/e7xPrZS48gH2j5fSyDY763MJmJoeCROnCQbRcGI6V1iHqUhab6DeGfHfu5qQs9a92NvKRKudrFL0ssLxwIq9Bi7RFh+I4TppM6nCt4dGMPEwZUIX+S+RX7HJGgbpp0NgOrfVyC0Y2xL9X+XGBViE1uB57gjIH86zgNC5eSuKiQz3n901YVUAKGN/4YlYB6Ak6CzlknVZmSMTUkp06uCQZVSDjhy7AmopEEZjq2fux2pk58c+NbP5SDRKyXUu9x1PLoKiZS4fuYm8NyBKnht/YglEb9Et0e5cTowKtsWh9HX+46e6cfd4IJPp7g4bZ5SHcD5tGJtPI015WNPpKayoKvwRsydzsow5C0X3EdsHGP6A62cO8ogn2l9d8z7W6m66Xzmbymm/EXWZH2zK589y5VJTaDZ0v77ZMRbclSIH5bgm1rS9HHvGzfbNlHYCZcZNme6HIzRpJ9JPS+LSy6VoI+ZmNiaVUfrOX7FECEeTdlbGMxijcW+ztg/CWX1wtQydnr/Yn5zOwTJbzw/6TQIpt+NatQHl2INRTkA4M3td/pbVYDC8YLtJnDX6CnEK+dWikZ2VN2rY2YqYG+KTiCRGmtxqkI7Rusms4nGKcoma9AUnkYPBwkpiAH9yKE01DrhU9B9yg3Hp7QAiMYpFQSABif+42SC5y/KJl/6GImydINzkX8LndJ48ebO/7JeoYK3nzMODU8XZ2D/jFXd27tkWb1xD+ls1Vvm/5Y8Ar5YJkaAX8vpofhZRuUTga4rZ+eQnRNdo8zVBOeOMIGYMqQFTGEF+MXSmamGM5Vep7XOZQ+MjwYhgsSzE5lWlR18W+/Uiu7x8n1FIRoKHhEI2kvASbFjq03JDHF99GVCvwSSKR/mGJUMh/1B91Bn6hCNp/pakTfu
 wP7Q+ixr
 OnvBmm7FVh02pEQrgY3dZ3xXWijW7sHhwRdDOG0vtnl3BIOH4U47gT+nqhjfqrZhoLy3ty7LfDjn9vx8/ik96xg8EB44Vg3toCMe9iehSuacZNxcL3dS0rQaK3qtP2egddyHnZrGB/JHKYnaa6MwPhRPrWkezDdCJZ02a2MWpkKEofkXAp8kSbpxPCCRd20va5NviEdOm2hxYhB9T7pYEh2Ai4LNsdksuWD5W5wI25I0ztLrZheltSQQYvELDDVpOrbqDznACwBdKQGYLujrJbfIFMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Extend the mapping list for data attribute report types and user
keywords, for the USER_REPORT report type.  Use "user_report" as the
matching user keyword.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 1c171af4590a8..b4d898ec0c9f7 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1187,6 +1187,10 @@ struct damon_sysfs_report_type_name {
 
 static const struct damon_sysfs_report_type_name
 damon_sysfs_report_type_names[] = {
+	{
+		.type = DAMON_REPORT_TYPE_USER_REPORT,
+		.name = "user_report",
+	},
 };
 
 static ssize_t filter_report_type_show(struct kobject *kobj,
-- 
2.47.3

