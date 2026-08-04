Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D769C561E6
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 21:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62E7E6B00CF; Tue,  4 Aug 2026 17:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DF696B00D3; Tue,  4 Aug 2026 17:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F4A66B00D5; Tue,  4 Aug 2026 17:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 308C96B00CF
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:08:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6175C02D7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:08:58 +0000 (UTC)
X-FDA: 85064826756.12.1DFDD7B
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf17.hostedemail.com (Postfix) with ESMTP id 17C5D40009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:08:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aghz9Evy;
	spf=pass (imf17.hostedemail.com: domain of 351RyagYKCLQmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=351RyagYKCLQmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785877737;
	b=EL7erj+vnOWZodpdYtuT4wIuDn9ilDdX/jYa3vobmOr4QfZfKnMq0awPMCxOhKoyxFDuBl
	H3VrNlL5mLi/Timi68J3Dq2AzlMeVaLg7MqN0kLqBl4lFLyCm0+Wjp81DSpnvEj8qFojMI
	LW+wkDyLvLgNLpONe4sdeLh0vAfJ6QQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aghz9Evy;
	spf=pass (imf17.hostedemail.com: domain of 351RyagYKCLQmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=351RyagYKCLQmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785877737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nz3aCp4Uyw3qY+MX7Sv/bu2ByRkx6w/quCe3kJ8ANw0=;
	b=VAepN5QOXem7pAKL7DEocC5QItrSmAednbKyS8Sco4Y1mpxRWTVqGsDw7YkP4eq+3nudRE
	q1+spMjyn7KdAYs+TTEpLBs9eMBlwKv6hj+an337wQmit1yS0hzOPIsZlGHcKEc/iLlIin
	aAo3caQ8LaX6wDz7e3qrlqLb4SAFg3o=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38dc085b0a7so337963a91.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 14:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785877736; x=1786482536; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nz3aCp4Uyw3qY+MX7Sv/bu2ByRkx6w/quCe3kJ8ANw0=;
        b=aghz9Evyi9zTgX4rej9OyoF84pBtkD3RuIhsFQAyj6VnAQFkosrra8T1QGiB4N7Pat
         6EDMoxkiY7IPzp29KuOdbqsmfOGUR1Kl4yj4mZR2LtGvW7qN496TUtAcBfkTw9dZHVOI
         uTRx7lORXKr5kFqjFGKwqLPVQ6qClI2IfdvEX56HlYN455byKqhpn/4z/aDdubB9wCkc
         uj5yXd7pDpmgovalfFck7UoZJpedBsGTJYAZK61WfxOmnM5wRFCeccacLaE4CsF/joHE
         Rjdok8cunbqsufBQYTWfcgqMPXKB/N18FurZsM+XlueZSKu1B1DovGZUY/JgH1BBFr3+
         gdug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785877736; x=1786482536;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nz3aCp4Uyw3qY+MX7Sv/bu2ByRkx6w/quCe3kJ8ANw0=;
        b=JLtwTuZhXcnluADy9tWOycm+2hzKh6+TeHJ8FKKLulW/3fvxEOScU4SwmPkp89El3j
         Y+rEluEx4Az2J8/PExpC4Q2gFVYijATfV0MaIOpRZ99+UbMM2NRAcz3M3TcrS9tXeigi
         GcwVbUEo4CJKrTFk9JnjBx0NYJunh4oVoZEQ3wjRm87u+Hujp4xhygdWAu/FNrGvnrdW
         aCzI90sPCitSJ3voMy9K4vcE4kC29rUc5NG/imI2X2Wklu38MEzWaq0a53icUJTo0nBO
         737L0uvQmXl0MOOhw4ufifcXoxN1RRZER9kUjdmKlvemfn63ChHNcdxU0FwRHF/GtQz7
         /GNQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr+KKMq9NNT/elRAtmlVr+htOms2nwvHinApQwxtgB+wBF/nCznOzFKRCmbXhzG5OdgNi4pq+I9mw==@kvack.org
X-Gm-Message-State: AOJu0YzF7vTAD+4BlFr3tfy1XEn4GaAvzZ8eXVPjD7xN+zKirNR3qPDQ
	tY9xC2SO5+h7/Rnq1v0Iepx621eJ4x7GreGx8cEEexN7vY0x+Kdxm9IUoa/eH+onsUaHrnQdvqC
	niKh7Sg==
X-Received: from pjsa12.prod.google.com ([2002:a17:90a:be0c:b0:38f:e6f2:5944])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d644:b0:38e:2860:253f
 with SMTP id 98e67ed59e1d1-3903c582511mr1841710a91.12.1785877735649; Tue, 04
 Aug 2026 14:08:55 -0700 (PDT)
Date: Tue, 4 Aug 2026 14:08:55 -0700
In-Reply-To: <20260804120529.1730187-7-pbonzini@redhat.com>
Mime-Version: 1.0
References: <20260804120529.1730187-1-pbonzini@redhat.com> <20260804120529.1730187-7-pbonzini@redhat.com>
Message-ID: <anJU5-5xi3bcW0jf@google.com>
Subject: Re: [PATCH v2 6/6] kvm: return -EFAULT for writes to !VM_WRITE IO mappings
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Alex Williamson <alex@shazbot.org>, bcm-kernel-feedback-list@broadcom.com, 
	Boris Brezillon <boris.brezillon@collabora.com>, Christian Koenig <christian.koenig@amd.com>, 
	David Hildenbrand <david@kernel.org>, dri-devel@lists.freedesktop.org, 
	Fei Li <fei1.li@intel.com>, Huang Rui <ray.huang@amd.com>, linux-mm@kvack.org, 
	linux-s390@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>, 
	Sergio Lopez <slp@redhat.com>, Thomas Zimmermann <tzimmermann@suse.de>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 17C5D40009
X-Stat-Signature: j15z73aa1fcphuzsw7514t3prposo4gn
X-Rspam-User: 
X-HE-Tag: 1785877736-585732
X-HE-Meta: U2FsdGVkX19TumNT7RxUXJzfvnC7LL2iMsPZxafgwFT7f0lyzp6SCMJlmQ2d78c+EGts76gKzcATjBw0vew/8DoyMCxBfRgxYq9bQiaCGvmXnCKn9r58b23P8JIa+ffRwXbXwL8fGIvje4vkeqYFhnFRzMMAGjEPC5ZSgyVavuULCiyEDUfeMeikiXCf9rHTqD5pEvaTLVvZSgBv/oR9l1fW4FTsTfTxa7Lk2icmNnRrvu4Mjqu5rpb4wkoOVk+0GobeX4c037S7TUP4H+KPBg4T+brj1Lm5y/zAIpyBri4aB3Z7ISOXO1bh8Z5/7gC9eJw+oBIrOG+oa3e/H9SGjyflvhjQh5Ow5n1tVtmLoZQK9PgArrP2NWfjJ6J49JoHlKK7fECppIlMUhjmXAWtjI3aql9Ds4ZMfcYKKG7J7+oZkd8OJ8Lexpg+SaEs1PupQ1l/8Mb5eFf3bhqbfr/bJDegyBco5f0E6JMo9+B8KMpRFVEfh+XHRgFw3Qgt9XlLzuTJ5v84LU05yjpnHRGEjf6S7r2MfozRwW3VTDBQiKcnupdd1afXIaXJQLd0B/lqX4R7y3F0uXAo4XU1xTlrKwlwiAhghuC1OZju1FdVWW0vxbNeekLQZQ331wa3alABRCT/Dt6xGb9a5+QkFkSG7745nLLPGAXc8AAVTV+T1Jxe//MH5Qm3Dnh5/KjN6tKQi7zEEbD32Sr07PSGylziAzr+WQNKU65hrtAlIdjyVYJZvym7EB/Eu313E6Njen7UtHlhES6Z55863+PUMuRGLygXMWBRg1PH28ASsoXkdjVsnPhubEltAlgRZ03YqOhiqfnxdI+OtBU6FyKLu8N3cVskK+mVxFWyJhk97RhCasiZMIotfFoVf09U1kpm6DpH69w1ILtTVvPY7o+kLx7JP9yZKjRqTkLKI3k1kIGfWT80i6Dh0BkrZIvzrVU+0mYtvZG4KC4V7S8zuLO1wNE
 5uqgNmyN
 9b2fv8+JgXz1/gaVtlHV7dxnbKpr0vJbkkungBfczqYXUB3DMBjSRnVcyvkj3kwKLeDwsyE5y7CMYZ8V0FvypXviMuf2i/8gQDGvqlOXXHEQd9CUbfI9C0mHav75ZqkMoFP4JUjRjWSZoxxPiiU0oSJjPd7SjV96ByRGoql3mtn04M4U7x/qkDsOv2BR0qKoNDg3bvoGmwsdDOl7Z+/u2vQGvfA5YP2QEFpc64hL8y5amZQzEPXPgZDhuT1l7uen+f9kxMBSSZ5jBeT8WtHOrYWOlE3QU/WJruyCRfWg+R/UisKchnYxsKgelbXqoi3UBBTxfKX6C0QozlkTQoZu3u37SExUt4lvnn1BaFMTGACmEvmLFLYvjpGremcmDcysqRCP7qi2Utp1FGbfu0OZ24GDxg+6Lylr5julujFu/7Aea497s+YWLhUUsSdX/hD04RMxKn3vy4RtEbLKESwzVjBbcZ65P6M3DapEPg1oFwzrBJwog1giiy84hpWrxJ0GQGYxbGQpRNbMdtmeDHDqll29I9IyKFWsFl9cDb/oJrP3ZcU5QmQKsbv++qIYzLBm8oVKzGv0xDKG3KNzoiKBMd4u48YAKBZ71WAvuo8Y08lR3G5+L3kXcP+5if8ez8MyIRdhQoMYyXpsSwqmw9jaB+eddd/xN4H/3t23vbA7B7OIdnsh0RTBJZmhG10YDsI6Bup5NSvARg5qyVJeb8TI8/ye+fbT4/hBhdTeK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I strongly prefer "KVM:" for the scope, and it's waaay more common.

 $ git log --pretty=oneline --after 2015.01.01 | grep "kvm:" | wc -l
 1298
 $ git log --pretty=oneline --after 2015.01.01 | grep "KVM:" | wc -l
 16249

On Tue, Aug 04, 2026, Paolo Bonzini wrote:
> KVM's behavior when the guest writes to a non-writable VMA is inconsistent.
> For regular, page-backed mappings it returns KVM_PFN_ERR_FAULT and thus
> returns -EFAULT to userspace (which is ABI, and relied upon by tests);
> for VM_IO/VM_PFNMAP mappings instead it returns KVM_PFN_ERR_RO_FAULT
> and thus exits to userspace with KVM_EXIT_MMIO.
> 
> This behavior for VM_{IO,PFNMAP} was added by commit bd2fae8da794 ("KVM:
> do not assume PTE is writable after follow_pfn"), and even if it has been
> in place for five years it is unlikely that it is relied upon by userspace,
> since it is inconsistent with KVM itself.  Change hva_to_pfn() to return
> KVM_PFN_ERR_FAULT for all non-writable VMAs, and restrict KVM_EXIT_MMIO
> to the case of an explicitly read-only memslot.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Shortlog nit aside,

Reviewed-by: Sean Christopherson <seanjc@google.com>

