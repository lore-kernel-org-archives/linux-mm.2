Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1F8DD2ECEF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 301626B030A; Mon, 19 Jan 2026 18:01:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CF126B030C; Mon, 19 Jan 2026 18:01:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FB926B030D; Mon, 19 Jan 2026 18:01:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0E8796B030A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:01:52 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BE4648B07B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:01:51 +0000 (UTC)
X-FDA: 84350237622.26.3F22871
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 179AA40012
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:01:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ty14IhFY;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7tXOMpSvTNAehyXPE87lP43EUeW8U2886S35Q+iVnQ=;
	b=OXmt5MulFNxvISsUfvEDU/gJNCKi/DqSa+mVWC6/OxULVLSRZoFKRdPOptEC+fvMTTsxs9
	EIvXkjJZJIqFtWOx8Dv+Cg37lIU0pk5LXltqcikM1OBXZX7QAab+Bfeg3D0RFrPxMnqSrb
	ZChXaEi+XQTUgwIr6klfiQMdwhVwdks=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ty14IhFY;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863710; a=rsa-sha256;
	cv=none;
	b=b5t1UKcMZe4KgwiAsI9AZz7kOIDQ8hAjh1zPfkekb48OouAsLfSROZEBW1RJIQCtGgFiIZ
	RViiQ+QWX/8+KxlAThy43Lyhlu3rBN6XQPjTU1rpNoRurH82E/lG3MURwJe8Jq6dQhUj1j
	ZVowpp8Brvjuh1Yp6bzBhoOoEJwDaRo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A90160151;
	Mon, 19 Jan 2026 23:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531E9C19423;
	Mon, 19 Jan 2026 23:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863709;
	bh=luihl3MbyU6omYSiSWj4BOo3mmNqgAivFPTCpm64S5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ty14IhFYRg1l/2Ez+3EIhcGA92inZASN9By1yGWpfoCYQQoaXhF9GeSHpXh/4o7wh
	 rv2jd1KqUv7sxbQENf3+a93+kiHs6Pt5G9xfUtig2LlyAvg5fqgjrRlYOU451DxdQV
	 xFS/6MQL9QO4d/tcIUcQUVkk5Ga5MkYY1UtDOLULiGw7WY4N60Pad45nIyjD3Ohaa7
	 1u8b3HPjwXFqvexE1sUgx5Pa9UxBfNk4UNre7uxGAjjqz0uqzNWWM+n6+PIJW/KZC+
	 PdVBqArgnZb/xbX+khcmpQlrZp1iBBmSTeD10FX6KYq5s943DkILJgOIVYjGLYJiq6
	 qwGIPnllyT+GA==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v3 01/24] vmw_balloon: adjust BALLOON_DEFLATE when deflating while migrating
Date: Tue, 20 Jan 2026 00:01:09 +0100
Message-ID: <20260119230133.3551867-2-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: en8f71cqiofho9ycmd3f7dujr3kax9ja
X-Rspam-User: 
X-Rspamd-Queue-Id: 179AA40012
X-Rspamd-Server: rspam08
X-HE-Tag: 1768863709-759279
X-HE-Meta: U2FsdGVkX19wU7eulufTUvZMNRvpxRW6/RSAOYK2rF+DTjYQDxljCKXhLaUZVFtHwSHJ6mooixE6yA+yM68JwQljAylvIc+a+j8NHvxd/0NwfG6de3KgX2YBDZRUSZfiyUqSGby5kmSY5SnLEtdRdRD8+k2XQ81IOWGFzfBa3KSH7Zs4fUz+lf0GqgCu2tTrXhJGsF8j2KRJQLohfULaotLPcSHhskcCP3kCXY2C0LE+RGsGELZZrHJCetUcrOPL1t+E8k4k8Ec8js9Y1C5rS50WYw6pEgnV6Eol8Q91lYaKvuo5mHW3tOq5eM9VmSsvrXXAzdFqDy2tanCIsyfb00ck0CQt0zNRTLvQfF7d2oi+BHtSLy93IJKkFvJAI9Ga1BAXrdn28bDHsrDgtir8NR+4fxKB0VgHdfgxX+cUvA0rAAdkIbNXPmit70cAH1kEQEgWgmJtd8PEDasGxkgJp7Q+dfmd2Y1OXmvLFZRS/ML2EWXOsuBPxnoRcA3bOYQGPx2MZm7RkF5btI1L42WH+xCVrWvwi/+gwb/Jo1qlpIg/KwQNa6Z39TKbeTPCFNiL8C1YJ5ZaoOmwIUzmzA6hISP3J/BNX/LONCspHGHZTAr43GWHFMirq/WggPH3BA+le8Z3vE+aycxr85aV5mj031uzGVUHGbmQNmpzlxQAm5j4+VE1F1fQ+fwjXEeNIxi6TygpRIJqtMJ1RBLM1o4PDARMKpAEKw11J3TWmvT17GW8lq7ZtiwzurIm66jldwPdFHLw6xuDwB1SEXJy19z+ygHX93A6V2gPGj3FS6ptoytKjuplCd2/ZAaKEJNhoHpqSO8XEE04/GhTlb+QngaF7FJOz6f3zuBGKdXSbuONQOAJUX+9/oY4XlOUIk6yHaiV+RfoZUjcI1chyGavXIuhyO2Wrn9VJ3QiLw1TijK6Yku79AHR7MFvWyeda5dy3DDLdt3Z/HhWo6/U6bBOaKA
 +3OadUWJ
 X6GRk/iBzDBVaHzkGmugKKENMV4MBTelYPnGlJ7XZkoYmhvkLb4UXGt/3eM0DAajj3DwSbPIyRyByuvRPwlKKuawVIt1iukFnFbt6DQ69dD7Pvy8rk2745HmUn9LAPtiHb6urIXeWYvuxP6YfiJlNHkgbZgYHoH3dF4UN+CXjEr5WE268l0Z3if/kAVQOMBI35PRTX1BN1qazmQmGY/lqBmfRew7oFWYYH/hDr7O346WDMtteIeWS1IUZoxWIEvvcXh5NUvFkbmdfQQ3P55jolcVGZ9T9vGlBFxZdr6ewIz9EoNUuvX3zNwzQPIBP9cNjQWJnrQp8Ve7+XhY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we're effectively deflating the balloon while migrating a page
because inflating the new page failed, we're not adjusting
BALLOON_DEFLATE.

Let's do that. This is a preparation for factoring out this handling to
the core code, making it work in a similar way first.

As this (deflating while migrating because of inflation error) is a
corner case that I don't really expect to happen in practice
and the stats are not that crucial, this likely doesn't classify as a fix.

Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 drivers/misc/vmw_balloon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index cc1d18b3df5ca..2cc34c4968fac 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -1818,6 +1818,8 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
 	if (status == VMW_BALLOON_SUCCESS) {
 		balloon_page_insert(&b->b_dev_info, newpage);
 		__count_vm_event(BALLOON_MIGRATE);
+	} else {
+		__count_vm_event(BALLOON_DEFLATE);
 	}
 
 	/*
-- 
2.52.0


