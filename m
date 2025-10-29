Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C94ECCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:10:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 779D88E0050; Wed, 29 Oct 2025 06:10:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702AC8E0045; Wed, 29 Oct 2025 06:10:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F27D8E0050; Wed, 29 Oct 2025 06:10:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3838E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:10:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC189B6A9F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:01 +0000 (UTC)
X-FDA: 84050731002.08.B359AE6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7DC8B80003
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:09:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eBt3/oi5";
	spf=pass (imf02.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761732599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8VL8F1BbEiYOKI5l4LcZTZfjaaIUn5rioPCVGdYu3M=;
	b=nKlo4sFcTfVRym3gQv7rC5MbGudaX2HonyJuzEn7ESIYuDk8ZiIRaTadB6Jh3U5Dwe2mgP
	Rgw5U3vALOWPeh4439BRpR0qS4zh1/lGkSdGX+xbXCobcMKxmzays6P0fajivgJuyw2wHT
	LRLb6rbpFOZmVp8cqWX8gVqgVXoGXkY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eBt3/oi5";
	spf=pass (imf02.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761732599; a=rsa-sha256;
	cv=none;
	b=d+aVgSAOep3C8guxImX8J7v+UNVrciUkUSdZVp5mcMOiUK27rRCRnYr5TveH8zJJaTT4dd
	QoMak5IYBbFlNtlnUx7338LBffYU1qfFLIetv/N/VXmieA4kQ0xLM1BecQoqE2Om4R+0NP
	cPSmm7YMOviSvJPEjW1bOvcU0KuXRhs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761732598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P8VL8F1BbEiYOKI5l4LcZTZfjaaIUn5rioPCVGdYu3M=;
	b=eBt3/oi5goOv07OsxEE88OoQm7lYCD2UYK2UIjXNM25213RA4bF6WtBIwZHJwxm3ugDK+r
	DqYiOI9/3GOQMBYLWr/S98PHM9yka0ji7h1hwVfVxaeiY7EjMRm9C3cqfLYShne5Frb+dn
	yuUp1mMgH4YPCJB7D8DmfdrMEhZ5fIM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-nPIQ__6DPxGqo2_w3bsnFA-1; Wed, 29 Oct 2025 06:09:55 -0400
X-MC-Unique: nPIQ__6DPxGqo2_w3bsnFA-1
X-Mimecast-MFC-AGG-ID: nPIQ__6DPxGqo2_w3bsnFA_1761732594
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4298da9effcso4895622f8f.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:09:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761732594; x=1762337394;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F7va99Zg9nu4+XxtsT3y+i0Qg89ua4ByIHfysL3F+F4=;
        b=fvpPgCq7wpYbawhrANdrVq4YpPPo4X1jfzsfmgCsHw31idHzaIjwK/0Z/glYwi2iMG
         E/yV1IHtMC4oGIN0qCLY3gFbTGcHCA6+DBqsLdK0HaGRFMagwJcR0jBvt8h5GaXHBt+D
         t5l+jLCebRnPUW+EcsE/2wETbq92lQE7/UH1lOJ5wrkA+MGu43ExKD8A3h4RJhoAiSuo
         4yTKftIODMOQTpqJ+p/PmoE8YXbusQebKwGq6j8MpVulLTcPmrSouvtq1GZGbJ8z8EAO
         wLGPJHh/33b63KKlrKHQZnbzvvKfPDhvO7iWWEiCatCp16VL1mi7isxLSeXZs2lNhyAq
         fg5g==
X-Forwarded-Encrypted: i=1; AJvYcCVrEj9v8BcKLwk8A2+fer8xZqheHa9lMHC52OWUoovEnUEHdSsmD0AVzKKfLJMH8CMHV3K2HLQmnQ==@kvack.org
X-Gm-Message-State: AOJu0YwNnImob9loESZRNIhPk6G2TICoWG3AASt9UPwPRzJkt0mwCbEv
	PoOq75BwskfLYhhg3eWRkVJp/5NiyyJ8PG7tYa7ODYDwMuE25fq+DdphVQ1yOAuGJfNy/g8VAe0
	ifFOn3OmlCYJmTmkk75nLUOwM8CImIoMn404eiWxpacUukSPoYCLy
X-Gm-Gg: ASbGnctppZIwRNPy6d9vl3cCyktMRDa2HSMn8QzYCAjVyb4Nd/VHLfZXIqP4XimH4xx
	SkaLDJx7hrOraSRxRjPUYeBofjmCGkRFOKeNzWAR9nyIhcmjze+n/BOFCVxx0BqRUhC7cY4wid7
	Z6wcOPsktnhZDQfnXZUb5C6QTKOYKR5feKeTmMAcXtNsYLoMf3j0nwTfE5JD86eMnRSdYv112s5
	pY+nPhY9qwf97Dwy48as3uBT1Stq52xrbL057pS8yfOu0PHh/Cf2pWrs8SBx1EFX2L21m/rA7lW
	4fkKKnlTxLU7ssMegnsJEJc9OvYNcGDHDmUrWSX/bp2cWHnXoMqz+7m7mXBcH+iWdOAjypXaswD
	QBDY7O61XQS+IlFTObkh1ytUAGvlFUwHvlD4P3UuQ+7E2dWhmQK3dXM2h4jgy
X-Received: by 2002:a05:6000:2089:b0:428:4354:aa43 with SMTP id ffacd0b85a97d-429aef83083mr1733922f8f.18.1761732594339;
        Wed, 29 Oct 2025 03:09:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMwZOd1Sm4LKIO70Dn8iCGAQm9z32hncQVtTx+dFITCY/jcrLahS/V2gOWr58H4oqqEmvh5w==
X-Received: by 2002:a05:6000:2089:b0:428:4354:aa43 with SMTP id ffacd0b85a97d-429aef83083mr1733872f8f.18.1761732593822;
        Wed, 29 Oct 2025 03:09:53 -0700 (PDT)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952e3201sm25467518f8f.47.2025.10.29.03.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 03:09:52 -0700 (PDT)
From: Valentin Schneider <vschneid@redhat.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
 x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org, Nicolas
 Saenz Julienne <nsaenzju@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Josh
 Poimboeuf <jpoimboe@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Arnd
 Bergmann <arnd@arndb.de>, "Paul E. McKenney" <paulmck@kernel.org>, Jason
 Baron <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, Ard
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
 <juri.lelli@redhat.com>, Clark Williams <williams@redhat.com>, Yair
 Podemsky <ypodemsk@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>
Subject: Re: [PATCH v6 23/29] context-tracking: Introduce work deferral
 infrastructure
In-Reply-To: <aQDMfu0tzecFzoGr@localhost.localdomain>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <20251010153839.151763-24-vschneid@redhat.com>
 <aQDMfu0tzecFzoGr@localhost.localdomain>
Date: Wed, 29 Oct 2025 11:09:50 +0100
Message-ID: <xhsmh5xbyqas1.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YRML03_mVnzJEU725UEsRCdBiBNKMz-LcJ6h4bNqbRA_1761732594
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7DC8B80003
X-Stat-Signature: uesmj3nnie88p9taxfuecceu9yyss8ps
X-Rspam-User: 
X-HE-Tag: 1761732599-620062
X-HE-Meta: U2FsdGVkX1/fprmMuVbaWFQaFEiF0WQOpgjsTmjHPGRjlJz/t4b1OO2b/Rz84c4C2fA2MxqnQpoemXrKRs2UZ44t+eJPIIN1q7IaHey1Bw5xxp1RiPJ2s1LZCXdZSNX+8OG2nCudDsWgDd95L5ZFkQG2oFowWUls/KI6bEAgpse8+EnkagSifCgF842DIErTqGzd7ljTw9mE347l4YE7TKvGRZGZB9vTht2nJqWiJDg+TZCuZG+VOPrkKzO89WdXftxb0ol4dP4Uvpyb7i69VFi3FuRIlFSAHkAMv5ynJDk/kXROE9xQZeul06g9uytHyXx6s2SYHDf01e8i4spm0u/TlRJocPQ+o+wxPyNAEEIZr7xItONTD+HSz6GhBZH7UbkndPUkBsZuiX+CzMeHyTP2AArjYqz60ddFnbC562IXGkpSipK70DA+qOf1fApiDCUfQLsVmznBT68jXARz1HObQtozDv1zZ6hEchvybxQc5MHGLxLA4lPsnXt5vw+R3pgBZfwbi3Dp1Rvcg1fuZdY2CYwx9US6nBjAFqvn7pZ2ODuP+MM0KDr1sTvcUzIVt9520Et9HpkNXLrvzgprYkwHs4Qv7J7Bck1IA9KtoBRkesFH5QmJm9cKfM2GlVBJsF8Pzf95o5hGeqwUd4zWiepUxO2qceYr+ahrKzpG5GRXqe8bKODpaP5A6zh0u3ejq+FccDFtnedYKNbSLasZUyhqTBZq2AHA4v9h3cph9woL+TaDBp7liq1Ewnu32VwA60jS7IgEllYPj+lwozC2egNa7m97ATxGVJyng1P8ZpiL/LlPMhPYKGTdMDGKsUskT8ac3Ppgn88FrzqW0Vg3RgEFlvCW+K6VwM27qjr2NqIRGRCUTf2BqdINx1AjYb6/MMQcO0urZpIOjamyyshDdPnVZcm/5zpicabGdevZjyKV4OXz/AMmqEVocfokC8Az4nBnIA0kBPwRna5u2V4
 qxZeTZq+
 Z3AHB79SfeIGKrU4EoGdfSJQ0iv4LL1cMIHsjYpgDXQk9iiT6NtlVVlvTtVAxIbSBGHIBgMQKhMPzCunkkNyjqtgkSwayURX7k/Z49Tadgum+QnvpIEHCRmWjjzMTK2OCAC2W5EX7IOg48e4VKKs8H7H9iVIddLAfq7pY3frzqcmyGKRcB8TI0kqJD/wInuHIWUwpEB+gUTPv44WC5t9tpBzOLqdnApmGDsDwJt61kRgJXa9xrXm4WW98kDogO/GK/fI6p++Iz+D7jxQMEhJmM1L8g/vxd1ZGdwsrNJcZvs/y7cvIKVKwSc//grTWmNkKk9/NK12ggI9xIU4dfYi9XUXKoEdZwg4GvLUapQ2AWq2skRlCTr+SwShsg3AUt75UM4/kOEWtZzOo6Ejv1a6kiEWgkC9/GrQPa1htcKUuwWM9uwSIxmKVWTBQrXSYWF5SB7gyaW6cYxAGLcqc50eZznk5vjDnf/bLUo4EXWOCK9vB1ZKT8HJep8HHJSSLB3LXgVv8ymEY5kZlTKfciODmg7dPSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28/10/25 15:00, Frederic Weisbecker wrote:
> Le Fri, Oct 10, 2025 at 05:38:33PM +0200, Valentin Schneider a =C3=A9crit=
 :
>> +=09old =3D atomic_read(&ct->state);
>> +
>> +=09/*
>> +=09 * The work bit must only be set if the target CPU is not executing
>> +=09 * in kernelspace.
>> +=09 * CT_RCU_WATCHING is used as a proxy for that - if the bit is set, =
we
>> +=09 * know for sure the CPU is executing in the kernel whether that be =
in
>> +=09 * NMI, IRQ or process context.
>> +=09 * Set CT_RCU_WATCHING here and let the cmpxchg do the check for us;
>> +=09 * the state could change between the atomic_read() and the cmpxchg(=
).
>> +=09 */
>> +=09old |=3D CT_RCU_WATCHING;
>
> Most of the time, the task should be either idle or in userspace. I'm sti=
ll not
> sure why you start with a bet that the CPU is in the kernel with RCU watc=
hing.
>

Right I think I got that the wrong way around when I switched to using
CT_RCU_WATCHING vs CT_STATE_KERNEL. That wants to be

  old &=3D ~CT_RCU_WATCHING;

i.e. bet the CPU is NOHZ-idle, if it's not the cmpxchg fails and we don't
store the work bit.

>> +=09/*
>> +=09 * Try setting the work until either
>> +=09 * - the target CPU has entered kernelspace
>> +=09 * - the work has been set
>> +=09 */
>> +=09do {
>> +=09=09ret =3D atomic_try_cmpxchg(&ct->state, &old, old | (work << CT_WO=
RK_START));
>> +=09} while (!ret && !(old & CT_RCU_WATCHING));
>
> So this applies blindly to idle as well, right? It should work but note t=
hat
> idle entry code before RCU watches is also fragile.
>

Yeah I remember losing some hair trying to grok the idle entry situation;
we could keep this purely NOHZ_FULL and have the deferral condition be:

  (ct->state & CT_STATE_USER) && !(ct->state & CT_RCU_WATCHING)


