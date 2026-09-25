Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C851C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 06:46:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733336B0099; Fri, 25 Sep 2026 02:46:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70AF66B009B; Fri, 25 Sep 2026 02:46:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621156B009D; Fri, 25 Sep 2026 02:46:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C3606B0099
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 02:46:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4E68A6A43
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:46:32 +0000 (UTC)
X-FDA: 85251351024.26.6B8922E
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf06.hostedemail.com (Postfix) with ESMTP id D7FCC180002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:46:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IFiKys9n;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790318790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FMYQeYmwapr9qKJcU1TiAWf7WUGFTHj+8reCqdf/NZk=;
	b=aj35xkHBbZFqc3l1KTNhtwQSP/W1lslQc81GnUkjujE3NKjrK0z7gdLNwX9Q2Vtfi1kiix
	rG/ZzuFHLapqZNJd/sH9r+2CN6JZv8JyXOvKJQWJRyvezim8wULFitRgbIrcZzHQ+lFfy7
	QOWXwh7CtoN2HYF90g4kUpNayMSBsEs=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IFiKys9n;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790318790;
	b=1lAZMXXvPC1FRJJdtUkfCEq0UuJtM5UtQZLPGtEuHtSP8VMtWtASOzTAbNNgSqEt6uDqCE
	rofQmq6kVB7LBOXclzHXYhFBwWtjSr4/sr7o0kgT4HHty9OPEJ0fZOnqwVJou9k+uoOtn2
	cf27ff7vw76HsRULZ+tvlkB9i5uJ/V8=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e66390995so2909425e9.2
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 23:46:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790318789; cv=none;
        d=google.com; s=arc-20260327;
        b=eLx4VTFPOyJ1mBOU8FKq25kTyBeNSKpuS2FCStf3Mx0SC5Q94xb1P8rdHIZ7ER68NJ
         2rnaL58lNwL/F8UEv6xCEtGTOqY9O5OEGn7ych5l/bOCYggJt7MesqR6s0j2jwKeVcFX
         w4YkVlMmPph5ILHAC/KrvuIcSWb4GBziyoPLE5FQDgZeJBx3HGGyYRe4ZPW7tltGSSpH
         pRmF7zRoH85mzD8qHrEAe5ttcS/Vx8darH3MczPCGg8NqYeRz9AW7oqZqn1KOer3CyFe
         QDgNCjKvn+wj1rN4bDY8BMmI2XMpFBKe9DX5xe8FG+gGV5qySXIqJQ30oadny+RZnJ/9
         w18w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FMYQeYmwapr9qKJcU1TiAWf7WUGFTHj+8reCqdf/NZk=;
        fh=UOzyK74HFgLy4wlshtbtXjHvj+Nw1R0hR2MgQg5POkc=;
        b=T6kZac23JXP8KMJYQ4kW69lAS/eT8fKVzU71hGU1eCcyzesjAsP3t55Kh1WDvAJKPu
         otb2vsEKka+IfFMD48kUGrsW+CmoV/AWuJX8E5Nl+02WvT5kHMJqAaT0DS/ua+fcYQP5
         t2tfim3vj6lVpCBqM8q6ZN3O+nfI0nsMrk6SQVSit4ZsSPXpcLcDUTDz5e5+d8nM0nch
         IAFlOTw4zcbnGnuQVQSBAlpHbaz4rKoxVqBhwhN0n5GSAy7Y0sZLqLFio6babJSIK4Ta
         abtm5pxRCeJmltFCLtkbrjAMUKMfvu29PgIGbfBkA89RWhLvwcrnSpSW1Q7RO8Ir9ZkK
         nmlw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790318789; x=1790923589; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FMYQeYmwapr9qKJcU1TiAWf7WUGFTHj+8reCqdf/NZk=;
        b=IFiKys9ncvbKCFnGjlkE5bbUEdljiNfAZBfBbQBDOK0teWYIyqdw2E19d8QMhvyv2V
         XnY2ZrJBMEVmolOSde173KLiArFqTOlJ0yXYD6DTyabrdCn1YR7D1COU3cRXgZ9dHmVx
         fPviL4tWfaIFpreguQ8pZvTIRRLt4pxTcanfj0y/fwtPl7V37asZqQh6ijUkyZ1nOh/7
         y1mrYynCVX5AgZgnE+cC9h6+xqS75My3O89VKVDhMjJnL1Qj7+whsXe+u+xvt5LDgXoN
         KsB87+H2IKC5LDyJhmTlMT1wmZva3OGALTOBnk00jtADpdHEWIXrZsrDW5EJ1TMz5Bwo
         oKKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790318789; x=1790923589;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FMYQeYmwapr9qKJcU1TiAWf7WUGFTHj+8reCqdf/NZk=;
        b=hHKp4cWiV7MS/GhhdfwERoCdE3SO2QLM3JDC6SOUGRnNVJsGlpqE1Uv8TOpyp1Ds9S
         c1Wzrxj8wekiIuVnHiMLIETlVzkd0GauecCbitckHdeTRYu71Ysdv9GtrA26zZIXYR2l
         wvSchHz2byE1Elsl+fYCk7tlq7qI5CM2tvQIkBvuqnjGzUNmS2rT24BvjV6+ThDMft+B
         k/S/J+xxGaH3iHIc4ge+OOst1QLk4M72IDODju61+Kb+ZisYh2mQ+H/MyinGi0Vzy02f
         gZa56eASaMUADb93TQieOYYCK+DhImEBfcn9rbelF626Z0sjge/YjBeNwv041dxPHjed
         aU1g==
