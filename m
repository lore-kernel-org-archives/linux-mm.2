Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99CE6CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3B468E000B; Wed,  5 Nov 2025 16:23:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC4DE8E0002; Wed,  5 Nov 2025 16:23:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8D9B8E000B; Wed,  5 Nov 2025 16:23:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A25C08E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:23:55 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 51B8213B006
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:23:55 +0000 (UTC)
X-FDA: 84077830830.05.CEF9ACE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id CD59640008
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:23:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FLeCLTmr;
	spf=pass (imf07.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762377833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irxlM+zajycQvptkFG0Ecggkg0FzwDEC2rGbASu0wKw=;
	b=hTydZAO7LtN0Qi1UB9AF3MpVyWm3Whj7/X3lE+NpCJEIgE7lREeEAlS7xDSuXdUkjrA9Mj
	UlJeIxYAv5Pyb+RA5bZ4YoBL+MJi4cXT5+XGR8p76bDtoU9/UXMP+qIv2llG9rUmdU+tOT
	fr16SC6pA/mTFttoLRImre/YzIsSOVM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FLeCLTmr;
	spf=pass (imf07.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762377833; a=rsa-sha256;
	cv=none;
	b=kPAD6Q26LpP2hgpLXyJ276ckVAqOW6CodY4cHYI7ty6O/F6vin5+xVNSpx2JmXQnlUmg0A
	M4rW+H7UgHI/s59d0JZt+VOcFhesZYePk3xptp+ZZW+FkB8jrODNfhMpDccu47t4RgyAiS
	TWfZCGkGlDUUV6SGfFmSxz8Vrwh5rsU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762377832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=irxlM+zajycQvptkFG0Ecggkg0FzwDEC2rGbASu0wKw=;
	b=FLeCLTmrDODnIxI/14BiqHSrlAnkCMTiDV7teqw6o2WdNBbIBJNcz/YYZb9ZnD/ULgjILT
	qNwVguTSFnv0zgFwrgn546wjS+ym0ne6Xv3FTkaEqVDFMiXVRVZbGwpZg9PPFxnlOgMNKE
	f0VMYkDSENYTJnWs/X71vCDMaiUGtEE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-GnAd9WAyMqaOUcFlhnxhqQ-1; Wed, 05 Nov 2025 16:23:50 -0500
X-MC-Unique: GnAd9WAyMqaOUcFlhnxhqQ-1
X-Mimecast-MFC-AGG-ID: GnAd9WAyMqaOUcFlhnxhqQ_1762377830
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4775d110fabso3006285e9.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 13:23:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762377830; x=1762982630;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=irxlM+zajycQvptkFG0Ecggkg0FzwDEC2rGbASu0wKw=;
        b=Fm9puOO5Qdmo1ygfVOkr/FdSWQxJxIKvB0Rd2c4MlWiJP2ILpMVrmrWsI/r+OUepVm
         /A2vad2mngkzMWDDwE7Nyr5N9EhjMQodbtX6HDIXSthonqEv3tFqX4iq5axOWVaZmoNd
         JQWY/RMR64Z30DB4u62eYRkxcxATSF55zBYoLfif8BmVP1IArqKgFIZXcDds586v1N9j
         /bIjBclS69QBeAiLx3WVJlkntZaDAyQwAXjRkvjvm6z6O/iey77j++cODgDjMXCscD08
         nGrk8k3wNmpBhCPK5WdF8dc05RpgUuTbmydfDzBa/1TQRgPQgsh7Wfrim1RYsqXhl25G
         fp3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUhDQlS3+euWeDKTz8nyllC2kxhY5ZpTMAPc1eqi75rvbW4iIE9ZjVoAuoK04yjLvWmW56DicCK1g==@kvack.org
X-Gm-Message-State: AOJu0YxDk3tNHypr66TPJuVwT2Lss6HeBgtSC/1ATCFmkhCvoXFdMTsN
	crpKrleFfF+pEYIkbgWTOaFMPES/aRbz/uKOWlNSBWRaQKkhXmqNkm22UXQ4m6aq4fl8kbKyhIl
	40drNHAqtwT6JUHQ9HZhEMjvu1sk+GehhKYxBA01J0qrkCTqIyyQ9
X-Gm-Gg: ASbGncuAcaZjVojYNnrLhfWreM5+AYf4ootyaqjn5c3/WtSSAGACU6QDQDzSf9Tviof
	remJcZz5d59X1EFoCZ0Bsd5wrvsqUs7v/GU0ZJUGdYFJiRQLVg5bjCVF6SMU80nE+dX1GwuMuVX
	QiSzKDF4scE//F/MuBXLBf9VeJdkvCewoeZBlPS4ieBAL/yIBrEEQN2Ycibf/1A6ymlr1uV+NaQ
	+P6KdfBjynl7EAUv97QJipn9hRuVhx/CWj0DU+4Mh+QvfyLt2WzToN19Y4chaffd8rirSPdgsxH
	phTdIW+QjBLrvBs16IdAmM/OHsWFKs2SP+IgYpi+HChk0Fd7cgoE9C53UqGVMpRLW1UgD+/dd09
	0X0wtlUNd13rUDr7NMi/2LvJlyi0iky8IqDMvP7utuXUyeK12+2SJzSiva7RYT1loOiuQy/0/Tc
	7IMJXt2ALqKsyCoYsTxrFdsxE=
X-Received: by 2002:a5d:5f45:0:b0:429:cbdc:86e with SMTP id ffacd0b85a97d-429e32e92f2mr4264251f8f.18.1762377829716;
        Wed, 05 Nov 2025 13:23:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEFMBPGjUyAWRqYLdaePyzci1tJGP5cGEiWVS3z0azdKYFVcbbYYUKG6ZsLRBWt15fQxm1NIg==
X-Received: by 2002:a5d:5f45:0:b0:429:cbdc:86e with SMTP id ffacd0b85a97d-429e32e92f2mr4264238f8f.18.1762377829254;
        Wed, 05 Nov 2025 13:23:49 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429eb47873dsm860677f8f.31.2025.11.05.13.23.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 13:23:48 -0800 (PST)
Message-ID: <78de3d64-ecbf-4a3d-9610-791c6241497b@redhat.com>
Date: Wed, 5 Nov 2025 22:23:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Peter Xu
 <peterx@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Nikita Kalyazin <kalyazin@amazon.com>, Vlastimil Babka <vbabka@suse.cz>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 James Houghton <jthoughton@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Hugh Dickins
 <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
 Ujwal Kundur <ujwal.kundur@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com> <aPZDVuscFsYSlQjI@x1.local>
 <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
From: David Hildenbrand <dhildenb@redhat.com>
In-Reply-To: <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: T16XNMnVKFANXZ_TPhyB4kjNyx54rmM00eewEGxiDf4_1762377830
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CD59640008
X-Stat-Signature: ga8a3bg3x635m1qr1sh3do4ro94fyyft
X-Rspam-User: 
X-HE-Tag: 1762377832-976728
X-HE-Meta: U2FsdGVkX19Ag4zdv5ZoktoVb4lCz3ll2dtv+RP/XWYdTZw8kDQabiwI3ZTL55hpqjJQ//kRTGmdLNASr4Us8zT3ILOyv/5QCvrrPM2GP8dmdd+DxGI677DBYC5OXzqLkuE8rr9hiqogetYQQv9+SdLpmghV9mxvsyOjnm0wvncDsnFJlVVrbr6TNWyQZ1bS4hrKzd7aqs8tzwVLNzFnfMDy3CfJK9/gRL6amSnR6KIuN3oHaa2UgQfGR8qjVF6r/45AjwyyOqBi++7ImLrFUohY5g27q8lHE/UTBxM3XoU2OssF7rz5GlQ1mI684ExZrCQFI+4Ef51u1eJRqLYin3N8EOAqBsV87zbQww8acTK04niPxnxN7hWFbu6zsPXBs5h2h50JxiMS8BWAdx8PlHoJtEu5N7yZwy817tKdt5wBqOOd3OI5gfLOEpuwffGFl1dNezGDxW48kBjdZUCjo3CcJiqNrc9SE28Paw52hvqbO3wNDzd1G2MAknSsjtuLJ8wQ78tOMCwXK6BTwm2IarwNW1UsxALIEwtPOylVR3SGXr1T8HHIviuxy04aqbZD9an6zpqxEfbDy4y/v6QuTHue0Flbdf92maTBtLrtpgVVKhu3gSOx2eG6p7EiZBkhKyQEgf7KH7x8Vm4TftnGF3DFkOIAxG9znFJBNS34JLOQxbkbUh2h6qRPWwU+ACOfkveFbwh6O7Z/JwElKwJCLBS4AlsoLZxdiahoNC/wMkjZt1W2gYFl1+CyEoZvywf+GOvbgjZ3mIjBSChKHUUkntmdfS1o0MTMlNsZk1VjFjBld/e9kr0WQGbewntMRElif4f+Pj00dKH6t6i9DWi8l6BFxiX44K4mgAwfrmoCmLQxfwzpFe7W+amQWl8SLCS3jul1T5hqhrZzzP7QQB0OkUVzldF7oAwAP0KMAkic+Jj1E59NPhGizdJn2M+S9UWLEWi/jryE/pM4MRWmJMm
 ldqC/e1g
 IrT8YBhrQUR7Lkox5FD/QluQgAQHIGZnxuRtULipkcWUliV2qCWtL01fvZjsCbXFuLXqXdx0ep6I1AHz3av/OoYweoh9t8omyGtlwimqHxwb6EBSmWAp7IuFvNlXGfTIU3qDuxpMMx+g8GEHDfMwVju4QA/4MNm5dtJZ00eO768njP6cm0Vj0s7iu/j227dEnTIZ7tx/0bl5AFvtuJMM+xJF+HshGf2ALoz21RlLEmf7+rHlQl7Aiik1MSf2RqoG4C26v8djLlOYYoi7HJ3BI85YcOfxF0nquZ3kaRbwjrixY16Ahjvuydweb82ZO3HdN8SgSD9T5fMyLYAgVoN+eQaN8LczLD637HYSHLJAajPULDmG1CNOAO2xWFEztsRMYjzUDugX5828EYgrV8HDy9ToJ3+kPcgVqvGan9SHIIVrZHygc8g8hUOY9s4+BfMCSiYHhBaj0XRnVa64IgPIaqlM43a5n8bz099U0BbTbwY6EpYxZkqlhFDzdGFtn66T6JL8S2y2IbS5R6eEkney83kJQMTKIm76qklY/rHPzGTZWiJWjnFCW4I9ftSZxP82szV8jws50mrTeSE+0UyWQbON/G3D/ImsSu0cg0SS/bjZMyzgRB6nE+RaUdpj1iWwiurmV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.10.25 18:13, Liam R. Howlett wrote:
> * Peter Xu <peterx@redhat.com> [251021 12:28]:
> 
> ...
> 
>> Can you send some patches and show us the code, help everyone to support
>> guest-memfd minor fault, please?
> 
> Patches are here:
> 

Hi Liam,

thanks for showing us what userfaultfd could look like when refactored 
according to your idea. I think most of the userfaultfd core code is 
easier to get in your tree.

> https://git.infradead.org/?p=users/jedix/linux-maple.git;a=shortlog;h=refs/heads/modularized_mem
> 
> This is actually modularized memory types.  That means there is no
> hugetlb.h or shmem.h included in mm/userfaultfd.c code.

Yeah, I think there is this confusion of "modulize memory types" and 
"support minor fault in guest_memfd".

So I see what you did here as trying to see how far we could go to 
remove any traces of shmem/hugetlb from userfaultd core.

So I'll comment based on that and rather see it as a bigger, more 
extreme rework.

> 
> uffd_flag_t has been removed.  This was turning into a middleware and
> it is not necessary.  Neither is supported_ioctls.

I assume you mean the entries that were proposed in Peters series, not 
something that is upstream.

> 
> hugetlb now uses the same functions as every other memory type,
> including anon memory.
> 
> Any memory type can change functionality without adding instructions or
> flags or anything to some other code.
> 
> This code passes uffd-unit-test and uffd-wp-mremap (skipped the swap
> tests).
> 
> guest-memfd can implement whatever it needs to (or use others
> implementations), like shmem_uffd_ops here:

There is obviously some downside to be had with this approach (some of 
which Mike raised), regarding the interface to "memory types" 
implementing this, but I'll discuss that later.

> 
> static const struct vm_uffd_ops shmem_uffd_ops = {
>          .copy                   =       shmem_mfill_atomic_pte_copy,
>          .zeropage               =       shmem_mfill_atomic_pte_zeropage,
>          .cont                   =       shmem_mfill_atomic_pte_continue,
>          .poison                 =       mfill_atomic_pte_poison,
>          .writeprotect           =       uffd_writeprotect,
>          .is_dst_valid           =       shmem_is_dst_valid,
>          .increment              =       mfill_size,

See below, I wonder if that could be performed by the callbacks invoked 
as part of the prior calls to mfill_loop() etc.

>          .failed_do_unlock       =       uffd_failed_do_unlock,

That one is a bit unfortunate (read: ugly :) ).

failed_do_unlock() is only called from mfill_copy_loop(). Where we 
perform a prior info.uffd_ops->copy.


After calling err = info->op(info);

Couldn't that callback just deal with the -ENOENT case?

So in case of increment/failed_do_unlock, maybe we could find a way to 
just let the ->copy etc communicate/perform that directly.

>          .page_shift             =       uffd_page_shift,

Fortunately, this is not required. The only user in move_present_ptes() 
moves *real* PTEs, and nothing else (no hugetlb PTEs that are PMDs etc. 
in disguise).

>          .complete_register      =       uffd_complete_register,
> };
> 

So, the design is to callback into the memory-type handler, which will 
then use exported uffd functionality to get the job done.

This nicely abstracts hugetlb handling, but could mean that any code 
implementing this interface has to built up on exported uffd 
functionality (not judging, just saying).

As we're using the callbacks as an indication whether features are 
supported, we cannot easily leave them unset to fallback to the default 
handling.

Of course, we could use some placeholder, magic UFFD_DEFAULT_HANDLER 
keyword to just use the uffd_* stuff without exporting them.

So NULL would mean "not supported" and "UFFD_DEFAULT_HANDLER" would mean 
"no special handling needed".

Not sure how often that would be the case, though. For shmem it would 
probably only be the poison callback, for others, I am not sure.

> Where guest-memfd needs to write the one function:
> guest_memfd_pte_continue(), from what I understand.

It would be interesting to see how that one would look like.

I'd assume fairly similar to shmem_mfill_atomic_pte_continue()?

Interesting question would be, how to avoid the code duplication there.

(as a side note, I wonder if we would want to call most of these uffd 
helper uffd_*)


I'll have to think about some of this some more. In particular, 
alternatives to at least get all the shmem logic cleanly out of there 
and maybe only have a handful callback into hugetlb.

IOW, not completely make everything fit the "odd case" and rather focus 
on the "normal cases" when designing this vm_ops interface here.

Not sure if that makes sense, just wanted to raise it.

-- 
Cheers

David


