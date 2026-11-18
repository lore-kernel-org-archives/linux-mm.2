Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1479D606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 03:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ayXUbKYv
Received: by kanga.kvack.org (Postfix)
	id 1D9EE6B05B0; Tue, 17 Nov 2026 22:35:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18B826B05B2; Tue, 17 Nov 2026 22:35:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055D56B05B3; Tue, 17 Nov 2026 22:35:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D756F6B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:35:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A5D5140603
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:35:48 +0000 (UTC)
X-FDA: 85446825576.05.30ECF08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C8D71100002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:35:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ayXUbKYv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794972946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7/n42KyXg5q/rOBLOd1rb9kpcERHhPizyXCV+vNOew=;
	b=mD6K8Izw6aLBqpc9KCmCU+IhBSLqor7N5lG+GnpguHpbQWY47F2HTfWbg7cGdI3ZiCrYOb
	k/4kQYuIN7ISep0rle+r4SNzuZhG80eRiTllKdfFQJrdOy59ec+DSkHn3Ve34/OFqUHKJq
	00Jj10ac3l2riw601J3NUup9b11v6f4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ayXUbKYv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794972946;
	b=Tkg4zY9pytz/ie+CBH1kbHPT0rv+NEbjkDE5QGtPAbnBGet+yZW1Q103jo2wESDCixQLsH
	yMCv27cyfsKx9ADWSxyUkrx2BaZrkCOPMGGfSVPUsMGO6UIrSEnm0moKL6ywVPAnqx33+I
	AAPB20Lr57qyg0KhxEnmirmVbASCz00=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 210F760D29;
	Wed, 18 Nov 2026 03:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CB31F000C4;
	Wed, 18 Nov 2026 03:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794972945;
	bh=+7/n42KyXg5q/rOBLOd1rb9kpcERHhPizyXCV+vNOew=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=ayXUbKYvov/6b7QYSb9hRgYh8PtUWaFSc+844sQcDselrEd5exQDL87/sBG2IwRNO
	 FpqtxofSxtxMKbhWyEAeUL7v66hjSQQa1RG0+GezXIwZveyf54SRHe3ZSidkOL8iZw
	 F0lXTbzwP2vkXGHzc7zQUyfG72BrgH6eakIvKKD8+f0nYZJ2KXL508tTuqaCNG7TRp
	 vmFS8c5gayk9+NHihWEa0Kfdv3GKJR1HrEFmd3EiZm7mYWxNNx3PezcTRsnTRrIgBf
	 bVH6iXBxNj10AW+McH0nttridsiCH54mbhkdQrh5a56Dzstx6eVXjgH/SJ0vLuDkzz
	 FI0WWFxH20quw==
Date: Tue, 17 Nov 2026 20:35:42 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
cc: linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
    linux-mm@kvack.org, Paul Walmsley <pjw@kernel.org>, 
    Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
    Alexandre Ghiti <alex@ghiti.fr>, Conor Dooley <conor.dooley@microchip.com>, 
    Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh@kernel.org>, 
    Mike Rapoport <rppt@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] riscv: mm: reserve the DTB before scanning reserved
 memory
In-Reply-To: <20261104104604.3370384-1-m.szyprowski@samsung.com>
Message-ID: <3e5a01c1-1d91-8bc0-0589-0621930c2d18@kernel.org>
References: <CGME20261104104615eucas1p2583cd5bc9ae36bd9ff2d28f87d6e7583@eucas1p2.samsung.com> <20261104104604.3370384-1-m.szyprowski@samsung.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 8fcsgu4bq57o1xienc1yg1rkqahskbn4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C8D71100002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794972946-411812
X-HE-Meta: U2FsdGVkX1+xSVwlrYv3mUNUnC+Xb3yLngD+Ugk3s9VYtYKYxvh4qv9Zc9rk4ytnaq4mvsS4Qexl7l8EGQaRFF3tJC/06shXzwOUEPuNAUYNtAkqWTsdess13kMfE0AQT4yW4eg/QBv5nfwFXPrSzYbFnWEm/aAFqaWjwVF8tbK6M8FKpEDXv+pPwXs3IkkdC3G1Se2G9c0c8YuK4oM9tvHyIZmVSsOpcdzyaY8PBOIZXM4kwmTWmKt+xhx7Gi06zc9Wlrqm18qjbrfFzjhsggkNpkuSTrKUQY/3PMv4qLCFUsNH/xFnd1qvGeOXPbF69951/OVUL4llI6SZ26o8rrUtH0jaecWYrc6EtKgOvX9tKgKv+uUekAMP7W73wzyHdKBLdcNoRQWdvjdxPvvqEim5AjP6kN+j3V12D6yDu/6XdTmMIxCubFLYMpZbKTJ9fdyUUtTd5X0mka/G2XZEMmvSgnYUcIDmmyLNmsceltXT1qUE+kuPRhwdcu9lAtDIpYUEOIq+C3TaWZzmctEj9m5KVSAwM+9Y7uByxbQTaAW5D7SYppFtCAHAi5rIkeX7rBuxg+KwkQW3S1ixZidJ8d3T/wi1jkDSKdbw2jxdNXDwx3vJ64CdOa+Qre3ecAij3nav0MHTfD/kY4xIBskJTF6ueuxKQvotIrtvz89DdXhQNyww5YALdaZKNhGLPr3PsiSgJD6YWcKLeLS7WmMrqG5CiX4pkp4ra9FTfcQCWHYiTmYNzbY0/YeOgwf3MtD9IpwWn7QLWZ9J7R2oMQxgrWA6UG98oOUixvGe1npmsabL3IVT22EPCZKn+pCO0QPLdcXbr2AzilZ32PQpLRYUKpIYIPD3VbFRU6AjmaXlRLndJH0CvZb3u7NTGA7u5p4aAsULUpzPMp3cgHCobsO3obwBqgiaxRxLTGZ/sFmrZDICavZYbGDFgi3ES2/Rzr+Hp8cQMVyDFqiWMPbbS1Y
 RUtXROni
 F2/iRBYmcUfwi2JU+tKyvd8IIXY3OkfH01u3enl+NjGoE/44RoUxiKAiQJnFgj6bEAnwGgal5HKaFkZQ6z0Ee1TjTiJFoJjpm3e/AOXI1bAsz7aIUynelyShpurPXMLyUwbZhHPHBXJwNSZDiS8AsvLVywcHurEIvJZnS1RWLX3nL5EkRR0pFxI55oG1q5VGcECzGQeVIyEQ11/YNgbWenpuZfVaNoUUXE19px0k4akwmRzukenr+9otK+kaQh9nXfBR3BZafX9LIjVfSacoMNT8aUdTMyVkQ7/aFkvthNukMxSI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 4 Nov 2026, Marek Szyprowski wrote:

> early_init_fdt_scan_reserved_mem() allocates memory from memblock while
> it scans /reserved-memory: the reserved_mem array, and the regions that
> are placed dynamically by size. On RISC-V the DTB was only reserved
> after that scan, so memblock could hand out the memory the DTB occupies
> while the DTB was still being parsed.
> 
> Reserve the DTB before the scan, so that memblock never allocates from
> it.
> 
> Fixes: ef69d2559fe9 ("riscv: Move early dtb mapping into the fixmap region")
> Closes: https://lore.kernel.org/all/b71ac175-fba5-4f61-bbdb-0b98dec9ccee@samsung.com/
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Thanks, queued for v7.4-rc with a stable@ cc.


- Paul

