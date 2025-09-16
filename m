Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27C9DCAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 04:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823F68E0012; Tue, 16 Sep 2025 00:39:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FBDC8E0003; Tue, 16 Sep 2025 00:39:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739048E0012; Tue, 16 Sep 2025 00:39:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 619BA8E0003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:39:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F291CC0840
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 04:39:16 +0000 (UTC)
X-FDA: 83893859112.26.B599CBC
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 29429A0006
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 04:39:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DLYWJV0J;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757997555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9R6kQ9nEgywpeDIkgPPLCORIQ6RGJTSFvVt66zj4n+8=;
	b=ZJdcCAuhTiB6Zezk7Ks1x7imJDF/WJEqxge1zI6dnp9FrbVJ3Ayh3LQ2gp7NP4+EgZj19C
	H/Vv5qQlR8APsHu7yjYchzvex+dGdph1Mll+tOi8OstVxMtc4vNqH5wL71gLWUAH6o5+O6
	wmHILnmZbWM334lTQSCZSXe3Z8rEMB4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757997555; a=rsa-sha256;
	cv=none;
	b=KjRlGTSkzNTuISJNMrOsCY77IvZ/f+iWKPc+y6vAfREROORv6CZSWtt1iS0ChoTvcjvYlp
	SuYwKdGRR6YCO1sT8ZReCifb9Jl2Q0MD41VvotWjwj5oMuWVRC6N2x0vU+4mSHRcYManps
	Z1qyKRDAPkKc8TgJQLQCEz5fo1orV9M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DLYWJV0J;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b796ff6d45so147931cf.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757997554; x=1758602354; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9R6kQ9nEgywpeDIkgPPLCORIQ6RGJTSFvVt66zj4n+8=;
        b=DLYWJV0JVtyH3GX+p1lIAn12fpF/MILIpqZvby6DqitSDzdBzn7bOZnnJ51Y+vSODQ
         TwtCW48HsV5RJfQio/LNo364p7voeco3qarR4QTEEbMnBaw9Db7ojiEZbqwWOlt0s/n8
         BfuibYKTAWp2CMdKghkU+lOn1uGlbFUQNbMJgu63Y3aeqqybipA8uCJBdwiSiMGy7Xuv
         NbblZ0PMjjxXkKJ2W9fTUfhx8DkbCFbNrRb8ZvRQ+W37HE5KQ0IL+NoGiOBylIXxsR1s
         ODN0Sjnq+g291v2CaNJBUsD+KfX++aJmsnKrOmwsgJcDumUJtMOyXO8lD+5lw1F2nWR6
         mgHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757997554; x=1758602354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9R6kQ9nEgywpeDIkgPPLCORIQ6RGJTSFvVt66zj4n+8=;
        b=Qa/0myikB8Q3CyG8+xMwx9EO7pCQrhYFtgcDVGMB0/lV7toiVINSRP1UtVdzt4ESI/
         8wEnmvIKKrLlzw6D/chUhlserQUdiGUiCLaiZW4RsOZek8OA809Rc7SaC8TvYtpFMOcL
         oCRxP38k8fnzEunbNLFYzaLnGZM66E1/io4i8nwLl2wO/NRsiT97EaFtuUdZbaeEixok
         +0KYFX9xTquZnXN+5XOfOdBfq8AIr1BbKyZT4CtZbnmmwS/goDt47o70YRhvwHgE+DTo
         7Z2kswWLZJOGuR9YTWK7pcr1p2cMXrP8fA0ISeu9atxwFnH83DLBWy2zVMEHTkU6B37f
         gD1w==
X-Forwarded-Encrypted: i=1; AJvYcCWgU2yM26omtVlvdKMYrQX8eQyg6y+2C2nSqt+mf3jUydbLn7/uRHGTXXsi2znldzib4KBmD8y5Nw==@kvack.org
X-Gm-Message-State: AOJu0Yx/BdKGbXnLYI8i/jLqi4+7wjmdRAk29AMCeE1/yvvlHgPgSNKY
	Us3pF953YABfaDU8FiDapbK1W++2gUdzfPMnh8w/s85DaZSOHF81lKf/kEJra54eCnPh2eyfORX
	a0dkzT21Ku8QLiYcPhmlqHVSc42xpZnzFlkCKQIvB
X-Gm-Gg: ASbGncvifsL+LtKYfQsUSijSqWllY9vcAdG5ILDQjKUXnkNFlsdmEEz2v8e0m0/iWQE
	2k7NrVCVxPvPjUlcAVm8SPkX3ENygf6uycnyogbmeRSnmyiEtaJIPmKuHgyLIKQ+/Mu/qfMbGjt
	0MQ1uTmZq9M+8DVMnYOMWZMWBSPwSHwAq5KSqNL1gOQKIw1vXEWhZP69Rh77F7sLcOIGaYGHLJl
	Gi7RsjJQUIb
