Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5445CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 11:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1D288E00E4; Tue, 14 Oct 2025 07:20:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4AF8E000D; Tue, 14 Oct 2025 07:20:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B118E00E4; Tue, 14 Oct 2025 07:20:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD53D8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:20:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8EAB2887FF
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:20:14 +0000 (UTC)
X-FDA: 83996475948.24.2BCE2B1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 58BF912000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:20:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JLtaCswH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760440812; a=rsa-sha256;
	cv=none;
	b=22Y3nA58qtWl/ltGYMeoVVuQ7tIs025faQrbIAwYaxjVATg4lrwLMqesooHJ0VWfrEUUSB
	TY9Dd/8dUTT09lBw7D2tyAh9WCSTq9zu0tb5rIzP7+Cu1hYHzpRuq46/bQ143avasO69gG
	dKREA2QPihFC55IS5JuQMNl3YcspQV4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JLtaCswH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760440812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Imuve1iPcSxB4uVU/yFQsIzQ6zKzpq/61jJo3KbkM2Y=;
	b=DHgaynYU6mmz5BXTJqEZsI99gg2IgYMVHOtTLf+bux2WGK5rGN+icpaufc6TVkM6wX1TJb
	wVLmuMMEn7Ub5fD1e6nQe7zLcTxAdHUlIyAiqDiySGqgpohExqPvQBMX9dLsvGMFD4rtfV
	/bQqvkH213ZCJbQUuRUA8Q3M0b1y0uA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760440811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Imuve1iPcSxB4uVU/yFQsIzQ6zKzpq/61jJo3KbkM2Y=;
	b=JLtaCswHk/AW7ow1AFK8jpTTCTDmRdtWf4uRPQp+yJ+Cxgn9K2tK3EJ3EGx3Yxyuv5VOvW
	8MeIBKkAvdUbrmjYWsS33vur/yPGKfntdccd+N0/n4Jaz5s7kZS2eR6PLLvt3t0j3RlMxC
	JICyHnc66knRbsr4oO8lRpKs7rDX7So=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-9Aod9QcVN8mvIiQVSTFptA-1; Tue, 14 Oct 2025 07:20:09 -0400
X-MC-Unique: 9Aod9QcVN8mvIiQVSTFptA-1
X-Mimecast-MFC-AGG-ID: 9Aod9QcVN8mvIiQVSTFptA_1760440808
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e47d14dceso29915165e9.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:20:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760440808; x=1761045608;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Imuve1iPcSxB4uVU/yFQsIzQ6zKzpq/61jJo3KbkM2Y=;
        b=JaMJyQywu7Kps04Q6wEigQbCoIywe8VOPJDUuat537ouBojAFK8Ohrxcj3DueuABks
         GblMFgl2WhdnWHgB44oIWi8co5QWi7JGI3jHgeU/5hAsn7bp4hr7e2ijmktFEDEKjwlv
         T/DsL+E4LTFLNyd5RRUaGU+vovIlUfAAR3yppxOTP7sjYjlUph6XpMxM15WzyUvfJKQD
         VbCEhJi+iT2lFE/GzccLPDpPCQ+D66cxAyUpFkj/hbcc5aq0Rpz127+/5G8k0LEnmv66
         NjVqqSNf18+dkbEjhdphqxPV0/7fBenp/5D8A10LLiryVU/0n0T0UWq4kviaQFNZnfLq
         ZGzw==
X-Forwarded-Encrypted: i=1; AJvYcCVvtCQRoDveecbrPHmLl5hjGgkXrNwJdSSAMJyd1iePbiVP0hbNEHiapUhUJkAknpMQNlHZUbX+sQ==@kvack.org
X-Gm-Message-State: AOJu0YwU26KF0pYKYql+k1/hSXjJrPmiB6u2vzW9Irbrrc109ug/7c+H
	88ujlcH0tkNYCHwIchtvjTyideuuM6IUx5FM93UcLjLH/xlBg7Q4m4nG8b0WPi0AtxTU6TEgWjh
	kc8nMg/gJqw3E9tPua+U9cnuKob+00NEB1XirzVACrkf2C6qod1Mw
X-Gm-Gg: ASbGncvidPfVs5PwSVH7O0IQ3IoupqtndmBmfmo7XWdUj7Y5wEihEz4fcpX7Am+4T6c
	PBLI81SUsUmxZAhPsE26TFz+8Zk8TtjdE5LMTZgubW8RmiipgNFCs7k6RvpGUU/N7kw4+/caSK6
	moFY5DXpryXWFOfvScumjg9cOO4uwxXu7jat27ERr4x5pnfz27czKu8ERiv08iikgqqDx4JzBb4
	Du+2444KSya2OMKkM9Q5TNahu8Cw+iUOVgiERzmzJrUJyEMMNIF7dukRDjKt353fxP15+jChP2D
	rDYZ5kca5n5RIX+W25BY8R6H6tUSAejPfFxaq+ZeZh4GtwVbx04PR/jGr5eYb9Dcvvrkho2pbiY
	PhDAIUD50r9JY7edrGqT55rlLUA==
X-Received: by 2002:a05:600c:37c9:b0:46e:477a:f3dd with SMTP id 5b1f17b1804b1-46fa9b1b18emr175576295e9.36.1760440808208;
        Tue, 14 Oct 2025 04:20:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPNHhJVacE21hOu+c1s40cKBm99NOdKTbqBsl6lzaW/V++U98Y1cwp6CoRkBLGlZny7BSyXQ==
