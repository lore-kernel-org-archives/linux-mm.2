Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98FBD1125876
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 20:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0900B6B00A6; Wed, 11 Mar 2026 16:01:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07BBF6B00A9; Wed, 11 Mar 2026 16:01:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E96056B00AA; Wed, 11 Mar 2026 16:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D5D466B00A6
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:01:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 78AC61A03E2
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:01:23 +0000 (UTC)
X-FDA: 84534851646.15.3412C56
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5515D4000F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:01:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gEfPovHK;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773259281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=97x0/kdeo26XEJld9k7PqXpKblhUmnum8QVliCqa/RY=;
	b=6twtBedy0neJOJCN0dZLEmxpKk6Q2cS+p51e0bsGU6Gw9XkCFqT0x0NTN9Oo/ym4RnHN+I
	YmgMAsIutwYjBmvJd74AJXp88pKbirCGz0plClxRkQ76sJTUja0akOD1NwXaFxAhFfAQbh
	QRYperxj7YOsIgfQaWyp5OTh4ogFijg=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gEfPovHK;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773259281; a=rsa-sha256;
	cv=pass;
	b=PGVP3caWS2pYl1Q5Fpmqt4CUweriyf7LxS694ZhtPxfoBZFAoyquuot+GkWFtcMHlIs0Ft
	5UhrWNfiCju25i1RTSJXeMOy/+rJ7HZqSIgInMRGhCnyW+ilUOYUCDWTIReT03bmkPn/GR
	3gNwaz3jX28az/1nC+ugj/1xx51jBv8=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-439d8df7620so203820f8f.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:01:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773259280; cv=none;
        d=google.com; s=arc-20240605;
        b=JLQE9oCSVUiq7+eXMlkS8Lyr42UExt88FeVyw4WjUDqTDFgY38vZftsnBdyhKViYKQ
         KfSY22fi08egzNpj/uzeUf4zC0JV6UHLbPVMVnfIg5SEd5cXdYyj0yvSFdOeaDTdFGw2
         qlHVTLBOL/wXhJsdDB+PzPrZi+bFhK2XanoFdzC8hpT68/pOdC5wL9uAHP5W1fVpTLPI
         rE6aOFETT1hM5GfBMubP32wAPGcCAJIHpgbZRsCLiGmQAUlRpShw4dPckn+JzsySqXE4
         wpJjuv/Wdho8IrKwM1QUo6gBXGfv4lyOQV1pazHD7Hog9Y7zk/gP1Hmm+bphEMt/Y7fD
         BxGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=97x0/kdeo26XEJld9k7PqXpKblhUmnum8QVliCqa/RY=;
        fh=QkT8vl9p8eF+SnN6bMs3j9DM+s0Fn2mL8t7qqbqlN3U=;
        b=VQs7Nd8kl5b7O5f5gDUAHRzuhMIlkB2npQgcHUF3VI2pM+AwBR6u3wxgSHEqqeEaDd
         CfCz4HkFEaROcbh3T1jQzwfxJakphSuikIrfbPWhS1M1lWI9L34Xjx93YV7umJKoCFDK
         wxtvi93C3/2wlpugbsWjFv9vhM7PqRGIYvzYI/qFrzmBQt1pekXGiI+DRKEdfJiPb0L0
         YYJvQZ+FkUU20/rKgJXZobN0B9LK8IXEpt8LirBL0A3/cyXlQM/2pNKuoLiVY2Cs8IAO
         t4efP0rbhFe12Du3xDvVcDjjm4QcgrD9+r0F7ynr5PI7+XveXlTYLhn2VxekUZOnkZIg
         pX1w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773259280; x=1773864080; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=97x0/kdeo26XEJld9k7PqXpKblhUmnum8QVliCqa/RY=;
        b=gEfPovHKzLJG9ul+GWNQGJWaU14zrxZo/N8MsRtbue9M6ulJw4ceJhCES0p38vUkTN
         b0z4bqVCeWisq8NjaRbGy94kg9hnk+k3Q7aHBh3TyhNrFqV0viodEmH+SjSrNlodUkAl
         yBvfydQTAtAymm4c+Zf57e6DtFZUK3cNJk2uxpqgUVMRJf1Xaq6QF8YTF/65Dx8B75cb
         oSt15z63ZBl2hyW0+aaMf2HMyNXYE6SQaqIwgy50LFsSeGSmxezADX4YDNCt5toB2EY7
         BWhEkGRYpDiz7zsAJkbwbjk1uMRIzez2B3BuHZtbF8aWCPKtEHBJzDV0IgQmKsLsax1y
         l1uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773259280; x=1773864080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=97x0/kdeo26XEJld9k7PqXpKblhUmnum8QVliCqa/RY=;
        b=XDR6NzYkuaUATQAOGZ502WZ3jQSqWs9yCUvNX/twFSJGB+tHwiJ/CrFC7bylPyQNp3
         n9o+f6E1ij5rDoeKlgBGGAM+w7ApKAZFyuszxyHJs8bPxUMCXsEvOrVUEJfibO+Jc76Y
         2zvicNkB5/ou3WliN7LMuI9ohntnR/z0OKoTYB5KUjiYPBGwdaodrUQT3N++e293ApDz
         kUqkR4Z/FlX1VV22nvm17C0tIoJZJDZ48fiYiCPXtZ0N7bGEq+gGMC5nfP4QTAupZcEK
         QJLAlbNUinBpKepWuzFsOclrlmp2tQIx5sk9Wyb4QCFp4CQ3huFbVni/IrGdEQp/kwPG
         o2xw==
