Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E752960A8C16
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FKzpjaeK
Received: by kanga.kvack.org (Postfix)
	id C6E576B05DD; Mon,  2 Nov 2026 10:08:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84E56B05DE; Mon,  2 Nov 2026 10:08:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9AC36B05DF; Mon,  2 Nov 2026 10:08:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A6A66B05DD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:08:10 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A5F1C0163
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:10 +0000 (UTC)
X-FDA: 85390509540.07.2372BBB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 69D211C0008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FKzpjaeK;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6vXo64FE51u/FRjXpJ4fxOm9pgZA8t7pGEdtQQpkrc=;
	b=2CLCI7XuBlP9h9v0LEv7TJ2T4cycFwF6apTyJPfYG00u5wX+/tRmTKsvDijpeTt7HF5IPT
	rYXpJim1gYmeIuuCNkIulu1Jrh88iJkcEXI9JgNoOjXZOJCnaU7WD8qEUzgV6Wo1rN2+Tm
	WMF3OldBIUqtbOQXVbnIvCp3QbWtJPw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632088;
	b=IQ5PnFDyu1ngoMTA5FZesPGo+8c5SdD5vOP1cAZmEoOQi4xV4+I/gZWFlw8RA1UklJWwvT
	ZiksqrCcFGOMY0ZW9BBUpUt0P3dw6KqebzD1HDbce/idZP2DerlOnDGZKGMEYtI1eR3Xnz
	la8X7DX0+YU5INnpvKKMOJZ5x/ipFzo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FKzpjaeK;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BDFFA43D64;
	Mon,  2 Nov 2026 15:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599D11F00A25;
	Mon,  2 Nov 2026 15:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632087;
	bh=c6vXo64FE51u/FRjXpJ4fxOm9pgZA8t7pGEdtQQpkrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FKzpjaeKxeWvrMo9fGM/PnSq0y0waTRF4nSaoUSYDv463BztBvjEVpSlC5+0COvjN
	 X26BBza7Xv6XWxrBPglzRWkVzVzPJvCoHeXy3056YIhWrGQWrPbp2OLtEmO4vPx/SG
	 7+g0AzMvI7cNlqVF/b6KqJ0pltCp527K6EerXOA2bhuIj9m6SIpi/ywzjcN595FUjO
	 k2drc6SVXL7i8UG16cGyfpDc9Lh39ZF0gNIZ2VjEdlrh7mvPx3wIZ8c6z07Ozs/2gt
	 pMubg37QrajgabkRLwZdsCeLBhk01x7VY3kNOVEVwOawnfeDk8HsKbgTLB8698U51P
	 vwyw1wIhBumcA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: [PATCH 6/9] selftests/damon/sysfs.py: stop obsolete_target shells hanging the test
