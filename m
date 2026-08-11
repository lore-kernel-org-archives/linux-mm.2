Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20E1AC5CFC1
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 10:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20DFE6B0095; Tue, 11 Aug 2026 06:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BFBA6B0099; Tue, 11 Aug 2026 06:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D5F16B009D; Tue, 11 Aug 2026 06:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF57A6B0095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:32:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67C11C0386
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:32:09 +0000 (UTC)
X-FDA: 85088623578.14.B99AEE5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id BE416140004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:32:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QkssVT/Z";
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786444327;
	b=5lhqG7Ci1L0+zUdRJMjnRwMacijRbTBtujfZUaGhPi3zJWtOYsNhQqZjKu795UyKHvnlAY
	eQmnbkCC+JRa95NxIn94j/xpX6rSw7Bcz4YpUTY/WIZfxJZA6JYm9zXX/o04dGhMKh+are
	zvDvptnXTKmJKb+nIejZYlGsT+ZCl8g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QkssVT/Z";
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786444327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6kqp/Jib2qHuKnuXjTW7DmBQCS/40A0zxBCp5T9KsPM=;
	b=54S3NiMsf3XjqOtS22hRwIjfpYqc/+sRAJIHwUn8DbNu3Qa0HhL2x9qXq3ox5DHY5jw87O
	TGvghAsSdU9jhcKoKAR7op82yYykoZ8YLpJFYpTW7Rx9wuM8pFJzoMCZ9l/wdIy/UQOoAy
	zeqZ8B2W4HnO/el7JGv8WQM2xMx+sCM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 071CA439CB;
	Tue, 11 Aug 2026 10:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E6B1F00A3A;
	Tue, 11 Aug 2026 10:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786444326;
	bh=6kqp/Jib2qHuKnuXjTW7DmBQCS/40A0zxBCp5T9KsPM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=QkssVT/ZEngrzN04DrcXhMOGvp2/M5W0FwI70XNEh6QmviL80rjbG/xm8Z8DY/veP
	 4/5hlZB68qF+W0qhrPBu5QDHdz3LEebs5hqxgz2tSMDSR18UIxm6/2431u8q7I28du
	 4aEWTQIDWhF2GnpPLVvUbA14iMQp0K+2zHB07Zks59uo8rVarUwQQa6ooozIlDHYvA
	 Z3mRlx13lH0cw3mBOSJ0fVwwSye7D9hO8Ae9MJcZvPI7XmEu1ahiNwljhCI63aDXFd
	 ZJDHJ+g49/1tM/69n2VTE+I2MMdqysmC6BCKSzET2ZAzZuovCQj6yokstS57mwsjHh
	 nB/WQuPbeVmGA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Tarun Sahu <tarunsahu@google.com>,  fuad.tabba@linux.dev,  Andrew Morton
 <akpm@linux-foundation.org>,  seanjc@google.com,  dmatlack@google.com,
  Shuah Khan <skhan@linuxfoundation.org>,  Jonathan Corbet
 <corbet@lwn.net>,  david@redhat.com,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  sagis@google.com,  Paolo Bonzini <pbonzini@redhat.com>,  Mike Rapoport
 <rppt@kernel.org>,  Alexander Graf <graf@amazon.com>,
  linux-kselftest@vger.kernel.org,  andre.przywara@arm.com,
  michael.roth@amd.com,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  will@kernel.org,  vannapurve@google.com,  maz@kernel.org,
  fvdl@google.com,  kvm@vger.kernel.org,  oliver.upton@linux.dev,
  kvmarm@lists.linux.dev,  alexandru.elisei@arm.com,  skhawaja@google.com,
  aneesh.kumar@kernel.org,  linux-doc@vger.kernel.org,  David Hildenbrand
 <david@kernel.org>,  yan.y.zhao@intel.com,  kexec@lists.infradead.org,
  suzuki.poulose@arm.com
Subject: Re: [PATCH v4 06/11] KVM: guest_memfd: Move internal definitions to
 internal header
