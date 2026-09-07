Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E394C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79AA96B00A5; Mon,  7 Sep 2026 08:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733636B00A7; Mon,  7 Sep 2026 08:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4A26B00A6; Mon,  7 Sep 2026 08:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4286B00A4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:53:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2419140167
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:39 +0000 (UTC)
X-FDA: 85186957758.09.1393686
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8225EC0007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cXqqzSbx;
	spf=pass (imf10.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788785618;
	b=yxmdVtSBIKZXME4+sOWu/8RAKJ3Xqg4cwDD2fkAou+skVfI2C5tOaw9+BpDp9Ccd9uSKYO
	m9ySh4kRRbKIYoMWdD7HecWzLLvpQ3GgkxR4J5eduyBj7xofITfa6iapBfzYhrXMyNrMPV
	BZincxIUENdAfONy05Ee4O+/dgxsti4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cXqqzSbx;
	spf=pass (imf10.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788785618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RK4VHRefALxjC8rB7K7w3VAwG6W6KlTC58IWMIYwUgI=;
	b=Gr7Eji9m4ZY8yzPGT1by/G7BfAueJ4Faa0wHuwArFALP9ZoY/L7vpogk4u1nFyGxA1ptcc
	02dE7lf7Vy3J35jldwaFbzz1/pzw1ZiDtrfKUBvFrVzw+8kKSGdDHxduj6vxU2XjsvgHEi
	MlFAzzQFA1MHMf/Tie4Er6tjDB9YEp4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=RK4VHRefALxjC8rB7K7w3VAwG6W6KlTC58IWMIYwUgI=;
	b=cXqqzSbxz3lvEuOS9efT6kFVnZWykzECj9tiFIF8xUH5zySw0l0wtrrPJavS5/6c0ugtHU44w
	TQx608nHzqqoqjifoGQQm3bSkj4dVZdXvljaZRoir8tVoNs8JWQj9Dkf8ZWXUzNH3gtlFlTVTbj
	f2PJ9QOpTcwTuI1J8MwWSoI=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hdmth03TszmVXX;
	Mon,  7 Sep 2026 20:42:36 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 4F42940578;
	Mon,  7 Sep 2026 20:53:29 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 7 Sep
 2026 20:53:27 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
	<baoquan.he@linux.dev>, <rppt@kernel.org>, <pasha.tatashin@soleen.com>,
	<pratyush@kernel.org>, <ruirui.yang@linux.dev>, <kees@kernel.org>,
	<ruanjinjie@huawei.com>, <thuth@redhat.com>, <jic23@kernel.org>,
	<tan.shaopeng@jp.fujitsu.com>, <zengheng4@huawei.com>, <james.morse@arm.com>,
	<ardb@kernel.org>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<sourabhjain@linux.ibm.com>, <robh@kernel.org>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <hbathini@linux.ibm.com>, <adityag@linux.ibm.com>,
	<djbw@kernel.org>, <seanjc@google.com>, <liaoyuanhong@vivo.com>,
	<vishal.l.verma@intel.com>, <fuqiang.wang@easystack.cn>, <makb@juniper.net>,
	<piliu@redhat.com>, <ebiggers@kernel.org>, <jbouron@amazon.com>,
	<mclapinski@google.com>, <me@linux.beauty>, <graf@amazon.com>,
	<bgwin@google.com>, <takahiro.akashi@linaro.org>, <palmer@rivosinc.com>,
	<x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linuxppc-dev@lists.ozlabs.org>, <kexec@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v4 04/12] arm64: kexec_file: Fix elf_headers memory leak in retry loop
Date: Mon, 7 Sep 2026 20:53:56 +0800
Message-ID: <20260907125404.922123-5-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907125404.922123-1-ruanjinjie@huawei.com>
References: <20260907125404.922123-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8225EC0007
X-Stat-Signature: 9p7wsnuqfnccu55kx8q57o7ihsphst5h
X-HE-Tag: 1788785617-425350
X-HE-Meta: U2FsdGVkX1+vaQpVe02VfHiN8KLX4COD4fY+vw8bC+fEJa//LD5zP6p9xaH5/KdRG7dLHoPHwGQQGYai5G6Od14C7FMttsqHicAqqB/kyE7yItX65fwsKbZJsilUFN6vd0kf0K9BTMLmhtcobIB9+fJY+JQN0A67uet+VVtcqb+gHXWnacHM783EA5k4JovOzyLrh0Rramrg8rPJF7/iPwu7M+8VO1L5yp4Mx6pPzOyHBIf+BIXIPxw3/lbUCBKs/iKBwYgG+4FPMXZVnMcdMhxd2WPFQeNoJ+XBpF76qY9DnCwrvM0i2SpbkqDv37TeQ42gM/pnQJvrxSv7XvslJ0KV7LPwEsXuCoziEQw7eZyifHJ4mC/55iSA20gF1z+gFvrcqX2MVYQGWKOTSK49nYfVD+gPW4DFHjUfbUGmInzPwWv954oa2VeJUV2zoJsafDsDGMS4K34MeO6vsUODkJfurnZwWu7FkTq18/uhAbpaMIA3l6LQkXeunT6fhwqmOW96avWsLRF9fEgmsE0Zh1MoK9rVO9kwBlOzGxzph8z/IpgNEpGY04WGNdnvH9MkdhWZg8CApPgb0eVS25US51d2NwQmN3YAbWzEQj53YuPPxv00fNxdCTV73ufZdemsN4pzzodTQ6ZmIgS4IUDKgf82jiK2bmDsEBEPPeU1WVHxptcdP+neANGohkt+eod2I29FxbExAFuB6mYmxZvbCoVGQV/OiN95czjW7sBla8ebRJVG/sw5QVd5tkftXgSb2vwCgdGx3JcFgXkruQM1FVTNKqU0Bqv2caPXmD14PPXC+A29+MZT7zdpjzsRHQF6tGZnji2N5tsF4aEaHWTJ0679O8KcRdzldGb1vMMh5yKjxxgvDfvCpZNtgmnyHpfgvFEBewgNPgiD2BCCGu9cUveYyC1qKigstYzKzoliacjaGmuqGbqk/o2/bg7NvGuGx6jhawfePx4Dmo9h706
 G67OWvHE
 zVQOE4Axb7bjlFgw830q0ewNZPTqdyQGvJ4MbimQK8EdWCNy/ZJHiUkTPAR3H+N3zyhJ1FVsNGosrY9/Ua/caJRC6KaFmSqHmcceeac5kpmu38xioZ1oh4P6hBq4IT24JK0QZX+V44Gj9QJMGqX+1hl9syQjCV0aK8OkhFemEEeG2t/ShdnLIE7zTB+xaqzwNq4RiehSmYJ6WyXL4JxhpqVcBgudHhw+kQOwrVfyv38FxBy0tlANhGJtjfusIdm7iB5vz8GTD2eWheMnIuSpb7cn7az5uNCQlCxG/HJqECg5pE66GJ/vFBU5cDR+x4VOMJrnk9qg1fQJjjw/658+w7ftyCgWbDciQAGPSI0qf42GPgXMSNbpSK3ySSvIbykBTnfQN/eCeqwbapjgC9a9lyscFUhcKFScrWBy8ozFBL6xI43iqjhHODBGNHFPvc3vf/u2JRfbdjLM8f+prcpMBkwKA2+XOcI0bkgGM9B8k/MgCZCOcIIub6t7oncVuJGI4zIisTSLYKNQvl8ItWmlT4zjvwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If load_other_segments() fails after image->elf_headers is assigned,
the memory lifecycle is safely managed by the global kimage object
and will be freed in arch_kimage_file_post_load_cleanup().

However, during a retry loop in image_load(), a subsequent iteration
will allocate a new buffer and overwrite image->elf_headers. This
permanently leaks the stale memory from the previous iteration before
the global cleanup can track it.

Fix this by explicitly freeing the stale `image->elf_headers` buffer
before assigning the newly allocated headers.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 108aa503657e ("arm64: kexec_file: try more regions if loading segments fails")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/machine_kexec_file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
index e48f29167b38..2f750e5f4fcc 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -112,6 +112,10 @@ int load_other_segments(struct kimage *image,
 			vfree(headers);
 			goto out_err;
 		}
+
+		if (unlikely(image->elf_headers))
+			vfree(image->elf_headers);
+
 		image->elf_headers = headers;
 		image->elf_load_addr = kbuf.mem;
 		image->elf_headers_sz = headers_sz;
-- 
2.34.1


