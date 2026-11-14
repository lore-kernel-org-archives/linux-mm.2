Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9B54606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=d3BcPLP5
Received: by kanga.kvack.org (Postfix)
	id C11176B00EF; Sat, 14 Nov 2026 15:33:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1A86B05B0; Sat, 14 Nov 2026 15:33:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB1666B05B1; Sat, 14 Nov 2026 15:33:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 84F0D6B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:33:49 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F37E3C047C
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:33:48 +0000 (UTC)
X-FDA: 85434875736.28.86E1C56
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 198A0C0007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:33:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=d3BcPLP5;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794688427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mUNTxU6y4TEUEh2QskFJN7r1v0olPGCGxnMzFiH63eA=;
	b=6MYO17MVyCyjkypqFQb9LHlic7pYPKEJsE2UyNKEADO8R8tmJ2zl6W7Gwa2siSkB9FgRm7
	OrukMciEB6LtyT74PNPwfYfjuQVBxBUMAnscheVK0cbp4MGtQH5TlK/d3W7hjDf9V/oL1m
	Bp4FZ3+KCEF0QxauPxTn0vENdeA+emI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=d3BcPLP5;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794688427;
	b=K9zQT3k3NPTpS65uhvEw4DSk8YllUTj6Gk5i+8BP7F2V6X3fESon3D8+3bcH4+kSsTDTCt
	UGArw5beg/rgKiP03gRf1ya6rY27GYIw0ctvODcf/MJVmsk9bA2OE/l3xxZbvJAm/0kFQD
	XwIcmvf7CmKrR/l3xp8AKTPk8cC217o=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-91ef011e338so33329066d6.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794688426; x=1795293226; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mUNTxU6y4TEUEh2QskFJN7r1v0olPGCGxnMzFiH63eA=;
        b=d3BcPLP5p3ZN+32sAr1Y16K124d9odqm9O0fZj7ZoAB8VoBoMy9qQ0BC42YFqnUP+Z
         hh8I2ZYQJmwcZncFjTXmZ6YxFn/ViQjDvJTRWhD1zbyOwZvYlPdhKBgbZ9hneE6sUCfZ
         Sho62UKSM8wst2DuArj+F9YkiQZ7Jy9Z3yyKQ3D+AvrYOjF+G/XkZ/itzzU9O5pOGMdD
         lczCzAGbdQz+L/8Rsq9DIf1FUpjQeNE2LDUfGsFSePuZk1Jz1abMUSHODi4lYS9n6Icr
         SDoRnMFeTz6ljQLbB0q3R36oT4rOyhrA5YOTwZzXkOoFHOpj96iBDpWUPXozopW85R+6
         Ta2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794688426; x=1795293226;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mUNTxU6y4TEUEh2QskFJN7r1v0olPGCGxnMzFiH63eA=;
        b=aQhf2fed79+jJ5PRmWxiVaB0XWDW7CueVA9REiNBU61yUOxJaWSRmOw77s05udAbyd
         /O05N8Bawo+pbF2rYuGGjywxDB9FpOjyBcP+500uQDwFOnab3WbFrhs/GLxoPwiKsENL
         /oj7Kkbn0CDRLQh8iebNyPTbERVzYPVpBqXVWr0gRSlB+1CuxMnnM9uLfDMVTnfwiLAQ
         IgUBgO10NNJ1TI20Tar1GrEQm7qDgAi/oVv35Z/JPgkYKpoJGJknNmbZpyUsNYLXpfgd
         9YF7gIDNXCEjAX7dHgitlSRpAioFfVaJtu3nWWKhDsHPkUkdhoEeXK9D96aVeJ+6w2Ci
         JWyA==
X-Forwarded-Encrypted: i=1; AL+hErEsx2QyKsxmr+fRr+Foj6qcW8Gt2TTgkqvXUTK7TBsoMPyYgWPxLy+KpLtZuOXBytAvSbCAtFA6fQ==@kvack.org
X-Gm-Message-State: APuU4Z82c2tNZp6leM3LLwVK57vehQub+VGsu4jELTn9/LVeJjWHoYkT
	GHXWPIDEPeJOBQjjdZUso2aaRVbmgWqbMOgVqXpYcakqPy6CcsewgAzrVyxF7wTW+Gk=
X-Gm-Gg: AYBFou34XCmOOf8ce+P+m5yWbWImlGkS1C9Hixm9mh/7LgVE7+AVe44cWvF+omihSSs
	Z27xDQcSTIhRfoYExe8McegR/mApQ2KimWqO0IfWstQT5wSGuX7kZ66/Jis0kmuHyCV7P7gbumQ
	+AYKVEjF/JhNf1gch94nT43UMm39sbb60uUPGDit0bXnsekZCWstevCrcPV5cp6a0iMdxpAJx1E
	s7m3dU9ZbZN27eF/fz9388kcZp+r3pHCaZa6jTL7fJSLlb+OfGyz69eMGRPea/e6Wq3kETs5w7z
	XmZTpnnG0Vkilwmm8biupIt+CEWm5LG1rA3oaE0gvS20O6/+G1mpLUas8G8mYrUfo4ymM1HxtaX
	o+ZwrzJF5sUTUarW57iSdM+e0IixG7raL3LD/nhkAYpCGUQ9ZYOtCDMbi0+gWxNlNTc4QAIXbUP
	vFBv7d4wxOSOAHl+wIE9+DlbaRrn9iuAfLsKzpKrGhiM5jUqoYUFCgAuhIHT/ADQ66/yVUfR9ht
	jNxLYdhDlYu9+N+EEjVcB5RZ0Iwp9QXkeMMaqC4EVUx+R0ANds1n2+BtOQ14Fpf0zj9O4rOYksq
	yPyLGYSDnB5ZPVyQgruUv4f0egergAJnARn6WH/d/9jKd0qffc87QBzo14GkWyh0jOjje+BeKD5
	YPU/5iRw=
