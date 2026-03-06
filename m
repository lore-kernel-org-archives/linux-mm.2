Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED1D9FCB625
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B776B00AB; Fri,  6 Mar 2026 11:50:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E8CA6B00AC; Fri,  6 Mar 2026 11:50:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EAB96B00AD; Fri,  6 Mar 2026 11:50:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1216B00AB
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:50:24 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9AD051B8501
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:50:23 +0000 (UTC)
X-FDA: 84516226326.21.854841B
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8056B40016
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:50:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="BH67xsa/";
	spf=pass (imf11.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772815821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/JdWkEYAoxELgAwR8n3saGF3HFaHOnFaPXfAPoD+V5c=;
	b=516Kjwy9O+dtPcSlEdq6ga+IdKXMLkwuGXygiLTE7ozc2VNvBqRb2aLf7agC7+dm1S9aen
	iuJoztq8ih6QC28GOi7fhpCRfsvTqEqbMFeBkIUhUI/1JsiP/+oT4aworq3PTyrCj642eU
	tsaMk9eGnlt6goynSSq4l9vhtCcrWJk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="BH67xsa/";
	spf=pass (imf11.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772815821; a=rsa-sha256;
	cv=none;
	b=ZxqyorehFIWTWryKjAKya1KNAkTl9JOweb62uPBDRTeBU3jn+mEUUMdp7pId7MV5ziAPnf
	JDxLIqYG8V/PDykGt0EtBhZDJkBmNdkvuZGCOCMr4HIZC4CDKPEN1PnMxKAaNyKtBIaQVX
	+3AvczYd6iPcE4/eHWz3KRFsvdhones=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-660d2e48383so6583887a12.1
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 08:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1772815820; x=1773420620; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/JdWkEYAoxELgAwR8n3saGF3HFaHOnFaPXfAPoD+V5c=;
        b=BH67xsa/yKmSsOkOfF/fTWB+KSEySMUv2K1scS5VIA3kbO9q0d8hhC39Xu/oCBm3A0
         I2dPrDwZh04I1GfuzMNSjxtk1DQlBkYPAB7R7sIgqVgbk9WjwJPe0QtYVpE9V9JV09iD
         CsJjv7J4GlW2qnkLf8c5rdpao2J8iJuD5Etxw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772815820; x=1773420620;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/JdWkEYAoxELgAwR8n3saGF3HFaHOnFaPXfAPoD+V5c=;
        b=XDIECk6RYvmGoqQGQqAwg1EjpMfHrknl3yy6cpREUlVBtZx+gBGnY60yIOhRxy/4bV
         DiyR+nDKjoH5aLNUeH/zWIZHMcpNHgzHlig3w1Vq9Kl2pfjVOmO4TBuO8okqxfmEJ5o9
         cA+TdJ+skAUv6GfUQd53QMqoXkMrMhosZoDDrxtIF7063YtOY5UzKSU16PzjdrI8MSiq
         d4W3BfT30+YWv9dtDGmv9WANmTidECE7db4pDikuwA0Hp90VvpAhEHs10N/igvDLppWV
         byL5ToMku/NEEZ7Vq2Kmvvb2wCItsYOPDrL9+kU0PzvAcAMKKy3odO0TtCOiEPGT5YuI
         0vqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWShh2zglSUcEjsEoacu/UZzILqB7HoanjBxdTPM5Rexk/F4MIsz788jT8t8PU0s6HvLK3aYWDkg==@kvack.org
X-Gm-Message-State: AOJu0Ywdm4dbsAQAIT0dpdelaYp8SVeaX3D3syLrd1ZhJOBqY/FL71R8
	hVEQC5OpROqoe7ySphaUexRPW4Umcgjuh+Vz+e+5SS2f4S2+CZIEJFhSQUq4cacTjuH06zuSS4F
	Pwz/fOMo=
X-Gm-Gg: ATEYQzzBDYuV9OHjilX16vcd9veJzUMc4JVBAGldkosqT9/Nq+9w0mmzgiZgRqXerMn
	nvzk9Dk0WlLcQw+GWxOcjerOLiHj8iWiToGWWBw7cPnBIIG5FLXM3RM2Y2rT0Ze0LgKa5RXfAo8
	1FM9Aq6LIButakV5VmoRem0EQzZ7HnnGy6GkMyaDJFmtP2HBY3fZPc2hdhc9yT96qZj15n9mOVJ
	k4UMsiQOB5v1jopYffTXoL0wnsg1O1IjHu5qJJXgwRVxGIhEZ3DYL0LVOVEbm+JtQ/rRroi5gBA
	Y6baWiIUUDgdY8HRoDmYH0aPAoMQILYtLmMA5SSrPGxPvEGlawUzcPbMbumAtc9fU7akW4Pbhhy
	47ehfAwSsWRxStnxxUFjE+POa9FSn0jbx8kocCCi1A4Hk8ooQxuoo511jkdvOr/Q3I6LyV0n+rW
	jqGc4FQy2dsM/zMlmkit840erIa0DqTIfW4lXdADLwnq/pl0aOrN+ldulOCrj0oGdUMGIkl6jjw
	HbBz/reX10=
X-Received: by 2002:a17:907:3da8:b0:b87:7485:b4a8 with SMTP id a640c23a62f3a-b942d58045emr150963366b.0.1772815819823;
        Fri, 06 Mar 2026 08:50:19 -0800 (PST)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-661a4fd5e87sm642509a12.18.2026.03.06.08.50.19
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 08:50:19 -0800 (PST)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-66132b22182so3123324a12.2
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 08:50:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU8ek1SNKr9y9CfZj5ozWnDnCOCUdb7cFW2e38iirlSPjFY3kcpOV8QC2e1DyvCL8oxh7nTVbvFyQ==@kvack.org
X-Received: by 2002:a17:907:960a:b0:b8e:a1ad:36d3 with SMTP id
 a640c23a62f3a-b942df83300mr169072566b.46.1772815818781; Fri, 06 Mar 2026
 08:50:18 -0800 (PST)
MIME-Version: 1.0
References: <20260305103941.11f1b27d@gandalf.local.home> <CAHk-=wggaToeRYv6B5L9ob=wBdVW9_gFudYxH_WJDTuhyX_Ueg@mail.gmail.com>
 <a8907468-d7e9-4727-af28-66d905093230@kernel.org> <CAHk-=whW890h4m8r0iYwXEJK=MUJx9nLxuOduttRJNCLrMdz7A@mail.gmail.com>
 <a21ea7c3-fbdb-4ac7-8be5-0173f54890c7@kernel.org>
In-Reply-To: <a21ea7c3-fbdb-4ac7-8be5-0173f54890c7@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Mar 2026 08:50:01 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi4CA=yPP-rQON_2_swS5Jd0SS4UwWbct4LdfGFyzHFRg@mail.gmail.com>
X-Gm-Features: AaiRm53iDzSi0JGYZcfli_2X5ejbywSxs09OuffDjXkat3fpYe7Z3-u4fRncIZ0
Message-ID: <CAHk-=wi4CA=yPP-rQON_2_swS5Jd0SS4UwWbct4LdfGFyzHFRg@mail.gmail.com>
Subject: Re: [GIT PULL] tracing: Fixes for 7.0
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Huiwen He <hehuiwen@kylinos.cn>, Jerome Marchand <jmarchan@redhat.com>, 
	Qing Wang <wangqing7171@gmail.com>, Shengming Hu <hu.shengming@zte.com.cn>, 
	Linux-MM <linux-mm@kvack.org>, linux-rdma <linux-rdma@vger.kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 788rfstu3mazy8jnjqs1jsdjcuardh7x
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 8056B40016
X-HE-Tag: 1772815821-40735
X-HE-Meta: U2FsdGVkX1++yG+ZUyUDibWtUDmj8jn17DEBXblT4QJTrGlc0/07pehJXxfNHY6t3s22qDbc5RK95rcPHjFOKrTLFzCtXe62prBpflrMIqHxKLxufT1iHkD5wIT+VjvBA0d/x/zzXM9gIhov5cWMwDNBh0D8HzEIFXp9G96NIXHKGQibOIfbqBDR+WDjd+N4OXuP70sDh0IZe3/xPJlns30l8AxpEQniYocR5bwxpjUMxIOkfxTO+PzeThj21jxtCbi4QMKmQOEvSgJd7SDET2yqv8NgAmviM9V9zeqtl1PdrHAWxTS+oGOdgBJATvmccikXp8ShxTd3XE4MA2Yl7PJGckuQkhPoZoOmz7ltLkOD2mMjpbLU5XHqaZE0H1Uwe1UGmWgkVIVwZ41o5qAPWV7I1mhvfnZ9vyxEeZ7EjAkmSymiV7QMRc6kd0HKfjp4ym8cQgAxVj1/oYxKRkmM1vVwmGGNlKKXxNSE9/UeFvs9yayePmQwFDYDNzZB1HWVqT3sHDTQ5hTg4O2VLF2QqqdKvzt3TNBY5MHb6MzEJNmgUoVsF1W+apsNvXewRfPqMU18IS4b1fC4JDz6Zb+tAnS8hVsbDpCaGWRM2tIBT/FWZHGmZt1Ez4bp/RrIsgalfb4VLY2K1UFZ7XJoZFOQWI3UwdxFA4Cg7georeTVqnJFgabYOBlViwrS7T1EOfqkn4pI8W42+7CvgTDP8xaLY6xoNddViNDoNMJ7shGW5so9c1i0bYfBVP06113AX2Ap6jAcOpkQZf2EfRzTme7Ad7b+nhvPCDPscHDTwLfjC5LTasUHFowUSnq5MjSlPHKnNnoMELBdpg0saE232EKeL0KkIQurkgX6wrNROoVRKmSHOCJVXOv8Feg0l1pLTAhigs2tTqVkIAB3mIvCGrbKcTO6InOT9FhZ58u9hKiSExem/QkBorMLdFQjfGjJv2p7+KPCi7RosUq1dXedCev
 usVHdJ0G
 +twBtRr12GzId6zl9lktYJIIEbuUiqHHZAS6QGz1Lbxnv/VIdJQ+js+BxDVmRhkbX5R4n+xufAq0pnpkj9BoQxwnOgm4C3OgaZBXXF2PHhuQHdR78vOQM2xlcaUjfn8TNd1a4Y6ogQ2DMB+mn58QAmyqN2aC/nn/zo/NJsSofgs6lFnlKBsw7o5b/m7XXcjb4Qqh07TO9HUBwsOGhk/xQmoT4ZUT/16W4Bq0Bk7B7MLppdrBox2FdLiTAUxnMKbuXqtMselPSfFEhHWZmEKEzdHwGCWucZhUMbfxHVwFYqbCBQ7T0vPLgvQlaLYIc0tBkCn3nmkL1ph2igbR05FH72lf2SuOFTR6eV36rDPgh/1Uktms6ixjAbFRpyL/R14syIB2Geau6dcmmcgnoQWXp66GK+Z2lEYLggO4WQKXndSc+lVdDXJisNyIJjl+bQFbbQIYOqvDpjhoimjROE72QH9dZvq2lJEKcQuscicaaWITfzRE1O9sW4926biVIdeVJLdDXjndY/CMOF4/FIsWEnzApschrUTlziFOR1saCrPwVXp9Dbo7fOP5y1B1RD2lnk1K+r9CnYFa+NZLr44MhzgA3LHNYZjbCSHSiI+bEaKeUWzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 5 Mar 2026 at 10:59, David Hildenbrand (Arm) <david@kernel.org> wrote:
>
> Agreed. We could think about letting it sit a bit in -next before moving
> it to mainline.

Honestly, I doubt it would get any testing in -next. Yes, -next gets
some boot testing and maybe on a good day somebody runs LTP or some
other test suite on it, but almost nobody actually *uses* it.

I think I'll just apply this now while it's early, and see if anybody
notices. Lorenzo will apparently be shitting in the woods if they do.

             Linus

