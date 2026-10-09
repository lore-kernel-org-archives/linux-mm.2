Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E9B1CA9EC1
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 393C26B00A4; Fri,  9 Oct 2026 14:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3446C6B00A5; Fri,  9 Oct 2026 14:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E5E06B00A6; Fri,  9 Oct 2026 14:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D86416B00A4
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:07:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A4BF1C3C9A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:07:06 +0000 (UTC)
X-FDA: 85303869252.06.214C0C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 76C394000F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:07:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PexwGEWK;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569224;
	b=ZKxqwYJ2r7yUuRktXOPrNeDuQx+n8ODEUwsJy4LuwsnJ/VHUd9OcAJTEUzvIsUIfqKlDNN
	V0T9vjekMlg8C81wizg5F/kwIBv2tyInXyDZqqOm1rmDhLILx4/Nhht6HRronoGtb+CvMf
	QCvfoVrAc+rHWdHjqHWGJVOst7p4gPI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PexwGEWK;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fMouXbG2h0wxZaoIKIXRoNcgC8j9y9aYKzl3T1PtfP0=;
	b=U6SdFuN35htzwUSTotEYkSo69Y/sDHoovXlQ2Q+EQHEhFK+FsuyYNfDMROc/V4CDawlBqW
	uK8fEW2X5pf+LqCNNzzvqpeNjtUZWp2GKUspr6lALAlU/wqOrqOk1hf/zJpoHKlTEVj8Dr
	eiUt+eJhw7pNVFUSCXYeHmjijozRrYY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC5A641AB0;
	Fri,  9 Oct 2026 18:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C911F000FF;
	Fri,  9 Oct 2026 18:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569223;
	bh=fMouXbG2h0wxZaoIKIXRoNcgC8j9y9aYKzl3T1PtfP0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PexwGEWK02W1TNKpuKKW2RfGdx2k429Zda7eTXtEq+OTDlLAYvBo76PDgf4vE34B2
	 iLXCN7yVz39l8O2tYOCm7n6hw1vd9Qrp2zI0ZH5cHDe3f635t4P9aI/8toTLJdGZZT
	 tEu2/Vddj0lSlm2urNsWNUitt7lvxFPqxIznviO4z+9dBtJg4n2NQnp/mp730LDAwz
	 WG7Luscx6Um70OTAzkfx28pp+SuNVlbAPieAXuMrY64huXTUdNA2+ckrqscKgKlkJb
	 E1WCr32Vz32RtPQLRhpaCoTyPGaO85rsIHfRrE9fRiZTSIq8Z0i9u8RMDMdEj07Y7S
	 WBYeev6opR+Fw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:01 +0100
Subject: [PATCH v5 07/38] mm: add mmap action for discontiguous kernel page
 mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-7-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=15704; i=ljs@kernel.org;
 h=from:subject:message-id; bh=HwbEev4oA39NY0j7YXfvM4yzFXZ+XMBaqJEHjkUqR10=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6swUW7nBK25XjVbIvfq+qetPFQWf0Jt2L//xBelJa
 zl9Mh9YdZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAi0RcYGa6X6grPLPvz9l+p
 g1H7UuXaKRf3b8r+Kxt28U7PlocRj50YGaaLhbk2Hc+fsTNw0+r/6jOv9Isr84pLiPR/fnHx5ZS
 LuiwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 76C394000F
