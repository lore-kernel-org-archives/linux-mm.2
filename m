Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75BF0EEA84A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 19:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A4216B0088; Thu, 12 Feb 2026 14:16:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652006B0089; Thu, 12 Feb 2026 14:16:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 533386B008A; Thu, 12 Feb 2026 14:16:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41B776B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:16:08 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F0D851B26EB
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:16:07 +0000 (UTC)
X-FDA: 84436759974.14.DAA7235
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id D2906A000F
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:16:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Moj+2hpY;
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770923765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34GBq/w9QEN1MAXl5GyaptaVmrZQSD6tth2MQtzvH/8=;
	b=HHdQ/KIug9Hx/8CqOrLzZ149JMFaBdA6D9+ZCciPl5un4LwttROsIOdI2iYP25G/jF5pa/
	PJmaGfAdWzlwTiMViFQj8bj/XQ9bVc1i+r3cYrAHRRuYhdv3yT3fAU8GoBfBJ3UBpz5SBX
	XhY3NWXGvWLMarJqkkjw0nRv/uzHbzU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Moj+2hpY;
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770923765; a=rsa-sha256;
	cv=pass;
	b=4UieUvD1rI8BKC4ouPS9+flaTYFKBqKT9PdL4wBnQQyYHBdXhrc7NIzPa4O0AKnxFndWfs
	t3QrVsWIB9HRJrYnHDa6a/p82GTuNbBhnbNqWSllaHX1RG5B364mGXbmiGStfHdnohHM8i
	0PymvHYJnizGI14PpUPEWCUjvogJWMI=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4806cc07ce7so1539065e9.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:16:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770923764; cv=none;
        d=google.com; s=arc-20240605;
        b=CSxYoaRNfL2Wgwcha4PBs6VWusrPV5I90tpjmPTEyTFD/u+Xmg0/M6wKmsQOqbSCd3
         YJXUFowqKi5esNdufxqusI51NvA6iWURhIvAMy/JjmmFXFWFhHRu6yHB01DLgid15oZH
         TkGChGyU/5YWmMSWR+V6h1cqlri14iD4qkeVQed2iWdb1GliYaZLLp2Yh9gEGnyf1HaJ
         GEBXNsOA3RWSmjUsJS8eoiWwAisKj7EOspjAK60mDQbSBz4FJbFb+InT7ijztPd0FKew
         8z6ZZYaK+5e1zlg8t07OOO2ohhbO5zVZ7fZmfw/a+yeVJOBQYVEjlsaISgGo5RBhyULi
         7vuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=34GBq/w9QEN1MAXl5GyaptaVmrZQSD6tth2MQtzvH/8=;
        fh=HFXfY7bwBUJqvHSqYChjvAUvjnFI21n5YnUwMCxPr5A=;
        b=FJ2N3Gqme/Qu7PALvbTf4FJPFU1cCJteAVtI+GnCsz60J8RxjoiU9xV+jf4/hfmUf+
         wEn8c0DL2vIz7VK+OzYC5mJygsiyH3QYnx4LfH5fM28ryKqAyQKQL1+rqUiT10TXiDDi
         pNgeoHPOTr3wK2ABRz3ATVlmCH5hOaj2hHd6y82LY7nQzoD6A7OmhYACT0ZXHDbj2csY
         1pFe3wt8ZqQK3x4f5+9Z76KX5yufm7656kGbrck/ENvZ5OpYLwr7sgkHJuqAJGVwSQBH
         8lKX3t5obiUqJTGiQ9j0xszjLA6J+iRSZDKHDdQi3x1zy+cS4OQEn5KbEbiUoGueCx/m
         E8zw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770923764; x=1771528564; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=34GBq/w9QEN1MAXl5GyaptaVmrZQSD6tth2MQtzvH/8=;
        b=Moj+2hpYZkjzw2xEGt/d8/eu01lhgpZm0t9DBEM2oJwIGe25CG7KQzk9I6uKCyRGGo
         1Jznjw27aKrvtCcXduB4s+YRkb9I2uAviNPHD7pOvnOc3l4GUSS8RLVTkeNmugC9DLuE
         ijhxiitacHJXTcJbXoqQTzJ8CNPb8j+plwQe8sICmjexqddJsW3qnbneZhxjs8Aki8kt
         nrMREEfqZI6Nxv/sRcCMqQnjpNNaXtooFVEyfFDwelZzNc0UtHmUsp549ov7Pijp7mt1
         D1uHXPrCUP7ntk8Bi/byVnzmsFBLX4pDqXCTeJs/vFEX8fu0pVCjONFVXiMLDdleHlOP
         d0vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770923764; x=1771528564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=34GBq/w9QEN1MAXl5GyaptaVmrZQSD6tth2MQtzvH/8=;
        b=A7ggeasT26XzTahXtvUo/QZzM0Hu7hfXugI+YJfk0T1vBzmNm4tIMNoCiKk8aMBvqT
         mYmP9litAyyEiNrWu1tVCLAARIX0leXIpOJXZ+F7hkRIVjfh//tny1JLcvAZ7I3pJzd9
         dNJWtZZGbp6SWc9VpZovEuqlSwkRuwbH9Qw4Wjsd4ISUWckcoAeYF6qcg63t70S1wXaF
         eIMlZNc6UC8/o8URgnM4PTuBifPG2/3XIx+KlDl4K5VhkP77FPn4860MKz99g0ldSSrk
         t7p3Dq7pF0CzszAmRZhQ8N4R/PHtVfNPY97EVyQgZxI1eq6FykwmUwcD51RMc3WSrnB/
         iaAw==
