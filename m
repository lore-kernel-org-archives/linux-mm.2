Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB02CD484A
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 13:11:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39AE46B00B2; Mon, 11 May 2026 09:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 371AC6B00B4; Mon, 11 May 2026 09:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 287F76B00B5; Mon, 11 May 2026 09:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 168336B00B2
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:11:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D56F41A0115
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:11:47 +0000 (UTC)
X-FDA: 84755176254.24.5A228D0
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id EC7F14000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:11:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QW5WfecY;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778505106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DwmcDFyZkGZV4b74fZllhwzC8fV4uJFXqCHKJqBwYe0=;
	b=xHEIqTZdBXXkj28XDv7W8toclDDYhOuXNYdfId9clIrmjPYNMrhoaiqlhpwMChbNfOstRu
	Widr7Wysoj4h+mMOxFVcu9aqe36vlFl8mwd2wrxq7bNICWWBxzAoBTOk88mRzc2W4ymRJO
	r8ufasIm7WXlaPirKTAzT7E5R4Y3MM0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778505106; a=rsa-sha256;
	cv=none;
	b=TwrfaA63Yem7R4NcohUxyyoAnIVl7xPysLpALzlHCBZlpoHBNHMgPMFlAfMlHxbRKI1vgf
	xjiWMxyqWxsmdsxNf91D7NJ7S9XlPa/FD35c+r/tr1odtO14zDBHWilrRL2wgeB4phfTeO
	VTpWOzurtGwoRs+qoQRE8oObasGkOfc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QW5WfecY;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7bd5c773ef3so42246317b3.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 06:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778505105; x=1779109905; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DwmcDFyZkGZV4b74fZllhwzC8fV4uJFXqCHKJqBwYe0=;
        b=QW5WfecYKUMaJ/pF4+WKZrlOogLSDNB1UZP40PPGZ1BBz9/fPUr4JJklNMAIVGpuYa
         mfegiYFV61ZbGAEyqfMqiAVAnGD1JB/gyAiRfsNYlc/04sqSh3RyBVD/bf6rb2iRsCAK
         Fer+Pjc7wDV7g5yvnjM7nxa/no2guNgZ9IBM425Ffgx1YPspdDT6Eg/pfB1dAWwnS51s
         Gz8XPoP5yGVMQ+NwfAQx3AfVVmd4kSGL0Smx4kyNDeJO34qKg6zyBfDkG+z6gryyIxT9
         H6hWLXg3CHZ7weiqQpbTL2RlyfTr0QU+iHbB6eoyiZuU232xA7WIcIWn3KK3YWUY53dS
         ZGeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778505105; x=1779109905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DwmcDFyZkGZV4b74fZllhwzC8fV4uJFXqCHKJqBwYe0=;
        b=UE7Azf0f1j8HHxiPAtNBLV67GCbHEPb6I1bI5PGuWeJ423LFYSNbzD5moIrhhi52bw
         C3+pvQqm5IJUSgWvpsQLKmMf7rWpyGFdTc5kZ1OZwAVqHdCXuakeOJiLfYPp4/4G4zzM
         AI1YCUL49exwreZUbqXRF30/23prRVMRsFZJs2TE3Z3xfji+lrdkepBd9QtOvnc6V9dc
         +oiS6gmZkHEwAlJNgvNTGYMAsNafpHNNeifDESLQiEBRLQtTyE6GMuvDrUBu+BtUug2z
         1jaf9r3T8xoNPuDVyTVGTLglLaUhzhBR0cJsa3Imqr5vB2zOYXi2I6yGIVSQSP6e5H4/
         6w6w==
X-Forwarded-Encrypted: i=1; AFNElJ/URA13LyfeQUM9zR/gyui4NPgHCyzACdrnREphh7AKv7UYeMHb3TKZHinX/D+JFjrln3QeJ+msJQ==@kvack.org
X-Gm-Message-State: AOJu0YxqEQVAob3Pfn7K60w0cd+2hVlNGw2TJDymiqGcqJnM6SwxKBzs
	dJkVYW1jlgV/BkdXl0lewts79D4IS3vmKJsglcWdLwVDanEh9OBclJrXWEqUGM1Lj/c=
