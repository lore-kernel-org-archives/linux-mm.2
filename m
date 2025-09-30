Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCF8FCCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 15:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 198FC8E000C; Tue, 30 Sep 2025 11:32:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 148648E0002; Tue, 30 Sep 2025 11:32:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010068E000C; Tue, 30 Sep 2025 11:32:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF5DA8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:32:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A5E4713BB1C
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 15:32:37 +0000 (UTC)
X-FDA: 83946308754.08.59DAFA7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 46C21180015
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 15:32:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JjnTwAta;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759246355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dV+ycWrFzskPSnB+QMwZi+hj6ppbWIqN7KMrO32+6zE=;
	b=OMMPr8NA2J3+laUtfL6M2z/zKrE8QuDem63KV14O5HtSeWOvz5bzDJfuAo3+2Zht/j3+HM
	VCRwjlv6E5tfckLnWuVwYOGvVpkHRTPe9FBT6/A4WkASVi0Sp4OBSHyCJTXP9ZAepGZXVQ
	Xs08BufsHoppe542i6h45tcWO9Z+8cc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JjnTwAta;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759246355; a=rsa-sha256;
	cv=none;
	b=eqQp7iFcXEONtcvsj+akw4j6u8ogQsmi6qEXU694IF+Uv9D87QGtFKLzvP9YF5efGRNpXF
	V832DJhDz8CK8g6X/78WLGWzIQ3wxEC1SSgXj+mZeYl53vNii+XWtd44Amf39hxdQTliZv
	GFP0JyTmyhggKmaP2SAsdD7nQhsVUfI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759246354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dV+ycWrFzskPSnB+QMwZi+hj6ppbWIqN7KMrO32+6zE=;
	b=JjnTwAtatppn8ZzeedkmDvdyCpOGqWWZF63/2qTxVVcgBTpzF1VFDX0DXkrwkE/tRmf9d5
	OdH8eqErOMfR+x/zZ+mFlh9q+IKCdhOlWj+yPSThJhlWIulY5gVRFF3KWSvlVeKg2Z8fS+
	jQmLqaiJf0CJYrrnz7qKz2l9BV6fJdo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-Cmfy8c0eO_OortdnhuVnnQ-1; Tue, 30 Sep 2025 11:32:32 -0400
X-MC-Unique: Cmfy8c0eO_OortdnhuVnnQ-1
X-Mimecast-MFC-AGG-ID: Cmfy8c0eO_OortdnhuVnnQ_1759246352
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-78e45d71f05so12405626d6.2
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 08:32:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759246352; x=1759851152;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dV+ycWrFzskPSnB+QMwZi+hj6ppbWIqN7KMrO32+6zE=;
        b=vK8Jp7uW3Im0SUew412deVg6xaUpVP67vyF09yUEmQA+dtkgVJXrlhqE0Ozv6t9oBP
         aorz+jPgrN2nSkd0RL79SCwijosLTv3dRIAYAuBB5WXvROmF34rrlIf+C4RnoCBYBr1f
         WQFu+CfOGwCCF8VJnvDgGjP+w777dqQdAoJviTH7GEM88aotmlfEZ2S64ZDcN+8K7YIZ
         9zlA2HetvdoFlxt079llYR7lIy8N3AwLbgd+5SUf6Dqay1sc74k6d0SQYrqEHfxkJFfR
         92OoI+SA+psjZEdZ1pBCgEeHzwQTMKp++J6tBteDhe57UmZjXFhU4a4evjVprEsJzIQV
         CIZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwFXZqWDw22GX6Idi44GbRXS6aICo1Ew0pvgC903yBXFsdjqDECrmt/SwEw4T2/xr5pJGgSOjnoQ==@kvack.org
X-Gm-Message-State: AOJu0YxK11LScmevHnQ3KT4X/ordZFLohwYmnIDL5HqxKbv6n40jCSYh
	rV0h7PJeBc4dTtuZ9jSjlW6GciNMZl8EZ5IC3GjeSMkqmuMU1tL5YGyYp+A9/zC1X7Y+pIrcuv1
	86BHqVGALvjuQlibRExv4hl3sT5P8oj2HVV7TPeY2glLqTnMXSwkF
X-Gm-Gg: ASbGnct78yuv2a/a3/CJtsrAdemPZtFmWA1pI4Qs+SfYhrqIBWXm/V3Zn43JdXGy40l
	5ARV717b82z75U6sYwxHQdhIZI3x5v+e67awoZ2vPXVIo59+CdXTuiFv4bXFPs5PW31RWwUhVAL
	QcD9WtfoM5qJlw5Hv0aS9V1LQ8n1rEYdonP1xFGeXWBXaQkee/hEJzMH/OdzrIddd5sy5FUIwgs
	DotHtr3+ZezxyegAK4AFCPfMvtESjeGOJBdCiVUZMvgDoCv2h4KBz3AvTr8+QkP4bAWjzAAXENJ
	JT1wK5D5cdRvL55Yx3DbX8Ri4hiCsjXw7bLksZj7PhEINIYsYpNTFgNeRY8Z4UFDYuD0GoOjaJj
	E1Vbxs54H
