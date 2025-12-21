Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2554AE66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 12:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8335A6B00DC; Sun, 21 Dec 2025 07:34:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80A576B00DD; Sun, 21 Dec 2025 07:34:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736BF6B00DE; Sun, 21 Dec 2025 07:34:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 613036B00DC
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 07:34:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A613602F5
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:34:37 +0000 (UTC)
X-FDA: 84243421794.11.9202970
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2BB46180003
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:34:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="mzZaLS/C";
	spf=pass (imf24.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766320474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/zDNPMvmJjRrV4GhC7uV9fp37vI0wy5aPj4K2cg4ANI=;
	b=MEKIYZ9JcgKnOKYe/IxGc0A9a4hVFEr/Ma5OBqcThK+uzBNjHZBXAsy7B678V8/0S2aMSe
	YEwq73oYkgkQhpiEi6mn8YOGq1bOFci4NVeUeRS+86fJ/q0EC3T0uoQauH2osyBwry6TZT
	JrLuA57QzvDJjPvX5UrAV4wYKZUCIiQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="mzZaLS/C";
	spf=pass (imf24.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766320474; a=rsa-sha256;
	cv=none;
	b=h+vcXW7kutK9vfdwKWEVkEaGx9pErR0vrbu1ny57eAEunPPRsLbGircAEfpr4trTT9g5AR
	Cx2fXLTnz3xVUszScq+xFUwxuq6V/u+tgchJJop0xTCnP3SUCnGDqkvuAA+AJfffrtL8EA
	AOjdvO/qc7zMGCQzFPPY6lbCgH/62eA=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7aab7623f42so3770463b3a.2
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766320473; x=1766925273; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/zDNPMvmJjRrV4GhC7uV9fp37vI0wy5aPj4K2cg4ANI=;
        b=mzZaLS/CjSdtyHqeAVevAOiAToZY4Uxz0tOb6Wafl4kJ6iII26Ask7BrGxxadTXlrp
         s32NYNvM0z+GbGHhCegYh1oCKuQmclB0NWFip6OZ0DE9Mfs5olp/vLdJum1TG+8hC8z7
         1yTceyqP5qVxZraq/0QeSXFIkRoZjV4xZ6c4FCqEkBl/cMrPz7q3tSogM5W+pSjC4WDb
         raWh0OaoMsXU8BO1xD9gP1x77C3eLomVIhwZZLlGkDNKhoQ85yKKSYL4JTqAcV9KsQTf
         GRW9RZN8bKV6axiU9hVJDHbyDUpy/PNR+sljUoHIQK92G7WddBHTmFc9dkl1soE3yfSA
         RwoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766320473; x=1766925273;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/zDNPMvmJjRrV4GhC7uV9fp37vI0wy5aPj4K2cg4ANI=;
        b=qgwkXlLy2B7DcatEDRQhM57PcESbNNTYKyRJMIZ3qspJNyD44kXvEKenFwLDgPnrBH
         UzHcTJ6T54nIEToCzg9gbXOOsgpgLS0E+BnXT7q/9RrzePUye9cLYcPu7LgcE+Ux1fU1
         WFQe46yHNLoOejMTzRM9qzhrp3R0n0Eh4mSZ2OdonveZyF4KXZVES2cWncfsDXpdFQCP
         EasFfLC/ApdA1Z0oKS/fFLHYmcFLb8YZNbjZztKGVhyG1LK/CjGAauugOZhXR3XGvZTn
         ZMMwig5QJM8Z4vsn2a6/0WLnyN94isrzA4FDQlLzMzqvBtHETEwKGuTRDJwIzZVYNjjo
         kRFA==
X-Forwarded-Encrypted: i=1; AJvYcCXXZo0n/arJWZckwNpJm3Oaj5fLep0ogFF1DO7jHReSobg4RmgykjqirOWxKSsIgIi2qCgdkQcAsw==@kvack.org
X-Gm-Message-State: AOJu0Yzp8sJbMvgEYzvqTfeX/SawP5pd6kdKApRWvfnoQl9nhP8i/gfo
	elUVJZI9QkZN5/Y/GCxhq2SiVsgL2BCitZpNS4S+tgM2y7xhMe1ubiM3
X-Gm-Gg: AY/fxX4gkNdpMNgBuo3DTx02rcuVUyqZbx3VghTeSzf6+YfSHSKYtNmHuTi+TIKZt0o
	6Ti2a3aa2U9bDWBH4DS3b+kn0UCYkhqBNWAjhaKGNGYq8vNwpwUR92hnJ4WVAvjZ8ace4VQ8XQs
	8UFouoQ7ectynRA0hAbGdZLwhMg7p1W4JlW8noe4Ew5N3xXdOshO/MKHGsM0rpeAh8zAp/j7oZr
	+0Ubaltj45rIR4kvQNDFr/arsBI+yDVaQZwi6Pi81LBdOO6TfV/wEK87VSwXE7XXdu2otYuRU0x
	9ChKIZyWBm2oNUG8LE3j5tRo4uE1iIKtO+PnMqRq8dm2xJ1DnSmKxMfa179VwcAEzqY+ffGE3oQ
	mljkL3NwApr/L4kgw1wZcnN1mSVLLa1KHn1F8YEMaU4Eve1nkSbnQTrP6QweqixcNUBGrGwX9RJ
	7G9kqOh9s37rM7GA8qamVYgK1FMQ==
X-Google-Smtp-Source: AGHT+IHcWTP8wlPrHfGP9TZsfQkT0EOfc7VgchyI0NW2fLjn5Cc4vw2fNSZJ0J9MOz3ixkKzpRgmUw==
X-Received: by 2002:a05:6a00:4ac4:b0:7e8:4433:8fb1 with SMTP id d2e1a72fcca58-7ff6667c7b0mr6662442b3a.57.1766320472867;
        Sun, 21 Dec 2025 04:34:32 -0800 (PST)
Received: from localhost.localdomain ([114.231.217.195])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7a844d5asm7508581b3a.3.2025.12.21.04.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 04:34:32 -0800 (PST)
Date: Sun, 21 Dec 2025 20:34:25 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 3/4] mm: khugepaged: move mm to list tail when
 MADV_COLD/MADV_FREE
Message-ID: <ck5nkriyqdvy7ftu3xeu6cn4aj3s3cpefbga55vkzblnoywrpi@2sw5oh3saixt>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-4-yanglincheng@kylinos.cn>
 <3c75d915-5d7f-4e80-975f-4479393e7139@kernel.org>
 <tnvhnikpfxyjassrdsnqmpxlem3hnoepwxmp4hysfzqzl3wltw@7utx5hxc52th>
 <6e8684a5-1f71-4be6-8805-9b047a2bcb78@kernel.org>
 <20251221021044.2r5fhepiyyhvuo7h@master>
 <mcf4mydmyz6e5ioeseaawhfro2snox4hyfr2irpx4kxkagx2k7@uszrm24ulffg>
 <5af0e0ae-0472-45b8-a249-44b4e5239d33@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5af0e0ae-0472-45b8-a249-44b4e5239d33@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2BB46180003
X-Stat-Signature: r5tqabrbe7gja8k4of1caku3yftyssho
X-Rspam-User: 
X-HE-Tag: 1766320474-67594
X-HE-Meta: U2FsdGVkX198MrZI/CYtsHpTJvvZSNpY9FVM3YF7IdYEslX0cl1KV2OUG8nJvMHvfnsVJSSHCP1E1TD2G9omUh1f/3jw4FamSiDufWi+P6I8ZPkdg+a4lwxC68YmUuVYOCDoYsGLLh09mrgvf8aRWBCzLDo2PYTbnAuL0EPIj1v9AaLEmDoUH8Vf0WN3H9BQcbXzv+y3KymAtvAtT0zri/xVxdvHWQuOQS60LBRvO+FFfRJRHpT2g5fm+L0xJi899AcE4PcCCh1RSbJuO41ZRLBPXYhgsoWaYK0wpPR0gfub1ZiBuc3z6z2Fs2gJKoQr4HT/hZIznU3Rc7231Fy4lkJSeVAmwFx3YDCFwGHZIBGUsHz3cqQs6walmHdJ7K15ospATQBONjnw1FoOXRUHgRNLdjfClSV9EwHFL6wg2sFom0NIWsFwLENckeXPks86OkZBNyC2+Y7I6CO8+Y56Mifw6NuhlRGh6jDv6+VgLU4ejDzZJAfQSjpf2kXge7+Vb822CZzkFfzh8HOCEk4jIuccpwEMvW5iRa/Co+hf2NH+xcPtV0PNjYBGh65E8u5YFYnYNuroYjsDemGXrodOlPDFjgPcyD5HtLqVkwUsymh58CDOAOnWuQykVVRYpH9vgGZhRZHE2p6VKfbCz/m6etXPD/x+bYt8wpHGOCfpIfkJDuei2P+1F0PbTvQkxRoAroYDS2MfrZsm7WbYZ21qVfemgFChh6WrigIh4ENe4HCatxVrcrKjkVeMsn4rWQCGehl/p+aS3u6d9C2CiUWg0nXAp1vNeTEZl3U3dtebEHFCIicmCT6rJLv4DwoNbtQ/1QhuCzd0cYP98HnG2efecpOXaKNDWmx3A/pQGQi/Es9FJOMMBjtMc2Pzd3TnJg9TTQySy7wjsDACVDZm/HSuqpXP4qwnvBDHstqIPB7eGy5l62ddF6YfeC5pHCO0dx9sLrIQi10FDD0T+YCpVYG
 Ryc7Unpz
 KGPCjCk86C50oSbMl4WwsVRjnsXmCJmpbVeF3iTm6oQxmimRoP8yygErk/JILE2vSwGIucSe/WZpjFIJBvIvmH22fH/JYi4W86Nmb2v5rxwKW8EhwVomXb94+JkYV9ZORokyWhj6FQP5VNNvCJTjY4GVqFIRpNSJBTSv8KddOEGcty2w7b2O88qgJvmPwCIyKnJ7PZYQ28h5gOZgzHQXfZDnRUhoeVDEGJrIMYazgNEmh4NtEXnM5qiPV8f7VqQB6aj4gFZ/VHPOFOO11l+aL0hkLql79Z0yfNZkLsJIcDTeR/L2LOMjWw+zmZ/mFbrenalG18FEJjUIQbKU3Ab0pMn3rQqHrEFpcR4stgaYz//YHRA6rD63Ovosp3r+ZktcDJJLw7oasQQbhsWvOcv2yFwusicFm+GVQ4zx5rKBlxGmw63UElSezkUkDd/2jrzumBricTptVE4inyxPH13Uc5pmfNkl6tLtmUInne75zkovhXDDfRmeDc7sAFtxaNib41EQvxfteubaa7S8koNfwTnsbnlS8sM8V7h8FRsNO34/sWaVcyAjN1NZiyTmzdFwRWJRToxspaKCZnEiuoVjGGjyzUj1LAFGyJzNrJst1YRoc+q7oHbDrpd0B9KikYuYy76w95fOjASHOInQ/NetAZDvnERiIpxiEGf3n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 21, 2025 at 10:24:11AM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/21/25 05:25, Vernon Yang wrote:
> > On Sun, Dec 21, 2025 at 02:10:44AM +0000, Wei Yang wrote:
> > > On Fri, Dec 19, 2025 at 09:58:17AM +0100, David Hildenbrand (Red Hat) wrote:
> > > > On 12/19/25 06:29, Vernon Yang wrote:
> > > > > On Thu, Dec 18, 2025 at 10:31:58AM +0100, David Hildenbrand (Red Hat) wrote:
> > > > > > On 12/15/25 10:04, Vernon Yang wrote:
> > > > > > > For example, create three task: hot1 -> cold -> hot2. After all three
> > > > > > > task are created, each allocate memory 128MB. the hot1/hot2 task
> > > > > > > continuously access 128 MB memory, while the cold task only accesses
> > > > > > > its memory briefly andthen call madvise(MADV_COLD). However, khugepaged
> > > > > > > still prioritizes scanning the cold task and only scans the hot2 task
> > > > > > > after completing the scan of the cold task.
> > > > > > >
> > > > > > > So if the user has explicitly informed us via MADV_COLD/FREE that this
> > > > > > > memory is cold or will be freed, it is appropriate for khugepaged to
> > > > > > > scan it only at the latest possible moment, thereby avoiding unnecessary
> > > > > > > scan and collapse operations to reducing CPU wastage.
> > > > > > >
> > > > > > > Here are the performance test results:
> > > > > > > (Throughput bigger is better, other smaller is better)
> > > > > > >
> > > > > > > Testing on x86_64 machine:
> > > > > > >
> > > > > > > | task hot2           | without patch | with patch    |  delta  |
> > > > > > > |---------------------|---------------|---------------|---------|
> > > > > > > | total accesses time |  3.14 sec     |  2.92 sec     | -7.01%  |
> > > > > > > | cycles per access   |  4.91         |  2.07         | -57.84% |
> > > > > > > | Throughput          |  104.38 M/sec |  112.12 M/sec | +7.42%  |
> > > > > > > | dTLB-load-misses    |  288966432    |  1292908      | -99.55% |
> > > > > > >
> > > > > > > Testing on qemu-system-x86_64 -enable-kvm:
> > > > > > >
> > > > > > > | task hot2           | without patch | with patch    |  delta  |
> > > > > > > |---------------------|---------------|---------------|---------|
> > > > > > > | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> > > > > > > | cycles per access   |  7.23         |  2.12         | -70.68% |
> > > > > > > | Throughput          |  97.88 M/sec  |  110.76 M/sec | +13.16% |
> > > > > > > | dTLB-load-misses    |  237406497    |  3189194      | -98.66% |
> > > > > >
> > > > > > Again, I also don't like that because you make assumptions on a full process
> > > > > > based on some part of it's address space.
> > > > > >
> > > > > > E.g., if a library issues a MADV_COLD on some part of the memory the library
> > > > > > manages, why should the remaining part of the process suffer as well?
> > > > >
> > > > > Yes, you make a good point, thanks!
> > > > >
> > > > > > This seems to be an heuristic focused on some specific workloads, no?
> > > > >
> > > > > Right.
> > > > >
> > > > > Could we use the VM_NOHUGEPAGE flag to indicate that this region should
> > > > > not be collapsed, so that khugepaged can simply skip this VMA during
> > > > > scanning? This way, it won't affect the remaining part of the task's
> > > > > memory regions.
> > > >
> > > > I thought we would skip these regions already properly in khugeapged, or
> > > > maybe I misunderstood your question.
> > > >
> > >
> > > I think we should, but seems we didn't do this for anonymous memory during
> > > khugepaged.
> > >
> > > We check the vma with thp_vma_allowable_order() during scan.
> > >
> > >    * For anonymous memory during khugepaged, if we always enable 2M collapse,
> > >      we will scan this vma. Even VM_NOHUGEPAGE is set.
> > >
> > >    * For other cases, it looks good since __thp_vma_allowable_order() will skip
> > >      this vma with vma_thp_disabled().
> >
> > Hi David, Wei,
> >
> > The khugepaged has already checked the VM_NOHUGEPAGE flag for anonymous
> > memory during scan, as below:
> >
> > khugepaged_scan_mm_slot()
> >      thp_vma_allowable_order()
> >          thp_vma_allowable_orders()
> >              __thp_vma_allowable_orders()
> >                  vma_thp_disabled() {
> >                       if (vm_flags & VM_NOHUGEPAGE)
> >                           return true;
> >                  }
> >
> > REAL ISSUE: when madvise(MADV_COLD)，not set VM_NOHUGEPAGE flag to vma,
> > so the khugepaged will continue scan this vma.
> >
> > I set VM_NOHUGEPAGE flag to vma when madvise(MADV_COLD), the test has
> > been successful. I will send it in the next version.
>
> No we must not do that. That's a user-space visible change. :/

David, what good ideas do you have to achieve this goal? let me know
please, thank!

--
Thanks,
Vernon

