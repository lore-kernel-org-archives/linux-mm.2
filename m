Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04E48C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 10:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 190A76B009E; Thu, 17 Sep 2026 06:19:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1414A6B009F; Thu, 17 Sep 2026 06:19:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 009AB6B00A0; Thu, 17 Sep 2026 06:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD40B6B009E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:19:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 103601A02D0
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:19:35 +0000 (UTC)
X-FDA: 85222857510.07.CA5CCC0
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3D70D1A0002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:19:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nj9jKCgq;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789640373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lIbDzBYUic7atO3Tl8OUtyUr5JA3iHCUK5rlYQyhAyI=;
	b=uabVKhZ47hnbzGGHm5g05SVrsJU5l9OMtxa6FuZYIMF7M2MEFW9ZdN1ORkrALVV2WiUV76
	vxrmKfyLSYoa6MBLrLaQflT65W6d5YIyGk3GLLYGUT+Z1Sv5bRD6bicMczHftMjFNdvmrX
	aeicmhlnVU7PCNmxqYXDDOh5IyM4BF8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789640373;
	b=7QF8lCmXwE1xQ1RVZg/36o1G66u0lv6UAAmwoSqgr9lPBKGpCqQ/V/xPBAg8EQJHP8pfgi
	uEn2xZgshYfME36U/tQcwsmfAkA4hZPEsVbjaxApswHwNQ9j+8kiSMBeqihVcjoRO8Mv/n
	qTPXersi+6wqDMRGf32PQQg5R2gQhiI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nj9jKCgq;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccfd61ecaso6092825e9.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 03:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789640372; x=1790245172; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lIbDzBYUic7atO3Tl8OUtyUr5JA3iHCUK5rlYQyhAyI=;
        b=nj9jKCgqQ4KaWC0/gNIjVXCUYKMq6NWkK0jHg63kkle8OY5cA/8doHzHRXJ2adSd+C
         s1wxjCqHKnOewOFI39hy5x1+fEcgtC5ja64XGYu8DS2sBqwHi00b6fDshN8VjZnNScK9
         Uocw2DPFVpElHYILMetUOzfNU2guBCYQaV4OCnuhsbbgxIrAAsjxF/9n1pf40TZF863W
         JSK/KONUYXXJAJsyurvgKrFa45Z1tZCdUcyUAhM1EO/hpLqeSOdihReckj1yNJfSb9N6
         G+WlaEMV801REhLVGndEXU+LzpPC+/kwzQnBY/OiAudIe1UHga48MWszvdLoT7tdIHB9
         d3UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789640372; x=1790245172;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lIbDzBYUic7atO3Tl8OUtyUr5JA3iHCUK5rlYQyhAyI=;
        b=CuivEGUmW9zb7lXelw1aNrqxuRnQa/RmtGUxV602lNRWkiRa+mo0KhaHpltqRLpJRl
         U+hLRf0BcIsvkeWs1QmVRd72OT2KEK5QLSl8X11jaxhen6BcUsbLjx95MIQOz9El9J5P
         eEf2EjefZxFAScwJ/e7XHx/cnPA4EFwHsREqezAU2plgirI/Q4sFhHHR652zaJUQPk4I
         AlgrnANgVFJQ8v9pOryW1PetTTPUGbpqypCCZ6RDItgNXZuWS00mkRscLgPRA3tS/4NG
         /hTm13fADJ0RdzQSJ+dcCwVxLvHVhhVMSvVr3KZh1auBeJC7L+Cx5TQDIl+P1YzlYeUk
         c06A==
X-Forwarded-Encrypted: i=1; AKwUvBw2d4N1Gb1ERDGiBv9QsjOr+gzDmgtfQBjFkSt5rqxfKPKUnsTbA3BpaOyAQQqdXqIjVL/nsO+JfA==@kvack.org
X-Gm-Message-State: AFuF++mURdJFSLk0oNinSjJP2UDIRCXTN+2Ql+fk2ont5d19wf3Loarp
	NxrQG0enfCqgysOvevU9BYrUrajeOhMWaQYXh6so9iZqRYpzI/K8lI6h
