Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDC7EC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 772926B0096; Thu, 27 Aug 2026 23:37:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 723836B0098; Thu, 27 Aug 2026 23:37:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611D46B0099; Thu, 27 Aug 2026 23:37:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 351176B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:37:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B52A4A3CBB
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:37:48 +0000 (UTC)
X-FDA: 85149269016.14.F36504E
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0D62A20003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:37:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QuhpR2fZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3iQKRagcKCC4gPOVSZOQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--wfelipe.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3iQKRagcKCC4gPOVSZOQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--wfelipe.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787888267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O24jMU37BkcwnSlc1N2v2/+qg0Mt9kUORAX9UPQ3I1U=;
	b=FjNb8hlL588yNKkoJlUzI3nQBuznATfYV2HhNsggXNS8uWRyNGoRN/YwlIB1ZuUMDOi+H9
	pwN0avgDR8CzHQ+S2hOSd2T48ZZMxrEbVq7wxy2ffa3Mw/hjmdS1feriKxianm19l6VM3F
	favZH83euDZVDSt+OIftjgDcUBJWXoE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QuhpR2fZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3iQKRagcKCC4gPOVSZOQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--wfelipe.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3iQKRagcKCC4gPOVSZOQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--wfelipe.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787888267;
	b=7NwH38aPk68Suo7C9dTJbaA+WqwyHYb3qH6gH5+0LEiCISAv21F/njLSFXwuK+4S4hZQ3k
	MUU+FVuAy02NGPQcMwsvDqE9sGOCddDMmiUQph0c8WL7UQrmm/4ZmqaR9lHQwP6IClkYIb
	nyj1mDnSjG4MSAuVmWwy9g5dULI0YbM=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cbb92868263so546110a12.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787888266; x=1788493066; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=O24jMU37BkcwnSlc1N2v2/+qg0Mt9kUORAX9UPQ3I1U=;
        b=QuhpR2fZDq7M3EpSvbOzi4CMPdWT4f5U09v+jBJcd22at4We/htevSgtK1/8fqTG4z
         Suuv6UfTAEEdg2mkbDcraVQA65p4B2xvUd0lbJ5QAoPxhafjivzMA+XOIWXHFT/Pbz0z
         3PfU1+CyhitxOo5CRO83AQwG/ETXYskjLNAlLaCNpKnjdoJdom7D1D6lEDQIq9Kcuobg
         OO8BcboN0ZOuZJDD8r2Myst6SpyO+pB7CLOQ7RhvB2yzPZndEiCTT7idtNgFHAxjb6dH
         qtZfkzMU2fl2bPz+AxXtbD7/Ofyf7scuU0RveUwl5VH7ucXaynVBrJglDBxAJ5wNeqsh
         WbZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787888266; x=1788493066;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O24jMU37BkcwnSlc1N2v2/+qg0Mt9kUORAX9UPQ3I1U=;
        b=XbCBZxda31PBsd3Pte82Di9Zn/hZhJ4W+r1m0CaZtVwvcVAyaeiEcS2QBXK+yGwNlR
         rPY6XfMjuY87xIIHShUSJ9tp5vUfFCiVDI4lD8Dt1oULKCyzQ/ugQdw4e+snvjApoIh8
         Uos5fJe39jssk5pqwFxYL13DaDa+6PjbAkZ5X+wQypf6tidWuJoFnOD4PeuS23EZWdHp
         tkgBWVxL5BwLeLB1GhykKlQ9dtntVjCqazRcjX/eliqfj3sSv2zF7h/tYg+e//wdD4Ap
         t7fRb0wOCNI2bLuqvjlUcqeHPVlnVvaszk7dRBWh0eqR2Qed+U5lnEsapZSTAVKPj+YZ
         hjlQ==
X-Gm-Message-State: AFuF++nAjVov8dO6/5bsA3z7y137XIqDQeT21xDMLCjnGxfszcRGmYs5
	iNb1ZMhJYacx+vM++G+baPVXf/Z/qSLuNyugFOjvEIfZA07o/8AttHFpWJhOU/34r77Di3nYhub
	B5wQpr8F3Ug==
X-Received: from pgnd2.prod.google.com ([2002:a63:7342:0:b0:c92:3cad:b6c5])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:4842:b0:3d2:82a5:f539
 with SMTP id adf61e73a8af0-3d282a67cd9mr5391975637.7.1787888265644; Thu, 27
 Aug 2026 20:37:45 -0700 (PDT)
