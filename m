Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE1EDCD6E57
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:20:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F05976B03C5; Mon,  1 Jun 2026 10:20:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6596B03C7; Mon,  1 Jun 2026 10:20:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA4626B03C8; Mon,  1 Jun 2026 10:20:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5C776B03C5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:20:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77BF7A06BC
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:20:03 +0000 (UTC)
X-FDA: 84831553086.02.5A36FBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D17EE40012
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:20:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aBxSk4mH;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780323601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UOzybEzeLExkH9mUl9oBfp93NZv2EoV0lRz4YiNg45Y=;
	b=uAoRAaarKDMlBUyh3krSVcAw5ktS7PrGxRjNntIEuwj/4yW+I+wM4//Dr1h7uJCwDlGlnB
	nvmMrLcK9bHnJsA/WtZ4Xb03svRMei3L0w24FC2GEMJCk5m4M0/UTJ5AUyHkDcxgsIrBcy
	hjjEuw6Cuf8iaYv+d8S1wiZB8EG4Lxg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780323601; a=rsa-sha256;
	cv=none;
	b=XJtTVc5bWmv/cROVhjvjeJPLeyMPgP/JZMQ8nI6sFlvuAlpQkQtsZUSoH4J1ABsnFtZ1f7
	PbxKEySApqahc1ujm113JBcpPEi8L7XjZV3t/wofKqx+ERkU8QIF/N5+GWHAdMR6Sq4vCG
	4G0PcLQnFmmWBNkTTV5CQZ/SOFPIjZo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aBxSk4mH;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 19E0440AE9;
	Mon,  1 Jun 2026 14:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8611F00893;
	Mon,  1 Jun 2026 14:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780323601;
	bh=UOzybEzeLExkH9mUl9oBfp93NZv2EoV0lRz4YiNg45Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=aBxSk4mHUoODPHO12PREt7EgMTEXEXpHHJMcvZe3Vj+AIchbsf4rNiraqBIyY6eX1
	 2lIPQiH14ZViB/aO962wV/vfy2NPH5cUJNjbg4Ueb+xFdvhfkoqf4C/0LmHee76TPw
	 G1y7++6qdg4AhI5A44YjrrmPBR4TBL+6BrlMjWCdFXRP22vxxThNpHfDx5LwxHNOTb
	 6rqVRRP/vSRSya8f84xsWMqmbd/4DhaxZKbnXzCjvTBl+gbBCkPkG88joWnHnS5o/L
	 lnX3Wg28hqTzwxADnDOMWa93KPLkugVqAmXGl5IAUJfJUU0fxBhNcZ07/Jw6CsU6b+
	 05evwhABEcYyA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  skhan@linuxfoundation.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  corbet@lwn.net,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  skhawaja@google.com,
  graf@amazon.com
Subject: Re: [PATCH v4 12/13] selftests/liveupdate: Add stress-sessions
 kexec test
In-Reply-To: <20260530221938.115978-13-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 30 May 2026 22:19:37 +0000")
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
	<20260530221938.115978-13-pasha.tatashin@soleen.com>
Date: Mon, 01 Jun 2026 16:19:57 +0200
Message-ID: <2vxz33z6filu.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: D17EE40012
X-Stat-Signature: o5yhp6fbcgrqipfrjdderck8f9ssthwo
X-Rspamd-Server: rspam06
X-HE-Tag: 1780323601-526222
X-HE-Meta: U2FsdGVkX1+uq1NeDpoigy+2M/nnHiJ3cCGIzeopwnVcxpRqYkAc/OQg8b9wwWxZhpAxcqd5BJ/aVt7oqYyFshY22rftaSsDStay/Qof24xmlvir4F85KTrfhdMs+r/SAxew83+gKlpDBiSESg1vEFZ6xk6/rX1hqGRjdQo+kgbNMKCVYnPuD+Y0Z1pmn+r49t1sfANohgY1yXbP69vYqW7ZvpLWM8x/moropIvbFZBVG2kI5rJXx9eaqm5DeJ5DI9jOvMjAQAKD8KJUs+ixvjm795+6CeGjfYZm2T5TmINphTgrrGgNWJ2wYQo7THqYHgL6ktOKm/B7bvXRWiLsc0KquNHm/Fp40grJrKyRJzx2QM5hLEpsfkSemVUcsrjezFOXzi1BLNLTXVhQ5q+yD7hzLJg0/NEVitNiz7vjFiRk2h040ktMAc5ZznBPJubpaJwojNDG9z6rcvMDiu3DttCJApOAP09yH3K2SlYe7kw+QOt+KN6lAxEC39CRVdiXlLlB+r7z5SqzP3aEfJRSRqTlTQQK6aPUgC1mo3yo/C2lEA1hhrt74tigfMnv0ps4fZxZiMLV7SRposxtgAjds9GAjXVQQ5Kdf1JK4hYc+OG9LF/F51BN5jZALm8OhhxecvR2SLx4AsSxSbdudQQzaCMFEs0rWwmkUDgvwYvDjG/rtbGJElYUQNQmAs4NZF7gFWvnDz+WldDB/n2oDfzAlk7ydSGf8eqjV5eOeOFhBUA5ZPV31HwGMUrX/sgV/UZhfm+naSxr+Yn65IkGw60PNC6zas+JQKHTmrRCKkwKzQCsApmFr5FBzlR6y1ad0UHEUCS6FZXKpFu1w4nF1Ty8VkRVP0Hfm0SXob74PQbyGNMSpJHPTl5eWMddxzrGnAR0INvLP6sIrCZ9uwcAGWr1BUfPYZp5hzudTZYDcVoMcDl1yKYaV8wsBmH5UD2qjL5vc5ZNT0uV0G5YVTtX9vQ
 W6bU3tM8
 EM8Do/Pbo1UhDSK0xtmBsJVZma1gMc4VfZgMdzv8EEKTd2lk4NTyGl9wcqNA9KDd4fX5SP/iWWNErlIyWeBB5wWUdA1yUcZo6JXy7KzdI6ER7O9qEISEKTAzox8USwKWrD2u8tTIG0yDBB6Zpu4qfq6lXxncC8R8GHQcklKJjL0PuXJILw17xqwdxQc0FipAjLK1NelR2Sobup50XWyga3QEVtu5kogZIo0N7D2fFWWiGliekgy4JUtPosA0iNymaVqU8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30 2026, Pasha Tatashin wrote:

> Add a new test that creates 2000 LUO sessions before a kexec
> reboot and verifies their presence after the reboot. This ensures
> that the linked-block serialization mechanism works correctly for
> a large number of sessions.
>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