X-Google-Smtp-Source: AGHT+IGy2zUeUVgUuFT4t7VWEdEjde2wG3xmJbbzOEgNSuq/gMX0RcKVbdjrWT5skjoaUgdj+RMigu48osKUGCiYUHg=
X-Received: by 2002:ac8:5846:0:b0:4b5:e600:3d6a with SMTP id
 d75a77b69052e-4b7b1d8295amr3905351cf.12.1757997553736; Mon, 15 Sep 2025
 21:39:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250915230224.4115531-1-surenb@google.com> <20250915171112.f71a7606a7f9fd3054662bed@linux-foundation.org>
 <CAJuCfpFQCgQLSrzfVjV+J4tkYbOx_W9v-kWmoo-rmh5hs9gEXA@mail.gmail.com>
 <20250915195633.96236cecebd8777243a770bc@linux-foundation.org>
 <CAJuCfpH1JW8vwOFF2H2SOxZqoJHadXsTc6C=LUS_=twcf=k9qQ@mail.gmail.com> <20250915212133.de5b8522137a5ed30efe956e@linux-foundation.org>
In-Reply-To: <20250915212133.de5b8522137a5ed30efe956e@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 15 Sep 2025 21:39:02 -0700
X-Gm-Features: AS18NWDHXLFv3lNg4PYk4Bb_peo44MLmDzNlQvZH7VM8bIBPMPrwoAZZ-W4no6M
Message-ID: <CAJuCfpFonUPE0FL5XGm0paYp9ZXeAKK6mjHO_8hUkyxfyduL=Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pyyjason@gmail.com, pasha.tatashin@soleen.com, souravpanda@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kxuzo5ejqfuef4wi7i5job8ru4f3an4t
X-Rspam-User: 
X-Rspamd-Queue-Id: 29429A0006
X-Rspamd-Server: rspam10
X-HE-Tag: 1757997554-660009
X-HE-Meta: U2FsdGVkX196jTX3LbYpDJT6VplpgioGxlPKqhA8zTJhggR9qV5LbRAVd/v5vN25EK7qOCO0j9ndAR1CycH1vKGe0qV3aKJXz89glS0Yxat4tQGI7Hyt16G5AfFSiRCI7tkmiNw49s7VK+stBuXDG3qOXw9usSUELNhDw+1cWz5E1NQSetk3rXgJ8/wgi3rRszRISUMhRDgQcBoAWlQz59bvWpgagQ1fTIbdtUI7dq8W358371srC+umBmkfYZtZiYt5+Eonfc+UcJdyIVsMp65gFgd/VURqSz7XWYlV4QnrA6cZ73k1svc9svscGGAATzqtFWeGaAnHAVegbO8Bh0JUPDgrzv0gdy5bASC5Xa9TanEsDv8pXf0UOKPCX4c3f1/OA8iLFscKXIbCWQ4wBUZ624hFGtPm7S673RA/mvdzW/uWIatC8K0oeFp88OpgNepUGXg9xzrtmu8mU1L4i3yiBaZZQL5GSQaV8HpKUrt3myuGW64wzdVHN+VoXUIUAjamrkvgVbIcE21IBfBT4AlwM5bvxAz7aMkEzI5px7hgBKaF5D1QymDvmLoAWhBH7JXS45Ckp2X/dQLswt6sVDKOxb9Et3YCGJWsBFVZ9ioOg68vlPFLRPtUKCuNr2pHJ2EWpUb4i9P2fx4lJMngqlrZ21aBe3m2gGEB0G3yZlc/R2wcLFQo3jvuWvQkQsbfnXF3xB6CP6peImbrbkyjNi/o0/DS/krY7FRKgrB4wOaXUlbZHZv1dKJFmQVMed5Y0CPBEYzgTeAzv4wSCB9dNQw4Xf5FgZq7hkqLJkf0falQ7Ft6n/iILSdSlpFgtgA8nGoeZWncUh5W/APF2+iXWIKr9RG+vHEbN9RXVjcQ7y5TV/g3E0aeJR08U6DNkSCz1VAtJBf7f0U+3NwgTdRUm3yACzOot93IX3LTIxu/EUPCwAyIdhh6xuomXEE4NTvKpBmixND0nkrYBla2HXi
 Zz/0hUtI
 dCZDtFRBmBFpnf1vctLs65ee+50DfJylT3XNoK7+vqi6y3mDDnxveqot12zGHHUG0hGIF9+JgFwTeUbAZiqiBX0eNuVBvD65Bdwl2Oc2InggJ9y00k+irhyfccUbvxhST2q8GQBqqLTHJo4hbzMyoKypycTQJzorzCIa+UYOsTfiU5km4jQ0rHTmpmI0a/gQJ1+rC/B6T4oInf53uWcqUDG3J61T3t5fxLy9/mLQrRSUA+xSqB04jgXC7karAiCCah52i3Jg2nA2AyneW7Af8RiqmKrDmFtx0wNz/y2PCkNErBUQsxkGujTY7Fs4HLIVefIHS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 9:21=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 15 Sep 2025 20:34:33 -0700 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > >
> > > > could you fold it into the existing patch or
> > > > should I respin?
> > >
> > > A little fixlet would be preferred (by me, at least).
> >
> > Ok, should I post a fixup patch or you will do that in-place?
>
> I think the former, please.  Your intent is preferable to my
> interpretation of your intent and we get all the nice patch metadata to
> track everything.

Will do first thing in the morning. Thanks!

>

