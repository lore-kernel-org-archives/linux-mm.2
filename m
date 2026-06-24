Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87502CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C56A6B00A0; Wed, 24 Jun 2026 10:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49D996B00A1; Wed, 24 Jun 2026 10:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DAFC6B00A2; Wed, 24 Jun 2026 10:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 120626B00A0
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:20:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8096BC02BE
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:32 +0000 (UTC)
X-FDA: 84915016704.07.8261699
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id DE59D40007
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YPobP0tH;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782310830;
	b=tOfArgyWfqHwq1zg4JFqPHkker5WR3m6jqRQB13lKZUWpru762Cshrs84331E0CxqZTJTH
	6CRqUuzivDeeALmmfqTyDHYe+3MKeR2/i5C3Vjfqd11wE6nAe2hTzp+HRjRqLRGJHcw4mN
	C/1LrjBBN33kpW17SBWsfl7FuqwKIyg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782310830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PdgawUMr3ivgV/d60/KgM0WVFSSy7a/TodMtkj3Ep3M=;
	b=sunrRHtge5Vb2tN7XGamecd/CBVsREe0nc3cpNNPP5sKq/W/M5+ZaUFBbMyjyv7mCv/odk
	oR0ryPt+W/0xo+8RcTiKu04Tb8sXXmngqqQ+aKlkctO59M1xqdrX9uivc9It3ZV8KCAk0U
	sJeG6ZaEmEtST9o4ZHjkGjdS8otkYJ4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YPobP0tH;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3420141839
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9A81F00A3E;
	Wed, 24 Jun 2026 14:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782310830;
	bh=PdgawUMr3ivgV/d60/KgM0WVFSSy7a/TodMtkj3Ep3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPobP0tHgNl/zXvL8PurjIsqWlC8cOWAEuMU2RDz4X4QEb5da6svPnZGw0H2bPuwZ
	 zq5CGWsT3T/1VGt3x5hL6cRgoZE2bol4C/hVmoCEqKBxWjocVpiEPIPMaBC02j7Wh1
	 c/I1W1tnhWWv9pC38rOx4fUp3MCgElrAEXCTpoY03SDGMT6Lupqbj7CvYKN0JpCTCP
	 x6EjjRGoigjmzphABjlNaKq7NnxsOE+iqGxGOn7lX9jcf3+eNDvNLJT0y+IReBTad5
	 Pgnc7nMTRSw1sSsKwLXoOntqq6bZvn9mLTG2SFWo/UBwkc06MHKHQ8u/zo0NDddpHG
	 /kJ215HGNx1IA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 06/11] selftests/damon/sysfs.sh: test dests dir
Date: Wed, 24 Jun 2026 07:20:02 -0700
Message-ID: <20260624142008.87180-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260624142008.87180-1-sj@kernel.org>
References: <20260624142008.87180-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DE59D40007
X-Rspam-User: 
X-Stat-Signature: 65ydywxy36eci97xbubwrwofxuhwx9i9
X-HE-Tag: 1782310830-279644
X-HE-Meta: U2FsdGVkX1+dXiPKhYZqKUl20rnEvv8moxUcfgcS/c32XR7tS5nQ9ebUppNtVaofTMx/hBqTh6Y41IhnqopU4Jjb+VpInK+oNuBxO1YB8tnt2RbpIdozXCUBXq3aN+0TUAoDjvPesTFG7kMhXylGOU6WI7TWel3Qapcqooj5lOtI4S9/iOngHl+sDZvKLqQn4ZDKLR9VsCGl1MlSBaund8iKz9yl/d6NJO8fOnGFEyjB+qVy4JsjIwtEu45CBkA0GMZeEW5Sns+ChfOQKrAGozZqsfNLencRFAhILLbZwiG/lKPgpBs3QwUxzdHWimsifAoKwoLGII6G3413Pr7Dqhg9niFmQeD5PRstlzwKTZeEtpNUun8rbTA0CBASOY5QSaoMUdcSVonrBaG+t9Eg4jhcIoSS2e/KZ2wSHVeJYx4rVZqCTHhILI4RoKSoV5fxvYGangJTp7AxuLwPhi6v8m8KeOGypGe+jQYPWuUSuU/w/bi2IBmHuM4oWONzZu6Bfn2x56XXx8mdtPj8KiZTK1CfLl3+xpJhX33qn4GUY+LGZJqTVx60hzs8OSwUxvlz9+Aj2KBYcNLuaiX5hss3ET3IWhszmCjrGusgYW6oquyXOPOel9RlLGmF2945pYOCVx+JfC0Rl+0UQJ8UOuxibhD1iE6G5TZrq/gXekpG3ROsaNGFeb8AVGRvSEoD5sPyALkEplF93IpMXTjzXs728YmOXFQJ9G4u5+pJzI1olJ2Hbz+XowKW4LSTW94KaZoF/unK77r2rBI3W/G8rJDGM9JIuY5+iN//M4IIneqHduUk3QaszL63uW+KkPzGDcCz+Q3cCBEaJ/RsZFyX9BU+wD+anOzejZWzacXbLckXjtOdonUlB72/uTdmfxsZez5zMOPgp0HNV67LBMAWt8OtDCJHvz95EqS7ZmuptJAD9DFMrKlVo0l5ryT+OmPMfzBSepsXdsJziYr+jLXrs1P
 /z6rG/eP
 5jwij8x9A2wWVNdFJZHnDrwL7KfbvFjpuJ0NG00pxvqoeyjbO8s7v9fdB6Y3XMozwM+vS7TFFAQJ84ek/yiWfkcDXqpjAXT+Y6NDUUBkUGhroTWIgjbOxEE3qN+iHaNOmVi8jgKgM4ktXl6qWGl1v5Vy18bOxvCTk8+342Obmkhrb6z/CTYnkHXJadELJYv5X3JEGnYcxnmeQ53Oe36sRBC+0VGE+AbC8j+2PAW7AfMHyxpRPFQaoeDuanpBB7KlkCIpDsZn4MrvRDOTA59O3x9MGvuLtRexTvCOLEacJneRWLd8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON selftest interface essential file operations test (sysfs.sh) is
not testing DAMOS dests/ directory.  Add the test.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 78eea0d13c271..cbfababa0bf31 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -99,6 +99,29 @@ test_stats()
 	done
 }
 
+test_dest()
+{
+	dest_dir=$1
+	ensure_file "$dest_dir/id" "exist"
+	ensure_file "$dest_dir/weight" "exist"
+}
+
+test_dests()
+{
+	dests_dir=$1
+	ensure_file "$dests_dir/nr_dests" "exist" "600"
+	ensure_write_succ "$dests_dir/nr_dests" "1" "valid input"
+	test_dest "$dests_dir/0"
+
+	ensure_write_succ "$dests_dir/nr_dests" "2" "valid input"
+	test_dest "$dests_dir/0"
+	test_dest "$dests_dir/1"
+
+	ensure_write_succ "$dests_dir/nr_dests" "0" "valid input"
+	ensure_dir "$dests_dir/0" "not_exist"
+	ensure_dir "$dests_dir/1" "not_exist"
+}
+
 test_filter()
 {
 	filter_dir=$1
-- 
2.47.3

