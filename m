Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73E5BC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 03:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64C546B008A; Tue,  1 Sep 2026 23:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FCFD6B008C; Tue,  1 Sep 2026 23:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EE466B0095; Tue,  1 Sep 2026 23:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2589D6B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:13:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A89F21C2553
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:13:32 +0000 (UTC)
X-FDA: 85167351864.23.398D5B3
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6CF6940004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:13:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=eZ7bjfyL;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf11.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788318810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=h6/5EmycLIcO6NT2x9QwzeRmtzgDcLFqGj/52XEIcm4=;
	b=hHD07sa3EvvUO5+CKFKIKtFfedKvTWove5UpRYxMz5V4mN9W2D/U7xUFEYBoI8L9ZwcfIh
	cNUqnhuTh6uA79KNNuw+l7kixzB8oFKsm3auEaojt7/G4gp4EowO3JvnLpcCAMEbcqmh+U
	Oxnvux3LnqcR033PflAeE+hJqnHPORc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788318810;
	b=nbdTcB1aoCFPViCSf4Dz0GPjxf4kuAiqNBpV15NFiIr6c6tV2BBXZLF8SMwNqOx4stU5Xr
	itx2VmSkMNEi4HG6HM8ZENdoLnn99EVaYdtNVGUUxuEbWudOTgXfOR8rMz5kC0vL/SCHKt
	BWY44gOdawry8T110vrQphFxkk4xbok=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=eZ7bjfyL;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf11.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1788318775;
	bh=h6/5EmycLIcO6NT2x9QwzeRmtzgDcLFqGj/52XEIcm4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=eZ7bjfyLli9Gzmr+LAuEG347uwkmGP8vzy/EgzrWPW1Dt64GvqdYsfu2M6tku5y8c
	 HE0jnBu270Wk9U3wmGV5oeGS4YlXhaQDjTz2MpEH8X8JjYYXO19efuUdtuqwryb+wf
	 MtXa5ysFevlL0QPuZUKC/3PiXF13elL6kT1HDfLM=
X-QQ-mid: zesmtpsz8t1788318769t04f7107f
X-QQ-Originating-IP: Tp3c8ceN3I4tfWZkFDr/C9B0wsT3VLd0pwwTgHq9rYY=
Received: from zzz-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 02 Sep 2026 11:12:41 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16383390424684535128
EX-QQ-RecipientCnt: 13
From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-kernel@vger.kernel.org,
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Subject: [PATCH v2] mm/migrate_device: fix function name in kernel-doc
Date: Wed,  2 Sep 2026 11:12:29 +0800
Message-ID: <13768B0F4A5FC1F5+20260902031229.1821112-1-zhaozhengzhuo@uniontech.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: N+U/QWJ6RP+kQyUWbS78eT/R6DOMTzegLNBdj9gysPNoyPk3RhJNNjbf
	mBbiTX34ZJE3YORW/X0Ok2TTpuoANGqKkfD7iKSJpgn3xDo6cFTg/pA8MCkbxArokGgL6dJ
	s2MhWWXvCGu35Y40PPi/ZzKm2tDMlPj7GWQ341I9KlRyVTYCyx/E+mHhtyKL97qM5C72vuy
	Xhq1kAov+9x+XbybVmjJBO/aUgflLInw3D1hko6aQSV8khjCd2PBRjzdOoEGEokC6VUWTGE
	ogq8xtZTq2PosOMay29PNTyfp2xjqPBD+/SuBLdzfU0lXq60AU7l4j6RYH3ophx7WRAqqP9
	D3xkMEOvDnkCYJPmX9ThPamUBNDVSK6qejdjWPoHn2+MdephkRX8odOitiKwLOqtC57USXc
	u9JKFNAtFyaqBTwiY2aD7uAhcCKh/t6QTp5D3c4DzUh7x+8I5JUIb4tcOeyDnyH1vK5ckz/
	bY22uoShrxdbsTc8ZB7+lqcDhNSyfUpCSC03CbfnrJD8ytcNEDCyQU0/EjbH28+LdqBCoyX
	UejTHTR+8ItYfn0JVG2m5azjjHfwTF725KsqRAatSfV5ehWqnovwpROeQW6A278Rwdzbt/Q
	9IJQdqMYm8LPSn9Drlj1ZqfDxyZSNTVFJBVFisNSVqHeIKoZvbfUfCrLjq1HYTJqXBltiJ3
	EZef2sUdZqI/K7drFNRDXCNmuDBy9mswKQiVUXVXZdxIQLA5OYu+kq7umMuemd3xWtvSJUo
	ZaMVV6jtZ+YkTwYZrV87hAEIAvH6Zgy905K3vZRJnpGq+wSnUyNoa4f6Srs6PFMkRFINOos
	+gdtAElzapI43/VtNoG3t4zVm3h/Ze1ApfU6taS3MQCZ+dSclWyFlJWvjVOR6UX6FQXz2mO
	K3JnMxJRCZEiwHKwXhNDC1T2TpLBvb9voIfeEH8sDpt0G62qPyxgOwaxKFhXybgKalHbwW7
	u9cHNhx+Ylgu3TI0v+dyx500rXkH+doiTPnZc+nmV5Z56XZAUi1aesl/XL5LdNZQNrqoZhO
	AAYT6qX1JAVrK3hLei1AxPy4JUL9NTdBAqCLiLpccBr7TLfey04sL1YicZ0Zk/MxuUnZpxc
	cdRQZgEEt/TsnEe6zFjMSVlH1EoA6ei2SsQcKlfTeTkJ7XZH3z20jw=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6CF6940004