X-Gm-Gg: AYBFou0eqtEWy+wf+DyV04u4tj5ON6Zl5E5CW8h9BMseH5tBwYLR0ERif0hZkyk5bPe
	/A+xXF7gSrEdPHtxu1qHQSXrKl7PSX5Zb1E21d2g/eIacsnli9HOIzlKcuqAdZdE/BL5mjq+Fyz
	WS2MZO6OSK5VpfOrv1nhEKSODcfawLn3vnJKyJ4QJ0xxRWSts0GZG0tcIYIh8ryrNH1Chf9kEcD
	Wz55Lc1oYfVnuP+jnTsAVoU1xZvPIHzMcnka4FjVrKDqIhKgkLq23wH/0EeUoqEDvhKZlJk8ezN
	ZvjtrSzvpv3NlcrIKFfdZaW41jvVkrLLu5WY/4JV6/VtW0BlZj7dEHChT4KoSADzf5w0tQl8chV
	2shzeWfxIHLBCALwH4ZlfPGETefVfjT5MIm+A88NLCDuH4zMeByxyqCktan4Oy2oGFoF8CliDxZ
	xuBBbZ/+yRjM+70kubGSZHc1Q8K64pWo7kYs6LekbxFKLoHaBttmsP+Ns5JglczwfJPOfVw7QXq
	IllBC0ej2HDAhGcVfYF4qD4uTK6T65zUXZb
X-Received: by 2002:a05:600c:a47:b0:49e:719e:e215 with SMTP id 5b1f17b1804b1-49eb732eeacmr66304395e9.26.1789640371628;
        Thu, 17 Sep 2026 03:19:31 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd1d0978sm62964985e9.2.2026.09.17.03.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 03:19:31 -0700 (PDT)
Date: Thu, 17 Sep 2026 11:19:30 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Arnd Bergmann" <arnd@kernel.org>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "David Hildenbrand (Red Hat)"
 <david@kernel.org>, "Michal Hocko" <mhocko@kernel.org>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Kairui Song" <kasong@tencent.com>, "Barry Song"
 <baohua@kernel.org>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He"
 <baoquan.he@linux.dev>, "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Ridong Chen" <chenridong@xiaomi.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: avoid false-positive -Wuninitialized
 warning, again
Message-ID: <20260917111930.03a5f02b@pumpkin>
In-Reply-To: <20260916230330.f0923cdb679de0b39d1c5d3a@linux-foundation.org>
References: <20260916083456.4136132-1-arnd@kernel.org>
	<20260916162816.39f0f33f6a48d30a71be3575@linux-foundation.org>
	<20260916163044.3daa3811d9b2bf7d958f1f27@linux-foundation.org>
	<75939625-482c-464f-83fb-fa12d3e1d79c@app.fastmail.com>
	<20260916230330.f0923cdb679de0b39d1c5d3a@linux-foundation.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mg6shnd7k3beajmpin5qikdnghupfk5t
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D70D1A0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789640373-295858
X-HE-Meta: U2FsdGVkX19Vk5BOjXgL90/pDtps/p7q5UTw9GOnYakm/VM13aZ9RweH57mEPp2bSnWIOV8rJENwNH9jGQ2bZVkhFFc76RzTzsZW9O7ZtFWmlPJvqB+GLtAPJuD6MHBl7HXYDQpGnDJFPo2O2jh/PwO/kmhK44pt7FzDbzlNmCCYbVh8CLGhraHfEaPstVUWWOf9y30Fla49/w19pgsWEnsM/GK/yGyuLoJiG9Dmr3FTxACPyYXShILjJTnd2iXSplCa/n3sUqOJ3hSLVBxVZV5iLOz4cIKnCHscJBgLCredhD5PS92C8xMPwbOt2lh6iE1KioL+FZvwYpsJEJmLNc0VanZFYR8CBae+JGd3UoaRGmhEympb0JvipWh44wmmQVqJgg42Iunw/N7NhB9Nt9+IIRIYbzoiujyP4DpJclgVmxZYUdGxK8oojZfdSAuxFqIyQDvwDEXOZRtIJP0TfOTDgqRH8BfkygA0/ev+1tEP51CRl8ENEtrRRjOKvrMa0hr0wRogQ+XpnXMWpX/1rEx3dFjekhTMTmnTE1udBHQnFa7bgMUehc21vdJqJ2rqcslxe7LhEe9SsCm/VKsYF/G28D5ym4EMjMYCW29JPHdM3pmO/9FgHeXk+pyASi6NWCy1XuJ8v95qehdUcPxW064nan176igqMPJu9cOWmeTHA2hMhf8JDXJGCet5ErC84nY1aZQHnI0u4g+CQabOiDyq//u6+L6q6sQkyWHFsuVfP0e82qJFACdbaU7df+jSY4wT5EGYWAXzsWHQCTbvIYjPOT5cQsGV8n4cMv0YHeu44f2tiomN0E9+U+k9M4luOO3v/Zp8CNealK7G7rK0VmskEj6VC/hqJabNSuvYFhWIt83F4TAb/rW1c66vyk0LJkFz88243H1C18c8YxemM8LywTZRRK0dMPtD+cC8nW3FrFBOsHRipVYXb/WbuHsabewkPUsEz5JoFrrb8pZ
 T8B26SYx
 L/tZvoJknu0NB4iKmJay4AsQ9zzGb//23v8qei4c0S/bci9/Zp2oZ18c25Amvg1xJHRJW+TYM6H8yzRSc1hhRo+5GZo5+qMOQStxGMlXebkPh9CP4kWHWDw6JE+VxLe/mDH2BiiYufJV339HIcPB5oVyhcZl3+W8/Y9znqo3RXnQEXkW82DVN65/dh+rPzZPXcNWBI6P53hGCuYevv4A7WyOvOCXDbUkjFC5KL5PbrR8U+QS/cM+xiUMJV2uB9lLm6JJJZWe5Nj09LhAIwhCS95iWVriBdMMOJmaCNRCcbPjX8mX3qriXMK+bcTB1DICQznj2wy7B0bN4Nm9MhmobrVqRVdqp09FMHLkEA295kWUwDBTFBXdFBGrxydv6D9McB3Z3Bwxqa5k+/ZN89KlnJCvsvMqnTwWnP5ss5UBh8DkmTuopLrG++KhazOH2C0bJT5rmzBnJ31TGrnD52YQCLQz0x3/oRKKwZzNEBKIUHFT4nfc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 23:03:30 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 17 Sep 2026 07:50:43 +0200 "Arnd Bergmann" <arnd@arndb.de> wrote:
> 
> > On Thu, Sep 17, 2026, at 01:30, Andrew Morton wrote:  
> > > On Wed, 16 Sep 2026 16:28:16 -0700 Andrew Morton  <akpm@linux-foundation.org> wrote:  
> > >> >
> > >> > --- a/mm/vmscan.c
> > >> > +++ b/mm/vmscan.c
> > >> > @@ -3274,8 +3274,10 @@ struct ctrl_pos {
> > >> >  	int gain;
> > >> >  };
> > >> >  
> > >> > -static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
> > >> > -			  int tier_max, int gain, struct ctrl_pos *pos)
> > >> > +/* __noipa works around  gcc-16 warning for uninitizled use of pos->refaulted */
> > >> > +static __noipa void read_ctrl_pos(struct lruvec *lruvec, int type,
> > >> > +				  int tier_min, int tier_max, int gain,
> > >> > +				  struct ctrl_pos *pos)
> > >> >  {
> > >> >  	int i;
> > >> >  	struct lru_gen_folio *lrugen = &lruvec->lrugen;  
> > >> 
> > >> Current code has changed here somewhat, but I expect the error is still
> > >> there.  I fixed that "uninitizled" while in there.  Altered patch is
> > >> below.  
> > >
> > >
> > > Then the build blew up in unexpected ways.  gcc-15.2.0.
> > >
> > > The failure looks like a legit min() signedness thing which has been
> > > there quite a while.  I'm thinking that __noipa surfaced this for some
> > > reason?  
> > 
> > Right, I now saw the same thing here on the current linux-next.
> > 
> > What I found now is that the __noipa is only needed on top of 
> > "mm/mglru: use explicit tier range in read_ctrl_pos()", which was
> > in next-20260915 but disappeared in next-20260916. This patch
> > also removed the min().  
> 
> So we don't need cc:stable?
> 
> > I think the reason why __noipa causes the warning about min() is
> > that it prevents the constant propagation into read_ctrl_pos() and
> > in turn the hack that suppresses warning about mixed types in
> > minmax.h when both sides are constant.
> > 
> > Is the mglru series currently expected to make it into 7.4?  
> 
> Yes, "mm/mglru: use explicit tier range in read_ctrl_pos()" is in
> mm-unstable at present.
> 
> > If not, I would withdraw my __noipa and hope that the next
> > round of changes to read_ctrl_pos() does not run into this
> > problem again.  
> 
> OK, I'll drop "mm/vmscan.c: fix min() signedness mismatch" and shall
> rely on "mm/mglru: use explicit tier range in read_ctrl_pos()" to fix
> the min() thing.
> 
> And I'll stage "mm/vmscan: avoid false-positive -Wuninitialized
> warning, again".  ahead of "mm/mglru: use explicit tier range in
> read_ctrl_pos()" to fix the build glitch wihout a bisection hole.
> 
> Does that sound sane?
> 

I've don't remember seeing that last patch, but I have looked at
that function before and it is entirely horrible.

It really does need to inlined to avoid really horrid code generation.

But, in reality, it all ought to be reworked to avoid having a function
that is called to either process one entry or all four.

David

