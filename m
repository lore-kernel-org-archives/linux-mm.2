Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D433E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 04:01:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3D026B008C; Sat, 20 Dec 2025 23:01:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF4C36B0092; Sat, 20 Dec 2025 23:01:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C13D46B0093; Sat, 20 Dec 2025 23:01:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD0156B008C
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 23:01:05 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 70F728B428
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:01:05 +0000 (UTC)
X-FDA: 84242127690.21.E384BE6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id B03A4120015
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:01:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="aQiL/5Sd";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766289663; a=rsa-sha256;
	cv=none;
	b=oNN2fKIKm6rqiLC4z/D8V5tMAftrUXUCou/o0Ty6NO3hqbym410G/sPrzqUv2s1vzH00zu
	jFVYeejF/NPC4Yi1GeycXF0lW1a6vAu6u7AwNvBiYe4MsVWUEvCnZGXOuj1qgOhSWMhQoQ
	bi73/sOH2jfddCB6cOMsrnQQU/uAB9g=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="aQiL/5Sd";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766289663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9qvWdknSv9E7fxj2/6q8B1lq22rZkxKblz4jOQ4Dio=;
	b=y0zbuuySKfRokKKMUYqKMDo2Z/GmUZtoJAc9Y6JCjBL++FB4xCNe4+RAs/9QU3KdCo6Jpx
	IwWbbzaVoLKz8pXeoH3mv7DhltEOz+/TnFc37bowCQmY+12vXVpulQNyv/ydnAUsNz6vdr
	cREok26012NuL6ZY8y+sUOXYFcUf/eE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766289663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x9qvWdknSv9E7fxj2/6q8B1lq22rZkxKblz4jOQ4Dio=;
	b=aQiL/5SdewRYziWjh0Nf2SkWbkSzqBkLKg9tm5QgTv+431iRo76Ewb+BMbh01un3qAiKh7
	ZsRxgGpsPJa7iEDP3nx5hzy4Yl8FS2sgplbRdQ+Favert5AJoDxx9D42jbKkAkF68cNimx
	68ySNzpPYSi7Kq7P7Nx5lRzJD3/u2Sc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-379-q7VyEp1NPOWdFG_vCIl5JA-1; Sat,
 20 Dec 2025 23:00:58 -0500
X-MC-Unique: q7VyEp1NPOWdFG_vCIl5JA-1
X-Mimecast-MFC-AGG-ID: q7VyEp1NPOWdFG_vCIl5JA_1766289656
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F17C1800342;
	Sun, 21 Dec 2025 04:00:56 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4781319560B4;
	Sun, 21 Dec 2025 04:00:49 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	chuhu@redhat.com,
	Luiz Capitulino <luizcap@redhat.com>
Subject: [PATCH v2 4/5] selftests/mm: va_high_addr_switch return fail when either test failed
Date: Sun, 21 Dec 2025 12:00:24 +0800
Message-ID: <20251221040025.3159990-4-chuhu@redhat.com>
In-Reply-To: <20251221040025.3159990-3-chuhu@redhat.com>
References: <20251221040025.3159990-1-chuhu@redhat.com>
 <20251221040025.3159990-2-chuhu@redhat.com>
 <20251221040025.3159990-3-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B03A4120015
