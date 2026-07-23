Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39862C44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33FED6B0145; Thu, 23 Jul 2026 04:19:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0036B0147; Thu, 23 Jul 2026 04:19:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 195FE6B0148; Thu, 23 Jul 2026 04:19:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3A986B0145
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:19:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 762D7803FE
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:19:01 +0000 (UTC)
X-FDA: 85019340882.24.14D8DD9
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6D442A0011
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:18:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=QhTlk2ry;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf25.hostedemail.com: domain of gouhao@uniontech.com designates 54.254.200.128 as permitted sender) smtp.mailfrom=gouhao@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784794739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cfSzb1j3fDLRRpHqQ0EUwXS6MbMulPkc64LtYOOGOc4=;
	b=Ehv/ZBu9fIO7qiRdmzyAULXiskX3HTcs14pJLufUCw8w9UzwvmtWQNQAxO+dt48RuTeW10
	/r9y+GG3SwtPldUOn94THiai5ScjAyiQWYG/KQPD+5Sk8PT/gOp/otbtT6bP+z8hJjKaGG
	7LAKdFwlE4T1Sj3KmsycOx8zK55m50c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=QhTlk2ry;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf25.hostedemail.com: domain of gouhao@uniontech.com designates 54.254.200.128 as permitted sender) smtp.mailfrom=gouhao@uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784794739;
	b=Ytf3JGkiOAIWqX8y5WANK4iuKHXtYi+nJi+y1v8f+agEKGCYNo9aNliG7tN8LBNCvCy3IR
	zX2ucAfUNfbjSOHwD/cBsCpXIXCmpq0Eg051ekgxHAX3gYKKKnYxJ7c4vkNCbzF6NVq2SA
	tpe4RgtvGdNHXvlVjgjV9sx526/AwAE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784794735;
	bh=cfSzb1j3fDLRRpHqQ0EUwXS6MbMulPkc64LtYOOGOc4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=QhTlk2rylcbqdS9qAPvDh8mmMfn7dRUGuIFXLamI390t33pcuwpXBVjvBKx4I2QFP
	 UpJKAAZf3qUQhG+0zS7KemBROPwHK4xkf8iUGNVqmrmMl2fO0ROYDTEu+zN4Zi93OL
	 gCili6F6MrGOcP5QoW7JaXAlziDZUcbz4T4GIIs0=
X-QQ-mid: zesmtpip2t1784794718ta429b909
X-QQ-Originating-IP: bWv97cvpQpUfRA+67ASoV4xpS1e+WkNnwAen4+2FDbo=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 23 Jul 2026 16:18:36 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2455247409279869291
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
	ynorov@nvidia.com,
	namcao@linutronix.de,
	mkchauras@gmail.com,
	sshegde@linux.ibm.com,
	nilay@linux.ibm.com,
	kees@kernel.org
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-mm@kvack.org,
	gouhaojake@163.com,
	kernel@uniontech.com
Subject: [PATCH 4/4] RDMA/cxgb4: remove dead NULL checks after GFP_NOFAIL allocations
Date: Thu, 23 Jul 2026 16:18:13 +0800
Message-Id: <20260723081813.176792-5-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260723081813.176792-1-gouhao@uniontech.com>
References: <20260723081813.176792-1-gouhao@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: OBUGnm9pFasAffgwCaHyvh+utdpS5dxrDBVi/nyJUW9jHqGkGFDjhV+Y
	4K21RliLy1zOExDCE+ZKBXeA392krA/AeDFoP5kfQRefHYtK0H4yZfDSCc9NqBjfIo9Tfgz
	g3Ntx2CEUkocB4d1mGiQ007T7Bm7E8mMFfumsPnYDjDqwgMD25/70ppaNYuBHfoheMffmn+
	rgJUF2idHD1MhVI/vN+4BcY2gradf21ddpwvcybkiKQXYJYgRr530pJlUP5FWzr29XwlD2A
	mIcKvUHzkSCJFBsJREGrXLKeFMzeOFTf6wrjwhzWKYLHqUz7l77MjVMrge3ji1KJvvG2lE5
	Ody+JAUtFG3uQ6fh4u+t27tl/F/Q3yz6jKdgYkn97j/wLCboR2yV6b6YztasoxBNrEvMlrM
	A2aAT0HVom+MXIRLAoxhs7dxZ5EWIA8Vn2pJiU5jIFBCrXkMgdGFvXrvwtfTndS3bJxpkGP
	OMY5cW86gbWpW52pmziQYz+yXPcoDvPaUIoncWGk9YFJe47zQ+H6awcgrZ9gKD0V4zGXTzo
	AnhzypynZvYnWyhfl9cfzhzm//zr1QtgCi7tNZCljyE8vAAVvrCQfJYBSTz5sWsw9Qn2TZo
	NThTR7M9MxkLHimKiTcNd9T407lTqrmVfd2NtjEFbPbOEmSgeG1WyjlNFcuzYEmFvQq40bf
	R9uuoJZ9xp2T/eEK6CXP4MgMHkJOoyqiMW6oSY3Cc5bR+p+3ZQj3cAhgWTgnDd5p8Yt0jbE
	WaDw54BYFZ8affZ6pG8tKnttrp0eIzu4wRvW+RMH5NiTcYmtbVmUBmHD0o3FAUK75O0GRG8
	e5FHbQWNBKWjOKYtAaV+gUITEkcIB88uQfdjoaMLJSXuJwpXQjFfe282ZQSHns3aqr+h5cO
	Ml4tGrsUkzRM5CuyXYFnECLMS4pST4QgN+EUHpMFnpkJcQhOxSSDyxyPp5ecaZgeL1Xa2WM
	eRnD7zqKdt0rEQMZGfs1NFXh7ONLqs7c9f++m/Q+yOHjOarr5Q5qZhTymz4sJ7aepo33jsy
	LbZ3q1jDo2Cn/UFDg/9WOVS3k9sfERFIBq2EMQFg==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6D442A0011
