Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21D7DFD460A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:07:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5496B0088; Wed, 25 Feb 2026 22:07:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5632B6B0089; Wed, 25 Feb 2026 22:07:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4618A6B008A; Wed, 25 Feb 2026 22:07:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30A5B6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:07:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB3AA1B6DDC
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:07:26 +0000 (UTC)
X-FDA: 84485122092.05.A423192
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id D478F14000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:07:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P9re7bHy;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772075245; a=rsa-sha256;
	cv=pass;
	b=4jYu9tJTN4an8f3wob5S6lOEt6d8tdDugApRCkaCMq0ejyjKqT94w2SgPE1PX+TOTTfxzq
	wiPud9OpDzSV9P8EBNygr78BmyfV3yAgkGIHMvoQq86tVXMfq+YkFtZVPgTP9bwwu1otWx
	J2h4zeAJaeehY8s8iY0561BKvgt1zB8=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P9re7bHy;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772075245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UD9eHWefjmBDyyVrYbi1gZmjIDGqZz9yxYXjF1yUBzE=;
	b=pNkTMb/5Att8fo6TYO26ZDJJDWi6eoqZ5KUk+Iqg6Mlx+AJL3v76pm7qvdxbJTlrttjkM2
	lNU64JRpSBtVB6tBZFS9gFqJVYwmfjiM/7XunUBadUZDJl/491diseakK36ycvsLm17i+A
	S9DD9X1rAF/TApcrycgyrtCMPmu5sgg=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b8869cd7bb1so54365766b.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:07:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772075243; cv=none;
        d=google.com; s=arc-20240605;
        b=ErfRaGdUtnTEdpRlw+RrCLhpF2XLzdjW4qfivFtIklNTEJsLA7xXeEaU8wcvsr/Aui
         hP3iVQitrnUIzUqH+9gmlG9UP/7OocUpeu0gYqINHhqUn2NuIJ63WM8CYl2Xswbc+d0f
         +G3JZ2JsnDA+3FQnWB9xQtNGX+8NJnF7PzMxoQ43ja8ObhS2oBHcxQ4DaAkPgkqwto2M
         w7+90nviwh+6JTcqLb4n71ijIxzSEySGnZZTIMn9yx9VRs5jDDqsRy7qxAfi1ZxJHvua
         zUdaKgSVZ+VzswwkhN6xH+pDxnHSeWHXdw+3bWEF0ZGx/fVd74XwlDtLcNTr5VoEyry+
         isjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UD9eHWefjmBDyyVrYbi1gZmjIDGqZz9yxYXjF1yUBzE=;
        fh=iFM8id16HULzZaErZKe4u6d3KxosCWOzsOxRrMsBW2A=;
        b=YBxk3OaGVMuup5ImCE9/kPmL20Q6dsd/2OaWtTunqctg7cJ4ShpDGgVGuxxf3MnCJT
         uZz96navbUw/N1XAfXPgYWiSoXqPBQQNiej2Vp/PUcprnh8d6hg/yaMKEaBAFdW7ZWgK
         92XD9eiE464LWg+a4+FHkqpJZpfxGiE2zKY/hoRYiDJFDeIB/jxDGHzSD0+Zi7RidZ1m
         GqQcWiBeOsce0qUK6A0Twrxd8JfBtmv49WX1dFo7LH6WiXYkGmM6jL7g7zChR6MuENqJ
         L0n52qfSKQrTiBc+PMtKNmZ1LsGgtotAdT0pruo2j1g/elID5KfDq5Fhigf/1YPJ1NDB
         dxJQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772075243; x=1772680043; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UD9eHWefjmBDyyVrYbi1gZmjIDGqZz9yxYXjF1yUBzE=;
        b=P9re7bHypZoKqomO3jBp0RjyDYTRJ4rvObaAcKpgOY3V/NQM1Dn+YrfR3DI10fSqED
         DqMq7m/HUc8bbMG0x+o1/IPAO9VrhvygrlxeWaUZmKUjthcaKyOBiWtAARaxHZPZHnER
         ss9TS7CEb4DW3rBCogC8GRrgxsbXRZNC0PKdFsXjX/gfWGqcnajVckRoj+z+tqWzGs9d
         +WI7YaipBbVqogLhbFPN+YzyyHmhv3EQp+69C4AZR5NXhLUkPAY2oeS4DjZRX5gw7JDv
         74GTRSCeAzQ964OCC9iSSxfF7LbSa/oF+57I5IO85BbmpwFeorP++76oExko93dA+tVA
         mvMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772075243; x=1772680043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UD9eHWefjmBDyyVrYbi1gZmjIDGqZz9yxYXjF1yUBzE=;
        b=gLzaTeZ7Ufy4ImmJLYPNnOxM3vwxuxAievLPJ6n6CJTyak9zlAzqMDYBRy+mr9s7LZ
         GKH/aWa6X6D6eogh6fo8B6+DtetjxTymvTt/ARUHkQCiO1IA6OCSrXsrSy7lM1kCM2P8
         rWz4wRPlukxYYwPEYKBQAbBrE/VeQVLqy4Pz4IycYehKAk9hekQy/ZTCuCne9wtAg8p4
         19Iup5GelbzGSmmWvPndlFlaNQnygy03at9+eZ2R7Yy6UxX1+HGwe18nkMEGLXnpbidb
         PeoiG9rKelcoruPMiORqPZVOCR34Zi7lg/dwueMKZU4f/ru6FCEp5uLYLJos4syzXzF6
         6tGA==
