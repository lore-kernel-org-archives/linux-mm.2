Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA61BC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 12:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56DD26B0089; Tue, 29 Jul 2025 08:28:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5458C6B008A; Tue, 29 Jul 2025 08:28:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45B916B008C; Tue, 29 Jul 2025 08:28:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35EE36B0089
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:28:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6D221605FF
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:28:37 +0000 (UTC)
X-FDA: 83717230674.14.CE23EB8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id AF7BCA000A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:28:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="acKyah/V";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MGkdUfoQ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="acKyah/V";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MGkdUfoQ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753792116; a=rsa-sha256;
	cv=none;
	b=4VQTxwElO52J3uoczA3Y8rHjtv+uV3Wi/tTREkmy9ym/TdK1GbS1JKnaO/f5x3QVTGzOBc
	ZJjtrZP9ZDHg2ZgAPeGCLBZdawlOzPMdrmuQ6VE/LgNgqlv24VoGIB+82jXWexNROnOnk5
	YGxGVYdrzgNa3uhLco7CsX7N9CL6qEI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="acKyah/V";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MGkdUfoQ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="acKyah/V";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MGkdUfoQ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753792116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MEoIMXx8uWeBAUTt3qneNgLxCWwpKhWrTNGeluKmiDc=;
	b=YT7rA87Xp+ZdA4rcBY2Ax48r7y8h6MWemhkB22nhyZG4GAg3a4sk34lMYHmS7g6wtEm/l5
	Koj5GgBROfsSRcTc/v6CoKGDKz6R/D5BrB0EFvlkv1n2MWg5rGHKbtrRTxydo0DdkREwKb
	DkJWE4DBpvfUYXLvWJUqkUEFxG6PKnA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3235D1F750;
	Tue, 29 Jul 2025 12:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753792114; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MEoIMXx8uWeBAUTt3qneNgLxCWwpKhWrTNGeluKmiDc=;
	b=acKyah/V2u7tElhJw8/r4m4gyKxaRh244JwlcjhgKIQGDq+zRCZRiEMsSmh/QvJSfL18Qa
	m1pObE7/Aa985ugQcIxHgmjKWeBoCJp5g62pCjedTvsb5eiYukYUSjrFjhrpOHqJa5bL15
	Q6wutLuggczcqd2WRJTtz8ghyZVIB3o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753792114;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MEoIMXx8uWeBAUTt3qneNgLxCWwpKhWrTNGeluKmiDc=;
	b=MGkdUfoQMMdA1OI31PtcuYUJxUY+pxLEU/umpZLBeWiYLRIhRGcEZhZhvg3XYGW+FDArR0
	sMKKsww9gbaUyaAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753792114; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MEoIMXx8uWeBAUTt3qneNgLxCWwpKhWrTNGeluKmiDc=;
	b=acKyah/V2u7tElhJw8/r4m4gyKxaRh244JwlcjhgKIQGDq+zRCZRiEMsSmh/QvJSfL18Qa
	m1pObE7/Aa985ugQcIxHgmjKWeBoCJp5g62pCjedTvsb5eiYukYUSjrFjhrpOHqJa5bL15
	Q6wutLuggczcqd2WRJTtz8ghyZVIB3o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753792114;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MEoIMXx8uWeBAUTt3qneNgLxCWwpKhWrTNGeluKmiDc=;
	b=MGkdUfoQMMdA1OI31PtcuYUJxUY+pxLEU/umpZLBeWiYLRIhRGcEZhZhvg3XYGW+FDArR0
	sMKKsww9gbaUyaAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B43C13A73;
	Tue, 29 Jul 2025 12:28:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id k7sVD3G+iGjJCwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 29 Jul 2025 12:28:33 +0000
