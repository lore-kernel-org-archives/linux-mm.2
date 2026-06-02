Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 258D2C5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 08:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56E4E6B03F0; Tue,  2 Jun 2026 04:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51F3C6B03F1; Tue,  2 Jun 2026 04:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 434E86B03F2; Tue,  2 Jun 2026 04:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 323776B03F0
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:13:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C91971405AF
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:13:44 +0000 (UTC)
X-FDA: 84834258768.06.8B022D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2AA6814000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:13:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bpa1KuA5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780388023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBkjXMTmjLYTnOUwfnks3EFmZB9pPlPFfyMtmk7cI3U=;
	b=f8MVYHUPd20TPNfiQn/NWL58sRWuxzC0yvo4/K3/bpfaTQtEeL+ikuQFmWUpLv7Ul/XVdM
	q/5K7bTqZ425wKbA2qxPtOdy5zQaGfVZ3KWCScFiOYT64Mx6Ii7AH4pd3XXwfGMkmKWpgY
	Hspq5qehtN+UJFJSA/7hfPD4mjQ2898=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bpa1KuA5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780388023;
	b=zDz4kOf7VOwtmqDnKLXU7V58nzsPck8ClcgYBS3ZktNzfRT7AXv/K8gzZiOHmrQHPmpq6r
	S2G3tok/HTPgQT2k7nlcqWUYQsljCbhv3AQi0oWI4/KbKGOC9Z5EqAtCgdnRMZaf1QKVmM
	QVwVnoxp089jXK0NnFd5iNKS00OlBbo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A21016008A;
	Tue,  2 Jun 2026 08:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3AD1F00893;
	Tue,  2 Jun 2026 08:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780388022;
	bh=dBkjXMTmjLYTnOUwfnks3EFmZB9pPlPFfyMtmk7cI3U=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Bpa1KuA5WsCD66AasZ0sl3TPcc1/4v3KFLp4MBWQ3V/DKp9IxKexcZETomuPehqTH
	 oW7AjhG5pIG0+1zPLNhQr1BDSRpxy0OXJLhEu054Dk67FXWjHvCzfw+yOu7ZSXp9WJ
	 TTMEJZlPB80bvMNID92SiC2lb+b5+MbERApA9AM+sYZsv/xvWNdPNt0RFDlZv4BH8G
	 0lubNHY31s9XSrUDOq0nXy9XEegapfFje+0pK4oRel7PqRqFxQ640yWxWQRe5qEHCX
	 dElzNPk+Fbugx4/pfXDfPeoWC4gg0nTxxb7+/9VvEPJNz0qQnr4IzF0xJ68T7cSaa0
	 DoWuzoVX7NVSw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 01/13] liveupdate: change file_set->count type to
 u64 for type safety
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
 akpm@linux-foundation.org, linux-mm@kvack.org, skhan@linuxfoundation.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, 
 dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
 skhawaja@google.com, graf@amazon.com
In-Reply-To: <20260530221938.115978-2-pasha.tatashin@soleen.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
 <20260530221938.115978-2-pasha.tatashin@soleen.com>
Date: Tue, 02 Jun 2026 11:13:34 +0300
Message-Id: <178038801483.119771.5551368813719436713.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2AA6814000A
X-Stat-Signature: kydm5ey95iakma5mg5ajhpj3ngibppdk
X-Rspam-User: 
X-HE-Tag: 1780388023-759552
X-HE-Meta: U2FsdGVkX198P4jKp3LSb19GWwt9NDc4q6dCR7PTOWpqCSdEFIKlgp1DRuscCtMm4OxFfADOZihDCr5BACUiyRzLvoSIKPlxv0ZKH/YfuQ7ogxw8BZr29QvNhB+EGcRlEMBRvq5G2hESGogVsV/amDUQG5fgLjBgNNnf+RKHq7d6DO/H+P9jswETS72QivVusyFJXy3KMjCusTIIuf7kPd21G4Wf0ovF7/AfE70aANA7ZzJqLaFCExYQU4P7VUgLkuEXun5cgefIEr2qQrDXmj1fZEFVVRtA7TTILd9hcVgS5cPPXwYeXvd8ZofprN/lSScpir5Vs/6njVRmtPPo8KOxY/wRUeUXauf9VgfwUXiz4tj3dy6cwksc8dt88+82sBW4QZFrJuT9dUsg3yfnpXnNf9W6J2EhZiTy2RjeaFl1KYEuj+M2INmOfwJ3en2SjQaoKKa779Tcl4rf/idkgMJYMDcUUHE/s+fxu+cK+yOhota03qa74AF0hUuz0W1UM755chGLUO7GCFpU0lsushg9/0F2c3CB/lP0vF54QfusCpf5q29uZdyMokgvGbSvSmK3S2brZh1thZL/An7ak0bk6yF82n2O+cRNSw7Hp1O5l0ERXue4U4SUh3sPNu+PdAlM6qHdbCOUAZMk+uNriq4CzHk1mFocksLFpETOXv8ATwIDnZXZatL3FhhLkZAD6jrJzG3eBvAFsp/3ddpkMgdEkcXMkFyQl5/uCYz86cqzPsNIYeIbOdMD6H1Pg2bdS3jpJl+GTJzdEmW3W33CA1Ypy795iqqqfmdf94Lapig+NLRNnvbPZ6hbl1KWLeCljLHcGJJoOtaXIdRYamr1nvtx2sI9ETa/R9VEPEtrqjMSBHTQpmPP8ON6o+Td6Xr6E+QTEk4/PfNSr3Q1S8lGBrcgeBA54Bv3olODWP+oGxv2BUUwtK+sdl1sohkpZcJm6+cKpzVMFi5AHL+FL2u
 0sIFwFdl
 rAQQqkNAt8aCFJr0eAHAuQxcGWPK1ouGpWnZHbPWP7ryiauBgiMtKkjuJMBIsht79y14TDkZs35IzJFtVtYsuneeoaZKP8u1x47bw4376bss+4PYFueuPo5I4ZK2/LkPnkBy2bnhKQ1cahrblRnB0PlafeWCQWRGK2V36i7It7coRc5hdZJAygEITAvSnV79vZW4QFq9FvUWyy6sdPjMdaxeDihiCOw+JDHOFZOZkcvKow6f9RMGAlIIXfnGHEa7nGu3r3owQXMeFrGrJ0Xy/gp7HJhQtq3gjNXx4gZUkiQ98tbvHJoE4UkYTygspllry4x3aNlguzvaNa3+O/m47az0PyzHVlGcts852
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 30 May 2026 22:19:26 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> This improves type safety and aligns the in-memory file_set->count with
> the serialized count type. It avoids potential truncation or sign
> conversion mismatch issues.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


