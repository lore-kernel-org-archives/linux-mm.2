Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B333CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787776B009D; Fri, 22 May 2026 11:09:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7117C6B009E; Fri, 22 May 2026 11:09:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9616B009F; Fri, 22 May 2026 11:09:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 49A076B009D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:09:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED6421A0A75
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:09:08 +0000 (UTC)
X-FDA: 84795388776.27.09AF1DB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id E6B98A000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:09:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e7AxP21A;
	spf=pass (imf25.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xlNmX1BV9MIxy/ZAF9lZVHt0Q/P020czO/vsZF3EvpY=;
	b=QKNvF4uBoFUKkvehXc6J9y+ZUdceaPtLLQt+yxyeroOVoqfBdWk9MRq0+hSbP7qtqhb+JA
	WKN10i2DNj0o+ythx8gcNjGYvYwGKrTCWdfeKmZJlF/lCLXBmkoEqFq4eRUT6A3WuwWzNV
	bArPZ5bJo8fo9Oa+umsnXNunqfOkSDI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462547; a=rsa-sha256;
	cv=none;
	b=ik4EpVxk297TtkTN5FexNOeugwWvYrpyOyWypG0I9EiKjvtotVfq0TRrFCsidRwQATTkZd
	i9un1EIBSOblR2rstcHmKb+mTyR8DPEPlAcbC9HqAYDI6+7nP2MjkaMPAIjlfUHocoVBk+
	PsbZO+xaLYPNVUIAOK8wZAC3UWrn7xY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e7AxP21A;
	spf=pass (imf25.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779462546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xlNmX1BV9MIxy/ZAF9lZVHt0Q/P020czO/vsZF3EvpY=;
	b=e7AxP21AXiin6EFZUoj+CVzyKBg3djqshgtGIFciHh3mFlq1sH/o2h5+JWNBLbCQyI/EoL
	UdBV/qOOjSMNic4u9tVGO4a0hIyqoOD3wBmDZ/uZo5OEGbyP+GNiPGMP0x38RYOhG3bV+x
	DjUYC+di4beVQRidT62TzybeWuW19EM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-99-XN9U4HBINX-4QYRGfZ1KxQ-1; Fri,
 22 May 2026 11:09:00 -0400
X-MC-Unique: XN9U4HBINX-4QYRGfZ1KxQ-1
X-Mimecast-MFC-AGG-ID: XN9U4HBINX-4QYRGfZ1KxQ_1779462538
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 254F11800283;
	Fri, 22 May 2026 15:08:58 +0000 (UTC)
Received: from fedora (unknown [10.44.48.45])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 020EA300019F;
	Fri, 22 May 2026 15:08:52 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri, 22 May 2026 17:08:57 +0200 (CEST)
Date: Fri, 22 May 2026 17:08:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Christian Brauner (Amutable)" <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Qualys Security Advisory <qsa@qualys.com>,
	Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>,
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH RFC v3 3/4] ptrace: add ptracer_access_allowed()
Message-ID: <ahBxg9mb5c0aVP8h@redhat.com>
References: <20260520-work-task_exec_state-v3-0-69f895bc1385@kernel.org>
 <20260520-work-task_exec_state-v3-3-69f895bc1385@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260520-work-task_exec_state-v3-3-69f895bc1385@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: e5czw5ZodV6rSaEBr9rJ3aOgmmwum0QCc18iKs7fuVs_1779462538
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Stat-Signature: 5xwqtgmkwo9abjyzboi411bay7btkifs
X-Rspamd-Queue-Id: E6B98A000B
X-Rspam-User: 
X-HE-Tag: 1779462546-847670
X-HE-Meta: U2FsdGVkX1/KLjQREa3TI/5YCDDgKYjON3brM3mCH80IHXlmJfYvKfnhHatCAc1F1gEA/zrfTjlDyCfroazPkHy3mOPkfKTP+bOhB3AKzbmmLaGGpZLRphf+2vzurGRMjjztkG/TcPdq2prAvMPgfsEYBd87yF4cOKRZPJ6QIuppBf0ijmxg3FZI+QCC/tamM3tbbuYT7xAyu069Ic/OhBnKHLKAs2E5wtP9VlnbSbktqkWFXhXEQgov3vIOIxAx9zcIYPWYf/Ub1rm2SQhJiS9DCxFnTuS8JWSocEFqA/eUSRyz0h4SPWicA9aK4DPGx2KR2XyQiPED93atHDhrZJosx2SOPXZ2iAlLcikgtjwNGY5UF3cf54I5N1W4W0GodhJUmo0osbvFkBy8YLYwyCzei8w0Mm5tCj1l72rBfrOyPbB4cho21KFfMehZRbdfwz4K1kUoYm/grbLfQcANKMDHEhlSbGqXIppQS1EQFPfHoUWi4a452dsWF1JGF4OSXZZXOKS6hVZLobLjjl84yB5P3tJxSMb/t1Urunsugvlgr39Id2DUSFFXMLv8yCVksA9YYTtV2cNTwbK4mM9q7/0784Q4b16QGH8PYJGn3z3+qBZK+ub0peHxS6oHXDLfRBg5nwQ/9IA4aVEC8Ngp5WY5e5D8lEtY/PpPwz8kjFwo4MWCnv1zv9TyW1eMADxKG+pcSAjL7F0F/OQPulziJDw0+VMyZs/L/5H6giifCtwCrqbgeb/nneQoZ7LrVqkWmftZIwTSux0KMisPkoOHSWqO1IFSr+TO+gcTylJJipHV7YmJbeAmooGf8RcXHV27uvbc+VpUD3623bng28XnZddxrx/8RyuVANUvzqdGis5Q2Dm1857bkGibyyAy492sPhH5DPyly6vW4+T0gDpOnTeHt6nXJGFzwr4RF7vjV67dICEwpiMV+e8bSLlLbUJP6ozPA0ySa4EOE4GqODz
 9FemAv7O
 XS4HtGEHvc02I6AE5yJ/fc+AL9xOjMrfb5FwwSzLJMtnPVHmdp6QdhXZ5ISR1q42hgddVGEheZQzVUBXBk4TVKZt1U0tu3oPZVZNgE1UMYozO87ZmgIT5zEm2bQfYAUbjUGTElPcaxezQBJ/VWTMq+37XpdG2NG3PpmaYzMe9V+90qli3P0cbKQMJt7x8MOnA+Y4qb5LysfA7yvq8OGPifoe+mYvmK979BK2+SYFuf9TMJcbv0HTxE7SWOPtOwNTjIuCLTrsVd/vXyYuDmIwSzjJMW/1hOPBX3ZuEREvsUndwAwwqRavY2nNp6eFrDPcCvCb0MxyF3oGSS66mHHLVJS0kCVt2B4YJHQ7qGPIv+lwov+oc5BKl9KecSDISpqo5BD9nHmo5nLKKRI/qyZsXYOldvmgRNX64ne8nCNKpuJbc2KY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/20, Christian Brauner (Amutable) wrote:
>
> +bool ptracer_access_allowed(struct task_struct *tsk)
> +{
> +	const struct task_exec_state *es;
> +
> +	if (!tsk->ptrace)
> +		return false;
> +	if (current != tsk->parent)
> +		return false;
> +	guard(rcu)();

Really minor nit feel, free to ignore...

	guard(rcu)();
	if (ptrace_parent(tsk) != current)
		return false;
	...



With or without this series, I don't really understand why ptrace_access_vm() needs
these security checks... And ptrace_parent(tsk) == current should be always true?

Oleg.


