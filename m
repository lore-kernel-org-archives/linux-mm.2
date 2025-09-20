Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C69CAC5A5
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 12:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFEAB8E0007; Sat, 20 Sep 2025 08:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5ED8E0001; Sat, 20 Sep 2025 08:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12998E0007; Sat, 20 Sep 2025 08:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F3378E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:47:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A07682E4F
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 12:47:45 +0000 (UTC)
X-FDA: 83909605290.13.3AC6E3C
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [176.9.242.62])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7D0BF40011
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 12:47:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=none (imf12.hostedemail.com: domain of foo00@h08.hostsharing.net has no SPF policy when checking 176.9.242.62) smtp.mailfrom=foo00@h08.hostsharing.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758372464; a=rsa-sha256;
	cv=none;
	b=eqKPv3/9MPy9STAzwCjC273klhpbAoOxe7djNwAqAaOj95SoWKHvbFpNDMyZzf4mTLm/Py
	I4wbSthp/wLKmz0Dz8YHjH/tncQhlPm0sBOd8m4ZbkWgXlBHlu4qRd0Q2IuqZGaFLe061c
	B0YQBsHVZ8zmUMHdl5FuSeaXcYLykng=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=none (imf12.hostedemail.com: domain of foo00@h08.hostsharing.net has no SPF policy when checking 176.9.242.62) smtp.mailfrom=foo00@h08.hostsharing.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758372464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kiYTmNJx4zbudQh5xlMJaraNXMJ3Jnc7uOOKRWV/Mrg=;
	b=iDQV22AxVxUO/cBn01u9BqBkB6dEiTWphPufnzgQW9C8NWNSiVHqumiuZHBayfVZtDAVv6
	uZwK/TUzwMH/m9nBtjSN0DR2iVjft8S2JAV+l0q9K9wt/Pna4BirudarzM6TXRNDUTJPl3
	AVqEvGt+pHoaD7Bd3dDtMLY4yWt/kQM=
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout3.hostsharing.net (Postfix) with ESMTPS id 08EC22C051DD;
	Sat, 20 Sep 2025 14:47:41 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id C3C4E5D31C; Sat, 20 Sep 2025 14:47:40 +0200 (CEST)
Date: Sat, 20 Sep 2025 14:47:40 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Alexander Potapenko <glider@google.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
	Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com,
	andreyknvl@gmail.com, andy@kernel.org, brauner@kernel.org,
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com,
	dhowells@redhat.com, dvyukov@google.com, elver@google.com,
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz,
	jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rmoar@google.com,
	shuah@kernel.org, sj@kernel.org, tarasmadan@google.com
Subject: Re: [PATCH v2 08/10] drivers/auxdisplay: add a KFuzzTest for
 parse_xy()
Message-ID: <aM6ibO75IidHOO3m@wunner.de>
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
 <20250919145750.3448393-9-ethan.w.s.graham@gmail.com>
 <CAHp75VdyZudJkskL0E9DEzYXgFeUwCBEwXEVUMuKSx0R9NUxmQ@mail.gmail.com>
 <CAG_fn=XTcPrsgxg+MpFqnj9t2OoYa=SF1ts8odHFaMqD+YpZ_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=XTcPrsgxg+MpFqnj9t2OoYa=SF1ts8odHFaMqD+YpZ_w@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D0BF40011
