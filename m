Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0237460A2607
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tychen.cc header.i=@tychen.cc header.a=rsa-sha256 header.s=spacemail header.b=YFbaSadU
Received: by kanga.kvack.org (Postfix)
	id 27D286B05C2; Fri, 20 Nov 2026 05:33:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255AB6B05C7; Fri, 20 Nov 2026 05:33:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16B1D6B05C8; Fri, 20 Nov 2026 05:33:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E13086B05C2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:33:30 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE88CA0EA2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:33:28 +0000 (UTC)
X-FDA: 85455135696.15.2EBAF45
Received: from out-utut-a206.jellyfish.systems (out-utut-a206.jellyfish.systems [198.177.127.206])
	by imf23.hostedemail.com (Postfix) with ESMTP id 87C2F140002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:33:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=YFbaSadU;
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf23.hostedemail.com: domain of hi@tychen.cc designates 198.177.127.206 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170807;
	b=DX1JQN8PBTykvH/7vEpzu8ZWvUTR4sHbMDMOW+Fx7/hT36sK0UndT+DnrKczL2h0R8dQe+
	tf8p9IO+CrukY7mwi8pfLHFSPU+HhdHpKdQKk6upXzYk8s479WHmp9okt5a8oEs8y0MT0H
	83pAagXEV4a33uiebxvR8deV5GGdS+k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KCPw+q5p4Yyf7FYw3qSmU12ZFK/LfmJwMcs22RlGgSU=;
	b=4Avaxu/gklI4IK6jdPGLW9CIwxhpXxl0Kskg6mn4784MTIgTyH9dCmgFP4k2cAnmCfJSYJ
	L0VeeKhn9bh84gPiB+bfSqPwKzS4g2xUnl+l23lbyt6P5lQHlO53hoHwbxHK6jpx4zVijX
	6C2nmTYQc0nYnc7b95GjUdp6nonyfms=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=YFbaSadU;
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf23.hostedemail.com: domain of hi@tychen.cc designates 198.177.127.206 as permitted sender) smtp.mailfrom=hi@tychen.cc
Received: from fedora (unknown [151.145.76.168])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4jWBVx0MHhz6tkK;
	Fri, 20 Nov 2026 10:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1795170791;
	bh=KCPw+q5p4Yyf7FYw3qSmU12ZFK/LfmJwMcs22RlGgSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFbaSadUIfqinCT95kZ4vNNrDGlY8vKSJxbuwUfzAAoiputof8HA2RVaXoC24tEdu
	 L6VK9zfchBxb9JVZCwD9ZjBuiQMO/6jcAeMMhB8eSCDsJp8PGQZJ664Ab9uctX62X0
	 PerJeDVirnbZBZqeso2rTWsFBfn7KlHST3oqX5thjoS0ZHNW07mF830vgIEN/qnFBb
	 yWj2Jv66UGZOpHZZgbKZ7KrdBX5Hs46yB3xrguNhRa37nP9hCOj8PyZoZZTCru8zhH
	 zUO0wgqxBsGQZVmWwuhFp8NexiSObO2miUzVbBYkPDiUP8YacQfdfIo+WYQ8Fmkhtn
	 rznaeIGJo1lSw==
From: Tianyi Chen <hi@tychen.cc>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	SJ Park <sj@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Xiang Liu <liuxiang.277@bytedance.com>,
	Ehab Ababneh <ehab.ababneh@intel.com>,
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
	Lian Wang <lianux.mm@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Hui Zhu <hui.zhu@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	Maxim Muzafarov <maxmuzaf@gmail.com>,
	hi@tychen.cc
