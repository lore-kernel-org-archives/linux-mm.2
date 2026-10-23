Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE94E606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 14:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WcT546oA
Received: by kanga.kvack.org (Postfix)
	id E4C5D6B0B7D; Fri, 23 Oct 2026 10:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E232A6B0B7E; Fri, 23 Oct 2026 10:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39CA6B0B7F; Fri, 23 Oct 2026 10:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B31E96B0B7D
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:28:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44891C0441
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:28:43 +0000 (UTC)
X-FDA: 85354122126.18.F893F2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A291914000A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:28:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WcT546oA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792765721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tYNDgS4FomXUNTZJNpkRvBZq74Kpg9AjMcOmrrvyONo=;
	b=wkjQuqN6pTC0SPojsruixGDioWmlmzBGCFYCdyG+TmYLUk9CZsXS5eZ9m7isd3JZ9zaI+l
	4hwFPiEKfBOk03JOdQT5RKwbJwAdcLfy0LAdXJ/jeBM1CL26MsuD9KMJn1VShzLZKBfIdn
	a1KQcSsapcM69zYvWead4AQ0nVODehI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WcT546oA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792765721;
	b=ffz8cV+9yBK2rEghOqEJU1bKoYfPPRRXCkPI2hiGudG71tRWyHSUYgqr3zTsQJMaGTyrIz
	S7cuMOT5xRjk2b+zEzQiZOKrW9D+UNwsKKcYOuIiot2i5cgISFcPmsuIVZXxaQ6ABQDoZH
	ERpafV3uK3JaxYhwBsVKvjFqZ+sdvaQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FD72601DE;
	Fri, 23 Oct 2026 14:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DF81F01825;
	Fri, 23 Oct 2026 14:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792765720;
	bh=tYNDgS4FomXUNTZJNpkRvBZq74Kpg9AjMcOmrrvyONo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WcT546oAtz2NoyHVdhlcvqJKm4GjbeNvAjEtqDQfOsBT42lUpW2+FtAN4IhqCbXgZ
	 WjNeKIJToUsfoorYVo5RgDVK4gxldbsfrQSlcu7b3gTOZdPotOMt0vFF7IBJgWxQly
	 C9deb4IKsXnplNky9SWj5qd8Ib2+6Z3S+KEMbGz70WSVHa55IFhkwHouI0RRGZ9wF7
	 9ew3rHb5Q93zSwKlsE0IS7gwNRBNIxrMKtHZSlLdeqpZbz0PjQiDBRVCl26FzjWBm5
	 S+paaMUasLNeOpswdgGvM2H6qTBoagPr5/1qfsZ/gcTpbMzxcNHlMRor1wiKZDr6lZ
	 /WGLpNq11xSoA==
Date: Fri, 23 Oct 2026 15:28:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Jakub Matena <matenajakub@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] mremap() fails VMA expansion when VM_MIXEDMAP is set
Message-ID: <attuz_R1tZo6y1fX@gremlin>
References: <20261023023106.515365-1-luizcap@redhat.com>
 <atsWop95CHj6oTSU@gremlin>
 <538f7c6f-3e16-4ab9-9b79-232b34fb4d3e@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538f7c6f-3e16-4ab9-9b79-232b34fb4d3e@redhat.com>
X-Rspamd-Queue-Id: A291914000A
X-Stat-Signature: dyh57p3dgtmrqitg17171rw194b4ngqz
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792765721-935120
X-HE-Meta: U2FsdGVkX1+JgIP1rv0OdjQ5Lt/kwaMubbxn7Yc48fWfwSN6lgW1HEAgcgS8p1NiI8z7C0pJ/x390B5TGNdwnbSJqIQ17q682FhOOc7GbM8EeQ4HeAXXSIGgGKMk8uFNWAHJdQMO9/h7RKvTwUHBpOWT/vnva9QwNSTJiuplqEmQw09+xostn2pgJIeNGvDbLn6TZcOTKReQURGpNLgOi0Ztnll2JssmYIf/YonEHx7FOYkH6qRw5VO9KKEFGoJMUP0YEvxstEYEWlPKApWYqvmnytKZUuVZpsQiXSc9lgyu0gW6MPv/LZWf/RLW8wdap3TtS29x/0xm+gLlpGPse1ro3oqiRspYPfN8svbeOclEdF7xrmaYAe6mE+Ej4N9Wi2Ipj1QX8uHIRG3KSqt+p7nP3zI3Gxe4M1seS6/3hOha9cVxHpcLKvX8aP9dHmJSf80jtm1bx35zmv2gu4u35hy22lCQccylihi9j/QAtSNUVhYpFFoJMq8py6ZilZHtxDapaYqHfVfiJtyHUnvg/eT9uNQRelZk+PZvs5YymoI2EEoiQV/vo5kjey8PLyj7+x2I3cUzC7LKPTHK9BbdxO0Txdy7NK36M+rA6OnoGD5Xd+AuVk7IySdTA+7zXWS5t+CSIMfdOrBLEjOdHlSgIPv3hKiZZkDaid0OFDtoBEdgkO/aBGZp64oep4Jck8Mvsmc/L3pEyktcHCazcyT6AR49jly59h/7amuThm9hsp+r/bzP0Y0ar9xLqAx2Ie2DxCluJLg3W2aDLIRyxPLg1D+LVEnlhVa5nQAPKucj4RVuleGd5u/kIBXAXw1IugrDj9sNbyqj4L/oqJ7xPPM/7ME6M7/oKJg6h2WBP4wwnWwDUU3C73Bmz6dHdF/dJShDcEkWGlTxNJIO7Zz86SSrku70ZJcE8w8q6PO3H4mjBunEo7KceOk27HxveTTN8FET0Y+WZAKdRc8g3t79iiu
 QTKVMkE5
 aBctNnt2uD8io+QRLKkl2YFtV6FHK5FKpXQ+6Y5I2M9VYUcm/P4yt7Rm7znyiGnk17gk5AHeDGjvf3aARaqANBZJ75ONuK2YUFOFo/WEmVWV5IwN3qIq/qXExn+2vGDif33QEo8PoZSiajJnYfp57H0B1MIqoeY08ZFuKaRXdcBupJogC8TCp+QKhWfKaoRDX7zSTks+v2Ik3/5cmen4tfioVUlH3AQdwCASu1zWnIZJqi5TRWctv2vLDl/MUVgi+vTi3u/GpsU4MC2ze8gLjDyzebkEGDb0zmre6D3KPpceXaQU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 08:15:17AM -0400, Luiz Capitulino wrote:
>
>
> On 10/23/26 4:18 AM, Lorenzo Stoakes (ARM) wrote:

> > I'll dig in + get back to you.
>
> Thanks Lorenzo, I really appreciate it.

You're welcome!

This report looks valid, essentially a pure expand should be allowed for mixed
mappings (with mremap() having already asserted it is a valid expansion).

Writing a fix now.

--
Cheers, Lorenzo

