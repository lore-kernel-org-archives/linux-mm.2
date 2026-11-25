Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32919606A329
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 02:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a9Hkhu0B
Received: by kanga.kvack.org (Postfix)
	id 1C1376B08CC; Tue, 24 Nov 2026 21:10:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1982D6B08CD; Tue, 24 Nov 2026 21:10:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088086B08CE; Tue, 24 Nov 2026 21:10:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4D466B08CC
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 21:10:41 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4133780D19
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:10:41 +0000 (UTC)
X-FDA: 85472012682.20.EB752D4
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4E3DB1A000B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:10:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=a9Hkhu0B;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795572639;
	b=7fYhbu7LnKcENeWBowMwuo0meIyaBX7NkVmqk8SvXvIXI9EpkzlegOoUw3utRxUQ8Pwpk+
	NRzPeJobT4DS0GnQpeTOqNkO1uKYzYQbVoVul2Lejf/WebeYUjCn80Rj5TF2hL0J0x/dJi
	xViJtp2qHt5v9WKXvyv8RrbeAfxHkBY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795572639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TvZlrkg5tr9gIRROT023AZ+ik64XGCLBZ3Fbj+l0tnE=;
	b=L+fMj1I1N8YusITkP1R4q2wPKG5SYovQfPBQ3DhDelf3G13wzyCXX0+3V1e7/vgjfBJGhr
	sqPQ0ezJ1zFvRRyWqJpGZq7pId7bI+8QSjDacjNFvl+qXZfP4MBewkHatv+S40Hc4tlXLN
	xA6e8GHjBhP2DG67IpSK8LXbR6hFaSc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=a9Hkhu0B;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5be4b61fd3dso4580906e87.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:10:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795572637; cv=none;
        d=google.com; s=arc-20260327;
        b=lHl2g67/nQKEXaIcwdgcBbpZQ6VfJua5tedPIlc9368DAIXjpiXq3jzyeC+a6PGhdk
         e1qNSCnwM3bFJQWt9NhzQsOS+a2Byqvn2A5zlfyLcqsahCHPTUWsclQjllW23Pspj0j0
         nWgNKFhCHEV30liFc8oXQDi1VomIa6GvDJxjQxqST6qkgBN/ohfDhgqnDtEpXPDBw49k
         PY4z5bnkinaXhgkOTcGm/bQeSFFVQUDmBbBPi28abI7HoZOfsod/kJjmk2w5GYorr+Et
         kQXZio8OaxZZDcBubkBvI1NWSeGkncKQRiSKegofyoC9C2GCX3gycDqICx8Lf98jw9gz
         jO1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TvZlrkg5tr9gIRROT023AZ+ik64XGCLBZ3Fbj+l0tnE=;
        fh=+eMG1EfnCwLyBkeZJwFDFVWUtp+eRVBVAqNuHMy67cI=;
        b=ZtLytaW/shtQmNOHRT7gWGvC+S+Q3PRXJjOqpHB4isUFMGZIJVv01E2EG/3RwXy39X
         qsI3X53XYEuCMO1Kw/s6URAQ9yh/e2TJU/qzJptJgKWnt/LtUL7FOhOLKFVNgrAcH0i0
         qvL8m7oqR5O98i73RgjsbitcvNkrF6MzP6dYNj3kFmpUdOlCd5d5s9YdU4t7lb/Zr9rn
         UdRMqiiIGYDgT3xwa379JdyvQryNud2djymh8SUDRHwymzvuZ+h+cgKb6NO8JEfrPri5
         kB4UfwPChcZ+LjjMjTnI4CGy0MZY4zSURFX/QjosnzTvdgBUE9RgFpih8ucag8Xssw+H
         q+iA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795572637; x=1796177437; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TvZlrkg5tr9gIRROT023AZ+ik64XGCLBZ3Fbj+l0tnE=;
        b=a9Hkhu0B7cdLogIqUNTmzte03z7yDWiUC9FfF4nqVLjUBm/QGe1ivPFoi7Bitjqywl
         QzRL7kyD4H8cIeQvn2GcwjzkAHYXomdWPltdzSVYFXZ0knhL7dCBmS8swUxUvgVOGkLa
         Pj3rcfPH/ySk4YxUzqmzT7hT23gysBn5i5HfAMp990UldxMiIRgJCaLaXfZhfz0zb/rt
         HkRapdLIDGlZ2VU9+3z1L0E7X3BSdZXhji/XdyEqmc/QX4VtkXnLZsejjQbmY19+KM/Z
         cZIf5Io0wB5Fq4NAbqThXsHgSKHVE2sU8MKITnlyY3LJ0AtmHsdWwaqQ7T2aGkOdAzxr
         WotA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795572637; x=1796177437;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TvZlrkg5tr9gIRROT023AZ+ik64XGCLBZ3Fbj+l0tnE=;
        b=zMXcE7Sj6vFGfPU6VQ0XRZg+7ymKALM3BYT114H4q/5VadhWwnzIrBlOU4UDj3Xgem
         92c5F24BaFi5BjudkSYyyF9bLhhAGBJW648b0Fe1e9C6Bao+MXRn3DMuFjwzqst3rxhE
         A5BebMsphS5UsvLCQO16uSLsS+jIy6N82vudFsQGGOfskr+I5f2mZr4EhlOIE5fyQHEw
         i/5rQQKAC+44XsvCt63NXM3U9sHRYmXYrp3ZAWpMrNqlax9eynFurg+fWVpjs3SXp8YZ
         cEgrg+m6mj76tk6ALxt065WqoxJ5H9dZjNaravzGq21XGeMBcttf+VeCmJSHqJAouX4z
         nExg==
