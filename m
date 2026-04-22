Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F493F9EDF6
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 14:50:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7AD6B0088; Wed, 22 Apr 2026 10:50:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A8856B008A; Wed, 22 Apr 2026 10:50:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796F96B008C; Wed, 22 Apr 2026 10:50:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 587BA6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:50:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E937A56AA2
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:50:40 +0000 (UTC)
X-FDA: 84686478240.25.113948A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8D2D9A0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:50:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dQEiK41B;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776869438; a=rsa-sha256;
	cv=none;
	b=MKE9Y7PgXQbzXTjNfBfSmCPKTZHY/02cDKg+8LyezDHhOVELYjJDECG5d59BpTAdemtMpP
	jkHhAvjtp1IiZBCx3xeiEdQcypgnGTWts3ZY88kB1IMBK/ozPfL1Nxb40BNniQfAFnJJ6+
	ZEH5blP62gX6X1Nk0Iu8mBGO9zDabg4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dQEiK41B;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776869438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFunmV8UnJFrvBCFFUDwN5yy8J9lleJQHUZ0ZtV99M0=;
	b=3RAPhxQc76pDOLg3ImjtKcCW5rGP+MEqn9vABV2fMPXS4hTmBlVS/3Fj+WYHn3B0nsxCXD
	RIFRFd5DfzSCll5Gt4O7W7Ne81qcxfUK1Frd6HZr/P2/cMn1W77IhuCUh+W3DRztMidN32
	rJFLneKfuzC+2mBcNk31HY25urpNlpY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776869437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dFunmV8UnJFrvBCFFUDwN5yy8J9lleJQHUZ0ZtV99M0=;
	b=dQEiK41BXwil9XgNoedG87nh1VI0Hpwe4RWigD2qHieu0gWgzEgMkAQpTwCHRgGyQdTNP7
	JnQLcwMzlTjOiQLHS4I8zQI0QjWic322sjZ3mMHLu0M/CrDXPgP7miYYHpPurna04yVHiM
	XYr1HhdlsgULHlaDEMYA3TVsVEfHtD8=
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com
 [74.125.82.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-ZKoULItUOL6947BXTk5COg-1; Wed, 22 Apr 2026 10:50:34 -0400
X-MC-Unique: ZKoULItUOL6947BXTk5COg-1
X-Mimecast-MFC-AGG-ID: ZKoULItUOL6947BXTk5COg_1776869433
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-2de07c12745so5450398eec.1
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:50:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776869433; x=1777474233;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IoDlr13M+1WKRkUHuCCHQTA6Gku/moKFjbS9dPK3sKs=;
        b=fnY9m0+65iGGkFvVOTORUNGtkmGH+Lm1sa57sn+0VGUOXVtudbzchzDtQtVKe6NRgF
         5g78drLbRQbu9eoxX7tPvVMTR3AFExzYZpmJk8A2JmxtkHaN+EHQPtkfJ7/geK/sBDfV
         6QjB/33ZHxkaZJoTSmOQkS+wcV5uN3wEemZ1v8AnV0ioaJYa1w2LBlwrhE7UDx9Ei+pK
         gr7ZY7MaAssNX0vIGT3f9lpKAnqi3DzcISdlpCGRBPe67Yquh8oN3oNLrU0+yG6WzlzV
         M3BLh1MBjTB9HlCKa89nOHiDcrwPTdJ6PMQKDMlma7Pqk98QihW7NdtHeBWKkQfK8eEL
         Y5gw==
X-Forwarded-Encrypted: i=1; AFNElJ+Zo0ttp962CrfKW+XaR++DgP3w9t6/Z5vLqGlPRLwtWonqFCnh7+YnmBV5WMaquVF7QXpKvD6yWw==@kvack.org
X-Gm-Message-State: AOJu0YwDXJtB7SvKYegRDj5PF7ygC4HnbOjW2uwEBjFSYHSx+BgZ9d0A
	LVW3VTz57ozpzIL25ULLzaigvOuZTSeDhH4nwyq7fKN9zD2lJVNLZvZmHmm4kkDyxfQsIpjYgZT
	B6HtyqfGRYn1vvXwM+t6v+V+MwW1V89zCrNC8we8m3hYCjylivwoq
X-Gm-Gg: AeBDietz5g8vjWVmk3ccK/ShhXgpc/PWQLe0+gj4jc6Wv2KA7Gjt+JA5dfwM0av3a2i
	QFX9Hiy79nmAFV5ccEiVvxEQA0uhvVyXWBGSc1soaNjO+hCvRiC3VQ7H0cfg8nMvmQMGqNA9iP/
	sX3x52SzTEqscl5CM6p01IONcLabnfwx7ajQxI3WiHIXkGsVqfKNancqQnxrMbjjx3395PA0YMR
	NUz89IglsRRc5/xgVletqk3FwrXxVM1zxlSx9pW3iBaAKjae9V9F7b104Uerwf036myVMcN/qIX
	qHvBrLFQKuODzQju1yBhtt+isXJqzlp8qM3/uRU3I2Qi30FtXQNUJcqqfeOrS9a3aH0p2EN087y
	gwa8cUl81jEv6u1vmptYk2yZUYhD7i4Fw9BSNjiYzPjhwAyKjsot8OdUvPF+G795E9u8ng6OGdn
	5xH0FhXEl9dVQXY7nzBA==
X-Received: by 2002:a05:7300:e12a:b0:2d1:d434:cfe3 with SMTP id 5a478bee46e88-2e4528c967bmr12802136eec.0.1776869433216;
        Wed, 22 Apr 2026 07:50:33 -0700 (PDT)
X-Received: by 2002:a05:7300:e12a:b0:2d1:d434:cfe3 with SMTP id 5a478bee46e88-2e4528c967bmr12802102eec.0.1776869432674;
        Wed, 22 Apr 2026 07:50:32 -0700 (PDT)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e539fa5c38sm22845738eec.5.2026.04.22.07.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 07:50:31 -0700 (PDT)
From: Valentin Schneider <vschneid@redhat.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org, "Peter
 Zijlstra (Intel)" <peterz@infradead.org>, Nicolas Saenz Julienne
 <nsaenzju@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy
 Lutomirski <luto@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>, "Paul E. McKenney" <paulmck@kernel.org>,
 Jason Baron <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, Ard
 Biesheuvel <ardb@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 "David S. Miller" <davem@davemloft.net>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Mel Gorman <mgorman@suse.de>, Andrew
 Morton <akpm@linux-foundation.org>, Masahiro Yamada
 <masahiroy@kernel.org>, Han Shen <shenhan@google.com>, Rik van Riel
 <riel@surriel.com>, Jann Horn <jannh@google.com>, Dan Carpenter
 <dan.carpenter@linaro.org>, Oleg Nesterov <oleg@redhat.com>, Juri Lelli
 <juri.lelli@redhat.com>, Clark Williams <williams@redhat.com>, Tomas
 Glozar <tglozar@redhat.com>, Yair Podemsky <ypodemsk@redhat.com>, Marcelo
 Tosatti <mtosatti@redhat.com>, Daniel Wagner <dwagner@suse.de>, Petr
 Tesarik <ptesarik@suse.com>, Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: Re: [RFC PATCH v8 09/10] context_tracking,x86: Defer kernel text
 patching IPIs when tracking CR3 switches
In-Reply-To: <ad-Ad44-IyU-yKJf@localhost.localdomain>
References: <20260324094801.3092968-1-vschneid@redhat.com>
 <20260324094801.3092968-10-vschneid@redhat.com>
 <ad-Ad44-IyU-yKJf@localhost.localdomain>
Date: Wed, 22 Apr 2026 16:50:02 +0200
Message-ID: <xhsmh4il33v8l.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uvj9DNsbU1POdRV7jEs0_UIMYO5adDqrH8876aw_ymw_1776869433
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8D2D9A0005
X-Rspamd-Server: rspam12
X-Stat-Signature: gt1t544ryja16r96gg57k7t7z8fury35
X-Rspam-User: 
X-HE-Tag: 1776869438-203792
X-HE-Meta: U2FsdGVkX19KFu/2n/S8m2ZGjdNThJCaL/xMeO5q2p1CQTDiSackjDuW5H1g6KVLea/SNpZOh+RfbhGLxn5WrcBWGIusCV0iD4m1oZmNSVVPwHhWkYvyGOe4LuQDNLj7PuQwULetiw/FGW7htoxBjXcTZ4MlbyOlfS+tPyUQwp8zdbm3EHLBPxnR/vyi+2Ua06W5jkY/p1AnuXMOZxZq9Zx1jJQ9t514ntF/hg+LjfE2Iaq0H6RDqMZPxGl8t6WQXikFWbkd5IB9m64/cxvDYk4KDTiNWi1MVrGwnGM5wPHyN8j6+phMFTWMWwdVFyUrBaqo/p3QLgaK2LqGXtJEOq+Hq+wKB8rY0MOUFtFxJcu01jyj9SAGTYsVizwoW8x3IZNhDLVmCiY/R4PJ8IXgbN8E6YDATehYSTrEH4NL/yRIIVmbsD+rDvVoqyzhPR/SnRW1F30x4XSalMhO9Y6jrYJGMyfnRUQLvAxlSRxUxb6hu+NykxbLcun03zirknjP/HPqNw+Ub4Ff8S3SkXZHUtvS46EQ2H5IC/BHqT9+pdwK1leEMoMJUHQco7aFhfe++tsUqRfkTg3AE04ojF5DhwTyL8p+c6UXIOv6xSia+fBy0t3PMSmzFr3Km7+LZIqKfRQFt9fo3zYy5jnifweICdD9izVqYAlVMpPkGYmXJJx2c4qxDnVsxTNlK1euKXWmNLY7upVK7EBuqWs3BKQlvAorEk5dzKZZ+/sTRjxTX/ZPlrCFL7zlehvhPsg3XldVhWGD0No6IPFm/+lWHZFROoa6YYF4klPUkSGBIhKo+TSWg28F93Cz1L72i2g82VsfrVJJk0m09SIVTc2zKOwjIaFqTuKduvRkubzabBY5pYJzIsXBQl1XKX49Kell/MmaAp9Ll2MtO7Eb5w60N981GwO0Ry+5M0Qh6Peit8SGKnGUHOAKUr2wUvL20kVJkSKyyM/K7Bbg9iOCIOmib+D
 1m+beWj2
 ms/HwoBJCFPn3cOZYFsgNlTcCeR+M0+LkD9TJpp5lgzL8qf+YqBAQdn7g8LqE/0JS0H+GV3KH2Wn1RN9IVMAnmMjp319QtBaSTBNtPCGjaZDhe+4lhzL//xoSkoc1NDr3qIrqOTIkKB5/sT2vy6pu++vQ0BJs1Wfe1xbrol50m03yUPSvxrnHWX2dTNN8auoMhWmMOzBoN6DOCxyByfDSvwiHTxyMUQUG9Lw8Jp9aPw7C6VdUWtzWStSWXWcrfl+lOXK2aH0pHWKZCaamUEncBwH2YY1EKdhcsIRN4SqeWaP568n1tbPpTSD+xGDcH+9pecpzyG1Amk2x5SvZVSFTaHpWVqE1c9L1Qh/w6HuHxjh4vyA1lDt/08eGHkM8F/oL6LWbvLJUNqeFMGOfp213sQWIpe9lazj4YfyPilDsm17E39CjgTyhNkT/s8/WOEno2LnWN53SV5HFP2WpZUFvELeJdfioQZr4hkawPzOZf5/4/Kp36lGd29PFJH35Jm6Y3RhAJqG4JWhPOthdK86IbxoxBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/04/26 14:11, Frederic Weisbecker wrote:
> Le Tue, Mar 24, 2026 at 10:48:00AM +0100, Valentin Schneider a =C3=A9crit=
 :
>> @@ -2706,11 +2708,29 @@ static void do_sync_core(void *info)
>>      sync_core();
>>  }
>>
>> +static void __smp_text_poke_sync_each_cpu(smp_cond_func_t cond_func)
>> +{
>> +=09on_each_cpu_cond(cond_func, do_sync_core, NULL, 1);
>> +}
>> +
>>  void smp_text_poke_sync_each_cpu(void)
>>  {
>> -=09on_each_cpu(do_sync_core, NULL, 1);
>> +=09__smp_text_poke_sync_each_cpu(NULL);
>> +}
>> +
>> +#ifdef CONFIG_TRACK_CR3
>> +static bool do_sync_core_defer_cond(int cpu, void *info)
>> +{
>> +=09return housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE) ||
>> +=09       per_cpu(kernel_cr3_loaded, cpu);
>
> || should be && ?
>

You almost got me there, but I think not :-)

cond_func() must return true for CPUs that need the IPI. In this case:
- the IPI is always sent to housekeeping CPUs
- the IPI may be sent to isolated CPUs, if they have the kernel CR3 loaded
  (IOW accessing kernel stuff, no longer accessing pure userspace faff).

> Also I would again expect full ordering here with an smp_mb() before the
> check. So that:
>
> CPU 0                            CPU 1
> -----                            -----
> //enter_kernel                   //do_sync_core_defer_cond
> kernel_cr3_loaded =3D 1            WRITE page table
> smp_mb()                         smp_mb()
> WRITE cr3                        READ kernel_cr3_loaded
>
> But I'm not sure if that ordering is enough to imply that if CPU 1 observ=
es
> kernel_cr3_loaded =3D=3D 0, then subsequent CPU 0 entering the kernel is =
guaranteed
> to flush the TLB with the latest page table write.
>

For TLB faff that'll be flush_tlb_kernel_cond() but same logic applies. And
now that you point it out, I think the smp_mb() (or LOCK prefix on the asm
part) you're suggesting should be enough, but let me ponder on this some
more.

> Thoughts?
>
> Thanks.
>
> --
> Frederic Weisbecker
> SUSE Labs


