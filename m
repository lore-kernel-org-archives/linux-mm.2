Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A73C8CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E707B6B0096; Fri,  5 Jun 2026 13:22:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21406B00A0; Fri,  5 Jun 2026 13:22:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D10156B00A1; Fri,  5 Jun 2026 13:22:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3AC86B0096
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:22:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73E76163159
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:22:09 +0000 (UTC)
X-FDA: 84846527178.04.8E556ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9ADBDA000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:22:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BRHTcwSL;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780680127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pG5SFLXqHSL16ior17lMXeykIDslLb784eO5noWxsxY=;
	b=S12wiYNyikMNZnRwdWQXqWYD4JEtM49o0XNzAMfjWDXRaOZWmJ4CcSg0O/aRbTyNaACRN/
	ji8cq9kYbq7vf/KTGP+qxMeRtawX0R3dK8x5mEwNxw7HFtfWkF+yau2+9ZrBipHFhiwvd8
	exkE8p0UjiKX1OVsuskZCwXJuadIbBs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780680127;
	b=J+tfSptsbCTCLlVavf4q9kY1TXcRz019OBwUKl66yTdRTTM/+nZD6GdaTIDqWDvMe11xAJ
	KhSnIH8otBAgyg1xrzTc5e1a3FxEMq7xNaSeAVlqeConwPxiBGxUXXzRXR25gnj8Irzb0m
	Aq46/cwp6+rPWfMkohfGMXzQmIlxlN8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BRHTcwSL;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CFBB418FF;
	Fri,  5 Jun 2026 17:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB7A1F00893;
	Fri,  5 Jun 2026 17:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780680126;
	bh=pG5SFLXqHSL16ior17lMXeykIDslLb784eO5noWxsxY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BRHTcwSLuouyHkitWoP16Un5boWNOPQuWBN7Wfs4c5kaxEYJ5pzQ8IC76YLhWwEJE
	 MfOCyBaL2kAydrKWSApqqYLHEBWPHcaG4eDe30unadQuD6RcUvfa2vw1+2Za984I1O
	 T6ebBHPw/pq0y5QyWi1323ELh9Tqq83f7wYypIDpQfPGzm5O5Feudng6r7ZlPyLaSm
	 iBmmGcoRUVYnsCXsjWiFykWgBHb6b1neceY1xFS8zkQoVWE9SpVL7uBRM6AhpnN+vm
	 LfrXK+Y4iyvFm+H/zZQ+YWgb+mpoBjGJ6KpuRXcgpszyIIooSDNHVSCiPTBqfk+fs9
	 RL6Kk8Jp0ZBLw==
Message-ID: <aeff656a-ffc9-4c7b-9a3c-b27cae571961@kernel.org>
Date: Fri, 5 Jun 2026 19:21:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
To: Mark Brown <broonie@kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: Askar Safin <safinaskar@gmail.com>, linux-fsdevel@vger.kernel.org,
 Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org,
 netdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 David Howells <dhowells@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Pedro Falcato <pfalcato@suse.de>,
 Aishwharya.TCV@arm.com, ltp@lists.linux.it,
 Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260531010107.1953702-3-safinaskar@gmail.com>
 <d9806b34-fc73-4878-997a-95c5e8ae4b29@sirena.org.uk>
 <CAHk-=wjBZAzPdZgEeHAtSiwJpomt8ZZgKbixuiHfRm09a4=PtA@mail.gmail.com>
 <1eac3b42-5dde-41c4-930a-d74cda9e6d68@sirena.org.uk>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1eac3b42-5dde-41c4-930a-d74cda9e6d68@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9ADBDA000D
