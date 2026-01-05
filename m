Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB3F9C2A07B
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 09:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 263656B010F; Mon,  5 Jan 2026 04:56:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F99A6B0113; Mon,  5 Jan 2026 04:56:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FBEE6B0115; Mon,  5 Jan 2026 04:56:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F09D36B010F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 04:56:23 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81CE31A0EE5
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:56:23 +0000 (UTC)
X-FDA: 84297455046.19.FF89140
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9E871160005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:56:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3rQ06Dm+;
	spf=pass (imf08.hostedemail.com: domain of davidgow@google.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=davidgow@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767606981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=978ZWWi6sai890Fl++7NaEkwfYAeYbiznAx+5B69J/8=;
	b=K8aHh27tCzbaTaZ8JsJmQ2zBoXGeQ4hKfh/dCddK/XMFLncDsMQojTltYZXkpzOXSqQJYb
	d9cJ9Yk1TiKJKAKQcGlZB7uk9KyPpfTNtdFgnKFT0mx5VhThgJI+PQn3HnL5T4HUWfW82P
	fW8MKdVGUurNxjBdL8oCgB8e7mcJIF8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3rQ06Dm+;
	spf=pass (imf08.hostedemail.com: domain of davidgow@google.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=davidgow@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767606981; a=rsa-sha256;
	cv=none;
	b=HV9yjMVimGzyRO6vXrgOr/q/PAqAd9A+q0LP/J+AA6VSXHs3qxkwLx+D8Tmwtbm15xA6rI
	BUzok0+2M0EngdlsCrqXrp6I7ZptJDQp5Ymo+SZY5qGwAxbMCRpCMR16pvmcBjcofg0CAb
	/gUCM0IVX7yh2Mtfd/giJFH7tTjl4SY=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42fb2314eb0so11033020f8f.2
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 01:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767606980; x=1768211780; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=978ZWWi6sai890Fl++7NaEkwfYAeYbiznAx+5B69J/8=;
        b=3rQ06Dm+JSiwksZlrA9XWT6tIzjA+RWwXPUQArjqYXwhmgPcMOm1jGDEcZdygnPURm
         8dvLqPbFiKiAlffT33SJWLpXDUmCpfrr/FM3DrRq9XpqhEVTrLILV5s/Tg4Q1pDcpkSt
         uRsI/0qAL27Ahmkru9nWJNtkHMks08O98bv4qPtNqaDi9jrWjMe+Fll4GQTGf+QBKMEX
         vVMm9IrBuMwmE/q71oGVVoJfDY86Ww+7Ok0q4TmfBFq/Ki3L0smBXFAFkH/s+CdMf+d0
         t+hH4vTxbOz+9QnHiVXtanmlEFzRjjugBrPpbXDNrtg1uX/VXk/L5Wv54raE6dlqadrt
         hg/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767606980; x=1768211780;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=978ZWWi6sai890Fl++7NaEkwfYAeYbiznAx+5B69J/8=;
        b=aSsxQ36u5OfEO8fvFJOJ8UKtbr9kEeisV6C0MxluK0mcpSsW+R6ukCtxYRft1iuZi6
         Fk98DAjlBnLy0+wBWi+ov2RqwoypgBYUhhKT4mIDB6puYiNlHk6OZJULi9FZBXVv9JHf
         hrqEchNIGQ/1rCAdAOxbOaR+Hb0JLB80RI/6aIUCbPH+2+4Oty+vIhZcgVhWkCPFaZW6
         m+NwP7wdezeMXbCtMuNFYzv2L2t1FDROQRw1o2SRMhL3I8pvn4FdMz+SjwygDkX8e9tR
         OK3b10LwOjMS6UJ0Ehoiv39SH5oDb7xM5Gj29EkduJe/J8l6uopYH1mRnzqUoUUAg+zl
         K1vA==
X-Forwarded-Encrypted: i=1; AJvYcCVGBRENXhNN3fpDOQlQCZ0X7Yyh3ZiY8oQk/qEb/kSbpkTd9Xrkawti0P4FUWI1MmG/coyai15B7A==@kvack.org
X-Gm-Message-State: AOJu0YwAAVpg/pWDlOWq8Ev2KQ0yQ0qTW5ufACoGAvvvN7wXJNO96lhT
	suSisWRB7njQB32NoFwyXi6AnhAm4aYKHU4rnUircAdJvE/0rjfKPd25ZzAUV/ZUFI6hWqBXpbb
	IBKBdMeQXHUwYaNbqTePV5tNGoq7/C2/ArLa9wo9/
X-Gm-Gg: AY/fxX7VUrXospRHVW5czr6D6+zGI2dd8Dn4yOJwrKnxpwo7qZ4dStKAm5d5c2gqldP
	bR7OhYb4FizZXbT+rXpOf846ZqVV73D05Pr75mLXqh6ogRPACCM7DmSAg6SKeIw7Lidg9vw1zDa
	gSwShGarVTuUWZFKIj97taxp/u3zE/fIOJ7k6rYNjQiMt9mHqZNCo0F5cjWedHmZIvWOghEuCv9
	JL68Gw0XLGzSS6U0qwlflJhA/0kLusmLMz+nxef5eBbrs6SRr2SClQ06Pw3me4MVbqC1Q==
X-Google-Smtp-Source: AGHT+IFhHGqV+111+Jsl/C7heOpaY1/FMuHju4NwSGTautSM3LQjZq6+CfqKPbYyrgfW0H5gLSsVGXIU8o316QNo+WU=
X-Received: by 2002:a05:6000:1acc:b0:431:a33:d864 with SMTP id
 ffacd0b85a97d-4324e4cbe79mr60695677f8f.18.1767606979125; Mon, 05 Jan 2026
 01:56:19 -0800 (PST)
MIME-Version: 1.0
References: <20251223-b4-kunit-user-alloc-v1-0-fb910ae0e50c@google.com> <20251223-b4-kunit-user-alloc-v1-1-fb910ae0e50c@google.com>
In-Reply-To: <20251223-b4-kunit-user-alloc-v1-1-fb910ae0e50c@google.com>
From: David Gow <davidgow@google.com>
Date: Mon, 5 Jan 2026 17:56:05 +0800
X-Gm-Features: AQt7F2rWRtCZ2foFqib5wHn__dRxlvbLK48dSdGfX_Bapcf6uaBoiId46FXURj4
Message-ID: <CABVgOSn8UjWjEe-FNfOBSpZiBL0797VvJQZOOGp5QB6tv52COQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] kunit: test: Delete pointless resource API usage
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
	boundary="0000000000002b4cf70647a1123e"
X-Rspamd-Server: rspam02
X-Stat-Signature: mbdprxajscj4ncmt98ogomzmarm7uxcf
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E871160005
X-HE-Tag: 1767606981-323115
X-HE-Meta: U2FsdGVkX1+4c73cgR0UEVTfRQcZ+1YgHqkXR+ndh9UdLy2qfPDh983O+YP9xUc38yzXIv2dYovIGsnOxP43YqTRpw6XHJTViktdnvbsGusnNN3g2hMAvCSsR2WM66vKtVHkw77Euu35n2yax133446iAMNAzhwYhFwnHPbbmbv0g+ftBnQt9z+kQVwXxYTVSbeHygc5CrCFaPJb/F5HhG4phkNSkxch6vm3cnKSL1JURm4Y4nVjujfDWOKzct8ji72X1oD3zWoKKas1gnjmRm2oPvDQyqTjZYhNy6E/d8OqhwY0qAqaewhVNFdR9k2refYIP6/x+KSl+ofC16MeTPK/DI/ePIDqyd9YKxuf0ow1HQzPeP6rHQhFv3kNemYAeEPybxs6qkqUgMduRMy8eGauV52c7wd3y5rqVytyQTXHOailSPO8WjlruLVYTQJnNAyzCJV2wpqYSwHU3rGHgBJHrxk/tyd/gz06kOigVGYSEjhzsjYDEZpeGAf+2T+0tEO+1BRn1Gik6x/RlHy1Oryy4XdToHe/vaWyPkPR70uMF0TxSyaVvL6F/6Ls00ES5ixoAPM+2WURPmB7pMyd8mjQMMMA55/Lu/kTMW/C0ZV3WYgmf2F75Aiyfmy2CqMg1u4J5Cl7HBELQ9P5Kx6GO9jifU4+jfMgADspLus2tY73v142KVO2PH3KyPS6b9n3rOCUf0eKdrTp3DxdzqneosLpsu5E8w0rNXt2ktujNZPzEqlHnJuP0YkL5s/w7B+mS/0GFEKTbwPY+841SzI4NSu6iXdaYFhrwx8vykXesF7Wr38xT1mIXakCgNElabhnv/IY0Mpk4qpgAErUqIJCI9rFdcuPL65awFF08xiFT7JNP5Li5MIal5CKTQxn7GRqNxFKbUU/OFe1rwVJ83JvEZtRWaZCGQTUpRm8fkMIv2IcVeptk+rNlsmQV8sAkci3QuuyGOQEab8GEerqu0Y
 8PLsqgiZ
 ocFA3pVf+jtn+G3kaZV1Rp4+pY1PnhPQ8gIc5H/4udH4eL5ovqihoUN1izTdg4/UnSIIDLs2XsvpCbuBmuAjlDHLDT5Q1GxAJWVHqe2OPcYw5GxijIrhi/8anHTP3jIPlFYfofdetVKqxtMqSTaVy5U+ov3eOyw5owH3B8h2JCa9vmD+vfXrLPPU2nAUiRigrWqWH6OyfePUN4IKDiGeoAzX1Lb7m5EUUJkmgI0x8huIUhONeOtaaE3cTcs1KGRUfszL+lV5ydbWnBF3rgZgRItIDCgih9yYh0Zqb38aFnLVzKCovjsfHfMYlfU51D2ZPqnpvp+/hLyS0u/mjF8jHdTb2kFeVw/FYo6Hd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000002b4cf70647a1123e
Content-Type: text/plain; charset="UTF-8"

On Wed, 24 Dec 2025 at 00:18, Brendan Jackman <jackmanb@google.com> wrote:
>
> This code uses the low-level resource API to track parameters of the
> vm_mmap call, but it doesn't do anything with them, because the mm
> teardown code takes care of tearing down the mmaps. Delete it.
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---

This makes sense. Maybe there's a case where tracking mmaps as
resources could be useful in the future, but I can't think of any off
the top of my head, so this is just wasteful for now.

Reviewed-by: David Gow <davidgow@google.com>

Cheers,
-- David



>  lib/kunit/user_alloc.c | 76 ++++----------------------------------------------
>  1 file changed, 6 insertions(+), 70 deletions(-)
>
> diff --git a/lib/kunit/user_alloc.c b/lib/kunit/user_alloc.c
> index b8cac765e6204..564f5566641d5 100644
> --- a/lib/kunit/user_alloc.c
> +++ b/lib/kunit/user_alloc.c
> @@ -7,21 +7,6 @@
>  #include <linux/kthread.h>
>  #include <linux/mm.h>
>
> -struct kunit_vm_mmap_resource {
> -       unsigned long addr;
> -       size_t size;
> -};
> -
> -/* vm_mmap() arguments */
> -struct kunit_vm_mmap_params {
> -       struct file *file;
> -       unsigned long addr;
> -       unsigned long len;
> -       unsigned long prot;
> -       unsigned long flag;
> -       unsigned long offset;
> -};
> -
>  int kunit_attach_mm(void)
>  {
>         struct mm_struct *mm;
> @@ -50,67 +35,18 @@ int kunit_attach_mm(void)
>  }
>  EXPORT_SYMBOL_GPL(kunit_attach_mm);
>
> -static int kunit_vm_mmap_init(struct kunit_resource *res, void *context)
> -{
> -       struct kunit_vm_mmap_params *p = context;
> -       struct kunit_vm_mmap_resource vres;
> -       int ret;
> -
> -       ret = kunit_attach_mm();
> -       if (ret)
> -               return ret;
> -
> -       vres.size = p->len;
> -       vres.addr = vm_mmap(p->file, p->addr, p->len, p->prot, p->flag, p->offset);
> -       if (!vres.addr)
> -               return -ENOMEM;
> -       res->data = kmemdup(&vres, sizeof(vres), GFP_KERNEL);
> -       if (!res->data) {
> -               vm_munmap(vres.addr, vres.size);
> -               return -ENOMEM;
> -       }
> -
> -       return 0;
> -}
> -
> -static void kunit_vm_mmap_free(struct kunit_resource *res)
> -{
> -       struct kunit_vm_mmap_resource *vres = res->data;
> -
> -       /*
> -        * Since this is executed from the test monitoring process,
> -        * the test's mm has already been torn down. We don't need
> -        * to run vm_munmap(vres->addr, vres->size), only clean up
> -        * the vres.
> -        */
> -
> -       kfree(vres);
> -       res->data = NULL;
> -}
> -
>  unsigned long kunit_vm_mmap(struct kunit *test, struct file *file,
>                             unsigned long addr, unsigned long len,
>                             unsigned long prot, unsigned long flag,
>                             unsigned long offset)
>  {
> -       struct kunit_vm_mmap_params params = {
> -               .file = file,
> -               .addr = addr,
> -               .len = len,
> -               .prot = prot,
> -               .flag = flag,
> -               .offset = offset,
> -       };
> -       struct kunit_vm_mmap_resource *vres;
> +       int err;
>
> -       vres = kunit_alloc_resource(test,
> -                                   kunit_vm_mmap_init,
> -                                   kunit_vm_mmap_free,
> -                                   GFP_KERNEL,
> -                                   &params);
> -       if (vres)
> -               return vres->addr;
> -       return 0;
> +       err = kunit_attach_mm();
> +       if (err)
> +               return err;
> +
> +       return vm_mmap(file, addr, len, prot, flag, offset);
>  }
>  EXPORT_SYMBOL_GPL(kunit_vm_mmap);
>
>
> --
> 2.51.2
>

--0000000000002b4cf70647a1123e
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
PzANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQgU21tlyrnKcwwD0HKVywy0ClrUDAI
j+EYTMvKqDXyr+cwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjYw
MTA1MDk1NjIwWjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJ
YIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcN
AQEBBQAEggEAeMLzwQb11o4HDjkOsb6HGw4/G9MyJhF307GZPsc4LZdDAC9ooU7tiWoalH18Ns1h
aHTztw9YWNPV6p05eCFszD3HSVsArAPc9hjOwYDrZxYP9WLm2+tDhznPZ5fU8jD9MOArRQV5ZLw8
iM58Rsh8XvugkQfnQ2OTKenE2olTmjPq6ZF8DmeuKcPbMkL73wKt4Eldu5ZEJS6AVDCqmnckMqcg
AnLrFFHnEk8cAaDu1SnK5UUwOkhzFkUzR0QAZzQjLnXKRUPbbZPKRy0AVUBnO7MOpUI1oDEqjgox
W59oH9Fi8nrgcXB0NU1R+j8LSNJguiqTek5F40H1BGZH8759LQ==
--0000000000002b4cf70647a1123e--