X-Forwarded-Encrypted: i=1; AJvYcCVPkkk/oWd16fKGSznkz6+7e1WkAVyU9p5QHXW76paVnuMX1OVjo8QBoSLQlgWSyTFQxOgxIvF9pQ==@kvack.org
X-Gm-Message-State: AOJu0YxS8X4YY+aRBk1uDwYCIH4yhnpC4yfbiK8QdCBg3eka6JyImL9r
	WpQPCX+HltgMX1pBaZSlqSsaPpf6JQEUAwHn34D3SwVXp7nSYenpOZgbBjU8m4O/HMLwqJdIpVU
	iptFqlftXDTvVKOE1s0Pj+fFmiFoNo3U=
X-Gm-Gg: ATEYQzxR7ZjWaHopS1IkGY/FvJ1bHcVknHMHVjwKmi41RbZSBBKogmnTUYlVwVmtOfO
	b4qFXeRq3nfSC3kQHWuavyzOn6k6zle2zrnzS+C8Th8q5S8xbi0SaDB8ByeL3hlNNzjpSWbcLDE
	MppJZ3CFpeBeWQ+YMjIyJXbTmnO90Z8Zy0tqp/BOZYscbpq8IbZcSW/yPn7Mw/pABYQDgk+FwQh
	mmD5MczLLZUl2XyOmLJkE5VvDHtwPqrzf1prQEx6CCX6/Bp4DWoYQsm4rbAbm1BC/I/0/RYiutc
	MQLhA6L8OasTpZzJn8Uzoskd/ewX2plWpQDCc8o=
X-Received: by 2002:a5d:64c4:0:b0:439:ac98:751a with SMTP id
 ffacd0b85a97d-439f8222f77mr7535673f8f.34.1773259279513; Wed, 11 Mar 2026
 13:01:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com> <20260311195153.4013476-3-joshua.hahnjy@gmail.com>
