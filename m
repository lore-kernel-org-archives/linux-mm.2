Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B8B8C982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F1506B00A3; Thu, 17 Sep 2026 12:33:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2A16B00A4; Thu, 17 Sep 2026 12:33:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5427C6B00B1; Thu, 17 Sep 2026 12:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 281406B00A3
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:33:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72CCA160406
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:33:43 +0000 (UTC)
X-FDA: 85223800326.25.AA97158
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9CD65A0012
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:33:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jL/N+nAe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtYEyCC7VKqkqWelOuwt2okny02CJhbQpnc+ekNFEso=;
	b=RT1yxAux73oGx6w9Q5w0E/mpXn7FnLdIivjHQm032VglwrG5vsVQTwBOrXleLrHUk64bUK
	60LS0MhS57/4R43qXBgzaiNxls16/VBp3o711LDzEAOD2kPiET4ID1suPY7CKdJ8aymXkF
	DorS1e39Xrbqn0deMEiZRH9NMtnRiIg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662821;
	b=1muBk3YDmDxnviJpUNOickBsQ3/yvp8fKL99Cbgg9clYwfMK8GkYMlyCWkuOCEVxO/vj6m
	IZre3wE3RaET6mk1arjM9m3kdRdWABhqjX+WNHgx+hQSEa9MeBPdDa7umliKzTWRAnykue
	fTfRtS25I+Tww64P9JLMTW3dDoS17dA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jL/N+nAe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB3D240941;
	Thu, 17 Sep 2026 16:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D2F1F000FF;
	Thu, 17 Sep 2026 16:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662820;
	bh=rtYEyCC7VKqkqWelOuwt2okny02CJhbQpnc+ekNFEso=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jL/N+nAedFIcy7gClq40Pni5TcpDiYU3W6lU6py709+elTP01tPRn59duEgHxLXX0
	 kgCAUZfQP8LDRJaXC0n/N71unVUr4ytyGLpgajOR1/c4YelJsh50RSEglvq6YMlAKH
	 biv1yaVW5dePVs5g/Hv/jlVM0hOEtIb8Jag/bYYIcYGUqIDRRHHq0XdtEgAa+WCKje
	 /aLWPXFVlrCjlliJACtNcUtFXB+xYLlGB8XPAz53hZJeOTI9CTWK/FHjTV9mVLJ8+S
	 0aZkLZiwRcEq1Xk/+ULQ+CCWEkFgHVPGycWzsZevF4lLL2VqFx1YNlnabo+3m6UhqH
	 SZaK2+UVVwY+g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:30 +0100
Subject: [PATCH v3 21/40] mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-21-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1289; i=ljs@kernel.org;
 h=from:subject:message-id; bh=NwkWQQ7fmwzL5QGJDJ/xCgQWUhs8DQGRd4wM7Vj8ofA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB96M+ncMv0Z517wyC/y7rrGInXUMERpxZ9un+9eS
 ca/pBtPd5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiG00Z/tclL5u+8ccfuY17
 fiz013R5ciLNuW2/7fq51ryiNWtXXapn+O/gpmbwXolVdG+JNs8Gjq3zWM8cSOs76LXyVfXh8/y
 uF/gA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9CD65A0012
