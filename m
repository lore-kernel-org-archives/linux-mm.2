Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E665D606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=EVFNqegP
Received: by kanga.kvack.org (Postfix)
	id DF6766B05B2; Wed,  4 Nov 2026 04:19:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9F406B05B3; Wed,  4 Nov 2026 04:19:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7B96B05B7; Wed,  4 Nov 2026 04:19:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A11326B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:19:47 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2D499A069B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:19:47 +0000 (UTC)
X-FDA: 85396889214.10.52D83BA
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0F012C0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:19:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EVFNqegP;
	spf=pass (imf10.hostedemail.com: domain of pmladek@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793783985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yvthss1FZeqCIQjhmXOlwbHPhSn4bLFrdViNSfOo4xU=;
	b=kFlhY87GURAL5Cj9gGXW0Q90tMWlCZmRQi2UBRmkgN7LZxfZmmhoDk4pP2mpu14nI6Kpj9
	VP9UuvfWL8BSeidC6+e6dLuxnzkOUIdu6HNn67tLv/7+If7MgDyt3j8JzGC6v9POh7e+wB
	ZKMy/G/gVacM8XTjN5MpPpmc4WKqg3Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793783985;
	b=ov3uTyPc519kR0kCd4a+zCcXZQn/9dVlxhK+2XX4uBhoe1zJCQPXv2+H2jGal32T2Nr0OC
	SANFFym1rIMJ+HT9IPA6XRhmWm7P29yIYO6sUdDU+ls3Gil6BM0WJw7iYUS969evdzDs/M
	8YHV6bbHOYqaWs7m+xR1dhtm8zLijPI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EVFNqegP;
	spf=pass (imf10.hostedemail.com: domain of pmladek@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48e0d1da913so275060f8f.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 01:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793783983; x=1794388783; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Yvthss1FZeqCIQjhmXOlwbHPhSn4bLFrdViNSfOo4xU=;
        b=EVFNqegPlPXvCvougXdLoL18fEFWIIlfOEXSgH4lV3w4rIIB2fjpNqEn3G1W3Jkse7
         wK1DOJyQbOppz42tAftnKWb7Bp3Jx36wdrWtMP4eCIjLqLtqKr7zrlFP26q/HKYohPQL
         nhooaHz1wl9CSHXnM1nWkRFbVGbikG3kc10ev28Yc6baRkxM4Y6MqI16nSwMp+5h4lh0
         aN+FQP2PRKM9N/zt8n92hLxvFs+Rl7x8OV55R7oR2PGX+C/juEzgk6LwbfAO7AfthsbC
         fSL/j9Qx12UlIhzOBj9G89U72JMZ5p/jHVj1Oaa/LZzD2tC0KjqVh1Jj3ImEh06W55HY
         6fng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793783983; x=1794388783;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yvthss1FZeqCIQjhmXOlwbHPhSn4bLFrdViNSfOo4xU=;
        b=pCVXj9PIw6v4KCvFwG0yrXgrlosh80NxwsIL/e2ricpyy6YnGa9IT/BVof9ecNega2
         /hHE8/ankG0LBqDdKxbputRmAr7wtCU0cDXLx0TTcfZx85gHgGvyWL9XfhazEa4/+787
         eqnMO8kr2VEpEs2a51qISlI48FcEnNRJHugt+uhy7fKrHszsE0iBFZX9oI/6NZ0qV4Rr
         xbKI6enuuB/L94VymQTcYa527orH3HhJ4JnR1gqOXd82DbYlh/O8j+vqtcTtXvlynUGL
         3+1JNM9BlrN4WJy1JZCox8LMWIVUMo/NQIUtbl83HZzIsAQa16e7aWWS1dqdmPGqZxOq
         DgMQ==
X-Forwarded-Encrypted: i=1; AKwUvBxGpZnAqTkauMjnRgK3rwTm7Q50zT4zXThjt8oY1mA24wN1gT2t7k8vUxptcjH/GUCrZWLyh5HcGA==@kvack.org
X-Gm-Message-State: APuU4Z98GaiyqDp/arhdY++LCrZv4OHwOdrwtwmQjaWeOB3WQKAWyOQO
	Z+6vHCspCnNiSYyat8YDUpzwOfOAEVYSDqkBwW4WKn5bcFX22Q3XAN+fh5IjR2dAyaI=
X-Gm-Gg: AYBFou1HyD8K49TnqYjXCH+UDBHZn0ABTOxU0FWKH9gz+bkb645ldUqkUQuVBh08AqT
	5MexMWduNNX4eVHoF8GgzKAQUmcMeRMDrAz69ERnZAPKmRaU4IunJ43ErdNEEzWEzvqhsAUBBVL
	+yt8PrMaUl58FT5nGkNlj+7BNhax8T79RI9SdPJBvzo6Awun0qDUZwcO/Mz0py6v79s4idrU0ku
	OuQwungyRD24j7ge4aBxHeG/KSGPRTkHaJMLNp1SehrT0WwOghoIbqSBhVMrVgn7rKyU/zYwBpM
	+HEC6te4kae+v8BsEFP+rWkMA6CjGI465A9DZ8ayqnCwSAStSyV8f1n6TdnXniv7PwsPejx9+ld
	IxvD4XE+fDO9TcmbtBX2SkDmyZ+ydDWoRF/SoZR0RL+Rxg+lkRI08RtUYF088xIfQOc3dVNXOxI
	kY+wq5bERRW3o7Ee/TBhE/z/+Bcl7DWcaIZJMhJYiWepiEkueKVS+W6GpAwr4KbUnT3JlgAsGnP
	+H17AsaKBAsOty1JdI+4uCXXXWiHQijBSMv8qysL4OTJGnrtfSlio2bYXwoBvyhaH5BAECjZQRA
	CCSHcYT6XGYdBoqYOO6nPGv9yipopHpObGROJU1/PIUd
X-Received: by 2002:a05:6000:3106:b0:48f:bbea:1a93 with SMTP id ffacd0b85a97d-48fbbea1c39mr8637656f8f.15.1793783983526;
        Wed, 04 Nov 2026 01:19:43 -0800 (PST)
Received: from pathway.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fea1811c4sm2887982f8f.3.2026.11.04.01.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 01:19:43 -0800 (PST)
Date: Wed, 4 Nov 2026 10:19:41 +0100
From: Petr Mladek <pmladek@suse.com>
To: John Ogness <john.ogness@linutronix.de>
Cc: Breno Leitao <leitao@debian.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, Toshiyuki Sato <fj6611ie@aa.jp.fujitsu.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] stackdepot: don't WARN when the depot runs out of pools
Message-ID: <aur4rU-I1BhxrxYK@pathway.suse.cz>
References: <20261103-stackdepot-full-warn-v1-1-41f1fc651b64@debian.org>
 <87wlqtxb14.fsf@jogness.linutronix.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wlqtxb14.fsf@jogness.linutronix.de>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: xg3p5umx3easutg8n7daray5z53edaxs
X-Rspamd-Queue-Id: 0F012C0005
X-Rspam-User: 
X-HE-Tag: 1793783984-722475
X-HE-Meta: U2FsdGVkX1/mv8n9a8GFPopIDZ2TicT0M4KNYqX+XoDDrT8e8iwlGdR+rCFjFR1ufDS0kzmek0QO07R2oWgBTrodNge+1g1mrfFphT6d03OWrk6K9wUZzfnUQmwMTPi+Dm0DPNDr0dgQIghV3NzXXqFdthV8pg51y2y50goz5JzJ3yi6OoMP9NHsa6x+jT+F8uf/ScW+bPUtp0w8pBekJREqiex4tsK0WmmCu8PgQna5i6e+t1jBHSxtvwcHZgZzV3T7cVrKThutc0tXq7Ps3RnCNPKEZPRhTW1NisqB2mN1ux/Ugz3CbTzkMSaLERJ6f7ssYlV5+bto5qnjNL/COZORcAZReWKRyfutG7EwyXWbHlkYF4nCpkz6g/4/ncdCzhUbnchSyalf1kU9ma/K1Jqo6Qr4YfP2J37MKdlnqXeqFuqoenSwog0+xB1tsOkh47I3215YCaInpaDjm7gnXCOsjZbi6Flhr7ndTDGok9EkbJVFDMDFR+c22Xr0cogBDVojWn2ly+CfS7+4QoQGaJ9Uvoi20f0M28axCcmcMWxtowL6dJ1bSgKxdtcDiY2AHBv71PP9OtZc6u0lEyIYpnYKVU+E/43hzpFBgoz1ekzVcZ344iiFIQkcJiuqqTDWfcgesHLz+SXlTukJ7PH5px8MWiBANldDBxfinhGgP/HAUHC9MWKanpScMN2UXa6nWTeJn28v7ZKZX8qsdk2LP/xV4pxYLkG8yidHoMH9aKq3j3izBdu4wml5c7glquUc/7lj1teoh/YGLq53QNJL6a0gpJ0e9ByVDWvA9k7P+BvAOCO/6+243tySFSYNTEqizU4kkDOx7MrT7dsX6wwqKuMikCYvZuiQA+RPG4z4elvWVM7NAZMrp6Ccv8l82IrAAcyHoFtwCBRhgk7WoO1ji6JOl92iWu39eAtSLUYTEOt12AiTg++oqu/pDvPdMMdnUEy1bBIl6Mp1OGIQY+Y
 xwzRQ2HF
 4Hdj8rxa0MVzremjd/zEsKADpInnlHHhJ1Ii1UFa1dgoLNVAQ7TBt1Kdt7PN99bagoe4vB6VMxhEuSQUvY01OEcSt2eLjT+Ar6Osy26bThtoHbExdPFCsHVpmQPKzjhT0/7s2ym6CsKHyvcGqdZm53Cd68juAUfqVlSGnApP0nR1PF1vD3zrgvpV1ZmSkb5TWbr4MBVbxuiM7jpRjnxImQAm6UMvUqMJfVW16eokKCiVaVhDTFfnMdEUVy+up4ongjjwf31vb9ijdFN1iZg/IPMErITOivCCCBNgXpc8qYuLOZyQXvo8AgkAzn5UO8G6JNRbaWDKWhKK5iq//YBOWXfJpJCLdN721ySwoR+mWQCUOS74LRCJxWNDENClx3qLVzR5V6ey960kKRF+FrOQJksfrGRwG6UI9dNdRWevvgVR4exc/DTkFNWc3cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 2026-11-04 09:26:55, John Ogness wrote:
> On 2026-11-03, Breno Leitao <leitao@debian.org> wrote:
> > That deferral only applies to legacy consoles. ON nbcon WARN() puts the
> > CPU in emergency mode, and in emergency mode printk() flushes all
> > pending records to the nbcon consoles from the calling context.
> 
> Yes. WARN() is supposed to be for critical issues.

I thought whether it is fine that NBCON consoles ignored printk
deferred context. I could imagine that WARN() is used just to
generate the backtrace but the message itself is not that critical.

Well, it was added to the stackdepot code by the commit a914d8d6cf204287aa
("lib/stackdepot: add printk_deferred_enter/exit guards"). And the
reason was to avoid deadlocks in the console code. And the deadlock
is prevented in the NBCON code by using try_lock approach. So that
NBCON consoles do not need to be deferred to prevent deadlocks.

And if anyone wants a less critical backtrace then we should introduce
another API for this, e.g. INFO().

> > With
> > a slow serial console (pl011 is an nbcon console) and a backlog of
> > messages, that flush can outlast the hard lockup threshold, all of it
> > with pool_lock held and IRQs disabled, while every other CPU that needs
> > to save a new stack trace spins on pool_lock.
> 
> Several serial drivers call touch_nmi_watchdog() (such as 8250) to avoid
> this issue. Perhaps the pl011 should be doing this as well (at least for
> the write_atomic() path)?

I agree that it would make sense.

> > Running out of depot space is an expected condition under heavy debug
> > load, not a kernel bug, so report it with pr_warn_once() instead.
> 
> This is the key takeaway. WARN() is not appropriate here.

I agree:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

