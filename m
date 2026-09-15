Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC4D6C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AF386B009E; Tue, 15 Sep 2026 10:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 433BE6B009F; Tue, 15 Sep 2026 10:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B28F6B00A1; Tue, 15 Sep 2026 10:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F264F6B009E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:34:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F31DE80229
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:34:12 +0000 (UTC)
X-FDA: 85216241544.17.31CDC97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6BED1120004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:34:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lae3T1U7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789482851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pe5PEKflMlDglfugpw4os1GpkWtazCvp49h5WT4n+gE=;
	b=y/BFeAbhxOx+E4oq01V3CmLBZADGYt7a/5vjUQnyWfsHi70Lr9adVwKwyXttKacM8Yo/lm
	SsC3bn/dbDUSPLbau90CtMTvilyg/rFRYz6zDDjNRclqfhHbObGLpc338vO1zCTX3dQpSC
	+XBjGM9geqK+MjvLbLtxCpI+fyeO9uE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789482851;
	b=zus18KGA8wpnj3rZL0SNIRLgsw5i4K5Txkez67tn5paisWmI1ULX+kGip/dpS3POwWNqW0
	5VqNsLWFrRrOYddPMCs/y2wJEX0jUDTFS+BXvGtJiK4PhWqKm4u+V2lVj4rBtQCnYRe83O
	tZ5Ci0mqwOR1nr4FxBBQuUVD6pJuHE8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lae3T1U7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C990E444F5;
	Tue, 15 Sep 2026 14:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDC81F00898;
	Tue, 15 Sep 2026 14:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482850;
	bh=Pe5PEKflMlDglfugpw4os1GpkWtazCvp49h5WT4n+gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lae3T1U7A2VSpNa+UqOhDrASVpciluogDdg9lfwEPGUzWSAdy1jpoPvTvR3G98NPI
	 YhaOJg4oi3f51zbIIPNK9v7s81No0glnLhWto3WzxJ333YjGWSlu/qyewp5I+J4bf1
	 ozAhiBfVIBcpNRnFek5TY0vvHRSlXLl5/yf1x8TZ1UvCJpWjxmu3YonQsRx3zsM+Eh
	 lCnbAmtMEHgX5JWuMkvEnTwrPXlnAOHVv93hs6KzP/4BGQoPTjRbmellLoR+pfB8rg
	 6dOFG4vaLKds3NG8EE8sYJ95eTU9ySSX2Gto0ESe+LpAWEPOtu5YdTF1frYyli/4I9
	 tygT9kCUUetyA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 8/8] Docs/ABI/damon: update for hugepage_size probe filter
Date: Tue, 15 Sep 2026 07:33:57 -0700
Message-ID: <20260915143359.91472-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915143359.91472-1-sj@kernel.org>
References: <20260915143359.91472-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6BED1120004
X-Stat-Signature: a9rh6sz8bhyzbrobjdjctdatmzk7q1mf
X-HE-Tag: 1789482851-765153
X-HE-Meta: U2FsdGVkX1+lyp05J2ggXeTdC3pvcxQdVu8p5R/MmLfJwQM0CGLcUNoIee/ySNAtmx4lCDCoZlAaKvg0Oz6QPa/O8ogJJjv29NHzXHZRGB2+DFkMjUIu3ASBYseQ+Q4lG13gE1XRK4gkWXehThkLlcm4chERz/F94x42UV5u9o3hgLZNqP7c2rRkceiGUdQ3UKjVzHTaNmUXQf0+IwiiJ5AhJZ2STW9HotpqQN63/hTchC6CsK+uXDlzyi7/kXRfaRw6/ojlosWBiGp4pImmYeqUKl8y50WS64u7T8H2npeaJUc6AeNg0JAJZmS+D2GNKK363mGuzr9PFJD7v+U1Iregaf6Ix0/r/dCdZJNQmEo+9xKFegRJVbYnwrhbN4e6y5PEdOrqXvCahzfihlPDTvqZUHMbJOWZCn7ZHbylHOAn7bWP9dZcDpQjsXA6/5/+5LZYpm71vip0SW10Cx1Ep7nMCXYilFeBkmwsvLmgF4t+wpW7/RXgJpRIo0O33zC5/1pBaqX0N36lfxie4cTPfzV9ETYEJhfuDWa4Z+ONfH3S3CO/SnQGuKspk0A8OzHKpEQ3fFQeqffhMO7P5i/ePXXcFcDSw4p9T2ebaMhi7Z2/oRz/GXrvjAgBzrDsR5PFkRtYBhzWEk2AXb7HUTnF8dDUlfv0XXrY9jcOKvVIH/YtTUP2BIuHQvuMNkqyKiNg9JVVhA9I+FGu+NM6yqGetC5NepqJ1RXVtnugv/b2QXEpDpEVQNFjXYRuIhzNBEa/wCoOR31pY+9GEddoPXgdIODski6Ia/BwO/TZTL3rB7fMxRT1VSRRMiSLFzIWMtys1TPxXScCHiwdq4S4kU2tis5l917fSOgw5lBJ1FtZA0I9Z0PxBCMlYK21nwNTsIEM6GBMZDT+stR6PmjAhMyxHSq6hA4web2affiyPI90Uw7v2AzW3c0JgbXKWsZznVIK/qObAaqCg24Gg0keHwh
 6MYufwZp
 gLpbP4ceWghPyfmLBK8ei/3JALsDxv639HAMdiaNv/sOU+0M/OlbX+BjuuSevLJKuYsmOFBLH8QC1MqZ12FU0AgA0E2LD1uog+rIud3UFABxDgpXBSQ4vdfyVn8yzolttE8x7DGTU7QCqG7AUaM8VWPLCUkHikO1tXPQseukgOPH+sDJi1OBK1ahM7DkrMVwtoP6mMQQ78SNfGjh7oozMAUDtMvj/U/sWRmixzh6CG3FxcQCIx//Zw114NlK3wEII/2JZ4XHL2AmP5ZPB8uuljTolY/enpdF9XJbJLDMPBURrEbnaE8Y5IKTry5byT5/LS2Xjw/HYEfwC+SCK9dU1xHgg6HR0f+sz4HLl8MQzoFsRRTyoKcp/KFwIcugyvgpz3YXPFyhAsxg156PfejUqakd9zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For the newly added hugepage_size data attribute probe filter, two new
sysfs files are added for the size range.  Update DAMON ABI document for
the new files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index ad21f58f3c912..55df688ea596f 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -206,6 +206,20 @@ Description:	If 'memcg' is written to the 'type' file, writing to and
 		reading from this file sets and gets the path to the memory
 		cgroup of the interest.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/min
+Date:		Sep 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	If 'hugepage_size' is written to the 'type' file, writing to and
+		reading from this file sets and gets the minimum size of the
+		huge page of the interest.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/max
+Date:		Sep 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	If 'hugepage_size' is written to the 'type' file, writing to and
+		reading from this file sets and gets the maximum size of the
+		huge page of the interest.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/matching
 Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