X-Rspam-User: 
X-Stat-Signature: by9ay4nwxwa4n7hahm7nsesubm7fxuhe
X-HE-Tag: 1784794738-991309
X-HE-Meta: U2FsdGVkX19ml1N9jfK8r8RJ3Zj9IByQxTRC5TSlZappgx9s2SZOjQFEl4LFMu14pUxqlMbNwkmz9o2BRH8Os4jQL8NZJoAapyKaWjZhB2Zcifb2WLG/maKzvZ9uv+01z+uTgOztTKpDG/yVYFOjVBsBQGX5K/G8cMc0CZsQDVjvQyRBaTJ+VTy6Ow2MpT8dbcg4QJ8x0eYd229Gv32mMmwdGVi2UeG0Kz6rqsGApOMFFgXFI4bXb39Q1/9hlb+f8YdFNjS5LBHT8JhgM0x5E/8tKGyjxSA5pG31tV4M3QHWrqlpo4sViohc5YtNYxDG285wWpaaZ6SAu0F0Koxuu49KaFPzi7CXLCp9RNKkPeqESZv39DXERiKhpFoZJNId2+tM0CxJr274aZb4cvS8Ntb8wNAaNwNUQjbT0JLiVZPYhC0QQi5PzHVxHwkSdOra1sjaWASNUQ/i+RjyxhEFAn3pfuhv/aR0y0QRU2NMzSGDHZtGRbvBFdUk4C3Tb2asbIV2t6q/43wyoOCybApIyxrYDslxahtflJDjpoG/7SoYebrNx3V+sjB16xEkmKiZzChHwnnO6Rm125pqWtBnIalPmlMQ5bQjl+VlSPprv9W01gzbcOJZtu9m7JBme0wLh/XZE16/bOOnnWPDyHE2W3m2nP+STi+8XcDajtSy5t97xMxbsLaoQQJ/uWCr5XqmdZly7AjMikYR2QFdjpXVOz0ETU5f8T/Tw7lxH5OPwCzvP/N9PPLBG/5kVGOCyJE/oUjS/C/ZHj6HP1tvBbCZKUtZNVyFmOf3jfjp8bgTWxKt7Ll3fbr8JOCeV3inJutWicfzVNTFErRIxao+Si5ViV2pvHyHTwOzdCDOIPwnItOpANhcUwTh+doqyECyH8Jc4mK5PCx71BvUoUbXYa7u/vtMcFuMAqw6nURcgklDJ3dyK+lqtB5qHlGOooPxtHg8Aj6byj6zZ+jj5T8YrJL
 8Xs7gSdN
 TUYIiFELSUXeVw3RKcQeAZJYG3t2fWsH0DhCFjTqKlI/s0RAHX0u8jXKjUxLeaGD1LqYiwulTT2HyKZ/GaMp6ZS+MYuoaq9vhtGpznfVrTirxYtizRRMTipWrPUOMIf1F2AP+dFqge9YP29reA6M9+YF37JpYX/BcxsXiLMfX3cuOTYIZKjFZrts2n6AVPtxVWwUopaSmso9Lge7Eit5rVbb2DNGlwU2ixVFUqDbK2lFEnuA6VQQxSfXKVulOllZ64j2PIwhFNSOtlJudYLj3n4a+pMQeWjeg9ksAXVR59L+S27Gi/W3WI6C7nHdqeQUuWQW0V/zwLp66xIip65C7ZwhCdJesVw9EbmR80p2zQA3KU00=
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
index cd1b01014198..08631de17c0a 100644
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


