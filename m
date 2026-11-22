Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EA1A606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IUvvF4dr
Received: by kanga.kvack.org (Postfix)
	id 1E0DC6B05C3; Sun, 22 Nov 2026 07:44:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16ABD6B05C4; Sun, 22 Nov 2026 07:44:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0328C6B05C5; Sun, 22 Nov 2026 07:44:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2FF66B05C3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:44:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 06DBD80684
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:44:17 +0000 (UTC)
X-FDA: 85462722954.01.12F8700
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 30477140003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:44:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IUvvF4dr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351455;
	b=lEprVXHmlHvoEdhjjey+rV+PqWFKcSk90yW+TuvFzSgQmCEhNaOHgB686iL86/XjH5leLF
	A/F8Wp4AlLpkh3seaDR/XHgSS8E+172VncdDl8K2YpthxSx82aRdQv3j2u7nFhlTt9Dc5R
	9CdzaoMe7jH8Ykc4thqEQ0b1LNjLm9Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=14LnegLlUwns0/xDAhlDRDvD4G/8p4sFhn7pqvFB7DM=;
	b=8W/TGag4zgzpzfhAQGi0LPb/7PYpRN2pwHQ+k50kdi7DJ2hM7R7OjyKciBSNNtwz5HrzQJ
	k9N8uI5E0Iu/ElnfgBVaw2VeKEvLxSi+/HwaAf/JwTe2MsgDYgjVXdmDjgcjsCJzAp43g4
	GzHnz2CoY3ysZZDhyGrbDpqY/OFHpK8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IUvvF4dr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso5327769eec.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 04:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795351454; x=1795956254; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=14LnegLlUwns0/xDAhlDRDvD4G/8p4sFhn7pqvFB7DM=;
        b=IUvvF4drq/ItQz+aI3ZLylxQci71TIARnGjrj+GD7UNB92+u2Rc80Ju/A8OkR0cZEh
         WAwGLx1kyGWTUDkoRElI1SkLZo/PrrsqVDZR2jmR38IcwdQvT+QU1fpOI9TtldUIVSb0
         s4q9gZZJq5SQto7zjw507MNoSsWAbkaeP++0OXcs1GSmeqr09gsfy4T7oyyp0BQL6QKg
         5o0XVNAWKI9yG/N3FiEMjrubrSaIR0xWiBILJMZ2LuQFTZtphGzpSh0xbvxZijksBrvg
         9LWHaYAAA9+A7e9LecMsB9OcROWOGg6mMbf3MowYIbOTR7Qm/U03obQkH+c0suSapPJD
         jNxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795351454; x=1795956254;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=14LnegLlUwns0/xDAhlDRDvD4G/8p4sFhn7pqvFB7DM=;
        b=d/dnVSc6IyiPUbbGjNpoO84yTS1DbfHD7nVF/xwlYYIiaokEmhQEqyS83aAZ01B51F
         5vkSKdt1aimXrm0r32z+ehj42ffKLIsAJwOS8w8u0PB8GARgUFKQI5gC/xoxkv7Mn+7S
         OA0aj6kz6IZPh6vZhcocS65JvpCzBEsXU3iQbBTkLBisO7NQ6XbUt9VPuODYV2WmdBBb
         kQbtMIIhgN0z/ppdfYucHHMR27I2THS9KXyOijp05XBULwt4Af3ZjyDsAqJZzU0JYC6G
         RTek4kNiEpZ8qammAfOtWyQ02EJuKgkqwxdhpnDZpQPMNQ9Ut6Y7uw4uYmrHSODKg6V2
         Dcog==
X-Gm-Message-State: APuU4Z8QlsN6+iFOel5ub80pxzW5E25LNpwZ/V0jnsrz/tWAnjh8trpe
	73yrUSZExQyhy/uhyErUGAmwEoi+g2XlvW5MZLhrIGe/yH2wxlvhVb/F
X-Gm-Gg: AZFdTZeN1o6Yak9Mgrs8h+3rbekesTeG+5UlPVZPh1vvf7PyYjbCcbfw+iZ386JE3ff
	Z52PctXxM+vrR664zvScS55DWlobavD1STVIQy+lvGcvC6tY9X8+TWfUTbYACme5wHja6xIpQF4
	W/zQ7HjlW4XW2GARwd8qOIMo19KkXfvmU5E1diaUa/QjmWYNnQ2lf8EsStvhxZzcUL0hyE66gfn
	35T8QTK3Q5/s1yPUPzDf0b0T8OiApb4tU4PYzvea/k8FOL8P++EaYzmKUgQLHH/BXMRBivAjc3V
	u3CzpeXyC1DDSe0qJyDgI5u9wCjS0LTTJuVeptqARa/+98Q6UVKUsDL1haC10P4nprYqLuh1HNv
	EIbdROUzO3PbVmEQ1pE/DcRxjnxzx1cKt2O53kdH8ZiYogAwT0n7NsVCd5ARKjUGG/tV20i8NgG
	Zl/H2yD/lGAtX5zVMmJUw91+LKnDeXHgLk7E70FbRPxuqct8vxb3DExNGpIgUoHIO75XMmigbEs
	rpniU7iJcJelQyHnvZJudBPjkQiQV6ISSNSVoytupXWeFA+tDad6hqVmwsl4E8TF/Y0RNhBRwEj
	TwtWcI4/wXGLOhRuaQIXTT/9lzznkDjh8HdZv+ZV4UN2stUIQBlm2Ycyf0H1BPnpXR5Q
