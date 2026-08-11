Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E314C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 19:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D4CB6B007B; Tue, 11 Aug 2026 15:20:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AC046B0088; Tue, 11 Aug 2026 15:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C2A06B0096; Tue, 11 Aug 2026 15:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE1326B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:20:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62BFA1601EA
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:20:24 +0000 (UTC)
X-FDA: 85089954768.19.7F2F6B4
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7915A180011
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:20:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T66BHWbH;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786476022;
	b=X6AV0X1KKN/69vvpywyU13Exk7Cf2v47bfpQKIgb2kxtIrbCG/7yxr2XMarSrmQJDc2e40
	yl5pvllTjw9+fYRRE/vGFMLJa1jmdfECeuu5m7/EmSb7XwOBC68Muv0m4vMMO/x9w5glQP
	E/OM7C0/QTZbfE0Pozp7hCmReBX8t0M=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T66BHWbH;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786476022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0tI9qUXL0/pdjc8WBu7cnqr0pTI/K9DzaSGDO9Uh+8=;
	b=wlDn8vDX20AArDY/+WvwckN09wQ7Dvw4RPAodRye5fBx+YhO6GK/QQnXgoiSCjo3bsMJeT
	nYXNmMF5HBpzChELFpv5cKsZ32j/xqkxrTcMXKX/Nz0utM3mdjZ5EnrowGM/aCXCB6XxZh
	c7an74c83can8VZ7P3OuTXRtwEm/zGY=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47f703a9d05so96304f8f.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:20:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786476021; cv=none;
        d=google.com; s=arc-20260327;
        b=OLihG5WC+GWySqBOPR1qhiebILQ13HPsGxcvx2V6VtIZnyPDOcnmgsctzQks57UW6N
         5N1GkCPbwdkWKPRu+VCUXOMLk2Q9Sj+lHIpREBHaHvpqGP2cdZLZfOb1lut9wEbgVAOl
         nJvzECGRhyJLW0jk2vKMayOyajvaaPCHuzniwo0SFNBJe4MhSMBdw2ZclHR4Njy7Z6wq
         rHb6sgw7UJu3HXDxfrjQugbNdkC4lCfeJW5tK8m0/fTBVEvGdgA5+0dvMx2+8UcbXaf+
         nIg+6m5aAQ5rNsBmxwLU5b/A+GcrpHt1wV4tm/ZvfWXJrSvZIOvzoN2fNuwo7aN/m49R
         aGiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C0tI9qUXL0/pdjc8WBu7cnqr0pTI/K9DzaSGDO9Uh+8=;
        fh=k18gi2DdLBYakATxE7eUd9kOeIG/9ssNB7+OQa6KCEE=;
        b=IFeulbeJxMFjm3xb7crbiXT83WafSea2008f1HBsmWmrUksYII/Jcu+8WzHcXpjg31
         Cw15+k+/qEpHXZMraGMJhYkvLUNWcw33zH16Jg1Gg35Sk7AVJymKr3mBEWm6w+bpqWkg
         W7xy7xO7p/Pljn2hv5X8ZbuPKVU+VZixz5Dr6ufdGcqXRhimDjXMABbbuMxUjMIM2heA
         jtbA09pdIOIk/CjdzzxcpyerbIu0DTvfHCl4JXz4z+ZSoyL0ibga5OaqT9//3P8Wnebr
         0v8Gwdc/X1Zz47sRXl+4NR4N5crtfvKkhGaKGIYq3CHF31GUD45gnIiJeWh/ZRPDmgeO
         A2IQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786476021; x=1787080821; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C0tI9qUXL0/pdjc8WBu7cnqr0pTI/K9DzaSGDO9Uh+8=;
        b=T66BHWbHgJrr0mAq+d5YUVY42KuiXvIo3cI0rWFAeUMzzt9khumxK7J9EUibEA6zlP
         56yG5AU7gSWWQ9m66rO1bYiaukyTm9YFOdz7j5jyvfnPpX01vSGXfi3OYwKnA1G/dvWA
         e4E25Sxz7hoSW9hVwsQoFwmCvpN607nsKI4XnYfh9aZjctsyN8jXDiNJPj8+p3MmrS83
         ImNT5Q/QHmyb4sGlZj9/mJjcbnmUYFTfLb2xHOjk7Iw9vtaBsn3mS9AMNZHCa7RV5iRm
         b982LXNr93sNj4O9GbTPiq3vons+iu3zujXb3OWC7K9Z4abuO1D6rC0FI5/nSsl75i+r
         Il6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786476021; x=1787080821;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C0tI9qUXL0/pdjc8WBu7cnqr0pTI/K9DzaSGDO9Uh+8=;
        b=O3SXOWiW1jAlJONz3oOZK17I9WG/+vHiAy+6UPW+44tEVesmqk/Eu3I5x/nHeHaG+U
         +MYmL7LotGrpjqpEyxho3BYV1pRUEqWDQ2sWZY80THRIfBYqil7Fo+/6aRzmOKM4GE5v
         BU/rDs50+D50ni9GiTHAAEXWsx+7zG19cezPpx0aGeknDJamowjUj8rjbp95b9TwIPh1
         SR+SpMwG5qn18a6aj9kIzwt7hsIPREoaU8h86RYarod+PMWkKD3YPH1z25NUgI0Ek0Ah
         0Gg0VfS0QMn2UuKSOS8pjG5We22FlBC/0ATjXPaHEvuWh+9dBVuU1IHc0inVeadoite0
         qa5Q==
