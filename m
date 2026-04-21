Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 148A4F94CB5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 502EB6B0005; Tue, 21 Apr 2026 18:51:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48BA66B0088; Tue, 21 Apr 2026 18:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3543C6B0089; Tue, 21 Apr 2026 18:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F9166B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:51:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B114E8E6D6
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:51:07 +0000 (UTC)
X-FDA: 84684060174.27.3C0B88F
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id CE9BCA000A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:51:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="mKjus/qm";
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776811865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=228mfLAFQ3GXHLkT80UKFb5GQ8lHGJIsTTdZABxXJ8s=;
	b=OiFnpC16CC0DV8YJVEotdwwFgBrOeSnJNX8GS3JATkvaemCelB9oPMq5302aztxqlL1YeY
	p8u7s5vD95AW/QoeTf9jFVBnbV2Hc7ly2GZ7eaRwRahR6ulsGWTM4YXgaakVg3Z/5/ya68
	R38oqztASBPGYyhQ9Uafe+BqYMTfCiM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="mKjus/qm";
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776811865; a=rsa-sha256;
	cv=none;
	b=Rhftj1tCFA0tke5WQGu4+ZFDhtlxz5RIsNPayA5tisITnzCgfyjqDPyQ1M6Wk7dgPNAvSe
	bAhTtIR8Y7l8JNytGiVsenmvg9k6oveLV+2/jME69bE0879ZLo/EqnCW7f/fwzqnNhXCRI
	lFtBYG2jdIe+Rj+FHaJpwymF5ZfzyGY=
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7dcc9b506d9so1976015a34.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776811865; x=1777416665; darn=kvack.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=228mfLAFQ3GXHLkT80UKFb5GQ8lHGJIsTTdZABxXJ8s=;
        b=mKjus/qmMz82/Jxxb2vIt//+gh8d1QBbXHQPGfeNXsxBz3SEQ+MvnXMb2aJyZRt0J8
         muNdhAB1/O3exYH4wRitquiiTpM5CysvDcLEC99V5nSV2ju24lX1zbLsWccUFM/2RAdf
         QA1z84gsp91VO4HByOMf9J/mh4sNzhN1i/g5RczA3FeS1UI5WyAZ4LFqlzXdeyMY2K2n
         vb6H1J81T7to07PR7zdCTOVbgOwUlJxiiUmWFN3mCHS2u6Lg8/JgC2nrm6WbNuSYdTAg
         p+aP69Vdk2Nr1jvROpOekDPXb9lqY8aZN8DDFcgAdET9ByN9lPAunDe2ObrFIYmtzqNW
         Wt6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776811865; x=1777416665;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=228mfLAFQ3GXHLkT80UKFb5GQ8lHGJIsTTdZABxXJ8s=;
        b=SD93bct0doO2PYwybv+4hyHKXU/nzBwJWmtsGoyX20xV9qB5bV8NWs01ry1iVwfxmU
         HV7cEABGPJ+rrbz3RX9p8ZVAr/jsbUrRb7BBWs8PBpIjyT/0nCChcQotWpD7pI5z7G+i
         lNsucdfQWMIhGVDg//GQnSFO1NBvY8vRJL19fB71ATvAVS1BnGBQbszHR1NzugkAlMXW
         cpY152N+45ilno2LAMmziL52ZbvSTjNUmSXAGxGSAfGHkpM26MaqLE7MqNRJsJN5G/Bb
         IBev1EaagX/RIjvHCZ+mZDZDBv/K9vYU5JcZBxF6yeAbQNiUkASCCk1uiZfT3YBr9KSe
         wuEA==
X-Forwarded-Encrypted: i=1; AFNElJ8nZteqmT2QvK8pbbocHTegbN/ljnzV3gYj3XJI01hj4n3+dJly+2r5Bnjnzn5N32oLJHgPrW95ag==@kvack.org
X-Gm-Message-State: AOJu0YxgOwsB+BRF91INeuJpBdzzm4bA7VtdMJr6/SKjZqeAKm6t4MLX
	spZUzj2y9FIenqpKmZn6LSFeYVos6AdkVqIMwKw2PBWmAQh2piF8e7LN
