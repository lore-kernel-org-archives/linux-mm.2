Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF45CC5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 03:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7AA46B077A; Fri, 14 Aug 2026 23:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B24496B077B; Fri, 14 Aug 2026 23:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A13616B077C; Fri, 14 Aug 2026 23:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 715CC6B077A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:40:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 095DB1C0E0C
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 03:40:56 +0000 (UTC)
X-FDA: 85102102512.02.FA22972
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 15331100002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 03:40:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fxhXXYGS;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786765254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vkBjXZgfE9QuZPVA0q0zgHjLQlsV7v8f9ZdsGtdUY+w=;
	b=yyDb1vMuvxwsKvvWLJr4u40IiHdbJyStHLzzJXE4D9AetwfPytrxDgjq0IbSwX5tW+BO8n
	L7P68wF+7lvML9FXGEDJElnuZFolh0O4+ZWwv26S0CoezxmQF/7zVIU/U8ZuxqqxtAE8aL
	oJ8XLAbTLl0vPIzsKM2AM8B//nsJxug=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fxhXXYGS;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786765254;
	b=nOIM9cioPNqhOA7J7Tki9oL8l7+ixWKwhJrgNV5McWlNsLF6OAP5Bkf8us8lrPXV5dz/i6
	QVZ3xWZ7U6MSaBx+wAH51QhM9O3kTxjT+5fwN4FjSVlTjEPowqzYEfJlewfP7XPv2a4ouA
	0wu45Cmfo7bqevVBbIr2zC+JVoNpLak=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c10e86e52so378541cf.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 20:40:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786765253; cv=none;
        d=google.com; s=arc-20260327;
        b=rzPzzdLBmQKhw9zvUmN68FnZcdzb9EvBeI+mYhXL/pVSzQGCYXX+/TjXvz7jYejIq4
         of3UuN+alpg0iotlfUT05KK094rzd6k+3hO9n+2cRPYScx1lHTbACE8O7CpXXf6k9vDw
         l93NqL8VmsiVJiF6XmC89OnnHkiCDkI9M/hBATzuVjContW81HD28aU0dFNy2nbpwCHV
         ZzKg2MKhZDdcgjdel2e6z91mSNQ/NS7uY7nx4zEFvQbUQwP3Rc4HwLEk2RSqBLMEvLJq
         gN/0e3PDqVurzI6XuAjjWwA/s/Bjf0s28Gdo9+w+FOjXWw1OCvIxMkZ7RlJaeU/5xd86
         I2zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vkBjXZgfE9QuZPVA0q0zgHjLQlsV7v8f9ZdsGtdUY+w=;
        fh=gjunftKjRaYFgw1+z9KItKB5Yn0W2wwwL54wx++3afY=;
        b=BzY+1fZgsmdV8Sj0B0FYHoFvLNFwkrMqtq2zUBNmZdkITUC5yaqc/HnHoSHP/i7CWE
         3wQyx0L5qIUS6khWLUaM2HWQA0jObq/7nqpqUTm9dnulaggPTVp4DsR1xrNIjy319TF6
         Ca98tff3zyRDeKg47y1nlGQ8lgTL3w2T6K83pP1wWUyt8dWwul+pPcflXzku0SXQ/amX
         0re7z7+vYk6oQUB/HF4Zni91hHyVlUE+c9WW4fQAonGsynbAI1t7n7oRCpT/Y+6ZAxgX
         aRlUPYX3UgruuxZ8rTLg/go2gHhhhIeasNnG2UnW3jVlSeGMKuLm4Q+lzd/E2qFzZrBb
         gRxA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786765253; x=1787370053; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vkBjXZgfE9QuZPVA0q0zgHjLQlsV7v8f9ZdsGtdUY+w=;
        b=fxhXXYGS3B/GdRtNVgXMCE9KbKP46Zx9X5ItMXfwmbx6GdIpKJynvo9jgL6cz/K9a7
         lP/6v9E3edDXeLE0vmh0T+oGxwpzd35ofVysBYdV2GstohogP6BFn1SIv4XPxKr4zTXJ
         MC7uulhFm1bsHWFXcsOE3upNuTHIUwssjdIvBCbMxhZ4u+oXAUtrE/Mkcm1RY3WAix8m
         Gxeari58ExF7r+018iXK8SFk07YCc2P7rXmxgCCrrWIcaIcl3t2ydwGUz2luJ+11XSB7
         EQRkxoaf3FehoqKmA+G1X6l+qoDEIO/x+/7M3zcV1kI2FfsyES6FmZmw9rAwNZXuZhoH
         kbgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786765253; x=1787370053;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vkBjXZgfE9QuZPVA0q0zgHjLQlsV7v8f9ZdsGtdUY+w=;
        b=JW5fhg4ml/zL2tw5VVj1Yfd6gPCttSid6VmmNeHy28UKeXvjgO6mpAvyMw3BUOj9IB
         vtzmg19+0141HvLnedV9lBGcbQjy/jdoK3n2vrByfuE3guvKgT08UGT8jnW67uaRLRTz
         vPDpC3QiLBH4rXZL4/BF1TmBYArbfP6IM7SFNlf6XRP2NXtWJef1dQVbfGQ5d6AhOYEo
         6+Yj2PbUq39O1IZUaOQr9h9PJ1FMIeyHsXHxLTYQ8U2pOCO5HNH0V6F4T9qdZCTXzLvD
         Q67NQcQD8dEYzQMmPBM2SwLBYuQssal+r11Ba2Kyj8WnYUAiyy66LXnHswhgCb43DrDc
         2Czw==
