Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 109A2CCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F0A58E005E; Wed, 29 Oct 2025 06:16:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1438E0045; Wed, 29 Oct 2025 06:16:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31AC98E005E; Wed, 29 Oct 2025 06:16:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22E3F8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:16:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C05095B791
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:16:33 +0000 (UTC)
X-FDA: 84050747466.04.75702E9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5934340009
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:16:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Rxw0NLQ/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761732991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSbP/XItnE8Eu8etTuS9l9QrebV4lnCgmZKR5M55TVw=;
	b=q2bQVI58Vb++Et/udelDDdSMo09uMYSLm1j1Ko3P11In3JzOCxaQ2kgCKo4GEWi6EhOwq1
	WErDRmoANFclf2WvFO4+daxs2rFkgYzFKULD/u++evV3wDVAqtY6onGkGvobLBcjWqtlYx
	oCuJ5+8jczvh8Uczs7KU24FzvBZ7GrM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Rxw0NLQ/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761732991; a=rsa-sha256;
	cv=none;
	b=eWHqSfJCdf+rnZUB7EhaRz6IJh/J5R8LoROBEPM7TGDBc/W3t3Z9AxgvbsfDrBk6clHB3r
	Vyzn1a4G60X64eG13/rJEFIbbD4f3/KjVE8hGimo1nnK/Hr/6LtQUWd9liPefhO9BAAx2R
	tYCjYdtjZuHwEB6vzRWD336OtHwJrtI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761732990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lSbP/XItnE8Eu8etTuS9l9QrebV4lnCgmZKR5M55TVw=;
	b=Rxw0NLQ/alZvJ+i/TRgwVROo5tXszuKQ+ctU5HQ1KE7uwu33C5WOQC63Thq77Q53OAn4Dw
	dov50TPFYGgJAw7Tf+WCBGBw/Qr9nuxuIkI4bPqJEEZl2oXpg9/dUkkZyw5x3lEKfcvXHC
	yrqiE0PJNv6d/msIH19CxotCyu5+d88=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-d3hWEuGVNeGyaUCuVabWhw-1; Wed, 29 Oct 2025 06:16:27 -0400
X-MC-Unique: d3hWEuGVNeGyaUCuVabWhw-1
X-Mimecast-MFC-AGG-ID: d3hWEuGVNeGyaUCuVabWhw_1761732986
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-470fd92ad57so83692175e9.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:16:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761732986; x=1762337786;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/btFKEFxhLEeC8J1xdXSDjZgEcY68zMIb5ZfPzXsUAI=;
        b=vNhdV/om9Hn+0a4NjpRZAxaY++7L3QckEAt9YWkcvEaE+iTrH9/0ojJ+WQQ320daeb
         lq2IT8MJ0kKtjLMap4ZUmQbodQLXtpogCBWZMBMeOBHmNiu69nOAccdjAWmVUVvOm4Hf
         Q56YMMGdsqwshlSxf/cUvHpgP1PoMI8djIZGtNbexcwb2JFnQFX61WnYtTUlRB+XWse6
         TxND/Grt8zlB6GSfsJWMx1lyDVfldVatWYQLz5Gn42ZpQhXiFQTTdjCKDhhhaHi+Lh13
         rM/0Ck+pcd715rh/vWKU/9/b6a2y9I2BiB9TYRbO2nPGhh8tbUMEE5kNr2xpDjxWrhNk
         iZFg==
X-Forwarded-Encrypted: i=1; AJvYcCVqUKBRdZxoVLLWj5BCMqWnCEvh5EnD2vJQRJpK+27zyb4DUezlfbMkJnSWS19Mic+a94nB63INKg==@kvack.org
X-Gm-Message-State: AOJu0Yx52h+D6pZm5AngQ9O07UmTlkmug736LcpKCvRIom7L67lYHdmB
	XOUq50sdXtbnwQidqlCNQbUhVm/aS1yz8K5Sswc8/vKwfc8DcigQApd+kjJ2AzTeutVyokvWfy7
	YsmkmNQejVVTctkw8sZGSJxlIE84IWQ+AvTRYyJmcMZ6QksgCT9Ft
X-Gm-Gg: ASbGncttsz+q5PeUpO9fQ8wiebePwf40Z1fc5q/iVJEg5fry1H4uPW7DZ/aVx1XRDey
	Tnlr1K06twBKzKERRXWDyBMGJaRTYCQ9qlE/KUT4+xXXmrcxEjfOsnVa6n4sKAG7cGjq0xhHKi3
	+eSleXMFNO/nqPLvnI4jOSFYXAxMnu9FbMGVDxdmUyy2YRem0e5ezd46hdWghmApit5Hj7rCC+6
	WEOWx1KDMlh/LecVbeI/FKor6EH7aEqfA5Ivc2n2gFDJJILX/PthD+2vCeldfHVirR7ez+L5qsD
	958shTWbZbzshBWbLLZlIE0GeR2TwyBDdKqZ4h0g/rxB3dc8BSu8/HVCKiyhqzCLa9Ou+STG2sN
	gF17fIEnSXZGdL4eYGsinrsk5873qHD8h4h5vGST5SjY5WJRjhgMYV0FN2qLi
X-Received: by 2002:a05:600d:4398:b0:475:dae5:d972 with SMTP id 5b1f17b1804b1-4771e85156emr13218475e9.23.1761732986064;
        Wed, 29 Oct 2025 03:16:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENaoAuowDmNKRs2e7mInj3dgyeHZe08An/EQmhaeEKImjMyXA9vgcPYVOhC1MZ8t+wInccTA==