In-Reply-To: <CAEvNRgEVxQS2r0_iPHciV=NEKFzwnrfitp-QdP1keAg5Ud7-TQ@mail.gmail.com>
	(Ackerley Tng's message of "Thu, 30 Jul 2026 11:12:54 -0700")
References: <20260728121138.1103610-1-tarunsahu@google.com>
	<20260728121138.1103610-7-tarunsahu@google.com>
	<CAEvNRgEVxQS2r0_iPHciV=NEKFzwnrfitp-QdP1keAg5Ud7-TQ@mail.gmail.com>
Date: Tue, 11 Aug 2026 12:31:59 +0200
Message-ID: <2vxztsp13q3k.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BE416140004
X-Stat-Signature: mg7w91uhipsqnr4krgsh7umhbe9qyfms
X-Rspam-User: 
X-HE-Tag: 1786444327-982601
X-HE-Meta: U2FsdGVkX1+IAMHdC2RTJ2LNKlkQJk2TfD99335dQDXy+9bjOaazDQhl1iPTN/9E97lGEZ8EVG70OUw5YBOR9a5D0MUrmmnp/SXtrGaQgQpSvD2xPFHFGQsL0RmUFYWg1WRP+gsszk0A2lY+xc1/qvR8XTy5u7F3mNhmC3n3FWNk0Q27d+IWVUfM0i9eBpglkWulkaWArXALXOnI2Vfl9SVXMPCvv7nPTG0YFmwrAzSCyeiftd/RGZU9njxNmrHdWiPYPR6J/Pc0KzUbfBpY7FJgWBtrY1KwEPyJcty8GZ+5YNgEg/9FcyI6Zz9Gi98J9YdS0jnhcGd3j26wtWmPcvt+IoMgmpX51onFC4ha7ICVftra+EPPLUrIKV640P3CcvXj2aSLcHKwRbQ3RV0Y+8bl2p+o58YG5wBe9BiCtouB4oYFMnObU1MmYr6WTFKvR8JSHSVFxRjAlUWel7Q3/vVN3Gi4RbFqPONFdC4RQAgVjDRUjUB5v8Ui3eRwb2TBHjiZQv+DN6EA4wz23rJos9n6hNd/9YZ2Wl00aLd1CfEFYKOnNmAFnUvpuw945wK6J6+z20mOyWhdB8e+g8Y2Kn28hs05wlk/bN9SJmRboqLBP34waglUN7YY9gAgrXDPWj0VDS1ZmWz9Cx7FKch8Z7r/52bvLYla+MuG21Mn/4KxtQjH3dN5qK83HEWcJN3TdzYqijWca5wa3rPIQ2zUwlillq/kUd+w+Sj695+QsnrTHuozw7aa5/CI8J4uw3dkfBIMZabG7PbLfZgvHdPQvWCREb8Fq0cPA3uuL4JzehYsMt3qwgv/jqszfugn44uSqPcoJ7i/Sq4PJ8szGngpUNpqXHZU7D9U+q4KP7Eyyq5mm5HNR3VXWYn2UsGOBue/IeDyTqSHWNVAUT8frDN/22Hh1uM6pZpSOsuDvt2dsLbB+IvXsrmYpR72MEsQngrUNe8wPhLs193R5uJl0/Q
 9ggKkj9T
 wA53oZzx1ru6SnLEgy7C2qb90/VNdnpxQ7wRVHZHHvUOsis79bQPfiaaabXN1nqQXSrHwcMmgnfW7mbw8MJbXsyPIcFkgCxf9zAu17XqVKsG7J4aURFbq49iPOum0YLZsyPyR6R9h95/e2ehCwO5T6U40OnkG2hC2x6xuDkxxgcg1SBJyF2CHyDPWyhbE8/ntiI20NAvdMeBBQgYXtqzok6vThp+iCgHrLyb9WdlwOFPA9Kef2Q8OmAc/mxEc1r6QNNFY29Ef8uqqfqtQKP9a52sIzbrHus29xUW/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30 2026, Ackerley Tng wrote:

> Tarun Sahu <tarunsahu@google.com> writes:
>
>> Extract 'struct gmem_file', 'struct gmem_inode', and GMEM_I() from
>> virt/kvm/guest_memfd.c into a new internal header virt/kvm/guest_memfd.h.
>> Also split __kvm_gmem_create() to expose a non-static
>> __kvm_gmem_create_file() helper that returns a 'struct file *' instead of
>> an fd.
>>
>
> This is done basically to support a new virt/kvm/guest_memfd_luo.c
> file.

My $0.02 on this: I think it is useful to split out the live update code
into a separate file. It makes for easier reviews, and puts a clear
boundary between core and live update. We have done it for memfd/shmem
for example (see mm/memfd_luo.c) and for other live update series in
flight like PCI or IOMMU.

>
> Would like to know what Sean thinks of this! I'd like to know for future
> guest_memfd work too.
>
>> These internal definitions and helpers allow upcoming guest_memfd Live
>> Update Orchestrator (LUO) preservation code to access guest_memfd
>> internals and reconstruct guest_memfd file instances from preserved state
>> without installing them into a file descriptor table up front.
>>
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
[...]

-- 
Regards,
Pratyush Yadav

