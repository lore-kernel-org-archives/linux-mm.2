Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB5A7D46602
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59DCE6B0088; Thu, 15 Jan 2026 12:05:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575186B0089; Thu, 15 Jan 2026 12:05:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1986B008A; Thu, 15 Jan 2026 12:05:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C14F6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:05:40 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DEAE2C1C70
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:05:39 +0000 (UTC)
X-FDA: 84334824798.29.F0D6B05
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id E207E20011
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:05:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=q0KCzg6i;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768496737; a=rsa-sha256;
	cv=pass;
	b=8UCgpuiEJQ1S51r35uClJBRXOTZSFjDGfEemLvhYY5W114fQT6+sqzkWcDPN+uoON2kIRO
	lFomEgfhK05vFuPk/ru6cIS5utt5VR7v6kIjjWR+8fEMRR3ty+Zk3FMcHPYTSQMtW3keoh
	lhqFioH9ZQa61UKtUfDZ/Yzvo0btDf0=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=q0KCzg6i;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768496737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=54li8Nl2hua4YlG/5pe5hANT9Dk06MGWYeEoawn3DKE=;
	b=5UDvoZV7Zs5V76iRWgcsSt0c2HJUHsnOGUQX1IKJF/N71uueL0tb4LP2tYRZeSdL5m2ZNh
	37RmZFsYQs7Nm7mByplvyw0ZA9Rsbvyf8/J1Ym3ZYT7CIm3OtTByOoBVFxt3QpxorXxojm
	Qeu6VSt6HvmhArz1yF8CYE0oUaCv6Bc=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5014b5d8551so537491cf.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:05:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768496737; cv=none;
        d=google.com; s=arc-20240605;
        b=jBt9ELH0+EJ6J4mbGhyYDiU46ZsCxAYwoBaq+2UM7G1MAZ+s2D3QYOnLURXnktTaGO
         4eZJo8iPeoaE7pSAAhPTTQ9LaUfjBojYhDmG3jlNoCLGjqvseo99oCS8mEL5WFbztPLB
         3BQOpDlNKLb0kgO8USv5IVelm/S7w0DMNHhJWssAN4m5v7sqzYZc0GLlbsIe1iPlP/nd
         cVYUeGrMwl+eSCdxWHd/UvGQeYotStYvlRkZEPx70fFQU5F+IPKLsKqYUMS2sxHshFb3
         dn1H0jeqDRBh5oB61V9G1SQUQHJK9rRkaf9tDTvgcekT11HPJz3E4727kzMjBbXdi34d
         WWhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=54li8Nl2hua4YlG/5pe5hANT9Dk06MGWYeEoawn3DKE=;
        fh=gAKozU44NQCEJ6KIrvO8EiOp7KuN/wcBGE2qyQ1PZLw=;
        b=HqoF5KvjtrhgtjXIyioxbg755Rw7ejDrJQ/XMQW31ov/adY+czWVY3ShpMip2rCFbd
         vrADg5GDgjaW6flM9fXqrx1Hq0GWH5o1NSOxbICZnrlZWeGqFDefaNFRSp/C+FXlHqlr
         NGzvO1GNt0jpTDurb5RP+pqMZ/AE5G2u/qw1Xfo/IoIoMp61geHE4TRRR3q7vGdPVdsd
         NOxwJUj1BLCBszom43dgsO7jmjNflOLakZs+nnAhwjBfRwhLq5ttfvr8sxg1cn9aMmkX
         Pc0VduZBH94exBBY1tNy+ya7a2k+TSDnOiS1VevxHLHJlXitzj8yVagzD19tDY+cQCGo
         /sog==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768496737; x=1769101537; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=54li8Nl2hua4YlG/5pe5hANT9Dk06MGWYeEoawn3DKE=;
        b=q0KCzg6iDajg28/DCcfxHWN5fAsyNJ48Vm4kSFwfNfTXZuVMvvRBcPxk+puGQT3trZ
         fo7VxauGo05cbqeUld9VjKOB95Od0niLkQeDZEPEwS+1lVXTAfVLI/hxDEWRkLmwFe76
         qVfGfxQjPYufYWmGzOg/X51FgIWBZFH/Kc9NKPt2WzGh0Iy8ASoF5VzzPQEzqXKyUL13
         4c9onH6VUyFUFEIT8PdW7BOgttlrhKjOW4JsRqWnPLqyPjWZkRt7KFjtTnopNvQfRHbC
         fvWCqbW92TRhCI/ZFoEEhMGjpKGrxQHuNONEPkh2K14jmHnnnRl7KrKx4foEFy+n2N/M
         GtCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768496737; x=1769101537;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=54li8Nl2hua4YlG/5pe5hANT9Dk06MGWYeEoawn3DKE=;
        b=HfCuL1/9LUaIyhtA1sQJgkebcxe2gNtVTjldKgWQ689pRxQ5IhMqMIi1SdFXm1D7jX
         2WHdX1R3z/4OmhOzrW325VL3oOahNhiRJvRNTw9KjKrFWkK+68o5suPhOjFH+aDyNm+/
         Os9d9pN34rHllO1hW8JzERdOXzMcyM09NpFwDqH2bsWmCebJkfJ28CArx2MgVPgb+wwJ
         cNg2rFvCiEWzSBxc+I89vPa0A/YTL8ay5huxZJhP3AkPb3tsRVGtyhus3p3VjgLu3XCv
         Rhq22CGfuG0kvgb/PsN8xn1c68Rkf/Us4o2dGl6zOdY5a0gIRsFr7s2etqlpdXNWGnTj
         aZeA==
