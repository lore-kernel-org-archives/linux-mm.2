Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A35A9CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C6D58E006F; Wed, 29 Oct 2025 10:14:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09F978E0045; Wed, 29 Oct 2025 10:14:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0698E006F; Wed, 29 Oct 2025 10:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBEF08E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:14:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 90AE088865
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:14:09 +0000 (UTC)
X-FDA: 84051346218.24.1718519
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 34ECC1C000A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:14:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pd1djTV5;
	spf=pass (imf20.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761747247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oz02NyUjFvvwgxoacij+FT8GFgL/ftCgtOYuG6E4VVc=;
	b=PWGQ1H80Yy4GpRZJ79w9iHoccP0ayiwAwh3LXsQ0oZe8U2LH1x7Shhu7pjO2Nj7VeX7ndG
	kh733c31IGRVakDP0T97o2lJhlDtXz88YHvgfQHJ3kzIDG3f1kuaD4JZjncW9hr4BLN9k1
	B3l2RvGe8SWJgk3UmTDL6G4ZUPmsu48=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pd1djTV5;
	spf=pass (imf20.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761747247; a=rsa-sha256;
	cv=none;
	b=y6i3nJTUQbPss0+XBTdPm4jZ4aAs0y/NhtE+tL1Ryr8OmqsdOk/nfnMsKuVuaFHNPIFwq1
	6xcS4lm5nUnO39I8rb65X0SZzYBRYIh0jp51VfbIsBpdx0P0EmEJ405OLOzjWNb6LntjYX
	SMB1AEotEiHdv2hNlklhkfLFOCxvpL8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761747246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oz02NyUjFvvwgxoacij+FT8GFgL/ftCgtOYuG6E4VVc=;
	b=Pd1djTV5UTTHtn+bbT70Kxjl08WjydcmL0ZwDbEiKr1VoFJDa5v32DjLRVRbZuANEtKEUH
	pDAMmzdFb0KKgoyXPbHNK/Y6apskbdxXkWorl1KFiN+nRpHynYBIMraNclg10kX+LIMcoK
	LKx7eDO+Y6vN6D9GmgvTc15Py7yZrGM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-sxEyRprAN62YCyIiywIQOA-1; Wed, 29 Oct 2025 10:14:03 -0400
X-MC-Unique: sxEyRprAN62YCyIiywIQOA-1
X-Mimecast-MFC-AGG-ID: sxEyRprAN62YCyIiywIQOA_1761747242
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3f384f10762so4516005f8f.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:14:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761747242; x=1762352042;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HYXy/T5OYgT19DHuKKWwDf9vfL9WSRPLsc+nPGT92ds=;
        b=k/YJ5GUSrAYfPoPuqci6VSZGPAKvQOhReIz1ZxqQdHvurDH7KrOZdiROmcFz+NJY62
         /sWU/RR1imzKkBoBBuXZx+Jszp6mCz5qSm4wEtctQzs857CL01wOZIFHHlYJMfaND24b
         oCHwEe4qEUyUXgRBs/PUm0ab7Q92hiaavU5xn2xHQbqCXBWfaPci6TJMXjRv3SfUYZp5
         TzkpsuA9ZZZApU2OBdwYjLw/UOmlPLwSG+j4lCbAGjUtZns4nBAmwdmHxNGN+1GYqBAY
         Y6hI3KpYM6iU7rOg/TZ+hkyzYqIVKxzS0QQpCEOD/d/yO1TLVribCxUChPAxwrHXhXe7
         vG2g==
X-Forwarded-Encrypted: i=1; AJvYcCV1/C2GySD2zI9o1Bq2ZV2mdoKrx0zB8aKOwmQm/Lj4HxZN2O9jP+a2iSufIl1qltWL/rMVk7CNrQ==@kvack.org
X-Gm-Message-State: AOJu0Yx9mL5ArAUpscx51yeZCLvHbrpkg+wy/fqHJPVSMnVzMNgidDAF
	rtEesUqFaqypXTMbYi/rjAclXJHaaXJVQeJX+++mjN6ThxXbZCXBBqNYKtSeDiJRIHvus1HPLEE
	Nbw5lYSawo2ep9pICLsHUNEXAnWI46mVliRwtn4V2suDRjwegm1wn
X-Gm-Gg: ASbGncvO7pvdn8oPqZIjqLc8oa89FVec7A6OvmPlCBVMGKSXep89uhx+vmbXZ63APuq
	xnD44bZpW1OusxZerhuWUP2FS0IcUEHHe3rlIBn1WuwCepEENv4gq8gPMPLnZd23/Ucb6GiBYfr
	N80pHxmg+di/ROasfMq9Cq9eAW+uAtjTCKyPk6uYWOx4uqdzpjag7z7boNUSHymfG+G5NSQdbXU
	GcmaCUOvfQyVYAn0zvah6vGItGdd91Lxmfx6CPtZ03AwMl66sMAR1Bl6vOfoFHeSrWhlw6mkPeK
	SuyZnaji9jTQbdqYhTMD398uTu6QrQX56FKpENMMNv0kGsCqmXEZwjhBuW6V3t/iYDzsPAVFYIk
	U08WA2ONvRdCgrsA0MT9q1GTuPxOMybRayThF16bJXfpln52kljoMvMfRnLov
X-Received: by 2002:a05:600c:b85:b0:476:57b4:72b6 with SMTP id 5b1f17b1804b1-4771e16e83emr30986195e9.8.1761747242015;
        Wed, 29 Oct 2025 07:14:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE2ZXdnOISpERgBiJ9ZdxsqH+M706mFK4IVywCP8xRKb07Mt6iBAhayCrF0GEYoqONAFcNsMA==
X-Received: by 2002:a05:600c:b85:b0:476:57b4:72b6 with SMTP id 5b1f17b1804b1-4771e16e83emr30985385e9.8.1761747241429;
        Wed, 29 Oct 2025 07:14:01 -0700 (PDT)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47719004d79sm45516125e9.5.2025.10.29.07.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 07:14:00 -0700 (PDT)
From: Valentin Schneider <vschneid@redhat.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
 x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>, "Paul E. McKenney"
 <paulmck@kernel.org>, Jason Baron <jbaron@akamai.com>, Steven Rostedt
 <rostedt@goodmis.org>, Ard Biesheuvel <ardb@kernel.org>, Sami Tolvanen
 <samitolvanen@google.com>, "David S. Miller" <davem@davemloft.net>, Neeraj
 Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes
 <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, Boqun Feng
 <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Mel Gorman <mgorman@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada
 <masahiroy@kernel.org>, Han Shen <shenhan@google.com>, Rik van Riel
 <riel@surriel.com>, Jann Horn <jannh@google.com>, Dan Carpenter
 <dan.carpenter@linaro.org>, Oleg Nesterov <oleg@redhat.com>, Juri Lelli
 <juri.lelli@redhat.com>, Clark Williams <williams@redhat.com>, Yair
 Podemsky <ypodemsk@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>
Subject: Re: [RFC PATCH v6 27/29] x86/mm/pti: Implement a TLB flush
 immediately after a switch to kernel CR3
In-Reply-To: <aQHtBudA4aw4a3gT@localhost.localdomain>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <20251010153839.151763-28-vschneid@redhat.com>
 <aQDoVAs5UZwQo-ds@localhost.localdomain>
 <xhsmh3472qah4.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <aQHtBudA4aw4a3gT@localhost.localdomain>
Date: Wed, 29 Oct 2025 15:13:59 +0100
Message-ID: <xhsmhwm4dpzh4.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sNjoNzKE9JOnk-qO50F7Fgc9FYM2324Z2zOlS9MOuVY_1761747242
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 34ECC1C000A
X-Stat-Signature: 374r7y54dz341q3tomuesah5yzmad5fy
X-Rspam-User: 
X-HE-Tag: 1761747247-210893
X-HE-Meta: U2FsdGVkX1/MSgpLiDe2hagT3xckf54GWoVfWMIw0v3lauqt04kPYE5RpFDKgARlpAHJ05v2uJXmuf9Oww0dDXvEzSxXrr11T0uNdUVoI9SWgaWSNPtfsB6g4b3CsLtiQuIeHd48cDeg3O6tHtSX3Tp50SpzX16JWzAm/+jJ1UoChLnX7tdWHe7vFILErNEekbRLCdWxbmq6HicdvSmjWlB7VOH+Mlxwg3UcxBboFhAq+cANeFp9z11Z0Krf9M1HVHEFqIjpRfXq6OEUph3zp3oK/kvHiG5kx9SrzLUlC+LIpHVohfDJ19EQxCUE7a4Qz+kurB42C0iVmU+aclP12whHShqNbAViW5q4DA8vEqdjPUUjnVMZrjVQ93uNTQgEvBd1N/a4zpP7DOnuA2QEhsIJfz8ZIcUM4o7m4UXkI9TRGvMnLYyLfNe6R+2Hxkogx71g34grGvRfsTLBie2d376nUY6MnJg17roKVIdZUEbgUKK06St+3fft5iWDZ7CsE9Ek7rZCne1xlEqSqILNO/3v8ifvoIbbNpzeRiHbqygiZBPvQ13Mx+oaO7xFNhHjZ6JQp/8jw9guPQN+P3qqaWYwd91YIY9IZU5mpZ7+M/R3GQSY8NL5UTYQLw2d/Y8YixS27+B0jCUw5yFJPRmr42Z02dMgCDB4pluG8ojfvxQWXgArmmEQtP+Cv9NUo2mqc2PqrxpZypc9tBBhFYkSnbzSWNzUh/oaYOpqAP2AWrPMbsG5QQE246TllB+51sxO62XVMiWJcHR3jaDhxZr0dqPw8bLcOBHDZaaH5M4NwxPcZMNN71mQNfCZNfDqJM8otkvOc5zt1ewxJg5yNG8lOz0g8bK2yB9k5ffdtwEST3CTKkDHJ5lmOhLz4q+rYbu0/Ilp7S+2C+FvZgPAlLD8qUalenj0tPfkbK7z/9bbMobswG2Mfc7hLpFi1Ujn7/zNfCrMUepBn9kfV2iroUu
 yNzKFDqa
 /AL3YVR7wyAmTNJe7g18E4AkP0/euENhLIRT8bnKQC8o2Zt+uDngK/M6qrA3uMpysIQVY59sKlKTHHaoqTeoVOZQwdCccrUB03/GKQV6OK4a+HdTNpq6nD/xCV5giKgHllQyWXP/XYOB8RpeCkeAwQSN7mx53zBR0UqzUX38KrOsGe7M+f1L19HnblbP6WHcNLOZF509KSQnxYYaaINpmWoUJNQEPYBSQXXii3U9Ob82zebSf4MXYFIU5GD40SMIZ2Z4QK1XgsYgA125LnT2uG4QyWixr6VPy1lkroZ4KKbPco69uGr/O8kOBqBDXmW1kLOJyWbMqE1WKtuoCyBmhQ5C/8E+6dHy9PU68c8cWnb1Ga4lskzyaAtcYfAGc1A0WZPxvrZQBqXlLuPkpRv1JfDx7YXEWnf4LS7hiwA/42Nn+rhjQGxdsaA0zn9N9qjFg4DxQvAOfYWAVGQY2D+LOU1k2Q1nc2E6UD3VBrLRCEnpQ28xSTvWnm+dyB/DL+Dp655GlBaQgplPfPnUthnI56M2wWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/10/25 11:31, Frederic Weisbecker wrote:
> Le Wed, Oct 29, 2025 at 11:16:23AM +0100, Valentin Schneider a =C3=A9crit=
 :
>> On 28/10/25 16:59, Frederic Weisbecker wrote:
>> > Le Fri, Oct 10, 2025 at 05:38:37PM +0200, Valentin Schneider a =C3=A9c=
rit :
>> >> @@ -171,8 +172,27 @@ For 32-bit we have the following conventions - k=
ernel is built with
>> >>      andq    $(~PTI_USER_PGTABLE_AND_PCID_MASK), \reg
>> >>  .endm
>> >>
>> >> -.macro COALESCE_TLBI
>> >> +.macro COALESCE_TLBI scratch_reg:req
>> >>  #ifdef CONFIG_COALESCE_TLBI
>> >> +=09/* No point in doing this for housekeeping CPUs */
>> >> +=09movslq  PER_CPU_VAR(cpu_number), \scratch_reg
>> >> +=09bt=09\scratch_reg, tick_nohz_full_mask(%rip)
>> >> +=09jnc=09.Lend_tlbi_\@
>> >
>> > I assume it's not possible to have a static call/branch to
>> > take care of all this ?
>> >
>>
>> I think technically yes, but that would have to be a per-cpu patchable
>> location, which would mean something like each CPU having its own copy o=
f
>> that text page... Unless there's some existing way to statically optimiz=
e
>>
>>   if (cpumask_test_cpu(smp_processor_id(), mask))
>>
>> where @mask is a boot-time constant (i.e. the nohz_full mask).
>
> Or just check housekeeping_overriden static key before everything. This o=
ne is
> enabled only if either nohz_full, isolcpus or cpuset isolated partition (=
well,
> it's on the way for the last one) are running, but those are all niche, w=
hich
> means you spare 99.999% kernel usecases.
>

Oh right, if NOHZ_FULL is actually in use.

Yeah that housekeeping key could do since, at least for the cmdline
approach, it's set during start_kernel(). I need to have a think about the
runtime cpuset case.

Given we have ALTERNATIVE's in there I assume something like a
boot-time-driven static key could do, but I haven't found out yet if and
how that can be shoved in an ASM file.

> Thanks.
>
>>
>> > Thanks.
>> >
>> > --
>> > Frederic Weisbecker
>> > SUSE Labs
>>
>>
>
> --
> Frederic Weisbecker
> SUSE Labs


