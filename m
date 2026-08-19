Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB468C5DF7D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 02:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E95A6B0092; Tue, 18 Aug 2026 22:16:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972846B0093; Tue, 18 Aug 2026 22:16:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889936B0095; Tue, 18 Aug 2026 22:16:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 618356B0092
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:16:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E5AF780375
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:16:25 +0000 (UTC)
X-FDA: 85116404730.21.52893B7
Received: from mta0.migadu.com (out-94.mta0.migadu.com [91.218.175.94])
	by imf16.hostedemail.com (Postfix) with ESMTP id B3DF2180005
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:16:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mIhZ8GMA;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.94 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787105784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QvKv5ZSZx/EJ9qc1HCKx4zU/bQKVI1LSrKt1R1DTBXM=;
	b=pxnJeUokYQcCPCLH/NquTN8LlaRwdcaq3Z14YF0Qi884hFXQRZzHIiIlz6WsYVyz9zZMrS
	L7dmD+PrKKmM+cHBXr1SbwcyMdrJQshzurJ+HwD9TLqJazbdJA8U/msPPoKwMPBa+CqeUb
	6gW2SyVE1g3koM4+g1/x0Kd+Qtu0L4Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787105784;
	b=hDzD9Mzixqw4qH5DHv/Qgg6KNWt1jUfEJI0yYuCpc/9Ayh0tGgXD+VNwZMosHnJVY4Ze5o
	UK4AsDGGmftPE2JCFBqq2Q2ljz5WeQkwtJiStmAkkMkYdeUcqau8NVkeN58w8ZdSx9vrDb
	HqLTvAb6hh7NqgFpUXyOPqdOUXEzwIc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mIhZ8GMA;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.94 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sR4GxnwUvygzIy4Ll7R5HI5CwDGDRQKts4PxllPhnAU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787105780; v=1; x=1787710580;
 b=mIhZ8GMAE6i2gPhFUjScBnoKlrOd+K9afaNpvuyUPV/c82b4gzLEyXlHJUQMtUJz5HbMeb8Q
 xeaLekDa8lH0Sdrdl1U4c7MpWAXv9jtRQAxGs2AEIK5kLBCqyDActNeFx/GaPVVEe2SJvnLj7JE
 p4ic5enRE14MwXiXvslx6Fh8=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 3b6440fd5a123c30;
	Wed, 19 Aug 2026 02:16:20 +0000
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] tools/mm/page_owner_sort: fix --sort option being silently ignored
Date: Wed, 19 Aug 2026 10:16:09 +0800
Message-Id: <20260819021611.2910835-2-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260819021611.2910835-1-ye.liu@linux.dev>
References: <20260819021611.2910835-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 18ymrp6a3yq89ffdxqnefihs7upp4uyk
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B3DF2180005
X-HE-Tag: 1787105783-98485
X-HE-Meta: U2FsdGVkX1/DcUgdQh6QpkE6O7KnLxiBQQqJ3Bf0DRp5kLrUzPW6nlyc9NyR4bL8LHe04zozouMEsynq5gq+4oDLKyV+d/2znK3lFfGs6fkXgonj1Xg+azWpwpmJeBqdnMyS76X2Oq79EDuu48IaSBGl5zN3hovfesHayxe5u8FjzvuHTXL/bV3Ct1Cah5FplQevZikkT5Y2DjhEpkW6JiE0+QypRCWIbYwjAPEwiTok8bvX3CBztwVYPK0/1SUwt3NcMYJqORMLEl1FdXu0Ni17NJmlcLOwkoBm0vqMY6yQChNtvXrFRWmmPzKqiV8Im2ZIjpzpB51snBVMCDdVIRnBzOmBlctCYuotQS5XAHG7ZxDixItaHCBDvgoq8yvFlzjwiEY08L3nwNvpg3/8Lwrtp4F2C+gY0ReFBSyODvBkjtUr8EUFNk/X68WXn1M2yU9PzpwM/fMeiktF3F8YEG07ZFPPvgnQP8EqugSklAmiJdgzktBUSydAFliIyZmd5QkWHnRL2O5mZ4i7OjNdf24Qms/WZxKxwq7kREZGbe0vySYd6R39SCHsC0Oj2XGohwJk326u1/s06P62YZBnkTqnZm1FZhdH2VMY4PW9oPFDn4LbjDMuclCDghdIZlkMDr4zBJWLKDzWmNgYkNgvMpGkdX1e2zinMROUXrqGvCpdWYpjYaakNh6mtU4sOlsCPkM+NodTW2KDddTzt18vl5qBFW1KfblnabaydOcq5WPy2Zgz3MSedvDJ+tJQFqW0d1RIR9WqSZhIqmkFjbJt505mw1OdnnKoYuktyBTfLjr2RiljsT8nsfYYFTVxsrcB3/74TaF8onc0usmVDETNxnvSTXxwAZYQ+zTW2VvMIYq7WGyFNmdbYrSD1Qin89FHzr5J+RIzjw5AkWq56S7xZJ/qvNC/w5m5qEG6OYbYKPbiU4DlZP2k2aYaFnF1pkF9FFW3tXdqbescp7mqLV0
 rUeFQa2B
 o4+LxywBX0fgEhVd9ZchM8tDGAg6q4qGGIuXWQ0tAW/OWbxBv2w8uKg1w4GYdmxTZ0TpH9AYtc7bPzAJF64F2ZFcTs72jIAMulBhHEmw2LXBq5FuiV5ASeWEo3saQi5kxk3EC7rN0LW+KnfXEcJxvIB/UbJOt18BPCE4nlAh4qRi2KOLlN/8lbj5tOJ58EFta0H9kEOb5GPgBmF8F3vOqGlj5D0e+hsWCjefh2TnjKtXCWFJBX0nTagoVmJaYTrESb+D0ofFj3vvLUem3+l5f0FqeLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

When --sort is used without any short option (-a, -m, -p, etc.),
compare_flag remains COMP_NO_FLAG.  The switch (compare_flag) then
falls through to the COMP_NUM case and calls set_single_cmp(), which
unconditionally overwrites the sort conditions that parse_sort_args()
already configured.  This makes --sort silently ineffective unless a
short option is also supplied.

Split COMP_NO_FLAG out of the COMP_NUM fallthrough so that --sort is
respected when no short option is present.

Reproduction:
  # Before fix: ascending order (ignored --sort=-pid)
  ./page_owner_sort --sort=-pid input.txt output.txt
  # After fix: descending order as expected

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 tools/mm/page_owner_sort.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 35d3d254941c..3b957b654f00 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -821,6 +821,9 @@ int main(int argc, char **argv)
 		set_single_cmp(compare_stacktrace, SORT_ASC);
 		break;
 	case COMP_NO_FLAG:
+		if (sc.size > 0)
+			break;
+		/* fallthrough */
 	case COMP_NUM:
 		set_single_cmp(compare_num, SORT_DESC);
 		break;
-- 
2.25.1


