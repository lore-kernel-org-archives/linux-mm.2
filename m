Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5965960A2628
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=UGB+QvoT
Received: by kanga.kvack.org (Postfix)
	id 7E5AA6B00EF; Wed, 18 Nov 2026 09:47:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BD5A6B05B4; Wed, 18 Nov 2026 09:47:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ABBA6B05BE; Wed, 18 Nov 2026 09:47:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9876B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:47:41 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7F361C41D0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:47:40 +0000 (UTC)
X-FDA: 85448518680.27.D1842BD
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id F2D611C0002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:47:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=UGB+QvoT;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795013259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IgtmGgLwdp7YHZZLZXtmuM3LeEAEVVcvQiETOOFbu8o=;
	b=aQ297mLyHyca4KcZSAnclwOzbWaN6nRKBogMGSTJQMsFCk0+Co5G2LeACyLKiUTgufvaCE
	6F83YrzLuC0SD11j9IJzJXrQqUNote7oBgbZqloOWHqnO7+w8t5N3wVrhoLOTFL1CYzyUc
	JHDhzcngBqvF4XJ29CCk5txIjO3YgRk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795013259;
	b=g9VtPASzZZC1BQ4tCFO2AH/O+6tWJPF7Z9jz6+RvqzvE/jfOJqXHeP0FkXrqo+3DewP5as
	B2Y8jT/X9LfCty3LS8CgTVZQ+v4jN2iL412Lo4SidIkMj5sS5rMzHw1E0Xl2JQZXwohYRS
	K1aWsrg5LW3UjH9xORk/SklG+HMUVyw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=UGB+QvoT;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-949664ee41cso133415785a.3
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795013258; x=1795618058; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IgtmGgLwdp7YHZZLZXtmuM3LeEAEVVcvQiETOOFbu8o=;
        b=UGB+QvoTkmRi2i/+YTJXpCXcL+ZCyNVY3D5PuRUyA1MBxio1jQWEjyZlVaF/6sRKp8
         B1jvoIcPA7brpbuz1LtlzOjU2kxzTsETlGjKl6CxG45sRB7hGj3QM+sJiztfy01NXg0u
         4UzJSQcb7SVlXM737Jd7CalJs0A9CbrmylP+txY/BR8a3royc51i9ERaS/vcsdzmLC3d
         3RAFZ9tEIXuBHkqUGkL2yRA7IwiSJirHcYzgthb8ncdrVKejAJsKpOuGaNuYz79LnSLo
         Jdq5+FrgV7X622gBhO7065E6oKz0fB00LVGiczisUB9LdZO41xb4JTQ7qh9SxkMWLwIW
         bwAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795013258; x=1795618058;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IgtmGgLwdp7YHZZLZXtmuM3LeEAEVVcvQiETOOFbu8o=;
        b=udT0wz32Dpk/M85lL3y6Q+P5TVkh43Rus6gpLSHOQ21nzpPUfRzxePs/1ZAg97FEkq
         VEUcvvo4PMZwXqnsXgW0/8BT3un4df4hX1fUUw0aaPlflgU1CvauIL39M3hT2c2LuWWz
         b+Nsqo9xEi8mM7bL7p5xAFnZMbwy51ZCSBucTuAfnaEG2x9DUTpJFTv/LRGZQ50WAHR2
         amsbONVf0sj8pb6FK3J01d1vT2zd8hsAiCXPk9ywICEBZk7IU5LCHVnZli/zMxg6Qqpu
         Bo9Y6QXYuaaLg8e4qEjrYsigpcytXmzdbXXRjMU2msuUdtZ5gC9mwre2uNJjxwGkZQOn
         8j5w==
