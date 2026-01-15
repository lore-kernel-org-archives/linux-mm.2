Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC430D4661E
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CCAF6B00F4; Thu, 15 Jan 2026 15:07:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B79C6B00F6; Thu, 15 Jan 2026 15:07:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BAF96B00F8; Thu, 15 Jan 2026 15:07:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BFAC6B00F4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:07:59 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D008713B0AB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:07:58 +0000 (UTC)
X-FDA: 84335284236.22.4036ADE
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 25627C0002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:07:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WjRwao0R;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768507677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5VF9kI5O9H97HnOZtL/a0iX1DIBiawVieSoxgvaDO+U=;
	b=wq7Hn4RiDTabLqpTnstVs2+CoVKSW2KUYXmtTSefEb+BORNtgFoW55KvfoIONcVdbeFqIN
	2mFyK31WiYWOpYYeB9ldW9cH3GkmrpcTvvOxq7wdHPl0liLrzkEF3dKpp7O6UJ6WQro8Me
	jS+SypGJ3pyHHLyiadGPM0SHS6L1iHg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768507677; a=rsa-sha256;
	cv=none;
	b=EngGnx8ZKOqSj0HKw8YLU3NcdKbC9LVRLDFWZ1kZHUEhyYhAWYBJafpK6MAM4c0/aE7o5W
	GZ80p3M/1jnmxsrXLwvpIaE6H0XYq1lNLImYs2xMbOfBfAbQHpLVUHM2EZExrOugPpQQuq
	KC3HX5rNK5VVp7atofosCOLLOfc4Dss=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WjRwao0R;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-78f99901ed5so12882347b3.3
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768507676; x=1769112476; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5VF9kI5O9H97HnOZtL/a0iX1DIBiawVieSoxgvaDO+U=;
        b=WjRwao0RDPabwFJdQ7Cy2s82nTNjlSxJ5MYejDDKJcaGSALdr2DFU7P4r3PZKN3WYG
         cCgHknj87qDmAjZO7/d89J0WU82WRhPIhO2TYLslXOXoKqTvAVoHnIL+kgQNJFDkgyjs
         1Sa2PBBfPmJk9G301/oPfoV8/uTPGfiW7aTlgPICk5c+9IuH1G4pTMasEGhXZeNKrcni
         hAS6uiqVJnvJ/WMgyrRdG6CtunCJR4ORUZ7uLXNROE8Lj3TI6oMwCX+738x/SZix6pv8
         TGaQsW1FsyC29WnZLofYHC4DEXQPb1xvN7ZHg/4KYRoZkmcS9jQtkDpV0Bgi2+DzE3/a
         6vKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768507676; x=1769112476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5VF9kI5O9H97HnOZtL/a0iX1DIBiawVieSoxgvaDO+U=;
        b=gyUNKhz7dcyDanZPZPnVF9T/aCVYXpkGdO6FE+0HTV8SIxRDt0e4qhZvuqhya+WLmE
         fCxbr6ODrr4dHBhFGmeOmqu2Fmx0Cju7xS0Cyj5fwToQayQA0Ljq931QghOKTB0i5oT3
         uVRK1atEn+InYhhnCAAzAAaUEzbwWJJKZtSNvIRSgxABWdBF5ovYbc736ba+9fBbuJnw
         SVm8hvGW+YudKA7CmXQuk6llaDsdJ9JVoLYMIcAvhS/PhN/K15F09iTHbtjjsVClIZfF
         Jn7YeNKN7I/nCCBZZjVpKnYG/1cj9wLEmoVkHn0A9MVV2G//qaZ9O/dwJY0qbUGeRx2j
         I85w==
X-Forwarded-Encrypted: i=1; AJvYcCX2wuRRNj6ftMZsSQ+v90jjJ3PheaQYTmbKQiuey+PMhjW4tNvy/4f0hIy4l5sdzm33Xk6cCdizRg==@kvack.org
X-Gm-Message-State: AOJu0YwPGSXsVw69EfZq877BorJAWLFvYkZ4bm7WEuc8xzStgKPLgxk+
	wlgQy/rw8CXwNcKKmREgXRtOP04d6Q0jbXgvDxsTbESPNhK4uRghxQyg
X-Gm-Gg: AY/fxX6mXKv/uHf1J6TzBD9T4I8WFEkC3vNAwzsEUKbHlYb/ueOS9oDrGPwcEOyq77B
	r2ZBGbuGSJ+C8vZQIiEFg7YNRGKzGkzFjLwMK9YJue2sEwnMcJWzQ5vGU0oaHBuEz+WeTFRODtu
	AbwsKKE8CqBBlNlbvVbsNhePG7lM47PiAVy8x3VB+Aj4sadn/b/iZidq8sw/F+beM12C0ps9B71
	ZF6lhVFIlcBbUKDUEJticbcXO7ESrENNmEhHpIvveMNO7P0kVdxtBiYunQfAlxEjWenWo4tt3ba
	d65ZuUxaYHpCO/Isk9h0V5YDo5ifO8/4lT0VujcSroqMlnInhxw1RtoTavC8OiLqejLAYmFHVl2
	6ul5zZsoTv92ILBquqAYOlyP2rR7GVy7yL+KO8ct5CU9CV8EBT8iaVsNjpV9Ge/D6h3F+2KNW07
	gddvdBwTHQNg==