X-Gm-Gg: Acq92OHewdGgS8uQGOMoM5ZIqiMjcrd56d8Lsa/Muv82nI8Cub8N6uZBOnGgGIzEs7F
	BeSH8xe1rm4PLcwIye04krwniNF+3UbtAJjDEYbWhcXj5wwNVfl2YXsFSGGSi7ZGxsNsVDtmCu5
	ckiNTVrgJVS47/jWR/1IoNot80i5FSVypi+ZJT5G4HwQPGIa0Sk8ILjnojLIFCBUM4kP45Y1HfH
	h+/yJdzKJKA8ojhfrmtW4Q1ZqU6t6yiFT/c3CO7UO3jTWI4KPKAyNJdrGYoQeKQ1DxdRV8yGuKM
	Dm/DeygGnCjKgG15U2lokUQQfkRGeQvNfFf7q7WuZlrclOMOMCGPk41LlY0mSM9Cun/BNSgdNqn
	qIUlJqEezuqy5528wqPdCpClJbWIEfVThSTvIRWq++1jPCB7IzHN8xSXXSUDY0Fc2hzKvvPfKZU
	VrY6iG2JkXBrtOFImnfL6vcu5RWj+SXDxbj6endfk/UAAMW3sWmgzO1/fsQ4iczB6vH0g+SmfFw
	99vWWz50m6DxzaPSianReSgFa2yygtzPlJorUu9kCc=
X-Received: by 2002:a05:690c:dd3:b0:7ba:d5fb:b543 with SMTP id 00721157ae682-7bdf5dcc7b4mr239220107b3.13.1778505104887;
        Mon, 11 May 2026 06:11:44 -0700 (PDT)
Received: from google.com (138.200.150.34.bc.googleusercontent.com. [34.150.200.138])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd6688c99bsm149750087b3.45.2026.05.11.06.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 06:11:44 -0700 (PDT)
Date: Mon, 11 May 2026 09:11:43 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, sourabhjain@linux.ibm.com, 
	jbouron@amazon.com, akpm@linux-foundation.org, linux-mm@kvack.org, bhe@redhat.com, 
	linux-kernel@vger.kernel.org, dan.carpenter@linaro.org, rafael.j.wysocki@intel.com, 
	piliu@redhat.com, kexec@lists.infradead.org, pratyush@kernel.org, graf@amazon.com, 
	changyuanl@google.com, mario.limonciello@amd.com
Subject: Re: [PATCH v2 1/3] kho: skip KHO data for context-preserving kexec
Message-ID: <agHU6q3N2URn8Sei@google.com>
References: <20260506182039.2623553-5-pasha.tatashin@soleen.com>
 <20260506182039.2623553-6-pasha.tatashin@soleen.com>
 <agGxkHPx7W7P5AUS@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agGxkHPx7W7P5AUS@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EC7F14000F