X-Received: by 2002:a05:6214:f01:b0:796:b86f:3eae with SMTP id 6a1803df08f44-873a5d20212mr2738626d6.36.1759246351731;
        Tue, 30 Sep 2025 08:32:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IES/v4bj9W83pQGqcZwESU2U5EfK7XpZkH9/GTodnY1llP4rsL9omYr2EEEfFJNXwo1h08wLQ==
X-Received: by 2002:a05:6214:f01:b0:796:b86f:3eae with SMTP id 6a1803df08f44-873a5d20212mr2737916d6.36.1759246350904;
        Tue, 30 Sep 2025 08:32:30 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8013cdf14ddsm97613996d6.25.2025.09.30.08.32.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 08:32:30 -0700 (PDT)
Message-ID: <85f852f9-8577-4230-adc7-c52e7f479454@redhat.com>
Date: Tue, 30 Sep 2025 17:32:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/ksm: fix flag-dropping behavior in ksm_madvise
To: Jakub Acs <acsjakub@amazon.de>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Peter Xu <peterx@redhat.com>,
 Axel Rasmussen <axelrasmussen@google.com>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20250930130023.60106-1-acsjakub@amazon.de>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250930130023.60106-1-acsjakub@amazon.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 60NOWmqlVWfFq2F_lQBc6cH2R9SGZ3YtQlMvm9A4iks_1759246352
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 46C21180015
X-Stat-Signature: zux9t67oqph8ncp5pemfr3rw416n113w
X-HE-Tag: 1759246355-459439
X-HE-Meta: U2FsdGVkX1/8V0LoNbJyxtB4+3HgrK7rjTlZ6s81NhjdO/xUqc/3xwPhn3LkpYvhXPZs88BqE+xIqsDsnXmVnuTMCJNNGSY5elkysiL7AyD7XG8nYYabD3AYODMIdmPOFo6icTyADxTuad23MT+edrHJ/h+70VLeNqA9mZZ9v87D8anFSdp7OtssRxlpB7pPRkzK1ZK3Cd/fsbxzVOwXW6z+DoxNbOyyVJ1FtDQESdjJJ529j/7qRpxjZOlF+BFbizAo6B3Zxq485mxvZs57Il8S845ihMrsGyxnBQbulLyxQhgw10Axvb/OZhwrkAtmSaGrcgknrMpZxNdU8kxQSw26KzvxUMgEbM7gGDj6Y44t8VO0hx3A/ee2ZEsEkm39t860GeYMsHRnszqY2AGSld9poE/GYulFzy6RDhjp/fGGh90QPv1C/lpop81Z/00kB03DeXNg//DQcq5YCEFyPrrmHKvrZKaYiHXLx9VG2PI9ECgr7gePoZAp7ksMdLl5HAyJXqgLA0e8iIbRz+Djyftd064hdgrtmiAU6XIWTzKM+cT1II23yIPCkXqjOkKedCrbWA+WIOt3egA0s0oIr2SH9gyOPL3vd6snA/LH7KLfGM94a1FiW50SHQVsr+kuxSAvg6YK1ls6oFbdkA/sqE5Ggu67+RJznLNOkrGAi9cPvVAZlY7WRG2+j/czrJ3E73VJoW5H9UZY6aCxGF7XQmecZt1ErxSkbhCmON9CWg+Z0hIaKmauGNSgj0+wiV8t8tPw6Js/+HqVfA/4FJ9ofqshuB2UN7ykr7UT1pX1k76xPSwx7db0rqXJk5vNgMYjl5/gQk+akM2pI2zE8aQIR3s5clbNZmfzfXxxuj1yIFmrrXbYlA5wirfBSCRzEzWsKmO7mi9zmjntYuNhp+j9SmuuThZYXQkCzsWIQKlXp1/rj4lBCfavd/g+o/ERYBUQgIWfkdz3HC6r/XwQYNm
 j7reFhja
 KYcxUSKK4t/8LdflNL7IT9fCoucToHiCMHt4ArOBCRG5LD7L5Ox18AJTT6qbYw6q4ajYDMj6KHsewR/YscCg/H5w941MmhsG0NRGugBLHoDK3O7dHyoFgd/kM+7XyOdynm4G3GvXnvgotTZGfsQpO/oDVjV4CdkTsHWnBzwn2ZsfJC9VpFW284OlpysUu3RTP9RzYARWej+9MMUIAPt7PotdwBafz2iah94S8Ez4IdQYThUsl170o36KzAHQoG8rOyYoQ2Uz3vtdsTyhjOrfsGp0ybQw0tXGLh9vtbv6pS/H5XWz8RtWBDIE1c9ZVBceG2GwZR3x4+pN7kAQALVhKrW9eQJxQRvrnyw/Ignf89D4x6n9LPUvFGyNeRaCJWjM9UL59BP+Lq4vymnM3758CPkOyw+mI4KUoA2uX4tA7mQamSALvxz2Pz6l+XXIW2wx6BP0lkI4MVC7Kg0tD8WO3TcV8A5LMHUFSgY6G+clJWlVGm2r97f2xoqOd38hMY9anOXrvi3URlANvS+5zg3b0xKXXx91t9RT8RY7zPySg17nkjLn3bX6TkLdlZEt/Wkut/2d9FtkL1tWsk7g9slMkbkmCT4hypwqEne2hhzUR8IAmSjqlkDbUKADhZOrXov+UZtegGWnDF1F3Pe7klMgaxwbpkD6TMHxQtciY1xGk3r7RKHHc6Fj2Gj8ph3jEnMEanLjlLcQHJfXWFogcMUdvEMaxDpvY1zyQRTJtV/dJNRjkGEDb1ErnUdSGz8ESvjOhking1Wa2Srt8jG6NcaEg0LEZ/0ZWa1z6jVTDYh7eYkrWIigWumilk93vMrwGgpwj1cDuERGDpYoFpqVIfQHJ80ox8sMvo0r+DmN/eZ+6qT44jCs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.09.25 15:00, Jakub Acs wrote:
