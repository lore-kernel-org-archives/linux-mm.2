Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49930CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD2376B00C8; Fri,  9 Oct 2026 14:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA99A6B00C9; Fri,  9 Oct 2026 14:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999826B00CA; Fri,  9 Oct 2026 14:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A8196B00C8
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:16:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE6151A04B4
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:16:52 +0000 (UTC)
X-FDA: 85303893864.08.0C70732
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 02256A0006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:16:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OkBCv+l2;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25TcrP5NPlHeICyKz/Dt0wvN5LMoYnpbWYR4UkDCBe8=;
	b=zTfXU0fZTC5KGJrg2z1CMdgj0IwCPKr6nuEKqGZs+/kf3agdq3prVNTqslVVkD0qp3nPDO
	8s/TO2DGsPykgG3GcP1mvtVVT0cKvHMpMTCgyVWereYrTnfYC8sJkM8zNTFZVzQGszcHkI
	oDNp6RLYxGCf3xEYM3+8eM8AGM1t5xo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569811;
	b=gIpYz4joJE0vwLxdNBwG5NLAZpwjVoEp8xLN/wFDiDr7OJpihvNqexsA7FX8lYuUp/HCb5
	3p71UU7obpuFiah3FGf0vbaqGY8CotTdW9boxeCkW4RbTdf9d4zBfh+xy/A1h+xBX8gEHA
	BBVnDz2g3EFo0daYYt2XdnmAtRBQziE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OkBCv+l2;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 955DE6020C;
	Fri,  9 Oct 2026 18:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D931F00893;
	Fri,  9 Oct 2026 18:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569810;
	bh=25TcrP5NPlHeICyKz/Dt0wvN5LMoYnpbWYR4UkDCBe8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OkBCv+l2tus1fhsoR6yRNBzqw9wTjBOBFDiaDfa14H9Z5JQB5kG9OiwbFete4BwqC
	 EzuoodO0uvmtlh55fExFTJtBKmy/gjwCgFE3kFsoMvXlpopfUcrM3eZ3kw2c5vnwMz
	 saQ/a/lN2THW/RWZzLd3qKq84ZRtCQi9Y/VdLxtxZvQlnF2CVh2i1N1MvGOkpd1YoB
	 /tOa3jA326w/FP2YeL1y3kuSS9DbgS4+2ZmaKC+u/rOas/ofq4KBiO/DbQHxTpdPt5
	 CniKRPTzwREOlu0kq1UEWcpT20vGpHTc8BA3SH17P+lKt2I4mnNzd0KrVlfqQ0dVEQ
	 qNXt+V1XPJIKw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:29 +0100
Subject: [PATCH v5 35/38] mm: avoid use of VMA_SPECIAL_FLAGS in
 migrate_vma_setup()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-35-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
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
 "Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, 
 Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
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
 Wei Xu <weixugc@google.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
 Xu Xin <xu.xin@linux.dev>
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
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Bert Karwatzki <spasswolf@web.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1717; i=ljs@kernel.org;
 h=from:subject:message-id; bh=iFGL+FHCILhy9SDbSepqrBsRxsucMM51zxGaU7Q5a2U=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sxzNUrRETtx8MUkj2Qz2awP1zfzxao1vmj+t8VGV
 NbijqNkRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACayM4Dhnw733085YbIMFdEi
 PVv/ZxsV/5xgZasU+Htn+Z5t6crtUowMqyL/vzAtXu/fPFO4KuxVZ2bG1YptJTZPP+xU/qbimHy
 HFQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 02256A0006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: df7xg5j4isqgcfg7b3t6mw5hzj5youa7