X-Forwarded-Encrypted: i=1; AL+hErHM8vFPd+R6mFs7iFGNRh+GESae9AePgFXgWPiJ5VgUG0M//OX+7rPWXmApdYPjaZdXA/fM0QG17g==@kvack.org
X-Gm-Message-State: APuU4Z8oxGGUFUMiNtuKqsewcb/uLzgPmriDogjjFavBUSDgs5czeQPJ
	SebjclvpnXNekA8XB72ZAQmu9T72dmkuaVwyIH8RRmDsiPwS/mp1SBFoym+cz1anXcU=
X-Gm-Gg: AYBFou3qug1qEkYpmt13FZ+BQ7yiBcm0fb2dBObP/b9wmNyYBhLP/xgsriCq462yvnP
	Z65JUqFhPYrGA/vWqRO5QEKtseHe/LL1cgv3GlpOv7hZFa8ANBVcjI3HPTbPaFuI1r48oaXSuR4
	PIM32DRMxAhfb6jsx+tdfrdwwTtn1VyhKiFLeVZCs/vdaoLSVo6JXqb+w1PSswMyPTjjAu3JJMQ
	y7JmpRpiHX5+zBX+KdfJMde+OFnRM2o3+ZpnM4NKh80BISuZ3c2OmdfgfPA32goGDYKIDn+m7pT
	8CYE/y1llqJtlk/nxoC+h04Ob4Pb9lrKI9CKty/CZXZ7CzTHuDvg5DFb9AdouDRGn+aT+stZjSA
	mq2Wd3GsebF3KDG1eHuYgE+RIew5ZR2sRG0x50WLEHeFWmvgKuEg47IkVqRX1gBS5ABEzawSg7N
	8mi33w+VueEu3eyUnrP8fGGAIUsEIuFai4vq/Ftp7jz1FIccOlqKNhkUmCXXzDYOnu9JDnPp1tk
	nOfVxRqtovJE21O4GtJsHwlAAZW+yhLAVh9dKSqpRDmpXsUyjfTlET3hlC3AoimfJK+3Ijx3eQz
	WzdDtbSDRf7Rchm/XxGe+0M21/Y1pjzZdE1EwbdiftHKou4=
X-Received: by 2002:a05:620a:880a:b0:93c:b5fd:f33f with SMTP id af79cd13be357-94999722106mr491978585a.27.1795013257845;
        Wed, 18 Nov 2026 06:47:37 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b81d4a0sm193898585a.43.2026.11.18.06.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 06:47:37 -0800 (PST)