Subject: Re: [PATCH v5 00/17] mm/mglru: frequency guided promotion (MGLRU-FG)
Date: Fri, 20 Nov 2026 19:32:50 +0900
Message-ID: <20261120103250.1241429-1-hi@tychen.cc>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <CAMgjq7Dnjsq4vid7H4usOB4f5AS8XzhG75mvf4-Y=an95gBERw@mail.gmail.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119112357.275352-1-hi@tychen.cc> <CAMgjq7Dnjsq4vid7H4usOB4f5AS8XzhG75mvf4-Y=an95gBERw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspam-User:
X-Rspamd-Queue-Id: 87C2F140002
X-Stat-Signature: 76c13oczm3z8snajj4gt8ekq8333h6rw
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795170806-828213
X-HE-Meta: U2FsdGVkX18AMY2vpEkCK2Re0oXGjCqLapi6hnT1n9jLUvZIOjHoIWkwF3C0i3sTpxzDAbz31EwOIK9eozK485i4+7HkufUggcSrz5ZqAAzoJsCJMM8vPfeWnbjNVUTbjY3gigbdWSRf8+qGrZqcZiLse0ra2q9M8yFebW3aOp47YobB6cNfWsBgsaAKCjMKCBgIlqUtBWI3POc8K2lFeFM8JYke2CGLk+0Bw+oHZvEgQzunnJVukPoA4UNRu4deLEVR6Uo6SGIBIDV3aQ6lkawp/OeFSemZUI+7JrCkxPNvGlNyFxQ3TdOMs9MrNKR4GVBtUWDuYRcOx23EGKu7h8wPFHzlnwRTRf0X14D3tennoyJhrtVEAh79NIZVG0vLi2AsKm/eMtFyPgC83/y7AAm/ZOOwNfqfe00GD7HcO6cwGzz4F2VVaumi48QrUeHaJ91n5Gm6H2ZY1PtvQwLgZ3fEcEj20yZ205dMSvo0JmeowSCMGur0W8q2Ooy68LLsalbUyOvQMU+x/dAYVnnH/OCAY0T1LwjCmN8B51vowYy72JTbiIO1k6Oq2W76mS70Gzim+jYxZbOHlnuTgCTOmHO3qHiN4jKD4bEPOXXZ8zc0MrCU+lcLoF3VhIwXBthySyW1hAhepOHTUqGbEpPjvoTBQCLpDLWYRFTCLYjXbkvl6MZsg5QoThG9I1X6wO/7f48Gy3RWa/eAHLKAcv6qrSyas0Wxayak51j6jjxYqlmkHFZVMEr34sxMJxekPOA6iSMeF64TqReq6RqFaATU4tZ/R3XWt90OGOkZAGt5AlsaQ1TP25IpPnbzl/vOI4I6pp+a/i/5LLjugdbi7/AhAgnzQDFYh3FknRr1/w5a0es9jT//V+vwaq6QD7K4jNTlMZatsYW/f6XOIxzEk+nnGS051F2HFL9UH7WN6+IGtbAlsf2SxiF2S/1D8KIRkpZXavXFHLudiKkxckm5ZzD
 NfYi1m3i
 RIgxziTUquWsDQ0F7xIylztJ/IpZ4V4/3ilQfSEINss/n2Sy0aZCuf2sN0Cizd6lgLoutySVQ+Lho5eGSGvqS+1oiVNOcpVqIV62KVrLntkby7dYY6pigFn+Qf7O91mTr3H3S2KP6ScGUwZuQqhFB5n2tXYtcaUi43a+irRsGv7qqOPWfE/8EHkZ1Cdm7S+RZe4DChUoK8YrUV3UoNPy0b79JbhNARTNfugEfHxHY9eXB0VtduZp0VOppv7xin1HpJUNUpwgRXFTtmOClP7DCz+ExKBoGe2Li2TQbbiSl6ouu9RNYGGel5rs8zDcI8oz6F3i0V4l8JiaHuPRW2g0MShhM6s2nWfOSMy/hOnZaVHKxHYlinWNZEtrz23oZr0WE2MOxRYYoHfm97W6t6wkeaxDHRKhAnVAYn7mUNujbBuH8gLSIS41EI+3G4lwodteyExOkCb1gx8UgdP1J6wkaWEIzRD9Ca8eu5fxIEE8PpISbMXO5T9EsB4YwdHjgsShwQDyNdMl/QWhXU2jcP1mQg6oiYJHdGA3DDcyA5LYoLMjzsQLfIi0I87OQrdDabMor8Hcsd90aQljGZAQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 01:33:32AM +0800, Kairui Song wrote:
> Thanks! That's good news.
[...]
> FG still doesn't track MADV_RANDOM accesses though, and still no
> proactive workingset shift protection. Refault distance will cover the
> rest including Maxim's case IIUC, as demonstrated before, it's better
> to do that later as it fits much better with FG merged first.

Thanks. Feel free to add, for the whole series as tested above
(the OpenSearch k-NN test, on 25fee5b1762b):

Tested-by: Tianyi Chen <hi@tychen.cc>

I'll rerun it on the refault distance series once it's posted.

Tianyi

