Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36DF3D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 09:41:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24FA46B0005; Mon,  8 Dec 2025 04:41:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2008B6B0007; Mon,  8 Dec 2025 04:41:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1168C6B0008; Mon,  8 Dec 2025 04:41:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F3B726B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:41:23 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 779FAC0A50
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:41:23 +0000 (UTC)
X-FDA: 84195810846.21.F77724B
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id A7C40C0003
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:41:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cAK9S6Te;
	spf=pass (imf22.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765186881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=E2IsRlHfOxoQ25VAxxnSZ58QOHjCvp9Xb/KmFYxJM9w=;
	b=s64ynkS1f80oI8TpzGOMpaNtBL4pCpILGTm3OHmMe4cgjTjecInqe2ycGr8ul60SV35XMt
	Mis+47WAP8K628a2ACvEENqN6rdLQnYRKGtWwFkXuBtKrejekBMHmIm8qmoknCdEYJew0A
	833mL4lw89cbuVY5xEmZG7jqsSPhCE8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765186881; a=rsa-sha256;
	cv=none;
	b=f4smhTZEZqcICty+YD3lTpcwemw4g8AccjG5o+l4hcIw2VX7DzPQVSbB8m2t8Ebe5W+ZJx
	TGXbaYHowOLsqVsP0zJEuisqEmSrXT6hdnX160reiaPr+JDTjY5sfFHDEouvazAxGc5FSM
	QroFhzX3942iHIcDEAv7PQ8tSWSumBc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cAK9S6Te;
	spf=pass (imf22.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7b89c1ce9easo4804569b3a.2
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 01:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765186880; x=1765791680; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E2IsRlHfOxoQ25VAxxnSZ58QOHjCvp9Xb/KmFYxJM9w=;
        b=cAK9S6TevxNlATFWxC4AzLu8vdvbesiU/1v+rOA5mIs7b6Ide3+b7PxfhmonqbMBXD
         X6S1IRfDeJQClGA9MZVbTuYqy4h6vvpIppmYILEkALlIkQaBqAsWy96E5B8hn3ezHDIB
         Ly0vLf+rZJ9xUbMqfu9U2FWbOn8QfGzazxGSApNUHwfgqLI+U0ffbR/WK3spgOW2hvpV
         ypEN4QMQQpwprF9ubG+kx+1aMR+Q5cxc8c7AKHyJTdB12iiIazxn4xiqo9vDooPXoXOZ
         ScJ2aD/ZiPBBZi1laJ/sO8iAV/eeYHS55DDfkUiboOkOWQbqgOzyG/TpS0SMPfkjO9Gk
         QOlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765186880; x=1765791680;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E2IsRlHfOxoQ25VAxxnSZ58QOHjCvp9Xb/KmFYxJM9w=;
        b=XObscdrEx+YuxkHk9e3KoScpcDrsgx1+aK4ZZ6EzQ9nW9zHNdyFNgpZwlqF+14+BMm
         bR09Yzn6CfLHj5/JMf6FP0dBTe3XXQjG3tXDXTn9eFx1yKki5vKMXotFBY5z64VtJgKx
         8yNblbugsP8kPeHaxe0hfglBoaXHHf7FT6+zZeyo+0GFns4QseeGm9VTiIxhCJHhd5xD
         sKwXD0UC0UACCRWmf2fZUFN1qLaIPx8Uan5bcCCq7ZCRWzwV+puckYv2CyDunX6scGmF
         xO+rwc4gb2Q9P9p7DZyGrUrHJyqTPefevC84ULwpDQ9ceFjOsqBQI2KEDeW9PiYYL9HO
         rIbA==
X-Forwarded-Encrypted: i=1; AJvYcCU/TGzFYRpB6xcqAiBwRZiGFUUptmU8nJspB6YjIIQz4/z7r+axjuRpavDgoIrvXjL/AlkpB0Dnaw==@kvack.org
X-Gm-Message-State: AOJu0YyRlftUNd9ryCvQBKLrBMiGWnpxaNF8V9Bn6I0xdmjf2v7QCk+e
	NSSy7Re2VsHj0EihqFIJ9bfSK8MVC6/heqKXQS7uJLbSe2d5jIjUu8P6
X-Gm-Gg: ASbGncs4mi/XyqI8n1AtKwtrqE+XpIsFHWjcmga358IMVuPfr2a+3vn0ct2Ti/8dfIS
	s41bShhKppykC3V+Ro0Eb4Y3Y8SlWez3n3vDQ7SpsJ8SmzAR46Z7d428Z+eM3kkVSsSkLB/w/nL
	gysD+ZQoR8eCvqmrBq5EQFk5hP0LD3eRwlx6gMDmKQBuK0OcY8pszTbFYM5+sr7KlRcj9A+YFYn
	qai644xWAAOYjEscPXa+dQtBwwrx/5KEc3OAjw2rYdtOUXHXpYxbDEN6YQb3EZhS9NzdI2DB3xx
	ZaGPjj1hF336X9Jt2nquGdkrJ+SXsQnj3Cqvw/KZlsptGp0mcYywt4usj9gEVzq8o32BbJS3/TG
	VEAzHASeXHh4DztcQPj/ahwUjqe7d/ez9e6XF6CpgUTkcJn4+Yqo5pMaZBpUBo5XHmC4TTWcBE+
	s9RAAD4Rc0bY10hOQelbsdqWHm
X-Google-Smtp-Source: AGHT+IEQSCv8PNnm1RLVVc473IhmbBhZy75uxF7k2QOy+9J7r7W1JX8p/WGoA+AAm/hEBAShqrmVsA==
X-Received: by 2002:a05:6a20:ed06:10b0:366:19e6:5089 with SMTP id adf61e73a8af0-36619e65142mr4333122637.9.1765186880316;
        Mon, 08 Dec 2025 01:41:20 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:e251:d9f:c2ef:caf4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf6a36bbc60sm11675279a12.36.2025.12.08.01.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Dec 2025 01:41:19 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akinobu.mita@gmail.com
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com
Subject: [PATCH 0/2] mm: fix oom-killer not being invoked when demotion is enabled
Date: Mon,  8 Dec 2025 18:40:26 +0900
Message-ID: <20251208094028.214949-1-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A7C40C0003
X-Stat-Signature: 8tzyg18ks3wmbtuj5i93bribqceepwrm
X-Rspam-User: 
X-HE-Tag: 1765186881-387748
X-HE-Meta: U2FsdGVkX18wiFfEAoyX6jZScY2WiiyOlf1NUX6cUh+hqEd9VBM4zy4GDug3A6rRP4iIzBSmKJhIQljLzF2iJbuPUyQwYxcXhpnYMhoLV8wv9nb0xMnQIoDuVotWdFMqn5Z51uR7slufC3S5oW2AWwI9wyiDfINjOpe+6XORQcaMxn4CiulCmGou1epVtuN6Vb5h69Eno4JaonslvVKCd/EFM59dqOqJrhyjX4fhyHzM5Tflw9S+nHl+mq9TkmcBJKIaMX23lRjOPeIBhVjspmiuQY/K0Rpd1LxkxrVHXmq6MGbcpZH45DADlpmzrkVa5svFCAjRJ5XUhDi86SRe2j6gLnJ0QJH1dpmA2i/1TcOZs/mlVoxGm4RqBuqyp8x9wIRwUvB7fYsx1sfNCff5WSuXatj+2SwVE0O8w6B03iA2IIHbFcY0dcMx+Nl6q7FPfL/XG028cZSVFn1JCTG8OYwYbX4hvaGH9ldv2zLnK9FOtHTGapC3aevOhlOPWCAWre5yXEEhdTzBveOtS9PZ2Dx5x+wYSmgnDi2qQIPy6UPeJeP5OHP5WYziIx5QidLKOLqQJTBG/bx3TnP4e6bI8M6xK1DVe6+jorwNGse2eou73fIpyoSOmMLXmW88vTaYILvQcAhsb9O+m7t/wikhB/9R3BHjz81RRzOSrKzo/aq8kS3VzZqFb5O1gzUFYwBb0c5xjEoXzOfyxD/z+4VOQwM8xWFM+GLMnIOktgV8WAbdZv9KnUom30vQ9e6zGbrZgMDZIWgqrRB+MTXPvwBPkoIQMHBfmxDMvD8YWXYMaBU6lz87byA64YE20bEPAtmtYGIXjRJyTVEy6g7oHCM0vtvWid/1JbrhxcOzb4H2H49YD3D8hAGDFooZ7DFh1RvMz85OWdj0nrNaQeubM/BQbLGuk49ZR6A5zISdHIEeOeCf8w5S345/bjPXu7E1u68GqaKEEzgG0dr3pxQIV6+
 2MrSGJ79
 3DikItYdWHK2UBs+RMBy/kJm/KWXBERABfZKewiOkkP01dPTGhrDapv/GdfVONGJeGTFlHkAfV5OLj0r5CvH1RZB+ODhAI8Cl83978VGvQcxln2jJuK4jM8bQzyQlUMHjb9QA2ouHW0DBp2x5rPk9QOopP9hSUYpTPNd49M4bgD3kK/e++APSsdIsRerba6rrlOgKHkTUdo4Q/CNviV6/USKimK68AqLExCxy+5QgnZ6WZUggEQlas7ymHvR/UmBnbiV/A3tXKWJVZKaL3S6SNj2uNnpuoVi+SrMatPtpVW4SsYeYcDQT7XVBPHkSm1R5He7UG5/Tep+bQvsbOeioJbJQ/hjAvieILOaYL4fb47s6dlJULCmmAvNsEiIYsX0om3OxVtFudsp7G9fGMNojUJU26UCIegKmu9CxOEObwmkjRatHyqYqxowEN5Tt9nXAIID9PLD3wgPgRW4NMCpag9KOKkjNe3MLiVjbZglUSzFRdICJ9e7ofM2QP/mJ1txcJ231TOaNUWcrcJgeroDl3ZtaluMZbPlSabWFE9ygDuP+Q0A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On systems with multiple memory-tiers consisting of DRAM and CXL memory,
the OOM killer is not invoked properly.

This patchset includes a fix for the issue and an enhancement that makes
the issue reproducible with numa emulation.

Link: https://lore.kernel.org/lkml/20251022135735.246203-1-akinobu.mita@gmail.com/

Akinobu Mita (2):
  mm: memory-tiers, numa_emu: enable to create memory tiers using fake
    numa nodes
  mm/vmscan: don't demote if there is not enough free memory in the
    lower memory tier

 mm/numa_emulation.c | 26 ++++++++++++++++++++++++++
 mm/vmscan.c         | 15 ++++++++++++++-
 2 files changed, 40 insertions(+), 1 deletion(-)

-- 
2.43.0


