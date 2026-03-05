Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43E3AF47CDD
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 21:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EB5F6B0005; Thu,  5 Mar 2026 16:25:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8990B6B0089; Thu,  5 Mar 2026 16:25:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797D96B008A; Thu,  5 Mar 2026 16:25:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B8AF6B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:25:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04B8516029A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 21:25:35 +0000 (UTC)
X-FDA: 84513291072.02.6F4A621
Received: from mail-106121.protonmail.ch (mail-106121.protonmail.ch [79.135.106.121])
	by imf10.hostedemail.com (Postfix) with ESMTP id 027FEC000F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 21:25:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="D/mneLLF";
	spf=pass (imf10.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772745934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TPF/Q7ncQZcbDUXuzcqWPm9P90x5P/esUaASP+y1v2o=;
	b=zfX/4ZE9nLTgMZj6GLuJkYkQXb1rUxVs8FkifllMhkQJ5wZfFaGjnJeJzhW2Phqt7Gm/Ur
	gomMbSEJj86YfhDg0IzwH63tgoeaayuZWnOqkLr66vA02XMWL9W7IZaJzlKzduiTg+7Ugm
	N+S4bWLucQuCVnKLbakAdxi8kgkaqlE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="D/mneLLF";
	spf=pass (imf10.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772745934; a=rsa-sha256;
	cv=none;
	b=MVH+gao5Vj95n/MIvdNW09noXRAL9HDYLubJ9Et0Cb+V7e0n2S2pmJ+VEG4T5uU1gF7sFh
	wD4wL9+8b0JEWQ/JwGkzr8DGKy8wWCob3tDcelCcHqYuLkCk9eR2ZPzKn4/8wRm9vD0US2
	WiaFdnWz7makcrMNHYDJHNanUtf35XQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1772745931; x=1773005131;
	bh=TPF/Q7ncQZcbDUXuzcqWPm9P90x5P/esUaASP+y1v2o=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=D/mneLLFVs6r0IvF+iCRfj60Ah/EZZuLEfnUlva1LdL5DC82Vz9Qw/VqefhhANJWp
	 WDyIrKxz8tdw1gjxkMNCbBDQaV2m8g70kPhDvDgqzjq10LWdXthhW3sqaOhboAVimN
	 fx+5VJ1BndeTf8PTDE7XZ5c1QF09c544w9woMA5NGpZE1sAIC1ejlnCTGEAy+GkzoO
	 Np3S48Ku9tVqsimRsmAltXy1/WyBD31pdq4wHYtO5HTpRIAD/yUzeNKjaEYjiGM7A1
	 xRIXcWjq7VefAOsjRln3WzSuL5V/BJC8LgLU2T1zJl/RE4F5LnsI4Q9CZOfSXLfeSb
	 guSupu87mt2BA==
Date: Thu, 05 Mar 2026 21:25:26 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Samuel Holland <samuel.holland@sifive.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, workflows@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev
Subject: Re: [PATCH v10 01/13] kasan: sw_tags: Use arithmetic shift for shadow computation
Message-ID: <aan0qbP0iV48bih-@wieczorr-mobl1.localdomain>
In-Reply-To: <CAPAsAGyiukChPLYO_tQci-7Bvmnnxh+w=bO6eUYLrO3RVuUThw@mail.gmail.com>
References: <cover.1770232424.git.m.wieczorretman@pm.me> <bd935d83b2fe3ddfedff052323a2b84e85061042.1770232424.git.m.wieczorretman@pm.me> <CAPAsAGxpHBqzppoKCrqvH0mfhEn6p0aEHR30ZifB3uv81v68EA@mail.gmail.com> <aanievpHCv0Sz3Bf@wieczorr-mobl1.localdomain> <CAPAsAGyiukChPLYO_tQci-7Bvmnnxh+w=bO6eUYLrO3RVuUThw@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 2a85cbea50d69490acd671149ee415089f8f199e
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 027FEC000F
X-Stat-Signature: occb5az37bsj5m6agxzsbeok74xyu4ks
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772745933-647566
X-HE-Meta: U2FsdGVkX18Bm24ilOyWsqy7QutB6n0lauHrYtXz6fpTlbLid3cBAsxgFaWIXJVqbwD283+m6zN4orfxco268pjqrLlUD2i3sBJ+rboMDycjwyh5kVtVbnCB6hlakRWHtZvkI3bt+kFic2mB/4BRHKRtXpqtBgaUgxOtvympdyDhkNoZgKxpt/MelzwU432kvwxfEHGtQSRF+xFvq2wiW64VRxOAf3x2Sm9kKEW3uHP113QpGa28CgVi5ws9TByg7JdDVncEfK96EQlDLhLjIqtrKaDIDUtGbQd8h/wVOjaxVz0bF87rAXrx4/Kxyurh5iDScvSQEcaR8EiW08afgVPf3a+w6X+xsyc8qYQZI85d9oOrgtT9ml0L8uyP5I6j56XQIR5lvqFqo45Cc9uEWhSn3ARvn0kOMcFh679lJ4C2vfcCBGk6davOIHEXTphOfBZkUCT0FnI6EbDDymIrieMBT+84BaJPt090Vn+B5r2p79mhxBv9/6MVuqsH4vUBO/jpdh5dnh/iuzrToZ/KebpfWk2cpoukPvloZ9YvwGcU6IcCcVeDcpa88uQrcfCG9QgjNkfPprAfg8mdZCyka1im5kuvtENymVM9G9+8QNIBbdFvOPHoE85ZtvGa2q9lmNnYVqr8ax+QJgh8jyQJ2DCs45vJTPQUuKcNfqFNCZK7zTVh4Cg1rwjpFn4k7j90u6zobvRg9+xj14Rtu+CcaoLoNbTXxmtFhSe3MTAn+D0vVPgy7zD5yBnhte4vBwB0hqrIrBcEm99Oo+y8OZSZXnq/P80uLOjcprH//Wrg+ihmMlDayBn15m8nplXGxlf7hr84NsU5xbTP1qVGmFlMDjhz9oD1FrJFMwJ7rxLiHKrE8lHfg3wQwvNKewtrjC3TNiPUs3tS3HiwDg9P6zciigBP9R17lZk5k+Ndk6qYc87dx+4eCsybZPNYuD0zkeJooEnnXZrb5dUhQv6K/Z3
 eodvzblj
 pt3osGKafPsKTX6q9jXhjug/79euliADi374ezDQaz29b9xJNxzlbIm5zRjk4EwVo6PmiZ3oIZ7u6lXM/s9RrbobbY9cQA+O/QzrYOpOI7FcU4DUa3W6+CXZPj+06jf7Jd1o/tXCcvNt4DYNEqR1QPc5OIfKqYB1NJ4FqWZP2EQPUy9TCrG7N/FSsPbVzM6kaXIo9f8VMyCdOiHvMHir8ItuO4gIpiPMyoyxDoyc1VM++pCqayDNs7WdqubQZ9yEqEPmWePH87VJtKNn8Zu82ZF/CxIe0FPRjeLlDwKPLu99dpEfZu57dgJimni+Q4rlNN4QK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-06 at 06:22:32 +0900, Andrey Ryabinin wrote:
>Maciej Wieczor-Retman <m.wieczorretman@pm.me> writes:
>
>> Thanks, that looks really neat! I should've thought of that instead of m=
aking
>> separate arch versions :)
>>
>> Do you want me to attach the code you posted here to this patchset or do=
 you
>> intend to post it yourself?
>
>I think you can just squash my diff into the subject patch.

Cool, thanks, will do!

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


