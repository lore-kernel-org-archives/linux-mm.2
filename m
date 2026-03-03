Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11543EB3649
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 01:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D7846B00DF; Mon,  2 Mar 2026 20:00:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582106B00E3; Mon,  2 Mar 2026 20:00:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 484656B00E4; Mon,  2 Mar 2026 20:00:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35AFE6B00DF
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:00:44 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD0D01B7E51
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:00:43 +0000 (UTC)
X-FDA: 84502946766.02.052187B
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id 30665A000C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:00:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xiaUxl4N;
	spf=pass (imf15.hostedemail.com: domain of 3uDKmaQ4KCAsuz2oly2tnsl2o3rzzrwp.nzxwty58-xxv6lnv.z2r@flex--jordanrichards.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3uDKmaQ4KCAsuz2oly2tnsl2o3rzzrwp.nzxwty58-xxv6lnv.z2r@flex--jordanrichards.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772499642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zm1LTC1JWmja4CORTzDR8ARPE6yG1MLArG1qV/pvpmI=;
	b=iHfIymplmSndF4D2Cz01q000FI0Q+QAezTO9bMBq4ybEetMjlVba4ZKY4Lqr4P1GM4xCBb
	704FbtHwgR97vz638gwhOPZz+hnNRlrqZ2cdZM0vr3SekKZaCFeN28EDOfNGIfPvO0GyZw
	chAI1hMOgXfQ+BGT/2ndM7DLHqGiisI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772499642; a=rsa-sha256;
	cv=none;
	b=04anMunyNuEv+z4CYYXuT2kRGkRnF2q9HGGCBGaTwZ29hFGnW6/Yv2RqsrtVoNqjizk48i
	Fzhrswe1sGvYI41HQafLmYswkMYGK1lCgz/q8Kd2evmfMJk8He/1XSDmImokGsJFgrmuLr
	Lvw47VratP8fOLYJvZBDnPx297K4ff0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xiaUxl4N;
	spf=pass (imf15.hostedemail.com: domain of 3uDKmaQ4KCAsuz2oly2tnsl2o3rzzrwp.nzxwty58-xxv6lnv.z2r@flex--jordanrichards.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3uDKmaQ4KCAsuz2oly2tnsl2o3rzzrwp.nzxwty58-xxv6lnv.z2r@flex--jordanrichards.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2ba8013a9e3so5016852eec.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 17:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772499641; x=1773104441; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zm1LTC1JWmja4CORTzDR8ARPE6yG1MLArG1qV/pvpmI=;
        b=xiaUxl4Nor2b959hmn6sV6afToGxVy3Mw9T6C8U+XIlrYhzofRtpOg+dKFbTHPx472
         EDyAbhnl5m+/UCVk6OoyETZFEeUol4WTlIwf4pDLUlsmHweheJeMCF9p+XLdBESKzyoG
         dDRVLZfaPnrAbElMmVKLjSf33Wvxh/ievwtRcjE9UHHxVZlZw/+WNY7Q2Yj5rwvC2wfW
         TWojfXfchO6wKJZy4B/lbo7XTiIQhLkKRMqSWm6D18bSYcCd+2t0G9FtXnDXXGI8bf3q
         AHgHEEQyvsG++/oj6SAI2JZM08QOW/CYvDLMFJ+uOmONe4vO68yDQ61WOE9Z+gak5G/N
         04Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772499641; x=1773104441;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zm1LTC1JWmja4CORTzDR8ARPE6yG1MLArG1qV/pvpmI=;
        b=VOoNbMitesWm1+XjUdF87wa66nWhq374/2FcThTEoFML2RieYSZG+bFAevH7zz0eQ2
         Mwp7k1uUYgApjoIVMykxTIbmL4SOTnxjOgXD0Sty6Jes+AARo+N7UFDnWCH6IF8AyEvn
         SUVl3PAvTpHpQd6B8lsHxgQSuvg7Kmrz2RZXoG7UAJwOzu7EYipcfILRUKOdnTqUsrvs
         ZBtBBrLWLbADkogrTcLzDqU2vWzDWNrxLbNOKpcQTlgIpXu2lYRfsYi8m5kPXFH2DVa6
         9biABcrxDrTI2cxHtoPgYi7N1eEs4hHeC/VC+BgNMAHPeMXsrF6j8N/3yjorT7TP/S0h
         A7Jg==
X-Forwarded-Encrypted: i=1; AJvYcCUrGenMqM1C6MaayaWwzF15g51xOaHo0YytbY3LmkkEIzQOkCJXZ6h0cF3BI+vjzQvoU7R71BmxhQ==@kvack.org
X-Gm-Message-State: AOJu0YwpxcuYY5sbuKyOaCsNc+YATwiMVLpKy6/eaJ8Vvi3AGg8VTE7g
	HRCjA4eBTRD1JFia+tbjf5UL1UtxCWyUuT71an5w2dHgY4hKNXSGV+KL8P6y3MlbfM6hyM8sjPf
	DVoPZyxw+Dh5sio4Ialp0i5a/yJsDLFx8AKkZxA==
X-Received: from dlbqc5.prod.google.com ([2002:a05:7023:a85:b0:127:5503:dc9e])
 (user=jordanrichards job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:418c:b0:124:9acd:3c4b with SMTP id a92af1059eb24-1278fd2ad4amr5435794c88.42.1772499640432;
 Mon, 02 Mar 2026 17:00:40 -0800 (PST)
Date: Tue,  3 Mar 2026 01:00:37 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260303010039.2969125-1-jordanrichards@google.com>
Subject: [PATCH v3 0/2] selftests/liveupdate: add end to end test
 infrastructure and scripts
From: Jordan Richards <jordanrichards@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Shuah Khan <shuah@kernel.org>, Willy Tarreau <w@1wt.eu>, 
	"=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?=" <linux@weissschuh.net>
Cc: Jason Miu <jasonmiu@google.com>, David Matlack <dmatlack@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jordan Richards <jordanrichards@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 30665A000C
X-Stat-Signature: xjz35fw9swazowisczxz77w9ec6kpjzx
X-Rspam-User: 
X-HE-Tag: 1772499641-899509
X-HE-Meta: U2FsdGVkX18mq5EAmfuSm9RQ4Wrsgw0Ge+XuvFG99oYUyKqCoI8HvX9MTRJQRw2M12qbpIKcWZk7mRR5V34C/RARQWYTm4UmDkMgHlTcnEtS/kaqhWfypOcTvIQc7LbaGVqlBKWNLp3750W/RVo7Aq1LaiG0RLeXCLoDh9sEqameWZ6Q9Xa6DtnTxy7EbULxhaYPgjQCC0hSlZYd3XrYC6RAhrWNuWa5n3/zpeSI4muQSJaZ7YMlTUqg5jts2Un+/n4pNFIYdmca3k0gwdtz0zurwgWE4dzEviRFchHqt6eo+E4LTSphGidyLTvK45lLiB9NMVCLum/j48TiGoTJbzQVDEmlw0uCrSYKbSNKoD/QXX40ZYq5Sp8xrIdy8T9sZNaktPVvwTpARcewPLK5hDCtvImobLmH4jGlZ+GMt899nUNVjD26FeR8q+nFziEXt1LW35DfJ1NnlmRaoGn/BK1WFLCwvirMMUZwa0zCQUYMgHKVjkdrQXcJ6tGk5lc2QibaCfFn8qSNkwW0JYwqD1Gsi0OK4V+96Fkr3EieuSXY9vaN6x5l/3NdVsbJCb16FOLJ8EH8R/UAvGDCVjq6qQLCVicSk/bw21z1/LpDnkF0Jm3Mh2/a5kgWneV31KceKIIpJ9gMF841gtYoeiKikrjHug8n2BkE659Q/pWJ81fd8b/67ka/OJz++lisisk13SzDcJl4Q4E5uj7RWYIfVaNLWl/x3Hij5sIyIhs6fAMivhe+E98+55EMrT7yQohCMEYR1gFk9ZVQdXykyOmQTsR7AKoI83ZMU1VWR28Vv/oa1Gf6WZBt9S1Z4dN4eismLd0x+0jR6jiSUfpklDLu/EjNkKDysISAKiHADbT2W219WHSqvIkyiRcXEAzPrli0Dj7ESXpCiPWckCK4UgwVzHvZ66orEyhI+5t9EO/zmGyZzH+7tGMeLUHznfdi87Hzq14oqec3ODczx9UGm4x
 U/dpIvnZ
 6ZHhFmUxqHIghQnis1tCNl4WnSTYn4pq7MirmE5JHhCFTv2/RaS/hlCNPkQHOAtoUyRdPe6TM+daPwc9hu4sfyRsmT+ACrw18Kb66qS5aLbxFyjmysN+VmVX4Q9i3aJRoh983TRKiFVZp0P39+ma3+598vOlioQZf9Suu1iaURDK4B8DzOPvsrAPqvfe6h/wRM7lk3oUlHDpcD4XyNbNx8sJEduly1btaPNkrv3nPUek8wGGbQWk/wb/OnJ9bvAIFdDHkRDZIjX4NH0719B9dhON9fxc046PNfmll/NrxU8UROvNXY3hQEA8+eI8e7YyLdKnYaSuOrtwSVqob0A8FeZcoir8T3MPoCMyoJdDSg/RMPKLN2n/MEhqihVm1WgLxj/SUnb62GgdKvxuLiixntHQuka0Idc+02Ge7L1IFHr60tpMXGglmdjNUKB//5jfZn1gl5jet87Buf+cMDTuOg2pua4JKNKq4ABCX8+FRbPmoDcVrLqq+Dbc7STw41T2HFaWkK/4eUyR+IsVwB4CZql5tE4dTDhpOkodaq3R8mwKzR4L6/8cZb7Udvz7y2zxtWbr9VWiM8cM0Sl1aSyInuLcFT+GSDI3QEl+3QMba1SRlHZeimKhpSEK5B3v9i741yTZ/xPoy5O1JrdXc7bAB9Jv7Y/wWcl0Y/L66t6pmqiqlUp6+edYUGDXrAn8al8Lf0vW2g68/iTYuhD880+GQUv1mcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series adds end to end testing infrastructure required to
verify the liveupdate feature, building and running the existing
selftests on supported architectures.

To support executing the selftests as part of an init process, this
patch series also adds ftruncate() to nolibc.

Changelog from v2 [1]:
- Removed unncessary nolibc/sys.h include in luo_test_utils.c
- In ftruncate(), use __NR_ftruncate64 when necessary
- Add ftruncate() test case to selftests/nolibc

[1] https://lore.kernel.org/linux-mm/20260205222329.2419035-1-jordanrichards@google.com/

Jordan Richards (1):
  tools/nolibc: add ftruncate()

Pasha Tatashin (1):
  selftests/liveupdate: add end to end test infrastructure and scripts

 tools/include/nolibc/arch-arm.h               |  11 +
 tools/include/nolibc/arch-mips.h              |  11 +
 tools/include/nolibc/arch-powerpc.h           |  11 +
 tools/include/nolibc/unistd.h                 |  35 +++
 tools/testing/selftests/liveupdate/.gitignore |   1 +
 tools/testing/selftests/liveupdate/config     |   1 +
 .../selftests/liveupdate/config.aarch64       |   2 +
 .../selftests/liveupdate/config.x86_64        |   2 +
 tools/testing/selftests/liveupdate/init.c     | 179 ++++++++++++
 .../testing/selftests/liveupdate/luo_test.sh  | 276 ++++++++++++++++++
 .../selftests/liveupdate/luo_test_utils.c     |  23 +-
 tools/testing/selftests/liveupdate/run.sh     |  63 ++++
 tools/testing/selftests/nolibc/nolibc-test.c  |  51 ++++
 13 files changed, 653 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/liveupdate/config.aarch64
 create mode 100644 tools/testing/selftests/liveupdate/config.x86_64
 create mode 100644 tools/testing/selftests/liveupdate/init.c
 create mode 100755 tools/testing/selftests/liveupdate/luo_test.sh
 create mode 100755 tools/testing/selftests/liveupdate/run.sh


base-commit: c95c8315909f078d16bffa2687346b4c63baf0a1
--
2.53.0.473.g4a7958ca14-goog

