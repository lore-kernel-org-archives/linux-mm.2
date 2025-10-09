Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16683CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 18:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626FF8E00A4; Thu,  9 Oct 2025 14:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FEEE8E0002; Thu,  9 Oct 2025 14:15:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515708E00A4; Thu,  9 Oct 2025 14:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F65E8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 14:15:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0868C0AE1
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:15:22 +0000 (UTC)
X-FDA: 83979378084.10.76EB749
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id 13DF240019
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:15:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dm3qndJD;
	spf=pass (imf07.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760033721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vn4n4RSlfropTQ5buc9FvEgi9hxnZliFrOPmLk0O+rg=;
	b=gkS4ubk6C2agb5FlynxB4CePrCIjcAJewr6Zi3Y5tENSGmVFoGfK8zDZ/twi3q7uukeemd
	h8FNC5jqBo4SErIJgEWQK7/ue5HJ5Dtm9AXxSMKi5h1cq04aWl9c6t01GnKMgtAmcoU2Pp
	Yy0xqB3k/y5uWY9m0Gfj0IQ0Qc7j1Oo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dm3qndJD;
	spf=pass (imf07.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760033721; a=rsa-sha256;
	cv=none;
	b=SE75etBYJ4PtdTqN5e/6d8HNLdn/3qTdfS4Zj1VJc43AnmwEDdn0bKwLFl97nZIkWQANOk
	IjsWcrh8c313uE9YI0MxSdwyJ1E0KvRqkC/SQTqtA1lj5sz8NAIymm9smPmRQlsALD790L
	7NOsNmsza3nTovLANwGcuWnBXk2GEys=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2680ee37b21so2230295ad.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 11:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760033720; x=1760638520; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vn4n4RSlfropTQ5buc9FvEgi9hxnZliFrOPmLk0O+rg=;
        b=dm3qndJD98zCwmDR9oLSytHYB0jgY9u02GG9/7GRh/wJLWyX97WjsYuREzVM7p3FUu
         Yp1eQoJ7dKNajJcQDRxpefJpp7DS9SYQROQ9rZWwIFKw9tq4w8OUyaMbZqF3Cn8x1+6B
         KBbt2HXIaL/0GUxor8bmhODjfNs4hDR5fRU9hPmuO8eMCUl9kEaNEnPwqEDakAtR0W6F
         KEB1z1sah7V0Z+cERxoNU1lDFmUOzcdm83nbrGSKHrf0n8PWil+AGfcz4eUdI9CKPM0z
         3ap1oP32UdvhawU+WbvD8P+1NYvC3ZjH2RSICuQk6zH8IMn/F74AOroi+d7wIsiDAmBt
         VJzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760033720; x=1760638520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vn4n4RSlfropTQ5buc9FvEgi9hxnZliFrOPmLk0O+rg=;
        b=u6Z14wdzcb1vy7xhDLZkItS1xsmJ/fEv4n12cf3SRSHgn60vt+DZBhIq+vM8gQdSVV
         hin4VDxUW6ySqq7Al9Dn2iJps66GOzxyvj8CJjIMBMlpaSQ6IrYbmpyi0IbkYlRBA5Xe
         6lWFsQ3E+ZHYVw9ldd1Xtur9BnuwBv59VupDDqnrP2sVLlW3pwNe13+5sHCx37Gb62FR
         msPLdmjh3Wddyx1AFvKjlVKWFqi0ViL9MIY4dJJ5EYiyLtnHbCq+rapxujBxB/7qfdgm
         5At4wJzJYaT8PIr3JLEuvCfJx6PJwh//o6n0lqHMvDMgRorYQ4YkzkbOKRvIC75l1mq/
         EdSA==
X-Forwarded-Encrypted: i=1; AJvYcCWmTdA+yPzNEWYaIUd+7ARVg6JZgXG+YdVcu1ow5qpFKhv9ot8t8+mPneeUsMIeSBo7MVUSrmU4DA==@kvack.org
X-Gm-Message-State: AOJu0Yydo4mtQOoq0afMxMPsBetLtnYBWPla+w4SroOmFxCoaCe+klnc
	TyAfyswE0l8croAy1CWtartJk5J55e6G6p8D5t1XA2nTj7pQpzRc8AyF30N2VoVhPFo9fXod9pC
	/TwMGclkeaNmYP4yfMlYMGgOgtA6iGYSUPMmr
X-Gm-Gg: ASbGncv3VNIPnDA/bVJqisqa8dF8QSZASLJAUEmv3Jr/xtst43fSGlXi/2N58IDtA39
	aM0qd8QwazDd2/9ANK4E1yq7utWeERCJE0JVmCatQlzy4WH80zSgCoA69h0WCzKRvS9sLAFxM9z
	tPEcOy3ofsW0OHjMcNmV7Fd4NCLgrTmqecoE33NYw+bbzFocmgtRXM0xOGvR5CKWWTXPFuQMlRa
	AXGJ6LmwxjFR4fk9FW1zoKohxsvOLUj6B8/4ivmT/ZRpi78YK+nP9hjHgYOxc/2IytHS8VUEzP3
	/m6C7NU3Xm66itXldedX14mk1AdzQGW1VU300HKXF0lj59SN6A==
X-Google-Smtp-Source: AGHT+IFc9KYDo0vVba2RUD8DAtI69bgAyM4PDwpagg31YnO4T9LE79wjEuU97MRUl6V1rW7V/9/UNL+E0+rlTC6BKDA=
X-Received: by 2002:a17:902:c94c:b0:28e:aacb:e6f7 with SMTP id
 d9443c01a7336-2902723ca5dmr61015185ad.3.1760033719751; Thu, 09 Oct 2025
 11:15:19 -0700 (PDT)
MIME-Version: 1.0
References: <202510100127.yuqhg8uo-lkp@intel.com> <20251009110555.29a67af19f5cc4d40e66713c@linux-foundation.org>
 <CANiq72kKSz=UK+O4tnV0Kmw_HmJhJJ+KNZnUBWtOWqanrG+7Vg@mail.gmail.com>
In-Reply-To: <CANiq72kKSz=UK+O4tnV0Kmw_HmJhJJ+KNZnUBWtOWqanrG+7Vg@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 9 Oct 2025 20:15:06 +0200
X-Gm-Features: AS18NWBY_LEofIxL13seTuWRCLS4mtbWJ5eZPeFPnSTCgp-cv4muXJzm_9R95HE
Message-ID: <CANiq72kTPjukgmAxDfLg2s4JHdaKaw=bY4DLVjTr7-9bqv5D3A@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 36/102] error[E0425]: cannot find value `VM_READ`
 in crate `bindings`
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, Jakub Acs <acsjakub@amazon.de>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, Miguel Ojeda <ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: x41qyac4cy4ehji34ekjgci45uhnocnb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 13DF240019
X-HE-Tag: 1760033720-244037
X-HE-Meta: U2FsdGVkX1/GMv66z87IwJbXtgvmjPHVxrqKSDLOiUvjhV+Hg6BJ83rW/nnHYTrDvT3RwQE06kPxTAa1oxjkXPbkKGDnxoeRCqlY2T5caG5YKC757A15CwCA3vzIWOXEF1986MDzHoEuZoIn4Lo9Pq3bln5AvROOjt4VUU7strb3QsFKaRepFLr7wSsa6H1Y8+bHOV05KkoftB70DeyGduY/+sBATjauNDvr6mgwt0cO//KD01eKO3gOaPXrVFSyT5cJJDqN12468rn7w9jwOfeR+CmyB6MXMj0zGTjQgcnVA54ishyY1EUGPZLdDSkAzLISBAVF5/7nO2wQbH7kLAY99csBcehGvyYzzrCGpA1+2XvUUAjDEfoTNLh2/CQK6ylvcAIhiCEVQuRqUvnPYiOGHoEbrgBZuj+HJxTY37idy4fjpTIlrDZeNl/f9B4XvLBvwC8qin2hrQnAR271r+cDCPIA7XTBD7U/HwALtqPMuL359gGV2oBkiAUiYBFK9sUlinZcPRS5Dt/RPnFFSzQvse6v3kN7rlJy+Z8WkMhSLx9txZKQKODD5PDhSjZMdXiPpUTd5K81FGUszqpPphhv0ZWl6+kz6O2Lg8cDJ+DRcbNBj83tI62DO8S4l9A4Znbmg98uvpmmwupw9+1eaQMrkmF/tH69Z+uEZ+Fu/6mZoJRYCfQyMPWx1xHkh9K3A42dW9+adB9TnSyb4Z6l3KA9e186ae2VWKDqBzgXFK8vfY+isgLGdGC5Z85wqDnweLae+FJPj/cWWuC76oqIaWHYC4eHH3suKKCB5tsO55veDacrxw9mB2bYw/z21P5cRZ9LlZ7fjg4mSUZ5523uYxqN8/Qww6RuYjL6ZPGlhTBjv5YiCd+VkI8u593MBMJVLOZT6lB35OxfAkdNwNz4TTGvKZzSQcqjUV+vEPCR1gnZ7bzmCOvhirvk21Epmf4ciPCeyDnATDfB+HKUXQD
 h05bh9B1
 SCdE0BrV+DkXNFrNK46NCbrP3IvhlInh0H/ovnxSg9kvPb5gFdwg4GLHp57NkKF5faNj90Msz0LnqBcrJ0akRK5w5DgdBlyXyfT36pjwFbaI9yLK35QsZ/7OhrG1OQwbOGVVN/+owlWqpMlhHUyvrspcNLb+meSWOc/uqBvwX/FuaG4VXPi0Dl+jZ3o5mOYJAa496A7RdRCZAdxffkjZeko/s2lhhMgjdYiIpKzA2z0NPGFsCZAx6nFvP5e07cCU/0CqwJl/kFapm6w3YkDAXC5rWuIt1QKOD6KMIXEWkzjgWXGwxq5hzh7Zar+UKb1rmpLPHkDG0K2cAYyC1SoOi83X/+uXcuErBcci5RDEsrGA/FYjTKKPTAtFJa7dCXwp17WvoEVl4ihfIHiybLqAJqQwVBdzB64cn+2Lw+5gGFHRgMUqMRYOpWEfQaUk7Cnwv/3aUcJQLtNtVMkeGorU6REV+bcR4ynBUgVbX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 8:14=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> We can either define helper constants in
> `rust/bindings/bindings_helper.h` for the ones that the Rust side is
> already using (like last time) or use `enum`s on the C header.
>
> If you have it in a branch, I can prepare a quick diff for you to fold.

Should I test on
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new?

Cheers,
Miguel

