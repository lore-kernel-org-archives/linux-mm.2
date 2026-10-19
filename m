Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0098C606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 16:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=GzKHFjUo
Received: by kanga.kvack.org (Postfix)
	id F09096B02EE; Mon, 19 Oct 2026 12:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBA9B6B02F0; Mon, 19 Oct 2026 12:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0816B02F1; Mon, 19 Oct 2026 12:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AFAC36B02EE
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:21:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 89285A0787
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:21:45 +0000 (UTC)
X-FDA: 85339891770.21.D397BEF
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id B7AD880013
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:21:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GzKHFjUo;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792426903;
	b=sgjBZUggkzMVuo/3wJ+WKpadV73hmDR2/15lBDuejnx+GAflQydkeMgrqpSKPtazIoqDMX
	USjayAKkf5ADkHawVbGqB79uEAfV+UVgODOpkx1icztylC5ivF6cIOPO6jXLY/yhoFFwt8
	kxhWJxtSj6U/CFZshr1s8/l0QbIxMsc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GzKHFjUo;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792426903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AXALzYiDlqNLgw2O3tAb14ubqs9EH5rpsxDv02Io52g=;
	b=BA18Z+YDYVgux1wmwAoAvkiH6huojNuXIuZ3nCiIeAuXvLii+sZ2nOFB8j4drQIeL7+ZmN
	r3sy67mVYup+a3Us3LEX163mSrdLMWO4IrencH7pndWcV9OgvkBJ3SwLSNxTy0Cy7Zghba
	rkURvlg+OB4hFazFwzatMz7G/mUHl6c=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93f2ed2541aso179265385a.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792426903; x=1793031703; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AXALzYiDlqNLgw2O3tAb14ubqs9EH5rpsxDv02Io52g=;
        b=GzKHFjUouMwecR/b/+5qbbrgb1TtfB3ZcVc1DsaByoK1ag62sIVuJcMLck+crTm/H7
         i4C6HSdRLFyM7oPrk3nfd5YDYubIQagQKrGam5D03jTLlLZjAb1FMq9ruVZW9klmVX1l
         2B/eogU8R5xy8iKUt+cCDOVdPdnrfgDqfNmiEwvjPhDtujb58MLksOwIdMIRDGOHA4LH
         Ct9PL/0kk6NAiw0VlZmw2hhQuWkkSs9vtctEkpzuLKnwr6Z6SWgAXvNnR2Q6Yj0uZNhP
         NCLssdOhrkg8o/szb9k6SqkFQepuMgLtkZ7bAuRoU6t9WD/DxtIZR2zy4sg4gp9z/c3P
         XYRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792426903; x=1793031703;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AXALzYiDlqNLgw2O3tAb14ubqs9EH5rpsxDv02Io52g=;
        b=PF7j3YNkB61I3+uP0rQ41YWsiE1phcj0czYvuh7s4ftkfrUTwqBsgFRXcjSM6QUd9x
         RmxO8JZajizqe/v9rSvFm9h3V4Apnh5EKt74+aBsR2dX1VL/wlmVO46pK7AdNy2kyAgq
         i3dAxz7wz3s4r9Sw7sKgtwtLLSfKH3jYoB5GzG/jjkxM9/pLGmkYvJiIdn2+alW4IqBD
         25OL4jx2QsSAPVJGG1OpvY9c0AE3qmnmG69dU4xRlBhDqTIBNxzG/1aNQFHXFXEQ3mVo
         2svkUsw6Steloro7joPSsVPo0wASIVisJRdku0PGuHrwYoQGySEh1DXJg2A4oFIVIeZS
         XuUQ==
X-Gm-Message-State: AFq9FYLWPiQm18TUNEe7WbfbObJoeS3rrowcbDpCKlnhUiYnVOrE9F9r
	cJUitE8ScBBOS0SVKq85ghLNslSR/prBBT0FwzpIt0Hc0oYvojWdyNSBiYYkNqdHcQ+541nh+YH
	uUdUc9Vs=
X-Gm-Gg: AYBFou05ZN2aB+a0hrMxQ5Pb4RHPy7AVHNM63Nt0zE5o4SQcJO20hXJlbEmIEfBuVwc
	lAUPTlBIUvGllS5VGc7OAf6+FPV36EZ/LLiZXYLrDKPPvNIqwJLczxDGLYq60im0/lrQLu6cRFg
	REMsEXYyNZjaXE2NxSPjC0CN8jTQeVZ6yfRLL7b80dLH3Wf6SRSbO4M3pwtbS+2NsFwjVkOqYp4
	CMCKY0N4eNclpVQxRwRdI8AwaslEYyiBKboSj7+JmG0r/VgBYYe615/AShfQveUfZ7cfgj+rMxH
	AFU/VkUysGjhCcMpEGwmfElbQPTSu6u0S5lw41q+xqnLSSmT6v4XwVIKLakR/7e0J0ve9e689bj
	SqgtgeuLKH1D8LLn6XL7DGFY4PTQ5Dj2hTwLpsyGUoSyg7cVz1pwemq9JJbZp/ZqP1556aHMPg7
	y3IKbhsk8NU5zJOsOAmDevk48ZUh+ZPaDXZnVgyLyYzCbA7pyWofNm1gnCQumkz1nsYGp5jVgVg
	HkB5HkuKa0Gfj1xsIlEHN9Po7PlDd7ERdJJ4Csh3H9EXSUJETxSpg27e++67vzs2i+t3zU=
X-Received: by 2002:a05:620a:6cc4:b0:93f:2b65:593b with SMTP id af79cd13be357-93f2b655ed6mr1165985985a.38.1792426902714;
        Mon, 19 Oct 2026 09:21:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcba4b9e1sm102394026d6.14.2026.10.19.09.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 09:21:42 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	mgorman@suse.de,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH v2] cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask
Date: Mon, 19 Oct 2026 12:21:38 -0400
Message-ID: <20261019162138.3271947-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B7AD880013
X-Stat-Signature: t38upstyfi1jkyjcgid7y8sdioodeiah
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792426903-773293
X-HE-Meta: U2FsdGVkX1/k02cTm090314d9RsGJ6VFiG9Mcdwi9RV9JJXi2OdaADZ7MwlEvhj3xDLwi8wZd/XaVvo8VHl+GNKmN7DouX3FNLY1sLGbPSWbHL9fi4qnqugoPOfrsJSsdImkN9K5YgUJ3Sylut4ciVSbOWJViKOamfL9mBGlI4YY4NgGDRhUQ+lNYMFWDEZMbXtzl9gTebkHQtSwGAEaVrShMC6jMxXTv/eQDc/M7PrSKWM1O9URg2+st+R0QglbqYCAUeFlyy4F+nqM4I0hJM7rKvtJqwpEzmNfXUNRPOObz1JWAgxtURsEGzK2I9WM+PfbIhYdTvn4z9XCbpF1FQwTkxvSKzA4H05RGYiPvkNO4hHDuWF4lRxDJ88rirkGe8Bgx3DUQ/zywv3jFELuswZgfeO1jvHyO7sDqXQLg9EU35oO2BEORgsyFQrtqGHzYS3b4IEprkNnj5hVUADG4DdyqfLE7zxbgqhi+zCxo4TyT0FTYUCyZLAHTPVmfJsTZfb93DAgw/Km0jTPAfgGW666OxQX9zz4niYA6vkcyk3tuF1CboNy3eJfK/+7Qd3rx5jiduGhTAwqd4ehIGqcjq6J5SIrjGEFvBFpVB7qrzYLsYtfyfhpl55XWL132QLqiF46+M1FmB909TqMpln8IasWizbUc4oWkKtnD6LEriWg9kdipEPLfy3eOOpzjbd+zx9JlniIAgnFfUY9E58QLEb6ID5OJpTP2I4AcK31X8iEWcfqWCdj6kmySSa7CB8OLIm101Or5RNEYGJSxM6YhFl4myfAOm9dB8Tt4SCfV/Pd0FkRRUPRTPa+PFCkJjEPInxgcspqQfi5LFnbbEHbQe8EF/YtCkHsJeC8uyNRwB36NxuZKTAmr5E36jV7SBU/w36qu7GRDvLf7E3bdEfJU9WF3di/0QEw4s6b8/OepU0pEXKDp66tFwNTfgSWMNojPGEDrorT3dcjaeGLUSO
 yHOPyx0+
 Hd8Xn7uNdkccWUr3TjmvQe0kUilW8GOUihWxdZ+85ZJ9hlF22p52yM8Tsw40O/IEuW4Zt02aQb2wvT8NmpPym7KJBZNzHtBOteD4eCVwxs/WonkgYkqdp9zIgJmKnylhkg+4cs1ukpQ9Z3BTXqlG5qWfe7r94j4zkf4C0R8uwr1Lo+Fxm9afvevJtAyA3ByRUZb4sxNvLHW92o2Ypltf28I9gJpKDXYZmF53p2vtjdJDiaiw1Gsi8d7ReSdzwdQ+/L6RqzYJ1+9+Bq4HggCJw4GqPGp8TYlMQytQnm8+BHMQDkvUOUFtSfAeduoUYU0H4d7EP1X8a2KX7SDsBoFdf2HOgSah7jZMzdmBW4gM4lNOKOhKGEPW3gA/2zC4W97ATg6ED1X9RuLT7dHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A cpuset update changes the task's mems_allowed and rebinds its
mempolicy in separate steps under mems_allowed_seq, but the check
reads both without it.  This can cause a spurious numa placement
miss under some cpuset/mempolicy combinations.

A reader that loads one mask before the update and the other after
it can see a spurious empty intersection and drop the nodemask.

For example, a task with cpuset.mems={0} and MPOL_BIND={0}.  If the
cpuset moves to mems={1,2}, the policy is rebound to {1}.

The allocator can race and compare the old mems_allowed {0} against
the new policy {1} - which will result in a dropped nodemask and a
misplaced allocation on node 2.

Simply retry the intersection until mems_allowed_seq is stable.

This covers the task policy, which is rebound under mems_allowed_seq.
VMA policies are rebound afterwards by mpol_rebind_mm(), outside
mems_allowed_seq, and are not covered by this change.

Fixes: cc9a6c877661 ("cpuset: mm: reduce large amounts of memory barrier related damage v3")
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
v2: there is no real update here, i'm breaking it off of the page_alloc
    series so the page_alloc fixes backport collectively cleaner.

 kernel/cgroup/cpuset.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3f52717c19654..8ee239d5c6b48 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4354,10 +4354,21 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
  * @nodemask: the nodemask to be checked
  *
  * Are any of the nodes in the nodemask allowed in current->mems_allowed?
+ *
+ * A cpuset update rebinds the task's mempolicy and changes mems_allowed in
+ * separate steps, so retry if an update raced with the check.
  */
 int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
 {
-	return nodes_intersects(*nodemask, current->mems_allowed);
+	unsigned int seq;
+	int ret;
+
+	do {
+		seq = read_mems_allowed_begin();
+		ret = nodes_intersects(*nodemask, current->mems_allowed);
+	} while (read_mems_allowed_retry(seq));
+
+	return ret;
 }
 
 /*
-- 
2.53.0-Meta


