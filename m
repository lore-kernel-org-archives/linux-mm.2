Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 168D0C982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:04:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDE3D6B009D; Fri, 18 Sep 2026 06:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1ACA6B009B; Fri, 18 Sep 2026 06:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1D896B009E; Fri, 18 Sep 2026 06:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF316B009B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:04:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF3A81405DD
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:24 +0000 (UTC)
X-FDA: 85226448048.13.00DAE7E
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6A73A140004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cXqqzSbx;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RK4VHRefALxjC8rB7K7w3VAwG6W6KlTC58IWMIYwUgI=;
	b=LqzrUXk1fT9K0Lww22yuWrwl4D5pPksMoc6kA5DuG8Oqmmdls9Dw0qHeSCPnmlEShFPxHt
	Bc8e8R9B9sH0YbUbVIqqVb7PmN80zG5VN6jVoGP75+C7uett6SUhGOlQlqEqbV9peLonT+
	QF2Xml50yslWniPxb/2CtI5gh1F0ywY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725862;
	b=lzptomQO9GoK3cVxk9phKW6gNaFTFGDj9XQqNUNDI2TGs5Bd4/JbMOg1b8pv1+vae5Onxh
	kQNlpRWmpXWxD5Jxbp7VI0w77+AbjGypn1bJbn+/yE6RwPrfuc2vVwGuj001YDxLVuyMAi
	gxlm6gWe48dP7g5snW3z4acBMH55EwY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cXqqzSbx;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=RK4VHRefALxjC8rB7K7w3VAwG6W6KlTC58IWMIYwUgI=;
	b=cXqqzSbxz3lvEuOS9efT6kFVnZWykzECj9tiFIF8xUH5zySw0l0wtrrPJavS5/6c0ugtHU44w
	TQx608nHzqqoqjifoGQQm3bSkj4dVZdXvljaZRoir8tVoNs8JWQj9Dkf8ZWXUzNH3gtlFlTVTbj
	f2PJ9QOpTcwTuI1J8MwWSoI=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hmScC2CS3z1prlD;
	Fri, 18 Sep 2026 17:53:15 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 8D05940591;
	Fri, 18 Sep 2026 18:04:16 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 18:04:14 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<ritesh.list@gmail.com>, <sshegde@linux.ibm.com>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
	<dakr@kernel.org>, <akpm@linux-foundation.org>, <baoquan.he@linux.dev>,
	<rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<ruirui.yang@linux.dev>, <kees@kernel.org>, <thuth@redhat.com>,
	<ruanjinjie@huawei.com>, <gshan@redhat.com>, <ardb@kernel.org>,
	<james.morse@arm.com>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<sourabhjain@linux.ibm.com>, <robh@kernel.org>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <liukexin@kylinos.cn>, <guodongtai@kylinos.cn>,
	<maqianga@uniontech.com>, <zhangtianyang@loongson.cn>, <blum@kernel.org>,
	<adityag@linux.ibm.com>, <chao.gao@intel.com>, <kas@kernel.org>,
	<vishal.l.verma@intel.com>, <seanjc@google.com>, <piliu@redhat.com>,
	<jbouron@amazon.com>, <me@linux.beauty>, <mclapinski@google.com>,
	<graf@amazon.com>, <bgwin@google.com>, <eric.devolder@oracle.com>,
	<hbathini@linux.ibm.com>, <takahiro.akashi@linaro.org>,
	<lizhengyu3@huawei.com>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<driver-core@lists.linux.dev>, <kexec@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v5 05/17] arm64: kexec_file: Fix elf_headers memory leak in retry loop