X-Forwarded-Encrypted: i=1; AJvYcCVAzKBzLZoR6TwvdV36B3gkiT/OqiCsfWgGhsR+oDV64EX9n9zspVOVTHlvNb4i0h0xbGby4xqpzA==@kvack.org
X-Gm-Message-State: AOJu0YycWByD/jN5XGvKfBE8e2aSMtTgW9rmYoiR9hqNhZoUf5FG/ItF
	vYSafhLvqNg/sSbL9rXbjYABnH9zfsYo0fnCHYfHvD/u1Cz+8osD0tj3MJ0kWzeWPjZPgEeA8TO
	AOvCVkETbVOQU7yih51q9e0YSh2JzdPc=
X-Gm-Gg: AZuq6aJATr8+WjDs7VDgaNqtxuQnHE4JrrZlitpU2f1JWwzd8VCEWz9Ax8SIhmoq2YW
	VdXzgRz4GfR3AtB4e+0tvzwrlolajMwCXYPJKq21qbmATRr/Ke/MH+LsAoY2R8FTsT1jZTCTd1t
	POHuZ9s9Hg6gGM8HwMMNkuvEfH1aZ5rpa2+SN0N4xeYUKb1KP4oriAx3DL3XJE7QtjYzyQKEQSF
	JtxW3W/EE7l9tz49k2Le6JsLUz/XNKuXYyNQEf8gNZxNDyqx0wOwnNJAweVovx2LdL+UlUqdKpr
	vy4OirI9Er3em3Zp/y0oGFpAuBF/liuac/G4Cj5YwKoYyCn7UoHmzmMh5joLwgXM6lWVg1IRJzk
	1OL9cnQed
X-Received: by 2002:a05:600c:4f0b:b0:47a:935f:61a0 with SMTP id
 5b1f17b1804b1-48370cc979bmr3868275e9.0.1770923764039; Thu, 12 Feb 2026
 11:16:04 -0800 (PST)
MIME-Version: 1.0
References: <20260206093410.160622-1-harry.yoo@oracle.com> <20260206093410.160622-8-harry.yoo@oracle.com>
In-Reply-To: <20260206093410.160622-8-harry.yoo@oracle.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 12 Feb 2026 11:15:52 -0800
X-Gm-Features: AZwV_QheBogDYj3hjqCT8mZg95VywPTWK4lWyWbkX01r20D5GbhYKN4gZGkX0C8
Message-ID: <CAADnVQKRVD5ZSnEKbZZU7w86gHbGHUug2pvzpgZTngNS+fg4rw@mail.gmail.com>
Subject: Re: [RFC PATCH 7/7] mm/slab: make kfree_rcu_nolock() work with sheaves
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Puranjay Mohan <puranjay@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, "Paul E . McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org, linux-mm <linux-mm@kvack.org>, 
	bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: D2906A000F
