Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA076106B53A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 13:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10AA26B008A; Wed, 25 Mar 2026 09:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E19F6B008C; Wed, 25 Mar 2026 09:39:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F398A6B0092; Wed, 25 Mar 2026 09:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E0BF26B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:39:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 879378C571
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:39:31 +0000 (UTC)
X-FDA: 84584692542.25.2D4FA49
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5F57CA0018
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:39:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=grwhGpJT;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774445969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=faA6mSGMnx6rDUpnfk0PZMG7cUv6wd8U0MzReApShCA=;
	b=ymUgV/f50L3cf8p60zs3A7ga0EJ1SYENZIjbyvBlyhyWBjnKlsiCdwrohgagmS1ac0gvNl
	FtJeD75/ob0KvqUPxNzF4MFCmN3x8EfaJLL3jkM/7hBLFyckyJn+QP6m3bxwIp5zvcRh8v
	jx+NRwf70/T2LjGSYRowB3VINAIiFJQ=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=grwhGpJT;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774445969; a=rsa-sha256;
	cv=pass;
	b=eRuwCkFl7gbY0RJjOPrVIifgTwAv1dw6xQPQlKW7c04mcojUEpxPbIt5bHb3aTHu6FBkpC
	p5CZ9HTAbVMhycWPdvua/+iC7/IK3maFm967o2skvvqjoB3oMovEyAMvuFCC1/XapHEKzz
	1i2dcpnhcguNZKeEpT35IMjzopSQTt0=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-669d7666d77so5328825a12.3
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:39:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774445968; cv=none;
        d=google.com; s=arc-20240605;
        b=XDsHbex8q6+uBrGJa/hx4d+s9ZWVlFA5TeLNSGwLJkvEOK6rRL4bPLHPbcwFLjnsS1
         kmAyWQ2ebk3Amd5T7knC/sgW5FYFZNCWQF9pCQ44u7tXC1Ljq3wvO940GA6PcG+PjMk4
         Ej8rz9qm0CmxCZPUqRipBdrv9WyRbVJ7wMW0ycihdctsCm04N+8asC+hwYLhKeoXUo7p
         3pgMVKtnzSklKvrfZ9mNQrnMBOVCaxjML8pf/oX9HlulT+XYv0uF2QO2rJ/Tuczng457
         i+RawEspqHMmU4IBytNdjW4rfzChaMv72wYGW0decq0pnbsSnEITD6e/ybNgIDhfGKFl
         tL1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=faA6mSGMnx6rDUpnfk0PZMG7cUv6wd8U0MzReApShCA=;
        fh=K1trzT1nvq7R+XC+btCAeiHVAy0uc1lAGI3dENymaNQ=;
        b=j5+MBQR2xAWGDBPG1preDI4A9RGPx6MMfYoRjXEIJhvK0IUcBpwiPVWmXl4VCTzkwv
         cIjuLGnkpqBgqJZYnfjLa/8S7KrVTgCJebkLSvRQ5sbBXnx5UrfEOwF1VvXn8YEGtrPW
         zC+Or1JMK7rK5HaxnqtX22Pq2FtGpJdVXhhyjKB4mCu0XqUUCLicUsdRAvF6kuA/wMVm
         DmfVg+JjOyO/1QMCttlQ1di8rzPsYQJKcKN65IdtRBzxpo0Od3rnjMx8SqC1wZNdemsk
         kADEm2/2Cy/jZz2gUbImy8lDWLHXxsXmnrw8TwWpgO2dB8LHnqfT+ohPwEbjeAAzr9gl
         2UHg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774445968; x=1775050768; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=faA6mSGMnx6rDUpnfk0PZMG7cUv6wd8U0MzReApShCA=;
        b=grwhGpJTY24oBVKhnUPpKuTVhf0eBlPxdtr+q/63Q2Mv8rU3PXx2gb/zkZPszBjaCc
         rTqIoRckUpQq+v/IE08AweMRslIM+Q2tpZ2vzBrNv0jLUEiZWl9QwtHYDrZAPoazQFR4
         RfXBOHFmbPBxkjj9kyzSHfSrbfqq911zwrnt2JZfijSASjAMe3+Ob9ni5fSvCLgV+Yqi
         fZifeBN2shbEEzBzZY5vS6fCJvapu5mKTrk7bIymm2bFIqiQLSUYU5FUlIIH1JdOTX1K
         LbWRcnl/Xdo2/BKP1JHqHA6CCQXPGMq9nwDgbXHN4CWjOT31cHhIoIMKlvqHLWZGEvlC
         g3mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774445968; x=1775050768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=faA6mSGMnx6rDUpnfk0PZMG7cUv6wd8U0MzReApShCA=;
        b=LJrvwK/8phXOsjznZHPF4SQySU+BSuVxvFkRlVCF2Dg8+Su44suM3YXNsUBrSDTPC+
         r5+Zfu29LrQd7LgMMXR8K86jU7OODQeM5k85wXpOPTpnmqum9FRmqqsU8UQ4i0Z8LrC+
         20XPN4MdpyQqyDo8jKnSVEX2TlXyMQUv8J++SAWvihw5n4eOcTNnULvNfHcbSis5gJei
         WJjIrPsapGdf9CmqhhbSwCna0lpIRr69L8KpSevYk/UsDuqCG5HReFs0oag0wqmMQyMM
         vBcAnVArPMzr09GX/ExslkOh1CgbOC+mn8K9m5vC40i7UEGyGva36fuuQY/rFeCyyBqH
         mKTw==
