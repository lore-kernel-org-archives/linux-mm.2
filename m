Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F053CFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 18:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3096B0022; Sun, 23 Nov 2025 13:58:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AA5A6B009E; Sun, 23 Nov 2025 13:58:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E7D16B00A3; Sun, 23 Nov 2025 13:58:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 377576B009E
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:58:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A2A5A160169
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:58:41 +0000 (UTC)
X-FDA: 84142783242.11.301F7F1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id A1026A0004
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:58:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V2AwkH1w;
	spf=pass (imf25.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763924319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGBGXV63GWONBhSXcOYRfuWB1hafcWHebaEyXH0Age8=;
	b=IEPcn1BLvgonjgMIDz3De8m+HX+JBxQEwkdSApeFvyDHYMv/k/wVAMmM6W97DnhY9uYoE9
	ZTecBXmzctfdlvVoR7zZ0kscaubeESCOlSuusq4AuQnfTHbGq+BD4OO4A/KDhsWcFFzNv3
	ygagVE4VrpUMzoLxH2n+VQgVJOZLMRQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V2AwkH1w;
	spf=pass (imf25.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763924319; a=rsa-sha256;
	cv=none;
	b=eAyA2DJy2NjyPygiY8DJg0N5h89IoduH1vL0orAMk5kyzDwZ9ri0gDk0lq97/4okXbyCHz
	I+GjBv1k8mc/t7npwfUQum49yRmvdsLu3aEYuMPzV3NjRWQUyzUP5HTjzhgNDNE85PUZjp
	4ILDMtdtTHWch9DoFTZUpxfbs1oJ0M0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763924319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wGBGXV63GWONBhSXcOYRfuWB1hafcWHebaEyXH0Age8=;
	b=V2AwkH1w5e4hCe2kaTwYECT3SDQSC5uXP6A6A27rNU83Qbi3bKN4/lTjf05gx6V6bg5dDi
	fYRJp6snP2Lu15YzyBbZT4gzNUTWOLFs7Al/xboIx7wnbPf6v0oRCH/ijd+hRMZSwUMbcO
	4KEWFLvENr/PqOJsgG0hLBV00AiaUP0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-91-PsLgnA6uOli0lSIaSWPAWQ-1; Sun,
 23 Nov 2025 13:58:35 -0500
X-MC-Unique: PsLgnA6uOli0lSIaSWPAWQ-1
X-Mimecast-MFC-AGG-ID: PsLgnA6uOli0lSIaSWPAWQ_1763924314
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 17B8B180057A;
	Sun, 23 Nov 2025 18:58:34 +0000 (UTC)
Received: from fedora (unknown [10.44.32.8])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 048881956056;
	Sun, 23 Nov 2025 18:58:31 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun, 23 Nov 2025 19:58:33 +0100 (CET)
Date: Sun, 23 Nov 2025 19:58:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] ns: pad refcount
Message-ID: <aSNZVv6BZCZcRsgs@redhat.com>
References: <20251123063054.3502938-1-mjguzik@gmail.com>
 <20251123063054.3502938-3-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251123063054.3502938-3-mjguzik@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A1026A0004
X-Stat-Signature: rcoxj9te3jtckeag1syo3ky1zenm6wwf
X-Rspam-User: 
X-HE-Tag: 1763924319-441394
X-HE-Meta: U2FsdGVkX1/0UV9Ck5eH4tioSGCBIFbUO3DAzQwxX5nvPGk5foYcKWIhqEtb4K61nYeHXu9DVsikgCqhkfRqG5yAXcqI/2B/H85JVJUt3DPRq/pdBqWHgzCrN3+hgC0iVCjiWG4MWpFoI8qVQCu0yxC0v5xu2gxcfU8Pwlts4FLai885b1TwDKiFUj6Tsnd+b/qytovzHLwtMXbqC16GbnZ6SZBx9JbHhzc/g0AgdgN1yt+ZabXpiKNLAsFo7kl/hMVc353vX4PJ2bb5Bf1H8GzQQYctS+ymQB0MhzwQorfFgokig0blJ1juFdsWpGEXk7qcZCWGEw66rpvQZ8UbCqnt0v1fvntRWGke7duAczhujwCPdPbdHahzg2BS8rgJFHYsIJjMJtrnpcGS4GzChpi6UBvnPdAuvF3vmRvk6dIaVo6bpeg70v9fHlX6n6hexImsJUaZMligXdndSAHuvItla5n03EUKlmtfaWnozPpmX56yTyZ5tjUd0KpDCGeX76cVpr35w3j1+BVnor2HssvgooG3wXjZr06eru08l9NgEPPXZOwLMxcOFR6Vo5CSBuYSreURaUt+5BdQq8ti5Tb1sq3flt/xNUzkDpd4ARONRAmZIt1VxgpnFuAotLYI+EzZNiRgJ5Bc3BGAjbWY6Zj3mGaezDTIfsF8WJrPtbPoRPZ093BlhEcyhkae1al6oaj4L/OcTtrMSFnnSowrxQyCB3tbUqpsxuEg71tpX6jp2jHWUUo9MPSHqF5j0G2HZSPsWhqntEOcJbZIjlGtOK0b9iNAABhhvaZvI73/8pokoLSxg7jFYVr6mSasesnmQAyRgwihs7s7q47/eYooLmY16H5pV1DZdSTrqkpq/XwaVFyhV3H8783pnbVOD/mztliuMXy4hEHVGSwFlxOSwJ+MSNbgBP2IVSthNIt0+PG7nQpXpM2NHtu5BYzfA3a08FwSO6rjhD1iyTnhLN2
 uwWhSPkb
 XPc1VEhKMlO7jvTa0KFZzbOTzth42wtDqYoYb8ScTyEgyARAi1nDW5YY5JwF3RD+ielYVEIKYu18/5otlDVts1KUIGk2xQ2wHxC58te7//FbnLcNfz5+dpbrFuxFjHqsVKueFeNhI53lPgKm2rYfP4kbkX0FX3fXx+xfJBnsaCcrG/S1hmlNaCzLmZAao+TISr5iqsI8OGGl6tI3HNLKeqCtZOcXVqy3mxaMZ8GyJ7ccjNozTIacIU/Q5VdGM0bwb7/hn8RSYTNzFGio0XvsbC8zS6IMOHknIByw9P56PwSNl/IeQZ4kJoi5yHSCWWjBsYStAxzBYQwfIrdAZ1tXhiP0z0eD3kQ2hLDu8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/23, Mateusz Guzik wrote:
>
>  struct ns_common {
> +	struct {
> +		refcount_t __ns_ref; /* do not use directly */
> +	} ____cacheline_aligned_in_smp;

Cough... stupid question. Why not just

	refcount_t __ns_ref ____cacheline_aligned_in_smp;

? why do we need the anonymous struct?

Oleg.


