Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC714606A325
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 02:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jsfNUGh7
Received: by kanga.kvack.org (Postfix)
	id DC8636B00EF; Fri, 30 Oct 2026 22:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D795E6B05B1; Fri, 30 Oct 2026 22:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8F576B05B2; Fri, 30 Oct 2026 22:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A71026B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:59:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20350A85C8
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 02:59:00 +0000 (UTC)
X-FDA: 85381414440.24.48E17D5
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3B767140004
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 02:58:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jsfNUGh7;
	spf=pass (imf23.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793415538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JkfOBmmLSdrkWhRF5jU/G/pRdN9hDyVrLyqK8ebtGdc=;
	b=7iLp6Jf5hD/ozrLL3TicO2YhLQibFtOFMpW08ipp1UCQxAevdb3WZDrsoMKIonVveLnl00
	ywy93qWTFDTszcKGW6kfi/va9DDSuCpvZQp42MWCoc27L8VKCwmu79CDVsNRr+Ovz/3Ene
	H8TD+AfFlHq8mIgxS8EunBKsCqIRkoQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793415538;
	b=omZ6Ryk43aOUoHnwYeW6GNMj9iuRW83GBMEBI8gNmM2EpZFmkbCrR24dgAskzTi/uonFVt
	bk2+HHUofkLerKgFOUUdwYEwR8J9UmYE8RPUHsqbeCFF/TAeEVLWYceybQTKMOt+j7LcXF
	V8/ZGI6ud3AgMC8ZWag7AVrV7hcwtgA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jsfNUGh7;
	spf=pass (imf23.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-170135e43c7so466481c88.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793415537; x=1794020337; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JkfOBmmLSdrkWhRF5jU/G/pRdN9hDyVrLyqK8ebtGdc=;
        b=jsfNUGh7ndHzEoPl59XkfjyHOZDNHVLTCsy6FXepkl0Gw4edLePsWDAmPXWwzZWAC0
         C1JBYOhQK7k5O0ZfgNWc2/GMNQrFUaYvSMOcV890eJ7CF/VJDtH7tSmlO5G7FuHezuWh
         zhWYW9SgwCLEJKyB0/AnBW1sdoGU/GSOV1tjfdHI7EfSdOtfi18Z5t0Ladc3LGgjz2S7
         Y3qVNS4yqpZHuWIo447jywmnYJ2CqiFnMe/shyjDpu9Olh1q1+liruygYAzU/Q9MwLph
         2QaG/vyt7dAAwtgDUKV+wFTk404UK7pbTNmpxGsgJa4A65JDLr39MYa6FnZsbTjL7+I8
         j4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793415537; x=1794020337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JkfOBmmLSdrkWhRF5jU/G/pRdN9hDyVrLyqK8ebtGdc=;
        b=nLMT9kaasF7NJuM+v0gEkfo7sutO7nLR0Hk12jvYlGV7fI0btIO4uwtMLc+gDkIlhZ
         VifLNkZKPicnVXSVW9228OAi/cflXGhwWc48WKvna1Rpi6JUWApKcmz0oatK0F8ZyOVG
         bMo5H7UtLA44VM8mKhqtnx1W3OqU8oAOAlW0zuZoKr5aK1WGI1DHEtYJvCkQEiwXsoSR
         tsbOpdlN5ZfhswragkmdysBeK/9Ekjifx8DDWdfUuSJ+gFz+5q+I+jE4zQl+JW+vuMRZ
         9tnB/JH/mhizgED3A4m6doPWneu4iErMMSd1I06drgsCeQgTyNwOxS/slAjSMU9gK1MD
         0pYA==
X-Forwarded-Encrypted: i=1; AKwUvBwizeNW5jBkJdQcz8FR/bP3dx0PYwftjw1MOARdrd8oBjr07Ac5J9ea8S8qpd11h0kFrBihlYRmCQ==@kvack.org
X-Gm-Message-State: AFq9FYI2kOt3eojHxpJgwfB4d0V5Szf6R6lDUugs20mDxscQko8KhbsV
	z5vQUE0UwKq3EMKXWdUUx7QdnfDj0C2z0EJqWb7dEnzMTHjss0/DUb3c
X-Gm-Gg: AYBFou20wrpIFurZAMkagOjOhLdQWuTG5cmbA+yEm/Uaz3evQWImlwdDGsB6Eo8lBJW
	EE6rsfp+S8WMjWv+tgLcorVsGfg6UU0tYlZ5gqxRheDBIscdYoSOAO960kbnrqQcLUK9VAwHPaA
	dlwW9HnXeA42xapnEu1pxbR5riyNYw8tD8G3RVPmTL2LL7OmXQTWCBTJ0g9RHXkPMXYDOmYdrsM
	Gebp5RJd66eL8SpqlG4GgCQSk0XEr4xzTz6rC9znjejiQEQahVhElfT9DpixjH0a7udwoXI+McB
	DaDAhvw4wb6vXXGBEI090ci76LYKO24VQGl4hw+sWdwg/vg9ju0IE7GlNjLsuLI/+Oeh7Z1NI37
	ZQTrXTYWB/cuC73dFNuxR5wTte90oDtFi+Ttut2xLBMxyrGUrHVC9YlU27MRW8C0MTlqKDALiKo
	eKetmjd7XJDhuS/fhB8KqyB1Ey5nzSnpBzRpRTr3U2aQ8aKGEZmgJeOP9ZBJ0cqLElK8M6Yc280
	J0DHdcUE/D3kzzNPKyDTyrI8DKWg8464FLmiMnvdLct/SHb//vRgiV9AQPeeJ358gA/EPCSALGM
	LHcdQyn+qqeHHbX01Jwn37JOY/VE9F+HVf/LJI4a7v1eUZQ=
X-Received: by 2002:a05:7022:1181:b0:154:e9d2:d741 with SMTP id a92af1059eb24-1ac5bbb4870mr5104907c88.8.1793415536649;
        Fri, 30 Oct 2026 19:58:56 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1b0a628bsm10940998c88.22.2026.10.30.19.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 19:58:56 -0700 (PDT)
From: zhangbo56 <zhangbo0325@gmail.com>
X-Google-Original-From: zhangbo56 <zhangbo56@xiaomi.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	bgeffon@google.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@kernel.org,
	richardycc@google.com,
	zhangbo0325@gmail.com,
	zhangbo56 <zhangbo56@xiaomi.com>
Subject: Re: [PATCH v7 00/15] zram: redesign zcomp and rework backends
Date: Sat, 31 Oct 2026 10:58:46 +0800
Message-Id: <20261031025846.3774596-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261025021839.1542805-1-senozhatsky@chromium.org>
References: <20261025021839.1542805-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B767140004
X-Stat-Signature: uzszygjwdzprhgrfpjpzgo649odr9fz8
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793415538-722693
X-HE-Meta: U2FsdGVkX18K7eC7/TFP/Qi8XoL4ZJbm7IfqK9FEM2+qf2eywzFVTbtxnXEaQsGPq55I/9El9bvfzqjG5ligw8voG7zRcVghcvI0IvGgHD6nZWf6bDPS+Aj5TMI0S/elaA33EDmUaOq+yMcdbdB8TcVVQoXu4Wf4kibjeuBZ21XwE3+sym14XNAX4TaiRysdJhCPQhE6yOkyqZRRoAiXcPZiiN9NuIyIQpt8+kTu+eMRCVGn+f23u14bzRyr8qMZgHReutOqcv3lTkHErV0pKSQu+XBIn49I1Gr1zVjeZB2jTwo8ATMHVmS37iYOdZmtQoTtokOE2e/n4oxZU6Ng2yreKz8yNg2UspWSkVSaJlw2GUOms4g58OH0OMua9Az3279ObCGwzLVl+bE87R6Sf3FJ2LkREX72SJhfQKRL7AG0ULSLmoa0fZTTzgTRUxHyT8b/BofXkLwMZj83ZRuizo0z3m/mx3G2wvRD6iSXPAJsyC0Jsksl8ZePij5blqyK/F1PAvoDOmwAEQx3TYaDuU0r4I3se+D1NIJkBm/mHainCYxWnf9azWOcuvvrtwH9oLOuJL3dH9XForliTy3AlwbMlF4mLZK4wteF5qakfabTzXWKIPp+G75dQXk1L40wUlymgDTxY0t4wN9Nxunw1u4GFExdxcehT02tFjpeArvACMEYVJGTD7590NxuHpxbogO66/Ub/dr/dqgzR0MOw9iW4u+zn00tfa9CYZeFTOeVfq4/hC7KqMkyx6SEaGkHl49pek92MV58yTIwEHBgkk4RVzAZ9RZZU7naAttqZPAsEXwKPklAR9d9ApegAgl2XPUVZxXBZ0TrJjFK8U90gMsnHJ48JzYjHhWvBafQhjj2FyEaLbLhJUhUYfhmjLgo2ToeTPlSHGQQqpEp5+odTaQ8wm42523k/bmmmk1y7iRNZENSknb69w+gghZqGt/8pCfsWXQnmhy8XB2Yoon
 uPNpaIts
 hl4iJvK4If4tPuMF0fQ679+WdUdXg0bV5eOam9aHb4gt1vg9sJ3EfRRoArH/lpPGfIOZmY+Fo8yyXxyKruhyakEeZDGFTwBMiwpaDN8rhYstAvsz2d4KQ2/eL+R7mbx9iVguKYsKxFVE0vB+xMbbvEAPIBuXd9J4g4o/X7KfcSY1C8u3T9c9W8sKPefKNmzm3rUcPJQGgvbeZPzZHCsGKF7Bgr1Yb3rTwqMc4fMA15ww3F4PI/5Cwm/TDJb19CBlMc4NgcSnH7uFJhDufGcpBK8Swy3zDg7xzXFYEJ8GbFBNK61nO3IT0PL0zfvq00CqrkhW+R5hG4ySWKVbcDvAO9lK9Hja4fnqS2OsVOc2vRdgz6ql8tu4aBPezYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I reported performance numbers earlier; this is a follow-up focused on
stability.

I ran an 8-hour stress test of this series using the following workload:
16 memcgs each looping a kernel build with tight memory limits to push
anon memory out to the zram swap (zstd), plus continuous CPU hotplug
(~113ms per cycle, 254k cycles). Repeated contained memcg OOM kills kept
the per-CPU streams constantly torn down and re-created under load.

Result: ran to completion, no issues.
  * dmesg clean - no BUG/Oops/stall/lockup/hung task/warning, no zram
    driver messages.
  * zram io_stat: failed_reads=0, failed_writes=0, invalid_io=0 across
    ~3.56 billion operations.
  * All CPUs back online cleanly.

A shorter lz4 (stateless) run was also clean.

Environment: 7.3.0-rc5-mmnew+, x86_64, PREEMPT, 28 CPUs, 8 GB RAM.

For the whole series:
Tested-by: zhangbo56 <zhangbo56@xiaomi.com>

Thanks,
Bo


