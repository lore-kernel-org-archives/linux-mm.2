Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69FFCCAC5B0
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 20:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 738788E0003; Sat, 27 Sep 2025 16:39:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EA618E0001; Sat, 27 Sep 2025 16:39:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FEE08E0003; Sat, 27 Sep 2025 16:39:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4D94C8E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 16:39:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF43687D19
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 20:39:42 +0000 (UTC)
X-FDA: 83936196204.13.2CF809F
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0426AA0013
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 20:39:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WxqwpI30;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759005581; a=rsa-sha256;
	cv=none;
	b=OZuCcgt2WOJFUN8sfTbU5JIgqcLd8xa72cEl301ZJ/1gSy7QOFU8urPXpgl3hyeP2USlsA
	CMfsC/czfHNQdcXJo7ecTN+OrSlFQtlUzq9z3dNIStccD5sf5h0Q8Eo8JtttWGLHf/1uLj
	AcEWhkozhzCdat/5wQPl8kWg7mCaYac=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WxqwpI30;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759005581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nqm2a1slgwRpzw6giHb6m2YLEyBBuzMrjpXPrRVXwQ0=;
	b=qXI0128Md77hC729G/Eqc9UIPU4VKkuP0GOU+wbbmS2MSZOjffKYIN7aYw1AWxp1vAt+z/
	b0MWxi3kJSMz4cJFVPkpLEfT3pj6yQhCm1RAeblWjRCpKbBfdm98Kf6lf8rHBl52Ne+Dsa
	+etTexrGZuO1pqVvNeNbOUFg/NroxIQ=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4dfbab4fb0dso5173451cf.3
        for <linux-mm@kvack.org>; Sat, 27 Sep 2025 13:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759005580; x=1759610380; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nqm2a1slgwRpzw6giHb6m2YLEyBBuzMrjpXPrRVXwQ0=;
        b=WxqwpI30LPWJ+DooUucx/6PUHLTdVfzRpnIFmn+R9Sb/lH4zOlEOLfgObcLoQlYOcY
         rFxhyl7iRuecZg1nyLiotVOXzxVp9L+Fdh0tHdOifLpAK8AZij6CyvogKVsKkTt+2iGA
         EF8n1Rfo+x/uKS4Ni3/+GHZcFocEyAbkQ9Dpx6PthtTDHdjeD6PsPn9oql+6+CAUJhuG
         3KUqc7zctrC7vmE8BeAMlYJmcAPT1GYx26HchtXBTn5hv9rohmyU6aBHXK4mDbqt5YtG
         S08bQ7C3avHJzkgrhpT8AdseNKIE6ZMosSgVMyBnXJZTV6vTtlIhs2rH1BNVX3gurtrK
         uONQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759005580; x=1759610380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nqm2a1slgwRpzw6giHb6m2YLEyBBuzMrjpXPrRVXwQ0=;
        b=L7G2bRrIq0Z+M2O8GeKFHQwBXqkRs6Jm6+bOn4X0oG3Ac3JJxi1xYxad2K4xXu/Qi0
         hVOiaJa39gseppkB/br0b179RmuBCkWmZ0jYuNOmmH3nN/EZe/hASghgmNiA46xsihEQ
         kNUWgob8vIEvatf/oC9pBV//IAvFrIH6SnfzZsnpE/ntSzLMv1to+2RE496iftp551r2
         47ZEAXnihdaWG5zaSFBpT5g6cMNWJLqNieu7EF4a5RxFYDljfHB9yQctlcy9HjE3dzmo
         fB2YVvKJbylmutEQBPlc2xx47/dfhNKLsboVaSieFuWITKrRwFZgZdIP9YjwA2yiGq0e
         euRg==
X-Forwarded-Encrypted: i=1; AJvYcCUXJJSPgkHWeFN4ME6mP3WbyK6KTnd5JWDylnMlteEQi13p8yVWISHSbTWBl92038w3qHB1lOnhhg==@kvack.org
X-Gm-Message-State: AOJu0YzzMJvFMnO5BBZto2Dzt1GP3UcVoN+T4HE/DYi9u2R5fcCvMhWk
	Ui78ZPM66gRojasIximFALGc1O+8RpEJ0Voexjh/kpPVNK9k9cG3yVFR4yS+ZujVVQOqjY6wJ+S
	vSEYF7XZBJTD2GxnYetrw+IJp58cGCafiCNHIOjfCGQ==
