Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B540FD73EB4
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 02:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7416B0005; Thu, 29 Jan 2026 21:32:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA5646B0089; Thu, 29 Jan 2026 21:32:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9868E6B008A; Thu, 29 Jan 2026 21:32:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89DB96B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:32:23 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29807B9ACC
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 02:32:23 +0000 (UTC)
X-FDA: 84387056166.19.C7E32EB
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id 32E7E80002
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 02:32:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YCt1vGvs;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769740341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/aDS+0oYH5HpbjfW6HjWYN5iso/Y5/50MxxdlYKMOM=;
	b=DI5h5OihSeoqQcB/o5O50PLueQy7ls86pO4971EQnwyukJNm8R8RhV38MYfRuzwZITOCuU
	3rPUnBx1NPeaIFZaipDp4CDVHrHthHi0pY4t916bgfEsHIH+/Rw2bLPwaFveArpAsTfrKi
	uz3j2S5xMNtQ5AjOSYyG5cFJHOslrK0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769740341; a=rsa-sha256;
	cv=pass;
	b=6Rv/NN/TUvFNv37w/R57/z8WdSJkfk4cWyqh5qWdBau4ZHxaRMtXU5+dIAZ+IMjUEFm5zG
	uQT9e0DH8+jsoV+ue2wSTwAp6UWZob5Oziy5V7uVZd8ntl/RtUuLnIMdd/NR6ggZVpbbGg
	efMOHNaAgVn7N0dOLS3n8a3zbSsAfNU=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YCt1vGvs;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-432755545fcso1160606f8f.1
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 18:32:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769740339; cv=none;
        d=google.com; s=arc-20240605;
        b=XU0cLTxnrsT3IajyP7r//s1ry97NMmkRQNDheH8Td+BxLbmefGQ88knQe2WVl27U3H
         pc5/EZY/yoIdoyp1FUa7azCjOXjny8PNtPDKN19JJYG8Uec3wVqkTh9/hCLErrrG75bm
         3LvTbutbQYyVC0GjTHH1MM5If7jSgavYdEqyqKf7rdkGWYNKTzlOUxkiDx3jD8/A/Eyi
         I6C3cIe4+HJ/frfNB6Giqtx++eLUSfIWzSkSgg2Ks054GNMhs2V+IPaC+AxmaQ/RkDdG
         ipuT5YW1ytHA6RWR3cLCp4Jil3WAaL/WQ0vSIW/ByM7COF1FzP4qCqjhwOX1TJGpAIXp
         IWGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k/aDS+0oYH5HpbjfW6HjWYN5iso/Y5/50MxxdlYKMOM=;
        fh=sUNBVwW8heyuc1/5IEgmGwuUvenUQ/HOSlQaA2TI6WA=;
        b=Jo9SdeoTD6A0ZHCKydXcvzG0r2XkGDJYbRO2XBzLqma0f1TLLkqqf7B0ZMnzJBD3Jj
         mM8rzFVIuEQpcH1k/fy4YjALqRUv3+QdJ5iQw31jltiPXqHMKabjWj+70kWja/UtqxKC
         csvXo16Te6FKMw75JpoxfecNAxx8bIckW2qOOK8UqPtBJKq3+EeWxunpL7VhrZQaIJxI
         qQYKtd5HLpZg8YEd9U+9GQbXcF+E/jZWkT+vK5Uxt4NPDMZ0pRjbLlX77f84HCfI0qB1
         ymeMSulDDwvqZYL0eQww0woo8nuVlfMkI66cBal2s+xg6juny7AIIJRAadyC8NHsuci+
         MUjA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769740339; x=1770345139; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k/aDS+0oYH5HpbjfW6HjWYN5iso/Y5/50MxxdlYKMOM=;
        b=YCt1vGvsWGnu3NWZhJZ6R7l8ccoxFCaZuOjQiJZ8IAeJgPz48NYWc3DPqoVhTNcW3R
         3nFcfcuPQMv9QUqjzOeBfar7IX4PWZ/ZjWytcwigze3p2BEYTJyb7z01lr/By3Z7ELZ/
         mtrCz4S9OoEO7dF5tVym1NtX6hJ/vZ1WZjkln7PR78gSJSThcHnSvRxHPnRBwp/Ir3I0
         rzwgt5rNkpH6KlF4OWNAyrfn3xZZQJUrasAfgnhB1yvoq4IC3GqWwa1KsuaUBjyhXFk3
         0rNnSbF7W8C4WPjf1bszfNcYQfHEBAvRSSjPxLRCoIEUyqC1OvwBoNlO41qDPbZS98vL
         1CSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769740339; x=1770345139;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k/aDS+0oYH5HpbjfW6HjWYN5iso/Y5/50MxxdlYKMOM=;
        b=iupVNlQJ/DvXpF4yt2E2Zb2tKVsusz+U0c0kT8tV27qCe+L08Z5ubZL8gN9fWaNjWc
         sILbjLaJzct7JTWoeMFdTbTrD/D5cczirivjBTyQoFfgsUAgVufvWIBo44q7J/bnHZUg
         vSlvbD+y236jeChaIE24HqK+RBOZ7lUzp7wEVcWDW5PmugdLa7iMFQ03AXt6qYKHdBIr
         +wYad05rL0dd7e4S/QZ9dx7eeAcWICxvXZDx0IQ4LVLe1yB2i2lIEqCOyKEPYAOHr3fY
         gvimwO8qOfWRfCdi9MZpRKqCZkLl6phyYgXngmenHJs2VVBIf2BHEF5hQ/IU+0PXEPaZ
         WRfg==