X-Gm-Gg: AeBDiev8BO9FWoxjbxz0lrn/+b+tk4eSYN04K5vriq2B7Ag7r+guVEb72QkNQ7uaMJT
	OK661kbJBuAHsa9X7r+581UZMKCExqFGvZf7DMmC75TeQASX99yrY7VZmk+6KCs4oodXbuV0/+G
	bEMRvwRCwdABo2/OpuCKmhR3yik+RuCSv4aXR3ObL99gl48NU7P1cY9z1MmFiy3O1dZxiaj6MgX
	ziWiH8IF5fRB0uMvFO851OMv+O4xTllp/bi8VK++3+6S+bW7tVALJsooCeAfvRGwTbjXN8o6pom
	Cz52MjAkbcVij/Cyc6lEg1wfyq3oG4W9si7Y0bNNZ9i5splCTmPUoDhDThrN5BkAcGemcBjkavU
	FW5xbygh1emIy6OQ+5mZUcut8iM1u2dZPxFFgTrwnsJ5xq2x3/dmoCLjg7WgvdxLQhWvHaxwxJI
	Z1V6ZXG6CPfrW1b0Pd1MFSKzyuWsVeLGUpte4AaYB9BXxVZI5Fwh2wczJisiYh3BwNjMh9WZdHV
	XQuvPHtdBKYHKzrR+gFmxWsgfup
X-Received: by 2002:a05:6830:67f6:b0:7d7:5559:3d1c with SMTP id 46e09a7af769-7dc94f961d0mr12841177a34.1.1776811864782;
        Tue, 21 Apr 2026 15:51:04 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:58::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dccfe912edsm4252662a34.16.2026.04.21.15.51.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 15:51:04 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 21 Apr 2026 15:51:02 -0700
