Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A479ECDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 08:50:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896A36B0088; Mon, 22 Jun 2026 04:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8481B6B008A; Mon, 22 Jun 2026 04:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7374C6B008C; Mon, 22 Jun 2026 04:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47E8F6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:50:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CAA981C55A1
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:50:54 +0000 (UTC)
X-FDA: 84906928428.04.6509222
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0D6B4A000B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:50:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GWw9k3M6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3avc4agkKCJUIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3avc4agkKCJUIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782118253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hYK5Qpvd9EY88WoCrO0RzLvyGBW/Zs8Pl1ZmnAQD11Q=;
	b=ZvpZrYx9YHYs8mlXomEp3jAVQ7a06QhJseSy9lu/9GtRh3vQKU0PADKNgHJWKLVi4Ly7Zo
	j7XNB77bwVYfF54DHD685u0Xtw0k00kt1eRuRmNDE5/2uGH8FuJCE+Fu+d23zQDvTnZvQP
	8qU8pRGUSJeECKO89y2a0wEqvlCObpc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GWw9k3M6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3avc4agkKCJUIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3avc4agkKCJUIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782118253;
	b=64Vv7sc4KFdiHMbABe6mr5Xl//ll//f/VP+CPL+RD0ivziNFcCQVdqWxVn+EAxCmDKSi18
	u4GLlUqDNgRwOP4z74HXZf8DFSWsj7R32xCgHYjdsuk8hdkxBy+Ut1kc1UrU5h49spktFC
	gEE8clYh3ZEheqNgaY7XcCCwrUvLZns=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c0bd2bf3ecfso215224266b.2
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 01:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782118251; x=1782723051; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hYK5Qpvd9EY88WoCrO0RzLvyGBW/Zs8Pl1ZmnAQD11Q=;
        b=GWw9k3M6vLIRCkIhrVXhpwTXI7GrMXmwQGI12N0lqv0TIRBTkKDbdtHQng0SuMVtTx
         A+g0nBA4JoTv4rG/6Ku2fqd627b2aYL+FEsWcLDY1YS9yFwWaOtz9+xXN23nK8pyfpzP
         EKXm6p6RQNlED1LXzdkbXyKf5V4ZV8UkS72LagZnVyIQOzVi1+tAjJvURXoFkuCEdVE+
         Oq/4qjI/EEot2spXtRtB46y4NaEQtau6T4wsrCw049ABv+t0FKTXKIjQKL5228+D+hGT
         YhrKv4tXmX1xXUYsjAPEOw13sOOaDX1bzP2iCD6dUqdmZ6Fyf2zRCMKf7u5UaPqBkQ+f
         cGFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782118251; x=1782723051;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hYK5Qpvd9EY88WoCrO0RzLvyGBW/Zs8Pl1ZmnAQD11Q=;
        b=R0UDUW62EIGXlmDKNLabIOzqWekoN6+ibvdk0TQfJACjAnpGzBmvXxRXl3FOWtdGXu
         eDwhsnYv30/B5k5o48G1aVJNTIbW9IYhNXO68kH51k9xxaJAV4xr5Bz4swfdZ0EYrgTV
         hxD0tsnedPSs5ZgwHcS4x2AADSl7rUZv23AUlogAouYhIhToDXDOnmvQRhhOMO7DrgMV
         aRV880rdCtoXv9E/wLiUrAAB8gift41xiMFtb1Gbw7Cp6wpIlPMCsIAHQVSkVixJIZZW
         qRQohYwlYYDncfaUNdYagbZQxMNfuKtONjmRwa8KglW7znpKmzGNjFfcC/E3wOnBXrNw
         kXzQ==
X-Forwarded-Encrypted: i=1; AFNElJ+tFs40UcRf5g7zwSq4cDUX0GLh+naKknB9TERU8RBDyOnL1mQkhro/GgzHw90QYrIsUKw1vIgQAA==@kvack.org
X-Gm-Message-State: AOJu0YybQf6th2Sglk0hXxDLlnm+9xhkkTTGfcWBAhaNi89svqu2KJ14
	DKfYMLjpgr5QGu4UDoOqgQDlmz+1afb38/5EjYp6w2ar0wKoaQSStlqpoGkDoDivUF0IaZUyPMX
	4DD+2A9Sk6cieSYbhvQ==
X-Received: from edtg14.prod.google.com ([2002:aa7:c84e:0:b0:695:b06e:adc4])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3d4e:b0:c08:df94:69d8 with SMTP id a640c23a62f3a-c0b601ea81fmr594723366b.1.1782118250865;
 Mon, 22 Jun 2026 01:50:50 -0700 (PDT)
Date: Mon, 22 Jun 2026 08:50:49 +0000
In-Reply-To: <2vxzmrwqoc17.fsf@kernel.org>
Mime-Version: 1.0
References: <cover.1781615759.git.tarunsahu@google.com> <9huzv7beloza.fsf@tarunix.c.googlers.com>
 <2vxzmrwqoc17.fsf@kernel.org>
