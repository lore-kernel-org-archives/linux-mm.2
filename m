Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B46CCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 20:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CCC36B0005; Wed, 20 May 2026 16:35:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D676B0088; Wed, 20 May 2026 16:35:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16BE26B008A; Wed, 20 May 2026 16:35:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 064FF6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:35:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4226160DA9
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:35:35 +0000 (UTC)
X-FDA: 84788953830.30.46DA4B2
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9798714000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:35:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="M7wvkZp/";
	spf=pass (imf26.hostedemail.com: domain of ackerleytng@google.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779309333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7Uhb594XOL1gZOtZrSL5VavWJB1z/5+87hhs5G/QCo=;
	b=C1DiLPFerHW4gsMpDX5JccYYn6O29HBuZySvhXM9TefxQ8UKIG6FNneVe9vrPJklhEb9pC
	1gelkFoRWd0K90vMnnn/Amov0Qdtcw6R8RAUiBOu2pybqrmlLc4fafd+imnkWTkvn56fSt
	TQLDtrkkx+8aZYnjpwIsxP1jDjDZEIE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779309333; a=rsa-sha256;
	cv=pass;
	b=jCO9imjFpsdaIvAMyc/xAWT5sX7YlBlfQrKYa2bryH8nMLKdTXL/60bqHzntrMtJuHGzEr
	bdGbSyNIJj7MDSqgrETbx2RHfVnDnHY2iW0ZjYhFsg/F5lmkQPsemafRD7g4wpLwBNVWva
	k/Xf1vcqSvFduluwICxxDbQdxfGSuHI=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="M7wvkZp/";
	spf=pass (imf26.hostedemail.com: domain of ackerleytng@google.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5a746f9c092so8397534e87.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 13:35:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779309332; cv=none;
        d=google.com; s=arc-20240605;
        b=aPZdgrUE56FSPuP3wc3xR1FFBdEV22PWXt9ZvtSBwU3Iyp/x1c9WetzIeGGkO1g0Yz
         RfSnpMftG1/C2K71auJ86qcSrTFqM7b5GzWeiVHFzihHot64MpTaSqYu/+DUaqleAlqJ
         UZ0RN4LE8Hf51YUbH6uZzz/crI9dlVBoDgBQYXnryKePsESV14PiD6BxgIe4vNzaCqEX
         4FN9yvZBu4NZzKSWczZupX/si2nhYxP4jzjrBV6FBinlL7X2Ip32kbkQ+biAQaCb6k7C
         KSsDvI4dphSf3bR9Tt3JIvAD53Rf9ptFcg6F8fOAGm9tQYn4mhWkFOjwny+clQLB+l5a
         P6AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=y7Uhb594XOL1gZOtZrSL5VavWJB1z/5+87hhs5G/QCo=;
        fh=X7AqQm6NceZX0faBSj/+fPM8ffrnfOFmZbpOiw0sIvA=;
        b=WqeW12+ctxeSj6gNVbSfQ6YIaPJ2rFRPhi3BfmCRUw3eDGITkatIZwhOH0SkGJquAP
         h4e15mU2pcRCtFg67h3LP75a/nozVfH/wXbhmYTOZIsCLLxcDVn4/KCATuabYI58HHQ8
         OYV9/zabhaBQdI0HKfYuLLquzAEOcb/+07SwohhUTyrbu2rPAXX8eNdkCvz0TmvCIw33
         bSsnevo1q+XmsXo3kNQmn8FPf5w+C/cxilF5JgscWsje/0uwDKttkaWwxc8bFZOq1v8+
         bkzN/Yh+VEjNI87T+Q63Lu08Tb0hl9x5U2RW+1e+L06/pkF36oB/XjdSklWj/9tZ3hwn
         y67A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779309332; x=1779914132; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=y7Uhb594XOL1gZOtZrSL5VavWJB1z/5+87hhs5G/QCo=;
        b=M7wvkZp/cF69OhmRlDeZcnNP77H7/EEQej9oTbPm7ddplx8Igsn48wFo56rreyyUbt
         C06uEgP5L6t3vo4jiD/18X9Y+RuVZU59hwMXgumrTHf3Mlh5ZDXPgVH17AlgN4WFZgNP
         pG/C30ii0C5yMZk9Fv/LUL/ASY+R9S8S7aGST8+1N+gUQhK7/bKAORWeFgKIhjDoRgfr
         u091FjrTLeC5CkEWpdEZEcWu2JaDi62EZkzmI2gBgX/1OtmX7hcEM14IYkf5edUfRSPS
         9NquoWhsaR+u1Nu8V2JHiaDB3Nh1zjk5J9d16vtjJ5aoSkX6BFNJDF1GV7ft3S6ilUQU
         s+2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779309332; x=1779914132;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y7Uhb594XOL1gZOtZrSL5VavWJB1z/5+87hhs5G/QCo=;
        b=SWVr0maaJilJq/G4FJMwXXfjnSynfamy8ut53jDVRAPLba5YogOOlZu3t+Fwxx/Oa+
         BcyjEnJffJ3n/Jf9QjFE3+pXDE1hK3HENcBNu1NcW0ORPihoVlo5DL8GTQkma0U2kAly
         IIs9cTuXZMxodNEJCDhyj0n5fKfOu5GxvROooI4i45UZQmEzfSscq25gZPFVMiNAFMrK
         8g4b/x34jEUKkHhrYRRQYrkTa8+CaR01xGHhje4HtRW48omnwy8AdHasSHXlmIo0fj5o
         RPQICDLqn9n9r4E8GidXJZhed5yTl4wDHWhfiKXIZqJfX8GqBB8XLtVVMUpAOauuFtLf
         sW1A==
X-Forwarded-Encrypted: i=1; AFNElJ+FmMYJihqtCUrTbwoOr8Bdf/U/OeBEUAfWE/Ez2A8ktp3ndLgdZ2Yex0fxqdbaafPEjuNQqUQHZA==@kvack.org
X-Gm-Message-State: AOJu0YxlmIeZq9/bgHdnXc0FSgoJxNxvYMhKjCIAzb7qi/6zR4nyKCM/
	nljqmd55hFAdnZy8Y0dKk3wB2eSgqqCwziSHLT9ujYKROqbtA5pmqbcm0P/QeHPJHaUWb6yup6q
	Sfqqy0B9a0MztXsYsMn/m5SfaeRG9/hPXvxZ05H0t
X-Gm-Gg: Acq92OFewbT5s7m6iZ2Fz1WvQYN/i+qH1zlMvlxqx/JRTlQtBsemmHEHzXzB0uPmD5c
	4I6AefbDjTRPTBjMkC2GH0VP0B5HLhjqgCBFAGsa82B3PBTrD9TO4cDaNWeKu4/ljEk6/h1Ncc5
	tog2uuvHsoIFp2rg03D+Ekk13hImkOyU844ksvPRsGqvdoldb4029WaUdwv5UVYZdS8Gx/O8Nej
	B+i7uUKDg9ZRzUW8kJHk22bMEEwKoSDGyIdj7+cvRW1bKoqnhRPFL5o8c/EPEGutwEnrinkKL+A
	IxGDCzNjPcUwOMFMuZX7SyWOwaWGUWG6xjefsx91OLbPYHENNR8ZcSuith+EFZO//nJZAszZP10
	rbCPG
X-Received: by 2002:ac2:5b03:0:b0:5a8:8818:819c with SMTP id
 2adb3069b0e04-5aa2ba8d0a4mr6125e87.16.1779309331108; Wed, 20 May 2026
 13:35:31 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 20 May 2026 13:35:27 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 20 May 2026 13:35:27 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CA+EHjTwOfJ=nCRoX3m5uDt=CcF_zrqGsZVBBmo4MscmPqrBxOA@mail.gmail.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-12-91ab5a8b19a4@google.com> <CA+EHjTwOfJ=nCRoX3m5uDt=CcF_zrqGsZVBBmo4MscmPqrBxOA@mail.gmail.com>
MIME-Version: 1.0
Date: Wed, 20 May 2026 13:35:27 -0700
X-Gm-Features: AVHnY4JCI2WxkpGpEfiZH45uIXCVj4Nb0JRb9mme96xXqvKAS-EEsMTVSDBkz1s
Message-ID: <CAEvNRgFqPSLKKKb9etgfqdt0y81Agu5RwRipuGw=j2y7W2Y0-w@mail.gmail.com>
Subject: Re: [PATCH v6 12/43] KVM: guest_memfd: Call arch invalidate hooks on conversion
To: Fuad Tabba <tabba@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
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
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 9798714000E
X-Stat-Signature: fuqjw7pije7k5r6pk9rojjx9rz4i6zzh
X-Rspamd-Server: rspam06
X-HE-Tag: 1779309333-855810
X-HE-Meta: U2FsdGVkX1+u+W4e8woExlPrpjWEJ+BpI6uAhg+PZrTwm7bVGvg+BG8CB/Bn/qWnOcB29+Q5mIaVg26g8vz6RJDBUv+wTuNXOwzAf2CoiGkksCXgFnY1rLx2ufKbNSsa5KejGVAcwwKPf9SDN1ARQ8V6KuQaR23ZN64AQX7DjSGc7LVVNzcikWMbUp9W0wrVJVKCZegqFgbdd3Dt4bKiEUQp2+4ZkUqdY+l08bzYe/0tn+nz+zCTpMq/Yuub1J4gTexiHFzI+jKHS+jOT0MLJ24NgFpbkB0JL0L6yKh5hmx9hKfNOPsXRDTQtPJp7mMJCWM7ggj9syleMD39b8yv7Q42MnSjMLxodODnhvqn2MqP3eG/HNM/pMYepgn9jn3iqxH8yEzAFwB3EmUysVD2s3mNS7NTSfFocgnyn3JMfgVTmBkGkQK5p4RHoQB/dakjgyOsHHYH5DCWWOdmRObjzeDooaEm8uNhSPlHMlLO5pSPzvTSQMmgz4oxySTjZ8DFG4LHZowVrXAC0jpbeHfNpj2LeBk0QjH36i1BUeiDNn2luaj3WjI05roqI5DdttsG64Op5fdh6qDx7j/CO3E4HxVO8wlwfYbMNoJoXPP52RN2/Y4H/FDN3WUGkvGe6ki2+ISXV06tZ5vsNjUNfd9iTRXffyA76npakDVG05p9uP0hYEtVAciqPeuY3mfmE28V9uRs0laV1KrLBSNrZ3v6UHxgMHVaYT96CXEyhDjnUv89mEi7nlqH+qku6bNycM78hyjQeU9gntGFd10PF/6lw1ThXl9wQTqBw91hBp24otw4CEDXVHhsxBKEVJjlLX1xtuufxJfbQ4TzoPsZHWg4tzadR8Mbo/6o7zChhiC7WbkgrmBe3ProdQ2nCskYow3xfhoF5riXYlsghV1waFnJoBXfr7Zu4UTnn66my3SQPqfdzZeVDkKbjsFL4N1hvhqEOLGdkDJPTURHnCZGmD9
 Ys1t+cNX
 4ZIU2CD2Vnv+uXBoGqd3WaysSxe6RMa0orFXI1Xskmrs+MUz4b1KLt+FkVW3k6Yp4NwmaHXxEGY8w09QkllLhD/hsbsVQLinbG5dfY/FmbsEI/6Z8rgTn4em2PL1aRo2PuseyVi6uK5AzLkU6yHmfSBrIKuLk+vaUf84t/ZaQyHzomwqhstXA+b8qvM9Glhsg8WQxZ9biqBulCyqY3mmSMQu5+91zPqmz+6ZzTavDo6zYXWA9+UBvSex+SMoazuqoz2l+4TdvNOgHi9WCz4z9Tt5Rd6Z1eDDt+vveO6Z8cXXqpxXVf97EXRv5M/9sHtTB9HrXZnVin7FFF8nC/WsND2UAYs0IXA3vcKpjbUXxw8tn6Y36lFv4rm7eYYM5+UzA53zvPllhW6gkElE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fuad Tabba <tabba@google.com> writes:

> On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
> <devnull+ackerleytng.google.com@kernel.org> wrote:
>>
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> When memory in guest_memfd is converted from private to shared, the
>> platform-specific state associated with the guest-private pages must be
>> invalidated or cleaned up.
>>
>> Iterate over the folios in the affected range and call the
>> kvm_arch_gmem_invalidate() hook for each PFN range. This allows
>> architectures to perform necessary teardown, such as updating hardware
>> metadata or encryption states, before the pages are transitioned to the
>> shared state.
>>
>> Invoke this helper after indicating to KVM's mmu code that an invalidation
>> is in progress to stop in-flight page faults from succeeding.
>>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>
> Minor nit below, but lgtm.
>
> Reviewed-by: Fuad Tabba <tabba@google.com>
>
> Cheers,
> /fuad
>
>> ---
>>  virt/kvm/guest_memfd.c | 41 +++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 41 insertions(+)
>>
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 9d82642a025e9..baf4b88dead1f 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -603,6 +603,42 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
>>         return safe;
>>  }
>>
>> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
>> +static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
>> +{
>> +       struct folio_batch fbatch;
>> +       pgoff_t next = start;
>> +       int i;
>> +
>> +       folio_batch_init(&fbatch);
>> +       while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
>> +               for (i = 0; i < folio_batch_count(&fbatch); ++i) {
>> +                       struct folio *folio = fbatch.folios[i];
>> +                       pgoff_t start_index, end_index;
>> +                       kvm_pfn_t start_pfn, end_pfn;
>> +
>> +                       start_index = max(start, folio->index);
>> +                       end_index = min(end, folio_next_index(folio));
>> +                       /*
>> +                        * end_index is either in folio or points to
>> +                        * the first page of the next folio. Hence,
>> +                        * all pages in range [start_index, end_index)
>> +                        * are contiguous.
>> +                        */
>> +                       start_pfn = folio_file_pfn(folio, start_index);
>> +                       end_pfn = start_pfn + end_index - start_index;
>> +
>> +                       kvm_arch_gmem_invalidate(start_pfn, end_pfn);
>> +               }
>> +
>> +               folio_batch_release(&fbatch);
>> +               cond_resched();
>> +       }
>> +}
>> +#else
>> +static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
>> +#endif
>> +
>>  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>>                                      size_t nr_pages, uint64_t attrs,
>>                                      pgoff_t *err_index)
>> @@ -643,7 +679,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>>          */
>>
>>         kvm_gmem_invalidate_begin(inode, start, end);
>> +
>> +       if (!to_private)
>> +               kvm_gmem_invalidate(inode, start, end);
>> +
>>         mas_store_prealloc(&mas, xa_mk_value(attrs));
>> +
>
> Why the unrelated extra space?
>

Hmm this space provides vertical space between invalidate_{begin,end}
and the STUFF it wraps, like

  invalidate_begin

  STUFF

  invalidate_end

More STUFF is going to go here in future patch series, such as splitting
private pages in TDX.

>>         kvm_gmem_invalidate_end(inode, start, end);
>>  out:
>>         filemap_invalidate_unlock(mapping);
>>
>> --
>> 2.54.0.563.g4f69b47b94-goog
>>
>>

