Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D3BCCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 06:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7D268E0005; Thu,  6 Nov 2025 01:34:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2D4F8E0002; Thu,  6 Nov 2025 01:34:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6A8D8E0005; Thu,  6 Nov 2025 01:34:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9750E8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 01:34:55 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C5C413B411
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 06:34:55 +0000 (UTC)
X-FDA: 84079219350.28.330313E
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	by imf14.hostedemail.com (Postfix) with ESMTP id 179D7100003
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 06:34:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ZGG0IQIW;
	spf=pass (imf14.hostedemail.com: domain of guanwentao@uniontech.com designates 18.194.254.142 as permitted sender) smtp.mailfrom=guanwentao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762410893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QZ7DE2sG/2Rv5kN7Az6y38KWqe7iePtqFCQYa9nFJTk=;
	b=2mWB4rL7v8PfWCoIldmX4B+kmdtGebrtOuc3okGJs0+QPGSfQBqhX1lAsG7peKV+q3inqT
	C5NlQWJ+KHoBnDBf+rPIQNGPjh4VkRw4SgqZ08Ga1UXh4J2vsvN5C6YamN4f6Wsv38e+2y
	bOdu6dmdvJJ94zypTFbKhrj78f7TevI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ZGG0IQIW;
	spf=pass (imf14.hostedemail.com: domain of guanwentao@uniontech.com designates 18.194.254.142 as permitted sender) smtp.mailfrom=guanwentao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762410893; a=rsa-sha256;
	cv=none;
	b=sdb3n7oYsFt6vvjptQ42ImbZfMCldSePIDs9ZET4y/vHv6aZMQ/DjzTX/b1+hmzLICZOqU
	aIZc/nKVbR+d7+eW59m2m3jIO4kjpu9tAoy2LyUZQOyZFVy2V3a1eN5/vg+rGskWRMGy2S
	9QxcdyBRClOseE2zeAC4vo0Z6x3GM5A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1762410888;
	bh=QZ7DE2sG/2Rv5kN7Az6y38KWqe7iePtqFCQYa9nFJTk=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=ZGG0IQIWwBBHqSLxfjmKhEz391LYl5hdCrnS3VT2gfQSyjpW4WRpp9ZLuONLB8pkr
	 p00+miLjy58Vm7Kk2+Dmh5NU1EoocyTAQ5TsBaXKsh5f07kvh/1USVpbW1RYv9QLsY
	 QPWHPKHesPMIyi3PGL/EWyIBtT9asRFjRlD1m0yI=
X-QQ-mid: zesmtpgz8t1762410878t199b0e4f
X-QQ-Originating-IP: wzccWFkcFTATNYtGEZy5o/bzg8KBCjYQIHLUW7O3Yyw=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 06 Nov 2025 14:34:37 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 708193780531917148
EX-QQ-RecipientCnt: 7
From: Wentao Guan <guanwentao@uniontech.com>
To: Liam.Howlett@oracle.com
Cc: vbabka@suse.cz,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhanjun@uniontech.com,
	niecheng1@uniontech.com,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH] mm: cleanup vma_iter_bulk_alloc
