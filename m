Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67246F8FA9E
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 17:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9663A6B008A; Tue, 21 Apr 2026 13:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 917BF6B008C; Tue, 21 Apr 2026 13:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DF0D6B0092; Tue, 21 Apr 2026 13:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B8536B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:09:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0BEF98CDE6
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 17:09:04 +0000 (UTC)
X-FDA: 84683198208.12.9952501
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id D86D2A0009
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 17:09:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gmaEmtAo;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of fvdl@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776791342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HFQ8wxNql59DNKoY4m4ShNnIhY0FuV9hRkmF8YGbPEM=;
	b=HwgsgZwXc7PTqL180HbpPlmGHS+tioUOrFM+D+TqgfazWwlyQ6dAdSpoQxNGLAZt9DcExo
	PthJp0ETe/ofVtBaGVT+33jVTffgAMaUq3qN8xl/S9HkXYP9azzVNjQs2CHPt4C0lYRGEA
	kyj7Z1or806rhhWj7qhYkRhysd8NMMQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776791342; a=rsa-sha256;
	cv=pass;
	b=gRND8Nxsxy2bMjkRSf8c9DF96NACS1V3g//+dFgqvlCbYQfh4c2OvPAA+KeB59u7z+YcWh
	nX2uBZNLE4rxi0QHm1/lpQ3fdjMpHi4dl2RrNOYPI+DBSvolbBZfcSOIpiGuwfAQbT1KYo
	GVOJ/1GAwubZhHJY3j9nI8jFSLVOKRI=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gmaEmtAo;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of fvdl@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4891b4934ffso251625e9.0
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:09:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776791340; cv=none;
        d=google.com; s=arc-20240605;
        b=QqFQYRq/uNmy9UJysRo7RgKCz4HiWzKi7Na4IqKKm51TbV2WAB2wf18nOP7BeVL84I
         OA7JU3BKm3+NhCn0sHh+8OmHoM/vb1FlkgccZsgAcie4roOKlZxhHnkfeyTYzXGD8sEj
         N/fRJ5Ovq+LLUjgapUr8fH2dxa08zmueMdJUdl3aZssArwQIMuDTcKdeMryyY/Welp2D
         fb5qWEU47uaFdK7fDqxiJOTUR0ll3UZR2ROWcKGbnphfMjkIMhYsbmM/GlswEL5K0D3l
         XxPsiQTQZ1VmIO+1nBOZ0Ym4Arv49sqK3GXoqEssZMwYveDznwOOfcOkuUSluRt807k6
         itZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HFQ8wxNql59DNKoY4m4ShNnIhY0FuV9hRkmF8YGbPEM=;
        fh=ZLAX2SBMhk/gMI+iwBBsa2dbPkjzKZuGtjE29b944dk=;
        b=D8OinEOhYj6ZnoUh9GIW/E8DA49BCNy0NvJIPQ9zkxzGmjIpspvdmCHKM6aEZeb4We
         UgBRwD+1Yn5NvcWyR9lHIgm9KVix/9t6vvDA7u/uuEcKFdSGumRP5icWR6Ng8Kw/y14I
         wfmlrRQbnDEUw1uD+zGeBO2U3Fh4f1aed1lh3qUAn4bXOjVwZiJoHQVIuBk2hOGultQK
         MxByN5UyXyUcZUPznoD+vdHMYPUCOUfxhDgMkZj4585Axl0cfMhEsP4IWZreZ2cVm9wj
         V/Nwf4MlrKA5aSTQLBoGkgemyZC/9X2om+BR+1FViJOL6wvKMPh/PnPwHEH/e/mCFwTj
         rxmw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776791340; x=1777396140; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HFQ8wxNql59DNKoY4m4ShNnIhY0FuV9hRkmF8YGbPEM=;
        b=gmaEmtAoL7+TCFPWFNor5pLB3awygHE++j+eI4cGU4bI9Uxw6xHl8Ob9mirTpN8/a1
         akSQxt/11YkVdcHjeUa0U1XTKu014QphpWlyoMiboYXishKSC8VcLHRWizjF+I5ZVK1E
         FwgWxU0T/JqCjwk4W2fW3hH1VGHj+JyK3qKH45aiTayctFdMRZkdxm0KcOQpqxO1qWR2
         Q975ypMbtbuFMpI+8gkep6H8boVDO6lu6qjMe6XxjQLppa/6LiS1xzaNxmyZycb8Ja93
         chaTGkPeHLoWsPOu9llHlmTc4s4EgxU4TinS5ZcfYS1lH1aQuObt6rcyBHk6VvYtqzgH
         4Jiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776791340; x=1777396140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HFQ8wxNql59DNKoY4m4ShNnIhY0FuV9hRkmF8YGbPEM=;
        b=dbD8juGZKYKfjLpW3Qs+ViU/lRXaIwMV+DAoXvS4uvGO6I3qhCQXXIbPCVjjdQs8Gy
         ts3Q1VNEo9wYaGjxsOg5RYTw3iuYXJwWG1LgcNBWDuKT8uVhCBuSlsYWcgqqBIDcT7uE
         6WmWy1Cchr8rFHzWXa7XzrH/DX9YtuaGkVudgl77utg7JmpXFvUyCrYP8PdTtHXgrFjK
         RzMF8qav+vMCcGD0bH6+7R7ScxxzQFMM0trQDl2c5u7gWwEDRjQX4WWjGptCiEUuQsqi
         S8hsd8ILQuEMKu7YPGVe2LElv/MLLFPTHi5XL18dbciRV+XrrYgElsg8KPpREH7mctmE
         NO2g==
X-Forwarded-Encrypted: i=1; AFNElJ9BRgpIlgfIs4caVOktJiuY6vqxVwCBCJaWGGqV/Vu2jvX+lD4vxDUTR+ARLgwTXO0m5fhxybthXg==@kvack.org
X-Gm-Message-State: AOJu0Yz0LsyQ0BgKWwXz8umhf/Xz0Nd1Uh3ZE0o/eyGGna0ARJ799pcd
	uAWvRs0bjCMTdANttr/hiLm5K+fhPUtaiPBl/nBHB0KkZ2xqdQ7iM/7YNckfaJie6mFphu12N2x
	1YfCGc5lX7sHPL+z+v1C2dVWXNXlfDzsJzGpPaVLb
X-Gm-Gg: AeBDiet4aTBwndXpdwNHhlUdJ/9L/nXWEYEuSnwgc21snpNB32tVlBMBNde8rCGJWX/
	meQAUrzDourpvQXchSAr27wZqb9DP92Fji8OWZ7tulb48pzw24yt4oLPgbJjc4QRsoOiEBPqqJ2
	75wLSgjQB8C3l/onKC2v23yf0xR1c5UrY8y2hXKbccsAwjEl/lo6YMxF4a2x7+MF+bTxNzfq7Ry
	ia790LE8fZfVKBGkwamRz0xGPsR2EPZplbkEChpbrcFUo22mF4oCzrmITu1/yi9BoYvYBqi751H
	VHLahDylNa2TmIS6R5pkLQ3b2lZXVNc886sMrhY=
X-Received: by 2002:a05:600d:6443:10b0:488:c4b2:e832 with SMTP id
 5b1f17b1804b1-489013bd895mr2808755e9.3.1776791339707; Tue, 21 Apr 2026
 10:08:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260410151746.61150-1-kalyazin@amazon.com> <20260410151746.61150-11-kalyazin@amazon.com>
 <aeemS2wm38Cm4qAf@google.com>
In-Reply-To: <aeemS2wm38Cm4qAf@google.com>
From: Frank van der Linden <fvdl@google.com>
Date: Tue, 21 Apr 2026 10:08:48 -0700
X-Gm-Features: AQROBzBifkAsQzS0X3Z1RL6hHFJu96bsJJpCRfOrgFmfYjKrDR-uZJ-l8nIAe34
Message-ID: <CAPTztWb67XZvfcMVnbegDNNW0LJa9UsaTGx3M898xJUJrekk0w@mail.gmail.com>
Subject: Re: [PATCH v12 10/16] KVM: guest_memfd: Add flag to remove from
 direct map
To: Sean Christopherson <seanjc@google.com>
Cc: Nikita Kalyazin <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"yosry@kernel.org" <yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com" <tabba@google.com>, 
	"prsampat@amd.com" <prsampat@amd.com>, "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"gor@linux.ibm.com" <gor@linux.ibm.com>, "hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com" <urezki@gmail.com>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, 
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>, 
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>, "lenb@kernel.org" <lenb@kernel.org>, 
	"pavel@kernel.org" <pavel@kernel.org>, "rafael@kernel.org" <rafael@kernel.org>, 
	"yangyicong@hisilicon.com" <yangyicong@hisilicon.com>, "vannapurve@google.com" <vannapurve@google.com>, 
	"jackmanb@google.com" <jackmanb@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	Jack Thomson <jackabt@amazon.co.uk>, Takahiro Itazuri <itazur@amazon.co.uk>, 
	Derek Manwaring <derekmn@amazon.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qgb6okkxgp3w63b1ggzzukxct7adpqke
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D86D2A0009
X-Rspam-User: 
X-HE-Tag: 1776791341-110810
X-HE-Meta: U2FsdGVkX19lJfRre3OqMMKuh/wRJMoUytR0aQPI/HGVKrKjXYqh0UvU3GZCTjHydKSlaucAh+GPGSkolm4eU2S3E5Dcfpbjg9OvgNoaKAxIEYUd767WgMC+ibg+cANBnBPCpFE48f3IdIjiviIhRwbYoMKEQFAkd84iQomHaIQ5mVC4T7dMJf5Q0P3j2tMeAAP6Vh1PaHNjwxEVMJF7FF56+BuW0GL/7acPwW2koN8Jvuf4i85a0DwO4Jk/+Q7TDATy5q5dgJmZSG425g1r8D+bb4WnIppEfO0rVuHmLZNV0LosG+BK28+dbOlPrMmaKBeGYt+R9z+bzhGWccRHfYvuHpNf6hutVnqzNxCI/xyJfF+uzudCdo8e2EtBA60Rt3FmIXlXO8BazrdanMixbyOa62YPYcwgyOYcr/GfEFwhIz4Cu2VzQVHHPZuB1T61NyetJ6EhKx6WZe8Y/jiF/rKoG1W7JlKFN89HfB8oUdkzJ8SHdE5ftyPLe6agsV5p3hv1dfK3Gt8ixNHiZogamwAp0tpR7nekRm7mkvHMsQj5HcsVdb3Qrp7h89Y4ltyuyZls7cXwPflaqu/z+QmIBmJ/jkhQjjxYvojjd157sTI8iysAJrx0izneADvOGPnf4lXYOKihE1XMchJ7c4J9pRDWtWeptpxXfEi8qsasjuqvDeToZIFThWexZtrYbAkIynlwBHRA9kuSTgST+BeblMsBQf9dSl/IOIpPeFSw+z5tcwp9jHwChBmbo63pwGwBuDiunfFk/6zxMq7es1MEMeNH7TOGcMv+s+0SkO+sp+juwtK04+ene4IQ4PXTMNIqvPOYMIc2O5fYbfTp+iq59QwUXGkZl5DPTaWduI0JNjobviCp2AjVC62yUKZgV6P/BXeacD3XBdUIPGdl4bIa/tJ506zxYz3PTLo/oFxG1DST+gzJ0NoqmV4CMJz+X9x5Ev6Ch0EeNt0YbBVt3fU
 8sa/9Key
 h+aBdmPNulfQ1v8TkddL+UYHvrP4Y/rNj+UpBINz3YFTjyJEl2F5wt1c/fn61QGAt64DI9BLl/uM9ncd/6yvmoWGP0qienXjjLtc24VzBVF/hdHTIPPj2fCMnlyzVmdh0br5vvOZw7lZIAvl13zvbBtHCpynOP8ubonfCzYh9tEc85wQb6EoLAOC7l+sH5J9M5RsrTn0qMfAu2gfdInQQZp2IMDbyopv63kzzsYS/QvVBtqinF4+ArZu5rhxlf+1Iskp69+1YsZN314jRcY8eOTF1JQFtaaQ/3k2dSO47MyVB/OffwgjSy0D9iY4xT5o01fLZsPCOO9+yqFqpdSoP9orZFb8/rQ1ISDY9WW9qBa0RmaL5ODhL14wpCy3Oi/jkrdeF/pl/muVzojiqUDIe8OR2S5xGQRLa8c9x6fuqSJBVhmWYZVKUMAxkrD/eOH19mLWtB5YVB0HLBJnPmjj7P9+KaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 9:31=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Apr 10, 2026, Nikita Kalyazin wrote:
> > From: Patrick Roy <patrick.roy@linux.dev>
> >
> > Add GUEST_MEMFD_FLAG_NO_DIRECT_MAP flag for KVM_CREATE_GUEST_MEMFD()
> > ioctl. When set, guest_memfd folios will be removed from the direct map
> > after preparation, with direct map entries only restored when the folio=
s
> > are freed.
> >
> > To ensure these folios do not end up in places where the kernel cannot
> > deal with them, set AS_NO_DIRECT_MAP on the guest_memfd's struct
> > address_space if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is requested.
> >
> > Note that this flag causes removal of direct map entries for all
> > guest_memfd folios independent of whether they are "shared" or "private=
"
> > (although current guest_memfd only supports either all folios in the
> > "shared" state, or all folios in the "private" state if
> > GUEST_MEMFD_FLAG_MMAP is not set). The usecase for removing direct map
> > entries of also the shared parts of guest_memfd are a special type of
> > non-CoCo VM where, host userspace is trusted to have access to all of
> > guest memory, but where Spectre-style transient execution attacks
> > through the host kernel's direct map should still be mitigated.  In thi=
s
> > setup, KVM retains access to guest memory via userspace mappings of
> > guest_memfd, which are reflected back into KVM's memslots via
> > userspace_addr. This is needed for things like MMIO emulation on x86_64
> > to work.
> >
> > Direct map entries are zapped right before guest or userspace mappings
> > of gmem folios are set up, e.g. in kvm_gmem_fault_user_mapping() or
> > kvm_gmem_get_pfn() [called from the KVM MMU code].
>
> ...
>
> > +#define KVM_GMEM_FOLIO_NO_DIRECT_MAP BIT(0)
> > +
> > +static bool kvm_gmem_folio_no_direct_map(struct folio *folio)
> > +{
> > +     return ((u64)folio->private) & KVM_GMEM_FOLIO_NO_DIRECT_MAP;
> > +}
> > +
> > +static int kvm_gmem_folio_zap_direct_map(struct folio *folio)
> > +{
> > +     int r =3D 0;
> > +
> > +     VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> > +
> > +     if (WARN_ON_ONCE(!(GMEM_I(folio_inode(folio))->flags & GUEST_MEMF=
D_FLAG_NO_DIRECT_MAP)))
> > +             return -EINVAL;
> > +
> > +     if (kvm_gmem_folio_no_direct_map(folio))
> > +             goto out;
> > +
> > +     r =3D folio_zap_direct_map(folio);
> > +     if (!r)
> > +             folio->private =3D (void *)((u64)folio->private | KVM_GME=
M_FOLIO_NO_DIRECT_MAP);
> > +
> > +out:
> > +     return r;
> > +}
> > +
> > +static void kvm_gmem_folio_restore_direct_map(struct folio *folio)
> > +{
> > +     folio_restore_direct_map(folio);
> > +     folio->private =3D (void *)((u64)folio->private & ~KVM_GMEM_FOLIO=
_NO_DIRECT_MAP);
> > +}
>
> Making guest_memfd responsible for zapping and restoring the direct map o=
n a per-
> folio basis feels wrong given the addition of AS_NO_DIRECT_MAP.  I especi=
ally don't
> like that the "rules" for when an AS_NO_DIRECT_MAP folio has a direct map=
 will vary
> based on the owner, and even within an owner (e.g. guest_memfd) will be a=
d hoc.
>
> E.g. as per the series to add guest_memfd write() support[*]:
>
>   When direct map removal is implemented [2]
>    - write() will not be allowed to access pages that have already
>      been removed from direct map
>    - on completion, write() will remove the populated pages from
>      direct map
>
> That's pretty gross ABI, because with KVM_GMEM_FOLIO_NO_DIRECT_MAP, users=
pace can
> write() exactly once.  To re-write memory, I assume userspace would need =
to do a
> PUNCH_HOLE or truncate.
>
> What's preventing us from handling this automagically in e.g. filemap_add=
_folio()
> and filemap_remove_folio()?  Then the usage rules are pretty straightforw=
ard: the
> kernel must *always* assume the direct map is invalid for folios from
> AS_NO_DIRECT_MAP mappings.
>
> Then if KVM needs to utilize a kernel mapping, e.g. in kvm_gmem_populate(=
), KVM
> could use dedicated variants of kmap_local_xxx() to deal with a local map=
ping for
> a folio/page without a direct map.  Or, KVM could simply disallow the spe=
cific
> sequence that would require KVM to do the memcpy (I'm pretty sure we can =
do that
> with in-place shared=3D>private conversion support).
>
> I realize that could throw a big wrench into write() performance, but IMO=
, before
> merging either series, we need a complete story for exactly how this will=
 all fit
> together, in a maintainable fashion and with sane ABI.
>
> [*] https://lore.kernel.org/all/20251114151828.98165-1-kalyazin@amazon.co=
m
>

I agree with this - this approach would also allow for memory that was
never in the direct map to begin with, or has been taken out already
(for which I happen to have a use case :-)). guest_memfd and other
code can then assume that AS_NO_DIRECT_MAP means they have to take
explicit action to map it if needed. It's a clean, simple ABI.

With the current set of patches, it seems like this couldn't be done
in a clean manner.

- Frank

