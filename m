Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A978CCF9FA
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 11:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99A778E015E; Fri, 31 Oct 2025 07:53:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94B4B8E0042; Fri, 31 Oct 2025 07:53:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 861958E015E; Fri, 31 Oct 2025 07:53:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 74A158E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:53:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B0661A04A1
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:53:06 +0000 (UTC)
X-FDA: 84058248372.29.58CCBCC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 96048C0005
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:53:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="VLW/68ZH";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761911584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gTUIS93GUZsQyg4tbyddEkDWsI2/kBv/P3HZONFfij8=;
	b=RQJ1zHhRNShuo6j/oE8kwJGNdmI/salltEu7ZIeYomjV2AK0HkdimTqeprMWa/WLaiqnbv
	2nahpFMlatJ/GszvDxc76hUMs5RLvmaU8n/Vv2dYRxUeUmN7LpuB6rqC7h8s2mLJo6Gr53
	tC0T0bZyA2TMMYl/mD8PGQaJpz6vZmE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761911584; a=rsa-sha256;
	cv=none;
	b=0RtzcMjr2AFXPrrHZQRyCNTSAODybXuLohL47+cb2/JilUTE2uV/ABJ8ZY+R1MEAc4/ZdX
	x8judWrY9L7mQOqm3ySC8GRIli/GYmp+036X4ReDOPcZ7xfJIO1kortg97dyGtVN+aaFeD
	K2ixoSmjM7iktRNLAhrCUrWKwE49Ogw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="VLW/68ZH";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761911581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gTUIS93GUZsQyg4tbyddEkDWsI2/kBv/P3HZONFfij8=;
	b=VLW/68ZHSgBq5lCtIBt6zBfYUUL9IMbTYLjZAqwK/FhqjF+QAXx3GTgJuMBL3GSVIzTNtD
	LkNkGQjSvlhnngMQwMoTJIMtampraNBpsyA+MGl4E7l8zOtU4XE6QYh/GSciXnW1xubfiQ
	5jnxJTDgQ9z0DxI0INAjX7EOwrYO8QY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-fp6hzPqhN_umMNiGPUv1zA-1; Fri, 31 Oct 2025 07:53:00 -0400
X-MC-Unique: fp6hzPqhN_umMNiGPUv1zA-1
X-Mimecast-MFC-AGG-ID: fp6hzPqhN_umMNiGPUv1zA_1761911579
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42814749a6fso1856542f8f.2
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 04:53:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761911579; x=1762516379;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gTUIS93GUZsQyg4tbyddEkDWsI2/kBv/P3HZONFfij8=;
        b=jiBqykjzKPb1VGrjTl3hJNAtqNezs6IFw4IWc6hvZHZxPuldnsYSDFUnBsNIDHiBMv
         4ihwCPkq3v6hZWnqznPGBFY+NbDtqC1YjF0K3w2YiCPPI87dbEhOQnUaP7ui1oR0vKq4
         CNcOT/lrk5Sr7Hwk8Rd8l+wQ+MM20r5amrkx71SVff9adNDVMVQvsA3XxyxnX0WGf0nQ
         vv0IWKwyL5lvE4Fav9D/7DXFwMc2flO5h0ywMWWa3Llu4o/1UgkzJ5L4G1syGc+MdAAU
         L0rp2lUWtZiPE6zfctIhTZbca1BF7dXSk6L23GIOB3s/eGQqvoe9AlOMydO9J+VFGWrb
         hmTA==
X-Forwarded-Encrypted: i=1; AJvYcCVJ0YH+5E3jz79+g0VRnt4iceNaRUNcNu0Gh/yqJzrKkF8PqMRfEXmCvZIlG9JJxYxF7in6SchlTw==@kvack.org
X-Gm-Message-State: AOJu0YwmMVsxx4Y070PmsbFhZpvcZZzB/yB7PlMYzAmiDBj8ess1NsD7
	WvyqOukGKdmuC6vs9fEHiEAn+Nmq1F2bp3nFuGk6DGg39vBQeLT+YNCc0qEZd3UbN+syFr7tBNd
	DYDe7omsYNu2ggquAeMcFtfV1sxpJaB2/y19okuq3D4j59j7SRtLa
