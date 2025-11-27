Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2919BD1118D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 01:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F7436B000E; Wed, 26 Nov 2025 20:15:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CED76B0010; Wed, 26 Nov 2025 20:15:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4E66B0012; Wed, 26 Nov 2025 20:15:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5976B000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 20:15:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D38595971D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 01:15:50 +0000 (UTC)
X-FDA: 84154620060.04.4F87657
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id DEDEB180019
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 01:15:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JhyC0n+O;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764206148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W4p1bn22G2i0XoJzrL7o1dUUJ8ghtmPDbFaXYxRwFkI=;
	b=Jg2AeJB+Es4Jwr+baxC66swvQWzIhbTWxrrm8dd9eJGmzB12sIQMczU3HC1Jg6rmxSWNQ4
	HYnwtfrXixAD++Entf1e17ivXI8ovQOrFKGXL9FvPp7IXH7V26lb/HBq5G3Mx+azPhNKQU
	xQrtlpTFMWMgDRE23u1uSw2cRiSTwqM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JhyC0n+O;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764206148; a=rsa-sha256;
	cv=none;
	b=xJyOx69XAddiqiSZ4YF1AS6pVWbr/gAfjY3GmB6o+E7Yn+/WAAdPCDgWuAeLCMi+v05umD
	lAIlNBf8/0UG2kNWCqzQ5se87FhkDPyXF64yIIpfJ/EzEh2OKGNvBwCZJkcIfSPGarc6/T
	apgmXu5S6L8KAudvZFepAyp1oPzxFBs=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7bab7c997eeso357783b3a.0
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764206148; x=1764810948; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W4p1bn22G2i0XoJzrL7o1dUUJ8ghtmPDbFaXYxRwFkI=;
        b=JhyC0n+OVt1xdb1lvEwH+LuAhNwUrkJ0SC3ENxQS7klePxRvVUhgWeou8sUAEZATmd
         5iG6NC9nSpOpGSvTVCLJ5339vfNm/sYi6A1fojKBk1T6qs6jcUaFHnCYeiWX9BXOJIHh
         fIfoxOm4HwOCOMswScs3MxlJ4ynjjd7Ai+5S4kpOgzunKLUjBoiYokJCdUPIwtm3/BbO
         SLOAC7cKKdEmYGFzX1kRrT8zhZcT5r0eYaSuZIIPQ73Gk3lPl0Dmbz3Dn74+k1qGEon0
         DyTdYTJRoX3hjnLXrEaW7nSoARkeXBAbPaIdRCL/38L2LcK3GJAF/vfi795G45VHDvDr
         1x7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764206148; x=1764810948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W4p1bn22G2i0XoJzrL7o1dUUJ8ghtmPDbFaXYxRwFkI=;
        b=ct+hihA4Ng1IuKkkzW1VF4RYJcZ2TfVdNoxrs5b2Co4+rchFKDYZCsdVwF3UhzriVS
         B7HnpWrnZpqLQHgostpg7bZCZdVHCklzbg7Z8pwLrQ4z7gc3m+NFV9TMCc82U3GuiBkR
         EhtKI98gaNX0Kd9S+A5PG9LLnhs0tBwY0X0S5L/bjtS139TjehW+lDv/CvLx6fVyQqaG
         tZRFYm77w4rBjl2ANbG+YJkhy7lnxUICKu61UzQCYtNC07ujrozjc8n1QyB8K4WHmI1g
         Hv/MF/bkIx4Q6R4SEcdSzWx/Sw4E+44nkVmhI8iaYZPiq2R4RfUtXoBdlJTsbXwpQYOM
         6i6A==
X-Forwarded-Encrypted: i=1; AJvYcCX6QwVMPtp0o8LFbxDsu9yrxuM2rIuKfxLGMT0PBWy4ad65LrxMtgViA5R8FmY9INXefZVEdEr7aA==@kvack.org
X-Gm-Message-State: AOJu0YwRyLetOgjm0ICLxg8v9ehUWks6wz+KTsHgfq6rAuNUrytBGY1G
	REkfxMzXBpVuby8/wSYyELYCjJnElgxQkoywzII+55GCr76EJJjaSi7z
