Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97810C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B10EB6B009E; Tue, 11 Aug 2026 09:26:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8A36B009F; Tue, 11 Aug 2026 09:26:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26266B00A0; Tue, 11 Aug 2026 09:26:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B81A6B009E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:26:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0A9D94037B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:26:09 +0000 (UTC)
X-FDA: 85089062058.05.DD1770D
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf29.hostedemail.com (Postfix) with ESMTP id 556C8120014
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:26:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Vy/a3r5Q";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 37SJ7agkKCHorYpslqYfsemmejc.amkjglsv-kkitYai.mpe@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=37SJ7agkKCHorYpslqYfsemmejc.amkjglsv-kkitYai.mpe@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786454767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W70NQ8qweOhk0vfOOOPEvDwhbPTM+yme1ctvOdIAjTY=;
	b=LzyCalBgZLtyJzvgf34P9XOfHHb9aGOzf3EPpVOP8bppZ571S1OArrjSMacXEvKzYF57Jp
	g2HrdMXbvyZk3nibZt1sNFzDxm+6EImSP0l3zPLqGrPckXUgWgw3aNHneI1/S82l0yD+YT
	ZN9nC/YOjhhjsH0hVtm9tnKV5SeMEZw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Vy/a3r5Q";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 37SJ7agkKCHorYpslqYfsemmejc.amkjglsv-kkitYai.mpe@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=37SJ7agkKCHorYpslqYfsemmejc.amkjglsv-kkitYai.mpe@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786454767;
	b=1CVxy4Po9u4ubLWr9oQPmC1BK6jy+WYmXfp6u/N6CYOa4JQMdEiA4OVJWbVZlxNitNdO8I
	E0B21LwG0wzx+x2lzbPVAvV5NngH5cAnsTw/puuK8SJke2ZNbw+kakw9/AddEkzvc577Jh
	3d8ZpvBEBQ98mKlc7hWO3ybfQkLI0JA=
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6983e384c66so2291882a12.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786454766; x=1787059566; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W70NQ8qweOhk0vfOOOPEvDwhbPTM+yme1ctvOdIAjTY=;
        b=Vy/a3r5QCB2i5MnwOeY4KDRcOYVMqIoQebLL8cdR0Uqx5sevOOfYJEbT6mKTok/1el
         bEQtIpwQlOQti84BeRCJW63DobrizrHA+hbNF8y8wK1kJr3KxgiS0jjJNMufBTSlUCVr
         osDHc4Oj2Xg82pe8wIo7Ga6cZfFR4nCXAPzXhnT5i6huVuAbFiPSuVdxkXUOkHo20sWz
         DFNJ3nc5yILvXtgCaCyfSck4pDIhnxC2qSOmHboRRw9lDV+a5DsB8rDvQOFCusaHoea5
         y42VuhesqEuqdq0nZXZTOeVyaMGKI/nxowkojJ6WFb+S1DJ3tZW4LEXIBAOJHrDzxprt
         m+xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786454766; x=1787059566;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W70NQ8qweOhk0vfOOOPEvDwhbPTM+yme1ctvOdIAjTY=;
        b=stYg6ZXyVoQuy3waHcTHZlorQ4VFby6SjMapOii/e+GemiJpPI/O1AsVd9xn3AYQdT
         tKS8ONbaGRdZbc1QmS91H4cXWJixioSoCFH9AVZSa+KnwF+tmigqNd5dznm7Y3ehxirE
         HPNVaZysLdcVdYSHh1O3MXhSq76aMbfeKGpq5PxgVtGRC1JdsfoYjFfRg2SBX89D7YLr
         +A4Zmqq76kyat8DBaIggmaKQ9Bh88iCIZI/JJVnm+irTF72fyt8GJJ/JNdez3XUFnJHA
         SufrmoDU0ZjrZ1VOCY8DNKRwlspGjRHHzyRhCoxYNSaiBkhoXEFrxc14hM1VTawft9mO
         yGlQ==
X-Forwarded-Encrypted: i=1; AHgh+RpVDgiLoXaHuA9NScVQlnU+nKpC/IAM89YqCZ0h5l/s/zkG83Xlcy/3+lL+6SHZ5R7qkL27RhaO2Q==@kvack.org
X-Gm-Message-State: AOJu0YyTpLyFWF3dp62orVF5PdJ4CKkDayXNfzi9s1gAZcF30/viEx2X
	7l4oJKroqFtZARsMj14bXHPmJjNKTDRQN3qlMJqu9urt9MczWe9odvMNLotvWVw7itBC6GyTa1v
	PedPC/YqFPZnPt7Y90g==
X-Received: from edqs15.prod.google.com ([2002:aa7:d78f:0:b0:698:b78e:8827])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:158b:b0:6a1:e59c:62c6 with SMTP id 4fb4d7f45d1cf-6a364525fe5mr1952585a12.18.1786454765239;
 Tue, 11 Aug 2026 06:26:05 -0700 (PDT)
