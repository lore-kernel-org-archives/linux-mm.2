Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A55DFC5DF7D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 03:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AABD6B008A; Tue, 18 Aug 2026 23:42:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953B16B008C; Tue, 18 Aug 2026 23:42:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842696B0092; Tue, 18 Aug 2026 23:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 527A66B008A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:42:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D6C40A0415
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:42:53 +0000 (UTC)
X-FDA: 85116622626.13.7FBFF2A
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	by imf16.hostedemail.com (Postfix) with ESMTP id 18CC8180003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:42:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dxJlAilX;
	spf=pass (imf16.hostedemail.com: domain of foxieflakey@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787110972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CkLkEuOXHhSmUN/BJBFx0Z7g8/lyDpALhd4qEk1ARU4=;
	b=spnnNmLk+UPW/ZvTjidDPiaq7tvp9ybNhkAAWNtt8gs0N3E2kfFy8lqQNbDMT9PkVlhCO7
	+9/Cmz0WFL84X6OkG60B7wAllqW0kue6i5MxLHElPzehNUmVKPG1Th+MgbfcQL/Ag5p3yZ
	mMgrEqqTtuR5jz7Z/WvHGA4yGbd/oYs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dxJlAilX;
	spf=pass (imf16.hostedemail.com: domain of foxieflakey@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787110972;
	b=gwhfqyM+wONtss1KkyHRNRUz85q9Gc5sNAp345WNjDhUzTTw7QAH+OBW8V3EK/NKOkxKCS
	8uBlQTo5mKg2nHiCFP3niP84BoMW3dsaDGC9SIABQsLL5PB9fcS4dIwK0YaG7N4OXhAYUQ
	9GmfDhcMYf7QspDfI31MfX906AL0Fjk=
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-2cc61541f8cso19931605ad.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 20:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787110971; x=1787715771; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:date:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CkLkEuOXHhSmUN/BJBFx0Z7g8/lyDpALhd4qEk1ARU4=;
        b=dxJlAilXj47U5i2hYVt9T+8IQuu7/e/s5BcM3dlQz6a4dS4pSPB0mBtB7wH4mdqQZ/
         ktffdBjFW5e8KTW9TDcWN53SSqtxuKPwTggTPo7al9Q5KYRFA6RqC160yuB4gRSKsZhe
         vcsVBUFgUCzZ9q9SyobR7E+nVwn7jmEuUOuKLnJkgXRc90Anchi/bv0pMsxoZVjTU9EB
         /FMlYVNILoK69U/+8VVsV9NdC+h4vzTO2bFt8wZ6r0rqo2hO2W/KjfD62YaiAb+Dce9h
         k34JrS2xN1J9p76fj+fGnobW5fr37LZQ+P65K+8dEktsimrwJ1a0RwXH3a/it6TyF68E
         vE0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787110971; x=1787715771;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CkLkEuOXHhSmUN/BJBFx0Z7g8/lyDpALhd4qEk1ARU4=;
        b=OadirNT+njsR/e7QneQLejmIQ2u6k5v2enE79JJuiyyrXQAiLJOQ7JOsBVzYkPkcl/
         mdJPU5kwq4lzEFfU9t2/kO+Kp/0ZiJrdxxbtqimGOvm7UgcZjNsRzvQWt8JDrhaVG9C0
         vRUUlcqH8dawVOn02n+HYR/r1cCToFFTaLNdJNfWONZKsy/2By6aK22PTueTkr+m7U9G
         WAU4bkZXO4WAML2h9SWMqnJDttQu2/XImuh9yemuCxnhP9l3kwW7mY20y1Z4nETN8Mo4
         8VfE5nOfa96Ji55cxRgVmR6x1v3hbGb0dXLJVfILgbtBAVb11SjbpvnxKmHrgfxv7bPB
         kfEQ==
X-Forwarded-Encrypted: i=1; AHgh+RoQ5ux8N9mQzAlND7fSjrTzrfr6Tj+4icfIo3n7DrnI8zpQrFc8+13T4eLegO4IHUeswEP3FaRLeA==@kvack.org
X-Gm-Message-State: AOJu0Yx92XYTuZrswVSvhHcRYkkxde6EHyhJM+Gi896W7JXpTbHS2tNP
	0oe529i+LFu5j08AHJfGVcHGvTOfMABv+YhFkUtrZuT35jK7Dgcy2z1h
X-Gm-Gg: AR+sD13Gyw7uaKH7xpu26211msbsfpjTwaFP1UwFIHOEtMSdtsO/NS/TP7GFKY3NDgF
	+5efWXaPBMvaDWr3rebcr9gKYePur63aka98NwpXk1iBoBMfYAv70huRcvGREabao6sB3JB6aqu
	htWXtIaFnDPrgjQcd/M2u5B4reYt3lFU0TtXD7eYypJxtgmc6RU+g1xN3KVueDM4hQLmw+HHj13
	6u+asgcuEEUxeyHxCsYrg7XCkBaxT+DXRw+td80eiJwkkz7R+VTuiYM8VZMlhSkDfVeXAqe2pM7
	MMd4xgOUBws+hx0+otjTCv7x6KO0/N3jnrMEhB4h6ndQ38a02SGLOinh/C2CPHbxmelPfXFxXIb
	ogtNrVtT4x0ADIGxUZIafowzQA+qMrd1QGe6hy2uQDnyGKwyTYI2Jb+YCmzEiQ92DatTCC4x56W
	4jHxHT/dL6vbK8tNRWgaGBZCEdmaMuRaJLJ0BY9LzZMaVmDNdbQb0rv+V0
X-Received: by 2002:a17:902:ef02:b0:2cc:db7a:251 with SMTP id d9443c01a7336-2d5fc84bad1mr25854625ad.2.1787110970799;
        Tue, 18 Aug 2026 20:42:50 -0700 (PDT)
Received: from 192.168.1.6 ([140.213.202.182])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bef7a0easm2081197eec.12.2026.08.18.20.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 20:42:50 -0700 (PDT)
From: Foxie Flakey <foxieflakey@gmail.com>
X-Google-Original-From: Foxie Flakey <foxie@gmail.com>
Date: Wed, 19 Aug 2026 10:42:46 +0700 (WIB)
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
    Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
In-Reply-To: <20260818202656.f7a248b33f6130d06b4cf83e@linux-foundation.org>
Message-ID: <e6302577-c2ac-b80b-bd43-7f1f8a52c314@gmail.com>
References: <e1e0b5f8-c3c6-0537-670b-4397f822f980@gmail.com> <20260818202656.f7a248b33f6130d06b4cf83e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 18CC8180003
X-Stat-Signature: j1ks39gcssccu7r7jghqq8ihmp1m59cy
X-Rspam-User: 
X-HE-Tag: 1787110971-376231
X-HE-Meta: U2FsdGVkX19iKiTqxew63Uwgg2hxrdK36Jsp7YmpKZ3BsTtClpjDuBFGtwIFttwpXKoDB4rIJ4ujw84L0qYBvTm58XTyqYTPCZA4L0K7Nki538Clucqu47fbLFOz2j+99/p8xDHBpl6oQMQ8GGq2IzatPxxY7gwuSJaoO8Gk77+29VdbspJrshApFxl+z/eU4MH6S1dMwxetxL+tGTe8HspV8j6Pluuhzat9Mi9FrILsTJGslU9CGMU1UzSFYcQvqMlssKsAQst6k/K1Mpv4+JLHNR6sGtXAi7HrnFynxT3Na6zVKm7koXxeQ2b+xID9MY7fbLz0k2kYVkclT1NnpP0caISeTHqe24s2pnf4w/OfFJjfMUhiWCKEAVTHOEU+Tkf26rNgLM73IdVNsx4l6tPtHuY1wPxhX5grbywQ+0egkNMMTBX4YSa+/j1gZp4ZSfd2qdYFZeaEoEf/gf+s5rpqcYf84jkpo3Yjj9G3JqZ6M1KWnlXpWx4aPeeBdoSVsR2YkcQviBIcHv+WEek7rkNjLi+oX3EkAQSx2DHlENBtk+xtLT5+W5HNAOPvNSK46/izhHFpvCHPeyqQ/XtczDTHQwWT20OKv6ptBFVvKvN8SzZcizTg3z6n1tzCNo8imOmKWvIutkGpEvOeMBCSZIBK1VQKkQ9rhATZtx7DYs0JIt+4fOQxyo54JHWbc+msUWvHSDt9cBErRz+qBPqgpJCppLABSPGBmfGsEYheA73x+zUwYWTt+p5akLlRdIXFkJgZD6nx9puzZg8xjJLG92cQ2zFlorgjM5JDYs9O2vAaSp2+rOa4ghDC30jFhbowKe1NJEi0DHKB6qFh3EvgxftqltHViv2YkjEHJZbC/uRgfRC9uxmwuJ/N7gUJINaocr3ExmF+IGJXsYgZJFPgr9RdeZeAj8ER6hni1jXolEIvoN5mtWarBvBdKCTXAkoZquxlcEb1ARvdrDhk0IV
 81yeDzl8
 29DpR6G1mPtlZvutBUVX26qm8d6yzUbGyaCkfr9Kw/pgSMldnq9HUFaOzpv9S/ToKtWkT71bFU2ey/dCjwSQN/uaMVpGWrfFdAIm279mbwsfWyqVEkqoNXzxiHJhD1tc00X5HoCnBgZQxKFBElpH3WduTooR0aX9kURs9cTauzWFGcl5AHWYKvneQNZXybo6/5vLximYyUtv410/Xljq4NhJ0nmWaIRWfXaMHMk6balMRSlq5SwgDsnzwMnoU0/69/Fmi/AFdwn4Kh4zIKQT46TyUXSYZwQdd6B4mOCU8E5aNbL5JsNYQitVo6aDuanvjTTx14Za9y3VBqL3FFo2AWw1W8+GtWdH5HFVDNQ6ffHq4xeIZ+61ONqr7P1P7S8Y1tJ+hdXQvhcLAYCcD7sdTbrq/TrwTMPSyo1wp734Rqn0kcPIiAlPKYzEoLIx2ykjP2gxSorbIaP7vVsn9nIYSyunqOMQdkEThmBcdFc1C3L9Uxf0YxOYi45t5DWTWOnn56CV1mV7hqVpdajITXMm2FsUHQiaMn4y7EU0SfVtPvE06HNKhDK7JoUf1djwMPoo9RJeQFVBV8RbUK4E++EeA0Zgf07D7FgkyxaPLwVRuPWWWcOS3PJfswu8W155JKELVBLjN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026, Andrew Morton wrote:

> On Wed, 19 Aug 2026 10:08:24 +0700 (WIB) Foxie Flakey <foxieflakey@gmail.com> wrote:
>
> >
> > During move_pages() operation, when move_pages_ptes() returns EAGAIN,
> > the error code is not cleared even after we processed it. This leads
> > to a successful retry but then the same pages are retried again due to
> > the stale error code. This time move fails because pages are already
> > moved, loop is terminated and move_pages() reports a failure.
> > Clear the error code once we processes EAGAIN.
> >
> > Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
> > Assisted-by: ChatGPT:GPT-5.6-Luna
> > Signed-off-by: Bryan Lim <foxieflakey@gmail.com>
>
> Thanks, Bryan.

No, problem. Thank you for your time. If you don't mind this, I would
prefer keep to be called as Foxie unless its required to be Bryan Lim like
the sign off. Sorry, if it took a while for me to understand.

> More paperwork: the signoff is supposed to match the Author:.  The way
> to do this is to add an explicit From: line at start-of-changelog.  If
> this is not present, we fall back to the email envelope's From:.

Noted. I'll keep that in mind for my future patches.

> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -2085,8 +2085,10 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
> >  		}
> >
> >  		if (err) {
> > -			if (err == -EAGAIN)
> > +			if (err == -EAGAIN) {
> > +				err = 0;
> >  				continue;
> > +			}
> >  			break;
> >  		}
>
> I'll queue it, with an adjusted From:, as above.

Thank you!

> Could reviewers please advise on whether we should backport this into
> -stable kernels?
>
>

