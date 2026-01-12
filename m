Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48ECDC9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:27:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B02BD6B00B1; Mon, 12 Jan 2026 10:27:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE0BC6B00B3; Mon, 12 Jan 2026 10:27:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E2F86B00B5; Mon, 12 Jan 2026 10:27:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8977B6B00B1
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:27:15 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46F4E8BC24
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:27:15 +0000 (UTC)
X-FDA: 84323690430.23.6891641
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2ABE84000B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:27:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ZvFB2ND0;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768231633; a=rsa-sha256;
	cv=none;
	b=Eqy39krUwu7rpg57PI8zDxtOKRi8LLD56ua0higwxfOKwhdoBicmIF0oB1Kd5Jjq8iEat/
	8aH73PtEsq5E6SRfUZ0VuC+otCS373Olv+gQFrViQi6Cx2tcWXT6xJQ3es6yiQoQ/+wbnt
	5w/eP69LRqnHOZQwZ0VbnGcE/Xu8ZoA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ZvFB2ND0;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768231633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/KZrNpTOv53Hf6emFKpIDyGwi6CuZM71jTQ4Nu4PF2M=;
	b=3jnehrDL2/HhuZmnQEy+Fgt3EDm1P8gMMGbh2jmcbeJa7Ba1521PJEUgMp3IITlGLUZC42
	hykBpil+D4mlskQwoGjS54tU5OIdxjd6Q7vGPjOW34EtDhyQYN7Zwkrdwr+oEY77I/il4/
	YWVIcZMJJjhL8dFuOP1ch4hixptolr4=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8ba3ffd54dbso975957385a.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 07:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1768231632; x=1768836432; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/KZrNpTOv53Hf6emFKpIDyGwi6CuZM71jTQ4Nu4PF2M=;
        b=ZvFB2ND05D1/UotABpvhFtj7utoWlzjAWu7FgILd4YKkV5E/h+EXwignpEbHbu+sRF
         wgC9caPALwoOxou1DaaKLAzMdkFcoyiB6aNOgh5+T2gOoqfzmeexPVUB65XLnGgl5iyO
         4ufhGqaeLk3tE/W36FLcEKQF9OuJ6TIcQmAZKMHvilI1itOqxNf4m37D+9aMwDM7pZrP
         qoxHqeA6PgNuctJaeMI0V+1BAx4QcpC5c18OUyQS7a2N5Br8wFzKJxn/g5qwzJcZTgmm
         7MUm9gI3BFajnlH/i9eQ7M6PztdxjDd5k51z4MMkktFOuVgaYm3v0BO+Bg+ew0edwCAO
         d0kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768231632; x=1768836432;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/KZrNpTOv53Hf6emFKpIDyGwi6CuZM71jTQ4Nu4PF2M=;
        b=doG5I+scbHJ6sFbJZC2nJFX8FpsIq1ot93OyO0NKCpQ7FuC/tlQYt33tCxm5/gW3Uf
         U5LYzdTY61WJHwFBHCRYzq94Bq8wVXt6B5meHjRS3Q6BrknzKW8ClEwGkRxnDh9APcF0
         yvptrgZkkAA1lb6+XLALUvFH6A+ipLUyWwmEy0j5BryIXJBbXzR18bCjB68ybxSzqZJX
         PHR51u4zc4wnVd7Hag2cEIoPR8xRLTsV6SlMXyO+4B6ZZ5w7EGX2KUhEIdQQ4GXA0ZxO
         CYLecKI9dnDEM8lemYG06u7dP1o5trRX8+uDd0c+vZkiXJxpVxzP8zVZ+EOjlXOWAIYT
         32FQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGO6/UihmdjjQF7+qf/R2yVPsXrnDmoOSm4W5H4NSJzpKbgvSDO3j1DvqV+AAsIUfw/w/05Emb0w==@kvack.org
X-Gm-Message-State: AOJu0Yw4RG2IvdzyxCurejvfWUpAXPjw1+V7IYbRZW9bPV5NwGs+veOA
	qx2AXziGx52jPVzJ7PiBZO6DuG0M1KT2QDqKxuvnwdUJlsH2bZAChBJanw5Sy9BriGs=
X-Gm-Gg: AY/fxX5yQgKN4GLX+uuHJSs6GuHna2zCPni3va6V+ijEEdPXWe7q8FaJvdRA0iW1X1e
	62rWLVS0xvBcoSJfVkWnNPMEk6b0py06X+uRDUZ0O2q+XqOeQEmO8UCErODdbA5V8rmBs9bsPb8
	y4u54aUxvpCX25FEqVWsO11Nwc0dI9Cu0ZBCnnMkWhmH4u0fedB20tXWXVI86Y1HtxwiGOG9sv7
	olc/wawhWVWsrqtb3fO4RVf/fezHoif4169A5J2ZvNwzdrMMZpIdr0pfudKyueVicaF59A446x6
	Pqel6KTm2WaMsyliPVxeFQcUOEQuZmVR3LDgSMat3G5YqNJXUhgq0G7uGJydsHoaSVhVgSokD/t
	OR5+wSoowN8OM/oVNMq0/n92oac5rTlEyIxrIBlHt+nBfHbrFLjCpbAnbVSwfEn1kixDfWpgjjU
	facdTaiDBuQOnpE8EgdZl/
