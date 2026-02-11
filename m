Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D1E8EB595C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 03:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5AD46B008A; Tue, 10 Feb 2026 22:30:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0EFB6B008C; Tue, 10 Feb 2026 22:30:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35536B0092; Tue, 10 Feb 2026 22:30:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C464B6B008A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 22:30:08 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 768361B29B2
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:30:08 +0000 (UTC)
X-FDA: 84430747296.30.531BD02
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id DA0604000B
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:30:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="Vx/PWKIP";
	spf=pass (imf17.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770780606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ORVMZK9TTKMl+jFhx+5kZzvswRYg3GhA/r8yrkv73eE=;
	b=XTZ6m5qio4ERhTS+fTwsW95j8FBjdTCqvKlzYX9Gk9YKkJJPx+EQKss7jl2Xtm/H1cztzT
	I3x3nemZ0iUEk6gqmYynV1gWf41Z5SEKLKvNVDJtm3yfoCdM6lK0MnggPZfWQfczpyBj5b
	x09/mwx0gjd46TLTbKoo8j8qg9MzM+E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="Vx/PWKIP";
	spf=pass (imf17.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770780606; a=rsa-sha256;
	cv=none;
	b=gZlmogz+8CNYgfHd5EmRpZ6ob1cXlQRCs8bG/HkDwddeoDtZervjm3XP9y//sCRFloqjE3
	Yp8ZaeBC3KsPHmC1Nup/DgI5+h5Axy00pU9JLhvoB4l66P6mE6KQhTTo9vT04ulq3lY89R
	bHMkSx9Ws0G8atqrd3ITxrlJF4NpNw8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=OR
	VMZK9TTKMl+jFhx+5kZzvswRYg3GhA/r8yrkv73eE=; b=Vx/PWKIPqvGfFelh/g
	KfFjktTZZm9TEtVUQeXkFYUO2aQlZM+uQwAIUZMjUcLhCq2LVsIP6O+esfL3QYVZ
	my8xCJRgIrWl2aNHNts4LZ77merEU1LF/uR9WM8mSi1Fai9gH00SZLvkomwfSo4S
	KAw0+FtvoH3dBRBzspho2KudQ=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgC3f96j94tpMZp0RA--.2981S4;
	Wed, 11 Feb 2026 11:29:43 +0800 (CST)
From: ranxiaokai627@163.com
To: graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	akpm@linux-foundation.org
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH v2 2/2] kho: remove unnecessary WARN_ON(err) in kho_populate()
Date: Wed, 11 Feb 2026 03:29:37 +0000
Message-ID: <20260211032937.208353-3-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260211032937.208353-1-ranxiaokai627@163.com>
References: <20260211032937.208353-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgC3f96j94tpMZp0RA--.2981S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtw1xXw17Cw4DGFW8XF4Dtwb_yoWDKFc_WF
	4xtw1Ikr4qvrn0vr1Yk39avFWrKw40qFyvv3W3XFWxt3W5tayj9393Zw4DAFn8W34qkryD
	Ar1kWrZ8tr4fWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRCHq2DUUUUU==
X-Originating-IP: [117.176.243.201]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxgdksGmL96fAXQAA36
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DA0604000B
X-Stat-Signature: hct7zwn35mqwwcjq97wbyw9m4frbhzi5
X-Rspam-User: 
X-HE-Tag: 1770780605-527173
X-HE-Meta: U2FsdGVkX19Coed0F3MHwoRtq9ExuT6dl3pFcrDoehu30+70JUZ4oKPEWPA08EV4aS5dPjnSmdjY+UjpzLZpi0/u3E+qiMKq2gaVwrocAwK24axdQNANZnih9sa17QZ69sb9FBT5iq847yrsS12F9wMs5ZZiS/z+u8t38fQqv3769jiXyRj19D6bhbpqKioXmD/+Mb08/OP1lzuA2zz1aAp6MuAZwkFohB6HRni4dbZJ5+PCM/mmqGLfvk3TNsfEb2tNTv9ElYYLhecVnciNSWLg4rC55qVOr3iAcxX2JqNzIP7UdYsK8+1uoBhvHncCTQbEfnnoHvqdc6YGmwpNRlNmuwNUCgAfcfFJkfl0Ge5Ud2D1N2bfn2hsMppe75jpLIZBCk0zO06vDmxTcK3y3ypTXH4XgPEgzETSayfDdJwbB6e7l41satJy4BQHV0RbGNsfSKfpWcHJncIa3PSmykRiuLM8p1ZkI11eLmd/sjhN9Q/7HRYwc1wUjK8eSgfGzGsgbr+d0DoRYpaibadS5Hr90sYgwAvl8ETNuMhnhEGqsRmgRh2jB88NtBaHN3cy1dR5PMKlKm7soU53QQ22cw6grl4L8MldCsaEV594zKzk2XvXfds4jGOoNb2Cz7NtgxORkNNksDmFwIz1yZMtWpT8/g1Upxis3ylPfwGjOA/zQy3zPu+JQgi5jIIw33SuDHFLVr4uSjaV1g15gQqypa8fHAQ5WDDdMe/7WylxgxhvqSqvllfRhPwDC7APLLDYPdlriaXVb4bbKv/XhK+AvV/rtIL64zwmn+RaAur/+OwlFHZHNtvpD7hUMU34oTPFn747k9bgqR+B9YGA6NlmNeB5a7gQSc/jRS4aipfSDlkI2uLjoq+tcc5tRJ3QmtJ/yQosKC/fjwrnYnNI4eoR8w1D4Gb7KsTLWuso4zxXFKKakIvrzglJXIf1T2eoLvCJEqcNdymGlGFT+SCdhcK
 7v3U/htS
 2JGFWn59Z8u/c2vdlidRM32KSdNr9iekk/1yIZdN2NQpiUa2LJUCbMYvWjvyzmaVaoUSqnYRgw80+weem6uWDAbzLDJiZcbfTklZsxl3oU+ShHg39pcR/MJTlnifcNkyPbqiNZOr1pu01KcVH1y8ykkUtDpFHad+66qfrIqVGew8yfRC/VN6plD4k35DfI3YmpuSNIxFhRuB8ZcTWIgEb0QpU4Al/A99OJp8dJC3EvPsoftEu5Ispovu0fvADLdJwgbTTfoN7TBBsyW1NnAiK9eyVkp6t+4fxsWqprrQhWRHjchPLsJPmKmLJ/ZQzsTBSMlHZXyBf4lGZpgdTDJfJUZzL5Z4bj/Pue+vOAYaWcXLDCZyYAllqerLpK4igBd3W+Q49fyA6JDouR3Ky2r6j7ttHAnZzcCKlEzTDUt9H1I1l4cFilmyC+J7KOpWuvxeR7OdgI9ZfqxeKGv7IZ/wLvylmW4W5LiVLmJOLEBiNOB02LRo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

The following pr_warn() provides detailed error and location
information, WARN_ON(err) adds no additional debugging value,
so remove the redundant WARN_ON() call.

Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 3c705b08a489..eb87d23e8da6 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1507,7 +1507,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 
 		memblock_add(area->addr, size);
 		err = memblock_mark_kho_scratch(area->addr, size);
-		if (WARN_ON(err)) {
+		if (err) {
 			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %pe",
 				&area->addr, &size, ERR_PTR(err));
 			goto err_unmap_scratch;
-- 
2.25.1



