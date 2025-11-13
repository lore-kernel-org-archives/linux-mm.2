Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C441CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 02:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B9AE8E001F; Wed, 12 Nov 2025 21:21:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891448E0003; Wed, 12 Nov 2025 21:21:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CEB48E001F; Wed, 12 Nov 2025 21:21:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A47E8E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 21:21:14 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C0AE14079B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:21:14 +0000 (UTC)
X-FDA: 84103981668.07.E6817D6
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4D84A4000A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:21:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763000472; a=rsa-sha256;
	cv=none;
	b=TO3a6D79XkN+moMU9n/0V/Z1bSdPJKp2sbVhC34YHiZJ209Dzqw0Skyu2snHaZe+9ytZNH
	r7HfFED5USN1l4Orc2PKPqkcZfkTIKP3ARQY/pB/fZl/yP2hFOhbZedOISqCUFs1xDckN5
	5WOk1uvxrNkWTAWaArJknbvC4KEk3C4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763000472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pic59F/pdzv95VKhKYJVYZExCpTxWKEdCOLNoyda+Us=;
	b=p05iC4bxwPN6xPqQNvwRO69R0w0J6IA5dD4QHINITM/0niW0ktRO1ibr+QTo7nkgXWNrPG
	UOunTIWtH5dLe8m/VBZUXuBc++ro2IqwzfpQQ5eFIGozlY7WgyCJTd/2ZYpmAuMkCZTlIO
	OsO1sx2ujDPtv3YSDo1g5gCV5J+brQs=
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 248AF1A0737;
	Thu, 13 Nov 2025 02:21:10 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf10.hostedemail.com (Postfix) with ESMTPA id E75B02F;
	Thu, 13 Nov 2025 02:21:03 +0000 (UTC)
Message-ID: <1dfa1e3566cafbe43a1d4753defef9c82ddb3b64.camel@perches.com>
Subject: Re: [PATCH v3 07/22] checkpatch: Warn on page table access without
 accessors
From: Joe Perches <joe@perches.com>
To: Samuel Holland <samuel.holland@sifive.com>, Palmer Dabbelt	
 <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	linux-riscv@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
  David Hildenbrand	 <david@redhat.com>, linux-mm@kvack.org
Cc: devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>, 
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>, Michal Hocko
	 <mhocko@suse.com>, Conor Dooley <conor@kernel.org>, Lorenzo Stoakes	
 <lorenzo.stoakes@oracle.com>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Alexandre Ghiti	 <alex@ghiti.fr>, Emil Renner Berthing <kernel@esmil.dk>,
 Rob Herring	 <robh+dt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, "Liam
 R . Howlett"	 <Liam.Howlett@oracle.com>, Andy Whitcroft
 <apw@canonical.com>, Dwaipayan Ray	 <dwaipayanray1@gmail.com>, Lukas
 Bulwahn <lukas.bulwahn@gmail.com>
Date: Wed, 12 Nov 2025 18:21:01 -0800
In-Reply-To: <20251113014656.2605447-8-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
	 <20251113014656.2605447-8-samuel.holland@sifive.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19giTHWCQXhnf4xIrV8ypTp+gyVUJdqk4E=
