Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F967E9B346
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 09:50:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7776B008A; Mon,  2 Mar 2026 04:50:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61B76B008C; Mon,  2 Mar 2026 04:50:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939F56B0092; Mon,  2 Mar 2026 04:50:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8336E6B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:50:44 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3266B5AE9D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:50:44 +0000 (UTC)
X-FDA: 84500653608.15.CA09BC9
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 44469100003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:50:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YVjODA4y;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772445042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DjYuhTfxuStg4DusSeqMRyij4jtJ3Wp64NCtc74Pn00=;
	b=8QUE4+t7b5GT2W9orbuO7zpW935flNNew5tswxm4csf9iR/dFhbbo1AQ8xW9litiyF4qBP
	q2cjyg06EwKmlC4tFJDAqvmc4zbxar0RKqi0Rp5K7PjRd/4tOoLxDIow9lxbsjCTegHh2N
	9eaX8EhmzzIxaDW2cQsY/c8Py6hjZL8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YVjODA4y;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772445042; a=rsa-sha256;
	cv=none;
	b=M5retLkPq+l1aY4DXrEcr1p3eR61f131CvJAVGw40QRCwV1op06DfdEP1CGYSx0ld5iOp/
	ZpYiAI/zZH/70dr7rLTlXHdpw3nIZfCL898yrBYwv58XV91Lwtqg4VK443fog2EAD2XoML
	nmvxPl6H7RX18+QNxfIAMi6j7rHFoLU=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-439b6d9c981so524948f8f.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 01:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772445041; x=1773049841; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DjYuhTfxuStg4DusSeqMRyij4jtJ3Wp64NCtc74Pn00=;
        b=YVjODA4yOAKHupZsutmhEzJzUQNzTFaXVm+0RwniATfxEWysesBVTkpWqm1wUXCtTP
         Evm/xAgKuCKhY4a9Av2ZLemSOjbzkxo0Sxf5D+crI+qdFcPNdDe0tqCGynnaxrJ3m7td
         QjBD91oBeawbALd2UTye2XvccVsG3xyfavnIt5WC58AfjYjrAg/mcpqBIPfeKVKaSHDO
         f78jTw1ptErUp7lz+AK3eNf++hnfMEwrdPvqRgOKi+zYCPDB8q30VeXEHVgjXlook/0q
         qma0STVFDXDuP8WGOPFNyE8ZfD6Al29xGrGK2PreHFKG/fjVIYd0RRWTlxfKZa8aZ1FT
         DDTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772445041; x=1773049841;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DjYuhTfxuStg4DusSeqMRyij4jtJ3Wp64NCtc74Pn00=;
        b=ZHeutXaq70FWKR3qXYApEzvFIwA2qit4ZWwSP8/1CKf/ajle0Id/VPwIeXrVJ49p59
         SI1Dvz8YxbW2ko1rP+8DjRtA/LDJS91JVrXt382SkhjgCkugn8zi4LCFz7nhR/X9yaGg
         KYtz6s2zfuZn9HghOZA5FSZdukY/M8BXabynTCh2szXnqCJwG9Ds2Vj7ia1xuJPUoJEE
         mn39c+juX6LG3eKN6HzNX1w+ApNOeIDmQYBDBFumQa8RFgvijH1JhQUv8/nw857xvt0h
         N8V1w4JXlwLolkcIiw5e2M5DyqIN/pSRPjkeH1sPeRCnF1gAMkvxMJgMXi4A84gsTAEt
         43/A==
X-Forwarded-Encrypted: i=1; AJvYcCWf+X+YdMJvZZYv7kzKKJUkZMo/HruoEZhvT5D9rRBrKJN1e7q7xlxn98OCg85pnPnO7qdJf34tMg==@kvack.org
X-Gm-Message-State: AOJu0Yz3c0WCotSDLE3JomTph3VYXP2L/WjFopCzZiGaAxtjLY+HYWHR
	Qo6Iphua5O/sK2NxnYvSsdwC3bcRJfmSZb1HG815OyDdAWV9BwPg7NXt
X-Gm-Gg: ATEYQzxprpR8IfO4niPwd0KW5030SjmB9zEApLOjqdz4Ur+IvwbJNo0GSKczSkRFLs2
	bdSmPFU8WcVGbW46k49yXq7YKAf2OG4ZsQI+n5EnRG6l0uB83wPjvO0VX+OUClyMMEr6zuoEjqJ
	lD+bM9t24mW9Y+3hhxiNk3oZdQ7si+y0Is6RILmyn+IPHFsjYKb3jcnXz34STJxq/RpFOYFtCem
	o6U+X4i7AgSb/HHXBoh+4hpHkJNl/X9cjgeup3U4MOea4YbJTHEomuYaPFZCtax0saP+z541Mss
	hOe6vCXb0Zv7fHPs2BAR3ExsyPIRC71XjDUwjxGc2im9bems0ncGIoQobNn8AHDVVAjUp5weRpP
	uG5Etzla6P5zQVviGh8FeGrw2ABeh8IOYqdE9rKHifU9AdTRtXTehzN7lTZc/0uqxEdk4yy2uvf
	9wuW5V
