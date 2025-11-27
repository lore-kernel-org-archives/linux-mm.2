Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35C31D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E45E6B0023; Thu, 27 Nov 2025 09:11:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC386B002F; Thu, 27 Nov 2025 09:11:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1346B0030; Thu, 27 Nov 2025 09:11:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6C29E6B0023
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:11:05 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C3F01A015C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:11:05 +0000 (UTC)
X-FDA: 84156573690.05.48EA9F3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id B2E4E80002
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:11:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K9NUfQJz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764252663; a=rsa-sha256;
	cv=none;
	b=45aYK6soWgeBtSS6GQTpH6LQRsKQyZSpEVEMr4GFU0vhAUIINvwR3WiibbRLKP8jygkpKT
	mcxO5Es6lqx6cybCjY75pdRQg69ZSIN3DqtWtd1PJQO3lTXUxKbBsiWeANveUhvDsvGT6H
	Msg30d2a20HaJe2k96ZXYGfLt/vTwPI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K9NUfQJz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XR64ry2ScNCGM4bs1WMW5J43Vq5AKcKTg9WAzYYBca8=;
	b=E/+JqbhFG11Ws6RdgLQ1MJCnYbP84+5Vpi+uJfEvApOLep0ygVP+74jg2TyKdoycTqyDER
	GMxfirpB2RJV2SELEKZ9ag4f/qZ1WVn3XDyUwNiYbpHMH9gueqjqcExxVNyyv1Pk7jvkro
	0YqGR1EqHaxCytEd/X7gqkAr8eSDTJ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764252662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XR64ry2ScNCGM4bs1WMW5J43Vq5AKcKTg9WAzYYBca8=;
	b=K9NUfQJzBGLkhVJ5AvexvTFrzetrp8x8cchsqX/8/M/zgeqjDNTuppIzUu/EB3WyHHj2ZM
	jUKLwPRLCCdxPcSbinK5HwurrwWfAFBIiHsVJgWhy++YZDl4h508dasEMe6AKcHYBoMlz8
	fAy4jCg54cuYn7+dFWxPVKgJFZv2o+c=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-FR8teb-_PLy56XuFnYqJ1g-1; Thu, 27 Nov 2025 09:11:00 -0500
X-MC-Unique: FR8teb-_PLy56XuFnYqJ1g-1
X-Mimecast-MFC-AGG-ID: FR8teb-_PLy56XuFnYqJ1g_1764252660
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-882380bead6so20249506d6.0
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:11:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764252660; x=1764857460;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XR64ry2ScNCGM4bs1WMW5J43Vq5AKcKTg9WAzYYBca8=;
        b=B9cUruYX+s9LGUYEI4fXAEx8goyF9s/onH+8dWQDEx/2ERTYypkNF8ht9DfxLlHE7k
         Gf2XhBhcgyYp3sUeAAV6j2hSrb2qaBqohIB3xI1dIXkDMeZDwIeCRhXNR7JHH5oQEsLi
         und8sk25Wn5tmWbQXcJE/3+SvM65BCT6kxPFFzmZ5fgO2Um+8k+inf7UE0+NgJZuvUCB
         DRVX6u/rRCO+ER4zerhKLLMGlm4B62maXwDI7PFnbgZeAGl+vnDjSNd6VILyyaWEyLk4
         Jq1kaMywtsMBFKrmMT750kcrfv4Qbu45uy5ugVWbScgjtSwwN+499UgmVJE8IR0203e2
         vvKg==
X-Gm-Message-State: AOJu0Yz1S79OX81vi50zgbcvsD+lRCOUbrXcD/iUKyLB6E0CbiAb4rXj
	9BlV1SzXHKHAOBLZogDo4d/IOpDyI6bulAQeIoD2eaFONbj1Gv4g6v9rne7BO4E1p3+2vN3jRQS
	VE07M+G+mbr3xTsA3mqKAsJoWQbKbO0Iv5GhoRLAESMnBWR7KrncM
X-Gm-Gg: ASbGncvh+V34+OUel5LKOQa25EMBUUL7SZmY3vpWBVPe/PTG7vHpl1HWtkMywRXDEuv
	CXrmKlslmmrPpZdpFbc4iWsVfNEj7T81yWGrfLOcKrVXwoIxokAPxLywW+K4A+iNbw+8gBucveN
	rmPHfm+hUv/6kwTx0Ft2xe8IpzczezGsHBCa7v0Vhj3wTtO1jToSg/zEHrItEDTyCfCawANhwrF
	Kk9Pfh1xr4mYHqqmoGMhOe7UjmZsy+F/wK0qtDTy1OJlk8rB1DJla8+/P2ljfySr03EzMTprDnq
	SwTd+B7342VbE4jhnQhLAx4/hHLmziYBCcJC+EYRutoeS2E4+JuUFqyGTOnVAIeLaIizHRvNBiE
	oee8=