Date: Tue, 29 Jul 2025 13:28:31 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@redhat.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Harry Yoo <harry.yoo@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>
Subject: Re: [PATCH] mm: correct type for vmalloc vm_flags fields
Message-ID: <5sm4k5dms2ryfxzj4v5jfzfthlzwrsournupl6kakipiuyty7m@to7gbjenmfyj>
References: <20250729114906.55347-1-lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729114906.55347-1-lorenzo.stoakes@oracle.com>
X-Rspamd-Queue-Id: AF7BCA000A
X-Stat-Signature: kot3y9hk463duqeq7faox8c74din9yfp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753792115-698045
X-HE-Meta: U2FsdGVkX19xlcBadX9bBtOfX4tkFCvF2lOeC19JjI39lmONGGsZT1AMHbeT07MK70GbfpCBNYmyyzGgtlOZjT71eQFr5EcdstyLY/wqj2QH9ZSIXQvUjL0ADhR4d51i0tapPcdUFUUKea5JNNIiWW4uQ9tAnJtla4f+0EMzfajqL2uf2wi/a+etQ/OZGM7tOi2vI1+CNtyI1Fo34Qv6KSELiqjvgHE1ggnNCleIJo6jYrRRT7dBjuh+cXV1wf6bGjPrTZaYpSN0MZ9euKkpN6UYuU666b9S22Dr9++0izCy1RUZnn6de+Evk2GomupFAesvMg184098YF0YWM+mbs+SgEwx56tWefp3K4MBfyN0IPRTM0nN2wapm8DMtlCwXkn8yQXAjQkjZW8AjbZPvzE303FPhrTTjw3uAgQoNUasGWaG9NqVdx8dTSbbD/8IXBBaz6g7J3bRZ/A7/Dz2NUqBI31tV16gDsY4zWgGVp1bJv4vEOtYQZ0+74lBYuc6j8g/0gtZ8hzI0VlUHQt6CqGPztPZIOdY7/Ln+LKon2shae4D4SNCzjqbRHjI1G7q4OmmJAF64PPBJGwaQ+bHGED73jdmhk5/UOqrqo3Q2wQ0KInfv97AKiIyDcBucI+vVVkiBBQNfgeMCIrAWQdg2niaMftFkOJbQ1VnPUQ8cTMLVzIkN4WicDDxHVe3pR562Ct49czJzQrVZBP7dPHDvz0wCo3m/bc15FLsjQMx+JJp2X5SlMVG/R/9b2PWX8MhrIGK+I5QG8/y20OKJWRZt3oeYgyhOUm61RGjpv7kKp4JGS01ZBoIqVTyEdLlM3BP9UrwA5baX+GY+U/6KFR2sI0XdRrVoyctRG6GGwOhfIfAXVeOQPBtH6zl4R/Q0p+JwfCD4aXOytZBe74zdg+l1CIJG3R/uYMHmYtXzx6PIKcP9XphxE/q4ZxX3CHE+sHBatDfCg2ijRO5912QvTV
 BjRucp6G
 aookBP4yhylcUg0O9JMriE1JazjjWqYbX2aXzAk37V270+i5FVpXNnQDh1z+I05a1zVx3Iz9jFdLtW9Y5+UNQSe0QFBo+FDEnXvxz+wpnuqYqP0Gj5Mj6vyldFfB1ZDefkO7VMeMYc3UOsndfXGOtIkRuPN6zKEpzhCAIGuvdSuLdEvh0kbCXNoWTO5fBbuUDWVPEbpYx1YXB93fYjz3Bd8gLPrpfGdzbxkj5StvIt+AO9a4tzaooaVp+IPoBVUZeYjKIEWM0Fs+UlBleKhtRa5fG2mylz/Z7IjTOoJVZJBh4ezfE6jnFqujtNY4icRbvKwRTuGgeraHV6V2G867AcaPx45MRi4cB9Qfhsw2xSz2XD6HKhTda0sQx8xBflg2VaLyWnCHVhb3x6XKa/j6lbcRXAS/W2OD41qGCCRkbbNraLBw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 12:49:06PM +0100, Lorenzo Stoakes wrote:
> Several functions refer to the unfortunately named 'vm_flags' field when
> referencing vmalloc flags, which happens to be the precise same name used
> for VMA flags.
> 
> As a result these were erroneously changed to use the vm_flags_t type
> (which currently is a typedef equivalent to unsigned long).
> 
> Currently this has no impact, but in future when vm_flags_t changes this
> will result in issues, so change the type to unsigned long to account for
> this.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reported-by: Harry Yoo <harry.yoo@oracle.com>
> Closes: https://lore.kernel.org/all/aIgSpAnU8EaIcqd9@hyeyoo/

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

I think the existence of this mistake really tells us that we _really_ need some sort
of type checking of this stuff, in the future.

-- 
Pedro

