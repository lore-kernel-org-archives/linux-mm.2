Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B421C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA45C6B00BB; Tue,  8 Sep 2026 16:14:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E54D26B00BC; Tue,  8 Sep 2026 16:14:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D796B00BD; Tue,  8 Sep 2026 16:14:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 887FD6B00BB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:14:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F03A407B5
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:14:53 +0000 (UTC)
X-FDA: 85191698466.02.EF96EFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C443140002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:14:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KojzWCtk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Buy1X7vUhFA5M0q0YkwTXJ3WCTRlDAXOGFi+KKMvNMI=;
	b=KXuZJZWwTZSc14WXoBLeA5k+Qpi+JKNtPX9wuN52xcKxBF/xoG2yiks9bWp8rmoUlBWOZM
	bQOzxkqvU6kHn5fpgG9tuOyHZP8l+iIrbp2XlqXlASM/3W6rpj2t6RPX3rXjdELcIZuvYi
	W+zzR77/WyMpRUgCRht5wdKeIcZCGhg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898491;
	b=UzeoOWxgi0G04RCJqyZVIxs8IC1u9sfW/AB4fA2hBd8sXBEyNlL01n3ZrYKGbxVWJnfRHD
	fVs5cjoF4yehIpLql+RIGmfddgLBrHcezAHuRO3C8LDwsN7/pxfRDrCtzy3piIpMFZTzDk
	bG9poIyu0NldKk7wMpkcw6C7e/oHcC4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KojzWCtk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A8C7601F6;
	Tue,  8 Sep 2026 20:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12F41F00A3D;
	Tue,  8 Sep 2026 20:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898491;
	bh=Buy1X7vUhFA5M0q0YkwTXJ3WCTRlDAXOGFi+KKMvNMI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KojzWCtkTQlsJQm7/MIp9uzjo+PwnVFqf6hsdt+rd7ATpRH6UidsxgxwQX16JXLAw
	 i0AALCpugtToQiETqIvU/a5aq0cG1t7P8WbiUiuxj+q7yDAAlBZV0fX3OPlFMus5He
	 fQGkuPYfrO4iFaO1iQN/F5HBza2fMnpu2oFFcei4aLZ+EuUEEP9zch+irG/Us7WvVr
	 DTLR5R1n0euq/X7Cn527JsWMvfOHYYg4rCt8TLURvUQJHx6GAW7rr7uQ/33+7zK1t5
	 QUhJk8TdVdq0RQ52fitsuW90DY4Ztto4vMdo1U0vLZ1l3UVbi5RfPaU264Ehj043Eu
	 JketJqZ1s2Ztg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:30 +0100
Subject: [PATCH 26/39] mm: remove hugetlb_inline.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-26-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5564; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Qn4kLSsTRBUisak3Rnkkd+W6TUlYWpGyVle9U2rwRzg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG6ZP71T6FrDsWXb7rHdmrLTtWU+zxvza4dj4u5Lf
 RFqkem621HKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJHGtnZNiV/fq/ReuWTGNV
 lgW522/+rTxhLc+xcv/7F/UfT9QdvOzJyHD/k+N37ch0nYbMs6ruHrpJpVmbVGufX2gsqlTelZ6
 3gRcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C443140002
