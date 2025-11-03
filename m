Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90EB5CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 18:03:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76FF8E00B6; Mon,  3 Nov 2025 13:03:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27BA8E0057; Mon,  3 Nov 2025 13:03:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEFFB8E00B6; Mon,  3 Nov 2025 13:03:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8F0E8E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:03:31 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B11812B0E4
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:03:31 +0000 (UTC)
X-FDA: 84070068222.29.8025642
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id B414C40012
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:03:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F736mNZ4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762193009; a=rsa-sha256;
	cv=none;
	b=HHqS+BdAtk3zivmeaskAPUdL76I0R1LqUGxIBvWoSnPJ6qAqP3mNN3IyLb2HWZzESBZlzR
	47qoDaJLPgSTIhGvj++JWpihNReqGSl6BZpmk6VEzGWQNwwx5PiK8NpDl2BcKK5wLgYTSD
	RUUwP253T3Sy30PdYlemIkMKN+Mc9cw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F736mNZ4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762193009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3TDOYm2DVmfqJCujq+6JvTV9/WNymHqWtuQZIak8R4=;
	b=hsCPPVigrIYuFDfgjjD84VE/nWVKy52B/18egrxiWuAIgysVq5mWuNmY8ft22nTO5CedvX
	1lIlJ4SE1KkIqpzwypewENsq8CisAgbeunrI+BkMjY4OT/uF4qoPG5g3tvgoIXoGTj0Kge
	2blIoPy4u/uK0+/cbifk/8l4vTiUBAY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C5BF6013B;
	Mon,  3 Nov 2025 18:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55759C4CEE7;
	Mon,  3 Nov 2025 18:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762193008;
	bh=YOjQBkrOvTLYl9O3qPNqMbiCs0u056QzurwCIfKrTaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F736mNZ4enqmL1CdoNBgCseU/Rb6cT+mn8V/+4DdA2zn6krYSoi32FImyJgsY5Mmq
	 eS2xkqfvGanND5uHf/4K0l6HgNDFKrt4Sbq9QDK/9qsyASgGQw2/8EueQUJO3CX4Ct
	 O17hWlY4l5npThOxsCldovbc/heH0Hyk4cI+99epdadY7F9qiIfbjZaO8G20UxmoUm
	 q17JewytWt5tlGPBlWk7Lb1m6NwqICEprcRCI+iX8K4JL9jIyTysjFiYpTfDK+3x0H
	 7Ot70mZ4DBIZUgtcZs7HmW79Rv5vJw8SwQSHsr/WCaOnt7/j7tk9LvenVG+2pGDdtu
	 kznpX5MOOcY3A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sidharth Seela <sidharthseela@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	wang lian <lianux.mm@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	hannes@cmpxchg.org,
	nathan@kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17] selftests: cachestat: Fix warning on declaration under label
Date: Mon,  3 Nov 2025 13:02:33 -0500
Message-ID: <20251103180246.4097432-20-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251103180246.4097432-1-sashal@kernel.org>
References: <20251103180246.4097432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B414C40012
X-Stat-Signature: rr9j555wsr5rzzaq17mz6napkxbxpz37
X-HE-Tag: 1762193009-740447
X-HE-Meta: U2FsdGVkX19FAZwMNaDDVPaf+IkvdpXUY30panmHRJUcnXIxFm3ef1NlWlnO3cg2VRkWQm/9Ba8l64h81/OB6LM3HTTTYf8N17G8Pz/R6Vm80Wg3StZ/VgSqX3crCZCb454iI6nF82WWbC95HRTfhfrCP0QdIdLSEzAgHOiMUN/XVGK771j8+Qm+lB1LQChxB61PwoJLVfhk9DkwQZDbW4HX72VfkZb/f0OzEx8F/OWgmaXW4pY2Cb6bv4C3XkzRz4Xdyct/hS5/Cx81yXF2pdVNp2J+SGdnsCFoer1p3HKMs48jVRfrRm7jCyEz34zom3IEQQfGNWuRPbYjCi0m4uExT6THHfxg4JHZWNusuE70c6fmtGGrv2hSOTKMNHB8J/Uw6uxIn682IUjDRC3wzAwS29yody3SZtUD1LOrIaH7UwT/Q8UmKZ8I3yaw2bDmyfInLwidePINbf4FXpST6j3LmtgLpeghUljWuad/mATWZrAMd9aau4Ch2+fn331I+0haAcSM8nGCEBbW5CjUBw3SSqGmXafDz1YaBKtsp5W4ablD9Rfg1IUGb/I1tOvZS6ME8U/R5xmqi2sn/18KNtS7So6oxMCxlfIDMA+Q3iWUe03YS8JLz35kLBz6YxIfM/Qe/it/qjvTDuJmK9PIPw5MrUbqQQDSSzVsF6rLByWgsK2ejWJ11c2axYiZ6KCcAqw3ePhdy6SQCkyzKNQebP5QtNe4m0b3QWdRdECUe7LiXhZ4IoB0KR9L9q6Gb+TEXrenmflwWdipCUCVYct5/AjmnTAlCfvx2b2Bv0HCBZWBOyzawhqqmOJNHhUn6KuWS1CZjnpGMEgNmbTHXTvyiuUhH/fDS9wlGY/CLsw1VUMWChr8bxmVX1qS7AFIKVeR5W6/G6C16GVR026rB5nxwMXH1k89fn42Kbt/BpFSlmfmonU3Ul2K/7JSxd6mhxDNlyOUVYhqhZhZrK03ai9
 DKJ1IaPZ
 LSdHDb1XdtB92Ma5oPKz09JTSkNefWd+h4j3RxrJcmRdD5/OHfJWxNpUAnS7aLpl5zjwDLiARnRuQQR655jWs4tDaTU31RqFIbna232icsojA4QdlVhaNll3Do9Fia36dKyuJdCfrkI8lvfEkg7heOjPfpX2gQKkq9z5V3645/rIvnawW1spplV0qfTjEzgDsHqI/awwIwhiP5Q5qXM/BPKQLlBmP+7IoromX2/chQheZLShNwysJ+e48tqu5F5cyLBOOUDBZiGO1nkqSMd8lzngHTVud6gQC8gUSOKtQQnRwebheVMQP5jsV1D15hgxAtn7J71ycPtAZF1ua4SYiBXoIyc9JOjpF8bp2PHIF1u9TN2rAMcSq0xEShqhQ7JW5QR2WLl7D4S+sfiSTyU+1MLsEy0KQLOpJSaDQqToKgunLFEf7Ud/+3ftwiXeElMtJC6nVlt63FW3Zp4cCOqbjoE6iuMYf+LJdR4IG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sidharth Seela <sidharthseela@gmail.com>

[ Upstream commit 920aa3a7705a061cb3004572d8b7932b54463dbf ]

Fix warning caused from declaration under a case label. The proper way
is to declare variable at the beginning of the function. The warning
came from running clang using LLVM=1; and is as follows:

-test_cachestat.c:260:3: warning: label followed by a declaration is a C23 extension [-Wc23-extensions]
  260 |                 char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
      |

Link: https://lore.kernel.org/r/20250929115405.25695-2-sidharthseela@gmail.com
Signed-off-by: Sidharth Seela <sidharthseela@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now let me compile my comprehensive analysis based on all the data
gathered:

## Analysis Summary

**ANSWER: YES**

This commit should be backported to stable kernel trees (specifically
6.17.y and any newer stable branches that contain the buggy code).

### Detailed Analysis

#### 1. **Code Context and Bug Identification**

Using semantic code analysis tools and git history examination, I
identified:

- **Function analyzed**: `run_cachestat_test()` in
  tools/testing/selftests/cachestat/test_cachestat.c (lines 222-295)
- **Bug introduced**: Commit d6a511dea45ce (July 2025) - "selftests:
  cachestat: add tests for mmap"
- **Affected versions**: v6.17 and later (confirmed via `git tag
  --contains d6a511dea45ce`)