> syzkaller discovered the following crash: (kernel BUG)
> 
> [   44.607039] ------------[ cut here ]------------
> [   44.607422] kernel BUG at mm/userfaultfd.c:2067!
> [   44.608148] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
> [   44.608814] CPU: 1 UID: 0 PID: 2475 Comm: reproducer Not tainted 6.16.0-rc6 #1 PREEMPT(none)
> [   44.609635] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> [   44.610695] RIP: 0010:userfaultfd_release_all+0x3a8/0x460
> 
> <snip other registers, drop unreliable trace>
> 
> [   44.617726] Call Trace:
> [   44.617926]  <TASK>
> [   44.619284]  userfaultfd_release+0xef/0x1b0
> [   44.620976]  __fput+0x3f9/0xb60
> [   44.621240]  fput_close_sync+0x110/0x210
> [   44.622222]  __x64_sys_close+0x8f/0x120
> [   44.622530]  do_syscall_64+0x5b/0x2f0
> [   44.622840]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   44.623244] RIP: 0033:0x7f365bb3f227
> 
> Kernel panics because it detects UFFD inconsistency during
> userfaultfd_release_all(). Specifically, a VMA which has a valid pointer
> to vma->vm_userfaultfd_ctx, but no UFFD flags in vma->vm_flags.
> 
> The inconsistency is caused in ksm_madvise(): when user calls madvise()
> with MADV_UNMEARGEABLE on a VMA that is registered for UFFD in MINOR
> mode, it accidentally clears all flags stored in the upper 32 bits of
> vma->vm_flags.
> 
> Assuming x86_64 kernel build, unsigned long is 64-bit and unsigned int
> and int are 32-bit wide. This setup causes the following mishap during
> the &= ~VM_MERGEABLE assignment.
> 
> VM_MERGEABLE is a 32-bit constant of type unsigned int, 0x8000'0000.
> After ~ is applied, it becomes 0x7fff'ffff unsigned int, which is then
> promoted to unsigned long before the & operation. This promotion fills
> upper 32 bits with leading 0s, as we're doing unsigned conversion (and
> even for a signed conversion, this wouldn't help as the leading bit is
> 0). & operation thus ends up AND-ing vm_flags with 0x0000'0000'7fff'ffff
> instead of intended 0xffff'ffff'7fff'ffff and hence accidentally clears
> the upper 32-bits of its value.
> 
> Fix it by changing `VM_MERGEABLE` constant to unsigned long. Modify all
> other VM_* flags constants for consistency.
> 
> Note: other VM_* flags are not affected:
> This only happens to the VM_MERGEABLE flag, as the other VM_* flags are
> all constants of type int and after ~ operation, they end up with
> leading 1 and are thus converted to unsigned long with leading 1s.
> 
> Note 2:
> After commit 31defc3b01d9 ("userfaultfd: remove (VM_)BUG_ON()s"), this is
> no longer a kernel BUG, but a WARNING at the same place:
> 
> [   45.595973] WARNING: CPU: 1 PID: 2474 at mm/userfaultfd.c:2067
> 
> but the root-cause (flag-drop) remains the same.
> 
> Fixes: 7677f7fd8be76 ("userfaultfd: add minor fault registration mode")
> Signed-off-by: Jakub Acs <acsjakub@amazon.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Xu Xin <xu.xin16@zte.com.cn>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---

If we want a smaller patch for easier backporting, we could split off 
the VM_MERGEABLE change into a separate patch and do all the other ones 
for consistency in another

Reading what we do VM_HIGH_ARCH_BIT_* , we use BIT(), which does

	#define BIT(nr)		(UL(1) << (nr))

So likely we should just clean it all up an use e.g.,

#define VM_NONE		0
#define VM_READ		BIT(0)
#define VM_WRITE	BIT(1)

etc.

So likely it's best to do in a first fix
	#define VM_MERGEABLE	BIT(31)

And in a follow-up cleanup patch convert all the other ones.

Sorry for not thinking about BIT() earlier

-- 
Cheers

David / dhildenb