X-Rspam-User: 
X-Stat-Signature: 4d6apee1gupxf3ooss661z39z9d6mffx
X-HE-Tag: 1791569224-521498
X-HE-Meta: U2FsdGVkX186EfeGQ5yOlvxG5PPsRy/k4EaYPn7+Q2k1rLrWkFOxKU9Kk9nMEITgLVdza648Wk+QlvVbtXH+4zcMiema5Wh85kaRfS6Ej2Op04ySNBG6tPXDCRuQVWREsHbQ292FeUli4ugiNblzWSA2yDrD9Snfso8lMlXVqTPpxsxrmK5FS4FBRO/UJ80aAZsZUYDSjN3Cf0ig/x2M13bcVjDwonxpZ1awHlrlHxQVkdv9zj6y+N+KoPQwBIBDO+eKkDFGptPPZQZfSIrEeBmVaHu+dpsFuulQFZA2qOCjEuhdthacv5+tT/hpzkR1HpgTwCZshU96noZwDBiuNoMhHi3fxwh9nWTkOYb8UFiQXCz809PR5b9pwKPXsxsSU5exf948FHRXH5BAl5+CUwoErNQcDi4YmE3LsZBB5PiGRGzLdL7zo00XQjjWTdCw5GcNqMrPQyOTUD+By8lcJEWJGOfMfMnB20yRRvjxiKZr+Ue+toZRlicCuAXydWANX4xgBCMa0drbWYBWNzq0peIwWbY0PC2GqzJhFZ0ciiVJlN7oH49oMfqXxtONNDxbO6JwVunPF8GD97EKQ4c5yo4zt2X8uxFzwJBQ/juLnCScgZH5yCnVrl2XP1P6qIJ65kw2KAifzY2Ghnn0eXe/+PqwRDb9W+q04hMZvtpkHpS3OHFYrakMtBuV+3Ba2u6dAvngc9ntdKN3UZuSZV9UWq6pi3rIYtpO8fvAY3YerTGDv483r/htPpOjcz/0rO+AsSEoSwr5moWh24lpl+DSBwOl7WOxZxQD88zkXc0ha7elvLCgnNPgIxY77ern3UIXO9eRx5ChgmZC3n/W66saLlSBt8etzF+SK2x6+pklV4OsNqW4LjpY8oyOuPT+WYojKYO0l6li4dRb/4PM5Ld0mDKd1/7tE15UvjXIssV+6Ei6ygM4lJ97HqGSaf5qRxhrivC1ci+eFDB+R6cJ0v2
 g8wWGvQq
 AtrxhgedpC/ZrY454yNMwM/Nk2X5ZPk8w66JbOZIrcy+dM/nlWx4IFn3vkDmzzGVaWeiLIQLd9g64rx/XMnHZQS8oXofCOwhM8VNkyfmUaDI30e+9H03fwgcX+5r0lu5wBF6V7vlV5ZTUdUomHOcx+3pBw0/M2VJbrMnsi3vP0ojjqG/bXvdbXOH+y/jB6UKCZ3l/ao2/7zgo11+QEK2nSO6J9s9XArVtLgSQ5D9QI83BK/OvwbOhfcQpzb9/LuLrkt4Sj/RDr4w9cXSgGmXqDYxJMSEQielXwKnApfLi5jWYLoiLhwT9GPEqcow77Dsrhwuft13HmIxZMNFbytTBmhcD8k7AngTz5pYZ7Y5yepeK9Eiag7TBTQqjCKm0ccsDzX6ZjOMC/F521GpUA4p8j+wQyVmZH9K15hHfXRqwe1sh6zCLtA+S8q4DiDDGNNQkQUvRIIk2qQJGb1E+FcMeyH5HVCf6oOtZxjPCMB89XEd9ew0BIMmsKAbQBExoz8zVEdRrV4AW74eWnO79MyOGtz9AESLE6BcMng0dLJyr1Mp4BZBBysYb+OoHYuAEpc00aQan8/G32Y+wocRxaDWv87Br1bq89FmIZwzL3Gw+qHlNJp+xXQ5MzSMO5vAdTUbp9EcCD/y9cD2oNhfv7X/W37L8sH82KK9YVuNFr1wWE65krA6tfYCKSAEQmAi0DO3P1xgr2Kl5PBC5PXhbgfkjRGvXGMv7HFJgzTdK8KnhMsR3KW8WIvlfggXJ9r5I0AzIRGY5iyl3ONKbUWcFonDY0KNG/SnSC8c/pRru1K0AAX9ud/wXtzRV4L1TKlmW/iLC5dXl4isIRaRq93+wZJq6A+hxw3Er3YIbWQ7maF94oLItaVAh9/xp0X99cQc7nBRK4wye2yge0z5uZu32mv2NSDaFMVHAQv/N8LUamQjbCEyaRdcRWNj3bGbyuhHh9a6rECoqFm3+7Rk8j6P2yVjhBdS/RCyb
 /GSTU03p
 Y0MQlkfEFL+7KK5JQjT0OMrSCxreEbZMn/rtBn20u93EG1I4hT8EHg1tRWfbNKmNDoGHsKvREeWqeCW71zNaL7eQfKYnQzcmY4Ob7Zw/kXLPFwzQZaRsFS+QiCoRb9mHQOxzG/XM1wU1yjVzcoErbH/EpKvZlbLBswy5dRSLqxQWVMlgGvhhXCekRUrXX7x5JAx528qCAWTnqirkCOyKVisyRm7Q8rlEgQ4b8Vftf6CksQDu3PG8PeuOmq8a2v6IocmTdgawA9y5fysxCfG/cTJze1PyOapNAKl83v4qBuT3Nduh93qh2f7/TvAJWTwoTocCJyLqSHOIPUMLnC8iNYm4Ejqnw2F2Hci7ZsIiDWhHuNP4I9cnfXTuEWgsrJkA7cWG1X8T9pXwnmAoaX0MP4lPMdeVmwO35Gdeb00cy0dgm34G+RrfcEUkZi8ExkfVPnnlxnMD+QWQCXXotWsOCjD/KGeH6U2BTEmtsJ7qxR4K5UuqBaaEEwdfksByz2sK3bvBdI9BNOgQYMI3BB/AFvQSdAdAYyiKZ3XSEeCLLWcRWModHYNfsSGIn+TAEfS1FBNvwzpKa1+J0Py0P7cMzRpt7vbMIq5PYHO3znmuw7s4eoq07cn1a0KDZnRx0iIfQ4uEYKNjPrlZHlM5BFevY3nlyQOIEuKcfMrHEXboK7L8sdeAx1C2FDfujhAL4xHwLGTX28QdIosqg6/X34PXxQKn6SU8B6KzNLwiTlRgy53uyupDi+3a/hgnvrOpbjlnao4HaH472x14qasZalGZgFfEAe43+XKcHBvTzqnDa4cWwylHhsmA4S8+mh9OxuMlcRPVKMAqPJ+8n+Xd0jCjc31LvDwZ7dOeUBsAjUgt5jPLfv2qwCxU9NDAvpYma2q+pR58/OE480uK+7fBoDViYWSxmOCnRY9+SGWQsFNS5jHdvVoVj2vla20ZruYq2ZPwUg7A9GvsQztdlWTnda6KP4KmIauN9
 XB6s9K1+
 +Fd84hrxVUGglX/1t2dlpeWoP9/WzafD+un7YJuSJcjBkvV0uaF4GWKK/NtQVLZmiAKF4n21ixUCqBdzLEPcE65+un46S4YdHvsUgNXdoia91Cpe9SfvUyLV5ytHifoQIHKgATyLHq4P/S/FRRicCRIra+qCYUTwhy1lgC7tY5s9LIlF/6tos/BBRgAbUH52GDWQdAH9945JGVF10RtpYOurXbCpN7I88OaDhc2GVJqtSo+4EfdWEQK1z12qdAoNfyZlVFYSQe2PZb7n8uVfON72nb6PQnLnbs0f5Z/ybA+L+3IdAnfRwXP7i4eIln5JJWUJxK8VMyAqQo89IzNNSAzV0v6ViJH1Nj5xlmLX3Wwgsl7MSn2SDBvxlqbiWUdI82JvAFMopr9nvPIj/v9jUZjeZtRF21cYMUheoreKg8ZO/dcmopWgXeZAmgfE7RQqD/V8uqfDsL6RPewGc2Cr9l1NNa0rMSX4xJ7olIKbu6nBBOfjoDxBkTF6IURhQ3eALyvgavaCTvZnybyDsk2wjhdKFBBa5a1wPB7vKbu7WTkZcqU/+V3V50oOQy9PvXaB/XGKn0knIYY76dGiIPe8qXmPuwCX2W2W6psHCjjcdnXed9oJV0cbhGhiXLGUpQ8QEjDdm3aPykyr+12e3znPe0iszvAtaLMRM3uJZD6kBtNBkeMWY/HjzZibCHQAKktxIuZSAg2drW/7N8R28LCfGrNzuPb3ejbLEIvecmnqjjnt5ALaRbnXkz64MSwOyIEO0TWJE5Ec8INJWwvyM6FPsgtcXJh1CnoitM+04mVN3eA5U9mKYfdADrkPCUdwS0kYTASdyD2KEdY0+0iKkKTvjSfT4zIH3TocZ/g4psX00vuYYGhkT5CJYAneq+iRk5n7aaliPajXUi3dvz/BdB9/SEI5Iq8lBE3I6yb8kCRibBH0Y8KjiZ7vlQWxqRFZ06rCJsrGylgUTJaOv4DVsSHHqygJul/Z5
 5wwyyA3p
 PIgJs4OSkNincd6nmXZA1iGiZd92+U35Nl38kQxUTMC0YLUQXm/vYJqVRdsfiNd5sA+WVYq5Xbw13RM+C3hfIxf8b+AdWwMzs14ZdkDY9I7RlqvSjKbekePGOGMEQYrHaSYP2OBFXObbOBRBaV3T8bjXdwOQqPXDNO8mbYFI4UPGfUSXXrlzr6ie1auTiBq66XQfQoXjSoWvlMfaYqDKLsv22zupIxFNBpYMWaTDQbWqw5qRzgow7X5GsOZLVQqMT+8dkMfEfLOW2kDQEjpBer0fMIjq3i739NHYrtRPm6calrLgwwmzVRmVKmosdoDfA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing kernel page mapping mmap actions allow for partial and full
mapping of an array of struct page pointers.

However some drivers require the mapping of discontiguous ranges. Permit
this by providing discontig_kernel_page_ops which allows a driver to
specify how the operation should begin and how batches of pages should be
retrieved.

It uses the minimum exposed interface to do so, providing address, page
offset and both vm_private_data state and a local private state object.

ops->init can establish state for the operation, and ops->get outputs the
pages to map and their count. Should an error arise the core unmaps the
VMA, invoking vm_ops->close, which is therefore where any state established
by ops->init is released.

Also update the compatibility layer to do this too via
compat_mmap_action_abort().

Batches may not exceed the VMA, but may map less than its full range in
case the driver wishes to allow the user to map an area larger than the
available data.

To use it, users invoke mmap_action_map_discontig_kernel_pages() with
initial local private state and a set of operations.

Users can then use one of the provided helper functions to perform an
action:

* discontig_kernel_map_abort() - Abort and leave the mapping as it has
  been accumulated so far.
* discontig_kernel_map_page() - Map a single page, or a compound page given
  its head page.
* discontig_kernel_map_page_range() - Maps a struct page ** array of a
  specified count, mapping only those pages which fit in the VMA.

While here, update vm_insert_page() and vm_insert_pages() to assert the
mmap write lock is held rather than the bizarre assert !mmap_read_trylock()
and use the new VMA API so all code paths are consistent.

Also convert a BUG_ON() to a VM_WARN_ON_ONCE() in vm_insert_page().

The userland VMA tests are updated accordingly.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              |  45 ++++++++++++++
 include/linux/mm_types.h        |  44 +++++++++++++-
 mm/internal.h                   |   3 +
 mm/memory.c                     | 126 +++++++++++++++++++++++++++++++++++-----
 mm/util.c                       |  27 +++++++--
 tools/testing/vma/include/dup.h |  11 +++-
 6 files changed, 234 insertions(+), 22 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a1f2d375cf7d..97e1eb4fe3a4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4647,10 +4647,55 @@ static inline void mmap_action_map_kernel_pages_full(struct vm_area_desc *desc,
 				     vma_desc_pages(desc));
 }
 
+static inline
+void mmap_action_map_discontig_kernel_pages(struct vm_area_desc *desc,
+		void *init_private, const struct discontig_kernel_page_ops *ops)
+{
+	struct mmap_action *action = &desc->action;
+
+	action->type = MMAP_DISCONTIG_KERNEL_PAGES;
+	action->map_kernel_discontig.init_private = init_private;
+	action->map_kernel_discontig.ops = ops;
+}
+
 int mmap_action_prepare(struct vm_area_desc *desc);
 int mmap_action_complete(struct vm_area_struct *vma,
 			 struct mmap_action *action, bool is_compat);
 
