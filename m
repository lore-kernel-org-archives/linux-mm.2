Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 566C0606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 08:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eU1+Y3Wz
Received: by kanga.kvack.org (Postfix)
	id 60E496B00EF; Thu, 29 Oct 2026 04:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BE2E6B05B1; Thu, 29 Oct 2026 04:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AD626B05B2; Thu, 29 Oct 2026 04:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24A916B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:42:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A1CA31A0339
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:42:40 +0000 (UTC)
X-FDA: 85375022880.14.8B57B10
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id E714340008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:42:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eU1+Y3Wz;
	spf=pass (imf01.hostedemail.com: domain of xiaoleiwangxiaolei@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=xiaoleiwangxiaolei@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793263358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eJN7tODtM96gshRP+uJBFf1UOunuTrvylT+4Jwns9+g=;
	b=l4mqLzYGEQo8gv1eREEfAFjpvc9lK4S9sb0YDa6u4KBYM3q7P1hzDUGuFdl8Uj6xfE9Ju4
	7GZFpdAN4U4Qe7QN2ttyCWT444Q/ByNChPSDP1iDvweXlHreTgPTR6yCHNp9aRuRXy8Dhp
	6Hh7UGpB4GBTXdqLONPhj6DR1iW0kdg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eU1+Y3Wz;
	spf=pass (imf01.hostedemail.com: domain of xiaoleiwangxiaolei@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=xiaoleiwangxiaolei@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793263358;
	b=j26mn5VOQJmD/U91uqY0KzF/mscxmsZQPbXiCpigOfEPPsyX9oRKr+DbfLGYvb/xHe//sD
	+KX5HClBheQlXbacVsD8XYW9jmWSSlvGRYCIM66HsKzp1MzNATw+OFkSvMgKm8Xu57oTVa
	zZ+r2uTUY912Swc6BMbrg5lS9GZXZ0w=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-89f639ba307so749407b3a.3
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793263357; x=1793868157; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eJN7tODtM96gshRP+uJBFf1UOunuTrvylT+4Jwns9+g=;
        b=eU1+Y3Wz8W1cHg2PckCvRLsoblTaQMhpK9h9ymLUK6tLN0q7pLX8gpZdF5oVQ0uy8F
         T0ebD+cEIEfTk5aXqF2A8Fmg4nz6qFA5VrfOOAiCSSpyRbftNwQ9EBnMK0cJRYCUOet1
         jTHhf9du4Kzh1YJ+qG1Zfv+gE5RKVSl2kloP/waKK7ZkDzYq7wNsgm6rhgvyUt7CKzrW
         tdPcH8Op1HZKw8o10TqTY0sXryZG70JELZZNccXrW1eH3r70BLHPDlZu7QEYefwRfug9
         4rcPSYPoI6YbLuQ+ughW41F7kJTG+a8LxB+sC5DHpGiYvt9RQOqhzA55DFBl8uci/fhW
         HzNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793263357; x=1793868157;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eJN7tODtM96gshRP+uJBFf1UOunuTrvylT+4Jwns9+g=;
        b=A3pwRLW1btfmOt5I2DVI69W29IdWg39MkP7VEIxjXv9sKqWdpoioJ/JdNm9MW1swMI
         Zxo3kUUrUMB6VIEUwJritusE4FINyAjLMJhK4rKDGVQE55vKGxm/jdMDRaM6G0zlwaSY
         Qnf9YMY3I+cJ5k+MWm2Dx8HX8hRqkIYNJTbzlaWLuGC9PUHs6uaONV1QS0aEC9tITka3
         FXBgEosLxw3wVVr3gar0snZejLG8Usv77JZ63030LsXTXkho+jRQXBD5yL4mXciYVmJ2
         w1dTUOhn1/w86Ce/GpTwo/6AgB+w9Bj8zi9f0nAT7yQOlyEmEOtQKPF7ye3EHozTsAYF
         CQeQ==
X-Forwarded-Encrypted: i=1; AKwUvBz8hEE75sOY3oWwjMJzT7RuvrDMkFCbseCiy6YvmjZ3CT5j3RCW4y6kDA72wH9d6lCttY0h7pHgWw==@kvack.org
X-Gm-Message-State: AFq9FYLKprVnMBRpm3GL8FMMkksZk1RhS1jU6Y4uOwoZqGpTP3DYwiKv
	Db6F/1W3y506WAtYfmKp5k0dlaaO8Bx0xu7Q1NAkq5wIapNf/xPQOZjB
X-Gm-Gg: AYBFou0wby0RzLH+mYByQxOOtWelRq7vOvgX9jSyhQ5xARwKMlGn6syUrHoyeahO7ZN
	6USu7qN4tYpyShNNvfvQrXf98fOdh3+vIKyWFsm4NYV6L80Gmrq85M3IZzcWwiepbpWWpUMYnMn
	cEzcNVKArOs+uFy6nB5FuBjkMgDQBVMvxKQOxIPv0rWeCsRQvfP4qWNLnOfc+G+M6arh0VA9iSv
	OykHAKO4X6BdeI0MSAl5wfe6Krw1Jc0OYIzMf8K2fMV2l6bmOG7GjehTJGVhiUzhn7jzqN/u1BS
	WRelkIhxW8ILYA1yQSqGT/anS2iP/RlChzzdlw6kDXsFH/146G3nmrZSAUIfJnH6miCZjnEEdUT
	hj3moASM7JFSWzyc754aLD94yiqKZx+TBJ2Z3plGJEAn/1PwxRYIqYB5e0VpKIANQx2vrFzoiAw
	JJRwZ7VdNG2zzSOjzAK/kb4i9I0a1eARF2XWulD/vQLGIVrCvucPX7nemL4MaD1ttRHcrrDe9Uk
	7daLpOXbqePCwrGI5Q3cuHQ3B1UB+HD6gZoKxPWmKNJtvj4J4Ym0M1+DafHwJZvdtG6DlqUfozu
	lclh+VsL0DpS/iOA9qdO4bV81xVjRytNFVz/5PcBlsJ4mre56NihSpkgraUzOR8WwRM2
X-Received: by 2002:a05:6a20:244e:b0:3e1:af52:6d06 with SMTP id adf61e73a8af0-3e9023bdcb8mr4276472637.52.1793263357282;
        Thu, 29 Oct 2026 01:42:37 -0700 (PDT)
Received: from xiaolei-VMware-Virtual-Platform ([219.142.21.190])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdacea7938bsm3338029a12.27.2026.10.29.01.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 01:42:36 -0700 (PDT)
From: Xiaolei Wang <xiaoleiwangxiaolei@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	error27@gmail.com,
	xiaoleiwangxiaolei@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [PATCH v2] mm/damon/tests/sysfs-kunit: fix leaked pid reference in add_targets test
Date: Thu, 29 Oct 2026 15:56:09 +0800
Message-ID: <20261029075609.35661-1-xiaoleiwangxiaolei@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E714340008
X-Stat-Signature: rmrk875xwnn9hqbprsqs85kfkadyxcy7
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793263358-135151
X-HE-Meta: U2FsdGVkX1+hJxExkX2NeWOwT6sLJzGupbuKpEeqDZ8UZYeDxKDguy2P79foJvXLXlkrT+MVDQWBFxeJIYZEU3qvmcDuIXyPbyKzrJGdpqLNHLyxIYDxCV3pivWE1IeiXtw9EHNc/1+PXHTaboeTLC7FeK/56oB1/qjuCTrG7j7a/+ZPIvwWpM9970vukuLvDE4I4GBunBqNPPtopaXveKdnMgrlCNyrGOF/5MFLXYpnX5qfjNExwv3fdFzmDtIniyW+5FuHcUQvjqS9zuqLfvQflasrykouW8pJgV7G+QgpWkP/JF0xLUWCcQ+x83eAOw7Vpy4ccOHbDOLXr4W+AN0S/2cpTxsNyiIYDYAHDl8AWe2SivysDF47q/AIwfJm9MCU2sWLdcMC7rCaNQVIjwj1XFkNPryUB7tC+NBMpR6X3evfQYYkxJYKT9kOKBCUvJmqk6502c72MLbQSarlsAU0x2mf5aIkvnf4tra5wf8BB0jmsCcXMuDKA18qVopyKRtZ3UcGzlbaktIFRlxwGM820ry7HX42PDFUrfiftfix1jdEjV0OQBvhH+/4FiH0iIaFnnWLqHPOZf4WqSJolwVuh+1XaltZQuccjF1eNQIK82fh7NMyR0Q0qqGjXJJG6Eb7PNNq/cYCNDgNkVcMHscpDkWKrOzv/x3v3gee+dcB4aeBSJF5xow10CrPqMMB0LvEcX9JIb6rpGqh2iaJzPu7WiUJmo3oAxL23yVtshrTCdD+6PyJIjwubv4WgYFzKBnX8kVxrRG8i73oaHL+QhNcG/agogvXFJLkdyQ2KRQFc/gAbQThOOE8jjbH0O5atwjuzOSzc6SAZj5IdeLCC9FwRMQ9BRAW8vqujaMBhpbM1cltJvd3NYXO0D6FhVFCaVPR0Fd9iIVPChY0pBfgmMOeSj4Fw/kRYEyeUC/VCNK5FAm25siltg+vCHw7ApZ0Xejr/9sqtlIjyyFYZJK
 hucP9Iqm
 FZX9ky6nLwP/qGhzmpWDuWK2x6tTd6FArxXoZE1DPQ9hyezASH5yOBYkNVC5kBPfXcwMxLjC+UdXHMcQ/eZN03yI6wnHc5gOJSnXrLWL7sPZrGgC0pc5hsNvv6Td6pbI8gih/+T2EhppmJCY6I1aMK1dDqrYML3LY1mooSNvRT+ddEX5lIXY0vHyql3jOf0bBaQO4vhoysaDEKXPjSzq3/qsDxlQXbFYUE/Mk2J+K2KxIHm+aWQUPwTvDsCpfoS7IVsN7C1Brs2sNIM/am8evSpVgQsRFC9qiHgFrdxbYWMjBxJc/Bjmb4HAqb0JIHa6K+ziJ5XZ6hKx9N+fbI0kN2842Hbfgrf814pOwpZ+jZSVI7Ukv47T8VI3EF4L3Idr9oawMM97G3m8BrAqSX1/s8VNuzjtMbj4Jyrc/WQf/92hzKaT2c4XcOeN8CZMl99hy5keq1X6s0h1OkSx+WbsLpBdpe8jMr9WLZPePm4m79aHCILOr/GvmgCYrbuO23x5mQ/POtLazAUumAf+komXD89HipSJTDgjiWJo8F8auFCypXNXbMhLXP9oxyfTcmeEFQl0plyATjejGQJQuOmCdmFUXV9UlPNYmgVvOGxhcjNo33FqJrCY4LxflMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>

damon_sysfs_test_add_targets() creates its monitoring context with
damon_new_ctx(), which leaves ctx->ops zero-initialized.  Since
DAMON_OPS_VADDR is zero, damon_target_has_pid() returns true for the
context, and damon_sysfs_add_targets() therefore calls
damon_set_target_pid() for each target it adds.  That function grabs a
reference to the target's struct pid via find_get_pid().

The test then tears the context down with damon_destroy_ctx(), which
releases such a reference from ctx->ops.cleanup_target().  For the vaddr
operations set that callback is damon_va_cleanup_target(), and it is the
only place where the reference is put.  The test never selects an
operations set, though, so cleanup_target is NULL and both references --
one for each of the two damon_sysfs_add_targets() calls -- are leaked on
every run of the test.  Running the test with CONFIG_DEBUG_KMEMLEAK
enabled reports the leaked struct pid objects as unreferenced.

Fix this by selecting the vaddr operations set for the context before
adding the targets, mirroring what the sysfs interface does.
damon_select_ops() fails if the vaddr operations set is not registered,
in which case the test cannot exercise the pid handling and skips
itself.

Fixes: b8ee5575f763 ("mm/damon/sysfs-test: add a unit test for damon_sysfs_set_targets()")
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>
---

Changes in v2:
- Fix ctx leak in the vaddr-not-registered error path
  (reported by Sashiko AI review)
- Link to v1:
  https://patchwork.kernel.org/project/linux-mm/patch/20261029015725.17378-1-xiaoleiwangxiaolei@gmail.com/

 mm/damon/tests/sysfs-kunit.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/damon/tests/sysfs-kunit.h b/mm/damon/tests/sysfs-kunit.h
index 138a4b8d14e7..16373ba751db 100644
--- a/mm/damon/tests/sysfs-kunit.h
+++ b/mm/damon/tests/sysfs-kunit.h
@@ -79,6 +79,15 @@ static void damon_sysfs_test_add_targets(struct kunit *test)
 		kunit_skip(test, "ctx alloc fail");
 	}
 
+	if (damon_select_ops(ctx, DAMON_OPS_VADDR)) {
+		damon_destroy_ctx(ctx);
+		kfree(sysfs_targets->targets_arr);
+		kfree(sysfs_targets);
+		kfree(sysfs_target->regions);
+		kfree(sysfs_target);
+		kunit_skip(test, "vaddr ops not registered");
+	}
+
 	damon_sysfs_add_targets(ctx, sysfs_targets);
 	KUNIT_EXPECT_EQ(test, 1u, nr_damon_targets(ctx));
 
-- 
2.53.0