X-Forwarded-Encrypted: i=1; AJvYcCUTEHNAmFqHHeWnFxG9T83LS4jHNrQgb1Dcai8GOLGxwpMd2sicsw1kf33oYGDgx2dE/lekwkPhvQ==@kvack.org
X-Gm-Message-State: AOJu0YxFj2ls6hS8n2c+8pUbpzc41y3j3n4GCkg0iPhCGkpsein+oG7C
	7s1Vj3qcOj+wXJF+8BFzR5VziGglsqWIKVxDbjIkcaMRSVmwFWuGEDKo3SuTyPJ5We6Pl/9Q8Xb
	kJiGoBt5ySb7htD+FS42Td1ladjbtz+c=
X-Gm-Gg: ATEYQzymf5ZVDmrxpNX4R+0WBq61BqBBX+VSj1B51EMuSQABOTqFevksDY/6PGXcpll
	VPztO+/knZFsc9v6XnfI/68qs42TXO7u/Tdn9x+mH1OR6uAMsiqpwgeQoHEg8SqLz34i9uz7TAl
	6ZpCuPdgiuHZTOXC4dBdb9+3N+Rrcdl6WL4pxcrkf1mtMps/1MLsmHlfrO6DW9HfcfluyhPwY6t
	79KalMYLqITW10NDvGgzNaWILVQVtTvdW7tr9RpCXSHPGAg9kyJ8AykLmFOHq8BpdXKC3CbEFG6
	iZwGBAzIhwvt0fEwwomQJ1qXnTEOiVHUqMlMFF6x
X-Received: by 2002:a17:907:3d10:b0:b88:e09b:88ac with SMTP id
 a640c23a62f3a-b935172fb73mr175254866b.29.1772075242780; Wed, 25 Feb 2026
 19:07:22 -0800 (PST)
MIME-Version: 1.0
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
 <CAC_TJvfi_5n2crGHbRVO0R8jdYcSCmgzUJPzhtSvWeCN6fCbQg@mail.gmail.com>
In-Reply-To: <CAC_TJvfi_5n2crGHbRVO0R8jdYcSCmgzUJPzhtSvWeCN6fCbQg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 26 Feb 2026 11:06:46 +0800
X-Gm-Features: AaiRm52rmqCtV9BPRYLzlMLHICt6_NYAz14VF_Mx49K_49eF1XBu2D8c25yhS3M
Message-ID: <CAMgjq7BeBEeV1yHYd0fh74m452nOY2sSMbmGBakuiLVRy0CkdQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improving MGLRU
To: Kalesh Singh <kaleshsingh@google.com>, wangzicheng <wangzicheng@honor.com>
Cc: lsf-pc@lists.linux-foundation.org, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, linux-mm <linux-mm@kvack.org>, 
	android-mm <android-mm@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Barry Song <21cnbao@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D478F14000B