Date: Mon,  2 Nov 2026 07:07:53 -0800
Message-ID: <20261102150757.93058-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102150757.93058-1-sj@kernel.org>
References: <20261102150757.93058-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 69D211C0008
X-Stat-Signature: josfb4xyf6makoqgrb6ecy6ew94kzw97
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793632088-351918
X-HE-Meta: U2FsdGVkX1+s/GPmgGAMPZN1aL/eNxNwz0AA+1Tcy3uvUAyEWFef8dfl4iUoSE1b65zffS4vxft9UFIrtEWom/Ps2PChYhHqqYCQ9Onr3PK47w2IHS6Nbo8V70jGvH2Zjh5AtpuMw98ZTwz2HVcC5Hv3pAGWEM//b/cfPI1y4DnwXvlb2QGftJV2iUnZv3bXkMwbcyC2G/89pvt60go5/4Hz2BxZqb/ZURNIxpZa/KMuo4JH7B8kG255vZPVOWoihULB9kYRwtkIc+Dl3gRlgVwHB5vJQiPB8j2pfmKvtQgJD78xlrAuc47dTWSGD11/k/IatgfIqxUXGbXJuI6m4NgRDaKv6plmtzAISMgCd1hQ8si28Veqx0ZAamJ13hiFMYknEpoOJJlg+P1zxxjjPtqQxRRolUOSSfHkth9/O37LOXUmM49pR8QV98NgWiVvXYMXmheSY/ce2pos9nj5eJPmxU6GvndHNFvm5GqnHLHO4Lr3e2wZdPTTBBD99PLrvCSy/T3Kczi/2V42uFI0E5Lo/FsSnGtvyworRs+qUXlOGBHKH0FFQsqNb3hAGSAFZdKMzPylWQOQHhN1nA3PMVBYUNYkESqMpOBg2t1ecWSOGqYSLUJeq3FaOdjZT3cxEewD/ajV5xNAVi1r/JnSa3HAHD1i3cnMTIXXIQN7cqVCi02y3fyHPwgZzLoG6/Nt8pAl3AOFFHqAgnOgWo5uCaKS1gnV72iocPjuSf1nH0muRSthmGqv2Xmc1xHKLNXsQmF6Okamp0x/BrxTiR6z+0oWMYVKl1l7fWqolCiQPO8kofpla+0w3ephtpskcIpeHj/iuHGyUr1Dj7oo9vPjWNRh6BFqfc4LGIA7LmEZex5OmgHWWoBsOg+PTc+Ly2W7nW1ezwviQs2JLdOA7B8XGowbrJrKMoDl6Bzi3LCSUhMjFDDfacbwNcq9HJfmqgqKWNUVZVFjL144YVpLVvS
 XMuokt6W
 wjEo4njvu+0fQdIwvU4yp0hAAqAoxqOwN3fzq3BpBIKKh4oaXSKtopOsCu3Pqb0QYEX/KiJ3V+mhQhWZzaB4KWmkHSzc58fjbH6Fpq6pV2ueU5gFrbmIBNQcQr7dZkrKQ2BYFTdo5UyEG8eRk/vmW5EwHSd5gPGYAnmV8j/0Qn90XVZkFuMU3emoA0G7q6wkWxINEFl5Huz98dp+H/SUvzixGqN6p+MEoAwny+iE2Ug9vP+UQ0Hn2jSjSqzD6o1CCA9aU+GueSpwaTMa6a43wP+V5Ni5ouZI1ZWpz7OVkBQPD1EysqPFIgGL+t81yR34ZCCVt6WCQUhP5fQZd1Ftb6UBQ9VP48DinbudjquV356Vlhhwi6Xfw0H9DoSH1mfgmKbLU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>

The obsolete_target test spawns three 'sh' processes as monitoring
targets.  The processes inherit stdin from the test.  When the test is
run via 'make run_tests' from an interactive terminal, the kselftest
runner executes it under 'timeout', which puts it in a background
process group.  The 'sh' processes then try to read the terminal, so
the kernel sends SIGTTIN to the whole process group.  This stops the
'sh' processes, and also the child the test has just forked to spawn
the next 'sh', before it can run 'sh'.  The test then waits on that
child forever, until the kselftest runner kills it after 45 seconds.
The test passes when run directly.

Fix this by passing stdin=subprocess.PIPE when spawning the processes.
The processes then read from a pipe that never receives input, so they
stay alive and idle as the test expects.

Assisted-by: LLM
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Tested-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20261018020415.35567-1-jaeyeon.lee.dev@gmail.com
- Collect R-b: from SJ.
- Rebase to latest mm-new.

 tools/testing/selftests/damon/sysfs.py | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 66c826189320d..ce54fa21c09fe 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -390,12 +390,12 @@ def main():
     kdamonds.stop()
 
     # test obsolete_target.
-    proc1 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
-                             stderr=subprocess.PIPE)
-    proc2 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
-                             stderr=subprocess.PIPE)
-    proc3 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
-                             stderr=subprocess.PIPE)
+    proc1 = subprocess.Popen(['sh'], stdin=subprocess.PIPE,
+                             stdout=subprocess.PIPE, stderr=subprocess.PIPE)
+    proc2 = subprocess.Popen(['sh'], stdin=subprocess.PIPE,
+                             stdout=subprocess.PIPE, stderr=subprocess.PIPE)
+    proc3 = subprocess.Popen(['sh'], stdin=subprocess.PIPE,
+                             stdout=subprocess.PIPE, stderr=subprocess.PIPE)
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
                 contexts=[_damon_sysfs.DamonCtx(
-- 
2.47.3

