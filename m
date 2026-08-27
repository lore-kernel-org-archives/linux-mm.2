Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11592C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 07:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FD1C6B008C; Thu, 27 Aug 2026 03:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AE216B009F; Thu, 27 Aug 2026 03:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2D886B00A0; Thu, 27 Aug 2026 03:38:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9EE06B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:38:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 427231C189A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:38:00 +0000 (UTC)
X-FDA: 85146245520.12.022CE82
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A15A81C0005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:37:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YtN1N0ZK;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787816278;
	b=zZvHE/suwVZTiHEqOER/knNjhxRZtgZYvu7b8WWS31B9ZVCmUPRcT3z6Df076H7z4aMUfo
	J8n0C0ivmHagpS1LGJXIHbhCLwrahzX6PJoM7RxVyFOAsPJfq334wktlLbPEv/4ENMJqwO
	UxDM92Zkd2EBRw4BeEaID9T8dFULYow=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YtN1N0ZK;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787816278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kcfEKE7rt/Pg9IfggMqdyKnd9tu2Y2Sa7qCBo/H57wk=;
	b=cG4HmtZO0zyvKJPquPkDuBHoAzFdZV/8I9bBPlsD2AFlpTPhBqQGKankVifpCOw8POnkle
	MRwDm8iosacqFV/QS7IlMC2mnWLWislXwDFRo7NbFI6xaaFvm5UqaSMe5VRiZaqrA1Pbc7
	ZLRTRFwfimXRx4ZJ0XPKjuZDPpPOQO0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C91E600D0;
	Thu, 27 Aug 2026 07:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E741F000E9;
	Thu, 27 Aug 2026 07:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787816277;
	bh=kcfEKE7rt/Pg9IfggMqdyKnd9tu2Y2Sa7qCBo/H57wk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YtN1N0ZKpTNC+ACk+Iim+r89M0aXEkdOIv/V1hRB1ZzZX4DQjEPTjRrK12LXL8AVu
	 BWh21RAalkuYyMyY6HXDdHspEGKriCUY9qUR7JvMcfPYoieO/SaJe/0VVtt1HSJG85
	 GbZyMEorAwP0cV0HBrvvAxL9wUZND8pqA0ZPFqZMnTeZdXi3982xSYgxakZPurEFH1
	 U/qtYvQ1+JrGKEPZ707BtWNcRekosA4UdjHKws3rEcSf8VZXs35q20qDy/esBzoJQR
	 VowMX87d7KsS4t7IwLTJmVywP2+8Ry0+TLZ2JJpkTXwXu28Vfq7OCxm2jt5brNjTwp
	 ymUQ36p5OTETw==
Date: Thu, 27 Aug 2026 08:37:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
Message-ID: <ao_o-y3tbs-Ccoyu@gremlin>
References: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
 <CAGsJ_4wH_-2NPV2j6wxN_EfAeXvDe_eUnkj0KVUu0nn+ANfohQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4wH_-2NPV2j6wxN_EfAeXvDe_eUnkj0KVUu0nn+ANfohQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A15A81C0005
