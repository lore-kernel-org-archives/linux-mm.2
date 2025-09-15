Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8FA1CAC587
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 01:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3C318E000E; Sun, 14 Sep 2025 21:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9F848E000D; Sun, 14 Sep 2025 21:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC91F8E000E; Sun, 14 Sep 2025 21:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A0EBC8E000D
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 21:58:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7680F58CF2
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:58:20 +0000 (UTC)
X-FDA: 83889824760.28.6AAA93C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D77EB20005
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:58:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G5MLt3OX;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757901499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1D3hbdJYJfsknkSAR9wXsM98cd70RvwaSyDi3uD9E58=;
	b=BhNritt+mFMRX3o9U/0KuILqcEkt6VV7cpu1rtvsl9ewc+h6ZvIzxpfyGSKpTfQ0ndMHnU
	hlZ/F27L7b5D0iRf8xG4agK8secW0+htsBgCoP/5q7GsXuYOpRx+3CCXZNHTd2ak1cG5cF
	8fSKNX+nCWXk+BFElZPziv6zDjiqpAM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G5MLt3OX;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757901499; a=rsa-sha256;
	cv=none;
	b=1RboF/w3avqV8/Rjrl2XwS8JAaDC2mgpzTtO7pqpFNLi3JZxm2gokeHp1Jk7yDNrnlyTbQ
	jZ8MoRBSb5M9mWT/9lP4R1rLpLBYfYFEimFImscy7dzalBJ+zAVew2ijH8GD5B7Sv2vRdB
	U9PlMjskSKOvAZIs80e4oDgfbayuSRk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D70534443A;
	Mon, 15 Sep 2025 01:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4D1C4CEF0;
	Mon, 15 Sep 2025 01:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757901497;
	bh=DAVCpI32krZKX7tAL5BJ72tG+a8Y+Yz9N/KNa3xRsxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5MLt3OXROpxw7J/b2AaPOt6R/868NrvNrr1mvdCZr7cI5wc6vhu0FGpNglEiz3f9
	 xTYFFjKsXM6lKnhvnnl1Pw5AA/4ExAJ0pEPn8E0oKcW/eTRFr4y/pGWMDtx2vSP02t
	 B/KhoKiWrPb2qtEYa1vX23oRqcBUEKMFPyQ9D4d56J6s31Sy9aGvCx0XJ9IrTByv0X
	 mc1KNcJ8ho6ByaGYL+J33n6qqth7KPs0VNSGTStEHeIs0NrXiyHPE64sf//xtzAb9F
	 n1ESaGXEsqVz+McdvMeZ4yXeqrY80RxDM37WhgogzrzgD/bi+6oSE/ar49zJ754zzB
	 wLOwGmZDi4+WA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/6] Docs/admin-guide/mm/damon/start: add --target_pid to DAMOS example command
Date: Sun, 14 Sep 2025 18:58:06 -0700
Message-Id: <20250915015807.101505-6-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250915015807.101505-1-sj@kernel.org>
References: <20250915015807.101505-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gf4bssyrcfzu8mjmofztpi6zbkkcz1cc
X-Rspam-User: 
X-Rspamd-Queue-Id: D77EB20005
X-Rspamd-Server: rspam04
X-HE-Tag: 1757901498-261451
X-HE-Meta: U2FsdGVkX1841J6gbsf9kCp/QxOirMDDDMolndGR0y4N9Ua1UhCJ4vNwIknwuO03Ume4wKjbN+o2bAllmCVjOKVDIEF8+IODBDxI2HAShQoiD8aiXubbI9iEUP2xjVzpmXeEhdHrXwMw4n9BCfw7Wh6M6dlI/EG4uQScUs95HW+VapSfqWhulpJZ5Fp8N/zghvxWgQSCYI0BNO4nd6OddG9GR8EVlaS7W5dsJDVcqUMhoiUxpezBNGlNNhs20RAIe6X3UwH2GQkzZ16Yci5mX2sMg7n+c4DhUBNCswEsqT+EMYOTa1LBpDdBfEc4jozHDvsmE9Asst0MBshYmrKn5kkgfjcaAy2teMMpGo1s/daC9z/dyLKkkzFImkp42v7emM+J0vBIUG4GK7YD4sRKHscN+d5JIDTALc8bCuJvuDN/rCN5NKRdrdlf0U9gOYlNTWZoGCwIIxKHc4DebiYPRUCWuibOXEoCBqroQ8+U5g5yZfIex26Dsy/akbtsuRdaOf2NJIzZLctB62Ia39DX0exX8kKhkA0Z8KCVBf8fnYEy5O/fyk8PcKz1q4wU32co2eCRZyIpammb4hWZCumkIh2M7V84K2fNw1YAPRsWJ/xHX9oAq6XqriKN5aCAK6QGt5Gog+bdqvspDD+Ek33V8KCR71nqxdBfSys8HmpItRvQtmyU12g5FuiDnykbww283GpSZW0hxKCxfheHXHfDdQ66GnHb71E/WHZtu5OGAqAX8F6+JZh+Sa0CdEv5xqrFo+X01EG6qHC8itlgx9GM1qr8DPj6yd8qz6d0Eal9Dhx3JLokuQc2yb+07VPmLf6LYQCdG3oGrIsypOcSTXuuOooY1B2s4lLXYtCWL3P/VFy0yYgtjJZAQuc1n6HQ68dTZa7SaIvv+OfC6yA9fUVGeVHIPQWUxoFX5qcqjOiXVcBR3d7pt5AqXjmMYoh8dZ+0hgVnzURdW+OCoHspYWh
 uWnQ2jtM
 +jRAJCbfBP6JjlSjmEGEtGiu2dPXMwNmkK0P+BPH/CSTQDqBwtk5/MvJMq0k7HpyGiqvWuWgbxpSP/adMWQs1iIvzKkmAPumdVk22RLnopFsVBKHw43DtkVDJzLiHaMCbpKnJnq1O4JfrJyYpBLBEyCbDR2DGYIbvLWQ7czRkdfDWUBh3EdYjX8tiPGnNL4L9P3Fh7u+hsg4NM9KHuKnhBXVa8UyaF31FUud9nAbXwvs+LvxS997ge1+jIFB1Y7BxlrlJWAJl/7sgr0X4YaoWF5HY8BAf4pPOymC/1cv4qE3Lg422kfhCOxYwTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The example command doesn't work [1] on the latest DAMON user-space
tool, since --damos_action option is updated to receive multiple
arguments, and hence cannot know if the final argument is for deductible
monitoring target or an argument for --damos_action option.  Add
--target_pid option to let damo understand it is for target pid.

[1] https://github.com/damonitor/damo/pull/32

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/start.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/start.rst b/Documentation/admin-guide/mm/damon/start.rst
index ede14b679d02..ec8c34b2d32f 100644
--- a/Documentation/admin-guide/mm/damon/start.rst
+++ b/Documentation/admin-guide/mm/damon/start.rst
@@ -175,4 +175,4 @@ Below command makes every memory region of size >=4K that has not accessed for
 
     $ sudo damo start --damos_access_rate 0 0 --damos_sz_region 4K max \
                       --damos_age 60s max --damos_action pageout \
-                      <pid of your workload>
+                      --target_pid <pid of your workload>
-- 
2.39.5