X-Forwarded-Encrypted: i=1; AHgh+RoNMWRkBUUEg6X/m0STxSGsoEkKqRmqRWfosxejw/xgxhuFAF6bIsEIOiMfoOzfnZ5Wdmn6zDgbAw==@kvack.org
X-Gm-Message-State: AOJu0YxixzRC11a1AZYTsMsMl8prUqNEKtHRt7NFznnfG/Av4/mHvyTo
	twRktAi76ltJfSW/vAdyAwYMi/blinlk4Cc2qoGLMpsVH6jSGD2y3NUL/dCkq0xxrCP2AsRxQkT
	NX7qQd3fdCTBrK2Qxz21vyO13YlfQU5c=
X-Gm-Gg: AR+sD11tUCPW6jFJyCenyqWILfnDEfa8BnwutkHeRhOLEoLkSKCv55EekrJp4q2TlXg
	DdiTjHUGP2fhyKBp/uJnntGMKheMqEP0UyuRfGmtCpSYLzfGGfpOS4g3QQd+fvsA1RaJOhR9znC
	8JHC0ptVzEk+sIeiz+YyUmoLWedB6yXc6S5m7NgB0CtgfzCK/mFxgxGOyb1bC3iUZx3J50QoyTh
	iidVxCy8S5bQR4YYNlYXkmd8WDCz/p5WWrpT5cPLQxKUrVdRr6QMATAVfCy4aZDbkNoL4ljf5yR
	FiqbjapoXuDJKvKy5u+bP+H4v0bHy1MjR0cMcSupjJcB9pxGepSxdQWVCswmhXO9C5xzVLct126
	U
X-Received: by 2002:a05:6000:2687:b0:47f:d072:87d7 with SMTP id
 ffacd0b85a97d-4814ad8531cmr9844062f8f.9.1786476020845; Tue, 11 Aug 2026
 12:20:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260811051434.3805648-1-wfelipe@google.com>