X-Forwarded-Encrypted: i=1; AL+hErEzYOotLs3VUQ5NoBpUqtjvdC9MUm7GjKPZeb0anl2mwp/kJQinMNvrOAY12ocTUMi8eji3uQO8iw==@kvack.org
X-Gm-Message-State: APuU4Z/HkvciwX/w8oOVxPvkbOz8jzDTawI5sp92WPzfnwBOn21qccsh
	bY/b53/rEaB2pr7AwSv5s//iQEokHYBuFLqRluU1DztGDrMugnrvnfemen2mOz26oHJT+0SMVRj
	1oZM8NgD2RpToWVeDSgzxSSdaEytUAwA=
X-Gm-Gg: AZFdTZdmJOx3GHr5+jDK8joQCeyIavcwytwjmckfUaFOnzJvTsr+YzPQfRWJYByKb4V
	ZdQU1LAzOFbOIHCHZPz5lK0kE6jz5LD+5tRSDHfQWaHYiWn4bOx7bqrrz1iUmmLnZiXISBcGoIC
	yGMSJ2OySD2+Y2vi5MUxZsLySIwxnNosmKLEvUvIPU5oN9vH2F8TKQhxzx+c0wJ3+wutbfzG2Ml
	ekYHvqQQQNuNXfCMDFmBEX8W7hhPcSzexht7RRtUUkB86KbCey8K07F3/6evMM2hi1fzfzADkVi
	nanKw5UIL2KEx7ijTSKwq5QesCwWWPC24zrKl+tSvAoCIGtujiRYjVdN9DS2kmZmWJHPf/IM2fL
	ZGBBmOGMyq65U8e/u0sEwTdLU3kb9sepJu6aw
X-Received: by 2002:a05:6512:3d29:b0:5bf:d60a:9802 with SMTP id
 2adb3069b0e04-5c1bc806744mr4597626e87.18.1795572637275; Tue, 24 Nov 2026
 18:10:37 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
 <awXr6iHBR54wBB05@google.com> <CACpmpodH3UUDLEze8=5v8LWgKnZWQVrQBhzSGJFY-PwEYmHEzQ@mail.gmail.com>
 <awYsDfYqrS2ldOTw@google.com>
