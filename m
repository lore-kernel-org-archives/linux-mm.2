Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64DE2C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:10:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BDD66B00B3; Tue,  8 Sep 2026 16:10:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76E9B6B00B4; Tue,  8 Sep 2026 16:10:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637BD6B00B5; Tue,  8 Sep 2026 16:10:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C77E6B00B3
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:10:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D7AA080262
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:10:35 +0000 (UTC)
X-FDA: 85191687630.05.5C24DFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 266C01C0004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:10:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tl9ZV6Hb;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oPJX0y8/AFpF4NLkzH+iQBcndkDmeOupn/4emEXwzc4=;
	b=ljz+auiZpIn7vxJldRlBjAoiVLvsOL4waIGZ5EJ7/Pc4jUbIIcCXPaG9JhRn+RxqmkbA4D
	gordV0UrGVphnmhn8YW6Ax2+SVMLw34s3Dag9Hs3lPUcE2eGa9Lzpb9TTFlbuCQrFvdiv7
	U3hHuRtO8dXux9AsJ2MH+P3XIfy5pQo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898234;
	b=Abd7Xcu8qjnNCH9cvJm7/LRLRQf/eXS8eKFk22LXBJe7TyN0HK8sfq/NqkvOE0Cut/dQbL
	TVzwSk+edXpSG+Fc1PflgyQQcPMGWtYaJQVHfcFtC5oF5uJyKqEllnLe8cHHMVyAeV6YT/
	w+Pme/625eeoGSUNI6IgeaId/NCtyco=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tl9ZV6Hb;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 999F2601F7;
	Tue,  8 Sep 2026 20:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B8C1F00A3A;
	Tue,  8 Sep 2026 20:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898233;
	bh=oPJX0y8/AFpF4NLkzH+iQBcndkDmeOupn/4emEXwzc4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Tl9ZV6Hb8Hjiuc60Ij+5vASX4LO4r2f5Hjq6CP1FNLVozhArVz9mi1Jif7gPMJdIi
	 4++H88OwBH/cogRhHQit1xi7oDME44hQN+VP+YZU4PJ57L8nsQXS/p5n4SXS57x5GK
	 x619Olb5JOmJzBxzUUNKU71Y4lSc0ZV5Lb9Bcv3T3GsiFgV0TDnq5vt2SNzPS2lm5y
	 FbYol0Fxi4EsP7jRcmb0BLBzoeikFrPPwtP6zJyl9ounKHiOiG4FUkK7FR+JVUcWWQ
	 hoYJQAkJTHkCesL3G5CW1CVz7BbhVpPBN2Yw7kjQuTuX6MRqns6c/bi16DttknbuFV
	 62dS5Inoq/Ffg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:21 +0100
Subject: [PATCH 17/39] scsi: sg: convert mmap hook to mmap_prepare and
 rework
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-17-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, 
 Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
 Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
 Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org, 
 linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5941; i=ljs@kernel.org;
 h=from:subject:message-id; bh=mW1naObXPKtLwSWApVWsQPYHiLfHpNWdJIadTG8SHEw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG7+YfQznv34ok35avkX82er69RE11TdcfjmKdEzh
 U15v2NeRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACbSlsrI8GBzr7PJndJrvjb1
 l3MuT37UrxbVn16c5yHUa2VdtsFvPyPD5IthfpMVE29zJX2yOxuTIfxt1sMV6SaLjU7oe3lYPHr
 ABgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 39d4f9i4zkims5ukcg6nqw8hjjqorxik
