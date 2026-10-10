Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C71F9CA9EC0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 00:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9676B008A; Fri,  9 Oct 2026 20:10:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B7256B008C; Fri,  9 Oct 2026 20:10:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F896B0095; Fri,  9 Oct 2026 20:10:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30B1D6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:10:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A29771405C2
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 00:10:31 +0000 (UTC)
X-FDA: 85304785062.11.4C01685
Received: from mail-dy2-f9.google.com (mail-dy2-f9.google.com [74.125.229.9])
	by imf16.hostedemail.com (Postfix) with ESMTP id AD049180006
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 00:10:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lQk0dkmt;
	spf=pass (imf16.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.229.9 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791591029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cR/CPJKG3NoiCnDGVGJZMEP7USNRf/dhi11bwg0wPvE=;
	b=Mi9Hew6ZEhpPFe26Up+caJ9UVpQ/bE1pT/hDm9PAJt092KTguZdH8o7udNfS/BvYHY8huU
	IfcTjBL5AMjuITSDRpBqZxyhZJq2VUET1AhtRmZs1MVMYMVav7BskHGLVDneG6wW+fUABl
	2t8UqVqr9BznXpLx7rMataKPZ1gHvJs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791591029;
	b=0JqD1A3QEw5Fy7ZA6xc9NJgkS6JL42fJwXB04gKKx4frLnRIKfJO2oTPOmbaelgfMOUbBt
	wpII8u+nNbzvJ5s3g0qulrbFRsX4SGQiIEzZABtOWSiMgCsAmZS/v/aeuFls4EHUgcvTEb
	baRdUXM7IO3PdcsHuaDi5hrYt2YyvDU=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lQk0dkmt;
	spf=pass (imf16.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.229.9 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-dy2-f9.google.com with SMTP id 5a478bee46e88-3514b7a0a23so204303eec.1
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 17:10:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791591028; cv=none;
        d=google.com; s=arc-20260327;
        b=kp4wbkxKTutHJcCbbNzXopuYR4PCcW2T0E38dvj5XY3OZ8ah0Ex54GIohR2rWcUs3B
         3Q7qTs00RXpHPzAORYCt+Rh4U20YrtjKvrV0oeAqVVfnFtpS9y5wkKjCfD294hBcsavY
         9F5Yzx4vlG3VfOKJcblDweGkCo+NmGSftZMQA7bGq1xeLaOFcyTep51mLLcKYt8T/7MC
         UTqmot9PND574i/WYrLALdf2Lt1HsNfvYwxHqT8tpkD2QE6pyMTeRDy96jKY784Ebpjd
         KD+urVjOzvXVqSL5aYJI5uOPhepUbB+00WhLOsfsxBJad8OkPvKf/DfvSLpDOmrKpika
         We3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cR/CPJKG3NoiCnDGVGJZMEP7USNRf/dhi11bwg0wPvE=;
        fh=/TcIzl5bz6PzMGc3hml1oZtGG6B9yy2ozDnti8InJVA=;
        b=cYKvONNjhX14ruioUndCsUPLlVNJAsqBauF+Aw8kKu9qu/z4nGiRrXz3KZrTqLx0YE
         HhCiuT6/AGwyHkRj04yzFyd3w8g6BD1TO0dxy18cVx6o4TEps4HUCWe/fs0ixHUhBII+
         aiTmInV8IslxHEg8PMX2Z3PV0CXLiNi33PAdNcaNPkbE2V7Dt8Lqq8IJUvR1Hy+jYr0p
         DafkdVC052o8LU1xWv6dvZJ6tXu093rkVblZNRiGo7Vm/hsku8dhxIq+LtWXp6VSCrRX
         Vs880pqOZKQs0lAQjp6yYMJ5FSwmfq1NsNt4zgFm1rC4CsIVCOMM1Y3JTsxf1NXqjX5r
         D6Rw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791591028; x=1792195828; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cR/CPJKG3NoiCnDGVGJZMEP7USNRf/dhi11bwg0wPvE=;
        b=lQk0dkmtKgxtcVL5KjthrVoBzToHUZ79DW96X1TYVcIOUKJJLLRuyXtSPGq+Lm7iW1
         aF8WODGav0IOPtg82tIfLpchIZ/Q40EHlJYXSMJ+m2bpYouNIVUXg+AjrpwkhmRvHMOh
         X38Fwo/a9+sdLuF4lQnyuljenE9rvhVk8l2Kw6vj8/xUgza043Vphv5+jXc8PDayH8jm
         M8Qg1vyKEA8TtXQpALG9jF5sO5ZNAArwzgkT26ijsIbAo2CCLiZVKZYPlvywJMeQPwnX
         nCBNGZ/q17vtOaRHOQXQwhkvHdI+LWp8h4hegY9kY4UDi792+6Fe7gInGyJMRfguiTOv
         zDPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791591028; x=1792195828;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cR/CPJKG3NoiCnDGVGJZMEP7USNRf/dhi11bwg0wPvE=;
        b=1kNw86amY3zLn2y4eK9CBRtGUTyE141oyRFhPp2x/GAvebtJBNsozAZkqKvSXtJ81V
         rkE7damulxlw1orK3gJaswFfWrs1RyThECazEUQOiTz7ARibuiJ/iGhQ09PXNLR8ECpz
         Qzb+qjVgKlgqcGVeb/SXYDeYbLxOZ94/tMl07PRuMtulBe+CRGM7NNNYmev9GKyjLEUM
         00abg4lFixqntlvAgudhvTnGqJ+2xJluLJOqV1O8atBBmVj0ojI5kGJ5/FHDBnBJ2GHC
         TXmaHCrfJi13UFfGN4IkpKr7g83+gadffzUnx9Relr74M0L63fkKXZFJgAMP04GN6br6
         JlHg==
X-Forwarded-Encrypted: i=1; AKwUvBytjTnUhE5dm10iBE/aPcFbAlVTroGu4I+AYfvVdcuVSk8530moQgFz6u8euRe5HlCJRFpAAFDlLA==@kvack.org
X-Gm-Message-State: AFq9FYLVFmjVrF8hMPO8sjUat05wr9Ht5iYa7KBiKBPUp9FW1txZrJIV
	CJMPsGv3xdg5Z0nkRbVazuXCckORQSquqKptlGJVhqe2dwQKH6SeFvA//8goBVe7o5PXWwKaLQ5
	w4hDk5qLbXTYePIXzAuIS8Aa8W6w2HQ==
X-Gm-Gg: AYBFou2bRhatfWV2NXiGqfUL3z2nVj2GGn6ci+cXM4sCVVEWj4X1y24xS0D/r4V/P1K
	LiIb5PDWOCc3MJw9qCTfW1Rz7qEIpT8tJBOC74QTQhHQiD0uG50ouNPMzhFq5aeG2ChsxmpQ29u
	Ah8+EKC1Zavgbs9cSU0kxRTEWWHSXCW5/zLWaX8x+rRzB2JiRDKljiC5WXBbgNYq7XBfAGiHl1/
	RJ70ouTQ4GkExvI/KMFlV+aMswquZLzG/EyQtw1fJ+AYD46mB3iLDO9bM8SqGmcRGLxI9TboBr7
	oYizwq0XzxEiawEhChon855YpdK8ScTwmt8ufsAGivKjXOD/oCvs/8Fs
X-Received: by 2002:a05:701b:2607:b0:144:f096:4dd1 with SMTP id
 a92af1059eb24-16a611c76a1mr3960393c88.41.1791591028199; Fri, 09 Oct 2026
 17:10:28 -0700 (PDT)
MIME-Version: 1.0
References: <20261003202727.3673-1-ravis.opensrc@gmail.com> <20261004080110.37328-1-sj@kernel.org>
In-Reply-To: <20261004080110.37328-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Fri, 9 Oct 2026 17:10:16 -0700
X-Gm-Features: AclHuK9iErDpI0ky8YsjjXHUJ1Bhqg2BvHDmttXO2gzSECAslgV1ytghZLxTEaM
Message-ID: <CALa+Y17H55dp07Td7oqhDPq0TmuWHFB9DNcXNZ91Su_di2vhnA@mail.gmail.com>
Subject: Re: [PATCH] mm/damon: add damos_node_eligible_mem_bp tracepoint
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Bijan Tabatabai <bijan311@gmail.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	Honggyu Kim <honggyu.kim@sk.com>, Yunjeong Mun <yunjeong.mun@sk.com>, 
	Akinobu Mita <akinobu.mita@gmail.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AD049180006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: xm7aerhitpddnbz86ng4j97kf9moedta
X-HE-Tag: 1791591029-482148
X-HE-Meta: U2FsdGVkX19ZwdBvEQRoUTlNWiQDObgDHu9ShJT3datd5O/aS6Vngy8Ap3km9spmyXmvggCBip5U1P0j4a0xQXcZsbzGfUxho8KJMgEtLcM1y5oQlyBm8fn2zpAhuALlaRyhCIR6OU+Cx6xM+ouubdGfLaDzZivKs8ByXUl5Vy5Dc3LWMORzgWR9D44aGOf8wbpj8WRqWbW7F+OcRl0L5fG6J30CJ1rsDdluV8YtgI4xJ34zuPtc0ibjRsYCd29xCnF6NE0KlWbMkUgO2F/XtclB11zfhxjVSPSkT/s0OJXaBziESGqDfFivrVRSZ3BbN0SXKpDnRn6JERzClUf9Q8XcDev/ae3FfcLrMs5fqabKeRvfb8C6zt6XPclhv70K0wQs64CLV9nHDSZlSZhluE+qjhltRAd6wfpQn2qGobuEI4Pz+CWi/uGoE1PyI4XhY6BXeB3nhIF2C/HOphz+LUjTnHW0AHlJzuv0vIcn7TLvaMhcqUuA+rHHd2phkllBUxoZkajF9zWMPA+rpaY5/dXeJn8FJQj22WAG/TaoFPQdXhfQYG6kDSdJkPc+zOLRed1KayjUe0XK7spghp1w45tAwb/mb9HtHh2/OicUxRv2ySnnyorvF39ii67unx35mXGXHCBkN3PBB9LgcPG/xwvq97HVf3bYPyXnEPzwdbUHUBHgwU0OIZYNs5CbTJFqd4Wz9h8M19NUa3pNbFLGleJnwkw13rX5oGLR9evEsIT2Zxauiff1gAcoXxtr+iZHyXyD6JjIwlSz7xXhK95qZIfyzaWn9QkIYRfP4cthe1OsY3MWXl8+yRkI/i1nFefn3ZKoGd0X4uUvmQ3pmtJ1uLxJcpZbJBD5gIfD17EowQWJRMTPkzhTyquEyGG2Sr1pLNmbzU56HSnliGTp9fajWxoJW8QO5l4n3YkPetjhvhBPwBZssG0yS5yLXQDKVntvqqGrgMtIPQk1KTbzWQA
 Zu0fJulR
 qBvmMDx+WvuvJHBtbskF725XY6ZPfQhOPOh17/0NYAlVPhao9XjTffXHKkwqaXPOs8kBkb2KG+9CT82BmWwGbPbCRFtfrW6kSktd3UMF5lEu6GqXSf7y6/vZJL1D9SQISQ6OLHNub/KFLMihigDLX3JxPkW7I2mv0n9xeppPdCYBJNSZQY3McxhaQw5D+lZI6jghYUCelkF9ydHtDRsMTaBtx6wV8jOrorTZ/CjYIWX+m+qTyIPnREfHw/z9dzW1kPx64gAk+3HxembIpoQnIK0/N1rN2YyNyqS0bjBPsAtdJC4pbUxmIBsJv5wU/Gqf9KSdmTXGjY9xZH+8HTbtQ/OWjfPI5sNssRVPfHcmvQ5te70cAkzV/2sRhgqY+MGruCYIfkOY2agId6TXYHU8G9PQretf+pvT3TvSCaPbOXZsqGVEpyzSV9jrHM7DU7grNIIMKXzlJvys8NjiWCslRnlVUifZGb/m9Zh5N1tDwVDyTFNd79r+Ru1a2f8cQadOl59n8WvHoC8hwoH/Ipn/5swE6Q2yOwXnG6xpC2G2kGybueh3koowatL+k1EiaYN+PmtUP2bbNNwnkGgRb0PLK5D38eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 4, 2026 at 1:01=E2=80=AFAM SJ Park <sj@kernel.org> wrote:
>
> Hi Ravi,
>
> On Sat,  3 Oct 2026 13:27:27 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > Add a tracepoint for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP quota goal
> > evaluation.  The tracepoint fires once per quota-score computation when
> > the goal metric is DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP, exposing
> > context_idx, scheme_idx, nid, target_value, and current_value.
> > current_value is reported as the quota tuning sees it, after the goal's
> > complement setting is applied.
> >
> > The DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP metric expresses node memory
> > occupancy as basis points of eligible bytes.  This information is not
> > exposed through any existing external interface (perf stat, /proc, or
> > sysfs), so the tracepoint is the only way for userspace to observe the
> > target and current eligible-memory basis point values at quota-scoring
> > time.
>
> Thank you for this patch!
>
> We have damos_esz tracepoint.  Have you considered using it?  It doesn't =
expose
> the current value, though.  I thought it wouldn't be real problem in most
> cases, but I can show it could be problematic for node_eligible_mem_bp ca=
se, as
> the metric value is not straightforward to see without using DAMON.

Hi SJ,

Yes, with the temporal goal tuner, damos_esz only
tells whether the goal is met, not how close current_value is to
target_value, and damo needs that to know when a step has settled.

>
> If you really need to know the current_value, I'm open to add a new trace=
point.
> But I think it has no reason to make it only eligible_mem_bp specific.  H=
ow
> about adding more general purpose tracepoint, and/or update the current_v=
alue
> file [1] under the goal sysfs directory to show the current current_value=
 for
> all goal types?
>

Agreed, nothing in it needs to be specific to node_eligible_mem_bp.  I
will rework it as a general quota goal tracepoint, emitted for each goal
evaluation with the goal's metric, target_value and current_value, the
node id for the node metrics, and the memcg id for the memcg metrics.

I would leave the current_value file as it is for now.  It would need a
stats update command or refresh_ms to stay current, and damo wants every
evaluation as it happens, which the tracepoint gives it.

Thanks,
Ravi.

> [1] https://origin.kernel.org/doc/html/latest/admin-guide/mm/damon/usage.=
html#sysfs-schemes-quota-goals
>
>
> Thanks,
> SJ
>
> [...]

