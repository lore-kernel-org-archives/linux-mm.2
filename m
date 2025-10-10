Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20B3BCCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 18:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A858E002A; Fri, 10 Oct 2025 14:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341EA8E000A; Fri, 10 Oct 2025 14:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2313E8E002A; Fri, 10 Oct 2025 14:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 083388E000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:53:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6C68C01D0
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:53:36 +0000 (UTC)
X-FDA: 83983103232.08.3ED057C
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id BF57840010
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:53:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uqhE9McU;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760122414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yvk9+2uf5Jy110s1EexKEDqunnlIUh4JFbrOdrqUH1o=;
	b=Kv4gSHABi89uMLnMJKBcdjgaToYPFOuseb3YCDvRs9LkVvgHdFWBJ+PcGmdrumiGjjqXpD
	AXtVi1DSAF/stf9ZRPdqlMu5NoF/hLBPe7wuXjmJu4GQjaKmkZcOD/kX1ok7od9yyUEw8j
	RTdSg/m3k0NTWMVoASZlRrOWhSZ/qV8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760122414; a=rsa-sha256;
	cv=none;
	b=4DBLmlKBYqKxHx9Pw97TIK2tYHq3Hqmy3CKUTPNxr9PSxuYuhNMMg2udHAlRvLRDuOgfQM
	PM1JmcHSEvKaUJeDwB7F9qwRogANZFoP4LoTLZpP+YJTv+grnto85DPlv15eor3eO9kzgx
	xCmfirzf4X8/csmNXPVFnfKRB6AbKJY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uqhE9McU;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-85ed0a1b35dso211088885a.2
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760122414; x=1760727214; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yvk9+2uf5Jy110s1EexKEDqunnlIUh4JFbrOdrqUH1o=;
        b=uqhE9McUG199E+pEHnPY92jKHAHEFZqogqbAQosAyMZY5ZWxRr6QLFlE3nwDSqhDdT
         FplbFjGyL8yllpe/CgzhWgs2RFCkdr/Mm9hiadeOw0fUy+qNjfrhXWSvCjsOpYOm3aku
         LDreAFIhPekRvYrrx+fuwOJAyR+DYzDd7YiA9UBUHBU0uxpGJIjaWqLZ6jlWEOKYVyzq
         kS/IliN248rXqtg/wi84cA41KXgs71yypr1EABaoe4yrUwBgMfpBh3oNxzp/uO7gE4t+
         8g9oKU1VKTH061MP6e/cEHcSzR/lpG3fxgzoGbNQVfHhFzKHL8L0uHQX004bFa8+yaPP
         8QyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760122414; x=1760727214;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yvk9+2uf5Jy110s1EexKEDqunnlIUh4JFbrOdrqUH1o=;
        b=jmCQIOfa/dmCch1kx2NJzK8ZFk6iNSlL+n9z4ORl76f8Af0F4TTrwX05tptSQs6D61
         oJGg1Di6jYZXXCNLp29KEnZa8jsEpNIxk1RJZQukpZIzhJV7JrDz3Wgj3LZx5Ga2Xd7F
         1FMBBE5ewjlbeAgh0r3KykChIfP1GQmKw8Nq1OAyYdRUqHHSFVLpCmgotFB81xmqdJ7j
         vwBnJgAeDB07d3XyZ+4sb2YVdR6vcwCBROwtwfB59oOTD++QO+B5l7LTpx08PiP0vltp
         UbmqqeY7sRZ+Fbqo/TNgWtc0e3kgKM2zmam40eP59BrO5tUNImJfMElmznwvLZnoPf8s
         XoQA==
X-Forwarded-Encrypted: i=1; AJvYcCWZ4S9Cu4FgVNUi26qw94m5ADAQ4V7iX0z/VRVB8ns7M4bH69YJzXCxaicgdCqnYp15U2x61e2Ixw==@kvack.org
X-Gm-Message-State: AOJu0YzjLJquEwz4XMdNM7K81UFCxkL8/IPpRM51wMx1V8pNPyEpERSC
	OsmCwJ8WQuyAmRUtlTAfuuN8wlcXqNd2DMy/P2+frNFvUvBwkO1egVdGYUbSea9v8TM=
