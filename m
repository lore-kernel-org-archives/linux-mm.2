Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 938CFC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92AC36B00C8; Mon, 14 Sep 2026 11:09:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DB3E6B00C9; Mon, 14 Sep 2026 11:09:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A49D6B00CA; Mon, 14 Sep 2026 11:09:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 525946B00C8
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:09:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EB0351C00D8
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:09:37 +0000 (UTC)
X-FDA: 85212701994.22.30B80E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3AFD44000A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:09:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hrvl0D0j;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398576;
	b=EN4fOfbHNxvFdPlbFunrcxnOpRHR1QRvqO6BO11XDPG5tkgjaEW2ng7BRFFLSgK30M3VaA
	I92I5h6n96FyGTdltBgtrQF44b3iw6CpjsCBZOPFr+Ztd2FuUpFYHL+Vzci909BAul0vzq
	zlBkR5f5m0eeQyjwXcLLEek3AwpY+WU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hrvl0D0j;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GfRJzELhUA3zmjv637fDp+tblD+oWrGBxslIXX4F7cw=;
	b=G8ar2hCiV4fX5e7bPHb3s3qQ87sb+FvGGtv9JFr6wAUUxYb++tEpEQuSXXlKDdvPKpqJ+m
	7nfaAjYqQYU4MUgCb8VYlP54KGdlNiku/49Gig6tnfc8gd6owWEYMi3CmYDHFHHi5dr8iE
	d44BDrdEmlLvxIGc46hWOuv9vYbFTpA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B548A601FB;
	Mon, 14 Sep 2026 15:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7561F000FF;
	Mon, 14 Sep 2026 15:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398575;
	bh=GfRJzELhUA3zmjv637fDp+tblD+oWrGBxslIXX4F7cw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hrvl0D0jcUyh6uvN3XebCBKsuFl+Mh+LBuw54wmgiYZ5pJic6J+FDi7a7/oYIZbrN
	 WQowmRaCgo8p7AykmaIoxZo/pJ2dHmUB9gbcFhmWl45G2Mhh4yFuopGrBcctiaM3El
	 68DDeLDxRrJU/lwaOEljlbe9r0ocz39Hh4x2JFFkZNeVrvdYx+9pruOj7yeOkUdJdz
	 9ayyQuXCEa9/XjgJ7X8EW3xxS5gu5Ksv+bqTx+v392geCiZRa/zUWP9Lprrt22EWHe
	 i8V2yIXKCyWHgu7EKnmmt0Nm7KISk8cPtnmCihwyqZVRlPc2i1GMkwKxnVo8S8rDqM
	 XfgZBeADzZr8g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:42 +0100
Subject: [PATCH v2 22/40] uprobes: remove VM_IO, set VM_MIXEDMAP for mapped
 kernel pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-22-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2070; i=ljs@kernel.org;
 h=from:subject:message-id; bh=joQXUjvjM3OjL+Ta6QEJ1w5g7Vsv4M79ot1AULAZKpk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG+UmWFxrd5rX01VbImjwcymWUd7HFT3MX92PMF2e
 /PkB5K3OkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRu38Z/pcr1KWXq5Uo9Rn8
 OHKxm9XRopRX32vrvYe8rb0uOxv4+Rn+l6+M/c59213zYUxKnlCarmzPTE253GMTvmzNPZN/b94
 bJgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3AFD44000A