Date: Fri, 28 Aug 2026 03:37:31 +0000
In-Reply-To: <20260828033741.2184560-1-wfelipe@google.com>
Mime-Version: 1.0
References: <20260828033741.2184560-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260828033741.2184560-2-wfelipe@google.com>
Subject: [PATCH v4 1/2] selftests/cgroup: test_zswap: wait for cgroup to
 unpopulate in test_zswap_writeback
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: b61fzgf9a6oksx3tfhmt8cq788i5bf3s
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0D62A20003
X-Rspam-User: 
X-HE-Tag: 1787888266-116776
X-HE-Meta: U2FsdGVkX1+DldNX+3i+x3VmRIJKiB9ZqWqrXocXasA+109199+CqwGSHCCsy6zEXFPOwbSFQCcy6/RiWlLD4WE1bYYw0etSeOBgekGSQMjIliuBccIgvpmr2nX3PLeMcLLLyAxa6MveRjx6TOZqqhVmxLlUsEOzAGPmOmf4rgur5NpQtHXAgHMy6O3qiacoyFnsV1iDHohfvBOVTudhSKjSzmWb1Q7YEXs0DFrdtIMQTQxNtkpSq1kV+RLgEaVrUiqKc4nSDbJ5261jjWk6mfC4GJA4RG1tPS2aQnU+2K1g/JPuWecM0UHOy8fRnNs7ojUlcyH54E/lGb2TKSJd6gnmqeCBqKEivrAJQ8jxbPE72xJt5ph58p8tn3/3IjJxYxMk345MdUIvUpMoRar1Vexc76p4YFw1ubHmzg1FZL9HPgozUYQUN3d8KmW09Q+FfG5vNVlrvXZnvNqZujZd9ynF8xWGTPlzEd6KdF/y0X71FZpS34xTOQGJlstfmrGyg5X2hOQUJKXwIN1foW3XFk9qgKWH21UzON8PW4vXR688yRqTKaTMR008bwVTjiGuju9BTNm+BiOTTebApye4Kp8X7Rewn98iuVN7meSYytCOCqKh3mL2n1J08aRBZOzBc0V7vszkSIW27OsW6JTplr9AcOxYPAJXsOWjgRz2BZe0ZAutIkMWrk0qukThrf9UCPuNw/tKMUT43YAkeIw6gh1vFyhUAIukXn3korL6pQTyRYPx1DmIXZ3p4fN5Nvl60Zt64iJQpQCSVymSaOpwILvjduljgs2/z4zw64aN0JcNaBVKSQ5kxJKbC5HpyZZKs4Rsl530g2dvoP6qKuibw2tSNCR6ePLQ9LGx3c5pbPcsysZm4Yn2rfRa3FaAFiIGaiVCUrQ6zMLcocV7Y/Ht9gbcPLr8f+/IOn+Bb4OFQTFlf/TE+Y5S19qRgFnaQbnwkT98OzJ7zzXv+DKGNK+
 3RREaczB
 DsFxZN6XktdM8GJ1TjrvQbkAzFPHGQqH1XjPJOQyTPhLtT9/g1RnthHLNi5/SDSjzXUXW1Xyz2fvGkZfzLN+sOXDfwLsZPBTru6vOijW+WAqONIi4tbCMbrqxYvP6nxjh3m9cHXHU1urO9ouB12oB4ea+J+d6L5oe/fU0pT+QJy6dkURAcMa5XcuR8y65BP4BmC7zkeBQS7N+KbqmRjfL87vahzQ7yAQMTfRpGiX1n6i48PF45XUKIjeVo1yhFP+XetU3eskfCXBGIiwLREvn8FK+EKjDa3HcaGKg54z5W5x7VR/9hC14A+zfBexKaZT9KpouwdkFEpiI7jjvQp2c95lOFdUt32uAKaXn+fkKffHKWrmQKrsFFhCRyVNfPlFNRmKDVghiXXM0C/P/6ehPvyiFn0afkH+xVT9AJNPjg2vToV9XH5lVcOEhltayIBPG8lyvXcRNgr902TW/F6OY4Jw/SQ5D00LasyJZLC/bXkXQLb8SxYfGB0BRT9wQ6R5OLcylnYAs8YTcuy+IWUNnL6h1UNoNnX1i/gaU99pPUL31KOftrqkpd0yUKjCVyIMpvRkRgglYyhHfRFuB23fH/unYV6DXLKjEw1I996LKAabXEcjYCvFm5YaHTb4Fc2fF4PYJM4VxLH9i4o0zUghtmAoBRxremyDNBMup0gkBewe1Ha+xoqUwog3iqpqGlndRIj2c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When running test_zswap on a single-core VM (-smp 1) with 4GB of RAM,
test_zswap_writeback intermittently fails on the initial run after boot.

In test_zswap_writeback(), after waitpid() reaps the child process created
by test_zswap_writeback_one(), writing "+memory" to cgroup.subtree_control
can fail with -EBUSY. Under cgroup v2, enabling domain subtree controllers
is forbidden while any tasks remain in cgroup.procs.

When a child process exits, exit_notify() wakes the parent process,
allowing waitpid() to return immediately. However, the cgroup populated
task count (nr_populated_csets) is only decremented when the exiting
task is switched away via finish_task_switch() -> cgroup_task_dead(). On
single-core systems, the parent runs before the dead child has been
switched out, causing "+memory" to fail with -EBUSY if written immediately
after waitpid() returns.

Fix this by waiting for cgroup.events to report "populated 0\n" via
cg_read_strcmp_wait() before enabling subtree control.

Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Acked-by: Michal Koutn=C3=BD <mkoutny@suse.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/se=
lftests/cgroup/test_zswap.c
index f7b4c4370db6..1d3c410252e4 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -408,6 +408,8 @@ static int test_zswap_writeback(const char *root, bool =
wb)
 	 * Thus, the parent's setting shall be what's in effect. */
 	if (cg_write(test_group, "memory.zswap.max", "max"))
 		goto out;
+	if (cg_read_strcmp_wait(test_group, "cgroup.events", "populated 0\n"))
+		goto out;
 	if (cg_write(test_group, "cgroup.subtree_control", "+memory"))
 		goto out;
=20
--=20
2.55.0.897.gb25b4bd76c-goog


