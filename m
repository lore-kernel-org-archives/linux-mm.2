Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 296AED116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 20:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82A796B0089; Mon,  1 Dec 2025 15:58:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DAC36B008A; Mon,  1 Dec 2025 15:58:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2696B00A8; Mon,  1 Dec 2025 15:58:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 541D56B0089
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 15:58:06 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0274713AB08
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:58:03 +0000 (UTC)
X-FDA: 84172114488.07.2076D4B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8D6BE40005
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:58:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bjFIIVG2;
	spf=pass (imf01.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764622681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cn3VhpmwVa+pbYhgAkE98mZ/JbvIwEHKcTRbeRu2cf4=;
	b=1A16aVIVQbT8+lg07cYbTKSbF2yn5CgR1h59TKctcWt69bXN90osNGPXFWk9gof+6ign6J
	1chxTYjz7qGD1rvagDoqj/g1LTSFxW4ykM+OlSjuMPtKeWXN8cd9/DQ6r84mpQWF8K996/
	LV9KscivaN/QQRu9epQ0YtncLfvKH+g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bjFIIVG2;
	spf=pass (imf01.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764622681; a=rsa-sha256;
	cv=none;
	b=cZsflemW88QDbXR3rN90UstRMq+AetQq1IXMRXqpnldKkBiJrSyeMnb4yMxWHkjhP02ScN
	d73QBX4n5k8hFWALbbgBie1pRQoAx1IEYFPyTtPhMyI1dfzUpRPoA/9SyqcZu+EQiDBs64
	p0+NVLoQmHzEKDiaHMX/I/MDnqjrNFw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764622680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Cn3VhpmwVa+pbYhgAkE98mZ/JbvIwEHKcTRbeRu2cf4=;
	b=bjFIIVG2ZrsDWhxkydWlSpMmSfGaA/FpmhY9VlHW+jZmuOzSKLSJX+HRyZT9Pbd4g7aHEe
	juJH4S91dZrBi+7gLYUEE7UcjNm1tdl+JZ2CPzDellAjqb5huUSuPJKBg1C53bkLsUF4Ro
	2bDBeZdzm8mvyYUy4kIWQQLSH+/a4l4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-494-ZvOXz0-ZMN-JHR9U0QAJmA-1; Mon, 01 Dec 2025 15:57:59 -0500
X-MC-Unique: ZvOXz0-ZMN-JHR9U0QAJmA-1
X-Mimecast-MFC-AGG-ID: ZvOXz0-ZMN-JHR9U0QAJmA_1764622679
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4ee09693109so80587191cf.3
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 12:57:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764622679; x=1765227479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cn3VhpmwVa+pbYhgAkE98mZ/JbvIwEHKcTRbeRu2cf4=;
        b=M9ZBD9mQJNd8To8QnASCSYH3ry7oHgrynv105bpgIVB1RxLpAj6wH3/cL0As/froP+
         abdKphee59tIULbVAqE9wUc4qXOjScwWjP5JiIjlu2UFPXS4+512ovz80Ua/r1C9oK8m
         QBGKOxnIBXzvzbF5HAt/YIwawgq1/DYiUlf4tUYYpKGL3xKHiQxIzqLD+wBVZCVyS04h
         FMoY71O/dlx1v0I4Cm5tzVMXfC8/U2MW89mk43K9tzN4pLmcZdxMHfjKojuEuo6xUcIv
         JGI6/sEGIHQSxqQ7Y7d0XLP14MgXnuusc+e3aE8jU0pp45pSEpPMe/5GhSuDuhlX0K4h
         eTuw==
X-Forwarded-Encrypted: i=1; AJvYcCVwE2+LNnGfwgJzonpuJMUL44o9UJfCVho8npwmMNFXulndn+9scMIObZSwyn5OKnxWbIX8XNotpA==@kvack.org
X-Gm-Message-State: AOJu0Yy4p6+SXBvbUlFn1Jfw36LBMxzGf662ekzNQabHh7MgWbIL7XWY
	6B2Yy7+2ztqG+zDFpM5XkySdv3YFh7TUZaahM8tm3yWyvV7koRHG1hcIInlZNsbPUHRqOMyM3Ic
	kgLeRqEdkR7jmmRSp9ScLMGrzITbrnwMKL5ACEticbtEviWWGSV0q
X-Gm-Gg: ASbGncsm2IumTlsWu5XKeumbi+EHCho9PzaubRLhYbOAtGRTlXoAj6LRvdwtPuQWck7
	frLV77blcrJH8glhvoNeBrkQW0aAszmfBzY59keR5/5wPBRxHyoM2bvqaTq1iRcavKbvEuyWNqI
	EuCOu6Gp/9pN+mweS11zy7j7svaZ1q1qSqxvUMaU1C4dLdGJzazhfKQi3QX+Vj8OAjNgYQrIzK2
	tc2THTIUtUAgRxvmJ1GWNWkMRrlpGHmxqxqkYEZb1czuAkXQjJ1MTJ4Zii7AIpI1RjAHxyO3M5T
	52GWFbMqR8eJDyY5Fo8qHkOgVNGCH1uOzSFpRFRTQ3GlcW3ZEtwmB3318maI1E/9TvAebZLPCUS
	+5n8=
X-Received: by 2002:a05:622a:88:b0:4ec:a568:7b1c with SMTP id d75a77b69052e-4efbda33ba1mr388432421cf.21.1764622678836;
        Mon, 01 Dec 2025 12:57:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHWk8T36NyEMOMD2WZTIhi05/ouYbVdGm/+oj1BADCz5jW4gqg2t7CwJF5ZBQ/vmsijc1KTvQ==
X-Received: by 2002:a05:622a:88:b0:4ec:a568:7b1c with SMTP id d75a77b69052e-4efbda33ba1mr388431931cf.21.1764622678340;
        Mon, 01 Dec 2025 12:57:58 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4efd2fbb8d1sm82384891cf.9.2025.12.01.12.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 12:57:57 -0800 (PST)
Date: Mon, 1 Dec 2025 15:57:56 -0500
From: Peter Xu <peterx@redhat.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 4/5] guest_memfd: add support for userfaultfd minor
 mode
Message-ID: <aS4BVC42JiUT51rS@x1.local>
References: <20251130111812.699259-1-rppt@kernel.org>
 <20251130111812.699259-5-rppt@kernel.org>
 <652578cc-eeff-4996-8c80-e26682a57e6d@amazon.com>
 <2d98c597-0789-4251-843d-bfe36de25bd2@kernel.org>
 <553c64e8-d224-4764-9057-84289257cac9@amazon.com>
 <aS3f_PlxWLb-6NmR@x1.local>
 <76e3d5bf-df73-4293-84f6-0d6ddabd0fd7@amazon.com>
MIME-Version: 1.0
In-Reply-To: <76e3d5bf-df73-4293-84f6-0d6ddabd0fd7@amazon.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3NpzuOd6DKHPzKeuFFPNWfljMgNhasIgj1d8KK-E1-I_1764622679
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8D6BE40005
X-Stat-Signature: is588qwb8fjgqud6j3qguun14uxeg7c5
X-Rspam-User: 
X-HE-Tag: 1764622681-349092
X-HE-Meta: U2FsdGVkX1+H2yp/xlv7ROxEe+3zi86VkuHQW1Vy+xI15drfIv1eJiGg7cWDtmLgOk5sIk54hEKsIb7ZH9HVTeZO9pRzZmTFd5NlEtRomGoyhs6qL2XPtSzbw6JkDeoc1u9z49dvQNHX7gI6uWfSy1Cp1S/IkwcFS+GU5Dek5bbwIStWEAnad2/SJon7U5G3hb2jupLAWpsFAvtzO1gCuJCDmZ16469zF2kUkvXqJ5USg7eRupT6THWu69HHsp6gsrZcWBLSktvevoazAPPHNxOLqcd1YKilFEy4v9s/2THVqiu5iC5R8xXavPFMeuJ3/rUNuL8H5MDi8AQcO14SfAWkU7l5ALQT/iF3y+XjvOAVuk37sPnYER7EJyk0b+qbKsDOIV+9kHLUk8W6WhH1yiCIYbkPCYp6f+rFqL3g0rD9VBr25BtOvEMl8P2W66yyB+058JutCxL1F8B8pMl6TcOc096BCdkTFNiA33JFVVTiyc6hrIAkHu3zC0x7TFzL3hAbC+lU2knt0iX83dr1l4cqMvZmLIqL6LdNzyIdH8wyO0yjt8w1BlxUitTy2Y9rUldIgrsnLJek4IcfZp12T4g1ezHMV8kXROa1t0n/8Z1rbn29dKMwH0x6TiiAG70AUWdbQPcVS31KBlZl6MjDQCTxcavVnjaIqP6RR0da6tNdxroW//vCTV2WnRw2BV5iPXneXNpZ04bYqiU7McggR2gKjxkngzI1vhWCph6v8uQi16S3HZLfHZa0ZItEceVHijfArGPhCakRzZVKyVMsQ7dr8y/c5cHSXMPI4V/UomwWJ0sZcJIDjyx8Gfy3vurWc81OE3ogqa81I+PWsJPCSIjli4VfZXb7zVB/fjCRZ/NEkEzeWPl/tnH6KwmS03NdSB5o1pOJpf6ll5y34YU5N1uyTb68W2CLw4wFw5kZZz0HoAt3TeuS5ERcMJcsa+GiU56VgmqIyA5f4nhGlAN
 ImQjSUAU
 k/vLdNQYSKy7R/xQWhsOvhg+5yNBlQGrZz8P6MEEuB/cahvz0NMR7UrQSIL5RqNM6RRnptcv1DfsBvU+7kUO7jXgwUlLn9zHGv9bFzDp8qXcVgFc0LJNu0lZ5a1uJjWg3dFNmt+z9DOu2ACipeqhbV9tMi/Z8gG8vPzyH8TJ9eQpHMP3/ec/ksXa/czf8VCFGVajiQ+kMpzurrC//BapJVL/zJMb2geextilOVdb/IJJlzuUnE3hYcsM77xY73X1FiqTjF6ZeETqnndSRS4Jz2BiCLpcVWQv+1xN1FrlY5Kp3baI9qP2qxq+yNLHwJAxhV7cCj0loTw291UH56efPr5BgIWL1qNWEQzl+gi6b2vkQQQadYtwGX9YK9MlNkLmwSlbMq0yia1Z6jvPwsldoWK7ItatrRuPkht0GzQGqvG59Oi3HGAOVMf+57tGDXVA7yGi1J8n6GjVON9GTCKzPBCC+Qg8LxdxHIbgle1ylxn8y4Nb6Q1Qt6UImJ/xTzbCPQ7KNxHYWt/noKCGLpv2wc5YvdRpb5U8PwUU100G671NXwQT1XhziEi1fjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 01, 2025 at 08:12:38PM +0000, Nikita Kalyazin wrote:
> 
> 
> On 01/12/2025 18:35, Peter Xu wrote:
> > On Mon, Dec 01, 2025 at 04:48:22PM +0000, Nikita Kalyazin wrote:
> > > I believe I found the precise point where we convinced ourselves that minor
> > > support was sufficient: [1].  If at this moment we don't find that reasoning
> > > valid anymore, then indeed implementing missing is the only option.
> > > 
> > > [1] https://lore.kernel.org/kvm/Z9GsIDVYWoV8d8-C@x1.local
> > 
> > Now after I re-read the discussion, I may have made a wrong statement
> > there, sorry.  I could have got slightly confused on when the write()
> > syscall can be involved.
> > 
> > I agree if you want to get an event when cache missed with the current uffd
> > definitions and when pre-population is forbidden, then MISSING trap is
> > required.  That is, with/without the need of UFFDIO_COPY being available.
> > 
> > Do I understand it right that UFFDIO_COPY is not allowed in your case, but
> > only write()?
> 
> No, UFFDIO_COPY would work perfectly fine.  We will still use write()
> whenever we resolve stage-2 faults as they aren't visible to UFFD.  When a
> userfault occurs at an offset that already has a page in the cache, we will
> have to keep using UFFDIO_CONTINUE so it looks like both will be required:
> 
>  - user mapping major fault -> UFFDIO_COPY (fills the cache and sets up
> userspace PT)
>  - user mapping minor fault -> UFFDIO_CONTINUE (only sets up userspace PT)
>  - stage-2 fault -> write() (only fills the cache)

Is stage-2 fault about KVM_MEMORY_EXIT_FLAG_USERFAULT, per James's series?

It looks fine indeed, but it looks slightly weird then, as you'll have two
ways to populate the page cache.  Logically here atomicity is indeed not
needed when you trap both MISSING + MINOR.

> 
> > 
> > One way that might work this around, is introducing a new UFFD_FEATURE bit
> > allowing the MINOR registration to trap all pgtable faults, which will
> > change the MINOR fault semantics.
> 
> This would equally work for us.  I suppose this MINOR+MAJOR semantics would
> be more intrusive from the API point of view though.

Yes it is, it's just that I don't know whether it'll be harder when you
want to completely support UFFDIO_COPY here, per previous discussions.

After a 2nd thought, such UFFD_FEATURE is probably not a good design,
because it essentially means that feature bit will functionally overlap
with what MISSING trap was trying to do, however duplicating that concept
in a VMA that was registered as MINOR only.

Maybe it's possible instead if we allow a module to support MISSING trap,
but without supporting UFFDIO_COPY ioctl.

That is, the MISSING events will be properly generated if MISSING traps are
supported, however the module needs to provide its own way to resolve it if
UFFDIO_COPY ioctl isn't available.  Gmem is fine in this case as long as
it'll always be registered with both MISSING+MINOR traps, then resolving
using write()s would work.

Such would be possible when with something like my v3 previously:

https://lore.kernel.org/all/20250926211650.525109-1-peterx@redhat.com/#t

Then gmem needs to declare VM_UFFD_MISSING + VM_UFFD_MINOR in
uffd_features, but _UFFDIO_CONTINUE only (without _UFFDIO_COPY) in
uffd_ioctls.

Since Mike already took this series over, I'll leave that to you all to
decide.

-- 
Peter Xu


