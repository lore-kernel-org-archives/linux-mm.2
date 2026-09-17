Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F5CC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 19:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CDF86B0092; Thu, 17 Sep 2026 15:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5850E6B0095; Thu, 17 Sep 2026 15:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441F56B0092; Thu, 17 Sep 2026 15:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 100696B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:30:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3FEDAC045E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:30:04 +0000 (UTC)
X-FDA: 85224244728.15.322E4EE
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8A317100003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:30:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HY63KutN;
	spf=pass (imf14.hostedemail.com: domain of 3uD-sagYKCEUzlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3uD-sagYKCEUzlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789673402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1mrjzrdKauTI1kt3ea3M47lmxrEOAZpZ0W0oj81G6CQ=;
	b=QeEqkkhFrj+xHR7ssNsW2hA6bCBQImXI56t0K2+axZ9i/2PhtOaORcsEDk2AbOLGMHK/WC
	UGBI6Agbw2JFj+xRoOdFFZfR2NDmwAU3cncaQ105IatETGl9q5b39H4IftKdA1vhrWoPAH
	g/LRd+D4jraEoNHadSVAlWEKb6GZ60M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HY63KutN;
	spf=pass (imf14.hostedemail.com: domain of 3uD-sagYKCEUzlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3uD-sagYKCEUzlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789673402;
	b=n/Fg9+ZJ9ur4oXWvFid2RZ5/LHnX+v7pBxPebDMad9zCjd+mn/rJAKTf1T8nFlBlKuvb/m
	L+b1j34zOd7roghnDcRgtzmEoZAn80jrv/AR6oTEvz53xS+mn02CPb0cMIru48eZez/YDz
	R4ztABEuxARCcBzNW9sbaMyy2Bq5Rhs=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-398d0010cfaso41489a91.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789673401; x=1790278201; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1mrjzrdKauTI1kt3ea3M47lmxrEOAZpZ0W0oj81G6CQ=;
        b=HY63KutNFX+hpa4PEvpqcSLoyj4b7cd1wMuJOmdTE7gAwihdNOGc/+iXV2d8XS9hva
         yA7bjJ+tE/vmelQjvTjqjH0ZHZW0gHN3Iib7SyH2iJmMeIqEgSkbM3juH/m+MtiKT5b5
         qT2PgSai4GktWLJ5bT+YCrHLIDtACu3NDRJ/VVcEHtJy6DDKZQO9GyHFWOIfEe2CVU0a
         M43G4nkNj0kT7PIX1CS0BrAiJZI2T4KUKGIn98+h0sGACc6JVC7cQm5OKuEfbauRCALd
         xZwW6jl51+kzq6MAll7QZLETFqSP1SWXhwz00e/lwYXCbw9wrCQhFSlaSYzp243dsy05
         JnRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789673401; x=1790278201;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1mrjzrdKauTI1kt3ea3M47lmxrEOAZpZ0W0oj81G6CQ=;
        b=povpZQ/8va4rg4UFAm4e5m88qjbMRNVCbWhZM3C740UutpSGPGQXMgFs9Qslx2wboN
         b2IVeV3Ivm3paD0wautm9hp/azU37jX4VXcSeK3fyVUjW0zQX8KNGcF5vZgMqV2TAIhx
         Sk+L+oKNKZlNFPFgAPBt334acFhfS+msdLP1dvudR4qeFQwel9JyJvGHhdvuM+txL55O
         qkgfKvPVoAjmQstiB0qdDlv9K+Qrt6Li7L77a2biiZ8+eMbuTctoPJIHsWQHcfF8+SNY
         n2JYNA5M58KGTXH5rT4VjUhLt4jiT7TRq//jw3CHPu+caLjKpxcW2TNr+5fq2wXtz39S
         xe4A==
X-Forwarded-Encrypted: i=1; AKwUvBzLFPg3blbRucy7sxkwlxpB5gt1Zz18clos6ecdZQCPohLqxNAl+9fYMt7fy4EUQZokwCRck6rT2g==@kvack.org
X-Gm-Message-State: AFuF++lx1Bbet2K5NvQWYcPwnhkVY1KQxStsilCl60SD7HrJuv0zspt9
	zvY/Y0K22OXky2AoJPWbvVC+uDIjxgUqE9P6GM0Kib7kbBBk4q9oPYPTi49byJZ1cW8i/ed8kZ4
	DjIVG6w==
X-Received: from pjwo24.prod.google.com ([2002:a17:90a:d258:b0:39d:93fb:c298])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b82:b0:39d:f06f:79be
 with SMTP id 98e67ed59e1d1-39e5502546cmr549736a91.15.1789673400989; Thu, 17
 Sep 2026 12:30:00 -0700 (PDT)
Date: Thu, 17 Sep 2026 12:30:00 -0700
In-Reply-To: <CAEvNRgGW_VHmT82q+bUqHh_5G2Z9sUF1jJOTiVN4Z8_cA9A50g@mail.gmail.com>
Mime-Version: 1.0
References: <b91dbfae-20f1-4b9f-a25b-4397afae80f9@kernel.org>
 <16ffff40-4ef0-4312-a700-348603f05c0c@kernel.org> <CAEvNRgGW_VHmT82q+bUqHh_5G2Z9sUF1jJOTiVN4Z8_cA9A50g@mail.gmail.com>
Message-ID: <aqw_uBIYig_uo5Eq@google.com>
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2026-09-17
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	KVM <kvm@vger.kernel.org>, amit@infradead.org, aneeshkumar.kizhakeveetil@arm.com, 
	ashish.kalra@amd.com, dwmw2@infradead.org, eberman@quicinc.com, 
	fvdl@google.com, gshan@redhat.com, jackmanb@google.com, jackyli@google.com, 
	jthoughton@google.com, kalyazin@amazon.com, kas@kernel.org, 
	kevinloughlin@google.com, liruxin@google.com, michael.day@amd.com, 
	michael.roth@amd.com, mike.rapoport@gmail.com, mvaralar@redhat.com, 
	pankaj.gupta@amd.com, papaluri@amd.com, patrick.roy@linux.dev, 
	Peter Xu <peterx@redhat.com>, pheragu@quicinc.com, pkondeti@qti.qualcomm.com, 
	prty@google.com, psalian@google.com, qinkun@google.com, shan.gavin@gmail.com, 
	shivankg@amd.com, sidtelang@google.com, suzuki.poulose@arm.com, 
	tabba@google.com, tatashin@google.com, vannapurve@google.com, vbabka@suse.com, 
	wyihan@google.com
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Stat-Signature: x1ccrwn1ssjqc5zjcndpacfymp3uo559
X-Rspamd-Queue-Id: 8A317100003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789673402-689677
X-HE-Meta: U2FsdGVkX1+g9mHeBCi3xhdbpqzGLXxRy7J2ChmOmnLJSExrmJk3SIMVeLs95PaHMg9TjMRmQh3wK/fg31m2ZCn/dREdPSYiu5GPrUMjFPY70bLwsuOC9me27BGP07gPRT08fKNPXs80ntwsn6/goU0KIJIJbsiAmtxxRXNe1+DXtGSWaQQ6hUek8fryl1LnB+62pak3TMUdUS8xFP0XHGiKbTTr9vYDJBsJDU9YjMhzTX/d36EoaJ8roZRFXJ/VAhOYoZx0dGlqLauXVzaZiJuHA60MFYvgASOWVXrSC0B1+WW670Px2VHoJ0QgOCirCZIC/ChL9IEFoj9kOfSg6FeB001gebrGJTbYVx4puCSiDrsX++6DRMLDRdOAoJDYQIErNt7KKOxUyEsKiOxK7IQx/KrVhhDHAHmjQjaVW4TgozqXNoRylBsF+5zIyzEICmeKK5bFueBvotpz++gnyxlKsyvaOv3cVWhhCFTr5Af9ZRakZPsKixGelLXb2tnUaPr+Jd/kp2DEzTAm+JNpWIRu37B2xJY221Pli7C0U2fIQvtvBg86dQHu6Ki0HsJgqUU4+fdHpOy3GOlPpksVSDUkjOVcicXbCOu+SSj0CbftxQUHfEB27cjGcggMgaB36bpXQG63oKmq4R6vKL3lsPLfYpCnZYppSfLLrWrpGwToL6+/xNgZy7BtG5atlMkDpVecgk1NwfvI7K4yYiWQt2xmowD+DffbzcUofE7spJlDCopCuq1kkfG7i7dyoIJ2ohG1NVLBtUM0HQ85V08b6DjpR8I29wVA7lhVoJcqkxp/zqb6z3U8rFnANiCKK54U6/06g+K8TEn7YnTx3aAUrIT6LD9UG90gLGJLdinreYKb35BiDHysHmGxe6KQfzac8BKP2p/65CjB1tmye3LN4mDOsWnxz2JBShfYkpm9N5PkQcytOOtZ0lQbckhQHacs4lgdrblJEMLLXuXTHo4
 FRbxuhBR
 0VWbuVWzrOVLxlelx4msEO5czu4dY9/wYtroD50wt1823cpJ/3CCTeqYOpD0RsMPm71Jybb3avx05SQsmMaajvFAWBUERo8rPMXhwqUaiFeGERwFGS28h084NoAoA2gRWDFnanzKHgONcoZf/YabhIeG4p30PAx2friKjzfVSWnEICzq9dzJ0t0pZn8bpuwqcuF/XuBx5tcxJT4OJFM26ysfx36AOXARv2gNeUgTVVJeZAj8LOR8+qbbk0h+fliryq3jDTFlyMmPJpuHmr+jmQC+nE1/o5dU47qx9VSaOhmI4Ibrm1UgUQdb0numaaCI5KSrn3Qlyk2WMxeogujZ1nELxq2S9n6yeYvx2mU12vb2pCaxjE68iMS18CnCppzzlefXd9R+r2etAbrVPormY0WkzZObb2iKzOmO+vybL04iFsrFHtjITl++3t3Yg0rIwbw4m5Wwc30ruRd/QVpr6iR5Sk6TDSUWlYHbdGhTPqyVYC4SU0YlQQtteurO/+w5oGmRMTa/ludCKDawO67q+BKjmomndzqGJ5IIEWkhFXtqchERtEUIHQnI5Oe7F1xAiGtbDuL+4zx1QpptRlpxqw7G4aAPWXv+bb+ty0sExv/Q17kPT9UaQqu1CpOloxZ4XqYbJ+qwEFyJV7SxR5CfZzSh+MkMBD7qHgKWUHxfYge1ZcGFSrVqK8y3ELsLGOBOi0n7FezTeSRLA4KrjSfAfqvXoA9lAGgBwPdGJpdg46vfcjySNNUJJW5GVmcqV2R52J8yP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026, Ackerley Tng wrote:
> At the call Sean suggested mirroring the RMM's tracking in KVM, but that
> sounds quite arch-specific and it's like doing arch-specific validation
> within KVM.

I suggested "mirroring" the tracking in KVM arm64, not in guest_memfd.

E.g. put a structure in arm64's kvm_vcpu_arch with a list_head object, then insert
into a per-VM list store in kvm_arch on a conversion request.  But before inserting,
walk the list to see if there are conflicting requests, and if so, reject the new
request.

Then on KVM_RUN, if a vCPU has an outstanding request, verify the gmem page exists,
is in the correct state, and is mapped into the guest (or at least, is known to the
RMM?).  If any steps fail, exit to userspace with -EFAULT + KVM_EXIT_MEMORY_FAULT.

The downside to such a simplistic implementation is that it'll require a per-VM
lock to serialize the requests.  If the contention ends up being too painful, e.g.
because there are usage patterns where guests due batched conversions across many
vCPUs, then KVM could use a more sophisticated approach as needed.  E.g. shard the
tracking+locking at 1GiB or something?

> p.s. Fuad, for pKVM you also mentioned that you'll need to check if the
> guest had requested for conversion first? This might be the same/similar
> problem.

