Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58554C2A07E
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 09:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5574B6B0113; Mon,  5 Jan 2026 04:56:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B24E6B0116; Mon,  5 Jan 2026 04:56:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5336B0117; Mon,  5 Jan 2026 04:56:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 261116B0113
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 04:56:25 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFC72C558E
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:56:24 +0000 (UTC)
X-FDA: 84297455088.13.A2AC311
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0B5C8A0003
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:56:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3A9Yc+Cr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of davidgow@google.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=davidgow@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767606983; a=rsa-sha256;
	cv=none;
	b=gEDcumAWMjSsXzf8s5d0bF6VL2uQ3JuCc+v1ctbbYragRonMN0nENEx9ah23BylH+XGYFh
	002+FOLSB8qtLvFX04ozCXHLRhchc3/swzyHVKiJoLyitiu6jgRmystvOk8Mjd7cAf4tCV
	6JgeGYAvvPfwAA7Mk5WxCPrDRmCQWXs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3A9Yc+Cr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of davidgow@google.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=davidgow@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767606983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9sAFWDOjvNjOHWWvYbDu/Q41H06R6rApJd/rfCzHjV0=;
	b=k3Nv69vFp2NzKKmxO6GupSRzjW/GHN12EWeP/wk1tHIxy7Y8MlixITDz27Jbnoyn/KGDrX
	wS/dIb8dANeG27AYJuHUYfzVGUfMvKk1FD8r+bB4QHrmq6E0ujOO1obeBS56NOR9jb96uT
	p5X+fdLbFLFynSFgbH4Xt0cc1ZIqonI=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-432755545fcso4391811f8f.1
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 01:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767606982; x=1768211782; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9sAFWDOjvNjOHWWvYbDu/Q41H06R6rApJd/rfCzHjV0=;
        b=3A9Yc+Cr5QdABQurVs9TIMyId5cphAWVzHwyLWXj7LCBkDYkoxRZSy+BxtbtR4Q4lP
         EURMWjykDbae23McseuukM8tR/lqtqRUA5c2GJ7lSALqqv6mCSn5F7W0fDa96/E7JXDZ
         H4Th5Efyw6dP6A/sz/NYwVXRHDo11bN/v14n9UVoNy26vWE0CzNgwayBPH39IJotHr0/
         tgnRWHlmJg3O8+aBjJgW7HsZf+7q2Ps4l4/MsODE/EUw5Y/dFULPz0zJTMfyRp/StAaA
         OrnpWOm8u153vnJQEp0kCSVr/Nd5qk5mixE7fTIEP2nhqRufjJZ8wEFqw4FfsBMolPDL
         2a/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767606982; x=1768211782;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9sAFWDOjvNjOHWWvYbDu/Q41H06R6rApJd/rfCzHjV0=;
        b=swPrYIpkhLWkwPN/TroMa5X6611LkHOse+Rl9f+oELBridm0KWZ4XvCaHDWfifbKaH
         m1Qn6ZkPTUpR1qjatV+xODMwVKhPrjuWSmt5DD60XbnQaEdJInnYL3uta0B3zIEyAIrn
         ZHSrl8k9k7OeAxKKtuG4u91gOQhHfiIDTpOQpvm6X1KJoTlP1BpOKvRmtfnk31m9D0bC
         XbtYVVXE2wPsu1D2qNo177nVgpV4C6r58HdXeaAhDJJ0VLajdBjev3Yhb+tCRJw7tjZy
         CcUH9mxaf6xG59iOPBLuVCTXSFVakFBImFts8baEdeZv0jv4afrrDKElNvjnD6t4gBcW
         m9dg==
X-Forwarded-Encrypted: i=1; AJvYcCUI6zeXs84BVjAhdc/A1XswrmUHHpXtqotgvUOns1NUS9FTq4DeUgGIVAO0gs5Bc2DOkfS1UnVDuQ==@kvack.org
X-Gm-Message-State: AOJu0YyhWXmPSD2Ml8y9yjavxLUhJ8cw6lcrFKVawhPODQX/KPQGm2JR
	GpCTeo2B0rlaSCQbHBRsTGGC4XuJtAkVdsHmBC9y+fegyI6E7cheias2u6C/ACO6M0qjVtQ8WEn
	/da5UG/5nA+6EivL3Ndju4FouhENcs9HAf+RwkIbe
