Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FC0FCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 09:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEA4A8E0086; Fri, 31 Oct 2025 05:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1788E0042; Fri, 31 Oct 2025 05:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7148E0086; Fri, 31 Oct 2025 05:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD2858E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:55:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64D4C16043B
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:55:47 +0000 (UTC)
X-FDA: 84057952734.14.2DAB0F4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 08442100009
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:55:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bpBBqzgz;
	spf=pass (imf05.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761904545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3tkSelHNNZtYzi5EY8XsAlaXp+ewc844ITqqtJnf0nc=;
	b=LbBBQAimXArZiGj9ZKwa91f0z1Z74k+hCmK1cKG55H6Hr5Nz9Il6H2lzNTKs8l6GR0RcLt
	8QMzas5GtGqnRa5hYj6eVM/XP88X/Yd1D285NUKYaLHZmPXqvlOpt2Uwv9z3zAMwagGGxh
	tX0oBzbPZt/oBptyjxI4YZHxurx/Wk0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761904545; a=rsa-sha256;
	cv=none;
	b=jAFC578IxVUr5Y2jREiH1IfrM6fSu93S1wQSitq1isgit9U5xQDZg85ohTsmvlyWFBNqlz
	0HdhF2b9DMJGPd+8DFnxutvfNMlGn7OBD3BMDOzLOw60nwQBh2VYh5LjU+GduwOQbB3eBC
	V7GgmBcbA/RUtHD3jlnudX5CIMCZeNM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bpBBqzgz;
	spf=pass (imf05.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761904544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3tkSelHNNZtYzi5EY8XsAlaXp+ewc844ITqqtJnf0nc=;
	b=bpBBqzgzyBPK/o1+KI7xY2Hdl23T1HrQlMCltBf2NUq8qpOltbMBUOS818/SuRG744qQZk
	lokwwn0n59QrntvBa/EqWrwlnViS4Jh2FWjPSArTH54VrpG7sQgUw+KETRQR19jrY5p2Ur
	PoMst+vhP6HzcM+zMnc/hQomP6p4GfA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-ouv7bSCWMmGvRzoAdg2wDQ-1; Fri, 31 Oct 2025 05:55:40 -0400
X-MC-Unique: ouv7bSCWMmGvRzoAdg2wDQ-1
X-Mimecast-MFC-AGG-ID: ouv7bSCWMmGvRzoAdg2wDQ_1761904540
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-429a7f1ed1bso933029f8f.1
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:55:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761904539; x=1762509339;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kTCg+N3NYwBLqF+pIITZOoHrF01dYEOCOu0+H1nRDT0=;
        b=fcciE3JIXS1vMsfxxNEG/67xeaUuWTnfYgtjXVQeQvkWaN+zLP9jMwJ3l+ytHgIHr/
         7PhPB+YpFipxzZBQjooCBe7f8M178ozGMcn8P/0D14qNZHZxv/60lvLqvSdDctufwAjd
         VQv/Ox8zh69TD2U6qfTZ/HdT85eXAthXNWlZ2tP8nMU16/FvwBXEP1rGRQGtStKKExnc
         ax1PeY0oGcKeU4ZWwivJEb+SQkLBTJK+MhwZoWWcttV0e0leWPYBqCYtOnV0w36y8CYF
         DpT5drL2Lcw5IJyv493V5CEJK5P8FuTfd6FNkWNumjsiJIugSePWBS/qWuwDF2eF7gvZ
         Lt+w==
X-Forwarded-Encrypted: i=1; AJvYcCVGeep9HHDe9pBK08x/5FX8oEZ5jh5tv0F6bCvz5LvItHVgqgCZSkxFcGDksT3b3VVGV5dtPf+afA==@kvack.org
X-Gm-Message-State: AOJu0Yx4xN+6zcsZ906FeSR5qcHA8AoJVZtR3BV8qpSfsMLogQ8ONlHP
	8Xlxm3oxtoqiuUL/h6HaSFRncQGn3eBJe5B78qcTDBFN6s8af6lZ3JoLx7iEz+I22vEJmKuX6tG
	ebFbYfkpyl7a+KzJMwOvqS5CkRw+NIQJrVg/k8Z9q3w/AsmvMmWbi
X-Gm-Gg: ASbGncssrvGGN+vWLb5G7jJDeDyLIn1cbb+m/aJZ8dCFqC25auOETHQ86wvLXg3Tose
	hHYXNR/NmxNiQTJVYPur9WiMPDBD1nMjCe/ju6+91fwmczTBIa6WjbAKh/9cLpxTjAevsHESfwx
	oW3v7XPo/IpwqWdvMOz/BqFeBI84k+tgWGSedZ7mNIbnp30xVFtFnHktc3K2JmSZ6uwEozl88Pg
	SL2Pfg0oDy7Ox2SKo2H3axGtB2QtLv+AbO+AOvzYMxpMwznPvb5B7LzW83gmeZMu7h2TSWVP9rX
	n1fxSvpInuqo4KIJpUtvPK8jjogqvp1lZeDQpAD2spqcizLxhh+xYmJs7QZqOXXcEqtbLOAYK4t
	OWhDhl6rxVJhvd1UPmg9zN4HeyZuMr+tRc3QWgcXUyEqV8PRIo67mjPi7vShv
X-Received: by 2002:a05:6000:310f:b0:40f:5eb7:f24a with SMTP id ffacd0b85a97d-429bd68869amr2437857f8f.12.1761904539545;
        Fri, 31 Oct 2025 02:55:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbUxApmJAOYlrcJigfNqaTRZ7Pz52J94NiUAhMgZ/Qwj+7BmCVMNCnPqwOLJ11D9kpjdgFWQ==
X-Received: by 2002:a05:6000:310f:b0:40f:5eb7:f24a with SMTP id ffacd0b85a97d-429bd68869amr2437793f8f.12.1761904539055;
        Fri, 31 Oct 2025 02:55:39 -0700 (PDT)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c1406a45sm2624895f8f.47.2025.10.31.02.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 02:55:38 -0700 (PDT)
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
In-Reply-To: <aQIpXyX-z8ltB1i5@localhost.localdomain>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <20251010153839.151763-28-vschneid@redhat.com>
 <aQDoVAs5UZwQo-ds@localhost.localdomain>
 <xhsmh3472qah4.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <aQHtBudA4aw4a3gT@localhost.localdomain>
 <xhsmhwm4dpzh4.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <aQIpXyX-z8ltB1i5@localhost.localdomain>
Date: Fri, 31 Oct 2025 10:55:36 +0100
Message-ID: <xhsmhtszfpf8n.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LcJQENY0ShfJDXvDbxM8YVOfzbVP68o4MLx0WRzN4ho_1761904540
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: nm614u47w66646w4mc8rkadhparm6j7m
X-Rspam-User: 
X-Rspamd-Queue-Id: 08442100009
X-HE-Tag: 1761904544-223961
X-HE-Meta: U2FsdGVkX1/RPNCFS6fkckVOHx4g48ZQBwBpuHondbE+VYL0EScrjg9yQ8FrBKCIIzn+Y3ox5CGxRW1nHtGSmL9Wr1qYIm469Z05qGyBIBpArpAJr8tPER4vjW8kxjwxAvQl07V1ta3s6UD7MplGqV0+I/HSHHz6ue7gL3IWmGefdLxyF9Xgb7CwYm/EgAtwGuamnpa9ppVcaYquHLKEUkIhV1KIFox1Dy7QHOCm1c5KaHiuVHtkek4NxGzS+V7I2sxEytDEpitJFuUZVblaBp15YrhmYirtbFz/TdDmpzU7qwVDBssd2VWQq9h9ZA+3BrYyaUMxosgbVuhCFn+++9RIXAh++dHJqiyCvgbFbX5KJhaqipaW6Oq5ZUobf0N62NlNVnkj+IGiRYUfWRNordMd239e5KEwmwYUyxU8qWczLDlUUVOezo2qnt1svHqsD9Bk7JNkAT+FSDlMgoMhZ41vRnU4AoryVj4NHvyqNI4W+hlmS++PYqqvL7SHZvxnjMuP6ZFoD4TeF28fP09EGJoUI8xUHzjZGWK/1V0A8YJP9kuwBiFXVgIoZvh3VPZe0SfTh9b/lMIje1DXa2g5iSWn0lMyIbRPQq99z8J3HLt1fYXPvnFgqMQGx0acegLoLU1Z98ho8/evwkup1TzhFZrIbVIh3FFul6FFTSLNVXw/O5jcgCi8dgrQWX+NHEv+Do0/ZpkCQq932grk8iAQwLJHLscWmuk4V9p4kTrt6vaHK2CvuIce+awW5Y/wjtOpn68znwOkgA7qz6/v1DdOxrx34MEYC1l+VTZcOGEu/1wr0cA6qbM/evrllURdbfdvxTIl6b7E6597cvFX7IchgcxEBsfx/pi3S4cjJpEYcUvfWzdDAZTLapFFGfl4VA3kGTJESwbAObN3+XXlihSFa72o38/hfBXSGAfKpFfvkCbbcLm2tihGXpxdfrUC92+IeAWT1rbcAkTXHv5Q9wt
 k+ifrr85
 qQ2oqrwGdYTo8cKQ/1o88ZoLL6e6fGbljJGE7UAVQsl0mKHb9a2XE2+z2LszGaZQ3XZhOfR1YllB1w266VIR1rNFktaq4lyCbqfawYSuZSXxrnj5Twevz6qvRIoVVl5mziR7gS2qUUVS9J0O33UV7YIti1W3oDOn29bq4Q2+dAXM267jyLHXGNpo8BIgx4u4Qlok9xB2u4EW6m+DefXhvEqTuz1R4HTIF0aDSwpIFywh+06Q+4ps+3nHdgifqgfj1HGIojLFKI/y6qm9zC98UjwnlJx0AGi4LGH7CYNb1x/jlXiOuda6pyiG5UscocA/xLNZUb3Vi0itkHSfTsi5JJ4ZgzDGPTGwr9NjqtpYqkxTN/8nNMLY02Sz5aFUQTnaBMqcpwuwfORA76vVPDsOj5dut67d6bPQ0Av3OlgaSEP96MI2R/iFnScOvRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/10/25 15:49, Frederic Weisbecker wrote:
> Le Wed, Oct 29, 2025 at 03:13:59PM +0100, Valentin Schneider a =C3=A9crit=
 :
>> Given we have ALTERNATIVE's in there I assume something like a
>> boot-time-driven static key could do, but I haven't found out yet if and
>> how that can be shoved in an ASM file.
>
> Right, I thought I had seen static keys in ASM already but I can't find i=
t
> anymore. arch/x86/include/asm/jump_label.h is full of reusable magic
> though.
>

I got something ugly that /seems/ to work, now to spend twice the time to
clean it up :-)

> Thanks.
>
> --
> Frederic Weisbecker
> SUSE Labs