X-Rspam-User: 
X-Stat-Signature: rpsstgaqqunn81q5da11phukdgmgwcht
X-HE-Tag: 1778505105-485832
X-HE-Meta: U2FsdGVkX1+f57sFpvE09BJidL6+EOqGB2wHsW30bO8ArsI8iu2mbPCtZ54slH27gThJTNIxxzZw/Vu9eZYL5Bs94TGcpUKnZsO+7Gm5rVMKURbBp1h7KUrOnqpqe8Z8h9cGm5oXh6ptUYH6AeuRgAndcEfsdQRazYJqzbevL61Jy/rQ8hOtBE7oKt6VT1TTI5zGwjN70p+eA59F7oUa3pkCLCOTt21CzCx5vVaKEdPvCGwVdVnZibbrAGe8PDAtKkntnFxD8kEGJLwcnksgP/A/9ou4qOwsZ86vol6uw4Xd/W9rOBL9jpeqErMERxgHxX6Kx002B6lsOBmeqw4cY0MPWNOUMLda6ssvRJ6UvUWl9mgRGBI4pihWDCz072jAX+1F6mKeO7LfzFTTdIZlDYNUaSOW/Z9AFjiT2eCoXpaxge/Yh7J1KNVpc4kwAlcup1Vw10DtiG8DS9PuKeETDtyCa8mhB6LXMRej6VroU2vjqXfwMUt0s0jKrUWY5x24LccBn1fAWl8K1wod5T4XeUTJlKoym7LGi3XJGiL6+UxYC/fwmIKN/pF1F4TTPnqPEPvB8on1jZLgOBXT55/4Tw9VH4VeVuGluTRr7ByosuPDnnt+y6qdLTguvi3eK2B9c1wnltslfG592n+pzWPnXn5dt+dnQV87mjL6aQ+1xwfNFOZevSNRPUimt3ECdeNwgCVUj+JpZiRnSTcKIjQ5kbJe8DhMdq3/LqHVseRwtHbavCU55Md0ZQcG35/icH6j8bEkS3MrY2bbp4omZc2uJBI3Vr1TpT/uGKLCrY9JZz1krWtsUFmeEwLpSCiEX+/EpiBHod+KoS/FOZ0hH43S8I85Y4S3lakzgjlk1lbNyWg+5vXauru7NDo/hVaCfrLJYR3bu1ogJ2nne+onlqP3i37wK0Se8vSzb4NMSusHzAus8W5zBIdvUd0NbqAW/5BpEEgt+zA166ujuct1tO+
 1QWQ0y+f
 bSaZKPulxJDqAvIOjmRUF3vceBeRjgbszOnxYHd4EcHTODuW21eJiMpUeU7Xaosk2M4YNORByCOJ+p+jmRUTnyeYT5KFOMV7RuoO0GO89g0Gipy6HCXTq/tftO7Ud1eAqWuf7+3R5ZY1TR66hvbkH5/5jNuTdKpca5WXNroBaOE3xXvGUKabisxC4auBP5Ex4rHIIRjvgY2nMBzgOAcOpwT74R0nftFVq2ImHtNPAGUSXPyzw/iHcSzj53G5VeilBY2mGIOz6p060067PsgdZF5sBjz9NUitwulqWGOnTnw5mq1VHYyQfWFdMXaPA4MKjiZjnu0DAqjZXtPxHjtTJ59SmLY/vHyA0nYj9l+EIG4rRNNuzggOuPjt4IxZh9IhtrxGujVJH57BGvYD0qB6GcZSVez5wXrgL2hP6yKLnJjQPzouf283OdyWr7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-11 13:38, Mike Rapoport wrote:
> On Wed, May 06, 2026 at 02:20:41PM -0400, Pasha Tatashin wrote:
> > A preserve_context kexec returns to the current kernel, which means the
> > 2nd kernel does not use KHO data (and their memory spaces don't
> > overlap). Passing KHO data to the 2nd kernel via setup_data or
> > devicetree is unnecessary.
> > 
> > Add a check in kho_fill_kimage() and return early if preserve_context is
> > set, to avoid passing KHO state during context-preserving kexecs.
> > 
> > Fixes: 3bdecc3c93f9 ("kexec: add KHO support to kexec file loads")
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > index 4fde8325c49f..2eec2a169c83 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -1702,7 +1702,8 @@ int kho_fill_kimage(struct kimage *image)
> >  	int err = 0;
> >  	struct kexec_buf scratch;
> >  
> > -	if (!kho_enable || image->type == KEXEC_TYPE_CRASH)
> > +	if (!kho_enable || image->type == KEXEC_TYPE_CRASH ||
> > +	    image->preserve_context)
> >  		return 0;
> 
> Sashiko says it's unnecessary:
> 
> https://sashiko.dev/#/patchset/20260506182039.2623553-5-pasha.tatashin@soleen.com
> 
> I tend to agree :)

Awesome catch by Sashiko, I will drop this patch.

Pasha

>   
> >  	image->kho.fdt = virt_to_phys(kho_out.fdt);
> > -- 
> > 2.54.0.545.g6539524ca2-goog
> > 
> 
> -- 
> Sincerely yours,
> Mike.

