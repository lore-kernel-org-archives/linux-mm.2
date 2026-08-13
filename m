Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB2DAC5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 12:43:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA4D86B04E0; Thu, 13 Aug 2026 08:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55BD6B04E1; Thu, 13 Aug 2026 08:43:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945246B04E2; Thu, 13 Aug 2026 08:43:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65BED6B04E0
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:43:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E4D2C1A00E8
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:43:54 +0000 (UTC)
X-FDA: 85096213188.30.BD5169C
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0D5F1140004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:43:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=thingy.jp header.s=google header.b=WXCVJarf;
	spf=pass (imf09.hostedemail.com: domain of daniel@0x0f.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786625033;
	b=htYNBQinS84/EKclMWWx1fUDttqNZIb4t1zpfciRVWpOBP4mK8Lr1i5OdiynIeo1NelNfx
	xYiCu4tqQgEpXD1cPJwBz1hpWhu3EfLM5XeFpxcgPMyVIDUvDN/XpMr8odSfIBDGtH12mq
	y4yfhyCGRKM4B8zstGMwFBTIMIyWfe4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=thingy.jp header.s=google header.b=WXCVJarf;
	spf=pass (imf09.hostedemail.com: domain of daniel@0x0f.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786625033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8MzUWj3rgn1GnbdJfRHSG5hyWrOQ49fk1AOnT9UoUDs=;
	b=5wzBVPd/vxcu58p8eviZfR5hit64jsTegA7ESZjY7Y9z8nawEmQDJJ6oCDpoLQo+kr52lW
	QXQFxwNJzo4BQCHou88qpfcxhDbS6HsfG33hK6XsZqto/wZ0oBCTYV3+fFUXn7leWv6lV0
	KLhDg2Vmuklvrj/Y8kTcc/IP4d3/fEE=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-7ff05e5d009so22590957b3.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:43:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786625031; cv=none;
        d=google.com; s=arc-20260327;
        b=MwRDepgyF0LS1K8eZ4MtICc94YCDNI+US+XYGcPiD3fkobYApcMLDqlJJ2i68q9DbI
         RbyOvwgBpvyulbgwJr8r27ZCy235E67HcbDsaxMQiH4pZtXLSqElR4cnpKc+5qHB5aIF
         ahhc/G/w74koIWC7eF9B8jV2UD4B02ikObUWi+u9OwZZcWKkveVBNW1pQxh93CvUO87L
         k2XtCETkcLq6YARzKQ/wePmGL7W/LJ3hDTqDV6eJxXkfIC0NKYrSwAc1JBjMEn6uxj9V
         DEyRCSBjXyQ1K7ZPvTy++hMPDQbb1eiDzcSOYxZTogYPNZZQm2azBRMABFfaw2rxoc+I
         Lk2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=8MzUWj3rgn1GnbdJfRHSG5hyWrOQ49fk1AOnT9UoUDs=;
        fh=6Q0QR2lX/DT0AZAreoqsNFtWchLeoyVt2dGHWtUVn9o=;
        b=auYyEQBg5ZLZ9maSwUkThTfnZ/b7rorrriZJkkPtP8igXWDPqTMsAj3g4rOw89JVeJ
         nr0WpH86QOLgpYEscC85HCQOGf2ElvgQ85D1jg8gQQrw/ziiSiiW+F9k8oiPA2EQWLxx
         M6Z83cPfqx+pQkpG7v9RX3iX6CO2JG3nOVNweRzNIQIh2pAyO40WBu3YhfSaP1XBVf+y
         gkuMXgaTiNRfe9PDSxJkEVU9W1SJdzF+P3ZLbp4m6un+Lw/OfnsDkZ/RVjaxy7CeB/ss
         Dct/244e1Jw0km1baqUHcab7wParo6NMWiy6MQcZ+FaX8VlTTr4+emDidWLk8Cz8r6/W
         zNJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thingy.jp; s=google; t=1786625031; x=1787229831; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8MzUWj3rgn1GnbdJfRHSG5hyWrOQ49fk1AOnT9UoUDs=;
        b=WXCVJarfjvV9asFV1a/2rRGDP6aQ14h7PHx+rv/8zNMN08SjhxQ/kDrIjrnTVpsaR8
         D3G8LfOEQuz9fRdrU7q4lvFZFqg0O+I1xUdK7lqsKfbn8WIAkH6iKToEZiJRydkyN6iB
         NGX5TguBtmvgd84zaZ+tLgYuQlzQSzKrbJ8uY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786625031; x=1787229831;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8MzUWj3rgn1GnbdJfRHSG5hyWrOQ49fk1AOnT9UoUDs=;
        b=LgS2Ea0d+XIk/M+gpXf18t7G/s62vv08gy2lKAQcK/Wyrz97UlZv4+IlKdJPUVux2o
         z7Tbbgvqk9X8IuvcEQeQtYOMErJweNe5oywf9mJL3fGmOnJskN0mrJNvSuRUuJ+0niMA
         OkOi+8kqZUP35Exth2vlXDpLNtz5lcJnjGIIOUYVpWuQUqDhBG8+5I6ZCoVZsoZAl8Tq
         mKv9JIYRop7fx1+X1kir3QanE/+KH1s98uCxi3VN8usgx85CaTy8s66/6q7cUg6n3pbd
         e2y8Vy9AJkNCX4IHDVcn51viPSM3ZYkA6xBr8Gf+E+8j2ux9eLEfvg5o4MOSVdc9bXyd
         e57A==
X-Forwarded-Encrypted: i=1; AHgh+RqfhjZIFUbK4NFkxUu3L7QcO51MCwmTtywRuWi4KLWeVwmK9moxbpnwNIaprT3/oNMg02BBABjIig==@kvack.org
X-Gm-Message-State: AOJu0YyKrkm0ESredOoGFj9O5GdDvwtgWAjDtHmgCZ1Fu7DGvKKXrrV5
	mhhA0cDhpJm9cPnEFN5zgIs3morRvfEr9IInFnVEHZmv2RMyoHe0V4kkEjCd9jlpKLLEx0DVlOm
	sB+230tLAzoEdZ22CNrDXX7ir5105c4/QvX7GIZWYrA==
X-Gm-Gg: AR+sD13dMA1h/4WNiOwcBPonh5B+AZs7V4zUaLKoBIXwcdYK3mlRGWo9SX6PI7K9QlH
	Nkx5KJu/QtwYItXDCIuTGqAbBvPtqllsrVzHsTaPtLyBGc0vWeDa3isPUY7HCrLh/s983D2buKI
	T3fPmGXZanqIsZIAQDBSXmmgr71xUXgxGLepvGsGAiJ1CaFlLIETlqTaBCuzzYJ85/hygkbVCK3
	iQvZ95/+MMG7ootKsPq6AQDtHZ6NBLLLx+sJDLW7v6epbqg+5nomAHOAjs3W5DrW+xrOtcVTcPI
	9w5lEI35AcM5OQKuLGwf4zouQ3zTFyJpjT91+1gCpAwmybVkvzyNAcCU9yHgAO3Sc+4RYPKlD0n
	d8Q==
X-Received: by 2002:a05:690c:6604:b0:80c:3848:bde6 with SMTP id
 00721157ae682-8347604ac58mr25851337b3.30.1786625030082; Thu, 13 Aug 2026
 05:43:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260813063401.1786548-1-thehajime@gmail.com> <20260813063401.1786548-4-thehajime@gmail.com>
 <2026081355-remold-sterility-84f9@gregkh>
In-Reply-To: <2026081355-remold-sterility-84f9@gregkh>
From: Daniel Palmer <daniel@thingy.jp>
Date: Thu, 13 Aug 2026 21:43:37 +0900
X-Gm-Features: AUfX_mxLK2-tTZ4HbMKH826rkOgcLTFpV3jXv1YZv32aeraWoqNHTweMz1gVfTY
Message-ID: <CAFr9PX=zC8GnxwrR=wTwA4xQq89cHYpxZWooS+-=Q-WuNbjanQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to /dev/zero
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org, geert@linux-m68k.org, 
	Arnd Bergmann <arnd@arndb.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0D5F1140004
X-Stat-Signature: 4rec9yz9urrpb5r3j1joxym4f1ewzrp7
X-HE-Tag: 1786625031-192589
X-HE-Meta: U2FsdGVkX1+aWIljkNrv8hxwpAw83TxTlKxLo0SzF5foYcWpZmGKyOAxLkW5WNt04yGYe7xCovHUT8KPyRV1Dg/VKPyS08PyKhV8iMsHL53PCBihgmQNlKPlj13NDjdz71fVvslodXiQdN6r2E9e3JgHUuJ20eHHskjdbQiBPxso6E3u5qGbGxKyeW0XQOyEw2dJ0Frjs3O/lvXgThmz84L1rHeSuT5EnemMbXXXFUx2QrHhmzigfj8YFFuTbSTMjn8fz2rE1KwC+66Jz56RXMgTlPkqeFtQ05WMXAwpY+YfImhnYMW8P1soikhUhfk7dAbu8IpZsvW6i18jTC8ABJ0yJ3kD0yegH6+jqCgL/73JYr1dNdRczBqCMNq+MU65YaaAGCxkKx5PYQFiAe2RgZPVWJo8irTEVE1jEneBPKW1X4QQKUdvN3WF0eyJGmXB8KdV6XWj7PEGe0MafhYzpLX3iiQYE5AlKpLxVvJAiwU2O4ln4K7VpAlgaoUNrL4HoIrL4/ZDxb4CjWxCv+zjTKMqprxE30B3o51VxXrrnMEWDGvTq0cHMGZazpwsIKrcwJ9TeicKwY5dQxX8/DIzj7VKiOOdFTIBZ7A6Ucxg2juDy5CnHPc1B6k/X/EeBw/2qsDlLCtqj+p7cbjx9Fq+F99ldbGlm4+KALdsljzf/nH4+xlGUehRS1Ll3IDby9hq6prMNel9CQdImZxIw0SF8Gf9uosebX+6j3pX8V0aQ80ms6YaQrH15oA7KdArxftxTcXPv6URpoOZM/UUQvZ3nG9nOiXEUq1bB25yY/WMnCnn53LvaQVb3F33LiD3pn3BjcO12wcQzHO6j2ji+WhLE/W0SYu36+m1eQzssE65YKY2nXW4CQ0+KW0FJ7jJUX5NqTzJd6hzws4FLenTsGgHInFBPYiZLSybF8tiB30DBo08NKEUaP7BP6orm8WaNCM+gZgsfp84iXWxcAAJ7Te
 c2y3Xla7
 W2clvpTHJqLOJm/eTutjtyCNrcNKJSe4giDd8PQSOohJ8t3wT/Ig3AIBs/nIr9MTUN8W7Znp3u7R6/+hnjB9FGOO1f/FmG2c+C6lQZzoj6vujkUJUJHsYcXdXx9F+uBVhqSWFD8dfDmKAoDw/pyN9H4tov16iNBczSaJlMTi0ZBu8AHOPUtFqtp+ma5fnVXj5aBAVO1HD9aq5MYLHly2317U+0Twhv431SiN75dew+ORsQifVGWFEFM2/h0AhdlYVwBoZJryKTxeVZAttxpR+PpDIYH5xAgdz9QWV4PS9XyafxoXB7JlvZ3gv95DN8af1Uszw/ddPf60WEL/Q97CWSnlv8SmR+aisAOfku07lEd5FOxO7K33olj1G2S3/ofN+8UaYMgP4quOpLsSCwZJbv7No6nElQqA6jqiS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Greg,

On Thu, 13 Aug 2026 at 21:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:

> Given the age of this issue, I don't think anyone uses no-mmu systems
> anymore :(

There are a few of us using it for hobby stuff[0][1] and there are
apparently people using it for actual commercial stuff.
There was a session about this at LPC 2025...

One of the big problems for nommu seems to be that everyone is
convinced it is completely unused and totally broken. :)

Cheers,

Daniel

0 - Really good example(s) of the 68000 port
https://github.com/crmaykish/mackerel-68k
1 - https://github.com/LinuxMD/linuxmd my version of the 68000 code
with devicetree like those fancy ARM things running on a sega
megadrive.