X-Gm-Gg: ASbGncuIqZTKQtCOEDHF2lJ5ilUQRrZWXJQs0F+5BkQBzD13w1GGUn9Dx1OyIZUOWUU
	RLrflcEb7K10wSTSBJXw7TCYn5Dm0VKjusuchm2QMM6pG39hYQD9q3StDTam2INc5Vk44RFCgeg
	xiL5sV0kybNl2/lzcqQ5Xs80wU6nwfXrPIigXfuktkSISZY3KvATHx2ZF3TY1qfgdH56HgV9u30
	TH+kBJ2Ea5yxZa0gFfnpvPzoM6iSqu3Hx5AoHBWU5npkrguVurriJO2Y4nah9GjJcslhCom+6nf
	rzF24KM+GMLfKWjTsaDCjAn/ZdNevk0iEXoHAS+K4IMD6/XlUGwCqcDQ3+c95HPCQAoVWuqYKYZ
	uDceHYaAwHGi67ApZBaCSr5WzQrU1RvgaJLo2yoB4QhtoigcGGHcubwCHSzp0gIjEh/6PFNT/+m
	isplM3ESRItql+8cPDXE10LeTleXIyg9AsTT8=
X-Google-Smtp-Source: AGHT+IFw83apThwu3Bu6mVESZP4W93bdkR0fqUQg02zKaUQROrWdoFXC8bV8nX7m1XqGZM4W610+FA==
X-Received: by 2002:a05:620a:179f:b0:849:21b9:478f with SMTP id af79cd13be357-883534624f4mr1914757385a.35.1760122413577;
        Fri, 10 Oct 2025 11:53:33 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8849f9ae48fsm459499385a.24.2025.10.10.11.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 11:53:32 -0700 (PDT)
Date: Fri, 10 Oct 2025 14:53:30 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, corbet@lwn.net,
	muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
	hannes@cmpxchg.org, laoar.shao@gmail.com, brauner@kernel.org,
	mclapinski@google.com, joel.granados@kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mel Gorman <mgorman@suse.de>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
Message-ID: <aOlWKqyN5P_kaoHc@gourry-fedora-PF4VCD3F>
References: <aOZ8PPWMchRN_t5-@tiehlicka>
 <271f9af4-695c-4aa5-9249-2d21ad3db76e@redhat.com>
 <aOaCAG6e5a7BDUxK@tiehlicka>
 <83e33641-8c42-4341-8e6e-5c75d00f93b9@redhat.com>
 <aOaR2gXBX_bOpG61@gourry-fedora-PF4VCD3F>
 <aOdSvriKRoCR5IUs@tiehlicka>
 <aOfU9YTKMPWzYOta@gourry-fedora-PF4VCD3F>
 <ac0393c7-9c0c-4b4d-8b35-5e6369e5431b@redhat.com>
 <aOgpz6no2Jx2-Y8Z@gourry-fedora-PF4VCD3F>
 <1d7476e6-5c6d-4175-b28d-3622222ea8e6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d7476e6-5c6d-4175-b28d-3622222ea8e6@redhat.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: 1w83ipedr71g576s5nx7aet46848b8xc