X-HE-Tag: 1791569810-163543
X-HE-Meta: U2FsdGVkX1/HvZevS7XLJDojUgXjAg84jQyOJCm1BtVsE4QT47Eyt0DqVLhehOBOKfTpoFSbgEYjOtIqtG2Hwo5kHZbjqfDBIzGsp6U2qrrVDXeY2R4uWdBQdkEKjGIhbEAd+GOEkXZ/gbLCVAPF5aZw5X2xC7CsxplhqFq5ICqTeVUdEf68ExVPUJ5zppIATfKxG7VK+6WLnq6HX3KDoBFBqNM7SIM4d7sGtmvZrlQJ1z5faFs+/5xTYpfm1ArGipoPvoG0gB+1+iCsIZjjE1NKDDjZeZX1T6t8HEYBSq220QqUnjY2AAh2QI7n/UKOY2DtlpXdxQOwWxTYPeQCjatByCnvJxLmz8IpwYte/31JAwCFlpU8oMP1/OF++4t/mEB0/OcHNIQI1PKzj7q7G7fRrC4yjxLxV1SOn3HTHYKNNOhvhjfzKf6L5X1JMHSkzipbizMlIFjO9nwFJ5DwJkedlE5pDARc7CwZ3b1aNDY7BBR4wBEBWTXH7BFQdAcYQYoBvY/pFCjRe3hYXbqCWvIzKWJXnQw802qJ+JDWEoBUx0aa0SDHmWhfzuh4Ph0LZuLdR8FRYM1Y+ISKT3DbFxl8v4X/Q4LpIg/tueFGc05hv1OeJc8rbQOUbfk7CY8h2KQUJdIT8T9pjQAiPaQBwNI3Qm1HRMM7moiDng+pKzAFySQyH/y5dPfVsHzCveygqM4I1CqqBT4CYKGK0KfiapwZZZxTysADJDAEjfSjcHaT8jQBo+da6QcVxy2wHazO/+oiq151rNraegH/rhLnTYhdKSZrYiuAPJBwwStmw7XmcsHpmHSgnohh4FutMQ8ZjD8tSpTtk19QflLPrtH94Tw3KdExoEtaMsSGIEIe7h4zi656m+cW7N3QSvvooSQT2WU/ihQSVDDd3ya2+SdUBSjCKGMa2MEZouKeCo6ta9BerwZqjeh9V6XohhCzIOQQ+GRj2wnyOqQ8NSOQLYN
 wdTTeIqo
 227gm6jBUxIX0ra2KoyGJwD/92CVNLKPP34FHbFMGXXDU2EuTZSVnT6DCyIHJqR2fQ0IEUGXo3XF6uiFhwj9nq5l2sY7XERS7dULeJ+vjCHAE0l55iwCc2bxJgkMXivSLCxAiMPbrwCXd1RJB+Mk8yl09nI03O6YnR9drOU0mtSeFOMVWqt9HsyqYW1Eo9Mwiastcr2Gn1iuCVGDvRkQJldnt+oEHukDYQzu6b4NUa3edRye/ukeZj042kaEEyfEjZWg4gDeVjYzNcFwbSTeHjoiC/pZsFX6UUH+bOxNhnNFpf4xMQ/zFRFN5mKTd5CTtxExyfoxL8siTD4MVfqqpmmgx/jCQsW8u3UCHLUJ8n3r1sJHSMYbAFks3qknc241X4FJICAeM68YM1JmRaZI4xSNa7dIXDwZUZJHqe52LYdfoFRmlopaoLrXWfly5SlU4r73ZtRgzfZzNuEuoTLPGLr97qwFoz5xYrLeFQHk8DMwX5W1OeiJv2aM6M0H6uH7ATaqYh8y3k5V8mmvWDY/nRPCqvNd+ShJzT0a8Nd9iRjthxCyowJdYQPVpX0QbLa66ZZ43KgSIDRDWSQZYwmOdjZ2jI7H70hSfD7VyzCetCw4+1p8fhuP8iBbgWVCiKnHEfLWH1OHWhhF6V6+khw42BJiOBMJ/n47QwGRR3GUcxlezaWEeGCdUEJDUrQcBe4d0jsz60pND0FFSN0wrqAdobZRO2fQWbtEESPlFSWUuzMhH0/GN+nj/FWhyO6MD9Bv+tbMeAr9KfElM6Zihg5ITvIUcnsqRWmRR/sPcori51/LSBWJdc+2LMOnZJ3MGBH3McpyO98053/73KEhp53xmPqvTjIMP+vD9HHp3qG9SITphGMA0FSXGquDYyOqAsV1JRbOe3KeIc/MQAz2pRD96fML7EbNLOB/Fy7BTSes9l8AkLuYxpT07pvTDGhGrytEyV5Dc6vJCUP0XwVN5kZVVe6gzSSmm
 c+n146vE
 THQCFhS/cfCQBynXic1/oes0tC0JwLaQHDx9Oy/2GSF1hQLpecdTWGAaqWTwbqel5eQ2oNWu3B/erX8pk83OhfWkHyx+Vn716pTsAd+AXX+6wpO+ozl884SkhqzX/53wp4B8Npc/fy0KiZc2eiAai9z0mEbBw6uiJ9WcRS7sLZD/Dr4PbfJ/sePKFpjRysh7MAJLkfS0KjEnzbl4MU2c3OpCFcu4Vq87IIIWwqy4tzKFY6rotBasx8z2VVyx3ru9n3AG5y4pwUbvYYf8Iu+UxbMSRGxG1SjM8cEFifzhg2CMwtzvlwxv4X+zjJhieJyFYwSahks+Ck/6/1KvD70nMgOTc7DmnGX1RzPJa4bHkM/YgLOal8/A+WydF4xRC59TSsyb29AByJrhUvz3YvNp33vxFYGzUH3Q+UWvZVQNp8QyqLCRJ+YlI4fNWB9ikzhD0fIOtvjKNZroZjWiPQZBlKUYnLj4WpsshH8MUDU+XrfjtQl3gnsFMNSwZt6QqgQiFQzg90lMRbeuZaCdfcL62kAu5JdupCvvuLQYYKw/m1oxVYuNqzxltIK3B6MPG2JX5ydaxPmChZN29+TEjwKPqrT1XX2gKFwtyDjt4HefRArrqquY1hFQydVznuwD7B9NAZC4r6BROVI0nPTnhzRJeCLwpLAM0PnsAiZfsZvJco7KCUwn14F31ltDZbFG7poEHKVvPz9/ASr4Q85OCstMqwLO09qs/5fse6wRSx3LWhlHsZHxG6uCdjvEuxcwOnv0zPL/O4AgT+dYz6yEPYR6XJmgfcIX2Nh48gt6fx0LqB+gAbtM2jbwcqKF9Jk+ezCM5eGheJtQmzf60Dc1ShhCSklPypl6BiEBbZIA0F5NmTF0VCthefqKfuTxiDfXB6hiwDOqmDma3+P0pbBxjV/PgLMeSqTmunx+3vIvMEebfjFyughBfTK2T4VB5dthRU1MyPOWxgZsiGd3lAzQSXPduQhGZ4SlQ
 nBcnZY9W
 oNy3yS0NJaR7aczNYntqtRDSVOB6rm6snnfm7uceenUCloh7xnRzCNyK5TCIcDe4B07EU3dkNTyLWeaQ5V+qmTAio1zQrur3QALmKUDCIj3ZQz9L0UyW6uJ0+cHIFHDNJ1l8tS1lfosMxy44lNLxGt4S5mQxluKl9SOv3vddAISp+lQLuQzW8PCQkAua55fVOxzbiGkQRNfzA9PaKqtrHnujChZ5ZYIDKthrJUg0ZNlXtVDTTCycfV26QegdREEBATNf0jhLcBpGOj+NsTbNqyh05UIFLPVf8kASAxKvK0JtMe2akwn6iP09Ir5XcfKgmNV2hZmPNsOmNHlPVzihTtzB7TUxL6Ek1zCKIo97kOKm3CECneItXGLZUSwIiaBwJwr/S9+gf8YsI+xChBstq4LgcFfFhihkMyPVJphERrciCWxq+duUKSZu+d/81gYkuw0mRLfYtOUh/dXWVLOuKAI7PchTsSviZcRdo5rCh1SmzgfP3QwKs3sydFs6uRjk4IjxEU+fUSD9YB8Rc/R+CKFbHQTamCxiupDsA/2n/kFumxF6c8rJbUrmnveoztj8/f0CyBlizkp/edU6sfjCG/1bLZms79Q9c2SNj8LxgfwxQynHAnC1anvzKY4sUl5vQlBDiOVNj1t6LC/j1i7daLbMc0Z1xKL5W2HnAkD9n2OkpfoJ7KtGxasWN4aMPLMucsohTls07Uc9PamvXZNHvtyu/+RQI0FR65bNc8VEiwEAQYksUoUIc9umkGNdcr4+fdz9LgeA6pAVPhlzgvfVIlFmicOxJLvhhxQmdzQcAsA44Ip6umAbcRpG21McTeyDQETr4A4O1CBzMPCTFvrl4409QUsg4ddVw7ibJL2KXydv8BWuvI/Saxh8nx773JWD9kU8M2ujuwpEHbztpzRkEpUwf8CTXvNlk1B/nYlbZr1aZOEn6mfGPo1xcpF7E8EeVgXAU36U4QdjAMDmDed6IrySFQJKW
 zOvpNU2N
 2DwGG/wOQuowNBaVj5cLbf1ppg46vPoV82iNhRCdw+jI/KXFstrQdsT2CQ1b3bfm9uHsAyVTi1IAMwTM9/aPa5qtv3cIYyRNROq9ZjbXANG4/EY3PHq6gStz7Ibv0sKZRHfxIa0gFaaR8duStDfpib4pHi2ni1sf1dmhD75zeJtXdy0ICr2rp1332IOKxXZvDmvI8PBVz5O6F+80XwKYCMJe3CT2fzqMgU1aAZDF621i6SIy0sD5d5niSuXeGwpS7EhXDz1hK48MOQYQYCluX4Yva7zwDrkNdobrv3WNSKkXacPOeh9WVQVmxKey7bBbuDddUxMSyEYN5bMYbGG6s72QHDNS+IHNf0oU1OcOHZtOzWsxzykleSeI/bIhymmPnaYXfXNw8XkbLQexrvA19nnqjoGSZpeTURQyphfbdaMATMTM47c+I1yTz+/fSf5Nw+R/1sR/IetcwSgTLHVYMHCHApcllDink=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we have the expressive vma_is_mm_managed() and vma_is_fixed_mapping()
