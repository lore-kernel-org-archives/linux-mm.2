Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B4E2C98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 09:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4C7D6B0088; Sat, 26 Sep 2026 05:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFE7E6B008A; Sat, 26 Sep 2026 05:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ECD16B008C; Sat, 26 Sep 2026 05:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73E7B6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:05:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6BE61C3751
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:05:52 +0000 (UTC)
X-FDA: 85255330944.02.B12D524
Received: from mail-ej2-f41.google.com (mail-ej2-f41.google.com [74.125.228.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0954F40002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:05:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FxfMuLdu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.169 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790413551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aeAHyC+9N6Co7JC4GWq1L6y5uc5GROrj5CA6iuWEnjE=;
	b=AZ9hN2zikDOkPjxPqmQno04t00VMhanaTNWAgBCb33MYPma30Z0a5P/h5ZN5I6co4NyLC9
	CYipLXfOj+z/bkRBOrT0Aqd12dXArGP5mJODV9n1LaWAqiw10MaivionS635y6lSVEXFXx
	CMQBRm8MS1kgoQWqs/tUuSVbc/FrFZw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FxfMuLdu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.169 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790413551;
	b=HGRC9LkbJhyWrPz0eix3GX8kDYk6chF/8w5hmrEv9L+DmzxuJOBHijm1TSp6uzK4YXp/+j
	jBeL8JwdO72+ctAaNnOkq2T8BCQtRhmGIMhN3YynpU15wj34/hrUN0B+msWfkeQ1aR0UH4
	DbigqLy0xN1sWXdmT5+RCv3o/LnvcBQ=
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c254fa663bfso253906466b.1
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 02:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790413549; x=1791018349; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aeAHyC+9N6Co7JC4GWq1L6y5uc5GROrj5CA6iuWEnjE=;
        b=FxfMuLduWknxEZHPiCgkYnRlVcxDdy3v3UhNzNF2rvkFlkBPama5lEDvliwjbiTl8f
         IOnEGG4mCo+gDWN7kFSSaAcmcZ0jy6IcAMO7KFgZFZN8lBXeFg90FTV+8/CByPLk4awo
         TkKZeJidrDfCb5lViJzvvOWXQ5D1Hmvcna+QxkB9OEsiOq756qleX3vGlbzx2fwEyHvD
         9mr+ZPXBE85jolye0G7xXiBMJsfBp1jDYFn32eDWH/ha/iud9FAGEfAhO2CkvMwuSNK0
         y1slZZepEzw2F5atzPNnHhwmu/d0YqdcKFgT3B92nBIzipRL7m5U4Y3HadXRjgg/suWH
         /9qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790413549; x=1791018349;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aeAHyC+9N6Co7JC4GWq1L6y5uc5GROrj5CA6iuWEnjE=;
        b=uAKCMnNfxHon8tcszTHXOx7Hmn3vceRPZ/zx2VK0RL5TkyE0dLmTPZy/yq6wgvRHb3
         7k+jzyeNmctIE6TPGCezRK0F2CHEznNvNDYpUYVHVAJBG13IxJ3zCTGXRZ7ox+XOldVP
         peH4vfqEIfr+MsOOwboXljcF1jw8ZYRpNRSe5NmUegLSnzF/an7e6wiS11ahRUMgyhWC
         7YlkselKNSwP17Pv15GuhC5pbkQu/XolxU6rHZZOrkP/m+TppuAaiEj0HmSu1FfP/4aM
         oKo41Ap+Oh8VVu6qGvdBPnPdYycxh17w347z5/jON/j3Tcv/+KNlQY2r85N2vd67/bVC
         r99A==
X-Forwarded-Encrypted: i=1; AKwUvByPc4+aMvuC43ox69Rq15nmtXSp7c3J2Yoz2dRtPRpHzgzfGULLfJN1jE3CEwhcRCOypOD2F8Wi7Q==@kvack.org
X-Gm-Message-State: AFuF++nZdCsZpjaM0n+exVSKRso3+gvexV43QF2qrd7o4QfwA2LbJ2ma
	tLwUNgqbsstJRvC8R3OUU6KUzM+21RO/vTCp6XaNQBKCwZqmX2PjuyG4
X-Gm-Gg: AYBFou18+CDvJCxcomCNnDlQ1+l2Bb3CePrJgRCyFeiEKstfZcQ4qjygYw/kI1I3Qml
	QAAxC8cuAabJAAN0MsReo6OQZfaM1Z3v0DTcAXfADwjI+x9UHJB6z0+pufBrsGnhcBQz3k/kv0W
	w3M4s27kVcWfyJX2MvIQEbVCDP2vbW0N0rg3QitfjGMHp/3YMgIVt8I0ZPdKTfnHV+GZNpNhfBa
	dNvzB0/QmaMsN/4tLT2rtfJCYATuVonieVSUFoPBx0KqFCMRcry2Zq+Mu1bjXcK1ne7n7xdvDNg
	cP59s1dNvO7bWrgCjAiuI0n8dg42XuSyv/4JrLDMsnyMdsczS5GBmVT0aWReBeVppdwEqLpU58t
	gf/yTe0bXnMuhsvzuUaNQ68WjyZeY1yTytkDjnBNcQJ/msEROnNNaq8EEyMHsdyIJfSX9SN1tts
	XegIUQC5GwKT7kM8jso0sgabB4s20aPwpZs1g=
X-Received: by 2002:a17:907:da1:b0:c2d:bc33:7be3 with SMTP id a640c23a62f3a-c2dbc33c16dmr67023066b.47.1790413549220;
        Sat, 26 Sep 2026 02:05:49 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2ae7357cf3sm224612366b.17.2026.09.26.02.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 02:05:48 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Sat, 26 Sep 2026 11:05:45 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Palla Raghunath <raghunathpalla.0209@gmail.com>,
	linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
	Brigham Campbell <me@brighamcampbell.com>,
	linux-kernel-mentees@lists.linux.dev,
	syzbot+442828bb356b10813a47@syzkaller.appspotmail.com,
	Uladzislau Rezki <urezki@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/vmalloc: do not warn on -ENOMEM from va_clip() in
 pcpu_get_vm_areas()
Message-ID: <areK6Z34m3gP7qe5@milan>
References: <20260925205450.21262-1-raghunathpalla.0209@gmail.com>
 <20260925151500.75fcb001ef8cd7f4842e62aa@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925151500.75fcb001ef8cd7f4842e62aa@linux-foundation.org>
X-Stat-Signature: goa48ptqrs7ju8gx7qbm1o67q3tbf843
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0954F40002
X-HE-Tag: 1790413550-232392
X-HE-Meta: U2FsdGVkX1/O3u8lg27nzErrqCI29mdVE6jiNdtroOW3R4SaE2jG1R+gxNEpsOu/9P1ALxdxYkgH2oSbOpaqdTx8OlAhx4eIdwNtue0+GXdIP/JpMDTK1RKAkypbiQaRkOElaUgjG00CvKiGWXsttfbjp8ajz5OSohM0a4MEFsqQ38YRNEV2p9wKG/UDLBwWN4EEQI/oOuujJHlkOnXZcAVJSCQUqOLwoGmTlINiEEYxQCdpy3IYr3EB7ufROa5pKld2SaiMf8SZex0tqdHryxE08EZaadBT7p/g5sM2RS7nGLn9FUIp6q6g8UA3gmwDOg1k5vPEJXuwZnD9kgtWbvTeumWtESPIscARpXzIAPuZe99hfwST2axz40PqVR/72PhM6z2f58WDjGcLKua3fz9hnepPgIxXd33fs7RbDUx4h8eJjQyO+6XAmKQVkUTOVgtWbKI5dJlbUua3+0dSZZRTX2926i4hfzNFJkY0X/crSLDPcJ7CjPjPFK0fkC73SBXTufVnSdWT2dlD5vD+SB0V3yh/lnEoFZGV8YnbeFSO+OSoJ0CfA1qvP8044vnqEpvDBFxtCgcCEZ3MtQyvPKvIdWZjCUsSy3GtFssUXTBElj0aTOigl4wAIA0/uLVuYJvumQ9HsUFc49gbygQil2a9oyaXQS878a1/a+38Eg/p1ra7rDuG3URfocwlg0DUSg99WLN+rFLacNyz6H2nikManZ1G1gJOKqVVGHH0VDQPz2fJd2KGZ6k7N3irum4rQ1KN8eHXRwx6tAb2TpZpAe6sz3jJESfxIy3JDTWZLZNinqYnI/LG45QKpLVA+tjb8fAeNeFSiPzyhGsId6uYW2tV1mPas6ur3yWNa10mPHKZNaEpe4xsy3jI1ON1iB3SMrtMGvkXdWDvscakkzOaeMExJjL8zAGe6XXQREcYy7Yw4M0JOJCLd0zDNIWA0v/JFtH5abR071GPUYu5bgD
 9rFhpH5E
 4ZO/CkTzswbGcE5M1B4syxTLhr+7Mpt4IFR622e1UiDrLL5QNpXOWeuF6nd4iyDCxPpzODfF4WKcI+te+t2qWvYxEzR/x2d0NfeDUkyLaVFeVIN8UOLKsCGIVN+Owqdvs+U/mHpYiRyQjpyGfPxaoxITfZiylhg9uCZw0XSFttwZycmGglBi61Frk3+s/c+RgP81aFOWle5tG9xArFgdZCrFnj8rSwp55XMagL1/VH1Nmp2Q//2Phk3czbtvnH8qVD+BTgY8mIx8vndQz7rJwPt4nsZxo7OH0LnywfMaEvYXR7IwEWNdbEivuGB8UQFj5md5/XxoBzIrEZALRA+it3jYmzhyx+Py0fQm9Ppz55RQ+mXl9r0/rEVC0GwwdZUMlhGmBtNFgCHDFC6g9ZhqcFttA0M8N5cUa98Ft5j5YSfWmiOhRxvJ8T4GjP6vFX4Thrl5sS+BfCEJk9vmgO/JAsoBuN2fxqFeMpF/zi9Fg8Juyn71QlrFQauqSAjnZ1a/GHnWG9BA/qufHD4Hu85JbThi/KXDXelYwf1hYbVvOW+rG59pSMOeSg09/lm6ySxcqhCXmO6Xv9FuSGItkIxLTz1bKV9OThSBbuMrcI3qdbcnYNMsiVdahtSdUJrR/hsMdVL6lQ2hxuvtpHuwp6sy99AnjH5/dJ8vsVbzcWCiRJpaTAp5p4vTt+nP64/8VQVAz4BR897roXh0DDzVQi2M4G1MsxrnfU+dv+xEte8pGpHjx1LCJsvNLvTj//d0SQeWakN4k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 03:15:00PM -0700, Andrew Morton wrote:
> On Fri, 25 Sep 2026 21:54:49 +0100 Palla Raghunath <raghunathpalla.0209@gmail.com> wrote:
> 
> > When pcpu_get_vm_areas() has to split a free vmap_area in the middle
> > (NE_FIT_TYPE), va_clip() needs an extra vmap_area object. It takes the
> > per-cpu ne_fit_preload_node if one is there, and otherwise falls back
> > to kmem_cache_alloc(GFP_NOWAIT), which may fail and return -ENOMEM.
> > pcpu_get_vm_areas() never preloads, and a single call can do more than
> > one such split: on a NUMA system it places one area per node group, so
> > the first split consumes the preloaded object and the next one depends
> > on the GFP_NOWAIT allocation.
> > 
> > That failure is expected and already handled: the recovery path returns
> > the areas clipped so far to the free tree, purges lazily freed areas and
> > retries. But the error is checked with WARN_ON_ONCE(), so a transient
> > allocation failure under memory pressure or fault injection triggers a
> > kernel warning, and a panic with panic_on_warn. syzbot hit this on a
> > two-node VM while creating a per-cpu BPF array map.
> > 
> > Keep the WARN_ON_ONCE() for errors other than -ENOMEM, which do indicate
> > a bug, and take the recovery path either way. This matches what commit
> > b9183788a2de ("mm/vmalloc: do not warn on -ENOMEM from va_alloc()") did
> > for the other va_clip() caller.
> > 
> > Fixes: 1b23ff80b399 ("mm/vmalloc: invoke classify_va_fit_type() in adjust_va_to_fit_type()")
> > Reported-by: syzbot+442828bb356b10813a47@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=442828bb356b10813a47
> 
> I assume sysbot hit this via fault injection.    The report doesn't make this
> info easily available.  Or maybe it wasn't fault injection.
> 
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -5107,9 +5107,14 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
> >  
> >  		ret = va_clip(&free_vmap_area_root,
> >  			&free_vmap_area_list, va, start, size);
> > -		if (WARN_ON_ONCE(unlikely(ret)))
> > -			/* It is a BUG(), but trigger recovery instead. */
> > +		if (unlikely(ret)) {
> > +			/*
> > +			 * -ENOMEM from the GFP_NOWAIT fallback is expected.
> > +			 * Anything else is a BUG(), but trigger recovery instead.
> > +			 */
> > +			WARN_ON_ONCE(ret != -ENOMEM);
> 
> Look good.
> 
> The WARN_ON_ONCE() is potentially redundant.  We could make va_clip()
> remove __GFP_NOWARN from its kmem_cache_alloc() and let the page
> allocator do the warn for us.  Doesn't matter.
> 
The patch looks good to me also:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

