Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E9A1C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 00:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 771D66B00B5; Fri,  3 Jul 2026 20:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7225E6B00B6; Fri,  3 Jul 2026 20:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610CE6B00B7; Fri,  3 Jul 2026 20:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 308166B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:21:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 972FC14022E
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:21:10 +0000 (UTC)
X-FDA: 84949189500.11.AE3C271
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6C6BB140007
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:21:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BS4ui7F1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783124469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nhQI8qrC1+u/J9NZuv3XyN01AIsqOde2x76wYlNC8WM=;
	b=WDCrLN3BqSSaQUDoZiHrZsU84DaCqWl+8W7eguImoaXz3GTRdyhWGiNNz5aF23vzTQ26nk
	7UAI47OGZVIYwR/qLnCOY/iTn/GOA9AUkHXRFB7T7hwkr9f9Hdoqmp05eXC+EG19NQRBoW
	6LGLZEMjrm9ij2B/i2TedEzMgq5EXhs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BS4ui7F1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783124469;
	b=2JASXqnpQtwG4gBYtBarEq4hj1FwmPJhn2t61erUYGQzM5RjPlDrOXBqo9ThQ0pnpYae6T
	3h3I27FQo+toalQKkd3Aql41I5+HS+1KPiTnWJWcZGbiXdfLTAaIFmGJgemP/vynWCmyQO
	087NzQ7W0q5VeJrU4+3tgBcpH/nXTCI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783124466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nhQI8qrC1+u/J9NZuv3XyN01AIsqOde2x76wYlNC8WM=;
	b=BS4ui7F1n8y9YLLRS7xGfVRmM9PrQ1NaYnwBB6b5ezq/2Xvv16B1OJ3GluXFE81Vado51k
	AHtaRNz/zcyvLaegy5t2p3Xc3fQTc2fiSnJl9w2/3IC2jWPaMs/40YWaJ/pxuSRFV9GOeC
	8G/QEIUtIp4tZY/kGkh09G9ZuKrmHXg=
From: Ihor Solodrai <ihor.solodrai@linux.dev>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	bpf@vger.kernel.org,
	kernel-team@meta.com,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/5] x86/cpu: Refactor identify_cpu()
Date: Fri,  3 Jul 2026 17:20:41 -0700
Message-ID: <20260704002046.3859585-1-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6C6BB140007
X-Stat-Signature: 9rgw4tz4nh97nr7jdd1fnkbr8pb7qhy4
X-Rspam-User: 
X-HE-Tag: 1783124468-784634
X-HE-Meta: U2FsdGVkX189k5sfz+We8Duv2p4sOPuJ4KLXUA+ncW1DeT/W5VlOTAb8dx05KmaNNcRKEV0GFb/TlcmAOl0XpuYTa1WO/6/sa1HftBJbbyHl2F2K4u3w4l4XIoYfZzVUPJ9FsUYzT7fRvA5MGx5mkHobyEHvj6vLqyulDtCegbQgKnftpx42tVRcwNU7wuVXicmNeVmEtZ3WTm1GsLO6I6w7bC59GoQfMX5DovGJL0ac2PccLVpCBASZDR5fhqn6A9zZK7rzmrd97IWzxYxBeBC/f9+C2EzsY8SjwEKdQsNERYYjem4P+ZhkRVK8U3wYgo1FPtqNk7yyDQWFyrcVXKQUdcDkUSptyz4Cf73LTooigQOLDtAJjhl/a8zA/swquVxlvfTta0ot9EbJBfEXhhTnaFs740fSPin2HBfW5y53Iue5hzx/0GTRZYATHj5MFSFU99k9/Bevpm2x3fizwDLb5pNjakN/DGGPP9dLFcRtoSB625G5bUYpgF0p+cnVf+cFWdhn4xh+8XPxltfqhToNUP86LgHpD9p9awShgGmAacX3vUQSef6qgcYOE3MVuRND0RzCUyCqyeQYlr+5WcL0iSOrBPBzKE9AWmLRRK/VYlWpCxlvTWoIMwg4dJlc/ljOHCX+EtjpV9f7g6hC5XKPmd8LQxbj17oE+jBb1A///7AFz0TpOoUL6JMk4TNt4gf5N/2tTkOyxO5aFEzyvWhpgF0AxrOM9ms3MFUT+lnHEpjaUHWL3oPkSD1+yDzRxvHevMViMUf9pLXxss2TtZkV1AI5vf+vnqkabjuWNZulG5t8wexrzDc/NC8bvmUSPv5noySY9OZLgsk0mugIZ0r72ika4KI1MENVEBYBJr9Ys6oIqdDeer9LEsyvguF5bXpOIPMZpMKOhy3wE7/ewYyI3K11iRoScj1oVRvLhuwfrxE7HR65cizF9PBjBUpiraYQ0K+8FwzcuoKN+9q
 jV6mqOd+
 C2B7FSIrdQ+up6jH7KntHKPbp8KFGpUmuuVsVpbwOeKuCLSqxJFhgyVXtdG6cOASr0x4tJIc1dwvc2iOdH8R/tzHcLh6Qn9rVcNsvzNKk3QqBBkdPrqmQ3hkk6cvJ7qOYaOtPjqfgoy3LZ3XsYT2C1z1D9ZrzummbXbntOnXXD/Y1SjHzjBOhOf9GshbP6ol0OGAAMlEhMcuwgpoEXuHOfb22pAEvkWh7TIPC6sjLRkssypZuCMPirg4IabVZHJU4wQoExuNwwsBWfboIocuPtZTyRWiDdo5YXhvalqM57+Wegc0hXlYtM6L2SCgJ3b//uONdcho/a90zv20KYnRB97T0a4Ro+04cxP64
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series refactors identify_cpu() machinery on x86 and then
implements a fix for a bug when cpu capabilities are temporarily
cleared within an interruptable window. For more details and
discussion see the relevant bug report [1].

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>

[1] https://lore.kernel.org/bpf/20260610175651.647515-1-ihor.solodrai@linux.dev/

Ihor Solodrai (5):
  x86/cpu: Factor init_cpu_info() out of identify_cpu()
  x86/cpu: Inline generic_identify() into identify_cpu()
  x86/cpu: Introduce identify_cpu_32() helper
  x86/cpu: Set X86_BUG_ESPFIX in identify_cpu_32()
  x86/cpu: Don't reset boot CPU cpuinfo in identify_cpu()

 arch/x86/kernel/cpu/common.c | 114 +++++++++++++++++++----------------
 1 file changed, 61 insertions(+), 53 deletions(-)

-- 
2.54.0


