Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83030C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 06:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3895F6B008C; Wed, 26 Aug 2026 02:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3123B6B0092; Wed, 26 Aug 2026 02:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3BA6B0095; Wed, 26 Aug 2026 02:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E64C06B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:30:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5661C1402A3
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:30:46 +0000 (UTC)
X-FDA: 85142447292.04.006FD7E
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 28CC2A0006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:30:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of liudalin@kylinsec.com.cn designates 54.92.39.34 as permitted sender) smtp.mailfrom=liudalin@kylinsec.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787725844;
	b=7IqGEzy77ePJW5kGxghhZismhTPWP9uAA+3S6p9hcRb3W0ws0mokrKcvTUKpSD7+2B1BDH
	eXW4dTV+Bxnz/xL4VX0+DthtGX+zTw4Coflbs2CG+PpMxlvMoMhWlm39UKABd1ams8HkWs
	ZF6a1cbs4U8GZ0PowB1FKHJc+Fzwtvc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of liudalin@kylinsec.com.cn designates 54.92.39.34 as permitted sender) smtp.mailfrom=liudalin@kylinsec.com.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787725844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=NaMcK1mHk++nTvXqZQgclcZOKcCf/XfU6jkUKr1W8fE=;
	b=U45XrNHoPD4x/HdRzQAGIJ5zHPPLOsOF+87CRKbFDap0Nit+cKPANma7bAoVTLmXGaMgMx
	+h28jAGa0f1wTDGlgsFXpX3wXWnj3R2qcFZcX2s7zj1EFS619nJll62w3SIA/qJUAa6NSf
	lp8KhKqMwsKjYCamMwCPVTS8T2yRzwY=
X-QQ-mid: zesmtpgz1t1787725824ta8c5bcf2
X-QQ-Originating-IP: XoYHGViZHRkF8grjBFcf1wFtpnwvYS4ldql6RKskZoQ=
Received: from localhost.localdomain ( [111.8.45.130])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 26 Aug 2026 14:30:20 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 4632055950645483182
EX-QQ-RecipientCnt: 11
From: Liu Dalin <liudalin@kylinsec.com.cn>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Liu Dalin <liudalin@kylinsec.com>,
	Deng yingchao <dengyingchao@kylinsec.com.cn>,
	Qin yungao <qinyungao@kylinsec.com.cn>,
	Luo Qiu <luoqiu@kylinsec.com.cn>
Subject: [PATCH] mm/gup: add NULL check for unlocked parameter in fixup_user_fault()
Date: Wed, 26 Aug 2026 14:29:43 +0800
Message-ID: <D1CF78FF9DD1C630+20260826062943.3255351-1-liudalin@kylinsec.com.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:kylinsec.com.cn:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: Mp7prxL8yJP4k5gyK46EuxCuVA3TArhryMDeu5pxaFJPioVUyfm0a2Iy
	jotp+CzwihW4MjVDSvbIRey5oLU7cqLP3nB+y3uY8Qhu6/LiJjhLaoZs7+7tQIvOgan5OGG
	GJoR+J7AW9VGh0aakuJTrQQIatP2Mbt5Vp17GWU0mC1QNgWsEuSw0o1HySVapzom8Ca1xjX
	DzCLbbxETh/ssCrsbGvX7arGhjksw2tg7G2DLaQ7kA/gNQOQovRhZ0tp4d/H4wqILeLs7lJ
	L4D9IX7VlpkjxZDCHaRKXMPdpSLyzYBri1vmEVY/JLrvrr9s2WpLtq0ahvXIE1mq6cJuhyH
	n/jH7HRVL2UTeBbyO1QJ5mKE5f9hasGw4X2glxvndBfqMjN6fKfLh5efqKqn4gzVWSCUWPn
	3cWSePhVSGgavowXEacdWjHgJY4gn2UGGmO5GVyRf6YVr4vV9nKauV+gei+Mm5KyG2lRc/2
	dUzwTV8sc3EQazdC5oZfu/4YTjyISRIvKupGV4uoT27DICZvUtPcCrv9/TckcRJYZH/pBKq
	LOHTrlCsAqMVNmnbNhj/I2Wpbb9pamJJbVh4MbFI7CyhPvaZuciU0nSv6gdoYxWxBqjmjPY
	6VmlaKpipHIV/oway4WsYxIcCq9XdOTW55ojUTRCU0f9/2ZUOsynFpAoc70Po7g44woNZPt
	8ZPTofgemPToo90GgZsCTGi3QanmvBNTKWJD5BAAhCmQGmjfJAiQqF0UQcYOeGPZQBy3j6m
	GtMifHB7xubPRGsgtNhgq+HRgz333H2XtjfwP6McIJoiLB1skmSlmpTgQxDQsAjeZguEjz3
	FF95F81C00vokLqXsRamOysB51i9Ijg9SH2/y9DFfcqnx91Y9cUu9zFiuZkp1xcYLLdgF8E
	c5oWEF5BtzrFnBcjXd5LfrFdGxXhCpIq7ICAAeVu1k0Ekzv/QgtEEpg1m/FdDYyU1ppa2Uj
	NkTwRL2GP3qiwKPqAj9oC9M+TGJ6qMI6YJKgh4fJ/OsXD+n17pAiRQORI+chY1gcff9gZfE
	Nv2EwNJOe2x+xzoPTtrixpto6NI/6pF3RtOuQpZ5PbMDUMncDRGZX4f+Rme4c=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 28CC2A0006
