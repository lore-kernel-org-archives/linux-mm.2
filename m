Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA207D116F3
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 07:50:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89B566B000D; Sat, 29 Nov 2025 02:50:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871DB6B000E; Sat, 29 Nov 2025 02:50:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7872C6B0010; Sat, 29 Nov 2025 02:50:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66A9F6B000D
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 02:50:55 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 096841408EE
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 07:50:55 +0000 (UTC)
X-FDA: 84162873270.13.E3B85C0
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1CCBE1A0004
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 07:50:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="asWVBs/Z";
	spf=pass (imf19.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764402653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+HsHRBtCziZ+LzyVdR/+QBu72ws9YgkNkjzvuF4X//c=;
	b=JF/2bwYNt2ts2pY3tMtRyauSnYT01P4iEGMMJCIl/5aZFNimmVFxZSZmxWOgLj/b0ek0ZM
	I5n8y1HcnO65NjbMcAf+s4q/NCxV39krx9r71TKqtGtOzn8wNEg9Lx5LSZt+87+1KiMIym
	B2iGhmx7X3lFbPeCSd93jFSUYNoGVjw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764402653; a=rsa-sha256;
	cv=none;
	b=XrK2AyuBmsv58R7m8OAIRtNSG9Ma9NGLRxWxHY34QRoLxJSsXN49NE+W4fiUYVFTBJ4FSI
	dkxllct7DDd3a/3hHmhrOzFRpPbpAg87CN/xVgN9ipf7bMCoeCjZSl590DjacZg3VqKuR5
	aXQVtGA5mbh+0VgrPZW35aMqL1kYUgE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="asWVBs/Z";
	spf=pass (imf19.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64320b9bb4bso4994150a12.0
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 23:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764402651; x=1765007451; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+HsHRBtCziZ+LzyVdR/+QBu72ws9YgkNkjzvuF4X//c=;
        b=asWVBs/Zzq/RzYPaFnMMXxANOhhbS0aRVgnUSnjs3f8018AcsVCojSqphtjxXTPBE1
         /TopfpVaklSkTmi/RfpaQlVtEmnFU5llOQEXTXo3GKURwMLJVyiM82GDKY+A7uoYW5yu
         cik4BYj4q8ih9NR6SEr04z8u5HjVd75KhcV/RfNl2N96LBPnh3j+IPCWxNmpvVqpoUG0
         9/JfeSMEy/VVq3d+yZ9/dLm57DQyZAvFs+g69OS217smpQUsea5L+Z1MkvKl+uNjJky1
         NLH5L9oxtxHDHza+VbQTR8KcDb247Pid3g0DvYDTc0UOhCSLWZXFmRH5zSkfcdgqxtOF
         Sekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764402651; x=1765007451;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+HsHRBtCziZ+LzyVdR/+QBu72ws9YgkNkjzvuF4X//c=;
        b=Ai//bAmLv8d41brFgtTdDoQb5JwyQYIEPZQICrFk7AHeo+q+/2L2BKM5Prw5HjVm42
         lSCVoS0LHdH2yUqzZ3s9Q59OLYoFEk3PHA/VMKAzywK9p9Gstt0xOlI9Uv18ElrO3iY+
         WMnouYjw6liR5mX5XtQEOrrxWFiy8hblKj7knWCYp9fVnMOCDUZkAmcIb7rZYuvwA6BK
         TEt5ajUXQ1NOkQwxEJcJ6l5WeeNIJDXcNkh/8IXI4JPgknwwAFcDwjmPxR+mt3VJW+FV
         GKiNxETK0z0uJtmgNyUEvZ1SBuXfcH9++ZoTwKHz3U7W/wt7Fr3jNOtRqUMgFufDA8Gy
         wFEw==
X-Forwarded-Encrypted: i=1; AJvYcCUly02+SzSe4/H64E0VQ4VVEShhnU+1Coef2ui3fxZmrSuElCX8lWh1C+Ew7akd97PqTZlUivZUJg==@kvack.org
X-Gm-Message-State: AOJu0Yz7CkU/MneQHR1Sg9T0Y8ZhvZK+ViJI9KkI2M7DD8s1DsAoPlRy
	AFtxRPcQs77KjI3yKcwZFgU/y+5GxCHw0Gs6V9eUFasm1tCe1NE8x82M
X-Gm-Gg: ASbGncsGL6Xnunl2lnJ+rOoasOyDCx8uH4LVPcYDr2daCHpbT+R9yvE+gTImAVPFeik
	1bLs6dgw+CeVovKebZG9orpZbMTILbjJhJgQV+JdHTht2q91KfjzQrwz1MCF0f2rk2UlC6FkZ0q
	ZTwkZoBgPSM6EsYY8VQSNGn5uwwp4WhZNUShucddqp8rb0+OFwOO/p4sqebCVnX+4zrUXLTLv/F
	M/txwza8wyaDgs1vjLN+Hg5tHB5UGOgl1zHBfwNTCTxfzKvY6DqcnVeA+5v5X6Z09jwXILYgI/B
	2BF4xmj8GLCNcFY7SlkCYlgZcVQIyaEFcVS1iH76vp8gNYyRBvetou3LVPakkL0TnKSxiRr5Qsb
	bevrog+CafDSjo0YKrJEjKjuL7VSE5q/EUizX1dVIM2h2ke0eg5rkQRc3oSIjVg2YM0fca5brWK
	h5/B9DzfYqeYotdyeIThCB+XE7nl89AheMccpk227RGh7d11d7/mPlsKKY
X-Google-Smtp-Source: AGHT+IGr5+RJU8TJE5XhEbLjl2W6ooWa+nJ37imMnPXoLYQWPTkCsejf4lJHl8vrBnd1A6WocQ5riw==
X-Received: by 2002:a05:6402:1641:b0:641:5a05:c72f with SMTP id 4fb4d7f45d1cf-645396af1f3mr24762510a12.16.1764402651262;
        Fri, 28 Nov 2025 23:50:51 -0800 (PST)
Received: from f (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64750a6e873sm6530678a12.5.2025.11.28.23.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 23:50:50 -0800 (PST)
Date: Sat, 29 Nov 2025 08:50:41 +0100
From: Mateusz Guzik <mjguzik@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Gabriel Krisman Bertazi <krisman@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/4] Optimize rss_stat initialization/teardown for
 single-threaded tasks
Message-ID: <qmmncacgzhby5ewkzbu2gc7dovawyzevgyhwmdp6te6ez3svp2@ns3bcq6dvq6p>
References: <20251127233635.4170047-1-krisman@suse.de>
 <f1a1b7ba-c084-4e41-9242-8255f2664b76@efficios.com>
 <yvghqmbugs3oejsvbh5rrw76rvtr2wfwqysjd7tw67z4tzpdbp@6zehhuzumiez>
 <CAGudoHEyX1gdwG_MVf-M2KMHBE1Juo6VbfSyp3rbXoS+5JaNtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGudoHEyX1gdwG_MVf-M2KMHBE1Juo6VbfSyp3rbXoS+5JaNtw@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: sfk75z7bo7oim85k19ggzw3cto4ry5gp
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1CCBE1A0004
X-HE-Tag: 1764402652-387458
X-HE-Meta: U2FsdGVkX192JUUCjQdZSXGPX/tiL71eLyQap/38cjc+CcdJgCwevHiGQ21tU4WFPxMjH02My+fk2CDh3ew53o7MSr6aAm3l3WiZLUZcj1TfyDNoqroVZR9p+mutQbckNCht3trvc0KLV518paFEkeFLTUr3e89ZrnaCLcpIJPLRGCplcUKBRNgCYq6e0LDq0/lOx4pzL+/jz9m/97w5LOxJtDCa0vK5TZPGCvCVIrDpiSS2tNnlWtoGbxL3CYK2dbtgC1SxEcgcHlbJGJ0QJXHKB2TBXL/H0FBe+NpDthiTRby6YNmj90LZOOoMWd1plxbX6g2+7S1ONwPAcAAWB5J4fq108YPKSmsuSRgJ9lqWtKtEH9rN6IHhwRwiHW3Fxz0cy7EXyOYKGr0C0qcec4QNhf3xNTLsMdYb7e+Udr1vEJHm2oN/4Sw1eSzhramSzt2Z0MsOaYvpEU/ZCaDqC7ib9cc1TAb8vFLzYYhAJjKKxqID5gbxtskJi1/poY6EBmTee/Th7j30+iqOrLAbX03scJoc3s79kFvTSCSDSE8//Dl7K2oFAZh/luWBI8NEUQbB2lvcaC3VtvK5ZnHi6dmkN7PJrmeLBmj4+DInkfdGLLPPnxLgckbINDPzrDp9GblfPEeKQN48LugbmwHoPJ5mdAtmewa/drZ5eg6TsyamnlTzNjPFM7UN9UdtcQ73yweBRPNr9eGOO51lNVmwn2RisEqtufBN3aIXh2O4qi8jygEbO6GoPObvV2cmnXkbpK5osXhmC7wxmgjGIDtLQPPjveK9ZljNkp0xb3QbIp7Wk1o4iUQucTXagivfwT8uHwTM4l0akz/dqUZ9WZLXgfcPtZlINDeDYBmV86LQuc5ymFFs1OMq2FRN2ZMwW8FcZJ+fmgNbIh1VyRbp6zKMMbhaJurZ8zgzPBXOPnk+KhvkLwovFl72COmFiX89513KDaxmgpH/trmVN/ctJbL
 gwTcX9bC
 R/v9tkg6Z9b5yElkcsTLA9DvfgUjpypBE18Fgu+brXnOkk/1JhL2ZepTfcbkxSzaS7sbmsZIu2OxWItgDUYsFKwua7F29OyMpouUBeK1Y/6iPhaZKOpTa+asgD/OOvl/qhzERjFXsHABPUYlSuYA7cloUhnwRd/gm/iDKSOeia47Y/pM2jr7FngacCpZKf9/GJK13XknbVuWQwe74hBekfyqNbSU2m3yrigYwEPgTmhHmUfxklSdyt/Hm4RCn4Dd9pk9UCbdQ08sa52QtqwLA0DlNfOwOvDBzWE+P3eQHH1zrb9dKBpp8xkwCWZ64C2o7vIrjwvAlJYgu8C0llbhdmLcvOZfRjjBIOKc4BsHIjnC3hRsvbfQgVstSevrsfQ70q7MAMwG8Gj5F3Eq1yRXPcy20q2VjgqxMiX8BFCN8DdCsHg41s3/2d+bFl/D6NTibuMnNU881aRrbzS5Z0it8btRuhyxyUVlIbska
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 29, 2025 at 06:57:21AM +0100, Mateusz Guzik wrote:
> Now to business:
> You mentioned the rss loops are a problem. I agree, but they can be
> largely damage-controlled. More importantly there are 2 loops of the
> sort already happening even with the patchset at hand.
> 
> mm_alloc_cid() results in one loop in the percpu allocator to zero out
> the area, then mm_init_cid() performs the following:
>         for_each_possible_cpu(i) {
>                 struct mm_cid *pcpu_cid = per_cpu_ptr(mm->pcpu_cid, i);
> 
>                 pcpu_cid->cid = MM_CID_UNSET;
>                 pcpu_cid->recent_cid = MM_CID_UNSET;
>                 pcpu_cid->time = 0;
>         }
> 
> There is no way this is not visible already on 256 threads.
> 
> Preferably some magic would be done to init this on first use on given
> CPU.There is some bitmap tracking CPU presence, maybe this can be
> tackled on top of it. But for the sake of argument let's say that's
> too expensive or perhaps not feasible. Even then, the walk can be done
> *once* by telling the percpu allocator to refrain from zeroing memory.
> 
> Which brings me to rss counters. In the current kernel that's
> *another* loop over everything to zero it out. But it does not have to
> be that way. Suppose bitmap shenanigans mentioned above are no-go for
> these as well.
> 

So I had another look and I think bitmapping it is perfectly feasible,
albeit requiring a little bit of refactoring to avoid adding overhead in
the common case.

There is a bitmap for tlb tracking, updated like so on context switch in
switch_mm_irqs_off():

	if (next != &init_mm && !cpumask_test_cpu(cpu, mm_cpumask(next)))
		cpumask_set_cpu(cpu, mm_cpumask(next));

... and of course cleared at times.

Easiest way out would add an additional bitmap with bits which are
*never* cleared. But that's another cache miss, preferably avoided.

Instead the entire thing could be reimplemented to have 2 bits per CPU
in the bitmap -- one for tlb and another for ever running on it.

Having spotted you are running on the given cpu for the first time, the
rss area gets zeroed out and *both* bits get set et voila. The common
case gets away with the same load as always. The less common case gets
more work of having to zero the counters initialize cid.

In return both cid and rss handling can avoid mandatory linear walks by
cpu count, instead merely having to visit the cpus known to have used a
given mm.

I don't think this is particularly ugly or complicated, just needs some
care & time to sit through and refactor away all the direct access into
helpers.

So if I was tasked with working on the overall problem, I would
definitely try to get this done. Fortunately for me this is not the
case. :-)

