Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D58EC5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 21:04:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C28E86B009D; Sun, 23 Aug 2026 17:04:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD8F06B009F; Sun, 23 Aug 2026 17:04:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEF546B00A0; Sun, 23 Aug 2026 17:04:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FEC56B009D
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 17:04:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5C7980395
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 21:04:13 +0000 (UTC)
X-FDA: 85133761986.07.D62FEE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id ED4CCC0002
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 21:04:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SGWtU1r1;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787519052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5VxSwmuQ6ztS1MLxHRfHBUyhAy2w+d0ivs0tkUqY08=;
	b=qInFmtyXNaQVA3esvLK6jPoNsVDNGFUZb3I1ezklgZVJ4+EE+H5ix3RS4dunc0Vsl1ID17
	qVkvkegxXM+wZE7PYllvRexRaLe7H+I1ODS87TBajmDLuW8cyJsdTyuXSB4W7UtC+QuSPE
	4zbp5gRay+qcyX8uUyGM8cvx6FjAJD8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787519052;
	b=o8rB1pj/UzG6ePTPhpRlIBcQuAiQmRNvsbhYd48JvTxdBV6P0D5omxZ8so8y3AqyRyKO04
	qIVDV8xbR0R3S6HPafjHQOS1lmfSO22IjLT2oCxy6/4DTU8gtv9idsfJRC2bHmTbh30ZE+
	aXiGZMk/glkjiFIOhQWNEiH9BpmVCIs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SGWtU1r1;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB8C644047
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 21:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07AE1F01560
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 21:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787519050;
	bh=Y5VxSwmuQ6ztS1MLxHRfHBUyhAy2w+d0ivs0tkUqY08=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SGWtU1r1O+/G6w/iQF/Am3SuKXqCK3ZinFSW5xmAN8aUfMvGFZ+x5FWOvAa0Io8h/
	 9f5VppfNfuPpISvprGPw3q1pUYiYb4HaFqNMtv7ACBaANPtEAmoDEZXiahH29QAkcb
	 9LEk4EyKKh03b/MNF3mhJpS3jNC1eEmgv0US2yWmE6r80gOCYwPou1qD+rwMEsJr1H
	 4LB0MO6MUFpbSq2Kg4AF1I5WxUqM7kUqNF+GJtIBJCxOg3MjJNT8eObfMLYq03QfOX
	 E7o2ATBWvHB6w3rXnbfBk5FiwNEIynpqY+HPY8/PzGuhCfji2qC0P/DeaLJoJPHbQv
	 3XCke1p0vh8NQ==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8f032b47e3cso17924866d6.0
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 14:04:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoyZL/b4WPaZFhkF/q2wTZouk05J/2lFl3d06Wh+x9dbruiyr7WCM3zElCAqy7zr0zwWJKXIeYJXQ==@kvack.org
X-Gm-Message-State: AFuF++lQu53SM3RLo16sVmL25PSV8bdjhwryxgeK9A3cV2olfms4B/87
	Ipuy7cuELGgoTUpSE+p7g/bsTqkHDRf0N68BRS1k8sZFTg9Udc6AYHv3ABUytw6nDN0/yFwlIoY
	tGlEm3dIWwPfuK+mXTVXLWl3RGHF7Zxw=
X-Received: by 2002:ad4:5cc1:0:b0:90c:5947:7e60 with SMTP id
 6a1803df08f44-90c80c15daamr170758646d6.4.1787519050081; Sun, 23 Aug 2026
 14:04:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org> <20260823-uffd-vm-flags-v1-v1-1-3086981b33cf@kernel.org>
