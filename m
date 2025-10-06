Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11D8FCAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 07:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FCC28E0003; Mon,  6 Oct 2025 03:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4AF8E0002; Mon,  6 Oct 2025 03:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411BD8E0003; Mon,  6 Oct 2025 03:54:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 318D58E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 03:54:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5D161DE616
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 07:54:51 +0000 (UTC)
X-FDA: 83966927982.19.E2EE943
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id E4373140006
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 07:54:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SYr6w+L6;
	spf=pass (imf09.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759737289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NV9odVNENStyxZ7qLDwj7Wax6ioI4vbGv9QWrXdlsOc=;
	b=ynJOcbmJ4cPreg8k1mGWC1DFl22L74JaH81QJOaooGI9i6FF0rB/Ohyaab5ylJA5eJY3lM
	3vO27EhXvk8bGqkQMFUCQGWQrX1VE/QzfwwH+kTlWNQRFFVSd790qeauFNoBwKXuXsPc1Q
	nvioBSuxc50TcEtWve87ai6t2nCex9E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759737290; a=rsa-sha256;
	cv=none;
	b=6lNV1jYNX3G8EttocnhOb/9SyijDQVlhJyNwcYsnLesL/QDT0ZgUvsegxbjv22W7Vg/Tmt
	hgkNzq44BGd+oU7VKwgtjxdbC+BxtsaZYNNzkC2WTNZ4HyKmzZCU+mKTehCsvnq9SUxylS
	M+4zFnItDiphcSarQXbu/xIloThqaSw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SYr6w+L6;
	spf=pass (imf09.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-27d4d6b7ab5so65236685ad.2
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 00:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759737289; x=1760342089; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NV9odVNENStyxZ7qLDwj7Wax6ioI4vbGv9QWrXdlsOc=;
        b=SYr6w+L6sLdCdUYdkoI3OufMDEfxwSD3PDDFPxbwjftvCmES5/gcIJ1SQLFhnQUX1T
         KSW/OBjYZszht+nH7QwEkVwlpL2DAE2AqnknAT5qKIoU/pPUn37uBGX/UE7BwsKkjyHO
         BVe/D/aznyXdyXRCICX6MH6s3I1hPdlCY4kPV2CI0S3vtAHFguAGJaxBRMZGQsRo8dEG
         hRIcV/qHJw2JIknS7bgJ6zkZs9OFlUdX4zWuzOvb65TmVz+1zmdpYPrsOIp+R/Fz+XcQ
         K1i/H+GEk1BE7IlUpoPOoqNlLp6i55OyCL/502OYbzWVOpAhvmPFMXiq2FwEQSasZZ/j
         CQoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759737289; x=1760342089;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NV9odVNENStyxZ7qLDwj7Wax6ioI4vbGv9QWrXdlsOc=;
        b=RT9rQv9YTirJCjl8lk8wq97gZquFvlQ9V5NZ6IyvXzoZGnT9J777WBpzGWGqM9eBwK
         WI/uvO3+//L2537ltn+jMSmMS6Od3/Wq3VvoOsO/M4HSsgU7Zq0S2qCnwXHLZBz8CLai
         ytTCa3YHmE26LxlUxnnIItChxlV5KLeQH60+hw1dyYB3N/bw1ru7ZQhdPkITGC0zvj7L
         NESI0lAfQaGTCa/UykLbFMFFvR+MCuTlWm1c0AapbLtt84RLOtqXqJCHBcNvdtFrwWpx
         qoH6VdPjVw5cdsJz+1w2ZXM2Be9KrqjWe8wV4xQhQswT/IjTlEAxKYrffNh8mGPFCwJH
         YKhQ==
X-Gm-Message-State: AOJu0YyuXAT/gFXew2OhA62ElUesheP59s0pPSJHRNzwgJaosnk677H8
	/vFwTjNPfjsXDTTZ4AIBPlPSwvGMD57yt3HlG6XMPvv8fU6cZMzNbYaf
X-Gm-Gg: ASbGncsJdAb1XZFvL73axKYl0f83PUnfLRNhvfrSmAsxFYjnAlSMuvMUepBwgJvcgTD
	aLnxGnXKxv8veuOqgJI6pr3ymDNLixl1uQ2OnuMJ+kmvXK+7DuovFiVDARxN1iBRQcvScemfldj
	b1pEvABuF2+oVkbcNtnm1C9Sz2NiygCLgf7KYL2dIWDU00sMP8uXGb9KxQRIC70OXqUZJZL3CZO
	nCtB9OQUJhLk0WmvVMA6WEMtF7ynbIBtRXsKR6Lics8RQT1bxr54WoEqa1nBzf1ZTQ6INrIbwZp
	ZMd5ZO534X3TNN6ayGjnIatoOkANLUECfG02IgMkGGiS57+5YxiX38lkbxtCjDqNDM9eq8JvWX7
	o8wEOMmd/nNiIgr2YpzWZxXL7OUmpWTjLh7/Ph74IWnP7g32hB7oqV8qNnxHrxjnM6hh7S1ug74
	M6ocm1G0VeaOrnM/MXgQi/QbAzYFDPki97MLvvmA==
X-Google-Smtp-Source: AGHT+IHru+Vra/1nFYTR3oq1XBmM931fRClgQ3HO7MJwzWrhDgBX9rVkYzz59sy4NX2Ta5aYjCDBqA==
X-Received: by 2002:a17:903:1b03:b0:269:d978:7ec0 with SMTP id d9443c01a7336-28e9a62ffb0mr153066685ad.28.1759737288688;
        Mon, 06 Oct 2025 00:54:48 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2401:4900:87f7:8f89:cdb3:c13:8077:eea1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d1260cfsm123706915ad.48.2025.10.06.00.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 00:54:47 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	broonie@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] hugetlbfs: skip PMD unsharing when shareable lock unavailable
Date: Mon,  6 Oct 2025 13:24:36 +0530
Message-ID: <20251006075436.8417-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cxefr4abzm4q6kukfsmkzs8xzea3j1fz
X-Rspam-User: 
X-Rspamd-Queue-Id: E4373140006
X-Rspamd-Server: rspam10
X-HE-Tag: 1759737289-674242
X-HE-Meta: U2FsdGVkX19RWXlb1mm2gSl+G3dkCl3lMlaaVtDCp5p0qtDnjr83ec7apqx4J+zZyGs9mTC1BiDLriFvqnlWvYIr9xEyo6G8sIUT4e35vUAERvIoBm5GHSTbPr5IBDQvSk+4/KtD0vhMaBjyRUmXVD4xcTmYb3LL82/wLnVThPZ3UeGiDkveN5/p3EkEqpzgYCWqCKtS4ERZ/u+T2XeHDp37L72A5F64WrJqdfYD/c2pYflzBqXA24NUsk68bBF3a7nMXnq89yOeZWmATFROjZ6T/jaCYHNSpKvpbfp1HHpJ32H0Oxl2cZ3Tey23IoIXWjutOQqM3naN07MKJVR5GmYBSAU4/8p+Uj1qPE6fhfzV4jUuuxU6lwQX57PYXe2f0Scs4NbnI4um8jE+jwC9ze51NN+Rs67Ptvf3hATXKC+Lf9JkhUJ1akWzqpM5E0RaO7iCdPHWSBEltg2AoVCxo4zc0mxV3Cy4TcVyZmw/5cHn4/Z1cuzG3u0POK6kGkbfcBHRcDR/ItLph9TYp2lnsZMbolzOVUZ/L4MCpOwHh+42iB6TaVTLFg0khD0R/CVvWzpRy6/0ukgo/KmpesmTpriTaJkcbM7rOmoAKTrgBUkMHCSEqkczfp+FWtd2NNbqYiWu78RAsLZxVOlUUZXmRoaexOSaMThGWCc21VS9DRJ21FhywVcN+v6lTIGobSDEVMMhLItEUjHTZNIP4k4Hds5lg1uVVG5L2t08Db4IqZ2SXfwcgiM6bU4y0nuvcLudHZeMoTYGLYskUm0N9MgoRAHnrqRom4mVBiwI5ivlU+muQIjSQq82o4H4LfM/NFwbDrXTS3BwSFN4u3422y3p+DKphISKqhG21gZJ7XJDLpC5bHupoF5orV9qTMyfthP73MsxDS+NHdfF3mvVOVwqnLpqkCUQnhs49ano5XTKf1mG4E1vxQJ1Yko/mw+WYaKCeiMom9dd6vW98UDRjws
 cL3SGhKg
 4A5lgNEna5IADSPP6JnmbZhamKbJQ+Cmq0Da8bg9arM5jS/nL6iPyqBZTQT6O0lmNQOfn5arZR4Hy5304lr2/rU/KVkH5H6Nh3E1q0s8oLZwAXSJxcEKBsheSFRscq/xeb1lehZD1ECtGWNphLjZE0WWeJYK5VAQZxR9MJzkFKF1XLaRen/QCrAJajOA15+/I7k1xezlWYy+78RnaISCWD08/aCqQdoNgrLnhxLH/WYAUK+Er5KeC5kee1Iyg4bLnf3Eal+yEJLQ+m+RlWSI4V+uVvlggvSYTFzGOMHVKvWuGbqidktBcag2XGRkjuMWcqUneyd7+u7bLJRoFswk/wbidEVvxu18uKZyuCY3DN4NLOpw6bIx91mmDcyuq+cqvE8lSX+jxflTXK8bso6gA904BEpZseLVcLG6MnXnS4qa9AmIuaa/bMSHYK3/y1oweQLzgZFYEnNCtaCejJneFl814YzDxojz8ABG2v+wjsiJgK2HZYLvZhkAvVgBoRxrEOj7r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apologies for confusion. Please disregard this patch . As, it is creating a lot of confusion.
I will create patch v4 with proper commit message and previous link


Deepanshu

