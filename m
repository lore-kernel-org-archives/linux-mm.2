Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94B2F606A8AB
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 16:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TJiNj9Pa
Received: by kanga.kvack.org (Postfix)
	id 40C726B05B0; Fri, 13 Nov 2026 11:41:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BD7E6B05B1; Fri, 13 Nov 2026 11:41:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AD5E6B05B2; Fri, 13 Nov 2026 11:41:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF3EF6B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:41:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0EBC1120112
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:41:36 +0000 (UTC)
X-FDA: 85430661792.29.D5C150A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 77DCCC0005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:41:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TJiNj9Pa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794588094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8qKb9rlg2aEEkV6QVCRnchaPwP15XP0q+kkFlBQhaA=;
	b=wkLX+X/Ry2RfkCPilLmpDnNjRFY2GHwILqmdHzdkTz6z7kJsSBPd4XPqoPX2T2xvxnG5Qr
	cfwPoWQjKG3TU38Lr469WAwwkLSx+qJe3HZS2qkgUA4dedSPWOGjgnh2QstIcbbUgTjOSt
	FTNg/iphaj6PWDfvhW9Qj8EOoCy4hfY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TJiNj9Pa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794588094;
	b=UjK55n0CQZ/OBpnI7Go13vNi4AwmdQevgEqsL0D7RCnQGXCP31POsGlm/J9sjovtalMZ9j
	f7pPzoxPwJ7XlvXBetert9yyPhKS7i8oK61hwYUfrzoM1Ro1RIeUwS192o4FFUtWEenSEd
	FOxqK4Pcgk9YPlGnH/b01Ywscn7tkG8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DBBE5628D4;
	Fri, 13 Nov 2026 16:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A797B1F000C5;
	Fri, 13 Nov 2026 16:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794588093;
	bh=P8qKb9rlg2aEEkV6QVCRnchaPwP15XP0q+kkFlBQhaA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TJiNj9PaJ/qxzwLbB05GnqsYEczTd+Yl61wPH3YPhqTn8BdVHQHXle7Mzm5+AQzOH
	 Tl4EfUMus6L5YSKlnAoZFwvbB9lFjUYJCVJGVOsUeNWmiU7F/DYBgv70gaTWUYaLUx
	 TLrqxAChPkOn3Q9NlNDmDPYzzmMM955V5JbZNeZug2MPXsH2Hs4Jsd2ndPeRzygBds
	 f45cCvv/EhYKYgqlBbS7DCWpc9n4c1lQYZzXfnAYYW5evLxouoAek6ry184IixfdTq
	 PV5ekTHu/jSLnufJDf4QQ6xzCPJtOFXcrN6Z5rmAQ29UsVTxzGuCEWDDocwiG+w0Vy
	 Gfsr/w1kTYAdw==
Date: Fri, 13 Nov 2026 16:41:23 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Eliav Farber <farbere@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, 
	William Kucharski <william.kucharski@linux.dev>, Vishal Moola <vishal.moola@gmail.com>, 
	Alex Williamson <alex@shazbot.org>, Matthew Wilcox <willy@infradead.org>, 
	Peter Xu <peterx@redhat.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] mm/huge_memory: don't warn when a page table
 blocks a huge pfn insert
Message-ID: <avc9mjmGUcPd8fIs@gremlin>
References: <20261112051440.16140-1-farbere@amazon.com>
 <20261112051440.16140-4-farbere@amazon.com>
 <avcsfhWktvKxQlkW@gremlin>
 <9f98dc84-a11b-4885-b414-d751c0ed68cb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f98dc84-a11b-4885-b414-d751c0ed68cb@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 77DCCC0005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 3odesb4w9mjhun1ryrdeixrmfwjq6xob
X-HE-Tag: 1794588094-741976
X-HE-Meta: U2FsdGVkX19iGDeUlHKU3tq2h4GaKPC4OYeh0lhTOcJ79el6A122pnRD0lDzPYthmC4S1ioBVNRf7Np8y4TxzV87FERFpWnGlPKGqLpxcsuZU53Rx3hv0Khpoe/7f57e0tIdmPSt7XgPwFoHXUs6FFNovHfRURc1/DalXi1e2M6ru43snMcZ7TKuS479FxauD7l4dW/8WC8CH1kkTT/ePNzCjDkt3jaOqMCACvF9BAc5oZwAQLkuErb9lq1jeNrrqsR+R78fcEErrJCXbV/3dCnYo+Reu9nGOKLcnvUnaQMFFc19f3Dc9VaZ95SiGAxwjuDmGRAMZfGgHhS0depNJS0xoeDB4athFuFRgmuT4g18CkpQ/2euFuUpkE1Th72V5e+Ds+KzN9+WDhEXtyCLOYtnVICkexJrC99sNSPh2H5PNILjIzXMZAi9WXcVBXtuDIL8SwjnQzDBXrr2Pu4mfihTINnLHgwf7+jewCNfj3G3q8Xb2Tvw9E7XcDNRPlo07aW2SLjskd9uo10uoWyiX17Pa0ArfjN451Ikx5/0gNlyl5UYy0U5B1djJdrkmrVzz1iKN+tOD8nmgqc6VnlSMNs8G8Vz7KmfzZvqq6tRQ23jBJYwhM9f/lNH9ZeclpIZJPSVEXi/DxweGvLItfKvOPc3NVZCD75Vw5tKAlYX8Yp9ZVLITpxPOQEG5B1z2sELjbMzS8p1xFc0VfvSIqThPnUsxPIBuQfULUP0OGQ1R1XcvPqCQHfn2zKDvVP6OjP6tLWhvOerIRh4chCxN6a7lClrcVjTksWM+6ix7NGbU7CjlW/5k7Y5Kp9GEgEU+YXORkjj4kls3pzWG9v8KGiKHCML7cj4sQS5jmaE96suBhAPvbhqwYdUbqv2hb3Td8p9BbWzyMQQpk8g6jUlBOkf4XAMbRoTVZQTK4tHDlkIWSgw7ZLUx2CUeVAS6RqKlniClBsXwop0MvfSi3Wygdv
 ZdHP1MT3
 LUED8+Se+UzLGiQOIqk6DVk3s5lyLzZqWlipZQ7o11Hz3H/sLQepRLo7098jOWmuzUQXVfFPtaorUl2GBv4GcEmZRwose8548b5yqyikXWEXMYJTh5n+l693BpsDzS3t/vCDKLbHZseg284OUtRn1j/oGkAF495kUH+fUXEGyl9ax8haPQ/xQ4yWeZbiAEzRiRWd/xinR95n+WI6YFOLumoaUMFhkhI8+ZH8STbWl+4dsBaaAX8ucMJiJ6n93Rzh0j46qsUBw4DhEHCd4uBDx43lPEEr+u2JlIiCtiPCqGfyISHBx67HPPXyjPEDAovBXsIyJw5J6AsycKe2djsPW9+GA83ovkfDyF0BOzrZZaKFWriOtkvjcx5rljw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 05:26:16PM +0100, David Hildenbrand (Arm) wrote:
>
> > I also don't get why an existing unexpected entry is totally fine if !write
> > let's not check anything...
> >
> > It feels like the real fix is something more substantial.
> >
> > Maybe better for me to take this over...
>
> Please take over the entire series.

Ack, will do. It's clear there's no understanding of any of the code here.

--
Cheers, Lorenzo

