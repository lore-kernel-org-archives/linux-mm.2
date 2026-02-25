Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A0CAFD45F6
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 21:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED48D6B0088; Wed, 25 Feb 2026 16:51:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EABAE6B0089; Wed, 25 Feb 2026 16:51:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8826B008A; Wed, 25 Feb 2026 16:51:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB6406B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:51:25 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 982F5BA94C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:51:25 +0000 (UTC)
X-FDA: 84484325730.03.0AF7117
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 87C7214000C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:51:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lDBA9E4D;
	spf=pass (imf09.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772056283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wmdx/Cbf+zEgxaJBqjHZqb6Npzxn97ZXSNHZYWGgIk=;
	b=R0Q4Wguif6sIlelm65WgmXT2mKfsFE7bRfRrDUK6VyrxgPo3Riy0wHQEDau/3m7i7qeR6p
	ST0D8DF8DD9AzlAx099dfPzqP4A2bBLi8JrcrZDj4enFoOHbRcftQaHMYFgqVQzLeFgVFb
	6XENgs8pCWKp5uYt1WAqSrIR7Z/A6oQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lDBA9E4D;
	spf=pass (imf09.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772056283; a=rsa-sha256;
	cv=pass;
	b=c5TVs9Z0HHpO56eGuzVy8Vvmp3h4PLQB0G04m28XWm/RbUlxJ3G/AJW/AqAg2W/q2z5l3I
	g7TJ/AW4S9kVmXSxq5j2sfPOxur2v+MNVZbVhTlVlsDYDr3+SF9WxiP1RRW5cXy8ftsmVl
	8adqvDwASi2yrF0yq+Hef1MUxcatwQ4=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1270f10a774so767c88.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:51:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772056282; cv=none;
        d=google.com; s=arc-20240605;
        b=VnlgEpKDeZV2Q6puA274+CktEpev9XIhTMF5BDktpm3HduA8W1XedRZ3B6LAI/t4sF
         KUhXU7WkZRsWSYHpE5Z599M1MCYhAi9KScn+Ayewbm2x2IIP0RqgeWNjrxXMvSy1t1fq
         FxwceIxd6AvbnMIpQskYgJ0mrCmjBxIiO58jrEK68YmAqH5AeJ42JgSNt0+jbWejdWAI
         /wfHIg0eUQuBN5Ip9OfORu6C4NwbqdaS62jL/aD7n+F2MZGEgJgZmyZt5BJjra6/IsMk
         jOPaqqUB3Fa+ZWLKNCWYEm4GcBXyZymTyblMjkYhMXDgX023WQFSA0w7fUZvW+US16AR
         ojig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9wmdx/Cbf+zEgxaJBqjHZqb6Npzxn97ZXSNHZYWGgIk=;
        fh=KaSc2xs9GCyrOQ7MJEUy4J1aXB79wQJY1OnWipguGFA=;
        b=QdX+SRhz/eqOWScp1iQcxPJmGJzCqDm19BjMGGgxiyHrbQyl/4orq5BzDwohW5V9nr
         KJ3YsnTHcL6fG0ME5Z7FMH6yj7mLvc74+VkAMt9ZCG+i5L+rojetSDoiDJcDoRFzVAuq
         bZNFlLG3HxCY0Rykvkr3McqB4F4lZ96kv/qClXy3FNSmi6CmJ4x+9ixcTosLnT3NTXKl
         93okqYagQZu4hoIiY6y0Kv2uQMVK/3isov8gnuhsM9zHw+xj8lYxUg+0iDhEu0FMHiY2
         fpWbHbm1wdEqhL3+nywcIZDQ+cTZnU1cPH6wyy+DcvyfWxY6D8PZnFo6p5I8+oSqov2f
         uP8A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772056282; x=1772661082; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9wmdx/Cbf+zEgxaJBqjHZqb6Npzxn97ZXSNHZYWGgIk=;
        b=lDBA9E4D3vm6Rmb8TNGEoLjREK+kEw7kltbZCSMzDr+ze7O0lXP0vDyeNvj9vLFpCG
         2/uW4E+NfQHMiakoLfnzIlqHmOc1bbmnRNQpPoDnxqMaiUA7BuzdxbfmvPtH0ddVkHmR
         dy7MObPi6S832mJ20Ny2q/W5yOsAr1A8nsXVwU2eUX7GMBL/YyDBNOilCxdBI7ykkWax
         /pYO4gTwbEsc31iTWdEuOWy1Losr+T78oOuR6od62Sz8KMQbVFYCV0Xgo1eVoq2jV8Th
         b1lyiXTwuHzvEm1auktE1eV/jjThWtll8mb/yLfGbX4fTxyFkVUrD/Be+9W4xBUZnYoO
         4FiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772056282; x=1772661082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9wmdx/Cbf+zEgxaJBqjHZqb6Npzxn97ZXSNHZYWGgIk=;
        b=fIPGsINUxSTFpL0eYyB2n97plEQIH9N+O6Um0GNLQEgBtNn+BFWTc6dA9Nh1TvCVr+
         poaZE+0PH3ArmjnKQPT+Kj8lRR59rZjjulfz20t1ETWSckLkbTqbdCCT7Z5JMGl8pALk
         Q3NdEREcsm9EotQUvFJ0qqjr3iPD5sxjGgdfphAnIcqii5gdHcx9NL9hh9KSJFJgccG+
         5d5Jl1BFv8Ks1rG+X6EpcF6l2kM7yAiiA4FYm9Wlw3cXh/CCxFUKM67aIQkQd+KYHoHi
         UsN8Hvc/DltJ2ufPyl6T3McE7Hyer8dxM12SgMtGtU6xnhmQtdfnl8Wjdm5hxrWjGxP5
         vR0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWQQVnMGPgHIaVRq1KVEfAcDBtOqOjlcst4hcCfAWsJJ5xtT0aMn/+LPtakzFDsodp30YXZei9u2A==@kvack.org
X-Gm-Message-State: AOJu0YxhkzSD2gk3eZ1MFT8QH1ix5G9spNlNKJzzgE6QT7YcJML/VR5G
	Szrf1v+pkHAQKIpPkNhOZPXn+5wIvALk2t7+zFga87SyRQPDrV9efNdtkI41/K9b4QEW9ZVnKpd
	tm4MHyZ89rztBDaostP+WHQc7qUhtwf6VewiNtbS/
X-Gm-Gg: ATEYQzzoop/g3wQylN6nvO0o4xktoailf8VEScq6vA7fxs6jJskUd+LV7mx+nnGHP0D
	MPyZLisL7EAthnbar2NdaEJfO05eqRGR5OxP60rTgqdn/Idc03YEbrRZreC5zDmPEWIHP9nZ7u0
	8EJte006KycDpAwxmb6GSv6cfvOMD8/WlBb1RSVh6w+d5Y5ghIe+9umHSeC+f3ar0j3y5QXDu76
	M1QiOe/fzJAn0MSV6dyIph02kP39jhjEB0pVXCKcvHFqu93UC/WjE/Pe8BFklzSWxKKIc2u0ZFY
	eE1S2t8N
X-Received: by 2002:a05:7022:ec8:b0:119:e56b:c1e1 with SMTP id
 a92af1059eb24-12788f977c9mr37575c88.12.1772056281815; Wed, 25 Feb 2026
 13:51:21 -0800 (PST)
MIME-Version: 1.0
References: <20260225002434.2953895-1-axelrasmussen@google.com> <aZ9OEAzENzeFYDB2@cmpxchg.org>
In-Reply-To: <aZ9OEAzENzeFYDB2@cmpxchg.org>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Wed, 25 Feb 2026 13:50:45 -0800
X-Gm-Features: AaiRm518g2bV4iY9cTGSGtmK5Kp_ChUfHNXuOPyWbieDNcE5Q59_QUJZq_8Lm6Y
Message-ID: <CAJHvVcjnSc16wtYrCt8i+UFUmGzoAwKXoB8CGMLwz4NEG32QnQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "ptdesc: remove references to folios from
 __pagetable_ctor() and pagetable_dtor()"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 87C7214000C
X-Stat-Signature: dgbrynqce89g6swtn4zka5ew9er1ceck
X-HE-Tag: 1772056283-570637
X-HE-Meta: U2FsdGVkX1+UiDxpruJyOUxdS0kCLfGydT+THRzZRcnCsCwtJiCD3YBPVMtbd8qJFhm+MVEw5mhrwVy42hMWBfVq1JwaJd9VRz29sS0Chyca4Jc5uwH2GrCnO6fAbfTkUIlpFDueM5Oy+FD1VUl0CZz4/iJKCaX0shtw0ImGIJfU37nn/EmpCfSJT4qm1squn9er8P5PQjOW/eOMbxxq9rnRoZfgmwPFlFVk3C7+ZU3IMBrcFelP9qUID/g8UW5M4IljZOFdxcs7L2o6VI2B9XsCyKPMg3NGqEb7YInKCJgrVvsfj/cc2XyyQ09uRsKr0DAV6iLGsUt7HopztI7QiujU1RBYTvu3MLJA0IQYNKhuWs8ypw1GGwe3UYA/5EE5ZHInxxH9s+WD4UC2f9qhAA1kcckCFnWCQknH9Hhybp3tDC+h7c0A+X7jFiRM3gsXJzyXWG+a+PSiqeTtGr/NZjr2kLIEKa7g+s1FqmWNxIDIU9g0LTLS73os4i+saDLacNH9JZR6lqxbRerZEIbHV4zuJYmHPNQKRZXaP1P2WtjnKYjO9SztH8hFpyO6ZoiPiVe4H5sn/Vqlszw7VwbwV3yBekxLj+cNaSaw+qiKiuaVCB76iBuMGCgEeNkYC6VwhSNi1Nwj4+a2K1R2/QKWsCBDsbdPwdwrEAQF84rpTmnthFgnVpEW0W/Qye65N1IZZIhEZWiwYLBdNdLJtN2eSbJ2T5M6eXOJTLIvmPRfLCqU4r3CX9ki8M93c9TE9kvkuabhE7VzxnEQZDQhzx8Ry8tycDlPbhQLA+/Ncq+1eVYx+dUdtss0CwcP+TPylISATsPAgTSCdm+pXPz55vI3/lHZI/plcG2cCdWcY4PLxwzAblvDXG07RFtlRgL4tha+ScjquVw1LULdAkxQKS53j0oBi11hlVdU/a9IG6p6LvCIRJmMb5z5o9EprzKU+VgjZyqnxoj5f8dqhBjHsZp
 geRSRrEN
 SZ2fMettAQRE1m8nEZK5PH4YyK9H3PGIFG4wLqc/5uSycpz2gPNMAX39Ge5ZQilmQRGWgfklgzBeLLVlX7tL39Yz5x2OBIiMIwDWFPiCANO0qNW+Emiqc0H5z4j2n70q6JDYHci7wpf93MsKJE3hf5z4wgRV981DvaK1L2dKDcAtXNUXSwMrfUtC37VO4ni0RCLzAsKHBGA1V6UtKvzCFREIGpdd2OCz/vm/eQbn5+mtCUTl9QXnKOX/x+rjZn8UROsYqjuzTqcYgz0n4bxcpdBbgNF3SnJ97Bawrk1HmYGI56NHdCvFVV9I4rVlipDf5+qHcC4EpZ82CnQ+8VLZqk61YYzViepxpAbOqHVIjsk33jp6FtpKNY31Zqfbl5oTy7m0w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 11:31=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.or=
g> wrote:
>
> On Tue, Feb 24, 2026 at 04:24:34PM -0800, Axel Rasmussen wrote:
> > This change swapped out mod_node_page_state for lruvec_stat_add_folio.
> > But, these two APIs are not interchangeable: the lruvec version also
> > increments memcg stats, in addition to "global" pgdat stats.
> >
> > So after this change, the "pagetables" memcg stat in memory.stat always
> > yields "0", which is a userspace visible regression.
> >
> > I tried to look for a refactor where we add a variant of
> > lruvec_stat_mod_folio which takes a pgdat and a memcg instead of a
> > folio, to try to adhere to the spirit of the original patch. But at the
> > end of the day this just means we have to call
> > folio_memcg(ptdesc_folio(ptdesc)) anyway, which doesn't really
> > accomplish much.
> >
> > This regression is visible in master as well as 6.18 stable, so CC
> > stable too.
> >
> > Fixes: f0c92726e89f ("ptdesc: remove references to folios from __pageta=
ble_ctor() and pagetable_dtor()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>
> Willy's cleanup proposal looks good to me too, but this is more
> straight forward to backport to stable.

Thanks all for taking a look! I feel similarly, the other series looks
reasonable (modulo a couple of fixups pointed out in the other
thread), but at least for 6.18 / stable I would mildly prefer to just
do the simpler thing and put the status quo back. (Especially since
the other approach needs a bit more tweaking.)

