Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D49BDFEC102
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 19:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCCE46B0005; Tue, 24 Mar 2026 15:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA4826B0088; Tue, 24 Mar 2026 15:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB9E56B008A; Tue, 24 Mar 2026 15:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BAAD76B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:46:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66B6458BD2
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:46:19 +0000 (UTC)
X-FDA: 84581988078.06.162659F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0C71FC000D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:46:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dtu73KSn;
	spf=pass (imf28.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774381577; a=rsa-sha256;
	cv=none;
	b=gjsAjBv8L8bIJLYpTfRcC+QpnahxlG5Qw6qrEFUHGBggNFN8AlaFCNqQxXINlgWdb98eqp
	HD5kDSNdYKcSmW6D5y6NE4WkJi++61SAk5cWCUq27iqP4i+GuIdz47c2KdE2zAlG24w2wO
	LOErXmznDzw4w7TeqnT2LJe0POu1iGE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774381577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jfKSRA0ia5TBxEYus3S1w5DhvtkOE0LjE7GseOssoCY=;
	b=rmSiY64yyFlG7qyam5NyBUGMOUkNGldHmWWZSIgRPf+r3ceoibojfh7v67xgQUYXoIYNti
	SdeKOwrhaTEzGGyDRiWrfQ3EIiNFNKKzPqNwWd+mOnkollKnITvJTS88+xnKIYV5PvGg64
	9/kiF7rm/O63HTjRicaQvah8//GfR2Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dtu73KSn;
	spf=pass (imf28.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774381576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jfKSRA0ia5TBxEYus3S1w5DhvtkOE0LjE7GseOssoCY=;
	b=dtu73KSnbiarVqDZWEyI/J8Lf3o9dWpKxytdOybaN65KvcpXjv4DuB2obWt/ZbyBxHCB7U
	eHMBdhr+3oVtTKTTFPenqFwwlqxizr8qaHdnyPuQhuLx1HDluk/4xHK3Tvo++gus+ut1d8
	58i8QuP/ViG7UO5COAumzxemoeH1CS0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-w_9KoPgpOVu-m62ZuSLemA-1; Tue, 24 Mar 2026 15:46:14 -0400
X-MC-Unique: w_9KoPgpOVu-m62ZuSLemA-1
X-Mimecast-MFC-AGG-ID: w_9KoPgpOVu-m62ZuSLemA_1774381574
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4837b6f6b93so36540905e9.3
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:46:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774381573; x=1774986373;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jfKSRA0ia5TBxEYus3S1w5DhvtkOE0LjE7GseOssoCY=;
        b=H5MaBma9PH85Wjod5hUrMflGL96VLph3V44qJmOt1pcqPQ3iXrCtD+UfrooA+/9oOx
         I4xddTByJN/H5+G7piZrjftt+m5arBuCD1p1cY8Nqpq8CJE3YaLDq+UIySZp6d7OEuau
         xEIO25/d6oOXXZUTESkaO/hVkKttBtPmUn8vAgDKYKHgbcEWtr+9dVtCKfe2jTyjE/ud
         n6EjwgXPVUNqPQLCYpHoy74pfaN2NU6dvJZb0qAX4CxZ1WC0+np6XpZq4W1cIHnpIr7R
         CKndyaxuZ/QUvC5YN9WR6GGXmCCOoku/46ejvVhgGX4UpLeC9VBwMPg6NGsW84aP3Bf9
         GiQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCGns3EMreVv1EKvS6EjLs7snnaYrAzASp1HlPKAfMhbP/LFy81J1KqAzAegrz5x0eQgnL77gPGg==@kvack.org
X-Gm-Message-State: AOJu0YxJXCWfK1sulff+u8mOtVw04hqQfTw+MuKdIh8rMdkLpvOrjB+s
	vSQUcl6g6eztfNxLsEv07pL5k0gXmtjAiLJwXJsrElotZw/pzokYE1Zj/M1Is6xdtE88FQ85sQB
	/RTOqMHEZNjmUknh4xdWq7eTYj/uL/easuc+sCo2WSB0w171fWGVD
X-Gm-Gg: ATEYQzynBL12trlD/CGTtwdmz9VIuFCgi4jyUS2Yt3hknHRA8/P26vuPfrb9lfeK1bt
	nip8/nYfHLu2W/gLwQMqj639qOTtV6zL5+qxyjVtoedfKVKUa9i397f1ZsGlF0hRqHnyzw+ChRU
	aRpjgvqhiEZUC3WwFiuZ00RnWqXux5G1ACe8lhMqFm9Ehj3YskPVkaAAQTAPl1iSpyxdmqI7mtA
	SSO7+3YqAwmKPe6vHNCb5X7U8oGzzP0/LzUjsW7g0b0Y/6krcpOvNSu26rL3f6Lca5CWwjrUlwU
	+9OoCg0CoKvaVnnCmw4ciNO1op4hWYjqXZRgRkKXf1nzitPOvHr/rujNJzQPhytdwaa1vjjFbNc
	4xMcDFrf/ZUSbaJvmTepuSWopUl/PtDtPANLM52uugSm07kSJPj8EOmbtD8CKVQm5Pehq7ZRG9u
	qLMqBSoa4=
X-Received: by 2002:a05:600d:8:b0:485:3b34:2f51 with SMTP id 5b1f17b1804b1-48715fb7251mr10210465e9.4.1774381573454;
        Tue, 24 Mar 2026 12:46:13 -0700 (PDT)
X-Received: by 2002:a05:600d:8:b0:485:3b34:2f51 with SMTP id 5b1f17b1804b1-48715fb7251mr10210315e9.4.1774381572919;
        Tue, 24 Mar 2026 12:46:12 -0700 (PDT)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48716547649sm7811135e9.0.2026.03.24.12.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 12:46:11 -0700 (PDT)
From: Valentin Schneider <vschneid@redhat.com>
To: Shrikanth Hegde <sshegde@linux.ibm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter
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
 <juri.lelli@redhat.com>, Clark Williams <williams@redhat.com>, Tomas
 Glozar <tglozar@redhat.com>, Yair Podemsky <ypodemsk@redhat.com>, Marcelo
 Tosatti <mtosatti@redhat.com>, Daniel Wagner <dwagner@suse.de>, Petr
 Tesarik <ptesarik@suse.com>
Subject: Re: [RFC PATCH v8 05/10] sched/isolation: Mark
 housekeeping_overridden key as __ro_after_init
In-Reply-To: <c72fa095-654c-42c6-9e5b-1459b1b7e732@linux.ibm.com>
References: <20260324094801.3092968-1-vschneid@redhat.com>
 <20260324094801.3092968-6-vschneid@redhat.com>
 <c72fa095-654c-42c6-9e5b-1459b1b7e732@linux.ibm.com>
Date: Tue, 24 Mar 2026 20:46:09 +0100
Message-ID: <xhsmhh5q5gge6.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AXesf03arX82k8H05uyAIgUTyKVO4ZlHT4kgTnpK9FM_1774381574
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0C71FC000D
X-Stat-Signature: gbjwknfwrqfzny4cdensjyqzsfse6x57
X-HE-Tag: 1774381576-355552
X-HE-Meta: U2FsdGVkX1/0iZlj7kkEH+VPjfzmWTbTu+5alFuU2rJCRaSKaTRdms9lv87Jq0OmjUs2xkqiMZLLsybNCrCQ/wfPOzL+PsTJpq5nUYv7ZS/AX4YeJIoh2gniyyXR83ZdJWLwj9Wqy8L7lhU7W0rUJlZSEWx5DQZwfAsgU+DK6DzHLZVnNve+f8/iWWHlWLhsMLijIgYRgcdodgfd8782xAZmyPW/ns0clQKLl19XCbgXI6hVDR4u5+GRDrmNWdhoQxD/vx1HTuLOMVgteUP9cRhljdCZb+VDbTLUSKyJfDucjpkFDaFnbkV9CvfWM3e8ASWjv95F8WtbizTqG22SxGW2u/f95C9r2n07/HNEbg2G9PsilpIBnyNvSp0m0FdOsZqylaOcDDLFvYZDiNwWm5wA+ERkW9nrtLY21QR1+NSMLmpN+RhjAW7JviCD7PYiRLT7O50YN9f9mNUusWm/Z2qeX0JSxmIwm63dZL0dRTx5qSJIFwhvuPH5eG5P2qxJlR7lXq6zfJNRhiXInkct/9PfbP0Vj6tnSL0Cj4L7/JOQKJ5klFfM6KxwlvS9o8X022mPzJmfcU86ZpSkqH6/zBlGFhKpNwATroN7XeVptQTnij7Ei51ijyvhxk3pxHSCrT2KsudsjbUxTct5Q+QItrqO8pg8wkgyBlg9lLsh16W7fQJZMo0SiioEMeNYxkeiDKg0Evq/GI7Tpa6a6Q32NdcvU6H5kBXEDAsgMUdbjC2K63Wo9CPfhXBuvoxBObYR9gtNXyYA5Ph3cFtrdIL6WKyZeX3Ci5+scXHCNbas78s8JvTa/hd5joqMk8fTWH9dAJ4E7Vw2enCPjwizRmWTeIeYhKPmXLGJBf2DA9ai0vMf2nl01TOMBhdedGeyFEOYOn1Evh90jN/y4cfR0qTwVgSjGO1A2FWmKWiK/tKHoPlALmT7fXRF+72MkDqfQPuCwh0WnuF3XBGVt5kCQUL
 ekS2BcuC
 PSCmI9P1KY7kqR3Be4hqM8yE2r7odkDhusJR8G77NvtyhkGttrv2V5/iPZzOkmaNbtWj6svIM4x3C0KFCDA0qvihgFIupkKeQDkNKPdxRVNM9j9OLnmJIBuKvoLuJBYGE1G4aT0fmrggm/P+0QM/c1wPrpZb/Bshp8NzA0TvwIxJPFNisVM2T4igBCtVwJVGcR62j+MuzW9PQVTjTczI6RN79U6/W7/b+x3a5bUM6ZQWQbAdyIf0KfaUxvqmloKoNzylLH05m8vYT6ehoSyfkqCVI/J0v7blB5MVlkUfJT0HS8iJomVWl6NMfoN+5Z4Q2ad75jsgm2R2iC85HJX6BIBOQyEWxLDnD2NFGMzUSAl5l1Qw3/0aWEF+5hOuJBemIBIwkBMLSqUD/Uvw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/03/26 20:47, Shrikanth Hegde wrote:
> On 3/24/26 3:17 PM, Valentin Schneider wrote:
>> housekeeping_overridden is only ever enabled in the __init function
>> housekeeping_init(), and is never disabled. Mark it __ro_after_init.
>>
>
> what about housekeeping_update which could be via isolated_cpus_update
> when creating isolated cpusets.
>

Doh, I'd even seen the patches but forgot to make a note of em. So yeah,
that's not __init and the key is now flippable at runtime.

I suppose I could resurrect:

  https://lore.kernel.org/lkml/20251114150133.1056710-6-vschneid@redhat.com/
  + the is_kernel_noinstr_text() thing from
  https://lore.kernel.org/lkml/20251114151428.1064524-5-vschneid@redhat.com/

and have the IPI associated with flipping that key never be deferred, so if
we suddenly have some CPU isolation, every CPU gets poked.

>> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
>> ---
>>   kernel/sched/isolation.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
>> index 3ad0d6df6a0a2..54d1d93cdeea5 100644
>> --- a/kernel/sched/isolation.c
>> +++ b/kernel/sched/isolation.c
>> @@ -16,7 +16,7 @@ enum hk_flags {
>>      HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
>>   };
>>
>> -DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
>> +DEFINE_STATIC_KEY_FALSE_RO(housekeeping_overridden);
>>   EXPORT_SYMBOL_GPL(housekeeping_overridden);
>>
>>   struct housekeeping {


