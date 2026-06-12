Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30C18CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 16:41:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99F156B0092; Fri, 12 Jun 2026 12:41:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94EA96B0095; Fri, 12 Jun 2026 12:41:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8168F6B0098; Fri, 12 Jun 2026 12:41:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C9636B0092
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:41:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A6AE1C1E4D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:41:24 +0000 (UTC)
X-FDA: 84871826088.18.A96C872
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 01E2C1C0009
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:41:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="no/+Rcdr";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781282482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4sEGBFr682HVIkwOysoDKHHcczJpLA/9ZzssYkvyMU=;
	b=mBkIURpWioBkNpF3D5B/qmY4GPQyvYf3rYiykbDbR5xeC3JFTKV0qXRhnoioff5o2C20TU
	OVC8L39/5RtKoEuXzSb/UbuWXUBgytrCfRonhI2y4Gfg4hNjVtrimbMHi4Dwu6jKitSGqS
	tVFUX4y13+Yz9RfR4RzRgGK3FGShmJ4=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="no/+Rcdr";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781282482;
	b=3jkTJCOEtXNBmpKxfNmjV+jg6EsvZ7wKSsgvtxezmOiC3QzS05Odg2ErJJGMu5OwBTy3au
	fU3tQw9Yqp+2jrN5Wfi0dZBPoCrc0h3pc+RbiglLHJm8pfAmXHd0VU4sERsfyJdOnB4eOx
	QSVKubK2PZtjg6UfSLVV+1jT0KMt64A=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5177d1ff061so557801cf.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:41:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781282481; cv=none;
        d=google.com; s=arc-20240605;
        b=TsLj2hg7MgVip6lHLwpBvDyHqOSxB9LdZGkRIopiD20WHqm26Ncf2o5lEyFFurMCz3
         GOpEGTxjxmDa0zxjzQHooTYKhiwLO3DLb7fap807MAWu1sa7EQYGVSjEVAxQy1ckYoKD
         Wy+iben6UZj/JOA12jnpD5F35+nzDFoqChxlwF/27+aKk1HPbRaUbtvNu97U23e5bkob
         jvXf9a+GefxAfXSw7WMOiIiDbXN80g4o+KsOuGdkmDlrvzIuDZGFoQYS4j5Mf7QRWh+B
         qSqW3eJnv3Rc1rVAyyz0G0Cywy3w2z/RkFlA+X50KChN1whMKHD7XV27inA6PBSOEYoK
         oJ1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R4sEGBFr682HVIkwOysoDKHHcczJpLA/9ZzssYkvyMU=;
        fh=qI+7IPCvwO1pNWszR64kYC+c5LZblAPEXH/UH/QF29o=;
        b=JuUEOEZjN1pBvJaY7+bZDPHpFW/5Q0sOgXDdJ1mTTigclXKg6yfhkPNmCn0VOQKrNZ
         M0kjozq6MK+o/EjOmwVxjq+yv9gGrkNbI3a6CoQ6fE5N6oBzSM4v3iOAPX3xtPTGzMYM
         MzvMf0JkITN5pSwmfu404bzKeKm+7kwunEWJXq9QRROTCgdk1TK76RVPUOpIFspKkE9M
         fEOxQzLul8Nhk2rOPpAYUS+DRZCvHbVtOj5Xh4fHpNtaamptHc9sJN7oynPby9N1fUXH
         sX57Q9fMQ1HyjZiD6jeVfHkIxv18TH8vTlTPea9+3iU4Kp55aBmjx0kWMHLPZNwceyTE
         6tpA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781282481; x=1781887281; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R4sEGBFr682HVIkwOysoDKHHcczJpLA/9ZzssYkvyMU=;
        b=no/+RcdrJxg2e6j2oKvAI9SCNgGfbek+isO+WnpJYO+fYuJWnWsKIbuHiBG/cYXko+
         qivACFe0aTPl+XwQks7qxq9EYaZXZggDi5wQG7ZRcTYwMTuLvOMBGXg19kxqCbQ5IDoq
         81ge2zwj8k5Ncr1ZRdXupYZXtrN5CkXDzLS2phgfrdlc9iabv/wRs/nPrvVTMyPE0hgR
         aOfT+1f1UJuqrPgp9IcDROfn8DtPsZ9+VS5ekiDLTOvGJDDc248oGGGfb4HggYUf/cDV
         PHFvWGg03pC6iNpvEFXHgI5y0DFwsBi7GhofrOwhFmKfvXStIQHR3lpS6ItWMRk3TD3V
         pxdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781282481; x=1781887281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R4sEGBFr682HVIkwOysoDKHHcczJpLA/9ZzssYkvyMU=;
        b=scG4F9fdtYFDINk4eoUN19Mh1vyJOQEFJmRvfuI+5TfcAHIQVxbb6vBvQKmM2lBANl
         UaKZLMS/kdfdywtllvM4yfaWbjVtSaqj5OlKaanMUBkDAi4fP2ql8qA4acEymUCZiz6B
         0rz+IFbJKa7n2CpNfAWH4ZqTQV3rPuBK45VJ1fc0X2S9+352UY5OGNvMqBZxSFWLeR7Y
         nXubTFQyaJK3P8EXeK2MI6MynEc56+0RjbySmTuYww5BiKfdWe5wrsyHjyfyFTozbB1e
         d45fw9yZlzcGh8FunPO1Dk6kRqN4aWLyp6mh3WnN/kUehsdzyarQB49a+s3V56EWLxTI
         W3lA==