X-Rspamd-Queue-Id: 266C01C0004
X-HE-Tag: 1788898233-823225
X-HE-Meta: U2FsdGVkX18L66f/vXPJOShFCppNUQPhtb5VxBruqGpAA4vyw3FshajiWWC8HeopAuJRFTVMtIiTbSOA8Rs3WhAnEsfPLzUhPzNop3zKESh9SxpQllqSFxIpAmiq/dveD5graFYemH2W9Usx0p01T+av7uefTIYyWWR/uM3PS2AyVN+h4rRgr+NuhwbQ64EYXUT8CBr59b5UB5KLORkMJAR6ERTOsI9ph4qEfA2FAjNweCxwFIlV3Gut1+bqLJ8nSqfN5WAGVodCA2mjiiQqev2QZ+edHVBUHDhSixBSkAySsQITlaZfuErJYrUdJt5rSIMR9Bu1cfJyXlcSzwaJT/zfNGtWQ9p2R7Hr4UbxkhSdu+YBzH2P5o/lwrmR/QbOjPpeZz4dtEXaT8wEsKpovl2bDNtnEY98NT3O42WYMnhSnE8cLNo8+UeBwUlsyTEtdIpRbxEWJowkzYDTR1cpc2PLpgg32XekdCFqysYbAp00fjA18lvPQL6+p6NpJ4pXyo6sL+I26iGWt2zxoyOTIRbZMoMEg8WwaOx7SxI0Tp5hquMunJ3kjGiq6ho+FWU6J2KZLPsYsmcbPsas5yt8w0QX22cedSrepTR0jr2uVpnaTRo2JJBTfVJ7KYuQ1zGVFRHcrDl2LWCvQpByT+5vEcyO7/lV4dBSJR6T2suATJ+Ebj6GC014thSJ7LYoJFQvbs8xJv2sSjXM7/A+jK+b/wmy/FZrJJW2YEzUe0ZJAN+On8pm1TleTkMnxJ12U213iGKWqeVwqd9PE2fQ7jZIMQ1bwDwmp5TwiTJdOZv2xyi5pPoWrOG3NJ1UstDvNXS0EtkcP0vLPxsaJ5gXkeNgb8itL6ajyC150L1e4IQHAczn+vBEbhP/22AcWhFCCVktDMyptUHBveKhmVMUu5i3kyi5qQ+DN9SIoDlU3hzlcd9dj9AJUsY/hkyBfcVCOkqabHmQlU9GrN/ryLn97yQ
 oBufe7sS
 gooLEYIv7tqTKfV5Gw/weU73KNOgepWTz/nAEZ5VcLFXISzmzz6AKWLFlCllHqleaxCIiiceaQLvJOJH11O3m1FiVFFI+K/nufjrjS6kv2BEnyLGwqQbB+Uur93JFr8qlf+VBcJigXxnjAaole/pVaGj6/i21LjCmA3AaL5g138RznsQhVA+LRVtvEh/kOUPC+3LxB1J+yHk0uMI0imUWitZn8nFjgvszYkPG1doaSNfdp/E0bspS1fU2HkaJ5pGCg4obuzBnLau9PHY3LwIZDbtzhG+1paaK5WU+vs+ZilpDtFICXLeYiIucoxamrFtD1bHS4L6S2VZm6XvugAsxALiDtFOBntct+7wuPxHQYJRSTNdmNGawXUxEC6Z8uwJhQ21asmzJN5EQE6gwQn876IYE/qg/L4JGqZo8ZCfdrMllkon69+oQG4QvLCIFNQBxAK/GRu3HkI0kfOThcmZGnYazYh0QPQSje2i8xGC6k6En9kaMAVYhya08MlmdDEqI+zHS/Ac7lzD4ImiwdBwExdUAvy752ke+vwHiipnBHC2o4GWcz1jdrCQRIP577I0zrJu4fPghxkmOYQ2k9Xy0SoNDppPq5g5LSAZycu3LvS4F1NCehAgPZdhn+RbJ7mbO4rbVhPBI/LusTtNjax6iq5VB0XYYYQXvXFXe8iJKbb7bLvgATVXUj3AleFwEgUou/Y0TvHaH31NVswvBj1OzsIUKsPlVUwQuT9Dzc80ykWre4ePjc0drWIHDylkB0GrNXQPEtjJ1Y/y9tE0oFdwwJDxEld1T0Hx1zIU5ZOubqrLk2bsGl4fuXiYMIal83MWrlRG8oc6frkWrOwdkAQBjUwm+IxIhkH1roEQjX2HfNtr+BzQWpM8jDZkHT6F3sSKaD+NjeLTg84pI4yvyXad4qMSPIo3jI0wmXrcRtJQAKx4ogkX/M/sCw+EBfpuDNYH25znl5aHHe9wou4Zla1MmYVsY6v0/
 SKu0D3VO
 kSyyoGWtBICPEaPRijf++kUE+CtdW/7ChGhZ2sqageE+qum68lAPra4uk7IHLS21kmIbo07EIfel/7tQg08cUsczKoK4eDEtW/OFpo3/5xG/O6qc4bVEnBGBvNQtIvuxh7OClNf7CxHun0f5s4E4tL47LmCVZpWmfhUlNpopDwKba/YvYlp6TbV5e/gNE27xy9h6I81IxMkMCd497unyxSeM64LAfi3IGwkDZI+30aR5QlAKtOWMRMdR7CohCZ+VME78P9C9YNStXaqXZ61spjEc+Fw+gp8cIernuRaqErD9YE3zo0SeaRkNuZ2GH3J/6hCsGOcNRnTS43T7tRtVjN0K0wlSQtciJbBgdKKp0e46xTXjx8GiszvXbi2JSbKNVkzT4sxd9K1sUD+FVuvoS7bSELU2VbnIwYyAp5aJmNEMMy8vTbU9Y7Z1rdLBLim3zGB4rxS2laCsBGf+27zgXvI9mgwyFyex8wFwCBlgRSnHiIZ94AzkcdOwB9tJBfJ6U+hoTVwwbXw4ue+5Ej20anAJvfA5QwHM9elCS+8Dejq+BWcu0nrdGDdFoa+DsfvqZP/sfDXXw2Z5Yli9y+Uzp7geP6LzQ18t2L04ZQAs0RnYcLncJDbZC6UCwouZWmEgJMqaWedNv2r9cewDbNo3BYvPBGSnSSFmFY6O40lEtbpSicM8nMfFlp93SW9QS8uTCUxBFqVdUQYKzZaLlFSRgmzavOikb7aTFU5vNUNKHXVXRSXyMOybXf9/tKSED6T1bsioVAVnd6jEoMYWY7zD7KrdGokZWRSgcIWYjUdtFRj6rmUNoiPSD+nUXtSpQABalThcJfhpT33QAmD+1niTZaIxuiE9jHM8Kv88fjggLKayrZE9Uz9Q8jL/iSv/2IJVGkLWpw4A4cMBrNHpuPAA9YFrbsORNE2VDM2pRjynS13QVRlFn3rs/MebuvGpmz8J0T3BThPEeUYeOgvP96PzlxLVT46Fi
 V37ljSyq
 JhCnhwLlWTdO3+iV75j3b8Ac1w6Oz+y7DJp8cANV7KAcFlIb7D1OOLuK4nWdfdA2lzxp9ZzUAG68303I3oL+BDS+ZUlPbTGGx2OHQJCNPC5ZX8e/2Vax3IPBZO9j4vjO2YxRyCBnVsu+O6trNerz2NputaRVdOtkqZu7AOjwszyAWjSjzcu+ltFIfHsJM8tVmaCg+IRoj3LKCebA/rH8OWqeWu/6EhJTTLH9Psv8s45DLvgp7RrHQ1Y8PDu/h5Qu0ijvkpIcofs1m4TiC0GTegiTPlabKKTewEk6NBe9ShS/XPF/lGpaJKjSwk+GRlI+0DOltwbJFnJPy3lVrLt9BYC/cd4Xy04pKl6nph0Pcs1DFwY9TaP59DLM8Lsvzp2qXJor5Ec3ORpBwWL01ytYUeypjrmrWudqdsbVdHi3aDg6xS0UeQzNi7kLAebL/2Q9tqFC9LG4T2FqrSy7KBmrvIamlCMgkHWQRVrzY6uKChMfoLxk7rcjEY8jR7Ow+xTUkcR6QZHfFLjWo+ukya/s/tOFkjgBHU49CnkEJ8Dr2cVm15ixL1tukS1zBUZUdFtTDXPqb4ShbJdKOr3BaYcISR+eRnRFYfrBgUFwh6pmQNU/NnZh00c6siDuNJX4+O5uUlzhgqZgy+p6y1LjY/waSRb42JFIGzf05M2IvU/6vm4JlEkGtUwadDbH+K0nwrC4DIJ3M/btS05OLcmyvNhS9pINrfkIvLQvEXe3xL1vvroV0VMbbzl2ji/LruqiWxnoJgXJpwede0gwu64lcXY+wkxmMDUPGA6XSW9Pr+zCOwVWD8Q4xl4Oyvjnw0dfH2BTwxVSvqi82D/TsLNl/WHJlZb71oXzUlr8gKtbBqbMC0Zk/05I2cx2T2/tENQERXQnw7j51VBp9/zSKWGHBMgUKBl0JB33vw8nMStdKSr6c6gsbMEg7sPKLBFKTrw3/aJ1u6Y5puHqvhnPFSsUCRMDrrE+9wgll
 IBG3wmoe
 RnX/UQe6gTZJPtfAJyojsl9JuK+Z7L98nrZ9eX6O4lgYyjL3hIED6LzCYsbM4l8YnnUTPNqXia9fCfynnRArfdnngUWs7NAZ2qq4vzD09di776VP+UthOvqiHFM1rqhIkiR0xD45mIrQ697sf5n21v6bMQxZalWLqDy7IR80Diwi8mvJgQOfKqLmDf0mJeivTPI2pSq42MJvKZIBk7INRuAFmYDVZ/7707oeEOxjM8Do4FU9LJRUK3jKE0TF1rNhzvfC1NoUNRy+2mLwg8aL2tTgmTurdeMvMkRlObM1QW0xZCyPFYlhAFZBdO4wuuv+JLl8WRRKwuHMrtzKtwOBu4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move from the deprecated mmap hook to the new mmap_prepare hook.

