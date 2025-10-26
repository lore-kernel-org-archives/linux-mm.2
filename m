Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D356CCCD1A5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 16:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5CA68E0170; Sun, 26 Oct 2025 12:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33CD8E0150; Sun, 26 Oct 2025 12:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9227B8E0170; Sun, 26 Oct 2025 12:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1548E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 12:22:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 00CAF160317
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 16:22:14 +0000 (UTC)
X-FDA: 84040782630.26.B59268D
Received: from cichlid.ash.relay.mailchannels.net (cichlid.ash.relay.mailchannels.net [23.83.222.36])
	by imf06.hostedemail.com (Postfix) with ESMTP id 13D85180006
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 16:22:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b=gl+m3rbk;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1");
	spf=pass (imf06.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.222.36 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761495732; a=rsa-sha256;
	cv=pass;
	b=KyVDmNxUYcCHkKSlKytiJE3w6adcJVnjlqJtXDMR8cEYTHkKKSJwedbss4X4sz0pHVrt9A
	jBHZ5qSZHDF+AqxSZf/u7ZI9qXhT4WJZyUaTDpvnvWOavEyfpbWT8dtRjvYSO9HdmdqW/q
	tA5GHPaK059s66g13sPMjbW44fzqJXw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b=gl+m3rbk;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1");
	spf=pass (imf06.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.222.36 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761495732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MM88zLJ5rxpHST/Heh+0Np7jYGHxRTupznLlA+uOGBE=;
	b=3a77wN1BZMpoxetMrks1wuGu1WxruaCu4xpVQGM9XZs64Tx21UXjEQ2Nd/XtdsRhfNoD90
	XPnaEQpIfhVZeZswmcSMF30M+gDVAnWvqu27a4VGDARVmzMTz6kfNXQfZvP5Qnb18neXxn
	YuXJLxhfS8AQEQiH1GhuBZ+PhobqtOM=
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 0CCB9362137;
	Sun, 26 Oct 2025 16:22:10 +0000 (UTC)
Received: from de-fra-smtpout2.hostinger.io (100-120-23-87.trex-nlb.outbound.svc.cluster.local [100.120.23.87])
	(Authenticated sender: hostingeremail)
	by relay.mailchannels.net (Postfix) with ESMTPA id 3E114361B05;
	Sun, 26 Oct 2025 16:22:08 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761495729; a=rsa-sha256;
	cv=none;
	b=BfSrpQ7obPY04xoNL0gAfYkAZVkVnU5RK49Dz9iphXualZezzKbELAQC57YzdnwPcoZzwo
	SWkUHBkocmGJA459vHbaAjRJJuGYXe/01GVWHPbsHfSUI5CKwbnthxfcOiyZ0nlvl/8rOu
	05XwvVke8cfe8mOb1wZW39UYuQi94lzRu2qgCLdniOuybrGfC9+blUvYW0Di0EDS/J8lDU
	08b816+aHvDoOISeXJ7nrtAk/49xwkP6IE78XbPfzpflo4dPpY8euH9w0TCMErY7zyomzr
	VWRA37jocymQPZFf6vH+H3G5AIhPq7FL4Ym42zEXnlOlew672t9XWafCF/1w5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761495729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:dkim-signature;
	bh=MM88zLJ5rxpHST/Heh+0Np7jYGHxRTupznLlA+uOGBE=;
	b=N4fEQpE95EnVLMAH+EwnQ2ioK3PlBNaBAbMLSf2LNyUwgFSWe9Gjx3nIvu0JYEe/waOuPb
	8dfLM3Tz6FE5gQyuuAdKxl84oupbY9MZWoV2oKNRSv05AHY6eolGBejUYOvgliMsDXkLKw
	H6myH4izaW5fgxLf+cMLnJpwsGYeNbF0rSMq4Z04/GA7L+SCKzhjywSKUT3vXDBn6AYpsK
	plWncSqXk4lPANBbtLn5MFhpSfiEscbfW4qao1jxz691oWOoAxOps0sXvLU3DKS4C7piW4
	OPo87aVbLdaD0UcY/iC2p3rFX6eIEBZXdazRkSwDT2VOXUk8l5bPMSzxxzt0Yw==
ARC-Authentication-Results: i=1;
	rspamd-674f557ffc-8hdz9;
	auth=pass smtp.auth=hostingeremail smtp.mailfrom=linux@israelbatista.dev.br
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MailChannels-Auth-Id: hostingeremail
X-Thread-Thoughtful: 28aaf1236a54f91b_1761495729250_785022570
X-MC-Loop-Signature: 1761495729250:3874482419
X-MC-Ingress-Time: 1761495729250
Received: from de-fra-smtpout2.hostinger.io (de-fra-smtpout2.hostinger.io
 [148.222.55.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.120.23.87 (trex/7.1.3);
	Sun, 26 Oct 2025 16:22:09 +0000
Received: from fedora.tail0cc0bf.ts.net (unknown [IPv6:2804:d59:8970:3b00:5f26:e2da:68e6:2358])
	(Authenticated sender: contato@israelbatista.dev.br)
	by smtp.hostinger.com (smtp.hostinger.com) with ESMTPSA id 4cvhjn1PJ6z3wbs;
	Sun, 26 Oct 2025 16:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=israelbatista.dev.br;
	s=hostingermail-a; t=1761495726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MM88zLJ5rxpHST/Heh+0Np7jYGHxRTupznLlA+uOGBE=;
	b=gl+m3rbk2Gujv+1wLAFmd6mDlAY/Xy70SKXZkd7lRmhWBODteq5Xx3B1Q/GCzURYbSe/PE
	Z9QNdBnUGLXngeTolLUkpGLyEV+Vs+YjpmZpf2Utt89W/O3/UJl61xKpCgcUc1tBmNylGL
	r6RxVcg0Zkv07Jyu/UILuz6Hj8qGYfORSvtrXLEuZ8cOKr090KZsq+y1+p9U/oQNqo4x6A
	KQt0lLOqhsbtx5Mjv/k3/kTayPAVW2XoogLjoppiHqtB1Qjz8UfcAo+PAPbV9Itjcs8Ldf
	1j9luxM2OIm0yOXj3HgPpwXKvbxvE6JO2ukHeAr4e+naGjMxbJHE/oitQ6UnrQ==
From: Israel Batista <linux@israelbatista.dev.br>
To: akpm@linux-foundation.org,
	david@redhat.com,
	linux-mm@kvack.org
Cc: linux-debuggers@vger.kernel.org,
	Israel Batista <linux@israelbatista.dev.br>
Subject: [PATCH] mm: Convert memory block states (MEM_*) macros to enum
Message-ID: <20251026162156.12141-1-linux@israelbatista.dev.br>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Date: Sun, 26 Oct 2025 16:22:05 +0000 (UTC)
X-CM-Analysis: v=2.4 cv=Ceda56rl c=1 sm=1 tr=0 ts=68fe4aae a=WIeu/gG1zxr2CnNbFFeIHA==:617 a=xqWC_Br6kY4A:10 a=vgun6L5qt0XZy9YrhB4A:9 a=TWtOS45hTxhqQf3p7L_t:22
X-CM-Envelope: MS4xfEAzvQr/tVdCv/Pvsqfxu03jvQZ9r4K622GFFLllRo+gOZuz8VrMe2eXaMabqLDMI/I593auInNWEXoFjW0t19MwcPQPrPWTI/1JBDlNJvYPp3146tPN h36mLo84GmlwAe31XvcTV8jV8doezGSotbYg2lAsKFt1lL8UR7IdBjBI3vAErmRthKjDgtY3rlmLNJV1j4q9SmbJ+sW/8KnDU0+gQs5L62RL7LpRbfWSa8Np PKdSPoCrRI4qKNej1QBdrFcXd21dNu1OzjADuyA8+Cfiiexa0jtr9HyZ4UA9XPS/PV/9sriReLehl8ba1wwZu3YHI1agK/TvSU0lXTIYiLeeVlWDQrfyAZiC +j/zAbBPK892lvH+JVbPVZtQOBPClop8BHAKTqzLFst0Sou8/VaOpDCvuPvdx3ymoQ/7r0RY
X-AuthUser: contato@israelbatista.dev.br
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 13D85180006
X-Stat-Signature: s79yy8y6qt71fbt63rhmbc1sq5ne7xrc
X-HE-Tag: 1761495731-572636
X-HE-Meta: U2FsdGVkX1/VMhXPu9i65N7PvmhM5Rsu5i3FnfeyC4Os8HzUlVLiRTOnOh9oI/M+i5vY3p6PD0Mnfjl9bUjzC0loaYmyY8Lxcc6FRTpFlh3SKVs8JDVVjf0dn/e6VRflKmIzJRZ+kYQ4fBeM3CJpzCaf6wgsb/YuKh0Lms38TaA9ygF2Arzxp7P7ZS5GZAIvYvXDxCzj+Qve5WdDg5ihl4FLA5Zb7dAC96pVuCDwLHKFB3hb4KKuI+glgjBRfgbmiSzawtGKwVtEfWtN5JWJHw9u5x5NO4OjWOnzDURxcEOlhLe39E8ZYLZSg5MIS5ht4cfyqOgKHaN6jFA9Js+8C6QYZnZS2xSZqxFTKejP/D/jDDdRLtzqQn8wYLWDpTXTAd09GIbjP+GpFLR6t0rQtNGDE6s41kuciL5Gi7Oop0xgmM1hFdi/vbFSk8uffJ6YbmnrOnhtKL/54D6y2OR5VKdQXk3Fx53U5zk8NG4qL9lCeprGKwByUZ4SOCCMmqCZus41vG7tU+rJ9V6mzEtktDIJYA9Z61zQdtbB0YLswxygt79ESzI5UFaR+W+6ylWvFS9Cz5ewEP/FrZPmmH7r4GRtLiijcc6qZu5lgQuFL5s0Zz4hRV4Idwlccjm0sW1/U/QDSn5U7pcXvm1OspRTNiAjQTLo3ks8729XeZoZsMZj0OBNt6uySc7dspsDvFru+8FiHqugovceUVeZtVvveWA1R08ZL2kMauF+0cD+Sqq2BQATiVhpBeCdcHVMNiAlnOhmcI/jZ4Psb3wIL87nO1Q7qh+kVtc7SJ81vxsM4wUCM6TGjbauveafuX+zcRNDlN8PXThDN1UwyRUrzpCPSWnlW6kKuky6Jk64fEa6AHg+7+HXTmHKGud+Qd4oH/9hnPJOqTIJjYoOwcNWAlVHA1LXuihl+ni75arYY63fpuSQhUUVQNhSWGJJi6P7UjuVGgHiEkEFtc6tzN0LL3Z
 +Wh3vkkf
 FfNhx9usgkzZ5p9lFFk88SQTeVhP9qItaiyf0LTD/lDtUKv0Z/GDQGGThh8c59y5afA7VLsAku7ik4XfW/ue/qZqeUBHQDQqZsrNrG0bk/OOrL1Q34iQQKYrFr1b5Wqftcd+Jk8yCal6BuCtZOFS8b/kHCshcdogGPlMH0+wd4Zcjcbv7a434DFx0oeoInN1qa7VTBC3LWVTZBozzz3CQm+UfPGUy6rmALovwKNCdCTqar9FpgRkSOTV8mvciMz/mO1ARGbM7239XVeu4jsVtRUyLG2PCEerR6DsdSN9hU2EszvVCxIbCh4jsWiaL70YfNZcIY/IGZDK/uJVXKEOe0yv17lf+ij+jxlJy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000054, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MEM_* constants indicating the state of the memory block are
currently defined as macros, meaning their definitions will be omitted
from the debuginfo on most kernel builds. This makes it harder for
debuggers to correctly map the block state at runtime, which can be
quite useful when analysing errors related to memory hot plugging and
unplugging with tools such as drgn and eBPF.

Converting the constants to an enum will ensure the correct information
is emitted by the compiler and available for the debugger, without needing
to hard-code them into the debugger and track their changes.

Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
---
 include/linux/memory.h | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/memory.h b/include/linux/memory.h
index ba1515160894..8feba3bfcd18 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -89,13 +89,15 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
 unsigned long memory_block_size_bytes(void);
 int set_memory_block_size_order(unsigned int order);
 
-/* These states are exposed to userspace as text strings in sysfs */
-#define	MEM_ONLINE		(1<<0) /* exposed to userspace */
-#define	MEM_GOING_OFFLINE	(1<<1) /* exposed to userspace */
-#define	MEM_OFFLINE		(1<<2) /* exposed to userspace */
-#define	MEM_GOING_ONLINE	(1<<3)
-#define	MEM_CANCEL_ONLINE	(1<<4)
-#define	MEM_CANCEL_OFFLINE	(1<<5)
+enum mem_states {
+	/* These states are exposed to userspace as text strings in sysfs */
+	MEM_ONLINE		 = (1<<0), /* exposed to userspace */
+	MEM_GOING_OFFLINE	 = (1<<1), /* exposed to userspace */
+	MEM_OFFLINE		 = (1<<2), /* exposed to userspace */
+	MEM_GOING_ONLINE	 = (1<<3),
+	MEM_CANCEL_ONLINE	 = (1<<4),
+	MEM_CANCEL_OFFLINE	 = (1<<5),
+};
 
 struct memory_notify {
 	unsigned long start_pfn;
-- 
2.51.0