X-Forwarded-Encrypted: i=1; AFNElJ9+eZLZdqswwleftPAXXH0QZRxJ700fJlQFKPA8F9QdIBsvcnDeruQqopoM0KSjDuSUmFIV/eg2EA==@kvack.org
X-Gm-Message-State: AOJu0YzRcSOnE2sQnjy8Vz5szqPjazr8u8mDbbNoZeOFcNZ8wTk2nTrE
	ZCxtGnbIMjzPD44FyaVoqHR77TZb6z51eQ46c/FMNqXsAzziU80n2y6sKk6q450SBdjZGsP9usp
	OMQqk0w6k1ci7cFtdEKIhV6gJNwfRMRdMoepRs43e
X-Gm-Gg: Acq92OEjmJWvhBocWSHZTRB2Sf+BeLPdto6STQR1dBC8dMmkG5XaNlnVLBLIxEHkr7u
	QzIX/0PxFNn4raByrfPjZwdfSnT87sKsuXZzXYOOynnnKB8fv7Nv6gjjKKp1I1wHwh1sI7e1qvO
	RK5n2XKWuL9np1ElBuOEj9R18gF4BL9+nUFHrD1rHCooTVWfqMY9IUBc/mPmu5ZpcCcbbq2fxVl
	C00w506AlXZ/Uq2Z2D/SL46yEmwZs0lWBbESXM0HU9esun2mYHQv0ukS7F+Da6+Rq9sr39060IM
	OqSkrA==
X-Received: by 2002:a05:622a:5906:b0:50e:38f0:ccb2 with SMTP id
 d75a77b69052e-517fc521930mr8949631cf.15.1781282480443; Fri, 12 Jun 2026
 09:41:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
 <20260610230413.D68967BC@davehans-spike.ostc.intel.com> <aipphZ5iCnbXVNSR@google.com>
 <CAJuCfpHmem_g7mEoic7O56LVSLkbftgWYgzexPWy7VSwp7_SiA@mail.gmail.com>
 <131c6a49-9177-418b-a653-8f13942fb8d3@kernel.org> <876077cc-db6a-4517-9d81-cdfbb43e599e@intel.com>
In-Reply-To: <876077cc-db6a-4517-9d81-cdfbb43e599e@intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 12 Jun 2026 09:41:08 -0700
X-Gm-Features: AVVi8CcePaseOhbsxWf8YW1Kr17EUDVr9ZOtARek6g3IEepVDrdvgDvl_QlRRYk
Message-ID: <CAJuCfpFh60wULMkFc7hzxWNg+qmZ2R_HMw_QZe5CNcDRFuoN6A@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] binder: Make shrinker rely solely on per-VMA lock
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Carlos Llamas <cmllamas@google.com>, Christian Brauner <christian@brauner.io>, 
	David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Todd Kjos <tkjos@android.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: inx1ksg9w568yfgb9rpga56fupt3mssa