+static inline void
+discontig_kernel_map_abort(struct discontig_kernel_page_state *state)
+{
+	state->action = DISCONTIG_KERNEL_PAGE_ABORT;
+}
+
+static inline void
+discontig_kernel_map_page(struct discontig_kernel_page_state *state,
+			  struct page *page)
+{
+	struct folio *folio = page_folio(page);
+
+	if (folio_test_large(folio)) {
+		VM_WARN_ON_ONCE(page != folio_page(folio, 0));
+		state->action = DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE;
+		state->__folio = folio;
+		state->__nr_pages = min(state->nr_pages_remain,
+					folio_nr_pages(folio));
+	} else {
+		state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGE;
+		state->__page = page;
+		state->__nr_pages = 1;
+	}
+}
+
+static inline void
+discontig_kernel_map_page_range(struct discontig_kernel_page_state *state,
+				struct page **page_arr, unsigned long nr_pages)
+{
+	state->action = DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE;
+	state->__page_arr = page_arr;
+	state->__nr_pages = min(nr_pages, state->nr_pages_remain);
+}
+
 /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
 static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
 				unsigned long vm_start, unsigned long vm_end)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 9ca2ea3664bc..0cb4f9603956 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -818,8 +818,44 @@ enum mmap_action_type {
 	MMAP_NOTHING,
 	MMAP_REMAP_PFN,
 	MMAP_IO_REMAP_PFN,
-	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
+	MMAP_SIMPLE_IO_REMAP,		/* I/O remap with guardrails. */
+	MMAP_KERNEL_PAGES,		/* Map kernel page range from array. */
+	MMAP_DISCONTIG_KERNEL_PAGES,	/* Map kernel discontig page range. */
+};
+
+enum discontig_kernel_page_action {
+	DISCONTIG_KERNEL_PAGE_ABORT,
+	DISCONTIG_KERNEL_PAGE_MAP_PAGE,
+	DISCONTIG_KERNEL_PAGE_MAP_COMPOUND_PAGE,
+	DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE,
+};
+
+struct discontig_kernel_page_state {
+	/* Map state. */
+	const unsigned long start;	/* Start address of VMA. */
+	const unsigned long end;	/* End address of VMA. */
+	unsigned long addr;		/* The current address to be mapped. */
+	pgoff_t pgoff;			/* The current pgoff to be mapped. */
+	unsigned long nr_pages_mapped;	/* The number of pages mapped. */
+	unsigned long nr_pages_remain;	/* The number of pages remaining. */
+
+	/* User-defined state. */
+	void *vm_private_data;		/* VMA private data. */
+	void *private;			/* Mapping private data. */
+
+	/* Users should not touch these, use discontig_kernel_map_*() helpers. */
+	enum discontig_kernel_page_action action;
+	union {
+		struct page *__page;
+		struct folio *__folio;
+		struct page **__page_arr;
+	};
+	unsigned long __nr_pages;
+};
+
+struct discontig_kernel_page_ops {
+	int (*init)(void *vm_private_data, void **private);
+	int (*get)(struct discontig_kernel_page_state *state);
 };
 
 /*
@@ -844,6 +880,10 @@ struct mmap_action {
 			unsigned long nr_pages;
 			pgoff_t pgoff;
 		} map_kernel;
+		struct {
+			void *init_private;
+			const struct discontig_kernel_page_ops *ops;
+		} map_kernel_discontig;
 	};
 	enum mmap_action_type type;
 
diff --git a/mm/internal.h b/mm/internal.h
index fc4e249e2343..557e629db8c5 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1515,6 +1515,9 @@ int simple_ioremap_prepare(struct vm_area_desc *desc);
 int map_kernel_pages_prepare(struct vm_area_desc *desc);
 int map_kernel_pages_complete(struct vm_area_struct *vma,
 			      struct mmap_action *action);
+int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc);
+int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
+					struct mmap_action *action);
 
 static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 448342883e9d..e5c1d1c35bc7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2599,27 +2599,34 @@ int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 
 	if (!range_in_vma(vma, addr, end))
 		return -EFAULT;
-	if (!(vma->vm_flags & VM_MIXEDMAP)) {
-		VM_WARN_ON_ONCE(mmap_read_trylock(vma->vm_mm));
-		VM_WARN_ON_ONCE(vma->vm_flags & VM_PFNMAP);
-		vm_flags_set(vma, VM_MIXEDMAP);
+	if (!vma_test(vma, VMA_MIXEDMAP_BIT)) {
+		mmap_assert_write_locked(vma->vm_mm);
+		VM_WARN_ON_ONCE(vma_test(vma, VMA_PFNMAP_BIT));
+		vma_start_write(vma);
+		vma_set_flags(vma, VMA_MIXEDMAP_BIT);
 	}
 	/* Defer page refcount checking till we're about to map that page. */
 	return insert_pages(vma, addr, pages, num, vma->vm_page_prot);
 }
 EXPORT_SYMBOL(vm_insert_pages);
 
