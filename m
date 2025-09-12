Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 989FACAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 07:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD6928E0008; Fri, 12 Sep 2025 03:53:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87228E0001; Fri, 12 Sep 2025 03:53:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C75BE8E0008; Fri, 12 Sep 2025 03:53:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B422C8E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:53:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5AD1711AAF2
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:53:10 +0000 (UTC)
X-FDA: 83879832540.03.891B6CB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1022DC0009
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:53:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EMvgFXIU;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757663588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p22hl1mxPQvYXz93krcBnYpXobl8Fk3Ezh7wV4Ywahc=;
	b=5cVGGGWsTEHLYqzbdvZLml7Lmaqj+SmzCKuiwFMNl2BLfGBmh9Krtw4kDBWzr9Tc+1We9M
	SguM55DsHNEIWC+k4COtrmpAJdAVqX5gatHU7DElYMJiOxzkDhjjFMoN+FhWhbxNeTumvL
	rZnt3QhwGEMZBkNi7d534yhE508ezkM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757663588; a=rsa-sha256;
	cv=none;
	b=4fswmDme1i7u99Gi1lmLfDNb0T6m0yeZIybqdXmqrSAlnDW0FlksP7rzNIdkojXo7q07pM
	eSBmwAN2GcLWf82pXoFW6gC3yxUOpLSZ8brdLbcj14+tpjKUilG5P1S8jk1c3NEPzxCWki
	IyzJ5EHVTXmdesmV+7YvQ9/oZ0kE6Us=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EMvgFXIU;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757663587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p22hl1mxPQvYXz93krcBnYpXobl8Fk3Ezh7wV4Ywahc=;
	b=EMvgFXIUIXa306XZljnEvNZRFMsMqgT4/08UBTSWpkKtfK16mGT683nJKPv4pWaHnyBvr3
	1OQR32aKW/U9IEH3GAggED41Oc28j0UQuuKgS1J6pme65rrfzTOyhECD6uWFZ7hJr8Wg/m
	Z6M1iXFui9ITHlcwTfgeYcmpzC6SG4s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-4bWNB2h4Mh-17ETMZkvBvA-1; Fri, 12 Sep 2025 03:53:06 -0400
X-MC-Unique: 4bWNB2h4Mh-17ETMZkvBvA-1
X-Mimecast-MFC-AGG-ID: 4bWNB2h4Mh-17ETMZkvBvA_1757663585
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3e68a54dac2so705123f8f.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 00:53:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757663585; x=1758268385;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p22hl1mxPQvYXz93krcBnYpXobl8Fk3Ezh7wV4Ywahc=;
        b=URQjxAmm20qalDkq/WZe268nCl+uvK25H9R+0xVYiziIzPdIV1MUAKHgZEO+IDEvoE
         0AGGZiZGmSbjxvmqyg3NAj/B6asQ79TYeMiusR8PxND0MoZLTZxtmu63WtpjvF2pfSLE
         KixERu+7In//a8294TastQpdB852JyTZdmJ4fC//VGEqJGTTpUr8FNOcCMbbqby1xmOh
         XkjdeD9Od22uszDkocJBmqBFbSxyrOI+g9VLUR3pJ9Kx2OFtqdx5/LOvM9OaiUGm+Va/
         HihIyITcmXFkSs2aMvfaHMtTFAzyAgLhL9XIBATsswpEnaYdoJQiNGo8LWFcs+I8XsI3
         IqsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwDSMDGP6zq8QWNaBBwV4UxXGr+8HkO+vvCZT3e83iusqzr1ce8O5kAuuWBg92cDlNrppkO6+UPw==@kvack.org
X-Gm-Message-State: AOJu0YywUvMDMMPEK8lrgxmZIqp3RaDy762gidraA9y4xbdlhttY9CE3
	g/wT8flmPF06DCFY9YgtpCGSaOLZMBBJQqxVhxEcs9eubzKOY3i/C9FAvbRaRgQfmHwb4UU/LXu
	zpgM+PG+dypiUA34Ld0RdchRFc3fwToBrvkKc7UIXRpB/bSmg887q
X-Gm-Gg: ASbGnctXD4kWiHuj2cAI2E6k6cKSKawL8IDNcKfN428LHLsZYloZLVzoEoX/ysnMfFh
	Rc1RKzJBhEDmBYzmkMCt/l3xoMV5XmgaZMOwOwn1eg4dCdkM+LwDW7eIUYBf4W9LcAdWAZw9O0w
	YYHjxpSEmz5NwXu7XFE34p65tniBCwuLx7H/hNG9A7j8IWy7MTfhUvwXHqPCNhMZqF+VmesPlD3
	cmhgBPYoP5u3bwP4BBlUgB5myp6nTeKd9+Uj5NsQ37fdghEsWPSYfjKE6M56a/sW0oXHQ3xrlou
	HvvmB/S7Y0FKe0WYzxGm5hBAE8DFluHJwaS53jyQRVMFQpn9CeUILvHExBb90ZkMXZSJees1t21
	143iqgajvgJ/j4EXYQXK/SOze3eHxR/tGmRdk2SlCout8JOGt6DcL2qq6nYDIeTbRyB8=
