Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6405CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 16:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BFD78E000C; Wed,  5 Nov 2025 11:24:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1700A8E0005; Wed,  5 Nov 2025 11:24:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0375E8E000C; Wed,  5 Nov 2025 11:24:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E2D7C8E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:24:38 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ACD1857825
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:24:38 +0000 (UTC)
X-FDA: 84077076636.26.6052D80
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3F852C000F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:24:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dsibnOTX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762359876; a=rsa-sha256;
	cv=none;
	b=igyZ+YNtoG6o6qxiPM7uW8gPAclbz495O5/q+q/yMPEUbzk3HSXjXm/UadUo1alhzFlQl2
	MuG/UQwIn8spYrbxxU7BQeMAKuHWGWhxSsMMTybMjgFVqGG+5vK1cpXI5v93ecsVNpL9Lj
	VJbJvYFByQG9C+2Ma99kADTNQfwGRxA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dsibnOTX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762359876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3pRDkw3OiFwhnb76GBtLAGbxTsylSIgAC6rXytdCdKE=;
	b=usHaV4A4uqqHQuUUC7xl6zSgJpE/eni+hP7Sgyc3ZGosnHSo7uc3DXX6hvO180w575sSqA
	TqDo2aF7WQ+mDYFdcJUGdqBkwxe2S02EpA4CYsVhQTjWNNVNwP+GePbg7n0y0Uk7OA7aot
	Em3XawgJWqQoGcjLxmb0kAOgTqG7nQQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762359875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3pRDkw3OiFwhnb76GBtLAGbxTsylSIgAC6rXytdCdKE=;
	b=dsibnOTX1vhCWey85izUGyetA4hdx+49xNpwToWVcFcLao1MuAX3uj8gUVP5E7eWKHjq5n
	8MFpaYBhwXJDddkE05plPeji2bNM9FWK01eC6vwf2r+k8ENppGQP0nmbRFdGz6T6o1OonR
	C99DR7LrKAEkexIg97WE6Y+BMd/1giE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-_FI0wE0pMG2wz8nkQD1uRg-1; Wed, 05 Nov 2025 11:24:34 -0500
X-MC-Unique: _FI0wE0pMG2wz8nkQD1uRg-1
X-Mimecast-MFC-AGG-ID: _FI0wE0pMG2wz8nkQD1uRg_1762359873
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-429c8d07874so5582f8f.3
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 08:24:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762359873; x=1762964673;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nPk6YcBuruLXQ/o+Uci3gsoXIOQlnGdWukNwLQbwsoc=;
        b=qIlLhTbq1tr1GRiYTcNwH0tV5kV/wQZBz5yfbclexylJITVyBdDGhXUjv5gPzAPXZU
         TQ9nTKIXhNPfefhb0HFXbgx7vPyp7s4C9+x8hbYumdWbJSCJfDmRXaEGx0qnbMOBbh+x
         60TD1/V4hyHkiyuUxh7p8CQHESU9RNE6idNhb5wR95DEIAXkEMfPWvTqCFjhlHQTgEZc
         gDKCr20BjjPgRxKWH5k/9/c0pxp8HmP23e62WLEYmjcKBTS/NGAlvk0BOm/BMxbZj+8c
         CHLK6he1yMSnsua9Pokbl+dUT4JyuBxqbPnzvkhcKYHeWM/yVDC+0GbM/kw/wDdMTrOi
         JYVA==
X-Forwarded-Encrypted: i=1; AJvYcCWUSqjdtErF/WkkligDbvN52QXevMAJPlj0cSORu9+++1Ry0tgwulKswmcy+o8vs1rKnM3LjwV9Wg==@kvack.org
X-Gm-Message-State: AOJu0YwxMSw9EGhJDEyzTZ4WU5O7tS1bDreDnU7lk6zWXPlp4k+x/hDs
	qjVN+8IzxI75NLj8BNmRWqfvqRh3KxrE0Nv3jdx0y0E6dX7idTzDgAZLftFu0g5txXkw3dfjbXW
	NLiaKNDp/dIavcLkf1IhL1EOax4cEdHn4vWT725jnuDl2mtvSePXW
