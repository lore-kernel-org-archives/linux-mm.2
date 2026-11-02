Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE31960703B2
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MXj3RDV8
Received: by kanga.kvack.org (Postfix)
	id 803026B05B6; Mon,  2 Nov 2026 09:46:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3896B05B7; Mon,  2 Nov 2026 09:46:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C8C06B05B8; Mon,  2 Nov 2026 09:46:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 400BC6B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:46:39 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B9A0C80141
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:46:38 +0000 (UTC)
X-FDA: 85390455276.30.6EFCFE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 30C6A20011
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:46:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MXj3RDV8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793630797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nxdFwnzJ2ILCyC6+9MxA+NGU4Ptz9IG819jn1r5qFOg=;
	b=ShXvmwzs+aJ9pQGrWJ5XmO9hIr/kNpN/PdacdqsRPAGsJCB/4mqvyE0tLi4YL2LXm7sZeZ
	i1iO6YgkdtxN4ljH1bzBwqPwtp7HYriazfL6OzleF4VS0EbcF4sXdWY35HCXNfozNpJQCf
	SoNdGVGzX2x5zvskaEmiQbY3fi+8nlc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MXj3RDV8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793630797;
	b=zsBFn7F1wRFaN7GsbtD5Tk8FmwQLSJhLz3pUyLKoJBv0TnSBjlDFeeN8iDuSAW8pBHfTtN
	gHU+1l7TKAbuaWeKv5bCU7Y0jfrdev4EF+wjv32rn1NamTjuH3d0v1MXxfQQQ7uDPBFwY2
	3aeSIvTFJH+u0Xb2KC9Dc2ToCcjVA7c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB2326021E;
	Mon,  2 Nov 2026 14:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2F51F00A16;
	Mon,  2 Nov 2026 14:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630796;
	bh=nxdFwnzJ2ILCyC6+9MxA+NGU4Ptz9IG819jn1r5qFOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MXj3RDV81dKUrDy0quCLVlKxNcw//TUhE3A/qQuHALE5D3lK87wijaCmLzlKvZotw
	 gwP4tPkl40dLdllRhvDfmwVkKLIcm+mbGXHry37PS0045N5i7TUAXL3XUOS3PKZllY
	 V4UBulTRfGU9FwjHk8elo62wgWxbWtsxDtRnvEKVOQ1AkeeNGyqYM3V14MRiPUbm7/
	 vmHfK/LjaAYxvbQV/pbbcQM7AEy+Y2QqyhKdJK9jAzR3RR3Xceh09PFAOR1GaWKOIU
	 jxeNqSp4ghTFEyR6KgwX3dn+evqDC3eN7iZpIkwxm8mx/flTmwFTHIRa5j42KfLJH0
	 gbv6tdlElgm8g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: [PATCH mm-hotfixes-unstable 3/3] selftests/damon/sysfs_memcg_path_leak: define ksft_skip
Date: Mon,  2 Nov 2026 06:46:26 -0800
Message-ID: <20261102144627.88843-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102144627.88843-1-sj@kernel.org>
References: <20261102144627.88843-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 30C6A20011
X-Stat-Signature: doz7edksby8nxf1n5h1rpj6t3e85nzx8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793630797-90021
X-HE-Meta: U2FsdGVkX18I8Ig5web3GJyS4Y6TsVsJQtSEN0P+Qsl0VMo5Ni/8ImKW6As5dNQcCKYNx2xLp+2ELmRiPsobYXjfw6XwyTpErWjsl4ZPmMqwNFo/gmlruDwdBAiiWlIUetL665tDWerAVzdA5RPlzGzdn49ZdNXluq3u0QGQL7u0BGayAI/0U6ZdmBM5e4UCYx1shAMMo748o7L6a6AFCI/pVMNO4O4he33tWo43ZQZ/jaKSWdYY0+F7MixKq4Z6mQNfRr51dL+PWxUio1NXlGzbGGx2ISvlmeJHPhd283UMJk5z6EFMiRhNmx8agYyBI12FPOpDzGc0e9mkkKMIRgrW6siaiZPJ0mFyM5j5pvS993p/0AIQuJqEPiq21qTE2BUa4Ki1ElKFyYu+r0naAo9pO827DNRRje7VSUeZaAZUpzGL5sX972iAXMx9XQ29JinHGOf3RGeUff80iXoGZ58WieUlWXW2JYlBRi2TtOqan0wErKaAQGFKMn41kRamSSIiTLehO1RmotTrwwTDxkfzxnujCig4bZ69CeegLA+qWw6cBtolSUS/qGUrYcleDK6KRTibxpOrRTvgaR6YmQtOlopUrHv7QdIsC7pW68N2OitVSeBkyEwrHFfDhcjvXbDXXA2k+vHA9AKHeqxSdXhlSUoefPk8jfQaBZTN/0Ny8adtxfz9V8l3xU2uOE17A1p8++1PDQXnzam4h8pgE8NgwTzcDpi259cAC2JeBWFf9TIiMvBmd3ZJSO4R+fpdoYMmlRuhUO8QG8f2v/IOc3QZWYeEnftESFQmeqWzb/bygwrod2glRK6hHuKVABYXGpeASWD7VLV5JxnA4c+ctNjo1uK0Lyy4c7+LhaPXRgEjZ3jFJf9QRzAXwOiUSCdRKsB0Fb1IMtpOGcsNQxkSHQLK1OpMRCF1btc9v+ItsCWkIcU+U92yp5pCJVi957Cwm/QPTYF7l41h7Skigfc
 26wPBF3B
 LZgJcyFm9O4N4Nv8W6k7plaVqLvOAt3k02MdErt00O4cF/5PrGw7wKiObxklfWfcPVIQK1gzOoIOKdICe7Zi85GiBv8THrqngQCXYNHEoesp1PNn3GIS175A94+NuzF4t+I/vD41Oec6NnmpSJbYM5om7jtN8c5y9+lJS7qiCtWFgMSsXUKqVNwTlxoEP5wxzr/Tc2tD/ffhC2Gim6vVydN2nOtFN2v5qVA6s3VS66DcjUcWdGEmd6jiGStTwOGO3VvrrZhCNW1IiUhrdO+m8uL409Two4TayxGJV2cDgUosnE7Qtds1biy+71f9atdtkAA3WJgi7S68Ce28jxFD077UBDtxeobqsr+FD20ffLv8OxJw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sysfs_memcg_path_leak test uses $ksft_skip without defining it.  As a
result, the test is marked as passed while it was skipped, like below.

    $ ./sysfs_memcg_path_leak.sh
    Run as root
    $ echo $?
    0

Users who run the test could therefore wrongly believe the test was run
and passed while it was skipped.

Define the value at the beginning of the test.  After this patch, the
exit code reflects the skip.

    $ ./sysfs_memcg_path_leak.sh
    Run as root
    $ echo $?
    4

Fixes: dfa3cf0bc018 ("selftets/damon: add a test for memcg_path leak")
Cc: <stable@vger.kernel.org> # 6.17.x
Closes: https://sashiko.dev/#/bug/linux-a0456336-0608-4fec-ac22-0ee61d1d6a91
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Tested-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from RFC
- RFC: https://lore.kernel.org/20261030044643.157105-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.

 tools/testing/selftests/damon/sysfs_memcg_path_leak.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh b/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
index 34c37129c49fe..d407dddb879ec 100755
--- a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
+++ b/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
@@ -1,6 +1,9 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
 if [ $EUID -ne 0 ]
 then
 	echo "Run as root"
-- 
2.47.3