+static void __map_kernel_pages_prepare(struct vm_area_desc *desc)
+{
+	if (vma_desc_test(desc, VMA_MIXEDMAP_BIT))
+		return;
+
+	mmap_assert_write_locked(desc->mm);
+	VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
+	vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
+}
+
 int map_kernel_pages_prepare(struct vm_area_desc *desc)
 {
 	const struct mmap_action *action = &desc->action;
 	const unsigned long addr = action->map_kernel.start;
 	unsigned long nr_pages, end;
 
-	if (!vma_desc_test(desc, VMA_MIXEDMAP_BIT)) {
-		VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
-		VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
-		vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
-	}
+	__map_kernel_pages_prepare(desc);
 
 	nr_pages = action->map_kernel.nr_pages;
 	end = addr + PAGE_SIZE * nr_pages;
@@ -2640,6 +2647,98 @@ int map_kernel_pages_complete(struct vm_area_struct *vma,
 			    &nr_pages, vma->vm_page_prot);
 }
 
+int map_discontig_kernel_pages_prepare(struct vm_area_desc *desc)
+{
+	const struct mmap_action *action = &desc->action;
+	const struct discontig_kernel_page_ops *ops =
+		action->map_kernel_discontig.ops;
+
+	/* At minimum need to be able to get pages. */
+	if (WARN_ON_ONCE(!ops || !ops->get))
+		return -EINVAL;
+
+	__map_kernel_pages_prepare(desc);
+	return 0;
+}
+
+static int apply_discontig_action(struct vm_area_struct *vma,
+				  struct discontig_kernel_page_state *state)
+{
+	unsigned long nr_pages = state->__nr_pages;
+	unsigned long addr = state->addr;
+	unsigned long i;
+
+	if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGE)
+		return insert_page(vma, addr, state->__page,
+				   vma->vm_page_prot, /*mkwrite=*/false);
+	if (state->action == DISCONTIG_KERNEL_PAGE_MAP_PAGE_RANGE)
+		return insert_pages(vma, addr, state->__page_arr,
+				    &nr_pages, vma->vm_page_prot);
+
+	/* Compound folio - have to iterate through each page. */
+	for (i = 0; i < nr_pages; i++, addr += PAGE_SIZE) {
+		struct page *page = folio_page(state->__folio, i);
+		int err;
+
+		err = insert_page(vma, addr, page, vma->vm_page_prot,
+				  /*mkwrite=*/false);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+int map_discontig_kernel_pages_complete(struct vm_area_struct *vma,
+					struct mmap_action *action)
+{
+	const struct discontig_kernel_page_ops *ops =
+		action->map_kernel_discontig.ops;
+	struct discontig_kernel_page_state state = {
+		.start = vma->vm_start,
+		.end = vma->vm_end,
+		.addr = vma->vm_start,
+		.pgoff = vma->vm_pgoff,
+		.nr_pages_mapped = 0,
+		.nr_pages_remain = vma_pages(vma),
+		.vm_private_data = vma->vm_private_data,
+		.private = action->map_kernel_discontig.init_private,
+	};
+	int err = 0;
+
+	if (ops->init)
+		err = ops->init(vma->vm_private_data, &state.private);
+	if (err)
+		return err;
+
+	do {
+		unsigned long end, pgoff_end;
+		unsigned long nr_pages;
+
+		/* Default to abort. */
+		state.action = DISCONTIG_KERNEL_PAGE_ABORT;
+		err = ops->get(&state);
+		if (err || state.action == DISCONTIG_KERNEL_PAGE_ABORT)
+			return err;
+		nr_pages = state.__nr_pages;
+
+		if (!nr_pages || nr_pages > state.nr_pages_remain)
+			return -EINVAL;
+		end = state.addr + PAGE_SIZE * nr_pages;
+		pgoff_end = state.pgoff + nr_pages;
+
+		err = apply_discontig_action(vma, &state);
+		if (err)
+			return err;
+
+		state.addr = end;
+		state.pgoff = pgoff_end;
+		state.nr_pages_mapped += nr_pages;
+		state.nr_pages_remain -= nr_pages;
+	} while (state.addr < vma->vm_end);
+
+	return 0;
+}
+
 /**
  * vm_insert_page - insert single page into user vma
  * @vma: user vma to map to
@@ -2675,10 +2774,11 @@ int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
 {
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
-	if (!(vma->vm_flags & VM_MIXEDMAP)) {
-		BUG_ON(mmap_read_trylock(vma->vm_mm));
-		BUG_ON(vma->vm_flags & VM_PFNMAP);
-		vm_flags_set(vma, VM_MIXEDMAP);
+	if (!vma_test(vma, VMA_MIXEDMAP_BIT)) {
+		mmap_assert_write_locked(vma->vm_mm);
+		VM_WARN_ON_ONCE(vma_test(vma, VMA_PFNMAP_BIT));
+		vma_start_write(vma);
+		vma_set_flags(vma, VMA_MIXEDMAP_BIT);
 	}
 	return insert_page(vma, addr, page, vma->vm_page_prot, false);
 }
diff --git a/mm/util.c b/mm/util.c
index 1660910e2a22..5b2e1ab4aeba 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1401,6 +1401,15 @@ static int call_vma_mapped(struct vm_area_struct *vma)
 	return 0;
 }
 
+/* An mmap action failed under the compatibility layer - unmap and close. */
+static void compat_mmap_action_abort(struct vm_area_struct *vma)
+{
+#ifdef CONFIG_MMU
+	zap_vma_range(vma, vma->vm_start, vma_pages(vma) << PAGE_SHIFT);
+#endif
+	vma_close(vma);
+}
+
 static int mmap_action_finish(struct vm_area_struct *vma,
 			      struct mmap_action *action, int err,
 			      bool is_compat)
@@ -1412,12 +1421,13 @@ static int mmap_action_finish(struct vm_area_struct *vma,
 
 	/* do_munmap() might take rmap lock, so release if held. */
 	maybe_rmap_unlock_action(vma, action);
-	/*
-	 * If this is invoked from the compatibility layer, post-mmap() hook
-	 * logic will handle cleanup for us.
-	 */
-	if (!err || is_compat)
+	if (!err)
+		return 0;
+
+	if (is_compat) {
+		compat_mmap_action_abort(vma);
 		return err;
+	}
 
 	/*
 	 * If an error occurs, unmap the VMA altogether and return an error. We
@@ -1469,6 +1479,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		return simple_ioremap_prepare(desc);
 	case MMAP_KERNEL_PAGES:
 		return map_kernel_pages_prepare(desc);
+	case MMAP_DISCONTIG_KERNEL_PAGES:
+		return map_discontig_kernel_pages_prepare(desc);
 	}
 
 	WARN_ON_ONCE(1);
@@ -1501,6 +1513,9 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_KERNEL_PAGES:
 		err = map_kernel_pages_complete(vma, action);
 		break;
+	case MMAP_DISCONTIG_KERNEL_PAGES:
+		err = map_discontig_kernel_pages_complete(vma, action);
+		break;
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 		/* Should have been delegated. */
@@ -1522,6 +1537,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 	case MMAP_KERNEL_PAGES:
+	case MMAP_DISCONTIG_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1543,6 +1559,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
 	case MMAP_KERNEL_PAGES:
+	case MMAP_DISCONTIG_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 023ad6092e9c..a6a8e53c4b38 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -457,14 +457,17 @@ enum mmap_action_type {
 	MMAP_NOTHING,
 	MMAP_REMAP_PFN,
 	MMAP_IO_REMAP_PFN,
-	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
-	MMAP_KERNEL_PAGES,	/* Map kernel page range from array. */
+	MMAP_SIMPLE_IO_REMAP,		/* I/O remap with guardrails. */
+	MMAP_KERNEL_PAGES,		/* Map kernel page range from array. */
+	MMAP_DISCONTIG_KERNEL_PAGES,	/* Map kernel discontig page range. */
 };
 
 /*
  * Describes an action an mmap_prepare hook can instruct to be taken to complete
  * the mapping of a VMA. Specified in vm_area_desc.
  */
+struct discontig_kernel_page_ops;
+
 struct mmap_action {
 	union {
 		struct {
@@ -483,6 +486,10 @@ struct mmap_action {
 			unsigned long nr_pages;
 			pgoff_t pgoff;
 		} map_kernel;
+		struct {
+			void *init_private;
+			const struct discontig_kernel_page_ops *ops;
+		} map_kernel_discontig;
 	};
 	enum mmap_action_type type;
 

-- 
2.55.0


