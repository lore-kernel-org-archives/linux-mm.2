Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 057E3E784BA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 02:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D462C6B0088; Wed, 24 Dec 2025 21:26:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF9256B0089; Wed, 24 Dec 2025 21:26:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD5686B008A; Wed, 24 Dec 2025 21:26:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA08A6B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 21:26:41 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 234C8C186B
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 02:26:41 +0000 (UTC)
X-FDA: 84256405002.27.2685B0E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 11EEDA0007
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 02:26:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UgvTo+Ze;
	spf=pass (imf15.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766629599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0yhfpKa36z2S4e97UcvwglyoKQJoQuKZ4hzUKoJo5oQ=;
	b=MekpZmA0gPdHcng1vYUANaTpKI+N5h+Y0vjBtV5cXCDHlt2jEdrla2qeyNOf/rGCZNgP1D
	hD/PlfWxmqq/t2hFI0DiEqzn26rMg6yF4WFV2cpAuqBcLPjSovqAd3TrQiAGxA20lzcHJc
	aAbuetS4ECCn9Y0BV9YAJTAE/Ak0p+s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UgvTo+Ze;
	spf=pass (imf15.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766629599; a=rsa-sha256;
	cv=none;
	b=nTLJbkyn9tRw+kZvQAHeNvH0WRnFhnyRgHgbdcQFdJ/9x2RCrVAPrJIyd5/qjzDZ+VBDJD
	Pr0Tx3njzs6av6lJJX+4lwRiytvkU1RpivZcHGi4TCmqUQzvIZosFQNtAfA0twkzi8xJLy
	FOL1/M0ndx9WC5utfpmML6UBmWhh+hU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766629598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0yhfpKa36z2S4e97UcvwglyoKQJoQuKZ4hzUKoJo5oQ=;
	b=UgvTo+ZetAqF4m3PurNQTv6sZ2Qf5g51L1vfRwfIenHnTlQwThcOYEknDzxkj7yaaPHKSb
	FGT0sFkL4L6aQmhtQtsG1bu82y7SG8hslK/vFXLA1vfXc7yOZ2YCPjAittRySTmOxaNACd
	Xky3CT6QldHMlqPrSjmjpn9mysRmhps=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-284-XD3JdoSdMca2cw992Umbgg-1; Wed,
 24 Dec 2025 21:26:32 -0500
X-MC-Unique: XD3JdoSdMca2cw992Umbgg-1
X-Mimecast-MFC-AGG-ID: XD3JdoSdMca2cw992Umbgg_1766629590
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A7461800365;
	Thu, 25 Dec 2025 02:26:29 +0000 (UTC)
Received: from localhost (unknown [10.72.112.137])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F37A30001B9;
	Thu, 25 Dec 2025 02:26:27 +0000 (UTC)
Date: Thu, 25 Dec 2025 10:26:23 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>, linux-mm@kvack.org,
	glider@google.com, dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	elver@google.com, sj@kernel.org, lorenzo.stoakes@oracle.com,
	snovitoll@gmail.com, christophe.leroy@csgroup.eu
Subject: Re: [PATCH v4 00/12] mm/kasan: make kasan=on|off work for all three
 modes
Message-ID: <aUygzzVSqg52TANl@MiWiFi-R3L-srv>
References: <20251128033320.1349620-1-bhe@redhat.com>
 <CA+fCnZcVV5=AJUNfy6G2T-UZCbAL=7NivmWkBr6LMSnzzTZ8Kg@mail.gmail.com>
 <aUtd6es8UC0lNf/9@MiWiFi-R3L-srv>
 <edd6e350-5482-4551-aa94-e1ab8d2f9774@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <edd6e350-5482-4551-aa94-e1ab8d2f9774@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 11EEDA0007
X-Stat-Signature: uftjcu4kad3oxwmofbbgb7r8mkkom4xs
X-Rspam-User: 
X-HE-Tag: 1766629598-127652
X-HE-Meta: U2FsdGVkX19T2LIsLK1bqcerc2lFL1vO0BSv3U7sTOyqVeVrudvA6631t/Xhzbn7jDAG8N4JmeY+XiSHKQmNnSsmXtqFRNNd8PF5dy+I7FPNP8VKcXeaYEgUj0QzpkrH6jFptoNLY4JMyimqjzfoinuAVSrdp3oINoDUPPptfK+Kf/DAD4QCytj0CC2+hN00XCJ2qjWak4fsn5KjjKfj049wkaGgE232X4RhR05AehdSxoEjfrFONaukqDJtGuCTR13yDB7APCRcZl93vHiM7JELxk9rH4oDozr7w9Bq+rEAvShHgcWp2WAw5tiBB2i/L8PfM/lhljRhUnYeAaKlB6SfTya9tsXMv291P9DDPdaSHAK6j3u3LRa6M8UIsa8QMOCByTAhkg2rxAwzEfZ5+KxoX+q3/KdPmovknQb5MbqdMXJFg74IXlHW/IYZFlccbH8qnGWQkg4LdsxfZ4kDYyP84jMvWIzSKJuQjqtHODuVoTVnk91lWnp4/kk3YUxeYJ9f6dTz3ln+5i7M0V+8OobYEXsSFoLGsuwB0KmWi0jprf+pCeoapIR3LUK5eBAiBlWpcjvzkJdtvMNOIx5AWu/vvZueANea0SDI3v3x4mSXhpDTlxzhHQS0a/wKs4Di7ZEPPXUKSvTIVCSA39Xbor6EGa6S/ZSymyCljrvLgqHZwMi3+tEX1upmVMZSwvBrkzvbtWOCgqaANpxIi2HgitoaNep6lVnGyhbLrzc7k4+eBzUJZeanuNU0CtiwxXJoFr36hcxm25zGvWeb74xb+sAvcRQOfccfGQYj2pcN0DWmkRWeUgDsAPB82uhkPmSj8agMOa5jPEEr1Gw41VSf3wljiiHAVPwlStNPCnDS3sjx3XTld2hQUNYfV6JwZ30TDkgR1QNNp8sNt3FJOz7d6aYhu2Ga3CdIiaHsuC8GA0x3DFCfvf0zXyqSZPS0/JrgDhsTasaSyXo7M894RNm
 K7dT+OzO
 w8kvADkbSLh+vJiJpzq5fs8xpSdkfJLembwhU9sw+BaE/RmBtfYYRBfIVZOy59cL61y1NRWhkzq4PmmA9lAopWj3Z2Co8WZh96sv5OvxUhOYkTFkJworAO8okhEsEliNOZoVDwZoxf7cLI2moI/pg7GvOtbnX5ZWiMdGF687aNhQbe4q0wp6iaoA4xvzSlH5RvI6kmcjc+y+E2L7bz5GEyYST6hCvLIHOU2QPJff08yW1T+BORvbm0YO0CGUZ8ljOMAzxIOthwfBtORxIE4jDGcAXNF3bd6baMpWJLiKRUlBcF5EF0wdt9Uo643cMiCaxGooTTTeff8UfGX+jycIGkH8lXF84nWE4DKN8xlijfaCv09c9jefXWTvP9Oo8cl6sDUjNMbs/fU9dAc1441/qdXeXR8C3Bvi1M+e7PXUaZTQ+lWofm7H4n4YxecTejRJc4RmUrNHfqojLL8Zg1gnPMgo7AEPGE+LTKkrZPF/B6wbpLbNPyuO0sCs8RqXAatuSM30yJ6PvAYDMa8BqYdBCNkcpB4YfmbNAI322BGaJGhXvYmA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 at 01:25pm, Andrey Ryabinin wrote:
> 
> 
> On 12/24/25 4:28 AM, Baoquan He wrote:
> > Hi Andrey,
> > 
> > On 12/04/25 at 05:38pm, Andrey Konovalov wrote:
> >> On Fri, Nov 28, 2025 at 4:33 AM Baoquan He <bhe@redhat.com> wrote:
> >>>
> > ...snip...
> >>> Testing:
> >>> ========
> >>> - Testing on x86_64 and arm64 for generic mode passed when kasan=on or
> >>>   kasan=off.
> >>>
> >>> - Testing on arm64 with sw_tags mode passed when kasan=off is set. But
> >>>   when I tried to test sw_tags on arm64, the system bootup failed. It's
> >>>   not introduced by my patchset, the original code has the bug. I have
> >>>   reported it to upstream.
> >>>   - System is broken in KASAN sw_tags mode during bootup
> >>>     - https://lore.kernel.org/all/aSXKqJTkZPNskFop@MiWiFi-R3L-srv/T/#u
> >>
> >> This will hopefully be fixed soon, so you'll be able to test.
> > 
> > Do you have the patch link of the fix on sw_tags breakage?
> 
> I think this one  should fix it - https://lkml.kernel.org/r/cover.1765978969.git.m.wieczorretman@pm.me

Awesome, let me apply them and test. Many thanks.