X-Received: by 2002:a05:6000:2003:b0:3de:e787:5d8c with SMTP id ffacd0b85a97d-3e75e1071bdmr5309931f8f.13.1757663584798;
        Fri, 12 Sep 2025 00:53:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFq7C4qTXd+XsofeMwanjE1i08XNy6UqslUe+yjaLRudd1Ww9k5jR9x6r0SjXc+XP9zCsAuvg==
X-Received: by 2002:a05:6000:2003:b0:3de:e787:5d8c with SMTP id ffacd0b85a97d-3e75e1071bdmr5309885f8f.13.1757663584264;
        Fri, 12 Sep 2025 00:53:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e774a3fb5bsm805305f8f.58.2025.09.12.00.53.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 00:53:03 -0700 (PDT)
Message-ID: <a0e586dc-dce6-41a2-9607-f2f64b752df1@redhat.com>
Date: Fri, 12 Sep 2025 09:53:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: Disable soft offline for HugeTLB pages
 by default
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Kyle Meyer <kyle.meyer@hpe.com>, akpm@linux-foundation.org,
 corbet@lwn.net, linmiaohe@huawei.com, shuah@kernel.org,
 Liam.Howlett@oracle.com, bp@alien8.de, hannes@cmpxchg.org, jack@suse.cz,
 jane.chu@oracle.com, jiaqiyan@google.com, joel.granados@kernel.org,
 laoar.shao@gmail.com, lorenzo.stoakes@oracle.com, mclapinski@google.com,
 mhocko@suse.com, nao.horiguchi@gmail.com, osalvador@suse.de,
 rafael.j.wysocki@intel.com, rppt@kernel.org, russ.anderson@hpe.com,
 shawn.fan@intel.com, surenb@google.com, vbabka@suse.cz,
 linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <aMGkAI3zKlVsO0S2@hpe.com>
 <749511a8-7c57-4f97-9e49-8ebe8befe9aa@redhat.com>
 <aMMNVA9EXXHYvmKH@agluck-desk3>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aMMNVA9EXXHYvmKH@agluck-desk3>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DvTcMhqIOFI5y1Ceoxk7klDQZ0rR680SNgiUv1ntk9s_1757663585
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1022DC0009
X-Stat-Signature: 4ycysukcw3kpx8x4kqnn96193tui6htz
X-Rspam-User: 
X-HE-Tag: 1757663587-656073
X-HE-Meta: U2FsdGVkX1+K6xUPH9sLY7tJhObYRv8cIrH9cl2xAtmDgDNY7sbrcJzz01kLFYZIkVAVXMRe6qNXfhhcHxkPkWuv9NiRKd9TISCRuJZcP3QfRvP1pQViIH++RqYvX0z+fn6W4ByYfwUV4M4Upxd3ufghvruGXCatpAtLX6TNlBXh8DHO/PqbHGptFxqLovukvBc6gjznLe935xLVIrKKxZQZzT8ufEurmD2gtfFCrVpJ8Qe4Tr4Omk2ig1bHu0U+lN3PxCWjPs/WYCKhc4FXH+8uj4T2bLeZysKo7AFdPOu2KihVJoYT73DiPfuDOeo7TAheaBCAZw0KF2MHeLipwJZid0KaZngtVlg66vIqFE5nzrF+7o2cH/03WFUBmwK5NSnuE/PggMs4ky4akNnzgYb2+al7tha+H13QPViReHrawYB/4ijh2C83vj5rUrLVNr1za5E66OASdy7DgfmniRF3uGbRtp/R6Q3uMkQSqsG6myf1JTJYS++6EEF42U4igs4Wo2z3zz6N6w4/DIKwdUbcIZf9EUOweRq6k7ItA6SzGU4zWXsbNCELD0yXwqzjyJmJs6wzZk5eavShB7PvU4jJhpfsL/dscbS06YCSP3++T2eL30JjdxuFfxaP6sn6fJFmuELzAt9xjV1d3V08svkOSKauFx+Ob5wFVl+YLDkD65dObtxPpg+H4/Wd35S79twwVV8do1i55Kc/AO61v5JNtCsgUyO77i+KP7EWCCa9XJXQ5grE5rRrxZqLae7xVnd7BVvuHxtucGxY3X1WtFLLD/cQ4hix2jttoP6IYps7juCT1TzDTJr1A1DS5c5SBMaz9jj2BQ5EXvxK45+OfJxP/AYYnxxaiJ7G8gHFseDjxn3cRaKvdEVe89jJnDGU8D5qcU97S7No9TNB0h0AdptI1Xz4OWsQ2apoeYy6WXdT69nJ6wVOlsetVMhJ9uudXikQ005wJRnl9iInAob
 8vispkYR
 Ilk6C2CsfBogchTpm1t+2+Oc8K41BqVQ8Ic6COljpSHsfCsoVVixmtCqPkFnQ9TDWu9vvGz2Xkwgy15zgCuY5zKtr+VG94VQXZ0Rdgh1auape/eKsymzMxr7TMtt2gTdbrkJWWTOspnhFSQwktmnqPZqHpVfbYI4bEeOcGLBhJwgszguVR+qAkukjjRxSZzA7cX6nI8ccqQA4q5dJ4wf+hQF2yr0s9ZdSBa98LAvvIVYTDxsfp4Yeg5cTxpsUejwuzi7H7akxpVHr4JJAKjuJfj9KKsCL1+I1Mf8YNltv60iVBtXkFcPgRBYP3Rn0res7bBkLThMIoq2fLozxvdgx0qTa0mJrEC2kNThfZDQMFy0w79TIJl2gj5Rr32mGuVMM/O/wMxbdzejiYFWFfRsXbPtSpZ2iDAv7BlyKDDo5Yr1dETm2hWRSPD1yBF3zdXpT2wq0GyViBeRgJY+UdPyhmGN1L+XtxToCccO23NXTLrvuPhyr7gfqbY7jkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.09.25 19:56, Luck, Tony wrote:
> On Thu, Sep 11, 2025 at 10:46:10AM +0200, David Hildenbrand wrote:
>> On 10.09.25 18:15, Kyle Meyer wrote:
>>> Soft offlining a HugeTLB page reduces the available HugeTLB page pool.
>>> Since HugeTLB pages are preallocated, reducing the available HugeTLB
>>> page pool can cause allocation failures.
>>>
>>> /proc/sys/vm/enable_soft_offline provides a sysctl interface to
>>> disable/enable soft offline:
>>>
>>> 0 - Soft offline is disabled.
>>> 1 - Soft offline is enabled.
>>>
>>> The current sysctl interface does not distinguish between HugeTLB pages
>>> and other page types.
>>>
>>> Disable soft offline for HugeTLB pages by default (1) and extend the
>>> sysctl interface to preserve existing behavior (2):
>>>
>>> 0 - Soft offline is disabled.
>>> 1 - Soft offline is enabled (excluding HugeTLB pages).
>>> 2 - Soft offline is enabled (including HugeTLB pages).
>>>
>>> Update documentation for the sysctl interface, reference the sysctl
>>> interface in the sysfs ABI documentation, and update HugeTLB soft
>>> offline selftests.
>>
>> I'm sure you spotted that the documentation for
>> "/sys/devices/system/memory/soft_offline_pag" resides under "testing".
> 
> But that is only one of several places in the kernel that
> feed into the page offline code.

Right, I can see one more call to soft_offline_page() from 
arch/parisc/kernel/pdt.c.

And there is memory_failure_work_func() that I missed.

So agreed that this goes beyond testing.

It caught my attention because you ended up modifying documentation 
residing in Documentation/ABI/testing/sysfs-memory-page-offline.

Reading 56374430c5dfc that Kyle pointed out is gets clearer.

So the patch motivation/idea makes sense to me.


I'll note two things:

(1) The interface design is not really extensible. Imagine if we want to 
exclude yet another page type.

Can we maybe add a second interface that defines a filter for types?

Alternatively, you could use all the remaining flags as such a filter.

0 - Soft offline is completely disabled.
1 - Soft offline is enabled except for manually disabled types.

Filter

2 - disable hugetlb.

So value 3 would give you "enable all except hugetlb" etc.

We could add in the future

4 - disable guest_memfd (just some random example)


Then you

2) Changing the semantics of the value "1"

IIUC, you are changing the semantics of value "1". It used to mean 
"SOFT_OFFLINE_ENABLED" now it is "SOFT_OFFLINE_ENABLED_SKIP_HUGETLB", 
which is a change in behavior.

If that is the case, I don't think that's okay.


2) I am not sure about changing the default. That should be an admin/
    distro decision.

-- 
Cheers

David / dhildenb


