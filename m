Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80C2CC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73B566B0088; Tue, 14 Jul 2026 09:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EC336B008C; Tue, 14 Jul 2026 09:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DA0F6B0093; Tue, 14 Jul 2026 09:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 333326B0088
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:59:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C823E1C024B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:59:56 +0000 (UTC)
X-FDA: 84987540792.01.FA9D690
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf31.hostedemail.com (Postfix) with ESMTP id C3B622000A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:59:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jMM4zwu3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kndQOXuIwkMxJQYvqsWjS7uMWJmdmNgelmSctupOCeI=;
	b=jC02c0BIbMuV9B53WKyDr17NkwFOdV4N5+Qmxl0ks7xVSRTohAZGcy/hdWkKyO/1Gu7tTV
	4WutKrtdfRyykbP/geNmnpgFl5Iau4FoVmAuJwZ9sHL+LLPOrfy3mqUt7GBLnKRFgMBkOA
	NyF87jL+cW2ZDOuvzvTPczPXmKxg/Vg=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jMM4zwu3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784037594;
	b=GdfEVvTC13PvXu0ltIV4LC68PEc14bDUc66iLvLG+yvfCS/+oWpjVd02uJsfznya7yjLPE
	kVdMXjQ7hy/PS5190pYx+KitPxZARpg1Xryhop5agqC3/XCxUwErQvT11fDwt8TkTXSDE1
	/T0g8+RVZieppvvkcEpFJ3cmUQXtgFk=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47c2b362ee2so3825318f8f.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:59:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784037593; cv=none;
        d=google.com; s=arc-20260327;
        b=aWC+s9NtRC0ZffyLttPi2edGWgo+xL/LMBWNwTAJNU3nqIACxjKfklCFlkr0QukA2y
         9kO7N5g/g9cnqkD6Ej1iknxYFOQEfVgcS2uFtp6ie3J5LYZAYNqtQRW+B3czAPdW9FKO
         nVDNS1cQkHP1JM9qgQ8xMBsLRKCZDPyJsDNfYUO2FHwiMiQVtnIuPzK/OdTH0VYFL9IL
         QQOAFpU18qAUXLjQJ1QAXqs0M2IPwLxiqFFXkos5uqVdK0fLF7J4t2LxMA32BbWXlTTj
         vQ9IaJ6kmMfd+iN/E1dMK8on13JThbqVLld/FtHOoa/pTRH69e/E5bOoByrA0Vflw5iV
         iQ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kndQOXuIwkMxJQYvqsWjS7uMWJmdmNgelmSctupOCeI=;
        fh=5ZdDuSp0+xtGN93KM9A9MGo4Cg1sToRy5XLVfu7jOkE=;
        b=ru0rjnLGtDkLq7pQyyd0rzwIMUrak9+bT7msKncIwHvG1jh7Z2XXcI6UslRHEEBiAj
         hE/DWOycqSRARDs2zzM8emQltL0pgqGZFE6ufNUQTorOeVVK9TGUChWUdqVjzcM6BUKG
         SEYfSFE8H35E5SlIj43iC4hwIqefjP6veJGOmw2Ln4IwBJUgcv1cReb7oexQGTfCSwNd
         xmNy44jiNoYOck3WHPS/gUhyMWI2KHg57wBmTkmU3q1YvW0AKwjRzGYjCgsyknvCHYSP
         umjd9bWxuCiJAUnbD8N9EEVfZ1FaK9xmORdJbgCc1W28wu0FslvDFWlZWVYdgv/iNNfi
         Gmxw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784037593; x=1784642393; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kndQOXuIwkMxJQYvqsWjS7uMWJmdmNgelmSctupOCeI=;
        b=jMM4zwu3y/Eure/43r0hQYfoYwXLXzp0sE4hPUHvow0mOe6rmuMnxLNr7y2m4+eB4w
         9u6cPm76TfjQFjlzf2M8ecFvLa0eqOnIZYZeSzoWnjlKsZdlY7Fs2g114LtJ9VIAHZPB
         L/Zb9O8RHM7IsypTz/mKpx56OOAKDrnKBvhGyH0Jbs3mh72+VDVnmZhz7P8mjJaUTuCa
         4SPJckd48qguwOKx9JDNxR3B4eeJBIRMuLpb7rqXK0bNu5HYJWlc2EmM2/5ZYspJTmpF
         honjXNHlIkM9FCQa/v2iSNywimQcZVK+yrnr31/TeZPFtvvEHOEvlgHJa9Spt0kEkfe/
         P4Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784037593; x=1784642393;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kndQOXuIwkMxJQYvqsWjS7uMWJmdmNgelmSctupOCeI=;
        b=MgC4aE+9aae9KqYAyr7KvMFqGXpd8S7ZFYkw9SZ1ZolKwZckL8dGfXmucw5gjRcqjf
         UTIaCrinN+E8sppySnP3UjaA9H3dpoQLXztHeFWT53OQkqDku16vs8ijYiiKAxCJapX1
         jjb4R9T9UVbRHrYtLr2ZOVJV4LHM1WKojjHi5Ps97dZk3RiCUP9coWSOSisMptwpHC44
         G/+4MhrPVIktfpkJ9DhCwlHw6a+TMGGgAi3jpW1klukAR3qGj4+huhp5aXDxDqSY0Ft1
         XJNRuuwcZMY6C5fOt9AQI8mAxVnN1yr7NaeloeqDhHiwwyKKGJLlVzZ2hblCPVOQgA7J
         c/sw==
