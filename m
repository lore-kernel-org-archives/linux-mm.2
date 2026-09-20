Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 392E2C982D7
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 02:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDCB36B0088; Sat, 19 Sep 2026 22:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66716B008A; Sat, 19 Sep 2026 22:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E526B008C; Sat, 19 Sep 2026 22:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD6D6B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 22:31:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D206DA53E6
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:31:19 +0000 (UTC)
X-FDA: 85232563878.07.800CB6E
Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 24FCF1A0003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:31:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G9iKce4A;
	spf=pass (imf19.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789871478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mVeyuR2cIR+fQnzLXyObLYbioaeM21VgFPAK73XbXwk=;
	b=t13wEtoqN8ZFo5/i9oXGcL/5j0MO8wlQ9KtzuVwfZX2KzRSjc+Dj9oh/8MXdUBt+qvKJhk
	3fRHUMIHPxlZrK7eHBHpalRreuqevACo/RxUclql+wvo+eBtvuJNHcM75mPTQ8lY4riHRv
	dj1NKZhdbJNHSVDf1uju/Qcntaor990=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G9iKce4A;
	spf=pass (imf19.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789871478;
	b=jJIDl7psBblwfdkCDDUnH4u13fbjQTuHKxFTcSjHBqHrCgiKcC2UC+ugtFLBZYK9g5Esga
	KNQPnq7CgcFDY50yhW6PQ5yn64dN7N/ARxkh6gkZ3ueXH3xoDzEgnGPw/j0H9tPMRuCgHl
	nQaHQziMlNuWP1OyQk8Fbn+KgpFTHlA=
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85469a34907so2139955b3a.1
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 19:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789871477; x=1790476277; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mVeyuR2cIR+fQnzLXyObLYbioaeM21VgFPAK73XbXwk=;
        b=G9iKce4ALz7IqCs8i0H3MwnATqE6VKlGRJL6rkxTsWfu/9BkdS2GCvU6elBL2nGCpJ
         INJAszXuQ+ymxyxG++tI7PsgYgIVkIpanDSmYfZxi3a6NwFNSfyr0xndbBAwwu0h1u6I
         qfKH1EtJEsg+/cp/CGbg0XcAl8iMsqSDK5y3rs09mI4wKim3VZ1Q8q9iAIHRoEr4xSv8
         Rfh5Sd3iEp9YzJCvYQ1oPagQnAD0QTFjY4l8MUT3mVTI5INlsPwQzkPrH4bZ4IsNQ+c/
         2FIFM+714axTsH9v3dlQg9Fg+cN1lf4fbxkHqa43UKL8FBtl7rSQTuNMcZTzwUEEfZZs
         wZDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789871477; x=1790476277;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mVeyuR2cIR+fQnzLXyObLYbioaeM21VgFPAK73XbXwk=;
        b=0maCNSYcaKXsRTwEZTNjgVjgmCrMoK5Mltn47A7sSdjQHEelxn2lPRAWoE8aII1N4R
         6Se45Z/MA4roOdQr/mgygPg84yZkwY2AM+0S7JVp/eRsH6adFyAr+x/CvzPk+hm34Z4W
         dyNyDh5fpZ3B4lYv7TEgZLxG6XIlNWRNfEj7TDK1uhzNn4Yj1jjyf/PODwEdEc0XcaFP
         uFE/nP50EBneMC3q6SS+hRvcwjwVkhpYW+VQFY3SEP5wcH2QuEbm8lFIPBKrI2hM5CFm
         q9t1ur9dsWpDe1/76EsIADygxURC9A5DAO00PM+Yt6mWwoF2UScw3ySCUi/fs0dQkcM3
         Bu6w==
X-Forwarded-Encrypted: i=1; AKwUvBxGYAbSjsKqfcLGcWN91ywffncPCNBJ3fsjbRnML/AdHRfO09Wz0SUjuSZUwe4e3Ao5nNg96zM87A==@kvack.org
X-Gm-Message-State: AFuF++l0bs3RxXSKmCEGI3ILs37lHxAvH6gmPgDf71ZWzkydhl7p/vZZ
	9odYzMFj+vV1+W6bUBQpt5AvMj4pCFhvyL8hZgpBn/J0+QH8BH+31h8=
X-Gm-Gg: AYBFou0WVO06asj4MsgYRp+OpApK0OeO7az7aGg2Mz8kN7vTNECRQ1rKLq2QmCNZ4Ki
	10BHVvyF1S96WSIJQJBbanSSUnMuTuQJMjJPhS45To5U2/VirctoyDoh/ZzTBsTPvbDCtMg9cTQ
	n4WVBwKqmgYw40G06Gok5j/OSWpS0XyC9ENYw7Ow9THsNFO8u96lyuZsd9TfDHZFyaL9VqCCJRc
	b2IU/eXPknfrLzlFZlHbketpaa4LL8NWhNQ4pydf9frcBQjDYbnN+AGcHo9r4al/OcNaO2kjvMN
	HWEpqpRvLcG+HEMQCwiieVk7AR+Y5zXP3hzLZskr3/5ARxIc/J9rVsNAb8sX757r6TcMw+WhWJ6
	9brnvc/f6TAFlcof/Yq6YazRLk1FV8uGbJGub0ToeIwLYrxXuxXGICUP/kHUmENBbt7xje5HYna
	4BjzmJldj23id3ibcnAbmutSCwuBFpndK5uz0T+phGgonR5G7fb5XJIxla4/W6PTKFIt0gKDNhJ
	1djaD499TT7nhIaWyJKU9GnHQ==
X-Received: by 2002:a05:6a20:7f8a:b0:3da:b8b4:91d7 with SMTP id adf61e73a8af0-3dd8c3fdedfmr11656400637.2.1789871476608;
        Sat, 19 Sep 2026 19:31:16 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:36d8:54a:e0bc:3e5e])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc72aee03efsm1481341a12.24.2026.09.19.19.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 19:31:15 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH v2 0/3] mm/damon: fix the temporal goal tuner's size quota conversion
