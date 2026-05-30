Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B60E2CD6E49
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 15:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FCAB6B0005; Sat, 30 May 2026 11:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD486B0088; Sat, 30 May 2026 11:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C32F6B008A; Sat, 30 May 2026 11:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 581CD6B0005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 11:01:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC2EBC1A05
	for <linux-mm@kvack.org>; Sat, 30 May 2026 15:01:01 +0000 (UTC)
X-FDA: 84824398722.21.70260AF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id B34A240012
	for <linux-mm@kvack.org>; Sat, 30 May 2026 15:00:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RXnVj0ou;
	spf=pass (imf12.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780153260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H8fnQtF47HERJ9HigsIpSUsCGTuehk1+/Ujtx+Jlp4s=;
	b=1w4z8I7cDwXEbUMeZCvfZXBxf6cjmmGMtTkPrRlB05GRaeQs7p0aC9XsVNASPt1qF/WNjm
	TtPhXinEliBMfEC/2z14/fCMRAn5BPng9n9jooxvaqcV94ZUVa/VyKaVFrDTiCBw0GG6bY
	1J4m040Ee6Il+OFkc6c5i21maQ8pwIU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RXnVj0ou;
	spf=pass (imf12.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780153260; a=rsa-sha256;
	cv=none;
	b=mGMG1U2TNHQbHal0hg/lS5Dr6Pc+fQ/U/2K/6PXEfmwZnXJDU7LBXO/ul/JScvz0KKafg+
	q9+JzLGQ7ixTYJL6B1K9ATlTJK8qiCRMVS1J7MaZu7SDFTXwA7S5U8MoYQ5H3S/kS0hLTy
	rv5EYyPH5gztNEEfUD3RAgQv1h8K+6s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780153259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H8fnQtF47HERJ9HigsIpSUsCGTuehk1+/Ujtx+Jlp4s=;
	b=RXnVj0outh/gRFQVGgUhOlYLaJa0XNfOS+ttJIE3vZCpeah5RRYnmcSIATml2fsSjs0+nG
	+u4DAjZmpyXMIjGvhx+OEnqVfMSjamA1jiUEscA+o9iB5yPIJIQD3A5eMYkr/cmqEMR3xz
	ajCGrleXnRaWi8o57ucLpkJydgEAXfw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-467-90j1EZ1XOvyJUAa90dWm5g-1; Sat,
 30 May 2026 11:00:53 -0400
X-MC-Unique: 90j1EZ1XOvyJUAa90dWm5g-1
X-Mimecast-MFC-AGG-ID: 90j1EZ1XOvyJUAa90dWm5g_1780153251
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D39218005B9;
	Sat, 30 May 2026 15:00:51 +0000 (UTC)
Received: from fedora (unknown [10.44.48.10])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 49E9F30001BB;
	Sat, 30 May 2026 15:00:48 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sat, 30 May 2026 17:00:50 +0200 (CEST)
Date: Sat, 30 May 2026 17:00:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>,
	Kees Cook <kees@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm_access: simplify the security checks
Message-ID: <ahr7hFGgGde82Ejz@redhat.com>
References: <ahrsfJE3NkKjShEX@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ahrsfJE3NkKjShEX@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: jcUdoEV7GokT_UbdFdzCL0nIIzWcu2CYf3TFiwJ7OLk_1780153251
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: xzgap7eb85b9sjunoxmb45ay4iuqyswz
X-Rspamd-Queue-Id: B34A240012
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780153259-946586
X-HE-Meta: U2FsdGVkX1+h+gyqivzNIk19npotTpOQIWYXL94QFXUqJG3LWIQjMZbWoqzVatOKmnUGjqvV3/paP24eLKKFExeywiGMKJa1Bqr8JNLHnZLIpNU6zNRYJ5x3Vcu7GN5L5vlfPUScmHNMGeybJyPVVQ9DURBjAgO9T3ez3z285f61dhYhA8ymp2iiDdufm54IHjvlR5XKchkGAd5G4Mc3pnWRsAmHVZCEWOfnSfa32P9r77Jq8jwxQGls7kqPVaXjPglRHd3W6lKYiphC+e/DB+z2+vkraT0oh9r6VzBD2rP2yBUjJK9IPE7XVvmJ+0ZT7c2k7duJ8Mnd3Uwd0f0LUsUNO99hNr5/OSPAw5pL7NzSRUJRQse4RDJtL2ELY3gRUirCoUoiSxVPEDShNScuVYXJgxooXzw1xDqP9+rkyqKS6vX0G9D1ZQLlgOu0liYDrXlpBdQvq4CRvw8EAuBI6/euR8trXoHi5S+X5YA2Yfw0v8DfbpbEPUeWCjrhUBnI/cI3S1w0U34sTgM0m3o+iu0eIG/ZBymYJ6sxJ3aTB8dQZY2xb333aGETevhwd4oU+SoK2NMGtAnrk9i15BCvxppRFoQfmQYKDMM5NjvthMhYqHIkyi5lH8rHyEEvKj2Qgf3yTiM4nmmLE7vdFNwsazzMRNil3UqnwDq91qbBB4S5S5lZHVjCol+YoxoM9L8P/3cigZK1MS3GzcslHBo6Uht7fBTU3bFiITllXNHq9Tzy9cZn19t1FkG+4iEUivb8pYheMztli2gItIr6DDNB38x58pqdcT0fd9iND5NCJm1DZTiiveUa0HVP8GZ/q2sPOK0ymOCAGHzE4C0OcxK9KVlXUKDodnRfbVErje/A0FWi+dRqjGvXmTXRzT0QHRUHWTpXmk6KNL7lkxqJWtwOpvNh2Kt4WdLjTEtaHz2z14T+QjKvrmcU+VezaHWv+ziQ90Iv5zRDYjF+eV6/LFY
 8O3ultuL
 wy2C7uhtcqkfVuuPlefQAsdS1xDuXY3m5na2wSJLP6ZVcOz09SepyT9arkZSDdHmh5fXsw6tkwHJPY/aLY80wRuJoBwqHMXDKHiUb4Kl6hnCv+nUSc1upvMXHSXwFXZEOFlbJLsRqN8RqjE0/FauTzQ5GNLREktBaDVYVZSeY3TKghu75PkWMZbU8Xd+xv++87belvYEcL1q93olsf2loAuDO8uy1kff8/8t6R4T0+LUsrW0GPeaf023IdgQfjV28ZtWRxnvy8elWwce5OZXzymtWZJC60yXIKCog3utlZz3HzOtT4pygr9RYI2fD63FRddZBva/gRYwEbZDGr1aKI1V7ce+Myi3Vt2kaPagZqwbehDrONWapR0j9fseGozDmRpNkERGEBN66ghRTlFcBkrqVrPcsTpfN9Jr81Pe16gIXB1SeJFK1crUwxb+F6ntmbqjfjXlBX+isxot2krGLMPsawTleabquSyLkXOj3nJ/CVoZNGu5ON8Q6MDfwoNt97UWR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/30, Oleg Nesterov wrote:
>
> 1. Shift the fast-path "mm == current->mm" check from may_access_mm()
>    to mm_access(), and do it locklessly.

Heh ;) sashiko has some concerns, see
https://sashiko.dev/#/patchset/ahrsfJE3NkKjShEX%40redhat.com

I still think this is fine, but I'll recheck tomorrow.

Oleg.


