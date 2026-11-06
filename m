Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8FB7606D802
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Hl3o2weq
Received: by kanga.kvack.org (Postfix)
	id B351B6B05BD; Fri,  6 Nov 2026 02:15:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6046B05C0; Fri,  6 Nov 2026 02:15:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986696B05BE; Fri,  6 Nov 2026 02:15:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0736B05BE
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:15:12 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E62511408E0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:15:11 +0000 (UTC)
X-FDA: 85403832822.28.11BA4AF
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id CD52140005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:15:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Hl3o2weq;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793949309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+m8DC4cfdQZ3xwF8aoJbUjRqYnCvVbB75BJhmdshTY=;
	b=NiQ4DwMSPmf0sn5k9kl9+0Eb5TsfUq4vYfBQpcf1mIQugHaRsujK6nk3iF+ZRLpvVk4Ij1
	V0SThXIcaJG33kNxXzGUdji4sYYDbnjNRfZnVB2NOf78/ZAk++SP51QScGGXp23Uc/y7Mh
	mKKRHSLbmehvlYkPLxDQ+GNaF9nVOO4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793949309;
	b=KTciaKBUFTyu7tPkmbP2KLUujgLqqu9V08U2zw/9EyhmSM0Tj7PKCo8P/WugJAYoRGDIlv
	+bLn3pRg5Sc+j0GRvzPjuK2AR0JjuZW/KqG2llzyHt3rkIASEW8cwcNj5Y8w4bXxxLPG3R
	MO8LPO7Q+hWp4YNOTUgKVTAXr9x50JM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Hl3o2weq;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793949305; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Q+m8DC4cfdQZ3xwF8aoJbUjRqYnCvVbB75BJhmdshTY=;
	b=Hl3o2weqnkZwsYIusJDJryh5AJmTnOZWZcfU4b19UghowGy3k+O08szVVPnN6JFBN58y+ixQIXkz+lf0/LsTxTW2BXFlSTZTiXfRwSGzcQfQ0KcgFtgOuCXTTPvv1GWzUEwxXs7h+2stdyf4NGWh9qOc9IBnGwTbc7yfs2Im05A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XEAtjMh_1793949304;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XEAtjMh_1793949304 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 15:15:04 +0800
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
Subject: [PATCH v3 1/4] riscv: Call early_ioremap_setup() before parsing the DTB
Date: Fri,  6 Nov 2026 15:14:56 +0800
Message-ID: <20261106071459.2003-2-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261106071459.2003-1-cp0613@linux.alibaba.com>
References: <20261106071459.2003-1-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5z13hfe8gw9wrx5cbx3ij91a5mf5z76f
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CD52140005
X-HE-Tag: 1793949307-983880
X-HE-Meta: U2FsdGVkX1+fp33bDGL9pLeghoC0S+eszhk9YozQv5fmrRQXoae+S5V77UHhRQA3ins7rUQVubF8yo1FLkvyFGoasOZRikbcXuGYYm67O9Yc37g1Sj4LtxyTOKAfXfqJ1os9xHH4MpJGmHiGvtHP94NmRDk8qrN7tB4myrvNJ89qkwAOTuX86V8TktnU2R6nrhEmlKSGCLHGor3sIqgjmiZERUx2XCrcKJ5fPdKvAGvjUNjAjkQmoPwWLu0orx6bo7n1HwiFxq4+yE6EcAZYJbK5/BzWF9alDOFnZa77BWn5cCv5uzThMfsnSIWU6IUt+e+mRxytOGYQM3PxyYMPeEexrIUdemKS0h55/QR86zRyqn3QLsDvkY1j/KPd8WCqpwILX5vF+S14020XI1p/gtm54vomdZSmLNoM8i3mwwIzyo4D1922ruZ/OOUVyxtscGG8Pi+R1ASyeOBRn3gDicAGMkFm/jhKDFgOXTyuWFZyAOeZYdx1RwQvPJEK3IWbElPL2NJdE4ThWFWTJgcExJeo2uv517L29QvlmcBx44Fra0Ni7+QxlNTSwUAX9vZuF4v89mIODHOo1fEEkj3QW3aqo6aTSMJ8cdbFx1OvglJzSVcP9uyYqCdStddngistacXAXVHtMkzQowIqO/PxWPJVHkrZ/MF6quJn0k8zkyDRoO0QsFIP6WOgh/lKpGnXnXKZyEhsF1LLt2h64Hxtwlp3Us4/Xul7dGKgiToOzkk8DnsQ8oZZIcVwYnGY0R2t2pacOrTgd32czauYtXP1Pcy6VSQKvyx5+AVQG1S8WjpriGdn3NE8HZkM6aNoi37Qpt92A+dtb+O8nFPODuxKvLoQLyra9Mv2SzcgNxosHY9H/ffMJ+oGPxZMeF3hD+n1tXGsxUqdpdMsZYy7LNYDoM5CV9/I7qoiIUZhBnQEDprEC0TM2jLKAsosqWA5A68vamEKnb5Zaue9zcKnKCo
 2mJF2UT+
 axhtrFCafrfxIShAg6vj2ScJGk1kMhDMx7scS2OCSYB8lh0JxeJUtYzxqSMt4NOO0hLWyTB80hbIEcIt8rMDzxEvel928aF5MG61ZZccDKVPgnQ9NbPzHvIjrxmj0YzGP1hAsHodZDo+fzHGj057XaLRUpgo/v9Mw1BoCZOqpdIpm20DonwDyy7a+UgrXsaQ9sraKt6OvUv/0JiAlrmHZYKLWkNFYUJijCSKl+qUkoQ98/2mDTaeGt1SQ3NviuyaIG/8kmxZRdDj6/QB2fAM8uyTjsAcvWZPMsjcrk16qYT4iVIQ=
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

Run early_ioremap_setup() before parse_dtb(), as arm64 and x86 already
do.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
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


