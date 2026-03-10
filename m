Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38664EB1060
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 15:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 741C86B0089; Tue, 10 Mar 2026 11:12:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EF426B008A; Tue, 10 Mar 2026 11:12:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6256E6B008C; Tue, 10 Mar 2026 11:12:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7B76B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:12:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1470D1401BF
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:12:54 +0000 (UTC)
X-FDA: 84530495868.28.8525AD2
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf21.hostedemail.com (Postfix) with ESMTP id 518F91C0011
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:12:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="DwW1Af/q";
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773155572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQRiW3YlOB3Mb+ib1i0SWorPbB1fJDy5Jpm6Xbydanw=;
	b=jsN7eHYiCihaC+BoE21Mq5fvwTAJSaNejMfES8nYNDznys0gdW8oGtcgZPmBBXY2JKxhrH
	1Xl3OHUcTz2WsVFjiap7by+1zr0Zy/HD/+23tZJeoDd1Sgby0O3iy7Sv1xyTKe2+VJGiP9
	t0MAmr6ygn12htw6+kbyfDcD9k/LitY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773155572; a=rsa-sha256;
	cv=none;
	b=RPzYEXAWkVWwJqVSyrnnGjSeERwoXQv+NevjL/tU1zl1PWfybflilebpjqhcsdBbQHyako
	37ygKowpR1uqKdJV8XyXRsCd5YvxUDU4/uWc9tFSu9Lp1vNCEDs+1GJ5yfODdD6zblEPDM
	BGYnjvABTxSEjvYrxLZDTEsS/vAAfhQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="DwW1Af/q";
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 69064B37F4;
	Tue, 10 Mar 2026 15:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1773155570;
	bh=wQRiW3YlOB3Mb+ib1i0SWorPbB1fJDy5Jpm6Xbydanw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DwW1Af/qGgqi8YmFeKNuZVI6qmStB6IGrHgDHXV3tdDzQ5uyWgEYGvQF5ObX6VFvj
	 HUNmp3kIMXPDX81SvqPKOtzXsmOvdwhl1iGc+zzg9Gbqe8RR9RSqm0IhbD42OQ8HNK
	 o9r16Bdo+8zjsl/t5doqnVtQMjfulecSLq7DICuE=
Date: Tue, 10 Mar 2026 15:12:45 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH RFC 3/3] locking: Wire up contended_release tracepoint
Message-ID: <abA07Tn034C66HI2@shell.ilvokhin.com>
References: <cover.1772642407.git.d@ilvokhin.com>
 <8298e098d3418cb446ef396f119edac58a3414e9.1772642407.git.d@ilvokhin.com>
 <20260305105924.7069eb23@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305105924.7069eb23@gandalf.local.home>
X-Stat-Signature: h4dpc7m5jc3i9f7964s3no97tqajfznq
X-Rspam-User: 
X-Rspamd-Queue-Id: 518F91C0011
X-Rspamd-Server: rspam12
X-HE-Tag: 1773155572-85545
X-HE-Meta: U2FsdGVkX1/7aWMmUnrWhImy5Tzzecn4cjslDs+kgzBv+aADzKRyFuaK0OMdIAhnP091C42BM75I+W/aqxFOGSQ4jh3lYrmAaK1j8aukJRRPc79f1VgJN9jjb7ganbMWelQ9zb2gvhq393zX+6FTFxTEu3J5dQB9Nodq8MGgM5BbofdZhrj0h7uMi9SDg0coL1DzsL/7eYfNw7UkCQavOURWETdjX0tMjN8ffc55UeL8LHAbaVqw7aJig4rQRZZgGTe7fLltRlY95KqcXWjWZn1MobaD+3YhoiaZ/AOA8HPVqbo2ToL92CxgCM2JqU2GHuV9XeRs/FJ99N3rK8nN//vW1RYtDjiCT5vTn1Im2u2NU1Kkc8OPym6PRiY59HNdVh1gvWRxqy0ndYw9/f6B+no9ObpAYmyh8fdxYI4zWxXIn5VwKZIgBHvco/xpDtDeOz05x9ZfCWR6qCrV0aqVjQn3EAJ+vsWcip0DwsCpOxvcG8XXifq5lMa6771Nn7SXkBcj1qUQ/loQ2LaShIKnt+Z90ZrSevSFLlMErdkJQBXDWR75aF1O/ovZ6PbbVqbIoJbU4V+6PmHNTdX9LV+gPWNDuWV5BoG/3F4igLZdw/GhhX37BG+QaEnpINq2LP1vz3ZNHSnehvNtgI5cZ30kTfNe2FPVQbSHudJaSUktBzNSjuQdTJlQqMxYcrPF7kgzhr80w/hvqXtgRC+0TGdmbEIyHx/eblDkrCB6YX996HK7zh64c4z8ds44lxe00b5DGegND/eOJskWhdxvGlV4PQ7RTNW4QFrvOWondeWROI4NjjeXIXu4jhv633qqxJjnXfGksq5H9ra4Lz1NztUCyabSa9SpaVFZ+9eeMBHSgLyu0baauPOVD8/s5zCWH6o0GZeZSGp4V6vzC6P39MdkSVeM0kwvJMBsxoizpQRBTGA8YvMBtDCFEujW9SkJj6MtmizkxdNq83et3VJs23w
 1AhG0ILh
 pICjMn1IpxCp/bWLvypXsNNasPoi7itjNpHS5ztNwyqMGHIQsenu4Yk/KPSV2CJlY0wLOoy135/gt+O3224g5k7PY09nhQGTlmBE+I429quIqI/SRdaqJRhulm+9mVkUNyItVi0+PPdfnamY62xdhGLP4h2ZvK2QFh9IMaaVs9IljJ96HlUnVAgg5I27OxicOrWw3LVRsixRGsyRCL8XXOdDE72xOxZ6V5hE9Qd8jydtR+/JT2+UEvFoUpyAZ91VFJVvNCrb2tequALt0VE2/RP+kACnIsiy5vORVUT23/65aNW9ta+4rXkWMth7JA2Om9u9JEXsT6iUSS4HDJtb0TrxX7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 10:59:24AM -0500, Steven Rostedt wrote:
> On Wed,  4 Mar 2026 16:56:17 +0000
> Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > @@ -204,6 +206,8 @@ static inline void rwbase_write_unlock(struct rwbase_rt *rwb)
> >  	unsigned long flags;
> >  
> >  	raw_spin_lock_irqsave(&rtm->wait_lock, flags);
> > +	if (rt_mutex_has_waiters(rtm))
> > +		trace_contended_release(rwb);
> 
> Hmm, if statements should never be used just for tracepoints without a
> static branch. The above should be:
> 
> 	if (trace_contended_release_enabled() && rt_mutex_has_waiters(rtm))
> 		trace_contended_release(rwb);
> 
> The above "trace_contened_release_enabled()" is a static_branch where it
> turns the if statement into a nop when the tracepoint is not enabled, and a
> jmp when it is.

Thanks for catching this, Steven. Fixed locally.

