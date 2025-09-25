Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C80ECAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 15:06:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC36C8E0005; Thu, 25 Sep 2025 11:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74278E0003; Thu, 25 Sep 2025 11:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62EE8E0005; Thu, 25 Sep 2025 11:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A41B68E0003
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:06:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3EB44139D7D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:06:50 +0000 (UTC)
X-FDA: 83928099780.18.66626C8
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9356312001A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:06:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NfHcyDH0;
	spf=pass (imf29.hostedemail.com: domain of 3hlrVaAYKCN0RD9MIBFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3hlrVaAYKCN0RD9MIBFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758812808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jh5MSqTLsjrp4fvoa9f2K3rue2zEjmwO4t9rR+bj9fI=;
	b=ghCokYQ4kEcbw820BpcDjtdi9ldBirYT4rU6S/GZ/QqqZkWt3tculumzBGDMS3V6up6aRL
	vXAQNgWByOTAYScRFCJaUxqys+PwM4T/s+jI7viIh7z65al7C5NKeLmI4wiTcwYpe+Fr27
	XVKBPhdtvHxpVSrXimzJs8B/nWd1ux4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NfHcyDH0;
	spf=pass (imf29.hostedemail.com: domain of 3hlrVaAYKCN0RD9MIBFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3hlrVaAYKCN0RD9MIBFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758812808; a=rsa-sha256;
	cv=none;
	b=bqVfGbnLKRQ6U0cCQCyiEOfRS3EfFCY2y37ZUOWK8jbTtY//N7eBUHBiffLEq2t0draimO
	OwUlBDQzCpOKwn5TNiMjRae7+HK1Acrm+fmV42i9hRDKyMtYeaoXrVvmx8TW1kZqjIjLq8
	fCg7jMmwq5DtAsO/d238VLFPnWmkpAE=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b55118e2d01so796209a12.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758812807; x=1759417607; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jh5MSqTLsjrp4fvoa9f2K3rue2zEjmwO4t9rR+bj9fI=;
        b=NfHcyDH0qmYl/KU82H5c26j6jAfWLhjQ9CyeE9JrWjs9O4CSc1Kq/755RAdRCk7y6d
         uuw0ZB1gseFjBf62Se5OyjEjkkBzKmMTQmboKuWuTkTNBkHSqiRjp8/6Zn42G967rqTw
         qexfRBFrv6g06T1jhRKsUmllIIDW6yM1TmY5sdf6aQ8R57T8PB3CTQZs7xi9J5HJAW7/
         xIvLhIRDuV7R9P7ajBoysS/Ybh1MQ+q/G0hHq+KznJGUPYUpeHHJQUAkrwWINaFhWMCG
         hVhXvtmth8EDdVZFr0XCigXp38HeImKBYuvGZfrTncliAT/KzX1LipWruIOQT7vjs7n5
         cJoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758812807; x=1759417607;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jh5MSqTLsjrp4fvoa9f2K3rue2zEjmwO4t9rR+bj9fI=;
        b=OzxTFjiu1xMwtHhzmU3MMG1uIz76ZWlLaHbQE0b9haWx0nHgupfd+ZAFjObUgh0Sft
         XV78L/Brtw3nL1GgH/KijGMqVu2UJtJwFRqeYrrXdvjF45E0fuPyIGYcPws+q8EGYC3X
         g5E60hgjzS6XPN0loXwcBUjQ+nyaZOwsioFUFHHQ+aQJg01ttQ2c9rLsOR62Ohk5ATYm
         6Y/HQytl+2CI12YjvptKRur6+AFHV60qjW/YdlX3N7WQ9ooqN2JvYG2sahEiCRJ1L/N8
         oBtPSSbCCrLYZ9ZciyvMpAjybhoB+tx/nOmqix1tyguItTz/8MJB8tZpWv8B0EDvo17k
         NUCw==
X-Forwarded-Encrypted: i=1; AJvYcCUaqBhPhSQHAaa6cv0N9NbTumbdejc/IG4bqiUnUxjul6FVGIdXDJG0I8GZHkqxgILQMwzwYitrSw==@kvack.org
X-Gm-Message-State: AOJu0Yxcxc4a1+PATbChnXfokvI8hsHRJxdThKDXuMcHSUR8Z1U0ls4C
	7CUcrenfKPnzAL9Ds0bI2ccs2V325n1IKGU4vt+WEY/kIw4snhlDGZcqf1UNGwaz+rOtEH+esqT
	MG46fFw==
X-Google-Smtp-Source: AGHT+IEVcWsyGM1w0GH1nNrshkk20Pnc8ghwxFB8MAUOFgcR14npidYwrEDITe3+YHWa4Mb/5XspEYhl1Ac=
X-Received: from pga11.prod.google.com ([2002:a05:6a02:4f8b:b0:b4c:213a:e7aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3282:b0:262:1611:6528
 with SMTP id adf61e73a8af0-2e7cdda0840mr4939471637.29.1758812806367; Thu, 25
 Sep 2025 08:06:46 -0700 (PDT)
Date: Thu, 25 Sep 2025 08:06:44 -0700
In-Reply-To: <3a82a197-495f-40c3-ae1b-500453e3d1ec@redhat.com>
Mime-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com> <20250827175247.83322-7-shivankg@amd.com>
 <diqztt1sbd2v.fsf@google.com> <aNSt9QT8dmpDK1eE@google.com>
 <dc6eb85f-87b6-43a1-b1f7-4727c0b834cc@amd.com> <b67dd7cd-2c1c-4566-badf-32082d8cd952@redhat.com>
 <aNVFrZDAkHmgNNci@google.com> <3a82a197-495f-40c3-ae1b-500453e3d1ec@redhat.com>
Message-ID: <aNVahJkpJVVTVEkK@google.com>
Subject: Re: [PATCH kvm-next V11 4/7] KVM: guest_memfd: Use guest mem inodes
 instead of anonymous inodes
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Shivank Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>, willy@infradead.org, 
	akpm@linux-foundation.org, pbonzini@redhat.com, shuah@kernel.org, 
	vbabka@suse.cz, brauner@kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com, 
	xiang@kernel.org, chao@kernel.org, jaegeuk@kernel.org, clm@fb.com, 
	josef@toxicpanda.com, kent.overstreet@linux.dev, zbestahu@gmail.com, 
	jefflexu@linux.alibaba.com, dhavale@google.com, lihongbo22@huawei.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	tabba@google.com, paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, 
	pvorel@suse.cz, bfoster@redhat.com, vannapurve@google.com, chao.gao@intel.com, 
	bharata@amd.com, nikunj@amd.com, michael.day@amd.com, shdhiman@amd.com, 
	yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, 
	michael.roth@amd.com, aik@amd.com, jgg@nvidia.com, kalyazin@amazon.com, 
	peterx@redhat.com, jack@suse.cz, hch@infradead.org, cgzones@googlemail.com, 
	ira.weiny@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	chao.p.peng@intel.com, amit@infradead.org, ddutile@redhat.com, 
	dan.j.williams@intel.com, ashish.kalra@amd.com, gshan@redhat.com, 
	jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com, 
	suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9356312001A
X-Stat-Signature: skbyinisz1iic96fs8ee7ngukuf1grr1
X-HE-Tag: 1758812808-488927
X-HE-Meta: U2FsdGVkX19WX7DU3IgVTx1XCxT6GfAhEd8PkjyE9MtzJFfeGm1NH/oviRtzceRqQKX9Ba8KJ6DpjThoEJ67Uq2+UvsvJzAkuDPq+I1Aj9Y5nFOIIV+eh1Nj5eBmXpNcUYeIoST6Fmy3Pkm11MAqG0SAQsM5EQnsDKrXRfoYkuuO+deFB+qnI+EqumlQAIWSNE5ZWLwVDjuAnSVJz1Ao1AnAZcg6Wo62sqoJC0hjNZ41k4HhsJf71jQf+B2MKJ7BTwzLGPTTugoITzOrbDtHmqNRCZ0qRQA84UhwAA0vmMi4gyxBdpC5MY1Zke14xB7i5PRtyuNoDAOv4LhLm2zHbo/C6Kpm9pfg4E1X9nyigaIXWSl/CJNO+x2cqOALuRu2kC5rJ88hPLutUK1JbWBdHn188HMCwLPIaoILhINmcP3juhm8UTvTFc7saG/Em7LPlRG1WfHcjSy6YoqDsVn01rlSxmeU6K75FVCMxMqcnH0o3VCx5mqQvR40UGrnjaH9LUnmkJcBjdTqu4yR+1Mnfu6wbMPuNw2k+T/edzvNSD6zrspUui/uuk141EF4rkQB4A602PGbK3LOKMgzyOnBbyWfFsuayCk+F2J4A/lwuJTCx0A/WiGr5snisNVlX38Ar2EWyHpUQ/0TSPTfh7pzrkLxCm0bpTRVf8xKCQasnXT2z9dVTaC9N0OKyhst0jMmpkxjyMWUlzgfg//ESPj6x1b1rTBOMoWPIOSD9iItv75EuHjHwxw4yeRR/rsJq7yCyuyKQ6xtiJaTyl21jCAcQk9imc9g0FAIksszmOH3o7aLK1HU7qeVIueMDahZiTBtTSSO/C0sAm+TM+9UZZq9WZlUMKTexl79e3cCk0FZvspf7mKEcsi/Y+5uuk0v/AzS3eBlgvNEdN/SELl8NRsehg4UTt5tsbHXNNYZ7lKnca2JmY7BAjGciGOWutE9lNOocchKKNirdG5aCrWlJ4U
 HcNNyrLY
 BP0Ev/5AjvnuSfcO2f4NKfm1t5+5oZd+Y+0Wiu9X6zWxD6SLtc4PccTWljt3/X2Kmb0T47cginsF4oxBbKGGiwNJ2OB+7C5TDb+SxpFPXVr+tymfBbFoTcpc6d/M95dTeOHxP8kT7Ge1NiJX3c1fZ+YM0195CqsUEL2FlUMWRjc8jfS2UI1Z+6HStk3Vpb2wmJONHxpL/YIreOeN3rhO2Ur9Ok7AbREfFa4+AZMpvuxF82J+BBCQK4Jss1f2zA2DMBMWv1ZSVJH3siviC8UL6BFWL3AclajLz/XTvhYCB78dDA+jJHhVwn+z1mx96HBSGc6vBSZmfaKNZSfRw6aR4UykBQ05KfZwYiB19HZeGRgpngUF4t8Tta+giCGWqU5v1s1nQhq+ufSRLMkIuSTJMAieHNwmaXhHQ9XYYI2KOi1rQCjsH1y8Myjtruj83s98TCHbpEHZLsOBTOWm6VgQNGpRJLXIGeVnxnHeI1weWfHOIJBGKQLOHCLlNXaUxsq26Ub0JErmlIvYbhuXDg9YFMxsLhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025, David Hildenbrand wrote:
> On 25.09.25 15:41, Sean Christopherson wrote:
> > Regarding timing, how much do people care about getting this into 6.18 in
> > particular?
> 
> I think it will be beneficial if we start getting stuff upstream. But
> waiting a bit longer probably doesn't hurt.
> 
> > AFAICT, this hasn't gotten any coverage in -next, which makes me a
> > little nervous.
> 
> Right.
> 
> If we agree, then Shivank can just respin a new version after the merge
> window.

Actually, if Shivank is ok with it, I'd be happy to post the next version(s).
I'll be focusing on the in-place conversion support for the next 1-2 weeks, and
have some (half-baked) refactoring changes to better leverage the inode support
from this series.

I can also plop the first three patches (the non-KVM changes) in a topic branch
straightaway, but not feed it into -next until the merge window closes.  The 0-day
bots scrapes kvm-x86, so that'd get us some early build-bot exposure, and we can
stop bugging the non-KVM folks.  Then when the dust settles on the KVM changes,
I can throw them into the same topic branch.

