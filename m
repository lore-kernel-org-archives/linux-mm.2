Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A482AC531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 02:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 999546B0095; Thu, 23 Jul 2026 22:30:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FBB66B0096; Thu, 23 Jul 2026 22:30:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838386B0099; Thu, 23 Jul 2026 22:30:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5063C6B0095
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:30:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 96041A0BB3
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:30:12 +0000 (UTC)
X-FDA: 85022090664.01.5139698
Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	by imf07.hostedemail.com (Postfix) with ESMTP id A4C0F40007
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:30:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=Thpc9fD+;
	spf=pass (imf07.hostedemail.com: domain of gouhao@uniontech.com designates 18.132.163.193 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784860210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XcvnlsC3HhT/It5VuOwr2y7sGHW1GiSiBgnaGk3guqk=;
	b=pXb9ugDatymtWiaLl6MOlUKjodFG4V5iKodzInE28N5bP6nAnFWLn5M4zrBxDrBnhvmt44
	yPagCGWIlkPu7y48gC4y6sK2BQB2/0sFih6hL/uq2wfQxLDmWwhYe7CimJKQ6zTYV+Wy0L
	zoe91jInpsJNb8b5uFh0rzsrImyVohs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784860210;
	b=Ea/avfMGwtiMNpj1hn5UzQ2xJ34qH62vs8fmoNOJmoKmuug3EcmwlOpmVh1XL+n+1KGJHA
	3xTvbMALyWGrlmN1ai7A+IVVnwvWlOZCswNnl16dxYkl+A3ZV6Pcbk2r7x7FEi7CZJP8HS
	/TjrUFFQcbdAvmHdYISdTWC0iU+REJE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=Thpc9fD+;
	spf=pass (imf07.hostedemail.com: domain of gouhao@uniontech.com designates 18.132.163.193 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784860149;
	bh=XcvnlsC3HhT/It5VuOwr2y7sGHW1GiSiBgnaGk3guqk=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=Thpc9fD+snLZvia4IvIECJR4/9ngZ61H2O5O1Og1QqoADevADqPMz/Bq1/8BXRRWz
	 JCrXR8+gXkama1LSqp+3/GKFYENpvhaX29P6kuiuDXji9ZyCg63LOcE/Yq33QZNkGR
	 BEJyJj84Px6hBhmJtbdXUe181psxM+dEj5Zv63ag=
X-QQ-mid: zesmtpip4t1784860141tf7457151
X-QQ-Originating-IP: mFrNixuyb/9G3t9a9hZZYveY0Gmd34ZMyBS60EAtLAY=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 24 Jul 2026 10:28:58 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9941543075585726979
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
Subject: [PATCH v2 1/6] powerpc/xive: remove dead NULL check after GFP_NOFAIL allocation
Date: Fri, 24 Jul 2026 10:28:46 +0800
Message-Id: <20260724022851.466017-2-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260724022851.466017-1-gouhao@uniontech.com>
References: <20260724022851.466017-1-gouhao@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: MyUUUoyOTIIuc0qvOZTgAWFYtPGeBvErdxgM61UBMZtGYDS1d7YEFbCV
	EC+5aagfWcDwUYtBQSqXmA2Ou8wgw7CJ68r2JzeTCbAyw0A30WJSIlLMZ0syCA2VcnWcY5N
	JdezyXm7x7g4dIdwBt1Zsb6OubMcCBlx3X6G9mSTZnW1t+HJCY/pUC790uaWtXS15Ryhciu
	bVPyhb3RANLomJvpoR4yqUizeQvh5OWR34napoHi/9d6EUlBMmQOqQZDXOIysak68PI2Byi
	SP4GDIKHAkakTIgXDPr+5YAx08BWxvPW8QFghC6LlOFKleEC6lcDWEyvqSdQPOAlb7o1lD2
	oumV9r/w9DTmhm+RDT5mq8+SIlCg3RNrv8KGU0NpBRd4JdU5JTCq+h0UcpAUFB9iFzAqRK2
	41A0krRGGIbDaZJiruMvHioEk0luwe68514j4LbAFb4srQ6/cqyaMT8vf6ztsrVLDbkd2CR
	3nt/KZ2XYCKjhzurtaPO8UZZqAJIFsZ5LdyAHAHLjuirRVsP3o4o/IZn+lCU1UHF5Kn4LNf
	Mna9Zu1id/tT/wzqhGeuraQzLgpMSfLyc67k+dtLqzcMowhYL+/vIpXpCO+U9P9q1ohm9ax
	zvrc0JNqPVMHp51VuyXmz1JeiiWVfXwZibD3HPgzd3CTz2rbCKMcCvbdFaISLD7qzWIa7Yo
	7t90D7fbXtdsRaO4QKBOw4ZzOXi90zBED/IPyxasP1G2+PtOin4oQghbxLy1DBnUfPzkoX6
	PeR62r79L9ZhZhHLfqiBQ95YdzFGbwNxVTxjC1y2gKr35BqD230sEDvNitVoz2LHbg4/urU
	6n+xdK7X5QKmBydiuvXo3ek2SPLFMW42g6j22f5aXiajyJ7hNyI7986z8Sg5v0PEVmVKWUV
	/vYgqgzYy0nbwONyAFwF76W1ANd6HZlQm6pCAACm9SI4Gp6BW+l17Ckz0Hjo1wQjQJeDsr/
	3tRvVuYfmj+ioLwBBDsK+brcU3KbqWiQ/LZ8kVG5QuuB3VrWIjt8hpTBEd4Ox27vYa+8HfK
	q+sPhe1Aj7m7eXnOj4RpSJvqRR+YEe1VYuVu9XyWEkTjYqrssgwak0wykIbqpZXcWy0JQRf
	r+G1UvsfWrBcMIhhG1ayQE=
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A4C0F40007
X-Stat-Signature: pmpgsa1jdbn15wwiqo1izscpcqd6qeds
X-Rspam-User: 
X-HE-Tag: 1784860209-168884
X-HE-Meta: U2FsdGVkX18RX8F4TuiH4jt3aeou+sM4Jb8vpkxdmMwbe1JpgSCfdZbdlEb7blKBEdKni5BlgkxwuQaqiiWfzjHhf60xzpkbBhFGQYZ4i0EMBXk5HTdYRmNQRlIyEtwHAGrXr2/bLA3aSF+HOovydmTqDfJzQwyRDgVlZ4vpq7/lO58AkZNau3mHKBPWw/95gGetaxLC7CufXqygfKqZr5Cz9jeXFz6rbDSvLRBivd9bKsINNbuczdw50+AhwIZ5p6yySQVVZzvCzLdZsaFaXDQEzHRZ2l4F2TyNU4CmHMy7OtoC3dhW1lfIFCNFukrykhXFRtR51M0JVJIcGiGK6CWFfkC898OWt2UUHf1idQj9gvAJvHdS3W6if4vLZZVnfgk7nM0/HJK30XJCqOd3SD1FJibWJmTJEvElXhlYVFQkay7lb1M/3yWQ5m1C9ucaSsI40IWiAxpIk93oSda1knrcoDyyaU8uYD4cEHOzunJDSHcE3HcuteKeNhO8bw4qkyCXQuV67uKO8/DHTYv/bNewyvC3XIhkR0IIOY4Ng6zkaViqCF9Lpel1qZtpG/1ScaY7NClINTiuqPbZznffrlBNOlXQEF089U05Aia2c1cAfXGQterPcEgxTCq3FJA2UMxfsWPhVgAHtM6Qc/CBU+yghRX6ITD9de7zXDNzbCdcjg3Kx8wjY4nLxOtagnGkiWRoxuLqVsuM3hNhWutJjGXkYjO4TNf8cqu1ZESmGySWf/QvQYGqQmH9ca2GtbPtWwxpsNiGv60b06hcJWcMmdvn7D1gscBWCyXBgE3mmT/S9rE1PomWsv+vBDC3ZkvtmnvOwYZWCGNnjpWjwh79HvkwgU+HSaQGMdV1R1arYP7++miLu9jG9ZqJXkZP2AjPWmvUpDxFGIEtZNctuEvJzqn1xFiGOMzPXb7MFxoi4Vmpgr0DqoVQTo91S4OP/MmkmQvyAOZ4TccIFdNCxPo
 tZBHWw0L
 dfTc+ZEU8FCLaU1ZVYJCGlXcSCspET3ZT3vJHNnmgJuMlnGVGOKLq0ULRVCKFVGgZGrGA+qF4hiHsvMMH6wAAdEePcIYzsQ4CX7uBx66DZ9Loc68FPLR6uouawLDT/IJdDhpfCPskvLiGgN0fazQfvJDA7S/hZNu9z53+youcnpAqGbWAHhfbwI8O+5fAiJzYvSiP9rOXz28JFPAK4ia06Bve+Xp15WNeae357zJq6WAW/LkNps+V0VqCpg7kL2KDPSnYBNt26CUesD5oJTOhgQaBpTR50Y9YQM+9ai0KNqHXcMk+04fktUASJ6UmWEhoLcYLOLoBcHhvuNiP7RPhrkEeYw805raUaAG67h5Y4xpZuUKbMKX1sOz/r1DsyZrfPBG+izf3BOUe7V8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kzalloc_objs with the __GFP_NOFAIL flag will never return NULL, so the
subsequent NULL check is unreachable dead code. Remove it.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
Reviewed-by: Wentao Guan <guanwentao@uniontech.com>
Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
---
 arch/powerpc/sysdev/xive/common.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index dadd1f46ec939..f2904a5c2b7bf 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1134,9 +1134,6 @@ static int __init xive_init_ipis(void)
 
 	xive_ipis = kzalloc_objs(*xive_ipis, nr_node_ids,
 				 GFP_KERNEL | __GFP_NOFAIL);
-	if (!xive_ipis)
-		goto out_free_domain;
-
 	for_each_node(node) {
 		struct xive_ipi_desc *xid = &xive_ipis[node];
 		struct xive_ipi_alloc_info info = { node };
@@ -1158,7 +1155,7 @@ static int __init xive_init_ipis(void)
 
 out_free_xive_ipis:
 	kfree(xive_ipis);
-out_free_domain:
+	xive_ipis = NULL;
 	irq_domain_remove(ipi_domain);
 out_free_fwnode:
 	irq_domain_free_fwnode(fwnode);
-- 
2.20.1


