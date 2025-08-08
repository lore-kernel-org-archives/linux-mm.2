Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1588C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 13:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7708B6B0089; Fri,  8 Aug 2025 09:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748836B008C; Fri,  8 Aug 2025 09:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685656B0092; Fri,  8 Aug 2025 09:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5ACA66B0089
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:01:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08B1DB6D12
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:01:56 +0000 (UTC)
X-FDA: 83753602632.02.32EB0AE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id EAF8B100010
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:01:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C3SeBB8H;
	spf=pass (imf05.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754658114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GIqJ6f/aDwqAFbRn5MC1kbdMPJMwUfUOc/srLwo7ZjI=;
	b=VUwQ/GV1kmSmRuUtfvs+W1/JG6DnzNq25bTs3ouqMNJx3NPvs+ar5CpsjC3MsT6ojyl0nK
	S8XStIhye1wXHxVOWo9rig+a9Ph/WGxQWc1gMPMU6C/4hUxGrK/2KVLsN+KEaou0HGf9JM
	4EtLGu5XCV0nOrcvMBaLLtseLpSalvc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C3SeBB8H;
	spf=pass (imf05.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754658114; a=rsa-sha256;
	cv=none;
	b=PxC8Yb6CSJzjK6htlXnBYIMo/2GSg1j26ssHCLRQoux12mvO1qmO96AUiTdQBXGv57QhDj
	o7GOl9v7xKIEAMuFbfCvyq7ZAvKc/Kx6sOcdzpeEHNvGyerbFrMjl+NiKYjI5DLmvj9u+W
	lJjBnwZm/UXROPQ0zzlDZCgAVZ9nTM0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754658113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GIqJ6f/aDwqAFbRn5MC1kbdMPJMwUfUOc/srLwo7ZjI=;
	b=C3SeBB8HD1gNrtdvPrLscqvKV5oH6LxctUA3n+l8plXHcv7yMfuOOjfF1Pz9jggFaHdrz+
	N8lmZuAK6nsB7zAKYyDs/APysMEZ8vhVnyII96bUjUqaK0t8NkkpeUNHkGTGOQeoh9ljki
	NbTsRs/kLjv8OwPnUMwy6Nt3Pb2l+kc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-124-CU-roWnKMwqBdKpO_Vmcog-1; Fri,
 08 Aug 2025 09:01:49 -0400
X-MC-Unique: CU-roWnKMwqBdKpO_Vmcog-1
X-Mimecast-MFC-AGG-ID: CU-roWnKMwqBdKpO_Vmcog_1754658103
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1812F180034D;
	Fri,  8 Aug 2025 13:01:43 +0000 (UTC)
Received: from localhost (unknown [10.72.112.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7BBB61800297;
	Fri,  8 Aug 2025 13:01:41 +0000 (UTC)
Date: Fri, 8 Aug 2025 21:01:37 +0800
From: Baoquan He <bhe@redhat.com>
To: Marco Elver <elver@google.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com,
	andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 2/4] mm/kasan: move kasan= code to common place
Message-ID: <aJX1Mcc1QrkUgi89@MiWiFi-R3L-srv>
References: <20250805062333.121553-1-bhe@redhat.com>
 <20250805062333.121553-3-bhe@redhat.com>
 <CANpmjNNr7e6DXQrZva8k46jELr1JSkjExWvQOyrkY5VD8mOadw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNNr7e6DXQrZva8k46jELr1JSkjExWvQOyrkY5VD8mOadw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: db5yyege6kpyr4inu846iseok4d6z7a1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EAF8B100010
X-Rspam-User: 
X-HE-Tag: 1754658113-728018
X-HE-Meta: U2FsdGVkX1/xqWn0FvtnxAea7jaNw4t305C1osJonUZhfe0VuFKp5ZvAejKh7hXhxHn04y74OLSCRo36JX+isJRWLjY691ZB7INV9z5h3/vnisRvLOX/PskwEs8LnPLjWF8Ox+jGRVI0UVfNFlZ0oF0HYOf9KcuwM4ZTrrfEWgPGR1XKhb6LMRCCdQ+Ea8UwnjqzqtMbg3EZXTP69g5BO+QVEMOLwbXVmyFdOqKKhvV9fuoqbgfjle7MyFRpdLTCVS0LhdtwBe5Nfb9GGlkQ5i4aACCgf4xBcJuw9GHgPQ6qrgU2ssw7p8TSf+5QIe/l8nTmK7QbEzfAhV90Er9ZZPPYHpNUqZvGEdfplwsy/FC2IK2IswC3VmceIi08wUfcFSVRnJ3JxU21AbRyP5DkwEzXOxJEaHASlAI8rrFdCyw2Khqk3rRHm/qjC3k7RKrtZP1dbkjK7p5Stoqtc+D0H/wD2ERNUIIIcp4SQooUi1FWR1AfKgr0ODzsUwb7mMw6qMWBvGCjen1Og/Y8Np4DrMkOH8ujEazFhWAsHN+GZPej01gNGabfo7Ff1gk4S98gTbo7XSXI/o54Yrt4ejd4Yr7rVX7kD1SYIfVrus4zGjFmYXTgJEiRYQoa2B6YbSntYShb9i0mlbTFCb57TyPU1+qlSToWjkmsETGAr+Qve1lDll8JPjpGNXQ50u+/SDajU5C5tZzAjM/JCSi8nKLPRHRerkgQj6g0dpJkRddLr/MMZnTLtqWHIcrys5avotzFWoym88ICbi07XUghXa59QfR6NE0/aDCkCxavauPKl3OlN2WSN+CkB3g2Fu2kGTG0bmUapMvL86Es/KsHIxWAnkHEKrMHXeZJSc5+T9DANRPHPnnjOV39XXX1WsisG/rF49mMLfZz1q2tyULg4d+Etf0EEKQc59tx7VLPWJcb8kus/xsPZ1RrbeoBMr65UmUEcdkyIlrYa/nBNzLdSrT
 flNWGg0Y
 kdPtxuNTP9xJV6tVbb0uDObTO+oSCbpd67/1NZ3zy9tRepGv7iQvtU5IASPeqe7m983ZHFPAh1CJzzX9bjek4Wo9XEeEUrOE7jk49gMtFWfHGscnDN80UYO8cWQjv36rah872dVIEU5WTs8vtm1T5l3/KgdESxlOeggNvNeMADXW1JcV9mc/1cnIcY+mIsvFhzR0E+z5fNoFCV3r2TNGtWnMHemHxiNnTKoNhY0K0L7ajkpl3grdU3xxbkonVp70DsMHq1394JPWDjWPrkzy//8VDT+nTVALQb1iKmyz4Guteb8pMiMcdE+ENfV6CrR1BPysNt/DHW7X8a/O3TjYxnwC0jYjBNrV1XZB6Qco8m4wtflulmVvp9scyC+DLauosXHxh1Bw9db9Zg1p0jQYNMc/HYsjf+v86lGOSinJfPL1/CDQFLCKwe6DP3UU22PCAnop6JjIRPAoN2l3RAwbL9FiDP/kYCa0QVQ/HIKDSGt9h4nI5X217ZW963GeQdPHttqXp25/H3EcEpF2X2r1yxkLXUpZC23UVzOsE3JKOWQsrAuJ1FoTlAoWTbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/06/25 at 09:11am, Marco Elver wrote:
> On Tue, 5 Aug 2025 at 08:24, 'Baoquan He' via kasan-dev
> <kasan-dev@googlegroups.com> wrote:
> >
> > This allows generic and sw_tags to be set in kernel cmdline too.
> >
> > When at it, rename 'kasan_arg' to 'kasan_arg_disabled' as a bool
> > variable. And expose 'kasan_flag_enabled' to kasan common place
> > too.
> >
> > This is prepared for later adding kernel parameter kasan=on|off for
> > all kasan modes.
> >
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  include/linux/kasan-enabled.h |  4 +++-
> >  mm/kasan/common.c             | 27 +++++++++++++++++++++++++++
> >  mm/kasan/hw_tags.c            | 35 ++---------------------------------
> >  3 files changed, 32 insertions(+), 34 deletions(-)
> >
> > diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
> > index 6f612d69ea0c..32f2d19f599f 100644
> > --- a/include/linux/kasan-enabled.h
> > +++ b/include/linux/kasan-enabled.h
> > @@ -4,10 +4,12 @@
> >
> >  #include <linux/static_key.h>
> >
> > -#ifdef CONFIG_KASAN_HW_TAGS
> > +extern bool kasan_arg_disabled;
> >
> >  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
> >
> > +#ifdef CONFIG_KASAN_HW_TAGS
> > +
> >  static __always_inline bool kasan_enabled(void)
> >  {
> >         return static_branch_likely(&kasan_flag_enabled);
> > diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> > index ed4873e18c75..fe6937654203 100644
> > --- a/mm/kasan/common.c
> > +++ b/mm/kasan/common.c
> > @@ -32,6 +32,33 @@
> >  #include "kasan.h"
> >  #include "../slab.h"
> >
> > +/*
> > + * Whether KASAN is enabled at all.
> > + * The value remains false until KASAN is initialized.
> > + */
> > +DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
> > +EXPORT_SYMBOL(kasan_flag_enabled);
> > +
> > +bool kasan_arg_disabled;
> 
> You lost __ro_after_init

Right, thanks for careful reviewing.

> 
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
> > +
> > +
> > +
> 
> Why extra blank lines?

Good catch, will remove it in v2. Thanks.