X-Stat-Signature: 6p89qxjzdjhknxw449gu4ajtuamsoxis
X-Rspam-User: 
X-HE-Tag: 1788318809-22783
X-HE-Meta: U2FsdGVkX1+t37vKgCwOPsCq+iA2q2hQ3+3hTHOfPpqndA+Gnd79Yv88IcfIddDk2lYyy50UOj8glETH9edKLR/qoWRl0O6uwiNfc5YqsYD5NUVBcQIJmDxjY5Py9svINNUVMOmEWwcYN7vXXU10QOhH4xEb7d+e1UbkVTHERnVIBk22+vLXwAfybqY1n5f+EfLc2+0HZbHD7AX8tEIFt08AljHLEcYOwIQQUVELuofTNv1OL5Tuo2yuS1AMADmw21/B6FXBrGChDARevz7pRDnO5BAvfWzo4Y470x3AHxXe33Wa15aR6VdKHXjFhR2S+LNppscPkOXhYOPbswUImJQ/o6pnzWm4aWm5UzxsXgyepdX2H5T0wytwIBLGaEs12I3cIDmpVyXJsvaOF2aXL4Iv++xbYfCV0L/gaQXDZ7T6sshrqP+2nzKE/EePW35n2PixJoPvBTN/uAKql1UGFoersvYOez2A02zGtP3XKzkGWpZe4FteCtmqchgIzYF6rDExfJzX5yX4JTTPVn2TbYttp8cTqUWxWSOSYiGZbslzfFXHku1xRFRv8smTTF7RtSBfUsrZ4zipHrFxI3XCgbYpslOd10kTyh1VmP6CHuMxwgOK0/l21XjxN9y2MEPOtV6RvKuqNVCJVJ1pU3V1NfgnbiNW/EJI7mSRBLcNF2v2wrc6ZMXAsyN7T+I/5l/rgK3/njixVS9/XthbWa+SWLnc74n38ocmye6m7Yo0RsufkX82f9D350P5DrUPRPWXoNjq5ohP1kRVJzgMPqLqN+b2USLQtoTVOtakrm72/tMlm8qucUjuuoSpPab4aX3Gh+itrotqZtlFLVZa1ewQTFqzDn3EO9AqBi0G1E/eh3PazVLJoNejMojeOHIFURqSw21kV+cWA1vMIFnPmtXd+NSEsOHn+Cz6MBBvlLlr67zTCeMOcOzRw+/jgy3f+p+R5uMkLR7pPmizE84sQf9
 jtb3iPMP
 CUAMYJP0kW9lShQjpcKaaCtsU8cKxT3g3XcXQx6JE9cCpxysY1QPB4lNwOgTod3pHW800NoDREwl6ZFNvGq7x0RebvCsXu87XR2TpC2p5eiEc2P8u8/esTQtXlHCd9xr/wimLgqnMcgwvVoS2N6BBg1zZY/gfVzn7bZ411GECl+8huGT/et/c2+hGjN5IEVu5z8P14r/QP2GY5J6iPBPFkgZxpy4trKzjvE1kQr7HPuCW0ZGs/OIY9phxWM7bTNA1kygtBsETz1kseDwXzYkGY6M86nyND9ms4uxqfbE4yygb7cNBX2mGBC916p+I47brFJJLoCftD0SQYPNORLlEuSgkNxVBUZUpPh9Y8WTPOxuWrqbDeQFLqIq3czTu0EqND2sKSEtsLtB/TsIitnN3IuH798w4om2hysOfNdX6ahOMDYQhh9lqaM01sGQhqESd7Zo0VvMmZQiyklC2JWkqL1ptkZ5c3xNlw7kRM7OswtIkomalJ7K2TXtcm6r/C9aOyaV9BETQNGpIr9A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kernel-doc for migrate_device_range() says that migrate_vma_setup()
is similar to itself.  Refer to migrate_device_range() as the subject of
the comparison, making the distinction between virtual-address-based and
device-PFN-based migration clear.

Fixes: e778406b40db ("mm/migrate_device.c: add migrate_device_range()")
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
---
Changes in v2:
- Drop the redundant second "instead", as suggested by Zi Yan.

Link to v1: https://lore.kernel.org/7D206FC95BDCAA0F+20260901065131.1759298-1-zhaozhengzhuo@uniontech.com/

 mm/migrate_device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 009bfa8b212d..0c437004329d 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1398,9 +1398,9 @@ static unsigned long migrate_device_pfn_lock(unsigned long pfn)
  * @start: starting pfn in the range to migrate.
  * @npages: number of pages to migrate.
  *
- * migrate_vma_setup() is similar in concept to migrate_vma_setup() except that
- * instead of looking up pages based on virtual address mappings a range of
- * device pfns that should be migrated to system memory is used instead.
+ * migrate_device_range() is similar in concept to migrate_vma_setup(), except
+ * that instead of looking up pages based on virtual address mappings, a range
+ * of device pfns that should be migrated to system memory is used.
  *
  * This is useful when a driver needs to free device memory but doesn't know the
  * virtual mappings of every page that may be in device memory. For example this
-- 
2.50.1