Date: Wed, 18 Nov 2026 14:47:34 +0000
From: Josef Bacik <josef@toxicpanda.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@amacapital.net>, Ben Segall <bsegall@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	David Howells <dhowells@redhat.com>, Davidlohr Bueso <dave@stgolabs.net>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, John Johansen <john.johansen@canonical.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>, 
	K Prateek Nayak <kprateek.nayak@amd.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Manfred Spraul <manfred@colorfullife.com>, 
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Peter Zijlstra <peterz@infradead.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Serge Hallyn <sergeh@kernel.org>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Suren Baghdasaryan <surenb@google.com>, Valentin Schneider <vschneid@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>, alex@amutable.com
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
Message-ID: <wdwc3b5edgtgvrgqfhlzhrachr5hrqb7ahipcuqdz5pffxlc5b@662cpwhxwjer>
References: <20261117231352.3816603-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F2D611C0002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: kc8an684ptmeg1onihdjhhqth1u19yyf
X-Rspam-User: 
X-HE-Tag: 1795013258-859670
X-HE-Meta: U2FsdGVkX1908IujJ5WsmqWr/U2WfVTM7Sng1GiSbyNT0XxP5tZ2Dqs2fkcsbdobOskD9wkbjeiaiOMTx9J16GgIwt+0KbOEbh5z1wz+JGJCBr0pREgIaAxgjN7A10OngA09DGVPUWFy2o8fOZwTEQTOJDOGGOc7KVp1PeftP+4q0RdNxasZY6tN0+9zyjTLLTFGrqcLZ0/Q9OPQcVWPAYrL+lWcDNmQEEytMKrMcnWDVe2pRnqapdNE5i4EPT9nXJFfTen3vtikgcxsjz6TQ2kA5a+Hm4/H+GMNEXKf4PAoagU6PvgEoCG3qVwDNDYG8v6wkVV5LUEfegzuRVEgkbMlLo6aZOyOBIc/cEZCdh8dZnlmzhIMj8kWHmTO9NysBgi/eiZ3IAztK29jRP3nNzf0ngIV4eoBa/jBr0Y9Vi6/G73n6X6DipM1WB0Xy4Iw7MnYRdL2X+adb0z8FfHD687icFMXYFEZJYXJ5LgRESND8glOHYXLBetUt90y6YEisgvzYlhCK15QwpcdCaSi8nQgWD1D21TIeZymGcQB0y3JYTBPUNnl+fW7yolS+ITpaN8aJIdmprpUmukcrU4VImlOS6yzDMftg3f2JgJF1KlCS7mjjEVhFTqclR48tX/yrCbAh1Nhd8Ao64scxZdas1gWnwZvb2Fl5MVgGah5JvpOE33vYW/TzfZ+QhkY4lanT5MDBC3BTqQGCJOjVlHCFRob1qxapM4oUGXoSIaud6JamWcYOjuVBU/MAaH+Ge8v3xk4c8+TLpRSKWQfjYQ8UZFGt1bsl6NXhUd/24ZuVnv99dq80EXUWr+WtdyUgG3tyJIdn83uDTikPY0Y8MQ5hcyUwb8buAYS8I1kdK0klbpjrPvIEAmTMjYEOhWNOp9OpNbOahJa2SgV3Pl5JffPZtVhGFd4jPHJvGyiLN/VO5ttZMFzSofk/WT1SGxTJm7izxwYwZicNj6kC8hC8im
 9p4L6L+9
 E+T69FAxczh1WxPUkUDwfRhBANGEK5eOw7eEpbB0JGYeWXvi3fbrLZO7p7giZOKCWFFn5Tp7OPPXoOf+dTlp4vzX4xj/wenxq3Mnqw4j5nki7nVfKmh5ZT6WUgashEhpPl6Zq5E5s2NRdYLOc6EeL6CIVKmLyYhKyOsN5KmwfiUaG9f+DPh1BsD0zoTngOGoJ6V/3sROoBkahFsPhI4kVW+iVyLbkBEqeGRK9lULZ5sPpphZSrGzDMfwfQtZ06R6Ued9HE85m3vNmWc2LHLHF5oYA/D1BAldfVTUggy+QQz/jTw655z1TMQUYv9zLKOFeIlm/ZKqNp5aj83+mZEYG6JzQE/YXXxWoygaLIj0+PuDFWhI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 01:13:39AM +0200, Jarkko Sakkinen wrote:
> OVERVIEW
> ========
> 
> A root namespace (rootns) is a kernel object backed by a file descriptor
> that binds together:
> 
> 1. A full or partial set of detached namespaces.
> 2. A dedicated PID namespace for spawning processes into, signaling
>    members, and polling or waiting on PID 1 exit.
> 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) that must be
>    populated before going live, without inheriting host mount-tree
>    ancestors.

This is what cells is doing https://lwn.net/Articles/1102593/, you may
want to take a look at that work. Christian, Lennart, Alex, myself
and others are working towards this in a more wholistic way. There's a
lot more that goes into this outside of just the object itself. I've got
my version deployed inside Anthropic for securing containers and I've
tripped over a lot of pre-work that needs to come because we can tackle
this. Alex has my rough outline for kuid64 for example, which is
necessary for making sure we don't overlap UID's on the system and
create holes this way. The cells work/anything that wants to have clear
security boundaries is going to require that as a pre-requisite. If
you'd like I can include you in our planning so we can get something
that will solve all of our problems. Thanks,

Josef