X-Received: by 2002:a05:6214:5291:b0:919:7384:99a6 with SMTP id 6a1803df08f44-91f24246723mr103621956d6.41.1794688426276;
        Sat, 14 Nov 2026 12:33:46 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d954e1sm49818366d6.33.2026.11.14.12.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:33:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] mm/migrate: fix softlockup in do_pages_move() with
 huge page arrays
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: shao.mingyin@zte.com.cn, akpm@linux-foundation.org, david@kernel.org, 
 linux-mm@kvack.org, ziy@nvidia.com, matthew.brost@intel.com, 
 joshua.hahnjy@gmail.com, byungchul@sk.com, gourry@gourry.net, 
 ying.huang@linux.alibaba.com, apopple@nvidia.com, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <avifKRgR0Q4WPUNR@gremlin>
References: <20261108142831046W_fbNCAFfuY0BjHPCCHgi@zte.com.cn>
 <avifKRgR0Q4WPUNR@gremlin>
Date: Sat, 14 Nov 2026 15:33:45 -0500
Message-Id: <179468842502.482102.17860580592179578567.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: 7mahsoqn3st4m4mbpraza8zjkxidmnmn
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 198A0C0007
X-HE-Tag: 1794688426-662017
X-HE-Meta: U2FsdGVkX1/P0q7VZemftULZinkAF62ot1n+gXEOSJ130hw65EivSOZmljVsUsEbIuYnKHl6ET8xDGwqWuV66p829KE7rHLnz8J3SK04xheFtJcLHkYFKJ7qWMwXHAkCx0u03mImtRiaeKg5R1ng1HIsmPLLvEPIzCfgrrAdgfIUADpF+VckCOghdF+v6HxLCghede2chtH8Rp2J/CY4u8Qf55GQGddtt2pQ50VMwGu+UU5+AvoWrEgn26oMqptYZJlRB2ihtjqvLGmgzMdMuVvd4ZQxd8XwkjIhR4AGtMS+5sdIXUpG9a8skmxvc9oxC0dJX93+OjatA8R5Xc5fFOiwpAXVBh9oYxs3uyu+CbF21tBYfGnZNY3sWiezxNGhf3OwKfd89THMP/+18A+g6VOLPifmUIgt6sKtIauY2JjeI2w9jzk80wyr9eI47UeJur+ci48EigyRAfHb3SE4+2qgU+5h8Nemk/+Rh1cktrdIBaalqWPbQm6xXnQ0PAfDBmUvcr8xnkexsQ727JUYy/cKrtit9u2yffcPWf5Ti9fv7MR1hoZHLcOw+oX6Xma7zY6gcKebrejMXGNLS4P/H8fUg44TLsSO8gaLrQPq0tjWGTZxrOcN8sNZulLPEIDa7fPGzjd4aPSa8VkvvZRV4RMnopHkT8O+YeqsbK0I/2zgmDhGU8luJrxv0jzpowHO6H7peGXwPxqxJYfyWryHZzeR1kagQr2gM6cQFQd9OVZFOlytvgHgrqoAsyKAK38EvzxXYVBrdH81mjTof3HiyKkSHL4SYFflfbuJsfhZYjqiKDAJKhHC6Yl2BMB6AX7YUAUOeU8WqZU5hBHfYStIkAtebfCay0c8284q8Lp6M/DJgWxO+w/0Njh2QttSACmsjg5labkoA/OUnwmhk8NBwLY9RV1KaJjr81QT3ea183PN1cHXQr//PB9fji3T0xgEafRnLAB8H7PTYMQ6aKr
 0+cpZtZ5
 M0gSyXFZ29k6upxZPkRkZuT6c+1/ADeMrN6864cnhmZCmGPJH0WF5OS2V2QojR+6f+umkCuU0MY6zANMuHswoHFvFk6XxD3X2NrDbtUEI/2oUmLR0l3xF1a1af68k3ddGNvnr8QdnTHHpZALbrwtaSDza2feoNEFl0Cfx/YV3/DnxIzgA/oEG2VYAYlnuCHiy8V+gcUJANpIfauQ28CLtPv+PDGIxfeDL1ahJWS2SivfHny/XNwjZn0uUzPZV/8A39oyeuCeRutAkFBMOOKSkbeG0+N0PiqfIvICJYRrxbW763dq7UDNatkpnLuIoH1R1WbbmSXaYUVj3PQISI+qcLrxW6NMFiBL/rcoRgyj1C640qy7a0MZATMB/5faXN3AxG4+n/feTf801e4ViKBKurRJ25qYQIfR/vtdEGYffi5SuiZPkmesBA0645L8t3B3yG7G8HNLZJgfOGZ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-14 17:51 +0000, Lorenzo Stoakes (ARM) wrote:
> On Sun, Nov 08, 2026 at 02:28:31PM +0800, shao.mingyin@zte.com.cn wrote:
> > From: Shao Mingyin <shao.mingyin@zte.com.cn>
> >
> > do_pages_stat() had the same problem; it was fixed by 8e934ab44389.  In
> > current mainline only alpha, hexagon and classic m68k can select
> > PREEMPT_NONE and they cannot enable CONFIG_NUMA, so this mainly targets
> > pre-v7.0 stable kernels.
> >
> > Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
> 
> NAK.
...
> And absolutely not to this person/script doing backports, thanks.

Have to agree here.  This is just creating backport busywork.

This might matter if we intended to do automated cross-arch testing
on QEMU TCG on these platforms... on those LTS kernels... but also
mehhhhhh

Yeah we shouldn't encourage this kind of patch spew.

-- 
~Gregory


