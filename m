Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DFD4C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8765F6B008A; Thu, 10 Sep 2026 10:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 827386B008C; Thu, 10 Sep 2026 10:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73CCA6B0092; Thu, 10 Sep 2026 10:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4888F6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:47:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67227A5057
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:47:04 +0000 (UTC)
X-FDA: 85198129968.20.4B3D9AA
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id A2D5340013
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:47:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="hIK/Bvw1";
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789051622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kKkfTdA2RhAgMUbRVAzf0FG3CakpaY+N8UoEfITRbZc=;
	b=nIMhfe7Bx7lPkl3W/JGlTfZDCm26KsiCRxz0I9Pfm2S27SUDMGVKSAAyo9G0e/F2Fo99ku
	59gyR+SIQV64mlqJCxW/iPdg3EPUIrjjtMGFms/s9V9rpeRoO0cUtVoh7OyUTQ3ZS0kf74
	Ro702Knsd+Z3FzrQ0w5oaC0eyyCA6Zk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="hIK/Bvw1";
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789051622;
	b=Bkape6+Cv/gAnrvvMBUAsmaPpGee8V1UNNLQj7hjwfqvou0QUZ6WHYbq8/Na+mR4aenJ87
	kTM1aYdgvASjxqnroQaqc/CuDQr1V82OjPnoPz71UA4a5DD2c4hz4Ff/YEeM3/9hAkx1Lz
	pM3p9lVPwdEZuPmm76HS58bHQSTlGX4=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-939e50ae02dso23982285a.3
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789051622; x=1789656422; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kKkfTdA2RhAgMUbRVAzf0FG3CakpaY+N8UoEfITRbZc=;
        b=hIK/Bvw1YtrIoIASGt1eSkyLQgeV3hJMIEZc3WLfFWgUqdy/H5Z7vWF3eRRbZeADTf
         rtrz/nPkzAmINu8IclBS0ZsRtyqi/TpB9SlpGjyuGW7PbUzKRM3Z27X91HZrPLzDOzkn
         Ly7pFE7XqZf79OWf5k8S8imgPqec3JvqWHl6K2qvb9+F5VDfZktIGUxDwr/4JFVyadnv
         boYX2kEvg/+O/kGyFHAmXPWSibg2793gM+/wkgS/16jMXZMx5unVIz6+F6yMCg0oOA1w
         c4/HnZBpc2HwQeBY/rQLf6P8r3T7bR4wKsdCN5gHtemBY9bXp2oZXBb9qfrAcSA5gBox
         84xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789051622; x=1789656422;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kKkfTdA2RhAgMUbRVAzf0FG3CakpaY+N8UoEfITRbZc=;
        b=ceoV+yM5vFT9qAU0x8XPyxfVcv9a18Be3zd0XpV36yZyy2N1SdIAC57Xn7j6hOs/D9
         Mb+YbSLhuAvtpG2WB5RhMUgPQDcLVu/IjHDJCLkVcDIiOKw3MD8me2xYPWxOKyu5spVK
         TCcOTnTCDS09T+50kSB+5V4UFW8eMdGdPGS2kIyNnbOt6ugGLFHEpkyB1GKnwoUzKAYg
         TSDT6WkdF6Gz206d7nxj9atRaQFk8xAYOZpayqZhQ9hdJFI8gMkOj/REuIwgOjhgzmwz
         sOdL3If8yru+0NiClr+mRHlPdfM4dkwL+KcGczs81YSTQ0Rdc6MI64bo5oNnf+UrNujf
         tcvg==
X-Gm-Message-State: AFuF++mMtcLvJP7PxAjquDNz2ifJiewkomyjrmqSon5UKqHNs+0J4xhM
	1CkXgSjBfMcpPhRnMk3c2gn4Gb8UNP5OkVKQ+9vtspopPzsgQ+Oq7npE5yHaAHLQA3c=
