Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C224FCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 04:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62F646B008C; Fri, 16 Oct 2026 00:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E0666B0092; Fri, 16 Oct 2026 00:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D1596B0095; Fri, 16 Oct 2026 00:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D02BF6B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:42:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE6F1802BE
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:42:54 +0000 (UTC)
X-FDA: 85327244268.20.222503F
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id C8F6DC0004
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:42:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="O2onXfr/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792125772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HOrvcb8VGO3g3u2hTYFvmKxMb4WgJQMQSCQrwrKKXf4=;
	b=Dtm2/N05bb/NgBPEhlp2I308drSUEUu1qEomq/OPfnNJvAHpVPQLysbJEdUNLbxbAITwk9
	psQWavvzOrfgo2tI8xFZcueqzDz7q+sAd5GDLNqAsKIRfZjPIB/NLgcwI32Z6SMMBUwpnJ
	yqRSEgPyb8TSbmsEtLROikobGzUzzbc=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="O2onXfr/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792125772;
	b=SPzkhmebQ6TZhyjRHwvr4OZ89WFSbSEDhae+Y2AMuGsS0tUCmvxqWNWEwD3CL6UnfM9fK5
	u/Dyrr5XteLp6WKk5xIKa/4fCFIYcPY45hU4KdHnmfCk5xDrBvi8KLvArVem34UuHdKNe+
	iZcxcXq5yrcCjy2xho+4a2DEFwtzeUo=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5bce4e278baso807270e87.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:42:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792125771; cv=none;
        d=google.com; s=arc-20260327;
        b=M5PnxrPlYn5bWdQwfrfovvxPp2d13HnpjX2QR/6Q2HY1r5r5gZD9F0/+oF5QmylkP/
         sj8H5gH5fPa3M6NSmn9+1PXhj9Z0TE7WXLMahclQ7khi2WnakBo/72EmGvSVBmyPUk7j
         bAtQySiEY8eL3zK9MGRjjTAPX10UewDIY3HkYnTPe6sbnF+BOFh468fMTnd5leyL7N4T
         s4YMtyzM+Erpf9pdjxFmiqQa+HyaHX4y5vx1+jnuCKqPNCKN3GFrb2t/jBXcki8K6YIK
         EPJYolKFbi0wsAn+RTkoI9/1568Dies40nP8G0UR8Uzac4MV6rKGH/GNEf2J2IAoVecQ
         ZZWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HOrvcb8VGO3g3u2hTYFvmKxMb4WgJQMQSCQrwrKKXf4=;
        fh=ZimyzREgYDII7d91zKvAqtcdCS78PNF2PH+oDYRFxjE=;
        b=CeFC5TrjxjAnKEwmv3kyMjNy9kGN8MPjMVQA3J1EiSJsCsqyx3cCuy2RVexWRXM49s
         Rsm9/QSHSkhAbLd4O4PcKG7iFnTwt5neYJy8LK7138LpRx7IsXhHpfdnOPF6FjelYfyg
         VRfKVay6T6pfb1vk8PElLoLgdQdrMbC24qkWknb0QKPlKVTpjfbMk4xT+9ClIiOKs6AK
         WPJi8xKzjpHVYICzB/S/UMXeXjyQZxj2tfbNvQWMCcwICkE5hOVbBdx/389kXr+m3Mlg
         DZiQmH5yYSrWhGKbQTHClErWYK7E0Iqb0HSK410pty9kkPTBsCiu/gnwwlgSVIT19QHt
         uwAA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792125771; x=1792730571; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HOrvcb8VGO3g3u2hTYFvmKxMb4WgJQMQSCQrwrKKXf4=;
        b=O2onXfr/SEffwVoafZaaXGiV8uj3ScFeUmh/Ge7cP2b3onTy/0UMcyh8ANI0h9z12L
         taqJBaBlp+0kaf66u9NlEV4fXULbu8Z2VumayQ+xolyslww6hxIVbZBby9gmcIffBP7m
         UzU/5us7aYOZV3UpSUfc2ROBGz62id8DvQ88i4RXz5oY03AMhOvpMqcqF39A+/i/SotE
         OG/u9IyUZOVowK5R3Jb++jf/MtEZAZj+O/XzSzIczGt6+hnr9zuILeUs1K5vSkl6YE6g
         jc5SXATHFvtBWvCWnu22WqFnmdSDigNHCrq5nPcuNCvrFjtwst1d6eQT2ZlwZQbnWdpT
         ytmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792125771; x=1792730571;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HOrvcb8VGO3g3u2hTYFvmKxMb4WgJQMQSCQrwrKKXf4=;
        b=iRa/QiqL5wsCHrsPh6QUytBcn8NwPH6lY/WrHfI4Xi58Vrz23s4jf+Uc7iGYfNyT/B
         SHqew1c06T/A3lI+3Uv67fi6+43ErFWQ4o9hUHM3P21tPIC3UYZO4QfWVuGyhOqCT34N
         /qIGx5UfxA8Q1xiYd7D4ANe/P6bKg8VTTvTysjj3Rc2Ieotu+nN2QlwB1SQjmJkewU7O
         fmHjs1qoZ+T6VQtuAJ/sSEHHlBkwIYM5Vz2aYg096LKia4vWWoeNVQovXbFvzEuQxdC0
         ZZ07jp5rnvsSC2r/OSve31qKAvtbfyveb6CkBt6/KlMcoF84SAluWYmk1Yy3Y9DqYPVk
         5aog==