X-Gm-Gg: ASbGnct7G6RG9dXBC5PpyQhP08687T5+2FkERPAcsZFDwGbtuR2Ry4GjnOGtDYALYii
	xQkjcKWbP3XeL4B15F7Isj3Xx/TT6ZT07kUBGJbiMVbHdD5fS+NPdtJS5CwlLAK/wXGcwNWUGry
	vp2LBvCfkiX51KF+Q+LzA7+MBSQDyyIfvA6jijav7PBs9GvdmjTBeWTYe24RtHdOkW/slcsynkh
	nIsK6YUlx4h6lfFSP/yWuGU2UigASO3puEzIQNaFU48PwBLpYM3dONcSZAnWRcgqgRz7Dxw4PkW
	hXTd2uGL/KawMRf9cBzVD4P9k2j6a23wtwUtVyc/r9bpXXc6K6r+13cua/NjdNIUrvp165HuXNe
	uFuqMykkDH4SiRrvaYXDZBjO3VDl49edrXY1v1W/ckWQIXxChPHGCOo3oAHWjlYAt9sTQiXZLxT
	MrqFrxmuJgqrtsyV66N+3LTUiJXxjO0MU2TcI=
X-Google-Smtp-Source: AGHT+IHM/YJW2qPboNwUb7KDGSWGsZmmt6gqbwAlILL0AqNuX4PEwg/PSJbXIFKwaU4zyLqhhDzUUA==
X-Received: by 2002:a05:6a00:4616:b0:77f:2dc4:4c16 with SMTP id d2e1a72fcca58-7c58e016d67mr22034173b3a.21.1764206147616;
        Wed, 26 Nov 2025 17:15:47 -0800 (PST)
Received: from Barrys-MBP.hub ([47.72.129.29])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c414c226f9sm22447356b3a.53.2025.11.26.17.15.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 26 Nov 2025 17:15:46 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: Barry Song <v-songbaohua@oppo.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Matthew Wilcox <willy@infradead.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Oven Liyang <liyangouwen1@oppo.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Robin Murphy <robin.murphy@arm.com>,
	=?UTF-8?q?Kristina=20Mart=C5=A1enko?= <kristina.martsenko@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Nam Cao <namcao@linutronix.de>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 2/2] mm/swapin: Retry swapin by VMA lock if the lock was released for I/O
Date: Thu, 27 Nov 2025 09:14:38 +0800
Message-Id: <20251127011438.6918-3-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20251127011438.6918-1-21cnbao@gmail.com>
References: <20251127011438.6918-1-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DEDEB180019
X-Rspamd-Server: rspam02
X-Stat-Signature: 4xng3dnzawry1pzwnzi753h6emh4ho9f
X-Rspam-User: 
X-HE-Tag: 1764206148-339967
X-HE-Meta: U2FsdGVkX198e3fwr/Hekeu65xwNhfBkzDiXwVgVFV6UchlDB+Fz80Sm4BsWzONuveP3ndh7GTFIvr2GMc9JhnELAJ5pf+Hqg9Iitq4tr1NpQpv99uEqu7Gs+tm7e3aSx2JRmMI4E/uLjlFWpiTIZ+m1i6lGHJAIZG4zCmamxk9u9S8ld9mKm8Cx2tRnsWCL/pacjKJMYhIbs+x3/shVehczBde+r8fItcootxaGxZKVwnbKjwO5gymStXD85QyswKRHVXPki+tgNZE1d3X0za01MVLW8MNsaGo8ZRhoEgFYYUYqPybxuD1vz0lus+LYBj2k6ZoxBvRcjDVB18JB2oywNQDBJH6rbAog6oZzDERSZId+oLObm9npmHRc2YieHPX/meRfaYs3SEY/gP/f60IrxXrXs5bwRV3J94k5LvgWj+W+vMcynSMXXlTZAXy5YeE7Ikh18M466pLupw0Oru3P+yOVgf/xd28U7jL4sheJcOgugSAjF6jN57aUhUOGn4LF9nFqifUTm0LjtLDRlZqz/zJ6qZCyiMqbeVSuN8SsqETe9+KM5dy+Mn7/xJAOPfY4qAQAqAFeLw+5KJ/JhcnygbZJl0We37mgcBwIatCtqgyVTkN05L8cGgEpyQjCgmvc1SxBadQbnXbrv0ySmbXfCjuVI6qDuelnmZpA/2RRKdNUR0atdfTkDkUqqbCX2evjpyf3lIFcVrvagKtlUTJxHZtMBMNhtZu1HXnHeAAZstd7vPAe1vaOOTeiSN7IyqUGd5Z9UIbJjY3vJ8H6Z7WaKN8cjNBYO0gPRetvMgDCYLu3pf/9bWaWbm/TlC690wayCWe/m+3rDi+71asAfZxGei2BHm7XFf6YNBgEOMozzSeZ8Kxqa0Xwyk0YE3X3MkXEOdLeMW1cf6gJ4yo9F83ERizESSbwykG/nnqG1f3RyhXzsLDhsk3heR/d8H9SDjHsNEx2upiKzYB0RHF
 5pn4bBuw
 4qkKRz9VVzQhRhazw4GzaypIaaIsPfczy2nAth5OBjd8L1SCblc9tSrgGdekqo2sqNMg7rpbkG+HpwvifetTZCbtrpU/LlW2P2lZh16eBg3bxyOSMXP+xP5H6QDBqTUUYNVEEFJE7VOqJ/ictHBQavj4G2dlaV+vuphPVFun4jFiJuBSjgbqYRDmw/KU1rfJdSjAQdSJDmeExRL4ayt/yDMNod3QJUX5X/OY74/4b5W+VzjX24xiEK0YCXdJfzMBVTpQr9hJnBX/Xz+Un4NE9eS7+zz0FJd0HSu5XXcL31HZWOkJxrLoEFUpfILYtGk+3utaR/8Jt7iJUTyC5S0qfAFw1eiuxUBuwv4Nw14UXv/Ykwalh6OpewV86gi0X5wAwvna2n4pjAdax8UAqkym1u61ecU49mZWr+YOsMsGrzImYvasHDmhNQ5S6V1wennVX3ZLsbyFiyzbya4AZzBxlSydrY5gTcswo4Y9CtmUX3J34VJjKJdvUXx723gxSsa+wWNLUIFYG3pY3v8XKXTyeZNNbyV7RM+YYRXCOCg//aX54PTF/utAUvRNIthkYH5YbvNvWRjlvMzoaB4yguGNqGzIg1NGiu73cwxiK1LM0FJYhcMB9wfIg0/FWS9KSJLjG+RWJCLm4VXLyqHvYfUjmOnqdM6inBo+3vkCYFg4fwI6rRGbrgARfA4jDaeSUNQzdFoPXbLyXn04rq0CSXmdvj7AGM15orBbp1JdgzGQreftgyCqoWm38WO665Mr+V9oX8b8tp+RMLurGPxz4S+BkPrcJ1PlXc3h1Iy4inNpOOZbhyWrOOA1z+ukkAVEkKsVbl6uVbXo6XQm4xAX76pdSajDDpRtsExDj41dHCusxIXXxe4CtlI5CKm6LtPk2z1W/leTVxkMIOJQH2jK31CCww1JmurH2utGK++bIHXUYAtWSDI9pueRrgVs07akE8dVTZllzUPuFdbWstzCLzqiIS+RQS94X
 7OVqUus3
 pa7tUIGx+qsvJKuX+dw+82+jJPxAc8tv6jaY4Ds8yiI10b3zUb/Qz0D+mHj+uLREfPCLPZiRqIQJKH2Qd1BzxpN+BvLU+tCn79/lC4/q6j0hzDqhNnj9FZ0JFJImWb7cGf40ebS5H2JPc+EmggnQvKB2SrEHdSy69EZDsqH60yA8P8abPRaBs9oy7grJqP1eSRhEtgBzn6WP7e2t16PcfMiMz3/7ibMVq1SmsBSxQdB6PVhHU/9UB81JQJa5H+v5T5XyHYy70FZszWBb3JWWeGJhKmGVEYKXcOZWINI8Vy5u+PIYD90OoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Barry Song <v-songbaohua@oppo.com>