X-Forwarded-Encrypted: i=1; AJvYcCUqOmTyYdRh7hZJYy5pLi9DjtUXGstCz3S4VIjyUgFPGBR4j5g2DN7OJTQr4zfLIe0dmI3YzvlelQ==@kvack.org
X-Gm-Message-State: AOJu0YzynHJjSKSBtG/TZwicySNLaELBYHMHT9e5bUWpZyAxeVHPM5NK
	wuQeA8MoiMYHoMbyGfMsAFrkmT76ZwLO3BDyj95Mp8ACJSIrJruYuq8PC8hQGf43GfvEYM0AE0X
	OzFNO6zQ2JcCAhvS1UxvHClI70PpGaW8/azwCWmeOBQ==
X-Gm-Gg: ATEYQzxlHmwqjAb3B8hVFfS3jfSFvN1RYyFKH54evth+far4u5ji75W0/6yiWUtDXs7
	d+IbArQC4Uv15ibgaFQ+s4Yy30sVK2gewU/ny4pyOXxcQArej7DRYLF4z978vnHW4JBkuM44h4o
	DGHy1sNuhK+wo7FWS3ZPFqTNnA/qkhk+2WO5SvlPGCSTVaonO+T7xwzL6A3NYwmmVKE4lYCCKAp
	7XvHNnVji+M7+ZH/5YjzVGgH1x22EmU/XUywZ+KJ9H0Yo8STf8qk7Lg9PKNanugQtHH8oKidKhd
	jk82Lxfcw7t+KEG+D9dmL2nXTB37RfAsoxmNew==
X-Received: by 2002:a05:6402:1912:b0:662:fad8:4a9f with SMTP id
 4fb4d7f45d1cf-66a8262df57mr2229663a12.9.1774445967511; Wed, 25 Mar 2026
 06:39:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260324212730.65290-1-oskar@gerlicz.space>
