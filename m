Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A78D3103A9A1
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 02:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E00386B0092; Tue, 24 Mar 2026 22:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDC6D6B0093; Tue, 24 Mar 2026 22:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CED9B6B0095; Tue, 24 Mar 2026 22:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD2DF6B0092
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 22:49:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 42CAB13B6FD
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:49:55 +0000 (UTC)
X-FDA: 84583055550.27.FBD69F1
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3465A180006
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:49:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=g2AF4qHF;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774406993; a=rsa-sha256;
	cv=pass;
	b=8hTK+XUHA0oFDY/Hr/De9HO9AjhhOJrgM60BpzohtviWeUWd73yJyYgNCjwCxlzKDIMPoz
	rRxXVy3UqKpMKUBmGu2AGdZPWwqf5h37u8N7EEhVSkhU+ugS7GAp9cp1JYXzDn4+M3Bq18
	o9b6cLIFAex7sr/vOM/tfiWmsgnGMQM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774406993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPBVA7DytOKZolOQDdATvF4ncnsezwN+Y1tNL9TRSSM=;
	b=gz90Ws3u//LZvAvqW1PJzJt+i7j5qkXzUBJjUE68QrxumiuDg2UFSPjIClwJP6//5VpyyE
	875Zr2UepbNKWuxLIRVaLA8nldwW9PsgApGR0VEN0fLu7FFtAIWr/fvth+5rd02ej5t5hz
	bDjkiSFDI3DVkDgGkiuEJ/xobXHSPi0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=g2AF4qHF;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6686697f578so3209109a12.0
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:49:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774406991; cv=none;
        d=google.com; s=arc-20240605;
        b=V+bpG2OsytKouTMO7Sj1HNph7GGcnLA4UmhSqN4SPYX8CSAkFaMbQVk1fgY6xVWiWY
         /cCIErau+KNAIwyEryoljV1pII9j18faZ9NNoQ9KIv402rwSxuEejXuyr0pX9xkRfKYc
         JgUj3AIk/MHzRMe/jeukmnuaIku7QAFmkH2vgVFX0kHUWUwghvDZKTo1qEqIDP85QS5M
         K1Dln84P4Q7QR16evwOXlzHiOjzUqUCs5uNWj5afm9pip8LonEktqs7z7cFQl+YQis+7
         HDla4p7LY8d1ZhNBpqYP2NvBfOTLfa0AOqr6vrVPX7X9qNUhlFzl28vcv1ya+K0ESedO
         qL7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KPBVA7DytOKZolOQDdATvF4ncnsezwN+Y1tNL9TRSSM=;
        fh=dZULZjeusKkXGvdNAMUhzmY1cXX+kXiSIuD/SOB/Xs4=;
        b=FxzQW52K3DkfNdrLksjB11VU3Dbvs5avexzRzJ9cR4nld1F/EDsV613MJW4Epn9B9G
         fMn4RmcuUuwxf9lBMz5RdLEwa62XhnpkxI7qATYbJ162RvT2WFEXZhBagvAyfb5gNtLf
         t84w61Th2xId1w88A+PRNcX6ntq4nOKSGwp4hTKl3RCyziLvPNlNB7GBDbj7D1TNJvXD
         n96PE1ldtkl77tl5C+DYiCTkcYPr8K/XDgDaPaqTHw5hjq5BHwgWEEUJG8xcqd6rSbB4
         e4mKYCCzSeCtNFvdcg9p+vFBT/1lkpw2p/zlhtSEERYKgfB9GHNtZ1M94RqHVAWcsPPJ
         E4DQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774406991; x=1775011791; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KPBVA7DytOKZolOQDdATvF4ncnsezwN+Y1tNL9TRSSM=;
        b=g2AF4qHFPk85ebBecgOuXMOU5tZUPpjpFZA6TQZ0+u0UZSkfv5mwgm+4bapEP8zzX1
         vvAenlqK3YwFVpERKwlCV5YHs7pRI8NZsAnWs0EQGytOoyj9M9RyKQLhUODeJQvaE7/k
         PPe+EBTThTiwUW8j6He4/2Le8VwZWNFN38JGLJ8i28hdUfNOh5J8X/yHT9fYD7irtE6+
         mGU/NXTYIQy1YfbryPFhOsyCZ+6xG9tO5/F0O+XLn/MJqxa42rbaSpHf/k7Od0irfG0P
         ZYLgbKO70Iy9K75g8PN4Toe0tLKu7fQrkLS2rvv0YZ6I+svqxE3D4Lie7EvVKoosnkmJ
         IKFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774406991; x=1775011791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KPBVA7DytOKZolOQDdATvF4ncnsezwN+Y1tNL9TRSSM=;
        b=NJubY/+FJmQfRRcClQ83C/eHNhYzz1FohwCOVn3xMUvIfyUD75SMTmzxyA9VWFnHeA
         SyQcMztzPJRiuko0JdF+JCWXjnNV0Clk5eK6nLmJFlJn98xB7Hd3E9aSQB0VLNp8Gg0x
         Wy9AXGrX+fhI/Ze8aH9ncLmux3yUR4sdo242UkF0I30Q8Ulxtw9VNsPCkuZGbrywWMBL
         Em11FBWrOozxAghIc+chhPBT/pwR+D9XPK9soQff2MWQ2utJygfw3ViHgzGK5OJpF5sI
         I4KFziFr1/7JzR6WA+bMh2PauPp5Pus9rcq+tafGn989qQdTkKLqUeH3l4LSgMgFD7Fw
         c5nA==