Date: Fri, 18 Sep 2026 18:04:30 +0800
Message-ID: <20260918100442.3841135-6-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918100442.3841135-1-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6A73A140004
X-Stat-Signature: w3f1kdntupid6twhyy45kcszjkpy1ehd
X-HE-Tag: 1789725862-338597
X-HE-Meta: U2FsdGVkX18Bc6KJ29zmyky85UqtuWq0GCsrVK5WRdCxitDPig9ftfKWdTIpjSvk3JPWPDQqk5XnEHD0yNtwczJWWDE1Wkbb3OnXWuRXMs6eB8pUD1BRlZc8UT8gzeJ/qmENeHrDdzQqxalVK3ZVsKfHiehNWbL1p2iRA58sKfzovjcsvEXe7NmmqXHeGQjZU081zPIQvJMsaOlmhDypCie5WkR1DCiL5VTyGwsYN1CsO7kMNiuynGwQMeV1Iz0kW0IlHV31lZQ9o5VVhoWT+kaA9PZR82vVSSGgYdKUuxK5iBIvj+hIT7Xt/K0UWQ1RBNJ2o2RDXj7OzWoA0b69xzoyHjq6+WMt06q7fZN+i0lzZYcyJu8S1vxRLboqsSTW7ayHlGj4mVKjxv6Scn3giq1Zc1Fa3wJRTOza2e3U175pbThBS//vb4/uWCJAoSPZQjlQm/q9qH6yFuXg7f7ckoPzpSVwwidZiq/VU3oswRlT6XmqH5TXCTCycUzqANhMouGNF+9LShNs2W++K51Bkj4NR9dzusGzr37S+MDnFPPP1Ng82WXa2n/hFEmSawKLBN+VcPHoF5MpgPpj00XOlxfNvhW+YrNSFEXG3H6LaHBmGmvZE8YGCpTiMO6ENpBVsYz2xpitji6fGcbpzO0Y5BG6a5i0OKy+5lKmF2MZg3Ac8PIFpi6x7mE5T69SxGkcalx+ISjmb0CfGAHgNrRYbn+9yFxQt20mpYxW608ZYmvmSnvBcpxdqao3AaqMJS+eJDXbLkGLtUOYokFZVi6COCZn7WM4DDVjtWSfLNGWz3V0ddbmEwQkJoB23Li3tgWRJ0BZvd2vgsNF8YBrN665Hev00F5+VJsUUZ7Cp4j8OU0wt24384bMiFYB1VDyDcR2q+JUCytC5u75EM36T9NPi44/DeG18ekO8y9fnIAObfL+8ao8+sVXVydGfnnECqylmZ8FTaVQTmVl5r8lNTr
 lID6Vd5d
 g0h/ZILl/l4RxXo2OYFs/Mn4rValTHs+NDKaEzbKtSRTqi3jWUUuXij1lBDyT2vqiKJI+U5/kZJiURcX4f+IgnO2EIscFufZum9KoB0dtMnfiFelj2yQg6MGO7GQeSMqjRFxacLg1V5Ok4GX6aRq0M+xIVmMLxGzGD8wdr/0iFEreES5A1GbIYScY+Mp2k+/l6HuaKPNJBtV6q1SK64Wy60HAbPiXN6auVETTer81P5gxYQT0YbRyN5RvDZNF/GYM/4Y+LOfG25NTVzM9zCmGEC1IAeYH7NRkN2u660O2Ob+hQVy6vh0aR6dkO9rPjhTcJHbOSZPsgVgoXKB94eV4cb6FoobRXR/KcjNDTTFnlaLgAkCCVTnLtWVophSNVAMqN5+r7vSTXTfw+3GJShQVymk+jcYfbMOPN0iMTe4W5QOEMX8WiTpr+CeisDYiovrr6BgGTeX38o7Nri+sJ3evYDN4nx9HRKEtkmHq3hI4R4ggzbRy3LC54grln2+DPH4rAah6Yf29xi8YY9nhBl/C/s33hTBmdNIY5HZZelv9DT5jkg6w+c8HoDepCbKKzxUMLPsoqYPeppTIkcSdjjxuXsscffsBm1/CnJFD
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


