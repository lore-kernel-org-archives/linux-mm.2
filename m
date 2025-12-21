Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3365E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 11:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDBD96B00C6; Sun, 21 Dec 2025 06:18:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86576B00C7; Sun, 21 Dec 2025 06:18:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7AC46B00C8; Sun, 21 Dec 2025 06:18:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B5A9B6B00C6
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 06:18:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6558C1335A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 11:18:04 +0000 (UTC)
X-FDA: 84243228888.11.06451C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id BB69AA0009
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 11:18:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u5SmioWX;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766315882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3SiZLaSgfUWvI0ADlw4fln/XM+z1mug13vTC0ceO8g=;
	b=z01/5h1OeZYdlvQ9vJsD1WLU6A5sC3Z0E9yPjg+mm4U4ddDX6wE3Ri6xZWsUwiRn4kzr7c
	JYlJLAnzq56HN7UKgTBqnKmbGyi2iIV2UiIe/HoNpEI2eBtrVoDxKNdHRm7+yl2jeMbrAJ
	9/Y6yortnCDlzikeBnT8tVnxowuADKQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u5SmioWX;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766315882; a=rsa-sha256;
	cv=none;
	b=5IiL3z+h633Zc8gViAm2hom5PDf3LkP1rbA5qsobaGMZkcmersj7JTxm8m/exEUOS2Lw5q
	jBdSvo61KN+JDHnyOHq1/4Vt4apPTL1vc3wymXhXxOKnUobGFAsJwPkRG0Q0FU2WEaJNxE
	vieExORnXh+AP0nMEphXnCCv/xYZyJ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 04AEC6001D;
	Sun, 21 Dec 2025 11:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39E7C4CEFB;
	Sun, 21 Dec 2025 11:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766315881;
	bh=ds7M2y+Ji3tCtnHlPgcG/0INk9eEwdkT/r4bGYpBiys=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=u5SmioWXDcvEyf/QIBmoSytmW4D8SIEEIZ3tzLGnDQ0XwXW+Z8TyYVL4NGBX59Z8p
	 pOjx3oOqkZtTko2rbdUjcUYugRkDM6by3JzYQjvFPNyJdFBDeQgcaS/IOM3ib8+IMU
	 m16s7JOn/70tLZ/rga9WEXlkXbz24wc9MG2z/PxWU+dBVzT4LjZvdb2N7uqIEmxraQ
	 2T5HpWoKDr+AhAZklgcVET71pAOAesTV0LoAGoVOBYirnqUotLAK4bKt9lbHnf2/a1
	 PXvzxx2y13HjWJL9iE9lfOUO/IbCBhXoXj9Q73FZ+K/IcgVi4dLVBm1z4DYwvuMCTl
	 Q1ZEfweplO+sw==
Message-ID: <7fedf049-af02-4ad8-bc81-9afff28c66b7@kernel.org>
Date: Sun, 21 Dec 2025 12:17:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: fix minor spelling mistakes in comments
To: klourencodev@gmail.com, linux-mm@kvack.org
Cc: akpm@linux-foundation.org
References: <20251218150906.25042-1-klourencodev@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251218150906.25042-1-klourencodev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BB69AA0009
X-Stat-Signature: r4kzxpiiigayfzp8s314t76cctqnc3og
X-HE-Tag: 1766315882-827412
X-HE-Meta: U2FsdGVkX18Hh9NfuqDovlU0FeoJAqilP3VfWiTK0/PpUjgQFWoA616LE5NQMZfklfRh9S5SO+PH47xEDuBJzs/YabKolxZ/qlBS7Hl7AOUUvkqZgm+OvzO9vKbIZLa4z9fsmV2u1+AkHp9ttGse0mVO0mvt5zVdkwAL9CBORXZG+YNkv6NlFIICKJRA5uHTO+Gp0cbl6QUj3Bay7f+9N8U+WAGgOa4+Ac0jnZLtWW5uTQptICaoamkdgSabcg8S6mqLniyRv1acriY/CImSiiKuYqrhnJUjdK3YFed9/+8yCAu1nntefPqeuE/FCEMSkla0QOjEH2aZ2yT2zZKKElWxJL+26BRx/souKY+W8uEDEu6hJQvN6cpttMUOscBzCRER++mw9SC7YUsRJgDM27chrWMZPcpwBGZJVFPUv2W8bm5MSQERNwMMYLjE3uz/z5rMNEeCGMSL5BxOZVAXvgu5o9tsJhIx2VhAnEeoRXdD1Y9B9KcoPSTHMjT/KyFN5BtwRVQ45ZbwfUA5/ftfytkP123MHtopGmbvxcUKynXtCl9kUdU5qg9/sIzKSPVQcNa8+sQa4t5tsPPhVi3iuRzuG5Ac5Akut+bvCPxAa8NpqlsDtfNbwFiha5ZJUOU2Xv/vpc730Z1EB1Ksf1ps3pQC+VrvaMutZnc+EiPkFnZ/G7uKvCQ/eGZgbBqZXP3DYBaCfSGtiwlz6AaG3B/yUo38maWWZPxmT3QpKYsvPhrVi8roRsbq3UM0HXVEdgOAb1RvQ8MBG4zFx4YIOfBE/faeTVbvY44nJ472biKM/a4xzGU6LTKDcfSrKvt51mOLEnLdz9GiXQuoDN+JQ/2jslmXmg5hPyFnBOhvHesJiipNOHp53oyIsQUTH/G7z+dcvqNqsV2BSPWbEGHUq5l0uvo3DpnYVXkwob6ypuFk8VqXXhzaM2BVqA8yvEry0kM1Xpr++HvooTaLzrY37tK
 5DSrwHcA
 mn6oxllIQy3DRkNJrPd4LZOa4QYKzesu/omVxhR0htMJ/ntlsCQYq+avp+Kk5XocqG91kAwJ7ewUaGKhJOqZ1CKwnHsX7j6kd3XD7HzXqCl7CeObl1IVqFyIf24N31am0v8j5olJXfLkMKWvjugW4e3twSbOHURPJMR7Fj3QojC0Jv1PsGYy+zgvj6myvRevS8ikVVxKu1nQE9/h2pQtTZ47F7KXMLyg1PNhd3WkN6N+qMVHiIl2rV9J8TjMxqlb83k+Fmpu9fnq8+oMmPmKp7nUQ3vMOcRCi9l3fVjrtVaKi3iOqS4NPkmpEF86PMNHJQzw2tW4cz8zx0x8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000138, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 16:09, klourencodev@gmail.com wrote:
> From: Kevin Lourenco <klourencodev@gmail.com>
> 
> Correct several typos in comments across files in mm/
> 
> Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