X-Received: by 2002:a05:600d:4398:b0:475:dae5:d972 with SMTP id 5b1f17b1804b1-4771e85156emr13218175e9.23.1761732985564;
        Wed, 29 Oct 2025 03:16:25 -0700 (PDT)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952b7b43sm25828786f8f.6.2025.10.29.03.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 03:16:25 -0700 (PDT)
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
In-Reply-To: <aQDoVAs5UZwQo-ds@localhost.localdomain>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <20251010153839.151763-28-vschneid@redhat.com>
 <aQDoVAs5UZwQo-ds@localhost.localdomain>
Date: Wed, 29 Oct 2025 11:16:23 +0100
Message-ID: <xhsmh3472qah4.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: W5avLDHD3xPj2duhvsbSC-ljnvTWUsuCVyEVaiwmV5k_1761732986
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 5934340009
X-Rspamd-Server: rspam03
X-Stat-Signature: unhtcgnooq9ba9icy7rrdfegx34mrxip
X-HE-Tag: 1761732991-708786
X-HE-Meta: U2FsdGVkX1+BTEvVZHeK80ugfvE3jqhTeay2A9+dj5YuGsX3TWgJ3xoicXI/eXLlc47Rx//h7m5IF20CnUScBolftGCdHS95XIkj82NGATc9RxLUYjXNSTupUiNp2VNqTuyseqGRm3huolIY8zp7ymdxbpR8sl53lIIf97E6FeiNis9IrqNPDGyxdcW2RMrmNmjkmxncVxwmHGzolNNeVLXSs9rS78MFPLbZB/lVp2wEEhP7iNvzsCAnO65i7jIr+RkwNQyFvD2BNNV+AAkT+pwkX3aXIXhcTY09b7QR9LTwbvhxHsuKfzAJk88QmUVfOiFN7sE/7rqZwQAsnGUMNDstuJe0oyJgiHbnwhqmf9hlByCMHMAz1EuVQHUfD8e3UImAof2xswj0m/UFf+VS/zVF+gf5GJ9UQM7ZJvK5VDtIekHbbg/PpusCckCn9If38yczH1O9gVgzb+W5fEf9ZdhFuwn/k2h8lVw0TtfMNlLJceaKrzA2wa9JmogooRwhkGSE1k8rdQTb1gZjhG0nbbInxJ2ffEV3tet1f+SCRrtW/vxe911ldFzMAnVxj+A1QSB55t/tiZkx4CIRkyf/LXb0hm3J2DFoVzeDLnKzkdzneNBuPiQR8CKhZFky/lQtmibU/vqP8jhJ59kXZaEuO/d9ELRjjNyyxVE5VdzOB7tASs+qwZxc8xdgpwAZGYnuOBAwz+/kDI5rIQF8P5ZYyxYMD53+uDQbk7IldkXCSmc4vDGSDwJlRv9KA8RHWELI/xz3i0OLaKWfZkGXyNhlRjPKdyycldxYTH3WUrZy+QX94zPNTabS+lrmCKxmdP/tbQ3M6tFAkVo5XfOLiqDJaprihQFijem5cAMtrmth9tY9iktWbKSlBqv7ZMotkDJERg9kY0dvELi+NkyQlHNkyUQMf1PPzk9ExazAExCHqOD0leu23+t/wuS38s513ghvjp4iBW213lh6bf4/yob
 mtE9stfK
 +GnzxeOHZx2Att1KLfQkXWRLfdnz1Qi0XfD65MhuodqXQpaG8sXOaTkkRqA5IgLrzZA7Ln9AD7dDNMpmSFIQFSmGk0sUaAFEfRJ1hnagG/GHMz0fwHKJL/o+xw1/dyAhxJIBxtHejmFti0oyxEiRrl86QHQGSxmoQ+SXIT2jr0INOo8P/0IB33fy0tiAcf46WXNj6dEyD7zbh3cJdNJWP/sHlz/N2IbXc5fAAzpOdfflRKm1gEAY7a2WPk0zMKWO5tNZgnIDtlf9B+mEwDppRqMdAb3EB+llHkNxnvCGvV2tLDoopxKhRfee6NMfuFEGLaHXFmEpDlcefoaANnPglqe0992pZnHHRFhCYZLwVgdJHIexJjs28wv45lYZstEKgqpG4iP9v9KKY7bQNnyy3AEcA56AjfDJyb1BCUt45lw9lw+wY38veYMBSZxpnV8lxIFvtXSbmKuegQp9UFFUqUKEzXzyWAPG7NDbB41bGXLk6hrxSmCd7ShU0/7HbjPrm2kS76Cn3jquyaby3/2k+mePCqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28/10/25 16:59, Frederic Weisbecker wrote:
> Le Fri, Oct 10, 2025 at 05:38:37PM +0200, Valentin Schneider a =C3=A9crit=
 :
>> @@ -171,8 +172,27 @@ For 32-bit we have the following conventions - kern=
el is built with
>>      andq    $(~PTI_USER_PGTABLE_AND_PCID_MASK), \reg
>>  .endm
>>
>> -.macro COALESCE_TLBI
>> +.macro COALESCE_TLBI scratch_reg:req
>>  #ifdef CONFIG_COALESCE_TLBI
>> +=09/* No point in doing this for housekeeping CPUs */
>> +=09movslq  PER_CPU_VAR(cpu_number), \scratch_reg
>> +=09bt=09\scratch_reg, tick_nohz_full_mask(%rip)
>> +=09jnc=09.Lend_tlbi_\@
>
> I assume it's not possible to have a static call/branch to
> take care of all this ?
>

I think technically yes, but that would have to be a per-cpu patchable
location, which would mean something like each CPU having its own copy of
that text page... Unless there's some existing way to statically optimize

  if (cpumask_test_cpu(smp_processor_id(), mask))

where @mask is a boot-time constant (i.e. the nohz_full mask).

> Thanks.
>
> --
> Frederic Weisbecker
> SUSE Labs