X-Rspam-User: 
X-Stat-Signature: dh1imnj3rf7rfdmqfgynq1y6irdhqosu
X-HE-Tag: 1789398576-378786
X-HE-Meta: U2FsdGVkX19SQMPzknmvdxL3wq5zQ5fd9Qi27hWLLdwPqRbS+lUkQn1cffu+hKx0yH1cMTryIS9K99Yphe0+PLT1Xs3H3xwEPo4PFG75OaZpOrKChPXKQ0P02YnbbYy5N0ENn349/NwQFCo2Rl/xPHTt8xivITm2uyY/eUE64LMDERgnP05WSPyChQ6Qeu9YLP7F3x4+imyF2gTuaR6aS2zPGFhRwPrH+TOp3bIoYkgDMYP895Ogr80ESClpujZUWEpeXZVMP5ZcpCCuwCJVjRr7qkff7dI4mBcVfJZM9kvNxDBpk2+w3xSgxJn16NGDsOZgl6TB6gieqGjmF4MMnGaLZVP9ISQBDQuRt2n8CRDmlfcdWs9v9CetGbxLSGDQwFEjhSdDZb6Y2LrvrY3zBXDGd6aMdtCv6z8M85/5W8tZmNUYKs9Evy5oAyNA6/3GsWq9Qzy6CYktDtoB26m7qVVU9xA8rV3SXz3Xw4Wbx6RAXBmYZvWeipRwvLy/79Ly/XV4EFlZ1Y4sV9HxGS9FkSCxuqiZnZ+QMmJz5IYrpXQCIVYqWU+I0tr/JMbIlZVxfiMpJ4st2URffVFOZzWaeBLjj5XbJPFa4vP/5cbaImwkRFhgfurXWnSdR9zZVbw/4VnYW0gC6fWLcaMn/CMshNbJTdFhR/zLecdodEzEafxCUUGbdyNXESGd4KE8QcWdYQ5L7eQSQDAO+iMbeoRE+xBY7RFMIAheqRf+SR60z59c8xJyE31bp1wyj2yDYspkk8OywWh02Muj9AeTEYFyGqLvM7+SfTpX6GO45OeXFStdxlruss7fwhcmIbG65kk3QpLhvdAMx1KVj8BmMYyfvOqiVl8K3PnMQ3RTzvWFAgtTdbwJHnebAB9qcqijWoKpuCCv5BpHpzM0Vyboiex3G6dDQ1MdL87T0RWkTgcuFsNkNhuQBfiXM/GFY+TGstWIOLvcwFlw7xctSMnZ9uw
 iMJ0BcC6
 UzTDpDdQQ0WnmBAKycfNrATeqkrmFuJom3dlX4Aj5RJf54LxEzNj2K0X5YQWIs01mzTlocIIt0IjH+VWCmZq0yQTpAoIO+Y72T/v/eojA4E/kuQgQvWWXt1pWXc2265SR+CdxBsShJ8vJd5WQX1QYOMUYLge0KibCEnbtAYdZHWOL4nur7nrFz+qq+BT40125UNnSHZTnQncW0HAuBokC2Jgc/eV8/pQpghLb9Q9VcSE5qR8whBI7X2TOVdJG69Yn6MCOCX5U72j3fcbRz12J72GfA/T+nTx+di3OSIRIl8KHoqzJQNT8t99XGwJvW4PsahUZgse5ZJCwz0hmMlKcRCyfJE4novBG9voARLOVyq2FF76lydZyR5og004tmmFlUv/5OqoOhnUNCHbx4CxWxhJFBvDp+LJs3VFUhlIDd9on43KksbFdoEjcCnjAEOj5jSsdlnGJ4Uacqbv8IJraJ09/Jv+9//FNwmORv6dq0Lwj91a8FyJIKU/mDfFrPZLcedO5FCYMcGRcQHxgCd1gF9gVHUtVPR/IDiTAXrVURXHs00laaPpWy5jSVZZxLBMtOYas5u8blT3+PjGQeWOkwSk4Vm1T4C4EyJg+PigVQVbRw0hbexx3D1DpD/eno0Y7DIQnyPUteycR1+MVjo2/JxCpX9J0SDAimxYrKMpQNjjxiAXbuVO9mbXAYU0LLnsD1a5chkik4E5C+ZZuMaY9rawe8IXoIb6a5DtkiB+Lty3o06JHCy1DExCZ6VaKTegVjdtWmUUaxiipNhNQIAfBXDnvd6yVgZPE1tWPov/nTehW9rWO3Qu5fHCFBoiA+/p3SyK0SEDNXtnF1bTyPeMu1NOHJWm0tFVSOBjKkdHsh97XTAQ7jwHHSeQI/iJPq3zhGhCgheSu1tHeD/95m29267XBLFpZ1oJvBmglCbbOhG4ipqBn5+TGtTPVtDzDIxK9WaQrOLVF9LrEZ+8z5IkB5+h2ti82
 NN1yEPuX
 v0rAcL93O3QK2EYgKJjqffAInrS3xuQE1xIvtrUgxlT4WJEJYB4SOGiMW0Cjk7rivQKGL7ArhBGfOvNW46CStQChm4RgoxvJP6nLv6TCd7ew6WvBwAHP8lWhwd5RVcfNn1TlNU6CLR3tUS6RamoIk7PGi80AfK0IowWSHAEJRB5E51DLu3jZLQoIMb53Xp/t8aAflOz2YnDqElh1+yrwCnIcF2Tqyhycnz8fofiL4Yptryt5ThZSX/d/gwb/8JSzarEsXiuazU6nmveH0Yt6WQO9sqSSxwo4qnOaJLdviRJg2ASwXn96G0YA0+OMzRVHS7Z7Zpyb/S+0K6D7APBiRrSq3i4Q8A7NdPCNffjrvj7OaBM+zXb8Irl/yEj6rPtGzvlQjwTlUa06kjgdq3KC71fDYyKCDBXgsyrJQUxjr1NDOUsu6gz7MPAgBSXKYEpvTXND0A/3/t0Zq7lgZZGyh9kG/bgwC4L30dpa6+hQQ+IoQYmjTjiBaILpnywCLq5WHEEhSM753Nv/Soca49dxvlrcoqyV9CYDHyPMTJbsudnr2U49pWX1xyvakDjtit2aSjugH6BmjzalpxTFU9fybAeba7+dG4U1m3HnRm8jqh8IQYKtNvOeqS4JDw3402BEjurUIjkKRd8Fh305ryJzFMG0GwIkRo/sS4L57HECJ/cupnVkI1kW1d6eC039ChWGu7DjsMEgfhciA4hT83Pm5j94pzSM2sQC3bZ9vRHC7BSAzwesytzNlhSR16gw4Er/TUt6eLjnhceOviAZhmwOWOhZV19+TA+3L5bXZyIQ9RCz4KZ3BRYL0p7rrtHE0wKynoRZiWBM29Ub5IDqAECgNgzzfbk4LKxV0Wv6lx0dpzwPiDuyUjGfnD3ipaKR/byAOMVaCI/OYcZx9y62Jm5katP8eqXZaC3eJ/5iDJ5jwzm2b6N6KEwPpuZJU8RdvRArBaPEyrC14jVZKIBkG/2BdtP4xvhNr
 PPp/DkeM
 u9plD/V4zn3heh2g+9om/CLIa0Mw4VMNjlHrqO9reqEJ2wjtt8TmYMeO/QfdL3AVAdLQ/3+J2G/Ovfirg6ICx/u8i13oCJX/1VKLLtnxfbOgFH7LCJfUqYyE63GQUoSEDjtgALHHmruI9yJSkgTXjNoQTz9Q6yrQ9+vO+zezNXSEcVQ1TmvsayvyUXgPebd8ys9w8gsxvXsmAtqR56jfTzkzOcJ3TlSueg1meloaJUfPITBj7UYlv3MAnevLeeaw0mYQouPvHPQW0ynH578EKEkfvQa4eEE0qOBcA2R3tWOzVqw0tA3njhJBM8Qp8ottVZ2JgN2kxZmg+c/VQtKY7T+Q2KYt9+ZgdGW2T092GhnByYTGig7SmrC6eZWxbwOSAR9An1zH2ZBP5qKnUZVu/BJ/y4czWFMEsRaGmSb2VFgXMEdgiFe52EdIkeA0Bq2OaECILVgTsngazMtfITIK3I4Ns8Yl+qUIpqiUAbYgS53pvuqr5LjgFJC/8sXGBK7zqCaGu8A5aXaajNthX6e1zHJcY/H6+0AVwnF/ZRJXzXftmWWj+1WKoFM5gpcnPoyMAHou28sg1BxK0sZGdW/vvO5Glh2ClrMiUpHiQC4U02ncBYmjIFwbdVFAzfLU3dvuRh8T3sbJQ0L5Kk11y9XSIxAIz7+HYBi/PUG837nOhfSsD2W3NWGJVb8Mnn50dgYcV+FkA7ZvhhJQ7OSpJ5E40EHLVlYcIG5O5FLs7IqgA2TpWYw5CgFT0H2hMboZdDChbybtUysDUwZxSVWTzhgplT0bDKAc+1LRjH/vdV53F5yVsH0Sl55xo0q+1Y3ejtLdVX6naFt5Y8wxACPaJIp4Gsq1l2qS3SsxNV2SNpyq3XFpHMDam/zyQG4MDlhxj2u9CmkIuqjlUXnEIMGXQ2eBG5PD63Soijx83E45J2QYHEb3SR1oMl9+IxrUlXyyj/KSseuG1tIup9XWAzdN7yi7anAaHVlF7
 a2rf5jy9
 bm/SgJVn/qIad6wROmAI9URTcJ5inyXWhmCsr7Q4h5NqinW5hY8muqXCBhe3EVMW+EwAA8xw2XIXpbRdnwcG7+4NfNrCwYaFi+rim4EWzOPO3BjfJvPbQ6YhgTM9NrdHDcO9yv0R1FlapGGvAnntIkXsdVAkjfaCqzIbv3Rp9Bww9XGuMfW7p4nU4TA1FoU+k6sRdOiklA9Qp2BkPMQ7lYeZX+kGbiAizkOI/oRXOnTWRADe30spH750H9IGaDk6sZU1LwWcOK8RujSrH9XC7tuMGmL49migep1FQjWKlqF9BgfVXe69aElDzI8iSbVranxX8+IXe/X3CW6fF6fWtb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These are not MMIO pages so VMA_IO_BIT is an inappropriate flag to set.