X-Forwarded-Encrypted: i=1; AHgh+Rpgpa4KyMKJvLjnE/BfQpnBA7/0umE65zEjqcmIRIHN2/N01JtZ8vBHtOa+3j/nzjrZDLDwQ2lGTQ==@kvack.org
X-Gm-Message-State: AOJu0Yxc4sVPeROet/Xvj7tnDSY0QJEGgXMwH58I4B5wT2RNbxm+SlaW
	CaMPNC0nkOZsELAPMSX9cG1Qt9iyFbTZ0CVX+kH7k+eGwT26Ud0Q9bMHCQShBPmNj5wb5tmYAh/
	VgYrjQbDQnhoUno/96vXwa5AqasTNI+SCisns
X-Gm-Gg: AfdE7ck/YPw+BATxE6qPW6LdmGENpEXUeIrnqhxSdmWmGGCzQngq7ztfJpfCRq0wqDH
	8D2BY2myCOTYKpM2qU7uVR1c5L/ElGWlqg83iuyBdyX5qigJxutYL0gH7upueZjS/TqAexEKnbN
	RgTfFZ3wxriSeaSniTXN5g16dT/pqZ7MhSicZaFTqtYsYMvzi0ed8NssWRGk0BmckKKYaoqZ3HZ
	/KwT1EqWqlkkFoMfdPH9p6/5AgAPNYjaMr0kN99MT3logxZXexJY+NWSZn3T2Evn4kOUI4LRZaK
	HlOoMK9SzQk6l9sfnLXbUvhm5RGfzg==
X-Received: by 2002:a05:6000:1786:b0:475:f0c2:75a6 with SMTP id
 ffacd0b85a97d-47f2dd08a4emr15890077f8f.55.1784037592990; Tue, 14 Jul 2026
 06:59:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260714081408.1596052-1-wangxuewen@kylinos.cn>
In-Reply-To: <20260714081408.1596052-1-wangxuewen@kylinos.cn>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 14 Jul 2026 15:59:30 +0200
X-Gm-Features: AUfX_myNwXVJIGmskwcJLSFUQfO2_1G8Xvir0uNKDGePNWbw2MHq7rVmKDxcWaI
Message-ID: <CA+fCnZcyZZAwhVpVe+PQfjNiS5XaZE8UGDocxnxYPxpX48+mxA@mail.gmail.com>
Subject: Re: [PATCH v1] mm/kasan: fix swapped read/write lock usage in stack ring
To: Xuewen Wang <wangxuewen@kylinos.cn>
Cc: ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com, 
	vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7zt5szmmncnjp8f57duic13pjjoshe3b
X-Rspamd-Queue-Id: C3B622000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784037594-450292
X-HE-Meta: U2FsdGVkX18wl1SrY3XKXBeL3gEM2EpgS3rLLR3Eli73lkY7CLAuhG6j1ywLf9qdkhZ1ZLNjJCPMCqgNIIDic11zRBZ2P9dLu5g1N7uXuW6dHwvNiTkIUXE+yHgW8JcJnAJWsIqpH91dwZkY5vXl5oBKF0rXakNwg9rc8KIOPW5rFIz70Sx6ADUUguZN0YT+Jm8YN+61Jga5I9qbdf77uAVAu1PvNnHpXY8G7ci0edlEdyXkhfq1L4XQD99gxL3RMHEFCDjjaQJbDE2QnuVtrcSLEVD5wJpieRwpAQD8rYqqwIlpdPthuRUTu5A59tC1hQPuf8A4WiU9E2/DQV1gtVd0P05NQpf3urwibFy0ADRlSaNeTCVJFXlOc8G+restBy+hyM/mLVnUiA36Amw5zspoBIeQ7hd708m9xxySEl3JrgBd6RnjRz4srEEQv48rFSFedOvcQSOqoO1FCHmLo3pGQeiIsIGyAmGy1KihuCqCS2vJ8bxNsV0PXaezDMlTn0GOJblfq1bNRABsaeIDV9FQ+Rc0L+5ephNi2URdNq7pGMH6Ui3+BwAkCh+wSbHMKY1y0sqr9CA4nxYKVReawb9MeXwUeJvTBqGeBoel9TOWe/ggMG2t0PK/T4OnbsLOKLtMv5UmeY6NVgbzY3hRXeojYx++RmW7a4tTGC3HjOlFDwmWMWwbgHhwophtna06HbYUyBAV+uI3NeUsF6PmNznXH/84+GPlbw9Y/vGj77cG36dWR/uHm/QEKjgAmGTo4FvA+O8nV9SNJUu6YVPRQoVpcxGXRGZFtnk+cQ8GDbsp76mYhFYaagwdKOb+Xyi2WHnZ0W/F0YumuPi/Xwif2vczldhhEK8P1+ze6cKuvnvybMwnzy3SPXNflacZGLY93hRNSttQ2KYXvWVKrIVstOwZmn5OFSkWbzHpDH9cRzzs3qM6Fk75s/6arFNDfgBiLv7N0V/ZmXnoC880Mna
 keAgaYbM
 O3xHaRTVLGOZ2MiAhtR/OGvW96plePmgY6bLUeY9DA3RpCBQ5EF59To00Mal92TGApr6p5kxKQTYQPWUZfFaVfZ4clg6dqTeji+saWrTa3xVRzeKQMiebNtVsIZMzUuFGjUtx3Sli4KZK4l66HzqeHCpC/U6HCYL+0xEIwMaInShYTHgpmT3Hvko2xLp5aTZENdMXHHOkK4NJqh7AythLHkKx4Ucv2niRmf1dVxPX0zr5ZNBZ+P/tu210/cIO4t36NBbz/htfP/LCXxJ4/LfNNIp8ZxZ6W/VvFq44NpRTMQ965RM52gaFPMmgYyc7vP1ML1xwf167wibrp4KTsyxgeCuDR7JHyyMHAYY0ux17s4//mgnNUFFbZwzsgZIEOxslYBMxnJEUJUvyctfdr3j194/CNpuo6VlASwh3qqSMbWIpFmIlXPvEZKniyE2dIxqTGKXc0BF4NrJJRW7zdkTAz2LABtOWex+r+zPm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 10:14=E2=80=AFAM Xuewen Wang <wangxuewen@kylinos.cn=
