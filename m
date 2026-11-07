Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 843A2606A32D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z2DnN9FQ
Received: by kanga.kvack.org (Postfix)
	id AE5676B05C7; Sat,  7 Nov 2026 17:48:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A96276B05CE; Sat,  7 Nov 2026 17:48:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ABFF6B05CF; Sat,  7 Nov 2026 17:48:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D8D06B05C7
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:48:17 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FF431C3BE4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:48:16 +0000 (UTC)
X-FDA: 85409812992.30.8CA13A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id C640A160003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:48:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z2DnN9FQ;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794091694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5j7HhXnzELbkFkJqEZQNTDWxIhKaeKvJLsv/O41RlA=;
	b=Uj5TPLxuYeu9S9P9Xb0C3LIBcC3Z7HzBr809uGiwNe08hEJ2gKrBV2EsPZ2/XFZF0d5tff
	sGw+lQW1S79ceRX+EyGnq+DiOX6kKgfKSf5sJYJPZXj9aoowoWkYbUIHpmAxZEgTMIc8Mz
	F+vW2sZX8mRvrrY1rjMUcPlDnBzjXtA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794091694;
	b=J9SwMxHPXQQaoSaoBgu7KsYTy8L0ISKxbtEv+bJQje1HHx3zqRoP4qQUctUF/xgc/DAhHj
	/SRwYqX5mddDHrgCSrSPSLzGy8hG+X6aR18z/JC71BbZaav7BJnNHs+1Em5lKe3eNRZfGw
	5hccevwR4HzCjs/hF46741EOt+rVAoM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z2DnN9FQ;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 600026126F;
	Sat,  7 Nov 2026 22:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97591F008A1;
	Sat,  7 Nov 2026 22:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794091694;
	bh=Z5j7HhXnzELbkFkJqEZQNTDWxIhKaeKvJLsv/O41RlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z2DnN9FQ/pONrpfmYqdsyadnC5aGPtVXxJDblg/cLi22vodpsA39uT285qpPCtkEf
	 t8z1UcPayk6eXHiM30oSoskX1Wpmec2l6JudAx+tFqrot2gNRvnMqZ6aXY1wT0q+4z
	 LUbGrWu4KcRkeFtbUXgLrHgIxFLhe0onBex8+Ov5cRNg3Wb7nm2R1h5yzObEfKyjWJ
	 ye/UmpNJFnsa3Cms1EGXt+cCMS6N5AYo6GRDh70btIaRB6fpummEYhWZ34nldZoeFQ
	 mV1QaeZvuSCI6u0ftfK17OigkxV+zy8trlgG2CIMbi/6LKgrKdDOcHSdmcbgCOM3yS
	 Z/S7v5GANMagQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.1.y 2/2] mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Sat,  7 Nov 2026 14:47:59 -0800