X-Stat-Signature: kxek8fx9br3nuz7e143zyiz4zg3mpycz
X-Rspam-User: 
X-HE-Tag: 1758372463-667899
X-HE-Meta: U2FsdGVkX19XB7p5RJC9ibmZFuc08ylYsZcJ1kRwSNBbMEYZbiMTBOYQ8sZ7l/S8bwQMi5hV1pZCTzMtCgyg8GdiFHmKG5l3o55MvH2+XW67Alhyuaj38/5r+qFXkdAux/R2NivLFSQdUlT8YB8gnT1jvqN/ReBJb0SgSaqkyrcM2ltD0UemFKGIN0d0Jkf932OaNt5XrlZ3ebtUUly/njb6QUqKH+CBdbl1SZuWLSqGwgRTIOjIdCw/Thm6rgDD30hwbBFzIWPw2GNkpVwQGJOmIy0HO8QP4in5W8eIrPtNueKqxfs3GgDlIVnJ6Dnrp4mczGIEi9kfozaglq0xFt8XX4R5tM0pelYstlQKIUEthuTBS1N2Ik7kI1p+uTRQ09VGnAH7+6wO92eINmzfMf1GOXxdFTrGgiZAhTeIzM/JUrP7+1J64+HK0e0JW6tFuWwsBDCiZpqeJdR5jHEWDyrmRaiFQ7zt64eIv/u/+QJQ1k0wiWJefydnE2/eEkOrl6OkdNMhtNaUKxe/GhCcyYwAfAJI52Y5C1rkk9luc2THtsa9eY/H3YV5QSnxlJU7xY5k1HE9ALScEJyHWmupyWae20D6j0X0xP6NqXN/qGeWMowzS2dRWtxvemSeAsc+cmVL1I7exNcYUbcwAMUuY721naA2W0rUgBSkxQzId9jJsP5KV5eiPR1/akejBrWzp6KkFjet+m/xJCkX0vIuazi1RT1BU/8RqVSUdTO7tpTnRDbAmmimKA2JcRX9ICrV/QiJdj+rN7uWtuAvkZtMKgNUrtJ1x9LJnNweFcZlOEcQJCP+LzsttoaucLmCIr0TuTqBBshua7767nNLSO8pZFBRJQeG/Kjb3l6kFqwwvpPLpHwe8YXpWsHYCN+58VuJo74pUc0tUvFcz7aTg5B7Sq8uWomP+xuUWMwKcAfbB+QZj3LNjrej7Q2F81kKUWkat6erz8LdEveEuE2dMzk
 TEte6q0Y
 K2lkNzpRPlpwtKqgIdN4O4GZc1mTHZ8RKp3P8GcpQDn95QfXBPOIJ67i5PHUXdcYpWF7o29o2AONFtrUFTXLKErz204WtthnBkkVWPMa3f6H+utSXa9rkAfDhUr4mPLv0fs5PxtXX99IHzMbVYRhQ78GfatW1qXtlg1GoKUan78W11uzSlDUWW1L63GTmmSpNwjbby9RbybLZtg5q4sFukbSqc3b3ubcqDefS74rErAl9ipotkJSAd2ap/qalRGJjW1A2pLsMPHRtXYauXxwWbG48MHq4CiLGvWFumbaHxJeXmhlEgCquYdFRPEZluRBWU/9hgBxq8wRDmzQktOCXkvVeSLaj6h5JwGNNcY5Mn9obrhkmS4JeYb8l3VLv5WC2qmEfhIevknkB7ETLYVnzVeFwHW14iGdFz64MH5xbreYh1US9y7ZkYXXZh0oduFZ5HN3tG86Rg8HH429Taw74C+x5WzfYlWDPLxwF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 20, 2025 at 02:08:01PM +0200, Alexander Potapenko wrote:
> On Sat, Sep 20, 2025 at 12:54 PM Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> > On Fri, Sep 19, 2025 at 5:58 PM Ethan Graham <ethan.w.s.graham@gmail.com> wrote:
> > > +++ b/drivers/auxdisplay/charlcd.c
> > > @@ -682,3 +682,11 @@ EXPORT_SYMBOL_GPL(charlcd_unregister);
> > >
> > >  MODULE_DESCRIPTION("Character LCD core support");
> > >  MODULE_LICENSE("GPL");
> > > +
> > > +/*
> > > + * When CONFIG_KFUZZTEST is enabled, we include this _kfuzz.c file to ensure
> > > + * that KFuzzTest targets are built.
> > > + */
> > > +#ifdef CONFIG_KFUZZTEST
> > > +#include "tests/charlcd_kfuzz.c"
> > > +#endif /* CONFIG_KFUZZTEST */
> >
> > No, NAK. We don't want to see these in each and every module. Please,
> > make sure that nothing, except maybe Kconfig, is modified in this
> > folder (yet, you may add a _separate_ test module, as you already have
> > done in this patch).
> 
> This is one of the cases in which we can't go without changing the
> original code, because parse_xy() is a static function.
> Including the test into the source is not the only option, we could as
> well make the function visible unconditionally, or introduce a macro
> similar to VISIBLE_IF_KUNIT.
> Do you prefer any of those?

Just add something like this to drivers/auxdisplay/Makefile:

ifeq ($(CONFIG_KFUZZTEST),y)
CFLAGS_charlcd.o := -include $(src)/tests/charlcd_kfuzz.c
endif

Alternatively, if the file in tests/ always has the same name
as the source file but with "_kfuzz.c" suffix, consider amending
scripts/Makefile.build to always include the "_kfuzz.c" file
if it exists and CONFIG_KFUZZTEST=y, thus avoiding the need
to amend all the individual Makefiles in the tree.

Thanks,

Lukas

