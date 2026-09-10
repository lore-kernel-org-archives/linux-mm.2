Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 076EDC79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 18:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D02CA6B008A; Thu, 10 Sep 2026 14:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D6A6B008C; Thu, 10 Sep 2026 14:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B06816B0092; Thu, 10 Sep 2026 14:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 640226B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:11:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9499F1A061D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 18:11:33 +0000 (UTC)
X-FDA: 85198645266.28.ADCA492
Received: from mail-oa2-f12.google.com (mail-oa2-f12.google.com [74.125.231.76])
	by imf27.hostedemail.com (Postfix) with ESMTP id A17C240007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 18:11:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M2iwphL8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 74.125.231.76 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789063891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gxuS67QpsgmiVo7SJODgVn7jNGL8PaTVeXELBYXj9Vc=;
	b=rpbueQgUauupT40Lc+Pf4AJ6bHc4kYrNX5SqGYpBfkaxd3zlID9aGhaSc7p7ubLMAxXFai
	dClXyed+FyhN66OpJ5KBV6rE4TPTaJcLxtVQL54HNOoVc/NT89PafBQFzCYXovK1t0Vb8g
	1ynqw5JyuThuy7+FVTmIVBirGcyWMRo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789063891;
	b=66eQ+F6kXwb+LklLkAw9Xpx4lwXT7nGbRBHy22Cs5Icuyw9LlHyYtgC2oBl0rxEpTLtbVo
	9O5kahgWjxJTjV4XsIhp1CbQ8I9BHfsHnWBqSLeJBGpJACQQAVH0mHQBQxEx7BWWkpwL2N
	WIMVIed/SkCB1h0H/4+o+r9IyV3qqUw=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M2iwphL8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 74.125.231.76 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oa2-f12.google.com with SMTP id 586e51a60fabf-47b5043f191so4254fac.3
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:11:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789063890; cv=none;
        d=google.com; s=arc-20260327;
        b=rQcNB/546bkyiJsZaWIm/CF6SapClYLq1FheI5O8//nMpK0YjmnM9xPYr9hOYE0RO5
         3r+kpiYCcMmXCJjVLz+XI6JPjF7cVX9cGamYUHzNiGyrjaHJo+qgIxnaQPaI2yHiV9Mr
         1ZecHoOFcMY2COexkShLiXCHQDoR4OU/5uyDt20Cg1mku9bJTKdIBndbrGpT3dtjG6uK
         ud6CmHpa1tjrAkKfLV54Ed9NGDPU2LFyQQvnJAPJa0QdkRYG/sRp+RKBCZLl1Nl1VVRz
         BRcf+xGpMSieohKGMzbUvBFzoPOJrweLw4tqvFaiDa3hgJpHyG4hjt2QEYN1DH0Rqfdn
         ugkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gxuS67QpsgmiVo7SJODgVn7jNGL8PaTVeXELBYXj9Vc=;
        fh=J04+TWvAp7oYaKEyAUQb476VS3u0lgU04FXf2ZOb3mw=;
        b=VfaiU0ppd/dGYrgsPZKGA8jpW5yddhMNQrh07dMG2R2sj+DoM39nUmU8A7FUbcGdyM
         t+8X5SezEI9JFb4GvzudvssTCjZQnpucWKyugcfw+ywBILsA4yLvGMCCVbtNkR0T8I8U
         07TDdBrMzMtPMr2581uAwtN6I8l+kSbvh4UdhT3t5gFz465NGuTrUbJafZH0vanxVGnN
         JBr6XmIBvfALHRjQsHJdOxsa0HJZ+YbZkwVZv6HYb7yQDuSTHTDauBfYTPOr1L3y6Rkz
         Q0QkGQP0dRwSgndmR6W0VdPOrx6skjlzD1JkzpGgVqNB5Zh5XowRHzfZ5aPvBvW+ZEAb
         ShXQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789063890; x=1789668690; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gxuS67QpsgmiVo7SJODgVn7jNGL8PaTVeXELBYXj9Vc=;
        b=M2iwphL8cFzaACgIGiuTi1vDfayRO8P3rHNxXHKs+HJCJdsTF1V8Jm2g/VxxZkdb8w
         9cGw1gxI66lV9zizCYpqBRzgJGJsFu4SB30toaqguJ2SwLzph5zuHrLM+egut6j5Fa3m
         ex5tpRz1kJahYyqqNsG0ZQWyh5QdN53MgbDlM2rqgxlbzFS431F2qjo97ztoaxeNx7hO
         4ArSkgkmd5JKee8prcMumbZbaVnXzE/3VZtgsBryIWwIPDV1lTdMrr4lFSD+teu8t2zK
         3D8Mr3CebVv04FJHp2oG6004JG3UFN2ryFAsjSPGv1rJgbR2V79lt8SAPkuXgMUYzwLs
         +7AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789063890; x=1789668690;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gxuS67QpsgmiVo7SJODgVn7jNGL8PaTVeXELBYXj9Vc=;
        b=SZODVtRZ5sEJK04KalgKmFqWJpqAMoZGpIhdNnBQoHVKxUCVDtYekUVimXJz+KMVL9
         180kD5oL6thW8KN79C1PVsiMgF0yGEvEVfjZFyBXLsvNp7p4dPeo7sgauc/3XeGKjc1q
         fvcQd1hismO1F3Y7oZCWeMs/WDbfjbzVJ5250YSnZlb8X2yp0dZedvaXSwZp2IIT7z47
         yusL14LJ7+QO2GVBf/hbhDlF4CWUjpJPzHdu6yKQS0WZRhUm9FCyslK8q5PAXu2HQA+H
         zXt4B6pp/Yu48vYGJfRSiYMVz2BE+pvw80O/aCFrVJWOI1Yxa5jXq9TIz/JhpAAIqkkL
         Ee2w==
