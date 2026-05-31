Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22BFECD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 19:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 640016B0174; Sun, 31 May 2026 15:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617986B0175; Sun, 31 May 2026 15:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 556B16B0176; Sun, 31 May 2026 15:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 41DFD6B0174
	for <linux-mm@kvack.org>; Sun, 31 May 2026 15:25:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E59EBC2116
	for <linux-mm@kvack.org>; Sun, 31 May 2026 19:25:01 +0000 (UTC)
X-FDA: 84828692802.10.1C2835F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1AE691C000D
	for <linux-mm@kvack.org>; Sun, 31 May 2026 19:25:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BqUnGLzc;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780255500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uko1Vuv+TRAWbjerQEGKNfOSzZb/odVklCx5MByR3WQ=;
	b=fEUfknC035rR/ewEljb1dnGzR0F3Dl8nEl5Sfx4bDStNtJCL2yUjwRAt5OjcduNSLBKl8D
	NNxhVChar9iqRhwX0eEbaAZlLS8zEekL4+FRENy0QkzdyKQb1YVKbhVslIm4xXjpI5U21p
	VIkxQdXe4Hd1BIQYya5DLYv2ezgM/OQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BqUnGLzc;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780255500; a=rsa-sha256;
	cv=none;
	b=GBlSO0o29YP7ZAtyFCIWRJJPzueDXrzESGVFgT6WbTCXL5kddabmeF82oiMtdyOTlV8EWl
	+efcrmDF3gQH3EGeWHZHSKoUGdW2lFdcCQjP31gP3NqzhxuP6GNiMFfCZHnPeFjjl4i+vO
	wjbISManjABsrMRNXzR1vLOgP9UpETU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AC90601FE;
	Sun, 31 May 2026 19:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9434C1F00893;
	Sun, 31 May 2026 19:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780255499;
	bh=Uko1Vuv+TRAWbjerQEGKNfOSzZb/odVklCx5MByR3WQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BqUnGLzcGY9YmhTi41lBU6NbdBR4BH3icQiVpu7Cu4k8LsPyfwWTbimSnSi491BMM
	 7gJbMySUzveXwFRISDc9OGmLtP2Pe98w/fnTvdELdKirOql5+FBFKEe1bgIk8/hkgk
	 t3xzRG/x170r1rjn3A4sInX2dhb71mwlk+YEOK18=
Date: Sun, 31 May 2026 12:24:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dev Jain <dev.jain@arm.com>
Cc: liam@infradead.org, ljs@kernel.org, jgg@ziepe.ca, leon@kernel.org,
 david@kernel.org, shuah@kernel.org, vbabka@kernel.org, jannh@google.com,
 pfalcato@suse.de, balbirs@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-kselftest@vger.kernel.org, usama.arif@linux.dev,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH v2 0/2] mm/hmm: A fix and a selftest
Message-Id: <20260531122458.864e9deac7425e1b71c14f3a@linux-foundation.org>
In-Reply-To: <20260530085413.1270139-1-dev.jain@arm.com>
References: <20260530085413.1270139-1-dev.jain@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mkuyjjcb1p3qxsyuj3e8m6bmoiim8ofb
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1AE691C000D
X-Rspam-User: 
X-HE-Tag: 1780255499-570834
X-HE-Meta: U2FsdGVkX199RT85UtfQiHGOePrY0LDyd3oAeIa9TPbvBIXUExe+NkQD3QMq/MKTEy3O3BcIEa6nsxWYRwwcf0a92a6i4iBjQvUx90JqWO3rfC8eVLUbcC+oE9VnqJnuaUJ6AXy+e2qjh+ON3cpAVpSK1JVAAjM/YtlnpAn0QGSc3Lwtqv1mlY1tRDwT/vpA8JUS7zk9I9nEh/4IBSa4jImCdNG4T7C/RIZaSs9Q4VwHw4fueWO3TMlzdjkmodFykCBicEqCg1CCjOrsdUaUk+UmTSzaxfbOSgy+rlcAQtlf7w8VYLQQymjY7WJGQxlboLJ2oBmLL+1avTgxIZhJZLKhRHo6lX1HOLEtmPr/d2am2kOE9jnhrLTbpyFHr3AIgwJQgfsU8z8ncINfYaBLhiQDgqjUbjVOo3TCjwNw7J4gznEzReUqKHPiZxD70Fnw1xDjJ8hJ08sJQGfMnLUi0JZA0TzpjWPCwUIgmL3bXg9olEQ38xJwgRwrtKUVi7oBerLfs7t0ScpCDsV6MaGY78BjiZIXTn/Zw2ScIssAxUC32V/4EwdCwUk159o+DaZUFrOyaHzFv8Wr2Vp92QIKaBYU0TsDOoGJcIirzmpZCBtBMO85hSnXAVC5IUHWC1bY6UcKFjXejHBFq2NKobzdxWMfOkMuOpnQJFKnHITA/lUQ4gXvXCQiCcMwxHjon4Vh2kxURIMpbaDfmwRqIYErzIRh3b+LimB1QNGNrvU0vRYjUGQ3rWd2hMgirUo+EjRfmjee/WGoUBiQEij4R/BoHPRJ7sx/fHGamX8PHp3pBQTH6dAAxjkb/3kwpYlR7ApZxiN7NwV8MMfHmjnOVbeVlT/aDj+J2uuQomwVxm1yIeSQUaRlADJGKhUntyVKm8qdE+NZ6a0AuA7yU+vA4qVpiUjVkXTu16oCa6n/eaJ7neDjFlb8XKCQk7gO7vhswyAol8tF6o+IIRCbvRPljfb
 QRXimc1G
 RH0yFWAA4PT6+3I0NjC+dxL5oYPhrK0j4MWEUJ6CVEQpKtr/TZeYHOWw4mPv0rB3SzD6XMhwAJO/qr7x2a108IIBAHp/tudMY36DJ6kRwdMO6U/DUekQ54Kqu0lSpquIou9kGETEcsxAG/ZsmQy1Mkk9ob1zIOXF96Yvmrc/2NoVCgNyhcuOxihjb1bsXeDqM5/l93qkn7jQtAsxQyTmXCFes5n2DT0kh54+7nMufnu9yQSuk1yEr1u9IGrNmOh21tyDgOwx73AOAA/IMuzLMB5zsCcajUirw6BgwSAcLzeWwhXi1JUjqJfyaRJYaO8CxlOYztFws1iLFtD73Jg0jf798FmbVlndSk/zLvtzsQWetvWVpuqN2O/XWRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 30 May 2026 08:54:10 +0000 Dev Jain <dev.jain@arm.com> wrote:

> Patch 1 fixes a stale warning present from the time when only migration
> softleaf entries were supported at the PMD level.
> 
> Patch 2 adds some code into hmm-tests.c which exercises the pagemap path
> for PMD device-private entries.

David, I'll retain your ack on patch 1.

Sashiko has a concern about the selftest:
	https://sashiko.dev/#/patchset/20260530085413.1270139-1-dev.jain@arm.com