X-Forwarded-Encrypted: i=1; AJvYcCXpUYU9tP1exUPK5kaQIVexYKV5YFmcbpDnibhdTtSPhLUHzC0kd1k1yN9VL69+XlCPvd2apcWQDA==@kvack.org
X-Gm-Message-State: AOJu0YwdrMx7MPbwCEHRvFy8ZHv03vmzmirzLbd2bx3c2kfH324YhSoe
	QdgK+i6Hn+sOOGYtQM3q8Tvwt9k5bICe8hJP7W6iSw5YHzfbwUo6Hku0imLQuayGR92uFsHlEXT
	4hpEf/wI6klT5abGrvlUcXLEvqWWI2J0=
X-Gm-Gg: AZuq6aLmgphfiHWTui+iD0YaApe/pHg+poY1dqeoBL4IIaX5JWW8ZRAzGTYB0JwY5KW
	8nJch5RcCQV9tlmoUixbciFgTESe12WCfthpP+tx1Xy9y1YAUSvNsUHhOOVXspgOB3jLEcF0zZt
	YPLGBYLH2/6wVvodBF6k5DvORkS50VI0FxS4CMrpZtGvIFd0muhl2Nd2VQLa7eNWJzcSNererY/
	l00seywpOKvJL0pXYfZawUibHKY639P8KPRkCItSOmUTV4JvWRh3xciRxj5wvX3ZOJdyk2XJu/1
	N+lN91zd8wulHAO4Vi+TIAgN9QsWMQmj5RrSGTHBgrflP83WwC3QwOeg42YFEc49BZB2SjQNZyg
	umFSzPxEdq48kbQ==
X-Received: by 2002:a5d:5f51:0:b0:435:97f6:4f44 with SMTP id
 ffacd0b85a97d-435f3aba452mr2106682f8f.56.1769740339363; Thu, 29 Jan 2026
 18:32:19 -0800 (PST)
