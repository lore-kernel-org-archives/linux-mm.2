Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02D9ACCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 17:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51FB08E000D; Thu, 23 Oct 2025 13:42:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CFD78E0007; Thu, 23 Oct 2025 13:42:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BF1B8E000D; Thu, 23 Oct 2025 13:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9018E0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:42:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7B2DC0C09
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:42:53 +0000 (UTC)
X-FDA: 84030099426.26.0EA193E
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id CFEF5100010
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:42:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iVl10dGe;
	spf=pass (imf05.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761241371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FgjwodffJXCXV9bFCxRQxHHnhjnX/ahOR9pMrTqBvoc=;
	b=ZqWvZO+peb+GS8DQ7XmgnIjYmH9CXAwVPh6OFm90N/Zebai2DNuGrLjvE9yEcb56aqC2g3
	+4zfbFjWuXivVGt7qBMW6Q9Ez6rqzZ1WeZcgIUMCon+cYgT5q+WUOj0vgeBfiO7AIAzk9w
	L4dcLccabm1McUi2Tope835hjzgqYZE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iVl10dGe;
	spf=pass (imf05.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761241372; a=rsa-sha256;
	cv=none;
	b=TGzSs3AX/dSwHMNudKcbX3b0rphCpX8lzgP2CzLy/+qW7UDk5biiiz5bSXDy+7nfQRq5S1
	aPuQoqXzD4i6KbOEW/PkvJ6zhf7TTo7u480tGNWKxk7AvBE63INxuZR0QQ7raQT7D/NKB6
	3FVDpbidgqJ0KHsEMRYN3TTFdmzxpCs=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b6d3effe106so265037666b.2
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761241370; x=1761846170; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FgjwodffJXCXV9bFCxRQxHHnhjnX/ahOR9pMrTqBvoc=;
        b=iVl10dGefTyjo1dUIe4TGQUQTpwiPyP1EVCabDOQVHR0Cnn5i+ME71Lv84bDVLWGXC
         ZvnJdy+YYFCunEr5XGM+2vym2lqZILaUP4RjbMqmTlKG+iC9x/e8q6YqXf6aEd1GDxD6
         7MmLoenSAqHOlEvkzmi56x4oEtYOAXvkpURJUe1OzOuiMn4dNn2XBtSXUonuCQ0W8Mmv
         0OIFWxT/Bj8cRrZedV+jDbxENSy94Afu/XQSK5PCSAoHc96/i4NqEY8JxynfaGTT2S/j
         3L+RjsEw7w+/BDPIxWR3fPmiEE1dlFmHF6wI3XT8Q/NAu53Oa4Q97zetbvtWCaFDKm0T
         jJqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761241370; x=1761846170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FgjwodffJXCXV9bFCxRQxHHnhjnX/ahOR9pMrTqBvoc=;
        b=HpodmxflA17tJPP4YD8ySZZK8rZ3yZTHjRrmUxP8Fgp0J/oVB3lIZZhZUbHGP6FVX4
         y+gXOirbR4/Cv9XK3wKmGtwijUNYVQ4jbgqVLBzhXJZDjr1zVxz5FgLU2AxiBL1QKrdb
         UgT2O6FHyM9/tCwvjCkoRXy2MTIV27SdEZaBwlV8c/Gnk2SyPCsD2BLi2jr1n5MF+kLk
         hbBqm4wZgBWbmWpvUo17vzLLwQwJs8JBrmdVC8fpWTjpkkVxaM21PHQ6CbbZsAdREM+l
         bO5zK6m2HDCw72GJN6rwU44zyNoqTYg9YPRMleqyfVBRasnEvH6b3GYAw9WRKRHXVDAD
         Gq4g==
X-Forwarded-Encrypted: i=1; AJvYcCWd4VCx+tSbAupAvLdfigXAZsIyoWFCKyfnSJq47O5LT+rB5Ptu7Ht8AuOXLKpfB0Ljn0wd2FIDEQ==@kvack.org
X-Gm-Message-State: AOJu0YzqhWh3XqE/h0a6PANdmbNGocou8on6zyhw0oQ0yw4f5TU8XUXO
	ivRQVh4tewaXOufk8SeGdLQgpB3A3w9bnVbKa5nldHEuKiV28hkvVJeJbXXiq7kwP+rivlvqdWK
	NOgSE1RSMEihJDuxxtQDvyfueiRKWh14=
X-Gm-Gg: ASbGncuyR7tH0X9yld5tq2bYsPf8ld5BatB6Ya3nGZjDxwnHlzw9gcmrYqUtYhMyvin
	OPjQUD+qeijrr72ubTqfBRV8ofY9nfK2ceFLzuS+oJFe1xiwxQ6WUT48e4Gd/SVKWJlnuA3kfGv
	VO5cSR1vFjDpmoiBvoOk+rEWBv7v2p0akXbWYhzJAxC7TtMHpD1FtUY08ij+UdZByM+W5KOoBPn
	rc1eNeFZcZFayYMUvfa7sHbRWhn+8wOCQ+4dfrmupzgFkmzRlhasUXC3DI1bhAOC0eXUScMUA==
X-Google-Smtp-Source: AGHT+IEKQYSOEcrZQfp4cJ7IkzzOuPov5OvT9VKtkMyLr8PjhSdzUuJ0K2NylS1MWdT9Z9LwTFR1Qn2IXWVMA8nvEAc=
X-Received: by 2002:a17:907:2dab:b0:b44:f9fe:913a with SMTP id
 a640c23a62f3a-b6475d04cb3mr2843914766b.65.1761241370295; Thu, 23 Oct 2025
 10:42:50 -0700 (PDT)
MIME-Version: 1.0
References: <20251017141536.577466-1-kirill@shutemov.name> <dcdfb58c-5ba7-4015-9446-09d98449f022@redhat.com>
 <hb54gc3iezwzpe2j6ssgqtwcnba4pnnffzlh3eb46preujhnoa@272dqbjakaiy>
In-Reply-To: <hb54gc3iezwzpe2j6ssgqtwcnba4pnnffzlh3eb46preujhnoa@272dqbjakaiy>
From: Yang Shi <shy828301@gmail.com>
Date: Thu, 23 Oct 2025 10:42:37 -0700
X-Gm-Features: AWmQ_bl7HHHe3F5m7s8SKqaEwkR90lx0Ku2nfc1LYSRH2AGyQ13C81borZW52B8
Message-ID: <CAHbLzkpx7iv40Tt+CDpbSsOupkGXKcix0wfiF6cVGrLFe0dvRQ@mail.gmail.com>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CFEF5100010
X-Stat-Signature: ytfyhdmhfe13i3zg43jfzd9uri4pkipe
X-Rspam-User: 
X-HE-Tag: 1761241371-237689
X-HE-Meta: U2FsdGVkX183QFP+mH9OLlAG8yIkB/g/y1wxN5lNdiQQHBAU01UgJZEGZT38BvSsI5CHtlb16aWQCQILV36f5eseWMLy3h6pDMBZQkWQw2Mt6QCFRO8+bG8q7qtJy9C3++WRyGuWO9WWw3/jPyixSwyDqx/+F2ZPupDggha1xpKoRJR/hZbJdzsP3zR0LqcIN972hqkPXeAT5GOdDWr9Gpi9SnJaY2xvprWdSzadvSQbapjoBn6i5EnXe4KpzImNdDsooRIMICI0CcI8rgnJdPstqlYcsmvJv9p1g2UZJLnS+z5ERH3wfkZl6kBeVbtx37QbtV9JZqPQU8rREgHVaCXRb021vCoe+1Cwv9Ex7SZQBICJg8NNUT4AJ6F8uM0nihrgeMg2yl2ZIgrfzejdMUFHLhg/FHCLrDYCY9ViTDSM468RbH6FNmnRiqf3hoO9KdCeH+lLkMSKo7T3i4k5JhvKOsBnClhK74biuyBrCa4rr/OxCbJ/7TCJbzYym3KOeaTk+ai4koI5Zv1D+FE+CXgVfQHxVeHY+tF7L1gRRJqGHW3HogBch3mObBcJ9VvXVeDJ2Xdm/RINX8u7AOAeJAEkQB+Ewtx20sta/t7U2bTmEHOLULdTvTE20p2/r+sR6Gl5pwQJlOhrP4XWkO0fwiz+tH/aHGrI4axFbOrYyUz8r8rpEBebw4KEandUSD7itPXfHBp1sZ+xcRIF0drfW42aUAbs44PAhL2euGEkY4Y8Ylq92mr27d8BuAZm+UrlFdRdIxnjzyesFrT6IKcVqvdNYkLpQFKH6W6GcYFuHqo9oiTDfh0+Xo17EICkTyp/FZzyTn9l4aUWuq1WSBfE8iZldbwUIMfm9nR9kNfj06CmlwTVqnx+LpeF4+SZt2pYIrRnTFmy2aFTg1KVqZsFT77uMDqcFOk+P6ln7urgphAk0AQfQLuivH2YYAE9r2PWpajjLrUeBg3BICjl7T9
 S3FPEV88
 4eIgvcFLDHVpBorCt9/5bTlX/z6QxWavsOfJtyrsW0FYNQ6wlNtHktOMK6NgwJQ3NF6YN4cTo5bUPwRo4RoIac8DwiN7ibq/xmtOq5XlnKlVwaJkw5+v87D2D3bG37UK/XzNw4IoDEApWHIW34xeKoae41D1TL8O/hYtJSC9rL9e0zVhVgRQEawhhk5yMEG74fnHrD3NbgiUMCxfreeFXobNjX97H2BdCVSttV1GHFLb/Tao2KraHqWy2Yov2ys/QLkU7ZW7xR25a2gavnKucaizEXnskpaijxcFtrtpFD46kSPB/Y3uLj3mXsD7tDxehOI/f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 3:34=E2=80=AFAM Kiryl Shutsemau <kirill@shutemov.na=
me> wrote:
>
> On Wed, Oct 22, 2025 at 07:28:27PM +0200, David Hildenbrand wrote:
> > "garbage" as in pointing at something without a direct map, something t=
hat's
> > protected differently (MTE? weird CoCo protection?) or even worse MMIO =
with
> > undesired read-effects.
>
> Pedro already points to the problem with missing direct mapping.
> _nofault() copy should help with this.
>
> Can direct mapping ever be converted to MMIO? It can be converted to DMA
> buffer (which is fine), but MMIO? I have not seen it even in virtualized
> environments.
>
> I cannot say for all CoCo protections, but TDX guest shared<->private
> should be fine.
>
> I am not sure about MTE. Is there a way to bypass MTE check for a load?
> And how does it deal with stray reads from load_unaligned_zeropad()?

If I remember correctly, _nofault() copy should skip tag check too.

Thanks,
Yang

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov
>