X-Rspamd-Server: rspam07
X-Stat-Signature: ds75ajnw4gzsj579yo91w7uzf17gepan
X-HE-Tag: 1770923765-824843
X-HE-Meta: U2FsdGVkX1/k+GZhMVoeWskylq9CcTMXOMtgRHpKpqj/rjivP9yHG1+9VGmrn0XvYnyps8pcB5HDKd8bl8NhSdULf8l++zU1bIWvno2n/6DlCtf4zqfubAtIBGKe084vxqptclK82T8hkoWc8SsTUtr2k7BfWoXouCGuyihL5buGuB35fIPRHT16aqlqHWAXOuPQwgS1cFXLRBlDIr3La6I9/Lm/m2JInDDEQtt7MAYtJPZSOLMaqQKZl2EnsP2PIA5h24+1NB434wxlfRmUUufJZ/E4cRDBnWj0IDdtw8R2JNhcyjUWvkRoVu284WVDTquCWT3vgu2Qk6+eyvQvpbo4Nm9QdDJ6NGH7orth7lZBi9+t7h2ZEkawlU2BVnkuGIYdJ5Jvmba1zAjeUbfzv77O3aBcNBmMkSapFfNed5xneU+TutldATt7h2tQyqwpOZZGVpKIoc2hH044FRnuSwA4KaqDj/3a44e0MXFQ3lwNXdZ8t28TNyPKeKAIss+DjLWcyVg90s/QSqrrIAqOtvWQPN85SfqYTqwMRPRrWxmddv34wjmJv9ulBgYiUIMOIeIFLLaPzlCOO7rcGHCo1TRyhgr1OL6y5TcgL5Vl6JJy9un46fdggmsEuXWJHEeKG1k4OpXyNjq1OBm0xYUR4HONGk17m5u/FPaSYBOMWcliLK60uP4lWX7u6CfaILYQNtTyah/bhqtsGeyJGh/MNYXD16yQRKZn5F8DU3nCBp3nruOBth7xLkzd6Mexz2nFDQfXTL0lcIYgkp4ceY0ZWdKfUCtVtQnPBvDfnhinLqvGfbXX9pWLDu92eosjDAEL1k0ZQpFGFNZ0++2QS1OsFgoHucRsAmvIETP6jgLw5T1y75hux+aiFE/mRJfFzLDie3okVP+AoTD3UIIxwqbeIa6MflAgRuSev+Yiq6b2nPVLRDa9bjgU0OdEqoY9D7pGUCCLaZ9i0ozO31NvcuG
 HcWEOwoe
 3p5oGXB9O3J/rG94SV81V2pNrSEH1k9SkkAO5NhFrR5sygwgceKJXNGU+gt2p8tiXKUM5IG0UmZxAGbzH4qCVg5x9ooFf5KJ3TL5Dkp+LXrpapnTjEaSRZiYxr8seT0NWGPxC8y1tnqut7fQcY0sg3gvkNDodP+GVfRa9PX1VWNVRTKTPHZEH8dUnx9lhkb4+uQESitHwBJw7eKCXun+P6Gz0ch4oFCLBqj9NZnSDVmlingk9q1bvV+IAiN8Tc3lFeSn4cymXPlWVpeUtxJhoW2o4V929K0KLA4FJnXKlv0hZe/rKeUQMcw/VDxahBtAE5yUmLfYjTVoR9UTFuJDTEgxdEQGIFuNHPLo87mvVm7Mh9sk4kjSNuCNg6z0ex60Q+1PgUw0D3V6t0qqlNUuqAaXUfQi8Ki0SPMy3V+u6K/vo1UCCy2syTqOip5es2sErjYOrJR1RAOsN6o6XNWs4eJ3sGPhSnzf4j8jnnDE/gG5N5OZZK3VK3mP3F60jVyQkeqw/+MuswoQpyTbt234Hj2kR3IEmGsVzk6fK0KnfpUNXdhKVgIv7EDbe7w4z9rGANnjY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 6, 2026 at 1:35=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wro=
te:
>
>         } else {
> +               if (unlikely(!allow_spin)) {
> +                       /* call_rcu() does not support NMI context */
> +                       rcu_sheaf->size--;
> +                       local_unlock(&s->cpu_sheaves->lock);
> +                       goto fail;

As a first step it's ok, but we need to make call_rcu() work too.
Shouldn't be too hard. It protects itself with local_irq_save,
so if (irqs_disabled()) defer to irq_work and call_rcu there
or guard reentrance into __call_rcu_common() with per-cpu busy counter.
rcu_head can be reused to form list of objects to be processed in irq work.