X-Gm-Gg: ASbGncuSLysHY0UqccO9b3zWwOAw8gCk+iPvMHgU1uMjVhCVsF4ugrh+1I6U2xbV/4N
	p0MrMbd2+404h+A0PkPyLJCjHRLGxVDEKyLYj1kUtyTw5oMAz24Y4g6V5QMul8eQCv9e7XOf/3x
	Wu6vL3/QzrlU4X+bNlRjlnXa7otjCccIRDzTooy9B+3WKAMaerNO9wQbdKplHAYwJUf8f+kCQ1A
	x5iovENqdDo/aNPigcjKiOK954CQVZzE3JVfB1UzLfpGGSz1Esycc5ryKaZYT827PRXtDUvRXeP
	dnSBkY9OxHVxHhZA3opqk6fFZl9ksEOBYmJgpCWJxC5E5RwxcjS56KvHFBw/jxC76dQpQjTVSsP
	Cu+sX5PPjzhMgLUGNyAoFNfO9+xyAv9E9Y8vtj3CYYOlTSmC6MSisJLYag6KF
X-Received: by 2002:a05:6000:2907:b0:429:d4c2:cadb with SMTP id ffacd0b85a97d-429e3311ac6mr3563211f8f.58.1762359873186;
        Wed, 05 Nov 2025 08:24:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEL75fsQ0H2l1YahgWByyszuFW6670iMBa0il80FwPsU0pgmLcV2khMdpXTiSamLH801kgv9g==
X-Received: by 2002:a05:6000:2907:b0:429:d4c2:cadb with SMTP id ffacd0b85a97d-429e3311ac6mr3563132f8f.58.1762359872637;
        Wed, 05 Nov 2025 08:24:32 -0800 (PST)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc1fd2a7sm11003113f8f.39.2025.11.05.08.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 08:24:31 -0800 (PST)
From: Valentin Schneider <vschneid@redhat.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Phil Auld <pauld@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, rcu@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann
 <arnd@arndb.de>, "Paul E. McKenney" <paulmck@kernel.org>, Jason Baron
 <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel
 <ardb@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, "David S.
 Miller" <davem@davemloft.net>, Neeraj Upadhyay
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
Subject: Re: [PATCH v6 00/29] context_tracking,x86: Defer some IPIs until a
 user->kernel transition
In-Reply-To: <aQJLpSYz3jdazzdb@localhost.localdomain>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <aQDuY3rgOK-L8D04@localhost.localdomain>
 <xhsmhzf9aov51.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <aQJLpSYz3jdazzdb@localhost.localdomain>
