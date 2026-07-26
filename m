Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9119C531FA
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 01:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E4CB6B008A; Sat, 25 Jul 2026 21:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 647046B008C; Sat, 25 Jul 2026 21:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 583E66B0092; Sat, 25 Jul 2026 21:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BBE96B008A
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:30:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7CD7D40436
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 01:30:01 +0000 (UTC)
X-FDA: 85029196602.02.EAE271F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D708F80002
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 01:29:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ULsCowlT;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785029399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3pRRG3K7S6YtKl2WqEHDfcoPnCFtKvVlvjr+gl6TKw=;
	b=eL8frT4m1FPpU7Vledl89yO93RVAaOjH66C7Fla6ojtZAiM3yqwlEeWmjeJ9X7c70nKlH2
	8JOBV7NKRsHgr25BIh4y3PMMkm+dQhgH4b40AzaKfO9qI9CVVUd84Cnoa+8HOFHqrtvU38
	URe5wLH685DXzrsoHw7Rlb/6OX2A7oI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ULsCowlT;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785029399;
	b=C86pyfkbG2XF93Nfe1OojgUao5H6f5WtEuKYiBfCDvMzCPcvEQBw+TIpVHe5uxiyUK7+Tg
	BKW/gK9xppgeQlF6howUHFCUKRw6lzqApfA/GxZ/71rcGe88JyjkycMXFrhMeVDWCUi5DY
	JaCSl1hKh7+VfSGrXWO4gr1b1P1Q7YI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 35DAE4056E;
	Sun, 26 Jul 2026 01:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466CA1F000E9;
	Sun, 26 Jul 2026 01:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785029399;
	bh=b3pRRG3K7S6YtKl2WqEHDfcoPnCFtKvVlvjr+gl6TKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ULsCowlTGKT7KW+wQQRN4qtCy3SRG/u243dxUHDYOkuGLQWFS5qfFbgi8+WpKhFik
	 xwsJZdIaH3TU+Ao2P4IjFh1lj/siNkyyR1BtCa4c/Aa13r4O7GWfNpmJpqA5acbL7Y
	 kDsBPIl6GA+XkHMihvZndhnbyNgfGCCrK5hkpp44MbDYnXQ3bzDv/usGip0f+trycm
	 GLMrhnXswQCbSrfLfvmKTlDYIaTp0jULhC1qAAny71UO7/L9PIRoSG3IxNzohfMKiD
	 /VpxB7fYD0G9hEgb+roat96z+YDIvXjl5agg+KG9VTkLeCrXL0S4Q0EWoqyp+Fy6MP
	 wZe/b0WBXHm1A==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	linux-kernel@vger.kernel.org,
	lyugaofei@xiaomi.com,
	stevensd@chromium.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH 2/4] mm: mglru: do try_to_inc_min_seq if scanned==0
Date: Sun, 26 Jul 2026 09:29:44 +0800
Message-Id: <20260726012946.18684-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260726012946.18684-1-baohua@kernel.org>
References: <20260726012946.18684-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D708F80002
X-Rspamd-Server: rspam01
X-Stat-Signature: k9ch5ft76qdnkafr9npg5fy9ctpcga4t
X-HE-Tag: 1785029399-209909
X-HE-Meta: U2FsdGVkX1+bBrGZeQ9zeMBo5oINVRkj9uek3Y6poArOx5N4aTj60pE9OiUhJHC+zmbSoMjsY38F5zbpfaGDGix7Vk+NQ2tqqgkvrszAcSiRcu8z281qje+E7D7KtPABKroW/qrqF0q1etWlW+ohnomhBg/QhJyabdvNYnk1jHd9CU7kcsMdVQ0mipqKPwWQ90xO3i9Jw0elxwgNiaw4dEUMxctAVO/GwCnYMlllkftZJjX5/MdWC85uSUcHAYkmWrKerkP0qxs0cvp0TlD6nBrCNwlkEGXe+bF5M+UQK0FE2W1dWMQuW5cPh4z21dlIakWAnh6ezs/fPn9KuEk6oQetjlCf6N0nDVzn3xev4VMo9JLGMDNof/CS8UCgDGx5BM41B1EFOwX6xy2UqerqfnzUnFDs9gwfE5754jrC9drKvp/4aOJbI1OF0ZvetWxZFRGtvC+o3/XUfs9nDeNwzz90lQlU0J8909suTfvyqTmRuTVOx0XvbVGgq2y0CR7KHWINF4hi/GABwXFLaiyoWJ9sWI3YVTGjc98UJoXF3yZwEJTlznzMOa2+7Dy3qjfTBALHAua6W1I4erdWjtNpGOcnf6vZSHVOODspzAggaYvqX7eFJmF/k6uS+6Be80IRcHh9DWNBITSwL4zX1gz1QLSUHZXEQkOkIFqJJLTs3eeuvNVvZc5Fg98wlouI/q1MEqvBz0k4QwO39HUwJJTL6d4oVw657ErgOnAXqhFRljKIo5L0E86UtdrpdWk5333qd4aH+xW6IRvRXIGEhNvwvqUjYg6TpeyMzkmsMyT9MfZWg+lARdxArTbEgC7OCMc4gUDvqaJtMQcv1s9khLAb8+tVBQvuf6svqtOSq4dCFZmHCmLaxS8JlnKufhBYWwiLe8v9VkqsPG+cTeKKeiiQzXp5G3WMEo8mpRH8DtZhyuzyBrGVw/K0O94vb38cpJxWCo10D95cwKkurRPMAM4
 my7onUXx
 gLxBFGltkHEafeskNBLRv4n3ObTUmEL4hhE8l9iuQMTGN3/oSoLvrVH1SMMJx8cWMI5oUcKqWv0XhtGOimPilYmVkyFJH3MQ8BPgt9h8pZiHQ3hTwh4AZiDw4PW3B09xDmTIDujmlGZ61QxE5QgljwqLeEeYuycYFfzWUCAlvimLyoffz+TzPzGWplCL4oQOmps+E0ixMOwfOOa38UHjGi7pygHHYaYVNy5i2DT+KbJhc7JbslP8qkRZX5mn0aOScRutirE0iEVbOCgZqgo+ctRiBfV1Zkwgp9DZ6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If scanned == 0, we are likely running out of folios in the
reclaimable gens. Advance min_seq to keep it in sync with the
current reclaimable state.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f79402760776..4f3a375de86e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4858,6 +4858,7 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		 * Only fall back when reclaim is running at high priority.
 		 */
 		if (!scanned) {
+			try_to_inc_min_seq(lruvec, swappiness);
 			if (!sc->priority)
 				type = !type;
 		}
-- 
2.39.3 (Apple Git-146)


