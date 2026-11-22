Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37372606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 07:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ep+qtuk/
Received: by kanga.kvack.org (Postfix)
	id 50DE86B05B1; Sun, 22 Nov 2026 02:55:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BEF56B05B2; Sun, 22 Nov 2026 02:55:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ADFB6B05B3; Sun, 22 Nov 2026 02:55:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 197326B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:55:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E8CD1A02B9
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:46:06 +0000 (UTC)
X-FDA: 85461971532.03.F3A4F3D
Received: from mta1.migadu.com (out-24.mta1.migadu.com [95.215.58.24])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5B76E180005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:46:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ep+qtuk/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.24 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795333564;
	b=JB+riSXRt8NmRE8jKA2N97ZX8O3+b+6HWtCX91EY4cOlXcTuVgRW3Eg/2kBYG0QFRTH33E
	gnJxcKBEugCp6C7eRs5kBGGCHez5fIxmjVHlFOZKvNfe/T7ZRIobbC5ZdyMAc8y/ZVL0Oi
	iXh9TN/JEE8uR/MOEXz9D47ckiAlNoM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795333564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fjN2XrDXoDL6HaIL9EYpcjTaN40VnCpFbTbw1leaE1g=;
	b=Tswj951ehXhoytQF/A8cvyAYX0RRh26YXaPT2HjymaeAWyXc7HGubHhs1dtXTVORrIZWYu
	dDxOwhy+WHarUTTGda1a6Xpw4oesOX0rgiD99KoOVKL1zeu8AT0C0oTk8WUq6cJSrmQ8ES
	ZePqaAxAXt7+0ncFlPesdAf7vJ0iRg0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ep+qtuk/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.24 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fjN2XrDXoDL6HaIL9EYpcjTaN40VnCpFbTbw1leaE1g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795333562; v=1; x=1795938362;
 b=Ep+qtuk/XW/3WBXdJc2FfXG5ni5wxOG8njJc02OEXT57/3jHMHHaWIt9HvTyl8sSqIw/eG1y
 Ogd7q0XaWhZzffdm30DqHZpdTokF7+jmEAUE/7WVfOH4yPRilUe4g3YDIFma+/A+EBcnqrZ4rwM
 +njendDcKBMg+aCJ6YS+Tn5c=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 56927addac11c5be;
	Sun, 22 Nov 2026 07:46:02 +0000
X-Mizu-Trace-ID: 56927addac11c5be
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v5 02/17] mm/memcontrol: allow update of LRU statistic
 without holding LRU lock
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261119-mglru-fg-v5-2-9eee2fe97a2d@tencent.com>
Date: Sun, 22 Nov 2026 15:45:28 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
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
 Kairui Song <ryncsn@gmail.com>,
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
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B8BCB9C4-53C8-4D47-868A-EEEA4E0EBE23@linux.dev>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-2-9eee2fe97a2d@tencent.com>
To: kasong@tencent.com
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5B76E180005
X-Stat-Signature: gdrgwn9oafqkc679ds4x1yqi5ep3g8ty
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795333564-975094
X-HE-Meta: U2FsdGVkX1/qKTVM1m1eAT9B42d6gZi3MSwZdXjXsJTps2oPLRw+iOWYnfjqEYKOksL8UJKxOBm1DhzDwdz4HwaOX5PyLGxuYVY1iFDeY4MQ+U9jWvkFAhzHVsC8e3Oqbbw3eh2kbylvJCE6s3h/ggZt39aXmW0V+Bqv4tx5IR40XSxxHy6IodZUVootq2oBfhvwcYtcouF9B5m0aRLhLG4lbDdLuM3hjug8Duwa3rBbUd1shuuhqvm02RFTmBkL3kJX+pVWrsy7EaXXWaB7hvnK69+/LCdIOvjuhyqWzGVS3VdESCteUbdOZJdtt1bUf70nxPl66Wy58SQ5dGHZmKUN9Y1z3bOe0MiCZgQroneEMfBIfG7/J/2T4UC3WqBhh7I53loGIU92RcPxVTacj9XsVmCmxylmIa9bxkP1KTTTgfCB4a59tnTAqK3JwKC9un9BQJBpk5fTNfTnxt2vxGLoPjSB7c9rdeOuZ73ychmSVajwcT+B3gm/BqcuYKYeBlsKh2mkWsSdXV7o2VrO7h9gjgn7YAztAdpixqw6S89utB8CfFGbancjf4PVlvD7pDtqCvqqFLlllaXAVZBnYHsKvBPcq+ot7f4Rz3scYEr+XIZAaGFnhemCigVJTpozELJaJx0Ej+jaFwzOqXPpGr9FpfjTh9rf+AqUVuIP1mBNRIVNz403FQuPyW9HUiaGHZN+US5HYv/bpGWtuEVMQSG8z72h3Oc0ucTwqQcy6NKI4j2wO7UiHPN7+6woKuv5dZALln4zHBZjr2nL4in6zN7W04DjYfL7c2wsuMFkvVmVG/HUl/+CdR5tCRwCaOT3Pu0xiyf78Kq1hM7QSqb6ELGM/d8wdbduBM4ZSYJ/UEN/7dChYUjDLOXq+gSHuTKbPIsxNCvCeRPgCszgJGdtim1sK+XfsxUQ9rP00P5IAQwdVVJeuOudbJdAtSCEx7yvO2RNVdpiijSY0nZRtos
 LE2y/x+X
 BkKALxq3nRS2oY59MAobf3s0uovnG8/N4CGL6k6DQ2HLo0Qzm96S+6yoxeE2FLDEoLyhuxPS1wN5m21TSrTZ33WRtL+2T1UnUinWE5V5jG5/NOUTOjN9sYoe0+/hfdyc6U3s7o1lzjJ9DLjdAwDW1d983zc456+I07uzXiBsu+ZdxtnFqTTYArE0rMrZXKVxoSa0veKibAyYV0k0Hkms94kulKz71EZn3PqM+Xr3wzR4OoM4UKhoeTfpA0SPhT/hUwODIJ1u3ZF+8JHlycYeLJBOhKqcGaS279eiowz7TmWU/4CBAi0+d0xeR0VPaSa/QQVoPcaPP+f1eduxD1wIQHB70AVlmV6THH2vREA6vLiiRqHgxh2CxbSWJYz/xTjNgDHllcdrrzCfeqLrTP6a8GZocLXDmz4QAEkekzbbEpY07NlISeS6ei3PnQYnazBu/3ce2DLqnj1otjl3mxHICRzuQmtgzMTYtIuBoq8qMgVHX5AxWN/Rm9yfeuoDaqDMIE2SESZiCK66kKBA+VeX1MbxMgY3nBC0CJu2FifdB/IJl8/5O2tr9CuZdn/aLXg69nVyUNZusxEhNPWtMDamEjZ8+8qejWAvBQLuY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 19, 2026, at 05:03, Kairui Song via B4 Relay =
<devnull+kasong.tencent.com@kernel.org> wrote:
>=20
> From: Kairui Song <kasong@tencent.com>
>=20
> To enable moving file pages in folio_mark_accessed directly and lazily
> for MGLRU, allow updating the LRU statistic atomically without holding =
a
> lock. It may cause temporary counter underflow, which should be fine =
as
> the counter is eventually consistent and only serves as an estimate.
>=20
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

Thanks.