X-Stat-Signature: igy6izqe819ow8897tosjmcdoy9ah53h
X-HE-Tag: 1787725842-458121
X-HE-Meta: U2FsdGVkX181wmFO1948SjxvEVvwVvqKhhhuG6V2xPD0Uwy8GGIB9aU/DtFPud+I+YQSDFKAJnYAQiX42CM2RTg9yUCP7ljARPXUwxSdKw/1dR9H3Nf7k0XB3FBptAC6FNO+2h+UKQpqtgRNIgXDMIfMintUHniYA4hgjlOJaPugcWEfjC4bGC7b7BetBeXvx+t2jYczVC7ogkMKC4S4MMMzAhcbOTCnadWgJe9p4kayePUGTcoMiMBDT2ix2JbJYciB0Voh1MvSSai1HX/QixeYdmHLIUkgygAiq05vAZyLp1f9YtJQSqjBwJUvwBGmNzJWOwAP8qMQq/DilOpkJDGP6f/d+xnc6mb4E3V+3mRU+hL2NcpUlFGXp4r/IIWM6s7Bmqyc+YOjGBdoun34tePDfgvWhid+ah3bg1aLXjjW1ev5H0zXk+RgEKssFzQpu88JB1z6e2Sl0gC3dioSqMAF0QbNJRFin4bjEejfnZjTzAPxrszcSn4qo1ZCEWJbbcfYkiJ9RlB4vHXn3rK5zqI/Y+BvfEhd7tKGa3ZPLYDUNbiLhhPFxDM7a2FTnjTvkZMuQ8o0cFfhqefXlAu6ugajqM5uEPrGTkcIajVxVjVbUUPSRH3RusVaDf94qp6m837RdyJB0gUHi/Zv89SZaUH1kkGDyhBuwfdXCA1bzNx+Z+VUFhfGVzEfTo0s8+BGmZTbrLRmZ2DNEVkG95Rg6EMgeI2T05DsT/u+B+tPNn9EyuizWw7vQ3V4zaNS3EysYS7Myphx2t199DTtf4m1ZDBOJ7Xpla+3ZNen9oNtU/O+obbzhngISZFMlmf8No2q1/0Toz588IXVAr8REY6V+7mODUYqttiv09qhPt0+NDREupjDNJjJRr3lqlUZyYQ+Irs3AV6qZNksJCas558mYFNHiKtOenN5BCioWmSMKjRoPLiRcLAU+DIAMkrOM+a4uYGErCkNMoiUSfsXn07
 a3qw+rbR
 qNH+c+/4+uO4JxCfPgUklAEkMpFKMOHnUj26XzVx3cFAJdEYTm3uxN1rRI8bz6g59MZE9WguFXf9l9FmBXX87H54arLDCKKesZCVUqcOaTMKyUq84XyLMWiLwRcHwHEeM8oGC2UXqJNmEz0U2ce1DemqciEDBpPk9U9Jm3ycopvsDWxAxO1wuX6Y7hPEBOycU8OgnJnVBYgcVTOkYE7gPaVX0DJFkFbLguG4o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While the current callers either pass a valid pointer or explicitly
pass NULL (indicating they don't need the unlock notification), it is
safer to add a defensive NULL check before dereferencing. This prevents
a kernel crash if any caller passes NULL and handle_mm_fault() returns
VM_FAULT_COMPLETED or VM_FAULT_RETRY.

Fixes smatch warnings:
- mm/gup.c:1597 fixup_user_fault() error: we previously assumed 'unlocked' could be null (see line 1573)

Fixes: 4bbd4c776a63 ("mm: move get_user_pages()-related code to separate file")
Assisted-by: smatch:2.0 [static analysis]
Signed-off-by: Liu Dalin <liudalin@kylinsec.com.cn>
---
 mm/gup.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 0692119b7904..d12475a7f7cc 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1594,7 +1594,8 @@ int fixup_user_fault(struct mm_struct *mm,
 		 * could tell the callers so they do not need to unlock.
 		 */
 		mmap_read_lock(mm);
-		*unlocked = true;
+		if (unlocked)
+			*unlocked = true;
 		return 0;
 	}
 
@@ -1608,7 +1609,8 @@ int fixup_user_fault(struct mm_struct *mm,
 
 	if (ret & VM_FAULT_RETRY) {
 		mmap_read_lock(mm);
-		*unlocked = true;
+		if (unlocked)
+			*unlocked = true;
 		fault_flags |= FAULT_FLAG_TRIED;
 		goto retry;
 	}
-- 
2.43.0