Message-Id: <DHZ78L9HZ1YE.JY63DXXMN9NF@gmail.com>
To: "Harry Yoo (Oracle)" <harry@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>
Cc: "Christoph Lameter" <cl@gentwo.org>, "David Rientjes"
 <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Hao
 Li" <hao.li@linux.dev>, "Alexei Starovoitov" <ast@kernel.org>, "Uladzislau
 Rezki" <urezki@gmail.com>, "Paul E . McKenney" <paulmck@kernel.org>,
 "Frederic Weisbecker" <frederic@kernel.org>, "Neeraj Upadhyay"
 <neeraj.upadhyay@kernel.org>, "Joel Fernandes" <joelagnelf@nvidia.com>,
 "Josh Triplett" <josh@joshtriplett.org>, "Boqun Feng" <boqun@kernel.org>,
 "Zqiang" <qiang.zhang@linux.dev>, "Steven Rostedt" <rostedt@goodmis.org>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Lai Jiangshan"
 <jiangshanlai@gmail.com>, <rcu@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH 7/8] mm/slab: introduce deferred submission of rcu
 sheaves
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
X-Mailer: aerc
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-8-harry@kernel.org>
In-Reply-To: <20260416091022.36823-8-harry@kernel.org>
X-Stat-Signature: mepugbtg3j5mekcu5fs443ikdh6etrqq
X-Rspamd-Queue-Id: CE9BCA000A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776811865-824327
X-HE-Meta: U2FsdGVkX19biWKkEIlCxtgrFeowUEyjjhZiYyCnAwbOuE3u4Ii2bisxlNt1vPjVFtdY+crcwm8bFBI7UOcEHXzkABDtceDBtAlF0t7OKgj+rD0houn6UVin0WbFoY+iofgSqGsdnmTPo+gwqMQjaCXcQX+CwhRRXvSep58Y6DOWK/sPGrqhBCb1/6ja2IM6SDjiK5NKXwgxU1ii+eRmUx8r/oPemneabbM6SUKA85eVWnt2l9wXfMzHMcTU1LSocH8UqvOx+zg0J/+OHpO5XAABlg7VbaiP4TZIqZUTBiWgxWW4rnbkHURFTuB40zJhL3R6ONJyRXbJQiU/u9a7eZ6IiTcXkMf48Cwp8qt7t1DN7jagLPsDoP0HEM8K1Trfi+o7W8dpA1fVc/cAe2WGETlcMsysjNmVGS/ufNPHL0Z5UgzP3b749Zatg/vj7YXoryicKy8MIAebpSSFcnpI5CH6X5wRdnsi6X1Rb6YixS7dZbOWT2rZMVUiLutsV9biaU1tUb3MzYW9f0PSo0SPO2uWPFkFDzsgtoTikehzPWFZdbyFdJh/r+bCw7e2xIYdgO2GZlvr7RkIgLtIpmQdAGWIY7kzhDYFHy2KZsVDqxMxKNvC9r4cQtuquITrwaZP8yN6rpFeIXepMCe0WPTtaldVoyXsFIlpoJtrmRBeyt6rQhHBDcdlmMtfTwvssmgAjEFxUlJ5Wlxz5CmVVFyVovPh5duNpOQcrHEoQjxybqKvozTw536XqyxFukpsxCKz1zy+yuN44bvANHFm0KDs8vcG6nOyTRT4/GhWiVghf9buxpOKmb7rjfkqJ4iP21inAm7RTUNBXHUfVS9htPFbyoqw/+yK+GTktRBR7JR0u3LB5JsjoZXB+VZ3RvYRqEIuJaQ6cXAYd+zUidiOSXhEnc+OnR5myo8io1N42F5uPBmy+j0dh1JigIaX2C61bcp5tvC+P8/sB6vUZkNd14F
 DSqB1zYm
 CA1k1kFdvpXV1w0nNTSUcPivGRmcQCJ/qVB5t6I7Dlq9j3/JXxG23wcjeue/oM89zNTEGC/UUjMLpoPmaA71/O5sJGkwc7ua7KNFX8gx1YW0pDgKki+955c3n7z4vlfJYD4IMlKz8hFXf8TnuRG9klAXcm0aCledXetpUbuDDXtJulUeELrYJ/i+MbZZQrZCwV1IOZol9qMWoWwXxDyntihfD72lNUX0059N8UAVg4be7r5+JN9nCyiyLaY41wqaF9kr+dP92Es67UdFwxdanJVTkZDN/emi56jfGE3Uuzo+VSqjj6PgmhSrFIdoX7OksLydTjTuNUg3Nc2tug3tjv/4rKPPmsAKQPg9MRl9tJEFo6ZbeqlaamQBGFuT5P3m4nc1eJCEcCqBCOmjUdMuyjArcgWpYD2IQ5o92FLHM/BFhLt/2H6ygjtWMWvCEvI5rhaZf9T3oRQ4xrQeSW6Xg8/yp45tVKb60yjdCkFPGlxZJqv0njiNGBzQXLEdQ9s3gICCBI0OVVCf0nErF+OXZMD5mAS/kbJRmvrgtFSqdsKz9p0SOr+O6ycqDBSl30+cU/2MQVMnWUNeOLw3StqAYJxk8cYCZbLSJi8BENk+eJn693JMgOFKbm0gtkRXAcXUUhX1ktGBz8P6f+R+MQ1RLbGXzDhM1m9g8nNe8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Apr 16, 2026 at 2:10 AM PDT, Harry Yoo (Oracle) wrote:
> Instead of falling back when the rcu sheaf becomes full, implement
> deferred submission of rcu sheaves. If kfree_rcu_sheaf() is invoked
> by kfree_rcu_nolock() (!allow_spin) and IRQs are disabled, the CPU might
> be in the middle of call_rcu() and thus defer call_rcu() with irq_work.
>
> Submit all deferred RCU sheaves to call_rcu() before calling
> rcu_barrier() to ensure the promise of kvfree_rcu_barrier().
>
> An alternative approach could be to implement this in the RCU subsystem,
> tracking if it's safe to call call_rcu() and allowing falling back to
> deferred call_rcu() at the cost of more expensive rcu_barrier() calls.

Yeah. call_rcu_nolock() will be really handy here and in other places.

When you respin pls pick some tree that sashiko knows about.
So it can apply it all and review it all.
Currently it reviewed only patch 1 and failed to apply the most interesting=
 4+
https://sashiko.dev/#/patchset/20260416091022.36823-1-harry%40kernel.org

