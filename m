Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65BD810FCAE4
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 21:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0526B0005; Wed,  1 Apr 2026 17:12:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA1536B0089; Wed,  1 Apr 2026 17:12:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB6F36B008A; Wed,  1 Apr 2026 17:12:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E9536B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:12:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C0C2160164
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:12:54 +0000 (UTC)
X-FDA: 84611236668.25.0F6CFDB
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf12.hostedemail.com (Postfix) with ESMTP id 85CEB40007
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:12:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pFb6Nsnm;
	spf=pass (imf12.hostedemail.com: domain of 3UorNaQYKCPElXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3UorNaQYKCPElXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775077972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L2hTe6/qAASYky4w9/7qUWXPsVepZndGTLTeQA9+UIs=;
	b=1gBEWc8MotGF4kR4EIWENN2tKaaMB3A0MU1aktP2+9Qhmn0LGq9UTJnPzFrExphlOs0mlL
	Rj/GoIXB3xVt9z4X1w3SiMkPmjK8ltdsA3AxkdEzlTXtoiTEK9PUFr0OUp3nwN0KG0Ylcv
	2e6hgll5FMiHSoSkhe2XsDbCmosKzHM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pFb6Nsnm;
	spf=pass (imf12.hostedemail.com: domain of 3UorNaQYKCPElXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3UorNaQYKCPElXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775077972; a=rsa-sha256;
	cv=none;
	b=kWa0vlEQJOCtoj/pgwVrRvcXh2nG+OAwbZ+FFkPjdqHA3GUj/8Fy5dRf5sX/VC/KGqcn8Z
	w8xGL4uaifLsi2veIHyVmSCMzC57lngNgxhEzJnCMOrw9M+eeDT8P3hO9KPZ+taEA0bHiD
	Q6VP9vL1jRJPw5x55iAwpOiaWjpJEsk=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82c63f85c84so96532b3a.2
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 14:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775077971; x=1775682771; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L2hTe6/qAASYky4w9/7qUWXPsVepZndGTLTeQA9+UIs=;
        b=pFb6NsnmDTnwsPL0qrs4hbZfDnNfSDSg1BihAini5TSGIwgLMm/I8CR3z/ldbuLAUl
         ZdHVjKIoBWk2xaA09VGQoTyYZ6TdaKeIgEqYP5Ugr+QFYfKlgxRZ51DK4xcnbO0+xdbk
         z4+m5mTGlO65+mYIckKkFMPUWKodvdKZMk+g0bWO8J3wN+0Eq+oMtOKvMxjQLyUCq1SX
         Qtypwmm2Na0m1YYt6PZIafCjhEgjz/MXnPrWrXo0bcicjjuvsM0zmOETwAwNLBTMIlDX
         ETPXUUoe4XOGqQ30badKY9t8jTP7wgDAbbHMwJbISmNND5eYclOwnYmnlD4dGliF89JC
         FkFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775077971; x=1775682771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L2hTe6/qAASYky4w9/7qUWXPsVepZndGTLTeQA9+UIs=;
        b=YEugKK5SewjsVw1IxoQ3UYldDcLtrNGeE2F8fzKf0NCExXpvGcU2GKP0XE4DTBS2vb
         W/szZOgTfxkPTPtUi59INxTqdU1DF/PJC2OarI2j41Bq8EwPydkn9S6ainAgJEZKK9gQ
         dlWMbF/e++Z7yGSrkqN8I+mU35gw9CDl65mVuVCHx6GWR20XLqFFFNmJlFazTu5SKOb6
         tJXs3O0NExHoLD8XzHtc5pUxOO7PtDAeetOOATd4seylVoov+8ya7cDQ7AvNVUxaM/4z
         O2RUH29ZVZiruGYWrQrseyz5MBkjGtRvWUH4Wlola91glsynC6kqAgkqQQk+97CYDu4n
         0H+A==
X-Forwarded-Encrypted: i=1; AJvYcCVNVcrWkZ07ckhaDDl/U+KByjrDcSifzbC6y0QjOTzJt7TNXOe/y0rIf9M1y/eKaskzJ8Kie3Xt+g==@kvack.org
X-Gm-Message-State: AOJu0YyXDFpXaUgrsl1KbCw42ZEpaNiQN/Lol1GA2YHviwBaxRdyUXoF
	/bTS+ZhLUzQyYmf3N4y84EPlubuNt9dTNFotlHk9sLlmIHLFb7lpisgOblbqJQ8CHHcpkpfar4G
	1G7TH0g==
X-Received: from pfbhw14.prod.google.com ([2002:a05:6a00:890e:b0:82a:ff5:27be])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:84d:b0:82a:fc5:fb81
 with SMTP id d2e1a72fcca58-82ce88c3336mr5445243b3a.5.1775077970623; Wed, 01
 Apr 2026 14:12:50 -0700 (PDT)
Date: Wed, 1 Apr 2026 14:12:49 -0700
In-Reply-To: <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com> <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
Message-ID: <ac2KUaWxpVxmfUtY@google.com>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
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
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Stat-Signature: 3uztw1osrhqhk7xaosd1qchkrygue61x
X-Rspamd-Queue-Id: 85CEB40007
X-Rspamd-Server: rspam09
X-HE-Tag: 1775077972-840686
X-HE-Meta: U2FsdGVkX19+Y0FdIDdMYwhTWsYAdYR8P/zNN/KbdP6FyRGItRE7kagW84G2Dr8V0BtM2sZxfGyf/uB2UnJrY+tGuOqX+XAaxOsJP9sOu0lYWkLflazlXA2zLFC6kk8c4fVwsZnVFwJxztEXVg+5Gi+7dcTtU8L0NWeO6cGgrVqcnAx/0nj/XWOk36DlYsrv/Zg33Bs+053u2hHMJRo3XGa36xxcfrOddioa/WG8T+0xyw0FYuJWqw9+VG/Mc6Gp7xFv39UiRH1UUxuHZHlLNUJ/GWvzX3bBe8iQJTwb+G+eL1iIPLmeQxskoD2ocDaZEevyazFemrSz4T81edktFhV9/C3u5FF9OO32aY5zjbMU3TxeMyM42AvdlPAb+qEm+W8t8sX0DLgsvhBh067BT4hSk6g0XAs15OE8G351FeSUMmPUSUoXNyWj7KJ9yFZUxwSV/UvpjiY7itPmWg73SA9cT4TW7aYKORRCbqB9yDOJY0S+j+jMLJEu3KIfp5yLAqVn6GCZWBr5Lwt2EUE5+knsLyGwvCaDRasCFkA/ssvUh8FnRMecXXs1ry2Go0fmLyGOkNRmumgLez/7LVJdGrjWt1dsHQSu58ETy8+EANdb/qKPCnUTqNRA2UPLkk3AopefGAd/G2+/L87/qLMsK+5ZKZFSW2iTFU9slo9Sz4o5IQKfcUg5IUQaq+JIL9QaTMOtBGK7C0mQ1aJtSNwoX7r9CPZG//Ym8GhTG+ktk1vOKW61s03pYJBARo7a/352SdVDYcN0UaclcnHrTUXFrcsjZiMDHMagOwgti3ZVrrsjIJ9OogBI7u3aKPolPVPDX7JKw2pUojFQpLxahBOsQRKu7BCkvHJzgRZV3PBiSWKXAJRXIGQvWl4EiqSmYqIMOOUs89I18SdlhOAGSPu2KRp6XrbkOjjkjLHdc2aU/dQVGJ+CTZFJyVGHDTF0KaWsJsDGDkdElN8jWdXXmBt
 jehVcLpy
 kSAZuVwS6OOLv+dMjijepfcThqsX737VladQGId0Mn+Kn4jKaBbDWgL927EuNvko31meSbH/lci+JOYsqo0g1a0qWhDwxW3XDRfnHis6Ipby8Q5y7T7/vjHEjZzTgY+SnIHi4rSpTh/DZcZ0GOH++cUpHgZrY5apysVNp8JeeVCf5KJFRFrPBWiQ8Y4eSkZW6/QCa4RUb+RillN9lEpiR+cONCuyF6p4ldsJQ7WibcRe2wlxeKmHi3UHKkjcYTwjfujOrLptQedpYEm1qAJOaRXURqdDt9esecX9i8FvR7Ah17Q5mY7h3iWnr44lCGJGAHJQcWL5vb4qbQ8pp34+Qkf98JvgsCaetTkk2eTxdUJ29NbNmgL4j+3KLp2xCTCz0e1PzieAscyB60qI0IPZKguLYPMEBotg0jFetczqJD/VdQ2mjQroD08C/xCTYnsvLxiAba/tRxOYD+ppv4rHMbFUw/9lC1ri04Y2W49n2V/l/He1N7QKusOy5CVMoxpwEeVU23hznQjwgeipObWOOwJYv1nw5nnr9G/0LAMBR5Jc1GUbnv8eEZQ9CThLA9PXLapIZhJDFuIU+SWGVaTKYhd8U7tqRpKcRIcmTJ9qxq8NZVQ8lbH0CVVflTuJevcxAEQk+F8G2JOK0U+ovkdxJ99cf2AiF7iQGiXYNX1zk9j32f9sRa0ERpZMPwvqBr5oYn1zqSQYpZZvYuWeIJyPWb4Cc1llUSCs64EhA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026, Michael Roth wrote:
> On Thu, Mar 26, 2026 at 03:24:19PM -0700, Ackerley Tng wrote:
> >  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> >  static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
> >  {
> > @@ -2635,6 +2625,8 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> >  		return -EINVAL;
> >  	if (!PAGE_ALIGNED(attrs->address) || !PAGE_ALIGNED(attrs->size))
> >  		return -EINVAL;
> > +	if (attrs->error_offset)
> > +		return -EINVAL;
> >  	for (i = 0; i < ARRAY_SIZE(attrs->reserved); i++) {
> >  		if (attrs->reserved[i])
> >  			return -EINVAL;
> > @@ -4983,6 +4975,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
> >  		return 1;
> >  	case KVM_CAP_GUEST_MEMFD_FLAGS:
> >  		return kvm_gmem_get_supported_flags(kvm);
> > +	case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
> > +		if (vm_memory_attributes)
> > +			return 0;
> > +
> > +		return kvm_supported_mem_attributes(kvm);
> 
> Based on the discussion from the PUCK call this morning, it sounds like it
> would be a good idea to limit kvm_supported_mem_attributes() to only
> reporting KVM_MEMORY_ATTRIBUTE_PRIVATE if the underlying CoCo
> implementation has all the necessary enablement to support in-place
> conversion via guest_memfd. In the case of SNP, there is a
> documentation/parameter check in snp_launch_update() that needs to be
> relaxed in order for userspace to be able to pass in a NULL 'src'
> parameter (since, for in-place conversion, it would be initialized in place
> as shared memory prior to the call, since by the time kvm_gmem_poulate()
> it will have been set to private and therefore cannot be faulted in via
> GUP (and if it could, we'd be unecessarily copying the src back on top
> of itself since src/dst are the same).
> 
> So maybe there should be an arch hook to check a whitelist of VM types
> that support KVM_MEMORY_ATTRIBUTE_PRIVATE when vm_memory_attributes=0,
> and if we decide to enable it for SNP as part of this series you could
> include the 1-2 patches needed there, or I could enable the SNP support
> separately as a small series and I guess that would then become a prereq
> for the SNP self-tests?

If it's trivial-ish, my preference would be to include SNP as part of this series,
_before_ KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES is exposed to userspace.  I think
that would avoid the need for pivoting on the VM type?  I.e. don't advertise
support until all VM types play nice.

> Not sure if additional enablement is needed for TDX or not before
> KVM_MEMORY_ATTRIBUTE_PRIVATE would be advertised, but similar
> considerations there.

