Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F483606A800
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YSImQPJL
Received: by kanga.kvack.org (Postfix)
	id 8C5166B05DC; Fri,  6 Nov 2026 19:37:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84D2C6B05DD; Fri,  6 Nov 2026 19:37:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7375F6B05DE; Fri,  6 Nov 2026 19:37:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C35F6B05DC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:14 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E103814021A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:13 +0000 (UTC)
X-FDA: 85406458746.12.A25B360
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id CC1A280002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YSImQPJL;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011832;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S1VeQt4eeGIXDkcfneZT3UM35I4Mo6EWsujW5a+4lpA=;
	b=xRYYjFAqCH4lQv5RkPU0Q+V3uwryBgRkkWPS+1YIPs70ielDL9mwTVqluZtsjz21m6sa9D
	cVFyu7gx2biOkmQVEzMFek58PNI86t74k5vmW5+hwbbDlmTeXvNnxQwShdY7VHLX1UmMGY
	CJwQhfxCX7gcfXx3YDLJLc3vf5dYQVE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011832;
	b=42bNWgQ3FTdDJnsp637DEzVgyinPIl7fzxMDoQrxBym3In/duVBKPqzxH7dXgyOaJa6XPS
	q3Xr68o4WlJHrhMaybF2DIUG0OvlQbFmPqVy+qx9LcRpsO57R92ItaIt2B16Df2IyvMZsG
	+2K2UP7hpPRxbw001l/yceseL+a0LnU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YSImQPJL;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FD3544003;
	Sat,  7 Nov 2026 00:37:11 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011831;
	b=nlK8gBR7K2hvsAwNnVXGVAPDl/sTzzIGYraJ03hS3G/32/N8X1Yuk7wHvEAAJqEMZ2l2
	 xFXnEcjoZKNsnnf6idKtzrdiHxa72oU7d78oCQwNHwu/tGsdAtTcddLeJT938PqFmXQ95
	 Mm0GGK5zt2ziq+TOsZkEhBWOOrGwswKL1ISwZCZZtqVD79Dtxqx8LfYOfYn7SnuWCdk0G
	 IpK25VdJFdYYsmkjWVulvzYQHuahKEe5kY1UebO0x/z7Wus4yboqfQg+y/xnkXk/O9ZG4
	 nL4OkKy3Z2NWlQypYqvA6pUA+ft7tYVxF0AhBTtaPqxohOHxwSMHv+HmHKthPMSwnNA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011831;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=S1VeQt4eeGIXDkcfneZT3UM35I4Mo6EWsujW5a+4lpA=;
	b=HNioULsevLhci2bx6v/QOTtiDg0YAgmlQRTHuF7X2wbsShQ03MWl0nfXKuF4MqIc8rrB
	 PizRwKXTnSWyPGdvQJlp1zXvd08jNOAXkGtjfI5Ne4FlbuDfanv7vH4pGBxtYKXNe+Klm
	 39FmsXAnbLkO5ZICNcSaFTUSyLqy3XntMLvyc6LapLCbTxvyKhwc5OH2QODwWiMP06vp6
	 VqfBM3iwW8ivoxwj2iGz2NWXI0Z0KV9ved5jzOudkNJz1ZmW+GjWquX91KWiZEE5j0VYH
	 XVEHdGIY2qDzwIuvQ9h2O9Z+XMW8/PE8OqTFxry87V9utaUfKV+OvdgkiVnCsgVsSZw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 852E21F00AD1;
	Sat,  7 Nov 2026 00:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011831;
	bh=S1VeQt4eeGIXDkcfneZT3UM35I4Mo6EWsujW5a+4lpA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=YSImQPJLVctRWA9uk5of//u47z47vnJGGof9RAJmUHprZd7MtBhM1UoJJcxaNIgl2
	 3uvZXMb/uXKQi2nJEjG/2CdcyUhmZdsX0Pdg/n5VeqIerV6nzcxyZGh3Lg4uhb9edA
	 58c2ZGuQfhbjwWPxCf9UV01NdeDeNgZDfOPPJbFnhtYsnPAY1G8N6EhsGjQDEfZDFg
	 qIi/JMELX8Pb1QwUv5xWiKf5HX13Tsv7IQTejgLNyQHjtaIuwUC6h2j4pxTudSU57Q
	 iOvjJejWhDhjBfD7B1zrBXVcI9OTWwtMlUyGoQgdogE2CE5zN6ZCrOFZGeGNOcjNXl
	 L0Lit6heGxopA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 45B68479D2;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:23 -0800
