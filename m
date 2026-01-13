Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 962C3D29DFE
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 09:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0391E6B0005; Tue, 13 Jan 2026 04:54:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFB576B0089; Tue, 13 Jan 2026 04:54:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6206B008A; Tue, 13 Jan 2026 04:54:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C84166B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:54:27 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B4F31ABAC
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:54:27 +0000 (UTC)
X-FDA: 84326480574.19.750BDBB
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 89B2880004
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:54:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CIXBPzOZ;
	spf=pass (imf30.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768298065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=I5kwq28ArtsUeWAWQkRHAJMD/obs9sOzlfds4wEk8PI=;
	b=q3Wv7DOM1tQyobbPvFSrhqxPag7BINw0Kq7A4BAzparCfjtfTZsDEDgf0kUSrruVpGpCPl
	twjH6oxBFS1lJwCqIDna4Kj6S8YXHGwuK4vJKQ+jySpcUEmH60+zSMtEl6SCC8nsGATEln
	h+nJ/XgO6Izd7RFJGg7EMto1Ym2CgQk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CIXBPzOZ;
	spf=pass (imf30.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768298065; a=rsa-sha256;
	cv=none;
	b=Q8JBeUInHCCHyo2ic32/Soo2vJRmBndJeNGswLLcL8e70RPjkgEV1/5ncwInIuCnKgP3U0
	/e4zUFOZcnuuBKIh8Hh4h0NDEWgcgDNAy/AFKTySndNgYO4XPSadj4edFckZyJOwOKQdEA
	b+IU1letCVpGH3KriMohFf90PAwys00=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ffc5f35b54so57367061cf.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768298065; x=1768902865; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I5kwq28ArtsUeWAWQkRHAJMD/obs9sOzlfds4wEk8PI=;
        b=CIXBPzOZcPZP5AP8vEh/p8F1KPQ387K8mB2BbW2IWCD2t75HaVBMvX/E1ZmenqQWsP
         QCLBSyc8ajFYpLK6uod14graNxSIsFJQh8xdPkN5mQAmBhsL37fjcUGsp4V9KxsC/o+P
         c6aXEznnRte4sDosRltLQuxfInpRo2PBH4bfeEu38Lup88QUDfyLZQqf7Ky9pFzcYbrd
         th2ZzJYfn5djPS2kM5pj0NoJlCNZjDz0rlE40SacKRgoSIjJHuSz9uYvBztgxz2wqVUa
         l7t9qa0MXs537izpdjFjB+V1o0vbcIK9B4f8YZqHesy7g4mmguJwVgJhwnUzed1MlBoU
         voKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768298065; x=1768902865;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I5kwq28ArtsUeWAWQkRHAJMD/obs9sOzlfds4wEk8PI=;
        b=c20RrWknyrVVLU50RNjteBGvZbw1mXejkEoYUbMOGsr1o8dyPavV5MqJwBYgUvnWm+
         9W78gOkft7F17wboPLu/PE1stgoch+STzJkiR2HI5DEozgup//h1i/1ShnH9/HGF4zav
         jK0luxpRWMjdnq7X17h6Oo9pw6/NO8EE967oLbp3atdbIDWjRgsqn6nqfzxdZYVVPOYe
         yYhBGV4Sp22rhZ52BeAK2V6Hg1+4blA3vwLZgmRnQSOMazA/OtvtI6O/QLUq9jO2fUq4
         vNs01S8vdSTpkGozGWk24iPkb4WWHUwqdoLT0/NbjZ1+S6kYaVr+zPI+GEmMTyB5QVdn
         sOCg==
X-Forwarded-Encrypted: i=1; AJvYcCXTgE/fusTlOZi4UItKexC39c1po+TU1cDXnYmufjRIlFXlMJqeV8Aun4Q5xuESG9J+v4uxMOsw+A==@kvack.org
X-Gm-Message-State: AOJu0Yx1eqbgBiuMIvrOjFzTTCpK06WWk4G7vZnSuLdg559cCklaUnUe
	teHv+pNzHAzMb0mpKKC0dCgMXP5ercF8dbs1R8DnifLjg7kxVfqfm1e0Zph9Lg==
X-Gm-Gg: AY/fxX6iELdS4CBqfr2Ky7QRTJHYm5ZUO/HPdzeD19rf6nhuT+i5W5O6uphLahPGAGD
	8i+idpTrPyzwbJ2NV9az7sEBJa36V2sulKUevowRnvdQOXMDmvDDUhE5FLFohR9q0Yhq7AwtXNv
	8hS3ejKCBZSAvbvIAmx99MGer9ZX883EMA+IYAkgXn38ar3j70DDnEXmT0/oM03TOTnCwXKItfv
	NH0kCcYWOBO6/xSU3L07jDwtWwzhrCaRVbvKBJSGWSPXZVVDN2tDsmO6ozTmaVDQh993qerx3Oi
	bUBkc3J7tnWkxyOvxVkNRjYPzKoUbtw8V3sn2Pj7xvOWZrEacbiNpT3FJLojemj5Qi7o5ijyfin
	TNlGJbpuWC2auUJBMUfTnuKMXoYjnU6Ur6JnCnAqRyvhkTchzH7X8IIFttXCNx/BOd2HoKiyN0P
	4GDXnAwjkIXAOHTPlECFm1+erQ5A==
X-Google-Smtp-Source: AGHT+IFBVrtk5u4rKzzBFDXzEra8FkgmNs+pG1NptAdeAUj8xnck47+E/LevyB+t2O7vXfNt+W6mJg==
X-Received: by 2002:a17:90b:528e:b0:349:5b1b:78bf with SMTP id 98e67ed59e1d1-34f68d0bc85mr20289632a91.23.1768292123859;
        Tue, 13 Jan 2026 00:15:23 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:180a:3788:c683:2f64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-350ff05492dsm657199a91.3.2026.01.13.00.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 00:15:23 -0800 (PST)
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
	surenb@google.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	bingjiao@google.com,
	jonathan.cameron@huawei.com,
	pratyush.brahma@oss.qualcomm.com
Subject: [PATCH v4 0/3] mm: fix oom-killer not being invoked when demotion is enabled
Date: Tue, 13 Jan 2026 17:14:50 +0900
Message-ID: <20260113081453.8293-1-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 89B2880004
X-Stat-Signature: 9hmjothta7mxwepar9sm1m8uqpndqy5k
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768298065-973334
X-HE-Meta: U2FsdGVkX18VCnyJSRxN4G3UAI6LGrVmZBZiu9G0uOl3m8fPp4cvatoaEurSy2wXqfuetQvFviBd+yLZLkoXKW9iADjoSWmYSm85tDUv3YSctX63saKwKsR6ofUBIFKglhe98IdJHANYkPxjea/1/HVOHI97X3kVis9/LCEwFHd8drv+3UWommuU+eVeWSgrJMGWMxNdmIarwzd5jo3l106CfsGtIXLm9kwXmX7y8zEuczRZR2L6oOWpD4EXB2nn8LoSZ6xBapkuxa07i3Y7To13d6pyAo9LADKXxhlvLn24d+SVbwEohTPbh3ifouc3AktyUKydHvaa1ivGJRZtWrar582MU7aYx9yiriDQL8IvQHnj2i5bQeH08sT/4osGSh5lxs2oLRUQQ6bJU+PnZ5vc9DRoOrnmsNZ9RaG6AU8zq82RQs8EYqOFin0AFv/gQ8+CVcBWNKa0KEgSuHvTiHpljxi7vjcXzirt6B+RsvXtzNy0ktKYrx7XGufEFLjoXHPUopFwCdHRCz/1wbZiD3qfCPbd22GdujIoaHD5XwXgurhfs0BJsIp95r6C0A6Zfd6uc8/zT1gRNlX7Smj1jF7eJ1x5VKru37zkLnJqsDOFKOd/861lfoaf40656OC6MZXvQh0i4PaJePX5R3x9hS/lNYIX773mdgp5SPPnJPUDI/LjO/9mRZX1Ymnn+Aosl64x+8bJpzk0Nznz5XmmkpYiWfXFOJrUcdKqGxCybnE4KndKBeUUf8ZjivvpokLSr1hEokqZ26HhoeREl9pVTstA762zWz9PSNIMlQMB7IbAmyR39tq9QFlS+ecu8AEBdljN4sk+sMEvXHzat20iWJ+XRPV5pGxjCxu3W4H6lEUlzBuI+2R+5lm7Q7WOIDhSJt8y6e0eyWWs5NJDdwVnBtUurwO4SBkIhWpWMFKRckT9WAc01/rPqQcLB4Up/c6MYhLfiXsPkAtY0aTYf68
 dXvTwpaT
 3mHARtKDcvl4UAh6oWDKVghu2BOn+kc+6LGaqX2vGUlq5lyTQx+I27DDQtP5qfRAUV5QpV+d0Abso7VBe3lSPS/+OSuYAsPnpBJH/B+Vtq6vdXMd9/RqQ5rcOgXjNlExUGfFSAm2/27Z3tyngIBvIMZIYVESJJiv4kyERhL3vksztrI2ir2G1LqmK5KJLzZq+7j+r/hdD5Z0XLvBoEWaJSCuSGA21OphXzktMuPSZBMcvhUQQGQovjeAGMr6FrtEyUv0Yf5LbvCicZH2S2NPMI4bVw8KHHd1PA0d7z6M+usk3YB8M56OghpQ+UYAFuVZPQAeb0NzOtECJTZ66Cm6k1FZDtbd9WZ1Bim4QtawVlQ+A5kzdaJbI0pnH1isucbPw/kWJQ9JZNU5u02yjwZjU6OpK3dFqDPeFWE4Dl7jaPNiNC4WOnvGNkSFMfwdkdM0Fnxmjou48pgEXwmgXKeVVD7/itWvsrpPAKGEdFxaXAm8aHYUXIzFAd7Stjz0fOgsqyjPz
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

v4:
- remove unnecessary include of linux/node.h, suggested by Jonathan Cameron
- include linux/notifier.h for the notifier_block, suggested by Jonathan Cameron
- typo in abstruct distance value in the commit log and document
- add information about supported architectures in numa_emulation.rst
- add a code comment in can_demote()

v3: https://lore.kernel.org/linux-mm/20260108101535.50696-1-akinobu.mita@gmail.com/T
- rebase to linux-next (next-20260108), where demotion target has changed
  from node id to node mask.

v2: https://lore.kernel.org/linux-mm/20251222004834.10539-1-akinobu.mita@gmail.com/T
- fix the explanation about cmdline parameter in the commit log
- add document for NUMA emulation
- describe reproducibility with !mglru in the commit log
- removed unnecessary consideration for scan control when checking demotion_nid watermarks

v1: https://lore.kernel.org/linux-mm/20251208094028.214949-1-akinobu.mita@gmail.com/T/

original report:
- https://lore.kernel.org/lkml/20251022135735.246203-1-akinobu.mita@gmail.com/T

Akinobu Mita (3):
  mm: memory-tiers, numa_emu: enable to create memory tiers using fake
    numa nodes
  mm: numa_emu: add document for NUMA emulation
  mm/vmscan: don't demote if there is not enough free memory in the
    lower memory tier

 Documentation/mm/index.rst          |  1 +
 Documentation/mm/numa_emulation.rst | 31 +++++++++++++++++++++++++++++
 mm/numa_emulation.c                 | 26 ++++++++++++++++++++++++
 mm/vmscan.c                         | 17 +++++++++++++++-
 4 files changed, 74 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/mm/numa_emulation.rst

-- 
2.43.0


