Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CCB5606A326
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m0IMbOAc
Received: by kanga.kvack.org (Postfix)
	id 2C0CB6B05B8; Sun,  1 Nov 2026 12:16:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 270CF6B05B9; Sun,  1 Nov 2026 12:16:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 186DC6B05BF; Sun,  1 Nov 2026 12:16:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF4486B05B8
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:16:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8415540A97
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:42 +0000 (UTC)
X-FDA: 85387204644.25.68D3BC7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id E29371C0006
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m0IMbOAc;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793553400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3UDKAp2uds0+N1mENd7M+9zX167leKiazEipp95Aa0Y=;
	b=DbzSEWqwmbGQhJ4QGNjI3zfMt+dVOoYHnouJxiE1csg8swTP2Lcfo0JwNLyRhuxfKJYeEa
	cQmw5n2hQSjhElnCl1WZTfnJ1vhYGUlp/oAIhNMJSac3O1dx2TI4DYdhTKxahVNX316X3q
	64LrOgsCdFVxrEGwPDVKZXGBzH4TZcI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m0IMbOAc;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793553400;
	b=gcjMjoBoyRpbR3a2PEb7OGmL48oCxe+LOl7Jh1PpU/YuHUSj+uFjcldmHKsqpf1Szeo29r
	4/hSZhxkTM1dbbIrqnX1nAKx4XzhEkH3ScnaYjnivXeWCeGKnNIj9WJ+YBrN1gRdN2GM6k
	JK1LVquwFZe0gZH0LxSGaqutC6mTE1Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8938460200
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1503F1F00A1A;
	Sun,  1 Nov 2026 17:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793553400;
	bh=3UDKAp2uds0+N1mENd7M+9zX167leKiazEipp95Aa0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0IMbOAcMMiKvuFVTPYx+cflpos0ecUDnB1EYU6un5dMopyB01p6xMV4xOJ+dF/sf
	 cJVxsAwMJnhtM5u705PX/HFQJklyi0WRsCXChlo3oxCqqKNxFyDMyGqKO/zv4XIvjF
	 Pneh15gdgH5LcrpPtdtFkLkVaIpKZ+yFTO/wvxcHt52ib+8FzC6Q6Di6FbUSvlvyry
	 U6qnkTXCUxOvAc47JyOro8hDTEUgfoa4fxw9rcAgl40FXw7A2K9ODApmyCROJJKNRP
	 l9uQHGmiOktl3Vr2vVI8v6xNnjG3Ne5/JI4NAkjnT53zHKjVzXBRq6EUEJ1S9qRn9z
	 rsTBFf7wt96aA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 6/6] selftests/damon: remove unused imports of os and sys modules
Date: Sun,  1 Nov 2026 09:16:29 -0800
Message-ID: <20261101171630.81477-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101171630.81477-1-sj@kernel.org>
References: <20261101171630.81477-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E29371C0006
X-Stat-Signature: sqr8kpk3k64m79gsurr3kidkee53jqyd
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793553400-605269
X-HE-Meta: U2FsdGVkX1+I8m4KC+xxPtMqfIPv4xIJc6FJzquiJd5sQXhWK6mBipkLiyYfFRq5uJlF+17ot2qenh7Hf14iSpNYpelIlhm5PYEHuTlN2DPzO0b3zhxCMI2zg4xqIgqiL8c6frA76BA/obbVaT+xO41fmfD/zDqYdrYqQQxsqAKkwLFCxfClNs0SocFmEUh6ZsaAFgJ6Fo2whDmpe8mWJ2IIEViui4RcoK8Mxnj6NcfDSfQiYAVEqJZ2LrM/1eYouU/Cb6ap86QTJdI6iVEfovx27vnHXdh7M4f8HMC2Vo6XCfWbLyyG+4LNcBEKQ9g6xY66X6g6OKFUJVgTz6n7XFDBHT5Nfs6aZpIAQqAm/q5og0hF6+xnsP1Lo1jVnqjE73e38kU8jC9TVjOPPQDoRHZkVHTb3Fgt93wPprtbEqQu1b+f5dn/XXD6LU6rsjqrYFLNBjtKxLhLntyjymBVJ0T+DThryLP2ZykwPdUHlSg42jIxBsGyo32qlCD8xLrDJxYkYqmIDuxv5CTfGuDVIU948Km6iA+sLr1JzX1Awf8Bc7nO46fK6gla9LdgVeQfh4hlGzCfx/NE6beyoV1QVTRBdisQiREQyMdkGTHOnxBWU38IDxeMtQ1dx1UCpOBmQqV7Y9R0cPI3j5jUhddHVQR9yzXVT01NoNT3xq1XWvdsag7y5j2ppnzi8cFBJsQ36X3G5joF+s5oTT2LZ1AQw+/V2VeUZB8d6g7F/n76xO+SVRy27CjzN9S3Pj2RMslsHy++OosEofWEVhhyTMbNwXb8HyirBZUcRukU7c03TdRogGPw+Cgagggm3dHJv3Nu7o+YJrUsqAo/yz4JZE7IZOH+GNtNskWTNxOsR+Q89UcW/2SyF9RdFFs5CGmf9Dip8IlSqavPEKa9h0g6wBb1DOKrd6x06p0bBRGRrcd6hrJL/Vkh58mj2glLT9IdbT3JHGyDwwYpfWWvtdy6ges
 5DBg03es
 jyqo00I5yC8fS6Iv6xwFwY/HrWmv7QDgNFhQcif34zTE34MyvXDnvkKMAotH31ujgt8FITmrtkpyeZy8KxV5U3yDKNOnbvWKPPoGsQgP14DtoobTSDnK5bbMe6Enk1IQRaymasbJrjl+1ErdSSTesp2qdMpXDIDIOnTJoVzGopftXLkDzSsACaPtufcP2NVgov8WQRjnI6XNLB4I/cNHLhdIfkeZzM9oplIDwiYmCPxUg5a9ZhxQO2j/5KV2P3RQvjKc3B8nm7lDce12iyqotCbEBZzWxLq2I3VShlkyGJCFx6Zc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sysfs_no_op_commit_break.py imports 'sys' module but never uses it.
sysfs_update_schemes_tried_regions_hang imports 'time' module but never
uses it.  Remove the unnecessary imports.

The issue is found using flake8.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs_no_op_commit_break.py        | 1 -
 .../selftests/damon/sysfs_update_schemes_tried_regions_hang.py   | 1 -
 2 files changed, 2 deletions(-)

diff --git a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
index 81774ddc55ac4..5664f75186bac 100755
--- a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
+++ b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
@@ -4,7 +4,6 @@
 import json
 import os
 import subprocess
-import sys
 
 import _damon_sysfs
 
diff --git a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py b/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py
index 625761c243b58..326a14f040534 100755
--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py
+++ b/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py
@@ -4,7 +4,6 @@
 import os
 import subprocess
 import sys
-import time
 
 sys.path.append(os.path.dirname(os.path.abspath(__file__)))
 import _damon_sysfs
-- 
2.47.3