Date: Tue, 11 Aug 2026 13:26:04 +0000
In-Reply-To: <anpXjM_lg_UTpl0q@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-2-tarunsahu@google.com> <anpXjM_lg_UTpl0q@google.com>
Message-ID: <9huzqzk4zt3n.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 01/11] liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
From: tarunsahu@google.com
To: Sean Christopherson <seanjc@google.com>
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 556C8120014
X-Stat-Signature: 8pdydfariepfgb1fgaa46j6pj86qy9zt
X-Rspam-User: 
X-HE-Tag: 1786454767-850052
X-HE-Meta: U2FsdGVkX19FgpfUhIVlKnfXgRi+HuTR9i4XoseCDyyeiyncm+sg/sqyD0XVowkiXVcYsD7kUbZO27rc0I5gzzqEriQzzYEoLuWkQ5WhMkk6/HAPJbfj9PopDMuuJhd1fTClpTNdkgQd5GfneczmDMK1qJruHznu1sXBQtxol25nImOwcILpAN3juvJeMzNPfN2paudAy6ssxztr/5kTCaW/TUBgR+AdMkllzGL1TfK2ECkCMTfY6GK1jDvKnEa9cvzCjnhfc5T9/dkwKQ2vRfJ1jcOYM1cQYirKS206HEd8RFhbJkzSchfBn1+EBqX5eLVubW1cqCF2LxwkvUVll7VkCxjQ8pl9xkRsZFn8d6JnQfW5n18HbNcm4arLQo92cz+5VdDg2GZhwDo3e3JVwzf41zweYCguC37tExpGzCe+MYfRH5Me+iBFaACU4PNaGDp4uCw3VPvS4z7czeVZ5vXJRapcsjuK3pQRG/UldBXez9+QdlW0Th8tQFHiNIURU4hNRChErltP7Q9qa9ut3D8+SEB9CJazDhosyPDziskiHqp1LpoKwlITU4QF4clNCASvyvrP9UUpnJOHtfaWfxOyB6PRSS0XiYEYQ6I0R4cvvcfgChrdxb7Q8CzY/LOJzLCE0wVPjCQkOJXTCVGo1WcY7oXZKx+K+hRdkfwViNxsLyvnhBC1dtLRgXRUddCjArFkHQBtOatxiQfFnmahdAaixO/EgIHdALZyzGshkDV6aDEURMxWLlZ6Y9LZah1wKUGsdNhok9woF0hzR+ZckSVP8hi78rmJLbBY08M7n/liPGA5z/rStGCOzYRyAITo9psSuVVR8uu+nAK+LmNhpg940HMNgLL/PGsRdkKJ5DtUDhb+Fbc3yp/SCSPciAYSw39CiR+oZW3RkdsNdpYHTzAB3wEQj4zjvAp092dZPMSuoxXXg0VuWsTXSDoCm8zfjHJBM4uMhzgk/klRu2w
 pejCwVNE
 OguOA1uBtbmHOOftiet87QXfu9ppAux6AE/i8H5mEcUz37JJWwOTYRMhuCw8yFikxFqkibIS5VvhsQq99Pjr3DXP2+FFfSZgV4TrFDqkLa8wzNMZ2HECf5aSSxwnnacDMniL5g0L/WBOwTmBIKS4xF5HiWvUKlWW/d/dy7DInmhJavva9aGnAo8ahOtNz93tfpof5XLTesnhgrSg+AixjG3LTSkJImUiTOB1Iu7V/U5ZxiMU4Tq6Gbj13TS+Vk8+yIDGDpQg7OUU0q+qVQJIwnw/42L5A8SiEQbIxGFhlg5eJZLXXL+XuPXwls/0JSBSYKAF4InjJFaJbFhWvgv1kShT8wzvK46mDJE+Fim02W67D3i49SXngiqU30Bd+pZTuNf4iAcbAl6ez+cUZPO2LsJm7UPsPR+lrWdIC3DQR19MlgcF8WUrAXgTPJMPKvy9gRImWp/LK/o7eGE7RoXV7OTYUbHsNAI2PSWJ2XRmjb97Fy/rONac56f6DtOOBfMqVr0nMG1u2TMd2dNmO2AQpoLYHsJrCpJ6xugtUEhiMu6ENJDoDQrPX534twnOhe5ZazempkYgWhdOrWN1JYJTv5zDEsnbMuAMOpNSo+DKD2QmKP5M9qcnyKI4f/2mrZKl5fgx4oy+WbGofC8eu8qxZtnDuBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Jul 28, 2026, Tarun Sahu wrote:
>> Introduce the LIVEUPDATE_GUEST_MEMFD Kconfig option. This option
>> enables live update support for KVM guest_memfd files, enabling
>> guest_memfd-backed memory preservation across kernel upgrades.
>> 
>> Currently this support only guest_memfd files that are full-shared
>> (INIT_SHARED and no support for private_mem).
>
> Why?  Specifically, why do we need/want a separate Kconfig for guest_memfd
> liveupdate versus KVM liveupdate?  I can _maybe_ see a KVM-wide Kconfig, but
> even that seems like a stretch given that (AFAIK) hypervisors are the one and
> only use-case for liveupdate.

LIVEUPDATE is used in many subsystem. It is possible to enable
liveupdate and kvm without enabling KVM_GUEST_MEMFD. So GUEST_MEMFD
preservation must depend on CONFIG_LIVEUPDATE and KVM_GUEST_MEMFD both.
LIVEUPDATE_GUEST_MEMFD Kconfig is wrapper on both of them. It need not
to be visible in menu, So I can make it hidden. WDYT?

Also, KVM VM_FILE preservation and GUEST_MEMFD preservation both depends
on LIVEUPDATE_GUEST_MEMFD in this patch series. [PATCH 05/11]*
Which is wrong. So I will update KVM VM_FILE preservation to depend only
on CONFIG_LIVEUPDATE.

*https://lore.kernel.org/all/20260728121138.1103610-6-tarunsahu@google.com/#Z31virt:kvm:Makefile.kvm

~Tarun

