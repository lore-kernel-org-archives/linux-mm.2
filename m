Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D543D116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 07:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F6446B0007; Fri, 28 Nov 2025 02:01:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CDDA6B000D; Fri, 28 Nov 2025 02:01:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3CA6B0010; Fri, 28 Nov 2025 02:01:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C93A6B0007
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:01:59 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EEFB9B990C
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:01:58 +0000 (UTC)
X-FDA: 84159121116.26.E52429B
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id 221F08000F
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:01:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NbKMQaB5;
	spf=pass (imf30.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764313317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1xQ33iNWqJtDWF6gui8YVsjkOhMscwlURztQqJu0XSw=;
	b=zUgmilRxljneuQPKG/IavKq0b3pIxPwNC4WvOSg9gc95/7b3qW+IXOpZ8WfZDpNgCZHBC1
	El8uxTs8xe5ZPDoM0gjoNaeWn3A5CMmdO93pPH+HYsGCdcMviPsXIJ7ehlecCzDt3gpY65
	b0oQCpIeT6Wb2UyRuxNX8QUQQZ4vwD0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764313317; a=rsa-sha256;
	cv=none;
	b=ymUS0Ar794PcylnQNJWloisH3gaiCGa5yMZ1aVAsg6AS+XpjZHV5GLPcaO9oMfJ0tDCdSP
	Rf7uZX1sRHJN+9urpua3Mj+BMmjGBlpOIXjIr4DkQdgyDQ+31U9ydMrUOBO2A45+TUYcie
	vN7gbXC331p267g5+xKDaA2HX5SLkmU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NbKMQaB5;
	spf=pass (imf30.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7a9cdf62d31so2036282b3a.3
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764313316; x=1764918116; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1xQ33iNWqJtDWF6gui8YVsjkOhMscwlURztQqJu0XSw=;
        b=NbKMQaB5IwMXXcFLisaAgNv/vDiDe5ttQp1FmH+VhDszDZW3gcMUcQpYNBDLryh3Yz
         zc92MqcbJu5Yo8yadx6Y8V4+0nph5JMIwmAhab6PYcrq2AAzJ5dzVtzKpbrFY4ieudMa
         JXCLc4GTLdSLHM27d8exo9z/bREM76Y3Qg+XdovwVIWCoMG0tG9V8z2XMXNn/YVk3bgL
         ayH8+E/2W2VqDbooKkekA8/k2R3Xp64JfxjE8by8lda4SObjHC7qQEfksyxLTpwpTdOa
         EyhxvyIPbhPnmpyBrYvocAeAKjoPjBzXto3ZeUTCTNyV+mb3vFBUVfZ0lL+I6VBaqql0
         7MFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764313316; x=1764918116;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1xQ33iNWqJtDWF6gui8YVsjkOhMscwlURztQqJu0XSw=;
        b=E96FYzpaJ2YspYB/EAE0c/hfDBNTZofhpM7GPst6R9abW7OYI7cF5CDKMjXaEMls53
         EgPIuJkVi3BtsgWXLVS+IQBtB0gP7YuSCuhWSFVSffVdsijl9hVLLF696kMkbaisNN8D
         Y5CWUViJ14zP5V5f97QnQhav84zgLnwvVG1QfeREfgHRiYH1WZh/3PY8sz2Xu96NiB/h
         UCiSWK6jFvv+yWmtC3H+j7b+MYVlJJzq69IBiPmoCsptemRaqTPaUSyWvqwh98FXnTMw
         dtZGUPTqq28MXCcnz/+k3mcsOGomEz97JshgHmEPTyc9t67hmUBVXC8OuMuhHRnIGzZv
         freA==
X-Forwarded-Encrypted: i=1; AJvYcCUQrQDdXVNys0FB7N/a4q6W9dDUm2THsRT141QRF8Dpy8vsgZUHhN2ZXU+UT5mfIGUBsaG5PktYHw==@kvack.org
X-Gm-Message-State: AOJu0YyW2bVYmhB/hMsUP+8bE0hrOAisYglnr1f0+2L5vetkE26h/wAK
	SsRqIUu5cWpAKYSzL8WPyBR8JlAaUPa8e9oIb3W+xfIAMLMdfkzu3tYX
X-Gm-Gg: ASbGncsTvM+GfJ/ZDiMeS2sVBJCNhjL4pKBShHKIM3TE42iHOvtZs+QfwfRnJVeJtpA
	VXJzPE6BSiBoW/HHx+qz7035A1IGhity0ovfg7hD3X1DufCzdB0aCPFPz4DALmXasbx5XiiKi3h
	Wr1T5xla/fClyHccWM9FF0o4FWwOg2659vnvZjkgH/wfzaBDmzGth6SrPXADayGgPjM9uYCo66z
	g/n8v/Bs4w3bGaiIihqISiC2bPAOY4ATW3hFHj06XeK6hKiaCYyEPG3nBWzCMctg95HBu9DXMia
	VZjq7fLEl2XMgKURnTD0w/boXXP/UlX+Z/vrZUBbrdisPsmpjRXH5cwKmoDj5nb7XHlNe8e27Pz
	91RSCY3WfYjApqwSijw5FgyOVm4bkP2hCwsNT7cCdkdYtPmvehTxsoezGgVO0qp0PS2veUrQDpb
	Pet/CpHhy1xdAvpURZpdzXyDVxXA==
X-Google-Smtp-Source: AGHT+IGbgbKSq2dmNuZROmlRe8dxMskDACp6gbpsYEwCSnM4PphkjR88rvQI8FBy/Fb+yw9DX5US4w==
X-Received: by 2002:a05:6a20:12c2:b0:341:5d9f:8007 with SMTP id adf61e73a8af0-3614eea27aamr30557168637.57.1764313315619;
        Thu, 27 Nov 2025 23:01:55 -0800 (PST)
Received: from chandna.localdomain ([106.222.232.43])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d1516f6970sm3864693b3a.17.2025.11.27.23.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 23:01:54 -0800 (PST)
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	zhengqi.arch@bytedance.com,
	Liam.Howlett@oracle.com,
	weixugc@google.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: david@kernel.org,
	Sahil Chandna <chandna.sahil@gmail.com>
Subject: [PATCH v4 0/3] mm: Coccinelle-driven cleanups across memory management code 
Date: Fri, 28 Nov 2025 12:31:41 +0530
Message-ID: <cover.1764312627.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 221F08000F
X-Stat-Signature: ps74uzr1mbo9onuuo7xj9hp9bgzkp3d6
X-HE-Tag: 1764313316-951172
X-HE-Meta: U2FsdGVkX1/0+gEWgb38zhlueOOKiTyMdRp1LL83miqI8iumnglcTKE9fDqmajjKcMt37/nSEbXRoXa0kqCpi5CbDmCXAkeu5RUrbDin+qNiWEhVBiGtDT/Lx662npVgluESIPo0TTiDtUa9HOfeGQadl6NywMcU3kb0f5sonoa4L3aX+u61J/xcIQh5GUAd55JXBxVpfJn86OJcltZZe9VEzwKuZa3Px3PloX0GOazxoKdftL5G75jJIutK3G95jYGWsjR94O+zEtO4WoYkTjNoaKLBS3fo2oIM+KmxcuFEYagoXua5MDhY+54QICMYrcMaALitf7J5/euwW5ONqRGFlR3GrqaBOT2w674g0ay3CbOkdW8nEMoIM13Ep8AuJ4dqBgLDRgqw13DGJ3yaecfgC7keqFhBf+VKS6BtZjhHAGB82Y1LqDwaeHcmRwahnF6CPvJ02zttxrmLJhuRJT3MOUvSJ7SvdyIg4P8p4K354Ux6s/WxQJbS0S6kVm8440Fh91GHgLDYWE1nf8hO2Vlpfn41OCzfh8WyeLRp0EUH1ucwm6RnUPrvj+kBCNwRi/8dHPLKB16MoMHiAU9r0xLAqhMiSBBYSGvrSeMM6leiVqkzQjQt58GyUz5YRUtTUioJ3451CNpPBGNkUMT2v/Pygy9rFDq2TfkZveSryCcTqBRujs82VkEvS1CplxeWlgxNzyWtewKZCIC1iM5pihLwoLndyIubmzm5dSLYcL3myNNPTojM6scHSnP2LBYvSt5ChxLtHED1d3H5sNuYHl2CTFi7pUtYR/DcKMs8ucTevQcj3jqL5cz0vYa1msz+PNwRxngRssmFREXHBBjC746DvXMk395xgT828xWI3tsJRRdpjb2fsmbcXg6A5J69C3Ibp9s2ufGKMw+LwJF9GVc1yhUWCLI80Y0dK2rmzVoWaTyy4caDvYJym3wCNvQlUJVfutQgWO6Rf20o+OP
 8sTT96s6
 /6aSZVfiW6dni8zRl55FkpJ503N/+LoEDBofOxWbhg8Dz7gVPBkvqV8vbifyW9MCfLY7U3Wa38S8o3jPg32o0lJbGd1TPXJMd68dVxN+sJ/LFjx1jAPvyXsIi16zoGx1eQXb4kZFYjCnNauJkdygv6fLLgrPN60K1yo8w6Smp7+oUe+jcUl9NFxwTswcNy0FyMIwSGHHuzwbEGhv63xA5+Fs4lefjegwpIc4ZYKKH0fi5L0sEvBFTUI///JPJsYhknW2gjjH526YA5avqm1SVC3XhyaTmDBrU7yTlQevW6ZA4QQz34MV97XFcABgBhweuOJmbUBFdb/WNO3T76yK7+IK9h2o1+YpNg6ux9yhcmnYp9pBATCSkm4xs1taExqte2MBa/0QVrvZgO8nXMrz7ONOGIjbN8uqryn9fUimcEbsr6CBQhIlKH2py4SRtRb54BP1NgnPu4vG9KRAxSIcwBsnAmMh3k1vMg9U6bSNAB3HRKA/N8kRI/pgGfI0QK812dKcnhLCqFkX2DEM9kxwOjpm4bLaNgr0ARM0yIeQjkCYlt9Fk/MxJPn4Ub7M86iIYC7jO7hN9e/en1YM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series contains three minor cleanups identified by
Coccinelle scripts under scripts/coccinelle/misc/:

  * Use ALIGN() to compute the next hugepage boundary instead of the
    open-coded expression and use min() macro to improve readability.
  * Use the %pe printk format specifier for PTR_ERR() reporting
    in vmscan.c and zswap.c
Found using:
  make coccicheck MODE=report M=mm/

change since v3:
- Update the commit message to highlight change in computation of
boundary using ALIGN().
changes since v1 and v2:
- Patch 1/3: update return value as per review comments.
- patch 2/3 and 3/3: Add Acked-by and Reviewed-by tags.

link to v1: https://lore.kernel.org/all/cover.1763227530.git.chandna.sahil@gmail.com/
link to v2: https://lore.kernel.org/all/cover.1763796152.git.chandna.sahil@gmail.com/
link to v3: https://lore.kernel.org/all/cover.1764177933.git.chandna.sahil@gmail.com/

Sahil Chandna (3):
  mm: pagewalk: simplify hugepage boundary calculation
  mm/vmscan: use %pe to print error pointers
  mm/zswap: use %pe to print error pointers

 mm/pagewalk.c | 3 +--
 mm/vmscan.c   | 4 ++--
 mm/zswap.c    | 4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

-- 
2.50.1