X-Forwarded-Encrypted: i=1; AKwUvBw6Ah/Y1spg7xQdQsRErqKD6r9aNnNAxmyJGM8DRx8x3H3e9nn4LRirOIENfC+JJHK9ryN+13bZqQ==@kvack.org
X-Gm-Message-State: AFuF++nMrSN5i3mExc5pnEqHjmnk2Bav5HNyUEK+wMeDNJF0Tg4mJyD2
	rmNStUFP3FFx6BI8unV9bAdXv0Yo6ZDieCna02HQVNfV1z69QlZmPK766Jv7myhJ8V/I0sVmiEH
	+WgpSUiHOMMTJfeMkZ8NgCe1XihJuRr0=
X-Gm-Gg: AYBFou0U84hSRehrShNEkzLW5wy3XQlYZpCmW9x35bUx9UbkaFOM+LnZk3gpuGZxgfY
	uFwZ8MyTI5weBeIihe4n/h89SeMiuaBAoCdUrVHcuId3l62hzs1K9h2bwoG67JwNTcfTl72g/KI
	PeZ8cZ5jdJ1rJ9B+su2CRFNHFc4Ze8B4jHmrOAzBawbCNYelYsZ3n0ujdDjUwJiakxaMLwLZ2CM
	/jsQ9asj86RrebSpllL9R99gSsahpSYrCi6VT3UMDxB7mqniN7eqrXFy18Unkilm4NYnc55hzxB
	m0pb88t75SNRT+tuI+LRV3I8h6XCVECn7b9X6GNJcumYKyvuRFZUVRTTuAIcr6jKzX/s+eaJ97a
	bVHTEFVb20qfQZg==
X-Received: by 2002:a05:600c:3107:b0:49c:cee2:1697 with SMTP id
 5b1f17b1804b1-49ff06e502dmr21437475e9.16.1790318788803; Thu, 24 Sep 2026
 23:46:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260925054408.10431-1-lance.yang@linux.dev> <20260925055807.32678-1-lianux.mm@gmail.com>