In-Reply-To: <20260311195153.4013476-3-joshua.hahnjy@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 11 Mar 2026 13:01:07 -0700
X-Gm-Features: AaiRm52XCmOK7VXrDToh9xbY376FpXNE9oI1PQps6TxR7-1cfIbnzEiFo55XvyM
Message-ID: <CAKEwX=O=uc+8=sP4YxBarD2np=RCxQgJepBAp-W0OSM1TkSb=w@mail.gmail.com>
Subject: Re: [PATCH 02/11] mm/zsmalloc: Make all obj_idx unsigned ints
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Nhat Pham <hoangnhat.pham@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5515D4000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 7ai3p5kx8gmhwt3cp6bgbeuhf7nx3e64
X-Rspam-User: 
X-HE-Tag: 1773259280-281772
X-HE-Meta: U2FsdGVkX19zs9P5cV6S8UdgMqgU4Imhot3cNQSUIJ38D50VbwVgcewTRNTMTgV5/ac9/v4RUtl0uMibXSu84xZcj6NehlLP9DHgNM+JpGBOGWkn0zhji6rMiMNaBOSamNiAS58iO0/YAJrEqLMu4Ir/+q6YMgRsFKD829gd9WKDwBc02j5DNrxniEH/P1Efb08L+bCMd9I/emJcTHXeC3/ZkxqMPmpoRrHgO87tZjYJs6ZRoOkTUYB/kxJzTwBHmP2UMIPoLMdJQq/vgyrV3WScWHzpxMwQinSEqF0gquU726ReCvwH1I5OI4Bhd/X3Vy8gFu6/Efp4AKjr/YE+W0QI+5mqg1xL05CBxnZvl64Tta4awaktBaI99h/6PSHm1yttkQYqZcqwyA2eUYAV1+vRbc60yM4LqSR6mEMOkyR3qSwrril8salhtU4/NtRPJq7+L7sSRByh+M8sGzkOWGCdsPV74Rmkkj63kXreOsTMG6vgPxKKC8aH2o7olucXDbQvke49yi514HnUuUOvqPl9mQxf5eyHh3xE9mQwgXmb7/50MpYEw/wdTV8GuxT50I2ogtuxSmMuaNNQt47jOT8tcdrCRkbNAOOTLgVeMVSW/xstBCh7Xqpb9eZtW3Q7zsvjzJ6atMN9EEYfT4PJnJNVrnu2QDqeceWNKS1U0tlHfTJdkPHiwp9Ip0EKTFFLHgOplFYQp8ZDCAArzEV6AZKF9fXozuWu2Oec7+CBYrJCExNt+jxXvhemfDxOhlsw9AbfoErA1Cznd1I1R6eeeDkFsodmPPchjKXyR8atqPggzyuv+4p+kXLctaNuQGa+36boeo9WG1fhE3hMmUq0S45Mpy+UtvhzMmS73F4J5jsVpS97eF4+V2g1yvoqx5XSysx84tt3vW2TuuE1cI9qKrnt5MkpFc7cqiyzlkcluaieGrxeMAMUFurgZRrEaev3vHRB8in3zOSP1TMDxuW
 XAutU9/H
 zH/oA36HzbvWqRLiyz3Qx4oeR+Qe1Rkft2G38dcab/wTxCssVhZMJt6VGHAJaUfahE3NFmN6FyYOR4no67vtdEaINKzB55z+AWzr/iS4sl+Cylpt56DEyiD31fWsSIgA/ZvJbFK4ap2RSdhDPmcDwuAhks2ZL/lf/9rZ5Vw2N8Sk30AsDWAQTfnlHditRxf5a0i0KbN8TZzmqv2XEOFWMA2etQIMi0aCELjgzj1OZqiRoFr1GtulK+hESznkWdkJv1DOLc9xmnfm6DEJJ+JBqv/Wxpr8pILTyRz2m05QfJD8v0VSTMOlIGVgJBtNn1QN4lG/x5+nSkNGYv8uC/jm0h5SnNWB9ecvwhY1/YIL1Xv1v45fkX4evJQEJ3T9fnjLDiF47h/ZmKpujQaw4reAkjwsGS6PabK20MVL6JMGxJ33sPjxYA2IWI5iHdVWbs0dtzJGZGAlTa+kU1Kp+dje3yj06ijFyyKjtwJ8ePIPdWT0ZZVnXFpPl6cmIfJ47nOJcuFWE9KdtWHUyGo9RnhckHbV4hguhNxB52tYh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 12:51=E2=80=AFPM Joshua Hahn <joshua.hahnjy@gmail.c=
om> wrote:
>
> object indices, which describe the location of an object in a zspage,
> cannot be negative. To reflect this most helpers calculate and return
> these values as unsigned ints.
>
> Convert find_alloced_obj, the only function that calculates obj_idx as
> a signed int, to use an unsigned int as well.
>
> No functional change intended.
>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

