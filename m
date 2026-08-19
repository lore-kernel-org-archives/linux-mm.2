Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 547DFC5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 12:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F6CB6B0095; Wed, 19 Aug 2026 08:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A7DB6B0098; Wed, 19 Aug 2026 08:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BD546B009B; Wed, 19 Aug 2026 08:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA80E6B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:17:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46B5A1A0590
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:17:34 +0000 (UTC)
X-FDA: 85117919628.21.9C93F07
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 89923A0013
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:17:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lRIjn/JQ";
	spf=pass (imf15.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787141852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ky3eaerp2FIi8m89t9kDf7IwmRQ42625cuWkd+thIcA=;
	b=BZVDgxe6B0VwCt9Zzw9tbWt7lGGKylxRyqI7vT6wLK7Fw5y0Fc9PGgLiYEEPtyFWOU1GDG
	4SNLcAir7nyVPnO1X3BC9LYOvb5nrqt8CCP4s5dpKXt5Qz+iswOtueEW9mT4X7gNJZUI2i
	x2Yb8pkUQcK1l7n8+TNopfC398/y0DI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lRIjn/JQ";
	spf=pass (imf15.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787141852;
	b=6SvynNWe19VTWO2pmDPhQZ7PkB6yKBe/ULZKI80UDN4i3zujxtxijWOF+1eN/3JDBr/wrC
	GWOpW9DWIe5l7XBlil/rWN54MQdL/4XP0A2/stkmardPBpMCPOqh54hJDmkJq4Z/CU3w21
	n3+jC+WzYLmp5peN/h6bSfu2Km9TY2w=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38e041ea211so1033095a91.0
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787141851; x=1787746651; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ky3eaerp2FIi8m89t9kDf7IwmRQ42625cuWkd+thIcA=;
        b=lRIjn/JQwfAqwFs1B9Tc0fx3ZgM6/kmbMBUuBURcrs2ijozVd8q3tOVSxxVVSanz01
         0/eS5113BdP/Pjf0KuylHZszMSztXtyjCy6KyKLhP/Pgyopz+v1kEFY8G0dXfXTblgkf
         KuhoUzp1PNhLmNT1uMyQWqiP0ylszRSieiH+WmlUh2a7KesFKTedBZ8PuJYKWuI+8FGv
         Au2U3C7IUidMBdjp5afmMa6uXxA0YBu1Yfnk2oueXKabNT/nbq4IAQl7d0zEUzdDt3Ky
         fNCA8ikDvjYuI0Z/8RssCsu9xuDQ2z2fgldmXXFgnugbFOkva0LjjRKc+OnYaDgMZZ/S
         AduQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787141851; x=1787746651;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ky3eaerp2FIi8m89t9kDf7IwmRQ42625cuWkd+thIcA=;
        b=BYt+dexsYm7ziE+UwwwxuXIe9VRTVkp/GIQ6vbzAZKbL+hChPej0pDYwRHUcplJ1UJ
         V++5XVsHBTCB5T5Gmxhrag8c2c4ekWdDAH/Rm7HzZF/9s0s26bSwz/1gJbLNlApUkdPI
         UoFHEJsBNS0GTbtCw6rhvoydsSInB2Yk8A+lFXSz8Aag4ky7MCBvwFCYe2nevbKesj6C
         mKRYgC2rfTLgo2hGuw3RPSA8y/5BCVXAX6eyRliAol/k9Lx3LCQyUbWz1JD0Xa4sJvay
         Hpa2zL7HzYHZ0+1gpa4mxnlPY9h0Dl7Ph0NGvjVV8fuleNDrYi/4y/uWSIR5vWpJQeyN
         UM8A==
X-Forwarded-Encrypted: i=1; AHgh+RroTFhrfM+oytZXwORg1OPhztDaJg4OgQxqt3ZJmGW9M8WEZMFy716ur/F8im1gsAndfuvioY4ivw==@kvack.org
X-Gm-Message-State: AFuF++nwCGnbEMFo1O5UDjpKyp+Zxmla4puZFZ/o3vIWYNu4UNeSgP1x
	KLIrmeBgeyxSN7b+PKwH6cfrJIUQu7GsUMeLJORNiPmNdCM+B5gqHjuK
X-Gm-Gg: AR+sD12XWWg2VErQSYJMvJ31+gXkFZvaqNP/yuFpaUw2odGix4+iUDnlmaEt77MnPDD
	QysDDwgqvCsA/8SXM61q5gUvPa0hH/++mJzqpq8c0JvIuMBjF40finM7fQIzqfbCHB0Q6+zwy8V
	+JFl9dAMVrT+CLcy6fhQnw0+bCkhQLpKyNzBAohoJiTxupcLQFDXtFlLLSpMnh+qMmdKTqbQzKg
	3OGLru+YC3Xw8ze2lM00F4ykHVLZcJuf9ANQ5AVSMV747yNs7sWZuACfKe2CP3NErQTh0lfWH8V
	e8yXaWXx3SmQcBgElAO8/uCa6UaZRtPz963IfKcKLsf8xtrnWnUhlOB6uTpyL+QrnQCtM8WtidJ
	J5KI1TwSel1b3V3x415MCPPvJzWf5/Am5JPOn/BsvpyD1nmUO6Eh0y4mBSSDUSRr2WKEaLV3wE4
	k8Wqtw0rZYG817Ya+IEL+D7Wcr2cItoAutYKsaQ5OtlBwj4i6efz68j4j/kJh+dLukTCU=
X-Received: by 2002:a17:90b:4d81:b0:37d:f206:a2ac with SMTP id 98e67ed59e1d1-39580a7c832mr8254013a91.7.1787141850868;
        Wed, 19 Aug 2026 05:17:30 -0700 (PDT)
Received: from Anshuman ([103.106.200.63])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1416ad6060asm12607295c88.6.2026.08.19.05.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 05:17:30 -0700 (PDT)
From: Anshuman <anshumantewari123@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Anshuman <anshumantewari123@gmail.com>
Subject: [PATCH] selftests/mm: check stat() return value in khugepaged get_finfo()
Date: Wed, 19 Aug 2026 17:44:26 +0530
Message-ID: <20260819121426.49500-1-anshumantewari123@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rniom59iufnpwqiwk7qqd61kcrb36ih4
X-Rspamd-Queue-Id: 89923A0013
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787141852-562762
X-HE-Meta: U2FsdGVkX1+5Upqnyjh2yXZFDjx22VzTks4S96pMtfXFH83utCbbduPKIIc7cnfH7lmNa0zwBeeLBRDrYeubygPsjMdGl1XwSI7wE8/xDW0OXnPL7CtWdNoVwrC4z5OHeVVfI/4o19/TJnFgClG6EBTBuXsT8aw+EPPlFYgPLcskhFv4EVdY1VCGQdlaz+D98/xXyX2JKR6wuWDJbmSA6seTaewsVCpM/zue+j8s8prnA0N5Po2LkjmVoT1qXjYzrF9AfzdhuKiPVmEobFWwtmvZA6Y4gSDMWh0QepOALaOas8CfIoqX5iuDR9BW9wewPCm4JR6EJLMmlEDIExei4aIvWh+DY0JtdOjDQNO2V/heFUqx4pj3aLSVkUe87t1EVAnNObIwrQy1afam1vl+JdsdQIe8LY4Bue4qXBQZcBMckZAFbFaFiKD2/6ecOi+GOGxr918Mw1vW9zCsjuzDcr9zV2y9uLYkhdD6jf0I9rIVLxpOWKB0U7qXuCi0DAlqvBqE92BPmzPet9w4SX9K+d5pzowDMEs5EmxjYgodJdErqZF0ESjdm+Yecu0OtZd45lEUqe2EFNnjC/oHsft3LnT2yXYmRqDO/9ycHkkJ6GMCvF3LekfqloGWGHB5mcL/Fx2z5we8HGQ235fpLIMRrjddorckbHilRyxpdQ5WwEx5yb2dtWhxldOCl7ptBPRMIfJIe0E2MpEuGqBEVF50rAceIX/DK9TgtevMXXqL8am/7gk28APdN/ULQrr+CQHv8HO60L9I+6UFdRM+ty0WfiS2uWKo0HC/BZjn5EFcqaP5n4zwKf9UI1+qz6lgFnTxMG/QXrH64ShVl6CT4+u0Bl9fQ2ElYW6kA4c1hUC1xeDGumF3lR7ueEbt41vGEXB8+jJPi4caU5pqak80rB99FlhwyJVx+1fCe28/6AyPZrrOrLQ0dT8Vxu894xihJs7JypAjE4rtq3nr3V29FF6
 vbJ31Udq
 N2UDRSp/CtAbP8ElPWJVedkhc7KyR/9wFGIRXi/zHnXHXB4fGNJXITGQUhB1qOH1J9iABLLHEM2ReDgCx8GD0PwdjH2cyjIX8sbXcz4OAQe2OKqNY7oTpvnVkPSCz/E9BJ3wVAp/6HmewejtAp/9fKDSuAajK2qtH6Kumr61bixuN6G9eNXbrdA95HRPLqKXKH4EhgB+zrUIpsvpWUBkkon5I3tHlIEYNPh3X25POhdr4q5KbUiu+/CXUJfY82AMoaLdO+6VQUH2xykt6ggAdy1gRuV+TLIF1pzAPqatHSh2FihrNQaRyBS/CTZyY78Xfj+dnLfJSdpsRynti/dyu2/kwKIz5XUOPLN8nvDGBP9bCaa48KtY2C0x6ZxGnkdfaN8xICt1H1avrnaFjg9gatueE/dHboDZNSFXuFtMiYJfii+2OC3cDPkmKsP+Sn8rpHoFaKS5ZCIsVlN31YaNe9cB62Vtoc8azZAeyY74nJofgHYE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_finfo() calls stat() to get metadata about the target directory,
but never checks the return value. On failure, stat() returns -1 and
leaves path_stat unmodified, so path_stat.st_mode may contain
uninitialized stack data.

The code then checks S_ISDIR(path_stat.st_mode) against this
potentially garbage value. This can produce a misleading "Not a
directory" error when the real problem is a nonexistent or
inaccessible path, or, in the worst case, the check could pass by
chance on garbage data and let the function continue using an
invalid path_stat for the rest of its logic.

Check the return value and fail with a clear error message if
stat() fails, matching the error-handling style already used for
statfs() and read_file() later in the same function.

Signed-off-by: Anshuman <anshumantewari123@gmail.com>
---
 tools/testing/selftests/mm/khugepaged.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 10e8dedcb..2240a9b4f 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -121,7 +121,8 @@ static void get_finfo(const char *dir)
 	char *str, *end;
 
 	finfo.dir = dir;
-	stat(finfo.dir, &path_stat);
+	if (stat(finfo.dir, &path_stat))
+		ksft_exit_fail_perror("stat()");
 	if (!S_ISDIR(path_stat.st_mode))
 		ksft_exit_fail_msg("%s: Not a directory (%s)\n", __func__, finfo.dir);
 	if (snprintf(finfo.path, sizeof(finfo.path), "%s/" TEST_FILE,
-- 
2.55.0