X-Stat-Signature: tu7ttqx3r3wiuejbqks7wop9bnsrq815
X-Rspam-User: 
X-HE-Tag: 1766289663-233204
X-HE-Meta: U2FsdGVkX1/oC3legb4iX488x3mpQaUyFwRBizLCr3DDc1KMnG+tGMtAlNpHMDFqD6vXD8uXFbYSHvaE3Pv0HMwNdIS+XGOunCvx1qX7GND7WteXe3ChQL15lXK7a9toKqvwyonI03Y0H/zsBO9ezTSTJek16BejC5RnweWnoYdCCH9QrSBhwzVRBeiB6xuFC1mO4Z0dGDvVC37eLRiMxaLFxqjJbfOhL+QhGpJZgJ5Us5MS7hIK3rWgygLcbc1MNN493BkydPJP7aW2H9qKmm/rHTVpIUZ/6LcYWZzQyE2f+xiPV/JLGVxJkcn1o39Weon9YjbnTbESgJkEHk6Osi0knGFK+feVM2DoYm+JlnKLE7ApqWrPSR91ft1pzq63iGLMKNDgQ8U51VSdP+3Ez7gq5DrhFSr0SCCma32Cwx/rVFkWK9vtxen44m6c+iBxX5tznUiTKeKKZ48a2t2Bn5VoGumbHvNhpu/fhtq+0zFT3Lv5sRYl2BfLAUBH54P3q+87BnMqdO9eFu0b4t/rOsO5DhJSCil5N5XuUB0y8IjA/qGsa79chfFA2cCUDdWjE1TfXSNBrRRV/9CT6j+znPJYtysOkT2q96y1B83ANuwD/c2DGo2wdjFzkZV6S7ISqeFNSCAWFGTBD9SqApWNzNsJ1riHKFu8ihPoWyBTzS+DZE6atSYQZc27LhSu3bHADmEouzycTTfIMQo6trWrFX4mxY0bSxIouVifPs+GUg+YJbG1co0tZCGcYKDcecsU0yjrI8BwvuimtbhoZpF4L+oMgbdlgU+7cC663uNlUNCktks3aMTIAe9yJxH7cIatowD9opCEkOKAIYyZ/ekiH/myXIdYc3C0g4rHfIAMniD6J/BseUOUwwcUB4R0sRI8a/loOl+oKaVo/EDbnNNjLSa8FvWSkfAINK52pLbIw9DPRcJx15o26OXYiFtQXpYIk1V+1ZyQmFe8a8UAx80
 /i1+Eq7G
 G4iioBw6SZtpFPJb8d5HhYgeHUoiq2WmDBKC54oqPR6EkMPj0CedCSMb6HbSVAWHcvUBx2AgJ/EFtDrlzOIWLCDGxvKRRNcTAc/GdA6KKsbn/z9PErpnhYLgbRSm72vUa7nAAPMGYFo2sPVo+y7zs8lOMxY67h0RWI4FSI4xH9LiWDTUDscK2yc6HPgkRFFc+nzMJxlTG/bj15PTQGVo+4SK5zfFvT4/Ym0eMJ+59MppHhS0oUU+FhBLudf4ktAlz9HdKmKuoCRtX8NBmCfj1OmCow4xpitVUuQr5nobhEUQGXnenQpVJEdPkMeDdXExGD0S5ODL/w6HhhRAtt9RbGzGVk/+29syb13idW7konM2AVSVGx0o/iBRCQBi3l40pZWH8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the first test failed, and the hugetlb test passed, the result would
be pass, but we expect a fail. Fix this issue by returning fail if either
is not KSFT_PASS.

CC: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
 tools/testing/selftests/mm/va_high_addr_switch.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
index 02f290a69132..51401e081b20 100644
--- a/tools/testing/selftests/mm/va_high_addr_switch.c
+++ b/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -322,7 +322,7 @@ static int supported_arch(void)
 
 int main(int argc, char **argv)
 {
-	int ret;
+	int ret, hugetlb_ret = KSFT_PASS;
 
 	if (!supported_arch())
 		return KSFT_SKIP;
@@ -331,6 +331,10 @@ int main(int argc, char **argv)
 
 	ret = run_test(testcases, sz_testcases);
 	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
-		ret = run_test(hugetlb_testcases, sz_hugetlb_testcases);
-	return ret;
+		hugetlb_ret = run_test(hugetlb_testcases, sz_hugetlb_testcases);
+
+	if (ret == KSFT_PASS && hugetlb_ret == KSFT_PASS)
+		return KSFT_PASS;
+	else
+		return KSFT_FAIL;
 }
-- 
2.49.0