X-Stat-Signature: agh4nsbixyfotuzmue3tqrht1o8eibtn
X-HE-Tag: 1789662821-747189
X-HE-Meta: U2FsdGVkX1+R3eaOVEeHv/bdVjoZTF8dUOd8BejHTk2v44uPwkgE57S+tgCadEkwzZw0qX+NwRHKfY8rxUMi8ZNohfHQ02qWE4ISJobdaIZgdw+7dHM8aLwoR+KvqnjyAlh7Nj0q+iea47CMoLa+kkkU1tVk8XbWscw3notcqrfimPXBmRKlGPT0c6v8PqbDeXQlQsOJm0ePiuMR8ZwEYY66oaQ+KnM+azAk1uZ1MrLmoSSL6eOidnoLz+PmW4g79nhWQB62lfiZPuhUEmT0c/hSZym1Oq38Dm3o2D/d8FSzSJHeLpWLjwMhkj2AwCATitkzCFXl8JoAYvbNWdVVzRH2JLwFS9YSHbmdXBpSo08UADF1xHvGsSik2kFk8gjmAvBCYosKJOYzj0ZJmJiGlYmTia1YgMZlRcJvsU66z76s5BCca9/aTWwODN9gW5Uk8WEUC/n/xtlfemec8bAhwsROUSuSdS0dTaq6NF8nnEwPX9HEwIdU4j7Y4DXg7zL8X5GQSVwc+HMJSBqRJ7LXeFN7tXpdbCri97kl/5bzYADG95BfwKIlX61RYDnzh733oTBG7LdkREYZ6CiIa/fsWnbSaBfb+wKIw83zk1YcbhSee4qscAHgF9SdTChqDeWbyHAc3vW1xuhelNz1gZee8HqflUihHYFGgUBumynk7aSeEUcqolrQS+AUlxneyX7F9eD5ykhfPDNTgYlK1M0ZMYlwicvP9JyWLuYDz8WTZvPg+3woPe1gTpu2w2xJUgHnwBt6DvndI1jMuvCRXLNbIIsVe/noQ+SO3vYQqT88p+19eeC1pEko2Pim1jRTvd0Mmsbhv0QZ6shJrhTyPgDilUZibwY+Y5/Cnv5EzdqXKRco6LGreUIpiPVXYflEgc99ij4mWvstsBV8KeR4XHYSijHWzGSiVijCe7DcHQ9phjdlA8jAi884aq6NOY+5Jyz/DC98/vj/RT7U4ppx85Y
 hySDo19Q
 s/JfzIt5AHGI0L21dlpX/LxoBk2cuGp/8PackhEYdgjRti8nLo2AbVrqy92DrwwZQN79GKkas9+anp9hotU2QX4Nl4PrgrxL0hIMH9Lt8vIUM6I4ZJ1Gld040zwU3H0fnagC123flQQH6SrTMnUIv/YHvtw5Of+HCX4gAG2HvW94CSLdZClBQZyaYCs4T9moZDhKYcJzg7VLFc3Ax2trt/uUekaal1U+Lirll4Qs+86cN0qZhnoh5BMQJKCYCTeUu9XJJwjM12xGqY5gGvZ8K9vurgtDpE5+SRsLzHLHoV4v9MILdgGasxEmoiusAVd4/vYtwvy/LjZ6Oyz22ZaleM3k4T/P0i1MLTIVUjyq2rX+dcZ1NPLSM58qzAufKW1/oPHAOkfVJpJxArsfRNgjd9C6MMu5ANItu5jVhJ43NZ1EtbT18YN4TaToySCUt3QlQwyUIitaBHvEyGax5Yhxk1FJOdVy0JpltpksnnBxOHxiYI4wW9G9/aNvaj1ijSSvGDW/o8D4q0ak6RvCEeC8YB/JFJ1eUTpYkdxayn1zk3ufRGHVT3GZ6e0c9B3D9D/BQdnBows7A8Tbvr6HDCpzeYsgMPNLptE6fyO1/digJqATUuFnxAiSlpSSR8ASGdxlpZFbI8h8081B8JDoSKAhG+JG1bzXaFxGGGv13lN0rwC12Ci++GvZFAIYkmYUX6YOT0lZgNG9h0KCtOxkWMeOmfGGI7Bq0Gez59gnIK9Ne85tmBoDBjAq5OoYao7A/LJMV5t1T3qf8hcJe8WIDd3ZLJIJV3d40rWBGm4OemRcN04+D+n87NENIF+u5lYtKyRe+RWvVKxnULr2yJ/o0xbzgWip3r0vtraHsN8BPZXAZ7/p6pJxrPq+DYZJYQ2A+AymTImdFefVAL5gFFqVVkVIl9h6ZJUky/Im/ofs7bdzZPyDhOjj5C1pWcSYv1KCM1bEXOdoSYuppsqXSSiRfxKhtl59wgu8i
 Y/8UG4Ni
 BQrM4oomSIvx2mcUM6ZhJW7rbyXf4L5mb71DKIhVDZNDosyYPzqgP0mjQyK7ymg/g2qlymziNuNnsq//RgZle2cEVftuuZS25CdeleTj1rwmJxhCGFQvQPDwozOQnBy3fpesc+goLIOk4AR9B/e62LJgvjreJMI0bYALCENTC8yE3PM86dFp6ZqnCYIhBj37nF1nHaggpD81nu09QqiguY6inLXwqar7Z1QcOmXlOvkke7kfQQiwdcBDfxzoM2RK6uN+EX/v5wLJdMsZ23R3RVf2kZdeFatZ+Cu/drl+VkHlZ6axtAvXSwZ6DuTX9RfpNW2xGxi5ZA5Icyiftzac+7BPMQuPKPGzyZgS77Ey1SI85UlhfQ1MH2r29YY+7RkoEHXvBAupYDrkgViEhOkCZM1F3GLotfXqT2JLJXIClqWQHuKI7yYoEEBNHabKRo2p40d7+1DuFq5VbCqhgbAu3J8A3pmTO1hAYwGWL1etn1qjsG66mDTYte/LBb+O6OVfi1plQtDR+IUB8LAEppoVLGtFRjrYGbeuL/NHCSVVTsJZPTFsI8xLnIm8uPPmBuDXhF7eLu178xfRvp5yfDoV/TelVP9e2+A9wvf6RfT6gIMKouAZLoBO3BMevVH0VUH1E1J1FWcZbVR47O/c4DbiNvwFCtLMIsxgQjAxW6QPi5TWMwhSBbzK7cLWGwoDrzyOccKXqwrJZi+4S1e31oam+c08bAqj6u+FKpmDnYjEfMOekiDYZV0VoXs4QvjNeoZuYIRB+PqXWHseFntHhqFp188REV103dVX1fPnmed7i7BKi3Za2LjdRQtXkyDOvQaRy++o2CzPBD+Fm5ra1DFPy6r7ORtSq2/mWpA8VK8AhNxE7rkKLCYyLfkVccNVo/S2UtLt6Gh1qq4JASrXnQrYsx6YqIy166/QSN6eqPD/58nHJiDHssmiSkXJHTltFqbiKEQNdodEpOQJjFsDiYDAk/faMkLid
 gyr+6XkD
 tPqqCx/Nvknrnqpy/CDlp+QiowAdBKljMRStBISUx27I8/VHktnNDE1tU7em7ADRINHMLJ0ygPGXAK2ob/OZchR8idxOoyb9bOpy7XCkt6Bnt80NfywUomgbJrSr/XL7HStmbPq1Y/lRuJA4XSU8tFv4695yrT/Nls9KI7fEdcHDFSnxOX46uhOD/I/yMTQZIcosgU0uGChxTtt5T8xgNBYp9xCp0o6Be+ZQ/dRwqAe/ihAYHpiyS/qRCZFmx/ujNAb4E5esZ/sAHXI7HyMDpOdAx1veMAvvP9cRXtqdJeiAbQiZWdiEabUWZZpLixFx7GirsQ49WkQiZm0oehNQB7nJ5Q5GVV/yNrhkzobcg0tuPMLBc/Z7dNejeRgKEiGEp79C5oShIAg5NQQgBUPXDmUzJ83t5TDfc3vppcgsPnpVX82qlNeBK6rJEKeBj2nXzBtCo8CcxpaRrTpv+Pc+8wE4h1bP/UbtsQaWwtJdytGYjnlJoln7R6IxHEq6l8/4d9/HhlxDx4ZxLTAw5Siqrjneq9DyzingiE7W+sRBsCxAP6yIhHiRatb/wnZ2Ggn49vKMas38f8cgX3scYZP3YeWxR6MFcsseKn8jBjVJchft5zp8cuZUcDmrXzqYVXj7R5rqRgV8Up7nOYirWsS4PE3RDUyC+eeaQ2MehMvF+YhOWnCPRBJJGDSgBSA4PzAz4x26Eoh3De9gE3qxR+BSJLugDKnlG8BSxuKFi1FnH5nY123awOBzJHYW788ywvJ0UY3z48a5vz75JWMORpqs3ogf2GfeQokrTmyy3H0bzAMHDxwbkHruatuNekN6wsFglVxRlxVLMZEA/ij1+ZgjblhF4vH6iWqY7pH7Xt3V5rvLRih4mvXqNuhxM/VIRZ3V/GIyhu/ZpKMtQYyR/LQcqAlwPX/sVt26GW39g6PDeizUqrctXqulsS3ewdtgrqpj5SJTJqGrDVBtJ9eU+i03gy+isVDYb
 O4QIurrD
 KcaH0JHzIm6m2dHVNXMVwwguI4/1kyWNcM+rSJ+XbQ1RHBkxq00C1P0R/V63uDIJBrLIIaSuzoyP2lcepo+T7cb3iIuoJy1iaJiaM5mhmeKGuWFZsnC57CAxN89fYCTKz0VQCZgZr5byMI+GLGGFh595TlAacM8P0rt6epeiAdjussXdv3dg+h8kYnxSMXanKKVH+JiPJFdwDqoXU7UxTK7p0jU6gzL4k7JXS3sPW6c4tI6lMHJ2Vsip9n1ggZDmJsQmT2MA6cJT4f20FGgU021n7GW3OZFYswL2pOLUn/3kl74RqGNqLKo6buD5XxnI6tWXnGRUbFyQlet5v9FJsFxi5Ko9jBWNG5iq+ymIYNVsJMU7z6UJitHk5t5UwcL3zXHSbFOmZTZq/HJIw1vICdyWGp3YUJLtdJe9nr0iMaWwH7RT3E3FB4xl7Pb3zM6VHCs8MkMK8Wot+M9iboSTaSqHWOv5zbhrcLU2240H91pTOx6kfQGDjQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When populating a VMA range via the aptly named populate_vma_page_range()
an unreadable VMA will always eventually fail with -EFAULT.

That a VMA is accessible is always checked, however VMA_MAYREAD_BIT is not.

All user mappings always have VMA_MAYREAD_BIT set, so this check only
impacts kernel mappings.

It is implemented specifically to disallow population of uprobes XOL
mappings which are exec-only.

A nasty interaction with these mappings may occur if they are mlocked, so
actively disallow this early.

This allows a subsequent commit to remove the VM_IO check in
__mm_populate() which otherwise requires non-MMIO mappings to be wrongly
flagged simply as a workaround.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/gup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index c2dfcb4744bc..e6310a7cc05b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1836,6 +1836,10 @@ long populate_vma_page_range(struct vm_area_struct *vma,
 	if (!vma_is_accessible(vma))
 		return -EFAULT;
 
+	/* Unreadable VMAs also cannot be faulted in. */
+	if (!vma_test(vma, VMA_MAYREAD_BIT))
+		return -EFAULT;
+
 	gup_flags = FOLL_TOUCH;
 	/*
 	 * We want to touch writable mappings with a write fault in order

-- 
2.55.0


