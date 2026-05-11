Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD7B7CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5610C6B0138; Mon, 11 May 2026 12:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511986B0139; Mon, 11 May 2026 12:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D9B66B013A; Mon, 11 May 2026 12:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C95E6B0138
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:34:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D29631A01B4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:34:32 +0000 (UTC)
X-FDA: 84755687184.23.8AB00B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id E576740007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:34:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hcAKKDva;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qrEvTBLdPSUHl0O8P74dXE4kuITaDmPILiD8TB61O4A=;
	b=rRPwxnSCkcwbZ7pX7RFGAAGKRKCPcI+ZJeoM+Fq8Rxt4fDp1CUQJXmXUvZtVl07IaTMuCC
	y+mo9Y0KoOWf/QAqzfMiKRYHDiQ9a+g1EhGvJ54JvO0KNJbDNCJK8AR6LXdfAvbUEtxtWA
	WV+T743EOgfHHHLv2oXokeqra19aTlw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517271; a=rsa-sha256;
	cv=none;
	b=Rp3gS920m6R48tdXW4ks6iYe4vb9TBUFj/n1PQlLXZIxlxM3KVHMWJu6mB+LIjy34FMsxf
	yv6Snd/JqRatT5eCUdTDXtgaUYTcIMoA9XIqbkzwxQR3y72FQWZMeU4qBIAcGClMxS7n0w
	zjQszWhRMWyxH1fOou/GEB+i5FS6nQQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hcAKKDva;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1CFCE43704;
	Mon, 11 May 2026 16:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D16C2BCB0;
	Mon, 11 May 2026 16:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517270;
	bh=7xaEO0jVC5oa/tRtrz6y7cMEa/ulRsn9VdSuUhVaWnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcAKKDvaGGiwoqAumYTApXmbnL6JF7KtdECplSQfIACzSO0/i6P87KjHbI7dE1n/d
	 ZVClLZgoS7v3iibq11JFq8e5QvkGpFrSepUow4mD/TOJHiZA9p8a3JAR7zsAPMrg/W
	 jy+C3CNa0JUv7reaauSAy2TRh56CwHIfOdxWwLfPh2HjxttgKXNdN68/Z5Ki+RSXrg
	 E/p3mliWyePXA4GU1OxEGyR0+kUp/LDY46qVfsMt4g/x9Hmirs8wb4ojNjuTzd/+qo
	 PWdmksodT1qI1yH5YEiteEbNj2SMk4kLW7mgBkvr4869J93mtQazXv21PceCGHdg29
	 YXTva4RQQ3aeQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Li Wang <li.wang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 52/55] selftests/mm: va_high_addr_switch: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:36 +0300
Message-ID: <20260511162840.375890-53-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E576740007
X-Rspamd-Server: rspam04
X-Stat-Signature: 47ut8opx7kaupkx146fygqdx5zg4rwk4
X-HE-Tag: 1778517270-190376
X-HE-Meta: U2FsdGVkX183uoD72imIC4Tq0IvrS35BOI2Xi9X+EX86x2lrKk/+mS7mKNyuZmLVe1M11mCSn8Bp64G449ZGepx3wzFf7T7Q6ZB6EFrXTfQ9BxDDsupCe4YEM9CELYxS2luDD0O3XqrTKvhtsZauhOJZPJqjY6TzODFBljV+KRhB+8VU9iLLborIvdDTFn0KOM3Igw3IB9WPoyL711YQ6UzG27hgvkW9hdjVY04kJ13xBzBRUDlzt3z3jDeV+VPyVLSOZU+pVzkcx5oUpmKM5Y4WLork8y6fiUyDI1A15qcgyHRRd5k/PqE9oTmpkFfn1N8BZd4DpiZw9d258x12n4+l/g1vIrMolW+MuJTe+XXcRinjmYjSRib7bI1fvuqHS1ks9bsDXGIl/srV/lEZk1t5Umug3S3wiKjuCnjiXmoUuqQM0wK+ojHZvUR/C7QnphWCMXSaPScPVyo/JFpUoWvK3XufEg32FY9r6Qt1yB9r2v5ZDZPw9I9cHzPTovv45fos+sgoZQ7NGX3OMOE9mkCi3zdJqb7v1hdtau0rT7/FXIG9SoQA5GraLuK0Y2ADeT8b8taDsHtBs4BJbx4JV7JYSQlk6B5JJp4hlBMeSXBUWG1JOj492EziIJnVpzBL4cBJNxs8j5cIHHuAkTdR2bS9M3J8dxxw/1RHDJdxZZ6iGmCMC5qSejT+JenDbXPa4QAWLh4NlYBBKa0NyE78/auJMRM51w3gcm7NGf0nIxFNeFhoVvuphYlxnORZlrR9sOK4MKfMDADkzSGApvaF3PHcYjIK+AlbtThkGbC8WuNAny5ySlqJK4HEvJiCaLiteOmwGDnHsy5Kk0/9WLvihJ+ywbjPiLe+lPR/627jCB3oVdHsIS69hRsZ/tJrhZBJUp625WtCw3Q8BbkVW3UKI0Y93OWsf5hq2TZlqS2oC100cRR6OzK+UXnd57++Bi80h+3WOdGJWG8rS3ZMkpo
 8Mp+ffHB
 VGixujburXIrLUYtcSci9OBlUFL/YhoHRMpkbsySnubV+8LWyhMX2dA0an5zrL34TURD+pTsDpC0GaUXX/bPjB3EyYbScRMpleMs/0q6axp7jxpdBGv8YZ5d+IoeolRvRJJweeom8+VTdkOjDLsemDWSAARWWcb2e/hz5uaLon2napnp6R7sjoEvWPmIA7ycz9xwm/wQpzjkHnc4MhztRL7xFZFC3G+vsagP1kZYkkweqdjlRMyOgpJGShov6nqBGy1wHtkC2yNzECKj/QZDMGsdJYhxVyF1wG9kJ2fL0UeimPMMnoso7vM4aaia15V4DblAJv07goMhBKCpfv9oH9glokLkqRRPh3U/Ele5TG2qxm6I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

va_high_addr_switch skips HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/va_high_addr_switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
index 0b69bd4b901d..e24d7ba00b44 100644
--- a/tools/testing/selftests/mm/va_high_addr_switch.c
+++ b/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -325,7 +325,7 @@ int main(int argc, char **argv)
 	if (!supported_arch())
 		ksft_exit_skip("Architecture not supported\n");
 
-	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
+	if (hugetlb_setup_default(6))
 		run_hugetlb = true;
 
 	testcases_init();
-- 
2.53.0


