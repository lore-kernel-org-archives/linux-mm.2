Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 925A1C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7CC36B002C; Thu, 28 Aug 2025 08:37:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D25E46B002F; Thu, 28 Aug 2025 08:37:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14EB6B00A7; Thu, 28 Aug 2025 08:37:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ABC226B002C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:37:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54D02117593
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:37:55 +0000 (UTC)
X-FDA: 83826118110.25.4B47A8B
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8F49B40010
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:37:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mIrsfYNZ;
	spf=pass (imf01.hostedemail.com: domain of 3oE2waAgKCEkulnvxlymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3oE2waAgKCEkulnvxlymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756384673; a=rsa-sha256;
	cv=none;
	b=1HWB2B0e+7Kl7PAnJJitvZbQ3UhTNh5HVdjZAlAWs2VE7YXaHXrTeB12x53LHBOXx4eq90
	oYdNp4LHuYO8DiQrTeWo+XK9TpAtVqE9Mlc8W0RdOzK8AEnaBr0xHc7ODtkGHIxsSzXZOd
	v86nilikQZNWvLDr2ERoqDw3bfLFml0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mIrsfYNZ;
	spf=pass (imf01.hostedemail.com: domain of 3oE2waAgKCEkulnvxlymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3oE2waAgKCEkulnvxlymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756384673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vAjHNwDkKH0Xrf7J9hqnDKcdzoQblJhdBv+PKUv1vNI=;
	b=PTp9lef4joM//cbLeW4E86BRYYMeawMsCpRgiPzW2Uez9WfRVm/DjZa2oSaU+sXyrYRPtG
	4Q3jMStRBed7Im5C7AxgpXRUzIlZwg9OehgccXJSjGlbx+E/F3Lg6c35cg5V4QYcvT/j5u
	2CcIHmlCGrklNlzE3O7oSmp9uIDXH9w=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45b7a0d1a71so4970175e9.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756384672; x=1756989472; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vAjHNwDkKH0Xrf7J9hqnDKcdzoQblJhdBv+PKUv1vNI=;
        b=mIrsfYNZqMLEEXYFdVZBdOk4v2ZmWQUsCoDZ5JqDRn0XKwQxO0dv0teqLC+wV6bZXC
         8kQt1ICA6/vRiVPb+er71CV+j/U9prlO3UZJ6Ih+fX/xxIHeyMOgkQ5wxQvdlb35tBzM
         yDCANMws6KDROMa+Q/pMAec7MSJ3EhvU8oQUC7nHd/wzBdZ6kFeFe2RdDQ/5q9iXPxCf
         pXj8FjZ9h5kehMbEyy/uBqtT/EMQlewHsHonV45h1wUoW1bNxUamWgDrB6BEqkBY0BNO
         pA33nRJRMLRDAK4Y6Vbx7MLt+4rpCCXpc0R8kT1+ZWTF2BJfsIELSdZi3NaAFrZVmgns
         T5oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756384672; x=1756989472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vAjHNwDkKH0Xrf7J9hqnDKcdzoQblJhdBv+PKUv1vNI=;
        b=FwkjXOYeyJXLf3x4yjU73JCyo5aRCXMK7YBr6DWEAj/JHPVjB5hJCkHSk7ml/RV4hn
         euAC2sGNr/meV1z9SoyKE+HrxGWWWAD/XBu+4zqfc8WP+X+89yoTKciSjjh62ShkfkVX
         KkhpIjzgBposBMPV98gQU4YfSbtnsaL/AHQQuukP/ihMzxxE6jc/XP62W3aZniBpi6JK
         xsuHjozvtf4EJMDCnIxBREXPV8CYvfsnzv6zEiRyWILcYKP9JvFf7OQBwxAQotya2wlZ
         CSZK9+hdpsJno8am0k9Z1P2XYJWvswma1lex1qXTdOOA1+k3I1qBeS3z4athMgBTODBU
         wybA==
X-Gm-Message-State: AOJu0YwBJFF7XkIuIpmzWHXLjkhsb0kBDNyYyAjAXjA3WRKDXc3dOdik
	hvil0trk9jV0qIepNa+Tpxbjpf6ZxTL+t8w8/pYHD6GuDCCwa4lDjohmizOaRSQbUhz8E73854c
	uG2g+Orv0/eaWfg==
X-Google-Smtp-Source: AGHT+IFBXeYhNMzdHXm52lCcgS2aFNIXmiYG3CWqQS4CZNJo74TXJc+LGj4lyuYSHltaoqSjZezmpZSGDKJR4Q==
X-Received: from wmben4.prod.google.com ([2002:a05:600c:8284:b0:458:bed1:8923])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:314a:b0:45b:7aae:7a92 with SMTP id 5b1f17b1804b1-45b7aae7dcemr16281425e9.21.1756384672158;
 Thu, 28 Aug 2025 05:37:52 -0700 (PDT)
Date: Thu, 28 Aug 2025 12:37:51 +0000
In-Reply-To: <20250817065211.855-1-ujwal.kundur@gmail.com>
Mime-Version: 1.0
References: <20250817065211.855-1-ujwal.kundur@gmail.com>
X-Mailer: aerc 0.20.1
Message-ID: <DCE2EJ3KWX3K.1Y198FHBV8UG7@google.com>
Subject: Re: [PATCH v7 1/1] selftests/mm/uffd: Refactor non-composite global
 vars into struct
From: Brendan Jackman <jackmanb@google.com>
To: Ujwal Kundur <ujwal.kundur@gmail.com>, <akpm@linux-foundation.org>, 
	<peterx@redhat.com>, <david@redhat.com>, <lorenzo.stoakes@oracle.com>, 
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>, 
	<surenb@google.com>, <mhocko@suse.com>, <shuah@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8F49B40010
X-Stat-Signature: nsziocchk4eccaxrno96iyyu1c3uh6k6
X-Rspam-User: 
X-HE-Tag: 1756384673-95943
X-HE-Meta: U2FsdGVkX19r3Ze3yUAExxmOq6x8+zdm6+oaapzn/YMdRNLJyV99D46qiWKPxAAI6CwNbY3ENHktjibvkUNq0tg1m1ZX6/QgcwdUlunRq1kl3KlYGa+s7FEL27gTsARxUUsGeyz6P3qkOiYUxIYfgqr52haumPaSVIlHO4iJgVY5Ji0pLDNPvpAvRhxxAWlHpYGFP9bR4w6/0vjKXKNga1POY2ejSK+Sf+GAwVRHIsY803mOTDaiQonOHL/HrISF4vbMBQqy9rO8deiirR5FszJ5sybqssOqJ6zHHtdfFqNNsPAw3BZ8Hf2WyuoKZwl8yfP1zr9kOfFq5XzqmrXuvtjy95nx9PDjMTDRp9eQBy0nhRTg5n+x4ZAcvFtViJhbWCc3eHrfEvKbMC65w/oTZooNfvW7T62Hsj3XNhod5kMNL1rKv5OB2LCoQoif/BAqMOvjO25a/WWJePK2gD3dRzY9rs7EbRX0do5FibWI6oT6fZUL2jqNqLXIvd0QfOXXnP4xyHVP1Nkaa04U1aGeMoA5LVoQTzxGv0N9PsqEhAjTsJHNa8yUwUQFvawVHLOJir8JCDh7jq8Cch8A9+Xh2quWgpv3XtJREtYxhhLcEA46cJaFoJJkP5sgrH3lkSDlUIxSgY3k4RwAQ344IcomVncPeofduddLxyIuWwvyGs25/IEskUNdLDzsWCFbwSJaHW4hnfZrvAW5mnrmSOO1pJ7ABRdgKNKorpqlYXXmagQZv8bTsXRYEskUJfX22LDrj4DXSfrpNKn/fRugNE3i1RePpdFVU9iNCrdqtbtxQL7PEiZZqWaDlLZ9Ft1ltZEYx628Ruou4YBClbPPKeOyGTWVnJwN1AdE4OM1XQlaoZsFUMQv4uOwsjCFhSDfqhWvHPB0dE/xHZzDsx+xRkOiPoty6LX6ipu/y4YiTRxlF/6jwUgfR8OE4sqayWpyjRBJlhNoSoY8j+5tyLfMwdG
 pJm4yxvl
 GUXXbC5ajjRNF2VScesZEyzBAhoIhLmmM5Bfya6fyUglf8jZCLZ7c1h16XxaNTU+QSxr2PzHwXr/gJ83iS3alp2gpnZFQ52hrboITfZiGlNtiMpovrHfKPtZGQwwRjNElzkl0CRnh85y4ZwZ6XLkbjKrDOHoMOBVMeVPCp47RT8+wxylGAB9aD0fKEw1AcODS7CCIvDVhqwDMBFl7kD9WRA7Mi2jZwY/iKTWBh6M1K+PSxFuqcfAFbbRZkFqhrpAZ+N+YyIQ6ciWV1RDpTgH8tOIlxjlUATJW75rOityzZ6+5brNw/KNGWfph0qSPb708DpAHFqI25+auEEOB0Mhanvm4NcM8YxU+1Um0PxQGpelZUFyFqCZUhEDd6RWlQpCDyrLJAs/+O/3oKBIXX0RANt3jUtef9uw3vSxkTMBINlFuFo4RydEFziZUKsO9yMcsKgE5+KY8yOMprGwUnv2OQwdWufNyIwk0RRoAouXVVNyHUeSXe6cCVmontdoZoH2qBaIvwaoUX2Jgjmd59t4c9k5buYvHQ+RImJnsgOSwg+tbmxFPqTIsIp/N2rBA4CIKax7adAC7l5CUQWo5n9SgM8l0oVCxKvR8mcVrcMovv1JoR8ZAPluc54ZnlBRfJfAZYScoHkNhCglX1xqDaHxaCXFyT5sR5A1xdV5X5lEAZgRXG8bSavQesd1QL/nHP/OBXmnkPEsBeSFQQrJRX6htRUBIR+iSLhj9fLg0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 17, 2025 at 6:52 AM UTC, Ujwal Kundur wrote:
> -static void noop_alias_mapping(__u64 __unused *start, size_t __unused len,
> -			       unsigned long __unused offset)
> +static void noop_alias_mapping(uffd_global_test_opts_t *gopts, __u64 __unused *start,
> +			       size_t __unused len, unsigned long __unused offset)

After a rebase this is now falling afoul of the -Wunused-parameter added
here:

https://lore.kernel.org/all/20250731160132.1795351-5-usama.anjum@collabora.com/T/#m0449dc0d6a5ac3b1f71f7182c13b6829e1b444cf

I really don't think we want that flag, I'll comment on that thread, but
just as an FYI here too.

