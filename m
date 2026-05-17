Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35FB6CD37AC
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 10:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F7C96B0005; Sun, 17 May 2026 06:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A85D6B0088; Sun, 17 May 2026 06:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1951D6B008C; Sun, 17 May 2026 06:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 042546B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 06:37:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1A6D160DA7
	for <linux-mm@kvack.org>; Sun, 17 May 2026 10:37:18 +0000 (UTC)
X-FDA: 84776559756.27.15E9056
Received: from outbound.pv.icloud.com (pv-2002l-snip4-8.eps.apple.com [57.103.64.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7E36040002
	for <linux-mm@kvack.org>; Sun, 17 May 2026 10:37:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=RUnlqTKu;
	spf=pass (imf12.hostedemail.com: domain of ssh1326@icloud.com designates 57.103.64.169 as permitted sender) smtp.mailfrom=ssh1326@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779014236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TeziDzDoO/PNY6PhjgVpHD9zZvjFwOl+yvI8NCHJLSI=;
	b=3OjQ7L5Hws3DxUnvw/B3vlsbWjQukTCjCXH6gufS8pwppfcJJfOarvVIpRLLpaHJYV+6+z
	rBgyUtot4w/wbTHioG9ibUtVEl3zc+A+Zr521vHpbz6zmd8QiWfNr2kjeorygqEGweg+Wp
	wSKL+P4b8+P1+a+6qlzTH1E1WBV2yZ8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=RUnlqTKu;
	spf=pass (imf12.hostedemail.com: domain of ssh1326@icloud.com designates 57.103.64.169 as permitted sender) smtp.mailfrom=ssh1326@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779014236; a=rsa-sha256;
	cv=none;
	b=orb+qWgrg5IBlqnhpbu+cbWpyIxKF3Od/5VdSB8kGVfZYa29HzFdZEcZYtXXvYTb0n3K+w
	/iH7Kt2GCXyhfmbxx7WHPEYkgUL1/BneNRMEoyXEPGMPb95PaqlSfp6VGirIUPbpAyfD50
	B630/ElzY3EuApZuT9DLPk8sx2HedUo=
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-7 (Postfix) with ESMTPS id 4D3661800108;
	Sun, 17 May 2026 10:37:10 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhKBUMDRQBBCFYBWANLVxQEC0AFBlgARnkRUAFYHlZeWhdeTVEPDwNKEAJeBV1yGVoUXBhTRVEfVFhBDgpaB1BRHV8CCgRHBFsXRgNTRUIGFxFQAVgeVl5aF15NRx9ATWJJAVoZWxxAF0puTVMPDxlaFFwYU0VRH1RYXgRTVg5CCUoFXQJaBUEJSwVZB0UGRQ1MB0AGRkEDUUkAXwErWxNVF0YJGQhdHQdYRxRHDg8ZWhRcGFM=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1779014235; x=1781606235; bh=TeziDzDoO/PNY6PhjgVpHD9zZvjFwOl+yvI8NCHJLSI=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=RUnlqTKuoyFFJCvYHOHSWUPlBSiNo+PdekRUuFU1gS+BQWWfym4onKMVe1VTXC5S2h7dBdX8eKmljT6/UBI+wggh8UL9ruNLmAMb9LNKl6bTIbxxWKnvGdhWFRikmQ1sGu3v3ZspsRHGiBLKPKLrO2+4G+Ln+eY6KQZ9IcNhYI6XLVx7xnrz6cU7sxn+8q9uMittwxk78JEvvBYCgDFgUZlxsRZFCT1pqWXeVVVIooC2XPPTAMje8a1C7Nv+dfk6YRE0x/Q5+u3Un8IApjTGgxSJ5gjj/gBQvpNpCFJxO3M+wvZq97OiOVeNYdEOb6LIDFjugS/Up33+zlfziZizgg==
mail-alias-created-date: 1778972301885
Received: from localhost.localdomain (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-7 (Postfix) with ESMTPSA id EC5F818000B1;
	Sun, 17 May 2026 10:37:05 +0000 (UTC)
From: Sakurai Shun <ssh1326@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: Sakurai Shun <ssh1326@icloud.com>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] docs/mm: fix typo in process_addrs.rst
Date: Sun, 17 May 2026 19:36:35 +0900
Message-ID: <20260517103640.45444-1-ssh1326@icloud.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE3MDExMyBTYWx0ZWRfX1AAOIyg7xFDP
 jquP21Q4lLX+zcFlWp4i4CME/d8SNLi9DZaqYnDsUAhWbrPWry5Z4QiI9OSXVdW773Kjiq7UeEs
 y3l69quiFKhdPX/t2mVasNijPk9eD/lurYmxSqFCtHsPAi1ujU4nu3MAIP9vrXgW8+nHh4nVQm1
 FgxaSUCW57IY0Q/yhzHRIxjYIPcfeHuYs+5DIabXgnYQFNlmhctojdH5L2k9oJVbO7RL+n0bbpI
 p8q1c4Z3UvMkeXMWFYLX8tak2z5tfFgCx8PvJxJW719IBJEEWBRQ2VvTChcHZ4h6qugsIuPmuBT
 ++iJVH2Po1t/Ncni6CL/hTuS1e5FI45CmF771HWSHP5c5Y5cumAVlQoYaRSsoQ=
X-Authority-Info-Out: v=2.4 cv=N78k1m9B c=1 sm=1 tr=0 ts=6a099a58
 cx=c_apl:c_pps:t_out a=azHRBMxVc17uSn+fyuI/eg==:117
 a=azHRBMxVc17uSn+fyuI/eg==:17 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=ZxuoajvSgW0A:10 a=VkNPw1HP01LnGYTKEx00:22 a=v3ZZPjhaAAAA:8
 a=lqo7fT-aTzeglYgoLxgA:9 a=IxSG75etxsVYPPdR13TJ:22 a=YETpcmI30o-OGwpgB0-d:22
X-Proofpoint-ORIG-GUID: AdqbNU45CklcMOGHau956gW3IQpfYlIY
X-Proofpoint-GUID: AdqbNU45CklcMOGHau956gW3IQpfYlIY
X-Apple-Category-Label: MjE0Nzk4NjU5NzY6JGNhdGVnb3J5JF9QZXJzb25hbCw=
X-Stat-Signature: 3t1hhxkz86ro3wdxck7w9o6ksesqsbgq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7E36040002
X-Rspam-User: 
X-HE-Tag: 1779014236-802752
X-HE-Meta: U2FsdGVkX1/WMaTPKwPhDhOBLLKpVvJcDnwd+sAPxDm0SHBTSqW0Ye9JOnMlCDW2/5uU7KTOXPpEErYQRU0fIrBtZeVjDhtt3jB6z3UHN0Wz7DNci2l7Hq8vCxliePtt+qXh15b/VPnAwSNDYGGoOBa7qjuiC8eYBe6cJKSarHL7MnR9zQe8NWL+aDIsdkFcDBzE4qw9JziSoK8QzptLfO+zDCKcLqLI/6UrXazw0Lrn2Z7WvcQNoOuYZixCLwxSZdgt7CI41dbJJe10XVX2j8twXAg6+odiUYw45E/iBTHi7EGgxHRolsROH/ZLw8nQfnJlvpmKRq0VmLgHPfADWHWQ43paDQwy+apwsw0IISEgaqV4l3q2aAqzk5XY069e9AlxNNmNCjyiYi7PmIfDfl0ta3yB9vIfslQaDO72jK9NBbG48+RZMHDv0okhx+lRrOzWutdgWsh1InnLAidQ0iQBdW7+uA0xLLyX7++UKJsuF8GpQUAefLSU7Wji2vVCcEGJd1e+nzuSuevQudCMSFDspKHVaXR5WnhmjuDGr9fyK6ggVyN3n6VDxAK70Jh5GDBoqfhhKhv0XZvBFYrHK6QhRB5QmST4aAZ1I73lTgIPq+nwS1QhLcgQGCHEt9osRVMwkx3bJNaBgNw0eaG5D9Ui2YBHsFNjvF5Y7iNPOHOWUiRBMueqQp/FMk8oloQN/g4MB0on6+GT7RMkJU6yv2a+Nzp/TdvZEir5eArNqXRDO9zlUbLSi2kTEeU5Wqm6WPPkCVjzP6d9mhdaOnq9AdcoR//8IHXmtHZZu3AAGN3MDWT5GBi4PkgWt956OqT/xdEOnM/35gQP0/QGaBDhkFOy7taU8x9I2FMwNPxu0JJeccrVgirqxdACHwkOID+4/UZNOrPYtcqWhcrTN7D5mdHmyRvOR26e4Txvn5AAXXtTJFNWoZp1zzW1LGKobABth1zo/GTO7/RGPDBvT1p
 Yj7074WH
 pp3DvdW8n1PTkHcGZzFrYFHOL6J836WpvWdFduSpPo2D88gCJ40Ca9xjERKEQZy5/nJxu0+QDLaF1T2r5QULR1PVlDbUJlWQRw5Dz36aZFE+G4h2ldE8RQwwC81/57ksUnw5pYIpT7kot6UQe5RCgphN9fqwkXtx8QCiUbCrfTLoVGzCT1QK1F4sE1OjMBA4kww9aI9ge5+VrecYzYgFTniaXfcuIreP8Yts4qSjxhS8XkH9zfHc3s3VkBb3bsYSaKtCN/nkt+iBUesKkZC94HRbyKdMnZpF7JbZaYDTrwPWSbmVbhSeZWs1Ok/qOulHfnH6carm+P+FvfsRTyfmo18Mpq4ghmm0PiGWHHHuYKls8H1dXWUB5x6u4ye08f5ENQmR24ZDb4Ayc4J8aJl5BloZHG1CQubWpgRZiWzwva0fGruuBD+TcDMotJJGUiPupNxPL0qLpAspa6vjuB7XoCMmeTU6iClcFKRKQzxjczP7pSmblTuzh72tVF6ZNv6nu48Ue2RywKim5y2p8HwnlLQEkCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace "presense" with "presence"

Signed-off-by: Sakurai Shun <ssh1326@icloud.com>
---
 Documentation/mm/process_addrs.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
index 851680ead..042d64d72 100644
--- a/Documentation/mm/process_addrs.rst
+++ b/Documentation/mm/process_addrs.rst
@@ -775,7 +775,7 @@ lock, releasing or downgrading the mmap write lock also releases the VMA write
 lock so there is no :c:func:`!vma_end_write` function.
 
 Note that when write-locking a VMA lock, the :c:member:`!vma.vm_refcnt` is temporarily
-modified so that readers can detect the presense of a writer. The reference counter is
+modified so that readers can detect the presence of a writer. The reference counter is
 restored once the vma sequence number used for serialisation is updated.
 
 This ensures the semantics we require - VMA write locks provide exclusive write
-- 
2.54.0