Date: Sun, 20 Sep 2026 11:31:08 +0900
Message-ID: <20260920023111.2466265-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 24FCF1A0003
X-Stat-Signature: 7ha3y9brw45cqiupbats4nhxyfoyyfdi
X-Rspam-User: 
X-HE-Tag: 1789871477-283508
X-HE-Meta: U2FsdGVkX18wCrgV/P+OcSDSM22IKLdyNK6W949WstBjTcIEOQywXyrks3LB8qzu73b6kyndrl+yV2v2iJwxuy1zS8+9Pfl3YzjyPvn7ATpxi7AtpqA5YwRE82cspciF/b45hNoZFjSU1Xe4rKYLuJSw+pullFBH6CJmFxuSY1gWvhE9Xk73j2C+WdZm0VQO43vGipwhmRedM7mvliC6z634Ds6mXjV3XZMOi2WQsVFPtjEPXIWcV0Mr0g1qFocBA1QtqGfdtx6iN/2kxyMtWGKwrwABkoIQ20FByfE6RHfW57qaUhTzF9Mnb7tgUhDzPU2Y3VZkSaQBWpsyRypascK7RFEtLJvGyzffi4OfHl+8JEuNu22pXu+AtDSzPNTr33J5KQACGPTLe1nLpa+W0xXjH3A+LnDUiqqebrSe8r6nqqkYG+JVWo910/zKRFNNEzmLqBOzDy0e8eLeTD2rIffJ3UbRYLixEn2ne8RNXKdpPwHf8AbepHhHyP/QDYVSWpwieyP7eT/RNB8cQoA4i+XzwLl+pU6Kp25RT0djFZ96BWvxY4cwHW671ysDC6bIjLO/XZenuiBzYDMk5NZATY6BlkmSjg1J++r9wsXDqsSko70mohl+k0vE6RR9tTlpkakuqi50B5PfIeW5vW+lsDUL0I1K9r97+145oDMfCx++hC9TcN5nlItssOPHmoUUD9nrYuYD80VZ5T5wpD+qEUVNqR+IIF2FtNYbwrkwE7zYABiXtr/AKqqec8/q/BcwlYgKXwloQwOYsYcMArAIhdyAmIv4XfoksjLSM+HMpjeORKbcYwDpLg7QeMgeNZuvyK9TpsTmPYgYN32R/tTCGJmI7uGkkW5z+lzd/OP8KBQF2G1jqaCGI0VJGaXW+w1uCQwzcSN6mP5ILDiXG/pDA/MculorUhIFqvtfDYXNuIDxaYbwqWdYalzOArxjd2XR/r4k1EkNsWDClQNNKD4
 Vr1giepk
 HuGdJnDeIMf0bEyQx3pgDcGk0PFL3JUx8Z/+CLGDhX4GyOESfxWv4x6SAwBE4BH7eO6zrT0Emd/xNzFqL+cBi0iY3SMZAkBRrrHN0ASQP8AlSQn3DVaDJcN4hcK2n+DiqwYHr0mREtZ6TN3yun7EwS7m9i7RMDe5lmN8Y6n/GRxtbxYBwMS5huVzAMR/DeMlFDl9eDqJugz5XpMFWo1YDfVGOQg5swygWAAtByxYaKLqA7sTbY+h8WFwDHafErbzRGng7L3lXuyJWzqN7gWWONH31BN7zQ+EYfmrYclMV2bGdPpmW52fQZe5A98rQ32/pMsP6hVccpHv/GdewO0OI9PNLDovWpZsxNuLtgCJvVuE2/1VA7dtlWS2LT17thmVhG1JUQC6SGqU9eQoC+UENfdaXrJLA+SEgxzQLTY5ACpf2uTMnZLPg+ujdP4SMIn2W4aSssK2zlYnoz74lde4JZ0RNgs3pFP3WKv6LogtUPTol1kLAMhhZ07YItazqKFkUn/KOcaiGDY2W+2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_goal_tune_esz_bp_temporal() hands the size quota to