predicates, use them to determine whether to proceed with migration. This
drops the VMA_IO_BIT test, which is safe as mm-managed mappings may not set
it.

hugetlb mappings remain excluded, as they are fixed mappings.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/migrate_device.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index b9c453c28795..289d7b08ace4 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -739,19 +739,21 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
  */
 int migrate_vma_setup(struct migrate_vma *args)
 {
+	const struct vm_area_struct *vma = args->vma;
 	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
-	if (!args->vma || vma_test_any_mask(args->vma, VMA_SPECIAL_FLAGS) ||
-	    vma_is_dax(args->vma))
+	if (!vma)
+		return -EINVAL;
+	if (!vma_is_mm_managed(vma) || vma_is_fixed_mapping(vma) ||
+	    vma_is_dax(vma))
 		return -EINVAL;
 	if (nr_pages <= 0)
 		return -EINVAL;
-	if (args->start < args->vma->vm_start ||
-	    args->start >= args->vma->vm_end)
+	if (args->start < vma->vm_start || args->start >= vma->vm_end)
 		return -EINVAL;
-	if (args->end <= args->vma->vm_start || args->end > args->vma->vm_end)
+	if (args->end <= vma->vm_start || args->end > vma->vm_end)
 		return -EINVAL;
 	if (!args->src || !args->dst)
 		return -EINVAL;

-- 
2.55.0


