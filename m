Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FA8CC5B572
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 21:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF1DD6B009F; Sat, 22 Aug 2026 17:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC8346B009D; Sat, 22 Aug 2026 17:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDF046B009F; Sat, 22 Aug 2026 17:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5C5E6B009B
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 17:12:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3D05740203
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 21:12:40 +0000 (UTC)
X-FDA: 85130154480.12.AFDC4FB
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	by imf20.hostedemail.com (Postfix) with ESMTP id 03D8C1C0005
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 21:12:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=MJCA233n;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr;
	spf=pass (imf20.hostedemail.com: domain of jeremy.jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=jeremy.jean@oss.cyber.gouv.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787433158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLWB0kaCt/rmAupaJgQeIGSyRveCIi1ZrRRpZelNVsE=;
	b=0DhoDft/fn65sweHyDQpsHaEH7+8k/6rudtj/a+4CqRfK8hP6nloL/qdfYSuVp3QAcC9uZ
	UYjq4FG7xUGL/ICT5/jkc9V6GGhN20RTbEBKtANrkiPuC4A13SDrs0iJazgY3o43Ifk3kQ
	EziZHKjC37jCrOaLHT1qLJXa4YO5UI0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=MJCA233n;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr;
	spf=pass (imf20.hostedemail.com: domain of jeremy.jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=jeremy.jean@oss.cyber.gouv.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787433158;
	b=xarbz8Ianh7H21H8hgmcYB0a0z9OakvELLMGM4ApNGsiLjhOcS8TzhhnSgPi3WYOw7B5It
	rvshicUb6asLvzJZ9ePC8Hj+LCxoKMdXYoks1Oevj2u94ml9wc8Yln5UB1gXkOR2q7uzgz
	tKOkDNnSuNupZXpsZArUAK1/RnEzSq8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=vLWB0kaCt/rmAupaJgQeIGSyRveCIi1ZrRRpZelNVsE=; b=MJCA233nf7bagc8MB28UdRMUZz
	jXPB1QKyIBBI4tYgULKa7xvZaaHA1OeDOAwUn3mJXGohl5LzK4RwOLGPpXnk+hsjq7twciiVQLtkk
	U/2/aBvLyC3cymvNXY3uTFmRcuwKT8o3jdG6mwFY5Mv80PmlUU/9k1xJi6T+yhR1c1vA5xVSmZ5Wp
	qWwqkohXj3FjLjRROy/qlNVyC055lngTCGEMl8pOu9ibLIYZoyd0THHYsOROCOUqSERcQOnQnEgZA
	FfciWAxsEPpjiB1RnBYYWBtc5BxE4yr3zfQAic4WsuIct8N9uogocJuDtdqlkOd+AEQo1BY+7n0uG
	7t5XHoDg==;
Received: from [::1] (port=55848 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.99.5)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1wxt13-00000002Q8Z-02qL;
	Sat, 22 Aug 2026 23:12:35 +0200
MIME-Version: 1.0
Date: Sat, 22 Aug 2026 23:12:35 +0200
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Bradley Morgan <include@grrlz.net>, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 mgorman@suse.de, bsegall@google.com, dietmar.eggemann@arm.com,
 kees@kernel.org, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, vschneid@redhat.com, linux-trace-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH v3] fork: initialize function graph state before
 copy_exec_state()
In-Reply-To: <20260822170928.1acba2cc@fedora>
References: <20260822195321.962383-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <4E2240F5-1211-47CE-AF04-24E1F0BC4707@grrlz.net>
 <20260822170928.1acba2cc@fedora>
User-Agent: Roundcube Webmail/1.6.18
Message-ID: <603183e5d6abcae2229c61b8e266e60c@oss.cyber.gouv.fr>
X-Sender: jeremy.jean@oss.cyber.gouv.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - kvack.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Rspamd-Queue-Id: 03D8C1C0005
X-Stat-Signature: 7bqp6qqb6y7w8qg6ozfw1huqy8385guo
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787433157-690550
X-HE-Meta: U2FsdGVkX1+J/nhr0C4Rl/kqCqxvJ4PaFhHyDvD/d3Abitgxu8ggiOTwUnoOJ7zkIXefbbPDZFFuQw5z/asAXzbWjsHdnJWcZzQF4BJxBUGLmA7GRubeE+tFh05bhdiqKaVZuqeLgH2Q7F6B21TQmeSgtf1coXu72vKs3oULBYKiRTQZYNsO1JEEHogp51X9YkhYolLHlNTy0br0ZeNdsiFXDvTtyXygRf/e7RDiufKYlD00NkqlkHh1/r+/qsfto3gmjOxrJpZYKG/CmejldHX5DLJLqnO52V8JXwjBb45ilOWtvTkY+/Z2VgmYgqJE91Hj59YWyLeBvhGbe9HiYlvTJL9Kz4yp7TaoK/I9zqUKiV3Lp6jSUk8nZc47yOjewbcnMhxrc5FwK3j/8KjBDFyMoJ1Z/hcZrkNN6FtiNBpbqUm0vMn/rjpCjoomFLk9QP7+4JSTbHp4BMKQ9Db+XrnanA5OiOnb8VhKjhnuoUYnPi7xQm4N2ltWyGf/6YWS1OlQbjgrbLhystoNqao7IoAECy1C4DcyDSNz6srhvdODtZd30SulWsr/jMb2cPK1CATO9oNIdu72Q+4ma+Nu3sH6scG+tHy6ssFgg1KVE8w/Ui2nRn6ik/XPL2Ua8NqApgKtaV9yLLtDs2uQxDmz+oXRcJ7vsfmRirbTDgHYjAHF6qp6DUS9rPM/b1nRscrO9mDXJOcWs5ROD4jHAMUwnEq33J5lCbug9O2uyJnsbsGvH0KUHXR5jbNaGalfSi80s/bLKD6G14R65KmNooDpf2SQMT/v+UC1J17vCm5FfGCvguTaP/z+BkdVV73BB1hKRZ7scteZy7vKZaFNR0fUxRV7aD1HEywSXzggNJv6U/m7YMMpuiC0lhGgg4QnFYJmcG+2N27JYWbkrPnSOrXm0qGMM000gL4FH7KPG4ADQlFEBXSuXPDsT9iuxCuQGtv7d3+gOx+JBBR7Egq/7Qz
 QIcPB8uy
 bgDPig9/qng+IOozPgs+0mtAJlmqgU93O+ENduudUPO/scSOg0JRVKjY8zbQkGG0KSZALulOElplJuplsguKgCFvAS01OqvPT66TiRUef0zMGvp8fJV5gIXUnWxcHq93IiyjOcz1Q/oDmAMJuEo9ypCQB5XqErNGfTMHH+VvNFjPKb4qUVccj0AQwANdj1sIJhY9cBHNwxROW9ymCnTYqP05pQZXakDvNKl1fb8GXIG7M/NtTE4Eui2Dvivadf9AYjUk31DsVCArd8ZWB1N+7WiAvvtIxQk94UZYzky7Jk+DJfQ2MTHcw665n2LfycKouoPWnoCvTlfpD4P1fXzBJGNDRHA9LlZ3pF+G6TQl9a6pvyMmjOCmqaFeTDfQOuAyT+MUjKc3x9kQTctotyyzNKbF4Ed3DLk80oqxQfJ94nJl0jnhSswm3XP2QKyKkfztmrAiU7BQzdnfDBR/LKuRJ3AHAYUpHf3jw0Hi0vcUoj0v6hnOW92EJd9vByCi/x0ORYtPWMkmG9FOimXnVQbtgmLfERyqovXMXJBnjIPXYHyJkop0KJnyPgUNZcLDgv0+FqmNLn+ujSXoSK1lBcN64p52IpS39h+mMzWDeGqZUDUteG+FHkfNlh+c4EL3Wgm5hrnb71rpTJF3A73YDJjpOr3grPD46ExiV/I7qufgoS14MH9nn0nE0yaBmp5P9zrrdWACpET+ALmrhWUXuY+GdsoY2rvPunI9ASTrUCHWAB+diWtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-22 23:09, Steven Rostedt wrote:
> On Sat, 22 Aug 2026 20:58:15 +0100
> Bradley Morgan <include@grrlz.net> wrote:
> 
>> >Fixes: 6b1c66c9cca9 ("exec_state: relocate dumpable information")
>> >Cc: stable@vger.kernel.org
>> >Assisted-by: Codex:gpt-5
>> 
>> Where's my R-B, nothing changed also, it's V3!!!!
> 
> No need to get so excited ;-)
> 
> Anyway, as there was no change, it should have included your
> Reviewed-by tag, as it will not be automatically added from the
> previous thread.
> 
>> 
>> >Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>> >---
>> >Resending v2
>> 
>> (no! V3!!)
> 
> Right, when resending, it is best to add "[RESEND]" to the subject:
> 
>    [RESEND][PATCH v2] fork: initialize function graph state before 
> copy_exec_state()
> 
> And below the '---' have:
> 
> - Resend to include linux-trace-kernel mailing list.
>   Previous sent patch: 
> https://lore.kernel.org/all/20260822195321.962383-2-Jeremy.Jean@oss.cyber.gouv.fr/
> 
> -- Steve

Oops, I did not know that, sorry.
Do you want me to resend once more, or that's okay?

Jérémy

