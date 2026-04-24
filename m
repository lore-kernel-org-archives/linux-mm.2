Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E929FED3EF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 17:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953DD6B008A; Fri, 24 Apr 2026 13:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 905AB6B008C; Fri, 24 Apr 2026 13:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3A06B0092; Fri, 24 Apr 2026 13:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BF776B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:22:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0CC118A928
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:22:20 +0000 (UTC)
X-FDA: 84694118040.24.1394A9B
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id 26CD140007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:22:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BPdLHh+z;
	spf=pass (imf12.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777051338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJpfQLhYCMBQwdjJS8K/XCMHtvPcHGNh9u8Wq145pxg=;
	b=Jl2upPJEVJTRBjmM3eStSJx3lgAImk4gqs7ifTzSDVmdeiI5uMFp6uOUptuytrjeJcgIcY
	ZXucNFUs1N7kH+StoA/yNnb/FCqYEVKiRnDsJRVsaQu+b/rxlCLCS+U2K5Bx9u2rLIWqs1
	XcbqJ8rKUEUa3ymJFYLHCytDQ50Vgpk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BPdLHh+z;
	spf=pass (imf12.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777051338; a=rsa-sha256;
	cv=none;
	b=GX45p8cLXvL8qOK5tcfSi8/B8fSt4IrxLGH8xBgaO3klBu20XJ0PORlLR8IhLVw7Umk47F
	pYnwX7h3uGM9yNDJilYxATE5YiJuwJBpAwEajkVRUl8/PbdcJy34xFWqzqiJKWQNTjYhl0
	KEOrbCehS/GDzUZKFy04PUvzh3OvNjM=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-35da9692ec3so7007099a91.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777051337; x=1777656137; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nJpfQLhYCMBQwdjJS8K/XCMHtvPcHGNh9u8Wq145pxg=;
        b=BPdLHh+zAehR99miz9v9nWsmuRb/0mwBLhBk5/bMChZHQngtT0y4BCGCU7Y79+HI/s
         4uQe2NrW2fO2nw8Vrs3eJvnW7Iroz6qlqTaG2lNlshKR5DBSB4Rq/Rm/YYWpuGCdDHSM
         Txj9W3HN+0ZaFN1+9K12bQ1d1dTyvg6mTQTNor/rZAUHP+fepwS7JfGzxn7HyzIK9Op3
         IIYjzEclEI1tmhxvhPmG2Tjt4+Kpo6ddaYOp36UmHW2WkpLtqqO/R5KKth8NsebQFZ8s
         wWaAvEX1QlsSnnETLOMDur4RjZPqtI02S5ETsRKuJ8svjnBhD+Za5E7ahpFbog+tdScl
         gE3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777051337; x=1777656137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nJpfQLhYCMBQwdjJS8K/XCMHtvPcHGNh9u8Wq145pxg=;
        b=ay0UQSFkjLO+1qPt2vimi34LEfS98rxHsUGzCXYKzOej2w3HAp7KetcW0xmrj6/yiP
         AqE+wumPiANRKuXJ5UNxtJS3TdcFH4zlXb5VVaRhXidNkOhgGXi0APGAX6XOKHKAV75q
         R/03r5aGhJ7zg/hswu5Md64qICJiT7sKaWDb+6OcLyo5NfRyqYh0zYyDqCfuw+4SM7pr
         bvWf4wlaIrHN7vSiywijJzIKIiQjVDk93dmtlg5QRcviHKLcS/f7JgIo4wiH4idr5SyY
         VfBed+ZHYczZ3Ciyq/BueNWVdmdLGNoPwuKfJlN6UhnNe73NlcAgVNSxGfgY+CEM6ijJ
         Ubww==
X-Forwarded-Encrypted: i=1; AFNElJ94PyMPk4K/nedt7ThvAaBOd2HFwQYAhC3ySPuEa+W6jCfy/LRVT1tyM8Ua/f0MpTwAu0w/g6bPeQ==@kvack.org
X-Gm-Message-State: AOJu0YwgWH2kbOl4jvQjumP2eS7Ge/OBUdqu61DuTGxsGeOf3V8z8zaF
	WOKqmY4a/s/lkZIGjDb0yknp2F3jNLyMVwDwTbopTScBZ2B5oRrilhM/
X-Gm-Gg: AeBDiesAbUQeMh4PuD8AYY7KE3JTEC0p95UAN5uK7gn9aZ9YfWOfCGavC5JUqRjijXK
	7sPlFuT/AMCeHrKJM2KbeozFftshADzImo0BdzJwOCB82pGArrHfG/+z/exqeyP5ybRCAGPaSqi
	ApikPIyJl9qtbNLHNkoSAeVIERjkAXr94D7TEuiuietVmue5XYUxVtF4RzKdkbAnjpDVjocTDkT
	HJk3l1UiOEV44x0004hQbSSK9gQBAK378D90315y6fj4KcaEH3vlVdrn1Lowj9369g1SilJxixZ
	R8mwwsVVRLYukb8/RGalbp0xjINHoo6Jamw20CKVtWZS6paF0Pb8CF5mu7K5t8qNsDl7t+iXJJL
	KUt1+0O8/xdQtG9xuKLbQ/zawjX/oe1MQoATmNsGY1jgiH+kBdSUy8lHc3xcG6EGaWZ6uDO1rrp
	BOvfbkm69GvGiuUuz+I6HL8oac72pCZt9h++Hw/YEaH6ibrgutNPy9ujiGt13FoGm3IQ==
X-Received: by 2002:a17:90a:fc45:b0:35b:e4f8:7b2b with SMTP id 98e67ed59e1d1-36140468f71mr33021775a91.18.1777051336642;
        Fri, 24 Apr 2026 10:22:16 -0700 (PDT)
Received: from tech-Alienware-m15-R6.. ([122.171.19.32])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3614186a52csm30673498a91.4.2026.04.24.10.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 10:22:16 -0700 (PDT)
From: Sunny Patel <nueralspacetech@gmail.com>
To: akpm@linux-foundation.org
Cc: apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matthew.brost@intel.com,
	nueralspacetech@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com
Subject: Re: [PATCH] mm/migrate_device: Cleanup up PMD Checks and warnings
Date: Fri, 24 Apr 2026 22:52:08 +0530
Message-ID: <20260424172208.11674-1-nueralspacetech@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260424065922.5f15ca8c88eaf8a02847af17@linux-foundation.org>
References: <20260424065922.5f15ca8c88eaf8a02847af17@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bq79rg9h9omk6azzjxapz9qhpiot9s5u
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 26CD140007
X-HE-Tag: 1777051337-444934
X-HE-Meta: U2FsdGVkX1/5bnoW229B2qMKXDT/LqfxI3BTq0LEflokD3GNjd4fQVXO7WP0IiQRFci7hwHm6fsNqSdLD2X/TdmaVouTgCML+bLgSRA26ZmwB4xWs0vHsUHK2mLH385ny2/ouVb+efuqSxyc2OcC39b/5B9gBopG7IDnm0kOU8rlUoMQp/ADdU4hEDbM42iLu+PoYTTh26i7qrUi6GqHyLB78ISk7Jc+g38VK7Gj5uGM8zcCjtjJ7RAL0mYJHG9i6yoKZo2e7k2aRtGgrGAdTXKFA5ybFVKrXiEGIcyAWLNY40+951SWGDBXi4HHqPF00uMroZa6xeipvV7+3QeLwtMzhigio+D//srtntXqsb9WC+0Q7enGpqBokA7WJxHJ9DBvEUZa4R57FLM6JPXGwMZMjbjO8rUm5mNy7xPYtV4lbhh0tXldhiS/ZW8nUcYURXfvCG1Gzv8MqsmEX8x1UCaGrleaTy43QQndt+SGFP0WoQ0hXJmQ/g4pdQZ3eqhuVwnBr0HO0hFbESIsCccEeh0CcXcv4JDaJhHoL8OJ23LlkHVNShLHAeLgA9jTzyKJ8Pu40+uHGPW0nhLCvp0ouVRUGc9n7yKC0u7Xhz4atr5XmBciVLQMa/MQKgP7iqTnZIjOBbZ3Lx/i45aBANHHyDmMDsB1Xwsj7npU7JNDIDKhTZe+EadxW1AbarmVj40QxOVzW0jEnreGv7cl6UoyZecHR+bSgJrNTfJLdjIArqWNAvhJtpc5XUcLvlryw5eJhcPe697fUaVe+m1lFKuEGFs/9q2W/nJ3tCdvSuD/WL6DiWtheDZCyZGqOklVrpcJtow1wTuuuKoQWmjBCK/wUJb4/Nau6p2lA5+D4lGomOb/kRH5tjPDrZidbLEGB1jCAuSemtHhJQxd62ky3BXdlzK6mNeMFlAnhVSonQX+dFKjCJnWBQa3Hm8TR4pRVQSfhdt2xcU91JQJzJueQ0f
 Gabq0+kO
 4NPqeJfMeLFDQB9dIHDrsDR18ANjoCsVQ0RkeRGgYGBXgk2BHVu3rYsaK6mxcgJ5oi2Qeqt3ACBCcjR0/70wtT+Z42wSpaM+VTSf2xwWeC9V66KkrqTHSQUZUussHMe2Ytzyn1woe4XuUcFoKN7hjGoe6hn+hmO+bKzz0r0mv4pADOFpA8Crq6/GRzB88NXbXQkiIefEZMIOUJs0GwnNESYc3MtkAPlaJtiu83n+ZrSf6I9h6eq4C15BeNTpBSyD83JNBkBEyqigy4cglwV3etbphw09p+ify0wHrjrS4cmWCSA4ENd4DZ3LTBe2iTBMbso0NaA3eNpcricQuKee6jEut+FFxE4xV7fCAwE+exwNZbupA8ffYuOLF7BBNgdX09aVGFZybvcChj9w2MoKceZXffjTbrDV0O+8rjoOOkhMz81uFnLZTk9n74/KqMPuD14uNFys2ow6CEM8/jyVPvaI1GFtU+DLaJtgc50NnGLD2x9xKFPsQaXakAGEwC5hb/a0pJEH2bQXtrwphetZjKvIK9RSAUftaR9Hh5TGw8HZDQ5mVifcYX04vlud/omaL1wUzAOJsqoe20Zdh7FGk81B97A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Apr 2026 23:17:43 +0530 Sunny Patel <nueralspacetech@gmail.com> wrote:

> Remove the odd VM_WARN_ON_FOLIO(!folio, folio) usage and replace it
> with a simpler VM_WARN_ON_ONCE(!folio) check.
>
> Drop the redundant VM_WARN_ON_ONCE(!pmd_none(*pmdp) &&
> !is_huge_zero_pmd(*pmdp)).
>
> Refactor the PMD checks, making the control flow
> clearer and avoiding duplicate condition checks.

AI review might have found a bug in the surrounding code:
        https://sashiko.dev/#/patchset/20260419174747.10701-1-nueralspacetech@gmail.com

After looking into the AI comment found two potential leak.

1. The goto should be unlock_abort instead of abort to ensure 
the spinlock is released.

2. The pgtable allocation at the top of the function
is indeed not freed on the unlock_abort path. Will add a
pte_free(vma->vm_mm, pgtable). 

Since this patch is more of Cleanup on PMD checks and
Warnings Is it ok if I send different patch to address
this potential leak issues or need it in this revision
itself?

Thanks,
Sunny Patel