We are mapping kernel pages here, so use the discontiguous kernel mapping
mmap action to do so.

Unwind the rather confusing loop and instead map as many pages as we can at
one time.

Note that we do not need to pay attention to rsv_schp->k_use_sg here, as
the pages are populated for the length of the buffer at
rsv_schp->page_order granularity as compound pages.

The discontiguous kernel page mapping logic handles the compound pages for
us.

sfp->mmap_called keeps the buffer stable for us. As before it is never
cleared, so a failed mmap also leaves it set.

We also remove some useless vma, vma->vm_file NULL checks - these will
always be non-NULL if you reached the mmap hook logic.

We retain log output for consistency, but change what's output on page
mapping to indicate that sg_discontig_get() does the work now.

Note that we drop the VMA_IO_BIT flag for the VMA here. It was never
necessary as we invoke alloc_pages() which gives us refcounted folios that
are fine for GUP to access (VMA_IO_BIT would prevent that).

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/scsi/sg.c | 115 ++++++++++++++++++++++++------------------------------
 1 file changed, 51 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5408f002e6c0..12837b828b89 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1212,85 +1212,72 @@ sg_fasync(int fd, struct file *filp, int mode)
 	return fasync_helper(fd, filp, mode, &sfp->async_qp);
 }
 
-static vm_fault_t
-sg_vma_fault(struct vm_fault *vmf)
+static int sg_discontig_init(void *vm_private_data, void **private)
 {
-	struct vm_area_struct *vma = vmf->vma;
-	Sg_fd *sfp;
-	unsigned long offset, len, sa;
-	Sg_scatter_hold *rsv_schp;
-	int k, length;
-
-	if ((NULL == vma) || (!(sfp = (Sg_fd *) vma->vm_private_data)))
-		return VM_FAULT_SIGBUS;
-	rsv_schp = &sfp->reserve;
-	offset = vmf->pgoff << PAGE_SHIFT;
-	if (offset >= rsv_schp->bufflen)
-		return VM_FAULT_SIGBUS;
-	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
-				      "sg_vma_fault: offset=%lu, scatg=%d\n",
-				      offset, rsv_schp->k_use_sg));
-	sa = vma->vm_start;
-	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
-		len = vma->vm_end - sa;
-		len = (len < length) ? len : length;
-		if (offset < len) {
-			struct page *page = rsv_schp->pages[k] + (offset >> PAGE_SHIFT);
-			get_page(page);	/* increment page count */
-			vmf->page = page;
-			return 0; /* success */
-		}
-		sa += len;
-		offset -= len;
+	const unsigned long req_sz = (unsigned long)*private;
+	Sg_fd *sfp = vm_private_data;
+	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	int err = 0;
+
+	mutex_lock(&sfp->f_mutex);
+	if (req_sz > rsv_schp->bufflen) {
+		err = -ENOMEM;	/* cannot map more than reserved buffer */
+		goto out;
+	}
+	sfp->mmap_called = 1; /* Prevents changes to buffer size. */
+out:
+	mutex_unlock(&sfp->f_mutex);
+	return err;
+}
+
+static int
+sg_discontig_get(struct discontig_kernel_page_state *state)
+{
+	Sg_fd *sfp = state->vm_private_data;
+	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	const unsigned int order = rsv_schp->page_order;
+	const pgoff_t nr_pages = state->nr_pages_mapped;
+
+	if (nr_pages >= (rsv_schp->bufflen >> PAGE_SHIFT)) {
+		discontig_kernel_map_abort(state);
+		return 0;
 	}
 
-	return VM_FAULT_SIGBUS;
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
+				      "sg_discontig_get: offset=%lu, scatg=%d\n",
+				      nr_pages << PAGE_SHIFT, rsv_schp->k_use_sg));
+
+	discontig_kernel_map_page(state, rsv_schp->pages[nr_pages >> order]);
+	return 0;
 }
 