X-Stat-Signature: gazrfrpjgcm1ukdgmwn3a3m8wdckayn9
X-HE-Tag: 1788898491-444349
X-HE-Meta: U2FsdGVkX18G2Dy36rwA46gd73vymOuJeuYc4nLVRGb1742+LuG/72WJG6jleOKNn38mXgPEfR/M2V9TxbO7VYDaChLn9PdOaqJEIkZp7RAoLQ2BS7acL611M2kpMZx+69d9Uoxa5Q+7K3m/eJIdNlMjE4U4oOpgVBGA05oK0uvd14OY64a4olkRoJtRZf8g3CmELMT/YnC6dDuLesOX2eIlvyz1DSCYCBYjjtrAZUR9HZrDqCCqf3dwgb/ntfuq/P5vpO2O+YgVKEUERNJlH+a+t/HPNc9E5WnBFAnMfWufgLaVfAdjN+MpVmpujufSczaYCD/Du6jIL9mRy5mMKva/SNFEEZ+3JugMtQ/kq8hBmxSjD8kyxy+FzzCaxYRv+7uXckC/QhpC83t8FjLUYdyyz/nPSjsD93c4teSuy2Rz8WhVyL1oUhKjl9Yfjo+gWkJu31VnXDFPSccArzX+/wGR4vVgh5V+Uvykzx9+0aNLOjjCekE61nrW+V6e3qql4GIu36QgEpz5oB9/yIv3SJsC1Ajp/IQZAKuFFhfzNWf8sTEDvSnUFXHjZVCHJHamKJjflKIOZZlSXQWdcL8xC+INKCRbO040KVYjjhVI8g4Lyu+k5Lbsyha8NWQimRWb/jxVeJNtnTK52Pilm9A5zAk3IwflBOBZNZOu6bb/CzKFKJk/4YewMFUUCWJEZHuVsecsGjbv16VR6wSQw9QO7iUedMNxKXzRaMvpb0WcgXJCt9TXFD1e+JtHLifBNndFIGOFoibK6mc5sRyFZUXrLdcQ59V8lnKQkBSRMwOlBkNx79jo/mygRRlyWYT0B8VKxbSGslCVOOtJ5NqkJUoFX8zQfdXD4xouWgKDwVMjGW5boqJ3IJ5ObwI+fEt+dtaAszEFFncj2NN35vzsgJZBOHIsrVuRummX+3CBjjEAbgPPk/glz/jSOcYF4jCqJKuz46O1yVa58N/0xBQEZ8x
 czqTyG7c
 MVnyTCTc7lZdoo+I4EUJPZsKQjHgJysCs7A8YqUe7QnBcGatC7gMV5AbnGCA4k8m5F3umJCjdRg08EJMbQUblf5frjeRuYILVyZ9DZh7inDGVzBGa7/qcr7L89VILWPdFFubg71vJOT9DkPB6Bfi5DxdCmQ0R0CMQK9MjUPut6HTHC7fijqetqzphz/Zt4No+qPO0W765CtRYatsEHJgS462qtYdw8AlkZ4HVm3niTZYbnK4o0WKb1eosU129yzvLOOEdxih6lt0KaHc2KEEV4U6xwlFf2wdIS02SF3myJx9MvC2PrUIWRSrRakEhxPNb/ah/1gRWVrRtXjW1IQDp7KasOGpc2Ka2+IZjLXYsojyWyUQxmgyXFpJF6PqZvTjU4Ob6q8jQut9DwFrKCdLTCnnqFzRvIRHR6TkEFogGzLDdhfQ417UJNkkqzO3GOJ/JmHHeS/3ztGX794SZQp4YojxbW4+fRMrihIC41FSugo6QzxRXxHjXTZPW6+FK1aW/fMEv3dYg0/Q8unUdFIwrMXGQfH/McncvcomifodzUi9zAS7ql8vzjCH+K8Zt+fDZQqsN0vulyZFj8BEcP/o6OwK8QiUV3tjDwrxi6GInojYoLgOSyWWx8SaRZokwIB0XVDlQT9ksU93V8ISqjLQ21ZqOcQqPK9XWtZCSbf4PhOqbaim9uduBZz0UOPKnMXGB11nKXDOzvgl14M9IB4s+RScBO/N7kE0tzC1bJZfVh3TxTCAS7tfZsw/xZdl8PCA34+33Z/37rDXL7zbj96L6epLh4aNvM+885pAS7LBN2PDQIimYuVcK7FB3Jg7JEETPZpy31j3KYLp9jXvOgGbhtWvRtfVRuCuk/l1oE1idS8kWNA9tCj6xmo9NY2/riwFM9W4F7xqhbh6c55/pagg9h2TfzACyz87CGFj3XVAz1oKxer9EKMmG8kGJBF5bBCKr/tCf5FWA7/SauDBvZeBFl17ROcq5
 v43oJ3Bz
 M4osuz/Ldvg/iDiYsOzp855WBlqUqqLBZoLEqtWf7zKgy1/ilAXO1fBjAF3IBPZ8bmqchPsYoPzvQo7CXGI/W9gsjg9sPCrEwVt+cNZ0Evp5aq/ibQLoCoKJBC3Gy/fInlrmKTlVs+vZHQndN3QRgWXkGeQ8ou+K9X9FX6o3R4NjozAzxDag4Hv2bENKyYWPPh5NqSBCqdK3J39JnEoj9fz7cyuDgYcDgkTh6F9mcE07NYltUFrAuE+CgXTTvxUcxy1dx/jZVg/1QLa1WYf10G2uiBPvKphI/1wLrAVdgm+Az1hFVmzqPML9mIFTmbpEXU7UGZD9z7Ms9HxtbMANmHXFd7j8l5TG0ePLrLGpN84FSzfHvFnNs+KO0V4hZ2QRP2qGvZjbUqRmlanAwaCilB0cFVs7RRvr4O/pRkEamMFxD3+X7mu2kddwBnuxQv0QDsOmOadaVvrdmhSA4Ro4NOdubKVgjhvfcLgWT5k1YV1m84vw9U1d2wILbV5TvHHIt9BEcVCuU8LbcV2puIQT5dKXp5RMzQzm5s+kE86XFzFNdA3NVuIEzGaXZWtH7JAeJ3pvINIh8XlLXDVWTK8/5BP6KMMDZlBCw+RUAEGOPaC3b9niIu6UqjgGoAOcarUiMvDSQT/GRfqt2M8Xg5aw8yiVPdTH7V5CvN/SchrKPTSTSggjHGKjSodiT9I8KMeA++yI1sflMRu0S3jxdsXuLWPRWWs9jejNSR3ARIu+TE/C8H3HjIk1yJm5CDonPajC7YjUgu7LXtTlRPw6faq0gs/qCXSwGZvalm7i/+AweGmXaxE07JKuYSzXOairZmTfev2EdvXR8uYhq66vBTPaYc1DLTs4j7cec42KISmR50VvDFjlft14kwLxf3yxBXHmcN0jnzAu7E/b0Gt+VsjpU3+w4Gg32CRjaurmmTfUPNUlS2LTOcXQhrytz4ytRsRdQNMOaFHGeqzuZk4yycsdQpi9UBJHj
 wjCb2gRC
 O5rFC7I+GVgzdiXJ3E/Y5C5B5Zj65vdfPAjaSWB2XQQxY1SlzdimReY8fwMHYsnSlMlJpXdY1JyUN+9TURUO+WQGpnfuf1wxwYt9xUveoZVX9TOHzvcjiBmMCuNb45uEaoaVcjtbRspxdrbfPs7yXO+m6TEns6foXYZ8q4BMB0Rw1Ue2eym5ULSkUxwyjhqmmoNXaqFanETL06V+hdx6PW6PevCYcaA4KIT2IpKby+hv/byX0WZVsRMEsBZU1HeprigMY8qlr9BbafjmVZOZehpFnGipxDv413v4q8eCR1l6nf2tvF3SX2k2GMS0KHSkRI87KyvNLE/5pbVbmiHPzOUnMRnSMXPYWHgKgUUMXcl6Z5CEhyzgWTC01i1ztNJ7aCYoTsOFpBZ9enwejESMNaqXa5cAlIjXB61OUFGJXaTXqDVM8DsZ89jfOfxkUnfGopuu9OHlr5dot3Bpe2kHrpahpGymBpkMQ3QA8DvGJXokHLI+5jmciKhcFizpZ/DqN1+U1cV2MePxuFYR6C4+yz6r1KUzt7BdjXS8P/BsL/nI7ahlKVDarLVBgNxB+Bgo6/6wL+MS6gqeO7hOU3TvZ6/HA7HYQw1WdnQxD+exhq3OlehQn8HbZnuA3zCa/T3HDAOSEdrHBXctvtKsyDojhM1nX6BoapxX5djiYL1WYunSPAefx9ayYJFWAeWx+xNfDDZRgE2sqxaj3rxit4rpITDoa+nDtRGWskI7YuRUK+oKeE5WJWxAJIQIUKXyln8yBn5BQtPTpo4H3o+/wBxKKU3rKQTvooZQpUCS289i6jdHJB/fDZSHTN+5LkV/qsQ4+l9pnM55pYbLT5KqLtjuLPMYJheL9lu3dGUbSRGdDEPOSy/8Eb5gaROYV+zfwsWUi1Hsx/COuufB6jX3s+k4TPIHRfLEcOdpRJ1e5z/h0lNjQNM9T4ng5znefzdsZ0+RgiBxtVTvOI36moQ86wgcwuIn0ok+3
 lGMQpHtl
 aoTgo6BV80PMj3diBrV90dx0G42h+VQXaObm5JOX4q9S28zTKPM9Tg0pv2OfTNgFrc1/OOyYasXA2UEm1Cg81XA4M4VdNGyUJ4Rn59wMwEQ571pjyKG6BdjAYbpaSBQZCDgiIPcSgOgRuKCD1FMkWDp3OZuHTOWcUpR8LlWNOajpXjxWErjrgij0ENBc6JlnxoTCATIbEfUSz/vDOZeOh3zKvYa6BlL4AsYeyAklr6xFXKKnhQokK231RFA+99XSKqEzIveKz+pFX77lsoM2WuoW/5FBmdH25VOGJeZweuQuvH9nwx4U19g2hQBt73neUPTK175PvBsU6CtF78DEEg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This header really makes little sense - every place it is included mm.h is