X-Received: by 2002:a05:6000:2c06:b0:439:8559:98b with SMTP id ffacd0b85a97d-4399d97f826mr18969913f8f.9.1772445040626;
        Mon, 02 Mar 2026 01:50:40 -0800 (PST)
Received: from pc636 ([95.214.255.238])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439ad3daf89sm27054944f8f.20.2026.03.02.01.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 01:50:40 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 2 Mar 2026 10:50:38 +0100
To: Michal Hocko <mhocko@suse.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aaVdbio9nwRW4L6t@pc636>
References: <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
 <aZ3F2cghZpqBi1Mk@pc636>
 <aZ3HaVuIA4Ezu1uY@tiehlicka>
 <aZ3JB5Xm3SCmJW95@tiehlicka>
 <aZ3MzxtMp2OykAQq@pc636>
 <aZ6zwMQIj-3JFQZq@pc636>
 <aZ7hJi2-iATBD6GL@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ7hJi2-iATBD6GL@tiehlicka>
X-Rspam-User: 
X-Rspamd-Queue-Id: 44469100003
X-Rspamd-Server: rspam08
X-Stat-Signature: rjupcgwapch6hyf6i6g1s8z6r4zhrjai
X-HE-Tag: 1772445042-862696
X-HE-Meta: U2FsdGVkX19SJ3vPPjmdOU0sX4pKe1F24xwsjRp9xE0yqEHqSCOSnYhs5ja4AnXWVS0oM1PmmiO2EF/jGdnMi6j/FC9h7FmA/Py6gDlX2ukEudaym60zvwfWoDsg5WyI4unwMT++Xh/lF/lPkxKkSosEA94BbdDSukaR079zeCsfdzhYoEjsBPKkQb+34dQCwZ6aJklsJ34LYSfKa1XKnZfG3E4bLZWb4EifOh+Pfqbs00cDzX+NMjwZaG4qkS2twT0gjnrP+kurTND3Fzmsqlrb2AkDgP4/wsxTcBdrV1JwzFRUsb4SnJP/zv5sxZ8vAvHNpp3VqlFuPVB50tCFW4Mt7X6CcIt1A4LS+SgMKswP7a9ZT3UkU+slu2mhm9y3rSzsubb5Rjx3nIkIqXlJmAoZvzt0OK7ZyN0wacio9yGfitogi6b7wokCgJzyUJL6F5eTRxa7VURtLY/P2L85NEDJFmtAYF7ByL36D6buysFlfdzpKas5TQrlt5jJn8ACLyj5QIOSXADw+mR3oTrVr+rke8xxyi9AqgA2FuZf05Dc4DTqUnINw1ia3EeC7nKrI3C9DgV0BKqGNvCaxPu/5Fg97hDCc+bdL69bcKjtTiOne5DPbHVS1VFL9ixpWUx7/e9u6/UO1MPuD3fys7/M5BKzbQpjq42yhg6cpzjCtDsys/Q4N8AltZtQjSK+FMQyKtm0nsCwZnoVwH9SH9HQReC7RozaKslFY2QgAoaLgbC26fQO59uu5DYZ9DUgFIwjzt+ypi/BuOv0n2yecyryS+8EP3n6Mprt4ofEToEH7snoaANz3FU70GIBTTxWoRiOGloUbJybkJjpajFAZ0NMc62yAeLR3WsZjlYqReJYqbLRY19Vs9gWl80kPlPEs0FIwVvOEw1IrrfWK+xqHc4j6qIy6kyv5HBWE2QWAHzfsiJIMxYnX8dYDPbbcHOiF29nGBF/tAGqMqF8KtPM65Z
 I8atqU++
 PZfV4Yt5pJhx/rRXZOP7a2muIemSbxFxKOC5fqkhbppevag7DOqoCSH+UnldCfWyhLFqL5Zw500qgy09/q98+OjGlf/rBVGkY6wkk/cXSBsO96iNuAd3tYngLHoMNjRtwhqmhlVzJlFwq5LQje6cbem4QR1WGvLnz2tINoM2PufFFr63iZOdgLJnHSwuCiK9nP59xrYveeFPhPyCYGbmghDco/HfwFX3KPMpBpq8IurWl1tCAtNKxbPvn2zwM+iCgWvYE7vPp7v8fJA2LsxAYouaLit6kGMLkUI3FTP7R5V7gqSo9h36HTM5mNLkc4cWSgYX66bkkXm66mS2VQxUJMVo/vo/9CaVz20l70XyCRhvRHG7GfcM6o0/Grwmrucau5M699M2iLtaGNHKzkPCvalta+99plX/m6wo6kMM8Jzy3/Y6vwvX9ua8kxcAbB2ebU2R8knDDL6js6BJV+DSlFVXoC/8+eZe8H2YKOqlsL/K4srEyqcGWLC0oxg7J60FLe2JCNrvHeAcp2wtc4+5rlF6L6HqnlyJt+qnpyN6CuEvCA9Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> Feel free to use this patch. But please note that I do not have any user
> so I couldn't test it. So make sure this is tested before posted for
> official inclusion.
> 
Thank you. I will properly test it and apply my fixes if needed.

--
Uladzislau Rezki