-static const struct vm_operations_struct sg_mmap_vm_ops = {
-	.fault = sg_vma_fault,
+static const struct discontig_kernel_page_ops sg_discontig_ops = {
+	.init = sg_discontig_init,
+	.get = sg_discontig_get,
 };
 
 static int
-sg_mmap(struct file *filp, struct vm_area_struct *vma)
+sg_mmap_prepare(struct vm_area_desc *desc)
 {
-	Sg_fd *sfp;
-	unsigned long req_sz, len, sa;
-	Sg_scatter_hold *rsv_schp;
-	int k, length;
-	int ret = 0;
+	Sg_fd *sfp = desc->file->private_data;
+	const unsigned long req_sz = vma_desc_size(desc);
 
-	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
+	if (!sfp)
 		return -ENXIO;
-	req_sz = vma->vm_end - vma->vm_start;
+
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
 				      "sg_mmap starting, vm_start=%p, len=%d\n",
-				      (void *) vma->vm_start, (int) req_sz));
-	if (vma->vm_pgoff)
+				      (void *) desc->start, (int) req_sz));
+
+	if (desc->pgoff)
 		return -EINVAL;	/* want no offset */
-	rsv_schp = &sfp->reserve;
-	mutex_lock(&sfp->f_mutex);
-	if (req_sz > rsv_schp->bufflen) {
-		ret = -ENOMEM;	/* cannot map more than reserved buffer */
-		goto out;
-	}
 
-	sa = vma->vm_start;
-	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
-		len = vma->vm_end - sa;
-		len = (len < length) ? len : length;
-		sa += len;
-	}
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->private_data = sfp;
 
-	sfp->mmap_called = 1;
-	vm_flags_set(vma, VM_IO | VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_private_data = sfp;
-	vma->vm_ops = &sg_mmap_vm_ops;
-out:
-	mutex_unlock(&sfp->f_mutex);
-	return ret;
+	mmap_action_map_discontig_kernel_pages(desc, (void *)req_sz,
+					       &sg_discontig_ops);
+	return 0;
 }
 
 static void
@@ -1415,7 +1402,7 @@ static const struct file_operations sg_fops = {
 	.unlocked_ioctl = sg_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
 	.open = sg_open,
-	.mmap = sg_mmap,
+	.mmap_prepare = sg_mmap_prepare,
 	.release = sg_release,
 	.fasync = sg_fasync,
 };

-- 
2.55.0