X-Received: by 2002:a05:690c:1a:b0:786:5620:fae9 with SMTP id 00721157ae682-793c53c6ba6mr8735327b3.54.1768507675354;
        Thu, 15 Jan 2026 12:07:55 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:70::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-793c68c4167sm1111377b3.52.2026.01.15.12.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 12:07:54 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Manish Kumar <manish1588@gmail.com>
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: prefer 'unsigned int' over bare 'unsigned' in page_alloc.c
Date: Thu, 15 Jan 2026 15:07:52 -0500
Message-ID: <20260115200753.1002036-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115194845.118064-1-manish1588@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 25627C0002
X-Rspam-User: 
X-Stat-Signature: 58m8mnk9ohjhqum9tc6tkhsdg5w8kxxi
X-HE-Tag: 1768507676-280292
X-HE-Meta: U2FsdGVkX18dNAfeDxXsZwi2Tr60Fgj2+MrJ5o1y8gVTltCX2YMBJGGp+aWl1y4DcJMU7PY99215s8ANU09S/Xa/afiotpl/fm3NTqeR+9o0VVqHfWYqOkF8qQbh8rTj4eI9MKXpHTnuOocdxovJk1IlkVuY8LwtGeA9Nny+LsR05Ub0SZNkVgeujfK54BcDm+/IL5PXpEO6gHQD/FqQrv2ybuRU14xFtlhKMVosUyOH00EX46Lf7Q0Nyh3a0DFXW0dHsXYKnV0S1NgQZhWc1+B4wfH6riND2gvDAeExunkS8KcvwEaRaK/rzvw5bpxviAWDpTme++SVSVAQcvCBc3Zc4znsUd3Rxw5BP2TC+Qz6hneW1PMbgE7czZd9S9pLYngPNOi5Fk5mMK2i1/9haU6ITo2ab9jQhJyWj54huYME7ZZG40Vz3vjmWNVMpJKSHq1QJYgI/tOOt8UW5FbW2fkdCVDTTGK9VJEwyA2bltvNROD5N7ZSga2KgENUtevzhY6PBESOzxNxRzqBKIfSJzHv6r7PxqDMi5ULjsgbvbyPwqq3wujIoDvnOuc6mwNbyoFxxDGuusaZE+pMzEIzf4YqSbLb+Mm7JLiFTuwO1CMdrSosfskblPQGkFCkiH4OS7LzBizEket0vhyg+VchJiUPnNTHFN4qqTMIRPKdU//Ut/ub9FoHyCkkM8wiOVPXBC+cZ768ooBr4TpcNTKGbSzgJzUBABX2Cp8gAAzUs2V9dGGCVWSOX2mg9FbChpisBYBiYdcf8GCXd0RrzHWtbrXHGH51j6xNbR6scH4SxRtuyptljQT9UBIQkI9FLXrY9dAxljWnFkO3G0LnMlr4I7KIHDKlsxzcp0NB3oYy3ISoV97EF53BhE+QPoYQIJcq+py0blZrJC29Fbkz0GAinsgEr15F9cxmokHOtmeofZPWm19dS3oVIYKZYQF3dJ00IsvkiMBFXv1Ds2bGqvv
 f9CqCdtf
 CEP0fDr/mnSWZ7tan/cxX2YUe3jEgZ7+e+7S7CbiA4i03ued884I2lkhbK6nqLJZEKnmvSoIRqnEDbFy5hI0PErcAVwwsnZXSGWJggwHgMe5W2DLPLv+kkAevifdtgeQj4a8mm9lCTi0KBt8kfyMT6CLhRGjdTkotnfSZQgnf4/WCyl04RUCavi5oPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Jan 2026 01:18:45 +0530 Manish Kumar <manish1588@gmail.com> wrote:

> Change the declaration of 'seq' from 'unsigned' to 'unsigned int'
> to follow kernel coding style. No functional change.
> 
> Signed-off-by: Manish Kumar <manish1588@gmail.com>

Hello Manish, I hope you're doing well!

The patch looks good to me. However, I just have a few comments about the
other patches that you've recently sent out as well.

I think it could be very helpful for reviewers, if you grouped related commits
together (in this case, mm/page_alloc.c cleanups) into a single patchset.
This lets the reviewers view all related commits together, in each others'
contexts.

It would also be super helpful to Cc some of the reviewers / maintainers who
are relevant to the change you are making! scripts/get_maintainer.pl will
give you a good idea of who might be people who are expereinced in the area
and are willing to review the patch.

Thank you for the patchset, have a great day!

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

