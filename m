Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73739CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 11:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136876B0117; Tue, 19 Aug 2025 07:33:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E7E6B0118; Tue, 19 Aug 2025 07:33:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3EC26B0119; Tue, 19 Aug 2025 07:33:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC9E96B0117
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:33:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F3AEC06B0
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:33:49 +0000 (UTC)
X-FDA: 83793297378.30.655DA89
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf01.hostedemail.com (Postfix) with ESMTP id A465140005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:33:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fdfrPF0L;
	spf=none (imf01.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.12) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755603227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CIH7yJkvh3/ZYJwCY/qi2Mlqf8m99Z7mxVV0RImGheY=;
	b=UTyI7sNI9nqSwhM7sJCAGYa/Rpg2gLes7YkxFFtEMeoaRA4fXWv6tc3gBigvSkZjSIIzDR
	QjyVAzdD9F4HqS8RfsE+YfW0czcC28Rze/wDLeUabgL9ys05MgnMESG1Y8I6RGV3BfxUU7
	bSGvSAtc/g57FfbXhMYZkK9kKy3INhY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fdfrPF0L;
	spf=none (imf01.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.12) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755603227; a=rsa-sha256;
	cv=none;
	b=Z1ca3JxpKYwM1rgDPznAj4IBiF6rdvydF7T6YMCF84q2tcx4CJ+g8UHwB7qg6u28obma2E
	Y9ZmeTjKZd2Cnqvj6DNsyrIpX3ZPs9LLpTynGfhkXVA3YLGwlVTi0gxirTBJ/iJze3cyKY
	aL0mb+/7BpszbFmCQaGb4Rokg0KfHBs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755603226; x=1787139226;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=CIH7yJkvh3/ZYJwCY/qi2Mlqf8m99Z7mxVV0RImGheY=;
  b=fdfrPF0L1Hj970wtgEHqnmB2DXRcsX+1rS+PpSDmcEwL9M6LApXXuUJQ
   93xBxnStBqVvHGVwcZPKCnNjlCFPU/TtC7/dy6mpRrlpcNTPisUfCPmlI
   yrXpcSqTxMywU4LMi/NoVUYsQ9oZ9/Tina83b3Ol8nFS+7hJ1PO3gm+v+
   Aunm9+4TOA7cLlZ2KwdQCPlAlgATNiNWElXtRly2kZhIb8eUIJWEZYr7H
   g6RNNFyW6+BvkHfbUG+8Fsp3XqeK+lB6MlnW8gHIt6B5kiAngWOOlIeAf
   Z+Ha6TFwg9voh+TK6R6QwYRCghLZAq8grB23XwAHTqNKWUWnPZsbSL0te
   Q==;
X-CSE-ConnectionGUID: N1igxkDSSt+hnXiu34SJ/Q==
X-CSE-MsgGUID: I7acK6irTuWeu71dHmg8vA==
X-IronPort-AV: E=McAfee;i="6800,10657,11526"; a="61653779"
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="61653779"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 04:33:45 -0700
X-CSE-ConnectionGUID: 9h5gT3AbRN+Hotu/iwO0Rw==
X-CSE-MsgGUID: pw3f4t59THSX7xndiXJpeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="191520115"
Received: from ncintean-mobl1.ger.corp.intel.com (HELO [10.245.244.175]) ([10.245.244.175])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 04:33:43 -0700
Message-ID: <e96dcfd4ce7c84a5b66ff9d5f082ea209266ce48.camel@linux.intel.com>
Subject: Re: [RFC PATCH 1/6] mm/mmu_notifier: Allow multiple struct
 mmu_interval_notifier passes
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Alistair Popple <apopple@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Matthew Brost <matthew.brost@intel.com>, intel-xe@lists.freedesktop.org,
  Andrew Morton <akpm@linux-foundation.org>, Simona Vetter
 <simona.vetter@ffwll.ch>, Dave Airlie	 <airlied@gmail.com>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Christian =?ISO-8859-1?Q?K=F6nig?=	
 <christian.koenig@amd.com>
Date: Tue, 19 Aug 2025 13:33:40 +0200
In-Reply-To: <4lsv2lcd7lssyvcjvkqe4t2foubxbhuxrt2ptzee3csymz5gg3@jwrg3xow72lm>
References: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
	 <20250809135137.259427-2-thomas.hellstrom@linux.intel.com>
	 <20250818160726.GH599331@ziepe.ca>
	 <aKNT8GUu0r3i4Ikq@lstrano-desk.jf.intel.com>
	 <20250818163617.GI599331@ziepe.ca>
	 <aKNYUaPS0PiRk/yj@lstrano-desk.jf.intel.com>
	 <20250818164655.GJ599331@ziepe.ca>
	 <4lsv2lcd7lssyvcjvkqe4t2foubxbhuxrt2ptzee3csymz5gg3@jwrg3xow72lm>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