X-Forwarded-Encrypted: i=1; AJvYcCUADG+QqnwZNx+Ne6SKsDDYOd69eqaKNiyGPGMjs6n5sY9SIuctkG/NDukJUNZcT/9sgNirKQq4sA==@kvack.org
X-Gm-Message-State: AOJu0Yw4iRF+h28OxzjeQRgXsm047SOolapvIDmLdJ5PCaKzf54Bwpk4
	QkFXHHQAmjPjgz8YTiFWB3sqMTuU6NzCOHmCGJ7k38DmS8uOPnRNceK9NY1o5IYOeEWTCxiV0kr
	gyXkB2y3cRRtRWN2Mi8Sq/vC5Kd6rk+Ty3Zk7utI5HQ==
X-Gm-Gg: ATEYQzxNL4AxQkpiWFy4sB71bZDfqAhpu1N7VuuBkrVvigSHMoqtqkTSqKB0QenQoVm
	fTzaLdwMsEcSnfQelLMf4L8flXmJjQedD00KP0m/4n+jp6XPWY751IL/bpr4+TlOOEzOiCUxsen
	vg5UXJJltb7loQuh5C1amgX0BUolY3P5fqPEBP1H7uLqkRC2pdjpJjQSNYB5j8AMyuXuENrlHZE
	FuGHYxnmRW/ZL1/gyWI3UrCpLZduMDVjXansjZY/6qZ7JMHfBT9UYDd9vyo5p4cFsOJ2r4ICYny
	7xPZY5l3rEwWyha3jsX7aPrg+OkXoYOfzJsWyg==
X-Received: by 2002:a05:6402:4582:b0:66a:3948:d038 with SMTP id
 4fb4d7f45d1cf-66a826e4411mr904611a12.19.1774406991473; Tue, 24 Mar 2026
 19:49:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
 <20260318141637.1870220-13-pasha.tatashin@soleen.com> <CALzav=fhwP1Wv9YjFTXoinX7R3rX-P0igvLbftBh+sZrL3dySg@mail.gmail.com>