In-Reply-To: <20260925055807.32678-1-lianux.mm@gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 25 Sep 2026 14:46:17 +0800
X-Gm-Features: AclHuK_RfCuOCjo48ccB0F6bBk20RwJxdVKVRfQ9R5t7EYWoxDxogjcXf0echJY
Message-ID: <CAN_Opa878W14HLKZHic415SH20dHfJQwxpaZu0LXnLMsc5Pqrg@mail.gmail.com>
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
To: Lian Wang <lianux.mm@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>, sj@kernel.org, mst@redhat.com, david@kernel.org, 
	damon@lists.linux.dev, linux-mm@kvack.org, virtualization@lists.linux.dev, 
	Kairui Song <ryncsn@gmail.com>, baohua@kernel.org, xueyuan.chen21@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 6qsnhocq3x33xrni4qpfa31xhk7arwrj
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D7FCC180002
X-HE-Tag: 1790318790-864269
X-HE-Meta: U2FsdGVkX18mMFhKzXYjl22DXdamoVQG2mo3Yowr2A/KhUms+bIKBefUd5Oc4xIAOpIoKSe/86V2++91Ibo+vuqN8HXLcgsQ7s8dTc+4Ums4v4Kq/4lExKv64kNWxzsuxNZBXQPcIvNvh5WlAmNk6A9BrUGWG2t/lY5+/NYguaOhoiLUoGeL9TVpCcCpceoxUqfN7mxZFufAQOFgu/PrTGrFBLf6dhS8Pj7sWyZ1EEPS0N4wxMybyfgobCJqdzUZUO+EKuM++0WVtcs5pOoIP30FbWiMtDvEn5Zd9rdU3nin2+KPfxIVGUa1AEDBAG5c+vdOsaAW5QWlPXaDa6v1XVes4E/jH6v2/tedB/DjoiZtgmK17tBjZHg5IhlJY9kl4IheWw5iUN3ejybdGaHdM4EzWghQ24eotChvAk3cmZIZ792bBLY1iozv5SnfWswqHjTybycfZWIUjK8AmdzPqGaOnen7TaG7ISHZiaP6S8wnEeU2FmMm/i3toOJGjtKgV/firiYfG0bJ5exWy1b9Jaufc9HjirfhAOpptXr8seosrTmswwvWaw9AZksqQSdCQ5+VhTKgLOTMumeiLZvjTqQt/ohuM6Ctw1hQ2ibg5JO4x3Hpiyz1Aq3Z+QlofFe5ofRrBGYE7ItW05n5OcsVBNpeskRFYSXBFpoUBT2/8uzzDWQzS5eF2om0ocFOLtW8Hh7xZdeoKfCnYLQj3+oin+yDLW60bV3pSas8u/jJEigugxxpHiIdI46CO5RK9rvVB0kfY1hW0Lt1VlOuBpC+jSMLVNBYgtriI/42TwMf4P2sdMNmmqWCqiO/kREYZioxAApPHQflZe0gcsJC0E0JdwQK4EGvGzGWPo3z1KMTMir95ixRlY4S4O665WyEiIc/I3mE1Y3SfPLnifktsz4GaE71ksYJBmZZO0x81i5uZrlajCTqW+RxBKUSaoofXEDWAYjNIpU+VeKy3pqaIOV
 L9mxi7Kh
 nkgLNpDdBwBaDCKj9vgs0Q7+76yi7Y1gWJ6sxZUSIPXroNKI+CPTTK0Y5q6YTgSSXRCFrlQ4Nnjssk985VMoxLWwU+xLl5ltiD2p+MdUFB9DBKANvFtRPr2LKdwQB2wN9ogLjX2jCWYAMmx81AhgMxRjD9BJ4/cmhI2ZA9VNB69GrlwD+bSLUMlaQ9nmNWrTR4cbmXOzlxcLLNOilHsyEsSlG0yDzp6cfIeK0MB1dQk9ipu0DTkvfNUQDixIJF4ubdgLjAzIhejlpDOAfVRCdAZ71iuh1ijArUuENnzeNaGmMYfHlH14rPoxlW5usRKEBKu80wVAXWcAFuAeCdK16zuqooIuQg6eSHwCohOQEwihn+l7HxjhbD5I4UrzB7o3vKPNL3wey9MT8MefvDO8bByla7tw8xV2eQToFrx44WVxloNxzHx8P728NZbXCbJTaA2QDpSgX1Ego40ije8YzrWC3sZbANoxJgoTn4EPFpJRwerBgRRZJtEINyuzOVSYwqpOzQ3x/Lxj3Aco=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lance, Lian,

Thanks for sharing this, Lance. I also saw SJ's post yesterday and
was very happy to see DAMON being used in a real AI production
environment and delivering measurable benefits.

Hopefully, DAMON and other MM features can continue to evolve in the
AI era, better supporting diverse workloads and real-world use cases.

Looking forward to learning more from the DSec experience and
discussing this with everyone at LPC.

Thanks,
Kunwu

On Fri, Sep 25, 2026 at 1:58=E2=80=AFPM Lian Wang <lianux.mm@gmail.com> wro=
te:
>
> Hi Lance,
>
> Thank you very much for sharing this and for your interest in the related
> work. It is great to see DAMON and virtio-balloon being used together in
> another real, large-scale system.
>
> One scenario we have recently been studying came from Sangfor. In a KVM/Q=
EMU
> deployment with guest memory backed by shared tmpfs and host THP enabled,
> host-side DAMON can report a much larger hot-memory proportion than the
> guest's fine-grained activity suggests. The related discussion is here:
>
> https://lore.kernel.org/all/20260915025514.2434-1-lianux.mm@gmail.com/
>
> We are preparing more complete experiments and improvements around this
> scenario, and we plan to discuss it in more depth at LPC.
>
> I am still actively running experiments based in part on SJ's earlier
> introductions and our discussions. After LPC, we hope to share results on=
 a
> more regular basis, together with discussion outcomes and reports from mo=
re
> scenarios. I believe DAMON will continue to become even better as these u=
sers
> and perspectives come together.
>
> I am also contacting the authors of the DeepSeek paper to learn more abou=
t
> their setup and experience. We hope they can join the discussion so that =
we
> can work together to improve this area further.
>
> Kairui is also very interested in this DAMON use case and may already hav=
e
> discussed related ideas with SJ, so I have kept him in Cc.
>
> Thank you again, Lance, and thanks everyone!
>
> Best,
> Lian
>
> On Fri, 25 Sep 2026 13:44:08 +0800 Lance Yang <lance.yang@linux.dev> wrot=
e:
>
> > I was reading DeepSeek's new DSec paper[1] and found a nice use of DAMO=
N
> > and virtio-balloon:
> >
> > And it worked: time-integrated host memory use fell by 21.2%, while pea=
k
> > usage stayed about the same, with no significant CPU overhead.

