Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B09AAC79F8B
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 22:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28F816B009D; Sat,  5 Sep 2026 18:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25EE76B00A9; Sat,  5 Sep 2026 18:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19DD56B00AC; Sat,  5 Sep 2026 18:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E62C66B009D
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 18:37:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 575DC160427
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 22:37:08 +0000 (UTC)
X-FDA: 85181170536.04.0A9983C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 89B51140003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 22:37:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ONQUSt83;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788647826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MtjQ1ODtoXbhHRqrZLCBQGlLhKxmPKi8roy0XKYbjzA=;
	b=RioqRQr4rNunslsnsUMlMVVRXaac3+uGo5zZobx9/nDy1su/HjhFSukmLMyriG6i0b6pet
	Lk1QpfIWiMO4kueJP6GHokT59myZDkTTViLnAfxko/m4EVHzO5U3dFTnntA/s6H36Z6uhG
	JhEI5JyjY9XbS4wIo51RkZubbwhvKZE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788647826;
	b=19Lr9V/xSqMXJOjZHdvxv8A3SOuyktfE9L2IGK02THBIeOmsUcaEsHKuIhiKVA9lwo0p60
	B9yohB5PzuM/xFo5glSmovx2qH3RSEiF4phBixsNEMol+JXooO4UfBF4cEpa3Q7zP42doW
	2bGycwKwR8oBJfHAp0j5Kp5OdXVuQOU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ONQUSt83;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A58440499;
	Sat,  5 Sep 2026 22:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063021F00A3A;
	Sat,  5 Sep 2026 22:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788647825;
	bh=MtjQ1ODtoXbhHRqrZLCBQGlLhKxmPKi8roy0XKYbjzA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ONQUSt83ZZf7rEbmIESSsiSQY3xMN39a3j6xObv5wd/XdtB/jXcxKdMubi9fe5Yu1
	 h8udRMs5vsU70vf9oSVc5EGY3fc750jeT7FoRPmc/08YkG1aXEj4IL9INAk2HtbgVc
	 EQmH5KBU7pLDLRkQMyv5MGprvN0nAH+jY7ZC8M3k=
Date: Sat, 5 Sep 2026 15:37:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Baoquan He <bhe@redhat.com>, LKML
 <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, Dev Jain
 <dev.jain@arm.com>, Ye Liu <ye.liu@linux.dev>, lirongqing
 <lirongqing@baidu.com>
Subject: Re: [PATCH RESEND] mm/vmalloc: Use dedicated unbound workqueues for
 vmap drain
Message-Id: <20260905153704.e7fe650d0226c3e20c1c8449@linux-foundation.org>
In-Reply-To: <20260905152717.11711-1-urezki@gmail.com>
References: <20260905152717.11711-1-urezki@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 89B51140003
X-Stat-Signature: 4rjeupahfns1fxhu859k47s7y7dqypp1
X-HE-Tag: 1788647826-45094
X-HE-Meta: U2FsdGVkX1/mB3/9w2jFYjn0L2CS/0bAGawAJ9bMKh6vnFQN2AuiSFy6DSdwkXuSnOt7eId+pXH5Poj7qtFkaLNjycj7oK3K7RBHCGmS7uogI4NNJnjMzrJgIB4dAIXpr/Rb7XZX9XlMV7kXqHVuI6ESSpGfsVhVAF7iKTBNKXscA2gmbkZMaMA8+z333MUOfP8jk90NMsHpJ8/C3d1I64z4mRs4+tHU9NdW31+NYiZQyOS4C4xHZ1VoNrYgfEajsHEgUl2NXume4qHI2iTZ4Q6z8wAVzSVngKE5Lr+YGngboXfnp0QuRWSTxSZrIz8ZBeDsjeW3zh+AvmddyK1fNLQINolgvEmIqwQTh11tEz3TS8J035efn+secjwRnN+q8FGainm7FwZ6H0iW3brufDwGWOZXGxA53cSfKj6WCfMm+iEtCtM+QtBdLmdNndz6DadQwQ7+S5j3VcWA1+OXDWSs/ttwiwS+FyDZ5TUE2dQspH2R3sISBGNT0ig6pIq4jBq/unxDG+X0jD9YhuRNCzK1Tk2YVrdNrlmIzq9D3OHT+PJawR3SMccpyYEb3AwmMhIt20mfU7XFQnNXqz5QrcZaecd3KfTUptBT5FPPXuplpu0XwX2ZpeTI/M9u3O5UU7noRVXsECa8+caHmdv/4E8eACNU0TuKriPqpGXBzbkA7Zv+FrS51aDvmX9R92yj4FXwDvfTb1KsGdLWFCLHutRCqs+PNAaYIyPDSs+MBoFl8pq43WndG95IOydH09grsH3oz1royxFOkLZIuvDmhbMY89yC9ndqGcNXqYvDfE8V9vVxBX6k0oQJ0oe0a/UtF4Adw7IEspmYtGtj+OY48OdyVnJlsZ432sSa0NqTBWUYoafoMeGrIqWZIbDQLNiJnTlpFwvGemHX6PkT7iiB259tQSYMclfMugM7REH+761Y3YdHRXAxkphK5yQoPGyFs9k5Rki7VKQq/DT9VZx
 cFzWEc8g
 yO9g0O8DA2lhCntuFJGAocHncvqr8s+ExXlfWdjPK/mmSiNO9LCozcQT/Hgm0p36AmIysqeH9jtnf26p762F96auW9zqWjBc0FoHz0syoBLd37bA8YGMc1mL/oBkj7aOzqihOFX3Ro2lB7sMG22lrFZGYpWyXL83fiMHLMemjNXfb0MtbrzIZVteLzzfR3obvDad48H8nx7WZEv+6VJD+HH1B6NI3qD1iZHQrXG3V3kN7mruZoaLUURehggXih+fyVL/15XTg9CWyqFkWXnLob2cde5RwRqmFmNW0yyfYLk75QSN0vZGZRBkZBp5H4MtYTGZ+pbkIOwfBFKLRqKahVyIxanTt4vQQHGycN0jtI9NQ0Az9ObQqHIayxLi5LUkeThuQjDPVbUixoYXQZs2hzUYSZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  5 Sep 2026 17:27:17 +0200 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:

> drain_vmap_area_work() function can take >10ms to complete
> when there are many accumulated vmap areas in a system with
> high CPU count, causing workqueue watchdog warnings when run
> via schedule_work():
> 
>   workqueue: drain_vmap_area_work hogged CPU for >10000us
> 
> Move the top-level drain work to a dedicated WQ_UNBOUND
> workqueue so the scheduler can run this background work
> on any available CPU, improving responsiveness. Use the
> WQ_MEM_RECLAIM to ensure forward progress under memory
> pressure.
> 
> Move purge helpers to separate WQ_UNBOUND | WQ_MEM_RECLAIM
> workqueue. This allows drain_vmap_work to wait for helpers
> completion without creating dependency on the same rescuer
> thread and avoid a potential parent/child deadlock.
> 
> Simplify purge helper scheduling by removing cpumask-based
> iteration to iterating directly over vmap nodes checking
> work_queued state.

Thanks.

> Cc: stable@vger.kernel.org
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Ye Liu <ye.liu@linux.dev>
> Cc: lirongqing <lirongqing@baidu.com>
> Fixes: 72210662c5a2 ("mm: vmalloc: offload free_vmap_area_lock lock")
> Link: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com/
> Reviewed-by: Baoquan He <bhe@redhat.com>
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

I think what we wanted here was

Reported-by: Li RongQing <lirongqing@baidu.com>
Closes: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com/

so I made that change.



