Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80FF7D3B7E2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 03:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2DC16B0005; Mon,  8 Dec 2025 22:28:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B74F6B0007; Mon,  8 Dec 2025 22:28:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880766B0008; Mon,  8 Dec 2025 22:28:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71AA56B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 22:28:08 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECB7458B8E
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 03:28:07 +0000 (UTC)
X-FDA: 84198499014.21.0E99800
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0945114000B
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 03:28:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fm1AsM8E;
	spf=pass (imf09.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765250886; a=rsa-sha256;
	cv=none;
	b=4ArSWmr8olMFu5IRkG8F/IF+e7ug/+OO1/1UwjCdiY/qjdfYWZU2Sb2ftNt4qAf2kNHIWZ
	3h9VYAfeaOF6tiqj0efqOVZgg4Tu78yWq2Jz49gI3MxQ0/ip1x8plNM6oIjL0v+hOPK4aP
	jKwq513ufVZL7GjM32Y0IGk8em4J0zQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765250886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NbFVdOXb1Nr6+8TD5KZltub496iqTHAYaOUL7OnbUgQ=;
	b=uuM6wX3EY8IEYPH3rGf6DTQ4q8h/X7JspKcW2B8J0gR4lNQNbISYOded68U0nSzJ8mmspJ
	0Rfb760knusbpwM5uKe2YqbaxUnCNnnz9v+v9CNqxyeEv9K7q+wusblhClX4RZz8zdbpRp
	X0JDWxzvVkFC2y4EiFZsUsvMhIi6pTg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fm1AsM8E;
	spf=pass (imf09.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765250884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NbFVdOXb1Nr6+8TD5KZltub496iqTHAYaOUL7OnbUgQ=;
	b=Fm1AsM8E0LfOVVgw1LTPD3/6LQj5SrgYqPGEjwEJowAxPRFr883VZHuJF5Wsc/pKAEilqi
	HComPFYkC6BJlLN3SXIwHQSdPcalMN3TJYAfwHAw1Suh/DAIbrxH9XyiaGe28eSaao1Mp0
	2CpAbL71kuSqTVFWmpxtJreQAT/GQXQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-251-P4iN0WunM0CoN3RLOuYODw-1; Mon,
 08 Dec 2025 22:28:00 -0500
X-MC-Unique: P4iN0WunM0CoN3RLOuYODw-1
X-Mimecast-MFC-AGG-ID: P4iN0WunM0CoN3RLOuYODw_1765250878
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A24091956088;
	Tue,  9 Dec 2025 03:27:57 +0000 (UTC)
Received: from localhost (unknown [10.72.112.51])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2678719560AD;
	Tue,  9 Dec 2025 03:27:54 +0000 (UTC)
Date: Tue, 9 Dec 2025 11:27:50 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com,
	dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	elver@google.com, sj@kernel.org, lorenzo.stoakes@oracle.com,
	snovitoll@gmail.com, christophe.leroy@csgroup.eu
Subject: Re: [PATCH v4 02/12] mm/kasan: move kasan= code to common place
Message-ID: <aTeXNkWx/U8MB9hf@MiWiFi-R3L-srv>
References: <20251128033320.1349620-1-bhe@redhat.com>
 <20251128033320.1349620-3-bhe@redhat.com>
 <CA+fCnZeHZ4+8GOn0untumM0TE9TeSHqja9kAsbEb-+jbEFNQQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fCnZeHZ4+8GOn0untumM0TE9TeSHqja9kAsbEb-+jbEFNQQQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 0945114000B
X-Stat-Signature: biuirpm8xpj3ot9riznsuun764xmm4cn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765250884-246563
X-HE-Meta: U2FsdGVkX19C+PBfX32Txl7Dk9nQ2kR8MIexU/XN3z40tbUpHe7HBCzYN3lXL22LSmr63dJtala0WM+kJcAP6eq1H9siV4s79lDnfxh7x5AeSh2nrlz5P8rf4ASn6K0qyAKuwVLeQ3oqF7sPNW3hRouXjg9PNs89cvz4wTJ9u7eRYq0rtqysZNViPQ8nLxq0dhkD5pwo8QY7zYaqoHcLzItq2lUqUr61iHL3Mz4VmTOyr1A6rYBDMZ1kcBcAJOqUOMiaYoLI47B3ANsFsrDx7qAzhZLhfQmAPGu1pu8D9Ha4Dz7ct6+UkbfZj4ACbnDD2FvA2PqiKOMgRd4wh5JmyCnpXjMSxt9i7iZ+o/CkdikOOVrEPdfeT2ou1it8Klt2NFK8HZJ1ODuRds+NORGfwYNVmH2QZIKvemBIXZlEkh0HZGrODFywaVHWTp8AZGSu5dyn083ZRke/CYe4IM8SYi5md/shoqLcAEqmuu7qpFxhCDMI9T6DRyd2gV+i24KqUO1jUEAdjeUS1+T/y+/4IzOFW0HEmxMn6dFezWW0EODFofNHOSEyj7lmx2jlt4V6g/fyMFfxKtpXPD96SSHEZFBdQt9EDBJNMKFCQP6R0nal5m0gSSPIEa9nPNy3IQn313IUCWyEAQMi4Wd6E76rdMCbn7bwXXMQE5k5w4RhXeua8qFgP1a/UacIVrvZW9AiLFewH8zcklY2TaD6RtO0bEiUEVl3IQq3x17fcwHQ2v4vZQiAAD4sNfNVXa1u+KctsA4Kp3LqS90g+YGLIZycr5m4gTvvl+6krYQyeGvzSvQRPehrf3MCCaURaBt85UEfQLFDrjLQ4vBiuJZyzvaYgVooSjxFs+8MJHJZ8XMJWTdNDPBUTzvYwBjTGXpPlw/X3URJgMWS9C5pXfRhYpA+8b4X1WC+V+w1t4bcjjEfV7Msq97OXfHTrAkQC/yfAhJVOZ+sGY7A80XHby4+h52
 4QbLvMlD
 qVgPpUDUEDEDqX0+bXsyNyEJHmgT9hTINoDCEylL1K+QS9yeGUi5/vNvw/kGT740PXL1rSsqeDApjecPa9+M5B/u9AXic9PNyE3WAjIJNXSCWpVe93GcskBsEtUGxXuqsb2If7vxD3TZJHXjel4rMFeevmyOSnd0KVGaKT6pbJl2dO1wVmyF0n2x7Dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/04/25 at 05:39pm, Andrey Konovalov wrote:
> On Fri, Nov 28, 2025 at 4:33 AM Baoquan He <bhe@redhat.com> wrote:
> >
> > This allows generic and sw_tags to be set in kernel cmdline too.
> >
> > When at it, rename 'kasan_arg' to 'kasan_arg_disabled' as a bool
> > variable. And expose 'kasan_flag_enabled' to kasan common place
> > too.
> 
> This asks to be two separate patches.

Makes sense to me, thanks..

> 
> >
> > This is prepared for later adding kernel parameter kasan=on|off for
> > all three kasan modes.
> >
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  include/linux/kasan-enabled.h |  4 +++-
> >  mm/kasan/common.c             | 20 ++++++++++++++++++--
> >  mm/kasan/hw_tags.c            | 28 ++--------------------------
> >  3 files changed, 23 insertions(+), 29 deletions(-)
> >
> > diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
> > index 9eca967d8526..b05ec6329fbe 100644
> > --- a/include/linux/kasan-enabled.h
> > +++ b/include/linux/kasan-enabled.h
> > @@ -4,13 +4,15 @@
> >
> >  #include <linux/static_key.h>
> >
> > -#if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)
> 
> These changes of moving/removing CONFIG_ARCH_DEFER_KASAN also seem to
> belong to a separate patch (or should be combined with patch 12?); the
> commit message does not even mention them.

Yes, combining tit with patch 12 sounds great. I will move patch 12 to
earlier oder.

> 
> > +extern bool kasan_arg_disabled;
> > +
> >  /*
> >   * Global runtime flag for KASAN modes that need runtime control.
> >   * Used by ARCH_DEFER_KASAN architectures and HW_TAGS mode.
> >   */
> >  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
> 
> So kasan_flag_enabled is now always exposed here...
> 
> >
> > +#if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)
> 
> but the functions that use it are not. Why?

Good question. I didn't consider this reasonably. At the beginning, I
thought it could cause problem if people has specified 'kasan=off'
before patch 12 when bisecting. That's why put kasan_arg_disabled and
kasan_flag_enabled declaration outside of any ifdeffery scope. Now after
reconsiderring, putting patch 12 earlier can solve the problem.

Thanks for careful reivewing, all suggestions are good and taken.

> 
> 
> >  /*
> >   * Runtime control for shadow memory initialization or HW_TAGS mode.
> >   * Uses static key for architectures that need deferred KASAN or HW_TAGS.
> > diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> > index 1d27f1bd260b..ac14956986ee 100644
> > --- a/mm/kasan/common.c
> > +++ b/mm/kasan/common.c
> > @@ -32,14 +32,30 @@
> >  #include "kasan.h"
> >  #include "../slab.h"
> >
> > -#if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)
> >  /*
> >   * Definition of the unified static key declared in kasan-enabled.h.
> >   * This provides consistent runtime enable/disable across KASAN modes.
> >   */
> >  DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
> >  EXPORT_SYMBOL_GPL(kasan_flag_enabled);
> > -#endif
> > +
> > +bool kasan_arg_disabled __ro_after_init;
> > +/* kasan=off/on */
> > +static int __init early_kasan_flag(char *arg)
> > +{
> > +       if (!arg)
> > +               return -EINVAL;
> > +
> > +       if (!strcmp(arg, "off"))
> > +               kasan_arg_disabled = true;
> > +       else if (!strcmp(arg, "on"))
> > +               kasan_arg_disabled = false;
> > +       else
> > +               return -EINVAL;
> > +
> > +       return 0;
> > +}
> > +early_param("kasan", early_kasan_flag);
> >
> >  struct slab *kasan_addr_to_slab(const void *addr)
> >  {
> > diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> > index 1c373cc4b3fa..709c91abc1b1 100644
> > --- a/mm/kasan/hw_tags.c
> > +++ b/mm/kasan/hw_tags.c
> > @@ -22,12 +22,6 @@
> >
> >  #include "kasan.h"
> >
> > -enum kasan_arg {
> > -       KASAN_ARG_DEFAULT,
> > -       KASAN_ARG_OFF,
> > -       KASAN_ARG_ON,
> > -};
> > -
> >  enum kasan_arg_mode {
> >         KASAN_ARG_MODE_DEFAULT,
> >         KASAN_ARG_MODE_SYNC,
> > @@ -41,7 +35,6 @@ enum kasan_arg_vmalloc {
> >         KASAN_ARG_VMALLOC_ON,
> >  };
> >
> > -static enum kasan_arg kasan_arg __ro_after_init;
> >  static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
> >  static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
> >
> > @@ -81,23 +74,6 @@ unsigned int kasan_page_alloc_sample_order = PAGE_ALLOC_SAMPLE_ORDER_DEFAULT;
> >
> >  DEFINE_PER_CPU(long, kasan_page_alloc_skip);
> >
> > -/* kasan=off/on */
> > -static int __init early_kasan_flag(char *arg)
> > -{
> > -       if (!arg)
> > -               return -EINVAL;
> > -
> > -       if (!strcmp(arg, "off"))
> > -               kasan_arg = KASAN_ARG_OFF;
> > -       else if (!strcmp(arg, "on"))
> > -               kasan_arg = KASAN_ARG_ON;
> > -       else
> > -               return -EINVAL;
> > -
> > -       return 0;
> > -}
> > -early_param("kasan", early_kasan_flag);
> > -
> >  /* kasan.mode=sync/async/asymm */
> >  static int __init early_kasan_mode(char *arg)
> >  {
> > @@ -222,7 +198,7 @@ void kasan_init_hw_tags_cpu(void)
> >          * When this function is called, kasan_flag_enabled is not yet
> >          * set by kasan_init_hw_tags(). Thus, check kasan_arg instead.
> >          */
> > -       if (kasan_arg == KASAN_ARG_OFF)
> > +       if (kasan_arg_disabled)
> >                 return;
> >
> >         /*
> > @@ -240,7 +216,7 @@ void __init kasan_init_hw_tags(void)
> >                 return;
> >
> >         /* If KASAN is disabled via command line, don't initialize it. */
> > -       if (kasan_arg == KASAN_ARG_OFF)
> > +       if (kasan_arg_disabled)
> >                 return;
> >
> >         switch (kasan_arg_mode) {
> > --
> > 2.41.0
> >
> 