Instead, set them VMA_MIXEDMAP_BIT as they are kernel mappings and this is
the appropriate flag to set for those.

This provides the semantics required - no VMA merging is permitted, but
does not prevent GUP.

However this has no meaningful impact as these are refcounted and thus can
be GUPed.

A previous commit already prevented __mm_populate() from being invoked on
XOL areas, which VMA_IO_BIT was previously relied upon to do, so that is no
longer required.

Both VMAs set a VMA name, so always_dump_vma() returns true before
vma_dump_size() reaches its VMA_IO_BIT check, and thus there is no change
in core dump behaviour.

Change this for both the core xol_add_vma() function and the x86-specific
get_uprobe_trampoline() function.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/x86/kernel/uprobes.c | 2 +-
 kernel/events/uprobes.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 65a2de82ecd2..0f60c0d076b6 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -715,7 +715,7 @@ static struct vm_area_struct *get_uprobe_trampoline(struct mm_struct *mm, unsign
 
 	*new_mapping = true;
 	return _install_special_mapping(mm, vaddr, PAGE_SIZE,
-				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_IO,
+				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_MIXEDMAP,
 				&tramp_mapping);
 }
 
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 7709ea882477..b89cc5cee002 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1726,8 +1726,8 @@ static int xol_add_vma(struct mm_struct *mm, struct xol_area *area)
 	}
 
 	vma = _install_special_mapping(mm, area->vaddr, PAGE_SIZE,
-				VM_EXEC|VM_MAYEXEC|VM_DONTCOPY|VM_IO|
-				VM_SEALED_SYSMAP,
+				VM_EXEC|VM_MAYEXEC|VM_DONTCOPY|
+				VM_MIXEDMAP|VM_SEALED_SYSMAP,
 				&xol_mapping);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);

-- 
2.55.0