X-Forwarded-Encrypted: i=1; AKwUvBzNES3zeQ2xOxK6IeR/eDWS1MY9aX2krUySxyn9TLY476QjVR4X6y3MlIPtyAE71JgjYrWxp1lVSA==@kvack.org
X-Gm-Message-State: AFq9FYJ0/BNZ06XRrZf5QwYZgvTCdQWA45cMzZ6I4RszlW7twvHeQE31
	YBZ4K2Vpci4kmYdmA3kQQDmbDNJcNDyZ4puE+xv6iwJSEzKfj3+lSZI4fJpoXJShMzFWQuiG7It
	4VYvEEY4XN7YwzeXFGmhDROWRSS7BR3U=
X-Gm-Gg: AYBFou1mrznbIZ5b6+Ao3dcLtAT2pUPAn16RSv7zgDJ5+1qyceqravpxP57RdgSw+8V
	mS4iBKlLpY5nn+91tj3jrwSsafk/iUmg0Y/+UKJXeowGj3Z5Ynm8VDEEma7vYOu2vPD4jF2GtL+
	L1sKxOULxBwtzc02QtETZsdFm5svIaUSE0cvO3VanFDV+4Oe50sQKLqjohNiH/2/AvejcOPCHbi
	DS/30WJJQL5GQ8P7IVUFEwDlxEUSvnuNdw27t2gMmFjZdh67Kooklny+0bOM94++VKhMd5RyTd1
	ysF/15fxtZIq3uZ9aO4Ck8zLlKcoHrwTODw/yi1RDFkW32kepcovm70=
X-Received: by 2002:a05:6512:b88:b0:5b8:edea:6800 with SMTP id
 2adb3069b0e04-5be476da151mr631619e87.22.1792125770781; Thu, 15 Oct 2026
 21:42:50 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <as-jZopKRfuYAiTE@google.com> <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com> <atGqPIpUfX0LDokV@gondor.apana.org.au>