X-Gm-Gg: ASbGnctAJObJhG8axEMb6UAx+pj4XFnIREVB5TTAiW5s9WadcP7qwIKYlv2p7aezTkl
	0bUg++VQexLm80JACYRHNiiY8tMiDpU0z42Udl+0jasREa7lEDNPdVjYPInL27SvZkU6g/SsxmK
	kXaynhz9ikUnBzr3gbQ0GkRc/tvgh6xUl6aoKOmK14CwfNfzwXM9ZV4TN+J9Bz9HGP9gDJF3h0x
	gdDAu7Au08vwBDCI5lHktDIeEY5ZjtotBR7FUDoEoJuqDg4eEsORxkvZia/3nAYVfbt0kPljvkZ
	KghmhymdO3tHOiZPVkMko6sBQjwX0PZqh1Ir6zxqsHVmf9434r5Kbf3zv0Yrv+NRSY9kaBa61TU
	PTxTMj0hPiQIoiNq2dJ3h5hyWEolLqnSl7eiAU13OUaVcJQfwFVsXdCK0mqKd
X-Received: by 2002:a5d:5888:0:b0:3e9:3b91:e846 with SMTP id ffacd0b85a97d-429bd676a88mr2912809f8f.10.1761911579310;
        Fri, 31 Oct 2025 04:52:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1wuetlLZ34asXy13r1bfmujThSOSUu3cZmMHhgfxqrER8G1YsbbHDsXHGv7ziQ36i83pqkg==
X-Received: by 2002:a5d:5888:0:b0:3e9:3b91:e846 with SMTP id ffacd0b85a97d-429bd676a88mr2912761f8f.10.1761911578857;
        Fri, 31 Oct 2025 04:52:58 -0700 (PDT)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c1142e7dsm3186896f8f.17.2025.10.31.04.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 04:52:58 -0700 (PDT)
From: Valentin Schneider <vschneid@redhat.com>
To: Petr Tesarik <ptesarik@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
 x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org, Josh
 Poimboeuf <jpoimboe@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker
 <frederic@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, Jason
 Baron <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, Ard
 Biesheuvel <ardb@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 "David S.
 Miller" <davem@davemloft.net>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Mel Gorman <mgorman@suse.de>, Andrew
 Morton <akpm@linux-foundation.org>, Masahiro Yamada <masahiroy@kernel.org>,
 Han Shen <shenhan@google.com>, Rik van Riel <riel@surriel.com>, Jann Horn
 <jannh@google.com>, Dan Carpenter <dan.carpenter@linaro.org>, Oleg
 Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Clark
 Williams <williams@redhat.com>, Yair Podemsky <ypodemsk@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH v6 06/29] static_call: Add read-only-after-init static
 calls
In-Reply-To: <20251030112251.5afcf9ed@mordecai>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <20251010153839.151763-7-vschneid@redhat.com>
 <20251030112251.5afcf9ed@mordecai>
Date: Fri, 31 Oct 2025 12:52:56 +0100
Message-ID: <xhsmhqzujp9t3.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: axZaxTVr_dIUc0BHHHi8xQPz0UCLIGGWsK8-UsU-H_w_1761911579
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 96048C0005
X-Rspamd-Server: rspam02
X-Stat-Signature: mxqpb71djy3s9781pfa6q4c55fq6n96z
X-HE-Tag: 1761911582-184819
X-HE-Meta: U2FsdGVkX18wVxM6vzDbr8U8GXYmHsHAW5Dvn8PNA4H5NE4mrCu2BHtF9oZCfx+0jigr/rgv3NmQQih2QI+Sary0UoIfqpEnVqbfSyPlXoIM1fhSwaVDUf6+ieNFmxbOHPMlLbwmTWwtl9xyQ62NqpljQLu/3arHN3Ufh43/CQb4jNuzEsc6ylkbB4b8qKo5JhKIXTJzrNA9c65l9Td1fR8kuJZbtoP6Rrh/dzutiMRblztHjfZ5fL6xG1cRRBKvTtHui/2kcrfFtzy4XlYsugMvjfAkNlIkfuJdv9tSRdxkIb9EY757AUeHanR6GWrKZdZcNY17qmkt/bbDBpc0Bl8TrVEblFQleTaoYeMsljOh8ObJFWOgVqDwbihXziakIahtBM9lqzq7l5cdBRhYXCUAOg0M0wmyxGHQroCyUv3/RBIsCi9RgeFSwNfVWNjkBlywI0/ImNZQCMjx/LEqRV13uQ00+NedSNT8QkbzdYq3UDKmtOis5RA8ldCfrPFgs2Dz3wJULvEklt4Y0AOCC2aV/T9Va3RD1cP3ayW6cQJhDKfx0MxNurNx7IHpr5PQ9KWRzOZa8gygXA2js7UcHJshgvGeALvDhrGEC9fDS5Lf/rsOINSYEDu8jueVylGjbe17Bwus+MpzxZ3hw8d1Mg5jcPf+guYxxn4ADcZ809ueMVlDDwxSBIXDmWox9DcyOewg+doIaxZg/HoEVW6DwCfjMkIWINsftsKx0cs+8ylEBhqjK3ndkBOERfgWKlcMpJz/iKixQRAeWIKuddgP0r+4XCvB6bOHKcgsPQBjBjVKMmHAhjBCVHYpLs9GJXRUFdbeOO7MSJ28YQtzASTzgFelFD/TRsaeyo58AMU7DQ9W3pP4ZnZrVLhZ2JNTairRYv08qmTtQhxRApnnKbFSG5jLv+ezbmnMuf3bgnrW89tcsy9a/aLvqgx7roNhinvS1lgaOxN4fQ/HSXzbwE9
 +Fif2iRX
 BdCeGf8IzsbAj1KvwrniyATujmIDFphLjXU4kUNlX93YeANzUMWiqyL/6Dlpi9IqACJbvq+yi2+oc8Zs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/10/25 11:25, Petr Tesarik wrote:
> On Fri, 10 Oct 2025 17:38:16 +0200
> Valentin Schneider <vschneid@redhat.com> wrote:
>
>> From: Josh Poimboeuf <jpoimboe@kernel.org>
>>
>> Deferring a code patching IPI is unsafe if the patched code is in a
>> noinstr region.  In that case the text poke code must trigger an
>> immediate IPI to all CPUs, which can rudely interrupt an isolated NO_HZ
>> CPU running in userspace.
>>
>> If a noinstr static call only needs to be patched during boot, its key
>> can be made ro-after-init to ensure it will never be patched at runtime.
>>
>> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
>> ---
>>  include/linux/static_call.h | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/include/linux/static_call.h b/include/linux/static_call.h
>> index 78a77a4ae0ea8..ea6ca57e2a829 100644
>> --- a/include/linux/static_call.h
>> +++ b/include/linux/static_call.h
>> @@ -192,6 +192,14 @@ extern long __static_call_return0(void);
>>      };								\
>>      ARCH_DEFINE_STATIC_CALL_TRAMP(name, _func)
>>
>> +#define DEFINE_STATIC_CALL_RO(name, _func)				\
>> +	DECLARE_STATIC_CALL(name, _func);				\
>> +	struct static_call_key __ro_after_init STATIC_CALL_KEY(name) = {\
>> +		.func = _func,						\
>> +		.type = 1,						\
>> +	};								\
>> +	ARCH_DEFINE_STATIC_CALL_TRAMP(name, _func)
>> +
>>  #define DEFINE_STATIC_CALL_NULL(name, _func)				\
>>      DECLARE_STATIC_CALL(name, _func);				\
>>      struct static_call_key STATIC_CALL_KEY(name) = {		\
>> @@ -200,6 +208,14 @@ extern long __static_call_return0(void);
>>      };								\
>>      ARCH_DEFINE_STATIC_CALL_NULL_TRAMP(name)
>>
>> +#define DEFINE_STATIC_CALL_NULL_RO(name, _func)				\
>> +	DECLARE_STATIC_CALL(name, _func);				\
>> +	struct static_call_key __ro_after_init STATIC_CALL_KEY(name) = {\
>> +		.func = NULL,						\
>> +		.type = 1,						\
>> +	};								\
>> +	ARCH_DEFINE_STATIC_CALL_NULL_TRAMP(name)
>> +
>
> I think it would be a good idea to add a comment describing when these
> macros are supposed to be used, similar to the explanation you wrote for
> the _NOINSTR variants. Just to provide a clue for people adding a new
> static key in the future, because the commit message may become a bit
> hard to find if there are a few cleanup patches on top.
>

I was about to write such a comment but I had another take; The _NOINSTR
static key helpers are special and only relevant to IPI deferral; whereas
the _RO helpers actually change the backing storage for the keys and as a
bonus are used by the IPI deferral instrumentation.

IMO it's the same here for the static calls, it makes sense to mark the
relevant ones as _RO regardless of IPI deferral.

I could however add a comment to ANNOTATE_NOINSTR_ALLOWED() itself,
something like:

```
/*
 * This is used to tell objtool that a given static key is safe to be used
 * within .noinstr code, and it doesn't need to generate a warning about it.
 *
 * For more information, see tools/objtool/Documentation/objtool.txt,
 * "non-RO static key usage in noinstr code"
 */
#define ANNOTATE_NOINSTR_ALLOWED(key) __ANNOTATE_NOINSTR_ALLOWED(key)
```

> Just my two cents,
> Petr T


