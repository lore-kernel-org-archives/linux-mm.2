Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 682ABCD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:42:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD9536B038D; Mon,  1 Jun 2026 08:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0416B038F; Mon,  1 Jun 2026 08:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AED966B0390; Mon,  1 Jun 2026 08:42:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9DC9B6B038D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:42:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4314FC22BD
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:42:45 +0000 (UTC)
X-FDA: 84831307890.24.A033108
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2DAAE40011
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:42:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E7mtZrFp;
	spf=pass (imf27.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780317763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Hwq13SDbpVOpqhNfmfrEwK4V0aUm9u8GnF85w9/4CA=;
	b=pVQ8xc+Dj5KX+tiryId569ae6MQNSWHJA9ZdsPVkIRf8gYuZd+xmlnbBqJnFUCvhJ49ay+
	8TByhGznBQqzOdv542Hn2IKHH1sosPjvYhgBVAcrOs7K8dVsCAGG/YKsNKYSJdx2Zedwq8
	l+w82zrdtHEPwrCH5AWPTLpUL8yf6PA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E7mtZrFp;
	spf=pass (imf27.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780317763; a=rsa-sha256;
	cv=none;
	b=sXm+/FVdUImWwCfSt+mJwlx7NeUEZQTTh71j/RtYQdECr5Ct4FLHMxJ90rdMpTTarO5YIX
	H2QAKpd+XIWOxx3UifcQ/HVmWH5c5u/jYtFPaU2eRhLKjGioWr5i8Q7EkGQCodfZsF0eX1
	0WSf6IMpaijArmzUsyjZsUPCgCYx0tM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780317762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6Hwq13SDbpVOpqhNfmfrEwK4V0aUm9u8GnF85w9/4CA=;
	b=E7mtZrFpw1z0/0FT2eQPFbUf6kwEUZCshcbR8rTFpVjjNcCRn0RDeQB9BDlnw+ww/8b6tH
	WPKO5yg/nVfX8xXSJ0HbIm8nOWyanXDySCVDq0tInFkMtZQXnGKVu2Nyndg1gDBhhPrdtj
	AXNx0jXp07BiUY8qKKTgXco1uUliNBM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-82-Bn2Cp5duPQGMUbXlL13P2Q-1; Mon,
 01 Jun 2026 08:42:37 -0400
X-MC-Unique: Bn2Cp5duPQGMUbXlL13P2Q-1
X-Mimecast-MFC-AGG-ID: Bn2Cp5duPQGMUbXlL13P2Q_1780317755
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 74EEE18002D0;
	Mon,  1 Jun 2026 12:42:35 +0000 (UTC)
Received: from fedora (unknown [10.44.48.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id D5D1A19560A2;
	Mon,  1 Jun 2026 12:42:31 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon,  1 Jun 2026 14:42:35 +0200 (CEST)
Date: Mon, 1 Jun 2026 14:42:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>,
	Kees Cook <kees@kernel.org>, Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH v2] mm_access: simplify the security checks
Message-ID: <ah1-NmlbYsdH3hJp@redhat.com>
References: <ahrsfJE3NkKjShEX@redhat.com>
 <ahrwUGytgulEwujN@redhat.com>
 <ah1qeNkatqx_N93-@lucifer>
MIME-Version: 1.0
In-Reply-To: <ah1qeNkatqx_N93-@lucifer>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: JOqYNCn87LMWN77_b1d90NCpevXbmIShYFrUgIcQrVw_1780317755
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: hey3hjraoxoxryuj6bug8mhn63hh4rgb
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2DAAE40011
X-HE-Tag: 1780317762-722965
X-HE-Meta: U2FsdGVkX1+Ehmon1KypAFfTcHxTdyZIlRta512o8+Kti6Jh2Y5nNTsnzWpK09DKG7i5lbLFyGCcIkg5rat9rO5nz4/hbOxyDjkkSlczVAbCtjLyBclLGX7jRKJXQv8qtjfVANa5KB7KkFo+XzWUP6Gtj/YCXVvbhx0JQ2yMM4bLzJePVHwqeK7VC+eleAmY0ucTWbjVGEpvkVibDZhBIpDT6YZlH7ze/iUP5zgiix8vVK/IzvIFEiZr/UOfAhNFNti8+lMgd7gCdB+Vpr7V0EOfFNt2xSldIFfcheCvnoIpEk8tj5JCsu2nkWFpEKgHMP+VGgm2/v+cufByfT0C2xDHNmHqukDPJWNeJzJtmHjw5BBTKLjst8G57Qwc9UtbWe7R3esJhH0BEDiitYGhWjfXl/LFTefBAW1zSA7TFWcaUs+THU8lnqEwx7NVCYL3vmH5E9Sj7SLtoTjP8jjX0Kkd7NE315DckO6D6D/kYoTzgTiZw27K2JQrykmHe+D8+s/N3+AUpOLe8SS2zwEPC99O+yuHCRjRTVvgPSP5YS0x0Euud64+bEvYVsNOFHlmGWXSTMFuoU6wJmSHuhUx6qCwoRoqV1mS15fs3PZ9xe8mWCZ6DIQP27gR4nPF4uA+KraDlhph8Iq64rzQPfL6Zdpt+k2jIvdrFcpxly7CoJjhfciVWxCdRRCWg8M+qSN3cgq5GkwdxJv1rVyc+5dbgA/EeYPyFOZbMC95HzFgvC6JDfsGmvnwZJgpsWg8RXV2EM1uAt2klb6rK8uKzf/Ak58VaH+xXYEYNtCIKrF2C4V6USvlYpPXVmmpGuK633ctybDHNpc1MNXbZfEv0XGz6nXq9SI8osY9YURySsty/BIR4evsr90gKmd7wwMMhUdd7iEONAD3KeGWNXfiUu6JnLlJxROwvZ/Vur1IiJhCo50RW+bduHeXantBjwEChqlIICiR/G3TtasgF2Xj+3P
 LMtVzIyt
 4iEMFXNddTUXa2MlhGjoroh5l2qSSK+lbkf6bY9xLOxP43tmupFaovwDg1ZZeQFK+SNRdkZbRh0wCdJsu2Gs06xPipNLALydrOhd/iHi2z3aFzDXBYZzGLoadQAcrh1e/24pYSWmO0xnib2PxHfBVv5mwmMBA3hNthQenGwuBqp6Yj7p1sZXjDzTNo+9L+AjEIgfeIUUQjF+oVJS9ZeAF3grQ90OExQ6Bc5RDh1teInQrUcEz8oL+MeWtbM+jAEihXQy+9mZusuMoZrGkHaGs5wUi7Qq2tZSEg9NfMJt2rd+7SSCdPj7lW8zruoeQVRptvW64WWRhH+TV+kkC0n4g160j/cL+ad1Vk8tBDGH19bWOHu9wfUEZiRd9tLOv6VbiMCZDFTwFywFJYLtmAaY6uzwMqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/01, Lorenzo Stoakes wrote:
>
> +cc Liam for mm lifecycle stuff :)
>
> The subject here seems not quite right - you're adding complexity here in that
> now there's a racey fast path.

OK. See my reply to David. If it doesn't look like a simplification -
lets forget this patch ;)

> One behavioural change here though is that down_read_killable() was used
> previously, so such a situation would return -EINTR, but now would instead
> succeed.

I don't really follow... SIGKILL from de_thread() or anything else can
come right after down_read_killable().

> >    All we need for correctness is READ_ONCE() to ensure the compiler
> >    won't reload task->mm. This is not enough for KCSAN, but we already
>
> I'm not sure 'this is not enough for KCSAN' is really reassuring :)

If I understand correctly KCSAN will complain if (say) we race with the
exiting task which does current->mm = NULL without WRITE_ONCE in exit_mm().

> It's useful to put a revision history (ideally with links to prior revisions)
> below the --- line to explain how vN differs from v(N-1).

Yes... I didn't do it this time because V2 doesn't differ from V1, I just removed
the duplicated paragraph from the changelog.

> Overall I'm not really convinced about this patch - this isn't simplifying
> things, it's introducing subtle assumptions and I don't really see the
> benefit?

Thanks for review! lets forget this patch then.

Oleg.


