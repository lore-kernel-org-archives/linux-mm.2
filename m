Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E24CAC5CFC1
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 21:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 760AE6B07EB; Sat, 15 Aug 2026 17:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711866B07ED; Sat, 15 Aug 2026 17:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627A26B07EE; Sat, 15 Aug 2026 17:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE996B07EB
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 17:58:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD14340478
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 21:58:44 +0000 (UTC)
X-FDA: 85104868968.28.1A7CE28
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id 03D17180003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 21:58:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="A5Oqm/MU";
	spf=pass (imf06.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786831123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31zdeqcy5sPeYzke8us34mex98HuBd1sdQEvsQlannI=;
	b=DgqCKRZqLd/yH3NNWZtVXLXQFfQ/rmfR/gyT0bgeL3Ld7noCr9zZbyD+CcSaDd+mgWzHH6
	z48K1ZG5md8fKaSxQZhXc8Jb1YzHCQzNLUygSfzgIkZFOdSfXkceq4O57pSDX7DJwCpWCB
	h3lv0Yz9PYyrhW5ZJ1lpmUS8c62/r2o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="A5Oqm/MU";
	spf=pass (imf06.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786831123;
	b=GatjwnRq+X36pjOFMPnnCmNkGiK0kO2ZQun91Ao7eOqIy7M1FydilPd2dhPJL7RNWFSQSe
	UX37sDCzuwyacL76BcXX10qJn28sj4myPpvt0td0V4X3JNB6CfmZ8hXdsP06v4YVlKRHS3
	0QEjWCw2bOjX1QyzAqSF1qQQhUWiYOk=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38511175ad3so2073481a91.2
        for <linux-mm@kvack.org>; Sat, 15 Aug 2026 14:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786831122; x=1787435922; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=31zdeqcy5sPeYzke8us34mex98HuBd1sdQEvsQlannI=;
        b=A5Oqm/MUnQ7bFKAH2sOjmYS0ZKzEj4KHALe9JoC5blyGp9ePs7mOaLonZFqNbtnqvY
         UHoBMbne/bPUsKphZSLCy8Rc4czF0nuOejgAfpssjj7chS0IGQYjUC44JAJCpbBXuR3W
         /LdC9izeQMXgGBuqeIYA1WuPlN9dRNr7XCLMxLmfvdfjVl0j3tWdYL8pAroAiAORucfz
         3LWAemDrjxEnazt+CbsCs1lWNOcBFIfj976rRl2DziIX+G+Kg4AXzR4Z0YYjLIaS2b/4
         GebW8446a3iBllqEex99J00ykQE24NNxQJ4iV345wXr1BRqOOx7ExznyNhaqlQAWL7vg
         BTNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786831122; x=1787435922;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=31zdeqcy5sPeYzke8us34mex98HuBd1sdQEvsQlannI=;
        b=j3qsxgUBTpZBJJZbUzf3qkH1BDm6YKSg81ZGPYmiJtTv2WQ3cFFdSNbBSVn8OIoDDb
         GxxRvJ/oIe8SKIALabzwzeYBRGT9jAkWHN2BbsGodYh+d4bJOYZ/PljspbzkCObmqSZU
         vmEp5NFXWUKyDr+q0iiKlRAPqdnyGNKb4B1Hle8TrC/XW3ZRXIVZ2NfyVDX13Gl9lR8z
         MfC5UzMKiq+1QgAveV0eK/lVKFxA0+yl5ExEl1KnbFaNahaNyB3Vatr1dttdyE3hZ8IH
         cC3BAnjzXGwyIRRuEEwSwObrJe4KxnQCpcOlJbNztIaAJephsentNnE3nanQ4QCpujew
         5s9w==
X-Forwarded-Encrypted: i=1; AHgh+Rp6hYAvFRwAO8CPXk3CVthPFIZY0N/WCpxhCcVFs4wd8n0nTJK8xi9WKgz14kTa/FD74KPjPMBaiA==@kvack.org
X-Gm-Message-State: AOJu0YwIIHOF706Gh4QAjiMmENSGz4S1ISJWwqdp1FKT/leVjGrbTB/7
	o0q4qyCRhexSmpgMthyyBwxpqe8y1QSsrY+LbD5lP+85pVaJrjlBt/6+
X-Gm-Gg: AR+sD12OT33PjWpD4SBgAeO7gU3fHiGI222cPqr8f+fwlYE+bmLTVYSGty1M874JemS
	KmZPePz5MQg0gJtxh9bJ/acPr2Lw+k6ghS5FEdWoHdci+lQS45z+eGkXdHJfy49cTwfa+Tv5yrh
	1Lef6+HBv2gRmAezayOD2dL4TzoafzWhhZ1k8vJzByOivRq/5/dU0jtrsS03GB7QyvvX27t6TpP
	Mlw7lCo3Np3HR9Z7lPcZtpbQro+IYq+X/oCok2Zee3M+VKcvebARkZzMSV9/1AiDgHNP1m6/xrq
	74RXSAaM4dLwzJreC02NOoxdBhPtldzj/F8Ue+TNsqMaCQHdH0q+2CYgM8JcL+Ht23O0u7umx+V
	g54XmJtB76XEtxM2Ul0SHLvUzCffdG1vzjVEAUTtLzJAUQdzMpLzIsnyTkIux+riKvTFUtfJdb4
	+Qzcnh9tIWJiWbzo9AdWYPdjOZ74tgWAIW7GxX0UV4jcZc7TrAopJLm02LZIST4FXmS2ByA56NF
	MvcTVjTUFIK/9PA4jz5V1zTzuEn8MSc8A/yukg+Ee/Z2T1hQgZT7/07kLlWNEPzWPXMXlUfLi7n
	9oDKJw==
X-Received: by 2002:a17:90b:5606:b0:38e:6aa7:68ad with SMTP id 98e67ed59e1d1-3933b7fae6amr16351451a91.5.1786831121788;
        Sat, 15 Aug 2026 14:58:41 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394ea9722fbsm7233622a91.3.2026.08.15.14.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 14:58:39 -0700 (PDT)
Date: Sun, 16 Aug 2026 06:58:36 +0900
Message-ID: <m2tsovoxkj.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: broonie@kernel.org
Cc: ljs@kernel.org,
	linux-mm@kvack.org,
	geert@linux-m68k.org,
	daniel@thingy.jp,
	shuah@kernel.org,
	kees@kernel.org,
	luto@amacapital.net,
	wad@chromium.org,
	jackmanb@google.com,
	liuhangbin@gmail.com,
	rbm@suse.com,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org
Subject: Re: [RFC PATCH 5/6] selftests: run tests on nommu architecture
In-Reply-To: <4355a510-2e00-41f7-9bb3-8f6b2d95503b@sirena.org.uk>
References: <20260813063401.1786548-1-thehajime@gmail.com>
	<20260813063401.1786548-6-thehajime@gmail.com>
	<an8MlE22U3586R42@lucifer>
	<4355a510-2e00-41f7-9bb3-8f6b2d95503b@sirena.org.uk>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 03D17180003
X-Stat-Signature: 6oa4c3jugh7zmshtnrreors4msgr5h18
X-Rspam-User: 
X-HE-Tag: 1786831122-12006
X-HE-Meta: U2FsdGVkX1+ynfMODEZkZijCyFs/jipIwXJ9fLXXOn0A2KViLLZ1V6N512OBys0ak0NJE9RtlsaLkHr3rbyg4+z+93g6uxYB0PyrI2pyiTtHphVKsAk15M1Ep0k4xL6NiPTWQBC6jWZaz2RsQswAQ6kmykoTOXmuLu79yL3cFTVgrH/a66zgZDCD4mbEHVYcNprh26FHWmyqxYe0ucRDipebC+gguo/LHDAjnvi4xd62SPMZZj3impqKBlQswq79+P1y5K+bQV6zG3E/REttPi8nO2w56Ix6YucKyzCcgTGjx8RWx0RRVk7zlBNp97EEoEd/fFxkbvWAND9IDpi/zprcAFWfx5HNZyqekKez8pHb1uvA3+sej4bQnZEktl2ApvE+o4ugz1Mwi38nqZCBGDhmsTvJ5IzAwI8wyXKEtnXjPYijB9Wsau5lyCezd9ikSjCe4yLdnYJQtk/N+V/io3Uh1RvIrEHozxlsj7k9WgnWaJZ98q7Mn4b49Ng+AhBQBaamQlArwSc9eY6i6dDRSPjXakhu+eFpQ5eqS4z6uIIWDEj8ZISH2LDRjEaILQxwwbnnwanyt64F2ZMchuA2PSOcJePEKG0SQlScTj4O2MoAgV+U3Dz7mvHwW5lj6nJog6kE7mpJ8BnGJbyK6srFyHqvuR40YVity7iyXlubuXwlkGwyaRBbWX+jORJ2+YoNDrK7ddRmpeCqHE0bfnPXZnvNOMymKraAHIgqEqSL4W4F7flulJ2tDncCl3LEOdNJrVu7A7tu6KMukQnmDxGp+XOLHi/SWopsvxJqAjAS16cu04Orbr7spKKcL5SRvyrtIAJZ2ta7OMRkPZO98FdrJhYpHL2zu45/tyQEhxr1kBHAmFTxUVjKcQ23iLKFKuo6q0aRqz6ttYGM47ceJ4IMhO6hEtTOblqR9g4eb0iT1yIQF+jd4VJBDBBHvNXaZsQsQrJNFOys7ZoUmfIMYLJ
 jPPTE+Oc
 rb8jUA2Bz/dP6gYoDz2vq2rLNxyALY26rQXvxcMOWaUWa4Orv5PmeevOLrTe/ef7TbiRXdnzeiJY78587v+DrOYoTpowDBGkywgrZokCPHPUjl3/gMG3mlMBBUxxRgB8G8GH5SEi4v//MgMTEFVanXmNZw7Ri+KQBQkqCLXNvyTtZlgUkhim1b07EI7hSSKPNzg2pPWCAlSgE3cGvuo8gTnZZqFq06KkVDsUUCnnd/GZSoGNf6lRL284oodI/hvpHhVXmViJMMkXNbNapkt94O+xAA3lscH9nt0FqywqAowl+md74p7vqHgxa3Bdz7ryLmSJZgJaYLW2ObDlIT2VRyLjlQICMP9CoxikrCGlRR9tws+sn/jKHQiTvK0OcWLxeK487FH8DSHf1TsE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello Mark,

thank you for your time to review the patch !

On Fri, 14 Aug 2026 23:34:15 +0900,
Mark Brown wrote:
> 
> [1  <text/plain; us-ascii (quoted-printable)>]
> On Fri, Aug 14, 2026 at 01:50:50PM +0100, Lorenzo Stoakes (ARM) wrote:
> 
> > So at this point you're not really running much of the selftests at all,
> > and are only happening to run those that don't do the very basic stuff
> > nommu can't deal with.
> 
> > I think an audit of existing tests to figure out what works with nommu vs
> > what doesn't is really unreasonable again, given nobody tests or seemingly
> > uses these arches.
> 
> > So this patch might beget more nommu carve outs and exceptions and
> > therefore nommu workload and maintenance, which isn't really sustainable.
> 
> > I know I complain about lack of testing on nommu, but at the same time I
> > don't think running arbitrary tests that happen to work on it and who knows
> > if they are valid asserts anyway really fixes things.
> 
> > And given nobody really is doing testing, it's not really a great RoI
> > here...
> 
> Perhaps a good first step here is to start off with getting some public
> CI set up, then build up to getting things running cleanly.  That way
> there'll be visible ongoing coverage which will help motivate getting
> whatever changes integrated, and if the changes are done bit by bit
> there should be clearer explanations for why they make sense on nommu.

thanks,

I'm currently running tests on my personal CI (gh actions) but try to
find a public one to be more visible to others.

> You could perhaps use a skiplist to ignore tests that don't work yet so
> the CI starts off clean?

thanks, that would indeed make nommu tests more cleaner to integrate
as a first step.

-- Hajime


