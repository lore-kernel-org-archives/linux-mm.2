Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0E41CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 11:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12C4C6B00AC; Tue,  2 Jun 2026 07:16:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DDBA6B00B3; Tue,  2 Jun 2026 07:16:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F35226B00B7; Tue,  2 Jun 2026 07:16:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E5D086B00AC
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:16:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 55E0B1A0858
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:16:43 +0000 (UTC)
X-FDA: 84834719886.16.4CF965B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id AEF5E1A000E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:16:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=omq+JQrn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780399001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHHmOMUhMrD6elLCrpUvk78XIsoPIyxDYx0ELO8iAa4=;
	b=tWFEVikmfHG2Saa3IzV+PILLs3bIaZu0yr1W/34xuRFTTxaxZWFpYoBMlzuOXH2wkT07fT
	xc5nyu8ryuaNq11cK224G+eJ8vbAsifvxgJ6SJEOYe3bUG97tjaDn+XOd40lP6kYxCKX8y
	oW3xqPpnujxoAevwz5dulwCJtPhlu2A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=omq+JQrn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780399001;
	b=F76trmibEQrxT5MCkUb9Qd2bGjSj6fmNpz0tU8eTy3PbwwNWPtd7zMsETnM1CKbl39Pn6i
	v9l9pcEq4H1/GkfGrIUAWY5Q/o1MpjoM5qA7KjfIZ9CaOfWt5WPezMOHFaxWHbm3DyEYV5
	egmbGLXkyKae1ZYqddzjw/lRQYrmGK4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE99B40C4A;
	Tue,  2 Jun 2026 11:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496771F00893;
	Tue,  2 Jun 2026 11:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780399000;
	bh=NHHmOMUhMrD6elLCrpUvk78XIsoPIyxDYx0ELO8iAa4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=omq+JQrn5ALhrOzX+8Eq3bw1JR9J/OISKf1HWndsuAVSS4v8L3usY6Crc7kYbxXf1
	 ckF4MsSvEAnMhhsFAfItS5oh/mojUDhbaPExXT4uL7COhJEr3Oifskoe59NuwIyt3S
	 BqZaGsoMKgREFWCCxCvLw6g1JOMBEYUdF7O2H5Psiyjb3kotDTUTHHokwntSiIgjEk
	 Ze/NXJ6tWsSYEHpjmMMND0CZBLchifQiEeXZFHWZYg3932emOQ5XMXerkpCPIFS3iB
	 xPC/axf2451bSZgedbp2rPMLsBsGXHlY37ytw403P1rXZI16QK/3a7MTLAVQtLBTiE
	 jZCuVkAFwChRQ==
Date: Tue, 2 Jun 2026 14:16:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: add testing ABI documents for mm
Message-ID: <ah67kYgt8mmFPPUA@kernel.org>
References: <20260601235506.85123-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601235506.85123-1-sj@kernel.org>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: mpz91f3gp95a8biusyfko76f9911mpyd
X-Rspamd-Queue-Id: AEF5E1A000E
X-HE-Tag: 1780399001-491782
X-HE-Meta: U2FsdGVkX18AaRdihGVbhagjR3pgRj9wNPWmPJzTXE0+RNVqymhGQ668fTmmDzWlxUdNrMa9aKtbqGM0HwBbMvPIiNFJmOvMRrENqnlHxwZ9qtm6ZwEqh61033mC4u7wHzfZ5lyi8u+jHy/ZAutAUTh1PDYQuWPw1XRn5jP+VOYKE1Y5z0YmMio9SlT9KptWxmrbwJOqXIabTy2kqddSq6rjrzgkam//mQ3BBIJjVeAGvWge+Y7ueC3cpLKDz4H5S0gUO/lIWnK4x3AwAF4ZjhsRTeP3UAJ/5GKj8w77rik3tyrPKmWFvgL5iEwcL8UrX4nFswmYvKksP3KOOc1j8QzT7t4JQt4WnAC7MHoo+VvN1rIG6mjG5YYRnfsZTRZQLyz2+eRJVFYIVvHBAO2Bs+sHeO90pw7CaMlqKxxI7iQFO3c6FzNYt0BCrYDdjWQ65jAE7iHQskyMSV9fWaIAGTbE9ZhOuN03kpEXj5ey+IKjqjRi0gmDe3Fjb7PImSqoq/SzIxcQj5XerhQA4M02iAudQ+TA9PAFr/mcW41tZCypwXTaULVDaw4PgJ2W7z49yHrkZX0G97eTFPugLlg1A1h7f34JgkK70agtB4RXIBq3nRghYy+6i9GxLZ9iIcut6nDhopBFFmfXle+yJ7R4lPuPI51dWyYY61MSpSmjpakMgxGi8a3khbKpvf1DWlEkov44zFzLBX7F8ZLeUAAkUgdRngS8DWZ4ZY3ZDdMPfp6kSiAfAclDZEtvnp9wlyhi75tGmP/2tiVfM8kOlAouNhLxwfUCaCp1QHK1Ufw+L8PS8xv+WeJUZKTXbL9px47Hczjp6GlqEHSF1btq+B/VTuraszr44hMNszqxN9TTihAtAfQ/Bt1zLpDOd4Wuh27I2qYlI7hmAdh+5tQUUgQdA57CZwirLwbzHz0W1IzMOxW0E7MFlxXye/W72XwJT3U/EHJ8ezlIEvIhQIsUIF4
 mNO+bgug
 GmmBtH/1coYS3YfV8ls4nvM5Ycc6fdF5U0fCZs8xOhSXUnhymGe9bc7NhSDB2/L9PAygkCOxlLhRZpqeJA74uqrc1tPihAY/CeoGZqiEcR3e96U9ftYDe8EERTAtcirLzIO1vo88PcD9KAVK3N1Qd7DcZAdk3ugzq2yevXy6+LIwapHlcyTtq0Y+cEeZmhvMq8medhhMXdFjpW8+KIhj6UYNxQ1WONSwjfwnpUVAdeuRJLu8fVLepOCYKo4wesGboSeuiKWtIjq7+jcnDaIZVrK8SnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 04:55:04PM -0700, SeongJae Park wrote:
> A few mm subsystem entries in MAINTAINERS are missing their testing ABI
> documents.  Add those.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: SeongJae Park <sj@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> Changes from RFC
> - rfc: https://lore.kernel.org/20260530011852.90663-1-sj@kernel.org
> - clarify it is "testing" ABI.
> - Collect A-b and R-b tags from David and Lorenzo, repsectively.
> - Drop RFC tag.
> 
>  MAINTAINERS | 9 +++++++++
>  1 file changed, 9 insertions(+)

-- 
Sincerely yours,
Mike.