X-Received: by 2002:a05:6214:5b0a:b0:87b:f43b:89bf with SMTP id 6a1803df08f44-8863aff433bmr130936876d6.65.1764252660235;
        Thu, 27 Nov 2025 06:11:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHVVojIJxBSUg6Ma99iaPFcSP2N+G6I7KWSD+e0Pql+38krJCo4yqt0i+13ziPHCggkJGRQFQ==
X-Received: by 2002:a05:6214:5b0a:b0:87b:f43b:89bf with SMTP id 6a1803df08f44-8863aff433bmr130936256d6.65.1764252659699;
        Thu, 27 Nov 2025 06:10:59 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b8fcb2sm9879206d6.52.2025.11.27.06.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 06:10:59 -0800 (PST)
Date: Thu, 27 Nov 2025 09:10:56 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: [PATCH v2 3/5] mm: introduce VM_FAULT_UFFD_MINOR fault reason
Message-ID: <aShb8J18BaRrsA-u@x1.local>
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-4-rppt@kernel.org>
 <aSYBrH_xfMfs6yDW@x1.local>
 <aSgzcpFP1qBda5ef@kernel.org>
MIME-Version: 1.0
In-Reply-To: <aSgzcpFP1qBda5ef@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hQjgi2V12DeBTfuF8KVuiFFHGHTW5mrxbfNl_uaH51E_1764252660
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B2E4E80002
X-Stat-Signature: jwfbsainkgg4k5k51bizsnuih7pc4d57
X-Rspam-User: 
X-HE-Tag: 1764252662-138757
X-HE-Meta: U2FsdGVkX1/r44hCz+vZwiMB3JodeDjo11CnbWRbINoZom4GYWwRab3GlObRD2sRbMqEh6xdyFk2cZ9+pICvNUX7CHLnp9C6MGpXp2f3gtjIpFsIHK4fk6V5T2gzusV3jy5qTvm+avXOk8B4PZktP7/l1Heq2YQXFLLvDg6+abjzO3bJ7qmoPbBB06YqHHe6EX8FxJ3Pikj/I+X6T1UWjO7YaiADPS2mLdGZbGnX/FeEkJZ0axmT83QMBiez0DMg+zDUNFMZVlZYxYI99LJCza76bxC/FGBHkB00V7qY43hrDcTpJEncDLypDBC2HgaEdx+Q92H1YWWZLuVl3wcno+kRUas0p3NtzE0tmn6hZEClJpniPgdM5IFfITmCpkEcGWCC81BPeiQoBnGLl38IKxGoL+hUo+Hzg5fHv8l9a4B7mFT6F1iPOOU7VmLGLDYTsgs2OxG+sdoF+zjqH89Dj+ajV3QnzS4Y560NaToaFoDg05dBb53EUufVpIGReAx/MONM9GCg4PNZ2o8sNaOAnrMz2bfqr0+FlRSrKsNwLMBRFTRBmeb99CITqUN/f8diDa8yLleAlHnOfVRXkJe2v6XyT0snXSIZj4kK323n85gUPYE75WgKEPd9/orETYyY14A5SMTEm7ECPnjdRdU31lRPo+fz9s2mw4p8GNurHsBbbv1UoQ97Lkaxn7RS1qM34BYUC9pKCB5VeFgHwt+FcJUyqV2zJcBAcNnNRuFL2xKJ81voBoCDUj40c+vBzKuTPAcwP3y/DUg7CvwBCY2yYNce05Ws452nQ2Gh4ODuipP6W/OJHL+dGytaXq+0uIJZfOzM2jIG7hpGl8N/h5FRo+kvPh66N2eWhbKpzvOAS4sxxzygIJrhZXWiIzimaDxlIDPbrXchbh2L1sOHcNkCi41Y2Vrjp1t9iZMlqitPf+kKncgkCTWxx1pnxwdOXhiz5sZ1ekMjiBf5plfGHA8
 bjpfRJZ/
 RPKWJJ8Vk+wngZWelepQiRdLmn4uK2T7YRLXYCxlCls2WHEJYdEE3rbejWvHJtfEITLd4AcPHq/EB5K9JNqFTb7yVkIF/okKVZpphABAXscQDGcYkNFxMWNvtgax06ongOUrtm8+YTkZPTmoQxjF3qZt1nlqMUsMdloMJ6Z9Nz1tLz2rfac9mkXGSnSoxS80PBOzVLpWSHQbFofFfUDGyAuOZ004WvIx4khBqkUQCO6CiHPxCluXAuwnp+i/plJK2xOiwX0jQxPITevBdNLfnXhPiv9q8PvZRdTLrf1Os2m5iVdv905VCsEXdAaUjqBq98lBh8qVj6JZuvki4Oe/FQZC28yTcu4Mwf1VqcHENB/90skLq0mig8JvQAQJzNeS+KPW/4LW2WejB3MKH7xsOdmwAA+oRe80UfYBFme1m1PFvH2D94y+eVsgeoOhp90CzwZGlExOteXi8llgVzSSp9HOxPMeyfX793Ka06P6IR+mCEt9UEHrWEkhZt6FMVyw2j2NrqC2xhy4zYekO0jaIFdMtPG5DaPmVrnmU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 01:18:10PM +0200, Mike Rapoport wrote:
> On Tue, Nov 25, 2025 at 02:21:16PM -0500, Peter Xu wrote:
> > Hi, Mike,
> > 
> > On Tue, Nov 25, 2025 at 08:38:38PM +0200, Mike Rapoport wrote:
> > > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > > 
> > > When a VMA is registered with userfaulfd in minor mode, its ->fault()
> > > method should check if a folio exists in the page cache and if yes
> > > ->fault() should call handle_userfault(VM_UFFD_MISSING).
> > 
> > s/MISSING/MINOR/
> 
> Thanks, fixed. 
> 
> > > new VM_FAULT_UFFD_MINOR there instead.
> > 
> > Personally I'd keep the fault path as simple as possible, because that's
> > the more frequently used path (rather than when userfaultfd is armed). I
> > also see it slightly a pity that even with flags introduced, it only solves
> > the MINOR problem, not MISSING.
> 
> With David's suggestion the likely path remains unchanged.

It is not about the likely, it's about introducing flags into core path
that makes the core path harder to follow, when it's not strictly required.

Meanwhile, personally I'm also not sure if we should have "unlikely" here..
My gut feeling is in reality we will only have two major use cases:

  (a) when userfaultfd minor isn't in the picture

  (b) when userfaultfd minor registered and actively being used (e.g. in a
      postcopy process)

Then without likely, IIUC the hardware should optimize path selected hence
both a+b performs almost equally well.

My guessing is after adding unlikely, (a) works well, but (b) works badly.
We may need to measure it, IIUC it's part of the reason why we sometimes do
not encourage "likely/unlikely".  But that's only my guess, some numbers
would be more helpful.

One thing we can try is if we add "unlikely" then compare a sequential
MINOR fault trapping on shmem and measure the time it takes, we need to
better make sure we don't regress perf there.  I wonder if James / Axel
would care about it - QEMU doesn't yet support minor, but will soon, and we
will also prefer better perf since the start.

> 
> As for MISSING, let's take it baby steps. We have enough space in
> vm_fault_reason for UFFD_MISSING if we'd want to pull handle_userfault()
> from shmem and hugetlb.

Yep.

>  
> > If it's me, I'd simply export handle_userfault()..  I confess I still don't
> > know why exporting it is a problem, but maybe I missed something.
> 
> It's not only about export, it's also about not requiring ->fault()
> methods for pte-mapped memory call handle_userfault().

I also don't see it a problem.. as what shmem used to do.  Maybe it's a
personal preference?  If so, I don't have a strong opinion.

Just to mention, if we want, I think we have at least one more option to do
the same thing, but without even introducing a new flag to ->fault()
retval.

That is, when we have get_folio() around, we can essentially do two faults
in sequence, one lighter then the real one, only for minor vmas, something
like (I didn't think deeper, so only a rough idea shown):

__do_fault():
  if (uffd_minor(vma)) {
    ...
    folio = vma->get_folio(...);
    if (folio)
       return handle_userfault(vmf, VM_UFFD_MINOR);
    // fallthrough, which imply a cache miss
  }
  ret = vma->vm_ops->fault(vmf);
  ...

The risk of above is also perf-wise, but it's another angle where it might
slow down page cache miss case where MINOR is registered only (hence, when
cache missing we'll need to call both get_folio() and fault() now).
However that's likely a less critical case than the unlikely, and I'm also
guessing due to the shared code of get_folio() / fault(), codes will be
preheated and it may not be measureable even if we write it like that.

Then maybe we can avoid this new flag completely but also achieve the same
goal.

Thanks,

-- 
Peter Xu