X-Gm-Gg: ASbGncvD1v1ARTQro9BwIro1BDoe2bCdPzrzlPpU5SUug0vHB5XmsqS3QLlck/db+IF
	XwB3RWsagNsvAES+EK4PJsNjLBejAQPq2OdSVxiMEysQ0pWUDd2rgJBXawyBQno/Z+cBDjt+BLl
	nu3TL7cqDVIvLaqNirrYVrNnZvnLVyr9AapL8k3V3re8XnmStAzbqs/AqB3r52M7b0GB0qHH+1I
	hE78KVgHNXWaLv/5v9MsO/hNQ==
X-Google-Smtp-Source: AGHT+IGBzy4xKVonjD75U3bFZeJHdh+aNj3HgTEf2iQJ6Ivdld2/QWu42FO96m5+KzxRvbcmbaVonTr0xtmksT79s30=
X-Received: by 2002:a05:622a:4cc9:b0:4cb:102c:56b2 with SMTP id
 d75a77b69052e-4da41e113ecmr158400271cf.0.1759005579868; Sat, 27 Sep 2025
 13:39:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
 <aNZWTB_AbK1qtacy@kernel.org> <CAM_iQpWBHWscTbuUm54G3tvqf-EQhSYaFJqEJD4M73doeH=TKQ@mail.gmail.com>
In-Reply-To: <CAM_iQpWBHWscTbuUm54G3tvqf-EQhSYaFJqEJD4M73doeH=TKQ@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 27 Sep 2025 16:39:02 -0400
X-Gm-Features: AS18NWAcl8Gu_k5gDYsA34u-oRSTQGnYnzR7vJJapQMSC9amp96YmIxuBqedkv8
Message-ID: <CA+CK2bCFBOVQnwvRePHRkDqdh5rA+QYrkhqvf=ZiHu=yicShAw@mail.gmail.com>
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>, linux-kernel@vger.kernel.org, 
	Cong Wang <cwang@multikernel.io>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	multikernel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0426AA0013
X-Stat-Signature: 5kqsfiw8rjdfnrxjy78nme4m3bxfihzt
X-Rspam-User: 
X-HE-Tag: 1759005580-701581
X-HE-Meta: U2FsdGVkX18OuxlWk5A7lqtZt0YXa0wt+6oMI82AQpRPhNtu1XXIsY2P1RDjO+W7MHdNFKxilYsCt81zPYUkG3o8SKUkN1NrkiPuTy1mHCXX9TGJCFomItG9W1DZxurKEt6K2jMlrBbjJw0DeTQQdBUgPgM5HAmXQs8COqIKFn7jlJoJ33WJ/8gF/5/oRSfvLK2SxVoexs8csegaustVbzo7RuR8oZJ3lEMqbGgQj8eExSpLsCIbc5wVp7rfal/s9VWW/WHrUgUueJSx4x1LlTmE6lXfw1NoTAKLL2vKW05PNn2TrmceQr2vxpGw4mjQVS1t3/h1Zr8Kd2bLQu3UmEgp808tV+0uQtQnBjh62kpYGmwfPkn1xUAc3VGyQaUPRGUgW3l0YCoMNRZCljhRif2eJIZQfUdKMdHIl90HO7A/AQAOjcLgNpqvPkWGBQiNFn5twJbJKb5STBvRUKw4PLb0+oUY6pjMsZf43wsM2SbnQmML40x8fGSLd/LFIq6n//+LtTBKdnZgPeqy2/YpK+7SI41UntxwCDSXiKg6THx0XIcvGwPZ00ExlxYXmBnhzbe0j2ZRvLKOglVQfxLbKap/qWz1Aa/18P8khWrT0KEo+2CQzSe84/CSCBrMoZZRQslCnCpLKFiD0ikWF5yjYIm8NlCDNuunmto8oHQY7qPI1FjisHcC9Qgmq1CH4AZRMdaM76EiSzTYliKqrxxlDidBQiWU/xVjIHx89/6F06r5XdIlDyuaaGtJ2Ue/9cfWA91GxAew5QUcqew18Nz4AEuO5EiLaRKgGbxazcD4jwivFX8jJSbB5IKqiS/GPJgbjGACcV7uA4mE5p6tHMYerv1ttGbsMBb1ypVjf+u2U5NFWFlXLlAsUQd18HZdXL3AP2GmDoBv0/fj/3roXdEdN38MiBR3Gr2gmPLyEE5rBwcDBQ1fs/cZW8Kvwuv44L2hqVFsJZ1ed1GhLd7Jo73
 LNLbtT55
 NMmuj4v9vGF52BctIHHhSu9TSuVpebU/9fRR0dm8h1SvnWDvuSTIVS0JIPMBesenIQTYj0uRcl8WRfo+prBWVseL99BHMkjQHgPvI+iaovK0ftqmMUV62eeixtGFffqm5nBGIEYSHH00kgBDakV5YMO33kA8cxsDcehM26sn5ApXf773SF6+6w8mxjbtle6FpPOQdUwF7bAtb0hu5+atXXGnfqIY3/vOuVeVj7iy/GS3MYT+lkewwZsXCe76wDdlUkx0MoBXSlIyCwH3rTqX25aHhAnMl1chCW/NAn6NGDHUEUG299VbMnmWHD5ZuNn+BfGBiEm+8QgtZXw7KPn7l+T94dURNeqgU3hsmDWdd0otng9zB0eith2WEZhQISqt+ax++qOyHRDpmlS51Uo8gUONSWlwG15Q1E3EizoBMy0E177wM+SypVaVJcYwMpsUrYdUTTdYbQQLidaxnF9LfpZiicjGOteaypyKufkdxU62qQRSMlXYa48n0aDUf3mZcEtvn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 27, 2025 at 4:27=E2=80=AFPM Cong Wang <xiyou.wangcong@gmail.com=