In-Reply-To: <awYsDfYqrS2ldOTw@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Tue, 24 Nov 2026 18:10:25 -0800
X-Gm-Features: Aa3M54qALWhKRISY9YLBLu3ihm-qdLfUy_KIL1Y148EHluJ1sIurum0NLZUmUvA
Message-ID: <CACpmpofsU3f=PVQF4moe6n=_qit1ZGyo4FMjyM-sVgumfyN0iw@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] Batched zswap_store() framework with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, hannes@cmpxchg.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4E3DB1A000B
X-Stat-Signature: 9jhdn67pqz6ojtes36st4m4zsh334pzs
X-Rspam-User:
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795572639-281499
X-HE-Meta: U2FsdGVkX18PmlVssWynk+03YXxIBg7oF4oCUxXakYn7qouPCtxoj9OSXu6H+zefnY1lk0w7ee/mSbn2mPfZo7sMFVyOerfbOoschim2iNrDlwvtx3Qv1zQb6RrTaLI7KywjakX0K9mgho5bnUW/CnlxxJcU/2mlp7MLqpp/cRGnrBU2m8ICiX4/h0pIZIIeCqYcZRLv8N0ZCJifYc/MCTr4hngxwoIwBxcY0sKzuBikTDXYbm3K0ma1Q2Pw4WtCqDb0qN9BrAaPhO0//BMeZQnSx/33nayzChSN17F0pGAOFP5HyKA+GesvpBD+chmDjEpnD8CVla+k7KNPLIrVTINN/w8LNU6V0EO6DIzBRYtLIa83fYGmEyp3w0kQPmpz50hQD47M/NLMBVwykzdSVYoOK5G0N0nsJuTZ3z17BOeZHbVVCmbNybWaJ0ghgKsX1LBeQVv5/rvYNu8N5sozVxukDs7jE0hoDG9ryXTQsF+0anJJvWTN+EoWCN0eXTbTbJefJotKaUi6FfXu/SosFVqG05lu0fQqwE4gQQ1Og1J9duFE+hinNWTu6ZEXGkD5fBbXYvhTzH8b0WoT/kez40yrLJ9+jBvzc5kolOgcj0OlJyPMCg4kQJr5PSRpX5mO5KfWck352cIOinU2EBmighb569GbhUyy2W5+VOMJb24VE9c387uKkKmWB7NJuYrr8TwfPUGoH3J5aVDkwuDke+Y1LELpAZFmn9pxCFWNWIsJnoJmZGuPZIxGvXWjoo6Q/8029XXpNDJsp0XuxXla40G6lgzAoccsoJyc7S2OBJmy0xxOAKrjNVO9+VRQqwPAX7QqYf/SFtVLqMcy+NgkdkUid3gw6zsrN4sfy+Sactg6yhFO7+ZJfR81n0ZKZ3XxaRamp1H0C/Y6q1HDG9u9KR3Wc9DXs2J7kBzOV9pbfQyfG6Nt2OvMVhFOLPgVBKLJk5cwIj/I5fnlIcboYw3
 FY4/BsxX
 5nJmHakOh3rkaJR6PoCKtXM/oDofqgYz3VZYA9dFs4JK8ndrJzr9libr9Z0TEsvNNRHm3nmm+xAlCVwqJYvR+vdOclzERA2yGeViQlh6wS/jmm2lZsTd+UBGk+wwyJC0dsDfYlsMx7E6gX9BB63wq8IkepvKZlX7wa1kQrtHmRRtlyyntITVOO2uDpi87WH3fod5nIbXiaVT3Lf3Wev+kQpvwHWHqF/coTPC9aQ/Sk0DH7WpclGpF7kgojYVYIE8MmPzL8bW5uoI4YEOumRhhHQi3BKOZp5yqvF3SAXSaHzKv3c87eKbA1S+MuiZIo5piHAdoFf5N9DiHVht9lIVWVASz1TIAeMEOR6p79hfdDOV6DafAbDz4ozPDjmyVKINu9TNFhERHy7aT0IJNPV57z6DUDQQketwEVF6jGo9QVkMmO+dD+plAk3xaoSnIH3mFGtv6C6l/YJSBKRfNVclVg3ZEGIoxw+S3DExKkrhljL5AlsHx5o9MQ2I21oTCWNfewuEQTAErFiYg8xzLU1ly4hN8B3C0jBUW5U/3dWAPHRvMvyU08gQSR653sLnAymDycnx4lu517l7xUsgQTFmFmIcFpFV0WKjySGYM6G3F1GQFx+zy6+qH+9aRPzwNiKfdgslnaiQfB39ufLECcTCl3QXxb9lO9OvFdZ90rBOH8W0Svxm7MEcxZ80aNllXJ+QPRnliLQk2CFE4jzrrUAWams5R0xXU8DPFYRiN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 4:59=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
