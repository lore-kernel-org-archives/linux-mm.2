Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32340CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 315C56B0088; Thu, 21 May 2026 10:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C67A6B008A; Thu, 21 May 2026 10:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5BE6B008C; Thu, 21 May 2026 10:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07F3C6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:21:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A98881C0508
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:21:46 +0000 (UTC)
X-FDA: 84791640612.19.05C12AE
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id E2D9E4000C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:21:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rLEXO4t7;
	spf=pass (imf27.hostedemail.com: domain of 39hQPagYKCLMlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=39hQPagYKCLMlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Q5oVYYRVy83rEvyTZBhLaKBIsxHN0wptJNVngW/2MQ=;
	b=zBrmXwQNZ6PVQstOM1Y59vdeSpSy0qy0TdbuqCat+x5tucZRUizTvmEGSmujRm5XssA/d/
	MQk9SG838a9SvLk2eykehnRMC1U7lYzHz3z21ffmyj59ZgT70zA+bOihI+93J3zvoT1UgS
	wDe7FI7y0Fi89eAbcebPrS+xCW7zM+U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rLEXO4t7;
	spf=pass (imf27.hostedemail.com: domain of 39hQPagYKCLMlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=39hQPagYKCLMlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373305; a=rsa-sha256;
	cv=none;
	b=DYcSeC3zLcZ2TrkLpVXfvqRlPD5Q7/pBcsyQUYyde7PhZmbITouWdO+OG+xiK4m6d2gKTv
	PLTOxa/nxd6+fWzBisjjWTHdhiMRJh1DM8OVwQqwKsXXYv4V+BCQ6XyZK32gAA4sXtGygX
	zoGSZednSp0/i9RXcRy+ba5JQufTsB8=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-368ac44b26dso5317596a91.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 07:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779373304; x=1779978104; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Q5oVYYRVy83rEvyTZBhLaKBIsxHN0wptJNVngW/2MQ=;
        b=rLEXO4t7Z95QgRTkTiVaGWx4CR00ANK+Dd/eDPvWK1jjVBm93rX8a70AYDNBZPkv8l
         oLXBrul70K1pX4HseYBhNoT0adE7BR6+Eo60F4GeA0RsHbSiUakZBvE5Q6m+tad+GcN0
         j4iqCQPHw8xG12l0R6RFt2h09w0MQea0bLsdKYciJbCkeKo8LlATciawRH/i76hGKZHM
         s4C6fslfRmK+9+8Y/+f/2ZMq4IRFziEtFyuwM/tvz1WsW9L3DL/zgoG2QZ69lOnz5/l6
         qe/PikvqopRuLK9Ye5h0/PP/dprAJJ5lZeuF2g/tcIKVE3agXmgs62OyKNsSlBENTb8g
         Cczg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779373304; x=1779978104;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Q5oVYYRVy83rEvyTZBhLaKBIsxHN0wptJNVngW/2MQ=;
        b=sKJTQH2cZflAGn7Ms8gYOixVtkc8EK+kbqbA3MAiSCqzs/gZBJiup0HXRFi3SYbaCI
         gHa04WvMH7Bdphb5bxbSQ4mHTr3rEr4kleHggbKVlbZxp1H9oMSSYnjC3jhVe7nZle1l
         3AKQE/C1JuAMibhjPdtyxmkBaj7aADTPRfk3yDfVXw+BztKzxlMGFC3qmgIuTu8kdC3s
         hSjEcogwTgLHemErnXBGn6TfER9YHoGTcf1xlOKyVUmO8wYNwAA9JsjVkhE9p7cA1lko
         haCsHNAmbjwBoueYHBJ+4DLVmqLJCVLuIM43znEJvDOM+RYlbVpoTJE2MJg2QcpILFKd
         LNPg==
X-Forwarded-Encrypted: i=1; AFNElJ8LMfOsdhwuTb8VbAkrAk7bRGAi52dHUdGLo5eOVxYikp21H8WWRzZ/VXpzHt4Hs6yOCyMvWGa1jw==@kvack.org
X-Gm-Message-State: AOJu0Yz+8GrqeAjrVVfMkCQH6nu3zkhcm/VbHr8sPNXNJkcBGH9Au1NM
	DNZxzAHkonMReGhsGDZTQgYqUX89KjUtji2ngNaUWobqWx24GWjHvKIyAZbIrQk8scDi+BHmDPR
	QlzV7UQ==
X-Received: from pjjj1.prod.google.com ([2002:a17:90a:601:b0:368:adeb:4994])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2548:b0:35f:b5df:453
 with SMTP id 98e67ed59e1d1-36a45630166mr2922293a91.22.1779373302968; Thu, 21
 May 2026 07:21:42 -0700 (PDT)
Date: Thu, 21 May 2026 07:21:42 -0700
In-Reply-To: <CA+EHjTzu=28Sr3=9A9LmJEGz0tBEDbU9taznVV5kdL7s8Nw=Jg@mail.gmail.com>
Mime-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-19-91ab5a8b19a4@google.com> <CA+EHjTzu=28Sr3=9A9LmJEGz0tBEDbU9taznVV5kdL7s8Nw=Jg@mail.gmail.com>
Message-ID: <ag8U9qIcTd_GykHE@google.com>
Subject: Re: [PATCH v6 19/43] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, ira.weiny@intel.com, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
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
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: im3h7oe6g8uh85mbcp8hfkqrh9qm9rkp
X-Rspamd-Queue-Id: E2D9E4000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779373304-502598
X-HE-Meta: U2FsdGVkX18Dym+AmOcEbSRfUWhkdOsdnEkhSdDc1i7a6rYxj9CpTLYhr5rGN0aDLQmQ3sLIFlHTuZKZ9ZhkuyCyIVKCfbhEnT3fvpJV72AeMTF6R9hp3ExE2lesz/yWSK62MtBix4LJFT57qiGo6gk9gGtqspk6xqYVManOq9mCH5Y93krEt2ZSVamonquEZsuuPjX4YyFZR6IuRRn3lOq2SkjezmtMogePB14dWpwXWqGkaPgXd0g/rAiIPj/G0M1ViY1sdZ6+IjnzQBBuCR7qG0Q3EZbHCHvHTe3LAx1Kbm3AahmGoIc1QvLdtHvMiOT/bifb2K4GiRQOU0zF7zqYVopg+3IvWrZX2q93M4ah6TcBN/VwkLxLE7RF8DHu2km5mPbIhfdDh4h23dfmFsqIDLMM2Qt7iP8vqNlCWvX4yCq+JG1rv6GthDZ8/oveI4geDxuvRZRBExmfVt+XxEFkBxQNo5R/I8bfV/0k2aEICSRefnCPfwfOrcaOVhs3R6Lb37V7spnncm5QJ0rJsvAILHY5aUDB0DY+N5Z2xht4stss9JGDfy6n0c6l/eErm7X2O2WJsMhqXAnkT3eGVDnHrh/q+DTvgTLs0yHEJHOAOM/KrwEYn5tnvzvgRMg6VDgbNX0AXmjeoxrWAVTvJXNcwD6pbMGTitpv/6+HF16g0QPloPzMND4DJlm/nU1uiO20W8vxGB/B79DrKpBOcaR48aAFOE/0w+stdePrrSbwYFY5ow+Z9cst16Gqhzqk42eSMmcdsMMETQSQ3O2LEG0oE6z5S7b02JSJ27r/q9/0bXXoUt/gU+i1heUhd5Kh83oT99CTt8pQxihWRkMdpEH49vwDTLKWPJ8YPppDtPBpKBZj0Xq9K4tWzq3k2eITikktcebcm4y3OUvEazvPscDcC4Pi9LgatnzLY8DGTpxxYLU1tajPJxntGVH4HKPig1gFygiJ/colN4359c9
 smqSVCcV
 fHxKHdsEEnXdEeDs7xbsBOEKnhhCgjKtN7ryvB6vn2ps6DzlsBkwtoewhtxAMj5LnR6UaiN84bcATzOoYyGd4CxhIGG572fQ/MXADDJ1KEYHcSjqjRnwy8UuHZbje4wnwCKqMcRXD7OnE9Hs0QVGX4oXBpGwhKm7IwgeTYP7WVVGSd2NFvcXlMcJmAGtFqhGb+4x7nWcsb7SMvu4WIgRLDGHt7L6NeATw6ZLSj9xDNxaVRmikKAQQI4iw4SCXPtPijmLBQxqstaqZEjcygimBXeSJ8o+mDLlHyoBi4M8YrY6w68SNOlF3swEPLl608bHsEXQAwUvyfp0kYCOm8ArrNuaSZkFyfv/RDpLF0h1Xh84qGlwUndvl/j8WzQcievNnxPo2DG3MFh4JcP6FO//Vt6StsI3ZnsRjj8xvyIirNczfV25VA1MKD02s3/eLaMLs9D0VGl3ktbdT5x5PEZG1MEHgMjEB+G7pA4ZNS34W3HqWhZFH0owv53sJIFmKh5lVjNLlLqddNGaUHwIrzVi+Y6s5XaiLSP4cOBQuBUyif/ZPOSDG+P4QRN3O/JbB6OlNwSmdAwf87mpS3VGkXIufvC2C/UGIKq7kZZpc+HQDwtIQJYYSqvVdhXPpDYi3oPf2K4VZEzqTvjvLYWGh/fQumtO630ynaUd9Z4niEUXiKANMR11Bq2ziCd4vwV8a/awqVgHlFi2An8tIZVbNmqKC7Yk83lEKulJdJ7N0XDKCNbCVags=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026, Fuad Tabba wrote:
> Hi Ackerley,
> 
> On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
> <devnull+ackerleytng.google.com@kernel.org> wrote:
> >
> > From: Sean Christopherson <seanjc@google.com>
> >
> > Make vm_memory_attributes a module parameter so that userspace can disable
> > the use of memory attributes on the VM level.
> >
> > To avoid inconsistencies in the way memory attributes are tracked in KVM
> > and guest_memfd, the vm_memory_attributes module_param is made
> > read-only (0444).
> >
> > Make CONFIG_KVM_VM_MEMORY_ATTRIBUTES selectable, only for (CoCo) VM types
> > that might use vm_memory_attributes.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> 
> Config files always confuse me, but Sashiko might be onto something:
> 
> https://sashiko.dev/#/patchset/20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4%40google.com?part=19

: Since this prompt does not have a default value, will it default to N
: and silently drop KVM_VM_MEMORY_ATTRIBUTES during configuration updates
: like make olddefconfig?
: 
: Existing userspace VMMs that rely on the KVM_SET_MEMORY_ATTRIBUTES ioctl
: for TDX or SEV VMs might fail to boot if the feature is unexpectedly
: compiled out. Could a default y be used to preserve backwards
: compatibility for existing configurations?

> I think this partially goes back to commit 6, the one I flagged
> yesterday. But also adding "default y" to KVM_VM_MEMORY_ATTRIBUTES?
> The default value should at least fix this issue, but I'm not sure if
> it would cause other problems...

Hrm.  As much as I want per-gmem attributes to be the default going forward,
silently breaking existing setups isn't great.  On the other hand, I'm *very*
skeptical there are any SNP or TDX deployments using a distro kernel, so I'm
still leaning towards forcing the issue and turning per-VM attributes off by
default.

