Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A720CA5FFC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 06:17:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163926B0098; Tue,  6 Oct 2026 02:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 141346B0099; Tue,  6 Oct 2026 02:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 078A16B009B; Tue,  6 Oct 2026 02:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D92646B0098
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 02:17:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 579B01C2489
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:17:16 +0000 (UTC)
X-FDA: 85291194072.14.6DBFC52
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8F21380005
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:17:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WRf8nwbF;
	spf=pass (imf30.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791267434;
	b=OFRfPGNROvENU40ZiLg0bJ0Ta3OE8s1nS7UyN+r1dzO50yDYC422Ieo24TPt3DDPyWd+md
	f+M/sdnRkcgLm75g9xo0YOY12nwo78KK5ROvVM8yLD62ghT+9a8mN071UwMQ9IXMIzbOWq
	mnUYy8Q58lyuNZW3//Su6pKvhGH4Yjw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WRf8nwbF;
	spf=pass (imf30.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791267434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3XGWdEYbUJd8tcJmO7sHix7Djo1stlaazK2dWhUeaRg=;
	b=fg3jPuo9bHUuZKIA7ng0trScHKpMNfzZ9uhIg+LORmEg+L/qTslNj7iX9cCkoXbHTyxVAb
	LWwSrrnQ+bxc9fk1NFfPqX4weEAeGW5vXhC6OpPJIZnBvmyQVYqMIzYvqeaAyAeqtOA8CE
	QIBk6fri7DkJK9b8KvcHnPs83z9RGhs=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc1cb472b76so91498a12.0
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 23:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791267433; x=1791872233; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3XGWdEYbUJd8tcJmO7sHix7Djo1stlaazK2dWhUeaRg=;
        b=WRf8nwbFw3Yjlus+kMkxtG+0BylStE9q5AM+CRza+NVwcU6iEhMALEXoy76UqrJIAm
         s3uAY0Bdv7JQeeNAPDlW7wSaTH6vm7nWYM/cF9rS/Z0nxy1vKE1ULAfkVcl5QT1LoadD
         TLDFAR+kilQsyHL7mi4MQJSQLKNFazpDoqo09kHaXjWg4NJbtBTAqJ2Ub/SpmzgwzSXt
         bVBx7p0xmZ6llvQ3VUT/zTSxRkhgEFtZ4y8SfsTUl2qdW0jgxShrerXU4UokWYbZaPJs
         v8jJVXYiofVG/GkBr0cL6n+04ug9zYq5hHTzS0F+CBZwwPjptZLov4CMAg2SjFor+NDW
         0kZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791267433; x=1791872233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3XGWdEYbUJd8tcJmO7sHix7Djo1stlaazK2dWhUeaRg=;
        b=uQn/jkR3QkucLVLgTIkm91lcccYU6lTKkvEzO9IZKZz7Ium+N0vK5QMUEV1EbcCx6+
         nzfuWIbV/VVRvINHiHMEeJ5c+vLtSSBIr0DI4df5vEUovf4KXKa/ECtmaPAVvpWvJWfz
         aG6HIa+FOFEg8I/X+IoDtNGyDMqQkA8+OFfUNVcozTrn/3QgOrQDfZIi2Q8msLPq6U8t
         0UQtlc84oBCOGR8Uk2yJFH9TSYqU2bI4w6M0F6wl5cE2KcmtlTElHd4P5CDwbxSGC/3v
         fX/z6ssFbqPyPk5SBASS+H9S44npjAspQpiTy+hDCZse0tSF9icWNHuvZvf/k9BLtOmx
         zZxg==
X-Forwarded-Encrypted: i=1; AKwUvByR+wxEii7xG0ySrfiy4njRTLKY9spfjIBf0mI5ry3D+rRtBiEL05w+sBo+G0hkdJXSeT86ximWkg==@kvack.org
X-Gm-Message-State: AFq9FYLi32HUPqA66pNKOavY10V2g/4cF7eEQ4coGj4s8wySaiUPRtma
	y+u35xh12M6anJvijxe9ukqm/k087h7HhW79aO0jNK4F6/wue3Q2j97T
X-Gm-Gg: AYBFou3zPtk/8AwVN7AsSQQxEh8XBNRu9W9UhpvRjoXgs/VYz0usIbSPh8MNOo4jiOD
	HQTHcbCejel7FD5tNYQmRCg2RywumyjyvPLYXuvU2RzoGTD/ss6ijroNhYc5SAyyZS57A4UUG9J
	sSMaTKqIeZJP+ru65fe3LiSxMJxOKLDNbeDQD+iYtJfgau1Ef4g4vBvcerLB8Ssd8fE6KpxFRir
	7OqPVT7ZQhE74O6+jEVcHT300Q7QJGb7ZQihku1x1sHZU9phSKYoD6FblT1FKWDAP+PhieY2GUs
	D5UhkZfJq+Wy7bFNFq7GUfPCIyDeBKmC0L6/gtag3EE6/NKENMLS09mMHg1NepyiJqtPPi9oePZ
	RKXxoGER01XiM6UgbZoGscJH1X2Dyd2OX5Sa0soVw89eZ/8tbpZf0SyrJXvqjtq3LNcysW+XObQ
	xuRfqJHHzvP145iPlblweeS2fjhDobUosgkyhtkPrfpKMVU7hiTCaxsiuwhYxXas87LEw71ER9l
	F/BaK5Y74i3vRMp8RVFQaZ15yVDW/4z339cdmzWY3ahihqgXt2sXpCVZKwGEwlNQMyplln6fZOP
	ZUKIbRA0mZVd350emIMwM2fRsYs=
X-Received: by 2002:a17:90b:2e49:b0:3a0:c3d4:f3b2 with SMTP id 98e67ed59e1d1-3a873729daemr295202a91.56.1791267433227;
        Mon, 05 Oct 2026 23:17:13 -0700 (PDT)
Received: from AHUANG12-3ZHH9X.lenovo.com (61-221-208-111.hinet-ip.hinet.net. [61.221.208.111])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8533aba95sm3662789a91.2.2026.10.05.23.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 23:17:12 -0700 (PDT)
From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	ahuang12@lenovo.com,
	"Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Subject: [PATCH 3/3] Docs/admin-guide/mm/damon/usage: Fix incorrect option syntax in perf example
Date: Tue,  6 Oct 2026 14:15:49 +0800
Message-Id: <20261006061549.627-4-adrianhuang0701@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261006061549.627-1-adrianhuang0701@gmail.com>
References: <20261006061549.627-1-adrianhuang0701@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bif45nfr3g9ithb6db383sieffs9pn1d
X-Rspamd-Queue-Id: 8F21380005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791267434-285864
X-HE-Meta: U2FsdGVkX1+zZ4bE92/obNoP2wdKRVZj/WJMzLAr1MWfUz++r2UL9BBKZ4UrvDqOAzxrd+xfUvEH/JnK8qEtTNShFPRJlDn0wv9V+d448mrqdbFEvHDmVmYwF/soyyE00ueAiSMu3gZ0DEC7N/fc3ipBk8s/b8c/zYb2G6JD7PBAytBBczyxwB0hJPuf8mto/obF6yKo1Jf7puUZJaGkOCW1CiGJ9rAUgtzsAdJtpntnLc71jxE4ogB1VtzBQAyvT8/jl8kJrzAF9wMKTlMw+S24Oq/D58kFBV1Mmgkl9sV3WAbqhKvTqY7oMdWtKRz3TWAVgKRu3zYJ02j40GiCTEnHt4pEthetIFc7juA7kSSUgomwvCfcm+h7RnmDV4bJfjiD/UZWFjHaqaBEGLk+CyUbVYqiOum7fTQ6P+oKXTRqzZqf1Zy9rFmte/5crijm8TpcubEkgmXq5synareVqvKzyM/4/pyvCOATpMjsCsFDkXPD2yADBVSR0VO6VCr38+fChOYeF/tDCsoRbadnSgIv7EXewX5e90LqzTBrfoc1fu62vVwCGEI2E79XHEuIhVPmBetxK6eCIuNgzq16ZODjM5DXK8Y2fHrPHYqhMtmTaPusRNRmn0R0I4paSSg/xeiZW9Uk8inlz/lUz37z10+eiIm6yEvF6EJLkG0iizHsymlGntcE8e5Zkp93l+AvtSO3n+VZctCFA3pKf6OvObwE/jcC3klbqRm4rsNtlyJT7Dn2UKpATiSj6xdqzdUkSGbPwuQv4fKbtwr30GKxdQETP9I2enlz1V8ycX5WoAFJsku4HsxFb4xRzqxkPSYCGUdvEv0VimyWhUGibyH4ISpv5wFJdVsq0tyjH6sDQNM+SF71ixY/Ka6dRq+UU/HdE6ihAPAmvVgUpZ6uEke8C//cw/juSRmrTntW7IsiPhEveCHNUtdMxh7v6QB2A8nJKscAE+Q2a4O+IU3+WiK
 WKTYP+iV
 5oATPcznjJ7vwDGiDP2oWI5JBSAnbZqFwANfMn5RDxyWZyi3qGZikcKqQ6dYOFkZp2WbY5cEERWEI/X5RPsjaCWgxyPuoseYVTP/4ABof6IRPnlOBwDGyYccq9ucjyFK3b8D/8Jl/1Js66ejCjCFOpDKuEsDKIMkwsvgOFxHPnoKGVDczftgddamNgM+0djrhvhhSgX728BJuTTnjvXsxz+QyPk9NG/LuzvqSyzIAppDo+8jJyW+f9MuufmFVazzV0yFEJpZz91eiMBWX/cWK6kMehlMJwHRHmS1JOAbmydaL0WmU3YKMxSDjGgHNTDUczGVDN3xotarzbkoXbwQykURc6oCsrLbuwFgZ2y6eopu0Et3h6LMSHQcnbM27lrajzL7BcH7dRGhcRfP2RrDeXS/qhMZNzeH0m+Gi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kill command in the DAMON documentation uses an incorrect
option syntax in the perf example.

Use kill -9 instead of kill 9 to correctly send SIGKILL to
the perf process.

Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
---
 Documentation/admin-guide/mm/damon/usage.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 3d43954c7046..bd687d89ea4c 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -749,7 +749,7 @@ show results using tracepoint supporting tools like ``perf``.  For example::
     # echo on > kdamonds/0/state
     # perf record -e damon:damon_aggregated &
     # sleep 5
-    # kill 9 $(pidof perf)
+    # kill -9 $(pidof perf)
     # echo off > kdamonds/0/state
     # perf script
     kdamond.0 46568 [027] 79357.842179: damon:damon_aggregated: target_id=0 nr_regions=11 122509119488-135708762112: 0 864
-- 
2.43.0


