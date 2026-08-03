Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADFF0C55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 06:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F82B6B0088; Mon,  3 Aug 2026 02:21:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AA296B008A; Mon,  3 Aug 2026 02:21:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E6356B0092; Mon,  3 Aug 2026 02:21:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 45F496B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:21:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BFBFBC063C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:21:58 +0000 (UTC)
X-FDA: 85058962716.14.5D89268
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2E668180004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:21:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P06mjlhE;
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785738117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0NUjMF0YZdO+mWLr8nRUv6rJ891UqYSF7C3pZ4ivN0E=;
	b=ppvSSGNU7qTXT/bPT8poqHhN/Xy5XhO1S9FvzeYutoF/UJfFyJjU6NcId3ZiouxP1rAKqE
	clHIn0AKvmHhzqAXT/uAyJJ1RkUCq95bzgIGFwyYyYuyFCFiMI4g+4GEuHZW4vDu5KOp61
	0RQDlEySMdvMs6Cjq7iG/nwXkLhWBHc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P06mjlhE;
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785738117;
	b=VsWRhkccr5o20ErTH226D/ZpWs20VMvkJciQElgaM/ktncuG52OkFpwsjP6/0c2NPDBn5J
	9L8HGEWBpTCxZZcieqx59/dHAa4kdxuYAHAwXAfoO5qUC/x2CCLUzLUiLEnrWRgyEyt7kM
	E81kY+u/FAgoeAA1S4yx7TxKWYqy3o8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785738115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0NUjMF0YZdO+mWLr8nRUv6rJ891UqYSF7C3pZ4ivN0E=;
	b=P06mjlhEuN+V17oxIDVJfMATXr41BvX4ARgCP6fw47r45jdjZnHiVfGlCJmOyapK1ZEkIF
	eDeARBohXJIE+gxZUqW6eLr/vAVNmbtXx3aEKKGl9PPyCCUKK8uFTSBYoj2/MQpLgckMw+
	teIp1bU31RMRj+W+yBnFcP1bUJKZUvg=
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
Subject: [PATCH v2 1/3] tools/mm/page_owner_sort: fix --sort option being silently ignored
Date: Mon,  3 Aug 2026 14:20:54 +0800
Message-Id: <20260803062056.1518070-2-ye.liu@linux.dev>
In-Reply-To: <20260803062056.1518070-1-ye.liu@linux.dev>
References: <20260803062056.1518070-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E668180004
X-Rspamd-Server: rspam01
X-Stat-Signature: 7k9u3p4gith68f3n34ocmwr3k98rgtys
X-HE-Tag: 1785738117-824784
X-HE-Meta: U2FsdGVkX1+5NDFcXI2KTM1Q2HZ5G/Spuuia80cVfBaIEuYE7TB4N3gyUXaTimtztIejnJAmuTQgN665aSME0nJnQZjYXhL9bJrSruZXLPKU4E5h91yMUnRgswS8lq+GP3+At7f/YBcOpKcTSm3dk87OFSUkFRrRDpo9m97zyli97v1ChlEgA1ec5NjowYvDvRhdqNzSXZCiwRKJB7cO2Sw3nTatbQwyUkRSG/hg2e2Q6Awg/YcEAqS48A+CmnENgZH8Zx4epNx7IClu8skqlQao/85ReQfIhfIPEMa5VzzVznZ3qVS6yKEKtd0s6Fy+gk0qkssFUuEX7dwEIxpH8n/ebjPazkSAjTNsGxch4nxeXurwKIxr3WsKIR9a63mqyxggYQKAavjeJs11niLD7NDNA2IMuHPqKwN/pdajjASU1D6WKg2aKQ6bzXzpfOO3nw+9FDbVf+TYgrLLGHCrDPbb6mHqpf96uXLN30pjfQlLn423xrh+/5i5Iuyn7FnGr+KPJQCxtYAiuwKGFK0xqXBK1XELgIavQRTPJnK/VXFDL30/rCN8KejLap859lR6llwlr+Isfu0DdezbPumJF+FOG92BR/0C6sFAp36VsCNl5ec1xL/E6jNuoaTtQEIuSycKGpXW7kE3BJRnF67Ep9svukPKeY051npokWoyRcEDpiyY2dUmJzRhjsuPiv6U0wo9YLChWov+v2drkd5/l4FOBBtLqXy/ET2MGpkaBSs29qh9Kly0Pg08yprZaN+51cLrVMte/jMB7cBqQBMRIF4NKr5zPs5Q08Zk+37cUANC8gO+ddcn65fgg1gtDfFW8HbBsHgBTca1sTfYWTkSyAThx/HF1DhUnseWBLplWfBLphx6R4Rgp6fAHuy2PeEd0kQTyK8zgBAj79fNlhiMamCdGyz+2dnSWamrwRAwFBbe6mo1eXNa4Wfok/vyQmBPSGVDgdEbUr6ubrqYJnn
 NfyDhaIc
 uwcxa1g+yKioOQSaRQPNjP0UQuxS7yYHQrA/FNLZBrAQB12qH3w26m+I8ywdaoGSTaYUVNkZFQnaOv1YqrNCAA2iYbIfp3XJgy32cs1ky/6Cr6T2OzrYYAbXOi7VbE/lLHPGwhnO7VnGIK86ru6FKyDULsb2/DhRI+EPgF2er6Ml7sTRguKG5vV74dy6s5n22Wt59m65oWp36vnpKjtBob8vyq/qE6Amze0GG6zhw2CityzPlHTQxBBNMTA==
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
 tools/mm/page_owner_sort.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 35d3d254941c..3c86c8d0618c 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -821,6 +821,10 @@ int main(int argc, char **argv)
 		set_single_cmp(compare_stacktrace, SORT_ASC);
 		break;
 	case COMP_NO_FLAG:
+		if (sc.size > 0)
+			break;
+		set_single_cmp(compare_num, SORT_DESC);
+		break;
 	case COMP_NUM:
 		set_single_cmp(compare_num, SORT_DESC);
 		break;
-- 
2.25.1