X-HE-Meta: U2FsdGVkX1/zAceZ5vnh4tbWR1f+Cwm6Gajb5Cysjq6qV34Cj9ZhK7eypGnKqYKEn8aGGYIrbdej0PNanG4Y7TU/rQFSPu393I2CQtbbB+tC8raIaQXcfTo4/QsU+zfgvxgvrkbI2t+kILkdA2MOrD1E61pPCOZlLL5D27VIEclZ4WR5+L5e2bEJGUcPo/3BvvjYsMlCufHb2LdyCWotOP9G0jDRsl191XUc0vokRa6gejGK8FjkEibcUKMjgguRZP81NCcHiR4kBfuLcisXBHTUQG1ReqMmWiKYx9A+Ot1h30HMlHgxWYbe8+ei1wEa
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4D84A4000A
X-Stat-Signature: 637x6efm4mgrsxn5df3wupihd98x8qr7
X-HE-Tag-Orig: 1763000463-251880
X-Rspam-User: 
X-HE-Tag: 1763000472-476961
X-HE-Meta: U2FsdGVkX18GCMGrL8xXu4kjU0gR/c2KgKyPQ5NLBv5oq4Hr+tskJsGDPFI6IPHnz9Xdqn9fpZiYrOlhoev3TERNs3FHPmF1maXAhV098AeN8rqhi0RWE51XC+Y9Vcr4YM0TUInO/B3O3DSS9JFOOwKWcOyo/CsDJoiJZ4bpgV7CAeWW8Dnj+Dyg4VthhqKpUH0vEkZhb+twl3PGlcZDf+Cn1+1piuT2tL3siIB30WxgSnOv+jWASoBNbOT20DMuc7vhd2vUkzlaMB31elLBUObLuinOi4cicgisbuf91QqSDPXvri3EJsDZwLdEeNx+ZhgO61XS7N5cd+uRwYVHqMkKtt9yck17HYpuI6Zwg8hJ11oeCiMcdLuoRKu7cq34akxJI7f30RxGhUHC5D/5kw/Ek7PcV1EUX4kcqY9Ua52Dx5tpsX+PKZ7ynQNRpWn+D6Uiv25rBFkLI5GDtCSsnracrSozmc4FtiTgmVTfHi3HKfekBjAWTjXvpF5/vh8hqhKvMazSgNd4XA0Otp/4BPtWyWyaGvjNH7+tOsUAD51fdbp7qP35h8XtRfXzG0Cwo3szJt2N7pbRdvGDxB7Snw0Y0QLJ183mzzX3F2lm5P5Vcw3weJTyHPIq78xMubmNNUbCWwv7uDK+u88omJZhsoyLyP8B1RtoV9LLzmjhMYwO8SQNsDcmvAucgbhDT9JarcFE5nki30bYBIZM0a2g3yDTkb1qMIpUuxycJ70LWag43mXKCthq59FXNewRLvPY5Em3vZJOZKUVp5WpVyt8iMwsq2X+IpPtp4FsEiQmSt0PHXwtHFBzEbvcwYXEIe+A++QDKE3gsxWPlvRMApZPsWtEAj3jpCClVKW1xygLU3ct3J2KthEps4YG8goTyQwi9uzVhdgXyWgtiKUXa+bV1wnrQPyY1FO07P9vsQjRej+/uY9/BGp34SeUDFfNW5kgZ3voMEqLdA39Qp8WXLD
 8j3t3JeG
 bQTMBm3CyhkAx4WBIU0alSS8y00aN8eJBzafq9UdNtwCeedc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2025-11-12 at 17:45 -0800, Samuel Holland wrote:
> Architectures may have special rules for accessing the hardware page
> tables (for example, atomicity/ordering requirements), so the generic MM
> code provides the pXXp_get() and set_pXX() hooks for architectures to
> implement. These accessor functions are often omitted where a raw
> pointer dereference is believed to be safe (i.e. race-free). However,
> RISC-V needs to use these hooks to rewrite the page table values at
> read/write time on some platforms. A raw pointer dereference will no
> longer produce the correct value on those platforms, so the generic code
> must always use the accessor functions.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -7721,6 +7721,13 @@ sub process {
>  				ERROR("MISSING_SENTINEL", "missing sentinel in ID array\n" . "$here\=
n$stat\n");
>  			}
>  		}
> +
> +# check for raw dereferences of hardware page table pointers
> +		if ($realfile !~ m@^arch/@ &&
> +		    $line =3D~ /(?<!pte_t |p[mu4g]d_t |izeof\()\*\(?(vmf(\.|->))?(pte|=
p[mu4g]d)p?\b/) {
> +			WARN("PAGE_TABLE_ACCESSORS",
> +			     "Use $3p_get()/set_$3() instead of dereferencing page table poin=
ters\n" . $herecurr);
> +		}
>  	}

Seems like a lot of matches

$ git grep -P '(?<!pte_t |p[mu4g]d_t |izeof\()\*\(?(vmf(\.|->))?(pte|p[mu4g=
]d)p?\b' | \
  grep -v '^arch/' | wc -l
766

Is this really appropriate?

trivia:

izeof is really odd looking.  I'd prefer sizeof.

