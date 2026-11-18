Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A3EF606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 06:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=mN7/eRKf
Received: by kanga.kvack.org (Postfix)
	id 7D5E46B05B8; Wed, 18 Nov 2026 01:07:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AE126B05B9; Wed, 18 Nov 2026 01:07:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED6B6B05BA; Wed, 18 Nov 2026 01:07:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2B36B05B8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:07:15 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C186B1C4033
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:07:14 +0000 (UTC)
X-FDA: 85447207188.11.4AEF89C
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf03.hostedemail.com (Postfix) with ESMTP id D1A3420007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:07:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="mN7/eRKf";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf03.hostedemail.com: domain of wangxuewen_ky@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794982031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=433+jF5VmY7mJrkGv4a5VU07RrjmRllblHsG6O6S3l0=;
	b=g9wysQL1rqMedABRX3ODec5+mfZS/goGpoi080mJ/JI85O4xvxFHIKEXlOk0AXiakM83KX
	eaCaOuEKVj/12OufmO5BerXEk+VDBP04XGBA96Wa5Pnfp6SPBzkjH1Glj9kXJNHVszwos5
	s/cAPXntnGEEOqbytHv2B7upY9JOo5c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794982031;
	b=gh3YXbpmJd8uHNMtvJg8gH302fHgagE0yt7jQevX24ForHvsyz933HFckpGc5tsGU055kA
	7p8/Dr12TFFmM2tb8A32+LWuQejgdLb5073S3i5Ufv4xXEWL5ZJSUaRL287oll8XjPs89A
	owG9UDbDnX7JB1CWbsf0nKFzuW2IbUA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="mN7/eRKf";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf03.hostedemail.com: domain of wangxuewen_ky@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=43
	3+jF5VmY7mJrkGv4a5VU07RrjmRllblHsG6O6S3l0=; b=mN7/eRKfEz6Ngv05Hv
	B0BQRae/FVfKmuRonq5m3LnVhIzpJHl60PRlTvlA4+vLnvpL728S6XGtL/cKkgM3
	WJjBZMcJvAiir+3zceuKWvdCCt4fgaYAIJPZHsX15q8PBhJ+dmgQG3/JMTnXbiDf
	9UbgOw96xfEpYpx7Yj+3Tf1Gc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3HwjJP_1qmvfEIw--.16665S4;
	Wed, 18 Nov 2026 14:03:56 +0800 (CST)
From: Xuewen Wang <wangxuewen_ky@163.com>
To: vbabka@kernel.org,
	harry@kernel.org,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	rppt@kernel.org,
	mhocko@suse.com,
	surenb@google.com,
	sj@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>
Subject: [PATCH v1 2/2] tools/mm: slabinfo: preserve the average partial object count
Date: Wed, 18 Nov 2026 14:03:17 +0800
Message-Id: <20261118060317.1802620-3-wangxuewen_ky@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261118060317.1802620-1-wangxuewen_ky@163.com>
References: <20261118060317.1802620-1-wangxuewen_ky@163.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3HwjJP_1qmvfEIw--.16665S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xw4UWw4fArW8KrWkZr4ktFb_yoWkWwb_GF
	y7t3WkWw4UZrs7Gw4fAFZrXr10qF1agFWjyFZrtFn8Gr1UGwn8JrWvk3Zay3WF9ayvvF4a
	qwnxtaykGF4xKjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUeSPfJUUUUU==