X-Stat-Signature: cgopmycqhza3ex9nyxaq14y11os7buk9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772075244-774220
X-HE-Meta: U2FsdGVkX1+SJkQENsmWabAk1YOTEocgvP859g3IAbHtApvkjZtYiLGlEFMUtuZasKgFd6M78d+9lwo/7dsH+hfWIAvi31iPAMxW+j0KcHuaKqhoKvGULX4qzpuaC+wmt7pgih0KEfc9uO9fd6VQFdffvcIdUB/YkB4q8pkE3fUTjjyciceIc9SaVKWZY2/qoNHBYX80YPFeoVsWIEXq7Rv93ahRY70OmhVZ9SJXMnY1bIGP9iY+jSXkWVm49DZ5LwZvelFbVfV0RKP7gVTQHMk/a1ev2Bpzq31qrKTEMMwtLnQ7BkEv8coCr7JgCHyJEpn1kGgosYAt+A6gFwB9rSILSJ0qf5wgzSYAdomaf9YotfvxFfXE9VMlypjDxfKWAzpSw273ZfyLajeFpObDtDfE+k6CfIYYTwI+1J+z0TsyuWpv0Ko8bz8bqs5x6F47bEcFvcTwET9y9R4+8hsy+RTR3eG9gpBUhda8psnGcR6i703ce/ij1EIbA79yUiqaMdKfUA39JQgJD/jWn1HQ5rexEAVLaihqAWv13N5BoQCUiGSYwp5YL1tkyHneqxJruFAEt5Y2hob/M19FoR93/F60QSFSvc1ZmVlMTfpvcS4iGYjuw4vWDXMLfKikl2E+3NQPnv9kkMW4R3rlxXbObmoaHp1WYD/0A6HbU3jH5f/SbloZsLMEycx0OT0+ee/pTOBBadtDb08GjmzpMHVhJ6hMQ9uwX7oA/akVk++xdljHoskBBfyEF4Zay8R0lAP2w+viZCezCN0bZn85x9gfXlCP0Gwr0B4OReObzgbOxRpR+rt3hsGBpvZxNr1kxjIpTv3p6DiyiJt7rmdLclxBuDnJlI6ctaJZQruYlTprNYVlPMpxRV1BzfT1F8IX+WjGdL3Sz1e99W70lUKlz/f5aQYAko7NPFwZTQtWRj0Kq5i6xGh8S04bNKbM8nFGlGLpuUB96uN8jFDojtmMQ3b
 WCV84Rhw
 Qqq/TM22HRqDmxNDFwIg7zs//mbEK5BtdcRS69P8TpPJETdrR/8pFSNkBcaMDjD9NxpTvhvCh7VLKBibUVfCosoX2t677Npr3HtlBA5GSgIpWip/RcT1lNPV4cJN5/t1xFcRwMHktr2mILOybldecKY4TZqPKyu+rL3pKprbt+AKe4BFOmzUP3lTxLKV8/dZnl7/TNGeJvkktYCUAhN0FnT3z0DN0xJh/Zh8ZBeg8fY2BmMxDZNsIEv323Gm978sfAh4bDp5Ju80zBCiy8IzT418ggBXOdpwWyKzb5xHm+QmGnKMGwJTK5kO8Z4GfP+3VCFz0X37mtn5Ch+MzGJ+4UrhjGScRYMIlKgPeDyz2uS769LND3V4A87SnCwBnVUZjrOJD6ftvY0OGt0IdhPh7TkhANuzIF4gn9twO4Y6vqC6I5O9zK5QhV+x1ivEjHWwYIX3x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 9:55=E2=80=AFAM Kalesh Singh <kaleshsingh@google.co=
m> wrote:
>
> On Thu, Feb 19, 2026 at 9:26=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > Hi All,
> >
> > Apologies I forgot to add the proper tag in the previous email so
> > resending this.
> >
> > MGLRU has been introduced in the mainline for years, but we still have =
two LRUs
> > today. There are many reasons MGLRU is still not the only LRU implement=
ation in
> > the kernel.
> Hi Kairui,
>
> I would be very interested in joining this discussion at LSF/MM.
>
> We use MGLRU on Android. While the reduced CPU usage leads to power
> improvements for mobile devices, we've run into a few notable issues
> as well.

Hi Kelash,

Glad to discuss this with you.

>
> Off the top of my head:
>
> 1. Direct Reclaim Latency: We've observed that direct reclaim tail
> latencies can sometimes be significantly higher with MGLRU.
>
> 2. PSI and OOM Response: Tying directly into your point about metrics,
> the PSI memory pressure generated by MGLRU is consistently 30% to 40%
> lower than the Active/Inactive LRU on Android workloads. Because
> user-space OOM daemons like lmkd rely heavily on these metrics, this
> causes them to be less quick to react to actual memory pressure.

Yes, this is one of the main issues for us too. Per our observation
one cause for that is MGLRU's usage of flags like PG_workingset is
different from active / inactive LRU, and flags like the PG_workingset
flags are bound with tiering now, so changing that requires some
redesign of how tiering works too. Which is one of the motivations
behind the LFU like tiering design I mentioned. That should make
things like PSI or readahead stable again.

> 3. Misleading Conventional LRU Metrics: We've noticed patterns in
> standard memory tracking where nr_active and nr_inactive show sharp
> vertical cliffs and rises. Since MGLRU derives these metrics by
> mapping the two youngest generations to "active" and the two oldest to
> "inactive," every time a new generation is created (incrementing the
> seq counter), the second youngest generation (before the increment) is
> suddenly recategorized as inactive (after the increment). Because the
> newly created generation is empty, this manifests as a massive,
> instantaneous drop in active pages and a corresponding spike in
> inactive pages.

That's also a major problem for things like K8s. The cliffs and rises
confuses the cloud scheduler. Our solution is also based on that new
tiering design, and counting the number of folios in different tiers
instead of gens will greatly improve the usability of nr_active /
nr_inactive. Whether this is a good design can be discussed.

>
> I'd love to participate and discuss how we might tackle these
> regressions and metrics.

Looking forward to that!

I also noticed Zicheng has another proposal, I've discussed with him
too previously about some ideas, hopefully we will make some progress
on this.

