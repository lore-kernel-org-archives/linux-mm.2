Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6796C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 14:52:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8D626B0162; Mon, 17 Aug 2026 10:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64126B02AA; Mon, 17 Aug 2026 10:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3CC6B03D8; Mon, 17 Aug 2026 10:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 744F96B0162
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:52:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DEC2E1A07D3
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:52:36 +0000 (UTC)
X-FDA: 85111052712.12.61840AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 532A380002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:52:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CBoIq9lL;
	spf=pass (imf30.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786978355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wnsRgd67O5ijJMELnbh+i0cmgBbItG68MRY6qRnSMzA=;
	b=0ZG67zSUv6Rt/WYKFjAmETEDvDeTfHZE5Pj0g0wrK2qqCP/F4nawE89NqRc/xHC9ORzp1v
	CIkX+t3uMeYfvwoQpSHyTJyCZnhnnE0rlOm9zKR5L21F2KGPzj6r4VQnnQG+Q8ZPjrFLMu
	JlknuvxcJ5i17mWAxUhikxY3F4+BULw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CBoIq9lL;
	spf=pass (imf30.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786978355;
	b=iciTwvmnxGdg5tlAXg6y2U8aRg/tIAOgb89tgLDUC6MsRYlUJ84iKzOCrqzQXMN/2XSc2y
	fhg480xd6ghTjUX2jxrO4iKF/FwFEVRTjVW+noYpWvC+FBQ1ynN3DFENo/91VvCEY3D06t
	ryUho5qKHzpWox3eRWRZc3GWc/uJoIo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 85389601E0;
	Mon, 17 Aug 2026 14:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F371F00A3A;
	Mon, 17 Aug 2026 14:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786978354;
	bh=wnsRgd67O5ijJMELnbh+i0cmgBbItG68MRY6qRnSMzA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CBoIq9lLGcS1UGfR4RR+GyS2qSFm8aL5eb+9zilvIc89rv295t+J+1iuJ2RdNYN95
	 G25ofttDY+XuK1AH5qG92ZIzkAEkONWdMALeOvk0NT42gNuHCzqWLWd9KbVPWOCw5p
	 ur5Gu+9bLyhlnKL13dobkZAf0L4xSVlHOROg4JpvVPf87NF4JB3luCj1ItTd5YRhqD
	 irW7P5rpyC+dFSJrxnBWYO+S7tHEmLwA4OetakxSOUZC20faUsFylpFkqnW+VDbmHA
	 p+smz5BpBO2zuDaOYjkXj2gF6+Nz/EzxK2oHF75hOI3g7i2UrPEwzXA5il4kD7inkq
	 iNIMSvK5+lSDQ==
Date: Mon, 17 Aug 2026 09:52:31 -0500
From: Rob Herring <robh@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Pratyush Yadav <pratyush@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Baoquan He <baoquan.he@linux.dev>,
	x86@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/4] kho: rename "scratch" to "bootmem"
Message-ID: <20260817145231.GA579285-robh@kernel.org>
References: <20260811162642.3504565-1-pratyush@kernel.org>
 <aoMdJ7hpr1GonLz8@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoMdJ7hpr1GonLz8@gourry-fedora-PF4VCD3F>
X-Stat-Signature: e31yzq8fepoadgyq3abmwyspfcsdw3w6
X-Rspamd-Queue-Id: 532A380002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786978355-256616
X-HE-Meta: U2FsdGVkX18OQzHSqg9Z1KDDleAlgPEfLxCAXE5/veMHXixL4QXGQh8wV8EwPMErFcRizNnBcVM+LWmqJ+DAjJvvauaDwhJyaI+EoI+qWC/uWEa+QztWeMv9sueaSs3OC9HTG2wHdQfruQZsEwSZvjPffG8w2593BbCkHQapCOx4Ps/gJCtO+r+j/81xs45rcGA58GzVnYq0S5Qtt+9tDaU+SJiHQZ1JLWlctVx1bPn4/m/kEsQTS6ukkLz4t6wQWB+fkOqy1rkxfv+CndHqJorfTDQ3WGg88pV/a24SE6ozRDBSaWY1wdPCzM0LWhUFbHnUDujePuTnP0qL/FCq9fCjwfRcT/oVXHhMuoxk5l/8Bgkp/ZLRP+2wdqKbwUlzfDZ9iKRZTzADF4NQW7wP+Hjoq9hMoRaHE54UqZfqWFldMGcDg3BjUVdruW7dGQVPK+ViovzAaRb9Wsq8NtgWhRNHZU7xWZZhHkeYf0ZD0vduOj45VVbdtjQ7lIet43PqMAXmd4QGszeOePmCDO/Dx7MLCS5TIj+S0aVaHZ0W9GQeyHrwmX8CMECM0HbPtGFk8KEU7ok7XMSImeWA12dJJlat/sr4n2qVxVj6fOLqZXUKBxq6UmRNJWhzBUur5b58Pg/c3j14cFf0aDyjy+nnEgcp+YF4Ncra/56BxLvK/qO+uZQo/QNyMwhHZJjPpQvCqrIY5S/zRDl0fqGVypHibSWGnyvFNlkR9whRGWCcfzEOH8sa3wjbqFKZ/Sdxs/g55LzbIWgFjYjEP+YOwMgWVujeGU46MGPNWxpbjVmQh2omnys3BHq39KL+9qlfBc41Z92NgaOQaPozPy0kiGpXpwjfgMTdxzUjP8BQSoY/Eyb3BUtpV4yfMawEPHSfAtkF/Z6nSvtFDmf/iOpBYn7gNJuzxDqDzOnLIXtXvTdnOKmU1zqyBqO80NIkTMhq4evWlnAKgTw32mhtPMwT8Kt
 i+lBG+oL
 FWK/ifPeNUgUzCrEwJJw135HEJDj5oi4nErOiYXhXqdnaKI/u5Vbnw4ilBFziss9xj+ePT2J9zHtxTjckDFkopwPort2FfqJEEtR/Oa3JRzX/S11W8Ub6Cq7vnaFxcF1a6w/RDK8VXwCXhXPBqeM2Cw+pH2y6npMmGneQljG8su7l9bS9qiB2t7nxj8PNgHdfHo+GdtkaprxXK6u/+0FPTXN/coTXqqUq/yHrVtn6u2dwHX8j/kibAiof80Ckitt7/eo4JuVoWH+XwdnR7Ww8UlSIhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 10:42:00AM -0400, Gregory Price wrote:
> On Tue, Aug 11, 2026 at 06:26:36PM +0200, Pratyush Yadav wrote:
> > From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> > 
> > The term "KHO scratch" is vague and overloaded. It does not accurately
> > describe what the memory is for. This was discussed previously at [0].
> > The conclusion was to rename "KHO scratch" to "KHO bootmem", since this
> > is memory passed by the previous kernel for early boot allocations.
> > 
> 
> This seems like a lot of churn to just rename some stuff, especially for
> a term "scratch" which is very much understood to mean "temporary
> working memory region" in common computing parlance.
> 
> The boot param name change would also cause breakage for existing
> systems that update and depend on the scratch parameter.
> 
> Is there a non-verbiage reason to justify these changes?  Living with
> "scratch" seems better than potentially breaking folks.

I don't think these are the first breaking changes. And if the changes 
are fine, then that means more breaking changes are fine, too. So why is 
this upstream at all until the design is settled?

Rob