X-CM-SenderInfo: pzdqw5pxhzv0xbn1qiywtou0bp/xtbC7wwdBmr9P8yjdwAA3I
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D1A3420007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: jmx1anzhzuztsjpi6oaym5977msea5cu
X-Rspam-User: 
X-HE-Tag: 1794982029-66876
X-HE-Meta: U2FsdGVkX1+1NgLa5OR67uVYZMS/Foii2liiqO6R48np3ZZZX2h9IVjIcgxgmR9rcCWO1jIg3gs2v3F+pE4HHVgHF8aV3+7xy964jV+wF+9GgTpK1Bh57O0wYunAdZe5I4gxFpdUn7aTNaVigmnENUIYPOawhvNubypB1lW+VGsSJzaUl6V7Zhj7UY5K8F9rRy8PKO9dCHqPcCFhb27pQ6iopS4L3Fq0r4fxxq1D0Vwpwby4xeenLjF6G15+7SNJxu2JjwkGL4tFCQGKlniXLgglOE9ptEJTANTDecs97zJAm/bLjj80CK9KNtf3TXbPLMQrj/Rd6B6nJI1ZRKElQ9qo5/h/XUIhcumuksBhYeNfCoxbEak/rqWF/ymJNe/Mmm/mTMcLNyz5lGT/+WSFXxNXTKnG7nsiOj/AR8p6ggJ9ZN5fp9isoHZ6eoiFx1Uw8LrRUHwSRGJ/ebUcLFXA6NRGrglU0QroMxkVOnsbJ1iLulv1ic4lrJNddRp092x4C4DA16UUhRrTp0K0g/lwSV/MAkllHDZdlTYhtJmiD1KiWyvoIqFlhpGMO0kUvcV3LZBsQdNpatV0j3qhY8e9fOfsShVxuRKDzMP5olau33Y4XOZ4AtpIA1xVZfTPxWbXP41VMcWwt10+Z5zL7uiYJvIThgyAWy6UMT1Fm2ly4a79QhG2mNw9PLy6334q0dfofpMBczHzXHKwDzybi4zgQyQm2KBWxdyKHjAxqg1ivrdvftCkZoNNFLx54DX0PrLAXw6NGLF8elOfQWMFwmoZXB3G+zdK4jlijV5Qcr36S4MIo/b5rnFtx2/ZquA9NxVcKqE07rcEymbxp0BQ/ManUlGf1vC2g+xF9VjNaZsS1imVWAaFS+11owUQFWytp5fbNUEoxQxWytDdBbR6ZvZmVT+ItYC2b9Y4hYom8Za/Hwe1vCojimR16M/uzkAbFyZ1RZk74rg00d26uQCrbzp
 q7yZvAZF
 BkY7XRGYdPPD8yGUdepKlCwj5s66gjLIok/0DqoKdRNjubWbQBl+k/WeyVhaqbXR6Rj2MBQ4ggCA+D6zysO9fJJwRv8eJP91FFBGG9JCurT+b+dgqWyz8Sn8ama2NqOb38oMu5HKYJqYuS7+0OC2bjIjvPFe+1KxOYOrxhE9FsXOlEsqo3187fKmnvwpaod/nGVoNGfAQl9bI+7kXcYGkvG8giG24CCFiZrrCdqizan97VOwI2/eBUOPkPS1ibQYLEcPl64KM/5dhu8+O0sKVaz9UTs87kyh6HURlrdLI4fPJVYLT01MwN5PhoMEd8gvatYY67bjf/LwTYlE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Xuewen Wang <wangxuewen@kylinos.cn>

totals() calculates avg_partobj as total_partobj / used_slabs, but then
overwrites it with total_partobj * 100 / total_objects. Consequently,
the PartObjs Average column of -T and -X reports a percentage instead
of an object count per cache.

Remove the second assignment. The aggregate partial-object percentage
is already calculated where it is printed, and avg_ppartobj separately
holds the average per-cache percentage.

Fixes: c09d87517298 ("slub: add slabinfo tool")
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
---
 tools/mm/slabinfo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
index 3e62a2fccaeb..116625bd1110 100644
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -973,7 +973,6 @@ static void totals(void)
 	/* Per object object sizes */
 	avg_objsize = total_used / total_objects;
 	avg_objwaste = total_objwaste / total_objects;
-	avg_partobj = total_partobj * 100 / total_objects;
 	avg_memobj = total_objsize / total_objects;
 
 	printf("Slabcache Totals\n");
-- 
2.25.1


