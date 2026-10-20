Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F6C606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 20:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KEH9pa0d
Received: by kanga.kvack.org (Postfix)
	id C3A826B0551; Tue, 20 Oct 2026 16:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEAE36B0552; Tue, 20 Oct 2026 16:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B012F6B0553; Tue, 20 Oct 2026 16:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 854A06B0551
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:01:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2066A03B6
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:01:01 +0000 (UTC)
X-FDA: 85344073122.21.269B44D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 00E6640016
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:00:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KEH9pa0d;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792526460;
	b=J4ibthn8vaheEu61Tspv5Qg41Zr1GYW6HayD3dqDjPUcKDbtWLG5wYr8hW7MHrHpCLFIOe
	/DYVL3is5ySvoSEy407TBS0LT8UOsVN2zjNZWfLvVG1BNzywP1E7JrDUeeCbA5FeJKkNuD
	wagS4zG1AlYc0BNML+OxI/L9RKIVxpY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KEH9pa0d;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792526460;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zfyehBfZ/NZDmVggboetswaZ5EHjIBQH3RA15D3wRlg=;
	b=fe4mjpSNmCxhMo+JjmhvvBoEcNx0CK5e+GRozSVmNt7LkbGLGXwOQxXwp8PB9PLNPdA4Uk
	8VHVeg8Zmd6GRWR9svXXjBgZelWe24Dtd5ScM1/Z3DBM8v602gKokk0ntZ8+oW/16V6QbM
	N9cr8F7TM5pAw2N/cgIBqOjTFe2LSvU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 490A0601F0;
	Tue, 20 Oct 2026 20:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26DF1F000C9;
	Tue, 20 Oct 2026 20:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792526459;
	bh=zfyehBfZ/NZDmVggboetswaZ5EHjIBQH3RA15D3wRlg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KEH9pa0dOrTQBDrixpNqKDsr6RzRoUWWTdOEZMK4QHhiFKXks1om6u7kv4+pOXGHZ
	 UTvq8ophVkkUkPpojCXThVz0k9IJ2cdif6USzJ4+SoTnh2XpFJMqAzRFmgzFV22EAr
	 xLlUPk30MQ/6Kls48HSu7aTt//sVtx2xxRPnMKOlviTcLyHX9YWW1hIgw+2FmtL1el
	 YmbJY2IMALTIYdBelp/6D6ncT9cCQG8X38OWNPTAuEJFcDZw4G/g6zLOJhvJy9AXKK
	 V78LOF8Gkwad+/kvAhXlUjqqCvVWe7DFeuAInRrkPQTZY1k5SX9hhl6IiEFmB675k0
	 JdMuqu36pE7DA==
Message-ID: <sashiko-outbox-179524@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/4] alloc_tag: Extend allocinfo_filter to support
 tracing queries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhishek Bapat" <abhishekbapat@google.com>, "Suren Baghdasaryan" <surenb@google.com>, "Hao
 Ge" <hao.ge@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <9e49a8f68e4e7d25c5a9a73c1926f68e468ef320.1792439751.git.abhishekbapat@google.com>
References: <cover.1792439751.git.abhishekbapat@google.com>
 <9e49a8f68e4e7d25c5a9a73c1926f68e468ef320.1792439751.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 20:00:58 +0000
X-Stat-Signature: pin3iid4fpojz9n5doayo9aqsi8zdygw
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 00E6640016
X-Rspam-User: 
X-HE-Tag: 1792526459-491219
X-HE-Meta: U2FsdGVkX19ezYZbd549nsZbvPf/4Ps57XXntweJkRLWKaN5bFicNMtvVKUaUu/IHuwUs2ZmKifr3J/mrMXqmvrUGf50szMFeGkG8VRGuJUHen3zmSqPr7Kszot56Q2OGUarIbVxaLj6tt5cYu+NKFi6s9zXxTAY0F7OHTIgDOjR/NdT+rEHoNnQ+lR7+bcyOsWeByPvEADHVciFboTQnfJHsPW/7LB8n3vXyINAKXRWibPgtLmyygqmIm4TbmEwHqpkQnA2F+Dm4HXodoxL5v2V1l6a9qMj9qZx0d8IVNxW2hG6GEbFA/wU1GZfcFG70zNfBj8DyK54C3b8d3WiG56hvjdiao/3NnG7BpSOE6edP/iLTDcFsMhyhvDIu8VLH6A3wHlCZBLKe/8mYmzUdXBeM++h8ISC31W/K4Fk79YicWKqau7MTPW7PXWbbPe1IuJLhHgm4N0HxFPbR1Gl3dr5ZiyuiH91wbKccSZEoDpRFhnw3io2HNnGhSKd5mn13PGiVOA545yTC4FPmzOaKBwC2hfeHN28jjVOIiKfZT1ep0NP5Dt2VmIQBjwL3gBpMxqXNP79Zjo7Q6bJ5oCPkPn1ulXDvX8QOgE5kqou2fHlulegFRNiGIxqh8M56oMa54aBsk3FM00szysxZJQJlnoooQgR2qxX8XFgTB3mfyPBRGVphKqsTOcYl8IsdaJCD9CvrywyP66BoSCfCpo/84vVlBHxYGZiWSoIPatxdg0EFi8xUjt9UPglVQcbRF8bB9rgnQr9BrTdlrMA/hZfg50HEw+Ddi0l5y9HdJF5nksDH10+ww196nXl5Au0l1vkl9EkeFC6efvrSu82fgSGCnW0pde299ybY6gmjYtlbgMO9TDqLTZP2/qnGKAVueD4NramZ71MvmeLb+0ktMRXyMOi21DWjcJuZKENh9lx8Mrm1+HN4gLEf06tWMPZbPfmsN4p9e2E80RVowdc8z3
 SKp9xjeK
 nE6oq7gg04lIsRafnkEogscjHorZehyFtFIFn6vyyixcH0jb41M9EKrI1s93bHiyMq6G9Zl10fbZ5YomRhcC4IV+UbkiwIFvF+uLLYzvTgin8+3PWOCDOGFlpwoRdQ00zMWpnZI7wtFM1H5+Olli5pPg1JGVSifdOsmvPfZoVh20Fv+6kWVu5qdmHkgxGCu+qj7nJGMEb3/HiO0+wGgv0DLd54EvhOhQuSTylp0G+3uhuK62gff7tj4Z8WWEweNzZXYg2jlLfDEXHzo5SQSAhi3bcr5KcIym9dhy2cPWgM4ThySGcQtcX4PKRFKLnSjdy5ax03LUItc6zDJxnWizhBng33AakMGNZ58JMYWX33zo79BzxmVEJIrrGHcWHiw3vQj2OxA7h3UXTwOgyLW6nqnhqfx8XXq8hPMxjjDZNIhm4ZlAziy9emlqCyo7Sg5NNxTViN/F8ir9KVC2+6Jzvaj2bmVHtCXdImqv6a3gWCBFn3ZdZl0soWxW/5v4PlM0DNY9RUdgAYWRNLR4bvGcj5LGvaQq0al6lMOaru01d1fh6QtMHUPu7KigNIMS3eboSVBZchooLygMM+jHOPLDuguvF8LCQ8FMhy8mUWHu1jRpZn1qwqJncJbo3/UmjbV+JIQyD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] alloc_tag: UAPI ABI break in allocinfo_ioctl() from growing alloci=
nfo_filter
--

commit 93a7b2baed26770ea553f10bf7e51ee61056c1ff
Author: Abhishek Bapat <abhishekbapat@google.com>

alloc_tag: Extend allocinfo_filter to support tracing queries

This commit extends the /proc/allocinfo ioctl interface to report whether a
codetag has tracing enabled and to filter tags based on their trace state.

> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_ta=
g.h
> index dafcba2f7e2c1..a96054ac22376 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -38,7 +38,8 @@ struct allocinfo_counter {
>  	__u64 bytes;
>  	__u64 calls;
>  	__u8 accurate;
> -	__u8 pad[7];
> +	__u8 trace_on;
> +	__u8 pad[6];
>  } __attribute__((aligned(8)));
> =20
>  struct allocinfo_tag_data {
> @@ -54,7 +55,8 @@ enum {
>  	ALLOCINFO_FILTER_INACCURATE,
>  	ALLOCINFO_FILTER_MIN_SIZE,
>  	ALLOCINFO_FILTER_MAX_SIZE,
> -	__ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> +	ALLOCINFO_FILTER_TRACE_ON,
> +	__ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_TRACE_ON
>  };
> =20
>  #define ALLOCINFO_FILTER_MASK_MODNAME		(1 << ALLOCINFO_FILTER_MODNAME)
> @@ -64,6 +66,7 @@ enum {
>  #define ALLOCINFO_FILTER_MASK_INACCURATE	(1 << ALLOCINFO_FILTER_INACCURA=
TE)
>  #define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
>  #define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
> +#define ALLOCINFO_FILTER_MASK_TRACE_ON		(1 << ALLOCINFO_FILTER_TRACE_ON)
> =20
>  #define ALLOCINFO_FILTER_MASKS \
>  	((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> @@ -75,6 +78,7 @@ struct allocinfo_filter {
>  	__u64 max_size;
>  	/* filter criteria only; see allocinfo_counter.accurate for actual accu=
racy */
>  	__u64 inaccurate;
> +	__u64 tracing;
>  };
> =20
>  struct allocinfo_get_at {

[Severity: High]
Does appending tracing to struct allocinfo_filter break the UAPI ABI for
ALLOCINFO_IOC_GET_AT?

struct allocinfo_filter and struct allocinfo_get_at were introduced in comm=
it
1d581ab2348c ("alloc_tag: add ioctl to /proc/allocinfo"), commit 5732a4e4c1=
8a
("alloc_tag: add ioctl filters to /proc/allocinfo"), commit 6f6769ea88f8
("alloc_tag: add size based filtering to ioctl"), and commit 33588e0b81df
("alloc_tag: add accuracy based filtering to ioctl").

Unlike struct allocinfo_counter, where trace_on consumes a byte of pad[] to
keep the structure size unchanged, struct allocinfo_filter has no reserved
padding. Appending __u64 tracing increases sizeof(struct allocinfo_filter)
from 232 to 240 bytes.

Because struct allocinfo_get_at embeds struct allocinfo_filter by value bef=
ore
the output field data:

include/uapi/linux/alloc_tag.h:
    struct allocinfo_get_at {
            /* inputs */
            __u64 pos;
            struct allocinfo_filter filter;
            /* output */
            struct allocinfo_tag_data data;
    };
    ...
    #define ALLOCINFO_IOC_GET_AT _IOWR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_G=
ET_AT, \
                                       struct allocinfo_get_at)

growing struct allocinfo_filter shifts the offset of data by 8 bytes,
increases sizeof(struct allocinfo_get_at) from 464 to 472 bytes, and changes
the size encoded into ALLOCINFO_IOC_GET_AT (as well as struct
allocinfo_toggle_traces and ALLOCINFO_IOC_TOGGLE_TRACE).

In mm/alloc_tag.c, allocinfo_ioctl() -> allocinfo_ioctl_get_at() only match=
es
the new ALLOCINFO_IOC_GET_AT command value and copies sizeof(params):

mm/alloc_tag.c:allocinfo_ioctl() {
    ...
    switch (cmd) {
    ...
    case ALLOCINFO_IOC_GET_AT:
            ret =3D allocinfo_ioctl_get_at(file->private_data, arg);
            break;
    ...
    default:
            ret =3D -ENOIOCTLCMD;
            break;
    }
}

mm/alloc_tag.c:allocinfo_ioctl_get_at() {
    ...
    if (copy_from_user(&params, arg, sizeof(params)))
            return -EFAULT;
    ...
}

When existing userspace binaries built against the previous UAPI header inv=
oke
ioctl(fd, ALLOCINFO_IOC_GET_AT, &arg) on /proc/allocinfo, won't
allocinfo_ioctl() fail to match cmd and return -ENOIOCTLCMD (-ENOTTY)?

Since matches_filter() only evaluates filter->inaccurate as a boolean via
!!(filter->inaccurate), could the boolean filter criteria be encoded without
growing struct allocinfo_filter, or could allocinfo_ioctl() handle the lega=
cy
command size so existing binaries continue to work?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792439751.gi=
t.abhishekbapat@google.com?part=3D3