[...]
>
> I think the real gain comes from making the freeing path faster. What I
> am saying is that we should optimize the freeing path rather than
> batching stores to get better locality in zsmalloc pages, as this only
> speeds up the freeing path when most data in a batch falls into the same
> size class in zsmalloc, which isn't the case for real data (e.g.
> Silesia).
>
> I am not arguing that usemem results are not valuable, I am arguing that
> there's more to the data than just usemem latency/throughput being
> better with the patches.
>
> The hacks were just a way to test the theory by eliminating zsmalloc
> class contention. I am looking into proper optimizations for this path,
> the goal was just to see if optimizing the class lock contention in the
> freeing path would achieve the desired result.
>
[...]
> Yes. I tried rerunning usemem on a similar setup to yours, and
> aggregating throughput, total sys/wall time, as well as write/free times
> over 10 runs (write comes from throughput lines, free comes from freeing
> lines). I did this at the baseline, with patches 1-7, and with patch 8
> on top.
>
> usemem30 (usemem -w -O -b 5 -s 10 -n 30 10g):
>       kernel   sys_s (mean +- sd)   wall_s   write_s  free_s   tput (KB/s=
)
>       base     2355.6 +- 25.3       94.24    55.62    26.82    212,239
>       p1-7     2366.7 +- 22.9       94.65    55.91    26.90    211,108
>       p1-8     2197.0 +- 37.9       89.65    55.48    21.66    212,853
>                (-6.73% vs base,
>                 -7.17% vs p1-7)
>
> AFAICT the speed up happens on the freeing side, not the writing side,
> so it's not really zswap stores getting faster. In the freeing phase
> (66%-100% of the run), ~90-92% of cycles are spinning in zs_free(), and
> total cycles drop from ~1.64T to ~1.30T (-21%).

Can you please clarify what "write_s" and "free_s" refer to, and how
are they measured? If you are referring to the gettimeofday() reported
timing done in user-space by usemem, these times measure child
processes' fork, do_unit, join, etc. : IOW, not a reliable indicator
of zswap_store() performance.

Also, there are no calls to zs_free() from zswap_compress() and
zswap_update_entries(), so, it is not clear why "free_s" reduces from
patch 7 (26.90s) to patch 8 (21.66s), if what you are saying (as I
understand it), is zs_free() results in the gains.

>
> Running perf on the baseline:
> ---------------------------------------------------------------------
>     # Total Lost Samples: 0
>     #
>     # Samples: 465K of event 'cpu/cycles/P' (time slices: 66%-100%)
>     # Event count (approx.): 1636895619486
>     #
>     # Overhead  Symbol
>     # ........  ............................................
>     #
>         92.29%  [k] queued_spin_lock_slowpath
>                 |
>                  --92.26%--queued_spin_lock_slowpath
>                            |
>                             --92.17%--zs_free
>                                       zswap_entry_free
>                                       zswap_invalidate
>                                       __swap_cluster_free_entries
>                                       swap_put_entries_cluster
>                                       swap_put_entries_direct
>                                       __zap_vma_range
>                                       unmap_vmas
>                                       unmap_region
>                                       vms_complete_munmap_vmas
>                                       do_vmi_align_munmap
>                                       do_vmi_munmap
>                                       __vm_munmap
>                                       __x64_sys_munmap
>                                       do_syscall_64
>                                       entry_SYSCALL_64_after_hwframe
>                                       0x430ef7
> ---------------------------------------------------------------------
>
> With your patches:
> ---------------------------------------------------------------------
>     # Total Lost Samples: 0
>     #
>     # Samples: 372K of event 'cpu/cycles/P' (time slices: 66%-100%)
>     # Event count (approx.): 1295809013413
>     #
>     # Overhead  Symbol
>     # ........  ..................................................
>     #
>         90.75%  [k] queued_spin_lock_slowpath
>                 |
>                  --90.72%--queued_spin_lock_slowpath
>                            |
>                             --90.03%--zs_free
>                                       zswap_entry_free
>                                       zswap_invalidate
>                                       __swap_cluster_free_entries
>                                       swap_put_entries_cluster
>                                       swap_put_entries_direct
>                                       __zap_vma_range
>                                       unmap_vmas
>                                       unmap_region
>                                       vms_complete_munmap_vmas
>                                       do_vmi_align_munmap
>                                       do_vmi_munmap
>                                       __vm_munmap
>                                       __x64_sys_munmap
>                                       do_syscall_64
>                                       entry_SYSCALL_64_after_hwframe
>                                       0x430ef7
> ---------------------------------------------------------------------
>

