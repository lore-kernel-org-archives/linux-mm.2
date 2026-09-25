Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF9AC98325
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 15:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AB276B0088; Fri, 25 Sep 2026 11:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65C286B008A; Fri, 25 Sep 2026 11:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571996B008C; Fri, 25 Sep 2026 11:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 374436B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:59:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2178D1206A7
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:58:39 +0000 (UTC)
X-FDA: 85252742358.06.F4C22AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 89040C0004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:58:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SgZQLK/Z";
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790351917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qR8azvgZfaRgE4wOVbNM1K5aJXx9TItF6h8M3YodUMk=;
	b=CUb/9C+OesVGHOZPvcKckVwvriUvyKuyzTBclMeuZNPU1zU/5J4Qt4CNK+GNR9VoNpwnnu
	cHtnottQuxCJBFUY8G/NjQ9IUsz0MZhEnQLI9ApCSa8wNuU6vkt/DTgIxmRw2akqGVMbho
	/GeG/XOFt2Qqe6B3aMHBtjc/5tlZ/vI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SgZQLK/Z";
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790351917;
	b=VJ12IP22JCJhHwzmKoerqMHokAPNg5lCl12Jkt/drWQjVeQEzp2eOppb98A9tkgkANV/gB
	/A/gFkRq/+pK+6qqkl73w+U954YUCqfj4MG5paLohKkDuhFiQYzJmNOTElWAu0vqzGlhVA
	REkH6oLRHwqvyOrsyKVukT//aeWBFcE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 144FB60230;
	Fri, 25 Sep 2026 15:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C781F000FF;
	Fri, 25 Sep 2026 15:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790351916;
	bh=qR8azvgZfaRgE4wOVbNM1K5aJXx9TItF6h8M3YodUMk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SgZQLK/ZjTy0c1dNQAGHBfjxb6+BScZ4bBrLAmKMtrAjFjBCc474psP22+z9Q7xbF
	 DLvGeI0/5a86Cg111z8elU1nj9UDgNB9FgPIf+OtNj7PrPff30k1WdbFXon7D7eWNH
	 uZH5gkis5ea40x1CD5tlZTwvy/KMyX4c/1Ra+1/8g2N7h0fd9aNsjyYIypYwRhWeSI
	 Yb/ngp7yrqGrT8odRHzIJY0kwFKBVKHn20+desMT8QYhhMhFfu1wpraK1V/jsMRMIw
	 3oym+6bAQgvvUCIuC29xsJafd8BSCe+4/cyW7txTLiI/9gsjhuz3U1o8rugfeA0cEU
	 N5qKTjaS0cx8A==
Date: Fri, 25 Sep 2026 16:58:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	sashiko@lists.linux.dev, Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: Re: [PATCH v3 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Message-ID: <araV69I3WLn9I_Nu@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 89040C0004
X-Stat-Signature: dwcchfwkosqw4pq5qh16gobimieyj87g
X-Rspam-User: 
X-HE-Tag: 1790351917-584971
X-HE-Meta: U2FsdGVkX1/8nQwiXEf+Otx9fQ2RWvajAcuuYh6LXF569e5zH95+qGVSi+INHoxAHcNDp3WX/dZthdBMIs1QiSokVbnPXMrcHkSNpzXfh7Bpq53aaYzN/yKBsjJhXeDFhjDc5OxBFIIeMh7OBoj3vKFqdr02PAKxqY/EeB6I8pQHhZyH99QRLxytYvV2TrAulMtI3WD0AF8ze7/uNfTB9vk5E6dbx7W09tc8ANs7xFkREfapX9sCNsyDO7Hb1dGJ3QI7Zi3llgDSimTLmEX+NaoZbed95guvtk37NsVodzHYsPUc4AE+qKi7ZecrA1lTc6lZ42vWq8YBF57j0OnX8T/CTopUigVkNPMhViYqtXQpGuaf3LZ5A4QoepBpseEomFh47HXMVBzXfheNd/rFebO4PoPVl1DckP1db3GEy8vEHtt0NHPnR3Ztzc/hi5CbrxaCtcXRfDJjgN90qFFnQsabWPsTZDIqqNXh9Z/krdNNIiANsZsoPur/J9/EDhupWxZjDBLqBvs84/GXWhTEYvmdcJXd/L3IN2DNU7SUntvvaGjv/ZheT/uawO75MD463wLJ7GNEfpPFUtbPKz7307GBtw2+fTjuuLaNu95ZdSp7PBBAho9ulwpFVUQGuuv1klShsN95pjqj/q6R1T9bDqdCZAaRCaLegPvRZG/e2TGPI5U4zFJ9ME9CbkUBLNWWQQBSNpBRV6eVvRKv4Q5bdLEOkCaOTfJXYQ98FUaQEt42SMtUNOQB1V43pzLjm0pj5uq7V1eWBOdBCzbPZd29p95SpimWHK3XGJhF9fVDc2YGhZ5yStSF6hDXnM5lDWD0bjVzCIzD/hsI1fJED8mi2hoS57OVUpwCXPUxa0atA7VpgQdH9MJNFJXCN0x+rsBnNlTSOeLHzVMMn4sTk6dTNfmtVSV1OYkN5YxdIJYKIKSgHQkeruyeS4Hxd/rtkww9rpO20Y2vdH9Y1YcSHgO
 3/OLZYTI
 8AIPce+Yr5Iw2SCG0Khprk6kJ5Cawwa3wP8euNoH2x7c6zVMSI5NX9J/VPHDIb/anxblKtrL3akW3RedHdkF6PP3occM6b69361iTJNHt4JCAUAHgNDcL3FYi14JxEQVZllcU8T0OjCx7WEr7K91N+aXbj6Ss9aiQSIcbgH72XeSqw/1MfIc9SJNFTN/oKrsA6D8ftqZRPH+32xlH1xdC/N1t0XDJuuoPKYft1/pqAAjoqc6SkJKwjuoF+btYYJenQVIySVZtZxXR9nTmdxBAvBPPFFoUW5unm7M9Dj6LSUFdMkg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

< Edit mailing list, +sashiko as I gather this kind of feedback is wanted? :) >

I usually don't report it, but here's an example of some false positives, which
sashiko regenerates on respin.

Specifically the 2/40 (high) report was valid, as raised by Gregory and now
addressed ready for v4.

The ones on 1/40 (high), the other 2 on 4/40 (medium, medium) and the one on
24/40 (low) were all just wrong.

The one on 8/40 is bit but had some semblence of logic, but still not something
I'll take action on.

So a false positive rate of 83.3% here, or 67.7% if you exclude the 'meh' one.

In general I've continued to find the rate to be 50% at best, and it has not
improved over time.

It also seems that low/medium reports (which I think were disabled before?) are
particularly bad.

(I thought those were previously disabled for being inaccurate?)

I realise everybody is busy, but it'd be nice to have a means of marking
individual reports as hallucinations.

Thanks!

--
Cheers, Lorenzo

