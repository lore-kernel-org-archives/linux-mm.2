Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24860CA5FA6
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5204F6B00AA; Mon, 28 Sep 2026 13:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2106B00AB; Mon, 28 Sep 2026 13:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BFA06B00AD; Mon, 28 Sep 2026 13:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EC626B00AA
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:41:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A24291602B6
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:41:58 +0000 (UTC)
X-FDA: 85263889116.25.BCD23D1
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf27.hostedemail.com (Postfix) with ESMTP id 00D2840005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:41:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SqBWHING;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 346a6aggKCHgoikopWbWckkcha.Ykihejqt-iigrWYg.knc@flex--smostafa.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=346a6aggKCHgoikopWbWckkcha.Ykihejqt-iigrWYg.knc@flex--smostafa.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617317;
	b=bnF201wfHxPMMQVu/SbygLxgW9hBEWunua3YO76VrxHeupmtzkyr+p+yBK5uhruXRQOVQf
	kOulUYDFqn4hFvdSa7e1MFdWEucPw1w7q1wvXxWYwyzeHlzvFThZNJm6KSu4nKn0xsX1ft
	zet+dGsy/NrgOAP4fMjUpUs8OE4x0EA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SqBWHING;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 346a6aggKCHgoikopWbWckkcha.Ykihejqt-iigrWYg.knc@flex--smostafa.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=346a6aggKCHgoikopWbWckkcha.Ykihejqt-iigrWYg.knc@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ci6kw3U2QUuQ8iEQWyGnN3yV0fEIMUBiQ7ACCZCMmiU=;
	b=Dv30VKTphuG3DMXhHUP6k5d7P5mTh7dLT23Uq3NDzsHao2Y7q1tJ8k1r0JbGHLblS8UY9k
	s4LResff2Ynxi69pWNxRjMfj2KDNk42BOyfGaRFFT47ArtQUGetj4OyeO4CvS8TUhcF+mk
	DzMhL9mmB1/fPLrjx5ozoH/LvS70kHU=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49e6ba4abdfso35203535e9.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790617316; x=1791222116; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ci6kw3U2QUuQ8iEQWyGnN3yV0fEIMUBiQ7ACCZCMmiU=;
        b=SqBWHINGsRqTc3ca/n0+ic2G8E2B7IixGp7cb6jGO51GzcsCDF4g1X4xPtFQfOpOr5
         Z8y1WH6k6s88fJ3lpqbyjH2hdm56dRLNnwkMC21o1WmbCioxAtCinxg220wdi9vBZMqV
         joyW04dYgm9IBKkada0P1HgA51e/ERCbeKhPjFAc9aW1wg9Pz8x5cEYx1mQWSwLzrevA
         ID0RqbYEvKd2NyOJrtuRS14ftGSQCTNbDj0shblp8OmhDbnpqubWGZmijqeIjnZNHqT4
         rLisP9FO79mhaJpEP6yud/sMw9/wLByp8/n62A7CCWrWUgbhC3tKEzDYA/ZMyWlkv0t5
         yfPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790617316; x=1791222116;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ci6kw3U2QUuQ8iEQWyGnN3yV0fEIMUBiQ7ACCZCMmiU=;
        b=q5lJNsAAUUqBG1jmQrRVrQu/zu5Ea+/0kCRTx9nQDUa0+9CiN/uR8G3f/d78Cl92pA
         jy/gtq+luPF0/myoh0UD4tEuceTcliD+Qu2IV1vWKMC0lyY/Pqm73ZqIFW2bPyeGISm8
         k3I8K0z6J7e/HtZvdVFrY6RebHhBeDwyi8PrgGyUckDvdrVT5dJiTE+7PzfjUrbONZ2V
         xAg8gMjA+WqkNmjvafZvZKE3zvQ9JqN7Xbz7+mSNm0ZhED8ljzTNFOkQImc3zcIQS3DI
         UFgy1yIMwNs0cIwfFpRsEGPUHtpHpgqIMUpz+4o8lm5nOc5quR/9b5RoOqNGMk5w6EMc
         2tNw==
X-Forwarded-Encrypted: i=1; AKwUvBybAAL32VSn2mDGVgPFmKHUyn1G5u3PYjR4ERTmn9chHXox4OcqSMn3sLI/IjTbgt2L7ofrYvSGsg==@kvack.org
X-Gm-Message-State: AFuF++mMag8nxCgys9+bhlNeOIduzcDHVX5y9999AgHddJbVWbQhvBO0
	b7BmF8mWbwnn6s4jNFvY97HWnjKDfL8wATAyhvO6V3oHGOegSeVuWnQiR62STisMHOqChLGYizp
	tXvOV64h2fxHj1A==
X-Received: from wmoz7.prod.google.com ([2002:a05:600c:787:b0:49f:e26d:37ea])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a16:b0:49f:eddb:bcb1 with SMTP id 5b1f17b1804b1-49feddbbe6dmr202116635e9.25.1790617315540;
 Mon, 28 Sep 2026 10:41:55 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:41:14 +0000
