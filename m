Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BE43FED9E3
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 15:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F115A6B0088; Tue, 17 Mar 2026 11:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2196B008C; Tue, 17 Mar 2026 11:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8776B0093; Tue, 17 Mar 2026 11:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD1BF6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:08:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83388B7A9B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:08:53 +0000 (UTC)
X-FDA: 84555887346.11.E1082AB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3C5D3C0014
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:08:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DrQ0Fuuo;
	spf=pass (imf28.hostedemail.com: domain of audra@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773760131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4GR98Iuqt7XunvK/D0lZVC+JOV+h/F1TlWUdvlnrG74=;
	b=yK21qcpVK5gDSWh8PQfbzr/7o86PsLo47YHXJUPRT2DxiT1d1sacUnoNEqnRv76XrwxrGC
	Zv396WR73Q6lQLFAGb0p/4PQEaDBkoVr9S6GJjGy1Suhlt4MtPPqwl5dMrdJwkYHE1fQNW
	hfNvWEzv645COO0y7hxKDfzXZCdeZG8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773760131; a=rsa-sha256;
	cv=none;
	b=vGDe2+EjlCeF7j4qy7xDi8P8cydW0dJFleMpH+IC/fGy6y/pjEhD3Ndfpi78lrb/D/KRmD
	iy0plQWQa9L4JxcG+LMco2iGkOQYYt9HFYxq5e5RuaP29eGpKTO0ZGq3AXbinc18FF5ps/
	pW29e4mgVUv3mxrLQb/GFSZYWHs9GcY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DrQ0Fuuo;
	spf=pass (imf28.hostedemail.com: domain of audra@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773760130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4GR98Iuqt7XunvK/D0lZVC+JOV+h/F1TlWUdvlnrG74=;
	b=DrQ0Fuuova1lMGPznQztgxJEIi+IFwzxoQ3Kg6jmgY8MRXXTELGZbWZjlP/k2wHaMJ2FaU
	LTOMkKFOGs5iomlFqVbWdw0R/HD7vyP4BdgMJQQs1QofOdmzTDRO1OpuGNdQwh/jWjtJb4
	bYMGpy5KE+/gVP3cH52pA4upUoHEkzs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-jb3R1-qHPtq-hR_gdhRPhA-1; Tue,
 17 Mar 2026 11:08:44 -0400
X-MC-Unique: jb3R1-qHPtq-hR_gdhRPhA-1
X-Mimecast-MFC-AGG-ID: jb3R1-qHPtq-hR_gdhRPhA_1773760123
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B05501956055;
	Tue, 17 Mar 2026 15:08:42 +0000 (UTC)
Received: from fedora (unknown [10.22.80.202])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B2A41800576;
	Tue, 17 Mar 2026 15:08:40 +0000 (UTC)
Date: Tue, 17 Mar 2026 11:08:37 -0400
From: Audra Mitchell <audra@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kselftest@vger.kernel.org, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Fix soft-dirty kselftest supported check
Message-ID: <abludfGu4upPcyRI@fedora>
References: <20260218184210.206466-1-audra@redhat.com>
 <c1b6f8eb-602b-4306-ad60-7a181fd94a45@kernel.org>
MIME-Version: 1.0
In-Reply-To: <c1b6f8eb-602b-4306-ad60-7a181fd94a45@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: AgeK1_8YEz45HDJKdAdxHgtQy6My2ywrdohM4IiZ-98_1773760123
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 1e7oo4cfzffafh4q4cgtqm4nmf9it4gz
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C5D3C0014
X-Rspamd-Server: rspam12
X-HE-Tag: 1773760131-646357
X-HE-Meta: U2FsdGVkX19jQbCi5q7Zi91jcQf3rojJGtF7mL2wsQ1ynqZPZBXRUIasNvga/4dovYu6C+Rxl67QNpWowPf2bTSAHYBq8EXnMY7yEVq3p03WlFNeR/8Z8PFKzy7w5B0NVoK+jSu1yF6porrai2WUZ70+myhNj6pkeVDknohH7iQIpn8NUADxuEwHIL7N0orfShzqxJCwmzDj/P9V6SWVWnn0MkEywEL99Y7Xj9jBZsFqVjpzUUKR1XMBWqyNhRo55BViVn6beK5SbkEH7HZO2yBHXZncXf62tgbs4ovnCu7c+I/YsWz6edADyLsi1W/+Z/BfCl9BN3gw/75Hus9RLpDlaa7NSuRYxNyc/3D68GsCOkqEOF9hrVPUwRb2EiDCCPE4qf14TeYVxhuvsp7uNINKX0DJhjOvGES3Rec1boLYkqeEuMiLBDwPyYyNIBPdCMUOmxtInGFYOxwR/7ogvJX8M6MEKCbCGs/pApUWVxDUzQQefja01ezXUjd23EfmGLKaDdNAcmP5HMbod2LpfebSdJk2Hz2we+A8gAXyREu2E9BgwIwIQmMeLu6fnawA/fLlIk6GvjkjPYuBG2p46Fddm0kS8/zsccLPr1/JUYpCaWYkEsQJGLPj7GOG8HvYGSvZHqCgRDaJddB1OwkWwlG0GxHP88A3scQZUOl1s0vlknXPsI4oJ5xV2o2tQbGyKkUsAMvw6MI2AB3vnvvdU9gTaGywY+NIgXWwzco9aMdmdO53hb2nURdArLsI5lh7X1svAiV02TSm97cMUoMd9JTh5g3smX5TrSaPb1oAmadfNf4K9D63gRSO1UuQSdXBTDezTQ6qtBUNSZVJp0INrzfU0Q6yrVwFI6zNGRqzxp88Hs1MWW5fYBtkL6VI8pWluSIZW2JlXBR2bQbXl6aQTnXbIBs28gpfuMsEqb3qzZ68GH4cHndmRgHItd1IpSMfvLgQPUhcP+GYenbFbv9
 I+EuliC4
 E5wr+7SkLwiJCWeyuhldMWvTwCGUFJ06lHJOIvNwlxz0RfGH9QrpXUC6+O4SG6Zod4hZ+MLJztCDH0AZUasqRhWxL5694LlYH/g/DolP//xqpADlfInRVz4Im0zJQsWDF03zl0TDjUZol/aRY+m2OFQdF+846IqbWM7hi4rx58X0X8JGlh65QeuDlHG8n44Ht8Fc49/mo++Jr4hVAUdqLtwMlZWNX2wm6uSdKrMeTiiVTRsscxittOvOS8CI2dxQBm0BKQFKVzRdiYjgPJMnI5idZxKxIisxGx3sk1IDLNlia2CcBE/SisSrlBInp10eOVfW9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry! I missed this email so never responded!

On Tue, Feb 24, 2026 at 05:15:14PM +0100, David Hildenbrand (Arm) wrote:
> On 2/18/26 19:42, Audra Mitchell wrote:
> > On architectures with separate user address space, such as s390 or
> > those without an MMU, the call to __access_ok will return true.
> 
> Where is this __access_ok() you mention here? Somewhere in
> fs/proc/task_mmu.c?
>
> Where in the soft-dirty test is that triggered?
> 
> I'm wondering whether the soft-dirty test should be adjusted, but I did
> not yet understand from where this behavior is triggered.

The problem arises when we are checking to see what features/categories are
supported. The call chain for the soft-dirty program goes:

  main()
    ->test_simple()
      ->pagemap_is_softdirty()
        ->page_entry_is()
          ->pagemap_scan_supported()
            ->__pagemap_scan_get_categories()
              ->ioctl()
  
We enter the kernel with an ioctl, expecting to have an EFAULT returned (see
the comment from pagemap_scan_get_categories():
    
          /* Provide an invalid address in order to trigger EFAULT. */
        ret = __pagemap_scan_get_categories(fd, start, (struct page_region *) ~0UL);

Once we enter the kernel, we will check the arguments passed which includes the
call to access_ok: 

  do_pagemap_cmd()
    ->do_pagemap_scan()
      ->pagemap_scan_get_args()
        ->access_ok()

Here is the path within pagemap_scan_get_args where we expect to fail return
the EFAULT:

        if (arg->vec && !access_ok((void __user *)(long)arg->vec,
                                   size_mul(arg->vec_len, sizeof(struct page_region))))
                return -EFAULT;
                
However, if CONFIG_ALTERNATE_USER_ADDRESS_SPACE is enabled or if CONFIG_MMU is
NOT enabled, then we just return true:

        if (IS_ENABLED(CONFIG_ALTERNATE_USER_ADDRESS_SPACE) ||
            !IS_ENABLED(CONFIG_MMU))
                return true;

The intent appears to be just getting the categories available to us and
verifying that we have the feature available for testing. However, this corner
case means the soft-dirty test will fail with the following:

  # --------------------
  # running ./soft-dirty
  # --------------------
  # TAP version 13
  # 1..15
  # Bail out! PAGEMAP_SCAN succeeded unexpectedly
  # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
  # [FAIL]
  not ok 1 soft-dirty # exit=1
  # SUMMARY: PASS=0 SKIP=0 FAIL=1
  1..1
  
Since the intent is just to validate that the features are available to us for
testing, I think we can just modify the check so that we don't fail if we
return 0.
  
Let me know what you think, or if you have more questions!

> Do we have a Fixes: tag?

I always hesistate to add a Fixes tag on situations like this since this is a
corner case that was not considered by the original author. If we need a
fixes tag, then it would be:

Fixes: 600bca580579 ("selftests/mm: check that PAGEMAP_SCAN returns correct categories")

Thanks a bunch!
-- Audra Mitchell