X-Forwarded-Encrypted: i=1; AHgh+RqCFeDrZdzRKvGE78YNxyc56B7rzgp1LYWJ9KkYTUPF+s/mZibrLyresSHtAQfk6+eVgB9JENrGtA==@kvack.org
X-Gm-Message-State: AOJu0YzfH3SGJ3VMeSxtt+ct4uHQzTxNgSkJ2yhUzrpdhpwZp5yI15OI
	99xaPGUlrkrGIWkC6341LmxfGRNYZRdRCem8LxGuIrEB46BpobI8vfhE+Wc+gPkxob5Rozytola
	mB9fFjk/YeLA7cfJPFgOPROrj18JGZlEhu4uf6McA
X-Gm-Gg: AR+sD10tRUfuZwLCNw27RvP6CMJSKZ72D2idWE4rdIH0vsnPZiIFLv5ylA9EDL8DDgp
	V6coPIkYItGUrHSYUtHEthHw4tTqiUaqtJkapyTitXpUxwn05XsG2d+vBP51Gm4L5qdY7SJEvtn
	PGQ689oWNWczwTmdrrIYdotedcgJ7OpighBXcxA4iu46ykGXIxWfsDEC/HUFtNP5BdIv5Bv0/A8
	LJSeN5nlABn5VvKEp1lzLYC/Ufa/xL1SIijPzo1LJlTEsU0PxMI9ds1u3N1gxUEM7P9XKxtxoh+
	k9eBng/7JpG77LfteT1aOR9uhp3H+8sIRdTDWFsjJ2exZnPiGcinJA==
X-Received: by 2002:a05:622a:2309:b0:516:3f51:81cb with SMTP id
 d75a77b69052e-52d863056ebmr33346621cf.13.1786765252641; Fri, 14 Aug 2026
 20:40:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260812054105.102637-1-hao.ge@linux.dev> <20260812054105.102637-2-hao.ge@linux.dev>
