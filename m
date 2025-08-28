Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37CFCC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839438E0013; Thu, 28 Aug 2025 05:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 810878E0001; Thu, 28 Aug 2025 05:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E3B8E0013; Thu, 28 Aug 2025 05:40:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6504E8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:40:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C3F713A539
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:40:30 +0000 (UTC)
X-FDA: 83825671020.23.0E03DC2
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3EB664000E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:40:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cU2JgRzq;
	spf=pass (imf07.hostedemail.com: domain of reddybalavignesh9979@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=reddybalavignesh9979@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756374028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6jxNMAjDI19J1IHRQGgmZqJDB7pJyMti4vDt5IrhUw=;
	b=SiLTamzGViFMzh/g8Inyw1CX94TivSenmfDi55UHbvvCayD+7zMbDFF4bk5BIJgZtGBJ9/
	o+CKQjdJscPKzPmPeFqSdKxxEB7e13f7t9e2rb8vJigc0OiEmIx4TCGsR02TjY/o7HZ6ok
	+0c1jpnN7owCDuHsIDzN+fwL8X93c90=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cU2JgRzq;
	spf=pass (imf07.hostedemail.com: domain of reddybalavignesh9979@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=reddybalavignesh9979@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756374028; a=rsa-sha256;
	cv=none;
	b=P+g6eQNmZKHk0vMariAWJIRm1JvlA36Ul/RFBwMydVTvZoufkd5HBG7o+1rgg0HyVZDZCx
	T56IA4COPztVuK2ckKvYiikQ65JCRIWSM0KCi6QxUsTlSzC4uu0az1YON3OrgxEgTKbw5L
	lGV5e3m8kO4gzqEHCFhYFc48a9ZzL2E=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-32326e5f058so664462a91.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756374027; x=1756978827; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R6jxNMAjDI19J1IHRQGgmZqJDB7pJyMti4vDt5IrhUw=;
        b=cU2JgRzq3lNRnKk5F4UokyiG1t/UvSpVXWAuCxHXT2niDscaU8bmYst9Wv+larQSCj
         Pk2zGb6/voKtvbFf26A64MvBZSCCTr9qz+WOjRtt/MH3fW5bt6FuxlhF9ibKk7UUb0Yj
         Bte0CworxGrqgbP1+WtWgTF7wi66C2FrJ3n8I8qFNmbMGkxzYG/dcxSCOEcN2mSFt+yb
         LvcQuTnufwb3yjIPqpN1dCiEPVE9q9XMLJcfvVHKyVzUwKykivzwDjFawMiXS3UIR/d/
         Z4RXsBbOEPSXWFJEKx9V/BlH8S08CrPLfEZ8CNj9A02KazWShpmxepM8E4l0ycjQ17AD
         nY+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756374027; x=1756978827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R6jxNMAjDI19J1IHRQGgmZqJDB7pJyMti4vDt5IrhUw=;
        b=MynLUDSNVnkzINswzGWLI2mIkx9r2J5LAU4eVtwTRE1Zh6glMvCC1BiFJXgdSpmuSu
         5YLxtq2wde/wj9BxaiYmIxRNI/8LhFXA/+q2PTUVPJS0cVKjA8+YdHG13qpnqmTonDBT
         90eDSye+FJxLXC2LpaegO8E/sFQSDMsfhy2uaDd4ZCKvk1gcQY6E9BLLauuvd2EkCnLP
         clfNRMHnlTDRr7ejI6Vuyjz51PkZ/twLDgEMmJAZJo6d9eKiIPtFcKeKHcSPt2mUc2df
         rudogs9qH8Mlpfv2+kA2aGcIRwWAWxFJgzJpES5+ZvS002MCXjGyHY7IxuSJY87NrFY9
         F5IQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvz3a2xS/ansIuEjwtHLNJ08ZPUet4j9GGu0J3CjXILrPWKR7zN4R4DLGiBUBTQXEbA/L5RN2X3w==@kvack.org
X-Gm-Message-State: AOJu0Yzxlrd4NYyGJo9XMF1R/AutGHVSz9vVVYIWHjqwu0l0Twp8X6+b
	oylWBuTWiCsBZ34JZCkSIQ/KLgWgDawM9gnceVUZO3zToFnZR/1eMNJO
X-Gm-Gg: ASbGnctnmgHvHieak0aDZ74Y3pI7CNoQT1ufiJ/cbeD1KVZqz3wGMsAYewKJnAUmXHr
	cfop9SDaF3s8dH4Y6nBfHe5TilhxlJzUHbCUjdbvtQd5Mt88J/zfi8sHRaT1Yqz9HuzBuE518VR
	puVQYZFyIc8c0SfOFUT8Ux7itDuOSdDMOyhBIvV1Xyd2PiOpzMEOtIgOl5y0dINljWYtft17tb3
	s3r6Ao+N0kZ4MJsbJUiMhjqPPP+KVRvuppWXtiMT+tDixyO2mqipeVMSNOVHTW/7ztgHqHx90io
	x3FGhQWDdbFre64xnjG5Uk3vNajyzj5Eh+sZFOWM2jfSDSaZd1FFi6sEP7s/d/0PmK3wcrjRY7K
	4cvbhlFl3I5JXjKVyyXupIe1TaDe91dEN2Lvr69fj4o/0qJeqJ00tUUQ+ITbJI9RTgPDGxnVmGy
	WO+3IFEHcXzmVr+Tp/gw==
X-Google-Smtp-Source: AGHT+IFyJcs7VZXQO4bl1E7h+tk1g9mI2keQqRtJvL/QqXUnkVgw42POnmQAIbH/7ZuAy7kHK1BBsA==
X-Received: by 2002:a17:90b:1649:b0:321:4182:2b9e with SMTP id 98e67ed59e1d1-32515e37410mr28758623a91.12.1756374026134;
        Thu, 28 Aug 2025 02:40:26 -0700 (PDT)
Received: from server.. ([103.251.57.213])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3276fcd33c1sm4518432a91.17.2025.08.28.02.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 02:40:25 -0700 (PDT)
From: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
To: richard.weiyang@gmail.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	davem@davemloft.net,
	david@redhat.com,
	edumazet@google.com,
	gnoack@google.com,
	horms@kernel.org,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	mic@digikod.net,
	ming.lei@redhat.com,
	pabeni@redhat.com,
	reddybalavignesh9979@gmail.com,
	rppt@kernel.org,
	shuah@kernel.org,
	skhan@linuxfoundation.org,
	surenb@google.com,
	vbabka@suse.cz
Subject: Re: [PATCH 2/2] selftests: Replace relative includes with non-relative for kselftest.h and kselftest_harness.h
Date: Thu, 28 Aug 2025 15:10:16 +0530
Message-ID: <20250828094016.18063-1-reddybalavignesh9979@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250828081026.yx6vgphtsf4pmr3y@master>
References: <20250828081026.yx6vgphtsf4pmr3y@master>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3EB664000E
X-Stat-Signature: hyn7c4i5hbcbgroy87qu4f4q951cr61m
X-Rspam-User: 
X-HE-Tag: 1756374028-796490
X-HE-Meta: U2FsdGVkX1/aST+18BEu2v+5thT5Z9bDY71zhjFZYBfKkKZMOsTgmpJ9GZH6p46o06QnlrZiQnyOekSmR04GPth6c3CmMtE9qWMzhbGt2MqQbdiD2r2DVhmQoURKB1R5POaQB3bY+1zcdOilTbwb5QoE7lqf3Mrf0CMjkGDX3J74T3HkYNsNsRrjcs2nrpJLgxRv5IrhicuVLvN966RY1XHnc6uFoskbnjd/qpSLAvoaORg7RgAOASLYFn8Ma+MxLnTexNzR3qzMncxi9F6Dp+UKiOO6+yU/VDb9NaZu+B7CyMV6trGx5vgbVKfeABFx05KhaSqxKYo4pi/paf3PCys+wkuLM373lXZvsIJHb6ZtyWm2ySzEMT+rlIPrIvQ7pquIPZkxKVHuXUOlmodvIMiH15OUMvuLSJt60KY9IFub8wtXgBfg5Ig5b8WEWqa3IWMB94KMSh0iTVmEQ7mO+0IEagZr3uM0a82kVeBBiEG8luG67OmJtoubfVPAHRlDosesZQd8YGc9X7sCAffpp7ep/MYKA78BnoiDMeJC/+CnU1/dOawHZjoz4sEXgibYc5h2KF41LWrSy6WtwnY9M/vvFilx9ircsKKfAJafvn827bPuJ27tloyX5GL7Hxy6b5IJIveC1Bxv2SHhmBkIXC8wZ2W56gqH8WL4m0lEW9Ou9mqxv2DM+ITRuqqzXUdNPlsig9t7Zv1rLIQF2J2qevpkAb2puXaJwMQcicZh+/WSGMW6tCOIxwEl8qq+6gMLEAHok0xKhsiF40XcPgDhg/cLign09nn7lKW5r89ipjgn2aJE/hnVvF4PllGmWMd0E7x3BBuSq1gq2k5jU8hqLZ8peQSEGYvyqV4+MBJZQ27pac6lYXNPb7mnXHuX34rdm2pSdQ0VQinINCetMJvZsT9ufGYgfSDX2wATD718HS2J95zFIsV+IAlSbmeLMlVZVJrUfipHLfUKg1NLa/Q
 l+k2jVxF
 H7YAaLqz5tbv4KNkOh9Lf8YafKVJyswAeGEAkMblXR9iIfp6Sn4OGr6WmA33u8WN5OQyQzYazOtT1pMLO4YqJnlaO2MwcTPLmSZxnXPxoCVQ/CHgISDY8ylTc7IgyYLXoobZPmD4K26BeWjOWNatp8OkDytJs/ogMANTfUeZWnElKRXIzuXoeSKIBdKiXFIV/U2yBaY+ceMH3J7oTl+DZJRiffi1K1+JEFPDccnqO0oDOgyJqXCHoQNCVNBN5jSwkDXh9HzwRzauPPLWkgco5Ri9B1azZk9cE/hDHGMqvro55eZWaiHw1wzJIK1eCeEqQNfkSG0O27qv5r5n09pPcIjgD0bSAmRzc0I3jyMqT+QnxzdhIYXkGNqAOfvzlt/nXZnA/xxaV35Z17vbJvf42grOg1dYdO0JevzrmOkHVSpU9pxWInUplHjJuvozQIj5Klb3cmlwdzF5QE2ye1TpV3Ra6J6b38iRbFS8Oe2o7V/k1p+dG1gDGaWUTsOpcb6myMdzK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Wei,

Thanks for testing and for your feedback.

Yeah, if you try to build inside a subdirectory, the top level
export may not apply, so CFLAGS don't get updated, and even if
they did, the path could be pointing to wrong location.

As the docs recommend, building selftest using TARGETS,
either from kernel source or "tools/testing/selftests/"
works fine and doesn't fail.

If you really want to build from selftests/mm/ directory then
defining KSFT_INCLUDES with a fallback in the Makefile will
resolve it, but there is no need of it if we stick with "TARGETS=mm".

Thanks
Bala Vignesh