X-Received: by 2002:a05:693c:880b:20b0:386:b025:1e1e with SMTP id 5a478bee46e88-386b02522d2mr110063eec.16.1795351453747;
        Sun, 22 Nov 2026 04:44:13 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385666e99fdsm33447310eec.5.2026.11.22.04.43.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Nov 2026 04:44:13 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org,
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
	Kairui Song <ryncsn@gmail.com>,
	Xiang Liu <liuxiang.277@bytedance.com>,
	Ehab Ababneh <ehab.ababneh@intel.com>,
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Hui Zhu <hui.zhu@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 02/17] mm/memcontrol: allow update of LRU statistic without holding LRU lock
Date: Sun, 22 Nov 2026 20:43:36 +0800
Message-ID: <20261122124345.66978-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261119-mglru-fg-v5-2-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-2-9eee2fe97a2d@tencent.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 30477140003
X-Stat-Signature: gb9nahhg94wadbarap81buooubrk11aa
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795351455-147043
X-HE-Meta: U2FsdGVkX19UmmmZf8XJevsoI4SK3CP1FDpjsLNCxz4SbCtLpttunN1JGCvG0nirgIDm8oXT6kitt7iwiQIvzmOF/W8zTue4t6Z3Vi9B00ivvkw2vvXgxUonKILGou3orxkVsHAtaB2srUpUHew/L0b/+t/qqmtnx4ETruqW3wCxpvsjoSfWMz4Wqe0lWMocpnTLDlFFJYmDAduhqU9CnDGYhk1tCb0I939PCjYSL7RzIaMnIzs4Nj091DbzcHeoUwNqk/9E9Wq8IwvXSmWhKb9XrG640n929erAT/ggfagN6RIGbgN5m+2/LicCSp+yjGrp2pozQJgVOjM8bk8sPjRv+EC/NNhSToBuoNWBBtSMXROv+Expg/Jao7a9JWWwmW7alMRf+Q4fyWx6FLQP9qKPTBaK+Bh3h67KTz5dXWypd1qDOXuN77wkQz4TqzlvLS+cUwpA9eVjRsyfrJF2NB9lvCfTkMxU3KtERlT2fjm0BkFPWjXmsi9r0u1MKbkxGwkakCMOr3IxdyIbvJADJpF6MdHa92YK8mQNCxK1ozn85oS156bBfRwNLwRlrVvQJ8HmvxBdMlqVzILFCJWKlkmyN+yCD3fVuQKNQPPGiQHu7ednxygF7HP3I4Ucbj80kfwXQBSjmEiyA3iFwvgcQXnRjWTf02DQmrontkl4VX6ZJVFYwMkgYq15Cln422JJQg1J68HjSLa1Hc+nsoTVUL3kjoKJezbAFh/pKUIrgxtYzTaBpp2I9dj1JnGY21I72MoJiDZ+z9cAQKdS9S9/lQqBIsWdQNK/3ym5xWSW9F4+TKJFrxnkaJ/Sr0Yx9bBC80lveiiyK7ArvbwnFltRs7xK9WlMJ+1hJZRGPGU+Y8VjdqUtYWAgYDldhualMHFKSMVf7eBX3T7ue1J7wF1wcIZSa0gSNi518gp0y1dyG5CNUmnWMg18kyyQsT9JsVD/4exjvpsfoVVhri3iPcw
 ZQclN4vK
 ysTqlGFnEXDZKg23ofVpg1N13rtCamIt/8GmffHUjyX5bOzf/ZfwqTh0Ew4zTH9VvPrnB6nmLd3DD+87QFOQSH81ND3TWw3y+6381TfRiqLksxc8YHd7D1FN/Bf69sxZTK2KqJeka9A1TLJWk02gOR3eRk7b6qZ7/UgJEBgElbK29Dru1vb6+zC30ORwB4UlxubDsM5ZCKMrmuVDVcpmbIsWHN6FVHxs7OViYHa1CT1vZfxUcrrGAKYSoRQ1Zori2fCBHHwtaVOIuzXHMnAkyLJE1E7U15cJwzZOjE7rAZ0xtDpmJY2YF5QozHeHZ7TjPqFJSyY0pD5fdZUJQJEzD9txa7u1Srjs2e01dPaddA7Pyw47u6CG5a3OpBZvIM3N6Qc83cvC1ay94DjqIhxfqMD4CRz46//AJyM8+oHffI1l2Gbr2cDyUdbJN91URBixAjNyjRMonhswRy/9oxFO2/6vW9KRmZUjjyNUfqeOELN42vWX8w8kbxJl93MDLWLZdoiMoEGMoItJ6vWv/byXGsE9LAWahPoWYYKvvnerdOptGMr+eb/XuSNwe93fvIPR8QbW3hkl580Yg1aMFd4OKYYUKp4x93vklYMI6bw5GJcXv9B2OlRxW6Si5p6VN+j4nImEILq5pWgy8KequTjHo8oRPKNoMQbUJbVj/snAQaXyB/ooeqCI6u+bnHB0iX34qm8M5U1nen95xupicgZnND8Ol0fqp76xV/Gd1rT6e1MtDURQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 19 Nov 2026 05:03:34 +0800 Kairui Song <kasong@tencent.com> wrote:
> From: Kairui Song <kasong@tencent.com>
>
> To enable moving file pages in folio_mark_accessed directly and lazily
> for MGLRU, allow updating the LRU statistic atomically without holding a
> lock. It may cause temporary counter underflow, which should be fine as
> the counter is eventually consistent and only serves as an estimate.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

LGTM,

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

> ---
>  include/linux/mm_inline.h | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