X-Gm-Gg: AY/fxX5VSpvDi0eeUIRGIsesNc1B1gU6YfC6fSIDyf23H9mTHByuxMDMDnVkatfAdBG
	Y1KjWpc9uKmea0M+HHiLhZBwjXipr5HgL6963qMixKgGcvrt4eUfYHN9gG4wQS2H9IQ/p2293KE
	dBlVb22iFMAEVOxEctH087lhRb0ELglLFiFYcRsjjJGZF12fSBAe3tzr+T2r+9hIC+YCZqq+ypQ
	QRfLQ/RvgbOsBOLicVdAxRsVMCntBE+04XuNr2/iqGDmTjFj4nNy0r1xgUSp6pAJ7iNqg==
X-Google-Smtp-Source: AGHT+IETP1/O0u6R8P0hJGnBjXEjiplyCGQS9hjuMTh/gbkgMQlB7HrQ/PUiVu/ttzpwaj5I20HoxJBvpIG4+MOunxc=
X-Received: by 2002:a05:6000:144a:b0:432:8f36:d69 with SMTP id
 ffacd0b85a97d-4328f360df7mr30751973f8f.33.1767606981272; Mon, 05 Jan 2026
 01:56:21 -0800 (PST)
MIME-Version: 1.0
References: <20251223-b4-kunit-user-alloc-v1-0-fb910ae0e50c@google.com> <20251223-b4-kunit-user-alloc-v1-2-fb910ae0e50c@google.com>
In-Reply-To: <20251223-b4-kunit-user-alloc-v1-2-fb910ae0e50c@google.com>
From: David Gow <davidgow@google.com>
Date: Mon, 5 Jan 2026 17:56:08 +0800
X-Gm-Features: AQt7F2p6A3aOQH7r3FcVWFP8NFSKL2NfwhVBOpWA4or5Xgs8FwgJSgAY7np9lAM
Message-ID: <CABVgOSmMXsbhJsBBy9p=WK1RdB+gcgyuma_FTSfQOGWJ0eqU8A@mail.gmail.com>
Subject: Re: [PATCH 2/3] kthread: Add kthread_take_mm()
To: Brendan Jackman <jackmanb@google.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>, Rae Moar <raemoar63@gmail.com>, 
	Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000043fa600647a112f3"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0B5C8A0003
