Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9216C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB9E46B00A6; Wed,  1 Jul 2026 04:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6A936B00A8; Wed,  1 Jul 2026 04:46:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B58EE6B00A9; Wed,  1 Jul 2026 04:46:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A7B76B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:46:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D75D8CD36
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:46:45 +0000 (UTC)
X-FDA: 84939577170.06.02CB125
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id D82A3140005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:46:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AyQq6eyv;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782895603;
	b=icxZ6lU+r2yDLi1B1rOWLW8DvsRtQAFv28aeZjh8iuxUPr3iwvacnBQMQ9FfwrUc1BTHu0
	wUSYfoXM4M4OzpgvptAh1UMU6r6ONTMNLfN3GvCKMTlxOwP4d+GH3BxNZcBd3hP8iHZnC3
	A92bZANk8WRJ48B0bEj1I7zLzhHt+uc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782895603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2iRDmruNYnQRwyieHJfNSToIl/HN4MV26oNb/LK8qcs=;
	b=78Zit1qu3TSdCMz1ycW4x2fs3Mvcr+siA6lJ7+y+rX81TmWJs9O5wzqWvNKXX+OFoAy4zh
	YoxZxBfjqWJuLIc0EWGgQ1njd/bCUayUUY0e2blP7125PFYVx5vwXiMmtAGht8F/amq29P
	kyd6zSJLUHMNlM1N0LIgR0mB+vBTwCg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AyQq6eyv;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 702922364;
	Wed,  1 Jul 2026 01:46:37 -0700 (PDT)
Received: from [10.57.81.2] (unknown [10.57.81.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DBAED3F85F;
	Wed,  1 Jul 2026 01:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782895601; bh=uR4IHTNg4iqIgPvoJ4nECT0AvoZlomJhg30Tk7S7lxM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AyQq6eyvCbr55bey4JrYXd7bdx5h55iKv0uGyuKkHEPlNLR61k/zJc+fFeaGGgiEp
	 J4yK8xJfsQelgenGEh4U/exbVka8KRYBpp9l4luuQ1N4nXjSVa0hvZJJCyp4AWlTu4
	 D09zykboYIrTeeJa/+9nUy6dF2XmEFFdk4yaqb/M=
Message-ID: <63a70282-0d9d-489b-ae70-436901e6bf70@arm.com>
Date: Wed, 1 Jul 2026 10:46:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/5] selftests/mm: move pkey selftest helpers to
 pkey_util.c
To: Hongfu Li <lihongfu@kylinos.cn>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, keith.lucas@oracle.com, maddy@linux.ibm.com,
 usama.anjum@collabora.com, yury.khrustalev@arm.com, jhubbard@nvidia.com,
 joey.gouly@arm.com, zwisler@google.com, hongfu.li@linux.dev
References: <20260630073235.3802271-1-lihongfu@kylinos.cn>
 <20260630073235.3802271-2-lihongfu@kylinos.cn>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260630073235.3802271-2-lihongfu@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: qcbpm7xg6dnsrz9cmujqk87umxpytoh6
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D82A3140005
X-HE-Tag: 1782895602-127853
X-HE-Meta: U2FsdGVkX19+hescEASVypUxcqC4DwdFI8WvOGxz2jJQJGLMC1uQZ4y863q3tOC9jKoHOnrIf7VYMlmVMR52LD4Jcfh1GUBK5ZvxLIsubhlHFcXpJGO7GRPUmes5SvPXcZHuWmLzzTn2Qh7pUlPaMWSeTAOIfjXd6FF0+Bhv6t7p5T97vd82cYDQosuEW9AQoKWtMoWVLnqE4ARjVQhfkfjDZFuiJEQgnFmfNa5PSQdP7TWZ5XOlP3VlLYBWSCdBrqHMCm0Bgq9nSk8FV0x+hqYeb4PKvRXpOKbsUvpJ4q048h4byri1eHzU+EJDQ3vDZgk6JK6d3a7d2R8uutv07fDN+6D6h5cOLfvarnNPjVeOKN2X9a2/4NdcSEm+LXoTESFyOoo/9aR+tlprxvw+D18iQjyb5SRyKdkq7vWEws8OjXqNRvsvvs3daaRtHZUmklftwFP3g4TXBW4jIO29sth0fxnAP3+O/nec3QmiBM4b4mx27uKy2HaGCcDGKm8yqIYWc8hg/BRKdEHqtxJs/NihOypbDLZyCdvV+wAOgonmSf8KnhQbvhyJkSPin8bmtfLmegfzP+DreiKE0lR4RVn5Eq9BENICzj7lsB7U6deKf3sJeMGqClQfZ4S8RKkDURE89UPb8ZnCloggBd0UJfnJPQjlAQEoSfKx3pVggV9gte6//BgZc2ygExT6nKwAtiHQaA27MC13bCyfGqmtxOVtDIgvq1u0qNL12OXJfOa7eaj2U00Za44X0YOhMmI6YClG2aAnyBOCZnaGzZjZ4Ggwn+m4rRmW83dJ0uKt09xAm5I8JjZUDtNsCCom9igKzpZs4ka4gmdFmk8N2kf78+ec4RVg7PDirsAoI9T6YawogbM0YgWluxXDJWSA/S78BlsNGQLG7AHqj2X6pnkTqaUQQAD4pCMVhA5Vt0B8ZaCfg6ZfNg9ZiLGf78pSB3lVxt8BXx0M6UWUkB5DY1t
 ZrTW/VQY
 KHrfUkU/fd64i8cmaIs2A0Jxlr6/F1dxBpDRb3tQoqprmpI0AE/4mezChO01SHQueftMKlKO45X/k+20jw8TAaCDI2eihoFs66yOvmn0srK8x0ooVVmQeRLzK2nDUAw40a6jjdICTc8mwMq6YjWeAwYnkw8ffl2gHR9aHsJHOpgs3eU06HFixX70qtd6PkS1ojKdYG3Fn8n3jUqan8Cd5eQkoIHVu1fu8W9qeipIrYjmXfzSPT4KISwzi+5X6SOpS6stlbu/bjF+YQoeLD2I0KSu3qKLbSGF9sLdZYfD3hbvNBjuUCPH6NktEEK9xgIbGPLRFv40MxKPy9WG5J7f2uoKA0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/06/2026 09:32, Hongfu Li wrote:
> [...]
>
> diff --git a/tools/testing/selftests/mm/pkey_util.c b/tools/testing/selftests/mm/pkey_util.c
> index 255b332f7a08..abf708d6575e 100644
> --- a/tools/testing/selftests/mm/pkey_util.c
> +++ b/tools/testing/selftests/mm/pkey_util.c
>
> [...]
>
> +void abort_hooks(void)
> +{
> +	fflush(stdout);
> +	fprintf(stderr, "running %s()...\n", __func__);
> +	tracing_off();
> +#ifdef SLEEP_ON_ABORT
> +	sleep(SLEEP_ON_ABORT);
> +#endif
> +}

Definitely an improvement to move this to pkey_util.c. We still have
multiple functions declared in pkey-helpers.h and defined in
protection_keys.c (which clearly doesn't make sense), but this is a step
in the right direction.

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

