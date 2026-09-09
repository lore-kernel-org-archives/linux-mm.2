Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1860AC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 327A36B0093; Wed,  9 Sep 2026 11:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D87D6B0095; Wed,  9 Sep 2026 11:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE436B0096; Wed,  9 Sep 2026 11:33:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 006D16B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:33:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 918791C1BC8
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:33:07 +0000 (UTC)
X-FDA: 85194617214.15.2DE253D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id CE7DF18001A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:33:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mdoKkC1M;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788967985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zTLAQxDUOUQ/JjETmKVNF6qdkHlKlo/iHhk8XqStnV4=;
	b=cf0z6a81uWKJ0dwarcCBwr6OdChviaM1UJCcauliBNTYpCz/v+VZNFMgLlvSaCk2DtZKJ7
	JMmIW3dNBGxWU3yVZuHd0lYkhLRWo+xS2+X+6Git5zWb7PBDPp5ohOKOUPWXX4HNRu+8Tc
	20JHJN6hMv1Ie+WObOoS6mhtY4m/COI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mdoKkC1M;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788967985;
	b=r6L0osjI4j02FprSiruicSir4C4I7cqy+EyzQJtah4YKl/FFh3D1Yehk/nbaaO7A93hIMv
	IaLNcuouDZdNMI/pNOe3SPHQpnRDDHGRrhxyQvSpz+k9UF9OZQlwAkqig466pdGY38CU2E
	jKxxpC1I7xdHIIpc7z7T1pN6at98wqY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5011D601EF;
	Wed,  9 Sep 2026 15:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92EA1F00A3D;
	Wed,  9 Sep 2026 15:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788967984;
	bh=zTLAQxDUOUQ/JjETmKVNF6qdkHlKlo/iHhk8XqStnV4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mdoKkC1MJoVOKplWs0WlxCyIl8WGhJfTItz9wea9ZyfLYML3xpRa3vNQa9pqQR8wV
	 v0izGXK/UUOr9vqXe7ivZwHijDPYv1AT5q9ybgfKYJGNu131LaXTfxBOOQvDD8B6d/
	 D2YCu56boH6D9ootgOvKSzOo8s3D6LGqIyLno+0sGrKrjaRX3S7CzfAFuKSNbgJswY
	 QYuYB1rEm4if2VRholu7YVZpTRfymEIijWN4zomaMidS/yagUqT5W57RBGuiAo7sdF
	 EfC5vLcQrjfmD7oe6CXsKTzr1n5i79Hczh2fYa9ovGirQH5DhTO17KpiBuAwg/GGhV
	 J5A0BwThP1J1w==
Message-ID: <17f49997-2bca-4e1e-8d58-bc95e25b9a23@kernel.org>
Date: Wed, 9 Sep 2026 17:33:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 1/2] selftests/mm: Reject invalid test
 selections before running tests
To: Tianyi Chen <diannaaav@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Joel Savitz <jsavitz@redhat.com>
References: <CACGbirTvSoSeNSpMCBiifTdRKKDsKbgk7nfvh=09fHw2b0M4Ew@mail.gmail.com>
 <CACGbirSjNMD1mijDWRp4gLcw-6dJsErrF_jgjwr3nO-geBb1Sw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CACGbirSjNMD1mijDWRp4gLcw-6dJsErrF_jgjwr3nO-geBb1Sw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ze6ze4y47opso1647rmng5suycwi4dqh
X-Rspamd-Queue-Id: CE7DF18001A
X-Rspamd-Server: rspam07
X-HE-Tag: 1788967985-232926
X-HE-Meta: U2FsdGVkX191RXDnI5ZKBCkIn6NRFoZdhXTctfEuqw9riUYEqoIHfskHaIxNaWj3Rtb+6VJ4+GyGoExOmgnFNkWcTeT7hLW3ONqEss2NzmEBlq4O4KcFJtdk8OQiSlEGeKYItylR9wZmENMXcytmkFdYocyp8r7D1STpLZGC0qwdsTRBvtYc4vNdRo/7LdNIMCmufqIYfgDAa1iFzAaCzYKAwIuaN5UwIuBmusbgJ7o0x6UtU9pk7m+Fc3uossB+da14BjCHnz2yyBvv8ezNwRI6OP1ebGj14W5pv4d4PjXSsMo3P3MkLWk9erea74kpUH3eR4Q6smh0EeIBqzy8cuF/+9IfDAVB9HLFsiiRblrHuLSCG03b84PdlpX9bLkmjU5xmuP4otnMpnrsOJ3cTkRs5pzXDc4E/mpsGwPHwWlnWonXYNjaRKV0vwwT9Q3NSai3fQy7TlD2Du353+Th7p/FQ/4yjLasW/mk89UsIfsFi+mQMtJ/m8Hv+BrQpXvpa7myodVomnb5s/WA5pYdvW7VmlnTXRX/yFimi+1jQdqGwRmI3XZ3KLnatVSi36DposyUCuBZD2sLmrtTHZOu4nXlj66u0Faq7jKyOl3dhEcQjjQVxNeXgIHavArFCaCtljWGdbNvGQlt1hJ4JraWo5pxswB+02uThSUsnDSXz+nJwwwoZQRfa0LUrCHUTO3yLjnnpOn53JyYq+TlbE9Bttjpj5i/kKhfVANDkkQayrcFAQX3FfCaoPwKQLV47f2Vg9l4fKD+cY8id44TvSY+O1BclSbIAT9HRC+Nc+yXc5o2gFN/d8II9w8bt8xyjujWZLSqRxf6kVu/n8Gt0XnpDwVGzrH+JBzhSu0LSsZyB2dPqG0VadvKTO4sjrsJO/ICw+3m4kfZ48tVOh4ldc87J6n1XfM2uBSmHqqcTyeMh8RS06iwpOowwk8IsYVKoyNa4oiynPfG02I2PenZZDI
 gZ3YRyDj
 5nCXww3tY7YRBwfZZj+IzNsAgqrXlgqB+kHEFPRPlbywDeE0UuakZr1fpfvOxxoIpAaHmLDaovolBj0ZqmPlZrbjnCnX+fQVgL3XMgjckocfUVBheN6un8Eu5VpgIYi7JIJM5BN+YbKgdeqAmH4BZUMWemsIcsR/MJ4ErAH2c3xL3KXWGCuFowpKBG4S+f3lmqqcJruAjDODoUO7l8Q5EHgzpRk0/3mDbg0HLI8iWjMuUg2dHTkfLDjsHumHkQ1AXQwIm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 17:23, Tianyi Chen wrote:
> The unchanged patch is attached as text/plain to preserve long lines
> and whitespace during mail delivery.

So, b4 was able to apply it (and I briefly played with it and it's fine), but
for review using attachments is bad.

How did you send out the previous revision? Through b4 or git send-mail?

-- 
Cheers,

David