MIME-Version: 1.0
References: <20260129035014.3283392-1-hui.zhu@linux.dev>
In-Reply-To: <20260129035014.3283392-1-hui.zhu@linux.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 29 Jan 2026 18:32:08 -0800
X-Gm-Features: AZwV_QjkvCynu0iwUVBI8BI7kYSRcpjxCSWpTLRoHPDF8MFwQngmzpsXdmYVjRo
Message-ID: <CAADnVQKGci3kJW0F40j0tJn6=ma-ACEzcYOcxYE8Vkp_Tif2hA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] mm/bpf_memcontrol: Add missing newline in
 pr_warn message
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 32E7E80002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: zqiym6p933gpphoz3tjyzggjh4ay9e9a
X-HE-Tag: 1769740340-726681
X-HE-Meta: U2FsdGVkX1/QNMpyNBAkyNKDjCp5Eyy56pGgv4QI9SqTMXl7qS3fbvRDWON6AW5vlcro5J+vVeZXn/H6B09JXkqddFSF0KNRxISMGEN5+kM0UuiaXVx5LilPwxgwo4Pi4U5Pjn5te11zQ+zJ24y6zq3EGIpImUrnYxcMKy289QLpSuB9RTBD0q8dYrY1G5o/9C++mDC8KMmnQwMkOj1apw7ETnb5oXuuY56wgRugCphDapiDJY1GoS/ETnbKzBYGI07RngTYHGL8CZOZv9yao3lrCaBkzkzVlxoYvBg6jaTPs7MmfPq9s7qKoszBlIbLeVQZucaUHbxoR4ABpuVwbz0liUSSIU9s8/jtJFpKGYteAA3xsUnZQsFcNFmgnCmr4QjTWg6ak06r9uqiFbn3/LO9+DeNy67gAi9F6BltUfBPIzqCot/NyQFf/Df+p6DZl+bkYqRZvoiL0C3bGtHh20Lickj0XJVK3K4gZxEDCCyn/4vDydhpSf71oeVbhIn/l7uSKGPJgD9mpiez6hz0UwwTGN01lHzAeEsyEKHjquPz8OH2ikm0o9cws/8fQFpMToP+1VUoBQoanQ9/Mn0qGdNN6T5qq5+N1VGwSCeJAjaolI6Kd/pZgnRns/n2cA+SbJWROtUZlT8TSfJVESH7Y8mp1iw2s0uPOtob5EHbbulHn28Oxdi62+NMlSoSwRyJ0cdKOMQA/rXCIhuOLuILBWNb8WiQH21aIpmR4VXb1F4fwCZ54g609AT1OVDKNPVqMiHv9OyiXxtKrJVmznLO2T9nWxYWm9UWHRHV2BBWpTIFGbHB/f+mCTH6VV2hGxwSPYVTcNdnL6EmTvNXXwSJOYghjh5O+UQU7Wyzfd8RcRLCtNoUA6oNv90Rdn52frIRUNcNK6VAJYSEMGYVHEFnPrVwuT6sC3UpWNCjIsNggEc1Wtkd3jC5yEbB7OMkWmeLvG9PNN25GNidrA8P6Hm
 iLOXMh7g
 ozSWuBnnhfFrHMtHR60ITZIaNz+O64H9xRvdIg6JAR9UvKpLFkh2PaiJKiVrNhNJJbpEDSW6EdeqSesFqK2R/OM4XOdt43Km7Iz+wU/fOdHjujKxeIIpkBWR3OWYiatDZamsng1tMXSZn7BjaXHVzTUXypYPOEOGsROihXtrJmWQMhZif2lguMZm3X3ZOdyI32+Xp9Agva6YdRegANUpBX3LaKgdm5pZCTQnhC23y56nyAXcJDlTWbyqacCH1nrWo6o53X5cLEKdv0UjhhYwXUa5dy2QDSt8NFn5jn/V77XTH1SDaVLgpmIsFDwPLWR+UsGPH7bJOLc1iz/Uxth7+5bKVhdSsTLJ0CoZgDOx956zV7FuF+DCnqD6aFIPwevkj6/oGT/WR9GBdfIUGDuwckdaoLcwUtXsn6AqeprWOtd0F13HqIa8wnrXRCFWLmAC8wX7qDy7y/sPqvmp68CBEUpppIs4ZJqbAeg1MOZqwMdj4w5/4fXGmYKecoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 7:53=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> Add missing newline character at the end of pr_warn error message
> in bpf_memcontrol_init() function. Kernel log messages should end
> with a newline character for proper formatting in kernel logs.
>
> This issue was pointed out in
> https://github.com/kernel-patches/bpf/pull/10864#discussion_r2735018210

Just spell it out that it was found by copilot.

pw-bot: cr

