Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF3ACCDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 00:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA6546B0088; Wed, 24 Jun 2026 20:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E57FD6B008A; Wed, 24 Jun 2026 20:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D21036B0092; Wed, 24 Jun 2026 20:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93A3E6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:19:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1EA05A04BB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:19:35 +0000 (UTC)
X-FDA: 84916526310.28.DF3CDE5
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2B5CCC0002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:19:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TgK1EBuy;
	spf=pass (imf28.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782346773;
	b=h94kex9UiLXErMfmt5bBu5Wa8kFnPizg7KQ/RH5QfMwvsFhBKZnFsXkNEy5hX03ojf1G8R
	MiLVUxsPg9CmQu8f1P5wLhfM1TMD32kzIdPeIFN1JwWF50JXhQAQSkXHyNSKHnxmRxgofM
	ZooU6zh4foVU0o8mnijd98fg1bSOi2U=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782346773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dsN6vnyaJBkYRNoTR8AKQC63zHcXTfT03kDeM9s3ZGs=;
	b=p4lBi2/lanFhSvwG5fW8dl/hT1baBBj49fdj1NUSS6mf9YczltvfLz3ZOWfra4TmKIZFuI
	gsBNR5g5ou+iGUXOdB8qnlzR3fsX7Hf9YIHSjVlsxOWNRQkEzHa+3UramdzRxWsIMHG/u7
	UGOsx//U3n51uq8ADhqysDlC5x3wzM8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TgK1EBuy;
	spf=pass (imf28.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-139a71baa35so4345393c88.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:19:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782346772; cv=none;
        d=google.com; s=arc-20260327;
        b=L1KM92uKnugjqyQpWnDxIV+5tYNuYOVK4BhYiZInO0+yqyJQ8JDfkgfCpAEAG4letR
         i+oC+dctYsOu4t9FQKFjslYrjcOXUwpZ6zr1jug3MQppuNMmj4P3vyg1XdH/um4zaMOI
         J5+HFn3F9acMHOFLtRU5MbluYamPBCwpLd9PQx2tJa4jHSGUjky/1KSvF5mYeVAppmNJ
         WzgsZsCkwb7qzQMKwaMf3Gs6Dx7uGYPy5ycakKsppBhjRweAzGBQM3Z5WIR0vXEWclmV
         ToH+wupFDIcDEYz64q3Pe4iHGti4hQh2GRjMhN/ACr7ltJJF/BxVfgmPqw84+D98Zlmg
         A2kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=dsN6vnyaJBkYRNoTR8AKQC63zHcXTfT03kDeM9s3ZGs=;
        fh=R+TmXJtrZQsFjNRYKo75lVDe99arvSMUfvuoHoOW9Xk=;
        b=FJS+d75ExV+l9koKKxwBFTfZLe0bmCJtvHLLtm/Lm1aW8RSU+0iyfWAgJHf4Ij5MgB
         Q72shxPsnLpXCmb8JOUG1DB08hAZvyIRjCCsScKurvdJdGSv9V26eKLJ71rZpofMpvxD
         fEXxMrKzpDucs/5elyD/xtNm0RNuoQ2La4zvkeD2AfseNDyII+ZD0Iv47BU9YKQxfhNB
         ZNUhxkzYcAh1MKsiXuYveuQyItERl+XvrR4q+45DOS1zKtwUN77TnoWHrK+kAU73gncp
         ayHbKxbHAMVgE9mxziygd6QfyeiMc3hVFvvlQRoOwu2BLlYv0aO304yBYZlq04S7qR6a
         ULvw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782346772; x=1782951572; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=dsN6vnyaJBkYRNoTR8AKQC63zHcXTfT03kDeM9s3ZGs=;
        b=TgK1EBuyxWcTaYZEdfcoIV/L6hISVeLrTYiNb112CZOQsX9VbueR994Ve6u55t7vxW
         M+BmXMdYCPGgYGxBidS8mHSL8KZDnHkc4FV81W7MS3cFdJlO86aabuHt3JkAXgapRwqx
         3iIEjHkjcm7Q9fjNPMoFRC9eyc1KWaIMMU53xsV+NCp1yRdPMdUJ16e+VGZTS+ZwgO1c
         2oW58EEU43TdghMRX53iYwRBSORbFe1zBUG4XOK4EWH9qxjusCHjQ0mYhXRmYdFkxm6d
         gnw94oOYosV0wrRLyD3eO1eHNIE/Yr7WpGzYNf2Wb6pV2IOKSokgFf8D6wFWgchb2aQ3
         6YxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782346772; x=1782951572;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dsN6vnyaJBkYRNoTR8AKQC63zHcXTfT03kDeM9s3ZGs=;
        b=oPWaCcvU4863EsOmqfKGLG+oYRSIOlE3AIXZiO5mqkNypj9sjYxLGV/4krHHTGJ2Ab
         yKufL1s0wGXG+SdnOhttlimXoLEEzP/CNqMELj0BhyRiLiG1SttXmumEVnDrya5dFXOA
         rfCIcM62W0IpAkGlMbnm0iAWXs/c4PWQfoTEfEkMS6o697MArXKO5u1Y4vEegTb1OlD8
         T2PHOVAQqO4agkcJGbEdu8WvhTSyS9uK4Xc46oXElRSOhI/WMMLl1mM2014oxzXLEg0u
         fnKqTHP0UYM114ZFpzZAErFypMQH5Whvi/mJgT6hH6IG1UY1rZ7Dn4GQI3+QiamH8Tb9
         6aVw==
X-Forwarded-Encrypted: i=1; AFNElJ/iGKYf62mf51LnKYCcdk4FatFsq3cbLAIZ1zlHdPfXknilzuuhoi3OwDI1/RE3k9ynSUSxLZUYew==@kvack.org
X-Gm-Message-State: AOJu0YxEprli2L7UXHZk/OyWiNksrehGHQoxeWsW5Gri52GJ57NKK3jQ
	Xy9tYrmhVBW2mHoSD5eD3mFbW68DxxzvnN0J6KlSWsGEVisx3PZH5OhF03X8jpSIsGwjEJokWfw
	xXXkeaY5MXrUFwMTyYPJE76JUkoV2YJGq8zD0csqO
X-Gm-Gg: AfdE7ckCVXqxTU5yB9R6w40CTZ3Icbrfibq/OXJ8rX8Wt12ISNoj69c8IcIW2H/ycFK
	TD62+XLciouyslfW+0S9ttZMQ79CIppeyC2Z2IPN69VL+b+SMXim5UN3Nak0g8Cxto0vSpttRmV
	x78OGDAs5Fhk4LnJ4AZPKWVGc5MiGpSSofmfQAPq+XmRbVivK1Isocsn0igKwZhq9YhOLtBMNt5
	+riNl3DQyr85ngfcVt5at1QmlHi74YFiGaoF191RhzaJobthKLXJ/DQka9q2ydFDtCWjofKaAXG
	Rz6BRgBiDf11uhkJ82taOGjTLdy/Mdb97ReUqvx3IXYRbv4RyvZc5lyRruw=
X-Received: by 2002:a05:7022:fd05:b0:12a:b39a:339f with SMTP id
 a92af1059eb24-139dbab1be2mr235748c88.21.1782346771178; Wed, 24 Jun 2026
 17:19:31 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 17:19:29 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 17:19:29 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <a6373206-60b6-454c-9aa9-9d52f9d84de3@amd.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <a6373206-60b6-454c-9aa9-9d52f9d84de3@amd.com>
MIME-Version: 1.0
Date: Wed, 24 Jun 2026 17:19:29 -0700
X-Gm-Features: AVVi8CeipeAcfAxYa6j2yQPCcdB9pyHrAKYmhFznoyz3FS_QiklRPL3N5ubFoHk
Message-ID: <CAEvNRgFUru5GEM7g6Z7nuaqQK2iFmW3w2dPYEKPuehkdGvP2yg@mail.gmail.com>
Subject: Re: [PATCH v8 00/46] guest_memfd: In-place conversion support
To: "Garg, Shivank" <shivankg@amd.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2B5CCC0002
X-Stat-Signature: 49i75rzpps9s3s5zf865fj73ie73ooqx
X-HE-Tag: 1782346773-473455
X-HE-Meta: U2FsdGVkX19G/yepa1/RGloVKfRk9UoZV0KLG6jEcbfBW+k6RQf9yfAHdCOGse3E3oh8ADM6rl50qn6fv64ewipD16ovYrphuym18Wk8EVLsYtvpBIbD9jNbHeXeIDBVyYmGCVqF0dk7IhnPPwDqWV8hxDAMTi97fYglwsmlgZjav72L1bH5xPDkdVXG+xzhURswV/f+xGKx9H1f+CPLdX8c7OKCimoJ3OiEVrHiGTL/OSrPCkPykODWWIZ19CDYtdr9m5YM8vXPUmTpnXQZHyp/h2cU8ygF/kgqi7m2cU1YAO0MDf0qoFveiCfYFtQrBaCVrjLzcblwB5XB25Pj2GUYN+0N5kNDzW72TD69U2F0IkEwrXW7xWGqnTU0dniMrr0WHIwKa8bzWzMRDVX/mHi5nq9ikdYlNLyutvxiH58vnpYmOV32xSJk8gr6BBCy2HYTh2qNkRSG/H/Ot5qeqaWmgxeTdNyu96PjCGKytjlz/1P8al24fdlVUqaqlpKzsmAqiuXf2iLYtGge/KWLCbcBWQ4IJKlFyHwU/gqDv/RbyQwvO6XlN2nfT73d/Vo8iRKiHVok1Gbiy7W/iwYc6Bly2IEUywxAgbn/FnCFWgHZ1ntbDncRpaWsAs76XiTfO9Toc6Mj1tzNPc/FjwbZk6SWfUVOGxx3+V43N0zqtlDMkf5e9Kwo6JCt2HIqHxzdTX9KOaBBUsZ3HLwXGM6H0U/Tgb3MMfsfnmywo437rOXy81m0eexrnRVC9Ozx7PpEkzSNil2JQvV0zDAZtslbhrJtfyNKIgpw4x9xYAX9RiZsxovt1TFjkYE+ajMFeqrsBD/Fj923Yea3EyTjLEVnchXjR3Qh86D3HemtC017IjYVK1xVUxdExn+WhJEeXTCkZy8ios+oJS70QZjgDj1bV5a+THp9pYEKB4vfybUU9DIUutDRTbqrh7vMr02FmYRq1ISmEqcWcWd9HQ0+TYH
 Dd/5NMPK
 iyFHVolR96XiaWXwfpv7XxOPjGRamlHCt31GzVPj+BDyvPbRxKWn9u8Xu3tOweKANorZUR55a97pNCTTE+S3tg+UA15wxBL4lbVWJgNY11D75VwpVG/4F8uxH7kEhSqxMyJ952+4gP2rtCLNj2s8PK7qxo27YJyrpNzdQjuDKgNIir62dmTu6AY7p/71llHvpzn2eIzmg9aRjyYzVXn+m5Of2jRsjOjqx8EJ1yUbEP9uS01IGwDrk56cvLWnnTibebTb/g9BBbquntDdQJAnZzlR9TuEsfRbUkE9XJ+vIqKbXu/a5mMeJJZ1qLLP/NHZozs2bJnReQpgjQfKrVMu40pLeb0RsMqhBZEJGzJzhr5vOAKguRMEzMI+Fkti0/2s94QzA4FGOogk9X2EDsogFeyOv8bygOHRgugd5QTSRrJ++Xag=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Garg, Shivank" <shivankg@amd.com> writes:

>
> [...snip...]
>
>
> Hi,
>
> Thanks for this series.
>
> [...snip...]
>
>
> Tested-by: Shivank Garg <shivankg@amd.com>

Thanks for testing!

>
> Best regards,
> Shivank

