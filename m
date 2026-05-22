Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ED98CD4F5B
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 10:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AB036B0093; Fri, 22 May 2026 06:44:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 734F26B0098; Fri, 22 May 2026 06:44:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623BB6B0099; Fri, 22 May 2026 06:44:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C1A16B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:44:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 031A51618EB
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:44:32 +0000 (UTC)
X-FDA: 84794722026.01.A52FC13
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 23077140005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:44:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="C2ri6T/l";
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779446671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SfJang+TZTQLqk7DZIpUWZVG9tUIbmUt1GUpAMl7Gjw=;
	b=A2K5s4W6K+KA/ByQKtzTybbkGc7uE0sLvmyrgnF2G4lr/r690Z0aoZConJWR0jtBUG+fiS
	psAWF+LAmpqqv4c2iybPFIM1PaAPKbpsrRfSc4DGo81BaYka2qXDRNIKNX1j1iKxx8DeeH
	bLw/CcHiiy9/LaTO9rIe4jqNUSuaBXE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="C2ri6T/l";
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779446671; a=rsa-sha256;
	cv=none;
	b=MfeDkBcNz6RCR4LeOglTbA4HHcqRn05Sp+tB8VkCHSKEthCJVdaoS5KUvf7dmhgmfse4Va
	2rCmW0KdguirK3LH/D1hFd2EgzqAlDfV069laVFeSV5AILF4w4ksFziGYFdYHHidcczxbX
	kEaHm4d17qHi8Aj1W2VL0O1UphmV1Z4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 946D760172
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8D11F00ADE
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779446670;
	bh=SfJang+TZTQLqk7DZIpUWZVG9tUIbmUt1GUpAMl7Gjw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=C2ri6T/lqtjuD9OHMmpf94hQHlmIQTvApEiao4VOX9rNrls/ayInYr+Ch9rqqnG4x
	 URrDgEkhj0xEqW/YnO+7v7GSaq8d+9mDPXNyQtcDUTxb5NXEo26XgqaztsFrT1XogP
	 nTCA7JKxGiHlo4bDHeBr5cf56qegszX7XvnKmZ1oMmBjgZHjoKhubo02LmFz/wGn1b
	 KVa8/6AMK2GkJQcSxcsuQzzFSGAsu7BH06eHMP4whbql2sPJL+IpfGjgfsZvfr5xpI
	 2tzQ75yX0OK4T+/xR9UvCP7/W+QOLJAWCyL1UrJ+jzdHkqcYL2JT0KQgvQOzgPLAOl
	 jkO1LkOIaoYHg==
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8cac189e516so36774106d6.2
        for <linux-mm@kvack.org>; Fri, 22 May 2026 03:44:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/eFZobfD3m68Xc66idcWbwS57F8/bEQXQPA/GzZsgHKHgoteNseps+YvXL/6IDTqc4idmaiZZK9A==@kvack.org
X-Gm-Message-State: AOJu0YyligWgPxG/zzVg+QQDGl2OHb8PKjnnI6AaRcVIQ904i5C6QMeV
	SxppieL79dy2ktG3m3tCTPjh8bL7EBs1yYhWiaV3PK44q+N2pGVysI15rk7LU61tyQ29SelTyPI
	ZghMUB0hW8iKW3vD2LQh0AUmOLGHwdwE=
X-Received: by 2002:a05:620a:c4e:b0:90e:2f56:2f0b with SMTP id
 af79cd13be357-914b48d69acmr413792185a.7.1779446669684; Fri, 22 May 2026
 03:44:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260518123238.56344-1-ranxiaokai627@163.com> <20260518123238.56344-3-ranxiaokai627@163.com>
 <ahAwLxwW3ki9cOjw@lucifer>