X-Rspam-User: 
X-Rspamd-Queue-Id: BF57840010
X-HE-Tag: 1760122414-558118
X-HE-Meta: U2FsdGVkX1+XUhxuVbuW3whiCBFF8eOmppLFyNN4jOHuftTevOhZwQKfjyX29L46m3yjbxHS/xEZsVF0m4GzF9UcESr2bhHdF6DXwde5MODyp9ZLx8hQdnmCtCMJ6wJwu4kerucUek6CjtXj0FITXJS3mejGj0B5BEsm3F/+44kQPh9YDIP93SGNfss7sUG0m69Fsu3ooHv3o0paPa9aEMOzeNUp3Ryz4fJx5opx5/UqASaWA7ih+xeEpUMenK+hfb4GQf9IfDgarfwWkTWU9V4QtKYAg2EAV0UycGlM61sCJ01ULZ1lIT/xHXTjAmE4VMxnrsvjbacuJ6OK/6wmB4xuuT68Xgr2d9Vo1Qc0GetH9lxKR+lgJDqcqRY63fuAeyMihY0Hvy9i8hePJo8JCuJKt/4zjCs7iddS0mbnnAcsjAQi+k3hN7WsJtbQlNVdw009Jja9Jfc50JSPSM3ClL4bZIC/I4nYMduWR5mrOCvUPOcz0aXssHIfWneu3NvWQsiC9wu2oEkX6RYbUakL9cRK86O1PATlolqbuJbsYNmLu4fQIIxLWDwY+PKbro4bEe3JbCR5ER+wWvJv7GvZRh9+94kHgaaR2KfECeLJLFojzwq7gjQdtCwufPawDRfHQFGFKLSmSbxGpjta9PwtcApsJivtXteQL2FgQvcpH2T1wZcIsI3VbsvXBSBq3YVTt8GwEOguWzi95DG40ZZ2PyKpXK11qnnK88wjmVeevhOTrAR5VPrPImTe3BHTWrd8vhKZqiQdazb3ItoWVBwvFF/gk/m7UeugJDIsVWcSeAh2KwMS4OcN8tylgNWTfElOJte7yD5lXFrvWDHEDteECuUuZppF9famm0/JFIipkd45NawmfoasmPL790sorvcp1VQwtrpkXgNRNJeMe8uz83zKudvwpRah6odjMOkNjQK4dL7eX1bDRhl+l8EAWWFNX7JQzrIzPCz50D0LSk5
 P88nGMFU
 hrhWDilnXy4JgUfrKxqHFRFq+NSHxvmC0uBf6zjA3iwnCnw9NlYoBv8yK3VctUDxlYh3Ru4wlWBPKrCilaSduFzvDH/luklkDerdN4vZgsno2WJbc5Ny5FtRApjsZbrTJbJfXd/ArOn3fNqFpbKHlTTvNRjQdUxRdT6sluRxf08gIEDyy7w3yDiXtkrcJRYOl651cHfS9Ltvvjxel2Lpr43uMrNI3qztJUip7Jer9+MP4gnNWyiYx9+tvdMFrOzpXUpZ0Z6N6ezlb0TzuMKk6ffr+UVkstXMj18LpaN/UvaeY5yHQMhAtEaLyuNJ08ZTv40QnDh2ndTbodAdiXGQ0KOpyw5SKKQXUqV7JiEzAy9eZg75sLP82PgkfzesnCpq4RDJRLsmyuuc9csc1ukHJ3aGoniNoZzetOHtYFtdJTbQ72F6Zj65E6WMPcaLaUDeeqmwppUOQ67O/3VZCI3r9E/ARYDhuDfp2GFrGqyyObhlhtYjBrNMkItk7NM/TqXrYbvPAH1UrfpWQkrm1MkZUTkuE6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 09:40:29AM +0200, David Hildenbrand wrote:
> > 
> > Seems like this is pretty stable tbh.  Obviously if you hack off the
> > node0 hugepages migration fails - but I feel like you're signing up for
> > that when you turn the bit on.
> 
> Right, just needs to be documented thoroughly IMHO.
> 

happy to make any doc adjustments.

Better to move any notes every here though:

https://lore.kernel.org/linux-mm/20251009161515.422292-1-gourry@gourry.net/T/#u

---

Maybe worth finding some time at plumbers to discuss block-level
allocation twiddly bits.  Still not quite clear how this would pan
out.  Maybe it's as simple as adding GFP flags to blocks and having
something like:

echo NO_KERNEL > sys/bus/node/devices/node0/memory1234/eligibility
echo PINNABLE > sys/bus/node/devices/node0/memory1234/eligibility

folio_to_block(folio)->eligible(gfp)

The issue here is obviously that it's clearly racey, in that a bit
twiddle can change the eligibility mid-allocation.  

I'll think a bit more about this.

~Gregory