In-Reply-To: <20260812054105.102637-2-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 14 Aug 2026 20:40:41 -0700
X-Gm-Features: AcwNN1VIChM5uS8AeDFgxDsAxr3cLyAQ5ichFcFG4fV7s7-Mxs0cUi0jsKmDMp0
Message-ID: <CAJuCfpHYnjhHh6mex5vuzwz=ggn8cuW_oR03KWih9vx+76a+RQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] alloc_tag: move release_module_tags() above reserve_module_tags()
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 15331100002
X-Stat-Signature: hgwa6uoxusbp7mqcbhu3ei7ewzidjrjo
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786765253-815527
X-HE-Meta: U2FsdGVkX1/pFfewfKo1bcUxDI3Wupwt9c93VUf62FJ16D/nTTu85+VJPD2YDcYU55k6g5LLjrnEF/v/037oPan6yHIAWMS2eHrcXzIzvvCNXkX4/Up8mlp+fF0K3JIwBLnZtxVuVB+JUDBE4yoP/yw/6uwyMx1HpnAdwGgLBkDkqFRGW+v6uMOXV2jjvd0VcCuhwOlPr5HvRskRYtt2OHM+3UfpQaSOdpHKN8MLTUCBbwTDuD47xS9gbNuKbU+QAl+/Oav7D9L+8/fJF7o46h3vIfvjKfRMuwRkLbrtBDebarmpE1fsXBIof+oEAxNf5zMMxGvK1rd6yjtS+uiVC8cnIp9xdnlnAimTwN2BxrVGVc1BXigYBukdAoCCwZLxEAuxm5MpCh7G6K/3r4Mw7hzA2HfIyrTtkEXqfonIczRDjLu20b5etVbCnJextfYcflVL/if0eQNERIcpy6QFIu5tfi5EM8T07pd1dR4ifdv976kV7X8MT+/+ieXRuWpP1oUHcXZe4JIFIMh8/vdwHJegcmhK6F43Gk9pPVLfx7Ex00isncvF6O4WqkZLWBFz49OPUCmfgG6w3EvF4s3uH+Hw1fJDgPQISkJm7HrERDO8B5yEN0AP0IdWDIhJXBma/Ex9Da0Y844aHfJ9YjA+th4SMLO6MEuPi9L46qpC1vgkjdt5mhPeY6DGMAD//AJOn8oPMfH6289F3FvCiJKrMSUks5tk+WakstSu70qOLIjg8erJft1OezjdeJQF0RC3B47ZtH41G5hhom0KlKImjFRFNvsb3ZobUYlGqHTPWXrgh8RkXo/Xz9GatLRkHhHTgtJtjJpp6xXKZnskGKNNwjETtPt4RSsrTD/RsSZv10UcVDO8Tx5ZE4+sNxP96bjE67v2zlmL+gyMfI9Se2vyNmgzAwvY0iGN0f0ANtwdgq+kTaSywaMnVm7GF6i+N/FiPQ3qtfxny5MO9+ov/16
 M8cOizJB
 5SLxl/YKwjVE4Hm+Fnvq4l8krUO2jrcJSfW7lPMe59SEEBr/j5BPoORwGAPZRs0SSWkOorNbyiKEAAl9g51p66tNF0BJiqz7+LiZzkbrhmwa7D1hvV3x5aCMToTBp6qJ/eztWBV1ZAu1xYXtzrnwo4a5HS2AAXl0FusNyit/ZnFOuSDXOxkzxFsjWSywpsm46JieF3H40hqcPngrJUrIu+7UaEyrDE+DsRmdGP2nMbqdgmq3U3PJ5a8Gr+OX56/Z6UVsW1IbwmRkPw1FnyTfcZi7GOUlf9qmJG/STKfv70cU3w77YLpQebfU03ZReKjhJY2B+v8qlAiPmnBw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 10:41=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> release_module_tags() is a cleanup helper. reserve_module_tags() can
