Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82BD0C5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 08:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE9006B0401; Tue,  2 Jun 2026 04:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99936B0404; Tue,  2 Jun 2026 04:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B897D6B0405; Tue,  2 Jun 2026 04:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7F2B6B0401
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:13:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B3B940536
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:13:59 +0000 (UTC)
X-FDA: 84834259398.03.C0B35C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C049110000F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:13:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HiiL4MDo;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780388037;
	b=mREMvvQlpjW9vzOvcIwH4lFnoCaa7R3oxwEu6TYR5RBqQItHGOyM3aYUgW+HA7U4BWobuG
	g8+v7Xnl8n+7d66FdB2gnvpI+kg2znhA8kYb5AkXkFal6uA3/apb0vZipxK7unxANWX720
	lW3Pjmdn2ZmrL6UjX+92v7NF+Z7D19Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HiiL4MDo;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780388037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z1/GsCfRVNHOJEA6izSI1fELICv3oclmjsMXfZuvbdI=;
	b=jSqBDmUdldAqzjZfR7EAoOiEPbVjOB5OsNY22epbli6EICYeDYcbRKcz5q5TZ4lIOsNkiC
	G4YrMXrWNz424E1sLOv+4X5sANjWoKyhmJW6ZzsI2VCqQ70evKI1hVjxZzhLE4tWF9dsPU
	OCL/VkklfcTUK5NN2KDKKw+/1KZcXcM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5AC4360120;
	Tue,  2 Jun 2026 08:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7D81F00898;
	Tue,  2 Jun 2026 08:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780388037;
	bh=z1/GsCfRVNHOJEA6izSI1fELICv3oclmjsMXfZuvbdI=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=HiiL4MDooxKbk4zL5IfetQScDfo9p+gaoxWVoalB3YTSTvLSYN7i626/UbbekXXz+
	 t0CPy29ulPj5SHa9SSWcoHy3KRVHek7ttrSGlVQhbSDZsfpnvfYdZGNHqJmyPYmFuv
	 EjbtgI+Lt6k40LdPaxhhru9eNB39BwwsNGt6uWEQ/6p6HeS67ap5fUoPMMqbn+G4/0
	 gnNXw8m+1fKE9Y+4FPP5wS7Z4owmJf0rg3tO3/8Snd/vs3ahJDsCwmLPFAB+95nsGm
	 CVRVXZxC0SybfZCW6X4YUbOeGhse+KV5Ms7rm+TICefsrH9iXdF0p6Rk9Jqj6c0yPW
	 Tt2SjBEuPJbZQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 08/13] liveupdate: defer session block allocation
 and PA setting
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
 akpm@linux-foundation.org, linux-mm@kvack.org, skhan@linuxfoundation.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, 
 dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
 skhawaja@google.com, graf@amazon.com
In-Reply-To: <20260530221938.115978-9-pasha.tatashin@soleen.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
 <20260530221938.115978-9-pasha.tatashin@soleen.com>
Date: Tue, 02 Jun 2026 11:13:34 +0300
Message-Id: <178038801492.119771.3419366349068848854.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: C049110000F
X-Stat-Signature: d1yfj8fzpazib1fr6us1yc4i336u8645
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780388037-924634
X-HE-Meta: U2FsdGVkX18GPCoCC4N6L7nj0I/VKEsPKkdK480kZGdMQSkfyaZPjaafa4WyR/vAe8T+nJtuWi2+qvvDo0UWysKJE/2RSo8rN8duTzY0Xc2FKalXtATHRPhL6HedNMUT3FuXkLxw5K6V2hIwb2kGy3DOp6PQ4csBZDkcVEfDyazBgpXWXUVl2wdfKnGxhMcO59shTir/gssq6TOsb/90dOxWaPQXIv2/nEM8u4ZbCj2zvGJhKC49VZE1tLVG2KG6B41dcFXhapkbfrNgNF+6gDwc/5b12rnITSjAbIWvQ/yHdqfrOe6FKUmKhmgPW7rGSs7UWERNpA9v+7i/pkw9QVLWGRpMmfWfFncINmc2Cd/TCtoe7qiCFt92Wf6ocVZEok99Ez5E1VLkF/9Dxjk93vktzHtQR9FOJFGjWpNhhEgYgJH7Ub5+2W1s0uRQbUXWwzNlWCW1HBJ7l1BCoWoNHH//e++AL1TDOWbNx4QZpqVYW6G7y+PvQnhUPLyQXaBrfvQjcCJN3F2cwLkScnA0828KDyiDsHtWsmZJmm453GS1SnHHwH5OQaoSPr/N88sA9zkz98L4x1Zo69wMFj+djn0a+q68D9ig4V8bMCAtMSUSYfWwPs2CQXmCY64Z9843isgzgA/wFweutabH/o+rUYdSXPFrlIQME1X6MtRZBCXzRs1knCsaNkxVGOFy50aszbiwKsqmukfgP6AJu1XucELbY2TWXQN2HdswABYnHB3CnZ+08Gm2+TeHIGW5RR3NIo96uVYOKAyGFGfsnnE+D6sKx0TfuwhHv0xtzwACKBBw/H/9VLtE2TYW8TcSrx+kdlsaZHOwBmZWbuetDmUlDlQvq2dh40TJFX0TM46GrEsvQplAMFRR/aNWlLuczAsjEoFB5gy599iY9KHZAmXQ7jyUICaGAVG8IXrqqGug9WHZWqBMENKpt/mzeaYykxLovKEGUti41bvdtrfp8Hm
 JyWs+8po
 mBialzMhUiTjjN5NIt5HUowynFc/b/qbcDIHJrLnnqdnqqy05E8ZvltdDBecECTY+qJwnX8EDbqA1AAWt1mvbEsF9b712Cx9hAEsDGsF15xq9qBqnpEcBPGa7U9FFNd4eiGY34v1T8wAuJzXDswZpIkyqMsJ2goq90N7jYtfNjP+u8LRhI5V6UjIWjrgcwwhd+5Cgxec3ZggWZVXyJmhmdxO1G6f6oQaQsM52ROodHO+F2qItHrjE+w7zCOLZ5YXpHxxV9Nak5kPjBZkK6dxlf56fDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 30 May 2026 22:19:33 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> Currently, luo_session_setup_outgoing() allocates the session block and

"liveupdate: defer session block allocation and PA setting"

PA as "Public Assistance"? ;-)

Let's spell it out.

-- 
Sincerely yours,
Mike.