X-Forwarded-Encrypted: i=1; AJvYcCWEn2sgBBx7NUW7jJ/ilwnDTTx2rp47zEy9w6nK086G+NDBIv9uZGyL0EBmp6Pm4+peg8bniVukYw==@kvack.org
X-Gm-Message-State: AOJu0YyZbJazYTUgzx/TdDMZ/TnQbb3+aubgeN/FlPFGOfuHE0+e7u0b
	CTF7A7+gSMWomdFvPUiz9iXAUVBe71vNuJ/PfM8HUuTWPT9+mwYrATQ5K7WU7xUjPj1IwgLPjtQ
	VH5PeO+bfSV9c4xg/yFkrvgTfDCW4yK/w5Ny+xHXR
X-Gm-Gg: AY/fxX6efoCPfeQU8/xHgvJQWx00I27m5Yx5iBDUapKSvmuMPe/vtlgSBA1YKpidWep
	Vdzdt0xEcyzuYwLnEV5iooAhSrnoFySlZbW9KlXmoKsTkvgXv/iht9sAtG6wxA9aAM86nxWR+AD
	+HZwoIKr08sKvVDz+zqQqalUDhgLVekW0gf/rwnym113duZq1uljYozdhFOCrah+RLYcZBYdf30
	/KYcCGO0cML+mbXQkOOHMI/dSvqLzW0SZ0Js0ndQ0fJalmJh/V+voc8SONnYY9hcuP8kM+OK2nl
	PyrE1YzKalYjzOtA4l+K5Y1oAg==
X-Received: by 2002:ac8:7d44:0:b0:501:3b94:bcae with SMTP id
 d75a77b69052e-501eab81d32mr11968081cf.8.1768496736612; Thu, 15 Jan 2026
 09:05:36 -0800 (PST)
