Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C75DC982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE1D26B008A; Thu, 17 Sep 2026 12:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92556B0096; Thu, 17 Sep 2026 12:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937316B00B1; Thu, 17 Sep 2026 12:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6EFB06B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:30:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 203E5A044B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:30:11 +0000 (UTC)
X-FDA: 85223791422.17.7DF345F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4C99120002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:30:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HFj1ZcuE;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662609;
	b=7Mm3sO8EQabBERCkiNtiEg67W7mAsCfLG11GtzPWlxsTPEFa/K134JafYPu6rBjyGzUnVE
	1DOj5lrH6RHYXMvQ6I/3w7CnEMWhARSjc9W0A0dKuq+c2l1wIHqwn2T5dKLriWqzNfuwiA
	X2LZ4L/WChEGUuzJh39JLp6Gvr9p1Sk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HFj1ZcuE;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qgN2FFKKPpmp05DaHJUklpQtNOudy/Yy1fqR/MizKYA=;
	b=jJqx8KS7BCkNkZR0qlRrm0NoRdZPrmK2VAcoHJo7zrIPdYRUdv/ym9lJSmIQDRLwL8OvHr
	fk4z1Is5mFqZQRAN55quesCIqo7cHOHAuNw2QnOFXFaHDXeZewBoe0kgmm3LTj8SX/6Vgd
	lIchHmIj3dOOoQoPrIgxuJ9iJJAUyQE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 85A0842CEB;
	Thu, 17 Sep 2026 16:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB891F000FF;
	Thu, 17 Sep 2026 16:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662608;
	bh=qgN2FFKKPpmp05DaHJUklpQtNOudy/Yy1fqR/MizKYA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HFj1ZcuEDNTMnh2Nqg6+fJfV02zj4ziSKQ6RRu3yQsj5p9v46CsiyUooZCzc+YKP8
	 34+cHO9Ai3c1E0itgx/XfzOSuRfYmy8HAt254s7g3BLKzyjpUAnQOVrO0QhDVNgiq3
	 flPs+hy1XGA0Y7fr1T5cxhyfnmG67B5FQqIFoWXsIONz3QdBqErmu8iV1XFY4RLphO
	 IFPC2LNRFjPKPOaYpFPD72y8tC/6OnYCr6cG2Sad5uOHcVDlZ4CJ7psZsf+Fnn5m50
	 NrSpWB5QWg5LSJldkts2rYONeMhUptkU9gWhvtFpmXXEctHjrUlI2vfeMdLEBsJtm/
	 Oqt+2k9sPTlrw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:23 +0100
Subject: [PATCH v3 14/40] bpf: arena: mark arena_map_mmap() mappings
 VM_MIXEDMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-14-4583d8a23bca@kernel.org>
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2130; i=ljs@kernel.org;
 h=from:subject:message-id; bh=R3tb6SjOVu7d1sP7Jc7DgfQesg/5MmuNI7Jhk6g3s7I=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB9I54nnNvtaIzQtQLirIc/9iwfHss/3oxY92Nyjp
 NYufetcRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACby8iIjw4Z/yqcuR2/Xfn+H
 S/lV3fFHj2t+hpZ0/BU4/O3EpbNTVAwZGa7W9Yjb2IRpLFvWrbWlSPbedPOzxjoW/zcszF4buGz
 NIRYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4C99120002
