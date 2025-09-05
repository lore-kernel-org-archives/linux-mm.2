Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95080CA1015
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 08:33:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBE7B8E0006; Fri,  5 Sep 2025 04:33:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C962C8E0001; Fri,  5 Sep 2025 04:33:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD32B8E0006; Fri,  5 Sep 2025 04:33:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA2EE8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 04:33:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 619391A05D9
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 08:33:27 +0000 (UTC)
X-FDA: 83854532454.19.5AF922C
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id 85269180004
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 08:33:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WwUtGWy7;
	spf=pass (imf06.hostedemail.com: domain of glider@google.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757061205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NiGQFhCM+75MKVgSkB143RjF35qXTjKYNYENw01ZAOY=;
	b=FlGG+CzHqvc3X5rYobw+U9s/rzFGAk60GI+zzGOvtTDamF+0/35MOa7uzGf2EZOupHTf9t
	9aNF97RThaQA5p1wCF0I1X7b0D36w9iZCg878t8DINIpy+ZVnmY6zfHlE+sx3JK+bdaYbe
	ETOADzFRFB545jdCAe96fU7k8n5i68s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757061205; a=rsa-sha256;
	cv=none;
	b=NS7lhAnjM0JCSuKWNvf2XKceljofPiBONQzS0TFbmUpJb+TkO4LbC6fmmiCxWmnSU2Y7CD
	CsJ9oxZ2b37bEPL4PtbKIoTQJE6Dx6Z1W8ATSHyAygIZm2bZGs1rtZPMKaBftqmWNlI2kJ
	af4HtN/O+KUnWM08OY8TkvTS3Di+fSo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WwUtGWy7;
	spf=pass (imf06.hostedemail.com: domain of glider@google.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-726549f81a6so20067786d6.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 01:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757061204; x=1757666004; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NiGQFhCM+75MKVgSkB143RjF35qXTjKYNYENw01ZAOY=;
        b=WwUtGWy7Nd4CI/j52XGg+O7x/x1e3r+11PE8SnQWoZbRIpF1OnYA1nC1vtidL2ctzD
         Tnk1cOvnrIPy0yE7vrSasAemMNm5vPAZCoywobHVejxbZiYC4IzI1jNelGtOMF9XHNhL
         2tZyDj8dqaorb//5PjoTXeW/c/rqXmx9J2C3j9tme5mowsuoADZxXfjA8laXrl3S/NmN
         IWgtGt/7qti5SPoypV7VQz0AdkYZkYfU6yPtZxG0ScJHKrxk015S+/cYKaSSAqFjTHTX
         RjHLgt1ATDyAli9seuE0gHLqOJf+khJzUnAv3poJZZ5s/fwzviyxKnxDbfZ+KaAg+hYx
         uUpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757061204; x=1757666004;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NiGQFhCM+75MKVgSkB143RjF35qXTjKYNYENw01ZAOY=;
        b=XeYds75TPqTv4fUffT5S8pcGeGr33x6sAW3OGXj0hM0dxi7RiEZXgTCDLH8WL6RMgE
         W+BQQi5mvHxSEouYF1iIT06A8X7Ng1KyXuyVVlLgfMUPV3S9JZq/JraVQ3l6NzwzmZyR
         vzKapHxkzW8T4ScXgVUFK+FNKYTCalfzfVgw9Xza+N3OuocugIyzagSRJcm2z6XA/Mex
         Ui96UiUi3MhIXDGHZFaA9w/bmtAs8LIwH8y7ManA0h1UrEzYB2wY4I83/+M7Lrg2x5DP
         wff4cwBbCo65QwTLmC1Fgrx21dRdL1f2dVZ61X7a/VzpeeLoWDvP1WtBl+cBG4+BHqa/
         MUZw==
X-Forwarded-Encrypted: i=1; AJvYcCVAlqcWBzN/1ixjCYdMzbk7hwaUoGTKY651UQl8/I8jRBa9UURnRoRqAgGqrC9YbhmOkWhdfRtw+Q==@kvack.org
X-Gm-Message-State: AOJu0Yw0XA5tKH0DKsTZ0JH/gdXSuH7vFCQD9s3YbZcvy5wgYT1+h2Kc
	MJomyuETKorTx1GEjH8eaLeNV9jHuoYd4WZf6AZ2871CvSJw1wZeapYonFsiHj1h2EvGbW7JyB4
	VH2TXiWbZzqkusxOvNh+IDvjbVdyC+2bI3KB+U5qh
X-Gm-Gg: ASbGncvoUDI+YjqS9War3TQA5zs1k0vxsGqOyT10W4/HbiImL3Q3lEUSIU/nKLYM5K9
	vWrzvEUHs92EgP+l2kV+NXUoTZKFr5AJUTbXIpkzGIC2ymKY/bWqZQa4yCOhW9UkRshI7pMSPbP
	x7q6zQF3Yi25fGPZ4C057CIrRjoKCtq+mdkS3vkiOpTHFWKj8/d0v0N8a76PAY2PenO6lpT+N7o
	YsR0sAuldxOmlmkj75ZT3Jol945HkXoEL5uBvcM2VUS
X-Google-Smtp-Source: AGHT+IH/DBAwk6CJl0zPHvkvyybbJDJwRBFvtKF7fuH7ZxC/t8JRFTJCkN03HH9959f/gxZEw9kh5A4knxtTV8AylRs=
X-Received: by 2002:ad4:5c8d:0:b0:729:4be4:7fdb with SMTP id
 6a1803df08f44-7294be484d2mr55718806d6.52.1757061204289; Fri, 05 Sep 2025
 01:33:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <20250901164212.460229-2-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250901164212.460229-2-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 5 Sep 2025 10:32:46 +0200
X-Gm-Features: Ac12FXwF_nrqiRF1QRwe4SEL1LOgGhI7gT4sYUe3e0eDMXNCPS7Bt_KSLOk4LK4
Message-ID: <CAG_fn=UfKBSxgcNp5dB3DDoNAnCpDbYoV8HC4BhS7LbgQSpwQw@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 1/7] mm/kasan: implement kasan_poison_range
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, elver@google.com, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 85269180004
X-Stat-Signature: t55chbqudrkjuy8guhe3sdeicjjyqb4r
X-HE-Tag: 1757061205-101949
X-HE-Meta: U2FsdGVkX1/4rkD4yt775oR5AI53Pdc596KvjX4kFjP/lhP/qpl2r9W1LxFIQFYEiFJObze0mpCK5NnaADJyqE076FXS7L9NwuYvM2Og1P/VxLQSbzc/i13aOTlGQuNuT6sY4T+djMPXJy8v3t2oaQMAJtI/jhJm6p5mpjFQ7j9hfKz2TkFrF8qfRELljTjMuuXfXWb06pDXVlYComdTnlDp6n2FWspyi1tGD7qz2CjP5KE4AntKYQaJ6frAGDjhb5VcUvpSQLUkAApHaXjafd/QuxMMXAHGgzAwupWscLEf+KssYdRnnUI2pU8jLgXdkYQ0/pJzh8UH4Gxv0qkI+02SGJklJrDEoES96FdpuKfzJygZDO0lZjvCZzCEq/EmBZe6+fTaZJ9TfOWoihc/hrEzIh4CXwsRVX7FIVNa3R4v0DBfv9yn4Q2sdmfAwFxE4MxcLykH2HBNPkjVzJo2nXTMXkGXl2kSceKSdd/oJDzjrCV8jhCpPSM/BxeNhOBEg0Ga/O1cFgH8fM5SQr20brKIRcEhsiMnNvn05ueo7o9a8J7hqGCU8+z7VzJztCP/viKlS8t7LoGMrXCwHa6ii40/4u54hWENbSxuTOu+bQ0mVTQOObUIo8TnjYNsNSINHakwDvJVTZQVn44UtgLEmWcAbfYCwDjoinMG81ZfjqRZAtQ7jP5uFy75qP0d4IBzMDiGUOXXX4hLNO+NuiMHU9yFsxbZ0/NjpuZtKB8gt3pkYL/d/rhr8fwQZMjel3j/K/QqNQNE/ZrcgXvlUidl2KjUjllfCHJfjBC6vo0jfTHDIrRFAmPxUJWIqm43wBcnjdGAAvVQU3hlhJoVAz3nbWxzojYKjyq18onEtxsVwVTssMaPp1lZfYIS/LYrytUlG4dju70ErurOsvHASRlAgO355Z8UMdRynyEqs+JcpoL6XQtuQszEjb5ClkqcSnioaSHAaShN7Cn0gLVgWgP
 +dhQu7Sf
 dui8c/B8haAlLpDJWBPIO2XWqPFmOMZgYEyWUNHp/cfKRWUJA1dUpXCaVutwuE9cpwVtc7ISI4XTR7CJfWGNgUZiqh5cWalR7D7t1G9tFevQvVKtnwmRaZystv41Ll0NSqKvIGHWjpqbGSK7sborSeWl967fFOL+8i44gCxavLFlBR/hGXtec9AqP4RfHkhVNgXEXAyCo6fVFr0cKwOv9q/IjF51wy/7wlucdqRGPNqz1iOsZmfseOTe6fpgpcca+1tSE9/EB1CoS6++1wDGY8m2VflgjBGNEluTf0m0xad9v+CWcFgJWWwDqWu8Mb+CIzdOAn5nMWECLp+DYZ/tAh58/Od/XM6f6IidGVazq/kbBX6U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 6:43=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmail=
.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Introduce a new helper function, kasan_poison_range(), to encapsulate
> the logic for poisoning an arbitrary memory range of a given size, and
> expose it publically in <include/linux/kasan.h>.
>
> This is a preparatory change for the upcoming KFuzzTest patches, which
> requires the ability to poison the inter-region padding in its input
> buffers.
>
> No functional change to any other subsystem is intended by this commit.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
> ---
>  include/linux/kasan.h | 16 ++++++++++++++++
>  mm/kasan/shadow.c     | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+)
>
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index 890011071f2b..09baeb6c9f4d 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -102,6 +102,21 @@ static inline bool kasan_has_integrated_init(void)
>  }
>
>  #ifdef CONFIG_KASAN
> +
> +/**
> + * kasan_poison_range - poison the memory range [start, start + size)
> + *
> + * The exact behavior is subject to alignment with KASAN_GRANULE_SIZE, d=
efined
> + * in <mm/kasan/kasan.h>.
> + *
> + * - If @start is unaligned, the initial partial granule at the beginnin=
g
> + *     of the range is only poisoned if CONFIG_KASAN_GENERIC is enabled.

Nit: for consistency with other functions in this header, can we
change @start to @addr?

> + * - The poisoning of the range only extends up to the last full granule=
 before
> + *     the end of the range. Any remaining bytes in a final partial gran=
ule are
> + *     ignored.

Maybe we should require that the end of the range is aligned, as we do
for e.g. kasan_unpoison()?
Are there cases in which we want to call it for non-aligned addresses?

>
> +void kasan_poison_range(const void *start, size_t size)
> +{
> +       void *end =3D (char *)start + size;

There's only a single use of `end` below, so maybe drop this variable
altogether?

> +       uintptr_t start_addr =3D (uintptr_t)start;
> +       uintptr_t head_granule_start;
> +       uintptr_t poison_body_start;
> +       uintptr_t poison_body_end;
> +       size_t head_prefix_size;
> +       uintptr_t end_addr;
> +
> +       end_addr =3D ALIGN_DOWN((uintptr_t)end, KASAN_GRANULE_SIZE);

I suggest making it
       end_addr =3D ALIGN_DOWN((uintptr_t)start + size, KASAN_GRANULE_SIZE)=
;
instead.