> wrote:
>
> On Fri, Sep 26, 2025 at 2:01=E2=80=AFAM Jarkko Sakkinen <jarkko@kernel.or=
g> wrote:
> >
> > On Thu, Sep 18, 2025 at 03:25:59PM -0700, Cong Wang wrote:
> > > This patch series introduces multikernel architecture support, enabli=
ng
> > > multiple independent kernel instances to coexist and communicate on a
> > > single physical machine. Each kernel instance can run on dedicated CP=
U
> > > cores while sharing the underlying hardware resources.
> > >
> > > The multikernel architecture provides several key benefits:
> > > - Improved fault isolation between different workloads
> > > - Enhanced security through kernel-level separation
> > > - Better resource utilization than traditional VM (KVM, Xen etc.)
> > > - Potential zero-down kernel update with KHO (Kernel Hand Over)
> >
> > This list is like asking AI to list benefits, or like the whole cover
> > letter has that type of feel.
>
> Sorry for giving you that feeling. Please let me know how I can
> improve it for you.
>
> >
> > I'd probably work on benchmarks and other types of tests that can
> > deliver comparative figures, and show data that addresses workloads
> > with KVM, namespaces/cgroups and this, reflecting these qualities.
>
> Sure, I think performance comes after usability, not vice versa.
>
>
> >
> > E.g. consider "Enhanced security through kernel-level separation".
> > It's a pre-existing feature probably since dawn of time. Any new layer
> > makes obviously more complex version "kernel-level separation". You'd
> > had to prove that this even more complex version is more secure than
> > pre-existing science.
>
> Apologize for this. Do you mind explaining why this is more complex
> than the KVM/Qemu/vhost/virtio/VDPA stack?
>
> >
> > kexec and its various corner cases and how this patch set addresses
> > them is the part where I'm most lost.
>
> Sorry for that. I will post Youtube videos to explain kexec in detail,
> please follow our Youtube channel if you are interested. (I don't
> want to post a link here in case people think I am promoting my
> own interest, please email me privately.)
>
> >
> > If I look at one of multikernel distros (I don't know any other
> > tbh) that I know it's really VT-d and that type of hardware
> > enforcement that make Qubes shine:
> >
> > https://www.qubes-os.org/
> >
> > That said, I did not look how/if this is using CPU virtualization
> > features as part of the solution, so correct me if I'm wrong.
>
> Qubes OS is based on Xen:
> https://en.wikipedia.org/wiki/Qubes_OS
>
> >
> > I'm not entirely sure whether this is aimed to be alternative to
> > namespaces/cgroups or vms but more in the direction of Solaris Zones
> > would be imho better alternative at least for containers because
> > it saves the overhead of an extra kernel. There's also a patch set
> > for this:
> >
> > https://lwn.net/Articles/780364/?ref=3Dalian.info
>
> Solaris Zones also share a single kernel. Or maybe I guess
> you meant Kernel Zones? Isn't it a justification for our multikernel
> approach for Linux? :-)

Solaris kernel zones use sun4v hypervisor to protect isolation. There
is no such thing on x86 and arm.

Pasha

