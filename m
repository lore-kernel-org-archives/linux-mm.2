Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6365AC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 14:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A6D16B008C; Thu, 27 Aug 2026 10:29:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3585A6B0092; Thu, 27 Aug 2026 10:29:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246BC6B0095; Thu, 27 Aug 2026 10:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EEA796B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:29:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A312A0434
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:29:00 +0000 (UTC)
X-FDA: 85147281240.09.E176AEA
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4E77140006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:28:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JnvOaekw;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf04.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787840938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PI7Nz8d3HH69nhtcQsyOVYUPwrNGYdNUTrVZkR05tbE=;
	b=jGTIY9Tq1L50+mqk3rTe/GnYxyederYBT7FXh2bAmsiO+0OSoq2/HW3ZIo8YO/fauP8EVf
	9p2NCcqJUDyY7KQXEi6RxBNNzacQMhqb+6iUL45FDgsqV54v9vTiEeSZmF1wSX0I95DQkF
	1nJikpAgVFqlHnKlePzKqZrtdszeBzQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787840938;
	b=2SoXwuYzAJUNj5q2fauu3aGjXKk2MmKMa23VG9oOXFTSswJ6d3irDkvt0CMNjw6VWyKLE6
	hmffksmlziknE+bXOYLlZB6/NylF8Us9xbNutQHlFQfSbpianPADvVUMTSnk5BHa2C2+TZ
	ih5u9Nk9C12W3s1jzwNKwwjseYuBgIk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JnvOaekw;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf04.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49554ebb87dso21160805e9.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787840937; x=1788445737; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PI7Nz8d3HH69nhtcQsyOVYUPwrNGYdNUTrVZkR05tbE=;
        b=JnvOaekwIukdvoeEHRMjqSSuGX/9xnohvsLa9WK8uk+9gkZ+HV2q/kbva5YC4is9ND
         l/9on1Vtj1V7x79F2IH8TmM3avddywFRI1GjwSSLrnB/LIzQdOtpwdMTi+OMzFvaxNSa
         v7h1sPO+XDpN4Vm90c0mlbiogfMvFN45tbGG9N43plxW5sxIuLhJBPCdn125EKOu1sEl
         M9ORb+JDOo+QdV5wZWbGSvv6jnjarFjYw02QA9Dbykh6KWZpfYpbxFBPnUoEWSQOpUaC
         8SqIq/3kpI0lemp9SQsixQRzyAtBlk+L8GHpJgOO/f0oHo36OO1sMO574X8psEryw1RM
         sqaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787840937; x=1788445737;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=PI7Nz8d3HH69nhtcQsyOVYUPwrNGYdNUTrVZkR05tbE=;
        b=idqsUoDvnrwwEwv/fVQzOwQKe2AIdd3sEDjj4CbnqWRVo7g4S9qoMvHfXgtQosHaeC
         zwxgktKgoC600pcyqDxdihnsBb7ZYiN0cuCEM2vymeAsFuAZ557mWF36wup0odBI1VaZ
         fs6vqc6Xl7fAL+eqvTcKshNYTVuFwBOsLjJihUpNY+IThkmrr6o0N9mthLuFarCPhUBy
         kWMjhPNpYtiJbPmP9/V7x1vjgnRrLMBXjxLsXXnoiiBKKn2eE6/7P90VNRlh0I2ws1I+
         F/LVYsnmmcEaFHxM0GWnFzgZ1TpsqKiUnIp/YMTSV1aVak4h5AkA4pOy0BbMXt7Q8/b7
         X4jA==
X-Forwarded-Encrypted: i=1; AHgh+Rr+wYf6qbCeZUgWiYPnFSVckxZXv9mbgcMWyneIp2WU9xlJsti4WkyjPs+zZ/d24eRm7JQO/vDwjQ==@kvack.org
X-Gm-Message-State: AFuF++lATit4UNnMapFidYj8SDnbNTAqeC4Z7BxktcpNQ/KHQLO9CSvU
	y5vzL5q8CO1QUNitsRCG7FMkmZt157eYzM6UjTq5+pov0qE7AQHKHGV5EVg+WB7G+JE=
X-Gm-Gg: AR+sD12h6K+fkcyoFFB1dtNge0EHdhdc/hwsN3x+HLh58p1hF3uB7oYDuGpaAj7AbsW
	XP6Ch8ufXBc3bbdAEQqcwYd3Y6jdazYj50WWJVkjN8+wq/oIQVG/07MyLCd2vCkvOGT+fZBacyL
	NFurZB4ijy/gl0SSoQw6ghdmV0DvJtajGelLwf4txSRaHkqGWXcJTixtHRCW8EW3OegTGrdoYx4
	QmHpTGYIlHkQEKtWpmUYuR7DTDdyhCRwabrctOTUu5YfazxYtHlZ2OriT2s1EHmNnNSvB+Zrbqg
	ZqfcGjldZyJCmFK9BljpWsqwkBnOktv6gKiy1LRX4MrCyLOwM3jrt82g5C8bOtrsHbk2QJxzWbu
	UrEYWi7wQIm+J7OGlDl2xkqdE9csHDa682BvcO/wHI1kVcL5Ns8dVpWxn5yrG/uYeTRjfezLr0G
	sgtcJ+w6nUdgs3bEHv4ekmQiL0AJGGwKnP7dE5IP1x7gDL3Z7gaBc=