X-Rspamd-Queue-Id: 01E2C1C0009
X-HE-Tag: 1781282481-561712
X-HE-Meta: U2FsdGVkX1+sEu7gR+cgO02zhcRPj+26Bx6yIcgyVj1cd0gDHCiSttqT+4UgaXpcbWQEWx+FrJU1Cdy3GzcKsk2wb557/WhyFGlbmuLkUln8ZY3hPvTIr9/bkkNgeWnMgA9LROrtEVTtJgaBvKuxTA0/+Plap4ZPeIjz6LbnZjzixtkQVxheiRfgnQkGuqwP5OtLIPEKviZCG7h1Lo+G7f8TRcGdwEuLfuujCV4mj1iPFwoNZE8Jav7JVoGs4xTMu0ewF26bR3UksVcMRliSlMqE7DS5dDR7jRdzHtqOsjX1SBNsjGXMEmC4GzFg+WkE/7TWho8XHHc//3aRnDGm4Q9pIENYa2Iob8fTLjQHQHk0T0+h3QVJrl8hV61AgZTkVp5wUEsYIuMozyfu/Yy69fpJtomzKq0b1d8ETjrtz/khFLL1PHs3D60vzQNOpFW6LZlN5zD5euu82sD74J/6YU7vl5nw5imK9GWOHelhMeDSmu68bppHi15Q+ow9u16R27nCw5IMEkwW8x2cWdR3YTkqn6yHULXjBpKjmaX6E9kzBAKMv8wr2s/1Z9hSEamTTR5gwR8TQZx338kJkitkpL8Hm6s0/nyFcRmOelkZ3YT9mto+4rcRd/j8PtvY2uRdk1ZrMR2wzIgR40YoLdB5SCSJfQcoom7cqqDc0trMwwxGcyYSQCtOg42pZW6ON6wQB7gV8iI+Tx52W38jjYh/zfpoJEINApDNCxIB2RxwXOyT9nLWQpEH+Jm/IsYE1NdMxARNdcdqzAVb9LS3QxEodWEOx3t3sX4/qh5JsIXN2PsIyP08cg3GFcyExnX6N7yyltB3yjC5mEEM/WbVNXXp8fbpagIB3K+ulh+bFpCvdStYJ5ygeM60v5JC2HhSb6pMH+pNGMmeJioboCNEH4OTiksjmckk7ZR/kAAaIl6Mb0vLficyi2UjaiPr2kZCMa9OMlCetcd9hk35NAf5JVA
 2UJ30TQ4
 04c/JoQPpqt4L2mpIQ4CkzHStsjKmokgptmkKGguXB36msQ1U7fOin0PQS0tVythsBWqHDUwYsKlp2qqcSMA9smUQbS0785peAkEqka7lvyw85WZEpMfdifWCL7qj9C0sUHVS9unbj7RZk1ypW7v6uAJz5eGl61IV/Br8GaUyi7OWc4Mm/Su2GB19jvaf8d1db3a/i2L7anqn1HNUlxKBh6/njZNlNAE3xUB4W7xUk+GsJ2UOuHMS//ynxQAUupgZG3iu5d+LJxWa8So=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 9:05=E2=80=AFAM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 6/12/26 08:41, Vlastimil Babka (SUSE) wrote:
> >>> If the vma lookup fails because the mmap write lock is held, but the =
vma
> >>> actually exists (has not been unmapped), then this code might "succes=
sfully"
> >>> remove the page without invoking zap_vma_range(). This means that the
> >>> page does not actually get freed and will just hang around forever un=
til
> >>> the process owning the vma exits or Binder needs this page and maps a
> >>> new page on top of the page.
> >> Yeah, I think if lock_vma_under_rcu() returns NULL you just need to
> >> jump to err_mmap_read_lock_failed, like we currently do if
> >> mmap_read_trylock() fails.
> > I don't think that will be enough as well, as the current code AFAICS d=
oes
> > something meaninfgul when mmap_read_trylock() suceeds but vma_lookup re=
turns
> > NULL because there's no vma at that address. Now we would just assume t=
he
> > trylock failed even if the reason was that vma lookup found nothing for=
 the
> > address. The problem is that lock_vma_under_rcu() can't distinguish tho=
se
> > two outcomes, so we would need something that does?
>
> I spent way too much time staring at this yesterday.
>
> I think the key to distinguishing between:
>
>         vma=3D=3DNULL because there's no VMA
> and
>         vma=3D=3DNULL because of a trylock failure
>
> is binder_alloc_is_mapped(). It won't return false until vm_ops->close()
> finishes. vm_ops->close() shouldn't be able to happen while
> lock_vma_under_rcu() is held. So if you've got a non-NULL VMA, you've
> also got a stable is binder_alloc_is_mapped().

By "stable binder_alloc_is_mapped()" do you mean it would always be
true? Asking because in your patch you removed this condition:

-         if (vma && !binder_alloc_is_mapped(alloc))
-                  goto err_invalid_vma;

So, previously if we found the VMA but binder_alloc_is_mapped()=3D=3Dfalse
we would bail out and now we don't. Are you reasoning that this
combination is impossible?

>
> So, if you've got a vma!=3DNULL *and* binder_alloc_is_mapped()=3D=3Dtrue,=
 I
> think you can be pretty sure you've got the right VMA.
>
> If you have vma=3D=3DNULL and binder_alloc_is_mapped()=3D=3Dtrue, you can=
 be
> pretty sure that you hit some kind of transient lock_vma_under_rcu()
> failure.
>
> I came up with the attached patch. More eyeballs would be welcome.
> There's a _lot_ going on here.

