Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B199D606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sYP5BPJt
Received: by kanga.kvack.org (Postfix)
	id BD9186B05B6; Wed, 18 Nov 2026 04:16:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B870D6B05B8; Wed, 18 Nov 2026 04:16:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75A96B05B9; Wed, 18 Nov 2026 04:16:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 741B76B05B8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:16:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF5D9A8192
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:16:21 +0000 (UTC)
X-FDA: 85447683762.27.79B2CFD
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id F231E20004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:16:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sYP5BPJt;
	spf=pass (imf03.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794993380;
	b=C//idNNdApr2Vs4QPJiyxMgUgPGT+uoXyr4KgULW8wsboSxQMP72lipbXk9qSQc2Wjt2AZ
	jCP9Jt5QDkYaRiHE+TJKP0Famu8jbRqEaBmGMQqZ2PivWCdFcMZ9NB4pTmNlgVaXN8UHxr
	rD2a18bEmmZwqci42d85qp4JvzkFK70=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sYP5BPJt;
	spf=pass (imf03.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794993380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/p1Aibx+fESAoq7Mn088hKyuz3N34SXVD24S7wMWTbk=;
	b=0DR0VUdvtk9fMJ1fX8P/SqSnHyUC+XOco3J5ll6lIpRO6uAHUQdS4Sx3h6m8mrZ5dNTT/r
	rw9pl+BtSl6juS/suqjxEEHqaHPJArVFE+DB5ipu3tDk/iLmUxnYRi9RqGq6EBm+bxFJ/2
	GTmc1LjGIQzJKGYE/MeWvA2WMgtWb6Q=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794993376; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=/p1Aibx+fESAoq7Mn088hKyuz3N34SXVD24S7wMWTbk=;
	b=sYP5BPJtOg+mrYm+Dk/FSjUMMVoa+fnyhmdn+KqVXRHmaz+T7E6VeRUrYyFepUAK469TYU65POWpJjdputIei+Ruygc2yHZu749/ja4u83cS4JYbWeVfIL5Xl/VTEq1iEN0iP4jx2KznouUzTdesjVAbq0cbOyVEdFsLRBJw1yo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XF0HHbZ_1794993372;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XF0HHbZ_1794993372 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Nov 2026 17:16:12 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	alex@ghiti.fr,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	graf@amazon.com,
	shuah@kernel.org
Cc: guoren@kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	kexec@lists.infradead.org
Subject: [PATCH v4 1/4] riscv: Call early_ioremap_setup() before parsing the DTB
Date: Wed, 18 Nov 2026 17:16:00 +0800
Message-ID: <20261118091603.979-2-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118091603.979-1-cp0613@linux.alibaba.com>
References: <20261118091603.979-1-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jweapwudf4xx93cs96z5ijkx63kyxpyp
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F231E20004
X-HE-Tag: 1794993378-905905
X-HE-Meta: U2FsdGVkX18yU4NqSw7R00tnj67ATu5e79936FNZHBTQz0rFPwmoCYXKwQ0lzcghPGeBtl3Lftxmgj0VVTLRNqpBGFKzycpHYDjpVP5y+UrlbheGdr6hyQg+F/M938h77xhogNrdTJSZTWHlpQ0sMsyNpNnotpy07EKVMoMGUEZMKGp7LeeFqOotMcFJooWdNgYQj5bbHJWEkSrCzr4tjxqZGIf079B9k/Eq1bpY4Bd6aWV5rsAOu5WIJvgLIkmEw/KPLvgjYJPa0Qfzf+2AXL6OKMp3J1deVcIRPiYKy9Dz3Lae8UagCcm7p1G4SaN5Qu6AomAjErNbeRAc8DigWS4d6iaeN2cCSw2z7VUSxYsyuhqi4pBVSLgN8INwIClPCZ55wLaEUT+ylZimA8VlyZ7KQS/VUSyT/zxBYwgvWOGnPMJbnFAW+sY9+3Eyns3rbWV4BdU8+8PGq7QtjIp8IULLDlhozBRtWhRkMDrfp1cnox1mnMN9r3yQ9yyaPdMgYzjl64zkx9pNsYnOyqT34SZbICckPYkymikYtY6amKRaC0SX5l/VT34VyzfPROgWlkWLGFUhTK9Wd8N2DqYkayfag3Qcvp9eF/FFOMVJC8yKCsI1jo9UHARYJec6fTpb4dO4Q8MCNNbgWMx02r4ThJxNE2OWoylj7DT3POXkxKA/EKpLcEYIbJJC4s8MywmNyra+CtwAARbpYhu7tC05/YYyu4u1F9KaDI1Np8ftt0JJiRLRay4MetiaeeO1aWMDkdolrigxt7IfdxTg8GiRsf3d+HhAGzwAXtOOaKfSfn58p2pTIv1Je7UGYOycYSkoDbB2ApzVHeQVuNWg0rkeWxVHOyQf7pHiygN4OuifGD6XdbN+ywxdw9280Yx+Vua27oFAmSPX3GciaOi0Mz80kXT4iSdBv3i89oVr3/+cGt5wTml8l1j4tI94q5M0JCAp+MKCNItWMif7K6ifSni
 NJT2vdk8
 QCTFThrCGxIUY1su71Ro29u7hef3Ibo7DpZfd1v6GmAOFt5J6aQvltzeeofXq5E+pLd6WWkZ0r5eb2qz2rKGceb0wrmsqWsrxjm3K3EhzSCsdBvl9BGTDz0h2v2mOZp3Seyht0g68CcYqtbAcwbYetsZqnBtoCCItXVQI/kCaCiahhZmOSbMOq9QKDPz9HKqq/WUQFc7X083EM+obeMibLqOFT8URyWf/cvN2nDTrQdBFv7QUe1aXN1Ju64UCNJetq7L/8mXJ3HYh+/Rtoy4TybZVLz6iS+8K6+lZqSTMNHEK0XBDijXWND0DPVMFNBoZKyIFkPTEdR5mvtQoYkxoj++hh0ubqc6/kf2q0Vf8Hver9L5xJE1VHfBQuEGtqhZo4key
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

parse_dtb() can reach early_memremap(), whose return value is composed
from the slot table that early_ioremap_setup() fills in - and on RISC-V
that setup ran after the scan, so the mapping came back NULL. The DT
based kexec handover parsing is the first caller to hit this:
kho_populate() cannot map the handover FDT and the handover is dropped.

Run early_ioremap_setup() before the DT is parsed.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv
---
 arch/riscv/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index d79f99b86033..45e2ef9d32fa 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -308,12 +308,12 @@ extern void __init init_rt_signal_env(void);
 
 void __init setup_arch(char **cmdline_p)
 {
+	early_ioremap_setup();
 	parse_dtb();
 	setup_initial_init_mm(_stext, _etext, _edata, _end);
 
 	*cmdline_p = boot_command_line;
 
-	early_ioremap_setup();
 	sbi_init();
 	jump_label_init();
 	parse_early_param();
-- 
2.50.1