X-Stat-Signature: gaohib5jwibm6tyzztd7exfssjjhfb9u
X-HE-Tag: 1789662609-485276
X-HE-Meta: U2FsdGVkX19Sn3V4nNgFKUXyHVEUoOTvJAWz+LD7nb6V1Px+R0ekPvu+Hlfo7X11K7RUmjhaEfzYGOp9LCL2RUZzitj3xmcA+hBv/cV4r6WSf64R0WDjn1FD3XQSthWX6Bh/jtPUwPSkPJVA9/7olJ7gT6Sn2f06jq0d2BNBOLPDr1OZ7GAeMaqD63XVj04+WpBuHVV5k6+/Qf3zBOCXq3nMNMypY2VyiySuhzimd76R9NPrhGR5I1jp0TFQan5Yv/wSZOto/UHQ+/dGFfLtsI7cU1EGx6JAuCtEKHfBL/wTcnc88GxHm6YOvm5wNvkXo00k26Pnli5qjHAMag2pHKo6NSuKTwzHCMsgK3fXVY/k/4fKiKc/uUHyie1ka/lYY5FXtuMSUJQ0oaD3vV6473vJsfYI1Ogu5iibBS1QIRrV5Xtl/wUiNF8ztgMczz/xbVqOo3vobQqD0XH/1Fx+X98Yxa386OkcqaPxE33/F4ckF4Xdtn6zKyEjbD0K70JtiEIeqnft6hkxFA4SNXwM8rXpfHUGXI1fUbUevaTpG949ZbwsQH+CCYLbHZKpFdrR34INcZzRi7x7p/ZuelY2whP9zx5dTcoJDIi199CSw0NbxLuT0J6gDwfDzgLcEevx8OK9YDUrDjPF9CdtK3qlWRN+FSY2yCfurs30PuTakBzzl5KteBuOIopaMNC5jBgNrnZriIQ64KzfvScb2J6t1ZtjoGxdIXtZegJBEsdUjMbIXwPt1UHHRdwi29inPz+waUQrtcZnal2tRC/c6BIv8AaIgdPDfZB/2T4qbCp4IKy1SJV6bvuGtyKEiV5qslR59vcgRNzv1xn4mZ0l3Szt2liQbsxQeMb3Uz15fjY+H47DniIwlsXAhbBw1YiCZyEsRLsLomlZyB4rFYfdVhRJJ1egeVKqQeGpK/1n0Yn2BlTBcIuy3mu8FcZ4fe1GeZe70+qrkU6h5qERAEENMyJ
 5YA3TCMl
 uI/OI+//LBRXAhYYkdQMt94qJIbdiH/O/N9Qipo/VyN7DPcvBQ4Vf5agFadAbpF4wOura9dQn4QJzsMuloPJOOBB7A3CgmUvCbkVjqcWHwOIaTXZy+yTJTIlUKaLerP9wzOgEwcIbgmNlkQLc8urrLJjhdycZYO5SPlphMt3Lmk97GUoLoxWZQzY8ntgF5Z5UdkwUcwvLNlwjK4CwkotNWoyTELwPfKEfjARnMg6Qxa3joyV5TZeBIku2rGsQMgAVMPLMQ4lWEtG5zYJYHcYAB9mYYQ0IaZ0zfZYu85KOVsu0gQpDi7yqfJIHAgb/7aYh53+3qoTUnM2f9j/7B6RL4EDdLKPcZa+IAyDkXOBS9p+lNRAAJR7gAnZAdFEuZCEutZ9UpcI06FoGQ70vs5Y2X2auioQZEsKRcPLJGqFRMoATh7YQIOiG2P+ustBeqcw5b6ZtYePaBn7mKfFZMEN4VfVj79LSrNHQuzNj8YRV7QBrX9QXKMK1V0bL/svEsa08Y3IesQmGDp/18EtB1y9nvDX9litBgLtY+9hCGzcQaEUVYWBIzSRYzEogtDpuxz9mTZidAgP/ISoJNGtuU2ngKy/3kP5mrziaxpJc6sVbudgaGiTsEpVEPHKqmJcLQ2HSME5fJ/NI7s7USspVCkrCliFoho3SZr+qFWc44qj+fNZQ7Ue+QqDB/b66u/OStpEE8LmaEMPxH6x1onNrXMPrCdk0daDh3/nV2XNlA3VEqO5EWaCdxttAYc0OHOzFRy6h3gR8D4xNBXxHyqeDERjqt67TZMqq5s0Ui/IK+YXWhje1N4tX6d9g0g9K376SuSc6U5Gi9XUaegldlfp61SBbTgGr2cMWaQr+usi/+RB5VXwCWt0Y/A5yeOmCfIrUbUoQQhSdtto24ZzQGbAxWGkdNgtgRo0mlkByjQKxiWQNhIjDH6xatrkvttcp+G8HaNTpHQVCZl3pzDSCuJZh7wE2HI0y329n
 uVe8EKL6
 R7b3p7WwGzpdwQVcammLYr0OQ/e1G0Va8cMIVTlZS+2TIk3R1N3H0nPURr//xxbtuPshzK1ygP4TTZzYF0Ji8xyouZDW95j/uACFHnYIckzL68vwXPtOHalH8E5HCvojIKGtOzPxOG06kbsf3oAHC8zj0f9ENIRDY8U5FFfuN1h1eICLtAEf/swwC8lB5WP6o8UpVo88OUqwDkLdysqdPC6yxmVAxDgiHuZB2J/KlxGoN5tE/C4TlUjzGQCJtiFRQkYx5eKXl1RJIjqds3y+EJkfskSOpeUMA4qdN7JBM451TGenTL5RIsf30SyNL2bR3Ll3lI7HdqjZeOMDqMOz8QbuWGy7PJlNepk2ia2s9sov3dkxpAixSwQ1ABdlmEwzKAYPeLRzc0rn53rzGb68vSjMsppeglRCsgZMrBTCo+SfSWCl5AqZFD5nyjHsNixfYobNwkFpdOZFtdm04vl9ZAbmzG8mVBzcfAI3SOcmE+7GUaRcZDNpHIy2ewG8owD3Tch1z1GktGv5LTksNm+QFcfETw4+940ANRbxi4PFxH68KCqA0XaDdYPyTVlrJUzXe122e4t2Ca5jZSt4/gW0hmLcWelZWJx+xmu54PdQU1A22ujHhtBCW0N9QtzMIUDSig2T3rkP8UQWPf9Movzc1JanieMCPnkm9i1z1j1zjrydsGEr4KIDGjuqJBCtsvZQ1J5Tt22Xw51qcXGE2pkDnn8v762I5JEtRNZ6PwJfcerCxa41pTIvnnqYUbdFiTkNXVF8wspOzcJJhiSj1zZuE+EtxtjxmN8Senyu1co4/RicUU5xLprtxnpfGtsHJ7II3Wz11D/2buY8AD2GqMJ08gRBKC+ERmT63dF+nbwvpulkczRQTJ/qOhA+RA14ZsUCPQ7wbpvECpCsMNz+K6qJ7Vnvlo8sqBuE6PY+dsLNFyNq9/jhF+EGnvbYsOINFGI0RLaGzNFD8HjalXj9YD2s2CMXan9rv
 GwMaQRw2
 pwSQUjaL+0UPgexx3dfiIZbYxHaeaeYcJcxAySsZLaBUPsGSnP4Qk5MXEpjXVb4QgBlOyl2umO0Aa4YWTb2M6AxqxMoQ/qX6qCZMxQOyM2509/yHMjnzij/BFFpUDJNs8EyPdAKyUHXqiMNxdHlvbD1UM82FUu8S4J7LJMQTxc6Jviu42/QnMeQoyuu1sitrB/cNwSYFm2R2bd2UYNHo2Gvn4CG8JUvO7H4U1MN2XAcCidwGXppEqSe89/jmWyo3AYrWe/KyasCmWoJNGRnWrV4wxczt+7JxEsvXZMNK7YlTkHAmbLF35CVpisVxkty1ZOJMp8IcbtFkINRQhhSoBgsxUuWDVd3gA8SkyvqdJBKo9BnOhsr8rouj+AwQvPbHqx7UEzeVauC/Dk8M0Jz1NlEHis5ggpPgexgeHj3ueUBQX2tq+Ozc508NWQrMQ92ZzZEK5niVtmTXDZAmIIKMi/91nDNc9bsdxzeaAVWiV/AdQUozVMmrvTQ9GTI2dASDbrHOHWlRn1gvSSoafCWvNsXvzFEo7xUXUX+ZYB8oN+5nkq19AltKXYbe5w9OPJyEJZqrZeIM25GNAH2hX/bUkLQ1bzkXoXwofHq/wrN/svmM/K+iMNKjsYP5Q49S7y26smEhAeY0xoY+Ohj1177I5oAaeJ3UpiJ0p5RfY0Dyc9SLZiAyxgTuVE9LZSh4IrOTr34sO9lOFLNlE3J9LZnpjGvyVsX2x8uRgLJGR06U/SMltf8MZ0D4VtzNhq56BmcHNY0tMMOEsBdTD8kLnoNbciebGtsrGB73Jh67h4qLFZBZAAglriooZEUhFyJQSKYSJ+GTVjTnMruO+w6xTdOS2yz9w7sZnKqLYNs5Rz9DXFp/Mavem5UIJ28e4PUAexd4LG9ZV+fq6SBt1J3GRn0co8DZiBfHI6e9Qf20R3BoQlnd9C4VrlZ83ibBl1LdvXXw/KoASES2rN5Vn/8gCaYpunDx6vTJz
 P3u/v3kJ
 VNzYSmDWva6xvKzgk7Kslx82cxO6D2ScBnSKIi0ER2edS0qfhmjVayQXqaYH6s3cttIGFt1bTtiLbRY7KP4TD0S8NrVmH4lSgLjeCJ+kTYELgGwWuyzsWIjKHmMFZY1Vk+prW0G+PyhqfsmHZDcKBrR0+XqWEpDqs6D4L8ACFmDpzWJttmWY1T6ZIpju7rBmpez+m98sF1WKs80nJBIC3ZlC1FbxGS37PDRlP+asSxDAHAo1SGRAW06n0JKK+yojk4et8uzvw2CDqgmewFXsCggJzjjFkAwOkyyNmpRoFifv8xFS4z/NlS9F9sdTj0UGSGbSd20qNaW1hwqj0t3Y5FJzZkWEKjRpZSnhmIq8brcHkDqjjAMZYLZhoz6xmDm3fTZ1M23/Fecw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The bpf_map->ops->map_mmap callback invoked by bpf_map_mmap() can be set to
