Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2A88606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hxozIhHm
Received: by kanga.kvack.org (Postfix)
	id DB8C96B05B5; Tue, 10 Nov 2026 10:55:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D676D6B05B9; Tue, 10 Nov 2026 10:55:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58CB6B05BA; Tue, 10 Nov 2026 10:55:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A369F6B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:55:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7D7516090B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:55:40 +0000 (UTC)
X-FDA: 85419659640.09.0934E25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0E754C000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:55:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hxozIhHm;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794326139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SvIe1dTA5bgP0oOOky8Z1uVZhZTsydnSnODkTILXkXw=;
	b=AunnZP46Bec9BHh1AWLLWxmZ5RQLdzvwHrjVSMH6VVT0ELLUd9hvRZPR+SiPBcjK2pgfT2
	fibdy60vLo1KqF28AsfAqL609mfoOwkU0WqYYzn0sRXaPww5xFlA6V7/qp8+/sz/daZZ5I
	F/HXxBxMZhhIwOqPnBTXG3FW4obt0xI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794326139;
	b=EgsfrLDmslQthGxpRCSDPqJ0mVZpeYNyyu0cM//U4H0GoNHdMaZaRK7lNdv89FFEW8clkB
	SQvEywtASeb8LOJM0sjIxf78LX4abcXRi3no9P1kaXAUPJ5iqExoHECNPwxmk7vCNVtsR1
	suzmuTxoOdADkkh162/uXf+TQ6GAKoU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hxozIhHm;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A19F44D2F;
	Tue, 10 Nov 2026 15:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD06D1F0089F;
	Tue, 10 Nov 2026 15:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794326138;
	bh=SvIe1dTA5bgP0oOOky8Z1uVZhZTsydnSnODkTILXkXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hxozIhHmmpI0orJHynU5GErfujgQcajB7c5xDfVJaCwJou8oudZLuQk/PhicbS0K7
	 XNmgvLHiXxVpurT9ttEcApD8O0aIbqdrPmJHZNjpuRaLyqXmSQ5+Uf32xSIiKjIic0
	 Ic5+0xgvDdFUuxitJ/dzD6YM7jV20SLaKKRi2ebOQPBPACLThIMab3dl3LbKXvLZUz
	 5irq6W8mI0FPPZB7SGVHrNurymQtdA7AXHGWGNoomKzVQFgiiPkAq4bW2qx7B3fFcs
	 pkwz/3s/25vWVBP7mKxlgp5d8PcnhH6WqiIQkZRln0vpFOV8I/KugDXhXFIZ9Qc4qc
	 SvD8pzcRJX39Q==
Date: Tue, 10 Nov 2026 16:55:32 +0100
From: Christian Brauner <brauner@kernel.org>
To: Eneshan Karaca <Eneshan-Karaca@yandex.com>
Cc: kees@kernel.org, rostedt@goodmis.org, viro@zeniv.linux.org.uk, 
	jack@suse.cz, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	jkoolstra@xs4all.nl, farid.m.zakaria@gmail.com, linux-fsdevel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Subject: Re: [RFC PATCH v2] binfmt_misc: add binfmt_misc_select tracepoint