X-Forwarded-Encrypted: i=1; AKwUvBwwdhWlaZysSg0TYCQI035x96+N4NA3v+2Gtinzim9dUmaB6zViudV101JLrNDU2lgdG+LJQxnFpg==@kvack.org
X-Gm-Message-State: AFuF++kRjQH9DFdr2zXHJkoNxnKrqMTVpYIPYUFriRdsoTTF20ykhjPq
	RNnzZ9PNCvJa6gfHzQCyjMeHSwltJux5MpUXJxYeu61pRB5T7f/umYWNcWaRNNhdCyOL/JzO5Ta
	yLXffXQgbXpNMPD724qxNwiHg0EnYWn8=
X-Gm-Gg: AYBFou3JJeER4Pl1iPbES3Z374fvQsH/qSn+6B2UBWTTRO7W5CPuGuotK5fAbT6IWE1
	UX7Ae67bL8IqXkVdt8fpC+JAlcHk6K8gWmHoZMdeQABxgJb8q2PBs4/58QXZ6+wBn6nit8KmVKZ
	3gKalkNB9o8rBG2FTO5vLIW+V8mEUMOZiaxpP9xTrOh4slM9NYZ4grU8rgIQCKJADobUnZY7hbM
	I8idrFiWTlGIQU/4BGL9usiOftuet79ge1pQrmNvRRZiVuTGvqI2DBpl+AOHl2BdDxLlP1KpHCR
	Pys/YzVnjbIxGAo2utuVfmKiYmmTNmA7fRh8HJN3idhKTbmdjVX+Big=
X-Received: by 2002:a05:6820:55d3:20b0:6b1:ac4f:f708 with SMTP id
 006d021491bc7-6c0bc1d3ad3mr241038eaf.17.1789063890425; Thu, 10 Sep 2026
 11:11:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-11-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-11-dacf19cce22b@kernel.org>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Thu, 10 Sep 2026 14:11:18 -0400
X-Gm-Features: AcwNN1XLr_yN2lEzELD3PcXDse2cuW9BBHCwsQpnROCV_SxzPvFmiqhSaiK704I
Message-ID: <CAEjxPJ7hXSi=oLtQPV+7GEvN+txfYwZ-u-v_EysNHM0gSGNrCw@mail.gmail.com>
Subject: Re: [PATCH 11/39] selinux: reject writable opens of policy file, drop
 mmap shared/write check
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, 
	Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Arnd Bergmann <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, 
	linux-sound@vger.kernel.org, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A17C240007
