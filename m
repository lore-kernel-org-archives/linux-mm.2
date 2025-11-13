Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80DFCCD6E54
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 19:11:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E25C38E000D; Thu, 13 Nov 2025 14:11:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFCE18E0002; Thu, 13 Nov 2025 14:11:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3A0A8E000D; Thu, 13 Nov 2025 14:11:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C294E8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:11:45 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9506A160B2D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:11:45 +0000 (UTC)
X-FDA: 84106528170.09.9725EAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id DEBFDA0009
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:11:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oitpd3Zd;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763061103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pcy7aYn9MZVC2xGd6TvPK827i6h6zbrDqlhj+OgNpow=;
	b=GErhb9pfxrpgczWMU7821VEkRNV9WqIv1xOpUa6bJ4Csf6m7kfnGpEaV/ohyJOdjrRQlKg
	qEahYY+dXy9PstVPMj7mTEnGF/ZIayF2tK3Ng/gz/ULIIr+S2SQoID2aj/8/6z/fNk8bZc
	tv6nkGRJHCexLAp5YOoChgkdvRlC1PQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oitpd3Zd;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763061103; a=rsa-sha256;
	cv=none;
	b=vtZEQKlhYGS4VVsgrAMB1wjaLdH7Vcmjf6l8GbEpZnKhObKJdWEtkxi/55khWASwCamH1m
	BOHMDFWzyY/Peio/xzmtfRuLdPc0Mg6cFqJ6Yw3HUEFTIfYQVALwqlT+grwLiVDYPkuDRZ
	50ZqplG1ooOoK2WIHoQevlMYdkLgnhg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0857D60103;
	Thu, 13 Nov 2025 19:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED57C4CEF7;
	Thu, 13 Nov 2025 19:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763061102;
	bh=XPlHEOw1uPJQDazcMEywsx61CVGNF/VpjcTn8wMkkCo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Oitpd3ZdicpxqLH3v5bMK5Dlw1A1IeaK/f+tMTgfSeNLv6snibjasCa8fSqZIGDFS
	 ilaoa+y3l2jQcb+qTJocZRgmlzNYJaDn3EAu9DGDHd/qKIxK0tmkyjhU2Txd2cqisv
	 aNhkpdWedumHkSV5hFInFMMbkv3zrJuy4L/pysJQMAwj2LyuHGxfPnws2ZY1hL6Cwa
	 V1Ic0ZewDvDwdHjuxn5G151CvWFhEP6vH3mkDkXNug+MjJ0B4RzaKCWG0UOQtkjWVF
	 lSaCMtY9s73rD13zCeObAXRd10IO48NtEimwc7JrnRCNLaeilmBAOmnUfHvaE+uupq
	 eH2Mloms0G7lA==
Message-ID: <ae87f1fe-b107-4589-bde5-21c9f3e8f816@kernel.org>
Date: Thu, 13 Nov 2025 20:11:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/22] mm: Move the fallback definitions of pXXp_get()
To: Samuel Holland <samuel.holland@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org
Cc: devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
 Emil Renner Berthing <kernel@esmil.dk>, Rob Herring <robh+dt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-6-samuel.holland@sifive.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251113014656.2605447-6-samuel.holland@sifive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DEBFDA0009
X-Stat-Signature: h6na5pnhbr37rbipcarcjouazfp1q853
X-Rspam-User: 
X-HE-Tag: 1763061103-989615
X-HE-Meta: U2FsdGVkX18DMVfuhYdCBS95vQ9cLmaSPJgHOnQPC8omho3g4OTOTKrVPI9GCuQumjXmHfyNIhqRR+e+93y3xWNbtx+zYuPuXNGIJMiJXHg4A24xX2vlKKYsG7s4V8BMXARcWN6IRjBtqm2QNlmeoXCGQ19jJze8MgtBCPFJGPdOZaNlN7JBihN170rs8oXIhreUaOCg7oePV8TLX0ZMVhTgkJ+UirK9LoeRgy8s7+SAUVPYGdVC//fXx6NZx+3dVomZnVLzelXZSOR5HOzTO4GBk7qzP9srBRxYNXC16F73UZqhMgKI9oeLkO9ua2UZ0/XllJI5pGeoMfi+Q0zXlPZgYdo2M/TgYjRJNvvK+6MU3K57flGvJb2ypUBGvbDqzbXN/H4kffjPd9LdHyvFTcTytul1RbYsNm7+eCUveUzvpExamGu4g3LrCfdd18rHcfQ5XPEynI5J6sdU5784IFC+VpCzMdYU93tnt4WcNuq8BlSrv7IVTDv3VlCh1kGVNv+6lx8tGGSkYCiyMLRZRQ4ohvF91SkfTSAhiT2/6jssIt+OPXQKvTCAwp6DwklDg4I4E5sgaW/KpPOPOw68xYIZWDqfJ7vTNOXUTdP/NdIvxqIxgtDtkKdgYLsfljr5SYauKMfawNoivbiiG9bAAyrR2bKbtnF1x/LQBWC1TqUGpCI3nXPo8ttswzwh4Ji0uNWq8ExFmYkSOygxTuMYiBYIjPLLE8giw7LKrecpPthJpIUkwD59/uj426EVLkQ1ZS9EKvg/GhDT+8FO6/bXz0bGBQjUER2FiHSVa0fApFrEodDuHZAKVOwB38i59e0/bWAzdZLXX79GeGUEoaGi+bgflY86yORKrZWrn37sOa5W6awQ3ywFbJbL5T/jlD9oaVDWFEAZOStbeeTO7bzZWnyUY4B7QF+cGsj94A5mRquxi5VwfuwI9nWnM8FfFZ+gcr3NUu5oTUy45P1Zkpf
 e1ErPy6h
 ie+zSXm8z1y4Bt3SnWG18AeOe32HRG3ZxuSZz/CAV/queKG2j8BDGNHdAtCXkenW91MIlUvYu3aihjl8+UwMXzFDrkBWzVlMlu0scrHeRAFqF6UVGQo9x2tNKolA7bfcdCJgeEz4WHLzqUPJ3tyu2VASiN3PDsQRxziIniwbG1FNQLAS3LwYItE2M5vMC/ZIVPl0r0lZ+NjCq8cw0nNwkQfbNPkMaB1dsBQ+rJPfFlT7DJjk1hhBU5JyVsFeI3wX0kAB3Yyz/tHD6rebdSQmTBiGlYeNT0aAGDs5YFbHoTN26+q6ulrE95MFeEdCts3gHwePwJ/NBGg6VpjAIHD1K4+77rTmALqllisb8uSKHbEKYfM2zbPmubZiovGAMZbBscb7UrEdBcRVk2ABq6se4zsWgpPjp7J6bH9AXRLEQb8mvZHFJcDec/t5Aoh33XYrd46moKSgFWFCfRzSV5iL6YofkOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.11.25 02:45, Samuel Holland wrote:
> Some platforms need to fix up the values when reading or writing page
> tables. Because of this, the accessors must always be used; it is not
> valid to simply dereference a pXX_t pointer.
> 
> Move these definitions up by a few lines, so they will be in scope
> everywhere that currently dereferences a pXX_t pointer.
> 
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

