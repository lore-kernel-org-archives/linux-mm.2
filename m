Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B542CCD193
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 01:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5A818E002A; Thu, 23 Oct 2025 21:35:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B488E0002; Thu, 23 Oct 2025 21:35:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFA008E002A; Thu, 23 Oct 2025 21:35:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9868A8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:35:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F344160D00
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:35:53 +0000 (UTC)
X-FDA: 84031291386.20.CE91A73
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4F39840008
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:35:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="F8I/hPC2";
	spf=pass (imf01.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761269751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cq8gqqeYooxgW5KYKmBo5Rs/wh49wN/6rTY6x+8D8QA=;
	b=AqYVsugen5iFqMXbtMs0CuWvRuNJMVR1i3dVETrtUbEYzkdIWBgysq+GcvYbxyjnGBBDHf
	8oMlozwRvFbGVTkmQck7zf7G15LWCu7XLMh13FU4kKjeLIoIWHgAG5bY7h/Xh2CE1ARy4Q
	PK0o2UVL9QHtLCYmunzPlB8DMy8fsPE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="F8I/hPC2";
	spf=pass (imf01.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761269751; a=rsa-sha256;
	cv=none;
	b=3oUbCC5QjsXBCdU0N8v81fouymzW2/GEGSrTXbo4ZBmMSFC+RipLq5lkrJMsTq0zYdgg5R
	4VXIXb5pMcV4W0XuWfBEQ7sRbI1FqVWvbsSyhNcX/bWdVcQStwMKuJYvM6u9yMG+uYc8x+
	NPTRZHNy5krbktQjtF6zFN77k5itPUM=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-475c696ab23so8522835e9.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761269750; x=1761874550; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cq8gqqeYooxgW5KYKmBo5Rs/wh49wN/6rTY6x+8D8QA=;
        b=F8I/hPC2Pp7FHwgFcuFbcRa5Ycap3Zrolov2aoZ9MsQf6gkpVlExVjzpyHc0Pt3QoK
         nIzH9XdokSeNfhJ7QtTS58U3ZqEKtV2eQjr+iTm89NewU71U2xZkvCgnErZ7c/nhBkLl
         XH+vl4zbH3dHiLQh8aq0FveRk+onlQTS/Ty5btQXENhi/bqkH30ZDOAI+o1ripZCKH/U
         rOnjvtXVp8qQEFzobQvXibBFFF3on22U1Q5RUBnWIXxa+HHNA4ruprY5H7q1uehwCeL3
         /B5y/AQi1T1H365GWycE4O1JkFsnByMK0n0meGfaBpA0cLLJA+aOmzn27eBPzNXwzrGu
         VL7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761269750; x=1761874550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cq8gqqeYooxgW5KYKmBo5Rs/wh49wN/6rTY6x+8D8QA=;
        b=rk8WsrySBlRgVg70wJuUu5LuvQ6kFKajYu7UyLNyw1eAWeTL+qrre7DpYnVR9EqaPc
         voaG6KPtIaOxKCh97lVXGC3nPmyzK9i8PsfhIyXF2DqqQLPSrz8+K1kHOwSzmMebvr6P
         K1qyfGEia9OtPmtrWs8N4SNOyqMhSCt2RgQBlPx7mNbg9wmCbbGt7nFbPNpN7gGUSbjO
         iUCy3j1MrCA9beYVwDHVFxSeOMkOAGiNMNb9WkdSu/fhSt7jjyhof/JgVWbCyMpl0rR5
         FUpANrD07BfEPRoR4VDmbIwf3jcz/HtK7iHoak364AfWMgDTNh2JD42tWOtEicDVEN0t
         kzEA==
X-Forwarded-Encrypted: i=1; AJvYcCWZzwf98528KBgGRZYaTc8HVjIY+E1DXegrmMUn3LtpD9vAnxqEO8PPO5zTe1MsaVAqIOtaNqMndA==@kvack.org
X-Gm-Message-State: AOJu0Yzds231rOBDLTk+JEi7jN35vSrROFtn3EUDLqF0VfkGLiGzKF77
	MwkX63hVPCVYJoEEtDIxQj3IR7XPyOKq2+HZgkFv7hEt7vF2HQC9Yc1/CnqMpY8xc4cSvwcFVly
	AN7RiTmXJB3InjBWExFVoU1NIU9OdfH8=
X-Gm-Gg: ASbGncuWiRD6u4WPAkiCSGmIuSUXFH3CfjlJltLc2WdcWoIhHHuzm2jBfJL8GRW7B51
	NhAM2jMGKpXgVTlXCw6nIQfdnlwGzk90K9omObzRu+t4nKPtUVw2PLDe2FICLIzywRdn/k22HKp
	UQZ3mOy2erfK0F33O2YFHrYD8jtOlGM3o6pX+JdH8D3edETnQQdSbwwiCcJ288SZ5ny2AiUhSNo
	SzmUfhIDkw8qhIz4GHUlDKeFMiDcrI8/BnTM+rEtpfHsP9KVAuEQQLimdFixr/RBrNqi2Lk+J68
	9gT6YYXMSb/IhQurJ+w=
X-Google-Smtp-Source: AGHT+IGwrfelWdU2yhalAC0i9vt/hIf2/MMW3kPsGCKlhtSvPHBTMPWNKLBb8oATlrSieozyy7lk2jNHzMN+c5GsljA=
X-Received: by 2002:a05:600d:4355:b0:46e:45f7:34f3 with SMTP id
 5b1f17b1804b1-475d39b9552mr1422285e9.8.1761269749552; Thu, 23 Oct 2025
 18:35:49 -0700 (PDT)
MIME-Version: 1.0
References: <20251023131600.1103431-1-harry.yoo@oracle.com>
 <aPrLF0OUK651M4dk@hyeyoo> <CA+fCnZezoWn40BaS3cgmCeLwjT+5AndzcQLc=wH3BjMCu6_YCw@mail.gmail.com>
In-Reply-To: <CA+fCnZezoWn40BaS3cgmCeLwjT+5AndzcQLc=wH3BjMCu6_YCw@mail.gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 24 Oct 2025 03:35:38 +0200
X-Gm-Features: AWmQ_blTT_7WNBqDPFmuMJp8o4vQAMauOpamt3NvIm4L5ZNNRzy9gCKm7HE9f0E
Message-ID: <CA+fCnZezciDNL4-Yto8d3bPOc3U07hY1Q_DMk926-1H17Ugx3Q@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: ensure all metadata in slab object are word-aligned
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>, 
	Alexander Potapenko <glider@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Feng Tang <feng.79.tang@gmail.com>, 
	Christoph Lameter <cl@gentwo.org>, Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: a1tiridqa9sqndqek9t9rfkhjc99k8fc
X-Rspamd-Queue-Id: 4F39840008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761269751-622787
X-HE-Meta: U2FsdGVkX18nxHhsV/lSaJqxziiEeX1o+zLqHClgJJ43iDq7yobNo7OGeJWKd6mGjR0vSIAAP0opjUcc2FcrqzIJqkY8/8yj776bF+Bi1WTX8xSizoVf3Ypp/wH8D3L4EQWxCMkGIlVXCt9CKi8FH+RbjSqoGNuS4iCIF3XSc64zMvqFLMmjunD0eOdCiyKTFvkGjsOLiaNpdwWIpUBLwgTksK6Cwr1ICWxP5dIFsI0j1NJkw66Sgva9oplD1dG+HiepemKiXCSsowDtQgrIV1cEwU2eV0+sLHkn869Zh5BobDT0r7zS9DNFtkuM3GIoJesU2MC8V7yva4etTgiogZjfIaxVG6ZkJ8bxc5SuQsbv25QRddhBVJRwo6fmGxMDmY0azR8ogQdVmctEQC/ryy/UWdQyJNSaupAtzmQsY8m9IG9Tp93g6q6RxfgNH6P57PQk3r5LB1MZadRHt1qa2dveMvDgdowkk4H8MigCW3LgcU4gSzQVfbXrzAOW4Uw6rTq4SJ0O9uVKMApZfQlNFbkO57g+s+20L3h/QKpu6NCl8Wq/5T5z0AcATSLWOuaqbvnPX1Y72sYzVJMjtUdWAKYYkiQXV7I0SYEjV2lJH9pTqwnZVPapdLnA/iYC6f3FBKPpzJKvcAb2Q3D4xSZOcSwbRlrGis7IiMYuJGYPFCwIWtqihrr8o+bipzo8ZAuNG/IPjpNhoS3ObA8mHChB+t8zhfR052xlRkNi+W7gJ55jeOFb9kOEcNCFMOc88++Aw7ExvScv82gT+856cRQU8Xl+bhEr7/D7eiqj6M12Y9mhtUC8lW6h4Ko4WC1MZp4sKLMSEvjEnhuaBH9YXhwQVQfRon38EXdl/OzEDrG2573Vv7tuAJ5/YEA1js4sIVimXgVihPKTTpZ4lTiPtAUK3fHRRnrubhT2yr9bJsHmNaJyG8PYIgzaSamShDEz181MJDvDwXXDWpHCXF+61Cf
 oSjqHg32
 lfP/zw/ODRQvCsFwgXd8/XyCv1ZfxxgXex9JBnXYsMacJM1uediduz6h5wTzWCx+qrDQ2tVOpEoLQpmppcH2eKUjG+ABbo0JTakSUHN02JiRK1gZ2dmOUrZP4bIy66n62RySBZwzRx8xSK6a0aWL2IroNwXal0e8wo8zHIebpOeKPR+D1KuwY7ieuHVlPHv3jbEOV/qWON5FA435EW4Vo0G0PVdWhpoMuI7TYBQXQoM7TUecX/eBGguy84omZQzx+SJ1wWPIySXylze5MKcFb2yTRFOP5CByQQq7879rBFxWlNvRB+L64nRZuBCWqie6kgFUq110Qy1doitV3HpEZzsrJhGnhgVvrsClI4GyQY9SsMCIq0pIdohc5YoHbMAntVaT211c9UQMLcj1HWO6VJ1QgzLUarXmmQo6NXckWzITmwhjR51LwPKfRpVcW9p0yeebp3nhgfjDazVRaRG0Xd7aRUr7Hj+h7i4KO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 3:19=E2=80=AFAM Andrey Konovalov <andreyknvl@gmail.=
com> wrote:
>
> On Fri, Oct 24, 2025 at 2:41=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> =
wrote:
> >
> > Adding more details on how I discovered this and why I care:
> >
> > I was developing a feature that uses unused bytes in s->size as the
> > slabobj_ext metadata. Unlike other metadata where slab disables KASAN
> > when accessing it, this should be unpoisoned to avoid adding complexity
> > and overhead when accessing it.
>
> Generally, unpoisoining parts of slabs that should not be accessed by
> non-slab code is undesirable - this would prevent KASAN from detecting
> OOB accesses into that memory.
>
> An alternative to unpoisoning or disabling KASAN could be to add
> helper functions annotated with __no_sanitize_address that do the
> required accesses. And make them inlined when KASAN is disabled to
> avoid the performance hit.
>
> On a side note, you might also need to check whether SW_TAGS KASAN and

*HW_TAGS KASAN

SW_TAGS KASAN works with kasan_disable_current().

HW_TAGS KASAN does not and instead relies on the pointer tag being
reset for the access to be unchecked.

On another side note, unpoisoning slabobj_ext memory with either of
the TAGS modes would require it to be aligned to 16 bytes, not just 8.
(But those modes do not embed metadata after each object in a slab, so
your patch seems fine to me.)

> KMSAN would be unhappy with your changes:
>
> - When we do kasan_disable_current() or metadata_access_enable(), we
> also do kasan_reset_tag();
> - In metadata_access_enable(), we disable KMSAN as well.
>
> > This warning is from kasan_unpoison():
> >         if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
> >                 return;
> >
> > on x86_64, the address passed to kasan_{poison,unpoison}() should be at
> > least aligned with 8 bytes.
> >
> > After manual investigation it turns out when the SLAB_STORE_USER flag i=
s
> > specified, any metadata after the original kmalloc request size is
> > misaligned.
> >
> > Questions:
> > - Could it cause any issues other than the one described above?
> > - Does KASAN even support architectures that have issues with unaligned
> >   accesses?
>
> Unaligned accesses are handled just fine. It's just that the start of
> any unpoisoned/accessible memory region must be aligned to 8 (or 16
> for SW_TAGS) bytes due to how KASAN encodes shadow memory values.
>
> > - How come we haven't seen any issues regarding this so far? :/
>
> As you pointed out, we don't unpoison the memory that stores KASAN
> metadata and instead just disable KASAN error reporting. This is done
> deliberately to allow KASAN catching accesses into that memory that
> happen outside of the slab/KASAN code.