X-Rspam-User: 
X-Stat-Signature: um3aw4ftqci7tu9mn97e88iyqpw6f5y5
X-Rspamd-Server: rspam08
X-HE-Tag: 1780680127-50081
X-HE-Meta: U2FsdGVkX1/1tzFM37bayytHjzoFfA6goCcQymbYiaGZox10ItaPZBr8ufX1NA3cBoWAqU0OvlkvRFVk0pbtbeIETJ6LwcFHLSLtCaIbb57daeQRY34fEsWUubxN/8dTEO7cUx/WJGQlTvcALjf8+D2GghmFAPOq06/bPHuVDncZIIjCMjbULQCOagXrau5YjoGNDtsqzURdUHYzV0G4u/Q8o9cSXyJH4uzmveZok0vNZLJvlD2clA9DJyXXde6nuGM6jpockf54lGh6J8z5pKiiMa8Jq48bigdMq8C6s7sLyG+K8xIGDudhetzPUjxJjVGXGTxddNr7vRiLxyS/6iTtdra8BHliFfrLh1SxqzL8TuOiikVL092VIkutLFQhURy/jdyfrW8+/wiQdRncNgJZoTNNNV6XcO2/vLPVWyhr5VZepJHzXaMmkCP7uC1J+0VH2u95IbMTY3R/jUbiwnawApPBwfwY+dZ+LQQvYzsslFkqXBOZjGXM9Np8lB/QHdLtd4mJrb7mIo428EhxVMP9hYeYBi4Gqm24AsfKFcSMQl4oiPIAwgnHHbf9bY4H+9KGV0atkAJwT2ty0lbbFPAE/7AP+zKkr3hes6K34nG/Z0EsKFt3lPYH4erbSMSZFyyRz33I4jzAEP9fB/vZ8e2fuQKwW3cXv83k5Jwz/pnoiJAzI9UIyYIULyBc5oAcj5YswNnQVhUhTNIL8Sotufa3cn1ntUXl20nudOYBC+PSXLFYt1Fqr7c6OoOhkqJzB2FFfShEri+NhdoOYgsJ8qdft5hVpoczooOvmkID3W+JJ/qosid5cbgnZS3EnbHvFmwtLhHM2tn+pOj5ZiRfIfl9ZNrU0sYrbA8zCcVYGkhokoM5MwARmzITIE8J/ua7RMoGofD29Cyn/5lWGmWZrYLoXTGU36krcRVxRxoMeIseI7BRelnulnNZ4LkQFjd6038IzSfeElxRkvcVSeU
 UIvNUw+O
 JP9l4eLZ2MhJuSR0IwXQt5NcpsKNNrrSiMM28+eRklmIjcGT6Pkdbh5IrqP4HhQjoOJA/Wu2fnAD2BpWK2kMTL/vCZ5IAWqDEQiwjVSY2+pY8FYsW29QbkhGhNEJCCxg/EYCYbdBIJaghivH7qtMro9z5Wu8u2QuAXdGopk66nbOAy/+PcD1qW/ivB50ZLSQSF6jsv3/eeR4S682iR9VWa0vq3WRLIV1agVI+UfnAszLKnstD0Dy6XO3I0lcO/dNcmsrNFN2Clrk21x4Axbxp3dclYYtgZjcMQWr5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/5/26 18:26, Mark Brown wrote:
> On Fri, Jun 05, 2026 at 09:02:52AM -0700, Linus Torvalds wrote:
>> On Fri, 5 Jun 2026 at 04:02, Mark Brown <broonie@kernel.org> wrote:
> 
>>> | L4472tst_test.c:2050: TINFO: Tested kernel: 7.1.0-rc6-next-20260604 #1 SMP @1780589917 armv7l
>>> | L4473tst_kconfig.c:71: TINFO: Couldn't locate kernel config!
>>> | L4474tst_test.c:1875: TINFO: Overall timeout per run is 0h 00m 30s
> 
>> I htink this is the same thing that Christian already noted (he said
>> "reported by David", but I don't know which David ;), where the
>> vmsplice() writev() emulation was done as a blocking write, even
>> though vmsplice only blocked at the beginning (ie waiting only for
>> _initial_ space to write, not then blocking afterwards).
> 
> Ah, yes it is - exactly the same issue that's mentioned in[1], I missed
> it in the middle of the quite large thread and didn't directly find
> David's report.  Sorry for the duplication there.

Yeah, I quickly discussed this with Christian on a different channel and he
ended up sharing the report with the analysis directly.

-- 
Cheers,

David