In-Reply-To: <20260928174122.3380703-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260928174122.3380703-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928174122.3380703-8-smostafa@google.com>
Subject: [RFC PATCH 07/15] usercopy: Don't assume the kernel stack size
From: Mostafa Saleh <smostafa@google.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linux-rt-devel@lists.linux.dev
Cc: corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	akpm@linux-foundation.org, urezki@gmail.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, kees@kernel.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, gustavoars@kernel.org, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: hkeqgm61fjw9k36h6jcqn354cg5xfner
X-Rspam-User: 
X-Rspamd-Queue-Id: 00D2840005
X-HE-Tag: 1790617316-895137
X-HE-Meta: U2FsdGVkX1/04guOWLa+Mr+w5Yw44GbSW929zwm4muIa5ftPg0fduMzAOFugOD1af9geuD9RlqMUHfU4rKrn4rE3SI+HIS3nzBK4VtyIgN4duUr2Zs0fdjXHQzETywlwrT7bj/oTcX2FFPh5zDedb2R9uhmraiNtT/ik409sgsJ4To+rBB7lR9BVTFDVp2xvVW0lB9tkpfKRUkCrFIdPr+XtuNTr5lZHuIvZz+/0DS8WMVMIF1sYP8kyX7BAGXzYvQp0FgN+/c6vyhyb+ywiYzrpXmibyhm3izBTRfdGwcCC6baXmiz4Hs+dFRt60Fq04BnUnBHMWfAUqUb9FEGJmsFfRSvNaZHtUU/c2FgyjkvhmkbQYxzIwoV1oxMrdr/5WoNjHi2XYCN+8oxvJvRCaR6j+oxZuFAVafjTUrb1o/JwpsCVxq8v1LEmTxD3FwfSzQYQy2wbn4NAYmEX5RfZ/3UHqON2jHXSQ42ucWsd6ht6mmK+N0u+3oSCo1lvdJ6o+2TrBV14/QBSCRVnRJQWi+ZM0gk+TrP8z3raPmUZaxOg8xrwdczklIWQhpNWdMF6QgPOX/dkQX99uJM/z0MI3OOoUMlFIjCR4Eo98qR5U4Z7PQrn992x4IBnf7aW0OQcjDEqn+CpMO0vL1uxHsHU1PCQ3LBHHlMohQGLV89n1hzWGTepZtsw3DQN/a4cTqxau7Tmh3dSjV0sC7IZa69CfSlX81sn9iYTEQW0rWy+xVKjnwyC16WJWlxCfxrqIW4UaURPU5blb27J2F2zUbdcmgqrE8CNPazz1wYaJeumbW3GPjOyeCdd6V0i7ShnWXrFtjkDGnyV75cLZ6eBMxH9tAK8heD70SSY3TaP+NRDYwevg2So5OPVeg6keVobYxQqhxUa+UF21SYitnSDz1VVrN4Om9RfRhut3hKhnl2am+CqQffUhUYIP3rj70/TKySizdkM4zgpmWxtiX23LNA
 KlAT4jch
 4uC4nWtBl7y4WTe4TDf0ybFhKJosgTLyjtv36zNIgrE8S9fy5mNea16BMInmexRY7HA4C4uzK3lOKEFjgz4rAxWahcPNOKklybtNQrMjTetueuYluWP8LgEpEWuanzfKpoA9XkmXQcVXCUFmELHPv8uO4rMKN7UgNbt3t+mbgCZPBP411pgKQtd78UaWAfVgyz+IFo/9q+SLDmVXytfsAPcYCzO4R5AVa4Uy2YFHBzpqWzt7bIBGAOGmDbdR3OeNR/TttBgLRB3Tfo59Y/3M65KHLaxe4yRyZT5XyrCSxs75Fsf840R6vRVLiBNTd/HnuZM+p9S2OaRTC8fy72bRXoTfLl1mx3XpZYt5ptVwqM2DcL/9ymfZj6sb/jYsf5Ci+Vr3VKAibbZHs6yhVWZt77Lnszm0nyp/R4jFYBqM/SGLOvvOyuUGVTk3DcZxSjkbRRPX28eYaPc6TTFR2v8yTBtUnZaqBWt+UX6AGg7TsqfHunqk8SqijHrT6E1lM5VrNVBkq2CnW7rvMlimvdIbsvu2Bd2kDEGVwpU0sl8rAqwHQQTvA3xCA4+c9MGE9XM+Lf6Enj+zWEulcbwFFWzAeQUiMIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

check_stack_object() assumes that the kernel stack size is
THREAD_SIZE.

The allocated kernel stack size may not be THREAD_SIZE anymore, rely
on the newly introduced helper task_stack_{low, high}()

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 mm/usercopy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/usercopy.c b/mm/usercopy.c
index 5de7a518b1b1..f31a42b9f9c4 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -36,8 +36,8 @@
  */
 static noinline int check_stack_object(const void *obj, unsigned long len)
 {
-	const void * const stack = task_stack_page(current);
-	const void * const stackend = stack + THREAD_SIZE;
+	const void * const stack = task_stack_low(current);
+	const void * const stackend = task_stack_high(current);
 	int ret;
 
 	/* Object is not on the stack at all. */
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


