Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7B1CC624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A91EC6B0098; Tue,  1 Sep 2026 12:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A42556B009B; Tue,  1 Sep 2026 12:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90CFB6B009D; Tue,  1 Sep 2026 12:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64CA36B0098
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:53:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE6FDA3F3D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:53:20 +0000 (UTC)
X-FDA: 85165788960.01.B4B4A1D
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4563E20006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:53:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DDXr5TC3;
	spf=pass (imf13.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788281599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pJjngWo89DVxd6ai/hkg9rTN/tcZiu9r0IP6u0ad9gw=;
	b=FYDy1s71sPv+MnqOiCrXcXHQpJFpsxRROXazSna4xp+Bkks15wvIutvcVfhpVI3uUD3Dn9
	smWNNHrTGxvGWlbuCcwxEv59gw/dsUy0dNQMnXCmrFbjhIaMP1ydgi7bbapYeCpsquqR0e
	hxe2ny4M8zR19lU8J84Yu3od06dLW6c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788281599;
	b=4SPwXQwjNzigu3xt6cpA2GS/S76oaMlZ+zggnrz0gvNfl+pGYeIOsIpnX9eJl5ItKeG/Fw
	8iVThE0FTEQunuMfnO29QN1+LsoArBApFUnlPRqf5ve22+YG63/Osq5D2WL9zwZitQoddH
	8y0+bOQLeXb7nR42I5iIszk/mggbCl0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DDXr5TC3;
	spf=pass (imf13.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2caced6038eso484155ad.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 09:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788281598; x=1788886398; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pJjngWo89DVxd6ai/hkg9rTN/tcZiu9r0IP6u0ad9gw=;
        b=DDXr5TC3jnyBO8dLiNCiD0cYHQOoT5BjStTsXuPlCjGCsZKG4vry37o8RcDNYpJqXx
         xj3Y5yib4XwmnEFcalsqkgcxHjjIWf4DXNjuZTszS1yaoUxlNI2lqPKky7w/D3yPk+Mb
         Gzn5QdQ5cLt+XqN4RlIr1VIrbrReNDTroW/A36lpAjts7i62xJqCPF5U2lb5aIX0SDKZ
         QLOwER+KI5v5c/CX0SkDNf3yNr+DJgWqNEpjfYaVAPlmVhgvwNr7UGv9GPsHXoCiIq+n
         +DXSFKuLCNQVl+gJTaVAPoUyQSvF+WZrLHBdZ18Y6vUc9/tRCRcQzPWFK+X1qQfK9dov
         atwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281598; x=1788886398;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pJjngWo89DVxd6ai/hkg9rTN/tcZiu9r0IP6u0ad9gw=;
        b=aapENsMIHYXaSa1dM7DH99En1tINVMZSahTVJB6X5QU1JPL9mZJzbaP17NJ+zTz7UJ
         /upDdQuAnvYnT3zC+L8IUYsyjFsOVQl+Qw5JwSBW4Ez/fgj8lqEFQ89e+5Ya4kBUxSMv
         dIyIaYvzhy9gEaT+3SV5b3de9EsPX6Mnaj4640MVneRniZ7+HjWIJTYQFcpt4jN+XazE
         25b/wfPfW3GZxpWtWZ36AydjGDkvSEzZM8Z4cz1Jt1kCXX3Dq9TcJO9fLVx4HQC1bDF6
         EREB2c/OA/X2kePp+EsqMSP+tQHIgqikZsCbbs+ibWai1IXWlmxF92iXpRCBfnrVhCHp
         3abA==
X-Forwarded-Encrypted: i=1; AKwUvBzud/bxTk3i1Y8RiWdAzRuTuehuBOgvaZ9ZSsvNzkmUM3OskUuNEhA9QcjRFSqqRsxNUPFC9nP9ug==@kvack.org
X-Gm-Message-State: AFuF++mS6awrIz+2P4v69wjEy+yUmziektPHRNiSZ5zXBiH/NHJHCsRV
	ZacccJwbVZglU0+2SEwsmOfjhc8e+BeVnthxtpaDBJeUTyC95INOEVeQ8v5KZ/Ji
X-Gm-Gg: AYBFou06ag8lb+vwidZQxAEP3JxLM0NIvNwORM/jvl9nFtjU9hb7AqgyYMtxGfP3Awn
	MA9zaibp53JaeO9Ujukui1OqO3SRGLMJ+oKL9X74rt343bYgwmpDQjbZlAIkb8XUIOq5ZNTNFu4
	BehykGNFvZ5kUeIGLLEnGFQ1lZbjLd1wKFrC48aU6LEEMJeYj4eG+P3DMz3jiWEKNbB7kWoHwXD
	EGKrhqbGX7r8SEywB2UDXdjY0s+DyWo+puRzb32Sp+qBYRZ/EqasdjI3A+76BzyeB9EC8s0TZW1
	qmMAaTZkoxj/1mWYX3JSPxOtW7Fl37KGzHyUA5wPbL5+26WoZT7MYM8VoGAqSqNAP/Y8wBZidZP
	8X4KCWoj1rzdSvMaxKVbisZ2RN3L+dNpVhS1kVR8RVbC41uZp0NH8iDrHLa/Zu7cOYBJSA7ZF8x
	AxiJZZ+hHWY7TPklNUXzJEtPHhW//Zs1zqHCBSbIYe7do/dxHGWCBxCI0=
X-Received: by 2002:a17:902:fc4c:b0:2d0:401c:2edc with SMTP id d9443c01a7336-2d95268a82fmr70377805ad.1.1788281597897;
        Tue, 01 Sep 2026 09:53:17 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dadd357efbsm1762325ad.4.2026.09.01.09.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:53:16 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/4] percpu: remove code with no effect
Date: Wed,  2 Sep 2026 01:53:00 +0900
Message-ID: <20260901165307.1026248-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1juuwpe37nazxiucxjudt4g4du84343i
X-Rspamd-Queue-Id: 4563E20006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788281599-532684
X-HE-Meta: U2FsdGVkX188H4RQ1RMfOBQB8GvJC2a6ydpECFxI+Wy6Xs4h0XjEXLyoLqDh7K0cRi58/eoeBYK1dNwTmqD5OnYgGz24ns2uA7IakbbFFLMmXnrMsmtsVlMDKRkK8mbE5Ao5hr8dTyljpmfqJ9bVnexQ4KsC+qnao79BY6ikrQKI3133NHKiA7RSyg/s8af25hryzVTwkMqeC9ratBUGO2n84EFWoGr35c8E+EIhQVzZSgm5HL5rOO5p1VrZukCaGKZzKmeTjZ0tGqr3T7WP4gQ36PQlYO/FgkJ/TBCI9hzQGCpdL02y4dyW4z7wxdlYCwWojGbjCPHipXYSm+uqHZMksxaXz2CvMpkkeUvzOibtuWUn6TE2HWDAq60hxXfe7oVvN+4+6Gi+hRUFnI+rmydIgcnXtpMTnpKl600M0l1uRQb7Ox529gVGNGuVCdTdHwaNstpgX7LFXPdXrLjA8WAb1R9lCY8roPkhNl//9SzIzGbu0J1g8bwpKjW1AZKzmorHLPbSGnZM6HPoJk7Ke6TfqqkXYSVwUNrM6AAVnwb68ODOPkuz0nmkKRRVnfWUAVD+M2AyknyQ9c/ASksUGMv+CrTPst9ITo80J/jls00ZPTAvlJqHWz+km7YF3NE8n3dFFLZyW54BKVCINj+L+POSuKBf/6bXHAYNFwuzFVk0IiCxJhOMt1jGvEnKSlylI0jwZV4lW11yZCum1wCUX+gESdzrbuLNIvZJLn6hfXF/K6gxDXqs4p1TNE/5ssl/RbXkrwfNjnj5xNlJ4kSHRHQiIV7mjUYgF2JUd3M9a02COF42Z0Gmdmm/9otNv7dGozHjvwHM4JnPWkPNb6ySnwosk/3lK4MgEr/9APxswyErm4fMC1Szhnzd/0bpWFKNG8pVh+lIZ9F82VjAVurM5HJHgw3Sjn9p+0mPj2ifkHWyOYHk8h760QPFfjm0uTMHXtkt6AG+y1epIKj9Xx1
 yjGWfpsR
 nLuHLubDswq1D2+ix+Caa8lY+Wug9gKyYAbnuIDkHQTi77FlKOjltaocCMbMexOc+YELmL3yBI5V+PtWOPR7yQONZO2jWgb4/74E6qMJFjZ04D9xVBd6uFFM/mRevTHLY7SL2+4QJiWgU8pqY0fg9oTpKIay6KFSa2pwF9daCXfDpU97pnQlyrpRQUk5t/9LSMQlti8NGDlcm1BBq2b65x5EDwhLiqPn5jI8rCvibG+c9X0wQoTllXLe9jupy7SaPL3OyEuSpiVsR6vpNzxl4yp08smWKP0nfPE2F9LuznrkhtjSzMIVTb0NcL16j/OVUsbfCNsJFZrJWsQYGcwi6CbpRXtaegVPf7YSUeeUFPs85vDUM+zqKpZnVwAWrRSaUCfIy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

While reading the percpu initialization path, I found some minor
cleanups for unnecessary initializations and an obsolete return
statement.

No functional change.

Sang-Heon Jeon (4):
  percpu: remove redundant assignments to bits
  percpu: remove unnecessary initialization in pcpu_build_alloc_info()
  percpu: remove unnecessary cpumask_clear() in pcpu_build_alloc_info()
  percpu: remove unnecessary return in pcpu_populate_pte()

 mm/percpu.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

-- 
2.43.0


