Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BF7ACAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 23:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 058528E0003; Tue, 30 Sep 2025 19:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030548E0002; Tue, 30 Sep 2025 19:36:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF668E0003; Tue, 30 Sep 2025 19:36:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7F628E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 19:36:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 596671608B4
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 23:36:31 +0000 (UTC)
X-FDA: 83947528182.28.2387AE4
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6912F100012
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 23:36:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rlEQZreO;
	spf=pass (imf05.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759275389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BzAGHoC3LCY9BMZcnX+2gQ2YcNS5UVNzJHOD3iXvnng=;
	b=cyHG/0GYcq/CwUW0XKm9Bf2RYpULH4YAeqJv6f78hbn5IuAq1jvDOT+D4ocgTCxN7/4kTl
	VtB4lKrM8qxvrR1K9+4TwtZreDvDYkeF9PU85g/uHFd6CjgUP+ujw0+whwKK1UkBhs59zm
	jKA9p9vvksQV5aYJu+6l2A0FSwmn9Ws=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rlEQZreO;
	spf=pass (imf05.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759275389; a=rsa-sha256;
	cv=none;
	b=GM6LihJS3y1YiT7hFVDJ2O8h8aH+AEzX4e3gJXp93s26O0n4JUEVFQ0Ta6mtAKoU2mzumM
	zm2A6nckGaoKesDp+ncH6BfyjVC7+Jb/f/XxeQlg8JkyK/jtOu8leNX0iM6jAsDBZHzey+
	M8H92hOx29MDz+/XuQu0zr9tJvngG8U=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-57abcb8a41eso1792e87.1
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759275387; x=1759880187; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BzAGHoC3LCY9BMZcnX+2gQ2YcNS5UVNzJHOD3iXvnng=;
        b=rlEQZreOBo1QnMxoVjezj2aQKrOeeoJmLw4ELxk/FEQ5e6U3/6v/4h/a21jD0K3vRX
         mVFYQrKTsVaqGnf2Fu1kp6M+kmR9Aj33hfy4SRNbyTJq7KoDM518nZaSpp/lbT2aXTG9
         vPEzTR8h/YQ0UuN/SQT53ogcS1wT3LpJasE7ZCs2tIAtjCcqNMJWOljDnr74jUk8li/w
         AyxhALjWBx5ypUTcHMi/0lFYnQcxBoT8/kWoSKy3XYmV99Fu5TDUCv55CGXFnNG/A7D5
         oWis42dqxVBFXUeoPTzxwFAQZjasR7yfSj03KwEhh9rK9gGxfo6AvcYEG7tLDBr++nRa
         x3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759275387; x=1759880187;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BzAGHoC3LCY9BMZcnX+2gQ2YcNS5UVNzJHOD3iXvnng=;
        b=NdE8Zq5sUPa0VIzoF8jyienxwUNO+o2YlQ9lmaR2ygqX/OoOwEx5mK6apAVFAEePxZ
         HJ4zrdll5C+eLiSrw1Nb7xWL/3f/E85s6Xbl2FXuYRxqRVs6UXv6CYYFwzS2sCFk+DjF
         TzyTcTQ/Hz5UYfo5m20CbJhojmXAxJoZQ9V6flBIxtg5bnni/keq3Dj+v54gTOn64fl6
         oWoO5Enm0zehDvdXTn4xFf1/+9Mznh75yfsjIoLE52SYztjCrjyyVWdYLZtZnttNZFUK
         N9pUKTOxWihczDJWCFTzFPkq7hUAXhvjtZLsOC/nBtuVCANaBSd916Cbn7hNcpN0UfxA
         McgQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/nDdOeeujM9utkzArQJuWeOcDkm0NalQLCvBNxfJoAJe6PHvJfnGteqRNmgdsGcILDBFM/mms1Q==@kvack.org
X-Gm-Message-State: AOJu0YzESLmm1Zrp17eENkyVgT3nOGse9MNtzLG7JTc5cNbdl7zitZzZ
	R+Xa33AHyBPoKYAGU3ns97H6MbRvmworwnZcH3I+/VJaIC2LSKnv0Ym1MVVBFM7RFuX3I+KE1Zc
	Dd6LXQ11HFdCeLDGnnh6pZXfFs3wqz31fdNX2oL4n
X-Gm-Gg: ASbGncu2xjTStGFv+rYe9g61wpaFI1MioVPx9uTFxm4EH8PIy6SAhsENs5708N+sGr1
	xq+oOwHnYm9ClWO4WJdjV1HBw7xZATgOIosTN/RDZZ/zct+FO/U76yE1b6fgmAQi1BVJPeUNPku
	T7EQqofwl4n/oEcFxDWqcLKW1Hw7Nrhr3bs6mhDzCq78hXdz9mmuuWtKCEpN0/MmmrefJ436nLA
	eJNVDmzYku/7IPw3xrmYMsII8iB5W0rWytJMa5bdSygnU+vFTgJDu1WuirdTYX+q58S4ebOsMfj
	3U4=
X-Google-Smtp-Source: AGHT+IFkc4IJjLwRN6BK7QqMPx6rU0WejItlxxFNvZ50TdxHWfIXW7DGWHWYtXgj2YsxQvYwGLGM181jyibNLaHKuC8=
X-Received: by 2002:ac2:490c:0:b0:57b:aa84:8b11 with SMTP id
 2adb3069b0e04-58afa3eb46emr129851e87.2.1759275386958; Tue, 30 Sep 2025
 16:36:26 -0700 (PDT)
MIME-Version: 1.0
References: <20250930114331.675412-1-toke@redhat.com>
In-Reply-To: <20250930114331.675412-1-toke@redhat.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 30 Sep 2025 16:36:14 -0700
X-Gm-Features: AS18NWBXmtCuQg-Y2WOs8Fk6rwYNK6cExv_BH5QWhhlqrllaXyqnaMgGll4hTLc
Message-ID: <CAHS8izPGxvdDu7JwEWK2=fk=qHoYgFzOs1FjOWjmNwqrU2r0kA@mail.gmail.com>
Subject: Re: [PATCH net v2] page_pool: Fix PP_MAGIC_MASK to avoid crashing on
 some 32-bit arches
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Jakub Kicinski <kuba@kernel.org>, stable@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, linux-mm@kvack.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: i159x7w5irj3tmkeszzzetkhgthposs8
X-Rspam-User: 
X-Rspamd-Queue-Id: 6912F100012
X-Rspamd-Server: rspam04
X-HE-Tag: 1759275389-551822
X-HE-Meta: U2FsdGVkX182UiGY+LtJxvw+t62NEoCbf0f4xc+UY1p8zhtbKPMI784ErqRY2zqBV+p/rLPIk4ZzihaNqpEhfNcgi8oK+98OpYwQvpKd/ngXDA9U56rLIBIShnY0nz2iGUWcgdn/7O5nUBi+4v9NT4rmE/3MFokU9o2eDbz0VrMBekKIELvn+EW3tlKTsxq4gyAdV4McE7jmngofMLOXkDzw4osR7Os3Nm1JDkUL6nkPXhoOb5xZ34shwMfv1IfNfJfBf9NovMJSR+PM0kWuZ5hkoPU6kJ63q2jDGxzT+m1New5D7cjRMMNqLVPY+PN3AodAXBYI5QmR+p6Az/Rl7H52wF6ct+hAdkdLKUl7ZtgDZZ9Chi0jg9BABoqUmnGZV7FkoV5PBaeDhwXIZa8TfYycyNklnCTMlGhnn03j9PkbgncyjJ+5bfb9m2g1gzfwldRn8MwhKiwapc3FiWI7/zne7o3NHltjFGlRUdmAPe+bOkoki/se7qVyL1jzXCS6RkjAP8JcPjyUtR5jq6wQ7TVVJj63XsjFAclleZ+Aq95oO/DsrlfLMFFpyglBcUG8vQR7ocbbsRE05eA5Uzrp9qmLbRJsbxw4SiFE1f5DtFFBJYavWSJAUaygwj/UKRbd+eD+OZIBeb2GYejMCoDAUOoLi5t18pkefcMT2hoCNLiL4GVdGtybWLaqXmKWmhbTwgbGn31jMB13KUrgH7Je1ZvC28+MrOojXOy/lhwolXtdracDpm2vW9hdZuDJClM/FtxJNj6kVSBh+4RWyoWRftP3ekUTrrrPtoqLFz85BX3xqpWbQ7j1kkf5s71pB2ThW1ZlvULITitWuEHbyiFgBX+HRSTDn2XXhRjPH4un75s8D+yvmNu/TZMjVR2PlLe6TDxKibgZronJT+UnuS5uTKtukFEbY0z+sa1O/EBpo7DMqPqGMFSwiWD2fqB/cEgIx39Dddr0lHWm4iXLn5w
 YBJ3+G/s
 +aqPI6oeWgmVY7rnod01WHyyMoh2nVjoGi9TWH9IlV2iRUjZA8+lhumK8nXUZV17xrCqJ8ZyGJDihsk5Y+8mYEExXtS/IXs85Mx17ae8cXG4Rps3GMjBf3GIWh1rd7GkeqkLvxKxBQDaInZCkB0z9/pS/nVh2qa4aJe+jG1hp9kW7cmSvX17Gxekntli9XOwZSm0kSlnzY34vNzSHW+OZy5ctuWyMyWuWhWSDkJ9AjTwTT009XdsidK17/mYqfr0XFvWe5vCgud9uEw9OhZplwYN+6dnYDTiKT2Trs3prVyhwx5DKCKsd+OEYhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 4:43=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@redhat.com> wrote:
>
> Helge reported that the introduction of PP_MAGIC_MASK let to crashes on
> boot on his 32-bit parisc machine. The cause of this is the mask is set
> too wide, so the page_pool_page_is_pp() incurs false positives which
> crashes the machine.
>
> Just disabling the check in page_pool_is_pp() will lead to the page_pool
> code itself malfunctioning; so instead of doing this, this patch changes
> the define for PP_DMA_INDEX_BITS to avoid mistaking arbitrary kernel
> pointers for page_pool-tagged pages.
>
> The fix relies on the kernel pointers that alias with the pp_magic field
> always being above PAGE_OFFSET. With this assumption, we can use the
> lowest bit of the value of PAGE_OFFSET as the upper bound of the
> PP_DMA_INDEX_MASK, which should avoid the false positives.
>
> Because we cannot rely on PAGE_OFFSET always being a compile-time
> constant, nor on it always being >0, we fall back to disabling the
> dma_index storage when there are not enough bits available. This leaves
> us in the situation we were in before the patch in the Fixes tag, but
> only on a subset of architecture configurations. This seems to be the
> best we can do until the transition to page types in complete for
> page_pool pages.
>
> v2:
> - Make sure there's at least 8 bits available and that the PAGE_OFFSET
>   bit calculation doesn't wrap
>
> Link: https://lore.kernel.org/all/aMNJMFa5fDalFmtn@p100/
> Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them wh=
en destroying the pool")
> Cc: stable@vger.kernel.org # 6.15+
> Tested-by: Helge Deller <deller@gmx.de>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  include/linux/mm.h   | 22 +++++++------
>  net/core/page_pool.c | 76 ++++++++++++++++++++++++++++++--------------
>  2 files changed, 66 insertions(+), 32 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..0905eb6b55ec 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4159,14 +4159,13 @@ int arch_lock_shadow_stack_status(struct task_str=
uct *t, unsigned long status);
>   * since this value becomes part of PP_SIGNATURE; meaning we can just us=
e the
>   * space between the PP_SIGNATURE value (without POISON_POINTER_DELTA), =
and the
>   * lowest bits of POISON_POINTER_DELTA. On arches where POISON_POINTER_D=
ELTA is
> - * 0, we make sure that we leave the two topmost bits empty, as that gua=
rantees
> - * we won't mistake a valid kernel pointer for a value we set, regardles=
s of the
> - * VMSPLIT setting.
> + * 0, we use the lowest bit of PAGE_OFFSET as the boundary if that value=
 is
> + * known at compile-time.
>   *
> - * Altogether, this means that the number of bits available is constrain=
ed by
> - * the size of an unsigned long (at the upper end, subtracting two bits =
per the
> - * above), and the definition of PP_SIGNATURE (with or without
> - * POISON_POINTER_DELTA).
> + * If the value of PAGE_OFFSET is not known at compile time, or if it is=
 too
> + * small to leave at least 8 bits available above PP_SIGNATURE, we defin=
e the
> + * number of bits to be 0, which turns off the DMA index tracking altoge=
ther
> + * (see page_pool_register_dma_index()).
>   */
>  #define PP_DMA_INDEX_SHIFT (1 + __fls(PP_SIGNATURE - POISON_POINTER_DELT=
A))
>  #if POISON_POINTER_DELTA > 0
> @@ -4175,8 +4174,13 @@ int arch_lock_shadow_stack_status(struct task_stru=
ct *t, unsigned long status);
>   */
>  #define PP_DMA_INDEX_BITS MIN(32, __ffs(POISON_POINTER_DELTA) - PP_DMA_I=
NDEX_SHIFT)
>  #else
> -/* Always leave out the topmost two; see above. */
> -#define PP_DMA_INDEX_BITS MIN(32, BITS_PER_LONG - PP_DMA_INDEX_SHIFT - 2=
)
> +/* Use the lowest bit of PAGE_OFFSET if there's at least 8 bits availabl=
e; see above */
> +#define PP_DMA_INDEX_MIN_OFFSET (1 << (PP_DMA_INDEX_SHIFT + 8))
> +#define PP_DMA_INDEX_BITS ((__builtin_constant_p(PAGE_OFFSET) && \
> +                           PAGE_OFFSET >=3D PP_DMA_INDEX_MIN_OFFSET && \
> +                           !(PAGE_OFFSET & (PP_DMA_INDEX_MIN_OFFSET - 1)=
)) ? \
> +                             MIN(32, __ffs(PAGE_OFFSET) - PP_DMA_INDEX_S=
HIFT) : 0)
> +
>  #endif

It took some staring at, but I think I understand this code and it is
correct. This is the critical check, it's making sure that the bits
used by PAGE_OFFSET are not shared with the bits used for the
dma-index:

> +                           !(PAGE_OFFSET & (PP_DMA_INDEX_MIN_OFFSET - 1)=
)) ? \

The following check confused me for a while, but I think I figured it
out. It's checking that the bits used for PAGE_OFFSET are 'higher'
than the bits used for PP_DMA_INDEX:

> +                           PAGE_OFFSET >=3D PP_DMA_INDEX_MIN_OFFSET && \

And finally this calculation should indeed be the bits we can use (the
empty space between the lsb set by PAGE_OFFSET and the msb set by the
pp magic:

> +                             MIN(32, __ffs(PAGE_OFFSET) - PP_DMA_INDEX_S=
HIFT) : 0)

AFAIU we should not need the MIN anymore, since that subtraction is
guaranteed to be positive, but that's a nit.

Reviewed-by: Mina Almasry <almasrymina@google.com>

--=20
Thanks,
Mina

