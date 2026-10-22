Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0EA606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 05:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=J2nGQySl
Received: by kanga.kvack.org (Postfix)
	id F07B46B087D; Thu, 22 Oct 2026 01:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF346B087E; Thu, 22 Oct 2026 01:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6546B087F; Thu, 22 Oct 2026 01:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9AB56B087D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:22:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1605B1A0729
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:22:52 +0000 (UTC)
X-FDA: 85349117784.12.0098084
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7CB84100002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:22:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J2nGQySl;
	spf=pass (imf05.hostedemail.com: domain of 3qZ3ZagkKCKgKPQPaPMVOOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--chihsheng.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3qZ3ZagkKCKgKPQPaPMVOOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--chihsheng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792646570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=i0ib49ykkVTIXodpiuOe5mlbictVGMpVlOsQqgxbR10=;
	b=CSntIkI+GVC0UtZ0Mc3pNKIzItzI8jZNSQU/z8y+CqPm+l3BiZmbAdF0tDYRdMEEFlWKYU
	bWUBxFeceZt8PGGwozq08pRzWhgqiWqab/jrRkJZ/fCJW8ER9RRIul9Y7lb/Vnh1JnEKgB
	aRn550vpf+LHLMPrxTYktgzTQgsPIvg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792646570;
	b=YcpqrB3Ou7itiV7m8IZyzKOciNoGj0RYmM+2o8nNbNp07LnuHHmjN/yICE04M0EPtDlxkh
	KZ8LZ5vzAl/GNaLlR0bk4xbc0K0WrJ+zTHHpxH6RyQ6/1nPpGbgge75t9w/Fk6HyU78ylq
	uVYncdhJAKWYY8l7GtECxncCDKp0Oj4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J2nGQySl;
	spf=pass (imf05.hostedemail.com: domain of 3qZ3ZagkKCKgKPQPaPMVOOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--chihsheng.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3qZ3ZagkKCKgKPQPaPMVOOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--chihsheng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8a0522cdaf3so1118619b3a.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792646569; x=1793251369; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i0ib49ykkVTIXodpiuOe5mlbictVGMpVlOsQqgxbR10=;
        b=J2nGQySlHdWUjF+2MzEu5j2fKW4BJzjlc/M81xwCOFSqyl7LsYiGbY0ENEoSDX94lq
         OddSneZjzXLUagCGBZGSmm4o4eSYsPyyWaRaMX8uFEztvqSa6fGBRdhAEtWg1gfNn0ik
         rF+abKsTmG3f0n1zxTeUgcOhVtm5RC1hsgcp3txfNbpGEeeGHIRg/Mq5Iy+HB8jk01x0
         ze5joq6F65hDW0PCxeNn2O2bZcKe29aHcOyaTup356Pdy0+IpXummJSt2J8QDO1GyBvJ
         kElLCq5rrq/BHxeFgcbUALpYSx8j7fpsbFDC1kgg5cUxkfHelcklvYyfc23A/cqJEqzC
         lmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792646569; x=1793251369;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i0ib49ykkVTIXodpiuOe5mlbictVGMpVlOsQqgxbR10=;
        b=om/bNCE5KQfgBeGujtbciqqyJx4PrOj0o6053Cyfp5stoOgL4hEJTzddp2mASodRqm
         WGgtGae3PH5uOuUnOlTxcdytV5TgBEAiV80ZYXG03SAHyf11V1QzSy0/HLn8qzoDoTK2
         J06lrZudAnnYlWzxz6ObZan9H4E7czp2E4lGVGT86QMnkKWL2DkRHmS/d15XcP7JpiST
         ZV7aWhi/TMgfmhew75KpW6yOD8rmmyG9Iy/7TDLjSIOB+ewYW6SUZJzemWp7BabMbq2x
         Fgp7gNYDZnAgAMWtnvddec++qI9zHC31VS5Py3a0bMpRMH459K+svibSgn3vI7IoB+1c
         Lv5Q==
X-Forwarded-Encrypted: i=1; AKwUvBwoWCE98mHk2e3xWBFj52nxbKpK/tksfs9AMY5/Jm09R54Ql82h4KraLJQCzJFpJkDNmXnuAVIHrg==@kvack.org
X-Gm-Message-State: AFq9FYIXfry716HHePzsmxzG8yBNwOoMf+EoYhjAtEuWhTVFQsye2yDt
	o0cIL5w6cRNFnWuywAozmp0B1RLvpZGtWel0vQxY0F5keMUvnUNYWxufmLMSTm3Xm9Vu/uT9pb2
	uH9mbZ9LtTXq7YvxvtQ==
X-Received: from pfwo8.prod.google.com ([2002:a05:6a00:1bc8:b0:8a2:1bc3:8884])
 (user=chihsheng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:349a:b0:881:4b47:f31a with SMTP id d2e1a72fcca58-8a089cdf1a4mr3211775b3a.11.1792646569217;
 Wed, 21 Oct 2026 22:22:49 -0700 (PDT)
Date: Thu, 22 Oct 2026 05:22:44 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022052245.1138709-1-chihsheng@google.com>
Subject: [PATCH 1/2] selftests/cpu-hotplug: Use $(id -u) instead of $UID for
 root check
From: Darren Chang <chihsheng@google.com>
To: shuah@kernel.org, david@kernel.org, osalvador@suse.de
Cc: linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Darren Chang <chihsheng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7CB84100002
X-Stat-Signature: ykusy1hzakchhmp7aw5fw8wkk1d1du4q
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792646570-930616
X-HE-Meta: U2FsdGVkX1/vGuX6fyHbjUfWdeRQRkJQMPctNxrojRqKMdHgZSQ/wNDN5foHSEXDUyF1BNmesrRFTb4C9YbVQzElhrhQ6M7AMS6c1HKx9mi3zlFwqjm1POH7yl8QRtjXGniBMho2BVDBGRY1oLlZc6ENUd/StKj6VBL47na+u/dN53pr7p3Y9sVoN1A8f3hmoiDzVWn35DbOGOiR/OSAn1t0bulnVhZKJQHyyOco2w0QbGwcfaa5Kwag9YeE6jgpbh1tnJERt77/DtUh111VfSDawOn9G2ZTPqiNa+5oka1RfVXNRegicM0hosludIM40/b+Ey+HHxH7aGuSgqUhdqF2yqU3/tWERbU/i1DXUHM0Elqf5T+qlTOEIGydwpy32IQ/56I8lqiKS+7lL0Y52Y+2dC8PyirycurPP3u0e2VOM5uC3aJmNYzzcUnCPNyCuOvQXwJpJSslhNRPKAEf4ZeaQGHQvw4kSOl4yT88m7hRZNqnu81MO7PGj6Bx36pYl/BlaCq4X2yqGyRrs5tDPrz3+BREE8PtRG+uGgKxXZtRkbGHVJ+4Jt5yyusn70ryoEbxf9WzIAjU8pepdZXgohvDqMzy+HOaYFGYcI0jX3algZqRtlaGSgxXlIbe5POyKC5rYJY3izIclDDxZBBDcSqUh9eSQaKoNfOQYmxnILBMRRyNpgMIK0uwwMkv7T7VkTu9gEbP43SqV6i+/RSa9wn+Moj6HiNXYRbX80ilTNAM7fc15v9f0pxSzg5pKypV+ckrYxec2JPNQaJU9WjeJFNfGWObyhBpRfWrw7hrGOb4A1K0CeIAsPhSZk+1V3DWjDNVOS6l8jrFvBL1utqT+n40WEct9BtttpLJ91zsB+czOG98pe5UluXRVuFXwCdacvnrjOnn/xJc4DOImTufySpK8a7TNz+KTYmo7mxAb/v1gFYxK4m5bIeGRltBOBzwY6ssnXSQicF+nJi1ceu
 BfzCgn4z
 yff2eUTnQYDidkEF9sMgcjpumV9JWgqpH/pB+ycj8ed16tFZ9M2iXKKrpHLMSlSHjC3Cx09JE2CpS6A2u66Azn9A8YFF6BmaCVlt1MyDntugPHdA9cF4Ssu3WeCJkNZg6vEwqJcWvpnD8Nq48mU4vU8u24hjFGuxtmaNRvbqxGkIc8RZ5M7GXWz7AM5jCGK4eHNDkaFyQLIPSn+k6gnDoNYAzeHcI+WdzswMHvEl85ZaUTT46vMwBRQK8ih27Tuaiok+u3SAT2x1Mf/6imRV5Vn6byZqmOyrmkBfAreOXXjrwlaVlEId/13Aya7NkpukGLsM57KRjPw0vv/JaOd51tGRQFytbs2PKHyyhZyYmecPxf3gmMeV6xmmH4DGKyN2NduMJYvQLZEeVjw1//C3bp6Riysc+hEhWdUrBGspCtX/rNBWmrl86vp8oMHk1d4qGSjdLqw+cnhiGPsCiJpWGn6dqocU6TztOUObUjnTmAnDQBQmvRlXfCwHOPWG+wr8MiAvbCGheXGaF6LxY9YLn2qGwhhPq+9ssO5OhTfeOa+6nTDZT5jLwkpc0D+jjPy1Hc6+IuN0bnpZS12uXjUh4JepAPQc4r4pWYSea0bMG4LBZApAB5iuQ/T81MP/nngr7jqbWSrMuMhHOegY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

$UID is a bash-specific variable and is not defined in other shells such
as Android's /system/bin/sh (mksh) or POSIX sh. When running this test
on environments without bash (e.g. Android), $UID is unset and
'[ $UID != 0 ]' expands to '[ != 0 ]', causing a syntax error.

Replace $UID with "$(id -u)" so the root privilege check works across
different shells.

Signed-off-by: Darren Chang <chihsheng@google.com>
---
 tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh b/tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh
index 287cfd5809f6..6653507b9348 100755
--- a/tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh
+++ b/tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh
@@ -10,7 +10,7 @@ prerequisite()
 {
 	msg="skip all tests:"
 
-	if [ $UID != 0 ]; then
+	if [ "$(id -u)" -ne 0 ]; then
 		echo $msg must be run as root >&2
 		exit $ksft_skip
 	fi
-- 
2.56.0.257.gf7497c7d27-goog