- **Bug confirmed in v6.17.7**: Using `git show
  v6.17.7:tools/testing/selftests/cachestat/test_cachestat.c`, I
  verified the problematic code exists:
  ```c
  case FILE_MMAP:
  char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,  //
  VIOLATION: declaration after label
  ```

#### 2. **Semantic Analysis Used**

- **mcp__semcode__find_function**: Located `run_cachestat_test()`
  function and confirmed the bug exists at line 260
- **mcp__semcode__find_callers**: Identified that this is a test
  function called from main
- **Git history analysis**: Traced bug introduction and verified no
  prior fix exists

#### 3. **Nature of the Fix**

The fix is **minimal and safe**:
- **Changed**: Variable `char *map` declaration moved from line 260
  (under case label) to line 229 (with other variable declarations)
- **Lines modified**: Only 2 lines changed (declaration location)
- **Risk level**: Zero - pure code style fix with no behavioral changes
- **Compiler warning**: `-Wc23-extensions` when building with clang
  LLVM=1

#### 4. **Backporting Precedent**

I found strong precedent for backporting selftest build fixes:
- **Commit 90c1ffd1347f3** (bc4d5f5d2debf upstream): "selftests:
  cachestat: Fix build warnings on ppc64"
  - Similar warning fix for the same test file
  - **WAS backported to stable** (shows "Signed-off-by: Sasha Levin"
    indicating automated stable backport)
  - Establishes that cachestat selftest build fixes ARE appropriate for
    stable trees

#### 5. **Impact Assessment**

- **Scope**: Affects only userspace selftest code, not kernel runtime
- **User Impact**: Developers building selftests with clang will get
  warnings without this fix
- **Build Impact**: Does NOT break builds (warning, not error), but
  reduces noise and follows best practices
- **Testing Impact**: Enables cleaner CI/CD pipelines that treat
  warnings as errors

#### 6. **Stable Tree Compliance**

✅ **Fixes a real issue**: Violates C language standards (pre-C23)
✅ **Small and contained**: 2-line change, single file
✅ **No architectural changes**: Pure variable declaration movement
✅ **No new features**: Maintains existing functionality
✅ **Well-reviewed**: Multiple Reviewed-by, Acked-by tags from
maintainers
✅ **Precedent exists**: Similar fixes were backported before

#### 7. **Commit Quality**

The commit has proper maintainer approval:
- Signed-off-by: Shuah Khan (selftest maintainer)
- Reviewed-by: SeongJae Park
- Reviewed-by: wang lian
- Reviewed-by: Dev Jain
- Acked-by: Shuah Khan
- Acked-by: Nhat Pham

### Conclusion

This is a **low-risk, high-value** backport candidate that:
1. Fixes legitimate C standards compliance issue
2. Improves developer experience when building with clang
3. Has precedent for similar backports in the same file
4. Contains zero functional changes
5. Has strong maintainer approval

The commit follows all stable kernel rules and should be backported to
6.17.y and any other stable trees containing the buggy code introduced
in d6a511dea45ce.

 tools/testing/selftests/cachestat/test_cachestat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cachestat/test_cachestat.c b/tools/testing/selftests/cachestat/test_cachestat.c
index c952640f163b5..ab838bcb9ec55 100644
--- a/tools/testing/selftests/cachestat/test_cachestat.c
+++ b/tools/testing/selftests/cachestat/test_cachestat.c
@@ -226,7 +226,7 @@ bool run_cachestat_test(enum file_type type)
 	int syscall_ret;
 	size_t compute_len = PS * 512;
 	struct cachestat_range cs_range = { PS, compute_len };
-	char *filename = "tmpshmcstat";
+	char *filename = "tmpshmcstat", *map;
 	struct cachestat cs;
 	bool ret = true;
 	int fd;
@@ -257,7 +257,7 @@ bool run_cachestat_test(enum file_type type)
 		}
 		break;
 	case FILE_MMAP:
-		char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
+		map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
 				 MAP_SHARED, fd, 0);
 
 		if (map == MAP_FAILED) {
-- 
2.51.0


