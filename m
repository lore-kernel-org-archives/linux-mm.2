Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B01ECD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 21:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E4046B00AF; Wed,  3 Jun 2026 17:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BB6C6B00B0; Wed,  3 Jun 2026 17:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1196B00B1; Wed,  3 Jun 2026 17:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEF0C6B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:27:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8AD2C140493
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:27:09 +0000 (UTC)
X-FDA: 84839886978.19.D188092
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7E94C4000F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:27:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HImUn9pf;
	spf=pass (imf17.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780522027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXmCClVJ6sffKdNaL7Yv6BlzVuWsmG/JEBjIeBbKKjE=;
	b=EtKrdb24gNYfJiRLT/thwgcdSWiA4fVjgHLU7VgOxB4EecYIVallSA0ZiDQEFZECRPAVjV
	q+nxnnwVbnqz9HJeQQbnwdeq5GNIAnqzc1kOhPid37nASaWNS+EotgOU6mY3QRRFh1NLGJ
	CJjKL6yEB9I5HHLEjZX4ZMFYR6Co9wo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780522027;
	b=MlgZyxap1H4b1UweuW+dz2K4TMFK5BSTc5YcP8MJr2zWAcALLzjzFXqn6wY91JUsNtgg0a
	qPceiLEHlO6KRKTM+VQ9RLqUZrDFzJ/GOrZeVvQwuq4EQVV4EfDvp0m4gx1ehmLiatD5p0
	k6orLS8IkkJdbbrgdYjO6y2In49l7WE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HImUn9pf;
	spf=pass (imf17.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-137f0aa125bso36407c88.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 14:27:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780522026; cv=none;
        d=google.com; s=arc-20240605;
        b=RsjoE6JqyISR/TUAt9eE6GDh9XbnYmQ9ZQcJOKZPxJa/F5lb25ZfV38i/ZkE9QQ8JK
         QapzzF9HTvQOt6jQnrVBdlZ/yhtthvxzH104COLPLjwry16HRts6x65Xm6jCYTo9xgCc
         WYNFB1a4xel/8lDWfeuKl16mjVbCKtNsLEPHZzyafky+L2NC0J95MJbtjYW2qOzmJw1J
         ah56YVdwv9agbE9P8YUNEXPYrBE6vms4vXz1We6c5OsF4r0rSyesRFfMurrMqwFJLtwA
         1qyN9fbOBxVOPLY4/W4gw6d5oGpkQll42yJDt3CjjZrCgLJRHpX41KDhpJPeWhGygSXq
         WBTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=kXmCClVJ6sffKdNaL7Yv6BlzVuWsmG/JEBjIeBbKKjE=;
        fh=eGCF0SXFKjBV5pqXSa2f5cjMIIo3qzM9U8g3lkz3i2k=;
        b=CqN6wbD2iInlzTtfK8/+RDDdlHhYRpZ/LRhILQelqHI7tTbxnhUmBy5lvNRYc61D2P
         Ve/lZwaCwAQJmMrjAcT8SUKAuYq2tatKUW3WjlQECxUP7jRyCvgHH+cn6U0UWeuuiWjx
         LFyFGmolW55V7MBO9zWZvhmeR8Kf2kjIchbuAD/74Ph6TmQpwFS5fSqxuTFfrMJF8odn
         OCGN5Yb6h2jPl7E6z35qfs4BRpRYWyEFu5QPYPDXoZlvPX8vL9f5KB+NAskTqqjYVG2p
         0uATWABwC2xnBNcX/2KRfHJKl11KDSwP7zw9lAhgbHw2l8wrS5ZtaggZULpc+Oz8AqKM
         aGMw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780522026; x=1781126826; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=kXmCClVJ6sffKdNaL7Yv6BlzVuWsmG/JEBjIeBbKKjE=;
        b=HImUn9pfRLbEWWrdr4H4ptTxtzG9zzphuDAeSyO2V3b14yxT5fe3UfRxKtZImZYMn/
         sFydxjgg++6JERkufISi/16+GiYWG4ChN0S/FyWMxxIDA0ibzZXFqczeJI6QAaU45Ezk
         6DcZE0D0ZS5JW/E5bJ0HwYGwC0Cf1cLFyvDOhGSHv4BLWISABFjJFqoFzrohmnl7QGHF
         lOlEJxHqzqMJ3d4gEHPC3zUeqmeu9ciN42iqnsteF5UkHtOpPZRzIamY6yK+hN/6SEib
         Uucg5WjMLL3V+0GOMwX42x0YCwa5lJJhsnBIrwgudmqM6P87rmMJhtFEDjcqgwh1nf8/
         0Arg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780522026; x=1781126826;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kXmCClVJ6sffKdNaL7Yv6BlzVuWsmG/JEBjIeBbKKjE=;
        b=b5nvkN9yf7jODf+nKLvTRoT2qIim2nEgQ2R6dx+tZM8RcYQiVEtuSnxkW3JQeAlwiD
         tExYIpu3TyrxSqJFmQa7YDZUdAIV+0mw6LbUmYIgKDlJQiXCaEN6SDn/sB3u8geeWql9
         ne8YGtDdmqF58TvvE48gH5713QaSspuIaHS+M1Yr6qs/+y+qO/XcQimY33GD8x4BvmlW
         KJmZLoOGx51up4X1NMWzlVJgNdwn7HHvcUmjDqR1Jln+yw0Cls3EMv20+jtZbBo25638
         F4n16Q1GvBMi5fjMZ1+fiOdwmcRcF+5lErL+uWj79pLnqHZ/Tq53uA9bn/HL7BWJ1jx4
         8Efw==
X-Forwarded-Encrypted: i=1; AFNElJ8P34wL6KWLevB4R5PdDwk9XQ7BFtnxAbeqricVlYO3LP6DbQZeb7CzBQ6N0vTWnGfOdD/+Q8FgdA==@kvack.org
X-Gm-Message-State: AOJu0Yy+gW7xoLd5sOTcyA1NRxKUMa39672lSFgLG5nUGnh2kJ4rzU2i
	K3B/KL/EjZqs/RRyQMokv5ziWMzdPq9bB59EC1N9rvPeYBVxWCr5delfxlnaoi1iiF4HmoWqIfo
	luqwZ3IzTP9q6xip4JDGVokTFcYmBiKr3e6KiAXG+
X-Gm-Gg: Acq92OHeJs99GK2wqC9hkUGxuWjDCdzz8y6vSCm+6/Du/5Ng/Ssp1gB/MSiudGUVfYD
	WM4MDyMaZviNamLokkt3S/M1FWcWbuG9WsTjxQEqK/hXbnRO1wXSwmBo1AvCKnYbYLnYOJf83L2
	5mHp2AT0OpwVxOeiWLJ3Px9e7rIS6vMWxdc5lRyrekJkW45WI8XR71qpzSTdwQzjxRb30yPwL6o
	hWshgm6yPkOhsKjabCoXDN/n0RAc/qivwXWc56A6I9rl7c0YYEMXMfNuMVnH6eDJDR/GKi8wKsX
	JvNkHG5TVEJHkmtIfCv7557C/ZOFv00Cjm36IwyF0K+TzvinQaNCc8i5odjGq2qnfvNZ+KUGhxz
	fXXEqkFt+6anPL54=
X-Received: by 2002:a05:7022:1285:b0:130:9b78:b17b with SMTP id
 a92af1059eb24-137f6befdaamr2412541c88.38.1780522025275; Wed, 03 Jun 2026
 14:27:05 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 3 Jun 2026 14:27:04 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 3 Jun 2026 14:27:04 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
MIME-Version: 1.0
Date: Wed, 3 Jun 2026 14:27:04 -0700
X-Gm-Features: AVHnY4LsErH-4tZ18bsf2DQ3mNo93pDC9YYwJb_gB-LjwgbEb6k0MtNG-ciXWJs
Message-ID: <CAEvNRgGpaggjd3=ooyzv7iEbmA-x1mWJHgjLSjPi8=5CPrk-yQ@mail.gmail.com>
Subject: Re: [PATCH v7 00/42] guest_memfd: In-place conversion support
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, ira.weiny@intel.com, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
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
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7E94C4000F
X-Rspam-User: 
X-Stat-Signature: zucasm934ygy4h48xjnfkm3kbd3rzfo8
X-Rspamd-Server: rspam08
X-HE-Tag: 1780522027-571148
X-HE-Meta: U2FsdGVkX1+G3YmHpVya4Aj6IGGovLZFZWpVSa6D2I/Rknqp24LFL365Rg5zSCzBokutucoXAiSz5U4oKZgYwdc6aw1PSZCDW0Rt555e2OsA++mB7yR8MiMOaGtOW7qVjT5CjwcjR75KpjEpjH/vEbGizLInFiBdtHhqM3Ik7bI2F1lvxChfTkZkRdmk7aA7lHeMugJXHhWHLBH3DiXGw1VxS0ojBDcM0qW0uNH+vlSyIvDCbBIBGy+3btmu3uDo03N6ji99zz8IZ24Pwa0oLL1b7L2Kn7RkBih9o0Nde5x8vtc1sL7/dArWkK0GbkpIUqDTYDzA1uoerIsK0PnCcVAnf16oyUqs7Zk/NKABU8pGxNrUfI0eCo/qahMR8kciiLJQ8jPxa6z1gcv4SXBay943PSnUZ7BZIzE+cwkfI39QNmip0LRfMCy9Dx2c6osDQeL20TjqNBeJeS+tTJ9p944bW1cq/kEfBIN0sVcVcuCnpqQMwuMLEHGwijOGKZRG+2iJfvboyJIKniRlVJvxvppTvL42kH/Qcsy4LC/chUf+SLdj0PI0fpnzrKHL3QJuzkyFoRM4a9w2ZvHo6YBq3oVAni6ePbvVYj8xSQiWbtOHepsarctucPTnwpZdsIx9XLjaEjvyvaHjprMZjqRlX2Lr6t8xGR+g8AlBj5FJx17peFl7zIC+6b4JgBKDtztZkew15WehM0x8kHe2o/KwStxA3u/WEqE1wLQL46xAEmXkgF+Zzxpe5QyiHJalHeHUyqRxULxcjYeRxWqY2dLdLAGHM35eQTbTmEuwWhmEijllFo3w1HpKLWLUFly78GIrQfFo74gh7puQnXn+yJEyrjQYVtZmjwS+8u2sRAtjjKbr8Ecdupi7j5O0jnobJ5+ABVZsTirz5TMK1Hfp/L80GKLOvVz5yeEAOm29TTEJX3Vz1FDCaA8p95JvUFQ+y3NI9QY6igPXGTOfBI/x+11
 RL3Nb3XC
 rEro3jr8vLke/Ni5qCcPX4Hb+4LUHNFU/vSz8TnsmHsb2SfbJ3A8jUJN4WKPv4tWO4+VkYwpiGz+90uaE+QkUh1Qoh8zaoVT2ErQ1wRiCiSTca8/ldUrh8I4t5+UNJZ4mcwm4HgDaO3tg3nma54UB0Dl62D5yzvnK+DWA+ewWjxPH3SlpFdvd5WUi0eXpJgIoiO4F46YMHnK1KHRgEGLfiijKv/YSzbrv5RqutWy8O9YSQ3zNQ2XOV0KDnXddNrS1ISghq0fyPQCasCtDIGx9VN/wkWjNqdR1YFl8XFUJl1/IeapOFKEHsqor3zAyeb9AdV8zIfGb3BD2XmioDpZJ/QL6r2uB7qKOwiBumVDAnMgMyU765VHVYPHLixaB2p7UVwOa/PAqwQQOMDU57hA3InLZIGs2wLcbjDt5TeBmEOnR9mTneony1K19DsGfSnBqeKM6XcUkXQMcswAakvsS+w4VBaGcqmEy4VG0sxNJihE85XflpxF+jecur4j18d9/a31kNULuI5DHobkaBGPTvrCR0gdFkNKQCrUVzK/WLYMgC72l0fIH5vvxAM9MFbYbl4lWEJU71HN1OeCFdlsh0U4NGq9Lx05YOyvVBV9wXyDxKOeGldQxtUSZnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

> This is v7 of guest_memfd in-place conversion support.
>

Here's the outstanding items after going over everyone's comments
including Sashiko's:

+ KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
    + Need to move page clearing into __kvm_gmem_get_pfn to resolve
      leak where populate can put initialized kernel memory into TDX
      guest
    + See suggested fix at [1]
+ KVM: guest_memfd: Only prepare folios for private pages,
    + s/non-CoCo/CoCo in commit message "INIT_SHARED is about to be
      supported for non-CoCo VMs in a later patch in this series
    + Use Suggested-by: Michael Roth <michael.roth@amd.com>
+ KVM: selftests: Test that shared/private status is consistent across
  processes
    + Improve test reliability using pthread_mutex
    + I have a fixup patch offline.
	
I would like feedback on these:
	
+ KVM: selftests: Test conversion with elevated page refcount
    + Askar pointed out that soon vmsplice may not pin pages. Should I
      pin pages through CONFIG_GUP_TEST like in [2]? I prefer not to
      take a dependency on CONFIG_GUP_TEST.
+ KVM: selftests: Add script to exercise private_mem_conversions_test
    + Would like to know what people think of a wrapper script before
      I address Sashiko's comments.

[1] https://lore.kernel.org/all/CAEvNRgEVC=fFuKVgZYvWyZD7t_zvUZihFG8hrACjvtkD5cwugw@mail.gmail.com/
[2] https://lore.kernel.org/all/baa8838f623102931e755cf34c86314b305af49c.1747264138.git.ackerleytng@google.com/

>
> [...snip...]
>

