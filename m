Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25ADA606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=S5zDyEK0
Received: by kanga.kvack.org (Postfix)
	id 1DE986B05B2; Mon,  9 Nov 2026 22:12:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18FC86B05B3; Mon,  9 Nov 2026 22:12:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A78C6B05B4; Mon,  9 Nov 2026 22:12:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3DA06B05B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:12:27 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A1AB1C426C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:12:27 +0000 (UTC)
X-FDA: 85417736334.01.9DC4D23
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5066E40003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:12:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=S5zDyEK0;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794280345;
	b=59HJtR+TW1+4LlwFU4heshA0UvUOYdcomyEJSHqxoDgR5rqBSspwVlBKWnV0i0Sam3G8qL
	EcqDZNI8Nzp/5ePDupgBCruI8M55vFD5rzc6Udw0kZljVGl/4fYgueujMTnlfCe+DkrRtL
	xXHATJIRbErvne4ZJZLIz2bPYKVUtQ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794280345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFGbItuCJXnws5VmBkLsQYAO9inTwJbRMBsOInhSTps=;
	b=GTbxvfofbe4/2vd1UotdVuBdn8csChD+SY9KKL15NtDBz9VOIF/sDI5yCgGT6fzG5RvBjb
	jFTi7w9pjOsTQUbVPP8CoavTCaPwCK2KKTuAoL9+nit1siBFrfu00++0PY4SWvrKNwYCv7
	adstICduRxlVin4wbTQ5lxUIj0lb29Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=S5zDyEK0;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8a07078200fso622875b3a.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 19:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794280344; x=1794885144; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NFGbItuCJXnws5VmBkLsQYAO9inTwJbRMBsOInhSTps=;
        b=S5zDyEK0Y13/bH27ruuBCeggzB9Zs6M4ek/tpZQMRVmhnRV8MHfqeXpk90ELXY2WxG
         Zm8OeWe4+15/erkC8uIfYOGpUem2F7jCY1SE2qRWnUkpYg8+iO/ixJm2/sI3LyuqOTmd
         hUZgZik8ak7lvQw/1lueipSSzQ8cLdQafe5tU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794280344; x=1794885144;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NFGbItuCJXnws5VmBkLsQYAO9inTwJbRMBsOInhSTps=;
        b=JN1m76iWCl2+hv9s5oX71XmIFHFy9UFWoJYji1iZHreR/813Mp8AUJi3dDNczZ1si/
         Y40hZAaY4BOs3hcjk8JAsR19MRuK14efwuQ1ulpMUeAl9qFO96RUKLeyhQjo8sOvdc/R
         bQ1XCZX6uyM6/soUyJgZ0EdMShvQz6HSM9oZHj29xEPuM7UOeSzYew8OUAidoBPkT6Ge
         4SKjk6rQYQbHyMndbpOWY2V0bKKQGQR7PAjxeIPZNbl2GysG9ZbmAvDywCTNB0/cCinh
         QCeXw5seb9G549O7Mrt/SBsG+Gd7vgZtLSdFmcW3dva9tAAU0tgl194Bja7MQdtPn3lm
         nnnA==
X-Forwarded-Encrypted: i=1; AL+hErFbduOoiJiuwgaeOhurkJJfQE3sJaB+s+4CKi2uaOQKaBjnThlucaLKt4Ie4jkloKTtuWHdnE6AVQ==@kvack.org
X-Gm-Message-State: APuU4Z/egV/1zcIiaLMKYcalqUuIFhuvmaI3nr0d56Qkrxddm6efncHW
	n9ny7SfLMHJHanxr7HvS/v54Z9c2jZ9lJStedVD0vh94NLW1W1wGJ++nGJoNgijndw==