X-Stat-Signature: znz83kjb1ekx644wzkwutzr1jsyy991h
X-HE-Tag: 1789063891-584736
X-HE-Meta: U2FsdGVkX187NrbfFSF9qTj3vlfebagPZLrIairnnbyK12INiR+2X6GWGlH0Jl9hryItdC49DrVx/ItGE4RW9jwaoSyjCy2uEcHuOqzAvDeluKcuaqZBwkYQF+kiW/9PWu1MzTJmwrflWzBLCv8EXRI7AlAi2SmQUccZcGA6lhRm9HajOjHHsbJjMNNrTgoAFF8bdIDenjc+DNW21Kvi2RAT0v+cqEDzVPM76bkrUJX11A2VkbdKo4cJKsphXEoZEGJvv57HiaJyrUilUW1uds2JZVaKWmWu0oI1WSDn1IlW+Y5vp51nk0hTvkwqGF9GvvD2w6c8EQ3tte4Fkjf8e5iYBkDe8AtBoxJHPkNIgTIoAJmbbN8n9NL3WEksYPY60YK2V/xRExEfh8HXx7dGla4BPfPYaZ+dkTgWWupfOGTdwFT9XDThCOKFcvhK/ZiKW5Yj84EhkWNyv4AI7SRFtfcGxIZgwvNsAelJjFEXLdfbtyO+38ifVsC2PzfqbboG8y9bPHL9+/Sj3a842nok3PlJx+P6XUcDZDh/kgY6pnTItzdZPfPsu1xLwTDQkZOnCUi/5SuxOkF6fMbERxxolINfjQSqNIY4oHkaHq5VkcQDGB86g5Tk1dmtonwPBLbkyaKqc8NY05GiJ7LQ00oihRWyvkkis1h4d3DbQri8AMudfZ7aX6/bgZwDrl2aH9Whmccz6kf9aFRdBljXq+2SQo8NBuvLctAOaNUsOX5n5s00/TIHkbLhdXOrRTEWohZg9YDchpsPwlVJxi3bv7FMMEYrmibvqAewIMLMeW+ZoeVSK7bmiwPJ4OBhklUxyPRK5347L/moAt8pe++7pznLyVQ6TWXLL85ZZULrdHxWJKBpTgCa7rDYUDNsvtrjCAubBrvrVvkf2Mx5gPqxvx4Gu92AG1+m/eG56ppYZFcbu09LX+vdxrcHxnQuHx9aY/++cItfk9oLifEjfgef04b
 3XqdJeC6
 ZlwcWUzObjgEh2FMOrUh8JJb+ZVPHIU1AhwWsry+R0+E4x96zR2Gf2NX7TBGSabK493YcBtlDYVygl398iB64VlU6rKhbUPCR9ce1f8lqSm4XKQawBgguud56FilQzdFHjmGeVEzxOebtaTKkoLWYIs0sV44QrTpvz8EkI+E3ERX8apAcUmJAGmkhmuvbZUzqqPaTR+LUSjjFMMD5QqlTBqUtJcorteRU4zGrzZEwPqRQAqD7RAHOXw/g5ujxjzrxSgvz73uFqiW+SPDdKfC8dP8fFA0IGC0Mc9hdURxvWDsSMzt/OqM4G8zmyg5v35bDsbLkjLO7IDtvt0gj65BHYjeXp5Htfw/lhXBpUEVF4Utxaf8po8rN7H+5bp5MvxRug0Pn6pmHOuvAqFLf9Kp4qCo8ebOUaR9z+dyhPveatU9tqjmldK2R2807dLGEFcpHafY1t0TfIMVTpgHoYsg1CstUoGq8cmSc+4fmlycDDpxVSMEbk+8ZmdmVrv5CSEBVtv1swkEZU1LyLB/3AUbWYTatldMc5bBA0jNYdWvln16YpZTQCjjO+tK+Y+Xq7g+fwKm5oyvCr+N/cDFJICdQq96SCpF1dJ/+8ULrk5UHvmmNJv17Czw88kkV7vZxwgza7d9mni6o7Z257hgCuROtcMJfP9XYFhmuy/vyF9cHe0/PCEG/+RnqTi45nJ3aMI8DdTeAFDB1zf0ykjYlLzArYkRKlsAr0EAT6JIt3ZijOdistB8daT4zNR8Co9I+TzTsAvm3/0cKvXo3AKBAdcBm/UdR/hyx0g+AYqTjSgo2J2zT1xhsuh6AuOP2nnL5jzyVavQy3riOyq3+VBkBosuL3IYAXHpy10fn4WxADkcXN1y+HYxV7JNEgXjSYdWntmkPUhvKIanQLWW4erg68Z6s7kaW7lbV/FTiwpyxZQt15y7l4KsIUBjbh+ZL9E6zO2zv0xCseyOdwZtLI0C7m8gX5Bb7/No5
 pf4V2YkP
 j9JsIxRRbvNvnOu97sohM3IeuoSnCKo1IdheywoFY1N5+DaoEZG76/gHJx1t00JFjGvjUsc8DbLsDhk3+SvQCQg2xkiQaJImdN8VlrLkwBM86CI0bpaBqA+u/lqbYBZCu+qi/PpccpzvMPNGixJXshQvQVRUvgBwGs7V49aaZHdNBvfnrnWQc4uwmSSQPO1RpFLo8EjZqP5lkRW6I4VSY4evcU3W/6LK6ZykDDvGKPGtNcqLjkXNkF8sWixm+V/LwzJGnaDp2SZyssr7GrHATUeOt3p2buogbw1UbIGBSi+dJcvJPCk5u/kZve+U7NioE/If5LY8TNu0wOkoJOBLW0HZeqJg0xjgPs8RAjlfrPeZoZGUdzsVq755HKYHcFqv5lD9SEHtm2XxyLokw8OnFNGFdZ+nNypvXjcZCycVNUDRWHBSBldY5uWzdCbZ5N6YdAHEPYpoC2U+E8XU8NjqCLbYYcW3xtYCeV9Qtwfk5oKcUTasQ9ofpTQf8u3t1KlzkeyhwE2gz055ldAMDDWCc3jCW9kf8Qghd3JcMrQqm5TqrVuFz+6hohfdvePapGwWmy7Hr0jwqeKCPTlZGbb1IeNe8NY6IsIH9AkMtrEusykqGTox/UeQcLPgZ0P4Ekc6qjS3idcI0rOqP0HjuRNUHLiLgMiMRm5jIMp+DuA2vuEJJ6rQ1ExKcZLxiNq1CdzRchwqiSCnxgIA8ole3yNcCxOzE6FjDFVrl9hezXh+0MmD7LiUKDgNvBQQGjLeROONpe+e+aWvyeV3KxSElQusSMGpZB7kPFZ83ndJUQn69sViUoe1HXAsU+YgJSyKgsSTSELYfIVzx+7jfLaOR/5FTCmstAFDhnUhapnP2neU6DA8OSFCeIUvYMI+XLb4S34hBv6vuh+dJp1B65obHTaqo6iJXROD3lxx+3byS9cuABpFl8uunelJGSVUD2azBtn8XPAOEOsJuINoUQ0WyqTzEJiSVMvHU
 ghCRUObX
 k71G/43eVdVB03sgGpRPG0UpbgJ/3j88EaMbApzs4Ny6ol6vTSjI7NFZ2FeRy3yq2c20IatugvOHsNYI8QUONdQh86kBFeVqslws2c9iS3UUHwpsioDfem+UaW9g1hMT6e24EdHSS7o1Zhx7Co2BgKInujufZOfqxcE5xSVLObyJuQ7+FaI7wkpHDjoN/MNvK1qHWQYO5tyxRa56rokDKGK/H796DG37ZbibTIk7L2wvIy6gEfsxVBdGWVV+lslw9jRUilI2StnE+NrsGVLXJKE+kAtSdyiUrm3VMvFTOdpXQiNjNuUOoU8BL5sfoO1rgVtDUqWdVW/MaFNAqQHDGgUbS7xqwFYj4Deit6rqAvWZNfIEFo2j0uCDALdT3KW58B/4cMz+w6QkvsjX01JN+DAQpVNl+WZlMCwSOB+krVTyfsH+RA23HgZXJ0qssAQHaY0ORVprhtdc6ctzqGSo+uq58sDMViK3YsTHpWArjDYdTKH/uwUkuRWfDCg223yZh/W7d7TTwpbxAxnkkBab0d3f8T7EZfntoG1BgE8JkzV9BR06wjqW6Bj9WQIC6HP8DV87tlTx+ut1Bq9OlHyriwg0teabBAfEMSKxfpa4DF6Y1PdlqfoUxtnNRa2Md0fh/hcm+0l/8+80xufkIJoF/3LdWMP7dHcwVe8sCrsgFAQsCD7gJgpOoAgYSsFRb9VKEWI0xGvwsS5c666KShhmsTM/rcTVz/fMILPvI8bHvJJ0/W1jAYUbIzOKnf/X5H+OXkyxcDsv5I0aqhfDc4jM8GNMLAuosLe89bOBgxV+PK34NWnH3CVasitQQ459x2ApMF3GB+w08QBRPpdAFR76CrOgQDp+mCH3pQq2ieDqrQsOSXRfB5EAxo/ecHAp4H8ykvNTienhYnaCbTrKAWeU2YU5T5prdmeMRGhGBRI1sD//qcT7LQp6TKjv2oEU3Hxclf6Pg2M9imG/oyMdVhtnohSoBgsd2
 T11/ZilM
 pZ3J3sx2Ldftq8IR5k+1F69eW7rZndGf65YR+RnG1g0liTlNLXqtYZ3YACJyxMx3zjX1zQZMWcQ2xuQGFcR4bfma/yO0IPDMbOk5Nm8VWtVd9tiQjNtul1+zjarZ5Vkz5vdXn+y2bXmMFYCvhanvym5cJcPvVD4bseSUFuTCaxDjge7fADgow0FjrAesdUdTtgwmQXqkk1EKlMk7pDrh1/ln6QoH+qvXYzQXR/9x+jqFdbucmGOzqhda+v9EB28V7oLrfWXFO5Ju/rncCDWXpotaQcouSR0ZXqCTiV64mSkzYgt3gn8EI2eYPcQYmN4jjH5lKlyY+DyaU65+VqBdPiIQbNZYiGIzO9biNOzjIZIqaV/vz5bxn7oiNjCJu8YzPJnzHtNi4tZa28gWgIp7kyLg8RyIo9GuD1fNfplBwHBnJkBMiSl9F0wIQXKBPdVAd0uduBaU2ky+CDu11UtWBt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 8, 2026 at 4:07=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> The policy file has no write method and is exposed read-only (S_IRUGO in
> selinux_files[]), yet sel_open_policy() performs no open mode check, so a
> CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, a=
s
> kernfs does.
>
> The file can then never be mapped with FMODE_WRITE, so do_mmap() always
> clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARE=
D
> check in sel_mmap_policy() cannot be reached. Remove it.
>
> This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that =
is
> neither a PFN map nor a mixed map, ahead of the core enforcing that only
> such mappings may do so.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