In-Reply-To: <20260324212730.65290-1-oskar@gerlicz.space>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 25 Mar 2026 09:38:50 -0400
X-Gm-Features: AQROBzANxvahMrwgqF65m0uu8wFijNd2nMQVhGo85hpt9Z6ibVgi4ycmBx884KY
Message-ID: <CA+CK2bCiqCg1Tt0WgP3KszrK96Qahcgfyfige4eUQOkMVyLUqg@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] liveupdate: tighten handover cleanup and session lifetime
To: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
Cc: Mike Rapoport <rppt@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F57CA0018
X-Stat-Signature: 136e8nh89en3aymafe85hrs6j37ck1r6
X-Rspamd-Server: rspam06
X-HE-Tag: 1774445969-957078
X-HE-Meta: U2FsdGVkX18JyucaKa60h2dTgboA72xrGH99GDZHa0B/BDwa5PbLxePeo5U/PyXFLWckclwi0Pt6SyThvFMjS5Zo5G60v5LzpFWNZ0s0OzbbxsGrI8S9DjknC0rrppPO0CYpZ4fcuh/XrL+Be4EPM8u3JiB3k0726ivRLIGdAW8ZIlaK3ORnJQ9nLJ1RXiWzNeN0NpfGP2THuEjYI9x+IGCpVmi8ubZ9N1CNh1ek+O9k4IIwYq9gG87w7IjMnc0+Ez9rrC4IO8ryRF6Msge7JqN0bZiwyOxCaY56q1l0jlpA5gOvyj91S8aHN7A4RjsZrtKNCEq/SuacgdFPSLoaqWRS+GcRg+wa6UnPbB1ek6Jc6bvzKgmM94LsqUMOS2jv4avSf8HZxq5KbjaZgySaB2/hDNDZEvGiWiwyyGDIrlZcdDzvG7w5H3krRlJriFN7bZl6Y6Fra0+O03KneLdQx7SntTI4puXZ3h+1fVlu/Y5OtCps3SeLLzWOAn4WA0hwA5GxBNJVJ5J8rZWgVBTs05HoiqJm3GCJav3VerS39Hk8Cbxo6qYUir4eJSWeWJdkwebYQfM/soYRijyiBglq2mK4T7ysdYR9H3SI4LfHVvzwPws6iJrDodMDti77hVlG+ByR2vqPeT8k0Uhfd9nkWdY5ZO+sEZdvvkzB1pbOIwzCxTZO2jiKueiR1Xl2zOv80pr8NxzhBPBMMIbFMxPpmlL+jhOaCcbSQZ6QTDwa+CRYleWefE+fESLYtJWCpPSo15J7gIJRj+/i/GmxMlTYfuuIA4UYxMa56GbS6sMNdmcRfcLz0d48T+Vb3fCvO3XLTJPY9DYttXIxOdFhOuAIkZBnDBiogaErsTWYqA47OKdyPAbCHiggaMTIGWSn6DlSwRed1fnmFWZQhIJi+jRv0fxgJ+W9bQ6EaPQHHacAQb2C1kaCViDyQ45ugTFsy0Qn/CO2D3HUTGiglV/jZee
 P8D3RrAK
 xywTiWNp8d7Ab/tyxv+r8HDgf4L/czdcqWyEf5qkLGydRZJ7VEWfGIKZdN91NmDmVu5eneLam8tGOAv2ZqUEGUgYwe/DKntVJz5G5kVVF3cCSgW5HK05SBDdNbLqxERlhVnb2AWl6Cgbqs0Qqy+yZtRZf6d8NTEbACrRdez6hpTFFnihUuZBsp5EzxcLxrN8TbcjVcbnzYKQ7lHaONte3XnaX8sz9W4pzkVO/js65d70XU+oywLP4r2eKJfDso938hzvWVZAaUDQEfRav40UO1i/Ypg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 5:29=E2=80=AFPM Oskar Gerlicz Kowalczuk
<oskar@gerlicz.space> wrote:
>
> Hi Pasha,
>
> this v4 keeps the simpler direction from your mail: outgoing handover is
> still driven by a boolean rebooting gate, refcount pinning of outgoing
> sessions during serialization, and session->mutex as the serialization
> point for in-flight mutations. There is no return to the earlier closing
> counter or a larger session state machine.
>
> The main changes in this respin are:
>
> - reshape the series into five commits, each building and standing on its
>   own
> - keep incoming session origin immutable and use retrieved only as the
>   checked-out bit
> - make FINISH and implicit close consume incoming sessions without
>   reopening races through retrieve-by-name
> - route deserialize failures through explicit rollback paths for
>   sessions, files, and serialized memfd state
> - validate KHO-preserved extents before walking serialized metadata
> - harden incoming FLB lifetime and remaining teardown paths
>
> Patches 1-4 keep the core session, kexec, deserialize and validation work
> separate. Patch 5 carries the remaining FLB and teardown fixes needed to
> match the final tree.
>
> Oskar Gerlicz Kowalczuk (5):
>   liveupdate: block outgoing session updates during reboot
>   kexec: abort liveupdate handover on kernel_kexec() unwind
>   liveupdate: fail session restore on file deserialization errors
>   liveupdate: validate handover metadata before using it
>   liveupdate: harden FLB lifetime and remaining teardown paths
>
>  include/linux/kexec_handover.h     |  13 +
>  include/linux/liveupdate.h         |  17 +-
>  kernel/kexec_core.c                |   4 +
>  kernel/liveupdate/kexec_handover.c |  22 ++
>  kernel/liveupdate/luo_core.c       |  16 +-
>  kernel/liveupdate/luo_file.c       | 237 ++++++++++++--
>  kernel/liveupdate/luo_flb.c        | 116 +++++--
>  kernel/liveupdate/luo_internal.h   |  14 +-
>  kernel/liveupdate/luo_session.c    | 500 ++++++++++++++++++++++++-----
>  lib/tests/liveupdate.c             |   2 +
>  mm/memfd_luo.c                     | 160 +++++++--
>  11 files changed, 934 insertions(+), 167 deletions(-)

