Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E77EC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48EED6B008A; Tue,  8 Sep 2026 08:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 466C76B008C; Tue,  8 Sep 2026 08:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37F2B6B0092; Tue,  8 Sep 2026 08:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4BF6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:50:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A5851C2800
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:50:32 +0000 (UTC)
X-FDA: 85190578704.24.5FAC6C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 62187100002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:50:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZMSl8cWl;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lKBFZhPs/eGo1uvy79sNZrgCL1vNlvYuvk0BKQC0ZEM=;
	b=Kwj1MTZkkEoTAO/NGi099wu+by2X7XPQQe4/b48Ex0w50P053DljpCqU/cy3p/Y0cNYULe
	gKbvor5aw3ucJ8N6OZpi8H+sboh6qanzHxJ+M++mGGHo/Vm512m3Xp7wgiS1476j6qE+R2
	dZStYoT1BSES94Lt6UdbhSSd1Ud7Vbg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871830;
	b=N1rmbHyVTb22LLUomrpZERpguJWvWW8DRwdQaF0Y47oEd9vN4Ui/dHwq8BMoKP/xL8Xh02
	lwA494mmA90FfnTaZ3+cS77IYnYWx+63ZXClaPYIRWSGxlFBbIAXHL2aCBVF1Ox/+mkpiN
	c6eTW4vcdj9Q+6w57RCx9PEptx+4KLc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZMSl8cWl;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4097340BF9;
	Tue,  8 Sep 2026 12:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E3F1F00A3A;
	Tue,  8 Sep 2026 12:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788871829;
	bh=lKBFZhPs/eGo1uvy79sNZrgCL1vNlvYuvk0BKQC0ZEM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZMSl8cWlZMT42GbWGlAWuzPvmeOJqJWUYg1qsIu94uFfoz+Te7zxeDYfXksLXAJ5V
	 WYuV2oW/intOhz7QqS0OB5E3MqY4cinTQdtPvLsUXhXg+5If5fVdcFpL1PAq1LZWUn
	 MNLqKWJI6OGqZlVtApYZ08dDdaTa25Un0TP+7Z1V4zuCvJfG9VivLOZtZBnc9Gz9aQ
	 9PaeweDbuOXRgo9OZzNOCYAsgkT6cBHsJjn2EswgkbHR+aeartlg+PqJSLEIMp8aT0
	 1zMHjbLzaYSTa23T22YJcnae5sBCdirvTOcp8Vutl0LGe/wmJ/ZOmc53SF5MdJqkPw
	 SyDZxQ9lanGQg==
Message-ID: <dccc8e21-ade5-4726-ae17-a7017f084a02@kernel.org>
Date: Tue, 8 Sep 2026 14:50:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] tools/testing/selftests/mm: add
 MAP_PRIVATE-/dev/zero merge tests
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
 <20260908-map-private-dev-zero-v2-6-acc7b5625305@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260908-map-private-dev-zero-v2-6-acc7b5625305@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: eaz8fm9wgd8o4zgo11rwxnimxg7mqhgt
X-Rspam-User: 
X-Rspamd-Queue-Id: 62187100002
X-Rspamd-Server: rspam03
X-HE-Tag: 1788871830-608450
X-HE-Meta: U2FsdGVkX19OqdyEfYd4mtewhEJLraJyyfhuv75nO+2oJrSmrZpnheBQlyktq1Vil2Y9XeJi+fxM0aVKzagr2inakDY0MDcsVjNDsBO6t9aG9lPLdkUsCRRfBAJ5kGBpncjTEulBaVZGU1CJmQG3rrc7Rlsv3MDWJslznmDnzCNFzdCTGjQn7JJ/QMbnLitWLDmFEep99yPTOgPQL/wYyWoDGrd+eMpkdzQ3D/cmmMgo6NsIEPaqR+e2RPI7DLcrzjz4Iblkuae0c5jjoT8uXeTKcTFZZDBx9W6YX0IfGukWBv7UUKUhCSmRXM2vIXqsRmhpbt1GasMtgox6mccxSQ81BryPQscnH3tXcvUGUFcgKRaDqr+yGM73uw2w+f1/jtzdmqRpafs4JJwdJ6JaWn+y4AuQE6v0u8MjpOzIUncvb1hSD1dM4Ca6COmnDL1YVhxJmxXR+DMjsmU5po53b+YPesL74xBZSes+ytugDb5zaOnPvD1WzSLnkjRRwcp726cmWsAKN5YFRNowpWTucnuPrJcXvsHWkeGmPxxNxYO2Jnk75cczWzxL2yVCWU2UbWqueBs9dBGMDUu6RqypJN2KrNE8nlOpv5218OTc8C+R0EmM/ytwi5dqWT8RrUQapblARTEZPp9DNIwysO8dSthtAV/zw0/1idoUk84IOWMrkKb8iTqM9iEoPqcypL2B/z+p3btPTGlpRf3uUho9KDs3qUyZy2PCenlfLoBBENgg4CRSDijeElampjYSZ6Wp+aW5RRlwxuraSoXwybVCiYfOo1jyYqZHF2h9TfRsUtn1EQoAms/8eNvaFB92C1aVSgecivAQOcCUY5yiDyvc9wwoguotX4FzI4L+Di6lC9J6dMfBLXCoR7eMikNEKCsdgmx32qE476WCY7hpUKe1pTAlMthp8q0WVQQWClaVdP5IvKv7CaDoXATZS2ewYISXBJZXUbXEe4WkvbN2W5l
 7obpuEul
 bQwiK/GP8PJmoPQ8w6+fK/6d5WQSPFjEsEKKHkyYkAUrhcSfO6K1NC0jv2cd+iC/9YgqfmYSdpgHXULWJHvslizhMKCV2XiVJlrqNI89geEHeMADhAeBrq/NZi6cyvterj+vbFENhxSPCaodWG3zU4vGBbCU/QAhJDFMy4wWzEfMtWXgruw5lLmFFrhqh+8j9OWUSbfFUHnsfWeLxHX21nOvmivaBSpf9vV/Ld06kgsF7kQTruemgb6vM2SYswFFlv6wgOBHaneqpMhM0NW0psNwZrWP2SK5FY+xeFBiNz6S7EGaHzoFgAlu1B2WVVyGEPaX6r+Fgr3UoMz0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 13:23, Lorenzo Stoakes (ARM) wrote:
> Assert that MAP_PRIVATE-mapped /dev/zero mappings behave like they are
> anonymous.
> 
> Test both unfaulted and faulted/unfaulted merges with page offset 0 which
> would not merge if the mappings were treated as if they were file-backed.
> 
> With the recent change that makes them behave as pure anonymous mappings,
> the merges should succeed as their page offsets are equal to their
> anonymous page offsets.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