In-Reply-To: <20260811051434.3805648-1-wfelipe@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 11 Aug 2026 12:20:09 -0700
X-Gm-Features: AUfX_mxREYM0a5ro6axfuWwtuNUtoNVGyXynzVlYalBNbqZUMOkUoPV4WEi7gaY
Message-ID: <CAKEwX=PW8D6z3Oq7o9OYGXV1YF3g8mxq8rGDU-Tjn2FQQZ-XZg@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/cgroup: test_zswap: skip test_no_kmem_bypass
 if debugfs is unavailable
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7915A180011
X-Rspam-User: 
X-Stat-Signature: 4h1kkcpx8b3hcspkfeibuxhyz3aes984
X-Rspamd-Server: rspam06
X-HE-Tag: 1786476022-102350
X-HE-Meta: U2FsdGVkX1+W9jIR0uEIX1clV0idZSM+D+b8+O3pm1qpxqvo+oLqkcCRGQIUJjWZIcZTyXABoKydaxS1Y61PFpfqFWWb2EoDoTyHuyURXCAcH/JceSiHKeNgMIOA9jyDRFBm4tB6SlWjI06WgwP4UcKqxkXebsLmykpB5TM4N807bmIWanxuMksZoClTN+rKIA6Oobv0AnwPNxeKnRuI+o1XDrUfPACX80jCJ6wPbsk8dA0DCXR/KcamCH1e6DPv403b4kILx1l1/UIQZfbjnxfgnG/DBuyZnyecI3dtpuSgEaDmm0N+qiLWL+mrBUtMsg4T/+ySczTEf+ss9qtEZ+ULEJ4zul7wk6ZiBeZoXBcVxrfTSIk4ktW1+b9MpREcqniJnhGfNa0Grk5LpmtinkPe2Dle2I2Dmj3dLo2YOSq0prAKFHUZUs5HaLstldB2nYS3io1TKLNZXxNHIUdVPCjkDr9AKmzW8pAXka0qaynJjxq21AnmNimcHFQGsYK0DrvGnjjMTMYtIAFHIQjTO5JpszBlc/dBOvW5zMpydVAoBcjnEEPoJsneqLXt1ObYOhbgYxtU3me10pRhhEuUokb3MsbA9yuAXfgsWe8zaUkLVW90QpV9lRuTC+Yg788Unves6kKnRY3CRwqROo3YBVtNk/wK0LiYfMgMOUyzEJ+mFCuYBORVST8DTkhjOrg99ICvxHrMDIRaZjqYYRJ4CWmwbemFjjgzvlGIcqwTY01YlGE7JBHvbEAfSzB1KUmtQ3vzvTfxO4dYVhNagki8pvozp1SMWCRydI0SAxgOTeT8awQlzGPl0nVwCrFkTA3TLgAsq4+of/0FZjGA2Nw++A7PTOKXgLUBy3D903/1QQvjxP8LvwneHxe30vO2Cmaq/DH4Iky7D0RrGzaJ6s2fgzBKo0ZaJa4KFt/H9UFIDigBTrCk+9SE0TL1XnkWTrROXkVTJKIQ0XXuRsheqQ1
 r8mqw2oS
 5fG2eyih4ACBUbvd2/OWgsttJ3buuMOYQRfelKG8bkGhr99nKMrweKwgRA90TPY42OWznD38CmheuWX2M3n+hh77fzJNhQ+ploPEq8ZX06V0EoZBIPlrRXx/1KFFG/TkcHZ871/ETd9EjyaDeEnNe9LF4c1sqRf26q5dRIXt4hBceLkO7Mzm7NIluwG8GZEV9rY7EQI7gBZk7LcM6i4saMJ0zVXY8p8/l4EVB6LMLSBQkM/anBmNO/Mh3v3p0NT4vi0+l1TYH1xA5CLAAsNpUVOMAJ0PzRrnLcRG6IsuMIyyHxNjETbj3SYnYQLNtTe11i/PnNq0D2+xW4cM0cKKL0xak9tmqd6u2a9cCF8LuBVxh5xHct7Mk7Bp/fYwKo80vzBKBHRCfYu7T3suZWpgwQ/Mhko+CN9L45KIING1VFjtad9yht7GJs7y48XFfithxGJVC47AbC1V3m/ZsvmHH/Dr2XVBPIe6gxJ7u6tEEvgspNsTdQT3GADAfsovvuLTKmkx7MJJyhpGKEyQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 10:14=E2=80=AFPM Wilson Felipe Pereira
<wfelipe@google.com> wrote:
>
> test_no_kmem_bypass() needs to read
> /sys/kernel/debug/zswap/stored_pages via get_zswap_stored_pages() to
> verify that compressed pages are charged to the memcg.
>
> When running in an environment where debugfs is not mounted or
> CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
> loop to terminate early and report a false negative (KSFT_FAIL).
>
> Selftests should not fail if debugfs is unavailable, and it should print
> a message when it is skipped.
>
> While I'm here, also add a warning message if the test is being skipped
> due to totalram size and make the check for totalram more readable.
>
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>

Acked-by: Nhat Pham <nphamcs@gmail.com>