In-Reply-To: <atGqPIpUfX0LDokV@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 21:42:38 -0700
X-Gm-Features: AclHuK9lFk3Bp3AlNyS2F-GkGX_WVBdlaB2VfCt4lT21jMqDyuj_BMkFpZJj-S4
Message-ID: <CACpmpofAtQymsWVG+XtvzHahthFmNHXND8t-pqj0fgURCP6Okg@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C8F6DC0004
X-Rspam-User: 
X-Stat-Signature: 9665d18oj3pajpsywa7fnfh3zzasq3g7
X-HE-Tag: 1792125772-125856
X-HE-Meta: U2FsdGVkX19INIvC4P3ITTHjWJRl9RGvcg11EeCuoStRR9tb/XPEu2YdqlrS8Hh/0R5rpk+pt63pG49wRtPT40GZ0Sf/4U962q/IrJrXvfSifwOOfqnMVlpRXixtMGe1F6++nt/G+b2KiXSY96FP7YRr0rEfn99dfKR6Oi6VjIIx/h83dSN94n3Mc/6vZGE1yiI0UlCJWx0L/A/+tEDicPOJhq6tWmsNdYmwMinVmnO5VH725Xt/iZ41zEmOaKqM2pFXV5iqgAgrOQPjEI1fRE4QQouwjoCce/VfDp7/Qih3aNthoNBIpn5O1VvdjaU/oC6+s4TsL/eT3kqhJ8kzp3Bro3SkxWIlrIiY/iCxPDBwDcCp9dQJFH45lX+MpNSoNVE5TxWRw2ECsBbE3BUoIULa9kyEsqyaJ03yTzdpw0Vi0SH1pPYrCUARiSVMJVWlWI2CLhCe01E1KgqnILixFXTfNfhIlYPBF2ki2LKHcL/SQalSq+B8m2xymezC8ESYugxuetg/J4knLAE0CV5wsQoitbV7QzzPf57G1hvLysYiO2ZBP+8hzRzU0CbfuJx1BFOo4z9ZQTubhWktcJ6NY7ixMToHR25BXMPaULrgc6AKS1MPqBS/bkEhZ0+cXipNsZRLI7n6U6cwduzybouP/g17MtwxwXjTEHsI0Ba8hBYc/4y/O1+yww+ptxEUlg1d2qy4pIKxcZL3sSS3urz7ma9/H4ItTSKz8IwRdgJsaFJFNiIW1+YSORCRjWZD74BylFat/prsXsB2iHVS4SdYZYw6Stnt7wDXYhtWNCHpVIihdiwwJW66Stf6iFmu4jEkcsJbO7eQIQv6lKiGVb3O0zYd5K/xGM8YxJQCklgBU+TFBJktqroHVh9+V7YQxkxlIvyinFl0Zh6Me3QTYYplSAhRY4mupwi7yVsWji0fxrNiKmCFCsataPgErewxgXRpReFTnMVGlh3jY72IO1K
 nvnbU9cz
 rY8rKadJo1gULuzD11lfe9PGZ+IPET7Lcs10u3tmOqQoaOuob4lBa8kWj192/tuF7WSH8Unxuxv4qHHD52uk0IfpU8V0VJsuYrG6HgBp1Oy0qAGAkHJNEqxzfvW//4elRPUFY6R5vHyn2Va8LPu5eIhN+zK7G4meUE2miNPXg8THplBoaMS/KB4Z0N6A1YCiWgFdQTU1q9gwUYenRsA1+errmYd/MRvDWVgZPUBPSEXQ0++kRNOVrwKQlAPi6Ox1/fcIhQ8fqejL2uZsXgvA/P0J12ZjZ4UXI4g0dzpVVgUDNKYmxVeoXC5wLjOX7ivsBEyTdJvaU6SIdnW/NhpTlykfgHQkxqAMyEPNGlN+gNUZ1y6B2+LX+lUpxjgOJJN+jMnMstIALnQ5GhYnZXCvlMjqCt7rk5KN3jBBf/mXBt1Phbs7KA7GfHX2JW328SSJEA8oeOg7BvLWVUsX9Z33fZLbeaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 9:38=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Thu, Oct 15, 2026 at 08:32:21PM -0700, Kanchana P. Sridhar wrote:
> >
> > If you are Ok with all this, we will need Herbert's Ok for this change
> > in patch 3:
> >
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index 192ea996e779..db8e4c82b900 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> > @@ -293,8 +293,12 @@ int crypto_acomp_compress(struct acomp_req *req)
> >                 return -EAGAIN;
> >
> >         if (likely(req->unit_size && acomp_request_issg(req))) {
> > -               if (!crypto_acomp_req_seg(tfm))
> > -                       return acomp_do_req_chain(req, true);
> > +               if (likely(!crypto_acomp_req_seg(tfm))) {
> > +                       int err =3D tfm->compress(req);
> > +
> > +                       req->dst->length =3D unlikely(err) ? err : req-=
>dlen;
> > +                       return err;
> > +               }
>
> What if you put this short-circuit into acomp_do_req_chain instead,
> does it still give you the same performance boost?

Sure, that's a great idea! I will let you know if this gives the same
performance boost.

Thanks,
Kanchana

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