X-Gm-Gg: AYBFou1Cw/gXRGsuC2AQGKgAoDnG7mxm33OzyazJewC3wKgP+PUS6DD+rQl9LFKIvoj
	3hDZllPKv5cQ2ZY61aN/7gM8UGIucf88olta1pAz/3hcrlnLvNl4lmIcc+Iv+mGAqPflaeXE2Mo
	whovVSYG8vYreRZRm6NPSngR6YHeXsl7HSujE4arOfG00IduV95DTqDg0tbGlTfJjTctpzACDY/
	KBDMX1o2yv+h3qHZOvoKaHkioLryYVXYK+mpQ/pCVKWu7Gjg/husvvjMUStO13/RWxRvrNbUTXn
	ZHr+9ubwgY9BFbPFIicLYxP8fuKnkadD2fMDIxI6D3MFXmxK6plSHiM8iM0aRKqlveOd8vB+vr5
	O83op0nllWSigof2y1wv8MJlwEr0gbMID04M829hL4mnfpYYUSGylxOr0s4mdGGZb90m8JHzFdx
	39JRMoZ9BqNZYl1SgfSpqCDo7IghrraCc/xXg73jqLHAelo986tU3c4xSAkPpODiIRBILXBJtWL
	O7nBCP9Gi4xD3cE/Aa9K/UtVCuWaUuYsyaDTkmCb1haC8yaCkm0Vq1TudGLNAhjXZOcfvnN5vZN
	dkryOICOGUNFm8fMB+Ar0rcEcJ2TgR3uvuMpEjrKiGohYi9ghU5L09iUajYa40UErlWkNQ==
X-Received: by 2002:a05:6a20:3d1a:b0:3e2:e27:1d36 with SMTP id adf61e73a8af0-3f190b8c38cmr1165365637.59.1794280344125;
        Mon, 09 Nov 2026 19:12:24 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d7b6236sm301072a12.23.2026.11.09.19.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 19:12:23 -0800 (PST)
Date: Tue, 10 Nov 2026 12:12:19 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 5/7] zsmalloc: embed struct zs_handle into zram and zswap
 entries
Message-ID: <avKLRTmkNGU-wxmp@google.com>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
 <20261105044752.1997895-6-senozhatsky@chromium.org>
 <auy22TkX0ADxP9WR@google.com>
 <avKFc82JS4R9yU-N@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avKFc82JS4R9yU-N@google.com>