We should likely do something similar for the other sel_open_*() and
sel_mmap_*() functions too.
In particular, truncation of the status file can bring down systemd
since it is mapped by libselinux.

Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>

> ---
>  security/selinux/selinuxfs.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
>
> diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> index c7d91476971c..545a6f89f9e7 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -340,6 +340,9 @@ static int sel_open_policy(struct inode *inode, struc=
t file *filp)
>         struct policy_load_memory *plm =3D NULL;
>         int rc;
>
> +       if (filp->f_mode & FMODE_WRITE)
> +               return -EACCES;
> +
>         rc =3D avc_has_perm(current_sid(), SECINITSID_SECURITY,
>                           SECCLASS_SECURITY, SECURITY__READ_POLICY, NULL)=
;
>         if (rc)
> @@ -424,14 +427,6 @@ static const struct vm_operations_struct sel_mmap_po=
licy_ops =3D {
>
>  static int sel_mmap_policy(struct file *filp, struct vm_area_struct *vma=
)
>  {
> -       if (vma->vm_flags & VM_SHARED) {
> -               /* do not allow mprotect to make mapping writable */
> -               vm_flags_clear(vma, VM_MAYWRITE);
> -
> -               if (vma->vm_flags & VM_WRITE)
> -                       return -EACCES;
> -       }
> -
>         vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
>         vma->vm_ops =3D &sel_mmap_policy_ops;
>
>
> --
> 2.55.0
>