X-Received: by 2002:a05:600c:698c:b0:493:cefc:d113 with SMTP id 5b1f17b1804b1-499dc6f5dcdmr215984745e9.5.1787840936850;
        Thu, 27 Aug 2026 07:28:56 -0700 (PDT)
Received: from blackbook2 ([84.19.86.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b494228bfsm54431465e9.2.2026.08.27.07.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 07:28:23 -0700 (PDT)
Date: Thu, 27 Aug 2026 16:28:02 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] selftests/cgroup: test_zswap: fix implicit
 unsigned promotion bug in test_no_kmem_bypass
Message-ID: <apBJbOhQakQH4WyP@blackbook2>
References: <20260827034807.2822234-1-wfelipe@google.com>
 <20260827034807.2822234-3-wfelipe@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260827034807.2822234-3-wfelipe@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4E77140006
X-Stat-Signature: 6ozp7tjn6f6zwbjoyk1ppkx7cez5fn4a
X-Rspam-User: 
X-HE-Tag: 1787840938-505754
X-HE-Meta: U2FsdGVkX1+fe97waLDzPBtxob0y4PivqpEnkdvbop5mDHPau3GVkv3nYyUNR4f4dH9WbDiFJSg7uppKxEjVXvb1zJyyBj2d480gmtVA1TiDHdql7/hCe+kD8KfbK5Yp5OuWJSW6i8Y0TpSv5nRVc4PTuAr/+93F5oqC21gmW6zBPG0qngEFsyOmsDriwJyTIVllYzEm8kgoiSFXTmoM2JAhTGXB3F8rWAWPTQmUc3NsLH7caPQEwcXLi5E+bDmUU9uAdDNy+wbVYmQsS48E5ObjdteKg/PeZs/t5YrmUkFTMh9M4h4HtaCtLR8FMzrab4RtmOtGhT+r0RKBaW4LrdijuN6P9X33cfjmoh7RS3gt1e4WqhuwaHSjgn7zoznv81waqFtPoQWQ+Iv2USK5NWErWavj/XmUXlNY476A9alfkdaVGQ21EDKdoLESTfDkHgA0m/s6RHBMwY/n8BJTaRfejqw/QC0D1ZJJiXActl70Tgj1bgySNt+ITAAdB/RXYCmg4tIPBIUTGaKjkJ87rub5a1QZ/ldEKxmuUCytBb8B23K2f6eKcwIWaKHeFkcYI/Xx5m4noIkwLTgxDs6HeA1orUzaGln44xUQmA8+yNcUYVgVh6esbqALcqOlIx5tZbAL+gSFriPMSLK7J0YCuY01rKAHh5ZPVUKdlc1aG655y8/jd1umZn/xSun4uyR+MmR/E+6tG84c3jofueorPClmRql+EHKv0ugpXRxkdZLbJq82Mc1C5L81nEAbOsnHcb5QSrSdZYNaAEenANXCQ2q2krClyKUjcPUcuJIjHLeFSEILanFgrMqh+XOqDEqgcwf6KX+uHSUgtedaP3Ap6xEj6Zvs1REk+9PQRN471ZXoaXjCqFoI3WVgYfwTp8P+fm8ENacHi5Kh+nAyf8VufqN2rlKwpdTQWxbRb5P40hyr/sA7krG5bGWpbgQR/CZSCFU1t9zrIanuQpzGjd0
 i5yu68yv
 bHnkOTIGAV9eU2KiXZLDkxSalZxV0YXgM2Kr29D9nseCnOjZQJe8pGfmyPTQui6ieRlCIVNYJ0VLusvGkWGZaZSH9+9kD2+jYA1zgJu71XUl/UP3RbFIHYn180mdgh64hciV3vsBJDyNa02PQXL2ICYglIzRCSTbnLk3yhNmEgXciUSL+x2wQNgYgjG5QUXnhLQW8kAkVw7MLGIkSaTzBfs9UvxqyZVvwPx3z/yAOEBTdtaDiGSjHCSOlTQLiuUwlfWSjb8d0IXpX599u9HMv3diLToQAFUTsU9oO9aDsQndOay5BDHTawCC+sfSJZDfG0lwuqiuSZkGaWL84cmKZXhI/irTRumyzDRNx4moSNPMFnVAwUbi9d/wgRpf7XtsjF/vrDpygahwuPu2IGK8levKGe9J1lkoiHA5CVuZN2yVJR3960PgK/A6UuCOlfgtTI7XD3QnIdBukIbnnCMYBbN3rXmjUDQ3RliUsf/hquvRuXLc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 03:47:42AM +0000, Wilson Felipe Pereira <wfelipe@google.com> wrote:
> In test_no_kmem_bypass(), delta (stored_pages * page_size - zswapped) is
> checked against stored_pages * page_size / 4 to verify that the pages
> pushed to zswap belong to the test memory cgroup.
> 
> Due to slight stat update timing differences, delta can evaluate to a small
> negative number (e.g. -5MB out of 1GB). Because delta is declared as a
> signed int and stored_pages is an unsigned size_t, C's usual arithmetic
> conversions implicitly promote a negative delta to a large unsigned 64-bit
> integer, causing `delta < stored_pages * page_size / 4` to falsely evaluate
> to 0 and fail the test.
> 
> Fix this by declaring zswapped and delta as signed longs and comparing
> against a signed threshold, ensuring negative deltas correctly evaluate
> to true.
> 
> Fixes: a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem bypass test")
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
> ---
>  tools/testing/selftests/cgroup/test_zswap.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Thanks!

Acked-by: Michal Koutný <mkoutny@suse.com>

