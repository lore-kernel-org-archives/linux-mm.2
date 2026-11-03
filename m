Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10193606EEA3
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LhJtAzid
Received: by kanga.kvack.org (Postfix)
	id 6FB866B05B6; Tue,  3 Nov 2026 10:55:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4A46B05B7; Tue,  3 Nov 2026 10:55:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 612616B05B8; Tue,  3 Nov 2026 10:55:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2506B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:55:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C85CF12048C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:55:02 +0000 (UTC)
X-FDA: 85394256444.12.9B6DF7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 47DCB40006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:55:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LhJtAzid;
	spf=pass (imf07.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793721301;
	b=PQpVc38odKDP1EOz+2IoLN04w5/Zgcwy104aW/qBA22N//qStSbARjC4h46zyFsYMWrNyy
	QBHGtb1KaDKJrda6OC4LZMJipBvvE7yvZ0UPKnvpp5aH16hA9uQq3I+UpQNhOiKo+d7opV
	nPfvGeqkTWH0E9Fqjoo7tWo4bg2Jy9k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793721301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=O/jUknsydqahcxESJ7eAS0pyf88Dhlfftx821T6uSIU=;
	b=cwvGvCSag/VZ0HlxvWvvGh/kdwL3j+0f4L9ozw54v6u6KN+50YoAvpO0WsOUkdB7sqLIv4
	1q3mJjsA/BbZ4ZxEJnDOV/b4nvxTi5D9o8OYITF5RHF3W7TpNEFUIvUNE+8a6j1Jzw6o0c
	K1B28uxbuLnEVWdViUlUg4kLgMjpvZA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LhJtAzid;
	spf=pass (imf07.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF1F4429D1;
	Tue,  3 Nov 2026 15:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E061F00A1B;
	Tue,  3 Nov 2026 15:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793721298;
	bh=O/jUknsydqahcxESJ7eAS0pyf88Dhlfftx821T6uSIU=;
	h=From:To:Cc:Subject:Date;
	b=LhJtAzido5Pe5ihl8fxiEg46QKwuK908HCgwtjhnQbkDmIasZz64TkoKMXKOZc7Vn
	 MVAK++JAzdBxFurU4SuzXMoPjb9T+tnjcwydP4JYn8gbc69NPI1RdCuf7r/ZWs0uHz
	 XgsX9OZ31Z9J8E4ALLsUXmWaMIrkTBw63xoiL3gA4PveJp8SP/JSsJF7uQEqzXVQfb
	 5UbMarVD9TOZumQt1rzIjkXEIRQYEjGf9mhjRddlNz2LB6wR1eOkek+74kdrmQ6m6d
	 mftcY3B6zoyRkEQQzZ8WV5wcEmkIhUlzrCAC54SoU1wuHtc7Lfdti+mr8bAEIGhTYi
	 EY9wt+vkIKuzQ==
From: Sasha Levin <sashal@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/cgroup: read and write size_t with %zu in test_zswap
Date: Tue,  3 Nov 2026 10:54:56 -0500
Message-ID: <20261103155456.534684-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: qo9b1o65qhakmwi1bn43ojq3fyntbjxs
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 47DCB40006
X-HE-Tag: 1793721301-685860
X-HE-Meta: U2FsdGVkX18z+RMM8bzd1xAA59lw29v78ihwUB8X8RxRNdmO6fM96EPcaaJEHhqOUl3oxel5syh2VE+xyNVJ0OQPSY+k4eAT8qVi4IIBxw0tQAVTZwtD5zbwVaCW1GQbU4j/EFDmnfZ4+35BTgH0T1t2CfeC2J9wh9llApyvlWimcFDYNgdjedlK+j8eAJR2MgppmXweSH4DSFYzDTulzpmmTqsnjmHnOCOjpmlhBCjl3QLvyYBty8ZV8lSc8VpXp2UnWHsfhQ0YCljGq8BNpxMtSN8R3hlhyVFljdDf7vtQCS7krWgtys6MGOgtHeqc4UndvxwtJegVpY0Xh42RSZP3e3glLf9jNNGAmsSHAtBFH6hlb6Vv7qU+yRTxdRWekCzbQiiaQo5Wv2gSQbyqOYAQMGR56L4bpyQPngi1AFc6vRIMpHxpwSrpgJG06zIIJcnXlDg58F9ctkFlnXJq1Fx1ebb/7bHC2sD5K9p4EfYBpGS8qyGCvI59aymoSWM/owU5pebmyK+JcmYczO7kNPvqB9wfMaRFRg0b+ld7R4stJ69rabXouuxqmWE0pGg8iqEc2XjR2Btl3RynZBN1Qjjfpq9IzFTnvSpHX3sPcXz+gu0aw1YEh/+oGHbWXED+UEkA/1xGuqpv2Y2ioMqia9841oZLJKYIGdE7nRD89yHu00YVmDVXhkl2acLrwh0shdoIxQPQmxY1sd/hIk3VfZGK3GWvPU1A0S/dE9bGwSRM7SxQ7Ops5C065Cl8J7vqUA5Ry7b4BwsxKCebDMz3ShUzAlG51m7VJbbJua1sT4fnjBAGcKzxV8NJjHcBYFnedhb/yozvsDRjUXAEb3oTvlnvDokOhYgJQpW7gxLct4IdBBBAuCKNjP5YCPxR3Rhv4jvWBVwJPI+kSSABfewwcrFCXszxqOMDJUcDEVqvRkrucsDmKUwKD4li6YY/iNgu5iELvVfmRLUnZP//DKA
 6s/HFCs+
 RMUjcT87L7XYxaMIk5lzjP2S0/+n4pTujISseI90WwKaoCGjkQyYIvNaXye4sDq0UwA+4oH+UGEXDJkMnsK+/r2B4hjR5EBecTlx1ooQFMtES5Jp8yWaHXEJHJb6m4pX+ucMoyUn3Maj/S8buaDnISGrgWw6bZIaAfo7GAOLxExqEHbjFQI3uupta4l8gbJPITVJzlsupWMgjObRVFQvRGy/ZTo+87Zy/7LZ8Wm2iIKwrYhRA57d/NejY/pVM8UtT5jNsqVK3dbFZZfTM6a8N614Wg10oTRa+3bIG1+MbFiTSv/SU9HoullC0OBsqsR9qINAc0eqoo2SvMrU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 32-bit architectures size_t is an unsigned int, and reading and
writing it with %ld warns:

  test_zswap.c:34:29: warning: format '%ld' expects argument of type 'long int *', but argument 3 has type 'size_t *' {aka 'unsigned int *'} [-Wformat=]

Use %zu.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
Found with a 32-bit build of the selftests with a 64-bit time_t (gcc 16
and clang 21 with -m32 -D_TIME_BITS=64 -D_FILE_OFFSET_BITS=64);
KernelCI's 32-bit arm builds show the same warnings. The changed files
build without format warnings there now, and the x86_64 builds don't
change. The other selftests get the same kind of fix in separate
patches.

 tools/testing/selftests/cgroup/test_zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index d50acc1b83ac8..9b5769b417410 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -31,7 +31,7 @@ static int read_int(const char *path, size_t *value)
 	file = fopen(path, "r");
 	if (!file)
 		return -1;
-	if (fscanf(file, "%ld", value) != 1)
+	if (fscanf(file, "%zu", value) != 1)
 		ret = -1;
 	fclose(file);
 	return ret;
@@ -45,7 +45,7 @@ static int set_min_free_kb(size_t value)
 	file = fopen("/proc/sys/vm/min_free_kbytes", "w");
 	if (!file)
 		return -1;
-	ret = fprintf(file, "%ld\n", value);
+	ret = fprintf(file, "%zu\n", value);
 	fclose(file);
 	return ret;
 }
-- 
2.53.0