In-Reply-To: <ahAwLxwW3ki9cOjw@lucifer>
From: Barry Song <baohua@kernel.org>
Date: Fri, 22 May 2026 18:44:18 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xCDhj97=4pFrwg1-Cfh5MMpBn=yV=VLrCf1PYcjY+EOg@mail.gmail.com>
X-Gm-Features: AVHnY4JsR6R42ICiV3vqJN_kI8jDzHGlgr9-c4UxhyOQYVc7NHoMcreG9jxSIgo
Message-ID: <CAGsJ_4xCDhj97=4pFrwg1-Cfh5MMpBn=yV=VLrCf1PYcjY+EOg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm: shmem: refactor thpsize_shmem_enabled_show()
 with helper arrays
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: ranxiaokai627@163.com, hughd@google.com, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, leitao@debian.org, ziy@nvidia.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, david@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 23077140005
X-Stat-Signature: pb594x34sstkk7q9ces53gkz44q9wzb6
X-HE-Tag: 1779446670-378740
X-HE-Meta: U2FsdGVkX1/0YGJurdUQYasVmKFkTMPrYNNPSaXas1LOBXBY/6RN+oMIHY8zgk92dVW6Dtm4piYBzVOGY46mrawWALvBB7DWcqbH1mGh+sf14Pq6tGD4M3wfPX9tB9UL9hClCpDW6IPi6e+LR5LjNWRVNR3/dszNZTXwr1pOrSn+LrRzIotb0rH+BnaB0Cv6bP54TWBoFbOaUvbJPHeE7frQZtUxZcAnyzjud/agH5aD70Nl0rSOKMFkU0lQeEhfSiVnsDQdvhTaCSLTgrjT+YdlVMOyIh+4ygXJOPQny9ZB7hn+chc3YHWQLWU4sdkFE8QMCUpM6u+x3Ch+N9uweKYoKM2RaI0KSB/MGm9/zm5gFSVhzn1bELd8oaAds6vs3OH4PqwGdpZyK7GwxmOS+0bS9fQQZLYLIxjZ2IxBh7KCrBEaMbJoNTuuUH2I9P/nQzROB+BTyk3Fszvs74YpS/PV7oEY7ZECgDyz7CGqmHOxEhzqmYMmcvyGR318AJMNvI8ka6Eo8xlGpxWiSlqj7NcRyAfJhCXyb+bQZ0Hj79tECVcXOGx7/T+CkhIddAeY356FH9C7d8eNL7dAHv9OGrhtQwz4wphZ8s5sqWo9+Nc83Ba7trOdbep6X7m7CmXwJVr6UtY9JRLMqFaYfZU5fsQWwyhQeFnhMWk+SsoWg45F9vkjjLpbSZKizAP46ttShh81nQ8nt7isX+5OIvClvRGNsc1DiNDLAcpLj1lnO8tT4AjgtgXEU5I9kTe8hKFiSpqC5tZqojEL/aa1SF+bSG0NLOci7Ce7Qg5ivTvSj9MHpEogx2fMvP75GmwLBh8Hr0sscg7wMotFeXlBWtrzF4PkKum3LfSkbYKjACRv+pSop0Ja8+Dm7f7edGm2GpIx456aANX7vkHhpIA+C3xuUlhGMBfQlY2i71UIyPVN2zLTyuhCFI5g8ys9R1WssaX5LgidK5YeFrlqz90WG/D
 1s5ZXx/P
 BP+PguWz9vpbSk3mK1S5rCuMUoUghdv9hz3IhDsj86fgAwiPS8h3xSDfPDnb0ojMZfD2RCw+oaVhyvTvqYn3P0ab2undXbJkFm46w6Lx4YIuXp8iDWPlXH2Q23mmNWgg9NPmRd7kZO1IGFRiz3iviQlPMoDIUwmPNio7qY2gVE2epTi/WwW8TGgL0edrJdNYv+6YC39DXlorqSkzd+U4wm7fbd7GM6jElSU1vwJMuhX8EbqqeNMHzUGQCwHWZ+kkt6aCwNyyvV1m+uk0eHdILmzS4G0hj8gYhnn3uMRlnwMRcYar+Ttq0sUB4EmnUQriZsRd6h4aJEK59tqMGeFX3XvmjI4RjuCGlvmkzR6I2VNxMuCch2VImhXUu4a69cEj1gtbziNQjYQl/pCj456uy8xeqOELk3tREK4Pv0VbBgLGyJxlxegFgMx7C5p6IegdfKUrwTCYr0t+tlqQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 6:35=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Mon, May 18, 2026 at 12:32:38PM +0000, ranxiaokai627@163.com wrote:
> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >
> > Replace the hardcoded if/else chain of test_bit() calls and string
> > literals in thpsize_shmem_enabled_show() with a loop over
> > huge_shmem_orders_by_mode[] and huge_shmem_enabled_mode_strings[] array=
s.
> >
> > This makes thpsize_shmem_enabled_show() consistent with
> > thpsize_shmem_enabled_store() and eliminates duplicated mode name strin=
gs.
> >
> > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> From: ranxiaokai627@163.com
>
> This does not match the From: field of the email.
>
> This is violating kernel process. See
> https://docs.kernel.org/process/submitting-patches.html

I=E2=80=99m not aware of this rule, since I usually see From matching
Signed-off-by. Do we really have such a rule? Sorry, I might be a
bit ignorant about this =F0=9F=99=82

>
> Please either update this to your 163 email account or resend from your
> zte.com.cn address, otherwise we can't take this.
>
> Cheers, Lorenzo
>

