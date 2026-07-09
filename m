Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10A5EC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 05:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12DBE6B0093; Thu,  9 Jul 2026 01:58:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DDE26B0095; Thu,  9 Jul 2026 01:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F385D6B0096; Thu,  9 Jul 2026 01:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3AE56B0093
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 01:58:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 541071A03D9
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:58:03 +0000 (UTC)
X-FDA: 84968182446.21.30B7E91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 16D6B140009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:58:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V5Tn6BZJ;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783576681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xf5NQPRm+PlThVUYalodcm0x+VRuVBSqRkIVWGLY/XA=;
	b=xzqHQ0Byt9GKr0xqIcaSufzoZsFyWUPzVjz2IpOViC2SkUPUkCZbbD7cG1uDGaMSYBzm7Q
	OUmtwgx/51RDcbePvgG36Zumyyyfr4KGSiF6DQN9NgUIeFrDqs+v3AJfzzfEjYOa9acXtw
	ZCSFKP0lIvTzkAGJ+ZbFRSZ6curOhzs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V5Tn6BZJ;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783576681;
	b=VkAULndCAJuBEEUTskC2Sc8HpD85oHootOjcVFPCBMGw06j2UL7x8nKPAD7KBcHt65pHl5
	YZL4whhwOlqm/yalrInVU6iWPj0xMnKIVgNsxPGq3cU/l9SVP2eLTqI63oEIwPs8h5j9kB
	LT9FLrrUGEipXXbFxcHh1ZvLIvPIEkg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FDCE6001A;
	Thu,  9 Jul 2026 05:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607271F000E9;
	Thu,  9 Jul 2026 05:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783576680;
	bh=xf5NQPRm+PlThVUYalodcm0x+VRuVBSqRkIVWGLY/XA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=V5Tn6BZJLkxVItaPfGtZTeio2YPQv0sF8JqMvvYBNPsA+qPaNDRenlKs/s836974k
	 qsTr8puf4xA6xFW00rVJXpAh43IXBail89YZzVeuxVqk817zVGM84AHJD+nZfh+GYX
	 5j81OJNXC8mbtvk/6gsvMKN/LQHLh/65mbf2rYmw=
Date: Wed, 8 Jul 2026 22:57:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: rppt@kernel.org, peterx@redhat.com, david@kernel.org, ljs@kernel.org,
 surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com,
 ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org,
 seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com,
 aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org, kernel-team@meta.com, kas@kernel.org
Subject: Re: [PATCH v10 14/15] selftests/mm: add userfaultfd RWP tests
Message-Id: <20260708225758.0c8bcf16598f82d84ea7f71f@linux-foundation.org>
In-Reply-To: <20260708111417.173443-15-kirill@shutemov.name>
References: <20260708111417.173443-1-kirill@shutemov.name>
	<20260708111417.173443-15-kirill@shutemov.name>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 16D6B140009
X-Stat-Signature: z36tx43pgop9rmphe4iz55pww8kptxgj
X-HE-Tag: 1783576680-736949
X-HE-Meta: U2FsdGVkX1/bXGLqOPF91gRd0KOcX513zmheVJOe1FrUyStN/R2hdyB5BwUyfamc9tqh2c8qTwMbXb+Sq1Vr3TqUNZw2Ho3H+ALOxd7Fh6PHp5UXYRYGjCWpIt0EzREAmXfBlQRWZAknSX1JN3qWsUKJkUE0KhWeyt3guvZa/ZySBJ+cPJ/4AqtrF5W8GOl41CkXO5lU/x3BXXnBNUFQev2JEnkLNB3K7w0pG+6u+aVEuvpbMeyBZwQBSCuKggsILs0H6yFjrLw/omX2JfCatS4pe2kPOED6VCwQ67h0Zu+E4Xum7pGbsFWeL8O/vhMR8ewf/yOLEwLJnTlne5jQHE6FcKdU8IE3r3s8guqBIpiX90DDIRW2bfooAGCC+RGG9Nfev6XMWhHannsEHi54zlhhOsFGIl4ONLUzAd0+9sIKCuaQlhW1XTUoCyu9OhljJ6JoDpXo0A/3b2zZdMy93UWWB9GmK/LTBU4fvzDgEu2m0cwEBl7CYhmg/6N2AtDI39uk01BixyInXcFjqrXO7bcdHMebjmdXnpNrmrHooCU5pKHAVhxtd1UMfBX9xjONTeuSPfxMc94lanJJUrviOabEzxaO5sjmUpPAPpWzPQbFgIXOelhqQMG35KKvq8sbne08E+QSjk8kSb6Jg6ZyhK1nQTbeXRXHWuv1dnS4yVJBewCxm4rGMhy7AaG/nEwFfDfjizjUb/LzRLGC7G96vz8bn0tZbgpwuE03mxggGAE8gc2ODDVjEINs3nJIDrWOgT1oTGEDT0VzFnoECOfXOisxNyNsPxWs5RNMj1F/VcS9Bul7w3cgOaFxOAgkZaArF/OTdcWikKQVQ8OLVzfSdgRCjbasCP2jl1K+LeOLr9mFJACoax9UbE/vj0OBDA0vpc7JbnFEnRUNvCqiUfd6WHrUunMea4Nem3TrHSHsE6ZwdsI4pF1Q9rgOmS6kAL3+1nebJoGYqSCBfm6yebp
 3SmZuMM/
 6S1AWPYRTWwoDfRe9M5EFyXhBjiKZhK44rXQXVufvHN5G/0LCEcQIQPyfHFwCwfqCvBXa6OeaMy3VjhX5P5ZnoOlVyDeZ09BcWIG2eNDtf+5oWQoU0b3qIrtuEnMtx2uPf3aQ2tKNWEajmaOjOXU0icfMcENALvh1rc53y7jWF1dqjzCoeSU93NTrkveConMr2jndSjeMSIxPiddZozbAzoqoAfliNfAD71UO2WNmObq0H1MGni4oxTGXGOPD0FY1V4MsxitQpL1GN4AHcQys/EFDKNM6b7us0dTVg+sD2QOW/KTw05iehyF/1L31ElBg3JAhgnXdQvoLJAQA2Oj3/anwfUSbQImbAfOE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  8 Jul 2026 12:14:15 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> Coverage for UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT:

I'm getting selftests build errors:

uffd-unit-tests.c: In function ‘uffd_register_rwp’:
uffd-unit-tests.c:624:25: error: ‘UFFDIO_REGISTER_MODE_RWP’ undeclared (first use in this function); did you mean ‘UFFDIO_REGISTER_MODE_WP’?
  624 |                 .mode = UFFDIO_REGISTER_MODE_RWP,
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~
      |                         UFFDIO_REGISTER_MODE_WP
uffd-unit-tests.c:624:25: note: each undeclared identifier is reported only once

<etc>

Seems that tools/include/uapi/linux/userfaultfd.h needs updates from
include/uapi/linux/userfaultfd.h?

I'll disable this patch for now.

