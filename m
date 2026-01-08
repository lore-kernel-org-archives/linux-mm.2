Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9256D1489A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 03:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23E8B6B0005; Wed,  7 Jan 2026 22:17:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2162F6B0093; Wed,  7 Jan 2026 22:17:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13F6A6B0095; Wed,  7 Jan 2026 22:17:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 019E56B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:17:13 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96BE8160591
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:17:13 +0000 (UTC)
X-FDA: 84307335546.24.90B759E
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0034CA0003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:17:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jkJ2AWcg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of sun.jian.kdev@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=sun.jian.kdev@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767842232; a=rsa-sha256;
	cv=none;
	b=tbhQGgNpacX+gjbpIYz1C7/S4xYeajPNhnQ9cB/QILMopD2kp6KCHUCXe1dSS6uTn3WJOp
	8X1FIzoMN4iYzJodK4/Gpn4Sb+3JUuUcIS5TgiihqVvGRBPIGGPVq2l6R8sFZ4OLeE8TmY
	TLYYq7+c5MIb0FAcVSby0++oLpMnvCU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jkJ2AWcg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of sun.jian.kdev@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=sun.jian.kdev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767842232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tltITiw95/9wtf2NIqRzgqZ2v8zq5SZjH8mYyCvye6E=;
	b=X4VAnHM4v4jag3WDTGfV0FHb7UyTO/Y08RlsyHrHPvvMAZQXNr/eSp9Xon4ZQgfln7KRPB
	Tl58gvcBn4dakl3itZCWw16RS+gCnlku1GA7kGau6GZp+HGBslw8CHBSfFDB0W1lxzwnbK
	OfEukS9WO7dBNn5GegkhZbDXNLwAA7g=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a0d6f647e2so30770385ad.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 19:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767842231; x=1768447031; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tltITiw95/9wtf2NIqRzgqZ2v8zq5SZjH8mYyCvye6E=;
        b=jkJ2AWcgIQOvbslkEkIqNyTiUKuUt0zx/XpP8Oq4yoEFwT4gDUuOg7R23qioYcwjVs
         V/LVeuA6E7309fvigIJVFdypiKW9YnrRnhrUetFb0JiXvV6awniVnLhfHL6X73scGO3M
         AxVy1b3D1SuOUS21PZxYjxn9K9Xt/PJmAc1CvQI/oOFSTPyX+/rJ2Av7DkAinPZLtcmx
         eteCJBMy4pIqMNLxZ1teXHHpM0s7A1Mu+oYxh7WEz+b1qTyrWcXfj5xu9NCT5fQPfXty
         +16NYgsOtaYFZBVYtyaWyabO/V9EQk9v21JrNFUgwIkzwGUMUzjbTwqXK5OxX9JRzRcX
         YsfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767842231; x=1768447031;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tltITiw95/9wtf2NIqRzgqZ2v8zq5SZjH8mYyCvye6E=;
        b=v9kdcYZ18uMQFk8g1V1/FNNXjgD6XHnHzK2PDF+MJHoJ4ZXS5Jo2iFZTBT4S1yI2vT
         X3uStnngAmM/bkwwB8tJhx+tAplHcBmKFP0lxbNfDUzP842bOBeQLhtsBmcA/ZAh7iV2
         tulkhG+yYdIYK7na1smcxCb8S1yaqlv5/hu7zXSHvtEwD0PXPce4hAgexWwCoj6954gX
         fVkGVRDLoPrC2vX5cKrw+Rsv3BgqgEoP4dr/SCbpdRLeQQcfdSjBD4f2RvETDDnUMGLJ
         AUvKHjpU8gyNA7HOJ9NP05qK4YbHlENcX3fCG2tH5HlxZ3V2RRuWbzI/MzvMHYTkk7kX
         43yA==
X-Forwarded-Encrypted: i=1; AJvYcCU81sdAh+0Pz34KSKEkpIo1N399/yAA39sOIn1lMv+eBYPeiPe9mNf3XL6M44y2BZhrcDArAE9+Mw==@kvack.org
X-Gm-Message-State: AOJu0YxURIRKVo7rKqUe8VPR0UR3Yv7Du27aeuDrLgYqaX9Xf9QXrPOF
	wwAISpop19XTRTEFL5vI2QSABkgehtNcGWUsRE+HblmbQIiKgq+6XjmW
X-Gm-Gg: AY/fxX5t4aolkuW4QdenMHmjTq3Jt406LNu663Q7i7JzeYmnNBtlCR29XmxXOepdoWG
	OAjrTXpfYM2iCmlAvrMD7dl65EVat9gRs+v5pk2IKWDP6xsRAIhwfVtOImbqPtBrB9mdyObDmva
	KHsNwrgHesqDYBpul6LL8TnCGBD7oASN32ekXQA1QCYnwuF03UWUPSJkGDeewRbivPq+4N1pugM
	orZZWVl0qcalOwukwADo7HvN/zsyktQOdjk9Q5sXKC8mKRunIC5+SdIC1tgwFbyQwbNDZlQ+mjC
	iCD50nKTbsZSUq7T8S25U3DjzpvISa+3JjVV9Xd3ocqbooJDQVmpJ6QA6vqUxtHjBow90st+49j
	0zD7nLNQ9AIQwERnxV8Ps9I+dzSdk1HLhR9CBPe1VVWwqP41bVgyhV/7LUFFZBa+bHe9bMilhz1
	6DmxyLfbwW72ufsdwLBzw4gBQiaFt9hOPINQtzJwiQVWTUORmyJIp/vRX7tU/ScRbmWjhTzlUrX
	6F7k5oEYvs=
