Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D059CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 06:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3B128E01D7; Fri, 15 Aug 2025 02:14:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB868E0002; Fri, 15 Aug 2025 02:14:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA448E01D7; Fri, 15 Aug 2025 02:14:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C94D98E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:14:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F38A118063
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:14:32 +0000 (UTC)
X-FDA: 83777977584.21.D968C49
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9767F1C0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:14:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cFDyLNNK;
	spf=pass (imf18.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755238470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RC3G8Ydq/hH7/R8jIdeAziyUg1MV8Z+nvGhUkoaFFOw=;
	b=00IrO7Vk4uq+aiG87lpxU3k6CgDaV2GtOcBrC+7SRc35hWppM8Eu/dvUvfQaLP6MfquW0B
	9Bh32mFNocRaeWimyrMwydMiMgijiLSTAUr4RKfZlqTqAkUNPtAYYC7JZQ3pSIYxJFleV2
	eBzN9eVtWejqDLBOWSaKAgRvETMpEac=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cFDyLNNK;
	spf=pass (imf18.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755238470; a=rsa-sha256;
	cv=none;
	b=N9OW2PsUwnYhdKIhGugOiKS7d5hE45XQuCu4qXAbB/LU7v7ovn4ACO9qac+jeMZfO3r8bv
	BOqwh8J2ZQDL8MUi6z9ji02lKxh9ukCtNBZHg3rA8quFC/uyf7CNlxQEhVrc3NfXi9sZoi
	12U5yhyeLAqM+V42CQQW9ARKR5CD9Xk=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3b9d41c1149so1258875f8f.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755238469; x=1755843269; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RC3G8Ydq/hH7/R8jIdeAziyUg1MV8Z+nvGhUkoaFFOw=;
        b=cFDyLNNKiGGyJccAXaz+ifyEqamBkmORWR0wpPQodQUIIR2a7KT5sMa6k4stkxx3F3
         6EXD+E5IRT/nEb1NMSZK/ylgFvmIrkBwowt14fsgVRIvX26ZHNiIoCf4XEHYp7+YeUB9
         lbuouoeCWd40oxyo7sIdFuXiHC+DhZfDXhnbDKxU63iDICoMtUUUkkM2oTaId1K6Yr3m
         U3U+jwgoH5A9sldxvqVh9wkedu5xgKBLMed7EUqCc4trMptdiYW0FJjTKpU1ULwfZWEX
         LexK3xN6pl0IJZ0QOrtxx2+T/OpGhdj1UDmRA1yaZZWFnr2QXEa44p54VjjHiRRrMEi1
         fK0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755238469; x=1755843269;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RC3G8Ydq/hH7/R8jIdeAziyUg1MV8Z+nvGhUkoaFFOw=;
        b=aGvaXMJIIc/RdadtywS/D0j2iqSPraVS5AwK7od9erfWAqy0J2UP6NCA+XNEw/zb2h
         pVmt+ajbprRjmF+5XZKbMbs2A1kKSXMUOsbKeP9FeiQqjJNddy0XID8LAkMUp/y2xSIt
         4UtEW0NUAiFh8bfyrPhAjzEi/+G1aNQUEu7YhC0tQFlmj9AHivNqExJh6+TzymGd4uCZ
         SoYGBXtIYVLaRIu9RjXaqXnNIfCA36xyZwcHrY8envwegXB8jRqPWsB/Wt5u5qvK0ZVK
         gjCf3dO8wWGULvxKXPKnZz8rVIFUUyygNf3WIvTju5oKos2RrHE54vXHLNZmU2MMdZE6
         tGzg==
X-Forwarded-Encrypted: i=1; AJvYcCVS/77LuogUQSbKdfYy1ToHS4ZxjDiYk48ikcK2/8P8Y+k1T6jotELpjd104V76FBwBN8vGPxCbkg==@kvack.org
X-Gm-Message-State: AOJu0YwB+LCidEMTyvcPl4fIzGwGGTESyROCK011OWSuvTMaSIUWSh/H
	h/UQbv0Cd2Vj+dbOnX/7SDi6vK2aAClXDkrlPPJpUQV7H8g2o2V5kuzcnTsZrJKhgJkno0/Z3LX
	Y7FghPQlnuDS2As5rq/PKwlYKQsuRQvc=
X-Gm-Gg: ASbGncvBKrO8wYHaSOj2haO3KWaIQaYWxYGhx5HbmNtQ/E0CwjBDTjEOfz9Z1szls6c
	b1o1F0cb51Q7Wt0T3vmZWigzxVfcq8ftZIqQM5mMXuyRPFir2FmyxE1zOPiEl2A7ZpuX0hobVhs
	zqwB3lj5/7eJNixdeAC0HOOv1YILHQvnGRMFWES0M6L/kAQBDrQFgMGvFGog3fDp8lJ8yXsH+T1
	PZGsPJN
X-Google-Smtp-Source: AGHT+IGcfJRbvVjPwlmwrtipABpPT2k1A2y354zwiag+PFS0u1nqei6MBVPlvAO14bH2h8cPLQmeAXffrbKgUI/mnik=
X-Received: by 2002:a05:6000:2584:b0:3b7:8a49:eed0 with SMTP id
 ffacd0b85a97d-3bb671f56demr475473f8f.22.1755238468843; Thu, 14 Aug 2025
 23:14:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250813175335.3980268-1-yeoreum.yun@arm.com> <20250813175335.3980268-3-yeoreum.yun@arm.com>
 <CA+fCnZeT2J7W62Ydv0AuDLC13wO-VrH1Q_uqhkZbGLqc4Ktf5g@mail.gmail.com> <aJ3E7u5ENWTjC4ZM@e129823.arm.com>
In-Reply-To: <aJ3E7u5ENWTjC4ZM@e129823.arm.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 15 Aug 2025 08:14:18 +0200
X-Gm-Features: Ac12FXzA1cRDanNY9nNRCdMRqZ-71xbNZTcaUrUR9hUEP-TJh9C4NEiHu1Mi5Xw
Message-ID: <CA+fCnZdFVxmSBO9WnhwcuwggqxAL-Z2JB4BONWNd0rkfUem1pQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] kasan: apply store-only mode in kasan kunit testcases
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com, 
	vincenzo.frascino@arm.com, corbet@lwn.net, catalin.marinas@arm.com, 
	will@kernel.org, akpm@linux-foundation.org, scott@os.amperecomputing.com, 
	jhubbard@nvidia.com, pankaj.gupta@amd.com, leitao@debian.org, 
	kaleshsingh@google.com, maz@kernel.org, broonie@kernel.org, 
	oliver.upton@linux.dev, james.morse@arm.com, ardb@kernel.org, 
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com, 
	yang@os.amperecomputing.com, kasan-dev@googlegroups.com, 
	workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9767F1C0002
X-Stat-Signature: 5mht8ic8wfn7mnp5q74i66kop4edck5j
X-Rspam-User: 
X-HE-Tag: 1755238470-742652
X-HE-Meta: U2FsdGVkX18LSmtf3/pX0DjkY4UZYvlfiP+un3zIqfWfUN7/7j6dP++6lOIdBleBlidUT2a/fqaeFFArErgorfKkSI7lgXX3cVvORaKirlpuC85Y13HFhJoOvX4ubdRZq2II2C4f3w3nmLHtbJWdxnVeFACxG7nkp3fst73G7i14ecaoTup09RsStZ+FrsAPv/emRv2U80ZlhA+PLcVy4Eebr6UKs75GQ68w1sZ/JkL81qVWWDKmEZrU+MZGHeiJ3SHqWDh59v7CVMAd9x84WAcDSv4lbqUpuDqi7OxeQdIh55jEv4WTwypSCwzNvTsnolnasUj2f29/d208cosuCnT5l81sXDQX+prg6m+QXgT9a0+hY+Ro6clF+g5GqmSuaLZQVcleaQjPofzcUfxG2spNtC1xjbK/B0irDTflUu5ARMR/LmIOTrFHlE9SvLS7IZVGp89vYrVKLI07N+tgmY/29egbfF372kOBCvmxkjoojB6tLAgKfGIG9FlmhsuJ9UWoNUVi7c1mFzGNMsK7dxRV4BgiS1gSr2+T9AEMoiTbQl+gMMyg/bgMTMzkDSrLRgLtfJtMYaIWFXpIpOTMxVIbEHvVDQRXZg22z9MZF+AzdJ1XsjnBDnFcMOXg3Ilj+qwtpRGlh15dWHLCaZjKW1wy168UgMG3p7AHFxDZFVfSwKBkh0zP3e9a5Sy01OF0zeI3Ct9wxPM78NdbSR9id+5m8dO1Xnwpek4xp+NBwShwus/kESbL5sBeB6sCRRG/HEnRxKa3iEiq5q7egn0Tg9HLvQwVQAkoIF8BQIti/+VEy7z4D9B7mNAZ+BjiaBDgIOnsdhJ5B7fySuGQ9u4xPmY+qyMkGAfnIh2vWOiPt3zm4aXICExyC5nwd5L5r27aCqXNrHlpcuHxwMtOZtCO4DM2tmvWMLvh+58qCbXeMuDQRyrn9wCgrAmMyHBwv/e0Q3sz41xNgglEDVUriph
 dMnRpWCu
 fCYR+6PtcAaI2IHpIJFKcVswp08GS/3Y9IJYyNabo1AjlHyCj5pwYvkQCnJ5BMEkeRqxahVuAzZ5KloKedRvTE0kuvstQD6rJggomkcYvy2OrMxWsMCtaK8RPULtk18IdK8w0ECHauQIXerZNhnIfZa8VzU3ZSq5QhcZmsomknIwRuPvjsat2nR1iu8zn9NOEOYUBJZg+CwGsKdtKpA3qsnfqHqN+g/RMhzt9rIbSWIra0ocOSvExIcmqYZQO8MU5ZTRpqMrBElPmpjd8dV5FSRCzGSoZVOw0Vev85qSsxq9zDXIvHFY6u/GIGfjcOrtzm4n2rUHjIWdbGZGfeMRpRAKhVtAF4SYkhK6mvPCJ3W/8Fv5HhQzaoRq4U038SJy+w6ZzjmoM1A3jXs5cYP76IFzyTjw0MZP9QHi+aB5YbMYQ3D1NeNQx4tawZDO306SzKCLVLsM4sgFc+F27Rc4Qonsqf4bg4Qp6E49NrLArXy4Zh9WlNmh/3SI6MPqLidFlq3dm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 1:14=E2=80=AFPM Yeoreum Yun <yeoreum.yun@arm.com> w=
rote:
>
> > > +/*
> > > + * KUNIT_EXPECT_KASAN_SUCCESS - check that the executed expression d=
oesn't
> > > + * produces a KASAN report; causes a KUnit test failure otherwise.
> >
> > Should be no need for this, the existing functionality already checks
> > that there are no reports outside of KUNIT_EXPECT_KASAN_FAIL().
>
> This is function's purpose is to print failure situtations:
>   - KASAN should reports but no report is found.
>   - KASAN shouldn't report but there report is found.
>
> To print the second error, the "TEMPLATE" macro is added.
> not just checking the no report but to check whether report was
> generated as expected.

There's no need to an explicit wrapper for detecting the second case.
If there's a KASAN report printed outside of
KUNIT_EXPECT_KASAN_FAIL(), either the next KUNIT_EXPECT_KASAN_FAIL()
or kasan_test_exit() will detect this.