If the current do_swap_page() took the per-VMA lock and we dropped it only
to wait for I/O completion (e.g., use folio_wait_locked()), then when
do_swap_page() is retried after the I/O completes, it should still qualify
for the per-VMA-lock path.

Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Oven Liyang <liyangouwen1@oppo.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Kristina Martšenko <kristina.martsenko@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Wentao Guan <guanwentao@uniontech.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: Nam Cao <namcao@linutronix.de>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: loongarch@lists.linux.dev
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-riscv@lists.infradead.org
Cc: linux-s390@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
---
 mm/memory.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 4f933fedd33e..7f70f0324dcf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4654,6 +4654,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	unsigned long page_idx;
 	unsigned long address;
 	pte_t *ptep;
+	bool retry_by_vma_lock = false;
 
 	if (!pte_unmap_same(vmf))
 		goto out;
@@ -4758,8 +4759,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
 	swapcache = folio;
 	ret |= folio_lock_or_retry(folio, vmf);
-	if (ret & VM_FAULT_RETRY)
+	if (ret & VM_FAULT_RETRY) {
+		if (fault_flag_allow_retry_first(vmf->flags) &&
+		    !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT) &&
+		    (vmf->flags & FAULT_FLAG_VMA_LOCK))
+			retry_by_vma_lock = true;
 		goto out_release;
+	}
 
 	page = folio_file_page(folio, swp_offset(entry));
 	/*
@@ -5044,7 +5050,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	}
 	if (si)
 		put_swap_device(si);
-	return ret;
+	return ret | (retry_by_vma_lock ? VM_FAULT_RETRY_VMA : 0);
 }
 
 static bool pte_range_none(pte_t *pte, int nr_pages)
-- 
2.39.3 (Apple Git-146)