Message-ID: <20261107224800.340250-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107224800.340250-1-sj@kernel.org>
References: <20261107224800.340250-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 6hncykuffkkxitkehe1egc1fc5nciuig
X-Rspamd-Queue-Id: C640A160003
X-Rspam-User: 
X-HE-Tag: 1794091694-99873
X-HE-Meta: U2FsdGVkX1+sJShrRfGU4ff71r9up3Divg04dpdiXt2i4zkTT7O9jdnYAQfWAIVzk4y7+jX/K+/zuLP6uV+qwsUSHM6GeyPanNhLcr7+VkO7+upCb3HR2/EdNKdWMuAmDYvNsJzXj52dGtii7Pf5fLKghWVaMdID3N6kyRUnP/YD4xrO5zZ/OEfvzHybqfE4jbas0BBAavMh8Ns6A583uQ8/OYImK6I40YSw/GYkqM27ynylqyIwNF+lhCeBZTea5Q1if4NFL6SeOPBTrgBHepqfNkUJdsUT1ZC9AKM6C2MkMJEavIjlzNd/DI9vJ4kXcI+3bBYYxGMtPi88DLZJ6eV9Qs00S5kLg1ojaysDQp6DjZkzmQG11wgvHOc1yyFmj2Ol6S8qMDLmo4uAq7CIb5TOx/4YE3dklhtQbNWXsl7hqNXBrKGU2uxaxCSlu/U7S3KTYrHbr3BfbebmRAFFgWcd+prKbwZSabzyGm3JoJojOxm45DdlZZm6DB8y3EafYiy4xWZQwvRBiMXXJTt6JHSWZcpyxW3kNUDZKdSLio95L1JM2RzWrN0EYOgeIVRgzFs5nU54PfbvW2Z8OSHK8VeydRr3cJFjErbODNohRfoZ3LXwPqZ5osK4fKu0o9zxkQJFwZIH3qNKrE2cecsb2uaVVBHxrs9AMem1MM6icMKz9UPjaeCvFvgcAWju06yW+JhIJhEqRLX5SCZZVc5OBMKRgfEinYttrHrtj7KjAcsDENIIeo1UkPIv5IAk2tEkKBOesSAcbX2r1IM090hR6FZJB4xz3US8MF/3IqDdCKwl3e6sX4NjWdauLkdn9ZxVtDnACOdUoi9XDA/eZidvGprhJ6K652+7QGaJbRMIy/L3BHujHI4F2s0zR3urtKxns/81uhbp5kYaAMyyn7CQP6NfxDXstkuGAJK5Edt6FMLwej5p3rJapPzrOzzMJzpvA4mAUEVoOaN91u9ZLNw
 InTat7WM
 pd9GZ/lDJ9+TGeIe3dAuZwBO4r06cbcFAVvSS+OKbb+2uuFk8gAkK9kxspyVyjUM7QBojMXHoXOOIdiy07Dc0vXXnSejOPsXiU6HNlBROq4RA5OwgDXHqexGnmTwpcdj/Zall+/9lZi9qg48yNlkocyEB1o966+I4AytdbetxQlCF8j18mHCFdzvZOajbiDiEfFYi06xsrXvMybOh2GRfNjdBOj3Fk/UC2n2GM5eLcBhLB1riRnZ4MW0FoKOM8rAEx3ifzBUPIQtpxQQTa1AuqUFJ2c+SXJW7rDyETrxXryIbvLfgWl1fZDF6aUhwcYm9CBDDK9UBU2Tt8BO3jU0Nga6Y4pP1P6PekbGApd/vEE5prilv2eDi8WAfXNaaSUTeyvJbn62xRU5qpqM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damos_quota->charge_{target,addr}_from saves the target and region the
scheme's quota limit is reached.  damos_skip_charged_region() skips the
target and regions before the point.  The target that was assigned to
charge_target_from could be dynamically removed from the context by the
runtime parameters update (aka commit) feature.  In this case,
damos_skip_charged_region() cannot find if the point is passed or not,
so the scheme is effectively disabled.

Similarly, the user could also remove all the regions of the target
using the runtime parameters update feature.  It would be uncommon to do
that, but it is a supported feature.  Because the skip pointer detection
logic (damos_skip_charged_region()) works for each region of targets,
this result in the logic is entirely skipped and the scheme is
effectively disabled again.

The user impact is that the DAMOS scheme could suddenly stop working
under certain uses of the runtime parameters update feature.  It could
surprise users. No crash or leak happens though.  Users could also
simply work around by re-installing the scheme.

Catch the corner cases in damos_adjust_quota() and reset the pointers.

Link: https://lore.kernel.org/20261020023958.108276-1-sj@kernel.org
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-cd0c55fc-0cc8-45d8-9637-3334811c49b8
Cc: <stable@vger.kernel.org> # 5.19.x
(cherry picked from commit 5695abc4e742b947f586bfb6a080a80ad9957e5d)
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9206737d05ae7..01f93146b92fe 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -860,6 +860,26 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 	quota->esz = esz;
 }
 
+static void damos_fix_stale_charge_pointers(struct damon_ctx *c,
+		struct damos *s)
+{
+	struct damos_quota *quota;
+	struct damon_target *t;
+
+	quota = &s->quota;
+	if (!quota->charge_target_from)
+		return;
+	damon_for_each_target(t, c) {
+		if (t == quota->charge_target_from) {
+			if (damon_nr_regions(t) > 0)
+				return;
+			break;
+		}
+	}
+	quota->charge_target_from = NULL;
+	quota->charge_addr_from = 0;
+}
+
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
@@ -890,6 +910,8 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 			damos_set_effective_quota(quota);
 		}
 
+		damos_fix_stale_charge_pointers(c, s);
+
 		if (!c->ops.get_scheme_score)
 			continue;
 
-- 
2.47.3