Message-ID: <20261110-gefruchtet-singt-allabendlich-ff8653eb8631@brauner>
References: <20261029185849.8016-1-Eneshan-Karaca@yandex.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261029185849.8016-1-Eneshan-Karaca@yandex.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0E754C000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: e3beqrqmogxkzxp4is1jicw8igatdgss
X-Rspam-User: 
X-HE-Tag: 1794326138-114715
X-HE-Meta: U2FsdGVkX1/tZ23X9BC382r3TfwHklQLt4Ssd211R0nAuRuiskgG0Lnkz8JYeiTTUc7b5kWrHfTFD6Y7QGWMlT/Cyouy0Ja6K0IsIMM/dQC2fkbnJpmXWioR4EYM8+pT9h0NFQFIg0xa5ZprA6aFbpLn3I/6MkiozwIhmV3BjhrYrfokHvnbeTiaanQn77Qad/sZ4ug0g6ITf1snoIhdo0lh2RSqDEfjCkAhh6m6lO6WwGqF3tvHF7WZnI4Y2n99N5BIsvXhnztUhfiU/3IPeNs4dOJgDHSmixW+JIHKDz7qmfKppKEhYexNEBCMf4QcX/yFNVfhfVcs24irGK8/c8XDBi7wEXeTr+sU4DEDOkLsvwN+J8OcsyO1YNTQeDLWCg1/h+4G+GCGuDSRRZOoXmmNmrsION924jonE+Bhp1svp6nnBklVU7EJHG1pxCxLYqVmTGLoEOUINJLpioyZsNSErLsZgfYaq+9NlMgWkvEdgdg2jyC1AoTfPm/YFN+ZkTsrAfwvQGbITEAqYrS1s7shP4FZMwA61ULMrncoUcrKhB60RXbhONlfRJ15upzl/rWuf93+dDZq71/l8F7nbLyGVnLqYEG0KSFnUTi2hpNfESOBqGJcL2MoOKQ8Cht0QFpLVLBaaJb2Ll6J6oWPj6e9nobs1RixMSy+Fz3t9dQKLG55IRPxpuWwuqLA6mWB658PnRHp+0IrAMFePOVZKYFLgQG97YopnsUNmE+umVPsCzVI2ImrTRhay6emXM9NtQlKtdW5JDRxFB+sPTG4jLcJdZbte9bFjC+Ajyy1/XDliF4i1y/SEw+72n46jW+MRqCORJG+Rk3v9SB4EuYc4cP9xel3VXXpL/2X7zBk/u7ysPCnScmiR7EJwJS5bG4SX8mPJw/ec5+z84m4IJIn5KZ1OXad4jxNJ9wFheYNfAlEWWq0La/LJ67lrF1o5iy0U9A4qNN5SKIpRpoETff
 MW8mMmVB
 klRymf7XDaAlWgmY9hrnIuIMmuBc+2l7lq3Qh6O/KyXlwj1h5bpIHEZ5DKCY78tOelk4vXDjcJY2fBdAjZ0VvGEArUAx3Hfz4387pJGo/iTPs3GNEWwd1CNhEx1ENgEAJfQkmrsCAHVGn7BdN182DVNKCpeodQE5dh4RuqB6dPBUzc/rtxzElEU8omWZt+ua2Bo4lZYcIVo4cEHuffLn/i/hzz62uME8VuQHujJ9WUfWHLmDLoEsesHO7IoWHAU8+4ER5Yjyx6nh4+G61O4ZwbUYD2dpgefjcjljaNoPJ16mx6XqWPr3RdKfyGBD7/zaP8Nwwv+x6AcMlqG2l2OVIGtPVAxGWyv4ayxYA7/KUHLLx90oLg/32Xgg1LLgajLZJYxPohgZpsCc0nhIpdcRvtQ54q/3+Gk35yvfyHn7Gfa4xszP3MgHq2vasjl9v2bLNIEpv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 09:58:49PM +0300, Eneshan Karaca wrote:
> From: Eneshan Erdoğan Karaca <BoxStrikesTeam@proton.me>
> 
> A binfmt_misc entry can select an interpreter for an exec.  With a BPF
> 'B' handler, that selection can be made by a BPF struct_ops program.
> The kernel commits the decision in bprm->interp and bprm->flags, but it
> does not emit an event at the selection point.
> 
> Existing observers have to reconstruct the decision from
> /proc/PID/exe, AT_EXECFD, AT_FLAGS, or /proc/PID/maps.  These sources
> are mode-dependent: a transparent dispatch still reports the original
> binary in /proc/PID/exe, and a short-lived process can exit before the
> observer reads it.  A classic dispatch reports the interpreter, but
> not which handler selected it or which invocation flags were used.
> 
> Add a tracepoint after the interpreter and the invocation flags are
> selected.  The caller passes the matched entry and the raw flags; the
> trace event resolves the handler name and masks the flags with
> MISC_FMT_INVOCATION_FLAGS.  The event reports the binary filename, the
> selected interpreter, the handler name, the invocation flags, and the
> pid.
> 
> The tracepoint is observability only; it does not change exec
> behavior.
> 
> Assisted-by: LLM
> Signed-off-by: Eneshan Erdoğan Karaca <BoxStrikesTeam@proton.me>
> ---

This is whitespace damaged. So Sashiko can't look at it.
Resend it properly, please.