X-Gm-Gg: AYBFou3L0T0c52WZB76J8rPnrxTpI4j3GIV4V8D9CiEkvnpqCGiMg66fkMEEyxXl3Ep
	VSALn0kMK32H0p6ROZHjfm0Kuu1aK43gtaNzOQCbXG6E381F5mF3uw66+R0G96yEKQX0p+gFR9B
	hNTZoEhvcH+dZyGv3v///aM+VQNiIcG48QUBWrGa+O7GN6Cgqx9j2uUf1REfYEz0Onqp63GbM8Z
	J0AlFdRYihFAvXONk+6mv+0z7yoYwearMt4jHs6dPU0hykGKNzek0fhzrYkPrpeJ13SnZYilTaz
	GXdn3BB7F3gXubGlwr0vjECBJD4Y+c45ZvrRP0I5ISpS8NL+gZ/VroP0Ss+k8fVeCp5x06o+RSt
	si3cLfCYkrpOuSdrC/tOyYB0VmR3Q7EvyoWYgm7UlmxnowjxzVLjAgiSULt7e48kXGTMX6dcW3V
	4jCLQHuowdv+CCgL3JK17QZ160bOg0mH7vEwvSJYisgoD5ifgr//xI7/AydsIhGA+0DtDIR/x7W
	EUNAqiyStmlAYfmBmkm6OmfEbZj37EJDvjeh1jzOstnA07MlrmzsQY=
X-Received: by 2002:a05:620a:46a7:b0:939:744:b5a3 with SMTP id af79cd13be357-939806da02cmr4694331285a.29.1789051621645;
        Thu, 10 Sep 2026 07:47:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e7da5f59sm1310085a.1.2026.09.10.07.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 07:47:01 -0700 (PDT)
Date: Thu, 10 Sep 2026 10:46:59 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	pbonzini@redhat.com, seanjc@google.com, akpm@linux-foundation.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, shuah@kernel.org
Subject: Re: [PATCH 0/5] KVM: guest_memfd: bind backing memory to a NUMA node
Message-ID: <aqK6aj44Tn3bilry@gourry-fedora-PF4VCD3F>
References: <20260902194657.79075-1-gourry@gourry.net>
 <9b67424d-70e5-442b-9ec7-22b1d3db12f4@kernel.org>
 <aqKzIO3DD66Dhkdw@gourry-fedora-PF4VCD3F>
 <6285ebc9-fee5-4f51-9ce6-b840f9dba65a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6285ebc9-fee5-4f51-9ce6-b840f9dba65a@kernel.org>
X-Rspam-User: 
X-Stat-Signature: n5d3f4pte1gxzrjobojbac7di78qzk6e
X-Rspamd-Queue-Id: A2D5340013
X-Rspamd-Server: rspam07
X-HE-Tag: 1789051622-599564
X-HE-Meta: U2FsdGVkX181Y6fPBpciKlhA6jQczfxWDINz/sK8XTu97DZBtVNERc0OJsICLPGWRjbbWXi2aIiZ1/JEap+wqeG4hzUh5vCmcRvJQesnoCtR9N0baJ3o9+TnC8qkNHfHjEbnH2a+21jB2Ckwnt+1dIlfRn0GYz70BoIosAb6GzjWsf9V88e7fiaYRnrpLaw+3iuDKZJaOuG6+ZTevNEcSFpiFTLKjBGnlLQcTSR/yDm/cyS7/9A1Y0c1DEoRMJ7UIQkZHZ5kZl6NTynGkHt210bPtN+5JfzFA2famdGFnBnRlHEo86ing6e1JzJ+JxyCIsTa6BNHlVagSlEnEXmdRNDe/Id1wWwNbf5Zfqcpe6Eh6oMes7A3bAlmoQ0W3ObESpWMvuUMOjKv1Bni98GRUSeq03d9flMk84FrRYMg8kYCut46enW+o9bLsgWJTDmi+k2ahHRiS0X7Xn6Ry/rV5Yl1Cs0arYwYflf0E43bar6JZKBWDsM8Tj7Qrz8QXQwfkpfAClP54w+EKSXYKsP8J4bQW9nqgXyujDY6085y8QBDKY5GD+kel7u3wNLwYgHuIDrpQRni1NpD3htodt2ppzAZOxGrayDtIm1tNZM+ZiFXds7XOvRMqHK00OGvrsjfVn4069GEQpttKj3nd1LhrwULvTqg6BFbJcdubf1dGiRH7R5/PJhK1gaN/Mp6hy0MRNFku89z4TqFOXBcdKs8jzLbOLOOtmnhzmjMbpe3Mo1AYGTNlDbcUu7Me0X/jcTSAXVl3IaAdGJNwlZlwsiYvwdSkR6k5DXJ17NX7rQsJY85C1ldZGHZJk9TEk7NO+c3mRtL5BMnIbpav2AFkD2DKISLgxeewYjM+puPMuoUR8+ZsTgn1KzwX4xAX+dANda0PnJHb32BUdNskqvJ/nAx2w3X3V5UBXnnQijlL9r3HPXdtPWBLbuw7+jQL1QEWd8S4dnW1/dD/ABLZEpCsqi
 p1DCMBcY
 b1JIE8L9NgAVJ3B+pwT8BXwuUCnOBO9JI752l5615XuvqyrntLV7bwsIIUksPBPglqUf7rhMA70NPXmW/YlCE4NeZ+bfkunSVQdwmDk2gSa82c4/oaMxzdd5oj7AWuQ6BpTjxmq2tYo5QL8DzxttIkFkGYnLfDbbbU3r/9OTra0AyHCrhk4xluNU5yj3itwqANpWM1kXLbaV2GY/Qk6gC/x6qSGTXiN7ShzDRgjyPY9n+R34XOKdvrZ37NHL6FIq4/DW7fYNeWLC0fZ7gjluvgxVuyQ3sRTvQagYAsJZRhjAi7KHaL8lQy5w138oguSLUQC1VSVwofY1iSoTo2TPs18vzp0Qy0eoAqhWrvtdR8OnSWqTEGCKez08tiKmEOx248TjcuEmo4QhOBWz2fZ+SNPr5M9hPNyRxjBjT3zGVo2to8Ic9ZZO1JPLwGGWxsj5f2Yvb/TedWR5WXWJc9xmx95idZ9BNZ1OtSakVc+S7OuCe+ft+mia6oBedkWl01TaJpkoLhodIqCDnC9s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 04:05:36PM +0200, David Hildenbrand (Arm) wrote:
> On 9/10/26 15:40, Gregory Price wrote:
> > On Thu, Sep 10, 2026 at 01:30:04PM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/2/26 21:46, Gregory Price wrote:
> >>> guest_memfd allocates its folios through a per-inode shared mempolicy.
> >>>
> >>> Today that policy can only be set after the fact, with mbind() on a host
> >>> mmap of the fd. That requires the fd to be mappable, and it cannot reach
> >>> folios that are only ever guest-faulted. Neither holds for a
> >>> non-mappable (confidential) guest_memfd.
> >>
> >> That looks like an investment into a mechanism we will soon consider legacy, so
> >> I am not convinced this is the right approach?
> >>
> > 
> > Hm, I think i've missed recent work in this space / this context.
> > Any suggested reading here? Don't want to eat too much of your time.
> 
> So the big development happening right now is in-place conversion (having shared
> and private pages managed in guest_memfd):
> 
> https://lore.kernel.org/r/20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com
> 
> 
> The final series where we added mempolicy support should be:
> 
> https://lore.kernel.org/linux-mm/20250827175247.83322-2-shivankg@amd.com/
> 
> (I think you are aware of that, you commented on some)
> 
> See my other reply regarding the use of GUEST_MEMFD_FLAG_MMAP on private-only
> guest_memfd.
> 

Ah yes, i do remember this series.  In fact...

https://lore.kernel.org/linux-mm/aPD-dbl5KWNSHu5R@gourry-fedora-PF4VCD3F/

```
So this inode mempolicy in guest_memfd is really acting more as a the
filesystem-default mempolicy, which you want to survive even if userland
never maps the memory/unmaps the memory.

So the relationship is more like

guest_memfd -> creates fd/inode <- copies task mempolicy (if set)
  vm:  allocates memory via filemap_get_folio_mpol()
  userland mmap(fd):
  	creates new inode<->vma mapping
	vma->mpol = kvm_gmem_get_policy()
	calls to set/get_policy/mbind go through kvm_gmem
```

And quick skim of in-place conversion (wow that's dense) 

```
  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)

  Set attributes for a range of offsets within a guest_memfd to
  KVM_MEMORY_ATTRIBUTE_PRIVATE to limit the specified guest_memfd backed
  memory range for guest use. Even if KVM_CAP_GUEST_MEMFD_MMAP is
  supported, after a successful call to set KVM_MEMORY_ATTRIBUTE_PRIVATE,
  the requested range will not be mappable into host userspace and will
  only be mappable by the guest.
```

I guess the thought here would be something like...

1. create guest memfd
2. mmap(fd)               -> prior to full guest setup
3. mbind(buf)             -> shared policy hits the inode
4. munmap(buf)            -> policy is NOT reaped
5. set ATTRIBUTE_PRIVATE
6. no longer user mappable

That doesn't seem unreasonable

~Gregory