also included, and the header itself includes mm.h, so it does nothing to
reduce header size.

It also oddly does an #ifdef around checking VMA_HUGETLB_BIT, however
VMA_HUGETLB_BIT is unconditionally available, and will never be set if
hugetlb is not enabled.

Simply remove the header, eliminate the odd ifdeffery and place the
predicates in mm.h.

The naming of these predicates is odd, but to keep changes separate, we
will address this in a separate patch.

The file was never put into MAINTAINERS so there's no change required
there.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/gpu/drm/drm_gpusvm.c   |  2 +-
 include/asm-generic/tlb.h      |  2 +-
 include/linux/hugetlb.h        |  1 -
 include/linux/hugetlb_inline.h | 28 ----------------------------
 include/linux/mm.h             | 11 +++++++++++
 include/linux/pagemap.h        |  1 -
 include/linux/userfaultfd_k.h  |  1 -
 kernel/sched/fair.c            |  1 -
 mm/vma_internal.h              |  1 -
 9 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index a93eee7ddb9e..793dacec2100 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -9,9 +9,9 @@
 #include <linux/dma-mapping.h>
 #include <linux/export.h>
 #include <linux/hmm.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/memremap.h>
 #include <linux/mm_types.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 
 #include <drm/drm_device.h>
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index bdcc2778ac64..53ce414d9d81 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -11,9 +11,9 @@
 #ifndef _ASM_GENERIC__TLB_H
 #define _ASM_GENERIC__TLB_H
 