Subject: [PATCH RFC v3 49/88] samples/kvm: Implement lookup_pfn_range
 provider operation
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-49-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=1753;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=zF6/NHZXYKv9L/HYCXHQCrJDAKRuC7sUwZ4mNyf3Ilw=;
 b=ahCkSRHzo9omVJZMhhE6rfmRR1w5YCbKaLV2veN+koHtwyTZEPMuUJDWA4vp4xnnxkooZ1qco
 erjm1pX+7bACC1WV18Q1Je2NRoYM1uyGK8yLYYA8TUwGIp3C8gOY06l
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CC1A280002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kxspei5r33kyirzjna3mwx9hqhqbrp4p
X-Rspam-User: 
X-HE-Tag: 1794011831-927787
X-HE-Meta: U2FsdGVkX18NId2S7MaVhg+nRjRanjCUn5QgnodbCyDy18O71Sif1Jf8vgC3yU4TNQwe5B7xZfSPK4e/fWW4takmT5fO5IpA/cax4H00UCTad8hGeHWpWxTC47+IxaKXZR3sx21G9uxbLhcnj8Mv0YO96VMOAbAXqp9T5yKUA1CN1wcKkGRbSnSh8ze+ZCb988iZpinMIfNbWT18QKxt9UHgKN3773oNLDXpxBL5caXU6S6YyD/VHSHz4/vwTD+WgWQwN//wt934oEJv4pxCYxbT+w4yr0jRq0+KeIK9lJkxm7SZdUQwhAQHdsyRy7alomZW3pJ09Ebx/uAmlkPM8A9on3iytJAgBt47t5q0J4z/pQxfgg6NDJ6yi+gOoplDct3HjvX3RRObymydvvbuRG5bekNimA3N7nRb01A6na7qb326ElMFdvlguIiwDIv3+PT8rhWL4nWnfJbZ/6IUa6f1xZ0JfK769CVpnfKBc6CRbsvfLS15MvDmiNwnaF5O3kPMxFfp+LRaZqzzFwgpC8HLfFsXBhbO7S0Zc05wmfUnB5PfnA4OqoxxbfR/VwMdprmIHGpV0/pWvWduFT2tPzxI+y7Rzdp/+adZJDzGayHh9USNAUq9Zv1iuDzeUf+KcxWb1GiFjCju5S9J+TVazrGNJvYAK0KvPrvsUn+3RlsuiZImREsbdnYFSbdKVYPdNgFLucVrpV3G017tBQVwcURYhxQnSa493DLJCNzfsBmovPOsiFy1GDmGcH2l6ZT5WntTzIWvjAu0Bbr9WWlKoaY8E8Q4OWFnCgf7rRPpqcMX588+V7pI1HiJlvsbfUZZ/eNlqY+6eNuU3o1ph4aAwDi4Fe0MxPsXd7xs05X749AR0wACWCxgNzWPMMwsO/vMTZtO5blta+hGzhCX5yQyjEC5LTBXRcVYmKf5AHQdsvVUNIPlWUaiM+eE7Tnun6wiJmdeglYh/McOPsYVN7Y
 LYVz7xpf
 wKCHqi4jwK24Ru2NNSOJywxffx03qwilN/fwGUnykjGVJI5ttGOgq7SeYPKY79zl91YeJtVq5GbY1zDuC5aP6E8uW2s0BdQRnKqKkglEFwklhshDd3HHHPjavs/bf72X1rN6NkvIBYWec2w3ZLqdeMg5wf5RWSm2QWY2H0YPuJOwOd25pBdpQsSGaQCaWbybgoHY8lxXWGwTAw1yyHSwXcyiBRFnnJcldL9e72EL1j+HlzV616FTmG99e+JiOAKbn9761dFIFEgltK6gW5pYvHQOVSJr3K52PAsxm9UVNCt2Z22N5vIz/vlVrSNnS6tHEd3tV41osElM5mYARM0t0sEjUNlxYORjB+gII7SiiJMT6fuuLTySelw9St2cJ/+SKotfh3OAxGoat6bqL09B6ASFLkZrNjpaGVsvbsqooTHEjMYbTpQxLA/ntnlFTEJuBcdh6/QWfyBNJBDLK/ZdFKNcfB7hgdYOpFIrhHNJLfYa/W69Tsu2oA6PiDsHgr8o5quCaJivy1r0elFvwUBectRZmrbqzzybOaANsIRUWa0qiExQiaxzac6FBo6M5hKQON2G7TDV1SD6Qp5l8PO7Or0pF8kYFmmD0eKvG01BiXS7JDZM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Implement .lookup_pfn_range to allow looking up index -> pfn mappings to
satisfy guest_memfd requirements and make this sample memory provider a
valid PFN mode provider.

This sample memory provider performs allocations upfront, so
.lookup_pfn_range doesn't do any allocations anyway and is only slightly
different from .get_pfn.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 samples/kvm/memory_provider.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/samples/kvm/memory_provider.c b/samples/kvm/memory_provider.c
index 926f3cf68ed49..7fb7365b65940 100644
--- a/samples/kvm/memory_provider.c
+++ b/samples/kvm/memory_provider.c
@@ -249,10 +249,34 @@ static int mp_gmem_get_pfn(void *provider, pgoff_t index, unsigned long *pfn,
 	return 0;
 }
 
+static int mp_gmem_lookup_pfn_range(void *provider, pgoff_t index,
+				     unsigned long *pfn, size_t *nr_pages)
+{
+	struct file *resource_file = provider;
+	struct mp_info *info = resource_file->private_data;
+
+	if (index >= info->npages)
+		return -EINVAL;
+
+	if (test_bit(index, info->absent)) {
+		unsigned long next_present;
+
+		next_present = find_next_zero_bit(info->absent, info->npages,
+						  index + 1);
+		*nr_pages = next_present - index;
+		return -ENOENT;
+	}
+
+	*pfn = info->base_pfn + index;
+	*nr_pages = find_next_bit(info->absent, info->npages, index + 1) - index;
+	return 0;
+}
+
 static const struct guest_memfd_provider_operations mp_gmem_provider_ops = {
 	.attach		= mp_gmem_attach,
 	.release	= mp_gmem_release,
 	.get_pfn	= mp_gmem_get_pfn,
+	.lookup_pfn_range = mp_gmem_lookup_pfn_range,
 	.put_pfn_range	= mp_gmem_put_pfn_range,
 };
 

-- 
2.56.0.455.g6c5a503b38-goog