Date: Wed, 05 Nov 2025 17:24:29 +0100
Message-ID: <xhsmh8qgk5txe.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kvk-pLSKMXnmhfhSeDc6_eyUFUU1dD9VCpWME4v3CO4_1762359873
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3F852C000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 1z53m8sk5d3obk3embzm567zyqgfe76w
X-Rspam-User: 
X-HE-Tag: 1762359876-946605
X-HE-Meta: U2FsdGVkX1+iDUliqOQvdkb+leGhvBwnMysLO6n+Zp+iwAN3MWAVMgMEPWdpdYw0J7VKE9ku58DI/En71td0XM7XJD0eOlzXqHnaZFAIAMymb5V7hSvrY/x5JuCyyz2Pkoc3gf2kJYBvEtKHCEg0DNeVRES8YHpSs613GPqiwdnoBtc4zjQ64q/f2QIBJmpiro04px9WczCuGJWxkQfE/UbofaxppqRNtRqOBTXFbm6Wzm1ND6rXGooO9uwbF9MQzMj7R8CtFt44Vp4GKKqZI4XdLrwngTUFYptcQJCKPRPJP/1Z6+NWRCNHj1gBYlMQTuULM/LQ65KR58Scgy+Iss1gJBzmE+dOE54tUwQ79fQc5vEcy8p62FiwYmC73hKAkhw13jjYrObKDDhkH7W18Hgk3SW5s5eGz6WkWGs63zfw7nkKaftgMyhLzkl0rYsueWbVlipnh+Ushr6u09kZI/CDm9BqnvkgDjvcKpmIOg66/QJiQwZg6YzXtsP2dD4WqcSXNG460O67JAXYdcGMFY0QlH76Am5BL8GxLlJsi8NNqc4bMoNCRL+Zvqm7LPnsrr081XRPo+wPcWs4NCd/NEhNrQ1ojspg+DJYJuGkAeBgk4ddXkfPT+eyUnYDuHWTzCQ/B6WwFxsNdyZS85WuBrR9YeFzgzR0LLFrdhS9/NOuEQeqIJUi8RahVj2Hn8dPI14b/nRAMUnzXxzlNZ/dDECOUDZVy4alnv7QuUIG6k+i0G83TBSQ7LIyEfzFSq+G1cbYcP+3b84GW2w2MI7BqP6kiW4WCBY7rqZ3HFu1zdBLZdAI3Q73rvSQtgHpjOWEIEl1AH7r3QYC8ng0T3Jq1HVJL1NikrI657l7wZQ2krv4hUxkLW/cLpYgsq8n2QtYyvJWn+jlgxcuAwMrxKKBSBVzYliQUP/T8ACW6ER1fmAFILD69JK5K7wM7zTl0mgh90IKWJ6PbaHPLtby/0C
 l8WaqJO/
 vDJeE8RC40uRBvFOA64lSfQdvtSk+FInkDjggsrDvKFoLkqaY3Y1SuM5N4xNmevNHNg/3LYKQplU/gUFczrtgi5mWR8fMEogJm3hWKGqKdJFx/vd6WLLa1WNpJ9ypsUikewnR1Z8DEzvEdeGEt5+AdTwkZP9yRFUDMGrMpSRFw62Ktp2jHlA20bCOg6lk4Tt3m4JA75MRkiruEheUwuaF61kEKozVmunqkcNLJdGeapuMa6MIuQ7VjWKDyXdOuBdPBFHSMjhcYM18gGEjkX6O28VSvQd4gui5PlH2Iip0qgZhpPWg8YqxI1Gd2mIx/TqeYZWJ/3okGbB5xonFjd5nCDHKnP+yBDGRVKw4L3HwbeVu9WRzD0yFD+UzxZCkQEWQMqXhvKqyuAzilWaG1amfyq6vpmiuDli2QNaozzYl08iA8du2fyTZa0E+nWMqIKCJ0ORDTXo5hGHPa6UHjRWZ2PJEyzmQy2eJOKhg/EScgNLn7+I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/10/25 18:15, Frederic Weisbecker wrote:
> Le Wed, Oct 29, 2025 at 11:32:58AM +0100, Valentin Schneider a =C3=A9crit=
 :
>> I need to have a think about that one; one pain point I see is the conte=
xt
>> tracking work has to be NMI safe since e.g. an NMI can take us out of
>> userspace. Another is that NOHZ-full CPUs need to be special cased in th=
e
>> stop machine queueing / completion.
>>
>> /me goes fetch a new notebook
>
> Something like the below (untested) ?
>

Some minor nits below but otherwise that looks promising.

One problem I'm having however is reasoning about the danger zone; what
forbidden actions could a NO_HZ_FULL CPU take when entering the kernel
while take_cpu_down() is happening?

I'm actually not familiar with why we actually use stop_machine() for CPU
hotplug; I see things like CPUHP_AP_SMPCFD_DYING::smpcfd_dying_cpu() or
CPUHP_AP_TICK_DYING::tick_cpu_dying() expect other CPUs to be patiently
spinning in multi_cpu_stop(), and I *think* nothing in the entry code up to
context_tracking entry would disrupt that, but it's not a small thing to
reason about.

AFAICT we need to reason about every .teardown callback from
CPUHP_TEARDOWN_CPU to CPUHP_AP_OFFLINE and their explicit & implicit
dependencies on other CPUs being STOP'd.

> @@ -176,6 +177,68 @@ struct multi_stop_data {
>       atomic_t=09=09thread_ack;
>  };
>
> +static DEFINE_PER_CPU(int, stop_machine_poll);
> +
> +void stop_machine_poll_wait(void)

That needs to be noinstr, and AFAICT there's no problem with doing just tha=
t.

> +{
> +=09int *poll =3D this_cpu_ptr(&stop_machine_poll);
> +
> +=09while (*poll)
> +=09=09cpu_relax();
> +=09/* Enforce the work in stop machine to be visible */
> +=09smp_mb();
> +}
> +
> +static void stop_machine_poll_start(struct multi_stop_data *msdata)
> +{
> +=09int cpu;
> +
> +=09if (housekeeping_enabled(HK_TYPE_KERNEL_NOISE))

I think that wants a negation

> +=09=09return;
> +
> +=09/* Random target can't be known in advance */
> +=09if (!msdata->active_cpus)
> +=09=09return;