Hi Oskar,

This is a NAK.

This patch series is still significantly over-engineering solutions to
straightforward problems, and the patches read as if they were
mechanically generated rather than thoughtfully designed. The sheer
volume of changes (nearly 1,000 lines) is unnecessary for what we are
trying to achieve.

As I pointed out previously, we need to keep this simple. For example,
the problem of preventing a return to userspace after a successful
liveupdate_reboot() does not require inventing a new
liveupdate_reboot_abort() function. It just requires placing the call
where it's the last function allowed to return, with a simple
exception for context-preserved kexec jumps. That is a trivial change:

-       error =3D liveupdate_reboot();
-       if (error)
-               goto Unlock;
+       if (!kexec_image->preserve_context) {
+               error =3D liveupdate_reboot();
+               if (error)
+                       goto Unlock;
+       }

The same principle applies to the other issues. You are doing rewrites
when targeted fixes should be applied:
- Sessions mutating after entering the reboot() syscall?: This is a
14-line fix [1].
- Destroyed serialization race during liveupdate_reboot()? This is a
70-line fix [2].

I was hoping that v4 (BTW, why are we at v4 in just a week?) would
include the patches I already provided, along with similarly scoped,
minimal fixes for the deserialization path if needed. Instead, I am
seeing another over-complicated rewrite.

Looking at deserialization, I am seeing, you are deleting a comment
that explicitly explains our error-handling design:
-       /*
-        * Note on error handling:
-        *
-        * If deserialization fails (e.g., allocation failure or corrupt da=
ta),
-        * we intentionally skip cleanup of files that were already restore=
d.
-        *
-        * A partial failure leaves the preserved state inconsistent.
-        * Implementing a safe "undo" to unwind complex dependencies (sessi=
ons,
-        * files, hardware state) is error-prone and provides little value,=
 as
-        * the system is effectively in a broken state.
-        *
-        * We treat these resources as leaked. The expected recovery path i=
s for
-        * userspace to detect the failure and trigger a reboot, which will
-        * reliably reset devices and reclaim memory.
-        */

You are adding a bunch of new functions to solve something we
intentionally chose not to solve. Attempting to cleanly unwind and
release incorrectly deserialized resources back to userspace is
dangerous. It risks security violations and, in the worst-case
scenario, customer data leaks. A failed deserialization means the
system is broken; we leak the resources (make them unavailable) and
rely on a reboot to reliably sanitize the state.

Please drop the over-engineered approaches. Use the patches provided,
keep the fixes minimal, and do not alter established security
boundaries like the deserialization error paths. Take your time to
manually self-review your work, do not rely on AI to do everything for
you.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/tatashin/linux.git/comm=
it/?h=3Dluo-reboot-sync/rfc/1&id=3Dd47b76707c4f352c3f70384d3d6a818e2875439a
[2] https://git.kernel.org/pub/scm/linux/kernel/git/tatashin/linux.git/comm=
it/?h=3Dluo-reboot-sync/rfc/1&id=3Df27a6a9364cd0a19067734eeb24ea4d290b72139

Pasha

>
> --
> 2.53.0
>