In-Reply-To: <20260823-uffd-vm-flags-v1-v1-1-3086981b33cf@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 24 Aug 2026 05:03:59 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z1FHFOggOfq4V_ikdrNNmiAyDTdUaq6=Svw=MSNJODpg@mail.gmail.com>
X-Gm-Features: AcwNN1XAA5UHMELIWABqTde52FJDm4K7QaHzff4fQOng4mfJiplIHcLVl25NsMI
Message-ID: <CAGsJ_4z1FHFOggOfq4V_ikdrNNmiAyDTdUaq6=Svw=MSNJODpg@mail.gmail.com>
Subject: Re: [PATCH 1/6] mm/gup: move gup_can_follow_protnone() to gup.c
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>, 
	Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: dye9o5nuzw8odxt688hpyawjpjcbxx9p
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ED4CCC0002
X-HE-Tag: 1787519051-90518
X-HE-Meta: U2FsdGVkX1+NPmvl83YoL/llSHoT+l0u+ZTgfvjH0D7EmeZoZWZ3o/6q7i90Objr+BhNO3r45onA66EhgnyPq2lM4ervaeTEMh52eQLutLKwjPMBe5uK8F0QUMsHV2kk2bcL0ks9ocDcS3VJB6z7VnKKNZtINB37qFfBFz//2bR1nGOh3juIEzFK7Y8ZM87DIeVytXuaISXI12/UAlQMjcy0EtiBFS//3k9WFWYU8zGU3wcDiiPGTmHcJV/Glwv53vAAhH9A9iGIbwVY8niubMEXZMtBp3VqbOi+ptbcfjkGnu/8IQiMvVlRregO7FyibeADM4rty3sAszy2J0Lb85E/8YkWb8SRCG8f74cENn7CoUXx1XIm5wzRS1tUBuASxn0iDLDB9pz9x86qq5xdflQ1a5kLZMPi8hu3CIBMjXfVprSp5+olkL3Ty+JEe1Jj40kq27MC8HCye78vWtcUrCYX52RfyyIxtEz94ixwEiFD5HtbAEzjGHZ3yYHXT1NnmSWn/USPeZI4VhojCmv/MJdX/CDc4TVLVkp9EPwrh39EgRLTcSGvNzTdroAxyal+CLwh/Z+76zFjCDqT3nI6nRkP25jmu8fSJTiGsBDCVAJCVcVO3HDWqnOcX9737pBYfqcSPIaS92dfCSqnr7kA35QzsgC1OGUUDKdssYosUk0d+ifXlkQ+Kn7gAx3Sku3wyYKE3UqTyaP0u69sLv6OVU1wSaiwo4mqtKJteeUcKWiAoNIUBdVPQj7KA12IZokdlq6vyw8vg/C/kbFw9tzp5npxHyvvOo92pjJbMKnmuy1c/qojcYwAFuC5Jfz3Pfy0FRLkPnsmCRl0t/MQxOEAc0xko+VLUVpZ+RxxYKOqfgif2Kvs3mxQhnAxYAnj1EFCi1eWC83YwhmtrjSF2i5JG3tBgJyWv7FeC+wIxW8etga7Nt7dXxNaNLknkv6PQV1LxIIkigTo8fA0UaiwZqU
 g2DzpfZX
 NxoBTJ/2bMdDtHl5rGJqv6O7ckEXQINtUG7qU7/gnAeehboZNtC1ma3Alt13eslFidKU+y1jEctrpO+P3KfmgVbIvWg6LfJf+GloaPrEV01yfR9Cn845leQhWLKkVMLk9OrlI1OTDg6E/4K2qQv8yQaNzd5cCm7TjBsocXNxz+ZLy8/4QlttrBwEzRTlpP2jak8L/xbd38FnzUbOfm9TZbpxZsMISASp0UXRRvZ2jT9cs9YzURG288WTuE20ohBhvZ5HGAyCyV2cabYDvwEMpyHh/15lwzjbSSr5FggNODRonpOkMaOxIb5JcPCBnPilFYLV3oCHhWDnwYhT5LY7ReZXe+PXUPBA4LiDY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 23, 2026 at 8:17=E2=80=AFPM Mike Rapoport (Microsoft)
<rppt@kernel.org> wrote:
>
> gup_can_follow_protnone() is defined in include/linux/mm.h but only used
> by mm/gup.c.
>
> First, there is no reason to have it in already gigantic header.
>
> Next, the upcoming refactoring of userfaultfd flags will make
> gup_can_follow_protnone() depend on userfaultfd_k.h which would cause a
> cyclic header dependency.
>
> Move gup_can_follow_protnone() to mm/gup.c.
>
> No functional change.
>
> Assisted-by: copilot:claude-opus-5
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

LGTM, thanks!

Reviewed-by: Barry Song <baohua@kernel.org>