damos_set_effective_quota() through quota->esz_bp in basis points, and the
multiply that gets it there is unchecked.  On 32-bit it wraps from 429497
bytes on, and wraps to exactly zero at the 1 GiB that
Documentation/admin-guide/mm/damon/usage.rst uses as its example, since
1 GiB * 10000 is 2500 * 2^32.  A zero effective quota makes
damos_quota_is_full() true on the first test of every charge window, so the
scheme applies nothing for as long as the goal is unachieved.

Patch 1 bounds the conversion.  Patch 2 pins the boundary in the core kunit
suite, where it fails without patch 1 on any word size.  Patch 3 documents
the ceiling that remains once the conversion is bounded: the basis-point
form cannot represent a size quota above ULONG_MAX / 10000, so a larger one
is handled as if no size quota were set.

Changes since v1
(https://lore.kernel.org/damon/20260919071324.1583280-1-donggeunyoo.kernel@gmail.com/):
- patch 1: bound the existing multiply arm rather than reorder the two
  arms, per SJ Park's review.  Same behavior, one changed line.
- patch 1: address addr_unit -- it mitigates but does not solve this, and
  the 64-bit boundary is reachable without any scaling.
- patch 2: build the scheme and the goal with damon_new_scheme(),
  damos_new_quota_goal() and damos_add_quota_goal() instead of a stack
  damos and an open-coded list_add(); drop the max_sz local.
- patch 3: new, also suggested by SJ Park.

DAMON kunit: 36 tests, all passing with both code patches; 35 passing and
damos_test_esz_goal_temporal failing with patch 2 alone.  DAMON selftests:
15 of 15 pass unpatched and patched.  They do not reach the changed
function, though.  A build with a print at its entry stayed silent through
all fifteen and fired as soon as a scheme was configured with the temporal
tuner.

Donggeun Yoo (3):
  mm/damon/core: prevent size quota overflow in the temporal goal tuner
  mm/damon/tests/core-kunit: test the temporal tuner's size quota
    conversion
  Docs/admin-guide/mm/damon/usage: document the temporal tuner's quota
    limit

 Documentation/admin-guide/mm/damon/usage.rst |  7 +++
 mm/damon/core.c                              |  2 +-
 mm/damon/tests/core-kunit.h                  | 48 ++++++++++++++++++++
 3 files changed, 56 insertions(+), 1 deletion(-)


base-commit: 498ee28e5ec4727f829507c4a1bde3ab1b7704cd
-- 
2.53.0


