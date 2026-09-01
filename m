Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98025C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828936B024D; Tue,  1 Sep 2026 10:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D98E6B024E; Tue,  1 Sep 2026 10:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C8696B024F; Tue,  1 Sep 2026 10:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4320C6B024D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:29:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C8E091A03D3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:29:08 +0000 (UTC)
X-FDA: 85165425576.25.728471A
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	by imf02.hostedemail.com (Postfix) with ESMTP id D56CF8000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:29:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=YlzrbHTy;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788272947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROFHdh5YcxFRur32+u++7A9cnHI72YhPCUV519Syh7k=;
	b=SaYc2P1wqOhyIEp7ctPAM/Ps+/q6vE5PMRR9fkF9p/ceoGfslMTRniH4WQSjqClWLMKGHR
	9g0owvDID4CyKINcdnmvb+in65OK7IhRU2FwN8pK0lpzXyb9AmWwmS9r/CIAgFIQwUQiBt
	1rD+8MUup36f3W2m5c7CBa0TjeC2GxI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=YlzrbHTy;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788272947;
	b=0pEd32cgdKzBk+dvkc01ylmU02ENt7B6oXLscIe8dGbaswKxDy8qmJZXeVVeh3A2oICE+/
	4pmxa5uOUW1I81W2qUeDihHwF0u1ZepY2Mz96qipc7CGsBNbatBngG3WCt4Zeng3wTIZo4
	hokWHnnFLHKJ3vHptHSJXiN5hAG4Ekc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ROFHdh5YcxFRur32+u++7A9cnHI72YhPCUV519Syh7k=;
	t=1788272946; x=1789482546; b=YlzrbHTyy5KElcFf+Dgqru5ng16qu5fFa44Ww7laQyO40RP
	E6VaMyNWQIBcrEsPwTHHbuof0ArBNwYGUwr6RdQvXZ743uk0zbVbsRYuvM/u0cuseaD1BcoYuGEr7
	ZxhbuVIRuGtNWrmAZ5gfiRMbheTFHXvtUqc223EjNK9c2GB098GzSWQL8Iidc3BWuWjPRxLT3ENa4
	GcLp7B2oBlqg6ixMaGp6LxJ1GvLBznaLCgdM5itVvSHJdGP19M85dFyO+04gFYDZmga/NA8WV7nHP
	rG2OeyMbj0JmdffIQkMCcoKIIMmWFShBPHFvjchM3GFbrIWVEf5dvdpBttY9rjew==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x1PTm-000000062mY-3a8R;
	Tue, 01 Sep 2026 16:28:51 +0200
Message-ID: <40e95edb8dafd88fd13c3003c0e76df6a2f124d9.camel@sipsolutions.net>
Subject: Re: [PATCH v2 0/2] support kselftest on nommu platform
From: Johannes Berg <johannes@sipsolutions.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Hajime Tazaki
	 <thehajime@gmail.com>
Cc: david@kernel.org, linux-mm@kvack.org, liam@infradead.org, rbm@suse.com, 
	akpm@linux-foundation.org, luto@amacapital.net, brendan.jackman@linux.dev, 
	liuhangbin@gmail.com, corbet@lwn.net, kees@kernel.org, broonie@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org, 
	geert@linux-m68k.org, daniel@thingy.jp
Date: Tue, 01 Sep 2026 16:28:49 +0200
In-Reply-To: <apAgQJ5p8LEDj1c5@gremlin>
References: <20260825015945.141739-1-thehajime@gmail.com>
	 <f2ac9432-4fea-4007-aab0-ad80597b284c@kernel.org>
	 <ao2Tl9CLL7WjHYun@gremlin>
	 <bb9a3add-4849-4928-8b6a-0afc0c73b112@kernel.org>
	 <ao2l9Ao7BQI6uRKC@gremlin> <m2y0dsuf1d.wl-thehajime@gmail.com>
	 <ao_541nBaa3SJS9F@gremlin> <m2v78wueir.wl-thehajime@gmail.com>
	 <apAgQJ5p8LEDj1c5@gremlin>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D56CF8000B