Is this perf run at the workload level? Can you also share the
zswap_store() perf breakdown? I don't see any zswap_store() callees
here..

> Adding some instrumentation I figured out that ~all memory from usemem
> ends up in the same size class, hence the better zspage locality from
> the batching in patch 8.

What does this have to do with batching? All usemem memory compresses
to the same zsmalloc size class in the baseline too. Can you elaborate
what you mean by "better zspage locality from the batching in patch
8"?

>
> Here's the bpftrace data I collected, I don't see a material change when
> probing zswap_store():
>
>     zswap_store() (2048kB PMD folios, 178.9k calls):
>       metric         base           p1-8           delta
>       p50            10.76 ms       10.85 ms       +0.87%
>       p95            11.34 ms       11.40 ms       +0.59%
>       p99            12.15 ms       12.05 ms       -0.82%
>       avg            10.80 ms       10.84 ms       +0.40%
>
>
> Also if I run your modified usemem with Silesia like your previous
> versions, the improvement goes away (because data no longer all goes in
> the same zsmalloc class):
>
>     usemem30 + Silesia (usemem -w --read-silesia -O -b 5 -s 10 -n 30 2560=
m,
>     memory.high=3D38G):
>       kernel   sys_s (mean +- sd)   wall_s   write_s  free_s   tput (KB/s=
)
>       base     1779.0 +- 8.5        72.84    55.34    6.92     53,290
>       p1-7     1775.7 +- 7.3        72.81    55.29    6.86     53,337
>       p1-8     1771.8 +- 7.8        72.58    55.19    6.83     53,435
>                (-0.40% vs base,
>                 -0.22% vs p1-7)

Is this with PMD mTHP? Also, we would get a better idea of concurrency
by increasing the memory allocation duration by allocating 10g per
process, for 30 processes under memory.high=3D150G. 2g gives much fewer
samples to be helpful, imo.

[...]
> I am not saying there is no performance improvement, I am saying the
> performance improvement is a side effect of locality in zsmalloc, not
> faster stores, and that it doesn't reproduce on real data.

I don't see the connection between batching and "locality in
zspage/zsmalloc" since compressed size is a net wash between baseline
and my patch series. Are we drawing the right conclusions?

> If we want to address lock contention in zsmalloc freeing we should addre=
ss it as
> such, not by batching compression.

Lock contention in zsmalloc seems like an independent optimization
that is good to solve. What I don't see is a way of explaining the
gains in this series based on zs_free() lock contention, and hence
drawing a questionable conclusion that this series does not optimize
zswap_store(), and further that batch compression is not attributing
to the gains. I have provided ~10 reasons as to why the combined
zswap_store_pages() batching and zswap_compress() batching improves
zswap_store() performance in [2].

[2]: https://lore.kernel.org/all/20261120041906.5785-2-kanchanapsridhar2026=
@gmail.com/T/#m51d7d13809d508a9116904c01bf3c94fdf2981dc

>
> >
> > I would appreciate comments from Nhat, Johannes and Andrew on these
> > posted gains/analysis:
> >
> > [1]: https://lore.kernel.org/all/20261120041906.5785-2-kanchanapsridhar=
2026@gmail.com/T/#m33e586ec89ed46790da284e7a2f6d99b50c9f935
> > [2]: https://lore.kernel.org/all/20261120041906.5785-2-kanchanapsridhar=
2026@gmail.com/T/#m51d7d13809d508a9116904c01bf3c94fdf2981dc
> >
> > An independent replication of the gains posted by me in this
> > patch-series, using standard mm-unstable and vm-scalability/usemem
> > would also be very useful.
> >
> > Thanks,
> > Kanchana
> >
> > > Regarding the bpftrace
> > > measurements, I couldn't reproduce them. I think one factor is that
> > > probing both zswap_store() and zswap_compress() makes the zswap_store=
()
> > > numbers different based on how many zswap_compress() calls we make
> > > (which are less with batching) due to the overhead of the probe itsel=
f.
> > > When I trace zswap_store() without zswap_compress(), I don't see
> > > meaningful changes in latency.
> > >
> > > [1] https://lore.kernel.org/linux-mm/20261016120927.3191690-1-hongfen=
gchen@xiaomi.com/
> > > [2] https://lore.kernel.org/linux-mm/20261123054746.2579253-1-senozha=
tsky@chromium.org/