+#include <linux/mm.h>
 #include <linux/mmu_notifier.h>
 #include <linux/swap.h>
-#include <linux/hugetlb_inline.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 80a5a03e9cee..d7e6563cef75 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -7,7 +7,6 @@
 #include <linux/mm_types.h>
 #include <linux/mmdebug.h>
 #include <linux/fs.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/cgroup.h>
 #include <linux/page_ref.h>
 #include <linux/list.h>
diff --git a/include/linux/hugetlb_inline.h b/include/linux/hugetlb_inline.h
deleted file mode 100644
index 5c29cd3223a1..000000000000
--- a/include/linux/hugetlb_inline.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _LINUX_HUGETLB_INLINE_H
-#define _LINUX_HUGETLB_INLINE_H
-
-#include <linux/mm.h>
-
-#ifdef CONFIG_HUGETLB_PAGE
-
-static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
-{
-	return vma_flags_test(flags, VMA_HUGETLB_BIT);
-}
-
-#else
-
-static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
-{
-	return false;
-}
-
-#endif
-
-static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
-{
-	return is_vma_hugetlb_flags(&vma->flags);
-}
-
-#endif
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 15fc4509784b..d6b38556be36 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1609,6 +1609,17 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
+{
+	return IS_ENABLED(CONFIG_HUGETLB_PAGE) &&
+	       vma_flags_test(flags, VMA_HUGETLB_BIT);
+}
+
+static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
+{
+	return is_vma_hugetlb_flags(&vma->flags);
+}
+
 /**
  * vma_flags_is_kernel_owned() - Do the specified VMA flags indicate that the
  * contents of the VMA are owned by the kernel rather than the core mm?
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 939f3a5e973f..d7d8b312466c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -14,7 +14,6 @@
 #include <linux/gfp.h>
 #include <linux/bitops.h>
 #include <linux/hardirq.h> /* for in_interrupt() */
-#include <linux/hugetlb_inline.h>
 
 struct folio_batch;
 
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index a4351cffc60c..a14b8a9ffb7b 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -18,7 +18,6 @@
 #include <linux/swap.h>
 #include <linux/leafops.h>
 #include <asm-generic/pgtable_uffd.h>
-#include <linux/hugetlb_inline.h>
 
 /* The set of all possible UFFD-related VM flags. */
 #define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_MINOR | \
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a71f0ab79bcd..c75b5c50af30 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -22,7 +22,6 @@
  */
 #include <linux/energy_model.h>
 #include <linux/mmap_lock.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/jiffies.h>
 #include <linux/mm_api.h>
 #include <linux/highmem.h>
diff --git a/mm/vma_internal.h b/mm/vma_internal.h
index 4d300e7bbaf4..4f73f0a4db79 100644
--- a/mm/vma_internal.h
+++ b/mm/vma_internal.h
@@ -18,7 +18,6 @@
 #include <linux/fs.h>
 #include <linux/huge_mm.h>
 #include <linux/hugetlb.h>
-#include <linux/hugetlb_inline.h>
 #include <linux/kernel.h>
 #include <linux/ksm.h>
 #include <linux/khugepaged.h>

-- 
2.55.0


