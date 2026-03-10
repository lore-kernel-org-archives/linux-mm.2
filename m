Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F145EB1053
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 510996B0089; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B9506B0092; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305CC6B0095; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 145C26B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE3971B4756
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:28 +0000 (UTC)
X-FDA: 84529998336.06.C3705A7
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf25.hostedemail.com (Postfix) with ESMTP id B48D2A0007
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p0plzaKeSbxjl79A2lleHYZjr3IgqG3bFMpzk2gkjBk=;
	b=ekI3DrCHrVtco6+C4EZ612LDA+2uaH0EsGUclcjzpdiJulYbblKBihttff4/RD4lnRPWG8
	n1KQDdonkR6ngYeSi9j50HJl7CRYoXQL/VYM45Nvd1NIbkIx1PF1aoXPeSjUBmVl2g9CQp
	jkJ3AwCbIxvgVFhLv4zxmkfzYnWSeGg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143727; a=rsa-sha256;
	cv=none;
	b=n0O2pcTqv2Oz5z5Xu0jPRjMEkCa9ugoIzrArEvzuntz3bihUAyxccOpf9c6I3S8qhwT35a
	axRolbpae7Y5cprzDFsYyQ9vEbsnTydadDU3/N1X3sxcUj5Y1VN3Nh/sayJIVohye1yTPt
	i/C8xTqSaMgCjjqIaucwYtjG/4hm2pI=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-e21d-7f0000032729-7f000001d99c-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:24 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:33 +0100
Subject: [PATCH 07/61] erofs: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-7-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org, 
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org, 
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, 
 Philipp Hahn <phahn-oss@avm.de>
Cc: Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
 Chunhai Guo <guochunhai@vivo.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1165; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=Wx/k10vuVbp8ZUI17J5Bmoq0XIce6rBC9+YI4+K5MhY=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAXuTWLAsZgE3CYfS0prKIO5oYoR3eM1fSwdn
 +XKr0TQn0GJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAF7gAKCRA0LQZT0ays
 2/j8B/sEd5J2vRHsnvhncB2lMo9VZ5h3+ZMJUztWw9QhmuXX9Qx3HEdJ5GLZ84ct6sqOhNTdJzS
 JFD7aVZEzrOOhcVXC4LBSF/0LTyuRs08pHBx90juaWCHs505i/RK57onvWUjJYv2jNvBVJQQ+S6
 AU4u0SqHLiT0AAUqbjuiM2TTHxhB5xD59cg+mk4rXkCdmvt3sw2+h9McRwE+VdqWIniC4/IsZt/
 lSDklfOcCL2PaTrHCFhWHaM0/yrWd/ljPTRmFceOPsri9YRyl2VkofnQ4LBx/tIitZdlpukR5BZ
 3gdZMB70thXOoVOpRxkVmdjJvHPiGXebLpJqAK8oxLcbLF+S
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143724-8966EF2F-D5F13E8E/0/0
X-purgate-type: clean
X-purgate-size: 1167
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: B48D2A0007
X-Stat-Signature: orugryfegwqaymt6pu395prxd1rgwb7k
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773143726-607309
X-HE-Meta: U2FsdGVkX19PKXzsSpVzyGHXSo9GF/AR5PFyODfo+AwVIgapxFHs4cpvHmzxt4KIetsSgDicvLiETonWDWOcqcHSsMr13LxOiqzkeoeX4Gds7Z6ussPpogkFSESUXY7X1ro3jJ4n8+2pVGJ49nTH+WEgOPiYoImjyXYS6hzKzoFgiC5db7VDCpJnw9n6xgX8DtsoKDKTctX42ZbtLJtkMxFjzQZ5BVcDMf4yYJmJbSc8Hy3cmiy2srX2o+9nJbL0/+go3apOmehaVnm24jtbvxYFMHEqVYPH4ACHdlawQ+hEmi5ZjuPY0/ms283yDOeuHY6CBreLhz+foisGbDB1SGvhuuWZGKKayM6/zpd7VQzp2bEy7gN/y8vD5okD0Y4Q4+zdwqccvl9Ms6tlwGaGKwI6M1eNKDApQR0nCRK3f7ictTKDU9Flgp9lmgrCHt13T+Jkk/q0N0217bfuDxAQxPcgSp66VWd0CymWftYrK0/nLRosUHEDqTjk8OnqYkEsJOkz7TCsGj0QCnRmbygB9ygjwAUMc2mnY7RzuFBixRXks5sysyFslPJbpV3Wd7ynpZ+YcB7Or/CO5lJc+JbitLz9oBLU8/9XmepXshQaJJ+Jjeo+MdVYPalC3EStGh4URdgnC2CQpwXU+HGgfCc64SGVCJBh96WvMWxvwPyn5/fp+WVd8SBiKBx8N+8vn8sQXzdbzpICF/RsQtdX1TInX78ms6PDV7vJGCQRjf/tkoWSr5BgYEvEW2Nfdds6oqt21CiVCnYW/hDowqI+Wz7JNZ2Nr8rfGLMUiGYXO2m6/Nr5AfDbUGKlDtN9F9fyfvh4fxSsn3t2YqpXCUjU36DQI3ZSr0u3q/VPXmWzMWW5DEg75pfOg3cYlGwlB94GCjmt/miyR6jCkxZSindvL0LspenENt/ChT1B7SY3m2iupVun0J3Bdqj9mzDtcGorwxg7JT8saySYkLlQrpWK82Y
 s00Dr0Ex
 mGktSk/2VZns2QAZOJzaFn1XnlJExGyftY6gWlpW+wZxoq4Wlx33VrVzg9ZULxaW7vHFc8TZB7JWh3e5nvpHxFM6bZIq/YQcN/9sLfTjIobjLhumy0///WBJM+Y3yVdVS13p/LgtTviLR3cvY0TgfoA5Yz752HgPXUVpjNJUCObZkDz00sjLx1QV6bNc7IPosRYscLpBhZenIZXlHA7rz9Rl+g7rPC08+UA1HV8nGuxy0OqrRyWnGRWgPED9E0swC0+oI/dMUX/HVCKKs1F2RB5/OuCCcoF/0KoF4Cz1sM+DtUb+wJha0/o82yDjPFl3QodqS8W5brL4JAUq7VykB0M7ePzJ1VBAGA6g+85bCMSKfTumuOZ6pLuIS/knloq9ul0iDLzOIeWq/TM4fbi75yD8yRKHhTkWORqZLgfCReO1+fvE1ovpvB0iod/KkAQexeNj2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Gao Xiang <xiang@kernel.org>
To: Chao Yu <chao@kernel.org>
To: Yue Hu <zbestahu@gmail.com>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
To: Sandeep Dhavale <dhavale@google.com>
To: Hongbo Li <lihongbo22@huawei.com>
To: Chunhai Guo <guochunhai@vivo.com>
Cc: linux-erofs@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/erofs/zdata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 3977e42b9516861bf3d59c072b6b8aaa6898dd8a..88c293ab2b1ef7962c6f5c0aa82639859e41b8e2 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1227,7 +1227,7 @@ static int z_erofs_parse_in_bvecs(struct z_erofs_backend *be, bool *overlapped)
 		struct page *page = bvec->page;
 
 		/* compressed data ought to be valid when decompressing */
-		if (IS_ERR(page) || !page) {
+		if (IS_ERR_OR_NULL(page)) {
 			bvec->page = NULL;	/* clear the failure reason */
 			err = page ? PTR_ERR(page) : -EIO;
 			continue;

-- 
2.43.0