Date: Thu,  6 Nov 2025 14:34:24 +0800
Message-Id: <20251106063424.3381872-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NulC8gp9xT8siRdEOVw9JtpjCGEPviwcjIU01Q1XibSEmAdkUklxOKpZ
	v0ud1usjc/LMRcXAqYubwZubq8tS9iLiG+jpL71E+n7tmDthHlm6PZgUXKzdSm938DDjgzS
	5qNUMYGTkuP4WuY/u4sapoPjDw1AZUQuTyXEsDpFBC56w1WpiGru6pJIFLw6470jk20yfWt
	G724RiOcSS10Ev/L8EHeF0cirW3pxnG6aKFPe/j26J4h30KAzNLmrXY/6doWPXNUH3J5k2X
	beyZ134NY1kdjMTc94348eTWdmMml65YGwx/FgQ67xb9UFRBHqfHe4UoE/ytQbwaz9oqhEp
	bYze3vHQyzxh9n5QIS7g4d2dgp2NEzNvehLQsty1xjUtMW+2YwZ36m7DF7LmEM0MFXxW0MV
	4+JiCEaUmoAlcg8YZh3LH9GMoTRXRowNBrrNmeYlT0CKzVQNexlwcouowHqspdc+/TS5aNh
	cr9wonCWEf2gJoN3VBX4fpEP/nL0we2AlJp0mmtts6ZeA4SxwyVq2Y6nir7Q1poDvQxs1GJ
	9JgX5aGMPJJSto/HtLPPqlV/kpiZnm3CzIdKUkFVRf//Ug/KNZU/Mzm3ZxiZ59kyzq09gAY
	kRPNOxwJki3+1xHs9dbhvuHri5uLyNiRHRi8ltok2sZN4TMEjjbeewT+kzZo9gY4U6ebB+v
	DsQLcth2YTyv4Vub2m2srEXnroyRTdtorsS+KtveA2pMikA7aaH4iohZ1oTyeeHfrxCQIRe
	CTu/x9G4zCLWbzmaK6bhICMNZFJhToPlhCevuNEB0YNlammYzafmCOnfLxODRaqhbKM3zHn
	bajx4qZ87O+5KGadFJwz5xP862htX6wisHMnz1eA0ZgAZOmk1ayHroomYGfccvg8wBN07KW
	wZZ5uX4k7y7jAm4wESETOytKDtmjmqz7lnG/tSSnQxggCO0OY2K5CdiMc0KZYIWQxHyEX00
	bvI0vrqlaIZbCydvWWAC2H41Ht3R8vpMssMQ2uricmAXr4h7Th0j3/7zeZohcUGAShkBRd+
	xsCqhVCXmNRG4boK+DXqjVR7SEPh4lb+I6eOvsATcAWj7Frvaw1sZisFpwYzI=
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 179D7100003
X-Stat-Signature: xugt3meeaw3oqi679w78txpa9bzdzn7k
X-Rspam-User: 
X-HE-Tag: 1762410891-265112
X-HE-Meta: U2FsdGVkX1+9yujceGEkSHAd8PG/kGt+hqD97ImXxVcRFyz+c0y96O1xBb7Tsi8YqCHDl1FP3jE3djo4blFooiYzGbcaaxsGkNML5rdSrE34J6+L9UyVR+wdSDl/qfvNTvmlwf8HtLN0tArmTJ+zLbSaNKXZJH6Y1Cq+FM+2pMXanNwZ+Z2s2WrlgG34FIr4c65b/ZPrd+Gn7CAh8s9tqounqflrGXxwZjw1rb5BYI7Oh852tj6ISve4xj82d4lEuJ1rilWN7Jopffy0OKIg12Fj/bI21bwfn7hgTrZRBp1VWgIscuiyzy9LjiwZcwz92vE0qiFTTo5WHZ3I2k0wxNVacxrbTY/XIpd2GYlcxJOHMrwVA1ea+KkbxJP2fqfsLev9sIqkHGORHNw3dn5g1hQDBbDqg086J1hygQjzE5WdeVEhaZ73LNZx1bMu4o9s94VoL15baoMjwmox0tsJAvZ2j+yezwmYZ2S82sHplNELuZEcwOEDR1XF11lnd4TvbkSUpP8s04XUnraX/7myCrTonckdVO0ePA1XaRE1a5GSYNVsU7LA0W6XvfKMAWEJ0dr3XgQx65nzaaSpCYXbfONxcXrarvhjenTigt8dPPynD7dttgRcUFleTVUFU6ypKfEQCX7Q+NRxxn4OoT0XfuXciCOhG70auhou1TU9ogvwfIBC25lVXaV0T8149D8zSaDFDKXUwNg7OU1GZCDib06EUyduA5RDTbcvOFtoX6iOSmwaGR7ymRx3CEqs5t5zscSc28X93cLBv9+vdSm5Kj20u4ul6GedDuafDFNItqycuXmfr0SxSsfweSYLwmFb87USJfOcxn9uX9BRQQ7nBp+zanc63qLeojQUB5WI5CeC4K9LDj2BNtNEa7TqMAaqtUQIughz/f740wM2KiF/O5AwHx6jlbupgsiIQkISau5qVXOj37fTlGw5Dfx+mBZ3sWxNYGGGO5RmtB3cvuh
 gXf5tei2
 g1bQwCOQzBKBgeME3GgIwfzzTTwoWg/mK8kPgp/tCLLpKhqPGmun9K2Xk4jfP5ScEWIgmcNqXvRaTLjUHh+CtdDF/jG6kmBfd6HUoxIcXO8osOeoAte1RuUnoXdCHqxqVlk3feol6mG9MXtkii77ybNKYpukvKsB8f2DuLh1yVdHrs3+CTa8lm8+b0Ti0gbNjlDd6ur+9SXBmUY6wUt2zvt+POsIwi+hwS2gTxGaGECT5ik0ZfeLaYJaOovSldOlg7SoQU8Df0VEKtlX3qeax+phTUkjDJ8HK8gqdluxd6HkohIWg1aREfflQ7b9jQz72afaKZm9zxCPIzWwPuRBC65d5mtcrBUUmOZk2cmx/X3Zm0YmqgnQfwDJlL+W3hBJNWMtucBgZT7aNfEk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit d24062914837 ("fork: use __mt_dup() to duplicate maple tree in dup_mmap()"),
remove the only user and mas_expected_entries has been removed,
since commit e3852a1213ffc ("maple_tree: Drop bulk insert support").

No functional change.

Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
---
 mm/vma.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/vma.h b/mm/vma.h
index 9183fe5490090..4aa72c7e94400 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -498,12 +498,6 @@ static inline unsigned long vma_iter_end(struct vma_iterator *vmi)
 	return vmi->mas.last + 1;
 }
 
-static inline int vma_iter_bulk_alloc(struct vma_iterator *vmi,
-				      unsigned long count)
-{
-	return mas_expected_entries(&vmi->mas, count);
-}
-
 static inline
 struct vm_area_struct *vma_iter_prev_range(struct vma_iterator *vmi)
 {

base-commit: dc77806cf3b4788d328fddf245e86c5b529f31a2
-- 
2.20.1


