Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34616C531CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 02:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 185E56B00A3; Thu, 23 Jul 2026 22:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15DC86B00A4; Thu, 23 Jul 2026 22:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09D646B00A5; Thu, 23 Jul 2026 22:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D6A2C6B00A3
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:31:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6064DA01C3
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:31:54 +0000 (UTC)
X-FDA: 85022094948.24.5F681FE
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4D8F7C0003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:31:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=JfRBL6vG;
	spf=pass (imf22.hostedemail.com: domain of gouhao@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784860312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yn0Gyoe5DqjP71R2buJi41mG3iZ0k1ZX3eDGImr8Sq0=;
	b=4BEmeiETWmLYW5X9XM7GucWEXiU8roQIp9i53agA5Ud9sjTJes0ZuHV7BF3NqYtY4iBMGK
	jiMDmK9TdBHoOxorl4igxw14G7pE+Bk7Atty3l04E2zqac7k/RPvAAfS403+XhuJsav8z7
	V9eC6AXhdhII/eOrWYE0BQYpGiPxCeM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784860312;
	b=KJBcx0TwQKaRPcNeMnyBnd30L6PNAoZoE1X29XxHrXy/kJMUJQLpeaQcBo96LmLFSWNva3
	u6pfFFQLAeL1NMaPypWDQAwS6bubCW2U9bIObthhJvA3/tYHh98xN+4wQUJvAgJYg8hQrM
	eGSzUsw5PRop8K7oU+3iQHhlYSvpqvs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=JfRBL6vG;
	spf=pass (imf22.hostedemail.com: domain of gouhao@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784860173;
	bh=Yn0Gyoe5DqjP71R2buJi41mG3iZ0k1ZX3eDGImr8Sq0=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=JfRBL6vGX+km3YMzXlEy7HJjnZqr5bN52rjPOVAQnKRIbluO+xg2UR2JNwgYqwD0z
	 SXyUg4OftBJTjKaq6Dj2Mo8/uGJrhggOebDVx6pkjdosAv8MRFez9vbIMWQeQE8m6Q
	 WIIski7wchHE/k3u849ZwaM0Ku3cvTGxYk+Yhn7A=
X-QQ-mid: zesmtpip4t1784860167t2acc5bb8
X-QQ-Originating-IP: qIXv24m5LF8xLoOUC1kXo/DM9tGPxEiRVtvDS4LSMeI=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 24 Jul 2026 10:29:24 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 530311859156334886
EX-QQ-RecipientCnt: 26
From: Gou Hao <gouhao@uniontech.com>
To: maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	bharat@chelsio.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org,
	gouhao@uniontech.com,
	namcao@linutronix.de,
	ynorov@nvidia.com,
	sshegde@linux.ibm.com,
	nilay@linux.ibm.com,
	clg@kaod.org
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-mm@kvack.org,
	gouhaojake@163.com,
	kernel@uniontech.com
Subject: [PATCH v2 6/6] RDMA/cxgb4: remove dead NULL checks after GFP_NOFAIL allocations
Date: Fri, 24 Jul 2026 10:28:51 +0800
Message-Id: <20260724022851.466017-7-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260724022851.466017-1-gouhao@uniontech.com>
References: <20260724022851.466017-1-gouhao@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: MNU5/P5d/Qy9RNPRk664Q0Xw109pxpzpMGKL379ZUzcshP83H9MiEsd1
	IyV+Onok3MeRQ1T+ngmr1xzbcU1xx+vFpwEVY+wuxNIJ201zV+NLvRFmflO7umpKgp1BOqJ
	z96wlYlqfUeBqPpOrRu4Laygf+MwqB4o3eF9GDKsAqt1h1VQsiKHgtTL078FspqslJclih/
	LSAdIRnaQcF3IsZ1FJYVJGUgcyRdHm3VLF50Ti6RUr0HwtqBlNFPHlKZMXhexrgtrw+Cphc
	JxY4JP/I25QaZKybpvkHDPy08pNjAmBdVxjk0nf/6T5JalR1ahtqR1+/MMoONxBhdS2CsHv
	xV2HJAgpiNZDWaaU5uNCEb8xAmJQqQRbeOo4oMDIYKkBIknl1Y2SKe2EtrMIhYHgYrLnR1p
	gpvduyt1R9gOS9tB9ky8rDkPS8a93XY/5/nFLCw526fv+nxxOpLAPFA2QeC33sEk5hEOIoj
	jxlWS3gKZXLrPbp7sz3IgyUWYT0KgMJmS2eU/TrQmKHZqCf+A6FEOh7ojp1+ZCsflDc0So3
	hDt8vEmZCr4JboY7d0ioM7Ik1oPszFjKauAqy9I/eMTzw4T6SC74qx+BWS6DHBgdpmK4EgZ
	+oSX/7H/vhqwP6G+ZcKjg9apZetYQghWsY00AzS6acYNqzs6N+6O1s28hNCPtwTflFQ29Hc
	j4Wm8jlXEFJwQ8dF/uge/PUGtom7egTNBopX5QYvI6AqFuNpql4a4YCGllUNzkHD+EB6hTY
	1sXdeMhMu5RMuOmHNYdgvRq90t2lH+BpCB45/yhvHe8d+b4mo8a61E5Tmr3FyYtwYzQ2C1k
	g50UjxEbNb63M5p5MDZjalDvYBmhXZVavsT52GOJIoelTYVS57GN9n+2LsZuRhmYg3901xe
	TZUqUqMPxqlw9dxzw1uzo5NR/JK0hfLbc5BRBqhys6pO/TYlWDrDUomU5GAa6KikVlW1Emx
	7zRhVMRn6Gw+Kpk4/7xPqX4HtdKoLinAtIJM709TwoMwB1MvH1A2AobZFepeMpyuEHBmEsD
	YCa4gwXfwzozIlgRG18qaCcxyGCN5lPeUDTUEgeScH5/oFd5PlvpxkI5HE4sGUDT4K5RUPf
	PQAKWbWwxwx2FrvruhkVRaqZqEn1ylT8XAY5Ly8DqJqJwep8AItIZU=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: gso5ww5z4e318ihwft4hz3g188ndu955
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4D8F7C0003
X-HE-Tag: 1784860310-545005
X-HE-Meta: U2FsdGVkX1+R3U30vXqXa8B+BZTBLGHQ29I1pfrDzZVy17umMmjVKegWllQFQgmCtPBUk4eqbBwCg2IICZYvqX2ZsqoJL76BjsSwJ3xI7qDXlax7LIOjEGdJEAA0olL5tJtnTRNYG/Okf6RG/0q9lnhiPEONbc5KB93nHJJ0o2e+9D51BbxIkfYnY7Q5U+g5EwmZFclcCh1k4Jlp8FMXGWTowXbEGwDSr8uUqmVPt20fSWwgMQUw0jL6H+kD0KLByTD9lSww4WokLMKAZvvLvfEhfFcHDjVLJAyMF7Mm30j3xPjNPN7EWPT38Opx9xdhjd1BzOfehNM7A2+Qf7unhEnOnHEnnz88TYIJdOKz/CG4Kuqzjgbd6Wxkb3HGJso6Xl95KeT57S+kpW5zKo0pTdLIZF0VHbRwHYn2205o32W4QsCDuD/HjAzQ6XliBVnCGELJiZ5qrmi/PK0x+6jA0KJ9uL03j0Z6euFuTCKKcgJpyXb8InzZKtJr8FXcRUwskPB9/lURrOfbVENhCCvBpNK15QbUG1jgRlgtLKhE1lcAfaXs+qs0LNp9aRAgMsGDzAfTXGEUj167t7euz63rCajKUEHq7na27UzRnQyvn9TcefE6ZjcmR/lhMEFAwR30dvhVXaw631wjL6JX6OeTLiulsNn/ht280PhOf3YDHrSdurH4Uh3O3ceDF9qodvh6gLkfj5maQ/waqEeiA1WEZbhl9q3yEQv6TvC++aGUaxf8LBBC9xWphPzSOtEDbAxTRTEc8kM8CQ6meZIKDXp9yq03RnIetqQ8eQtjye/G1tijSqJTey87JfiXdO6YhfNcKenZepK092lfjJxREUL6/ofahymTFrEnxNErZsFv9Mp+7UddydhqLRZduKyGtBrNO5vdJmqOhqZzmU1D5rr+RdZgWk/bxR5rM1Y6SJEGqkcKJ1iygfhVrNgZ8MxF4pX2mErlZ+ulrHAIMCU3ieC
 9NnUGump
 i4E9WLXJEHO2ta6w8eq1qbop9eMqEqbC2zDFNYRJFR7PgI0pdaAqHeMGbNNFSZGN7rmTaSuL5fCKVLyVy+RAmrD3y+KOPF4zP7xaYbDTY6eh++zUyEetV+QNoWdBUhZhpBHPtlMH9ZXTlfZXhu4lXhqwoQF9+Hwxnd4wcnxvAV6VjKu+999r4oc2TyDWWFAl9tXylt+AKFhpw5Kw/fDbQrT4Uc1Znxiw7lE3pkJ+MRLvI9RSV4apxiqkmMfNxuivrtpFaiEhTEKNmjcTWOsbqDseFdYaSxcWM6WzIz0eherkJCITR/hvGDatD3I6+Uxq9r/UotMZbp1qMnf9/rzKGJHBabR9AODc0Vc/0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_skb() with the __GFP_NOFAIL flag will never return NULL,
so the subsequent NULL checks and error handling are unreachable
dead code. Remove them.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 drivers/infiniband/hw/cxgb4/mem.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index cd1b010141984..08631de17c0a3 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -74,11 +74,8 @@ static int _c4iw_write_mem_dma_aligned(struct c4iw_rdev *rdev, u32 addr,
 		c4iw_init_wr_wait(wr_waitp);
 	wr_len = roundup(sizeof(*req) + sizeof(*sgl), 16);
 
-	if (!skb) {
+	if (!skb)
 		skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
-		if (!skb)
-			return -ENOMEM;
-	}
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
 
 	req = __skb_put_zero(skb, wr_len);
@@ -134,11 +131,8 @@ static int _c4iw_write_mem_inline(struct c4iw_rdev *rdev, u32 addr, u32 len,
 					 roundup(copy_len, T4_ULPTX_MIN_IO),
 				 16);
 
-		if (!skb) {
+		if (!skb)
 			skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
-			if (!skb)
-				return -ENOMEM;
-		}
 		set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
 
 		req = __skb_put_zero(skb, wr_len);
-- 
2.20.1