X-Google-Smtp-Source: AGHT+IEMJiA/1eid9s4j9DWQmqT6T/1kpjdK8HlfZHWC5kbrB6Xvn594oXzyY6TZwshoZ0nf0OGjPg==
X-Received: by 2002:a05:620a:7087:b0:8b2:f182:694e with SMTP id af79cd13be357-8c3893f4e8amr2476371785a.54.1768231632134;
        Mon, 12 Jan 2026 07:27:12 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f4a97fesm1512326085a.4.2026.01.12.07.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 07:27:11 -0800 (PST)
Date: Mon, 12 Jan 2026 10:27:07 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	syzbot+d97580a8cceb9b03c13e@syzkaller.appspotmail.com,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH] mm/swap_cgroup: fix kernel BUG in swap_cgroup_record
Message-ID: <aWUSyzHcaDwEg6_c@cmpxchg.org>
References: <20260110064613.606532-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260110064613.606532-1-kartikey406@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2ABE84000B
X-Stat-Signature: rfstn4aa4bkaycxsij49jk1wmw38o84g
X-Rspam-User: 
X-HE-Tag: 1768231632-217785
X-HE-Meta: U2FsdGVkX1/cWl5Hfq10/+UymH1gftwgHhkFrvdpCUNOKM+vJB8D3RWL/7bRPx78Y8Q0IJrkmVus7n5skchFyFHWovsiOyEZnNKFWBu/Nl3faNuXHGcvdiOrrrUl/ZSeTOa6jrIIBgFXMu6A/W/X+CVnAAwO5gpN/Yo3cxeEy09RQ1fWGsdz7Ujrm8yCXB+4Wes/yc4vDxfI9Ki8lrRMy3oNjmX3Ok3IhenBa086iq4ar1FI7CDCxzHqZmiep+WZsMt7cx0AD1l9hoMMJNrSIZtxD4w6MK24MHPKkH/Ls5uf6ZN+1NwbTErKFpDdghFwumSUZNViXf7ZfOAeAVCgahxzt6bWZebe+k26OQLwemOV2w1vG08wL0d/lZz+pX3EjmhPluNz3ySL1qetJMUtEVjxoQ3A1twQlgM3PYo042XqEvBPM17Srmy/qsf0qI+VPtu2WyHDEXGomTjAnGj4CP5igtSbUaAFZWxKS/mcLy3KYHoyKO3z81zHDR9CvFiZMODmV19u3JOlg0nW4Uvv13qX6crmxZ6ZoiX79T2QBY0oe9FQ4AYRjIkSh2YHphTt2HWkwKnPzh/PLLZM2SMdIMmcG5hRni05bgM3wCzX/uYs3xIF092cEmS7VdPlclCtFT+ZeqNgySlftc9l3Nq8ndyvex/I+/PO2hrBtDlTfcgybYqGo8vt+gEi2nmDF4TTvez0Fc/hEUk/VuyjeJBXQn75NlJcV/GRQsCSZHNjBnJgjdclh4IIDaTOqjnBOOiGmK6zlO8g7dOB9fxbnOrS4qL9ISQ+5TpWU1pbZDv/1jRIgegjEw7KgM2pkLX7RNMExMEmWzDFlhRFCF9RE5XNIqlq/bJlDfrD0UjpN00ivkijMKkznoY7Suj1pNtniY6wyu5xRD8NZzyxKXbWDytZ/HhCmp1eu1FsIbzN7Z+aLNl7Omvh5FFgg+cbBRSQS/rm8xsXrge8byfPIPq0io8
 tpOKmRSc
 CoVskoQEnjkdJ0LRS9hpaW0WbmU0M+f4ZA3I0FUCZISH3VsOe/HbGipGHcRPwse5uRGvskjbVqT+rtD6DYHVVMUj7eeb2vKrQLdxSUFYXtxFAIJwLFJS/uvQMDx7+4LTaG2yPiBBc9znXBBXb8j0vDylJsEkvmSs0QNzUEqhOJQ/FaoWyJgqZIGbBZc+2z1yo+srvr3ma3C1pm+Fc+bD/MM5/P272NOAx9lx78gmEqk7mz9JXuOtVwu0SqF2xR8bX5gsaKekDsWO4ldxmaVOtWsdg5pfzneO1YLhpbqzbvU4V841E/N+NvRM2D2oJzxBrgjEuDfDiAfo4JO/c9N55di05S5CIM0YAo7IYpafVmJMLDCQjZCF+S5F3K5LyPHuL/UiXd+aV59K09zPvH2ux8b3PEHM++cw2Mhyaw/ToVeqiFJKAtQMCk8zLYGvcTlTyi1BmMZ5OiCLIbyjLj9SXCyiapO5loSu8l9mV5TNh+2g2rvKB5j7zEp/CsauAcuPocmYHKCfsjDknfxhgI0/a7daTPatql/DdaHVtglU4jhETtp0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 10, 2026 at 12:16:13PM +0530, Deepanshu Kartikey wrote:
> When using MADV_PAGEOUT, pages can remain in swapcache with their swap
> entries assigned. If MADV_PAGEOUT is called again on these pages,

This doesn't add up to me - maybe I'm missing something.

memcg1_swapout() is called at the very end of reclaim, from
__remove_mapping(), which *removes the folio from swapcache*. At this
point the folio is exclusive to *that* thread - there are no more
present ptes that another madvise could even be acting on.

How could we reach here twice for the same swap entry?

It seems more likely that we're missing a swapin notification, fail to
clear the swap entry from the cgroup records, and then trip up when
the entry is recycled to a totally different page down the line. No?

