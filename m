Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACAD6CAC59D
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 21:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1571F8E0005; Tue, 16 Sep 2025 17:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108758E0001; Tue, 16 Sep 2025 17:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 044FE8E0005; Tue, 16 Sep 2025 17:16:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFC2A8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:16:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 76B3C85068
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:16:39 +0000 (UTC)
X-FDA: 83896372518.28.D1A82F0
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6A7D4180002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:16:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=V22XGrXJ;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=CqWJ884f;
	spf=pass (imf16.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758057397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cdBjosARmBSEo7aiSHM+dIdoMHfCZY2WlWe0Fb0A5eI=;
	b=NNINGjWB0V9fGHbcDDPIbPlwMdp0ho0R2U+NLVAk0iepzDPpfZUNumUZq6iCjhZoRCgt3y
	VUjgLLEOxFtvaaNSKRqf7b8Xx3Uh2IHxDzvr5E7kTM9BGS5ea7wV1Q6jE07OZGL/g2V4CN
	ztMj12v+oksT+rYavbQ7O5fG+lr6gUA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758057397; a=rsa-sha256;
	cv=none;
	b=7uafl/ZAg4INiRWp7BcEkJ172KYTs2inkFQZxM3XOc4R1pkIb7BNLzf4bsxRNPL4R4Wxuz
	w7ip39pfUA8vVViqljJGLZSUnjGmgYFXFmRKdlLVEW+AoZTZupaPx5k9McEwIumc0VcYIt
	ZL4fiRxokXTwRHrFOYFx8uBSGvX6xOc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=V22XGrXJ;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=CqWJ884f;
	spf=pass (imf16.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1758057395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cdBjosARmBSEo7aiSHM+dIdoMHfCZY2WlWe0Fb0A5eI=;
	b=V22XGrXJlCZ5AQ9pe37LMtlOlaa5uG8osxrLsqv/+DC/Jbi/gaOpvLPA0WMtTQxFy0AUdp
	ocZJsSczCxILdgsmO4GMKTUFDP0xpwY6AtIXURDTCI7YBHO2vUnZPIuwtJw2bNKQ43jRR/
	SrnGkYVy74kqALkz23Q9mSMTMN61R3tuGvD3/VSh+ybJMd55BYszvtovTcZU3B8sWL/oxK
	m7Yx3U3wdB0a8EHseRTc6f9n1GflXL/nu61iIYkP98BgbC6HF97j1UXSi1XiE2URbMvERJ
	DzKL9myXEOmPWxsz4yNEbIW3+Ka6Elq8rzhi9TN1pUtrkyuBilYL6aLIOL/JOQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1758057395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cdBjosARmBSEo7aiSHM+dIdoMHfCZY2WlWe0Fb0A5eI=;
	b=CqWJ884fvJ8/FWHJRwkFwD617d0BLRtMBNrP3oVIvDrTlG1B/A3pQgDgnF+3bJQdmfDYNc
	0I7SSpqMR6U7YOCg==
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, david@redhat.com,
 mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org, Eugen Hristev <eugen.hristev@linaro.org>
Subject: Re: [RFC][PATCH v3 09/16] genirq/irqdesc: Have nr_irqs as non-static
In-Reply-To: <87cy7q9k8y.ffs@tglx>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
 <20250912150855.2901211-10-eugen.hristev@linaro.org> <87cy7q9k8y.ffs@tglx>
Date: Tue, 16 Sep 2025 23:16:34 +0200
Message-ID: <87a52u9jyl.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6A7D4180002
X-Stat-Signature: 5cnp8t5an1wknpi675gfgrw9s9dqwt58
X-Rspam-User: 
X-HE-Tag: 1758057397-35299
X-HE-Meta: U2FsdGVkX18rTtFsCksKR5OILsK2dEMSdiWZ2CfCs1JtOzAtXR3jud5ogAKczspLlB29614AhYOFCAgrMWpQObbGXZDSJ2hLaOsYb61QJwFjl5c5n9hEKYUHX7FJGZT0L4jbvatadYip16Y969jeC+vEf0ieOHIGiwo55bUBo3cY0ErkpSjo6W5t54sXClS6k1lD9UKth6l5MdzRAjgx6ktovPGd8wF4ov/l7PCzNAagosyRrEq9GsPyZovSJBVp7daEOpmBRupqbzqSw7pQk+wl3gxElISFk4WfGGfafXAQ7WnHkKBML1Lj+VdmHLch4Cvq2bZiAv1EJX/bRztpUTyPtdZgY6AKbVjrHUzOlMLpuyvVm+yvRCU0EfaXlSJnmByUk/W7VkKRYWNERe8p3vao0EuTf6tTZxIWWMFQTgEg/k52NqYR8GLTfo3LchTLGUfYlVWGJW4p1KeB78VflQVBNL8lJEQX3L7g0JInHJ2yzatfV5i/60CPcl9f/smSXc9grD9MarmO39qvX6Y9A0gBPOoVRooWrgGZN+WSwiJAb7RyctB7fbic2HRvv82PwlXX+k0kALRNJ+8gTVMoHsnXdfRlQlXVnE0ZVYXaTdKI1eTg2xUEYB7My1+YhCLOAaZxvvYYqwOnwxm1reTPoiWYwhOWk4CIa8D89AR+qjB5BiPccRpln3vKhT5htyxnZtxASJu96v17lUW/mqf6qWMBY/pTMqAQk6fPOS6nx3PaoWP76BKWQNeb52oCGZ8zmPTMxowXNE9vMp3sKiq+oJLZhjPCxhESu9t8G0E13tOtNlts/CWVR96QATgM1JvHSxADFna/SOHgTv8QJMvkWxXU1lnmri5B5ics8J3Z5LGJEW+KDZeYTJ+tfwCZtL+xSDWI584kU7Aq3eC8oGaPeE2P6y0553HJKPWcIgp3JubXTv5fY3cC0edSI7YNL9CwN2FM11I4Ru6d3S5u2SS
 MmB5TGKf
 EnKvaerCsjf3HoPXe4inQsP2SRh2RHNyV/vLUl27SyRKd+9BDKvf4nrVLXPrnIDBS7X3219uhV2tB8av6eSMYMjPeyYsiFd3PUAApp690HTzLGOBlmPZu05UJfkwpKEudR5xEalpDWyKWzD/vmRQFiWfpWL0GwX+wBiKIiPXYYKmJDY/GuLMue1BWpPxoK0aq24pyTXmHgfpNmjCIc5RQbD6/akM62CRpYazWg+nKBMLWt/Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16 2025 at 23:10, Thomas Gleixner wrote:
> On Fri, Sep 12 2025 at 18:08, Eugen Hristev wrote:
>> nr_irqs is required for debugging the kernel, and needs to be
>> accessible for kmemdump into vmcoreinfo.
>
> That's a patently bad idea.
>
> Care to grep how many instances of 'nr_irqs' variables are in the
> kernel?
>
> That name is way too generic to be made global.

Aside of that there is _ZERO_ justification to expose variables globaly,
which have been made file local with a lot of effort in the past.

I pointed you to a solution for that and just because David does not
like it means that it's acceptable to fiddle in subsystems and expose
their carefully localized variables.

Thanks

        tglx