X-Stat-Signature: e9ngxym9s6hme9i5n4qrkw31rt6jwjar
X-Rspam-User: 
X-HE-Tag: 1767606982-992883
X-HE-Meta: U2FsdGVkX19jBL594A1HyVN3o3WeHCQ22FXE2WqPbZzxkDz/PFFoC713dqqfWfGQwOpCwftrK8OOOeENE5CLOEF2yu6kesiZC+N5LE3DjbPXAuLSHa48RXDj1MAFbqzxs4Vfj9LUtqsuLFJmyPHHrGVgqWKZhpQlzy7B/KmEmHUq0PIFBWE3oBPdns8KD5zH8YqGQDbPKC0/zy7vNH4epth809RyK247XGKC9YWINVnooBV031jeO61XmR9IqA0CTfev0jp+lWHUz90JX1iAQUc93yTj1MFDx8ird27HfcJ5FMw/cYF3PMKSZzcBL0avmHRz2EvNXzmuv5eYsM3TcK2P3jqzhjmvhbxt/FXXOOsI88t9N+fXIM23RTcMB2EUEhnI6qt2N40+0h8LCjmjkCNJfeWXRnQOpdzjzzRFwv4aVJjxx//unuMVfJ3/d+DJtgo/3oOpq1qHhvqxdEIRqdGDlhvZhnAOOteHY+L5CXrDUfGNysjE/cFG1W968TlsKneL4CCqiKQ7TbAxSdMctok63bPv7A53RrOa3Z3BR77fzOfjbkBXqucAzj3ZI/Lb010v3IqEueq7BmbiLFGOdDkNSb/6bAJSg7XsH2G4ZLPiUjEXVAMDGz3O5MBquJpCcy5xVmpiBfLlXEHmAI9A4suhVtSAIya/dRLV93SAx1qtYyNx9disMIVsurJoeXpwDoE/f/2JcRCBDNwHbEFi+/yyPxkc7Xok3RSImnXOPB9eOoQHNy+iwIfiMeRiwsSP5KaVEStcbSrIP8lXImwAzDbpIWl83SsZxW9hKIm5TSUjc3EqyG9mJHIofSMTrrXp0l06n5BR/52eH3XclZr/yusjTouesIte+hNPgEszpTdagt2sl4L4Tces68B83A4PAI5ERSlsxkjZdtXx36GeluVKkiNsWfydnuzBTX397HHJhU31UsSGlkQ2ml0W0sP9MTbX3HViKV4JmmPLl7c
 +26mDAWt
 v1SwHYuL1zoyGEBwlWf2hIcVopm6Vb0nPnQNNebGGiCT32yjXLKab6lXU7F8VUO8ZjgVix5h+FXaLzD1fXPCY4aIgFYL6MWDPkjUkTct+6xFFxbkhTbMZepcJ6Yj6zumx+EC+HDfBc0S4wmmESr4OV1Lgj8DkN8b/nsfhGyi9FwS+hEon8l9/uL48NiEQve0+9MFJU7ttWBKPf/4I/xEEf7D+1niOH/TfugEROZ3penkH8wc18DbVw0JCJgDudfZCVgXPVevv79l3LPkvChS9P0yX9lDeBoaNnx64RbDg1rIEu2e4tf9f4IY9o9KClIzL3Ytav7w/HyV8Oy4MI/zFOlEu9fL6M7fbQR8X6GmU26ov6yYfplUj7xMCCLnb0MfiTzcAqIjbquFvBV9Bt+AcOhlYAwalyTtQn/P790yepnMwAY3I2Xt/Ta3v4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000043fa600647a112f3
Content-Type: text/plain; charset="UTF-8"

On Wed, 24 Dec 2025 at 00:18, Brendan Jackman <jackmanb@google.com> wrote:
>
> lib/kunit/user_alloc.c currently uses kthread_use_mm() without a
> corresponding kthread_unuse_mm(). This is a bug, but fixing it in KUnit
> makes writing tests that use mms more difficult, because of KUnit's
> resource/try-catch model.
>
> Therefore, introduce a new operation that does what kunit_attach_mm()
> wants, namely an unbalanced call with cleanup deferred to
> kthread_exit().
>
> This is actually just the same as kthread_use_mm() but without taking a
> reference on the mm_struct.
>
> While adding this, clarify the reference returned by mm_alloc(), since
> that is what kthread_take_mm() is gonna be paired with, in practice.
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---

This makes some sense to me from the KUnit side, though it'd probably
be nicer to have a way of actually triggering kunit_unuse_mm() at the
right spot. I'm not sure if we'll want to have tests spawn additional
threads sharing the same mm in the future, too, which this shouldn't
make impossible, particularly if we have a requirement that those
threads don't outlast the original test thread.

Otherwise, Is there a reason we can't mmdrop() from another kthread
instead of trying to kthread_unuse_mm()? I wouldn't be surprised (it
doesn't _seem_ right), but seems to work here.

Regardless, I've tested this on a bunch of different KUnit configs
(UML, x86, arm, powerpc, m68k, etc) and nothing has gone wrong. But
I'm definitely not an mm expert, so someone who is probably should
look over this as well.

Reviewed-by: David Gow <davidgow@google.com> # For KUnit

Cheers,
-- David



>  include/linux/kthread.h |  1 +
>  kernel/fork.c           |  3 ++-
>  kernel/kthread.c        | 36 +++++++++++++++++++++++++++---------
>  3 files changed, 30 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/kthread.h b/include/linux/kthread.h
> index 8d27403888ce9..2e6244d8ff1a3 100644
> --- a/include/linux/kthread.h
> +++ b/include/linux/kthread.h
> @@ -259,6 +259,7 @@ bool kthread_cancel_delayed_work_sync(struct kthread_delayed_work *work);
>
>  void kthread_destroy_worker(struct kthread_worker *worker);
>
> +void kthread_take_mm(struct mm_struct *mm);
>  void kthread_use_mm(struct mm_struct *mm);
>  void kthread_unuse_mm(struct mm_struct *mm);
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b1f3915d5f8ec..761e6232ea75a 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1147,7 +1147,8 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
>  }
>
>  /*
> - * Allocate and initialize an mm_struct.
> + * Allocate and initialize an mm_struct. The caller gets a single reference to
> + * the mm's address space, which should be released with a call to mmput().
>   */
>  struct mm_struct *mm_alloc(void)
>  {
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 99a3808d086f0..c660c04a1b627 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -1589,10 +1589,16 @@ void kthread_destroy_worker(struct kthread_worker *worker)
>  EXPORT_SYMBOL(kthread_destroy_worker);
>
>  /**
> - * kthread_use_mm - make the calling kthread operate on an address space
> + * kthread_take_mm - make the calling kthread own an address space.
> + *
> + * Unlike kthread_use_mm(), this doesn't have a cleanup, instead that happens
> + * automatically on kthread exit. Correspondingly, it does not take any
> + * references, by calling this function you donate your reference to the address
> + * space (from mmget()/mm_users).
> + *
>   * @mm: address space to operate on
>   */
> -void kthread_use_mm(struct mm_struct *mm)
> +void kthread_take_mm(struct mm_struct *mm)
>  {
>         struct mm_struct *active_mm;
>         struct task_struct *tsk = current;
> @@ -1600,13 +1606,6 @@ void kthread_use_mm(struct mm_struct *mm)
>         WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
>         WARN_ON_ONCE(tsk->mm);
>
> -       /*
> -        * It is possible for mm to be the same as tsk->active_mm, but
> -        * we must still mmgrab(mm) and mmdrop_lazy_tlb(active_mm),
> -        * because these references are not equivalent.
> -        */
> -       mmgrab(mm);
> -
>         task_lock(tsk);
>         /* Hold off tlb flush IPIs while switching mm's */
>         local_irq_disable();
> @@ -1632,6 +1631,25 @@ void kthread_use_mm(struct mm_struct *mm)
>          */
>         mmdrop_lazy_tlb(active_mm);
>  }
> +EXPORT_SYMBOL_GPL(kthread_take_mm);
> +
> +/**
> + * kthread_use_mm - make the calling kthread operate on an address space.
> + *
> + * This must be paired with a call to kthread_unuse_mm().
> + *
> + * @mm: address space to operate on
> + */
> +void kthread_use_mm(struct mm_struct *mm)
> +{
> +       /*
> +        * It is possible for mm to be the same as tsk->active_mm, but we must
> +        * still mmgrab(mm) and mmdrop_lazy_tlb(active_mm) (in
> +        * kthread_take_mm()), because these references are not equivalent.
> +        */
> +       mmgrab(mm);
> +       kthread_take_mm(mm);
> +}
>  EXPORT_SYMBOL_GPL(kthread_use_mm);
>
>  /**
>
> --
> 2.51.2
>

--00000000000043fa600647a112f3
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIUnQYJKoZIhvcNAQcCoIIUjjCCFIoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ghIEMIIGkTCCBHmgAwIBAgIQfofDAVIq0iZG5Ok+mZCT2TANBgkqhkiG9w0BAQwFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSNjETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMzA0MTkwMzUzNDdaFw0zMjA0MTkwMDAwMDBaMFQxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFz
IFI2IFNNSU1FIENBIDIwMjMwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDYydcdmKyg
4IBqVjT4XMf6SR2Ix+1ChW2efX6LpapgGIl63csmTdJQw8EcbwU9C691spkltzTASK2Ayi4aeosB
mk63SPrdVjJNNTkSbTowej3xVVGnYwAjZ6/qcrIgRUNtd/mbtG7j9W80JoP6o2Szu6/mdjb/yxRM
KaCDlloE9vID2jSNB5qOGkKKvN0x6I5e/B1Y6tidYDHemkW4Qv9mfE3xtDAoe5ygUvKA4KHQTOIy
VQEFpd/ZAu1yvrEeA/egkcmdJs6o47sxfo9p/fGNsLm/TOOZg5aj5RHJbZlc0zQ3yZt1wh+NEe3x
ewU5ZoFnETCjjTKz16eJ5RE21EmnCtLb3kU1s+t/L0RUU3XUAzMeBVYBEsEmNnbo1UiiuwUZBWiJ
vMBxd9LeIodDzz3ULIN5Q84oYBOeWGI2ILvplRe9Fx/WBjHhl9rJgAXs2h9dAMVeEYIYkvW+9mpt
BIU9cXUiO0bky1lumSRRg11fOgRzIJQsphStaOq5OPTb3pBiNpwWvYpvv5kCG2X58GfdR8SWA+fm
OLXHcb5lRljrS4rT9MROG/QkZgNtoFLBo/r7qANrtlyAwPx5zPsQSwG9r8SFdgMTHnA2eWCZPOmN
1Tt4xU4v9mQIHNqQBuNJLjlxvalUOdTRgw21OJAFt6Ncx5j/20Qw9FECnP+B3EPVmQIDAQABo4IB
ZTCCAWEwDgYDVR0PAQH/BAQDAgGGMDMGA1UdJQQsMCoGCCsGAQUFBwMCBggrBgEFBQcDBAYJKwYB
BAGCNxUGBgkrBgEEAYI3FQUwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUM7q+o9Q5TSoZ
18hmkmiB/cHGycYwHwYDVR0jBBgwFoAUrmwFo5MT4qLn4tcc1sfwf8hnU6AwewYIKwYBBQUHAQEE
bzBtMC4GCCsGAQUFBzABhiJodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vcm9vdHI2MDsGCCsG
AQUFBzAChi9odHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9yb290LXI2LmNydDA2
BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL3Jvb3QtcjYuY3JsMBEG
A1UdIAQKMAgwBgYEVR0gADANBgkqhkiG9w0BAQwFAAOCAgEAVc4mpSLg9A6QpSq1JNO6tURZ4rBI
MkwhqdLrEsKs8z40RyxMURo+B2ZljZmFLcEVxyNt7zwpZ2IDfk4URESmfDTiy95jf856Hcwzdxfy
jdwx0k7n4/0WK9ElybN4J95sgeGRcqd4pji6171bREVt0UlHrIRkftIMFK1bzU0dgpgLMu+ykJSE
0Bog41D9T6Swl2RTuKYYO4UAl9nSjWN6CVP8rZQotJv8Kl2llpe83n6ULzNfe2QT67IB5sJdsrNk
jIxSwaWjOUNddWvCk/b5qsVUROOuctPyYnAFTU5KY5qhyuiFTvvVlOMArFkStNlVKIufop5EQh6p
jqDGT6rp4ANDoEWbHKd4mwrMtvrh51/8UzaJrLzj3GjdkJ/sPWkDbn+AIt6lrO8hbYSD8L7RQDqK
C28FheVr4ynpkrWkT7Rl6npWhyumaCbjR+8bo9gs7rto9SPDhWhgPSR9R1//WF3mdHt8SKERhvtd
NFkE3zf36V9Vnu0EO1ay2n5imrOfLkOVF3vtAjleJnesM/R7v5tMS0tWoIr39KaQNURwI//WVuR+
zjqIQVx5s7Ta1GgEL56z0C5GJoNE1LvGXnQDyvDO6QeJVThFNgwkossyvmMAaPOJYnYCrYXiXXle
A6TpL63Gu8foNftUO0T83JbV/e6J8iCOnGZwZDrubOtYn1QwggWDMIIDa6ADAgECAg5F5rsDgzPD
hWVI5v9FUTANBgkqhkiG9w0BAQwFADBMMSAwHgYDVQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBS
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
Dxz3AgMBAAGjggHgMIIB3DAeBgNVHREEFzAVgRNkYXZpZGdvd0Bnb29nbGUuY29tMA4GA1UdDwEB
/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIwHQYDVR0OBBYEFHZtY3XkWtC2
e2Idfk+0JyK7BLzzMFgGA1UdIARRME8wCQYHZ4EMAQUBAjBCBgorBgEEAaAyCgMDMDQwMgYIKwYB
BQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAwGA1UdEwEB/wQC
MAAwgZoGCCsGAQUFBwEBBIGNMIGKMD4GCCsGAQUFBzABhjJodHRwOi8vb2NzcC5nbG9iYWxzaWdu
LmNvbS9jYS9nc2F0bGFzcjZzbWltZWNhMjAyMzBIBggrBgEFBQcwAoY8aHR0cDovL3NlY3VyZS5n
bG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NhdGxhc3I2c21pbWVjYTIwMjMuY3J0MB8GA1UdIwQYMBaA
FDO6vqPUOU0qGdfIZpJogf3BxsnGMEYGA1UdHwQ/MD0wO6A5oDeGNWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vY2EvZ3NhdGxhc3I2c21pbWVjYTIwMjMuY3JsMA0GCSqGSIb3DQEBCwUAA4ICAQBo
hqjbVaHxZoT6HHUuwQcTlbgXpuVi59bQPrSwb/6Pn1t3h3SLeuUCvOYpoQjxlWy/FexsPW+nWS0I
PUmWpt6sxbIRTKPfb7cPk32XezfnA0jexucybiXzkZKTrbI7zoMOzDIWpTKYZAonB9Zzi7Dso4An
ZOtz/E3yhdR/q1MK30d5fiCS0vorEd0Oy8Jzcc7TJ2HGMzEEXiFFvVrJYJHvfYOeXE4ywAG6YWO0
x78+bXeB9vkeWHhOYKyYXuAXrnHASddEICg1QlJCHDAISMC1Wn/tjqTMTt3sDAe+dhi9V1FEGTbG
g9PxPVP4huJEMIBu/MWNMzHfiW4E7eCHVPrmtX7CFDlMik7qsgQBbO5h6EcxBamhIflfMgoISsRJ
Vyll2E5BNVwkNstMgU3WMg5yIaQcuGFgFnMTrQcaLEEFPV3cCP9pgXovYDirnB7FKNdCZNHfeBY1
HEXJ2jIPDP6nWSbYoRry0TvPgxh5ZeM5+sc1L7kY75C8U4FV3t4qdC+p7rgqfAggdvDPa5BJbTRg
KAzwyf3z7XUrYp38pXybmDnsEcRNBIOEqBXoiBxZXaKQqaY921nWAroMM/6I6CVpTnu6JEeQkoi4
IgGIEaTFPcgAjvpDQ8waLJL84EP6rbLW6dop+97BXbeO9L/fFf40kBhve6IggpJSeU9RdCQ5czGC
Al0wggJZAgEBMGgwVDELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExKjAo
BgNVBAMTIUdsb2JhbFNpZ24gQXRsYXMgUjYgU01JTUUgQ0EgMjAyMwIQAYQLf/BIzLow9kWqD8My
PzANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQggiScsvRriAlTYeRBZZrxcT/n5dta
x94uXMjvUSJtn8kwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjYw
MTA1MDk1NjIyWjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJ
YIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcN
AQEBBQAEggEAYjSa6/owBcNpOQa+qYBG3RkRAs4qIIdK8QlaIAcaRZJ5YRFpPVOWUNtbhaL/nhAE
EYJ/MuMwolf5I51gj2sUA7inlHe7oVLeHXmi9czUohAbpWiR18XEOKj+PtND3DO6YzzJpTFRHrgS
4E9QnE/pd4qVgjcBr1i7SfKZiuFH4FBZ9eScf+0E5tOV6lIHR9fLD5MKUQGS47MK414SmgDsRg43
bigKQKNwfBf9IUnBMAY/v6CQ/xGuUFUzMvcVQnepUb0JeIkS0ceQJe4HGu+/nrIqjVBXWx99vtrG
a8sqw9Kl1CCuK0vCNWjs2v27D7eaLVKhmdujvIDA4V/uUtPynw==
--00000000000043fa600647a112f3--