Message-ID: <9huzcxxj3qmu.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v2 0/2] luo: migrate serialized_data to type-safe KHO pointers
From: tarunsahu@google.com
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0D6B4A000B
X-Stat-Signature: hsyr91ohopodfdodr34efacyci8hzira
X-Rspam-User: 
X-HE-Tag: 1782118252-182938
X-HE-Meta: U2FsdGVkX1/EuzzkgJDFRmi8ba2EbBntzKwiehHZBC9/gXP05ksb9/LMCauF4/t063NRKBU3sYWWhCizdbpV636QGpeJvKUbmIyJiax87SAsIlKzjzfTbugDr+0yyW/M0OLXpEf/LCCE8PWNy2tCMtc9y0KRsGJXlVpJgj9Xx8F53l+gSJ2/HHNm4UBdUN2yjFjJOZyFBjE5jhBnyTit/qBRXlosaxKLYSYubnzmFz383w+3TbsCV7n90Y3EOdv48fE7/B9zjCKbw7wiBkEUAoYBmIx28fGd1cNLr+nyg07U78KikKE1KP4K7Q+RSL+7SQG7tI7w0A+/e1iZYBVqkQqAWOj3BKq+9BuMwJNUpifWxcmDqq2m8+vw3Kls+Jv2zEivXbfiAriKDsDk1nOvKQwVNR1d2xO7YzU3GP1XblkifHrVFIsAuNsJ4XkSmR64QraHW2PvbXYfV++zwcfjzdHgadGfk/wjRq0XRNose1wOksfNi2ZSyWSTcKcH2aCOcZVUCX7quk0APTbG8lphrGAi50X8wr3XbVo/se7APElBMK6YZdRZ+XgBfVQea8h+X5wuwfLf80hUEONlNAKGaOvz1LgJhLcirdqkmLTUp0iGWOQ8j9zIuHGRx3eRzsbLzb6DVtrVuWpQornCOPlF95Xn6KR3HsevM6MMrbKdDS8apYlEIENuEaj6gA5DNbT6hnAAyIUATv2P6ltze+5Sb6Ob71+w9CkzCqygGnH80XDo8vb+fo3oeSSVp+ZdHUq1OiG4sdREd4ZyPxrJj+Kyo8smaHytVbh9Ru5DJfTfHvJ12qmNwhTcH3n5g/1LWPdrxv3t1qkJ6ByMB0Zy45QwWRhO2mO2mPYWeMGF/axozzZjrUxd5RUxwBm1bEjnbjrJ/iE4a7uiqJN9uySfK51TpIOTQ8IHQ6KIvx120qFsOPdUKUCgoLWb9CmyJLV9Iq71YXWHxexX/+SLD/h5jBI
 CRESmF7T
 bMG2zhwzhXbhsgOo5x8y00tVT0uFxgxNj/dLi/G4xGgG3EKnqb1Zul7SzOzK5L3MNq8uld+taDJXkBWXN8mtscX4oVwPC+LBZXwyUOjaB44RQQTY7dFhzOn/7CX2/20glAWAVV3EQiWMrzxE7KNJJBFAbuMnwniX+Lqqj+RR8vRlP2WnNMmvBVcQbRkxsWaLDrJfdGRP71Tj0GLdcOuU6hpkiLbDL+vlrP2URIPedfYZzea6PrSC7nyQrRJD5h0KxzZFJfEm24zeoXVyOKDTqqVrGWWlK6SIFgdnJD3xTVTm5yQNJq89Y5C2jWSl38uZIpBT0atxEE8w+4VdSWcwuaEydnOedQjeiz/WkEkvIuLhBCkmnFSVQYa7wSEiEBXAmSkArxKOlNLhHLJ6+9/+XPTlHUBjwTS9r3DYVsmm/ZKVYFBNTAZCCVDFbLUdFErqt1y+WD2NNfzy3L+vhnX5+M0lxPI5wk3INH1pEtFhEQ2MZUh/skIMMAShGUEMecNohHIUKb9OciKJnbhwbSRH1mXCzTa1H1/jerFHoSD49pUuHtJUyDWoMevaixozKH+co/ufFQosxDYtY7aGqcfXv2vLOknem3Z2QXRMsd99k3uVELhtMYN2cStFB0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pratyush Yadav <pratyush@kernel.org> writes:

> On Fri, Jun 19 2026, tarunsahu@google.com wrote:
>
>> +Mike, +Pasha
>>
>> This is currently rebased on top of mailine, also can be applied to
>> liveupdate/fixes with no conflict. I would like to know which release
>> cycle we are targeting for this, so That I can rebase it accordingly?
>>
>> As for liveupdate/next, it needs some conlfict resolution.
>
> Base it on liveupdate/next after the merge window. Since nothing is
> actively broken (as far as I can tell), I don't think we should take it
> via fixes. We should do it via the 7.3 merge window.

This is gonna be used in guest_memfd preservation as well. Next version
(V3) Should be based on top of it. And if we delay this (as it is gonna
be with liveupdate/next) it will delay the review cycle of guest_memfd
as well.

~Tarun
>
>>
>> Tarun Sahu <tarunsahu@google.com> writes:
>>
>>> Covvert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).
>>> This series also takes care of resolving the bug with memfd of using
>>> phys_to_virt before checking the args->serialized_data value.
> [...]
>
> -- 
> Regards,
> Pratyush Yadav

