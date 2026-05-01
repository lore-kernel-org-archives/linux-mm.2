Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44AB6FF8864
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 03:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D1946B0088; Thu, 30 Apr 2026 23:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0832C6B008A; Thu, 30 Apr 2026 23:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB30A6B008C; Thu, 30 Apr 2026 23:32:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D918F6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 23:32:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 394F916036F
	for <linux-mm@kvack.org>; Fri,  1 May 2026 03:32:40 +0000 (UTC)
X-FDA: 84717428880.22.7668A28
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id E1B5FA0007
	for <linux-mm@kvack.org>; Fri,  1 May 2026 03:32:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AjRhNCeV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777606358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AGHQZIIr7JtLFpAcwzlVPtO345HWtqACErkZP29Clnw=;
	b=HNRX2CgY4VvcR+jbRtGPU4uDFS5vz2VtOxXAXeMp+72LVEbIPvtKsy1hj4XfwVVLhOn64W
	e9epUuF+0L6T0gHqfNYWInr0BPh59kR6m2ISN+kQOmUZjJ8G8dUnE5E69Zg9u/9l5O6fof
	SS/V6AKhHawEhqp8rEQUrrjXYnVO+wE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777606358; a=rsa-sha256;
	cv=none;
	b=0fMTUKTy0gEhWCGTE6hJJ0vaoj0pM1fI2oRMq5nmTGKzv9sT3dt63DvdFRa60agDMDUsqD
	BhY2qP4GNM/4VDln3uBc/0+9TRRJFiBV7P/B20kJ56VY2MFWvLdSPpueOxgFd/xP/PFj6p
	T8qKtrWNswfW30nnmIX//7FyOkL/6dQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AjRhNCeV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777606357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AGHQZIIr7JtLFpAcwzlVPtO345HWtqACErkZP29Clnw=;
	b=AjRhNCeVya2hhO3tD9yDwGH52MO5K9TU0y4dsuuug82CTbj8sZsj1cwbHftrLqOmJuoxoh
	uSS2VDqeFD4zxtsup1Z1bidq7kX6a0WWgbihY4tNv/T583KjkRp/RY8sv2AUScyfkOh4dH
	1t4R1tnDmEHFmu35pZfOSr7l/QSYjlo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-440-JLdQnSEhO5WXLV2G9iAbOQ-1; Thu,
 30 Apr 2026 23:32:33 -0400
X-MC-Unique: JLdQnSEhO5WXLV2G9iAbOQ-1
X-Mimecast-MFC-AGG-ID: JLdQnSEhO5WXLV2G9iAbOQ_1777606348
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C9CA1800347;
	Fri,  1 May 2026 03:32:26 +0000 (UTC)
Received: from [10.44.48.3] (unknown [10.44.48.3])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 06CE71955D84;
	Fri,  1 May 2026 03:32:13 +0000 (UTC)
Message-ID: <3ff53353-3842-4a63-80a1-90a60d09fe02@redhat.com>
Date: Fri, 1 May 2026 05:32:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] proposal: KVM: Orphaned VMs: The Caretaker approach for
 Live Update
To: David Woodhouse <dwmw2@infradead.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, kvm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev
Cc: rppt@kernel.org, graf@amazon.com, pratyush@kernel.org, seanjc@google.com,
 maz@kernel.org, oupton@kernel.org, alex.williamson@redhat.com,
 kevin.tian@intel.com, rientjes@google.com, Tycho.Andersen@amd.com,
 anthony.yznaga@oracle.com, baolu.lu@linux.intel.com, david@kernel.org,
 dmatlack@google.com, mheyne@amazon.de, jgowans@amazon.com, jgg@nvidia.com,
 pankaj.gupta.linux@gmail.com, kpraveen.lkml@gmail.com, vipinsh@google.com,
 vannapurve@google.com, corbet@lwn.net, loeser@linux.microsoft.com,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 roman.gushchin@linux.dev, akpm@linux-foundation.org, pjt@google.com
References: <afEwWZksU0Fw61oT@plex>
 <0a71472c-b397-4699-a518-61faffcf4ab2@redhat.com>
 <c004f333ed4f7dedae1383f22d43b009cd83837e.camel@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <c004f333ed4f7dedae1383f22d43b009cd83837e.camel@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: FAd843xo-Z0GU25yG5XfKGrpWHXphxF70DAfFBKNDPs_1777606348
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E1B5FA0007
X-Stat-Signature: 6f8rjm6qs45jc858w87dt6m8o7bffq7m
X-Rspam-User: 
X-HE-Tag: 1777606357-613798
X-HE-Meta: U2FsdGVkX1/JQgcG4gAhFCAGc+2ZsrnEZpWOQ4QLA7TOLAWtZxUmAGwTlCRCmPs9l0ktD6E8KjOYq2ehl7CKVY9OTDE5YQQqUNghBGoM7MXxu7Y6sgZOsV9+fjmRc8cXXr8nBxV/BUsRBpXMXI6FDNKF88uMfD+Ce5vQ1jf+Let2ggvicd7N2xccJYhZNV1KMe3/0Re4jyK539LKYVnJg684KHDklKgpeplI/2bK3w91ZS8wITiUKXhVF8o4qLYJ/swmGJY7iG89j+S2ppufPyb4kuJ1LhZc34jEONfW//cJfBoXXog/8Csn//3QQcKSeJjuAt+KjPFV09AN6UngvV8rDtAYQV4oeoCQJEvFmpbrPi2y4BQyL1OY23urD3WNt8Epttolpo+SpkkMwdaZ00NbrgWFSIhYPndYJR6cjUuGbRhdHZzFwWUmh7M50xecmUBubLjLvJYynAegXqIO9W8ZZK9RWW9lLbPZffjHzcU3AfvY0EvPLGUew3NNlYmPCrrmm4U6wCESK8eRPzMxkoasPbq1JHJvyYck/EXALHJF/KMRPlNmHboa0rvNj8fgR9pzZr4XQELG9lBJlQBky8aVrYNvE3ilbtwioT48HB6u65wCi5iY/Q7eUqNZux9hCIKhTA0sAtp6x7j+t/Hid3wWc9miX05fECkSwhxqIMFFR7Hlr46Uq7f8Rb9YVNyccyLtTbGs4NxfvSwKAuyQCCZJfYr/ccTSrZrCSSyHzLJGQpRosZAGGEOqUGzWCpKqO4uDLOH5+NB45RevcX6G22/VXbaHmxKqLX1FhnfTwwquwzSWJBQsBZTHN03AZDMchcpFGXLsoo8RlXy9HIQ7bQnCpaTmen7aRcM/udBi2a++k5SpVyxmn02oLG0s2ixEBWAKe/Y2yWthPRvXDh9SlDlMTUcKrs1F98IXchke7hHWsTpW7Pl4ILOK1vWZXvn1L040axDBF010jEcTUaR
 zNrvGfvL
 ov6MUU7fUb09qO/8lPsfbX0L9/kozEa1YQtEcEgsGIBLIIsCJg/AClFmtMiAC8YD+atWFZbLLnnN8/cyK0wpcEhy/UM444p48BkPuFHPkDVTHz0rBR+69Yqqnsk2IokRHoeDTclUs5pzcvsdRF9JrXFx86f5ja8sX2YyuKzU55/sT6Q38SRTbsNZqTyPYTE+lw89jyAut2zpw3pT/N3PgCo6raMYohvpthvwknQcpxXH1AltY0CCF9oTqmil3DixHiTKjuU47+X6d0a0EwSo52ARoHYBMmWDCjJLrO3OHi2DxMX0Yy2JtxM/h9hkR3yy51Aps76xgMD8xpOXfSz+dtiyQElkahsOtWQZDhuvfX/1QY7/NHRCjbPXVKRkuTSDqr0svL8+LE7L29drnIJWCVPnA+TADxb4N9uZ9XxfugjktNCE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/30/26 17:27, David Woodhouse wrote:
> On Thu, 2026-04-30 at 15:28 +0200, Paolo Bonzini wrote:
>> I even wonder if, for long term simplicity, the interface for
>> host->caretaker should be just for the caretaker to swallow the host
>> into non-root mode, again as in Arm nVHE.
> 
> There's a lot of merit in that approach.
> 
> I talked about wanting to use this 'caretaker' for secret hiding.  But
> why have *voluntary* secret hiding with the kernel hiding things from
> its own address space, when you have have *mandatory* secret hiding
> with something running in EL2, like pKVM.

Well, other than because it's a lot of work? :)

> Honestly, I don't see the *caretaker* being much of an ABI at all,
> except from one kernel to the next.

I agree.

> The *userspace* ABI considerations are all about how you make a vCPU
> that runs asynchronously (should it conceptually just be an async
> KVM_RUN call, which allows the vCPU to run in a kernel thread up to the
> point of kexec? Why is it fundamentally tied to kexec at all?).

It's not tied to kexec.  kexec is just forcing a handoff + forcing an 
update.

The big difference is that:

1) if you don't tie it to kexec, a detached vCPU thread is a struct 
vhost_task and a blocking vmexit schedules out the thread; while during 
kexec you have s/kthread/pCPU/ and halting the CPU instead of scheduling 
it out.

2) if you don't tie it to kexec, address space isolation is the only 
real reason for the complication of treating the caretaker as a separate 
bare metal program.  OTOH maybe that's a feature - you could do:

- ioctl(KVM_RUN_ASYNC)

- then vmfd/vcpufd handoff to a new mm on top

- then address space isolation on top

- then kexec (de)serialization on top

> I'd love to start without kexec in the picture at all. Just show me the
> KVM API for starting a *confidential* guest (pKVM, SEV-SNP, whatever),
> leaving it running, completely stopping the VMM and then starting a new
> VMM to pick up from where it left off.

Why confidential?

Paolo