MIME-Version: 1.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A465140005
X-Stat-Signature: 1hsmpozr9bgr4eymaajyqwior1epxaa3
X-Rspam-User: 
X-HE-Tag: 1755603226-263818
X-HE-Meta: U2FsdGVkX1+HB4hORDzKtTUEPZa6xlcu2eU/LWgJmJravDbwqIabCA6PQO5HWzomDsrB72rIkiDq68FqSnspizwsPtFVgeL6jfVg39ZrAhVRASX+6h/ZoO5WVv8iPO9k21S/EQZRp0L4xrOwIiWvt0PSKhTRXSgXoSydmou61pPS/18esnM7tjqNgsImmYzHf+wOhnJQWziAWrv/w/VN7NxhDdrOfZdr+nulTz4KDiZbw6yyAe1MdJB6iSYGzNR+2pyBr/MVKpwNWazq4m17s3UrqQgq8dkj936XVKkHMDuH15EwC4Kpi3yqyoUne9Sgi3hkQrZJ8dfPU2r6WarTofDDsZZxrPpQ4cZrwYoIbX9Vh5GKSjL9dGdnnM3cYvZ+AlKjy3fwicCgp0QFz6ZyG1LVk+KmiL8HJFwgIoPKiZkO1HsI+K2uJdbL77//dNM+FIizhbrFJYiZkFnpqmW/CSVoehzXswtye+lrMBW9+an18pwg7+fpjj2PfMsDIb2YVpCcQon8FF4Zz/EDzmrdwL3bSSzgPG01ALslFreYM4/d0+FSUNSJ4uOaboNUesOj9OYnhYtN4egc8QNH14RXDc9Xv/RJN9ILu/xJijW+1NTl7mHSA5i2aYKG1wRdXGCGNCaTiNXU84H6/1OSBaymgsvO+kWfRgbkB6fukhUPZrQTKhbUvsqc+IImUxHdamwPQ574FvWOlxHlJodJlVaxD7lja75TKVFHHewrGlfWZGemLBqvQrrV43KRzIWDJIyTJO9B/feGhlcAufOtqS4P+eOn0BBB/7ubyL8shG8+EMuEI0nvOx2mtswhsUWX9omZE06YMPK2Ig78NiAXyXhzJJetOgeRNaFp0shGiAzElPvr+iylRmfAjPRXvww7Fo+Tn4ZzjRkgoXrND5gy20DcbdBo/vJjB3vQEgOy5eSJBrDIKN9gNkAjzvUIv+KNgZoQfFVeRbqDdSEmkUqNMg9
 YKMIB9fe
 LEafAvfwxz93wHmSf8gcB3jmTWF+kwLV1DV9KHgOk1A5HfSQFaaCPvyDKAU0I0M2s1Ls1XYERRB9QQ7tAIe7qVrsAAtrgoSlnV6UavjkCmCXzNbivuvfN/3iE7HH+9ULK7XZHENeNLryQ5pVaCYQkryjfiTlcGFiR6otN+q/K/C5GwGplvOjO4Wysh4XjHDrVMR8EcftPXHFgOS9G0aKNnYEpN+cyFhSKBbD2JkwWiSZSSaRJGlh5fr6Gn4GnnRXEvHvK9OSCpqa5KKLKyIXNw9uWTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2025-08-19 at 19:55 +1000, Alistair Popple wrote:
> On Mon, Aug 18, 2025 at 01:46:55PM -0300, Jason Gunthorpe wrote:
> > On Mon, Aug 18, 2025 at 09:44:01AM -0700, Matthew Brost wrote:
> > > On Mon, Aug 18, 2025 at 01:36:17PM -0300, Jason Gunthorpe wrote:
> > > > On Mon, Aug 18, 2025 at 09:25:20AM -0700, Matthew Brost wrote:
> > > > > I think this choice makes sense: it allows embedding the wait
> > > > > state from
> > > > > the initial notifier call into the pass structure. Patch [6]
> > > > > shows this
> > > > > by attaching the issued TLB invalidation fences to the pass.
> > > > > Since a
> > > > > single notifier may be invoked multiple times with different
> > > > > ranges but
> > > > > the same seqno,
> > > >=20
> > > > That should be explained, but also seems to be a bit of a
> > > > different
> > > > issue..
> > > >=20
> > > > If the design is really to only have two passes and this linked
> > > > list
> > > > is about retaining state then there should not be so much
> > > > freedom to
> > > > have more passes.
> > >=20
> > > I=E2=80=99ll let Thomas weigh in on whether we really need more than =
two
> > > passes;
> > > my feeling is that two passes are likely sufficient. It=E2=80=99s als=
o
> > > worth
> > > noting that the linked list has an added benefit: the notifier
> > > tree only
> > > needs to be walked once (a small time-complexity win).
> >=20
> > You may end up keeping the linked list just with no way to add a
> > third
> > pass.
>=20
> It seems to me though that linked list still adds unnecessary
> complexity. I
> think this would all be much easier to follow if we just added two
> new callbacks
> - invalidate_start() and invalidate_end() say.

One thing that the linked list avoids, though, is traversing the
interval tree two times. It has O(n*log(n)) whereas the linked list
overhead is just O(n_2pass).

>=20
> Admitedly that would still require the linked list (or something
> similar) to
> retain the ability to hold/pass a context between the start and end
> callbacks.
> Which is bit annoying, it's a pity we need to allocate memory in a
> performance
> sensitive path to effectively pass (at least in this case) a single
> pointer. I
> can't think of any obvious solutions to that though.

One idea is for any two-pass notifier implementation to use a small
pool. That would also to some extent mitigate the risk of out-of-memory
with GFP_NOWAIT.

/Thomas


>=20
> > Jason
> >=20