X-Rspamd-Queue-Id: 5066E40003
X-Rspamd-Server: rspam12
X-Stat-Signature: ipjd1g5tn6fzc994nsqpxms5bidnp7wr
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794280345-297595
X-HE-Meta: U2FsdGVkX19qeLU0wSx8HNH37HPJY9Lf1Md1bP2SvaDVRk7Z295SD/+e9MiWyhvfpeGp1iDQ7tgIcJd0LcdU/B8eNV0gPvuXeEhlTi9r+NDhrH42uRi9syJcwdwG496+N0OXnenIhirTMLRDsMBllUcopou5JzXblmS9ITjzEWuM3mKO8LM9VwvqTjnq/YvsXtov9TlIARga6RwxslDqwlysmmACwhtUWggFMlFT8WYuQkGBx54uVIC2zrsC+dGU0eMqovSfsjKga3+5RznmpO1Pc1EhJQdw/X65ihNQ6B6umxDOWqpv/IgR63EWuMV/yTmL3B+6x3oqe5g1upTGrimve3R59Wu795dG8t6iO/EiP5K8bnqHHFGWmawEjkGw7lT2ykq/l8hjL238FcBSQfMuwi+3NqnK9po8vVcJjfagzSJ7nPpXloKAruMsFRxotBAaOJhXqqTFvx3TPs0NiHIc0xncbI6vMaZDLjVSuJqBHwMqNRQ3blu5dl6AO/66s0mrokj60mfsKKEyNbhnGgKfs0V1/rW0R510TFxztPwSRsHbZKvK4vAFAfpUZ4hw1fvxR4ThZHpvAR1HATTPA65+ef88w6FwIzXy9OE4xtoRNfJSMFRpd1pVEaUaRZDf0hSmWOAJycFp+qMDLrZnHub9nLzyblGPuKpG+aJyafPYp+Tt8qiN08P6UpN/HWJCM/GFaCuljugvMVgQO6E0c8BfXcDfEoj1UVdzRDD3IM0ACerAngB+/3NIyVZ7isK1LLzJoy9lsvivcGWLcKiozoAO3G59aPO07fIwqVXMCKkZF2InBt8rxxBpq2NF5dAg15mweBuqHXP2wjoOeefumGZcMR220oaOv8XGXqI5KQRdz53b9Qtr2U2HHT0F/xfqiFJiLDcfAkymh+nrp4S+q2m+FFQrxH96MLi4A7/MMl094Fyn0CqgtkygSDwsgdUbLsnaZqgfYQvx/JLAs/U
 87EcljJd
 2y1wwIeNu82SqSE01pFarMUEGuCtQy0PS+J5JqgXS7ALSdHq+8nH0uroBw3HurkmVx0yHde/6JgkZwA7I0uRzrFhV7JmaRwZyXUG85UEO5x4CQZYj4GdhMasU/6ytHy4FoEhDy2KOPq+isDCAMlYmxvZlD6tMgUxLekunI9NSrPnYxfzKDFU81tPVnepikHU1iMjhWXSf3clswie7iEB0rd5h7SBQjz7XdX1NlEYR0WzgiMOB1zxZWeRt0dk3wKVyOrfhcY86ZOibWcWnIPNoPCXOtqbEHeuIE+iADVmFeGPYDrozcEVFmanmT2dpj9PFT+rMzdzGU3Q/j1r39Y2sOUbNdztz3BoDVviyDPJ6gruvv+DdRAgwjpXAyoTLvDx+i0Ve1Q+azoEaR1ujGCRk0TPl4lR8Iov3aGSRtlxdaotTpGSHviDSaykGNUXmVBshbZHjHTbVmCT9J4uZG+di/gb8hXpttR9IPI2rtD46HRQ7qlbhUvdtsJ9F57YFVqTjktkNZph24yxLyNcXp9Fq9pF6hWl+fme6eZzrrepmqtffzKiEQbU95CK6r72spUe5MclW+NIJxL7bdMWnf2Xhh3fJJxOyIfMtMlQP7W+627XYt4qi/ZKRGIr7eN1pAIZl/s2iH98V+zMPGJWwPbIJbJJ8THPqAT66VBzm/EOGKE4PNg80fmpoL8/eco38gJo9FFOq2mnM275ySsCCJhgQTb9LgpFWpAGHcyEP+fhz4XqVSmiEtRIgO9pidKvfe49RvbmnyRLXsKLPFM54zIt1mh73+lziIDjVsT1QhnCLDeR/MzNiX+/v1hcYhEat90OYap5ap1fk8egqPW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/10 11:51), Sergey Senozhatsky wrote:
> Date: Tue, 10 Nov 2026 11:51:21 +0900
> From: Sergey Senozhatsky <senozhatsky@chromium.org>
> To: Yosry Ahmed <yosry@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,  Andrew Morton
>  <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>,  Yosry Ahmed
>  <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,  Brian
>  Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>,  Richard
>  Chang <richardycc@google.com>, linux-kernel@vger.kernel.org,
>  linux-block@vger.kernel.org,  linux-mm@kvack.org
> Subject: Re: [PATCH 5/7] zsmalloc: embed struct zs_handle into zram and
>  zswap entries
> Message-ID: <avKFc82JS4R9yU-N@google.com>
> 
> On (26/11/05 17:19), Yosry Ahmed wrote:
> [..]
> > >  Additionally, zs_malloc() does not return a dereferenceable pointer.
> > > -Instead, it returns an opaque handle (unsigned long) which encodes actual
> > > -location of the allocated object. The reason for this indirection is that
> > > +Instead, it stores the encoded location of the allocated object in the
> > > +provided ``struct zs_handle``. The reason for this indirection is that
> > 
> > Should we explicitly call out that zsmalloc will keep a back pointer to
> > the handle and update it asynchronously, so the owner shouldn't modify
> > it, and should keep it allocated until zs_free() (or rebind)?
> > 
> > Probably somewhere in the code comments too?
> 
> Yeah, perhaps.
> 
> > >  zsmalloc does not keep zspages permanently mapped since that would cause
> > >  issues on 32-bit systems where the VA region for kernel space mappings
> > >  is very small. So, using the allocated memory should be done through the
> > > diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
> > > index 693c9484b638..6c76fd10344e 100644
> > > --- a/include/linux/zsmalloc.h
> > > +++ b/include/linux/zsmalloc.h
> > > @@ -14,6 +14,7 @@
> > >  #ifndef _ZS_MALLOC_H_
> > >  #define _ZS_MALLOC_H_
> > >  
> > > +#include <linux/compiler.h>
> > >  #include <linux/types.h>
> > >  
> > >  struct zs_pool_stats {
> > > @@ -21,16 +22,39 @@ struct zs_pool_stats {
> > >  	atomic_long_t pages_compacted;
> > >  };
> > >  
> > > +/*
> > > + * zsmalloc writes object location into the handle and updates it when
> > > + * the object moves (compaction, page migration), so the handle must not
> > > + * be on the stack and must not be copied.  Use zs_rebind_handle() to
> > > + * move an object to another handle.
> > > + */
> > > +struct zs_handle {
> > > +	unsigned long __private obj;
> > > +} __aligned(sizeof(unsigned long));
> > 
> > Is alignment guaranteed even if this is embedded in a packed struct? I
> > wonder if we should have an explicit alignment check in
> > zs_malloc()/zs_store(), and probably rebind too?
> 
> I guess only run-time check will work.  I can add those.  I wonder
> if we actually need to worry about this, neither zram nor zswap use
> packed entries, but I think it's cheap enough to make sure in run-time.
> 
> > > +
> > > +static inline void zs_handle_init(struct zs_handle *handle)
> > > +{
> > > +	ACCESS_PRIVATE(handle, obj) = 0;
> > > +}
> > > +
> > > +static inline bool zs_handle_is_allocated(const struct zs_handle *handle)
> > > +{
> > > +	return READ_ONCE(ACCESS_PRIVATE(handle, obj)) != 0;
> > > +}
> > 
> > Can this ever give a false negative?
> 
> That's a very good question.
> 
> > I believe that's only possible with pfn=0, I don't know if this can be the
> > case on any architecture. Should we use something like OBJ_ALLOCATED_TAG?
> 
> Yeah, I don't know, I guess would be better to not rely on "pfn cannot be
> 0".  Let me look into this.

Look what I found:

--------------------------------------------------------------------------
commit 67296874eb1cc80317bf2a8fba22b494e21eb29b
Author: Olav Haugan <ohaugan@codeaurora.org>
Date:   Fri Nov 22 09:30:41 2013 -0800

    staging: zsmalloc: Ensure handle is never 0 on success
    
    zsmalloc encodes a handle using the pfn and an object
    index. On hardware platforms with physical memory starting
    at 0x0 the pfn can be 0. This causes the encoded handle to be
    0 and is incorrectly interpreted as an allocation failure.
    
    This issue affects all current and future SoCs with physical
    memory starting at 0x0. All MSM8974 SoCs which includes
    Google Nexus 5 devices are affected.
    
    To prevent this false error we ensure that the encoded handle
    will not be 0 when allocation succeeds.
    
    Signed-off-by: Olav Haugan <ohaugan@codeaurora.org>
    Cc: stable <stable@vger.kernel.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


 static void *obj_location_to_handle(struct page *page, unsigned long obj_idx)
 {
        unsigned long handle;
@@ -441,17 +446,21 @@ static void *obj_location_to_handle(struct page *page, unsigned long obj_idx)
        }
 
        handle = page_to_pfn(page) << OBJ_INDEX_BITS;
-       handle |= (obj_idx & OBJ_INDEX_MASK);
+       handle |= ((obj_idx + 1) & OBJ_INDEX_MASK);
 
        return (void *)handle;
 }

 static void obj_handle_to_location(unsigned long handle, struct page **page,
                                unsigned long *obj_idx)
 {
        *page = pfn_to_page(handle >> OBJ_INDEX_BITS);
-       *obj_idx = handle & OBJ_INDEX_MASK;
+       *obj_idx = (handle & OBJ_INDEX_MASK) - 1;
 }
--------------------------------------------------------------------------

I guess I'll do the same + 1 / -1 trick.