> also fail after storing the reservation in the maple tree, in which
> case it should call release_module_tags() to undo it. Move the helper
> above reserve_module_tags() so no forward declaration is needed.
>
> No functional change.
>
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compress=
ion")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/alloc_tag.c | 92 +++++++++++++++++++++++++-------------------------
>  1 file changed, 46 insertions(+), 46 deletions(-)
>
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 52aece27b00e..af44f90379f2 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -835,6 +835,52 @@ static int vm_module_tags_populate(void)
>         return 0;
>  }
>
> +static void release_module_tags(struct module *mod, bool used)
> +{
> +       MA_STATE(mas, &mod_area_mt, module_tags.size, module_tags.size);
> +       struct alloc_tag *start_tag;
> +       struct alloc_tag *end_tag;
> +       struct module *val;
> +
> +       mas_lock(&mas);
> +       mas_for_each_rev(&mas, val, 0)
> +               if (val =3D=3D mod)
> +                       break;
> +
> +       if (!val) /* module not found */
> +               goto out;
> +
> +       if (!used)
> +               goto release_area;
> +
> +       start_tag =3D (struct alloc_tag *)(module_tags.start_addr + mas.i=
ndex);
> +       end_tag =3D (struct alloc_tag *)(module_tags.start_addr + mas.las=
t);
> +       if (!clean_unused_counters(start_tag, end_tag)) {
> +               struct alloc_tag *tag;
> +
> +               for (tag =3D start_tag; tag <=3D end_tag; tag++) {
> +                       struct alloc_tag_counters counter;
> +
> +                       if (!tag->counters)
> +                               continue;
> +
> +                       counter =3D alloc_tag_read(tag);
> +                       pr_info("%s:%u module %s func:%s has %llu allocat=
ed at module unload\n",
> +                               tag->ct.filename, tag->ct.lineno, tag->ct=
.modname,
> +                               tag->ct.function, counter.bytes);
> +               }
> +       } else {
> +               used =3D false;
> +       }
> +release_area:
> +       mas_store(&mas, used ? &unloaded_mod : NULL);
> +       val =3D mas_prev_range(&mas, 0);
> +       if (val =3D=3D &prepend_mod)
> +               mas_store(&mas, NULL);
> +out:
> +       mas_unlock(&mas);
> +}
> +
>  static void *reserve_module_tags(struct module *mod, unsigned long size,
>                                  unsigned int prepend, unsigned long alig=
n)
>  {
> @@ -922,52 +968,6 @@ static void *reserve_module_tags(struct module *mod,=
 unsigned long size,
>         return (struct alloc_tag *)(module_tags.start_addr + offset);
>  }
>
> -static void release_module_tags(struct module *mod, bool used)
> -{
> -       MA_STATE(mas, &mod_area_mt, module_tags.size, module_tags.size);
> -       struct alloc_tag *start_tag;
> -       struct alloc_tag *end_tag;
> -       struct module *val;
> -
> -       mas_lock(&mas);
> -       mas_for_each_rev(&mas, val, 0)
> -               if (val =3D=3D mod)
> -                       break;
> -
> -       if (!val) /* module not found */
> -               goto out;
> -
> -       if (!used)
> -               goto release_area;
> -
> -       start_tag =3D (struct alloc_tag *)(module_tags.start_addr + mas.i=
ndex);
> -       end_tag =3D (struct alloc_tag *)(module_tags.start_addr + mas.las=
t);
> -       if (!clean_unused_counters(start_tag, end_tag)) {
> -               struct alloc_tag *tag;
> -
> -               for (tag =3D start_tag; tag <=3D end_tag; tag++) {
> -                       struct alloc_tag_counters counter;
> -
> -                       if (!tag->counters)
> -                               continue;
> -
> -                       counter =3D alloc_tag_read(tag);
> -                       pr_info("%s:%u module %s func:%s has %llu allocat=
ed at module unload\n",
> -                               tag->ct.filename, tag->ct.lineno, tag->ct=
.modname,
> -                               tag->ct.function, counter.bytes);
> -               }
> -       } else {
> -               used =3D false;
> -       }
> -release_area:
> -       mas_store(&mas, used ? &unloaded_mod : NULL);
> -       val =3D mas_prev_range(&mas, 0);
> -       if (val =3D=3D &prepend_mod)
> -               mas_store(&mas, NULL);
> -out:
> -       mas_unlock(&mas);
> -}
> -
>  static int load_module(struct module *mod, struct codetag *start, struct=
 codetag *stop)
>  {
>         /* Allocate module alloc_tag percpu counters */
> --
> 2.25.1
>