X-Stat-Signature: h6tjujsy5swf374jxqbj5trftxnjzc5e
X-Rspam-User: 
X-HE-Tag: 1788272946-148323
X-HE-Meta: U2FsdGVkX1+tt/KlvsmVI7iHyzpAuXNAI7YnNnjN/JXbs5qnQuY/XQAiCXZhZHcga4BZuUx7M8KOxKoPXTatlICyuUzLFoej1KyVKJo47MkzhJE+ixcR54K4RcdwXee8LkyAzTlBrPSM5JbxhyQWAnHuUAKWYIATvsAEtQ6UgqFeIocnzPOlJTOFVkNSOXamkZoN4Np7sM8a712PR+djbcmy3Ak1WSKxnP0+t1gEveH0W6auQaUl5P16M2GH6OCK4U8mJ2hUzGaUg3w/ZAsmgZMEtzsdZ2vi7Wib7bHT7c6hkqfauSYxMYNSKFJ/1s30ujyklsnHSwd4S2zjD74/KpGekPlpc00frbXOHH4W9ROKKyO7wcEjOb0M/EkxeSzc/ihvkic1tJSW59CKCxw+QmBr10e1NOTic1wsPsFNYcWEp0dM1hAGnHCrtOIxWfXX5eCyhKiY1mao3zmpW/+WlPzMyiwkJEfAwNYj2Lfzpf9qOZBoibVEoLET2MA5+c7d9VvMVNvaxqiIVNonwJ06Z6f2cDW/WJ2Tg8vInZ5z12W9NI8O2eKJUU5MbPE3sqELhAxyka/VhMN5wRsBhpNsMpCH6QSeMCXBIGisJUTEjHr6L1v/PxRxcKRwx5lMwmaZQuJVKeWEfR1Xv4myvBCbGwXqoj9ONBhX1+5rpTNSUlADUtbSNimWfvI717+y/PLrLxQaTuAAFgsZPkmJYGh/VSdy6TqmhmMHQJaIOFMFJgTxbfdXyCvD+OupAme6KKjBz+GF65AsR+b+kEMIhf0SRd1B5jQCQqFUG48Fx481cbFWkPVZGgUtQISDnQHknSsvSpMXg50tCcHfg++yseBiiF6Cu2BZFy7GvCkD74ZCpcL5BIlTR74/EDWysrTSU0kQaOD7Ff8g8kTblAxMqNNOhtjAWEeFHbp17uo50R1rlvXedBahzBxYE2nasmbM19kF8zisaL9Ns1o3leF2YF9
 Qz8wK0qk
 G3E1upToAryoUm0h+ZBfPUxfGgwr6Ju22CjZ+LUMkfczBdSxkJH52izATgNzeVlPfqsT1LbJVqthFmNHOZsTU3EjgGASaMdVhNhKXMLyuoJ5+JhEaKr46tM623Bb8nEdPbW+PYv2ryXQ0V71nCaVbtKVe9XvSt/OSKQTxm+dCHYj5x5SnS9faxbXVrmb5xgN2qITe+hxNbJPdhwiQZGPabOO260UOwFFCuov3JdUsy+wCxu9v3/WpraqnCquzNF5qZxn86SwKcT/kedbrHxCvQ1dJmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-08-27 at 12:32 +0100, Lorenzo Stoakes (ARM) wrote:
>=20
> Ah ok cool, thanks! Is that headed to 7.3 or more like 7.4?

Seems everyone was on vacation (I just got back) so I believe it missed
7.3 since -rc1 is just out.

I hope to have enough time in this development period to the merge
window to figure out all of these things and get stuff merged - UM
wasn't on my priority list with all the (LLM) security(-ish) stuff going
on in wireless.

johannes