X-Stat-Signature: sbegpinxkc9nqwyob6xrzndmc5ccy4p8
X-HE-Tag: 1787816278-599103
X-HE-Meta: U2FsdGVkX1/uPtIF/wtoJdtOWpNQexKMspiHNPGdPdc5VaKVuthyut7WnXgzfoExwuEtChVg8QJVyFDye+DFpvZ4ODxTCMx33sXAO8k5BCp+YwUHYebhUBU217KmXNzvWZ/cHy2ywFammN+nCndm39sZ1XkwyHu9oIepSzwi2iEliItn84+CnK6snUzj7iHmWb8/ugb6ep2fRadCaBmtgt2LyUvQiYfKmO/8ucY39ijQ1OM/cylq2FGR/ZdImyOQOk7hV64JfOIR+Zk3ohLuVzCTjp0RClyji0svTX70IPligFdentlYHbfFR4JSBRDi6uYFrNsENn/5H4FM77+AnZ4CHdfkhcxL+W5tDo1ibykpVGyLjhrk4wA6XIk26OV5nqG/UTsmV0AvfXsyS+cREoXsbXgPeIk0VkcW36dkDIDMoERWmpg9L9UlnOHOyXjbiHK20TsCgfWOekoa2IKLIqnItlYnm/+jaGgH2X3nm+SGyBh0MsjZ+y594V6/mNPYbSfmdiBEcGycrNA6CORpsLEAhseOCl9S8xKe7k19/Gl/i8LCg4fv2wkkwjOGWV5hY+Zp+bD0TpHSwL7ZSbCVvNNe5cCp2uN0rHdqzla/p9ZSIRl2rnaRiweaa32gHF7CZo6i9jzv46wJ3sRUlJSVMNi5MURhY25NBe1td0gcXOJ7znDZerv90KOcYRKG8AbX9ORNSTe7wpzlYkVP3O8MRei1dNNsxz8X+BoL49WqsT5pGkbjcT66FkawUCcI9lfJGU7ur16u3vsw0VIut0ETqLTsRDsyk0BdUdj+WAMN6HGMXPzBne9uXmplsPMzHpaS/MWREOU+m0i4DAFESbK6AnV2wlI+Cz777VNFFFOgJvpw64ZkJG08q93NguNSByka9+ugOcAskrD1lZUOsXaHP//wuMiCwz5KH2J23eDLyXxCdmikH4HVaAQIKcy3AaVB9JdvuHBWoT0rrp0xaE6
 /WCaJ4AE
 Y6MfU8ZWwggE2W9eP/Fl/hyZponhE0dlH49bDD4fd6S8cjtnz/MHVJXhMCe9JfaS2tX7IQvRijzlN58JoW8dYdeVQ7+kCENqw3a4u4CVFy9eO0/sa1qmHYFpfL4ab0A7m1Vig6YzKBDzBjmNo/pGH7K1SjhPtKaU8S4Y40Y6yNQU2GrTBDclQvzXjIboK+oUBk1lPHZ0fmoOQ/tz7wi40PSMSbJT0iZku7lGFOdqIUHkBz41zk/B/1rOZUo+eGdOLkNJqwe72LnGF87kvAu+fiq7gWNqMiiwxSF1pb51v67x1VBjyMs6WTe29f+pNrIRsVqvPOKPCmObQESQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 05:02:50AM +0800, Barry Song wrote:
> On Wed, Aug 26, 2026 at 5:56 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > Unfortunately my workload is such that I simply no longer have the time to
> > give THP the focus that it deserves.
> >
> > So, at least temporarily, step down from the role.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
>
> Thanks very much for all your hard work, Lorenzo. I can really appreciate
> how busy you are, especially while you’re still developing so many things
> at the same time as doing reviews.

Thanks :)

>
> Personally, I also feel a bit bad that I haven't been able to contribute
> anywhere near as much as you have. I still have a lot of catching up to do.

You shouldn't, I often feel bad about how I haven't done X kind of work, or
Y kind of work, etc. I think feeling this way is just a product of working
on kernel stuff.

The scope is so broad that it's hard not to feel like you're accomplishing
everything you could, no matter what!

>
> Right now, as David probably knows well, my colleagues and I are working
> on both FS large folios[1] and mTHP[2]. I really feel that I’ll be able
> to spend more time on THP-related work and reviews.

Great review and contributions are always welcome :)

>
> Lorenzo, you have my deepest respect.

Thank you very much Barry, that's very kind of you :) likewise!

>
> [1] https://lore.kernel.org/lkml/20260826082641.2007658-1-zhaonanzhe@xiaomi.com/
> [2] https://lore.kernel.org/lkml/20260825043833.2659350-1-zhangbo56@xiaomi.com/
>
> Best Regards
> Barry

--
Cheers, Lorenzo

