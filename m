Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF2D7C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E374D6B0095; Thu, 10 Sep 2026 08:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0ED6B0096; Thu, 10 Sep 2026 08:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C132A6B0098; Thu, 10 Sep 2026 08:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9810B6B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:57:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F1A3CA4F47
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:57:06 +0000 (UTC)
X-FDA: 85197852852.05.D34EB13
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2BCCE120009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:57:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CMKkmGIg;
	spf=pass (imf29.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789045024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6mRdG/Kt6hS/eZlSBVQMx/QTMGuDSPWApxK45jZ1fD0=;
	b=2QFKziTz0QfEgLFBIytVWduIX24a1AS1b1OvJXECnHyzfQZaei0pmue4REouq8VRRK1NKc
	WUvV4zRFfJs8ftwgrQg31G3+O/HIwtKxgOtIYpyqfxhNALx/XFh2y8ewOBY0sXSyTNCcik
	A5uisQCq0FxOmPwZEFEsplmcFqmL/88=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CMKkmGIg;
	spf=pass (imf29.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789045024;
	b=I/0o/Gb832qLnup8CD+D5LOX+gEJYWkmLLIITJN7TnzQsmaFHpOjb8yWozpHlP225ZoFO6
	y3zYGoZRh+TCqhnoDPO6rcqas4RyUdvDL9LVd4X6a8Q0vk1g/gufAg8vdklxpU887o69xt
	1WWtfFjBBBdijTWlPI2+qW0KAL5kduk=
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-396a51b2605so2892791a91.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789045023; x=1789649823; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6mRdG/Kt6hS/eZlSBVQMx/QTMGuDSPWApxK45jZ1fD0=;
        b=CMKkmGIgxgeEpzVDr4A5pklbdDubX7IB877oVZLOzPU++BlI5Tof3nxDMtKCT8l/yj
         Eq8eJygaPxdT7aZIZ5XXi8H34xVWW7lRC1jHHGCrLhrJ+bcJOnJvZCeog/v1m5uA5RYo
         KeNV9WH2q6B4XNy0inRQ2deQfdYF9/RL45q9igj/9anA8hY42tU33ELIt7Yh4xlRks2s
         FtYNiQb7RtCh5MNScIyMwivZXzIHiDl0PeaeK1txFKHPenIn+YOkVn3brgqvmqrXUZIA
         quCcHkI3VzjUxpBrCLQjfVnQCG0Q123Vxj9Ff7Py9h+SorXSv4FOm9Y24CwafyDGZ72Q
         XRbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789045023; x=1789649823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6mRdG/Kt6hS/eZlSBVQMx/QTMGuDSPWApxK45jZ1fD0=;
        b=hCtnoeiAVuEUPhZPHR5VZWmTixoIA7sDD5K1HYpJiCS0U+6VO1M0KVoxs4UyIFMULm
         wWiEcc87TDwFyAOuVmeZbEcmrIhtu1fUnZU5h0K1vluKpR6YCvuflroRveGIPufB8r9G
         +ffVYATXVOuhraJ7s18iJmj2kUK43MJSKWl6mMcW8gcpKo8UnquR5aGKaCfbuElh02VJ
         p90/cqV1fSRKLjIvUZwGUgm23ZXY9gPV55SJGBrarPYh2RbkIRWJfkbmHFBOBfEYO47q
         DJjr5yd0zfLdwQTFYW+obT7LA5lB+0ojC3XB1JNSp3EgrcxyLL5DZ+YLbgyfwNcKt5Yr
         5qZg==
X-Forwarded-Encrypted: i=1; AKwUvBwLGawEIlbIB/FTOZ7RFCeVHWVzEG4N/wMidTtiRhkPeyyN/omJlmhW291STM6CQMEDg6hDLlZXjQ==@kvack.org
X-Gm-Message-State: AFuF++me1zfDJS2xDwjh/+y6ACrH9gBEMHAKrXeesdsvM+TKpyYvt5uq
	mbYVcG6Y/ZwGrWzfpzOuk17bSZFJfdmRqzV/yZJwXsNZV/N3Ex0PM+sB
X-Gm-Gg: AYBFou0KqHDy38wliq9CiWSA2+ZqPlep9t+R83pcUHMzFbSCianQXbx+Qci3pky/Qd4
	+rwH7zzVGgWO+m+4UOElfQQLqLPV+IQ3QoUhTAST2ppLK6skFLtxh02LcLK4m5ePvk+LyEwB5VU
	wwdv4tGlOzzjs+Q8A1+AtaTtGP6rsVXbl7ZIlzMzy+X92a08ZHorOoGLKNdZaY0Sqd5CGBFp427
	fU8EdtQ5U1q6XHJq0xv4Qdl/9ZD7gvcVC7d7YPVaZ3NPIC/CuwESQoWwW65qaiLI3I9vDgnd+AO
	3xMnZydlPHGWI8mAh351uhqXyNNwTDo2lfX6o44FA6Ow+uFczqz2wEIJiSsGd81jJOby04ciQuX
	O45HyxBkNEMmMOtAfsTTqm7FlDzPaWAT3qfRexK1tRh8qTiuVQwzBrKk49I7gfSHFqmFlRL4O11
	epINMd/jxX+8GSFvq5gzsWU4fdRAHWhqt+GXGwO+m3CqCx8vz4gWXGQygn3Q==
X-Received: by 2002:a17:90b:2d0b:b0:398:c794:ca26 with SMTP id 98e67ed59e1d1-39b263167f7mr60407420a91.25.1789045022916;
        Thu, 10 Sep 2026 05:57:02 -0700 (PDT)
Received: from fedora ([69.5.53.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d7e9014cbsm4800488a91.16.2026.09.10.05.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 05:57:02 -0700 (PDT)
From: Tianyi Chen <diannaaav@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Joel Savitz <jsavitz@redhat.com>
Subject: [PATCH v3 RESEND 2/2] selftests/mm: Only prepare ptrace_scope when memfd_secret is selected
Date: Thu, 10 Sep 2026 20:56:45 +0800
Message-ID: <20260910125645.285866-3-diannaaav@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910125645.285866-1-diannaaav@gmail.com>
References: <20260910125645.285866-1-diannaaav@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2BCCE120009
X-Stat-Signature: wqsjx7b3mp4jrg4xn1juaygc7u46w3ij
X-Rspam-User: 
X-HE-Tag: 1789045024-673606
X-HE-Meta: U2FsdGVkX1/i2XOCrsjVaAiMkUL419uq3WOu6A1yJIvTsvApK5s/A0g431W9Wwo2fwHr8sUWX4QxQjDBBMMLlawPYId0QncJR0N6fhu9hnd3xlRh0gvR308y4rZRY749Dmaf8rpD6dAK4n8V/fsa5TlGeu0O6Y1tjKkY+VAr+RZQ6s+iMsTIZtCwK9aQMSxVOYfFkuL5FaQy402Nq7MZ8tCmWWirDwPzvMBgNsFG/ULikTNVUiNaDjsBTA6ZBmX1Fj5VFpY88LZAMkJtTVKP0HLuzhVoGN2qI3jSZHvBEMUxWgJD3PYYv9GGmIlli8Z6SRpysiMszpGpQGls/2Ovc6kl71e/doYcA9W0UBoLy13ZHuDl3xHdCqK/qSC0c1pVEOD5ZBIMejVc9ft59cMetKxCUXzkK/Z1SPT66MBZPLH1yT3sFHNNNlzevpZOvCcXagwXtoKsCv8ckUq7pvdDA07P2ShnzOWkO2B8b1QrLVH5Vx+EEVxI/nFGXcTpERzfGIzaV0lzz1ELeve3I51PhDhB1rxZfm79EfBeHFGJx8OlfhRC1nuasx/Rbx7hdhu3kbUfYCel1r7YOt6X6fxfXCvch2441x5FIFiCN1E7ZqEINwHaYyH/bn9dP1qD575dfoBHHfFyw4XR97CQE4fp4crZ1ArZ70Xy6lIjon+e3izHBX5zBoJJnyjUF7YzonxY9Ye8DQKuTTcBqlzFYheXXCwmaCqqK8TqxEQXXh6ekwhIWP7MoRoZKT19j9AG2dY1pkyrhvdkPNSd5Slbx7YzGj+6txi9ZEn1IOko8fi7XTIF2A2+y138Uj2fGSqby+8WjSEiH73kxZ1X91dOrnzOxyaH9kBjcEnR4eBVPepeNOeZI6IR1npwEoUneGstTKV4Qz/kuTu4jE3jURQZsHHzog7HEyGGrxUEWMegwvfbRHJPcGaJFf3gjGlYLZOoC/wuDJP6qjt6r/mQPOha+vn
 Om1ZjGRb
 UHIuIzxFHol4jE04rMPU9a9BeNpK6EYLVM0+ZNXfsrtLU2QboBflx0V+zwAuw3dyVeVEkJncJL+7eS9JJ5Tf0w4GeYioFQ4PwMpCk0dbTsSFAlhKX6/AQqqYW8bpka+ScmQX6/66Ox3GPIXr3GdRhcDn0NzmshJDu/2MGcc98kW62Mw2qQN0nw+f0t8PZmTicYAtJgWn0M6wsRL4bhs3ROep40qPR2unv/11G2QbzVdyYNhOG4I77hXycllpgPsSug9PMP88ztRIbL01vUoGIlGaFC7tV3rNNZyFrp2UfmJaPdtZVOFvGyuRYeq2u9QWbV+NWo/9yuGirwcY/K6dVH5nRBnfZw5NPJzSRw7La2/oJ9TXkKZKpCLqVUJyv+FpHJoILV+cx2t2nUv6zpHCKXnysBg9e+7LlotXdPQSzcZgGWyoXopNKH0eS83KnuQL3gSKvrC/E07i3opA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Tianyi Chen <hi@tychen.cc>

The memfd_secret setup clears ptrace_scope whenever its test binary is
executable, even when a different category was selected. run_test() filters
the test invocation, but it does not protect the preceding setup.

Check the category selection before entering the memfd_secret block so
running unrelated categories does not change ptrace_scope. Keep the
existing executable check and the behavior when memfd_secret is selected.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 tools/testing/selftests/mm/run_vmtests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 9e62ab4c6775..9bbef9410ccc 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -370,7 +370,7 @@ CATEGORY="process_madv" run_test ./process_madv
 
 CATEGORY="vma_merge" run_test ./merge
 
-if [ -x ./memfd_secret ]
+if test_selected "memfd_secret" && [ -x ./memfd_secret ]
 then
 if [ -f /proc/sys/kernel/yama/ptrace_scope ]; then
 	(echo 0 > /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
-- 
2.55.0