X-Google-Smtp-Source: AGHT+IHrccX18hWgZN+cQEN8AOL+ajDQdYrjJ1ODhl4Q40AtMXaDPEaPREbLjSfBXOA87RJKcpynWg==
X-Received: by 2002:a17:903:3c27:b0:2a0:c84f:4124 with SMTP id d9443c01a7336-2a3ee4b4f21mr46877445ad.52.1767842230664;
        Wed, 07 Jan 2026 19:17:10 -0800 (PST)
Received: from u2404-VMware-Virtual-Platform.localdomain ([117.71.53.159])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cb2ea0sm64031255ad.62.2026.01.07.19.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 19:17:10 -0800 (PST)
From: Sun Jian <sun.jian.kdev@gmail.com>
To: Shuah Khan <shuah@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sun Jian <sun.jian.kdev@gmail.com>
Subject: [PATCH] selftests/mm: run_vmtests.sh: fix relative path handling
Date: Thu,  8 Jan 2026 11:16:04 +0800
Message-ID: <20260108031604.12379-1-sun.jian.kdev@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0034CA0003
X-Stat-Signature: dgohnnqkdt9mqmibiqtpg6s851esy3g5
X-Rspam-User: 
X-HE-Tag: 1767842231-302731
X-HE-Meta: U2FsdGVkX1+t6puOzUBKyaAHcd6nPfqwoPMJeGJsYylKEJvbHXnPMl4In/I9XBawqixZSSrIX1ObR7+hpNTWMKHbeeK7y5JAAjmNsb2p17zH+rIbS/JHStiNICpgN1k634TqqEVJjhWIRCHb5zyL3UiPo6Vep0rVWE17guI2MKljgAw18Xq6x/yFaU60CUQAcEJ3TDomSubUvAUYkYOh4Rjdd6qTawH4dZMZh/572SlLrn9Bk0Coo1DN/D0YQf2QBm95gWAutENApvQL+uSsZZL92thERFKGKSq2Be0yPLLDRHAMEZt9hB3BiAMvWfFS4Q+NBrALEhY9l96rKFUP4qRgFODu8tKqiEyRPHuFnM4grIgjaSif8PC5lPePD08rjva2KUseAHgjC/ZsNVDihcOC5BnttCEBYi6q2/nXdi9gkfG6I2a82L3bTCSol93PVr4lOrM6DI7vD2KApT5CUo6vZjbj1g8mJq1HDxeyxPJFnOa/XVXU0TJQnBR8HuOgysuvzD1J2BhDE3PbZpOtq2O/sf4KVakq7GIgY3m3H3iTxw0RbI82bzdeJKI0McX3TBExerDteBvBgNIfqc8XhrXHBSlWcoZo+2fI4laLQlCvJqzPeuNY0Ugjv4ekRk1nk7Ua1bYJ7x0OnFLJPzQPqx9eDkDXD6ufyXVcBlLsCQqZVwV28p+G30wzsA2eA2+D7OCoRDin/E/GOmJXhppBraKTGi/IcNcvIKtBRPOwFOq1/n5Z9Jg0jFt0xUtbM4c2mieKQpDw3SpF0S7U94ZyRgSTVCBilhMAvRfNEv1jAKGPqMgyhL7g9vLbGmkkTujSzVmtS5BPIAT4WmgOyxNyN8m64UCGUcM739ut2HLxSxt05pD+1hix7sXUWziCCjSJVPuilzzD3L4deZ/Q1ShwAlBL41aCbl+llsUibhP8EmCeElPGKqtiaH+AsJGQiSI/18pJWPo4wK7X+Rz2BUd
 rmMJCEnJ
 ZGMPbEnXfxjwlSavowxm2dmHSnXTJ2Ef7+w8rqbh1wIUZcUidwmvMU+MtlQ0L+gvwGUEBovnBoUUfbnYta10Enwf03ZKIIn5MpfLRv5v4Qs1Npix9gdr0d3IihsOh/7czxZAElgcdN/49d1thB8VygvR70uo3K1lqgxq8iPb7a+GiXTHcpDmBO8J27bIlcaDIXq/6QmoVvt2C7sQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

run_vmtests.sh relies on being invoked from its own directory and uses
relative paths to run tests.

Change to the script directory at startup so it can be run from any
working directory without failing.

Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d9173f2312b7..74c33fd07764 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -5,6 +5,10 @@
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
+# Ensure relative paths work regardless of caller's cwd.
+SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
+cd "$SCRIPT_DIR" || exit 1
+
 count_total=0
 count_pass=0
 count_fail=0
-- 
2.43.0