MIME-Version: 1.0
References: <20260115054557.2127777-1-surenb@google.com> <aWiBv4A4QGJ1pr1l@casper.infradead.org>
In-Reply-To: <aWiBv4A4QGJ1pr1l@casper.infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 15 Jan 2026 09:05:25 -0800
X-Gm-Features: AZwV_QjrzboZ9bNCbx-dGc7Nl_6nQsBcpSB2Pv5eAnsjMWYU5mH2P1l-S49q7HY
Message-ID: <CAJuCfpEQZMVCz0WUQ9SOP6TBKxaT3ajpHi24Aqdd73RCsmi8rg@mail.gmail.com>
Subject: Re: [PATCH 1/1] Docs/mm/allocation-profiling: describe sysctrl
 limitations in debug mode
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, corbet@lwn.net, 
	ranxiaokai627@163.com, ran.xiaokai@zte.com.cn, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: s48nstknnums18p954as3kctg46ko3c8
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E207E20011
X-HE-Tag: 1768496737-305535
X-HE-Meta: U2FsdGVkX1+bHpoftSJklODbt0CVY/UPKCKPr0r4HPSVqhUXkh7mspYYPOPnvZaexVOK1uF6AgURYDzteHw3ObWErCJo3eM7jl/yKMbqnuUBoPVnPUUp9keYzTJQNEdsfnZMBzeU2fA3pCpH6fH/2jzlsoldrWcPsqglCrMPl5Eq3eoUUMXjb4jb2vhExVC8aam+jVEoEjeLxRZRcrp6J5XRlKUXnikLfkRWx6SH5toxNTpslR3zCFpFlIZ8n33W7pe2etjMbJwiX9k9JML93uXeejpeiTyTSVlXv1dcd0NsJjgLbjvamMdgBr3EDSgD11phwqy3Yu6eVSjJpAs6W9DA1ne5VQTsQloreeu14vxN6yOabwS1rxzGxA7Jd2j/3WXw/c+/NEf4szGg1rslrxBg9tegoLZDqYAHsfbyrvh4k48uJZcnThCaPbkgX/H/l+93CINSEx9ZrFKLnQlwtyqUhV8s1U2jrWPzMRTPYwmXedcvtpCt9vLCg7euVQ9PyzdcS1mvYjEO5eJEm7mi7/WiP3voA0lyPFcm/cf/VEa81++x03w1pomm0k6v+5JE7sOxTXTkbAOYQ/51SOi2z2yK52HgWlwHHvZDUUry+1AjTr8fuL0IF7h1F6uMOKzICKGYNuYxS7wphzCIlNEHr4NzdvgKkv47o0EzD9+3Q46Aj7EL/UPlEhxe3nhAHiU5q7rijWY1mhB2E+Yq77UgiaU2kBI5LBfc8Zv8txkhRmuHovKdoMyfkOeFxSCwfQGB2804oz7UFlH6zlpDaU+QF0x+IpXbYQ1SMvl+RRUwYOUIK2zHq0hpRJYHLBX9IJY0vRMZMpUlqOsI/VM2Wxnmnq3DGCbZnEmPHqX8Cy+xHvpt+s4sJC1XyLm7y4VSE0hqJzWtg4WDqyjgXJuh67mDNALtX/7PKajiMMHwc96EHl5YY3HsQXn/w5RGAJvYf9Zb+O1aDGbVLJPm81m7lCo
 y6+8u7Wp
 +U13eVMLzHDcbMYiU3a/wh5qdRpW2M+R+PtqWJ4CmSO88yuQAM6rpXPskzeX9cgGLoO5VwXxrQ+a4jdK92DOwlmLXXgwqEH2lrwyqmLJga0be6SWK38eTqvYv5RCssfoL8zo/icX0sjNMvjpJG8fyQTJv74Y2yFLX3z1IDKgYW1bANfqePi9I76Zh417o87vji8upKkEEwiz+kJrq7dA4SDOwnSvVlg+fC8qqyNn9evtOmmX+0rGcsEvBkGo52BDxalQ1gTKWvCCjkeN+/elDvyddW/5KTw59GbC/yup6uQG7y5E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 9:57=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, Jan 14, 2026 at 09:45:57PM -0800, Suren Baghdasaryan wrote:
> > +  warnings produces by allocations made while profiling is disabled an=
d freed
>
> "produced"

Thanks! I'll wait for a day and if there are no other objections, I
will post a fixed version.

