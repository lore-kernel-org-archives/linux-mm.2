Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D50B9CD98C7
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 02:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2799B6B0005; Thu, 11 Jun 2026 22:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22A8B6B0088; Thu, 11 Jun 2026 22:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1199A6B008C; Thu, 11 Jun 2026 22:00:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 036AE6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 22:00:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BE7612042F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:00:58 +0000 (UTC)
X-FDA: 84869607396.29.C3A8D0B
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9B00F12000A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:00:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D+LbsuFy;
	spf=pass (imf29.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781229656;
	b=7eEHyi4ZtmG+xX5m3Sgh9w6bBTfB2NvIwu7ix/7aJuTS22tgZmYzRxwyeZId7ugnm2PCwT
	aTsMAwW/Wrk2GbFMqlGBRGDsJzSVEkEK3B3O+3o5KRWBsXTcGLCIkWTQyf5vDj8+J7VFCB
	pk3A9QzaPyqFrTXpghFAOzVcZDEuk60=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D+LbsuFy;
	spf=pass (imf29.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781229656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=49dakZ/sUlpfjJixZWoB9+lqTB48qur6TP/qBiR1Cfg=;
	b=x+AjI4+LPfRXRn/e+5fYjJ7AGWMo4Vj3l9yVsoAdLNCuL+GOoOciNbRGuN91AOFLbsEnDz
	G+u85Xi5qk2YZrXX1hZInQ43c34WqOdP7F4QqyYDGOR012XHgujRts6N3lbCSFBbr9wXCf
	zg5q6CyUqSO6rOoFQrBcZpnVZAqhqFA=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7defee656dcso3790347b3.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 19:00:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781229655; cv=none;
        d=google.com; s=arc-20240605;
        b=Tjc2TR0SBZeHsn9pyJY3uuoPxxvIZcdh8o+/fPGscL9coD+2EblLLCasxJa1O3P6q6
         o/YoSrrK5qBLBapqlaKB1+qSgoLNdoc4oTv2c+z2eaq+sC7wimgJR2wN821KwULYgBHm
         t877JPqOJCpY1PzhNLP6UVevX+hz1oB3JyLcrrAmwaVCBqGUlb9/m9nMlTrgXBaRYCbF
         IL19IE1H8/KIswX9vGntaq9s78ANxWmmbv4q+61EwI3DNue8SjT7lmX8q+HI7LZ8vwWp
         EC5+xoR+pv61Nz95yn1J5uOre7QCD0kiszV9YjiTd2H1ZeT8A/o+9Ygc73Vl6eJSeKGr
         YVPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=49dakZ/sUlpfjJixZWoB9+lqTB48qur6TP/qBiR1Cfg=;
        fh=FI1nKi+O3vLp7/LG1l7JRMlgdu4O7iDQQwuH6xMj3HQ=;
        b=FLvqbmGok4TkjDcS/it3hMs9n+D+JnkchFDLKOKyABQYdK0rFGFxLWuHuVK8icmOmP
         T/IVUZPDr+k9/Yin4hscYDYpMyqYoCIC6CagZKou1l31y//ebd/mFA44u2ju8MHhox/j
         w3BkoZv0VbkdE1t6+hEEyGw2sHi3EDt+rxFo2FjelNPTPfz1tPOrCh6xKETvlNfUVLeb
         ceU1JFe2jQgQD21vnWAujWQYO7NQd5N4d+m4cilH+qqEeiOyVoFKuKg8ndqhvf0bLW8o
         nzLpqCy8rCMYF0AWqSvO+Qq4nGL2M95GxBqPzY6XYlgN6jAURq+5fBiz9Kb+wNI1DAtQ
         h78A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781229655; x=1781834455; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=49dakZ/sUlpfjJixZWoB9+lqTB48qur6TP/qBiR1Cfg=;
        b=D+LbsuFygXbNTO+1QljqZrANK41xwjvYyhGf1MD1QFaL8z+qYiHpi/n39Xx9d378k9
         I/mXOWjRQJX1sP61Im/UpeLdUScNqWKdAKOuQMZ68Tjg7BifaktHm2WKHmfi2LotqBJN
         eyAPvi4RlILPpCdMCs9g8yyGxwEhhYzkUaMEZ1KLy4tl/gf6k8q3Pvhdd2Mm8qL6Iwik
         tC92TgjctHp30XWhZ/O1srhzYo9MGZTqUsbc+dlB+vw2fI2U2K6vyAQxrkI71qGxbJoB
         TlN1yYJ3bD5a1+M88Sc2ker0y3KOm8nQYftTuzLx1wiMcdeWT+JbhH2vAmp6EeRKCJ0G
         nOmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781229655; x=1781834455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=49dakZ/sUlpfjJixZWoB9+lqTB48qur6TP/qBiR1Cfg=;
        b=R1xQrUCDDBxOdXAfkAo40KSOtOX/NHkbZUifkJEbc4GRxKzzWFB9CqGdC9APs3JVGr
         8xqxOCmcMOXU9JfnM3IZxpE4DQUhi/QYJYPWsxiVE/dU6qE7OTVYU/JsP9kxVa5TRdYK
         04XkPZW4YTd0+ZaYQWbEKYQR/Ib23YT7KM0fVerDF8DHGbcUma4dwaXlhT65g3EZHJP5
         B9a7usC83DVoBvRTlZmp4MKu2MzL2pTASPlB8h5A1176vxwzDDTatv6bweprYJabxYaG
         4dsIAbXcwLSJmeKmctlRynnfX5Cu+hfvXYAt308F3GGIl0XER0I10Je3f7l+8ynO41MY
         6jZA==
X-Forwarded-Encrypted: i=1; AFNElJ9Y85gEzdPG/pFBu1z8IJRYniWs29CF7FbnisD/9SJm6OQlVpOGLJCAOQehaKQkIdWPpJmE9LDSoA==@kvack.org
X-Gm-Message-State: AOJu0Yzoh5wGX6eD5UYxkMxKPlDlq6JDeAFHC6LAhmZ4gG+cSqu04FC7
	J4x9wDzoATlcd0Jhe0P8lHMBV18jX/JFLoI0Xdaevv0SgQrXo8Dh4SqknPr7WLdabnBy4jRZ1tv
	jFmZUvk16WX63uHvZpMDDI29Fj5c99KQ=
X-Gm-Gg: Acq92OFUbsiSHapcR5/+xzI9rEM8nOFFAcueXSqPYGGIVllx3z/wmpqmITgs0Ug2WN0
	B4MMSeXpyLgcyErRCdgjRjAelZkUBPD3xXkjb59VHY2HzzC3WmXNfvzKO9S+5YbOPJ8JFm+wmq5
	4p5LsWskb9veGWFjg00JQVce2HpALKrxYG/tZF/unChGCEVf+0wPzKy8hpi7hKkCLhb+/rs2lL4
	nkPAqsbheuB+vuIRG7fE5IcTTHdb2N4DkUPMftLtNKlCkNvu8bzrec2ohx603ukWjDxJorML5cl
	cqrhRW6ogcuFolaOsKg=
X-Received: by 2002:a05:690c:e3d3:b0:7dd:6034:b465 with SMTP id
 00721157ae682-7f7b5c55031mr8423667b3.8.1781229655584; Thu, 11 Jun 2026
 19:00:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260609113520.3507783-1-haowenchao22@gmail.com>
 <20260609113520.3507783-2-haowenchao22@gmail.com> <CAKEwX=NoNXqk6koBYMSjaQaiMfq-dRaBxuFpYdrZyByxs1g0xw@mail.gmail.com>
 <CAOptpSOHcbOrukxx_u73jhNyHcFNAg+BYKNqWxDcHqTM+k55_g@mail.gmail.com>
 <CAGsJ_4w+3RYwGqmNvrF9ragiFNW+_mHfooQ5pOwGDLTzLUNomQ@mail.gmail.com>
 <CAOptpSPseFH14dyyVQrvfLxqjSXFUyhoVg3GXsQh=7qktJ85Nw@mail.gmail.com> <CAKEwX=MjWMTV3KLUDtfmGDM7LiRXNO5au85==SwFqpSBAQ6Wzg@mail.gmail.com>
In-Reply-To: <CAKEwX=MjWMTV3KLUDtfmGDM7LiRXNO5au85==SwFqpSBAQ6Wzg@mail.gmail.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Fri, 12 Jun 2026 10:00:44 +0800
X-Gm-Features: AVVi8CdgpzAaBDYJRAST7SixLJg9RPkuoLQtYKxFQ_LxM7JE7ehV59Z7Hu9VDjU
Message-ID: <CAOptpSOHNA-wSqfCsB2-RhM6AzJpn4bzDf4dXPcQrSO9g1tx6Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm/zsmalloc: encode class index in obj value for
 lockless class lookup
To: Nhat Pham <nphamcs@gmail.com>
Cc: Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9B00F12000A
X-Stat-Signature: s7b9epkiwt55d91br75t8chq795bhpwt
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781229656-358404
X-HE-Meta: U2FsdGVkX1+C6lSnS7h05NWWAmvnwfZPBAJjjrLR3d4VUgt7ErfiP4GO8vWUNIHn/QdIuynCv/dVdaCJV7XkW/5ZgYg0nrSnbI8i1QBK8vqzKn5KjccsDmUmnmcbuC1/MlXiqATf49BIpRwWo59G5jzusi/AuJLp3rW8vm2QEr3e4zCqgzr/gUYuA7bQTSmiwLda3VSbtxF8gOwtLT0uRV2eBqMpS88/GNBBtkuonUSXoZp1qbCqBpgLMPkLsqYTfa0ANM933zolSYbk03G7aYBIJ4UKlpxmB/g8pSGoeg6TvFaOcTwKRLELTRvrYizc2xBauTn+hxdbkOA8b3a/21xIj+xozN76IJnUUDj3cx+NRg8/WkvFwtVmHTEON33rBBVkfqcb8EYCtRmlLDoVt8utOXI9s8QKSoRgaXMGsZKBCN7VYuCoGSgwC0Mtil35p9j/TNmACEJM60leiPdSm8jbh+eY/t7UcsuK0P9WBHIXZwki59aOjMQIdujiHxg9SaR870Vkj/5itPJnp7LuGknEyOCgchvY46beiO76KyhPDkc816/02AoD+srgSHsjNvRocI/ZbY7cHnd6zdX42wo4vfiovPDCE5OshB1H/kSxAGKgOJaAX7moUQRpJlh2Xa2SnOQWeEqZBIORK9MSIhIeeii4ydMNyqyfYjbG6xn0CdugZhjXL/P6ySJ/6uC3bt8SXk6uDN7Z+iR4O1biln5KNC9BmkMsFYZ0AcmahB4TWg4F/UFDjdNrUwslom7XYVC/LieuTKfOd+X0J08LZuwUky2OhQwLogmIXKtoraFGnr0tNhZNsLNi0vlQYDprJej4a/TucF9paebxN9w1k963ouNqifu0RLVOzo1FIFkgDSc03Z67VpQ2GKxnEnqGVk4UR1SDf2+WpuMCWXeEQQydgQh10eE5MO22obZgNNNaOSaWL441rsAM4SXoZqGGKvCUALqUWp7f4BbJlGI
 eSn3ll70
 V3GLZV2NDLbxDX61Aln3xY9s09R0qYM7ghQPsS4DOhcznAJFm/eo77qdZOWpCqeqP7i3U54JE6jL91TDb0su15lLitN0l0xsGfHc8J0IU7Fsr6rJmTfAvLyLPt6AmQZOvLOIuvHoWNSTQWS9dWkAe2mhuPiz49SBSSdYSwOLS/T/uCgmPCJ/u4Op0MY0Qh7HJr+o9sS+KmpSPojqZPR5Pg5uiG9i4mx2K49LN0MueoIUVT0cJEexUPyptXNBLXkGF4HAVAsJIsASOMx+C/OpkywpkcTkBWBUelIYtuDDETyXmVXtCxj5h0Xjoo0QLAsDsH1hG3yR6jsYp4kTrAbMnFX9KmE8jwF0X+/E/erklU+lHV0vSulLy+xuIMBjYgRnjpfcOUhD+YZKTGGJk9Exm0oXmjx7GaEJCXnzbxIH9jQ5bRdqBdSgsToHRtI2S8dS6A957FvMj7cv3E3uKwkznPiwebostTyWakDGgy6pKUCl1J6ixoCWe7DfgRQiiAr5y0VJddp4eyW73y1M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 10:31=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Wed, Jun 10, 2026 at 8:15=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.c=
om> wrote:
> >
> > On Thu, Jun 11, 2026 at 5:28=E2=80=AFAM Barry Song <baohua@kernel.org> =
wrote:
> >
> > Agreed, will follow the convention and drop MAX_:
> >
> >   ZS_CHAIN_LOG2            -> ZS_PAGES_PER_ZSPAGE_BITS
> >   ZS_MAX_OBJ_PER_PAGE_LOG2 -> ZS_OBJS_PER_PAGE_BITS
> >   ZS_OBJ_IDX_DENSE_BITS    -> ZS_OBJS_PER_ZSPAGE_BITS
> >
> > Nhat -- sorry for the churn; this supersedes the names I proposed
> > earlier.  Let me know if the new naming still reads well to you.
>
> No worries at all. I like this a lot :)

Thanks!  Since the rest of 1/4 is unchanged from v4 apart from the
rename, would you be open to re-applying your Reviewed-by on the
next spin?

Wenchao