> wrote:
>
> The read-write lock semantics for stack_ring.lock are inverted:
>
> - save_stack_info() modifies stack ring entries but uses read_lock,
>   which does not protect against concurrent writers and does not
>   block readers from observing partial updates.
> - kasan_complete_mode_report_info() only reads the stack ring but
>   uses write_lock_irqsave(), which prevents concurrent readers from
>   walking the ring simultaneously.
>
> Swap the lock types to match their actual access patterns:
> - save_stack_info(): read_lock -> write_lock
> - kasan_complete_mode_report_info(): write_lock -> read_lock
>
> Fixes: 7bc0584e5d2a ("kasan: implement stack ring for tag-based modes")
> Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
> ---
>  mm/kasan/report_tags.c | 4 ++--
>  mm/kasan/tags.c        | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/kasan/report_tags.c b/mm/kasan/report_tags.c
> index d15f8f580e2c..62576b1470e1 100644
> --- a/mm/kasan/report_tags.c
> +++ b/mm/kasan/report_tags.c
> @@ -39,7 +39,7 @@ void kasan_complete_mode_report_info(struct kasan_repor=
t_info *info)
>                 return;
>         }
>
> -       write_lock_irqsave(&stack_ring.lock, flags);
> +       read_lock_irqsave(&stack_ring.lock, flags);
>
>         pos =3D atomic64_read(&stack_ring.pos);
>
> @@ -99,7 +99,7 @@ void kasan_complete_mode_report_info(struct kasan_repor=
t_info *info)
>                 }
>         }
>
> -       write_unlock_irqrestore(&stack_ring.lock, flags);
> +       read_unlock_irqrestore(&stack_ring.lock, flags);
>
>         /* Assign the common bug type if no entries were found. */
>         if (!info->bug_type)
> diff --git a/mm/kasan/tags.c b/mm/kasan/tags.c
> index d65d48b85f90..6aa09122f09e 100644
> --- a/mm/kasan/tags.c
> +++ b/mm/kasan/tags.c
> @@ -110,7 +110,7 @@ static void save_stack_info(struct kmem_cache *cache,=
 void *object,
>          * Prevent save_stack_info() from modifying stack ring
>          * when kasan_complete_mode_report_info() is walking it.
>          */
> -       read_lock_irqsave(&stack_ring.lock, flags);
> +       write_lock_irqsave(&stack_ring.lock, flags);
>
>  next:
>         pos =3D atomic64_fetch_add(1, &stack_ring.pos);
> @@ -131,7 +131,7 @@ static void save_stack_info(struct kmem_cache *cache,=
 void *object,
>
>         entry->ptr =3D object;
>
> -       read_unlock_irqrestore(&stack_ring.lock, flags);
> +       write_unlock_irqrestore(&stack_ring.lock, flags);
>
>         if (old_stack)
>                 stack_depot_put(old_stack);
> --
> 2.25.1
>

This is no good.

RW lock here is used to prevent kasan_complete_mode_report_info() from
running concurrently with save_stack_info(). But multiple
save_stack_info() must be allowed to execute concurrently without
contending for a lock. Concurrent writes coming from multiple
save_stack_info() executing at the same time are handled via
atomic64_fetch_add/try_cmpxchg() slot reservation.