one of ringbuf_map_mmap_kern(), ringbuf_map_mmap_user(), array_map_mmap()
or arena_map_mmap().

It is convention in mm to mark mappings whose pages the kernel manages
itself with VM_MIXEDMAP, so the core mm knows not to treat them as ordinary
page cache or anonymous memory.

The map_mmap callbacks ringbuf_map_mmap_kern() and ringbuf_map_mmap_user()
use remap_vmalloc_range(), which ultimately invokes vm_insert_page() and so
marks the ranges VM_MIXEDMAP, and array_map_mmap() sets VM_MIXEDMAP
explicitly.

However, the exception to this is arena_map_mmap(), which doesn't set the
flag.

This patch corrects this and updates the comment to reflect it.

The pages are refcounted and vm_normal_page() finds them regardless of the
flag, and VM_DONTEXPAND remains set (marking the memory as VM_SPECIAL and
thus unmergeable). The one effect is that NUMA balancing now skips these
VMAs, as it already does for the other bpf map mappings, which is the
reason array_map_mmap() gives for setting the flag.

The intent of this patch is to be able to establish the invariant that only
PFN-mapped or mixed map ranges may clear the VM_MAYWRITE flag, as is done
in bpf_map_mmap().

Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 kernel/bpf/arena.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 7b6847200b43..b69fe5e34339 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -620,8 +620,9 @@ static int arena_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
 	 * clears VM_MAYEXEC. Set VM_DONTEXPAND to avoid potential change
 	 * of user_vm_start. Set VM_DONTCOPY to prevent arena VMA from
 	 * being copied into the child process on fork.
+	 * This is a kernel page so set VM_MIXEDMAP.
 	 */
-	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTCOPY);
+	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTCOPY);
 	vma->vm_ops = &arena_vm_ops;
 	return 0;
 }

-- 
2.55.0