In-Reply-To: <CALzav=fhwP1Wv9YjFTXoinX7R3rX-P0igvLbftBh+sZrL3dySg@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 24 Mar 2026 22:49:14 -0400
X-Gm-Features: AQROBzC0DwhMMWi0EsUVCJug7-pyk_Y26naXj4MKTWNsdNop8tv0j-A6EbSiOVU
Message-ID: <CA+CK2bCU=4XQQJ_-3HrhbENBNWoDf=ZzHpp66nZaPxGUAU=U9g@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] liveupdate: Remove file handler module refcounting
To: David Matlack <dmatlack@google.com>
Cc: rppt@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pratyush@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3465A180006
X-Stat-Signature: o3wn11kajwsczj5x5f7bb8fzt1wru8a3
X-HE-Tag: 1774406992-80015
X-HE-Meta: U2FsdGVkX1+FPBL2nRAu206ClUZGXI5nXZwl2y6sdFqVjVaTuy6TDCHbU8FsLLRznV1kNre6OIB/BhXquPk3ftKwDMxqP32ck2nJIiKdfO93rgLyaYCdz9VM4PZRvAj7jwNYLrugUA1LvkfP1bTuOHnznf9YXh3dH88I7JNr3UQbhtch4BI29gEPADhGaO4gdjjHBEuhp35NytrVlvwRVl4RDgn14TE3Z3e1oAAYYDqfHtdmUIeOsAlgUrW0drb9F5eqPXGg308vwKZybXmv7LlDIulVV4KQjojlUy0Kkq5Ug879WMN5UmcowIj6qy1OmBsvDgUxsnjTv7DaDjojWTsST5rJmhAb5FVLsDqj0xqiC2T0yl1g8BeVybpfPaJ/rWSR9fVB01Q+yPNL2ZPslyQABk0vz4jsdj+b9K+E+w50IWOVXRti/dowSngnJYEVrUyvcMCy55aJsxJKZS3qoU7bffOsWCHAkTKqzmkG8lsYgKOFoA3sPVmm3/EmffbimJNS5S3JH8baWJOVwzhzGsdMjNkqnEXrgvIf9Tk67CXzwSkoKkQWWb4TFdUMF7R7OYmDvhmY8MlJvgrqkQtSobGEMvo95pEqu6b6ZERryUThRm0xXRIwTn+4eDw1oiBD2+Ziy36RTjqkyFFmGbr5x6AnnIZ7ZFi/U69gYksOw9k//a1V2hPzPLzudUd2/ArC8W7GND3W/WTSrfSpTU88deFmQScAZjFYsUz9i0FmjJmUCUm4XJLFCO3ZpH+O0Ofq/M23jXIeJC/rAIC5O6RZ3zSYo2tZxR3PsLfEPJFpArfr+1+kYF3u7tiTXM6D8idPiIbyrhfyRLiPHk0FxXqvVHvJd3GmBSON26lztufhIvNuf+l2EiVq+IrLo178iEI5ESLiYDxfBGslhtTYpxM0jpDl9MIeOxeeSpQHV/pmwv44FkVHa0tFLpKeVcgeB1/dILPWxXLdBbb/NQxd3pB
 uKXt41Pi
 ND8gRoUiYSOo+Ifn/aDrTm+F5vd6v2F8aYG+u5HRmelt/iiKhxtisI8NInQfcAJfFQHBlvJVBNwjidHr2gF4qonKI/9I0FXQ7EaCW8t6wLHjFIckF8kGyX7roLyR1ndrFl1Iga+5WipngvbPnOyxhex4ReXOS2TVVTi6AgLnUcjpVEazuMa901zpD1hFhNWqKdGlaw7+WOEzb1pGpv68RtQ09qziH22n6NFT8V24SmQSSY7Vpl07r0GLL4th3fRC8AhhP3I6TufQFlNgSDsQVcSFFwY7Efa36jf7m/mplSQN7kHZQ7VaINc8SAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 5:24=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Wed, Mar 18, 2026 at 7:17=E2=80=AFAM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> >
> > File handlers do not need to pin modules indefinitely or during active
> > live update sessions. The VFS 'struct file' pins the file handler's mod=
ule
> > via f_op->owner during active sessions, making dynamic reference counti=
ng
> > unnecessary for handlers.
> >
> > When a file is preserved, the live update core obtains a 'struct file'
> > via fdget(). As long as the file is kept open within the live update
> > session, the module is pinned by the VFS and cannot be unloaded.
>
> After invoking the file handler's retrieve(), LUO should probably
> check that the created file's owner matches the file handler's owner,
> since this scheme relies on that being true.
>
> If there is a mismatch, LUO can put the file that was just created,
> log a warning, and return an error up to the user.

Is there a reason why taking a file handler module reference is
problematic for vfio or iommu? Could we take it while files are
present in incoming or outgoing sessions? Overall, it is because it
cover corener cases such as if the file struct owner is the same as
LUO file handler and also this approach covers the deserialziation
side nicely.

Pasha

