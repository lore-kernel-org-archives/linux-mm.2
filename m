Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2B5DCD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 07:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEF8A6B0005; Tue, 19 May 2026 03:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC74D6B0088; Tue, 19 May 2026 03:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDD6F6B008C; Tue, 19 May 2026 03:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D08F16B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:34:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9422D8C477
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:34:03 +0000 (UTC)
X-FDA: 84783355566.05.908C723
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9BF40140011
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:34:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=neXR+dQw;
	spf=pass (imf26.hostedemail.com: domain of mshcherba2000@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mshcherba2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779176041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nQEb3SnKmUgEZvX6aq8UF98SecrpTH59w1+qmzmaGdE=;
	b=y44HTjP0sgKcLEXnvdgD6e2fkJqiF3Uq4GTinCdjVMWKmdy3rONC1aig/lZBYMpcl4QZoJ
	fZg9NThrXi24NuK6XqDdSxDFbDMNGGkOxlRTwI2iSVjX7MJjM1ycmOVjHbug+6CFxHLAiR
	lYOU3evW2LKRw3ohmLjiixjHDoxv1FM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779176041; a=rsa-sha256;
	cv=none;
	b=VFlkB/daaxERJ5kNuIpExediv1pzeARe8zYoz59HdJuulOzOZeygAJ9UlYdYSilbYVmUgP
	TkPJ0fcFaG+I0voL7clAZwJLmstArknbAy/7ZSdkYtDDt0cUO8S7LKVbJm77lUJiwkfTbc
	WqJihKzX1p+6qZu3pE9ouxOeGQHgR2E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=neXR+dQw;
	spf=pass (imf26.hostedemail.com: domain of mshcherba2000@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mshcherba2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43d75312379so2757540f8f.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 00:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779176040; x=1779780840; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nQEb3SnKmUgEZvX6aq8UF98SecrpTH59w1+qmzmaGdE=;
        b=neXR+dQwsGslHQRv3UuqS4Ltn2GuZakv610OQRY7dFS1d0SA3TnlDTBlqD0X2DxhRG
         JxIUkpQpa+tXlUX3DPmpZVc1iAb151An/2va4l0W5gBdH7z6c51x76GXpWPC3Y3MQsA7
         hZvPFn1RQfbP4DAlZvhZUp6wug5XE2z5PtoeR9bVHMAvmn64NVRQ7uvkAFAVygCLs2Wr
         Arc1T4+LUYPjFigy4wTonlixbSVEwLsRi7/zHsts0Z9BzRxhKqbDioPtbb68a8hBz0lO
         rjXNCqEkt1iuoB8uRKlVvnPj1WXr9pfyPrTMUgksBGz+t94WdD7xHFQgbHsw6QXGmaEB
         +i9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779176040; x=1779780840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nQEb3SnKmUgEZvX6aq8UF98SecrpTH59w1+qmzmaGdE=;
        b=g6oIY5HrKcPA3eBvDjQBZStqBvA/tYKbbzj+RmmMgC0FZ0z3L45Y1Apl2SA5ozmowo
         HtUzN093TUvmyTPjEz4GAL1wSEHtb3d2KyKE4W9TGxJJvjfwIuuWs4d7N7qhjuye2MKq
         X4QJZ5e9DVjfS7aJQ18fh6KlVSoe9V8CmM2wJ0f4QcTnVVZ78R0sc128KxPeehmh89IE
         SHRySARuFGpkedfjCOoe4wtKk59nAtMeWEd36t2PgA5UEqwG814O0C5lW6GMp0woWl22
         R/yKELd0YWsDWV5ravF3AGzRUv5/gfObpZALVTly6lqp7lUjYPoLu0TkrgwuVF708MWr
         qRfw==
X-Forwarded-Encrypted: i=1; AFNElJ/nQmTauhLWe7vOCWP2FPwBAOcZ7GtB92LBNxoEDt05EoeG8V1JRAlT/KOgALDpDXjYO2BduWDS8A==@kvack.org
X-Gm-Message-State: AOJu0YwsImHKDSO9vEKegAlMeqX6VrCArXZQ1f+vMBQg/dxGifCsZH0D
	bt0a9c3c/I+er7AXPIvXdDRbLK5NySQ15UQrkJ53OqS4t3kU8tAtbXSV
X-Gm-Gg: Acq92OFJrva0PEykm5mDR7OllX/3ikarnO9nF9ZfuDjdJyD25cT3nQKcRsYLJMbck8E
	Y8IUGRn2FVq9GtPQjjgSOonM3BtXj161IKbaPACinjC1RDq2PkQRyU68bAOHr/+jmp6qBI3oNlt
	B3L4Pdc2q4j4QyGNYajqKnMFeNhVIjBuo4iSYp9RYQsJRmu87kIs2XsfrSzUkD66JJmcSsoZIh8
	Z8Qgf0KeIcLNYtB+2O3ucnIUwbqhIGHHUynfEFcetDu01maWHrVbn3AtbptXD3cFunU5iDLje12
	/2A5QGghpt1sapKPNkWdwCxCWZhiskoYJhZPzn+wVoQyjoD6RLuxX9EjzFR+Sc0gNE5A9tB+rXg
	pwsRHR/07hcIeMWMvSqPVfuu+icIwBiJDfEkuav0pXvKCtf5kR3SZ3DwjzYxxCEpE1rjAIjB+kp
	HW/BXTH5h7GT1fstlj9jss/9PrnBXoAfJbP8ukHu/ozp/aZrQV+Dw=
X-Received: by 2002:a05:600c:1d09:b0:48d:50a:6ef4 with SMTP id 5b1f17b1804b1-48fe537fb44mr240677305e9.11.1779176039621;
        Tue, 19 May 2026 00:33:59 -0700 (PDT)
Received: from mshcherba-RedmiBook-16.. ([188.163.115.207])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48ff43f8799sm191476755e9.2.2026.05.19.00.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 00:33:59 -0700 (PDT)
From: Maksym Shcherba <mshcherba2000@gmail.com>
X-Google-Original-From: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
To: SeongJae Park <sj@kernel.org>
Cc: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>,
	Maksym Shcherba <mshcherba2000@gmail.com>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/6] mm/damon/sysfs: implement update_schemes_quota_goals command
Date: Tue, 19 May 2026 10:33:52 +0300
Message-Id: <20260519073352.16587-1-maksym.shcherba@lnu.edu.ua>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260519001703.99264-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9BF40140011
X-Stat-Signature: ya63xydp4wuxcqyfwdq1pr3kaj9d5ktz
X-Rspam-User: 
X-HE-Tag: 1779176041-475681
X-HE-Meta: U2FsdGVkX1/zw3775D2NuEKSCWYzML6iEsh+oozHfZUI5KilldD0B5WQJq5dpkpbDenXAR78bNWpduaT+dafBbAhZO51dN9MozG7RVitGVJiGoFUueXHyraKjgzJNcz5DRwQyGIkb2pRUHtQw81xjzSUD46unC1J52IRi+8aDUztskIkNpu3+f0a2o86twVYAF/0O5JdP8gsXkT44ouLish2fkkwZuznMkDND0LIG+oQKQUYCytVA5fxjuTZbMC1J6q1ttwa163mnX3c9LG2apiyqWSV03lRP+TMKar5t/90wmbS3OmIbbnwvowut0AOGiPvCZkhOunxbryYtlOsRuYc6waKf+M/fHdaQmyyT3qItFpYyRI7rMMnJM+ti+jWxD+R0SEBPaNIy2XkyQQVC0gLa55aOHe+wnjO9Yej/VibhBDq7qziKNI3VjQzPqivx0v4WC0RGkjI5bpYAOd/svaWRGxD185lVLOhre1hMAkbyNCavSDBQAbGKyp/GMXost0e/QWBElubht7Di+36DrKEtYhc30ZazFM0sdOB/vgqTOeJ3O4qvthznew3uiR3hPuxYKb3uA+bpvrjQdHgs31k3TL/VdFMW9KAgvmMh+ln7L3C3NJFb3AzDn1Dw3WpSwzm020DQydJLDgWPdyvRwspEccvetagl52MExdURzuCxfV9oGWqhje0HWVZBLUrFS1zZGFr0Xsf/20UhoN7BsGbnoy9HfL+AK7f9/9lsshtDp6Af4/f/0fgA6A9nyceW8sbahcHLx2vHvKbFnkOjBylb+5JgD/aTQ3FaPByGlwf/Vi9f+lNJVYU1hsP5CukRjEgUwstP7bzsUjIJ7/R/f69/lPwYLC1ZfmIbFQAlyETlC9vujGwgXi/pKGdFvpLtR5n8+NatkAjvhn/WdPsvk3ioe1MkB4C5uqf0qqC+gC9UMI3bW6t0bNsUhFSRneSR2fldntBLv2Fu4Iae8z
 6edaaVSb
 Pn2mgs95rj2VX2iBDp/bwWmleU0FHWfmc198UbrUSRLSZBSmDj5UW0033mH0iLEL7GE8RHO/I0620DJHTxTH5JF99Wpb7PZjgLW5D/yaIBHn8HEtLSYvPAp3SlBkjImORz9n8q0kNu+mYmGeA1jaopKLbUzgYHFKEMvWCmGsVPoPqOsERkRDz2d48uTlD3EcnQ+ZdbG08MxxXM0nqSfbzE0XLqgTZgifEeXSVnNWUEy/TvScckB/c6/3F88NsRXEs6NkwENflKwYzQZo1byuNRCSXszcFCrNiQiY6zPUbPLQJ7s6Rgsio/8ZW2NFdWfg9KijoDx6OJrpdEKRLyQGul36lY/bmAKMR2Ln0lxFJj0KfdtFayY8HwjP3yqXkKBDNjR/5hRFAUOGq98psPmuKkBix7uTuZMvyvzXr/7iABIUF+5ekWxXfqaH/qkZmWbRsnVQC0CP4/mzSZXe2J50nN1p5YA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 17:17:02 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Mon, 18 May 2026 22:09:28 +0300 Maksym Shcherba <mshcherba2000@gmail.com> wrote:
> 
> > Add the logic to copy the current_value from the internal
> > damos_quota_goal structure to the damos_sysfs_quota_goal sysfs structure.
> > Introduce the DAMON_SYSFS_CMD_UPDATE_SCHEMES_QUOTA_GOALS command
> > and integrate it with the sysfs interface via the 'state' file.
> 
> Could you please further elaborate why you think this change is needed?  What
> is the expected use case and benefit?
>

Hi SJ,

The documentation (`Documentation/admin-guide/mm/damon/usage.rst`)
states that users can read the `current_value` file. However, the
kernel currently never updates this value in sysfs, preventing users
from reading the actual metrics.

This patch series implements the missing logic to align the code
with the documentation.

If the design intent was to intentionally keep `current_value`
internal and not expose it via sysfs, then the documentation is
incorrect. Let me know if that's the case, and I will send a v2
that drops the code changes and only fixes the documentation.

(Apologies for missing the cover letter where this should have
been explained, this is my first patch submission).

Thanks,
Maksym Shcherba

[...]

