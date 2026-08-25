Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6F7EC61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 09:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB30B6B0088; Tue, 25 Aug 2026 05:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3C706B008A; Tue, 25 Aug 2026 05:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD686B008C; Tue, 25 Aug 2026 05:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8AC9E6B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:24:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7954A036B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:24:41 +0000 (UTC)
X-FDA: 85139256762.01.4375C7C
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id D9286180007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:24:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NgPrr+4o;
	spf=pass (imf06.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787649879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vHLaGrUi7+Oo9AeiJB1vfZ/JdoschteUbCDtrAmEsM0=;
	b=xwmfeQAiJAOGtmRdXlk5AkX3Nfsilm65W4neOLJM/HX3vEx1/UZkQCBUOUXlnoSf+N7BJx
	a44wk6VYUKBn5cYJ9pPUcCqim6HS26Iwj5ea/MCRDiZcnE0/dndUqAXtKFdRv2QSmEe2v4
	y5QXsV36zvK27UeUhIE/sIyuIyD2mhg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787649879;
	b=ASPS9wuvpiFoMR+adKCGO7LdATBekOIXrof3Tq4ZM6q8y20YcIIJogYbGQpCWxEoOlyx4C
	9LLduYq8eyzNlazH1KEaIt1lb3KDqR+l7rFm4DaEA09hoQJ/zcGE5noou0UKs97pPNg5HT
	vI3SBiNLQqRLODs3ej5f1DNz74OSr4w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NgPrr+4o;
	spf=pass (imf06.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-39c95395230so40056231fa.2
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787649878; x=1788254678; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vHLaGrUi7+Oo9AeiJB1vfZ/JdoschteUbCDtrAmEsM0=;
        b=NgPrr+4oeK7PyqdeLuqY+DvJqoQaDNKkYoFKOTkCwYj0ZzLblNO/uxt4oRJXFrJ1s2
         AaCsnLoMAcTsv67/IQmf0ifb098P55nWw6ztsHc7BGOUUKm22jA99RiQW96UxsoETVSm
         7spy1P5G1+sd7pwmWdJ4GBw0R+V8jwCfxWSnIwnrIhh2KtCTnsOHxMLEwnKGlkn9I20Y
         rVS/fkHDQe1anUEOqt6CjUWtjNmW26va6HLrhRKBDdquXBAbXgseoOz+PczbKM1bVg4H
         zciDM69wyu1zarJK8nR0AOYFgNbF/nsGWM14QEmVTTx+GAqA1LUN6HtbMaIKIBJsyViC
         a3bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787649878; x=1788254678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vHLaGrUi7+Oo9AeiJB1vfZ/JdoschteUbCDtrAmEsM0=;
        b=q5c8Q4YHdHB7Wu7jEdB3Qoxvvq9RYCtSTNS8jC9sxPnZwHmjVclSV2AyUlLL9M5VWR
         GR9q3NUz0IsxKNanV+WoGDebFdyYs3P7pgblRZ/UvbsqZwQgBFGQVEcKqo15JAyncTsN
         5p2zOz1i7SvSxcntKCkWfhisj6b+XHDsqrHhqx8+JWzLCuALJWZtpdHfkibsfYWEGki8
         8CL6JTVF892Q8hX8dPfNdL3pAZaFEVwOcHOwW2xxJWWaODPB5AFz0oO42auAQhliu10X
         QYpGfLWWBSkPv2VprWP0p/E+8S9d2fzg2KZHPCCpMgb8RiZDOGohCDFoQhbs1Hx5Wh8Y
         WNtw==
X-Forwarded-Encrypted: i=1; AHgh+RoFA5HrciACWakMjjxJl3YbtJbiAz+LWhnkLRYBvlUzEFaLo8WsCcuy2gK9NpnWtNyqVKd/Ma4u7Q==@kvack.org
X-Gm-Message-State: AFuF++mztBE7WqVF5nw1wnFQulGffEFmMptxXEAjnjyjU1uP+ZFki4yw
	48BLae4OjRCunxe8+jG0EbQwdFGdXYO8SrljV0GWdP2Z4Cbmt8G3U74f
X-Gm-Gg: AR+sD10aotXAcEk59ydHW1Ms4fxbkEhJ8NPIK+VV4WTzSS3Q5SHfZ82vv074qSPOGm5
	2tY0jSF1Yc9vXjRIyImvhVD0LiVNSy93BWrB0Ad7DzU0UpmTs8pw2in7uVvRomGLge2m8zJeL4M
	Hq0HJT6t6qUGCh/SnuMVP6ByRQXH/wEV+JATaCwnqnB8Z2lvn05HhUwd0ZS0nFSkRi5ahro9mlX
	h7NIR7kvzoBTlrw3OLKo6NjIgUigDLOaWP4Dri7ybdk6q8cyNt3d0qvqzUDPLlR715r1rfdbD3p
	7yXaXdS6+nY8P6Eubjo0CKhIKiWsxb+QltIXesRdjeOGa9bOiILgRlaAJDfzA/AIWHKrhspiYte
	9CPWfHNIhMnJRo1VuFmsr6pQD66wcRwcQevBgXGnvGyP+RbJNJ7WqVPp3CkdsOXMr5AqmSF37ON
	ikpn3ufD/ikXeF7ZxZUTcDrs0wV0pjPbE4WeGxegxFdjd+Ubje9VjbHXE0rGAQMYXIkcpFsdL1n
	IpIerYiLqpqgAyyg8YCaq8TzdQsvwVa+10hu8Pj8hAfnJ1LaCu1cLJYyw==
X-Received: by 2002:a05:651c:43c1:20b0:394:1254:10d2 with SMTP id 38308e7fff4ca-3a1ef07aed5mr7714881fa.0.1787649877837;
        Tue, 25 Aug 2026 02:24:37 -0700 (PDT)
Received: from localhost.localdomain (46-138-191-2.dynamic.spd-mgts.ru. [46.138.191.2])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a1c2e87dd6sm18732761fa.13.2026.08.25.02.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 02:24:37 -0700 (PDT)
From: Artem Lytkin <iprintercanon@gmail.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jann Horn <jannh@google.com>,
	Carlos Llamas <cmllamas@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Deborah Brouwer <deborah.brouwer@collabora.com>,
	linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] rust_binder: check ownership before using vma
Date: Tue, 25 Aug 2026 12:24:25 +0300
Message-ID: <20260825092425.64784-1-iprintercanon@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ao1E_6yo9hE17e2E@google.com>
References: <20260218-binder-vma-check-v2-1-60f9d695a990@google.com> <20260824194808.216021-1-iprintercanon@gmail.com> <aoyvV5-ZqXoRDFaf@gremlin> <ao1E_6yo9hE17e2E@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: da8q4u1pi53t6abppw4gzzgwjkmcw84w
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D9286180007
X-HE-Tag: 1787649879-206513
X-HE-Meta: U2FsdGVkX1+SZ91jry43OikWm52fJWLE3cPIfWW+QFs9UXizFGJ0OOr4YF57xokjE+mSbOBd/pKe+Yc8ydGDdBW3DTnNrbnnC8lO/+hx6R2PX4WlmSH0qSCceIYUgHA0yPpgRinFlgB5nnff9EsHjJvP9BlGwn+JIF4fJc0tZ7MvJLb+DKoAIHSd3w/4zjHydHw0T1vn8FoZs6PVEuc4t+Ruua0DwviP4/LSFHs2QYJ/Vf45XUkKGS7hhnoLXs7krLyiI5wGD5x+R5U/Rjyorx/Nv24ApfDCFsu50FtnaZfMDiYwYLE1stVxc77wA8HxsR1oKem05vbnIRIgft8rXGieOIRbrRy30P1Ss9RjkWszuvQXExQ1Pi7ObCreZHWDJOx2E7FWNzAH8BVfEEIj6yI/1ZkcZzwD6g2WwOo1kMhLwAYcDMFUWEw0HFVFn9XmU3lpvOR97TJht5L1zkkrOGIe8RDe7f1ot16tMfsi5cKo1FnYLR4PjpX7sOFN+bEfkKWuhXijwZ7BtsEPoEWq8VeLF2rI4q1d59YCj2V5FeXaziNhA0pDR45iEXJ1crFerD1kaays7QLWVZj69VBa/8GWlVUqFsSq0obxobrb+OUzWPRy2WYqLlFFgx1P+BLw9Qut4gp+Je/E5zln/YsbJsek+h+V7Za2agsKyFmBj6whdUZbRsQYybOd4TH/d9ncSLTEe1udgNmIaLjF9j/o2gpllFgJe0Ny3wEtE3mcJYddIDM++My8hIl61MeEmMkGCiFa0SxUA7qelpgY8XpPLiNQJDxtboZoqXpJn10j+0iHDtycVzzbXoS3/ziadaNolDJO56Oc2eDPUUN4OHOsF9JuegFxHKf13cEAqSmKredpODAafzC5YUoGvjCWOZXRSY/8nxKIIi3ToU6/hotjzXroGkkvz7ot0pSKtvX7pbkKZ10CAXBO1PKWWWnNmV8icAuOlgFiu4fBo4pJnxZ
 GNOyvnXa
 U6U4mSQr+1yNNJhsX2k61RwQftdSD+ICSMfisc0gAtsbnDFc4aahvSoYJCktC9Css5AAJUu1H/09lja0szZl24fcn0R7v4A2A6/znNxTPr/gl9yZeoBS9bWt3gFRj8nqJmh6FzwWj4ASvFdpVpWb8qQq6dtJsH3O8hhehqrzgO5rZS0A4fNgfHsF4dwc7rv9qk95qm5UZAtRK2H8cT4FIvJmVWi+3TNJH0nuH0/NI4c3IGg56N7qqHBfl70kUY3lrP/x8IL5MnVd7XuEsqzQJw+xyO5Hm3byPb0GPykof9EBwUOYvYsLDTlfXhxodnIrwjJZg/Qn73M/GodA8hSqJS5MfAZ8qImEB2IF0lGhcOGB0ec1nMGpa8eUBgC/GbhLFufkTKnI5LTMTImBhgUMSe95TVYhwsap4QEdI07o6qjWqfFYlXCfplo0yK1txk1smgh7tlSynKukSzfHkcLK8OLoKGTns9IBvwI/Sy2Awaiocw4o8OBkRDIoTC1q6LDVsOR0RA2cERWXi+/LnWJcKBcSZCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 07:32:15AM +0000, Alice Ryhl wrote:
> I'd be happy to let someone else work on it, but it's somewhat
> nontrivial, so perhaps we should have a call to discuss the design to
> work out the details?

A call is hard for me to fit in at the moment, sorry. Could we do it
over mail instead, here or off-list, whichever suits you? I'll write
the design up in the next few days and you reply whenever you get to
it. If your vm_open draft is still around I'd gladly start form it.

Artem