X-Received: by 2002:a05:600c:37c9:b0:46e:477a:f3dd with SMTP id 5b1f17b1804b1-46fa9b1b18emr175576075e9.36.1760440807708;
        Tue, 14 Oct 2025 04:20:07 -0700 (PDT)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb492e6ddsm265506695e9.0.2025.10.14.04.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 04:20:07 -0700 (PDT)
From: Valentin Schneider <vschneid@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
 x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker
 <frederic@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, Jason
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
Subject: Re: [PATCH v6 16/29] KVM: VMX: Mark __kvm_is_using_evmcs static key
 as __ro_after_init
In-Reply-To: <aO2TKOY5JV9OoRUg@google.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <20251010153839.151763-17-vschneid@redhat.com>
 <aO2TKOY5JV9OoRUg@google.com>
Date: Tue, 14 Oct 2025 13:20:05 +0200
Message-ID: <xhsmhtt01pw62.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: j_Y-cHaUm7l7uKxX7meBXheUoRTHMQWFKKP8sqtvRVg_1760440808
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Stat-Signature: 5ee39q87w6gnf3hib9u7tyrs9kpp3e1y
X-Rspamd-Queue-Id: 58BF912000D
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760440812-376870
X-HE-Meta: U2FsdGVkX1/sX+42MqYD71h4r0XHOyjjyD4+b0O0jmhhmipSr1qpuYx2uZxqQS7kkebGOOUIMiklB7NNJc15U/0dGRCya1dQWd/Z6AntChg/NDqJ9XvM6giqXMw3bGhyLNFpc+zKbTyex8Nla4Xq0ZrjkkkJPJm1VKPxUsP94BDo4vny7el0j6yBcV4FzLH37rkxZZ7J/KJrBctv0xpF+SjUEjnB3R2x67Z+pbbmP05AcrDNka+nvzrKAGFfxorNQjtGqaf45BDUz8eJpYZKgGWVPd/1DksD3T11G0T1RSFSjQvi9DxruNC7mSlaQItBHPqoMx1YX9KfJ0ngkAuDU8piU0pd2X6D5VBRsOub5MWO0/D3J/l9XOWHFW3ghGrOROEe1exHollTjE2A3TcoME+KcK8R1UQtoLLTdKJBceJ/2tmcSbRvYdrb9smtgLIO5tAhLjOmbd6uf2OzLxl53T3tR6VxaNCyNG/WyNYGhwIZ4ckR0H/N9Ft/RK6cf0CXJ066iGQrKrqtFDgnRczBvAj4AJ0eEBa+cye7ksGOFi2cYMcPfi1cJ5JBJctEoh7mzxyOGPYXxzWTATWpUpwQxZjFssJAc9j6L4Sem5CTW4gemnWdOR4ybaK2nSoflLw3DO+jtKUBapg/buqwGlcYsVbz+a8OVs8/hrlR5FAL2Psj2gy6lpiIzFjHEV8hm8CfXpj20YRjXhCSTeDFYNDzoW5Wn9UEEAENalEbBxMfbqo01JHZK6DZdcAr/yg15VhWsaabrWogjqd2Xs8aM5gHZa0l6D63J6igjqaipvrOUjKiZhatJ6/wLyD2OtlHtCd6A0f83TbP0BWOjcuLEW1b+hDG/qiZiu2D/Tnd+e0Y6Of9gz0D/IHuemWgSCsOL7ARnGXt28oQVD34D1jn9P+c1hZXdjx7wS/bMgtnBW0rq0gRqW4wwOd6BP5fBLZItKhjaM3onT696RRD1LPuhwn
 /XaIihdB
 E+fIjjm31vWaripRp5e1KJQ/Sgb7urnN7hZVYtmXjo1+XZ3AslpYTDk3kETiIW7Gina8Puixc4DjIXB8BlggNiKyeBm1TF4C47jEo4CM8Wd4EAhuSHS+98Fr7utYtBPKnBtn1ONDwnTUoHs6oprgPyeX8o6R3CxP2AKsDi9L4mm1kdbq7wtWlAaRixJtHzpqWdAuoAsZwn2qaGs0WJ4tN7+msyMfoUUPfuodpXCE6YLREwMzzec/Dqmrigy29zAeZ1UmgADFFPNX9fhx3JjHj02r23E8k2Y2dXXpuaxhl+hronsseEmGXkILo3culSvMT0ec7kQhkpWP2EXZWYypVQO3uAK2PUXuMYzKvxYkYo9THqAPKG8RhyrA2U3bRvz6dKv9wRnOrcDDTpIBdUEiCjhmQWzH91cLtd7+x+FmNT7l92geNGUkgb9A8dqmgj9tuIDhW/LJAE71M79cVLY/dpdhlYRhrITtooUk1ZHrsbK7EfOuna38jQPqVbF8mUEBWa9aUTHLSMLZPlFmhJB/nYv5GDgILMA7twwlpBWquHw+L0wkpzK/NaHvpK5O0fBl0Fjt63BnjWac+M9/tWnL0dsSjdQ3+HzCVzVy7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13/10/25 17:02, Sean Christopherson wrote:
> On Fri, Oct 10, 2025, Valentin Schneider wrote:
>> The static key is only ever enabled in
>>
>>   __init hv_init_evmcs()
>>
>> so mark it appropriately as __ro_after_init.
>>
>> Reported-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
>> ---
>
> Acked-by: Sean Christopherson <seanjc@google.com>
>
> Holler if you want me to grab this for 6.19.  I assume the plan is to try and
> take the whole series through tip?

Thanks! At the very least getting all the __ro_after_init patches in would
be good since they're standalone, I'll wait a bit to see how this goes :)


