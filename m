Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 342DFD715F6
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 22:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6396B0089; Sat, 24 Jan 2026 17:18:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969CF6B008A; Sat, 24 Jan 2026 17:18:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A4366B008C; Sat, 24 Jan 2026 17:18:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7933D6B0089
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 17:18:10 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C791D3010
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:18:10 +0000 (UTC)
X-FDA: 84368271540.12.0A95FBE
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5EEF440002
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:18:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=U3xEHPAT;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=ObDNF3tV;
	spf=pass (imf11.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769293088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hIFzXY0B+ynRIddHqhxGeSk16xe6pjlAt/cnuRvCdl4=;
	b=0laZksSYwQWJeForr0+FKWS6dSIf9kPdlYOlZ3jvols3RsT1AYms4wEwc1k+88QKJs8JeE
	pKiZLF4fcITwL/WiAUfbQ8Dn5Fjpf3NjXMYbX4hDB8VPguaIuMkWTMQslyS/w5gyb9J0QK
	4iFO/i/XznfLu6g/EtVV8lX8DHc/zWQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=U3xEHPAT;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=ObDNF3tV;
	spf=pass (imf11.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769293088; a=rsa-sha256;
	cv=none;
	b=I+JhCm1OprmsO45YcPvZZIGkeYvODz9D9DFM2F6FbkUU/VQCjEnnzBnHJvra5usOxQcZQs
	D7WcGwB55UDoi2cTWNddJCQbVyg/kOzRllhJvu+33U/djdChqDcxPC8Gdf6/4swP6z+Xl6
	cAcBrg1tklPYgTCcqtfbVfUt6WPMoA0=
Date: Sat, 24 Jan 2026 23:18:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1769293086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hIFzXY0B+ynRIddHqhxGeSk16xe6pjlAt/cnuRvCdl4=;
	b=U3xEHPATYtYZKnUZtHiJEWMDVxcLYTtAaEQRQKnU4KQCqNiw1DLkhI3/u/N/agqaDLi9Lz
	fdJwN7NeZLeVKuOZ26hqptvxxVpaEhr87tkC0hpSI649thatKeqNSFSyr1sfz48XQoQC0u
	X2X0uV/FBF5W49lF9U/02xZiQk/BCoFIUTTXfTo1pwSSNb25uePG7lhuaj+9Zg2zXYD0VD
	toLsYi8slyeKUcocLx4mEJ9aUFRPXX5F5xOYqrhuidgEZuT46ZQxUAG87VVhuBTBdoAaUE
	7oB0h0Sget8bEoIHUy7lOjZcg98TAG8TdchFlbUxgND+b6XCMuIyF7qdqbZVKw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1769293086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hIFzXY0B+ynRIddHqhxGeSk16xe6pjlAt/cnuRvCdl4=;
	b=ObDNF3tVS+gJZtBoqh6UDrEczTRvmvNhucXAG3v+Vii63SWCy860g0lAxp5W5p3+D6nbD/
	irVAlK1g091mz8Aw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/3] mm: Replace use of system_wq with system_percpu_wq
Message-ID: <20260124221805.wuaYkfoS@linutronix.de>
References: <20260113114630.152942-1-marco.crivellari@suse.com>
 <20260113114630.152942-3-marco.crivellari@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260113114630.152942-3-marco.crivellari@suse.com>
X-Stat-Signature: izu4cpizkpsnhgszbzsz3pcih8n6sack
X-Rspamd-Queue-Id: 5EEF440002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769293088-622730
X-HE-Meta: U2FsdGVkX1/xZJfaKz8yOt6F1u7bFpfJffCkDe3qwFWD6RgETfwvqwGb6dxq4NE4le3yMg+vcJc6qddKCh0k/O3VcOVgM8dkEWGdn0EZVdFW9EMio4Yj1U0aI2Vzot1ZipMraKIuCJkE+P5TCL86TsfAecuXlm58OX0M0AASC51vwDnWKnAiwDapywHEijXb/4ifUfyA+dM+r/CGcOfaowEd5RChmieLQP7ea5AyC1frjTsoQrsmiC5hcOepA4HP62xzW1fGkhLi5PzOSBYr4KyjpOyudIfcV6x/7ztKFto+p8r2kNvHgJ2RInGu5yK4GEvtBbk2vtPcYFqeiwJ1XZ3ApZKy0ZHNVMAdd+MnhDsuiYD3RAsdw2by4Gs6+4B6kVURZ/YHB39xDr9ATBrKn9jsuAHKOdwM8aE8TcdhEayNxUknHe9KGziXjGTITWfQ1ihIoz8nDNk2FZS9L7dqYsF4oN2tCpjHtG8fu4Muvo9SiGdqJY7elGHCbG6qu/v2PjJGIdZx3oodlc4sVYe71HcFS6oKv93GT1OiutGUZrTHCRsD9eRMHO2TpAB8MEcQQzJ2S5bJSomA1VHYi/UYYR3nadbGnJ6JVM/woOm0o3aaiQwxwqNC9SG4yyFM7iNvtDETdmJQ0x9FeiQa8R2bxZFFd2WMe2MLNyl10yxmzX7R7OPPeoaKDzk9PXbf80TXDus7tyYFhKhnucwi01amaEQ/I2CWPSmNvzo7gwL5etjbkyABp9v80bqlxJIXxelQLpaR7qxgtolLlYdqhUW3pIGb3Z5ExB3NQmrATvDWfeiwfyXJnPvjxe70/c9ldPGLWFVktSLKFQY/eRroxMT2bxDmEVNbCf/PCKrjd9PgXPUL8pepSBp6EusSG2+Z11rTdm5MiHUh/yV0cu72hs9dWiQt9+omwGRWDqrP6zD9fTnOfSCG/Ypcf7E63Medq07OMzuqY1XGbcZK3/bVV/d
 foQTL+Z4
 ZmuGlQCj/bt3AvCUUQe2cNdLwmtjDwecMs8Hllx3PyXSkOfuwJ+khTnR+PT/y8FZq+4z/uWVT6NpbwMoIJvb4DBS6BmaxEKSNDAcgx3WMBoAGeWItNHDiXryW/yk155dl2USe8Vm1IdJ95K2k1HI9w+afSUZ1zomPcmvXyuTXh6oZh01bEM0UYxxr8IhWEy+/OktcXiq0yq0hmj4QKWJRGsl3NXG93dcpOIWsKDBEUZ030nmOtArwxo0HIry+HvVx8rvmgXwPOzF78axTRLJFfzmPGBJagPsiY4DJrbeAchNr3pRi/rhjEIjMcxEFY7QxBOZi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-13 12:46:29 [+0100], Marco Crivellari wrote:
> This patch continues the effort to refactor workqueue APIs, which has begun
> with the changes introducing new workqueues and a new alloc_workqueue flag:
> 
>    commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
>    commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")
> 
> The point of the refactoring is to eventually alter the default behavior of
> workqueues to become unbound by default so that their workload placement is
> optimized by the scheduler.
> 
> Before that to happen, workqueue users must be converted to the better named
> new workqueues with no intended behaviour changes:
> 
>    system_wq -> system_percpu_wq
>    system_unbound_wq -> system_dfl_wq
> 
> This way the old obsolete workqueues (system_wq, system_unbound_wq) can be
> removed in the future.
> 
> Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian

