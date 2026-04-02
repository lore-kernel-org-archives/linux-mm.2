Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE186111224E
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 01:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DA256B0095; Wed,  1 Apr 2026 21:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B11B6B0096; Wed,  1 Apr 2026 21:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7D76B0098; Wed,  1 Apr 2026 21:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29B916B0095
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:46:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 739588B4A1
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:46:41 +0000 (UTC)
X-FDA: 84611926602.30.8AA427D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 81F364000E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:46:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BxVvJHdQ;
	spf=pass (imf04.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775094399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KDU4afNqvnoHoqSo/k3e5WTx+bzCLp33/wZdOxE3SPA=;
	b=vqo8sDb19b5/WnSsdnyVHWzHgLFvgeI0cM+p1F52g42qaLs0ZFq7F4vGSaKXh0wd9rO98o
	DyBTO5uA8a38oyD9T0E/5iZgyNVLZkiF3di8xMWvfECsNttU4uZtAs5/sM7z13RmCxD4JA
	le+5VPfU2MVEs+lg84kRycZmCnina6g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BxVvJHdQ;
	spf=pass (imf04.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775094399; a=rsa-sha256;
	cv=none;
	b=AVKmWmWF7Zpk4Osu6tjJBMB1cYDZFbmopicITwqjoTsyie0IGKz9EFXI764YzUcMireadI
	zSzECUrJ584bV1al4cSHvnNT59r/XgIwLbCHOrNt9QhFbjhEQXJDL4lNt2288eAj5bdnnN
	FGJ+j8Z4OzU4AGv9asZ8BMQds2rtElI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775094398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KDU4afNqvnoHoqSo/k3e5WTx+bzCLp33/wZdOxE3SPA=;
	b=BxVvJHdQXO9rjZVTxcq8roXzpfCrqygU3QIHbSdddJuCruWmyxtHsMH+jWKCsi0UcH4or9
	+YVQ7JrmMkaSGRJpDqXK2e88Vyp5wiFysTwAm+bd8pabIlStZNk9xZmegMnaRb1G8Cfp2g
	ZVFy1iHIhFXDtMvoGObbY1guI8TqsYA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-248-CzV-77pMPretbtz4CzGeKg-1; Wed,
 01 Apr 2026 21:46:34 -0400
X-MC-Unique: CzV-77pMPretbtz4CzGeKg-1
X-Mimecast-MFC-AGG-ID: CzV-77pMPretbtz4CzGeKg_1775094392
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 09E8D195604F;
	Thu,  2 Apr 2026 01:46:32 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0862F19560AB;
	Thu,  2 Apr 2026 01:46:23 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	chuhu@redhat.com
Subject: [PATCH v8 4/6] selftests/mm/vm_util: robust write_file()
Date: Thu,  2 Apr 2026 09:45:41 +0800
Message-ID: <20260402014543.1671131-5-chuhu@redhat.com>
In-Reply-To: <20260402014543.1671131-1-chuhu@redhat.com>
References: <20260402014543.1671131-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: UtFObJvOY7xmC-ebp-T4ULvZRjFyigzTYEO3XHpp5so_1775094392
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: 8ygzzdssufqofkoqerr5gtxtunbdyq3q
X-Rspamd-Queue-Id: 81F364000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1775094399-300976
X-HE-Meta: U2FsdGVkX184uY0LG/fZ5Gi2634UVGctIyy+lfZswVgBBD2iM5BfBTgXLmJ9GNNMXEaGxjsFw5zlqH8wxiF+ZT7xFvXY3MmRE2nyVj/OBFFPLZHaiwyjw5zfyivbsxXNDkUd7Vwu7rBgl6K+2xweijEKNmzVYH3qkp2pnx4pSBi1sl4R04/rGFnx3QjrKK+GeHphqiRkFPMw7ZebqChe3KNJVIKTjgSbVuGccZuvHvyqZhTFlIp+Ct9QY+bw7g91Ks1/YWXcn+12vE9W/zZp6FEK6fhr5GDP0UreFlB72MzJhGRQgyAgUW3/adEUSJFWhnH7qKX94PML9UCmBVfCjrTggH8PSLawKU9UFztXSljqBDyL0b2dfAmGexDd+iewhjaappuygBsGnKIcA1kiw5ulxeDL9zR6S1qVqez3H4G779qG8SHE3Mfzhm2EijurFqulTEwQ1yyRNiMRznHV8Tgd+qa4g6/TiTAlOGTUZjxfckhG/nO1xKYMHQ78CHUN5+EZ17Jh5QJeKf3lO7tOmcYLubo6EuidpSVCqKwiW4+QMlGARMqM10V4PwuLVeVx2vq7lN6k/2erpe2yJo+2D30WOyBLWiNMPHZBdv8jbHZzP30rVXXmNORsNprUpsRJ3zCm4HIAKaZ3rbZZ6s1x2v64eIcaQHp0myh+DdXYRFBK8I7m6eklzEtJ2E7ZF+tE7T5EMRGklEeBQzdcwFOchWWp/XPxIunXH2JxZZrHL4o/eWXtyZJXgdEbSfffhEOmrUO9jhmfulbIHjd3etZt0IyHFKR9KTkfs+y/gMNSBg+LJDlSPs20YdHFe0aikgVCbj5TDTE5MMPpDa360T9yFewP5eqYE2jhgPQSln8s4pdIRZCdevf9DxbJY1DoF4y3YPfeG8D6OMyQiPDF4Qi39uvSvC4UEYlTp773NexjB4yubwNh3zk4JCYfV33RmLiC3m7MHv8e6ssHQ+DotIw
 Qa+bWb93
 XXAiL4LkWGiZ3ZRePOKohBlYLAk+cJKcWCpjgU7y6JkEh6ZQk+GJm236InW8Y+fI9izMlKBN/FuV5RD/iH1qlKmf9yCmA0wky8/NbnM130SRc6U1rsj4I6OAr/hK5HG9Gr86+R3gmuCuNYu/QNcS09JHVAIUVftXTyngDpGeZfrD1llhXy2lx7XWwTk+42kZ8T4wcBloclNeq1YTaioRX3jxVoWuhpQfxL87Xjq4QG+gS3+ty3biJQqaL01VSGIe+Z0q1xtSe1bhYPWmJRKLrGgQca+i7qa5xQSrCcxpcfzRgWd0qCgr63/oUtWGgBkwSCnPwamDPug3JIOIzQLcwcBD/yQ6j++38g/VDwkiQYih2GH1keg8lMi9lO6APMUtDjrxW6WmaJow4Jb0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add three more checks for buflen and numwritten. The buflen should be at
least two, that means at least one char and the null-end. The error case
check is added by checking numwriten < 0 instead of numwritten < 1. And the
truncate case is checked. The test will exit if any of these conditions
aren't met.

Additionally, add more print information when a write failure occurs or
a truncated write happens, providing clearer diagnostics.

Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
Changes in v8:
  - go back to ksft_exit_fail_msg in the two error exit path as no clean
    ksft_exit_fail_perror that supports va_list
Changes in v7:
  - add an empty line before the 'buflen < 1' line.  And change to
   'buflen < 2 to limit the buflen at least to be 2, so at least one char
    is allowed.
  - handle the numwriten < 0 case, which is the error path.
  - use ksft_exit_fail_perror in error exit path.
  - use %.*s to print the buf when error happened
Changes in v6:
  - save/restore errno before and after the close(), so the log could show
    the correct error info on failure. Suggested by AI.
Chagnes in v5:
  - new patch for making improve on write_file. Add more safety checks and
    diagnostics info in log
---
 tools/testing/selftests/mm/vm_util.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index ad96d19d1b85..db94564f4431 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -767,15 +767,24 @@ int unpoison_memory(unsigned long pfn)
 
 void write_file(const char *path, const char *buf, size_t buflen)
 {
-	int fd;
+	int fd, saved_errno;
 	ssize_t numwritten;
 
+	if (buflen < 2)
+		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
+
 	fd = open(path, O_WRONLY);
 	if (fd == -1)
 		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
 
 	numwritten = write(fd, buf, buflen - 1);
+	saved_errno = errno;
 	close(fd);
-	if (numwritten < 1)
-		ksft_exit_fail_msg("Write failed\n");
+	errno = saved_errno;
+	if (numwritten < 0)
+		ksft_exit_fail_msg("%s write(%.*s) failed: %s\n", path, (int)(buflen - 1),
+				buf, strerror(errno));
+	if (numwritten != buflen - 1)
+		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
+				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
 }
-- 
2.53.0


