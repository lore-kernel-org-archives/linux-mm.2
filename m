Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8226C5DF7D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 03:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E64746B0092; Tue, 18 Aug 2026 23:04:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39C66B0093; Tue, 18 Aug 2026 23:04:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D503F6B0099; Tue, 18 Aug 2026 23:04:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DFF46B0092
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:04:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1FF40A14BF
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:04:18 +0000 (UTC)
X-FDA: 85116525396.22.C86654F
Received: from mail-pj2-f2.google.com (mail-pj2-f2.google.com [74.125.227.130])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4953A20006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:04:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G7vlSgJQ;
	spf=pass (imf31.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787108656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=276tg3SMLDavi/qnvy971rQZcpwVcCkj3/rR12mXK5o=;
	b=OBOgaPyyNvGAq30Dur6+IJq+aRCdoZGdoW1geQ8vf9hNwgEUZbO7KNZ6GV4qfuaS93F4nC
	8vtlGzkRy+T3ju57RlHiwtCck/7X73aXi/6oFrc91XRE87cqeLwpi56iwdbVn/FAwxZKCj
	GMdmVKCUYBv/mg3teKYmEk89S9uwLl4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G7vlSgJQ;
	spf=pass (imf31.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787108656;
	b=kQKDl74/aFJ6lQZXDDrVP4Oe/7U1eXHa3mni1XiD9BdJ+eUUg+VP87iEt0JiPa4ow4R3Sq
	25X5bDyDfwcokfveLpIhg6f7s0BiB00TwkLiyspVwtmuh0fvr6GBkwcudXkRrgWMKTzdgK
	neeot/WjTn+V8nlAZsPTyE3kC/xnc3A=
Received: by mail-pj2-f2.google.com with SMTP id 98e67ed59e1d1-37fb1883fbfso200799a91.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 20:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787108655; x=1787713455; darn=kvack.org;
        h=content-id:content-type:mime-version:references:message-id
         :in-reply-to:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=276tg3SMLDavi/qnvy971rQZcpwVcCkj3/rR12mXK5o=;
        b=G7vlSgJQ319ZGdCDmKA5ff7zbQAfVerm2kwygH13QUda0Bdlz/7/REifz56WCnmxCO
         yr9PtClV/gdsPEKvMXBhhObd8mET3f7Y1m91Namza027qcp2pnTX0N2vBi2x4P/Auqum
         frZleH0pDgucHw5t8+JsCtZZWX/tNSyiilS1WxJieUKMJYglffUpF3VtATc/L+CjjI+U
         Q9FRy6ir9gybW6zv9JepPrFS9U2ElsZei1d5jEBzVvvzrFhPMsl1IUbueRxiSasPSCny
         c1diWd0ld+15NmvSslCyPpR0ZNzMNzEBP97jKdU6KykSNFsOfWZqlQpb0giceFW+/cDO
         PeAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787108655; x=1787713455;
        h=content-id:content-type:mime-version:references:message-id
         :in-reply-to:subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=276tg3SMLDavi/qnvy971rQZcpwVcCkj3/rR12mXK5o=;
        b=YparTX37v/Q55H44y0cP6hnY8UKd2H/8Roa4A5pc4VLyVZROD0zwwYDgS/fWD1xd/P
         5VQPDM4DC4nsNTTGbkzwEPR69gEejDuOT0gbSzmxZqgraVjZPGOcJCjzZXJRXEXD4LhY
         6kd1y01bnTYoNK61UFJdSYXmBYlADSQDGPyuG60vvE4oRJEgD5VndUGZHjvI3RriUzZ+
         JQ76Dk6Eryd6KaYwZ9M2OxF693LOJPO6U3dFxryy4EUZEBFjyW73wQAF+uY5vJdOAgyi
         Lo6L1r09bk7YND1mk/nEe0YM2kSYJX13VoZzBeA0U6UcS3ykT7Ss2XcokY1x5/bvjlJp
         e5Ow==
X-Forwarded-Encrypted: i=1; AHgh+RqqHPmW4l9hep9/a+8LhjtWYRwsA1VrxIzqxWl1IYw34DjdpKtYvspVQuNVioL7AmF4PVG9jl2COA==@kvack.org
X-Gm-Message-State: AOJu0YwgQTc+g7G3Rq9pnaNTPs8K/r7pGL1qRPl+nphWZFopX2CWw6mb
	7EQVtLSyGps4iCnOFm5/U91Mcn+Hph7iYmq80Ej0Amo3ZpjHm2S8ci4G
X-Gm-Gg: AR+sD12N5c6A4aSoWcj6JT8QGe1HQa8/vRrqUQfIB+pM9VcclxXmfwLF1/wvpRRVl7J
	SNa6r16/ynLsei+azlw4Zqudy8SRf+5dM3XIFDExnug9J3h06b9lWGz5T1jMCGVUXwK8oCeYmN0
	IrHAt6QwKDoZ5fyNDd6wm4wIjwIojC5faavLi9XO8KlbRkErM6kEo6zUKOTiXUPLIa9Y1G+rE7V
	b1tGPDiwl/xT0EGF6kWQI/wLjx3ZzaLfZAtIgmHyjOZ4KXzww2e4k+pFWVa5kYnP86lGGRaXAb5
	vCINfHEbKFjAuES6+7oKkut1SfRchWRRjhc7nakpXbH3oLyuLZu362FfTPveWC149piqHhd6F4K
	vt84qScGnQAFI9n4zEPgnKD8tAd7k4QgPUkileefQYWF2uiOqkx7N36yXejHLbfwiOrIz/sKl7V
	mYU8jRMGvKAcF5ObsIEQ3mTr/8JlhNZODbIvldtnEEMP8PEEm8xKg/npxGKo/+U3lMG30=
X-Received: by 2002:a17:90b:4fd0:b0:38e:5b59:c2ff with SMTP id 98e67ed59e1d1-39580a4d031mr2838795a91.3.1787108654838;
        Tue, 18 Aug 2026 20:04:14 -0700 (PDT)
Received: from 192.168.1.6 ([140.213.202.182])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bef3bb46sm1517533eec.3.2026.08.18.20.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 20:04:14 -0700 (PDT)
From: Foxie Flakey <foxieflakey@gmail.com>
X-Google-Original-From: Foxie Flakey <foxie@gmail.com>
Date: Wed, 19 Aug 2026 10:04:10 +0700 (WIB)
To: Suren Baghdasaryan <surenb@google.com>
cc: Foxie Flakey <foxieflakey@gmail.com>, 
    Andrew Morton <akpm@linux-foundation.org>, rppt@kernel.org, 
    peterx@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
In-Reply-To: <CAJuCfpFzcpqG+g9f-m+-B6yk=pOU+PKgKRLVowOE65S127NWzA@mail.gmail.com>
Message-ID: <b66af965-5bee-1c20-d5b9-ce77b0c8b117@gmail.com>
References: <9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com> <20260817152605.5d2bee3fbf1a2bace4c0eff1@linux-foundation.org> <ae1cdc48-4293-8b81-d142-3c656f2c2cfa@gmail.com> <CAJuCfpEOF3=Uu3cvoiH0tJoJhhRmwR0YLy34tyPC-2EE09xWMg@mail.gmail.com>
 <b248cc12-e083-ec37-e6f6-2a57e8cccd3b@gmail.com> <CAJuCfpFzcpqG+g9f-m+-B6yk=pOU+PKgKRLVowOE65S127NWzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="0-840344486-1787107643=:7449"
Content-ID: <c46a12a4-229f-aef0-f5b7-c5e69daea2f7@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4953A20006
X-Stat-Signature: uise3gmp6s4h456qocxcyx9yqb1c1edj
X-Rspam-User: 
X-HE-Tag: 1787108656-198131
X-HE-Meta: U2FsdGVkX18eZa9y54zskM79qKoirJQhX0ak7A3mLZxATQbsZcLR/h2LVtbTd/XxnrrXmNqsmrNNMmqByzzHo6M5CZiJVjarvT0OnM+WPvMdzLc/JylxCeHG6kvORJ4nTvaFwMOqpSrpbM64hw4MPNI1ifhwutMkyHpZYy8R/jT15TghrMIIuoO34xatdLdizhkWpktPDT36eJb8guAU8uupNPQBAPWzuMmNqMm06e7d33oRWJozFZk4ou+YRvsn0hH8aKx8yaKzAriwFzpXTMdH3JYPysf/doOVwgMNpElPirOiMNOb5wcORz63nqTBKTPjcbdKmPSjwH+cajmozM+sxmhJjzEp82hUIlDtp4bFpsBj6KpDTPLTIoUEUs5KkkWxofn8AA2a+q6/2ZDgFPUV0h8LPGWAAH/ihtNNDikttoKXZ3kNgL5kxEVI6E8wlErrJEIO7EAuNJDISUv2UBSwKt9a9CjYYuvD8/PnAzy7QpLX15aNRvIG1pb2aWBVMxpbDWtS54PYRi6nSdzVvsmWh4ZREMKUlACiCwjx70wx91SVuTC5C6qgBly2a9d/sDRcjq8GoB3l7CxapcSlZNPitVppITxWJe5OfQ5vw79mgn4hk35JJvZztvnAdQPs7zIm6r+6iY2DWXESomwKHFup7/5AtRXBYdNGvGUkA811Es6RkBOWsG7M+RvbdMPkUoGHEgBkW7Q9DT3ejAlC/71AoZXElNqOGlgkRglFvRm/gSW6dvqKIjz5o4xAWSbh4GzjiVWRiplf8Z5ioWmzP5SWmwFX1IHCXhRXA2AhXXGsU9i9klk5q0s8Zbc6GtOQ/NrbAfn9N5/OZk5e/vfLwFqKDBeiwQCrloChdx2HYmM5TtDPWcJK+TP00hERk/DbKjR4KxwgXFNnzlljYYl/UkwiQ2QMOZOrG1GdiPXmH6X2UFLOn2RokEkYvthZRtZvbD6WBqMSOYK2KAhUxOn
 Vz09Ilpf
 2y3IcbpVIo8kndGhsT5ViBAibiOGlBv4/nqh8tAp7R9SedHlNY3mQaA4I+hXl9eIYm332R0ttcgb2Tlqm6L3kxBuHaEEIp0A7evIGVQunSBRiX4ErkF6kfxPqb+RVXyBZyEvKcM9lNIckN0jlu6oH6ITKigg6mirDIk9YxM0KUXAIidWioavmkva1mYC3fWO6p4Qr9smnFTmuRsYShPjp/u0SU4YswPuMfvrP1L/+vCU8/FyMVv3hEUVzIjYyZ+7GdjDbCokwjDeoplraKkg5whlx99SuDJeNs8E9r0LWZF5pn0DiMchEwMZv+Alrj7ahvEG9y8ZhY0aOnD7MujYKmEyfOuy81XQ4F50OYM8PRrxdZouYRFfymsAFSe1xQRlKMTadwh7QZjDMuCEkDtdkndioPDLDDZ6HCCisLP1WJZpLeWIiQWSLD46UuA3U6adD79to66TDjtzp2R8Hb7E1meXapsxAVfMj8oXB1vZ3yVUjRhVsdfu7JhixaLcnlW4h6HFvngdjSVmFHet9+rm3g0yKO0KSYcafn325+PU69iEKLsARj7ryBwq+LqZoTThD9ZSkqdUnUl/0cc2+ginsus34XQkH+cckEUCiJTxyEdGOe0JvoikmO0SI/xpBXZ7P8jxCXchEycWrKkU7CgIQxw31elRwwvrM6cIopaUWB6rVNShvm5uBDFJI+IWwSYdGiOoFTvwwflm6TPheG19z4giIHsDv0Cj+oY+3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-840344486-1787107643=:7449
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <fa3a66e8-9be9-6c33-230a-45e54ede4812@gmail.com>

On Tue, 18 Aug 2026, Suren Baghdasaryan wrote:

> On Tue, Aug 18, 2026 at 9:50 AM Foxie Flakey <foxieflakey@gmail.com> wrote:
> >
> > On Tue, 18 Aug 2026, Suren Baghdasaryan wrote:
> >
> > > On Mon, Aug 17, 2026 at 6:13 PM Foxie Flakey <foxieflakey@gmail.com> wrote:
> > > >
> > > > On Mon, 17 Aug 2026, Andrew Morton wrote:
> > > >
> > > > > On Sat, 15 Aug 2026 17:42:12 +0700 (WIB) Foxie Flakey <foxieflakey@gmail.com> wrote:
> > > > >
> > > > > > Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
> > > > > > Signed-off-by: Foxie Flakey <foxieflakey@gmail.com>
> > > > >
> > > > > Yes, the pseudonym is problematic - it is contrary to our written
> > > > > rules.  But I'm a sucker for fixes, sigh.  Perhaps if someone else were
> > > > > to send me your patch with their signoff also, the rules would be less
> > > > > offended.
> > > >
> > > > I see, I'll post the updated patch and work on signoff issue later (there
> > > > has been updates, I haven't posted v2 which updates the patch and
> > > > description following a feedback. Why I didn't? mainly I'm not sure with
> > > > answer for signoff)
> > >
> > > Yeah, please follow Mike's advise.
> >
> > Okay, thank you! I'll re-ask Mike again due I'm not receiving sufficient
> > answer.
>
> His advice was to use something that identifies you. When you meet
> someone at a conference you do not identify yourself as Foxie Flakey
> (unless maybe you are at some anime convention). Use the same
> reasoning here please.
>

Thank you. Its clearer now. After thinking for a while, I'll replace the
name on Signed-off-by with my legal name (yes I'm aware legal is not
required but I don't have other name which would meet under that reasoning)
following the rule. I'll update the patch once again with proper signoff.

--0-840344486-1787107643=:7449--

